Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42BCACCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B808E000E; Mon, 20 Oct 2025 15:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4E98E0002; Mon, 20 Oct 2025 15:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1D88E000E; Mon, 20 Oct 2025 15:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB8A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:46:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3638414013B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:46:32 +0000 (UTC)
X-FDA: 84019524624.07.EB2C675
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9B9D2A0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:46:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bg9nwUsU;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760989589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nsYu3sxWKw35kclt34jyQDkTPvyZmJq+s80Nd/F8dw=;
	b=A2ccgKaZ4gI1XXr9CDhalerkicwvWQ7PhIDhrw/NfgZwUjw+yzXf4CJaoTrYEtQhIFtzlx
	ms6/soH56KCzp0+cYpDtGg40Oj3Fx0D0YRMHBx7+31p7xgOdXuUdzGUrrkcZGbuTgWGMx6
	IMHQGhOtb/VNCIOARNm0XE/g2mpkKfk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bg9nwUsU;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760989589; a=rsa-sha256;
	cv=none;
	b=EQqjEkVxp5+GOHw+Q/e026L0qXnICVYJQs9vQINp4STWWz6RuGjXMnVgPzw1YzqxNUi4xN
	eP21EfiNEtmeXNmNbNaKD2PgEKIsrneewRp0i87kXmoUG5daMKazsafxNoOu34ae4l+Q33
	jbcsfeU3kImS9bLeE7arBX8ANRYK1eM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760989588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/nsYu3sxWKw35kclt34jyQDkTPvyZmJq+s80Nd/F8dw=;
	b=bg9nwUsU/5GSDwBW4k5zBqrxydMqhib5EHQR/f0KDl1Th4Dcq/YLIsMsHmysD+bLj6LqYi
	iIRwmnRoMN8HuKl/ZIl+3PsfiTLmRKParP1qe+G57HA8q9yi/aijIgPJhB4zepfXICoqRp
	4jNe4RwBdTQ0aYRJj2yGtOwcT3yd4Kk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-LP2Jb3L8MrGnHrnR-Dl4jg-1; Mon, 20 Oct 2025 15:46:25 -0400
X-MC-Unique: LP2Jb3L8MrGnHrnR-Dl4jg-1
X-Mimecast-MFC-AGG-ID: LP2Jb3L8MrGnHrnR-Dl4jg_1760989584
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso37048345e9.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760989584; x=1761594384;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/nsYu3sxWKw35kclt34jyQDkTPvyZmJq+s80Nd/F8dw=;
        b=sPqdsbtkvAwsdBFC9YLhXmolgubBy3Yt+jwvrw1Sma7e63zJASuvGqmOjD89yzQCSf
         RPXFE2rog/4VHNxTleXXeqPZvtdZmFvJLBdMvjtaH7X3zztZln6w4uuxVilEeLlsScoo
         zNjKN/Csb1yjcyH1+TpEC1zFVnvvbjT9QHGJ/wDjtl3nyoAy+vHQuUi04DaW6jEw9TIH
         jEM+3n3rdRmiatSWL3G3F25nQFAhc3SLzypfZhNhZp3emRrOtHOGcL78KgAOb+Y8ouVA
         GeB8pDfDIkhYhVJFd1veWO8bDU6KhnLwsTi4ak7EFGMoqri+Kbz75QVkDrVaK37TXztw
         TNlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDJt4cqgYnCqQvog6qkSy8gLfnfNUoPhtCR9TGQb1UDY0UW+xXB+fYWWozMvFalvLD3KU8VoIE0A==@kvack.org
X-Gm-Message-State: AOJu0Ywavxrhzm4rzuvgpRdbAoynAWkp2xgMio4i/Q7knMuC4rEemYgI
	gYJykFy+11yZ1LQruFWtLKYc1LPlTf7cCWhDs7JVD2DMOcJJqf5Vw6um21Lv/gUMTOpZ5jvZoRP
	wP8FFXdSjeziasRIFgWpZG6gV5Obo0m7j9M4YekIVpx8xybGWgfvs
X-Gm-Gg: ASbGnctaYRYsGrBZWwywjDq/wiqzW2bSx53j4OsJDT6kdnQDmK152uO0JtG4ZO6h3hl
	5H1hUBIOLgMCWSgXs4ugRu0vN+qDgy/iU0Qv1UslFo64y5rzFzVqP/PCYDBY32Ku5WIITosIq5L
	nI0bq5ZTuBaegF2hm3xxZ3Ls/PYbsmSJ8RWCuCCCNoh653c0yg9L1aJs9iFMUjCM6t3QpgzUDfk
	/EJsewaa+ORtc6pA9RssTjKIkuUfwhlstqWHmroCKYVg1cVuKgUm4n8RPmLOrKgI8iQ5M9hxwfT
	sOfmOumrys8WNLvocPcDJr5G1IYkpbn0SeAIj5KhoP7VC4GAFMx62YgRDQPR+sx3Uz87pmxDZkU
	vpnJbanb2/XiVJiEZcgVtNnjpoLqKvYVLvH4CR1DjjiIvNhbuQMdxnRxtE6KyYs8eIZ+nSJZVgB
	jxfr2SYcJQD1Rr1687RpTPfLMtC6Y=
X-Received: by 2002:a05:600d:62b1:b0:46f:b43a:aef4 with SMTP id 5b1f17b1804b1-471b5341411mr35825875e9.38.1760989584108;
        Mon, 20 Oct 2025 12:46:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG41dKtmg/MhiuPABusf+rU2NYthrO92PlcqVEvTG4DvE2u37hJDq3TNOCRz6ssCTvqSlBdHA==
X-Received: by 2002:a05:600d:62b1:b0:46f:b43a:aef4 with SMTP id 5b1f17b1804b1-471b5341411mr35825745e9.38.1760989583729;
        Mon, 20 Oct 2025 12:46:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715257d972sm163976505e9.1.2025.10.20.12.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 12:46:23 -0700 (PDT)
Message-ID: <0d92a675-ab24-4b1c-be71-956f09a9e973@redhat.com>
Date: Mon, 20 Oct 2025 21:46:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
To: Gregory Price <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
 <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
 <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
 <272c425a-b191-4eef-af6e-2bca1db7a940@redhat.com>
 <aPaQNYsN_YPDOwQG@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aPaQNYsN_YPDOwQG@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OhpeZ_Pv0Is_-7Nv7H9HrGMSE76DatHfYiGvJr7PKHg_1760989584
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uifma3p6tpguqiman7ixp98nuyta13d6
X-Rspamd-Queue-Id: 9B9D2A0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760989589-894893
X-HE-Meta: U2FsdGVkX1++k/0CQJCsy9LS0EdTQIIkkbcoNHh7XWJVqvZUFeHGvNS5CwvMo2g3hRQPd2jqbEQprqWyVyuIreenqHlhwf3LDDB+aNXTiRKV4pDkXSkE7pV56EF0mqiFJpuXKmS28G+OwqbNSzvprGrbXDdsgWVy3GXaz6rHa/z9Ch1RelCtPI+xaKeq2iigyJgnG58sjqBGb0oWRzdcgLbINPG3kkWyd7mimd87Bktz9CLC30d34g59CgEf8iOxBHcW55spN3PVk9WLkwE3mYEZkzsLk70JSCQ+1n/1N8/pbv/eQl0G3czCddGBBdeYo9euP1BX5i+x02c40rPOkxn7r8rTaIqCxEk4f3nThlmhbiD9rCDN1fiiME70AqhygNqIwnZuP7vOeKJbqPLTOvRmG2ZzqxK0J2HIXyt51BG3LlXepMjv6qJuLa6HDwNGudDgOn8ECYCdQfEMJ/ig/tk0rZKR2R6OXijvqtl9hxx84lnCLjToWkF+r5B/tGXd2CIKDrQBl4YtAyb9qu+Fry8ZGUUjpYF9suKou0vEXAnJcnG0cmPV1THwLPv8NSNvlDjFuvNlk8Q6D8qVgFWfaWP7Fvp8MPkYw/67pF4CvHl/7+WtJAlp4MVI4CsP1VoD4y4+BnUucscCK/kwPC0ogMYrnn+qHYt6tUIulpmBfqPi7FZ8IZCT2i0ekec2qUuLUyL3E68Fo5kjUEclYLh0d/aeuttFXL+mGaNueKR1NpaKxBa4OBfVqByx4DliSetaTnG0B+CBz2mu7AuTg9w8bpzWhorbJEuK9GkRNn9sek1bUkXzUgQ9/n8XxW5nFI4+9uwM4TnSvCSz2Ljk54bFk9AZd6LoY2JsMkn/fJViPGqs+Wn7A7MeLyxNd8Ww2XTfGgAqWVwAh7mbtCfwIe2hNEssB1TlsZ/78QsnG+6y8m7s9VmXESEc+sS38JHvZ2tYn2jklJtyRZ7im3rnu1o
 P/otyEF4
 mNCvsppapfFoN3UFlYvpveOx1V4dcfTjiFmeWFoyWXVFY/uWrBscBf9HuRL0FC+fIpaTO4WyNFIrmPrnVcUYuDSajl6caKA4s5S+doorE4GTrsBNUCcx2LLSPzqFlS2tw0HU1uZ147nzn6GALRdQSFsTuc6zG6yaGx2uDxUJTjly0iHBgpmXgDaL/JfWloPV3BxvqwzYzWnlinSemygRjr2NzpWtMPSWonrF0KhIUsM5z4pf79ovsb9ftdVWI1GLnS1allNpZ0A1LROC0Z6qpYM6C3iLPr+vxn5kt6y6OgjJIGqRrdokRXPsJRbMZA19USIjcIxkQRt9aYnimPHBlFmzVIxidvFejCGugdHTz1UONv9b9Vi1gq2adMpxkb41XftVLUJhClQKeaYB8xOZFq25GjA0lCiSjUu+ZuXc7zEpwxL0b/DY1wal9rFDp6OrHPXNP4SeN6ADf5aqXa7KhIwgt38+xOUqIEH+8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 21:40, Gregory Price wrote:
> On Mon, Oct 20, 2025 at 09:18:36PM +0200, David Hildenbrand wrote:
>>>
>>> Basically, what is the right way of checking a folio order without lock?
>>> Should we have a standardized helper function for that?
>>
>> As raised, snapshot_page() tries to stabilize the folio best it can.
> 
> is snapshot_page() even worth it if we're already racing on flag checks?

I think it tries to handle what compound_order() cannot easily handle, 
as it will retry in case it detects an obvious race.

> 
> i.e. there's already a race condition between
> 
> 	pfn_range_valid_contig(range) -> compaction(range)

Can you elaborate how compaction comes into play here? I'm missing the 
interaction.

pfn_range_valid_contig() should be only called by alloc_contig_pages() 
and not out of compaction context?

> 
> on some bogus value the worst that happens is either compaction gets
> called when it can't compact, or compaction doesn't get called when it
> could compact - either way, compaction still handles it if called.
> 
> We may just skip some blocks (which is still better than now).
> 
> --
> 
> on compound_order - from mm.h:
> 
> /*
>   * compound_order() can be called without holding a reference, which means
>   * that niceties like page_folio() don't work.  These callers should be
>   * prepared to handle wild return values.  For example, PG_head may be
>   * set before the order is initialised, or this may be a tail page.
>   * See compaction.c for some good examples.
>   */
> 
> Seems like the correct interface given the scenario. I'll poke around.

Yes, avoiding folios altogether is even better. As documented, it can 
result in crazy values due to races that must be handled (like 
compaction, yes).

-- 
Cheers

David / dhildenb


