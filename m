Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14AB4CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 04:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCDD8E0006; Tue,  4 Nov 2025 23:47:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1467E8E0002; Tue,  4 Nov 2025 23:47:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083C48E0006; Tue,  4 Nov 2025 23:47:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EACE88E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:47:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C7ED12A932
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:47:22 +0000 (UTC)
X-FDA: 84075319524.30.08A35B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id CED71140005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:47:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gchhi4QR;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762318040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZV5b8ObBHmuskqP4QKr/XNVVhj1EcxiETgwZBc5KqA=;
	b=0QEJPi8glQ5nI7PTZk9JZzMaT8ttOB4jJj9ULIjI4uKUj+dNUZ+wXckbITFs1lh3Y8/EsO
	CIb5/mVeI4YIXydEDCoHqQtaAFtD2c/dGTIfr5D88rJLENuB6NS0tKgNg1TwRl+kBPLqVw
	xX4dW47a13hgWI6MyLBrn7a7+CXk5Cc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gchhi4QR;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762318040; a=rsa-sha256;
	cv=none;
	b=Ys6C43XCj1E2cdwRUF4/CxxVLWbXdRTjQzkucrqTaMc1gCiLG4lGEN5GxPGpZNbqe20IWQ
	a2UdhPyldbE+5MuApewjxh3L3b6QImotauaTjY5qpjMGX4PcgpxVcGdQ52phgT815tNjnp
	G0lHqiafHb56HC1QOjB+MbRlBbtfr2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15B056020B;
	Wed,  5 Nov 2025 04:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3EDC4CEFB;
	Wed,  5 Nov 2025 04:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762318039;
	bh=ZZ99cejwp4rpi6lQWuniGgjbQ8xV7HQM8mDIn0ioGLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gchhi4QRF5x5dQQCr5QEVmyfZiLJku4SKlv3p7cJCPx+AToJsZUtjwseitC+Jl/X3
	 pgy9SCkimdjZtZ6XuV1RVG9uEFmnO+gSd7m81JkRSpNxJiGbkf6rYGG1N9ou83voIP
	 Tunugv/CixPlNRu4ak/Gy24LjM/VOjZNZP36stEPxZAGaHANBWayezW5chuidJ5Eiu
	 TEovjqjGO57oN3AN+VwJMf7mYzUG376plcLvyd3VqGc0UjoZ2z5dlHTQ8tqSen/zL9
	 VRZrWF6gIV/zLgXi99GCU1bViPfDGpbAfiXBzLfR/VTZixDsMU3KqoFVpczyitvz+F
	 j0iqGWbO8U+Bg==
From: SeongJae Park <sj@kernel.org>
To: zeng_chi911@163.com
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	surenb@google.com,
	kent.overstreet@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	zengchi@kylinos.cn
Subject: Re: [PATCH] alloc_tag: Use %pe format specifier
Date: Tue,  4 Nov 2025 20:47:14 -0800
Message-ID: <20251105044715.71861-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251105023925.1447482-1-zeng_chi911@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CED71140005
X-Stat-Signature: ti1tr3u18mxcmf1p1itmce4j58iw5uw8
X-Rspam-User: 
X-HE-Tag: 1762318040-176057
X-HE-Meta: U2FsdGVkX19g9eifgRRvEM14xYGcBsAYwpW8Jn4KWzEcWbT9mTL1m2Otyx4KCqGyPVIT3xdiQDIV6wGBrfLIg5P/Lfd2/NgCJDGaoybUFJg2B9R8fiumHMziQ0IAryC4N0YiRfe3ZcOaUbQuPu7vWD3XuYfz/lv9Pvw4SNFkq0Z5HhhSUFrwpdw00qsGJ3R1QCLcPCyKdUCGZfSUC/yUzh9i7WDPT+Qojv0o0qu59cJ+2A1vj7tE3W0ITsVjtMUtcUxsuWmAeAM4kCw20LozEGLsOyeReNYu5W2Yudl7/wxl9UGXbDx3eP0OMmYQg9q/eQ+DplM9RphssSW3fm5GefSxT/sHYLTiqG5gfmY7ABR+lFtd2inMt9M5EYhcK9Ep5Kg8McP0elk4PILuvUwzmkbYTl+uikNfPly2Dopy7Tehcy077OSXapfVS5sFRZA5h90PuB4se2s1mmRKoRYZlJdRFsbm8A6VgyE74YIq4SY8OgnU4cetiA4f94SzVCg8/I41VBsAjQyRfIV1T18TAxL9VjVSQgZ0bt3IyUmq9mjbnEx3K+IK2fZ4nRTxXLyEuv+1bEv+kbp3z1Yz7Dh5ZFOApZaQiROKRfwKPCC5MMvul91gUCcIy57ZK2w6LvxojwX9WSS6y51H7sGDekSxS++PEXWIIe0sRoxzHyxoi21VVIhYhhkmj2Gnb4cjmHwEpeV2htxmuOMUFQNBJyJwnt++2aLSduprhrsgM9wDqPwbiFGzFt5yCaD3T3oJ2Xml6hndWu7vzWguKputiA5Yhu8OyGYfjMMFva7fO/sVA7d9S7m9liamKX059dzGSt62NhQmmd2BpFrJMyGdZz/EVCkGE2wQfYqnqHMlxlBTdFokziz57Kh7AVdm85eUTYUxvushYlD5VL4eerAuRtwe7I0G3jAYyZpjFKtO+lJPRHD8DgVg7IVW4xF1tRqX/ypKpBaL1yKk2tt8PGg8l3k
 My2PX0JW
 vhRODjgxzHtYoTHh+KT/w4foQZo+IDMcssBjhzqVCCjFuNYMAAyhP0du5SbZbeBE8nTWbPTOMOcj4zXlp4Pi4EGdYPgnsK6XRjHSrPeGX3tCt8Op2G1kJ5NVUEzTJxJym5rc7WphPwOgs5iGMuc8UGQXuxVCET3KF45yqrDlb3FMBIJy0rnBTSm4jtr80MVLiMGVyT4xsBSfeZ5qvQmaQ6K83vVdCkUl1ltYA6sjo6lSkY9JuOc+QpYZw4cAC6tnv9/ZAAfg1+y+KCPuhxS6eNhAi+IISxZgEGmgpa7/NDPrElVs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  5 Nov 2025 10:39:25 +0800 zeng_chi911@163.com wrote:

> From: Zeng Chi <zengchi@kylinos.cn>
> 
> The %pe format specifier is designed to print error pointers. It prints
> a symbolic error name (eg. -EINVAL) and it makes the code simpler by
> omitting PTR_ERR();
> 
> This patch fixes this cocci report:
> lib/alloc_tag.c:776:63-70: WARNING: Consider using %pe to print PTR_ERR()
> 
> Signed-off-by: Zeng Chi <zengchi@kylinos.cn>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

