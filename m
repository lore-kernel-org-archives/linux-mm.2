Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3298CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4BA8E00D5; Tue, 26 Aug 2025 09:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3644F8E00A8; Tue, 26 Aug 2025 09:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205478E00D5; Tue, 26 Aug 2025 09:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8968E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:13:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94D6A119032
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:13:26 +0000 (UTC)
X-FDA: 83818950012.04.4953B72
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1BEF2140005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:13:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KL1w+yp/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756214004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
	b=XCYvnnqeGcjY5/zAifmBZ0hDIePzLQJ5IxcAF7Og/mmwalqXtJHhpS6v07H1UUArjdtxrH
	uIlki7KbN5OZNawo1mnO/K5yFuLO82UCFchqAyvVJn2oNytGb2O9pneUnbfvnIy5usNqTn
	zRXYmkrj4pSItPECyDLrXHN1V5nN6r8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KL1w+yp/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756214004; a=rsa-sha256;
	cv=none;
	b=5AWG5rQlu8xXmQR+9o/wrrpcOaCWDXrxhcPpwdqPjWlyD8T0T/QzN8spHuyjOFxqXKtVVq
	Zd3tZYzrPzLcCDN13eUtbhCM1uP9QMmC1N1h+BPNTPUwDCsTUcgRELQZHIpFZKFbuWUGxd
	C/uAzA1f95h9OMK+3PVugVcTHapxWks=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756214003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
	b=KL1w+yp/nXfT/CAUCPaiGVxaRUwX7zebkDA58NK1DTqcNQkMotwVHy5gvOxz/ZC5/S6zE1
	J0YfOscDhH+aFirH8AN+JTD09WFAaieVt+qTOhZD1n1R0SCpDuhy2wiEzX9PLxE0cZTA6M
	6P0SrmdP9PZBuA6Wf9saGZlfIRw666w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-zkNaLwhuOJS87Qo0njqs7w-1; Tue, 26 Aug 2025 09:13:22 -0400
X-MC-Unique: zkNaLwhuOJS87Qo0njqs7w-1
X-Mimecast-MFC-AGG-ID: zkNaLwhuOJS87Qo0njqs7w_1756214001
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0d221aso28249435e9.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756214001; x=1756818801;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
        b=I0h5smX9fXrM6uncShzNbcgHwwujPcOX89XxCIf6bveUnsSfOHjHsf30ev0hoG8Bpi
         GCYL0/AFEDCTXiRgOOwlK3ioCFDivcdQamHhi2uqsnhnZ04Y6LdBAADwwfa3FCVKUL1y
         6JIDAP6dHlpBHJvybqY2uk6aSrkibPl0HJwpff6hMViCQ1N7eh8I2FKHYniyDdzTlF5F
         eCbZz2Rcw0+U//TfSZIRzdHjd6DFfCDXX8rEbdqeEKprAox691tAy5dbWr5/fGoSqqd4
         JYFXvk5hcFoALalOpHxyywSCfpSSXgfRmPyj2HsCsczMDOjJ4qjSXOeK0k90oLXogWjG
         gZVg==
X-Forwarded-Encrypted: i=1; AJvYcCWiFG0ytm8wfjnXj6FClsm9nkxI4qKiGKLM7FOdOfKHUdyjJRwWlmk6iHk8IC3OCXxaqG/dZAxEeQ==@kvack.org
X-Gm-Message-State: AOJu0YwAwjCJDt4OUkludHvTVy2PHjv1dtgDOXoda1c6Fp5ySdaZht46
	jcioqHmdfGnhtff8HrG6LG7HkTj11y5JiFH6hDUlJL1g/IV/yRRVXlC1EzC1eFZix8lMz6FixlH
	5n63ZllDKQloJN5hAeSyX1/1eqohwW0iqdxdLFtN2v/JEbhaQt0nj
X-Gm-Gg: ASbGncu0gNV2bpP8SgV8n4OdxgtBoLD0Lq97sLStLgzKItKsT6M7IZz+DPm0+J57fWB
	+KYO9gjXqc4sWvEpwLct+YwYiz62hREMNRt8KE6v0hLwXu7OGON3pH8xoiUGDJMWhka6GAkvbGu
	H5qIOfIrmZH1SWmNLEQgR5hrNnzUYogQ16lKhlcHqqk9LSPKMFsBPzTpQyiO+Uv4AAuJXUs54rF
	5yTESdJId7Hen0gM2Gp644f5Ahs9auVdf/z6wFwWLk2jjsNtcFzF+qzdqntq478JihjcbhnNQhW
	xTTc5IuGvjFxBaAT8KJZF2x0nUs4oAm4jj+9GcfxtJaeF/ktSkXpzB1AvtfnvNrTE8o2vNW3lg=
	=
X-Received: by 2002:a05:600c:3551:b0:459:d6a6:77c with SMTP id 5b1f17b1804b1-45b604654ebmr67817295e9.33.1756214000746;
        Tue, 26 Aug 2025 06:13:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFU6LjwpcLiO4vOafOaD+LEz6b5Fo3ncGFRjR+/4dbvpwKsZckynZJGDmTGTRv6UW0AZNnoA==
X-Received: by 2002:a05:600c:3551:b0:459:d6a6:77c with SMTP id 5b1f17b1804b1-45b604654ebmr67816665e9.33.1756214000202;
        Tue, 26 Aug 2025 06:13:20 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57498d8bsm152684985e9.25.2025.08.26.06.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:13:19 -0700 (PDT)
Message-ID: <3a072cda-2eb3-41bc-858d-3fcafd7ce05a@redhat.com>
Date: Tue, 26 Aug 2025 15:13:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] mm: convert remaining users to mm_flags_*()
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
 <cc67a56f9a8746a8ec7d9791853dc892c1c33e0b.1755012943.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <cc67a56f9a8746a8ec7d9791853dc892c1c33e0b.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PFnrSxPo9uPcrA3NbNRjwZMNCy99R2gsbd-N0dqi_hA_1756214001
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1BEF2140005
X-Stat-Signature: 8ycgoaijx4xk3mmsb7wrrycrr9jj9edq
X-Rspam-User: 
X-HE-Tag: 1756214003-374484
X-HE-Meta: U2FsdGVkX19w3rZw5W5EI3ZUkXR7PSN1HcfOGEbbT5SNbAw7W99Uq7LPE+42EXBMVkkYb0S1fCq57HUNoH2PLsZi74Yspo2P6kPMV2w3J0+ZnICVkMr7+dnnzfIwVkFdrn6MsBxqgPimezycVqQdDX+4jaVhpuCYP9KEFk4+YIjmjiJ3KlpJiyDXu8k+t4ilpV8BEujLabe/ezn/1ugTGfQTSkRginsLgQfy9axNcXrYMT9DT8lJhbCzX3vhOyLqbIaAksD7Nhe2B/oHz14cWQbalpCaDqWXH+t8i2WgrmH0lFqyfKXkhCmbfk6JI2cGdUACkxnljBQIr0lQCwgQxUcHmCxpa/wEsGWRtNgky51p2BBGKi05E4uw/3f4KVEVf8de7lYir0Pz+uoD/oA9ITY9mAssHBMDzngs6i8knt76JGCoWg2lQDn21QysdK/Y3JBEBqemJb52FBM6eojr6LIeWGHZ95CuoYBO+XY3fyuugZ7WhjPABXQPIyXxSCWwHbxd1WdDesOLJNDtPwpI2rO0rwnzD0KmuKBJhWXC1AH8M/1/hkvfxnsvqqFvGs5MlxhgPQlIf4dls0oOqSqSf4yPAdBi5Y9RPJ5WtZBi7V4i55sxW+0OWH1I/lVLzsbqmUD5dd4yUainSUcXHWOa5KW5sLaBwIrT5jB7JNi71eER7gRGezUENKtSQU4pAUuVLSK/sxIoVQf+v8zlH1v8ay/YVh6dHAVhkygcuVyNnHWFQP7I5pqVW5NRuZlL+dtF4bwLbT6FfSDBpzLJIEuoYW1WCpyfvAmza9Ck2zIQMDnMNwcwMTAaCLRmW9dDjM8RPVDQ+LazdDSq+Bfn1KgedbuGUx6ugYdgsHYv4xqUeZGoRSoUzSvU5kvO6qESbRijW1aGcgvwDq1jQdzHAIPoHcwyqlkjxlKxOWUmfzh8UNJUcrQlH60ORHRnVdrYyc3d8TQ3v6yDhrqUnDzGtKX
 K6kgv5z2
 WMVnZQ7UHsuJQFjRgk44NOYzS3za3zJKiqltcA+FTO9B1onmu7P/zC1ot75MTsATYV74stIAGIR4ZBHeSlfVjtF+AyAHMYea1IJIFogXvgSm9XnFeHGOP2DMmZSTcK1g2aKgVc+HOso0AP4EZx+i6mUp+0aB0/p8gFeW4l/rJmLtkpiZmFjY4mIePKMZbZngkCzXnhkemuopVUCvQGcXHD97XY2YGiMi/Ww9sv+Cdc8/NzMCStUQgb+XVOFe+BsAIWOsgaqqJvhWNdUf3gai4eAhYbZEC3WSv+ovPSRf/iZ+DQERw7aktwSxdYMRXwS5VHeyeyuT920WG05sUzXwo88C/NLXO2RE5a1Qgn57hrBcPSgWSYmsLessHSza66mUnArrlvvUodCGmNvGCUkwUsAwieRE8gwZ9hquudzzdvA/JNcAQuruKSZpMR4POFbf2d++SlHxUKehqHDWW3Qf9tODlKISnJ1d/ED3kGI8XePZDJUs=
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


