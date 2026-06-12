Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BBB0CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27096B0095; Fri, 12 Jun 2026 13:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF2E6B0096; Fri, 12 Jun 2026 13:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A151F6B009B; Fri, 12 Jun 2026 13:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCD46B0095
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:09:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31C1AC0A5B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:09:04 +0000 (UTC)
X-FDA: 84871895808.16.4F28A1A
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B81B120003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:09:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=bquUaG7N;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="h 7tMjQU";
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.155 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781284142;
	b=5FVKLlmhJ+2Kf6yHsX7J3g4lvfmRhBomlpCU+ClSVoTaiWu+VARo+4jYeVLwM8VVONtY6k
	wH15Eo29Rs/Cpb9hK40lzWmVEzoMRGTECoXFPfHqN5qjw9TZKRt9lYndQA0uzRK8soygnA
	54eaeEK7ReHqSEbOe8/h+FqM1+382mw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=bquUaG7N;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="h 7tMjQU";
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.155 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781284142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsUebY2ZXG2/1TO6nMs7fw5YQPjV9f9LK+DvZ2Jcfhc=;
	b=5+6QIFSYXne/soGUJ9VcBPIFC5CSEbxRg1eiUOemJYXqhNd3HwXYyeJztN/H5KUkdpchuo
	TV73P+b+Kf0YaNyTMWbhmmZhqNMsg9ezVLI6RDwStPXjgPB0QoWV3gG9+6uTZeSXiUuLp1
	HUOyS+v2wtjRMhNN2grXokxeq+s+rYM=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B910B7A0148;
	Fri, 12 Jun 2026 13:09:00 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Fri, 12 Jun 2026 13:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1781284140;
	 x=1781370540; bh=BsUebY2ZXG2/1TO6nMs7fw5YQPjV9f9LK+DvZ2Jcfhc=; b=
	bquUaG7N6CdRZXhDzy7S2dRUm3jRKQ6L0LVoYqkHU18Jsg+ri8+8fMM9WBcV59QS
	i9APzzg6XUH+ShtlW4AsiannDhuZJ14zoqwCo73/Y2bbkTT4Rcj7IBdww+LLqlK0
	iZKwd4aHvsf7zOVZ0rQAJISYcuxal3Fgkl8nsDeufvTG3wQWz+39aIp/2/FlV/eE
	3MxTRnS3litp11LMo5H3BheN8HK7cqqF9OuMPbPlzqoO3oO0IasFqrqN6mjNaDDk
	cGLgV/M/GmLaqLYXevN0U6OVDg4zwdQdc8NwrwoNRDlO3fQ6Tyvmv7kzRaEeNpck
	adtQKZ7CdSDxgruVrfcC7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781284140; x=
	1781370540; bh=BsUebY2ZXG2/1TO6nMs7fw5YQPjV9f9LK+DvZ2Jcfhc=; b=h
	7tMjQUfH6zFenuqIJLzxcK8xG12he/XQo/ImA7umOkc7zWoHMHGQUt3rVGYHoMwp
	wm9u1hlU8l2pYVim7SJ9vYZhGazTpcNR8wv6ceK7lRQwF+VcGmDzLFd8dFOhFSE/
	0dVpcN8a3D61vz8AdEW5aySTV4lNedqYb2EdiaB8qxS9Pv/3R+tI8Ef6y31f7vwl
	K9D20UqCCUjOMsdhtBINfiAgiXFp2lFnOsRvXgpiLGRpyHYeLcKqkhpwRwQSvZGA
	TF/b1iOCV5CXHounvY+w4N/bLWd3kOh3K+7jz3yHq1jmkrKuq7FyQH17Pk5Z60Jd
	S3QXsJBkecf3jfEyCAtBg==
X-ME-Sender: <xms:LD0savSXV5zl7_--zguKxhEvrbskKYlLVyRh2YvonnF6JXtbsVKxDA>
    <xme:LD0sarm-T8yPsQ9D2k4e0rQ4JW-wM7iUX4sMEzQmdxVH5_AAnurErA0s8FlZTDeFZ
    iI8dbT02OthdSpl3KG0PJLDaW2IA-QSsl2cHrLosTGXuO1HU6pZI08>
X-ME-Proxy-Cause: dmFkZTGwN+Ekeu17sMdaw9gASWSWOK9O1Zv6WScOHNDncCF07cLZEt8u3bD6JKiw70vsW5
    gyk4kNWrdtL4pFHt07VYa6ueq6AfuzMpNyJ5O/P61NOVpiIvmo2U75TLSN99ln+iUsMfeT
    mgxfr/nnyD5cckfWtpP3S42fIi/P2HV2KeFHQ47GGDTQWmoiCQywJ8H363tWJL16Zl1fhN
    fb84euBh50u7OJWWBPMoLhu4+OmzW0j/ZBELvHtbvROJbDewuf2x9ahVLaozXAbI74QsvL
    zGZK13k7Bj4cs+KCYq0u3ZGZdxwxfm6vDeOwboaoxEthvVrFdLmfecq7s7WWTejbwVaLGf
    ezclml10ERX/lJf3eMC0WO0XNyiJQqPghg4DbRV0EcAq8g2lXR5kF6Yn0CUwmd1qt0zj3X
    3wa1gWO/TGp4nqUp2PwtS87zJMSIwL5rnsLR+ZZg9hNk2qfuFc3sxnzLBki4MwOby9gWjZ
    XV37tWK6+dn4i9Y5eZ6uQ34q9R66N+0x6Mjxqco7ZNUw5xfbCQkLBrW++b0wZHE3W1pfn4
    f+xIsywnQUfzSyAyeTs0iQs4DiH3sDOIYehHPJ7lYjcNrdb0h8kH3bsD/CeGEKUNcaFTlS
    46j7JHCRXozPG96KAmNLdMoqPFCehFKzOK3MRAm7NMl5+YZfkJ+NkFcaolgQ
X-ME-Proxy: <xmx:LD0sahge6lPQ79-hlA-9zGwO2GZJyrDa4q9E7theuP66Ew4vx02gZw>
    <xmx:LD0saibguOBbn3ns75KWJl9c3Fg-yLHDdGyT2TKZ7v9xPspm9HcLoA>
    <xmx:LD0salgl3aExGE88O73YuF1R5qlx6JND46UvRasxbZ3CHi8iQYVnBw>
    <xmx:LD0sakYLC9-VHquBVHNSb-Mmbo9fR-lH6_HUc9pVqqoPcdFYT_cq0g>
    <xmx:LD0samHrYOlInMhF4Q8G40pcZfTTr6pnRcyJHmsiR1PTshu6yYKfN8gF>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id EF0C31820082; Fri, 12 Jun 2026 13:08:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AzfP_w-3vYjw
Date: Fri, 12 Jun 2026 19:08:39 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Laight" <david.laight.linux@gmail.com>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 "Ravi Jonnalagadda" <ravis.opensrc@gmail.com>,
 "Quanmin Yan" <yanquanmin1@huawei.com>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Message-Id: <139b11c0-dce8-4995-8f28-320dfd6cc70f@app.fastmail.com>
In-Reply-To: <20260611195037.1adec04d@pumpkin>
References: <20260611125704.3386176-1-arnd@kernel.org>
 <20260611195037.1adec04d@pumpkin>
Subject: Re: [PATCH] mm/damon/core: reduce kernel stack usage
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B81B120003
X-Stat-Signature: 8kyzt1j151aqr3s9codjdzrteqfkb4xf
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781284141-862164
X-HE-Meta: U2FsdGVkX18FpTmGWL0MnPI/+OZVJYB0wRAzD7u78fjzTdQgevZtgrjEJY/MZiK1cRvlJ8/tT40BOiY4E5lS98vdX4tEWDAnfxor0w+kG8TaB9ZUM2C2EF2LWsmjcG/+AxU/SGK/uNhbv5R+m0Z/3jrQ65H5474aScjnUjKdJRnKTjRxkE58pkgMSTy3DRv5TNcxF9ETeCyParHxUyPHJEljMVdQRnzWzwFzUDKzEn6OrjFYWjbEVZMk2bev01SLazG9onilirdtBCzxaeDeCj8m/Z907//Z85R2LT9CYWvgE7arsrG+W+KeZ2K1ubyXvKLCBhtxm4xWJgejPgH6U1cIDkhRpIEeEAgaa0C3PB7VS2zhwBpw6BGZmfobj1vRABLpHa6yl4t33rHDtT6Z3ft/Ig4+V2PufpdQYifkAnDO/SkicuJFLM2Owat8d+BKNSlDlayEwOLol66dLvE4ZYpyZsCXPmaUB7R/q2y4dn0Bt6st0uVRn8W7y/kTeE+fQ970YR2GISH+KS5V2iB0P5sL1VVuvH1WvroXcOLsOlxm0hx8J4cGlRcQseBhJwgX2Z6GGL+WlGIs00B8Vvti5G8wS7gbytZocaUhCwiAhGOKq4I4r1T5bS+ADbqvAl1UP1rHb7zICx7KmBOCPenenkzat0r8jLkhsd+hjqQMZfan6tHRpDNNJVfDs3sPpkSbB3ah5iPb9xRY2GjwamKWr+jYqk6ce1Wyvk7snl3reTOSwv1jsJQUI3us6zXMtoJkEbtTkKJYl6ZLE3jlQqRya7V0TZUiXWeG4/5AFB0H8tBsHeeET8woDmHJZ2fc1j7VNKpA5F3rhf9PUOJlhrBw560A/XR4Y2odKf4DMW/whDu+RESfy6yZ0yed+gEpRUGvuvu0TZtjbzrVfHZId/OW3pFMTRjDlaK2RFWhwHEGMzOh74LoJMCtzd2YB8tHZRA/WzTOoolxmDeGnriBDq3
 SEe+ZnHo
 j+zaZlrVXYVPIy5kYRQazxtu0T+5J3g2TBBnrD+UaGfyP6yTGXexsmvXpfTeLtMBmSiI/lsjq7uWxDobiCWJvaZD/NgwGdI9y71VRx11Um1VJE5Pu2H+drPH0dqNaAgRnmcWW0O24lZCbEvSpzzsjixPXfnmSiEsexbzjBBx0R2PZeSiVpd6dsnAonGT2SIKXFrAW9by/h90FKawzZLnaAsd4kql+9IQWjONntN2rr0Z9fbD1GMZ9o2LUvFOUrvxZ8YSIlr+IeA76VJykp3Src9D9ySY3cnMLNQXI92iOVITddFeTfVEBetMbw8ITrRHsdnkjl67iq+Xbh6lESQ3ePU0Vmo7yO3U1pcwxpCQBvDBPfBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026, at 20:50, David Laight wrote:
> On Thu, 11 Jun 2026 14:56:57 +0200
> Arnd Bergmann <arnd@kernel.org> wrote:
>
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> The main thread function has recently grown to the point of
>> exceeding stack frame size warning limits in some configurations.
>> This is what I hit on s390 with clang and CONFIG_KASAN:
>> 
>> mm/damon/core.c:3440:31: error: stack frame size (1352) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
>>  3440 | static int kdamond_fn(struct damon_ctx *ctx)
>> 
>> The largest stack usage here is inside of the kdamond_tune_intervals(),
>> so by marking that one as noinline_for_stack, the functions individually
>> stay below the warning limit, though kdamond_fn() itself still uses
>> hundreds of kilobytes for some reason.
>
> Does that actually reduce the stack use if the functions are called?
> Or just stop the compiler bleating and running the code is still likely
> to overflow the stack.

The one code path that was identified by the compiler does not
improve, as the sum of the caller and the callee is still the
same. As far as I can tell, the stack usage in gcc is similar
in this code path, but it doesn't warn because the normal
inliner does not combine these two.

It does help in other leaf functions called by kdamond_fn() that
now don't have the kdamond_tune_intervals() variables on the
stack on top of their own ones, so in any other extern function
called indirectly by kdamond_fn, more stack space is available.

> I did that many many years ago for an embedded system (no indirect calls),
> the outcome was that we didn't have enough memory to allow for the worst
> case stack use!
> The deep places were all (the equivalent of) printk() in pretty
> impossible error paths.

Yes, that is a well known problem: it is very easy to construct
call chains that are possible in the kernel that go way beyond
any sensible size limit. Importantly, any GFP_KERNEL allocation
can end up in the file system reclaim path.

The -Wframe-larger-than= warnings are just one way to make
this less likely to happen.

     Arnd

