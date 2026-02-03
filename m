Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3140E8783D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 14:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E33F6B00A2; Tue,  3 Feb 2026 09:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9286B00A3; Tue,  3 Feb 2026 09:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BE36B00A4; Tue,  3 Feb 2026 09:58:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDC126B00A2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:58:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BD9F160540
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:58:59 +0000 (UTC)
X-FDA: 84403452798.19.F4C9824
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B84A020003
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:58:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MS1vH3Y2;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770130737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sv7c5+Wb7L+x53Gll0nCFm3iORDZSQuTRiAzYkmPt0s=;
	b=6ru9HVv5wss0zZR0ePEms7aEh2j1qrQM2CTG3yiJFZZ1ArJGWLDiCeEgqowbUI8mAXjVEU
	fBytaIXbUP/buVA1dPT2/Rq6KQ2fzWSdkUJPAKuE2HUoXGb9w/A1iD99KLhNTYeFCEokH7
	K65cJdACwCX6refqkJcZaDYlTaA3YW8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MS1vH3Y2;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770130737; a=rsa-sha256;
	cv=none;
	b=rY2vs+NiNitE/8YIcV9rtysyWS0fIZYD6YbIlxqiui1WJns4W/aw+3+3Yw+uECVysp+eyx
	1y/+Cs7EZy+htYfKL0C4oD9pwv/nfR7jY7MowSAvytxGHfSs4T7aOHDU+VzO8sv3H1Zr/h
	YCo7E4L2V+PHUy0IGadZNDOgBAVvth8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E30D601DF;
	Tue,  3 Feb 2026 14:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5148C116D0;
	Tue,  3 Feb 2026 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770130736;
	bh=AB+11IgAHQ4Zv4sJxXwOskKIaf0y0aebH7UdqQsEi0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MS1vH3Y2DMgMyWcZy2ZZW+2ypjiCAnvnVbtcMm+3lbwH06ZJR2uDgYG0vS6Q1hafs
	 wl6Z5IfS7D1zRbjLReVr/J1NGgPe2YjLyfZQ8TwDargAkg9+aDGa9eS4VSKy+cwkKh
	 EvM9QNUX3IbOsIyuWyLbyZTnnf7KWd1C++cELzeDLGuZUvhwo56ghlUsHkiMPwsVY4
	 UgZvmtxvNrXXXEhOAmfySsizMhFwP9pZRVP6nVXus/IUltVsMOC5d8xJT19mPKfvOm
	 YNNqoQb6teNygNh7yFC8j7zj9dNdJS6uoNpCpdMkr2JHnmmmCbm5u745p60BxS/BEk
	 6SQWSp6bWV6EA==
Date: Tue, 3 Feb 2026 15:58:52 +0100
From: Christian Brauner <brauner@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Orphan filesystems after mount namespace destruction and tmpfs
 "leak"
Message-ID: <20260203-bestanden-ballhaus-941e4c365701@brauner>
References: <aYDjHJstnz2V-ZZg@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYDjHJstnz2V-ZZg@thinkstation>
X-Rspamd-Server: rspam12
X-Stat-Signature: j1bw5ff6dfmn45iic489ntzqchyujwmb
X-Rspamd-Queue-Id: B84A020003
X-Rspam-User: 
X-HE-Tag: 1770130737-779760
X-HE-Meta: U2FsdGVkX1/wZ+6n9vjKwXPHexc60cRNX6WD/DsXw/MKNuEOBVi4xnSy9JT6yw2GHdBpItKB3Gi2OWii5wZBgJs1bihWBoVhN7EQ7r+VapQ2nCRzEiZchNE6/BhBgeZIO0TnqkMKu9KCMidm5zSZHUw1fYgVRbzzU3wITzDp9c2NOqgAH0qinpP+Liu5FwTs0M4lOOGXM3I96CBq9d+TGzPk5BJCipPkJea2PbHjsWwyJb7FnLmhKCFMbQ24puh3GD7ikAXiC5EFZv8o2rqCmR+g6OpZ1wFA9xQvB0XQtzuAjIJJydJ7r1ULHC8TUov/RyjzuGzbwLRK8ABHLWTmDeoi8pONe464cR4R6RwcGx0xSrJjpJxb1/767uyS5fvbWqzJ6bkwYrWeel6Utkc1HS+B9zcsxLT0NePfwdnzL2kSyA3B8boA1nTKahFf2GfHv+lzTPfWEtZaGV9xFaSQsHhS4ACNsS+Tz1eAuOaBZp/NrXuSz22qUzLzSpGFY/SAe4p+wP/vGEHEqE2DtpeLIirpnSZOQu9mPxYNcLumU4BSgYEmrPmgsCggnjIySl55BcSpHPyYIvmpR2Q/87zUW1Emkrrm8lA+0/GtvoplQDvpZsg8b7S9Mkr+o3ZwpdLTgKXxYSzv3w49XtsoApi/XIPcdtVezPuWOrLPZ2SMTyoYhP7p8p+ayXDt4vr7YfTd7djycJpPfREva2iscLzd5s9+eR7Bysb0ux3W2YwQGb3pUlHa7eqJsqlaVuqpBuFljSe6c/gKE2CLHs/7nIOUY6ilYwSUfkZfRocwYote3FhwSd5RsmQlt4OOJPoVzLvjm7Y+IseOmSnoLCX/xcy0NVYxI1+YOui9MkNePYEZ7fRKWwc8SsXyLJ7IOtRe05ILAZHI9AEBbW8GWuGb5f4nYwJD3diNnu0kJh7uJx5VlRzXSz2KqRdiyCiswQ4Nu5vv9MrZ6sGnw0cnnm4H3T1
 1Zxu9mlr
 R3qD9WVdeoxSN15CLAeyvxzgRvdsTwZLvgvh0REhKtbt9wSW3UMUhVPC7ApXleoLwXTcOGazkBQKAmRrk2ETWNW4+4tjELrASrmtPNZFVcC1xTkEg0JQMFa17ahCrh9+a7Q157WAh9L2jAsFDqQ+M0Sihknng3xPd/wxNLteg9lOhmw76h/kb+dVIIgfU/cXi6RRZoKxOeCcFL5AL3oGl99VpU2YHuGH7HKR71HmeEn9A3YY0eEPerH1Os/AGtbbqof1feydxdGePNHIlZbm+nAVCiAhFXLyZVbyaGpDVp3hPFpI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 05:50:30PM +0000, Kiryl Shutsemau wrote:
> Hi,
> 
> In the Meta fleet, we saw a problem where destroying a container didn't
> lead to freeing the shmem memory attributed to a tmpfs mounted inside
> that container. It triggered an OOM when a new container attempted to
> start.
> 
> Investigation has shown that this happened because a process outside of
> the container kept a file from the tmpfs mapped. The mapped file is
> small (4k), but it holds all the contents of the tmpfs (~47GiB) from
> being freed.
> 
> When a tmpfs filesystem is mounted inside a mount namespace (e.g., a
> container), and a process outside that namespace holds an open file
> descriptor to a file on that tmpfs, the tmpfs superblock remains in
> kernel memory indefinitely after:
> 
> 1. All processes inside the mount namespace have exited.
> 2. The mount namespace has been destroyed.
> 3. The tmpfs is no longer visible in any mount namespace.
> 
> The superblock persists with mnt_ns = NULL in its mount structures,
> keeping all tmpfs contents pinned in memory until the external file
> descriptor is closed.
> 
> The problem is not specific to tmpfs, but for filesystems with backing
> storage, the memory impact is not as severe since the page cache is
> reclaimable.
> 
> The obvious solution to the problem is "Don't do that": the file should
> be unmapped/closed upon container destruction.
> 
> But I wonder if the kernel can/should do better here? Currently, this
> scenario is hard to diagnose. It looks like a leak of shmem pages.
> 
> Also, I wonder if the current behavior can lead to data loss on a
> filesystem with backing storage:
>  - The mount namespace where my USB stick was mounted is gone.
>  - The USB stick is no longer mounted anywhere.
>  - I can pull the USB stick out.
>  - Oops, someone was writing there: corruption/data loss.

If the USB stick is yanked and the filesystem uses fs_holder_ops it will
be notified about sudden device removal and can decide to handle it as
it sees fit. That works for all devices; including log devices or rt
devices or what have you. Usually it will shut the filesystem down and
tell userspace to EIO. I've switched all major filesystems to this model
a few kernel releases ago.

> I am not sure what a possible solution would be here. I can only think

None from the kernel's perspective. It's intended semantics that
userspace relies upon (For example, if you have an fdstore then you very
much want that persistence.).

We could zap all files and make the fds cataonic. But that's just insane
from the start. It would be a drastic deviation from basic semantics
we've had since forever. It would also be extremly difficult to get
right and performant because you'd need algorithms to find all of them.
Keeping a global map for all files open on a filesystem instance is just
insane so is walking all processes and inspecting their fdtables.

I don't believe we need to do anything here unless you want some tmpfs
specific black magic where you can issue a shutdown ioctl on tmpfs that
magically frees memory. And I'd still expect that this would fsck
userspace over that doesn't expect this behavior.

> of blocking exit(2) for the last process in the namespace until all
> filesystems are cleanly unmounted, but that is not very informative
> either.

If you just wanted the ability to wait for a filesystem to have gone
away completely that's an easier thing to achieve. Inotify has support
for this via IN_UNMOUNT. But as you say I doubt that's actually helpful.

