Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF47EC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D666D6B009B; Tue, 28 Jul 2026 15:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17596B009D; Tue, 28 Jul 2026 15:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C305A6B009E; Tue, 28 Jul 2026 15:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3FD6B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:21:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 251AE1C0C65
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:21:51 +0000 (UTC)
X-FDA: 85039155222.14.B4BFDD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6D5B81C000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:21:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vh8cfK/W";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266509;
	b=LK0R7mexoKigxKiBjVz8513OtizUYoTDUPtTgqtCQ85fQ8pQONAG6cG+oBp+EY+jBAiDPx
	I8ymf2UhSzxHYWuv+GxXrszuAfdqkUOpu593cXrWpqK9yxAPmIhZ/LWH8rm+Gb2JhekGtp
	eqqVnB/nRLWT4M1hMjD90mMyF8+2SuI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vh8cfK/W";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGWijSDtWk+fhGO38JmsrrEiRaeSqUZbV8BWwZgDlUQ=;
	b=LV03hnRPP/h6sGzQdxtAUsrhYvpnvOdnCmWJ4DNI4YfrXmhAEORxol0+SXgS9IXFC/x569
	JZD1C87lSRoX9QwDtCR+V8YjAJoItq0aetCXa5bmr079Cp7JtKcLzhzAoxWeQoSuE2EXCr
	HsQnZPk+oMyvzxTWhu4fGp7ybLmC0Ek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E001760A5E;
	Tue, 28 Jul 2026 19:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0C21F000E9;
	Tue, 28 Jul 2026 19:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785266508;
	bh=VGWijSDtWk+fhGO38JmsrrEiRaeSqUZbV8BWwZgDlUQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vh8cfK/WbsuEuEqm5kKXePuRsF7HldqGGeMwCc6tysdn6iqjPxeGymZA3GA++fqkX
	 VxoyTgbqgUxRJfYY5wQqB+npy7agacFIRHmwo0XO36VlGn36Bc+3CA5jQNbpVdMjLg
	 3L/zLdRRMs4m9vef1gt5SiqqHl8JaFk6TC+7S9q6IOJ/VqSVMV4hrl2OUdo+AtNe2W
	 2P9vdFRucWBF0JnvvzqGRXXx43Y+FKSLq3J3wbD8whX4AGHcdtBMfUoPiRAHYi4/rz
	 niF4sE4GFgIpLBbcmj+AWCTJ0+Yq9ZwMy+fOUa4vj050x206qdNz5lAM9rUwNwex30
	 8/rM9T7g3NKVg==
Message-ID: <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
Date: Tue, 28 Jul 2026 21:21:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
To: Andrew Morton <akpm@linux-foundation.org>,
 Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
 <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
 <amh1nZVVaaZSGD3M@gmail.com>
 <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qqnir6i73e11zyxobpzmbg54amt3k5f5
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6D5B81C000B
X-Rspam-User: 
X-HE-Tag: 1785266509-332674
X-HE-Meta: U2FsdGVkX18kVci9bLovGugmGTeI94rTWKKviUK0Nr7WchlAF3vmftukMPhZ8CscAVsNJTE2jhkqRgMR48Gx600YAIvNnxRpNBp+n0l2lscPPOYEC1y+QMZJ4H3lvmw/Qn87d+1Q2KbJvxzd++tNdSzjPONekqJaahmMJZligEgeKWO2K97YZEX/AKtxjdHNIhVLu9k96+59OMFb36fLTH8gx+/g0ad2OmJpgvpbGq4+AIXwHm1iaHNf45ynEvbqxaE2486edxSIOwOQ8bjEABkPiijBZw9E8SGJqkgvSJcqjfWGiEdFIcghXXTLbCNackQLrE6Fl6XKBVmn9qYke1GKngkrTGnjICp2/a66DGLfYpzVijzDHWnDiJZ1XFsUNZTmbf4YyrI0CBuy1WFOUw6WkdxLEfbofoI651GSdt3ivsWq7GCfCFBXGuByjt7MjFougJbdruYszSWHakuiIWS4sHddP4twSeB8HRyXvz951o5YRArJJJcXAtKsZ8cA/+lEahxG4fr+BThWjWMxdFO7pCCkEiVE9y7VYsXH4caApTrBwmunveYXDIw60qY+r8opDWaTbHXUfZNQuUvtB6dsborHVqvifwX7cSBRAaH94FW7i3pwuY8wVD1b6R7ALO3vnf0f4RsWkvFj4vIdmthsu1X5cCJYH8EnEhxTzl95lotxo8VmuONjbIU2n9FZ0AnyqdoaAbO2QxfGhUMAXilsnCE2stPZsVrxBCTBXBvNa4yGVEMeK2Ut4H6Rr4MC/3cnpGibZCMuortkMmdudk2JXXFFqhKh81VZZby7aVbtpNxbycA9MOVsczqt3MOhoOdc0DOv09BpKI/+nHGplbi8cI4/XYpgBQgVbBD0YUWbdu/zwCJ0RTbJ3RAENlerjdLmVRzYjd9EcqAJoPAlRV7yyivSR7U8dknAj8zGPGJJflMXhFNAm4lARLak/NJ740z/xt8aci02LzlrsxJ
 dCtb+Si5
 yuE+FuRxYhg5IlKgOpMrJcOCTcI3rqIM1Hjb5AQMkOC2glxgU2dt2wLsAJebv+0dpRgKeeXMcTZtaKdEKbLNl6nmpJ371vTQbiG00AhTnS3h4ljKOJhVBFnL2ANjgRlC6ZZSSw3ZoBQQYSo9DTOdiraBAro1YRFPs4IkoQejzIL7ms3L/wHWxk5f9L8Y/lspFy6DWV2bYDkMFTw/0vft0lo1DOUes+srOHGj3jhyiRgl/92yhOlfD/dbADvhiUJ571D2okMVvXqOCEUIHmr2UY0cQ2BICYjT7vuE8NsrkQbQgzCbIF7CMPabz9azv4F7b3xiQv5j4TZETZZSZFII3SGMrd83UkNXZ71jY+bpgMPwkyTCWKLNQbpcO3LsMrS3DlU3UDTWWUVja03Ehf37h+9pIMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 21:20, Andrew Morton wrote:
> On Tue, 28 Jul 2026 02:29:39 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
>> On Tue, Jul 28, 2026 at 04:57:13PM +0800, Miaohe Lin wrote:
>>>
>>> Sure. Should I make this change or should we wait until Breno has time to do it?
>>
>> Apologies for the delay. This is on my TODO list, and I'll prioritize it.
>>
>> Just to confirm: the feature is already in mm-next without the selftest, so I
>> only need to submit the C version of the test, correct?
> 
> The bash script is still there, no known issues.
> 
> We have the thing and tests are useful.  I'd say retain it until the
> rewrite-in-C happens?

Nacked-by: David Hildenbrand <david@kernel.org>

-- 
Cheers,

David

