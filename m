Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCB4C87FCC
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 02:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F5F6B007B; Sun, 27 Jul 2025 22:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9796B0088; Sun, 27 Jul 2025 22:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791356B0089; Sun, 27 Jul 2025 22:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6545E6B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 22:09:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82274137647
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 02:09:35 +0000 (UTC)
X-FDA: 83712041910.21.0485ADE
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id A2386100008
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 02:09:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gw2EI3VE;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753668573; a=rsa-sha256;
	cv=none;
	b=izu9uUY37thlStJvFz0PpeI60Q5BYfwEaEvpTyvF8oXMTVTVy73uIS7I4Cdv6Z8gcPBq1t
	/a31DcP41Fz3Ehvf3FuWJQspV3V1NXVtJZmuz2ko43bq7ldAi06CVAwSg28dWLnDhk554F
	R4yKH2JRtJ6DLPBT4VyHLWnZgm4ttiE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gw2EI3VE;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753668573;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SegYKAhN6ojNlpIAhHg/DIVFTDWS2zr1wodaWRquMQs=;
	b=26zlJ4PNFXzXF7IfTbkd4r5gPO/EQ1UG7/WRLchyGJ6ogAevJ+vSVj6Tb14ovzK/7U3goZ
	tPBVh0fGlqd5GoXeIrQ55F57OadL5quyEw7Qj0ydU0lJ/0CWXBx4ZIjlJ8sg+iAT+YPP9z
	dinXPQCzQtFMlTcp1OlaFJ7RobnQnfg=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ae0bde4d5c9so741713666b.3
        for <linux-mm@kvack.org>; Sun, 27 Jul 2025 19:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753668572; x=1754273372; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SegYKAhN6ojNlpIAhHg/DIVFTDWS2zr1wodaWRquMQs=;
        b=Gw2EI3VEpFCOCa3yHMHmd393sqm4HPxD3tICmZ59zACmP52MpwToFhpYeMyQJ9jicY
         0mY8KcpOBDXdqZXzyvnGDKm3pGVmX+myZZcuQDV02nmhE8MN5xbFK9x7qvzEXu0V60R3
         iwGdDZ/p/f2w+VoUVPJF1Em3PQA2LQWG9CDV4q9TN7v8udbGzLF/Lt2Ss5m+2qajgRnN
         ntR/mWuka2fA2/ZR7MoMEaSAmPlPesNY0VC1jg2sWgDdSzVEG1JN3PQyHZVx870jMglD
         7paGc5C2rympph1zE0EF+1AQysnh0Eq+SynvRGBupgWrIP0o19wp+mM/EA14PlTI9xCu
         7Kzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753668572; x=1754273372;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SegYKAhN6ojNlpIAhHg/DIVFTDWS2zr1wodaWRquMQs=;
        b=cjK5Ml8I4qimKJbFFYP+HM4fvqv9Mp6oyI2aCUQDbpqhqRvQ7cH/rNus7bh8DCh6n1
         +EHPnKgR/nMEj9T/XF8Ki8jUpa+9AxwFai/BZePf4AwFDl51pCOlBCax8SrGE+Jd1zVY
         piXwr4uIiiBmZ5LVRn18Qeh6+3wtCz1x46AQplUtVhFMBsuUyyyZDjcEFadRGlto5LQ1
         6DPxDd0jMFKtxOGKstYYYGw0oZ1fDHzl29HL5NGquwHiSRK8Yry136kcH2LRnH9HBRIi
         FkpbXtCNbHbFh991EgiCjq731zPHwxh4V+xfgxPJsV9Aqapvtnj5mNTYHv8MrQlcO4OP
         FnvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQn57puIegcKn7Qy+m45DZMFMUhVCkiYGAKiTwxq1+z75nZg5Q0zsrfgbvdcMUdN4Xh1hYRazJBA==@kvack.org
X-Gm-Message-State: AOJu0YwymvKnYf9Ol43mH2dDI+6RalZLwurexs6E03LVUlwSCueGiDzn
	iDdtLma9akJ+ZjlNesGdDFc3ZIkfk2/r7Y0S4AhFxD6Vnp9bJme+RH5D
X-Gm-Gg: ASbGncsJ8ov/cZeUvQ05moj9qOwJhDh7+YLwisv/o1qPv9fgLYs59YWwHD0aA98pRmS
	lI0Xc1E9ZoRiO58o4k19FT7qZNlQXO387ZzoeRQYeh5yWLz7dUW4tj7m/fmJoRZrS3G14ByVQ1Y
	g+4aNCFpTdxyPuzXMvELB2bd5wMQTtaFu4mM1A4CdGZbE4KnpWFBjpI7Rhcd568Ub0pjj+W8nqM
	y1qAvxfuz2mzbxEsEobVd1EN5SK09MKjw0qmTU0Sy+6Sl6GBE8ax7KWCgd3QtRLsC1M6TCqPcPx
	XwVgk5dS2byJM6wZBt/rlNH5BApoWwLl/5GBhlX05Kq6IdvDjedOapcw5/H3pG3oeO7jF6cTUlq
	kP6F2ItK6U395DXztwLwbiQ==
X-Google-Smtp-Source: AGHT+IHBh+AF5LYeeeuiwJHnb1+ByK7ooa8oMb0KBXNw6RrvnipsnZg9FxEjZFKZeUcJVTsmgY+MnQ==
X-Received: by 2002:a17:907:3f12:b0:ad5:2e5b:d16b with SMTP id a640c23a62f3a-af617d0b1eamr1253813666b.27.1753668571717;
        Sun, 27 Jul 2025 19:09:31 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af6358a2743sm359227966b.48.2025.07.27.19.09.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Jul 2025 19:09:31 -0700 (PDT)
Date: Mon, 28 Jul 2025 02:09:30 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [Patch v2 2/2] selftests/mm: assert rmap behave as expected
Message-ID: <20250728020930.w7sv5eccp4kcizts@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250726025223.350-1-richard.weiyang@gmail.com>
 <20250726025223.350-3-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726025223.350-3-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2386100008
X-Stat-Signature: dm1fihr318xbxndzzqif3gzsxcw876bq
X-HE-Tag: 1753668573-14968
X-HE-Meta: U2FsdGVkX1+gDrU2anOS+wUEkL0d1WBjAxreGDO+W2OrJ+rNA7cPwnZZM3qh1y6vcZK8VfTmp0LorfhKY9BInO8Vmk3V7hBuMQi0bCm10tQyaXPTYH0NmXf/ihvoroan/FRWPaRA0mEr0AXJZqJRdyeE+f5im5DuVsa3qTsD08+01P2HrSLlcop139SdBBJrjLv6YrvcXP26YR0452j8tY9rFBhXjmKA2u5OalLzsOWdMp9/21aaKyy59x/BKWA+CpGAHETdd+slTCBdHC52s0Gt2Zcjhc5yI5R2zGOp8qotEhfzjdbKWgE4G8KgU2LjKuq25tLdIxexGg7NV2/tuVa1inWNPWYAMuG1eRYFTi/iLfQqALhIQVzUWH7IckEUvRA8ILLrm6AawGnDdIMKwXYB4F3AR6YMvkZ53rBNv7h2NGeWyrVoO8zyEYVzTs3aGbt0LFjNk/0IxpW1o6FZWDii6OBv95DOWtQgm6auyXmcgaKhOho3M871IE/7f6Wk+kEp45JT98QxeRf1qWQWlUUfdgf5qaRrWOaiQ12wW0/Dh1Dcfq85mPDg2r3kP4SvsBKiJV7bPCpZodSTeQ0/BAITgAgheKymeXGwxHfKPjBR4955iruWOMt9dBo3aU3rd4vkOmPfz8amEyS5CvtS3tTa2ffYyAGTwEM+cuW35uh4/b/dYU+DZJQpk9WffTSyw5Ct7Wn1YX6TcAXyQ0S+FqoZTIDZUKkBDcxr8hRNhW9IGv28srm6ZWlL8XewzkyrBWYXZk0BCCx0CT11aBb4dL4t4VUjNj8hC9z9Nt+617qSaVKiqFkQLY0PvTsC3wDVPjp+cVS2nBsBhTayiXNNELj9NuZgFhNpCR8sUHT1JnLS0UDayCWo4/eh7EGEAnontmU4GT1MxbzYJBB1ZMDMN5IJR99bxvkJyGpyn3wgVXHtatV7nQay9JfoU5s/3CEWTYQbprUK3cMaW1xkPzJ
 RbYbud0n
 0rfIehEqdN1s+is3VsUWM5jcDeAf3QbjH+Rgx4thTxHcq4niW1WZKEJedb+EfuRbKT/qJIUfdUP9Ml10mocokt83C9GycIsL8toXrXCvuhzzQzoXbF7eupJaMA/JTtgLXPjLGE31pmJfMjL/4CZFBsZFHyenjIiKrsXfPBGP3SZ06g13IxzzG/kNOHcJSAGiNVQszLn/l8oeUslRe21NPi6/bJ7rKOk6rxx07vNKZmnEH9mKsLnOC8tVBvwQ66VLp6yCPNa16N33hlrw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 02:52:23AM +0000, Wei Yang wrote:
[...]
>+
>+int merge_and_migrate(struct global_data *data)
>+{
>+	int pagemap_fd;
>+	int ret = 0;
>+
>+	if (data->region == MAP_FAILED)
>+		return FAIL_ON_WORK;
>+
>+	ksm_start();

Forget to check the return value here.

Will update it.

>+
>+	ret = try_to_move_page(data->region);
>+
>+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
>+	if (pagemap_fd == -1)
>+		return FAIL_ON_WORK;
>+	*data->expected_pfn = pagemap_get_pfn(pagemap_fd, data->region);
>+
>+	return ret;
>+}
>+

-- 
Wei Yang
Help you, Help me

