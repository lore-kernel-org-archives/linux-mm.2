Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5667CCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A08866B00C8; Mon, 18 May 2026 20:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB606B00CA; Mon, 18 May 2026 20:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CEA66B00CB; Mon, 18 May 2026 20:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D60E6B00C8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:33:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2169412011C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:33:08 +0000 (UTC)
X-FDA: 84782294856.26.DD1B5DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 777EE18000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:33:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vLEVVK5R;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779150786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICzoZk+LXA5ONKkYzXjmH2pkS56z7T+kTrPZfleaZfw=;
	b=6ue/l4c5yPpTWM5uSrEyBbCNEV2NDscQR+t8nJfQmdJ8twArQZr3d+pOlQz8Zrci9bMx8G
	6NSypOk/J08hmbANIowG0R1wkMPSA9RuSVeTCB3qtxgj1+z9GjLIv6z8qjfMvlw64UhMEu
	lTp57cs6PcNtYI/qbOkVhxpTAWIkwmw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vLEVVK5R;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779150786; a=rsa-sha256;
	cv=none;
	b=r6IKv1q6UnJ3wOy0KuJ9ZCeKeTMZsWsBVJTTbMxRmT8TX0YlvZF+919KfHg1xX2RQkbl85
	w0K9LMFTeSLmraoFVRHBN6mipR/Ei9Jypn65eD7YJu06FfOBhAaE+bPSrcTKzjVb4n2NLo
	b7xlJjf5AlytM1Bd77ISe5ILRnMwp4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83567418E8;
	Tue, 19 May 2026 00:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C2BC2BCB7;
	Tue, 19 May 2026 00:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779150785;
	bh=FuErmdxHsxg6/7/1IgVUv0uGSQ6Zm1dWU+tQAbt3MKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLEVVK5RwKB62dfACFV9CdQRz90aVyGW4NNfOaBD+Cyqj2t8oFVRhT8z6csmuG+I8
	 nkxwkL7LchPTE1L4AoTL8x0o7MHldmi96EOn2sQfKkB2rnpvIF/7S1LlIiUjnkPCWg
	 bwxgBTK5HBjVIC9R4rj1vLFui9p/1hG+MLFdeSWnFKt/q8ho2lTjRGxNlN+Rwj+LgH
	 YDv4DmRpYzgY3cyuu70kp+y+++BgfUm46xwjimQNK5wrKx7Q0fyIp6mkRxcajyXuLm
	 Xi/73f0o+fRYNn0EyX6ICyc/IdJSCQzCLO98p3hzZaNFAdv0nIUpF++2qO/ecOEV8L
	 8gV981wfoXl/w==
From: SeongJae Park <sj@kernel.org>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
Date: Mon, 18 May 2026 17:32:56 -0700
Message-ID: <20260519003257.99650-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518062159.80664-3-wangxuewen@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 777EE18000A
X-Stat-Signature: gbybjqiz1aqm44hi3ermsqr4kx5ce34a
X-HE-Tag: 1779150786-732486
X-HE-Meta: U2FsdGVkX18gujMeVq3tIqCWZ6tPIA4x9zrcJAmIzQbCGvO6Fx4gh7w0NkXciBBSZbSGug1lqTFzTCnJzNiAMT7vkTIHTwQI9YVnu6ZcCevRE2vArGv1PYhuuuftmWNs/rAHqmVEImZno6dgieEY8ktkg9BqY7+rMmAxsPXmAV60GSNueutwiULafQkhVz6VLvMz7v8zcy4B/OZTIR4vh0eyM7eSSF4jYg2NvpOaGMWvgYlGsU9MM9zls5UnneFuBFsUDjMj2uoBlhxTwet8G8N35uqnBpXLPoU0xCRThF7pTPT+FS6CLfMHVjX8NEHUxysIiWDlOGLtUbzDW3wjyrkfnfi/WeADMCMY29+J918IB8iCyIe3tUB/oa/jQJPi4JJQp/4z21g5JkO079tr2tmNTuWnqaALE2ME53LU9m5ptT7IyTJSzjHLAC/ZRPON7c6WCJU/5YsMnzK1cSy9Aw+Ywjdp6YiGb0lj6EAJ7zWXz9GTCR1LnGvaQm/YISTts/16mXnSb0DxqScm8KcG12FkAlm9SA6tPFlYLYQSUGfBMSPZrkO3kOgBNQzAtul76vqBpuzMHATNH8t1lFCcVY26QiMWfuAuCo7k3BQM+D4QhXCzNFdiGxP7c31zabELG7yyHBrs45Q1Vj5MFwBT+prR4tr4AL7HKrKJXoALECfD9tJd+tRf3BGEHtGsM65wHhTvCFJSQOPVtr9pM5ITDA1EUvdkxIFlmOYn3bdysPas6yRdydwAPMPCo5elEP/NijRKGomUVv3RiBlhk0yXIhdw4dCisnGShYhSzHJjCDqZdn6GaSMwEuJ2Fw5epHYXGyQF31EfeeTn0ymlEKgy0nSfFupdygOVwKQHofgy9IFjN8M4fGK/Ob4Sgv2XuhvhYOdks51fik20Lv2u7fgrqrMViTRkNIiGcmo6SnHQP58UvhzcJsLRdVsYjZb/GC0bFPzJS/oHhmFDvTl2cqv
 eyWvEQWx
 MVQ2weHEXOG1PRjOhS6H67F42eI9UhsW9cXsn0zDAfLXL91lMaTlm7+4/G7iMJ9+Y3Fl3XHcOjZkNO029kmger5jsUSzs5nJ0S0md2loRdqsuAZNdwj4yOkD+4oa+9yrTcwjakoOlTMjrjON+IRhZtZSvHGJ3sAqZQtZTZ0JWMVU7RfTw7JReZFsqBki5Y1DO8igGDKKD0dZDsmnVafffKTomEygxEFZ0vhXIh2d2HJiCDq9PNdpbzyY07vOL7yNU1DwLhL0W3wsY8ye/gsc3IGmAlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 14:21:58 +0800 Xuewen Wang <wangxuewen@kylinos.cn> wrote:

> The assignment `x = NULL` sets the local parameter variable instead of
> `*x`, which is a no-op since `*x` was already set to NULL on the line
> above. Remove the dead assignment.
> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

