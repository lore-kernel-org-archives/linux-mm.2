Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB86CAC5AA
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5D18E0007; Mon, 22 Sep 2025 09:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD958E0001; Mon, 22 Sep 2025 09:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC468E0007; Mon, 22 Sep 2025 09:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B77748E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:03:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6465A1DF50E
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:03:00 +0000 (UTC)
X-FDA: 83916901320.23.B1258D1
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F2ACC000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:02:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JW5Hm60T;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758546178;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zogx78RQaEiiWpwLmGWXLgq8KG8SPvZ4z9V+PmCx9u8=;
	b=gwE10uIETzfaIFdJ41t4hYQ20umjHYLpUM1IBDJWBK5dnpuL999Xgu2rG9AlHknhO8sbTW
	6YcK6WMFwnFHhuWIVxnTrJ8nhU7tWYbyUHM/3TpAwdARgu6gG1ZURjJfvUd+PnoUN/hDjD
	Tp4OHLaLHFkGayTCUqIuhp5jzw0QCes=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JW5Hm60T;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758546178; a=rsa-sha256;
	cv=none;
	b=YWDlWGNCBCN7qccA11uPzkNFXOTNX9adW1UgOfBf6qgEaegJVb58TzUHKHYCSR93khLfS9
	mhjFWuQBIE0rPaCK8Q3C/3wsUOewKu0dcoCJhkReef2Zq1+gKwpErUAH8OQiMs5NLx4iOu
	00PDeucVThSuIcm4zLn4fwGPwMpsuFU=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b04b55d5a2cso797163866b.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758546177; x=1759150977; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zogx78RQaEiiWpwLmGWXLgq8KG8SPvZ4z9V+PmCx9u8=;
        b=JW5Hm60TGMra0Rg8l6Lo+uoMZgPf/Op9DNInh/zD1KE4c5azeWqjBDXIKvtcallBMw
         69zxdWSGb+g9l347jrKksWVOURvbVupWMjiBliTt2VZhFSB2eCr+rI9tDEIPlhydzsQ5
         F+VHNWqZS8sLEF/GvBZfi+7QcQp3ruMDT5N3LhroMMKdtIM2B2vPeeCxpyjjYlqxtd9k
         8/vwuRGkFq+7Y+GpovdZYaC8wHav2x6a8Nz1xkflX2MT5RO/Y+cL7h0MENtmeu2RVwOs
         BcmpT9KOPKgB1YWGHpjTSDuOS2iHZKBzQUAU7k/dhPS0PvJzAw6y2y7Rt24OdqWhE2ft
         L9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758546177; x=1759150977;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zogx78RQaEiiWpwLmGWXLgq8KG8SPvZ4z9V+PmCx9u8=;
        b=NL66V36TkmlDefj9A1Xpp5H6nEyicAFN/NPRj4DqCYx3N5P67KdJwJzPO2vXUY8Cs7
         tb9Kxybk/LRU2i00kuUc3U0ZClV0kq06v5Q0Bbm/GdpkRmqe958PGt+UuJrz0ZteNwhN
         Atcf+hzpFwQnZOj6lWE8fQphxef9pSckO2Iu0m+/t3BhxAiQpkEmvINaWkUg2gxGk3d6
         HgoleztptFBMCESI3XB0YWFqgSZgGO6SZsAUatyNsYRokTpe5khdlYgx+HMp1WSOKJct
         lHCkkE4fDXVAQAae6vVLLMYvvUCAxE8IYvuk6DzeORj8G2PhkItowE1Oc6uo3E6IzjB9
         yNwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfGnkz4qIpQcS6ODFfTDIoxWp2juLaNGVh+R/Zx02tviZS2//PRS62Ovi14MnmQZpSXK3KGXZStQ==@kvack.org
X-Gm-Message-State: AOJu0YzdfB/wfzOB0lmlFkEs39FHIDPm/OMjHu9rWiWzPHJaBN1AnmP9
	2JMHjq0IYvH1qpoM0yZ5Cz4SfvPcDWFo6NPlu92w0QiYG04Bm71JBIxDp4cJUQ==
X-Gm-Gg: ASbGncugXzZvtu786Inf90c0FtzGG40C0wXZj201j/j3KRaS08wSOoGOE3EyWkjH1tM
	pKG7DHwPLH8oemCydBN/IHbfsxayHfYZUzeQuNWbj+b02WgixBiEjWU6ozGkn8VFcWwYACI0fCa
	BeTtxg0sqMqrknPeAM/EkQm812W5HcBIVbHrmO1o5kTjCWCoYUHzUJMYEHnA2Jpln/fSBMyJAFu
	JmX3Oh+eR+lSeHeUvNvMlYnuWQO1/oUzAkDX/QEJPz6Qva4FOTrZdn6awV6bhKbkphW9Y5JLYXS
	JXC+tLZuNpgaCIY0CFtcbgHWg0upnTpkp4t6CbqAyJDh4dqp/eovyUjOwLoafxSopm4niQKrwkq
	RAnEZtz73LAK3mq0Uj5qQ9A==
X-Google-Smtp-Source: AGHT+IHs9uSn5TVye+3e+TMafMmVMcWcNI0qGGpPvDEMl3EA4p0vpbWXVLSM3+wyH3lGc6p8lpPMEA==
X-Received: by 2002:a17:907:6ea2:b0:b2d:e514:534c with SMTP id a640c23a62f3a-b2de532dd6fmr176674666b.42.1758546176397;
        Mon, 22 Sep 2025 06:02:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2a88413a9fsm399574866b.90.2025.09.22.06.02.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Sep 2025 06:02:55 -0700 (PDT)
Date: Mon, 22 Sep 2025 13:02:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
Message-ID: <20250922130255.lbrrbrr54iwso42i@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
 <20250920090228.lovkrpwj23bqdamj@master>
 <93095f34-d7ac-40c7-87c7-60d2c64d4800@arm.com>
 <20250922081226.hsglokm74lh2eng6@master>
 <89afa6d6-0a02-4825-8923-3752397b38dc@redhat.com>
 <433cba08-e33f-43ba-bccc-a2b1f2b1cd50@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <433cba08-e33f-43ba-bccc-a2b1f2b1cd50@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 4F2ACC000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: yswwnocfbwkurzygji9jhunzkrxyb634
X-HE-Tag: 1758546178-650195
X-HE-Meta: U2FsdGVkX1+0bSBA9e/6EG/qyyhNoj5pFmZt/k/j13rZGJX4ca+oXjDymGS7SnUZL1xrZkQbRxNs2Ur7Ti9lIz9UHflQ47ALnAsEcxezinfE5ddt5PNJ0+sWXiZ+2BoCMsrRU1UKe3a8HZf7iU/Om0Hq/FLCynwWTga7CnpDUqTJO78HCoTMZMyYM7ZSP4zvEwGOGrM/TH9sLj3P6acsUIwdLLaqIDVw3cnqQalR0dcWfC1ad+4WxmPJ3fP7rkR1ReXqV0Eu+EIWZeIybLvuSFA9IlX5Xxm0gHRLUcaCchTspl9y9vJ9fUlsyhbXa/7Su5EOKJDdSeKgMZKdFGBgutzmtkn7yutYeclvWqZ4kffEBMy8NP3KCOOAtEzCaGSwQPwKQ5sl+mpo/npNzQIxR01mzEFloMS+ZwbIr6FagnYhE5CvPXwn4gOSL85vf3AFsL9x/2fA0qer6pCmnLaS96WQZALfDaaqdAa3ajl/3ssBlXtCVxzFzins+7mOcMcqyWZHrvEVE5VmA+0V56H26gWoIOHCv9t5s/CjvfmfhXYadKfwwptQr50svQZ44axPjb9qa5vafm2HlPy5gcQY1ifDUBqhQ9KysMj3wVCsvm38Wk6iShk22a1t4SVZiRt+J6keWgmXAspm/Ad9+D4UehGpKWRntI9Ug3OJz7gdYaT5dnVqW04bqexjW72cRsGhPpp18od1MVBfZ/sbIbD3FzgswJvD60dF0nnSq0uvsleIMeSnYjOPHE6tSz3S26FMNQLs1d6lQYSY5qVnfoFiSettIVzHu4hw4xS38YWkxlQEJrErlbYzdeUDBld6K9gAhoFevsCf8chQFwFvHdMd+Wea1e5jhfMDUQ2+C4aasy/kNuS+IrymYT+pfERbmnsGpVse5sv16t8pQJfWc/eoTvzbSs4s8DEplo41qHMJRy5WSpACr+SCeUtvleKcDzfdbZ3A7qxdCnm7NfE7FGQ
 ErWkc4Pg
 3NjR+eWJOZL/fMO/FcqzlxM82tbPGLKGRxr7BpZePY2rl/SCEx5WoCgIVh5CipMVmxNbioNzpHWgPS7W8lfeNx/xxPOe/oIBL18bTWiZUH2rdPpMakqzJcendTLOKHeUlUcExWKJat7URbKRJVfD9T2hX2wDoIHosL6zo6xCj6auY4jdGPV6hcszTFKna1qhQ0eM9HGJTuawn2Lvw15moaFFVIZHRP7q90rPrMrT9wgh8+/g/ZfhjZ7F4jF7Dp9R1dCY4DCSMe3G+Xjhj3AJpdbPD/tAf3gHYTuDRv8XAuL2f9R4/UAh0KgiY+7UIrMJjNaC9swUx3iBp+RX0h5H8cTK5uCfWPfq2406AziknCQynA/4VzkP7Ki0jn7lGDohErdGlNFgSxyYyGmcfAdT4vBtxHBQ83LmbEU1y8MB8yMWH4zVzkcxPdKMB9d9zkzEaGk1k1c3CDemPiBOyu7ZhZWuQaEGliGlAh9PiOBsxSv9l9US5jcbctqEkhYvg38TW6yLA1xnofFHvilVfos33oKsHjfiVaYtbfJmjvTWy6ttMi9+K0kk6AlzcmA431T2BPYDAWFg0kxV4NX04ce2SkmN2AMvNdXHxtQ6SLeeuHT6GGD+UnU4Q+rv+NfdYLj5HfjYEQasvfXlF0ysDkwpkcs9flY1xdvzHLMj37XPxzEaSNBITTy2gauPjqP/f6OITOPpLaZu/n4tG1ox0rw8R6YYZ0d1DaCOmdW1IjnUJJ+STUW44WvwsmYRFdiqtd0IF5jXn3znQy7ydcPT0MXCpePv4qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 01:56:54PM +0530, Dev Jain wrote:
[...]
>> > > 
>> > 
>> > Take another look into the code.
>> > 
>> > The change touch three functions:
>> > 
>> >    __collapse_huge_page_isolate()
>> >    __collapse_huge_page_swapin()
>> >    hpage_collapse_scan_pmd()
>> > 
>> > Use pmd_addr/pte_addr look reasonable for hpage_collapse_scan_pmd().
>> > And haddr/addr would be suitable for the other two.
>> 
>> haddr vs. addr is just nasty.
>> 
>> Can we call the aligned one "aligned_addr" or something like that?
>
>This works. Let us use aligned_addr/addr everywhere then.
>

Including hpage_collapse_scan_pmd()?

-- 
Wei Yang
Help you, Help me

