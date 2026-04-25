Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 426A5FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 09:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678336B0005; Sat, 25 Apr 2026 05:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602256B008A; Sat, 25 Apr 2026 05:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFC26B008C; Sat, 25 Apr 2026 05:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 34AC76B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:36:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDCBC1602CF
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:36:18 +0000 (UTC)
X-FDA: 84696572436.02.DBDD722
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAB0D180003
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:36:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026032601 header.b=Vq9nQMq4;
	spf=pass (imf06.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777109777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhvYVy2+fkh/jv+3V2pLBqAm1atXD9hJChgcrEaqFKw=;
	b=j46VlDVDH21dhhmmXkrI2NBSJYp+uCLxoDRr0zlb6p/W/wAxFmr5rHCZTVQ0tFGPo1rsW8
	ipT3eyPCAY2LR5JjRIVgXyIyfFwaeP0uR3U0aMvgQ0rdJ3jGhwEClgSX3T185ll5uFRaBc
	d4hD8B3t1D8PKo2DW0wgxhzuYzn+c5M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026032601 header.b=Vq9nQMq4;
	spf=pass (imf06.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777109777; a=rsa-sha256;
	cv=none;
	b=hvihZk7b9Af0cVwHY1/1Lw7ne6lH2vrjtCveCnjyHYiSgdPCoqNPu8+kd+pCK0E29hL5UI
	EpoERYZ1yoUxczqj3hR5q+DPGGWUmxtScFtxGOI8N5ZVxaaWU8roxREhO8V27WdpU6jxVA
	StXZZ8V1kzxZrpMsafiyC0gNzgXGNsQ=
Received: from [IPV6:2601:646:8085:1a81:cb3a:9fd0:def5:1007] ([IPv6:2601:646:8085:1a81:cb3a:9fd0:def5:1007])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 63P9JaV7911354
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sat, 25 Apr 2026 02:19:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 63P9JaV7911354
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026032601; t=1777108779;
	bh=vhvYVy2+fkh/jv+3V2pLBqAm1atXD9hJChgcrEaqFKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vq9nQMq4kfTp+Ig7AH43pPk9xHx4vM1reSBisRaZOk0XgF/w6ztm9SmpOMJYgh5mo
	 5emme67gaB/t2CpO/AxyVfbFoYal6m0gJVTTBuYhEqca+BhmIcA6nqCs7R5cWtZv5X
	 Ia96Dc2+fcqCUgSz/2xnTgxr0gIyQ7uGp0brObF5kNwCNyRHeG5lGnfknU2c9lvuKk
	 LD3D6ap07frG4zWBubO6LGJTSQXk3v5KNxVcleMddkDqBIeh7s+enQqF7ue9thOY9Y
	 CbVGFsQ4RHuxr2DgvW2NmUcqnoH9BkD9Bpp/7PuIOZVHQPhuDf05jv689sY4/MwsY+
	 Sh/r4QupXDlJg==
Message-ID: <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
Date: Sat, 25 Apr 2026 02:19:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Dave Hansen <dave.hansen@intel.com>, David Stevens <stevensd@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon
 <willdeacon@google.com>,
        Quentin Perret <qperret@google.com>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAB0D180003
X-Stat-Signature: xmk1xbbahfddrb5eq3b1wmm64cqh38am
X-HE-Tag: 1777109776-272680
X-HE-Meta: U2FsdGVkX18VxL4AF/byqhZBpt1yBFV/BbaQyANctQUoJMj6d/2r1yYRQo2GqncKjiuto6vynJWt0M1YEs9jGQHifq8F8/1894X7bnnoGpaMn9QmnUSHUXxsa6FNm+dMkpi7KjQcHPxsA5xnYLRxw7+JXVY1cEpFz077qLcGOcd4A+b9KFXV4LDmDTEZzhQw32UoF0hYN6SEJokH8JYcSgGdCGKOkWGomiDHJA+gYK/5aISNzjRgOA7+uJPVOFlFley0bCVZktXIkJj+hNhZUscbRtwV3K4maKi4H8b5jApMl1jd0fo7CcSV5I+PU888xIAOSEn7lxBwECwua5NnGIK0XHruIlZ2Q0z9b321K67BUvqDzxJ2fvWMAUMcgiUJFu9UCZiO2PiDEsYGvtzmQax1N6MhO2outSO2304KEu5RbiIYyoKRkTGX9MxR8+QbIQjkEqxP3b2BcIOMMOYO0hgsShAuKzXesrzKdpwyfcjjl3r24iYOZk/oMJ5T6l/H89jzvTnPDROHGyCxOAj+rGYZlHFcazkfr6LWcOI9gJPCc+2rAJsCzI5IvjsPiV2IV3bu7TAz1Ei9qLME3VWwP4tTMrbtYDolbyYMQUY8VIDRL+r5NP+eRQi934OHc4r5Kx7LZrAFQv2FzdQZ1n+MFIdMLaFoq7BwhB2sd9ljHM1IZo8iRPZMQnT+GnamHEBs7ZASb/7mXtZ2P68doWI2ED4dMDt6KD7hSMkhk+keBMQThjiDfgGaYU1YthGlFOQ+6z+AvD2W/brGwoBv0W7gPJCMIfeClL7UqIbwEAC8GyORiAjj5/YzcXpbdEAEkCpOUy6uqEtHBDVvtfpOh/MURgXyQIVEnYB9On1MwKISW2RmQN/+4VXDbkUlZxFE2CdCFHWNvq5tRtQHJ3Gvl9lHWIJHw0Kbg0vyZCHBnB9xLQ9BvYcSrvP9Vl0I9fICykd3ysQX/mJSvDwzrQqmmvZ
 i1aWooZn
 3ybCrpYGYc1SXhZpLKYhxwpH3jMOwcLn1Ze2s/hlsMnAL1sxkD/bQj9eCh6rgPlF1hbcL3Olxjr3KAv6ohvJh/HoFtgPZpFzTgf2V0LdFRfB932+omHsBMgIO17iCB4Q7+zPcctJt1tLzMs7hM/HTlJwh7KNWDGemcOyiiBLuEZco+r7sLEyT0zby3Teo8ULDcFwXacGjDUP9XYDnd8AW8rmLHoJYmI7ZBqDO2VgrPgegl2Sj9BQkmE5Dk6hUe8HkEQnWyO6lXwwLE1BSuGfEmHZuE0yPyYWEuqaEcYFHd/FRwl6MDYXMZ0W9zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-24 12:41, Dave Hansen wrote:
> On 4/24/26 12:14, David Stevens wrote:
>> The question is then: is this approach something that is fundamentally
>> untenable in the kernel
> 
> Yes. Fundamentally untenable.
> 
> Not allowing stack faults has been a wonderful simplification. It's one
> of those things that just plain makes the kernel easier to maintain.
> Saving low single digits of system memory is not exactly making me eager
> to go back to the harder-to-maintain days.
> 
> I seriously doubt that this 1% is the lowest hanging fruit for memory
> bloat on these systems. ;)

It is worth noting that this was one of the VERY early design decisions that
has shaped Linux from the beginning:

- No swapping of kernel memory
- Kernel stacks are statically allocated
- Physical RAM is mapped into the kernel at all times
- A "monolithic" kernel using function calls, not message passing
- A kernel interface that closely maps to the low-level application API
  (e.g. each user space thread is a kernel thread.)
- Kernel ABIs and APIs are subject to evolution; stability is only guaranteed
  in user space.

Those design decisions are, by and large, what has made Linux Linux: a
relatively simple, highly performant, and reliable system.

	-hpa


