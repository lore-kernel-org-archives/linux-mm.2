Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD6ECC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249DF6B0088; Thu, 15 Oct 2026 14:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5636B008A; Thu, 15 Oct 2026 14:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09ADD6B0092; Thu, 15 Oct 2026 14:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA3B96B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:24:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDE3EC015B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:24:02 +0000 (UTC)
X-FDA: 85325684724.04.E7552E0
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1BA5A80007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:24:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Nm2YYmkP;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fejDPgUdb/iOyoCqBL5K47RANMeJV8pAF9VzuVR2mQg=;
	b=jJigEYUTTSUXIqFcnMS/VhQRn5bO87scB/C5/WeCnqO4i/h3J7Mq+MOvT53qJDx97nIvlf
	8yZV6gEglUFFZYs+jJUkLsio7eE42EQL+KwI8Sh7BGVANMOPrHpgYGN2CJXOmGqH7xmcQT
	LLTkBmp+8C68KtD/1XDf65/U9tT3xA0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088641;
	b=72jWTKo5tNdNZmYa/rJJoScQ516hukJ5BmZ/LLRioZj2A93wV5UK2ZunHS6ZY/6uduAqBL
	szvO2nscFxl+ooLuriyrWb4bRVnWNfejoLzovWFyMiYLDUp3hptmeVZfCNEbq4eD/qxjg2
	EkTzJiqKPxfAk/ntsRm41CIbBGsedvE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Nm2YYmkP;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5e9a1f1681dso647313e0c.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792088640; x=1792693440; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fejDPgUdb/iOyoCqBL5K47RANMeJV8pAF9VzuVR2mQg=;
        b=Nm2YYmkPUj/3wA3oGjZs3PWn0vfMnAnoe9WYU/fHgvURJQyTF7dNaQUEuPpv7+lsum
         FkZ+5SqawTC7CA7a8DRC4rKP5y5ypJWVTGDkqNHR/8ab7LhjqwE/rne/6V9MZNvGA/H8
         Vq4+dD+pgTCFiMGD5+ZnkTcGpF6tmlEvknyIZ5UoCGTKAdpG+5oAOGZNJRNGioUuAd9x
         U/PnLU5RepLDul7D174dyHIVRGjn6h7Zysjpb5+JWUqWg9/OmRPmOT/rLZVxuaXOeFu+
         cYEhyI09fKtD0lqh9iEXB7pPwzDY0Fx9c0+OkCSIpMZGllsSNn2m3Ul1sS03cN0QKJ9O
         060A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792088640; x=1792693440;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fejDPgUdb/iOyoCqBL5K47RANMeJV8pAF9VzuVR2mQg=;
        b=Gz63ZGBpwjpnHVg7HIFB1SPrdpEu9k/46OfVy9eq89earYx+vz7Q0kl7YU5vWZUZje
         4w8hEhnfn/hJJCS5mlbOPGh41gPe3dcyKnUt6Mwqga+uhUSg/w816PB9Xkh2kh6AFflL
         /iBFDPtLMb/nCAe6mjsdWAaBP9PPDbIzncTYOeu+lHtM+FK5rA60tUcHmMVfWtiXTC8f
         /4y7BhEzueRoZc1YqcnI3bF8yRe2y+kpusFnJtrYfEZ3XnfSWjj4Qh+Hybj15x751c+X
         eJkyHeI2tgCWZz+sdE2Px/ytn7gjChOO5kA+ZdW8TSeItWfyBNp9JS5xQosYOPrxLaVz
         6AFA==
X-Forwarded-Encrypted: i=1; AKwUvBzmm0hgEsWHBO/QAbTmN7HRKZDpbkz5Mc0GHdjMCGxSDB1q+MQoPYawTZ4kzgX27gFNoci0wZ94Eg==@kvack.org
X-Gm-Message-State: AFq9FYK8KFEDw+i5+FjVpeZ+p/NPkw0QwB6C/oMoJZ7KdJaDHN3Aj3Dv
	HFYZJTFENulaoQaG9gqone3rextObBgzXVrQ8VeJSyUwfqiXYmKYFKQu3r9ndRuHDvs=
X-Gm-Gg: AYBFou0hKg0QpJuqecqko8JaoXhIG8+hlo6NGEoSBhyEghyJ22OzhRvGVyYPUUcAqT8
	n2e6ry68vImk6Jsarv0uTit0slL+XdfOlwRprPLy2/h6bLP0ofA4NB+BpENuZMISYkGsaHSdJLb
	ZAd8SRhjQEogPiiglgJRMsylL9G5zgPFIHneORaC9Tqm3JU/5g01EENoBImd4rL0J/DTpXozIX7
	qKUyPZOS7wBzmQOcmIMa7BIfAxQoEpx3SzMaRC37Ce0YdjYetvplNqn8CmwXLdKbUg1ea2qk7Lv
	iguWlduJXkuXo2HI/yxAwS8vM0S6XNDzu/iZWTR4dCCg6yV9O3y7z28wa8GYmE6vJfT+wLCQo4Z
	2f6HE+vXKWQalgq8HOGQHkIux/0OcszQTgzshjuPPwhtc8qFNjoA/sfEBoNemcfrEO0i4vlsjiX
	KkrqxfcdwRjgk3VEcpOOfM+vYlA7G1nQQ3cFiHiG0n8x1UCfsyPQOa9BhIp0+1FQFDcEv4OUTvs
	uTUPePDuTSkULLl7A26B/5DcX6pTsxqiHYLLBOQSXkx2uyWc3thj1Cn/Fxn0Zd9o8zw/ImnoVWo
	CNC7UogZNw==
X-Received: by 2002:a05:6123:91:b0:5ce:b65d:22c4 with SMTP id 71dfb90a1353d-5e91f51f7d0mr7511976e0c.16.1792088640045;
        Thu, 15 Oct 2026 11:24:00 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9943d7ffsm331215e0c.3.2026.10.15.11.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 11:23:59 -0700 (PDT)
Date: Thu, 15 Oct 2026 14:23:58 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	pratyush@kernel.org, graf@amazon.com
Subject: Re: [PATCH v1 0/7] liveupdate: tmpfs preservation and early freeze
Message-ID: <atEaPuWNOm5VLc7A@google.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
 <atESAwf17pJ11S9U@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atESAwf17pJ11S9U@google.com>
X-Rspamd-Queue-Id: 1BA5A80007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kzrcn5tubpgiy43fkot71xzcdqht54b3
X-HE-Tag: 1792088640-528056
X-HE-Meta: U2FsdGVkX18T/FO9ntqcSk2LiY6rOr2vRv1eh+qnWvlug3ycNRObaz/pA4/rIzGwld9IsdFjlYk5/Ww1RoTTwTpnFqf+whoXarqlVQ7N8UxGLrLXQLIX77a0m12gfCA6d3lDCHHWf5qaY6wSVy7KvMs4QXecKwXelYUyYhom80qxm/Ykqnmf50deuBp+ccZ9K9ym/RiyZJS4qWknflrZ+e35D6GTxZpgOrjz5Gv+xiACO9KW4q6fhtqrr9IM92zFv2umthi6HCLQKq6KSa6Ug4F68f7ryMwQ0w9m6LFdw3E+a9pMM4cCW4fyLNxZIJWJMU6ltQu83zLIyqyBVplUcngeRaM5ohYooWjB6ehrBbmF3TYgx/PVpGiHvACQbxXKm6LsaRYaIKNI++6JhTof3jTGeVeIDX4LVkKa+1anJFHM1nxWaKoWqeD/kQIrr2rVQDAf00UAC8+MIvi8k2nBAxSnKri71+r0wySWqzpacD7iB0riP3xRWj5scyHjSwIR87LfpN9iYVPgGaNOGyFZUinoAtOQJ3NodMYphA8WXB0GEWQ//oOlH4yebUodDd5m2OBOWWw/ZqKx+172Yv8E6gl+h+Ngd4Ek5OAfWCBszzcexpAXVrMriwe3ZcRhHGGPCj2oVpljkmLLhGh3caVuYh98KgaVIM5y4Hsv4h8RCZKdDaPSQlsOtgdqqI3W2KOaz5AQlVWy2PIA1Oht7ILZIJUY+CczRgtWUkBhgMxLolAptCaahyaR7ERVRlL+mNu1k2inpCU111wHwdnRERCIHmrzqtMqMbDQwQkF8abHLuc6qTwHuJ7MlrOYXLXEYYte6QKyeel7Q5vW4Gs8n+o4jd1JH6L9NdqbuYh57z4vya2rRpOTXqWFHqBADVClrQ3lB003hbX6Qfszlepf/7f1Uj4LGn6VfgsKPDPEhFusf+PTYfQbZAtf2VJVft5Vpk5Wklmi1MeobI5wWmB7QGq
 AYGxKz2e
 sOTIQ2gpxk44DYvlwKlBkLPQtcSYJafdRcIrNSyuWdW1WtltGhAGjCPjoX0g/njKbQ0VtImzUJ9LLFl2Q6fq00iEuluUiQLcFP7AN0N8TJEIdxZkqckyXlKTyPUTnoWNmFeJyTVVHrsCcSgrYXT6XH+mcXQJ/twZMqwdGM5l/bMLUwmj3OPQJ++sLRu/8+WIoebM5pI85JMNOuFWm6K7nKNFl44OzuUC1g0Rl9CpvYymPvu/mGi6AZxzZJfD1SZwIFFvEj/k/91JP72T2lMYkeHvjcFUuV1w0viJxL4AUwYcgxuJ+gPpq1EQO5tiHizQDXvD9SOEULcRJAuciiw0fvtneLEiE/cDmGkiuk/zNOWrjrXCVlPKdWB7GyHVdKNIwm2ee
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10-15 17:48, David Matlack wrote:
> On 2026-10-15 05:38 AM, Pasha Tatashin wrote:
> > This series allows preserving files in tmpfs via LUO to survive across a
> > live update, and allows userspace to decide when to freeze a session
> > instead of delaying until auto-freeze at kexec time. Once userspace is
> > done with a session, it can freeze the session immediately (and across
> > multiple sessions in parallel), reducing blackout time by not postponing
> > this operation to kexec shutdown where all sessions are frozen serially:
> > 
> > 1. Early session freeze (LIVEUPDATE_SESSION_FREEZE):
> >    Currently, LUO sessions are frozen automatically only inside the
> >    reboot(LINUX_REBOOT_CMD_KEXEC) path, where luo_session_serialize()
> >    iterates through all outgoing sessions under global write locks and
> >    freezes them serially during shutdown.
> > 
> >    Add the LIVEUPDATE_SESSION_FREEZE ioctl on session file descriptors so
> >    userspace can freeze a session as soon as it is done with it (and freeze
> >    multiple sessions concurrently, since luo_session_freeze() only acquires
> >    the per-session mutex). During kexec, already-frozen sessions skip the
> >    late auto-freeze step; if an early-frozen session is closed before
> >    kexec, its files are rolled back via .unfreeze() before being
> >    unpreserved.
> 
> Thanks for putting this together. I'm on board with driving
> retrieve-into through a per-handler argument instead of a LUO-level
> flag. It's what Pratyush suggested on the RFC too (sorry Pratyush, I
> never replied to that). I still need to review the actual patch but
> I think the idea is fine.

Yeah, Pratyush and I discussed this at LPC. I've been using this extra
argument in my cpu_preserve series to launch jobs at a given entry
address on a preserved CPU, and figured it would be a useful, generic
interface for others as well. So I decided to send this series now to
reduce the extra infrastructure I carry in my cpu_preserve series, and
your tmpfs work was a good reason to land it now :-)

> However, nothing ties the arg struct to a handler, it's interpreted by
> whichever handler owns the token. At LPC we discussed letting userspace
> pick the handler in PRESERVE_FD/RETRIEVE_FD, so that it controls which
> one is used when more than one can take a file. If we do that, the
> handler name would also be the natural key for which arg struct is
> expected.
> 
> > 3. Tmpfs file preservation and retrieval:
> >    Using the file handler retrieve argument, extend mm/memfd_luo to allow
> >    preserving generic shmem-backed tmpfs files (not just unlinked memfd
> >    pseudofiles), recording MEMFD_LUO_FLAG_TMPFS in
> >    struct memfd_luo_ser.flags so that preserved tmpfs files must be
> >    retrieved as tmpfs files and preserved memfd files must be retrieved as
> >    memfd files.
> 
> I've been working on a v1 of the tmpfs preservation since LPC. v1 fixes
> a number of problems in the RFC that I think this series still has
> (sorry for the wall of text, it is LLM-generated):
> 
>  - Failures that userspace can fix lose the file. The folios are
>    restored, charged and added one at a time, so if the target's mount
>    is too small (ENOSPC/quota) or the caller hits its memcg limit
>    partway through, the target is truncated, the folios are freed, and
>    the failure is permanent. Only bad-argument errors are retryable.
>    v1 restores all the folios first, charges all the blocks and memcg
>    up front, and adds all the folios to the page cache or none of them.
>    It keeps the restored folios in private_data between attempts (LUO
>    needs to pass private_data to .retrieve() and keep it on failure),
>    so the only permanent failure left is losing the KHO state itself.

I think the current behavior is fine: if the file doesn't fit when
restoring, I think it is okay to lose the file permanently. We shouldn't
keep preserved data around in private_data once we have started
retrieving folios.

>  - memfd_pin_folios() doesn't require the inode lock, so iommufd can
>    pin folios of the target while they're being added or truncated
>    away. v1 starts with two patches that make iommufd take the lock
>    and make memfd_pin_folios() assert it.

Hm, isn't this mostly orthogonal to the change we're making here?

> 
>  - The target has to be opened for writing (FMODE_WRITE). Since LUO
>    holds a reference to it until finish, that means a restored binary
>    can't be executed until the session is finished (-ETXTBSY). v1
>    instead requires mnt_want_write_file() and file_permission(MAY_WRITE)
>    under the inode lock, like FS_IOC_ENABLE_VERITY. That also rejects
>    immutable files, which a fd opened for writing before chattr +i
>    doesn't.

Ah, good point.

>  - There's no file_modified() or fsnotify_modify(), so setuid/setgid
>    bits aren't cleared and timestamps aren't updated. The normal write
>    path does both.

That is true, though I'm not sure fsnotify_modify() is really needed
since the whole file is restored at once and I doubt anyone is watching
for modifications during restore (clearing setuid/setgid via
file_modified() makes sense, though).

>  - f_pos is set through fget() + vfs_setpos() without f_pos_lock, which
>    races with read()/lseek() on the same open file. v1 uses
>    fdget_pos(). (Sashiko called this an ABBA deadlock. I don't think it
>    is one, since vfs_setpos() doesn't take the lock, but the race is
>    real.)

Right, this was reported by Sashiko; I haven't looked into it yet.

> 
>  - Early failures leak the preserved folios. The seals/flags check
>    frees ser and records a permanent error, so .finish() skips the file
>    and the folios are never freed. Sashiko flagged this as well. The
>    new MEMFD_LUO_ALL_FLAGS check adds another way to get there. In v1,
>    early failures don't consume anything and aren't permanent, so
>    .finish() cleans up.

We originally agreed that if retrieve() fails, we fail permanently and
leak resources until reboot to avoid memory corruption from ongoing DMA
activity. However, now that we have the retryable option, we can start
relaxing what is considered a permanent failure vs. a recoverable/early
failure that .finish() can clean up.


>  - If a token was already retrieved, luo_retrieve_file() returns the
>    existing file and ignores arg. Userspace that asks to retrieve into
>    X gets success and an fd for a different file. I think LUO should
>    fail with -EBUSY if an arg is passed for a token that was already
>    retrieved.

Agreed, if an arg is passed for a token that was already retrieved,
failing with -EBUSY (or -EINVAL if the target file doesn't match the
originally retrieved struct file) makes sense.


>  - Sashiko's WARN_ON(liveupdate_claim_file()) report on 3/7 is valid:
>    xa_insert() can fail with -ENOMEM there, and userspace can trigger
>    that.

Yeah, we can address that.

> One place our series are not aligned is MEMFD_LUO_FLAG_TMPFS. My
> thinking has been that RETRIEVE_FD should support retrieving into any
> shmem file (including linked files, memfds, and O_TMPFILE). It is
> userspace's choice at retrieve time. The only thing the kernel enforces
> are the fundamental requirements such as exceeding the file's mount's
> limit.  When I think about it that way there is nothing special about
> retrieving into a memfd and MEMFD_LUO_FLAG_TMPFS is just artificially
> limiting how a shmem file can be retrieved. WDYT?

I do not want LUO to change the type of a preserved file across live
update. Take seals, for example: a memfd can be sealed with the
guarantee that it will never be modified, whereas a regular tmpfs file
does not support sealing. Allowing a preserved memfd to be retrieved
into a tmpfs file would create a loophole to strip seals (or bypass
mount/superblock boundaries). I strongly prefer keeping the file type
strictly the same across preserve and retrieve.

> One last thing is my v1 also comes with a dedicated tmpfs selftest with
> much broader positive and negative test coverage that I would like to
> land (things link O_TMPFILE and read-only targets, executing restored
> binaries, exact block accounting with statfs() and st_blocks, including
> large folios that extend past EOF, etc.).
> 
> Maybe what we can do is keep your 1-5/7 patches and I'll rebase my v1 on
> top and send that as a replacement for 6-7/7?

Sure, please go ahead and send the new version.

Pasha

