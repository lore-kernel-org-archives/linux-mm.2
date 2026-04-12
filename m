Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F13FCE937FC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CC86B00A3; Sun, 12 Apr 2026 15:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD566B00A4; Sun, 12 Apr 2026 15:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3FD6B00A6; Sun, 12 Apr 2026 15:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB266B00A3
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:04:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0771E8C874
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:04:54 +0000 (UTC)
X-FDA: 84650830908.12.1CC15C8
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 28C9420011
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:04:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YAOdTOxb;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xxA5sfGEOPcW6uW3CKulYm8b89rPouT75E/m8n6d44=;
	b=ah6ORJPhLnJTIktA64ZRSRII7CnwcSieCLyu3hTv9uGic8rEC/O9GzyByhPAkUC9tLt7iT
	CbIF7uySH9JEcf7ZW2CXbCVL9SnZfnGiD+xlO6aqXJcvsvpg7TGC43DEz9ArPrexEwM3bf
	T1bNxRkvz9YXu2WNE3ic/Txhe+n02XY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020692; a=rsa-sha256;
	cv=none;
	b=ypHu8QXFmZfbA/AFvx1xYboCmAZyjiYJ5Hs+7ixNwIdUyG7wUbUFh1A+1TZulTOUhouiWY
	s+o2TjXxJsYrY2kwPcx7LGBrnPBSZUfPb0A/mp15OiBUkS2LVlDEIecFKNWxDnojiqUp3N
	kkPe2sC/bpJac01Oa6SOMi9RPY/aJb0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YAOdTOxb;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35d90833cacso2264664a91.2
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776020691; x=1776625491; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xxA5sfGEOPcW6uW3CKulYm8b89rPouT75E/m8n6d44=;
        b=YAOdTOxbRPkkDwcS4SJetI/a8aLLtmhQppGT4Ffphqf9VWrVTMmFkC4dHw8xnXtjKf
         OA0xRg8t4EL34ZFgWYbZvuC1QOcwyzFAMKUJELJSejno+m5s+8gOwfUSf4T4zyo427PZ
         1CO52VpIlRfxj0W2MmVHWSC4tzKmK5UWx+RiaZQF8PerDfCWWqokhAuKdq1KB1fB17zx
         GemOIOry1c2NkCpQSrktmC0iRnVvN9bVObFAKGVAB9vXiEUEIcn7YZ6g/rhngfPicKD/
         P7Bvo/xTpN1Jd5GrUAGT54OwPxCGX6laYTv053oERJmeMpB6ke6cp0NGc6k8TKnFql7W
         gcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776020691; x=1776625491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4xxA5sfGEOPcW6uW3CKulYm8b89rPouT75E/m8n6d44=;
        b=aUUxETFOkB+SxoobjsqBvxX+gTDeMrdDLyCRUzthYFuJkoBKd0pFH5feXvwL4zxeJq
         XauDI+ii249UwjOUlQVf7RzEajJhynWGNCNj7HJng3twRbJRS8MZTmyUSC2wk2ecb1cG
         OTpQ0pbMzNIKk9dexbVZyigVukeDCJRSnyL7h+d/UXIJvjbWwl6yMz/npqkwRQ68IMeE
         fr8WlEIYS/kG6W4Xjg7zuXLLiIckCuS+0TMe5zQXz9wOhWwuTEbY3CJIQoarOJpQY/k9
         xGT6nzY/nELY2FcXKWQirZMbTDux8chRNcUSXWbuvPN7w5W++ueayEIWkOPO91qf/oYf
         rJ5w==
X-Forwarded-Encrypted: i=1; AFNElJ8pPbJdMyjvYCTUR7u8wh9bN6w2PWjFAvpqL/4o+rmyc7t+s4fOfJB4UpZXV4tLBaDGR76h6aqSLw==@kvack.org
X-Gm-Message-State: AOJu0YxEUVwr+mlWOMOcRNI2wOa1BLZLZnsLLaFI4MpacOeQK20KRift
	iIQkZT831K48kxzVh944bS3DTQ5WOsgn/9MLD2nXF+OYPnGrg+mHqNry
X-Gm-Gg: AeBDievjRPQfvIvb6FtKYqX5KZvMSvs+KotuPiKsY7ElblJuO1sLT+5OqRUgzjfSlFl
	dTDRWFfBM6L3lq4owP8p6O5bAWIQXUEYgc5jjGEYbqRMjNBLVNlKXG2LpLSsCzUZZ9C50sFUcvi
	7ZFvXU11AeL9T5Pf661L+jyKFK/+OXTS9J9RlZp2X4fSzdv9WofyEr4B+hKOaOXxb3eT1rfEE7P
	/aA6ObuS83M6pHR95REx3JixudUt2j/uAC8eoh7ftTENbox5FfT4vrlACzqWa/xlmlcT+hrBIt8
	BFxAB1Sn8F3kKXowIZB9fGd2k305mCq7imiuubm/oNhZMTNZElMsdV8MipKcc5I47cpuRvr+c6E
	T0VgpFCvuFozm4/uLrIsNbKkRd4fGuHIRy0E/UiKMl74xbTDQ0EWFpUtfMGkZ0ghJmpWcbQhWqW
	C3qbg4cwXqZqQHKOhIT46nzJGiEsE=
X-Received: by 2002:a17:90b:2fce:b0:35e:599f:aef0 with SMTP id 98e67ed59e1d1-35e599fb177mr3237144a91.11.1776020690790;
        Sun, 12 Apr 2026 12:04:50 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e411ff4e1sm9924144a91.3.2026.04.12.12.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 12:04:50 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Mon, 13 Apr 2026 03:04:55 +0800
Message-ID: <20260412190455.6685-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260411153821.95491-1-sj@kernel.org>
References: <20260411153821.95491-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: j1uymzb5676nc7dthga8ebedgpbqty6p
X-Rspamd-Queue-Id: 28C9420011
X-Rspam-User: 
X-HE-Tag: 1776020691-417267
X-HE-Meta: U2FsdGVkX18xPWJGZltD4TRolqmtf8axPP5AsOfkBYHWm5cyoVMcYCYjz0EO7Lp+azkmBTbk7nGol1IzlxvRDodf22R2ZbpW3V/YsH3C5jqnxghZajtQuvuEsIxEZkLxW74hrsEkJnVKqI/J8LGL62T9WzCoWNIQVXEQN0bgV11sa2C50E4TKdQB5HhAF8n+jBrvrp2YVlSexxNtcuYytnxZI62Rbz3rey2XbcrGZj8YqYKxQ+gvilFFLK45O5AAQPXTgelNrKo31X5zgYQolPN/hAeAbQzyqNxwY5vj3hrPQV6eR03uiJlHH55s8VgsMYpHkuEfECT/C7E4AHMhRz6OEYviWtLX4Ld+1xIVVid4p+FAEyTKBFKl97qcYO0iFtcvtvqctrY4JxYgato2XRpQxJCY7C0geKeRtVbWdldvgBiB5WEsKrSVdPDr3YVLxkaw+sVqBeL9pmbGWEFTq/Xg+zflUDvE77gqKjU27TcYz/vPDKr7plSzCjXyM6pMqz6Z6x5mv5X/someG2JMD5Celjjw4ps8g5YtMLuf0DIGscUKUg7bflKQ9LEM+Nn5fnF67HkT9KJ6v0sAdavMi5wa+bvmvGRlXz5qPlP731NFQkhCODqNtNLv895QNOX59azxHwxaVK3J/thzw135cJ3d0uwcjzpK5OVF4FkIphNNQrp3I5sZOMhMDvijFED/g0GiAaBaksGmU6sd6ZV+QcwpGfIYSRz7OrJtYj41ATe/PXHLDi/eBoOyZaFzfpsm7gGNZBxWZa37UCtcBpy8ILDqs2K024aNo/aPNULTbM4z6lw/2mvXoTrstoNH8JbrtQ6nZ5+Knjhtc+6wfOdaCp+uTPbRAC1vu4O8mV9+yKO1cpR+d+zCVZVxJnvlDG30xW7Qe6RcWKzIvETGNlX380GvMbpy8JZ4Hqj6plVPzfDnSBKmIP9CtmKpOJBYdcLNYlpd1IC/m913GmkabrS
 33HNb2vn
 gTPCCBqSSwJHzrF1BfGfjJr7E7WF12VTMljZOrHTo51X3SyNPPOEbrefhc/Zoo1qmYt/NeDKChx4HcpI4iA5ASEkzAUS5yFNiPuxCepW+7XpTQ5izo5AZhu1wj8UHDvl+9/gjXJTzSLpU5i/Xh7rLwIqPt5jo8AYWJQ2dy34YuChLJT3dCm/aUvJ+JKRUh5Ql3/uz/pYlsRVwhKFx4Zwa+nwhNf2NVrjAEgSQa/LZWi+4xK1VeVIQPOeqaboyxhRPLMez3WPakeHdudoafwyKxXK+/hjSzGwMauJ+wJmK8vXwrz6nn3YxQowWuz1elAA+Spr7aOS+O31pEUqkziOSLYgtaYnTAv4M2b8MbWcUcGeROcY5vgq0JaeVMRbVslPRyPsPN7xWAAqnmEpa+o9cbSd3P+RWdFl/KZ7teRfrcYeJlDNY6N6YtCAld35q8TNCCCXTgLrRf447C8uN1Ya5MpE/IeDQs+NGQg4rqFVB0Wgbyz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Thank you for your detailed explanation and for being patient with me. I
sincerely apologize for the confusion and the extra workload my unclear
communication has caused you. It was never my intention to hide context
or game the system; I simply misjudged the priorities and failed to
provide the full picture.

I want to continue contributing to DAMON. I truly enjoy working on it,
and I'm grateful for the opportunity.

On Sat, 11 Apr 2026 08:38:21 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> Thank you for sharing these.  But seems even this context is incomplete from my
> perspective...
> 
> The Real Context
> ----------------
> 
> The real start of the context is probably the question [1] that you asked on
> 2026-03-18.  At that time, we found committing wrong parameters stops DAMON
> without an user-visible error.  We agreed DAMON being killed is no problem but
> the absence of user-visible error is a minor user experience problem that
> better to be improved.  So you planned to make the user experience improvement.

You're right - that question was the real starting point. Back then, I
hadn't yet realized that an unexpectedly terminated kdamond cannot be
restarted. After that discussion, I started working on synchronous
commit patch [1].

> 
> Apparently series A is the followup of that.  The first version was posted on
> 2026-03-26, according to the changelog of this patch series.  I can show I was
> saying the patch was confusing on the thread.

Series A came from a Sashiko review [2] that appeared while I was
working on that synchronous commit patch. It [3] was a new, separate
issue.

> 
> While the review of the confusing series A was ongoing, you posted [3] the RFC
> of series B on 2026-03-31.  This patch reported one important finding: the
> silent DAMON stop is not just a minor user experience issue but a serious bug
> because it cannot be started again.

I discovered the "kdamond cannot restart" problem by accident while
testing other things. That's why I treated it as a separate issue from
Series A, not as something directly related.

> 
> And this made things much more confusing. There are multiple ways to trigger
> the issue.  Wrong addr_unit commit is just one of the ways.  We discussed the
> way to fix the real issue.  So, by looking back this, I think you should
> prioritized series B from the point, or make suer series A is only for the
> minor user experience improvement.  Or asked me what to prioritize.  You didn't
> and I missed the fact that you are also working on series A.

Here's what happened in my head, and I'm sorry I didn't say it loud at
the time:
After you advised me to slow down [4], I thought you preferred me to focus
on one series at a time. Since Series A looked closer to merge, I
decided to finish it first, then move to Series B. I should have asked
you what to prioritize instead of assuming. That was my mistake.

> 
> But you just continued posting new versions of series A.  I was wrongly
> thinking that is still the minor user experience improvement.  I still think
> the patches were implicitly saying so.  I'm not sure if it was intentional or
> not.  But definitely it was confusing me.  On 2026-04-02, I started feeling I'm
> missing some of the contexts, and asked you more clarification of user impacts
> [4] and full history [5].  You posted v3 [6] right after I asked the question,
> even without answering the question.  Only from this point it became clear
> sereis A is not just a minor user experience improvement but a critical bug
> fix.  Now I think you should clarify this can also fix one trigger point of the
> critical bug but the real fix is work in progress, and this is till only a
> minor user experience improvement.  But because you didn't, and my poor memory
> is volatile, at this point I was thinking this all the work you are doing for
> the series B-exposed bug.

Regarding your "[4][5]":
When you asked about Cc:stable@, I got excited and focused on figuring
out the Fixes tag and stable rules. When you asked if I had other
patches, I thought you meant the older "addr_unit power-of-2 validation"
patch [3] from before Series A. I didn't realize you were asking about
all my in-progress work. I'm sorry for the confusion.

> 
> In the response to the sashiko review on this thread, therefore, I was thinking
> you are thinking the wrong addr_unit commit is the only way to trigger the bug.
> I didn't want to ask you to work from the beginning to fix the entire bug, so I
> was saying fixing the real bug for all exploit points is out of the scope of
> this bug.
> 
> But now it is turned out that you were aware of the other ways to trigger the
> bug, and didn't transparentl and explicitly exposing that.

To be honest, I only knew about the 'addr_unit' trigger. I was vaguely
aware that memory allocation failures could also cause termination, but
I never reproduced them or investigated further. I should have told you
this earlier.

> 
> So I withdraw what I told on the reply to the sashiko review.  And appreciate
> sashiko developers again for giving us a chance to finding this.
> 
> Next Steps
> ----------
> 
> So, what to do?  Please prioritize series B, if you still willing to do.  It is
> ok to keep doing series A, but only as the minor user experience improvement.
> Clearly explain the whole context you are aware of.  Don't Cc stable@ for
> series A, as it is only an incomplete fix of it.  The fix of the one trigger
> point is just a side effect.

Yes, I absolutely want to continue contributing to DAMON.

I realize most of this confusion came from me misinterpreting your words
or making assumptions without asking. So this time, I want to be
explicit:
1. I will remove the Cc stable@
2. Since you suggested prioritizing Series B, would you prefer me to
   send a revised v5 of Series A now, or should I wait until Series B is
   settled to avoid more noise in your inbox?
3. I will focus on Series B starting now.

> 
> And For Future Contributions
> ----------------------------
> 
> Liew, I really appreciate your contributions.  You found and shared important
> DAMON bugs.  But apparently your communication has many rooms to improve, at
> least for poort DAMON maintainer who have to work with only limited resources
> including the poort and volatile memory.  I find I was asking clarifications to
> your mails multiple times.  I have to say it was even frustrating sometimes and
> definitely took quite amount of my resource.  Meanwhile, from my uncautiously
> biased perspective, you were only adding more traffic and confusions.

I'm very sorry for the trouble I caused. Moving forward, I will ask
before assuming, and I will make sure my intentions are clear.

> 
> This makes me disappointed and even suspect your intention...  I really hate
> myself suspecting someone.  But we are in the world of bad actors that now
> gained the power of AI.  We actually had a suspicious case from DAMON
> contributors recently, do you remember?

Yes, I remember the Josh Law case. I am not a bot. I have no intention
of gaming contributions or harming DAMON. I just want to do real work.

> 
> I want to still believe you, so I will do so.  Please feel free to keep
> contributing to DAMON as long as that's what you want to do.  But, please aware
> of the fact that DAMON maintainer has poor volatile memory and working with
> limited resource, and try to make every conversation super clear and
> transparent, from next time.

Thank you for your honesty, and for still trusting me. I will continue
contributing to DAMON. I will work hard to make my emails clear and
transparent, and I will ask questions whenever something is ambiguous,
so we can stay aligned.

> 
> [1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> [2] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com
> [3] https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com
> [4] https://lore.kernel.org/20260402140314.74600-1-sj@kernel.org
> [5] https://lore.kernel.org/20260402152915.75294-1-sj@kernel.org
> [6] https://lore.kernel.org/20260403052837.58063-1-aethernet65535@gmail.com

[1] https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com
[2] https://lore.kernel.org/20260325025317.86571-1-sj@kernel.org
[3] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com
[4] https://lore.kernel.org/20260403161906.65008-1-sj@kernel.org

Best regards,
Rui Yan

