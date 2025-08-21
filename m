Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5956CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024026B00E2; Thu, 21 Aug 2025 13:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E186B00E3; Thu, 21 Aug 2025 13:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B446B00E4; Thu, 21 Aug 2025 13:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3FF96B00E2
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:23:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E35114048C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:23:00 +0000 (UTC)
X-FDA: 83801434920.10.2E9B896
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id EB60A80010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:22:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3UYJcBY;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755796979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohNK1oVk0vN8EdxMjASq/WXoxyMJMQFN7vfZaIH/nfo=;
	b=ilTHI7nf8caVtXnKEHA28ikmFUnuf4fI7rl6hRoyuE+e3b1meSrRJ+kVw0cLpO2yYD1i4U
	WJRp0+/iz8NxUNokNdiwMhRDDSrEUMDJNOnz1lJBiW7Urso12v0rkbrfY0K/yqtdt5IGle
	DugB1phyuWPs84taJN70zkUAB+uIRdI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3UYJcBY;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755796979; a=rsa-sha256;
	cv=none;
	b=gIbtXcK+2tyTy98lIgjK/9+O9ltaZA+HrxEghPbDNGv4SNDWenkAhsPj+4hwtEH8456Gzt
	6x7WgC/KjDTExV8JEe4HalO7HBPcPVngMppDLJU0DdvjQGJkrdteDKjqPSx4dxI58b4dbG
	93Cn5dS8s6jWaqL+8vC4Y9uSnqqMddY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 37F385C0F2E;
	Thu, 21 Aug 2025 17:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C2EC4CEEB;
	Thu, 21 Aug 2025 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796977;
	bh=WuobrIU/w6/7bz5ni6T/FPagEIkFDuKLi573JKcu5So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3UYJcBYfqTdzeM3cc/mYqxGLnz8jpW9wKntxSB4wmbbb9AgsT9Jct8PBoGimkWkp
	 QBgqkbhp3bDdBN7fbjlveapRaJ6olz4W/Ivm1kDLDT+p8jDLoFIPEHYu4gmdTPtr++
	 iRn65sm4sjM9EHezl5vJx9O2guQC6TKTHEcPpa9AzzhE61OUQVycZfhvIT/Ke6RoUp
	 01WMJR4bmnhle7lJsNX9cPNM9obyf2sY9shacoICXvT/itLLneJ+7ESGoO5aTTRbAy
	 3JBtanM47mXL7e6lgKyP7572uBakPkTFh2oP3cxkMPMxUL2E6LCDR5jrQ/t31ls1rQ
	 mUWkbdD3BycWA==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 08/11] Docs/mm/damon/design: document 'address unit' parameter
Date: Thu, 21 Aug 2025 10:22:56 -0700
Message-Id: <20250821172256.82263-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-9-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 67h7sgpb3eejibgzo517bcceu81gkmfz
X-Rspam-User: 
X-Rspamd-Queue-Id: EB60A80010
X-Rspamd-Server: rspam05
X-HE-Tag: 1755796978-412011
X-HE-Meta: U2FsdGVkX183bjxS3q5PNhm1EpVdUkQ2kqYqD4Hf1Tg1/FSG7k/Sjv6gYUvkte1puwWp0mIL9Z529DLnNYeg/Noynoc7W3sY7XuOHvPpDPEyAzAmjkUdllCP+kYlEAACOZD4ot1X3uB9lkUJHQRGtmtUoQY5iISDaaaiURZeoNScTwlLXEYVOimSp7IdNKMvtsWZKVYaH7RM/p18bxC8feFMo0Sww6R/I/R38BbSgngEEKJSXE/LbvDlhc1I8oYn+ty2yKC981j/qwRXz6vpVjPMc3IPRphp74c6ZlIpfgGtRI8sh++GJKV2NpR6zFg8q7ZFCBJj9Ola5LRWfnaoYLZU/4xldNs5ZpPwpr9Q7LqEmOZGToJVaq3FGhRkNkzNy/75UgOmHYKJSRIGkdmDCNHDMN+TnjJFXzauRqEB6vwOPetYTAWfz57PjQeGtWa1K2dDLZNYvN29r2pc/4m9EDoJVWRx6jQEjyRGwI9ankePvggZgiRTfU+R2fMoNAKji336nWParwSPy+nsmqVQpQ1s/NrdiIa2fFcrKUUIU4g3Spoy0J6O8Wm0foHPZvhj7BOSGQ27c6wKs/iVgssnNjz1L6V2lFdrebssD+HP6RuucUsiY/jHtSohpmil7ic+TVkdemG7Gx214ThNe2B/+YkVtpwJLPrS3xWwWs18GI1MAzXfbQLZzVQV2srFAmGE5FNfL/p3e9AiROuZxCoJw7OeipibcIYz5bbKcC1lpwDIY0NSnbnzCNj6SPgNDjLlj6Dm+rKBkUg6MpxnFnphXHNda8tZf7Tjdn3webWHLOlL5uBqkjtgd+0EMfInI+s5mzYpvdqEE/l3EIShS8mQK5KHhkk0q00P/xKL0VZSoQbYeom0GhxRe5Avqtt00ZQyix0ZFQEEQSxfyxU3v/2JVdYc90SniDkmuGxpP/0EPPMXmNh8+OOdkVCdfoZtuYlTaY9SaX+zD3VViTZOO3D
 qNg8EY/Z
 4iNSQXVvJeJ0RuM+A9v+vQ7xqP4ppvpkMOk1cpmXtkKv/Wv7hCpEGQ9VoKkOLruTcMUB2Xj8nR8qZ2HsdWD630GG7UbgXfeIu6dwV9vww/Ghi0LiOmqyoilYxf3PliJ43ENuo6r6rmFm1z826C4sbT5H8JMtGvLVPYpSOdt9akgXIueXWLlIQhbe7LPEzRsUwdPfSvsmALsWtnCyXJBVhv4K4R1LWaYy9+RVS1UPBWVFVmemHRQkM3zDCslz9cGxXlOln
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:56 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add 'addr_unit' parameter description on DAMON design document.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

