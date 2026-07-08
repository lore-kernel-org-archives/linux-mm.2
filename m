Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A35C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8824D6B0092; Wed,  8 Jul 2026 09:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832616B0093; Wed,  8 Jul 2026 09:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD496B0095; Wed,  8 Jul 2026 09:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F71C6B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:15:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90871C03A3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:15:18 +0000 (UTC)
X-FDA: 84965655516.14.4009B16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id DABB51C0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:15:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4CaoWpn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783516516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyGf/9avokCc92WCSxG5vN8MV6XQhHIld2RcElUm2ps=;
	b=8VURZeUzmg5Wz0woSassKYVDiYrjob6ibieOgJ4D92/nSQ15JtfzCam6+2XSSavlUOL8xe
	VJ3Co7sevWsztM3drGcEvlTCGrEl4KV82eJxyJlntzmfYL5icL5EACBq0JMrBSTEP559hv
	8+spIgRsuJnbaw9b9JQXX++euw/uX9A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4CaoWpn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783516516;
	b=LUIyt0KZgrj4h2+QcjrmOIO8XE/ZvzbZrnXVRCBgW9RbtspyvjWky8OJVFvP9/8YUIsxaS
	/uJ/PIy2x6Equ5K6AOO98WRBfVVVu73DX/d7hmH1RHeJq7o+4ahSJPVsv5AXvSU6DcVyv+
	lG1pUDq8h6mU0yr9dESGnjNJyNBpHcw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 658126136C;
	Wed,  8 Jul 2026 13:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BF31F000E9;
	Wed,  8 Jul 2026 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783516516;
	bh=GyGf/9avokCc92WCSxG5vN8MV6XQhHIld2RcElUm2ps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m4CaoWpnXwaXu1tZmkUPfyDPPHDc/MGGsD9l4vDVSoM1wJDe1FzkZ6qG5rCf9q2R7
	 QvcvwSaXDCwppCgRj2JsqW9ptj9sdEHdPfIm5U9HRi2HLxlmaZ/rW1gbBveafQIaLd
	 VY8YVznnP21zjReawBRuyvuOe20279sk3V7byUU8068PYwjYl7davMV2x8ZxS933Le
	 6YHS5elXtnY46/ZxigI72BU/AMAA+je7V+QDTbmro24a+8CzLQvBc3qysDq8L4JO8t
	 tLxrcKN6vNaCkf2LJ+a3rYyKdr+8R2+29JJOhs7iHjw4JbA1XAQxbpoeV+S4dMy+Gs
	 rqHraFsC+Kxvw==
Message-ID: <a9b3885b-b764-49ce-9335-6efce3e67b77@kernel.org>
Date: Wed, 8 Jul 2026 15:15:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
To: Hongfu Li <lihongfu@kylinos.cn>, jgg@ziepe.ca, leon@kernel.org,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, hongfu.li@linux.dev
References: <20260708103705.840679-1-lihongfu@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708103705.840679-1-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DABB51C0005
X-Stat-Signature: d59jtyq3dyzhxat6ec7zbis7rne1pw9m
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783516516-676562
X-HE-Meta: U2FsdGVkX19O7MhI1H7nRuYKA2afp+gxExmLXpg1ho8CR9T3gdAkD5mKXko8XLkqsHkmOxdy5lgLppqPkg1SoAtv/LL+oRdOFY8ncCbb2DwpdZxTZyqUEaQi4BsIiA4llp0g5OnddFjgtCvVh9UmPOnp10Lp0kXZLrGHa4Vk3zUJgOt5gsWSHfcOQrM0q0Xlhq+bAwOrI40PPMvotDG9Zqm3EVM0W9QCXDkeyDOTR5hXDaGbEk8KV8I/dsYXLtEr7iYJjPPCeZTxZIyf0zw9hCFekCm87TKa+uTlo46zcwwGlvuJRx5NQ5S0fYold8fLloO+IJaKTf52fizcXBm0d3Wdpq11JyOeKC1N+HSy8+PcDinW1XkFzWexxuSxcEVfZXCRtO4c6aD7uHThp4bY5NItLxuUFW3zet+aFtEjPfnfzARbbqGjbSMImFqzJ5UpJj94EOGQ+9hqaUPWHXGIXtXfnxni1Nx6vSQYk1m99HwJuRCXlXg9vFkCRNcxyuRm2hNAKkuSuC6Qu2Ussb4xRh8pHoGcHNqoUiC4STbNUnUPiC0QJmvOjEAqhEmpwcgVBsoeIFxHyYc9yB8mkQftRV6pPdyWUYtVw3fSH+uoONyxRNfsHSGdMX2TB0mM38FHzrnlmik5r86nXMtj5WyvlCC/Jrp1ZKZYQlbQZwGMPonbaz6tuG2xh8Kblta3iofuwSsIJx0pV8nkrVYnHVJXj6VfE4JePvd9NrpWWlq+XQhNjKgwM+YUfWTUvMMixFjIyYd0dQj1dR+uMVDwh9EY2qvYnwAyN6X9A1WT8JoPSTvIszFfRbqZwtQ7OV5ynOm/41uFRWKQbsTKoaeuGGlv4wgOnJDziqyOGGd7Ndj9fPixTPS6JB5r2Oj4WyKILbMWNnwJ/liJDPAe9y9LkCj20rPcONZLu8Dh5PixUpd1CCFJb4rxV60acFhCnXgi7KV9rrCWOxGg1timdp9dDUA
 2xpP8vXv
 iHMHxCWvQuArY2sdA0a54YH3yM6oY5ShZf48fWYG2CdEdQ1yH6jKK/BxdEtwNsi1e6vZcF/n3tHjiS+v/1FmSeXy4CJAumMEOkIJbg4RHBs+fJR4w1ANGoPD/IVIbPSpAE/nq0PuVJc7PmxHChUJi+d38EN6COawR/HZe4/FZFqwZdGed5LPZZw14AcgutzBtGqqC9BkGTnqBXQagjeLqRLFpmqIKo+Y83933K70mNO8FZqSX/DlqEychR5am+vBLlLvPVLSXPCd2JHsPs351Ji6L7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 12:37, Hongfu Li wrote:
> Several early return paths in run_migration_benchmark() skip
> hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
> label.
> 

Probably best to add a Fixes: even when not really critical.

> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---

Nothing jumped at me

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

