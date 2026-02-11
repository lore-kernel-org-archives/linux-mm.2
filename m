Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D57FBEB5948
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 01:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB796B0005; Tue, 10 Feb 2026 20:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259136B0089; Tue, 10 Feb 2026 20:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165356B008A; Tue, 10 Feb 2026 20:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 036C76B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:04:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CFEB56048
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:03:59 +0000 (UTC)
X-FDA: 84430378998.26.300EFE5
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6C46A1A000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:03:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xfnosfJr;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770771837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m2AbjOPxKKnOcMkXmc4uuC7NcmlCqX4pUjFET6O+r8=;
	b=xnvDc1vbvX+OrPTA11VJRdNVIFuID0Lzj1ruuQlXu3cze3uXd3b9zawyRyYXsLW/SvTiTm
	a/P0YITRoBh4E9htFjEf4dusvnMuoSPhKjggubPKuySw2xSiOIgLbMuSws06+JzSxz3PSj
	FPOK13+zDQZfVa1eTIuyi1GWHOVNis8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770771837; a=rsa-sha256;
	cv=none;
	b=GxmD87IbNqLHxmhaEfbkFAWIZ/Gx0nlNQnIOlBTFQOymY+7WOwuJAaDxu6l2fVI0NOQDbh
	4cHLtce12bEALqKBE7GU1kKxic1AUq+0XnCBQppz8OtAbWzRxYM2OX3J0nsfSlNTGRM6qT
	iyjvTI/bEZP0CWT9dfbK7Z7c8Et1yVc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xfnosfJr;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770771833; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5m2AbjOPxKKnOcMkXmc4uuC7NcmlCqX4pUjFET6O+r8=;
	b=xfnosfJr/46Hkh+NP0vs9gCohWibc2wzI393ZzJ/W045mL7FwwiSSCJ8vB16QCs6B4XhNHVDNCT57TrVZiFxsmOqPtPKiZ9tnTpGbC2dtdOu4DjA2ijDPFGN4PLYwRVpf/skbqnigAPd4czfSp95YpFrqZDpqZkQbCNfUettzOM=
Received: from 30.74.144.106(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wz-ykxt_1770771831 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Feb 2026 09:03:52 +0800
Message-ID: <bbbcced1-6497-476a-8716-7d16304c402e@linux.alibaba.com>
Date: Wed, 11 Feb 2026 09:03:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
 <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
 <1179320d-6bab-40a4-a7ac-dbcfbab24623@linux.alibaba.com>
 <c225864f-192c-4cf0-a5fb-411de8c22eec@kernel.org>
 <70ed2de7-3e66-4a23-85bb-e0a4c5b61088@linux.alibaba.com>
 <af21afa0-2a30-478e-ac9f-6bd431af6502@kernel.org>
 <gogfqtdrd2lfoiwfetql4v2pjehof6q42oewn2tphddobzawf4@efiyrhjyzm7o>
 <a6e73466-030f-4b9d-a0b8-502916c139f8@linux.alibaba.com>
 <a2985ffb-6f00-4b0b-b29d-22b39ffc9eb0@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <a2985ffb-6f00-4b0b-b29d-22b39ffc9eb0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C46A1A000C
X-Stat-Signature: o14f4xy3ecj5m4jwsuwc6s9f94ydq6oe
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770771836-829808
X-HE-Meta: U2FsdGVkX1+/QlA9VdF4Wu6VmXjZFeZJ5LhKzC4vdwQEB0dCS4syd2S5KrH/iBlgmk2THySjkHoc1RH105PvuG13VqVQINGCSoyyoQSjYNBYH/QcIQWtXjOgZMM22+duXLnFdWMtUR2EdtThMUr3GFXPBE7m89L+sQGwzg7jUtEIG1FZHKUecBiHErfHxISnrwPVUVW8Di6lD9nA0nydWn4sKoEPuVyFaKJM6b1/WHsobroeWuMFLxJ+uRMuys27w9gs7A8l+crn+tN7+Be/GVn1WXVYDmmNCakDXhvGHBh1pE5ApsQTGhR3jrjLc441VqCGRxVR6ZGKy+mm0YTwJngMmrOaesFE96Fzy/fRjii3KvvBFvjochSh2ugXtvdvf44Hp/Z3mN1Rl1s9HH+IpzJ6gHlqwEl5m6E/MA8+NWWfjh7IgS/SfNPhinFA9eYOLipmX/Rx9CkakD6ueU2W6Ljg5Qw+ZmOuaJxt358B+ZYTQ1OH7AZn9gU/nqXFul6EbuOQlotG8zUJxSYl3MUv+HaKLNHnixFjdHydh79RHdO/xx146iKHJ7j0ei4uOTY//D0yL2IVmEXFm7wEbPT0mZ+gGIhOwQx9S9XqyI2RuH3KBBfG6Q3nt4JkTh2Wz9rgDDTLo5e9ZS3Kb1Bod1f8bdLm3sKblbDzbZp4tV5i0sl7ZwquTZXG5Qk/bUjrmaMb1hJWnNEgKOMTIAsKbA+xdIRY5b0Zy6pIWBttiHkeG7nZAIDkgrAzS6lqCOkzoNGghVahOnE6VtKDPJawBVkWv7wFIIqfHdIt0sAybqfb3RJhYfy81WYNUs8hlasr7gS9317HQ1+5OjyBfOymiXJxrxs/eB36zp0CAxwmwY6lm1wXojOdFpe4quEk6b7AJL5xRr0lfphz+whMXGSpPQAJAN/vTuSnBXwMdbrB6ZQDoeX5VZa670kle48mye0dVphp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 6:21 PM, David Hildenbrand (Arm) wrote:
> On 2/10/26 11:07, Baolin Wang wrote:
>>
>>
>> On 2/10/26 11:21 AM, Sergey Senozhatsky wrote:
>>> On (26/02/06 10:00), David Hildenbrand (Arm) wrote:
>>>>
>>>> Right, mimicking what kswapd does sound reasonable!
>>>
>>> I may be missing something, as I'm not seeing dev_pm_ops in vmscan code.
>>> Would something like this work?
>>>
>>> ---
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index fa6a018b20a8..c5d89ec223d3 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -394,8 +394,12 @@ static inline int 
>>> hpage_collapse_test_exit(struct mm_struct *mm)
>>>   static inline int hpage_collapse_test_exit_or_disable(struct 
>>> mm_struct *mm)
>>>   {
>>> +    bool was_frozen;
>>> +    int ret = kthread_freezable_should_stop(&was_frozen);
>>> +
>>>       return hpage_collapse_test_exit(mm) ||
>>> -        mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>> +        mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
>>> +        was_frozen || ret;
>>>   }
>>
>> Since the hpage_collapse_test_exit_or_disable() can be called by 
>> madvise_callapse(), which is not a kernel thread. 
> 
> Which raises the question whether we should forward that context 
> (khugepaged vs. madvise) to hpage_collapse_test_exit_or_disable().

Passing in the 'cc' pointer looks fine to me. Something like:

static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
                                                 struct collapse_control 
*cc)
{
         bool was_frozen = false;

         if (cc->is_khugepaged && 
unlikely(kthread_freezable_should_stop(&was_frozen)))
                 return 1;

         return hpage_collapse_test_exit(mm) ||
                 mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
                 was_frozen;
}

Sergey, could you submit a formal patch for review?

