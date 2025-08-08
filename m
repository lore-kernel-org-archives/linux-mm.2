Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC719C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 03:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF556B00A6; Thu,  7 Aug 2025 23:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E796B00AC; Thu,  7 Aug 2025 23:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3665E6B00AA; Thu,  7 Aug 2025 23:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 258006B009A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:40:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E247161322
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:40:29 +0000 (UTC)
X-FDA: 83752187778.25.A10F346
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E283180006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:40:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TvxHOmF2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754624427;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VwJdv2/aTZlGvHmbtM9UzrCVsyM+3NNVAJCeNgjzdo=;
	b=owGcHcFXxH7Ctk7qWAaHPnyT3oiXTDWIYBd3Q8H1QAO1zMx2YwYl/S4/Xm1k9oraAk+l5N
	yCn1fky6C9W+rYawagIynoafdNChWKckLnw574aNDZw7yeeFK7cSYR7DpeDE8m9KyH1LIV
	n+6rBOugsvStH75rPxaL7/mwG+QDgAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754624427; a=rsa-sha256;
	cv=none;
	b=rGo5C6w2r3XfSa+i591INGpFWzaIzxibNdkGKhiYN6MY6X54V8fR9HDKW93/GRo4/sKWck
	KKJLn0zrs4yqdFDZK17FN9z8sQqyWIfpposfide7UvrbqTTmuKEzxR1talARc7N3wgaaE2
	gwU45yzkInVjMyGS4zcSdoLadwtxBTE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TvxHOmF2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-af925cbd73aso329636066b.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 20:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754624426; x=1755229226; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VwJdv2/aTZlGvHmbtM9UzrCVsyM+3NNVAJCeNgjzdo=;
        b=TvxHOmF2NpEjgNT+PlwiNO8rCP8xSJaQphgLF8zKWK8eHGGJU7e5kDjXuDtd95xju1
         AFM1ieWbk0F10nl4dSnuBaPJxebnWrO9I7mNQGlklsvvmRG3WmYCnDmxeUWc7/z005C5
         QYRdqN+mQExkbDPr41UFoH28OY8QVxHQQI4U7hhWPDUEJN0haCP9qNDtSXsCNtajodFv
         0/MT7hqsdJL9NLtL1tKsEwRJf2v3oWfNUUi4LE9VrqgzUuQGN8ZTFnx4XsjXFlEUkOkP
         yMRKQjsnOu7gjxxtaNvKxwIOP2nu5qXKQPWgHPJKBvMhcJzvZDhvM9vvShGbdH4UhF2f
         SJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754624426; x=1755229226;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3VwJdv2/aTZlGvHmbtM9UzrCVsyM+3NNVAJCeNgjzdo=;
        b=l+8GdSYC4Fkx5O9J7/LO24c36/k/chAC2AVqYMDEw+V30SfXKB3hn0YrY8Iw6IACv/
         DLMvnUPUo/7mOuZsP4+3EuvV/ecLaotDPWTikrrzZ+bfdasO0OggdaFiRKR7m6sszv5u
         GKoqZgh9P7LhOgcg9P+zJKIQdJQLR/qhDC3B1sp/1p6JVqvXW/qUOpt4C1jjKHzfHIj5
         HC9cX8F3Xw313PW6UeILi2ebvZ2dY2jua+1DlRZNEkLQwRxBWWJZ2uhF5fGlLvOnjx8n
         NEWvSKIHy7qnBLhTj8rBmRdBdqj2RZDIh9IMv1a6wJr+zvDgMHWrspZcuYIvmDIknvtl
         f8zA==
X-Forwarded-Encrypted: i=1; AJvYcCUSxoTVsr3k3XL1kd2CZMremSEVlJm827XOWa2GluHjnlPMQMDN2VJUMu8Jk60/Q4s2VPrZOsLi5g==@kvack.org
X-Gm-Message-State: AOJu0Yz39op++FF1W0VblBz6Z5EMxRKbM0slncKDeJcWWsacQgltGzOw
	IBR7tJaQrtIiCjcnLlGdT2581gllHXgmanCZt7Up71vbjPbAJtutQ1L1
X-Gm-Gg: ASbGncv9D1M4Bh4u4DJCRrX77XZGDb93M/GC9/2RWVuAajVYX0eV6sr6bwNPqX6YD6E
	nTqVZdm6ZfIiKLtPHr4meD5boG36882K59LZGTs+0qVvD8qi41l5cQqM7yjLEC4790zsIvxvE70
	4iTbjOofYBu865Zv5+vNTDuowx3a9Soi/PXtCDQOaE4T2yfER0mi053zG28KIBg2y1ScsLjfSRu
	Ny9BTacSbLeyPVhOV9fVdgiHfaRYaPOJ1sQcEFqcIvfnQsTb0yKKHBV3JRZWrd5oDpqKhbNaOsV
	J2xAni5KD/cIm/RfyZgByL9rbBStqX6ADBpnr6Mxuvk41qM2bElxa1Lck7yapLxMt5sYie8viHd
	1O7kwMfBXwTBOBZ29bXbR+A==
X-Google-Smtp-Source: AGHT+IHtPlYQF9NDTtoDpiah0Zgc7+o2I8oA3L3L8/8DtlWIli216aBTAesdtybo8gOA0RWRG7TehQ==
X-Received: by 2002:a17:907:1c22:b0:af9:71c2:9f7 with SMTP id a640c23a62f3a-af9c63b0ca7mr102202366b.2.1754624426029;
        Thu, 07 Aug 2025 20:40:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a07659dsm1405214566b.21.2025.08.07.20.40.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Aug 2025 20:40:25 -0700 (PDT)
Date: Fri, 8 Aug 2025 03:40:25 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>, richard.weiyang@gmail.com,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v4] mm: fix accounting of memmap pages
Message-ID: <20250808034025.bh5giuozvz7ri34m@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250807183545.1424509-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807183545.1424509-1-sumanthk@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 9E283180006
X-Stat-Signature: ci7rmwztdthbyzkyqq4ffygtm5gisst1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754624427-905583
X-HE-Meta: U2FsdGVkX18N+XJwkjX0soROY8In32S9KmwRjfXcwP+OWMqQt7eADSXuw6iSEnkOB1TBUP1MqmRoXTiqr/iU0+RjzmTh8o4D6PlIIVeBOhlY4NMcNh/ozGqfhGQdMTwePp4IeUVeSRcp0TUzNppw/ZUGihFdsK9EaCneFUfXbfrS+uxw5lKNTdxX/s2ywJPeR5ZK/A32SDmKLAANVtVK3ZVHnveg/uGYkqAzkXAnif0I/23EHZxSv005TE78pM6QcDJsGuGetlGQlhWIzT0/usNJcTzpCoqD2jkgunmaFkaUbfD6Trq5CNobMCRaYwFriE54Dvfydc1W8HyBxM2AmmXU386TS34a9JKdb6weaCYtm8qj+3wgDLMgE7tg/pXrBqWaQrtGDxKLDgPWXOqIWQ/pHOyCflD94Akz4QWVhWfnfiriPlTk6Q+zawjTN7J/zsr0DTS7H/8wycdXzVoohnCid/+o0ZoUdlht2m86NNyDbE1oZp1CkPUmc9+u660ETP/5w2qL+2kbLpEO1uTw+MtQ4tj4KwjhIIELbYKFxnqeMpDmled5jwMlzZifceFo0gU+7HdIKtfO7PT+yfBOSzWY8DhGRJgUp03PQMoi/UWe1AFyrZHW+4KOiXw6VZBE4Pv5yW/PVjMnb4+XntenyP3rkCVc7FXO4/8ZWNAJEsRg2Idp2TxW/0xjzVSNwfKWEr2boTUUfYsr5h0OGZ+6iJMhiROTt2AEB4FDqJV+Tk3soo04YmUv7WT1nh0Nhxg1zF01b5s54wwXhdA5GRUxflSTxd2ZccxZEaM9Ooh/M/NDPHJT9CbZY3k+DF0aeCZEFUOvSrNKll/EnFIF9GJUTYhI9HaWP/rh6y0D+mSvjPcWVTBS8biB3VAYi0jioQwrmxer+jLTx7NB1QSdlvzpOxsxs1EMu9R+8F+NVyuf3TgwlicH/Nvl0DaJP+lFFgbK1udWSFyGoQYPTaO0gqU
 F2Kxaueo
 FWY8CQxliHVQKt+OebL8vpT/JMMyEGKlX7PWw95q66Z7NtConIdmB7O57LAniiBADpDzIGYhbH9Q00UpwzcyF02HCKR77XPVdX0NhpYw8nxtJ9hlZ9GQmykNlQarnFoErtxws9ssaj0WL2bBu+fIi7Pvq3CfHmtvgRJ4lAr9ecSLxKz569a3H4fUHZ0Y8aXuz3Wbp5lZQt9GAVL+h60budzSem5QgKuUDqfNIWryUHTEZB2YPbcxUrB2enh3qqT5B+UZWAdQ7/3kiGmXd1R5VBcljKbrjZj3eLFIRnqmye1RQolYaTgqcijZe1BRPs1jYBemCp1/zhJW9UJeFlyWfRISHVh9gCS9Qrsjt1SStnkzdXnxJydq8uqTyT56tXhYrJNC83iMKLCiDh80jh8sok9zVGyyKf2Tarx62FzU0y4V5IePr23x43gTCY9Q6TVoeLTCVfkgcQGgVBjSoGEh4tonL+TEyaTzIKEXiefQZOoSMsywUiyh56re6820wpkJQV6CmNC13mlwXAzFvjGyq1/cVpqmK1HYz9gNKN+xM6JfNakVhIvUUnF9xS+HKxM7r15KcEDZa+1Zz70qifCcoS9x5XxF+i8TaZZYyleGJuprDzHHiRwDbaIOUVrUqJhgx/vfz7YAxKKRPq/XI3m6H2kQ/VoLq8kGQcTPUhElz1A1JsSwHFcTIav58VLuljiMd+QePp5PEgAYRu/mfVJbZKumeuWZ7ZSrY6JJg5fmvsBUGeTSPF4vaiG2DcmA+IDQPgPkK4+nhoaRezqsaXuACiwivx6MQAXiOEhzBxuYClGWof4y4fmsUmtxrqn9E2EH45LwT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 08:35:45PM +0200, Sumanth Korikkar wrote:
>For !CONFIG_SPARSEMEM_VMEMMAP, memmap page accounting is currently done
>upfront in sparse_buffer_init(). However, sparse_buffer_alloc() may
>return NULL in failure scenario.
>
>Also, memmap pages may be allocated either from the memblock allocator
>during early boot or from the buddy allocator. When removed via
>arch_remove_memory(), accounting of memmap pages must reflect the
>original allocation source.
>
>To ensure correctness:
>* Account memmap pages after successful allocation in sparse_init_nid()
>  and section_activate().
>* Account memmap pages in section_deactivate() based on allocation
>  source.
>
>Cc: stable@vger.kernel.org
>Fixes: 15995a352474 ("mm: report per-page metadata information")
>Suggested-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>

LGTM

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

