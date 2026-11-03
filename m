Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC856606A333
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=Ujbfd4mm
Received: by kanga.kvack.org (Postfix)
	id 0A18D6B05B8; Tue,  3 Nov 2026 13:26:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FCF6B05B9; Tue,  3 Nov 2026 13:26:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1C86B05BA; Tue,  3 Nov 2026 13:26:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C460C6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:26:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5140BA0510
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:26:32 +0000 (UTC)
X-FDA: 85394638224.03.F419E79
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3FC23160002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:26:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ujbfd4mm;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIGmBf8e1TRHzdHJsTtZA5MGm5kHZ3GW2cmzV+bXePs=;
	b=vKcc2cKqmoynajwe1wlDbeUY9gxkQefIQ2F06KB5htgjGLgqre5/n1liBRt4YEInk2U0+X
	E9n0tcUwdMRhbaAeZprKjhyfSZUFuyV5ZzrQjHQOrWy02LPysXVvei8NBERIGZh4n28SAU
	HBiFMXI3FN9+ox0z874jJ8uLlBf6Er0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ujbfd4mm;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730390;
	b=BbTw9/ny3OYfnD56m79G4DPsSi7lYSUIwlX38KwKVgEH5CgQ2GKZHMfp+i0kEuPa4NNg4U
	Xw90UW+FQXemTV9xImQOgIOkrjayNdRQqnKuQ2p46va9SdyHhB2A1szHaUrI1x48TAXq3s
	afR51u6u4kqdbLUEeWlWh/FsmOIFnN8=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b305e10ac7so5326917b3.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793730389; x=1794335189; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kIGmBf8e1TRHzdHJsTtZA5MGm5kHZ3GW2cmzV+bXePs=;
        b=Ujbfd4mmQmKco260WvP/0xdlLuf6B1SCx+rdU8IkcAsbodkjaP6E/kDelEsLFVvwm9
         OVnLPquqzXMif4ebMrAmnRXvqRl1AYQSrvrFDq7pl0qTYQkJo3JOmmmxyNuz/DRQpHv6
         +IvG6E5OK848H/dzQIdpy6xj+n4YjhMAlxpgUkxT4LELVxpde5AqspJdSX2n+0UKmPN+
         k2si2LUlfkWOybduQ2vgYXOHVjgbLtbUcwUMI/wR78ZNbCT60c2ZOBvowF3c8NMvyObi
         BJv2I12ElDpvaTx4R1rqAa0jmKv22EfK1KQOTi/uMStRU/LHJ4I5o3+KHf+PTy0jBar6
         gO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793730389; x=1794335189;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kIGmBf8e1TRHzdHJsTtZA5MGm5kHZ3GW2cmzV+bXePs=;
        b=MmCJLhPjxOOeZa+g3opDzCGeVLWBHxQ29kIBoHxtJ3tIL8jktUZSY3tpVwO2DFyYiD
         V2jxLGaDbZkvKZDgxIWtQfkJMuPjdXzW6xzMD9SKFJoEP8h+MGONaAORpwkoklzsME/H
         W6Bu6vhfeLPwLoBl5duzkVIO+CWXViKT7/BGy01CFheR7edDbyjxrfaMthzGWdMHtHUv
         4+IMQwcWcw01QPX6mOLH7nsKDQ2eZvuHF4h0zNzHxnlJ9MoEL1A/9b4oh7nJts6ylc+X
         /VIcOeHGcNlhkLakBjdbqeZRFU7es6ZLX8QBGPOwqUa1i3FcFc0n36iP2Z/MtQbzNKFT
         9fAg==
X-Gm-Message-State: APuU4Z8K521rZzkiS3qcQIe8yHeVPbOFsAWIz5z3qOI0aKyR5z+GxBGW
	USsqKn8VdxLs6oWk9DddQIzklEHhIdm9m4NsmKHpLyAmb5RpX/W1v+Cvko2L85b0KUM=
X-Gm-Gg: AYBFou3FPWRv+6pgv6ZIOaYr8rZZ88zKieRTJQoTncY4I67hHpirUrqy2jkHTPZghnP
	HysCVXTeL2ZSzIYk1aXpRBtp7pKZmwBYgolys84ikry82cB2O1vjq7L+a/Rl62MghgG+2KTgaL8
	NcY8+pGGj9mlEqiog0BRuRv8MO4b0InkqNiRfdyQ7kwffjfwrAVD8fqZxaxitIXpDK2rR4cXn/0
	a2TpgHAO6huJQiFYiPZpdL1lWs2nOyGDkF+WdgMTy4NGUH1Aro2VqV1rdhNmoPgp7YyWr4pskoa
	JuFCrtzmlYJmW2z+YIj6OuqkWj3uhu8GtX/MARThi73alOFVmABt287joYp8zBeSEyQyxGoG2Q4
	cqxkEGm9kt/SrU3Saq0BoOJ377E9LKnNzowQINtBdebfoE7ygCL428gdm4/Va7qyNDcz3+N7e6L
	NXbefhOVS079iSaDjZiILhWuoTTqa4FVzIJgcBMPEOlUa05PYskEa/5pSaXx7ToaDGskFQFZ8kO
	qSWE6Wg3sbmle1IZZN60er22qiGzWiTQIA1Huo4ZYeiLj9TMRjA/qPcPew4W3yqSxAf2MHbwN9G
	SwkEtaNlk7Xkm9WixYhHPxdrBYJPTH7DtPQVrusZLhoWpM/k
X-Received: by 2002:a05:690c:60c7:b0:8a8:6fac:1525 with SMTP id 00721157ae682-8b2b67ab45cmr101459337b3.46.1793730389191;
        Tue, 03 Nov 2026 10:26:29 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b309959603sm2328207b3.24.2026.11.03.10.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 10:26:28 -0800 (PST)
Date: Tue, 3 Nov 2026 13:26:24 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>,
	Mani Tofigh <mt4022@columbia.edu>, NeilBrown <neil@brown.name>,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 3/4] mm/swap: account synchronous swap reads as memory
 stall
Message-ID: <auonUGAjifyuWJDv@cmpxchg.org>
References: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com>
 <20261104-swap-fixes-v2-3-204be064be5b@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-swap-fixes-v2-3-204be064be5b@tencent.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3FC23160002
X-Stat-Signature: di9zmgwhzjt3q7wmjer44xq8wb1iraie
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793730390-230900
X-HE-Meta: U2FsdGVkX1/p5XZnLMczu1OO4e+uIx7DT946VYqLLtwQeVJDHdhyQqPVN3RrvMn1PJ5EIP91/VoMfZX16PGqVhKOCHhmiUPk/q7LyogDbpwjp2UI8Rxp8NPsvul9FqRsgi1ILdcgQGcMcPIGcoWTapo16AKTTAgDaDOfKK2hVoLBtA/rJpKGewIoD0DX54+1ezZz2ya3hDaOhPlrDph5J1aJ3lEUqhQSuL3tAbgfZLP1c15sy310LSpNsMdORj4tkp0uKFXd11CYkN3z71Cw0VN4rO3lhHtzhkrLRfpnsrwyYTOqpWxvwgR5N9M+DnxXKqq942DG7FH6XDOnvP9jxynEr8RoD3gNWsEofzZR14gEH22WBO8Qyksh0efzRiSCCKPhTvU9hugT4lQuQWMHRrT37HtucyWdJyM2DsZmCuGF9XalPG0WkzggkLFqtRGSIVLmRqYR/3Qu91ciTMl311i2v3ov6grXgUgCSSM2vaTvDCuwuSo68KjVG7hqk/FObuy+eOfRf4J9gp7wJMDuCQKdSYjqR7ZfgkWWlrZpaKYInwf2Qo/XJLBtsesaKWhvGSOtwhLuz0MziqIO+/o2tgm2/SRkQiniorjfD3FieV3jyHnHnP/IKnW27qD7a+hocSDkAIzeFfMQS3xcBQBhTAmho2Xglt/B8HStqQ1KyccCqB4U1DOiomjQT/CB6kaJ7QQ1vhLOM8puCySUU3lpyZPY0ZRvjmBEicTJ9+SZ0Ghl/yEnbVTmw1om01MCAkoMieuRGWQie1tbr2cjfMGyfRsoSsEPdDSYFPOwdW55Xg/jjnHeA/0Nvoa/SDY3NU6qaSXyO+XtseG3EecEgpKaMbDxXBkSLfJFhBgtlhBU/CwHpGY3+vcPBtQVdz54AS9vuXr1QYHKRIrK2Eq8sMzkEnD4kyg5v7c7TEoQqe2wsrrVcsQoM9QpsAdk2hbNCnXHBRrA28M1RwcMhgbWWTc
 Og06l+Bd
 2iL9PcXiUqyjxhClS7fVa3J/sl+ukvWAtQQDE5m6Rz//BIij8V3WCv+bULr/s7VKWI6Js/QUQSyxT29LEb7gervc1F//fM+HgCO3lyEmrvLKAj7Uz2bL9JjKQ2/wJ6271wijBo/71s2pjzTJ+fQNhqSe1sBvmXKxvWrSbNRP6ZfRcZGeUPBEzVCd8+mgxVz/FrEV4KEf7rXDbcCROWW4rDNJzuOu+E7U8W25T7bw4PPMFr0CyqJ6txdUvCOrYZsaooZ7UxVruNHAwlyMzFQ+8qdQNYMQvXSn27yCo0lAtZN3mSYogxsMozqlSzZmLB1koayr7Y0JEDyp1+vWIOKPEkurLDvZViQEJ9ipB4GLJZzB7FHke9Q7VZKWZaXLz6Sn+JGjPCRgqWQxjMgRFcYenGSDVDknomdsS6ZC5YVCENyp0WnN6Wg2yuHOuA9YPmxT60MKcjsWkECl59jIoX6ZGUf/QUoa4pV+fFH9mqnS/YcBNq02VJxEM2vHNsCEbY+aVzMVYypZcKxvWxv5RoKUUmV/5NlrvpHdN4lZFpOQMa8ZUTjEJGLeWMrnrv7sdRDlV0DNsKzr2zkXtnZlgkfKptytHpLsIIfqgCZ3oWFgKwWJLf6La77x57m+yG4IxHe1IiY/HJOIj1PNuKeBaxpDQai+T7OK4y27ZzBmh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 12:18:16AM +0800, Kairui Song via B4 Relay wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
> counted in PSI memory pressure or in the swapin and thrashing delays of
> delay accounting.  Refaults of the workingset from zram, the main input
> to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
> become invisible in /proc/pressure/memory.
> 
> swap_read_folio() opens the accounting window with
> psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
> means to count the submission time.  For synchronous devices the
> submission is the entire read: swap_bdev_submit_read() does
> submit_bio_wait() and completes the folio.  Since reads are batched in
> a swap_iocb, swap_read_folio() only queues the folio with
> swap_add_folio(), and the bio is submitted later by swap_read_submit()
> in the caller, e.g. swapin_sync(), after the window has been closed.
> By then the folio is uptodate and unlocked, so the fault does not wait
> on the folio lock either and the read time is not counted anywhere.
> 
> Fix by submitting synchronous reads from within swap_read_folio(), as
> was done before the batching, rather than from the caller.  This gives
> up batching of readahead for synchronous devices, which do their I/O
> inline anyway, in exchange for keeping the accounting simple and in one
> place.
> 
> Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

