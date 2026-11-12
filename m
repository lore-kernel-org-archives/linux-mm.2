Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE229606A882
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pbt9KG9r
Received: by kanga.kvack.org (Postfix)
	id C265E6B05B4; Thu, 12 Nov 2026 05:07:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFEF6B05BF; Thu, 12 Nov 2026 05:07:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78746B05C0; Thu, 12 Nov 2026 05:07:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3D96B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:07:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2FD3120548
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:07:39 +0000 (UTC)
X-FDA: 85426040238.30.68724C5
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id D0E8B180009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:07:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pbt9KG9r;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794478057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSyMz69A6pUqMMIP1tdJeB+vvEVUhzDjG6WadbBU72w=;
	b=Fna8IqjNRk+FFEGWWO4SulxR+WZrSnVQdtsHhEXy820Ka8r7mVW/LHCsjvzWv99AZMopb3
	sce5cTHKOAlm5YiBlcSXwsyN/ORGOIYW8k2s3L1t4m6NP0K0+i9NabiyyXVQMXH9fmwxQj
	D5lvggy+R9XRFHpopVBRU8HMnKqgadw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794478057;
	b=UrjEblQ+5c3tb9ImGXphArEZ9ZiXxB+NlMm71l7LA5C9DxqHOKFeWCl03ki5IPOgGP5Mff
	/A4hJ/6uNxlun+/D2R4HdRrqfmNK3e8bP5xWQ+aOy5lW9+Z4dNKiZBSBcpofNEo86yxyKe
	MISlJ0a4me1+wRuHsqib2+SjFYwCYk4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pbt9KG9r;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso4007608a12.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794478056; x=1795082856; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WSyMz69A6pUqMMIP1tdJeB+vvEVUhzDjG6WadbBU72w=;
        b=pbt9KG9rJugluXdsIfGY3oZRQQDpLthwWffv1kGMb5OQWlqy2fMKqdXVYgCTj82zgQ
         5YbOqCWfcgwj5er45xfS0BE/mazO66KkrECsjEjBfNvNA9Cyn1+ZgOeGSmWZxM3xROQR
         ltJCk5t62vSjTTfrmQhouKEd8L+SMCMi7sN7fIEwUP5Aan9CRUcI40xm0jagVrmoYt5i
         0oXi8JHugUnx4RuKpLy5oMFAC2v5PKp+6hAytXNANgeHVZ5929T6Z2ojBBMAPD9rgXx7
         ivTZQSs8nCj5Lh/l2ftbUS45NQdU8JCVoPUjbhMvH3AY1luJt/++TPw69hLf6VoINr18
         48/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794478056; x=1795082856;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WSyMz69A6pUqMMIP1tdJeB+vvEVUhzDjG6WadbBU72w=;
        b=c88bUY/Ni42O/Gvc6/gPVpOPZX/Rb9j22+tfv7K8HNFSfSybmcUoOTJjVuNqe/Z+Ql
         sGO0Te7PI+YT6gXJPHDnJVHiTak1CFozGCc2Fu3OzkP33q+JO7TKvUbZjCPkXan6THNp
         g4txndHpE1U5nRuupI8ZJ0bYaT7xj5nKKsDgPD/s1twhbotk4CZxqYLx8v3b89wj7Dg9
         qMf85JoFTW3Dax4HwtICSoRBG1/QghskJOf5Wj+M0n2o8UFTH1r57gk5bgSWGtjrU6RC
         Pke4Bmk/3fs3HgzWStfW6XwNw6vdaCuFWbQRaqm5fdVWBNBEsZbQsJS+lbymNa/DImrd
         s80A==
X-Forwarded-Encrypted: i=1; AL+hErG2RCRg5e2G1qCJR2jc1My2i1aqYEWE3AVz2syhSNCWUE61eSMal9Y3t5sot/b4JUXGof8iNlOnow==@kvack.org
X-Gm-Message-State: APuU4Z/ozWASc2nEUS4RjhqZ7uzJBMwuEeLF0Cp/gdjvUdySn8PdoJYN
	tE/0GLCoIN9ryw37HdFQ9Bz+OPyiFoCsG1c+aiy20Kw1/EfEDrmkuT4i
X-Gm-Gg: AYBFou35AMkz0GJ8i3hpG0jeTqkcI4Vf+GY+bkM++23WO21g97xUNaUKACV2ixa/Mll
	F/GsVnzY/bfUQTKop/k3quXq3DFWUpPbizKfjH5Ui2eYF2r7bVqkEtskyLytQ6kOJk706jCzn/7
	1r70O0dOoeFAp4j3T0H94oRGPzcKHGLTlEAmLaBAY89cA4f6kRwgurhVRdQbvwcRKCzwdoiqQg0
	/uQyIcIrI8zezIrHOZzzZE9BYFZjyR2rpT5OgSMpEpFUyc/6kGCVYH5ad2Cg3Po7VjGZkF4EoeY
	ssAdmbvUhqjFEDASgPtMBBcEawl5SwExRcYwdrK9VB+VVq0wIkIL+u4AxOasfH0jExy/zLTEvjR
	JeiCzYC6EpfZ3q08uW8HAJO7X/cWdX8D6P4/7FU7ZqIlw82RNTbPi7HDT0QU61YjZnGyZuUr9hV
	PyE+4Si/NGw1ydRu2QaQAACCPC/PrQFkOx6QEKmbwzggKaX5TEwKtVy+8Lpervi/U/pknJWuQ81
	Sp7bUosTmb7hN8Ei1G0hFF7JCL9A2+IR4eK5pzsSjTPLY8pFmg/w50azqM6O22Zu83UqzoczeEI
	nKB3Vb46P/7kTs3Vhh1SBrRf
X-Received: by 2002:aa7:c1c4:0:b0:6b5:8579:5404 with SMTP id 4fb4d7f45d1cf-6b7773edf1emr2460162a12.9.1794478056131;
        Thu, 12 Nov 2026 02:07:36 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498363df7a5sm16175142f8f.37.2026.11.12.02.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 02:07:35 -0800 (PST)
Message-ID: <5411dadf-0df5-445f-a3a5-8d67489c7eb1@gmail.com>
Date: Thu, 12 Nov 2026 11:07:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: don't report OOM when a huge PMD race blocks a
 pfn insert
To: Eliav Farber <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, William Kucharski <william.kucharski@linux.dev>,
 Vishal Moola <vishal.moola@gmail.com>, Alex Williamson <alex@shazbot.org>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261112051440.16140-1-farbere@amazon.com>
 <20261112051440.16140-3-farbere@amazon.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261112051440.16140-3-farbere@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: g4crrr4wztt3bnapeqbi4z7oo9kzzeir
X-Rspamd-Queue-Id: D0E8B180009
X-Rspam-User: 
X-HE-Tag: 1794478057-281030
X-HE-Meta: U2FsdGVkX198t3YcwpNshJdudu4Epes59vb51ArMZXh0Sc7YVOnPfbfu2jIoRr70xjCu4ExYEexMzgJh3cts7Ng9DdkXw+j288VnokgUHaxY+vuYEDxRk8aYE1/R333QxyQbYgJk7X8qQzuWZBVaK/02C97zExnNh4Il10W0rnLYrNeu0YYTcIXnnYrkdMuvwXNJlm1a7K9YLmabAOqdEPpDqfFJtHS6jD6v4NfnoHU+L3fSTFG1HkB2jWP+dVjBLyCpG3oesLiB4cy+/Dlj2oqiV1onFQuDdTZww3zFVsEKJEp3xahXIiq3x+YCQp+SWqmK2UVLLVBPe83luRAAcJhZzwtAuP+V+joz5XgIRAtydXrh3UDctfCpdipk+zhVOPKQ+Xeg8uXTSTyS2ErWgYknuP9ZepJtSLhcWTeZKZ923ZaAvqpBKf/AT4znBRxYUNFS8DsxAyT2Fu+qroTh9yadNcJrlWyQNZq8YC4Q9MeRR6aFYgkOuu/SYTjmYnktIuoYLB5/TLo9aJ+KXIomw3eMij+gulX70x+fmhFM2QTJJcF0ExP/YW0yM+hqN1odYsNd64WAWN3JhabZbvhp2RLZfs7kLsbxSWJMn8t4j+f6TGfHGlxsZ1KlO48CSMhk9SPaWj5sgDeuYDZM7TOGrtUgk8gdveuoxsc0SesugBJJei2LbwlGLDzMuAzebw6cwrUpbd+jIutSAi0KusOP9Bnhaly+XXsM9vk7fVIvRVWqkSA1ocC6wENN6x/opea3jOoBWZRK0fsCggADGE5tjB4cRik86yipMJurfCdIkv65g9698ZTv16AVUkgdrNsdIoYWEdMtHQFqYUm06HscIVOezuwmr9ZfhpT9leZa1YlbY3ki/g4hbVMGjbiWduMvu874Alcw+YIcXB9+oEMXttz7muyHWZJRJZdBvI/8anE/UczEXrTe5MvqsYIkV82yiXQwBFTfu/ORaKsnLuX
 uJ6PK5ec
 hFJxDFoHc0UU2eMCtV6V3TqEFt7gaDkTEe5lHwyD9CseSQxDLT2YF7/0oMVoxvFPRYJ2vxHyrl3VApKhgYdGaknyTS3MT+zCnmjhxLbM+taBaYwnJOSJiwMumBAsjgAnDzRTpMJsCh+3ejzTEMVvu/FLz5z09ss2ybuwIN4+eilrSjbyVmlurEASMu+XtOuHSFj32tgYEEALSSINfW/R60FDiZ6AUAMlvj68Bk19ewpb1U1FMJXlVENXkBLoVZsWdy+/mSmUpjcn3zklN7uI2/7v1QF126bxTDbZUsRYgsX0u6xIesLHXXVGnDFSsoUVgkjWvmNrnF9JVDjN132Impo4Vp3iA7CY90Elqnvke5l7/HPn51JTSagUg+PAajhTDAI/Y4LCCxj/cREyLOn31TcxuBOm9K6zLLbmrGBdT+3+tTBQduREBOeedVw5nDKCvdPpJrR076G+6hQlgQZ1+FxgrvgQUOFkSOtx6kdWd/hkyvMBhE5N0QYnLB4phGm/l62r6N4IYdfvlVkcHHyrkLWjAihKxWxGOTEDZK5kbcnU0Svn6kcjyJAsmPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 6:14 AM, Eliav Farber wrote:
> insert_pfn() maps the PTE with get_locked_pte() and treats a NULL return
> as an allocation failure. pte_offset_map_lock() also returns NULL when
> the PMD is a leaf, which a VM_PFNMAP mapping with both ->fault and
> ->huge_fault can hit: an order-0 fault that passed handle_pte_fault()'s
> pmd_none() check can reach insert_pfn() after a concurrent huge fault
> installed a PMD leaf over the same address. The task then takes a
> VM_FAULT_OOM for a mapping that is perfectly healthy. Changing an mm's
> THP policy while another thread faults the same PMD, for example with
> prctl(PR_SET_THP_DISABLE), is enough to produce the mixed orders.
> 
> get_locked_pte() cannot tell the two apart, because pte_alloc_map_lock()
> folds the allocation and the map into one call. Walk to the PMD,
> allocate, and map as three steps, so that only a failed allocation
> returns VM_FAULT_OOM. A NULL from the map returns VM_FAULT_NOPAGE and
> the access refaults, which is what a PMD leaf, a PMD that is not present
> and a bad PMD that __pte_offset_map() cleared all want.
> 
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

