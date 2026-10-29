Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B31D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 08:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGmzUw0h
Received: by kanga.kvack.org (Postfix)
	id 384706B05B1; Thu, 29 Oct 2026 04:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3345B6B05B2; Thu, 29 Oct 2026 04:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2234A6B05B3; Thu, 29 Oct 2026 04:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06BE26B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:07:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 614B51202DF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:07:48 +0000 (UTC)
X-FDA: 85374935016.30.128CC31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B43C1100008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:07:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGmzUw0h;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793261266;
	b=aNhmLs8v37c4Y4kuOLLVRAgfhnV11yUn4/BneExrMmYUAxJuQbPFIOQ9SJYc7n65MqD8oy
	XQ9LVRjYNcK9Kj/zdF9MHaApVLRQ/4yw80fkPHQfANs5stc/GJhBAW/NQ0xYNFY5b1Ylbz
	W4hx3LsbMHjaGw0Hr4V4C4xQmJN4Txg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGmzUw0h;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793261266;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/5uRqJy/VgEhejne3xSc6gn5mfLQb/Op0B9UDn9Dv4=;
	b=1fsIUCrrwfEmejzBIK9h8zAtnFTBz9BHPk1Gl63ZQzMq+hh4jh7gVHy40FEDNBNfxbi5fE
	AO5L54w/dxRlVGYfak3Vk897E15cKoFk+Hk6/IXCbKmEBLnE48JuWivqkT0wSZ8bA7QOYP
	Wk/jxp1agj3jYJFOoVMt4zZsJEcFxEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F2DB43D21;
	Thu, 29 Oct 2026 08:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D42B1F01825;
	Thu, 29 Oct 2026 08:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261265;
	bh=0/5uRqJy/VgEhejne3xSc6gn5mfLQb/Op0B9UDn9Dv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UGmzUw0hxqQB5Jq7K0ZmE8qi79Qh6q/FwJOCvyVhuK7bYNkKkjDFg7534wmT5brvs
	 R0PXvM2ulEtAq4iCNIerACIRHsXPOSAtUVxeEG1CmR+Xn1k4TU5Id+LxPC+eWgUxXN
	 9FApgWS5HSHxCcH0kStuEJbBSRGwq6uLCra3Zfgj7QxRnCcrnRvM3SnYOYQ7Thk6ZI
	 2VaWoduewMiSMIE2jaCqh9vxB7nFdNZco1bjLrXd9xzt77p9AcghmjlJCWrMzaitN+
	 /yJN0+twezwW2pILyIesGTCtPXmNGM5v9Z8qax3+IUH9eWF7JfWJpE6kjE5EmW9uuV
	 9AkBlLloGxKkQ==
Message-ID: <sashiko-outbox-188948@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.15.y] mm: call the security_mmap_file() LSM hook in
 remap_file_pages()
Reply-To: sashiko-reviews@lists.linux.dev
To: "yao zhang1" <yao.zhang1@amlogic.com>
Cc: gregkh@linuxfoundation.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, ebpqwerty472123@gmail.com, paul@paul-moore.com, stephen.smalley.work@gmail.com
In-Reply-To: <20261028080719.1821-1-yao.zhang1@amlogic.com>
References: <20261028080719.1821-1-yao.zhang1@amlogic.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 08:07:44 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: B43C1100008
X-Stat-Signature: prtk6p6pdee3gi4nu9gji3f1hdu3dnr8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793261266-19563
X-HE-Meta: U2FsdGVkX18nM90sffKc600LooIqwgzjZKzd6LSHMzbYbGO7MAM+CRXRmcozVWBrqBB6OsIHB38nHZtLQubbAz3LVSVwggiBi+i+aQM0YftFWqoxQQaHyBl8sEBv1awL4Dx1z85UNseK+Shp3+BsWJseIIs140HV2+AGgA3ZkIVZ3NzuAltUrHknOSvIk1Ep70lCjtwToGZ1V/rImcnMZ84PZukmI+HsTIV1r79ogCj0bayzb243UoVLJbQoDNpZbjiffmwlbVCBO/s/eiRv42bzq86QjgvTpLnmP3T3a+bwxNCadd8L6EyjPjCZujdWYvrqyYQmidSgHdrDWPaK/WFDYOi77dG3Jg3Qam56KRoWOkw+hzg/AytqBMj0K5D0krGTkKGM5TAQ4d215ZNKJHSc4c0JI22gGL3pubeCBnMt9OLly1mz4DcZsh3B9OyDWzxByUbVzA2tjyNfpq7iA9z3xUqbhYBbrLFhUGYHjWYt/xAjZ73v26opV4J3myRvtI2zmTIXbjmMn1TlBJ6/jWIe5eMK2nKvf/oEC0TpYOKvSZPIO3HOXbnnwNzB8NcRtzLqgIGC+ww/m4x+85UOWNA3od/5gixLKqujeYlileigsJwYuLduu+X8RKFq1chQypDs31SgdfcuWTN/2mnTolSgTeXiI6xWa/xKcvoosI0hfpUq3AYj0ebfPvbzOe4tLGSmLX6ifbJRFd2hJhj8Pr7vS0oSlrnnJ+ylwK/DIBJUrGfXxYNrQGasyS/MLXeo6XJLySrqL6LzZfmWMJDtQY4il93Gm6MAu8n3RaWJkRk0Td98lcDFalNHgEqycRUZEERhuWtX7lZeVRQOs9mAHlCrerabXzWnbGumz6Zkz66MlJa8UnO38YnnZnEvF67orFPmhIe/talXnN4b+9Oo2QTcHiF/hFgCYFLUzhhKyt2OpMl6bnE1GN9KPMPres+V5iAANHp1en8k8uTeC9+
 B7BDuhmD
 4JkLaV2kycqiKmwnec9fJIxPX2K9G6nXPhI2EA58pvJCM6sPAejaUNP/1/WUftWtWHHMnX5KYqaKgge1UkoHkufDFZnaRIpbpicmYK25a531+DRcNB7TyBdU245w+ku5CnomU0x1ibVYv3B8ez+WY74eWkyRga3cFGRcwMOEumTfcmd7+FEM0Re1TFN3YEdzZ9wBbHSYGK9bpYPWO3252vIBzLPuZp4lR4/WQmENM4eSxTjizqVJEd70koiLLoG0K/gL7MIYKCkNX5BA91wJrlvR1ayF1e1tOw0RzMGd/OUoDyaGNRL2hTbEsE6P90E9sgQeLauKRq97T26P0q6Y8y/kOlhLiNAdHeBL1Ky+fgwA7iuqCO8iMTR0/BwcHcTLO5ACkXMzU1pSkvWEhh86rzpwpKTp6Y7YobCcFW+DkB0pLSwbPdAunO80vbg02y4odFXm80s6lqkwil02fwOQx7DtbDA2oIL9mRmUoML2V933l8/BXuVRzIR4NMsFk0afSN4hndbF0+Fpp3ajfuRJdRAlKigyPAL56z5cbe3g0lUGMoviJY88Md+SOIL6RiP2zg3WLJXwfunYe8EALCCdPYiWiAKbFbSAWgTXZC+2/azD9b5X2OlqRaOftARdTEInTsE1CrChzIA9Vgoh9L68UcN2uoho9rhDmSAo4Pv1mma37o1lAx6jgLfWb/+3Fngp8j8yX1iULBpOQ9GKzm+iWBML1iB6GnTa41wtbCBLmozCYK5cpOnk5/YTYv6Sx9MUADpCretOPfCczHhP/tIe0jX/QykaCiBdgwzwt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: lock inversion in remap_file_pages() calling security_mmap_fil=
e()
--

commit 78749fa17008059030caa915f2db592fbe2d9fa2
Author: Shu Han <ebpqwerty472123@gmail.com>

mm: call the security_mmap_file() LSM hook in remap_file_pages()

This commit adds a call to security_mmap_file() in remap_file_pages() before
invoking do_mmap() so that LSM policies such as SELinux W^X checks cannot be
bypassed when READ_IMPLIES_EXEC is set in the process personality.

Link: https://project-zero.issues.chromium.org/issues/42452389 [1]

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 273e06dad3c6f..7f357de8f4d68 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -3047,8 +3047,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, s=
tart, unsigned long, size,
>  		flags |=3D MAP_LOCKED;
> =20
>  	file =3D get_file(vma->vm_file);
> +	ret =3D security_mmap_file(vma->vm_file, prot, flags);
> +	if (ret)
> +		goto out_fput;

[Severity: High]
Does calling security_mmap_file() here while holding mm->mmap_lock introduc=
e a
lock inversion with inode->i_rwsem?

In mm/mmap.c, SYSCALL_DEFINE5(remap_file_pages) acquires mm->mmap_lock for
write before looking up the VMA and holds it across this call:

mm/mmap.c:SYSCALL_DEFINE5(remap_file_pages) {
	if (mmap_write_lock_killable(mm))
		return -EINTR;
	...
	file =3D get_file(vma->vm_file);
	ret =3D security_mmap_file(vma->vm_file, prot, flags);
}

However, security_mmap_file() in security/security.c computes the adjusted
protection flags (which includes PROT_EXEC when VM_EXEC is present or when
VM_READ is present with READ_IMPLIES_EXEC set in current->personality) and
calls ima_file_mmap() -> process_measurement() in
security/integrity/ima/ima_main.c:

security/security.c:security_mmap_file()
  -> security/integrity/ima/ima_main.c:ima_file_mmap()
    -> security/integrity/ima/ima_main.c:process_measurement() {
	...
	inode_lock(inode);
    }

When an IMA measurement or appraisal policy applies to the file,
process_measurement() acquires inode->i_rwsem (as well as iint->mutex) while
mm->mmap_lock is already held.

As documented in the lock ordering comment in mm/rmap.c, inode->i_rwsem ran=
ks
outside mm->mmap_lock (for example, generic_file_write_iter() ->
generic_perform_write() in mm/filemap.c holds inode_lock(inode) while fault=
ing
in user pages under mm->mmap_lock). Other callers such as vm_mmap_pgoff() in
mm/util.c and do_shmat() in ipc/shm.c invoke security_mmap_file() outside
mm->mmap_lock for this reason (see commit 8b3ec6814c83).

Can a concurrent buffered write or truncate on the same file deadlock again=
st
remap_file_pages() when IMA is enabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028080719.1821=
-1-yao.zhang1@amlogic.com?part=3D1

