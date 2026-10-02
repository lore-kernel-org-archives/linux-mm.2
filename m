Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47E6CA5FE5
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 20:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0DA86B0088; Fri,  2 Oct 2026 16:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5C56B008A; Fri,  2 Oct 2026 16:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D47E6B008C; Fri,  2 Oct 2026 16:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 622F86B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:22:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9920C0525
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:22:20 +0000 (UTC)
X-FDA: 85278808440.03.A1F9CC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1BA584000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:22:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrnDNug5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790972539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tmq0KD51zkY3WuDYM8F+lipJday2wPv7c2igNCkh6ss=;
	b=QnTbOBzIUaoZzxwj9T3jVFek8LyWApBtKYBCRWcTf/j3B8A2Z0L96Kv9lOyFqGvts4NpBW
	wyu6hyUmo96MN5TCVdCFlO19b53VQl1kttgIGBTqVTDYQeyPe4flD9fOMqvJMysYqDlqJ2
	EcbwJwvdkTZmobtK9AoA1/itfqfOvuM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrnDNug5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790972539;
	b=c6pkbwBEt0pZ9YorFyXaszxQnWV84Ads6tL9NgVFsozNNyRNCtrBtdmUfhFhPM2TyR5MOU
	Fvk0FUIihc1wtDi1zhpxRj/osl+uSZC8s6G0/XXLGCP4OEoa9vA5dkMJccbDiwNcJFFTIR
	eKpZxApCwqSbXTuvgRMs8l1+Vx7ypu8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E088860AAF;
	Fri,  2 Oct 2026 20:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A151F000FF;
	Fri,  2 Oct 2026 20:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790972537;
	bh=Tmq0KD51zkY3WuDYM8F+lipJday2wPv7c2igNCkh6ss=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lrnDNug5W2wmkcPEA12cNCAar5kTG+xYxqc7DzfnCpC/uU1FsQC5Oj97vOBX81Kd+
	 oSTnfyUkUDM5nqOAs/wLkekxjv0OcKAzL0Di4FXZmS82+1fZ9CE0ixtzqLgJtSuGS4
	 npQshm5RhOuWRURl59tBbkR5w7+R6N5KKND05LcabkkdSmtG4DKmzwdVMC7tM07DTF
	 9hw5tHcn0Q1sM3W/FZ1n6dET70++/wST4z1PEIkTZIiUKAPRXHlwt3wGk/Xm7VMJcz
	 X3hpDDnAL/nWs1K5LsfPw998DgRDepcUIoDa32d3AcN8mm2Zp8pF+DeMUvoCtwUhQy
	 rmKMhfTtXOzQQ==
Message-ID: <7bd2b824-4c91-4378-a817-d5ce475ea84d@kernel.org>
Date: Fri, 2 Oct 2026 22:22:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
To: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
 akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
 nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com,
 yosry@kernel.org, shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
 <aqrHjfHwyEtRIr5S@cmpxchg.org> <aquWKJoP5JLP8Ci7@fedora>
 <20260917131712.GA1344@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917131712.GA1344@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: etx9niwya64sx4ngb1x3k8qn4ib3py8z
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BA584000B
X-HE-Tag: 1790972538-178349
X-HE-Meta: U2FsdGVkX18TDIPo8kLopTQKCdDNz5b8Uy4g2oetiBaPiOxZN7oqcI2R+imLtiOMQC+yHVaU1joraoFgcA/StsxvjTxvM82daHvKhTsK34LAwNUiHUSOLjbZkfcziheifAdRQCP/bEsWOlhXggRYgpuGCGXP5zXHkPhXwU+Yb+ZIlmXP/Tcx4VCg2Ix09QtSuDEDkAljzKJ2MiuS9HSz7x9zT+y30nOC7msMCdjtQHS/yXaNoqacJTSEU2Cu3pN2vcVwadsU//6nr2UIfQQkUFxE7H01iHjhIpoJHo2gQZYggNItjYPcyEhlBTmCgM8c79bq3lhL9H0fisyOdIIJGzsa3uFBemIPmMYgtuOvWAGjXxGyFzWXrSmn5kcNlb8BJN+UkwyUf28L94hp5rWcU4fxE1csVWwnuf7/AU64INbGajkYlrNHycMPBl6piVNFeF2BUWN0TcK3cFWdMtAXvRiAseEE4WeStMZQN5y2zKdCWd3BSLZ6uonxUEan3rwXHqlC/EoGgksxzKuG/LlbIYp5II3pwXiBOuGFR2jVrIwGqoWNgpXbS/vRD5WCm5lWdMgDGdtYy+iHTXDiPtC/b4Gs4gTXJKWE+ZCMJ4Cs9brSVzFNAwnPoNPe1ijDzLlcKa4P3JCmoIv21fKk6qcxMPToXzQuUAwpF8VnRAAEN6laHl5UDUoCdGBn4RHX5IzFa3k/tiS40zYjU5JnynJFWKoNulupSE9Gm0tbXDQ1XZkE3g1ATcEbRQFH5E3z29q+EdfA6oaehxYUEhMd6QLdBmqhriK4sJPrquMVod1EBgHowXyEmiHRwRkNexzviL/b22IdhX83yglAqamfI8Pa0+Lh2eulOjJ29ioYFRaYx+kh61Wf7KzCTiZSzOBxLpdEgi37kcNrCMFGK3QZi6J7mOZkuUPCVgtbJ/iRqK+bKI93W4DRJ6TTkFW7+hyuyVEPmryF0yiw/yCF11aAFdU
 TB6PoJc8
 8cpD8kGQLYdhfP1grplsUIBfGLZi86v9cGZy4A3fpJ/6a5Y/mLeNcD/Wn5CsSUWAx0SYgg4tYox6x/1jxxLhf0YcMmmYOrm8EtaOt2Aqf1peIYYPap03Aa7rXwkviJmGc2pU4ZsNabCuByCTOLinwE2Chyb+pZc1a+xy17gy7+4/J9oTK4a3//yhigyjDeJ2JgG7i2FanpYmx8thABKA6ZzLznVB+qDjZGhrASrKzXP2rxSBfkWiDTmOMplviHLK0RucxbSVnFUmzGL3wUpM+d4tIrI71ncRBiIvccppMCDoZ6MdA6itCf37y+iofmjuPxuM9yWh/v0rYUaXEktwFtIvsFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 15:17, Johannes Weiner wrote:
> On Thu, Sep 17, 2026 at 03:31:23PM +0800, Baoquan He wrote:
>> On 09/16/26 at 12:45pm, Johannes Weiner wrote:
>>>
>>> If the swap maintainers prefer the VM_SPARSE route, I'm happy to defer
>>> to them on that.
>>>
>>> However, from the cgroup and zswap camp, two stipulations that I
>>> reasoned out in the other thread[1]:
>>
>>>
>>> 1. You must not charge compression space as swap space to the cgroup.
>>
>> Hmm, I don't have a stance on this. However, isn't this an issue
>> zswap/zram have been doing? It feels like an independent issue which
>> should be done separately?
> 
> If you have 3 containers using compression space, and two of them have
> writeback enabled to a shared swapfile, the memory.swap.* controls
> need to work to manage fair access to that swapfile. They do not work
> if compression space itself is conflated in.
> 
> Right now zswap entries actually consume physical swapfile space, even
> before writeback. Charging the space is correct. But the whole point
> is to decouple compression space from physical swap space.
> 
> This is not something that can be done later. It would be a dramatic
> user-visible change to how the resource is categorized and managed.
> 
>>> 2. You must make the compression space large enough to be outside the
>>>    range where users can hit space limits before hitting memory limits.
>>
>> We may need a way to define 'large enough' at first.
> 
> I've tried to lay this out in the other thread, and highlighted the
> usability issues that result from hitting compression space limits
> prematurely. It's kind of your call whether you want to seriously
> engage with this or not.
> 
> But ultimately it's your claim that a static size can be made to work,
> so it's on you to make a convincing case.
> 
>>>    That also means not allowing setups where this is possible.
>>
>> And the limit is only an optional knob. If the admin does not set it,
>> the device grows to the full address space, so there is no space limit
>> to hit at all. It already behaves the way you want by default. The knob
>> is only for admins who want a ceiling, they can use it or not. I hope
>> this would not be a problem for your use case.                                                  
> 
> No, I've laid this out already as well.
> 
> This isn't about "my" usecase. It's about designing a coherent
> interface that works well with a large number of usecases, and other
> pieces of kernel infrastructure commonly used in conjunction.

Johannes, I read this as a NAK for now to the current approach from the memcg
side, is that correct?

I've tried to follow the discussion on the other thread, but it just exploded
and some of the things I read there made me rather upset late on a Friday evening.

-- 
Cheers,

David

