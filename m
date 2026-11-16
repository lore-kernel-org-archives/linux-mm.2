Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FA2606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pz7j/Ikj
Received: by kanga.kvack.org (Postfix)
	id A90266B00EF; Mon, 16 Nov 2026 05:35:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40646B05B0; Mon, 16 Nov 2026 05:35:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F456B05B1; Mon, 16 Nov 2026 05:35:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 741806B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:35:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 016B51A08F5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:35:23 +0000 (UTC)
X-FDA: 85440625368.12.52A0837
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26F81140002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:35:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Pz7j/Ikj";
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794825322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iyaQZx4YaB2JOzxstluIUEtBMcc33AW6Ym2vysf33mM=;
	b=3W4hjPv6tg4jfZADO08rx/4c+AiZB6fgGZ7T7bgLgnyr8maUAjdCTA5kRwwVUKMUZkXFRf
	eHjJLZdOc2rx/WsER+oxb3sigbb1wbC9tUvg0vGH/5AKKfavqxsuiMYDjkpxQH59qb9TPo
	E+BXBKYnbCTVvrEcDGZ4u69PkTaqe3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794825322;
	b=e8r/cx9rB+VrL/KRHTRELAnvbKgtm+Ss19hIg/d6m/OGUnjinpN68wqaaTkfN2Ij5IoFzl
	m1i6eM1D2tvJ6JwDXrJnfThJfcApZMRyqc0YQ/hXsLgoOOFHnKqorgzQDK68lvMUurQP9j
	m3IKpNZeQrrsEIWMMsAXyQ4i/GvJgP0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Pz7j/Ikj";
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so14167755e9.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794825321; x=1795430121; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iyaQZx4YaB2JOzxstluIUEtBMcc33AW6Ym2vysf33mM=;
        b=Pz7j/IkjQtNOs5VvhAob7zLZe124oJ17jtJKXsZvj+EXTaP886L8zH1QMCTxIN4KTn
         tm9ZDK/G7I70YsWUPwUMvGaWTLWik5ha4DQDXyEYj3DT+cOUGMTiNiQJazIuPja+hcWz
         d0d0Nr9EAONA621gORJHn9NaC6M3gBcTjEXMZVAOl+EiJZ7czl+gFRfFWm+eW2tRMb63
         LmfjFdOXxMULC6RpKVhO+zbc/hMWSwb1DsYaBfBnD2ejWuJlU4/GJ2XaZaUgbZLruCEO
         HES5KgFsSMbfK/d1zUK47oWX7zYGDnawPacG3yQ9CkJVCVYRi5y1nw5XerW+NEHnRxkH
         hQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794825321; x=1795430121;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iyaQZx4YaB2JOzxstluIUEtBMcc33AW6Ym2vysf33mM=;
        b=co5MKgaaOluF97RonBi1JlO2VWgZmnanEocPnYzo5NzIQXMB/CtW3IyhXyH7JrVzYu
         wlwKlRWnJKgySU3xN30CMNOUMJ0s1VU0PGPASz8ITaiCLqsTUNAqjVWcLN3nqqfrx+rf
         7RfLPr+BCqgI/WAHg8yg1r83dOltGVo397FPtyVq1Did8d3o6+A6NBFMW9goz/lawRGV
         Qm4OApgpalHIgsoD9VLIj0GPyFYDjFx5HYX0cV1dCoOYB02hGlJ6oFmjKuFT6wxVtqpj
         EywjyIcUgS6UnW3cnUuVJ8ImeKBH6NuSUWNCFzqIRiBVVS1ZGGfipcdDp9z5cEGVc8ES
         EHzA==
X-Gm-Message-State: APuU4Z/5kQdsmokSU7VlSair0q+buzTIhN07JHTi7NOjb/ABROdlxv7z
	MtpFIS9MehxngdX8YliYO8m7eTYCFLivOb0AeWacmGnd6AtMNamILrLM
X-Gm-Gg: AYBFou1yBaPTPSHhwFelS3wOEzOfNUJBQJ2VT379maSGPdgrB6wEn3vuFTYsiUPLHHt
	S92hCylPUBX31drdLiEfIrgbY1El90M4LJznZQxcftcn5EuZBfK8Q2es8yRuXATUwJul1TLEJ/P
	NKJ46EBdVT1/lRWtpRwFUDz1Iq3tUyl0SIYW6xhPRZZU5airExozLyApVdJVtK3aJhDSFfMcWk3
	FLUaVJF0dP7DFe2YzD0yKICYTIfpuvdbiuWVxBnx5n7tBs1HawfqKwcTSP1GupDGiuM0JFWH+XC
	0oZ7qztiXAeSb7BOvw093ETU5Y3mEQCHqk3kzUU/Ej7aJcX4W2DfrdvWJxmEjcwLVDfOve/36ep
	I2tSW2qAFsTIZUAaBHilLxJ6z9HKj48G633nzNrMMN4Y9teG8p79PkN1P9wCgxe7TheUz4oWEwg
	+4t5g3SyYq8PxRi78oaT7cMrcj2dOWGx+IVwS2vmAF8I7mceaRdxGn628iECXzVdO7/ogqZQKTA
	n88kdy7P1UtBVfLtPyaIZKuQQrKO2MgaHSBuQUTQ3117kC9WiNp7idHq0HwM0vDyyw+bV5j2lAf
	hdY/EdVpjkVadFs8ueEp+/F5vw==
X-Received: by 2002:a05:600c:4f86:b0:4bb:5fd1:92aa with SMTP id 5b1f17b1804b1-4bb5fd19428mr160740475e9.15.1794825320590;
        Mon, 16 Nov 2026 02:35:20 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb675200e4sm118113715e9.0.2026.11.16.02.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 02:35:20 -0800 (PST)
Message-ID: <b3183fe8-5e7f-40c2-a534-c643d0fd2bed@gmail.com>
Date: Mon, 16 Nov 2026 11:35:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: qk6kohu1ts7c86n8g68oaw7dmtssqeud
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 26F81140002
X-Rspam-User: 
X-HE-Tag: 1794825321-228661
X-HE-Meta: U2FsdGVkX1+nwp3kM5zcQ61EOFftAi1NrzRtKhooo5DOVQVqjMRClhR7QXxyatBPcym2XdP+6bNjKwpdLjo6EHBJSsbmjPQXb9PRxlk5pZvvM8RQQxiTasZn/TrwFib7xCz5nxnxdkuVL/T1XnehbcV3KADFBPRKKDC9j5RJ5pBSqgCvZKpLcHpEVq0Z8Q/8dnaeh9orIeCzYPJc6X2MEh6hKVDgMnphJlWRV2kfn76T92aRQJSANC5W0OWUzqCF3D8XwKOy07DtH3Pp/G3KKwwKgB2EWm0N/us9OxoLCsC4DLBPFx0UfsmGOdzP4Jy2HVJrvKKbdhlBHt/ujfJKhXzNkLG8362/+f6tu31oHThjsZ+lAEuTILp8s8Ij42ydaDP4tUsJNDDHmtwEMCgjiDHKUn39V02Eu0Wy0ECOf6eRWndCV+7gqe7nWX09UpgL0AnHSGYRogBFPwfkBCB0bjYW1FML0s5l5HDTMnrDwjQby2sEedwugeeH9zHEi9g0uPH1Ht/NM1fbcNoLiPdtbTGH9FKOSAJY9F3MzugRyHIGBUwPaSFYfZT9ZvgG3NAvOxi6oFNnhBCqHrt/wB0Rpy4F2dLYvINeyZUBxTAxIYvRpR71jA3wDpqKQVm3LH4RA/ufeNM6PImA8y36BmNCvNKkhyDcAC70pQ+elMXvu2Zxlda/bTrthIIhxx2SAee0bOfSQq5m3jRLwKsoIJ2GUVFatbu6tTTJpc8De4fEzomG/BHaUNF2MLetUYUIUdpRHEyQZRvzpIYWHUERqk65osOpR4xZKML+Lh897HiLnu4hhw/OPq6IUgwoIJCQZ6v9D5d+dLRoq0KC5x4zrvgRmcDUwD4GusTmcODDczY0Q6iIUGtJLGX9+8HjHWiyAjTYek2s+jHBUnzRUtO9kYjapqC7xnDE42AsegJA555+hgIyBUt+PH5qnLX5KU9XYfRA5wza4TeT8SOF9wXrTC3
 wcM0CjlT
 gQXDP2as7uW4UDG3oFAngzmJvtX0IXfTvjjbIyAl64kIragHigQ8e3BZNRF1vNDW/KAUT8DlbR5J1MbgcnsdPASCSqZsJAQeRWCuf2Y3MIaCRmUzGuuIEkonoK6CYF6Xv6Qxxu+fRdEiZARUKZ7Bydi1uKhIZQ2vTrQNpphCCiwxqIEnXkkLJywck6xpE2btrjBgYCv2DCHxSDw2z89EOUdCUfD2+dakEzLIE4ls66VnQEoQjfRqK5/HE/tIOXgpT4KEUeb2R3mFEISlK9pkZR3sLmzRwkpl1+9oui6IAVj1eBiRhk3ewadx4hxN0gsvS/q+hD2WBZR6Ho8mK+vY5mohLd9cJUv6f3Rw5w0mk5y72CCTuAEL56K/7xWUDLHqkRnJzo73I0ungA6a7pTs0bhzdrofd6NiLTQF6v3Kx5ZeTxiqO8V4dZJLxKxfJFQlWjpMIYRlWSP+UcEPt3OrW6YCuFZuO7i/7l7f2yTIpZacCV3B9qA7xqAAYR0Yym/Y1qsobqTgOa7D0wp8KgxKXxFDXkYVKLmiedo3hJVqsRQ5Hu2Cd6dl3UY9NQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 9:58 PM, Lorenzo Stoakes (ARM) wrote:
> From: Eliav Farber <farbere@amazon.com>
> 
> walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
> so without holding the PMD lock, so the assertion is only valid if nothing
> can concurrently install a huge PMD entry in the range.
> 
> This is not the case for a VMA whose driver implements both ->fault and
> ->huge_fault and which invokes vmf_insert_pfn() from the former.
> 
> The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
> takes the mmap write lock and faults taken under the VMA lock are
> unaffected by this.
> 
> This can result in two concurrent threads faulting the same thing
> disagreeing as to whether to attempt a huge fault and thus ->fault and
> ->huge_fault running at the same time and triggering this assertion.
> 
> So just remove the assert.
> 
> Target the commit which introduced the first driver able to do this for the
> fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
> them using its own mapping entry lock.
> 
> Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> [ ljs: rewrote commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

