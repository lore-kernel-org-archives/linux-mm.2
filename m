Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1735EE776FA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 00:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7FA6B0088; Wed, 24 Dec 2025 19:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F046B0089; Wed, 24 Dec 2025 19:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50F36B008A; Wed, 24 Dec 2025 19:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2E506B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 19:01:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08A31B981B
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 00:01:41 +0000 (UTC)
X-FDA: 84256039602.05.7C3E877
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 24A7DA0009
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 00:01:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ee5Iqnn2;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766620899; a=rsa-sha256;
	cv=none;
	b=YlvhZO2KQpaMJKN6/DuVw9/A599ymQ9c+DOfWnmt9R0SSzxE9NPO4aRh1fxKCRh/Srmrny
	7UAzSIR6FEc1TOogP3vrhrML3HSj/qcke6Fm4KRlrXdq3mVJ1oZyWVhhvypm57FJxW1GWC
	+q+cvRcnZIf/0bd/haMoKHwjGAyTB7Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ee5Iqnn2;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766620899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Id7F+wXHc93ibgG+/wtsMjOVpvvGjyYqeMy6APf/36s=;
	b=1/BfNilDVst6yfGm4p2tVBfajegDI2RKLhAh9V9jjhVA5Uftqf8ybvGqr8UbiMRJGeIHc7
	CAs+YuI093nMWi70q+Abs/zqSwb8/f6BJC1v63+D185G4ZsbUH+p3CMzW8AZ7xehq7rj3b
	UD527lS7NAmpbtTalBrW8GsMFaNNBbo=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7f121c00dedso8427884b3a.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 16:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766620898; x=1767225698; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Id7F+wXHc93ibgG+/wtsMjOVpvvGjyYqeMy6APf/36s=;
        b=Ee5Iqnn2qfFXivYADqvwNgADdsvkEhMMW3Y/JyVT1al+Wk1KizGHV4T8J7157lXTdz
         NAhyGt8UkIC2RuMVPhTYmSUpkzhX62MK4eW0irbfPSzYGTZaH/doVsHLVr81YdtdJQwN
         Pyic8+Xti52411ke8IzFszP99PkL9RrZbwIkdK7q6zRJwk36iYvxV8Ai92ShFrem0hQg
         oWmd9/Ik9xLH2tYMYktF74QqVHz02opC2PAORvWPHjWp65YMJpgKYnm7mmYzIxZN2LcM
         m5+W3vUb+wkqXM8mZ6G+sjTrixPRU1stbfs2dVNVZ0vdeXtvtgH53GgUPcBcfcyjR/m8
         VrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766620898; x=1767225698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Id7F+wXHc93ibgG+/wtsMjOVpvvGjyYqeMy6APf/36s=;
        b=wiCsPKDa0D6HotVtPIf9rgLYkPtleumCvMLiHCH3TfTV4VxMXokz4JNMDgJT4idh1T
         nFkUce1KiH+wLp1xLCiafTK0mS0FE2q3/jvbTGcjDAhFffBj9IknIysDvMaN1ZM5NcLp
         nA8P+0fXJS8RxVwVtwI8wcjnuPNjEc8mi/qgK50zDNlWM0yAhukNbs60T5HkIdqNkZ6w
         A9FleimcqjHu5yNg+ZAMRVCENZdd5v8WhXuVn69Zg/empikATMg0a+jHhzIDpKyNGZaM
         7bqUfve1lAHx8XGO6dsmi6PbSR+m1LAL9IZc3aMzByrdyFb2RirwaCBApeCw2aDr8SLD
         TorA==
X-Forwarded-Encrypted: i=1; AJvYcCWC2m6B3eMUxrXmft5vJeTE0YG+T8h+S+bjAfqd79A6X2jfYC3cIvIYIYet1Aw29y6KEOkleMDJ5Q==@kvack.org
X-Gm-Message-State: AOJu0YwS5/7I0Z1EQH0bUjijvx79VWex5NkaZ08KCklp56Fnl/QYjCBH
	7WTNFQJFTQVEEfpix6J+qmdWglLWDwf43DvUq7DCALRH/bw4Nc6BdJUY
X-Gm-Gg: AY/fxX73wm/nlWmBe/F4O2IrAI/zyocUZOqJ1WcED4a6lWegRK5GNuiMvbFgI1Jnauh
	4jkdiO+jVb58meF8Axhmtke9cg60vC394H2HNuzfg6M3AbQUjBKsQUUULqYaUYWNBeFN/5Lh/JS
	pzdYJFxMpf4UERc35T0OxaYehezquhkpof7hnLPbHbiAZ4pEOW7ADEB8OP6BYgUS/OG+Y9z8bHf
	5M4U+ev6OEJVj+t3a80iM2g6AGD4U79Abwd0XFRhcl79uDmlMagxt6K1DrdNmecFLP18rFFTQWG
	2eKoCOdYi5eJyChugSwkM44uLWTPLFw8V6sTg3V9ilkR4Y4khThz4SrsZM0YPhLIy1NGrkAPemb
	2MEFg7N3ovlwSS/nH/8+uIjSkGb31t4UO4w9tcE6qdsMlo2U85rqVGqU3DCmIvNNwB73qmxHRgl
	ML0nU=
X-Google-Smtp-Source: AGHT+IEB9Z7kBBF0N2XVVf6Ns1PgmyYFeDwaJ/R5IJAH7naZu7p8IB3nqpfo83P0CwJYaTXa/bSbQQ==
X-Received: by 2002:a05:6a00:ac08:b0:7e8:450c:618c with SMTP id d2e1a72fcca58-7ff664814e0mr18371099b3a.35.1766620897943;
        Wed, 24 Dec 2025 16:01:37 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a2e3esm17561219b3a.37.2025.12.24.16.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 16:01:37 -0800 (PST)
Date: Thu, 25 Dec 2025 08:01:33 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] exec: do not call sched_mm_cid_after_execve() on exec
 fail
Message-ID: <aUx-0YAA7QyjUbka@ndev>
References: <20251218032327.199721-1-wangjinchao600@gmail.com>
 <aUvYMRmkWXUuuWXW@ndev>
 <4b221d91-84f8-4600-83b6-a2aa16a02c57@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b221d91-84f8-4600-83b6-a2aa16a02c57@efficios.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 24A7DA0009
X-Rspamd-Server: rspam04
X-Stat-Signature: rpytmakuaqig8y13xnf5ypdg8yc5i5n7
X-HE-Tag: 1766620898-400994
X-HE-Meta: U2FsdGVkX18Vp/yKT5qsOKZ1iGcQ2bXOhpGhSLTgyvnI8hGJDqOeDZ+SbGedn01wKRNzUNkpD/OE9KN4i0skZgbh0nRtePHCVdZYWy2n9k/xrVofHIdpPNzzbeIphgeSFLpzR2nBMgWkGQtEgs+pAVmhT975NBy70HMWR00cEp2FZfhPTZeN5k3eQ+HtdfWWrq+Ir58u+3KNviJSxgrCjYBYlUd0Lf/OAEdymmlIPxEE+K0o0SD/BiWuiO3od4YLEe+IVU4j6z9TjS1rt0kCYq5RV/zVTsTbpnL9r4AOdtJ7osU4h5V4t9WgKBM5fZbVsL82iB379dUWR39zcCj8akigP7SA0bYKcDNMWoYohRPm2wYmbKX2GtKOXpyfi3cCqHLxA0UsA8qcIk5P+pf6VowBg9nisSKYFqEgvwMwt7Qr/XUl+n3vTCp/XnPWy7lkxRJOsW9u8X3SU5sWB2F6bIPKAZxzWmP/yqWkuDExtXw5tGPUPFbAa11KprkdLxSFIRwXa8g97gUeTNB78snAn4063vuN6rhvmDPUlPUA537nGE4H1xhyc9/lE6bW/6YJoijGIK0gL+bJdtwV/vAkR7QqINszezNgYDLc/6rKXNKeuj7gfXzW3f06JnXFGlSVO8+qIPgc3BJgbhpwtEqh+D4lP2VGOkw1iDNLEDtAqQjgKlfN418qEgdNa9XxqBgMI1QOCmV2nGi4hPZmqYv8ckuTjgXjTktxC5Ykyhby1XpKcFZdvGzIyLti7LTtrkoAsK268e3EB9mUPLYAmb7TAyyN5cpe6gsdki5iFEkxajQv0WnZy3snhtJqsljnv44x2xCiB64o+5GPOcr0gJCLcx8ns/tYulvmN/+0BgTdOFwHq5AtjiW+s3dV8b35p+AVNY7TKavFgzFEVkFOKcvnZV1HZQXoG8LtpdXx32fSPrpNXwKsxi0AQEwwm+XzB/v/QohC/4F++OqqCwZXPZn
 K/nGXAbV
 nCGvupnjJrk78C8GxUd8N+wzJAqCFceCtFbGJsR/JDJynrISlhf0ovlpURIaNRGxyyZ8K19uGWid+129vbq+AO9rYPBlxNsGXXe0B9XCmr7ynZ8MXqt6PTNm3qy99TVBUD3nXq0YOmyFaWuVTsSNbpePPFVd5H1qP7AkaHoFGUX+bRvmhon01RPORTSmINKKuGJ5C591LykRT/hzKqJfnm1LY6Tb9EhfeMO57d0QUnAimdqbAZKHNt3YX8QuEciymZ50Yn9JRNsEr75/yAvfkjkzYZ4cS2YFUBuAx8r70dAt1wHfLDftzauhw2LPvpqdLn0vu7ub2VIn2aYxnRcwEGt+DCZlrlmlrKkX/xqV3noPQYt3iVRUIMChxNfNbKpEatQ8Kx/GGArdVsH6tWSJpKNXace9HlZCqvgwht0lKkVTnSqEgDXYLtch3QjV+4We1V3fnkBlEqwTtyvcd8uVjQCLOqBB9lqfEg/5wwbnU0jCJUF3RJaIUodEy/aBWSaoZEw2ihq6VwQpuCk/bX7mI5eecQzZikBtKaZs/9IoR0eChHusOFYmpJpagkMV9v4qm0o46zS0wkOkhYULRNMck+slgNeTbx93yZohXDKqPdxQSfcRPOKwsLzNlmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 08:52:16AM -0500, Mathieu Desnoyers wrote:
> On 2025-12-24 07:10, Jinchao Wang wrote:
> > On Thu, Dec 18, 2025 at 11:23:23AM +0800, Jinchao Wang wrote:
> > 
> > Hi, mathieu
> > 
> > Please review this patch for mm_cid.
> 
> Nack. Your fix lacks context and removes a needed call in the
> common case to fix what I understand to be a init task issue.
> 
> See this patch instead which addresses an issue very similar to
> yours removing the relevant sched_mm_cid_after_exec() call:
> 
> https://lore.kernel.org/lkml/20251223215113.639686-1-xiyou.wangcong@gmail.com/

Yes, they are same issue and this patch works.
Thanks.

> 
> I added Thomas Gleixner in CC.
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com

