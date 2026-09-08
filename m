Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9264FC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66336B0093; Tue,  8 Sep 2026 10:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A444A6B0095; Tue,  8 Sep 2026 10:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CAE6B0098; Tue,  8 Sep 2026 10:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE606B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:21:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA3B5A0290
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:21:29 +0000 (UTC)
X-FDA: 85190807898.14.54526DA
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id CEB9910000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:21:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ee5LQ38z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ee5LQ38z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788877287;
	b=TLPdmenXIFEXNG3RWHF3ZL426oUiN/OE9JjjCKaDaMiISAK/HUqs5Y5Hm4LxQGFnRTWvrh
	89VZJox4xNcDbqhAeNkmU9F6sxuVzBWlJsbIFwWLv6aquixw1PBK7Svna5qHwC/6euzs/y
	xcqVP84nLACSrx8jACo44XGCy6Fv1D0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788877287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elHR2dmgdiO2iJMqseykTVVlGqNYHDXkrEZm70hbhR4=;
	b=Iq4BM6N+vD3Gv2zzCr1pNrfRMdewk1O+ueKh8dmPpcXcNrkvsUieXYpdV4xz+18BnWs2VB
	3FgddpVXHzLzAKYhiE8HinKqd6+G3geuHrwSM7LnamV6nSd9TRMmTunEXNPnT/y5RS+02V
	dK0Qkr0GohdTmUSU0i5vzotyt/3R52M=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso39614525ad.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 07:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788877287; x=1789482087; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=elHR2dmgdiO2iJMqseykTVVlGqNYHDXkrEZm70hbhR4=;
        b=ee5LQ38zzT+z8rt/irVapStuHYg3Zb7HJerzwHYmGWbO3UkobMFBoV/ss6V2GGzc1C
         yMDLV6SA0lrB2V7Ngo29JCfRCClzfB1kIsOG3P14dXFHx8VZ2K/H+Mxa704SBMGiibGv
         9/z/blt3NbJ3zGXRWpniJ0AMvmrn45jHfnPeYpdDYDTLRKLxAs0lEgKYiT2l2o3u+6as
         vK2d217lZRy1vtLqoPkCUYcCCU3fu1ueYI6UXZCd3kpddEtqLSYmoc5D1PqlNf+Dfl7W
         oYVBJm6rrvv/sGtdRwm2lpWy7atEPB69lzCOCYiR1v4UKL0U0I9vCcviMexnjr5U9eKE
         eDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788877287; x=1789482087;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=elHR2dmgdiO2iJMqseykTVVlGqNYHDXkrEZm70hbhR4=;
        b=I59p3ded+yiibOE53UUj5zd3io4ILRWQTFtAO2KhtWXs5A+BsRSLp8hvjMdNhC7B8M
         FmMlIe27iEqHf/B9EyuCPOm68WLJy86fBU4ObKmUGJ7nrD7SNA8dp5yTO4syHw1ksY/4
         rU17wi2bw1gO6f0QnxLJkGooAa/zaAxFik3yYwjNdZFq69uoTlxnLIfM86sLVbMQXCif
         lCCTPt+oYJHv6nqH2WH/I+iwv33ajYuzGc3UNa5U6jVyiMuCw30qjphYe5EtJ09n1isZ
         b6uRS2CN4IGUna8HINQj9UoGj1ZDaWiX+PZ+Dsvset6cyqcRRDIj92zLi5rTotoxUC+r
         jRmg==
X-Forwarded-Encrypted: i=1; AKwUvBwd40LmXYdHArkwQopyeb3NT/peaoOe84bMgoBss/R2rEB5/YcpCjLe2XqD8E3UUlf7dSnWpnmHfA==@kvack.org
X-Gm-Message-State: AFuF++kPAZHt3wXwzenHKD4m9lib65W1oBc1a5w016zU2vCfF59dgiGK
	jzMsBOLMusix1Io71QS2S7Ia0kJg84nD/hfOjiu+JuPveGC1dOiJk8S9
X-Gm-Gg: AYBFou1/u6nSL5brruePy+VRoaj8zMehoIIcejKy0l/wW61IDk519V4qgXs/ZZBpz9H
	Y1isP7wMhbZX8JPxwMBafcEHqEErLmf6ZcZvSC6gcM/4P9zGOL+7dfhf6/xhI2W1LnLAWF3oYEV
	sNTecHA+J9LSNLjY9Ms0xvnnnJ0/bU0m6/NcNefV0HmPR6VbmVvhWpkYdL0LJbK/WoFNX6DLgXQ
	pMnTqrdySc7cRMJ/E5U29za/1kybJf+Zp/3NYginFxbcOf7H8ucpDkfUWJ6llfhfHVcvpMTAhAx
	EIuEyQ13WZwufUEMnhHqGan4CegXLHTeGD3tFikfnUglzuBlCxBxx5uOj+YQMYLxq2t3W2r9tIN
	YHdyEAR7gQtIsVxhcNtnUCPzDl297SNOERHZcLJPe4m0UhMQZNuDfIJrKKzjBtrWjI6t/sZi+Xx
	Wo4k9dWGgg0itICwiD5bIoBky3sV+cbDRKFPq+C6CZ8Q==
X-Received: by 2002:a17:903:11c8:b0:2d8:d4de:fa80 with SMTP id d9443c01a7336-2db1235721dmr410393595ad.4.1788877286477;
        Tue, 08 Sep 2026 07:21:26 -0700 (PDT)
Received: from pc636 ([125.29.25.186])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db14841054sm61015055ad.3.2026.09.08.07.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 07:21:25 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 8 Sep 2026 16:21:20 +0200
To: Hillf Danton <hdanton@sina.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	stable@vger.kernel.org, Dev Jain <dev.jain@arm.com>,
	Ye Liu <ye.liu@linux.dev>, lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for
 vmap drain
Message-ID: <aqAZ4H8mauWw4JVM@pc636>
References: <20260905152717.11711-1-urezki@gmail.com>
 <20260906035027.2106-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906035027.2106-1-hdanton@sina.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: CEB9910000D
X-Stat-Signature: nicidgk67rumds4kopg6k7s1sufunpoq
X-Rspamd-Server: rspam01
X-HE-Tag: 1788877287-49130
X-HE-Meta: U2FsdGVkX1/dZ9N14AzO0JBuUYhWHNpmb36VNzrhwYniIgZc+Ihl/D2MQ2RiMJlO+To1PeatkQ32/Aejmdl21MrrUS0lGH/pgmXLvSgAEo3+tOFMH1mAmnndBWI298yViJmthWlha4mT7Q1MOdXnowISM537rC6o46mNoG6KIf/nR7XCFvEsnXcoviP2KaehaEKGef61BwR8zI4g4Wne5goOt3+gIqn9SsFC64Kx8jZcPVyNjYdHEvoE6atYpdqE/EcZ4ssHzaE5YMryvs3GuK7R2290W0jO3vbmlFAQ1qxcnkP5FoNKOtcgqu2MT/g4SWhFzl6L4J4AOE9SgPuQrusLbgJOkG3Ae0Xy/8mI4Y2WV9/caikkaa2M6f4PBLuMtSk8HIuMPbwxH/mqdG12k1rcQgsFREbLrSWJR4XLvG0E+O3wK/ivhKseTeiMZ24/pT9J+AZT6mS/kuTC96Sm/BGtMJlPknnN6kLeJdSapruXL1VZBOscGJRY0EmDepDWL1iimaZGEW4V49dAngpZRPqvRERQn/Z7ANNTBBkoh823F3hX09ebZz9B49R/+UVJROXDjqrOwQRpVgLXtH1D9wFCTwzhpELjUxk39u/LG4qGa2GtQn0x/2uHhZ24Tmgno5LjHQXpGqM7b1e0w2TUSCDU46giuhRDkjJll1pawtGDsDOL1VJHGudVHJ/FZt8vZ4GC8/wtSopWlyxjcuMJv/tV1R0F/EJ9kze6NzmAVO+GeIYEO+bU315yLJDaiKw9rNhgqU8IU9e4361sfTZf7QJmb+fNt+O6l2l1pHLWRWyl77v3j5/ev80K/H26wdmCdlOWiKYU6WKz1BiQaLXBNPdE0AVlEqp1K5OITgC7V8WJ1ALgY2ZKGkdSgbmtqczgOdq/37W4D/eeC3oe71jCsujs85EcfdxRe7nd5bEx/rnRSDveCU0tGSjayQ7qt9q1YYgek5Sn4sgKbK3kQxE
 pdt6vnfV
 yddYPkN0ydzbkeFw/rULSxmzX9ItPW2pO3vf+9jH2Y0UKI9OOCJ9KEqEq0133vkN77sMOO9gDsI0zfQ2yqvgWC9dlj0kf5J7u1RkeL3qU+ksbV12wb4mxfuDCNIUWpZn6qhbSm0AFLYM+mNTvK+bgKJ1IrcNJIf9MGr+dAHCaNb1jw12pjBGm4PGouVmfliJxm8+mSaIbK4ijEJFJQY3qhap7ctldjj7ZTL7JVCPIyq3gq3HRRKv+KN9XJLJSsj1SjbEhsX3NhiNETSWJjThgTmg2lKVaCV8627bolEEmgebxbzx3RdPgzwRXAeTNg4WPCs/xwqqSHE2MDvjiPuyiycSmHSB14vDlvm5UeOAkWyoUNjyFumbFp5N6fb4DDsltzf3DvRieJ/sk6e2J7wxNYeavAgnLBJSDQo56Q0KcGMW0bFV0Q0khhxf/xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 11:50:24AM +0800, Hillf Danton wrote:
> On Sat, 5 Sep 2026 17:27:17 +0200 "Uladzislau Rezki (Sony)" wrote:
> > drain_vmap_area_work() function can take >10ms to complete
> > when there are many accumulated vmap areas in a system with
> > high CPU count, causing workqueue watchdog warnings when run
> > via schedule_work():
> > 
> >   workqueue: drain_vmap_area_work hogged CPU for >10000us
> > 
> > Move the top-level drain work to a dedicated WQ_UNBOUND
> > workqueue so the scheduler can run this background work
> > on any available CPU, improving responsiveness. Use the
> > WQ_MEM_RECLAIM to ensure forward progress under memory
> > pressure.
> >
> If the dedicated worker will run for 4ms on CPU2 before the tick irq kicks it
> off cpu, the system event worker on CPU2 has to wait at least for 4ms to handle
> 200 events for example in 1ms, the net effect is the same as the current scenario
> where 200 events wait for the drain_vmap_area_work to complete on CPU1.
>
It is scheduling decision. We do not want to tune any prio here.

> 
> Different workers does not help to dramatically decrement the micro seconds
> the drain_vmap_area_work takes.
The problem of current approach consists from at least two problems:

- doing progress under memory pressure;
- do not schedule all workers on current CPU and let schedule to find
  the most attractive CPU from its point of view. For example: less busy
  RQ, less energy consuming CPU and so on

--
Uladzislau Rezki

