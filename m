Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4461606B39D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=ewyRCCg3
Received: by kanga.kvack.org (Postfix)
	id 7B9246B05B1; Wed,  4 Nov 2026 17:23:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769236B05B2; Wed,  4 Nov 2026 17:23:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6573A6B05B3; Wed,  4 Nov 2026 17:23:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 389DA6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:23:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DA7FA0875
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:23:55 +0000 (UTC)
X-FDA: 85398865230.28.419F74B
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id B90D8140009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:23:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=ewyRCCg3;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793831033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeZ2aB0X0IqNy32Bwapb83gUzvOHb7jOV5nmidAoLRQ=;
	b=fMRZGMfLl6LGyr0gdcHrEXC9k/RpgwY4syrfRYhiZBmlOX3S/emZMUt+TfVg437+tzEfg4
	EzYA4VZXeyMe4gK/5fn/dPreb1BAVgqlcwVgzn5Ja44HV8t8yjO7Prj/zlSYFZacxOpYOT
	8h5LQhhByirVV6d/Ffwp4F2A2hR7/jU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793831033;
	b=MFmNnahgKLjtSK5NurpAji1KhsWp76ZgcbIQ8WncSb6pYEC1Cre2hXUfrBAHU+bQPOXf8t
	w9lA4GbujdFTjJqBEyLTwDlr/5DmvskiCNT1dd1KaHv7YbXBxwDpyd0hSIrmMqsjkkvQ7l
	vH5lOOeZNn79PHiRTNsloxhVN1PO26I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=ewyRCCg3;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f3c616c84so109982885a.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793831033; x=1794435833; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KeZ2aB0X0IqNy32Bwapb83gUzvOHb7jOV5nmidAoLRQ=;
        b=ewyRCCg3dFkVg16a70sGS9bf1I4EaaBR5et7m2vmRmXD4qKf59bUWNBbEPYW8tvSWc
         VWmGUBqobIb0yVOWwiUUCS9ot6Ho3qElKoN+KSMD7R3EP1CceJ/YLbvYa4yOXpQKsUhs
         tyRn2HHuqBByOQEBbE8qzqcstBuAswDrhwd1oI1qEzyfPBiwA8VDT6CrjAhxuc754Yx5
         pLejQxjUotRJLwhqZ7tn8jsD7nalZCdgUERxwT8pnOtXHnn4pmzuf8MKH0jxddX5ApBk
         PB+OxwxRtTyfqEke4KpWBEH3lfzMDWlIhwPijwUreDoEA7y+PJQ9BcdcrSxwSfeS16Hq
         NgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793831033; x=1794435833;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KeZ2aB0X0IqNy32Bwapb83gUzvOHb7jOV5nmidAoLRQ=;
        b=ytt5OPigAKGS/8bYJoYpALHwqj57p/f+Zla2HqXXiugMc74ZZR3evhXZ3cOrrzdd7c
         CIyX/pWXdANg//6vce9iGJBrx5BoQIF/1FAzJ6BpDPVNzrfqdN1gdYI+Zexqkmm3rw7d
         VgL14wJWzEU7gavJ1VUwm1KkzQIg3mfYIPo+Ahf3y47Hi0KnqsrYdp4EEzQnHbVwvftz
         Te0lXLnxns4Bpoxj+3bMo06lgf67YZIcwk0vFQHioohWU/dHpFbIyX2f7BWlw/nbmfXf
         1qSWeIyytuHw/w5hyy5NicKjTx9laPsEPDZtqdug6g4L9JGiiDS39lADq/EvwqG/qUd4
         N1Kg==
X-Forwarded-Encrypted: i=1; AKwUvBznBVyqusNiJBr97HOuuoWBJCU96WnE1zsroIX3GO9wrDTgquA7ZbuSFjPO+P91iENO/IBc1DAXQA==@kvack.org
X-Gm-Message-State: APuU4Z+mFg8ETQzofs9ERM4hV45Jm2uSoVVucDY/H9jVUAT+mz8ZY16k
	K3ljmhc+T2ypkCw2SWu4gE/rUMkvv2C1cOJM5f7RmRLECG1V4jgErQ2sYxbHgjRKp/Q=
X-Gm-Gg: AYBFou2qyVCUheK5a/wxVYfVsLufQNuCB3Lw6WwTW1DSZXrz38vPgS5dmfwze97DJV2
	7fZXWnPztKjUmKlR3ePI85CT4Ik5uXOqF9lrfIjZDVN26XJyfipiprB6PjqYFvvf0OzZ5THEono
	cbmLmFRZGzdt913Z2bXzWDvz8KfLvYtIYDoyNK3jSTUYFtkIuq324+cesN5ecZ+V4y2ZK2ZQhPM
	EJc5Krd/RNEF3WUaNtlJA7iF1HBjsh/CCUjaeZdQrvlPuApehDI307nIRQRhKAphionQNtIdDxy
	joiawgzldIbXGvCuH8LHS8O3IVkDE5/pFndzUp/XvvDQmonUsnVc3fiRXhgztbRLp/khGR/pr+i
	xqsdYy18qpgM0cA7twC+bGZpChPV3sfEqF0tfOUlGIzt7UhKYcN4OL49H21oDGfdZ/Ftv00a9y6
	KAjSZPk6+aRqnphr16Hj9D4p0N7gyUBn7twuWSmvX6vBVFpLtkNgsOQ5CpoEd5DRq20oLjuahCc
	XOUfznVTSy/lfAk5ikVUYszQT11J7SmzEFxYJowSGdaEHMK7bEOGV8k5xiCyc0Q7C/9iTT+3IzG
	wtzjuLsJW7JuFbiNvUlh5DWfrldLy7ctO7VLiiZPqSxbZw==
X-Received: by 2002:a05:620a:608d:b0:93c:7e9c:3bba with SMTP id af79cd13be357-944216bd4bdmr3093198785a.41.1793831032557;
        Wed, 04 Nov 2026 14:23:52 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d4691a76sm312610285a.4.2026.11.04.14.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 14:23:51 -0800 (PST)
Date: Wed, 04 Nov 2026 22:23:51 +0000
Message-ID: <464ef986eab97abf226791c7e19ad111.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>,
 Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
 Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>,
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>,
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
 linux-kernel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-sound@vger.kernel.org, linux-mm@kvack.org,
 Chuck Lever <chuck.lever@oracle.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH RFC 0/7] proc: move procfs to what kernfs does
In-Reply-To: <20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner>
References: <20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3nw5jt9dgsgrdsrrwgbbdhiq178n9rda
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B90D8140009
X-HE-Tag: 1793831033-287655
X-HE-Meta: U2FsdGVkX197efTGGZZm6sfQjbcdQYo3Pgbfi7R7y5TJn2H0CXHwbLik7XFbDRsMEv8KyprZqVTs6gFwSOZYcZ5YYmuRuQ2CKLrJx8A+CmHg+CGZrCBuhnUavqiS8B2IiN8jyo/EHMBlfjDjEoUqxG9aGkiRtPXorifXHDmDtJlbtc7JpplnvtES+9ssHjhGs05KVxia3vA4IKx3HhD6QEAQNZpubQyHTxsIX4sV4pC3ipZL+PG4kzaIW5L+C1WuPIZ3Z+mfeoQC1uCQNb1yP0BUe4jg2oUlCDvzLIdSpO39/CcmSHZ4qTX8E2c2AOeaUuc+GiZR8DyUor3QQKxkP6AfaDEghYqWCL0hwyORezSBdICC0WJ76VV2KXsjzlfMXLzwy2Fur2BHTXjBRk9Mrn2am7SgkukX6c+NxCANbeQXjb/7dYgu/OjHGLc6YkY//AGhOzfGz7BI4wdm+avRB/W6BfV+hxMGQ4P/T8UE6Bh8JhczAeFklTA3MMV2+n0RZ+eArQjy4HyeYlXnKC1tlXEtQq42dol4GQ0yNE0Jz0OrbZcP6vUHhGFVPVz2cC0bPWibwYLB2vc+qm6Gt5Pa0IwPbsmQrK1oolRGB0COFFGt3ViukWt0e/jSz0wU7EFmfVLKSOsFy+oZCSzRkB8bd7ZQ4so3Tp5TQLuhvUG7HDuR+C8OuSFQR+PrqhOpfJPbMlmsouQ+bYtGdDsYRrluwKmSh6WxShUJ8CsUKzw14lNSZGdrUJd+ZkbhSx3HsOow/qZfMoBfDW7zR+wqcei6tI1vxa7AaKvg4rhoPLlT/1Kj/LHeEfRbwkJ4bvz2u7JVRm92zWK0CPwCMq2pa/AixwQRCkJwz1dMhWUKhKqDFH19decAooaAy7uxbVUDXf115q637/pzDQ1Xc1nrMoMu53Qx+rWxtOYFgXgpY1upIuqhEFMW5y+KmfjXW401+1d3g2Z8SMa0Sw+UxLxi/MQ
 +GCaWKWo
 4jJu/YyRGOsyKEetoc4WH55ncjp0aBWSyhwI5zYdae534xTpUeR00WgFwGZyUNqgFNTPfL8OUWUanAVYujlYUGAZG/GbwWEKIBbcESnQA+pKYub5xwtm3HnlaaA0isif5hb0E5v500pfBWcKXCt27VIsK9n58rQ3bsIuRXCsdpZlVQFZoerrhS9uLv3bNp+33GWTr0b0cYtSiVUUNWzC86VKB7sXu9ZhXTTaMorGS6q/rPIPciKxeIa8oh9T8B6BgQeyCwwwzD/o9FlJPeOuKQVBdEXSFn4wgI9aDGh+YGQ/KJ6wMk2obafx60A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hey Christian,

This is a summary of my Claude review of everything.  It didn't find
anything wrong with the conversions in parts 3 to 6, the findings are in
part 1 and on the procfs side.  1-3 are reproduced in a VM, 4-6 are from
reading the code.

1) bugfixes 19/38 ("proc: resume readdir after the last name it
   returned")

proc_readdir_de() now returns 1 instead of 0 when there's nothing left
to emit:

	if (!de) {
		read_unlock(&proc_subdir_lock);
		return 1;
	}

proc_root_readdir() needs that to go on to the pids, but proc_readdir()
and proc_tgid_net_readdir() are also the ->iterate_shared() of every
other directory, and iterate_dir() hands the value to its caller.
getdents doesn't look at it, old_readdir() and the compat one do:

	error = iterate_dir(fd_file(f), &buf.ctx);
	if (buf.result)
		error = buf.result;

	return error;

So at the end of the directory readdir(2) returns 1 without having
written a dirent, and keeps doing that.  This is syscall 89 through
int $0x80 in a loop on x86_64 with IA32_EMULATION, giving up after
100000 calls:

	             base, 18/38         19/38, whole series
	/proc        106 entries, 0      106 entries, 0
	/proc/fs       4 entries, 0        4 entries, 1 from then on
	/proc/net     31 entries, 0       31 entries, 1 from then on
	/proc/sys     10 entries, 0       10 entries, 0

/proc/bus, driver, irq, tty and self/net do the same as /proc/fs.
glibc doesn't use that syscall, but this patch is tagged for stable.

proc_readdir() has to keep returning the 1 for proc_root_readdir(), so
I think proc_dir_operations and proc_net_operations want a wrapper that
turns it into 0.  The comment above proc_readdir_de() that says the VFS
doesn't care about the return value should go as well.

2) cleanup 5/5 ("proc: drop the _buf suffix from the new methods")

4/5 renames the old ->proc_read() so that "A module that sets one of
them doesn't build anymore".  5/5 hands the name to the new method, and
the old and the new prototype only differ in __user:

	ssize_t (*proc_read)(struct file *, char __user *, size_t, loff_t *);
	ssize_t (*proc_read)(struct file *, char *, size_t, loff_t *);

Only sparse sees that.  The compiler does reject an old ->proc_write()
or ->proc_ioctl() (gcc 13, clang 18), but this

	.proc_open	= foo_open,	/* single_open() */
	.proc_read	= seq_read,
	.proc_lseek	= seq_lseek,
	.proc_release	= single_release,

builds without a warning with W=1.  pde_set_flags() only refuses the
release helpers for seq_file entries, which this isn't one of, so it
registers too.  With a module that has exactly that loaded on top of the
series there's no warning, open() works and every read() fails with
-EFAULT.

The tree had 84 of those at your base.  None are left, but whatever is
in flight in other trees, gets backported or lives out of tree ends up
there without anybody noticing.  Either the read method keeps a name of
its own or pde_set_flags() refuses seq_read, and either way this
probably wants an entry in porting.rst.

3) bugfixes 38/38 ("selftests/proc: check that a faulting readlink()
   doesn't hold up removal")

This adds proc-remove-slow-reader to the Makefile and to .gitignore
along with proc-remove-slow-readlink, but proc-remove-slow-reader.c
only shows up in core 08/16.  From here up to core 07/16 make says

	make: *** No rule to make target '[...]/proc-remove-slow-reader'.  Stop.

in tools/testing/selftests/proc, so also with part 1 applied on its
own.  The two lines want to move to core 08/16.

4) core 04/16 ("proc: let procfs own the seq_file of seq_file entries")

pde_seq_start() returns right after it unpinned, pde_seq_next() goes on:

	v = pde->seq_ops->next(m, v, pos);
	if (v == ERR_PTR(-EIO))
		pde_seq_stop_pinned(m, v);
	/* seq_file would blame these seq_operations, blame the entry's */
	if (*pos == old) {
		pr_info_ratelimited("buggy .next function %ps did not update position index\n",
				    pde->seq_ops->next);
		++*pos;
	}
	return v;

core 16/16 documents that next() may return ERR_PTR(-EIO).  A next()
that does and leaves *pos alone is called buggy for it, and
pde->seq_ops is read after the unpin, when the module it points into
can be gone.  Nothing in the tree returns -EIO from next() today.  A
return v after pde_seq_stop_pinned() takes care of both.

5) bugfixes 35/38 ("proc: sysctl: don't hold the tables while readdir
   copies to userspace")

	while (err > 0) {
		if (!d.skip) {
			err = proc_sys_fill_dirent(file, &d);
			if (err)
				break;
	...
	sysctl_dir_done(&d);
	return 0;

sysctl_dir_next() only pins the memory, so the entry can be unregistered
before proc_sys_make_inode() looks at it and returns -ENOENT.  The loop
breaks without moving ctx->pos and returns 0.  If that was the first
entry of the getdents64() call userspace sees the end of the directory
and loses everything behind it.

The old code bailed out the same way, so it's not a regression, but
it's the "terminated early" case you set out to fix and these are the
lines that get rewritten.  Handling -ENOENT like d.skip would carry on
after that name.  -ENOMEM probably wants to be returned instead of
turning into EOF.

6) stable tags, bugfixes 34/38 and 37/38

34/38 has no Fixes: or stable tag and says "No functional changes", but
35/38 is tagged for stable and depends on it.  Without 34/38
proc_sys_make_inode() reads table->mode and calls ->set_ownership()
after it dropped sysctl_lock, and the caller 35/38 adds doesn't keep the
table registered.  35/38 applies cleanly without 34/38, so nothing will
complain if only the tagged one gets picked up.

37/38 has Fixes: 7e0e953bb0cf, which is 4.0.  "the inode holds a
reference to the entry" only covers RCU walk since 47458802f660
("procfs: move dropping pde and pid from ->evict_inode() to
->free_inode()"), which went into 6.8.  Before that the inode drops the
entry in ->evict_inode() without a grace period, and the pin is what
keeps ->data around for a walker that got it from ->get_link().  Which
stable trees have that commit isn't something I checked.

Smaller stuff:

- The cursors in bugfixes 19/38 and 31/38 hang off an open file and
  anybody can have as many as they have fds, so GFP_KERNEL_ACCOUNT.

- copy_to_user_fromio() has no callers left after drivers 22/23.

- fs 07/27 says ntfs_set_label() refused a label that's too long with
  -ENAMETOOLONG or -EFBIG.  It doesn't always, cpu_str.len is a u8 and
  ntfs_nls_to_utf16() is allowed (PATH_MAX - 2) / 2 here, so 300
  characters come out as 44 and pass the check.  That's an old ntfs3
  bug, it's only the sentence in the changelog.

Two more old ones that you might want in part 1, the series doesn't
change either of them:

- allocinfo can deadlock against a module load.
  codetag_alloc_module_section() calls reserve_module_tags() with
  mod_lock held for write, and its three error paths call
  shutdown_mem_profiling(true) -> remove_proc_entry("allocinfo"), which
  waits for the readers.  A reader that's pinned and in
  allocinfo_start() -> codetag_lock_module_list() sits in
  down_read(mod_lock).  There's no copy to userspace involved, so
  moving the copies out doesn't help this one.

- snd_info_text_entry_write() allocates the larger buffer and frees the
  old one without copying what's in it, so a text entry written in
  pieces loses the start once it crosses a page.  It's been like that
  since ffb73b08e794.

For what it's worth the end state checks out.  Every proc_ops
initializer in the tree matches the final struct, the only entries that
still read straight into userspace are kcore, kmsg, kpagecount,
kpageflags, kpagecgroup and profile, all built in and never removed, and
nothing in the tree trips the new checks in pde_set_flags().

This part is me. I have a selftest that my claude wrote to validate #1.
If you want I can send it along, but we should probably have a test for
that.

Thanks,
Josef

