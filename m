Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4E6606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=eoPUgh5p
Received: by kanga.kvack.org (Postfix)
	id 467556B05B2; Tue,  3 Nov 2026 15:49:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417A66B05B3; Tue,  3 Nov 2026 15:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3088E6B05B4; Tue,  3 Nov 2026 15:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0482C6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:49:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89885160443
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:49:55 +0000 (UTC)
X-FDA: 85394999550.10.19981E5
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9692740008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:49:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eoPUgh5p;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793738993;
	b=VU8PoBg2h0eJ+73vhwxAab0IFxLzWq4wSatUfcrtQl0FKNKStS/2z1dG8G0IOKZrQh/Okt
	V5KXHswiPA0ZXZoY3Lu3BskS1M7+uTe7FnNw1OmnlDmOaU85TaR5fIktqiyVejDtb+sWyv
	or3r1i0S4JAu/R7o5LLWGhWnc5olyvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793738993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vsBN/U3w7HiU12daWsEJrqxDOHajJ7sejATwoccs78Q=;
	b=c0W5nZUAEWSt8zIYmlE1xpklIVOCPzj8Nb0TtztJJfEAjHxPoaRGFzF7jVBtwKy1xNUM61
	wLJ+B1VJlPfaKlScv1V+sQS4k9iQ6bNYT1C6dUixAyKHltsKfFXfK3jQVgiURNVzPBA60p
	6WRXMYyL0zRj1eGoboJ3/oTqDFAyKwg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eoPUgh5p;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-9906a5410f5so951719241.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 12:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793738992; x=1794343792; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vsBN/U3w7HiU12daWsEJrqxDOHajJ7sejATwoccs78Q=;
        b=eoPUgh5pqoStrKY0r3he4bugusLLkdinUrRjCa8E42tGoUBHo+Q2V+Khsix5q53eW7
         iqsrioOfM7LFqFlGC1ie0Jne4LdUTKub1LUwwaXrO6/kVW2DfBwanLdmn0nKNx6LT2cR
         5SdtQ1M92zXD+cJZgDJwI9Nll14nHErrWQx5xpjO51NDaSYVCwLkzzHpM9s+cQN4pFU+
         jNZ9Yyi6w0PP8y4Dho35GJPXl9fKAJS7CC1gTpe8Fbl/iTUxKzlPvm1Q/cPPXB7ujdLA
         Cdj95/A30paGVDPZXaQhc1CTcsbAMACpkXNJ3B0s4LLCQRg4O6LMklFO4AFfNJbTJBWc
         KJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793738992; x=1794343792;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vsBN/U3w7HiU12daWsEJrqxDOHajJ7sejATwoccs78Q=;
        b=w1ycv6j7Jr7CIE9zcJxCF5j521QDUtP+y1mIrd8gdB2aOyjrkLjRMh9ukX37VuyPDQ
         LVRMXWK4luzW3Mpu8/i2wSwnO9+KU7g/i/XvNiXuKB2yRb9CJR+Wp5f8gbtXqHPf1lTf
         Dq6o9okrpNjvhlTpj2EKjnw0Squx0n8f3sm1B6m6WahmGzTIHbnpyx21aXfbWifqZco6
         Zl9JMYilvvZUyqMyedoBA/rfGbNd197pIq3oDcfa7kp3BgvltdJDpyM1eQFFkr1Nu7u5
         j5+5g+iTPM3U9yzxAQn27fMcKWRkW5Wh10+iBtyeN/ebUTHK6EgHJOKbq1YMmkU8aZkG
         lISA==
X-Forwarded-Encrypted: i=1; AKwUvBxTygoeRsFCaZS2qB8mCrHyHKJufVsZIP/Sb+1P/jbaRs/6tzl+oQMCsR6p7UpI5ljHHJlgFRlJyg==@kvack.org
X-Gm-Message-State: APuU4Z8mtpmCMy1VaufUHdNpd0d9FD3A38DgWJ3tm4XB5Elg2EP4iXV9
	TRkgd6kMzgDbeHXy63Epf5inZ+pKu73ZMz3k3nzq8EAOgUSqMzA+eBFop/2ZdghrlBU=
X-Gm-Gg: AYBFou1qBxVsPHhx76zt4GhM27ipLALJCVBRvPqetqry70UWeaDk9eEx4NzD7GVfqp3
	38uf/UU3DrMmKJIo9QG1Oe1I1m/SEgC7YWMJy3oNJjbg/KU83kvSrVLXLDws3uBMhecdvl45zKA
	K+QrCkgghkXu+AE2maawpoEWRHg/ilPkLoC4zQNR6yX9R8nVTy5J5DjIpakr4QALmxqY5CLVMBi
	Kp1avWudHf1NAoQFLjkhaAqjJxpZ/Ctg0ZX64Xo5YSJpKPZ4+zbHkVrVaBrk7ySoaS8n1Ip2SJp
	omR1avnnuoP7B9pwYcBpaV+/++jTeRH25vMVVVjRwHMTzpcSY/bqI2cXgPIq3eLlR1w0pA38lS1
	J6OZiXgMCu6i4jKC/5aj3L+pcIXbwbU+NBX1RpOUqMha2BPm72ZK0PDW5RlQ5n94OdKFF7z5l3g
	HtbIfzPstQhN20qbv9HGsZxS8p7VyQHJNS3RXfEQABt5rq7LNrFBYDiP+lDA/ZdvRyAKRUbFmkx
	RWDQihvsnp/CaqKGnduNf4BI7Ehdw6HKK/NI0et8ynq0y08lbEQ1SbxBHW3QjSLNyurBNCFN/zf
	H6T5TDe0kEqgurS8s1Th/GhXns4g82Z5ZX33RLBX4dxV4bvFQ1UPSDGf0ASUQdWEaMkKZVJuFuE
	TsLsnfPIpKKKihy47AE2P0T2beRf7vxTBScNj1wp7n2/T8POYy1PldiYHtlvjcMX8+lV6QA==
X-Received: by 2002:a05:6102:4194:b0:7b4:9eba:69dd with SMTP id ada2fe7eead31-7d0543c880dmr4776321137.45.1793738992639;
        Tue, 03 Nov 2026 12:49:52 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d77c6esm117398e0c.6.2026.11.03.12.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 12:49:52 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20261103172251.2348370-1-pratyush@kernel.org>
References: <20261103172251.2348370-1-pratyush@kernel.org>
Subject: Re: [PATCH v2] mm/memfd_luo: don't use memfd_pin_folios()
Message-Id: <179373899206.721270.10991415543158845800.b4-ty@b4>
Date: Tue, 03 Nov 2026 15:49:52 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: yrnkopstoq6ce85pw5ygsqd8pzd34zqx
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9692740008
X-HE-Tag: 1793738993-572362
X-HE-Meta: U2FsdGVkX197dPJup/Vqz16IiWa6MQuZLljbT9sF/qjjZP2Hyaq50sOgSyHAIUd64XH84+l4oiwjoi+48esvFTPQMDL6ymW7oY/lJSNHXk+PYm9E/DAYXBcyyAIbYWCxNg7i6QkNMn1nRHOjt0ww2zzEd+N4SE9/0apaR11euke18bUtqm8JgCa2jubo8cQumFGHuAw1P4Gy6iVHwoag2Jh644j0S60fYIzlenYReB7eOQI0Ih80S0ZF/WxriE29Es47VDQyG29FFCgI95DETmv3R+l6qIJSxrp/gDnbyF8fP4xUd0XshwI6Zsjcqko15ofwBHooi+1FXFDOgnwH5zjzo3r3PQ8/jQk/n2hzMtfeFbeY9DUp24OxRmcxFOEsIW2VlmXZ1JHo56sAqZlWq1tSp0v6WuPeUutQmCYAG03jSKj0jM50yyVGRT/n0runQP9f8VEh9gcc2JGsUjhBY9k6FoIJG8KZ7l+6jVep0+xp95NovQ5SoD20JdKugzZoFqOZqIQsCIDtR6mZ+XKQoTcFQ18sPXYqWKX+iuacyPWGt4qT+qHJUnQ8lQqsSJt8tEy4OCyzkRaeFdrvxA5zSk1DmckmTnJezmCB2l19XN9tupeCw+RzVfyEutg47Jr78WYYtk2xOIB4JzaD3mvgI48rci6WGh3j2xSUEQu/F8/NC9VCgBBDjPxwY9ZIRT9xKh3jMjIrudRLb0n6g5tQoTjJwHOjcLUFxQYB5hw0Zx4dIPJ6EfivDVmS7ZjWQ6NkLcxbDI5wxB9ocSf7uCH/woSM4/noV1rrHSVhrw+jM2RIp4MLJHfUGFvKCLqqQ/S+C8+fJrX7V6+uEcuNgcMs3S9m0L8G+iyV2eVvc/htr58l3kYWgAERpGTrd9iYxPZwCG+O9zZVY1ZAYOA2U0GqSDrXlImsxvP/qeR0LLrAHpToEn5EKP8oNUmOPhk0QSWV+p3yBDqFEKJ8lIx+MEx
 VOrJyBL8
 3p3UQKt2IfVHhq6TLycK2rln8U7PIQ3FX4TSNOhEAtPfWunA6ZrQws2EnUmac35IpJeOjr2sDukgyRu2ayU3+bEcD3QvylAj/AYMmhqUD2NnhzZyhGY8vLneRn8Qla6ZEwjxGnydIG+QT6E9r4ZwrnUt/nz7lIBxPCp9OefIj6PgfCJk+RjJh5i6zkv/ejCgju9fWJTMX6kKsLvoI7FE3PClhImd7Hte6oAfnp2baZtQlS3/TMDHX1NnIsO7KCsUvZjviNRnmxxnkm4HQ8e5TNHznLyzmNcC5pLE4ZzHoJtkyEE/6zdZiwoZTBUuL2l4mw3NUtT6KkqODQ/dk25sP7B7cWBhZOAs7RRu6yVOOGyNDvYZ/nOKk2/I27VUM4NH2uCkcq9A/rlB4jRDEB7N5dkqizYhuIXEq1sGbJkxrrKlvWn2TinIUg46GUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 03 Nov 2026 18:22:50 +0100, Pratyush Yadav wrote:
> memfd_luo takes a snapshot of the folios in the file's mapping. To make
> sure the snapshot does not go out of sync, it pins the folios in the
> file via memfd_pin_folios(). The pinning also migrates the folios out of
> MIGRATE_MOVABLE to make sure doesn't land in KHO boot memory or in a CMA
> region.
> 
> memfd_pin_folios() does not lock the folios. So it can race with
> shmem_writeout(). A folio returned by memfd_pin_folios() might already
> be in swap cache. This happens to work but is fragile. memfd_luo looks
> at folio flags and index on a folio that isn't in the memfd's page
> cache.
> 
> [...]

Applied, thanks!

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=next

[1/1] mm/memfd_luo: don't use memfd_pin_folios()
      commit: 9d07522bf59b3eb4b89b3a791a780a30884bfb5a

Best regards,
-- 
Pasha



