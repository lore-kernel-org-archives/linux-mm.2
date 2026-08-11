Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3640DC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FEEA6B008A; Tue, 11 Aug 2026 08:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6616B008C; Tue, 11 Aug 2026 08:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC9A6B0092; Tue, 11 Aug 2026 08:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0328C6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:13:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09755803D9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:13:42 +0000 (UTC)
X-FDA: 85088879484.01.04489B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2310F180013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:13:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkcpAC+5;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786450420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGgWpN1i+NlUCQibsDxSg1wYekJ19m1pWqZNmrOKPiI=;
	b=6RllmGymDd9qjpV7AB7kXwAs+gKRcEL6JVEWeFhamx9gsXxgc4sg8toz4i0XMvhyxI+whq
	1qlQCPnn370dIWSvMUQajvn2Y739vsHs/oJXj3/lv71XNMMb3eO9+JaverL9OADEMCdExh
	0K2QDWViklXtHbW/2Ox3nzmF0tyaCsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786450420;
	b=Wafb1B34+Mxcd6OMiBpXMBhMrfOBYPTDICz2QUXNTLjxRxgEKERhnQk3fX7c+MKTXrCQo+
	L7zGwRfIh6ivvqRaoG17dI/UX0K8QWwpmKED367D0jnYSp3lqMYu2AH6dbLB+NnpZxmZ/6
	mo2RJmUTzqF4Xhg2PcpNPK7HwiI8HSU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkcpAC+5;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43BD243497;
	Tue, 11 Aug 2026 12:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B71B1F000E9;
	Tue, 11 Aug 2026 12:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786450419;
	bh=CGgWpN1i+NlUCQibsDxSg1wYekJ19m1pWqZNmrOKPiI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RkcpAC+5i4iSwbVpCxb06SLXvRgB782ALB84/TQxbTDsFJxQ5DiaF6Bp9c8FvbA3M
	 Hw6qFCNlrIk9kXEfnuVEQh1avOTlL5YZt9ow61jljcQsx/yrR5jqeslE5e045TlXgt
	 L85v95miw9GM4em2SbtXJrE1VkcYIU4bcIS3RV8zKn3uTM4lWTlhOaj9NCX/p7MKOZ
	 c4LPOrEL3PlyPY3jf82d4hs3KT1kwpDoGED4XKrRRwLgWsykwgAwdKPOCNr7iiF512
	 QmNsLrUt6/McOxB2NV3VzFsNHVab6z1nwLZ42zMkRmvA+uLHQHuTnNUZ9lfMIgcJ7c
	 NdAouu7sF6I0g==
Message-ID: <16f37d27-657a-4dd3-8935-975fce5a82b2@kernel.org>
Date: Tue, 11 Aug 2026 14:13:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
To: Xin Zhao <jackzxcui1989@163.com>
Cc: akpm@linux-foundation.org, alex.aring@gmail.com, allen.lkml@gmail.com,
 arnd@arndb.de, brauner@kernel.org, chuck.lever@oracle.com, corbet@lwn.net,
 ebiederm@xmission.com, j.granados@samsung.com, jack@suse.cz,
 jlayton@kernel.org, juri.lelli@redhat.com, keescook@chromium.org,
 kuba@kernel.org, liam@infradead.org, linux-arch@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mcgrof@kernel.org, mhocko@suse.com, mingo@redhat.com, mjguzik@gmail.com,
 peterz@infradead.org, pfalcato@suse.de, rppt@kernel.org,
 skhan@linuxfoundation.org, surenb@google.com, vbabka@kernel.org,
 vincent.guittot@linaro.org, viro@zeniv.linux.org.uk
References: <8c763f1b-85ad-44b9-b36c-becd7598fe77@kernel.org>
 <20260806151232.1263773-1-jackzxcui1989@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806151232.1263773-1-jackzxcui1989@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2310F180013
X-Stat-Signature: trymjaourcugtitrct8ig1ay7wzje8ni
X-HE-Tag: 1786450419-541797
X-HE-Meta: U2FsdGVkX1/LxZWhZzMwsLHsfXu++fmWMsZZAeAmJvN/CsXKYIIX1LghO0sfIKhlSIdmzY0oOL8BAdV7UbwxM4hcYVErfxTODaMBScLut5ehFVVfU8UB4MT6oeAp9+a8jcDptxUaeJfl+DzGiVIfSET8B04revo/2pv68Z97mfLb5X47tjNGyOPidEjZYfOzIk+IXRpNWiwC7vH140sJoBrRUEvuRZcJCFqnTkt2jMfX5nslos22nN0l3anbipPj3GE9duChyv/QSfnHWuVJorAQhcsWVohHBqbOyVDHMxemBY2GcUV2Eg6YLwMA+U0aiEp+VzUcIJGy50hSBOQF/98VK5bEt9EY1Y3wMEoESLxaez1TdlMBvFn/wtQHtB6XVGogwWtw8Qsq4seAk7V/7AsvZKLRqvM9DkAWyou2ygS8Rzl7JpfxxB/Bi0eunfvvey58eJonL0UU29ZcOU6xOxPYWwzHKNG1cd2Nb6T6fqKutupLEMaB/hxnJU+KRKdUq3oK1ldwW8ezQIUVjnYoDRf4tdp0Jq9o4MlFijsXhdyvVKOZjkcIoyteMHRObIKX3+ZCTGgXauJLMnBdTGl/vKkP1SNm12PQWQgJ89lFOXhkHkCjqKyu4JNSf5Yppo1pliPlr2KW35KNgz/V7QmWoWdjJmnV5flM0De1paCIImT4czTxO6D+zsqec22sC17pNZjrQv91eSal6XSL8HzQsrBVahNO1ZjW7R7cn4evXDur2nbm9wpbxAfPFdQcs97xjJvzNHyqPhNKFLLDUmEe7PwDA6utIXSbtdhSFglb2xsO5/eGWMj1PIsblbw4x6iUU8weA/MMaMzG04PypZCtBvDp2aIsazughbzszLwK9w9j8GAQL0a8KGvhiaMUy30U312uW0r7Ymf+Zd4lIjHP41W9nacow0i4FauPuEvd2U+0wQ8Xx6UBw7PUGi+8L8J6unPVX3lNVbVTNymk65G
 MW79OqNX
 U4+ua6HiI/blbLjbCJyJ4gWB/mCaVDyPqMxSqxLd+X1imy2PqfTVUlXgXdimN4htku/TO6M6pyhOQVRHVkgT0nyV3tZ6qg0NNMMOvzy9UKAwCq7q4/HcUJtol9+XwM+AQf73rhwcB1B0XDj6urV5tsJ7unFRtvIY6nkfHmifFy8qTUM8XOXJTO7LytUZb0316Fg8/q7aZq0STkMwLPYHNCITZbhi1nMBMWqClaaRrzHkNqVKehS9KKhzsW5X7en97AlePGsqRpGouaSjrb7/5Qjqrvfm6mNmIwL+3FPJwNS1mkv1po2kfcBRuWKKL0PjYHtxgbge/dIxBpgqXuAX0J8Lqic3RK1qhgztRAIYL67dWgcv080Gqt7XXa97iVBHKbrDuBHaRhl9YXsjtG7KWu5eA2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 17:12, Xin Zhao wrote:
> On Thu, 6 Aug 2026 16:01:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>>> index db6167bef..d590a1dda 100644
>>> --- a/Documentation/filesystems/proc.rst
>>> +++ b/Documentation/filesystems/proc.rst
>>> @@ -1939,6 +1939,7 @@ The following 9 memory types are supported:
>>>    - (bit 6) hugetlb shared memory
>>>    - (bit 7) DAX private memory
>>>    - (bit 8) DAX shared memory
>>> +  - (bit 9) fd list
>>
>> "The following 9 memory types are supported: ... fd list"
>>
>> What?
> 
> Thank you. It is a silly mistake. I'll fix it.

FWIW, that's not what I meant. We talk about "memory types" and then you throw
in a fd list.

This all doesn't make sense, really. As Christian says, the whole approach is
flawed. Sorry :)

-- 
Cheers,

David

