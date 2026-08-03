Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A6FC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 21:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ADD86B0093; Mon,  3 Aug 2026 17:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6858D6B0095; Mon,  3 Aug 2026 17:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2526B0096; Mon,  3 Aug 2026 17:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 293D66B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:24:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2B8D1A0829
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:24:29 +0000 (UTC)
X-FDA: 85061237058.27.C086199
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B439E40002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:24:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="sZjaW/H/";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785792267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/s1uYeP5LpdSxptfZq3KO4hNuSZaOPea27UnwFRZxA=;
	b=jMcOKiqCS+kydA20fAhWQKCT2JyLhLsjzpbF/GuXD++sFx2GudvdHhn6wKBz8xQX8vTcP5
	fgXGvJzRXhNY41KhN5Q/BgIYLAewXEbzT7G388sFH17lxGg+bxMkQDhvOWAHSnd9gkoUPV
	IpRLCm1DO+zPYmlHzq9SHxV/CBRKRHw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="sZjaW/H/";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785792267;
	b=S19InsqXVpSAcS99ABUnU+y2Hk4CiJpULK1GPpIkkV59YQBDch+WxILroHlqYPoTCvNQe3
	X4yj8EA4LWdAbQ6V00pWNklSE/wofamnrRgcisAgxICt1cmj459TCJXqpdQIhu1HavhBIe
	xADyHdgFalkkZGLu7OKH2QXyzQmcjKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2AB14192B;
	Mon,  3 Aug 2026 21:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C981F000E9;
	Mon,  3 Aug 2026 21:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785792266;
	bh=4/s1uYeP5LpdSxptfZq3KO4hNuSZaOPea27UnwFRZxA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sZjaW/H/cSVDuDuRANXP6PrJ4w6e6HndnsBqWTNR2Yu4OEEN65acPJrTJ0wrLZJnh
	 qNcwSIWTTbpX617M5tJCF0pvSFDa5KI0n/GQDPkAbuqIoyJGOWQcdMtK6WWHChI0Pc
	 TJDfdICPEgG7k2jGJGnYv2GYpIjRYo5f2DZK/alg=
Date: Mon, 3 Aug 2026 14:24:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 0/3] make unused huge shrinker memcg aware
Message-Id: <20260803142425.fd860e19e77a11ccc3c84439@linux-foundation.org>
In-Reply-To: <cover.1785746588.git.zhengqi.arch@bytedance.com>
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B439E40002
X-Stat-Signature: 6hn8pjfmazysorgr6iaqdkkfqkwn374m
X-HE-Tag: 1785792267-324046
X-HE-Meta: U2FsdGVkX1+L/p/EffSe/yLB09TPpuIkIFCqcR4Q2dtx8dfGS3An1I5BspAKnsxv59BdWxXehkrwJoBT2c9fYJjefVzJQtTa4zK7RKQg1uZ8mFtjm+dP10Ap+x/47LaJZcLEKG0YD/r/0yyq4pYqNCNsIMhbhWjwrTYYXBqkW8CvGI4ObYsLaRcc5uOjSrdYK8i9jpChOTJmcTrq092gxrBDKl81tJxXDNfmjjWGTDgdLHLNnylGJoqDsUkFTG/X7iP/gcEwDvC1ENV3lVaCD5bfcg9O417R4YvXBnn6cRKAlfLfU69ay6j8IH0CiuNXiOGWgvIAAA4DyWo+wPm7yX/k9XEgjui5i3pxjUqzZ9QJyf1Ov4UdyoMvsCj+jRNhwImqcHy+QEDZe9PBmCvtTQawkWMvmAyLm7Oc6UvOGHeq1aRjSj5FQo+pTEWw0klys0LQciHeBg3MvZ+XQVXfnsa6SWgSU2x+gTxv8cU0OiMkUkkk7Us9BcXJfHMMRBeZu8iRtibwq8ZlokoP4C98Z7z/UuWxy97VjZYVo8C+sWosO0QvaxVLm7zSZd/SGyMm+vCeUOkG9SQ/3WCwAyWJkaDB7mQTVX+VlVQVwMsPFsXG45QMN2EB8bAtEZVPYN/IN/xPR7sN0hqs2H4a8L3oTiu6/hX3zwl9JH+/Gg/ARQANjOrdRxwH+YdyJKzAmsq1qM9DTU2pw+exQG4DAU4nsBVn+oJeDo7Pl26YHOBu/zK1p+SPfVxO7iGKl4Ulc9sgZIvTfmok58gdGzaCQ4hTid+ktpRIT4IjzW4Qqqos0I3NGrThQV8z5KKRvohwFX+ptNaWjR+VAdsYVQHYLZLNX1Kvn0nrsH5cF2JVYrLrYBWJ8z5Gyp/8VLzkj5uoESjVQEuGZIxplUYkfcb+zczYciIR4BshUH2P2DmA5CQnWJ3ASORDE7Q00P4wHsqer9EdAXx9cgQIGSkByjQghRA
 oAJ9hCcF
 UTYpbTdII5eJOuyvR1BVhSjQr0EeRP2KxrId/JGwlqba15Prpx0r6mawOlyrzw7GNn7+x0zrLTAHJ1V77iSDvmKSaYW57pGe7C/0WgnMofmL/hot1PbiOslrY2z9KnctG90+7dboSrzYYrsLJe3YkmocehaA12y1UXLWkYEemk4D6qQE4QLuGcDWy0p2c/se6bvNcqXC73L9IOz8CD6FQi15UFHtTi0UgN8Vp7DNO+u/tsMOp977/9RB3BwqHw0Ac+y18EGpGc64tI9kMyzTdy6HTP53ybmUto11GZnC6thBSDobZXUj9uPzZqYMVBUWotjADytkjrT1RXT/8V/MGJ4jAiPCJAyLrPcoCuoc7wcMrinER9lja0+i4JD8O7G86xx9H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Aug 2026 16:46:32 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> 

What David said.

Also, AI review might have found a couple of things:
	https://sashiko.dev/#/patchset/cover.1785746588.git.zhengqi.arch@bytedance.com

