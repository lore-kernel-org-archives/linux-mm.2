Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F21FCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8659B6B0213; Tue, 26 Aug 2025 08:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BD76B0248; Tue, 26 Aug 2025 08:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6A56B0249; Tue, 26 Aug 2025 08:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 564F96B0213
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:51:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2D0C84A32
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:51:28 +0000 (UTC)
X-FDA: 83818894656.18.5ABE24D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A6441C0011
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:51:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Uhj6WG3R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212686; a=rsa-sha256;
	cv=none;
	b=zT0rYOG066+YU3f4RIxEj7D7DOqiNtQ9nIuNiI/UBOEBGPCk+9k6wflsabIuBVoP6SB48i
	nvU73ICPmcxWDz3EH9MVC4nvAGxdQWRfEQJSwWQT3Aco4ffJK0caY/PXid9lZlgdhPlNB+
	RJrD/SsLAEan/ctrsCVR0jOPCeVebXI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Uhj6WG3R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
	b=U1BEw3mD130NU5a3mfmrsVfiMLTB1ZXh+Aajsx/uPdm4IR8crEtThb/4NW25tQ5SEZrx+3
	t8fq2l9NdmKJW7qAkzrw17YDnW+/4hF0T2tzHziDHonRkbMJGQk7jPbIKJLapD1rAPWJMP
	v8vbtOmgUMjnmotAQBP0PtepyO9z4oA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756212685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
	b=Uhj6WG3RBH1IYYPoDbGQziLIibXsHO8ao+ETUJKFe/hyB+8RxJKdKOatD6sD6J9yGZr/p2
	Ce9Q7zKDpozJdXcynhGC3EcDPccserqPQNDhetYF9vkijneYOgEWzW5jNE6vNnItbWDbKd
	LIGcc/s0R3Xi1f+WVr53PrYccZzJjFw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-aKqJmZNDM76yXKQrSOKDzQ-1; Tue, 26 Aug 2025 08:51:19 -0400
X-MC-Unique: aKqJmZNDM76yXKQrSOKDzQ-1
X-Mimecast-MFC-AGG-ID: aKqJmZNDM76yXKQrSOKDzQ_1756212678
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c7990941d3so1639332f8f.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212678; x=1756817478;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
        b=q+4FPiP4o4w9Z1fRBovR2+WrYBjYpEPZJg9jzkMvZZ4mJHfLfjuvSDIcE0VxCTakb7
         zq/VmzPmxQbsfUW1Nxz9bfz+RJRkSWaTLaUrTzno9mHshkCDQ9x5910B5n9RuGpF3+dF
         6zcyYqjd1Y54R53cvh+bfhPwrRvjRxzG07dPs1UoJ+BUINTfV4UJNe3Yo2LsP+Atku21
         42aJGWqx2sgsd+L9Fgz4V+Izv/BCRgFk5DlyznB12oeURILKrKqdBRI1BocWfwoDgUr2
         Ni19pICbtOexSbBrTdVXr7rWHUVRCjJLI+snJ7MUOTqUy4L35t8RjWm9CK/y+Rjbd7x1
         Gouw==
X-Forwarded-Encrypted: i=1; AJvYcCWONCW6hEPyTXFazhCguQj6nXEpikyhgrH+3nnu9fdXN8Hp+KlYY1QqH+ncUF9VVAPt0fxgrHJRWQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3qHZ6F04jqYgM/It5WUZJTA1jv84kBjTD69C6Ok2Ga+0n0ULh
	bN+F6uSnjafIQPUDA4GE9fcK9Xq+7a2MPaJWPI4EKkOiHwDfMpLds415wNRvaJJsVMnMoUUL1OF
	fnUL116ZshntcMLnrfKda7tnAN8rDV2tIdOr4O361sVK9XzstnWSD
X-Gm-Gg: ASbGncssCF0w8LOAJQLksUE0+/3YOg9EPqVuXSmq4TSU4CmI//UZWSiUi9mohUoyJ0m
	PDrbtw8J1CBlwP7u9n2wZ3S4RiDUcuuXdi79Vt5Sg24vuhgRrRYi7z7w8KJgL6S+ZsC1KgblGIJ
	UnaP6OHnvLFe2uMjW5eiTI2yZ22jZ5xKMjxxTPQ54Xcygv8Bi8NRkzGxxhNH2NRvhzXTZEN07sb
	J2Y1D5MUaYH9b6YVHQrkt022ldvk+xuQuY6oTDGlR/p1y0Iiq/rRxiL1+RrUJfJdxg392zPim5l
	diwPmNDx4U0MXfEuhhRU/tFliyGr6+NlOmv1zMXPh91Gr4R9u1riNMBFMcnKlwMkvpMTsbJ59Q=
	=
X-Received: by 2002:a05:6000:2507:b0:3b7:9d87:97ad with SMTP id ffacd0b85a97d-3c5dc6385b5mr11406839f8f.37.1756212677759;
        Tue, 26 Aug 2025 05:51:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSK/1xk3/c9Xu1SO8B6/MuQ1GDhVAwZAbjHThT9hVQui09GzjwaNiodslXyfKC9eiARO9pgA==
X-Received: by 2002:a05:6000:2507:b0:3b7:9d87:97ad with SMTP id ffacd0b85a97d-3c5dc6385b5mr11406762f8f.37.1756212677218;
        Tue, 26 Aug 2025 05:51:17 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba046sm17460044f8f.1.2025.08.26.05.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 05:51:16 -0700 (PDT)
Message-ID: <c98843e1-f138-453c-a764-17fe47426ea7@redhat.com>
Date: Tue, 26 Aug 2025 14:51:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] mm: convert arch-specific code to mm_flags_*()
 accessors
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
 <6e0a4563fcade8678d0fc99859b3998d4354e82f.1755012943.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <6e0a4563fcade8678d0fc99859b3998d4354e82f.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SLatswrsyzHobPjXejHI2lpZ0Dk4lJ32fpf5JakISII_1756212678
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A6441C0011
X-Stat-Signature: jwz7p5j7jesepzswjwomydnjpyhuktt8
X-HE-Tag: 1756212686-874677
X-HE-Meta: U2FsdGVkX18uYEpvFIWw/5Rqn3wk57xJ1iu8OfnCWuQ3C1WbdMzMTU5IXVIzWi0JVCv6KOXaHNPk8tafeIUhH+QjmyzbZEXj8EntE8vDbpPfKD+lsudIJ475a+SZcfHjgn32uAvOkKlz8Phjl365vrURLi7YudvZbxykC3QOwOKJ9AEp6ngQZUjQEksH5Qb0W566lIdG69KK2FcW6CeKFJCsAsSWKBZvnLjExAtTOj0HB+O96zTCg80FWq0lffHlrqqzYwXwO03P1MI61f69CqxN8Sq8CmyvednOvaXmw1ti/20MqVrtWHw2jsYWuNba4o6mKPjf51NdGLQoXIsifxa4Z0JVGzDDbMgPed1GAsWJ3yALpA9P390lhlDxOJ4LLiiksJeHEX7JHB7uCDQcj74ateNEbd7UNdrt38CO59FflZQOevaDgu89/fNdPsL5g8UAu9dki8gcXmC0VZoR+JJ0p32EcQxURIvVgA4VIUWZPPMu3NhzqN6pliUA5Gnks1bHh5m9Tt3GEG8MScgnyYKujeu+2n7Ev7mzSqT5vBFr3nriEUEueKnl918u84/ooIpyywDkrc1bK26AQhSkCFhueMsXtLmOO5Yw9+0opli8Zqg3N2QLeN1J/R+iHylRHh85H19+f1C/oRkqGl2CMUE+O3yF961/dUUAcghfp57yuKEyvE5gJZpzuFdlcG8ScG49qVciXm8NkygqUv1VmQmpLwUaEUS+AL8ci6Qb7fm9fWQmLBw+xW0e3aGGTwgm0QDD8sNNtzR0fStx8jCaG/ygbUE5k9RlLKqJAardLor2jvMuqyMECLnMetQuwzQAQY6QLKC6943xQnAUseamaZhjv58m0OPxOrjReTxxjqDK3aK/Njkz7Q483xe/gXB52uFP6jN2EK739IvDdRDRiFqy6tDJl5x07anRgzMe5GZol5RIZOkNexP1K7LK7AIUHvTHMmcbF2UlskYUfvJ
 HVCKweku
 bjUMHbAkBrSTQGWmDbA21DCgUN6BOHT1dOTKeYMxjjAvA01Yn/ydVTmJhT+7XT60NPf2FJbOtaVOm86+r3zp+5pZKq9oQR21AEzX7Oxlr/3CeGeUAKlAuAVLeacHv4ESFuGqUcS9HsCCB1dv67yF+ME9rLLQlgRBB/4e1dso9v7ZMdKQ8Thm0+ZPsxlaiEjlFEn0BqBT5cM7WWVegTs0n/MWdmA95/47f4Jb/H1NhU/9wr9R17hwa2qpZehFKwvSckDIxKheewDBfY/u0wc5yNq0ZndL1VEnlnGdZoDV2qewO62/eoidHUyvtw/WaAwNOeMGABp2+yU2vjzlDmf/e5UoHFqeJ3CIwnaFdG+7d3Dzgk3i4Fz/fprfbwHk+JQhBabKoAHBQeu1fITalk+3H+yioh02W5LQS5OO7NmeTsG6RVdris9Ybt6oo+WjXWkL/sHvTx9iMNTTxNS9KVgCbQOARY2WynLnhRlPqnpWDLUowlC0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 17:44, Lorenzo Stoakes wrote:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


