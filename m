Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D5BFCD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E689E6B008A; Tue,  9 Jun 2026 11:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19416B0093; Tue,  9 Jun 2026 11:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D569B6B0095; Tue,  9 Jun 2026 11:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8E2F6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:50:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75D701C25CC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:50:36 +0000 (UTC)
X-FDA: 84860811672.05.67BA606
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id E59A2C0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:50:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q3AXpyJY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781020234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+6fcZSlWOlBCUqWc42EMaBGgUkNT9qApX3XmRXZGo4=;
	b=vXtpDTMlThBUn83LehUfjsllRf6k8r5mvHnSOtWpLk7/ZLJOvIUqpASFyk9LhiHNv1DDhu
	IbW8NQCkL/HwGXFQde3Oew2lce1upKC2DjEogYzlewNxCxd19a0IQKaFp35vhM9EFTVK6+
	PbAzVg++mbzR8W2lwhc3OJbmgtuHmgg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q3AXpyJY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781020234;
	b=gooC4u8ffL0SiZmV2rs7C7zDsAxOJYP/M56gAA+w/wO2UphieyNTyBfoXzCmFg3BjGmivC
	WVTZ//wtBYJAeI3/34XqD/KAiNXfupWtJe21Buy/TDxtp5dFriV/OsszmLdfLWk3pQmofD
	W5Zcg4+DjcKgjBp47jok6QMCisZB3rQ=
Message-ID: <ed2a595e-bcc4-4af9-99b0-4029f2a13476@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781020227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+6fcZSlWOlBCUqWc42EMaBGgUkNT9qApX3XmRXZGo4=;
	b=q3AXpyJYO06/Xzod4bGBw+cxyrlUjodg9xT2dpSd3ijWO8Hh2CTigI8fxhDNAvpIkDvNXK
	kJ6gBlfAJ11djJYYupjiyZ7pszRj9GhYrxI/76L6LIVaq4wYYK8F2zE3KXhdjyXEDwG3fu
	6wTG2CLRA1CYjTYyDwxdj/y50erOyN8=
Date: Tue, 9 Jun 2026 23:49:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] samples/damon/mtier: fail early if address range
 parameters are invalid
To: SeongJae Park <sj@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 wangzhigang17@huawei.com, liqiqi23@huawei.com, stable@vger.kernel.org
References: <20260609144918.69429-1-sj@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260609144918.69429-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E59A2C0007
X-Stat-Signature: ewna96ksaszpfwftkfnygkwcg1s56rfi
X-Rspam-User: 
X-HE-Tag: 1781020232-310401
X-HE-Meta: U2FsdGVkX1/H2Gna6vpbeQqh4v/0nKBd+zv18FRepTOgtHWHrprU9eLmR8CEk/l4HaM4r+PWkdxbqTVT19N12VCm5Il67IocGRfygH/yOvWzpAXplxDV1AVjHOjkpPm3rkWh5DemCEeGEvVB8w+4pVHWMPgRoPUegKQfDJBCcEXiWi3Fd35lm37uD+xtgkeYQ0WizH4adN3S94YdnEfpWZfRlBTA8l5PeYf3x+4fcat7TgteXOpb8p8n8gLD8wCWb7GEjZxg4a4yQISc4LXzyKbEltpnLXLFkeC6nN6nrtlrMbrrjbf1bQC+FYVMGBoNMwOawq33vE0peM9Lw7PMzAduRNTQR1Fa+wknY6G/BECSas/bJS3ZqINMu/PN4+QpI+SQKWIq3vcxGO8WZSbefXvylaHXwZYzOucAV8lVQTyMpZgVu31d5Epjp7gRUyvIsr336k5BqQjVkDexpX/eNEn6mDpIYc8YprQ19s3MC/HWTni5J78UAaEbyfL7LNWGIE441qqxH6bCAvmbfCVUuvGuQZwfglfEW4OvIDbrL3KR1C0fPLYlz4ytzsCMgO7dKS67p034dG43siSsiqfq19z55JMbFF5gAK8XoZOs1jt3l9c2I6PI6n/DngBg+o39zZJO+ZAiNH4Gehj7hPzCJxn3cZ2HGA55d6kLmZZEkU3awDyHzbPnMYQ6Tu6SLR0NYCa9r2OpgUjdW327hlqi8KHO7+taIJUlLKC2jvVZAWYxQIeJgqkJTDTOei2ULKoMDEPV7nRbfHnMmb5nWmhgm4yZZIEkLhSSLMNi72Bc5c2EfiC9kDhpim3Nuskx2fRfTIDA0cEgxPGvftd4wCIs4MbGJGXslPev21zQShVELKbWr6cheZQ7Jy73zl5jOlKQqeXh87iCRB0pqY62C5KeKAxHvSYWl1HC/AGwQt3jIOGZ+zLMTWQ5AETB0Vr7S/6tERJIK7fNZFJKR5lg9N3
 XgIxXIhT
 hnoe01LExJJNjnYOGEDwA5vTziApi8gIEQZlw88FmdQ7a3uPeb7oWbMX439r96N6x2X3NditC5seryskc4naWiRDRxMZTbvMqZYB90qH/qwzXfBsp0c94KObbrnLqg//B6O0ezah4PA1ywh6k4x4Mu2gm4BoXEf6qdZAnRW41gKpSSi6+/xnszGI5IDlWRonVN0J5yQHapbhT5C8z3RvXQv8UplkQTy/VGWoR7Cru1Q6pDPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On 6/9/26 10:49 PM, SeongJae Park wrote:
> 
> I think this deserves Fixes: and Cc: stable, like below.
> 
> Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
> Cc: <stable@vger.kernel.org> # 6.16.x
> 
> Other than that, looks good to me.
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thanks!

> 
> I applied  this patch to damon/next [1] tree.  We are now quite close to next
> merge window.  We (mm community) want to focus on making mm.git more stabilized
> and therefore ready for the next merge window, rather than adding more changes
> that are not really urgent.  I understand this series is not really urgent,
> because it is causing only DAMON internal weird behavior and one time warning
> on debug kernels.

Yup!

> 
> Hence, Andrew might not add this patch until next -rc1 release.  In the case, I
> will request adding this to mm.git after next -rc1 release.  So, no action from
> your side is needed for now.  Let me know if you think this is really urgent or
> I'm missing something.

I agree with you that this is not urgent and can wait for the next -rc1.

Thanks,
Zenghui

