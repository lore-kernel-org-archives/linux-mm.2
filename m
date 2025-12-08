Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0EF0D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 21:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0DE6B0006; Mon,  8 Dec 2025 16:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7EF6B0007; Mon,  8 Dec 2025 16:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDC76B0008; Mon,  8 Dec 2025 16:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DED26B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:50:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9771988DAD
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:50:23 +0000 (UTC)
X-FDA: 84197647926.15.9D551E9
Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 79BEC1C001D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:50:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=nabijaczleweli.xyz header.s=202505 header.b="V67/bGoV";
	spf=pass (imf20.hostedemail.com: domain of nabijaczleweli@nabijaczleweli.xyz designates 139.28.40.42 as permitted sender) smtp.mailfrom=nabijaczleweli@nabijaczleweli.xyz;
	dmarc=pass (policy=none) header.from=nabijaczleweli.xyz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765230622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eqMMKLzelUBtEKmZgNR6yYEg8hojrIVFnJusXP4KLGE=;
	b=CJNaH9UNUN0nrZtEh6Mwd4uXnARYpLpS5w7nQxB1x55JJlfS3tQ5Qrg9WUsOsz/wSGz/6F
	dNov9shsidesNfGm9t6EYb/rDdEVY4M5dmCB9QDDxerbVVXl1auPKxw5G7lG1bANb5Lm4x
	xDrvpH0kDEupx/9yhrV1b9Rzxh5aSac=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=nabijaczleweli.xyz header.s=202505 header.b="V67/bGoV";
	spf=pass (imf20.hostedemail.com: domain of nabijaczleweli@nabijaczleweli.xyz designates 139.28.40.42 as permitted sender) smtp.mailfrom=nabijaczleweli@nabijaczleweli.xyz;
	dmarc=pass (policy=none) header.from=nabijaczleweli.xyz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765230622; a=rsa-sha256;
	cv=none;
	b=HfwTk+xq9QazLRDlt0Yhx6i1nP0Rp+fcuOBJFfRxf0aCRRgkbG4OEZBgwN1XCbP93qmdrj
	pNE8DXC8gh34kA4hHuB98hwIz9x7X5rvWdpkMqOICqkbz01KgJ/QnISwFJiPkzEcmm+0jK
	dbbeOvlwVUHivWakM1/UYa7gxpKs6/o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202505; t=1765230615;
	bh=0PKTKFXGxd2aclzI0UHRl6n4Lefqy7Wq32pHokcYqTI=;
	h=Date:From:To:Subject:From;
	b=V67/bGoV09QofbjWU4KsbuLK8Sx4FsQn9jUzwP+hKMTBBDW32BzV5SP0q5DRvQQvZ
	 WDkU7dC+1G7lXXx8FR1iluvXmVI5h0E/T4kY4TCuRBFYn437KsczLnzPsbkXto2Ml3
	 JG/BH9cgZtfy7AEecgAi1u8RCvvK4UKgvW0biU5leRRrTKUTWaX/P+r4PWnKzK2DyL
	 lr0p30t0aTot37tKd/gsxZIhQQxVNZA43VWW3cdieM6bek6BxabNI09GbwwU6uoJHY
	 C3h0ZPPcj7DN/jvOq7n4d0xwPRqMeu/CSswflCGyuQHiQhtisET4lWyg+7pr2/euTL
	 aEi97hEEgvd1Q==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id C4621F3BE;
	Mon,  8 Dec 2025 22:50:15 +0100 (CET)
Date: Mon, 8 Dec 2025 22:50:15 +0100
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
To: Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] tmpfs: enforce the immutable flag on open files
Message-ID: <toyfbuhwbqa4zfgnojghr4v7k2ra6uh3g3sikbuwata3iozi3m@tarta.nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="27dnkjatirtu5y4b"
Content-Disposition: inline
User-Agent: NeoMutt/20231221-2-4202cf-dirty
X-Stat-Signature: 63ems5r67de9k77hxetwww5t9c9wbwu8
X-Rspamd-Queue-Id: 79BEC1C001D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765230621-60011
X-HE-Meta: U2FsdGVkX1+26Dg5Wk0QPRZh1/INect47DpUx4gxRdSPE1xvnaRiVqfRDY8bfYvCHDPBgFiEX2CC3zqZdB7m91qd+hsqfJcQAHA7saQGPTX8y3uNJTqBuHRVHaaZTHJO07yAXscuQS7HFLBWCkcSefOgeGMggI2E44EH0HYZOdVcxqRwCQD1vpRnpEWkt5CYBAxq/kldonADEIAv1f+xUp7StH/kXfo0nBF2EuGWvmKa+7G93VA7PpOAHo3e2oCpNV2Oj3D5PvfebZZDjAjB3Y8lq+IxbGD2yEprNiZ4OCoYzAkReuMhmmW6ihHV/oM9yCoFfaiYEGk7T5v6/zkirE3nU4J5lzT5Mc9J91Q09+DxzN2+M1qwxu1Im33QFMclGH5O/jwuYRHu/isQxa/3YcRMR8LYvi/aO7Cu/U4shGAgwUv5njKhePkPOnoSmtEoxrYLCpgWG3yOB3JkXI/LVgwetzQCF4YYXaOcZbx66vrbYoANyL/nXvU90TMfHS+UMmG7946Fck8mvEQ5OFjDlFiCe0nfflODtK1dPT+jSplog636rLBW2oYSs9S28fL0WP9PlaWUt3WicoKWhpeFb7AGAFsXPSpS3MXQ3R9ZobwrZZJeoAEdBgxR6I0ZsacjfRlvjt2fbNy0KlDGgpjtG+d80mn3HdiAh9CVnH9DPcObPI5xgihb3eYTyFtwPtUuZG5H4n5kjdvBdhWKLFsvtkS9S3BwVfhkeJqtYGoa3FXjnGGUS2QCGysvgb7OzBCqYEtyTsq+bBQLLfbJv+SUoUdViwuI7tRsdnaXJkhODJZVhq7mBTVNyH8gu547KI4i6ChXTG3WPdH5X6cWVHJ4frHDcB9Yq7BC4W30Q0kWZ4Bhi29j9lmXtZnRvDdiA8LqUVTjGotqMlbASX2olheZtyVdospQNZmbNBXUTj+xbiASvN8sEgpxKtorEXL9CV7YY5pruC5UpCFDEmDwOco
 MIMLoi3P
 6hJek9RgYsHkw67L7L5rqVmThwclttkd7WCvVVXv8XM6xju317UES+mAqoOPZVHHtdKJ1nRTQWeU7suSSyZbJomgDwin8rXtOsCymcDLkX0RChd4b5+dRqjhYBVOeLegVE4sMgTwYU2PBfbY79K3iTaE2MJqz/yNggH4051T/xkEMe2pWQ3zo65ayHhPDOGVkadkYPYmd34Pa2pViv5h4IpHxsq/UrPTanBFpj34yG5aXb2oypbx929qAA3qNKVqFvw3Zy2Cj5xpcDu4PS4GGAxWjSb8fglzwaDIHBi5qqrrVFSDTE07ijvUXVDaIAeg2LWYxDb/VIMv+zdO+4GMtNvnsViYuXyh5gwj8A43xw0AwuSMq7ShEhv6FFRyhtc7g9VYYXXgVJWnNEeDpmJhcA0z/WF5vAKBqi9EMSz9IeyqoXXg022VpAChXES3QJK+o740DBVFZn61X2ADGAWeTu8lzNGfJVMoPhTFv9kZSYcHmNXgNS/4jZVr5nj7fCWO9ALmoExt/664Nq43Q7qyIcDY4Puf5MoXnEHlcnGvIKlYIf1kLgQqeEzUQzXhamqnw8OA9AL3jje3TkuKJ83SbeeLcW4cb+ZLD+nEpU41B2LU5tGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--27dnkjatirtu5y4b
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
v1: https://lore.kernel.org/linux-fsdevel/znhu3eyffewvvhleewehuvod2wrf4tz6v=
xrouoakiarjtxt5uy@tarta.nabijaczleweli.xyz/t/#u

shmem_page_mkwrite()'s return 0; falls straight into do_page_mkwrite()'s
	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
		folio_lock(folio);
Given the unlikely, is it better to folio_lock(folio); return VM_FAULT_LOCK=
ED; instead?

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

$ cat test.c
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/fs.h>
#include <sys/mman.h>
int main(int, char **argv) {
	int fd =3D open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0666);
	ftruncate(fd, 1024 * 1024);
	char *addr =3D mmap(NULL, 1024 * 1024, PROT_READ | PROT_WRITE, MAP_SHARED,=
 fd, 0);
	addr[0] =3D 0x69;
	int attrs =3D FS_IMMUTABLE_FL;
	ioctl(3, FS_IOC_SETFLAGS, &attrs);
	addr[1024 * 1024 - 1] =3D 0x69;
}

# strace ./test /tmp/file
execve("./test", ["./test", "/tmp/file"], 0x7ffc720bead8 /* 22 vars */) =3D=
 0
=2E..
openat(AT_FDCWD, "/tmp/file", O_RDWR|O_CREAT|O_TRUNC, 0666) =3D 3
ftruncate(3, 1048576)                   =3D 0
mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) =3D 0x7f09bbf2a=
000
ioctl(3, FS_IOC_SETFLAGS, [FS_IMMUTABLE_FL]) =3D 0
--- SIGBUS {si_signo=3DSIGBUS, si_code=3DBUS_ADRERR, si_addr=3D0x7f09bc029f=
ff} ---
+++ killed by SIGBUS +++
Bus error
# tr -d \\0 < /tmp/file; echo
i

 mm/shmem.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index d578d8e765d7..432935f79f35 100644
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
@@ -2763,6 +2771,17 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 	return ret;
 }
=20
+static vm_fault_t shmem_page_mkwrite(struct vm_fault *vmf)
+{
+	struct file *file =3D vmf->vma->vm_file;
+
+	if (unlikely(IS_IMMUTABLE(file_inode(file))))
+		return VM_FAULT_SIGBUS;
+
+	file_update_time(file);
+	return 0;
+}
+
 unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long uaddr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
@@ -3475,6 +3494,10 @@ static ssize_t shmem_file_write_iter(struct kiocb *i=
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
@@ -5286,6 +5309,7 @@ static const struct super_operations shmem_ops =3D {
 static const struct vm_operations_struct shmem_vm_ops =3D {
 	.fault		=3D shmem_fault,
 	.map_pages	=3D filemap_map_pages,
+	.page_mkwrite	=3D shmem_page_mkwrite,
 #ifdef CONFIG_NUMA
 	.set_policy     =3D shmem_set_policy,
 	.get_policy     =3D shmem_get_policy,
@@ -5295,6 +5319,7 @@ static const struct vm_operations_struct shmem_vm_ops=
 =3D {
 static const struct vm_operations_struct shmem_anon_vm_ops =3D {
 	.fault		=3D shmem_fault,
 	.map_pages	=3D filemap_map_pages,
+	.page_mkwrite	=3D shmem_page_mkwrite,
 #ifdef CONFIG_NUMA
 	.set_policy     =3D shmem_set_policy,
 	.get_policy     =3D shmem_get_policy,
--=20
2.39.5

--27dnkjatirtu5y4b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmk3SBIACgkQvP0LAY0m
WPFVnhAAmdkHtpNU4LAEDVg6qRIA6QyAykW1zd+zM6yKhMtP7gmbFJd9fcy8TyGl
Ym7JXRoma+VxA8xfl8pnbMOiRaR2gEo+iAd418PHg09BvY13PRtt2/nWQ6vzTlKM
M4qSVZZC6tIKEEuPmEti98M/Zn12iHorTGSQ2OgNVLhvs7DDnkUn4VkLW45Z+DEb
e73zuGnFA5stBNUcKeOw2aqAKo/1d2PYu4rGFQb1FMFBMvvVHbI4YRpSSnUJfPkH
iohvghgxPe896hoImjFhJUWX53td7U+smRFWVJQhxky85zap95NyPlCjf6Xd3wOX
i+XqvQFnbybc8FQNxs5j6cikVrXDNvPuZ4IfqadnpowmuDtMkZ0s2ZSFGN916k+6
TqyXUnIkzA/ORdHs2Y2cpN0Gg+EHP8jD6OPkv41oRptJujkyRC0zFYOio6AV+QNs
QgGPCwzk4NlmEi23a0OzYD4NApOVo3eCEnFQaooqz0xbb5FuMga7P2oBPPqnJ2+r
09TAninZR0PuNtyuyi+LXhF7A3nBotUNfSL/8D8nssvLTHzMd+a1mRMARo/IE/JH
uIAa2S30dmYsrVBrJMmfn0mG2utJL3NC5GXFpsjiQeDzCq1Jb0oh3LUNvS1lxHXn
IOabN4FYeHB6R5f4//gB0Ldx5wFCdoupMn0mPSQJjewfWend1/k=
=rA2t
-----END PGP SIGNATURE-----

--27dnkjatirtu5y4b--

