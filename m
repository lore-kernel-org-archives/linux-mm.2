Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC8A9CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A612B6B0088; Fri,  2 Oct 2026 03:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB7E6B008A; Fri,  2 Oct 2026 03:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8665B6B008C; Fri,  2 Oct 2026 03:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B90B6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:49:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9220A75BD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:49:00 +0000 (UTC)
X-FDA: 85276910040.20.D1E6458
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0D23740002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:48:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m/ZpHLuD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790927339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuJQjhi77ZVm2icnOLnl3Y2tfYl+LAIPkt+sFQXlE00=;
	b=tnCHtG3aue//Vr6GK2GI6SGDNaJQUhep5H5LfFVvTp6PZ7nE9+x+UOoxxqrkOvA2M8gLIR
	11e2FGh4F/v3tsl/JPonOTSNc91DCxhGhtEkIVhwtgfprMDWAysiaxaZcuMdKjHdYX+ELx
	GbRzU/eMQCxmXJxDlzi4RNjaa5Vt/LE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m/ZpHLuD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790927339;
	b=EDNr5fcMNL2ruHDxC6OQMAKH1zh1xUx4/jll9g2W2GxQkt0oGeqc4wWOwkNKY1MSXUH7/I
	gxsXFrP8XIT0aTGQYMMzWBLesZege6RJJWh11xxlmp0SIudXoxZuobUXy3TzXdU8OM0OE9
	sbxDcCnTUaa2dWdE9wRbdBBmtSl/ywA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B99043A11;
	Fri,  2 Oct 2026 07:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7558F1F000FF;
	Fri,  2 Oct 2026 07:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790927338;
	bh=VuJQjhi77ZVm2icnOLnl3Y2tfYl+LAIPkt+sFQXlE00=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m/ZpHLuDFIK1LoopTh4kNdvd7txlk1dEmXGio8sGjgBF+jhPpVEmgrx1I7J3QtPF9
	 mq6SLVvXjHAYq1lJ6wsRrm6oIMjx3WZJY2lu4n7AgTKI3GT+CaHdznS3Ig6YYEZLmH
	 H1mtYHkmiULRFS+3zuKn79OHg+OcKvLwihu2FAVMI9D/28vAGHBcdFtg0fZs8DTCFF
	 eAGYQUtI47QW+yGAHq0lXhwrbj0FJZAA9EbZh1OYmbfcB0giXI/NG0JyYP+MqhL0dp
	 25Y29wbqWeNyF/qf2ecRuYuvdsB1J0NTYKcl3Oo55gqurozPVky3Y3fXR1AyaTf/vd
	 F+V0T+fdyFJBw==
Message-ID: <202033a0-ea65-44de-8119-689e0df0b78e@kernel.org>
Date: Fri, 2 Oct 2026 09:48:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 40/40] mm/vma: introduce and use vma[_flags]_can_gup()
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ak36o7razdcs4nkdf4sabzqbqcr6foj3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D23740002
X-HE-Tag: 1790927338-310310
X-HE-Meta: U2FsdGVkX1+AGYIeTICj6FOFyaaeu4MQPmv1XZQuJ4e7kGlHUQUAJ6YW3n7jV89w4suwbJcXrNiE/St9/mQU6g0aZwwWVtUt95dscpnYZXsC6Rfw/iUIgA48UVlTjiWHiz/pNJMxiO1JDnIG4qCURoxHFchS7M3oiqsNbZ/4WKfI3jsAqBNtYTSVaN9aTEihfMBhGSjTjUjlnevSSWy0TyblWY44auCtJrz3krW6jVLfps4Ztev5l3hOwIwWJSQQuHf6vM+RbLQbp4bFlIxseKcz7V4ba+Aa6fcP2YeRe7eqFY8JxhRK6cI8EYlb1FZu57l8QyZYP9aZjm8Vga27m/WbcHGr4G2iB4lc9e7SFp3MVzjI+hbr4tWjmdQy9fhr0EM7yJ8q5GB1KoCFzXcUKi0BmZgo8mn01fdXWQyFlkrZ0oNdqxkIScKC7SHojPA0c2720dkgk4E/v0RP6hQLIz+3QfNYL6+NgyxpAPV9FlvQX0ndxCHSaz04vgxJDs0P06dCIrqFoiu9QXVBVXgD+K1hr4JR4rRe7YfU0t5a5GQqHdl2vxn6yt1jBwEDDRb8LWlPk83eRnNvQ+u3s32QJZ0n+v5KQA5MxbEhVvSrIBVo/gUfTbbfxsS0ePvbNnesZ4YqKvTO3vi2Fq4WHzypOlRBuXvYI87zQmn6QWgyjPjjHdZw7bN86q2YCq1JMoR/R6b0fj8vTW1LepYPgLanc4/H1ScekagBDvSzPhp8h41EfJH9nh7moHyOUBEQHJxvaVt4VTmroRxwz//Sx5Vy7JXH/SXR77V/ZBsWz9OA510U0ABU1pekLVXh5szpDqzvbLV/UjzstA4GmVVABPK/COvWUTFASiCwU8oNDsZBykoDk5zkgxrEpPse5sCJeTxODMn+98uvVsbhB9Mm9WRp6QeoR3bnyJ0zlqDjv9H0l1Ex9w8tNGZ3VhGZmZWAy1g3n6xUTMIq2Ok+8132pRS
 bSwHF46H
 eED0gX9V+3sM8k7fAvrRDmLkEhtBou5BLWEy8zoYEFRYjWJ+jHbdAINJyf+XKHssaGRxUcV/WkpNIP21PiAx+65RNK0CmD65kF+5lWNpeSjSDSywAzr8XyN9wxNf83H9AadVdJSTEOFDsdxISEK0nlTs94StHW12Odu4k8tbh9JrRWJ2L6auc8L6EmLfFHIh98klP/1xVOY7Wz7kckyYeMrNxVJBLDr0idTNWG73GyZS58CBbVJ2kDVA/wT5ZXwBSlmC9XxD4ougrLi5zLRGvEQ0nsjiA1baM3tr1Q0riT5mTOW3l8TONH/EVjTfN63KbZNPMT9lVy7QynGAWY1M9FD4OtCSIAlK8BXIY3a1mxxFcMNMM/RGcvSL3nXh5v2hBwLt2oPy+teVhSWDE2Ghief7/1tFfc7ov7FfRTApbzhw3Lisq8wx53tmnKEDxqciaRWZggAtZhhQ4/qcgaXorM8YMo21+UDyYRwdW09gkg73BPPtkCHbxSZTH4Q+4BNL6nTfJbQ9q3UM9OUMpybRvzQwhNOUOsU61THXxOVhc3c9i+QxxtTZaW8CnhOzNI0rMC4Rj1kKW7VA9oOZagxKX8GYziAEreHcxygC3bbtpLTFjlTuvopGhs1yLr1huUGtEa8/gm9Ri8uZAyNt1ldjhe5cDHypsxIP8lBOCbRoA1l6Es13uYX8MjzJ1DglDPYoXL+H65DTZSyNFoj+DwVmSQ8o3HuMzj6WsrG3C0m+hzqn5XtKmA27SvsFAUChirWhp9gKvXb0Cu8kCOgF2VoWnQnRO+kOiQxgIu721cValskXpRjDBVv60h5ChWT6+qj1LJHABM6Mjm2hJro0sqkHp9OQjGjZ0OYIv5212oI7e5Ma+Eose2GACqjtlfj4T0NcmhHp8NBT5AtFhX3z3/svb6VJDXinipQRaQd4Z+nhCH2mg8u4rW92MvA3G4v8ba4djtQZX2vdNLmg8QJ2CEef3lxtZF47w
 cU965kK3
 z+Kuetgntd7WhCJXBGsYPDRmzBuDt3LtphNwx/SiS6uw+UMokNvJv3c7+LKbjYI8u0FslEWOHk7v3d3v2IaKZClJ8l9HMA381B40OJpSADCrgFIfG3rcpgKXnWARH7zMs7Q0+uB/29WNJrd3+8ebrywy12R4l/3ElppSg1LuJieUXTDm8ofLv4oPTRfv7sCEN3aHvMdi5XQvq8LGC87oPZmP5fh3k/UhhacoA8Ty5oHl4Dt7QKI7KuBp7pAKZwVJilgd4gul4aAK4DGgxl7F75cTgJGS5g/AMHwKnnRRhuCj9tBqBjEeEBWEghDtjldhJLrJktF4c4ve58YQwCAeCnpTHi143wp0rE3kzGnhznKYnBH+8YKobLY+dtOlkHOCrDvVIivMcI+xVeZ0LftRYO6Fp4lSA6vvX/VCrqgMSpzhIWdZ/nuTFSE4VgQO1UhcPGTMG4fI0GrHoCU8RaC0hNsxU2TLnRzwNbmI5l280VrMasuL+xiGRVcJ2UflKLSmYYhbtl9v7UIgz8iEG5f4aQjeQFVNpHEZAgWKFoS8hPICZhP/Kl10VpMtTEpua6N/8ZX0DSs5JJuCfA2GF1VF7gz1bIPSCn+v2m4nQij5+3uutFs+T49cGHbyxSEZmRo4IqJn/dYx++YEJJJ0zEm5tkXT827Tbhoqlmc8COzzFs/1MeWy2WOKwmA/W6n7BWwi7+6y8IDTkXQDo11sFVgrfTqpMMZKq1vw2BYfn10FcJmTqEU3WADkfBCiQRukh1gXZ/SaE2Si/AMoTF0++JSJ7riMEwswBDFjh9uXvPByS7v869k5SaQGx9abaQg6EyHKDOe5njobxsHXvuP59EXJtG6gWInosnSPG3METcYuWOAX/lCgo9VTXS2diB+4JUtyDZeSMfm3RUpFiGIjFTSDQDYvaRtqxpqyTY+X3iCQ+aDMjZ5yQMnK04AoWKNRsgnKqFZFpUkLk1ftXf+b8k15OLgoGHQxb
 vm310S1o
 eUSwBjuTQsWln1G+pQu+F9zneF76pGKqKmezFNzYM7itzOFvDEgjKzAZhCHeSRKfEdwl14eOhNVtKEmzBZ8aTes3STndk90eik38FHEiif6j5AmTnnnH8K2ijpgqBbrSPCyk0l8RcGG+86MwEbJ7RSwr2d9x5V96sXedjXFVNyBUnKLTNhy+DLsHNKxraxcMp/kbt8N+xRQbsN9dYokcFmDQbbQ+9KNafp1s+cnBzCw/zHr1XnkE0U7RqlRPKIrZ6xvYZr3/5xrOhOI9M8DtLWxM/wSTwi0McivgmM2CBgRiJzEdhY/bWCrojMjLA5nXGA+h42Uew0Y4kA5rNnnb7H4A7km53g0vNI6BgfO/tvQo1YMJVPBCGAeqdLCPSkR0vuUVn2JJTkFyyd/Sb5ksis79P+mbIY9P0NKr924J0eydiwFu4IX3aq3YBIZD+HroEZ2Mz5myc0q6ArtM09/ClPdm+d6NT9pCPKmPon4jhE3SCsAuzdpRiYTcOOZyeguAuHOai7xhIRuBiHqIGVCHb70GkZwjY1HJLv4z30IuipjO7zUUSmEIAMEYztUi4oIsPhx468aYXL5vnh/uYpnmOQT4JVsm3vBz3qrCXbjt+iywjtp0kTTbZjSBKn8Rt7DC0PB2Yg+gA7k10Dt5uewaDuM8Ths6HSAKOXUBl5IuaDQxOfetmrbtr0YlONOQa7BC2rCwGDUuN7lHP/TY/MrIUCsU93r5g2fC3lmRQkXUt1X4kwzKOgzXct2i3PHdvQalvfbcFXS/tEsR/44Ko7ODHod9Sm6dKIXHO+n0spfzYm5UT/biV1pnM/kftilwxWyAB/hxb+iT/bLkeECmxzq0mlKVTzpPLVyP3kWKdxsVQCmY4rqeP6kGQ5GUlh5NpjS0n6Twki7xaDRfs6KPd5ax8I+qfIJVLjCHii8ERHAS3i5dNvplACgXrcUTvV1rn2zvnGpt2EjvWzENUCzqWncgx1fyYVxsQ
 uqP1s6bb
 ku5UGrFjI3SR2YJby92m8fD0o7ZCG2NrRd9CiDr9+Ji9/vaxnnO/a8CErjAWQojERg0HFo7pXFi0IPx67NLjnXWye6zcUQZ3dPxjJDmO3wDMZ19keWltwU/wO8C6NgJJJlTATNemQqMf3G/ouTjDdlwIXVoIwU8v4zZ+8tYUUhqaMaJAT0Iuz2p/05RO657PSQTm0aRbbXkpXPOHkvS1coox4Rc2vQfuncugoI4kqHK1IWOVoPKyddXkT2vhB3XmtJ3pgFkteAHHkorTucbeyGEv0eCFJ6PErKEn7YeyEHnZHJmLfV9UragZ+IrKybIm4GA2CQyB7uL1VArAlEu0Ok1eLo51diG8UpL1jY3i+iVV+0wnwmuT3u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
> I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT - because
> PFN maps have no folios which the kernel is permitted to access.

The interesting thing will be: what if we want to allow gup for COW'ed pages in
PFNMAP. We discussed that already, and it might be a bit harder to squeeze into
the new vma[_flags]_can_gup() checks that are also used elsewhere now.

Because GUP itself mostly already handles the VMA_PFNMAP_BIT, just has to be
taught about vm_normal_page() etc *properly* on all levels. I even have that on
my todo list.

Updating vma[_flags]_can_gup() won't be enough in that case (ignore
VMA_PFNMAP_BIT in cow-mappings), because suddenly we would unlock other code
paths that now depend on this helper.

Also, there is the secretmem thing I comment on below. I think this also belongs
in this helper but other unrelated users don't really want it.

Which makes me wonder whether vma[_flags]_can_gup() is actually the right
abstraction to use in some other cases that you convert below. For the actual
GUP users I think it's the right thing to do. But not for things that are
somewhat related to GUP (but actually different) I think you much rather want a
separate helper.

Long story short: I wonder whether vma[_flags]_can_gup() is the right
abstraction, especially for users that don't actually *use* gup but just want
slightly similar semantics (no VM_IO|VM_PFNMAP).

> 
> Rather than keeping these checks open-coded, abstract them to
> vma_flags_can_gup() and its VMA wrapper vma_can_gup().
> 
> A number of other places make the same check to decide whether a mapping
> can be populated or accessed as GUP would, so update those too.
> 
> While here, drop a reference to 'special' and replace a use of the
> deprecated VMA flags API in vma_dump_size().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  fs/coredump.c      |  4 ++--
>  include/linux/mm.h | 29 +++++++++++++++++++++++++++++
>  mm/gup.c           |  7 +++----
>  mm/hmm.c           |  3 +--
>  mm/memory.c        | 14 ++++++++------
>  mm/mempolicy.c     |  3 ++-
>  6 files changed, 45 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index fb21fb6703dd..9f729c594c47 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -1616,8 +1616,8 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
>  		return 0;
>  	}
>  
> -	/* Do not dump I/O mapped devices or special mappings */
> -	if (vma->vm_flags & VM_IO)
> +	/* Do not dump memory-mapped I/O, which may have side effects on read. */
> +	if (vma_test(vma, VMA_IO_BIT))
>  		return 0;
>  

In the end, we use GUP to lookup the pages through get_dump_page().

I think we should just use the gup helper instead?

>  	/* By default, dump shared memory if mapped from an anonymous file. */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5860a3b4dba9..1249e04d7b98 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1777,6 +1777,35 @@ static inline bool vma_is_persistent(const struct vm_area_struct *vma)
>  	return vma_flags_is_persistent(&vma->flags);
>  }
>  
> +/**
> + * vma_flags_can_gup() - Do the specified VMA flags permit GUP to access the
> + * mapping's pages?
> + * @flags: The VMA flags to test.
> + *
> + * GUP cannot obtain pages from a PFN map (VMA_PFNMAP_BIT), which may have no
> + * struct pages behind it, and must not provide access to memory-mapped I/O
> + * (VMA_IO_BIT).
> + *
> + * Returns: true if GUP may access pages from the mapping, otherwise false.
> + */
> +static inline bool vma_flags_can_gup(const vma_flags_t *flags)
> +{
> +	return !vma_flags_test_any(flags, VMA_IO_BIT, VMA_PFNMAP_BIT);
> +}

This only covers some things though. See check_vma_flags(): vma_is_secretmem()
is another case we universally reject and that is just simply incompatible. In
the future, it be an address space flag which we can have from the VMA. So we'd
want a vma_can_gup() helper but not necessarily a vma_flags_can_gup() helper.

I think this belongs into the vma_can_gup() helper.

Also, we should better clarify in the doc that other GUP flags will decide
whether GUP is actually allowed. the semantics are a bit vague right now "Do the
specified VMA flags permit GUP to access".

[...]

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b644..e9569b82a1f0 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -595,8 +595,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	struct hmm_range *range = hmm_vma_walk->range;
>  	struct vm_area_struct *vma = walk->vma;
>  
> -	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
> -	    vma->vm_flags & VM_READ)
> +	if (vma_can_gup(vma) && vma_test(vma, VMA_READ_BIT))
>  		return 0;

Where do we end up using gup? I don't think we do, because hmm essentially
implements an alternative to KVM-style GUP-fast usage.

So likely this wants a different helper.

>  
>  	/*
> diff --git a/mm/memory.c b/mm/memory.c
> index 6c011979401a..338fce99e711 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2417,11 +2417,11 @@ static bool vm_mixed_zeropage_allowed(struct vm_area_struct *vma)
>  	 * be problematic as soon as the zeropage gets replaced by a different
>  	 * page due to vma->vm_ops->pfn_mkwrite, because what's mapped would
>  	 * now differ to what GUP looked up. FSDAX is incompatible to
> -	 * FOLL_LONGTERM and VM_IO is incompatible to GUP completely (see
> -	 * check_vma_flags).
> +	 * FOLL_LONGTERM and memory-mapped I/O is incompatible to GUP completely
> +	 * (see vma_can_gup()).
>  	 */
>  	return vma->vm_ops && vma->vm_ops->pfn_mkwrite &&
> -	       (vma_is_fsdax(vma) || vma->vm_flags & VM_IO);
> +	       (vma_is_fsdax(vma) || vma_test(vma, VMA_IO_BIT));

This looks a bit misplaces in this patch. Also, not spelled out in the patch
description?

[...]

>  retry:
>  	pgdp = pgd_offset(mm, address);
> @@ -7316,8 +7317,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  			}
>  
>  			/*
> -			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
> -			 * we can access using slightly different code.
> +			 * GUP failed, perhaps because this is a mapping it
> +			 * cannot handle (see vma_can_gup()) - such mappings may
> +			 * provide access via vm_ops->access() instead.
>  			 */
>  			bytes = 0;
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 044ffb4f4128..2fd759e348ca 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2013,7 +2013,8 @@ SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
>  
>  bool vma_migratable(struct vm_area_struct *vma)
>  {
> -	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
> +	/* Pages which GUP cannot obtain cannot be migrated either. */
> +	if (!vma_can_gup(vma))
>  		return false;

It's slightly confusing, because we don't really use GUP (except in one scenario
for lookup_node).

-- 
Cheers,

David

