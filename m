Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 156FFC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78E26B00A0; Tue, 22 Sep 2026 05:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E292D6B00A4; Tue, 22 Sep 2026 05:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18936B00A5; Tue, 22 Sep 2026 05:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5CC96B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:52:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CB541C2816
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:52:09 +0000 (UTC)
X-FDA: 85240932378.02.2D5ED48
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7E6F6100004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:52:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=P3glEJkQ;
	spf=pass (imf14.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790070727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8gnsOu8dUZ3aA1jMaDEM+zSBKGqHWilm/tfYcR3Kt8=;
	b=mHXeF4yEB5bs/OSFGtzQkdhFtlbCIvGsowA4mA1pMcpo7vNNew7KqJU2weyplGun7fuWCW
	5wfpo4FSVuViyiMXAdIYjgHoKvqPMEYHEgEz+zdGd/7iQBOTdroMY//WJgkSNUp1wfpeBx
	6ORzHgizGs4iPM+f38rAJEjKI14ZeX0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=P3glEJkQ;
	spf=pass (imf14.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790070727;
	b=VdZ6wsSkXoZ4ZLs04AMrheHME4LyQu3i1VWDMfdhtY524J+/70r0UQq11LcxDuox4yk5cv
	KzHmc905Rg/5uMXQdvBYUzYx9mECuJhG6DHTrihPw2ehOmho/tRomIe2xksMPYQFUfWnsk
	dbieSWCOxl6dBkkFn3TCRIwRYBUf2ZM=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccd5cf03so3821975a91.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790070725; x=1790675525; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b8gnsOu8dUZ3aA1jMaDEM+zSBKGqHWilm/tfYcR3Kt8=;
        b=P3glEJkQxemU31ASn7gUoo6alqqRn6wGxX+v1rCnjQh1ieS5cvqGLRnu9Zw5ykedw/
         BVEg6A8dH7wCTmbZ/UKGKnVhpLuG/GHifJQbDflWxkz89enqlNv5vTNPCKe9KPaBcoO5
         Hlhcb8Wx8PSU5g+6tgkJJVHLRru03JUky/0r3hk5Kiq9aZvWenjMl4EF4EGk3f6XVtDe
         44UD1ld47aOW6vWYO3EzBsWtvD+HBX95og9juIo+Py/sbdYMl1VVvfeSBkS28HukS5Jm
         Ic+EFaRr/kGAxQPlVN+Q9N5V7hDvk1+G+c+xTlcpi31ZROMcgwkokuDN6J9DPmU0lxJz
         nqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790070725; x=1790675525;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b8gnsOu8dUZ3aA1jMaDEM+zSBKGqHWilm/tfYcR3Kt8=;
        b=DrxKDUnDqFCWbf4OIXR55xRKbe43ycjoB2zGEDJwoXZFF2JKq7EnfXN77MAjmeyNXt
         TSepjbtxCirFyrY08PL32rzoEw4xxL5Gpf+RkMdp0Ig3mrIXQwxJHz9m1YXW6ExXawQr
         mqlOoF5Cgo3y2YsEGL9XNeL/HWToGcZ0C4duIgT+UHVev3XDq/dE+ZMrxowC1dVn3vQH
         qV4ME/RO+Jnxp3UPef2yAkQAIZxozBbWxjhOogAj9u9bVD7wdlO0Icxll+zQXExo8QXX
         DoZGZoPZ4/K+5Fp9ndDe2C64JRVbKI3elZcOTrypy/eeViv22glq1ZWiqAHploo4s5gL
         xA8w==
X-Forwarded-Encrypted: i=1; AKwUvBwCgjlpfxcwSLfrfE22iVj7zkLW+IkMIPLNMYFoJ1C+zzwLXB7xn0VdA1q5SmccxbSlO3p3Y8jm8w==@kvack.org
X-Gm-Message-State: AFuF++nsFqQLLo5whPayQj5UhakNApDk1qxPSY28nEsRbycxnfXiTgoN
	zfV37UGfofZoieQ6TnQcvNRgyVRgBAdgEj6td/8dczn232y2PoaFNZDRD4LeBm6F27Y=
X-Gm-Gg: AYBFou0LhpiDZ0cM4d4Sqh/LVw0N6lQu+IIyAD4iA8IvA7q30UgZ2rzc+KuJAFsIOI0
	MR4qmPRd1aicJqqRRaqSod00532FmIEc8M8z5YRyAN04m+Lw+qY/BBS7WUOq4DiNUredXEbXUzZ
	ZHDkBzgOwzfc4PUZA7Ff9o/Eq2GomueW0Jm7ZTws8VmV8+APwpNCjkgpOyX+ETU52rfg3pLioUt
	Ivr/WZx7FOdoKaF9HaDzHOX6d9i+QYeBvkNdpwGOW1/fX7eaC1GZvwRQGGodSDbUd49QnSHPdGq
	ZW90gMBwSYlBXHX14zUctzJvTALVgT0P8UVn4vmjEiXnKv43/4+vG6XvIGjEaklypjLvNWkLydX
	U2AjB/NWJ2OhZ5TSa7vyEtbgXOLDYAt9GutN52WbufPzMYMTrz+KTIpQxHmO+BRpqyzkwlfzgxG
	VYN1w3okK/2/4rAdeUodtnT4yvtYbNEe3/gWLYVkfK2Uas59hiPcxZTpcB/FPsTnvhR6c83D6+1
	2nGGq5+TsrGAyHiseTer+ppJXDRvHwx4Jtd8L/DWXDhr1hMawFU
X-Received: by 2002:a17:90b:2fce:b0:39e:14db:4371 with SMTP id 98e67ed59e1d1-3a0730a1432mr716576a91.1.1790070724728;
        Tue, 22 Sep 2026 02:52:04 -0700 (PDT)
Received: from [100.81.13.24] ([61.213.176.55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a067409854sm3905971a91.7.2026.09.22.02.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 02:52:04 -0700 (PDT)
Message-ID: <e9d4b9c8-1b0e-45fe-95b8-f999055357a9@bytedance.com>
Date: Tue, 22 Sep 2026 17:52:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, jack@suse.cz,
 akpm@linux-foundation.org
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
 <20260921120658.1627992-3-sunjunchao@bytedance.com>
 <b15c63490f9164bf46d68ff3ec5dfc02@kernel.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <b15c63490f9164bf46d68ff3ec5dfc02@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: by4bikmuh8tdd8g4kaundcyjbgztf1ak
X-Rspamd-Queue-Id: 7E6F6100004
X-Rspamd-Server: rspam07
X-HE-Tag: 1790070726-670423
X-HE-Meta: U2FsdGVkX18zrxUpDbsudlQYf99Vkq7B9Y0VMj8Q0Am4tI0r/qvvM3cZVCvRktUCok7+X5WJ/p7bYe3yFK9AOwFFNse7f2OgO5QWpeEMFGqqmM1mSSJ27eyA3JemVO1jn//UNewsrgP2miVhkqu8P5MLMI84+ZlRWodd/k0yHUdm79fjiOFDbNlUmDi/f7NJG5vZlGVRVPV18iLYUgo0XZ/gQ3wPT9I5YeaL91DmlJNbK/wI2k/jOdMxNQGffhAsoumIGzLkLC3Tqm+lNB8dg68s/IcVeFFig1TeErKPpJpENGvsG8PrbLYVYjjR47K8iqACB68Lfl74HDqNc3BNFLH4qu/J8BpCOfJTjRqsUtoFDLJNjjdXvgniZjiqMfQie0NIKW+VittSLe3MSy89rzCCSFNvjGH3K7Y9LlYyGzRD0cJhT4zjbz+CLUVJqxiSeqrHL0UzsooTVq8y2PKefZmla8kTKg1iMgWiXp9fkpslnqozz6Xb1kUTQE6wzVBlRuPUZLJnv6BKnnfSVJZicZcfU+0vCvQqZZdLkk2bn1aFOnWtrt/3bSxGLEr5F8DfF2/rF8AUImAWQlvTlIm1trJ2uCaUasewS/BcJYUaJkmUasEPNUcwOmHsgO1IPg5VpG+EYSyDbuEvpaA6SVtU/yh+P80XvtKjKHC1rmkVNakxh/AMCTB9CH10kJWlM88D4D2Rvfc2s9pKhFBMEhcSFbIXqWN3ECOa+JvpFKvhuy09FPfoPilG7WzhALCo/5d0nRz/XhdlXcao9MdDg6uSKChRXxGy9ewIz74McyccY4cUmOLHYAx2zRieyhxnpGhEqVYf3E0XXWXlz54uOTQiCDVMrKe4tEeIyi80G10mmZ7Ecic4OZEWoWog7y172GTJNjIskzpJDgBOc0MBOrNrLX3FyOZVeEqC/T5nPpUEmWctzeuXijBPA4ARF2iLtRJuRDtihiLaZeGFsAxWnzL
 jsfnCuBP
 dNcFJkj1Xs2DEmr09rfTmasGytgrBw8kFEwAfkE2NJ1mRq7exs88wLbLeWTwHnW104OQu5JI30FUaA+wzrTZg1VjWLTiR9VnJdYBOleVmo9aMbDuauEsH8aBILQyi83S0ud+EVahmci7+ymbxPfyEe1kF6gG9pZCqwjTAhyxL8rVy76YosRAlaFkVj7kxyKFbmKUBvQpzdJdyV4RK9hs0cxi/3r8A6XuZParE2thtwacvqYN6N8bSGk0JpwI92jk7OqLKPkkSOQXxBnlxRF1ptRRneGHt47c/x48SDkpSmsQaiFRjnE1qP5LzrSg9fxRHe58A5LLfPF5QmjJMeheW2Ozl6NistMa/Rp/LEFJm5P3qicA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 1:55 AM, Tejun Heo wrote:

Hi, Tejun.

Thanks for your review.

> 
>> +static void bdev_frn_flush_work(struct work_struct *work)
>> +{
>> +	struct bdev_frn_flush_ctx *ctx =
>> +		container_of(work, struct bdev_frn_flush_ctx, work);
>> +
>> +	bdev_flush_by_dev(ctx->dev);
>> +
>> +	atomic_set(&ctx->inflight, 0);
>> +}
> 
> The in-flight window is now just the submission of the bdev mapping, and
> mem_cgroup_flush_foreign() runs on every throttle-loop iteration, so a
> memcg that keeps dirtying and throttling requeues the flush back to back.
> A folio the flush redirties, e.g. a buffer locked by a jbd2 checkpoint
> write, re-stamps the slot on its own. The old record stayed in flight for
> the whole owner-wb work. With a journal the write cadence of hot metadata
> is still bounded by the commit interval, but for nojournal ext4 and other
> buffer_head users it's bounded only by the throttle pause, for every
> tenant of the filesystem while any tenant throttles. Not measured. The
> description covers the target size but not the cadence.

The description, comment and tracepoint suggestions make sense;
I'll address those.

Dirtying or redirtying the same device during a flush can refresh its
recorded timestamp. This is expected. Another flush for the same
slot cannot be queued until bdev_flush_by_dev() returns and inflight
is cleared. A subsequent call to mem_cgroup_flush_foreign() can queue
the work again if the record is still valid and inflight has been cleared.> 
> Each pass also goes through wbc_attach_fdatawrite_inode() and
> wbc_detach_inode(), so it votes in the bdev inode's wb-switch detection
> like the owner-wb flush did, at the higher pass rate. Whether the bdev
> inode ends up switching wbs more often is an open question.
> 
>> +		if (memcg_bdev_frn_wq && time_after64(ctx->at, now - intv) &&
>> +		    atomic_cmpxchg(&ctx->inflight, 0, 1) == 0) {
> 
> Records are only created when the workqueue exists and @at stays 0
> otherwise, so the wq test can't be false with a live record. Fine as
> documentation, but the cover lists it as a fix.
> 
>> +		INIT_WORK(&ctx->work, bdev_frn_flush_work);
>> +		atomic_set(&ctx->inflight, 0);
> 
> memcg is zero-allocated, so the atomic_set() isn't needed.
> 
> On patch 1, the kerneldoc's "does not wait for all I/O to complete"
> understates it, the flush waits for nothing.
> 
> Thanks.
> 
> --
> tejun

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

