Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D671ED29C2E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8DB6B0271; Mon, 19 Jan 2026 11:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2FD6B0272; Mon, 19 Jan 2026 11:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D92C6B0273; Mon, 19 Jan 2026 11:17:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8316B0271
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:17:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC14E1A01AE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:17:48 +0000 (UTC)
X-FDA: 84349219416.19.74DBA5F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8FF2FA0005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:17:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qeDUL5Qy;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768839467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBTQKFQ+iMbSjPN7DMdPdmRmDdo14j7hl6o3mo2GTkk=;
	b=2rBEfE1IEYDeIcI0Cwbzlg88dLElSJmLo9lX+WjO24wO254pGXoGCiaeygqkuQz0xN61cl
	6ofakKZ7KRS4D1xSk62sb6PbZmSyW1vUB94Pt8YQEMPFQ9w4zNu4MerVVVToaJaPqtcLPt
	I/OLvkQrkvsLo7NN1b8+BfVQj9cCpJY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qeDUL5Qy;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768839467; a=rsa-sha256;
	cv=none;
	b=zy15mwWq5fw9se+cJ8SEPQtopRF2sRs+3UjDxE1SqO4xVyNDSb3rGwiFTG5aW+3u/G8Gez
	oFi69XOMos0TQQqxrSsi2M4GoKdZnX+q9tLtM8DZg5+rXY5k85NAO4AoXjlVpMF4Imoozt
	QowJoNS9MyJiN5cBlnLH05CZIAiHkLI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TBTQKFQ+iMbSjPN7DMdPdmRmDdo14j7hl6o3mo2GTkk=; b=qeDUL5QyIJKEoD2lsDL7J+KPex
	eq5yRP/cAtJo+gsWuw/ZPFuNEPmZtW2vGQ7ueeLYlsTYzP4ovC2zHJI1G7mq6nZphOOdt2wA2eZEe
	vnniTvpzR24enoNF53WilVt/J0PyQzaHqPdu328cTEU1J6SBF3gx0VVkDz2qwO7QbDR+0CVHex+TS
	NzowPuqh12djWLvE6hcNd4d3ju+Cl41uXDw4TORseC/QPCpRcv2qrubUOnw7KJhM2jIumFw0JF68r
	zBHS3ZN2iLlJvSpNTBZOXPfvBORQhOPmUL+hGb6RS4BvTJc9zWmMuJfjNEZrfjMfm4Y/F/Lh0BMUr
	/px7+DVA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhrwk-0000000DXNn-1h2T;
	Mon, 19 Jan 2026 16:17:42 +0000
Date: Mon, 19 Jan 2026 16:17:42 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Infinity <chaojibjt@qq.com>
Cc: linux-mm <linux-mm@kvack.org>
Subject: Re: [HELP] Request for assistance to upstream an Android memory
 optimization (Multi_Freearea)
Message-ID: <aW5ZJn-Qz_8RL-2H@casper.infradead.org>
References: <tencent_1B6C070183FB1FEA24C7AF846403A868B00A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_1B6C070183FB1FEA24C7AF846403A868B00A@qq.com>
X-Rspamd-Queue-Id: 8FF2FA0005
X-Stat-Signature: 31jbwaaxo361bn8o9gnwt7jwc4p5rkmx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768839466-2964
X-HE-Meta: U2FsdGVkX1+vgxsGfL4lSlkpURX86c9mLWflTPgSAOmv+zL39QDwM2LF5z2nJaA/fr9ndpfZfCGWImgUE+2IAobGinEeHN09oof5vquHwBIPhDKwb2gLJIWkQa0yt15M8qpnyrVEv74GopkjR8gvp7pSuORzRlwkRDmRdzUoAEcpYzZLkviL8oMcq1ZpRF4PyASt6T8ZMz29YN86P+qKxre79NLcsdX2fmHjOtOpBT5K/jk1gR59rWqs7y/hMBp+lDhhSd8bDFYG1fiRjnKSNt5ldA45vTuIH4/ffTXsXzRjMmDtwiip4M/mAQKukWqU2z0RdJrfweqSIh+E1PRahMA+2Jj+ipeRYv225DhkaQFEwzUQk+B+BZ6nSA9DxomaALbiuWeqsyXU66ZLp5nQpKFrU91D6oROHS7/uG0nCFNc1eMa5hMAVffd6Bb0tqwIyhVEKRAAW6FI6901HD0Y2OIww9KHnb9UjGEK7Y1Lv0Co87PNf3ENU6c5e38/F4m6nAzEmjyaarwMeSQFW2HhkWReZm1dCqtXnyFaJ/7hEqzanFyTZh7VtJvX4aB9XzhLMwdEWMylHm+051aqkrVtLZ0IrHUpoqDkdJ4D/F0AcLtY5mdJ83bK1BHgXfDdfqWNqtyrEW8mXNaOw+pXqAIH8NlIZxdgAjybyD84pI7yR6DckyM3Y6vFmWPmUeaIs9QSutzxdXVqmy6oq4kkny7MhhtpzIrkSbVuo12a+FopYfCClsnrMZPNZsS+3Pp9rZYaE0wrORGqgomLyQTHHkbxLZ+epBHLd/uTC3DkofVuCQK/Rd14OjawiG7YEBQK3fh5oquJ+3VTAsAE+MzApcB2DIsccESyaDLr7yGWQrURspM3C9KSKFqQ3k4qXLoEI+aINAP6R76FVBw6KvtjgdeA9/qq07jNK1O59bC8ttVV2XxtqZGW3R7yiCeXWcIp/KKRj+T82JoRV9jMpN6fyhS
 acZr83aX
 E1Q2YrrAJgpCWmgsjIrvxEDFgeHBB3iJ379cc8GyO1f33/NzyiMLH3nT5SOpnQeSSAnF84l6KG3+ux8aCMdo0d8vdjB5KaTvBgx1GTPgXR7eeMkdt+l5otUu/KP0MnM7DgIXhpiLzUwcOP6AQZ6ZnfT82zzw+Qif/KQ3Jz5Z7RunSDHTWdE3SFmspQdPWPdaqr+N4dJael19UzA3tvB7+Gk8MsIEFHESJAVwv2xOi3DVWKPhESQpvzUz+mwsgGoyPrqyVd63rEERoj+5V6+5eXZV9Z204ssIfPqunj6VdR5jFN3skOpORm2tTu5ejs3U354SuXcF9rTlUz9Z+b5hSUTxidw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 04:58:36PM +0800, Infinity wrote:
> I am a non-technical user who came across an interesting memory optimization
> in the Android kernel tree, and I'm seeking guidance on whether/how it might
> be considered for upstream inclusion.

https://lore.kernel.org/linux-mm/20210414023803.937-1-lipeifeng@oppo.com/

