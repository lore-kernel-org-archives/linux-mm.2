Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E03CC6B02
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4CB6B008A; Mon, 12 Oct 2026 14:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D566B008C; Mon, 12 Oct 2026 14:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3932D6B0095; Mon, 12 Oct 2026 14:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9156B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:24:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D659141392
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:24:14 +0000 (UTC)
X-FDA: 85314798828.23.9613E49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D27D100007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:24:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jtE+F+Qv;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791829452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFaoCRsSeFrqplzPhC7sYiQbwkNwnjThwg1EUt1kpJ8=;
	b=YslNGmeHXh9h8JJ21WHc3sFQ37M9KkS2UOQfXphxkiaCWXMvOCPHc31bfme+88zRio7ryk
	9vzEFwUu70Lvr/bXdHwEkB0cA3GosgwMa8dRnM0v8BnNw0XhBmTURAqKA/svpy+HlDFv2h
	9S7g+fWRwEont2cSMbBLdG5xZ+env3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791829452;
	b=HawKAAEIFw5L/MN1LNudGhIRr2v5UbvBknG/oNgC0Gt+T9QZSRHKbZpsWhmnh+uNzO9Nai
	t/cAhgaD/BF6g+W99V1vGof5SUdvtO010hkhTje2w48ElQnnA+fEX383eVleFuhr0crfJJ
	pgVAN6SQ/BXDfZeKHlGZiyPUaOSJt1Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jtE+F+Qv;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C9B960142;
	Mon, 12 Oct 2026 18:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB211F008A1;
	Mon, 12 Oct 2026 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829451;
	bh=XFaoCRsSeFrqplzPhC7sYiQbwkNwnjThwg1EUt1kpJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jtE+F+Qv8Id6B6sok4tUXFo/WttdoAtNDsnYx3FOXrAL8cH9okupFlV8UIia7guEU
	 +vucEDeV2orWOn4vncvKjOHxgLpA4z1i7ajNG9MWZWMFVvN4qyIVzuZeKcX/kEyCrH
	 E/taH25MY4+xXS5peaLpSE7R7Iim8QiaiSCBIYGbdI33SdOJfzFvr3BmyPD17L1aAJ
	 U/0dNzP3xhDe22x9gKDa9ilglbfD3cWxl+IMj1eK+ZgOY9uKMvF9rxkAMBdTJx+kaH
	 UEWib9ZdZm5YRBOs8FNN9IM2uvce7gfClsp4wZPpS8lSb0rbCcbaWuL8XwghfAbqY4
	 TscCzNvFkg/Kw==
Date: Mon, 12 Oct 2026 19:23:24 +0100
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
Subject: Re: [PATCH v5 22/38] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Message-ID: <as0lLP26IkTzbeaz@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-22-923b70125b1e@kernel.org>
 <5027aec2-84c1-461e-9f74-0736e2cc6171@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5027aec2-84c1-461e-9f74-0736e2cc6171@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D27D100007
X-Stat-Signature: r6zcdipj4suyko39dwckbd4ofwi5rfmp
X-HE-Tag: 1791829452-172630
X-HE-Meta: U2FsdGVkX19pfp8BuS/5EAoN/J7ocvLovUeXjfFOT2SIWyvD7RDV59mCCQMoIN9Cztv02yVLf0wqVavV+vuTLEo9Y2t1EoCHUE/5A15sBPhhpU5fBcfUG2RMVCuFZkGjL+LGiu3WlkeF/6DrHSLpwjDlvk8O/DH1xrAaTVXt2IKyqk3klxNPjTOj3DtQ6DGvYDh7yhZLSS3m0h3m5zXe2j5lBKeAukGgvu+G2gr+Ln7HhIP61sdCye34jofKSOh7roDM+MN6S4oPkl2ZkzYL5EvGUnCo0kBnVc+W265bwixFqvlP0WW7akfRqKyioJS/pFLvfmAyZGunrzIDoZf8+nKSuP6H6YEHStPEVKzlPfBv+zZX3W4A4/0Xoe+rwcUQlxnz+BUcznCs8E7VxF+Co7f7c1XEdiSSff+jwdJmAKEpNzjZvqrQyvDHpUhZz9B1KM2hbK1iRHd25d3z3x575/cFXr32cQ6sBn3daOQmGc95098qY53PGJr2N2u8iQaF4ilmFfBG90iFN/SClh1TJw/v97CeiTbctGdVxJfOwGFDtFhMDUn7qeZEUxPE2fjyINpbCy9oZoP8gxZaH+telBRuZ4iKLmkJINIe8K80m24CJYmG/SMGOH5dhSX0T6+KDpVhQZ6P/IIlEUnwv4rTSjxhsqH3YUOAkDEm6sHQqxjoAbJ6b1+WC/6/53mhElGoxav9vmn5dIjdvZmqKYAzFZ2ZvzTui6U1xXalcOGxlqYKFIT86NO1hTW4SG5DHluO4Hzvl8t4bnrBwZS2ogRG+8elufxP4YsTG8vCD6gknVHGWW20cPpa43hfDHDYGOPYxrBS1hvhDZVKcxJvcRaxpncILzC/blRuSeiAeDqF2QvQ1JECCd1Weac0ORm7GeA+yNYwa737Y8jx0ptRP0mMPyfmQPbcv9QxSni6kB+BXUpknsSyEb+qmGhy0fGYJSZiOl/GadOqyE4fBy2BWws
 RXibsiM/
 OharqJxfhNJagsK5qFvS49oCZWf5z0FN4jHzgyoc8tbzUU2M+OK1usS48lRaBz2zXliTJHS6TNx9WOZt/ZlB8rjRwpQetVcce0lUWuwyHvSrv+/D4KsPdnE261MpzLEgYhshCMgOjNg3Hke6zMJ2rasGYcpv4HTxwyxj64Vi3Y4tsb1c88gMKAwI8mxL9ayH2n3kMvmvoM1hawTrHMNbn/5Qua9J7q/d+aduParPKJAd+0aDtc1vUGO79bnqQSwG8A/g7jsAaa7yFy+jGbCrE9E/ovCaYb4s4iBUZ+QcqCpYd1GohwqMnGDNE1eycbjS57DO4MT4Gv58BudCMI4YYUx0HE/EDuEnBdqV1/BSLjDt8teZKs7vS/ZV34fNP0sQJJUVr1UAH3vapj3yUCWT52qwfCAppkYErm5LYKVN/4+cBS4fCI+VL0sIZcmaT+g2ir3OCRZY6wcDfpgJEpqYJQnrhMc+M+MgvVPI+dk06/DYzqRXNrmFE5mMnGWka4pu88cH9EotmbcyiWOGRXikioLrEJ/qNJN5eTtBFXFf+Qnvo5yBPVaXCj1rHuWEfJIkrBpx16bIz8108KobwqL1UpcuRLKbyW56qv7wOVx9KZHlHP8lOlSOwVqC0YBfP0HoZzV/4e/naAc2IuwUxRHoN0WXB3DbiVIJDL9faMMgkHHKWnNBHgnEzxkAE/pMAKQKYu+1BuVkUIYqyS9GCPj0eZt31uU2Mj6AnhsvJQxENQdZm+EczX08pTLqOaTXDlwaQ18lH4davJZhZNQH1PB1ZLRA21KrkZFfZz+EVRttWkoulIwe93+JroY5PTE4yjEhdrZzkzcaHOD8PaVnGNX6skJRicNMBnlGO8DqslQ+f7AfVLfFEtYWvExywDuXbOcw2gfBe53IOVt5TTDSxXl2yCJTrXRvusU8luatNV7hRPqbb3wkEKH7RiWGIpqXQiYKZkyrTJ2Ikki3Xbng58w4OiKxnC4/W
 dNG4jCGw
 nWruKlPSimthY/eUHfkTF04ytfGG9pwqvKa6t2ZbrLXD0ciEI5E/7N0i8lwZP5BMhdaX2xI6K2NfIPDPZ9W/eyKeP+VlgDa5J7F/eiQjvkjwLKW4i9uG7X77m8d4dEZH8b9+kkRcGIIy13q+Yce3MLvz7LhRdoJJOF+iOquWrmuelxb6Zz5U0fN7dR5t74SF/7rygRfuEErsGfzG8PlyCnnUKG4T+XFOYhd097zgA5Uoakia7oQ51hBRJ6gyUmbSy+4ZvPjth1D0HIAl9YIjO5st/R/NC3fwZHzFycq7ajXvdZn5o94lut/OBG3Yc/8PPViXAMrWgEesOxtxnu0cJtGxi5tnn5aKc47HfH9SCDyF3SE4TTYKtz1DBb+dFGxQrlj5tl4M+WfeingIcUoTX7R5c0jtVj9Z+3wJ1md/bB+Yp/fo72XovAtS0WzAazZFflNKhPKoxkP+zM3Pb4Q/sUen8kIfB3F6ePhsOXQCaowU+BGqLGDPdETVIIhnZTdrCpXnLZcrn7S7Y3EeIDhOT5ydz0U/m3wEKGgCXr9yUNb+hHLl9tY1qua05rvNxD7rN+WXV6rTCCg51f0nT26LVeyyOXqphz87ZGVRTJHhoj8jYBPK74gBrgVEpn/X34oPn/urw2fwQlROpeSl6UlQt4I1jQlCYiye7wi3kIjD06AJ6O/pJm0z0YFfjCdEEywznr/CzUtCe4dGS+SY6G4jUw5YRBq+nz9uObS+yJG5nZyTKRXu4joYZTqjwhg5DVhfi2Nxnf2VTsOrc++QaNdi+jTDr2SsnSw+Lq4bC0SwTTXvs83MgWkRV9RjCDG4GSIUM2ydFZZsdn148R8PUOydnYYkiRKoDsumYV5QqEWr8RnSbbKWRE877R5+8fGdN/tfJfELbRb+l+rzOvwRmZvtAZmE9t31fMrpYd5A0xYatGLdyz2ZKjW3/U9L2ZNFieiyHpgk7Jf6zVAy7F8tfxl4QQEK2PDsc
 z8X0x/rB
 gx+hTlxYbdv/Q6mdg4Wak0e4cuUpLqZgJR8g2s0strrYJIeVD7G9b8JxdC4J6mviRALRePfBn2DdMJzaAGmZV1RFwBu7tCu+J9LvqEej/bswkWdh2PUR4AuWeMkrlL3zF+wo102doQG7NvUjLa0RM53ViVJAbaHBskiVKCP2hxvoE98Wb5AqEudswJIN//HpX/RwZwbxM/eyzzPtem4GSv9t62e6kt3laZwoq05e1Yz9FgPOPWeDcNCE+n6vyZZ1heku5tTrduS24BK35FqnbKITX1ysjFwU8wBgcIIcMOs1MAueSIreOCoDs++bneW/KxN3WHJiTA7SOGP44Pj1bWk0GYQl6MFkifd6/kXAFMSTc69fpbXXv9IotW/8kZLBRf5TdvkLrJqnT8qVzKnk9ehq3mqck3/d//tue5wg9BH6VOPJpS4PjqDIQtuHtjPKJ0KHxfCmOyuMaqJ79VlQ9chteovYYqIKDiQOH4rGJzksNOvCV9afxWid/BcSwpzQZVCABs5vhtLzicLRKrXfWogT4LBwKs5DPdJBHS5XutHgdpaBpvkzKEr/4KdWhgs1NkdNCqNEOaXXLN9J5UG+qp4DJjC6XS3A1taghDWcAq+2x92+gYKOXjbTE0I40VQTojzebuSIhXjih80Hfj85DAjy6qJkAlrJCjmG9LoPm/9NxOMOXeLvgVEUVcLK0iz9swIOIermoWDq1Lik7k594K9AzlHjWnLh6X1v+UZq6ePm8QC1qduXcMrklJIPy6CqmohA1ulB2mS70xsGL0GJB/1TAxiEpH3PqEArDiz22rnVNuxw2HgDAj8KNSR4isYLs7Qn6g1QsN+t4MzXoBI+y49YSiNbMDw2EIRGrQ2kWNA5OQu+rxlKTUoZD+0yMDG4RqSaeWsy3g9KXl13ynLP6OTgo8G8n1T11aZt6+Q36qU3BmP4Q6cH9rUyUYMf02oPoxjPpoydVIVBFMZ+QcAjc5cQRiX6b
 HC0FVOsb
 IN7mbNkpc80PIBnD/526z1BChgXMILmWAslSufZAdKMkaQbYbLJP6KG5RXleZ7gDuVq5ojHZdCJJCTg12pDj99rq5BayatwK0+Sn3Ki9C4fA5hpCUFIYDL6IYpTPixjJcmHTLG+6qxooCSGMTKzhlfmZt0mO7bBMLylXjW58FvGSQYC8kQvxeNRoFuMEdpaG+uVmvP7bPkfA8fU24thTyVd9H/0S5NRLrQjJ1LOcNx3ouTCWii1stBDZvjn/BSAH4SPQ6+UkzuJQKQiUdyuUAObZVhMdS/TJIAOvq4XWiUe1NjBEEgPW3LYOj8TUqR7si90Ejk3POjdAJFlIPI2wzi2ZodnCj4ZD9L7y0A3ZcpgxtH9nscGcTlUatd02A34EZgQK93wC8qmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:19:03PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > Currently there's a confusing mess around VMA_LOCKED_BIT and
> > VMA_LOCKONFAULT_BIT.
> >
> > It is permitted for drivers to set any flags they like, with the VMA
> > already possessing lock flags.
> >
> > This results in the absurd situation of a VMA possessing both
> > VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
> >
> > This has resulted in mlock_vma_folio() having a very silly check for this
> > scenario to work around it.
> >
> > There is no need for this - just clear the flags before invoking the hook
> > and reinstate them afterwards if they are required.
> >
> > Nothing relies upon this being set during the mmap operation.
> >
> > mmap_prepare is unaffected by this so requires no fix.
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h |  9 +--------
> >  mm/vma.c      | 17 +++++++++++++++++
> >  2 files changed, 18 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 557e629db8c5..4ae08fedffff 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -970,14 +970,7 @@ void mlock_folio(struct folio *folio);
> >  static inline void mlock_vma_folio(struct folio *folio,
> >  				struct vm_area_struct *vma)
> >  {
> > -	/*
> > -	 * The VM_SPECIAL check here serves two purposes.
> > -	 * 1) VM_IO check prevents migration from double-counting during mlock.
> > -	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
> > -	 *    is never left set on a VM_SPECIAL vma, there is an interval while
> > -	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
> > -	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
> > -	 */
> > +	/* The VM_IO check prevents migration from double-counting during mlock. */
> >  	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
> >  		mlock_folio(folio);
> >  }
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 39ceb03023e2..4f09fb98a2fd 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2607,6 +2607,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  	if (!map->vm_file->f_op->mmap)
> >  		return 0;
> >
> > +	/*
> > +	 * Driver-specified flags may make the lock flags invalid, so clear
> > +	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
> > +	 */
> > +	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
> >  	error = mmap_file(vma->vm_file, vma);
> >  	map->vm_file = vma->vm_file;
> >
> > @@ -2629,6 +2634,18 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  		return error;
> >  	}
> >
> > +	/*
> > +	 * If the VMA is still eligible for mlock(), reinstate any original
> > +	 * VMA_LOCKED_BIT and/or VMA_LOCKONFAULT_BIT flags.
> > +	 */
> > +	if (vma_supports_mlock(vma)) {
> > +		const vma_flags_t mask =
> > +			vma_flags_and_mask(&map->vma_flags,
> > +					   VMA_LOCKED_MASK);
>
> I'd just have at least the = vma_flags_and_mask on the same line. It's ok to
> exceed 80 chars.

I've had people yell at me about this before on review :) you can't really win.

Since I'm doing a respin anyway I can put it on one line.

>
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo

