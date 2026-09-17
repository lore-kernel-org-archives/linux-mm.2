Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8AAC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644B06B00A6; Thu, 17 Sep 2026 12:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6326B00A7; Thu, 17 Sep 2026 12:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386CF6B00A9; Thu, 17 Sep 2026 12:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14D976B00A6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:25:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 207A840413
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:25:39 +0000 (UTC)
X-FDA: 85223779998.05.207CB4A
Received: from mail-ed1-f99.google.com (mail-ed1-f99.google.com [209.85.208.99])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63C65100003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:25:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=everpuredata.com header.s=google header.b=MYio2zgh;
	spf=pass (imf05.hostedemail.com: domain of tmenninger@everpuredata.com designates 209.85.208.99 as permitted sender) smtp.mailfrom=tmenninger@everpuredata.com;
	dmarc=pass (policy=reject) header.from=everpuredata.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662337;
	b=6qjXRHSDeNR5lgQxhDC7kBlZKlUExREObDnDvAEQ8eZvnZMF/wr16tFM+QTw7M1Hz9zt8I
	5Xf4lwvV75jhgPu5mT8d9L/2dpcdL8ViqqJqnVAKbqF55R0YOv/0DBiucSdlTpAfcjecn1
	IFRAI0DHEBeVuGp22kV+ElZJgk8tS9M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=everpuredata.com header.s=google header.b=MYio2zgh;
	spf=pass (imf05.hostedemail.com: domain of tmenninger@everpuredata.com designates 209.85.208.99 as permitted sender) smtp.mailfrom=tmenninger@everpuredata.com;
	dmarc=pass (policy=reject) header.from=everpuredata.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cI+xjeNHVNst3t+SGlRsF85lt+goiabsbiUNU03nAKw=;
	b=rccH4MYQ98tkdafyCGVuoZJUTwVXdyMRyvocnsz0P8gFt2e6ZTx7ZfPM9QKUaKph73ybUT
	r+3Ot4LES4qrCrNH5xMkRr7/j+I2qumiU+4USJ7PYAH3iS1CjuyHbhssNIRVlRRKiXSiHP
	lBCBnWGPwNLU0jqjzCMszGkThvtb8pg=
Received: by mail-ed1-f99.google.com with SMTP id 4fb4d7f45d1cf-6a9bd4db6ccso346804a12.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everpuredata.com; s=google; t=1789662335; x=1790267135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cI+xjeNHVNst3t+SGlRsF85lt+goiabsbiUNU03nAKw=;
        b=MYio2zghV6/ktRau9KVvw535ZIPSPIU6W0zY4s9Pr2aNzffyun93BekGILVe3xGstu
         o/SgZromb6H8t6xfSG1LLOm/uJtpwpwy4OOWlNmLYXlxr/no+YDnitiyl0hiwp5ytBTD
         3w15MvrIY7jl0iIDY6WXaIhdiK+Mp1jkGegfQvXXshyXd0UoTex1vIKZllPwoc8UB4R+
         4HsVEKtAVX1XoHE+nDFPnhFl8qRLV8CspuddZYb0bXBpf3UoQlULALW7vDNCaDGbqPPZ
         M+rEF4PgHdoYh0Sxz1kms0LAJ8kNU4hCY45vJEUYNz+w050FVGMrlAcoFM25rg4Zc2fs
         DgDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789662335; x=1790267135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cI+xjeNHVNst3t+SGlRsF85lt+goiabsbiUNU03nAKw=;
        b=AeidvG7OJyfHehJSJZJFt6M34hVkAYlImal1Gks+pa5brArLnta9dgXYIs8XACGQRe
         BQgsPkBaDzhwFzdLY+UOr/trY+RJpt2WoxMlmholFtYg2/6u3x1qjmNq/ZpYn15PuANr
         0VpKx4TvVE1TNZ0X7br9yYOFPQJJfoobaP0o2JWM+jYoHB0+oV6yBOwegFsN0ytxRhzn
         oBEWbzDJgAnSfiC151aewYGtj8cJdFbEJucm1VhLeMKlSJ9Z7CsRtOQkeE5s7DlM9FuT
         W6p8ppMUMdfjt0y5fNmnmgWAO/x1vcnIT2Hc6sROBsBfZfwM0Tlbw0IwiaXkCPty8xc3
         qUiQ==
X-Gm-Message-State: AFuF++nryPykjLWp3txbgKpI1JEglF+WwLMK5DzCyGIVJVi1x8Zy6wg/
	yO6hHMOwBkA4K3KTsOkrEr2knslHqwA0Yph7uEXpcWEyfC/eFtsxT6JsKIUFy+Xn6S16WZMcVVF
	6J0qhl+rW3U4IKguS48K0F0Tu5iUefO/O6xQS
X-Gm-Gg: AYBFou17rYmN81CYBtjQ3iQtCrrtMzXFVgmefwTdeWnITKyi9e72Ol0OqBSDznrqA4q
	iSaO9xpGceEQTKbMpC2JMosDhEZAgrhiomxgwHzTEm000Nq5ZImMP9DDsXPfa51m0WgoXxW5+7X
	u2P37+MtuWm2cQmLXHvlkveLEQoXUsuBjagpYNOh7baSEy6hy0kmTPBsVFGCtGJFBDLSMncUKKy
	tvKSHIrA0b404Ch8l9FKw2k6mracp2TcSoVqgqFVUPfksa6N2ntEKyBag51P87HeGs0P6yRaycZ
	HJB4USfLJiXc9ryqUp+Q21FBxkwwhmSQNwnrz6IquW+YxVsyDZoDz/rEH/iHkcUqYUxgvLxNWLr
	kx4aB4lsCNzhWLv0ZQRvo/sOJcSD46fEJrSqzIuE=
X-Received: by 2002:a05:6402:24d4:b0:6a7:ee54:f897 with SMTP id 4fb4d7f45d1cf-6aa2244349emr4232275a12.27.1789662334673;
        Thu, 17 Sep 2026 09:25:34 -0700 (PDT)
Received: from c14-smtp-2023.dev.purestorage.com ([208.88.158.128])
        by smtp-relay.gmail.com with ESMTPS id 4fb4d7f45d1cf-6aa1cf65559sm2670116a12.0.2026.09.17.09.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 09:25:34 -0700 (PDT)
X-Relaying-Domain: everpuredata.com
Received: from irdv-tmenninger.dev.purestorage.com (irdv-tmenninger.dev.purestorage.com [10.32.149.15])
	by c14-smtp-2023.dev.purestorage.com (Postfix) with ESMTPS id 1A53034014B;
	Thu, 17 Sep 2026 09:25:33 -0700 (PDT)
From: Tim Menninger <tmenninger@everpuredata.com>
To: Harry Yoo <harry@kernel.org>
Cc: linux-mm@kvack.org,
	Chuck Lever <cel@kernel.org>,
	linux-nfs@vger.kernel.org,
	Jon Curley <jcurley@everpuredata.com>,
	Eric Badger <ebadger@everpuredata.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [SLUB] nfs_page cmpxchg_double_fail and perf lock perturbation on dual-socket NFS/RDMA
Date: Thu, 17 Sep 2026 16:25:33 +0000
Message-Id: <20260917162533.600472-1-tmenninger@everpuredata.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aqvy8NqRRRmUlxjR@thinkstation>
References: <aqvy8NqRRRmUlxjR@thinkstation>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 63C65100003
X-Rspam-User: 
X-Stat-Signature: srdzmswyp19bhtr4amxw4p9xryb3s11a
X-HE-Tag: 1789662336-533152
X-HE-Meta: U2FsdGVkX18uWWyeL9FgiuVjrrZifWTNZplu0ps9edXFbc8MT6KzNbn+HuHMp0Ct0FWjrlncSd1sk5vF01+LmIglK7PidnMhBPCqqIacoAQnNoRNh4fWfxYukvBEEIY3FWB4ae3It9wbypAfOjui7Nd2+Yo4z7cQZXLPC7aniEVQb9fzDPcFsSebWi6Ivz4k4y3thSPcN0w7RgCRs/9GZDa6ahetTtmC1oA1Ij2qOF76v3tDis++Ow+8c5lw8zvh99QJ6qiwfvMgqW8+0kFEHhI0ARAZF117sS7DDrp8GZwM0ct7jnMniiAxihcSLBpxlBWapSCobnJUegozgI0Pz/ptu4MPXBRJiQcy+Ts1c7uzKxe8L3rTQaCMUIcHU3oJy9sgSKedh+ojPniVmIApFTkzZHfOxLgfePM+IkQOaY+lArkX9Qs2ZSekt5lnt/64ZBqka0Dhl0Fc5n1YE/q2FxoXfzt/c7Y5kjCRwKq0BUQLhhTUK/wXy64jRSiRcbzYvZ8RixEXe5i6FUtqxxvNVQMBazD4gScoh6bCzOYr5fODZEhL7Lv8Zu6ADW6DkniucUt58NO/7D3t2wuo2zCGTnV1mCAjj5AHCfxxSyNmmU6cCpBfXtVcsC9pjLpBLEoZ0f7c7DeC1VcrsyKwtGKb2tEmvetTHnDPNyTCbkq4PMRY1/Vbt/3dyTi45U7b9D+QhqAXl8QZyXH6kFP6LV/TO/p7j8itWr7JTbee1NQj6Zjg2yTOhgeepOoJ5yRe3gbvNbjzqoGSYJznrkTNxaS6FOxeWYsewphFkia6/aPg7i26mIh7b0JEkZ0zq9IFSudYHTy2VewW9av/fOdj2oWw5YMoDvQDoB0qDAO4d1n+SvpEheIZTzLrSe7Q6gZQZO7S+78YxTrRg2TM9VMJFSRHAAv2GenI0jt2Mm9tMOxzitsQiz/zViCcFU5LAXCiMCU5U3otM+xDZZUMRwxXy81
 1iOdFb5r
 G6LqMigmHwb8rcHfr4yp+nCwQ6w1bj5oVJfPpeEuzP41ykOm3Sgr+PRJnkuycH/PhdjwKdTaYNLRQMfAaGnSXN4Z29ZcnAiMC6wNkAocgEzFVcrcCAh8WlJ+klrtmz4StLak87o61cRSeTJsZfdT9q9vjRpbxegLI780LmBgW0fUNDG6kHV5vlXgliNRh5oasf3SHzEhNxNr/P+klydTwFhHLRODez5C+Rce1ZYsMcmFs7IIivIoJGcrFCmKHmELzwks6LN+ucv7qXzNnhBMM5CoXFUnX+DtbID0AJgCnVvDOUDHy/BXhDIjOtQ+737A/TanpC9GZSUwn2HiFX1vCaaswXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It reproduces with slab_nomerge.

I booted the same kernel with:

    $ cat /proc/cmdline
    ... slab_nomerge ...

Uninstrumented throughput remains in the high-45 to low-46 GB/s
range, as before. During perf lock it was around 30 GB/s in these
runs, versus roughly 25 GB/s previously.

The dominant lock measurements are essentially unchanged:

                         default             slab_nomerge
    unpinned/node0
      contentions        4,782,839             4,858,759
      total wait          14.39 min             14.26 min
      average wait       180.47 us             176.13 us

    node0/node0
      contentions        4,582,012             4,686,729
      total wait          14.13 min             14.34 min
      average wait       185.05 us             183.53 us

    unpinned/balanced
      contentions        4,572,196             4,544,677
      total wait          12.81 min             12.56 min
      average wait       168.14 us             165.84 us

The uninstrumented cmpxchg_double_fail deltas were:

                         default     slab_nomerge
    unpinned/node0          7,471          8,892
    node0/node0               713            457
    unpinned/balanced       1,503          1,504

The CPU-utilization change while perf lock is active also remains.
System-wide %idle for uninstrumented/instrumented windows was:

                           default                  slab_nomerge
                       uninstr.   instr.         uninstr.   instr.
    unpinned/node0      31.46%    3.60%           23.02%    2.15%
    node0/node0         84.26%   12.07%           84.62%   11.85%
    unpinned/balanced   66.86%   14.83%           66.58%   14.78%

Thanks,
Tim

