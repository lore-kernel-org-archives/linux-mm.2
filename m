Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7A6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DD06B00B1; Mon, 13 Jul 2026 12:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9176B00B3; Mon, 13 Jul 2026 12:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD1D6B00B4; Mon, 13 Jul 2026 12:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 169276B00B1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:15:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFF5D1C874C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:15:22 +0000 (UTC)
X-FDA: 84984253284.17.535125A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC5DEA0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:15:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kzGlsZ39;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783959321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=np7zQ9bu2/JDKdPyXVQqTGzye3HRFWjrv+s0jMcq6z8=;
	b=2B0PeB5DRv/i9qRgt5WqYsAPTuPyAg+tSjS+fmkIhW0Al5VQ8oD5YzbK5TPRTsfapyGVyL
	U+2M7uprvPb9phwMSRjOAB2dbtvZnKL/YDE6vANxgo+XTu6fFxaKMFTf+EINyHA4Jqgxoj
	nNgauH+XNijJeXbBy5TY0tSiAOu2jbY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kzGlsZ39;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783959321;
	b=SpsYRX9FZMxIG6owzzysjC0ZVeNfsX7e4Touw796eTi4R/095FMoEYPwcra0JbU+ww8XV4
	uGDymcAZkbmlkcHL46fcokmL0PqyEzbw6x40XONQUMe4Y6jIDUaulGvrGwVV0huHhie0tL
	dESknn74ubZXOCxRaDKbGWs7G35XwWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B687404BE;
	Mon, 13 Jul 2026 16:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC231F00A3A;
	Mon, 13 Jul 2026 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783959319;
	bh=np7zQ9bu2/JDKdPyXVQqTGzye3HRFWjrv+s0jMcq6z8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kzGlsZ39c3B2NKOwq8BPMqEwUB0Bq++llL3jpdorCWTDURtyiigecMD2B9RtgQzFB
	 6Ox8knw7gQYvkKRgC3yC758gkwHEt/SYQrzmAKc6/K2dbVDB9NsW/EdXSEDEPEH/mU
	 NcnqWtHaYxxa4MiwClbaIL3aFqYKNCyjLXAoDva7tBmzztvldUbmNH5wAU//3pYVNy
	 a2NqaFPAHoOprp1LMsAA8etSEIbHEUJSTYFlyxapYd4DW+eOeU8FDGgpT3z7LNBynJ
	 DDGdg1QtL08wMw5B9iwTywEiYChEkHGWAQLJyZcMCh81g0F5Hr7/89K7xEENP76+3j
	 lQcdDu1tCabhw==
Message-ID: <fcee1dbe-1109-44c8-a3dc-8aebc5569c73@kernel.org>
Date: Mon, 13 Jul 2026 18:15:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 3/4] lib/alloc_tag: introduce
 mem_alloc_profiling_permanently_disabled()
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>,
 "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org>
 <CAJuCfpG=Dk6PRWy-8wR4j0UreSsa=fdiFWvBYpOkSZE0zV2Z4A@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <CAJuCfpG=Dk6PRWy-8wR4j0UreSsa=fdiFWvBYpOkSZE0zV2Z4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC5DEA0004
X-Stat-Signature: anq4rooyprq7mha3psiu7hc4mzmpjsrf
X-Rspam-User: 
X-HE-Tag: 1783959320-819693
X-HE-Meta: U2FsdGVkX1+2AJhcstMeZ9RDqOo6aXW2AlP+3YUyE4t8QV4GAVTlfUEopaP/hW/7yHtaIq0vOj0YYwhtVYdX8i8GAQpBouknXyxGq/1BZJluCg8IpchPk6LvSdz48XUYW9/0pnR0v49pxpAVWlBOyhbzQsa5AGYWpRs8YfwcOznPOfsEJ27WSzaE4iGJpq9oVnuZTBjr19vefpwWx9HRhRE8foUz1hwF/QucUGrE+DYcCx/8mFLpVy+QyKpdt6h2WZa8H+LZ90vZ7zNI52oInC9/zPkJlRlLQXzvB/kGvCSdQIvk8tEC+jFm9yJUpU44XaBHPhHv59bATkWL1QdLXX69EMb15VraUxBp8gQPICl7gP9RcY9wiFKESgXzhpr3jsw9iPKJpvd67Jo9RID6MahA/qS9FrZ+flOiW9Gr+N3Tuq19ThyzZ4NY8CTCZ+4AliNfZG0ikyy6YJUgGC3pr2hWvcV06Ncnm53hAJOx0S53MoTr18L3ddOmPyKPecJhx46o+Ng2/L/zJXRANHcUybecB8RH7mV9CUSE3YX0HVyTQJamUOtwAbw4KNXmQWY462dsavtLri3bqWU3ZmN2sbxdq3UtZ6gkdco08/dl/OGqMkijXJJiNTucR0j4eK0j8efrwkWAvNzUXMXGdOKteg/MFsTZC4+HTIL3HgafJ4mulk09Uqq+yZ60/pC+/FX+CRPTtYK8corDCSMdKAGyMYMWH00H1BQOWen+hmd223PnRB8PgS8Jo8XjTkVhCqGkLuHNBujM365n9f5CbRQNAzMOPDCt+vNeKBEWeTrISryuM42KcGrY2x/EStiPFxkr/3UWDpZCOOWMvo7PNGbz6ln0/AtRc7yJa5E3z2SrIo1isQCZRcxYsz+xFOQMeOsdoX2Z2bpOnJH3xDRNBOHXJjWDeydg1DAjtr550f5fu+yKnc10e0spO5BthzwPNsLBXX34yx682yW/E+3OUqg
 e7eIzEER
 KDEHqRLiZD6cfhpTZck/Xqcr5TOY2ubq1D8bVy8AMCnYhO7crpijyuAWZ9aN0IkkFkfAa3HPuT6hw7wEnuoQD18PVaGruUbAa3PBrmVyeLxdd8xgcQZb+7280aaTdk03hdJnAZsDTK8Q9ffsCkwOV9xdKq5GITmz9zvd2h9LvLATzZuaHML1Ml6Qf6VszMgcBRYifcIzWdeKpjhI4fTM/5J4p7zd2Gj7fKSJtA2LiYGJaAN+R9bjK2uiykB/NRLOKz1FXN6f39MEeRqhNQjdfurd9j38RBk/alKOqVr/y/bz+VOEEKoSVQOzyn1qpQh3FCBwFnzKelv/Ey0L64yQFzrd0zx9ih0Q78bzWCuzuZYgWvRNzD4fBBe+s/XpF9hwa1/d4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 17:43, Suren Baghdasaryan wrote:
> On Mon, Jul 13, 2026 at 7:29 AM Harry Yoo (Oracle) <harry@kernel.org> wrote:
>>
>> mem_alloc_profiling_enabled() tells whether memalloc profiling is
>> currently enabled. However, even when this function returns false,
>> it can be enabled later.
>>
>> However, this is not enough. Some optimizations can be applied only when
>> memalloc profiling is permanently disabled. For example, to skip the
>> creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling must
>> be set to "never", "0" w/ debugging on, or have been shutdown so that
>> it can no longer be enabled.
>>
>> Introduce mem_alloc_profiling_permanently_disabled() for this purpose.
> 
> nit: I would call it mem_alloc_profiling_supported() but this name would do.

I wouldn't like that name, because _supported to me sounds like those
CONFIG_ARCH_SUPPORTS... things and not something that was just disabled.
I suggested mem_alloc_profiling_unavailable(), but it's not ideal either,
naming is hard.

>>
>> Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Acked-by: Suren Baghdasaryan <surenb@google.com>
> 
>> ---
>>  include/linux/alloc_tag.h | 3 +++
>>  lib/alloc_tag.c           | 9 +++++++++
>>  2 files changed, 12 insertions(+)
>>
>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>> index 068ba2e77c5d..6ed9f82e639f 100644
>> --- a/include/linux/alloc_tag.h
>> +++ b/include/linux/alloc_tag.h
>> @@ -134,6 +134,8 @@ static inline bool mem_alloc_profiling_enabled(void)
>>                                    &mem_alloc_profiling_key);
>>  }
>>
>> +bool mem_alloc_profiling_permanently_disabled(void);
>> +
>>  static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
>>  {
>>         struct alloc_tag_counters v = { 0, 0 };
>> @@ -239,6 +241,7 @@ static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
>>
>>  #define DEFINE_ALLOC_TAG(_alloc_tag)
>>  static inline bool mem_alloc_profiling_enabled(void) { return false; }
>> +static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
>>  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
>>                                  size_t bytes) {}
>>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>> index d9be1cf5187d..e5b218176c5a 100644
>> --- a/lib/alloc_tag.c
>> +++ b/lib/alloc_tag.c
>> @@ -26,6 +26,15 @@ static bool mem_profiling_support = true;
>>  static bool mem_profiling_support;
>>  #endif
>>
>> +/*
>> + * Memory allocation profiling is permanently disabled and cannot be enabled.
>> + * Must be called after setup_early_mem_profiling().
>> + */
>> +bool mem_alloc_profiling_permanently_disabled(void)
>> +{
>> +       return !mem_profiling_support;
>> +}
>> +
>>  static struct codetag_type *alloc_tag_cttype;
>>
>>  #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
>>
>> --
>> 2.53.0
>>


