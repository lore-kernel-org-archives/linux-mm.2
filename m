Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B60CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2C46B00A1; Fri, 16 Oct 2026 10:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063406B00A2; Fri, 16 Oct 2026 10:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB7E6B00A3; Fri, 16 Oct 2026 10:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA8436B00A1
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:39:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A723404E7
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:39:59 +0000 (UTC)
X-FDA: 85328748918.25.6FD497E
Received: from mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id E333CA0012
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:39:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dZ3/7o2P";
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161597;
	b=qQ4lvmbYJTifkZ+LOotWEr979auRSpeiyog1yNO/Pr8GBd/ih1vda0CIbt5w/He5C3zkO6
	oBrjhl0ahOzxqRbrXeoYimpzzmVS/O0xa+I5V6yIC8B9EAiYgNlF8+9hiHjZgQHpjzT3X7
	GVOM3vTBCAwZIk+tY0yvRQUMTCt7M+o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dZ3/7o2P";
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXE03LuaQZrNVFEI2+EGmoWbCN8J7g9e7qIgkzPUYkc=;
	b=o94mHll1YaEAg0iw4xQ3Wxnj48ktbsPZ1fkGhX+PtWI4e/eyy1vFIUGBceZuf6u7Q1q4xY
	8YI5zRIEr4dGV+EnB42i2vgDqdb3uA0tutWqItrbTfhCu7/KYrl3kstPHhs6wpFDFnKlRO
	bASNSpyrZXmW68ODcmhwM97yyyj7jck=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QFV7iPIFlCYUFODBqtdHCjoAJvOnecuzp3xttussARk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792161594; v=1; x=1792766394;
 b=dZ3/7o2Pq54lLneMqvwlaE/oXBR133ruUsozkb+85/ocfAVDYqPN7aZh0P8iu4gklBJcgHU6
 kh4yRZEHtCrWpIThHiBhTiVnD3ITIAw11jqkIsrwahJaJTeh1C1GHbUYBk7LZmHqfVtulmamuUp
 a6eC/kzOt8MX1f2YRDxbVDQQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e9d4d2c52d348429;
	Fri, 16 Oct 2026 14:39:54 +0000
X-Mizu-Trace-ID: e9d4d2c52d348429
X-Migadu-Flow: FLOW_OUT
From: Roman Gushchin <roman.gushchin@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>,  "linux-mm@kvack.org"
 <linux-mm@kvack.org>,  ackerleytng@google.com,  akpm@linux-foundation.org,
  chriscli@google.com,  hannes@cmpxchg.org,  harry@kernel.org,
  jack@suse.cz,  liam@infradead.org,  muchun.song@linux.dev,
  shakeelb@meta.com,  ziy@nvidia.com,  "Lorenzo Stoakes (Arm)"
 <ljs@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Vlastimil Babka
 <vbabka@kernel.org>,  Matthew Wilcox <willy@infradead.org>,  SeongJae Park
 <sj@kernel.org>
Subject: Re: Sashiko change proposal
In-Reply-To: <97dcba80-40bb-4b2c-a8bb-8a98b82e7d2a@kernel.org> (David
	Hildenbrand's message of "Fri, 16 Oct 2026 09:56:32 +0200")
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
	<CAO9r8zM_TfD82vZ23zwsd_pPLMpe11_XQhPEp5NDyhoPKDizag@mail.gmail.com>
	<7ia4bj8ufqlw.fsf@castle.c.googlers.com>
	<97dcba80-40bb-4b2c-a8bb-8a98b82e7d2a@kernel.org>
User-Agent: mu4e 1.12.15; emacs 30.2
Date: Fri, 16 Oct 2026 14:39:49 +0000
Message-ID: <7ia4o6ct7lqi.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E333CA0012
X-Rspam-User: 
X-Stat-Signature: 34c75cahifoc6fyys6gucq314ahafbss
X-HE-Tag: 1792161596-443949
X-HE-Meta: U2FsdGVkX19ajY5bNuPDPBtB+kN4tJbQnZXbxDRbWb4O92/WMZ2COkRIhAKzlND9fmD5TtUMY3NA72MT6jtkAeE/1UCUM5uJBlv18grRcQHti8bXMwfLPCtPqob23araJU6gSsQS++pM9YUS5YwQ51lgVpvEXy/knTL/qK4iEuqLDDcvVdakzBfaNsIDFEUGsykUX2GmXkYGPhTNDTiCraSZYtE13AWryEcXRj4qux+RGAICm3pttcSx0ZYYRv04+03lTsqN2gRvbblsuDtf0jICjPXvOmJsk1EkvYdOCqQacDz04VJUSlxcHH5RBIUlZDzhlGbG7/OIO1TjlxLi6b70pF0/pNW7DH4E5s+nMW7LAvzv5irbTYKNeDpMzBBdVlBFicYQrta07bIebNHOMgZI7EMrPRHop2r5QQ1Yg0s1KOfduG+O3GoIDKt/sGjr3puSuTRSIOGMgc4Uib2NMspKQEGAXr7+NY8TsUIcHvoxjQRTltePuzMd64EYcPFrPpEORX/qfppKm72KLd55vcpUPCOmNUKpFqlaFQg+8Loy4ZabsrFM6OI5/vuTMaBAsOqts98ISVO8YigATmAKeahkeow7GD7pQTqj29B66yJSrzetgoLVBAylTaPZ0sFq4/C8EHchFFFs2vZT9z6gVZnh4aRahOGNbrYjv5PUiY0sNmMpyzjZ2R/Y7bAbU+SVUaRNJ6dib2AoJF1TbP77Y8LrjEqqOt9OxRLKTpYTxWRpSQK4ZY4i5eJQMbL5kYVyJ1gLdvQfYN6maUVbAUy2/hQi9aRhx7V1ivYRqPmcVDLkfDlxN0wCL+539q7WS48i1O0hq31F52XMouSSPwJXkjKpjcJVBqhm4PxVR+zJ/zW/KIOsl5oXsY9JgvmKyaifj85jW0jvxl//1u0H3g66GFuJlceh33TGMY1Lr2DO+AB63pDhsNUSC3bsCtQgM5wza6pmgXagSkD7nxErEjZ
 WzmqVqQ+
 35E4V7eaNn6HxIwuH0i+ubIcUFX77lddfBiz3N5jAQ4XTA39eM59O+OQqjvgwdRdoibu8uChMxMVoSTfwYNNB/XZM0Ireu24cTJ4rB8xpbtyr6VJUj0GozqPehqzYxeg1+w3TddUWfZ8V3Y4q8a0jmkFpy06XclOLpq/qwK7805/fCMHXpfvgykS7VOjTVXhrYIAaJwYOiHNPCd43DCY+6kT36xNeEq0eB+SSyWwtQWMxZF0jAvBWAeRopEMT+ZUC3wPL7upiVSKRn7Eb5bT5qXXAguVYnO+jO1DPl+YQhE7Pm3uprbWvzWNdnW5R03t/hzMnXXlGRTbhnQr8/hUcMPJww5/X/GWl75Kz3AQDeAv1Cfa1razX53zUbJv697boJ4AEEibuwtyEsj2lstm0k5IcFadjrxvjY696qsXRW66/3lluw5Dd+f/t3FSYPWOe0oUpzKDC37WentvRoyBK7vFr9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 10/16/26 02:15, Roman Gushchin wrote:
>> Yosry Ahmed <yosry@kernel.org> writes:
>>=20
>>> On Thu, Oct 15, 2026 at 1:38=E2=80=AFAM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>>
>>>> (CCing all people attending the mm-next call)
>>>>
>>>> Hi,
>>>>
>>>> After talking to Roman at MS, he just informed me that sashiko now has=
 a new
>>>> feature combination:
>>>> - "embargo_hours": hours before review is public + emails sent
>>>> - Mechanism for signed-in maintainers to lift embargo immediately
>>>>
>>>> That solves the key issue I had with sashiko: people/agents re-spinnin=
g stuff
>>>> too fast before a human at least had the chance to jump in first.
>>>>
>>>> I suggest the following sashiko change for linux-mm:
>>>>
>>>> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailin=
g_lists.toml
>>>> index a9198de..ba123da 100644
>>>> --- a/projects/linux/mailing_lists.toml
>>>> +++ b/projects/linux/mailing_lists.toml
>>>> @@ -46,7 +46,6 @@ ignored_emails =3D ["patchwork@emeril.freedesktop.or=
g"]
>>>>  ["linux-integrity@vger.kernel.org"]
>>>>  ["linux-kernel@vger.kernel.org"]
>>>>  ["linux-kselftest@vger.kernel.org"]
>>>> -["linux-mm@kvack.org"]
>>>>  ["linux-nvme@lists.infradead.org"]
>>>>  ["linux-omap@vger.kernel.org"]
>>>>  ["linux-pm@vger.kernel.org"]
>>>> @@ -315,3 +314,7 @@ reply_to =3D ["author", "list", "recipients"]
>>>>
>>>>  ["fsverity@lists.linux.dev"]
>>>>  reply_to =3D ["author", "list", "recipients"]
>>>> +
>>>> +["linux-mm@kvack.org"]
>>>> +reply_to =3D ["author", "list", "recipients"]
>>>> +embargo_hours =3D 24
>>>>
>>>>
>>>> Which means:
>>>> - Embargo 24h
>>>> - Mails sent to everybody (author, list, CC list)
>>>> - No positive-review ("looks great") mails (default)
>>>> - No other static email addresses that receive a copy (default)
>>>> - No additional ignored author email addresses (default)
>>>>
>>>> I'd say we start with 24h and see how it goes.
>>>>
>>>> Thoughts?
>>>
>>> Thanks for doing this, it's much more convenient to notice and respond
>>> to the review when Sashiko replies to the patches.
>>>
>>> FWIW, I prefer no 24hr embargo, seems to work well on the KVM side --
>>> but I will take what I can get :P
>>>
>>> Reviewed-by: Yosry Ahmed <yosry@kernel.org>
>>=20
>> Is it time for me to pick up the change? David, I'll let you decide when
>> the discussion is done or just send me a PR, up to you.
>
> I was under the assumption that I would have to open a PR on github, but =
if you
> could just perform the change yourself, that would be great.

https://github.com/sashiko-dev/sashiko/pull/699/ , landed.

I'll roll it out later today.

Thanks

