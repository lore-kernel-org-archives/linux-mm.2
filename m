Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA01DCED25D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010166B0011; Tue, 18 Nov 2025 04:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29546B00A6; Tue, 18 Nov 2025 04:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FB66B00AE; Tue, 18 Nov 2025 04:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D20716B0011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:42:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E34E12E775
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:42:09 +0000 (UTC)
X-FDA: 84123236778.02.8519BB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F6E7180005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:42:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaA+AYng;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763458927; a=rsa-sha256;
	cv=none;
	b=20Ccyw609k2W3L1ZVuzS4tY42e//dlLaaw/h/nqlRON8qMrSMz8TGXHgmzaKlTp+c7jYxw
	j2Yww8sZtjfSZM7BkwCAGXTZAQawypgD+47lxWRagUSrZG4Y2sUVq4jD1HXb4aiXX693BT
	O9SJfQ7SIbbRLr8IzIVlIAqHTgxAw78=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaA+AYng;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfg+8kcZHJ9ZF+ehR/HwoefWpvBNcLDRLi3IodxhRCY=;
	b=VlmcO+v/eAzYAtLBmuw7Evc7kLoQLD4bG3hjX2mOmLxDWwvTsRpA2G08EPmTEOFmd3yu05
	c5SnLdniodzRhVXwAQPVE+0Mvr+FsLg/0+q6JQpU8BdmJwnL/4sXVao9KbLingu6ay3lZm
	pzr2NhBWd19YAuUO4Ov0F2KApMZj83g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8228940379;
	Tue, 18 Nov 2025 09:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBD7C2BCB4;
	Tue, 18 Nov 2025 09:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763458926;
	bh=XyKAd9WucePUC1o/tFCBrcsIQcxe4TH5h4/fR4SzmsI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iaA+AYnggzz+CZqxx89XQw14uDM8FmexD7ADNtIFpDkZZsEo8nGRYo1cnrQQ6eT4G
	 6B0l0HscHNkDSEOQ7srUciuf8b7DO3nhjEtpWM9zOdZBJcgyj/np08+4nMGYKmsg6k
	 HeRCsMeqoyn8imUAqYCsfCT3ZlbBGtAw55n4Y2QnqgdlU1x3Z/W+qIYX6nPP9LLmSF
	 SmyYM8rXRXIVacLyyHPRQzhDot45uG9g7Fq5Smro3mnkgviJ4PHq+rYuHEY+2ub9W9
	 zf/HNuqQadKct23H1zSUg+W3WuZJVmNLO8KKQ1rWolFkgWgn6/S8tWonQonFbCtQFt
	 5WJUgDQrtjMKA==
Message-ID: <ea294b1d-7698-4f67-abd5-a7b9b67db6bb@kernel.org>
Date: Tue, 18 Nov 2025 10:41:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC mm v6] mm: introduce a new page type for page pool in page
 type
To: Byungchul Park <byungchul@sk.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au,
 dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
References: <20251117052041.52143-1-byungchul@sk.com>
 <f25a95a4-5371-40bd-8cc8-d5f7ede9a6ac@kernel.org>
 <e470c73a-9867-4387-9a9a-a63cd3b2654f@kernel.org>
 <20251118010735.GA73807@system.software.com>
 <20251118011831.GA7184@system.software.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20251118011831.GA7184@system.software.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F6E7180005
X-Stat-Signature: zrw78gr3yrnw5gzxkfymbywsg4zzzrxu
X-HE-Tag: 1763458927-913400
X-HE-Meta: U2FsdGVkX1+8ffl7KoSk4XuQ/jZwzAFL6f6ntH42HuB1n3x60o2rVh3Yk6z+yShLV9u0K44txChuPyG1YA3kaQuNLKLfeJ4CnRScMKi2bFnP8+NEotxKWEU0R0mg8Qhjj4RRHCtgHVl+oMutlfYCcQrQagUWFFhJz8EcSiDAB/lZB0m4mX0knSljns0Yx970ONRi8O89JDE6HKzAqmOvRUGZs809R4I3dwZEEoQllIlcXrKVlD8jF+sCT5ByKC4LtN2NXKqjQ74S4B7alMy3h3y99fjU26stxTsO1f4Q/W9DeucJcVKSP97mW+UVqCBj0y+NWS7TP0tQLrpCC+CYaWTHJjFIMsnOhnPlovPEHljcqtrMIgeRAYMIH8ovNuaErT7bHRAssURMjibf+W3/fW6AErAfO2ZdnheDDom5TE2gi+NdxQticME4VXLNwJ97hbYH7J0OGnHvjpZOQWkt76K4w7mCOzrxCmFPp86vYcHeaS30U/IVoUmyEPNe2yUUvBWsg3A/qH8InkYdaapTHj0/WpV5Ep0QDQWeX0DcmaisCw6c58es9hGJrpORT7l843PASUbmKzr0WpZE8ioL7aATZW9m9esQ+LL1GDxCeG5VDDjaYCksC4/X1wnpSxcmFLwJgGsiGCUwizIQYhW+EX7ZFVuyfgsQA9DwLRAPDwvfGe3DEeLgIM6s753vF9R1AM9SBEPV3buxCAxO0yVY5ALdD03iVHmg8xz44wzU+C30ZrHiU6hc8y5hVYY5GAKevMFM48lsmkuQN+r6iNl50tM/o/JCtLmRPN1xFpkgkUrBO7t+ebd8217SvlW/7WYlh1+jTS8WPqUgjHLrwe1EsMM6G/5coFEdAyZOQfrYQhZu2VgbGXQyGTbdSNZgIXiIadtbXQc512oD689Sp6D7VzTI5h/QpcQ7PKjatKTHhqr/moEHltVbUj9TJ4WDQnpeiBHe8TeN/xePiuIHzLZ
 qn+BK/nS
 6LBDUClgImW+UyEGEZTqoaiMoOBXEbwjWfTA//5sgblfKKLKI/1r6t0HRSSa553G7nYKABUH73IXYBYfyKnCW9pZ+sffgnmFOCvgCShD2aprhy9KaOOuy036maNzkrXEDtdVsFRBKTLpV9W3nMgkv0tpWJUsyqJuIR8A5KBNkSeVOZDqhgD3Ro3BSoc7UEjkrIk7xu+AFPNlBCsFs8WMkGY8akAvqBPlxwNWgfry2bUZL0RI+zNfT14uaxoDxZ9d2F6wLNhta3THylK3XDC9isKxN1GkYzLlsgYsuGxEGvfAe4SR6g0OnyZDpL+7r0ExNGurJXQWG/DrU+WmgpB+X4rjKTRQrHvDEQOtteOQGYff5v8zcXEfOME9dPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>




On 18/11/2025 02.18, Byungchul Park wrote:
> On Tue, Nov 18, 2025 at 10:07:35AM +0900, Byungchul Park wrote:
>> On Mon, Nov 17, 2025 at 05:47:05PM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 17.11.25 17:02, Jesper Dangaard Brouer wrote:
>>>>
>>>> On 17/11/2025 06.20, Byungchul Park wrote:
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index 600d9e981c23..01dd14123065 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -1041,7 +1041,6 @@ static inline bool page_expected_state(struct page *page,
>>>>>     #ifdef CONFIG_MEMCG
>>>>>                       page->memcg_data |
>>>>>     #endif
>>>>> -                    page_pool_page_is_pp(page) |
>>>>>                       (page->flags.f & check_flags)))
>>>>>               return false;
>>>>>
>>>>> @@ -1068,8 +1067,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>>>>>       if (unlikely(page->memcg_data))
>>>>>               bad_reason = "page still charged to cgroup";
>>>>>     #endif
>>>>> -    if (unlikely(page_pool_page_is_pp(page)))
>>>>> -            bad_reason = "page_pool leak";
>>>>>       return bad_reason;
>>>>>     }
>>>>
>>>> This code have helped us catch leaks in the past.
>>>> When this happens the result is that the page is marked as a bad page.
>>>>
>>>>>
>>>>> @@ -1378,9 +1375,12 @@ __always_inline bool free_pages_prepare(struct page *page,
>>>>>               mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>>>>               folio->mapping = NULL;
>>>>>       }
>>>>> -    if (unlikely(page_has_type(page)))
>>>>> +    if (unlikely(page_has_type(page))) {
>>>>> +            /* networking expects to clear its page type before releasing */
>>>>> +            WARN_ON_ONCE(PageNetpp(page));
>>>>>               /* Reset the page_type (which overlays _mapcount) */
>>>>>               page->page_type = UINT_MAX;
>>>>> +    }
>>>>>
>>>>>       if (is_check_pages_enabled()) {
>>>>>               if (free_page_is_bad(page))
>>>>
>>>> What happens to the page? ... when it gets marked with:
>>>>      page->page_type = UINT_MAX
>>>>
>>>> Will it get freed and allowed to be used by others?
>>>> - if so it can result in other hard-to-catch bugs
>>>
>>> Yes, just like most other use-after-free from any other subsystem in the
>>> kernel :)
>>>
>>> The expectation is that such BUGs are found early during testing
>>> (triggering a WARN) such that they can be fixed early.
>>>
>>> But we could also report a bad page here and just stop (return false).

I agree, that we want to catch these bugs early by triggering a WARN.
The bad_page() call also triggers dump_stack() and have a burst limiter,
which I like.  We are running with CONFIG_DEBUG_VM=y in production (as
the measured overhead was minimal) to monitor these kind of leaks.

For the case with page_pool, we *could* recover more gracefully, by
returning the page to the page_pool (page->pp) instance.  But I'm
reluctant to taking this path, as that puts less pressure on fixing the
leak as we "recovered", as this becomes are warning and not a bug.
Opinions are welcomed, should we recover or do bad_page() ?


>>
>> I think the WARN_ON_ONCE() makes the problematic situation detectable.
>> However, if we should prevent the page from being used on the detection,
>> sure, I can update the patch.
> 
> I will respin with the following diff folded on the top.

LGTM

> 	Byungchul
> ---
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 01dd14123065..5ae55a5d7b5d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1377,7 +1377,10 @@ __always_inline bool free_pages_prepare(struct page *page,
>   	}
>   	if (unlikely(page_has_type(page))) {
>   		/* networking expects to clear its page type before releasing */
> -		WARN_ON_ONCE(PageNetpp(page));
> +		if (unlikely(PageNetpp(page))) {
> +			bad_page(page, "page_pool leak");
> +			return false;
> +		}
>   		/* Reset the page_type (which overlays _mapcount) */
>   		page->page_type = UINT_MAX;
>   	}
> 
>>
>> Thanks,
>> 	Byungchul
>>
>>>
>>> --
>>> Cheers
>>>
>>> David

--Jesper

