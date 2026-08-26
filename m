Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F84C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6AB06B0088; Wed, 26 Aug 2026 04:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41E36B008A; Wed, 26 Aug 2026 04:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31436B008C; Wed, 26 Aug 2026 04:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDB76B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:32:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 694CDC02DC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:32:05 +0000 (UTC)
X-FDA: 85142753010.29.B2C3247
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 52D7240008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:32:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=g5eT1ZUV;
	spf=pass (imf12.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787733123;
	b=fT3/JeInLQwbOSqwkd/eRk4YPtPnaLzzjn0SATkqMl3rHq9MSSbSoAXEvFJYHOWSLGqu9f
	7luWuPOUBrk6YM6ITUudxYeOzqzPpTv2vyZfYqNUDAPo3oD07I5b/Tydne1UnHcXZKJZ6N
	OIqFRqjT+nugdbf3t7AKkn6cPRcY2RM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787733123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzjUsX+lsqtEVzRmerNtLUbOSo9ZLAd59UCmepoNtOk=;
	b=l+9fam8ETAIWGO9UU2n/txVhEI2YR+XS76Id7BP/sJ56erTz2PCf5HFkkj0L9e/wIltNGd
	Iw+7xbLWwJCWy5aUXy3m2mWjaCcNcw4EVO1pgyCStGKJJuX4ToDubJu0je9WAUMFoDjrRd
	lnnu2xdPIBPSyvN+i2JCt/6acdrdBkw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=g5eT1ZUV;
	spf=pass (imf12.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15cd3fd760so74693766b.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787733122; x=1788337922; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lzjUsX+lsqtEVzRmerNtLUbOSo9ZLAd59UCmepoNtOk=;
        b=g5eT1ZUVZU9PGKNpjmT+5ci8xVPxWwW8OGdza8Af07lCxnnyYx8mPcvAQ9jIQSdsy+
         BCcbx0kMLbyxEV8wMaZiNWT5Wj/ZIS23KxgjstYPBgyDncipomczjKVCG6PsfLWpgbdl
         31odYyBLWPS+Y7ZIiyunwqc6i8sSRhkmO6gWyNST1iN9QrZ1xEXbBdv427Oe3zU6dPLp
         EUYBgJtmEtqOBwJAazsYgg91qWQdA/sAd0kXd9j26KfDk68fdRQ5pVAqvRW9iDuZScOx
         eryqQDU0DfP98YqNIwklKEFIVZI5CMc1F+jyxCXwG9sXwN9rMJI//H5YpC6P/UJbdLqx
         vvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787733122; x=1788337922;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lzjUsX+lsqtEVzRmerNtLUbOSo9ZLAd59UCmepoNtOk=;
        b=nK6O6wkEq/PBC32qpn4FVrs7UVvXhJQkUHW3NnRJpfjHn19iz3dq+9L0HN9c5DGTC/
         6ZOFSex0PEB9qEn1LJZVKIfoOFcwr6jLoYAQDwbWoQ+ZoObZeKrJOz5bs/tnbZYHb5HN
         boFvuEDKdmwQNZc4DhbmLVaiTwIx+0Yyg433tAab+Rzh7F8wQdGQKiQnCMLST6jUXWib
         SRRSXIsjkvsISrdG7PPKYmQ/YVKLuH0WW5dTIkGIVdSueFleh7k7/xJM1FL3U34o0Job
         OTdpJ/FBBLR3Tux69j3v35ejwkSl59dRgtSvrRJS0P8xR69m8yHeU3dE+6LXD6ypxfCx
         9/xg==
X-Forwarded-Encrypted: i=1; AHgh+RpAMQ/+MbkemEZKUl/xg3sS0RSlzZHpuQp1/7/8FGXOX+d8uI9N5L80hBKq5zqqr5GPLfX2hJvMmA==@kvack.org
X-Gm-Message-State: AFuF++kCWlC/6Emi7hhuofQCbnSZwcz5P9Bc1cokXGpQVd2vnpZKnnNy
	6y6OqusDVhxyM1xBr5HT4JnPmUeiVK4DLyAqwqtWOfh5r31UepxJADOPGNOcI5k2xiA=
X-Gm-Gg: AR+sD11+gikgdtx66f9MrEOrYjQTiGahHl0fUPECxkpW+zYH/gAbp9DozsDgkAuwjix
	w+IwB06+SjUTjTnCHfq8J6wQZAj3PVjf0xE8a86G7GxfO4MJsBBaEdtLWJ2myWhrComQ7Rn7blj
	RzEwj8X6psdNq616mbvR8bbQh6Gic5gXEGo9inUQhSnHsFNzJUBERxtNkMEWkDAnvnCeeWJlPGn
	3ZcKaDb8TTlg0W6kB3PryfNahnYRSz5Eoj/EJCxCohSCJ8wFzKiN9NmNTF4wKbQVPqL0K2ebM2g
	d/Q2BpHFIlldwrm53LcWgj5OLToKm8qUPnQeWnaKOjg0FMFhm6Ct7Fu71EmSq6k3RplmgRNqv+S
	0BxHGIZn5Wp50dkNUG9Zm+GHhEfkF59C4o/MtW2irpxf6xHFf4xlNqhm5k3nQrTFM6pJ+ZcPBqP
	7fz8cbe+6gxKGYltxp5y0qzifyxVyM4Fwto0NZFBYX/DeCNXuIYd4deivW7mcvWHCIxwkP9KEaf
	VtoKX2Sus+clBRq4IumuexS9lNMzZZ3Pls=
X-Received: by 2002:a17:907:1c99:b0:c20:fed2:898b with SMTP id a640c23a62f3a-c250c38520emr594114066b.23.1787733121625;
        Wed, 26 Aug 2026 01:32:01 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:fc6c:f9a2:4a0a:6354? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5deb030bcsm4393433a12.31.2026.08.26.01.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 01:32:01 -0700 (PDT)
Message-ID: <499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com>
Date: Wed, 26 Aug 2026 10:32:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260812054105.102637-1-hao.ge@linux.dev>
 <20260812054105.102637-3-hao.ge@linux.dev>
 <CAJuCfpFvdNFdsKdK2CdF2fNp8gbNgFpoeAiaqp70mpbNGCvk3g@mail.gmail.com>
 <143a37b5-93a2-4038-8be9-29e13263e743@suse.com>
 <CAJuCfpF1pWqhc+P9zPg8FT_CcdQxRuEpJ2DtYja1BeMXhW7-8Q@mail.gmail.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <CAJuCfpF1pWqhc+P9zPg8FT_CcdQxRuEpJ2DtYja1BeMXhW7-8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52D7240008
X-Stat-Signature: ef1iy4ufgtzthekyn8hksmy34ahasoik
X-HE-Tag: 1787733123-323321
X-HE-Meta: U2FsdGVkX18g8B/zrzYbclN0FVw6YrJw3/5Y9sOgayS8mo6RSkD3VfIesOoIjig5waK/mLVD6E7aQ4y0+LlY7yVBwAyWUGq/RHv9b9bVOMUkTBG0Ph4K2qUkfUm85x8qvAioXUXlOzTqjzA1ccz0yz6Hp5qhhCCe9G+dFjUmqnRrrtYtcI7wfbuQxOlusBjHMPwnxdznUyDSfiDOCfuRcTOGyXks3rg+EGPCi0XHAcZYCF/g1e20c8JX/YyciKTCmT+KJWGx2GzL3FSzMpjT2gPSfw//1I9NZm5ojzBp/SNM2X1+Ony3zUXwJaKJRgvOuFS14isolaow+FdQiNs2DBjqTyMwY5ZuLg2756rvzNgKQg+zH4xU9rC7lYM/4zQhiMGqwwM3xcMvYOafLW8UTm5r53xogAPb3QsoSfhiUPWdYj/tho9h27cWcqdtvRTIOt1TnojGPbP3G4f58eT7DhthUrpk/cEj57YHFTmYS27eQdxj6ECCoMYPMCey9Ti0jxdSiIIbkW3o4jetTiCOBR60A5XRAOBB2hMDM3Ah7Oruaxstz0INXh6s+eoNNTmbtiLWABGJLP/tgbZEacuaNeggqqz1h47dU6QMT5kuyDwMlXGfFppkFvJ/g7no6AueMPTR5LFws85C19G0ozHVf9juzCFXRmjhrWMitPj3OV2IQC93zLx2xHt07JK9vKInxxwUWn5P9S7vPmDCCELm59ktCJx3Kq4URb9hdh3dN4DiNUv72VmD4Ma1CMmXKrRIeDJ61qU8wKiTmMXt0d5bQZlDgXfe3KbkNwx9oxQ4olCYPOpBKCVnnDK6aGMldHLfF+srTMH8ZexguT5diVlfp2DhOj+V2bU7YSwjcjVQll36niLtorysYb/mLneogaNjkfZcPJP7HhDUUBTryBt2RNCP73cFLIxSZ4nNIRSk+bIX3LGEWk0Z0WnwIHZpBTRts+WOtkHeUAGgIi5GOJ2
 /ZoEWnIJ
 UD+DfoK3QNTKckP14I9pQXNRHPuRtQFoWx7VYkBQKIeo9hmdN85+lhu8L2WK9PaT748spUqAeQSw59bKoV8IhQRYopxkuXV01sXt3+YpmSuYyzL6dTrawXTlLDDBdGDD4F0+G6xh/Tz8YHSBq6tVHAxppQVK9zNylz8ovKUVC1V9ifg1D26qOjKetE78byHrhjwrPcJ8Jx2oZ+MtNsc0N5MugHI9uZtt/sxWMsFcB4mIlrtP+mIZIZCZvLGjj+tHqWvTj2tk0gBkT9tVth4ixkEK01El36o2CbLMOtrxxoADt2eFi5UQMnVgXpEQwSBLkZjDkxWojnnBIRYopRs+bkBraMRRyMdDvxs0q7DFMGbYkqKOdmn/XqFJZs2qNE9uF94loVHw3fvcQwBpWgeCmjg5r9rWCQ1htCBrGkgZOS6uMFgGuvokXZrpEUD72NDfg36Y79hn5aQ/UZUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/16/26 5:16 PM, Suren Baghdasaryan wrote:
> On Sat, Aug 15, 2026 at 3:45 AM Petr Pavlu <petr.pavlu@suse.com> wrote:
>> On 8/12/26 7:41 AM, Hao Ge wrote:
>>> In reserve_module_tags(), the tag overflow check is gated on
>>> mem_alloc_profiling_enabled():
>>>
>>>     if (mem_alloc_profiling_enabled() && !tags_addressable())
>>>
>>> If profiling is toggled off at runtime and a module is loaded whose
>>> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
>>> skipped. vm_module_tags_populate() still maps memory for the tags and
>>> the module loads successfully, but the total tag count now exceeds what
>>> NR_UNUSED_PAGEFLAG_BITS can address.
>>>
>>> Once profiling is re-enabled, ref_to_idx() computes each tag's index
>>> as its position in the alloc_tag array. update_page_tag_ref() masks
>>> it to alloc_tag_ref_mask before storing in page->flags. Indices
>>> beyond the mask are truncated and idx_to_ref() resolves them to wrong
>>> tags.
>>>
>>> This silently corrupts /proc/allocinfo: allocated pages get attributed
>>> to the wrong call sites, so the statistics it reports are wrong.
>>>
>>> mem_alloc_profiling_enabled() and mem_profiling_compressed are
>>> independent. Once compressed mode is established at boot, it stays
>>> active regardless of runtime toggles of mem_profiling.
>>>
>>> Remove the mem_alloc_profiling_enabled() guard. On overflow, shut down
>>> profiling, release the reservation, and return -EAGAIN so that
>>> layout_and_allocate() retries with profiling disabled: codetag sections
>>> are then placed as regular module data and the module loads without
>>> profiling rather than being rejected entirely.
>>
>> When the described overflow occurs, why should codetag sections be
>> placed as regular module data? Will the codetag support use them in any
>> way, or do they simply waste space? Is the issue that alloc_hooks()
>> creates relocations pointing into .codetag.alloc_tags?
> 
> Correct, alloc_hooks() will have references into .codetag.alloc_tags.
> With mem_profiling_support=false they should technically never be used
> but I don't think it's a good idea to skip .codetag.alloc_tags section
> allocation and to leave dangling pointers. Also the case described
> here is an outlier, so optimizing it would not yield much benefit.
> 
[...]
>> I'm not sure this is the best approach. It's complex logic for what
>> appears to be an edge case related to a debugging facility. It will have
>> the usual problem of error paths not getting enough testing and breaking
>> subtly over time.
>>
>> An alternative could be to reset SHF_ALLOC on the codetag section to
>> remove it from further processing and have relocations that point to
>> this section resolve to something else. It seems that alloc_hooks_tag()
>> could tolerate this, since it only needs to reference the associated
>> alloc_tag when mem_alloc_profiling_enabled() is true and that gets
>> disabled by reserve_module_tags() on the overflow.
> 
> Hmm, yeah if we redirect the references into .codetag.alloc_tags, that
> would be much better.
> 
>>
>> It is also not an ideal approach, but I feel it could be less intrusive
>> to the module loader. I can put together a prototype if needed.
> 
> If your approach does not cause module loading to fail when we disable
> profiling, then that sounds like a good idea. If it's not too much
> trouble, could you please send an RFC?

The alternative approach I mentioned unfortunately doesn't work well,
since redirecting all relocations against .codetag.alloc_tag to
a different destination is nontrivial. It would require introducing
something like frob_relocation() that is called from each
architecture-specific apply_relocate()/apply_relocate_add() after the
addend has been decoded.

Another option I realized is to change the order in which module
sections are allocated. Rather than interleaving the allocation of
codetag and regular sections, the module loader could first try to
allocate codetag sections and then allocate regular sections. If
allocation of a codetag section fails, it can naturally fall back to
being treated as a regular section. This avoids retrying the allocation
process, which I would prefer to avoid.

A prototype is below.

-- 
Thanks,
Petr


diff --git a/include/linux/module.h b/include/linux/module.h
index 96cc98568eea..0c6f32ddcbf2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -325,6 +325,8 @@ enum mod_mem_type {
 	MOD_INIT_RODATA,
 
 	MOD_MEM_NUM_TYPES,
+
+	MOD_STANDALONE = -2,
 	MOD_INVALID = -1,
 };
 
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 061161cc79d9..217bb540e361 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -29,6 +29,10 @@
 #define SH_ENTSIZE_TYPE_MASK	((1UL << SH_ENTSIZE_TYPE_BITS) - 1)
 #define SH_ENTSIZE_OFFSET_MASK	((1UL << (BITS_PER_LONG - SH_ENTSIZE_TYPE_BITS)) - 1)
 
+#define SH_ENTSIZE_STANDALONE					\
+	(((unsigned long)MOD_STANDALONE & SH_ENTSIZE_TYPE_MASK)	\
+	 << SH_ENTSIZE_TYPE_SHIFT)
+
 /* Maximum number of characters written by module_flags() */
 #define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
 
diff --git a/kernel/module/main.c b/kernel/module/main.c
index d0e1e0bd2ad0..a86ae8774cd0 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1624,7 +1624,7 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 		 * ELF template and subsequently copy it to the per-CPU destinations.
 		 */
 		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC) &&
-		    (!infosec || infosec != info->index.pcpu))
+		    info->sechdrs[infosec].sh_entsize != SH_ENTSIZE_STANDALONE)
 			continue;
 
 		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
@@ -1722,20 +1722,6 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 			if (WARN_ON_ONCE(type == MOD_INVALID))
 				continue;
 
-			/*
-			 * Do not allocate codetag memory as we load it into
-			 * preallocated contiguous memory.
-			 */
-			if (codetag_needs_module_section(mod, sname, s->sh_size)) {
-				/*
-				 * s->sh_entsize won't be used but populate the
-				 * type field to avoid confusion.
-				 */
-				s->sh_entsize = ((unsigned long)(type) & SH_ENTSIZE_TYPE_MASK)
-						<< SH_ENTSIZE_TYPE_SHIFT;
-				continue;
-			}
-
 			s->sh_entsize = module_get_offset_and_type(mod, type, s, i);
 			pr_debug("\t%s\n", sname);
 		}
@@ -1745,16 +1731,10 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 /*
  * Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
  * might -- code, read-only data, read-write data, small data.  Tally
- * sizes, and place the offsets into sh_entsize fields: high bit means it
- * belongs in init.
+ * sizes, and place the offsets into sh_entsize fields.
  */
 static void layout_sections(struct module *mod, struct load_info *info)
 {
-	unsigned int i;
-
-	for (i = 0; i < info->hdr->e_shnum; i++)
-		info->sechdrs[i].sh_entsize = ~0UL;
-
 	pr_debug("Core section allocation order for %s:\n", mod->name);
 	__layout_sections(mod, info, false);
 
@@ -2800,7 +2780,6 @@ static int move_module(struct module *mod, struct load_info *info)
 {
 	int i, ret;
 	enum mod_mem_type t = MOD_MEM_NUM_TYPES;
-	bool codetag_section_found = false;
 
 	for_each_mod_mem_type(type) {
 		if (!mod->mem[type].size) {
@@ -2818,36 +2797,14 @@ static int move_module(struct module *mod, struct load_info *info)
 	/* Transfer each section which specifies SHF_ALLOC */
 	pr_debug("Final section addresses for %s:\n", mod->name);
 	for (i = 0; i < info->hdr->e_shnum; i++) {
-		void *dest;
 		Elf_Shdr *shdr = &info->sechdrs[i];
-		const char *sname;
+		void *dest;
 
 		if (!(shdr->sh_flags & SHF_ALLOC))
 			continue;
 
-		sname = info->secstrings + shdr->sh_name;
-		/*
-		 * Load codetag sections separately as they might still be used
-		 * after module unload.
-		 */
-		if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
-			dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
-					arch_mod_section_prepend(mod, i), shdr->sh_addralign);
-			if (WARN_ON(!dest)) {
-				ret = -EINVAL;
-				goto out_err;
-			}
-			if (IS_ERR(dest)) {
-				ret = PTR_ERR(dest);
-				goto out_err;
-			}
-			codetag_section_found = true;
-		} else {
-			enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
-			unsigned long offset = shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK;
-
-			dest = mod->mem[type].base + offset;
-		}
+		dest = mod->mem[shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT].base +
+		       (shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK);
 
 		if (shdr->sh_type != SHT_NOBITS) {
 			/*
@@ -2879,8 +2836,6 @@ static int move_module(struct module *mod, struct load_info *info)
 	module_memory_restore_rox(mod);
 	while (t--)
 		module_memory_free(mod, t);
-	if (codetag_section_found)
-		codetag_free_module_sections(mod);
 
 	return ret;
 }
@@ -2951,9 +2906,47 @@ static bool blacklisted(const char *module_name)
 }
 core_param(module_blacklist, module_blacklist, charp, 0400);
 
+/*
+ * Allocate codetag sections separately. They are loaded into preallocated
+ * contiguous memory because they may still be used after the module is
+ * unloaded.
+ *
+ * If the separate allocation overflows and fails, allocate the section normally
+ * so that the module can still be loaded.
+ */
+static void allocate_codetag_sections(struct load_info *info)
+{
+	for (unsigned int i = 1; i < info->hdr->e_shnum; i++) {
+		Elf_Shdr *shdr = &info->sechdrs[i];
+		const char *sname = info->secstrings + shdr->sh_name;
+		void *dest;
+
+		if (!(shdr->sh_flags & SHF_ALLOC) ||
+		    !codetag_needs_module_section(info->mod, sname,
+						  shdr->sh_size))
+			continue;
+
+		dest = codetag_alloc_module_section(
+			info->mod, sname, shdr->sh_size,
+			arch_mod_section_prepend(info->mod, i),
+			shdr->sh_addralign);
+		if (WARN_ON(!dest) || IS_ERR(dest)) {
+			/* Allocate the section as a regular section. */
+			continue;
+		}
+
+		if (shdr->sh_type != SHT_NOBITS)
+			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
+		shdr->sh_addr = (unsigned long)dest;
+		shdr->sh_flags &= ~(unsigned long)SHF_ALLOC;
+		shdr->sh_entsize = SH_ENTSIZE_STANDALONE;
+	}
+}
+
 static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	struct module *mod;
+	unsigned int i;
 	int err;
 
 	/* Allow arches to frob section contents and sizes.  */
@@ -2967,9 +2960,6 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	if (err < 0)
 		return ERR_PTR(err);
 
-	/* We will do a special allocation for per-cpu sections later. */
-	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
-
 	/*
 	 * Mark relevant sections as SHF_RO_AFTER_INIT so layout_sections() can
 	 * put them in the right place.
@@ -2977,18 +2967,27 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	 */
 	module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstrings);
 
-	/*
-	 * Determine total sizes, and put offsets in sh_entsize.  For now
-	 * this is done generically; there doesn't appear to be any
-	 * special cases for the architectures.
-	 */
+	/* Repurpose sh_entsize to track where each section is allocated. */
+	for (i = 0; i < info->hdr->e_shnum; i++)
+		info->sechdrs[i].sh_entsize = ~0UL;
+
+	/* We will do a special allocation for per-cpu sections later. */
+	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	info->sechdrs[info->index.pcpu].sh_entsize = SH_ENTSIZE_STANDALONE;
+
+	/* Allow codetag sections to be allocated separately first. */
+	allocate_codetag_sections(info);
+
+	/* Determine total sizes and put offsets in sh_entsize. */
 	layout_sections(info->mod, info);
 	layout_symtab(info->mod, info);
 
 	/* Allocate and move to the final place */
 	err = move_module(info->mod, info);
-	if (err)
+	if (err) {
+		codetag_free_module_sections(mod);
 		return ERR_PTR(err);
+	}
 
 	/* Module has been copied to its final place now: return it. */
 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 2070e682fe10..112a014d4b89 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -950,10 +950,12 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 		int grow_res;
 
 		module_tags.size = offset + size;
-		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
+		if (!tags_addressable()) {
 			shutdown_mem_profiling(true);
-			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
-				mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			pr_warn_once("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
+				     mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			release_module_tags(mod, false);
+			return ERR_PTR(-EAGAIN);
 		}
 
 		grow_res = vm_module_tags_populate();

