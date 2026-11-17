Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76825606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P1mGiwCF
Received: by kanga.kvack.org (Postfix)
	id 9991E6B00EF; Tue, 17 Nov 2026 14:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948786B05B0; Tue, 17 Nov 2026 14:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838786B05B1; Tue, 17 Nov 2026 14:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65D906B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:52:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 468931C39CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:52:38 +0000 (UTC)
X-FDA: 85445658396.08.7191B43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9B0FB18000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:52:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P1mGiwCF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794945156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nq24JFvtPeVmX5op9gSmyrNH0NFQEiXDbSwSG7EFOzI=;
	b=8N6xHLkVWTMYz8xJ3PE8lJJJkl3lVNsWODm10LSUnSZvBeEXAn8PqCbrgE9GhF5L4N6JuI
	t0gmRyjMxJiqvZPh0t7OW5rvBXg6BHBD44AfQK+eB+kjIeqEVIVXZL/m2xYz0UsCbvBiXe
	0nMlQ/jYzNtTno1pO7vAcsM1eKcx9Tk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P1mGiwCF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794945156;
	b=1S7N28d0Ovmehj6ClISZmBKj/WwJiNMurjRZajBRgIpXG1gw+5wGDzzg7mUTEv4/NvDK+2
	5KaRjZ/1FTAitHXQuG2KqcKvhtqdVJMeuGXwCvF3AVJpoWJ9tLq45qPX6UpXMW9spsu7E5
	yFxYxV5RF4z93tOYsS7lov843IuK8/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DCCF601D4;
	Tue, 17 Nov 2026 19:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97421F000C4;
	Tue, 17 Nov 2026 19:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794945155;
	bh=nq24JFvtPeVmX5op9gSmyrNH0NFQEiXDbSwSG7EFOzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1mGiwCFKV4d+Fw4XIhqwyyL1Q5kkP1ZUd81/LGZyhXqvECuA4m9WMGWDnjQiN5ZH
	 czw4TxxrdYKdaE2EUxve7KTWze3y/6vyhOYk9tmRA0Wc2j+HxlsFJqEsq0IYTvXRFO
	 Kb7D0C0H2AljIoxwufbKo2L4ZLzhmBCaHRveSO+86FggcbVnR45ZoUm5isDi3EL8kE
	 DxfDXsJEaLpH1LZzB5RYQk8gnJ4LGZTfopSeR1E2ds+eHtVNW0IextsRV9ngORXWYd
	 ShA/lCouuq2O9pYU3LTb5h+/CNegq/07vD65wX9RAFmjuyZN5uhpSpoWfCrcThIQNI
	 4hXmKKcyDvRDw==
From: Mike Rapoport <rppt@kernel.org>
To: nakixii <nakixii@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: check exclusivity of the page being moved
Date: Tue, 17 Nov 2026 21:52:27 +0200
Message-ID: <20261117195228.2675563-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261117191853.1314834-1-nakixii@gmail.com>
References: <20261117191853.1314834-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5g8cti68y54yygw33zzgxrb3fkgna5or
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B0FB18000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794945156-49751
X-HE-Meta: U2FsdGVkX1+rlMeVZuunjzqeFZCxB1WE7hzynvFEfdfhuMSGm6RMktRQ95tVoavpx896ZCldaY+0Pp41w7MKuk0bf9zjWCQhcte1es/kF7ZeJHjLKSFWSN2s5cXQ9YmtHuPftJsgCwtFSaWQSEHaM3+U28+wGG/k5hWJ8O9slm/gROfebMYlV+7tQqlfXFPuqdwG4pIZUrkJRNqXAK7qvGBeRiqrvKeuQu6sxg3AckUBHpYxQgREZjYRvLc+WEF3Xu9GYZRr9rzu3Q6rNDH6T73kdFrEiTi1MB2smW+TL3iO2g10AbQBBc6qsHLVYjY1K/8jySVSC7iAe0qMOclofYZcnZN08rmdryDYmNcHYN9P6mldwZOeqq+nyeqd2DgXbG1lY8xs5W4kf87rXOqI3AH+4fLbw2XVwYVxXQvdHwE1CdarLOmFtVUA6FNDxvWIvbQAqMaeDqNFNkq77olyANqIL8eZQTux/Ocrs7OaHUfn7Qz6ExsDUvoPaX1PfvwM6XCMnBRgDeEzx+xlLLHHmyz1u7Tn1P2IFTviZp6ut26JYFtvj2Os95874dcT3jHd5QtjmXdApSLwQGj1OCdAEaGjk71apInst2NORZLCD9JwpbGlGD95ns2H+L6TQ6FRx8On+98siqZ/3RwuUlAxxVqROk6B0fenUYad0QOj6dUpfCr4Oli35XDK+fRqB9SOOITeGlecH4QaoPemN2yDiPL7wFJu1ZCfyAxnVpjiSV5D1oKwIdRiXvgBIAK0XArdDbmaqvcQSG3c1JvN9kobWEeygew7VMwPKDBP6pNXLdwe5vaGfJXIwC/Sz0SBRpOFSe7fZiRx0y/iGEGGYmqBWxhCLFcn7LD/kr4Apr2ctjMAVMwhOTNENCBw8wga61Nf5NMZ1Meu5P8XQvUVVgemZSiU/2OpFMsWid49LDcx2sBnjosc3e5sBMBdbBO+5/zVk3Cw9UCunQYEYed3d2+
 FVh2IpFQ
 pXrMDbvVjofa1UI4xHpGHB7+04h57xl3swEL95Sb0VBmpWms0hBjSAlDQx1qsPkHjFQF6mHCYAalypq/Hw8e0mlAaoexIUcRyBCR/pw+NY8Cqi7v05P4oTWNTNQliWqr4jsQLFr+skZHN6t6hqw51a1tEv4lw1cxmT1kv1/gP/47SpmIKJvuo9au/fVCwbqug3RXzPvrsC7izBJkYiWPTqv2LTUylWcR+cDVnPIg2KgtEJX3eVPySk3WT3XJQTCziaXNy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 03:18:53AM +0800, nakixii wrote:
> move_pages_ptes() gets the folio of a present source PTE and then checks
> PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
> is per page, so for a PTE-mapped large folio this can give the wrong
> answer for the page that is actually being moved.
> 
> This happens after fork().  fork() clears the flag on every page of the
> folio.  Once the child exits, a write fault in the parent can reuse the
> large folio, and do_wp_page() sets the flag again only on the faulting
> page.

COW reuse of PTE-mapped large folios only appeared with commit
1da190f4d0a6 ("mm: Copy-on-Write (COW) reuse support for PTE-mapped
THP"), so this scenario didn't exist when UFFDIO_MOVE was added.

> Reclaim can leave the same state behind when try_to_unmap()
> replaces the earlier pages with swap entries and then fails on a later
> one.

This one, and fork() with a single page of a PTE-mapped large folio
pinned, could produce a mix of exclusive and shared pages in a folio
before that, so the Fixes tag is right, but please make it clear in the
changelog that the fork() + reuse case is a later addition.

> Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though
> the folio could be split and the page moved.  Callers that fall back to
> UFFDIO_COPY on -EBUSY end up copying instead.

It also works the other way around: if the first page is exclusive and
the page being moved is not, we needlessly split the folio before the
retry notices the page is shared and returns -EBUSY.

Worth mentioning that as well.

...

> Signed-off-by: nakixii <nakixii@gmail.com>

Please use a known identity in Signed-off-by rather than a nickname, see
"Developer's Certificate of Origin" in
Documentation/process/submitting-patches.rst.

...

> -			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
> -			if (!folio || !PageAnonExclusive(&folio->page)) {
> +			/*
> +			 * PG_anon_exclusive is per page. The first page of a
> +			 * large folio can be shared while the page mapped here
> +			 * is still exclusive, so check the page being moved.
> +			 */
> +			page = vm_normal_page(src_vma, src_addr, orig_src_pte);
> +			folio = page ? page_folio(page) : NULL;
> +			if (!folio || !PageAnonExclusive(page)) {

This would be simpler as

			page = vm_normal_page(src_vma, src_addr, orig_src_pte);
			if (!page || !PageAnonExclusive(page)) {
				spin_unlock(src_ptl);
				ret = -EBUSY;
				goto out;
			}

			folio = page_folio(page);

>  				spin_unlock(src_ptl);
>  				ret = -EBUSY;
>  				goto out;

With that addressed

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

