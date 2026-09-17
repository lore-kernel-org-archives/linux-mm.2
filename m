Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459B8C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487386B0095; Thu, 17 Sep 2026 05:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460296B0096; Thu, 17 Sep 2026 05:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350856B0098; Thu, 17 Sep 2026 05:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09D376B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:45:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A407A802C5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:45:27 +0000 (UTC)
X-FDA: 85222771494.13.E5EB24B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E31704000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:45:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsOiXOhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789638325;
	b=aet9WefWNyqizeuLB/38YoX93k3z/1S+bQhqXfFapN01JfNj2tq23xjuOdtQ8/eyG9nYz6
	90KLJ6+Bkcm010cHtyozg8isGJPB+TJzxim+wMozlT2hRRWB/SorVWL1JRwzGzLG5Z6IXl
	+zbjcQc68OgCAursaefKs4D6WXW5Xvo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsOiXOhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789638325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlEiyYfBcgBZ76TWKmXGj0+0TR0lMPdB4pkDmKpFYnI=;
	b=il/Zdx8s1ufv9G8zgd9n6FJ6AbM005LpqiRuwhQC0mHW7rwkXj5Cp0ADeiyv92yUj5+L8v
	ET157LCV+towo0uELapTZJeM0KdeUiX0DXdOfe+Vo/rdAr6EbAe4w2oS4CScZpP0SJfNCY
	7GFRqeW8jiO5U078MzF3G3gKb+o2Kkc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EA1F602D1;
	Thu, 17 Sep 2026 09:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B321A1F00893;
	Thu, 17 Sep 2026 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789638324;
	bh=hlEiyYfBcgBZ76TWKmXGj0+0TR0lMPdB4pkDmKpFYnI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PsOiXOhApn42Zfm7SERnLwjOpVr1mytK2ATvjWg4avApWeoUvMYCLfLOZeFxER7Mj
	 0bNXhssDlY7hMTWjHTWYpqcd4MIVzjdJZUgcsGqSztD3IjSVHSVJ+foGP5SzMGSN9/
	 bXV8BiUExefzNgVnwygrPmASeqh3xdrPGXica0UquwskEPtdboK6JgffcoXR56M7pz
	 hP/1S/UCsdQuHAwt6t3fMq18jfCjfxM7MMO/Kp9s60aVoRTg4X/USwa9FQjz7MeyoC
	 MkH7MwmcCCnaZK9Oazl/T5+Snp6cIhh1ylpJZ+xJysSs1z/hdqVCxFWR7UJ1cYbn0l
	 iej8UquDDA3ag==
Message-ID: <4b2c99f6-d7c0-42a2-bf9a-e85061d53c93@kernel.org>
Date: Thu, 17 Sep 2026 11:45:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: implement and use vma_anon_tracked(), silence
 KCSAN
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
References: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
 <aqKzUTPbh1qcKs4a@thinkstation> <aqgQw6moAuJYCVw8@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqgQw6moAuJYCVw8@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E31704000A
X-Stat-Signature: sfbr6eem4khy1sw9zanmf4saj9i3sjac
X-HE-Tag: 1789638325-742095
X-HE-Meta: U2FsdGVkX1/wFRmFszfdSpO8/ORF00iVjYbS14JzSuvXVUTTWYqTgNiBz6Wy8M9ieRgmKIH1SRBFEFzilADJBn4XO5uJNvyJNWF6Gh6tU0oeLGsp7K/42fX48ojOT7VYSq41X6ntbBBACkrp6iwPNfIujlbHnWQ17It2fqD+DTsI7PBah6j6K5/HfhkodRkw5G5usc4Lg13+XeCb2uePup30918PkQSCHBlUCqMi++eA18Fe+rUh0/nAIxeMnSZkTCVGZqminmizpUa1kv7eMRBJe+0sysScWZqUDUQknnnKTG3pjMBksiWC3DmPx/czWBhnSHqUCRweFOFmcggEYdkRgDi4OpeUVt/HL0HARSPIPpR3MWoBG/Li54hB2qowVWCKnSiX9iso1/2OGmxsqS7lyT5DeEhpeiPSMtYvV058MXfRf6GZ2Hui0K+ghR+hAkBofsy/fY5/STu3xVdxidKonp/kM7hB3UrKq9XzWtNtOUe64VH49rPIPMT9saQei6pnCrIq1EE8cAJAZTgN8Bbfo28Ydquxu1BcSCpJMf2PvnQ9+tnv7+GBueqxeGyxxKbz1MbV6dPD5Aj8HRqybT2tVKeivJvjKByyvgfqJ4z6KXSFYNHuPLkWriNZ1MhBXGQZAdn4g075MiE9SMZf4bvEE3zrIcChPB5dVxEAJmCPUG+cnAZu9nRSQcvtNxuwzFS0apWteotmP5u6d1HPT6b3K3qHYskOH5CHelfJLP64vtBPCC/ROmfG4WrftPjM9+Sfs2xDvUXbyLLrcKs/cDABkwfXhOwmpb1B+P8YVj/EADUH8O93YW9UPd+2UefPxKf9vjnJoFyHqdgnP7GPvmE1mxYXTjmavOOOACIJ/B2Q4oKeeAe1DysUF/SqZcB/n2MkuHoazvR/KwL2nhcNpiS9aQGs2goiKMTYZnenp4FYF88DPrGsFWfYng6un68fte39lS10y0oV4gjR8XU
 P7j+sQFU
 AB7BdcHH5TLCLuHV23CyCBcXYWLhn7lpugqpp7EJFLUBNtNgOj/OO/31GapBdIp9S49xyyg/xEA22EHwTYdF5dqrP69pJEnTjwQU2r9HWyuky6ZXGmwlxrUtC6GRTDhE7nDE4pts4GHqSrsz4JMwfG9CyPUrVn0LdMHiIuUWWNUcOv0qHWx1Kry04DQCH1RXDzuMa5yEusyEe921SHD7uZqOyaKB+Ko8U/2h6zzhfiAKwzmrw8B+TMY7z9bVOSpjcxqR8m1WEk21tDksiGetpnRyl+FCfp+Bgb5DhzIFOWSLaaj8J9TmYcMOX7NTBiGnwYaahzkOcnt93gAdxFjXgAvP8ICE9HwGTjytf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 17:21, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 10, 2026 at 02:50:25PM +0100, Kiryl Shutsemau wrote:
>> On Thu, Sep 10, 2026 at 02:18:35PM +0100, Lorenzo Stoakes (ARM) wrote:
>>> Provide a function to abstract the common task of checking whether
>>> a VMA is faulted in or not.
>>>
>>> A VMA or mmap lock must be held when calling this function. For an attached
>>> VMA the transitions between unfaulted/faulted state are:
>>>
>>>        Transition        |              VMA/mmap Lock state
>>>  ------------------------|-----------------------------------------------
>>>    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
>>>    faulted to unfaulted  | write lock
>>>
>>> So vma_anon_tracked() never provides a false positive (the lock precludes
>>> it), but if only a read lock is held, a negative result must be re-checked
>>> with mm->page_table_lock held.
>>>
>>> Detached VMAs cannot be concurrently manipulated as they are removed from
>>> the maple tree so require no guarantees.
>>>
>>> Use data_race() to silence KCSAN about non-existent data races between
>>> concurrent vma->anon_vma read/write on optimistic fault tests.
>>>
>>> Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
>>> dependants.
>>
>> If you end up respinning anyway, this would be a natural separate
>> prep patch.
> 
> Yup will do, Pedro also asked for this!
> 
>>
>>> Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
>>> preparation callers which test vma->anon_vma directly to use
>>> vma_anon_tracked() instead.
>>>
>>> Note that the lockless read in reusable_anon_vma() is doing more than
>>> checking whether the VMA is faulted - it is returning the anon_vma to be
>>> used on fault, so this check is not altered.
>>>
>>> There is one odd one out - file_backed_vma_is_retractable() - which holds
>>> neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
>>>
>>> Therefore just add a comment to explain why the direct vma->anon_vma check
>>> is required.
>>>
>>> Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
>>> Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
>>> Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>> v2:
>>> - Renamed vma_is_faulted() to vma_anon_tracked() as per David.
>>
>> I don't particularly like vma_anon_tracked(), but naming is hard...
> 
> Yeah it was a compromise because David and I disagreed on naming (again ;)
> 
> I think vma_has_anon_rmap() is a better compromise?

Yeah let's go for that.

-- 
Cheers,

David

