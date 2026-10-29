Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48284606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7uYHMCO
Received: by kanga.kvack.org (Postfix)
	id 4DEEA6B05B6; Thu, 29 Oct 2026 03:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F206B05B7; Thu, 29 Oct 2026 03:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC296B05B8; Thu, 29 Oct 2026 03:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7526B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:43:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9594A75D7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:43:53 +0000 (UTC)
X-FDA: 85374874746.01.B1BCDA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B53940002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:43:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7uYHMCO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793259832;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njjkZYJyqK98tAp78SKwIUi3lpd2OxnQLHE7CyLOajg=;
	b=Cja22OsnU1YnmzcXr3KDraK9BEDBYtNRzCFf6jOkwvQr2viO7D/AzwquDe2rNPKl61HMwJ
	HaMOxuJ+3x/Zs3qEdnPkw/GoFypXDUrnALQMGq05oci8bQJIxLyGHC0ccX3AjGTwL71WlF
	WCIOhcX99UCg28P5YMkKA52K1+JsqpA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7uYHMCO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793259832;
	b=QreOjOVDocRE4cl0vwyNJOxKcIZ6fY7IxAwwyZSlb6nAn9uUEXGLbZ9ZmIhpbJrUz9T5S5
	QqniRUN+YIGJiXU9w4kPnebRvC7ehFABTMTxrcBSNifNq+fpE2jF+d1P6LNhVTXYV4oBge
	pXsdmsq0/8vF0NW8n6Wg27Aiej/tCtU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A74D3601E4;
	Thu, 29 Oct 2026 07:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20801F01825;
	Thu, 29 Oct 2026 07:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793259831;
	bh=njjkZYJyqK98tAp78SKwIUi3lpd2OxnQLHE7CyLOajg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I7uYHMCO4Op0o65e+C4O1vUCEIdSALNmdj8KY7Z64T7dy9i5ddLds5cf7nTUO1rRH
	 McZGlyuEVoccntgtTYeb19AyFCGkU4QSxmSuWIXZlzRwL3Z+Yi0eAasS9ZzbMnpuUS
	 oPMMndrU2NydLSRI6Fo+w/Yk/rLkRinAtWdU/Piii1CvOzwX/vPliQnewfADc1kFre
	 mxEsLWa27M2PSntvN2sm/5rpBioMk4burxhZBqDFX6wUi5mm7sfdU42ivVMcItZ++A
	 wnCYhu8TNfUexiv04ajeBrCpMpElNSGmqQCmEr6W8Lp55UUO8Jzhw7IsMRPvsRjIEp
	 c6QifSF/qKP4w==
Message-ID: <sashiko-outbox-188895@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.15.y] mm: call the security_mmap_file() LSM hook in
 remap_file_pages()
Reply-To: sashiko-reviews@lists.linux.dev
To: "yao zhang1" <yao.zhang1@amlogic.com>
Cc: gregkh@linuxfoundation.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, ebpqwerty472123@gmail.com, paul@paul-moore.com, stephen.smalley.work@gmail.com
In-Reply-To: <20261028074251.1695-1-yao.zhang1@amlogic.com>
References: <20261028074251.1695-1-yao.zhang1@amlogic.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 07:43:49 +0000
X-Rspamd-Queue-Id: 3B53940002
X-Stat-Signature: xf5ptmx7mg589yihm7k6to7fkwcoudjy
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793259832-673636
X-HE-Meta: U2FsdGVkX19ofc6eXWg0BdJ59Q+rgT3XIQl2ttUq67CZmDfxyGfRCcDmvbUrdjDBOvanfl7vjOxB4X16EQ3kMV2Y81UVWp0N/Ttha7/A3FuBABgLYDUqNecjPQ9LMcDg4ntFnCRtsscTfPQAwz5io33OdOHqZ2ucYlRJebjgd5Cca2Sq47s5Jt+UBXJoAthban9A1pCP1QGMEPDtnbHPsh6eE34pKy9buRl1DMRoEviX0EwBYaL3NU5/FRHJQIfZ3FkuAml00TkCHQgZIrin1N5bbeNpL+fss7wPjrIQrWiRwJVx3w5yA79WZZKLh5vdyxshm0zM/lGPbcnugFDI/Y231vxZPcAWp/4GMJHM8lJRiitMHo2KCillN3MWD6DnO4ybYI+/ycIENGkR63Ba7UT+Fw+jNakfLauID9XMsHo4l7twv0u4FabeT4MUME6v+V5OHZF99F1vRJRtwdXqaVipiCK/x/XxBfTNFNX31B59eoR1UhwdhlCwy2IZchvA8vfSEmVBUOeM5BPCSrU/ylKZAmQqc9Abug5rttOH8QrRBa556UxjpxpI/+PE0IdQKPJ58/8jMrNELFfHHYCO+CfP06364PnmAd1NhrqAiEZInN5Tj6A2x8ehpztWsBWfh3suzqnhJXMblTaj1h1RKB3qe17VUMBcogufKWkJFW3b4UhzPfDlvOQ+cLIe5EMMzdSbUcy4/jYzlR3sT775tlZZ6L7Ny3hfoNE2ebxqTxySV8uPOdNONNDbUCZa7i7bsvE/h3QINdfa9aR+3hHLuZQExC3dyUTJv0dtyUvG7CGimRuNUbNyzWYy2mra/Ku31hjIVqOV8b1EYjvYIm2YIwfYJ4WiQGUpdDITBVE13v9/GOvX9RR9Dj7rsUcXDQ8eFOVEM5nFF7gamiBKPPnFM1VMk9w+Dq8or0iqNzytRVDmZpEGUC0bAFZTzFsxcRKFku0hFU/lDBQehbCyiSQ
 a8Na9MbW
 rfyTLQI896bQUaZCoG3uYFw9HUa3gQ5Hq5V1NPODvgO7oBkZo3g7UWMSK3vqzjatD3T/m1ZfpDuPYgs0MEqBs5+HlEDQOuoBzSs1aFdMgIeClxfY35f3uyymcn1XxeDNsgjwiRtQhvRoUFbTJM5JIpDdu/VH8Ot8wX2BQPsmxvEaahIXDHaTLFVLE2fbUD+6zlbFZPhqXngWdLZy/9D7i3Bd2MzvqoWbm2hrGNYUN2p3yJ56foo9GxgiymMI4iaKbovCbzCNst44zXdZjeCz+63LnlJD2+4+kHmsmCm0ppIaVKKhAgO5yC2KY06dcR4XTayiOVYnQVng6f4Z+3Gi+AKJ7Wd83s9/5P0iRlrsREKQH72wrQE9bk9xhwKusEvjyPaSsSXpRhkkkx9i1ALYSXnjkh+zYiM8ZMRGWvbfroZ+je68pyj9SiF1QODN/iTScTLSMiK/BPSbacX56qDQg1iPu8r/8QLgQmP6hzz2XzbLSa0AEEuYVW0oYEH6kebV72w6Yjiwz6dyFPz3sWgrpJ8bE2Oqu4GEnhu3KuqZG6i0q+MFPWusNgySt1lnpU9E5JnQVpdpXanyI19aHQqANqjqjOyAqbcG0Q1l41JNLB0IPJwql895vKTAeDHJNWiFwf2KxbPnffsMK1gI+LjaF8Vj1OJC/BS5FsIKYnUpEmK7FRHm5llVSHjr4g7P16d33NOmIhKU/LNIIcJVevEnHidf6DafOGk/hTCTbLppHmSnaMsMC6vJPIbZRf5rbtWBXXjQ4w7AIKVQLd0IZ9nYYni+o2ZwoFs08/on2
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

commit 5a07ec5e983287a566c335be52d6b9bab2cb5e44
Author: Shu Han <ebpqwerty472123@gmail.com>

mm: call the security_mmap_file() LSM hook in remap_file_pages()

This commit adds a call to security_mmap_file() in remap_file_pages() before
invoking do_mmap(). This prevents processes with the READ_IMPLIES_EXEC
personality set from remapping writable file pages as executable and
bypassing SELinux W^X restrictions.

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
Could calling security_mmap_file() here while holding mm->mmap_lock for
write introduce a lock ordering inversion against inode->i_rwsem?

In SYSCALL_DEFINE5(remap_file_pages) in mm/mmap.c, mm->mmap_lock is acquired
exclusively before reaching this call:

mm/mmap.c:SYSCALL_DEFINE5(remap_file_pages) {
	if (mmap_write_lock_killable(mm))
		return -EINTR;
	...
	file =3D get_file(vma->vm_file);
	ret =3D security_mmap_file(vma->vm_file, prot, flags);
}

When remap_file_pages() is called on a file mapping where the VMA is
executable, or where the VMA is readable and the task has READ_IMPLIES_EXEC
set in current->personality, security_mmap_file() in security/security.c
computes prot_adj with PROT_EXEC set and calls ima_file_mmap():

security_mmap_file()
  -> ima_file_mmap()
    -> process_measurement()

In security/integrity/ima/ima_main.c, when an IMA policy applies to the
regular file, process_measurement() acquires inode_lock(inode)
(inode->i_rwsem) as well as iint->mutex:

security/integrity/ima/ima_main.c:process_measurement() {
	...
	inode_lock(inode);

	if (action) {
		iint =3D integrity_inode_get(inode);
		if (!iint)
			rc =3D -ENOMEM;
	}
}

However, the lock ordering documented in mm/rmap.c requires inode->i_rwsem =
to
nest outside mm->mmap_lock:

 * Lock ordering in mm:
 *
 * inode->i_rwsem	(while writing or truncating, not reading or faulting)
 *   mm->mmap_lock

Other callers such as vm_mmap_pgoff() in mm/util.c and do_shmat() in
ipc/shm.c invoke security_mmap_file() before acquiring
mmap_write_lock_killable(mm). Can calling security_mmap_file() under
mmap_write_lock() cause a deadlock against concurrent buffered writes or
truncates on the same file that take inode_lock(inode) before faulting pages
under mm->mmap_lock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028074251.1695=
-1-yao.zhang1@amlogic.com?part=3D1

