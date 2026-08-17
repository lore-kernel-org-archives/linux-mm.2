Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AF3C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5B36B0818; Mon, 17 Aug 2026 10:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BDF86B081A; Mon, 17 Aug 2026 10:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F151E6B081B; Mon, 17 Aug 2026 10:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC50B6B0818
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:05:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5887D1A07BB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:05:34 +0000 (UTC)
X-FDA: 85110934188.24.E287B30
Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94B14140005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:05:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=IdANnYMD;
	spf=pass (imf23.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786975532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4B633A1BFXz3QnMJ7GjsJGouuVbnGVqxnSyFxj5JBO8=;
	b=nKAIYnaNv7Gy0x0iFKUvpHBTU4rOhQkRMUD/OrdPtPBA66hJKWVIsLdgTcWoIFKB/wrrVy
	7Ubdrxl5wOE2S33iuzaSjYOp5yK+EW7UnR3PQdOlOoPF8QgvOMnRfjEHDGuTF5nOO/pfzT
	IbgQp/0RSnIUsjQ6XLRX4UY+SLUjlEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786975532;
	b=J96O6EhF+b2YKk8qVbdl75TvacsSsE4xU7pyhYFKJy6ld5I/L5rSq3i6ConrZED15ukGHD
	tGTiitkgdcFzJtK5abrcUij06hi29c5EEIBFRcu1JY2MvB0cn1k060xAfJZHqEoWzmNq4f
	RlNcKze5r7koUyOQVbDTJy2/un8I1No=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=IdANnYMD;
	spf=pass (imf23.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786975529;
	bh=4B633A1BFXz3QnMJ7GjsJGouuVbnGVqxnSyFxj5JBO8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=IdANnYMDDRiqe1QM3GlYoxohkeifa5s4OgBoSk0LX9rMHe4CddtYkabsEgX6v+XXd
	 W0khG6MclelfnW3ZRi2PVIUChrjs2Cg5JGo+wrAvUqz3AilHKLHxrXdSYxG8bP3w6K
	 vlEH5fImQxYDz314+gJvRyOiMZCyZ0kVkNYY/C1c=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4hNvk14gKDz10px;
	Mon, 17 Aug 2026 14:05:29 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4hNvk00QXJz10q6;
	Mon, 17 Aug 2026 14:05:28 +0000 (UTC)
Date: Mon, 17 Aug 2026 15:05:29 +0100
From: Bradley Morgan <include@grrlz.net>
To: Joel Granados <joel.granados@kernel.org>
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [PATCH v2 4/4] sysctl: Add 0013 to test partially updated vectors
In-Reply-To: <iahrpgl333k2cniihxiv4qbkgtalxmhn47gyzrq2xd7jshxbtd@cniqn2gdnqfw>
References: <20260814-lklm-partial_ctlvec-v2-4-9df50d26e477@kernel.org> <1EF80864-F479-44F2-8CD7-28383515F483@grrlz.net> <iahrpgl333k2cniihxiv4qbkgtalxmhn47gyzrq2xd7jshxbtd@cniqn2gdnqfw>
Message-ID: <9CD9A226-E6E3-4552-B12D-1AB984B8B21F@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ix5rc3d9y4pax4pnefswcm8eygy1z1mx
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 94B14140005
X-HE-Tag: 1786975532-767782
X-HE-Meta: U2FsdGVkX182wx8kvYh0itDmKEYR9rQkw2cmOozN2ndTy0WFOh5AoXKKg+k1zNxLf+dHGzR9kJto9WaCrng/AbzRQXW9xnIuVPG6t99/Zy69fJdTintDODd7w6O26cIcmEkG3bxZarX2n8w2qbJst9JLj0h0fpAKgsUtkQI4D9ttB4N2H4TtP2k13JRxwIXl/0rH6J3e/5kwZShkeFNImuUSvo4i8DPEZF+0IUx8hvAaTAYf8MafqWvdQaqZRitmN0t9H37Kg1Bk75PnZGqPPOuX/AryarRMDeuDCw6wXz/Kg7Oq1TxszJkU5puIUiAU8oezH2ig0OjWtonrR36ql40QbuWkefGphUmNgXu+a9BOzFwwfOKVmsV0FGKW0wGTH+F5NsuM1wVoqWNG/8Js/TFxGRAUyXvoEUrEdRw5mJHc9wGO5y8swD/XH8w9QGpFkjJyT/tP3/1S5q10KmyWfvbWGJQbdiJEkh31wBuYVKud7G150EcwZKC3dxK8yPN4p9Oww2+mTtXBdU9B0GPY0HQfmFDmqIUC+ng52gR0L3M0x7YTrNbSrV+JMh+q5b51bCwTYK1Gy4x6rwMwIHkSoSjH1Od3eaD1KYPhIPM9C9sSuoJBgd4UG85dwJvwICaNbnboGTklLbUOC4nwoRapqsCP/UkNQyrib4SzA4Ryp+PscM1v1/2RCX4X4rrV7ZFr77WyGWuVHetCsV2RQDbKZ4jM5D6wRPJjegGPln5W1lSrLPMAvwPDAtQKAUaYd4yChT9gpItTEiIpVnZ0Dzsuy/9xhQz2K8LDB8c1fi6Zx0uqw6t5AHPGMrd4yxio95a851oP4n3IJ+tz0zqxtIN7L9VN2ZSkyxYV5mUSBrE+6VCHT/9wyjtArVynnBCf8NrwE/LEh4TVcOse4qaIgRQxdvTZCMRkMRsg62W1iSCpSA7xDSi/QXh+GANAo4xby900YDJTyLBcApb7M9TDQou
 mJOC15hE
 vlokcOQQwAkwGzmX0azDw6eaMeoJZc19aEJUc3NPeyMG3tadg/Ehh2E88cNNwSFUh3Va5ypyw0tR5Sb7x9EO+BprdjybJ/6qXmpLc7g6Crlbv3hEPqjcrXiQMOmcsRRDkvgA2qZ4XllXuhaW+Of29GNn0iAAltRLOhEYdFZ1siWzkyXQOYmrKo1iekgLlFXMpy1Yb726x7Gup8hl61pxJm3AYoezAvFFR5UkUzAwO1rXKii4DFpA/FG4DAyKdLLZ5y3QXt6kbls4g2fD7nKRJwULLWGKXUJxTl7+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 August 2026 14:54:12 BST, Joel Granados <joel.granados@kernel.org>
wrote:
>On Sat, Aug 15, 2026 at 05:05:59PM +0100, Bradley Morgan wrote:
>> The test covers the parse error, the out of range value and the
>> first value failing. That's the right coverage.
>> 
>> The shellcheck disable should say why. The test functions are only
>> called through the dispatch string, so shellcheck thinks they are
>> unreachable.
>I expect to remove this in the new sysctl selftests.
>
>> 
>> run_int_array_no_partial_update() uses spaces for its comment lines
>> while the code uses tabs.
>good catch 
>
>> 
>> reset_vals() has no case for int_0003, so sysctl_test_0013 calls it
>> for nothing. Drop the call or add a case for int_0003.
>The TARGET is reset to "". right?
>

From what I recall! note I review loads of kernel/ files, I'll rant a
little below, some of it is related. Heh.

>I'm reluctant to do more work on the sysctl.sh file as everything will
>probably be replaced.
>
>Thx
>
>Best
>> 
>> Nits aside, the test does what it should:
>> 
>> Reviewed-by: Bradley Morgan <include@grrlz.net>
>> Thanks!
>


RANT:

I've been thinking, I hate clicking on the stupid mailto links on lore
just to review a patch, I need to be CCed in most kernel/ patches anyway. 
I already am, but im mostly a "pity" CC, because I spent time reviewing 
patch, and like, I ask people all the time to CC me on most kernel/
patches they do, but that's negligible..

I have knowledge On sysctl, id love to wonder why I don't even
get_maintainers catch yet. (And if I do, I don't even get CCed! Omg..!

I really hope one day I get either reviewer or get_maintainers CCed so I
don't have to go through this headache each and every time I bloody review!


Sorry for that rant, I tend to think out loud. (Or overthink)



Thanks!

