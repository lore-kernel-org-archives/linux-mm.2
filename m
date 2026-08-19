Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08763C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AEB36B0095; Wed, 19 Aug 2026 10:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0869E6B0098; Wed, 19 Aug 2026 10:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDBA6B009B; Wed, 19 Aug 2026 10:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C741B6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:15:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A3B680402
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:15:13 +0000 (UTC)
X-FDA: 85118216106.07.0CEB09A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A14FB20006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:15:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QTXh/QVJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787148911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbjD9W4dRfx8l1kqG4kJeNBsdhV6MaFUnq+9/t5i+o0=;
	b=bNFpq0F2pNwpvvK3E5mnr61QP8lx2b8ZD5Z8EOPANTFybBMQ6d4AVyh01+pswgNMK8Rf7k
	sITjg5cBKNlY9rAHSRDITPqxPCiextq2ZtGYJQaCoI0PRDrgkhPJ/HDnez/hnZUutFbRnu
	jnK/VoQHjsI1xAx4B1tscNSeY4+dvD0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QTXh/QVJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787148911;
	b=pulnoXPZaOiyp3Js3RgrNmbodLjCfpResfdNOhfsYDFu+TAmhoCzS3BwRjKC9Jnr0k/jIt
	7xAyM9OkbHFtzcdoQ3xyddKIFmCplUqT6rE7tx1Yh56jpqJW9ZFgUaQK9SuVZCcC6lh3Q5
	eTi7eb26/DqCGvPXq2IRNbiwkNWSbw0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D24E60A88;
	Wed, 19 Aug 2026 14:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898B41F000E9;
	Wed, 19 Aug 2026 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787148910;
	bh=HbjD9W4dRfx8l1kqG4kJeNBsdhV6MaFUnq+9/t5i+o0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QTXh/QVJwMCExZF6s89mCLjRqntA4DdohNZhzzkfOnCJ3ULmc/CidTZ+uJ1+rTBC0
	 4k5kPBkXY8a1mdbbp1RGUT8DgikRp0dd+1vdEhEcdCmipmYYr8RKlj46FUxRyD3Hv5
	 nA/sRH69Lx3Ff7MNIxafyvTyvY7OERSCWVD5O5AZPoZkTotx0BtjW8ab94WQZtlpj9
	 IAGuoEQ3JLhBygWyJ2FCKLLeHLuPLn0J7z3jX7z233+En4dVT5NTdqTHmiKajyI0Pz
	 zOP/f7UgzCkW8NG/ApgpXNWCWXkspwyQK2iz83C/ZcwHXPUMesbb8o+D+NAbNx4CiK
	 mAib6M3bJid1Q==
Message-ID: <fd193070-af97-497d-82dc-1f0fa1172fd7@kernel.org>
Date: Wed, 19 Aug 2026 16:15:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: remove the local PKEY_UNRESTRICTED
 fallback
To: Hemanth Selam <hemanth.selam@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 Yury Khrustalev <yury.khrustalev@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260818114945.1312987-1-hemanth.selam@gmail.com>
 <20260819074717.1345749-1-hemanth.selam@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260819074717.1345749-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e5bstozpnhw6mabw4y75sui4atpidkxd
X-Rspamd-Queue-Id: A14FB20006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787148911-833853
X-HE-Meta: U2FsdGVkX1+afusFrKXnCp72C01GNXUQFJ5zIyvgiPgHj9tXVyiTG/h6KGv1/kSRtDZ+o7FMUkeyWGMepWKD//oMk6BXZ/6wnX3Fz/UQSndMgh1jWkGOVSoweOWM97dCzQerGT2X4iiA3u9OWcytN9vGmhdz5jb8xqUcGM35aEYCB8F62eubqbbqTfiM1aQAqXdrhCSDauLMPav1WXR0RFyTWoVTRA8Eiqqlmn0Bcuc8AkhRhzY8RqzL3p6qVAhbE4GvvM5XTDPe4v0lanMXY1etgrNMiGZgXVYq7MwZjXmBIh9xaX6Z16Oc/sQiozOzGPvGGkQSkVV+7JSJK27Sf2eDnA1faHzETIAbrwECoCoXcMer22ZL9JFwoYK3Z49Ec0c5s+2SedxD3fNw1kGn9Eh9OFJHd487/KYs/WW87Hx4a9sQFaj874phf+E2X5Bs9m9b5Uh54mr/bkDDuAObXdKF5cLMf6wUbHOxSu2CuRx+zqmk+SOxLqsqJE7djucYI9hPBrGT6ksOGxPzLpigUDTY56Oy/lwy5YPsq5poZtxfo4u9te0tGO5Qj4aK+lplGjKL78J250n80wJEjFmm8pVWqPT0QahqVlX4ZWgPDlI2tHS4d3PZrjJPocDVSOANSWVxJKk9YmN3cUiYrvB/+ebUfQfS8l2vjrAvBIVLJVEsgUFSG6MwqInN1vkjs++2IpPB8NS2c7cD5A8oJPPQRYi40dsdncxQSiScgCs6eIGYTVKbzAzRGRnfChQrpOj/28ttWBtYaJHIHBVIbO/IiWi1ENP8vOGtfaAs2lhkqmDwY2rYt0IB+aSilKoBcFwQrpC6trl+dsixmBDydCmEGGybB+TIZGKz0axbI5+0QnERltaq3EtzflvpvqD1SHUPdROXwZpT2hlFtLIYomqKyEwdSFaq1RJEoRJGq/2S4xLU+XlA7dPg4kRuoGw4OZDxyL3H2ms3JsjLE+Nic1Q
 q+Ui+uMv
 kACJ7RujNsUXuWaXIn0HQEDc7wNoh2SVaea3M+1p5Fr/jTaRkUgvvKfJMC4b5aLNGXZZfDmlSKf/9eyOWFAmqIAMnqlnofuoaXBTaMSoPTfLBGXM8ssmGhrYKh0IkSv2JuK7zbVS/HHNn2MpR+aI8cBeiK/CK6HWHRn3NA5TME68dynWh2jf73CmELTb3Cw5BS+zHFYWo5Aivx83ulOixE8UeqXHetWLmoO20ox2jA4vEisRbUO/J1ZuVXcdeUtuzD8A2N2TFm1FhxGjzhVNAlZhdCBRwUYE+txRf7Kk7+1oV2yL0H17iLE388FHqLqLddtwbJawaG3LS6uaqBraf1e+DDTNMMNDT134iqBcjEaqsCCv8cK+wihxu3kcW8KkXJFqRqkKnvBgNak6b+3vjX/K/vQ9+sF25b1GaRU5kPTH4EvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 09:47, Hemanth Selam wrote:
> pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
> already known, a stopgap from when the generic definition was still
> under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
> Add PKEY_UNRESTRICTED macro"), so the guard is never taken and the FIXME
> can be honoured.
> 
> The definition comes from tools/include/uapi/asm-generic/mman-common.h
> via TOOLS_INCLUDES, which commit e076eaca5906 ("selftests: break the
> dependency upon local header files") added so that the mm selftests
> build without "make headers".  It is reached through the
> <asm-generic/mman.h> that the system <asm/mman.h> includes.  Building
> the pkey tests with KHDR_INCLUDES pointing at an empty directory
> confirms that; emptying TOOLS_INCLUDES as well is what makes the macro
> go missing.
> 
> No functional change intended.
> 
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Hi,

please prefer not sending new revisions in reply to old revisions the next time.

[...]

>  tools/testing/selftests/mm/pkey-helpers.h | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
> index 2c377f4e9df1..626c2e1655dc 100644
> --- a/tools/testing/selftests/mm/pkey-helpers.h
> +++ b/tools/testing/selftests/mm/pkey-helpers.h
> @@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
>  #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
>  #endif
>  
> -/*
> - * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
> - */
> -#ifndef PKEY_UNRESTRICTED
> -#define PKEY_UNRESTRICTED 0x0
> -#endif
> -
>  #ifndef set_pkey_bits
>  static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
>  {

Hoping this indeed compiles ;)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

