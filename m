Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC22C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0314E6B0092; Tue, 21 Jul 2026 08:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24726B0093; Tue, 21 Jul 2026 08:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED046B0095; Tue, 21 Jul 2026 08:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9F1D6B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:32:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2350B4012D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:32:59 +0000 (UTC)
X-FDA: 85012723278.14.06C2912
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2C40A40003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:32:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Tj+IA0pt;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784637177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acH6Td5yB7N9/O8D4hpOWjlxCJMO7Nckq/Nc+n/FZAc=;
	b=SEvyw4QFpcmev9M6ztojp7X8gGQHdaTIAT5T7e8c9A2T5PvnU3HoQGgMjBDNPYxh0Aeu4L
	RbclD27coXWPszRiIAltdJm0auW8X0wiPOR9PakVbszmHY0kkGF7As32cfdO1Gm6d1nUkf
	lKhf7ZvCXunoFJGAAKru3+BXCSB44JU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784637177;
	b=RLCGR4RMDcbTZcRBIFKPwr3tQbkWd7wrrm5E2hL1QXMU+wTAfpX82mHdrYl1s8cP9i95d8
	uwjsx7TI4QuYFmfS3cYGb2XUUagZT9+hXS0O80jmPLCAopJAR9JnGiCgYhqMMeIH7XnCtr
	r3jBPaH1VQjRiAOY4gAIxsJ3oB3JjZg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Tj+IA0pt;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso14175655e9.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784637176; x=1785241976; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=acH6Td5yB7N9/O8D4hpOWjlxCJMO7Nckq/Nc+n/FZAc=;
        b=Tj+IA0pt4Xry1ls9sVoff+8AhZ72+Ko2naM8r3q3TyW5bQSIpILU6UVaKB+nRAZQM0
         y2K54DoscESnQjqm7sMknxxkTJSB8KPcdtpdcLU0L+NzuPL5BWalx+IeHE3owdTeF5fV
         EaXfzj3yTU2FgvYergtTYIY5JbG7plu85W68TTqO7nqgvLmBsxsAF7S8CstYNyX3PBo1
         zbHH0WKvfTVjYEu9j/0SrHuK3URoPH9ngkte/6j9l2FqK5HirJ6NYfXLJmt0iDE/5DMC
         KLMTIhzl/7ghUqqXIIV2NW+/KXe1u0xwWGA/rqPOmXkpY1IxwPczCENhW92Kv+Fjq5I9
         8gOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784637176; x=1785241976;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=acH6Td5yB7N9/O8D4hpOWjlxCJMO7Nckq/Nc+n/FZAc=;
        b=flhcJGOv/4SQxX18z1opeflYdJAqVD3cvMLPlc4dtiNznKaspZpeYddHlKWi/g6Pzn
         KidKslDDCTba8yEE3/iwZGNILiwV3MK7QfmIdCHYbN65KLM/7kfUEvmzEUi+kBxTtAAU
         2gVDvWA5FTc3qMEbcTmguEoSCbPHhatzZmQVoeKcbKJmMryBViyzdut/+T99KXpCK727
         q5AyHKhUTVIdL1Unyc4f1YfJZWG97VM+xEIAZIrNr2uLt6Aq6jHGqPn+8QBmWAqOIC+a
         cC4iqtCBMqYb6dVVcyA1lq6fVQ1aPwkh3cLx7jXvrF/XNKbJID8c+b7ENfJs75ipQw7S
         5MPg==
X-Forwarded-Encrypted: i=1; AHgh+RpracTcyesWyqeYrfnIY1c3ygfLofRxqXNXi+edj93dJvCCbLhPimS8TEJviJbgdJ0hsG7xoqV0/g==@kvack.org
X-Gm-Message-State: AOJu0YwiYhMpZ1AuRmClzhmLbEUDJZMx1O0a1Z32DSxmtw3dbGh5JwgP
	7ND6OHK2tmf8Yibi5pRQm0wvjRarhIIiGpEmrqMhP9HuGt4Edn9I1wC/aRcwW5BmwlE=
X-Gm-Gg: AfdE7cl8THwHQJHolA0k5SvuKm27b1z4dFMjEt9xAZ+HxkyrBIIr69jTsEGeEz7JYHx
	D7AXKQ4qp8xXG5uelq08uAMYUURhwPPVwMGWx38I78di3F0A1PD4drvb6aD/q1naKUa3yCfGiKu
	3z8nL9eX4/GsLZYP+D2z/XLPUk0LMpQfLJy9OmAsU4wwVMkTgsGCbMabNADXY6vV+EB1XqcsVXv
	yQ8DWRgeSbenEMP+qXTTrIPS8/wNYDPD6FYlfSeAeHl29dhuv0AA4PYmJWOElaEo1vzHV+GdgOM
	tdssXaAfpldLafWVdQOnxfegSRNUQI5GexK2KBIou/Qr/aEk7VGm9CrSK5hmOQrnwaYzIuv3Ch5
	JAxu22sFKaEkuVxIAxy0ZI1jDb5Rz+BHuhZ8WcsRLDZlyeJ2pGA7e1b5HglxZNkNoIF3ZzLixtq
	DvH5/gGhsISd7Z
X-Received: by 2002:a05:600c:49aa:b0:495:5943:b76c with SMTP id 5b1f17b1804b1-4955943b9dfmr82668845e9.34.1784637175841;
        Tue, 21 Jul 2026 05:32:55 -0700 (PDT)
Received: from localhost (109-81-80-79.rct.o2.cz. [109.81.80.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495653c8760sm60745635e9.14.2026.07.21.05.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 05:32:55 -0700 (PDT)
Date: Tue, 21 Jul 2026 14:32:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Chang <richardycc@google.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <al9m9s5JpOO3S7jX@tiehlicka>
References: <CALC_0q8rz7U-8x+syTFcWS6Nihxvzd00ruzOThb90P+cDqi=TA@mail.gmail.com>
 <20260720044103.905191-1-richardycc@google.com>
 <20260719222306.540829de219e12e21396d260@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260719222306.540829de219e12e21396d260@linux-foundation.org>
X-Stat-Signature: qayouw79jnmstosuf6rnk7fc1ss8b96x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C40A40003
X-HE-Tag: 1784637176-930219
X-HE-Meta: U2FsdGVkX18wJPaO7rj3XenkCE1jbKddr6o6BoBc3v4hKHQeBCcirI64bB1N98aTPDtxeQpOB0WWaoMTMpwF8ezny5bDQqrfWxwCKk6YldO0RkjuqpCoNAzcjohNL/w3molRGdFRMVcRApqYa9EMHMszFQZbchtu/USYhCGowbCj6VSsSrKloevHb44ZDzftexMzCq+PSaUfcntGcFAQN8oqsDc6P2GJXuoeXT2PwAotL43mZL9J71iVCc+0Ov1CsQk4QB+AEC7+H4tmTbg1ZopztZWB1N0/lLFJ/cZVm1nQYPdQYgvAQVQ3OQYXFrdTOprbMhNE0r1mteDNocmXFqLckh6+nyFUjQRm30Aeua+VrNKSwbHogG3HxZRQ6Sfrr+dNYfTCAg7PyRn64o0GfPLPe/WFd6/at2DsTN+M+/ZfcytdNUjMX5r73ojsRDo9r9wsSZM5NaNppIYUsfVCW76QWZxSjUQYOMd0cBQpFTfQPRhi2+Yes38KA55Edx1RoXCnLK8hGfV9ivSRTBMRusfuWyQH12p1ReiTuGaS+Duwd2P8l2L4VU0OLshizsv8Ts2CmnOe64u2uh6uwSQ8EkBzuOW/bo1suhTv+Wzo52qVOmM77k9Bg+3Mum59NUZ7IeOJSs595M8JC/gqVeQd5PaZLRStMz//0UNuas4BGwqRRUeqZcCVFVKUidA/Gps7R0qa4MmeuzMRTJOa5bbQsbICeKvTu2CX8CkVvt5quJK6v2rop0HzzpCdwnJbPEgW2Ma091dYcY5ddLFpHrhbG2E60q1V4WtZhCnInqxiAcv69ERlrnfWOiguyIU5F2DAVekFagQ/jJW0DdMUyUM3zV0Xu0TGtlyBsB3wNE2A8Cu5k6Et8gmcvH3fgDY3mGMsfyDTu3qld1C2MX1/6RMDVRUxll5FDCZg5x7pAE6OCQpTGnaYt3hY1g8kC/hO7Q5qaEac+iB+gFgpxieqtoZ
 EuoP2oDh
 kanJX1bIzyU5/GIiWvXEgOBc3JpH29Uwrg7nK1taaX5mvUaECBDZp5x+Y7houSRoICrwS6+N8gvciDT+9IZpYELJRYrlcMNvVkrUNfkOn6XSa1pTFVscgZwmm9IHI0HMZ229OFwl+aqbjNXcx80FPeze7yopgJXd45gnc4ahwPjwU9uqA6FrsqjSEQWQHLIlpLe50wWS0w4pYmnek0URQSWSzErnmYGwtPWf9qJc7AlRdwiuSquRnNQxNU4Y9U1YiimizU5p8awgPrytWVvrJotDXycSQsnYtccyShoMqwyCjb1kgC3pyETSB8qhn8LS6gGU8F5v7hlYdC+NPbl2brUmZiMiKn4319SwrwzGX+spGjTBZZpjYdkUt+v+RrPD3COlwIykrUA+7D9E7t806q2Pc4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 19-07-26 22:23:06, Andrew Morton wrote:
> On Mon, 20 Jul 2026 04:41:03 +0000 Richard Chang <richardycc@google.com> wrote:
> 
> > Proactive reclaim (triggered via memory.reclaim or node sysfs) checks
> > for pending signals in its outer loop in user_proactive_reclaim().
> > However, the inner reclaim loops—specifically scanning cgroups in
> > shrink_many() and evicting/aging folios in try_to_shrink_lruvec()—can
> > run for a long time before returning to the outer loop, especially on
> > systems with many cgroups or large memory sizes.
> > 
> > During system suspend, the PM freezer attempts to freeze all tasks by
> > sending fake signals (setting TIF_SIGPENDING). Because the inner loops
> > do not check for pending signals, the proactive reclaim task can remain
> > stuck in kernel space for seconds, failing to enter the refrigerator in
> > a timely manner. This leads to suspend failures due to freeze timeouts,
> > a behavior observed on Android devices.
> > 
> > This latency issue is specific to proactive reclaim because of its
> > large, user-defined reclaim targets (could be gigabytes). Since commit
> > 287d5fedb377 ("mm: memcg: use larger batches for proactive reclaim"),
> > proactive reclaim uses larger decaying batch sizes (starting at 1/4 of
> > the remaining target) to maintain throughput. This keeps the task in
> > the inner reclaim loop for extended periods. In contrast, reactive
> > reclaim (global/memcg) uses small targets (SWAP_CLUSTER_MAX, typically
> > 32 pages), allowing it to return to the outer loop and check signals
> > frequently.
> 
> So 287d5fedb377 led to suspend failures on MGLRU-using kernels.
> 
> That's a regression which justifies a Fixes: and a cc:stable, don't
> people agree?

I believe this should have both Fixes: 287d5fedb377 and 94968384dde1.
-- 
Michal Hocko
SUSE Labs

