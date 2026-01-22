Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2318CC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 06:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E3F6B00F0; Thu, 22 Jan 2026 01:31:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591AB6B00F1; Thu, 22 Jan 2026 01:31:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C046B00F2; Thu, 22 Jan 2026 01:31:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC636B00F0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:31:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD0BFC0152
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:31:52 +0000 (UTC)
X-FDA: 84358629264.14.4382F27
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5F1DDC0003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:31:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zHQ1hoLe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nWTW6aKN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zHQ1hoLe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nWTW6aKN;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769063510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snlThi6xEbyLHgpAGreIAptLTtIG/sStzORilk3J78o=;
	b=Iiiyg/zGDIek9gQrCX2VD/wA+FY3NkKBTcm9Qu673WhJPas4FyGu6IMTBrokMdRw/P3NG+
	5LFSuCAqlHOBlxnd5qZ0s0dZYKpfCCQzORq2xALzgUqkmOMskmLtsIdMy4G6eAciV5Re+z
	hC0YPZ9rVrmz1Pg6t+JEDuwXCyqy2N4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zHQ1hoLe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nWTW6aKN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zHQ1hoLe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nWTW6aKN;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769063510; a=rsa-sha256;
	cv=none;
	b=OZqrLru/6ZNfpwcx4eMC5Rn5TXUEHaRC+9V4hpl75T6vEDS9NpUnYhv0aeSmaNgotJwbAw
	IKaJWNtYcOmRnm1ILoZ4M5CRYKOVmAi7w/LVlSyWOC2nFmwBQheQ2n/LN8Gc+QDrRHoSeM
	QSQbxzokGjk3fFszezUFCEn9QJVjgbE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 69642336E2;
	Thu, 22 Jan 2026 06:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769063508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=snlThi6xEbyLHgpAGreIAptLTtIG/sStzORilk3J78o=;
	b=zHQ1hoLeC/5cavLYx5OvU/D0QEQ93VhR9okhUNc8zOoL9mFrwy+2E8MuO6W4049oNippOq
	kNE76fHFsYXFhNJqEefS+X0P4wt2sDQrAeU1HNFOc0i5Ex7WPrE03Eb0eu6HTGhUyLqqHa
	BW6/aej7Xpacb7wmCnFsaSvz32nz/VM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769063508;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=snlThi6xEbyLHgpAGreIAptLTtIG/sStzORilk3J78o=;
	b=nWTW6aKNwwJQmhH48v0849Ik2lAcm0Xizdf4ZwIRn3sq1gkN0fQm8HbkbMoJiFHeUQwtbS
	0oghjhdTxItgZTCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769063508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=snlThi6xEbyLHgpAGreIAptLTtIG/sStzORilk3J78o=;
	b=zHQ1hoLeC/5cavLYx5OvU/D0QEQ93VhR9okhUNc8zOoL9mFrwy+2E8MuO6W4049oNippOq
	kNE76fHFsYXFhNJqEefS+X0P4wt2sDQrAeU1HNFOc0i5Ex7WPrE03Eb0eu6HTGhUyLqqHa
	BW6/aej7Xpacb7wmCnFsaSvz32nz/VM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769063508;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=snlThi6xEbyLHgpAGreIAptLTtIG/sStzORilk3J78o=;
	b=nWTW6aKNwwJQmhH48v0849Ik2lAcm0Xizdf4ZwIRn3sq1gkN0fQm8HbkbMoJiFHeUQwtbS
	0oghjhdTxItgZTCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46BC63EA63;
	Thu, 22 Jan 2026 06:31:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vbnsEFTEcWnTdwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 06:31:48 +0000
Message-ID: <6b48cc0f-f006-4d4c-af76-55f86f4267e3@suse.cz>
Date: Thu, 22 Jan 2026 07:31:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/21] slab: remove frozen slab checks from
 __slab_free()
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-19-5595cb000772@suse.cz>
 <CAJuCfpHggP+iefwGTOWnSxDma5U=uMROYNs8KS0A=u2w=1rq_w@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpHggP+iefwGTOWnSxDma5U=uMROYNs8KS0A=u2w=1rq_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ctfrpbe5u7txyoigzra1gg9jgxh1k46q
X-Rspamd-Queue-Id: 5F1DDC0003
X-Rspam-User: 
X-HE-Tag: 1769063510-364530
X-HE-Meta: U2FsdGVkX18zeCrGoo2AjXtf0xj1iv6Xy85S8GDstEBU+P5XB/SY4MacLH1K01rH3TPXSkSMvgrmfM0p8JxMqOQ0akmGmDr8CTp9cR8ChGxUyTtrzBdBMTGTzC803Uf29/zXCk6L09o3OpV0O6VpDq24rWl0m4BCT4vMk/w2vCLjaCvWbiD5vwnwip1DresJLLMpjNRRNJvIFv2vFlF3J+DGlo4PRypKSJWC4VuDJt0M0g5pl1Elf1DusOQ4s4fiQqwVwI5ZLKAnjff2jnRxV8P7KHb2YFzp/Ac+a8/tgBUgNHoeLdrjNqrAuKzBelAtWPe0tGLYFE5HUytaQ4kvUb+MO8uJgSbLITRdezV4DOi2XY1sR8Hyy1iU9CAkY32giyDt44voSPloA89KIMeWS2TkJMIG6x/hrp00zUs+y3j40KpyS3C2pZryw6HElsLfmS1l8FSl6ToVPJksPTVSVB4vmq6PVtTMAZ7zKiO6t6W+n0cspMBTaAs5/Xc0GMEJ38g0moVb2+v+Ae1OOdrHUOuM0M87suaMApwkYK2nLtmt3wr/7CJljJLtVnbryVUbwkQMWr+4T2GLaMVpXFDgmIxxDjrvf6MnUIk6llAsv/VT60eD2Y6r9eXu9rdhYaU3uqKLKpt/7YkMi/jUkVV43iVT4NqXkvKoAJEiFaCRwq2z4XTaGgQEgr3TNw+3RgRV8eP3Dvhwoy+GqAEuTvQqU3GZLXEQhtmh1jsZKs8Q+Jea6kexcpm4VK2F/uV1EZTJzZHVQruXPO4a7dAbxu4Y5MtcqRy7JVrAUblxtWE3wsifUZCVQ0r1gFIhksp/tPwFUDEV4fyQTuC4mNebjnI6ONRNUHTUQOkrfmspsLYVmCfORvcHKCEfyUdOOu9MaPXoQNUY1VOULXQNsQWH6NFffDA/pXaX+HxOI3eFsrHBZAj7fLAdBX9xk5oSRton/C0XSeloMBFbDP+IjJw3dY6
 V/BXAnrL
 ch1+UOq+F4BNHeW8TIHoVNcSBKlpwub1yen2uij3CrCRma+6PeHqWS2DfDjov9XIMJM85JXVA4JEQRjJc5v5fVgAubgylI2oJXV5v6DZVdZNnCu1lWm+d4pK/D8WCD8IziD5/nQYNGhIGwCewDhcXVR52toaq3Ok4LZWm+NEsy97CR+UdlgALF9S8LVzFzoV6nt9ds/25jY5el9T2V+b1U2Nrr5W3YIS2cfPdxc/Cj+6Tc7Yx+Kt8vGI3UnTvcbq7mmxTsSXZ1dDAXFUj2gT6P0/WukiDHTuRVNdCaF1p3an2AOTMwf++GN9f6jRKdwIL3O3Zz3fjvE3xWhbY1KBqhLklrRdD989JB1SzPUaYfzwO4n61ZeNne+AO26RKS5nySfZ7wFgvNsCqhWF6nDFXUgC+RrYOb4U4lLmyqJJAg+Cylj03UeK6EdqDu/y8QuregWp9Fcwq1xWXBM6FDEF0+jsZiVdqnGA7uApgdOZID5aVOyGUaFmpp0kXtqJueNxTYS16RiGV676jq51l+TTCeoSSNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 01:54, Suren Baghdasaryan wrote:
> On Fri, Jan 16, 2026 at 2:41 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> Currently slabs are only frozen after consistency checks failed. This
>> can happen only in caches with debugging enabled, and those use
>> free_to_partial_list() for freeing. The non-debug operation of
>> __slab_free() can thus stop considering the frozen field, and we can
>> remove the FREE_FROZEN stat.
>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Functionally looks fine to me. Do we need to do something about the
> UAPI breakage that removal of a sysfs node might cause?

Only if someone complains. Just this week it has been reiterated by Linus:
https://lore.kernel.org/all/CAHk-%3Dwga8Qu0-OSE9VZbviq9GuqwhPhLUXeAt-S7_9%2BfMCLkKg@mail.gmail.com/

Given this is behing a config no distro enables, I think chances are good
noone will complain:

https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=SLUB_STATS

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
>> ---
>>  mm/slub.c | 22 ++++------------------
>>  1 file changed, 4 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 476a279f1a94..7ec7049c0ca5 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -333,7 +333,6 @@ enum stat_item {
>>         FREE_RCU_SHEAF_FAIL,    /* Failed to free to a rcu_free sheaf */
>>         FREE_FASTPATH,          /* Free to cpu slab */
>>         FREE_SLOWPATH,          /* Freeing not to cpu slab */
>> -       FREE_FROZEN,            /* Freeing to frozen slab */
>>         FREE_ADD_PARTIAL,       /* Freeing moves slab to partial list */
>>         FREE_REMOVE_PARTIAL,    /* Freeing removes last object */
>>         ALLOC_FROM_PARTIAL,     /* Cpu slab acquired from node partial list */
>> @@ -5103,7 +5102,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>>                         unsigned long addr)
>>
>>  {
>> -       bool was_frozen, was_full;
>> +       bool was_full;
>>         struct freelist_counters old, new;
>>         struct kmem_cache_node *n = NULL;
>>         unsigned long flags;
>> @@ -5126,7 +5125,6 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>>                 old.counters = slab->counters;
>>
>>                 was_full = (old.freelist == NULL);
>> -               was_frozen = old.frozen;
>>
>>                 set_freepointer(s, tail, old.freelist);
>>
>> @@ -5139,7 +5137,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>>                  * to (due to not being full anymore) the partial list.
>>                  * Unless it's frozen.
>>                  */
>> -               if ((!new.inuse || was_full) && !was_frozen) {
>> +               if (!new.inuse || was_full) {
>>
>>                         n = get_node(s, slab_nid(slab));
>>                         /*
>> @@ -5158,20 +5156,10 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>>         } while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"));
>>
>>         if (likely(!n)) {
>> -
>> -               if (likely(was_frozen)) {
>> -                       /*
>> -                        * The list lock was not taken therefore no list
>> -                        * activity can be necessary.
>> -                        */
>> -                       stat(s, FREE_FROZEN);
>> -               }
>> -
>>                 /*
>> -                * In other cases we didn't take the list_lock because the slab
>> -                * was already on the partial list and will remain there.
>> +                * We didn't take the list_lock because the slab was already on
>> +                * the partial list and will remain there.
>>                  */
>> -
>>                 return;
>>         }
>>
>> @@ -8721,7 +8709,6 @@ STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
>>  STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
>>  STAT_ATTR(FREE_FASTPATH, free_fastpath);
>>  STAT_ATTR(FREE_SLOWPATH, free_slowpath);
>> -STAT_ATTR(FREE_FROZEN, free_frozen);
>>  STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
>>  STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
>>  STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
>> @@ -8826,7 +8813,6 @@ static struct attribute *slab_attrs[] = {
>>         &free_rcu_sheaf_fail_attr.attr,
>>         &free_fastpath_attr.attr,
>>         &free_slowpath_attr.attr,
>> -       &free_frozen_attr.attr,
>>         &free_add_partial_attr.attr,
>>         &free_remove_partial_attr.attr,
>>         &alloc_from_partial_attr.attr,
>>
>> --
>> 2.52.0
>>


