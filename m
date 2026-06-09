Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F17BBCD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31EDF6B0005; Tue,  9 Jun 2026 05:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF7F6B0088; Tue,  9 Jun 2026 05:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE376B008A; Tue,  9 Jun 2026 05:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC476B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:26:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4BF71C2607
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:26:06 +0000 (UTC)
X-FDA: 84859842732.18.7DB25D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0E6A240002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:26:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZF1jpp6v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780997165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fT247pCf2/V6ARxuw9Ry4Z2KZS4dVDh/CvQ+WKMkRLs=;
	b=lcDkOuuIpXCNIHdFx3fBsmsBF4L/8Ni/ZTrclfhXt59wgw7LwdTJKry958DPjky8X5VCmo
	R1dFHTQvZ9SfEJmd/tAQVeRRWMB5vIAOm2I082Dus5oJ//ffBKx4ofG44NcqVLFa6CS45V
	WPoyIXkiA4SrgE8u/lalyCyavQs29bI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZF1jpp6v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780997165;
	b=AfL6CWhYBqWpUSe8FEbl9OyCTitt2rGySywHHQmaNzJlL6z04O+OBSe852OCRX/lddQ2bj
	GjE77gRY7Jdmggod78s5kGk3E/Z1i7J0Fd8ixT5m5mC+jyGwI2tZN+PzA8Gz5ggRrhNtL7
	SHb4YK6tMjTPUPOwcPBm8hYkDhOuEdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F9B760154;
	Tue,  9 Jun 2026 09:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852971F00898;
	Tue,  9 Jun 2026 09:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780997164;
	bh=fT247pCf2/V6ARxuw9Ry4Z2KZS4dVDh/CvQ+WKMkRLs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZF1jpp6v/dXCeWr7H1p7HtA++QO5V5PbD/834AWaM1fA5wfB5NOwDk70hyhVOoyJs
	 ciupynr8vusnykDt6q/Xl2hxtnA/TLwYsL8xtFB6w0WVWhqkVahhEgywOv5lVpQ/yj
	 Me4eyQsUzWJWqEWFgDLzQFPgLQvsuskD1QicKh+dCqivZBb8Igy5YB3fAlk8FQZNlg
	 6PUqHLqlwO1KbLESLAntW2eYdlMQHFlFDxnIS3oGGn0XLPxi6+IhWD5wwI9kF7VWH1
	 YletVPTwk0H1Kkqkjd+VxK/+F3pC5locj+t7miBietqXB6RidJJ89yPA8aN7vdi3C1
	 1BIN16E1qzTog==
Message-ID: <b7fb4184-7a99-42c7-8ee2-4c7fa20827c4@kernel.org>
Date: Tue, 9 Jun 2026 11:25:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Nico Pache <npache@redhat.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260605161422.213817-12-npache@redhat.com>
 <20260606102800.26940-1-lance.yang@linux.dev>
 <2553caae-9e0e-42a7-8b61-d1216f1e81fa@kernel.org>
 <CAA1CXcBY_2372eJru8VoCq90rUMxn7w23hHou68MmXRv48NRXg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcBY_2372eJru8VoCq90rUMxn7w23hHou68MmXRv48NRXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rw686mnhi1xsxoiqkund1p5rupt4tjht
X-Rspamd-Queue-Id: 0E6A240002
X-HE-Tag: 1780997164-92731
X-HE-Meta: U2FsdGVkX1+dvA+fy7BtDemwmL0M6E7W3bKEj+7mRydFDDIFPASyz0tLevAZTF7Ifhrbh6FikDQpXz/v1xtEIKiYofUNGe0AX6NHkcgP1owUELd+fz45Tx+UzUwwoGwJ8lIBRRNuy1ss+BlAUTonb2wmf/2cQCc4M7Q3iRepfJDv4pbL9wlxRNZM9N4H2ExYn0WJ9tXnT6oLOvpEljSoHIF/hjjBGLkvTWl4hjPW2DfR1gQ6GG1kXRTdPdBrZ4Z7PcQtE3xAVZnVW0SD2rzBYP+M8HhG4PyK/yeAliOIZeiPYsMbIy0xEUAU1KXIUh0x3Zf3rs7RNjrOC+bGB1SOEemqUrE3qNH9qflJ6mWNAUEnx+2icMbGlSOSiYpJEeiyvo1wpFaEAYMxRpzm4Nrdi5qc0rh+tRJWwa0tk0O0uaBKuasAoPhhhAS5w2sfcAKIPmlkYmaeNe+Vz3bL+Tx9IexIVaVe6TntY77lQsNc7fDW4qR+ljA/ljeSST4cpLNuJddGWPAd6PZu01OjOzIo9c+C6KLp0+yk5za78/FXvZ1WH1zi4iJjiKHsAoSNBT5/RSl4AlnkqdfUQz9n/u3tTe/k29iPjqzKAhKUWEonLmT0JeN2ENfu6EI/Zp5Buvuh8JUtns04v0YlbdFb5ez8uWDQCah63dEu6Uu2W+Z1ZttUcZ1kkLhpJcVM+wd+7dpDdZyWSF/p+Se1MSRH64hn3rBhpaQ/9FiQbFSyQ59smvVmxW85dU1X9sGhds/TIEPmChyNpNl4rhUWKzId99XmtG3+FIgeX3+hsuWORLT6WcU9RtrJJlnKFDnWavJmfTenj7xTxCOmDtiXWgjCFZsysnu/mxUxHrhMS76dHyn30nf7mns8UOqxbfTqBkjGfKzZHw4T9/ctjOIJXgHWnT98bpn+NK2cpHDRPxfS7jmAKEaVZcyOHqWqRnp89f/hKuNJTHJaFSMp5kJncLOK44G
 59qe6Ak+
 28cbg8T+T+LqQBLRBfTKPgh+AVQ9qrvfdfC8bSaT7c8j0B47AwOE7oz0Va2j54UvGu44D3fZQPZA2DsfR5wxKfblOyL3mBQJa6k9QFF4iTqi2Jr75w8x7nJRtJo42ARWf4JD4gzRzDb5kJR0VEra2qQaVxzdDnmBYQEz80MnkMmD6+X1QACMhhBhW893WZSEFAAo14ueZOSWeicxqO1ZR6POUl4sdqd0PsD9LIBJGwW7bqhyoX9XBqnlFrWktjiTU/+K9CflzrT3H6dp1N8Eb5XbtI3jlw1ifia662+4XVsdNDB8hYO5M2yYbXTDCNIOddo2/Zb4//PXRoOTmEXvqDmZ+WGB4701pqUEHe1dkIPbWbFGA0/2MAwsmjqPWong06ZT5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 11:06, Nico Pache wrote:
> On Mon, Jun 8, 2026 at 8:57 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 6/6/26 12:28, Lance Yang wrote:
>>>
>>>
>>> Looks broken for swap PTEs in PMD collapse ...
>>>
>>> collapse_scan_pmd() allows them up to max_ptes_swap and record them in
>>> unmapped, but they don't get a bit in mthp_present_ptes. And then
>>> mthp_collapse() does the check above:
>>
>> Right. I assumed this is implicitly handled by the optimization in collapse_scan_pmd:
>>
>>         if (enabled_orders != BIT(HPAGE_PMD_ORDER))
>>                 max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>>
>> But we perform the check a second time.
>>
>>>
>>> nr_occupied_ptes >= nr_ptes - max_ptes_none
>>>
>>> So max_ptes_none=0 + 511 present PTEs + one allowed swap PTE won't even
>>> call collapse_huge_page() for PMD order.
>>>
>>> Shouldn't we account for them in the PMD-order check? Something like:
>>>
>>> if (is_pmd_order(order))
>>>       nr_occupied_ptes += unmapped;
> 
> This solution seems good for a temporary fixup. but longterm we may
> want something else. I'm still not sure how we plan on supporting
> swapin without causing creep. So I'd be ok with adding a fix for
> legacy PMD behavior until we know how to handle mTHP creep correctly.
> 
>> As an alternative, we could either 1) skip the check there for
>> pmd order (as the check was already done); or 2) introduce+maintain
>> a bitmap that tracks non-present PTEs.
>>
>> @@ -1475,7 +1477,9 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>                 nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>>                                                       offset + nr_ptes);
>>
>> -               if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>> +               /* Check was already done in the caller. */
>> +               if (is_pmd_order(order) ||
>> +                   nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>>                         enum scan_result ret;
>>
>>                         collapse_address = address + offset * PAGE_SIZE;
>>
>> 2) would probably be cleanest long-term.
> 
> That would be best for future swapin support in mTHP, but I still
> don't think it solves the creep issue. 

It wouldn't, we'd simply maintain the state we collect + rely on in separate
bitmaps. On swapin, we'd have to update/refresh bitmaps I guess.

> Perhaps we could combine the
> two bitmaps to determine if it would make the future collapse eligible
> again? Not sure but ill start thinking about it.
> 
> Should I send a fixup for this using Lance's solution? Or does Lance
> want to send a patch out with the fixes tag?

If Lance could send a fixup, explaining the situation, that would be nice.

-- 
Cheers,

David

