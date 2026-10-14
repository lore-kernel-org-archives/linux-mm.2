Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8942DCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DF2B6B008C; Wed, 14 Oct 2026 07:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F336B0092; Wed, 14 Oct 2026 07:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F836B0095; Wed, 14 Oct 2026 07:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3CAC6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:44:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 670351A0226
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:44:40 +0000 (UTC)
X-FDA: 85321049520.23.0884A5F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6BFCB40007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:44:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yKmZOQSx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5+jJryL2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yKmZOQSx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5+jJryL2;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791978278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocy9Wwhkw9+5dyQRVw3aQD1pCbreLfNwhPg/38rBAGY=;
	b=thJlUisojwYSUHdX7U/OL1yXvef41acwN/OyW7VGSFGGWmGy1f8LxLG8/l7uZtteGh1Bhb
	7ELCiu0N3G2Y+zqVogWE+gRPCcLB8lzD//RiP7geY1eDubwDwDrQAZOEX3tzUdsWujAMkG
	InYCY6O7EPmo1nlRyStvQq/wVtJBrLg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791978278;
	b=IYCMSetb2l6giQWfg/is3APCjZ/Dzy2IawmSdSkfe2RAdTXXihHEa0l3cJRypXEqsvxmMF
	INrqsb5NZULpMhrDjaG6J7ofTWAHBojtSEQ48kjrBTy2hDK7mkY6TZJmR/0O4Il+EdF+BC
	3MuybhDNHNW9815jDQHaxD1laRMut/M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yKmZOQSx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5+jJryL2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yKmZOQSx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5+jJryL2;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 52D3A1F444;
	Wed, 14 Oct 2026 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791978273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ocy9Wwhkw9+5dyQRVw3aQD1pCbreLfNwhPg/38rBAGY=;
	b=yKmZOQSxIP3kVjIQiTjJhWCHb4UBZoyBnOajU5pvdAR5Li5L43x9z8gD5q4vl9eas1gVIo
	S+71RmQO3L8TWgp+Mo+R6DMrX8lk/40GwIdH9QB2iD304X0kihJkRZQFom1dsyyjmxUyYL
	p7Y8CLopXhJzPbmZujtBV8GFmKJopM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791978273;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ocy9Wwhkw9+5dyQRVw3aQD1pCbreLfNwhPg/38rBAGY=;
	b=5+jJryL2Sr3cnYe+um/+1olGL/Y1sVC6bNMVH/JvMG1XuKbdJrVVb6hRlMrnfIIjuvEp0s
	GoJVHwHp+PfxbMDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791978273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ocy9Wwhkw9+5dyQRVw3aQD1pCbreLfNwhPg/38rBAGY=;
	b=yKmZOQSxIP3kVjIQiTjJhWCHb4UBZoyBnOajU5pvdAR5Li5L43x9z8gD5q4vl9eas1gVIo
	S+71RmQO3L8TWgp+Mo+R6DMrX8lk/40GwIdH9QB2iD304X0kihJkRZQFom1dsyyjmxUyYL
	p7Y8CLopXhJzPbmZujtBV8GFmKJopM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791978273;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ocy9Wwhkw9+5dyQRVw3aQD1pCbreLfNwhPg/38rBAGY=;
	b=5+jJryL2Sr3cnYe+um/+1olGL/Y1sVC6bNMVH/JvMG1XuKbdJrVVb6hRlMrnfIIjuvEp0s
	GoJVHwHp+PfxbMDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28539133F1;
	Wed, 14 Oct 2026 11:44:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aASqACFrz2pyRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 11:44:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 44ECEA1411; Wed, 14 Oct 2026 13:44:32 +0200 (CEST)
Date: Wed, 14 Oct 2026 13:44:32 +0200
From: Jan Kara <jack@suse.cz>
To: Jia Zhu <zhujia.zj@bytedance.com>
Cc: Jan Kara <jack@suse.cz>, amir73il@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v2 0/2] fsnotify: drop SRCU across inotify event delivery
Message-ID: <mzx4rhr7zqhza6qh7zefytrmcx547nh2bvopwtdnannhnjl7md@sm2kdibrorwb>
References: <cover.1791452174.git.zhujia.zj@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1791452174.git.zhujia.zj@bytedance.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6BFCB40007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: prxdkxea8nx6c93ywp657eetbpxpwcg6
X-HE-Tag: 1791978277-907888
X-HE-Meta: U2FsdGVkX1+ZvCdVkq+wzFsyIVTA/GwYl8ozAC/lw/En9x6bKyj/j74uRxXhzL5ppPClV0QpYJQzTSG6EjO8L33JEQf+PZxtDo+V5P6vX4AuQH9EO0oM2bTosbK5fQTTEUZGx5Bzgm4+UpNYuH6xL5TaonPpKFW2Lpk3j39CoG0C8P6ySrUZNNRbhXEzhqTXW6pfNvNGol0Hhz9dM76wcgFGkn8Ye0CRtnlhZWLehwxmN7uhapD6zzpnmHnMY2EEZeY7i5KFlV7aOrcbpt/eioQVGeCLkVQbTQykIhqhqwH2nZzo45vO6WntUNM6XnTk6qeN6BbHDclOH4SjjN7HJpLxJDPUwATaiQJ7H+SsSODqgPMZLuSAe3WkZeLW3WhRUrkwhgHS5C4avxd2mkGHhC0khfiB3shHfedYROvPEivZvGfxsrSNH+7QMmWiDkgDgp1z2sV3lLmoRBw7x4RfDDmo54tmJpo7L2yz8/cyihfyCvp9U5IUe7v//0J3OAhpwQG9TgA1qh2JwXO5AjRe4w/Z8A+iAI8Cmev8quM8VmKeHB385zL/GkY2eILBDTjnM5Nz1zPnUxVHK0hVvdWctyfsG7H7GAnBmCgx7gj9rZmdp6d1JBa/uJgMczIoTiTi5aDMcsgFCe9bx0+F8+BKAX+9RcFJkWAMkjNpq0psyEDGNMvBNU8TKYeoBdb77/vR+k0yliY7xzfuBngksqRhgZTU9D7WLebCfN02PIyht6ImquCc/lOr1nFeIovrQafWfF2/lXJQujYnsRe6dfbxyy8XILXvdzPqaZcgGzYIfj5rIFrMmbkrwbS7RhGXv/d6Lh/CJwkW7ndgkd7ganGrLfFp//vI8k+CIKY1ytdzW89cH7Gg0Vy1IPQ9mAhg7RTYJvMRMr2yQ1kDCFxQLvzQ2d3iL9Q0iXTccScEENgCz7sCXjM2XNRpckbRzlQJSWAHKXJ5v12ZUwSihnvY376
 YAEhrgM0
 CbFpnzM0BYGTqKNYLbJLuvDeSZF0nBuuoogmR43fHZWQ8CvmX3DsdihEuAJLYxWMJVYniE+5CIu6rgPxFBkcmh2o7vzyCY/Z6thuTea18hJauNSkRN3DMV9ix0zIVwdM3uL8Jr2+ve+dhSbPDsc12ex55e8C1yzPV4xTqzNayJJjY/XgQ9Gpg2osMVYl8ccxRBIj4mu4OCP8l79e9t9P07UC0B/XhaH5sEctm8NUN83pfmn7GD5AfMmlqwDsFFjOfljm3KuaDh0wj2El/GjirXyKmSgbwX1dJQq/Nt5FE1rzIow8W8F0756s0sKuTGopJ+FNPKSZxJtADXDI7RuB1gm4hzon0gAGw4GoUDBuHynmwM0OGoB+/SpbTCJ8I3HipeIMHUcTllSeBWOId7uEpNayvvY3lUj+ggNWcqmxcgH2EKUfZrHdJHFDoHZzI22iPs1Um
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On Thu 08-10-26 20:02:37, Jia Zhu wrote:
> We observed fsnotify teardown stalls in production. NMI backtraces
> showed inotify_handle_inode_event() in memcg reclaim, and the mark
> reaper, inotifywait and a systemd process were reported blocked for more
> than 327 seconds.
> 
> We checked upstream and found the same issue: inotify allocates events
> under fsnotify_mark_srcu, and the global mark reaper waits in
> synchronize_srcu().

Thanks for the details. Well, it isn't only inotify. fanotify also
allocates event structure for each notification group when the event is
generated. But when you run setup that can stall for over 5 minutes in
direct reclaim I wouldn't really say it's fsnotify that's broken :) In
general this seems like a classical case of priority inversion where some
heavily throttled task holds a resource other tasks need and so they block
behind. MM guys are actually looking into these issues (e.g. it was
discussed at LPC MM microconference last week [1]). Adding Shakeel to CC.

> The production report shows multiple inotify release paths blocked
> behind the global mark reaper. Because SRCU and the reaper are shared
> across groups, a stalled delivery can delay other groups' close() and
> exit paths.
> 
> Patch 1 pins the iterator marks and drops SRCU around inotify delivery.
> It retains fanotify's pinning semantics and preserves event delivery to
> a surviving inotify watch when another watch is removed. This leaves the
> reclaim stall itself unchanged.
 
This is going to noticeably slow down event delivery so it isn't really
acceptable in this form. I'd actually prefer if these cgroup priority
inversion issues got somehow dealt with in MM or with its better support so
that we don't have to add complexity to fsnotify for this. Also note that
even through we can drop SRCU like you do, the task that is doing the
operation on the filesystem will be still blocked until the allocation
succeeds and will be holding filesystem locks. So although your change will
address the particular stalls you observe, other types of stalls remain
unaddressed (which is another reason why I dislike your solution).

> Patch 2 skips the global reaper flush when only the closing group
> reference remains. As Jan noted on the earlier patch [1], this only
> helps groups with no outstanding marks. It is optional and can be
> dropped.
> 
> The teardown fast path was checked in QEMU with a test-only SRCU holder.
> 
> [1] https://lore.kernel.org/all/4467cbj7eivubtdwcawvr7mhrb7armgoc4xfqjjnncrbkxxag6@3mmou6nhviao/
> 
> Jia Zhu (2):
>   inotify: drop fsnotify SRCU protection during event delivery
>   fsnotify: avoid unrelated mark reaper waits during group teardown
> 
>  fs/notify/fsnotify.c             | 15 ++++++++++++---
>  fs/notify/group.c                | 26 +++++++++++++++-----------
>  fs/notify/inotify/inotify_user.c |  3 ++-
>  fs/notify/mark.c                 | 26 ++++++++++++++++++++++----
>  include/linux/fsnotify_backend.h |  2 ++
>  5 files changed, 53 insertions(+), 19 deletions(-)
> 
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157

								Honza

[1] https://lpc.events/event/20/contributions/2418/
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

