Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABDCCCC6B02
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A235D6B0088; Mon, 12 Oct 2026 14:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4456B008A; Mon, 12 Oct 2026 14:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BD56B008C; Mon, 12 Oct 2026 14:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 615A56B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:23:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E055481389
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:23:54 +0000 (UTC)
X-FDA: 85314797988.18.BE59949
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0CAC31C0005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:23:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AYF/F7fq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791829433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37WCeVdlLTRveaVJsSPOSKQC2Vppgq3a3iTQ8o/4uyA=;
	b=uJUSEmQodwrblLPIZJK4wMDAnr5xst8QDKXKYjr0qN0p5GTHCMN7SDbQ+XT1iUkEX21S0O
	kigTmk/IP3AxIAG+Bvf/S/xH2kYAnByJHYZfxBp5Fk81Fv/IWUqXiX8c/h1RQ29SThXqnd
	XejUJaQ2k7qyg6z+vmnvF4agmozDu5g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AYF/F7fq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791829433;
	b=U+lFhE2Evsr422nx3Ob1gViBaiXTJ+lCpHJiSC5pq77+IrhlrsUSG64QBuRF5+MIqkjI1I
	5/Dl9fuWMe/qID0D/douSc9bEcpGBWsmYnXcqXGw7KeFD2kt9xStWAHWfJZAF+P5Ad00R2
	RziJz2vWlXL9coi7CesLeOe4ZqQrrGw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BBB41413B9;
	Mon, 12 Oct 2026 18:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC841F0089B;
	Mon, 12 Oct 2026 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829431;
	bh=37WCeVdlLTRveaVJsSPOSKQC2Vppgq3a3iTQ8o/4uyA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AYF/F7fqLNd7h6e/tgtw1sUNYW18ddEXw/2rEyAeYmwhh102XwKLctA9bL9zaPya4
	 ynOK3Nw2RwXvwkGNGFmbVO4r+0v1EZXqh4DY9tZyMbh3SG3hn/Ud6M0IKSPvCePMhY
	 zJxoop/oPTaRAsS1MG3Ax3decQ4U+Xt67Z93r5JYsn0iPPqDOCHxaVesVM58eSfPr4
	 1fJrwl8WiJqz2PSFhVE7ES1tqCpJRFbOQ/WClqMcVpVdCtBB9xKVbDUDY8fR4bB8+n
	 eAo53kC+TloDeXdisLy9hXAVc/lOE3GDoP8OC/3GC2sBJ2G1q+vh30Dpaiz0XXBlNd
	 PkM7H9/ss4GSg==
Message-ID: <50c967fb-b6de-4189-9430-5455c26a5385@kernel.org>
Date: Mon, 12 Oct 2026 20:23:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 23/38] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>,
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-23-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-23-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 81jctn4tt63n9bcftspgeh43upiq19xy
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CAC31C0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791829432-588915
X-HE-Meta: U2FsdGVkX19X7mqzwrwfy+ZZ3fnfpr5hNLDombJ3dA0vjeC/xISncdUhFIMeqgQfzrsJjT0vQWHN2N1fREZyeNFQ/Jya1kdODNl50r+yEeiSa8HFT0DGggZpSCPBQOfbWAalUYmCANB119+zvH27OPQxM1vjnigfc+cHe9UnxljP11LEtDOpfpI12mceosgf3cgrCtCGKaXsHtlp3IKGJk8kQ9KOcRdkifElXnk6vE4NzccQjbra1HIvjRJk46Z/3jlRZ7rNFV/YkJO318GqZp94H/UNUZJyNYKW5IlC/6jlerttBc3tsUYHZBnaf7V63GfaY5K2omxQ/bdEZqoW8ozvmFlzYqXCqZJI7+6/AdFTEG3J5DYrQyQtCRRsy2JMpmcGm5Zm9eFyPpmVX/dSRQSfI7xyI6HvprB+tyjUpSurgAqdmShdsp90Siu6R9SU+rf3pUZzluUAqYbEai+FycQg0WETupp2YIXgm1MWLknnsaE6WmOCFzGYnpfUp+WdB48NAR4NTdNAB2vdOgetL00l5IaSvPr9mf1sbqp2bXjQZpYAWSukJLXillbGMbTRUaikZbUEhHR4a9dswsVFCWf0rMLrtPisoqOxEpJajT+ExdBvEBuPgL36JcWYjQ6/vzR4HkLWmhnYvp0BoUJQWImGjaRg/AYZL0iduCTLkIgeMveSC316f8yaoeX/HOltNi0MneuXLFgPG8GDPHMFSKg6ZNOoUNfoUBnui6cnSP3WShMfCoC3drqDXv9drIEILxQeBjSaa8Sa16Iu/dAmKEemEaDEVX2sFr4nlrTQ2WJ0n2H5ZNExt3xLe6lc9C49GPgxWhbqaaXg95LSY1KkdkPF/fzZpMjBG4CBCsd02MnpLJQyy8eqWXr7b73bvuaWdHEHGHd4vHY3g3QBslRwVhSgVXBuEiQ4bohSo2wrnm1+Kh6LkQnKWRV2MwCjCT5/0fECQ8sCqQtOF8QerDj
 7x9h0Ksd
 BrFg04IMMCzYGNqrytXCGl6ypnTnEY1xCI5/Bdn4YJL07bgP/L6PJ+t92LU+dUPS2qAlaz6TKqCkUvI8FknG1bmYtOk435TYRm7jRmoZ6J2/CN4CUBubNM2Mde9i5ojoq+XAooHJTNNOrY+2Wh15iSOb78tnkDJRMv+5Znau8Q72igrv3kxAMhDU/S0HVmTgHgoXfA4YnYMX8RSBZk33UGfGBEmrhRoPM/+/XI0bhdwB33//J3P1Iz/rdvr9JVQtbHOA/w9PiuPW/q6hE/c/I3f2yZhrmoIhcR60Ht1N8yKxc1xf5WMcTch6tZlElEpz8D7hv6dyIiIeqyaUTSot5VKQo5inSErytj13DB7GZg5EM2Q2u9d++wV2A+nmmP1hlFlF48wfsrTGFoM4bS27zF92QQ7nfze6NiaONUBD0pUY4ics15O/fymHGmPLnAIbNljhORnobP1ZgbMS8fxhb5vJi7VT4JLfIAobOKkFlVz7jb5qBa983BJcmXlX6S9I8kWU0ZPxILAuI4zmw2BuosGpKyevCd07GPFsmWRVQ1DuQ30VPVQ4FFXi0/1lTXKNHGTALLUeIKftUmHXgjE5YWlDV1SHiAecEO4ChpgeLRytJ/nUqFx/smEM/HwqA6b7cDDCLQ/xnnig8FySud869ZS+xPT1N9qN8QZhCjEHI71u9SvtQ5SdPkibTeLNAJPRJekTiVMFhYCiDqogS9Vx7Wk7FrGMHmF7z2ZkBx5/FQzknr/vJq5gMcK/Uob7BFoUtIOygJb4dJBCI7NcOd/fYwC/wYEUJPCUOnpFdya88+RJ6jSPJpDLUfLbZx8WpHLQk2lCpQt7y841MTFobaN9Kn2RV6dYHae7obScmh8Tf60/r0Q97bwf33Z1dZOWz2DR48WOmdkkFyuCKCGYanY4BAdHFzPNYnvV2Om1JX0ZgDRMkG0jJj8oVTHWNNgzN1zXnobVHAFkwyBKb3E6bYc0wRRXH07es
 u7sAZH++
 p8w9FLqUU0b6sZAiP6I1THQ1R0uZbqh9a/w9AGnlQpaJkeHRWIr5Bf7ehKBiWV69OwJ+Vvf0/SnrRosaFFmCtQKiy1x23dOm+avH5EQzQP2lGJmMIOyo+CtgoVXiZmxPypFOhdqlTr7I0l9NjMuRXnBY5W7yK9NhGQtC8BI9vLkcZGsOiZk+HBWV5J6fQ+bRLtEUroyXWVwN7wkD++tWIXCRpVdO85FWxxOIK9LwUqK2xAGbrr0ualnb8Lu7ncyZPer1n27ftrY8Au4RczyCRrG8A2F/FgY1hdt0WIJSxchCTvktUFzFmcsTyYFUaIeO3LFfP8s3f1S897VT/25eCCEI95QvGX2pdLf6bUujIC8LDU6cKJowS4jRJ7lf9Jptfqx6Jqk9xFVQDhLHKeNqZeWpu8LsGSTQwSTW5SeaWGQWO7IXNqZY4wwblme+GeTVKuOiS7u/x83CKAMleyVBNCYoceQSc4tih+7U5OGOs/r2WEHg0Px07LBn077CXCD4uQnsfWYI8VTRstttF9qSvYiRWXXqsAfxgdvtPkXaCmbVBd6WYypYPo9BTNVFSbkdTWM7qOyTu4dMdCRznmboEYRXHf8K6MNxMz6UKkKsiaTcZ8j/KzkHMjbDrZhbS6ORVnICkq3YgRF7G5+DwgPMlRm1TKdownsxlotXmVdx9n2CcJXVGxuB29r+Cqz/6iH9ofEESa616eo0H/p8VzZ3FL/XYMATSFMV98BUvGwajqqnOSMxTrRve85wRmePfkQlc4c4wAdlV8K7LNMYmhbhRHuMRWcygiKyHXHhs3HF3LSTI0RNc+CAuOVt5UhgZ+2ccnmcOswtwPC6iw4ar95eWNHNR0OENF/Atggl3WsQqwn/3/DwZ+zraRslmlzg7bnHY6cwa7LMrEqmzWEifovdoRqZmV1orK25/kmXLzDvdNCZbrzm7SB42eyQzGoYATyDaX21zOZGdF7xqyxJrYtn8E9t1S/FQ
 5HcbCNHJ
 G0oXx6MDGnDSlaJTzoTOx1sLzS5Vtw3SYFR1NMoWpM/5KAMdmkbvYwxpekm5S50/oyPh0xnrFCTkJ+mvbOI0SFaHnp7SsWfa4N9K1Gb+RRXcIgAk/gss169d2zbmcxlgFA65J08k5mdHFnvqxtFcbJQjftPlPKr7noLLxdcvz5wc3L9t0e3oSno6pzeHydjfYTx88UJfsorNy3x9Y2a4BDg1M3Rwt2dyVagXvMMtp9l9ZRtsF7xKoAIwAXhGiSSPHduOMewEQvd8xg7DcT4Bfs8HhLJd0jYp87rNy+RNOOS+Y1jDyFAwq1u7ssnX2JvTn4v8Hl7dxPTc5Elr30CICfV09V/UpN4khIyYX5P6tewGCFXAgwlMe5vq6oaDWX5jcm7ha+JCl8MXktTozU5ZCE060EEl790wnDv+DZQApOHS9He3sLH9W9Q9iV5mXoSnWIe4os5+Ciail5ESS6K1Ix+UGs1Ti4a0cN0EcgWH+8WGtdhzT5+TpqKN9R2BlGLf+6zJyJsXWUrhjruPMYlhC3Y9/I+LgxtVqy2Ksz9mhf0xF5iq35jzCY/CV8O3BM/2YSDSqjQ/DAym0K4JPuMJAWzxHBFZz42H7OWEbibV/Op2emL0ExR06jtGDYYvUP0CT4DjfzoNgUIYs/47JoyWjf4pwtOC1rp/PWf3dgV9hO1iAO0Womkd6oQSfKVoBlwciDkAVjMsOno2AJyyyHvbEpinjI9ab4t0fQM6A783oC88dX1VwzRLYmcbitZZ0ehQI74y1DDtMcVkiJbv2TXs9+szbl+oHhRg56qNl/qSSn41dE8fovkGoAGSBKi/yktT5E9PpsuNkcgjRLxe3CH7x7nSGg8Um6eGwO+fGtczLy7gMF5vw9P9xpfGDlAms2bK0jf2aZyb9cwfd3eRRLtt5H86l/Sgv2DK9GqJz5l/kBjWl/fZa8VgLkcf7m8TesyfZRiU87AypJTpGgltYUHPHrwpuXg/O
 E6ifntvj
 NPmjB7sK2XAfmwkrqwpmqWjGhihQCPRpbavGUBgz3is5Vr3P3BaIRBAY4CthZmTOeO+xXLxWOUndU8UYmN/96iEQSaOl0b1nvjgN/UduGpZRgu9s5ErOUn8Sj84fNlFha6i9ITfOo/f+iSZD8vxHVKFS4UCPDPLuykkvugEYVvYYWplAfJyIyEcH4iCEPJ5o0MJA9fU+NuWEWZwK1NmoTumPmryIfXpASBaqS/hg5ACzC4Zeq8MUy6lS9nRzSsrstRgnSF9IEL1DJgFxFITCMZbZAOeuCkDko63J9gAWndQcfIlnRkaXZWCJ+HXOXcZNwr7Tp/WOFphNVm+VBIIkhzW3/ZrtFnwu+8Chi+H1cJUru+hQXHZ9eyjcRO/LkfTLLC4UCyqT5Pvo3vu4smIos9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
> solely to fix a race with migration which might otherwise double-count
> mlock VMAs.
> 
> This is unnecessary - at the point of applying folio mlock state, whether
> setting or clearing PG_mlocked, we know whether or not we are locking.
> 
> Solve this in two ways - thread a boolean through the page table walk
> indicating whether a lock or unlock is being performed, and run a locking
> walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.
> 
> This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
> VMA_LOCKED_BIT. These are also always cleared together.
> 
> Then, update folio_add_lru_vma() and mlock_folio() to check only for
> VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
> instead.
> 
> Also remove the useless invocation of allow_mlock_munlock() which simply
> returns true if unlocking and instead rename it to allow_mlock() and only
> call it when locking.
> 
> With the other mlock abuse of VMA_IO_BIT addressed, update
> mlock_vma_folio() and folio_add_lru_vma() to simply test for
> VMA_LOCKED_BIT.
> 
> The munlock_vma_folio() function tests VMA_LOCKED_MASK instead, as an
> unmap racing with the locking walk must still munlock folios the walk has
> already counted.
> 
> Additionally, in order to ensure a racing unmap/migration releases the
> reference munlock_folio() took (whose put was batched), check
> VMA_LOCKED_MASK before calling mlock_drain_local() in try_to_unmap_one()
> and try_to_migrate_one().
> 
> While here, also replace some deprecated VMA flag predicates.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/folio.c    |  2 +-
>  mm/internal.h | 10 +++++++---
>  mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
>  mm/rmap.c     |  8 +++++---
>  4 files changed, 32 insertions(+), 39 deletions(-)
> 
> diff --git a/mm/folio.c b/mm/folio.c
> index 47a437e0f7fd..35e242b48870 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
>  {
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>  
> -	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
> +	if (vma_test(vma, VMA_LOCKED_BIT))
>  		mlock_new_folio(folio);
>  	else
>  		folio_add_lru(folio);
> diff --git a/mm/internal.h b/mm/internal.h
> index 4ae08fedffff..ea8fa94ebe1b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -970,8 +970,7 @@ void mlock_folio(struct folio *folio);
>  static inline void mlock_vma_folio(struct folio *folio,
>  				struct vm_area_struct *vma)
>  {
> -	/* The VM_IO check prevents migration from double-counting during mlock. */
> -	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
> +	if (vma_test(vma, VMA_LOCKED_BIT))
>  		mlock_folio(folio);
>  }
>  
> @@ -988,7 +987,12 @@ static inline void munlock_vma_folio(struct folio *folio,
>  	 * always munlock the folio and page reclaim will correct it
>  	 * if it's wrong.
>  	 */
> -	if (unlikely(vma->vm_flags & VM_LOCKED))
> +	/*
> +	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
> +	 * mlock_vma_pages_range(). An unmap racing with the walk must still
> +	 * munlock folios the walk has already counted.
> +	 */
> +	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
>  		munlock_folio(folio);
>  }
>  
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 39215a3eab1f..4235a1518fc9 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
>  	return folio_pte_batch(folio, pte, ptent, count);
>  }
>  
> -static inline bool allow_mlock_munlock(struct folio *folio,
> +static inline bool allow_mlock(struct folio *folio,
>  		struct vm_area_struct *vma, unsigned long start,
>  		unsigned long end, unsigned int step)
>  {
> -	/*
> -	 * For unlock, allow munlock large folio which is partially
> -	 * mapped to VMA. As it's possible that large folio is
> -	 * mlocked and VMA is split later.
> -	 *
> -	 * During memory pressure, such kind of large folio can
> -	 * be split. And the pages are not in VM_LOCKed VMA
> -	 * can be reclaimed.
> -	 */
> -	if (!vma_test(vma, VMA_LOCKED_BIT))
> -		return true;
> -
>  	/* folio_within_range() cannot take KSM, but any small folio is OK */
>  	if (!folio_test_large(folio))
>  		return true;
> @@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>  
>  {
>  	struct vm_area_struct *vma = walk->vma;
> +	const bool lock = walk->private;
>  	spinlock_t *ptl;
>  	pte_t *start_pte, *pte;
>  	pte_t ptent;
> @@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>  		folio = pmd_folio(*pmd);
>  		if (folio_is_zone_device(folio))
>  			goto out;
> -		if (vma_test(vma, VMA_LOCKED_BIT))
> +		if (lock)
>  			mlock_folio(folio);
>  		else
>  			munlock_folio(folio);
> @@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>  			continue;
>  
>  		step = folio_mlock_step(folio, pte, addr, end);
> -		if (!allow_mlock_munlock(folio, vma, start, end, step))
> +		if (lock && !allow_mlock(folio, vma, start, end, step))
>  			goto next_entry;
>  
> -		if (vma_test(vma, VMA_LOCKED_BIT))
> +		if (lock)
>  			mlock_folio(folio);
>  		else
>  			munlock_folio(folio);
> @@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
>  		.pmd_entry = mlock_pte_range,
>  		.walk_lock = PGWALK_WRLOCK_VERIFY,
>  	};
> +	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
> +	vma_flags_t walk_flags = *new_vma_flags;
>  
>  	/*
> -	 * There is a slight chance that concurrent page migration,
> -	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
> -	 * will call mlock_vma_folio() and raise page's mlock_count:
> -	 * double counting, leaving the page unevictable indefinitely.
> -	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
> -	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
> -	 * mmap_lock is held in write mode here, so this weird
> -	 * combination should not be visible to other mmap_lock users;
> -	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
> +	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
> +	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
> +	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
> +	 * still refuses to unmap them.
>  	 */
> -	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
> -		vma_flags_set(new_vma_flags, VMA_IO_BIT);
> +	if (lock) {
> +		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
> +		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
> +	}
> +
>  	vma_start_write(vma);
> -	vma_flags_reset_once(vma, new_vma_flags);
> +	vma_flags_reset_once(vma, &walk_flags);
>  
>  	lru_add_drain();
> -	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
> +	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
>  	lru_add_drain();
>  
> -	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
> -		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
> +	if (lock)
>  		vma_flags_reset_once(vma, new_vma_flags);
> -	}
>  }
>  
>  /*
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 5332c52909be..b4a4b3929044 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  
>  		/*
>  		 * If the folio is in an mlock()d vma, we must not swap it out.
> +		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
> +		 * mlock_vma_pages_range().
>  		 */
>  		if (!(flags & TTU_IGNORE_MLOCK) &&
> -		    (vma->vm_flags & VM_LOCKED)) {
> +		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
>  			ptes++;
>  
>  			/*
> @@ -2395,7 +2397,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		}
>  finish_unmap:
>  		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
> -		if (vma->vm_flags & VM_LOCKED)
> +		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
>  			mlock_drain_local();
>  		folio_put_refs(folio, nr_pages);
>  
> @@ -2770,7 +2772,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  			hugetlb_remove_rmap(folio);
>  		else
>  			folio_remove_rmap_pte(folio, subpage, vma);
> -		if (vma->vm_flags & VM_LOCKED)
> +		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
>  			mlock_drain_local();
>  		folio_put(folio);
>  	}
> 

The mlock.c changes are a bit over my head (mostly the old VM_IO handling ...),
but it looks good from what I can tell (hoping Hugh could review ...)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

