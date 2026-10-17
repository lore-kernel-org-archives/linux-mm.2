Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4017ECCF2CF
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 18:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB53B6B0092; Sat, 17 Oct 2026 14:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D4D6B0095; Sat, 17 Oct 2026 14:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4A06B0096; Sat, 17 Oct 2026 14:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B83F36B0092
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:39:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53CF01202BB
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:39:27 +0000 (UTC)
X-FDA: 85332981174.07.125C47F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id CFDE01C0004
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:39:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TstxZChG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792262365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=j1Sq7gj02Y/fsM3Bj+ujep5VUm++/+h+05QAs23TGuc=;
	b=h3vnyTQ1XbCMsTrTFRFDFS4mm+ENTf7sTwWFl7/eJULwQk9phjQfNjTYPDuQBrnqIbGK5t
	h4Gwi6/YihdV+s0tbtggmKX4eCu0aUqJRu0mZLaJj8RMWMrrrIkH5IsuSpDgO9gMhgmvK0
	FOwqbX2Wk+OaJo6HCbQACwGrDBAEKks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792262365;
	b=hWSk03KFe3WTN1sFZyiIlnE6Dx+fRamog7/uS+mRTnxG5suZghvfvgha4PgHtw0TGesvyp
	kJGpqH1htHt1+fcFnZ6SaJwIRQvF7Kuus+hPtsGXzpyGNih1/nftuDhmsiI1H01g4HMYGL
	RjOockRm45CfbzDPP/O5YoNAHa7/Nls=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TstxZChG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D0E7413FD;
	Sat, 17 Oct 2026 18:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD601F000C4;
	Sat, 17 Oct 2026 18:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792262364;
	bh=j1Sq7gj02Y/fsM3Bj+ujep5VUm++/+h+05QAs23TGuc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TstxZChGQhlAuN6Vej9C86VmeJrYsg6BGTkCv6R0i0K3kqID3y+bag3dhJce+nGQH
	 ODj7UFvSgACiwPEL1V2lXbM3HvQt116JhVq3iTZpDzgklsAI96nyqRIZwQaGKTD9BC
	 8iytmUz8y8rfqy0kLxRKpBhXoUOgwl4ewJuFnxylRQoqr0W/LrtB4QXX5C2cX608wl
	 hdyuNckobaYMHxvEeEROYyekawL451BiQrTfaOIWoBOdTXFT3vPmGGTt8IEZ5Ui1lT
	 y+g2jNZHceecB7wy9xllu1qZSRqPAPaF90JpJbzPRvArfa2BGQtN6J2JD2nIT5g7vf
	 DzeDRtAFsALNw==
Date: Sat, 17 Oct 2026 08:39:22 -1000
Message-ID: <39c61e6b4d8064bc10440e6fbb00ce05@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
	"Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
In-Reply-To: <20261017040710.1174009-1-lizf@honeycomb.io>
References: <20261015114307.1041273-1-lizf@honeycomb.io>
 <20261017040710.1174009-1-lizf@honeycomb.io>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFDE01C0004
X-Stat-Signature: gmx39d3k6pzyhhgwtzeh8emn5c1pjhgz
X-Rspam-User: 
X-HE-Tag: 1792262365-155936
X-HE-Meta: U2FsdGVkX18oCERyVmHk1iftp+PRuUTGKEDI1rsFD3ZFa4v6geW5seXqQNrCjZHM+YbJNu/FefGvxcG9By6A+CoAmYk5wYVgstWLrlZkQOA+ivwq45Fn5+AwBEZq14VVwwu0Nn6ExARBpkFp9MaT9joDPD5paXhEkMBeRAcbpxLgxTxlBkDVyoWxzfr6GKy2r8NlBS783LZsIkbwRtXMh946PLbRF9D/s3Jl4QzfvmNQpHTF9JAO7a5YjmO2w98bW8h3hEUKKw2eMnmFAjD4rsKtNUkiIxJjz3uyk/4yLemETtDauq2XXNOgvWPTB19navlMV6Onq4EMaIjm4RSozB4qD03VBaQOCmC2/HCvenUXZ3DLZuyxZI1RXkgjO0Z2vdt6uT43ob+BdJTAfO6pfFy/isIjLAN5qHTOY5Vv3mnlXIOuKnyLcba2MZ3UAl460vTX3zBSkpuZ6JJds9LuBo/iU3/5t/JZtYi1J705dc7dzGZQfRAkTpqHdrkd152XO4GXwBgN7aO1nTxcrtUcoZ9M0/uYIwim6SMfPaugaqeEMR2PdLvj5YjADF4Nt/8U35UUnrwRuUlTPSMTpA/wl99JDzQI47+t1Hasvde1cHRtUAB7NkbH1t+OQcnOUXtkiLq48EYqjHEqbT3cF95TIlkzArQXXkGQT1Fo7gmCKH0AeoZRHhubX2ifbjmrtPXRbubbmApTmehoM0yrdXTZOayBxTg14PU1Bpe/wKP6i4VX6UB+ErIY4NWd0xrwUxKWpjPstYsh+uiRtFmxgGWV5RVxb2IAsGfwxRAORyRXJTccjEwe5Vxy9L6cbtlW8UPOS8KEm6JbL0RbK+zAQ0EtFaVvdfAxwDObwci1BCUSGghQpSJYrz4Q7BlnY6b7w0w93XCZWjcDtOI0SzitkoRiMW19LAoY6+ZQI39lvtp9Q4wc2RrZZURvddo4zXoeHZr6kZE1WzKcX2tuQf6TVhH
 O9pEaopW
 uFCFrTp7bd6s3cr0ZeQ+r5rU989pZbM6CK+5o9ra4LylYcolbDulylmIBMSRTTJCYlasiHpxmOSTFgLIxzC7xPtxw9ql07XE0VhQ1I65tTGz6g+DMYnkHQAER8M55FsMmE/smcFfbWcvf/HNbOKDNMMF3VsFmCX03X198yIH9tzKccZEJuTqWO7uOHKVHjrxiYIihME6KqcOd0FndVrcuviJuGCqBXKhvco3h1RCh5vjv5aHtrCh2m3bVOwfyxLlObvksclglJBYycoSx+RRWwIDm7OfJFnebpgeY9Wv3QspsRAMmpfh7mRUxWOYYprkc86YmW/jxCf0kU+Lrr6b+6AI88aNWMLS8JL9eH8YfslYjpuqAbn+6MBElWNn3Fh1Sr+sTZZyapCArgmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17, 2026 at 04:07:11AM +0000, Liz Fong-Jones wrote:
> On a filesystem mounted with lazytime, sync() and syncfs() can return
> without persisting timestamp updates of inodes attached to a dying
> cgroup wb, so a crash after the sync loses them. File data and sizes are
> not affected.
>
> Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
> rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves the
> inodes it walks to the newest end of the list. When a pass fills its isw
> before reaching an inode that got its lazytime update after a sync's
> cutoff, the walked inodes land past it on b_dirty_time, and the sync's
> queue_io(), which stops at the first inode dirtied after the cutoff,
> misses them. The late inode has to be one without a pending lazytime
> update; one already on b_dirty_time keeps its position.
>
> The window is narrow. cleanup_offline_cgwbs_workfn() skips wbs with
> anything on b_dirty, b_io or b_more_io, so the scan has to land between
> wb_writeback() fixing dirtied_before and taking list_lock for its first
> queue_io(), unless a multi-pass drain started before the wb got dirty
> IO.
>
> Take wb_switch_rwsem for read across the scan, as
> process_inode_switch_wbs() does for the switches.
>
> Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
> Cc: stable@vger.kernel.org
> Suggested-by: Tejun Heo <tj@kernel.org>
> Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
> Assisted-by: Claude:claude-opus-5-5 checkpatch
> Assisted-by: Claude:claude-fable-5-1
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun

