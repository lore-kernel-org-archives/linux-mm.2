Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73977C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 11:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB966B0304; Fri, 14 Aug 2026 07:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABEE6B0305; Fri, 14 Aug 2026 07:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DC26B0306; Fri, 14 Aug 2026 07:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42A476B0304
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:26:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFDDFA2B98
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:26:39 +0000 (UTC)
X-FDA: 85099647318.04.1D09B3B
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf14.hostedemail.com (Postfix) with ESMTP id D1C9010000B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:26:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="m F2dfDV";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=jA1lc8n+;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786706798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1S9NCI2+tHYOR01YLEaMonDlYZYYqApipw0wF5z4uJA=;
	b=MNWKhwYWNbJx3XxrVdRFfLQTZybsJGobVKxfPAYwBnjzyM6hyqgE3GmoRtntxqPp+bZC9w
	6cCD2A7GJ1LhmMBHKc1MHkeUNhalt3kWMgISJkttbXvZNp1U4SlQutfQ1vFb8u/F6zxu8u
	NvNEqwfAuaUGK3LSIzH3db1Z6lTOpq0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786706798;
	b=wkX5YEuPgbTJof6/pmSiYt4t0p2OlGZS3IhgHsaOBOLQXAgk1MPDQbhtpa7qmdKOncci+b
	7Vip4Hq5ntfoN23rBZsyImaSHXvK9MPem8FOoAehl1bWhY/afOo+ko264KUkqlDAerpCez
	PITlarkySWp0+43IZMz2rBFkpQhaj00=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="m F2dfDV";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=jA1lc8n+;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 258C013802D8;
	Fri, 14 Aug 2026 07:26:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 14 Aug 2026 07:26:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786706797; x=
	1786713997; bh=1S9NCI2+tHYOR01YLEaMonDlYZYYqApipw0wF5z4uJA=; b=m
	F2dfDVt5VsZvn/gKKd4vRJWJwz/dR2B9Al1pwaFrx1p6RpzZNz4x0/cw4hwy652k
	hOgYj4nTDsTQ8SJYcjdqU7Xm8mMWLRMFQjnrffyde11JMqOo0DYgc+ZtkRj1bBYT
	zw4wG3PTtowPyQGeE+0FnE4MXHGTlP7rf1jH4hD/IxpWDbQw3NgWx1qCale+A19M
	5p3uxPeuV6KnB3uiy+XHWnd1SsZ03hz8QnzljnJLFyCNenn7RdjeizQucFy1bmmM
	0HH4H21yCmPro0Y5Y5oN4fQtH/GiD8HzkSEtOXEQUX0NaJcu5iPcDTNGMtbf50U/
	rk+4UOzo4ukuU1QuEiE3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786706797; x=1786713997; bh=1S9NCI2+tHYOR01YLEaMonDlYZYYqApipw0
	wF5z4uJA=; b=jA1lc8n+hN/4w7a4SdbFPbD8q9J3bQ1hGwbiEHqXJKctHuORlXi
	RGf6Z1fBofJn8u8Uh7omkOzx4mBudBClnZdeRYwuQX/A6jrI586OKVuDim3MOLnI
	P1h9qdol6tWZxirMwPkec1PEKSE4UXIWm7XgQ132hP61Atrf0p/jBFCFkfs64dcL
	XjKAE03Tz/Y28FE8mDyzOPlsLYtWEJkI9f+5VlV+Lxdwds7AF81YYp0Reiim9OIS
	iOFszzce5j4RmEwDbTPZAGQH7JDdpetgUcfPKS8MMIJYj48+COfOHZbVfRlQtiHQ
	+07BIB98s9RePak9zX/lgJWbUFF0cmvTaiQ==
X-ME-Sender: <xms:bPt-avm1n6O7CR5cqF7oCwQAQ8P5W8t2W5qzDYcb1hw2iaxDvxwulA>
    <xme:bPt-age8v_R6fhPAU9dUVxSslAHlCd3jxbB6VFPtLI3hTTs5r0aiSgWvKGQI84eOk
    Wd3SMhEZ9eoByXs6YMajcsLeBN67yPsRks9ZHoNl-BT8lTVflsGAN8>
X-ME-Received: <xmr:bPt-arMefDglRGnvG6hEePO2saIHcARy3JeYoFUH3W1zg2261YY8uCioWa8>
X-ME-Proxy-Cause: dmFkZTEoA6e9DNf8/AIkBCVe3C4E+A4zolmZoi+9rifEJTLPQJhzWR0S3AmeiZGHug6S4b
    ccnioTWyHa12kRYm5RXSa90Pq3oqFxXrvIKRfjcxMDtRlRosWwAxizIPcHnnoXqUSfiwbC
    NhMN2gUmfXhomnpCyzpnlIM8G50+Jh9zxBXw8ktKseVExRb03bdQlcFRevvsL9GEeyZ7xs
    8No9EKR34bblH8st1fNGRsr2qmWAJMomZO90nrkTl2DH7S+1eR2+5202NUvgy8kdQP5MII
    gm47x3G8KsrdPEKhV7LqtzYV5moSYCVDWqrgPwskor9yrzsntXhYRM7MoZ3jWI3iym2FCs
    VJhnvJd08pB9xJ21VqmoovnV62v21+vfJf1zuP6tZZ9q8WCKRnXvLldRo+jdJkGwN9SuA/
    xRY7YZi7k4PwrxCRZEt84nbtINUKZZ55cp/Yh0CrF4ZJJuXvfmDi0+4/JER3WkOUM67OkZ
    +lFSSvEltN2wvSBZbKd2dDtthvMAITr10LI04vUKYaV5vpQOxX+jGYF3Jh09UnZbW5oH/u
    d9NcvImq1GwEDmAPk7kJ5IfoybsyrqnoteGVCFXR4d+X7j81Yg6eJu9IPu6ONvH/qtpV5b
    NtEAVxQ+McQ9NcA9IkMxSGaaRoP6aRFLcLPVtDmO7OEeL4mtcQ4ASykyQMwA
X-ME-Proxy: <xmx:bPt-arP3Ts6Thsx6FmRXWk30RwhVRiaDf8thZgD-0jdfLVPMkXeLnA>
    <xmx:bPt-as6YeoGeAtDgTMc3O2gLp9gv-tN92fOqmHZA3NE4Ct5FkKaEAA>
    <xmx:bPt-avY_K4pjy295JDQWY5op1Vu2yXXuU-zjesiGnacobbm4lnThPw>
    <xmx:bPt-akHOwa-vX_exBnEzcNf4vRVEqa0vC4QR59xuM9Mv-cTBeKgfRA>
    <xmx:bft-avLHiGK0gIMG-i0YU8R4JuFQtrSJ-IVVoiAERVq-P6b18n3knxTK>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 07:26:35 -0400 (EDT)
Date: Fri, 14 Aug 2026 12:26:34 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/18] selftests/mm: keep khugepaged out of the
 swapout the swap cases set up
Message-ID: <an77GjsF5Qip60ql@thinkstation>
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-6-kirill@shutemov.name>
 <178663341429.2230969.913958776768961527.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178663341429.2230969.913958776768961527.b4-review@b4>
X-Rspam-User: 
X-Stat-Signature: tm5f48iuazhae393ryng795hxtebhi3y
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D1C9010000B
X-HE-Tag: 1786706797-137912
X-HE-Meta: U2FsdGVkX19wze2dps9Zd349AZoIOBec69gIBsK9Zu9qg3Eihy/TjVYCsFRQ40kQVG2U2GOA1HwvSD/Svu1Z7vDTQ7xl94nAmvXakZOMxSO6W0e4yY9KspOLy0YSi0EAUzf9o9XfXdnxNSzHjYemG6Us0XdBBdFLLfUmxcO8rPQx5wC2VL3WzHorfOajfGghYZjkNQf+GXxARWjBezLDwJ98JyrLbkWCGFFSJHZesP6UZltoNB8YLITT5HhBnjghy2hUyNNX6xNd6lSF3dMqhsIshBGN4El0E7vuSa9eD9ipqJkdBXFAncvh0arfmMUrGt0asXDbjymfduWHDMM147eqZPboP7lsH1Av5VizAdb3KXuEIZtOpDcZG8iGHIMx6hbUTvBriXoGF72vykeqWnhomWqY6kVi/KoOMrKitNsi9wgb/yNV3bQC7cDlRr3NfP9serNA1mey9C5kJrfsFizAInMU0ejc940hBd0p7clqN9J/1qTFlrP6IoEO/gPjDcXAKRSRM2uG2VQE/Qk3U/ZO93fzvAczKXi+rIVQYuoP0fMLppPubD4ruZyt5bKoShT222hDEOBv3pas9YlwzVS5Vnx1m6r+SqmH/L2w06DStIJE6drBfZSDV0cV+ZrNllVwA9p59Z1c3QWexItDcoygQV9siKLr57n4kn0ifNj+KR8FTnrXpKfPqTZm0ElOBQkWGiy9V4RGrXovDHvtO/8JnzU3y0BWsChmd9UiHNUK+mSPB2nbVmHyMk4Y1JsvK9jvPOS37R46d8+fvCH44qLZn2i1GLU2FleZcZ7lyYZRLD4EDZVXJc5/EIDiw7XYaXrgvVOqBvvGJEN1IKWv4tSWDIZOd3cfKF03OtWXUEjg2yFshBzTXyOOoEwUmPhkH7GWTGO4k7zgs5+1xLFivdEzPERxbLYWXJWWAIMCgh1k4SvhUbsDvXrX1IJCf1aDVpnmtrpVttdY1VKtqVD
 m78MZVDH
 UtLp7zGhRQ+wg3KQoF0OSjaTGTXyDGPAveSaBKYcPQMH/ze4qJLftScHcNhln2WHzLYNGe05UzD5eA8Rn/XAdIyQQN7/gffkvBJgOdK3o4fRJ1XpoZlV7WHZNa1NJQDjV4Zz9vEZL+DFJjXRKHrLNJ7J0Wb//f70krCceXlhJd5zGMfGEiZUOPjl3XJRVDx8zcXm9SVPMTJOS+58PUe+MX2tBLycjNh1lbQTvIpXF3jS2ikAXUnjpz7Qvbadpt3SlcpP6zmSajgE69oNXASqkaE6DjAkTyZtCCC15QS9Dql7BuOEfseEzl9yzeKHubMFYcHlHFcVKkmiwFxJBlBRdgmU5zzvMfpfBeAn/p5cxD2nYAPZWjf8k/9PDQEC68u2WoObQZu9+X6IFC1vwGzWCuUjyJV0Q7CPK8J4aa6FOdqTjE6Fz58d5rv37qnhhOmaO8OzcHfsvSX5+82ueFEzQLSiIPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 06:03:34PM +0300, Mike Rapoport wrote:
> This commit message broke me, I'm going to skip the remaining patches
> for now.

Something never changes. I cannot write coherent commit messages with or
without LLMs.

Will try harder next time.

Sorry for wasting your time.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

