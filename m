Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A64CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A8A6B008A; Fri,  9 Oct 2026 10:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B8B6B008C; Fri,  9 Oct 2026 10:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488606B0092; Fri,  9 Oct 2026 10:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 297DB6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:00:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD2EB1203AF
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:00:47 +0000 (UTC)
X-FDA: 85303248534.26.518CDCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 21C5880011
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:00:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BrmViO/R";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791554446;
	b=vnFCYW/mZtmNM7nbgdfzsMFR1nkYTSE1UJA9vcdwzhthy84kiQ/2nGZXwmjh911YJ7BhBu
	ABcKe9GJzU7x7++Sbu8+TddcfgVmn4cay2zGIPCUb3DjggDIwUu5VoAYB7L8A3HGbrYTYG
	VlQYB48d569xIisG1cZriL/2RS7tkrc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BrmViO/R";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791554446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8ZZtxpPf3ZxApZdnej/5Ho/hbGh7sjDwT8v0/08DJE=;
	b=SheOnbTdZD2tu3bgHTSDkhEEmzwpBVJou4m021XGKhDRY6O1Wy5ViVdzPv9ekmvpRgJYiq
	uFo+TlN7+RcWZ0yI0tUGH0BY1BVAflEhiChissSt1hzUZpABMPpVdGGgp9UilLkAP1+eJJ
	CnsDCmacGury7Ob+vmINrlOJKlpBsG0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47C8E439CB;
	Fri,  9 Oct 2026 14:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D8F1F000FF;
	Fri,  9 Oct 2026 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791554445;
	bh=U8ZZtxpPf3ZxApZdnej/5Ho/hbGh7sjDwT8v0/08DJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BrmViO/RMIoAWkNXWo0MAoKRDlCL6fGnNr9qRSMYPKrDZ4XvQTpTbDWEtxuEZGm4q
	 kwj9XAd/xlj1NYq25K+poxGO/DIkNtaE4UekGzAlqh7E8oVaRn2ZYDYXQJJRvTdUB2
	 1toht33sXHXl4d7XFpj8kmp76YqGcbgQjWAUD+CzIbg8YgSaiyD+5+GC66k+CAMqFZ
	 IXlJx8eWXM2vAyw2Lkf3GAbK5ZfHYed9AnyNZJyehlpsAb2yogHFD+ohUDfftiVfyp
	 WzJmsJPKcxGWyHYlCsD8u0x+nXjOOGKIrfRpxNrb/Do3Igxybr7cfX417UKmh0mzwy
	 rjDM5kPtkAOgg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Fri,  9 Oct 2026 07:00:41 -0700
Message-ID: <20261009140041.11741-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261009120950.38879-2-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: akfkn93j1ifdfyox9ijf97xn1f7ozw69
X-Rspamd-Queue-Id: 21C5880011
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791554445-694238
X-HE-Meta: U2FsdGVkX19o8WoBKEiRgCDZ87lD+r4n5egmFCPf82vhQ/sD1O6T5NTdo7JIF0LGiMABagDrmTkcNvAJtAvUFucPO64vHMj56HRmIRF79gCBqqjhnuUs6+4DwrI3R07jfkuMo0vcHcAlf1dhO7elrD4Q6obYL3Reo2JtuZWeKaJvC1z26mJwgFwxFW1yspnZDJCYsxNn9E3NqtBeZiJGnvtG7r4WJwBaziPP5fM+OeksdGFkHdhkwuaVXLIIiCYaVGIOfYYdjGKGkMCiGisnpVmzBHa3bwes+nJKZ5KLUr1H7YD8y7a5/iJHXn0Y2fRQUTrTX3TbXIWV5rxopk3/yrfD8GCO5zrp7mUCi10TW3RNjlGJUXu7XiMVc7K12R5PBZ6B28wIdfGI7IytrQTm/0Uea1ZHI0ozi6zlV7S1uzSX6XiJJywEvydGFAYvLPXhACpkx8Ta0QOTz6Hcq/shY+hJnNe9f9EmaPL2p6jmOBhhLeqpWdFoh6HNioLCtvfw5nCSTzeQK2WSrRMM3nzJNu2vSNoEIASYFUSIns8E1GUd6Q4LRyDANJ5RC2jeoOJLrt1wyc7qWW7yZiMVo0KHtx8QGFdxPSIj0t/YHZ1KoBzYKgCQbYcYMdZDEdM9dF5JFc9dAe9sg0cxO0pTfqpA1t2bDBlbvTR4w03FmHy/sVdmuzcZBDwuaxTx7jHvTvqwlU57Mzatwgsme8xBmVuikOpsUmr74h6jIotioxokUJ+PwXx80mjuCqoTezinW/c8uWQUoUFsurhsi/WP8oaXCfzjlZqCf0aK9K6puK1MB2VSfbY4S3xlpK/CnV+ATP9vfByPmKwPxdivV1D/meGWOaQlAPRsf5rfxkRh3dpNQ/R9IJF+nGWX8jv8RIz3wC3rcoAU5uOalU5zJXrEYJ+5Xx2qTR6tc2JSxY21t5Y5zce3ApxC2qBw7AMNUBvtzwKXi/Qn2sza4cVwEZf7vEz
 pAR/U4Dv
 7dl88TPfNRUOk7PLfVXwm1HmVfxee68NjL4hG1jP61Ip45+VPm4kfmIXn0gEBv6+qyKELVCBW9mVW+HA1CrUS/1yzClb4qalirLJVNy/V9LqZw7Cvei8iaoxr/yJObbPhKLolaXRlMG53X5RRNs5oS+k1aOAeynqmfnJ1mN5+tcqZOTUYhNIJ4XCAcN6l36yEdGcnEerlBIuGFkY/3F04MR9fdHp4DRIXkg3VH1l2/PyrXzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

On Fri,  9 Oct 2026 20:08:33 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

[...]
> Yes.  My expected behavior is to completely save and restore the DAMON
> SYSFS configuration, including DAMOS Schemes.  But it cannot done by
> 'damo args damon'.
> 
> In the script I provided, it first apply lru.json and then uses
> 'damo args damon' to export the current configuration file.

'damo args damon' does not export the running DAMON parameters.  Why do you
expect so?  Has some document confused you?

> I expected
> that reapplying this exported configuration (via 'damo start --kdamonds')
> would fully restore the previous DAMON SYSFS setup.

So this expectation is wrong.

> 
> However, the current/unexpected behavior is that it drops the DAMOS
> Schemes configuration entirely.  In other words, I cannot fully save
> and restore the DAMON SYSFS configuration using 'damo args damon'.

So it looks like there is not problem.  Please let me know if I'm missing
something.


Thanks,
SJ

[...]

