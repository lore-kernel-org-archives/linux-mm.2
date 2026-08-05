Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64DF3C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE1E6B007B; Wed,  5 Aug 2026 11:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F486B008A; Wed,  5 Aug 2026 11:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638626B0093; Wed,  5 Aug 2026 11:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 376766B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:14:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7843120370
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:14:24 +0000 (UTC)
X-FDA: 85067562048.27.02A78B9
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf13.hostedemail.com (Postfix) with ESMTP id B08342000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:14:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b AY628u";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=MCMnAi3P;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785942862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMNQPlInX9ujF7JqRa863xUmon9aK87yLiuZsWJbl+M=;
	b=lzCduTB6P6p/WYA7+nZqMzVrbrPG/24N/T80hZAP9bRkNOR9xqEoXWKTGGuMhe9ZAPcAhF
	e5PKUkMrkJbBhTgDfSpVV3drA/39Qww1gI/05OM54ykD8s1zUiTqFtFhriOAx62002kWaQ
	3itJK5gFsNiuusleBigYRtla/+piFY8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b AY628u";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=MCMnAi3P;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785942862;
	b=fX8nH7OKmTh5zcRF7CYa3EQhdHeOZxFELlmmynrl/hxcLQoo6TXuGaFma6fjGuC4F04MRG
	RlXtvOdyfntx8SrecR6B/uCZeuLvO6FYDdz+IC38t9VoRbeLAKM3PVqvoljpMbjbwgZMMo
	ho9uUiCCE2Hn64P9dpeZtWdEFfCbLMk=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B415A7A00DF;
	Wed,  5 Aug 2026 11:14:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 05 Aug 2026 11:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1785942860; x=
	1786029260; bh=PMNQPlInX9ujF7JqRa863xUmon9aK87yLiuZsWJbl+M=; b=b
	AY628ujp6PNWL/JaZIAGBzc4H5wGNzLCMKN9uPRryzQHkqTbNXFidTtLvmeUWxYp
	HRO/oNzIv8YIqt/pEyiKr+VvnvRK+iphDgIb5fROoTamVAx7dn87cR5tgL0HYjyh
	1LfP5H1UTVTi8k06KBXDeNhZ+0xZSnwCjqZyBd2DlH4y8PtfjMSLU8yrDtaDjG2a
	lYLDxpkpVLSnk465oZMXftXu9Xtthojq0OmF8YPH8SL3kLEeCtHXnVxtrH6p361U
	Odzm9tQKQAK5GX3n+jOO9dBm12dDNq1pgRl6Wo4S0cEN+4sY8qYmrrS9aqAxaPGy
	1WlRctvYQbbPht2JK6PBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1785942860; x=1786029260; bh=PMNQPlInX9ujF7JqRa863xUmon9aK87yLiu
	ZsWJbl+M=; b=MCMnAi3P4xMsKrNXshlFBCa1N1vo3Yo5TrctYrc6cZrjajD1wxY
	NVu6t6H2Jb2fM0qR7Dz2GLvKCLZEFQoWeiWAPNgUKm8Psujp3TW31iY2t1qd75nw
	dgLNHhwJG2vU3N67TBwPdCiaD4gOGpX1BhLxHP9VsXAzWRcwNOgH3AMrsanl+f7s
	xhQagZRAtYE5+V84Q2C9exKMz++eedRrT+VLpLEFvgNOeBa8lDpnbiiy8xy/LeQC
	8sH6qpyQt19r+5Oa44GCZ1YKHmtmheyRLCS9j/VqRaNjmBkaVg+/xi0yr4jFWz1c
	ZT+KBQDvDqOQWi6+iJNpTBFa114mgIBvn7A==
X-ME-Sender: <xms:S1Nzagy98l1BNpqIDI2PHnk7QRhUd77rTZPZcNK5j2U0WrErMjytsw>
    <xme:S1Nzakvc4QpRSrG14roQ-fyH4Ysejt8xKFESdcot_flrJINCNf3G7Ukog5LqSchKe
    HklpgbZdONlb9cnNXKuPe-Eg3AY5PWK5Zg3O03Ip3TiGQlNh0ND1Zf6>
X-ME-Received: <xmr:S1NzapNwDIgVS1vKU5Nq4EMm5sQm8RzfunB2UWtQzDhscrgt0vgb89eGN3c>
X-ME-Proxy-Cause: dmFkZTFXDFwVm5W0xBZGcJj7Nl1lXhDBR1FUroKQrSjwipeLMmgzI2AwBV+QdHALrBxEsY
    eMGi0Q1bi52iJJVhZR7IFduwgGfIC+kvSDhVt3+bxsWAZz7KgeP7tM/tfi6vaj0rR8yBvR
    bTQjq9GZs8aTpXRNdWvBhCZTh4MN7swWSqS6BMaeVMnCD6eG+dV41XjTgVQZ9nAnYjYcn/
    ihjdb+UUUKVNqSMAGTjaJECj/vNsitzyhuqyzHS6TV6BrbgM6HU91rgbPvvkR2UdYPAdqj
    iMq7yF/2/jhjySPm2gzgfF/OrMMlJLSus9iMti9XmddzcrEF7m894YHtGe0QLK+X1LHDPD
    ioI68h9nOepIuxsWoi/CGPm4YEbub8SMtWjQSzCvMJ1R5YIsS6zRRwkhHM33ijFVC3N7zT
    gyaDlFaaebEx+UV+2wi1GXQBMlc9dUFDXA7oaylHzXgTIqfZIi/9YZjAgKS9ycON75KRUm
    3WyoO9FZFcxOutteJT4AQnk385wpcZEYZqyjDwGNUYH7bdhgUCnduHfsn2FzJhoQNUXPjF
    izta4ZPvp+F+L057iQcclGmyRqOKl/eFeGI51DC05ogGSXpxuR7+T36uvLhxoEzuSUAMgW
    wa8yt92AlmIsI1YY5zrm9pc+FM0b+yAXrzlZjl8LyBjWudyvm+Gu6GjxgWoQ
X-ME-Proxy: <xmx:S1NzakxwB7PEd_2jweoB_7COuyOzxpAuIp-_L5HSORZ8sIlaIr2Elw>
    <xmx:S1NzavPS81gebZ2HIFt1h0nHc4xksTOi6bSsWpQEEXXL9HLijt2zTw>
    <xmx:S1NzavRYzuv39oRb_bYE3t28xAH777NiHq7bqJvYC02Nqt9JLUo38Q>
    <xmx:S1NzaqUPhcBkLZZJ4WOLy2TBFgEda75KckT_mXh9F-GsFUjx6cs6DA>
    <xmx:TFNzaomrWVzERvUv-rBKYEbaAU2PYz_ZtnMihW6wmBm2wbPnN1CZIk2e>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Aug 2026 11:14:18 -0400 (EDT)
Date: Wed, 5 Aug 2026 16:14:17 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, 
	ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] add anon mTHP collapse test cases
Message-ID: <anNTCO-mMa_y0AvA@thinkstation>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B08342000A
X-Stat-Signature: it6a1kzgcd8phr4xacufeku3cq9acxea
X-HE-Tag: 1785942862-124081
X-HE-Meta: U2FsdGVkX1+ZEJuFqD9CnI/PoTYCKwiTN8qoFIH0AYShQ/rGAURHzb+z54hXCn2F1M56z+Dxhk5H6CRO485S5iJu0YrtyHzPu/jqqH+Y6BnFpu72KDyjF2FXNtmsah5x38ujRPTVdhEMbcQNtxcdkWsP+g4hS66zZZr8mtDoJAi7qdiahGKuvO0OiDXFFVK7GY0FwEnglKvv54Ys9tJTMrNeETd7zQ05xqXLs1YGL+1Q7ASpdqORsAZa3K1fnwboGdUQMqbbQKFG9ouvQJLBma1OIqv5oJLKrhWnsCLil4MspDwNNfwsnwnnvaFIwldZQs6TCYP9bLRs2OCtIuprReUNrze2lFfG1ju0HxBeFgFRbhhbgcWD1Y+PkX4GtTVYkBKPGe2G41xvaqpcX4NxCeFkwcpepny70dewUJCIIaNWj0EvEj67QLtwIDRCtEVWONl9cwUK7Gpk5ngyjqYqjJflnY48lY2HJob/D0JkGJ0y4MOT/YDsh98dZ9x4Cz1WTfLR+E5vsABxwbfOMikHBUo7sWKsy4yNOCDXRA7ymgF7UYeWpe07WLgF7GM+Z/TGu+Qo0iDQeBqkGKxCfO9MwjTgIGcCqIthJkho96mCQ0hlp52PIKE44RVWwqKGbLkTs1FJk4eDquSRvVXMoahl5TZMbqWmaWK9BVxKfz/mBp1RPAXac+mQtS0ZOaqKejxERFrSOIdopDwlxiXX8/Ldy/dhfkCakU3/2BOnyvlWLQ90h+0EcK8JF0OHGTFWF3cDx77SFYypxR/ARjFBnl3V7+q/mIkEUgNGuuH3Cl7gCZnC0YebLfRZwlrDEMRj3CgQzV1hKDF+MZ6n9o3u/cAbGojYAuUPqoQ15jB3wmDeOSQm32cIbb7fx2QNrBBE30IessAe6JG5K3eD7Sv4JkTFkxgZ8q50Ekt4qvg8d+BnqBxDIVGuF6ne4Gq/lqq5OgxCbO4CfmNPRCliouiqbpe
 T9cTJsSn
 DPfwCYm1fjx9qrkP2yjHpejTkGrX+p8Bg5jwjyMEWnDp7PKuB+vkNoMN6BclnucKa4UfZT8o1i1nrJdf6H/qctKFSdlKA8UapsvPP9NHDsqQc3FBEFlMQv43+secgZgFZc3KZrfbUhLn3Yf9bmgUO31+oowjycVcKVckrCP7h8C6G0BDK/gT8x/meuwiq7Ji0Z0SO4qXaYbSqZU/DEuB2/5eXOMPCGjOaSHQmYKXPg2hWL7I+16YFsNanuqu7Jc0+huied7fM8af+qQ5UIjkBPGZ6ZvS5OYwwGnYXhacvuqf10DS0lS3Ar8u1TPJQPuiB3ENAi8t34buruWlW4wPRUwXeSXrTzdA2EPAFbn8PYwPu4xRB90w/H9OMB4+60NXLPkXNx1cvGZXCkoVgtWvQN9HdD1QLMm0uQI6Cf4TXTxnc+re83HLTrVADEMPmw2K23iDzkE6PRcIsABOVGkXsnLnM5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 02:26:34PM +0800, Baolin Wang wrote:
> This patchset is split from the previous shmem mTHP collapse patchset[1],
> which only adds anon mTHP collapse selftests. All khugepaged test cases
> can pass.

The patchset looks good to me:

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks for doing this.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

