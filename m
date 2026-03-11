Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775AC1062871
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A732D6B008A; Wed, 11 Mar 2026 08:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B7C6B008C; Wed, 11 Mar 2026 08:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F89E6B0092; Wed, 11 Mar 2026 08:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6256B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:04:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E393F140188
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:04:24 +0000 (UTC)
X-FDA: 84533649648.29.922164F
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id E5FD28001E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:04:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OaqPDODo;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773230663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5EMe7bYHKODG/rm1X+QIPDr4bQTLFjKqTjmSxuIYLA=;
	b=uNrfKzUQTn5TQxEDc/u2pTxrXjjcXPdYUDpoQs+lTqbpX7cCZTOOQABSqO4S+0tSQY6gYB
	YlUuSq5BHnNT7rHb3wuWm2OS20VJjpvIgD9T/IFjHgzMuVYP94L0e/n3Cm18rI8erAC1/y
	lgHmjBKsxQA36OGSvrV6GcHjUxxbMms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773230663; a=rsa-sha256;
	cv=none;
	b=IJ8WZMkCHo2U+KHFulv6/e7JccGzoaLFmodEIQBMBM43lhuTRuHTvZzgQ314x65/u3WV/7
	1fP0vnI9PQJYPEnxhDKQXi+4l663jV72cKJwWlzS0B3wju/eaO096Dhio0NeXm54kjdE0S
	oGsO2yTvhg6vvfSUu8fsxY8I4LFOQfU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OaqPDODo;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-89a14be4733so113458786d6.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773230662; x=1773835462; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s5EMe7bYHKODG/rm1X+QIPDr4bQTLFjKqTjmSxuIYLA=;
        b=OaqPDODohe4OfY8jlVgIEair6jTm75Ia7iWf5fk7IzswT5+w0DRx3VqPAekcPai4Fy
         7PxR8xpb+sdCP6a3N7Gz98rTdxydVgcRiCf1jboLO+LTSu882K38WNTZsHvPOOxB2pJP
         kXKUfYH923jVCUpnqPfGTxcd23mz0jT78O0Xfhj8F61O1UtOJB5B9UnW3VeOlORSXUhl
         sgbfI8CUhzwTjKT3v4//8Q/Jm/9MODRGCsnBpgppJV0g1GO0vD2/OKw3FrkfmcCCRidc
         SLK/t6nrU6wBz27/Xm1a2ikQFmK9btITXdj+XcUIF13jvgjgjPPE0/LrCHYKzKqimiUa
         E2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773230662; x=1773835462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s5EMe7bYHKODG/rm1X+QIPDr4bQTLFjKqTjmSxuIYLA=;
        b=NVBdFWZSZmTt3duXkjSPkSBQ1++DM2BcqbhjK5i0vScdTiMrIAqEUacOvA9VqvkUlS
         7YnlsdGZF62xLa+mH/VgUJkAu7TK1yRJL5K6uTxGTNhnGPe6/kt2ju8Hg7mEvQRo+bER
         GuM+gEXNNWaYsQS9nacn6HA3PCsQ2XxVCM8eQwts8ysZTidQp4izAz7lGWJ3OsUaKS5T
         afr70eLZQ9KzCEzaDKZxw1N9kB1+MfJo+3IEUQlL39VeoyxJpJuvFpoTuPQITEu52/AE
         DIhpRhAGSn+wBwtMyJ3LN/KocrVLGEuip/yStM/JMyqW3ty6nQdzRMLBsBawIemUwiEX
         EXWw==
X-Forwarded-Encrypted: i=1; AJvYcCVT+FNP2lrIB1kCDsw9mYAiuWtxCU0ZdgGwBe78dDmLiJId5Ku6NtFYPMsIvytkmxfXzsAG3XqcVg==@kvack.org
X-Gm-Message-State: AOJu0YyQP4CzHBr0Xte86lOvsCQLsKonX8pDUGXVFhvDS8Hp7SDTWz5l
	IKvDEeYL+l6SHr8YI7EQpj1e3j6v2nAapDKG7TTQ3mwRB8aPlPCfzkZFih5hwS6epDo=
X-Gm-Gg: ATEYQzwbIGTqypQJ0clEXlALneSeAcYd7lZv5QaKJUTZ9XJDY67DNue4MFBAoktZYQc
	iIwK+1PwKcs6mRK8uPz3PBX+jAlzKlIkxX1yoT5GMHn8yHwkP4TNfvBSK6siL8Q0Uitrq88sou9
	/zeolX5fSXvV9Aocxym/qEp0lqV1W8jWbmt8BdXTyuJkaRifuYp5AOm64uaoaUEO0xnQaRCBYaR
	SFItN0w8ZcnX7+hwJRV8RKpjqEDtBPTP+zd6JADGYNuS09stvxz3QgTFGSo+RuR7yeg2QGYpPMM
	vdPVbRlk/+N4whvUejV3xJW0WYA5KtVwziZFn0N+KUmSs8tdEQ7Sh99wzP7A72cqdjwABS8OV49
	ohMKsApjV5z/x9Z/vTyAHfimrnKo2W53Y2vdbVNfhK02samKYkfaaXcPHcrQn0bGKmpqmX/LN1V
	njyE62GcdznDh9HskIEy54LFqxvYZI51I4fM6OXe8BCyHU0dOh61w1AFnIQNRKbMh44/cJ8KnKt
	sxQDA7TDhzMFmVYwcw=
X-Received: by 2002:a05:6214:f2d:b0:899:fd8c:55c6 with SMTP id 6a1803df08f44-89a66a5858dmr29432376d6.23.1773230660563;
        Wed, 11 Mar 2026 05:04:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65d17023sm12745086d6.49.2026.03.11.05.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 05:04:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0IIU-000000069iv-3jx0;
	Wed, 11 Mar 2026 09:04:18 -0300
Date: Wed, 11 Mar 2026 09:04:18 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	"linux-mm @ kvack . org" <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in
 zap_special_vma_range()
Message-ID: <20260311120418.GU1687929@ziepe.ca>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-17-david@kernel.org>
 <20260309142954.GM1687929@ziepe.ca>
 <61df6369-333c-430a-bd18-c5b1acae68ea@kernel.org>
 <abE4JYo223OxWCBQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abE4JYo223OxWCBQ@google.com>
X-Rspam-User: 
X-Stat-Signature: zyatwirgournpks7fy688mqaq6go36nq
X-Rspamd-Queue-Id: E5FD28001E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773230662-556483
X-HE-Meta: U2FsdGVkX19VgwZSsRl8waCoazoZs9QCQxVrkDyjAcy3Uq0nTEMl/fQOg22UoCK8I6y2P7sOErYC68rHwtuebGLCyQAjhlhCh/MB3lGaxknk3I2SVCS5+3sS1VVBy+pVAGuio5gcxNJDxYa37QAtGLe27F4kmhpNg26a2/zYVrtKB8X41mczs1y9YUbFp+gZzyiyu1DqrulQ7ZMIto9cBmFuMkLNYbn+G2H4lZlOrwu2hrMtdBip+Rly2Dte1biuc3q4/o7Nud39Qg0qbMcHhV+WihA7avLpk8+t60M9HNf2FHW3QHHOI7fnzyPuby+REfynXnyruXBGNfoyBZPU2kr6q+NBg3k/onIAYnUzC7QVrnF/5JaKjGE5vDmIN3XM2tsc1Nawp+Gq7HeG3jzjFwWhKgGIEaGN8EP0jffNrtqtZzSsOcyfbd6Qmqsw83RggzF2TlKYgkChtyGe5qLGPdb+qT3Ws+4f4oJm97cDCTPER6M43gkimghZkjOITCnkrgsRjUOEDJnJbeJ3FJd2gI938Oqr1xIDzZY7WUfhU1Jh9ZxgF/+h1YOh03K3EHWYoIZW3EZD1GOVo7ZFKmEH0LqwbQR91z0GreoC8LeclnOa1eEdFIKxaUMoxZuzRzoh30jLXPSim9N4Nn3inrKWwmkZY2M11L1pGSBZl7/u1M9AZ1zHDutps9V8s+vQ62K5lcvxq7NEHWG7swqKlkBPMqX8v/TjW8B81idx4VRSnuuymv2pJG+R75wjFR7vM+Q3DHfDPxukbm28gizAbcV/bxJTVjPFF6mQ8/IJnPBzM/ocS3twuqrLad7AsSxE63/PinqjPN826fB7UDAEykgPoSm/o1LlPiNQs7HAL0+HrPwwd5q4Qv8QNgYoqL9sQTNn9Sixws+Xf2oxVdZVvVLqsROD6SVaYIBL3ILFwmVFrEToSfGzyN4GgcKBJliInfeIzEN5qN5fuqKuxbuamIY
 1r1kFRnw
 lS7lEgFqFjDX5fBr9ecMJBu8YbvMOpCrbva3lJI1i/oWdAqZMbttyEKlV9q0tlQJgSlzsBx/nMiZ2IdhSZ/OAbPk19ZVyf7z/Bq5pKOICpR6yvS/EI0eUWS8WfOzYJpKQqvm8vg4aQWZu7rTIn/IuWpcaAawCUUXzZf5SHwdjHn/NA+FqCoRcbR2NTvbAFOiy/H+WJIUcH3EIAksS1ftn726cwjkSDP83kfE8nKsauPzPzR83k/n55tgYUFJ8ANr76s2QkES4M+A9xZuoeHk1H7W9w1QCohw+akfQnkXZBVe37u03XtNQ9BrmhMUmHn5V3Pe83MLFaOy28DA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:38:45AM +0000, Alice Ryhl wrote:
> It doesn't really make sense to have multiple binder VMAs. What happens
> with Rust Binder is that process A is receiving transactions and has the
> VMA mapped once.

IIRC the problem is the kernel doesn't guarentee singleton VMAs,
userspace can always clone them with fork or something. Did binder
solve this somehow?

Since you can't assume there is only one VMA the locking becomes a
mess to cover all the cases where userspace can trigger a VMA clone.

address space deals with this internally.

Thus, zap_special_vma_range() is extremely hard to use.

Jason

