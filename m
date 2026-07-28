Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D947AC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28EB6B00A4; Tue, 28 Jul 2026 08:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C006C6B00A7; Tue, 28 Jul 2026 08:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B177F6B00AA; Tue, 28 Jul 2026 08:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 861636B00A4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:27:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A2071603BF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:27:30 +0000 (UTC)
X-FDA: 85038111060.10.2557438
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5FA4160003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:27:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf08.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785241648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLxRpuVlHCUSgMMc8lLQf90Lr8UUBDUWYwUCLDECzU8=;
	b=O9jJ9rLjl+m0ak6sB7xsbyPjAULz5JiQROHrRAs05SbJ1qLM3N1NqBPRqDQTIRZ0mWgPN0
	hFjmlma9P0V+r0M+LBbrEIT4+lGzlt+Cl7yi3vAuVcXfDzG7WPMcOIdUwampjFqwTxcRqJ
	YI5/GhRvHetMfo8on4fCbU02K8PyAiE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf08.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785241648;
	b=yJmNxru7LEIwAV4HxoZPkZG5Ar/gM/N9IHICHo7671/eFUl5/2y2P4p0JDKrjLqSCO7IKF
	CwDuNL2j3O7k4qY1LfjBuilixBvUXYb4QUYluN2BcgIQOJ3yLUYt40i8ckdEHkIFD98Z/I
	t9lJudu301MWLaoe3Uk6GuKYm/PdOIk=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4h8ZV13LQrzYpYtD;
	Tue, 28 Jul 2026 20:27:21 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 28 Jul
 2026 20:27:21 +0800
Received: from localhost.localdomain (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 28 Jul
 2026 20:27:19 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <baohua@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: Zicheng Wang <wangzicheng@honor.com>, <hannes@cmpxchg.org>,
	<david@kernel.org>, <mhocko@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>, <kasong@tencent.com>,
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>,
	<linux-kernel@vger.kernel.org>, <lyugaofei@xiaomi.com>,
	<stevensd@chromium.org>, <linkunli@honor.com>, <tao.wangtao@honor.com>,
	<zhangji1@honor.com>
Subject: Re: [RFC PATCH v2 4/5] mm: mglru: run aging when pages are severely imbalanced across gens
Date: Tue, 28 Jul 2026 20:27:19 +0800
Message-ID: <20260728122719.3688430-1-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAGsJ_4w17+jKWJKkq9fdEyu6CtBtMpH-Sb4XPwdDUfqSkpkQyw@mail.gmail.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA012-1.hihonor.com
 (10.77.199.132)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5FA4160003
X-Rspam-User: 
X-Stat-Signature: mn7351og4pkxhqjdihmw1wbn1biz8nju
X-HE-Tag: 1785241647-262432
X-HE-Meta: U2FsdGVkX1/fWEBnjEVo0toPlFdMgNSukHfkdHcW0+mN8MdFCgLTol2UzOsqPMzcd0G0NMMM13kRDM1f2F1nSLRI9CBUgqEQ/xsI27gJy9UD/92BBhI0OFyM31iGw7C5EJUNp/W2v+TufSQBk3N5vnUiHGUuydRQ0Z9pETAfF+U8+b7J2zdkO9Vq/9GR2qOz3trtBonXeAPDiPl/pGuHqdkgUOEsjqGmydOykEaQ3LxWkDJTFu4yd+jrcOk2QWlzpJFUFfudM/yETTbHDCaQHnXtynV22tltbnz5lZ/C7YSYqRyEgpdMZ4TBKsq5T0iOlxeOFjXmYgl0OgJauPwYbRYvIXB6huZmD2E3vfgyUa58GLjpwiSgozvpp5QrzCRh2XPp1+uQ/bebeo3PFiDyFO2wyoY0WlNEYpehleKpz4ZwRWzmhs3mQCmfyUyiQM7IGon28YFQgj/I9Y3EOU435cv2DAiKkUMoUU17P35+15Uf1CbhnLhd90HqORdDwXf6/2QhiL/LyAlieXtSkcaqA1jlCKqncCXFG23vXz8zFUu5RckIXpEGOCtSxFR/Bo5bWQuPLEEnKITyzx+52mVctNJrEBJNNBBw5d+sVaIExVCz8kQVqNiehvtMdQPMMsbYxO4olZSNHcVLnsTIRpwYU3fyqlFVobBQmL0Ucf+5mZs6QVJagRTzLP0go3S7STbVIQ55PcbpyA84KRRD708l9IozeeD4FQXlrItBuI9UPG8QtztHdqvjyimbhlFviHbpQI6njsg4rJNcFrFbIothEwqfTR5tjVpGrIGL1s6Iplj1LuITU+UAqzAtq9svve/Ay3GTmFwLgP8hSG7hZZ7gkCB4GgjjQiN7wXy8LPRuTnCRCJq2bYQbV+vUHjOTgdKfVdUlrrIHQKsF69IBdfrljqpeFDXk/TpqM6Ycqa7IXvuRf5umWyLLeDrgfsrmzXp8hd9UMxJbvh+x3I9UqBw
 iqdJ8feG
 DLz1NvsU/570RZghVGD5nLO+t55g/Npd/+Gg5n0Gs5xsUrqJqXWUAkbMSU+/cuIRl6Fgl5cAjuDEUQK7DJJZz53a5DKdG3IveqojA3MmIXUC6Dp9npIKN4uwJcvuEVRTvMtiEISeaGLd5H7guG+raYHg0IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

> The original code is a bit odd, as it compares a single young
> generation and a single old generation against the total, rather than
> comparing all young generations with all old generations.
>
> By comparing all young generations against all old generations, we no
> longer depend on the exact value of MIN_NR_GENS. The idea is to
> emulate inactive_is_low().

Makes sense, the inactive_is_low() framing fits.

One gap: inactive_is_low()'s ratio is dynamic calculated. 
int_sqrt(10*1024) = 101 (ages only when inactive drops below ~1%),
while patch 4/5's fixed 4 ages once old falls under 20% of young.
It seems there will be considerable cost on big memcgs, or should
the ratio scale with size?

Looking forward to the perf data.

Thanks,
Zicheng

