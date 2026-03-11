Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D081125868
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCD06B0005; Wed, 11 Mar 2026 14:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A5A6B0089; Wed, 11 Mar 2026 14:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8868F6B008A; Wed, 11 Mar 2026 14:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 759576B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:49:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B1A31403A2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:49:15 +0000 (UTC)
X-FDA: 84534669870.06.42DC6BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E83C8000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:49:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JgEdtbB2;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773254953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BY0FMQVFhHJxY5PSlqRNAZr+kG7EJORMbhFJkh2sEa4=;
	b=VsbP6oefGcCU0va+fbOqbkekwyCmOCkqGrp0U7P4CEJJFH09qgjGHA4ULZ5y6Yk19f+GiY
	lj+m9HzDjwm7m0kPbX7Qz8h48WMTd6EpBsO/8AfeZjopr9erRxSrkxR7Bcgt2TbXJWLtKG
	OKM4xKdEPWU1UyZmSsnriKI3eyI2VV8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JgEdtbB2;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773254953; a=rsa-sha256;
	cv=none;
	b=pU09LM6zLC0H3AEPQEm/ntW6m3FUl0RM57eces5jCtAOJ8L46t0w5VitBfJs8H4wrfKVHD
	VpqxwkUlg0Z3HcI10HP0+eLsWCOShthR7pmTcPfEvRNDsbl7yq8af93gzlq9tyoMWm2RIl
	4fUI4MlvtCICMer2K5+qEpHSrObWOek=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECD0A41922;
	Wed, 11 Mar 2026 18:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BED4C19425;
	Wed, 11 Mar 2026 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773254951;
	bh=V6cFeRkZqby++mC9llt12uQIBRckotBb4PevLS2Zh7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JgEdtbB2552lw+CZNF+iT4qjBWPNoUdaJrGRaWJeqan1Mdfi5a9y3+1uJSR/wv32s
	 QX4boMvXHOGzj77PQo1BGxHTnoQO0v/eCIx/awqOamXHSnQ99EQsHhBPgznbBS0lWi
	 mCrjHiikGeOlJUuB75XBJmwWEMFGMt9uY1e77zsOHq+K45kQ56DZ7NqDw8GFvVZkL1
	 DYO4WEaT0z6xMrEYBaptEqaIKq/SgXAXI1elpkm3mhjePR1FtlZ+1sJYrAr0FYZ5nl
	 x92uuR21FLfkhDt1132NzhtHFAe4pC6zGlSi1bT1bhetb8YrwM5mbjw20h3PWQcnig
	 aOoRuubqwjihw==
Date: Wed, 11 Mar 2026 20:49:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 07/15] userfaultfd: introduce vm_uffd_ops
Message-ID: <abG5HFV8yoEHOFkh@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-8-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306171815.3160826-8-rppt@kernel.org>
X-Rspamd-Queue-Id: 5E83C8000F
X-Rspamd-Server: rspam07
X-Stat-Signature: jm7c1xd866wjdu9nccwsecc9zmxhbmeo
X-Rspam-User: 
X-HE-Tag: 1773254953-864494
X-HE-Meta: U2FsdGVkX1/2FMP4wxUQNMzxkiHR95xCK8bAcjFRKESypVPHN5bX7iC0I90G/r7i897D8aLvMxXdChLdqVrgZQFmi7Zh9hB/xfgOL8bfnzpV4VUQ/uSy0Efv/FK6YijDOzsN66EY7i7Z0WwDiwaY8r+i+wDudafEUQq53LDk+zNmx+5ScRjx3tVLwoHwQ6fYoV+H2080rJkC2uEYd2TaovrVfCbTnWKwMDy1Ye2XnJWprM9qi3pEJ3TBNvQ7rbaWwvr9PxewCWkiQPTM8QE6rpHvYF/vv39KhZAm94asn+6UqLj1YEDdqDwAXDYGXwEV88ymKBZzG0rK2ablNE1j5/VBXO36LXXwO3lnKFK96BXaO/9C45aNK3Y87MfrOAPgh8KlK160ckotVbB6YVHlI7VOFW4i+NhMuMp4CbVTSOhrJbxERj1ZTsxSQ0XCUNfs8wlxyCaEYahnRbpx8VH9TOFFHNBVmiETLwPIQR96W9e+UsswQ4trxWVUjQAOenwZoTkGostoq3T62shnRXlnpE6QYQQ2cWGkpwTrBos87iiQhCmzeJ16UwENc/x3d9ERDNdjd6dNhp2PIOFashqzguH7TwIrj5xl0CQ2sx2IX07bo4+K2srV6gRPPqJ9A7m8dh2M6b8f5J7vpdPNuruHvu+1l8zyuDT2Fwz8r9uJ1cQlUym4TvRm4MTB5dCKyAMyelJWGSyLciWKeQqPTV6Wx1I4cU0J/Bu9LaSnKlN3DJu5diwxKMBaPfODl9wAK4FktrXWF0IzzNpY29Uxsv2KgnWp/E5Mfg3l9BENO22v95oeqiTx0HuNvQUlfLjmvex2B+mKJKj5HaptkN9f7aaNItrGGhWLF6tVzn3+xDf28V9/M8M8TDCr/4ugktrz8cbk6DDRZwvH7Yri5JWldGta8PJjdpJ4nFgvaO/76X6uGew3Q5Hnj8PJuKo6Pz5MalKfQlvci9qciJSCtz8x+jI
 qabC1CCh
 HK5R5lEHYGd/YGUxSk5ea4cmc/d3+EN15uL25C/qj9CpesHZodbzQqHq8JOUC2tY8gJLb7vJk59JW3QlCAl1DJysSP8O6h/RVAzi2+EhcYuQ1OIY1KErkf4CffVrjV3/SqBEYptk27CIVEBLAj6/jwDKEnKXo8chYWS3yWx6GkOh5wvWsXJYn7LiHB7JECIlABHmtpcKCsHXnQAY+swi/pkvDWlkdemHUBb/mC/F3PnweF0Muvj7Ah3Hvn7PnExboe8bkZnzYTd3lGO5z9sQOLNX1gnw0BBj7v3FkLHzuK02HWItxQ10p1kyIml1HKD5koKYdHtPJf1Trim4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 07:18:07PM +0200, Mike Rapoport wrote:
>  bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  		       bool wp_async)
>  {
> -	vm_flags &= __VM_UFFD_FLAGS;
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>  
> -	if (vma->vm_flags & VM_DROPPABLE)
> +	/* only VMAs that implement vm_uffd_ops are supported */
> +	if (!ops)
>  		return false;

Just found out that rejecting a VMA that does not have uffd_ops but was
registered in WP-only mode with WP_ASYNC uffd context breaks
pagemap_ioctl() test and more broadly it breaks tracking of writes in SysV
shared memory areas.

This is weird that it's possible to use uffd with SysV SHM, but it's out
there for some time and I afraid we can't change that :/

Andrew, can you apply this as a fixup please

From 6e3319ceab93d84558e735e1f4f451e80c85b267 Mon Sep 17 00:00:00 2001
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 11 Mar 2026 20:21:38 +0200
Subject: [PATCH 1/1] userfaultfd: allow registration of WP_ASYNC for any VMA

Registration of a VMA with WP_ASYNC userfaulfd context in write-protect
mode does not require any VMA-specific resolution of user faults and
these faults are completely handled by the generic page fault handler.

This functionality existed since the introduction of WP_ASYNC mode and
it allows tracking writes to SysV shared memory mappings (shmget(2) and
shmat(2)).

Move the check for WP mode before checking for presence of ->uffd_ops in a
VMA to restore the original behaviour.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index b55d4a8d88cc..436795bf218e 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2044,22 +2044,22 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	/* only VMAs that implement vm_uffd_ops are supported */
-	if (!ops)
-		return false;
-
 	vm_flags &= __VM_UFFD_FLAGS;
 
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
 	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * If WP is the only mode enabled and context is wp async, allow any
 	 * memory type.
 	 */
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
+	/* For any other mode reject VMAs that don't implement vm_uffd_ops */
+	if (!ops)
+		return false;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then only anonymous memory is supported
-- 
2.51.0


