Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D9E2CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 20:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F046B008C; Tue,  2 Jun 2026 16:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF3E6B0092; Tue,  2 Jun 2026 16:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3CA96B0093; Tue,  2 Jun 2026 16:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 985A66B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:37:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65B051A0150
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:37:31 +0000 (UTC)
X-FDA: 84836133102.05.3218C39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BD28718000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:37:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvEOYDcA;
	spf=pass (imf06.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780432649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHwD0ZV1CEAMNsXx/yt+effMomSWCNvi3CFB34MYIdk=;
	b=wsDswcpuHdlYy7Qa8wK+JUy9VBLTpqPzXfB2+ZgDrtq/7vwgJ4MF0cRtdjKCBPUlbQwmoK
	ReUGLI7lqdkDX/C14eX4LXjEVw6zdwwkdn/C59Mk161V5eK5YXdbXQfwb47ABg74YRBJ0A
	mhH+kFMldTktgyX2ygdmus82Ua+CpMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780432649;
	b=kwFQxN7kRUj5VXgp9qQDVgXvUEFndD5t8jZ2JIMODt0rQtgfvKvGghSpiqYWfx8GfVBC6X
	CtoSF4+dOfRo9ZNYpM1IIkyWHZ3i2wDNrze9Ipc+mtkeO7wRai5E308dWhRxSaqPV2r1+x
	nWDg/COIsMLv2SnhNqxFteBLCL/GqDE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvEOYDcA;
	spf=pass (imf06.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26A6B60123;
	Tue,  2 Jun 2026 20:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0651F00898;
	Tue,  2 Jun 2026 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780432648;
	bh=pHwD0ZV1CEAMNsXx/yt+effMomSWCNvi3CFB34MYIdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jvEOYDcADvlGRRYIOLhBJ9fraq492rgPCR9NNwxrkm1WgOgwIS9DZZE6WO+OKQWOj
	 HgTONB8mKBSHVkLVQw9p4dZD1YvkZyfE4eP2vGawFp8cTMKgGZnaXrbPNHA7iXpvKO
	 tIi0EWxzVT/Joq8wQYV4JvHjV3SLdlVQJhH2cg6Pi/IJrwINyUyE4GZYgUjSmhYP0l
	 IqkPj0r/ajPzK1dweOETJ2+uo+G6GSjS6FTxMiUlcm7WRQHMJqmdlQw5PJIvezNu/A
	 QwEf1e/4pe17gdpl6AWUHoPAG2/FRk2AinFLrWnZEIWagdNAm/mc2rWPWAo2ls/ig3
	 dsJmE1RNbNm6Q==
From: Thomas Gleixner <tglx@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>, Peter Zijlstra <peterz@infradead.org>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Miguel
 Ojeda <ojeda@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco
 Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com, Dmitry Ilvokhin <d@ilvokhin.com>
Subject: Re: [PATCH v5 2/4] genirq: Move NULL check into irqdesc_lock guard
 unlock expression
In-Reply-To: <ab457810653e4356e29b2d74ba616478bd9328ad.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
 <ab457810653e4356e29b2d74ba616478bd9328ad.1780064327.git.d@ilvokhin.com>
Date: Tue, 02 Jun 2026 22:37:26 +0200
Message-ID: <87se747k6x.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: BD28718000A
X-Rspam-User: 
X-Stat-Signature: jg4s8ije6u3ie7s3awfpamaub6yeae61
X-Rspamd-Server: rspam08
X-HE-Tag: 1780432649-414036
X-HE-Meta: U2FsdGVkX18bo1Pmgmc4XvWsj5VAwEM0DjUZqO+uyT8yYU4etNOni+IIXpeK7aHdmrv8g+SkQlF0adOz5fnh+ccXIII4N+B0H4L1QEcn2WnAb3Gj876nuJO7Kxdrndmp3aNvMs7zAeLOfMh5P7hmt8AGkgNpcwwnBtLSzR7RrnvXziDzbuVW/aX+RJa7Yzvjui+/SwIA+bpnW8ZcAXTSqAhfAO1gU5RZn4oOGw8K6ZVPKBk25bDekPw9mw9DOtgaPPIhPL1eGAR+Zj4Kq9OMqOLwj84lLUvmdA3/kS3byXsr7fNIhAYtLosjjoJNEsOXD/c5LMInQECq6AU1rO8pCTVrcxWQcH82aCmfM7kEpwwFuXnuNqeT40yOIwIuprJecD2rDJ3iiyp3wHyDMqLlWW/rJgJqCPRJs8dVBxoggQP5dvtcDkzpcP/gr2kJGxRLcJs0isLtJWpJFx5mBpzcTfhce2wG2iehMOEP6OCWeiOtB4qZy6FFFFO7Re7JGJ017nKO7JnaQK0WWfSQ3MQc6NWxMZZBhceBhtSzXjmmJEhFLwhD7VJQKf6PCWWRh+V7hcxRoeBJw4od0aOycsXwPHIGUqZqIkkGs2iPmPFtiTceIV/W9AMotfofHNV9uCr11iuCLY8h51giQvRchkkGeGieYB26DqZy/OgLMmaJ9tZBGv5RuRBoUBDVzkE4jxuU/hkcpsTVAL09lICC2hWfm0YhXRalfRddmI6jLdsZKP6uj6gO9lFs3UkjfdWtgU6qwEAlLU8Tkz8vLzjX3gJBtquw9a+MQ4tscqAGTrQwH81OjIro23XZyjpBnSP8uDOnnAqSmuVaCyZL6nlZsSLLMolvgWaF8UrIyljq4/8GCLcYmIIUNLqkc1fjfb4hiaZP/qARUlgTR4b3KRbR8yP3Tv5Bpkxh6vG/ZtnNqum8QUCUdmRaD0w5gtJaci1TAhXjl58pyKVmLK405/VqDlf
 jLX4VwSG
 15AldM0xEUjHqRA4jNBvOxdEMranSbcQ12dtn6KYilEUOARkM0DnsK+BOS3r5MElQTd8eyiYitYZKXnEQCsn/FrGjFvrpyOHlWpir0uhpQ8KWyXjFB4oGxLeWVmj9JwmldH6odSbGoun0zTAW2OVQv8OtB3EfWoVUcazFg1phyB+bgnBioNDmb/2PgEjexJ3JcpVTGpx+Sm8zWheghmGYYy7jBHkmJLNaJMj4ai4+BfLd4xuknZTFAoIoU5yol7n+EwMBrVq8SLOrU1gd8T9ZAfYpl3j1cVHW0bLut/DZ64jeNmd0MaCxXEzV5lhPEfnKJu+/rH3vZDg3qxw+zAg9lxCVHoNmJYgluVwwgMOMJofduix5jfLwsjlmrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02 2026 at 07:12, Dmitry Ilvokhin wrote:

> irqdesc_lock uses __DEFINE_UNLOCK_GUARD() directly with a custom
> constructor that can set .lock to NULL.
>
> In preparation for removing the NULL check from __DEFINE_UNLOCK_GUARD(),
> move the NULL check into the irqdesc_lock unlock expression, making the
> NULL handling explicit at the call site.
>
> No functional change.
>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Thomas Gleixner <tglx@kernel.org>

