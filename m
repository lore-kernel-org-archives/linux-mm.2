Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1020CC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234B86B00AF; Mon,  3 Aug 2026 09:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BF26B00B1; Mon,  3 Aug 2026 09:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1221C6B00B2; Mon,  3 Aug 2026 09:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF4166B00AF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:14:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DB1BC066E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:39:26 +0000 (UTC)
X-FDA: 85059460332.19.6641761
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id AA6A640008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:39:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTW3o3um;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785749964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7JjU4ooA85a6HMKOqAz8GampirGAdEOAJEDh++/oLA=;
	b=o3lq1rXWMCXgtD4lOIOYbZs0bFESdfvJ0oupyk0wL9JtJCAQ1ubIs3d/MP27/9tg/k1gqr
	cGJvJBXVY0ZpQJPYUm/GkEYwF2mFIbn9b+Tx6zN0X0e/YdMntHkzqhpv0CoygSxZq0f0/l
	xlaP2EoS2w71r70Vw+TK30jxBzs7lu8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTW3o3um;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785749964;
	b=IPYudes3OJOOdYWe9k3TgUm1OpNuqXNkD35sCu+pI6Bsj3qUmZQVxuEKv+ujWO22Qc/+Fv
	O15PxFrc8Rm3d/BxyZU5jQXG2dRdRRmLKtpjutpwgupCnB/dnybhYPeA0drgT+zMKeQc87
	nHg+CTZ6CyumnRR9lbRKHjg26oCVdbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C45DE41578;
	Mon,  3 Aug 2026 09:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3531F000E9;
	Mon,  3 Aug 2026 09:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749963;
	bh=G7JjU4ooA85a6HMKOqAz8GampirGAdEOAJEDh++/oLA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CTW3o3umAUW5i3xZFQFPZWNNC+eznu5VcXbR94t32vqQzdG4pXucsis/KnVxBUJ7a
	 CsDnu+Lq6WltnFb8vy1kfVbBUXJ5n7U8GZQMQB/n9XpCY2lL1Zf7XgWsDndR3wMhXx
	 C1AONjihG1SRW9D2z/z1RhG2l08NkV1HFHiQZGS6cPs7r17Kz/aVAvgU3C5Ons8KM3
	 Q8d1+IG2D6FzlYMdUsdFT/6rsLpY/b31cpAfYuCyKsMc4N+SSkaG/8jGFmX3f7A3g+
	 S7iFOaGC70kOFkj35OoE8rECH6orIFX3kMbdfXoT59PhrLhL+Rov5qFIN8uPjxsWuG
	 V6DnzmasuYYpg==
Message-ID: <fec1be38-406d-4656-95eb-048729afec40@kernel.org>
Date: Mon, 3 Aug 2026 11:39:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
To: Gregory Price <gourry@gourry.net>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
 <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA6A640008
X-Stat-Signature: ixkhsqxurkdc944i685om3smn5ik6xju
X-HE-Tag: 1785749964-588967
X-HE-Meta: U2FsdGVkX18ll+xL/eoFqCpd2DLFv98uhIjJsWxGySa1nYns2vIN+RdR6rHyuPb0jkqw5KO45fZ4RdHxb5YMqkktI0J6KTqnwd3zKOxQJYZ4hi2pkC5GrmTgw67JPv+L33Qe6WwQiDXVs23ykE9b1PnUgBmHsSNd2Ee964R9VCxKoyUVcR7sJozhAQT5CUBzitZ5gguK7PyCluW33V5HxRar4R+O+yZEvvBZjR7ePJ3uW9g5Qs2a0LeHyhLRVBY4mvJ5EEU1q7zm0paAON+rRLJM4bm18kqXAVsujEgmZRBBnupIAy6wrnqoMTiD029CgxAbQdv5wvPT4QURO0ObdjA7WVPGhehs+koZY7YRug9u55IRV98bLYFQyNCO/qSQvkI/Vqs+U8n13e1VqVDJ4f15UKhOs8M2qYpy+yPfrf3OrOROh9prNmQPTo6uiYAdQP89J96D3S6F83kExeAoGcEdTRWRtq0DQJjbVDDno2fX+mQj3fFHkGCqdDLMw0NcKjks1Rs1Yr9reMI7SL4WQfAqrleGlXkS1iKyTdzPskIs4/sTZHgKD32Fa5VmIPML8QrxBjWZjA7yd/FR43kP/2SbChWMhUeNCl5R5095msB2sAUf5YsrjXbzg2ItiXKSnrff/ni7QzkxC9GesT+isSrLEfjQVLRpEBmbjzEDTOHREPTBxgunytjnlwLGpkj2p7ZIfi7S+K+IZP3u4x3cDDBNh72a42G+wzlLswSLBNN8ZxerQJsymtKl3WXqp/qn6u/4m4NqetE+tJzj07g/N6JuNK7EIMjDnoYIs3qYX2hVT707dEg5S0+Skoq4zmVy5wUYXIfDK4/CyOaIHxn5SwWI03QZfsweutpl9QVuE2saUNxFAA27PcRAlswyXAqMjnfEhNfxJnEyrEOkRkinot4lJjW/5ftEVIygXJlX2yTTHD0MjBmNg28X6LYkOMPeervfZ/IF+tsA8OShrB+
 4B36JYiA
 ONyzWLZ+2uzgkbjGWJ9w6Er4dmFcxGhet10zJ6s7dC8DsEodfrR84hd2xkU119iA3Wyh70KDhRMovLBpCY+qi6/pqhi522AqSvJmjboQNy3Sf6itXnBVUCjqCCewhLa15heh8JFRTw/lue0uC55YYtedcPJ+9Xvzg5UjCNNqSluhY8U9vpKVEpzYVfEMZCIFlFDOF7OtpBpllaN2n+e21l6PcyoZ6vlix9KZ838zcBX/Liy4vJnflSgDB1K1D2zTGxEhkY+Tm5QmsraZShT13wxLuWH9uVFxsOmuZ0D8Pze3nX3IlIYSJPNa3dXMpmla3sSIM/e9UxSV+RQzWwNwBuzc7XFPG9xFWS+rXEylfDTh1KclEBKMOiHc85xp606seD3FE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 08:32, Gregory Price wrote:
> On Wed, Jul 29, 2026 at 05:48:39PM +0100, Lorenzo Stoakes (ARM) wrote:
>> This is potentially useful debugging information and matches the existing
>> page offset provided.
>>
>> Use the raw __linear_anon_page_index() function so as to always output this
>> value regardless of whether the mapping is file-backed or not.
>>
> 
> Begs the question whether we should mark the value based on whether
> it is file backed or not, but i suppose you can gleen that from the
> other printed values (anon_mem, mapping, vm_ops, etc).

You mean something anon_pgoff_t or what did you have in mind?

-- 
Cheers,

David

