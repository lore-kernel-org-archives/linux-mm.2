Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2EA3CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 18:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91728E0064; Mon, 25 Aug 2025 14:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42198E0038; Mon, 25 Aug 2025 14:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57D98E0064; Mon, 25 Aug 2025 14:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B41F98E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:53:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 604F81604F4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:53:11 +0000 (UTC)
X-FDA: 83816177382.04.5C919CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3CBD40002
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:53:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lb2uYPi3;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756147989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3rjkwd+yp81du5a0+5OxVddHSkCngCSEH8LmT8UTGg=;
	b=6EVJ/KJ4adm3vsHErip2y0jbsApnudBXjfAECCAgnJSRKK/2WZl39TGKZ/JVoXM3Ck6opE
	emlnObhhDXZx21yX4qk6whXzSJoCcNysfG556UPdJFya70X17+K9cQRlajOY/spEdZx1ZH
	sBrxUCm4qeTKrq9VGbsC6jhMoEHEwIg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lb2uYPi3;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756147989; a=rsa-sha256;
	cv=none;
	b=iLkUgmTJ3pREvo93umearPG4DibyoKuP3nzntVwe1iHyQO8jgI66DxblyzuPf1LAYM5ICi
	WaUANppAegnaFR0rtgjVstSGSI0TV3xrBqqawJKQqd1SlRi52M1AsL44x5Yciy0+D4yIqt
	P8K6CCRYGvmL8CtFKrGpZoWQxEwgmF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F1F6446BD;
	Mon, 25 Aug 2025 18:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D076C4CEED;
	Mon, 25 Aug 2025 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756147988;
	bh=LEW9gsFvgQr17Q8Hvz8WKHs69INOEWZ5Ig+Zk2KyLtE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lb2uYPi3eOLm4CsBv3EOgir97hD2gec70fzgc/UUC8EgEShwvOdx+TqoWoH5I+vSU
	 7J0r+U27tSe46fwR7OShP/BtBT5nwybHwJX2RupZSUSKL7xhLmcSuOA+A+mmzkeXtT
	 J+Crq080KBH41tinXIe+SgBIsDfgokYByiFlW2K14TxcyDtVulXENi9UoRR717CSN0
	 FlpLQ9TYYTcCPQLkLkzaRL2crTdOmVlP4mhzusombwS4zUE2sAWfin7EqyrsHqHV6w
	 Nn7Qv0yfJezlb8xsRFvxlsR5QH9MNTob2gXIN61wUZzNxBeWCfl0f5ahcWY9fdFF53
	 5VaWFk2ISjhvA==
Date: Mon, 25 Aug 2025 08:53:07 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, axboe@kernel.dk
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
Message-ID: <aKyxE6QOR_PtQ0mT@slm.duckdns.org>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
 <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <aKdQgIvZcVCJWMXl@slm.duckdns.org>
 <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
 <aKds9ZMUTC8VztEt@slm.duckdns.org>
 <f1ff9656-6633-4a32-ab32-9ee60400b9b0@bytedance.com>
 <aKivUT2fSetErPMJ@slm.duckdns.org>
 <CAHSKhtc3Y-c5aoycj06V-8WwOeofXt5EHGkr4GLrU9VJt_ckmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHSKhtc3Y-c5aoycj06V-8WwOeofXt5EHGkr4GLrU9VJt_ckmw@mail.gmail.com>
X-Stat-Signature: 89cz1s8fdyuhgkr96k7b3ckioijfk1c5
X-Rspam-User: 
X-Rspamd-Queue-Id: B3CBD40002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756147989-412867
X-HE-Meta: U2FsdGVkX1/VKxe3EN+yJvNJO3PRNRxzdnW9J3rZOM2OKOVllYlzNdUMcokt1uQiuAhotPcKTa9inEVNO9mLvInBUu6Dp0NYGZidksHLcoiOqP2OKvpoTW4Ndad/Uzkj8NoJSZWKhosl1dI1gNfjpmLfyMKKaMV8jH7ExaGFPBYOR+acC1g+xuIXbPEOPhx8WvVlgbn9U3amS5pGAXmSMNO+GZys6mB9Y79lAv88P3QG+GbzT4T8IFramcxNisNUsJiicboiN13OC3uABA4Y9qrnX/s2ZqdCpgmLv98DLhC511RmdliUzsdm6Gr1qefH2eczw+7uud9mOHsDqV/VWid880Z3N70nsUYhaWGQ+Htv0BZBlJZd5fWYZmoSinh9vvAzbcq4mrC6UDValWC13kxDOQrZxIM8GYhg2mNEt/Lv2CQ4o8wNnyaWVOHMFImHLj+4sikvWZqcnMFvH1XIk3oz0Ikfqf0LRvFXKC84qg/eOxiZQeycAb8cWUu0a2yQA1oJbcMXxreQa4145OrWHYWHRq0hRfMdaxoR/HJ0g+v/eNJbOOY7VKG/TB53K5lIiMr2PlymgT5ZZ600tUVjjayLiuRVkRgc/cTaLXAGLZ0sp8EJWW5ASDZwxvavsr/3N65mVhGxWFH3xBkf+SS7qNeB+VZ75aUNWKCRIRDmSp13CQpSxhrQ394vSE+pSpg/J5L4FNF2YABuITu4JE53+FVcw4SpUxV7pohghHrEKpkqmgPOlcHk48XwGWgzOwvGwkb0PWdSxYhiwnjWGR9yTKNLv/6Vl26//2MRfYswQwBNYCvjVM3nK2H1oTuDHeTwk2UuaIiYIUzUgRoxDHt5l3yALDf/fLReKvH/WGe2Gj6zFDOT+CmkTWoRPxTEXG2mrlGpJdAzbC3PUKbDTBP7VvhBG/Ob+M4LGYDyeaMOMs5284Kq2eMJwWBKAb9nc0SUVvqDrXz4gx1uE1/3EwZ
 nwb2324H
 9vzSZg9nKvk2PQrQn8vXXQ+sabV2Ntd+3xX+u9LRiY1v9trvHwnqovetah5eRl1pd5LkWR7KM4JyfTnh4BqffeIovEERbz3Xm5Rp0LPFyZCyD7A9lcD/A3xOZsj/0Rf4zk7wDlryOAjIuWqCcYJATSsCds8ibEVRb7UIxKm/Zc8GIST60WHWmtC7KEcNVGvkN7n+HYYvh5850cVPCt6q5U2TjpTp6frDc/6XUnGojOLGDBpk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Aug 26, 2025 at 01:45:44AM +0800, Julian Sun wrote:
...
> Sorry for having misunderstood what you meant before. I’m afraid that
> init_wait_func() cannot work the same way. Because calling
> init_wait_func() presupposes that we are preparing to wait for an
> event(like wb_wait_completion()), but waiting for such an event might
> lead to a hung task.
> 
> Please correct me if I'm wrong.

Using init_wait_func() does not require someone waiting for it. AFAICS, you
should be able to do the same thing that you did - allocating the done
entries individually and freeing them when the done count reaches zero
without anyone waiting for it. waitq doesn't really make many assumptions
about how it's used - when you call wake_up() on it, it just walks the
queued entries and invoke the callbacks there.

Thanks.

-- 
tejun

