Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0361CCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 22:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B624E6B008A; Sat,  3 Oct 2026 18:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13AB6B008C; Sat,  3 Oct 2026 18:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28EC6B0092; Sat,  3 Oct 2026 18:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 818976B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 18:35:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE7AE80A52
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 22:34:59 +0000 (UTC)
X-FDA: 85282771518.03.4D269D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6447F40004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 22:34:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ct2T4C8w;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791066898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zM0wm05N9ZuKkLRyyuk0bb0nZGRol8Du4ryT1xAF6Ok=;
	b=RJd2qXjqwJped7coWW6ODhW9M6l8dJ9W/N1nLyGRqf0++xTSjGBiGe64cz0aq64BD3OM1m
	zfYH/fzlWcc7/ehJ1+oQLKCZHq4f5JGkWdTbIG1t2EL8ZjgeBkQhMfpQsJrzIrNfUc46gh
	qYBtCmNmiWTldRR0nmtRhwAGYxvN/+M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ct2T4C8w;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791066898;
	b=VN20yV/myeQJT+6SjcRQfwuv/Nan3ZFzpCOcWL27/WjcPnnhHkaAtJDbq0uKfcWhd/4Y+z
	sZfC6sLP2UEBuX0qyUbhNN+FhXwQGZbqxL9HalAmOqJhjv92/tzZC1iUl+dGp9R2lM865q
	8ocvFKRTGdJ2guAVG47Q/InXe0g6waI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7FE743E29;
	Sat,  3 Oct 2026 22:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806B91F0089C;
	Sat,  3 Oct 2026 22:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791066896;
	bh=zM0wm05N9ZuKkLRyyuk0bb0nZGRol8Du4ryT1xAF6Ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ct2T4C8w0B4NvOUhuAHDjs6urnTBmSBma2hgKbEK6vMzu0BleolZEr8UYilUeTcpo
	 cj6LeVtQws2ZNkAfkwi0RXGE8crK0CF8nyUA+ri30xkJM40i9rjErnYw5fW+XjXgc+
	 LrZoeTae6F0j+baG8DKdekLuwm5ojpVYfOW6r774y/BKWhXKFWZyUXzmubgcdZrl02
	 q5e6KpTldk63TEOLIcF7nyv/nBC7rmSlvFhKJ5uiKAE8IYWpPkBY5c/yaqqArUauHP
	 p40OT8Rtqjq7gPyRMZSIch1RXfZDc1gI3uo3WTrAKZ+UKdQ9JVg6Yml4Q2TNpHE8/x
	 XL3HvrZhi2IBw==
Date: Sat, 3 Oct 2026 18:34:47 -0400
From: Sasha Levin <sashal@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: rppt@kernel.org, peterz@infradead.org, akpm@linux-foundation.org,
	david@kernel.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev, stable@vger.kernel.org,
	4ncienth@gmail.com, alexander.motin@truenas.com,
	caleb.stjohn@truenas.com, ameer.hamza@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asGDB8ZBX6zcsmWJ@laps>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
 <2026-10-02-rc-reply-0003-re-secretmem-sigbus-perf@kernel.org>
 <asDF77csaLDIuHTB@gremlin>
 <asERcvLuNJatsBL7@laps>
 <asEra6tBau-hiutj@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <asEra6tBau-hiutj@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6447F40004
X-Stat-Signature: mkac6oa33z41dixoep1i3yzbskg6x5om
X-Rspam-User: 
X-HE-Tag: 1791066898-188042
X-HE-Meta: U2FsdGVkX19O/mKMCW2fCx6J9ziwh0YUuhtW8f0UHmR5kKAhmRrG68vOWAIQviGk/aY+4ynR4/HUQAVWVeyqivhWB30fA1dSal7/IDJaCz5DtudK/xxW42dQCN+rVWhq45qROdF8sfn2wUPIYVWdKDQDzkeVvNwuCjytyUHAxEP4zgU3PFGZgzRFgRNPM0EC/2qWxzI9uOtqDfXFKwytSknMmS3W/CRoeL9Uyh6+2yv7Jbyr0IzntS0c9HiF+9v8DaNeogK13bFQK9fKf7dwJiOpqRLMsI5xoCLrb+qG2McbJw5LWPxIZcww3LbP3cFZM7Ak2C97DxIPkkZf7S7gKeAp4avUUJUqQRrPfaTvl744z2ijmJKD2vJfKE3mMKVxHLKVCCHTGJRdkRqr4ChlxN/kf2YCJPN2lIQ2gQGnqPBfl/TvHRaPPjr0kNeD6I4hPifNbiibZsWmbBMClDGrW55Cij3hNx6cpqkjjOj21JhcmyIDE/RLqAJFpi1UjmG/ZVrbBm9u7FrlrUYK4N64CDulo9waMfFwlqmaVcEDi9BUfqXZ/QUBtVLpcdtfSuRvznUMzxa8D6T0B7ZAunV6GdBPib71nmvbGgW4dFXLXsOUktz7m80Dp7VLf2H/GOYqcyJQRaBBExlbkMcGFmPECRt0TwBTz/DRGhU7fYJX0HQRcBuCzKXS+lUNnEtdspnw+418IuGrJUMgcW7jNTIk085ygRa6x9GaLja/506vJHkR9VWUDoPo/OA2lL5GP/DKLnay04hzmZvJNFJXgWloZOPYeWxYGMElo8m8lCqfY4DYiUvYPWB0f6AliRjA1SqBR+WIdG56dxfJ6rKTu0/v6kPb2WbW+MlQ91g54XHJVvpPo1UVwZ+CANMdSwRUd0GlV/EaJwLypRsyn/mSlPc3XX5gbi6P/+u3+ZckcB+b0Ferb6sUFDdV03QLWMMa8SdMaIpWBRpl0qj8DzPF0MD
 DArE0V7p
 QDqTuqK28cBy/xqwyTFT/6R+VXZkicNjfQT48JlfwMMH4wCJdaEBB7YwBHFucXy/pHZtaLJPwIbQi5jhMm8otTEMWlbSE871wyEh0Zb2PwAgEYX+lUzDDu7ongNQ2Us+ck4zQnsvQSa2uMHIWjKBDWaFDt6fO84+bwmLG2Q7uLzY51VE/MpoIyTgRCxqcHx/FkJDvYTPWQ46kxlezlr27DmN/CK/HYyi5NK33gHX4mdBKP9GO6CWaOnOkFdOzpiOhHbbes9RaCSJAfLq+Pi0jC6HFp8faPChFzSZCTi7hQXPjSTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 05:23:53PM +0100, Lorenzo Stoakes (ARM) wrote:
>On Sat, Oct 03, 2026 at 10:30:10AM -0400, Sasha Levin wrote:
>> On Sat, Oct 03, 2026 at 10:18:34AM +0100, Lorenzo Stoakes (ARM) wrote:
>
>> > It was sent late on Friday in a week that I was ill and it's Saturday
>> > pre-LPC, so that's hardly a timeframe that I could reasonably have replied.
>>
>> Keep in mind that our release cycles are fairly short, so this shouldn't be too
>> big of a deal?
>
>I mean the same argument could be made both ways :)
>
>>
>> We will generally go for the safe option of dropping a commit that introduces a
>> regression as it's fairly easy to queue it back up very soon after a
>> diagnosis/fix shows up.
>
>I think we'll have to agree to disagree about what was safe in this situation!

Happy to chat about it at LPC. Our reasoning is that users are better off with
a regression they are aware of, instead of getting surprised every time they
upgrade.

I can see the other side of this, and I think we can do some work to accomodate
this type of preferences from subsystems/authors.

-- 
Thanks,
Sasha

