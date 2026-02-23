Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCAEEA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E806B0088; Mon, 23 Feb 2026 06:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8056B0089; Mon, 23 Feb 2026 06:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7286B008A; Mon, 23 Feb 2026 06:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 878496B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:27:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D79D8C2E48
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:27:43 +0000 (UTC)
X-FDA: 84475496406.04.E35658A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 024648000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:27:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WxomJKx5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771846062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjdW17GJScJnMJuXkzBJzMqfXGV5x8IXtFVhpJFR8pc=;
	b=YAD+y6KYT12yntBmSzl0X+5VxXwp1lYG+GDdVvcDaqbW+wpcPH7vfORhXzGMDITf4WEYVC
	ZbYqLjrd0KWl4jfOzzE+AW2NZjhtjBTnPqVnjKZW8YSbAiwnV778HiMQdZvuTklih0JunB
	9X6O87pwNiMtjhNE9Od319W/+jy8kG8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771846062; a=rsa-sha256;
	cv=none;
	b=dXZHL7hiBu+l+U7RlrJOh7qtRu3c2TsuLB19zxFs85wipbxBsLa91IK8Qiw7j3qnPf2AfC
	SRtD4uFN/nCILUJz4CZdzSwkfMLXf/tNErB0mhpEZ1OFd/miE14+K6swG21wzQFaxoV0VJ
	UB/R3VqkGqnVSTgr8+u4iyORF+831NQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WxomJKx5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E29AA444B1;
	Mon, 23 Feb 2026 11:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EF1C116C6;
	Mon, 23 Feb 2026 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771846060;
	bh=IgbWkQ4+Vmc2cDQbjDQKwhY3CckSl6nKs7C1cc1tLS4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WxomJKx5GCBhAw6iv03KC7KELLRBQjZZ4iTcKmVM7F0U0FBjpdevI4tb30MZEcRwh
	 OEe4feh//Jb6Z0HyNAulHjENW6/E7B98CStPLQi5HJbO51xGJrntHK512lDFeGlVTj
	 hW4ebQQ/RKN6sdh5/Q1blFYy/keK5GPVhDHpFgrR8Vcq7VomhUeQVVpdVRKZ9PWF52
	 7s+3RqbmSb1XwgnNDEWXwB6207/RwtDO7HKRzMCMG9c8nBIks8OhxlUDRKrTXtraJm
	 AicG6oOFhmD8TiW/M35/bTQgqcU6D2UC1nlGmqtcbzYqp5Tp4SpHX1g6sOqulRJi4h
	 GYlm/KyAa9MYg==
Message-ID: <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
Date: Mon, 23 Feb 2026 12:27:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
 <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
 <aZw1DlKHaWvgOtm_@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZw1DlKHaWvgOtm_@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 024648000D
X-Stat-Signature: awxht3rbcbigm85e4u4aoj5u3s3baq83
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771846061-704558
X-HE-Meta: U2FsdGVkX197iZX//eQsUeed4sIuwzWNc7tbXBpiCsooM0hRCscaK3xkDY9tfspC6up6EiyBSRS+Ei9C+8biIQh43Zk+6HPjxn2eIx1jnGIkmR1HHO0+S/man1RlFQMziJFsdgDAf4ocHcGsYYHSnT7HNev7g3ArT2FVHdJ9QiomcSdFFSK8oK8mgIUsh/nmcyIs545vpWr1F6pZrB9Z8ziTTVbfozE3raC6hGkQ2b3vUefoRELZl8sJuPbiN99FvWWODqdfmrl8mBVCm4UPYWZ67VWw+yWRad3GpCeoYG7PtzyRdFyfpcCm2AVzn4yJjKysTkmHd7PtKWTvkXTbVcs4cAnDN+gapTH6eskOlfpbvVXMC4Bfk7JYn7u3p7c2PUXO3nRYFe8gDe06PZtBWMZWbfGYJKTi1OoCvfMARuTHm6C1bhqePlFbCCoyYkEFb7S7ccKB+6AR0Li7yfLe3If0KjjF2TeXb0FYIt42RrlyVHPvcITtV7kj8MqqaGvQXZfY1rPEcnKSP55dosjKGPV/tnfId60g3wb67pMvBDt/QFN+hCHkn+/W53xkYJswawPAFduC8hNo0EODZt9w3AK4Ihp9yOfg1Msrw+wc/vJEvr7TlhDpH0ydp/v6aHFHZnX1+rHPQSilGDhP7A8FQR6bg+rj2hS89bvIVjv5De8F3KEr66S4h7cAvOrLQtgYy631xQJTYR38XNihl/p5rB98778Y9XCj7kuUR+HA6MX8ZtlTNwguiFUBYzQiH2R0fp6fqFHCqxRjt1YedbN8f1/mGBFhnmhjJhwoiAxIhqh6DapsUt1FcF/roF0xeu14sEO3t3Tgs62nUg9bdF7pQ/ByzmPLyc3bfFZ1B8ZV9kOYUtFtfNDj3urV0B/q3DwxYu2utR87r6IIezzXXccqBTOGoUdUeUnQvx0aa1DNzu6sfSPMdGfszuUfi9KLW5G3qnxb7YEIQiho1RKXwKP
 kADk6Y7K
 DPBJCE0a12Qf2ay+toMe7MmKH4NeqbJDTtPqxDvVP17CAH3BcYUFXHgCmFa65ju/beJ7HBK82x/lCA3oAkdSUurBXwqm5z4yiCLim8qI60Hihlww9RZ1UbEM/5i18Q8geJLkwptF1mYpvkBcC77sh87KlHbV6lnGXR8p4yFsZj5xaGZUDIiSUllUvX4rfOkuEJ3VQfwlYPdK7lVZZx2+s5AgE3+kG6aEWC2Y1cS6oUeGTqwq20lFP0BGKvpkMH2AJY4ORzHMq/Q1FKUI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 12:13, Kiryl Shutsemau wrote:
> On Mon, Feb 23, 2026 at 12:04:10PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/20/26 20:33, Kalesh Singh wrote:
>>> On Fri, Feb 20, 2026 at 8:30 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> I think most issues will stem from linkers setting the default ELF
>>> segment alignment (max-page-size) for x86 to 4096. So those ELFs will
>>> not load correctly or at all on the larger emulated granularity.
>>
>> Right, I assume that they will have to be thought about that, and possibly,
>> some binaries/libraries recompiled.
> 
> I think backward compatibility is important and I believe we can get
> there without ABI break. And optimize from there.
> 
> BTW, x86-64 SysV ABI allows for 64k page size:
> 
> 	Systems are permitted to use any power-of-two page size between
> 	4KB and 64KB, inclusive.
> 
> But it doesn't work in practice.

Even in well controlled environments you would run in a hyperscaler?

-- 
Cheers,

David

