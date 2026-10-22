Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13075606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=H/+CWfzx
Received: by kanga.kvack.org (Postfix)
	id 280CC6B027C; Wed, 21 Oct 2026 20:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232606B027D; Wed, 21 Oct 2026 20:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170DA6B027E; Wed, 21 Oct 2026 20:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBC016B027C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:08:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8186340748
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:08:40 +0000 (UTC)
X-FDA: 85348326000.09.9163BC1
Received: from smtp153-162.sina.com.cn (smtp153-162.sina.com.cn [61.135.153.162])
	by imf12.hostedemail.com (Postfix) with ESMTP id D3FDE40007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:08:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="H/+CWfzx";
	spf=pass (imf12.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.162 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792627718;
	b=7RWLxUdXbi4c6D5WsTPokp0RWzL6erj9Id+tD17vj0UQQMmlyBnD0ZCNo8pOrXvPwvxqrw
	Fc5tpjMs0+rutejdFIlsJpOHDjHCPo3/W4CbfuFmbSQuJq4S0Pk1hSmh0i4R6ul/72AoJ7
	ygCieGYBekW0QiM2EegRwy2LwkV9GSI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="H/+CWfzx";
	spf=pass (imf12.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.162 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792627718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aW8G8tvB/aSV+Sr88rLQ9L/lx+lE4jps8NAxRfMRF8s=;
	b=Ze6OaScKvN7Hicg/4dfP5VC+o66l3mb83BBEv/K9cnAJjQULt8zIns3ezKUA6hSSrhjxgb
	veFVtLyHKktkaDYqdTHVR+I2ykQzLx5J2lDi6Wux2jifOobbz+gEyXUawE6gTqgrdVPEvu
	nFvoMfARBCt8ns9GYP80/3UMLewOMFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792627717;
	bh=aW8G8tvB/aSV+Sr88rLQ9L/lx+lE4jps8NAxRfMRF8s=;
	h=From:Subject:Date:Message-ID;
	b=H/+CWfzxG2p5MQDnrkFgjMlq17D8mrQRRmgB/jUj91jru9u3oDC8SJUgCw19CPziu
	 upwBLfSSZ/vMo8/ymjVhIIZOmJTxBTjmy8WnRSAnsa4I4puCU9UtGzezrgfjljAwa5
	 YhphlRaxZBdJQsXjBjGrHL4GgGBisbuqgEhJlWzM=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([124.64.22.182])
	by sina.com (10.54.253.31) with ESMTP
	id 6AD953FD00002287; Thu, 22 Oct 2026 08:08:33 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 3247236815943
X-SMAIL-UIID: BC0196746BD54520AFCFCA0E0C41DB93-20261022-080833-1
From: Hillf Danton <hdanton@sina.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Thu, 22 Oct 2026 08:08:21 +0800
Message-ID: <20261022000822.938-1-hdanton@sina.com>
In-Reply-To: <20261021075322.923-1-hdanton@sina.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ajh49ypwdy1hf8qw8hbpf6u11xcm544u
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D3FDE40007
X-Rspam-User: 
X-HE-Tag: 1792627716-629212
X-HE-Meta: U2FsdGVkX18xbJ4vOdu0NfvwAvHWvA/09gqBQpT4kqgqgYQa34cvuQgvl4UjqwokoebZGrfnbRZIJ/BGnx4exEv/bT2nxXSMr4y8Kk56iZoihdeYH58KpmCgipOlADxjwAhOMr5FNA6EWiYuZbqbgLdwr30UXbu2I6Y8qAmHVKNPqZ3iZFrLa7SbqZwVZKDyiAyK7v575VGEAl87blXGziex3xGlMSl4G22qorODLmHXd2hPBnyaprbgDvWeqzp4JdYmfdSUrSFInv6jippx5whV+ylTiT6YEZvc5Ei00EfwwFISOPD4Jyn6kESkKZZaB2Mc7AIOR42VhYIw4VqW+o9+gpQSwzRVxNZuBwSk3ahmaj3TgqOf/QQEkOjodjbQUmPH8+aGi3oCFIJymf/yoR/fyj2l9QLNimJKxm+O8lLlvselgoYJ898dpidOTnTxJWnyXQkAu9g4YZIb/bdenaunFj/gEzriIMd598IwP+0mQhS0/Wz4CSbO3fHKY4/9NOX+3DSdfdc5zFH0PQ4JzHqGk/1qLkbDWp/brlwTihAh3ggJlrP8fqVcZhBMgr98zHdZes3Nm7YxZ5uUNFtUCgnS5NjcAqkTGKXbALpr79t6J24E+Ncg1Vy1mEhG6eKc2DKzvKngim6BKCgr1UCMNoouqykvhavhd2xXmF9THZWH+NnSynkY2B3iVIXIqhMeiDBrKsxwtX5FJw2Ttm64zZ1Ua7uP+VqNP0tSCrr9sjYbYR4iHYdt0DNOxqSUomxCtO81n/187xhy2GvgB8kUJtTirRg4Ryltfnde0HKSEc2wVa1kAXpUK8cbMhavixNR5s84BJ3cx/aI1TCFgfaHXhm7bHcIsEdLD93QMLXC5y8khfJ82Bfg3H5Q2j2F7ARKhdzDI+UkTIVxPwmQPvXafsCVBS8S0ZGgag2ar+cursd+GuufRdTMn+G4k3udztFj2k2jDrj0o68hLFYoZw5
 VoV8mNYk
 9VMyft/FsRQvday8LDz74pWl1CozNpmw2hI75LiwxnHK+Pov+b8sO2pGpPsjhwVLaB9x5nFqGZUzYrf+hSYtp4LB8B2Acwqg83H2k6pR/TEGC4u3BwAYiQTADqy/kJX9Tc7MddzipLQNtavnNsQgHyz6KlHZxaS68Zo79xKv1lKuxcfpQCwKyjesxxukTwXY6hYEU/31BRDC/hYActFThCd0LliJl/SLWUgnSEHmJ6xy0g7GxFvM6k94EGji/DnFzlV257PNvU4B5WCGs23AiGeoXb8K1mq2p6ta1qgrGCZbng8qz4V6vsazk5FwOeSuk5Nv+OGLSQCM3wLMpG04B046KLg/MMK+BKjku
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 15:53:21 +0800 Hillf Danton wrote:
>On Wed, 21 Oct 2026 13:56:17 +0900 Sergey Senozhatsky wrote:
>>On (26/10/21 12:23), Hillf Danton wrote:
>>> On Wed, 21 Oct 2026 11:42:19 +0900 Sergey Senozhatsky wrote:
>>> > Split struct zcomp_strm into separate compression (Write zcomp_cstrm)
>>> > and decompression (Read zcomp_dstrm) streams, and split zcomp_ops
>>> > context creation/destruction into create_cctx/destroy_cctx and
>>> > optional create_dctx/destroy_dctx callbacks.
>>> > 
>>> > This decouples Read (decompression) and Write (compression) paths so
>>> > they no longer contend on the same per-CPU stream mutex (Writer vs
>>> > Reader priority inversion).  Currently, a (low priority) Writer that
>>> > holds the stream mutex can be preempted by a (higher priority) Reader
>>> > on the same CPU, which then blocks on that mutex until the Writer gets
>>> > to run again and releases it, which can take a long time when there
>>> > are other runnable tasks on that CPU.
>>> >
>>> Given lock like mutex, priority inversion happens from Monday to Friday,
>>> but I wonder if you are inventing some wheels in 2026 if proxy excution
>>> works for you.
>>
>> Reader-Writer split is a foundation for further improvements (like
>> singleton recompression stream and so on).
>>
> But that split is not needed at all if PE works, yes?
>
Because PE is good at handling complex priority hiarchy. In a simple case,
task1(priority=1) is the owner of lock1 with two waiters, task2(priority=2)
and task3(priority=3), while task3 is the owner of lock2 also with two waiters,
task4(priority=5) and task5(priority=7).

When the number of locks and tasks grows, I have increasing difficulty even
describing the lock chain that you in combination with Brian are unable to
handle. That is why in general PE is prefered over whatever wheels you can create.

