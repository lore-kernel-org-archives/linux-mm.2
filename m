Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D08CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967296B009D; Thu, 15 Oct 2026 07:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93FCB6B009E; Thu, 15 Oct 2026 07:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D056B009F; Thu, 15 Oct 2026 07:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1276B009D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:43:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8E83C094A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:43:12 +0000 (UTC)
X-FDA: 85324674624.01.C3F6D54
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf21.hostedemail.com (Postfix) with ESMTP id E9D551C0005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:43:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=oie2kMyF;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf21.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792064591;
	b=C81JB3NCMCZG8D33ekUaMVpTiIRH7f6eDkbYCqGKONvuJ3q/3kjupBJJshmLMY6OoOpP1z
	jI5iKj8+Zm3aBc3YQe4Ozpe7FERH3C+YGhA2rUH8paTmH15/Q72i70BMzbTH1XyPGsLNVH
	ULe/qbzHpY5EvehSwgUYMbCIUl4a3VQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=oie2kMyF;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf21.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792064591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YDGQhlGINpSPM53EPb5WQDPiXIGq0eajS/04uEiHt3I=;
	b=P6T3gjzx1zqPAzCUIvmLlRyiwoYnpzNUEjo+ojXDI39oaVjUBlceUHjJ5rfH3F1PkEnDBP
	yY326+wD8oYcgZ8hsGojFrZk1YY0AXxI1MEkTQcuuXEFonvSisLNgpn096j4iJx8Y74YNG
	+ndaw37Nlo2Hq9cMf2gpAU0q3KwvCn8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:mime-version:to:cc:content-transfer-encoding:
	content-type:cc:content-type:date:from:subject:to;
	s=s1; t=1792064589;
	bh=YDGQhlGINpSPM53EPb5WQDPiXIGq0eajS/04uEiHt3I=;
	b=oie2kMyFov1hla3mld0T4ApOwSy72MrCr1e3xqtwc1ASEmmv5ZDbyWPmePcf2LO3rlqa
	hL8jMODArPU80MFo2yyeGmp90iA7wVZWZJ0g6RIzeoDGnEr0wNuUlwUtEqH2l+JsEEZV8a
	v0lugJ3N5qPQSfdI9nSPN8bw/+JyjiegKgbQQfMJOfp1kjv8+a1FMrNksBWmJIC8nfVlzi
	gLIuHM9ia5ELs2GH92oq8HuLgeiAcGd7R+SVwEl7ZrcEJCd0APAuVbTK+hCZp6e6k+Y8Uk
	dUTDAquv15AbJCFm9w3QTKOrShy7tHlxLe3YQWom1mKpEG+VOFKgqp2FmytANYnw==
Received: by recvd-canary-58784594b9-s44q6 with SMTP id recvd-canary-58784594b9-s44q6-1-6AD0BC4D-14
	2026-10-15 11:43:09.292501886 +0000 UTC m=+1363369.825756546
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-83 (SG)
	with ESMTP
	id HHz3NpWqQwq5869tmBL4PQ
	Thu, 15 Oct 2026 11:43:09.124 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: [PATCH] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
Date: Thu, 15 Oct 2026 11:43:09 +0000 (UTC)
Message-ID: <20261015114307.1041273-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmee6tjAzEd4N6?=
 =?us-ascii?Q?h5hjz4W8xyC5g=2F6dVBEu2QNVvEvYnKd7+KOyPIL?=
 =?us-ascii?Q?xLHG5pUwOvvkK=2FT5OdJf55Js6Vqu0q9rSFlh4ik?=
 =?us-ascii?Q?Z226Qa9s3cfClCVqW0CeKHerDM8s2p=2FRQbd3VHa?=
 =?us-ascii?Q?ayOgM26DztqzBw3DaJPl=2FgKMX5t09C03xtIMZ3g?= =?us-ascii?Q?PK6D?=
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Christian Brauner
	<brauner@kernel.org>
Cc: "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
X-Stat-Signature: kju3ohh311g3guf1yck4eoowc7ur8wdg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9D551C0005
X-HE-Tag: 1792064590-713672
X-HE-Meta: U2FsdGVkX1+WzUmXxZjxsBPNsSd4pogQ+0TORvHZU5UKsncexrEQftJO67C3r1OISOdRcg0FFuvdY3r5eEoNbhJF2heu7iWrXYvuVK8Tg+A9H5djxsaz4dHAo4s5jueB6/DxDan7QwiiIPG6RZyIQlkjBZ48i7S1uIOeMLU9+z0Qm7zncANxj6m8ywBzVEbS58BisVHTWqwxnVOPLYySSs6MIle5AW7TwFIllE/kMzZMrTRyHI4uHaLYJvH7uoL4gcBbbf5kR+L1wWVb6CtB7AimB1tvw+op81FZgyePqhB8NEBPljeaSe/nSRJp28uG4jCGfK+mBnpW1wVk975hzSdiHEWunmQ7sWyrGL2cX/MyxNgHtjZxU6Z8vHuJpimMYXrGozz3IrK3w7LsZ402VW4WGSs9u7dRzl0sOciEps2zafaB6luhCWP9z8UyVNNwGYxV3JfsM5/yVeldkqBHxqF83lkqa6M7BO2Z9Pw3RzU2FHCK+Z+WBebkVHH6uP1z2ikYJI4yb9WLfujPw9L+l32PUlSNLaa6Z0Zpe3LGV8hOSXKgvd1uVEb9gPVNgYlrTUyI8yNB7uwKvIEq2XGxUb2DvBIixSWT04sb3GbybJSd9kXYPCEFttPEYGZqSmIvbhyqWUhLjav76rKHbJqmp9pSE+TYvSx1A9bZtUAivEIwSWyfB+TCv4NVdWkFW+cueG2mwy2pqcDDRQ2V8YBc8wZbdWDSRI7ZflMAIMsGufik6lU6CuanKYih58QoB/fx90nSLW3FwtS6BDe9/FtAwOmCUavX5biRh8HQF7cDgJY+KxyIRbTx8uPd5+veyPdyJcNUnkdzDxuasObaexGk893yhkNPRcclmKtr5alW3u90jm5QHU4j9hq25fGTmkJTLAd0cCntXHQeA5/KdL5EKNwhUKt5GHUklNeA5CI4HPmKKaf/FS67W+LpO0crtmsXl3JjgU9Ne6Czw0fx7P3
 lbITz/mW
 J0kq3pB5EaY3gEeVakkJ+4DPN3JjMLUgqe0wGlX1kHuXMuCMvig8JEE9GwIqF3iUhALJrgwWwYSmrAMlUVkj8beJlyb04pmFwBAZsNqbWjSBuPqUv6H1kBNli4Bs+5uw9gyWZxgAGPIDYS2VGuGsFjrk/bjJSnyY+E/NQuAJ8H5zwvG0QH/NwlIwIWjbUGHEs8I2PSsquRHPoVw0Qb4VYN+Tm4wp+Uaz7ZYJ4oIjugXM6xdzphRa2gwqTxhTkl9KsOBlSCO9WRMN6clBRgjbUKT/4F6fg+Zrmr8N4QKyr/na5pln9gv45Mr4EwTDII07K3a9thmHraz7UtP2vk75lqbfnINLuWHhDouBu6wzJiRXMO0M8eTz5N4zWE1jgtp1H+N/0o0PltlTmUIawcGgk9u/y6yxaZkDRKTmlxs3fEBOkEeNGNIKTu6Uxfagjf0tUqG8OpIuggUo6Ol4p3F0HDvlcrgaJd4i6HTa89mVXYuX+kG+5WKcFL/v17/SF0bLV7QTkWjYfrGPXZbpvPmPytaeuLzR1eeHDcJtnKojUIavpjy/JlxnJeVPHY91hbF/ecCX9MQxpOLANW1vLYoXivAnb2VBh4m/RD+3y7hl2QRfDES578I7+JvJl6SRzVPIL0Xzt/nys9lkcXma79GU3dJ4cLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On a filesystem mounted with lazytime, sync() and syncfs() can return
without persisting timestamp updates (atime, mtime, ctime) of inodes
attached to a cgroup writeback that is being cleaned up after its
memory cgroup was removed. A crash after the sync loses them, contrary
to the lazytime guarantee that sync persists them. File data and sizes
are not affected.

Trigger: a wb has lazytime-dirty inodes on b_dirty_time when a sync
starts, an inode on it gets a timestamp update after the sync's cutoff,
and then its memcg (or, if the wb is already dying, any memcg) is
removed, which runs cleanup_offline_cgwb() on it before the sync work
queues inodes.

Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves
every inode it walks, prepared or not, to the newest end of the list.
Once an isw fills before the scan reaches a newer inode, or a later pass
walks past it, older inodes land in front of it on b_dirty_time. A
for_sync queue_io() expires b_dirty_time with the sync's fixed cutoff
and stops at the first newer inode, so it never reaches them. The
switches themselves already wait for the sync on wb_switch_rwsem; the
scan does not.

Take wb_switch_rwsem for read across the scan, as
process_inode_switch_wbs() does for the switches.

Tejun spotted this reordering racing with a sync on b_dirty in a patch
under review and suggested holding wb_switch_rwsem for read across that
scan [1]. cleanup_offline_cgwb()'s scan of b_dirty_time needs the same.

Test, with a debug-only delay holding a syncfs's work on the wb between
its cutoff and queue_io(): 300 files on a cgroup's wb with lazytime
atime updates, a syncfs held after its cutoff, one more read, then the
cgroup removed so the cleanup ran. Without this patch, syncfs() queued
48 of the 300 and after a crash 252 atime updates were lost, on ext4
(-I 4096, so neighbours' timestamps are not written along) in 3 of 3
runs and on XFS in 1 of 1. With it, the scan waited for the sync, which
queued all 300, and none were lost.

Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
Cc: stable@vger.kernel.org
Suggested-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/ [1]
Assisted-by: Claude:claude-opus-5-5 checkpatch
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
This came up while answering Tejun's review of my series "writeback: let
foreign flushes reach dying cgwbs" [1], whose patch 3 had the same
problem on b_dirty in its own scan; v7 of that series [2] takes the same
read lock there. This patch is independent of the series and applies to
7.3-rc7 on its own; both together apply cleanly.

Impact is limited to lazytime timestamps on inodes attached to a cgroup
wb while it is cleaned up after its memcg is removed. On ext4 with the
default inode size, a write to any inode in the same inode-table block
also writes the neighbours' timestamps, so fewer are lost there; the
test used -I 4096 to rule that out. XFS has no such rescue.

The debug knob used for the test, applied to wb_writeback() and not part
of this patch: when /sys/module/kernel/parameters/wb_debug_sync_delay_ms
is set, a WB_SYNC_ALL work on a non-root wb sleeps that long once, after
dirtied_before is fixed and before queue_io(); it also skips sync's
best-effort WB_SYNC_NONE pass on cgroup wbs, which had nothing to write
here. Steps: mount -o lazytime,strictatime; a cgroup writes 300 small
files and one more, syncfs twice; read the 300 in order (each goes to
b_dirty_time); set the knob to 10s and start syncfs; 1s later read the
extra file; 1s later remove the cgroup; after syncfs returns, crash with
sysrq-b and compare atimes on disk in a second boot. The scripts are
available if useful.

Tested on arm64 KVM guests (virtme-ng) with ext4 and XFS on virtio, on
7.3-rc7. Not tested: x86, production.

Developed with Claude Opus 5.5 and Claude Fable 5.1. Fable spotted that
cleanup_offline_cgwb()'s scan of b_dirty_time was exposed the same way
while checking Tejun's analysis, and reviewed the fix and the claims
here; Opus wrote the fix, the reproducer and this text, and ran the
tests. I directed the investigation and reviewed the analysis, code and
results.

[1] https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
[2] https://lore.kernel.org/all/20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io/

 fs/fs-writeback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ea3eb40bf828..99570aacdd18 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -789,6 +789,11 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
 
 	nr = 0;
+	/*
+	 * The scan reorders b_dirty_time.  Keep it out of a sync's way, which
+	 * could otherwise miss timestamps moved past its cutoff.
+	 */
+	down_read(&wb->bdi->wb_switch_rwsem);
 	spin_lock(&wb->list_lock);
 	/*
 	 * In addition to the inodes that have completed writeback, also switch
@@ -803,6 +808,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
 						 &nr);
 	spin_unlock(&wb->list_lock);
+	up_read(&wb->bdi->wb_switch_rwsem);
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


