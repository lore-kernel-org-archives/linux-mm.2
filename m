Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5FFC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A2F6B009D; Tue,  7 Jul 2026 03:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D722A6B009F; Tue,  7 Jul 2026 03:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0AD6B00A2; Tue,  7 Jul 2026 03:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A104A6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:29:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECC4BC1D91
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:29:16 +0000 (UTC)
X-FDA: 84961154712.14.D4BE5C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 14E38140004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:29:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WuKDqQaG;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJDNsjgFUpkRMskGPiCnPSMfapFTgDn+0BKOC6J68lo=;
	b=MZpLRAFJSdQ4scMDhRWflTZIJ1ElNIiTflm5FEw5hfxA50RAJXOPEwfwouIWwBTSe3Gshf
	eD1n67AWWnVmfN6F7Y+rVs3AV+ZnUT8F6s2to8fiV+TEu1pFCSBqTIz+OTRINZl1BTMWjr
	JzOzyyo/5AqltBlUFvas0jdzgqXkvfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409355;
	b=0z4lY4EMiuWRxWWM6LQ3JMoYjALb65dqEufUne2NYQhRW8ZoprXnW4vkx+hLDsvFBZpEn8
	d/GsCkRzAwF077GfDtnMIfR4V4O7x4YrXs50nFP1BqqHqjxHWfBrTwFChg7SXIGhKQRdcG
	NAIPVowHT5TpZYTHukkMXTlX1cgPIjU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WuKDqQaG;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FA3C41FF2;
	Tue,  7 Jul 2026 07:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5458D1F000E9;
	Tue,  7 Jul 2026 07:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409354;
	bh=hJDNsjgFUpkRMskGPiCnPSMfapFTgDn+0BKOC6J68lo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WuKDqQaGsh3exMZdBNebudRylTlw0zWYmjonKHJt4f73TjWF0Gt5pCe1etLqyE2/M
	 rz/EoU64diSdXVCoKQYJxyhJdUA4wHslBpuzvRux4FZf3nAQrmvNd/x2Vooxtx494W
	 VwAVxTrOC8XguIMqZ6H3H9RRobbvmFWwcmHpZyCU2in3sTSHU5zs6Ik2VoZtY9a4qR
	 Zs2i6VKu5IlUeTpZoSabjz4z7AYwj6kY58PkH0qk4eaa9hUevjbR4Jm7HO3ew9CRgk
	 UnSX5qFYIxoOJsTnDDmELNhLn9CV1sYUle4MFGZUVaN+L3X/EwBxxXGVOpUTHu1mBA
	 xgW9UIq3SU4EQ==
Message-ID: <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
Date: Tue, 7 Jul 2026 09:29:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
To: Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, mst@redhat.com, mhklinux@outlook.com,
 fvdl@google.com, gthelen@google.com, mike.kravetz@oracle.com,
 pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260707064235.1386552-1-souravpanda@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707064235.1386552-1-souravpanda@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 14E38140004
X-Stat-Signature: bdwa7zrwshsan4i3cofhd761w65xhsqt
X-HE-Tag: 1783409354-24769
X-HE-Meta: U2FsdGVkX1/SLlljaHX+JO8ueO3RYzYJAohdoO1ItcyXHCGAVUGK9iGsO0nkuLsc6uRSXHHw2gof+dd1srAlbMuI+OlA2m1EDL29TJWncKBMbSE4vlIUtxTvqudCHT3O+G2lDxCaMCkdIWq+UKwu4LOi0y/OJngfLSgJ+VTuIYpBou2PIQg8MEmLMQNNR+XH7A+cXROvEEP8jk+p3kbunexBYtba3tfpeF1bLw1xAZsHZuC9lBrGM8qmFvfVn1bh8HI9JZcwXcWYBNdb8YemJtbGiNr6MFTEWs/J+kM45Ltvj260dkv6HBxyd80YriZggZw37pwxFRRzQOXJEWmEDh4oh/O+1me+1JsnieJGLegfH1i/9wn3GL2IKrd9mWzdQYfkSnKbYC9gP9inDAXlW3d7l2UPYzeZoH/dauKtPcAWslklcOTwBGB3Dl0/gGH9DsMaC7IKofTsvtSYXawXE5zGzun9voWvZsyZDz/yLkNdfUSDS+Hg7aOwa55wB0hRW1cWc+kjF7AGElFZs4Jv5OR8f/KFM+a1TKFma37OOZ9K5IsXjeLlg28JfTXzx4uh8pIw+qVbHuhXiPtub19UoqKtWwxpdyFFJpOj/JVAK9xjZv6NlQh7jP6Alq6VAV6sodQqNpEg/239ce+uCKyXlxv5K23UtsekoZUwO3BnH8ZzkeEy9cKi8wP7Lsdeg2sOnNwivseJWPgaL3qk3aID+Rc0IGYWFJ6COioXVaW5R8tvOqZ3fxinQKfi7TkiN5EHlBKlFN1UH3aiJUNJTC8c+mMw3YtNc8faGua3zjpMInvbG9P2nkVmm7GVnQvLP6zliwzD8+J553uZ/9eeXUAi8McJwlXy6TuCE0LrGRTQMdSsT2RKbsg99/Fg2a86pptXPQgDwfsuz0F54+J2RCxjrgeRWcus0xk9IxYCXznZ7kIobeEarAwYF/dsRGBd4TAXGyA+wj4RETHeW8p9qk9
 ezw2FG8T
 KtguFazs7QV+jaNBKTFVxh9gsa6+77KVL3JNkOHeXn4Fod0GLKnu4kd6QX8e5KtDm5L495PmZ7johYf+GJezt1oQncC4xgvbN67hY4FPoF3tMl/b53cvhOBAfxXNfa0qviUYILHnygwPSRcTarYFlZKQfVRmvXk0046W09r0YpASs6EnZorshOKULkZKWv2q5GecFGPodxvwoINCQ+ysndEWJgHX5gbV5JDJOddtVRxMxT2Hj4+bx91r/Ax0KNBdmYdfQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 08:42, Sourav Panda wrote:
> Overview
> This patch series introduces a dynamic, NUMA-aware HugePage Cache,
> backed by a kernel shrinker to safely return memory under pressure, and
> integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
> specifically targeting gigantic (1GB) hugepages. The goal is to solve
> the tradeoff between allocation latency and memory
> fungibility in virtualized and heterogeneous cloud environments.

Hi,

in general, we consider hugetlb nowadays to be mostly in feature freeze, as we
realized a while ago that adding more special casing on top of something too
special for all of MM is only going to hurt us more in the long run.

We want to have less special casing and less special sauce, not more.

Now, there is nothing wrong in making hugetlb be less special, by making it use
more of core infrastructure etc.

But optimizing for surplus hugetlb pages by teaching hugetlb about new caches
and its custom free-page-reporting support rather looks like the wrong direction
for me?

-- 
Cheers,

David

