Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F086C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAC58E0012; Thu, 28 Aug 2025 05:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91EB8E0001; Thu, 28 Aug 2025 05:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8598E0012; Thu, 28 Aug 2025 05:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEEF8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:40:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E57713A54E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:40:15 +0000 (UTC)
X-FDA: 83825670390.09.7143242
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5BA05C0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:40:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JsoyvWQU;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756374013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H18ShQScvKRglRK2UXGYScgTs4Q/vE1IKwPk/BKJEEY=;
	b=tOchf/lkc6k2g4RlraHjhgIZoe7Z12VVeZFEV+5Oce0O43aROuzyUtrBgqNXAHH+B7+tjs
	1fMbfuS6/wWYKUZba1kYizvpczj5eIrjjmRyrPYRNobokA8BZu8CETagirCKU5DPAWWUMl
	SJXYa2xR/uiL/+Nmhy6KeN8ajf+xcSo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JsoyvWQU;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756374013; a=rsa-sha256;
	cv=none;
	b=vxrZ0ajqpbLr9mkgm1PAN443Sk6+RehwNlzEjNrlMd+Xy5NunvOUB/jVw1CrmTvjDkyuLL
	oN7zYk3DoOcsZ8jSdCPcEcrL5IIQZubM3LWryd8PVjDOYDFj3zrsOLkuxp2fxXu3xkUREJ
	s8c7bgHkXDdDH4Ya6kUFtNj9GVHbt/s=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3c7ba0f6983so501537f8f.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756374012; x=1756978812; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H18ShQScvKRglRK2UXGYScgTs4Q/vE1IKwPk/BKJEEY=;
        b=JsoyvWQUx+cdHGiTMCU9NyYnDiQErvF4e2b6dKCkUG7j2Ij7clpnWQlb1ns/urKxku
         cUVUk2R0plvjQg5eoIfb8evP/HuDj18ZlIS+0yq6+4OOFe89P4BOLx3ph3iwVnGQZ4PG
         /PzWHRrxq3/yBit4yFeV1bCOojs1W9TUy8ZyeqjRApls6saSwI/XIGu8Ez0G+fUheW9d
         hvJWKAippYskHQ9DQigMhGSJQvPVO+NcjdFz+Qg46EUBU1oNkRGiexbejzKtrAEsvK/+
         yR/3V8gdT9BFDvo4Ygh3eamK+Te2Wc8U0mtnuifBkB0bhj2MX9kVd1LH3vqP8NXkd+nb
         REAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756374012; x=1756978812;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H18ShQScvKRglRK2UXGYScgTs4Q/vE1IKwPk/BKJEEY=;
        b=G+MsWoueguVKFdRS+SXOFDqvkZBvdBWXEHiocxUCTcoqDkuzpTWP1jnbIh6RFsOXxD
         oZ5hzZlRc7+yizxNYbYiYaN2M+Kv4o2zwrXr5zH7GMQddyEweQ2lp3kg2bOBDWR/X8Ol
         z1MzlbIyDUGglthXANylrxv3iakNE/wD542nZPcu8Z/I/vb51WtxA0rFpkuH1A83wB/j
         l9pRxpYeXh1I45sYQNw08DaxV+HFP1KgaCWdIf0enh9Blw2UeV2aRj+2PXrwIWlbLsQo
         wKH4u5NXKcBA+3L6tBE051ZrlLjv74gHMeu3YnmoFFlWlqdUD4pKPpvaSvO+qaKf3iqO
         +FSg==
X-Forwarded-Encrypted: i=1; AJvYcCX+5sLgvnjcvJCowbqZ9ruxgLIRlGKQqREHjYYW4IabpaM8vqXLsP1taxNGFbJwP6AfgIMQ0HctBA==@kvack.org
X-Gm-Message-State: AOJu0Ywt26RnsxS609fQFCpGv6X9CcXu0dp/oXxZq9XtoDZpbM8JgYLO
	/0WUz+YeAx1Lcr65MkKPmzq6+jKFHRENy6nnV3CPhEdnwq2QCTLfa7fhSy1Phl8Zk3o=
X-Gm-Gg: ASbGncuas1dF5VJ4+tIeNsPLfTxHBE4A3lu8SIL42vGv0V+hUSbIUiuf31XGS2GGCJ5
	lbe0V32zlVzw84zoZ6kNARqQD9Vo8FTzffr8K/8C3y0ZfCZRPwAoAIgJcXcRmDxIheKggJgL1q8
	sX7byW4/dKQELanX7vrL29XkWjIkPmy+LN4t+6YmPIvQly13dCw4yALLAcU1EoN1arSa/ddGjda
	qFjI/8dziPK59hTvoT/Gle/4ZGHPQDj7wAq6U8LRu4n1XxyBzkhUc4P/4kpgzDhQcoJZHevusWv
	Jo0KnL0TiUJ7edqMxqpy5XKnoqj25o2Nj6Lok/eg7Ey1X4G2iJ++/YtCk+MwdqCENE6oirVfp6e
	O+W/cyET3UBHverJ9lnAPsTO0alx9BjJUgndtKQ2fIMaB1Q==
X-Google-Smtp-Source: AGHT+IFERGYy0Bvc1+pJyr9ZQR1l+DS4FjEWsD509R+lmrVqd/10evLfD/XL9tsL/EgOd/szw8gFNA==
X-Received: by 2002:a5d:64cc:0:b0:3b7:9d87:9808 with SMTP id ffacd0b85a97d-3cbb15ca448mr6762408f8f.15.1756374011627;
        Thu, 28 Aug 2025 02:40:11 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cce1724939sm6098245f8f.26.2025.08.28.02.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 02:40:11 -0700 (PDT)
Date: Thu, 28 Aug 2025 11:40:10 +0200
From: Michal Hocko <mhocko@suse.com>
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH RFC] mm: Use pr_warn_once() for min_free_kbytes warning
Message-ID: <aLAj-itGT9DD3SU3@tiehlicka>
References: <20250828030602.204332-1-tongweilin@linux.alibaba.com>
 <aK_7GKJ4BWjye4tZ@tiehlicka>
 <35e0a580-ae78-4485-b285-7f71f91e046d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35e0a580-ae78-4485-b285-7f71f91e046d@linux.alibaba.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BA05C0006
X-Stat-Signature: gu7m3ketusg3soso9r86u69t9jtejxqo
X-Rspam-User: 
X-HE-Tag: 1756374013-868248
X-HE-Meta: U2FsdGVkX1/Dtl4ks3773Fnej8lJXWS55krBsBvjI2BWbgw2xPt2K+ZSwzFdUP/M18JLG6i+QHPps9oBvUbMYIIitjFyfnEiCRLNS8h61SwJbMBUUOVp25qHxfQ8BISfy2sobNTkf+WEsHAPv1pjsCWfnAAzkLQ9BB/eCpmZDG/wmRcSIiSSeI+KYgkhuGDeqS/gZR9W8y3O58rfA2p2kqkeueLEypgvfOTYXie6eRU3Zfu1KUzBEPUw4+N7ZZPgbbao0sMLsDexqzm8iSa4Chh1cZ5fzHk5gUPBAi78WqNqACAiwPs7y4KqwxVhT4YFEYUNfaygZZsBczMWh4wmPaK9c3LaJa1JDNL0LCt7dHyYTvZE2qlyYfpDFHOr9uY1bWENHbT4oh+RUZbiNefaEmxIOgGDTxYnXTAHa1dwMUw2NaxIrrZ62bxAQDjT1kNxHAQ8JEtBLjfCmpveryXie1/elkjrVC9nZ+aRv+NfftGk6W9yILoDWtuCmgW5fEDPAe5D2j26dv264bb1y447kFgbh1E/JBuvTbXu9jQH7uJTOHhvhM6ecy+11cXnyOGfgPDZlG59ymUhkeA9WNfztJtDcUEHq/ZC2/ptPdNxUtoazkdYRllIM7gp41i4woYqhk5t0Zns4Zuxn8ADFDcC1Dk3yZEV/KCVwN8wLcJskH6xCy9eYOWSGADnrCM606lO+H/tdiP4ANKHBcDVpG0VIipoJorNALBEfCzz6+D62gknEDsJxD2FGUAW8njwXEFr/H7uW8z9Cu0OGzt7x+zCJ3K6b6o/ldfw9CLXl2Af8/AXjB3p5vBLcePGK4tlTHgaqjIYDQZ7Vi8nbA+O8wZo3+rzhvJ/9xJ/NJp5GLgkQSioyOH3j2xJHqlbDK1prrRyJs6RMcJekOvSUOPwo9s8BgXu6VPDbeVZPx9ZVMHZ2d4lotrrJ/iIyxPiLh/gFP590DRXMezTaMg3VQ/MmRw
 eizOfoQl
 jIDt3S1u6Cx7kzMqULiwrN6rl6glmzdoYlj4fcYIp7vEGnMfHxg/FfN3zpINWX0sWi8uoOhSYRdesWIVko+eEes5G2rFKDZ5s4EJQj5qPH6+0qRgWQjh71w7UP4mkGa//xkW9SyVwFdPBZ2Hw6OCzdE4hVOUgmuSLfrLhv5xeemkLRk9cC92ebOnO8gNIPjEb4L2BzFbNM1c0eebk+yqrcg+HsqjFrerytmd8swEmh3CtKPhtfEn2rLVF3ApI6DD7cUpcJVXDFZovzmzVqyC38nZQMcTbjm7VqYWe1BLg3RDscgABsmcJtZrq8Ujq8pWGhp/+kodVqsnq7hrYJ3whPUCoIQNVH14/YXLgUmTaFGmVvRuOn1gijrMLtYmU7BB1LRcH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 28-08-25 17:23:40, Weilin Tong wrote:
> 在 2025/8/28 14:45, Michal Hocko 写道:
> 
> > On Thu 28-08-25 11:06:02, Weilin Tong wrote:
> > > When min_free_kbytes is user-configured, increasing system memory via memory
> > > hotplug may trigger multiple recalculations of min_free_kbytes. This results
> > > in excessive warning messages flooding the kernel log if several memory blocks
> > > are added in a short period.
> > > 
> > > Sample dmesg output before optimization:
> > > ...
> > > [ 1303.897214] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1303.960498] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1303.970116] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1303.979709] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1303.989254] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1303.999122] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1304.008644] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1304.018537] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1304.028054] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > [ 1304.037615] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> > > ...
> > > 
> > > Replace pr_warn() with pr_warn_once() to ensure only one warning is printed,
> > > preventing large volumes of repeated log entries and improving log readability.
> > pr_warn_once seems too aggressive as we could miss useful events. On the
> > other hand I agree that repeating the same message for each memory block
> > onlining is not really helpful. Would it make sense to only pr_warn when
> > new_min_free_kbytes differs from the previous one we have warned for?
> Thanks for your feedback!
> 
> The dmesg output above comes from hotplugging a large amount of memory into
> ZONE_MOVABLE, where new_min_free_kbytes does not actually change, resulting
> in repeated warnings with identical messages.

Yes, this is clear from the changelog

> However, if memory is hotplugged into ZONE_NORMAL (such as pmem-type
> memory), new_min_free_kbytes changes on each operation, so we still get a
> large number of warnings—even though the value is different each time.

We can check whether the value has changed considerably.

> If the concern is missing useful warnings, pr_warn_ratelimited() would be an
> acceptable alternative, as it can reduce log spam without completely
> suppressing potentially important messages. However I still think that
> printing the warning once is sufficient to alert the user about the
> overridden configuration, especially since this is not a particularly
> critical warning.

The thing is that kernel log buffer can easily overflow and you can lose
those messages over time, especially for system with a large uptime -
which is far from uncommon.

I am not entirely enthusiastic about rate limiting because that is time
rather than even driven. Anyway, if you can make ratelimiting work for
your usecase, then no objection from me but I would rather make the
reporting more useful than hack around it.

-- 
Michal Hocko
SUSE Labs

