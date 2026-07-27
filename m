Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B16C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5196B008C; Mon, 27 Jul 2026 10:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ACF26B0095; Mon, 27 Jul 2026 10:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4C56B0098; Mon, 27 Jul 2026 10:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7146B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:00:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A3BE1C0EFF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:00:57 +0000 (UTC)
X-FDA: 85034717754.15.14F400D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 949488000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:00:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXlwlqO8;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785160855;
	b=NoSe89qSloVds2lkcCgWwLOy+BLck/Jeb0RiVcmWxXBNbCdseCaiL1KlyHoH9D0eIPFjRc
	FBiuINUgkCN49tgPymrOvNwZixT0h9KTxUVYr+87BQEPkLfHEajAXEnf6xUA4t/4h/PkbJ
	VR8S/27SN5RgpcTnzJcZQEIKKJTM1Wk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXlwlqO8;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785160855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmb5Zs5dduJDrtlxe57uuXVtZpXFpGWAvCyTon6MMec=;
	b=DWg/31iEw6qqqeqhfzYvf6MXT7YwE0h4NCWn7ffYox+wI6Bod2BzTpBi0SdAhdAPds6QkB
	0jSkSce4jO18Qi/V7uUzdN7E40tCnkqdw8gQwiGDZQ9fUn0NshL/R5awxf1AFeUOtZCRkM
	uWcQI+uLANJKqiRY4qn0WB8416+Fm5U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B582E42B12;
	Mon, 27 Jul 2026 14:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BF91F000E9;
	Mon, 27 Jul 2026 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785160854;
	bh=lmb5Zs5dduJDrtlxe57uuXVtZpXFpGWAvCyTon6MMec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dXlwlqO8maZ4DioC4+2PtYtSY1//2rnBFPeH7B/UR5Omz3QnHHkOlYN5aB6FQNinU
	 poqcCIRX/psKYaBzbWExTodniHSH+3QqNhjFWGhpuxLJLayjhYgILje62evMe/yHGW
	 G/jruQmSo/3bDB0BSlAXew05gYebHtRPBEsZV29wuvDc2swHPs0OPDTfnZ4O37ZXjZ
	 +K1Y8uYPFOL9YPmDS+DSrbWlUlwpqseWKArePCk79173YWaE44lZ8UgPFWKwjDXwXa
	 zohtoufz9ELBuPvzZn7iSYadpnUFu9LbtWI86s+fbwBnIEXdTc6fgcxkZeOI4sR4q3
	 pFhD19pvnhc+w==
Message-ID: <3da27fde-25dc-4cb8-8e05-74cd26fc2f7c@kernel.org>
Date: Mon, 27 Jul 2026 16:00:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_reporting: Add page_reporting_delay_ms sysctl
To: Pratyush Mallick <pratmal@google.com>, SJ Park <sj@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Greg Thelen <gthelen@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org
References: <20260722211517.1898228-1-pratmal@google.com>
 <20260723000609.95657-1-sj@kernel.org>
 <CALHaPKd_Ytknjg7GFBXeQK8kXvE7DhbyX_een7k5Fti-ahxL0A@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CALHaPKd_Ytknjg7GFBXeQK8kXvE7DhbyX_een7k5Fti-ahxL0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 949488000C
X-Stat-Signature: nq1arj3yiu7d5954xjqfdni6kixypwaa
X-Rspam-User: 
X-HE-Tag: 1785160855-375259
X-HE-Meta: U2FsdGVkX19eZResOl2CU0pW4WB9bD+B9P0RYB4j0AW3FcTQLNTfT318H1WrnS+sv7KmxpM4y1L4PNMRGHfauw94FATXXTv/dT5S14Sjp2veU88yyPMPOtiB3PmrXIfjvD86uWgO+lsPAjYXZyP4Dv27pvKK9r39xlQAyG1sO6lNbByR6JS5M5SU1302kLJb7vjZRNa2yl6aEtQYVxDKaCZ5eFAnkzECvWVCehrQPpe4M9WArpA7bUiXtsapztKur/OHWSONGJzehwrtcJpKrd/OivjTxLefD82z05XXMUj3jwJx0vKi8lzQde9H2qDhjX30/SDvEEEINPPattaaw21R9LYI7J8NkFz31PT5IG9K1G85sN0z9R2aFfZfYeXDSb5zv9KE9kNXGwq9JntkdDzstigfsX+HiBcdqbr/ZXFSfOZ9zcDOSvIJBB028HCY78mUJMJ1g99a/N8U3E6TaL7kRSFbKxbS+xBhs1M/umD81G6MoLrWWcd335RVMCba315ofdMRGFXDa/auTXiQ4CVDegBd79fvqOxbtR8y1vVooox6xN2a1heVZ9UTxi72noG6NeO0bQxtyR14fP/qiWnnsp5w8RvYa+R8siGWfPiqFqT5mRY/cQSusQsJN164mOcviCg4R/GJLAgqswli5YqoSAyMBbcW70zGKgUxyaVL4G24f3O0QfRwqxamw9B/8qtTnURk76ylBTevN6PJ3CDIpI6VVOs0i3zHS3NQmQewT1N8s65szMyLfVsttQGc1BJ648hIiSq7ElIAmkiF5mnuVIl5M3m0P2ZaGiahoQK0MM8wBYqojF0JiVn2STPoLKaaz7C6dP6mBI4S2gIODfYWlqV1GG4ZO4ymoj9yyGMmXTF0bbJv3KIsT8ZGiGTYXwYGgSsh3yXUkEtV3ZLRPUeNAgmZZsp2BrFyw2QNkSwSsEkyT4Kk5ILx6nJp6m/46rgOBZuWNE2EDGvV4SU
 kAz7HIIG
 8yfRF5kwTWQfyeOoD5rJTqUJ3vm9mEbfpGDAgt7iF+XNYsoLwy1GkPhOOnEJYEJ0Xj/Vkl+tYsUXYhvxLrQg5IPnoxlJsmY/gq4GXZ96FMFLui4XsFClZa+zJaQ6A0fWvQZR88eEFlNT+3k+eK1cfegvth703i5C0vOUf0ZVHbPtYowY+AQWc9G/KV2Wmq0Ps47vgDa5TDwGLrrqDTCu84K3OK4mh8Ia/NmaWsPI0jDUXhkI69LNITNUo2qwQmfIWepVyK41As8NOUXpm9AiNkNJwkBOxnKdKSd393/H1T1i1vD30Ef0FI8wCnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/26 20:17, Pratyush Mallick wrote:
>> Why don't you make the lengths of the line and the section title same?
> Will fix the RST underline length.
> 
>> So it is milliseconds. Why don't you add the unit to the name, like
>> page_reporting_delay_ms?
> Agreed, I'll rename the sysctl to page_reporting_delay_ms.
> Also I think it would better to make this a module param to be consistent
> with page_reporting_order.
> 
>> Also, coule you elaborate why there is 10 seconds maximum limit? What's the
>> problem of having no limit, and why 10 seconds is the reasonable one?
> I don't have a strong justification for where the maximum limit should be set.
> The value is unsigned int, so it's bounded at UINT_MAX ms (~49.7 days)
> So at worst the worker just schedules that far out and reporting
> is effectively paused for that window.
> I'll drop this in V3.

As long as we don't trigger a report as part of the delay change in this patch
set, I'm fine without a MAX.

-- 
Cheers,

David

