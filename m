Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3991FFED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F3A6B008A; Fri, 24 Apr 2026 10:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF886B0099; Fri, 24 Apr 2026 10:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFA66B00B1; Fri, 24 Apr 2026 10:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 28B3B6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:21:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB8C288BB2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:21:10 +0000 (UTC)
X-FDA: 84693661500.27.D83BA32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BC69FA0011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:21:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FcO/T2OJ";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777040469; a=rsa-sha256;
	cv=none;
	b=I/NrK1gDjk3EALloYzsDDl77HY2uaRjBgy6IFPw9rzYDaaPRvFFio7YFGA6OAft4eX2gY+
	HonAPn6laCNH0InyAxb0NPRvs5vMACBA0gtfm38tgFXQ5NIxp5hh7Z0TF/95fwx0NbEW9k
	1Q99tObno4vYNRGCFYBtY/h9YXCOAQ8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FcO/T2OJ";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777040469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEeqeRRTjIDPdDNLl+n6lSmcGB/IDccW8PQ3eLuhsnM=;
	b=TQ/GdvwVt2bFYiF28yZGf4or1OHODDkK9UBV1QqqGJHPoxZdZMitKi+U9FSjKAyN4rKHq2
	QhURhROnpYdsd5GZW4xNomQWWUdkIrg+WJBImnoiU9G10Tl0tbudXbe6vJOdSSuE+tSwDK
	45oyXwA1XIhDagreqGFqOmahJa8EcpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3EEC40607;
	Fri, 24 Apr 2026 14:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037BDC19425;
	Fri, 24 Apr 2026 14:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777040467;
	bh=m1TLXBSapE9k/3U2BTj9Ixbf1K+29lmFaAWUNRfDm/Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FcO/T2OJBiXLuu2jOYNIQQjpOEf6UNNJeCnFHM1G3rkXVxZipjDU2f9hG18XgZSR6
	 nuvrFYyosEs07P/Rq5p1uyZxffKIx7Jx6DUl30rlgxqSa7ONJA+rAiYOXUUEt1y+fx
	 T1D3wFcSPJccj056BZMc6nNLnm34u729tzvGgbXISBpwg57i2VwUrlim4w8/A93egS
	 okGfpoNM6aK58HOLnHfYBdAX/JlfE9ZcjBMEny1KF2gZEZlJabPXMoASKc1XnvLObQ
	 n0SUzJQPoDVypAvwajJaRAG2RPTR3Rnm/yjlVFWpBs32jM6WZzTmGBDVNGhBYotvo3
	 6II/JCaXvWD7w==
Message-ID: <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
Date: Fri, 24 Apr 2026 16:20:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
To: Andrew Morton <akpm@linux-foundation.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Lance Yang <lance.yang@linux.dev>, peterz@infradead.org,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, ypodemsk@redhat.com,
 hughd@google.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, arnd@arndb.de, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 jgross@suse.com, seanjc@google.com, pbonzini@redhat.com,
 boris.ostrovsky@oracle.com, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BC69FA0011
X-Stat-Signature: yfgw6cihncibpew7h373zcei58icqbje
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777040468-837621
X-HE-Meta: U2FsdGVkX1870o3Qo+Zr+iRp/IOo7l1TON3/O7MMw0JtGjQ9wujcOfqh0fmyOGlJbQcY/dq9cLP4soIv8XNa4ULdv85Nnr38DyxOVMc1oXyPRcEW5OCpZQPhpN8J8Km6qsqxXoNnrJjZYtVk4QD+pDzKBcfOQYDvBjWageVeehSJwaAuTAMsV7Z/30KAiBSBsvQM8GxbWa3UEIM3qOV2vHls1+lmxSu4cwUGcQvSu0TOGAAkc90V85ZXVMV0GVH5M053FiBkMNYgDwizEERJkPJP4qDAg7dvom60rhuyAkMIRqAEqrusAr10LtJ2XTfp2H/imDxPLlcNAfYm/kNDZWyq5vGYJbOAfZI6VM9qdA25rE5S8ruTriZMIloSJ/CoEww1ebdJK2bszFd5Q1jHX7pfotLWvqL5wOv+NA/B3iMcvqwHdB+DV1LCsBtdJAKQ6+X13G+6PSd95AE+kP9Jv3s8MDa1G/FEMX76apfaHgWpvZ1rb73fma8TGhr6jSlTr8Nl1vcpMjDkR/mUmXuJZW+j2uwKZ+VeVvOMg5UnPlSYn6OsLZ8N7EvrQ7Svkhful5hj56iRgQjsD5OPv8KWqeU8wpnXgcAq6I3oUFqC/zUJePPkwdrvfCpLjJVVgb/bDVxzfzn2PJ2pzmapkY55ZxaGSnc20oAFZvU9lWfrjK2nybkQIJ4RxxwuVSKOrgTTJ+dwsrYKznOZz8FTInVLQzQA3Sr3UKESGjBvKh4Sl/7bSuSIrw/xMIggPyc/5nMoonGTM2inGYXJeFdxonAz3izwsBa7ayAphxZGQJHVZrIviMG1sJllsQ4s8EoUXzKYPu258ZXj7Tk2pG7j9T+8E2Idh3RC7OVLNj5Ft2/6KP4ynRliPrbGcmccoKgDxIt39XKd1wl/3B60HwFHoYukU97+77mL4q7tNecUiurmuEPSjcP6kKFjSA1HA9MPgQlnxAvMad4SiUyTEcJaEgz
 v2JYse1n
 7ZbS5I1xPuZ5wu+0U1kZF+GgDxiG8spKbFhh7mCp1FxzbN5aLNeO4IAsR8CDcWzFPeRRMEHa1RpcikJxJJYJ38ZBhZoxH/sEmpQIiIbYiGUl/HzwfQ3iLModDM9GYFK5HBQZSL5ceVFSU9SKvKLuBqE5Gkd3sKqVvB0UKLwLeJ7oIx/WPw9InIooMOlkMc9xBPaDZ91yn6a1hQ/TXDEoR2Q4kTI3ZaeNqoRqd0hlh83sFd/9OOr02NiSzjpsTm9Y142rFtEQgg44lxnAPAsn+zYg0GQcKqV3Ciaro2lZ3DpPnZiMkczC1q6WW07UIkdZmlmTlH3bJ+UsEIPzHkWlJ5qlFHLfpERD3w27y3pSgYWFKosh1nOx2CaONW1vzWYVbIzQm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 16:15, Andrew Morton wrote:
> On Fri, 24 Apr 2026 13:37:04 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> 
>> On 04-24 06:30, Andrew Morton wrote:
>>>
>>>
>>> Sashiko questions:
>>> 	https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev
>>>
>>> (I never know if my Sashiko emails are welcome/useful.  Maybe Sashiko
>>> said the same stuff about v9 and it's all wrong.  But better safe than
>>> sorry!)
>>
>> These emails are helpful; but, I do not believe you should have to 
>> manually follow up with a link to every new patch series.
>>
>> Perhaps  Sashiko could automatically send a summary email in response to 
>> the cover letter, or provide a link once the reviews are complete. For 
>> the kexec ML, we opted-in with Roman to receive automated emails from 
>> sashiko.
> 
> Yep.  I'd be OK with an automatic reply-to-all.  Maybe some won't like
> that.
> 
> An alternative I've discussed with Roman is an automated
> reply-to-author with a cc to a dedicated list (we could use mm-commits
> for now).
> 
> Preferences?

Reply-to-author would likely be better as a first step.

-- 
Cheers,

David

