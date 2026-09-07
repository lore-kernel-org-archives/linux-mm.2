Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A78C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D126B0098; Mon,  7 Sep 2026 08:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124A76B00A0; Mon,  7 Sep 2026 08:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B1C6B00A2; Mon,  7 Sep 2026 08:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD9746B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:47:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C416C015A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:47:34 +0000 (UTC)
X-FDA: 85186942428.15.A9D5948
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CBF961C000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:47:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/pt58nE";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCqLzsf4q/SjfdvKYkdPfgYTxL/rJMKfiZpM8s0mfBA=;
	b=5mysNcCJ45avvwWMqCWNQEUW6awlVwLNxKpZZB4O+PCsRprUPKNQABCp42VXPabRhusYba
	Cj4L8ZWF7sdwjrRNOz0PbXC8cYJsx86O/qr7tK8mzYgwmDxAhs9TZSjrcEbWFWLo+On4aD
	r3FaCT8bqdn82KRfqz6P99tK9xdcaXY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785252;
	b=8o8f806T4OD2ehbnJcI2BH3h9EvTR8Jk/+0U9T0qGrSnDbh2E78VOouB3ODIj4aArGz2Cg
	t1h+IF2cxdZA2SZMH1K3+9eRS8+8AnaridgoLOpbs22W/8GsxTa7w9RWZXQZHqYytq2lYK
	wPg21wYmt/xyK2WfmvOkMNlTBzFSnu8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/pt58nE";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 676FD60D8B;
	Mon,  7 Sep 2026 12:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692141F00A3A;
	Mon,  7 Sep 2026 12:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788785252;
	bh=iCqLzsf4q/SjfdvKYkdPfgYTxL/rJMKfiZpM8s0mfBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j/pt58nEYJIBTSG6JkoVecRRGUrq9BhlZUOVIfR8LvjAIdP15n0d/nf7aFvZldqjl
	 cLi36PuLgBqlndIF9jzAkxu2tXpNJD1dtEISU+xS62KLZc1hIOXRaiGmEWnINntAU5
	 DEXX4SWUzQZEJ2M0RkgjVr5rGxWpw5CmBMrk2pgrI+opGYVwqKqe4iTXLdHthOOKFm
	 tYXqnQg356uzvJ2gx47sAd7gXGu/eIy77OeQ8qAl073Wh9EqoSJjS5ok7HaNuPEEDZ
	 oHLSyW5cU10ys95L0YxGArParqu6aBf+cTHufDaioJsU+KjB10QYMBC0sOzX4Vkz26
	 0ubS21S89NhjQ==
Date: Mon, 7 Sep 2026 13:47:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, minchan.kim@gmail.com, lwoodman@redhat.com, 
	kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, linux-mm@kvack.org, wangkefeng.wang@huawei.com, 
	sunnanyong@huawei.com
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
Message-ID: <ap6yUYw-DH3ZZ2_i@gremlin>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
 <20260905162128.46fe06ad3689af1db637a005@linux-foundation.org>
 <8ed3a018-3290-494b-8e67-bf317974d8b9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ed3a018-3290-494b-8e67-bf317974d8b9@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBF961C000A
X-Stat-Signature: sh1nbwu1xs6gzbcdjz4synmn8njhkis3
X-HE-Tag: 1788785252-971593
X-HE-Meta: U2FsdGVkX19jyqVbxdPXdic8guIq3JbYuVr1a7LTEHGP+ko2LJ7YovFPO+kglWEQFtaOhLsB5Z9Nm6Akr+fjhC6S9nKcdj+fXDsO+qdNt+As3kWH0Wpy3KylAPfkW2hmju1L/dkodGZ5Ru1h67WjjQi0SyG3+oPaKZFcypOUzUDHmnJcQx0DWSQ/oQ4jPXDE8FzlF9IyHwBynW0lBMqLyAX08QMKvl6rsFNXbjy98AXJH1D0yM/vtWcN4cN7/c18xwJXdcF5jijNpJZFjV9YQB6g5rPWsjj7vHwv1i20rU1mZ3qsra9fvsS5at1gws7mFVmR9WDL5lNhS1Rp4d2LEMsGCLJaQ0eGZEg+mUkkwU41fyv9MAIaHoH6tTufWt07ggr1z7MsB9kX8mofElfL4gSYuBPG/kq0fRcMj+EMMN4pIM9PO56laerUBgIk4RHKDcamV0Wc2fBpaHJ7Jh5BHyAHi9pO0dJQKKnrlgO+/4vneOnpVdheP03wAGUKUfLV2lt8xLgEB7BUMEmNcC/8N1vqPE8s8y1oNo3gaeF5JlvG6FZrLre4oduJnHZo3pw22cmll9mzO8PcZrZt+dxgOffZI1DTIGhA4cBRoL+WqV/wbH3eKU/ahW+Qit422+q6dd6jKAV/mSTMkeK181t6aqlDUb6EoRN3cSIYioXqlcNzHmAF+81YnvXuniHSbYVJeK5tyXnlRRBKgHtnE+mNv1202RVLnhVp5fS2UYtUxcZamC6Liu3Q2fPT1mHpxOazLOAJ2RsPG+wiB/EE3iGtLgkN6mkfxfVqS2aERqal9KgEocK6OmK4CCuB+8y1YnUgyGXtwBAOD27NIlZWajW7Xb/XWDyQoj2Jt8cOSFNJq4F3TIxar67EmkheyR+fHmRlxa0uqwjKMvA06BCqq1irvhof/Uahv7YyTlaplPJ3KUQKgndD9RR5agPe6gX8U0Kpg5caiLsjfU6KPebYUQV
 fjavCfy7
 O6oIxuBrH3S+lCgdPETkTGpOx9DsOgjvborpCm+8dJeOyEfGPqcbcbYAqayjB3H76qtV23ToTWTjIXg61VGU03j7P/k3sM6g6ggU673wnDGc8ouU4P2z5E7w0U0DEzd21bLqrJnWESqlnj3DYD80SFleVEiEBR9XauJRAkUQPgxFScWZ2XgqHqC7Tqyn9LLj8M3rN5zC2Ng1nT8anoyx4FTS63jQofL1G4ENuxHCfEVH+TBkIGcNkmWkRF7cmE/EXr1KzcpbGk6h+C5HF9V3RprDSopQPM6XGkXuV1hR+tx7Y/cKTRY2hhRSBscQKhjQbHLh6iKl+VoItk4gRg8GQWhIiOuLG/3s9Lbx42ikblghYx7ZLeprJjwljd6VT7nH55/6g1iBjgTOvUugpTOCCGavItK05Xe6PP3cxHQWkMo5MS2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 10:21:34AM +0800, Jinjiang Tu wrote:
>
> 在 2026/9/6 7:21, Andrew Morton 写道:
> > On Sat, 5 Sep 2026 14:18:19 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
> >
> > > On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
> > > anon_vma->root is stale due to missing memory barrier, leading to
> > > lock and unlock two different anon_vma->root, thus leading to a anon_vma
> > > will never be unlocked, and another anon_vma couldn't be locked anymore.
> > >
> > > The race is as follows:
> > >
> > > ...
> > >
> > > Without this fix, our production environment could reproduce this issue
> > > about 2-5 times each month.
> > That's important info.  Can you tell us more?  How was this observed by
> > operations people?  A copy-n-paste of the kernel messages would be helpful.
> >
> > This will help downstream people to decide whether this patch fixes a
> > thing they're seeing happen.
>
> We can see a task that tries to grab anon_vma lock triggers hungtask.
>
> [2434968.289510] INFO: task main:2354726 blocked for more than 120 seconds.
> [2434968.289516]       Tainted: G            E     5.10.0-0021.aarch64 #1
> [2434968.289517] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [2434968.289519] task:main            state:D stack:    0 pid:2354726 ppid:2350673 flags:0x00000a01
> [2434968.289523] Call trace:
> [2434968.289531]  __switch_to+0x7c/0xbc
> [2434968.289540]  __schedule+0x3b4/0x8a0
> [2434968.289542]  schedule+0x50/0xe0
> [2434968.289545]  rwsem_down_write_slowpath+0x3cc/0x6cc
> [2434968.289547]  down_write+0x60/0x260
> [2434968.289551]  __anon_vma_prepare+0x6c/0x210
> [2434968.289555]  do_anonymous_page+0x258/0x660
> [2434968.289557]  handle_pte_fault+0x188/0x214
> [2434968.289559]  __handle_mm_fault+0x1b0/0x380
> [2434968.289561]  handle_mm_fault+0xf4/0x284
> [2434968.289563]  do_page_fault+0x19c/0x494
> [2434968.289565]  do_translation_fault+0xcc/0xf8
> [2434968.289569]  do_mem_abort+0x48/0xac
> [2434968.289570]  el0_da+0x44/0x80
> [2434968.289572]  el0_sync_handler+0x88/0xb4
> [2434968.289573]  el0_sync+0x160/0x180
>
> After analyzing the vmcore, we found the anon_vma->root->rwsem.count is -1,
> and there is another anon_vma whose anon_vma->root->rwsem.count is 1, and
> the anon_vma->root->rwsem.owner shows the lock is held, but the stack of
> the task shows the task doesn't hold the anon_vma lock.

Can we have these details in the commit message on respin please? Thanks :)

>
> >

--
Cheers, Lorenzo

