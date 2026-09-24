Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BD5C9831F
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 21:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72A96B0088; Thu, 24 Sep 2026 17:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFBDC6B008A; Thu, 24 Sep 2026 17:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA8F6B008C; Thu, 24 Sep 2026 17:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9D66B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:10:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECDEB1604C7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:10:15 +0000 (UTC)
X-FDA: 85249898790.14.7694F6E
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1ABA2C0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:10:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jww46CND;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790284214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zl2fNi5BfSzkgDSihIsrR46mveZ03y1JQtjuR5aZ97A=;
	b=nJR1vEdQ3a5mTQ4wIkniB+pL03qGNfrV1+7VAHg82HWY2I3cuTsKmuc8OGgSoiTN2/b9zs
	uYSeMBdT0mXyWReZZMeOVWxPnwOKObO3kqYs/n2otlvlKwAVAJ7kHDAVzPJUv4QYIRbGMO
	DKMpBO1CzbbL5pQv51zwV570VSmcz8Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jww46CND;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790284214;
	b=adhZg2LUrVo4Pt7UhbMDTG8rglRds+oK7ltzgk4GZ7UfpsclCWWpIXElyWMO8Hv4OcP9xD
	VTO8WbfUV/LkAN33s0TL9+XzfSy4R0PJbHVDWHCNnkTf+ihZqU+MNKkr59PDWhrjY/E7Sh
	+7WMcIBVWECuBPg5Gtxl/v2CIyq/4V8=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so248359a91.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790284213; x=1790889013; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zl2fNi5BfSzkgDSihIsrR46mveZ03y1JQtjuR5aZ97A=;
        b=jww46CNDhy7ViANO1FuP0z28rQz7iRCwrlLLWINUnsUysA7Xe/4aOGwJd412WIh6ow
         e2Yfg9kFDLW++SCLX2Z4dZU2Hc4km5PqCWZHLBJlxuU27OXyKp6MGeKo/BBP+gqtwMpO
         9NhbgJmM8BUnUN8fTceZkWk2a7ou+G0lbywSryRTPep/hZsPt9LlNuGQSzUbGHNH+oXI
         EvXIqoM9+Uafe2pU29+7TXfnaeEcWy0FvSVa6r6S+Pk09ECmLE8XynVSxlDdnPTxCJbA
         OTwMdZs5HnVQNROBJpocyZcjys3Od1qAEmqk4fWizi9dNBeTy86mRwuBmEP2RGVHwKMu
         KqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790284213; x=1790889013;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zl2fNi5BfSzkgDSihIsrR46mveZ03y1JQtjuR5aZ97A=;
        b=dqayjyGeB5Zb4WV6PLz0x+0XJLzRcsjnFuA/8wylE1eZqs3yqYhL95L8bJDGPVgYcX
         ch4AePDyJgt1ms38V/pwwGMoWfbm47KfeRd6NL2Avy/cv0ZCSea+ThnN6QJGxbj+Hi9K
         CDFNR1/AMK3q/63P3jH4Hy8/2OpvJlxozw/4fFkgcznz/1G4nhoNAo4U8NWNMr6cwzBM
         KCqDwPUeeI59SWroCZCUPxde8HsGAH4PYkMWzBNoVXscBL2eAbMmhghqSUTj7ckRoI1S
         38Nr4/Ab2JT6NNVkmVp6PrZEVUQVbSnkDfOqHM+UrdWGgINyxFrsonmfUlnUJct2SWFe
         oMzg==
X-Forwarded-Encrypted: i=1; AKwUvBz9rEfjO+uklTJfWiXPLUb7dfyqR3LIg6FVe8X2drsU+VUGXuFt1ZH/B61VG7VJrIWQoXMDbgf8OA==@kvack.org
X-Gm-Message-State: AFuF++l46dyuzc506GVX3Sucg2jRc66uWFPtrT5r+V2HCBjTHg8mJpjK
	FypJV41v6cP+LEQMK9E74P6Hh5eNM+T3+gTAi/LSwRn9q+K1uSLHuzayG1NSNn8GOQ==
X-Gm-Gg: AYBFou1IeFn/FDvVXBcq3uzn+IsLnGf961f/Mnh9p1PwOG+Dg/TIFO/fu4Jwk+sBcFH
	NSP1rArnYhdLEOpyXsq1SFHMgy4U4xMBSQYWxPv0zLbqWXqfRvSnh+U9Hg4wnHCoFDnDLyWy0JT
	y6pR+kGNlrLWzI+5saGiLR4ozEzjBmtLVZATrESzuYNzmxrCXnwaokwX+x6RgCsaHM8ez0TXfw3
	d7ePpxKiCd0uAF3Gmsv1+hBL5sEntKpj8DSmDks6aYPs0hDlSuhPi+UVhU/1AM4Wt1b2mz17B7o
	6ibwJV0uT19V3he4oLVqbn/K30brAwS6+Mgm5d+VhEvwZDZiCbmhNsZs02+cF4WMOHmU9VSP3RH
	OnT62JVs5QnHm0VLJRsj9TLsC90qTSjfYh8h0N3MrwXtbNhiQ6Pf8ktLPHu3LgjVeSdrLy867zq
	U4IvluAMIvDWoJTm/LYHwqdFc6UnhImE9ljACrK1kUkQIvtedmastD2Dr13dYySPN6XiG4lrXMq
	AnEsfTFLZEZV4NnRZS/hQ5qNCmMzW6o4rLb/T9H
X-Received: by 2002:a17:90b:3d81:b0:3a0:2c7d:edd7 with SMTP id 98e67ed59e1d1-3a098ad4cb9mr3516520a91.10.1790284212075;
        Thu, 24 Sep 2026 14:10:12 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9892dbfsm434036a91.11.2026.09.24.14.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:10:11 -0700 (PDT)
Date: Thu, 24 Sep 2026 21:10:03 +0000
From: David Matlack <dmatlack@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Alexander Graf <graf@amazon.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/6] luo: tmpfs preservation
Message-ID: <arWRq4ZRbmyWK4SI@google.com>
References: <20260923224408.3745689-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923224408.3745689-1-pratyush@kernel.org>
X-Stat-Signature: 4uwjc8ggy3kfx7n8s8tn1xtbk9aeons3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1ABA2C0002
X-HE-Tag: 1790284213-942053
X-HE-Meta: U2FsdGVkX19bhZaSZtueTjHXvAMYLir2pUAcubS2WhbiNHlml0n7kylbfX6CDjPbpeun+pQcePOqE77kxIjMgQvRq74ZrG5ZAjKKYy63a7WcS5fTO1/1reAAjo7q5iAYLS4ccqyuoSX181xes7tIR581/pT7xCGCj7C7l024IcOYFKXuy7ltY1K5n0adMFRRSoY/7Qcn34+RqSV8NpIqG3q7aRQ6nxV7KTcjvCz/OEHRNjRZS+TgYJj2RA147vKqr4vmxYQRMUv58hpK10nv1BYBn5PQ6kPwLgs93AmPrOrWP7apzWocQUi/6XUslJTRiouJiRn0/SN24gsHhwNSC2j+9EPAd4nF3ZAEPNTdghJCAqiT2DOB2lk5I4BtbU58tzO3KP7otxKHYtsra63M/6K5PQS8K2LlLz3UIaxHY7/NslCNKtCMT6SBkNg0stav+np7EQrUsVdUscReTBgqfxl4rtgAg8TKytyxCEZDnTyhNBwOeKNzzjIHfQ951Ma6AboTVFtBrRDxZS+wcvcBH+KQpRXTmLRlFG2rQBDmNwJO13hZlxeegZH8rZC/gLWZh7CE5fl0uH1EmJ2EftQ3Wg1ZqwJ+GE7S1eGQjpYLWthoGEwT3AZ1RLu9KOZQfOfX1uycST8W3kOkmfuKDUn4XnbZ3tTb9kgdMA2ijKRCdRkWz6j8Xz602u7FWX4WedfmSoYJ/Nt6HhjhwnRtzw2x8F1AExPZXLBrnKtisxFS80924ELtHj79ZakMyIB5wMrA95f3HyNeu7VKWC7LiQ+p682yuybCdwEl6vARgLWC6E8G6bmDeBMNHCiZZzI+QRIXnL6uc4FevRAOADnXwhYIqEA1YKV3zZBYPFv5UliuO/1FuVR0ABIY8b2rLdS9ojjfDwpFZir5fUF9eTQnXkFCF6zq6gAHgkR+c/9e3h11wYQievQiRS2T3dU3dNGlXANmpUTcE2u1qugZygVVb1A
 RCq4pwGE
 KtRAfb49aNWDTuu9U+Dhjyl4Axp1vIDTkkpjuzNhvpn0mnf/zo1WFeFGpYRVs3mq+MFPGjqeQsoSqIRCalg/nFX0jSm2i5Rzd3Gz79KqRPn1TA/T7G/+eUOj1HvprBOdE/lHlZ0YNU7MniqZLkuMXxibDPmiI1nBdUxNpE5hKJ3HZjPLstWs+gXbmXCsBw8qakamPqw91AkGPV8E6uXuOZ6Bo7KPzXYx4pgmN1tYWCLaOtI86M0MkEN+EU6+K75T9/5RCz/9860K89Zaf9A9CUyMs7qegdnSqK6mHsXG0dQ2RNjXvdXnvgPEhCwQPHUllJaY288txlHGgbKq5Z7m8bFVyc/5dS85eUnHQUGVuGAvhD2Q8DEaDnZEKaxpo00zCXxtg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-24 12:43 AM, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> I brought this idea up in this week's Hypervisor Live Update bi-weekly.
> I decided to try using an LLM to see if it can produce a
> proof-of-concept quickly. This series is the end result.
> 
> The main use case is preserving in-memory files that have a filesystem
> path. We already support memfd preservation, but memfds can't be linked
> to a (user-visible) filesystem. This is needed for storing VMM packages
> for live update on hosts that don't have a disk. A cold boot fetches the
> binaries from network, but that is too slow for a live update.
> 
> David tried to solve the problem by introducing
> LIVEUPDATE_SESSION_RETRIEVE_INTO_FD [0], which lets you provide a FD for
> LUO to retrieve into. This is an alternative to the idea. It uses the
> standard preservation and retrieval API that LUO already provides.
> 
> The core idea is to allow userspace to preserve a tmpfs mount FD. Once
> the mount is preserved, userspace can pass in regular files in that
> mount for preservation. The files take a dependency on the mount token,
> and that is used for retrieving the files in the right mount. This saves
> us from doing a full FS preservation and makes preservation of each file
> explicit.
> 
> Currently only files in the root are supported. Files in subdirectories
> will be rejected. This is mainly for simplicity. Complex mount features
> like memory policies, id mappings, or casefolding are also not
> supported. All these can be reconfigured after retrieve if really
> needed.
> 
> The code re-uses a lot of the preservation and retrieval logic from
> memfd preservation. It only adds some extra file and mount metadata on
> top.
> 
> As I mentioned earlier, this is heavily LLM generated. The code is not
> very polished and has some rough edges. That said, I have read all the
> code and did significant cleanups of the LLM output. This includes
> turning the 1600 or so lines it generated to a more modest 977 lines.
> So (I think) it isn't complete AI garbage. And I think it does get the
> core idea across.

Hi Pratyush,

Thanks for posting this. I wanted to compare this series against the
RETRIEVE_INTO_FD approach, since both are trying to solve the same
problem: preserving files with filesystem paths across a Live Update.
Both are RFCs, so I'm going to ignore implementation details and focus
on the design.

As we discussed at the Hypervisor Live Update bi-weekly, this will be a
topic to discuss at LPC. I'm hoping we can use this thread to align on
the pros and cons of the two approaches so I don't unintentionally
mischaracterize anything.

At the memory level the two approaches are the same: file contents are
handed over using the existing memfd folio ABI and re-inserted into a
shmem inode in the new kernel. The difference is who owns the filesystem
topology around those folios.

  - RETRIEVE_INTO_FD: The kernel preserves only memory. Userspace
    own the fileystem topology, recreates it after kexec with normal
    syscalls, and then asks LUO to fill each empty file with its
    preserved contents.

  - tmpfs handlers (this series): The kernel preserves the mount and
    the files as first-class LUO objects (name, mode, pos, etc.),
    rebuilds them after kexec, and hands back a detached mount.

Everything else below follows from that difference.

Comparison
==========

What LUO preserves:
  RETRIEVE_INTO_FD: Memory only.
  tmpfs handlers:   Memory plus filesystem objects and metadata.

New uAPI:
  RETRIEVE_INTO_FD: One new generic ioctl, or a generic extension to
                    the existing RETRIEVE ioctl.
  tmpfs handlers:   None. Existing PRESERVE/RETRIEVE with new file
                    types.

New LUO ABI:
  RETRIEVE_INTO_FD: None
  tmpfs handlers:   Mount and file structs, plus a version bump for
                    every new attribute added in the future.

New VFS surface:
  RETRIEVE_INTO_FD: None.
  tmpfs handlers:   Kernel-created mounts handed to userspace as
                    detached mounts.

Where the filesystem topology description lives:
  RETRIEVE_INTO_FD: Userspace, in a private format it can evolve
                    freely.
  tmpfs handlers:   Kernel ABI.

Mount options:
  RETRIEVE_INTO_FD: Anything userspace can pass to mount.
  tmpfs handlers:   Only what the ABI enumerates (currently the block
                    limit and root mode).

Dirs, hardlinks, symlinks, ownership, xattrs:
  RETRIEVE_INTO_FD: Free. Userspace recreates them with normal
                    syscalls.
  tmpfs handlers:   Each requires new kernel code and ABI.

Userspace complexity:
  RETRIEVE_INTO_FD: Higher. Userspace needs a manifest, then must
                    mkdir, create, chown, etc. before calling
                    retrieve_into.
  tmpfs handlers:   Low. Preserve the mount and files, retrieve them,
                    and move_mount().

Metadata consistency:
  RETRIEVE_INTO_FD: Userspace must snapshot and keep its manifest
                    consistent with what it preserved.
  tmpfs handlers:   The kernel captures metadata at freeze time,
                    atomically with the contents.

Trust surface for previous-kernel data:
  RETRIEVE_INTO_FD: Userspace validates its own manifest. The kernel
                    only validates the folio list.
  tmpfs handlers:   The kernel must validate names, modes, etc.

Generality:
  RETRIEVE_INTO_FD: Applies to any handler where "fill a
                    userspace-created object" makes sense.
  tmpfs handlers:   tmpfs only.

Arguments for RETRIEVE_INTO_FD
==============================

1. It follows the principle that LUO should only preserve what
   userspace cannot recreate. Names, modes, ownership, directories,
   and mount options can all be recreated by userspace. Memory
   contents cannot. This approach draws the line exactly there.

2. The kernel ABI stays small. Every attribute the tmpfs handlers
   learn to preserve becomes a stable KHO ABI that has to be
   maintained across kernel versions. Reaching parity with what users
   will eventually want (subdirectories, ownership, xattrs, ACLs,
   symlinks, hardlinks, huge=, mpol, quotas, idmaps) implies a long
   series of ABI revisions. RETRIEVE_INTO_FD gets all of that for
   free via existing syscalls.

3. Policy stays in userspace. The target file lives on a mount that
   userspace configured, in a cgroup and namespace of its choosing.
   The kernel never has to guess the right configuration for a
   recreated object.

4. It is a reusable LUO primitive rather than a tmpfs feature.
   "Retrieve into an object that userspace already set up" could be
   useful for other handlers where the object must be created in a
   specific context, e.g. HugeTLBfs files come to mind. The tmpfs
   series adds a one-off pair of handlers.

5. It requires no new VFS surface. There are no kernel-created
   mounts being handed to userspace, so the change stays contained
   to LUO and memfd, which lowers the cost of getting it upstream.

Arguments for the tmpfs handlers
================================

1. It gives a filesystem-shaped abstraction from the kernel's side.
   The kernel knows that the preserved files belong to a mount,
   tracks that dependency, and returns a working filesystem. This
   maps directly onto the stated use case of VMM binaries on hosts
   without local storage.

2. Metadata is captured atomically. Name, mode, size, and pos are
   captured at freeze time alongside the contents, so they cannot
   drift. With RETRIEVE_INTO_FD, userspace must keep its manifest
   correct across any renames or chmods that happen after it takes
   its snapshot.

3. The restored mount can be hidden until it is ready. The mount
   comes back detached, and userspace chooses when and where to
   attach it with move_mount(). Nobody can observe a half-built tree.

4. There is less for userspace to do. For the simple case of a
   single tmpfs mount with a few files, userspace needs very little
   new code.

5. It leaves the door open for whole-tree preservation. In the
   future the kernel could preserve an entire mount with a single
   token by walking the tree, which RETRIEVE_INTO_FD cannot express.

Where each approach hurts
=========================

RETRIEVE_INTO_FD pushes work and correctness onto userspace, likely
requiring a shared userspace library or daemon. The kernel also has
no notion that a set of tokens formed a single filesystem. It just
sees unrelated files.

The tmpfs handlers are narrow in scope today, and every extension is
expensive. There is a real risk of slowly growing a partial
filesystem serializer in the kernel. It also couples LUO to VFS
concepts such as mounts, namespaces, and names.

A possible middle ground
========================

The two approaches are not mutually exclusive. We could use
RETRIEVE_INTO_FD as the core primitive for file contents, and provide
a shared userspace library for the common "rebuild this tmpfs" case.
Kernel-side mount preservation could then be added later, if and when
a concrete need comes up that userspace cannot meet, such as an
atomic snapshot or availability before userspace runs.

That keeps the kernel ABI limited to memory, which is the part only
the kernel can preserve, while leaving room for the more integrated
model if it turns out to be needed.

Thanks,
David

