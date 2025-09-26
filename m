Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FC1CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07A08E000E; Fri, 26 Sep 2025 11:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8228E0001; Fri, 26 Sep 2025 11:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6978E000E; Fri, 26 Sep 2025 11:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4FDF8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:19:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D20FC06FF
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:19:47 +0000 (UTC)
X-FDA: 83931761214.18.9BE8731
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4CEAFC000E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:19:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GEX7sGSe;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758899985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWlR0y/Sux61rdpKVNHDRpox6sYOOn7qAYyRTBv/JhA=;
	b=EG+1FdK1aQCuq6FHn2aijg2J1aKbUi1HbW7ic8GzZVTyouNkwfB36USF7AvsI2PZ658b1b
	pDCpfumjaXk3NqB/pOaDh3rVdwbwYxroO3NbKGP23WeZcFfX9qIPcJvFT9HGaavNoPfBq2
	uScuLQkQWcBjPnnTk5xQDAk4zfdXNOE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GEX7sGSe;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758899985; a=rsa-sha256;
	cv=none;
	b=0CMih12NRxh12RbhkJOPeXoNkpFnQbQ49pYxj0lrP40vIHYH6vb3bej3R4Fd9CZj8qPRnq
	qjWQS0gAe2zvO3FJfexnSbvFAnmHNMVmvgSsvuJRUD5agq03f6Nqf67J1Mdd4BPiCoq+ee
	+GHBvNB1PI+cR4P/zbIQPMW5DQzegCY=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so1069408f8f.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758899984; x=1759504784; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QWlR0y/Sux61rdpKVNHDRpox6sYOOn7qAYyRTBv/JhA=;
        b=GEX7sGSe44TW9Ng7maRAjsOtgf5pGcZPaAFfzVqq+5D/Ox027dFAWk4xFubZYcN/it
         xk1qeLPOzFijtM/8ZWNpQitaJqEJfwF4nQCE+4zbVoqavYavLpx88bnOhU92sM3m/P2H
         NMDOUZxoCoco2QRaQB3py4WkdQu+eVQa9hSKi5tmuk7VYEeNe8taBLHUtQXze41t1JpD
         ZNhUh3GfUaj/1lgHtL0tEYIYjjdoeL5VGmpVGZ0D3okZcQSCsnZXc8LHbJuYWATu/llt
         GCmBdoGaS7vB7TcGyFa/yDxPlmPTCwzqtAjV2MR3tWI3MftY7opWzSqnkUzLyRKdaRhc
         SEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758899984; x=1759504784;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWlR0y/Sux61rdpKVNHDRpox6sYOOn7qAYyRTBv/JhA=;
        b=wZqWefATTZI7rHR+RF0F5GILZAKSERlkNI0sBgNTHzV8YvD+4GpwB8/Yga0Y4DEFFN
         tn71mjQNSvE/ncYFlKiqji5PiS/mEhUaUXvlT8IfHWH9hv9estXedKVDRm6tNyzb8Wnf
         k+wLY/Iy+RhDgNkjW3TuOJSUXxCwNHvGzGMGV5QgPOcNLrvm7wZcXl5JYys7XzsCvB1c
         lNzE7zlxnWPX5PdN8itQlwumYHgEp+G5AeLYxryKDmSVKeoqGoAJgkXak1PwdTjTI82/
         c02k482rSokVPjZrjZxi5LgK3TidMljEmlZtV1FHrK6Mys1MVymtxr6mjbZ6+H4+uu0a
         S0tA==
X-Forwarded-Encrypted: i=1; AJvYcCV/JBrFfElMy0gtlWoqVk9JMtV7Vkmna1bxSG2P1cHY9eZstIJCvQSOJ/zuvmYI/kPUEHPUlLN3lQ==@kvack.org
X-Gm-Message-State: AOJu0YzRekgFDNatnxOQ6sHuc5U2LBYOoULbHqw7tdeiQxM8RsCzPCZK
	TR/cMbVhxJZGaOtuMHxFqHO/s8bE+C/7O/GiLJnefJAKIJ62K/XGQuJ9
X-Gm-Gg: ASbGnctDV5vbq7Nz2mvk3l16L0bM+4v0W8cC8udPV61MCuSud3YRN8UVFuMRvanoZOb
	SDllSkeqdTmzFGoLyW7Q9qGFJISGGj4K8i2FkX+XcicbyHEzJnT855Rn2EM4r27c+yQf/rgFR7/
	mak8kM0ZlAFFA8BzGKQx6kOuay/Q0zvhDCAyTMBLCdyI+HuA1Dk/0AjJeGPc5wYvd+MMvNNdvgH
	VdmFJe0I+cUz/1h9u0A9M3rgPQwjXgq+mwkyeU/FIvuccxzPBBobI+Tcg3rirp+frzn0CTU7QAD
	WmdPnjyv+0MIJhT6L1ApzDiAZBg9exRs8Nk/ZUmzABi5cndETVfDPTa6BW6H7qY/Izd7Z0o25Ea
	6bb/y088RwB/Z/a+Oktpfb1KFlxibcdrYsINEmHXnk7af65nZ6tYRrrOPaRCHs3CBUCAVuwvFlU
	ojc2v2bd25ln6UGE7hIKq0J696Zlkg6MEfAZ/XV4g=
X-Google-Smtp-Source: AGHT+IEa1G8Cv8YRgqFXmAP3TAlQSquRLXr05PhtZGwjiNd0B//b+MGhp44cDbdJLfkDnbto9V3Cwg==
X-Received: by 2002:a05:6000:1889:b0:3f8:8aa7:465d with SMTP id ffacd0b85a97d-40e4adce7e4mr6096265f8f.30.1758899983520;
        Fri, 26 Sep 2025 08:19:43 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab6a514sm120108055e9.22.2025.09.26.08.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 08:19:42 -0700 (PDT)
Message-ID: <37ec3e8b-e46d-40d4-826d-b4b2378015cb@gmail.com>
Date: Fri, 26 Sep 2025 16:19:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 mm-new 05/12] mm: thp: decouple THP allocation between
 swap and page fault paths
Content-Language: en-GB
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com,
 shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250926093343.1000-1-laoar.shao@gmail.com>
 <20250926093343.1000-6-laoar.shao@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250926093343.1000-6-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 46mewbnomjwxbboqa48gnbqcwi6cu8s7
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CEAFC000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1758899985-360447
X-HE-Meta: U2FsdGVkX19p+CtHJr0QnEpg/N71HkFnj9fQ4aVGIEMYiP1DnfxKdTpG2qZkZJVZ1lohJzH7519IwOg7PrX0YPuV4GKrsWGneqJ0D23npFsLAPUEGfcf329n9nsLUmIUQqMOvXYAtaWUzGGXKZ0rs4MCDsQKyQZVhZnOeIrINvZQrVd8TR4HbDfh2Wpho5rNm6PHf+ZIS22+hejp0bkQN+J1two1IuFzNVal/ydwxug9OUSDv5X3znyKuHMtdAGTcKXf/lbGfWyeorAcgGPhUBJdfdaY83yIfFEEC7dFIqVFE7nlkE//rgVS1bjDasTSIxCPsLveFL/nwK5mnLCRdiV/x6/5A546w2CRZMRjOjhWoSIWK1u3rLGtES7LoNnJyA0XQLuWkd62RQ0u4+p6sExGA49Y5ygF7uSD5JEsyi3LZozIYimJ7Tgwe9hQXJJcJvn1mRpy1CQYpa3XTNH4IYHG3+VCRLCTxk1n/dNRaT1Lfdb0l0MK1Z88+fWF1wqCNBJHv8FrxgC1UkuN6NWldpm3yPixVTNskGH6MjwEosbrT7tHZQs6BAh4Nk6+teIHdSM9r9oPxuUB0/U3GLNS7C7C0H4CjEDj5RDGa9QauAui8BeHGQl6t7gPIzHrO5KqqfGVzMd/zbUx/S2ER8TelkS8MyPajIyZ/O1cllvxLsRoCPJUMfeMlOj/WSMqd7eUCadlGso6IAO1Qtv/EjQ7qAcH9np8eMWpoCdPtWm61eahH+hkGlYH0OzldHMlyKve0N6MUcpW7kYhFoTPoQFqZbgl1yD8PA3g/GIOnzxt4a+Q2Och5fB3hVmwZO0Blv0csMrW1N1uPzB6fPzHb5Gclq95Mod6MmysNC7Nl5qpuEBexdlSwlkxiAci6nJqI/3r5qDU2WgDu9Du442RoYyeGcXRlKhFLJQJ5pJFZN+b6shDVDxo4LSkmHRwGbu+H0JntsSHQr23aAQ2eHDLINQ
 ixcu/kwz
 AAeIwe3zr37+21gtP64yTO4khsabkTTXGdKh3jLbQeji9cxjP0PJp+NucsvpiEgwpyDnPmIaNz7PfazD8FD8iUAJaO1I9qgmV3UtmbCfLVzdDGSsGvV2nj6inQt2v5Et2uutYmNVrPjVQyCA4QR1kgLT7G2jg9DZ8Nm5d80r3FYIDiVgeLafeaeaLcV6WxhddDW66Du9IGx79ZPkHDzp9PdovBLBe3DxGwoN5p96DB2JyXeeiWOrXG91WGQpmgALFlZObzG45hzK4Vw3nGgV9KZHhhmWvzJIx2JU3msGggRllhc4UoIr26X4tSTYC4/LOXicQuPbaLNu26uV/36+52N3kohFIyWGtv+7eKy0bwPZiGLOhH+szbE25rDpMMlu0/UnM35ajvDN5cSUk3m6rhfhGW+asEZgiIS4VVTLCk4IOKbOJj8YNKKcPzzQYbG3026zyan0JVi9BIOsmWukPlkwodkOl9mgxFMV9D5kz5GbNSB55TS0aGKmSsULaGrA4uELtaEXQMqWo/6VsWE6oDySg9obN3SgC0TnHuWPVc6jtTLio4hy/lWW0k3N2iaPv52Wag/wRx9nZ4Y5Co5lxjuVzN27IQ1gvRwwZyX/IdsaTZVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/09/2025 10:33, Yafang Shao wrote:
> The new BPF capability enables finer-grained THP policy decisions by
> introducing separate handling for swap faults versus normal page faults.
> 
> As highlighted by Barry:
> 
>   We’ve observed that swapping in large folios can lead to more
>   swap thrashing for some workloads- e.g. kernel build. Consequently,
>   some workloads might prefer swapping in smaller folios than those
>   allocated by alloc_anon_folio().
> 
> While prtcl() could potentially be extended to leverage this new policy,
> doing so would require modifications to the uAPI.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Barry Song <21cnbao@gmail.com>
> ---
>  include/linux/huge_mm.h | 3 ++-
>  mm/huge_memory.c        | 2 +-
>  mm/memory.c             | 2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 

Acked-by: Usama Arif <usamaarif642@gmail.com>

