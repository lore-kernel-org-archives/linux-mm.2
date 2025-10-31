Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC89CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C608E0080; Fri, 31 Oct 2025 13:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8244C8E0068; Fri, 31 Oct 2025 13:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A218E0080; Fri, 31 Oct 2025 13:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61DFF8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:16:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07FE913B458
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:16:01 +0000 (UTC)
X-FDA: 84059062122.14.204C322
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 56C8320011
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:15:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NndvDcKe;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761930958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgmTBazmU3APPPKImmp2BpdY5glVvngR/Z5Kx4m3KiI=;
	b=AIILnx4AGHQjV5QQEQOd1XnZQWZaq0c/O+no6EtvVeFOxy2T4KouPPpmLkThNsEpgMXaCL
	mjGPFP4aA6VPHAbfKeAqgF2tCJGpVoy54djwqiKTUkT1DCXtATJIBGPBkS41Um1WQkNuWa
	/M1UHdHv+wgEHyuxRsa5thVOQbePUEs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NndvDcKe;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761930958; a=rsa-sha256;
	cv=none;
	b=xUqk5tdMMX4tPSGaampK0F5vR6PuBiIS7wxBdRqAHkSnQQx8C6oyi/D/T/PPxCiPaoGNXb
	BWG98BjEjD6kvppvCH5kc7UKG83zEBeO/LKXC79dhoU61zDyrxKEqecrFy6hLKcgbCyl75
	QJtj7yHwaTNaTJi1nTejJ/942sVNBVs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761930957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tgmTBazmU3APPPKImmp2BpdY5glVvngR/Z5Kx4m3KiI=;
	b=NndvDcKeEEvFohc+tDXKUegdIfAm/fygEcp36HULEgWsWf0ATIc0HCdKltH8U6FuSC89Sb
	7j//KsWo48nGx+jOb6NXMsV+lAJsqR1GFaP4faCnEsBzwAPRBbvv4l8EhqGmCqW+dvo9N1
	V0SUssnayP+K4ZiZaaFhCpgyznsSIJo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-KlE3LCyQOHqe2HIs6SvYPw-1; Fri, 31 Oct 2025 13:15:47 -0400
X-MC-Unique: KlE3LCyQOHqe2HIs6SvYPw-1
X-Mimecast-MFC-AGG-ID: KlE3LCyQOHqe2HIs6SvYPw_1761930946
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-426ec5e9278so2248779f8f.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761930946; x=1762535746;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tgmTBazmU3APPPKImmp2BpdY5glVvngR/Z5Kx4m3KiI=;
        b=qDP77C8SGwAZdXLF/39MbUIv/o0C5wAM1fgAu8c2RDvHkYvWl/Pp7XszuDMlJkSJ+p
         n+inJs/3G9AwyUQXxJKpTRWLwzg1lUPQ5QyWGKQFP6Z0bC0eWGT/ptsjkkkJcL7VkLrL
         i2FctG4I3x5fl72TfBsvIT18A/Bojw5oo24KmLLR3Mqei0OHnTmLdrJjsQj5eKmipMHf
         SUuEXlu3dSONv6vhoj3N2pqo3mOpSMDU9x6vH8FcpVsE5I3cGmcfyvpQVQuMUy4PatP8
         tx5Zb3yNU8NKWkMePOywS2drpJWr4v0kQ/DvyXjA6ubjqZIbwccZdfCUY3dZr3wYREzT
         4Abw==
X-Forwarded-Encrypted: i=1; AJvYcCVaQtQYnx6Q6BtBN+qbmJM50+LHj6dsNigaS1jFhWPI5K7fskBc6z0kSATA6+72XUe4Yk22PKuCsA==@kvack.org
X-Gm-Message-State: AOJu0YwE2hOmG2izjvN5Qu5eTk82U/+BXUscyPugOJeFXfsCp9TauIVM
	uynayaxUdIsgL3gUT6fJ19KAnGhXi0Vtu3lvK0bQdmKiofg47RuO31p/TDl/lnx5D49brx6nx+a
	gS/aZk6o7ceK4umFiJPTthyq7E9hn6vC71eFvzJI5fQw5t2W/iBZo
X-Gm-Gg: ASbGncvQrlC74WCV4lGw7xtxDFJBTp7rTJ11C17s5FuqzsMzK7b5ADYovjPPnwarby9
	MzoX5PLLYaILxnl4ecVVXCsP6pXMwGoJVP0uO0iigxDjmTxxsfwk+IJJuCtWopD6gDZckgvcMUi
	NTZzbxKa6lnFCOQ+uBQg9XXKpcD2sxQv8VymWyn375ah9PSUJH6/eA+VgIFR4+k5LfE8QatazFv
	AG9jMjA0Yuc6iHQWbL2rILuPxi96cIdn6XbpAXAyi9WMYnEsFMU4tVhgdTmJEQSivDMAP30Qdvf
	qv3xuZrzZl3L3HotIDbJsZ3GbKsYFKaTeVyV1k2Xpxwo7TCaH1ua1n2UGVPqLBa4T+nbUghv1sT
	FrjA7Z/M3lAM4b4HH6l9nE9cz1Z9LtnZlJTDI9UPXG8aswTpLu6j4ntLRC88xjFwFRfM5O61fXJ
	cGYsRScMP3urA1qP7bzq/gVBYpNd0=
X-Received: by 2002:a05:6000:2585:b0:428:3cff:3234 with SMTP id ffacd0b85a97d-429bd67e0ddmr3468011f8f.21.1761930946245;
        Fri, 31 Oct 2025 10:15:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfRdCnmdJNsaRWMm6Hvpwfn8ktJOmZbZ2fpl5KdmmxvY0X5gxISTNhc+2EgznD9qOwvAwSBA==
X-Received: by 2002:a05:6000:2585:b0:428:3cff:3234 with SMTP id ffacd0b85a97d-429bd67e0ddmr3467988f8f.21.1761930945762;
        Fri, 31 Oct 2025 10:15:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13eae16sm4529835f8f.32.2025.10.31.10.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 10:15:45 -0700 (PDT)
Message-ID: <7dd84c85-3cb4-48d1-94c2-83e17bf74d34@redhat.com>
Date: Fri, 31 Oct 2025 18:15:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
 folio
To: Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251031170133.280742-1-catalin.marinas@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SfJud1muWusFiEUdQF2CPTKjOyaXnVzWJ-Hg38Oo6DQ_1761930946
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 56C8320011
X-Stat-Signature: qdotg7pn4s4cbs8ejm6kdg13fuz3in6r
X-Rspam-User: 
X-HE-Tag: 1761930958-812692
X-HE-Meta: U2FsdGVkX185oqJnpS0H6XHp0FAlxFFQTdHSDUxRHdVrylEzoSaZAQ//mMyVXOpV1zILw0HQaVG9kSVabRbLM4NjYv7trAwIKzKnyU0DoSPaGZslTIi5mCsA/CMrUQqqU3O8bRVcL/TT+ZBU9c6WSR5BsBA9n+mAz8jEI7PWrKBd6BiQptVnkOetbcgEI+Q0IkUzzT2sssL0dYoKYP0iK8O1c9UtKIZU+ZbaXwO8obRrFOXx0FUHib/t18uFDX81jwlifRxgbe4Os9oA7CBnXXU/NGogi3+iyr5mzsfW6c1Ka0Y3pAAipyqhIm+HzwrDAk7f8Tpd+yH97LhOocB5u4wZDVeTiq/QWFxF8gfjyv5l0ikmWg/cARARIp0QHW3kyH1BFIq7ZkEyqcFs54tJa1b2YDlwSaWLkLyKh/TI/ugc2r9jDCG2JV9ut7htk7If6irzLztxk2Figkx4AYHueHb3S+JpJwKehQM2lSLjRa5jq0Nqoa9ZRjFluQKG39lyb7+KFnZLDYlGh2whZ+1fBAw0AAttTD31fV0kZ4n+28yySGzGj9vaqTUtXlX5qXZ3kvSuJXpxFvdQXNTQzhGLhn4xnleIyhjy7TRWzTnOA1PPkxr/thwkgNNs+srENybUzAgp12vMOQjMpv3T7zhANilIU7vOQm+/JW3+HfsHX94H3cMxQKuyERi0stmzOpE91aT4WHcbm6jZwTcbLA3adjn7qq/nj25Bj3OcBsI32laE6XBKIfRIQEyal483K0ZBkRLvV+6g8EZ90s7jJYuBF86gVturJcfvouf+M7uSO6vxdyz/NezR1evlBH6hsWmsZinqwlrzwOUsf0Q6FqATWffSc/+c/CwlK2beYnwrxh6WywwbsfGnVeKFK7tjLS6DHY2BpvHOHOs0qJ44xh/sP6gzT4PVXy2KvefmDpkTCnmMNrHpMESsuuWZ2eEFgBuzl4JNiSmEZAeEMkUAPLE
 nLr/mOOD
 HHrmc5++ski8zTv8eOcrrRYudYiTpzh3xPWOXwW6AH+L38yWh6kY11R4+NN/Ym0mXJzD3rT+LpUekq7e44WmJHw5OBuV2gT8eFucjumhOJ9tV5KLxRgASVM3bFp1n2BxobLdXoPbD/SvNX4S3YD+xT8e5heAtV2zSLEh3A229MWrZ3K12No+9XihsE/E4W5Hzt0DDUq8ZuEpQEVACrAAfF3QSUe2mnYw5cOAjOvcPxHYsV3gOxpmtk4KiTG/fV0pt8zWEy6BP1rciKWgK/XYnBqefzIDsXmgfAmdhTV/ID3ndzjdZ1t5g827Hk92PpEN2G/ydauAFXwFD3x8dQNkpIkLEAudBo0Z8X2gzhWn9wWWGCqxkgn4QNpVornKmeGxCye5q4JOm9p9xFMAW418r0UQWXdpPLlXfbV/0IIW65kBOTd+uCB/Ci6aeVeasXJhXMizduG5dVhxL0yZBM78TEvQqcuG8p+HdtqTLdf3l/x66fVaQFZ2mtuXj/o//DoKb+qWcLAw+tibBFO68DSJKLA4nM3tu6xBHyMOFFmkJbYSJpuPujDF4eCZjUu9RMCSTwN5zldXp8gfi0nKlIIPM8hZeD2kg39xsLF23zV9Q8AUBmHM8tfon6oAwNPO/U0bYP59DGq5Rrh8qMtnLLvVz/TzsvUn256B9JaRjTfLY06w3hhM8zQZrujlxrCjpjRhrmC7c6TBBNdbB2KXCYF2cQdEzKUcBM3VWel8N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.10.25 17:57, Catalin Marinas wrote:
> On arm64 with MTE enabled, a page mapped as Normal Tagged (PROT_MTE) in
> user space will need to have its allocation tags initialised. This is
> normally done in the arm64 set_pte_at() after checking the memory
> attributes. Such page is also marked with the PG_mte_tagged flag to
> avoid subsequent clearing. Since this relies on having a struct page,
> pte_special() mappings are ignored.
> 
> Commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero
> folio special") maps the huge zero folio special and the arm64
> set_pmd_at() will no longer zero the tags. There is no guarantee that
> the tags are zero, especially if parts of this huge page have been
> previously tagged.
> 
> Allocate the huge zero folio with the __GFP_ZEROTAGS flag. In addition,
> do not warn in the arm64 __access_remote_tags() when reading tags from
> the huge zero page.
> 
> Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Will Deacon <will@kernel.org>

Acked-by: David Hildenbrand <david@redhat.com>

Thanks, Catalin!

-- 
Cheers

David / dhildenb


