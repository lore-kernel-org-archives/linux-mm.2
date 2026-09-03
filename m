Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B893C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C17F6B00E3; Wed,  2 Sep 2026 21:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6713B6B00E4; Wed,  2 Sep 2026 21:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5629E6B00E5; Wed,  2 Sep 2026 21:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 328A86B00E3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:24:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1653A01D9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:24:05 +0000 (UTC)
X-FDA: 85170704850.29.C5CEABB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2446D40005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:24:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZO2d/zgA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788398644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4/wzRwhzlP7/SPH3k5OSlfA54gntiBoho4GKMTgNCQ=;
	b=oIF+XD+q7jWXoIBrxqT2WiiZdMo85cB6Fn1/7/JtcwfDPaQ0los0omQx0S0U7Jt7bEbUnM
	baJz4p8qNtRxHCYdRJDf0IXJaq8I+SNEAInkzyFSdpr7V0ngqFSLI5iBoOo+5IC1Ied9gG
	2rZS0bSOhsNS0ZPpI8VpDsCS2spRVj8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZO2d/zgA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788398644;
	b=s1/FYnhCwAKPrrgh4NRLG2RVq+S8fK+HpNgZn24nfOer06cZgfOzhOG+JtBuvuuv4uZDEi
	f2jp5tJgn+EbngEK1gYk4IMGiGFEtg2V9NXNf9zSVCHtrCjCBCoLi8LZdAxOizucEyDt+B
	rom7W79vbW2fsaycq/vgCDRM1UsHOsA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8F0B600C8;
	Thu,  3 Sep 2026 01:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BF81F000E9;
	Thu,  3 Sep 2026 01:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788398643;
	bh=g4/wzRwhzlP7/SPH3k5OSlfA54gntiBoho4GKMTgNCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZO2d/zgAos3QFBKX10N0ADQbrGJityoIwfR+nZ1lxEB7TcWhBiMqgwdwQYomqoZtg
	 ns5EuDCb4blPuPUmM0GDc66jt1JeRgtLgdGmFuSHRp7VgiRrX/ZkDJSHjbWFYdIBMf
	 cL4fnuWnAqKRBBJARNSvIX/TRBEAwQ5765Vr7xN4His/89rqNXmevsTFHS5JgL8pBd
	 VUxnAzzBIzZ9dGr4Pl/EPa/oheqeZ4LGTNQ1ARB0QEs7pH6qAcUG/2HurcqovZL5rV
	 eTC3b4m/ss1FjKB+qkLQMmCt/7KzDIjkVxyIBrn/UYFe7iWY3uqlQlJhzs4bUFn3c4
	 xqe2yUmulizgA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm/damon: allow NULL or unstarted damon_ctx parameter for damon_call()
Date: Wed,  2 Sep 2026 18:23:55 -0700
Message-ID: <20260903012356.95094-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903010334.93622-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: be8oig4bei9hhf3caa1a415pzipx7et9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2446D40005
X-Rspam-User: 
X-HE-Tag: 1788398644-865187
X-HE-Meta: U2FsdGVkX1/RWgR+zM2gVLHQ+mEk6SOo0MM2vBr+WFSDr8wL6YISxHhOY9+X3IEDlcPpT2aiZzYrya5pDEFlGvC0RHwf3yQ3K/QdQnJlSSDDrVvOLsq5g2fyUfsRuiDhYnxt6pBY+a8wyvasGW6hzNfSwUdRZOPK2GWhttQc8d1qmFU5oXx/ANH719gqFi6nAVxv35ECjFiqcXRmBLR+GGrUb6IIBw7s/cC1FnBi/SEpNY4AvlTNBdyk8yQi4AGU0+eOfnHccFtzhqkkN812J6QCJeanmJvNaIHW6kMVp21qJERbSa/Lyf0UQ6R06zW9M4Cv3ZhOd/1vxfenMZ0pdjpCdu+WSph+q97CgGPeHB3gS/ye7gJrNsxUOClFAcsfi1I+zhKqVKxuT+EDMMwJClY84CDM/LMxRP3bM9m+w9/+LCbva2Dp24WJ9W5PNIhf64HA5urt/1HzYomYz+wKFw8Q6p9H90BiRa1+Nv28gsSrIDFV48hK6BfjkHGyHbHWmr19HpKBN60Yvw8jfm0f2DMRTPBXEMgI1jc2nXP1IVcsjRbAcSp+ln3tg1DU29p0pdCwxzoHdXNnQDFtx7hVGm2ZYt0dFq4TaNR682yuGw2kNG7NKl7x3eIOUJpKr8ratDFuxgCKijP1qCelWtCP5ywFnzltQhUIQIhedG0pJriYlXD7c/ecStaJ+YVDpdm8tQ0QtDw9SvDlRHzPRYd05tuSekh7cQz/moheDrRSzqa0cof54/VHNIQIzkp5BuvlDfSmJ/m0YW48ZNNrq23+cNA5yacRAqf+KPaYmOXKxe3DnKU54d8lblSbjgZqw0JdsbWbO/TJvE3Ygu2+Chqt49lG2FkJM+BuWlik0VvSG37d/kwkOSqFycRMGvvbMe0tbNg1urjw4YOsq+Mq7AxsmaQkGE6izodg6AusP2hE0fK2dxg4NO6hPkmnFsyXxl+JrZs2m6mIbJCVZDyTrkX
 DxeZyeO6
 XB/1atpYCYEq7OW/+L4Ii+vbLdNayuuNYScRvnCqR9nlinIIgYr5IjbjrXFOekgAxSuhUcSjJgb89ywSv2DBGIioLNAOFUQanIhRrCw0vcuBezbzqDz4Cndbay0m1reNxPJPIQfN2m9R8oEtKoi2xxheO3Wx8caD0+faDSkke3KlOvGb8QBl8kmR2epPHp9IMecp9LLQPQhL6npssGoDxN6dbRQQz/jZ03RXi1V4U1tYmmT4G1w3Loo+n6U6W0V4OR0PfJT7xRL8QCgFAYZJpTrf+QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 18:03:29 -0700 SJ Park <sj@kernel.org> wrote:

> Callers of damon_call() should validate the damon_ctx object parameter.
> If it is NULL or never damon_start()-ed object, damon_call() could
> dereference the NULL pointer or indefinitely hang.  Ensuring all callers
> doing the validation correctly has turned out to be difficult.  Handle
> the corner cases inside the core layer and remove callers' validations.

Sashiko found no blocker for this series.  Sashiko sent its findings to damon@
mailing list [1], and I replied to all the comments having findings other than
the absence of issues.  Please read those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

