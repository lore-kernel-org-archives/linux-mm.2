Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C729ECAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3778E0002; Wed, 24 Sep 2025 08:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AAE8E0001; Wed, 24 Sep 2025 08:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A6C8E0002; Wed, 24 Sep 2025 08:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 041CE8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:41:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA6CC1A084E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:41:45 +0000 (UTC)
X-FDA: 83924105370.24.97406C3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8D4CB40004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:41:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V0SCHRM4;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758717703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJxt3d2F87wvI8Qe3x55ohTxk2SOPeGABJCtecxteNI=;
	b=Bd84SkFVCtJ2M6yK+hANBKhcIQWrLSLc9zgDwKCBcOuxtHzmqPejnO54ePYEiQVqUETLnk
	ND1sdjKgq5U2qxlxNC6DncPrbAvUgMFE0QBkZwarUwpCTfP96L3PTqS3KN3zO3VDzPCskh
	9OOJauVrOY5/sLhxUd7Pnv4LU71lKfI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V0SCHRM4;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758717703; a=rsa-sha256;
	cv=none;
	b=UWkHcbbB3Nk0p5D0rQ/AcrBuVHdZd6DLzYwEyyxrkm0PqL4DdbUdceDAKiqDgRjPGMf06C
	BGB0ik5ReY+OjWuZrhKg7Hi2Zx+IHlXKxa8ATdZCEFyWTrhFLBNW1DQU0qeN5a+eMk0AX5
	uar3ANjRRCvV6q0d8JQj/k9i2zeiVgA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758717703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JJxt3d2F87wvI8Qe3x55ohTxk2SOPeGABJCtecxteNI=;
	b=V0SCHRM4PJlFq1BAaB0UGmVGi9OOSV6Vdpk3NYiXN3WedZjoirmGpUZjTU4vwuLXXTZV19
	RVwyG5wCpCQqLxsKeHm0vtOCVPjvgYhIL2alm8E3Z81rWihji+zFzEE/4RLzCGSxdFUafl
	W6DdH2cbi258ZhWJTYgOBKs24XhiOS4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-xoI0QJnVP6OWgBNxSU45ug-1; Wed, 24 Sep 2025 08:41:41 -0400
X-MC-Unique: xoI0QJnVP6OWgBNxSU45ug-1
X-Mimecast-MFC-AGG-ID: xoI0QJnVP6OWgBNxSU45ug_1758717700
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee13baf21dso6651085f8f.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758717699; x=1759322499;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JJxt3d2F87wvI8Qe3x55ohTxk2SOPeGABJCtecxteNI=;
        b=KC4kvBNZbWRru9jvkoFht7hnqs5ikNCkv1spVni5e4LVoBvlYbGmucOsicb4Eubx5l
         bR1w0FE2Ja8/O78NZ/QJb0HZs38iZ42miPd8R7nS/kBCgHjoS2Vut1ZDuPERrr/qOGhJ
         CAuj0mVBJfGYNlec0aaDO2AbZNx3biD+yJyv6w+2c2dZiG8MRmkBp5qkVzRC13LMMQfx
         opzXeGK4I6zIJ+GE6yZ9naEfIerSnAr/Pyhevd08JdnmGlzgxE1mtimkdc/u/eeRKKnd
         eCJqSY3Fij/IVCpy49yhUUihyIlPCEiPscRBoHRc0ARnSOP23yVa5XaoMCZczAMlyFUH
         SJ/w==
X-Forwarded-Encrypted: i=1; AJvYcCWFbUg3fVzkOfn6as4Q07fn0mxpLvRNOwEsN1lqFHnVCe7GAifLzlCVWUt8Ej2VJDs8yLLbqLv3wA==@kvack.org
X-Gm-Message-State: AOJu0YyFquYQzhPpBw4+UwkG+sfiIBrOsf1ytIh/Olkf+vtVqN1WmUjE
	bE87iUfJaJx39GQK5DqsqTsiodbOoj8zBjop14WojgS7IPhxSKlnFenjvIOIlllvIpXjYdKZKhN
	lhp2x8fFPxj+F4gccAvmCba/6NWbAwifNNGhTQCPGs3P0My8Ov9Pi
X-Gm-Gg: ASbGncs3Xsumr3ukTirc5XJZKuqKNtf6zc7UQpyzebHKYE5oGrwmCT0sTe+5Rv3am97
	h4SUKOR1/awNP9suyRqunP42mnnGVh9aXkCy9JBryQ+mDRKIPlq0Db5INjV5rBacwm3wIzBPLgs
	id5Vc2gp/pIfXnLddqyJQgbhdraWcAVI/nT2NItrVZVO/5d+o3W4WLkKiYwaaZUpP6RDHgX5Due
	q5JJ0GGZQvEOq2yQ0g0LsCyEEd164gxnNaV4NuM11CvHbOwDUO72BXpCFeyXmh1mR/yFlXdFrqM
	QdIBQb/Lg/zaVV95eyPY9NgHzzNkBpQZB6TtEd5rB9gxv0bmTU8lJvusLsrY/aZLSZp/x5E95BY
	hKru/yoP9Nx8opujb7K9ICLnraoF2UAr+I0oZ3RhydZqvnESl3c8hJuIvyV03R0IZAw==
X-Received: by 2002:a05:6000:25c8:b0:3e7:4197:c99d with SMTP id ffacd0b85a97d-405c57f88a5mr6288974f8f.15.1758717699619;
        Wed, 24 Sep 2025 05:41:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHqqbOixBhvaKBIhVYlPl23Lfs3/UjwgQaCkd3TkUHwAqNxh5EIrZUMmDoMSlGXRelnCIlhQ==
X-Received: by 2002:a05:6000:25c8:b0:3e7:4197:c99d with SMTP id ffacd0b85a97d-405c57f88a5mr6288921f8f.15.1758717698609;
        Wed, 24 Sep 2025 05:41:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab7d4e3sm30435135e9.23.2025.09.24.05.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 05:41:38 -0700 (PDT)
Message-ID: <0d42e745-e146-45eb-80d1-8ce3a6777274@redhat.com>
Date: Wed, 24 Sep 2025 14:41:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mte: Do not flag the zero page as PG_mte_tagged
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 Gergely Kovacs <Gergely.Kovacs2@arm.com>, Lance Yang <lance.yang@linux.dev>
References: <20250924123528.1536835-1-catalin.marinas@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924123528.1536835-1-catalin.marinas@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LOxAddk4pDZi_-U3Jt7Q_kZJmowY2blgOyQ53dTOkxY_1758717700
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8D4CB40004
X-Stat-Signature: hjdyrykzfq1g8ar7ntcx7g1ubfaan5bh
X-HE-Tag: 1758717703-630177
X-HE-Meta: U2FsdGVkX19qzk/603iHqdSXNqGlzOqGPjHS5nh1S/Ckw5L9JPfzh5mS58JLLmAz1ssZ3vlZDu38fxneGgJfXPcTixJvcdWhi5tDwopi5EcCA57/Rf4SaUPVkmtpziMqMy6PsyfNEkgtupievMidwe97Kd/gzPWw3P9+nR8V5HO7gzGClPyT4GNuy6W+29OBqK1paXX9Y9nZkKOsgbLE2/K8jBUPukj3WIMHB5qtEbIyD0oGplT+FlCtJoigLBxN3eaRQ631KWK27U85IxzqSlOq2mZ+VPz4X6a/u4HO6o5IXEmK9o2SOp62EQM4ttaz+PZ8QY8pTNV/PxZAFbcVcKRVr6ygLJM5Ysx8G6CUuJj0l0gGnlBSMNpPgUHRqk89+U+kfgAmWcVxqg+pLTy5Kv/oOxVyphT8SXfFOuBGF2ot1QjlrPqjM64H/6VNH9p8Jzb0X0DNtXnl0O3kw2thsphEQKzEsz4oWPyhTy1NXzhFuqJncHWci5clxkvfsZNAnlDohwsGaALcBMhAhv+KdFfIIerD8DsWVWNVQd9tocxzVuzDy3RPPgepKbOqDtxrg8FOVOmoHCcquyJJvT9ZF6TgkOtxSvTOv+PruOLjIETGU49kLD0kuWW2YX2IcKKRVEqvbT1SYluNeaMmy2/C0a9s8+lobEZHZggGJRD8XgpIB+4VGBfVCS3GUhVywQJ/yHGsAhatDlOqCxtEz5aV1NQXl4o9Nn/sELxC4jR6jCN8S3g8d6UnrKx3t10TsbKe3QJrSZU7mf0dfzSH6H/P5aa5gQ5hxAdNJICzmAzFvXCKnMhKb/nIWJPLekeqHx3HtmxqmzxrAG35BfshejrBn+BsoHji/ATTvP7hStQ04eAAMDDpw0LpQm3oU8c2fcomZ2/2yqjm6AvoLod14JpUQ3yQiYSZDk3WMdCqTo86s3MYzLlT7Ls7kWX+4s4zK41I5ZCqP9WscqAHAT2eFD3
 jb0F/l9i
 impHJaGd9Enh313M6ucKaBvaRxtze1CjYczv/eq3AznDZ7x2XY07LHx6pqJHRdRImqh3wz0jmQDkN/r4Y9jXd5UsM5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 14:31, Catalin Marinas wrote:
> Commit 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the
> zero page") attempted to fix ptrace() reading of tags from the zero page
> by marking it as PG_mte_tagged during cpu_enable_mte(). The same commit
> also changed the ptrace() tag access permission check to the VM_MTE vma
> flag while turning the page flag test into a WARN_ON_ONCE().
> 
> Attempting to set the PG_mte_tagged flag early with
> CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled may either hang (after commit
> d77e59a8fccd "arm64: mte: Lock a page for MTE tag initialisation") or
> have the flags cleared later during page_alloc_init_late(). In addition,
> pages_identical() -> memcmp_pages() will reject any comparison with the
> zero page as it is marked as tagged.
> 
> Partially revert the above commit to avoid setting PG_mte_tagged on the
> zero page. Update the __access_remote_tags() warning on untagged pages
> to ignore the zero page since it is known to have the tags initialised.
> 
> Note that all user mapping of the zero page are marked as pte_special().
> The arm64 set_pte_at() will not call mte_sync_tags() on such pages, so
> PG_mte_tagged will remain cleared.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Fixes: 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page")
> Reported-by: Gergely Kovacs <Gergely.Kovacs2@arm.com>
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Will Deacon <will@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> ---
> 
> For reference, discussion on page merging here:
> 
> https://lore.kernel.org/r/aNKJ5glToE4hMhWA@arm.com
> 
> The deferred struct page init problem was reported by Gergely offline.
> 
> Given that we've had this bug for over four years and it was only
> recently noticed, I think we should merge it at -rc1, give it a bit more
> time in -next in case it breaks anything (not likely but you never know,
> MTE interaction with the mm code is always surprising ;)).

Agreed :)

LGTM

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


