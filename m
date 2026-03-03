Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF58EDEBEC
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219796B0096; Tue,  3 Mar 2026 14:38:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB0C6B0098; Tue,  3 Mar 2026 14:38:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A616B0099; Tue,  3 Mar 2026 14:38:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 029C66B0096
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:38:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 902861B7372
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:37:59 +0000 (UTC)
X-FDA: 84505762278.06.68D0BBF
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id C311814000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:37:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20230601.gappssmtp.com header.s=20230601 header.b=SE9Su5+T
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772566677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLA6/lNbnNrbFzoCMsv7/3TnmIMI00PpH+C/qr7USIU=;
	b=NT00DOWVT8jVISWBkmPBDglX/lnyHCST9/rqRZKdZA+07tqhK+w1R/NQOeCEnrh5dntsVw
	1QrnKRnl6ZcktJKu+h8MqQp9DGtWcxKHV0/E0+WTHvYqRjtfW96NRsWg5UJ0QaeVFMrHf8
	3poYcT1LjfNZhxd3RqFpFTpCwEWPSS8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772566677; a=rsa-sha256;
	cv=none;
	b=jkykcErVm6K5jnyvu/CXIhTHQ7+R+JgibBx8GCwSc9AuFf4TgjqmIPTaLqt1yLzSec5H+2
	ALZdL65dNPoXGQ6mnUNg2Qa7XOBN5SlSnGs6lbHREQNKYnDs9PlNMvbpPwlCCZwVeD9+0T
	cl416DvySegL045tRM6oMPndaA6u2dY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20230601.gappssmtp.com header.s=20230601 header.b=SE9Su5+T;
	spf=none (imf23.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.42) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4398f8e2837so5185054f8f.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20230601.gappssmtp.com; s=20230601; t=1772566676; x=1773171476; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yLA6/lNbnNrbFzoCMsv7/3TnmIMI00PpH+C/qr7USIU=;
        b=SE9Su5+T+8BB5QYK84FUGY+Q5GtEo0Stix2MtdVCK1JNkiPdIvpXfe1R9SMqHeyRW1
         wqkU2y3CgsQQqX6Hc9cjpnlyhZ+yqmQZ+8JUfFtcaOLAg7fRnt0IgVjkcxFbnD3NxeBa
         gHJ5UtSdKixtT2Lt0GLpVNmffl1AlY84/6AOd3vj+4znqIyT5TBBWuVbsNtMbdfl6+GP
         4MN1CRKRMpv9ax3jPelqgHKU874bQ/8oF5kCjsmAt46+ZuZaQB6WQ/huwnzy5GkaoIhd
         22IukSv5BCrps86puHhZubJ5NFBCamfiw3LBOqQXqZ757fYVPsC57VZmsazSBWjJ3AXr
         vB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566676; x=1773171476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yLA6/lNbnNrbFzoCMsv7/3TnmIMI00PpH+C/qr7USIU=;
        b=aNw53Y4BMndJcXmzgxNgP5wHYlH7AegarROK56iBxI1FWbqD9ziIjEObyF04rvcqdo
         xOmescNhhqoswmo99w6YMlHff0yNNhMdcPv0pBmCVIZ5ItBEhXJpubqHujPzTsbIx0xk
         ty9lAoF48NGn4++wa1arVdaSK6IrC4pcil8ysxEt9k1X211Ep45yKa33rA+KOuxirnU9
         IE+o9z1J25O+9bO4lFjpP64PBxqOEpdu3kUdthKdKTDq/KagFusGBjeeRkZM49vB7Ytm
         EIGEC6PLLm3HxSPxeIHpcR+UdlMW5jCcH2gdrUnR/KxPiF016lrGRTt0QWp41zD2WYg8
         7rHA==
X-Forwarded-Encrypted: i=1; AJvYcCX7e5VZATbaSawL9WA7Ty1Km3ckY+XsPTJmMLHt8um183ohxTMPTaW3jJxjyWZ9R1LBI6erTUMZHg==@kvack.org
X-Gm-Message-State: AOJu0YxbQPiOe88U7bI5ihuRU8gfpiBHWYBhka1FSq1jyYHS0kiP+mFB
	tFhA7+fuSa10e+V2pVYb1XnCIpN2HCEqqgpK276MVKbzbgM8DApc2U4cH9y0Y+Ih/oc=
X-Gm-Gg: ATEYQzy55ziwmcwWFSL3kRsBi3op09YD9cvJBGZ4Igksz09EFLZEJPkoBFtCa/XBMQO
	27f4LOSLh2m4YGM7aYgbofwergFcUoRwlt93kV1Qds/cU6F4cIvLt2clZF4SzJ3d3CZHA29pyui
	8KvOpYfmgzo3Jp9hHgliV83mzfN38PlrCN8P1U0utO57v+LT7HKY2Tsz3zMv5M/2E8m1EqvuBT/
	Jr0VuDJGRzKahC2Zx/pPBOdgxHSTCVI7EMtHlwHWSIqQaMhdue5DQ5vE3ioO9TweVd3wf5QHLtV
	BWIrZMI3SUn6ed0YuweOWacm3MM/LP06Z8IBuqw/nid69ENWIWYYhxIgRfygv+xPsEYACkdutOp
	pvEkzNtjmzsjVEKp4vxJ/d+2q+D9coLovGYQNXPYgUues+kay53xKvmgYEeMMX0TUCLfx5vq8bx
	hdwdbvJVo=
X-Received: by 2002:a5d:4b48:0:b0:439:c1b7:890d with SMTP id ffacd0b85a97d-439c1b7933dmr3930809f8f.26.1772566675967;
        Tue, 03 Mar 2026 11:37:55 -0800 (PST)
Received: from localhost ([2a09:bac1:2880:f0::3df:3d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ba2a5970sm13526574f8f.33.2026.03.03.11.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:37:55 -0800 (PST)
Date: Tue, 3 Mar 2026 19:37:54 +0000
From: Matt Fleming <matt@readmodwrite.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>, roman.gushchin@linux.dev
Subject: Re: [RFC PATCH 0/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
Message-ID: <mmlwwn5dgwzcg6svb7t6torq4py663fgqceea2t4y4ktiep2ch@qm2zw2k5njoh>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
 <aab0AFAgAzBi4jO6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab0AFAgAzBi4jO6@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C311814000C
X-Stat-Signature: mar6az9wiejxikfo1dicy4x4ps6r55nh
X-HE-Tag: 1772566677-190692
X-HE-Meta: U2FsdGVkX19w/Q0tgIj/ERREvItsVrakx44vVof3PweG262oQTKeeQGgwWZP0X7puLs/qYjrptigrzpGXZNx6faiAYjJbKP8JJC9p/vxSnXK7VyE2RAec5jtYJffatyPthIwQxQ8amn2zqjd1njQxzZlYLSlrOEVG0ipaNeLmghDSRZl32mcfcv6yXBX3HF4twicqyV0uGgvL038cjI5PaXSkTR1nW/UBWD2c4ML19ExeIRcirBBmU/UAvlYhn5DUNaRZMZkan7k75yZFsAgP55oTkpvzxd2EnFn00W8F4JIsSiBdxV5kYQ5KmkhTfl0wRS9//HtK9dZZclVUVqyu0ig3BY0mx+n+OGDnFPmWd8Hv2qau4oHhQzyySGECI0T/lp9Lmo489NLFcWEL9SwVJxTcRC4O0mBV9HNFQyhcZzqAe3PlNE1ZGhl8l02k1ETA1UTCyrrMLso/4MthwwGe5nC5jtFPAYZgFhdUCx9iFXWJq2nLQ4ymUP+sAqpF/CDgNYXvpBPe/q5hQoha6rNYmWur8DLrvDFICK+Rk06uOqy7iqUj3HS6HuQUcBCFg4lFgYu79wjrwHBGMTFR4mjv2xegHDsB+DDQqpg62dsPYwHhCaAhsJiZIFQz9Z1TLZ77lVlHVg7frXlOPq/FDfx7872T+aOeI3PFsrNjDz8btq7xpkGaZPUAiCAb4rO0ndpmI908fut4tMFfqsQ0ZQGOeHVAZT5G+ePwHvJGcYPpkudQeQXxfh2A98iFEFBdTY6K2bve+WTvm4UWjRzjFkbdeDeWkabhnc1TFm/6KgqBR732Q3maaNVlMPkdZi5d97f2na9rGQ2hdQepJ/mSqRY1Po99JhTTgvRNAAcNwHU+RXh+UBi0gZQl2cGIuBRnC131mI6MYv1HAaR/g8T9+2cliSkb9acT+vnM0I2lSfnoHQAjTHb6h4C2BwrgxOGHZ75Cii7vWHNqwNLfC9LQU/
 BL0Qjzo7
 ApKr+75JvH19+0Sf8RivGywtYWjgHr0uoUUozoojhIyeXr34Qway7Vrf/hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 06:59:04AM -0800, Shakeel Butt wrote:
> Hi Matt,
> 
> Thanks for the report and one request I have is to avoid cover letter for a
> single patch to avoid partitioning the discussion.
 
Noted.

> Have you tried zswap and if you see similar issues with zswap?
 
Yes, we've started experimenting with zswap but that's still in
progress.

> Over the time we (kernel MM community) have implicitly decided to keep the
> kernel oom-killer very conservative as adding more heuristics in the reclaim/oom
> path makes the kernel more unreliable and punt the aggressiveness of oom-killing
> to the userspace as a policy. All major Linux deployments have started using
> userspace oom-killers like systemd-oomd, Android's LMKD, fb-oomd or some
> internal alternatives. That provides more flexibility to define the
> aggressiveness of oom-killing based on your business needs.
> 
> Though userspace oom-killers are prone to reliability issues (oom-killer getting
> stuck in reclaim or not getting enough CPU), so we (Roman) are working on adding
> support for BPF based oom-killer where wen think we can do oom policies more
> reliably.
> 
> Anyways, I am wondering if you have tried systemd-oomd or some userspace
> alternative. If you are interested in BPF oom-killer, we can help with that as
> well.

oomd is also being discussed but so far we haven't experimented with it
yet.

What's the status of BPF oom-killer: is this the latest?

  https://lore.kernel.org/all/20260127024421.494929-1-roman.gushchin@linux.dev/

Thanks,
Matt

