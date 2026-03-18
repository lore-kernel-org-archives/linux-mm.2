Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0D5103E166
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BE36B0190; Wed, 18 Mar 2026 07:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC9B6B0192; Wed, 18 Mar 2026 07:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E23C6B0193; Wed, 18 Mar 2026 07:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79F266B0190
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:47:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06858C253E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:47:20 +0000 (UTC)
X-FDA: 84559008282.01.5907303
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 151B04000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:47:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=OtUVOSbP;
	spf=pass (imf04.hostedemail.com: domain of r@hev.cc designates 209.85.210.170 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773834439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLqnHb2ogCoxqHkELJxhX6U8ujBBduz9IxDDxqOJz0g=;
	b=qM2NV9eu5Nj+86przPbArvSvenp0RCNv1101gvy57cs+1maG3661sQx3N4Mi6YAOIWX8EL
	TW4YO25kneDNI5FDs3FctIDcxTSEKO5IqzkdJG+8gLYOw0qqm5wLCrzwpl+WTijhjhWeOb
	fYF+ImS0jh8VRNc2cQmJXXJDiDdGwRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773834439; a=rsa-sha256;
	cv=none;
	b=qCd7/VkE3xqcyimlvrXaiFCYtxQN/+FPTx8jyrZYOIE+nLDuMX3jNhalShrcQfhoNmPr1O
	C1BsOmDX7fINg7ZEI5OIl+tG+t5+zcd0Q10x5+I1YGA5UEgcy3mKF7QWDvTxWw4RxY5nRl
	uk0KmYm5RNhvOF6kmfC0RC8pqqzh3GM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=OtUVOSbP;
	spf=pass (imf04.hostedemail.com: domain of r@hev.cc designates 209.85.210.170 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-829928e512aso3514440b3a.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773834438; x=1774439238; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLqnHb2ogCoxqHkELJxhX6U8ujBBduz9IxDDxqOJz0g=;
        b=OtUVOSbPjImHFAf1BFyV/5r4ExDGB7fUZhDZFccRw8s6zOuZJ+eqImwhIdcITMFqZv
         ysnyT95VaxSweZXx7B9ok2iLahaf1ZNPbA+e89HMDF2EeCQiwNO4s4sBl7JThLDDLdDo
         H0O19q+tm1cfdpssIM2g3AMWBDB2wuM9r7/OEIjjBFEeWEC4oHPwXQQlSme6fWx9TIhE
         t6mgsg59AGIOLHtVYmJHH4t/UaRlx7JMeau3OCpIexVoYOmzmllH/w0rZuVtvMPXKd2l
         4RcD+wbq8isijCxOtGojC3U/C4bJdqpynVohF7w+TTAI+Gikbo8PBsDwyHAwhg+t4p18
         s8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773834438; x=1774439238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kLqnHb2ogCoxqHkELJxhX6U8ujBBduz9IxDDxqOJz0g=;
        b=F3fptfzpSbII1uHU+HfuIhMOgNIOZj/VYKrY/qUA7VOeyDy4ZogRVtPnQOagW0BdCw
         RVx4psmxZ/7qhFVyGRU46Jo0ryothO8VE6kSzd9zv4f6qODI9xJtziqclK5lC0vfugrE
         ooBifs0KEHgAv7sOQPqHFF2UUSgvRttdVLB9BY/7dp0NKS91jOXtB/mtja/p0hldW3SF
         y/D1sBLv5TNfmJ/FWyREgkrZVQxv8VmYEl/as7nJXz/KtsfNOlpkhLrJo6m9KpgYKMbH
         5cjC8PnawZclbs1y20g43BXFGsZGcLFBVjd3cWn3dx2IbqsqFSE27aUWsrqpDTd7tlTU
         z3/g==
X-Forwarded-Encrypted: i=1; AJvYcCXMV3/xVl0+PzceMzDkyw+1NHFsUGY2oy+9r3SoksuPH9n6MCWUPYZk48rsB7+eT0o7SwkJFYb4CA==@kvack.org
X-Gm-Message-State: AOJu0Yx2uZ67zIOjV2+9DmmpTBVjO4dwmhW6zx/2Zgne6LwDpgf2WMO+
	NbTyN2Bo+8Hfh+aTof4L5KRgNSsZNgHWBu1qDQ5lywGo+lt2P+sqq10EYUGHplc9+iY=
X-Gm-Gg: ATEYQzwu8G9UguXqWy9akLMrG7JvLEf6LH/uFAuKgDl4CySSA8VFoBkt6pySmV3ztCT
	tAHbdbA3RmJD9gOy28QHu7uCsqGv48zLo+eV6+WNE37NlJLZ0uybH9XEqTdFQskyiLF01cGDaUS
	RERSvth5fUOL4rfKAbQI3aJncQv1MAmmvxioRal+4aol0zifIkU3CzM+yR8AjPr0owh3D+BYham
	4UrY1HMgLpvbPmHMarubxjp5fzwFP4KXIoWwTVyEVb4rqCB0F6rTTfj9Y6sgZdXBwzwPuS+qrzF
	njlYaqCbUxzHaRdGBWFYC/9sXI942zibAziqW6UR2WYJvY+7GOE+u6obRbU9nclF8u8Y5Q4b6P1
	/TaT6gH0GO+/ysqwsemC27Q4MDqkdgjdNJhCxrtV8F/1FezC0MrnmEhRT8iJZVGIb99W/piVtw5
	/D
X-Received: by 2002:a05:6a00:1ca3:b0:81f:4ce8:d64b with SMTP id d2e1a72fcca58-82a6ae4f234mr2558433b3a.44.1773834437848;
        Wed, 18 Mar 2026 04:47:17 -0700 (PDT)
Received: from gpc ([2400:8902:e002:ded5:78c1:8178:95c1:6ca3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6bf0cf5fsm3176671b3a.61.2026.03.18.04.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 04:47:17 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	jack@suse.cz,
	kas@kernel.org,
	kees@kernel.org,
	kernel-team@meta.com,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	r@hev.cc,
	rmclure@linux.ibm.com,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	viro@zeniv.linux.org.uk,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K pages
Date: Wed, 18 Mar 2026 19:46:53 +0800
Message-ID: <20260318114653.123656-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d0c0ac64-be15-4683-89ec-e32bf4867109@linux.dev>
References: <d0c0ac64-be15-4683-89ec-e32bf4867109@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 151B04000B
X-Stat-Signature: zw1zcctmoows4n7wzya93mdj5196jmjc
X-Rspam-User: 
X-HE-Tag: 1773834438-484897
X-HE-Meta: U2FsdGVkX1/7NgOOCdig49oDev4f2240xLySidQ001NS/NHuyWvmUZmYfG2y2+rKb4Be9CviudaU0LLAMhTPA4Io6gAk2Sx3jSy/dBaUdfj4imAoS2cwI3mWb8P5/IzCdK3lOrlUVlbxX024I9yKVvRrn//cc3UA5MY4Fi1BQ1G7wcbtF4Ya989Ux/S3tQso+h1ZPFMrxp71fbbbguvFFE8/BCbopwcLt1v64E2L2oEbkzTKLXlZPi5x0k+aZwbqbloMhwHf7QBJz+uWCGJXuSHjQugda7Rqy0EFX8i+YG5JLP0auEd1BEHFZejRUWrMVQDN+kQOpkJgvtUoaexbkwxGSedfD7wqFtceDQjoAuo89OxHQXEoatEYm5su673wSXpwFxuSQ+nwI0IFvOue/EUvZdUcYnJBmMf2FZX7xjHG6iPWj0z+k1jBknt9XTAf4rGAVVx52nd0SMR/6PDC02xq2Z+dTz/qSOubQ6G4J5ClrbF3R/2XQIVVSI8YzASkj//jzovCrFv8W5jq4jqTZUYw+lNzFy0OfBo7tLdw0UHDlCV9hM6I3sQEgsmwUs2OLmlUCFUigEEWZH/1oIUrhTNhI2BnEjDU2Ym9mvqAC/Xij+OlW/h//v26Q4ZHr27k3NXoeveDSiiEPex24Qhfeew8UZmQvKDhVz/DjGK/4aFQ8BTDTJBXu1GRGzEBd2tM+KNzrnFhGrLE5iTejSA2DiW5I/FEm/MZYRy73r+xFS3OcwA5SztilIbhgb8w/LyO1tSqyVSpVcVGSU/WXZKdvon2Il+q1q8eeQFRD0YEgfDlog3K66tHhdwxIHRFTjknJqJJq6f3SjNcjIyBtHs0brwt8ACiKBVAQx1rjTAVOREARqGnB6pmBzKrNQQN/e3mpDWQeldhy0bcVyyVSfyyb7yrrTm1r9BkdxUIVKcE/l9UDycbscxJ1R5mQG1XlZKgQnURO3iNlQQVDh1Jj2V
 7Jz4QtFE
 vyEdnf9mjv6ruOOD5mH9Ubtfl11qRuzhwPNbezptEVFOWPdNigmudnXPdwgAMoOdEdgReNg8S84zAuEBmdKSrHi8E/HIkdGJEbeR3Qm5GZ0aPq4hbBu/LH/nUVEMInbmGt9fwL7M3c4E5kme3gKe3P3BuhMDf/v8LsujGz1QMv3Jq2c08IRg4n1BhbADhYL9qFdxs7b26zhmVHLuXtzA/fG+v3qpRGkeVdHTHFFvxvVt7Aj31wqaNZxn7FwMXrfVw76N6dWsLP4qW4bLRmQm6iTozOV2mKX7G3PDAVZKFKWXPzLmQk5E5HVCtuy2k30/3ULyXPZ1qjIH7aCUIDc59sz3VaLpgZj61vgl71dusIzZtiQSDb6qjQQEzQ8MUDcKJfVldG4I8+M/K7we1HNGZn6u1EtsTlXS6o6M65cyl3DY4fUVzdKzw0aQSrfqNoiKX0ylBFOjIitkI4xWXvvp+DOhdwX2Mx+XcOcCtBny5nzCXBz/9lYSLaQWc5tJulLRiJpONStrcUL2kXdjQ/2Gpf4xILQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Thanks for running these! Just wanted to check what is the base page size
> of this experiment?

base page size: 4K

> Yeah I think introducing Kconfig might be an option.

I wonder if it would make sense for exec_folio_order() to vary the
order based on the code size, instead of always returning a fixed
value for a given architecture and base page size.

For example, on AArch64 with 4K base pages, in the load_elf_binary()
case: if exec_folio_order() only ever returns cont-PTE (64K), we may
miss the opportunity to use PMD mappings. On the other hand, if it
always returns PMD (2M), then for binaries smaller than 2M we end up
reducing ASLR entropy.

Maybe something along these lines would work better:

unsigned int exec_folio_order(size_t code_size)
{
#if PAGE_SIZE == 4096
    if (code_size >= PMD_SIZE)
        return ilog2(SZ_2M >> PAGE_SHIFT);
    else if (code_size >= SZ_64K)
        return ilog2(SZ_64K >> PAGE_SHIFT);
    else
        return 0;
#elif PAGE_SIZE == 16384
    ...
#elif PAGE_SIZE == ...
    /* let the arch cap the max order here, rather
       than hard-coding it at the use sites */
#endif
}

Thanks,
Rui

