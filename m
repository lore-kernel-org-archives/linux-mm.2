Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5082FC53200
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 00:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5346B0088; Wed, 29 Jul 2026 20:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96406B008A; Wed, 29 Jul 2026 20:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86836B008C; Wed, 29 Jul 2026 20:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80C126B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 20:55:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5D631407E9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:55:30 +0000 (UTC)
X-FDA: 85043624820.29.4EBFD8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5AFE5180004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:55:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GbhS64Ol;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785372928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ge99MicqCJZVBzMhvmLfMa4E6XjEn3jhqh0vIzfEiM=;
	b=0/6+vtkWzlklTFTmMzezz6Z214ftfTQ33R3oU7O/lIy5LrUeaEvg8C/3LZOPg8Lp8L7ZEt
	pfeqJ6uJ70uGKzu3v9aTfIt4V+c9k0BKHA+IV75PSxonsI1SasWn4nesLVcFBL1WjNBs4G
	tgtgNKOWjCLvwQCAhYTCTxbU6tMo05U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GbhS64Ol;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785372928;
	b=RsQDMwO8VEZV8YAJXUIVwYcm4C4d/VXyzcZh0eGTnfVYfSQiokTBKbpN5aDfJPe1Nn2je7
	ymgbTe4yspt1YYkEjSuL/fNy33dt8bwNAzYv22/jugEb4Mg+kRVx6uDnN030jqp8KeyUpu
	P4j8+Wj2GHIrvnmqFI72PrlRUUfNWhU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AB5B4011D;
	Thu, 30 Jul 2026 00:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DD91F000E9;
	Thu, 30 Jul 2026 00:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785372926;
	bh=2ge99MicqCJZVBzMhvmLfMa4E6XjEn3jhqh0vIzfEiM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GbhS64Ol5wSWM1jNHKBXGbtg2prTUayi7T7xdxtugVqKV6gQQkIA/iYD14KuVZhpp
	 jHP3vWz1fU1Fs0msPCrj3PHjayQRc6VpBOTA+AC9ZZGK+llQogl0WNRKE0RDCS9jAo
	 9nYODBwzmvEk2F7Yf0awsovfzXOMdnvhXBa2dqAQ=
Date: Wed, 29 Jul 2026 17:55:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, Hannes
 Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi
 <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hengbin Zhang
 <uqbarz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes 0/2] mm/huge_memory: fix huge_zero_pfn race
Message-Id: <20260729175525.5e80051b8b21f723766142d6@linux-foundation.org>
In-Reply-To: <amm2GOFablLbBC4H@lucifer>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
	<f0e39f91-8dd1-4d9d-8d4e-da5d608a7148@kernel.org>
	<amm2GOFablLbBC4H@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5AFE5180004
X-Stat-Signature: 9wfjm6wyes9zs6jtcphirt8j9uap7rgy
X-HE-Tag: 1785372927-696874
X-HE-Meta: U2FsdGVkX19KvWFEOL2yzd5VU4FWk6p+9KuWDfDaYkLE86snqwDB0dshXzTgYfr4Qt+NLK0yqOBeGZKyL/e5iRgwBzWxYdYy7cpVtZ1VrGLyCn+Kpc7ZX5pAsbvlHiuf2eRfO1PSd2kkC09UXip/wAH7SBoQdcffqv8DUL5NqcT/r30AdPk4QvxDfFHck6dAOeYq93jroF73gxk38js62crpiXq88ntLeJCwX2xpc01/gHEY9xzEXqGyCGFztleU2DqFqXL0BTxRCTmw0Bheu0eyDrWoGsEiiodHoJB4w5NJNJhv3OzomvVSGOxecheYQU4ue8apXmcOxWyXvVdsyieXgWE5tkYT67c2bhpb65V/av0Dm4NrcHi6FE62Ve/DIxtzxeZdlflDEgAnlXd5HNH62KSXmsOyJNBE2WCj5e0hCBsjpCklq0dXvyUcrtXzjynSZQNJ50ib6oKnkY3ZT7mg8yRkmGAAxQDBBGlNrA5ybzfznE2PjA0cdh6SOuNodLBytY5GzhBIWfFx8xz5Bh6ctO+BoXwr6lYDE8kk/ffbNWZkk5iKMAwaEVIIz/YRuHXFoH2eyweD+7yLFje18NpGyljgHo1EasH5wqd6g7NrxZOHuZlN4O7m4l+e3spvva2TXDwNYy6FrdJEDfz2YI5YjRNN0nZVCDvzkoBAuZcC1CS9jZC0a0qky+zMkm6J28PmCnYOmQg/CM2Ox8Ig8iwA9XmWoXveqVKe2Fi0ijcmg+Xqu6Qby5T6oDg9Aopt59szgl7hWcjUq2oFBWt/0XQaV7aV7FgIVntSA+67Qofy1rAX36viQRTXCEzUrkxuEvd43e3Hm5yUNNf///GUcAKmU4plsPeOtrIuML/GmSaLYcC0fFhAoBjJ1nGwvHONACmrL4kqB8mMw2PtLj01B8m6krm0qzY2OVM0ENkRMxG3u/xGrwvurekQUQE3le339/Asklb0iYfRX3u0h2z
 O83jPx7b
 gDQK9Kj5Yohl3iVbEW1+FrUsBakRz6qgr71wvx0pwmr0IsWjAfZhF6gHrSIdXQ4axqtzfWS7nLH/ivTs0m76D0gjl5vilVUaY6SFoJPu2wTapbmqpAgidAk6bPuRII3za/ldHcMTbRCG1BY113hIwEi9yQpqCYxcocq6j9Fnc8xR7ojCDP4qBCT0fd/ceCCBD104068SkJX33eNAOisw38Q+p++8ZcSCPsMKQmKQwMat/2aBSvb0sRbpX82czc4ymTrsKACaSSI0mPKKFsGG9XakKMgcWpL/djjCrE6TwFOaciK50M1D27QHmAe2MZwqg1PoxpjjGt5VUdS3IVsR1w+7XFPTtjrcOj8fmLwvWyfvht/F5ZQmjYFrjfQb1YQlzQIc6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 09:15:08 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> (It'd be good to get some review on the actual changes also :)

Indeed it would.

I'll add these to mm-new as there's presumably no rush to fix a 2018
bug.  And add my little "acks?" note to remind that review is pending.



To simplify the dependency things I added

  Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")

to both, as Greg applauded yesterday.



Should I be worried about
https://sashiko.dev/#/patchset/20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org
?

