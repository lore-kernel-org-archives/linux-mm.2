Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18DD9C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669B88E012E; Wed, 27 Aug 2025 04:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6419B8E0105; Wed, 27 Aug 2025 04:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DE88E012E; Wed, 27 Aug 2025 04:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC4A8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:34:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D41501604A0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:34:12 +0000 (UTC)
X-FDA: 83821875144.18.2DD00EC
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id DEAFB120017
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:34:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of gongruiqi1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=gongruiqi1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzkLrI8sqeFJUFJANuhx098MDlg2CjKbPr6/Bv0iHz4=;
	b=cU+ohQnDsI1POrgguuv3CZ8/Fn4zoT416u2KWaJQOXHc1dl85Jd+3FEdaBRxaODUF4+XjK
	VJ4850traAHYwhbN4h7pQjElApkpCA5yqhNSEGFVjXGHPcUme2TaDoXIqJYUFxHOnhKsS/
	hePGVS35N36pXmFt8wsIlwCTNOkKrqo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of gongruiqi1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=gongruiqi1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283651; a=rsa-sha256;
	cv=none;
	b=dvF0TrCOANa0bCMuwyTLbjk+s8ddjseF0c0ySABtr3U/gHDcwgfKQXrsDqQjZ/EhApWf+1
	BUynEAyrA1ro3gzU0Co2EtD3y5gfIxkdFXoYV0caGUc8Kp/5yGFZFOOAXWqopfPA03UxAx
	9HGtUGhGj864IIpwuD5E6wHIZPxvvGg=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cBd492l4szFrnD;
	Wed, 27 Aug 2025 16:29:29 +0800 (CST)
Received: from kwepemk100018.china.huawei.com (unknown [7.202.194.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E97814011F;
	Wed, 27 Aug 2025 16:34:05 +0800 (CST)
Received: from [10.67.110.48] (10.67.110.48) by kwepemk100018.china.huawei.com
 (7.202.194.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 27 Aug
 2025 16:34:04 +0800
Message-ID: <0f718809-9efc-44a3-b45e-a0297f456f7d@huawei.com>
Date: Wed, 27 Aug 2025 16:34:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Marco Elver <elver@google.com>
CC: <linux-kernel@vger.kernel.org>, <kasan-dev@googlegroups.com>, "Gustavo A.
 R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Alexander Potapenko <glider@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, Andrey Konovalov <andreyknvl@gmail.com>,
	David Hildenbrand <david@redhat.com>, David Rientjes <rientjes@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Florent Revest <revest@google.com>, Harry
 Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, Kees Cook
	<kees@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matteo Rizzo
	<matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
	<rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Roman Gushchin
	<roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil
 Babka <vbabka@suse.cz>, <linux-hardening@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20250825154505.1558444-1-elver@google.com>
 <97dca868-dc8a-422a-aa47-ce2bb739e640@huawei.com>
 <CANpmjNMkU1gaKEa_QAb0Zc+h3P=Yviwr7j0vSuZgv8NHfDbw_A@mail.gmail.com>
Content-Language: en-US
From: GONG Ruiqi <gongruiqi1@huawei.com>
In-Reply-To: <CANpmjNMkU1gaKEa_QAb0Zc+h3P=Yviwr7j0vSuZgv8NHfDbw_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.48]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk100018.china.huawei.com (7.202.194.66)
X-Rspamd-Queue-Id: DEAFB120017
X-Rspam-User: 
X-Stat-Signature: ir5ys43h3niannb3kcbxggzq1ch66orj
X-Rspamd-Server: rspam09
X-HE-Tag: 1756283649-347727
X-HE-Meta: U2FsdGVkX1/9k7vF+IafRl+kfWRHSoFGEVUK06YPe4/oc3aKRGmbZS9WCxMxozkVzOiun/q1+igmWCs+M8MX6zTWa7MipT+i/owS5Hy7wUkqJP6q1jOSKvzh//uxExFS0lpNSdAiyKb/+Vp+F8As+YMUnOrTOZv1vTN1fBfm/Cjvm6R6hd6rqMfhjVNuiyfkcyY+umFq7YgEqQuKR1IvzJo5xXhmKqcoR2Q9SqVU2S88Pe+T5sgzns9up48Jcs0fKxWHrWIEOsrPCmn1JIkaj75Dz5bRrozZH1pYK8UI7TTjcojRdME8Pm7he0/b9zXx1xsY1ocp1hk6AxxcR9YCjjK/BCMwyOaVod+AxiWPyXZpNKgz5Zn88d9j0SFLdEOLZFGjZFrodJ+Gj/pFVHG00/c5RhgMFDGlsiGxDgRjoSCYnp+eWuhKzTZGW25PDuAYSorYuBowl0qt7V3Cfr3+6S5ScXwl/FF8OM8i/EBVgzrOESfXy2uv0W4AMt1L/qZcHRLf6O32OlP7294xYebofkvKr+lZYEDXf86xRwTg9gOaBrVzZsVQ6yPIHpe+qubcziPWIt4sqPz3jXL/Jfj7bpXbZIUF9sMii1g1tt8Df2UIQGqW6ajx1HVidiU0u6WmbmDhrx/ukQY52gF5n26OWLyj75cbpd7akiOOFyEKX3R/IPvgI02Q3pw/JI0JD00NPusglAHkZb6Lr00N4eV3Bn7Ci9sVVPJkUokv3beZwpMfPsoNgo8Pr9ZddmXWAGAH//z27Bm/9Nm+jZsTzE/NQykCVn2NKJ+P0o52Oy5SkpGL/CIxCK2BoxAM8Dtiu96CcskpkDW3TOyPx/E1Cv2SON3gHPl0kfksvHoZ1f0tiKIUdx2yNWFXD5jpPnKzrY6+f1geEqMOBGnDyZRS65XDMc0GhKfs9xcVw9WLIRX0aPufRq/Z/0defrM6vMi4bTwaHzQ+TsQTcqyKQkpydHj
 UJuQFNXa
 FTWR4Y2ZK8ts7ZZlT9fy93SK2UbcvoEt6iMqkaJ7oLG4fk7lqC579STteqwerEWLqh4I62OIw61sHt/xHG7Q5f7mifmNsJlakPq8hGaUS3nlo+Ac/Toe2x3mIoUKeFlFUbAaJ/+pd+l9kPEoTyTHAF5RbqMgM1FvusOWDpzJl/F+BNk+8bGIDtqSy4Xme3xWEG3dDz3U3l6j3NWAQS+FXZvUkD+WgLX1gUZOuEHWCOYQMrqGYsvsLNy9KAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/2025 7:01 PM, Marco Elver wrote:
> On Tue, 26 Aug 2025 at 06:59, GONG Ruiqi <gongruiqi1@huawei.com> wrote:
>> On 8/25/2025 11:44 PM, Marco Elver wrote:
>>> ...
>>>
>>> Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages Clang's
>>> "allocation tokens" via __builtin_alloc_token_infer [1].
>>>
>>> This mechanism allows the compiler to pass a token ID derived from the
>>> allocation's type to the allocator. The compiler performs best-effort
>>> type inference, and recognizes idioms such as kmalloc(sizeof(T), ...).
>>> Unlike RANDOM_KMALLOC_CACHES, this mode deterministically assigns a slab
>>> cache to an allocation of type T, regardless of allocation site.
>>>
>>> Clang's default token ID calculation is described as [1]:
>>>
>>>    TypeHashPointerSplit: This mode assigns a token ID based on the hash
>>>    of the allocated type's name, where the top half ID-space is reserved
>>>    for types that contain pointers and the bottom half for types that do
>>>    not contain pointers.
>>
>> Is a type's token id always the same across different builds? Or somehow
>> predictable? If so, the attacker could probably find out all types that
>> end up with the same id, and use some of them to exploit the buggy one.
> 
> Yes, it's meant to be deterministic and predictable. I guess this is
> the same question regarding randomness, for which it's unclear if it
> strengthens or weakens the mitigation. As I wrote elsewhere:
> 
>> Irrespective of the top/bottom split, one of the key properties to
>> retain is that allocations of type T are predictably assigned a slab
>> cache. This means that even if a pointer-containing object of type T
>> is vulnerable, yet the pointer within T is useless for exploitation,
>> the difficulty of getting to a sensitive object S is still increased
>> by the fact that S is unlikely to be co-located. If we were to
>> introduce more randomness, we increase the probability that S will be
>> co-located with T, which is counter-intuitive to me.

I'm interested in such topic. Let's discuss multiple situations here.

If S doesn't contains a pointer member, then your pointer-containing
object isolation completely separates S against T. No problem, and
nothing to do with randomness.

If S does, then whether they co-locate is completely based on the token
algorithm, which has two problems: 1. The result is deterministic and so
can be known by everyone including the attacker, so the attacker could
analyze the code and try to find out an S suitable for being exploited.
And 2. once such T & S exist, we can't interfere in the algorithm, and
the defense fails for all builds (of the same or nearby kernel versions
at least).

Here I think randomness could help: its value is not just about
separating things based on probability, but more about blinding the
attacker. In this scenario, with randomness we could let the attacker
unable to find out the suitable S, so they couldn't exploit it even
though such S & T exist. As you mentioned (somewhere else), the attacker
might still be able to "take off the eye mask" and locate S & T by some
other methods, e.g. analyzing the resource information at runtime, but
that's not randomness to blame. We could do something else about that
(e.g. show less for random-candidate slab caches), and that's another story.

> 
> I think we can reason either way, and I grant you this is rather ambiguous.
> 
> But the definitive point that was made to me from various security
> researchers that inspired this technique is that the most useful thing
> we can do is separate pointer-containing objects from
> non-pointer-containing objects (in absence of slab per type, which is
> likely too costly in the common case).

Isolating pointer-containing objects is the key point indeed. And for me
it's orthogonal with randomness, and they can be combined to achieve
better hardening solutions.


