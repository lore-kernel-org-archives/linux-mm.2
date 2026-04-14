Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AA5F9D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25506B0093; Tue, 14 Apr 2026 13:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5506B0095; Tue, 14 Apr 2026 13:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAFD6B0096; Tue, 14 Apr 2026 13:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 806786B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:54:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F0241B703F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:54:42 +0000 (UTC)
X-FDA: 84657911604.30.3B82462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6A18A140011
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:54:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VSw8oHqB;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776189280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVTInWR2aHl59QuYgge7RukF8qLFnBFE4Shx6Ep0t0w=;
	b=kZaqey5qhclyxbdgQpnyIPO7DWmsjwuJQ5antFr0SlyunUUjHqLTQ+VETs7WTgmzBcqTir
	Ow8xI/uIGE8ULnfTCNhpNRBissn3MRMWaUHt9GH8jJ2y67Mhuv9wXPHLGNq0+soobZlK6p
	OB79WAcYGio0IS7hcC14WI6ZYRlr7SM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VSw8oHqB;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776189280; a=rsa-sha256;
	cv=none;
	b=r7vfrY2CinMTrjeJw0F2vEyoT1o1kyIPfyf0oqfcekelhVcelDUjOrFpMgVcPXT8exjsBG
	B75IdoMPg8bYBH0VG9NAQ5d+LjdggncrL+YhR++VCS+WPLfwwnK7Z0FGZEOZDpsg5Y+kQO
	OI2dHBstkHBAXjfxYEtiSdpSvs4pf0E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9104343B85;
	Tue, 14 Apr 2026 17:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F30C19425;
	Tue, 14 Apr 2026 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776189279;
	bh=Jr2B3lt3xXa4bQQKpEY82S/EjHBlc1NaMLGr1CILpA8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VSw8oHqB/VwrtwyDmI2U2CbPZdE0lVA8lEknsFFI0fMzklbjVtpVkFFyM6C8Oodsy
	 l/UfDajM3Y0Z5Kli7JlF2jJykBaRws2Ok3jZiHxV2VJGd9oSjUZq0x38m6y+K0xH5M
	 RmzNqux2UVGy5fEX+TJOrgBJqiU8DgQDetPY3tpVyXdvYhwU1JCl7GU8gkdHxxK/Nm
	 KzdYixz1Hg4jSOW5HMRta5xx8+OtnhEiH9TTDpezucl2Fp7RCARPDckmwul93ZBpx0
	 Jd75qMQUbW3+FCwZd+SNlr+IOeMO1w4+Kgds6y1r9kzqQJ1t8eSLZaSvLeM2WJmLeP
	 kEY2KSZcTpf7w==
Message-ID: <ce988601-6b5e-4557-8f37-068f35469207@kernel.org>
Date: Tue, 14 Apr 2026 19:54:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] MAINTAINERS: update KHO and LIVE UPDATE maintainers
To: Pratyush Yadav <pratyush@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf
 <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260414121752.1912847-1-pratyush@kernel.org>
 <20260414121752.1912847-2-pratyush@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260414121752.1912847-2-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A18A140011
X-Stat-Signature: x8fokgkt3d9grxp5zcucwe7qed34ceur
X-Rspam-User: 
X-HE-Tag: 1776189280-645324
X-HE-Meta: U2FsdGVkX18PgiNTvchZOmar2/8btBZgizliQfKNmYtfmN+eteHbz/3/vyAzdbn+5/vtwzjgL+A+auogTtObEeAJSFkqBkAs1cp24htluX6ixg/IK//3gaffas/LlBHSYWZHlNckl17lQl0s8BnTgddM4TQUz/eVnVnEQ/aiW7obTGpuwWFGVkam8FFFPq5MDK2t8zokTNNknCPp/WxUf/4uTEnHx6XKcVFBvlGumaFvgdh2qp7eUzyaiJImwvbur+O3EhkQfEbTGUdfXH1/gTbzovgp9KWe9301T+7zkwVr5/cnIu0wGVzq0gdP1/zsl2rHwYQl7fQjoXQepXH5kzOyM4kWF5jqWhVQAp30C/Z1pq9zOiTmamOwEhvaa0CP8ZI1V/tzJoVUCSmfzJoOMNnSlWRSlAO1jRFCYR9Kzs25ZRRmWyFln5cbtPrwGt8pAJKYX2YVBvGoHKNQd6Xsmu5wThal3ELtgtz75IyQTD5Xlk/ri43AlnndFSOpxyiilPnaUJZ1KwNs++2j6bEu/0R0UQgtJ2OtIkqyRCLAgZXOMacRcLTRvAfhVv81TJD8Yt7FXxoPcOvfsfbiXzFs7+KQKOPgNRoTzivZ6RWvzpnx4foiF77a+1BfdenKukHYq0PwwT+SfaM+j5jJDVvgQAXWN85twp+LmqlXXICoFaV5QJL+yZQJzBe6Oy9F5WTEzehxW4NeA8oeaBlK/MhcnafXmV+pt6PyH4d7ruE1et6Gr+5gQsZ9UbkVNHcr0162m9mMhtIMRwWaxQrx/UCOLdaM+7h56kaBVw8UgvNlBTRIMJ1tzziWdPpsqB2w0cT1/3fkcMnpoA+BMuRpotRYpl56cvisXGd1w79eElXQXgIR1KamatsgnuWGBLCfK6Fs9zQ4u/DaEcW3cWx6d79ndi+jxzn9qOiFhZZi3bq6SpSg2qgiRboC6jImpDI4EPTHHRkXxdSBW2jsXy7CqWh
 PjtQtP0U
 1f42hY8DQdEtDLu12ohsJi6SZAZKbeD9yGx+VoFhYiY0yIZpOD18pNKVZg/Hj6VFaS5kHZUchgrlS2T/5t5tBzbXe20uF2xWsjoVYWzfA0gPJj+tfmcjTezryHtyb4o0BOcBxyKzn8FKIVx+SfoCT6eAlvE8gwwxNYyvEOj9VCOmPBjPgfLpV8GdzVakIL0RXFZV8XAcTYt6poYZDTDYkUdTc3ngJdQcVBA6iJy+x+M3wk2BvmUuNJuLGQrxg2fYW+J3BoRYe21cM/NWMnsHJ9HI9Ete3VETj0XUH22u2iyMttMUiq/hPrYi+LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 14:17, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> I have been helping out with reviewing and developing KHO. I would also
> like to help maintain it. Change my entry from R to M for KHO and live
> update. Alex has been inactive for a while, so to avoid over-crowding
> the KHO entry and to keep the information up-to-date, move his entry
> from M to R.
> 
> We also now have a tree for KHO and live update at liveupdate/linux.git
> where we plan to start maintaining those subsystems and start queuing
> the patches. List that in the entries as well.

Good idea!

-- 
Cheers,

David

