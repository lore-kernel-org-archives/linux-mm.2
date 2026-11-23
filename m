Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF737606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dQVJfxbn
Received: by kanga.kvack.org (Postfix)
	id A94106B05B0; Mon, 23 Nov 2026 11:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B2C6B05B1; Mon, 23 Nov 2026 11:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981266B05B2; Mon, 23 Nov 2026 11:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 269326B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:24:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A097F1A090A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:01 +0000 (UTC)
X-FDA: 85466905482.02.F96F6AA
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 98C2C18000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:23:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dQVJfxbn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795451039;
	b=WcTR7N1T3Lbv3uAxEvFJfaSIfYXqgh9i6vQscUwMilq+DJUQTaO9YPqtKhybzT8Q4b7eUH
	Q90Ds5SA45lAUUJ8hSgcBVVlvAvsgHpFHt7C/UuWxz4+9uJtWE1jCY1L6Nb2YFs6br1DRE
	25HgUyFabL92QOJMPyIr41/E6eeQuZw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vsXwjKBnoZqeiXMuVVDpDy/CmbHWkBJEaAM3FjaXc2Q=;
	b=ty+tSYl4NcE96X88XRP4B/1bsM1CrubqcbR+RHkOZ8cGBFDttZOEAX48u5iq4jdhLnWim1
	dTzpNikjQzEIc0gQQs9tqJRYeVLmG3eBjx9Ak1pjLXp8M0QbmWUNO0qXq0x74NxZYlgtdE
	YC4atq32dZ0awGcVAy/sc4BNoODGO30=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dQVJfxbn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55be673e029so441591cf.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:23:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795451039; cv=none;
        d=google.com; s=arc-20260327;
        b=jabE8bsO3vY3xHAKHwRK3P0cAb278jEht9/ZdIJ4U0FQi+CjG7dktQpzoDz67Tc5cQ
         Ssy/TeYMlFjjx2ulKDS7PRR6OXMEgyBKAPWOsZKkXV6P7wwXGXoTfU0uQZOgmlmum+sC
         uHZLMVWQDErrpoqPlfTXOO7uwEEOeKHzBAiyr46q90Vp+5osN19CXNz6QEmTr51O4Fmc
         GBg/AKJlnCvRg+PrY9k74KksZdNxW8Ziw9RALgqjr/sjudCNqzuxggqe83uqq1wpW12B
         r6yO5h+0leEhalRkQSrPCyquykw9+bW3T0XmF7HhaYYA83LoKKlhb7ekHP9RqhEI7r6V
         NnPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vsXwjKBnoZqeiXMuVVDpDy/CmbHWkBJEaAM3FjaXc2Q=;
        fh=eCiSCyCEjTS+MRxznaYY0eJcUw+csBF3/fjlXvcPQuE=;
        b=lH/R1ft6j9poxM18ZocC9GCkHyI7OlG6MCl8+ezQ9EU3yfZTifKUMfORLY++zdQJna
         6mCouehOgnw0K8tZ0uMrA/gpdIwFfGdKgJdptRbqWdU0/CzFe5zDn1B9E0LJ/rvfZ24E
         5ptFAC4SVLaJmQYqV+mgX+u6Pk104ZFpUYg9XHfbADihDeRftfDzyZR29r5N78mmrAmd
         ZuYzLDd8OdkkQP21a4w+b+Ydzu+l6qVeEchvyV0blQe8FqIpaEYlnf++mLShlFYGYgbF
         5kRklsfekL9pa+zV+aOgqCJtgzS3Jw3C+k9wLdi9LjmZf3VmTIXGwrpH2LFWVwsLNXix
         foZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795451039; x=1796055839; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vsXwjKBnoZqeiXMuVVDpDy/CmbHWkBJEaAM3FjaXc2Q=;
        b=dQVJfxbnzvXl4cBXRYM7fXdGZCWJqwL1m6VdkoWlLWYHnnE2IlG7MIW5VmJwlUKoCd
         hMvsVUC40o0Ukgmn7bj9ULJB3lMwoh1fLFQwsPq03HHhLVaCaYb4CeGpstof5j8k3xLS
         SWM+P1Nia3ev+QJLSsdP4HQmYjjw2RPK56Dm+bho/QdfjRj3eR+T2SOfHwiEdllLY67D
         X1tMd9w+1QzuWusbm47RzFaClkrtK9ieJlVIDuwHVT81cYrx8uTa4oAOY86rZt5Cxc93
         ZSDVdFOQpudBbsiiw9KqiriHw6ZxgqA61FHkB3zh122A8/4B22vt7XjJB+vmrTo6fQKa
         IsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795451039; x=1796055839;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vsXwjKBnoZqeiXMuVVDpDy/CmbHWkBJEaAM3FjaXc2Q=;
        b=epaocmx3iUkrjLZbuE97J2eMLuxqcpEI5bVj6ERZVVkm6GpM50MWbVBvurEAKCPiWm
         jOVHu0///ifsEjKWJxWhczfpnbYzB5V4sjVYpZ0iMqy0QAcr5+eaiG+i5/LdXltUW9fN
         WNM/LMh6C8j+rmLXY58GeR8vD9xQSxB1KFPG84SlhODdM9ffr1CnvrhN1KlPd9Gw/duk
         psvwRzafadDuXnC2FRa3uEzBzVAD0WZ+cPINdaCxUwytI2bwJtfsxLw1OjEq0w9Mism7
         CDVgR+cDlZQtzgxtaacYARTMJLP74Y8x6AcUnR78JaqASrY6Eoed+ywlBPQiUCiAwTho
         HPPQ==
X-Forwarded-Encrypted: i=1; AL+hErGQw4jdmi4iiA3KUGs5nqkOucFVMvb/aefN71D7yelC4vy9HXNDbc02wwajNBlDmpiURZfEPacGPw==@kvack.org
X-Gm-Message-State: APuU4Z+aaQ1+PYXrQ1BKj/MPDFJ++QpQj1gDCbWA55FVhQKaF1mkSG9X
	LYCy8dioRKDvTLLtMZg5kNCt8L9jYwRAIU+uTiVqkrcyL+j6To9gVBy8oO/X5KICVl+bMvkFoKM
	q4n2BtS66rPZtYcUHzoXg9aty+gpUUrL6DL7nvEDx
X-Gm-Gg: AZFdTZfemiJAzYh2YFtue1/OghKvHYx3+c+2XUL9YEKaLEncA+xuizVNvlI65Z7GiY/
	HiFNKTw6TIGk9vXoHMdinA4R7mnEXlxxeHgts177EBBM/q7SjCyNEqAWDYx+UkwwmyO0dCc6YCS
	EMRXiDaaB3Vu+8ocBi3casnKieCIKK8gh51LUkaxlvkgdFskRLdzJNYCA30XjtJDNUHRS8L3xZ0
	7a1Gvk8hsOGyvhHxpkLlUEG3DJdkXbdx2UwcL/U3yXhMVKNjyYnoypkBq6SomuNU/jRrOChQLID
	p4SrLy30Diwuf6if2jVyVeoKaMJTKDgbBlzEN065nKpICgkkH/hIkpBm7eNulSIbLr4GLKKpLyO
	d0MY7TM8eFebCWvpczlPzQGXxjP81JerJFaDnvAr+YTcqoVMd+PbOdGhvPCTsjKAS41Iav3t3SE
	WVTpdiTsOlIne3IGKy
X-Received: by 2002:ac8:5cd5:0:b0:55b:d494:187f with SMTP id
 d75a77b69052e-55d881708admr36121241cf.5.1795451037939; Mon, 23 Nov 2026
 08:23:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261123-fix-rmap-lock-ordering-vma-locks-v2-1-11b04646abe4@kernel.org>
In-Reply-To: <20261123-fix-rmap-lock-ordering-vma-locks-v2-1-11b04646abe4@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Nov 2026 08:23:46 -0800
X-Gm-Features: Aa3M54r8I6SgrrT7SXUxZTPDg2iuNTzqihC88BGRoF_BhP_IlsfH8qQxtpUWWUs
Message-ID: <CAJuCfpFzd4kKcyUVewacpt-jxPn9tfwWzf=NdDVvaeV_AZckEg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/rmap: correct VMA write lock position in lock ordering
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 98C2C18000A
X-Stat-Signature: ggexp7dptbmqmziwhbqibkofahtj9yur
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795451039-161961
X-HE-Meta: U2FsdGVkX18CxsyLaDUwadkYgfUQCtUlt7CovKzX2YYrZLF1C2a26evFbME3ufMKMPDQ9wc/xP+yZZNbbP8dq0igGUaTp77VGo7D2VluQG5JimfI9mknpIvg1jnrrLADeH4E+qZNKw7O/fxQyoYJXYdkctQXwg41E0+RJVmYrurHnB+02rfGc2lLpkqrzWEQGM/QHGK8xv3/rqtyUdcb1hnVLgNYqXU/AOe1Q5gBtBKTZHXUUb9yYNIzMnZmBrIxlQ+9gGIyX/Se3Xn2H5JtwrW/9qGWPR1FiorPtuTujkxPHZXCtNH8cL5XV7yuhLoxuFJHYjl0pKVWg1U7stgt5ThSPgk5YrBSt1Jb5WIWcNYtXYpRINOXlYemDhFc8wqqda4s1vI9HOjYubi7raPereVQGovnNz/RnLOW4+rCMLdUYBvrxG1R5xbYWmzmzaU3M1cT/5M/h0D/kVbcyAlLEejtUjO07JeSZaoHh6Jxt4ZgEgWrIkFrK/6yVcuRxydL36g23832tGn8y3vuf1jNgdWr7bNaQ5GE1j9YaKypG+ig4ZYqWrThG2VDSar63i2V4q+toBt0ilB8YBZHOtcjrmbOxIFjfikBGJz8XP4P5d/exSOW8X2SINHeOJ0N9/ywJ2gp+K6iFDoQ8lb4a8NnI2L7XIJuZtDgC9Zrnr9xYF5RSf1A2NaLF2f90tpdx82kzWY2eLM6zzMQ8tzBHdDb+n1y6+3zXNfE+n7DQPVU5tgw5sF3f7oJgYFc5WBahXtdHzDGNn+LoPHYQ+ISEvJHySOzMkyOU3ZbiLJmMeIQpdBYhU5Fzhx8+hdRuxaY+aR2npr4g2a8dPZV7wREVKKNm5QYWPWcjRXu5ux30omGlpWbvlo7e0vhTZKoNKyO4GLng4VfZg4sGexTYG+/BORBMUC/n4bVDhheWX4MLTNEaxjLZg4oFLLVDEjbx2npCDgKe+vzjbPaCI7Ws0XG7ns
 J/seLh7C
 9B/l+HkcteOi8Idiw5262phDrCs2DICn6FH4MObTmk0P7IkWJbR7DLm/4cqDDTETdaRBOgOs/OB/OPecPaE/Gd1CyjxteLHpSn+piICv87XR8J7XHjQGWCGTyw9tRABP3ERD47vWz6AXEJJUHfhH0p6OUa4/XscLHP56wdxp/xH2lBnMRSeKYlw4Gu4oAGZ+0eOyzUjOZEfJNtVQq5MLyoHlRsR0xmNdfFqlEPiqwgn1s2B2KL+ep2hhV78NoVTPNU9b4791cEdkaqtnNER117CKcKltiu38mibYhDikDRdn7DOCZcoQOYN64kMc7LFw0+Hl4vSRZ9+iiTx3ewPlBQtKV6dZb2IJt+cvczmFa/I4xIzASjo36w9ol0AkSf74kCR50I4ji25l2o79x4gGiKPyU20DOqFxicpGFvUR2WsAV5qNvWFAOVykkZaB9AAlxxSI8LEZBtravc7+ZtpNqneT7tYrgp/vAAkTNQuMbY5/oQQ0jKnNcP8K+vZPKmo7sRMSD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 8:10=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The list at the top of mm/rmap.c is taken to be the canonical order in
> which locks must be taken in mm to avoid lock inversion.
>
> However, VMA write locks appear to be misplaced. These were added there b=
y
> commit 55fd6fccad31 ("mm/khugepaged: write-lock VMA while collapsing a hu=
ge
> page"), which was focused on expressing the dependency of locks after VMA
> locks in the ordering on them, disregarding those prior to it.
>
> Of course, a VMA write lock requires an mmap write lock to be held, so th=
is
> leaves three locks to consider:
>
> mapping->invalidate_lock (in filemap_fault)
> folio_lock
> hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
>
> Each of these locks is either downstream of a VMA, or is not able to
> acquire a VMA lock at all (e.g. in an rmap operation).
>
> This is because accessing a VMA's file (thus mapping), traversing page
> tables to a folio, or interacting with hugetlbfs requires the VMA to be
> stabilised in the first instance.
>
> Nothing in the kernel takes any of these 3 locks before a VMA lock, and
> indeed in each case that a VMA lock is taken it is taken before - so the
> kernel is already violating the ordering as-written.
>
> So fix it. Also add [_killable] to reflect the existence of
> vma_start_write_killable().
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
> v2:
> * Updated docs to reflect change as per Suren.
>
> v1:
> https://lore.kernel.org/r/20261121-fix-rmap-lock-ordering-vma-locks-v1-1-=
952c0dd5bc3a@kernel.org
> ---
>  Documentation/mm/process_addrs.rst | 8 ++++----
>  mm/rmap.c                          | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/proces=
s_addrs.rst
> index 04b649818cc1..40be3a46a521 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -418,10 +418,10 @@ ordering of locks within memory management code:
>
>    inode->i_rwsem        (while writing or truncating, not reading or fau=
lting)
>      mm->mmap_lock
> -      mapping->invalidate_lock (in filemap_fault)
> -        folio_lock
> -          hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs b=
elow)
> -            vma_start_write
> +      vma_start_write[_killable]
> +        mapping->invalidate_lock (in filemap_fault)
> +          folio_lock
> +            hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs=
 below)
>                mapping->i_mmap_rwsem
>                  anon_vma->rwsem
>                    mm->page_table_lock or pte_lock
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 65646ed6fc45..55367e7d3eec 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -22,10 +22,10 @@
>   *
>   * inode->i_rwsem      (while writing or truncating, not reading or faul=
ting)
>   *   mm->mmap_lock
> - *     mapping->invalidate_lock (in filemap_fault)
> - *       folio_lock
> - *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs =
below)
> - *           vma_start_write
> + *     vma_start_write[_killable]
> + *       mapping->invalidate_lock (in filemap_fault)
> + *         folio_lock
> + *           hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbf=
s below)
>   *             mapping->i_mmap_rwsem
>   *               anon_vma->rwsem
>   *                 mm->page_table_lock or pte_lock
>
> ---
> base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
> change-id: 20261121-fix-rmap-lock-ordering-vma-locks-62593469bf59
>
> Cheers,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

