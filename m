Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E1FCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 16:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB146B00BE; Wed,  3 Jun 2026 12:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B8C6B00BF; Wed,  3 Jun 2026 12:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA25F6B00C0; Wed,  3 Jun 2026 12:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB4556B00BE
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:26:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A566C1AD0
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:26:31 +0000 (UTC)
X-FDA: 84839129382.09.46D4F3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5BEC140014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:26:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NhoIe9Js;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780503989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMe37VsnL6OyRGxikp8itIp9uDFnNxZm4xOo3bfJSBk=;
	b=JspIsSvIgwZGXcnui5pfYxphkSnXp08pqSHb9OWqiP8xrxvU3p1FWakm0XNGbcLQDMOdV4
	TW+4eZYfN58nXGhhHu+OchV2qRNBJu5FOIM7NpjBbJpKss5VPebb7Bx9WAU2ree2ImLfik
	VN4RTTbzGaC7MUwUDkvesfMRkE+HqZc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NhoIe9Js;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780503989;
	b=GVtYi95x2ZP9TYNU4syFfiiYDobChj4z+1zcJTAaH6xkz487WTJlQUp/Ixb+6EYReXQ93L
	0zAlgiTwf1izyIkk1Jkxry3ZdlVpX5FcP5HhlQWiLVkY2KWSoO1Avlm5aPt80VfS6kM2iO
	/8wVd7trgU8FKVKCgeoojXoDskIZSMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C96060597;
	Wed,  3 Jun 2026 16:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21021F00899;
	Wed,  3 Jun 2026 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780503988;
	bh=AMe37VsnL6OyRGxikp8itIp9uDFnNxZm4xOo3bfJSBk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NhoIe9JseUy9QraWDOJQdPhHINeqv4tohxGqNkK9LGG7E8vjBqRyJOYMewcAm+3uf
	 qMMNE2bV0v/L4yxpLT7jjmgoZbJkpSYDshkwIANRrH0Lwb9noLMMdT8XtQaOwYwhDq
	 +Ka4d+KKNputJPuwp49kg2YjVX4M0tMn/ycMU6IvHh8S5UZKrieQ/7hFmsL/xrel01
	 K7LXaIeZM4XxVvMA8Cox8zSOfFfMPv0EPU72us7Epdn9odE4TGaCF/cXZk0amistvk
	 fi6e/gCmEeLY2iDABj9ItLmQj91eaKLlN/0qnedqdf8ZlS2wLJmxPgBLb4+wcovGIc
	 d5mH5+Od1N8Ww==
Message-ID: <0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
Date: Wed, 3 Jun 2026 18:26:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
To: Borislav Petkov <bp@alien8.de>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: b7coennio4gct6cfhmuqhpgdt91ej1ca
X-Rspamd-Queue-Id: A5BEC140014
X-HE-Tag: 1780503989-454382
X-HE-Meta: U2FsdGVkX1+pjgm2Pt+F+fdN+iHhKG3Kl2vuAW6skqLHV6QXGO5WvcqVO4XmNZVx1JfOdKZSHdpZWRBMU5J4rjB3P7XIpUqK2z/dOyMZFOmoIfkyoQ1cRf2+dMwtAult+IVUcgVls3exYEgDA2TDEqLjOann9SIxuMaAHyRMfu1abtz0OPbn9rWS+pE9ipbH0egl1gc6jEYOF79aOGWaSTzxlMncbBN1CRnPLMqFWA34DpOYYbsng1nuiakYtzWcOmz2KHuTdk/TJ3mceJXZnsebQlere3k4hjd8a5DVL+qQXPkMcdR+4jaejP7Uk3EbQedQuh852jHTgWyBRNBdWKiqLQiIp4Jx2FefjmZhkG+Wq9jrMXzeM5enaRzjOEKrrPbRLXAaOQGxMrpsROFI5gKKBm6L7S1SFFyUBbQPFhXP6sJi3SHIgT29CuGLtJ5QEMNxcQhDWDmf6ICzQO/5YM7VpFoGUj68Tf5vz07/cROB4HPn0B4m0uE41eYymIzgxWGTd0/1+B/8Mw7i7GbRmTEqYaH61/ZUlOasZv7ZM78tcsFkMZ1mc1BsawnwDBa46b0Ls24u9sNBKVSEo/1Pje+86dQ+ytpkkHgYmfY0KfInjtMBusfsDn10VNgYvWZBOwUB1UIscctGzq+176uMCpLMDDzSrzrmJtw+lypGVZPg6WCtTY40QZJBBtSNb8xsjxmQ/lgvBQ/5C35mqHK1ZWjc/9IHtbhBpa8185A3lYiyS078TSKhD3sS/bi3R8EWrY3eZ85IFeh6FaZ1iYD82vPGdSu76hr98qzh7ApNF+3R6phtQFmi33spuC4ngepTCp17fTqH4UvJRlCHddTWvt9lw0Xy9k79rGOak9KPbcpIbzSeJ3PqY3kRAIs1oLQ8hVzJZRD85SFOmr/VyQs/uOddQ0dnDu9LQPZ2D+M7eYrZU8A1+FWu5JPHLX2PUGaLFwkk183ZDtXgR4KUuaC
 BbAvdP3u
 3DvqvSzy2Kd9uCy22H5MaN0gP8xtbKrc60yylTgaEKTUrAH2FlqfdENb/bXA0oaulh9phXAiCr3EKPSzqCsuL+MtGMU5EYpypJD/K9eDgv9KwDetQ1dQfviYULMUXRdjSKuhdu605IxAcDvT3rt52trOVsvsFfKzl2EgaRMZ+rPsptHKJ2rtaNo7szTUzJS3NFwSfelh9pMRLMu02bwBQXhxesvbeUqEXDMSyBY+u1TlOMvGVw1vAZjRdgkdyBpAMfd6KkrfaarSKSUhQGLmmm3xa1ysLZjJ3632+UIwj7kngzl8kc1zwUrXW9bw8F+5fWDMHSKrv5ikLiw+cfN1KJUCFy1GXO5jwok2htddO0I0phOC/TTfxaKj4bC9s/LYJNcK0lYireSTv3ydjz8yZsf1n8w12tVzE8VP2kuK0cyEzxral4A5Nhfvdys7gpcyqrND8T37qNhVUhR5wNBbBfKuZe/RwF0AHyd16fs1nuR/vGh1RHmXMlHY52LNMdNW2r2gp14Q1d4YcBmiMJvBlYCp6vQnuK2rryMApgFgogEIDGjxCDM3nN0Bxn3n8SVt4nz+K2qy09TyvyWRhV2H/mU7rzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 18:19, Borislav Petkov wrote:
> On Wed, Jun 03, 2026 at 12:17:07PM -0400, Steven Rostedt wrote:
>> On Wed, 3 Jun 2026 15:44:54 +0200
>> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>>
>>> Likely the latter. BPF [1] documents:
>>>
>>> Q: Are tracepoints part of the stable ABI?
>>> A: NO. Tracepoints are tied to internal implementation details hence they are
>>> subject to change and can break with newer kernels. BPF programs need to change
>>> accordingly when this happens.
>>>
>>> The Kernel ABI document explicitly doesn't list them AFAIKS.
>>>
>>> There were previous discussions on the stability of tracepints [2], I don't know
>>> what changed in the meantime. CCing Steve
>>>
>>> [1] https://www.kernel.org/doc/html/latest/bpf/bpf_design_QA.html
>>> [2] https://lwn.net/Articles/747256/
>>> [3] https://www.kernel.org/doc/html/latest/admin-guide/abi.html
>>
>> Tracepoints are not stable or BPF programs only. But other applications
>> they are[1].
>>
>> Adding Linus as he's the Supreme Judge on the matter.
> 
> I *think* tools or libtraceevent can't really anticipate the TP namespace
> change so we might have to revert, I'm afraid...

Yeah, I was fearing that when I read in [2]:

	"It has become clear in the past that this promise extends to
	 tracepoints, most notably in 2011 when a tracepoint change broke
	 powertop and had to be reverted."

Which means that I now also fully understand

	"Some kernel maintainers prohibit or severely restrict the addition of
	 tracepoints to their subsystems out of fear that a similar thing could
	 happen to them. "

Whatever the result of this discussion will be, I'll try to document it.

-- 
Cheers,

David

