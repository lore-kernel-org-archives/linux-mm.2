Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB14CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 14:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF70C6B0005; Sun,  3 May 2026 10:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7A66B008A; Sun,  3 May 2026 10:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD0B6B008C; Sun,  3 May 2026 10:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC2AC6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:52:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76F91140974
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:52:13 +0000 (UTC)
X-FDA: 84726398946.26.E0F46A2
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 905EA10000E
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:52:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sTjUo9hB;
	spf=pass (imf14.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777819931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVkyffb8Q0PGQnTBZ+TvlFrjY0CELMdRqK+yVMGHtn0=;
	b=fw0YpQsUt9rEMXl8+8rKZOPp8m0KKt9NxzcHd8zjl0JFB024nR8XEt1d23AyHNPk2iUrh7
	Xct/Tlaoj/e2mwLTNpYXEOuHUgvzHaOMoSQR7QZ9idaLiqLyIY0bQekUFw2qydKKjlbIq1
	tvu/UR/GQ/+mpFZdnLqSkcq8H1Zp6m4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sTjUo9hB;
	spf=pass (imf14.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777819931; a=rsa-sha256;
	cv=none;
	b=lmQ8Utsvdnoe7318/U6G5noMCce/YfbAnLpNqEJ3K3FQB9nj/7Y7BEcfhIU3F1KzR2p4Y8
	xiAOLIhTVSw8u0JYvyLYMBRfKLYmIamNEcWq+XVQ1t2vq0AMDNuXfkWcAheEKVk2ox8Pyk
	rPC4J9Q79e8aAOVV/yX2AiSsDBpcX7Q=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82faf871346so2020649b3a.0
        for <linux-mm@kvack.org>; Sun, 03 May 2026 07:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777819930; x=1778424730; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qVkyffb8Q0PGQnTBZ+TvlFrjY0CELMdRqK+yVMGHtn0=;
        b=sTjUo9hBs0FpvAMGHqjs2qDzUDbzSnXVJr6phyDFGJ2yioHcTG2L9yLhEmPgZdLYAS
         jhegCvC2ipMM74Vv/u2fu3Ef/LHiM20pCxZA2VMFW5Z6oKIo7+D/tuXLW5ylTt6CyFDQ
         kaNg3usxw06eZBNYaaV+21rMC9scVZh/BprVevtUkc0pYim5Z8oec1ru9hGxYXExE4+h
         nnywoVzIAabP9thpr8PyvTYRuRxBGceU6qdgV9L6tZwLCX+Blznvt2RPyDDcxv9BEUIN
         WGtaNfTmw2IdHaB0MiGiCm/Q7Sh5wnQLTqpa0eFJylHas6PICKPvoy2aqr/OcmUWwvES
         RImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777819930; x=1778424730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qVkyffb8Q0PGQnTBZ+TvlFrjY0CELMdRqK+yVMGHtn0=;
        b=Myc1nNoLy8GaFMJ4OSucU8U8XAZrvT7wphw3cfHYcaXb0J8qIfvY9FvRenEI61SOKJ
         SrEnyvozZA7SWhi5ZYyj8A2USMB8ZDdw4OC/id3T8Bhfgkrv59wor8VvnnIbbg1zazBj
         lRezirmwiK2ct1KyzDqX+VV/fjoBCZkzBGcHTzGIao33xsmjhPXBP8bZVyjWUPsq+jwF
         w79RxpKp1fwmnNKMgi0iDsUszDS3W2LRrLwBP1o9+1+sDcdvdSKS4+bZO4zzvSqn2JSx
         1C06cMcGjahClyw1o2MQ2cmfWZAGHneDb64r+zQOCZiQRlkgW+mDcMSG5zQDkSZN94YM
         dRzA==
X-Forwarded-Encrypted: i=1; AFNElJ8KVJw2U58kZeZw8TWEolBHoYlXPKXR7XpWwbMsfcfiLQkjkvr49u8qLvSh1BnvOw3O1a69bJCVfA==@kvack.org
X-Gm-Message-State: AOJu0YxrOCrDGfrci+aDUekHNh7Cl3Gty88GKsrAmyZ6/y9kBFxACKdc
	o9L96B+3CpUeKr1AL9eTj6wlMgFZLy93ZPccmtEwVEeXF9BBBD/bKbq+
X-Gm-Gg: AeBDiev6suUEuTgNb7NkzpjB/GhxvlaIlEHk03bNfNlQy21RnNYTpMYrzKrKKrx2iQY
	ec38zxa8QY8CC+UbMCTYVE/2NH/+AV1oK74VrEIAbJbueDpGWbXT97ECmn1iLmOqZvhC8ApMNNt
	et3fk2fdneQ295ZWhjeypjID8VxC3bUFGezReX+xgdWqxOFcz7F7H6EcRzHMY3ifeWsGgjwvDJw
	7sYWqA10+fMWv75c3802LXFEBj0loNZ2Bj66rtgwbduryUSAv0t9jYQQ4SNSQV9L9BdZF+xo0jp
	zhye1Hv7y9lAGObTr3F+eEEPk8ee7qL7g6owplWRPptpbM/pJWQakrYdZeK0bwJ6z5t3nmwOZb9
	b9eVFwFq434AzFCc0XCirO90TM2jIotzG57w+2C2PK01xuTPJF7Gvxvf647j/7QPeY/xj7HUcz4
	Nypc8OjJEL4rmPuX+O0GlcygN81KdY/2re3Q9ayFgLYZDQ7nka26I8+g==
X-Received: by 2002:a05:6a00:2d9d:b0:81f:3fa0:8c38 with SMTP id d2e1a72fcca58-8352d17504fmr6815426b3a.20.1777819930328;
        Sun, 03 May 2026 07:52:10 -0700 (PDT)
Received: from localhost ([183.227.123.133])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-837aa3e4f30sm121202b3a.1.2026.05.03.07.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 07:52:09 -0700 (PDT)
From: chenqiwu <qiwuchen55@gmail.com>
X-Google-Original-From: chenqiwu <qiwu.chen@transsion.com>
Date: Sun, 3 May 2026 22:52:05 +0800
To: Matthew Wilcox <willy@infradead.org>
Cc: "qiwu.chen" <qiwuchen55@gmail.com>, akpm@linux-foundation.org,
	rostedt@goodmis.org, kasong@tencent.com, mhocko@kernel.org,
	hannes@cmpxchg.org, david@kernel.org, ljs@kernel.org,
	baohua@kernel.org, mhiramat@kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: rework lru_shrink and write_folio tracepoints
Message-ID: <20260503145205.GA3181@rlk>
References: <20260503085705.3276-1-qiwu.chen@transsion.com>
 <afdBCWopkfF2ow-Z@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afdBCWopkfF2ow-Z@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 905EA10000E
X-Rspamd-Server: rspam06
X-Stat-Signature: sdkzzzeih91dhyd3ycp7rzifokbkhx3c
X-HE-Tag: 1777819931-209061
X-HE-Meta: U2FsdGVkX1+CAC00O9q4qYIBSoQnuBFdwAmjkhwR5yvvjNyHESyZuvAHhLm4RsMAmoTyXa4tZ0H2rmN4t46INfqFGO6vyGTNFBYWX7/pdlKHrYVECb/mPO54FB254bddidT/AQ44h/Xg6T93ORXoLWmUMisuRVOwl480Y3IQpbE3P5bYZdH00SWSuVzQPTiBu749/+8lDqXuzqB+n+38fiptjxUjBne38tZvVkHMvz8ibrJtzpnjVCssdRbZhAs8AItqXl12/+L6P0RqvfwrIPNEsGP+hPvUgeshaL+y8P574moBRSyccFznIVHdD41UkmpwdFYmRbJuNcspwEAJVDMFkEsptELtCZ5jzD+tYmeKAcPOjEy+ZyVE6RqgCK0w/z1OTOdOLBcfFnf7R0CQIDAnUQA7OSJN7ds7U6nGcLBU5CEklZheI2fIcxsIfo6U/Rx6mCBrcdb+2BTVS4Spt3yBuYKziczB+T2dsGaLAPDg+TDRGhl7RMMs/0zBzk4J72gq6a39fyIrByE0D99CCi18FfmlPt0PD0xiaYu9FeU8eLeqrv12VO0PPUL69YYXzYxwN3RGma1gWRg8GpyzjX15oIui6Iq89sAP0fdahe5RBAaTewVheCB6u8T5JpRWUaWuffX5r39s+vqJLoqzvxO02Q2SbQKOrWB+RUEIX3qzbV71P79C3K0Gn1t7X6nmNfbN4VwUxZB7TNvC3Nw5WHikctMjNEykA217jq+LP58qe4/2nsOyE0n4jH2LDLBTigbupxs8EnNcJ+phF18pXXmUT9neKJ8azbvlXi58iexAkJfuhHIqVgNqxXpQCOgHVGo8WL45jMCISb/TAkNU8rxSB+NEduydQHYRGQZfqVJub0l0eF5rvshNhAh/Dk1OZtNKjsvqBBIBJzUxXwyh+LNWKlwEhh5jga/8USQ3LwQg0cf8uOoLC5zPAF+z7fZO0PsVr7scTz4/4LmXhpV
 U/TOaNWK
 8TEjUeb/gVplti18GQHzI4wLbN6ZGpzFfLfcKMsWvldNInk2VQ5ZMQ1tk2VLXuGw5dQKyIxGrH1KmsaRLobfW+X49D4eSW7+LnNfVGbSdpBBEblxFwh3XSdFYNIbraYILlwGahTfApSmhjh+nfxO3Gi2PQiILog2cuVpGi0uF/xElA/Zw3PyoMUlA+3YzrbSb46bo2capYythauB1zuenjkhSlv157VewAIGnXMG/OR/tbbNvZ+teOLhGJkt/+1CJlmE/dgPMgZgXswDLuFdYa1Bw0Njmdx8SSKri9guO3/HUfbVinwswD14ltLpgpDoQNGoIZfCuBjRV6JaMWOjZdT/a6Z0SDi8SxthM/52u9ein5EYBTcFca7yZgYa26mqCHYKol4iUWNPgs4fmkPfABeUcGHG84zGMxWi93TYVK6Aa5QJnuZdfBiNrCQ5WqPYvcrA68JLillSzSneVM+tUJPX9utllKLf5bpFJYxYP6XvX0aupaXEfZ/sUsxN0Evik2rXW0Qo6VgRprIW32NcLzpxx95LLKojydk5R952gDd7HXPX1FX9ZLVD/W9aaKbqPYu2FfrRJQBsf1nF4vCt8JyErOcIQdaWiZHMe9JkzAJnJfiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 01:35:21PM +0100, Matthew Wilcox wrote:
> 
> You also removed the printing of the folio's PFN.  Was this deliberate?
> If so, it merits a mention in the commit description.
> 
> Also if you are going to do this (and I suspect we should do this!)
> we don't need to do the folio -> pfn -> page conversion.  We can just
> store the folio pointer and print out the folio pointer.
>
Yes, I think printing out the PFN is indeed unnecessary, but miss to
merit a mention in commit messsage. I will remove the unnecessary
conversion and merit a mention in patch v2.

