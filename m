Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88ABDC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9202E6B009F; Mon,  7 Sep 2026 08:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8566B00A0; Mon,  7 Sep 2026 08:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9846B00A1; Mon,  7 Sep 2026 08:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 596BA6B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:11:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C366CA2CE5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:10:55 +0000 (UTC)
X-FDA: 85186850070.13.DFFCCFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 208971C0010
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:10:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGeDkj4o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788783054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEgxloxaTpTQUumD+hkTo1x0B1XK2u96bllDoec8fwM=;
	b=BTKrwyAjEUtamY7wuvLBGTvlQG3MDHbd/FMEkj3hUyQiEDH1BVUjoURBw5b3hFUqfl2QeU
	rkGtALYpHi0Fv8dI3J00rvPODk2vr4Ql4CTwopc/JfbQX62DTaAS/uxEJ6gxkgFzlHEvvk
	lCt3kDB1MFf4ccXzZG9BlSJx7cpnXRM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGeDkj4o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788783054;
	b=EJ/mrJU7gdM51fBzdMsyHwew4ZCeSybivkvWeseHyjyyuerwJ19vxJyZ9w3B+eYaweA3Tw
	DxaN1Jg+uyL5lPkTRK2MORQJUNyGtYf42lup7COrcuYGSPo9NqodEbWSP7VLWzIpwYRWMZ
	7dKdglSIJ7sbfgyiQB5bzwviyKg4g54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A609B601F9;
	Mon,  7 Sep 2026 12:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1040D1F00A3A;
	Mon,  7 Sep 2026 12:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788783053;
	bh=PEgxloxaTpTQUumD+hkTo1x0B1XK2u96bllDoec8fwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NGeDkj4o02tKpAgd+NyPZyzh89AHWoejnLiZjOBD0W4Nid29aVD0ovoPrAqV7UakQ
	 OVi4n3LrbMeKeuNCSWUJUFSUHuWgra9+WwR9zj3mSLMXLubBvkPYfctRmL9NHzsCSQ
	 s+6tmQl8C/B556i1zJDisu1tRKmzqk5zUb5rGtLfpBuu/GyHVyj7leq+9ZnFZfKW48
	 3+E+DJTcEZrTbGph7Tr3FcCvO328MwjrLOn5W4+1JJNR0NiM6fJW3uZLqxqRXLWCDJ
	 EugHFMHMdLa7G9Vw3qVlVrd81jCkvPMk42r8bHkckgrU3Wf09m/vKRYn7/VCXMyok+
	 sD0+9Udy4vy7w==
Message-ID: <4d9e22a8-d261-45b7-b1a2-ede4a4f5c0b6@kernel.org>
Date: Mon, 7 Sep 2026 14:10:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: ksm: Use the renamed ksm structure names
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <20260905084034.39521-1-kmehltretter@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260905084034.39521-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: npng1m1ugd6inh3mn3dcqprm9za4jnyk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 208971C0010
X-Rspam-User: 
X-HE-Tag: 1788783053-912766
X-HE-Meta: U2FsdGVkX1+OXT2lrOPeeUMItD0FipqMkiZivx73p2H9j0fctVotcUSCb5K+cppZ++ErKbdhid9ZO92tQclO7lQY6OA3wB4mHBYc5S4X8JBbbqVn2np1cbOrOiJpH/cZQydo/1uZmsqjoyvfsaSt6WHSn3gCNyN5b9k7w/gbSCx0EnOd5cENgC4PMp+Q29UajLr+nKEN3L0MWelGDd/D7iC80PvNDwMVXUyvtMoytzEEMHCdyju/n1CUkFH8AzLhb6FPTtL9iKyIbohVaGoopJuC9QXodkVUGSE6kexOuX0p/qNKbk9K/VSKIZKDJIhMTe8Gjp5/83w/r0BS79ePyV/OqaO7i+LSBdNkkb3DN4qRcpA0r81g32TBO9JWptgH+TF3gWSWt42P5KCAvGzdsjuFnXMaSAytwTJllFfTuDSWk/fKjYBidpMi5TuQ4uHYsX5nB3uDrN5S/TMEtXhjvjg7/xR8AN0oOqdrz8ZSB0ec5VgSDwUUJAK43McKTj6KKemaFS7lRn6q2J7cAY3X6OPVmMYToWONmr47nujW4fU7Ik9h1Ueg2Eo3bVGqM6WEuJaOsWu6nbekREKcDIiXCoaLv81fanyOC50bJWUeZpDQe9SsPIRpodAlBdjUAs1j//HR7X/6E58D+eZ5dm6du2OXyTgnXBDobt70LjU4cfUwtzZi3b6a5sWRWXtYmPbbX00pNlcdh/2FGRgZms8xTIFmjMKbiNeDRTkpnlhSgy94Jj7UL4nLamwK54997OsJyr8aUMqBXLlSy+fIR63H85l46b78tgbihkFKed8q5YM50IP3qJ1+H1g+LBGY/GZHINMw7tya1ocqZogGzF4XKgFdcK19uJdDllJngmnwnh4fOAHu3I3Vj8qkQoZPC0MtXlPJtkyW1sMFY1A0Cc7EUPZ13+GTq27G2nLHkkw8lNYzQ3/mI+RS0U4Mrl7lb1+Ccy+qqKRadAIKYiQuiRU
 rr1I7yY2
 Ecwtvh7SD3CfNYW6u7ynEOipMJMElUf5Fp0W876dgnrAd8ommk9PK514xD14bikUDJIp5RNUU/kfd4zZCxtKktEl+5wdivbgwNrRixNCIDDFXwgcY5YMUoUiPxHnxF4dubGsbxjzNqfwZwFM1AyisFhrYYrnQUgCVk/pTyPZ5QE5SeQ/dv804J784JUPbPdEb3jAT+VgXqkEygB1ItsBmJzgK75gntwk/WDK/x3rNCiZNVnIN9Bq03NV66l1qhIex1mE9zk1suJ2aZE/VsvJm6CNDyEBri3Ju2I0NDvBi+OmSvbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/26 10:40, Karl Mehltretter wrote:
> The Reference section of ksm.rst asks mm/ksm.c for mm_slot, stable_node
> and rmap_item. Commit 21fbd59136e0 ("ksm: add the ksm prefix to the
> names of the ksm private structures") renamed them to ksm_mm_slot,
> ksm_stable_node and ksm_rmap_item. Since then only ksm_scan is rendered
> and the three structures are missing from the generated documentation.
> 
> Use the current names.
> 
> Fixes: 21fbd59136e0 ("ksm: add the ksm prefix to the names of the ksm private structures")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

