Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C4AC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B7A6B008C; Thu, 27 Aug 2026 07:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03C86B0092; Thu, 27 Aug 2026 07:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5436B0095; Thu, 27 Aug 2026 07:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE9D6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:46:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F5B2403D9
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:46:37 +0000 (UTC)
X-FDA: 85146872034.15.2152E63
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7CA6720005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:46:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xdm7fR10;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787831195;
	b=c2TmmgWOWsm4IuCfQlc3GS8DLUOgyhCQXsbooeyYWKKK5Lx/wgoKE/1s2r8D4MMewgmaiF
	cl0/Fd7CX/RQ/Y9mY+VQP0At8NuoLDgONmAOJZuy1CMtHNWtrfGLNlUNES27e07RRrkZyv
	iPB8CmiUWYVh7lECoJVpy928YRCao8w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xdm7fR10;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787831195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNGDPBQ8JRN5vAyY2IRVbV0Nhd+lqM7ZLfcWQUHQLZ8=;
	b=BMCkn64jbVNZAWZbOqLOD99/xRDLbjeOOvBYjjH0YnmpQoTS5aNMVLw2RargVErkwBeRq4
	mwopFqcB9XIkv9fEs94aII34Tth8qkGTZoIwE5zt4A60mSOOb9wOonfI0jsI2EclP2Vl2p
	0Z/Ru60OkSC8L26OoO+GAFa/1Cr1vI4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JBIJeyUF5JPm1xBAG2oWZhraynj8nQuauqje5HNBaf0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787831190; v=1; x=1788435990;
 b=xdm7fR10r57jOvscsWoyHopzQ2wylljneP3Kzur9OjlO7AG6kh6Ed+AFUxT0iuRXZOJFc1vp
 9CTFQr54r9ssqqYrZquOiXk5shGCnwpO1l8QLKq+X8WoxLYxq24IullCAe7bAvR32wsDD6nwPzb
 6nNT/hVF8QQU4t5CHTIp7tgw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c5776862b8f411c9;
	Thu, 27 Aug 2026 11:46:20 +0000
X-Mizu-Trace-ID: c5776862b8f411c9
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add myself as a THP reviewer
Date: Thu, 27 Aug 2026 19:46:08 +0800
Message-Id: <20260827114608.4342-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260827103435.1371882-1-kas@kernel.org>
References: <20260827103435.1371882-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: idmikb6esudnidssygomoqkbui751cdd
X-Rspamd-Queue-Id: 7CA6720005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787831193-94548
X-HE-Meta: U2FsdGVkX1/QU/phoPQszrL/xM7F4BpkbfvBjnyh1L+Rjngy+RU9oC2FIRPFcbcnyGg/KPZoVAMMvgHN9aSU/NEkWfmKbrsbczou3zds3P4E0aiWXtZKO3YiTsgrROriUeCfio1U1ZM4YgQvIQvNs8b603ZGDci4gsxN9l2SrXdsgiGwoIz6VbdTt29CD8OwuCm5rGuzn9z0iduWRbGJ2gCQNU3iJ8jC7S64qaRNuEGDSJfGOmiftKRN8donghNc1D0zJhwItcKYCkulOP28hlx4cxrmlYiPy0xy8Vmyz1eap6IgPzDjQ+t6fxPlKKlje2UnKgLeg8DiWfy6CXjrEY2HL1lvdFc7BTZzHHSX9DoMTaqd8fuirYtO835scyf/OObojJevX7X0HpbvP3sGKBrazQ0i+EjuUCeWwF+Y+mYUKW/B91qJHN6k8z6iF3POW3ygymKab17AYlrsRE3ZcdMP+9/Szhr8EhEvx3Pf1mXkLnFIDpaXY2xrTOmDAu0ZOxQ8EMn0RetW1YiWd2ImtKm2tiy/Xld5INw/XDZmC8fht7CQNFVqr7F45RVjHYhOQHtVCvFkmzJO5pHncfxDaCw8/zkaLbsNPNs/Tz/9X6qy0wt3qFUcueSf95mlqTLR52dv4zhIRokQ0ygLPSKX72HhEFc/lC7//MscFuI0HTlztoxxBqBEMwl42fi1zZZghn0TQNUah63jAvDjE0A+hKJxOOICq3ZuURC2fVXG3tzQsRkABPWBK8FMcw4sMhvGeAaT1+bBywHMYMBSRpi1XqZ4fY3m553yv09RwS1aZiOpDfx9uyK89E/9wjQinbcitUJ6ZwhxYW2JL4HXZ0baH1aeItGm7ZvavYtJ3Zwitjm0pf3BXKavdiQTN8Bc9FAYsK5z6IZrBlJQSNmjBK0mEWJ26GEcA3DoHsFVDQg47CHkf10BREAQQ98lsb5TtjUMcZsaCK4D+M5zI6RV+P9
 pROT+0tG
 EMAeb9D9jQDupGn5YyRKwLqS3Y/WAjs3PlTmQJ6g2KakSIuhuJBJo5qx1OdjXC+GHg7Q2ZZwKu1UwwKSUMT98B8xxz70aGW2VOBrI/jdHn5Oc/pPWAhYFNDW76hAEb6kZtGBNau0BVw1xZA84sIXSlizWSgQ7HRt57tkEk7aNCo88FLPKKh6SWRMdr5oT3xSq38Ztm+xIFG7t7OjAfJX0AS8AsF+U1UwJEXgrQF7QcE75v1VOtA1bGtpZGZAkScUQpBXd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Aug 27, 2026 at 11:34:35AM +0100, Kiryl Shutsemau (Meta) wrote:
>I have been working on transparent hugepages since 2012, starting with
>the huge zero page and file-backed THP.  A lot of the code that causes
>pain now traces back to me.  It is only fair if I share the review load
>for THP.
>
>Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
>well.  It is also my commitment to be more active in reviewing this
>code.
>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Welcome back to the THP party, Kiryl! :)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

