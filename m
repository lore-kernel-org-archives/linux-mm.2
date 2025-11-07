Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC59CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 01:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24FB8E000D; Thu,  6 Nov 2025 20:02:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC628E0002; Thu,  6 Nov 2025 20:02:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12E08E000D; Thu,  6 Nov 2025 20:02:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD0E28E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:02:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52D9E88316
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:02:06 +0000 (UTC)
X-FDA: 84082009452.23.8E73183
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 53D2020010
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:02:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJgJ+HD7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762477324; a=rsa-sha256;
	cv=none;
	b=DkMdW6YvC4U8NusLXSFL45kcj8J3I2qhzvbYDKT4PXQqOETR8UA5OsI7JW+eUiINqg2YJz
	moPALZK7SpvqfixwZ20YIx27IOnQaUO2frRztJKDEhlvaDfiU8dlDD2xk9uv9lkKQe9ZcR
	DWhzqf0yxFnB9Q4sK0x60nQb8DMFavE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJgJ+HD7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762477324;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgkN+9qm87GBpxjn9Sog+0BYGI3rK0TYVNEeT4MOW9o=;
	b=qnUbUwcseglTuGqdRYQ2oant7N37isLxLTaw0Xxi3Ojbkz+ETzYEXkKeTZoaDmSiH/Hn/r
	ecs44SX8kVwsoOushKDXcspLYrbdX4CgAIJ6PKfZIAHUeTqqnYWTCLtXA2a3RI/gelEOie
	5jEPsYtwzAb65QVsMXjsfemkmd7rPFo=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so398977a12.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 17:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762477322; x=1763082122; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SgkN+9qm87GBpxjn9Sog+0BYGI3rK0TYVNEeT4MOW9o=;
        b=gJgJ+HD793AIysdRYIM4GIqZm+7MScJxSdgvgZ5H6p9//BmWpNC2IzRn5AS9HczebL
         xcLOBDRBMhdzGPbXANo5z1g+WNpgSm1vJY9Udt6mN3t/a3LTvc22jU0Sm35GglC/pOae
         4wp31GpbUVGiSxml3D/O6v92sNcXQyJsbn/446uqowK9ZPH3aRX1FO0rHZi1A4B5To3A
         NiZX7UDzm6Ymhj78wybrEHyypVyZWsnX1F4xrtlyF+6sOGWcusCc/ZwHrR30XgG1taFJ
         zAGgcZdSs6ZdEay1opOGcSS+MPSGilZONUUNspADiFMRhFx8e4xHmZuKtcyoDaJDJQAo
         7TJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762477322; x=1763082122;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SgkN+9qm87GBpxjn9Sog+0BYGI3rK0TYVNEeT4MOW9o=;
        b=wCGSk+odk51lw8dlilYUh3x2fXNRajcQEEo16I3WcsE7rdbzq0HjlSfDGqZVVXRW87
         N4hAUga3ewSSPIS+hKaIzFfirQ+tn7bGUojBjePvzGov82CkCLHIbMcmrk3BAdQoEl+I
         sJV4zJD95BynBCV9TOqROFFNbae2UuzmPZPbvEGoMWocBw6/YyDdSZa3VwSngR5+Ri8S
         8OsxJ1gnRoml2/68FZCpS8BLjgyhAI5xyw1G5geliyv6ED0qmg5nhXL7bmFyFIsNM1K+
         AXGVoUb2V7tqsMezL1Cgf0eLDyk2pRO+ShEeOK9FXmzKmBa6XIq+TA0Vm5ORz89qgKGz
         Y3uw==
X-Forwarded-Encrypted: i=1; AJvYcCW3pJNckYU17dVKBIRmUxZIqD/QHcDA29Wu/gQm+Ya0sp4FBOTEqmzbfTl23KHQpgpGEjqn6+f0yQ==@kvack.org
X-Gm-Message-State: AOJu0YxZzpKlh6AGkAzoNMebWn+d844MayASIW0csYQ5VBYujAFQ+GFV
	ZbTEcUk/FIMZE6HvA2qs2f4eSmjJgN6y1KfDqUclybIBZHKWJKNxZuK6
X-Gm-Gg: ASbGnct8TolZCz6WNBbe0MeL5cIWIlvgNRPCnmfZ3uyQjfzdVSSVwUDTimDUt63ZUVv
	u9MWCBOO2l7W3Q9bDgrgO+KwHEmrPdVaQ/gOaH92wMjyZ2CN3fVs5RIljXBK4pGCStjrNrAkemb
	Rp2yI4sY+m8X3pZuqprvc+A5eJlt52ziKH/lo4++XukmQyss9XdMyEzMOyfQxO7DgLXRAspA/J8
	ZpHNoBNNHcwaqpyB2tZJf5P4hf3mEs1S0rM1QvaNPzgTeij0dYHKEQ9jSWrDCvxpd0LQXDEG0u+
	VA9C3tjM8Z7sHVcfd8/E74wwcZb5pOp95PM6JzwmSQfWpbi4v8swj9vTqppgStA8rYhfYrnPsLN
	NsqT71M0AdJP9eJK2PD39f7iF+yMHUMntKsCqe2IS0c2lKt87Z0hT0zz/oHYieVnQxgxT/FgVi6
	pTva9LT+isyA==
X-Google-Smtp-Source: AGHT+IF+5SqjqFL8oNALXBlTyBu+dI1yUcvROISW+Pd0IsN0p5f0TyAoCtrTnYe1iUVo6mW14bSOBQ==
X-Received: by 2002:a17:907:3f85:b0:b6d:7db1:49aa with SMTP id a640c23a62f3a-b72c0dabaabmr120465866b.63.1762477322477;
        Thu, 06 Nov 2025 17:02:02 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bfa11271sm89986066b.66.2025.11.06.17.02.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Nov 2025 17:02:02 -0800 (PST)
Date: Fri, 7 Nov 2025 01:02:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/huge_memory: Modularize and simplify folio
 splitting paths
Message-ID: <20251107010201.vasfacufmvza6xzm@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251101002927.2610-1-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53D2020010
X-Stat-Signature: 3ro99eydkptrbnfttnre69fwkcugg3zi
X-Rspam-User: 
X-HE-Tag: 1762477324-713418
X-HE-Meta: U2FsdGVkX19kqEL/fzW9fUXKtEBUGyWss7N5gUC7dbNIvK1hJg3WFlW62HsCZcFgMiHASdWMuH2Lji7ZDyAEDArnQitPDHeY+41jNUMaPZgcb4ptDQppdxT/3MEPoXpw9u+ojw1MSz4VfC88wTPj76SwcJjIpQN6rpq26BVgbMlZaK5OT8RO0I8kfGlV+MLmSk/nFm893dRIV9vTBAD04FphNxVjgQvx8Zz3P4s8t4bdIaY1gR1XFelpvuZy9bxW7MWSGLYVeqqS+QD8Z04eNV9LnF6tsHMKnajFnrTInwuJRcFvNZciVYKi72Bop+oQZAg6cVyXbxEp597r+hDLayL+WiZNu60sgTSALe+7cCmoTUpNK3AOFiXKNIlleXP3jtmsM0hCaKNjYECAE+ZZW+pHQ+RD1n8br9LJRe0WY3vZ9BtBSql8ymP06k0ek6EXMLLh4P/EAyvC8yG17m4KDLmH71cgZK+L+BH1sDwXBr1GoZaQ5VQNWqZ/vazAgGC3WyMXSXpjmQ0cBaZbt1mzz0DmgoKLI5hR91DCKCKwgkTlv9V553VQh9462lnABZKeIZekUIHgVPMDv0/asPHhFEFamv5CCxvsosovFsRfK08PHeWLEgtMSkmljw32MtNnpwoZL/WMkURoXNQG4RDgno8YkGoK96h3eJC2YktQ69+6QHzG8Zb6DfuQ+NDDkUdj84tDfIQkAJDuVQagjsQP8DNaxdPQ/b07ut+uXl7HZGczFH3ZiwgR5Di6F73g8hHDyTGNOjmepM74KYTtVE42SmX4z/mk1i1aVTPYCypny5myGq0g7RZOy6VOiznXLecIbH1JWjYrTH7c54l/bs0wcp3ApHSvLs8Hzd7HTZh0mc3YfDz+R3GmpsXeOdPw0VQUPa58w7fXFepJvOoy1581LlNzeRzHOXLAXCXvQ8AeW/4va7EqlHUsem8NL5nksWB2KE39XrgtNQg2MXt84bx
 K7yfdJPp
 oxjf4TEYIbjlbaKDt2GCAmq6KnLRfrydeEzNtBgg06eaAMBVvUXji5+9YJ/YDxiq633ICcR6BSPS1UuNdfuq/BNb7ufNuVRW7Gty7ytS/5Cxc6Ivw66JXuD7GKvZk6LkqfWlTQIf2BvUK0VVYnsLoEy3ohit730gKk53hNsIO/dEFabwJTk5JW8PjdFBfzBR+CHNmLxxsWXoxSr2CDzQ8sPYzHTffgFbPL1/s63BARsZ9Y0BSq4MjvKzbgdbSfmE9B2bChajumbZhEX6eu6PzsE2xtM6rgomHGwqENFKFiZ0idjUDyQoBVYdpGA5OG3gkgvKqvt5BdoXAZsrR7xW0ZXbeV+zEgeDNuWHzX2p0VbAAcpnXMKh+duoVzk1LKxt7pgq1OowBVv0MEn6nxF5Ps8yWrq8HTipkpidEtkNgD/2/c0ph4m4ARt/WbK27u5g7XLiYa4D6DpdaCXsD+ehJH2CQo9AczHPSIt2NGG2DgP4zQsMiymBQKbTpW0tt99iNyTyU1quJcvCRcx4DTmxJQLaMJJUORT6h0HwYuQ1Il9PAo4TWqzIPV9bQo/1++91HPd2uojWdg87XbemAK6DQWWn6ZbgiKK9XwfRNzIPe4hZZoXHcshvC/CgWWsZMlzgxaWb01MT6tYYwGHRc/ZJ1BcYRX9Kzv+T0vIGFAkhf3rDk5hJDJfx0UQZ5pdAaKD7I2uqhAAvxOhtPFbNitZjcp1UukiPSvv42Ok2Ya5C6FOPFXH+bntFZq+svYFn7614LsLkcD3JhlHiBdsldeNiChcJUGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01, 2025 at 12:29:25AM +0000, Wei Yang wrote:
>This two-patch series focuses on refactoring the core logic of folio
>splitting to improve code structure, clarity, and maintainability.
>
>The first patch introduces a new consolidated helper function that groups
>all the required tasks involved in a folio split. The second patch then
>leverages this new helper to clearly separate the different execution
>paths for uniform and non-uniform splitting, which simplifies
>__split_unmapped_folio().
>
>This series sets a better foundation for future optimizations and
>maintenance in the huge memory handling code.
>
>Also selftests/split_huge_page_test pass.

Hi, Lorenzo , Zi

This patch set is based on your suggestion from [1].

Not sure you still like it?

[1]: http://lkml.kernel.org/r/f1830e4e-1630-4242-be0d-1cf65f20b54b@lucifer.local

>
>Wei Yang (2):
>  mm/huge_memory: introduce __split_folio_and_update_stats() to
>    consolidate split task
>  mm/huge_memory: separate uniform/non uniform split logic in
>    __split_unmapped_folio()
>
> mm/huge_memory.c | 59 +++++++++++++++++++++++++++---------------------
> 1 file changed, 33 insertions(+), 26 deletions(-)
>
>-- 
>2.34.1

-- 
Wei Yang
Help you, Help me

