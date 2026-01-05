Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7F1C2A073
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 00:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186BC6B00B2; Sun,  4 Jan 2026 19:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10AC36B00B3; Sun,  4 Jan 2026 19:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016CF6B00B4; Sun,  4 Jan 2026 19:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1D556B00B2
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 19:31:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1336B92EA4
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 00:31:34 +0000 (UTC)
X-FDA: 84296031708.08.DEEB9E5
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 10A87140009
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 00:31:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MFMm+rKZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767573092; a=rsa-sha256;
	cv=none;
	b=2bOrPoiuXuMjrGJuAg+4BEAuuDqrdGY7Cf4zl+TwE8WLDlTJj3Dc7CinSK40hU5PQLltjA
	hk80bJm6XgiFuMKx4Gf3IMuU7EOLetQ9qaWEcLrSqnGnspkQPPpWdA9hL12+13+Dhau4yb
	kPXq6C6JH5MdDiOQoY7UiCsOuhpr0zI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MFMm+rKZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767573092;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpScWjXx32UdireQANlIMVCU9jYYS6COy9ebZPNG17U=;
	b=hRZmVoc+ssX3RLpUfjhNyUkAy+7Fz1W5mhBG/vOepBKj12ljcCa6LFCssn9vkqWj90BNkF
	i2KLtbNg61uktuwuksd4iwMLnjgj5cEEFGTY9WZMAuPWr1WGSs/Bj1PdA/j50uR8w5n+xm
	o8QMYL4RpWdtI+3tQnWYtM70aTMX6LE=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so2259327a12.0
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 16:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767573090; x=1768177890; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gpScWjXx32UdireQANlIMVCU9jYYS6COy9ebZPNG17U=;
        b=MFMm+rKZk7J9NxAIFECjPNcpjeej156BnZC8qUTMpPaOg3cEcjjqa4c61fjK0aid07
         VRqDEPnHiUqJGo000DSLV2e4MLr/1WFlVRj3Sj0JcDiPyJUX82wEohTKpip0iEi08lqn
         CrE+WX/zoCTHwYgyrhVzxdmwYdAj8daoQPLy9r2eJF2qef0p54l+Sjs2JcEpexPE2+Sr
         Lq5SWojoNjefQTIT5Eo1HLc2UY0tKH2pNacZ56D7Vt/wMyHceGeyjEQQaz+gLlg1aoZ6
         jSfc1G7/24pzi/+grEVLpQgDZ6emuFiG4uaD0kPug2muN6XayIcxR+UJsSYE5MpsSeI/
         ULUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767573090; x=1768177890;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gpScWjXx32UdireQANlIMVCU9jYYS6COy9ebZPNG17U=;
        b=K8paIGwt0ug55WplCO4xzevBIcITcYflQ7c/Bzw6ah6G8B23frg1otFmJRYuZN8W+W
         2Pluesy11ZTMsLcQyh1vc5giXv6ZLKtlsZ3UTpB6lSDVn/1LFLxHAVAIS+T/PFwIhiL3
         IXLJy8ELaklCsXhqem5saLubvecxYtbDXLF/xB7ztHUFl6cZVdTcyvS/dsRLQLIS0OJk
         gRrKvUtqeovN1zJS4NosCiB2wK/nkC0WfbpO/2ABVcy6O57ZSMb6sDAKz4xp03AgSL4G
         kPss0T0Suh2WOoH8g1Pxr1DmzuO1GJf/92SkQfHjqoYA2/I2vSin7wzgH6CY/JXA3LAk
         aQqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVN//udirkE8P58Cdm4PtMwcGiwckVeuYJ6BuskAgORIRMnnBsv+Ad4CstuR1KfGSjjfjFHsFtskg==@kvack.org
X-Gm-Message-State: AOJu0Yxxi4s5A0gUtWY0dZrFPI5OtGX/O5qFQVnYM/PmnorF9R3gidrP
	2FDSND98qmY7qled/TqN+Sr1w1uEcGD2e71WtsnWatTFrx5h0laxS8q7
X-Gm-Gg: AY/fxX4qchV3JWoOh6GpInvsGcJZDTwxf6LLbwsoujlWWGs048Vrc/cyImacafx9zQ7
	gkctNephC7DMK5bGOjp6fzyaTz6Erx8Tq2mLVeXsl3KHQmR8DXdst/2rG9ryS3hCFE2dD3LCQcL
	dScSP30WtFTMHANnCk5s0pYpg/HNKUJSnya8aINwitcQHFsQvC9y/Tux595H5lKXoPoxDhSWBXZ
	Y/l+TDwBbXbjq9swC8GQJLpE1sd8Q7hrw+Yk/UvSZmDNm1Q67nW6PN/ebbZmqdazxdbsFLZzsC9
	AhfaZuTy3EcziKqz+TuhMhXYDnEYfHTOG1wFkyv71S+tD6z+Fi0dZBUMlfPKPnLuolNqSO8sIwO
	Cs6yhqPzy+O+5UF+6ieW4tktDWg+cJMoLIpWlg5fgdmCcTxZZQ2790r4VYXGsg2am3B1h6D8S3x
	aLsXmFlIorsA==
X-Google-Smtp-Source: AGHT+IFqZiY/tTJ0C0QIUq5PksnWtfuoN7KhR5JgpcJjhbJ9tEmhm534OfKZskuDHTP+pZFa+QoqQg==
X-Received: by 2002:a17:907:3daa:b0:b3f:f6d:1d9e with SMTP id a640c23a62f3a-b83e25b475dmr722625566b.6.1767573089984;
        Sun, 04 Jan 2026 16:31:29 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b9105a9c4sm52272729a12.12.2026.01.04.16.31.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 04 Jan 2026 16:31:28 -0800 (PST)
Date: Mon, 5 Jan 2026 00:31:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Vernon Yang <vernon2gm@gmail.com>, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org,
	richard.weiyang@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org
Subject: Re: [PATCH v3 6/6] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
Message-ID: <20260105003128.7xitfioeno56h7f3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-7-yanglincheng@kylinos.cn>
 <bfb6f8ca-fa17-4ce8-a2b5-09155c50cb22@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfb6f8ca-fa17-4ce8-a2b5-09155c50cb22@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 10A87140009
X-Stat-Signature: 93abgroc7attw7rjy3m8gofabmzgozzk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767573091-935465
X-HE-Meta: U2FsdGVkX1+xKvB1SQ4EWCZRz6eoh/Ljm2xPbHfi49P/GPGh7lmFkV1ecYLoiEioEjv4toU29wG1GxXNbLApavCZEZwXQ8KYVftWBA88fEdbYatt+6oX1W4qeUZEPimvYvomQ5PtBwSZWYdkvRk+ttwiG1bm1TVO9kiuAqqZitOzbwAXZ2nZ/iqUA2Spjt743DBX0CjICvxsZ8Ue7SkecKhlCndRbQwTofKhWXSuJcIN+9ISDF4RXdlZkUFVTlvrlhdikCyAeFlAYBYm+WW0sGkWyUuaiPLRqda5mZUu3V0WDmyKs8eKir/WW64TCEOG6MURyZx5UkEJPbV/J/c5bJ+5H9KhNUvsiIFkCIalleFeXmwNCyJHIIRy6qVkksXAbF2Vjw1nrNwT+OQUB6lxgM69BtM9K8yt7wUuzlfrD2WvhLmQwplovSk2Ar3WqVuvWidADNkLmXvAuIGkYJGf+gQaqsLwv4xrRlQgf/ES5EFy+x99Vnri+BBESC5iY4iWYcEoB6QBTsXJhAgP4bNU9L+0UfR0gyllEX2V29+P6ZgBvB2gpS2naKwStC7EJeMiyQPmsfC/CeWWIVd6T+MtUbBXacZ59q2fkRA3Z4tzls8vDD8Y3vPtwZqn993e/VcMZyA3QBdis2Bmj74W4bKgs7822o5EiFD8TwTGVxCbjCnLNOQm/UA5R7Y6RDfKjggGXNVRZV4ZhYgHLbdwfitheGSfBZriPx1tNKTgBfHYv/5oLfjVrD0SuU3B+KT8mJ7ls6J7+dcNexgKJp8rjjw5/X8p8fuwrvvRdWBCNmqZQ6NSsDLAU5vGM9DbiDCvD1ZVN+CRvFZu35yAW+M4JMyVvw4ZxMOR2bApK9e9JhxHlXdfDXaxICduGfvKNxMHuKdSwua253vH7tytlsBQ7gi2scXf0LZzeVDtlgqRwoGgb1u1VGMQNg5fJzDADWES3oVE2AGeT9YflEH6X2a9aqZ
 nkwotsBF
 vc6tzwli4KQ/io71CzAfk62NMvdUVWEfOuGcZDEOhd8KHSXtpe1b4b5MSsGstTtn6DrzUuoz9b9WXNcohvEXUt5Bdj25QCd1gCRzTptqOkOuh/bE7ZL+Kws+WJmJuyeGuYMOSxcoUH5IRQayM1CWt+SlaJ5manIJQcMngCThumYcAHTJMOUTIHAvyS05ceP63pXh/ZzmwgAob9I2S8/szAyFL5INkI8p5TTLyu8i97hTOl4/wPMntZDXcfaEpP2U1RimdkTIY40IYthyVnXbN+PaaRdqfu68/Jo3JGCEY2pSONVfzA1EE90wkvOiN74gS6cA5OLHeuu30IJT8aCRgczGwzEY7Srer4BFJ+IultRgbfAd+PM4V1xnYfBMuexRry9yYCHl8b9AD5q8h5ZiYVMK83WqSEyn71nTmXJ9yquYFqQWNYeL3bZQBC1ICAniFq5nF9Q1ASK2DxyVu7N1APF0opal8HU02t1NapXh2xj5MuYPXplWwrHoOEtxCnirnFbtlizPxkvN4gEKnZ56RkgaBf6OwLpXytE7Pw02BGJ9m+0FhX5tsO18Cnnfr9SnwqiOk4qGfT0/W60v9j8yDKQ4+2r6U0WoA0N39op/TKBFWK/C7FHRtrLzz3YIjb4JDA5EyW4zfVZdVSHd5MrscOP78Yiw0XpjfhOtEo1ETAALa/OJQZWL9Fopesg1OIl/Q6VTktClS97NfRvom29HVv33euw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 08:20:29PM +0800, Lance Yang wrote:
>
>
>On 2026/1/4 13:41, Vernon Yang wrote:
>> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
>> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
>> reduce redundant operation.
>> 
>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> ---
>>   mm/khugepaged.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1ca034a5f653..d4ed0f397335 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2541,7 +2541,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   	 * Release the current mm_slot if this mm is about to die, or
>>   	 * if we scanned all vmas of this mm.
>>   	 */
>> -	if (hpage_collapse_test_exit(mm) || !vma) {
>> +	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>>   		/*
>>   		 * Make sure that if mm_users is reaching zero while
>>   		 * khugepaged runs here, khugepaged_exit will find
>
>
>Let's convert hpage_collapse_test_exit() in collect_mm_slot() as well,
>otherwise the mm_slot would not be freed and will be scanned again ...
>
>static void collect_mm_slot(struct mm_slot *slot)
>{
>	struct mm_struct *mm = slot->mm;
>
>	lockdep_assert_held(&khugepaged_mm_lock);
>
>	if (hpage_collapse_test_exit(mm)) { <-
>

What if user toggle the MMF_DISABLE_THP_COMPLETELY flag again?

>		hash_del(&slot->hash);
>		list_del(&slot->mm_node);
>
>		mm_slot_free(mm_slot_cache, slot);
>		mmdrop(mm);
>	}
>}

-- 
Wei Yang
Help you, Help me

