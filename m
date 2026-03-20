Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A922D108B901
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201A46B0005; Fri, 20 Mar 2026 07:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8836B0088; Fri, 20 Mar 2026 07:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEBA6B0089; Fri, 20 Mar 2026 07:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0EC66B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:26:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 942A3138E37
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:26:58 +0000 (UTC)
X-FDA: 84566214516.03.159C753
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1673A120010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:26:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iwpY4F0E;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774006017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDO0zw63Af1I9tfHghuVBXvOM8hKUhU/ec2D/SWFVEY=;
	b=OsInRK6TIk1MnSiO63QDs/dQfKQXnEWMhpjE/y6xP7a6ZQBwz7csI8dwUrJWWCk7zK3JUV
	NxVqWqRPog7U6ElGf4Uz/I9aO5enqP0pUbgxcbOQi3Wzbc1c8eqb7fu885hv17VNAuXJV1
	suEDWJBTs4TFCHpZ+dpFvKYqwqjQQhQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iwpY4F0E;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774006017; a=rsa-sha256;
	cv=none;
	b=JAWZhG/L0R+0uaqPoEFEr3VQ420hqx0WFTEgvxnrOECeapXsuuGKAY3Tal5ZiPMkEl5JIc
	rXdq1+w2Fk2RE6zq3mEVG6nidlbt2Jo31BL1dfeJ4NlD5h8TdERZOGQeL6qI9VJXMGTWyQ
	zNMSqtuoQFE4xy73wo89DNy9ytE84Ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DF5A60053;
	Fri, 20 Mar 2026 11:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C257C4CEF7;
	Fri, 20 Mar 2026 11:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774006016;
	bh=162dit8g8/7CY8fNPwJVXoMvncY0FTaddvmuQ6lnsVg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iwpY4F0ElgB7R6ZfLqDV67akJiYWw79mDZfWcusfNaR2Fz247iqqm4EJGUpKHI3SU
	 t9UrGVSb2LGr+lZGqrKdsXK3+DkiUpmoUc06IRnM6A1+ZQ7c5TGMtjNdREc22Hz1rf
	 dQxs5+q6u2ehwf4NauPemFW6JjeZIrp5bP8roFYkUoJSyZb51q11n952Hat9+YImjH
	 IJfRN1bUP+TNuGCe+4XoyrLuquXk9X8fMOAHZNUZSUgmfQLlc54DG9NJIcGo1+Xc+5
	 EgwnI0qt5ByW5dTkbaQvqioDSgUW5o9Lj7TKugfu/W6qJDqh8/4mZ2azBBsgnUblx6
	 S+f10ws4IsEYQ==
Message-ID: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
Date: Fri, 20 Mar 2026 12:26:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
To: Audra Mitchell <audra@redhat.com>
Cc: linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org> <abludfGu4upPcyRI@fedora>
 <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org> <abxHibvF8E5dcrUf@fedora>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abxHibvF8E5dcrUf@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1673A120010
X-Stat-Signature: oftd6bokdg1wcgow4m7bdpzmc1sokdgn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774006016-908385
X-HE-Meta: U2FsdGVkX1+wgKXBt17/M+qP0wbtxST1lfG5ZpmQ7rLASCX8yEcSkTDLFzPMk59lKn1UP/QC1VqBsr6gcd4IouR2VIZqM8cHWzjxJ23ccdFUfgDagpzWce3GYPWLyuOShzcpT0PC4XMDJaTQwdpJSN3vi+LgscOtf22WmDgPpx18WdgwAvj0IO73V7kTVte5cmEs3YOg/LxPi+Yj+uCy/oum7JUmSoOb7IoBSSkitAvPp45p/j2wjNJj/oTiWePEd03tfkBXPIuBskE0vDnWpc2SUV0SB1XMPMB4DhNM+VeabQ5Bi2V/MUJ7WmAsQgBcM7ovFZkkcabp/RatE9yVc8BgohLu/s8dgt8Qul3gFkFV+SY9mPrP9IEOzsA3zSrLsBvbY8MLRmeVk3+NqBUZmsTuCEsip8rycH5zUlCSqknDb61jOulYqH6/u3ht91wHHpkUWKc08nhueVomgjreY+lPZpA9jXweF4S+ND1D5kKaIeQFn0JLi8QQCTpdvzKPg0wunnHJloOZgYUyr7xqtKz/aafXH3zDnyUDW97omNPYOoFpF5o20hUi5vEjuxtzOdeLL8UbbW0J2NR4QhycL5SIkKSL4lraT5bgDpcCKmdqZLBGsD2Hhj+3Zvky2QtPkYqZexLH4UsXL0lhTX+ESXm+UEg83QLoXzLbg/Ajq8IsdtRveZRQAcn7bOoZiImq6QDD18slKNUqNH5Bxe+EDQ/ypLP7/OUARCSmQLO4zoxK/LwPtlLfIgjcALqswuYvSNOYwgvm4hpWgcXAdttgKeEm2WDQgExjNmAQcN9oLSIOx38e7R9Uc6hoE83oghElAoJdGeFKni2B4le/2qPEjqGJDq8++uil1wkIR8/WsvY+6t+qD4Re7MdYiuasvCxcCmudzBfQDEeDzP+C77ebcbZTtOmwAjK36SYi3H3W89s6jmoRfIxZdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:59, Audra Mitchell wrote:
>> What about simply testing for success on a test area, wouldn't that be more reliable
>> and clearer?
> 
> Hey I tested your version of this patch and it works fine on s390 and x86_64.
> I have no issue with this version at all!
> 
> Would you prefer to push this fix since you wrote it or do you want me to push
> a v2 and give you credit?

The credit is all yours :) Please polish the patch description to make
it clearer why the current check is problematic.

-- 
Cheers,

David

