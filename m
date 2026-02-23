Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 515C4E98DE6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842D26B0089; Mon, 23 Feb 2026 10:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824116B008A; Mon, 23 Feb 2026 10:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730336B008C; Mon, 23 Feb 2026 10:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 615DB6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:49:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA1681601CE
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:49:27 +0000 (UTC)
X-FDA: 84476155974.05.28E05E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E36CB4000C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:49:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncL+uf1q;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771861766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7fYQTc84r1/zu9zpGzDG2R1XrF3H1WnRAanBj1ceeM=;
	b=SCPERYygK2rqdzuZEMm8y/o0IRW9MKdk/T3K3AQPx1f3zqf6xj13IFU/e+2nMXaC7nR0aK
	jyoQN+4wIxGD1mwAWHkAwodq7Om7sWnupyHTvUdQyuGX7MqHVrn3UCELoJYUWOx4lhu2jJ
	ZRxZH212BI8UvhZwZz3zp95d1UHB1e4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncL+uf1q;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771861766; a=rsa-sha256;
	cv=none;
	b=Wwo+hjsnAD3liCtfdEgJ6HBtEiJ0oi+7Y9pH3XyZUL2Gufp+9iaoiZcinFQ4qlYN5PPAlg
	4ZymzWTZI0J8m6b7U/U1G05/X6RkXFY6rR+yk6uPa2eBYZQZ729XypJvgSmRJj1ebz5KaF
	nw0mMKDE6qnuekLG1PwILYdeaUOfQTM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8F4341A1E;
	Mon, 23 Feb 2026 15:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E514C116C6;
	Mon, 23 Feb 2026 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771861764;
	bh=/rX5cxW6YqpqKuij6MEUu5GKJrUsD5jfRzpeftOIJZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ncL+uf1q/xikEc43CSU/ATVyOTsfZwmIpxPnpD0dPhjQ0fmzgG0lfLRkT4POPAq4G
	 xiGlomhIXQJTz5LpIyGkdg+9cIC3K/j6tccF58PzUeID4aUfC6npVuNwbn6uvv214Q
	 8WHqnEZayBjpl9XjAtEg1FUrTTf3v0OFyw2n9zlqioQAlGMgTO90zsa/0DDRS7I4gd
	 YFmYE+5QGr9ZTiv0+ZV8bKXAMEulQZGiWl9z8JC4bGbGQBCTMSEgQW5L7onFm1rvly
	 wUAnw8JNCbwBBsYq2TY/JvhKWevq7nluSZrpykS2X3BNGHbfcczPAvNidyexOAaHxE
	 JTxGDneQ98mjw==
Message-ID: <91fdfa21-9efa-4354-b349-921ce990bb4c@kernel.org>
Date: Mon, 23 Feb 2026 16:49:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Kalesh Singh
 <kaleshsingh@google.com>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
 <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
 <aZw1DlKHaWvgOtm_@thinkstation>
 <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
 <7b414e68-4d0b-4d2b-a664-bbbdf314c0d3@intel.com>
 <89cc554e-9c6a-4c8d-8c30-573b2eabccac@kernel.org>
 <aZx1EOLutZd1XrPP@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZx1EOLutZd1XrPP@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: E36CB4000C
X-Stat-Signature: ox3hsiqbojp166a3zjimci88w36xhro8
X-HE-Tag: 1771861765-44970
X-HE-Meta: U2FsdGVkX1+kM0kXiT1n3+P03UCirbAJXq3yWdWBF7tZb/wj/4vf9paE/voPEkwYdXWZbox31koLcPLs/4QL4/aerpTNghEe+8MTlhjoTnKn8Whtpr5J3uxEBr9ibBJUrDhaML+5DFTHUvc6COuxbzddq7ngZkZVkfIGYvXcvvWViq53gyz6LMygdTUXYYhZdlz7/MgpqudVsRjPh8HSlnCqcUz2NWsZu4NC3CE5s7dPnWVZW8n3ucU8uTOJ+PJVC0M9JsAHcxatQj4IShlfY/D7a8tXM7m0qxRTBDDgJ4R9FAXQDZL8fFJ6vkytdPohlqQZg5Md089v+PunQZdlztlP8BdtoWOrstt0C3YitQa6LuAbiKQnNnMi5KtSjM6eBlrJm+nPpGNICMm35rigiNOB93FCdGCpbqenSBSgz0cFgChBM3gawsgGUKlqY+q2FxGqM9pp0y/HYlDX08ETaDQqlBBD1V31A13f9oUxyvxKhHOad1EOAATy8p0fLPHuLeBR1QkwM8+BZVwyo81joMgJtyExsYThCzG8K2vc1bBHCipGzLusUeZHhiqUniT8ti2MkgaRfbrWClyYdCVAZrLFj5Z38nq28OSBCcGLUQSGUrY8jjX+t8cifs72sr6F9qml/6YDfYl5sylUt/bl1buZJ9Rf7Cs656r2aJ+JAXXlFOnj4RWK6O3mw8ojC+1dgtX7ozioylRCQZ1TvuTCdFCGu466Pb2IVL9YUExGDNWTioWJE8lGIFLf9AgcqUgRp/LEDTyAMhhr3uF30cv14N8SrwuNIxQPK18SShc74d7PVo9uCoGAWsmwxAIP9O9JPzrF2TFmBPiW2w38F9XeGkazwXw8hIasMj2vluLdYje0DGzcZguBB7Wt/z94rtg+scEVSqIcR38uaiTPSj/MPrJOdZhW5SNahKkTUVKYfazRVpuUkHR5XFbr5s18JKsAT3i0e+MzG777NR4cq5E
 xRR2HK+c
 6DhFQXMJgu6AKx1Wilv32MyG0UZZwJOykRTjH8ZAmRKVq8SexhscPbSpK8ge5UrLpZ7vDvorb6eTX/LB0tPF68r4YM0i+Hvo8ygqGXnEg0xrzkYeK2vqr/5BSGUyRclsh2BH+r5eH59grylrDdHdca76UYJ5UO8sKoFo2JVF1SdebK16/XqYblSAd3Neilg2gnyPjXaS8tYIHR07g3uDbScDUbBGeurOAUTGlGAHd/c7jTTfnUMXpPytxW1uTeg7Ih0g8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Just thinking about VMAs spanning partial pages makes me shiver. Or A
>> single page spanning multiple VMAs.
> 
> Hate to break it to you, but we have it now upstream :P
> 
> THP can span multiple VMAs. And can be partially mapped.

Single mapcount, single anon-exclusive flag.

Completely different story :P

-- 
Cheers,

David

