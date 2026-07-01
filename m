Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10908C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089D66B00AC; Wed,  1 Jul 2026 04:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061DC6B00AD; Wed,  1 Jul 2026 04:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92F46B00AE; Wed,  1 Jul 2026 04:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C369C6B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:32:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D8E71A0278
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:32:52 +0000 (UTC)
X-FDA: 84939542184.20.9F48EA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8328A1C000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:32:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=POofgpPt;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782894770;
	b=wj1BE3lvd3FuPgmKW24wlnvLINj5n9ToAi+rNXQI9NqeTpuk0OyHcEKFunqNmnjnlgBUa5
	FDk4caCMaK6LVAfp78hm5EB7Bt9KCU1/bhg0KOvXlohbW6Z6uYv0M/pW7cQ+no7IPfkvkC
	PJAIRsia9HcidjAuBInu0oIKp7u66+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782894770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnNgn00HPtxGEmPVZmC3ERUTFf2RhZT1SafyHKh1YXY=;
	b=Txox2mVcsne5CHtBcJfpzfJ9qxSMHKAn3yGykvQribSLTXJi1C4Wqa8Mw0wgz18gvz/FXl
	ISalkeX19J2ZGPUSxZjePdi6WhC7fRGWwbngNEJe2SPlzJVi56u4Y7mXLcDgsyXv/y72FO
	ALqzHe28pRwUYYAHfvCcd9cTKu7Qhzc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=POofgpPt;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE15C43D15;
	Wed,  1 Jul 2026 08:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9831F000E9;
	Wed,  1 Jul 2026 08:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782894769;
	bh=qnNgn00HPtxGEmPVZmC3ERUTFf2RhZT1SafyHKh1YXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=POofgpPt2nwgcX5HuD4IxNyW9cOA3TuB2pq2AICIA3gIKE/TRguRBoSlwo69Wi2VK
	 DkFCow35wbmk1trpPJyJJ777stS8E+BCkDI089kcftpnHCtD0/SPGFj6I7+ME8JZSW
	 A7Yd5uCa5icpRjBVOUlUBKKRu80RLgewO8fxLDtRixro6vUqkk+sySkyBnppi8e05X
	 91e5sM8lla7yifNTAPqyi6/k+EY4jEQmsrYyYPvAYSzmpXYT2NmD9zQFnBfDXyZVC7
	 /G78J1U9+6KkDkiV9r6F/0eN3yOOVnZY4OK20rmeZ02pS/+ZNUbGY8grzY2lFLJtaJ
	 cFycaW0GmqZog==
Message-ID: <e0ae6be7-4e45-4c4a-9663-a87fb260564a@kernel.org>
Date: Wed, 1 Jul 2026 10:32:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/16] mm: remove the __GFP_NO_OBJ_EXT flag
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-16-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-16-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 17h6pprdnstm3gj1466eq9tmis9p34sg
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8328A1C000A
X-HE-Tag: 1782894770-546979
X-HE-Meta: U2FsdGVkX1+B7iA91fcBCEpRgupq95gL1kQXqmmpwzrcEzS9e3bDF2PjjNhedtFcPLf7zdt+m71HdIbg+DBudW0aRQw8jo9Z3hHsrzOOO5LcaVGwPcwIcNGxoqC8lYK41PjL8UK3la9LIyFhrdcKZHhx4EZeijZFn/8CGP1mzscj/XUeCr+LRKCXkL7Q+T+l+6KN/jpNaeTU3DVChiNg/aeUIpdD/SOpHxeE1DYWkwfLKIYJGMCDxHEcQTynZa0e59ZPD1/IjNaOfID1rhVxSyXxB866fNSnMiDbMhLFIYqj1aOCNsFSBuyYBsBkVAuMrDYHu0cmfh+3RJDHDg414tL684mrGU5OXrXYWnWGwiWuon4HOwNeJ2SIDCsks0qthPfpqjKN6cAaWrDQPIbfyD36f+obwodKXXC/V/NUXydja7zbpRzAoH0XANfUF7sqNONDUezad79pkH9pJl8EXbrRaLElISrpZz22HKc67PDcnT5S49zfdJBATccie8RE74yHI/mKZ9auTOpzM0OjhF3wYHBVLNarnhJz+iqEnikc1ILIgMjOSgSwnCqyZ331ONKMrvjlYwORj9Wdq1sQJoVYv9JR1hYM7MiAD5L47QjoItzLq7PYvvVnVl6KH+ZPdRKVWzVLvPHwR0cgN4bSu88VwRR0D5X1fGqhPEso9OMU73H8CxmBcl5FMkd/Ar8eUOyyiRuzOOWt8RlXPyV3JyNTnUuahWSUAyDohsTDfbTPV6tNe/o7XCek2Zubx0y9+oADmga0LBZAznxo+0TpFC2JcOEgs4fWScANMui5hh415kYNM2XpqQjIiSzi3CKZXgw/y3OP/86vwtYsEzmarJ2oDEuxpSkep/khuT3Igo/LOhtydpp1SMe1B6Zvc3pstQh7fZVmAqpQnqjwbNk7OLUKE94OWprLoJyYRhgg8maEZ7eHRfmwFezomMbTKpj9VskemOiyL4DQgUqYvND
 V92ZE/kf
 xD8ZrFYuFlc1fC6Dss60vBDFIQmHU8PF6LeQZcvPbV9FojHcgM8vKG8MFR74beClDkoF/tfncALTTl7O2+KrvdssGc4T8vMj05/lkX2EOzWeiqxV9lWThviqRFd4CEpRb2rNP2PR0uLZyA0x0YUxaM6kej0eCaXUvI72nih5ixHbYZAAhXmWOLwW06AcVoKzuyRh71soE+u0AvQvd69N79/WAurOTYaLFYSxAlY2hj5yQj9O9K3RnOlA4ZsM+O2pcCctfpzZtWFRbcgg8Lc6X4WYgeUl2NMNygbEoYDc0GJB4nVA1NwYcpEUcE1ylsolh6r6h/8y6LU2nf4ajmLbzy9yxXgl8rGdvt5Ts6t5gM3gbuHL2BUHKbye0wIU7PEDs8VfCwz+kpU+CAEPrG0kOnVXAc/Os5tZT7VYhhYnLZI1a1/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:12, Brendan Jackman wrote:
> All users of the flag are converted to SLAB_ALLOC_NO_RECURSE or
> ALLOC_NO_CODETAG (from __GFP_NO_CODETAG which reused the NO_OBJ_EXT bit).
> Free up the flag bit.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

For a correct process, there should be also a matching From:

Thanks!
Vlastimil

> [Rebased onto __GFP_NO_CODETAG removal]
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  tools/include/linux/gfp_types.h | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/tools/include/linux/gfp_types.h b/tools/include/linux/gfp_types.h
> index 6c75df30a281d..a93b8bd200b76 100644
> --- a/tools/include/linux/gfp_types.h
> +++ b/tools/include/linux/gfp_types.h
> @@ -55,7 +55,6 @@ enum {
>  #ifdef CONFIG_LOCKDEP
>  	___GFP_NOLOCKDEP_BIT,
>  #endif
> -	___GFP_NO_OBJ_EXT_BIT,
>  	___GFP_LAST_BIT
>  };
>  
> @@ -96,7 +95,6 @@ enum {
>  #else
>  #define ___GFP_NOLOCKDEP	0
>  #endif
> -#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
>  
>  /*
>   * Physical address zone modifiers (see linux/mmzone.h - low four bits)
> @@ -137,17 +135,12 @@ enum {
>   * node with no fallbacks or placement policy enforcements.
>   *
>   * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
> - *
> - * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
> - * mark_obj_codetag_empty() should be called upon freeing for objects allocated
> - * with this flag to indicate that their NULL tags are expected and normal.
>   */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
>  #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
>  #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
>  #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
>  #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
> -#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
>  
>  /**
>   * DOC: Watermark modifiers
> 


