Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5813AC531FF
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0956B0088; Fri, 20 Feb 2026 05:24:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624766B0089; Fri, 20 Feb 2026 05:24:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC526B008A; Fri, 20 Feb 2026 05:24:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39EE46B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:24:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBE3A1604C5
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:24:44 +0000 (UTC)
X-FDA: 84464451288.12.39A711B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 27F211C0008
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:24:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vENCC3nB;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771583083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVh2E6t9pep775eUDONewZBdgCrsHyOzrBn3KPRat7w=;
	b=6+LfLC9XDVpdKjFnGh8wQJIhZ443RZzdLMnKzDNTyfq7VfAzKX73sFXeGyel2WV4/x1zIu
	b2xWIrCPl67t0zwplEchKLEkDnM4g0YUcnHs/fGvwago7NWP8s4pWJnVVJL/xQ1983rAga
	OP+pPQAePPcGbi4qeFnhsrKvM1oJLNQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vENCC3nB;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771583083; a=rsa-sha256;
	cv=none;
	b=Qr6VujGFDEakkagURUR8EpVkbBoA+7yy5PfYZUSKkMOvtjFjR/oJgFnFlV0MG0vZDKHD6u
	RNIEtLn3OtAo3swKw9IF062qs/ONnXAM9pmKq7vXpHMw2Jz5M4dseFqBKRz8pG4HLlBCoY
	ZpvsfhP1qPngfUDxJ+sNdSYq0GNRU8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 659DC60054;
	Fri, 20 Feb 2026 10:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D6DC116C6;
	Fri, 20 Feb 2026 10:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771583082;
	bh=vf4PV+HFXsaMD32nDkPwT40QxEw4obzOE+eqOI/Igck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vENCC3nBziICLreN9JbBgQwrH4kVgp5ggptDZJ+wz2dwIDcVxtN99gsr11ZOC5lT3
	 gkBpR5nfQe1+Ivof2tnCoOvgfPloDYgG1SavSyjX7x0tZHpLxHOD7sgOz/NZFb7fO4
	 DrWAI7jdS07wlbZxCYB75pMYrkRWaiFjP1hG7gdZk/iX4mkPCcmgjAfTmjtscVi7fk
	 kdF6+ApkM7CgyuoJ+jPCBHxF2BuRI7+lx4sQuxUY8tmYa/nWCup+X2HWYAdsPXs7wQ
	 JzjOucuO1t2Rwnykov1w0sFiiYeyHWgvfWimtPG8Ok2SFJUaTbJEnsv0MpGy2D8w5D
	 ALCGRjz1AXh7A==
Message-ID: <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
Date: Fri, 20 Feb 2026 11:24:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZdCl8byz51Q1-v6@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27F211C0008
X-Stat-Signature: aj57j695hs1rfa3s7e7ipndngtqpudsg
X-Rspam-User: 
X-HE-Tag: 1771583083-584116
X-HE-Meta: U2FsdGVkX1//M6yR/zY60s1xNpMpHy12AMAqXNGYrQW27qVlweZ/W5/W91dkqVbGQPWv0365s2t/bDW/aV6qie6EVL/dlPLTMVF9MNAGKZJF6EsA2bU7dpVFG4tWQudM8qQvjmThvW5Q6c4UdeXOBAtcICRkKpx59nwXWW1qwP9E5U76+ZP5kGWlXzNivRdYb5JWTHVZ1AMHotjHgQp96vEysMQYvs93OfMo013SjAapo+xoVp39F6yuQ739zbEmWO3CT0+Tvttl7vNFTebctkIOJWNHbeiG7U1/LlqOG9LzC+ALhhbQ1/AM2wHiFNBkmuWkvN9aa1BAFzULAm6wuvGwTNUqPUzVT3AK8hcyVs7tNDVtDkLl9Zrzjgd8qBEhKSMh7fToZ+jN9pf229Q6JNF/YTqlehnIPXEGDwFw49dLJUPRd/f95rhBG9gkcB82buomRre6+TT2Xw063eqo1qVzyEF+LQq5cAMVQF3OAtAf4DDRCCQHOxJLYItPcx+jAZaGJ6SOv7ZHWpJUTAuqnXqSdtnPy5+2IfJYset/IWruzCbdyom4zk9CbXva3e9No4G8JCanrG/u47XEJktKI5fNwJj27sJSR4Xb+MQxbJMtHXqEc2h5/93QlmwvG1JtsWu0RxZUN6kg37m1muF262emyAZLX77sfX0pFvNGzwKCF53+dMECyaT5QOPUd/VzdBM3n++ioXs5NsN5xQ4y3xCuDhZAoQVYo+OgyyIg+FCwf2UVYrkj1N4iSfcH/9oNbpJE5FRPVAS//So1K8K2ccSw3EdDh6VsJ+DjpgziJXRlbaEv+HWzlpfURn+zYCNAQY/nNzO4/cO7hgcZ7fE6j8hb3/90Jh5fcAQNQdepSovE2Z/I9/pLdBUABra+n4n4Yi58+OlHxINDsAsaG+JECgxl6fdQmg/VOkN7K9eQij8wxgUCCFX8EA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> When discussing per-process page sizes with Ryan and Dev, I mentioned that
>> having a larger emulated page size could be interesting for other
>> architectures as well.
>>
>> That is, we would emulate a 64K page size on Intel for user space as well,
>> but let the OS work with 4K pages.
> 
> Just to clarify, do you want it to be enforced on userspace ABI.
> Like, all mappings are 64k aligned?

Right, see the proposal from Dev on the list.

 From user-space POV, the pagesize would be 64K for these emulated 
processes. That is, VMAs must be suitable aligned etc.

One key thing I think is that you could run such emulated-64k process 
(that actually support it!) with 4k processes on the same machine, like 
Arm is considering.

You would have no weird "vma crosses base pages" handling, which is just 
rather nasty and makes my head hurt.

> 
>> We'd only allocate+map large folios into user space + pagecache, but still
>> allow for page tables etc. to not waste memory.
> 
> Waste of memory for page table is solvable and pretty straight forward.
> Most of such cases can be solve mechanically by switching to slab.

Well, yes, like Willy says, there are already similar custom solutions 
for s390x and ppc.

Pasha talked recently about the memory waste of 16k kernel stacks and 
how we would want to reduce that to 4k. In your proposal, it would be 
64k, unless you somehow manage to allocate multiple kernel stacks from 
the same 64k page. My head hurts thinking about whether that could work, 
maybe it could (no idea about guard pages in there, though).


Let's take a look at the history of page size usage on Arm (people can 
feel free to correct me):

(1) Most distros were using 64k on Arm.

(2) People realized that 64k was suboptimal many use cases (memory
     waste for stacks, pagecache, etc) and started to switch to 4k. I
     remember that mostly HPC-centric users sticked to 64k, but there was
     also demand from others to be able to stay on 64k.

(3) Arm improved performance on a 4k kernel by adding cont-pte support,
     trying to get closer to 64k native performance.

(4) Achieving 64k native performance is hard, which is why per-process
     page sizes are being explored to get the best out of both worlds
     (use 64k page size only where it really matters for performance).

Arm clearly has the added benefit of actually benefiting from hardware 
support for 64k.

IIUC, what you are proposing feels a bit like traveling back in time 
when it comes to the memory waste problem that Arm users encountered.

Where do you see the big difference to 64k on Arm in your proposal? 
Would you currently also be running 64k Arm in production and the memory 
waste etc is acceptable?

-- 
Cheers,

David

