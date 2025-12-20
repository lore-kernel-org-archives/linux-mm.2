Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D780E668AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 00:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63926B0088; Fri, 19 Dec 2025 19:33:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11476B0089; Fri, 19 Dec 2025 19:33:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3186B008A; Fri, 19 Dec 2025 19:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0236B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:33:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F36A08AC5B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:33:43 +0000 (UTC)
X-FDA: 84237976326.03.9D52A90
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id E36DD180016
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:33:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="R/lBaW9B";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766190822; a=rsa-sha256;
	cv=none;
	b=W19bsaR0OJGv5E40lxKCKyABVt0RE7MzrHpR4KGRx7pcCRyemizpgLQZ0uUbSPlC3NllgU
	sIG0spS6GZETKHw/va53zn0BHMClf/bUdt9UMhXqQfDoYSxDVa5jhQzhev8T+j/Xg9+rvS
	w4lN/TJx6cqM1Qv96+AIf0trRoTT4Xg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="R/lBaW9B";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766190822;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYbf6758nhFa1mJBoRRRAf97Uabc+COBBvw6wGgXDa0=;
	b=lhigWy/cx/xOQkF3fSo/j36EV/UlXLPN7TxsuulNB9v1faLlHFdKqy4wG1mFCDadHuVjTW
	qoIQTMH968f9uWgyib/2rQTDCzvPV9FVt1+ma49jNdTp9dM4w78g90a8qEJ9pR2zEyepdT
	NysDJWE6yjhSds0W1SA9FYREK+sMCH0=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b83949fdaso2242741a12.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766190820; x=1766795620; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HYbf6758nhFa1mJBoRRRAf97Uabc+COBBvw6wGgXDa0=;
        b=R/lBaW9ByA75gJSdvwh+4NVfFYMvzdtNeYKhkqFplZ+OlfHdvS7YjLYkiCo+tbEhn3
         iVRxZtHaQF44QSujou6juLmSU1Hu98DFoPO/aH5rDCaWY3UVsfDaoTVeUNmQDSffcEAa
         5/mLlq6MV+HTaBFm6X1BoMbxUd+Ip9vk4/V5+bCfoY8Xnv+zw+VxVqPgt/+aQkdT9gb4
         0sNXbXCjtcGiHJJwjqthnyaJOgOfrnbY5dczyycIbjIAsXzarIINESPDUIIQCTH8uDQd
         ecECoacRRHUr3h/Kz8SVJHOjFI+ScIKIRDAAsg5riv+gnNH1bKVNlME0ttnvsZ4j4xCD
         0SKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766190820; x=1766795620;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HYbf6758nhFa1mJBoRRRAf97Uabc+COBBvw6wGgXDa0=;
        b=W35hmK18f6pQPe1F5Ar/vcXet6IMlgLgmGoHc1ShXoyZsf6dc3hQcvDIodZrzQ78OK
         5+I2np7WG1xgWRUBW5U2TkPQp0qnjVxMqW39TEEIJJuNS3A3PIJiWHpwzZclrBW6ZqdT
         5JAWTY5JotSPuGb+SPZ1ggbRt952AEviRTozHD9hLzPrvu6qGsK3kN2kMdQOUGXYTUDh
         KCAXTTsp8TwFju7/C2PMPZrVQoqiLg3mUQnrFGhZYPvp628XK9l5Ztb60xD9ROUJbOBS
         ZVjyzBraVFmzcZX1vy4/Fdbk18DoJAgmcgrszbDabgkdwKObHs6b+8DbLsCyFw+nJBfi
         yiOA==
X-Forwarded-Encrypted: i=1; AJvYcCUV7CIf/ix1br7yOQ1OtiaSqKCNuS+vxmpycUax/MC5ZjWAKLHauzEJkH5zYlBnkfJKFZGcQ9a3BQ==@kvack.org
X-Gm-Message-State: AOJu0YwWpyHmfhxm9Csc0+L42bI1kTA9LfWdhwAonoquRImlMSbdqmkK
	5dC/xufJTwIHULgM5zoQegcRA7To/DRPyYj03kU2hL3kqgB1Fi3N7iaK
X-Gm-Gg: AY/fxX5W8fV843JblH8U1oGg045Lg2B8T4OwJ8lO3W8dv4gwV3CRGg4c9lhPEQCF1iy
	mVN1JGrKKQaPKKI5dmdj/yyhq5vQVVgzehEaWZh9o/OoJp/ZLWSTC4sE3h1UYYQBVhsKSzzps8N
	5CRi+casHhSsyOjWJMRzleKW7Iqc9aCj1HN3fe/zWeqWvf1qUtsrRnVz4qiV4GRnY/iMdAXQaEQ
	7EWBzwk3JGkux2REdLgwK2ev4dpLvNizrItNXPInBCXmhaaynQwA4vrlI04RjdMfI1MjWBm2D7o
	6riR9EFIO7qsUJo7BRupeKEwD8/sBx2/mruKg35TpJCrHPKG59tta6XC064VUGns4W5F6b1bwvu
	2ngoTaz3ZxCld24DjBCLxv+7qzXJMpGcviNYzZklNwdY2Edlo+FN5i3ZizTktfdMyHpFte6PC/6
	TjRo5CUe0kuw==
X-Google-Smtp-Source: AGHT+IFayJKEXG80fOnGBPKQgrgpgEtLlpm+Z8aTk+lHB0VIhfdWLzoorS9Ymteu3s/3xDranClGPw==
X-Received: by 2002:a17:907:c22:b0:b6d:5262:a615 with SMTP id a640c23a62f3a-b8037153931mr494691966b.41.1766190819902;
        Fri, 19 Dec 2025 16:33:39 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ab69fasm358043066b.16.2025.12.19.16.33.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Dec 2025 16:33:39 -0800 (PST)
Date: Sat, 20 Dec 2025 00:33:38 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Barry Song <21cnbao@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
Message-ID: <20251220003338.bgqgd43wuz7q4c2y@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251215004836.694-1-richard.weiyang@gmail.com>
 <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com>
 <20251215084353.nmznnnmcpcqo4ldy@master>
 <CAGsJ_4yPnv_G0vciNLabA_kn=0k=RP6kBpuD04btj3HM_zarTA@mail.gmail.com>
 <37c5dbc1-bd66-4124-987f-8983a06d576e@kernel.org>
 <20251218152837.kbgmrjb5i6be7xow@master>
 <ad240d4c-0a4a-41dd-aa19-87293530a937@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad240d4c-0a4a-41dd-aa19-87293530a937@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E36DD180016
X-Stat-Signature: sx88aft1fie1p7mx5d1t165hwcq8mdnb
X-HE-Tag: 1766190821-634666
X-HE-Meta: U2FsdGVkX1/KV6/0616KwguSJuvaZJfbR1lQ59N6/cDA49pVL93mKOB4QO378XmXjRphEhEwq2xSzRDid/JstCLTBdRNbnL+mqnCDe/0vjhVk1Anzhrp6lt4b/8HXaQoY6RoWbKSNRUyetZ0ogRETw2ejT3b3mCyyvaKwZWnWcH6rFzMcGb+iufoz+4nQAWBdsjZ8Q/OfORPRAiME2n4K3BTs8UiDBF8nj6Y5hqK1GbDUpUJqq2XeiyQLHC/G1FglJQ5+vy0D+SSkaq4EJ+oYVC6uzLcABNfgpHyIdtap/zFnDvggm7+Jhl/JFTPstnTYkMX4aqYP/W8a3cEf9WfIg9K3K4Qhep3wLlLOgWLFHwDrQHXd3HTpmywAsdx3t9N/zOB+EY0YmzkkiE5gi0TXvLuYi5PrOv6nviVb8GBMGGzqbujhVWGTkiNJNAsNQ43VRy4OJWnEpu4czm7zWcOYoi++WuLVyjhjSND1SGJFMZOOBos8QJ/T56qYzNL+Rz0cJCa2xbDXdeY/8QXa52dFVzmWH/C7+rv/18JEXw7S2C7kTJMAHKkiNmjEzHD4lfmomCAhL90xaqv4LMaoku7d5Ek9uKP/RQkwIpiTJDk54vIBtuNFx50BBW2jUDYEc8vZCP8xQW9hds0KZbNcJZQNGkeYbRlg5+mn2yCb3296ASi8xcXDuHUvLnGhJ7/dJ3+Dnv/roppcUr7C/gwit8YktEk06PSjzwLG6P5YofkIPkCYK+uGzqYuYbfXb7lbng2xWhoqD54qnYIjEjG54jP/bmPsOuewd9Og7PYhqzoezaBg48VqLsJgEylGbDJ98HlnxJwk0T2R544ulWxSCObBntndpznWfK0rhFjNlWXU8w+Zkg9Gu6eyI+hEMUfugR8gNpHJd6hsNLWaEaszgnN1G5Pf/8e179MiX8AATFft+UGHK3R1PwCx6Nym13LUyJQm0eXk98Q7qoqhZplXnr
 a0QCZdBW
 LYRE9JDarQT41sCPvXANHyzS4uTn+dg6KzNXaJDlL34RsDbikHRjKnLxwFqsJ21Xxln7Pamt2vI9yttGngf3ulv6mHvWnI61jXAwOiONh9bb4g2dTmztChFCH3ryZzHZPXj8VSe/XY7b2LrhBPvBMvC/MWyFlUXLIgzZFG+CbzBc65jauGtsUmwoxbttZ+Uobjcyi8lpmKIuV332UvV3IxlIwv3QFSShE3H6BpukEWvRn6FbbT8ljHRoB4nNv2BlHsJ3gZH8QwZTXnqypbapwUqoqCbFgL3aC8sr8KKeQnO/jlwyMm5e9UEomEbOJMa/WinVqsRoEQCxXMch1tXihjhmVhoyujkJkhbUqG0BoRMOgvN/qNy/Ea6GLY5M0MY0PAeKaRx+RTkWgQfxYaN6uFbMxg/g35Xv+7u8g+M1KPCcB327r29+pHzeSeGeydeWElUTQtYfvfbD2VDvZFQy+Px4DswvS3zxCj0pVYziIx3bw9VFNCUOfXzmlVoNM1A6ZE/Een/+NQ3Av8SQ8YowtMs7Qcs2j8jDJbM4467Q+tpuywNSbdWnbUqwiRpPQ/rkG+i2/rb4QgX+GTqHDZ+UNBYfMWNsNcelNXLV7Ms58coXWe7CEVzC2uYYGjnVS7ndRspw8daZUPcxYPF1D1xDOGsILPGq99knKV3OmHLM92+czLVnfaFl/FXKMHLlNrkz0JJuYq9Gs/kXv16/CbUiXF4L1LeeVpc0vVyAAi9toERcfEWqFs09rCH7dGnUh8ihoSKRJ7T0GL0xMpyeJIl8woF4BX7ufJddaeQ9x0FyA0bTE/9Ex7s5XEksSxq4GFOzr6bza
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 03:26:37PM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/18/25 16:28, Wei Yang wrote:
>> On Thu, Dec 18, 2025 at 10:58:36AM +0100, David Hildenbrand (Red Hat) wrote:
>> > On 12/15/25 10:15, Barry Song wrote:
>> > > On Mon, Dec 15, 2025 at 4:43 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>> > > > 
>> > > > On Mon, Dec 15, 2025 at 10:31:15AM +0800, Barry Song wrote:
>> > > > > On Mon, Dec 15, 2025 at 8:49 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>> > > > > > 
>> > > > > > After splitting a large folio, it is necessary to remap the resulting
>> > > > > > anonymous folios.
>> > > > > > 
>> > > > > > The current implementation determines the end of the remapping process
>> > > > > > by counting the number of pages that have been processed.
>> > > > > > 
>> > > > > > Since the final folio in the sequence, end_folio, is already known and
>> > > > > > tracked, this commit refactors the remapping loop to leverage end_folio
>> > > > > > as the termination marker.
>> > > > > > 
>> > > > > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > > > > Cc: Zi Yan <ziy@nvidia.com>
>> > > > > > 
>> > > > > > ---
>> > > > > > v2: move folio assignment in loop
>> > > > > > ---
>> > > > > >    mm/huge_memory.c | 13 ++++---------
>> > > > > >    1 file changed, 4 insertions(+), 9 deletions(-)
>> > > > > > 
>> > > > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> > > > > > index 40cf59301c21..fe812d9c7807 100644
>> > > > > > --- a/mm/huge_memory.c
>> > > > > > +++ b/mm/huge_memory.c
>> > > > > > @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>> > > > > >           return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>> > > > > >    }
>> > > > > > 
>> > > > > > -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>> > > > > > +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>> > > > > >    {
>> > > > > 
>> > > > > Do we actually see an improvement in readability or performance?
>> > > > > The existing code feels a bit more readable to me; nr is clearly
>> > > > > the number of pages :-)
>> > > > > 
>> > > > 
>> > > > Hi, Barry,
>> > > > 
>> > > > Thanks for your review.
>> > > > 
>> > > > Currently end_folio has been used in __folio_split() and
>> > > > __folio_freeze_and_split_unmapped() as a termination marker. So continue to
>> > > > use end_folio here as a termination marker looks consistent and improves
>> > > > readability to me.
>> > > 
>> > > In both cases the variables are temporary, and they look fine within their
>> > > own self-documented contexts.
>> > > 
>> > > Now that we’re crossing two functions in the context of remap_page(), this
>> > > doesn’t seem to be the case, though.
>> > > 
>> > > > 
>> > > > But yeah, this is my personal preference. If it is not the case, I am fine to
>> > > > keep as it is now. :-)
>> > > 
>> > > I personally find the existing code clearer, but I’m also okay if
>> > > others like your new approach more.
>> > 
>> > Me too. Well, the existing code could be cleaned up
>> > * nr -> nr_pages
>> > * remove i and subtract from nr_pages instead
>> > 
>> 
>> Sorry for my poor taste :-)
>> 
>> Is this what you expect?
>> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1db9cfb09533..b8ee33318a60 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3423,17 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>   	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>>   }
>> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>> +static void remap_page(struct folio *folio, unsigned long nr_pages, int flags)
>>   {
>> -	int i = 0;
>> -
>>   	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
>>   	if (!folio_test_anon(folio))
>>   		return;
>>   	for (;;) {
>>   		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
>> -		i += folio_nr_pages(folio);
>> -		if (i >= nr)
>> +		nr_pages -= folio_nr_pages(folio);
>> +		if (!nr_pages)
>>   			break;
>
>Right, I think we would never underflow nr_pages.
>

Thanks. Well prepare v3 with this.

>>   		folio = folio_next(folio);
>>   	}
>> 
>> > probably more ... :)
>> > 
>> 
>> Don't catch this. Sounds you have more idea on further cleanup?
>
>I was rather wondering whether there could be more cleanups, but I have
>nothing concrete in mind.
>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

