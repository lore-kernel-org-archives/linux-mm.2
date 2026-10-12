Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26C6CC6B02
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D0A6B008C; Mon, 12 Oct 2026 14:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63606B0095; Mon, 12 Oct 2026 14:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B052E6B009F; Mon, 12 Oct 2026 14:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 828AD6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:19:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECC838137A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:19:40 +0000 (UTC)
X-FDA: 85314787320.03.9B72696
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 20AE420006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:19:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K0zgfFEo;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791829179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5YZV5/Gzxz8OvyMdBctaB65GhjRf5UZXPrX96RovJk=;
	b=CpTkU8/psQ2I6uVvl8D3aweDOW5qbTz2/mNNg+t3ktMOOtPZwGrXtBiVE8VXhVulLdYRlc
	m6/fIvgPm+jx/UR4LXK1Bw7OEeD3V8PmpljNvgH+MeI19Eha3fWPe8S6spmujaman2Zlel
	kCDzwUhJ/QntESAZJd8vTHbv9Ul8QyQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K0zgfFEo;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791829179;
	b=A2cbNQZSUZ8NFnN+jHS+2N3AuOgQFdbZa+KtvxwvG4JtJr2Nigd1tQ0yIUcldKy8U4eew0
	sJfLBAvUsq2SSAjhx//l3H8dCFDDY0MN/6fUGgbyP9HviJ67hDV24WsPZVh2/P6Ds5b25s
	vTUPph2URoBR4f1W87sv8uwarjpILYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0795C41AAD;
	Mon, 12 Oct 2026 18:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776121F008A1;
	Mon, 12 Oct 2026 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829177;
	bh=S5YZV5/Gzxz8OvyMdBctaB65GhjRf5UZXPrX96RovJk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K0zgfFEo0DCNyJ7wXXNAtUB46Se1h+SZXZQPeJemBtFpTzbbQfSp5G5oZ8GTdldLM
	 MXbquvQSvxIUkvzRI5GlEMD5x67ODCTifaRqV80gcXl3C4LnqeTjgHUYBaXToHruFk
	 RfjY3g/6IP7W015WE+bNESTYURuWY9jUJ8i7PjCWw3HZh6XeHu6oh/3E3uAUsENyAr
	 BDoFWSQQYfGPKVZaJYTOiQnAkya+mpNubID9cF4KOyTbKX/c5kud5UdMBR+XDc2osY
	 BCONemdMlwywRdie1WLtCEhwDC+gz89qp0qxbu4FjCd0DKp41FMXYOaWqa7vpfT03h
	 20A437rctccRw==
Message-ID: <5027aec2-84c1-461e-9f74-0736e2cc6171@kernel.org>
Date: Mon, 12 Oct 2026 20:19:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 22/38] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-22-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-22-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20AE420006
X-Rspam-User: 
X-Stat-Signature: trsr1yg19uy8drep3q5zejemsyw3p85t
X-HE-Tag: 1791829178-756176
X-HE-Meta: U2FsdGVkX1/pWsublSPhvcZub4yM4MLDXdbiLvEcmnwLSXA/BBpc5Pqn3flylUjYXmR858QuyOmACwYCTkzP+Z8evD5QRoNdw3Zdq/tAwnn9CMkp+H053wnNejerxtRf4Eq27ZJ0/wAIFbrZwxhsSHtr+Nx8IOcvrVtcez/inf67liuumlt5TjjPkFjgmXOi/HRzPpNbHigtNiRozjPk/vdverdkG/KqXU6Hs3iefI1uzzaAWva3LkDcdQc7kCZepo2MonI0pBsZUFUiW6vJb9vpYXTEeCOi76Sz5Z6UxjuUFxD5PAyJGstKOvQwxPV0S3cZ3RicMgdgnBfq2DjcED+tYPErByz7HIj//b5wiHrgdhHj8oizC17H8EiOJ+i3bSN33lrifabXR8R1nmtypRhvKsBQX3yWKiIYlMRT3fNKmq76CsvZKgZtBFzwSFj1HjR6JgBBtoE7mmJf2mdzaaNFw8OQjB0XcQnzxnSBoOz9J+XLK+CEDjm4rHcUEYzS/Vip3L6o7UlHt1sBuX/OQYTGr2yPJzKORrXs7xNaV75bxgS78uVHHBGERVD7CKFe35ZGXYkgVZnZy0XZcRcSF6C5RYaDYvDXIUP0SC3h+YB3iTT70Qh6QOZ7UhS8Z8w3/K1DPzZjH1fDLmUkbUCpDiNC2WTbBeuIP8IXjIQhWEY4VEH2i3fwQ9ZDr1ngcg1jQy6opAdeuYtA2y94sfxDKQgketXajjmpRoahcrcgbc7DFDmn77MgbGPT6foEPbQh38QSmCfa+Q/mdM9jtoUVdYfxzLPCpiGUtqc4GbZb45C1rtGJxX70DbZNTuf0kKt5HM2nTKuoh9YTBp0/8dCLmhVPnP2DMOdzhKNzgsjYa6W4YjdWGdnjugwBcV2p9ouDG4z4cFSwJRI4G3o98fw/osgQ2nOR7LgaitvvtGkeNN8vLxre6MEh7bEXAgtEeUNlnMA7ChMlFcMFcl30zVs
 sx42gytN
 rY1AmNQ7YnF5GD5XUiMrUo33nvwMABhXw9OsbPh3Xx5nahYRDJuYY+TFtF8ob93KBYl9QfhKR3wLCp7iMmYIHcitgRwzSe6caKL3Pt4Y9yDB34ovcwfveKACqnmQE5slEGA/90fTXZIIgJZaOBvlXBO5kqtxXnRZLCxzfAxz2IcA+wJgI8Cz8UVQXCJnKxYarnSS4lJ33SWHpC7WL2lGTEXYfFeVzE9FLf8R7Pam9iS4sogpwiq3lJ0tru0lHqyoJendHGaDk4E7kfJIZqfRGAENNt67PyVOzHObDxIyY6yx/oy8QHBItPClzdnsjZdZ7IZY1YYaVlJo8Q3UhrWHRr/Fyr2xyZ8D5L/SKijgtgbuo6podT0zMubDlW3e88VJzLb/at768/FyrvoRv1FehnPR54QOU0hnZtVnGBtgAMsV88acOtRCrdpEFH2LLmzAzo08I3K0YIvx/gzsSkpA56ojTYmbMlTJ2w9yHnWMg0Hi+WP8BoJZvVfICLqEK48yrXOyv7vihcOcW4tL7l7VZq0IVnqQJj8CMZm2XohbUoYoxqlckgpszjs7FgQNlXmHqbxQkVZVkrR1R5jLs02eSuA8RcGygHciFxCJW/qIfltRhNFU4jYar85ksBYts41ipYFs+X3uNWlInvQb8xkV05Qt39MPAv2Fs7F/Wf1vCOAhcPWmj3PyPU+whKg6tzmFMfb3QEOX1Q1TXb8gIXqirQfmPOAsNMCuKWYtPAWgTFIe3zeNOTBnbQB/rqSPKUFaa8TWtQKR9nCte93GczCETbvSnE0lh3Vz3A0V6yAzY3bruuwGBi04hJekUl2Y1faKfZ1iPiTC55DkGw4C8zvAH4gJScU+5mIjnx8nSt0kh/ORGKklYptwS7N2f/71XTLmu5kuarUh/ymlAEX4O5bPM1L+JkznvD3EwBX7jZ1NzwE0huxOkcqJ0ZgwY9YiTZ4dnTFI6Ul/w13a68jR1vCvPmJ1aOiCM
 pXXIXIVw
 Gj5zUKWD2W1cPN/O6rl/yBzv3Cbxu3q0YoJgHgv1e/G3Snjpldq8Wj9t2UNNGQ6x7BsS0iyMyrtk86LYp3xnnE/A4tp1dwd4fCv25UUN7i5C0KoaAqbYn/Mz0LadIkOjc2UTmaJf98+68fArHkQUyQttpeCE+mP9DKx5HhrpzLvSAdj3A6zow7Osa9J+AQU+iQ1OcuS+wdS70+puW8agxWzP7jYsfNqnOZ5z4Wn/bRVnRQK7v/Q/juwCZfvAXmcfObU+KgBve+7I/5B5s0kFBsl0+y9afosGol9Qbjuiha5N+Sf2mxUQa9ho4zMMuSFLPRQPYbxiOBlgarF2Q9COxHbzAnX2RPQGW7CrGkybErfl/LnfFJ42oWFhPP4TbIg7d7NYHPf+WgkBtfXBE9e++V9QuEZjnWJOAZ6MFoeE2i4acYK9HkMV6qHAu5RIxXAXLUFNwjqs+PYwf+BNS7MCU0ShLvlNam3v0uv8nwLVCfgkyaMOfJHp22aJK3ddGmfrbxIZBOue3Ti6peI+SL1IPrcz6mARIXumiuvDKpTwTox8gEsplxgr8sEr3AT2hgEYTbANBuBTTS7dYKSUriLfzMFH1CP2eAeZGrS2c2AP4wmZP86pFeelO5Qtqcu0+1fQfkjxQsjGvzKcVBHFCUj4uEdPuuTYXXFFSKQZYi8Vzkj1xcfp0n2yD2hvnppiaABvNVbyYxTdTw1OMiNfBRGmPPPHmtRM/UJqCiPeZ16mABz8QGU3Vo/b1UmhBlkgTAoP4vtBNaTrppfKLQPeZgiBx251PkMiZTVK2bm61O24nKOGzImETgzvxen8hQpktPFPqbiipjIBnsjNOE1LjFmt+rWubriJpuQK178BonUOZhc/putdUwBQsvU9FetwF3sYCegD9kx0M9U0EdHn3fBCONacSrIKZ946jMjUlaCbi5HMAcj28xT+rPTVASjceSK29lETQ9it9DyDsksAWoUzsIcx6XRL4
 aGnr4xoT
 uqknOZEFmdRF74ngwsdlZTycKI1aoQeYl4xEPrTc01B+DnJSMf5Ff456gYBySBIbFp6PeVVDfkYVZjVZUbZRJOKS5K5x3a68+h4S1AfSwo319sU9q+HcirBxI3t1K3aziIW5ZIdKm0MMEwNLmnyofawdpU/zHJZzqgSuZDa4NKPQrH1OiZ2rViRogQNcpKOwzZ8SKnflnyEx1nklCKMoxstOKI/2VnfkYT51DjaKuJZHHTTsAKnkRj7EcFZUmdj0BcZ1J8EuB0pfNJpBWa8svTN5nQwHYVRTLN5WutDImXTQn2Snj5VRGNN/aUV1ek0tGB2eEGfzjcw21Z+tdPvAP2n/Ohj44m9Rt0CyJB+dveGpx6mCJTDRsXusvTg9tvip0RaCgEovYtIxd1NJQpRLHSHDg24Ux/PZiOUVIFJTNdiZbwVwcWydb7cyWqtjEdv5o9xbT3kNBlVG71Xsb6/2Wf5wx9UN8sxrXlH/dr1GdWga686EpcKX7huL7kLmCX1HtU/Fg8eCQdue2noqaCaSISShUzkghdXSHFMTirtq1Fts2ODJyz8qmIqqKKxNfGt7+ycpDP8pNNTwTYB/c4xYjzr23cwvhRD/7Sv1g90N6BXX/EULQJGY2UneGm9/7hVrlUpYQGVAHzvvoaIQfCoaX2uAnGrWUcc4WFzyZIm8zOccc0q538rxCsmmXLyIv29N+QU9/VgsVaOKpYX6Mn/7/eqdhGD8e1zGrmDWpPf0+eQiPOI3v26uzGN8/4Ashp6EmbBqKp2N31hrN7Xey0QLr/30DKjHijF4gQaCjPvZtps8KObT1690eWN5axR7zDTik8xtdDS38pJichVp9Xu8qaklha4LICLGRaJAzAv4Bcfu/PhMyUrztgdOiA/vVlyFCs6NU3iMgWkmI+oVWj2NcBCUmxpgeJD/3UMq4xMBMqGUjESj8T8RHGYDlwc55bLR1XBiVlkkNHSDCSoJVgWJuh6jiuBiU
 cbSvfep1
 ruCx3q+Ffr9+Po9gKcLtIZkMeukOnYhRtvxES/LubJtn2oegKE4dX3BAkm7QqnjHZDTtpvGb1qbBREQ5fBJG/G+UavXbV957JTjc7zCId3XKQgjCfVfVzdTL0jCWTU4X4qWO/OIWIlpLg8Qe+iMOgDxkiC5C3XTSWw3sMnXuAxW+fPMRtR3FC/iLq3IoPPAxZV83DvTYaWK2cAnv7tFjA2w14AeNHPitH8TBR8st1uQtiX+az5zlTzCxFqKSC9r3fUKhRCUKaxKkBN2v0jWDNN0NYhst2NQZSuEsR4DtGuuswVs32kPgFDO/72pbPznclV49BsbsEnsKk03y+SEIS2a1McdkdSvESBVnGcFnX9i+qysODhEeAWts0IiJ4ibEl7x+V0a6Aktg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> Currently there's a confusing mess around VMA_LOCKED_BIT and
> VMA_LOCKONFAULT_BIT.
> 
> It is permitted for drivers to set any flags they like, with the VMA
> already possessing lock flags.
> 
> This results in the absurd situation of a VMA possessing both
> VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
> 
> This has resulted in mlock_vma_folio() having a very silly check for this
> scenario to work around it.
> 
> There is no need for this - just clear the flags before invoking the hook
> and reinstate them afterwards if they are required.
> 
> Nothing relies upon this being set during the mmap operation.
> 
> mmap_prepare is unaffected by this so requires no fix.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h |  9 +--------
>  mm/vma.c      | 17 +++++++++++++++++
>  2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 557e629db8c5..4ae08fedffff 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -970,14 +970,7 @@ void mlock_folio(struct folio *folio);
>  static inline void mlock_vma_folio(struct folio *folio,
>  				struct vm_area_struct *vma)
>  {
> -	/*
> -	 * The VM_SPECIAL check here serves two purposes.
> -	 * 1) VM_IO check prevents migration from double-counting during mlock.
> -	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
> -	 *    is never left set on a VM_SPECIAL vma, there is an interval while
> -	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
> -	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
> -	 */
> +	/* The VM_IO check prevents migration from double-counting during mlock. */
>  	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
>  		mlock_folio(folio);
>  }
> diff --git a/mm/vma.c b/mm/vma.c
> index 39ceb03023e2..4f09fb98a2fd 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2607,6 +2607,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  	if (!map->vm_file->f_op->mmap)
>  		return 0;
>  
> +	/*
> +	 * Driver-specified flags may make the lock flags invalid, so clear
> +	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
> +	 */
> +	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
>  	error = mmap_file(vma->vm_file, vma);
>  	map->vm_file = vma->vm_file;
>  
> @@ -2629,6 +2634,18 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  		return error;
>  	}
>  
> +	/*
> +	 * If the VMA is still eligible for mlock(), reinstate any original
> +	 * VMA_LOCKED_BIT and/or VMA_LOCKONFAULT_BIT flags.
> +	 */
> +	if (vma_supports_mlock(vma)) {
> +		const vma_flags_t mask =
> +			vma_flags_and_mask(&map->vma_flags,
> +					   VMA_LOCKED_MASK);

I'd just have at least the = vma_flags_and_mask on the same line. It's ok to
exceed 80 chars.


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

