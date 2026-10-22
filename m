Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76DA7606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=ffC6NtPo
Received: by kanga.kvack.org (Postfix)
	id 9F0E76B090D; Thu, 22 Oct 2026 07:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C86F6B090E; Thu, 22 Oct 2026 07:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905D86B090F; Thu, 22 Oct 2026 07:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 786566B090D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:12:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 056B8A8432
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:12:12 +0000 (UTC)
X-FDA: 85349998104.29.0ED6FAC
Received: from r3-18.sinamail.sina.com.cn (r3-18.sinamail.sina.com.cn [202.108.3.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57DE8C0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:12:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=ffC6NtPo;
	spf=pass (imf22.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792667530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lpd/iWIoxrsm+xCJT3uJAtx+84ErexdnmPEebY+FkSU=;
	b=llHOBfGoIvKupXuRNQgZ5vgx+g51BqN82bskeH1m7X5t8shjILFmxv/2ukxO7EQzOvP4rb
	nIaoJhGZX9tkpuMEbjIMKsQST8JRRhUJ0p3IBOarfMOTkuNOc9AlyBn2gpnrST/WMiB6eQ
	kGWkEu2GRjTzgbVQJKgTGIQrf75lkOA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=ffC6NtPo;
	spf=pass (imf22.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792667530;
	b=tHQdyfzqH2PktiEpHT/3rdLo1wmcf45Nuem2330gEsL4N4kBKmwtww32PQNhHeu7tkk9VV
	J4TdQVDASN6t2j/bzuYu6Meux7n1MXlwiAei4oogGwr+wWZs4lRi2Cu/0sgspDzWx1jgVd
	fK2euHauhVWReiYaCWdmJ9pcIKqM1wc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792667528;
	bh=lpd/iWIoxrsm+xCJT3uJAtx+84ErexdnmPEebY+FkSU=;
	h=From:Subject:Date:Message-ID;
	b=ffC6NtPoIZFq7B0vnhNNgxfgWGtSdSQwR4ncZchQOV6rhW6frk+IED/IwSZtH5x7K
	 jvxSUw6OxROONcJpVkrwWkiLQX3ccdfirY12/tFWBao02nAGfPsWR/XD2hOVv/UKwf
	 nttC9VQzM7r47QNLUmcMnCiUG4w1J9yGCDuIKnUY=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.244.129.176])
	by sina.com (10.54.253.32) with ESMTP
	id 6AD9EF7F00002849; Thu, 22 Oct 2026 19:12:02 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 1431994456874
X-SMAIL-UIID: 52917A70D3FE4CD2923250539711106D-20261022-191202-1
From: Hillf Danton <hdanton@sina.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Thu, 22 Oct 2026 19:11:48 +0800
Message-ID: <20261022111151.960-1-hdanton@sina.com>
In-Reply-To: <CAGsJ_4wMQteCGxQ7wxUKP2g96myo91ipF_zedFVVbxKdDrb=bA@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57DE8C0002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: tnqe87p8de5rksjsj3ifjiyf3haq4a3d
X-HE-Tag: 1792667527-821845
X-HE-Meta: U2FsdGVkX1+zrlwgl9KhFuIsdnEb8OqlSKkx2ggmwnaKnKT13M9+tJ17EClIaY6mxUq6PPBI8fvQkGxhpFpmQeNTHYL1Mzyv9UNGOoPLzPFu8jut5V+No7qti/L9o9J0cq4HabUwIPljwUO0zqyqF+fmRDZLJckwVx9d5R/zOWg2G6QlJXiRnckvL1HgsOcRAZLsnkycSzGoTk1nWB94lIvmw9qzS/VKGhRHpfiyKE8vI1bv/P8WIVZYrXYXFZJImpYaoNa1gTd5yVZ6IsbWxuD80PiWCRxqbuUc0VjB7r7jsBz4vsq0Of3qG5VZXtq6P7n3v+PxK6yUfVTVMbgp14aCjHqQ1EvzDoAryNeuB51hnT2X7qbAe894eUGQW+AhpPl2nDrMOla2e/01MW17FVLlwjJtPUSJQUwQW2CFFGMAdGXGyo2L8x7mRRiibuzN2YvRxz5bWdRkQrHle9xTUFRY+C0kBkOqDEEX1tYFaMcS5VUFmB6IuPyndB6IQXs6eBCF7IGmb3kXFy6t3VxFV7by7ZylPV7gA/j965VYCExYUbo6NgkZomY3bczunoxR6c+Y55ffQg/Y8sRfHCYKKyryHOMC3oyN8qAbzxAEuMiOEBJusmqCMp22KMZFbcGmwPMUR20agc4gvprg4I76xCvpTRIrgt11r9W1EWryUV4ZqSqnfmUlAFC3CMN4mzloS11RSM0upkVXTAvo2cpwqW7XKA3DaavJwaJ6QNgmzTBrsysdNi+zadARKdROBzp7RkBNOupj18n7HoBOIHiN6en3+dpUgjyecZFk2e95RUTnfp/W/ojU9hhxlsnevEvVGQW8BqbX2h5wv9018Yw58W+cnSqV4Vvezh889ZHGnk7dXmLey3EpCDsljvsqYB6lj4n1UMB1vFhDa9K35Gtq7NleN2Ok4yYoCXq2QqsCazapbijHTNW3pHCI+jSRlDFMxWJwGWmOKzeya2Qobrq
 +znaNr1s
 yrUOgAGVZFZthIwN9IDMG8KbT3UvbwAYyESNHJ5PDdfHzkoFAdLZABYAL1nn22lXNoIohCRADnACeBshkCBsvvaBUjRpwaH8xBeWHTr3wjWi5zQc2GIGMF3nttUP1zdV6iftttlG5JQuhIv+QsDoPpAf7pQbsy9aNuZIV2DF9oaWnIA8OPvWEh2l28jzKyELNCDoDWV5h0xCpWrrPWo5STZM8sCfKFJuc28cPLYyJrNsOoSsSn0MxBSLjQK8MkDIt0lhurTO8NrSkkWRj/uwOviMpzs20FKlSn3exlmOsTiUFSteMQypR/YiIR1w0ZW4Iu9GS5b6Le3nz6Gwt2zDmSVh8zNuIW/Bw0ppsW8ldxJUPEoE6ruAj+Ky/jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 08:19:41 +0800 Barry Song wrote:
>On Thu, Oct 22, 2026 at 8:12 AM Hillf Danton <hdanton@sina.com> wrote:
>> On Wed, 21 Oct 2026 15:53:21 +0800 Hillf Danton wrote:
>> >On Wed, 21 Oct 2026 13:56:17 +0900 Sergey Senozhatsky wrote:
>> >>On (26/10/21 12:23), Hillf Danton wrote:
>> >>> On Wed, 21 Oct 2026 11:42:19 +0900 Sergey Senozhatsky wrote:
>> >>> > Split struct zcomp_strm into separate compression (Write zcomp_cstrm)
>> >>> > and decompression (Read zcomp_dstrm) streams, and split zcomp_ops
>> >>> > context creation/destruction into create_cctx/destroy_cctx and
>> >>> > optional create_dctx/destroy_dctx callbacks.
>> >>> >
>> >>> > This decouples Read (decompression) and Write (compression) paths so
>> >>> > they no longer contend on the same per-CPU stream mutex (Writer vs
>> >>> > Reader priority inversion).  Currently, a (low priority) Writer that
>> >>> > holds the stream mutex can be preempted by a (higher priority) Reader
>> >>> > on the same CPU, which then blocks on that mutex until the Writer gets
>> >>> > to run again and releases it, which can take a long time when there
>> >>> > are other runnable tasks on that CPU.
>> >>> >
>> >>> Given lock like mutex, priority inversion happens from Monday to Friday,
>> >>> but I wonder if you are inventing some wheels in 2026 if proxy excution
>> >>> works for you.
>> >>
>> >> Reader-Writer split is a foundation for further improvements (like
>> >> singleton recompression stream and so on).
>> >>
>> > But that split is not needed at all if PE works, yes?
>> >
>> Because PE is good at handling complex priority hiarchy. In a simple case,
>> task1(priority=1) is the owner of lock1 with two waiters, task2(priority=2)
>> and task3(priority=3), while task3 is the owner of lock2 also with two waiters,
>> task4(priority=5) and task5(priority=7).
>>
>> When the number of locks and tasks grows, I have increasing difficulty even
>> describing the lock chain that you in combination with Brian are unable to
>> handle. That is why in general PE is prefered over whatever wheels you can create.
>>
>
> I still believe that reducing lock contention is the most correct way
> to address  lock
> contention.
>
Given the log message above, I dont think the issue in question is the regular
lock contention, but priority inversion caused by preempt. Due to preempt, the
preempter becomes lock waiter without spinning for lock owner, which I think
creates the issue. Particularly given the spin for owner in mutex, if the lock
is hot then the critical section is supposed to be not well implemented.

What Sergey did not show is -- what if the preemptee gets back on cpu at the
preempter's priority after preempt, with the critical section assumed good.
This can be checked by making the Writer high priority instead.

What I am confused is -- why decompression needs to run faster without boosting
compression up. Where is the compressed material?

> Proxy execution and other priority-inheritance mechanisms can help in
> some cases,
> but they also have downsides. For example, allowing a low-priority
> task to run at a
> high priority can affect other tasks. When many tasks require proxy execution or

No agree. Just because of the high priority lock waiter, low priority lock
owner can run at the high priority, so the priority inversion is effectively
erased, particularly given a well implemented critical section.

> priority inheritance, they still compete for the same resources.
>
Even when lock contension rises, the lock owner runs at the priority as
high as the lock chain can offer.

>So I'd vote for reducing lock contention as the first option. If that
>turns out to be
>impractical, we can consider priority inheritance.
>
>Best Regards
>Barry

