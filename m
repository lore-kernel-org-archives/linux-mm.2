Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99276FCC07D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 22:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880B66B0005; Fri,  6 Mar 2026 17:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82ED26B0089; Fri,  6 Mar 2026 17:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710516B008A; Fri,  6 Mar 2026 17:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F41B6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:11:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C217F13A930
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 22:11:57 +0000 (UTC)
X-FDA: 84517036674.09.B911560
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id D815440006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 22:11:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JPkAvZKp;
	spf=pass (imf07.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772835115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWBTEsjlrnIpMOQE5lEBCxyKb30jpD/7gGFqD2xtKL8=;
	b=M7wCzpOPEHQg+dVUUcfue6AV/lhr9J/6apIvJeAq0AZUHbUkHgR4L+m6xL2sC2YA9sFF+H
	nitN/bf/qaLDQg7yn71c2qTDsRRFJZv3Obymdh9UAy3BLOXZz2E1U7lvdwB3KXndy4faaT
	X/crtXgDauZbJSYqy7QVSnCgU/EJhjc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JPkAvZKp;
	spf=pass (imf07.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772835115; a=rsa-sha256;
	cv=none;
	b=HB7KbXhuZTuuOj4cjMkRfTJJAGQ7T6LVdmtWBePtdDNo3iKvS+bmJal+/V/aFfpfNCA48u
	fzU1J79jUh6LKsye3lwEJKaB8qMnsUsN8RQqGnHuuCwpZce3suXOuALGVVDMT/QC+gC7or
	WTuh7Hapr0wz4h2yVgmEBNIQ90igN0A=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4837f27cf2dso90903835e9.2
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 14:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772835114; x=1773439914; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWBTEsjlrnIpMOQE5lEBCxyKb30jpD/7gGFqD2xtKL8=;
        b=JPkAvZKpEAEORx0vdrKPA2eD7q602xLu8eHoydTxGywkfBXB/zGYuIEsdGgrb7d7Sm
         bt9DVRywayDl2QFwJ37RlXOQuMS6ErJcVVWbM3BWBBdPJx5HaPLqFoQ6h7i/9CkzeUUG
         098OsDhxlUFwLGTkJIu9K6BIQkIHdbQNJZszNi+BqYQ/3hKGgGceMWbqnBcNtxlJVrxG
         vkl3BZN3lMYlLeiMxgGaMyME04pUJlXsvwpQEwyptXDrrEnLSET4jhgffQMkvZrD1Fau
         kAUoJWwTKA9rABehAR99oOqxR16/eQZIj+1e3KJgDquRuU8i5gx4Q7jpg1/nwZSuhAzz
         O7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772835114; x=1773439914;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWBTEsjlrnIpMOQE5lEBCxyKb30jpD/7gGFqD2xtKL8=;
        b=Em3av0efvowE4H/E7LLSWDgyb19AFDEEQKcRU5k6rpnKe5U1ZFv0o7lnNimG0mrZdw
         +7RVbIc+X+mnkpy/Sf7nclrCQ8UoU0ShXtKFpt2m9sHN8vQ0FssE9PfsfNgiRMHVC+mV
         BSGPQ5zlYjVFJI5fXOC3JyUV4vcPHBSze1dapv3WznVehqBEXkUx6pBUZswrCAmLTHeV
         DT7zi0yszKsdDIJmUPx6Be4f2mMhp01yu3PQq42N7scJu85ai2FjzjQSh06ynVos60Qk
         71WN+MFgnp/f0Awio5cC3IyTnNdBWe7Lc0q8jgjHcyufsGBDMkE64cyvWkYoZ+o3ZA2d
         QyhA==
X-Forwarded-Encrypted: i=1; AJvYcCWO/Zf/rUvN86ckvm00UhoS7tRJcF5AQm8izbxKH55jjlXePXIsMgukqd7lkiZxHWYaAWfdzfuRfg==@kvack.org
X-Gm-Message-State: AOJu0YyCkRit3OPaZotAIpOkfPGrbjocuYw19fHT67T+odz5w3g6iaGh
	iyBoOzYoxG00Qsn65basNwRMqhpGPj6y6IeYT0QJ7tc/kw9pYTmOBSgJ
X-Gm-Gg: ATEYQzzasUm/gRCSCDQRSKc7iOk1KMxokm542WZI0gXifrKl+BrBlM60lAca14Kqypm
	5Ej8uQXw/Wys4dlpIQYF6ei/9xVv/WBAFK66ivNTLWbdvhW5p4oGVjBOrjASMio2tLakgjXTvmG
	0x4W/82KMKNu8c06MqZnnea09IVOIMW7Ptme3EOfh8gOjL88Bi7Zytyh6cLi5AOajTbgj57Cta0
	0IF4TygPI3rr7G2mKSuCalejfx64ItWgbH00R81x8CDm1rFW/DP5W5FAaQht3qNNeSoh5vDWsdC
	h1K1FBWGAWB7rruFV0h1CB/1vmwd/2+TdjhnTJfRsn2J2RukVIFa7gIGEPOAZsq+FSxqlqtUEyL
	iyaG6B2rY7MuX0OtwV7cmtJbCPzShZ4XmTLunEG8l41fxaHE7XscnAfAJyvPoxhNGC1jD48N+5t
	d9M9PQ008YQiYpNcM0
X-Received: by 2002:a05:600c:3e86:b0:477:9cdb:e337 with SMTP id 5b1f17b1804b1-48526918f8amr62531485e9.7.1772835113989;
        Fri, 06 Mar 2026 14:11:53 -0800 (PST)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48527681a3esm142962435e9.4.2026.03.06.14.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 14:11:53 -0800 (PST)
Date: Fri, 6 Mar 2026 22:11:54 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam.Howlett@oracle.com, aliceryhl@google.com, andrewjballance@gmail.com,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>
Message-ID: <b796ccaa-242d-4e4a-a9f5-b3a91f46f838@gmail.com>
In-Reply-To: <20260306133321.4fa6c5a73067bd179a5e888e@linux-foundation.org>
References: <20260306200820.2819999-1-objecting@objecting.org> <20260306133321.4fa6c5a73067bd179a5e888e@linux-foundation.org>
Subject: Re: [PATCH] lib/maple_tree: fix swapped arguments in
 mas_safe_pivot() call
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <b796ccaa-242d-4e4a-a9f5-b3a91f46f838@gmail.com>
X-Stat-Signature: cxb6ox8p695di38ipqf19gmsb84zafe9
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D815440006
X-HE-Tag: 1772835115-618999
X-HE-Meta: U2FsdGVkX1+65ngXdFuOQHAYRDT0TJPZ9Fae63xaWbraMTVA0hqS/a5m9v/gHEGCYF16i6zwfoMAtT5+79gNT922PAcNm/Rfofje0+QVKfJQpD7ClGdIlWFjC/e1hqZmSwlWP1t4pcwlffFDAm3xP4YqRY5Y6vJq3BiD5HLbuBZUmAYmU4IME4pxssUBanlsYiU3v9cRiuCuehlfd4nGAVk8Jz742JBqpp/MQoAhMB15hhHmvXnsRdAW8+wo7u0RGE5SnFfxWbyjGuKAo4fWZbFkdYdFV4m8ai0euf+1KZh0Dq44z1k295Q9qr3wY7X5BzZDHWSt5sFszt93tQzkWQJJ/1idF/sCuh36nxlAMNVQUPEw9SKRedJf2O7f2i+DA076g+Tgbu1OC1uQqfYx7Gh8gKVEPSWBWXOS9hCsXt7bDz3R5z0pGkFDWuDb9+v6CIbrJ3K9i7Deor8ehmpZqdOVwTdT+Ow1FoEudtq/2GX2Y9uFPVPjqIVobcePwPNZX+9+eUB/TDuzP+dQX4WWWEJk2jf4dK/dzApom8oENb7/R5b3+FFjiN29RtYei3vDgyYO5oLTpdC7a7ace/Tk12X0qTc/TD+QY0zd+97zTTR6Dsc9i4ioR2SYTKFSDh4rcdZZKn6LvTZboWxORYq6ZZ6bj20jjtCHNq2Qgc8uGGzA5NW41q86x2Vbm1baIiafDhEWVhED2JsJ+DqNY5RtAUx1xoA6LAeGWJD/gFhgF0uUDN/4+OO+l9j1dsUPikgh21VcyCKhZ5lZoqLGt7+27Kid++Lw6dzpBJhrNVXm5ZwBkc7TTjc4UV1k5kx1uBGu9qfp9pckYz8TjG7iZps56b56eDPtQAsj99mDBN/esI6tDL4F7QsYYySnLav+e22xKGASc1llbHSt4Z+PTsF5UKBeOU1QGnRa5LzTL0PSfnpi2On0HLNKHpw6J14so3d7CahYBUvFC0Y/dRQwSuT
 hkuCbakm
 rbAvQB7nrA4sCDl0cyKHcRAJVKvZLGxC1ZobKSfTUt96BeKI1DXgAZUO22ld4fkQ2+yiku2ArTL4BEJrPAwP5rSWOpHfH98vgWW+IM3DIzP1Ij5WcUkSM9/MoShp88wz1d0QYN9r/fiQ7/FzuFViV+/p4vKncCuKxpW5zkqqU7kjaFFJysc/fBXl3L5ra3VOsY8Y7vju+xGkWPTR63o2xcOHYjiU72A5F+PH/iErweyzO0+FvkK+zeGwlqhy6QD/Pj2s0A2b2gyhsI7mPFjBM/n2nhFQhYAsDiI/GLOpi8IVjt6p4yG5bjIyYqCy/fDgjHzK4pSAfEU32iHBz70gqcgADTwme9D6ykj141JO0wrjYGBoPl6Uf172aop1dN0Nk2nYC+Eh1OMYks0B74tKRJ2cbBUIHljtT3yc7Dm3nHyk3p/M4eG5BrDBEWtFNmz1l7+rsKShc+kPe2j0hHBjqq1Om+eZvassRI401hdsK9i5PzGOE5kjbySgbKKiZoVYuY0eBdxb80oUkEb91xnW3qBbS6FPgcQGquPES9iR0P+IFE8FHcPZp5/WbMCYNBVb1YXUE0ue4NPrejFQxpv05wlM9TvmTmwNSaNEuJaqM0IXPUCfNq4CIH9KYz5zlsgT6WQMweZaO4npAV7+0eJN44S6Md8EZx1npcMjsZXNGThzwMN4qAe/+6jDxxnpI8AmU7HLt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

6 Mar 2026 21:33:22 Andrew Morton <akpm@linux-foundation.org>:

> On Fri,=C2=A0 6 Mar 2026 20:08:20 +0000 Josh Law <hlcj1234567@gmail.com> =
wrote:
>
>> From: Josh Law <objecting@objecting.org>
>>
>> The call to mas_safe_pivot() in mas_wr_extend_null() has the pivot index
>> and maple type arguments swapped. The function signature expects
>> (mas, pivots, piv, type) but the call passes (mas, pivots, type, piv).
>>
>> This causes the pivot index to be interpreted as a maple node type and
>> vice versa, leading to incorrect pivot lookups. In practice, this means
>> a null-extending store into a maple tree node can read the wrong pivot
>> value, potentially corrupting the range tracked by the maple state. For
>> a VMA maple tree, this could cause an incorrect vm_area_struct range to
>> be returned during operations like mmap or munmap, leading to silent
>> memory mapping corruption.
>>
>> Every other mas_safe_pivot() call site in the file passes the arguments
>> in the correct (piv, type) order; this is the only one with them
>> reversed.
>>
>> ...
>>
>> --- a/lib/maple_tree.c
>> +++ b/lib/maple_tree.c
>> @@ -3279,7 +3279,7 @@ static inline void mas_extend_spanning_null(struct=
 ma_wr_state *l_wr_mas,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (r_mas->last < r_mas->max) &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !mas_slot_locked(r_mas, r_wr_=
mas->slots, r_mas->offset + 1)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_mas->last =3D mas_safe_pivo=
t(r_mas, r_wr_mas->pivots,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_wr_=
mas->type, r_mas->offset + 1);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_mas=
->offset + 1, r_wr_mas->type);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_mas->offset++;
>> =C2=A0=C2=A0=C2=A0 }
>
> Whoops.=C2=A0 How come nobody has noticed after 4+ years?
>
> I'll add
>
> =C2=A0=C2=A0=C2=A0 Fixes: 54a611b60590 ("Maple Tree: add new data structu=
re")
>
> and maybe cc:stable if we have a reason to do so.

Hi Andrew, on thought, I'd like to add Cc: stable@vger.kernel.org to this.
Even though it's been 4 years, a swapped argument in a core data structure =
like Maple Tree is a silent bug that could cause rare corruption. Better to=
 defuse it in the LTS kernels.

