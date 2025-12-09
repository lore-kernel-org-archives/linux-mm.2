Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D18FD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 14:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16286B0005; Tue,  9 Dec 2025 09:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0136B0007; Tue,  9 Dec 2025 09:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867326B0008; Tue,  9 Dec 2025 09:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC436B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:00:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11E6B160140
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:00:42 +0000 (UTC)
X-FDA: 84200093124.19.7A90B9D
Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 969674001E
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:00:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=nabijaczleweli.xyz header.s=202505 header.b=c9gnRav4;
	dmarc=pass (policy=none) header.from=nabijaczleweli.xyz;
	spf=pass (imf04.hostedemail.com: domain of nabijaczleweli@nabijaczleweli.xyz designates 139.28.40.42 as permitted sender) smtp.mailfrom=nabijaczleweli@nabijaczleweli.xyz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765288840; a=rsa-sha256;
	cv=none;
	b=hX0bauBCshc6YDEXiqYOvXHAs/gjhsNR/qBy/zp7ZpPFL7i1Bb+cyQ3fg042tGVxOqnwX5
	zjjMLe+2WjqskjXSRJ9x6d2JZ63/AP0O7YzU62vjyniBKuza9xAG96x+OdX4asNpAbCFkf
	CEHDG4kvBJYBn63l9DgiaU4wQZRJcI0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=nabijaczleweli.xyz header.s=202505 header.b=c9gnRav4;
	dmarc=pass (policy=none) header.from=nabijaczleweli.xyz;
	spf=pass (imf04.hostedemail.com: domain of nabijaczleweli@nabijaczleweli.xyz designates 139.28.40.42 as permitted sender) smtp.mailfrom=nabijaczleweli@nabijaczleweli.xyz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765288840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7YoyWPLoo1Oexx9AoV1XkRytYggSZxlMxvR4b5M6CI=;
	b=Q2aLj/f4/xGcIVkDs/5KGKnjyqljzXszLG3imzdhUEVL9oKCdgOHgyNOIl2gBATylH80id
	HbWcDhItOViRldC8cSrb+gruZXA9SxRaclE6G8g+Rhuo1JUlnq4VhrCTPfDSXT1FLtoOSH
	1iHXutNL5nXZ5AYR0mZrhy60LQWzWHQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202505; t=1765288835;
	bh=7aJcdC7gJFpMHBsFFI7dYqx6C/DH+AdeopjEcNfJG9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c9gnRav46sO4Zvpjnq87F9oIWKtzB4WS0XYVeEy5gY0kDJyFM9a5alMgT0Bv0Elo6
	 85Ok+KUGWqvrR8FfWuntuf9SSGZEfXN12smBlLyiYYPJztMJgUMBG3vbiufVGyHE0K
	 5e6rpqoDY4PceOc7LiQ1BgUq0izp7uhNckUsSdUpl7AoSeogwFptl53y87UNSzlvlD
	 ecnhk0Ad3kFXcx188s+Cq1JPYBzDfLWsJPeD4bEWJUDsg6IWj02mytILBNNQR6qrZi
	 khRjrnHt/DoSEu75w4gb1FIShUjZsIdHdVoF6WKIM9NZXmbY7oVQFqNGaaK9nsmyIg
	 IENXkA84dLhRw==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 8D684EE42;
	Tue,  9 Dec 2025 15:00:35 +0100 (CET)
Date: Tue, 9 Dec 2025 15:00:35 +0100
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
To: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tmpfs: enforce the immutable flag on open files
Message-ID: <mmfrclxjf2mmmohiwdbgqhyyrlab33tpnmtuzatk2xsuyiglrp@tarta.nabijaczleweli.xyz>
References: <toyfbuhwbqa4zfgnojghr4v7k2ra6uh3g3sikbuwata3iozi3m@tarta.nabijaczleweli.xyz>
 <be986c18-3db2-38a1-8401-f0035ab71e7a@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="odzmi4uh2rsyvvsv"
Content-Disposition: inline
In-Reply-To: <be986c18-3db2-38a1-8401-f0035ab71e7a@google.com>
User-Agent: NeoMutt/20231221-2-4202cf-dirty
X-Rspam-User: 
X-Rspamd-Queue-Id: 969674001E
X-Rspamd-Server: rspam10
X-Stat-Signature: axoke9xg14bo7bde5we58wizkz76gnq4
X-HE-Tag: 1765288839-357091
X-HE-Meta: U2FsdGVkX19AkST0ZGk+qYlRB7UY/cPv+z8PgAjiguHG0oZ/ndyfiuyL4IKSnVb+FBxaCeGuUemYqIBLWe8JyEKw0D2/x13Gl5IR0RmQ/fZSWrU4Isscw1M1pXASFZU23+DC4/Th5yQJGreejQhB4grBtiTBmdR21svt4MtdzwF+hMSISUWsIHNiqE/pCN/t+w+catQz8QWpp0vf0twzNBe/s3GxBMjBjptoYQuY2TlltQo+SgRk2Y4mOerwfSfJ309YUQ+UG8pFBNhMjg5JRN3oJ5Sop2XjVYsuTqNDhN9EtqIlqqPaF2ClvDVeUGo6IT32RipaAG6QKHlmBV/XJjnlv9TH3LHzivA39b/yX02WlIvL38h7tjK8IS5oFJGUXHISralXkVl+GzAovsIJoOtS2MBgpF0GpHd9dEuaSpA6Uc1QtVhnzRxGgc69Di+6FOTwMB0TjvQhSjXWH6hHB7JwoAlXocXfeuJDFGwWCZVi/Ag5V/oNh8KktsEI9v0semb/iaAHM43WuYuzTc/nxWcL3aAANuh2JvWzPUxkuHhhfQiR62tGETNDpZSjBR8ZJ04HFuBbOG4bK3QU15IVJY2TcC3vvqrxBGPFzYre6UTgXMHt+KYVnSOEUxJhl+oaawN/VrkxIFlr0nz0c5ed+FqS1h6Y5C5RX+q9RPSA7pJvEfwtLw+Xhx8D9WirJ1ugXUCeoooY+0o3NInnCbGEKFrLcBjBUxVWGpiuhh/zOTKyfu/4t/yqtNpA35nt+jXr9x+Ym2LTBZMCN360bkdT+gxPGh+BPsId2gwDXec3garZNOHOfrxzGg+XZinNuLr1QaNJ+Xqv0WvZ9PUp1Ky6McEuOQjaWjhlvJXM5xitroVB7aH+GvzGS3nehzH0wtcFhC66fL2FNBJ8FdZUq/JI2ccJwbezzJmjPThVFLjOfpGOqTT8Zx6PHSjMO/V9KtkmnUqgc6NTMzAakKvicrE
 ZS+oonuK
 ak6AYDzkZjaQAbukjBbkjl9VyMI/1UuyaeMXtTZa9x5PlUb+IbZzqtF8KGMLHysQjIgHq4cvuJImpiYHJogrS27upnuFatDSZjbeGcukgLTeTIS8bEaJXHNM1WaHI1dgHrDK1QV9891Tyma4lI7+Lw5g+Qv9Wh3fLoLSKppXziCpFKbs2lzgNY1tSWBqUnzkm/P6bkjspMEqoXB69KPFvOoeGe7A8DagyFhGzdL2le21DE44As74UydgxUoeBJaHcKza+vDt7zhkx7tiUgIPa//1M4DqddS3fSl6RA0ow8GCmJigzn8A3h8zTH7nOSXn2hkMnHMusfgnBOAuN4pd9QmoXzIhWmJoMiA+EL60ihKAGYMHUFQKiks38Bi6fiRR/4nnEAs/bt4UYaGuXN4QbLH3NzkeFKGLZIzQKGisabKF1Qi7IY0sfl+Q+V2/m7xmGmeO3ortIkTlOFhz36zeoHWDV/A/Q35jz61SiJJP7WPvByHgi9Oe9fNMEdQMAezrbXZnzx+sdl7chqAn7woHH1BrXut3FP3dLtMN1RvKGZSm2skVWI7c8JQAAwzOfRIjt5cxG+JYgv0Q2W+4mG50vyq8V+LdA5qN37gxLkw2A38XJEjc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--odzmi4uh2rsyvvsv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2025 at 08:14:44PM -0800, Hugh Dickins wrote:
> On Mon, 8 Dec 2025, Ahelenia Ziemia=C5=84ska wrote:
> > This useful behaviour is implemented for most filesystems,
> > and wants to be implemented for every filesystem, quoth ref:
> >   There is general agreement that we should standardize all file systems
> >   to prevent modifications even for files that were opened at the time
> >   the immutable flag is set.  Eventually, a change to enforce this at
> >   the VFS layer should be landing in mainline.
> >=20
> > References: commit 02b016ca7f99 ("ext4: enforce the immutable flag on
> >  open files")
> > Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.=
xyz>
> Sorry: thanks, but no thanks.
>=20
> Supporting page_mkwrite() comes at a cost (an additional fault on first
> write to a folio in a shared mmap).  It's important for space allocation
> (and more) in the case of persistent writeback filesystems, but unwelcome
> overhead in the case of tmpfs (and ramfs and hugetlbfs - others?).

Yeah, from the way page_mkwrite() was implemented it looked like
enough of a pessimisation to be significant, and with how common
an operation this is, I kinda expected this result.

(I was also gonna post the same for ramfs,
 but it doesn't support FS_IOC_SETFLAGS attributes at all.)

> tmpfs has always preferred not to support page_mkwrite(), and just fail
> fstests generic/080: we shall not slow down to change that, without a
> much stronger justification than "useful behaviour" which we've got
> along well enough without.

How do we feel about just the VFS half of this,
i.e. open(WR)/chattr +i/write() =3D -EPERM?
That shouldn't have a performance impact.

(I'll admit that this is the behaviour I find to be useful,
 and I was surprised that the ext4 implementation also made mappings
 SIGBUS, but I implemented both out of an undue sense of completionism.)

> But it is interesting that tmpfs supports IMMUTABLE, and passes all
> the chattr fstests, without this patch.  Perhaps you should be adding
> a new fstest, for tmpfs to fail: I won't thank you for that, but it
> would be a fair response!

I rather think having IMMUTABLE but not atomically perfusing it
to file descriptions is worthy of a test failure.
The mmap behaviour, not so much.

> Hugh
>=20
> > ---
> > v1: https://lore.kernel.org/linux-fsdevel/znhu3eyffewvvhleewehuvod2wrf4=
tz6vxrouoakiarjtxt5uy@tarta.nabijaczleweli.xyz/t/#u
> >=20
> > shmem_page_mkwrite()'s return 0; falls straight into do_page_mkwrite()'s
> > 	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
> > 		folio_lock(folio);
> > Given the unlikely, is it better to folio_lock(folio); return VM_FAULT_=
LOCKED; instead?
> >=20
> > /ext4# uname -a
> > Linux tarta 6.18.0-10912-g416f99c3b16f-dirty #1 SMP PREEMPT_DYNAMIC Sat=
 Dec  6 12:14:41 CET 2025 x86_64 GNU/Linux
> > /ext4# while sleep 1; do echo $$; done > file &
> > [1] 262
> > /ext4# chattr +i file
> > /ext4# sh: line 25: echo: write error: Operation not permitted
> > sh: line 25: echo: write error: Operation not permitted
> > sh: line 25: echo: write error: Operation not permitted
> > sh: line 25: echo: write error: Operation not permitted
> > fg
> > while sleep 1; do
> >     echo $$;
> > done > file
> > ^C
> > /ext4# mount -t tmpfs tmpfs /tmp
> > /ext4# cd /tmp
> > /tmp# while sleep 1; do echo $$; done > file &
> > [1] 284
> > /tmp# chattr +i file
> > /tmp# sh: line 35: echo: write error: Operation not permitted
> > sh: line 35: echo: write error: Operation not permitted
> > sh: line 35: echo: write error: Operation not permitted
> >=20
> > $ cat test.c
> > #include <unistd.h>
> > #include <fcntl.h>
> > #include <sys/ioctl.h>
> > #include <linux/fs.h>
> > #include <sys/mman.h>
> > int main(int, char **argv) {
> > 	int fd =3D open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0666);
> > 	ftruncate(fd, 1024 * 1024);
> > 	char *addr =3D mmap(NULL, 1024 * 1024, PROT_READ | PROT_WRITE, MAP_SHA=
RED, fd, 0);
> > 	addr[0] =3D 0x69;
> > 	int attrs =3D FS_IMMUTABLE_FL;
> > 	ioctl(3, FS_IOC_SETFLAGS, &attrs);
> > 	addr[1024 * 1024 - 1] =3D 0x69;
> > }
> >=20
> > # strace ./test /tmp/file
> > execve("./test", ["./test", "/tmp/file"], 0x7ffc720bead8 /* 22 vars */)=
 =3D 0
> > ...
> > openat(AT_FDCWD, "/tmp/file", O_RDWR|O_CREAT|O_TRUNC, 0666) =3D 3
> > ftruncate(3, 1048576)                   =3D 0
> > mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) =3D 0x7f09b=
bf2a000
> > ioctl(3, FS_IOC_SETFLAGS, [FS_IMMUTABLE_FL]) =3D 0
> > --- SIGBUS {si_signo=3DSIGBUS, si_code=3DBUS_ADRERR, si_addr=3D0x7f09bc=
029fff} ---
> > +++ killed by SIGBUS +++
> > Bus error
> > # tr -d \\0 < /tmp/file; echo
> > i
> >=20
> >  mm/shmem.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >=20
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index d578d8e765d7..432935f79f35 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1294,6 +1294,14 @@ static int shmem_setattr(struct mnt_idmap *idmap,
> >  	bool update_mtime =3D false;
> >  	bool update_ctime =3D true;
> > =20
> > +	if (unlikely(IS_IMMUTABLE(inode)))
> > +		return -EPERM;
> > +
> > +	if (unlikely(IS_APPEND(inode) &&
> > +		     (attr->ia_valid & (ATTR_MODE | ATTR_UID |
> > +					ATTR_GID | ATTR_TIMES_SET))))
> > +		return -EPERM;
> > +
> >  	error =3D setattr_prepare(idmap, dentry, attr);
> >  	if (error)
> >  		return error;
> > @@ -2763,6 +2771,17 @@ static vm_fault_t shmem_fault(struct vm_fault *v=
mf)
> >  	return ret;
> >  }
> > =20
> > +static vm_fault_t shmem_page_mkwrite(struct vm_fault *vmf)
> > +{
> > +	struct file *file =3D vmf->vma->vm_file;
> > +
> > +	if (unlikely(IS_IMMUTABLE(file_inode(file))))
> > +		return VM_FAULT_SIGBUS;
> > +
> > +	file_update_time(file);
> > +	return 0;
> > +}
> > +
> >  unsigned long shmem_get_unmapped_area(struct file *file,
> >  				      unsigned long uaddr, unsigned long len,
> >  				      unsigned long pgoff, unsigned long flags)
> > @@ -3475,6 +3494,10 @@ static ssize_t shmem_file_write_iter(struct kioc=
b *iocb, struct iov_iter *from)
> >  	ret =3D generic_write_checks(iocb, from);
> >  	if (ret <=3D 0)
> >  		goto unlock;
> > +	if (unlikely(IS_IMMUTABLE(inode))) {
> > +		ret =3D -EPERM;
> > +		goto unlock;
> > +	}
> >  	ret =3D file_remove_privs(file);
> >  	if (ret)
> >  		goto unlock;
> > @@ -5286,6 +5309,7 @@ static const struct super_operations shmem_ops =
=3D {
> >  static const struct vm_operations_struct shmem_vm_ops =3D {
> >  	.fault		=3D shmem_fault,
> >  	.map_pages	=3D filemap_map_pages,
> > +	.page_mkwrite	=3D shmem_page_mkwrite,
> >  #ifdef CONFIG_NUMA
> >  	.set_policy     =3D shmem_set_policy,
> >  	.get_policy     =3D shmem_get_policy,
> > @@ -5295,6 +5319,7 @@ static const struct vm_operations_struct shmem_vm=
_ops =3D {
> >  static const struct vm_operations_struct shmem_anon_vm_ops =3D {
> >  	.fault		=3D shmem_fault,
> >  	.map_pages	=3D filemap_map_pages,
> > +	.page_mkwrite	=3D shmem_page_mkwrite,
> >  #ifdef CONFIG_NUMA
> >  	.set_policy     =3D shmem_set_policy,
> >  	.get_policy     =3D shmem_get_policy,
> > --=20
> > 2.39.5


--odzmi4uh2rsyvvsv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmk4K4AACgkQvP0LAY0m
WPHX8w/+LF/sRkV9GkZuIiCTm3dARfQYYA5sEFRR/SAK44U4sWNpR5fS2NgVBvk+
wr+2CyVTTNHauBm0GpUuKKyYQtrhof8pQKYyC2i8Jz0Ty1azn/Dvm2Y9D3rVUa8B
Oo7w+7kQr1ON8MdTPiV0ekjO2ru/YqIUMvsaNSuxyqALjlZ+oDTlpOCGnj9fb2Jf
Nd83pErmVChI/cg7kACHXiJmrUNJd1QeNmkbu2uGnAKq5+n9kjsfKaYOCTiOr+ex
HAhCKk2yRvDaZ7vtSAlOUBB7ZD4dXFe187Vqms8Wyw3q21ztAvWCLwEPkzWYdnS7
6O5Y9IHmwmW3ESFVl0fJcaSb4nVL2LZTtNYUecB88lV+LiMaBOeeDA8yeqcinMnP
yYkgw8EfI5qYrdsDjYAXC0L8FY3IMXgWXIKpf8rhCMp0fDp5IwID6ujma0lu2TaU
eQgBTD/y8seAQykOJ/+ORoCR0zMVdeA4qeaJkwWANExCX+jjjucsUtoZ1ADu0mu4
4Ir8WdHqEQaxdo+rxdgD/M4kU5zBd9fBcI0+OhFywEHD5R4+Au2wKbwaKlYRleKG
Bq1U4Az183uceHRMeVEigRYfYmpCqSkhQTcrq+JfxkFbr72JSogt5CKcu21QQgXI
rWRQThCmT8heUpjiWNEI8B5eOL5TJkmeyPCaK2qU59E/K5oviXc=
=IeM0
-----END PGP SIGNATURE-----

--odzmi4uh2rsyvvsv--

