Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22E4C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B588B6B0093; Fri, 18 Sep 2026 16:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A516B0095; Fri, 18 Sep 2026 16:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAD96B00A9; Fri, 18 Sep 2026 16:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7390C6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:21:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CD2E407C9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:21:06 +0000 (UTC)
X-FDA: 85228002132.22.DFFD8F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A63F380003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:21:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5I4A1B2;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762864;
	b=u+aQCz+xKVEBUMDm1RKn5VPSEzSBpQXzPhJhlJNxiM8pRm8xyrPK6gQCCve6SHnD8uZLQ9
	/wlSj4L9UwWmaisEKlcvtQ8W/wnipkvQjip1V6pKuN6nKSa5PA0hU5D4dwJBmnDqnRnVtW
	BFIT0bKAWMHQ/jUOcDa5FB2tY5LTWEc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5I4A1B2;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9Btssn2Vdt4f1rDfXSpe3SvMf7Al9iM0BYQM0epkxU=;
	b=6sK4a2GtjHO4UMdDqO994PunhD9g1Gwr2oYF8tfK4kHM9/dB4v1iqRprwK7lMwX9/7o4pS
	cP3zjxK0mELIPws4NPd7EXHrKdgLb75D2E4oFSOXrz0AqWGVjdlzATUjAP3ydeAYEDxrwh
	BiBdopYbthUdghI6lJTvva2xLPN+5XU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4839C43435;
	Fri, 18 Sep 2026 20:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B51D1F000FF;
	Fri, 18 Sep 2026 20:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762863;
	bh=U9Btssn2Vdt4f1rDfXSpe3SvMf7Al9iM0BYQM0epkxU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K5I4A1B26PMHt8oPJgzgCMhlS4wSzBW0xEdgRbYlFQ1L5+hcNK9ojIVPnuzpqrdbT
	 jd7Bsbd9/3qi1WJCFDFEn1cF/K3pKWl1vPLikx7h1QC9/76xJNN+kAQuaQvJ8YE1y2
	 kp3ao0JkBouMOZwr3Ia5Qz68qTIGvmqoUZjV0y0o/Wkk80NxQReNfEfIzJxvF5Hf+T
	 86SBEURe95FNDjfSYUC0ZfDHH/jL97aBVufgWmldki1cC3Q6moSNid+uoLdUysA5vW
	 IHkh/zc5jxj/o9IiRwQtcD5yXGTXsyAfIhh+Wx3RP0y/ENE5y4vHqvd4IhEKCME0UR
	 kkCkah9a/d9Pg==
Message-ID: <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
Date: Fri, 18 Sep 2026 22:20:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
To: Andrew Morton <akpm@linux-foundation.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>,
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
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
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
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A63F380003
X-Stat-Signature: qpjwyi74ha1zph76qztu9osrs5f78b4a
X-HE-Tag: 1789762864-89434
X-HE-Meta: U2FsdGVkX1+1wpKG/9m0KR/6cp+AbVSve2Pgc4/N5/a5ujlYG8X6O8kwu3XU/5IEZog38TEKPT6DO6T8TyijhK7SR6OLYfYvjib2Y1s3GHi0LhIVP86NTw3MwGKKvVLfdQSBjSdAqN5oZtDtZt2ibBobfVinrWDtPHDsE+0FcHe3W2iTF5FwbbAUbc+khO+rg7KbS+Ip1leBohvh1iX0EOOk7FpDo2ognCs+WS7yihOiuAO7ONBJ1cZyjrinmBT1tOon7LsGRWT5wl9zyYtPDxDmhOF+BI4iO/SJ26AOoedDT0UOSeJGWQKhLImAnU+JwN1Tecmo+eGHuTExzLtxHb4Uv2wegpJRW16Y8WG313UIT4IUDciaIvgzy+dHBYwcB7DwfpyQ2cFmUmICxYbUEtT8OXkzTVCzdConJS9JXfcAulaCuwSUTdHXEeilCAdCxOrXQgrpLdl/MX6jh/N5bY3O/PCHo2v/9p8fWj2EHiusCNAaI8JZba4ipj5TJCbTY4MadPDCfqjUBKFbAa4yWx0zhG6HOWFev5OIt4NrKwcdAi5+inqoC6ppl95k5ffX3OlxBswwn+4q5m+7XOStCDU3aU39tN0cZmcQxiUVc/zHHWkjSzkGyLmIy2gNhv+af0gOB30JlxgepyU9YN9p/B7FbnlW+/7KpufN8XS1tj7uMcFW9sfh+g4JqAVkIBAmXe5b/Pe7JkVGc67plyaT6/0CwYO0KlKMRhLYOfIKDI0gL5jSKIkB0L+Kk1O4fX2/dFliT3tSeUkzy6VEV7qk7pyl6wOv+e0UEtPwytJBWWMt63DTwwaMBXwlrcWmrcgmgXhca6tvosD5hGN+MraGszFUE4o3kAkGK4+8phmHR+MZaooQyXH3TuG7ctzu6SbiI9yAlEsLLNNmU7rBJUq2ZHNBpGrgaJGP49/KRYB5DCTgm8rFRA/pZXw2lzu72T9obsVoeccTapAPIYZe6WQ
 ZL1xBaJS
 Uw3zSgpuCbyZdlkt+o1xSs0ObyjZMi8zw69exrqTDnBRjFvCh5u65+mLa1CGiY/w3fIaFBQiQsjZ/dJBlOa9tPu2pus2+dHYBfOAl5WUjL5owImzUw7TZv/L+ce16kAgbMTrhEeZ99EslFl5r9+DcF7fSun3MwkkdUdAb4KewEM27TI4CWun2F96WvPwknzlwURJtPzp6cARA2pmYUx6z8on2JzH5iMPmPFVkbH5iBbb7NbS8qlZzoUtO1WPKuUBZz/4tPk0F0pifoVmFUdZ/12N9FGV+WPPUNB6tDOHIl+nTorV17YkmoznPt+O9UV2fdnJxPZK1VDK0G+YLHdSPBmlJXl/FetEQOzP20DWQAVd5n0X3y9ye9UwiOg47bDZD4UuGxWrupeoZfZkz/zA2z7BxCIUgfJb5VobCDQmF1oYUWB1cYfiU5hUbNGty/KUjCrAkncf/fpr9z1X5Vaa57crHBeZWTXi+Mfqr5Lel52mEUax0JcVLywOcNJJTXj1ZZez+yyxASkErFOK3vGHPz+9jm4XVs/s+5tBO7LXDOwuaJOcTjPiHc8MPShGQwEYtdmd49+nMim2trV14CJ0a4eN5Audl5Badh0CqCenllF+LxNfGysXKdmM4Xmqb8CjkEsgX3YEvwZj/ErWGXpyH88Rjv6jYhKhzSlTCfn9Zz7FVzeWRzWAMkZA+/78dWWnaJ3uoSVGzK+nUatt+U2JNEP5L+nrpjFpC3oDGxdJ43vvXQFY5iYQBo33grR+Aw5JUO0Qwz4KHfFOWylKME1CCH6iE87ZHMxXm2aP75Ne89MMEKwPmaRnw1oHprz/1TwObSiPbFxKF+kCrJkeN6Spj6Q7+/NdRjbH2Z5XfCXOnHPH0i1E8ohxjuidpBhXCzOohTCyM3I/nXS3R7blNQmMwb+yo/QiNxM/FuFVEScpP8gFJ6QtE7JWA0dBo5JCgGg31wkHH4yBfRKk+HtVyjCbfWcHC/jXa
 BV+viDfi
 BY6xT/E41fn52xpGBmFP2mhkcdZcyPbsj+3jlmSjO0m2OXkNsq4MseIWwEBMuNc3xwRRudgcBqMzALNJ+LflPDB7TFckJxaZC0W8iYWb3a2bxRZPBQ9WtOynbQXvCXhB1kYy05BLySdtajgf1AtgTUYLYWcvRJgpO+eL9L7c/q6kRtsHOpqrCyf6ymzOlAH8IOs1OxvX0lvKV/TRwNc3/zrvu7pvGWvKzGOFASFH2WZaR2R4CYQvvQ1ekXGI2UUscNXhixmbgQXCM3Ds3ah+q0bHqDWwEVvCo5QH4Ui2uiU3ty9IdU7/Ik3lPeZRPBtPoDDL3C8cmDrzq0hQBDrcHWXnaneQ/KIHxsxt+muJo8lCbDNyKYXXiQQWJ2Hn8wTRerxu2LnN4Von9oGyVfZU0NZ7ZaCiZ3+6qBEdPblzCrcs5s2OBOAXcn8EXDywEs514esOMVbeb3koFbpPOQgp4Pu6XqzAUOfcEtm0T57uBI3VduycjGhRIY2D7qNXXPDMWh9M2O758EGibawFWpQSP38f4amahUxGHYUyevqcHoYUeRAAeA7pDxTBhssZVOMHWjDdYaCcSdRRdKDYH5Fnr6m2zYt8aj1/b81BzSoEkZuukIMbmJvcCpF8KYdv8Pp7lYmn4ddsKdDmjARqDElinS4eZAOc+Kn4yQbsQZvEKX/ChVSdrAtmHUqg9K+oOmjD+7cdM8advbdgD0h1xSdc8Kwr23SVJjtPrvHLUhfMdfAIeT+XB2SVJQhsD/9zxyPOS3vClSqf6ulhMUOYbu+FWYlsXGNfyiD+DOGqVRdzSXhOgBvR7lE9UOk1iWCytKpkT7oWLNsdQthlniUl8+EhdWN7Yk92uYm/1YgHz9m0YsDG0PbO2QX2gmw+lMb/wFxT2KTV61e8x9+kvpOvL1hGCzG50cXQcJJc1jo8y/Wy3XkNqOMeKQAipP3Gq9oeQTd0AywQg+zg7+ZbTFtu2Ltr6haMijtDN
 ra9hCMXw
 HXF5n0jNYjtNSwai9Ka6BfOUOeLl3xZOo63tboNL+L/sxizyEfKdr1cIIcODMlKo34DXeTgcaJwAGb4HG9pMgC0hjBT7cI+z06qY8zud/4Eia3TDwJMwhjy1rwfsB2lX+yqU+YVXdxw4DEIkqLSPCGJw3eTa6MUodoTGVrUuKNHYV/p53g9gUp8xXwdFhAGksAXrNLEm5s0/2sMm2rSwYK6yosm0JY7RDiASi0fbM9tpn8YDEO7/NhqP0C87GCpb8b13kh7lBmsWFwUNkSfscNKTR8c2UNZFpzvuyvL4PxYO8kQcGX4NS1g3Sk7pKQJYHxXuOPq9GJQmEDPGErnCZT0YUvKa60bbqPCRerNVu5kGbjo/UuXxV1wawVxKfS4pS1ohZjdAnU7MGUkwwDMfWAbgl/awxsBBDRLlNBNesjm716o+ifhgnDK0TzOABvRMbFmn7hB3CkTQviroelEclJK8Di5dZCfKAOqseneb/In41ZQDYw4M4KH8c+Jr3JA84LXEM0IoyLnTpGDNsTRmdH3SgZHFoh8jw3soulcmcmTCEcQjy5H+ZVImP4fVG5zq6f3vB6hwf+Rgxw74SMQBjFKIQfp5r3B65FhBqoS+M2Etjy7fse5CsrEoOe2+rj48uOk3jW5I2H4FZggYALKRvobSapqqNLojtSvRZXSgcNd9xaGmrIpMJq8R0WfYxtnIfR5AVdQrASCwviUD9ZqpQ6LSpeb/CLrx/Z+khhpcQvudcSPgvw/heYMDNzdXP34Hm0tC2SyGyt0XoRg+P9Lw5ttOqVUmxe/0IrbMoXg39k3jGZddO2dH1Vnh0YVbQBtDH/PaflKLDS6pfw/3zwETEq/LyR+OXocCIhh3oBorXs2W2wq1ytZl1U1anWP/fv1OGLuG26gHs/q6XuwqZo2QC+Nk1hJZ31Ti00cUBPUK0Y5FCHGYhPNZaPvotkYtXyQ3dzQkyUT6vUQcs+LPl+lhQiNZAD+VZ
 mDQK+xVW
 sKgPh0xHw1cm5KwelyiWwbJPFeOyZic8pd1eDV7MHO8Iv8MVRWouWataCanUGV9vqwzbBsVP505Vwa/WcpRZ4NNCR7MhrlfAGVY2YickylVP/UPLCL0FmswmhCqtfVjw9xksz5PHECvdUxoc+QVco70JB6FDmsXTe3SCH9crvNucZpXE9Vipz3LQZa6a59cZjZHacdM/VKDt+1cxciEsbDvzCQAlzT4T6GB1AhDMrtETgqX/jqVxaQ9repq8Rtt0nGM1lDIBi2Vpj+Mp1BHmZ0oz1gCku/tQtUJSQwr1ZiX1BPvWZKl2HCUXWndvLh/WA35/Cfl/Q8mpINQERbNME6FUqkbeSPvY7yV/hBBPyLfEAvcMFCZA69
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 03:08, Andrew Morton wrote:
> On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> 
>> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
>> properties:
>>
>> ...
>>
>> It's all rather a mess.
>>
>> This series brings some order to things by both limiting what drivers can
>> do with VMA flags and switching to using predicates that describe
>> behaviour, not arbitrary flags.
> 
> That's a lot of patches.
> 
> Review is thin and I expect this won't improve a lot.  Lots of "no
> functional changes" changes.

I'll expect to go through all of them. Might just take a bit ;)

-- 
Cheers,

David

