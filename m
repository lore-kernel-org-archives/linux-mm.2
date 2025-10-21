Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC95CCD1A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 02:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9038E0009; Mon, 20 Oct 2025 22:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082A58E0002; Mon, 20 Oct 2025 22:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01D68E0009; Mon, 20 Oct 2025 22:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD6708E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:52:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 721BB8779A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:52:57 +0000 (UTC)
X-FDA: 84020599194.23.4F94FB1
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id AE55540003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:52:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EWl2UJUY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of 412752700jyf@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=412752700jyf@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761015175; a=rsa-sha256;
	cv=none;
	b=bO5Oo56l3c0nG7S8krYHTK0aV9UhLBSWcdxMRCZmdYOMkumpZhzMTymg733ZX27LsdIB99
	wWW8DO5fDUQMZkyMUToGwpWdoeTcyp6AOFg3cw8WKjndvNEzK/HmimGEp7r4Ci0IzhIHD5
	fUB8EQdtGv97VLitm8WIUE52ayJLIPA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EWl2UJUY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of 412752700jyf@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=412752700jyf@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761015175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+lFg2ZFUpdrT2R4DPUThE/HcpQLiTAgd/CFeS6J0Ohc=;
	b=CHL7lA01JOTyDQ7bPtDP/qDL9kRFFmfqd4/vqI0mDhXaTedpZQB2zFiKCh83lzAiLwp2It
	a86e2v53b7YDJidgc8wk9Blpv+SZwG1H76MXYRXicSJPsOjqqP2q85nWqx1Gz8E1nanwO4
	NL9gRz63pJQEDfV/EbJbwM+meFUxBMc=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-63c12ff0c5eso10210604a12.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761015174; x=1761619974; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+lFg2ZFUpdrT2R4DPUThE/HcpQLiTAgd/CFeS6J0Ohc=;
        b=EWl2UJUYXB2vrYy8RjeH2aJ5vUDDqvtMJTVb+zeCsk2Hlxf9CfelybEJOo4O21h9XC
         DU6Y1PhEH+ECoDjzt5vpwUQNkm4nT7hiwTbF3OVM2sME3tFwxANT7X5STG/brcm/tvVS
         VpnYf6j8LmgJSMyVUYPzS53LSAyC7q86E/SOUaoHijnxcD8hiVQoWA+FW1o+vp84DpYP
         ewREonE6Lh16zGxLFBhkUW+eO6EeLsCTKU9kRorIuV1nKoaxl+6uSG9E5NBZceVs5Ajw
         JDT8mwkMeCMjM1zaSMNKF/JLkAEdrVxOSM4pAgAEIBY11wz/2AWeqAsUrevEp8MJXygN
         Iw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761015174; x=1761619974;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+lFg2ZFUpdrT2R4DPUThE/HcpQLiTAgd/CFeS6J0Ohc=;
        b=rBBtxQMGLCJSdTsWoe+tlQs1H+OK1juWyC5Y87M5ktuYauvDUnPYBH536kNRTkYO8A
         b79u/NoRFvZymP6gjgbD8s7J85q8Uzw9/ChAvaa1z3VKFxFp4FW3sx4cCnBWJovBaHyl
         +tVTMPA6KlPtrnUqFOJy4xE7kdPOhNxUpyhKQx94IPuy2hHm8AF+zcEQOf0pq2CttouP
         qegotmHZr5gM6k3fVcsPOmosF0Q7iYsqYAl9Xbj7nauaXZ1/L4JImehOfqzoAgPGs1TF
         3oRoSeNQGqcLe3riOj2u1OYvvUQ/yauqsac2CPVE/VXGRKt5ze07NnX79SurQIHgPHcO
         /oFw==
X-Gm-Message-State: AOJu0YzB/OoSg6i6ZlmAxseG+4KBd9NMyUlh6k/VZZ2CLI6ifS6UTKIw
	tuyMaGNQn83EZsWpKmfUro0Cx8H0WFoZfw8o1wrBxWXcBYrQNL0axxmTejV7BqiCZoGn9VWqa6z
	5y+SMmHxI77KVwbBEPZESyXGMWJyhWiYWK94lhI8=
X-Gm-Gg: ASbGncuESERubAEtK/iucF1hegNRO4ICKHQsT0dlO21J/ponpPL/Zp0uH3kUbL50ETf
	C99B7IJ+F/HGvY3UDY8sNFFGScVXwWwmHSrkCTL+Fdj/bPAFctY8YXYiAJ3t90BUqzA9I/4KyOI
	vnsAqYzLBGVjsj/tDksbUbPE7iiIewqsiG/j7jtr0mzLYFPsDqCbPkORoKCCB+UGAcdEkmIS0Eh
	od09Gp5gOwnckuWiMLN8rfalTfLBnOcobki39fLEMDZ3xO5UlrGCrNqKzmMFQDWKG7hvr3w
X-Google-Smtp-Source: AGHT+IEmq7X3S/Gb3U/bOPvAZXYKCAyEkGncY5qcyaz9gTXkjFXnlbM9PS002rsTbgYJyJkq7Sa21/nx9Lpmt8pl2Cg=
X-Received: by 2002:a05:6402:2713:b0:639:e5da:637e with SMTP id
 4fb4d7f45d1cf-63c1e1f212fmr14885424a12.6.1761015173539; Mon, 20 Oct 2025
 19:52:53 -0700 (PDT)
MIME-Version: 1.0
From: Yifan Ji <412752700jyf@gmail.com>
Date: Tue, 21 Oct 2025 10:52:41 +0800
X-Gm-Features: AS18NWAm93w4E1HR9wlOqKTla8-E3h1y0PBY8xr1ipyO95k053_X_h4pbXOyqw4
Message-ID: <CA+9cq0kkbk2Bpgyah=9bU2+=QNM2L1GfYLgMK6OuRhda-B80cg@mail.gmail.com>
Subject: [DISCUSS] Proposal: move slab shrinking into a dedicated kernel
 thread to improve reclaim efficiency
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE55540003
X-Stat-Signature: pak3rcosscqpt1pbgiecheh84bbtew96
X-HE-Tag: 1761015175-115697
X-HE-Meta: U2FsdGVkX1/Uy/hi8Xhl7s+NlOFK5cXB+vjbsvHjVjKLKEPB6Mo62TWjtC/cXYnxScpLcSaQGuhZ5cSknfZYpBA2BR1+qXSYE/WJ4EXmIctpGOxNXSbFleoEmhqVyRlXDzsg7/xEJaH4vFwA6frhocmGz4fKsyHpXMN3PbrUWvCGQjRBglDhxOS0oW7LuAbuL3PS78bknsIMEWFdQF8kGV3fS0RFhzXjqnTxQS11LTt7/mbpDhf2dYumRrB+PH/UPZLk2CBp5faTSNWRsfRDvfD5R/uBA6+9mTplzS0NspKl9kXepEbmX2/GIStzjrdLHzqbGoqdQl4ihRAHc7sqassyts5ouUNcqMcOWP86f74ZbRXN8Z0BS2dl8SJPU57+i833+YFdFYWH2eroHt6qI+IdUwaivKZDxnWaV0it9LORFql7aWh8QArXhHQSYXUIYUsCQ60Knoc+bfHbDt2i7vrW7bxvhELMTDz0rcoycrUmxMJD1JartE2z0IHfUyJfMuM8j1Q1DDYKHyX389DyftCs452Ve5mv0L6ftn8CoH4otm/ghHJtnEus8Whg74W3S15DLvs9WINRTSx1OJ3e+li4JEToT26g5/r/7f9u4ILay7csYDMOtJCLALYIrEIaY3FOK+Tj1JAXg59//J+6LG6g51CdzUJITom6dCRVggGSEPyrydIoZssOEL6R1SxJMbXRzuNk8K1bXzNr2gvJoHLJcFdPjU9JUU/M/ftHp1Z1o/mp6INuyLHC0VLQtbgxS954F8q1uMWdwbKMSVWaV1xmNZHPm9k3O9mKdCaYtJXOZw6M16uTY/7kBStWWaNAGFPwRn8wtmfrfXJmhuQhUTsDjz7DjVj3wQ/cCWG/1uYtg1H7s+I9TmLNNzu/qWfWQ+A0djellrUpIkB263A6uCGQFtYFogsV/o/865khi1erAMJ3wfiT0e5AIJpgBxXlw5KQlOi6WU7Iqid8rts
 FQEeAKpH
 z9mJIrnDNxPOfe2LN6hCN3eRjIZfQPRCwhKat9Jfukp0kyIeqpuNEt0/wAN73HdxjzgV0FieC7a53vu2Bl/N3cBW4ZAjrrdEESYghQgsJLMm1FWI9cXv6+gCyqAqWTHbjZNfazVMLh9lXNsn/URTDijLCEsIDluqXe5ulArDCjE59VL6m55JlF3Kb+IXw5xUcVSKJdB453rCVvXPeWZ30/heLSNInb5cMR24kzGvzE6mi00hLnE4AZqCRqi89AOt7afLJn+rCRFVnvTomCTcaEg78Fwi3JTMKAC1NKBFLuHEPRS/x6eNqNcClZRkmFIjTXe2rS+tkrh4myl0NgFHzB4ZauspU6wqLFFU9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

We've been profiling memory reclaim performance on mobile systems and found
that slab shrinking can dominate reclaim time, particularly when multiple
shrinkers are active. In some cases, shrink_slab() introduces noticeable
latency in both direct reclaim and kswapd contexts.

We are exploring an approach to move slab shrinking into a dedicated kernel
thread, decoupling it from direct reclaim and kswapd. The goal is to perform
slab reclaim asynchronously under controlled conditions such as idle periods
or vmpressure triggers.

Motivation:
 - Reduce latency in direct reclaim paths.
 - Improve reclaim efficiency by separating page and slab reclaim.
 - Provide more flexible scheduling for slab shrinking.

Proposed direction:
 - Introduce a kernel thread that periodically or conditionally calls
shrink_slab().

We'd appreciate feedback on:
 - Whether this decoupling aligns with the design of the current reclaim model.
 - Possible implications on fairness, concurrency, and memcg behavior.

Thanks for your time and input.

Best regards,
Yifan Ji

