Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E52606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mMRGHR//
Received: by kanga.kvack.org (Postfix)
	id 1060F6B05B1; Tue,  3 Nov 2026 20:17:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE5D6B05B2; Tue,  3 Nov 2026 20:17:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E516B05B3; Tue,  3 Nov 2026 20:17:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE09B6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:17:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28A944060A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:17:33 +0000 (UTC)
X-FDA: 85395673986.09.CD4EB03
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4DC9CC0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:17:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="mMRGHR//";
	spf=pass (imf22.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793755051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cm1ZQLsGovKO+P8QmmyFaPVIQNh00JlvvBw/TqlEjIs=;
	b=qkB7lE+2MBSgMguWlah0cfMkSLTyQdUpHFMX42xYZYq9y/2ZRTk+jvsnKAM7Zyj6vsWK5s
	7o4V+6j3HXooJnVcQpUAqDZF0/xJc7l+H2Mh4yFLYTQnTbCD2a4+S0SKt1A/1rMzMPKqgg
	2w9nF+1zl6nQjUryLHdMbgJGAMnhfk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793755051;
	b=4D4KfXViV8MpK/raie8st6WvC4frPJPfgfOMy8uAJ7rGIyE2onYzm1EUNRrRgeJmsAkSvU
	qNgWIRvWyD7eEHTphJlB4XZn4+M9EmGE/crMZZa6Zxl+xG28KOYW76nAABEu1IVJlW9hhH
	NGJyZ2DqSGsEZ5QgBzW3hEgIj0YbyWU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="mMRGHR//";
	spf=pass (imf22.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e9d7791b00so1184365ad.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 17:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793755050; x=1794359850; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cm1ZQLsGovKO+P8QmmyFaPVIQNh00JlvvBw/TqlEjIs=;
        b=mMRGHR//psSNmNgSEgWCgdHgs0sMyf91JJYNB9GOoyG+LGYP8SB7FHSA2u8ptkvIIO
         jEdq86/AXGNROLQ0UFcG56uuRWPqqr4loOYLUdtGvuK1o5fgruk/lADFqXlxxPuqAsDY
         +LLV2qP8zc5rltnZkwsicKGHw/kFv1y0tZ8qJIwk003LVlTWtU7tSEUR2yHORDXn36Tj
         UowiE5e+uf/aFOF3gYi7EbsZn6pqOWUBRXEEi7lIBMxVizIOmqkgV+ExNBilkPBWzPWR
         S/vo0Bp2bQir2WY3t52obqcZunygwjU1tEP7UJlWvmT5jhymy3xzIo/hvcJQYV2VvwT0
         OWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755050; x=1794359850;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cm1ZQLsGovKO+P8QmmyFaPVIQNh00JlvvBw/TqlEjIs=;
        b=RMbkU9OLcthjC8DAeHMPUr+yt2qpiBHn4ltQ6fx4KNiSa9f2mDv8rp3/sK9Vz+/ILr
         i1SqICVMcJ+r39S8L8WlXeDoMXpZoUuYXQnSSLfVEwXiGbBnwUa60fJcFdN0iagCodGB
         jBILpXe6DUPG6nlfmf+3Mir582g6cVa09UUhByyAWTZB/MZUCBDDCeOdu4qIbNEjV2kU
         zLn4MVSvh949/WYaPISPOg/Do1xf5bfQugxZRtju6nSWaTWrXnzntMXoFKTxFpfuk0Sg
         qlEVGeR9BdccXW7q1/SxyHXNv8AxbxyjkoR1v++RuVwclBtKoO6+XtArqE+gBG6SXoqe
         wHNg==
X-Forwarded-Encrypted: i=1; AKwUvBzcJDBXmrWO0jvx13lOrLsyncUjijpdgKtQwGUY2RE6OFo8EZ8DgeanNk2iHE7X+j2w7YHIC3+tVA==@kvack.org
X-Gm-Message-State: APuU4Z8SsYSakFjSGOzYM38bIDH8I9TNiHPAy8yXcB/W8A7mMuHcUhFi
	hMBkaCvLW3EnV3QGa9HufbFAzvGSzIF8bsOyrRaWNNFYES53lzPltGRD
X-Gm-Gg: AYBFou00qbQKJ1zBWuy4PEbdM5/6xI0Zh4kxOkzCr7AuE3csuRlQg+KI4wJTB1ESYU6
	sOIGeMSTJaQHLFKtB52jgDch7xCd2PgertaHX+ukOeMi+/Xm4Q6mHFo6uYps8e79cEIYHFP+mUm
	eXJv5nXzz22PZAjQryqX2qt5v0nT3yAMp0MlgfReFsBoChNxuSXp0Kcwgv20dDa/9mY7ovRzgfa
	y60kgkmo+BIbzneklBfp6kNXlM7I43kf6u7xvBQ0ow7X+L4tWR9Ws7QVoBCP7VlG1jo4NrhrJ2O
	PNwT3yaMMMslF4Pa+IC6InRE+52aD8+KCpuHlM4S02VShpWD38A1fffIueXYFnl3UFFtBwk749C
	YQCDfnJFDa4qEhWEwcgdzLQ/wH7Ry8qBYKepkOngzDQ/chh/XGe97sNjXNqd2h/o5vW0RluvSD3
	gjAfCgFnMq6hp9tpeLQ5DqhBZMWU64fzpdC0s6DRXvuFoo8ExCGYY1SdAniheKkSDlemNF8QyyS
	skuC8DJ6EpQlVNOwN5doK+qL5IpzHKpqQ6piwC3P3VKEhDlsz8WuIYHITn9N1V+TwrjuAWVIFgM
	XcQ0KXRtbrh7lAzwFo2GL8IyxnO9vKd9eToIHtIGk1A=
X-Received: by 2002:a17:902:ec85:b0:2e9:6788:937e with SMTP id d9443c01a7336-2eb364d1716mr124879085ad.42.1793755049997;
        Tue, 03 Nov 2026 17:17:29 -0800 (PST)
Received: from [192.168.52.49] ([2406:da14:ac0:7d00:a5cf:b1b:97dc:3084])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed091ce09fsm741905ad.68.2026.11.03.17.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 17:17:29 -0800 (PST)
Message-ID: <9bb64032-09ce-4ddf-81cb-206bb85b9be3@gmail.com>
Date: Wed, 4 Nov 2026 09:17:24 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/core: reject empty access pattern intervals on
 scheme commit
To: SJ Park <sj@kernel.org>, jm5905938@gmail.com
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 error27@gmail.com, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>
References: <20261103145319.88120-1-sj@kernel.org>
From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
In-Reply-To: <20261103145319.88120-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: qhadghkdcrtz9twfefbexy3yybdf1t8n
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 4DC9CC0002
X-Rspam-User: 
X-HE-Tag: 1793755051-893994
X-HE-Meta: U2FsdGVkX18rDx2YXsXNNmB8lhAVgiz/RgC1RyZp6bJQMuXquG6aGKt3rn4rGX+JoyDCAtpOtB5trHXdqwttiDTqeAVPoR2Wi50o8OXms6fwfWLSds5/3iMiT8W3GS92HenudlQF1FyP3BLfYQYU/gj02/DrU78E/bxe9CxvVIYttrrdG5ZSQkYhNT4qRyDCbtXFTjm/miwehh272NCz4MH5X7PnbSR+bjstIk1N/F1picEGVDly1ZYnyt7/Lx7ejTAET/5WENwLt3yDeyrfp6NUyjx2yOKNiu2MF5k7IPv1/M2u8KvFbF6pPqL14CDk4Irk8y6Zjjkbp6IX7HikKY3UgxupAtAQRRNz2kkSGdvZEcOHMHPLuXCk54fmwHDt8bmXJ+fTNSPlN2SgCFdzjgtU/yUvndWIon15/uoz+DS/NknM8vJXbgPgbQrTc+zhpolKsKIAyWcv19tQDiHUflm5jjrb3t5KDHmvMwNGwjByi5+cp6u2qZlcZUrrKKSZDS4Qi1AfzTw279DNi3Z5l3ltTYkIhl9zv6cvzgT8CGsIuFX2n3iXJidRu/0J8W4wjAsNK/tOqburo51xymlZpjqQvp0dXGj13LuQGqdXRkkABXCHJgl9c/+E3e0tupKMnySJ7aiZ6FFIz68DhFw4vlQuuzdgcsc4Y02VA0quVVAvOHpgzcp2dJ8cOAy/bZ49lzV58xtv2Twynv9nGw+F5CmNh9chT8gPMUupMIYksnF0ijWoVCIbNVJE2BYQbbzSA86Rf2cHyfm0Yo9et7IoKWpThF0vDJaivI99wTBDEqmFPKI1ljgwwwcgNLP33ETuC39Z4gOzjS55setkLp3LiZIvltMsmN4AlxD2z1twW3hYaBNcQVA8ILDoX9CH1S8nhrxMAwif+zATp7sF7VEunn9W6t6aqin54JBpAe++uPOjxP0uqaFxzPSmPhv6XZnhhLHq5qPRSV70JrGLfxK
 dGF0ZVqZ
 XRMfDBHhUsQae8xLaNgXRcfGEQI5oqD2VaA6gc9lJyFW/9Y+d2FX9pSZk/RPpNb8r2CyUDfPAqA1uRGAg9hMmq3dwEaV6ou7f1JYNR73so6TWXyvY/QwcmhjKODJpYokok1reR30IETdB2z57NunGpM1hVGV7aCrf5PtjTa7UbMp2Py8509mFJ13s/Rap2lGR8jKVlbr7fIhILsMgabKxH99jx9zrifB9VYCl/tncwOMCxwkZIlGTwAvc38df6zfDk9TXRzkGvXiSwZc//RDwY+4PhbOOoHKWCvmERsW+f8kFUV1i2750O7kYJqcDZHL7IIgAFtkEWMGhJXE1HTRuzmBKkh6L/hQ2VKPZS9osZT5aAIp3dyPiuDMsY4eD3damm8i/fUfiHKhASR3+Fn1xpV9S8qvOKgN5bkSVgI45zsrB2oTuOCkzaKGwFHVQf2j7jnajwnD3mL5kcffbF6koQssAxUYgD5R7eue/yeMlKOSM/QhkZAyvHj2qsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SeongJae and Aveline

  Thank you both for the careful review.

I appreciate the clarification that DAMON simply executes what

  the user configured, and that this is more of an input validation

improvement than a bug fix. Perhaps I was too aggressive in framing

it as a bug.

thanks

xiaolei

在 2026/11/3 22:53, SJ Park 写道:
> On Tue,  3 Nov 2026 18:54:18 +0800 "Xiaolei Wang (Kaihong)" <xiaoleiwangxiaolei@gmail.com> wrote:
>
>> DAMOS schemes accept access pattern bounds with min > max (e.g.
>> min_sz_region > max_sz_region).  No input path validates the bounds:
>> damon_new_scheme() stores the pattern as is, and the sysfs ul_range
>> stores are plain kstrtoul().
>>
>> At runtime __damos_valid_target() evaluates "min <= x <= max" for each
>> of the three pattern dimensions.  A reversed interval is an empty set,
>> so every region fails the check and the scheme silently never matches
>> anything: nr_tried stays zero forever while the kdamond keeps running
>> normally.
>>
>> With such a reversed interval, damo starts normally (rc=0, kdamond
>> state=on), but nr_tried and nr_applied stay zero forever and the target
>> RSS does not drop.
>>
>> The same holds for the watermarks thresholds, which must be monotonic
>> (low <= mid <= high).
>>
>> Validate the access pattern and watermarks at the beginning of
>> damos_commit(), through which both new schemes (damo start) and online
>> updates (damo tune) pass.
> The documentation is not explicitly mentioning about the inputs (min > max and
> non-monotonic watermarks).  But I was thinking it is not really difficult to
> infer this behavior based on the existing document.
>
> If my understanding of the documentation is not wrong, I find no problem at
> accepting the inputs and just behave as documented.  It might look silly, but
> who knows the users have a creative reason to do that?  As long as it is not
> causing a harm, just supporting it is better for both users and code
> maintainability, in my humble opinion.
>
> Pleae let me know if I am missing something.
>
>
> Thanks,
> SJ
>
> [...]

