Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FFD0CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505BC6B0093; Thu, 25 Jun 2026 08:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6286B0095; Thu, 25 Jun 2026 08:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FB16B0096; Thu, 25 Jun 2026 08:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC8C6B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:36:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99E9F1A0668
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:36:46 +0000 (UTC)
X-FDA: 84918384012.29.337F629
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA16140003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:36:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kj8c6IOP;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782391004;
	b=G9HlBdkSL/3MDx+s4hlI2aMUC5O/5OBKkx+2VkV+CweO22FG3vyiAPO9a1I2b2i+Yrnlix
	6W4p9sn+314ojpDVaY7+D1bx3Io25mIAwakP9eioPv0Kza4wbxN2nihaejFoIf7gwYSwEE
	XCRQ2KUwZXdTQR8HG5BBZerI0WiiQtY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782391004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uu7gdoQEdoZUwJ0MDafJIXOJkq/sIP8btQOGYvnT2g=;
	b=LPByZJyP/eYQFLAWEnirYqaBniwCJwQHCJP9m9I0fNDInTf0CkhKCM5RH+kWBR5PaxACnN
	1yhY1vR9lc4CG3KgILm8tHfgUXOyVBMRdXnwr7hyAssjgQrO61bnp8SjR6sTeKuTVnFcn9
	4tzaTQfWbPIKsKvOvQAZYzWhjTulgQY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kj8c6IOP;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A45CA40B08;
	Thu, 25 Jun 2026 12:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151881F000E9;
	Thu, 25 Jun 2026 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782391003;
	bh=0uu7gdoQEdoZUwJ0MDafJIXOJkq/sIP8btQOGYvnT2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kj8c6IOP635C/jK71RNETwqtzkumMX+bN7xVpwgoozalu59LqzLn5myc6+CGZGVOr
	 acmJgg9QozXxSWGs5lARRAao5LNw0qlHM6bIw2O3mupJ642jqMd2RjVcDx81bTHA6f
	 U1YjJY+qDDHAYbka7Uj/0BBpZvL2RcIUrmEweS5hPMFF2B2Y1lqZ9J32E34bYoLx/4
	 te5gjDL4zagobX/70siQAcfOiSCDpbUQiHYUUB3BukZ4CcPbMacsICz1Sr9JNeMb6o
	 /o/LiPtBxR9PY6IrUql8MnN6dse8gxxJb8WUj4N7DXo80yh1LwDsNuMYhUEgbD90bH
	 s3NjbK8+MfNow==
Message-ID: <088e9969-9104-4163-8ad4-59bec96014e0@kernel.org>
Date: Thu, 25 Jun 2026 14:36:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/42] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: Ackerley Tng <ackerleytng@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, ira.weiny@intel.com, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-10-2f0fae496530@google.com>
 <509f9a66-5ae9-4c05-bef1-ced89fd29bf0@kernel.org>
 <CAEvNRgHM4a66Jx9++6iioQLpFY-KgPvjY5+bg_X97DfSjpXzRQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgHM4a66Jx9++6iioQLpFY-KgPvjY5+bg_X97DfSjpXzRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 79fupp9w9u9djnfd7g5r45foyehf7up3
X-Rspamd-Queue-Id: BA16140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782391004-835747
X-HE-Meta: U2FsdGVkX1/iYWG3Odw0FwlCJLyo2qVQopzfHWRZ0lK/IuSxhD5Pl/k5xSU8duwoI6+YHbs+z79qr8HNBvFNTQ4SsAqGXHRg8fAjflZ8McMZgqAcaOf5aIdE2TXCnxnRgXA2TIDeRYQfC/QZzuCTvBvwmXjF7T4/KvXFJezROJSQi3zRzwQNj5GGUo1CtI9YpjypGCT7GV4Ck7l3WIAxA3rnD5/GJBE7i5ggmVU13PRJtkblQ4YEw0f4gYGkx1hae6Kzgpp7o0W/1/z0IIbTg5w8w3UgDCwSuZAg5hgiliFC319MV5I9SBjCGyB6tHosjn9oAtt8bEqiyeuCZem324AUq9NWgn9ToViDRXOHJVFrI/xPf/REAgLUEl2U+HIBX6uybDSp/OmC76cafHD6jrAiAt/0GQQvMitkB5VW9ZzMqcTUZCV6MaETUO/1eSQoF6Kw2EuiH1tEieh3cVMwlXOlK5pivr9SPbloPjHZiGWjq05q4ZEcWBN5acxG3eToKMLOkBA8LskmsjTaGXpMNNK5WzwJrtQjx+0NS+I1vdUJx0p2BYUyA0yRMDKYhHuQwSWF4wXqCJmlHNn2EIBdPwFVUclrwwN5WZQndlSMM4U2n9v1iPKFN3yM2GDEe4hNPMfvZ7afb/O8krspi8yVLGC31r5m1HHxYQFd92nfXubuXjpLQi/rafRmCVagSQWCBWPaLR/q6ljpGILWGyfCf4l45N6gShM1CsDhGLKk/mUJ0y1w2Jsne789ugTbGIciQXtwq91YXsgw1ZaEeOM6DQBxqgLr3gb/YWMjSNgGJVcHV56H3kCPAJ1Gz8dif+cl5RawinF6p0dLR3VgeCCrciC4cOyPj1gpTW69JniFpnzScnbnCLjd/p94tgGenzUVQRAziUch93EVRVqbQv2qoz3X097iuts1opwgR7eFCK1gDRir1qdDY9tsrcpzx/Stl8ZMfxJlRZfCXtUdot7
 nEWy38Qi
 zqHVwjSqToUxzGN/8awDRR2dqwQrkY4g3jTg3Dk5YKeIj4njbSkI0wNKMBtyLaHF74R8Dw/UCpOZCI6YaMYOVePAbo9n7lE4PskoQ240eR9CGFalzFIBybYjDFIcNWGAa2DKautsbXsaTgUr0IQah0Bnf9W4+hljvPLhuwBqpsdSR2WXWBEz0l9Djl3mvadgCIW6NkIY3fkJvue6TBd1FzXVIVnxTYcEXJCeEqeMlarjn6Sgh1HJOkvkcDpEbFGLfRxNOWO7JRGXm6MI8XIt5T7BX9YTUQ6u6MRm80ar2ex2KMwbqoNNeQmZY6HGtip5WjKa1yJN830msAGeoiM8vzU+AMRVOV8yo88ui
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 02:17, Ackerley Tng wrote:
> "Vlastimil Babka (SUSE)" <vbabka@kernel.org> writes:
> 
>> On 5/23/26 02:17, Ackerley Tng via B4 Relay wrote:
>>> From: Ackerley Tng <ackerleytng@google.com>
>>>
>>> When converting memory to private in guest_memfd, it is necessary to ensure
>>> that the pages are not currently being accessed by any other part of the
>>> kernel or userspace to avoid any current user writing to guest private
>>> memory.
>>>
>>> guest_memfd checks for unexpected refcounts to determine whether a page is
>>> still in use. The only expected refcounts after unmapping the range
>>> requested for conversion are those that are held by guest_memfd itself.
>>
>> Is it sufficient to only check, and not also freeze the refcount? (i.e.
>> using folio_ref_freeze()), because without freezing, anything (e.g.
>> compaction's pfn-based scanner) could do a speculative folio_try_get() and
>> the checked refcount becomes stale.
>>
> 
> I believe there's no issue here, since the main thing here is to check
> for long-term pins on the folio. Perhaps David can help me verify. :)

I think I raised this in the past as well: ideally, we'd be freezing the
refcount, then, there is no need to worry about any concurrent access.

However, we could really only get additional page references through PFN walkers
(or speculative references), not through page tables or GUP pins, which is what
we care about.

So if we can tolerate a speculative bump+release of a folio reference, likely
we're good.

-- 
Cheers,

David

