Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB4A10F2840
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146016B0096; Fri, 27 Mar 2026 11:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DE76B0098; Fri, 27 Mar 2026 11:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034056B0099; Fri, 27 Mar 2026 11:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8AF96B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:23:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 990D013C1EC
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:23:02 +0000 (UTC)
X-FDA: 84592211004.09.D2BF2F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D9983C0012
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:23:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c82kjq0W;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774624980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zt2Dstr+xsEVbaAIgi/vZv3q5x/EwYAxCvUg+mW4jWE=;
	b=UwYnfckdUACOVkeitZ4M+QbHq/W8OrfN2xQh/iqx/7Wxf6UtpqjVeIZwcO7H1O4kdi+zYL
	HPj7LPzMRAbibdBBiqFhaz1gBdju/YiKisMvybL1jgerjSqUxBEmBFd2G74+4Yd4Zb4A77
	t2y8aiy3a+Bjmg64krhgsfNbK3yzYuY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c82kjq0W;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774624980; a=rsa-sha256;
	cv=none;
	b=1+INho7pk29EMw7SwrdhxwB1fcDkRYUmNjCj1sIBISUrN1gidxM4JPx/SQ7sevRleUcxGo
	mr7NIkgQ0Ik2z4pK0T5U4MfREaj2hKU8wZNI32hU2y83+W4mYxJOEiSuXEZX/1cFPVdEN8
	Dw+IaLQVfL/1xstUcpz1SHK2FmU3XWs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5080D60054;
	Fri, 27 Mar 2026 15:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0185BC19423;
	Fri, 27 Mar 2026 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774624978;
	bh=NY5mjVUXPp8rAfv61Siy0xKRstYqehmAtDi/Yry4Ass=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c82kjq0W39pptBHRiBS4ArSRK6/Fh/0s2rmqjCc9WlbqLGE75f6ygPHNtm4qaButl
	 0tqYtmDERj0U778/Bf1Nv4fv6QNGup9boc/EtF5hR6AWa8aYdaUlw36792pmYjaC6B
	 YY0h9uttKA4vHNbtz66eFXFdo7Tlow1i0N9cosx6axD29kFid7nuU/Z0vmbZ5dkaEE
	 AJjLBrk3V1X1dHg1MQd99ZAZ+q0QhiE6a7D004X40vcKNf02ETMxyU9xpu3Qr1lnaH
	 U+42K7HpnwVkS1cZs+bkd2mK4lcgSymsOBCLk/sx8TrIRDX/+hSkZR1wFslA+wNUVZ
	 DwXE7pU/Qvs7Q==
Message-ID: <c3b10a9b-d3a8-4e5a-8cf9-3ddb172d2c0e@kernel.org>
Date: Fri, 27 Mar 2026 16:22:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Hao Li <hao.li@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, vbabka@suse.cz,
 harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org
References: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
 <2356614e-d9b8-4639-8e2a-96c5e4eaef61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2356614e-d9b8-4639-8e2a-96c5e4eaef61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z9pc7tmac73qm538g78pq3oue5k8ui3o
X-Rspamd-Queue-Id: D9983C0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1774624980-645922
X-HE-Meta: U2FsdGVkX1+QlAe3ekfjVK4piO+FCSK4tVNl1Uq4yw3F3TEStTYhnxNPrXaD5RQ7TMBVzQzcK8UL0qN63DWrS64cjrquNnQydKojsWLWlUmpK/VZKzvd8ruXwz3SMBv6DYKR8TRfbDaWFsm9bTOqV7vKMwK4ygvPylh6MO68/o9FalcMCmE4g1lfF00KDeVx2+3cMEGHZ7gZZF2lf1sel7A+DhVbo1ru2gJJ+de4b+A6aBzqNfitH5YzeWUVMuM1W5UIBOdQDkoZJY3Nh5TRMsS1jMVggobD2P1Rj8hmzD6rW/R3eYoHRi/jeIc5QIeRYqGd2JmuFmqF1wArLpfLOJEtBSePBbEa6D4QrPZm0yLWoqNFAgCycqEH+teSOhCiSCidb7nMN8zPKiHwANj7wgBbUzH0GKuXvtkpUwcPdgBZDPaB3TbQACDLzOgxKqJdjVFQQ5Nq7gMz8CF+eWekwTzZP9Ia2eD6PkMIpX7XdoVL4FjJt0HOExS2kkBv5EGz4LLRKb8xMe9q6qLo7PwcD2UEXZmmY5LyI3e7NOkNHoiGtqNLXpoZPiCk0hcCw9jzzWGVw8Eq2WuUwT8rDu7GQMQxyxrwYRQIYNr8jL+d5YaMWxd+mA1wBfSfs89Jy8ebHgsUiGOrVMw+QaC67lyV39pDAKcznDy3uJ5mqS6Gz+xkWAa5JPLCR823E8PGkE/7OTH5UINUvdrL+QlgbSaJOewivvpPyGYkB1DNLbuvIOSsDwFxvTJHf4Oo3CSKyBaGN8lK+PbIHZ9LDyZ1oR2bfnhELX4nVagQchzNqeUQtahQX04sEk9nF7q0ipThVMbTZLPSt8pdqicP/i+F12+m7rTUpN5w1UwIoV8WQTcwoN91CHp18I/UiGwdPR8xj8xs/SUY28wttUad8i2md4dAoIgkxrbFqfXX/7o739ahmf4wE1qZFd7Au8aNUO4/T20g6VDMPWcn2zesWFfciAY
 Fh13pQxL
 soKfw/Mu8qoQtaymZSq3Utmu26Ncxf51MPK1X7xKz+NqLOKL/F8HbefBv7P3QXl7hLYAyLGeBoyz3RwnvTMekOqhzWJVoYvWNOj2YKAjQ3HUqGrDzp9zd0R9lLz8nvxdoaom8o/qNxiMlFull3Noez7tFOR6BPAE4RR/KgcidSu1EjbBlq8vCrimT5mW57/Pmmzj9RS7d2MS8wLaOa+b5VFromUsX2ha7mN0L5CRXj9nxZpoB2LCKLW0ye9PQjB9QE1C3EFQEFtLVr/WHhVr3ngF30kyXVvbTKQR6Vuzei17PJp7bDFYJHkvynQC9ip+S92JHIdsgTwVHnzFYrt/1MQEVw2vLEGLJ/4SWYVjMeBqggEcjN2WGZN4w6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 15:44, Vlastimil Babka (SUSE) wrote:
> On 3/27/26 15:38, Joshua Hahn wrote:
>> On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:
>>
>> Hello Hao,
>>
>> I hope you are doing well, thank you for the patch!
>>
>>> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
>>> hotplug currently only updates N_MEMORY. As a result, a node that gains
>>> normal memory via hotplug can remain invisible to users iterating over
>>> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
>>> incorrectly marked as such.
>>
>> The second part feels more important than the second part, doing a quick
>> glance through the code I can see a few N_NORMAL_MEMORY iterators that
> 
> Note in practice it's unlikely that a node would hotplug normal memory,
> start using it, and then manage to successfully hotremove it, due to
> unmovable allocations. Most likely only ZONE_MOVABLE memory can get hotremoved.

Yes, hotunplug of all normal memory of a node is unlikely. Possible, but
nothing to optimize for.

-- 
Cheers,

David

