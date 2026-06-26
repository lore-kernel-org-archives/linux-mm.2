Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F66C44500
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00CA6B00A7; Fri, 26 Jun 2026 10:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8896B00A9; Fri, 26 Jun 2026 10:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14F36B00AA; Fri, 26 Jun 2026 10:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF8026B00A7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:46:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D283C21F9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:46:19 +0000 (UTC)
X-FDA: 84922339278.14.52D9694
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9DB6280009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:46:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S2MSO6vQ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485177;
	b=YlPPVLb4fmHPiiWLNtm77N67W6iomZP8fxRjEpW13594uE8jSaDrfANO1HsdG/FCrt1ss7
	9VXN7YdMmvmdlhBDFs8GfL8lKRJjkW/cyfeew/xTQU40Dscm7RXOUFoZFx7Rw+DCyrpG+F
	sPM/6q42JkiwXgQi9JaD6FxpEop0aNM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fZdQLtSd1MgDJ2accO5uxk2HAc7yukzOgkqYkqEi5Q=;
	b=V18y2P5v2Ux/EP1NRAxpMB2miDUMX4g+B/HwO/sd9GEtz8b2U17dz00G61bXX/Lu9lxnjY
	Xzn/h3olQGyO57lfiicqBaDXg8lnw8ZHo4DkeCc4mZRUcA+c0ycntOPX/T4rnpwqbaoeqr
	4OknMwBZtFq4QVbcB6anVm+LhnXBS7U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S2MSO6vQ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F99F600C8;
	Fri, 26 Jun 2026 14:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843771F00A3E;
	Fri, 26 Jun 2026 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782485176;
	bh=7fZdQLtSd1MgDJ2accO5uxk2HAc7yukzOgkqYkqEi5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2MSO6vQYMhCKGFwJNZwz24C4Wg+wu13oRJhd3WdYlk9FRawmhpmfDxxCdcixJ+Do
	 9AKfui952AR3leG7SuLiFOa+P3S6LNR9E034nwW1K4ulED9TQ40fcN/mL6P8X6L78a
	 3BK4soroM8Pjnl69VBogFVHWJqvSIVQR2v4tLqIoVZu0GMEJAFeLfZ3dCJlkVP+kYp
	 Vz+Sbe2jc2rZevEz6jSuGrzMTJKdTZmZjjQE9eZsjn/ERL4bjIzgpa+gmgkm8Y1010
	 RIlrJ9B8aCe5zX4G5oRNZ+sTRd4pZ/J/cSXKHV59Q6/KtHXtg3Ygt6L7BpV3PBqE1M
	 6loYGlvRd2oWw==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	jiayuan.chen@shopee.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon/core: split a fraction of regions when nr_regions exceeds max/2
Date: Fri, 26 Jun 2026 07:46:02 -0700
Message-ID: <20260626144603.86521-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626085851.70754-2-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: na19kueb6xuoj7bqootxipo9pbs75spk
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DB6280009
X-HE-Tag: 1782485177-868197
X-HE-Meta: U2FsdGVkX18/IO7A+WUvGrEaXP1vVJ/b6cqiNQpHcLCRctszfxcZ8mVQTQFrdpxUuqGkA5ybcFdBQUaquNYONNYN3JINI3Gc3dfHgfXsQJ3vCu/Std10twizWsOsTlvFZ4qRseo6MFcc06tPWzrYIRhKjetg69/fTSodEvac/1JBWI4eGNnlH4NNs0UO6dFHsMIx5jc7SUC65clSEBgEcE6EimPyzPFQqWtF7MMvQ0/9iUoYDHy1MqPMQ9NHIUbuhADTZR+NeiS2RgYzh2FFDzIoHJn0U+xoBU8XjiawT6bxLvNVuxrMYI/XBH7bMP42nIGdwFAdyVawwhJ863fOzjvufXxEK6SXlMjGrI4vU/fX9Cw57S3l7XXmjbheHAo0qfew4JJG/Y6e5pRgoLZqLf9saK9G6rcAX5OeZpzY9WSpYwf59/eKqOZiLdD8RUgTATkVjOYiht78pev0+qUabJpSG+9hTAqJMuzzMrE3OnfvV+WnrgPwgwV4/2GgiXQ0i0z5jWXa5Md+iIpE9FLH+3xd/d3TQj7Nxet9BCeAukCw3DSM72MOmXudL6nSTAKKyR2n3UJhlW2wezvSg3e6+5yS+vGUtoCR6Gjhql80Yoe6RrNWIA7mXDxSn0Lf3+VddtzIuAIQWGqbyXeWmPp36LqevmIXRctCKHWXJRL4qGqxq2/DCCTbwR2rzeLWIxTnDBPoEt6jtcVOx930H8e8jTNTb+7mGwD04F5RnScJtbusO/S//eTxcvCaglnYmQjTnI27CD7GZIras58r1O/B31d5wbE/JQo8+yhLojqIhUSWku2nKbK4SpubBBRw1uJkcap0ABaUC0iXuitQohXL1Tsrq+PhiYaQEvThG/QxlPxXaeRiSYgazi5h6aSP3TFYxqeTHsENMOXH5ZF/ilss8pvjOT0QDwESCkR9AykaoRuEduJ2irGGJFCLAKbr7xqwfbYSdXhH6zW8iyrCwOq
 GqGegF7I
 6+AqbKOGH2BK5FGH9qBDUkJ1IwuOjG2xrJS8BR787FfmdF1YPmM3qMIN2A7W980LTFuc9+FuVZVU51O4oqP34BbbZDCEuwAvF5C+sLBSAYp+dsyQP/YaMmY8ndGVUy8PqfBm092KiAVrCUXVbdAaEPufgmqA/m9E3eeiy/nUpwdsgkWXgvTKvyNdNP4h7ppUc8yV5aQGkak48HLDr/yqAfMEEDcPm41MffzQ5SbF735jAXArGdxJ4M4a4V/W0enDxxS89Ipoav52Xo80D5VXY8+7g05PUjTAg7b6Xdq6NCYIyhozVC4CbLmx2Q8M0wBQq6HjwDi0jvOi7+IXfbalm4aFncg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 16:58:37 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> kdamond_split_regions() returns early when nr_regions is above
> max_nr_regions / 2, leaving internal access variation inside a large
> region undetected.
> 
> Such a layout is common with damon-paddr on hugepage workloads or
> damon-vaddr on processes with a large anonymous mmap.
> 
> For example, with max_nr_regions == 1500, a target may end up with
> 799 small alternating-temperature regions plus one large region that
> absorbed a uniformly-accessed range during an earlier merge:
> 
> H:hot
> C:cold
> 
>       r1     r2     r3                 r800
>     HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|
> 
>     nr_regions = 800  >  max_nr_regions / 2 = 750
> 
> If a cold subarea later emerges inside r800:
> 
>       r1     r2     r3                 r800
>     HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|
> 
> The small regions cannot merge with each other (different access
> counts), so the budget stays full.  r800 cannot be split because
> nr_regions > max_nr_regions / 2 causes an early return.  The cold
> subarea is never discovered.
> 
> When nr_regions is above max_nr_regions / 2 but still under the
> maximum, split only a fraction of the regions instead of returning.
> One region in every 'max_nr_regions / budget' regions is split, where
> budget is the remaining room (max_nr_regions - nr_regions), starting
> from a rotating offset so different regions get picked over time.  The
> fraction shrinks as the budget shrinks, so the region count keeps
> refining while approaching max_nr_regions smoothly rather than
> overshooting it.  An unnecessary split is reverted by the next
> kdamond_merge_regions().

Looks good!

Thinking loud.  After this change, some users might surprise because the number
of regions became higher than before.  But it is still under the contracted
maximum number, and they will show better accuracy.  So I believe this is a
reasonable improvement rather than a breaking change.

Thank you for this patch, Jiayuan.

> 
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

