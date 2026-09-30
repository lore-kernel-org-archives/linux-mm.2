Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 508FFCA5FC3
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 09:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CA96B008C; Wed, 30 Sep 2026 05:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353DA6B0092; Wed, 30 Sep 2026 05:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A996B0093; Wed, 30 Sep 2026 05:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F15926B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:32:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FC7D1C3769
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:32:43 +0000 (UTC)
X-FDA: 85269913806.28.7514695
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B48F818000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:32:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/WFPBAH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790760761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUhUebTYwdNTDsFDAgKX2XUga1p/xniYtUmuBOcAkD0=;
	b=KqVEuvBsucAb7fgcWwFVQjsEdyFIS/Ulqww+y5Q6NE8m58gRRlKUVXd46i3D2l7q1EIEX6
	FMbxsabSA83m6YtHbWGGucg7RG1FH0bJ9daLn1nulP+2q4CWqEQPBeCfLLZado3GR7OW+m
	TEyfnBYD9Tp1ezz83fes6Jw5vzr8oHc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/WFPBAH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790760761;
	b=7nmnHzXfnTCDrZ39K7/s2NQgl28RpMI4RV4wKhF67Y3oXBim7fifaXELYO22aPV7zm7x4R
	/9bL5KkGpdxO7Ohqm67DqafCCjo5hhCErplK6WIccJlhhFkkGXOZbqwFLP308Vbpyau/qv
	PXlEdZx/HbCIylrxJFQh46aoFkJ1bZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D8F8413FE;
	Wed, 30 Sep 2026 09:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD21A1F000FF;
	Wed, 30 Sep 2026 09:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790760760;
	bh=GUhUebTYwdNTDsFDAgKX2XUga1p/xniYtUmuBOcAkD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A/WFPBAH7Qma+9hcX287RuSKWlORpntiWFjFLaPigU8Y75ISxg3KEjLTfteawEyBe
	 2g/cYh4OEqr71nkWwJpVQnorMprUQRkz1eix+QLOCr/CPst8lLD0ChCfFd8YGM4jfy
	 Fksx04sLagSxxR88vp09QnJZCikrL8s15UEcYtyj8cHuNrsfav7blbRqRE5dyxX7SB
	 IKNdTpYGGoAU9JjY6jjqMsEYQfRaLoK1HI3j102H2WUj2d2AjX7kJd1tm0yEuZtXim
	 rxv3PmM3a58m4CHKDbt2tmNwqyH0M2+G0zuIAT/AqLpxmsAoL5566Xt1IaKFXihiLq
	 k8Bhh/EDc3Mrg==
Date: Wed, 30 Sep 2026 10:32:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 34/40] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
Message-ID: <arzXDWOaouPMGtxL@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-34-4583d8a23bca@kernel.org>
 <DLSAZ4ZQY8Q3.3OKOCCOQAFVCC@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLSAZ4ZQY8Q3.3OKOCCOQAFVCC@nvidia.com>
X-Stat-Signature: 63d4r3tq5mmxr5hokeaxxtu7eqbnqgb1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B48F818000B
X-HE-Tag: 1790760761-931120
X-HE-Meta: U2FsdGVkX18ItsmoNV12K6R5I7Si/9Hpu0R8bxMPhZT1KGQH9dBS5MeUSDHSy4iKPgnHNiR+xjcmXWHlfi+/5yDpYkCOWnr4hN5H3hhAkUHpbfxZ1VUjHbFl0Ey5bWDAIHT5Dgj5biNrdXqWqEpkn+tGc9a2rnZwC/on+xH+MMOgtucrwKkdz/IaLc4sv46iFr0BCJJvkz3tYEE+nobTXsXbFPmaHWaGIVLNKNiJF36dcBrRefPWNeclsUm7GJt1VurkkFNevhUKdGZsGfNnI8HLjUpcYnLL+x7LoXXJUAQ99WxacuENcvnlr2vvet7jvJpswOk8qtoU2oa3I23hSZpqyzDPqbHOndAdtK8QzoLHNUlPgpRp2O4s4x5wslZICZmsWoSLci5v0S0/8FAEbjD33OUGIcZJTdBdUcpwd+uV7DjTr1s4o1W/6N0NhxgcrwZeTzB70t4Ce9aGjT/pN+Ws4hdki6P7sDz0Iy7CDdJiDQZoP6c2l5YSReUyU1IWdnnrGc6Oh/zIJeecZZacCFzCWjcVVgIKM7VUeXxZSZs6tcFGkKu1X5ag1HSn2LIlSVWgWtYobGGbYkvDpquoD0wrnSaQn5L1Lt6nsmn3Rfw92d4T0fVDGpGvaRI1yOjMvcUflEjBCYS2BAzTLH3nZAMGizfwI5BTP3eimPzhStPHknOijLYKBnaVeE04QFBrrw1bcWQ6t7h3BgzUNNa7m7e5ZYoB5+sNJVCkm2Ic6BWIxja5clD9tXV+2cahsdraiAB6xnUqgAYZGK31cnjfU8p5NJJ++R96kzcksu53jik2gRY6iguWORC1PGCbhRfauHMtyk/AyEqHMKMBoSvVZdXX0uJbNrIE9Eeptj44JbJG66Hqk0G04PkdpQPgI/zlubObhbYwWIOPrpywZ/sLolglEvKD7gOWN013XhjUTHtgyWGAJ0fYrokf8EzuEMFCVJec/Cycyc3tK7TEZXt
 NrZDFWse
 Qpxdsfdj4E4AjuUX2hfEEjbTFPlXcqQ0n6VwARWl9Olvl6rRVAq5Vc5lKESwo7nekgoJTRclwcLaldxs5HcFOKFhYoecCF8a7+1jfojeAxf91nqAKSAQELnXb8U7EikpBUbhil1Ezx7a7Ees8bzUM8G7ZFhISJrlLTsDmK7GaveIaqJ2sbI4ClPNkqhZfDTZQRF5yXLl2RIRvGnI+llyrqkEMhrqfPGQ5plwdg7hc5LeuRswd/GwTojc+3t8PXqR80NOGeySsxP86IOllBv6MQp7Sor1BcvgCzTu1S81ZnOn07QP85lZv/tgl8sVHolArPdD/bsrZfSG8eXDQV7gc8kuc82Z4jQZ3rJbZKYqWGyewcT3TDhXKcK9geKtd8scL7s3FY/N/l2gPr+EqDJ2+Hb96Ux0143D0BRDUiYPL/vWlPSUynsDkZE6ndgILBfQj+dTjPoZE5MZODCJ3dnrpcbrjh/N4C798OnenLhlS1qy0boRF2kAPiJZ0WZpQLFJoMzfIqEQoclu6/mzAnL1rbj/MHfP7Rcz3LL1LMBrh2JPAzaOk/2GDcGHVgGa8DT9GqxsyvLX9w5nIKuscRaP3B5iqIIkIznsr4K/PH6f8q3ilFKkgVXZnUlsZLLbZwVuoW5BZFhn5MP2Dwd8P7eYGDR3LVK0X1CE2Ijj1uxp1t3O7oXHfpgPQ+pju9VF3pwB5nSvew9mUCd/xDZbxL7Y9r7o2LXHM4Lkg44FdL6FojLnVYVTshS4h8yeOq218uBgvZbABB1BIuqpLlwWzl2/iaeWvR1SbOGKC1d355iIkcx+hsMJmVgKTX8XUzsDzgsLY0Ugl7B/WOEwhhgogCz5CGfDoPtT5LZfnteTcSDpL9dgoVo/PNoIfaCS6fxKrJWawfY4hYGvMeJ35M9G2vWmGoerYz8R+3+QngsXBnhQvZJA0zyoltxe78ijpAv7LPlVQsVqbzQsOBtRXooj7MrjtPVrhU7V0
 TJs9iGZ4
 71WShg1uB1VS5TkvXwJIGla6Tnmt7rWQJP+Rut4d+OJXLMBOeBBSWElJve2fre4OXV02wVJdOYnMdTtRzLjbJCA2wQLIUaj2dwVpsou6oHptaoI6d0ry2BTuBXnt+wjJ8+3UywZp4mOOcaN72qsUK2uoSPBuTviUxKNq/zuHjpn6bA7Ha8TYRPGtcBwMk1PR+h7a/kyAiW+kq0u7EewoH/7vZuwELAskuxOt4VbRJ+JgHYa/odOvMt1aHRKPFCU2nitH0xF3WmLkAY1E4emKJqWmfMtQ+99p8TN0teI15bgEILDUqYkg8TvJxgxyJ9yB4B82o/zsqOs8pzFjATCXarJvVx11udgN9jzRzQO+DW/CWkr2kxmBfMb1KACqCdk0PCC+/jQs6Lj44jlbVypp792yBlMhFNHXyi7aVFkMPPnAIA+wDMVRUUi3MnRSAhnvhZdqRYbc7BilGJUi8XpRgPHleh3Wi77fL29VOCITD1byh53SCw29ej44v/2wdRNJBepHMpOaNxkjooZXVyw3kDJ/a4//ZsaZW2RhSQyMvfuf9O7JXExvnC1Lwg4WiihqeU7+ovPFpnxpv0tVhniNRpSY+9pHvp1ZxkUznSWb1rfbNXpESIADW8s1fsyEbrxXygjg1EpyxVN6O9A2rvZ9QA5MTas/adBdofbP1uSzM3i3Pt9bAurxHYinJpIiisshCs3nJK3866GgRhCX6xsszUiHvYyZtnuRrj8qYB6PWvJ6FpO/IuGNbdC6dyUOlQaayZVIsX7TMzogega6DNcabwGhX8XnjvsteqSBZ6u2ocudAb5IXhPJtV97ciAXeQIDwBxUFtqMO/VYSPSHkfP7Q9o8/ADk24fGw0mfZqHQ7lLEEdKL/CKaj0Vieuyk5mPI+D/Xr22TraMMmOrhGwWIa1RZ+2hrJK30NnQiT1cjN0TIPagdSM7Gr9Uv6BY/cPNxMvuhmPXGRaQO8K7qem5Sz6UESNx34
 wi2KQCZw
 qewIkqeT+2x+LkuIVR/tM7/2WytbIs9t0GkKuo0m/n0NM7YbJF6egbAEFDQSdzC4xBgAbc9mW7wOrKdzCjgH8hAKf+XD4obF2J/bdYgwFkcd8jI/QnFuSaofAAcYWVPjHm4sEFppguaPNRi2d9Nbhf9ssWQE7L8av0luqGiKWnjc1CYNqHPV13w7+WtP9V0JRmmcg9KB2BZLmM+3utmSeuEPErDsPjsQAXIhJubd2BUDJsoLz2wMKJJNCcyr6izpswsZB2UaxVDB7wDWGGlLS8kzP3KmuZpZGsLYH0dK4HHWrhA84chAhZoHgER1J+blCn4G768/Jcc4IEmrRWWKuAm2vNq5iEO74sSZODtj2PQLzDv8kgMmwJvCM8V3LP2aD1vF9yxyV/ovIQGn+Zjh4Al7K8qV1IfvsR3iZRMDKi6jybvfcw5WBchyvLT99ZfofMD3cSy4qIHtNOxNDI6nji5D25A/EzQid+S982Flv47NQh696nARZ+lvPLcdO9kDG+/YEHdqOYBMDb6NJuHBi+22ZvFdDLbcZk4rSTumQ/xnfLSnc4o9SdHnr9aA0ntH4ppTtce0eEE2nlKAUH905dsBCES/WYtHD6hYnt4QsHlIE1GiYQspEontcXXxCbDvo88O3S7Bs6lJU76sp+vsGyBJ7OsJ+9mJoyLFWWtSl3NYKNOJWjkxoK/EOW6np4nChr20dnXXY4lRSi4dMGx1mL4HdEQ6yAkYCly0+IU1AaItmDH8eue8ak7ke3GVBTXAfia4M5Yewi64d5axIfBj3jaGOzfdah+Xhbosvgk+Fd5Irulj2KJLctNXxk+mVltQmLB3Ve+RVxJgJsjgcfka2QV5ALz1zoUKenOhq2CTC88WUIkaRFKKMFGu9XOESpblBS+HbkDS9p12ZenoLbnf269pj8ej2kyxZGEtNIMn0DxgnP76C/e6a1qzH8QFTFwmLuhyaAAsKpLaqAVt1Rs4p2wpIYoo+
 nQSwVzEf
 fcj/zssVqDGQkPUliwwphsM9NpHJcJtm0Up0+5n2pyALB1OTy13Dvhd/unOyjtIShKuKxSPKuqzW0lpqM9F1XR17qLPF8UGvzaEJR3GLmWdpUkv3hxcaJ7ejq7VxxrrRdK3fX32Gxq1MITRBsFzx9+1Z523ZYXKaJTAHieLOSWPlwG2r+9j9FxYa2bj0futOwN82hpUqe0u61fwGsmsedrOIPsWvnoFhxkLBGv+FCZ46n4+vVsDDEvGr/pyar4eTpr/gxDqLRBxyXlYmUD9aL6F36sGkpWiepl53nGyQydBc4NtXD57kAvERQrRQuX8fZF0mJUndlLQNQypvdAgKkiWTW6a0DczoHTRB90RC0xxU9ZHX7CU5WbdcH43OqWRDO8FngO/1/hZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:42:00PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
> > mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
> > VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.
> >
> > This is precisely a test for a kernel-owned or fixed mapping.
> >
> > Update a number of callsites which already explicitly handle hugetlb
> > mappings.
> >
> > vma_supports_mlock() and ksm_compatible() also explicitly bail on droppable
> > mappings - detecting kernel-owned, fixed or droppable mappings is handled
> > by vma_is_persistent(), so in these cases use this predicate.
> >
> > should_skip_vma() tests for locked, kernel-owned or fixed memory (having
> > already excluded hugetlb mappings) so simply test for those there.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h | 4 +---
> >  mm/ksm.c      | 4 +---
> >  mm/vmscan.c   | 3 ++-
> >  3 files changed, 4 insertions(+), 7 deletions(-)
> >
>
> <snip>
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 12ed3388ee41..09ff20c3df5b 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3477,7 +3477,8 @@ static int should_skip_vma(unsigned long start, unsigned long end, struct mm_wal
> >  	if (!vma_has_recency(vma))
> >  		return true;
> >
> > -	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
> > +	if (vma_test(vma, VMA_LOCKED_BIT) || vma_is_kernel_owned(vma) ||
>
> At this point, mmap_lock is held, there is no mlock WIP, so
> VMA_LOCKED_BIT is enough.

Yes indeed :)

>
> > +	    vma_is_fixed_mapping(vma))
> >  		return true;
> >
> >  	if (vma == get_gate_vma(vma->vm_mm))
>
> LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

