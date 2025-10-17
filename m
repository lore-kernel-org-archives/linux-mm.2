Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F2BCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668E58E001F; Thu, 16 Oct 2025 21:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619D28E0002; Thu, 16 Oct 2025 21:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5092A8E001F; Thu, 16 Oct 2025 21:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 394928E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:35:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C867887E29
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:35:28 +0000 (UTC)
X-FDA: 84005888736.21.C3AA3E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3B10A1C0009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:35:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pKZPOCYZ;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760664927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMiaJal6ZV59D7trBQ4ursZET+1FrsMx1tK9GUDZeGI=;
	b=U2jKbuzF6VLrshpbEWtl7yg/S7vQjPfgQT05iz3uDsgxYK+sbE8lHh8yWjpRRo/pUa1Qw1
	AxiNM7ZvX7+l+xDseSKjNVbgFls0GWuDBcfAm4MuMFn+PYhpIlJxQ6xpcx2CnBbg5Tdcpq
	EAic6dqAk6bGeRgEvpvDNwfBmWTBAjY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pKZPOCYZ;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760664927; a=rsa-sha256;
	cv=none;
	b=gSd8aH/Ej+w/J45wzxAs7P7JiNcNjhEq3LBzYmOoeiiY0NjwZQSnWcdMpT5D+ZOH5Gln9F
	zM4NRcIKAH8526J2IbQdhw8Nhx532HX5zFoiNo+qBhDMfAaQfQhpYhHqlqd+FruT44Gi0R
	sob2DXaSQp8BO5pYuG1aZ+yokGtm6Xo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE41D43F76;
	Fri, 17 Oct 2025 01:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9211EC4CEF1;
	Fri, 17 Oct 2025 01:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760664925;
	bh=joXtVh3UwYtLByf8UHsqtv6L5nl+MB4hmfuzd1U4UxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKZPOCYZqLnM+s0tdMVkwSA8mRl6LK0kIJ2R1Zk47attKGZNEYjAQT1cPyoVpiqn5
	 DiiR2C8HIZYC2vTaNnOBAQoDLeBBNUXbRpU8NSnlR6IyBNRRo5ZKLPa5G6DbvaRjly
	 d62zA2TDp0F3Izc9RRLbAuRbNDKrigUdXrVHkVboSUNxRhrFfLTkX4W71Y8YIwcjJi
	 d8VX04xfxygqE6YawnDzx/9sMGA1TB0JlGZ2WTMWM14gbWWIqaxMyZfwjya90gLv3o
	 A/Xb+tAVf3TydkNwh6ltpdAdVogGdM3D7CzwP4eyCzJsRJKWgFO2nixfTiuyfNYxw0
	 ZPOvyJH87JNOw==
From: SeongJae Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/mm/page_owner_sort: add help option support
Date: Thu, 16 Oct 2025 18:35:22 -0700
Message-ID: <20251017013523.112897-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <51f86d0e-e9dc-42ef-baee-0dfdd39b7cab@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4bgz8tdgz4ecsih5nofnqrgc38i9zgq3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B10A1C0009
X-HE-Tag: 1760664927-24794
X-HE-Meta: U2FsdGVkX18hRuIRSsW3fl8KekipaVWMrewvzGddwlvnRG616Kv5UoU7o7KpYcqLEGunHeGLKd5AizLNsgiXoU2/jO1f+WVIjM5xjzysdFYPiquJVQ1qa/SlERtV0evHe8dDxzQ80r42d89OAPU1oYjwki06VxQfF8dxW18HKSZVg8Vhj8ccizS/vu5G0voF0E51iTRiHIGz4ZZddBpk5pRJjOTP8szWAwzyLpLvytCLGrhbyYW0M20MaycBaRlt6agzzVBHSNDoVz2G9qnFu9m+h4Ns4RcaHScJBOO5eooSXIL65T2guviVLJheJeVDKTiiu9if0p6ZJVmGL+YtBqYLucyElFWzUVLA/b6YRZt1yM+BUrW0wKTqNoN4HQkUHmjgUp+eLUwPzmMmpKrGN8iLE92K3u8YQkA4wIsUds3D6SmdHef/5aQZXKwgP72Y1fFfW/pfCI8aBmxM9i27VTp4b0ays4VtB3h0sofo14oiZeDhT8jVoP4nZLR4QIo62t1bIX3LvqW5ogxJOn7Rmmp/4l7XNQzyk98VvUGTS3cdd4B/aA6URHU6c08zEH9WAATpn36r0VmhpXLtWTEuXQ8mjxEJQvpLA20ZyoB5OmRDGEKG/4rLEam28OtE+A7wXI+MVd8R/I39YD2O36IKqUZaDFqvHAqozqHH1OWFdx/Wxt7QrhwAqN+NZHQIA1/r8LmcbJaVFM1DiQMmr6Rm/raAihrYO8YEhXqmq4QGagDn7THYJdnap5DggCE6abJP3HQL46mVCiT+4Kywb4BWBXaf3e/fYlCAR/t6OJ8ylyrVW38+NWphQYMnup8fZZ53aUivsUSBlzzRSDDQr5vCxaeTUQJDHiuI5mQz4Dh4Qro/YY+nWsjr7fxivd5vAxwn1RaFHLP8+NygIpmkhhP1QnYzkkAIBEFq6B9VOb/zUXBb02iV1x7keRjroLAVGEEm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 09:19:09 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> 
> 
> 在 2025/10/17 04:10, SeongJae Park 写道:
> > On Thu, 16 Oct 2025 13:49:25 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> > 
> >> From: Ye Liu <liuye@kylinos.cn>
> >>
> >> Add -h/--help option to display usage information and improve code style.
> > 
> > Looks good to me, though I have a trivial comment below.
> > 
> >>
> >> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> >> ---
> >>  tools/mm/page_owner_sort.c | 10 +++++++---
> >>  1 file changed, 7 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
> >> index 880e36df0c11..202eafed66a9 100644
> >> --- a/tools/mm/page_owner_sort.c
> >> +++ b/tools/mm/page_owner_sort.c
> >> @@ -669,14 +669,15 @@ int main(int argc, char **argv)
> >>  		{ "pid", required_argument, NULL, 1 },
> >>  		{ "tgid", required_argument, NULL, 2 },
> >>  		{ "name", required_argument, NULL, 3 },
> >> -		{ "cull",  required_argument, NULL, 4 },
> >> -		{ "sort",  required_argument, NULL, 5 },
> >> +		{ "cull", required_argument, NULL, 4 },
> >> +		{ "sort", required_argument, NULL, 5 },
> > 
> > Seems unnecessary changes.
> The spacing changes fix inconsistent formatting in longopts array.
> Since the format fixes are simple and in the same context, I put them together.

Thank you for clarifying.

> If you insist on removing these changes, I will drop them in the next version.

I have no strong opinion, plese do whatever you prefer :)


Thanks,
SJ

[...]

