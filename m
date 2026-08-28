Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEDF6C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35B96B0088; Thu, 27 Aug 2026 22:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5F16B008A; Thu, 27 Aug 2026 22:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC546B008C; Thu, 27 Aug 2026 22:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96B9B6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:31:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04501802BB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:31:21 +0000 (UTC)
X-FDA: 85149101604.22.63F4BB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5DB1D40002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:31:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMyJlcCZ;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787884280;
	b=8gpn84S6/2WwMn7pY5xJhjFRw84yFACbCRsMICUCaxUeiEkmNAfKH1GNRXkFUM1J4ktn2P
	+mSxqmyI9rUWzzfr8pTfAlK3/2+qCm2+ByMnBCaN9TpEzqm9lPCDsN5/Vi/Fae5X8jjyJJ
	mqmvBJTErrFbXnAsWN7d2xx38iPRFMI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMyJlcCZ;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787884280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uY6X52+CE/BlmGNPEenqX1diWJOnne8XyrPMIYHRTJw=;
	b=pZuA6yU1mpGzTZnMcdkxdauVfVEMfH298iyrzaj67sb0JMBgCQHmKrlf2FNAHvB6E+S9xI
	6u+x5AlDNPC98WwtDtq0hJiZurGDpXarBjfLYUxXfl1Fyb4XmlZ09JEst/Ui20W7P+Pd6C
	hTobodTM9AJfbxpIg1W8G62+2VABFsc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7866A42E80;
	Fri, 28 Aug 2026 02:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276BA1F000E9;
	Fri, 28 Aug 2026 02:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787884279;
	bh=uY6X52+CE/BlmGNPEenqX1diWJOnne8XyrPMIYHRTJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMyJlcCZZCadNT68arE+NuHVNLfJoljWjgnNaTYHnUoH/ikEspa/3sSgkQ51iPMMW
	 juqRr12rV/tPIlwcIV/DwlC4d8RCzEDCpf5HXShxfHbHKRtcYVmQkF8lSUR+HReclr
	 Xf5Tp6mkQgk74UOlJ7RzdGge0V/pPx/fZ8Xz6+7n5sXW4nI36uSnKDIVsGKu9P/gr7
	 Nqw8qEyf9FqFBblT4Fgkiy9M4B+wqR5aoKYZTZ3IAgmlWJXB20x07cR4TuhgmswU3N
	 95skI+PX7BMU/kZj/YkBPeweAEoArbpFVJF/UlmTsA1ytt/N59Am5s/1Uv1u8GvRpL
	 apDqc7BZ6L4Fg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Thu, 27 Aug 2026 19:31:11 -0700
Message-ID: <20260828023112.122652-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828015429.131338-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: smioq3pke4q7pgu5yzgb68npqt6g5acp
X-Rspamd-Queue-Id: 5DB1D40002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787884280-354757
X-HE-Meta: U2FsdGVkX1/OB6IlAqkwxw+0+ocgJITDuY/JPz5OKcRCXcY3E/ol95Bo+wTQ/Qek/S7E6QaRtBQwh40N03bcgUUG/2C+ePvLC71GfddXAIBdC8sSO7JU8kfRRkDQ5jDMjf6PgUyiOWFy6/cETNH6WD+149fawAMknOS8+7hBWJrWvOD61pedAOnQdd3lIxtU8IfxSnVP7ZrDvA1xSmyBXp5n3a5qudl79JBShclyXyFl5ySL50ynyFkKRsr2KJFrpNIVOqU4OUUpqxYft3FxTRoEhOCs1JYjbzd+Xi7xULj42yqUimF02zCgkBTVamGbYBx82z5tiB9W5KKW8dJlGmTUbOyDe9UDaZbZSCYotzj1wVEOqTByM+HL5cVhq+Za1BHDpSnztCR/hyvc3UwibBU0RHYFAZkQ0tg3YhyqUBL/eVLV5BOVXNBqAiBdCF1GWvav+zh7AssAeplRpwVyaXxKLH0SkuUGKO7GaEIBPvOSzl2fuy/QxOSDutb5NXm7i6ocIkUgfblFhPT6hsOZDKYz3z8zdF9WCgTdSoyNUDNEoAdYuh8qSEwTqq4NAZ0WylyUphBpgHJa2yB/h0gPfNGFyGgzQt2/gKCSGHo+WB7UI6rE70wkjUeu1cMKQvKxizLVOsCpLCzUv5gLCJki+mGWMM4J5gz8EVWehO599eFdfeh+5guE8fWAInNpsYtecQFvKGRUO0Miu6LrxV0z85osNL8+vy9bksRr0D8Zg0s8GgycqlbR7JbQpPGoc469vp1qgOyHE+L90GCyros1bi4WJYf1JAFwWXeZ+R+qP5MdEX0DCar3YU4xUAuPUFdro1YmYvyZIJdZgwI2+uY4Sk+DJTx9CZfsmflvV3UR7NCadRTXWN1OgZ/BcjgeXQK4053guLprCXSIwFT/01CKXoHLb2HAR+SY1w3GckUpEk0CquQEZwOADTEQUqAuFsUNeB3JVTNGFsqGQry2P84
 9MrybeSR
 61Cqrorckfk5fq9xkMVn6mz/LPVwVGWvgo7AHgN52KBmtsjlLE0SOgNGaPMJNBHCDwjqV29NysZh0kYzLqPaRHOf7zA3sxMFot/dMWT80Mav7xEbMqTAjLa2msN7jw2kCcZR1RIH0Y9jCUEdHu3fDyiY/kbLFzncGKs0naXmk5pEoVhZ5TcpAbJab+Bmm7KETK/3OHtUP5aTaXsRkbOe7u3GQT+/zsvB32yRdTUmLMxVWIJDCP5IHh5TaYbiEm5KcDvN1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 09:54:29 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Thu, 27 Aug 2026 17:40:48 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Fri, 28 Aug 2026 02:08:22 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> > > While your approach works, I am curious, why should the cursor be reset
> > > every time the function returns false (does not skip)?
> > 
> > It doesn't.  It resets charge_{target,addr}_from only once after the regions to
> > skip are all skipped.  Am I missing something?
> 
> You are right.

Thank you for confirming.

> 
> My concern was that the current
> 'return false == reset charge_{target, addr}_from' might be a bit hard
> to understand.  However, I realize that my change was quite significant.
> 
> To make the existing logic clearer for future readers, I think adding a
> brief comment would be helpful.

Makes sense to me.

> For example:
> 
> '''
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2368,6 +2368,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
>                         damon_split_region_at(t, r, sz_to_skip);
>                         return true;
>                 }
> +               /*
> +                * Reset the charge_{target,addr}_from so that the remaining
> +                * regions in this/next target can be processed normally.  If
> +                * the quota becomes full later during the walk,
> +                * damos_apply_scheme() will update the
> +                * charge_{target,addr}_from to the correct position.
> +                * Otherwise, it implies that all applicable regions in this
> +                * target have been processed.
> +                */
>                 quota->charge_target_from = NULL;
>                 quota->charge_addr_from = 0;
>         }
> '''
> 
> If this is not necessary or redundant, I am perfectly fine with dropping
> it and just applying your minimal fix for the last-region issue in the
> next revision.

I'd suggest to separate the minimal fix and readability improvement.  Could you
please post the minimal fix first, with Cc: stable@?  After it is done, we
could revisit this readability improvement.


Thanks,
SJ

[...]

