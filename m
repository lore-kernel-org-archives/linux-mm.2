Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED583C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198FD6B008A; Wed,  5 Aug 2026 02:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148D56B0092; Wed,  5 Aug 2026 02:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038466B0093; Wed,  5 Aug 2026 02:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1BF86B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:04:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53EFCC0372
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:04:12 +0000 (UTC)
X-FDA: 85066175544.05.D67409E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F22F40008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:04:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvoOOyBk;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785909850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1V6xsKbzv4Oc8g71CDUBCGBJx1R/W2/HokkoKbrrkd4=;
	b=wDb9VjvI5H6hRMw9NXB1i1GqVv0tB7xGLUD1lWDtc/lDLNVI4Tg9lYWl425r1itpTMDGlA
	rKvDy0AlnKTVjugWG9JBctVBLIHliji5F/UFJgV4otdynGaaD5vip3jZ/n39E6Ah5YGqwm
	JbZaMn1J9GK0CoSpm00CCxUtJBoR/hw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785909850;
	b=SrLwo3NEjIRKlb2zzm5MKQxEO6vvu4WlSzHtBExiH7s6WoVvzi9ev/6So9UsAJ0b/gpPDh
	IOXas1WYBgvpF5E0+0Z9/3ZKQhQKEFhgwmWxHBwwACMUDh06degVeuuKiGZ8MoOJTPtyWg
	bXBLnK6hMs+UHw+h1O1IlBIzDpDORPc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvoOOyBk;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45B05600B1;
	Wed,  5 Aug 2026 06:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D481F000E9;
	Wed,  5 Aug 2026 06:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785909849;
	bh=1V6xsKbzv4Oc8g71CDUBCGBJx1R/W2/HokkoKbrrkd4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PvoOOyBk2rt8FR13TEdaLNbyQP1d2nEQVNOU4bNv4bcviSP0ehpl+/SnJuSGQZuRy
	 UPSudhakGWGdCcplBvaKYUR6um2zE8cQGbt5SkLdDB+ovpLzgt9iYgfjy45qTSW7XF
	 Q0c+94YoSmxJeEY0DdNIbvzDygYexdAhpWlvHQveFKOCkacZSQkuTwzOH6fz5DCnMa
	 rIAojzMjaH1XC4DUpp1d/DdahzNQYrqi9NoskmZo3FWAxgnMA80v9+ioHTZbGzVpGz
	 07pB/SGPHhmok+JGRWiMemvLc9upsYLhBm9ps3QSLA4syZOaLw1zpcB1tjzwPNvPF+
	 v1pXBDINTDyXg==
Message-ID: <5130d601-84b4-49c5-a9f7-454d54a7412e@kernel.org>
Date: Wed, 5 Aug 2026 08:04:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix incorrect flush address in direct page table reclaim
To: Linus Torvalds <torvalds@linux-foundation.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: luto@kernel.org, linux-mm@kvack.org, luto@amacapital.net,
 Qi Zheng <zhengqi.arch@bytedance.com>, Liam Howlett
 <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
References: <20260804003708.49830-1-luto@kernel.org>
 <0adaae9e-7086-4213-811e-ba6e4181e145@kernel.org>
 <CAHk-=wiO8NDCyBYrDMpjh8zMKnzgD2XuPYo0nk4Hwgq44R_jKg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <CAHk-=wiO8NDCyBYrDMpjh8zMKnzgD2XuPYo0nk4Hwgq44R_jKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F22F40008
X-Rspam-User: 
X-Stat-Signature: kuhm9t7nqe7hx7jm8m467w9ftqrq813h
X-HE-Tag: 1785909850-383217
X-HE-Meta: U2FsdGVkX1+AewLLKjCYAy/ycSKxExrtnCz2TCHOj8PbKlJht1BKt3tYzNvG0bw+wRB0mQSMsUh/yu1rOvKOluSSFNUr7StsAcLB4ON0rTZ4Kryik2W6svIOpxmosWGcwtjwVYjcCPCcCkSA0T/P5OGLo17WKoJSeHIuFbgLtfcgRiGKPyPJITtY/XsCQRnsazxM8KopML6RWKTacal7YJkpa5IrdIyoj1YrYpIFfBWgdwNOOWt5zqZrh33CayFz79k5RUIutqpbq8M3F+qWvWbwHsxya0UDx7F6Dty/87EBITBKtYmd6DBsN+scy8vgzDA5TFAxMONpsCOqFSYFGMhaeEm6Bc6d+l40klNa2nSXXLb7X6CLlCe/QwORXrhli2aqC6u8o7PO+F+gUy3c3KiB7Opp7+22tmDI8iSCDwW3S+t1eRo0P0RW+ExQUYEI3Oe4D5Iv7KCyCAlMKtehur5uMIcmYAnGU38chgsdoDh7B7UUlnpu/NpkY4Fyuo/tOc2NunlCSiuAuRvZtUV7NJ1LgFNoab5gI7yInVHdxg6S71Aeuq9Orl7UvKwLPnOU974c2HlnyrAhuOQ53SOySFAHejn37QiPQ92pQ7/AgYII9650vo800iWjvhZ1X78AxITbRAaK+L5xFOUhr9w3ZlgRgs6/fAipoFdhqF6woGdSJkjLbMFpBrdp11qjspLwiEVMU1gKDFvzDl7bGnxFpxOtZ8O/QBF/zIPTY8VzUEorOjzU/4q5IwYlSCsPsjQP/LUcH0Drf2NpuFVvwaB4Q9yAuvKAO3C/QJT3Z1ZrJ+SI6sM03uijc7d1f5crPIAAMHrWuvFYLr3D0wlHmVTjfKeCl4HoXBQiblifloxvETGc4MkyjUZtaQEeCdYYE6lOaKJfoWXNc6fHsvPnX+8Ly04ZjKMkx+KYlQJLkrt3rS38t2Ub0+sdUf21A4C/HhKc4QyiCFaVMd2+kFccHVB
 nB7q0Orj
 3iTOcMxgxgU0nQhwDM9G1AvB80geDOEz81jF1THxnY2o3aocF8jEm3PUPr2ROBUQ9qoj7VYcH0ryazUPnwfITPg9ZBs4/Ruug/SwjEcmjfjZge15pu24wY8BII0dlnCRRM46sGJK6ukMDOz3KOIgFigU7FjPam2TD1n36LKgepOF708gB5JZQlXxVqF0ske/lNyCvx/IYLk+4zjyzlVnsC3erwTycT6qkZRL+ajNYjY41fAo4bWK8yImIv2+f37A9CCPdGUzv4ppU7HxPj3KDZrOmlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 17:54, Linus Torvalds wrote:
> On Tue, 4 Aug 2026 at 02:49, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>>
>> +Cc Linus for nerd sniping purposes
> 
> I don't know what to say - the patch looks obviously correct to me,
> and I certainly can't disagree with the verbiage in the commit message
> either.
Can we get that fix into 7.2?

-- 
Cheers,

David

