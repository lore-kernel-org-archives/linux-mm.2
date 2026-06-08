Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C92CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC8F6B009D; Mon,  8 Jun 2026 07:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0949B6B00A3; Mon,  8 Jun 2026 07:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13C86B00A4; Mon,  8 Jun 2026 07:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E429A6B009D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:27:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACD83938CB
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:27:44 +0000 (UTC)
X-FDA: 84856520448.11.4C7AFBF
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf13.hostedemail.com (Postfix) with ESMTP id 15BAE20004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:27:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FHucFBpw;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzxUbcbj5dWexEFu7fMkwnP4bMPlR0eubB/DtOzn6jU=;
	b=6xkOkn7FQzvb9ibZlVa/uWMFdRHdfpHqstN8AK3wMg13FTONnwNLoYFjQcsSc5IwExKB6S
	72OA4tv5+aCK1Ad0jqp3FAm+rM2DsCFtsl9/YgO7gpm9IwUe/z0U+8dsu/oz2zbKctn25L
	B4ZeFRVIIOArcacg2KmNWAy1xIZZrXY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FHucFBpw;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918062;
	b=twGXyGPOqwCWnFXKhNu5MJRLQHa0pj85uXC8Hz/OpI8h6Qlz+dwK5dB+ljw59LQJbL9Q0k
	9uaNbEPoWScjylmSkyX3b2I6yZZN9lUmadTrmiXtpcp/NFz4Ah8L9dFroUbzqKmemeuNe4
	/jy4w9dDHfh54rxKUMN2Ke+gq2gIivA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PzxUbcbj5dWexEFu7fMkwnP4bMPlR0eubB/DtOzn6jU=;
	b=FHucFBpw3A+rcPsVp7EgDuSypdJrvqA68Lup5Tax6kwrl7ogwm2eCX+gw/rcFd1fWVDQrzPq7
	lpu+pgXFdo+Q1+IxuOLfq0QMGcrhdJO9bA4Ec7y0M9i4RWlspibqGVQxTMg1HFg2HPqFREVGfSC
	U5hB1DuILxZCxDDrqJTvvh8=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gYqM31PC6z1cyPM;
	Mon,  8 Jun 2026 19:19:43 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F1B740563;
	Mon,  8 Jun 2026 19:27:35 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Jun 2026 19:27:34 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Jun 2026 19:27:33 +0800
Subject: Re: [PATCH] mm/memory-failure: trace: change memory_failure_event to
 ras subsystem
To: Xie Yuanbin <xieyuanbin1@huawei.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <lilinjie8@huawei.com>,
	<liaohua4@huawei.com>, <david@kernel.org>, <qiuxu.zhuo@intel.com>,
	<bp@alien8.de>, <akpm@linux-foundation.org>, <rostedt@goodmis.org>,
	<nao.horiguchi@gmail.com>, <mhiramat@kernel.org>,
	<mchehab+huawei@kernel.org>, <tony.luck@intel.com>, <yi1.lai@intel.com>
References: <20260605081213.154660-1-xieyuanbin1@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <5d7eb2a0-e9ed-da53-fbde-548901b55141@huawei.com>
Date: Mon, 8 Jun 2026 19:27:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260605081213.154660-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 15BAE20004
X-Stat-Signature: tiigxh4ptgmox6iz1qpz4nscc8rf8sno
X-Rspam-User: 
X-HE-Tag: 1780918060-797445
X-HE-Meta: U2FsdGVkX18yLtvCYqHf+BMp2CdxCBakDnEk+HW1eNSvbLG4xcaPPBONjR1zIizBXyPF4CyACF7uOdiwSeMHNL0bD/09P7rXLWkVyQgPEUya5Wfnp/5MtJh90bSLGWgkj1xjLw96wvKE15I457hL8U6r2ATW1RcegYqHPe8IPA3Anmt0RSeegTbvMVIn2rNH4sz1FeXJnv5+OdzbYsjW+QZnS+PLCIb1IMDE+fxB3QVgNiZhR8l3fRAZgOyrOgOJP1klUT7K2voxnnor5lnQrhASveExa+6DhOdMWPeZ+xAnT/SIMth3VfqqmSjl/Ipxga2TlpQLMZ+d6E9g4zuqQHL5MfEk/8OhrJZcZSoAULDWxXROdGj3fnwlSMb3ESkcWqfrIMKdARh5Il17UVriQIiQb1Xeynm2aUSCxMjtaTIKSKtF482e5LSkcQWfL7OFwtikwQwd2AoiQOLgYoGxB7edmoL9K39iz/jvhUzZFMkc9kalo0AVkWRrNshQnkqiys3EGeCAA4fj5ff9DOFCOImO8dBB3ks/cy2z4MZ0zYDsvF+knXdiscNfKCO/2EdO+7Fm2ebKiohc8Fk9vRoEKmsYVly6FFZP3uyBPYtpwp+y66Im8DBqBQbsTIm6uLKXYBouOnyLgpUu/WtjZwTSXGj/SHBmtpA+CGH9gPL+t0xkPucj+0GNz50Mvl+MgzYg3ThkbOQD0mowY/CL88l/rVg8+ZrUJrQP4YAwGYphSvvf13PGkV40SV2TCtMUZGDQqIWyEdhs835h8yz74MRcVaNEt54GGnZ6B98VkmRxflS33+rjsROVngWyFQVlwLzha4AtLpVHtUe41OkNoXj7XDp+ODTa2+e6V6mgiVPtc952/cUtQZ/hFfRHs1V5iOxx22FgJOUh+r64g5Z/C2LYFyRyE583YvJsxfK1TaLHrJt0ESiaD7T1dFPG4VOD/B9kpz4RNWYxjdfMVA4rJJg
 zygb31yH
 xvBaSHRpfdzH89xCAGy6aq6xPGej/pDsnHxYMLXRHZnX6jZGW1yCnC7zf52InheZLoip4sfJ1TSRrBCzHlj6+bWDC2cMHMVO4OW/Y00GlZ8niHCKAmVHnAS9yVUzewe/Dy9oS2iIBcs8pXwr6U4OgvICfrq32L4CWNnW4SYHRjYTNMvfJEp/UDwcGXGwoTfAu6sj0uukdYGH4O1cOB4bssp+g29BN+kCdNgMdrc/T1DAQzLXVTI6XhOpkQ5rmYWHDXqD4eTxdSU8C6p4oPOdq6wadCijosW159FUxGD8U2TRC1eMK+3pJQD5JB3YqG7O3EI/JJty3BKkQbOUCVrq63BugmEtQRHGI25i/QgV7FVqMso1L8t9lRiwaVYd0TvLEkV4cVqRUwbd/BWdjzmENsgxZqzwqDuL0fI6W1+t1caKDuy9H88j3AbXO3kRhi6HgaefuKR+KXTYKmjt2HM6FIEbiEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/5 16:12, Xie Yuanbin wrote:
> For historical version, commit 97f0b1345219 ("tracing: add trace event
> for memory-failure") introduced memory_failure_event in ras subsystem.
> commit 31807483d395 ("mm/memory-failure: remove the selection of RAS")
> changed memory_failure_event to memory_failure subsystem. This breaks
> the backward compatibility, some user programs rely on it.
> 
> Change memory_failure_event to ras subsystem to keep backward
> compatibility.
> 
> Fixes: 31807483d395 ("mm/memory-failure: remove the selection of RAS")

With David's comment addressed:

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

