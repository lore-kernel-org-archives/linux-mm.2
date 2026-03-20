Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA97108B8E3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CAB6B00A0; Fri, 20 Mar 2026 05:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58FB6B00A1; Fri, 20 Mar 2026 05:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C915E6B00A2; Fri, 20 Mar 2026 05:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB0076B00A0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:49:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CBC25176F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:49:13 +0000 (UTC)
X-FDA: 84565968186.03.A39DA48
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 66C73180004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:49:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1tp2xW1E5q9qaamOvTGHF+oknQsYhgy7pYQsSrvM9WM=;
	b=AVK0OjXDSTDrloB4KoUpQnyB/2MAeN63vg50Or5OIugRCsyOjDQW/XHf8YhoVqdxVIcRjd
	DSZcLSTxuMKwusT1mOGbve1OgdAXIoVKlB7qVGhARUFeGU8D/Y4RzHZwVPEOtfd88Fpx1y
	4eAmXpDD1naXCEDShMygIghoQlVQc+Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000151; a=rsa-sha256;
	cv=none;
	b=E87cvFxN/UOloYjNrwOX1LBvTqhbetZjOW9F7IzlMZQkW6j4+ng6pzR12yJx3DF5RJe3M1
	3d15jksr4SjjrWk+bUJkvC9RP3btOdpGV4wV5Eansk4btyuXH4jTl04WZDx3Qsl85PLLzb
	UBP9PBSn5Wikc3LSGx4cwN6gcS3kobA=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 20 Mar 2026 18:49:06 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 20 Mar 2026 18:49:06 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
	linux-mm@kvack.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 0/3] Fix swapoff race and cleanup in hibernation swap
 path
Message-ID: <ab0YEn+Fd41q6LM7@yjaykim-PowerEdge-T330>
References: <20260319142404.3683019-1-youngjun.park@lge.com>
 <20260319195032.5c3b187d5779cf43cd63fcd0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260319195032.5c3b187d5779cf43cd63fcd0@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66C73180004
X-Stat-Signature: 4wf8kcz3urwesbs1swkqqyz8swxt63iq
X-Rspam-User: 
X-HE-Tag: 1774000150-154334
X-HE-Meta: U2FsdGVkX1947fDb6Iay8FQkI8qBDiGallNZwZk52ts8qXCLkbHMv/XmucTY4mIJ2Rn+JuQio9bHxgeeVd63o6XRom0W40oL0vRFVMruYI3pAhllHZHDU6kRWtm1TFBToK7zXBd9g2G5Nnl8usoub6Jd2WGdYgX6+diDpL56l805ukUBreZE3qFXonFR/Kyiz59sV5HF0rnThEqJ4G1/P6V6VvnH54ZhNC3C38jCTW23kLpQ1q3em/2kH0KbK4JbSj+QxAMphaF0T84PwCE0zmT4qac/5YHG0djithnmB/Mt6vNMzxiy3VzrzWY+jO09EbdB4yS98G3Wm71ETAO5it01CugexvduamEkwrUF6yajUGVYpK+LrJk4/HXTuW++Z7DKvfiWrX4AegjSTSHGzzFl3Q0/4DgbQwPjcdMqFIT9hpOfSwsyHzE/etDWvtJaPl+ZpKW0eOAVekqvIW/Vkeg4mRhw42sPFZTVLILP/OG0RpiAtjvYAWupiCyXnjDexlTsAuv3jmx5vvGwE/GituNoWaY+BrNBxMLfN1JvxMmuAn8vLuSt4NcbPYOa8AlR5Ab5kxI8YTsjkHFImOpwI9yZi+aTrCPuP5jLrxSUXZhzhM8BV+18kF8pMzujCytCdmhHSYX57avgpIeXLT0WWlfpS2lDExdwq3LA+ROgrGAAuuCt5XPmSCyHkVN2BKOStjoz4Ktt73zHcAf6isEZztkz6/sE9SEZwptRt7jqd9h1fzg/2aWoq5pS5l+pjIXJ2V+ZlAvW6oM6ZPcBvpK3IeLmx4MlehH+sTw+Iqn964tm+CFFY8qArZjkzKCv/zDoC2P+A8N+PeB3bmM47YdLHb/Owvw6R3RR5mfLmHx317gHNftvVgjwwNNnt/XbYqIgQEWTx7GAtxDFZNvUpjmZo7CHo9QHmozs4pcH7PhMSLpex8av79UXvXpxnGox7YMz2PKSPB3kF6+zU5BO0b5
 n17kGBYo
 mMGVB7radA70WBYph417O0qAG9baHFMjJp9XrGcp0NJ+OAbijxfDH64rU0v7d9iEDUWY6la9Wpz66/9wUYL5XqZEX5RGGFn7QwnfIO9z6K3ty0O98cjC/TGZNl6MsiqjT/tGvc2FVIJ08GlCWNQssGwkSqL92t60Yn7N8S3hc2C4mdNi90rCUzQU/xAF7TrZdwFzJJbXTJuiOkL8gsKaUZaBuM3lyZxt7dw1YJ0phsB1YDc6hPb0JMHhjbqJjHVfdr5SMLD0wbwhOesZgTaprx5tFeuA5g4kdYgw+lPT2hAgw2cOOqlDFkqtDhwL51eQ44+g06/5eal+uwlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 07:50:32PM -0700, Andrew Morton wrote:
> On Thu, 19 Mar 2026 23:24:01 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > Currently, in the uswsusp path, only the swap type value is retrieved at
> > lookup time without holding a reference. If swapoff races after the type
> > is acquired, subsequent slot allocations operate on a stale swap device.
> > 
> > Additionally, grabbing and releasing the swap device reference on every
> > slot allocation is inefficient across the entire hibernation swap path.
> 
> AI review has questions:
> 	https://sashiko.dev/#/patchset/20260319142404.3683019-1-youngjun.park%40lge.com

Hi Andrew,

Thanks for sharing the AI review. Some comments are indeed good catches.

patch 2 comments are wrong.
patch 3 comments are right.

Regarding patch 2, the AI review raised the following concerns:

> If this race occurs, swapoff clears SWP_WRITEOK and calls try_to_unuse()
> to scan and evict swap slots. Without the SWP_WRITEOK check here, it
> looks like uswsusp could successfully allocate slots while
> try_to_unuse() is actively scanning.

Right. but..

> If try_to_unuse() encounters these newly allocated slots, wouldn't it
> attempt to page them in and subsequently free them via
> folio_free_swap()?

I believe this concern is not valid.

swapoff calls try_to_unuse(), which scans swap_map[] entries:
(this logic is slightly different from each kerenl version but, fundamental is same)
    ...
    for (i = prev + 1; i < si->max; i++) {
            count = READ_ONCE(si->swap_map[i]);
            if (count && swap_count(count) != SWAP_MAP_BAD)
                    break;
    }
    ...

However, hibernation allocations marked with SWAP_HAS_CACHE are not
visible via this swap_map[] scanning logic, so they cannot be found
or reclaimed in that path.

As a result swapoff keeps retrying while swap_usage_in_pages(si) is
non-zero until user signal is delivered., rather than freeing those entrie.

I will also verify this behavior at runtime to be absolutely sure.

For patch 3, I agree with the comment and have responded in Rafael’s
thread.

I will update the series shortly.

Thanks,
Youngjun Park

