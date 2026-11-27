Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3A9606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UDO58cDw
Received: by kanga.kvack.org (Postfix)
	id 03BAF6B05CE; Fri, 27 Nov 2026 04:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EF56B05D0; Fri, 27 Nov 2026 04:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D286B05D2; Fri, 27 Nov 2026 04:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC6CD6B05CE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:37:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5F4A1A0275
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:37:37 +0000 (UTC)
X-FDA: 85480396554.01.96D8374
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id AA6C5140003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:37:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UDO58cDw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795772255;
	b=xLX96j8FirKbO5P4MGiwXd3MkGaD3CfYnmFUWdrv3d8/2pAwCnUYHmWfWbH+bFb5TBt5Tl
	0RKJRJQgH2v1qiTcFAtLjxScUt5eGdiUnkLyaEMGMoDX/DrDT1FWUKj/lh6m0mhICkOs9C
	7oeZOPpEU8JsaoirL22ZfVK/8EJPOzE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795772255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mycMiyzXx6bIeUm7MdqzGyNDFpDgTu4MeaLSplHBqT0=;
	b=HjZocymVpYAe2BoiCFNIF8PusF+ZfAuyNPf6aUzeHA5vBckySw1YDfA+zc+UYHsH2IiYji
	9A20rn1ooEzUgNNchOr0E2Z8ypMR0fBwcqgfmCENfIjtujsgDw7uF0wRvvOC5gI3OlN5Qd
	aoZep2B4NTGWYh1RPT3wheGoPFTOBGQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UDO58cDw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb61185057so50484825e9.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795772254; x=1796377054; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mycMiyzXx6bIeUm7MdqzGyNDFpDgTu4MeaLSplHBqT0=;
        b=UDO58cDwI3FUKOKk3qd2lsEMXCvkvJrFUny8SY6b5xsm6yS5MEngr+7/+mL1EJ7QQi
         KEuS18qYuX3wymLwjOwTPDRp0McsKhR7g5AA1ms9AyN0t+VzznHTg8XzmwtLm7qqvZTr
         +4HTRaIYxuN8Uj1LhhD2rm9csFRzBKbaBFwl/OKg5ZUG7ktQl1sSUV5JF+rVVNiaik/b
         0V70MNUSHGMpcEbnq4T9AhtYq8pPDbCYJRGZVX7oyUk1HWmtf2b8b+KCKUQ+ATN0jS8I
         2Rq2Z5vgm5UPVYy7wDhVI05J4jRifd6aUa6xKpYSEkQLrfFzNxLfpjGPaIpSZWNe2L0b
         S1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795772254; x=1796377054;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mycMiyzXx6bIeUm7MdqzGyNDFpDgTu4MeaLSplHBqT0=;
        b=w/7U7mByQ/zWiaIEDlLOYYWeZaQERwfov4OU7I4ehnPC/QNoS80Bx7TLWyAz9ZlVAZ
         L0nxglAaDlmU5dibH8vs8sqRTBXn3fZX4i4qmSFql4g+r3B7He7mcbLj9s3tSM7Z3B/A
         w6Lj0HqkA/O4YyVwPcF0tB0mkNXHNLe0jxgjGezXK7kfjqtFOurp5HCXCCvPESnKzJqr
         EcPAn+R32c0K0WSqCxYl8fcgwNxlhidcmvkWPQigYjYZUlu2NfiRleZ4LBy6Ax1CaRBX
         2iZ3wlBvAuswMtK+G/y7fw2W3KucLegDZDxJcmv1W1z3IhapXqDfeB3ZRNvwBRDRf7Kg
         30HA==
X-Forwarded-Encrypted: i=1; AL+hErG38TmeUYzyJZA2t/f7QHTdj/EFDvkZEhQzTIjEvLW54zluUXSq7jnqmmWINRcj57m4DUdw/MbOgw==@kvack.org
X-Gm-Message-State: APuU4Z/M9Tfv5w5TzM0HShswQqapU+S/P1plEjiOKDeZzXg8ALXuf1ae
	w+NREeiRyH84+iZ5s44Vdzk+3odUOqA1+KSuFW4pN7VyE3jgkBOXeeOs
X-Gm-Gg: AZFdTZfbS7NQr2j5OIr5jD3ExMLo088BZafPaVKcBUI+0+/0JZJNlH2uNTJXvGKJrRn
	MiN2ENV6Dq7Nsb0WcQa7bcRTf5l95u6vyzvKovMw2L4Ysyosuuat/Fd0CTS4MslBAfB7jrKhlSI
	FdclTCjhxnEuzjFEdmO6trmUrrZi1T6Slm/C1naapyn7BemB+6bfPiz9+g58N4CGSVlTYgPwRAJ
	+Gsb1YkrGNlgG6YZPq5XVOgmuYwsBiX8GLz1iWgKeYC8ygb+SmMi9SWgAbvRJbSNKQHMlYMYU8J
	68mW0MYrtw4u1B6T7kw2VKiP4NCX19llSn0Njn8kRByxmPOxazAVgdMj5X5wQFEX8ED0BEkkoht
	ImC34FYLOOHukuLLxlIKBXbmpscXg5X3FVecH/PX/qZ25OIpzbA++JPENPOS3RW86zEV50o9NPq
	IkDnW8hBGEvH2cQHEmPkStchm3SedSBORaoqQo0UTV145jrXJlLyhtap//6e4TZqzcrDI13/IGp
	y126evS0bjF5ZUFfmveGR6i3S0uWYp8iHrGFZrWwgLWBuV9a8d2Rt1SIWN6h19b8zlzpRx6SG5y
	r03InvxeEOdn2Qj10OefjtZ/v3Y9TXQoHGSohNhV/p9xqg==
X-Received: by 2002:a05:600c:5306:b0:4bb:6ac0:6dc1 with SMTP id 5b1f17b1804b1-4bb887c994cmr473012775e9.2.1795772254179;
        Fri, 27 Nov 2026 01:37:34 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853368d3sm663915205e9.1.2026.11.27.01.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 01:37:33 -0800 (PST)
Message-ID: <efee4fa3-b49e-445d-b1db-624ea589efdb@gmail.com>
Date: Fri, 27 Nov 2026 10:37:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: serialize subpool release with folio reserve
 restoration
To: Aveline Noir <jm5905938@gmail.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org
References: <20261125-hugetlb-subpool-release-v1-1-7398c24d09b0@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261125-hugetlb-subpool-release-v1-1-7398c24d09b0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u4ebwz8shoj3o7b7ooftudfqzmcj9zw1
X-Rspamd-Queue-Id: AA6C5140003
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795772255-332329
X-HE-Meta: U2FsdGVkX18lLNqgFgncDU8ra42zjWpbvpJDE3qLaBa/RotSSeHTaDEc4SeAYNkZBlcu77KEvehBVMSJ053PPopV7KPGAyTYAbnWWFyIGmpfqH2HJp3UfqSv//pbcy7fJvjuhKcsmBmENtOsWG7+FEiPgdKweVqgc3pn5jdH4xP24HCzSa1OVyzGH82rwYNBjDb7DleKuR02Nm3lgUiFmfkIOir4MofLGmNRO+qY8SqjSz3VMs5PUeVIQbZ8ay/DYtZaM8PQ96JzT8p1UxkO2AnmS5EP8SyWEge6kYV/Cphxo4XCtQyC3LB72qzTRdSnS3ZvBVrS/JGWGBnYEA+v/q+XjWXscqI8owsRlY83u7YsQjLrGEsJQT8kcfNWIWoS0dgKuXpfR33ickE75WmBZyT0hp6gV7/kBTs3FY4E2wbIcnzA0ptkgOoWmGDBF7lGLdDU+xp3EYrK4qknBc2FR1kwcknKIvvq6313+K9UEmVvc/A4JjjKjZi6GUCN+WpC/yTgxyLlJX6phKLDaSorf2u8ESixv/UsArpLKpfI67QypDF1i6vYaUx4OEHPAaOFzdpWfLT47zDhzvTxotHYuP3X/AFroBEtZwP9/OAl4WHyy1HfQ4oIBROxf7bzi9NQd+6yUUlZXNzsYz05HB1pLcPduggc3ZnRbR+kmUHPDkPvn7a+qmc8I9FII4+dA+qSadk7Z8f2aLsrCG+PpGvfaZfrV0HHeiw8jLMMYZtM5sDSwczANsKQWS9Or1zk2e11i+E18iKK54jwe9qNe7N6SgKi8Lx+5dko5Fbb/sxl1FRqrQqRDiCZjUb6lk21ZL5fJiFW0TD5DNDKiIIHIVgP2vSqQUnsaeQV7CxBMZWWX0P5z4/YGFRjPipIk8CM7OeHmsygHF65Mbsby3K5z9y7MQITqeYktYzWXip2EFkjoA4oiOv1Qc4meXZgPE+HoY/MKU9rZAkFhuYBC8BRgCm
 3YVgpNy+
 6w6FKgGSBRgzziKAadSHwwAWQt29mKGRd8WLMRgPqgmp+6O9FYK/4je/+HjQqP0qWXa8DnlGRbNI6+V0GbtAtyHCeoW0gs1jKryZuUA39OxGsBmKasM8EBPbcKTLEDOJf6g8Kb80vIHhlC9r+sqOjFKf0kINgoBvV/CUxPVehkbYb0/rWdIt02Y7SspTwsDxd/WSDcqJCKK90qTakhMK69rFVTJjj84vBU0sAiWBUZVeZofKoEYpJM8ocvyFYpxAzc1Q6TqFi2fOzTjw2wLhH89f8kd4Nq+5Kw/hgM97wKeTMIU6ZgR7CRNpcYPjDGSR+09sX79XEsBNcTdNMBGkPjhZe7E+0/A9W+S9WBbb5wQoHr8X5Kg4FEXb/X2E3zfdwJNFSvMkoCFIp9DHdqTpbeXahvNFGhrLjhEZFOJ/EeHO8oS8t/yXraeW/wSEo/5EMpKkN+iYWxueRjHzp6KmXD1eho86sxXKPNMQfjIg6rKzF0okXm+3p9a8GhPmMNDfpq8PxSctN96EO8ZNf4LLS8rFmPYo8oJJqSgmEzfq4TPrT+ob4lg42uLwsQ01jjnMijl0scHoUY7Y4pyt1WvTYAIYKuuaBwyJqkPhqbViiIBtL09hlpewUG8oeSANKRm2AnqPZKzYCxrT9r6iQFO1S8v7ihgqHA0PG7BalYoMxhKNheJhvo5SwHmv3+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 9:28 AM, Aveline Noir wrote:
> Freeing the last folio of an unmounted min_size subpool can invoke
> hugetlb_acct_memory() from atomic folio_put() context, where its IRQ
> and bulk-freeing paths may enable interrupts, reschedule, or allocate
> vmemmap pages.
> 
> In addition, the subpool minimum is released before the folio's
> reservation is restored, transiently underflowing resv_huge_pages. A
> concurrent allocation can consume the refilled subpool reservation, or
> unmount can release it, before the global counter is restored. Under the
> available_huge_pages() clamp, this underflow also prevents collecting
> unused surplus folios.
> 
> For positive minima, take hugetlb_lock before dropping spool->lock and
> restore the folio reservation, release the minimum, and collect surplus
> folios in a single transaction. Keep subpool accounting outside
> hugetlb_lock, leave size-only and zero-minimum puts unnested, free
> collected folios outside the locks via the atomic-safe path (which
> defers HVO work), and skip zero-sized minimum releases that need no
> global accounting.
> 

makes sense to me.

> The ordering came from 1c5ecae3a93f; the commit below made it reachable
> by enabling min_size and releasing its reservation on subpool teardown.
> 
> Fixes: 7ca02d0ae586 ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

