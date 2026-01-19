Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9DFD2ECF4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 22:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7012E6B02D7; Mon, 19 Jan 2026 17:22:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8F16B02E9; Mon, 19 Jan 2026 17:22:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5F06B02FB; Mon, 19 Jan 2026 17:22:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DEF96B02D7
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 17:22:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2D971602B2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:22:20 +0000 (UTC)
X-FDA: 84350138040.06.BF99CDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A698814000F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:22:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NyDwwFuy;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768861338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTc9X387fVd0+pI9KgornW7pZFZxfDT8ej9fI2UPs1s=;
	b=wAM+MM44er8HLE0uWnZqOWPEXIBGsvTFJ7xWg6amG1E8mxgRdWgaeEHR+a0IA9lm4yiqBx
	h5/v5gcHQ2lmPI5ZsT7Ot7s8U49DHGs67PgT+HLfOxFZDDMuM2ZQw/u8X8RGmrSE/BRXEm
	llCcVaNXvJumj5Gib2Ar9P70wW54YQY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NyDwwFuy;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768861338; a=rsa-sha256;
	cv=none;
	b=tYvroIdL7HF60P2JbTJ0OMx1dBpyBL2d53zOYtHeoDX1pFlSaJ2I3FO/na5AIAbvL64pcB
	iYunNw9eZ7MdIjbnkmuFSjIa41xO1uBmMe5VezoNrBIS5hRniDxCfJZkQUJ4K8fdlJVFsm
	y/iO4O/nNCqwOmyQR3SziVG9c2q52h0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A13CB6014A;
	Mon, 19 Jan 2026 22:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D88FC116C6;
	Mon, 19 Jan 2026 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768861337;
	bh=PSAX+ibtrxSZ0sZ9PO1JFriJ7cqe4buDvYhzubMRIgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NyDwwFuyD3RiW+jvlXOeCC8Y931wHEnIExpF99aiyYqCL/dFYBR0eXuM1hgSVC8ZX
	 dV7Ci7euBrjp8mM58FN81Ju81Fdby/UqtW7bsSr+wSuChvelcSkcpzm3Askr5Ji+8b
	 zTGqcx6ojNzjZWvZkeFrthAhbbOqQVCgTKFin0OIW82NsY+2rIJttSWW25MavsR1Ar
	 nEEVlzo7uw1QEKLA/BTg0pMF91wUNDoOki1EZoyW+wzHSv2jPML2uQxgOcIbHyzb92
	 g5LBoPU5xe2ff2Y8JGdoMv9ujG7qMWHb7+mHX4Dqx1u2SdCUxIiFJRT79qP7DHdo44
	 7u8us4s0Tkwkw==
Message-ID: <ca9e4ebb-e6b5-475b-8a21-a261e27c3ca7@kernel.org>
Date: Mon, 19 Jan 2026 23:22:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/23] mm/balloon_compaction: centralize basic page
 migration handling
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-5-david@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115092015.3928975-5-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ofaq9xrqisfbhnu195bw5sp7f98btpkz
X-Rspamd-Queue-Id: A698814000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768861338-411796
X-HE-Meta: U2FsdGVkX19y8DcJTLFMp6XQk06vHa4lnXjgtX5lwYcyDCH2fSNAsUJGlO9hY9YvgexhYB/8ZCm2Yuj1RurD0KEG0NGfzicXen/PtMgIp8ChuAvm6FjImGMXCbJ4Ltzgds9gXXMnN1k94FLdPuxz9T0+TNGgMHO5vPkwo/2bRdDmBwCO7aHMxgSlqUOv1BS29KBfni1N+/3MWlos/HMQfW0X29f68PohnC5n8ar9KbexRP2YPPf6qCGDvWcvfkG+QfSYY3nIQRn5vWwh3mHLE/7dS1QKSiCf8dbj+MvFxrqeSJrt8dBBgFccuxMSvkUJzBPIVYJYUDQpcx2oVQmgGHTeRIRkA4D4NqbGiXbNMNSowwzluRmAbZAo9eOIN0Lb/7TwQ4PO2eN+k7MM6LHVKfiReu035rLi6o9wL8s5jPSOHPPC0YTCyic69LKqgfIjFfa+TCWrG06znhw/p21i0ZUvaT/1GxWI6Itzw2RS7YpkojchLtl2tYgaLTxncXT9/gzWZokxXcf5C8qGeXDunlHwqgRYDDx1vDm7z920t8Sx1BJIIt/8kYSB+4Ds4XgJxPz40ZAtPtTBzmdsUxXCm2k2YqljrDjluGDaQu+dAxzeNKodMLKmIuVSZEZB/uhFzoowwIp/rLnyXFPQ6SnUpU2+A8++5nP8cWTZwQ3+PnnCfVqs0cBVETjWa+fLI6Kdq9M7PvTAVYfHffZR4p4Qe0CfmoBK6gxHazJ4meEAVyFVH+9hDSefVdSvdmwwsOEPUxJF3cAIp/KPioVuX/Iu7HlkB0JKNWzPmITQIl+qm5To3YClZ3dSosNgov5JNBAT5VmtdS19IiC7e7JGpOkAMXXpmNGg+e7pBB3NWmH6dE1st+akwxoTOg29skoVNd23oBM55NHfNssHwPFB1FRztxotAlKcLRmR35vaR6Hjx/qk1RSMKcY3HFqowgpwYolvnf4NYhbMWZiDUxmw4+W
 Hh4Zgh1Y
 Yv6o1v1IUvtr+4X9TEtbh0jQw/j/RlBvFFoIKYPvYcvOlWIL+y9dJHFjCNm7IN1OeP6KezkZmQ2DA35LQO/ls25TTOvJtxxvPqJlvw118X/pv/LK/L0fWbMklxmm231UGBFhw4N59S/X0b6k9JH9Fokc2cynxbP/s80scGbFZc+rSncngvc9HTBQvmOrTJ2LI8Hqf0ad6YjwNUCIaoeewRRW5p3g31eM6eRtDe8kM04WwbbagfJUlCMQER1ouWbBl4v0iyiE+id1FNBBtUAxZt0FW2+xq/zbP8eGv7xzvSxTIDJeGUnU2V1iicg44P0JhMuQy63/eUIi275DcfGZ27poKxX//Ib/y/fj4+O3fp4LsG64=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 10:19, David Hildenbrand (Red Hat) wrote:
> Let's update the balloon page references, the balloon page list, the
> BALLOON_MIGRATE counter and the isolated-pages counter in
> balloon_page_migrate(), after letting the balloon->migratepage()
> callback deal with the actual inflation+deflation.
> 
> Note that we now perform the balloon list modifications outside of any
> implementation-specific locks: which is fine, there is nothing special
> about these page actions that the lock would be protecting.
> 
> The old page is already no longer in the list (isolated) and the new page
> is not yet in the list.
> 
> Let's use -ENOENT to communicate the special "inflation of new page
> failed after already deflating the old page" to balloon_page_migrate() so
> it can handle it accordingly.
> 
> While at it, rename balloon->b_dev_info to make it match the other
> functions. Also, drop the comment above balloon_page_migrate(), which
> seems unnecessary.
> 
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---

Andrew, the following on top:

 From 4c8b4f0aba5859a4ec71c7449a98b10e0547237f Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Date: Mon, 19 Jan 2026 23:20:41 +0100
Subject: [PATCH] fixup: mm/balloon_compaction: centralize basic page migration
  handling

Remove newline, talk about "page" instead of "old page" and avoid the
switch.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
  mm/balloon_compaction.c | 22 +++++++---------------
  1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 5444c61bb9e76..b859411811d0b 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -247,29 +247,21 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
  		return -EAGAIN;
  
  	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
-	switch (rc) {
-	case 0:
-		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	if (rc < 0 && rc != -ENOENT)
+		return rc;
  
+	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	if (!rc) {
  		/* Insert the new page into the balloon list. */
  		get_page(newpage);
-
  		balloon_page_insert(b_dev_info, newpage);
-		__count_vm_event(BALLOON_MIGRATE);
-		break;
-	case -ENOENT:
-		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
-
-		/* Old page was deflated but new page not inflated. */
-		__count_vm_event(BALLOON_DEFLATE);
-		break;
-	default:
-		return rc;
  	}
-
  	b_dev_info->isolated_pages--;
  	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
  
+	/* If -ENOENT, page was deflated but new page not inflated. */
+	__count_vm_event(rc ? BALLOON_DEFLATE : BALLOON_MIGRATE);
+
  	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
  	balloon_page_finalize(page);
  	put_page(page);
-- 
2.52.0


-- 
Cheers

David

