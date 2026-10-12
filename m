Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C3BACC6B02
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD7E6B0096; Mon, 12 Oct 2026 14:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75EF66B0098; Mon, 12 Oct 2026 14:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64DF46B0099; Mon, 12 Oct 2026 14:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6A26B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:42:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAF821A0B1D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:42:50 +0000 (UTC)
X-FDA: 85314845700.19.63CD5E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1EC0CA0009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:42:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMZ7nmyc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830569;
	b=rVCY9W/hu/SmWqmxlg57PRrOnN2cpzl0OLJdpi+0GUB93gdo8l+2GuhRsECZlWWxZqlp5x
	IAPsN5GxYqjM1eQ2tc41CgAEWjiI9KvHAFELi7xligRZ+hJZUoBFkfSvCZLWQMZVhiPDvG
	2gbnWj8O2H/6aHwPukBnjk/A8aZrL3c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMZ7nmyc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7HtUATMHV4dGHIv5dVrYZXCU2Hx2YbbFxHYHdPPqaQ=;
	b=tn7dN97G2SwEDKGDxchcwvZwcNUiTROU7Dt/5kPhqH61U3c5MbiVctgwrUa64dLHm/cwhp
	Zeu9jYaKSQ6cy8BnEtsyzOtL8ra4Fjpj9h5e1wQ+3mDvQywfZATrq+tGro9vgiboY6V+03
	j08X+uSW+1wKa8c+zqLWvZhq2W3aJcU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DC2E40D98;
	Mon, 12 Oct 2026 18:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC16F1F0089B;
	Mon, 12 Oct 2026 18:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830567;
	bh=+7HtUATMHV4dGHIv5dVrYZXCU2Hx2YbbFxHYHdPPqaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JMZ7nmycwzQ0zWeow0izPPknZRcO/wgySmNtYtRnBKvciZBko71ogizDs2RS9o1nN
	 QiJEsk0Fxkq8JfZgvdubthyoVQPH7sKqFsuYgs9+nqaXwRCaGHTXgvCfX6o+rQWzIt
	 3aFBzjUGWc0uejpx2JphrOIG95SlKwCApFjGagHpKWtfkWQIb9WHor6tqgHRYos/NF
	 XpRQM8iXCxBBK1nhGTZJAutT/h7Lttuzuq8A1yYgdaoeROtDphWPD9Ms9Mp3EHyQtX
	 H8UGNcWAWLzTdAnnqrMy2sHZGYx4f1rtbM2A3wa79fE/o4qCg3V4fr1GGKHMjgYesz
	 R/LnsHiSg/EwA==
Date: Mon, 12 Oct 2026 19:42:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 25/38] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_mm_managed()
Message-ID: <as0pTv7PfApL4ftP@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-25-923b70125b1e@kernel.org>
 <c43caa45-6a4a-47ab-bfa8-c9875491a9e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c43caa45-6a4a-47ab-bfa8-c9875491a9e6@kernel.org>
X-Stat-Signature: iu8mw3ti9tz19iyyiimpfzmkyog3zazx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1EC0CA0009
X-HE-Tag: 1791830568-444328
X-HE-Meta: U2FsdGVkX1/MX2l1TpDtZWMwc0N8qbGA5AKwBTzWZePYn5tk6WqHDPqg+SQGSdJqn87Bw6kpR9PmwNtgoZC8vxpQUeA0VriQo4PNNZiBfMAN2wWr0Mhm/1BDTRSy2fXqQVHMQJyw26f/kYG2gARjnmKr1F57MSMIf1rJjq8MNeY8VC2f6cNKLxPuI0dfKWfSM7qHWa9hIxR9rsgu5SRQMz/uiUE7rFoqzR2P+6/vkPT5oDZ/Qe+fNk9S4Ja8CJxXHd3JPlE0h+YXORsI3w+1+mxOklK+B7BE/gV1PSKlKP7EtNzfNAHkolABMprsyEO8tstb/RAoFRkEMy00oFGte4VGFQTUvKh4Gl+cTVqKrvfJUqA1hG+/aO4ev2Ua/cQfCrw+JTkjleIDy9sRknojYRhzFjgouH+Q2BbokM9MSPEMcNDErqP57o98HT71pnGkoDKchtTfXomwfpyAsjJo6uUihuzL0uQldtW7ilWH5q1MpTklg05Y3X3NLje4XkwvsMEgcehyqAFN5rEgmxATpetD7T+oCh0Cq6H6Q0W/FyGnvdwqGUmUM5vs9YBBBxS1QJoTlFw/lBg4nJUprq1KYGFTQTUD8WrQnJUOb7JNBfBQ41gBdaJ9EcaEvEFdsinpbAkHVHyDzd7udh5uTjbO0Uh+iegZTuBQwEFMw2FubQTw2XDQ7esgF1u9k4Jk+NNkTS5vPv2oND5Afh8CmUzrZ3cV0iyE54mlQDwUkdgLm+9+A9s2t7GFbEG6gOaerAuozVow3Xq1tFEV8CtHlRbMMpHhUhYCXUem/U9G8jZQIm3ZbcifqBeHjDS3Z+f5zrWSQj3bKRD5fk7CsQHsBjUqc9Af2DEFpOxbVesZGuj9pc33kds19PJzpRiiNw5RglPxU2+jI4yKTVpuaDze9BkKoSvEFP/YvnXkKWNDJpJb+O6P+V8pgGjG47XcpQWJfYQ6+VQlJ48g+UpChZNODon
 pkC10F3A
 EAKAiKm5f3Mw3Tzuk/RJBUHKlPCm93o+gR9/0jnhD2/2cBhohJHpu82FOKnlBeyg/dSPxoE+zG2HyzfXjU2rGq8wDl0LHSsaMYsDaiFswFuUeZOFa0pvgOxZKGd9zk+37QgDtwWe2Gv9wL0tJ1TpkqnnQQ1apv0YWrjqVyshCyAGoNTgQbQcUrs8naYn7D7E3g8Ylb+a9VLuKFL5nn1d3lqEXwjRfBPSLbvmvnARzUzyKZF6xUZv43sFe1UgIPqck2Vy9nablt0+s/dkl9J4wczgONkZ3HzGNlPpyVILedysek0g9CnfUn5tEbdITJ7fH6M1Y4hqjLdQt2ZfVsBxBCqgG8k1tsise5YytqVHALOy9KsZEn50+rBQ+bQ0SrlBtaMSXXrBVDvzjH238HmRMAMqd8K6/I415bKo1PINYPlFGVy6139WRp7rQTeQ61YrXtLxwRYAUkrxb8/zu4d1V41WgwUEy4Hb45CFsW90m7WYJ7QM5VblB2X+llFIExYMFRHrbccAQajaJZaMoofqvN4v6+5votN+pjmEpBf/BhXk61Q6Obm8pmh24Nr0BZ8hLqAKZqk3fckEiSWt5CZ4lSP+YskaDQsTp087ZesGfXYIYIRlOMJkvD72HUX4DSkNY9Qls0V3sT13eUjr9/IWOcCkltlEGCua3LukRR8VXXvnvLhASISehNSC2uIJ17mtml2w1O5i4fzBL7c0CeKpiIl0ss/Kf302yFERQgpPKp0SGQPO+X0/qBOAJlxBBo70BrgRIyC6Oy/2JpsU51U28DHuVU03ZmbxyDwSArwjKjUi4vTvPtjVIyHI4ZrD50iCRyfZz7VJLvUeJTEumbrrzuXj5vZfo8SOD8HEazGJNdqrKjYuiH5GkLS5PBCG3/CuiCQH+cewydXxYlZ5dscgHrdzfHEsLEXJ0diRouhFstRbgLo8Y5IiTmrkCYAsYlGzGEkx877FJVOQyS9rg41gCVX/CWano
 gIM4Yi5x
 n1N38Wz8c1bghHhm5zqhqkTvXKLByEPFvgoxKrDCr8YPL2gTdB+yYZZkNC+rXjRMaB0QVrOiaOeG6w/ndQEy3GYM95LyMiLM8PGAMrO9TsDirgME+SNO92F4vjhi6plt02Fy7BeO2mrQuA1hELsfTQXgrq5g2FE79Aqg1GvjZfGK9ORMAc8o1md/fk9+XPmprdPY/DIPE5bSt3HyBCXzpq/ozWkUnuOvbp2kO/2ZaGB7PPImcvevZPz3je2N3QtGLiJJLjjerp214uHGbw4VSJSpAtxikSywxxFDLEHfS/HVA4h9q+zD/h+v2CXmOemNDojl7/++m/pcxHuNf28dT9QeljMAxNmNZIu3LISFVyOqDX4zJxFIIKKneDeksCfxCtjAI7Q9SnNkt73oORNGXmz0TOrIp1qMF20nBD+QUA8IFfMSDHKdwugt63pHY/nVZAX1uzUx6PITfqIOu/Zvl4p8ZmpmVhKH9HGcQCGMVC6QaymN8PMo2MBYHXxq2JBM3Jbtq8udBkhH16CSzhhtxpxHDkQutqUBsP6XaScpnlX2TXVThHriFyaM0X4lHzU54VwJYm6lcowO3Y2ZNpp+DS5cHHgP800GaKKCvRaKmHrRp+cnlyeUAacjnSzT6zGI6cP/WIQl9IY3dwK4Zjoz1Z4HJ5V03U9sT7iY0dIKrZIxgCjwsTCMK91f8J3pDLR5MBkCWIesocuXKPFZadEzHj33UUL7qwUa3fnLkn73/Pn80Na2q/JTnGpOZmW9xDJ1/LTse1DIYxW4y5+KNoyCJ3tiZPlS2Z5BARDKmXFc2C9zEhiiqsc1G0ame0BHFDnAD8SbnRXbXLOZtHbn+DIyHB2jM0O+/8vW/cwxIo+ilwJXmppuVzodK8et75EjcopQzat3vMViYgKpz0nhvYkbr+UbMcc1uHJh2S7iKRcYJWfa/NyqwEjpL/FpsLcRLPMQDx4Z/ekrvWVjbCJYp8t/44yhmMGsr
 iScgFvQk
 Pc0isq/N+oQL7u2jexnsrGyl4lxQ/AlgJEZRobc4yJO48i3M2WA7ploWzQwrkFrBHep1DPhrzMUrYHyTh/fsRuc5iOnP/WbENuUG80HCFhlGviHwQvNqLTWZLbV+3HAg9/lFGkKwdFii9L9AlgNzhkjoaOBCO97MWiP/xUuY2GmGcUHHaHV92D3giS51QLg5CkCIqMwY3u8GWq4KDg+ypgrfwTXllPhh2mpbpp1XFDs80CPCHRQDXw3FJaDFUyvZv8EglglPpUWCFy4yhqkRmnp+dsiUGtG+x80FAV4zxUoZcTVT2sBqPXN9Yu+h27upvIrp42Yo2gwZtG8j2dmft1B+iSifFIiOB15tEoCENYOssiHuKelRBEuVi1g93Ras9u8wdJOIJXOzAyYeL2TelcPHtsVLHYjTqb++t7v9cHCMI2Tdjl4eL3Dbf+/9z5dwNWo51KWQmN3JjDaRzjde1xAhrCBAcZZVYlOFHVgmq7MskLMH6sIDvj20HDdsiKXU0X0zXiq+pcxXQ+AUOWobngas/tPth1aBul62cC6M4IKWjHjSMpSeZZlGAOE15WgRSSLFyvDRrsBpSVb3qXmlp+HmFsGxm8tiR9mYJDiyWV/otPvPEOez/PepbJeTbIPaOdf56IvLFZ7xyUgLpc6o2khUQ1gWbPyY9Ri4jM/05SYK+hhWzn2zg2elcPcudzg0nDUoZOSRsCsyrnian+CJijs6Z2Jfc1R0jCgDmZ/RkvrOvD1u0chrA8elrAMppSHLFOqyJYUSU5LMwXA8Mb5VUNxopmraWN2UWXGhrzDJVGWJk7lKc1dbgBfKRSvEae6B+4liUwvS6z7ZvBgYRajC4helojQ9Pr464WmjwEYUnZ/tHP7KmHnKJ1virBSlatph0gd2e8m7X4b8cSFS/Z8WMiUs0bf1rDleVTkz4aXsWA7MJdDaGZAtaKmH1cEaYNmbDXmbnfhvS15m7/xrPTOE65/xaa9+l
 BDpLqQ+l
 G0cRjJoYjVJaspiFuBf2HFkSn4XBBGXGJhYZ30f5d6TLx23VQ+9Cj8YjGn0jAm8HmdBgJaFa8jDqsRH3sg6MVTSsAg50KkIybjYM7DipxsQgRnDtvSX5kZkrPR9EG+DtaWfCijGPcpQNgfC9zAU6+Fq11BhSBQv/0FNFTXdWCz5ltQXYQEAtPAHasWI4eHOk6VOXerPIgnOEyU4fdag2zYdXcBnivPRAHiZZA8DXB13utFnzKlAeNuPkm8zpNDc7nUa7aTEAt8TW9VP91Uc4oJ0fQGsc9NyqaYM1JoYKI45zTwT1swOLDcvsmiIGFU3k3++ab8L6SEmw+WMSWswixs6+Qoat2ovzVRfdORCgbw7iXLEx9eAyad
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:31:59PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > We have now made it such that every driver which sets VMA_IO_BIT marks it
> > as not mm-managed.
>
> Confusing given that mm-managed check tests VMA_IO_BIT.

Yeah, true.

Getting rid of that is a really nice improvement to understanding in general...

>
> Maybe combining this with the next paragraph could make this easier to grasp
>
> "vma_flags_is_mm_managed() still checks for VMA_IO_BIT, and if set, treats it as
> non-mm-managed. This was previously required to handle driver that would set
> VMA_IO_BIT but none of the other flags that would indicate a VMA as non-mm-managed.
>
> We already established now that a driver that sets VMA_IO_BIT must set one of
> the other VMA flags that allow for identifying it as non-mm-managed.
>
> ...
> "

Ack, will update to something like this.

> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2796,7 +2796,7 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
> >  		return -EINVAL;
> >  #endif
> >
> > -	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
> > +	if (vma_flags_is_mm_managed(flags)) {
>
> Ah, there is the change.

Yup! Was an annoying dance to have to do.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo

