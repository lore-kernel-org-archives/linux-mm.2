Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C46CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 12:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027EA6B0134; Sun, 31 May 2026 08:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AC96B0136; Sun, 31 May 2026 08:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09C66B0137; Sun, 31 May 2026 08:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB19E6B0134
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:34:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C1898F487
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:34:16 +0000 (UTC)
X-FDA: 84827657712.24.850BF71
Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	by imf28.hostedemail.com (Postfix) with ESMTP id F293FC0008
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:34:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=KlKsRsJL;
	spf=pass (imf28.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780230853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HL+wohryqOhpKGEyagy/lOHeWmop01YnUKtre6cBpa4=;
	b=GUwCHcTE49q43vqSsb48KEx+K2b93FdrLePiqxQ6BDsJTNqHl6X1C7D2sY2ZneDRl20++1
	eexqrkVvQeP36z71ed0oVishjudM/Ods+agvwvCQ8U04x4GXpL0ZNaX0U0AX44WCSfUMvl
	qnJ4bTWAxuzIvCyZJJth4zwwZDAMMJE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=KlKsRsJL;
	spf=pass (imf28.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780230853; a=rsa-sha256;
	cv=none;
	b=eaNTbZpzQ3ZvoldWBoVVuWJ37tw7Z4OjTzaHJMajKlhLo7z21OTP8Snvr/j9Y3H5FbOoWi
	SjozacB9AWgvyORlWSH3HeKuyNie8kdITwWwnMZn35aGqhmQ008GrmhzDLMDwNX4nwhDrb
	ySFIHVBoVIVBM/LOMKsJt1O87HofJVE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780230848; bh=HL+wohryqOhpKGEyagy/lOHeWmop01YnUKtre6cBpa4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KlKsRsJLZ3ZLT9ffrwic5MT6BmS572gbfCGbHY3YA7nBJtZNAo+KhxhsHqvCatQXu
	 gzr986sYUxHqbrXMMRCytxque3qSPe46FlkPMh9/FDejfZ9/2mfW9rUjSVaNscicCZ
	 54SO1Q0XQ7MThGmu+ynrl8M5p7UY2/PMUyH0FDTA=
Received: from [10.24.9.42] ([123.112.11.230])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 88587460; Sun, 31 May 2026 20:34:05 +0800
X-QQ-mid: xmsmtpt1780230845t6jodq04y
Message-ID: <tencent_859FD9151DE6F13D2447C86ECA2CEAB9D809@qq.com>
X-QQ-XMAILINFO: MpYZqmNm/7vMmnst/jX7M/5lIu0zok5pcX9bgbd/L55BNRONuZnTr8CFF7x+hi
	 Lm8Pc6o+SnwpYTDFwgAUG3KGyLgs07kCNt3JeGgJh8HSSm2htgO5UwIEfhD9/OpmrqcvfI6YwpHH
	 yS8sSrdIok2pzZhn2eGrHuNTbqhFaDKm+XHadLsKV8KoXE4cZqfiaPEnQXIGoRDTuu/OfjdQI7eR
	 iCz6VW92AA25Rq6zpg7e5E50Ip7qtcRrak/13rWOG90s2I73dK2KTJ/LdDV6avtMfVzEdlSpf6Lq
	 Vb/KbDAVuggLvjLkCucUWzTL1GeE4wbkcnOQCpoxlL3bfYJWynDftEwQ9iPkJQe18bfCNLSO9U0D
	 8uCyyfay/mOr1ms3Giv7DNGyRag8dehwGeci7erd+R4tJpMWrAtgCvp7V/z56Fvp5ML18vwKulc5
	 7+isBuSeeNmymq4jzMdJm4WNUFh05jyKXNNL3c3c3cxE21vn6Jvq3vJ1dK1TKivm/l7D7zpS5jmk
	 +iXN0FfFlWP1HBts7x43JyjgKR3XHodb4MFTRDGttRpK0tkJV7tVz26lOwdbAtAF74Oelm//ObEd
	 GsBOI70by6vm+WZlqnD14CnlfWGn8/Klc+2F+H4VqCPFErxDR9/YUvGd9Mfw/AgRS0LT41bnosnh
	 JDW5f29TY70mAqdP/933Gbaxyny0dwDyKZQg0k12lGmvUEqtn+3pgyYRSQiC/pqAkA4OmISl/Xrs
	 0BKnbWpxQRUVU5WcCWZkY4ikC4J/bkNCkUXpZcVYm20PEXdcTkYr70LMo1hGoDImVA8ag+znDSHF
	 3Br2z2IwOVHpCJIFKMAWrPSlGpTdjnDw9YVocGAHgx5n4xRE6/0dumHk7O4j+wfkDiwtqhi+KBJs
	 BZuw7XZ6Y1Ei0kFPhti54DHQcxFNH6zwvsTXTckqQCnDyn2F95w5YeoLuFBdAy9QQrq3MJHcn+HL
	 U0fMaFsTEoMfpFOg5P4zdWtUw9DfNQmQBJrViqtqSfjzw49QsJ54CKUILaO8t7kUb3RMyqHZXJAM
	 gpM2KTJy7zj+FTDA/NwvqnQZ5qWUaXKNbjgt6noLGLo/gje1MiwKGsifBCBnRPY1QbNstzt9BIYn
	 Cux1llYlj7+C4jvq/vkTJbL+FNy3TliHAvzriFrBY4YeghhB04c5T1bBPxpw==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-OQ-MSGID: <fe224381-fda2-4d7f-abed-49387fc9872b@qq.com>
Date: Sun, 31 May 2026 20:34:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 4/9] mm: admit large swapin by backend range in
 swapin_sync()
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@meta.com>, Usama Arif <usamaarif642@gmail.com>,
 Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
 <tencent_EB78848E34DC7858C873193D67286ECD4B0A@qq.com>
 <CAMgjq7AA_1esgtA8VyxaBLWBBRM12bCBpxO2Jch5OESBZSg--A@mail.gmail.com>
 <CAMgjq7AQwF6oNpnGTxxJWb=oyZ3dLfPL4oSNoS+eQxtuzZPgTQ@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAMgjq7AQwF6oNpnGTxxJWb=oyZ3dLfPL4oSNoS+eQxtuzZPgTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1m49tpqau5hytkntneyppretwq5c4pic
X-Rspamd-Queue-Id: F293FC0008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780230852-99850
X-HE-Meta: U2FsdGVkX1/N1orWAqkc8SfSTvouBz6OMRtvv46PSzttB1jdtiCNgbBFw4+x+rrIU2NMAKIUaiVj0ih/tKvYp9uynFz/vJRamDiXOf1fWKTlITJEbAscpR7CJMwVRVZ8zuu5WOwHlZR0FsP/N7EyoXguDv2UA8Mo5h4o+ZZayEyUhgo4qkEJFZiSu07WUGZ1ZiC6qkUMvpapOV/Rtp7yqioF0ZTLOXK2zEkyTe0Ct6C2imJfH/qBDhaPga3rKKwR4deNxy4TIy308nBxx+M4m4UjszL74zs3ykPC1oWe2omh2HUGUBsbKJbyJ+jyPoqwZKrdAufLKzsHDKIek0zmrlFdfIBLGyiQO3v15exrSCrLxOurKMTsFx8ZgWurqKwSftp/cVeAOx/Ru/lCd7vDOt4sFmjEpK4mSElF0DiWWrPxjlGzulG+LhyvLJJmrbjO82E3O9vIH2aJdjXhoxPQ4lvacdynVbNBY5iUxF1yk1dPhtVnc7UVtd9inUDC/kvyBwFfEjvtAwqHLQ3vCqkoq8gxnL4QxD1kaj/Rz4QYEkn2e+CGxeYKEUeaTzh1y7g+QFdz68QSPwDQ/k+W8AiZqBWACF/l5qBICchZP6VzpoLyti0V5WWoYUzGAoB7oOatYia7r5ftSXWqy5yBuC7WCwBObch2uz/fu8dPRYYOIX3AdHVrQhca9FquU1228vTHHvfSFrcgUcgfLob9jzXJeERdeOMkfK6+PmJTW66TS5Q0hsCBlD3cPPxAV29CI1r0VOylYoKYQbac6xDIbcxbhfVYQ7GnXMh49Irz029n3oCqVw7T75zW6xxahGbbd9TBCfIxvjYYHst+SHB/PIwcq7sUwf1mdyXikUjG1R/G8c1LmRk6nSaM5JDs4UXmrz4pOCXDOzigCTq8YXCokRLVuN4cPgL9Jf0VPkVBnKq6alyv8iei0QzS9eq1+W8dRXkJgyhpQsJS85kw6RXCHqb
 5/hjbiZ0
 412KIg+H3yTOMYRQb2xyrzqNfxjoqlXyj+LV/FSBM4JNU9LJayDPeiTDxw5ftCfpxe6GeY1XRocdOjPZFpe4jsON98522nfNFwVqJfH4stsnTJ5NW+UVhiR+/2KCueB5i1gKsiO6AXfMMNapbF8W8XzQLheAiHyZRr4CruN4N9rLrLItJk0CDLJ5BwH6i+4rk13MyURay3r5khcSkeoue64kFankUHKnSkctnPACnaRbNSX+rH8mk/jsKPuQ1q2hCH5zdyrPWcpEUL7IFUKKLOGk0uYigyM2MQiO3mePL2ecrALnq4WavPskBkhChTVyolnKbAstKHqe2MNQSNAQNTXJMNxQ9haiO2rV8uzGV9fPKLXdbq5UdfBd/Y32G9TpZPgkDqKjblA24yIBj/TauOFT2qAd6+nPtQsIfpCogAYxPyEJV3ON/9OK/p3BBRw7T/Nhi6hIzJyJqfkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/29/2026 10:45 PM, Kairui Song wrote:
> On Fri, May 29, 2026 at 10:43 PM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> Hi Fujunjie,
>>
>> Thanks for the update, but this whole defer_memcg1_swapin thing is so
>> ugly I don't think this is the right way at all.
>>
>> If you really need this, maybe you can always defer the memcg1
> 
> Oh and I'm not saying I'm against this series or the idea, I'm just
> saying this particular design of this one patch needs some improvement
> :)

Thanks for your review! I will improve the implementation.


