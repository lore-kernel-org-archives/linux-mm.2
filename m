Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC84CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A47E6B0096; Thu,  1 Oct 2026 07:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C7B6B0098; Thu,  1 Oct 2026 07:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492836B0099; Thu,  1 Oct 2026 07:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 331196B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:41:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A728D403BD
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:41:14 +0000 (UTC)
X-FDA: 85273866468.02.F9EC06B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9AB3180007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:41:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LTwFk0ZU;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790854872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTQjaHyFzgR+M9iAe8/wiUOMwWAu1rzKJDK8Ma1143k=;
	b=rCO2N62y3vgwKz0JxYZub29PBgVvWuFEVjOqDASEXHLw6gZ7UMxDTjL7U6ds2ZlJbISPk+
	8q/+yIyDYtYYBD4qxozZJ5TE/VQ+e79sojmWr0jpuAiEP8t165gEgx6Y/pAxWzt3XoiTPq
	W0ZE3UZttb9v7Jwe1wOzDoVcVRXJ+5Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LTwFk0ZU;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790854872;
	b=uCMB7bCDfWFC3fj2vS11+GKWICpHwZkPO/tMjx7muvLdUylkTmtgjtTB4XtjDVECYjMfh5
	8OkZP7Nhu3NZYjgBQvpSYEtkKdIfAUXtp9SykEvkItKORQvTmSQ1SqdK5Yld64iw8ZlvEW
	Zdtpsxmu0bAVt7B/58bn1L2NV4VYm7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D869601E4;
	Thu,  1 Oct 2026 11:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C591F000FF;
	Thu,  1 Oct 2026 11:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854872;
	bh=OTQjaHyFzgR+M9iAe8/wiUOMwWAu1rzKJDK8Ma1143k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LTwFk0ZUeiqGzU59Wwjcl9Gq40g4HavoEq9B1yqQgL7vhd4Grw+hfiEa7Bj7X+q/f
	 cfPlP+P21MXKYPL2otF3w/m8hCl5l+O9eK5Eg5vZlaoiYrb5o1ZSs3QTwG7XLwvjOG
	 qr2ZJ+5YGPKFJ5CoObtvSyFnDO7zUbqPOgQuNK5YtDhZqyOysOsSuCiZu1RXzW6e98
	 N/C+3I+SfMy39sUykDQd5F5AURf2FskNYG8lOkGnFmvOBCRp71fK15GTc6HICJl25A
	 AQwCcJ9VGR/XZW+zZ5rqk9hC1+VrtcJDiL5sVgZyGrX5hxLpulsNEvqJuHgQzSPhfp
	 LMG5ulrygL63Q==
Message-ID: <afbebeed-42cf-465d-89ce-3000fe361f11@kernel.org>
Date: Thu, 1 Oct 2026 13:41:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] selftests/mm: open pagemap and kpageflags once for
 check_huge()
To: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 "Liam R . Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260929131521.153079-1-kirill@shutemov.name>
 <20260929131521.153079-2-kirill@shutemov.name>
 <C1FB2DE7-D93D-4CE0-A6D1-624CC0B9C8F8@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <C1FB2DE7-D93D-4CE0-A6D1-624CC0B9C8F8@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9AB3180007
X-Stat-Signature: 4o6c7rbgaed3fct3n5ywroisgarce6cz
X-Rspam-User: 
X-HE-Tag: 1790854872-495101
X-HE-Meta: U2FsdGVkX1/eT46R+YhkzISA0JFShwJdyWVPr+jM3bqepyS5N/but3K44cP6Qz0iavWZjnKy9w81sgc2ek8M0GGfgSi19xUquDuM3SRxgvYBdqIZPfEJQtYhCvw4b8ko/DVIbnj5gzHvkSBCsmv8/LX/Fmk8cjV3726kxVEEuAPwI/TuOgSLPz7s4CX1bLBZ+NWocZwJi2s5hELRrjSW9JdXv9Af8jupKQbrWJY7/F5C8NkSSjINm46Lltbfh8TJa6g+BeYOrzZY652cc/riPz7/kqzwuxAY47nJypicViq2z2b8b3BOSuYyvJXvkB4Y8ZvzyOPyXh8gs2T5FTNMXbJ6p4NZvNqoXalgmgOg7XoRMQ41T8Hlp0O8CZhNIUmAruThD2kxceNbd5gDaqNMdce9NHTp0uRODOVyBNnFhsz/vcqHSJ79yAWT3UfVl53sYYRc9XjcrUBdgLcDD0zCPE0Bs5P8LNWUmakbZhlVschYhrOBJLglWcAMxSdoUlYDtpnsLm/gtfSqvsmEKraFZL8TKmGf8+B0oOO7bx7BkK/0cXrB54l9MobMZD6doXmkhcL0o+3xN1vPtY8zRE4EFhu5cUdblUQLNFrNJJDSXuX0TPzST9SRpMfLRc/MFTngHjR00St4BANaPfWbH1l/HrFdXUYQLqKE+XW1Gw85ELpxtHpGZaRPRIClerbW2xFFv5BIETlGjneJvhXcg+Uw9cesMPWsF480Bl1hfDke3pYxhuDEq6PPEwQi4IUrWCZKqLDBlc55etjTlCtiUW49XEb6860a4nonhlw5yYX/z76P4L4sTop0W+FIa/DICx6x48BGE59KGy0PdJf0tqN6oRROIevrTpou/iCS22JBre2acUvq4DFDbn8QlL99c297IgsHAz3JzlqHGO7fNAbe1McwursMTOILpZt7kgKh6SvBTt6g9+y9bgXIPHrf6/flAyE45KgLZUPxXU6yRXb
 Ki8ZgsEb
 Xl6GVSZd9D29bzK85JNJpWqQkVlgxnKfxexZADpyg6qHQYLXN4XVCcvvTbmyn6zbogR+YSP+OuDC8SdLPTy19R1dLl4lB4vxapGTjLY0bbuN31ZV+KfHAdg6zn+ouI614cEA56Vd0UYk8E/HN158r5YDJoqG3vnYAnv0jiTdIsdvQihkhh+93UYoF9efu70jUBhzCa3s1o/UBsfTTwO6LA07fh5ylYRa8LZfdAwzeWnbSYaxtHbjHHssufzcMvBBTXMuHC4+175aJE0wqTJkKSrzhsR9tndZgJ2LHWmC1ifBrdCRW8AIbH7qa1aguLAxdd0n5KQKEZNj/zD7F2OHyAsuHP2KtwrmDp+bnJRuSYDey0Y0O4B9K7mutBiZ8uBgnqihGJUH955hwFPmk2DGkr6u53cRASPCp2f2k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 17:28, Zi Yan wrote:
> On 29 Sep 2026, at 9:15, Kiryl Shutsemau wrote:
> 
>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>
>> check_huge_anon() and check_huge_file() open /proc/self/pagemap and
>> /proc/kpageflags on every call and read the PMD size from sysfs on top.
>> The khugepaged test calls them hundreds of times.
>>
>> Open both once and keep the descriptors.  A pagemap descriptor is tied
>> to the mm of the process that opened it, and the khugepaged fork() cases
>> call check_huge() from the child, so reopen it when getpid() changes.
>>
>> Cache the PMD size in read_pmd_pagesize() as well.
> 
> This part might be overlapping with Yeoreum’s another series[1].
> 
> [1] https://lore.kernel.org/all/20260921-fix_hpage_macro-v4-2-cdea4fc6ce3f@arm.com/

Yes, let's provide feedback there instead.

-- 
Cheers,

David

