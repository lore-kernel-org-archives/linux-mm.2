Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2643CCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613CB8E00D4; Tue, 26 Aug 2025 09:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBCF8E00A8; Tue, 26 Aug 2025 09:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9FE8E00D4; Tue, 26 Aug 2025 09:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7538E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:05:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC20A11904A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:05:37 +0000 (UTC)
X-FDA: 83818930314.11.1B7E773
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id F29F140016
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:05:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gkNCk8L3;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756213535; a=rsa-sha256;
	cv=none;
	b=e1jmwQzhxzSImRmBzM1R+YcCqUH6QHOhtrv+qeByvTa1lekG45jKvivHoqiJRnqmYtwNhR
	TiMinOmK22xvbHDQuTNleq4U3h564uiGJKEDPa+S4LVlf2VKKTXDOIuLEFs8FGHFb1xeEr
	GKjAvjshPDxEExDoD1YebRpnwTJf6zA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gkNCk8L3;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756213535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BB02iWNVIJ9mg9RLb+t+28O/xwbqNfMBkX4EOOZu44=;
	b=NLasTKMIMv3uTJQmV2Su391VafR8+YEaAY60ZSYWihkfali8WxOSq0yAnKioKm/uuvawh/
	xKjeX20ANLsXuVs4KQcFJRPJVzDw/xA+tyGJTv8WQxQCXsqZLZDTU8KxWBSwjVW6wijQ8a
	+hF4P5/CFN1ZUFodQtWhp7baiZtZJKI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756213534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1BB02iWNVIJ9mg9RLb+t+28O/xwbqNfMBkX4EOOZu44=;
	b=gkNCk8L3/8fsanUdnqZNfJBNNS3rDuiK7CCEZIK20PO5gTTXkAvwWKf6a4Ar07qtcd/gkF
	I/oJymxWjN2G5GN5GgNNoe0HJ6k5lG3ZSzDDxd/h1NnHFva7qr5VP30lqFIEx/7SBqaL3e
	h4anDE8bKgClgvqip/m2X9/8oPWARCE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-Zw7PR-JFN3SPndVI96uNmw-1; Tue, 26 Aug 2025 09:05:33 -0400
X-MC-Unique: Zw7PR-JFN3SPndVI96uNmw-1
X-Mimecast-MFC-AGG-ID: Zw7PR-JFN3SPndVI96uNmw_1756213532
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso39497795e9.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756213532; x=1756818332;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1BB02iWNVIJ9mg9RLb+t+28O/xwbqNfMBkX4EOOZu44=;
        b=SitU9T8/WpcsE2Hvg+kNsq+rA1lxxQV4QiyGtBmyN86kr7CxjIOGMth5XINCkx68Bo
         YC8qGiQ+Syf4VhmLaznkGWR7vwBUxhsFqouLRLi1HQMdaIWcaDgd+w5epC0PgiIZTNbt
         eMoSkxjVoGuQdpBP2QEJp3m1IFRl+UtioxdmacI/p+mtDGwBgwwbyOO/Umbe/sQ2MrPc
         TkKJWmLIWRItWQaL5rGv4ggB4puSrGbrvaIHeTU5EGL0+pEnRIEbWdRFcQmtHLYQWJjC
         cbGLIfRvcOm/BuHIusdMlPEqNRPB9C6OCoTN28lHXfY3JFvmVh6c1N0RvkO9U0Jc2wKZ
         Iexg==
X-Forwarded-Encrypted: i=1; AJvYcCUYw3U4nOnrdRNRZ+kJ91YcIt/y30T5wjpX+SelEGMeK0ez8WAvWQbdHHGXm8S9ziPjNHh5/HJcZw==@kvack.org
X-Gm-Message-State: AOJu0Yx4Mt7ISW4oD8QZ0UmaFSca6yMrAiiNQRRaeznCzM/bhnzKr8fI
	gMQVcDh9sAEdHaf+eNWC8MOfbpmm6sk2WWoDCaVYCi6pQxbG2T+bFmF0ZC1zFhej0vFM139O34Y
	btNu399S1DUD0x30SYwgvNd+x9MbHr0LoOkDk2mcczjR7TCQPuzPd
X-Gm-Gg: ASbGncteddjrGhFqK/H0/NhmZIv/mK9koMxVMt0ruUDNrCMquFsIGDm9dVAlwkv6517
	pcfK1uIJPESbC56T6P4b/ukdXPOzox/6Gn3ohnyDmCxTIb+F6VvwBhGLU7BTnbzx1neESHIYkvq
	OUNey5tozRuLWT9pblKT/1PdVoyC9urY2/iMNlAt35h0ZBvEZCfsAwo0ugHQP4f4WIetlt2KDSb
	SlUvf4Sj70Solg2jMxams9jOYaRFk5+qPXuSHsW/bQRDZe8T33a4lEu+Gq7Te85V/8yhay/84uj
	SBldSzZLVbLzf3FRLeOdc7jxfrBiNfvy3Js9NiB0Fz/lxajjInytjo2r57sXE8OlUWKnM0DbZw=
	=
X-Received: by 2002:a5d:5d0a:0:b0:3c7:6348:4086 with SMTP id ffacd0b85a97d-3c763484467mr7275241f8f.1.1756213531675;
        Tue, 26 Aug 2025 06:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IED6aZTaK2lqB/sF3ARmnAdAwZO8b9lpHwjPZdqb85yBXUF5jouz9AriJp/YIpO7DcxRXsArw==
X-Received: by 2002:a5d:5d0a:0:b0:3c7:6348:4086 with SMTP id ffacd0b85a97d-3c763484467mr7275175f8f.1.1756213531071;
        Tue, 26 Aug 2025 06:05:31 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c7117d5b10sm16090666f8f.47.2025.08.26.06.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:05:30 -0700 (PDT)
Message-ID: <f77fd9af-5824-4f5d-ba97-54d70bbd1935@redhat.com>
Date: Tue, 26 Aug 2025 15:05:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] mm: correct sign-extension issue in MMF_* flag
 masks
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <f92194bee8c92a04fd4c9b2c14c7e65229639300.1755012943.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f92194bee8c92a04fd4c9b2c14c7e65229639300.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IWdlpC6E4MFJPk_sOu0_k6SYBmOjjuICXFuVVs3xuy8_1756213532
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F29F140016
X-Stat-Signature: 5s958r4jgrciagtunq76sx5g5mjst35f
X-Rspam-User: 
X-HE-Tag: 1756213534-264837
X-HE-Meta: U2FsdGVkX1+YzJ+t1fmzhhhIdsqTLxSJz/N5n2g96hA9oVkW8T/L2Ax8scSkRykcH0tLkIpiD6h0c0lJzLhFwuaZZs0xUW65WSPecS4TKi4nKzRdxvZ+r6xDLy/vuGiK7QV7oLPeXN3sk8jaxQ4AyvQWvhLQcROFZHnrUyQeQwyWtoeoZ0GRGLPLOn2pQs8zpwo+kvB4v29zSermca33bOTeM2hhrlE5I6X+dDRDm5qFoxT1nVq3VWMWEtiZjvvWTiEL7LY4wLAECKcR8Wuas67PH802GbyCzzvHFtXRFDFDWUONh24HEcQ8sCGhB/PKzSkMehF02BJpX2ORK+Z3gTd+UWU5w1uIR4euZ8LI58Q7KCemkFDUAV9jCwDoJ/D4QO3UF9SADdTcvYLYAFpEeebd5LDN/Rrqiis/IRGRNw4e1yD9AD7j+ZpL2RgJe+24WJSp8LyKTuALLGBDAC+W/BAUJis80i6o2neogB5Pb1mwxRu7gGc1ip607fbEHgWXCQci3VqiHxM/IArekA2elb9uX4Wr+XvXGWFAMpl3HFwcuD0sf/DszKDSgYSiMR/FYsMOV1p2Q3c+MXRWRL90FWKgpJsWfYrupiE7/n3A4pOqpobI7SiikixZ39u43gYQ0tQZ2RjDjfPhMa8UGBJub7yIhm/05BFDn67pZB6z+5SFfCaOq8hgf9b3a/tHVRdB/1R2+ZjHBU2QoN76+LcwnyYExjmfYmAz+wpobCGvowIAqJXUOHY66gIrY6LBDKODi31aMb2e9gSkpRZtN61axWsRFvnsp7pO3z7Hglt8PfWF4GNzO6BnScqbEfQ+KvW6YOvTE5y3aFq8qDjO3WloUv8itnmNGXUsvDiYgoLfg3RJ0bf9wLB04OuLmXoYvXW82Ch+6mtKEmi9jiEncIM6uqHxyXvMrgqsc/vcs32tuf+R2maDBLvdMrpOSGIS38S9UXeIUYAwqr+M6WEcgLQ
 UreAGSa6
 CaPZ+wwQR+EfHWyFHVNbzPV/WkkK299MQLur+/Avz1S9Wd2KXq24fHbGUrVJeKHIxlln7m9XsTru+bv9DmYs4dQimzG4zxW/EKMXNXP63LASDt7/hL4AiWlwyHm4MdvOW/TotL2K05Z8/DGo+gC26tE+KGK78s6g7bZ7BMqnaSVtdKCgfzYnFvLFy0WYeiXlD2HcsX7js8SXVcsJD6nLFr1i9L+EQwsPTM3b/4f5Hq7D0Np7MgKL32CvG8j2EF3tunRt3nREnXGyzhOtnBFw+V+3ltRoXMV/AGojx1oF43yraXhrKDqd+iqoGmy0lL+6Aszlt1dQofju4k1fUV7oKD7zAxD5nxcpgFO+/+Uv2/7DcjZdXgfhlriv6Nq05YvvzlSpUp/EdZo0WpOyY1diRsLVpGfiiVNVeEVt+QPOTaoBEpPOww7USmXmOMDszSACzUyxacWLa80udpw4n3eS8bgwFo9WdJtvWW4aR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 17:44, Lorenzo Stoakes wrote:
> There is an issue with the mask declarations in linux/mm_types.h, which
> naively do (1 << bit) operations. Unfortunately this results in the 1 being
> defaulted as a signed (32-bit) integer.
> 
> When the compiler expands the MMF_INIT_MASK bitmask it comes up with:
> 
> (((1 << 2) - 1) | (((1 << 9) - 1) << 2) | (1 << 24) | (1 << 28) | (1 << 30)
> | (1 << 31))
> 
> Which overflows the signed integer to -788,527,105. Implicitly casting this
> to an unsigned integer results in sign-expansion, and thus this value
> becomes 0xffffffffd10007ff, rather than the intended 0xd10007ff.
> 
> While we're limited to a maximum of 32 bits in mm->flags, this isn't an
> issue as the remaining bits being masked will always be zero.
> 
> However, now we are moving towards having more bits in this flag, this
> becomes an issue.
> 
> Simply resolve this by using the _BITUL() helper to cast the shifted value
> to an unsigned long.

Hmm, I thought BIT() should be used and would just fine?

include/linux/bits.h includes <vdso/bits.h> where we have

#define BIT(nr)			(UL(1) << (nr))

In contrast, _BITUL is a uapi thingy from include/uapi/linux/const.h ...
as it seems.

$ git grep "_BITUL" -- include/linux/
include/linux/mm_types.h:#define MMF_DUMPABLE_MASK (_BITUL(MMF_DUMPABLE_BITS) - 1)
include/linux/mm_types.h:       ((_BITUL(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
include/linux/mm_types.h:       (_BITUL(MMF_DUMP_ANON_PRIVATE) | _BITUL(MMF_DUMP_ANON_SHARED) | \
include/linux/mm_types.h:        _BITUL(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
include/linux/mm_types.h:# define MMF_DUMP_MASK_DEFAULT_ELF     _BITUL(MMF_DUMP_ELF_HEADERS)
include/linux/mm_types.h:#define MMF_DISABLE_THP_MASK   (_BITUL(MMF_DISABLE_THP_COMPLETELY) | \
include/linux/mm_types.h:                                _BITUL(MMF_DISABLE_THP_EXCEPT_ADVISED))
include/linux/mm_types.h:#define MMF_HAS_MDWE_MASK      _BITUL(MMF_HAS_MDWE)
include/linux/mm_types.h:#define MMF_VM_MERGE_ANY_MASK  _BITUL(MMF_VM_MERGE_ANY)
include/linux/mm_types.h:#define MMF_TOPDOWN_MASK       _BITUL(MMF_TOPDOWN)

Oh, hey, it's only your changes :P

We should better just be using BIT().

-- 
Cheers

David / dhildenb


