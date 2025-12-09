Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA046D3B7F4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 16:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1302C6B0006; Tue,  9 Dec 2025 11:50:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1AD6B0007; Tue,  9 Dec 2025 11:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39116B0008; Tue,  9 Dec 2025 11:50:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB98C6B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 11:50:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6928484D92
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 16:50:00 +0000 (UTC)
X-FDA: 84200519760.07.9E8E5A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C0E3DA0003
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 16:49:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HJjOTpm2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765298998; a=rsa-sha256;
	cv=none;
	b=HoBpnG7SjRLbLVYsH0EfZqcMmzqD5oWDc/AE5Z5EOCkYoWo63GJNQ38QXGxnI7sjlVnzAo
	E3uCiUqyi1OXPaIP2EeTc+laonDwZuKwg8oX1HPtV1tnBSgro2/opT6kMYoUy5rTlnrOat
	I42/vKY4nWBIXXIj+d0WQRKs1pslIWs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HJjOTpm2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765298998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6buBg3qkfBGJ4lwdTN3deFRi/fkXG/oXgxI+TJ6Ig60=;
	b=PzX+qdf9UuL+zauEtiw1IT5npd/+sODalYSMKP7Rj/RaqhNyRDARWI5XEGoSiDYpK6jqlY
	vk5XZ1+EjXXQRqFhLUa4br9Qq6sPt7Cg9KIufyZZFI8s/fmaAsXA8fOlPEx9xlsKboVo0m
	o2V3hF90TII16CLuKTcgnXFUjP7htVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D2AC860127;
	Tue,  9 Dec 2025 16:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8E4C4CEF5;
	Tue,  9 Dec 2025 16:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765298997;
	bh=Fi78wc/8rnoNlreCtprcXsR18cJ0DDoUyGSanGb1RRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HJjOTpm2un+kyEU0/ywQtbHS8wwQye9QYslUGfHzpEghgFGb1qOs9CojnRpSrmnSV
	 ZKdjT74+9GHiUXpruZRNIUG9g/zbxlIYMAb3/utMhHV39M2zuNqTpvEfmNxm3C3q81
	 YVJ80JYsEcWa+y27dp+1JyF+ES01uHXTA27aHIrTHlvvz/ZR1/gy+ZY2oAIKm3RUuS
	 4uYLyek/yu0Dn+l0TnLkBXcRjFtd00r7yrcIZaeavLdqPgrvJ+5CYpmAm20+Da3goB
	 RqXSALzX97DUVkKLtiYlidha19mfi8u38DrGu0rQFAFZNUIcBr6aRiDQ8GArUKySrI
	 vUQSe71LrzXiQ==
Date: Tue, 9 Dec 2025 08:49:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tmpfs: enforce the immutable flag on open files
Message-ID: <20251209164956.GB89444@frogsfrogsfrogs>
References: <toyfbuhwbqa4zfgnojghr4v7k2ra6uh3g3sikbuwata3iozi3m@tarta.nabijaczleweli.xyz>
 <be986c18-3db2-38a1-8401-f0035ab71e7a@google.com>
 <mmfrclxjf2mmmohiwdbgqhyyrlab33tpnmtuzatk2xsuyiglrp@tarta.nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <mmfrclxjf2mmmohiwdbgqhyyrlab33tpnmtuzatk2xsuyiglrp@tarta.nabijaczleweli.xyz>
X-Rspam-User: 
X-Rspamd-Queue-Id: C0E3DA0003
X-Rspamd-Server: rspam10
X-Stat-Signature: 97jqrgyxanudodmyf7c81iobgct943mh
X-HE-Tag: 1765298998-700722
X-HE-Meta: U2FsdGVkX18iSWrfFvpx4NvCQS4AJP593KB9iaHY03zDRmsQSCF5IOYb3n3OgQEXwwX2nATAQYIRWsGNmrkDYN2N1aqT+3gIcjh+pOmhECtELSgP+N9LL5bO7VUhFUYChe3CQ+X4ZuT5Q/m35FBz8UHxy1ddsrW35DSxOO1DGT/E/CWs4H8+OTuIKXYSXUzNV8Wf9Ll8F4MS2BqhtuSXPF+CIPJkrFbh9MkBLKx/3p7wk4vASJtpf30kZcI/OK833XolGZ97WiN8YHnHr8Ajb7g77bL5gW7JuvWhYUarQwx/mTILfjXaz/fiw+pPLyGJJ7zYRESmjGuM9Xx2daWPOCHyRadGo9Zp6ywIeoHfyiIUehtiGMr2sExz8UTfEQm8Ru6KfH7U2qwPB/eo+d+qk+hsgPT32bZi9LIwccHjKR22qE4Y0BVRNKCl2kwEsYoGvTJy7yVCXiZEN5XihypHJHg5A9dOFqMkohY3tGaKwtDn43gygfH3cwsjtcz9IPNSV9ZJUNjN9aFAyJRebeVhXB+nKaI/U7J+QQWjFhuGIg7hx4z40NcrTVGsFaUJQgHrBqm0LF6xcAH+2wbvAlHn7k+huciGEf0qCp3B4Fypzy9sFmbZ0SS8e9t9Aqqz5eFvqcmIMYHcdyI0e1sscRTuCLUiWT9KJQNx7/BYY09phvWWdlhNmnliRo+srXEOGX3DrdQKFJEHltVIdTC/wWIgLqngJkcHpmjd/qEII2KevcSUA6RL++CwthqFhE3g1sRXyTTU00V+7/9tOXY/rvrU2SXiKpCkxU0N+vr/ae7k+/DKdKVIZAmw7hkmcxMkt26R1LEJp1rlq/RKBKePKLfgKA9ObXQUIYn0mbVU5zHGJxnFLDzjD7PahGyPFm4pjLYGxbtZ32VeYRY8d9JGZLup4pnltkdCD2ci1wPQP46R0YlEa4QhHew/mnWYduN00Exl4fNMEgowtNbts8ZpakP
 /aeZDIMo
 8i83tRlxBaQeQ3zMTzju5NMhBhYHuwTBAtNO94sVCulrrV9Qpu3hNjJRhdAlB2zAiXmyC3MIWi59ZPwLMh1EN5Lg1WOhE31yy23/sd691riFj9Uw6L6QVToAhZQmZY8Eqi4Qo/6vxFrrAG8K66tLciHYLU3jKNQVZjmzMzGo0G4rnz3rGlZOcwIdAWfgtYSL7GaGOUdG2vR2j37gfR7jZIgsGXPQgquCSHLh2wcBumENlbn6YKbYopSpgWqhjvI8HA3/1pKP294pAOhIk1IucketsoaUlMhzwyz6mUhygCaAJtJwm9G1y2bGjReCiFtvNaHnFyin29BUSzlx83zg8OkOQI8iHb4G6XDdGaPWv2I1K8GNMah4/qlbGWH4995vQi/J0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 03:00:35PM +0100, Ahelenia Ziemiańska wrote:
> On Mon, Dec 08, 2025 at 08:14:44PM -0800, Hugh Dickins wrote:
> > On Mon, 8 Dec 2025, Ahelenia Ziemiańska wrote:
> > > This useful behaviour is implemented for most filesystems,
> > > and wants to be implemented for every filesystem, quoth ref:
> > >   There is general agreement that we should standardize all file systems
> > >   to prevent modifications even for files that were opened at the time
> > >   the immutable flag is set.  Eventually, a change to enforce this at
> > >   the VFS layer should be landing in mainline.
> > > 
> > > References: commit 02b016ca7f99 ("ext4: enforce the immutable flag on
> > >  open files")
> > > Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
> > Sorry: thanks, but no thanks.
> > 
> > Supporting page_mkwrite() comes at a cost (an additional fault on first
> > write to a folio in a shared mmap).  It's important for space allocation
> > (and more) in the case of persistent writeback filesystems, but unwelcome
> > overhead in the case of tmpfs (and ramfs and hugetlbfs - others?).
> 
> Yeah, from the way page_mkwrite() was implemented it looked like
> enough of a pessimisation to be significant, and with how common
> an operation this is, I kinda expected this result.
> 
> (I was also gonna post the same for ramfs,
>  but it doesn't support FS_IOC_SETFLAGS attributes at all.)
> 
> > tmpfs has always preferred not to support page_mkwrite(), and just fail
> > fstests generic/080: we shall not slow down to change that, without a
> > much stronger justification than "useful behaviour" which we've got
> > along well enough without.
> 
> How do we feel about just the VFS half of this,
> i.e. open(WR)/chattr +i/write() = -EPERM?
> That shouldn't have a performance impact.
> 
> (I'll admit that this is the behaviour I find to be useful,
>  and I was surprised that the ext4 implementation also made mappings
>  SIGBUS, but I implemented both out of an undue sense of completionism.)
> 
> > But it is interesting that tmpfs supports IMMUTABLE, and passes all
> > the chattr fstests, without this patch.  Perhaps you should be adding
> > a new fstest, for tmpfs to fail: I won't thank you for that, but it
> > would be a fair response!
> 
> I rather think having IMMUTABLE but not atomically perfusing it
> to file descriptions is worthy of a test failure.
> The mmap behaviour, not so much.

If tmpfs isn't going to implement the same FS_FLAG_IMMUTABLE behaviors
as all the other filesystems then you should remove support for setting
the flag at all and leave a comment that minimizing fault latencies was
more important to the maintainer, so that nobody gets any smart ideas
about adding it back in.  Better not to advertise support than to have
quirky sh*t all over the kernel.

--D

> > Hugh
> > 
> > > ---
> > > v1: https://lore.kernel.org/linux-fsdevel/znhu3eyffewvvhleewehuvod2wrf4tz6vxrouoakiarjtxt5uy@tarta.nabijaczleweli.xyz/t/#u
> > > 
> > > shmem_page_mkwrite()'s return 0; falls straight into do_page_mkwrite()'s
> > > 	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
> > > 		folio_lock(folio);
> > > Given the unlikely, is it better to folio_lock(folio); return VM_FAULT_LOCKED; instead?
> > > 
> > > /ext4# uname -a
> > > Linux tarta 6.18.0-10912-g416f99c3b16f-dirty #1 SMP PREEMPT_DYNAMIC Sat Dec  6 12:14:41 CET 2025 x86_64 GNU/Linux
> > > /ext4# while sleep 1; do echo $$; done > file &
> > > [1] 262
> > > /ext4# chattr +i file
> > > /ext4# sh: line 25: echo: write error: Operation not permitted
> > > sh: line 25: echo: write error: Operation not permitted
> > > sh: line 25: echo: write error: Operation not permitted
> > > sh: line 25: echo: write error: Operation not permitted
> > > fg
> > > while sleep 1; do
> > >     echo $$;
> > > done > file
> > > ^C
> > > /ext4# mount -t tmpfs tmpfs /tmp
> > > /ext4# cd /tmp
> > > /tmp# while sleep 1; do echo $$; done > file &
> > > [1] 284
> > > /tmp# chattr +i file
> > > /tmp# sh: line 35: echo: write error: Operation not permitted
> > > sh: line 35: echo: write error: Operation not permitted
> > > sh: line 35: echo: write error: Operation not permitted
> > > 
> > > $ cat test.c
> > > #include <unistd.h>
> > > #include <fcntl.h>
> > > #include <sys/ioctl.h>
> > > #include <linux/fs.h>
> > > #include <sys/mman.h>
> > > int main(int, char **argv) {
> > > 	int fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0666);
> > > 	ftruncate(fd, 1024 * 1024);
> > > 	char *addr = mmap(NULL, 1024 * 1024, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> > > 	addr[0] = 0x69;
> > > 	int attrs = FS_IMMUTABLE_FL;
> > > 	ioctl(3, FS_IOC_SETFLAGS, &attrs);
> > > 	addr[1024 * 1024 - 1] = 0x69;
> > > }
> > > 
> > > # strace ./test /tmp/file
> > > execve("./test", ["./test", "/tmp/file"], 0x7ffc720bead8 /* 22 vars */) = 0
> > > ...
> > > openat(AT_FDCWD, "/tmp/file", O_RDWR|O_CREAT|O_TRUNC, 0666) = 3
> > > ftruncate(3, 1048576)                   = 0
> > > mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0x7f09bbf2a000
> > > ioctl(3, FS_IOC_SETFLAGS, [FS_IMMUTABLE_FL]) = 0
> > > --- SIGBUS {si_signo=SIGBUS, si_code=BUS_ADRERR, si_addr=0x7f09bc029fff} ---
> > > +++ killed by SIGBUS +++
> > > Bus error
> > > # tr -d \\0 < /tmp/file; echo
> > > i
> > > 
> > >  mm/shmem.c | 25 +++++++++++++++++++++++++
> > >  1 file changed, 25 insertions(+)
> > > 
> > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > index d578d8e765d7..432935f79f35 100644
> > > --- a/mm/shmem.c
> > > +++ b/mm/shmem.c
> > > @@ -1294,6 +1294,14 @@ static int shmem_setattr(struct mnt_idmap *idmap,
> > >  	bool update_mtime = false;
> > >  	bool update_ctime = true;
> > >  
> > > +	if (unlikely(IS_IMMUTABLE(inode)))
> > > +		return -EPERM;
> > > +
> > > +	if (unlikely(IS_APPEND(inode) &&
> > > +		     (attr->ia_valid & (ATTR_MODE | ATTR_UID |
> > > +					ATTR_GID | ATTR_TIMES_SET))))
> > > +		return -EPERM;
> > > +
> > >  	error = setattr_prepare(idmap, dentry, attr);
> > >  	if (error)
> > >  		return error;
> > > @@ -2763,6 +2771,17 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
> > >  	return ret;
> > >  }
> > >  
> > > +static vm_fault_t shmem_page_mkwrite(struct vm_fault *vmf)
> > > +{
> > > +	struct file *file = vmf->vma->vm_file;
> > > +
> > > +	if (unlikely(IS_IMMUTABLE(file_inode(file))))
> > > +		return VM_FAULT_SIGBUS;
> > > +
> > > +	file_update_time(file);
> > > +	return 0;
> > > +}
> > > +
> > >  unsigned long shmem_get_unmapped_area(struct file *file,
> > >  				      unsigned long uaddr, unsigned long len,
> > >  				      unsigned long pgoff, unsigned long flags)
> > > @@ -3475,6 +3494,10 @@ static ssize_t shmem_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > >  	ret = generic_write_checks(iocb, from);
> > >  	if (ret <= 0)
> > >  		goto unlock;
> > > +	if (unlikely(IS_IMMUTABLE(inode))) {
> > > +		ret = -EPERM;
> > > +		goto unlock;
> > > +	}
> > >  	ret = file_remove_privs(file);
> > >  	if (ret)
> > >  		goto unlock;
> > > @@ -5286,6 +5309,7 @@ static const struct super_operations shmem_ops = {
> > >  static const struct vm_operations_struct shmem_vm_ops = {
> > >  	.fault		= shmem_fault,
> > >  	.map_pages	= filemap_map_pages,
> > > +	.page_mkwrite	= shmem_page_mkwrite,
> > >  #ifdef CONFIG_NUMA
> > >  	.set_policy     = shmem_set_policy,
> > >  	.get_policy     = shmem_get_policy,
> > > @@ -5295,6 +5319,7 @@ static const struct vm_operations_struct shmem_vm_ops = {
> > >  static const struct vm_operations_struct shmem_anon_vm_ops = {
> > >  	.fault		= shmem_fault,
> > >  	.map_pages	= filemap_map_pages,
> > > +	.page_mkwrite	= shmem_page_mkwrite,
> > >  #ifdef CONFIG_NUMA
> > >  	.set_policy     = shmem_set_policy,
> > >  	.get_policy     = shmem_get_policy,
> > > -- 
> > > 2.39.5
> 



