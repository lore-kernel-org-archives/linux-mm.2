Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00440CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0858E0005; Tue,  2 Sep 2025 15:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7EE8E0001; Tue,  2 Sep 2025 15:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B69E8E0005; Tue,  2 Sep 2025 15:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC868E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:59:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF63F58B5C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:59:54 +0000 (UTC)
X-FDA: 83845375908.01.884DBDB
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7DBEC000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:59:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GlNrYIAP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843192;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVK2tUSQ33SqKWvrtmKuuwwgdgNcHcoDhIdJoECqwro=;
	b=TT4sFQIdKznVewpVqz046fR+nwEYvmtoGs7JtmECTn/+FrV0o/AZdGy7slCzN37ra6HR+o
	1Mnzkt5NuTvkWhLUFRUqHCIrW/JmUTij6tIXAkdmCoaJdhSYgB3C7UCo5EvmbZADlK/Tot
	OCrmtw1rpqcogYrCKWcGDfxgJkqF7jA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GlNrYIAP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756843192; a=rsa-sha256;
	cv=none;
	b=1vE2C+3kwNlP1YA7Xz2yG4yuLosLyifLkHADeaDqOmiUDuYv80xmMSSNzu6ibCkT1zDU8B
	ZRds1g0BH3995Z/Rb9w3ERjhRpXMvNRFb4jxoX4LwL1Fxr/b1q3cxxahuUa2+090ahtWwE
	VlPCfwgqowWWlQ2Jzd7sk0OWc3+WA4o=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b7d497abaso38704495e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 12:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756843191; x=1757447991; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVK2tUSQ33SqKWvrtmKuuwwgdgNcHcoDhIdJoECqwro=;
        b=GlNrYIAPfVyrtw4WcIS98HBYGmLWa9BhGCkTB2UOltENn0rxDrfjTZ/dN8Rp6TOfky
         GlE5krbcdDTHRfBR5BHTbElzao69LhU3287PITeYykzmiK85b4/tF6r6Qu8DQduqdE1T
         F1JhACOai0yAEXHnQLltwynUx9PBpD/2p1SgG4sFMk+YFj7WCo56xnYaZwCEW35/4V0t
         1NU6LrpVl88tvcWuEvb9hClo5CxrPhOWk/AF0RYxxmjcDksRXINbfELB0VL72IOBKXOF
         JKCne6nspjWTOjaKdYMWq6SLEni9Vt9CHRmWPPQzI5Xozg3IT0WTrkAXJN1t8GRN1YYe
         4m8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756843191; x=1757447991;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oVK2tUSQ33SqKWvrtmKuuwwgdgNcHcoDhIdJoECqwro=;
        b=eI/eE/9JLWyTb1+N9Om718Tn9JO1Un+53iTKR6bN07NU0ZvX37+NiXPFI1iB/3YvmP
         nym5b4fHl8+ZoqNlPOxBAdAVtRn60nmlqrz0eIPugOMH7ZrLJUVhWIg25HR+ecxHUJVF
         MLsGE1Lkw/fUKG3oLBBvcDhzc7RK/8alm+igcCSxMYyGgrDESZzh70besNMMIWgmKnO6
         xK7VjKcPFJ79KUUvuRhCTBHYdIGpz3aYfrrVePjCqTKz+F2UDXzluXSwgpfGFshs++bM
         Nb/p60ldraBqmzmc++nqBHpvHA8hnbvcrS1LOX9PweB7Jc5mye7QnPJTc5eeMaQF8PIa
         7wOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUlCBWucXDMsGMKXEeb000Xbg/5kB6Is0j8+99UxBSChsydZg0SmwLw+IVK/4aiYL6GQa8r+ZqDQ==@kvack.org
X-Gm-Message-State: AOJu0YzNza2s+0ATZrHqnfvJs+tM+WzHzlb+dttVwuqJYzoHkbUB6ikp
	ydrrqWTkXA41Ngd1+vyKPniYs542JJzzINNZ0LtCt8xks0ll4iXhUr3L0uXc0w==
X-Gm-Gg: ASbGncsbOv85hKNE8Jpxb0atLEUEao3N8smueM4hi/OUFN7st3S+hm2J3w+aap2MRMS
	ZXC3Of/K2yv4qdmePzUPNH67OUptmXsNyximbF4SaDvDwYKgm6ERVmheyNvo3bjTd+q2YPE8CHC
	6RjkDnyz9AD4dNL39+OfS/tqur6i2QcqbjfoBf1FE15D4OxUDCsVENX/yGawNq/A+suGW4uxftN
	yEJhBnB08DTy5lEvxE6oQyq2/QMjkB54AnalaSWmfgZWoKQMzzXpWjr4g0ujfw7T2qdtTvUBo8I
	7Jv6T/8L8rgbLQFwcWZ/YlbuyaQ8s2Duhfxqa1zPWysuV2AMszwiBO1uJrFp0Xct8J6ZP5IsW62
	XUsJx/mazxscu5Hdvj/XbEJ8h6g==
X-Google-Smtp-Source: AGHT+IHQV2oJYjYljdld4Wh4gdxE2HPUPFQOs8rCtgfrNl1dH9ZLK5M1o36UkS52Sihg1n+pZ+hYow==
X-Received: by 2002:a05:600c:1e28:b0:45b:8600:2be2 with SMTP id 5b1f17b1804b1-45b86002d9fmr86765995e9.2.1756843190844;
        Tue, 02 Sep 2025 12:59:50 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e380b77sm214291355e9.11.2025.09.02.12.59.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Sep 2025 12:59:50 -0700 (PDT)
Date: Tue, 2 Sep 2025 19:59:49 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] selftests/mm: split_huge_page_test: fix
 occasional is_backed_by_folio() wrong results
Message-ID: <20250902195949.pfjv55in3cdhxhfg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250902162536.956465-1-david@redhat.com>
 <20250902162536.956465-2-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902162536.956465-2-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B7DBEC000B
X-Stat-Signature: zsgwxcktuuwi63a3u5fgdiipmxm7aftp
X-Rspam-User: 
X-HE-Tag: 1756843192-490830
X-HE-Meta: U2FsdGVkX198wZNpgcCe7BfpgT4HA7izzt6Wd/mPmU6prxfOuTHJdAJDcj2pRVOKFDoc+jGVervr/5qeWVtawmizS7ytCk46Z9jk35jDpXJcEzo2BC4czj69YTpO0KY7IORil4293Y6l3vpz/SowQa1oMVnzctWGLg6qZmbkSwn6D6zV6Ni48w4c3wHhcCTRFeJiEArYqgn62skHsOefrSmiyVeQ0BPNQsWvpQzeD1+yIlBHuKn30JCZ/wWqwPUPmTS3KbGZMi2vpYKdd+6LqhC34cmVPjPo1JLj12LjBGyGuR+RHFZF0vySk/9rG0RqPgQPP5ao/QG4bSYNn48eGaylG0OjwGCP1wS9LiDmF4qyvC2GR+roVyqnpMzGENvtT206kt0+ON8itcCuhYnqPuvWll9eTUExV8kKGZliz7V8vS55NotGYTCesvMqHcEkG646pa8FUAC/TCz49jXDzFOmmtvtN0M/RUggx9ZUA3bOhn+RdBlHsomOwXyjJIrBHYwHNS4s1ZsEpMBQUOCZXeBo2/SL2k5izYCBJGMGbbrJISZ5+YJ9R3P45txM0IUOPnhF09CrD9M2gqBvvJNiHGlQH1YGQqEq8SOVj1xljfkDItZKKm/hd1g1AJPNuQYQLhyxWzAFAtgdQrEGyl0oh87f4ARwHnTwKHqEe6dygsFOxBBk/8hf8H+dypDjfxZaQd3hbVuqxmDkjoHuEuDzrw8u1cMArmJqimDDcMottxWIMhPixV8aPy0i8JyfwVtPTPeR1Kt5tffqCZSX3Paei6jsUifTOyGQF+tJztQWfOd06aTaT8fd6dUW2F9oc2IZUk1yN4XXT6LuEBoJ27cdmYXwrMcfggkkL6b9aovs+5PbqREq5p3dz/yr3rsulyYUGJkoS4zxfy6AbgVkLL3stMZtYw3RsrQwuAlM+4wxAY5IqQ8P3mbKFFPZK9B5iSeO1839S7+Spw7fj6LcrhH
 L097tCIY
 W5Rz9cnjSk4B/1h/qjn2Eul/pPpZQfsoYbeh384T3QXHIYpzDcLCrUKsxOKGSztD/Gzjjdcc+wA5x0DRDkEeKaVjMEr85azLZ+NPX4fqsk0U23wHYp7Z8R6OUDpYnyUJmTY+JrE1inb2/o4dJSUDfPpL9FCqQ+KghUvXoJUPDPv6zgKW4CH2+iIwrKsqODm4KmC1wY7i7O00z6Zl3Cxr6CcdaCmBf3bKyyHUxwWerlwSkQb37emc7V7nbAIdxxRD3cCCO0upJKd6S4L0ZJRQ8CIbwV1O0QOXjFISQBuzDZhFJPoSUb+1cz3HcF/rwGi8r3rmD3Na1NiJ5qBImjt8IEdN20BcAcagBXnp5emCT/ATdKh+GqOy8xfoWB3GGxeFavu/QzYETah6b6xDvxygVplY+vdyGbbZa3EVGGZ/r15UEjIUQEJq/wPaCYlht7TmuJgergW0q+SSpYiLHC5GmTVQs/Gf+cw7yJUVSXmRe4qhOin/SqFbUEUrLphERtz/B7RLxroA20KLIcRoRtcMGAe+29DPg4vEptCbUa85YI7dUBG1agXTXt/ZCOp9AzDFPgE1PRfsO4Rwu10HnoBGh7caqx1FNxyaYlIw5vAD8L3FKtY7s5P7mpGAKL+3Rn0bGbK1BbFvWsuspO8S7Z1nGIOxQEUdBJboKwvtidc2rA7dZM/DXtm+zxt4XYHqOCLDT4SnPgB/70dkU7RM0m/SiTR/yodJ6UWMHpTMf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 06:25:35PM +0200, David Hildenbrand wrote:
>When checking for actual tail or head pages of a folio, we must make
>sure that the KPF_COMPOUND_HEAD/KPF_COMPOUND_TAIL flag is paired with
>KPF_THP.
>
>For example, if we have another large folio after our large folio in
>physical memory, our "pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL" would
                                                               ^
One nit here, we missed                                        )

>trigger even though it's actually a head page of the next folio.
>
>If is_backed_by_folio() returns a wrong result, split_pte_mapped_thp()
>can fail with "Some THPs are missing during mremap".
>
>Fix it by checking for head/tail pages of folios properly. Add
>folio_tail_flags/folio_head_flags to improve readability and use these
>masks also when just testing for any compound page.
>
>Fixes: 169b456b0162 ("selftests/mm: reimplement is_backed_by_thp() with more precise check")
>Signed-off-by: David Hildenbrand <david@redhat.com>

Otherwise, 

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

