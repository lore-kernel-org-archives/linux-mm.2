Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA1EC636B7
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 20:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC3D6B0088; Sun, 22 Feb 2026 15:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999C36B0089; Sun, 22 Feb 2026 15:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871EB6B008A; Sun, 22 Feb 2026 15:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 714FD6B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 15:18:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18E4B1406F5
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 20:18:54 +0000 (UTC)
X-FDA: 84473206188.04.1F20AE8
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 045C6180007
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 20:18:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=OnLGwVPh;
	spf=pass (imf24.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771791532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYfTFIroNf85DTobS2svLK6WQ8ILiGnG36jHKS1GRiU=;
	b=6jU2EqpsrFCFu7tqrwT3CRrngnEIIfcCt1LhKzvzg7VRyAj9vI/pG//uiaNq2MlltRFXtH
	IuH0Jkl2bfTlbRfYhKIhTiWOhGS1i/MUjMH+aK+/67Rmgu7a6sim/E7cU+2ucP4wImySK4
	6VmNYSKqff2cUFE7h5HyOuEceWraf7Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=OnLGwVPh;
	spf=pass (imf24.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771791532; a=rsa-sha256;
	cv=none;
	b=O97BB1NCjmH/pXamYDZqNekGsYnHD64khfh3LK/lKEqM8s49OL4ehfPpScwofcOpTWp6w8
	Cv67zgzMwIEb0v058ErV46/NIaK7haDr9VO9tk/ScNu6TvZ6JPaYQ02etCJ/w1kcVCPzhj
	whANW5B6pa4iBoG6jU4A/suzzboKDrA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BYfTFIroNf85DTobS2svLK6WQ8ILiGnG36jHKS1GRiU=; b=OnLGwVPh2IU1P3Lug2trtYyxtR
	wuMVFjJTH5oqzqO5d8oNzwk9iRr5oOK3nfcBvvO16DKuYAQ5eFXmdtxR2WWeXzmkba4Se84EMYGCJ
	lUUieP7qyYWwjUMETk97/ww6lt++dagUNNL2P4G4aVJJHpQ3V2XzR2SyARl29VYR4bH/nfDdgWgWN
	doS9TpZfS2maFkLz3gIv9dn+HQvUiXVPrnWLG0sDVFIHAjb1aenO2ENQ0VQVIDEBN2B2ISXUdmXnO
	Xcuo5/NdPMzoCxg/oD9ESH0vQOPOiRQcsYJJ5W/GNa9P07Bj7HnZzcfFqS7MMXtVvybcgZZ/2Kr+j
	bywa5Hyg==;
Received: from [177.83.214.207] (helo=[192.168.0.51])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vuFuf-003xdj-5H; Sun, 22 Feb 2026 21:18:45 +0100
Message-ID: <34de3a3c-dc04-a9a8-d90f-afa4199e0168@igalia.com>
Date: Sun, 22 Feb 2026 17:18:38 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
 kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260217195816.861684-1-gpiccoli@igalia.com>
 <20260217195816.861684-3-gpiccoli@igalia.com> <aZlyVHwUdxg5WZBe@kernel.org>
 <20e28221-f9c7-47c0-43fa-72bb2e868386@igalia.com>
 <aZtWrjlAaljQ1F48@kernel.org>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <aZtWrjlAaljQ1F48@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 045C6180007
X-Stat-Signature: cukdp6yd5m9ircnuczqot37ra871qsyo
X-HE-Tag: 1771791530-384804
X-HE-Meta: U2FsdGVkX1+aEzrXCyMsZHlpqwG9uSXcvZoS4wjQIy5nmke+qWTnpZwj2FWJIp9i7JUsa0TEt/tzWKpwN8FoKxIrj9jCtjrlSMTnmo3Nx8q439KwQ9GG6XZ6G+v21yTw6Z0YDwfHVcwXTB8DJtfjiMIGWUYiv7WIMJdwGioL+20FbZfYy5RUYpFLD9PZf0yS+5WpU5rfAgXf0Meb+4i9bduHIIHRexmEsBLuB9Roa9BfCtMEn0/iD1a4hy4ECuqH8lC7HcOAQWzoobbGLPwX7O8R+RixC20Q8i1svzDhzaJrNuG2gVBQTplGgYtA4yXudowaiWFgo0yT7HuKBhuBn9ISe47MLPG8pLcM78VxmEoi2XNd+KkiTETfU0aix0tmoRv/yyEFF0fDRMcz5Y1IRjNy9WUO5UDuU7p1PxFynC0j/eiqF3aqG3gJeEByB9BPGBhggHKv6n+89/IwIw3WNSVep4zreRribL4nIUrPv5siIyx98+ANfKromkJ8m0341FC+ADnXgTQHpnzbxf4amRO+JLUvIc4HnYP1G3/LpMNx9+LDLdoCeZu0B3guRhfFk+RH21wgAIQUkLLIpHwsh9Ozwa573GeK12OJfFX+eqSPyiQNP6BAQduwOchqJQkmx0vfG9wCzmx9K9qw/1R8I3iBnXTc/BJEhueF7vDLsvWVJnvkQIMDDThVRN/6Rod7DYi8UfhaoDxY63P07uF/l0L+vdJKoweHhTS/pl6K3tvhKS1oJ6xb9uwBDfGixW2tvABbm6wigwbQ+oy6vL9etmy3DzhYsaWrsHJGaeb0ZTQ8jPn6a+Pb0TXalcbrogZP+3GIBEGVslYh6Qu/6+k798Rev0D18E7xNM0CwqcaaQINUYmU8UQGQ+IbvRdDU4pd1FLfUHc2ugqvfje5npyND/dTgrC+VxHemUJtRbXy6Mrnz8MAJIJgMpuAly0qzVA1WXlQaTV4ju/Zagfkkze
 FLQ4UJ8s
 wLBxtYIMyH8YRd7I8OycrfpsisH9Vmc+TBkqe18zXTFvabWDdTOypY7sQazxXJAadbXJLX9PjY6iXRoxhb6AUd98sPa+b2/G1qvIawo1H0roVPHAgHtnZvAvBWhjydXwpafreRajYaXeJbAMgZ5H5MORoqRRK2p+/Alxb14iPfNJD+5o+4Ev7Bo1KexCwh4KIegsPpEgubQCrrtbDHywvu4WpycEqmb0VxC0It3RctekRbEemw8eARPKcO1uBmKi03tvtRxwZAY9h0AM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/02/2026 16:19, Mike Rapoport wrote:
> [...]
>> First of all, what should we do regarding patch 1? Should I resubmit as
>> part of V2, even with no changes - or pick it now and I only submit
>> patch 2 as V2, with changes?
>  
> Please resend both patches together. 
>

Hi Mike! OK, thanks.


>> [...]
>> Specifically here, by magic number you mean my choice of 16, right? What
>> do you suggest me to pick? It's the length of the string carrying the
>> size of reserved_mem, some number must be selected for this
>> length...lemme know WDYT.
>  
> sizeof(txtsz) should work :) 
>

Ahh OK heh
I thought you were not happy with 16 as the size (this is an arbitrary
number itself), but it's just on the func argument - cool, will fix it!


>>> [...] 
>> Very good suggestions here, but just let me clarify: so I could continue
>> showing the "reserved_mem_param" inside the "<debugfs>/memblock" folder,
>> just using a different function for that attribute?
> 
> Yes, something like
> 
> static int memblock_reserve_mem_show(struct seq_file *m, void *private)
> {
> 	...
> }
> DEFINE_SHOW_ATTRIBUTE(memblock_reserve_mem);
>  
>> I understood that, based on your (good) suggestion to hide the memblock
>> folder if ARCH_KEEP_MEMBLOCK is not defined and there is no reserved_mem
>> set ... just want to confirm to follow-up the implementation.
> 
> Yes, that's what I meant.
> 

Great, thanks a lot again!
Cheers,


Guilherme

