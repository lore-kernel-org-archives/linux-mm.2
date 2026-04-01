Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE101D3514C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5207F6B0088; Wed,  1 Apr 2026 03:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7C06B0089; Wed,  1 Apr 2026 03:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E206B008A; Wed,  1 Apr 2026 03:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33F8F6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:26:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEAA6C6415
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:26:57 +0000 (UTC)
X-FDA: 84609155274.30.7F22CE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E6EC3180005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:26:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pdGgDMz4;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775028415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o21u9/KbdhceZZAcKY5d7H1O3Rw58ks1MPWR5PdPOXA=;
	b=DTVR2e2uvoZdd9OC6fcT7gdhPHQrbI1GPdJZwoyLLkJXMEOKdJSuZyJz/ylUmOmg98AHfS
	P6Vr4C2fpoDXeC2OgT11lCOuAHY6xF89p0X/ooHzB/a70W5WDKHgcQ8vDyb5ijN5YkxaR/
	E4QFL/CxpJ1zwrMcqiWDNsYFJ/WJ/i4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775028415; a=rsa-sha256;
	cv=none;
	b=Hjmzr5m1mnhc76/24b1stZ1F7l+brvjcGkJ23YmA1YnjlUvWJOaRJ09F3VoO/74DCkhStX
	H/jbUd8E/L+ten7cFQsZukk3antvegzJdOCnBmmoZB/UY1UC3by5B4JkPyYYEzr7zck4px
	DSchNu9a0mEqKpLwv8hrXroNvavLeT4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pdGgDMz4;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54B8060121;
	Wed,  1 Apr 2026 07:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A819BC2BCB3;
	Wed,  1 Apr 2026 07:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775028415;
	bh=3xugjtesEoQFFK/+Xjt+8y5k/Xf/gAKd2TSFqS2LoR0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pdGgDMz4oG/mPDsdGB+N7QG1bNxoA+PzqFeKz96MY03+OvdGw/B1mcTKmfgJVZH5l
	 bcMFHI71fqNM9C1/khFUvJUNpkm2L8i4tvM9qUbpIBSQhmOWH0hNPj+YUxDFbkRgDk
	 eOdk4kmAuXyfNudqQ6nU6HcG/DjRnX5A9Iki5ugIHc+FiQUP+4YO4Blow/zsWoVbxa
	 4YrqlnXT4kxa4xR4At9czWXd8pHLQvFYBKFOeIgy0QBBg3CllaREXtLL+HoARUmR+3
	 TrNrAUoZhuJZWZ/sKdsIQS24RG13JXekmscqVHIlttilHTwWgRYEK70QCADPZ1ZiY1
	 ceAjtWW8VuMUw==
Message-ID: <1f8d0cd2-c990-4597-bf47-5a8217acc464@kernel.org>
Date: Wed, 1 Apr 2026 09:26:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
 <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
 <1742503A-F912-4AB6-AAF6-6CDB06829024@linux.dev>
 <9fddd112-e304-4ce1-b3f0-a4b133fcb281@kernel.org>
 <EAD7BE29-7136-4A20-9CF8-1198EFB8C87D@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <EAD7BE29-7136-4A20-9CF8-1198EFB8C87D@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6EC3180005
X-Stat-Signature: efsfucxgzyjwb61nxxwgysqciihfr9x7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775028415-700671
X-HE-Meta: U2FsdGVkX19XNo8cYDOPUFn3OueIptFdaavv8ekJNerXTTrCmBBCEnEhWZlAZOiDHETxavRANfg6F8KsQB+gAwWFHQZQqCgqR+1WsMrXBvrY81MMYX4F/k7w+5PTfYFP5c9bYqx0xzqziXIgIQ4M/e91ov5Jr/UKrfplBUFiehZRP+UbLV83lX0gyMuLcpqIdQ2tLfx8sZT2WL51+wBZe2xRzr4LzDPuqYzOBLLcFoAqm385CsPXsFayqCnQg0CkQ59/15XcxO+OypxSeiTJwSY8XrTvvp5FNetC+9EMfjWTdA8GioBQLLHlLnIpPI9lnfb9z/Tp73Zl7l3OviyAVMVdXAKNxmClCsKaIcEMbWlj7RLm5JmTCs5seLJjERgg5NJfr3WpmhEhbpQ9g1QOrpwFMTaPxiV1HYnfMjnwx3BPRHCvCIfbWM95gC30KrSoqoccCAOKurTbIomtdNcJVGNWgg2liKdUylHOfaBG9We94NA5TU09u04X45mDt77ZQfLcgH1mZYc2Rmi1rTkl1szswRL20MqpgMqJ9/AycvoiSqy4Ga2fR1TRcdCqL3LQK2KQSKmlClx1+Q0yE43k5+xuoup3G0+bU6wy9xfxlAZezGSeesbHq0PWLBmalYmDiOjnV5LCeIhdWQ9yF6T6w+nESgT06EUgh9ZqosKzwdNsFz8OdtB3UN3YHa+ajE58ZQd6Q/TnDGx9Yf7h73zax0cfXRfvlyC1KOhfEVBCpu7LC9rdkoCaiWtkKCThbeX2Kg/CgcQTYFbsy988mwS2Do3S0Qmpz2C6G1dnWlM5hj44TU+bbCh0Jsrke+VE3Z1JOD16eL9tnK3pwOirHWUeXrgEVYYfqOBIjOvQd7jhLJGE6vMX8tGM7ZS7bUFXFEaEE/PnQU1V71AJhIvtRZRx7iLkguyMlYLahzGQLD2j5KOEC4FaOlAs4EGXTKgcir+dwWnoCRxiGV13bFV05tx
 DOUbHYY9
 e7eMBPot8kAzTP1UwZiCuw6H2HvyJbw4d+Jk1M+mOfMs6GIGORzCf5Y7UuDtaSv8gCObDkpsnYLXIlliiDYjfhX2xCLjBrQUzstpzNJWyYjEDJP4qt+0c8IZ+aNvf4MGteAabqlSfzp3HcEcymNpYw/t6q9BbmJaxzxSmSLDgBs1H+jZSWE8+yq1+d7qFxxhlH9JS+Ibkkc8wpJ9K5cb+HTX7UWJzM3be51/NE8RjOrkL3VlMn+gvuB7wVFbHDEhO5zIMsJyy4uXcLOmZou9kBEFyXUxV+UptbiiMeuy0lZidhnJQeONn3ErEL5A/mrjBsNowojAKRZrMozC+5p/zpDUwCRTAvQS1Pqus
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 09:23, Muchun Song wrote:
> 
> 
>> On Apr 1, 2026, at 15:08, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 4/1/26 06:01, Muchun Song wrote:
>>>
>>>
>>>
>>> Sorry, I misread it earlier — I thought it was about the memory
>>> section size, but it's actually about the memmap size. Let me respond
>>> again to your question. On the powerpc architecture, when PFN_SECTION_SHIFT
>>> is 6 and PAGE_SHIFT is 18, it does seem that the memmap of a memory
>>> section would be smaller than a single page.
>>
>> Right, and I am saying we don't care about that and do not support it.
>>
>> For example, most vmemmap code I am aware of relies on a single section
>> covering full pages.
>>
>> So I don't think this patch here adds any value, except faking that we
>> might be supporting something we don't?
> 
> Got it.
> 
> My original motivation was simply that when I read this part of the code,
> the comment felt a bit off to me, so I just fixed it casually. But if it
> ends up creating the impression that "we might be supporting something
> we don't," as you said, then I'm fine with dropping this patch.

Can you rework your patch to only simplify the comment, and to clarify
that we always expect a single section to cover full pages?

-- 
Cheers,

David

