Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E33CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702116B008C; Tue,  9 Jun 2026 10:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2CA6B0092; Tue,  9 Jun 2026 10:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8006B0095; Tue,  9 Jun 2026 10:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B13E6B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:18:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE6CD4060B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:18:22 +0000 (UTC)
X-FDA: 84860579244.30.CE34CA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B8C818000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:18:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYRLlWyQ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ubw2QAHudl/FE49qmZ7aPjPEDa/Kg3T1xskL7HEGaIg=;
	b=8kS1FQ1MbKw6Vchyrb9oK5+YM5K1zWo2aExb7kap6dGiIhjDqjjMJ7nZ5hC/E9JV2fdY8w
	5G6CSOdmmJWfay8utIqxZM0nSr8pjB9nqKhQBYdmUKjhauOWNCOUUV+U7byd4hTgd+8UYJ
	2qPM5OYAOYdD6UFcSadxrMrFOmy+DIQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYRLlWyQ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014701;
	b=6+6MYZbZFGIHMPXkT3wsCfxl5yKyvAwffDxxMo1km0QXXfl9DgvzJq1UzVQlCKbyvEYuY+
	DvHuhrVP6wGDSmVYSZ8wFS5pF8kquQVvi32q0Ux101zb+DSLaxOIFtATvJDYWLKbDQaFbL
	4SL1QA0NDQW6s/fDq0jlo2NyRDkcFZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F5B600AB;
	Tue,  9 Jun 2026 14:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7519A1F00893;
	Tue,  9 Jun 2026 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014700;
	bh=Ubw2QAHudl/FE49qmZ7aPjPEDa/Kg3T1xskL7HEGaIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nYRLlWyQHRUmTcPUVMyh+6nCWHLZxRljRiy2TeaHyZfD2e1OYBzOCYp9n+W/j/JrQ
	 YJIS9/Nb3bP7DUiLLinmPeXlXDJEpRTG2MDw8fo2NJJ8w6qoiM9bTuz3j3ajnuJ/YO
	 PI+rrnUN6ZW3fnHGR+rZSYvPEK05jjUspEZ8QEfROzbfQa7CHGM1Qvy4N1S+OIc0zI
	 zT1roCj/Wsx7bJBtb1Wnmnn6ItUaBa5yH4tMHI0eW+n0vF0+THuVPoMalLHmS9snKu
	 fxW4CWQes0cFADmDsNsmedcjGNK+O6KU3C/v3hgKJOAYDJJvnhyulQPM21Ptd40CEV
	 D/pytc5YrvhqQ==
Message-ID: <39e1a740-1126-47d0-b5dd-d711c04c6af0@kernel.org>
Date: Tue, 9 Jun 2026 16:18:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Optimize anonymous large folio unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2B8C818000C
X-Stat-Signature: p7fwxmmjp7zpsh9easc7j8okskguniqb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781014700-352205
X-HE-Meta: U2FsdGVkX1+DeahUh3qv8ZFjjgXq0X93/E034gb6Fp/ei2WZyGl53Q0H0l+HneQ5mgTc3z0OVTqiVQX2UFncXz3Kr1RWYfcebL6S38uYpw2QbdHSNbvgZIzEmXPP1JHPKrAxrDNnc9aF00tIXlgG6HyM/QXzHHEMYuYk2eE/Mg2WRn5kZBq7gbnLZJ6UHjamAZp7ywFp7XEN0CnvSlCoiVUOA8unCNFlu9ljix5doZut/hgbzU9cA0pUdl0BxMEqCZXQOMG9LN92Yy/076bNTC88EL9eWQjqCYyWvTng++3pPV4F13/UeDPWUSctE2oDTqc73I28IPfEIFYrjfqxqPngnJRn1+hVperrihGXiEAi1OygyNJzyMWpKAeyZQeNHczhMd3eY5tuz3o7dwg6JVj/rQeThzLcJjvYVbz51G5CtrPlGK9ZLsDrsc44ZtMRX9dKQMV8xCDZh9qEoNnwcX/cC4Amwgn+qqiN6dlv6G006+dYGwcv4uJ42srljXibYoWJHqKYq8kSRjESMciUoRpYW4SOKM7uiD+ICH9pZGncmH651OttQ1W6YihQZP0YPbD533nqeZnv4Ajy35hkaeBmLJrqvoXax9LOhsGy6b11bxr8tQo8AllwTWSTUWU+2TNLZBEHF5oVQx5mpj1bwxyA9gXcIEPqgAdVnCNNP6bWiji5a07FKRXthiiVb8gHXRE2Bp5t2JSAejFlG4BrLe+a3M244Y2wf44B7NVTLW6h1aK5ie9fiUiReGoU6AV9AlvlCq6hn1jUMK+LvYev722H/u8NbLm/kGZ/SQZqwDxELzM3v8F7WmSEU/YKLW9s5HpPr1jEc36OD+//cODEIt38pJuQvG2j7dH1+r/59Dmq0nvRZBNnkEvggzxsDIDi5Dy0q9NQNvTDC+1l6GmGLE3eNu3TKZtXDAl2W1RmMgKKO6s2CiO4kFM83ZhMpPJxpgGl4V1a07980/3IGae
 SvY4+vcw
 xubhVgEIKIeoiHckNH1OkObm7M++GClTCzmWZuMJmx9yUzhwqb4a9igXhoLJWdD4lZW3EdtBo2bdQG19tkcMdLExaOGVXiYQNknUtdKXo070vN071BDd8YdYHOEpBNO6vr2e1V3om+R6doYlJxNBYTE6zr0+xuQ4RkX8v7GMf8ey4xxOX6zuzUBPqqCCzU8U519J9mMCMjZDt3J3f3Ze7YpZTA5GrpvsnkHGEppD3uv8D/4xtXIui4WbIrKNqJ/fvFKMq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Speed up unmapping of anonymous large folios by clearing the ptes, and
> setting swap ptes, in one go.
> 
> The following benchmark (stolen from Barry at [1]) is used to measure the
> time taken to swapout 256M worth of memory backed by 64K large folios:

I suggest sending out patch #1->#3 ahead of times as separate cleanups, so we
get more targeted review for them.

-- 
Cheers,

David

