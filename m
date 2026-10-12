Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD17ACA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF71E6B0092; Mon, 12 Oct 2026 14:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8086B0096; Mon, 12 Oct 2026 14:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A546B0098; Mon, 12 Oct 2026 14:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61D726B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:11:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D68D71C4CFF
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:11:46 +0000 (UTC)
X-FDA: 85314767412.30.B59AF36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1750880014
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:11:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwUIwf9t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791828705;
	b=jh1BBm7pRZ9OtWaINwsHhoydX9vEux7GXKEHVizG2HleSAhutKyWONdipWlfg/NBpMR0Sn
	J8bpPxB0chQnWtfEcy2KdAswDXVvUkMZECZVl4vrB2krJmxZ3mh4CD9BRDx7Ef69GzdT7l
	eEnlgxv4lUVwL5Va2bj3GclH74zEI9w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwUIwf9t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nru7h3Sv5JaI6aGGCMmFY9EP6czcY0tZ0pY72oIj5bk=;
	b=RATFMcAYHGuQXbnfbd+3PFSkv8JbDgjVaZFL54qOKkawFxOBIItrbUdYHz/Px9I5jllngn
	jAiKBrXU1zdsB5gF4wYPc4coh8h15HNxPk17C/mQg58E5B2j97T6KK3eAPIGpWD2CwYYjx
	bvJx9Um+bWgZ6/jRgMiTmzsAlsGPK1I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA6F0601E4;
	Mon, 12 Oct 2026 18:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C6D1F0089B;
	Mon, 12 Oct 2026 18:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791828703;
	bh=Nru7h3Sv5JaI6aGGCMmFY9EP6czcY0tZ0pY72oIj5bk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TwUIwf9tGNYwZIY3Fm1yPDU4MTzPQZvX2/h7JIxyzkfk5eXfDQbWbnfsSbPbHnFqb
	 LjicSJy47COiVBFbpVCy6JFGXzEIJ0f/ZGnStnTNZvszexgrUMK9qHee5aJU9lSzek
	 im/JebuesdGjd2pwP3NH3XGqwXAxyF2dk/mjybeu0HMAgajsmthZ0IAFYR/8XRbSax
	 QYu4sPX7wYS1mmZJb0tI/WOLy9v5saXmqjpO8eIrfobNXWobyWDhWNgGpkmtg7xlXP
	 +NmTupCHc6jCf3Ulym34CpsgHe//G15vZKq3Lq9hDEImDN8W4h/n/dFUGMg+zaM9J4
	 XJEflFnpFAW0Q==
Message-ID: <1fd21055-a301-4aad-ae7f-8aa633804048@kernel.org>
Date: Mon, 12 Oct 2026 20:11:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/38] mm/vma: add and use vma_[flags]_is_fixed_mapping
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-16-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-16-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rt6nah5ek87ksxhntr1kmdt71fnnyqmc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1750880014
X-HE-Tag: 1791828704-749732
X-HE-Meta: U2FsdGVkX18Viw095G59UvRzwmTYKyFuB23+jl9JnYyfMWtgPjPAPxKvidgmtdMcbzB0xON9wYn7PmY01V+SUiWsgml2D4CitF2KB30VOY4Vt9WL6WFtqHT3aEvhpJOdp/rs+sPs2QpON2/GFmzSeBCbf9FZeOQ71obb7rvQ/ITg+ySnepRPf8MXW0dpuVJppcIwIg/lbaFTMWVs9dfKG6VW6Lg08CJnJKbYNmVCzK/LT3Us6DDuixbHwSP1SW0I0SMyd5uOf7kPj5WlDG3sIvtUA/VCw1m7Lk3P8g0bqn0lKjccAc5IBWWs1hGDXnEIMVA3gqhPknVsJlUyI19WWSRd+4UvLOuuHMslnwqUHP0WZ3Ux/0kiWsuSNFrU2/58AhHiPHsGRCR2X3HsGbnoSaYzmm1lC34z6jSF0oMOiaNxOa1l/8Z/jLqjCAr9zfNrLFu5jD5pX7Hcczi4cl88u8iACSJoIORpK1KwXwUWl97UPIqHd9DtP980LcUVRvdqQs6QQ662Secea2PJGpQE4hB5fDxfWcnTXx8JcTi9SnZxLe0R4+10mHlEFNd08ETvic5PWLkmXYbdpRe8VioDBvp0C5JjrB0JBgeXyVBIS1j3tvFS156MmfHCiwqIN4D3zx76H3vKY4dRBUelT7EJZyxPJaGMJZmfrZ+q7DjVDOoc7KQqSH7UxuREk15cZxSghda1bWdDOtVNDMFsIaemi7IRKXO3YWd+lKvT3rqk/lygmO7w4FqOt8k9wZkoAXFL5QpaSDXxCUJH1Yd+QK38Y+pkzElpqFi6Hs+o/K+iWfNImOf241hs9GqV/ZtKt+wtFXcBUhgkDC+Q5yH4GgNZdItWNeeLrx7KytqunIS1Cjs55982mSWQubHeU1B8iBb/OUhcOaFee8DEScJBQT9UyZvv1s6L/ZiUdFYvKGSIh/Fs/Xcn7j1lyPkdH5XzVV0dLNvoLupioPhYnPahmg7
 31xZhSqe
 TA2jmkphHitGHZGNYdW9iy+yfRzSinNUhLxcszhS7Goeia6V6nJFVzAz3X+3VfJBt/2tmSYiTQNetjLv6aTPreaVmFR9xAl5YSiPXfrI5mFMHty6ZrMykqz9jj6Er9R/ZdlHBaJDpxgrrRzsPVPLU5318mC4xpDqOqdQ9F5bv3fhuCkWOW3SVquSYZWWDvGigRf9SmZULrYIfX3s8CC/ruNDziHSHawV6PpDzkKSLIHZp8x1Eh6SeEpl/Q3XT5onnx9pOYxveeBzpFPAeT5zWPErc7DnBRIrMRZ3l0IH0nYEVdDpIBh8BHtuIczAXV1jpbUPPGJ8tZHXmDJKL7tBY1BinA2mpfcfn7Z+LiGOSwK5p6++9HrMct4ALbLe+8jyvnhAxBVGNzNKPW0Ktlt6YUEwb/GBJ+/DqBfL06mFRvUdbFqeisomPGy+ZnN78L0MQfXxvZZitQCXqOY165hwxhGFALpjh0cF05lkrEBNBOVMc8WtHJNJ8TJthiatqtXZnb83+9FD12J7uOBBUylUqPSJ0JxJQLuNyeN8/yeIwvZwGOyMcuopIW9goP+RAodfX9C5G8nSgZ7j54OGffSej+pAJ3VTeBu1WP5uJ8U4Qtzae789uSd9zYOGQzcJ2MXEbpklnVA/8w+1EbU5SAeuKFGjo0ZeF0k3/wbzT2ITZpHfXSSfOkTks9XoynUBWkIXPTiyP1GS7GpVJrjtAwha70Ba8VX2mNCuzrqXfUaDqnDh1o9NDuD6k+XxMOhLuNs7SX3NT3VRvoR7UtdtxM7itf4vJH38GgDwVpfCemzVtoamex0SRa9MZI8tCcWhAlzw80tLiODvUtBRxNXLNkTJNmTJcFMXGLCRb7nLx29IsWH2+riFSBHe88nZQhHcQTV7fEH3cg/rDs3Bbes2zmodq7CfZXiKcaJhHsGOGEM82O1EG66iB7WFUC04fW8wz/LRJabg9RarhifrPAwJYOK7kv/3YzxI/
 pEsVJSbq
 CHqjFYjhMkFRZxJnkXG9iS9Z7tim1Kv/2UJmLHw3UioKcQnL/eB8onFKmk8K6VPHdd1ziVCuVvI77gHrS/aW6izpmi++bQ81vuxP1xYuL8AJQ3KE+G9w/4iZ9CvYkiZjvRlOgVfQ105icW+ko0NZo4d6iPbPrmc2ZsqebvmNt2TJeWRRLwa4gkYiTjucB+SMNQCtMnYiUwvRSN/URRHywD8wjQHNGZmcuyg16PkchryJAPNxm6b6sgHSml48ynPTQlT/31AkuW/rzOnS5Qgm8IcrCJl/ijHAKvztfRto103xrjkRHZ8hzoRVaWi/+BkEI0EuiTh+fG5ySkXXH16XXW23KfpyOAAbOxTjSPDObw/pdlDfagf+EHC1SEJzyubvN/bRj5KE7lzUlZnCn1wcKTrCkTwGf0Byj4D4ElQKv/o+CR18gkOe5VvCImpmdu1n5VqN5uac9jy48CEFDzhQJsQ62blmZGm9fweFrIrSO13RXnK+JRXbGNx1MUSkDIxam2v+kIlRxhJEtsdlnTrxwSx1HLygBUjDqfcbPfBsiV/BakCuKTudadIetIBCN6qvm1rI3Ja5mos/j2KmVn5q9DkHu98Zuqea0WYY2J5b26XFcRHI1C7r03AgfIx/nBgc/klrYawGADAw0GPwcpdCNOtsRMxVmvJPTcdaheY1dSxCfG3FDf6acIwELSmgEqR+Bq5I/3mIyYXrE1ZsVMxBYgphKjrySioWCMLnmc3S3GgwFEKC8kFu1lL204dhUYrUT1ae3yfXmzkTxjyG3qg78pKrQuVuH5Ys0LCIASAU3SljwEx9C+oW43W/edc+3hxEsPxz6p5OHAYBrFVAva04vtIINTf7vx9v1heYmLDg4jAJ5fTCU8xhYilkrLlStSvedfZSp0ol5YEBDbYMDXOJOHeEpLBQLoYqXVnQkS8IUBmYlhrUZNROQrMC6O43KW2gycCmoFz+PudZUpP1QgzeuUzgo/soB
 yWbyXL0p
 RrfQkgW3ypORMwlEsSRsCPYEgTrGMO4HAu7gmhgqhC+IIUziBN1kgXVOB5koxM7WWW/tVggk/k1+rdKTQc/z8cqD0+V17otsGNS7dlKhBOyMBmSn2/myHZ6QlgLqmFtsMJbXfXWlWllyBsOKl00zb4cEvWt8YFvQ1ClIAMnAKMaSQ2wupsIX6mOAyW2aVYYV22LneGPjT98Nc1cyznbkjgHfY6c/yn+jO6MjGI/fiUXpnw6CGhhYmoeUuC0DvMO17l8CZ6z+5dMtWmM7WOC7rDGWpsm4etbcne8XxJDOqZ+znyDSUvhI7klBGmrhvwq4oRr6wSuAcvfWcaVKJfZmM1gRHcq4iCqneb0DtQdn0pKib/5LjBZ7Qq1tHtzenfuZxGO+beqRT1G+ef+2pflqLgoqc64Re0Qi3EyXab7qvaaYPzaNXfO0Gejb/NpkftKRvSrHRyRpGt1ybw5xT3AZUBdZ/jEjHQd3kWHKjMFCi1TO7TPHLskRWa0gEh8GUojoDgi8oqaZX5XLxFXB1oZ89DZ+hB8p8h728PeSpHqNq/cCsD5J/q//Qc50Oe3LAJolxWNxf91TZgmVIWfPFPx4ROk5Ug5dUGf9EUgJj/BA+CH08OD606xA9rym6NS49fzXsukwYH+tJLooDKeGfi7l1qe2HAnVLFVb0JoOiLuOqumQPK8fqIrVVRWlZg1NHnJvKE1bVbkMMKx/hzJAmJ22ClqwYiji51BcUxwqvKtZ5dXndqHEE/J41sxkgg8vs5rHxZWSlaDA62zljrhDCr8YneCos49DX6MU4g30YaW7/naemt2+tdZu+tqlYBt2dafoWGDrxaUTP/xIirBBUSumjR2HCoCx5SkSsW4mjH6Y1qyllqUPDTcaoyHuF2lO8ShLwmFP3ydlwJvVFSha39O+TGzTZ5Fe4I8lOBCCTIndOThKVldUeKyjAXhj2m/hpiLsfLSf8uSYVpoC+g1/9qa7Cu9MywYUD
 VYFlzQ8c
 XVPyK0iw3DdWlfvCnrZ93b3Hqpr8jNULkeBK6tYCgxDBviU2m7FLd12h27aWFzB5O2rxUNt7R+THFElNtEV6pDXh2sMLtewbe9cFe2DFv087wUsChcItVDdEVTLITqlzF4st8kODRohf6s4uysUutOUQ3MK9lCYNkDfvE0quZgYodkIFhhM5prX5BsIJ+yTd0XsQ72803UmPJqitmphQg2fntnRIKie/aIT/HRuqoQVGJxyQSXLO3abNitVrk5HZ2PveBj0sPrD3XlYAJxKQOUy1xhNX8IkVvxuzc/7DUT6Hr8CQZm7XlI00V/w/iIWhf1SRTj2V8I7f8xQU8/2tTbwumokN13dcuCdBx8DUi9mnhy5sGchS/g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> This determines whether a VMA cannot be expanded or merged because what
> they mapped was determined to be a set size at mmap time.
> 
> This typically refers to mappings not managed by core mm, however
> VMA_DONTEXPAND_BIT
> is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
> must explicitly test for this for now.
> 
> We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
> set for VMA_PFNMAP_BIT's despite the one implying the other.
> 
> Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
> mremap logic testing to see if mremap() can expand the VMA. The criteria
> for khugepaged and MADV_COLLAPSE eligibility in
> __thp_vma_allowable_orders() are precisely those for mergeability, so use
> vma_can_merge() there (with an expanded comment).
> 
> This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.
> 
> Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
> VMA_DONTEXPAND_BIT.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

