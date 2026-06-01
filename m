Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D631CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 23:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CB76B04CC; Mon,  1 Jun 2026 19:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01CDC6B04CD; Mon,  1 Jun 2026 19:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9BB46B04CE; Mon,  1 Jun 2026 19:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D97246B04CC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:10:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19CC61C00F7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:10:31 +0000 (UTC)
X-FDA: 84832889862.26.6FA97EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3CAC3C0014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:10:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UcuLTdYF;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780355429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmSU8+clGd9Vdr+0PQ5FxeSQ2EfOINrntLzTOj1OVhQ=;
	b=btopnolcmx2skapOfUwJzPRQWANsOiM9jW4iz1HonryCEtzDIV/lTF6ydardom0Z5l+3P/
	NnakkYtJ/xWuaZB8k6jsFZASli/JYb1mzTrEcaWUO1mhh3HPQaA+vmQy+9/LXu0AmFZ5GI
	MnvIN/4LsuIRjY2NQRNd4Ncw2B5broY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UcuLTdYF;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780355429;
	b=fhqtWWolgdnEIXj2fVoh6ODSX5Qh6ZIYgKJjKDrpncd46pHLjriDdCZMXFioztuY7rAI6x
	D7oOnSyXrYBAHsaIHteVm7yf5HzJkOCTKTcvr5Q8B6UZZxT4QHmFeN4ix6/+BCnNmUwWoO
	E+/wEy57Oq0kfiNPw1SqzjMRV19PNB4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CBA16001A;
	Mon,  1 Jun 2026 23:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1BE1F00893;
	Mon,  1 Jun 2026 23:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780355428;
	bh=jmSU8+clGd9Vdr+0PQ5FxeSQ2EfOINrntLzTOj1OVhQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UcuLTdYFJ45yGbhwq4JqV5rRBlsI2KOcUsj2hzI4QVrvlWpfknsw0mxnUG2kgHyGl
	 NKwBt+ok4mnD9QE2zdnUuN8BofrNb4vxTM73veVHbmfpu/tnvvYh3qwpGKcANbxpiY
	 ErXU92C50RKmfHmskjHokRs/Z0jxFNI5K9MXFzx4=
Date: Mon, 1 Jun 2026 16:10:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, willy@infradead.org, ryan.roberts@arm.com,
 linux-mm@kvack.org, pfalcato@suse.de, r@hev.cc, jack@suse.cz, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev, Liam R. Howlett
 <liam@infradead.org>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, npache@redhat.com,
 pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
Subject: Re: [PATCH v7 0/2] mm: improve large folio readahead for exec
 memory
Message-Id: <20260601161026.d5905786bbd3a26d62be88c3@linux-foundation.org>
In-Reply-To: <20260601102205.3985788-1-usama.arif@linux.dev>
References: <20260601102205.3985788-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3CAC3C0014
X-Stat-Signature: rymqf7mdegxaomctjajtcr81z7gkk896
X-Rspam-User: 
X-HE-Tag: 1780355429-315809
X-HE-Meta: U2FsdGVkX1+5fhLtdZAmE+VXFTiEbzF6SsoSsUoThxymNndjNUVa1curuB901FHMjgkWhWBHWTA5aUpg5yGDEg63/XQdyrZvUPC4v/tm/6GTpYttOW56WaHyR1ZyMPmO/4DnNbzVdCv5Mdp1o6TGnhElGQotWDfhcy/gAg93fPSrAFYb6WE6UY/pKvvaQcPdsdxF6dXQ7yzAKBEVRT1g9HDDTRIzMmxHP2ugN2sWUuvKC8gpUwU6Pg0iBWK9ZzARo0nzjI+97hpgHIqOA2sR8MIiX1grzDrn36cd013n4OTZ+nlcTE0K1war1Go3+uxSlwFPkNPR6m5Muh8x3IE2f5UojQdJjtA5n2Rad+ChkcCSIyr9c5hT6vRo6y3R8vzqnlfbosp4e7wDqEejmWVvZn2OXgEdrIG4g+iCHg+j76rWCVNFI/XY20hU9qphwLulV6TMqfxUzr90xwTYYfLgCkN19W4mqt5ZhZyoMrTPhgF0Vrt5YSRB7xDVuYvsUsExF0yjN8a5USq4yL8xX3oqpnl5bcusuOufvvvPKuPBqf72tT7UzC5T+2pPsiBoEPzf1FWQP1DgI6sIddEVXCazqqyvYHCiTBvV6O5y0Hs0dsjxP11xfGRiom23Jg1XvyA3J0fjkEIZx2mT2HGeLDzuCFZUCJSstzp/Qk6Dz0igct/BUFVDyA9TsSjA5TSdTpn1UrSTp8gKxuumBoPxb7LRSLuM2B0zAwlS3gT2rvVRwuLM6lJKPU54HEbkaCFZEP1g6EWrH+1QTJHO1iIEqaRerM89Tb8TKModWDvsGeFwmsNDCXIFUM/UNebP2NE7wPoWj2vDcsCbgcpZ9UKm/TNK8QrCFvjZKrynAKqeQDPr4WN5dREuKdg7omWVQ0vcwZjVQbAcUQlhKRKiO7uQJyrU8otBfPncYdsS3YgsxX6Ff+awyjzV1SB45a/q2WVUrsidoTMtn43woRc5dh9zHH5
 CwPNKzBS
 ckexPJLJ/k8a6Zy4hCyUYkVYqDZqpkDYC2W+lmQl8ZyubAnn2xY2t2BlnCGmdnif8c3XYRwlwRtxLUITVDQ5wzeomHuOtmTd2PFWJodPxHQeyq3jqHR8e3630Hdxk3YgJpfpGKpMU1WVpCryxwGw17Zk9eckk3d/d8YPqXfIDe6IzolzhPlDqJ5vRFjlpzUp7Wds+9fC5AAVBkoAMgAC1tjdWOOR7ieSFAIOqInqTjwBeoIpdVvzD8wbd3l7hySWMfhLSdFFlC2C1VCrqbaoZTAIuCs8nVINRm9QoMueKkhfqn6fR0FuHCUsDAknJj6rELLRiE02UXElhfuOGBlSiasmtN4oidhyMnW7aDqQ4kT7VQGUhnq1E2ltdbExm2UQClk8IxmVqsgkzw04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 03:21:16 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Hopefully this is the last revision. The only change from the previous
> revision is that the logic for deciding THP order was simplified and
> the max is now capped to 2M. Thanks Pedro and Jan for the suggestion
> and the dicusssion!
> 
> The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
> 512MB executable file on ext4, averaged over 3 runs:
> 
>   Phase      | Baseline     | Patched      | Improvement
>   -----------|--------------|--------------|------------------
>   Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
>   Random     | 76.0 ms      | 58.3 ms      | 23% faster
> 
> The patches are on top of mm-unstable from 28 May
> (8a74e22643189e0ae339afc91110ddb4cab1941b) which include patch [1]
> that make mmap_miss accounting symmetric for VM_SEQ_READ which was pointed
> out by sashiko in the previous revision.

We lost the [0/N] cover letter.  Please do retain (and maintain!) that
across revisions.  I used the one from the v6 patchset.

> v6 -> v7: https://lore.kernel.org/all/20260528165635.2068012-1-usama.arif@linux.dev/
> - Simplify logic and just cap the max THP order to 2M (Pedro and Jan)

Here's how v7 altered mm.git:


 mm/filemap.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/filemap.c~b
+++ a/mm/filemap.c
@@ -3320,17 +3320,12 @@ static struct file *do_sync_mmap_readahe
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
 		/*
-		 * Preserve PMD-sized readahead where it already fits in
-		 * the page cache. Otherwise cap the new fallback path at
-		 * 2MB: this is the common PMD-sized hugepage size, and it
-		 * avoids memory pressure from very large forced readahead
-		 * when mapping_max_folio_order() is high (for example,
-		 * 128MB with 64K base pages on arm64).
+		 * Cap max THP order at 2MB: this is the common PMD-sized
+		 * hugepage size, and it avoids memory pressure from very
+		 * large forced readahead when mapping_max_folio_order() is
+		 * high (for example, 128MB with 64K base pages on arm64).
 		 */
-		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
-			force_thp_readahead = true;
-			thp_order = HPAGE_PMD_ORDER;
-		} else if (mapping_large_folio_support(mapping)) {
+		if (mapping_large_folio_support(mapping)) {
 			force_thp_readahead = true;
 			thp_order = min_t(unsigned int,
 					  mapping_max_folio_order(mapping),
_


