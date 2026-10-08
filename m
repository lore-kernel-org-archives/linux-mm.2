Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AFF7CA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 12:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3915F6B0092; Thu,  8 Oct 2026 08:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B446B0093; Thu,  8 Oct 2026 08:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209FE6B0095; Thu,  8 Oct 2026 08:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBBC56B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:32:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8962C1A01C1
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:32:38 +0000 (UTC)
X-FDA: 85299397596.18.C2D6B05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id EDE57C000E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:32:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lKS2Bfgl;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791462756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmteuJ78jqh1Ln7c8dSnhU/GJ5JSXutSDUniST+kAJs=;
	b=2/TvQeVUkGIzHXyZldX4hF395GnUY6xW8/CNT0iKjvjOUCqsS/Zgn7Lrdp11slJ1FxMp2s
	tUjyL6/WsDg96dYg8DxSyaBVI5hed/rOKPaHKImFQatdNkPMcEqCga3GYtNTx9vSTgisLr
	MHtO/Goo02p8LnPN65wnm47Pq/uElag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791462756;
	b=6LYbKkIKDhPp3bIdxUW5TKkyU4XyYtKV4RpV/ctq8cAgr95J1h2GTQmuz8vlHGh1JX+UF1
	BKARa2oy1Ud4AZ4kFOo+2+UcpP06Z2i93cj9xikLGBh1vaEtRdwJHAk77Rf3jeSffI7Emd
	cXGIDeOaR3oAtWM0X+xYykP3D0kvURw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lKS2Bfgl;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38C70601DB;
	Thu,  8 Oct 2026 12:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4B31F000FF;
	Thu,  8 Oct 2026 12:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791462755;
	bh=nmteuJ78jqh1Ln7c8dSnhU/GJ5JSXutSDUniST+kAJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKS2Bfgl8TwwcykKDSmb+5YrNh6rvMBmhOv4vWhPSkI1kFLeonN5sMHO5pUTrwLrB
	 Ol7GYigQhKEVKTF5XWfANk1ySD4Qzs6nNZoZ9t5Dgv96ywPbplLlVkm5tS8HD3XxNS
	 AwNxWG+f3nyYBPT+1U4m4vntgW3aMclTGegEanpZ9CcAuWe2EcBoB/D+L9LxeUYCEJ
	 jWrMgVTVpPq55nODE36G0I9J7/qgK5mjxZqLqphiJ92UbfKyX3wJQK1eWZj8RRQR4o
	 TqxGrpE72iqbbcq8AZgphrg3KaMIHXgcdemQiUQ5C93yMrnez6eizrcc93dY5c2FLE
	 J0tR4zPfisA1Q==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Thu,  8 Oct 2026 05:32:31 -0700
Message-ID: <20261008123231.45171-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261008120916.4612-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EDE57C000E
X-Stat-Signature: 5u6qgqntsygibmrtm18raccqmni94uaz
X-HE-Tag: 1791462756-571100
X-HE-Meta: U2FsdGVkX1/Vx89N/j2+ZGat5Qj0HHrQmJhPrSOkPM2u4xJP2Ft906EOlI4H3kc8K1IphZ0x4sT3tc0FBN53uVPQZCbca0QXvJoV1+fmvW1eeBzEV0FGDmT5sFnpFEXunFPyjkVGqvWcbuDlFVSoACV9HOInmFdiBo3HWbL1aQfl7sc3SBiIAeu8FlwFf/VMD/QbaR82d3z3cx8o79BiIVeXXXUoGfCd69UwAl6ird/Pa2Ys7vNEu3Yv4s297oVJzoGagyy2DETukbE+K56yEX7Qt4jRgZeKoYHco6k1xFxfuLoDH+ny1+H++E8D9qHnkq/h4kKQkA4ZIT27vtbqvo74TBwv9b5+jjeeL4Ta/eIHkRmod1gOv+3au3kf+0Vvmb05seVRZzsHaDeXy00PM8qYR3WZlB5tnBxfzzcDlgC3SRoTub7Dvkv4Wb5xhZ5XbDgk3YpIyaxqS1QvCUwK1w4bC1sQ4B0KjeYGMzr/piSRxdKKraRcgDXMLyrZs2L4CBsrKx+N1eONBdX3PSoBCEuMqF4KHO5yK9e5fEHzvi3oqM7x5Cu/81BaUO0BulF+pR75Wd5K8zPLFaKUIJGQVUJj/mQS0eYusVJPttEOygw3VXQQoU4X5ahG70TtUjnHjuYpmGyxGQNetbhHOmJU22cgRl5wFfqtZk3sWAepH2l1CSz9flI7S5/DBoTnet7AxA5/jNKx/e+I9pCfIBMfHr1hSEXeuEMBh+88cSoA+okOzSF8B/3f4iaUVNYAxMLI904MqrJomi4VKGYGF62VCBgUgwgV4uIHCC3KJi50L0AuMDFjfIFnE5PxEYaWoO3KaSvmYt4SS/d8LES5793YM+ihVTmbMBcfePW6cyRSZakb3/GtigYNXCIVEot+cV97vobWMRBNBPjNRWndNg6B8jWPnkhvDhoLidiZ0YDCKpvotpOLLzuJy30ZzFQitOBYWPAGMxo1Ytd0XEKee9B
 G2cXSc7+
 17eYuiJwFf9wRdquij6gNOze4WksLoCafGbPzfiSs1AHkYkqWBzsS1iF+6KgfazLQm3qiOI7aod/HbponXAH4vEfVTmtwYfH2eQXsH1u1/MAWFMsGWk5Wn+5O6s05O0LOxs4vxFZHnM4k4NlT2UNC3TcmAKryPDc7boBBo/Y6UlcGr3xX7vF8rmJR6NmsvPq+d2akFOzZLxk7Uj95nWYxMNddp+vUtVvuDuPlZZBip2JR49oDVsuGO6PQSn0kPZOgt+Jy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

On Thu,  8 Oct 2026 20:09:05 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> Just a reminder, I think you might have missed the question I asked.

Could you please clarify what is the question that is not yet answered?


Thanks,
SJ

