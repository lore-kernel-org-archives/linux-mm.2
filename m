Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E88ADCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF3546B0092; Thu, 15 Oct 2026 14:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D846B0095; Thu, 15 Oct 2026 14:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C456D6B0096; Thu, 15 Oct 2026 14:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0136B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:55:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82860A7204
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:54:52 +0000 (UTC)
X-FDA: 85325762424.18.594D9E7
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id AA7D340006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:54:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kLylG9d1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792090490;
	b=hO/3Y8/g8rzUlhIUGrKBU8hubr5l0+TumxihUw3/r1M0c6E71noPFbhjYvRcqyBn6lqFoD
	4/xeoQCzuUMQcv4G6O9qAHLQteTkNm8GOHXhrNY12ONpR4X9P6G0sPBs/DCe6ffUTbL+2n
	HMy+Ti49lF4rQKDm0pjvIFYuTJDc0So=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kLylG9d1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792090490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IltlA15ffn2teEWgoeALmwOWBDbtdgaPXsnTGsD5rwo=;
	b=cIAgK0eCok7YU3wKOXoRBelNz5sTsKNO0lIlnB9HrPjqyOZXEf5/PVYQlC4jawILGwdbwP
	2tYVFWMa5V+mYWll2m2o7p9IJ7kE/QzWaGQzgZ0dlDU+YKnElKBmg+pRbu4YKNa71vEDIG
	Qg2o2g6JQrh6AME33Ne7zWj+Y6EiuLE=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso1965831a91.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792090489; x=1792695289; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IltlA15ffn2teEWgoeALmwOWBDbtdgaPXsnTGsD5rwo=;
        b=kLylG9d1tbD5Rkm8RDC1lqVbKA0rtE0gP4jfE0xGSo8QZkFTyF/HIIEhy5GL6t5nW+
         mnmz2ECuk12gs691YM1EmQD5HKicvG06CBc2WvdTfL5+n+YcDFXB6nGE6xivVDt2Rq/P
         CZFKLfrS44/z0l6siAokgnlBisEYjBy1QaDQVBr/cmSdxrNr4wEqPJz3mPQY70pwdc70
         pVMOiADfp41JnVj8WJBCNZYC2RvxaszQ6zvbt4t1hzYGrkQayv9xCcvYzRc+tQs/RR1Z
         Fyg0bfWmXDjErnmS8iKgEmclxrH7KIc2iSQg+GJARZd5/t+EzfRtc8OkQdNoNXNL/o1l
         mlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792090489; x=1792695289;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IltlA15ffn2teEWgoeALmwOWBDbtdgaPXsnTGsD5rwo=;
        b=uf5FQaAprYZpxQqdhP4k4AVp+5KbMc+LUaBIsHdmYuppCtESWV7cr0WzlI24mGF5X/
         BAOzXsQONgi4sESFs9cm2CRyBAE9RaL1n7WMmoOhs4h+p7pkGLR2CUW3PKn3A+DzQ3j0
         rlGv9WMBp5AstLLxSYQ+y+WM5SimnlHSRAET4EVuK9VEYX8TIiHOEksoysETEBcYPUsL
         7Q947/utvnpN/MnGrgkTt7BrJpcG8gwvY5+HO2AstrNFDLKwmAGfVHUBlLJr/urrdMHu
         o0ZpTazsw77XngamTmyoM9RFjl6dlDBrREj39xtzPwMTiT0znBjIMwBRKlYdFVil3Oky
         GekQ==
X-Forwarded-Encrypted: i=1; AKwUvBwNI6LAnoSdNmEkwZdpuS/6b7ILnOemmL+XJhzxosfhAVAs+a1+gawFGzGpOUaYVBDmBU857yjgaQ==@kvack.org
X-Gm-Message-State: AFq9FYJcFbJpOJkIzlkeJvFkBdZIkkxPA26ydDESozypEz13s9isQU+w
	sQH7nKXpW9CCWfO40m2ppsFOz4paxtkQ6OJzWg9IRXOql1a+DyJFoQ6PsUeQxxsC0A==
X-Gm-Gg: AYBFou2eKX30tn4sDEYGSI+x4qL4YewK1QJZudF0BFxDYO5UK2cyFF2mf8VrvVQhj40
	8izmLb2JJR2nbUGuLDlyQhvPtlgU6FXXJ8J7yFY2d2ae0b9kTR1zrw2QymjdhyQJEwN+T1+skw4
	1ndzyP7cGQsPYBf5VaO2B1+ebU9hZEDqaVlssSmP2twAycru+jKjOJA68cz8MP6LIWJzrv3Gdig
	30hFJzlQosw1E1g/beMG0jKwkmx77nj6DD7UI/olRT/Cg90QYgTF2w8OJM5feiavfOzMrEg/im+
	HCX9JsZa+bxeXuAJDYpHGUZgETGMtNNc9PbbGtGDuLdFEymuQcnibEhnyBtG/pAl1axiSj7gZPB
	TA6gUlF+dmXVqB8RYVHWoak8OnBy6Ver7lBpo/N3CbObKGoEwmCgPCtNwRv+NiDtakYPwn5NZyH
	d4tTYNG1n5wyqI+VnUTXiwortqHPd/PtohWsnFnuEeW+ioUcxxh4451ux8beBamPL+ux/5Psus8
	sZz0PLezqWGeGHQ/3qlXhDUhdOZnTk4dTk=
X-Received: by 2002:a17:90b:390d:b0:3ac:b6eb:e0d4 with SMTP id 98e67ed59e1d1-3acb6ebe1c9mr959297a91.63.1792090488544;
        Thu, 15 Oct 2026 11:54:48 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc46ecd32sm452704a91.3.2026.10.15.11.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 11:54:47 -0700 (PDT)
Date: Thu, 15 Oct 2026 18:54:43 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	pratyush@kernel.org, graf@amazon.com
Subject: Re: [PATCH v1 0/7] liveupdate: tmpfs preservation and early freeze
Message-ID: <atEhc20Zawj4D62x@google.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
 <atESAwf17pJ11S9U@google.com>
 <atEaPuWNOm5VLc7A@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atEaPuWNOm5VLc7A@google.com>
X-Stat-Signature: ipwnhzfay97sczrxzjsid44ixsay3zt3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA7D340006
X-HE-Tag: 1792090490-546698
X-HE-Meta: U2FsdGVkX1+g9mq/dju3XI19oaimUc58nE75P9UJKK+DI8HGiq+p8QKudz3HTY5Sfv8Rh9XinqKU1pE+n1sUi5uuluNWafEP0Wjx8U/owP+7+524ir8tBO26XDvr0CWPlvEUfjtPboMwfp044WL2KLdM9lUHZagM0JyWXUoooHwWm6U4eQDW42uZsM40N4Z4zALJX6eXc5OAbgEXGhGSZHhr4p1q+UT3tPW7WKjIrqAydGTi+srv4TQeOLlGg07UPB3H1nzv0vnkIDNWm01eiVGU5NY29OIFY3r9GwBSz7RqBBXPhyTim5E9Abd70/k+zxE1PECnIZOTTP5G7QRF2giDRDMZlwCYix45o3pxK3841T8s6gWu8dHoZyfrKjBLUgwThvNT240jXXTsXl8laTPJtSnh6uA3Ys+DPgM2lBTCgm3inXhAPb7GfuTdDNf8TaUCWD0nbci+54YAfd/aBqNEdzw35nguHChUsLx6hx36CTkY/oADIH0157RFXprpx2tsAD80y59kic0gCrfpXahV5EPKMLyhE6GskMVn0baPkZpr90udQi3UknXXqWzKS4rS/Y3RZPT4xIl105Cbg1tAQRwKkpzkswlkQFcy41fKxSjL28YertRnyzbbXkbJyHk8abGM5e/8HtGWfWusoHcFI+r18tI4b8pef+i9PzgT5vRleFh39gt0xBMIWOoPxC8jNc+F0bKzFcmvR1ctnvdSOlGh+FD4NUdV/9vyu9FHtyYBoaLevTRIM0TjRmzyiFnMZtmki3jOQ1CKyGIJ4ivL1xO12x+D5t/X83IGdBFd+Q0jsHE9+W3Kdy9Y+TnJdXbcszpgYQrRYbJunghLut2n5121/OzHyrc6FTuVO7U3kXepHl+xmD40JLXabpq8rQEPfJRG987vZgxczsI2WSNM9iJzTXBmUAQd8tVWWofvZjAHgD57Fbp8yIl8854lrT+g7evswjN7TC89RIH
 Je326Ko2
 ujgsibz/gY5clTtOEkNduwXPAtemYH6iCZA1IDJ9LVVi0xRalI0/1L3pAKlyWOqk0W2a43FqC0eM5JjABCJclod6gUW2dbSwAS6jK9lMZtRCNh7X/eASw7QKXiZSQM05s67Zq5KGFX4osZ6d9SaS3JpZbqmwBDo4e+Tdz6NWmf/4iauScO0dyCzGsWKttAFxi3lXtHuv3AY20eOZsBOSa601J6ofgfQO+hL8CFUeUmpnxD6tCM3sKdAe8hy9deLM/mT81+i2qCV3yp+TeRsvtY+lxV5bMez/E4tLn2FxN0W+KKZQTGkc5CkcON11u1BcudmQNPFWQc6BhXufdXh5xLIIJK8ov6WxPFU3ulaHY2KaDzag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-10-15 02:23 PM, Pasha Tatashin wrote:
> On 10-15 17:48, David Matlack wrote:
> > On 2026-10-15 05:38 AM, Pasha Tatashin wrote:
> > > This series allows preserving files in tmpfs via LUO to survive across a
> > > live update, and allows userspace to decide when to freeze a session
> > > instead of delaying until auto-freeze at kexec time. Once userspace is
> > > done with a session, it can freeze the session immediately (and across
> > > multiple sessions in parallel), reducing blackout time by not postponing
> > > this operation to kexec shutdown where all sessions are frozen serially:
> > > 
> > > 1. Early session freeze (LIVEUPDATE_SESSION_FREEZE):
> > >    Currently, LUO sessions are frozen automatically only inside the
> > >    reboot(LINUX_REBOOT_CMD_KEXEC) path, where luo_session_serialize()
> > >    iterates through all outgoing sessions under global write locks and
> > >    freezes them serially during shutdown.
> > > 
> > >    Add the LIVEUPDATE_SESSION_FREEZE ioctl on session file descriptors so
> > >    userspace can freeze a session as soon as it is done with it (and freeze
> > >    multiple sessions concurrently, since luo_session_freeze() only acquires
> > >    the per-session mutex). During kexec, already-frozen sessions skip the
> > >    late auto-freeze step; if an early-frozen session is closed before
> > >    kexec, its files are rolled back via .unfreeze() before being
> > >    unpreserved.
> > 
> > Thanks for putting this together. I'm on board with driving
> > retrieve-into through a per-handler argument instead of a LUO-level
> > flag. It's what Pratyush suggested on the RFC too (sorry Pratyush, I
> > never replied to that). I still need to review the actual patch but
> > I think the idea is fine.
> 
> Yeah, Pratyush and I discussed this at LPC. I've been using this extra
> argument in my cpu_preserve series to launch jobs at a given entry
> address on a preserved CPU, and figured it would be a useful, generic
> interface for others as well. So I decided to send this series now to
> reduce the extra infrastructure I carry in my cpu_preserve series, and
> your tmpfs work was a good reason to land it now :-)
> 
> > However, nothing ties the arg struct to a handler, it's interpreted by
> > whichever handler owns the token. At LPC we discussed letting userspace
> > pick the handler in PRESERVE_FD/RETRIEVE_FD, so that it controls which
> > one is used when more than one can take a file. If we do that, the
> > handler name would also be the natural key for which arg struct is
> > expected.
> > 
> > > 3. Tmpfs file preservation and retrieval:
> > >    Using the file handler retrieve argument, extend mm/memfd_luo to allow
> > >    preserving generic shmem-backed tmpfs files (not just unlinked memfd
> > >    pseudofiles), recording MEMFD_LUO_FLAG_TMPFS in
> > >    struct memfd_luo_ser.flags so that preserved tmpfs files must be
> > >    retrieved as tmpfs files and preserved memfd files must be retrieved as
> > >    memfd files.
> > 
> > I've been working on a v1 of the tmpfs preservation since LPC. v1 fixes
> > a number of problems in the RFC that I think this series still has
> > (sorry for the wall of text, it is LLM-generated):
> > 
> >  - Failures that userspace can fix lose the file. The folios are
> >    restored, charged and added one at a time, so if the target's mount
> >    is too small (ENOSPC/quota) or the caller hits its memcg limit
> >    partway through, the target is truncated, the folios are freed, and
> >    the failure is permanent. Only bad-argument errors are retryable.
> >    v1 restores all the folios first, charges all the blocks and memcg
> >    up front, and adds all the folios to the page cache or none of them.
> >    It keeps the restored folios in private_data between attempts (LUO
> >    needs to pass private_data to .retrieve() and keep it on failure),
> >    so the only permanent failure left is losing the KHO state itself.
> 
> I think the current behavior is fine: if the file doesn't fit when
> restoring, I think it is okay to lose the file permanently. We shouldn't
> keep preserved data around in private_data once we have started
> retrieving folios.

Ok I think we can omit keeping restore folios in private_data across
retry attempts. It is a bit subtle.

> >  - memfd_pin_folios() doesn't require the inode lock, so iommufd can
> >    pin folios of the target while they're being added or truncated
> >    away. v1 starts with two patches that make iommufd take the lock
> >    and make memfd_pin_folios() assert it.
> 
> Hm, isn't this mostly orthogonal to the change we're making here?

Kind of. Today .retrieve() fills a brand-new memfd that nobody else can
reach until the ioctl returns. Retrieve-into fills a file that other
processes can already open by path and pass to iommufd, so pinning can
now race with the folios being added, or truncated away on failure.

In the failure case a folio can stay pinned (and mapped for DMA) after
it's been removed from the file. Retrieve-into introduces the race, and
the fix is two small prep patches.

> >  - The target has to be opened for writing (FMODE_WRITE). Since LUO
> >    holds a reference to it until finish, that means a restored binary
> >    can't be executed until the session is finished (-ETXTBSY). v1
> >    instead requires mnt_want_write_file() and file_permission(MAY_WRITE)
> >    under the inode lock, like FS_IOC_ENABLE_VERITY. That also rejects
> >    immutable files, which a fd opened for writing before chattr +i
> >    doesn't.
> 
> Ah, good point.
> 
> >  - There's no file_modified() or fsnotify_modify(), so setuid/setgid
> >    bits aren't cleared and timestamps aren't updated. The normal write
> >    path does both.
> 
> That is true, though I'm not sure fsnotify_modify() is really needed
> since the whole file is restored at once and I doubt anyone is watching
> for modifications during restore (clearing setuid/setgid via
> file_modified() makes sense, though).
> 
> >  - f_pos is set through fget() + vfs_setpos() without f_pos_lock, which
> >    races with read()/lseek() on the same open file. v1 uses
> >    fdget_pos(). (Sashiko called this an ABBA deadlock. I don't think it
> >    is one, since vfs_setpos() doesn't take the lock, but the race is
> >    real.)
> 
> Right, this was reported by Sashiko; I haven't looked into it yet.
> 
> > 
> >  - Early failures leak the preserved folios. The seals/flags check
> >    frees ser and records a permanent error, so .finish() skips the file
> >    and the folios are never freed. Sashiko flagged this as well. The
> >    new MEMFD_LUO_ALL_FLAGS check adds another way to get there. In v1,
> >    early failures don't consume anything and aren't permanent, so
> >    .finish() cleans up.
> 
> We originally agreed that if retrieve() fails, we fail permanently and
> leak resources until reboot to avoid memory corruption from ongoing DMA
> activity. However, now that we have the retryable option, we can start
> relaxing what is considered a permanent failure vs. a recoverable/early
> failure that .finish() can clean up.

Ok I think we are ligned that we need to keep the preserved folios
around until finish(). I think this point was saying there are bugs in
the existing memfd_luo code and in this series that leak the folios even
after finish(). Either way I'll fix them up.

> 
> >  - If a token was already retrieved, luo_retrieve_file() returns the
> >    existing file and ignores arg. Userspace that asks to retrieve into
> >    X gets success and an fd for a different file. I think LUO should
> >    fail with -EBUSY if an arg is passed for a token that was already
> >    retrieved.
> 
> Agreed, if an arg is passed for a token that was already retrieved,
> failing with -EBUSY (or -EINVAL if the target file doesn't match the
> originally retrieved struct file) makes sense.
> 
> 
> >  - Sashiko's WARN_ON(liveupdate_claim_file()) report on 3/7 is valid:
> >    xa_insert() can fail with -ENOMEM there, and userspace can trigger
> >    that.
> 
> Yeah, we can address that.
> 
> > One place our series are not aligned is MEMFD_LUO_FLAG_TMPFS. My
> > thinking has been that RETRIEVE_FD should support retrieving into any
> > shmem file (including linked files, memfds, and O_TMPFILE). It is
> > userspace's choice at retrieve time. The only thing the kernel enforces
> > are the fundamental requirements such as exceeding the file's mount's
> > limit.  When I think about it that way there is nothing special about
> > retrieving into a memfd and MEMFD_LUO_FLAG_TMPFS is just artificially
> > limiting how a shmem file can be retrieved. WDYT?
> 
> I do not want LUO to change the type of a preserved file across live
> update. Take seals, for example: a memfd can be sealed with the
> guarantee that it will never be modified, whereas a regular tmpfs file
> does not support sealing. Allowing a preserved memfd to be retrieved
> into a tmpfs file would create a loophole to strip seals (or bypass
> mount/superblock boundaries). I strongly prefer keeping the file type
> strictly the same across preserve and retrieve.

I agree that seals must not be strippable. I am not proposing to allow
that. Regular tmpfs files are created with F_SEAL_SEAL, and v1 refuses
to retrieve into a target that has F_SEAL_SEAL if the preserved file has
any seals the target doesn't have. So a sealed memfd can only be
retrieved into a memfd that allows sealing, and gets its seals back
there the same way F_ADD_SEALS would add them. Only unsealed memfds can
be retrieved into regular tmpfs files.

On mount boundaries, retrieving into a tmpfs file charges the blocks
to that mount, so its size limit and quota apply. That's stricter than
the unlimited internal shm mount that memfds live on, not looser.

This is what I mean about enforcing the fundamental requirements, rather
than enforcing something artifical like MEMFD_LUO_FLAG_TMPFS.

BTW, MEMFD_LUO_FLAG_TMPFS is set based on i_nlink, so it doesn't really
track the file type. An O_TMPFILE or unlinked tmpfs file gets preserved
without the flag and comes back as an anonymous memfd on the internal
shm mount. That changes its type and drops its mount's size limit and
quota, which is the boundary crossing you're worried about.

If you still want the type to stay the same, we can define it by
superblock instead of i_nlink:

 - memfds (on the internal shm mount): plain retrieve only, as today.
 - files on a tmpfs mount, linked or not: retrieve-into only, into any
   empty tmpfs file, including O_TMPFILE files.

That keeps your guarantee, fixes the O_TMPFILE case above, and still
lets userspace restore into an O_TMPFILE file and linkat() it into
place once it's verified.

But my preference is still to enforce the fundamental requirements,
since we have to enforce them either way and MEMFD_LUO_FLAG_TMPFS adds
ABI.

