Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B0F606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e1JtPrG1
Received: by kanga.kvack.org (Postfix)
	id 500626B05DF; Tue, 20 Oct 2026 22:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1EA6B05E0; Tue, 20 Oct 2026 22:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7D86B05E1; Tue, 20 Oct 2026 22:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3B56B05DF
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:49:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A85A9A7E69
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:49:53 +0000 (UTC)
X-FDA: 85345103466.21.C953B18
Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	by imf03.hostedemail.com (Postfix) with ESMTP id F2E1F20005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:49:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e1JtPrG1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+NcK0DTs57+vVGbRZ1r7hBBNrTBEdI/I/AT/KU8aM0=;
	b=Hk6ol5Hl3IXivFbHfm4GEowaS+7O86Ac4BNsjlBj976yZJwaeqDq+hOkDMkxaareqG+Y3/
	ThtzPMu3TchxGOePlJon0wndkKueQkSuVnGXolPQdQix8qdgjvyLx/kUW56isRe3bIm94d
	BU8PJeElO6IX1qLwWjoijYH5nY3H2Vg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e1JtPrG1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550992;
	b=l4ZHmeEQO7/PCNp9KuNird7LP+TiGAm8H/p2H4ujmQ4PtYdPwRnGyfN4HxcAJ0KjnDH9zd
	8/FGhiI471RXxhy1LO2cr8s/VthXvOcL1ATrrzeP+VvruDgEK2x5XQ1L7UsMkZPHdpVvxG
	s9SrrvkVCqt+sWDG9zFVqJPg6zG2h2g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7HL9R8UsN2zMXkrkizxTIyjEphJ3Yy0GVd7C7cCL//A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792550986; v=1; x=1793155786;
 b=e1JtPrG1Uey/OUeY47nHEo/2dzWZ6ZzXdjNvcv6oMEFwkG2Znm1xuDzxYcG8kYperJUO9TP+
 drwsEbLXjITD46o5T3cObzDzwFVJ3NHqdVvQGWrBy4Rd1CfWKdn/d8LqD5djfe4NgrvRbJ0DWCr
 4UylqJpzgzyxxb2esdK7dJ1Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 5d093a78203f7ab2;
	Wed, 21 Oct 2026 02:49:46 +0000
X-Mizu-Trace-ID: 5d093a78203f7ab2
X-Migadu-Flow: FLOW_OUT
Message-ID: <49966df8-c092-40de-a05a-ff6d69382dd4@linux.dev>
Date: Wed, 21 Oct 2026 10:49:38 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
 <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
 <877bjowf9i.fsf@DESKTOP-5N7EMDA>
 <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev>
 <bc1b3255-99f7-49c8-bb52-bada6df80f72@kernel.org>
 <23d3756c-1a87-402d-80b4-c838dfc29f4d@linux.dev>
 <9da90d76-031f-4211-b9de-439cbf7bc63d@kernel.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <9da90d76-031f-4211-b9de-439cbf7bc63d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2E1F20005
X-Rspam-User: 
X-Stat-Signature: wi5fwoit151mfof3tmk7mwbuqdypnn6f
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792550989-9590
X-HE-Meta: U2FsdGVkX19cvWqm0qfP2/NEGhMfk7P7sK8GgCXz4t8mhE2BQLLGPZ4/WZ2obyJbKjhCT04fv/nxlE1hNMqmtkOCCGs5z9+js1SGknmiBRLEVqEHuFqaH00v3qy7F1mTWIEL844vRZD78yi9We0GS+/8FeJCLx4IXKyfrIc6A+f/PzEIpzy6Tg8izhxDsEdtPd0+PA975q3EY4kDMXWcFEdV70Wb18nyOiUNCbb2btDMBYOg1r/VHZPBJh5a6b6dTtcBpJ1kCFJPSFoy3KlK5IyrLsgbzeuB9lSXVJCaMOhfjVdEqQM6u5AaxTcPG4UMoYhUoO/RX0wtN21bUU+fBQbOdpAXQenJrYnf7IXbYdumY7LADrsjX8ptIOXaMuddqMPPY1BXmF+MCp8ZY1jEhtqmEUFy0gx7hm7ihaJ51zdMTIQX+oadbtT6cUNFIurj0zqaE3cdyMzIpLbjZI8h1UPNDcTPRoT7Fzx8g9J5qzX+xJ0C+NorR3p7JhoPVBtpmzrgX/U6n5eY2vH9v0FHg156+ZqvjqiR0b+begZ4nD0Kh6wDzzi1+OBYJbOee+wyM3zQDLRHyotrMiP+Klg0ueo+Uxu5RLBSCzkFFCAZdwgd3SNMygzfeCH2IEgvQgkWvBQ1g8qW3zT0NNLaj//YtrQUcUvSNc6AsMzJAcNF+/U3NWAVBrp4vUR1+GqM4acq6pYScgyAIlqsjlQqD3jSkwPe+LJyZFcSOizPX6xUgvLTiYqWlM1ARDzAvBrg0mBBDgoR93zyB3p7qowmymX3+ZuzhhiXSFsdbU0Z/pHVmzwH3AiPk/h/t4eqYJiHZBtriYv6+WKVxtdnworLoDF8nABoehEZL7kE1J8h2ejOVlEOmUx7vFkMgPBCaD3zr75lYjd1HUyYiAFAqpx2aRxDgHE/SsMtMwYl3G1HWfveB5c7irDMLbdHF/Z10Jy7N/Jx3nE+746bNKHzpN/YCMH
 suUH8gOO
 D5uC0760vVJK8V1YLOHdXLt7m/jeIhymXfJJzcY8w8MhEbtcoC5QmIrGDTKhjZU2agpidC/mQ+sZDe7+0oj5ksZbzMwbQAbrHN1Bd9m/63SafTvkuOjhZdUoy8XRfwWQ/Byp3O6gimv8uudOThHzkOz3+SsDrg9MxhdkEO8xTf+vn+UvZbr2Utafy0or1i6FBzGT+rXAI0HGqHph7FLBOLmThQbo60D2v8IbFWIsc2aykqcdn6mz5VIcq6GLjFlizKOUdlmUsWMwFMWEQ5Ec7ff+QIFc2rKN3nSYY7ihMZ7Ey3JIyoIUvn4qdCDJyxV37RpKgyLdHt+l7ou7JdBEu51UFH48BczP+Cj74Auq8V94t/FSbZ/yAltT6OxIQ0a2VeVAL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/20 21:58, David Hildenbrand (Arm) 写道:
> On 10/20/26 15:31, Kaitao Cheng wrote:
>>
>>
>> 在 2026/10/20 21:07, David Hildenbrand (Arm) 写道:
>>> On 10/20/26 13:27, Kaitao Cheng wrote:
>>>>
>>>>
>>>> 在 2026/10/11 21:14, Huang, Ying 写道:
>>>>
>>>> On architectures with hardware error correction and exception recovery
>>>> support, accessing faulty memory automatically triggers an exception,
>>>> which itself guarantees atomicity.
>>>>
>>>> On architectures without such support, even if we implement this logic
>>>> in copy_mc_user_highpage() and copy_mc_highpage(), checking the hwpoison
>>>> flag and copying the data remain two separate operations. They cannot
>>>> be performed atomically, so there is still a race window between them,
>>>> however small.
>>>
>>> Yes. And you need proper architecture support to fix it?
>>
>> It does require architecture support, but that doesn't seem practical, haha.
> 
> Well, but that's required when an arch wants to rule out all races.
> 
>>
>>>> Moving the hwpoison check after the copy might address this issue.
>>>> Is there anything wrong with my understanding?
>>>
>>> Will architectures that are not prepared for copy_mc_user_highpage() not simply
>>> crash if they trigger an MCE during an access?
>>>
>>
>> Do we need to check both before and after the copy? This feels a bit
>> redundant, and I'm not sure whether such a small race window warrants
>> an additional check.
>>
> 
> I don't see how checking after the copy makes any sense? :)
> 
> You already crashed if there was a problem, why check? Or what am I missing?
In cases such as transient errors, software poison injection, repeated
bit flips in memory, or bit flips in the ECC check bits themselves, a
page may be faulty while memcpy() still completes normally. If the copied
data is correct, only the PG_hwpoison flag is lost during migration. But
if the copied data is corrupted and the kernel or a process subsequently
treats it as valid, I think the consequences could be more serious than
an immediate crash. However, I cannot estimate how likely this is to happen.

-- 
Thanks
Kaitao Cheng


