Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 178A1CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 21:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10ED36B0098; Thu, 15 Oct 2026 17:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C27F6B0099; Thu, 15 Oct 2026 17:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F180D6B009B; Thu, 15 Oct 2026 17:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A146B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:53:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3882D801C9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:53:36 +0000 (UTC)
X-FDA: 85326212832.07.FEFE278
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 61B5F40003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:53:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mBiAUSDW;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792101214;
	b=eckdBSpbVfr4gSzilP396OwANe2LhDh75lMjsBaFKweAz2DYV3rLAb4e6KJJtRtJKYGSVU
	lU5rIvOv4EZ+1SSy5NuPFWK3yurPFhFPg1x2krj0eKmZ5YWR8i756pea3U4+eZwODWFuBk
	n9V2PSLovt4Zjok0mTpNWx4VHNiO/o8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mBiAUSDW;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792101214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mI5j2QSx7YHmNnf5OMmNmLr/+3VlhYuDRCjBR0r1XZM=;
	b=Rql6WM5i90N/AZ8N+XtEiduD564Jn5c2YpI+MdV+xlgvkxkQ1kRGarwMyBwSv0/zT/lTB+
	4LpsLJ8aOSgA0FeLAlLwK2wleX3X7DL1aUlCELWAL+AteYsTGLohbisFzRMw325geZAVNu
	gUQyDzbu9543hh21JGQi5PLEwUAcw/s=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-398a4dcf289so3166239a91.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792101213; x=1792706013; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mI5j2QSx7YHmNnf5OMmNmLr/+3VlhYuDRCjBR0r1XZM=;
        b=mBiAUSDWmd6jUWP/9RKvm0Amx4byNboD/tvRmUu6anIbNY86C8uak9g6O+nk3zx97j
         IvVJ2lasHEYiRvHbjC9zP3MROG/Iirvr/Q7QL8iMN5jA+M9Jp/bYBrLw9TLii4gqHNbl
         XuRbtgGuh3mpo4y4EoF8OBWLkqQ+90PROYjOho4xrIK4VJDpMbqx42QrVHLHwjBdpOxi
         mJKw4+iwBLs2EJqL3xJ8qvi/bO/oYyIYxvw7GCOxbh1P4p3wo8UaipSNHp8eWb+eekid
         UFYFRxEoDk+00hswn1GOC+GryErpxYf1CuVsKbc5UGXDoqdF/L9IwWRYXLbrZ0jLjHVF
         G3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792101213; x=1792706013;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mI5j2QSx7YHmNnf5OMmNmLr/+3VlhYuDRCjBR0r1XZM=;
        b=phFRIeK4sqjYkn+ycflqYX38moVh9JLWmHopoQWOGijpayf7iWeOCv0GcqTurz2dER
         Q8XGmE66IroWpGELW+2fxyhO/aCu3GaGW0IKedblpRK9l3ga5LPE5mbHwcVyOqOOOduw
         W7q8n3E4BbYGOPxy/ysy49aBhL9u8oiD/HdMiw8FpwaAt8S5yv7BLdyx8CxSSXOA2tL7
         Z3v8FJgPUFLBfo90bpZ9KHShR9bU3ZK+hyJbAoRN4wOcGB/y6h+QDm8/lbl0dTe0xBpX
         J40rKpG1313ePDwRFdpXZJ5xWsm97vAI5vqKseijndpLLMbFswpbdBuxe3hYDzIk6BaG
         iX7w==
X-Forwarded-Encrypted: i=1; AKwUvBy/kEEU+BpYDoxgsyWXDk48qyYQER4JLlDse861tLYrAuXdcFlB6rD+jek9y8NpuaCCD3gu/vbbXA==@kvack.org
X-Gm-Message-State: AFq9FYLJPyfsbiPXP22MYbYFa8+WHqYNVOu0l/iYCO/o3/dh/auT1xv0
	sz9idSrU1ZyMJOCEG6NVF1YuMW8IlyF/BCTtQUPMFFktVm6xdxn30Bn+gcy/O62isA==
X-Gm-Gg: AYBFou0W3b6kX7TGU8Di0bpTj5qm9lJhdQcOczCu6+DUogH9c87yQTDamau8bwaHb0j
	1sCHBjrEmr+WOCgNfZlOQa/QZRmHktgpcQZKXyoJ79iTrJTyHVdEdW68eD+EZhfs0zNstFUDorG
	2nWl8kzdkt4ChBd5d2t8aiPlUV3qZ/vTEn+OiDGD47LaF9GPmuBqUjfk2oOrTRr3QZSM+GWZZUj
	t8P8d3z3XHkTPR6fRCqAVekokFxeLIiQj6TaeO5i8EJpaHO/SgW0uy0SqnkUa+tmiJSlGKstSxG
	/vU3KHAMZ1xd7j+oul7HkwnYZAG35WgBiBpgwZjIXFdbW3EybOux9oZTLnsmsSthhOhAa+2hpVj
	Xi3D9rAiAhOCeQWCl/znSZYKMMnHCuHe5nGPikHJrn0ov1yUIdxT1kv87GinKHempQd6W8QVMbF
	Ij6zdqnQH4hz1kHFXTtKYX7Ksu93WEulgbR8hej4Dmya7CMowLbi74neYNgIFpyij/bRIFHTOJa
	Rs+Tc5q0jDJYEnhHHvMvUv5VKC7MM9Z487EJchMuVZLhA==
X-Received: by 2002:a17:90b:5343:b0:3ab:188b:c5bc with SMTP id 98e67ed59e1d1-3ab3a94f0dcmr16931016a91.14.1792101212423;
        Thu, 15 Oct 2026 14:53:32 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48e8646sm865063a91.10.2026.10.15.14.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:53:31 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:53:27 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	pratyush@kernel.org, graf@amazon.com
Subject: Re: [PATCH v1 0/7] liveupdate: tmpfs preservation and early freeze
Message-ID: <atFLV3tT0s3y6zMp@google.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
 <atESAwf17pJ11S9U@google.com>
 <atEaPuWNOm5VLc7A@google.com>
 <atEhc20Zawj4D62x@google.com>
 <atE53vmlDeA4cWD2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atE53vmlDeA4cWD2@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 61B5F40003
X-Stat-Signature: zsh8xuo7qhh41jamn1pcuyk4q99hzpzw
X-HE-Tag: 1792101214-768771
X-HE-Meta: U2FsdGVkX19n5x8pOpiBZtqJrdrh5RE2TOHzFrzbsu3d/6VJ6A/kOb7e0zfuAb5VtloFAjuoS43uIR8r7XTBRDQ2uKkseT37AB1j0vxFpjgV+fJnR+fTM7jhevLRURpbbfNw66Z467ik15eRpGEWXGelByuTuKex/M2OOO7n9JUwbbJ0jhZOFwCgGRwHcdu9SqZlnpBVsU92ChUGtjp+lhc78QC95yJKWXw47N0wgfpNDODdsIlkdqifovhLgRgVrXzFZaHI2kXIQyw4soYhLl9I1kc3NfOy2BEoZSWbcs5O8zvu/d4cCfQNKjVn0vaALVsgqywXJUA/inOPvXuZ3VYJDj9BKgMTelOfjx6IQCluWtd6n+O5iZUD94YRzxce40dELLnqGR2lpSx7c6k2oru189WykAgdXyPqyRp/Slkg2YFeRMTK4AEOj3aPFt3YAK9c5J4nEtuVEINh5ZH2eV2MX5icv0rRBGxnEOR/qT1zc5WrDX5Fa7lGzoZ+FT2anzZ0wD2tnC/eyKJ/LRox9tUWUvSh5KLKLpaeIjTLN3Wgr/vLUnaFSE8aX3ynYcXG9r3TAL04E6i8DEf7dJQRMWyLVT4WNxknaBWgwTGp9VnA6g1DErrG4/p0QcjjyvbNkqsPhT7FWuCb3q3fECpuhNJAiITYCLTa4AxzEXT8Cp7f6iOcB7mSZcbJwIPbFXe+Uc3nI5SfC6jct5PhPclqsQGfqwxXFBoh5aiXQDkNYH0Etgqe4mFQF13Mcta8fXoFLGt3Y+o7CsdIqyOXGteBC5P2AZ1aEzQWQ1HlVod4bj1h6O9cvJzwin2AQuuUtlsGV01KhiNLm9n7RDh3sSavT3hGnMsBGBh4ZwSfJ9RN+nOp/N43gxUATnVRY3d+RzeipEo5MfwK91xaJMsbJAezFnbrWCtQV5/edGbIzNxbEMX+Oi3dxTAe1ZbQASz8r5HSl5hkqPyjomVCpK/8Hsu
 AX18EM2o
 YCyTifdvXyWTPPVM2nEs9o/LpHmm5iaqT/YREgs7W0EF4MLwgUHS1kAgBdhqtYzm9aKQCt9EVrAM1lGq+TiE5hLJYOtPFypPqV4WZQjLd1XpTwjW4yB0Otj/GokTqmuGOilqfQFAyRCTnpWN+9CAREd4wtg9TwzWRpmo+KV8IspKheYgxYpMCdOoOWQOUThtNYnFHCimxAzW8LsCFZpqS7Vt123x2WlKKVzyLSjFys3T2fzNZVKn+qvH7wZGwXA4H87XP9+XeKSIRmqRfd5JaLuZDVr4n03tVTrOVald1W4rEXnmBxE4kjms92dR3TJ8y6LVhDjOZbhV2y1qt1YKnC+ii3XnvneKTHcyfzZeZ71px4FA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-10-15 04:38 PM, Pasha Tatashin wrote:

> What if instead of retrieve-into an existing file FD, userspace passes
> a dir_fd on the target tmpfs mount where the file should be restored?

This is good. This eliminates the pinning race and also eliminates the
checks v1 had to do on the userspace-provided file.

> During preserve we can record the file's basename if the file was linked
> (or mark that it was unlinked). On retrieve, creates a brand-new file in
> dir_fd (e.g. starts as an unlinked O_TMPFILE on that tmpfs superblock),
> populates all the folios and metadata while the file is still unreachable
> by anyone else, links it into dir_fd under the preserved name at the end
> (or leaves it unlinked if the original file was unlinked), and returns
> the FD of the new file to userspace.

I don't think the name should be in the ABI though:

 - Userspace already has to know what each token is, so it knows the
   name. And a basename isn't enough anyway, since userspace still has
   to supply the directory.

 - "The name" isn't well defined. A file can have several hard links,
   and it can be renamed or unlinked between preserve and freeze.

 - Linking in the kernel needs a policy for collisions, and linking at
   finish() can fail (or find the name taken) at a point where there's
   no good way to report it.

 - The name isn't the only thing needed to create the file properly.
   There's also the mode, the owner (fsuid/fsgid, setgid directories,
   idmapped mounts), default ACLs and LSM labels, the access mode of the
   fd, and whether the file may be linked at all. If we record those in
   the ABI it grows a lot.

What if we model the retrieve args on open() directly? RETRIEVE_FD
behaves like openat(dirfd, ".", O_TMPFILE | flags, mode), then fills the
file, then returns the fd:

  struct liveupdate_memfd_retrieve_arg {
  	__u32		size;
  	__s32		dirfd;
  	__aligned_u64	flags;	/* subset of O_*, ORed with O_TMPFILE */
  	__aligned_u64	mode;
  };

In the kernel this is file_open_root(&dir_path, ".", O_TMPFILE | flags,
mode), which goes through the same path as open().

Userspace links the file into place with linkat() whenever it wants, the
usual O_TMPFILE way, or passes O_EXCL to make it unlinkable. Then
there's no name in the ABI or the uAPI, no linking in the kernel,
unlinked files are just files userspace never links, and "don't link it
until it's fully populated" comes for free.

One quirk: open() rejects O_TMPFILE without write access.  With LUO
holding the file until finish, that brings back the -ETXTBSY problem for
restored binaries. vfs_tmpfile() itself doesn't need write access, and
neither does filling the file, so I think we can allow an O_RDONLY |
O_TMPFILE here.

> I would like file type to stay exactly the same, I really don't want to 
> play the game where LUO can magically change file from one type to 
> another even if from Linux internal implementation they share a lot of 
> code, they are still a different file types from the user perspective.

Ok, I don't feel that strongly. We should just do it based on the
superblock rather than i_nlink, so that O_TMPFILE and unlinked tmpfs
files stay on a user mount.

