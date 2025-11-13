Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B918BCCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 04:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B348E0005; Wed, 12 Nov 2025 23:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CBEB8E0003; Wed, 12 Nov 2025 23:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC858E0005; Wed, 12 Nov 2025 23:05:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB4FA8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:05:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 867AFBB47C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:05:54 +0000 (UTC)
X-FDA: 84104245428.13.3246DAB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 824901A0009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:05:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763006753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VfAX7BpKiYHrJFHXil5CTGdcYmQmmN/8zKZXkfBqGhU=;
	b=4mawOZGqO934BD6BX0TPFL9HBq4GiGdcuqahh7LvmMexNDLsEJbiCKKt/Jk5mlaPSgR8c/
	jOOXAfGIy09GJy/4sGKAy/hZpi4Oh06wlbb7pzK7gvfM6upJf0X9FVCbrXJGhwc+dtaUcK
	z+jmZXAL+7XYSlyh6JRzSslY7pEcFCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763006753; a=rsa-sha256;
	cv=none;
	b=A5a1kRUIuT2vq0zJxM+p8jA1asp7FYJAvNt8WU9ORJAjFY6lSIbdHqkeVWR/6tyf5BalC0
	38cUgBmoHoSKlLugoaTY+aNjlL31PCayoJXW0PfNL8eX7/qZmLuD2UTide79patjluwmzt
	YBORdnTYLcjX2crm0xYxSJXizC49EwM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97842150C;
	Wed, 12 Nov 2025 20:05:43 -0800 (PST)
Received: from [10.164.136.41] (unknown [10.164.136.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 549963F63F;
	Wed, 12 Nov 2025 20:05:44 -0800 (PST)
Message-ID: <633b4702-f7fa-4ea5-a428-d120191f620f@arm.com>
Date: Thu, 13 Nov 2025 09:35:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/22] mm: replace READ_ONCE() with standard page table
 accessors
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Wei Yang <richard.weiyang@gmail.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-3-samuel.holland@sifive.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251113014656.2605447-3-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 824901A0009
X-Stat-Signature: xext6csmhz16e3wot4xfnfockw7c8z5e
X-HE-Tag: 1763006752-845856
X-HE-Meta: U2FsdGVkX1/xvjZe+U7UPP8NgklBe+zQ0H7Zb+rdfIMXnolosFJ4rh6zQkkpg7LIREUPQcxxnftxkuqAXmBlE+Z+l/eL71bsvv1MWxTiOJ7N2NtK/TgzA1PqrJfE7WjgVnUxQv+SuLkFWQ50umpTHJsbhHNRSjer+tQ42JyYetTKgc+0yBbGWHugOmWsPvQj0iRz603puukrpBTy1v8iSvdeP45GibyMCt29LDoiDpnKDK4FSFoRqCHsns2eg2KqsLwcSKCerRv93SZGkrfIRA2GKR999Tku7ql3g3nKcpEtBbCBrdmO+Mzmabu9HnrAxje1SabTWym6ShV3Hq+PBK9gGiCEeVOvYVLlbyfHe6qOmvvGGePBjKSlPzFI/hIfp6A/SiGUTu1DgdhBC7b7BGSQtgL2Vur6fWFIXyFnELMFRZmUErBk4LiPlH30FWVZVH1zM4JAbo4JEFivADBFD5uIHhWU0wE4wVef6Miy8U1ub/GUlPdEgTJPW2gyn2bwVdi5BjwHGmo8PKadpI9f2YGISg8NA28JVi+fTifbxsxWbE9O/fW10dCNp/A1eqnb1HzX3qDwhh4xUtLjs+lwLJJMDLa2lyL5Kn50LpUj6ygEC3MhwqUNgOt3M69geRg1xuY5ob7nuW8K6L4MIHbHEG0vfLhvscTjq2pMIohrd11LiXj3vIboL8DdReklM+CUfqZ2vShtaO2yI0nyU3T9a55xMi8XGOACLNOiInhMmbfnbm8POS26duY2meGQtU2wuPWLn66XpiPRle9b0mMP1FjrZc0KXGmttIi+0v4NzQ2QiMN6Ml8SV0RFxIbY4MZA2rnOkvlOOV6NoKwFQ5mdTTuTW1f9P5o5jtTToA9rwk6/mIW2+cybyPAPM/VmjvY1y9GJ/8AsUiGvr4rMY8D4szjnwnQsqusIukkql+8Iv68g1Wm01KOMmM8jcvxaUsZZgbllypyPZjpPHwQQrnV
 4Qjm7vPt
 3bWFtBH1HjxA43hcDpqODDlbnzKnq3gGlC8WeU+GqDcvvyEubb3MgOxPFv6tjBSZ1C6D0qRd1kyy4qPnjpyvYP1HA5CedxhK8qT01nybJLCdB0l068kPvxPZWgU4xfLwdN0HD0EY/doNYlmIuix2eLPpdwH9ita0TScRt/gGMAJqCREPqy+MhSc9M3amIcunsgfYmtx21+pTllA5OxnpUm8pxKn7zw55UaZ70aa4plWHW/BN8/FyvlsC7zhAjXGRFjhC3ru2Mq1lSaazHbMkSF/X2mjX9TKdSA/Fzo3lWW3hwejPUxxU+0CydAK6OCQfpjF3ZZV/kCvQYO/S8xixOcMdII5KgZg0dhAJCwDosFG1AViTGlugayJ1shxc5ORxO6pmpKvL0O39YNoFkAjBoOED+t+M3XTxcVpweEvxcNViXOFgRuqXrBfaRLA+dMF44912RVsBcMy/6dUDWZbJUKMwNDOD0hFzCHNISAzZfgM55ovikCsALXcJw5XSND/LSEPRt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 13/11/25 7:15 am, Samuel Holland wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
>
> Replace all READ_ONCE() with a standard page table accessors i.e
> pxdp_get() that defaults into READ_ONCE() in cases where platform does not
> override.
>
> Link: https://lkml.kernel.org/r/20251007063100.2396936-1-anshuman.khandual@arm.com
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
>
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


