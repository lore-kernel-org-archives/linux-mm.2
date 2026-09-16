Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6AEC982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043E96B0092; Wed, 16 Sep 2026 11:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B306B0095; Wed, 16 Sep 2026 11:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74516B0096; Wed, 16 Sep 2026 11:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB0E86B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:42:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36D5C1A077D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:42:51 +0000 (UTC)
X-FDA: 85220043342.15.65244DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7B0341C0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:42:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UY1KQYkD;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789573369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zO2Hg8vHtFBJHvzcTWcCu9FZEuUhDK1HNZHZQCLtALY=;
	b=AM76mjn/G1GBvYtMTovzTeKSHserOeb0GPFod0rMp+aCgYFyA/2oUxW3GAUnv5ul9gslGV
	fkNYnhnBRtxjMeFw/NTHbFchYE7lpYSapbD5SpcI/hdLEZQ3sdUW2knjM98R6R4aAQqV+3
	DHWJLx3HFi0KawZMu7zgggLfaxijrww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789573369;
	b=aX/FTSX8lLxQnLHKbzFNlq9Hipr3aidQOl8MU0dSb9sOLEKrPYl3y6y/Xege4eU7p3HuVU
	opq3+M7J1SDelyIprTKXJmpOrLeCRrMSHYcqlKAGLx4jE4e9HM8S+W4c9/S0k3oD8JhSks
	Zr66jAS8Ol1kLy7IzPgi4Dbe77JAJuo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UY1KQYkD;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00E7B6053A;
	Wed, 16 Sep 2026 15:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA8B1F00898;
	Wed, 16 Sep 2026 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789573368;
	bh=zO2Hg8vHtFBJHvzcTWcCu9FZEuUhDK1HNZHZQCLtALY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UY1KQYkDB/rUGHIqU2oWGPMJKQ9TXTiGD7Lx+Tq+LUJ4yhkWR3hYs4NL6SAfmFRGO
	 ZvxiO+QKdWEBBSR4JdyyhdYF/hqXJrjGvFFyoe2HIK97shpK95vz7ai4tmmRcJS46K
	 ZsdHSweMLOIAFgtUEsxlF+vhWxbGaaNTmmZ3gIxgyZ6dc9K+9l3dei5ak1mhIRFaKB
	 vWV0IeCHmBx6MedCbXLFgLqSAhYQHs+fHE1EB9CpqRjcLUME6e21X3dCK7yq/KnC9w
	 OZRflM3T3M3dMtpVa1cM5X/GKlXdjWdvpUnOVzVcKEHSeTdihmkTK4n6V9Ua17sD2n
	 TfQSQ+X6mN68w==
Message-ID: <9b50a047-b5e6-45c3-aee6-551896b52eaa@kernel.org>
Date: Wed, 16 Sep 2026 17:42:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
To: Gregory Price <gourry@gourry.net>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 jannh@google.com, wangjiexun@tinylab.org,
 sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin> <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
 <aqqjW5dpyznijYLh@gremlin> <aqqk89oTigJ9LS2N@gourry-fedora-PF4VCD3F>
 <5437871c-d9ee-49d2-b24f-965c73c29c3e@kernel.org>
 <aqquDtEZL1ndymGN@gourry-fedora-PF4VCD3F>
 <46d923e6-5724-4df6-b0d5-8dda7c547f6e@kernel.org>
 <aqqyhkZqcXDUrzeb@gourry-fedora-PF4VCD3F>
 <4fadcda7-d96a-4cd9-9b0f-5d387b6f82af@kernel.org>
 <aqq23i9824-GWdhg@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqq23i9824-GWdhg@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pdo7d9aw7yiht7fefh1dfud37cryswd3
X-Rspamd-Queue-Id: 7B0341C0004
X-HE-Tag: 1789573369-577941
X-HE-Meta: U2FsdGVkX18NcKWM6/Pa76QomrwkEq+US4tEQUcOgxsUCuTktaCC3J1vbJrq2yarOg3kb3f/4gp/4nN1mOPPgrCtdKEw1PvANXhkq94EjEYu+mtdmqJjperyRc4N2OQsiYiXHeb1Z5y/HVGtS4b+ZAVU3noEnMPin989MIGnzLNbMroZtv+vpwoO0URbiKvnASfEKV912f6Yy4cO6L/+X6i+On34gYsnO3nNcjz+BmhTiDu5fDl5ava4hrnl0BehADOdR6N4tmWQIUA60hsH7mYcSyUhR3V0IESyTbgHR/sFYKEhG8n4/SeevukfxlvaYRK5REjQhltuUChwkZvdPhqdeyyrc9aqDoR8ciu+YnyDWB/+ItkNaO09QQFFCwXpPNq208Wqn1fT+yxu5BnME/exdSLAQJyMJDpqbRECAvCQF0dnTwCreAiPGYFKZSyeEkTC6xHNEBH3WMAcMj433n8XRdA0t2S4J7SJY2YHpMfDOTXkumi8sI1AoJKs927IjCV6b0EwUZmdHU+MzFnLR1SGLHlKcnUeXRs9894KCSaSSusradInC6f6M0Agsgzuy+U2ZJw95S+MH6Zl/R5WF4TdpFSu+YFP63WVm9Slt5vE4NiC3tcU3hosl25r8s7zRh4tHdMHfCBDqZJyDIZ678+2fR2yH0lH3/b3tVTGrXC4NbWrhghDX7buV08C71Ig5Dd6/kPepv4sGHuADTgneBjfvcCkJuSJiBb0dUAxY4Jq+kLLXanfhY3hf/XbKOXYY6S40eRtsEs4weqpYBgmNeENLukwMp4LIDVLoS33A1Xmo2r8xdqNb4YX34HvvA3STxLi5Phj04eOKne5eiIPoQuDesCa3DMdmnAIX8zjGFdpZLkVWaH3HI7U4i/wqZ7HinoCLuOkfAQAOoH/6TYezinWXzrTAJOTPQayYj8Z6iGd1mlCCGJbafdRbaGOQaMy9g4OSlIjELeERuDy3CJ
 QMLZTboA
 qTrsmWLPX06AKjXmRN2Hw5MFJQalSP5zwnrehIu7jPHS0A3/9+s49Fv542A+rYnUTUyBGKUvVU3vL9KLugyq1+OFkKg2xFgMinggZWR9I2tmXRSz2W7X9elTmslTB59ZakkvUY0DlRD12twsV9v3lvBh1Dy+2SBrXqwQ7lExAXBaBWcWXUkIh52ZEUH69MaOs4YbNYzvx173XoJmJdJIIhbExQHrfSKcxTP/uD0aYOp10+CvHsJpIQtEwYWj5lBF5PXr/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 17:37, Gregory Price wrote:
> On Wed, Sep 16, 2026 at 05:24:43PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/16/26 17:19, Gregory Price wrote:
>>>
>>> You missed this part:
>>>
>>> "I'm trying to be careful about not causing a bigger maintenance burden"
>>>
>>> I wouldn't do that to you :]
>>
>> I just wanted to make it very clear that I don't need another schlopped gigantic
>> patch series in my inbox that I'll mostly have to ignore because it's
>> un-reviewable ;)
>>
> 
> I would never :]
> 
> But *motions generally at madvise* if this isn't schlop i don't know
> what is lol.

Just to be clear, I enjoy any cleanups in that area which are well written (and
your track record shows that you do exceptional work ;) ).

I would also enjoy a properly stubbed page allocator as well as I envisioned ...
as long as it's not something schlopped together and rushed out.

... of course you would never work-slop me/us like that! :)

-- 
Cheers,

David

