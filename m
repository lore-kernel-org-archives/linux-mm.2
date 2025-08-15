Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC72CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6938E01F4; Fri, 15 Aug 2025 09:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E128E0003; Fri, 15 Aug 2025 09:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DAA8E01F4; Fri, 15 Aug 2025 09:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 266378E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:52:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3E0C140184
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:52:57 +0000 (UTC)
X-FDA: 83779132794.15.1A1C47F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 332A94000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:52:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ay1VIO4M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755265976; a=rsa-sha256;
	cv=none;
	b=wRTAOLgXpsAwGx986bQx84tK5uIPg6x/7/SolW+Bz+IDOXWIdxStBsG+cBFQ/l7+UDRq9A
	0Tb27pbRQrDxGvYyUuz9gC8/lkvDclIAwwH+iCIUUmwbZ8uvR1w1juyokuOsXYFnFlPOz+
	CkrL7y7T0yjsyA08mqxUBJqBV4JrBGQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ay1VIO4M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755265976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=is1sEt2dMpP72dCfAlA4fhrFnAjD3PRv4Tu+E1btYJY=;
	b=1iTbggBioolVsb6eVC/IpGs3VnzwT/t8g3sNcU+5BODnrBsJKHyXkLoe5RqwIVCdAs+wvd
	MGb8gFCVyh0EhlZtMz+drnZk8bq4COBCqws/7q6zuMk6iDTpTGsMTvjukwaz+WV/E+z/Sn
	pIvRjoVIK6MtsDC31Dahqw56QDtwI/U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 0DC9A5C6D45;
	Fri, 15 Aug 2025 13:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F1DC4CEEB;
	Fri, 15 Aug 2025 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755265974;
	bh=YyAwX9d0yrQxt1AtdEKMS1xfPyYGo9E0HQVrmo6HFio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ay1VIO4MZKIssq2DXmkvb9Y5xzxbYbHSJCMx9Q+b7drYxS0RvJmoAhIX4KjmakUQD
	 QzyQueMvVtMnt4CD8QUWt1ncIY7GzX+bMM6KNhI3V+tcPnmJvtFwLtp46R9R3gxiZF
	 3xIe+KY2D47BPbZ50ZN0iAnaesGtehgttZhCq/iPJutrQcQvt9m83DGGPzu/OZTCrR
	 DZlc3Alk6BOGyuxr0/JijZf3WjBiZfjGF0RPKBZUjw+TxNH0tUFogTt9YLewsZJ8ll
	 kEZOkiaQqQTz6JEEKBs+xEe0l4CwHvOCfp+vLj4AXKkBdI/lKEVhCBfwoOR44gZC/E
	 dRwzDtGpoOXqw==
Date: Fri, 15 Aug 2025 15:52:38 +0200
From: Christian Brauner <brauner@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	"David S . Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H . Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 06/10] mm: update coredump logic to correctly use bitmap
 mm flags
Message-ID: <20250815-neuzugang-gegessen-ff4c08a08ec0@brauner>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <2a5075f7e3c5b367d988178c79a3063d12ee53a9.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2a5075f7e3c5b367d988178c79a3063d12ee53a9.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 332A94000B
X-Stat-Signature: tg7bqqbt9hos8pjrcnur8qi7p6473inz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755265976-405256
X-HE-Meta: U2FsdGVkX19OO/QUomW4Np90M2iX/bb/f5ONH+Rsy15w1T7ZIcTdqYV6Ngf81RG9yu6NPv7QJ7+zO3syNXMjkF5W7Y5wrLaVWTZCZP1jk2YlgI4+1FIFo6TbJC4At9HzItrRaFDVwnwA4dMzNeoTDeHnkqE/i/KswOBTkpD7pLTA2WRDlnFsyCuOFH48GFfseNh0ojZJu3VYJjxlv6OSZJt2M9AFLy/vZzw14guUhcim3tjknUSd2wQJDAY32hy4MQIWNwrnE1xe2ZARXxAj3reygy/kpZ+PGcHoU96p4BxzlUZLJXamsaeOfZRQwRuXsyQXWCfFqg0zcm9JhTcGKs5vpFKw2D/u6b6n9yLZps2Cm3t7fCz0CHLeEfk73I+SZ0qY3rWrNv3m2Qzz7yBkG8mY44u9MT1+a3yZzSQ/K4kgoT6Pj2oR/krDiW31YUrFipmU8lBalpI+w9VyZp5gdB4Mcx/xjbd38dH9Gf/cd2MSUDrCMk5q8q5RDmsxJwjvP2WcQn4AVUDR8vM7JfVhkLkOikEMKwoIrrkIJ4UkX8gCvhhAb+hNh7VgyK3Ksf5ckWgXkqJ9ZwnUOW23ffig0BW3Ewm+2HSyWzB44Uv6b0Wdx/+N/AXuQjGt+T3Y3XMiJA0aAIIjqRagK8A8pwVnemDes1RXhkq+J/rlb0tVJdzoM30+7o5dnMYIP4YJcGezJ70NAqRIkyCLQxaDvrgH34AMJHlm+TsjMm4epHCArUF1SYYBXMkJAZMiPsK1ArDQ137ItiQwhv46709HyKUC9jLaE6+Nh6PDVsZ4Ysz+FxsHYBTvdnlHX7fIB62qpMvi7peyRX/1VBJaLRnYcoMKEo9w8w79wuOnpXkS5JCAW2ECMbp/KQvYLmu6AeZABtVDszOWw3BwqnIgoZ+uvFW9IFslog03EHl0LLj0BGg6VlmMLefuQ9tAME2g582+1+PY6aIsoy3CkLlZW8aCnzX
 K0wYqLO6
 dWUSstS1BsnuWdGEoEGb4k1BD1EeWATFsRiIwki4WTu2nHRwi4tdSmTLKd6GHpgpcHAPn0eDV4TUbt1W/hIKi8AhgRPAEK4Cq4hkVdgCwfT7CQw1i8SmGJOwFa8Ts0MvdvwZ8whVKaeT4fg8z6EnYsq5WbCWf8vMpstFGrPANQ438bv5auL/w3wDFZR+UFGiIFK1fPkV7xnJ4mJNZD0i5agVbXS0TyQBuiY6iLWtoX0SOK6Y68A6n9b8z+lVw/lyvNjaAIzM0EqjRGxFYLYWoaoC8zc/v1sJaY8NswmxzAPDD/oueEP1G3EXEZS74peo9A7mp0JcbqmAmJuMOjM9Zpg9OCxvF7O3ZY6wj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:15PM +0100, Lorenzo Stoakes wrote:
> The coredump logic is slightly different from other users in that it both
> stores mm flags and additionally sets and gets using masks.
> 
> Since the MMF_DUMPABLE_* flags must remain as they are for uABI reasons,
> and of course these are within the first 32-bits of the flags, it is
> reasonable to provide access to these in the same fashion so this logic can
> all still keep working as it has been.
> 
> Therefore, introduce coredump-specific helpers __mm_flags_get_dumpable()
> and __mm_flags_set_mask_dumpable() for this purpose, and update all core

Why the double underscore here? Just looks a bit ugly so if we can avoid
it I would but if not:

Reviewed-by: Christian Brauner <brauner@kernel.org>

