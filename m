Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CEFD4336B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD6E6B0005; Fri, 12 Dec 2025 02:19:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E186B0007; Fri, 12 Dec 2025 02:19:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7748E6B000A; Fri, 12 Dec 2025 02:19:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63FFA6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:19:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 094BE135018
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:19:30 +0000 (UTC)
X-FDA: 84209968500.22.9CCE97D
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DCAD1C0007
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:19:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=neGXABt7;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf18.hostedemail.com: domain of 815559068@qq.com designates 203.205.221.210 as permitted sender) smtp.mailfrom=815559068@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523968; a=rsa-sha256;
	cv=none;
	b=dlrTZ3QZohiIC1pmnyGgHkWC3LkAAxMR2PnGD53spy+k8NP/gcEeTBFFAVUxOOqm+qlRAk
	d6bshvIVb3/oi/IeU6CTdSNgVCELKApGFOBQOH/94dDgxEFgVHX1vmVrlD/DOEIpnptoL0
	+Dt8yxjdSF2yIP+opA2oCTfhq/3i7OA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=neGXABt7;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf18.hostedemail.com: domain of 815559068@qq.com designates 203.205.221.210 as permitted sender) smtp.mailfrom=815559068@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mggXY0hEXX7Wvtzw/Ni1MEaww90ZycISmTG5vKcc08o=;
	b=VZShZZ5JcLx7bDCoSUZ8ETyUhznZBd6LJbU1jGVUpRRLVPZMLpaRi6TJ4VjfM1dl1NzDiM
	f4LjnQJ5vR/cY7hJTJjJM541jESpjTpJx16f9FW+/tX/Pv3judJ6z4jxrBzFQQlxHAQKB4
	kIWHN14ezPeQEScXJXdNJpWh1gswNik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765523964; bh=mggXY0hEXX7Wvtzw/Ni1MEaww90ZycISmTG5vKcc08o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=neGXABt7PD1fVlyx37UDRe/L8hvn/urFohHbD013TMezaBo0XYzgygCyaG/My1She
	 SAyJzJI1dLS9D2j0S+rqRWcxgCtXCAP+gZ4BH5pg6TwN2oYjL2NhESsYbQIRzCpZua
	 b8L4UVbsLQi6iZuoKAJC1OQ+FyOLclzLVjvlL5RE=
Received: from [10.16.15.221] ([116.7.234.240])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 4D794A84; Fri, 12 Dec 2025 15:19:23 +0800
X-QQ-mid: xmsmtpt1765523963tk375veap
Message-ID: <tencent_A2549F7433365BF2FC86A5FE39F888956C06@qq.com>
X-QQ-XMAILINFO: OAope3s6+8XpKB6h6zzft/8TsuoDRsDaH+tVKR3+mBNbVrL1SYJkjnVEQJslk1
	 ngCiNEnOqBs8DpbcjiOG5OvfQ2//VufwubLxY0VN1S+/A2Gb/WoqpmnSxDACldyYYLo60jmFEg1s
	 fKWK0F6OczXyIcSF+R0w+0ESpcjeKmrZ7hn1qpP9/Zv7Pduj7RN9k7sUaeaFXnWKFqGvoOdzgfE8
	 2z3sfyuqSXTtR+AbITHG85lazpNVTK7ypoagy6amoIiaPThe5cZN0KvRdwnFY0CPRN7SAoA3XbNe
	 D2WNUnSsJpZrLQFySC4r1I+3xne+EQV3s1p+VG0PYtOM76J0GO5EMqsi/PPJpn+WuiFk6sKLvQgf
	 s2hWcy+uqiWKy/22r2hvWtdo+vui0FVAYcSxVylxTgolimy11sGlM+MllrciiAT37N3X8dfDBSrU
	 M9i+fhwT2pgb7I5WI1mjNEFeWf/g6THTWrIYuX1edXnadBkOFeGOWmb1NFbanCksYBncMQA7Caj2
	 7Qjlv6UeF9QuO7A69C2lHPtW3f/BNaD0sDSuHAoAzf3Vsza5T+LAPnHMYGe3sJfbmb0hoJAtAp2K
	 8+94tuFMjsYGC5LRg9Llz2pNwbaReoXKr9Mn7rh9ONUimsLWlwc3DOts/SSId/PjiSwwEnq0yiBu
	 YH8jeaOEAZ+A+4CI47Mxca4hnJgC666G0cVKTRrMx3Fd92UiR/aaeQHn0dowqnfn+X8j5RkE8DW4
	 GhNSuiQ0fZj7+Pn7lAecWp/0sMi41Fctxm81+4OiQZIfsUQoA/ZdKYFib2lH+iG3P8Cd/0Im3EIO
	 I6w9uUSVJ07hsBQ8TAVOSny4lS0e5MQ1EHRhnoja6MIpNl5vC+e3+9T6O6lpSNC217ZCRFnJmKUf
	 /QhsD4DMsUKPxcVY5sV1ZXBHiJGxCzd1+aBnHBYbm6REgT6Uzv2pLE0OiaG1JYTgcISKV5Y3w0PB
	 JkxTI/eS2sj+k7TlFr4DmAAFMLYeSE69idmNZ15jnRqrEkNw43exEYIl3JJD5YiBfdT8mFCYo4YH
	 rdc1GKtQaKHs8eTjhb8DQDg3W72eugjFcxyonRjsSQplIbnOmo
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-OQ-MSGID: <c1b71a4b-69a5-42d5-a578-cabcfb02ef92@qq.com>
Date: Fri, 12 Dec 2025 15:19:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gfp: cast GFP_ZONE_TABLE entries to long to avoid
 shift overflow
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <tencent_917BFA629ACDD8A2E6A32C53CEA147C66409@qq.com>
 <20251211120448.817a352350813ae84cb600b3@linux-foundation.org>
Content-Language: en-US
From: Yankai Xu <815559068@qq.com>
In-Reply-To: <20251211120448.817a352350813ae84cb600b3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DCAD1C0007
X-Stat-Signature: tisdfxpkfdjj7epwayo5zwg454qit8dp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765523967-96803
X-HE-Meta: U2FsdGVkX1+hzfJVXL/Y3vJAFa+S5tjF2km4daL6AzZP65EQPNRTC2swlcf94aHxETOPhqgFOJcFQyXHWZYi4OpX2ejmCO+oD7mUN8FnqyV3p7p+5JdCFUX7boaqwCdWiEwmOhVRz0fBoqLHF7wBfTSCAujI81u3I+US2EqNBNGVHJKJ075hNEw5krDKadEQO5Trl/fx0/zbWhGB/fdhv05lrj+3kE2jDHbr/XKg8qtR5DkW8IX33oGswzxRELjny5NHZAfNFKPjRS35Td5iK5NO2vUS7nzQ004agyyHGO1eaQheNJ3Ollt4Zv3xQXU2oesnbRyyw53/qSXwakjyjKpbiltLvtvEVEuTWaplQpZQZsmkHVfuEVag53v8lIc2EMCqrulRy290UwJtsxmwpt2i7b8M9sAiCq4D4F5ba4zCWIFZAv5Ve9PgxCXvjsO9+6Iipzj/e/o+1p7C16yCjN0cGN7C3j18D0UsV/ipR7DBXxe6lrGvvfI2jdw9pegPpX8cQ3KCP/1m+DOtctoObeu6J3uYrw5DY2gTQfJyi8lHB6oKGQAiOOhIKwgaQd1xvka7QbxVoXT5U2AWer7Sx3zsYUDlbMTg3Of2Q5iH1LfxwBRTm01XZbVAD22pHWHjA9/1AqMiCWsl3vDdZizO4O1b7p6cCeJ/2wWhDEDnhcP/7Nc+L+d/iTGGAkz6ahgo43+s768ojpkeTnUbiqppgvFTEPAHrTXsSr2LsXIbbsj8uz0NVRfYI1gIkbFc58hFO8y8brf9ZPdHx0OiGZ+yUBMbmbevxuOtPPA7I7rEtt5nrQ572Ps1QkQZIL5RewbQ1VriYij2sp7vkVvFMJBhMZtQVuE3/FdWsvysoKKk4X7SsmvsL+bcE6Zloi0/7zufvFdgcTfP5ga9wlT9JY9wjV3Aoqv3RlbEZGi37RhK78E5doi6Bmphre4JpbF/drYK1A03rwmX4IBQ8UcNTAz
 CAjpNWd2
 xxc6lpcJW9upZDYfmJ34AxSqKUlli8Awh/QWKakRltqqECjRYA+/A31eiDsUK1Ru8+DML5MKJ+eSo0bGC+O+UhT/OvMfDRCttls8cwbskWzmOOkCr1BQsRBMR23801YdRItWOKgNUco/Fj0SuAWvsLvLBH3iI2DoVp51SPsbSGbYoALEEXDuC/T2B5ONk6b0CUyxHiUgw/ZjxkVJ5p0vswRNpCq7DryS3WGDONgcz/Z9IQaw9Uzh1tmObCBWk2ddlsjXvYEonXktzcP0kKnOJ+sbhUJdgQKx1rFR9bbmJaN7IStSCXh61TlWpqh76d9McN365jtrRkBoIzalZ1k5kAiaqmNDJT9TKFPONYthWqFvbwNyQ8lTxnN/QeQtkZZf4d3Tw2wxu4ix/oexnqwvvVFfF5GRH0LJg3iCsJeObWeGTHxixP5D6rzoRSlDxnFSb0cRspAnBHpwm+dXx5s2xiez9xsUKAvzbv/xi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Thanks for the review.

 > Please quote the compiler warning messages and describe how to
 > reproduce this.  Please include this info in the patch changelog and
 > maintain it.

I have included them in patch v2. Here's the LKML link for reference:
https://lore.kernel.org/lkml/tencent_DAB2E2BC61A449B6AC4FA9798C4D75BED705@qq.com/T/#/u

 > >  #define GFP_ZONE_TABLE ( \
 > > -    (ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)     \
 > > +    ((long)ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)       \
 >
 > It would be nice to find something nicer than this.  Perhaps a type of
 > something was poorly chosen.

ZONE_NORMAL, ZONE_DMA32, etc. are enum values, which has an underlying
type of int. Changing either the underlying type or the enum type
itself is not feasible. Moreover, the shift overflow only occurs inside
GFP_ZONE_TABLE, modifying other code might be unnecessary. Adding
explicit casts seems to be the most straightforward solution here.

Thanks,
Yankai


