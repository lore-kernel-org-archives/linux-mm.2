Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CB4CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70016B00CD; Tue, 13 Oct 2026 11:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47AE6B00CE; Tue, 13 Oct 2026 11:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DE26B00CF; Tue, 13 Oct 2026 11:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A46506B00CD
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:18:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3668B160CFA
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:18:50 +0000 (UTC)
X-FDA: 85317960420.06.C40FD1F
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8480C4000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:18:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HxCEfUCK;
	spf=pass (imf11.hostedemail.com: domain of 31kvOagkKCAUyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=31kvOagkKCAUyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFCGbaDlX/AVQV6RAFUOj0q1sLZPldXZf8616wSFK2M=;
	b=ENa+uRag6GnHoeFdtSvnGShDzbNt7WqofJ7eyrXYrU0leK24YIbxBnIC62dXZyfsfQxu33
	OOouJis17tyEAxpUBI5nYu0PWctTtbfSFFfCQ+tL/uV1QATMNBS81H7ihKVdsAan8VLaL2
	eNmkKwIDeJd7iJtfxQadlddu8EKw5mc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HxCEfUCK;
	spf=pass (imf11.hostedemail.com: domain of 31kvOagkKCAUyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=31kvOagkKCAUyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904728;
	b=pwEbW3c/8VJ+NI2M/GbtAUURHJxGRlCJn//3XIK68X12qo2g6geMi5zyHv1WwssMScnaVB
	zqwdNvQXh5lvn5q7dsuJL1c9jzjiHFYXJ863f2lpbr3HF/f4wAZyfqVXYx3lnJasfNvPXw
	BL+Hrz3DQ9bRJodnWLkEB6D43SOM+gc=
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6acb986a43bso3653372a12.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791904727; x=1792509527; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WFCGbaDlX/AVQV6RAFUOj0q1sLZPldXZf8616wSFK2M=;
        b=HxCEfUCKepHIUZz+q1ZVOSLC0Blf3rHHhWDIqSmy5mHtmdayHzXsKks7urjQg9uhEc
         8+CaQ/Uu6EboGeJA9LtFvupTjiLTpRwjvbE9MjePxXblOozUVauAJrnUQ2f31Ji28x9M
         AljNj8s9w+wtHkTQil5hHACn7k7sIlHIY3yFX/f70efYHwORhvvJ4Kz6uww1jxv93nDF
         yAIWsMCVOvmFX2ikAWHjypGP79PsEuNKp2avYQPmoBIcYsRyZEpVnBFsV+2NDyFjtSCk
         DwIS07iU8c3+y7/j6cQUEP/tMP4bv9Ua333q42X+I7bWqjiN/6UN6dHF0hMwpwwwz02m
         nShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791904727; x=1792509527;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WFCGbaDlX/AVQV6RAFUOj0q1sLZPldXZf8616wSFK2M=;
        b=teXAhHGMOcEht5yvfhh4Q1q0iEHrqRY56Ma+ccsg3EY9L2nDt7g/RSG84d/+vAI8Av
         ivW194Nv9p7P1eLf3vnonf7zUVk4SeYitN1net2LgRSFExqK7siV3HKJxejB+Jewp+8n
         +ew2D6Y7XG8wJOUA6IZ0kq8ygfN6tVYNHMlbUgI78IOueMtIxeDN6hD5l24h3kZ8xU3m
         MLjZZJzXuK6J5AmE2OgVQCsS+Qocz4ilL3EE+Zsl5T21WVHRIQxcO3uLYcpXRqwb1VLt
         YeUm0SoiPyhEqvzvWZkA84bhvajEs84q/6Fk1ad4+zon0dUPROlfc9EtYjcTPD/WXZRw
         jetQ==
X-Forwarded-Encrypted: i=1; AKwUvByJ0liXBzm1LtgE/oCJb8y+SBnLzYWBJdvPVi0iukTfDFbuBL0C/5n77oG9ITGe05NQU34AsDADxQ==@kvack.org
X-Gm-Message-State: AFq9FYJwETFxhsM2T3JmW3XV1ZBKhlYZKa3a6JnCnuyWWOiM8vkUQ/lD
	9qqm/M/JdzaV2ZqdyI7AEW/IA6VdeqZP0TjoSGDl4ViHYd2r9WRtaH2MRefhleTB3RPe5WBM/mE
	d3o+w43j5lFkKihHpSQ==
X-Received: from edwl2.prod.google.com ([2002:a05:6402:1242:b0:6b1:a8d5:117d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1ed4:b0:6b1:ba86:5f55 with SMTP id 4fb4d7f45d1cf-6b1ba86636dmr5678473a12.35.1791904726451;
 Tue, 13 Oct 2026 08:18:46 -0700 (PDT)
Date: Tue, 13 Oct 2026 15:18:45 +0000
In-Reply-To: <as4EcgiBH5jjww42@kernel.org>
Mime-Version: 1.0
References: <20261008190828.3221718-1-tarunsahu@google.com> <as4EcgiBH5jjww42@kernel.org>
Message-ID: <9huzecdt633e.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 1/2] memblock: drop for_each_memblock_type() and open
 code its users
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8480C4000B
X-Rspam-User: 
X-Stat-Signature: 3xpbmthkspyug7imiz3nejdtafca3qkn
X-HE-Tag: 1791904728-48012
X-HE-Meta: U2FsdGVkX195UsvT1UgdxkcRXXTuVNjM2OYvpuPyd7VzVpDSxl0EZbExSuZ/nZwI9UPHio6m8aenAQo9hPNV/2EdjfhX4fIAFKZxSbVK6Z7QZu8oHcKDnJkvqjl1iZeNCGaNCD85er457RtRCwcfbEhJj1g/ebjjq2dUxCB9fgwBu8RRJ5/58pPx+yyOiSCTuyW3VeQ5tqZjpb3QLk29qN0Yh+6R6gymh8HybPq3misyWv1lfCFx/jT9RxnefgCeC8AxFdqi8k3Lq3dncQ0a1RcSAPgKFJ9HK1b1M/E5J9xj0Yk2dGdqIhPZIfnb+obh0b2agO5TAzrByHvILvr0l2FvP/GPB47uzpwo8yPBwhG1SN/0FZgoJV1HIc68lUlZgUnkPOP8qmLB45N6ghjnfRJD7oKoKJalnnXXaz0e5vjh3vVCwgZFKhGalxQH2QCQcSiJPXS+uLH2NFHQlKO7J/HFZwVpPbcJHgxKKN8dFewSCGbXJ0ADwUmImMrInY++PS6x0V6CIWw8yVIojPmCoZsgIcQok9sTGLCX94yhOE7AObiHlaSaAsq3zkAb+ZHS8sFIfCtxYG51f55gBeZlqnOUmZAIxkkn4yPAMaRrtwUsWbo+/tYHayxyLD3iYgAICNKh0VzyH8HnCBvD+aAL9RXYurVtuqyqvphNBkHLmj31X+WQamlqtJI8KqX3FAB9jfT88203nqsdp9IXTAGSOCgyhj9bKjReWxXDehj5pTTJXazG/a7l2t/Ao/RpexyusguI8Ihz0XBmCYnR9ihaIeCBttv37QozC4f/zad4GlKm8/VCGS0NWrVfsa1u2wE4+6IiLeJhZJvRLL6DnP//zjszTtbj7AapqmFKZLrFN1vdLBQlJvyORmm00jnHTxbpZkvgSgluE9FuVykycKdRcrIxikvJGy7uSyLri74VQ1n3lOe6eM1yxmv9UR19KhCVfSAuDG01UHcsYYchW0/
 9zoq9+ha
 lwrrVabEwKoc3o3YwZ/I5t9uSZb3j7bMCBgjTlCqcMUJoSPW9wlWA0cJMDJfJvISl9Y61MQBUOpSB+UYu8EZ5xu23ysqgS3Oe73z9AYqXnCG5XZ1hBplDhUH3Fc0/x4X6AuU87lL0FrrSy8KIeB+CzMx1tAL+tHEWgfREbNOZBZoryEHWnqkFXH0+eRUvvfSJgHOLof0uAW5MZHYRnM4kpcdz1w1MdOoSIBWpaRwZT6rwgRZG0C1IcUMITkGkxE9iTVe9PeprkBNLPgY/2ixHhnwtIxALBwco09DtGgDcW1OPH5J2nSnWIljdmJaqZyp8lhbuRzlpqD2nX/SHSxlpVxG/V9M69CTnMHA+zJCljgGGmn0MwNZoA0AVvQFH1zDaWX3aE5xLlu5vl0/P6TLayF5QvgfTrJO8R2IleRL7uXxIRrbvId2/f8BA+8vmc+tWRqrS/1uZ59aZAih+yzFVVOCom7ydvjsOsuYEmXIGIezm4sN384FFU/vNefR7fHVOutwyAyV4xzBBF2Ie/CawAardph60TJ1h3f/pxqCTov6zy8lS8yVx8nUWerHyhtotVCWERt1OKq3RY7ikDKgZCUt73IHaNEPHcNYVRd+jL+/rdGtcvwpzw+7Bo8dQtJGKu7h7Hbypm1qWR3RT0UjZREcX5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> Hi Tarun,
>
> Please for the next time add the cover-letter when sending more than one
> patch.

Thanks Mike for piking up the patches.

Sure, I will take care of adding the cover-letter.

You had some nit change suggestion, Let me know if you want
me send v5 or it is alright.

~Tarun


>
> On Thu, Oct 08, 2026 at 07:08:27PM +0000, Tarun Sahu wrote:
>> for_each_memblock_type() always starts the iteration at index 0 and its
>> body is a trivial 'for' loop, so it hides very little. It also gets in
>> the way of iterating from an arbitrary index, which the next patch
>> needs.
>> 
>> Remove the macro and open code its three users: memblock_add_range(),
>> memblock_isolate_range() and memblock_dump(). While at it, move the
>> region pointer into the loop body scope.
>> 
>> No functional change.
>> 
>> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  mm/memblock.c | 17 ++++++-----------
>>  1 file changed, 6 insertions(+), 11 deletions(-)
>> 
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index f5aaa38cfa31..59dda7d085f3 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -155,11 +155,6 @@ struct memblock_type physmem = {
>>   */
>>  static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>>  
>> -#define for_each_memblock_type(i, memblock_type, rgn)			\
>> -	for (i = 0, rgn = &memblock_type->regions[0];			\
>> -	     i < memblock_type->cnt;					\
>> -	     i++, rgn = &memblock_type->regions[i])
>> -
>>  #define memblock_dbg(fmt, ...)						\
>>  	do {								\
>>  		if (memblock_debug)					\
>> @@ -615,7 +610,6 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>  	phys_addr_t obase = base;
>>  	phys_addr_t end = base + memblock_cap_size(base, &size);
>>  	int idx, nr_new, start_rgn = -1, end_rgn;
>> -	struct memblock_region *rgn;
>>  
>>  	if (!size)
>>  		return 0;
>> @@ -651,7 +645,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>  	base = obase;
>>  	nr_new = 0;
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for (idx = 0; idx < type->cnt; idx++) {
>> +		struct memblock_region *rgn = &type->regions[idx];
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>>  
>> @@ -815,7 +810,6 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>>  {
>>  	phys_addr_t end = base + memblock_cap_size(base, &size);
>>  	int idx;
>> -	struct memblock_region *rgn;
>>  
>>  	*start_rgn = *end_rgn = 0;
>>  
>> @@ -827,7 +821,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>>  		if (memblock_double_array(type, base, size) < 0)
>>  			return -ENOMEM;
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for (idx = 0; idx < type->cnt; idx++) {
>> +		struct memblock_region *rgn = &type->regions[idx];
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>>  
>> @@ -2194,11 +2189,11 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
>>  	phys_addr_t base, end, size;
>>  	enum memblock_flags flags;
>>  	int idx;
>> -	struct memblock_region *rgn;
>>  
>>  	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for (idx = 0; idx < type->cnt; idx++) {
>> +		struct memblock_region *rgn = &type->regions[idx];
>>  		char nid_buf[32] = "";
>>  
>>  		base = rgn->base;
>> -- 
>> 2.56.0.385.gd3acb90ef8-goog
>> 
>
> -- 
> Sincerely yours,
> Mike.

