Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F0EC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1096B6B008A; Fri, 24 Jul 2026 11:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB2A6B008C; Fri, 24 Jul 2026 11:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3C36B0092; Fri, 24 Jul 2026 11:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7E766B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:01:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 213901403A0
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:01:03 +0000 (UTC)
X-FDA: 85023982806.24.6C13206
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 58A05180008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:01:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e8W6X5M2;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784905261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuWKgYJKiGV4VnZawJ+31C9x8fGlUZAxGdZ/7YC2SfQ=;
	b=7QcbR/ngkr4YeDEV6amxHvzoKTSTbGyR/8vMbC/W1fv7VBah0HLpuJQF7ORCuG7SZHzSwv
	XC9iadw74fK7CSu29V8zwATxHTHpqI3eXbmxx2kYGQmbqRgJlGVXkAThQ9KzpDE8lwE2uX
	QUMtR35+WTUvhV+qG6EWMCfYMNkMK0I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e8W6X5M2;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784905261;
	b=MBokgBc6bWiMn6SN54wu8FI6kSl1pFq6B7Jb6bolHIolrXUwF2raF5NebKS1SO8o/vsuNJ
	QCJJ9GVLC/WI8wi683fmHroh59WbHhYQj90voOcNFgFalcesxeankW12OuHIXvicEQGbJJ
	CE6U+nUvzXkUQcBRDBL+Wn8Kd6vftt0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65F33600B0;
	Fri, 24 Jul 2026 15:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874C11F000E9;
	Fri, 24 Jul 2026 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784905260;
	bh=kuWKgYJKiGV4VnZawJ+31C9x8fGlUZAxGdZ/7YC2SfQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e8W6X5M2pWsGtZi5XaJpnWsvWT++ncbBXhDqFjs8KD0up2kycu/GMZbclBqiYBpSt
	 wGzBMfmT23dSVR2aOyK3651NPXs6EiED71CrPgklCvktIgQIhU01/x2l2RJV32mRUb
	 I61yvMTDXNEj8/Qnqjv/d5VsR3GZRx5THPnfMJJJST27AmgHSZXc+e0Y0wb7c+q2i1
	 0QmyTiTnRi3iUuGrsUSWf21jiNgRfMYLqSo8x/i9HorgD9ELZuNaXx51c0diW3/Yv5
	 znuxqK3yOKhTHRPlenaKzAkp2IxQCW6Xev/WewcVy0CG5AMyMXyRrCxf3PLIVE2EO7
	 ms5vOavVoI+lQ==
Message-ID: <7b403326-b716-4766-9488-3bf662b74a64@kernel.org>
Date: Fri, 24 Jul 2026 17:00:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mlock: skip __mm_populate() for MLOCK_ONFAULT
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Wandun Chen <chenwandun1@gmail.com>
Cc: liam@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, jannh@google.com, pfalcato@suse.de
References: <20260722125133.543441-1-chenwandun1@gmail.com>
 <amC9AO3YoSnKewkp@lucifer>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amC9AO3YoSnKewkp@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 58A05180008
X-Stat-Signature: uoueap4eua8gfgaksxjnuoyutfh95ooy
X-HE-Tag: 1784905261-526075
X-HE-Meta: U2FsdGVkX19RB/l/eaZVK1LfLflE0NITvfk0a5s0UjjnwIoM+EQ9VnYq8r6PP1VUkFRKZpb93mJbA9gaY5qRcTYzkAeB4mqKfMHyyqg314zoXwHuJN9kUzDwpY+6iS1K7jQWPsngbr3EZg5W7Q3SR5wPMIGjQ1duj+Xi3MwTmOOldpu4aGCmv7B7GcIpL5h6PRoMNjMW55BIy7u8VFAw79lxxdxwsSGz+iShctbmOJ26eubCnqeuDuyNZt2/myNFqk8fJEh0FA6ekqPWRReadjLT2c/7lgIDGCjB2f81l5x3697qEEW+9JPMOJPN5p3axBQyQrmv1ccCqqLrHzWMijLK6t0j05IBoyd1nyQNmXIZWSDUCz00DFds30aC6U3qXkndbmmJI158J8RypydqD1GcWMOVlCpVnT4J6URFxLUBlnflqAGqTslaIK/HGqzXzm5yre0NbwmLbQSXIfHAPqRpldd342af53jYtl3RM93BNmGZj3zj/31av+reGKc4PS7i1pSO1FCLPCuTvgF6Zeir8wixlG6socJhYKhOBY0KKuYMgez5zcouUXsSz71+LyW86FMz5L/ln3Za/1ErbpBRjfIC1WbHzN+MNeUWF/ItOK3BbSnryRUSZD49XKazLAMGL6BHvJjXCM2ZauMMb3aSxGQ1AXxD/q7Z90PA4/xeyY0hQ5eqL1kT141KPdhmNavAZ9tZdRw175GyJHX3T7S5d8O30GZXBao6Vek9l3RelX/UUkxF3CflkvhVc0F1pKgvT9A2/lGPCSa9KWG2ut1nSx184MYmGO22ygKuYtJZfRbJKBvuSPCE6uN0QDpLzLaGTWCrbLwYnhjssCzisNVJohe+AYLFB/bq2rdHixL+/YIPpfVBA44G4irg/TSE5RailPdom1SenVm+k0CcBj4Dr3dQidELooE4NWxLtXuqPudIYOQxX6Pw4pBsulOHKBSowWGNmBaXkwS36a2
 izr58r6W
 QYpSZv4oDiODiZt/slMeAJ/xj0/4q1qQ5hd6xeeYiRJ7jCMyWtMPHJ4EEv8w1NL3UgoWLctdEMc5d5BOY+p1e1OmVZq0dlNuAB3YDaFcuewS5IpQp4paDc7KXf4l4b8EQlfWYPKnoMuIkjUCxLvTGsJV/gurgTakCZzTbYCFa+XhHsd3+CymiSJhzeA71/N/Jg6Yr1I9KWmczu9owb8uelK5VCgmAuimMB6+up2Xdp01n3j51M/n6qkspIJI2pBjjNZ1R5ebWiK8tF5wdbidbZH3bEtpK1rMKbN/khMmnIQfpRVpmFjkBVBh8Pxe8KzX4CO33Bss0uPCzukdI9dbSrnrbWSqVCUNMQ/KdrijcrED0O5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 14:59, Lorenzo Stoakes (ARM) wrote:
> On Wed, Jul 22, 2026 at 08:51:33PM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> MLOCK_ONFAULT only locks pages on future faults, so there is no need to
>> fault in non-present pages during the mlock2/mlockall syscall.
>> populate_vma_page_range() already returns immediately for VMAs with
>> VM_LOCKONFAULT, which means __mm_populate() just loops over VMAs and
>> holds mmap_read_lock without doing useful work.
>>
>> Skip __mm_populate() when MLOCK_ONFAULT is set to avoid this unnecessary
>> work.
>>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> 
> Well you take mmap read lock and release it (after having held the write lock),
> hardly earth-shattering.
> 
> And this has been this way for donkey's years I don't really see why we should
> care?
> 
> Do you have a workload that's heavily dependent on mlock2(..., MLOCK_ONFAULT) or
> mlockall(..., MCL_ONFAULT) as a hot path that is seriously contending the mmap
> lock?
> 
> I don't love how the VMA_LOCKONFAULT_BIT flag works but I'm not sure adding more
> churn and code for the sake of it here is really worth it.
> 
> Thanks, Lorenzo

While that's true, I don't see a problem taking the patch. Otherwise we'll
have to keep rejecting all future attempts (including LLM) doing the same
because it just seems like a low hanging fruit to stop doing an unnecessary
thing.

And it's not that much of a churn or new code, IMHO.

>> ---
>>  mm/mlock.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/mlock.c b/mm/mlock.c
>> index efa6716e4dfb..784bd4bfc3bb 100644
>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -658,9 +658,11 @@ static __must_check int do_mlock(unsigned long start, size_t len,
>>  	if (error)
>>  		return error;
>>
>> -	error = __mm_populate(start, len, 0);
>> -	if (error)
>> -		return __mlock_posix_error_return(error);
>> +	if (!vma_flags_test(flags, VMA_LOCKONFAULT_BIT)) {
>> +		error = __mm_populate(start, len, 0);
>> +		if (error)
>> +			return __mlock_posix_error_return(error);
>> +	}
>>  	return 0;
>>  }
>>
>> @@ -778,7 +780,7 @@ SYSCALL_DEFINE1(mlockall, int, flags)
>>  	    capable(CAP_IPC_LOCK))
>>  		ret = apply_mlockall_flags(flags);
>>  	mmap_write_unlock(current->mm);
>> -	if (!ret && (flags & MCL_CURRENT))
>> +	if (!ret && (flags & MCL_CURRENT) && !(flags & MCL_ONFAULT))
>>  		mm_populate(0, TASK_SIZE);
>>
>>  	return ret;
>> --
>> 2.43.0
>>


