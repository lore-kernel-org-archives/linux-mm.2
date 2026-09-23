Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AA5C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF3D6B0088; Wed, 23 Sep 2026 13:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C604C6B0092; Wed, 23 Sep 2026 13:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F6E6B0093; Wed, 23 Sep 2026 13:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7906B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:34:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9DAEA6CDB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:34:12 +0000 (UTC)
X-FDA: 85245725544.11.6606A46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3FC051C000F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:34:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oIPXhDnn;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790184851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPlu2H6XNVNAm+eyKaf+KNtcUOLDMiz/SdRoD9k3csw=;
	b=marm4Eo71vHWsLFvUlRLJDTlX86Va9nmOiFOm9lDn3qZAxzIneJHh93DnC5SCDem43Oynq
	JJUIJKuuufIk2ctu4yEYdZWzZ2sfBl422iipTciVq3WIFPZ/j0V3sviDuXGdzCE5UdV6Dx
	Ob1bTx/w3ITofqWXgyNXENZPEiD96WQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790184851;
	b=S1JBDe+Uhok8t/a3Yn79P6vl0TcY8QPnM3helCiPpz2yUdHW/mwcifWTvTu1W87PrnbuLx
	gagn/ExZVO3YwDIuIXD7lQp11mqO36f0AA8y9h2w9tm+rUcXHzmBt2HAHI+GPnB38K707L
	Vh1kjAUsbamD3s5rhJq1gzvBKUMUtHY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oIPXhDnn;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3A6F602C4;
	Wed, 23 Sep 2026 17:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7578A1F00898;
	Wed, 23 Sep 2026 17:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184849;
	bh=kPlu2H6XNVNAm+eyKaf+KNtcUOLDMiz/SdRoD9k3csw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oIPXhDnn6KrbHUdB8J3HtxFj0acE8ktVqJkOruOhJCvNG5tAAVxIsyoHMYMRieHKt
	 Is5+S1MolM3HFRsMb1jGHJLJBKDKhutQW6ZfXT/uIcKRR1r6PUVXazNarmpYGmlPd0
	 DrVxZDA5/RDFBx7/03GL1IZtxQpOt/AyuqUyDXzSfV+fX36mqbt0ecrQoeMZoKoF4P
	 +Cw4hzzM0pyksIgfNEY/yt9LZw5XVPHz+WoNZuUa2xzYl1ssIwnutkaiQTvVstnnbO
	 sloaQyC80Sym14M1BLGJIqAR7U69u/36OLTFb2LZOlo2vRK66xJr47KsIDUd4H3N/u
	 MIh65qBa71P4g==
Date: Wed, 23 Sep 2026 18:33:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
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
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
Message-ID: <arQNTibMdh6x_T04@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3FC051C000F
X-Stat-Signature: ue9nbqwfqw943yxupmk4nfopw1c1aetr
X-HE-Tag: 1790184851-503823
X-HE-Meta: U2FsdGVkX1/X29Jsht6dgP8utRAc6pDMVneFny12FT8WwklRwmvqSJylACPGb2iHbBPxYxpgi/eoYVlUKfnPIKX2McxG28jlJ6WCKkNF27fjdo4q6AbEK0x3okrhiSq3mSkhrNRHofQrbWcjNqqTNcWM0j1o8fpviSsJ6LtIF5m0cJ/3vFy2vi/MoKUR0FTRbRImRkj8vr9Ndcf6h1bFQyUSOXzT8N2DB9ew/+RyDP65qZLSZcbmiRBF63YSHgPUAN7nZda72jmzO47K39hfw9UqZfjBKEEM6wdciiaoyAk1i8ARTTSkRXbjmc5R7szVh7a3/AzT3Hgki2552s4gs9sCl/gNu1mo6/dbNJEOC3wuirb1cJQo6kwZaxkJO/lCBDcN+mMFz4IXv8k49JPeLm4XkZeOxtVCNGtOBFTc22E8wOaFQw89U4nmINaZc9K+V4c+gYkpGoKjHgTUnv4ZhCMfT21HXJ4IVlAN1a8nfZYLYra8fI5WSW+MYqIOYzY49indHGwSxpemZB1zvthzgxvPCL7XZ3ai6dueZzTELdQdmuS7IQiTi64RtqVtp3c7djdOeIAWUEIv3W2fN6O6TLphsVBnY1rLI0W76GEbGbxSIkAREx4IU3BzokjJTiPBr38vbl5Hxg8YqoVWxDWyr/yoN8Ha90SWl5DSaLLc7dfVSko5L8lrjz2QJxGyC6D47yLnRn8vKK8NMLH0vZ+iJCKQWsRXW0itcLa81GuL09O7zLP9jLndzKPWy7ws83e6WE5V4KWzCFBJoEl12c9++2jNiMTqtghTa8y9iiKLnuZRmzxht7VM8anQcY4Z8Ih4CtqxggwABwStZitV0Ea80JAJGPVnCYXT2czv7cuMLQmLEWgHl2ataq4eqU2Su7IuDMNMOw6WH2xPwuiJjcazj5k2rESRh+camCQLI3m509B3JaZqV+wPJ/JdhZ/MURKYLuDLVbHlnEmzf/syXHl
 pmysMELC
 hMjZKQwFHAefotz6HblmxLFHO5PgO13wwVS8SwzUHUv1ddJvvb6w2PR/ALBy9cgRHM8MZjOu1jtOQt1cSfVTA0cmNFFIVfcnEl+a1VEkegKmzXGpUOR4zbX1WZ621BDAZuqJpcLGl1823Rt4hZORA01n720bhG87VQnCu4Avz/9EFunxa4A76+pb1CW4sSuaMebTCi1F3WG2XHrS3Ynxno+t1DYguejsiwCG7TWdyyC1fLTIZWXBqi+qjESnUl/9Bs+QjG2ktbXuH/LmIFHjFEi/uPB3zaroWv1RJKTQPNnH8dgMp7boBxHShZLuwojrLjUlNPp5fEYzKlCGNl7cM/5ZZVPK9CrGl1g2AEvITBeMepQc90c358oFEX7VE37sy1kVRn4+wIsEtMezvYVpkmJTBCtnMYSgKvlWiu/b64YrX2vlvFGYeLF+AKiTMIl5yg8l7W6za7MXgYL2mbvSSFuQ/3aYuvhcS6YYmmlbMQtKDTaVKuO0PClzxr47aOhU1NAccP8V86HkiqikIJ0JiVsjRlbdQiii1fsfPeFDckQydoOOH9LdCsMQ0f8EKx3V1PMNmZ+Dyet/Xn28SLxuS3nYwznwq1qIXe+vlYxsQkdgkUeX0ISmXPbf/W8/4akjrm0jL4RGlGANNgzsAa+VOXWxi6LuPUHWVesYk8/lc3EML0dbMhkNiO2jQy68oKVEnHtBQhX+vgQGJ7L1Tpj8Sp6HkwHpbwfvM2ysafoKUbl9e+QByD9DFgtD1uhNtUI1u2quyj1slff6grMnFT7BRZdd6/r4IXpW+FJ3xAOqOlG0eDcEasl2tekPKCSR3/JTH8A/MdIzIoiQHZAJiCO4azNvHyawv3nq/NTvBdClp/VPg+uLT4YxRP51TYyIjHiG3jTKFCHdh3qslCq+p2COVL/UqiJQKbpr34I6oTiCVBYcPfH9e54J5mcGMGJ7JoGM8G785oiw49vlh9Mu9jzo6qMhlivtg
 Yyd6wFbM
 SLMgtoj2JGu1UEP5S1cfB+akcltZe8tQH/BYM44EBOuAcKLQEqra/DEpvsAMBp0ToDDvLdiQgAB6QWrTDZtxVbFo8CjYFU82/iMeM9ojvPwjckUib/mli/EktvNS3RYQyVi3C6ziQqHObrsiuKtebvl/Jr2HlIYM+sybxAD4pVz7bEMvQryVgQZ4qfbsWWsYrjXy/0jH+7KRplzYCMpaDJBjnpRAV3xvG2cfOtoSuXKH40eExuviC+SY3hPSKaGuByLU9Pf7jyOqs4uAtx0UV5ctBTuFJ17yx08DEYT/yrb7cPv501ztztiZvEoytMzL+HHfE+T4lVshd29dp6sm6C2Brl48HZcYb699y2JnyI2bYjU3gJDSN8icyWayx8iYt1+vyNwt2aMoZjFOnces2tTMQlXdLakDG9fFZetoErPhFtJGG1JaklJN5qzq/hJtlXLYcxrtWXkAEaCvzYJaLZQFNrvNUIrFy4G6U25KtMa3ANKuEwREXm6l5/kZf3V8pqHSGvEF+CrkHQxWXNOM+Kxa09UutR4fgaOs0x571YQroFobBevQ1svQy5Ngw+AS871BF9DHzFZHUP9uiD8et0+tjK2qnH8zGkCZDls0VHHkK4pPV+AZZW2ncpH0lfXI0o0qu4R8tbqv/E37oGc1LFW+c51D9EB8QlbWOl/Y1qDkfJ1Wqzq/CJsHXM+145BdyCY+3c7vbAZaumYJ7INCczaPFryt2FvyT9fIem14+DsD1EwJYWC6NOzJbiY4XkQ71fl3aTg6c1/waqYKokJ78NF5gETqqv0De7cOPaQaW4DNzQP2VB0VGT5v2iHeo13Ksy/N3mdMP4mau8hotCc14h3tqyG7qd3OkAn1s1eqyNtb9QqG3IZxJ2NAMB0UD3SpcLNgj3rU5cwxS7tcyCJcF9YiIdHG3Q/KBaUUpFbpzTUNnPWJx11cqO6GqE4q6am8ihsiQ4FWPNkr9dNzKUZs6Y2oq4Hft
 UAZhFDqq
 TKCDpa1PGKtPiKWY2u0VwNO8mwL3N237j8siUdSuMZFIk9tpO4sibTRpqaTxbSYRM6hCTdeYAxe65nvhEq/b8gI0tE2CFEkYAp/gJbIl3OvZk+JOSPr0WnRCPBA9dCRJAcvYj+42BSYTb4hW0WhDUDUIjxzOoSHe20M665RErhG6FBaJ9CaVUOBnSCPoAXpct0CKRUC3nEeiWM/kf1Yr21Lw8+U5ImFgOn6QanpdzaF2L2rmq607jvAZGuY0DLZhsNt6yObtp4G43tjuxsy4ysurZKDojFyxSYMnFmWXx6DKr+JXFym9VNqXsBPY0MQJxiYKauK+lnpKv7wuyok+yW1Bm+7Bxbt9G9P6gDoc1cnllfq1FGAe2/rqWdydvDk8v8h7nZlP7+T47Q3EY3PMZUORY+UCkdQcOZPu/4q5OcNYGRjIq6bs9WGSJxmhIj7WCzCO+z8C4KbvNWH55q/5r7/fjPjBjPtSOh17s0QbuPD3Yszm2UDOJtakDa2SDPxVpTL4ag+x8B+6/QBsYPIFXIwxgi7Tro+FPWNbPBC/Jtmwf0/NXtLjOj3KFt0DOfiSkvDpBUiJZ8KUa01O8Jn26Qes4W+TTxYCwW8iiupZX+pJNHGxSpF3dXQ/YT8RaQ7/GfYrutKYb+KJUnnBKhh6W4PHm1QwGIzHgC2oHwE7gyy409xievqpEXN8LBNooT0+7B0drJQ2ix4caZ8glxU6hxj0YDAkbDtol1fiaYfYNNceMbxmg9hIvqnp1zd5ckLJjvc6JJu7LiF/SXAYV4/fDjWmuIuiS3GZUh5MC4VwWyqBRs95ko7+7FciL9RhCufhjIcFgDWQQA+3UR8s5cVtZB1wQHNp9dMsJ4Rsr4pjX1PjE8T5GE+fyECaCuKJoBtCX6kmcFAzCLUCSEV5Yd/V9ce/hsWdyVBkBWZYNyK9MsAaIkeIaSkzCsHLg1olD2nUy5kqMRUbPSJoAxWOZik4wxKH3hTrr
 l4QQSYsw
 +oCJtbllYQNaoYMyXkstQV23/dGhnZU+NyFdvnTTT0ZcKp2M5Igclww1CAjuMJ33mwF1spNMERVVmVV8xRoXF6Ii+zcQhhSy1GPFl+wtbIgSWaAGNSnbbGlNJlORCWevE6pTr32IVJLHl2kYNP1fCEYGNdEehapenBZwjiNXEJ9db20WgEAFvvIKRQR6/QPU7Ede3eHrvBgQPMF4ToKOWruV0PfjcnralXTsUXjB0nNhdfFKZW9cmKfCX8r5OYVk880xuCFmSsa1C2CU6r4dQAa1rq6vkKm54EzqD+NkiqxbCkj6PQ5FG6m6QVKQvWr8sy9r6XKkVTJBGRXYnlpcxR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - please drop this patch from the series, I will send a separate fix for
this to go into an RC.

--
Cheers, Lorenzo

