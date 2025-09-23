Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D070CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFCCF8E0008; Tue, 23 Sep 2025 05:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD108E0001; Tue, 23 Sep 2025 05:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC27C8E0008; Tue, 23 Sep 2025 05:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C6DCA8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:57:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6400458DB3
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:57:26 +0000 (UTC)
X-FDA: 83920062492.18.0BF16D0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 00EB51A0002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:57:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHX7qx7o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ruU2lr8c;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHX7qx7o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ruU2lr8c;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758621444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPVjjucApSRx+R2misnP6FirOYmaZeSfZK2uZlsWJVE=;
	b=G+jleNoBleyI3Oz9oFbFziiwGBtLmE0STT7Kqt5VMqahNxBemKUAbt+66d9hvWGdQshqYR
	8LOTYG2DbpGLWHtj8NHDc7RQFHvQJkjLfgxSMpRGUPFnFWrZwamanbYAP3EtwPS0HvNL3c
	OzvrefdInG7p0QKo6a2MnwawnNuLVgg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758621444; a=rsa-sha256;
	cv=none;
	b=x6TTSB29C5SwmF5zb2LdAY0kug1mmLmQ4uN93Jrbxe41i5/h/Rmbr/ULpEq6DikmirQkLO
	OC6Mys+mRqtfsWn0R75EYgtgzM67YapZrZaxZDKUm1fwFed6Xbmy6fDVhmZWCWzLNn4kwo
	9GvwuGbH/Jc26FsjTXNPuW9Qg7xiDks=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHX7qx7o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ruU2lr8c;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHX7qx7o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ruU2lr8c;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B2A421FCE;
	Tue, 23 Sep 2025 09:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758621442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oPVjjucApSRx+R2misnP6FirOYmaZeSfZK2uZlsWJVE=;
	b=UHX7qx7o2b6ey5mBgk7knXhSh5NAomprqW21FOo3+i6AoaYjVxzuMInDFqJq5xlD0jN7jE
	l9RdrJAOT9uA5RmNnoc82zw3jNRxsSqGPknIFbKilV4hihF0zw/YTsm6ByAapLHTsAV9VO
	57CJylLPXR5bzh84ywSpKTnl/NrVnCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758621442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oPVjjucApSRx+R2misnP6FirOYmaZeSfZK2uZlsWJVE=;
	b=ruU2lr8cQiR7fVNcl8XuNGkvChlzJ0Fo5o5rGdZZM/dtI4Hc971GO4eoOvVJcuZVXmHi3x
	ko66sHZwAV6xxTDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758621442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oPVjjucApSRx+R2misnP6FirOYmaZeSfZK2uZlsWJVE=;
	b=UHX7qx7o2b6ey5mBgk7knXhSh5NAomprqW21FOo3+i6AoaYjVxzuMInDFqJq5xlD0jN7jE
	l9RdrJAOT9uA5RmNnoc82zw3jNRxsSqGPknIFbKilV4hihF0zw/YTsm6ByAapLHTsAV9VO
	57CJylLPXR5bzh84ywSpKTnl/NrVnCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758621442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oPVjjucApSRx+R2misnP6FirOYmaZeSfZK2uZlsWJVE=;
	b=ruU2lr8cQiR7fVNcl8XuNGkvChlzJ0Fo5o5rGdZZM/dtI4Hc971GO4eoOvVJcuZVXmHi3x
	ko66sHZwAV6xxTDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A5E5132C9;
	Tue, 23 Sep 2025 09:57:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BUaAAgJv0mh0YQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 23 Sep 2025 09:57:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A67B1A09AF; Tue, 23 Sep 2025 11:57:21 +0200 (CEST)
Date: Tue, 23 Sep 2025 11:57:21 +0200
From: Jan Kara <jack@suse.cz>
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Nanhai Zou <nanhai.zou@intel.com>, 
	Gang Deng <gang.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>, 
	Vinicius Gomes <vinicius.gomes@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, 
	Chen Yu <yu.c.chen@intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/readahead: Skip fully overlapped range
Message-ID: <cghebadvzchca3lo2cakcihwyoexx7fdqtibfywfm4xjo7eyp2@vbccezepgtoe>
References: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
 <20250922204921.898740570c9a595c75814753@linux-foundation.org>
 <93f7e2ad-563b-4db5-bab6-4ce2e994dbae@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93f7e2ad-563b-4db5-bab6-4ce2e994dbae@linux.intel.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 00EB51A0002
X-Stat-Signature: 9upgur31h3fwc4zm5f7i5fzem6fban3x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758621443-319778
X-HE-Meta: U2FsdGVkX18J+riVI0IsAHnkYyvOx+Erz4Cb0t8xarexUTiYGC35fnpVYBT/9L9mRgoPo210cWnOHVf1uVJvuVYwl+XWAXpxoilinyjljYttlrQ9QI4MdsOLSQTOKQSrJRaaqb6o2Vb/ybd6UjjRUw2+gJRJtxpX/ncmZ6PRnoUp+SCEmE+9Syff41l+NURAVpBW1VRFgnjatfnTc7FYfX+WY5XVjDo87K44CtRsRj795cmwWdCsKzpOOE7oL95fXD2KKCnvNtG38oZAIuJyCdeA6Fbz/+aYd1mgi0SZeoCMGSf7t1D5TuV9qT9i/ToGxOuECVFoODhS8PTOerfNzOWHDeUi3tsZqLdbkzesQMpF4LELh4HNCSyxTuOhXaXgdMNKbKhaATF9c5iugVOrr6m3mNtPHQPFjw8xQ+/LlRDurdr+XLVu1veZe+yu3fkLF2/ATTKo0wvXf/PpVVx6fTIHmciiHA0txuOA2V1uc/bxKWpY54/e7mmqNWh9du05n3UojZYNhfc39lBr2DuO7PMRzbhDpB9Dp5A10GxYaNKkgyzmzJTsBGbt9cD0IZFHCu4GFFRnOfJaEnF5CI4CkCRUxJKkBJLG2dsinGzXcohGDF3CNFqa9pXxWq0g63ygslbiyKXh5ZfQkPs+1OqkbEhDswkNzUKv1ozRxjPX02xy+0Za21Gl105YK/tIJ4ZKTS64QVhdOC/QeuPEiLrrfK4DE8TpTEZVkm2NZpibww+33N7KFH8fI9IUiYER5pgmxx/CoScR42gEL3hjNe7NNImGr/g+rwaqIkU95AbXEcOt54ogmEhpS8vUJzAEwZHLtobA4DKoMZ1pFEKtly/XG8oA9dGMlvR91Eu0a7PlWA2fo6jPtRW7fIhuHfXmm2A7R/+mq4MJC9KeNmUaBwfq+piRVOrggWvsWtk5zRRZnNX3d6X+6ZMUlrrTjgi1tXo8/2DTvJyoXrXPGDKyVhv
 w8Gk63Yz
 jo8SQ6nye2ESR/klYNhxsxmH93PcOQTbCQS5zAG+Tei3MrOr//KO+SIsqDCzin9+W2KFXK9WoD8E7O14j1lq9/ahB+T/ZsbQdbxJzr5XtKtxJ+fdFQFw1RFrcFzxrYk3k88qhgmLQsegJaWv4oBht71iOcUAiupT/ysyhu2HKcLL/au8a0CTt5KzbHjP4jS0IHHClqHOVSPJFjFXUa0w3AROfZgYS3dNRTJ/4IQBawMksHiKzpTNDhnoj44Hvw7WmcEVYWWLWOr53iKwrTR7wIubJ13hbP9MovJMt62k2HlNSfMOUFVG2vzuoFSjNJPAwAhOM6DiakyN8qyo3BG3BYiUSMVi2P/uACWsQv1h5RLP1azE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 23-09-25 13:11:37, Aubrey Li wrote:
> On 9/23/25 11:49, Andrew Morton wrote:
> > On Tue, 23 Sep 2025 11:59:46 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:
> > 
> >> RocksDB sequential read benchmark under high concurrency shows severe
> >> lock contention. Multiple threads may issue readahead on the same file
> >> simultaneously, which leads to heavy contention on the xas spinlock in
> >> filemap_add_folio(). Perf profiling indicates 30%~60% of CPU time spent
> >> there.
> >>
> >> To mitigate this issue, a readahead request will be skipped if its
> >> range is fully covered by an ongoing readahead. This avoids redundant
> >> work and significantly reduces lock contention. In one-second sampling,
> >> contention on xas spinlock dropped from 138,314 times to 2,144 times,
> >> resulting in a large performance improvement in the benchmark.
> >>
> >> 				w/o patch       w/ patch
> >> RocksDB-readseq (ops/sec)
> >> (32-threads)			1.2M		2.4M
> > 
> > On which kernel version?  In recent times we've made a few readahead
> > changes to address issues with high concurrency and a quick retest on
> > mm.git's current mm-stable branch would be interesting please.
> 
> I'm on v6.16.7. Thanks Andrew for the information, let me check with mm.git.

I don't expect much of a change for this load but getting test result with
mm.git as a confirmation would be nice. Also, based on the fact that the
patch you propose helps, this looks like there are many threads sharing one
struct file which race to read the same content. That is actually rather
problematic for current readahead code because there's *no synchronization*
on updating file's readhead state. So threads can race and corrupt the
state in interesting ways under one another's hands. On rare occasions I've
observed this with heavy NFS workload where the NFS server is
multithreaded. Since the practical outcome is "just" reduced read
throughput / reading too much, it was never high enough on my priority list
to fix properly (I do have some preliminary patch for that laying around
but there are some open questions that require deeper thinking - like how
to handle a situation where one threads does readahead, filesystem requests
some alignment of the request size after the fact, so we'd like to update
readahead state but another thread has modified the shared readahead state
in the mean time).  But if we're going to work on improving behavior of
readahead for multiple threads sharing readahead state, fixing the code so
that readahead state is at least consistent is IMO the first necessary
step. And then we can pile more complex logic on top of that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

