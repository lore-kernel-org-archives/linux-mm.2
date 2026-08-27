Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395B0C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886176B0095; Thu, 27 Aug 2026 10:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8376C6B0098; Thu, 27 Aug 2026 10:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74CD36B0099; Thu, 27 Aug 2026 10:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52CF16B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:07:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF67C1A042F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:07:15 +0000 (UTC)
X-FDA: 85147226430.30.CEB76EA
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf21.hostedemail.com (Postfix) with ESMTP id D503D1C0017
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:07:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k +WVhfA";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Up7ccU1j;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787839634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3Dh2o/3HyrcxPByYeYJukS7fILq/peuiJJwPWAvDzQ=;
	b=We46pGkte5lS9ePpJtRgcuKqoLZUHQoxf5W2uH3qaPaB8g77Qh9fGetf96jVsU+9HPlfxu
	DTfhJud5BVxQT8R/t5CcuNbjMj4F+regPARI8Y9JkmFH4H+PpN8OfaLC8Do3WvoZlOJnHp
	WP4ojLea4mvPRCEZP0yl+wz6oMr6p3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787839634;
	b=yjmWOWYi3IkdwnqY+wNDgKFYcI43fCzb/mB+WHKDtapoZKilLjeNVAYj8YZjPdnex3+ARU
	Zprnv7EFt708PQ9M5ooX5qCni3FvmpX2mCJdSntghUe5uZSl7vkIi/TY7FtemAZ2r06EXy
	wtW/qwk2HXWJ6k040gXMsToES7E4fU8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k +WVhfA";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Up7ccU1j;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4BBD71400151;
	Thu, 27 Aug 2026 10:07:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 27 Aug 2026 10:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787839633; x=
	1787926033; bh=G3Dh2o/3HyrcxPByYeYJukS7fILq/peuiJJwPWAvDzQ=; b=k
	+WVhfAHo2YaBEPZMooT2RGIZUpcB1FWU2F9wSfnw7MRC4jTgs9qn5VDe3OuNJ4Dj
	fS+Vw3YdZoxuLFk52Y2G6cfXQLTE366IVCjrzlVOHaG/lVjLoSfuli0aOR1tJk3l
	LAETQmeP7bYOaLiymSWtFk5WXteVzqd1xzpeN/0/xPX9qXZeA8+ZPF62EzSD6gmm
	lmJwxEYdzGlld6QDJIAEkHK6mRgf82xRKs0b8dcT7NCwO7nXswXhF+Qqax7z3qSV
	OUH/0G4G5eLFi+9P16Uy/pc4YC+Ouu++VUflnxV+N20DysZ3Z8mV4h7uq43vVsXo
	DY0v7xf2nPyUCwGeT7t7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787839633; x=1787926033; bh=G3Dh2o/3HyrcxPByYeYJukS7fILq/peuiJJ
	wPWAvDzQ=; b=Up7ccU1jT9GuRd+iGBKZ2+hUH3YHU35EP+BAtvBZntcL/xyTz5U
	0X91OB2BiFiKMBYUJ68X+hjHM57ntLqW/q6SOUQDm09+jW+udxYbStk2lCBw6BWx
	jh4FwpP+/MJD1t03tNVghVH8jv0U2Io4EmC6+TDB3JddVstzg4ttxIJCugPCe7Is
	nF2cDNVjTA8egC0OTfk025BpiDauey1IPPD5Hpt1/k1Y3Mvl+l2iw8/tyJ3Xwr2I
	fFI+5cTQewhfL7zyVhVhh6IDeZTWemLiupaxCNGZbYifKu+v8qVNb/uepQvuLitm
	wJcKqMJsdpLoSmSUwu9dLyir9bC5ZgDfbsQ==
X-ME-Sender: <xms:j0SQatZREgDKupZ6e-QiI8qPyZLTUVn_MDtJgaFlhpoJIl3XFGAnrg>
    <xme:j0SQamxCDWZU1nm8SrPjh4NyrxoTGnwttWx7zWxCf78hFXYd0uuBZBg_lJeuyxjqi
    AVTlWy0HlJ-4Necs0EK1HVqz4YPIMTFXgS7MZ1S-gNCEi1FPQ2Rqkk>
X-ME-Received: <xmr:j0SQapNRdTp99qK8rpvfxeAGVLUpaSzaTS9wcqrAChpex0QGgmaYbTofE0U>
X-ME-Proxy-Cause: dmFkZTFGSW/RJfX5fFLiJJB5xonRRzVd46tFbFtZOtPw0QpDPCnI5vfoNCDg0AQK4EaV3w
    6GfGtBxca2h0U4zuEcIoGCk3U2UUI8Udn3EpP4OXFa0hB8BMDqQeZ5idZ8pZFAKqjG0QoU
    BLTJOcH1ViutYOCUhUny/Ca+Ry8gP9QT6/7XhX9q1pHvOPGGPgZrn3alTue2quOKF3x9B7
    pjjpFerKzliWyeFmKmU4r3eZG4uGomhOD4g59ZDLXyD0L39QPG+2lXkCPhTmgGacfqwlqt
    8HieHcppXor1VEzneMl15UHX1u1FF/m7aO0tg+KPti97apdJLSZiHwRXR6hXJNYJKLYOaB
    8FSwVCXbuYkDkY2CnkT5ho8Oxp9reXyVTpZxzLLbsO+VZ8GWwbZdIrYqC0166pJ1iDRt8u
    VmeXqVVsbq8gWBxinQOq0Jif6pgnFtK17BhAuCwvNDvjIXlJ1fMtMbWnzEhRV7Zq1PG8S4
    RLiAN9YDw0797axKORICyddaeWUM2/UhOyjf+OnB4kP1VspcwtbxQkmidGyWiJ4pKnaqZ2
    0QU6XeZmFZ0IC/PD072C8qNfv+zE35hV4Mg1TVHH3pXU9LnnXnKXBgdxAHQrkbcvi1+Ses
    wxvZV310nAUqJvdsiINUF9t/VOZXtsWebKqTRdJbaTQqVEHM+LYvaAI7k7wg
X-ME-Proxy: <xmx:j0SQaux4goRFOqWJjSufhN5OUvxxmwz1NJL8WuxvRF1V0zC1bTZy-g>
    <xmx:j0SQarCNNAcIciXtLnLi06MrZG3QWyAHE93vWm0bvddUksdCQT3bog>
    <xmx:j0SQapOjsbQBzNitLv8HTOlQEQQTIS6B2PVJADRC7xz-W4yKJppDeg>
    <xmx:j0SQasZNuxNbWpoOubRdWp8xFFZF-e0tH8c4ysDKcG3QQd4rt01sTw>
    <xmx:kUSQarhEO7Zqa5q-8mUjV6gui5X0-wd3vjcxXTeOSmwKaiS6FSmIFGy->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 10:07:10 -0400 (EDT)
Date: Thu, 27 Aug 2026 15:07:10 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, baolin.wang@linux.alibaba.com, 
	pedrodemargomes@gmail.com, akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for
 swap entries when collapsing a mTHP
Message-ID: <apBB01VBbmV28gWP@thinkstation>
References: <d02405a5-1d0d-49d5-9056-1a34ccdeef10@kernel.org>
 <20260827121151.7837-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827121151.7837-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D503D1C0017
X-Stat-Signature: aabhswrmsawiyij1pcwmo65m53xbcaue
X-Rspam-User: 
X-HE-Tag: 1787839633-232392
X-HE-Meta: U2FsdGVkX19U123VWGDPIN5drcVVB9ACIQjcPI6I2LmiHWAdP8/7a3+U8WXDURjUAV/LBX10nORP8shXJ8YROeA9Qp7rUdqR/oZcMw/EsSe5r4KFwKL/MY66VbpbIcEHp/s5baERo7qGCUnnhaIc3cd6MIQ6sMqe6jUduRATzbYlzKSIz95gqYx5kCKq7d15sBbxLzNsX3fu9kcf2Pgdbq9+eVyQaqjkDyALVJoeiJ5B/bBV7njSfDGuT4xYCjVAi0uMjxZLOk2jUiEeUPjCdCmqmZpEgEAeM20kBVDXVmKO6AGdXy1y9BLGQ7/GKa7HFh840CEYeIXDr0z7ii/ka2kVWYUmS42Aby/C15fevB6orwEsTWv5N8lxzUub70dR+/rGEankE+OvipSbSOwQIV56bT5YyCJLgB7+THQiEvIE9inqBLHhnzxOfVJ6fP2grDLptg1IjwaBB3IWN+dUUFeQT4vj7bZpVZpgBg32l9b/gIonwyfll5n7vcBA5akk0sXJheHwmPASvGzHOmNvwYux8TPRgwoEmh7eNR668+I50gs7EAzIojdRhOklTa1k9TN5dEg/IciaU1BPHlPymb13PMRwIAAmLF9AncClidnj8cdDXWnlnfoszIaIHkEtXBax8SyhhIyHhc0WATX/3v8ufVUQH1xJrsW76roLfyWoN7itoOVm/TMrD1I8CMhAcj/1e3gXggJpeOcdQDK7DefyB4ditonLt63Y/LefA/3cwEWdIlhGeRgAg8v/6xeIHwkh+9gFHpVsNoTjLZUWYW9YuS+3r/PlxIMGnRWHEM/NJiCq6GJ3qO11bR6tv0DlnJG+5av3fShTIRM3xTwivmNYRFg71362VNK/QNsbC+LFWFok18+/xtfdr0vzzN4lCXBgjEQTfkn3k+NrxDIcqGvwLMez/1NEb+ssYyyYwB9n7p1fP+uqChqU5SGZOZbI5UixBBpes826VqgSC2f
 MFb0Ixiz
 GwXSsSqz1XLgagpk33uVpP8BzcxhXb1jDCEVzsWc1NFVVHV87+j1U2ecd8Wf1oGUVjmxxDj3jouRYv/xFSzgyXaqPPsm04E+ZE6jRaBj5fAMkTA66ur/YgceLHtROs9UCzMTXUK40cXhCZBlaIJ6mm13m5OCx/zWjYO4TRyZeg26jKxH/xlT90JEpC2Kef6NbQ+iKBsNxzzGRISrH5472gpxud/99dMG7Cbs2otYcX87Tx9BDzPxgrfxnBogys8gbxTh39p4bxj/RqoF5ojSXCTBvNX++GeIxBJTGFgNhT6cjfJuvT7T/fS+E857twE7FL6HXhhdxWC9xnJfkjVaQsMfOLMqDYumAbZIOGuzAGcC1w3mdo/dB4CBEz8wQvHcefRx2EfMkt9uMFRpAtL1v65mQjyj+ZCj/+wXZWwB68zvO46MoSIMtv6q8EXtRDsG1rdiZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:11:51PM +0800, Lance Yang wrote:
> For the candidate above, the loop only reads its PTEs and returns
> SCAN_SUCCEED. Pedro's bitmap lets mthp_collapse() determine that upfront
> and skip the walk.
> 
> Emm ... as I asked before[1], any numbers showing how much the extra scan
> costs?

With the win being only some scan cost, I don't think it is going to be
measurable.

It can open a path to future work. For example, we could find fully
populated mTHP windows in a PMD that is not eligible for collapse
because unmapped > max_ptes_swap. Right now we just give up on the whole
PMD in such cases.

But there are more wins to gain there. Just saying :P

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

