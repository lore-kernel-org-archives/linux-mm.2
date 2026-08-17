Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB09C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 05:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3DE6B0912; Mon, 17 Aug 2026 01:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94816B0913; Mon, 17 Aug 2026 01:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983CA6B0914; Mon, 17 Aug 2026 01:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5447B6B0912
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:36:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0C43A30F8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:36:54 +0000 (UTC)
X-FDA: 85109652348.13.8B085D6
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5EACB140004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:36:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U00io4qO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786945012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+s3H8mr90Eukwp2wYsn810qf/3D2Vg4I1reXNA6dRs=;
	b=NQFJzBp277JPr4qAn1jhaWlModtiVsk4vsLsWoFCLEcWkJkxZ5gn3CC1KgcIEccKP2RqhG
	T0kVfrTkNIYK1CRFKvt18YDLCojja/5FJuPTBgPm8c+LJHNk2/0F8wjjIptgoGRUa3B55+
	UKILpYFAJE/GhLVC7F0MIqVdTCctZuk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U00io4qO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786945012;
	b=wsAMdZGu6gBBXDYlRewvQ2L7+BAzhTEgWDhrsNgeTw7XdcFlVpDDsm7Qj7UzNefmWdKFOD
	T8C93LgZqNYar87tkZaGM1GvJLvPsN6PF/yQfnxE8KKoLRP4TTKZxEFQEoIT5DSFlf+JX1
	imQl/EYL+kNq2TtxBDbITP+IyRNmxIE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oKScFs2RQMYKqGOulhCgcCph0kZhAPotI/0u7YmT3ak=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786945010; v=1; x=1787549810;
 b=U00io4qO6hbgn2sCvdfr5PoEY/wZpCNEHr3KyGps5Tzlo183BbnoLYzH3mk1p+zrgWs7GqK4
 ELV7fsSVrIi0adtw2vjZEkUCTZ/B22OhK45W3Eopegc6QXbQ97wIuVKYlviA6063Hcn234ZU9At
 L+CHtjGJmt8CczorXyfnXQ+o=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.42.12.33] (116.128.244.169)
	by smtp.migadu.com with ESMTPS id 3b453216fad28c3f;
	Mon, 17 Aug 2026 05:36:50 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <32ce8837-f023-4906-9b9d-68442d52199d@linux.dev>
Date: Mon, 17 Aug 2026 13:37:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] module: move codetag section placement decision
 to layout_sections()
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260813093421.135230-1-hao.ge@linux.dev>
 <20260813093421.135230-3-hao.ge@linux.dev>
 <CAJuCfpHBWFZh5yHHK01CT1i-z=OP74kzGobfYskkqKgBBLx_EQ@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHBWFZh5yHHK01CT1i-z=OP74kzGobfYskkqKgBBLx_EQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EACB140004
X-Stat-Signature: yui916k7cenbfud4nw4pmtukagxu3ugk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786945012-699938
X-HE-Meta: U2FsdGVkX19qrUzY/t9X/UV5G9WG7mV2UmBYXf/zdE3GXCKzUTsskV3sMfsV2OcCU/eiJWaOPzf0GiMK4gcHTlDYjduTLL18aKQAlJIxxcRsMwl1n0518KEeOYX3dqg3kyl2T5t28cc4PqZLaItthpHu9p7NFc5xAxZrjNAWE2BNy9sciCR2rfnDMn/psC2pNfVdzt3NviEJTU6wy1tjVIsQX39YFHIuO6YIhNiUKbIpe1w8bTVoQiVWvNSNOTzpGMboEped+M+HbcL+/n2DtHGBNZXCfYuU6k3Xi+IhfkJZfMrlo9FqgmXc9O1uoxUL0EFpg7qrtnaTxrHygX0fvi3NTMX/J7A+vgiR9yVyD0U2iRbWdeqowqeRj7SNQd1aDrct6b4R+mewHtWOd70jlADiRHoHyoEotN5UOcAmNqLTyUtY2BpcGAhO1rqteIB1oPWHopCX34lGtjXGYvzP2JSnVZRNsKxBkUmDQWVre8SWDU3RfRPxvsExSo0urIHu1FPWSAoVCpvRYRjLL0fN2na7zimOUxAkUR7zvhs8hyIo0UKXkluuz+dUq/TIiR7rZL0swlFuJBZAxO0X3is848RblZCfhQVfn81s94bXNj2vl6O/zAyAKctXIsLo0wO+ixTVrp9K4vWLnnUmkqk7hlHGNvTZDV724zZwVgX9nCXoPqjG8iCbTyH2WVARF4gnyf2yos/IONHpDWlzgKJ/SUu9pevPn/KAB49nsFmg6YYHEd4tfhoysMXIv5JIGZ9Sf/5a/E5Thrw4CJVR5eaR80zj7wRNCrjL7jNU52WV8/tb+L4qsuRn/CX7Q58HE9+KtOegqKDCMIYgrKAQRuMJmuB6Fgb1CWevWQw+FQ+pfGAECXr0umPhPbtwpjtwYv9jsPgepORaL9eFf3ElAor9eZkVeTKshCBRmeRrMCwLE7dzICTedEC5vxlclGF5K6Veia3IlGetxSTRfWHwFjg
 qpGiP5Uo
 Bw7vuBhYoCrpx/FadlKla+bMbn1YoWySW5kYVz/5yCsZSxyP1RFGER6IdZ9Etl5ZIUQJtVdPrgziJe+IjiWHnYMue0lWNfKpAgiS15AOB//Sw+TWB8U4MLHKs+HX2dT/8jQSi4BEq5ma6BBYpL0atDAKdbIDhkjGEw2a7UbxstRlpEnKWMJo8UzlwGEO4kB6L2ZGzqxG2fQqMtxdaeBEFXDAz1U1aqywHYnBi/S3y9Grvw2p9xUm2NUPfjgT2Gw+ygU+PeNPuQ/kG+CJqvlBwTlN3o8qCXMCQBEmmP01OztPcmQxKPggHr398y3hlw78Ns69G9rQjZccfq6dr7Zm4NESpUiDbMAk7CJi8DKi2amG+L3LbALtDRuSc7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren

Thanks for your review.

On 2026/8/15 14:21, Suren Baghdasaryan wrote:
> On Thu, Aug 13, 2026 at 2:34 AM Hao Ge <hao.ge@linux.dev> wrote:
>> codetag_needs_module_section() is called twice per codetag section, once
>> in layout_sections() and once in move_module(), and both depend on
>> mem_profiling_support, which changes without a lock. If profiling is
>> disabled between the two calls, layout excludes the section (offset 0)
>> while move copies it as normal memory to offset 0:
>>
>>   CPU0 (insmod A)                    CPU1 (insmod B)
>>   ----------------                   ----------------
>>   layout_sections()
>>     needs_section_mem() == true
>>     sh_entsize: type, offset = 0
>>                                      reserve_module_tags() overflows
>>                                        shutdown_mem_profiling()
>>                                        mem_profiling_support = false
>>   move_module()
>>     needs_section_mem() == false
>>     offset = sh_entsize & MASK = 0
>>     memcpy(mod->mem[type].base + 0, ...)
>>        -> overwrites the first section there
>>
>> Record the decision in layout_sections() in sh_entsize using a
>> MOD_MEM_CODETAG type, and have move_module() use that instead of asking
>> again.
>>
>> reserve_module_tags() returns -EAGAIN if profiling was disabled after
>> layout, so the loader retries and places the section as normal memory.
>>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  include/linux/module.h | 11 +++++++++++
>>  kernel/module/main.c   | 17 ++++++-----------
>>  mm/alloc_tag.c         |  8 ++++++++
>>  3 files changed, 25 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 7566815fabbe..a02016528e1d 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -328,6 +328,17 @@ enum mod_mem_type {
>>         MOD_INVALID = -1,
>>  };
>>
>> +/*
>> + * If CONFIG_CODE_TAGGING is on, modules get a .codetag section.
>> + * codetag_needs_module_section() says where it goes: the usual
>> + * mod->mem[], or off to the codetag region.
>> + *
>> + * Mark the codetag-region ones with MOD_MEM_NUM_TYPES.
>> + * It's just past the real types, so it doesn't index into mod->mem[]
>> + * and for_each_mod_mem_type() skips it.
>> + */
>> +#define MOD_MEM_CODETAG        MOD_MEM_NUM_TYPES
> Ok, it feels a bit hacky but it's probably the simplest way to mark
> codetag regions.
> 

Yeah, it's not the prettiest — that's part of why I sent this series
as an RFC. Actually, I was wondering whether we could turn this into a
generic marker which means the section does not live in mod->mem[] but
in a region managed by its owning subsystem, codetag being the first
user. Of course, we still need to consult the module subsystem experts
about this.

>> +
>>  #define mod_mem_type_is_init(type)     \
>>         ((type) == MOD_INIT_TEXT ||     \
>>          (type) == MOD_INIT_DATA ||     \
>> diff --git a/kernel/module/main.c b/kernel/module/main.c
>> index ed26f167be84..2337bf604f58 100644
>> --- a/kernel/module/main.c
>> +++ b/kernel/module/main.c
>> @@ -1728,11 +1728,8 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
>>                          * preallocated contiguous memory.
>>                          */
>>                         if (codetag_needs_module_section(mod, sname, s->sh_size)) {
>> -                               /*
>> -                                * s->sh_entsize won't be used but populate the
>> -                                * type field to avoid confusion.
>> -                                */
>> -                               s->sh_entsize = ((unsigned long)(type) & SH_ENTSIZE_TYPE_MASK)
>> +                               s->sh_entsize = ((unsigned long)MOD_MEM_CODETAG
>> +                                                & SH_ENTSIZE_TYPE_MASK)
>>                                                 << SH_ENTSIZE_TYPE_SHIFT;
>>                                 continue;
>>                         }
>> @@ -2815,11 +2812,10 @@ static int move_module(struct module *mod, struct load_info *info)
>>                         continue;
>>
>>                 sname = info->secstrings + shdr->sh_name;
>> -               /*
>> -                * Load codetag sections separately as they might still be used
>> -                * after module unload.
>> -                */
>> -               if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
>> +
>> +               enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>> +
>> +               if (type == MOD_MEM_CODETAG) {
>>                         dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
>>                                         arch_mod_section_prepend(mod, i), shdr->sh_addralign);
>>                         if (WARN_ON(!dest)) {
>> @@ -2832,7 +2828,6 @@ static int move_module(struct module *mod, struct load_info *info)
>>                         }
>>                         codetag_section_found = true;
>>                 } else {
>> -                       enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>>                         unsigned long offset = shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK;
>>
>>                         dest = mod->mem[type].base + offset;
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 461fa87fbb0b..7481180dadd2 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -893,6 +893,14 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>>         if (size < sizeof(struct alloc_tag))
>>                 return ERR_PTR(-EINVAL);
>>
>> +       /*
>> +        * Profiling may have been disabled by a concurrent module load.
>> +        * Return -EAGAIN so the loader retries with profiling off, laying
>> +        * the section out as ordinary module memory.
>> +        */
>> +       if (!mem_profiling_support)
>> +               return ERR_PTR(-EAGAIN);
> I think this requires your patch [1] from another patchset to work
> correctly, correct? If so, I would suggest sending this patch as part
> of that patchset since there is a dependency.
> 

Right, this hunk needs the retry from [1] to work. I'll drop this
patch from this series and send it as part of that patchset instead.

I'll wait until we sort out the plan for [1] with Petr before pushing this.
Feedback from the module‑subsystem experts on this patch is most welcome.

> [1] https://lore.kernel.org/all/20260812054105.102637-3-hao.ge@linux.dev/
>
> 
>> +
>>         /*
>>          * align is always power of 2, so we can use IS_ALIGNED and ALIGN.
>>          * align 0 or 1 means no alignment, to simplify set to 1.
>> --
>> 2.25.1

