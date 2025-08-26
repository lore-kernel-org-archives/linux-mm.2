Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F8FCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705976B0248; Tue, 26 Aug 2025 08:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695726B024A; Tue, 26 Aug 2025 08:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530186B024B; Tue, 26 Aug 2025 08:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32D696B0248
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:51:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EADCB1DE426
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:51:29 +0000 (UTC)
X-FDA: 83818894698.13.196A763
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id EDDEE18000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:51:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Juv0MuXM;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212688;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JKK5SDncP3QKyeoqTzwvu03OjuGEJmHoeWEpa7ww0M=;
	b=vgejXvj7CbpPj8Hg7gaJGdAQ+VIz7upfLQ08k03vDzE6b/XHFjl3KJ1AkTPwKofxeW0PJJ
	rOnBo/clWJ6UTuq6fzkqP70xIRa7G/6kAgX0SAvk6/KGScowheJivnx1Zax9fXCU//Po5p
	YQqdXS37nsbKAVrdzbAMYKzoDiKbTO0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Juv0MuXM;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212688; a=rsa-sha256;
	cv=none;
	b=Zz1b1XgzVzXZnZG3mB4kvwe/KSVq2dy4cEqZWmngpoqMvah0RRIfhePceM1zA6i3SUuSyZ
	OUx6GFJ8IuMwJQHXKloSiM0Cj9WtgyOOOuWbZalt588Zbtf03MfibKwk8pIAlXFqr+8XqH
	9IdQaKlb7wXLBxJPgMdolVvH+HSgMxw=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afead3cf280so80972466b.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756212686; x=1756817486; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JKK5SDncP3QKyeoqTzwvu03OjuGEJmHoeWEpa7ww0M=;
        b=Juv0MuXMM+dfkXMo3TTP0zWSZD//LY0/VMxcpVINVHGFFo2jnVEU/ulnI4IpGropTQ
         lPXh2B+eUF7jL31g+VcIvqk8tH8Oj9Ar7HIjoSHOp0ZKtBRD8pDKFi/qyYiB6EhUtX46
         wp/jK7B0N3L+F+PInF2qYecgvFSuY/dvVM+hu8OZ00MyLH5+95kJFDpaoEa2TUf12Pcx
         y2NdFZvgEThCLGRzW9VYhMFislM7HSpKGQU7nzm1lOZhcEZJL85bNP4d3wTqt4Oz4P5t
         BwX64BjzuqgqpPOsTRipubWg/P0w/t6QdhL/MTMoabli3S8MaH1Rml0c6uz2PUkTwHrs
         iV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212686; x=1756817486;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9JKK5SDncP3QKyeoqTzwvu03OjuGEJmHoeWEpa7ww0M=;
        b=Hqo5s28BBFPMOVqYuD7gEIeLykW4C3sdixtzPgTC2qLmJCSWYrKeUU/rHM10kyGeml
         lr1Kw9AsTyGQCJM6Tcp/U1figKSEyxbRb1oHDVBpiRYnmhdeWkl85NkqmUGcQcIX5HIG
         t2PVqJrksC3zoO2qw1bBPPQAIkLMulYpmvCvVa3zU2/KmXfLbj1QAOmAvaKg35ttOJUc
         IYvs6eIf4fNTZuhPWFRL/m3e4Ox5Rl/N6mBOS6pTeuO1JLnH331KyuS9w6a8ihsfYtaV
         AM/VLw8Ltr36uThBbv+bqIJso3j65HDMeqUJL727K/CZxNkQWQZFAM3+2X7OwX+nwWNn
         jlkg==
X-Forwarded-Encrypted: i=1; AJvYcCUSJ/kLY+3nHTrykURRovYQyctGcChnIvS6KvjCALHqabpDnrESVRXFOaSwJ3y1/psMBRx8ac9mtw==@kvack.org
X-Gm-Message-State: AOJu0Ywk9sEwoGL+uDY72pyUBAl9vHl/atShueYREZ8wn+J9ADlylWfL
	RZi/n9q+foR+3qZN13aaLPbZTaCP/HrD/7aXmB8tNCiD0BRRmlZMq/NI
X-Gm-Gg: ASbGnct0egEnZlSDbJFGJY1zVMLR/Avb9tj0ONTMDT8YkOgOJX4Xqe4t3UIovcutnAe
	qc+h6rmCGiTU/UXH8y+q3QKsOLs99IQ9/o0L4kORvKfga9xq4WE2XYvaJMtX92FcPoxPJxI+/U8
	C6ApWW0Ngvi0eT005C6MMZ5H4+bYM7Zi8PloOjRHqAXOf4X7WkyASNkg1+WuDFmoTjqi69nON8m
	bD9odDetTbkHT/toH+iyM5zjIDwxFL2kne718iASxKlVDuSLdwzgYgvXU7OiXpc4w9cM35YRos1
	4lQ4h8270jaKxkuXQtbXQWOKOSWiqUOAA7nX4F3bFNoHyzHHYg1wI3BsTXhIdzZ+gAIr+rZElaA
	cgrE59AwAONI5MEEibUQAGI08tQ==
X-Google-Smtp-Source: AGHT+IGqDw+TcK11sENHUUf1vFPyvCbmWROkG5DAb3lQsEoxoizI8GCl0K7/OMLab0J2SLft/gCIEg==
X-Received: by 2002:a17:906:6a09:b0:afe:ac13:71f with SMTP id a640c23a62f3a-afeac130a1emr193937966b.41.1756212686249;
        Tue, 26 Aug 2025 05:51:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe8f8129f0sm299159266b.41.2025.08.26.05.51.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 05:51:25 -0700 (PDT)
Date: Tue, 26 Aug 2025 12:51:25 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	linux-mm@kvack.org, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: fix the address passed to notifier on
 testing young
Message-ID: <20250826125125.7dy4stl6nikhyo3a@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250822063318.11644-1-richard.weiyang@gmail.com>
 <0a2004c2-76e7-43ea-be47-b6c957e0fc14@redhat.com>
 <e9342d11-fe37-4df4-bc29-cc7f7e0ed38c@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9342d11-fe37-4df4-bc29-cc7f7e0ed38c@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: EDDEE18000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8eai3jnr75kwc3oznrq7s8mdp68ncqbm
X-HE-Tag: 1756212687-159394
X-HE-Meta: U2FsdGVkX19JLOpE5940moWR48I5iZKkK9zvM6mY5ZYEqOXHZMu/pG3nl1Pe2HaL/hRnswCQ2CI8ODcTOJwly7q03MYCqrBtQxfal3gPyvUczAK4AMDCzKtQY93ydOYhkhxUU07NhCfduLSru7QwdsP5zlr0H/x5aXVpR6uN1zJq/TZ0t3gNgMDwET9eAIDL+jGygJvYKqjXBWEoEX939QDYtDeo2MQvtZm1hTHH/ThQpe2a10YBPKDYSa6NLCl7xQ1VbEvxPiwnWszzOSkmRdGytLadItTx+ltm684bKByvmIGHv3/tI8CG5JxxV37iGBLU/nQZnT8KAYwodc6O0Hh6+/DK0DnZZVv2h0bXRqBUK9RUEhldBrhP+BRc5I9hGwyL3+60LJPguL8LjqNb0LO7sV6PpdIOVQNKbJeo7plF62CA/gn73JuO4s1GEHU4KCNoqg0m636qmWnDFQgw9J9RNdENPwuizOvH0X8nqNMa1FtfD+w8N/ziqnW3r0bN8dYp+XOD5yfSJqhhU85UcTGGO290f/mb36C7ge+b5sLWcmxf1QFgYd8+JWeCzYU7c8ZpTck0OfSoA22sFSNupz1t0tXqoEM+FRzgHwpGyYoKsJ5MnAvZaS0/FxZoRdCQbHRhphE3F1jkry/lMUJTK3gE2ybrdgpMmnnBIq1xN5WcOSeLxmEsxzPr7Ou4nl8wGQrHMiTa9MeriP+z4H9gLTbnNIoplAYlWf7P4GNbSAb9ifX3/g4bAVldB/X0qUT5Ck9kCqcSQ/LrTDE/mDKNWNNgVf05fuH/xQGueuI6FcesZXnCWnoBwAEjSdsbzs5NVNYH6q5nyu2NzTXdignyHo4Q+O+xNOsXAWjzrwBiGQP8gDjMWLonapoIhAXkXpsjtIr5ZwKxo1MYLFpqNnrcC5MV7oFNmqjGVSLrcztl/tGwXTlgT1O11cpP/JP/LUpMwhJPWpV2Esb4GZw6UBZ
 +xQxULKm
 vu4V9Hc4jWYXHSPqE1qAqDkI7KRsgYQIkTL/fu9iPg2zHWCLLF1axEvddICOoU5PxlNCXlqaPwcyklGpWMIgkt37bpmHNK+YKf8Vk7sj+o2xAzosSYwdh56x7cTI0pIxOs9oCay21Bjkps2RXE9PnJL3So7+vDRQcG4l2rjuG3wUG1pcvjcJ2CcAa9eeGjYplLsMMY0UhnBqVSEOGmWWuFaWx/V0lJqXooUoj/R13TLtF0zjnwCVZf97qhA2bAVEXw+xic3+SXSdlwhkCoTU2O0FbZb0BDW586fzckxOCn24nPjg4kIzbLOMrblgJd/5NTXAlZ8+nzYrX0JShjm2n0wyRCPf8lf75xBE97P9yNrK1a2vlSGvJLsrlkLLlZ9Mb1FY+iTGk7z8XMHukl2azgh+Bj9/CvaKYSM3SxSiG2Mn9UIhuFZsaK7Z4lZjwKbexX+lCnk/4qhfG/2WPZrTTNx1634IifOo12A/GMtzM0VOqkiBjHspBAvXcgq4LXhgXvDwT05jy+GD0rjuAqVfqJGX10dOu1K/9ElOCgRIVkGBH5Nf4cR6YSwwqEC9Iny4oi2nCVUG9u8MqHiPVfp8EKCbta+nDVpnyXg/TJDDOnRoJMPpZza/AwBMGc3Mc6+mxqnsUhUk3pWXqXj4aVuTyP+Wt54/CmRvQuNh9Zd2H9NVT+uIpDhfYEW+UaqMfTe7U4cEt1rQ0uMcq6QM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 10:03:27AM +0100, Lorenzo Stoakes wrote:
[...]
>> >   			referenced++;
>> >   	}
>> >   	if (!writable) {
>>
>> Maybe, just maybe, it's because of *horrible* variable naming.
>>
>> Can someone please send a cleanup to rename address -> pmd_addr and
>> _address -> pte_addr or sth like that?
>
>YES THIS.
>
>>
>> pretty much any naming is better than this.
>
>I despise it, and I realyl underlined this on review in Nico's series because
>it's just beyond belief.
>

I see your comment to Nico's series.

>It's terrible. I mean maybe even I will do something about this, if my review
>load eases up at some point...
>

If you are fine, I could help to do the renaming.

>
>Cheers, Lorenzo

-- 
Wei Yang
Help you, Help me

