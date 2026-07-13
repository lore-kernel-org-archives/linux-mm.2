Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB367C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3426B00B3; Mon, 13 Jul 2026 12:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B744D6B00B5; Mon, 13 Jul 2026 12:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66326B00B6; Mon, 13 Jul 2026 12:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5636B00B3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:15:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56EFB1C8542
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:57:41 +0000 (UTC)
X-FDA: 84984208722.21.5897BCE
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id BAE1C4000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:57:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aw+FqJ4lXkew0MQerRhojuraKT53GNBk/AWFrFyNNwM=;
	b=IDUfxePHdHKK/uNNhT+PZQgcLFPN6yBOWuw8xBbq/iFlyPMQHVdS/JpCS/DsXlJiFEvZ1y
	V0UA08zLYKIBYOoFCEnHQpAks7ucBDmqR+ZTUJcT9UjTOkSXWgZIGNiYnoC3CGWKQSDFW+
	5b4YQ47CzjkLpHKzcEFCjjjYygX4bvQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958259;
	b=usp10vhozrw7/4yf7su/Wf8atGtTsTEUWPMNX/joTcze/VUUKCzpVx6XeqassnfcmGFI8u
	wjMa8J5K6DB+PpbJun98BF8xTqbBBelzopi6jDmmzDaGcD9nwryBhQsN4PwszyPmCGf09Q
	Yo3bFWeBwYwF16u/wlz5MGGlqYrn7x4=
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.52 with ESMTP; 14 Jul 2026 00:57:36 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 14 Jul 2026 00:57:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 14 Jul 2026 00:57:36 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com,
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com,
	baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
X-Rspamd-Queue-Id: BAE1C4000A
X-Stat-Signature: nm9dfae4fqmff9ibib36xeeohzgn5dfg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783958258-469121
X-HE-Meta: U2FsdGVkX19luJ1tMf8mR96aO3MttRfLO+b43+hyGEbwWc4gSqk/jqNGMdYwZPqbHDB2N4OT/CVOHaltnyxz10jwiJv/EGVMbKqs6tCx6d/37N7kT55urM/9HuTokPD8VuY9SutGgCO78s+HTJzlUzd7UyLcuf7PRjr1MsKd4tvbMh8sqzx3vR0BKFjVD6wXuAgpzk9ZhDcLu+usICCGSo52DkXW1HjvR0hYPNwaOF0RXf4fsO2qq1TsVMn5uTmCEPYDD42KrSHOvrsVfgUIOsO5AwNvvpDLZqYAGH7TuTGo+y7ToRzbhhj+3xUSzgan3kq44jf3k4LHM1ptSwRh5zQasGMyfuAxqOpS3fF50pnt4dRlDigFCqdA0qWs6F6Zk5fOr9z1WwnuJ61vFw27FI9Z/WArGQ9dAfCR1sD33F0/M0sRCTsy0naYET5tOm97mYdS/uDGSXPnPYR3cSTulyENC/12BdIPl/xx9D7UUNueoEaybDTV0D7m0PAWCVecKgPHA6Fjuemnl8RP6q3XpjO0S+y8Z/Fc6COUA1KdS8Ff2hT53rydFMdbOsFY0PjQPr6hiJodO69PKEnimhpzwHOhlrFE/9xVetMMORHgCvCWzQ/tzg00XaAY+bINKvPwnM8Z1aAr7X6FrGOR0VuCU84AqHzveU9i8GhCtCpvA/UBa7Jk2xY3FE2D7577ktJtloHFVUlSaCKQCeFqRIHQtuf/RsbzshVUvNFDJ5ufNpxX1+MpECsGeVpSg3cReD1TME4FGRrwVuBqOFD/cjhJ4twAAOL+M+I8H+iatqG2KlucgLOCSstIX+w+JNDVI30HvLcX6fVCQVfjX0jeUr7rk9e/lG14SUgeqnMqfIU+XiIGdsz3scVl/sx6S/vFiW/jyV2cJTvm3bL9D+4Eq76Qx1nOpAKEiinCV6suHgB+Oya/IQF6qKmVT5zCSL+g8teV7ouo/Xjmhc3XLleb3np
 xZCE+AFW
 hrnOiGsEdwXBk6kFjdKBmOUfp7e/siwI+U4VaWQbi5cIC8EipfPKVxSLLGcyR0UzniGhb98NDbWycNedXUJANQUUhzRRAIx1GstGF+XXiowlXsjRDqN/bKEddMFJ/eVdGDeBlNOaXvvlQE86CwV8oOZPVSRt77BIn8KAv7Sp3kmp/BoZwHkakmR6LGTUnxstweaBIgzgKiovJ3V+sjr4jJ+DFW+HAAhAYL44y0QdqiIhHxp3PRTIRYrUARrL7i8TTLyF8RL/AQy1MXlEDzWBVX/fw5605fRPemOAo8LLtkqVNavY5wCQ1efVYnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 08:50:36AM -0700, Yosry Ahmed wrote:
> On Sun, Jul 12, 2026 at 7:57 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > This is the v10 series of the swap tier patchset.
> >
> > v10 folds in the Sashiko review fixes for the selftests added in v9 and
> > rebases onto the current mm-new. There are no functional changes to the
> > core swap or memcg code since v9; see the changelog for details.
> >
> > For context, the bulk of the series is unchanged since v8, with great thanks
> > to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped it.
> > The main change in v8 was the interface change to use memory.swap.tiers.max
> > with '0' (disable) and 'max' (enable) values. This mechanism was suggested
> > by Shakeel and Yosry.
> >
> > This change allows for future extensions to control swap between tiers and
> > aligns better with existing memcg interfaces. It is confined to patch #3's
> > user-facing interface; internally, patch #3 still uses the existing mask
> > processing method, which is implementation-efficient.
> >
> > We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for their
> > valuable feedback.
> >
> > Here is a brief summary of our tentative conclusions. Please correct me
> > if anything is misrepresented (details in references):
> >
> > * Zswap tiering [2]:
> >   Zswap can itself be a tier (typically the fastest one). But, until vswap lands,
> >   zswap cannot be the only allowed tier,
> >   since it still needs a physical device for allocation;
> >   that restriction can be lifted once vswap is supported.
> 
> Does this series support zswap being a tier? I cannot find any mention
> of zswap in the patches.

Hello Yosry!

This series does not cover zswap as a tier yet.

My plan is to land the swap tier infrastructure together with the
first use case (cgroup-based swap control) first, and then follow
up with zswap tier support in a subsequent series, continuing the
discussions we've had above. 
(I mentioned on cover letter, right above the overview section)

Does that approach sound reasonable to you?

