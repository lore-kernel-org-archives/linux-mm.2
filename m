Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B1CCCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289AF8E0016; Thu,  6 Nov 2025 06:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262958E0002; Thu,  6 Nov 2025 06:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F0F8E0016; Thu,  6 Nov 2025 06:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0ABF58E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:19:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE3B3BAAFF
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:19:05 +0000 (UTC)
X-FDA: 84079935450.14.E1CEDDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id F204E18000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:19:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bvia0hXf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762427944; a=rsa-sha256;
	cv=none;
	b=UdiOUuLSFzOgrODQYai0j5/1r5C0kGmvTErV/GMbSGsEBZALseBgWPPEyYZxcDUw1HiCRn
	LPvXILakwUtXbuXjj6qqWKAKczuNV8sKS8SE0sjdLfLiY1sJ40uki/mUYKTzlbd2jpQZBf
	eFOfM9eu7RxhWSvuzMi6xShqOseorl0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bvia0hXf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762427944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kTSbJugHlsVsrURZIwjnPQtmv3J94C7syfAIWDNxQ8=;
	b=T3tuRRFx8yeKPu2V4VfmfVwf05VV3fpI6nn+EFMPHHuY4vlAyqy51Wm1F6L1hPrNIzI+n3
	gQL3tp6u1DzF2imrGaBeX7yScN/pSig4+YohVscr41WQHdQIfKBV4KRnpvF5BggUTsNzZ9
	0lrcca6oOW9vmseqihwDRc82BAFlFC8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB9D3433CF;
	Thu,  6 Nov 2025 11:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C2BC116C6;
	Thu,  6 Nov 2025 11:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762427942;
	bh=uImHPwXYfgO1OsgDjUhpotL5RTPQMGjlax5/2LxDgoM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Bvia0hXfwFamS3dGiFgQBaoMMG5MmqEThD5KdGn9o8KcIojUqXbnUEfhwSP3SDXCd
	 PczjxFlmYVUgjZVjsEhx3x0/M+Jvun0vI8752K6yBV/jqR/WxMxR/q8cR3srOo+pRI
	 dyV9en4CtAGWtl777bKKjxwTivN8Go+7/3LZRyvUVsonZO5OyY8k32H72oNsWAUqAL
	 zg/Uhu66tqP0Uyugrk5R9z8FjVKfJAwBDxMxcmDjE68w7b4OmppwUofAM7OQReutkd
	 OT2YA4Bg7/J5ZOPNvxfZrJ8lQcygIWTaqe7KANgdrbEXRfVyBMyaU0zMLV+4P2RwSu
	 HC0A5l+qjwJNA==
Message-ID: <fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org>
Date: Thu, 6 Nov 2025 12:18:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
To: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F204E18000C
X-Stat-Signature: sh76y3wqdq5ij5sr4kwb6yeeutp7959f
X-Rspam-User: 
X-HE-Tag: 1762427943-896955
X-HE-Meta: U2FsdGVkX19C8JN56HJSO3FtPAIXuym41OdifJd5lL09o7S71DB6iesOKcIT6zY7jIXj8tugoS9FzSxOchhvh2p6QfEMG00r+QK/3vTCFntJYEDZXRxO03GfO20ofhq5TjZdg55SGLZ7mfPHpKAe/yjUbt1jksDdcOh175fL1/rrEyvnoR+bHm/P1EtYy5I4aL70h325HNF5oLT17zDza3pDviz73cSXzGCL9Wa89WpG8EZv4QmmNhR+o7RZwohaShzxjohlWfFQZaIw6IYYciE47J42FG+wmNLEjtE3CFxLtRAF4NkqMFmBf3kWRIzR+qZbnFT3nAQcTblUNKL8/Lgzcl7WqFQ0iv2M/1OWo7Mcc/9okV2z9dqiIT7GHpoOknc9/o4TcSlTO//15+YSIBygNyG1oxeChl36fqsxao7Eu/Zyd4JVsuIGrQyGwOKLJQXG4gGi5Pj6+fj8pnWJqv3wVZx0LYH8wnLQCt/xTCFwtq3eirT+2WqV1rRqigrG9k/UA3q6L7S+O67Eh+oo0lHkIHfCGum7tdjKMcHAI9ZaF8ZUZegnvmcD2hVkia/VVJTNfDFI984GTIQKG8yKuJ5PYUXVYPk9PnTcH4UAyZePldUqz2+37tWmXL07mY7v18r+RW/7k794EBgMIGf3Ut7aC5zLOxa+6hqG2czqcDjW5IVqxoN3i5Zc+9MFN55kcV0gBx8Z1v1eC9WwBFcrb5qm1ProyZdwvGJTot41TcQ3a37TRGb+nbMC77r7AGT4O3P0BHznlat2/EJk5yJl+7dcTWsse1TdrnR+8kBWeD7aEp6iI+MGXjjPCaz9aUM9dx4BfNH/5KzOGiBrEZ9UiBNlcJfuSsQol8/qhxHMUsz+NAt7ThZ3vH+eadkcOgPztJ5XHRtEgIDiT0vFgPT39+jehZdowBoK4z0vUccwe9LlqfQ3IZsT9VYPPAaAGSdw96VFnRw+cwmNZAirKLf
 EEPdcKfY
 uXMs/GQEdDmwVOS2oBckcCpUyIyA6eHbXKibskv2jTayA4kLRsrFLYPIW4LavaMdD4hukgDady09/XGe8nGEVLdvu1gq0zXsi2MAUwkoP4V0HxTIyMx485K53RUs4Hi9ShUnxaNx8oblVENGukHK7n27nH9rSE+mmVYC/ZSfsLMFCIDCrk0oq4gwVdLgyRXGJGvElQfKmXd2jKiCxeMk+G9q1KGfM/em2ucayKi2eDGbbhEcqLcsBiNk1Wd7W89Ypc0rP62Puz5gOaQmrxN78TJ5T6Xpapi88tAmhPD1hUhXwapT6A41z2PRsghowIGjQ68Ynkm35JkZX05fJsWRaM43Wb3fIRyi2mkoMCz6sUOI5iy2ivAJ2MixD30cdR9oapZ7h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 11:49, Ankit Khushwaha wrote:
> Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
> triggers following warning:
> 
> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
> false [-Wtautological-compare]
>   1035 |                 if (addr + c.dest_alignment < addr) {
>        |                                             ^
> 
> typecasting 'addr' to 'unsigned long long' to fix pointer comparison.

With which compiler are you seeing this?

-- 
Cheers

David

