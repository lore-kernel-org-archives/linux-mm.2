Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC6C8CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EED78E0003; Mon, 15 Sep 2025 03:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F8F8E0001; Mon, 15 Sep 2025 03:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E6D8E0003; Mon, 15 Sep 2025 03:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02D608E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:46:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D213DC0378
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:46:18 +0000 (UTC)
X-FDA: 83890701636.03.B9BF14B
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id C102114000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:46:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TLVVjqph;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757922376; a=rsa-sha256;
	cv=none;
	b=Ez7k8UUOnBNYJhQ4YtFhdAxvdLNTWBcw5e/p2Lf3eFEOS6uEjB/r0VlUoLYzAaAcnE04Cp
	2+SuHVB9scjeb2I0pu3sry1UtjbqwSQ3ECN9/S99w7HNYeiJJIMhhjZlV6CpRGXqT6cJz0
	uvYsyEWvZOUhiyYDNOJ6WrIXVHmynMI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TLVVjqph;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757922376;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8n/Nl9zgUNrX0AaPSwNRo3+ygEc48bdAXqhu2nej0A=;
	b=05uVFU/cKhqXDYCSGSz3CKiVu9lghzwHsxOUpUrYTOlRrJ3rrdTHubjYpvaBP5spR23VZN
	5ha8OxBHKitgmEPFoU6k2DV5+TMCnvzFTAHnfLmRAfNoc6KytSJG3Svr3MKMK5RWWR4bzw
	7JmudJQK1f6B+glsh73d0GBvPhhrCLU=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b07e3a77b72so248534866b.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757922375; x=1758527175; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q8n/Nl9zgUNrX0AaPSwNRo3+ygEc48bdAXqhu2nej0A=;
        b=TLVVjqphlySBPmeRecNFgSuEeglP6PblUF+d3h+c+Yv2wtlS1PaDdLIZZT051F5MBf
         jmmnr2yk863dfv/vuPYkLxNIWc62JQHmzJwEte0BL5w6sb5+L6NTj28+OjntyKxkhFwP
         KMJnStwhruTEHIO3TPsrGZNKPQwaWVFMKAvKmZPQTfTmX+gwrxQg0xtLbXj9VlyWv579
         IWGYABZSjcVY40jGPtl6kAQOaHFIunOBNfX60kBmVaTvywt49wqKwo7SbUJZYkc6XX3b
         YbKjHn2k5Wy2xTPNVpsyzdJ0oseefzMrPHVVYHjp+KgYqkyCZMPmN0rayBM18uxU4cNC
         Ls5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757922375; x=1758527175;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q8n/Nl9zgUNrX0AaPSwNRo3+ygEc48bdAXqhu2nej0A=;
        b=KOudjTf0dTDaRkiwaD47R1JSC4Uj6qEc5HEq75Ii2DKNs0IQ4gXqiR7darp6Uu5DJk
         cYRAnvW82gZQ54xzCniAbHfOeqdVSE8bz2MFggBEnl8ZqM1iasjfpV9/TvGP91QBT1cx
         Vgx5mplKNmG1yrDgY39H9Ti+DoffoV2H5c4uTHUaLRY8oFv02ZQLmrHgSs1L/+BcwN6V
         QjpnXNZI5UOMHZQ5yCwb+MgzRSuM5X6efcLYC7PXKbXpmh+9B/uX+cRiQYkJBx2lXpqO
         Tqt8j2n9wfY+19jCbJpIRdwT+zihfnWvFC4I0yReXOm2XpG6caZc2TFJHlTECssHXuZs
         mo7g==
X-Forwarded-Encrypted: i=1; AJvYcCX1x2O3Bj2wZfKjG9esl4bWg8ZPxxUel5iSr9pA8SNdyw0t/wP6dumcw/vixrGCGUIJRre3HnfNcA==@kvack.org
X-Gm-Message-State: AOJu0YwzO7JiC3U5wPw8AeCmhzoSNyJiI5RwQPIIMPVtJXVlM9fXIvX6
	v+J7ERwlKWbI0bOflD2BD7hrSIHW0x8R9B82OKCdc7KjgolHKuGGG8eP
X-Gm-Gg: ASbGncuAiV6bql/Y4Gg7Wg3iZrZpswJHvxVfe00vtTZ3WdIjENNJW+Cn9SoaqikwfWh
	i9nk3wVFimnEL6u+x8ltjPJSsNDU4H5v4U8ZL0JCYijdUw50yTweaTTKL9/9V2tR2OS/jDAkrRW
	oxSPu/iLAvQl33/XE7KpMlN7K8eE74odpnqmp6t6PHy9InfvBto1GXplWcRoqzpFKGwNF9ucyGu
	1cki6lFAv05oGDJPFCNCxtup5qW9fmDO6w2GfZJShNyNEYBw3wlQpLziNvWYYowF8R9+Pj5g6e1
	I9rwzGMwM73JPTajhJ4LAkpqVlge3VSqu6gKE5jsdyq+uDia5aPyLcpo65et4W1sgfvE0GdEdOj
	wjekRXyetaKU02FoalocUZwIDDDgKWBlM
X-Google-Smtp-Source: AGHT+IHYsgeY66s1dhKrXQAmuRRFT9enDc7TDqfN7XB+l8NTknZtcs8SdIvTlackUaItplvWNKq/zw==
X-Received: by 2002:a17:907:971d:b0:b0c:7269:8459 with SMTP id a640c23a62f3a-b0c726986afmr553549766b.7.1757922375051;
        Mon, 15 Sep 2025 00:46:15 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62f0dae0140sm4468729a12.48.2025.09.15.00.46.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Sep 2025 00:46:14 -0700 (PDT)
Date: Mon, 15 Sep 2025 07:46:14 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
	akpm@linux-foundation.org, chengming.zhou@linux.dev,
	npache@redhat.com, ryan.roberts@arm.com, xu.xin16@zte.com.cn,
	baohua@kernel.org, Liam.Howlett@oracle.com, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <20250915074614.tsezftgt2uks3l5z@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
 <20250915015722.z4w23d6ralc2y7mk@master>
 <daead4f9-aa50-41bc-901a-8dfbdbd896c5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daead4f9-aa50-41bc-901a-8dfbdbd896c5@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C102114000A
X-Stat-Signature: htuckek1dd1uqap5s6artiqjst4eezjy
X-Rspam-User: 
X-HE-Tag: 1757922376-281360
X-HE-Meta: U2FsdGVkX18R7Uw6Gx1Usj4mnlG+yye8HBRXRdM7jjAalw67jNf6VF/M+/a42DMHtGpYLEKSaSeK6His/bm7c11cRaPWzAY/zNGENYf2ygZrqNwSMeQWu+PKtGMHzzwAeqSyLAokSuGLc7y2hZfdzXKt8zoST+vQhph9z7xF8j82yjVff4O6dYcZgKJ/CqNC3lYEx9CEvA/T0cW9Mn0ZqIK0A8+U3AhKNluzijYNUp/bd7Aok7gg+z/zsS5ZBnyTJDwjoLkzhgC5wf+C1oRMigqhnYtSuovTE3cswWXEMJSpWySjzMdSRV/lnLNrfnRaKYzSZhoGprn8uuxiwt+QObeIk38iBMsy5X/EGhli4DxP9IHS3uBWodza8sA9+jXPnEWvIZoY2VTmMPJnsOOc/FKd3Ulb0Yto9XGsroRkrJ8jbmZS3mOzF/PL6IxWR3EkdPBHUTTtHsQ6DF+jbn9x6Yv8euqRqu15zmU1idG3ZnQK9m0ui0+D89uYhkJeiFBi4CzQeP00EgFB/4iQIQKmIESGxg5yJQoxYjTfCcL+nRjBiP5fxgx5N6ooBMv+sg/mJwcjKW2RSa1XaOBH5SnDR+1HnQL+C2VKHg+63ad3fMduJRqrRCU0WPwpM3K58GYVZ5iqtZXoZa/Kjnl9nEMb2/5Hp2QI9IiN9g1MgGGG53rrjs6f5cuLouFcSjuFYaZuzs9IsR06VAf0ktZqsnZ2rMWxC6TGaMuJvdVk9DGBMf/uAiEkfa4sPHxvrQyobomJjHzNBTYhl2/bbFehb26K9QIuBWQ7htpFgyS1pxXuyOUYP2fYzqxYFRDs4lBN7f4suzeyj4sb/TXKUDJj7ClaVtUmOmK/hkSg2I11MwWfXLi1uQVg+JF5gmRtSC4OeRnoyK8GFNKZGF2ecl+OyYm5LtdMeevr5GJBW5+xw/NX3+dBHKnQ2DRxj5MOFgsqDdqxP9PUbJT89hV+atFtIkC
 YQPifFPZ
 NlaOZ9Qsgfr3BPM2SHgnIkczBjCy1X+u/TXlTD7hX2aN+jHr7s2wRewOFxEROIi/8XdzVhDtFgMfNTsQZ03eQXx2FLDTR/1cpu4BkLQD7+prkStACPDyaY71tfJ+AvvnIqkpxcwyzwuUDMibSUWcGQyvgojdGQH5Yx59KaLwyFRq2GR9D+Y3IVSOouwIhVSNkFM6m27X3+RMBapuexYZQJEA82mR2DoG7JQ8LU5CumoMRuIywCcBG6KmfeqYZpMvxUXqwfU3LiHQLvgnw02ht/c0mfWaAAxVgXKFAZulsMpusedpQbQjjE7iiZYt5j01zlEFY9SYtNk8cDFrT3F72rfQoqyXy1luqLQg34Jbrt+CB+hkLErhlI3U3zxfgheZ3tOGIWRDmxqW7EajOXPv/beUYZLMSb5iBftAxnxa/SicvndOYZ59zaRr+8wWzfcdzqPnOU0G6uZPKn3BVl9OkO+OnLYTToxZc3ckejXh9KskZVwm1peu7Cjyj9MurfSiSsJV4AzuPkPaI/gPzJ5FpD25Gg/brfU6wbSZZAw2IR1cHKYXfz/InXpbGRSMSTqZ8kt/Jl6gaG87AhM51mhO2KHDdIWwVDiimcOEa7Hnfd2uDd1+7Bxuy/wD2xqyfhkYG2vzyV32ZSPDHLq62QuJ1Dv4S6j05k8puzG53aeVZ5upiD5WSe8/BFIxdjRhR7eyiNCgWuemS3j2+IES4c6oH/YiNjKF/jkAVDi0jJGGtyeHcydrML2Gxq4aHYpvg3mnAEzW0nVAClls6qbLpZ5UXtmCWhJSkmvxZIOcR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:19:55AM +0530, Dev Jain wrote:
>
>On 15/09/25 7:27 am, Wei Yang wrote:
>> On Sun, Sep 14, 2025 at 12:59:33PM +0530, Dev Jain wrote:
>> > On 14/09/25 12:33 pm, Lance Yang wrote:
>> > > 
>> > > On 2025/9/14 14:21, Dev Jain wrote:
>> > > > On 14/09/25 5:30 am, Wei Yang wrote:
>> > > > > When using mm_slot in ksm/khugepaged, there is code snip like:
>> > > > > 
>> > > > >        slot = mm_slot_lookup(mm_slots_hash, mm);
>> > > > >        mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> > > > >        if (mm_slot && ..) {
>> > > > >        }
>> > > > > 
>> > > > > This is only valid when mm_slot is the first element of its wrapper
>> > > > > structure, otherwise a NULL slot would converted to a mm_slot with
>> > > > > negative value. And current code thinks it is valid and continue.
>> > > > Shouldn't you fix the code for the case when you can't find the slot
>> > > > in the hashtable, i.e slot == NULL? Like, if (!slot) return.
>> > > Right. For khugepaged specifically, the slot == NULL case in
>> > > __khugepaged_exit() (only user of mm_slot_lookup) should probably
>> > > be treated as a kernel BUG for new.
>> > > 
>> > > But I'm not sure if the same logic applies to KSM ;)
>> > I haven't seen the KSM analogue, but restricting the position of an element
>> > 
>> > in a struct to make the code work should imply that the code is wrong in
>> > 
>> > the first place :)
>> > 
>> Ok, if so, I think this should be a patch with Fixes tag and cc stable? And it
>> supposed to be two patches, since it fixes two different commit. Am I right?
>
>I don't think this is a fix which needs to be backported, the current code works.
>What we need is a VM_BUG_ON() or a WARN_ON_ONCE() when slot == NULL, because that
>just shouldn't happen, and then safely exit.
>

You mean sth like this?

@@ -2940,7 +2940,7 @@ void __ksm_exit(struct mm_struct *mm)
        spin_lock(&ksm_mmlist_lock);
        slot = mm_slot_lookup(mm_slots_hash, mm);
        mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-       if (mm_slot && ksm_scan.mm_slot != mm_slot) {
+       if (WARN_ON_ONCE(slot) && ksm_scan.mm_slot != mm_slot) {
                if (!mm_slot->rmap_list) {
                        hash_del(&slot->hash);
                        list_del(&slot->mm_node);

VM_BUG_ON() seems too heavy.

-- 
Wei Yang
Help you, Help me

