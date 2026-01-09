Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8482AD26D9F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 21:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46106B0089; Fri,  9 Jan 2026 16:40:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C126B008A; Fri,  9 Jan 2026 16:40:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACCC6B008C; Fri,  9 Jan 2026 16:40:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA1166B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:40:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62B5F160B99
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:40:48 +0000 (UTC)
X-FDA: 84313745376.22.8BBA66B
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5954114000A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:40:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=n2MsFikn;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf26.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.66 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767994846; a=rsa-sha256;
	cv=none;
	b=VpWRDl+fXmbanCeTaPyFZ3QR9aFTeyWOc9fLUVTck1T2xUU8oAUsjLt806BxUE9vxRVNYq
	8XX2f5ektZZVsE45/eOUavBDrMjGGUhTeAj2HMEa88/IkaH0IQ+SNhfB4PFfMfEyYf/IDo
	o1PdcXC0ciKGV2OI1YV7Ve4S8wNAO/g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=n2MsFikn;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf26.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.66 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767994846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCTw4EBCGwVONJjQmcyN+IYawg2li4nH7oS2Xxt6ei4=;
	b=M1K6YgdbCkwGlYq+Ua2RYsWO+DnqA6ydCE1wemtz05rCevacaScRzo2pMNG+Kko6TZsIBh
	JxWfnu5ZMyY0BBaTE+ZjbBx9/zFKHypJEKZbzlw7Js4fHp875eeK56c5WaGCpxZSS6EbPQ
	ZlvknYcxmzjwx1IsQmS4/7/KhBJSmi8=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso28780585e9.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 13:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767994845; x=1768599645; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sCTw4EBCGwVONJjQmcyN+IYawg2li4nH7oS2Xxt6ei4=;
        b=n2MsFiknx8zxqQfkClpdX9W4AZZGAXzTzDOKcJqDL0Af6wVsuOIpHn77tmqagwV8S7
         gJbD9x7VfWYZ2+lN7Eo5Y2I1jRSQTF61I7Wnd5iK96QfRnxV3PSHsEVqc4bB8yGvYXoj
         MTEvs/xfyy+eg8zEoQBJhK32HSO3yNqWSZu+ErUsthxrbZo8WUL+XLIF5TH7iptZhq4g
         3zuwnpF2eDX1iNLJwf5slZbrf3igBS5CIajbcYSbnF+wvYHwjlvKefna2klvK9jLJLbp
         baahqzC8+o0soI8lI9OuYnReaRI1LYR33TZVpGu8cDUI0i+iqx1KFSnDhFp5vG0GUx+f
         AC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767994845; x=1768599645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCTw4EBCGwVONJjQmcyN+IYawg2li4nH7oS2Xxt6ei4=;
        b=K5N3ho2ufaMa+ss1BFUaAXikjH7lWPeQXtSpH9SGGFrWGBO02rGT12s7om1XKdr+tF
         Tbjmw1z34bpXxesHJbxjGhvTFbPZH4wqNF+Fw1f4v54TVmdjWzMOCn4Ywp3pmvFqH4eU
         aQq71hJ59vP0rsI6XaSiP9arYymUexiVUFNKPUGgNVP8QHmYUH+4Okc2rAkgK+EbAFIr
         R/xmsbIv6+V8+h9keULqLy1oi791Q2vxRK0mk+C4+740wY5BSXxXewx3gdSemgYnd7Qe
         50CfdWnwsbou+gObw94mXZTgNpfXORVeqxFR2VzrjjSGyA4ITZadt8mngrJVdKMt9ZAX
         MRvA==
X-Forwarded-Encrypted: i=1; AJvYcCWRC81hAiTQT6zkezsDQ7XA3QcihHs8Sqsh//ExemDAB3bvECYQXk78rPyVUMHJ12Eq5AAvj1Om6g==@kvack.org
X-Gm-Message-State: AOJu0Yw3KGb+4giWQY4sM68HoilONpU89RpJWT0SkdqQjI6HEa1o+BP/
	ujhGkgAZ2NPyomlSIMAZ+OKxBY7s5asFfmql4GFthIAfVVKPYBRFNka09HMq2zNZvUk=
X-Gm-Gg: AY/fxX4NCFV/ZTY5AoZWSfTXLK7E7XI4hiRQoQmtUCfHx6NZWdO0+1hvRWBQz4wTI7A
	L6GmYLzd18fGPnbKayRAYYxke6Ysj3p9tWIESVyZCy8URL7TxWUWZ97tEArIKMmq0DVGtqhUKbX
	YR/eVsflyey/gjMVe3gbZXNBl4r69jiIUwBn0B+2zHnry8ttXmidIUCj4YLlVg9lheQRSCdtdRr
	6ND2XI2m0Jg9813Zi+4OK3jUENOdNEVsh5XVoGcnFouNw8zgeHOtSPQni77MP3Lv18iwvX/705Z
	xBVuJcNEsXm4Uspi3s3SA8HobMBKAig73YO9MUV0mYVuGjDdG4cxMfFPINrnY3bPGvsiHDLfx86
	Gi9TLmSnSE2wOQoyWly6k4FvdFNm/LCNrh/dR2iwyRUovU0LopG4k3A3e/PaIAbzt7sd0Vr+W0D
	f0/khoSvg/3GkmHpqu
X-Google-Smtp-Source: AGHT+IHZeutMutt4esVNRapvQ9J/Z5RqsU8ZQldTS4RPxGqd9QwuZ9aFqAW34NuikYYDRpVsKKDUiw==
X-Received: by 2002:a05:600c:4fd4:b0:479:35e7:a0e3 with SMTP id 5b1f17b1804b1-47d84b3b687mr128511495e9.30.1767994844639;
        Fri, 09 Jan 2026 13:40:44 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f68f4ddsm235668775e9.2.2026.01.09.13.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 13:40:44 -0800 (PST)
Date: Sat, 10 Jan 2026 00:40:41 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: oe-kbuild@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] tracing: Have tracer option be instance specific
Message-ID: <aWF12Wjv_MIKu6hQ@stanley.mountain>
References: <20251105161935.545400234@kernel.org>
 <202511071533.domGENBS-lkp@intel.com>
 <20260109102301.19daeb27@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109102301.19daeb27@gandalf.local.home>
X-Rspam-User: 
X-Stat-Signature: hkapyrd8s1zp17ny9xetiayma4nyjcrm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5954114000A
X-HE-Tag: 1767994846-204421
X-HE-Meta: U2FsdGVkX1+tEDAiYAdlsVTEL4M6AInEH5JkIokdDF70sVcI0woWj6Ghi24n96T04lzEwQSezdo+2eQzdtz6Mjdlyp2pTaAZkdBC/oScI3VYQzG9pat+pXQ/rx+x7e66V6GQLscSE2kAtCeDgS3cvj6cF/+wJpKusFGgU67NiyZpOCy7HK6OWrOWFxtxT40rXZlB/Us6fhu5Ye5UgVuAc42LCTTuliK+0GjYs6t6kog511nZWW8xGEFGE83UY7eGfTWFWJGbX01Ro85uiTnFCTNA6nW9ElOHht5lohEfoHGMQf9qxwp3g6+mpBhxLYU+nYKZoclKyIOr/spo1ugmnpW8D/9QMfLoP00nF62oXORttr/4pIlPUb8g7CutcG2gl8+50f/H6vhbtz/rWjbAp3ZFwc4k7YqhvSv6GNgpkeIO9+phIBB6D4q7fOnruUGj4J9YBUTfKYl3SMGGa6OK1mqJqRei2264hS5RhssGk6xil+ghqMIhwuxg4wyn8BhngrMowic3mxy7Q1nwAiPsG/AvIyOy/3aSF+oxzeZwlBCjdOoL4nz0/JO+Y98SKtq1EThFNhD5sa5PISOkLy8eJXVpgnfQ5My6SnIMw0G0XM4PTNqwNxukOBTf9LHVA0wtru+YM7o4xzawmND/wson0GBoyYsXlqCtwk3fUcz4Tl8D3Y3RNrDrqy8dR7KVNjMjTVvwGGYvde2RbPOdX0sWIzAR2BBkwGov1wqkg0j75U0eiKmVnOrlEN/bRtRyQnYUhRcsgaiWoltRHCpeKBkrTlQqapuBMfuj/tdEW10RoQ+sbRuyH2uuIgjtDLvybBqtSGqy6ztfAsgkuaiNr3hfjdoAf3Y+hkeqFr4Hrkg4EpH/tOcH4emss5qrUXx7nluzssG0l8hZunTw/bEfUhn+fK7Eys5bQhNnnv8PdF5eYRVJFUAVOfmFMM/xLkYTI23tqk54pE5RmzCsq1XFXim
 PShrFs9k
 NmN619FZA7HjloJdP6oqfIRRMgmMBPGo6EZKZMIkX3wCi/ghiOdpJ/lm8dhBvSiC7yH1WkZjmZ77nsc1kBInAavKp5CLEOyK9AImfXRVhRQXjFbAU3xwY9eEdCZv3BnvM+959TvFNdEm+Ucz98XfLytJURhf0V2tZ4javbgLNpg6j9eWLzd9mWhaqemyhwU53X0xoc40lxtT/B4+9TAt3WP0sTSofKxCgodlPyOy6GrDDJr7TZxBzMNjJcV9ZzG4T9NI3xlqwQEHjYDrZ2xwwOl/v/fv013/pCoQ8pANbcfwYkj/OuaZsIy6bFHXlyTb1rILxlIZPa7+XsQ6lOzIZpJ0LUB4axGpLM2S+8FulFAzbewpLs6VbKeHXSXzgmG73rTq9j7I0wwJOTwBDx4CAVdh+HGjORZt3LRc9tkksnHLreSQ2VmY34uRs/TxNPBuV7IStWgaQo8sCXil0oozgoMTD8YtyxM00QzoYriGHp3QTU/X+GS1mRtV8TYnGOL1TOqHUONE35bjYbSb0MWeLnD/ycQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 10:23:01AM -0500, Steven Rostedt wrote:
> On Mon, 5 Jan 2026 18:23:31 +0300
> Dan Carpenter <dan.carpenter@linaro.org> wrote:
> 
> > Hi Steven,
> 
> Hi Dan,
> 
> > 
> > kernel test robot noticed the following build warnings:
> > 
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Remove-dummy-options-and-flags/20251106-010511
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
> > patch link:    https://lore.kernel.org/r/20251105161935.545400234%40kernel.org
> 
> This is an old patch (v1) and v3 fixed this issue:
>    https://lore.kernel.org/all/20251110234341.767135255@kernel.org/
> 
>  and v4 was applied and is now in mainline.
> 
> The patch you are reporting on was sent Nov 5th, the fix was sent Nov 10th.
> 
> Why is this sending reports about an old patch that is obsolete? Is there
> something wrong with your setup?
> 
> -- Steve
>

Yeah.  I appologize.  That was my bad.  I accidentally was looking
at old emails.  I think this was the only one I sent, though.

regards,
dan carpenter


