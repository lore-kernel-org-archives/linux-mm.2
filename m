Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACE3C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 07:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84DBF6B0088; Wed, 29 Jul 2026 03:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7926B008A; Wed, 29 Jul 2026 03:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B1B6B008C; Wed, 29 Jul 2026 03:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 358C76B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:25:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20F02C0533
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:25:25 +0000 (UTC)
X-FDA: 85040978610.04.D8CA65C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 626FD80005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:25:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrHTwLjJ;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785309923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDYGOjKuL1DA4Q6uwlbbmneA/BmguYqcNOaxqEegx2M=;
	b=ucxUkC2y0VjIEXCKFkYYyzy8r46lbYEd6TJwsArZji2OArmxtu7t748rDmmf2D1FUDZSiU
	fmyx/keahN3GJy1cdu3GII1KMyGdlCmaXclgeVFpn4dmyxFVe2cEfJDOXRGITzaQAq6NB6
	DmlYcyYp+XbTE1euf4bTiqevCnmEjSo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrHTwLjJ;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785309923;
	b=MiwfZbW68HIwDF9ostPfyLuo3XUxw7YVYr4FuhoxiU1Pr9t9H+KMFLjLpauBFoueevSI7U
	pRCJT3JjinjJ8nRNxE4ykWnKNIVBt///Pfcp65KKPhwuAwf9c4YuZIGB9Q/IIikGOB58pz
	d8waoebQjmmtIl5mD3orbobXkZlk7LE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1F0F60A6C;
	Wed, 29 Jul 2026 07:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0E91F00A3E;
	Wed, 29 Jul 2026 07:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785309922;
	bh=QDYGOjKuL1DA4Q6uwlbbmneA/BmguYqcNOaxqEegx2M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DrHTwLjJpITm/cjqhWV7x/iP3bTeLhLircGa6mbjz/8f+qPhDzz2UQhg2nFWs/3OF
	 EA4nZImw4WZh84vPgyd8V45CC2WNDxOXls8bTlNskB+sMWGOnyEU3uaonE1y1ZiX3E
	 5uaDC6ZdazBr7xk3jw8nmOS6LWoKytzQMyrizvrTlS76Ja+sEjq1NeK73SqS5a66bH
	 Hpx1EGNFGSDU3TnfHQBMD8vJNBV37zyP1E5YiOKOkbsg93KN9mTCG8ZPedd1IDpIt6
	 V8rPNR920GqiSWpwBRzf7BfmDfLmWQ+47PtH1rtpAtSuRK+VMrriITQtZjQ9GWhd47
	 JInm8Ie73VRyw==
Message-ID: <f83d5b26-b369-489b-a305-1eb5ec6fccfb@kernel.org>
Date: Wed, 29 Jul 2026 09:25:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org,
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
 <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
 <amkn21ftNme48Vbl@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amkn21ftNme48Vbl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 626FD80005
X-Rspamd-Server: rspam01
X-Stat-Signature: h477qc3s19ufmd8wdngzn9rdn494upb9
X-HE-Tag: 1785309923-699406
X-HE-Meta: U2FsdGVkX19fd75dv8jlOAhLLOhn+kIM10n5im6/arKUT6oTySAMtJAYeKPA6FpMqwBECikUwJSAeIbSxjMQCyNCB6aPGSHlcLxJuXxWsYnw77GhmI9aQY4zJVjKucOyQQ4oXr7oZuJs36ZbIVHosG0o2dn3vcpGcDjsS5ZleDFFYCdTckQy90j9kmsv/a5ajOZQKPXyozoqUpr1D9K0IBevYNJ8Us6LSf0QlpIJ3BnD6O1Akxzy3suxO9u42J3oCIrnLUvJrlDVC606njF74UcN45s+mSCWwttVdEwSe0MlBG/gOWtlpzmIrqWhuFv/A+GDeU09PJbwUF/AlSOFm+68yHrX+7zN+SA7tgw7/BhUuXdsSZxlw2PtPrlMA9n3LDFZNT3xodRlYCaFn/hcxlC1Vzp54lcNxfVdx8mNeVHpeQntE2AxsScQoGuC68GG4UlcQ+XcX4IlehpsVg99554A2ET1lQJb3iX7ACzzSi1rmcQ0fs/SHDxfjUEcWHKaYqOLSx6qxIoTCoCAI4S3voEfMRGVPJ9mMLJoT2Ch6A2yRwNzYPZ+c0Etd9dJq3r1qoWociENBk13e+m5sXFSGrG5yrIhVoTs06KLJOcItVZgU1UTtvgsPuVSvc/Pj6k80tw2SHq8ZrYY1eusuRexoz5lpw67pxbvzk5nKwxEU5dGjOBOiL0QO7dpOhDhZxR5ZviaZhJNOw4cj8TWyF0RFbckJ61i/4L53vE7mD2ubbcIfkRTeAZf3vZb5aIA2W/YPULfgoWJ/vZy7j3EW2o0KS2IJUz4mO17OAb5F/xCjQupPZyZti94USCRDgXILQSsikWrw5uslHsW5ihzrfZOrLOXv4Mj/zuaNi0c8JfuVeE3LBXCDQ3OvOYWSHjwYH2L8NLwNemfJwl+Uz8AO9AQjT2+kiKb4UjMNduFipD8/8H3C2Ndh7KRtOpHhDwWmhzlT+MGmH0Xvp0HXxqqAjc
 UEaMlphD
 6GIQAd/WUf+V6KGqOy+clUQxKGyfvo1dLXKL9M9ATL7jgb5F/nYbyZWO3uvkgCkPdNlqyQwaYtRcFP/S48A4hU9IJJVaIrf4Sxo+l/PYFUa1trrOQpH/PP/Gp3/RpMJ60U0kpOXoTFuZSc2K4opsNReWtvxslUIJVGk9HF3FaT3xW5kusgKE8wXQ7oKtPQXf1l/wZ/lXNT5yVKKzzxBePOl/Qlp9cM9QLlJpVgU4nt5mplTccpVBs+JB4gQ96kZ0t3cf2eKC2eJOgAWnxkwpfbpxbQ7poikmwCAE3aAscmyI4e2TfhpnCl1CpYqAdwnivTN+HlssYYK0WKclGEHLz1gk59CGSYyBXrQUEPAQftUQ8N6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 00:07, Breno Leitao wrote:
> On Tue, Jul 28, 2026 at 09:21:40PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/28/26 21:20, Andrew Morton wrote:
>>>
>>>
>>> The bash script is still there, no known issues.
>>>
>>> We have the thing and tests are useful.  I'd say retain it until the
>>> rewrite-in-C happens?
>>
>> Nacked-by: David Hildenbrand <david@kernel.org>
> 
> I have a draft of the selftest in C already and I will give it more bake
> time, and I will submit it until EOW.

IMHO there is no need to rush this test here, we could merge it after the main work.

We neglected our selftests quite a bit in the past, and that is biting us now.

That's why I push back hard now (sorry) against stuff that is different than the
rest and not easy to maintain.

I know, hwpoison-panic is a destructive test, but I really don't think we should
just merge mostly unreviewed bash tests that will just bitrot.

Which makes me wonder now: should this actually be a selftest? It's nothing one
would just want to run in a CI. It will crash your machine.

Maybe this should just be a tool in tools/mm? I really think so. So having a
nice C-level hwpoison-panic.c in tools/mm might be the way to go.

So let's rather make this test well maintainable and have it properly reviewed
than rushing something suboptimal.

-- 
Cheers,

David

