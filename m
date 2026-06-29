Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCDC5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B80D6B0005; Mon, 29 Jun 2026 03:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868DE6B0088; Mon, 29 Jun 2026 03:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77EB46B008A; Mon, 29 Jun 2026 03:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 489756B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:12:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE40912058A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:12:20 +0000 (UTC)
X-FDA: 84932081640.23.18E05DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DE386A0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:12:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MrYJJ0zh;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782717139;
	b=WjwY5nyvdMa/Zj5lDI+4hVV4XIEGk/Sbukktca2CuLmFvwNAIRsJhzaSO2iy5gu/uOmA0x
	u51+C5SHLFjQqTQjZ5AG1JgaF0oLJiwlXefmO9npTW/56vOOsGRCqjFX2NHBKiDWfbI0Ud
	H6ipRYp8x4z9yruhOnW/42sHnMQ6rt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782717139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfYGT01dvLOEc8FqHgrZrGneidKm26R2Z1JVOqhWxrM=;
	b=iKNDycYblnSfr1aclWLwBeG4iG1oTB30pw7cPVUnL2Mv2RNqKDmTCOChQtoE6xAFReKiqu
	bJkgXESEGQjTOE7jf0n1N+rfdfRWuFo6nLOQUgX6Wdl1duopC0X6wm4Pr15yTq0RvoAegv
	ZeLYc+hNbBipLIh0fHVP7apes1oqAQk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MrYJJ0zh;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9AF7409DF;
	Mon, 29 Jun 2026 07:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2920C1F000E9;
	Mon, 29 Jun 2026 07:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782717137;
	bh=RfYGT01dvLOEc8FqHgrZrGneidKm26R2Z1JVOqhWxrM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=MrYJJ0zhU6cSrLl39RQigi+2QZvaFhOxbtu1yEA6hTyfVFpe/kYj8ZS00AXP7ptpn
	 Zs/rJ4Dk4D534ofnWSAGcbnEwLBN/KnvzIci93vQYjVXwfpFlx1AlhBW9Fl152Ded2
	 /d2CVFTAmvwi5kDgZUn7qhQmYO2wdcMIKJ4WVa+ZCyvoFeewkXIeIOzYKTxPYfM626
	 SjdOu9pZ7M9zKvR4x37LFNlLbmDD8YtYoeFwpksA/Z471kU6qCbYSB3sCDLkxfcAQi
	 JOMt77dEy2HlYYsyn4/PmvnAsM7jCjaWO0fNwc7DiAVI1I8URakcULdgc+Xyp2+ihr
	 o5UyVL2HDf0Jw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for
 pre-exit before dumping
From: Christian Brauner <brauner@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
 Christian Brauner <brauner@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, mjguzik@gmail.com, ebiederm@xmission.com, 
 viro@zeniv.linux.org.uk, jack@suse.cz, jlayton@kernel.org, 
 chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
 keescook@chromium.org, mcgrof@kernel.org, j.granados@samsung.com, 
 allen.lkml@gmail.com, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
 Xin Zhao <jackzxcui1989@163.com>, linux-mm@kvack.org
In-Reply-To: <9a8e189a-39b4-4571-bdd5-400cf6443204@kernel.org>
References: <20260624145552.70143-1-jackzxcui1989@163.com>
 <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
 <9105c433-44a7-4e8f-bacb-def93d11a7f2@kernel.org>
 <aj0Mr3e9yt0kU-Qj@pedro-suse>
 <9a8e189a-39b4-4571-bdd5-400cf6443204@kernel.org>
Date: Mon, 29 Jun 2026 09:11:33 +0200
Message-Id: <20260629-zunutze-wirkt-furor-e9ed5e4c31ee@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2891; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iIFLBAM/tIt0dQ5zz76F+VqqO3DXDSEYi0YBpjgPesI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5Se197O5/9JN18ZuQuB087FV2hsyBitO0r6+OvXRY1
 uRYwsnzHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNpn8HwV3pngYVt49uynd6p
 3+a2TZzmxvVtguLbMr6tfY9XBIX9bWX4n9C9UiVUPda/2qBRe06i9a2NodH7fbWCpnPt/WTjph3
 PAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE386A0002
X-Stat-Signature: gtajrjp7jubu1nj1nso9b9bt4w9xkaga
X-HE-Tag: 1782717138-558921
X-HE-Meta: U2FsdGVkX18JhP4EY7yEoRUpjcHNi6h4vTUARY/vNsjU1RzIoK+KXESrB/5cTdsaF6wAAbqMyW2clYyeU617YqUctk1Baz5qmQ9/Tu2L1tlFoWbyNeJyPaD2aAP0l1njTv4ktijk9r2wNFinx13ZafBG2Wzx9EP/F9xEiDh06ZoH3DpVPJPzikH2TCo4iTPHns/s1I/H4SMJ4aNM6I73nbFlR1fJdvktZzbPY+t7FUc+xGGoD+3p6foDR8XephBRbWtALu+I164n7SCtfJVOUTxytTTCi9IAOgRHNIiJkQ0qiMm0P1smxFMJzpznLeHPeTeOiKpqAVrBasiyPIVWdUBb0BrpO0kHO5q8TNAUhIVwZM5HXX1M0j4HZ0MZ8LUutEobVvrvjJhaBsrIChmSF2ia+sotObejGlGZx2jfnNYyhMEIDldZGUYTs/KtxerRH6yUKofoUwiYdvJvZ2tYmBa+G6ntFstHoU711P48LfVd8TZNxyl1yhH39JTLB1UypAUsz2tQ/MhhGcCjGF3+vUs/EC95PDGN2hrSNpY3KRhO1GkVXHgyrkWefqtNk+FNnQ3gn9n09fmKyL7Gt1o3SPzrqPO3bbZDwNYJQI9IeE82lcbCP0o1gPiAfZsnnlc8dlocFCLrfKS3Q2vWjJV8pz+65o1jiefObAvHbJs4U3GylNa+fEBte2BCRqEiYfSnnczQWVRlzohGIba2pIiFP12z6ElHl/oFrZheZ7XYGpSXJGMU20S4XJ2u8tp/p6DS2ks0ZJ6KBK7pQS5Pn7/8WJJH1cH0v5XWI8d9pXX+FuFz46xVButHFdRHlifIgV4YTETKbFuBfkcWppxwQAAonN1pm7N2kedbuIGDwLpc846BrqbGviMa/q+G0nlQLYImuz1Ts+e6aq9k4mRvW0HEk2nesEv1VstD2f1SeCGN0B5sGHv58ukryO9TdojEufduB2HSOpV0FApmRflunF6
 z0ft5kM+
 GFJEftGocqIAjPvxMZTYWE7N1nHvcokGqNHT1vRd7sLuRK2KAcZ+P1KhV34xtCVW4g7zdTGmYqWl+d7NDQndA6FjZUpwtB3Jq5so8IX1ZRY6TVCvRcpZiAPGkOhQUm6Ti2J5GCb5vu07nQizQHXd6+pNgpcCQCpuv4QYnyyrwxbSoK1ZKUJzCBLgbIAkF8VL7c7hIMNU8C4FajRfBbTWuaK0xU2AxaumSbZPmIG6bOXAwNSRIuHNqXdLyIBR3c6hfw8x+GkdVIwjkWWX6YofeA36lYZfQqgW5/m/3RNzDEYoMIUsVmYLEJKoTfgj0Wh2bRn09SZY8Vz4KyWtpPq3sUCfUN9SkD2VYzEmR/0HGOJSCNJk4RGBataKGo36J8NhQcLYx3jdf7QDa0Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-25 13:43 +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 13:18, Pedro Falcato wrote:
> > On Thu, Jun 25, 2026 at 12:57:02PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> This makes no sense. I think you really need to sit down and think about
> >>> a design for this that doesn't introduce state machinery for boot, mm,
> >>> and the VFS in one shot to solve a fringe problem...
> >>
> >> Staring at exit_mmap_mapped_shared(), ... this looks rather hacky ("let's fake
> >> munmap and set some magical flags").
> >>
> >> We're essentially saying "we don't want (pretty much) anything that's MAP_SHARED
> >> in the coredump". And for some reason someone should configure that, that's a
> >> rather weird toggle tbh.
> >>
> >> And the granularity ("file-backed shared memory") is completely odd.
> >>
> >>
> >> Aren't there other ways we could optimize this internally?
> >>
> >> Like, if we know that a process is dead and cannot run anymore, downgrade writes
> >> to reads (and make sure we block GUP write attempts accordingly), or would that
> >> also not be sufficient?
> >>
> >>
> >> Another thought:
> >>
> >> fs/coredump.c calls get_dump_page().
> >>
> >> get_dump_page() will not fault in any memory. So if a page is not in the page
> >> tables at the time of the dump, it will not get included in the coredump. Which
> >> means, that whether most non-anonymous memory will be included in a coredump is
> >> already like playing the lottery.
> >>
> >> This is true for MAP_SHARED file mappings and MAP_PRIVATE file mappings without
> >> private modifications.
> >>
> >> Which makes me wonder: How much is tooling relying on file-backed pages to end
> >> up in a coredump?
> > 
> > FWIW this mechanism already exists, see /proc/self/coredump_filter. The
> > default is bits 0, 1, 4 and 5 (see core(5)), which maps back to no file pages
> > being dumped to a core dump, apart from ELF headers (these help the debugger
> > trace back the mapped binary to the debug info using the buildid).
> > 
> > So the answer to this question is "approximately none" :)
> > 
> 
> Ah, thanks! vma_dump_size() honors this, and I am sure through some magical
> routing the information stored in m->dump_size will end up not dumping these pages.
> 
> Staring at elf_core_dump(), this "unmap some stuff" part is really, really
> nasty, as it effectively removes the VMAs->segments from the dump. (unless I am
> missing something important)

I would not mind if you would clean the mm portion of coredump up as I
think it's pretty ancient and - as you can see - rather questionable.

Fwiw, for the coredump socket I added a "userspace" mode a little while
ago where the kernel doesn't actually generate the coredump at all but
let's userspace do it. Android has the same model but uses signal
handler tricks (iirc) to do this.


