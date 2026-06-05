Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73D7CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CFA6B0088; Fri,  5 Jun 2026 04:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DEA6B0093; Fri,  5 Jun 2026 04:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D4A6B0095; Fri,  5 Jun 2026 04:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 323766B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:52:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E73E614097A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:52:36 +0000 (UTC)
X-FDA: 84845243112.03.4A5187B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3B99E160010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:52:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhNQwunr;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780649555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsbfKlaq01f0v1LgLlTEBpfjv/xhSdlj/1kCdcHwrCA=;
	b=2Po7seNk2uX+mjnCTSyowR9qTSAfV5c47nVxUunGiRVI08MJRBsFMNoYCLR3p8fM/poryh
	bHBa+4+1hcfajkj5XsTse/YsD/nKVrRNUXMsAjeXC8Nzxk3NBqplW64OseI37gs+x+CwJY
	TTJUKG9i7CIWVveluJsnDYiX7Y5WS5g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhNQwunr;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780649555;
	b=slsYIAGQdc1Y1tdz/OExwTcWmjKSpx5svhB/9uVWy2k8dYXA4Udg9WF4Vb7/vZ5VlW/yOl
	QVk8sWWF70GysJhebc7xaqL2ODrLHoE7SRehXVHu4rU98/GPOq5xPOoGX41FlTDlzUYWb9
	T4rSk8Z09Ixj32qno17sAz6be+7i0aQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9112A600B0;
	Fri,  5 Jun 2026 08:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC3A1F00893;
	Fri,  5 Jun 2026 08:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780649554;
	bh=PsbfKlaq01f0v1LgLlTEBpfjv/xhSdlj/1kCdcHwrCA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VhNQwunraPqo9lM7LGohuEyegSpdEJJ77cUJE5P1Ox/get019RYJYAEVLNDQV1d/5
	 QzIKEooTy7semBQCXWBL8YxJjYKmzE0IWJU3MqPE8Bj4mvPHRwd518P+woHXM9XsAr
	 dJwjfRFcYKbpopr9XvXWliGuhVhU006c1Wi3N7tA+0nOj5U0wWYwoNPHh+1gRFxmeR
	 mvf+UBBZqIoVRofOon0uk57guY1wjXFnhkruc3Gi/Jcq8INlVmo/5nbeqbNHuniPGw
	 fWGFoIv3fjDfkG3WjZWvmo46nowXgG+ISjVa3ahCEjl39CHLomOpOHENYcfQzg37mB
	 B8H0nT/51c/+g==
Message-ID: <39cbb38f-ed3b-4f17-b9b7-ed466957ee99@kernel.org>
Date: Fri, 5 Jun 2026 10:52:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
 "Luck, Tony" <tony.luck@intel.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>,
 "Lai, Yi1" <yi1.lai@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
 <b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
 <20260603121707.7eccb9fb@gandalf.local.home>
 <20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
 <0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
 <20260603130006.7d2c4a62@gandalf.local.home>
 <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
 <20260603153115.775a2e81@fedora>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603153115.775a2e81@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B99E160010
X-Stat-Signature: qbwn46drskrdtkqwst8iawq78m9s5byx
X-Rspam-User: 
X-HE-Tag: 1780649555-91852
X-HE-Meta: U2FsdGVkX1+vCSjZ/Sbtb7QTtylAMMfOXT11j9zgnAeGLPCzW0htT/HOHKG3lwHmDQTF9dF8sM42lypwh7JhZpJ2rXfKgV7xoCEuEpqAjsqzuz3As93xELr9AC982RpPd7klgFayLfoAr//lJ6yft7rfNewQVajdo3iw+HB9ePQzo44SXdxrVpBAdG5PGCxwUE1j7tG43OYJaq2dl8rZTI4EK1geG+6doSV5DGnGHNZhfvBhdvW8jaYK2UA6juExKyZ13LZlWAFg/BSBuK2TkjJVHiuymZx8vbLhgowV4QWWhVvSk1sCTrHgL8FfiqSQzuqd4JoorucO5FgCxgFORZkvgursauiq7M/xd2QNsdwCCJoxn2/Lt4imX4PfBnCEpSKyxKs6hWcp3VfrOcmwdGnF2w3eYjKynTWw3giOzQHxTd+7C3QrRFtKkqVJNhnqjBxPoXx1MSa91j3Jnm6QZmevnwj2XX2VgA+tZkx8Nn/rH37kpv7xZ+XEUHPIFjwTEC9YXDwp/IinlXGNEFisDAvXsqjBg6kVR2xY3jOJBw8HzAf7OBpSd4EvNHyZiqn8XAseZ8YhvlaZSA/JVQrOyofVrdNclg981Y6WhHPlExFuCP9Ft/XAkjaV5Lwc5XEu4i+fA1188LnHvo08Fq3w55NmSXuSm5T7h7O3Z03vFCYyTH4kAsxJaJjac74Pst9yi+Kt1+Tm6Yv5w7aNERA/OmOfS02qpmCdNl/BfGnZlNl1gYk0UKKUA7LmN/FP/VwfUIrdVijqPAtNAUZL50xtuyMo9iwWy+HHL+bO9Ncc/bFB0ekPwXpZBCG4LlNssmAaz3jWnqaWSrHPb9jFvsVhA3AyuUYIVESVYVTPxwtHJlB01DcvujWbusCobvZdjr0NhaFZ/8hJbwKTIWVZ0ZTpnj2b2cD8psQ2/1DdFQRebmMgriAOk5jJ9Nqpaa/s0E2haJK8hx7Xk4VC55MYwF3
 5jpW+bDe
 gt/voAE6FTux2LU3OU3bXT01l1sBk2FA/8kWVs7Kd7xKmEUDU4iXR7ioaoKdKTwPyfBI90hsBt0MenMO1mW0Bvqd3jr0TwaUM84XPi7aM6W4TDPz+fnwKa9uOZG9Ev2aTDnzpln0frlk4maZGsGuF+8pXC6BElUszKvubYvPjR9jyAXUfzdsR030XjpwglmbSXEmuJruz4b+yb6ABnVxhSzAONWS6LK63WU88fsbmN7KFsgRmC27KhxBIhucSm5wz12P6609DOYfsK76A2rBQey2xvYeML7R4Dc51dovPgP8FDBRIWNXTKWpu0yMRscjNTfSB4RQfuoj5abkAT0ck/C7KdcPUfRfip/zrHrNIX3NdkzF0gucpjcMlpfLupGry/vH9FwdbZUL6Qm4tmisqmdgU5MazEAOAOVeKG7XDWH/go99SXXmweaNcug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 21:31, Steven Rostedt wrote:
> On Wed, 3 Jun 2026 21:13:30 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> Thanks, that makes sense!
>>
>> So, would it be fair to say that, in general, what's exposed through
>>
>> 	/sys/kernel/tracing/events/
>>
>> is stable ABI?
> 
> It's only stable if something depends on it. It changes all the time.
> It's only when someone complains about it that it becomes "stable"!

Heh, so we only know that it's stable when we break it ...

Let me figure out how to document that.

-- 
Cheers,

David

