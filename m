Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D86B606C579
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l7Z4J1qm
Received: by kanga.kvack.org (Postfix)
	id 5E00A6B05B4; Tue,  3 Nov 2026 06:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8716B05B6; Tue,  3 Nov 2026 06:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5BA6B05B7; Tue,  3 Nov 2026 06:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 280496B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:27:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BB20140381
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:27:33 +0000 (UTC)
X-FDA: 85393582386.09.132D8FD
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id B9743C0007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:27:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l7Z4J1qm;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705251;
	b=Pr+b8pRGK2lrdR/hqpeI5tTspdnDzS02LmcngA9hacfoHrYir3yLgdmpbSbdqP0dyN5txH
	+jR0WvIvNCmR/F0zyBbnP2xp41nx1Nhpz0odTdNJ9Bb4DsIIMZlm2bATGwVlfDIsPQIF4v
	h6rL2RgNsn4E7QTm2JBnpJCoMeyqLXc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l7Z4J1qm;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+euFfAeQxWkS5ASGGavFVBTLjPaa5ivYg3I8FV3VAA=;
	b=rUrfzqwG4emKw0sCu3YOGkiTyIRxirGlmqN8QUeeakMIbVXK7Hy6dL5G0VP7I5vWK60Em3
	/LlfQ3cdn7vRuG1C2dwoT71O7SxqJYOfFsHz69bIdEgRP6AKqG+HP84UQQXtvB61or/mo2
	K3ZZmFL1ypB6C21uTWPS1uG7rQAVKRk=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so376234f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793705250; x=1794310050; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y+euFfAeQxWkS5ASGGavFVBTLjPaa5ivYg3I8FV3VAA=;
        b=l7Z4J1qmE5f6sNdCXpcsPGnszF3+nUkK1uil4HM8ZD3mz0ovDvp51vCsrGZd2er9KU
         8U+XPgHzYzQO9E04OtosoJfj+NSV4aAj/ow+Z01eGDFCUfpbL6PL6NmSfRL1xH6F/p4h
         L241FOO9hsEg+UYkUJ+xqXZ8aF6ZqturyaYUo8GsTQ7Hv5J+j129De4NKlq0uaXtqBXG
         I9yG8kNemYgjArHEymNm52vGmGq5ypMiDKBZ8U8/D+DQWl5wLr2/8VSJs+TAbtoHnuNP
         NjwSB0YBMQmPfCu8uTGsem2smrQgo3lfy5FcSH8JmR0sZJ+Ee3RJUkoj7jUSts45S8HV
         oFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793705250; x=1794310050;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y+euFfAeQxWkS5ASGGavFVBTLjPaa5ivYg3I8FV3VAA=;
        b=blSsw1gStaWZHxR+CH5SYYwr1V0VpwZ8xtKJYyEOqBMbGQ1aVM291vT7fMKaZd9NpV
         W9EqHSdqTOJU56ojMiN7ZDuSfvj9tQOLPd/gNBzUtSQ0eTONIj7mwUu01GXhq7kHBP5b
         746MuQWrhvcPFbtEOyJK1Nsa1dXb4MtC88oSzlxxTQ2Q9Wy+Nu1CwQxjccllNRAKAboT
         fTKWxfZfztzgFfnUf4mp/Z0VB441Sb62ZwnEATrHOwUIs0nQWg1lWetFQw/lGOtqMNoo
         2jAFRm/XcMpG9nubv/CPH2Jw7Uo9wOjmDNuprv98lRs1cn3NJOo03XNiQQecapHkFo9a
         R/tg==
X-Forwarded-Encrypted: i=1; AKwUvBxQT3+8P8B2UY0MeuNJRtHuwm66qgFaaK7onJp2oNWeZ4recuoZadswLVw68PmMCI0Otsnu+AvJ2g==@kvack.org
X-Gm-Message-State: APuU4Z+2LoUz0NzBCCZm5HWGPFPEa1WcwbZsBYU6ugeUekAX6lJ3Ahr4
	ccDRcCSdU9jYxFOV6J79HjOKCaY3csY5Z3Idr3CNvbwhNTdlm74mvK3N
X-Gm-Gg: AYBFou1s6tXoDvTOpMyd2Kzpp2hgwBe1A9GOWNQVsRqxTrsZ+lQknPpyprijltUkS91
	OnVBa2q2IcDNP4+XdcIb5IAxFizpANM3w6HVZJs/M6Fk9SeA5Qw8VpM3w3HTDI3K1guBv2EEeyC
	0c8gu9UfEwS/CuwkvRGOjAyZG75KGy1e+YWqBLTvaGb9FxaQDqzkAN33Tg8A1YTh8AVjPXrK76y
	stcKpH0O1RNlJiAFFBV3j9oyEFRnjvO9eDQedpkGLmdt11DlKGtnLuKDCqVSs++V+DLPUdfeWmf
	LOPUePVLE5M49Ib1QFVqTxZ/DPfjS4rSkSAdgyHEL9Pvl0K6dCR9ZnKP6D7iG41gkV+Rv4sEvwf
	MsBfJagtVShK/HfoqBlCuXeMpECprbf8kP/+MxChMPgbEUfD4kFzQMYkEH8Ir4XyVsBrVBP90kz
	CUgMo0tS5Ql4v2wWSPsr/Nwz3WciugoK1WElvkuJFGXmMMGsoX2fBV7k7jTsIugknSnovBEjkQF
	snynLxnKILMXFUaPWA+/4I6rWT/HBBu0tHYiTZ3QPF85e4z3kQt8k1g3wGZPJnt2/wKbSbQP+uE
	pd1ipIWxMoNAEWaiHFGc4L4=
X-Received: by 2002:a5d:584a:0:b0:48e:7833:2e7b with SMTP id ffacd0b85a97d-48e7833329bmr23687518f8f.1.1793705250147;
        Tue, 03 Nov 2026 03:27:30 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a84esm26678645f8f.39.2026.11.03.03.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 03:27:29 -0800 (PST)
Message-ID: <b26bc0dd-43d5-433f-9ca7-2b0f550b0ca8@gmail.com>
Date: Tue, 3 Nov 2026 12:27:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] selftests/mm: test mremap() with an old size of 0
To: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
 <20261102-b4-mremap-pre-split-v2-5-d281dd11ad7d@toxicpanda.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-5-d281dd11ad7d@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B9743C0007
X-Stat-Signature: 6a35jcoy5a7i8qe3e1x3n1uih8h6habs
X-Rspam-User: 
X-HE-Tag: 1793705251-169997
X-HE-Meta: U2FsdGVkX193jbN8SNtzIvckgj48tdd4Qv34Oz6WSAUO3PXT9k9lYoRseECRWzA2L+VRXqAjeLJtg5m9N+tSmbAsDKoalDmBZtW4w8WmoH5aPUOnUmPUk4onUxH5bVfD4xY1i1ogxS3SnEZHM4Jb3PFN2hgTrCBzgHu6EEWvKwaXcjnGQM2BLZqBlVM+YeirbeRImD1OTY0Jmg6BJuOWs8xqXpPXa+kihtS1JhlGifofxEnA+fDIzG6oguNcPgUzu/0MOK/QnqELx6sM6kBGjD8aVfkA+bBNLQUj+SH7e30CWPlFEbYW20acofZ1SvL/EQiln0vCD1jO17NG/81nZCRVkSt6T1rvt+J4GJ3mjtpLVPYL2nkkVAZax5mmGNOEzMEzu2YhdEVr9liJcZCP8vTXdOaSiH/YBc2xEfsaselK47TRleUy4JocV2a8o+9IxzkX5qSKX6QteP1Ja2AUh/aAPJmtOiMnhrmAXDdrAAr9Dzfpy4UVIIcKWw91RWXNpMc1s4CyGljgFyWJSuc0nTfbmFeSaqba2lfGdUqAMjS+WmX/AHtEDb6AaLT2JA4Se72RCUebEDXbxj4FfGJvgkKHFEIQHjEWJLT0XlVOUKAL47UWITQCyGN3YAvLejgVUkpw18V+AfcJO5zlk+oAA1kogK3V9KxG8vtiJVYFk7UDlI01Nu0ihxdE17BtH9F6APoye05o1Ie4v3mC2vRA6STSB5kMe8qTLoGqA/Klt5z+JGtk/os7I6K9m0gxK1/RaBTQ04FkJ70jdwtaqE3BRgL1pzxbk0bVXlUdkxfXSxbtmR3M4BQVnbhEEjFHmP2+meeFSIoczuGxtN/nE7G0hktaVrGAVer7ELdp5ss/c53xLRGdsk60f8I6zdUIaHeBhtgDD9AVlFy7uqFW28blgli5PrX4rp+bAqvSSTCzFtj6MH9n2z2kTKJ1Jv+kV+xqrLw+dDOOEHfDbsCJmZM
 LUopbvGm
 n9ZqClWKwLSKJBZEfZSryCU5ZIszpphVN1Ct82Fe5cSjYLU/6gLGp9G4QHO/qyIivDBoNxD67zzjLCLYfm+S05J1+1fStfw/yesw631fCVJFtk7tmG6K4Es6GIUVg0y8OihpLYBsj3dq8IEexfeGD8XCIXxuUupiskNOyZg2bX07rNcTgmXkNQzCf6XsxPC9A9I1hPw1UOInSnoNmYI3eyodpbVhjwr76o8yBHRRXRYvyqFB/zjhXm9mcJxPupRZYB/NLBsHXnb/pYd/ETDYJr6/k3FnGmKahNxI96y0ByVPHuQeilxOLt2rTwhPg+5EUEDLCuxDzGyCXZMcPMdlZ7gegiyam5mr2+XYIRV2uJM1Ie+liD9chImnVXgJo4ZSDoantJwrPm8GnUbAITBginfVPt1zqveLylOOFOAKfIDy6evU3RtTUlAqtg4YjBIcSDa1h/HImNqy1BYP98Ekq+R8/9L2O3Dx4pg7ZViD3U/LLqjpV4ST02sBHkYbtHOJ3D98FHtJEsHRQzCr4l7LUrJYYvrHY4GQCm0t/r0yejqELqjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 12:46 AM, Josef Bacik wrote:
> mremap() with an old size of 0 duplicates a shared mapping, and mremap_test
> has no case for it.
> 
> Duplicate a shared anonymous mapping, once from its start and once from the
> middle. Check that the source and the duplicate are mapped by one VMA each
> and that they show the same pages.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

