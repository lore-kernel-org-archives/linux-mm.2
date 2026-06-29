Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2387FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E836B011C; Mon, 29 Jun 2026 12:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0461B6B011D; Mon, 29 Jun 2026 12:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA03D6B011E; Mon, 29 Jun 2026 12:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6B6A6B011C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:01:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 293951A01BF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:01:11 +0000 (UTC)
X-FDA: 84933414342.20.EF28D4F
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 56EF3100016
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:01:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="p/SuYdqt";
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782748869;
	b=oEhG85P6ksiIRfQbsj0tOi4arbGPAUPN/+pOOXqsmbmwu8zLMpK9lxvJNCYTnJJcTyf5zz
	M8O2DCfLB1tmLUnwVvSP6knXh/T8OO+5jew7HEyHm60XNyW3HxgU8+rIzNFN2awM3PNqdA
	Ex+NYr1XlR65DiBGsE6i+Jvqp+rCfQs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782748869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iCXvcvVpnsYDr5kbvWXbUhbyvnE3mHOMHboZJmxShw=;
	b=VnzS0PVFeMTOl4XePe/tjbQ+TRq/4LRBqCkCQuLNhYS7qeSm3rLsXpFl09LGjQW+WNoYLi
	oikZThsYXbNoWfsVRNNYBV57ULfyXwIiBw8tDkFym+74tdNLqNHwFWHBbVlMY1Ot5retVq
	JZfO8evc+pKxrsNls9obKkhPRLs1GHs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="p/SuYdqt";
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-664d7863920so1141079d50.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782748868; x=1783353668; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4iCXvcvVpnsYDr5kbvWXbUhbyvnE3mHOMHboZJmxShw=;
        b=p/SuYdqtIsGVwx1rBLyNNBneCT8zA1a2txJFgdVr13U5iPuLJY0n4efjxHuZb0N9sM
         mnaQJv1z5HaaNTd9EBt6tRkyDS6CvSEJ8bPtQDMcYiAzDud/+Xr8r0cZ4bzg4jmOZgGq
         KJr56ATgWrq7OYtljQIbJd+iSUlah5Wvqi8ZucjP2djjajN6JePeGZ9hgKb4ZLunEiyI
         kFXjMKO/HAasH2nT4M9ocHZQlk7hdwTHsmnt33isPTLY5KOGkK2LCjCurzeRC1UjsmYd
         w6NIfXA+wFIRw+tuizSgQ81CNi0qbEe6lThOKQ9+pKZWAaOV8nbzCECwTDJQMVMI2CCk
         bcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782748868; x=1783353668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4iCXvcvVpnsYDr5kbvWXbUhbyvnE3mHOMHboZJmxShw=;
        b=A54nJZf44+pvG7oYEgOjWNVAUzT3Y2r4JIPRgM/vsU7eDohZukayRF/JjT/4wXPopC
         5h2pmPrvKZb+1DcSGiHf0JBbim1W9taJ6OEKUELuuHI5x2VaK8bGA1UOAN/fMrQA1PaX
         5aFqbVZjAr5pOP8GHIT4+deS7BWHH1Mdn5wyE0xQT/cAFeXAPZDRqs3wsolbd8YRg1rH
         3eiZ5ZlJrM97iY6y7z3U7qP4hlxyTrC3ksFDVOCKA1mIcCr3OS3TRUcc3wWZZCi7OSbh
         v05HOd+4Cajz4U5qYsqVfEcOEIsmK2flZc2gZ4abVnaA9/dD2IdJuceVrTK2phA2lKEj
         01ZQ==
X-Forwarded-Encrypted: i=1; AHgh+RrajLnyf3D/C+atk3/XAaHM5mz1V42MtbhCmJDvxAMg4m90DMUITcukZLM0MtieshulvHloGahpww==@kvack.org
X-Gm-Message-State: AOJu0YzYAkNyVMr8wOp3nwGvgLFEB7XN5IaJ3ufxfKyVwGdLjHjfWiTP
	H1zQ942jIdNRcvcYeBZfwglYk2HKmCtjWZ8UQg2lOT2AQYr4wbbNW5K6kgOkfB9LF4g=
X-Gm-Gg: AfdE7cl6/KK7mEc0lNyYBC38xMnh7Dl2lR+Vn7kew9PkHn7YgNwdHAggYqGwMTFeEbM
	faK4GXAXS7nkxqcSRBtxdPVVpbkVy78OQ5lXiC0PzV4YviFfSDmAvkhntiRQOgX4XpaSs867+F2
	Z5O8/UBM4KYW3qvYO8wUcJUx4UVT9dNEZEbjAcH1fg17qN+JfWyxnP514cZ3ofEmneM7hhHOYI8
	e/topAMZKB+dPci5xj3WiG9tcndcRejswMbcY/e5w/eDtFl9MXc38cn1larNFiOr3tbAnXEVlaG
	zP5eQkiORvja2Z+oGEFNiWrReplIRitCsdurfa9EGwQ6yH7rzJZdglHmRcyoSxPt0F3hkHqENIR
	Ibpcmb4uMHXspgpo3UtWch6V1HBRHsKIf7ZArRFKU1rnBG8ClqM81jWvfYnYK6LhEn5nZ7rLN6+
	KxFAjotAE2QcGzOsGTr82qxxoMcce7VPafs3lPgaAUW9srjOyTl6TahNWelxgZ0NbzWDvNVsMus
	tO8cWY=
X-Received: by 2002:a05:690e:d8c:b0:664:e66e:f965 with SMTP id 956f58d0204a3-664f974638cmr245066d50.7.1782748868214;
        Mon, 29 Jun 2026 09:01:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a717edc7sm1112836d6.36.2026.06.29.09.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:01:07 -0700 (PDT)
Date: Mon, 29 Jun 2026 12:01:02 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Message-ID: <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
X-Stat-Signature: 8frjbcmj31gui331ynp37gpneht98yxx
X-Rspam-User: 
X-Rspamd-Queue-Id: 56EF3100016
X-Rspamd-Server: rspam02
X-HE-Tag: 1782748869-723583
X-HE-Meta: U2FsdGVkX1/YUDUoLgfMxdECDTV96rHtMusfqZ7HYvpaU/x5owAoPj+Oz8R0ffQEhrMY92Y2vzvB+Xz3bUX0c/QbQdehsKwSoZcxlLMHZghQmSyPJGfv7h+AhQ2NI4/BHfDxO//goiPXh0k0/7LZEAjwO3Y7DL7btibAAFg/DwH/7CMHlaqv6SlJqanfUnN7t6mBYzTnmzw/K47p90BcYUfNAEqXql1SbopcFBX4XyyA5Y2U6vRp5tk1XI10CpcFWyQ0UpFecjdjyhjUn3bPX4agHceVAMkuOPK5npACP+kwTx9u99olbRqh0ZwObteHrbrmVyMCjnIvP018M+It3D857e+bMJd3w74b76z96zYvXN8Go5xaIs+8IG99uzLKrpCpft7WxB/VWBs/yRxUteh0jNe30L3ykljUZ3tHMAii5R+nUjFoj8ziVCxnDU21xZG7F0vNgtz75pdf64E9EJQglcr1TOKcq1JbF8qxJsFm4wCm/aeAOjSuDkz67hkvt1as/T59jjM/U0rjoadd6y+DPlp3DiLXumMoDVVyqfTJdY3FBS1BYLqWntL+okyoRyqjYUKmpJNfohL5fNPaKOIGfbCe8WdVZmJY7eXkf5sYhVp0LARrbS/cDXI4YZv3WqZkw//gYpfY3lyxU0pLhJe9g9gnub3Bw/UEd9sL48dK3cC4/AYuW7DXS9eAit1GS/r4zRbIE+vcYSVytZkKDpWKTtFrq8hRqbTAeLdY4UinYgWbosaslxrmzxBeXjZlnnfRFq1fap/tO+0oz84URXlxV+ATchzl8W5tsvYN17nBsvB9aJSdbmL7sADM1gNtnQfLLPHNviF6TQflwWtCYJrp0TWusaSfaN/zqcvZu1GHxYgzPkb1FKbuxAA5eILpJc/uAZW8Mh6c5TXs+9lDio9mQbXFTBoflF+D+AISyLd5KZ1La2Jg8m7IUWTOLJlK0nTZ+WrLEk66PH6Fer7
 6GLyFksH
 dTa0C/z9L3rrv41mekG8iGPhHFPDyDfdZJ5FJGhheMwWKKuO8ORa5Fh8TdC+61kNtomM5JOY7sXgylQcQSHx6xZOUdkm7fyJA2bgdHHuZiGp4BMPastwR+9iDOSlXNcB2ds3A2SSLKlRQyv7nmUmdldxUyIbpAW2YXb4EAwlE8GNrmgMjL3m24McN4J+E/joCOgwyR6h5loNzIQGm5e5ngljnJnrAIM8sIijV+ggFL6RL+1kU0hWbRO556dN0ZIzXQyETmy6N79psxtqcrh1gxf82WCsE6BTR2bTjvKO8K4RZioWotFCBJk/pZONc+Mqjgpp9poZXDQEmyn6Pw1kV/sz0Xs++7fX9l01Bjn2ozm1KXByq19D5CEb2KQwSgmYoMWioMttsJgXb7G9hPLUSd/RSqChRpghUQD3AxalzFCx70dXl/arDTK8KOp5f+rvMchGn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> Update the file comment to clarify that both file-backed and anonymous
> interval trees are provided, referencing the relevant data types for
> clarity.
>

Isn't this self-evident by nature of the function definitions?
(one takes a vm_area_struct, the other takes an anon_vma_chain)

> -	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
> +	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
>  

For my own edification - I know not to add new BUG(), should I be
converting BUG->WARN/something when i find them in areas i happen to be
working in?

~Gregory

