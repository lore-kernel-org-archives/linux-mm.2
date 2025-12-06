Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDA6D3B7D2
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 12:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D8C6B0005; Sat,  6 Dec 2025 07:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE736B0006; Sat,  6 Dec 2025 07:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4696B0007; Sat,  6 Dec 2025 07:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2858E6B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 07:03:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B648A1404F7
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:03:40 +0000 (UTC)
X-FDA: 84188911800.18.407A89D
Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 873BD140002
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:03:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=nabijaczleweli.xyz header.s=202505 header.b=TiOYYR44;
	dmarc=pass (policy=none) header.from=nabijaczleweli.xyz;
	spf=pass (imf26.hostedemail.com: domain of nabijaczleweli@nabijaczleweli.xyz designates 139.28.40.42 as permitted sender) smtp.mailfrom=nabijaczleweli@nabijaczleweli.xyz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765022619; a=rsa-sha256;
	cv=none;
	b=qGKcPr9uMJvfJs9Bp8RZ+BtQvrlhqXnu9zGNAJyQruGxQIM3lzSDJU1JxwPxS0mHxHah1M
	2qFJmtU3mJnGsjlgii3sX55ufMbA/hdcGglz/8XiXzntwrwbtnLQ91fZ380NJd7Q31tFLU
	KkRLsfBToKlki2GY2y/jGl1JTMm6eaI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=nabijaczleweli.xyz header.s=202505 header.b=TiOYYR44;
	dmarc=pass (policy=none) header.from=nabijaczleweli.xyz;
	spf=pass (imf26.hostedemail.com: domain of nabijaczleweli@nabijaczleweli.xyz designates 139.28.40.42 as permitted sender) smtp.mailfrom=nabijaczleweli@nabijaczleweli.xyz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765022619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jajk78jjtKbg0lMmJm0cgRRVhN1VJQ7uL2nvYQuTEy0=;
	b=ESQbmpFn73X8ok/N/K7onCFiofyyUR+mf6e7P8flWLdbSJRGYOHg7hYTr/nhEVFpYkm5Xg
	W7RhiKdFekbwgSjwHqw8SZpzpivBaQ7LMdpESHEXr/r79MeUchTOvLGAsHuJW9ooprMLVl
	3DxZ718/1XZC8TfMPbxnvHox9N2HlJQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202505; t=1765022616;
	bh=lOLBjT1FhIQMNdS5V7F5ONlL7N51IXCMEKC6ONpFAww=;
	h=Date:From:To:Subject:From;
	b=TiOYYR44wI5xIrclsohvgNwsQncXwoWRlLwldFtgG2KBbS+JTVL1jfneLLqAyTNor
	 0I6EkMasJxa6Kj+2y0fvlaHQOc+CiacTwUHxqDMtDGqbhiI9Z/0R5DIiAeuY4AyOGP
	 9GzPaML6fgMcDYBrI2o9g7T94R6dhE7WaoPJyy1MFI5rbvFpJGqQwGMlW/oY0RvCqc
	 5xJaZ2oCQPPjMAWA4cCud+so5n6K7JtqcuZySRFoGX1HSAlFnzJlZBBbVi/vPE4ZH3
	 hQSxbzXgTiP+GUNVsvHU1v9QM7eenkKDuALIWSDeyXwx6Kz+aLcGRzYLOFhPEMQPEO
	 lk0ebJtN1MR/g==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 0749FE3F4;
	Sat,  6 Dec 2025 13:03:36 +0100 (CET)
Date: Sat, 6 Dec 2025 13:03:35 +0100
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: [PATCH] tmpfs: enforce the immutable flag on open files
Message-ID: <znhu3eyffewvvhleewehuvod2wrf4tz6vxrouoakiarjtxt5uy@tarta.nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iyozfdnhfasyy5ay"
Content-Disposition: inline
User-Agent: NeoMutt/20231221-2-4202cf-dirty
X-Rspam-User: 
X-Rspamd-Queue-Id: 873BD140002
X-Rspamd-Server: rspam10
X-Stat-Signature: 7hxdro44e1ybbbikjg8oz8r5as9z9mqg
X-HE-Tag: 1765022618-540350
X-HE-Meta: U2FsdGVkX1/Fgrz67bUAyzWti1dRBazayhG6pnm5GyeXLc+UJhCQzeuxgzRqg94Ng4TRiT/72zF863sE3AyEjSNzkQb/WEpz/oP9FtVLE6v56b+E5VrCqZyEbnmgr459km4midMpb1NUWcvnmyQ+7E0uj7d9tsWd2WMADiRahGpDjt5tEjgdMzDfaSNgfMsWiOmCmEw2FumAUREnczb+2wJkwr1xVAmV7zfbq8gcNfTi8apxKwDs550MqEoQ0OXDHeXBS22lhkXbHmWAMN8cjsF7znBiBQE4+VYS94vMu0/yDO+SFgDcOqOL7Ou4KVYPpDWrNjy5WdDCBfSDZat8Cqj8mVVhYOQeGJ/8f5FkQByzO6drgPtdXEh/SQaqmSCISyKc4/PSSqT7zYgOVaoLaJmSVDy3DJrCAU+CD4CFuFgj0VeYusDwiashFYbWsGFCaJswQ/uYWJb8UqHNI2W+aOLM1xvlMeOhqg792PRgNKtSFgFPhXQDMN377+CpvkCvsioqDo54Y8QW6KXFa4XeLbB+i7zSlY+BkUqOpuR7eepIQ1kKENTKEBeazxhST1m1kL1t1CPfbu25L1DNtRk0G3btVB/L3IIxufadgW+3Kp54sWu2zdrjKJBk6FQmU1JvF4m7xSJUAahC4EYR3FxOboeuOJizDdEKJ6/e97iwNuMSFQaFLVY2a1G2R366kJFlVVW43q3RXrySsEjrvt6XY3HjrqF4ubNFchKTN/ADKJlkQjNsdM41q2bC59gdimyduNfwvLAC6aZbaaMupc1AulrmszkoodeW0qgRlQQSrbnmEfqIE2rj/u+e+2XfM7YB1tassnUMSiteEr3a1HOCQTth63kiVEgqFh7WpWZDn3g1wwRY2blPXRIZXEoYrN1ud5E8bfT37e+rIIME1H9qhOPg5bkpdM/JKe4uiZZJgAv6y/QE+pd4mMmnQgbE3oJTZr+gFQau70hSuX0/l9L
 1azAH6gz
 DmjGbz+g5tJQnpp2Nb0FJkIUwJwXyr+UN1VSs42mTITSZaWfXlV5KOCVYiuAHUTt3JII7QenOGj+y2gk6cT+B5XSBfFIPhvlOKLOwT9Y21jIwhHygBsCaAgMlpMWMY762qUMDekW05OUg+peS3FAM9F0pfvU24VwOY1UdJW/p/9z9UoByj/ljUwpoEY7F4gGYy+W67YzsOdUo/d2LxEthFtnGQ6jhqLUed19Lz6IgGZjrLfVHrXJy98WRhO//F6RPdrgnpT2ex3sIikq03SkttVSXlbuZycjXs6ebQxNY5jSvmcOFKXSU5/SVSgCpUxL5VqbkExlYZWott+wubsG368X1l8HyB1X07V7Q434AtrRmqE8Nmbb82q7H2OUkaQxadySwY0TjJiA+0/rxSa5lQoZZqzb3EtXj2cpuOy9/A1maUoNQ7ZT+GEzsWU0+gjRu/0Gk3m7PQlVCu1R8SHFvGDXZ+/Js7ry05b/jHSTA1ZCK1ObSboaU7wR5T48z8TThZPALGFnORo4B4D6sA4h2wt3Yifkr/zKMSVSsLCLcsAAGd6RlXQeMIBAdZ9T6SWYDSF6iBSEO0DsMXxZ8o3SxvnWKYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--iyozfdnhfasyy5ay
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This useful behaviour is implemented for most filesystems,
and wants to be implemented for every filesystem, quoth ref:
  There is general agreement that we should standardize all file systems
  to prevent modifications even for files that were opened at the time
  the immutable flag is set.  Eventually, a change to enforce this at
  the VFS layer should be landing in mainline.

References: commit 02b016ca7f99 ("ext4: enforce the immutable flag on
 open files")
Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
/ext4# uname -a
Linux tarta 6.18.0-10912-g416f99c3b16f-dirty #1 SMP PREEMPT_DYNAMIC Sat Dec=
  6 12:14:41 CET 2025 x86_64 GNU/Linux
/ext4# while sleep 1; do echo $$; done > file &
[1] 262
/ext4# chattr +i file
/ext4# sh: line 25: echo: write error: Operation not permitted
sh: line 25: echo: write error: Operation not permitted
sh: line 25: echo: write error: Operation not permitted
sh: line 25: echo: write error: Operation not permitted
fg
while sleep 1; do
    echo $$;
done > file
^C
/ext4# mount -t tmpfs tmpfs /tmp
/ext4# cd /tmp
/tmp# while sleep 1; do echo $$; done > file &
[1] 284
/tmp# chattr +i file
/tmp# sh: line 35: echo: write error: Operation not permitted
sh: line 35: echo: write error: Operation not permitted
sh: line 35: echo: write error: Operation not permitted

 mm/filemap.c | 10 ++++++++--
 mm/shmem.c   | 12 ++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..0b0d5cfbcd44 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3945,12 +3945,18 @@ EXPORT_SYMBOL(filemap_map_pages);
=20
 vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf)
 {
-	struct address_space *mapping =3D vmf->vma->vm_file->f_mapping;
+	struct file *file =3D vmf->vma->vm_file;
+	struct address_space *mapping =3D file->f_mapping;
 	struct folio *folio =3D page_folio(vmf->page);
 	vm_fault_t ret =3D VM_FAULT_LOCKED;
=20
+	if (unlikely(IS_IMMUTABLE(file_inode(file)))) {
+		ret =3D VM_FAULT_SIGBUS;
+		goto out;
+	}
+
 	sb_start_pagefault(mapping->host->i_sb);
-	file_update_time(vmf->vma->vm_file);
+	file_update_time(file);
 	folio_lock(folio);
 	if (folio->mapping !=3D mapping) {
 		folio_unlock(folio);
diff --git a/mm/shmem.c b/mm/shmem.c
index d578d8e765d7..5d3fbf4efb3d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1294,6 +1294,14 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 	bool update_mtime =3D false;
 	bool update_ctime =3D true;
=20
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return -EPERM;
+
+	if (unlikely(IS_APPEND(inode) &&
+		     (attr->ia_valid & (ATTR_MODE | ATTR_UID |
+					ATTR_GID | ATTR_TIMES_SET))))
+		return -EPERM;
+
 	error =3D setattr_prepare(idmap, dentry, attr);
 	if (error)
 		return error;
@@ -3475,6 +3483,10 @@ static ssize_t shmem_file_write_iter(struct kiocb *i=
ocb, struct iov_iter *from)
 	ret =3D generic_write_checks(iocb, from);
 	if (ret <=3D 0)
 		goto unlock;
+	if (unlikely(IS_IMMUTABLE(inode))) {
+		ret =3D -EPERM;
+		goto unlock;
+	}
 	ret =3D file_remove_privs(file);
 	if (ret)
 		goto unlock;
--=20
2.39.5

--iyozfdnhfasyy5ay
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmk0G5cACgkQvP0LAY0m
WPFvIBAAk19V5uv/iePKa0AKLG5tkWQK6HUqaR/8OfHJ7jzQLHX65huV5VexvAwJ
BAu0GmaA97FjfnVlMjDfNGvrQYCr3qQz1WQqsjMMb87VkcO7I0qwAfkhzzhX9RXv
cxgzUbyBzM+yGmI7P4GU+LjV1dO10p0+5rd1gFIfzJkwyhN2wf5jgSziFu5phiYl
QBboDk9cgz7js6nefDMOUUf8nbdWPwdUueWmKfTHTim14FplslAwlX3X19UDU5Mi
KdA96wd9XTA1kVcduDchwFX1VflYdibzEGmtPMKMenYVnGskDDM+qAlJalno4/wK
D3LZsw0Q6bT0CE+md3NGaaaH7p+6nYyBTXvt+MkaF5cjesXUZg3175L5LYsO+T2L
Ub0yAEXgJpIFl9UIPoTAASRqlYXCv3HUKL8mAAOQH21okpgkAzgqvwXEOaDagA2R
n7U2zSIl6gr2TJgL4HVsUdwEVkKy+lmxKy2oc78ny0RXFrFDCJMAcnQuIL/7poz/
q9qErl3EtfPEvHj/r+T6CFK3YOwMa/SePinBcnvh4o2eD+5Lo0W2DJcKnL/gEPXQ
uoXSzjexYmpI0MOZR+rKWiYgmTM3Ll6Wp2CwPsC9hD1ChMsTlEQsoeKwVpzZCnVP
rt+HO4oIjacRf4EyHnyARf8q5jUEWMXDsJmrUf9hZLCL81GuB64=
=ybT3
-----END PGP SIGNATURE-----

--iyozfdnhfasyy5ay--

