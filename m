Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7305AC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F8F6B0088; Wed, 23 Sep 2026 11:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632886B008A; Wed, 23 Sep 2026 11:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546DF6B008C; Wed, 23 Sep 2026 11:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31D186B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:20:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A78CB1A0535
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:20:34 +0000 (UTC)
X-FDA: 85245388788.12.CAC8B14
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id A5BDEA000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:20:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mPCFAHmZ;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790176833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2ri7f9dqehfec0Yybwmyko2e6UZRcsiGyPJi3YOYow=;
	b=TuEb1CjLHpk2lRywwJT4PlN3+pEcrzvuFYs9rSN23ORI3+rkZgdM4qJfS1xeczNwdp4i+B
	2Liuo5IHHdegldVLFnENYwLNCyJ6226YB5/1r/fA5NxpMPEDnsdYx90tTLaIdJzGQhxJfT
	2DWVaLJNnOM4M12Iykxkq7p7c9/1u+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790176833;
	b=fiV7ynqDNnP6ZQ9AdSDy77JEfMDUfixN+7MpxC6Edx8Y9JzQ3XlOK0Tfxp3RnpPyzLme0o
	oLQBm2y2/P43/xAV1MXBbK5ziaRdS+4iMCiz8BL90hjZGm5tK1j1LH2rZ2dEori8uHQv2U
	kth2Am3iafUJTmxyINtm7JVD9l7F9dU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mPCFAHmZ;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 170D01516;
	Wed, 23 Sep 2026 08:20:28 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E79ED3F86F;
	Wed, 23 Sep 2026 08:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790176831; bh=plzh3izsHXGgmShwIXotE4fldBJ7kvc6B3ReIpURaYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mPCFAHmZzgwdrxNMzuHRfXYirzpSiYJQcS8aJ301s2u2mfEr1wZy19i1cUSGKQSw3
	 42zIFSwpkZEZJ2rnyqPudLRvMa8F5eo/Lct8ZJyZ8S+TqCfHuTTqNWS5T2ATQDiQQ5
	 Dtb9iS2rPYhJlArINvaQ79bDm/LAssiqGw4sfcPg=
Date: Wed, 23 Sep 2026 16:20:26 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	kas@kernel.org, ljs@kernel.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH] kselftest: mm: use helper to identify anon_ops in
 khugepaged test
Message-ID: <arPuOvSlZr_uheSL@e129823.arm.com>
References: <20260923110133.429745-1-yeoreum.yun@arm.com>
 <0241581e-3823-43ec-9c6d-2346433f8f87@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0241581e-3823-43ec-9c6d-2346433f8f87@kernel.org>
X-Rspam-User: 
X-Stat-Signature: djk4aa8x8zr7rzfza9wpxmtwpwxmuh9c
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A5BDEA000A
X-HE-Tag: 1790176832-103563
X-HE-Meta: U2FsdGVkX18NPal67Qns1AyEifsZzj1+bHG4Ct2A2BoEUfvpxq6ACVkVIKDp9ONgYlTVGjCJqHE8IVSZvRsyhOtok+CS63Ch2as5eV7he39Z/eGEjm1BkEgURU1NXcXlQ2xvrgvouGl2wteYbwKezqbeRpnwDTXGieyuxQIIj0/E0c2wBpzvzn6KqmYzOdV0oT+GBpElvPmOrtyF8a+HjzUTQGUrTMDuRhw0yYtx3WY9amLZ1/GV0B9LlxqHj8T9tnOF7mhSqk1tzCQFcltnJvUy76Hejpws9WIjr89UtQL88n//AGYDJZrCXtPy7OdgjEolvYXv/xiCTaucAcXUXXwRKJRCnXeaTI5AqlFyznqSg2X0RYsoZZfKh2uFTzOKdqyNT6Rwi9dNIqlpTEYWb3F+bNzYQmfUhXwq/VH049R8U4CLwZ7gl6/2coyrbr3v+iwZBrQLeW2cNpumelir8J7uybwcC21yZW+YfTn/n3uBhGLdcfjHXZ8XJwIE3UatoU4SAtz7js7tITo2lZNqHRIh8d9l8Tx4hpUBZdvhPXqmjzh5p/aZd6Yhw3KHUHd49IfrUFSbyVrLc/z23x9U28aHEhGEd9ZNMYz6zxuWl9Lk0LVrSuP79eoIaWatfl97szsiOcI/hujZ1gw52B6J3wAEmdHaHHmowHS2qV8uzy4fIlr7OEZXuEmBtS9UHxzlZCTGZgEJHtVJki+RN0FpKMOldwk23No0VLfCl2b1HvEXnReJ37x7oMZ91pKGxtff3+aMSyThErgdZ2OvzRjxhE+39sUTjdh++1Mf/kppWQavnEaiYu9ftQDmv38eWLCfCRN4H/3QUx9fyzeEQW6yh6xmWwcRsT36p5WRujbY4c8mn5eAguhNwDB3EcdXMhkOqdF4eddL1Cmj1DvfcCOJmA6UiRuMdnU3R9aHelp0dlZXF35yKDjf7ZIXUNds3kRiAtafgHUAqPsnn9GWsNM
 Fjw1GmUX
 Aqx/2qWsc5VGhs2gS8jEKpSL31519GNvj5G8qy/V5F8nX6GGSfiU1Q8PJINdk+fRBFam5rbzTWLSLr48OBRQ9iY2SIDbm1Fg2UQv54TbDUZ2ydkSajWVr9lgRpXADn9GITaAAfbNidNBOb1cEB5SS3sXc1rvLWhNl+JR/aep/GzWmLf3zdj7eEOhmuxq7a4HX6kp7HUAPYlED4JY9mYrcF0+b/cM1ow/q8ILID20i9c3N2p97qNB3PlLbBA47nw/GBD5Tp5mMHXu6afmOyO97oEqHrMt977YgfUv5xUSXfJXjEI+AlRa+RrFNUOU/aaZnaehI592NdGKq2GCgF8beqND/xebIp0NGOCPXqEli5hcW+t4Sezm7h+spBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:54:48PM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 13:01, Yeoreum Yun wrote:
> > Instead of comparing mem_ops->name to determine whether mem_ops is
> > anon_ops, use the is_anon() helper.
> > 
> > Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> > NOTE:
> >   This patch is based on mm/mm-unstable.
> > ---
> >  tools/testing/selftests/mm/khugepaged.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index bdc0c7c117d9..b0cb02bf1a73 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -618,7 +618,7 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
> >  		usleep(TICK);
> >  	}
> >  
> > -	if (!strncmp(ops->name, "anon", 4))
> > +	if (is_anon(ops))
> >  		madvise(p, len, MADV_NOHUGEPAGE);
> >  
> >  	return timeout == -1;
> 
> This should be squashed in the other patch under review.

Okay. I'll squash with v3.

-- 
Sincerely,
Yeoreum Yun

