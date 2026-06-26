Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3BAFCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621866B00E1; Fri, 26 Jun 2026 05:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8726B00E2; Fri, 26 Jun 2026 05:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536FA6B00E3; Fri, 26 Jun 2026 05:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31EF76B00E1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:40:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B83DB167414
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:40:00 +0000 (UTC)
X-FDA: 84921567360.11.636A8BB
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 99E17140002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:39:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=LQYG5sBQ;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782466798;
	b=WfqD/qA0jL+aekFmXUK9fvEdz285TUrGrFTsoXp4RWwdw5pGvwPH+yKdCCl7cPaePXqJ9r
	9XUNfLY6M8R/uHDPCd5bXlgsSVgfoMMbbdy/6sLRp1l2QzUUeEKtILLkX5WNHAH2IGoHId
	v19tDZbSshfwhlcUi3K9GOFk4uvlenU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbYFlDOdrRKL62BQTd9+XWo+imzEYyLX5XadmB2EubY=;
	b=XM6nMeble4Y5LdCGEnMpgO5K6xISTBqcjVYLyV5MEMDbLsknSzti47fpSa85Qkl5QmfGyb
	GXemDIPraCjusiw3K8+7jWVQb9ykdMrN8D66IEjX4d6gWidRXGThsvXaW2mKsP9j0xKz4B
	Kpn7Tt/TrIP5j4GG4jjc/qL9gugmVHU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=LQYG5sBQ;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-920f33347f5so66352585a.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782466797; x=1783071597; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rbYFlDOdrRKL62BQTd9+XWo+imzEYyLX5XadmB2EubY=;
        b=LQYG5sBQ5XXBcjdo4MzZwE52fHN/AtJfEHERT1jTHJeea3vtMSuxJfD44YB5+V9nCc
         x7NrW0bk2R4QPtISWHUOYJNO+XSXF7NBOtIWavPifq0nKm26eotgKzgMFcaKBLzOH7Kl
         fCj12T2cARUc+QS090i4/Nnyynf/UF4r6lz6wjtSEcnNs6yzhZjzabd2Jx+4fRbZ4O93
         dLvPu+pUgSYTNU4+mqNRfIAPVsTfJHiAwJedqFQbBBd7+MHWcn87IHb8VMFj3T03/pB5
         Ohocf7GLVpmqKIOe3Wq+8iFNkUAcUDUZbvdLHFIoWKiMyp7Scyfdsi8Cl4T490BJi2V6
         aNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782466797; x=1783071597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rbYFlDOdrRKL62BQTd9+XWo+imzEYyLX5XadmB2EubY=;
        b=fS4D7IrPa2A3pzGBhUICdFNkitSP5umL827kB3JhsTjumPRypPzqlf7lDWsIFGFtZ+
         sj1yNPA1aA2EpTWg6L1RdcnC5hWAiwq0RAcYtVaOwwLb8C/d4AIVwOUbn5KYCIcs7rIR
         vx46KNbKTEacsxAdWPf5DFpydQF9KottLsinQ2tkygD2yY1+1OxYH54QrpibapNHPM05
         bWEg54Vlpr6XSCvQIpEP5Euu3oNzHkCfkIN5Z1Gic9bznb7J7e9MxgwpUuMkqsU/wFAS
         C/lz8zYIR/apkUNifRRX9UmiIvoQhVZF8+ri4R7Lt14/guQJoV+1ynb2ARPMXnGZ5FAh
         HcbA==
X-Forwarded-Encrypted: i=1; AFNElJ/0bdVaQwdjIhrGB5wD6EY4LJ3gEqpQmyLhvF3siVbMhu0UP2zgUodlmUH5QfdTFGp2GngcZ5XOvA==@kvack.org
X-Gm-Message-State: AOJu0YwLz2M4HFPBOnAwa3eIPBWFbNGwuHdB8gR/2gnzJO/zN5cjekvm
	7/qCdmhjp+rxB+0Nh7f/MsYArPIRUclVnbjV2n24TGOGTCciqHmzoSSYv8p+Qog6qcw=
X-Gm-Gg: AfdE7clev0Eo7++uhiXO+dd9jGpWXEyEOCVaEGJbFz5MCN6JZfw+2JnRjkWYW3XnR5d
	lH/nmm85qkH47UbePvrPccwNZGO8wKEET/8zuypCZIqXwnkwco97DtIhEiuW0Bg+vFaI12UBxpA
	ekW0AiabvHX1hvyTC5nZ5ZcdUJcNTtgNG3JcI5iGZ+dgKzHQVblpUKWBjAX42PfUG1b1+IyV2LX
	mR0fjgMWs5TCCndYQyg3SYKLoEDBZic6iAS8ElACvWX6O+kqKz3/4kYIxtdt7ejyaXxK6MAdV0o
	Sua+wSlgPfq537PEq5R4TpNa/rapKRn99LN7S86Z1LsXLMESOwTNKFlQ2FflNabqzLeZuS+3/Uh
	hroYL6NDJYKzpWeBkj+yaZbL0ErBPb7x7o6bgmxonbs23N0TPtWDOVb4DdInJybt3O8wu8cdW8X
	6Jd0GES9ZLA3c=
X-Received: by 2002:a05:620a:4056:b0:915:8f76:8005 with SMTP id af79cd13be357-9293cadf811mr996276785a.47.1782466797609;
        Fri, 26 Jun 2026 02:39:57 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-925fd391b22sm1107164385a.2.2026.06.26.02.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 02:39:56 -0700 (PDT)
Date: Fri, 26 Jun 2026 05:39:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, muchun.song@linux.dev,
	peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
	roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <aj5I7JAXWlTHRyEW@cmpxchg.org>
References: <20260625151554.55105-1-qi.zheng@linux.dev>
 <aj12aVq3he6q7b2C@cmpxchg.org>
 <4c7b0c46-14f0-4a62-893e-e50714e09b74@linux.dev>
 <46ac28bf-5be1-4600-b522-0a1aa76c28e6@kernel.org>
 <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
 <afdaff7c-fe6b-40da-8f54-aeeab8fe8867@kernel.org>
 <90fd5300-1016-42e7-abad-08ad85fb62b4@linux.dev>
 <5a0c6597-6b96-4781-a71b-fd1298b2b7bb@kernel.org>
 <c0e366ec-ee5d-42d9-ba33-7c630660e8af@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0e366ec-ee5d-42d9-ba33-7c630660e8af@linux.dev>
X-Stat-Signature: 9p3anr5amiferqy8fhb5w1edyfbaqncq
X-Rspam-User: 
X-Rspamd-Queue-Id: 99E17140002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782466798-512239
X-HE-Meta: U2FsdGVkX1//Y8IKINRH4GxrPdPIdbLkgnKvDQey1cwLBcwefLIzYAa7V4Un3/McXuaVJcCdHlwLZZ5WWAjoveed/UVv2Er1lnqU9KBQVSuEvVGuKDwny6egXYZFLUHX/cG1THEBYc3zfpd5GRj0e3aTS3G9GfKaFjNh6fvWFP5jaYYEWFcKRX4Q31Wnp/6kwznoQTlfDyNq7VFFPhXuLt6CUyucfPx+4Q1lGYS5qDM+fFLm/bS1mFrRQD4X8nAjP8k6742qAWQmR1aMnR1E9vLusTdsh/01AXaLCn+exbYdbqalvAKF0+fXpKtHbWOgl0cpJjmuEiv6M6foPk2vOQvPXcqpaJN2I5avqf6R1SgS2emh4DLAFfVmTulqorV5imuJckxtHIxWT/xFPipbdVZB6lhU0tf00uwncEogjBVqF99mR9IuEq7UCV/Z4cQyyZuEFjSpGpKJ8hq+op2blV6RArgj0s6nuospBpU2/h6T0MKZSFBPyiPDu+yerd3ThU1jXGfQ3JFrAC3tnn9LLD3VQmht0j6KGr0Tg4/Ry0drQepjSmkx3kniXAjV+cydNLQA3JAtzbIHuPNttybKLNfA/FyMdKbWIoBx4VDeyLjXa/6OZtfIp7XRprWqb1rYHa9ga9J+vet7yyiBsIcjNVJSsNyj37ClRh9EwuRL9TjwLs58oGnyDuEMQVh6AfTYmnaTOqnQKoogjG7ORIUas6A1XCu9CRuOvGEcJpVuJBY8eXLUPxcw03ohE/aK+qmDQkFLdNMB4rMBtuIvWjDm0t8On6neelHbTbv+Vfj6GXmU8t55/TQpPdY0G9PzMemrtYgNoqgZLjoqPIZA3ayQCPXi6HtmNu1H9YyLqZzeO8ecuX9qxMYm8aDT5Y19ELywKom5FVegwZPQ5LlOwR8IuzpJZ/ETsvxQxmo7xv3O31N2jpG7TklMuX9aPNP+m4XybotmvT6jVXsBABuWZTu
 oZtnaj3M
 XgcGn/dreaAfdvl1T8u1/sfEA52dP0Ffaj/H9v4h+ypqRsBTUCQG5UegcFqLlEfXZK24WkVfkqx+Ga+4N6+jzSCvvPB/MH4MgJejeTADgyklTPftO0c/LWIzARN5jTDV2RB6b+UEHmdPkkDtj5Qu67uIpb12nb0EeBzwEGyv68kfat/E1Yi/tTPsbexmGwQ+dcyJcJEdX28d9CK13xv9MaswQxUX7XoTlnjv0L+rrmel0TD4V889QCnEWUFqruF5tsiGF1OrcD/mNbXymYidP5K2acIr15eRYOn+toysYlmvEedoMS252JN7u39IgWlDciN1mzbpaXs/UMnadKmL6HI5HwMOeDFlRAk4Y5osIUibcZWV4epJ2MYqJWtGIUPfIRsOB3hFYtjxU8znRfst6DeWWAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 03:04:17PM +0800, Qi Zheng wrote:
> On 6/26/26 2:48 PM, Harry Yoo wrote:
> > On 6/26/26 3:24 PM, Qi Zheng wrote:
> >> On 6/26/26 12:59 PM, Harry Yoo wrote:
> >>> Observing a dying cgroup should be rare anyway, it's worth focusing
> >>> more on readability?
> >>
> >> While it's rare to encounter consecutive dying memcgs, it can still
> >> happen, right?
> > 
> > But is worth saving a few instruction in a basic block that is
> > unlikely() to be executed?
> 
> I don't have a strong opinion here. Hi Johannes, I'll leave the decision
> up to you. If necessary, I can send out the v4.

Yes, I was thinking what Harry actually bothered to spell out ;)

The race is rare, multiple levels even rarer, and even *then*
mem_cgroup_lruvec() is a quick inline.

This way you have one block to handle that one rare race
condition. One place to put the comment. No labels, no goto.

Simplicity wins :)

