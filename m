Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A266C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB3B6B008A; Tue,  8 Sep 2026 09:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1E06B008C; Tue,  8 Sep 2026 09:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDEF36B0092; Tue,  8 Sep 2026 09:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 959206B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:33:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA6F01C23F0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:33:19 +0000 (UTC)
X-FDA: 85190686518.03.667E380
Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8740016000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:33:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nVi3+4EQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788874397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EaFwKrHIUhKb3ksnKfh7mgfL04pr2lGPE/n+xdAnCo=;
	b=vMXrnh13G5MXBFxw3eEH5yJCVX0YLHzOHxZZ5UVo/63Hdgn8veVLB5TCuu0+mpogOHRiH5
	K9A9/Bcyr9RFRIXQvlgRPNVsXYCgmu7RHwc4ovC9kC9E1yu2R1f4MMma4i5qBmF2NTVIVd
	NNO04pfXkhIJUVIoFkxeVLgn6S5NshQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788874397;
	b=zo+pP4yutWc2/7fYmtwlbQt71NeC6+PB/yJb8vPrZpFuFzUK+ay00GL+NID0zsqfmXgFbW
	uCQ5tr28kZzyN9gXOMnLfj4FFWwzLZ6/EkC7jKWCt/myGTP2ZmlLU7Lv1Mo23MFfQ0lQ+v
	uDcY04S3Tn0M8gxIudZg9HtMCTSPNeI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nVi3+4EQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tE5eScR3IxoTuSxmbp9k/zEYAX1sgNIFgHtL4WOiC5E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788874393; v=1; x=1789479193;
 b=nVi3+4EQI5fpQPU/Ae6ayeuI/8Ca4hslOAAKMjvRjEvj5nY/6BsN/FziW1HV1kMVzaeiia9P
 3bjzs82e/Yuzvtvw+TLgZ8kjSAbdBootfntQcuwB92eHWN8+dBBgpbVRe9HpeAWdYwK6gS6g3cE
 k/5mU1Qfbe13kIE91CPPKYag=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6d91044e4cfde672;
	Tue, 08 Sep 2026 13:33:13 +0000
X-Mizu-Trace-ID: 6d91044e4cfde672
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Tue, 08 Sep 2026 13:33:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Ilya Gladyshev" <ilya.gladyshev@linux.dev>
Message-ID: <85b0e3c5f328e2c3779fda986fa19530ae9c77d5@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/huge_memory: add folio_reset_partially_mapped()
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
 hannes@cmpxchg.org, usama.arif@linux.dev, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 kasong@tencent.com, hughd@google.com, balbirs@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <aqAIFV4nOGPbWiDS@thinkstation>
References: <20260907183340.1446132-1-kirill@shutemov.name>
 <ap_Tjt5vxal-B8DP@gremlin> <aqAIFV4nOGPbWiDS@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8740016000E
X-Stat-Signature: g7rgqtwfwgzc8815qm3xueuh57csng8g
X-HE-Tag: 1788874396-177939
X-HE-Meta: U2FsdGVkX1/PqrRQNPRWPmhKJCJxfw9hp6xTZ744mkiI7sucbpq/r4kVbSe+lKQHIORguBZAVVxFwgg8SxSQG+i4Tx09zf5MMquAk5ISv/PWbmciIzyGifYEs5OkjkMiG2GSvu+PRF1xMki2IQFWycwSZgJ5TJTYs/sWNpR3YhMgy0lL2tMvKl3OWhrvT7xTq9Sy3osTFaBZWmOfIyzgeLTphj4DqRjbXFrBR5f7dZV8QiE/VP0gK76AupohW+uZZldkR1UcDNfCX7Lz0GmroIggTeAQwB29v4Y0n3YxYUpxjVSaoNs14mMUy1mmn27mi5MDueMX8T3bl+uirRonaWtJf3lGRli1aUCeI20h4YmUbN6eiubX5xT8a2ad4VYJNbE/7Hwr6T9RLGDStkAjqmgKBPYwRUCzZzeVfvT2zSM2FsjMlLIbzXGU52dlFd9zQBprOGVdE9nLeoSD5EoIR49qk7/aedT8IRD5/7JGQ+HL3itr8o0PJHmlsskw2EobLanTNgNrV6vZNq6y+yFK6n1+wWomkGhJYtjmrru/BduWlYFs7SIH/8eoz7l+FF54vmNi/B5VmmvrEdPUAKM9zZN4JS9BtGv/5Qfv+ThQ4lbUabsezBfm66EF35SZiex/kebDu43fDatHCamIA5Pm+m1VKNNDM0H14/bdKOFRFFBwo8CgRfybl7Z+wVg8XtSCDbKSJmmk2xQimi+p69aqMDgqE7unsNes9yM5bBSn22+2rcP3BEioVsLn+WekWlxyEK23e2VqVdmBa4bNCPLNq+YX6xXaGYSDD1eQXZ6GQuCSMRA0qjc7aBVyT4gFabYhgOXBvMiRytJKk/VVGP9DWJcKzJCdF5DYnMzdTQ3XYDJIP+gkVqfmPrniQryAzvEO6mFM1rYgzaDxTi0vTAFhjP//bOWWXRkLnUVIMT1GwTsucoKXGfJYo9PjPnOYGm5NtECzNhdypiji+e1mKVB
 Mk9tgpH8
 DmDvKBK9HbAZk23p0ngQPNq6xtdJaWy+25Se5q4HBQcUTJGrVb/nfIS5eWc/CUBacZyQKptbrGYngHxJpdwCEdG/dpC4l+/0OZiCJuuIJIabqRwbENH7ImosmN36geLGIRYthkB+zUBkalXub0+3bIlqYwg04OTUVR/jCQJeEojW2yq/MB+kAiRDRw5NxJJi5MLxVRYJxwat6Rp+dR1FlyDZtPn2X69x0LbaBYCB6EAaFawpu3OuslOT/f2VlT+F2prtq84h+KJUIhXaQf/XMPsUTdN+svXxDJV3VTmiC/hstvH94vhM1t9tqTKZtNniNCxL6vOOJGcDLreenbxvNG4tkpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 16:09, Kiryl Shutsemau wrote:
>>> +static void folio_reset_partially_mapped(struct folio *folio)
>>> +{
>>> +	VM_WARN_ON_FOLIO(folio_ref_count(folio), folio);
>>
>> NIT: I wonder if we could have a folio_is_frozen() that'd make this
>> self-documenting? As trivial as it'd be :)
>>
>> If not, then a comment like:
>>
>> 	/* Folio must be frozen. */
>>
>> Would be helpful.
> > There is a series that changes how frozen is encoded and would be the
> natural home for such a helper:
> > https://lore.kernel.org/all/bb1cb750157733f897df2e261cad3d5c42acc172@=
linux.dev/
> > The patchset seems to be stuck. Not sure what the plan there. Ilya?

JFYI: I restarted my work on this patchset this week and plan to send
a new revision in the next couple of days. There were no problems with
it, except for minor issues with the debug WARN_ONs, so I hope I will
succeed with this plan.

---
Ilya Gladyshev // foxido.dev

