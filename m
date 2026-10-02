Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0CBCA5FE7
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 21:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289496B008C; Fri,  2 Oct 2026 17:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A726B0092; Fri,  2 Oct 2026 17:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB8B6B0093; Fri,  2 Oct 2026 17:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB5F76B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:20:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9701120815
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:20:16 +0000 (UTC)
X-FDA: 85278954432.29.6A5E07A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0BF14140003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:20:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpvjpYU4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790976015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ArV7W8I0LsjTzEAaR1K9jy25JeP2SRH+A96kVSZ90A=;
	b=MGQ33BUSsBHKbL/vlc+pnZCZwFs4RpH6pKhsiV7cT5SoVXyVcuuXplOgI6AfsR8D66UBKm
	cnztx4WwHvblQLQxyrQCdIayWJRfplpDZE8MLiIGfr4YlhBQ21/dUSR6IMNaU70m1BwLf/
	ouDWjQwQy9PbSQoSV4RbEz0oOTsdCKs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpvjpYU4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790976015;
	b=EQFBm1gaZwzxH5IwpcJO1bufjJt411l5ch9N8g5x9fxxMDaF36MB2txxeXjtaiNq8Wbc8a
	Q2GtnPPbMJhORKITtZObDTAFw/JVg3DyaZdTG3hI4TkX+2JFdLQ8ggxzy4LavhVWx36a8D
	pGwwuboit4g1qY8Eernj+i0rbLI+Mi4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE47B437AC;
	Fri,  2 Oct 2026 21:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB781F000FF;
	Fri,  2 Oct 2026 21:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790976013;
	bh=6ArV7W8I0LsjTzEAaR1K9jy25JeP2SRH+A96kVSZ90A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cpvjpYU4u7Gff3gvv+3rEhR5eck+vcIRcWyb1Q+dHkN+MSeRORuVtha97iRPXHZ4O
	 yTDf1hshmkL2uTTLhiDAtOgt3yqg0tyP1YkMh0cjJG2sPfJmCAYYaO3A8NPCrBCetX
	 kqA9sl0eq3V1GTT9pUwiQSB6aOj923fkGHl2U4UFSSQ1td0kLJkaMLyiFlav0GFQSi
	 Otf2qD0/FwFUyC1d6asohtioQF6OYgL36unFXzH67FlHCcr1DrF13KgliXj0YG8Gjs
	 ad70ETZiFPkGz7LnrN7cr9ICaDAtQarsVZuTam8h5Kar59rQHHdHn6vvxNCqptSlwa
	 63ZT6YTJ6FBvw==
Message-ID: <83bf4650-7339-4fc9-89a6-378a327f4f6e@kernel.org>
Date: Fri, 2 Oct 2026 23:19:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
 <0623ee06-00e5-421e-a24a-ed605abb559b@kernel.org> <ar_CYfkR5Pfb7J9b@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar_CYfkR5Pfb7J9b@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m1pntz66pxn7sfucamnmtibdushquh67
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BF14140003
X-HE-Tag: 1790976014-468340
X-HE-Meta: U2FsdGVkX1+lWvAV/barnnH4mTrzPI4szA/tnVE1kkIss1Ns1cKXaszAd7E4sT/VCs+N3mSUnkHKv6qVuWxZRlQFkPWL8PxgKS/upjPMvmQCrfi4lpAfXWK0RWqoEZU+50/wsDWyuO9UqSkCG09wI8PoOcJy5zgQUe59CM3nRm58orR4T2uqXQaik4MdOdVgjd3CJ7z2z7N0xYYR/upzQjPsTJqlcxreDBAwdKoYahRjqMd4V3RjiZ58t+KB+if7xY5iOUj3XllHulRb5hdkpC6F8WyigREqITWWi7RKy3ay0hD3eO8BJ0GJ24HD3XW+j9J5W7X66kPhORQBrR+9NHq99DXgI99qwR0yvDahZ9Ym2PRB0duRRphmFMu9+Y+xArSPEN8eTuFMqyh+4inQwdgVJhV9P74idQPKueE88sVsi9qk79Y4WhXr/410NzGs1XanJYiJKYIrBa9OLvwOHba1gnwB15mj9jSAvQtkDiOwlVuZiGqkTMLRrRlTj60p2/4zRze4UP1cv3V6PRT1CN5BQ8hNo6lw+3OvOHS5NNoV55OZSczRC8X/GWWAUXpdWjoksTwPssI+Xb7B9YEFnbwTPci32kgyz27JgkAFNw6NPgaOINCyFlGp5nEp2BXdEWFE7MDrKChMrmJ6oHdL10yIz0cdo9AMxMHv46YaQ1GKbsNeNlrDOyJ21F55VP16P3V3i9HbobJQ5yWwmFlxuw3QNg38Mn8rS4HL4eEeUnlnyuATM4qYXzv6IstQJKoy2vcpsetOWtF6ST79EsRB8WeAUZz+iMkagRobEs8sSa2Xx4QsIYtmR4iZnSJtjEDZyAhkZn9HZJl0lDB3xPWsn0WBwAye0Qz+xIxmKSV2ZRRBbUE+YOGLaZCKAUr6ucCVgBrQEvr3vQ/5Y/jTwixCwCODRgM23OQM1/Ul8jmFVc3HHH+zD4g7/4kzwWFIsq9lv4PYWbGBDyS6zI45QH8
 t1BChyl9
 sXoGm4CEBDCN2DVtrPwJHDUgDJtBu2w8+Ais1ZCTDOXtKZE+CDwM15cZt2FBXU5RjH8Sr8YHlvBboZJ35yMBAxQrn335zmk4WelW3AgDiSFz3zBstTBtT5PFeBPquJYzfe7TSEgpBAIrWynLL9xOu08gG8tJYUOmpErxRHGjdDK8Kx3LDSacrdmfcTR7zO1hQJATtfyBR1JpE509bpW2wRxLIqJRcPi9frEphqMthYw7MtSNGCvEEJgPZ5fGkHB6q5fdxi9DdJi5OK0F/FrGIa0NffhpuYp4s/g6dnfyYKiajZJ4VKulVDlpKyzTaWxuBaNjkX7vE0SOHJcb2fdTx1zMaHlRZGrCE4Nf8Uv+aODYl/FR5tUw6pgxquBAIR+eWEe0BCz6JncvWwOxELe7TW9gVASf7Y4oL83mNSrrvSb2fjMQuyC+ybP+8P1QQj7S9wdl33lpLJDTKvhDcdeX+TKlCUw0Z+xrBktrRQn22I/wXya72hlS7hvRMdRPCLTOeHaMPczUQLhhGk7XnyeSfDe0BwjwTe1Z+UhSrVZvik3tPpm5xGicgj6KjrDXXMrNfZRrtUt2s7ryV7eFOBqJepXueWqYn936wmzdkA1Fz2wRbqDz9fElGW8siS6YRpn0W/qrOuF2FAXCywOJ1HDoVVR7VAMCK/XqGezpDOQa0QkbpgTxIlH2eLEbNb2luV3cfAvFAfnhXT+iv6YBJzyEKoO4UhiLOjfx4mitfi2TG1AM414aCiLcL2dpH1cObf0kNrRdwLvJf06BEzZCe8QHhQuGq/YPPyryhB2VVbeqksPX/HcdKmmFlgux+n9NVfNBa4AAxzAsKvHJeN6OMd24vjoyYE1c2bxZ0Hda7lCgaziiVuCmCdbSf2sE2D3dbhU1D+wBxY3U14CcSQfqvAcS7fHRAiIKOcgQWoGBpyaLmEQ3PFXBUu1QF/2jtKIsUXWDbJHdNQwmFpRr1lhP+ppKbbHzN8Pog
 TcBXroPD
 2cx1BRd98yT9yl1hmPp8RBcyklY7abnqUObBHWVGflB57HH3RebI2I1DSmkWM3+c8AP7Z3c5L4dWuJGjcBJeLFqXHfByEYQy9KYJiU9E7+my4xqJAKq+q+MW3w2OAbzJS39XWHkKrh94kNyyO8XipwX+50ahJnZm2sZvHrZg9+H1q6Zow0hRI5k2owbDvRUWRJCHDO2FpiUS9DTIW1tzu9C4YLeZf/mFteuaWLKadRS5II+/50QpKcgjAzQKHenV+vWUWQqBHRrX1Ll2NywRNK+4mKId6npPigkktvTrortY8Z2/Zs/27TP5+kl3mcpSkbxxVtXx4D7BzGy/A76k7UcWpY0YP6O5tWsp2aHigjkFlHRUER/Fotf4gFnHHyvZb2WYGy9s9RFS5PjjTPdeIAzjZDAIjXtk6znbyKnBjtT72S2Tt+vh9655pBXXXP+Tkq9qfN1X9lpw3CdbtcPC7W/+nMd7NCMk624RR5lJnoCgo8bN3957lDVyZe/ud7ykp/DQdILYyYbj6gFeNZALenPqepebr35+n/nwkobvgD/UlblPt++UT1N/4zIRPUvGb3IfarRbIex9WvMJjtuaVtCRTeTx6a2gHcvRkzpslKGRo4Bxhfolhf4wirS11jvXw+hH++HcBLvGQ3Qj+KbnMjkondhQzpvs6qtGpW8jyg8H+WAqDreTVM/qvQsPYDdpJf/NIVtrDMXOvNV5f6TW4v9wtebihyggsT2bcTCM9wymBa40Uxj4SfKs9YNfNIIOSp5uB0HBRH/GHFSwofewJEIzpK7esW1v/w93L5bFj7CI8ajY76yq0Y4k7Ko3RSuFOfT1UQAY/DIeqjBu97cy1/aNqz79xZts0//d+MUGEk2+zw5iI9tjKXY/cWJmYTLqwltaeKimN3NcVbzeAh2ZNbWKkfrskiaK6zBbbK2x3U1y1AFua+ve0/M6F/i6AtWW/30ej/vL7QLnVhC+dkEDojcrp02zx
 2xepUrvR
 5W1lFBQT+wHgPl0cyXHGN4t4BWYl1ppMGpM8oQZ2w0bfkiLA5HYGYfA7UL5u5qzfEBC33CoQQdr9wefGYYxlu6sQualZCY0yAXkdcwZx3k2Xnsbjwr78FXvm2GZUdZ1sVGCe8oDentXP7k2CWKhVnJOIEqezIviCM2OZIsNRWC5Q4j7HLBam6QyX5QkhgLuD+R3mbgnEklQkExR2oz+iF+GpYVuxxzL4Tl1Ex96Pda76yZ0GyOIShsHZRlsxeB0wq1ttp9B5ModkhA+YZOCOU6YYnDVgdHTFFV8bpB3WWwaf65Q38wO7EYPXSvjAln+oJelB4nJPwRsTPoDUtK07rqcQUDIynHe1jQW6AmL87ONX/U5V/bbjtrSOeOUArr3MET/pYmwcL/HtzXMiWTPwlGJDuTd/a5bzZ27UL7qI4De0rEsxcgJP6lc57mDB4hfTsLpiHmUXySSgMkgRNKrW95mtc4nuEpCTfDW4PmiC72SgI3CtXt9oRSsJUVnImD/3swWpLxxWZ/1XSXfC4/GTeg9K2fy2FbYBPNJIH/2KggEzSkGDas5ROHV4T0c6T9yFs+nL+75UPavIZntjTqx+nYWusfn8QrxJoEA7Vi9b06JJkqaBiEiniDMSdT4g3dxmiuNoDjxVNkvgB7gl/RFYJ7kLcawqaes6+RPZBtM96NuFE5D/1OogntXT+JcAYjHL0bBqqphGV2gXZEidq/j2WMzr1ggQ7uM22hfKErb97+G0R8kdxO0etqJQ1cQmEqaVk+qPaaaBybPnYn/Yt6XObfxt6pwodut+8zsRW7rGmJ2zpnocAJGm1LLXmjxt5sruSTB/FUpXnBI2U7LI2/wv0Sn0TryEiUL0xBS37YfulUegHRyayfgbUmH1ZwUUE98ewQYboezZ01iJbM4cFBbIUvwuNVn+e67tT2EUefpJzFBIKxriagJwy+u2eWP5YsZBP16OU1xt6RsUkjRQjiwFd9Cat9V1r
 nxl3CLOL
 9aMvKDOvWv1sOJtPpFw3MbiZu7jx+E0TW3Jk1lNNNzLF/hikAdwH3x2L8SnilnQiuaPgFuqycgUnQe7eC3z8q4OkVp/sHBgSUObzYaqfttWiM0Fw5PX+2KracrNyc4sIQ6KsEbPN4bdhyUJHtcVn3Mzn1Othmj7KSAeJwrZj28FxYKwZiYXO4VS00H512AFHQpII4omb961gpIURPyJRBoccK8/5ekAq8RnXBd8CLl/6MSlRl//1Ro4tUC4j3YR4ScAeGMEob/pKmDOt7KLZZCUEqTwtccdgUtts+2L8LNntJnyVPhymo45L4qsKSLbAk2NP9M0HejMFZ8Pb4zOlOYlG9KKk2d8M3b1al4usAk40mTF0MZWPQ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Of course I have to bitch about the naming :)
> 
> Yup :)
> 
>>
>> Intuitively: kernel owned vs ... user owned?
>>
>> No, it's kernel owned vs core-mm owned.
> 
> I would say somebody who does:
> 
> 	ptr = malloc(4096);
> 
> Would think of that memory as 'owned' by them in the sense that they
> control the lifetime, they established its attributes, etc.
> 
> So indeed, vs. user-owned.

Right, I read "contents of the VMA are owned by the kernel rather than the core
mm?" and that confused me, because the opposite of the kernel is to me not core-mm.

Maybe it would be clearer to focus on the opposite direction, then we wouldn't
have to find a word to describe "not core-mm".

> 
>>
>> Which implies core-mm is not part of the kernel?
>>
>> Yes, this is confusing. ;)
> 
> I think what you're missing here is what _creates_ or _establishes_ the mapping.
> 
> Intuitively, if I do:
> 
> 	ptr = kmalloc(GFP_KERNEL);
> 
> I, whether I am in the core kernel, or a driver, or whatever own it in any
> meaningful sense of the word.
> 
> I think the issue here is you're confusing this with other things like the
> rmap and refcounting, etc.

I think it all weirdly interacts.

In !vma_is_kernel_owned(), would we only expect ordinary folios
(anon/pagecache/hugetlb/dax, maybe shared zero folio)?

That's my best guess looking at

	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
				  VMA_IO_BIT);

So one option would be to focus instead on that aspect (folios that are managed
by core-mm vs. random other stuff not managed by core-mm). But thinking about
it, I'd prefer if we can leave the "folio" bits out, because COW mappings also
map (some) folios. See below.

> 
> 
>>
>> I assume you're coming from "map_kernel_pages*", but that's rather "kernel
>> memory" and not "kernel owned".
>>
>> Usually we say "driver owned" when not talking about pagecache/anon. Or user vs.
>> kernel memory.
> 
> I think it would only add confusion:
> 
> VDSO/VVAR, perf ring buffers, shmem mapped via PFN map, uprobes, etc. are
> all in this category and I doubt people would consider those driver-owned.

Agreed. They are all special things and won't be folios in the future. (shmem
mapped through PFN tells us to ignore its folio background and treat it just as
some PFN range).

> 
>>
>> So is it really all about "is this (excluding CoW) no ordinary user memory that
>> we would track through the rmap" ?
> 
> VMA_MIXEDMAP_BIT mappings can be refcounted and rmapped so that's not a
> correct description.
> 
> The distinction is - who put them there and who's allowed to change them
> and who owns the lifecycle.

Lol, I asked AI for better names and it told me "vma_is_special_mapping()".
Thanks, I guess.

I assume for the reverse, we really just want to say "just an ordinary core-mm
vma that you would get from a simple mmap() as long as no weird non-mm drivers
or subsystems are involved. Core MM fully manages this thing.".

* vma_is_mm_managed()
* vma_is_mm_controlled()


>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>>  include/linux/mm.h              | 56 ++++++++++++++++++++++++++++++++++++++++-
>>>  tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
>>>  2 files changed, 83 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 2a92193ac6a5..cab29d6e15c1 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -1612,6 +1612,44 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
>>>  	return is_shared_maywrite(&vma->flags);
>>>  }
>>>
>>> +/**
>>> + * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
>>> + * contents of the VMA are owned by the kernel rather than the core mm?
>>> + * @flags: The VMA flags to test.
>>> + *
>>> + * A kernel-owned mapping is one whose contents are established and controlled
>>> + * by the kernel, typically a driver, rather than by the core mm's fault and
>>> + * rmap machinery.
>>> + *
>>> + * The mapping may be memory-mapped I/O, kernel-allocated pages or ordinary
>>> + * pages the owner has chosen to map itself (shmem via a PFN map, for instance).
>>> + *
>>> + * In all cases the core mm must not populate, reclaim, migrate, copy-on-write
>>> + * or merge it of its own accord.
>>> + *
>>> + * Pages mapped this way are not necessarily reference counted or map counted.
>>> + *
>>> + * Returns: true if the flags indicate a kernel-owned mapping.
>>> + */
>>> +static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
>>> +{
>>> +	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
>>> +				  VMA_IO_BIT);
>>
>> I thought we have cases where we drivers insert pages and neither set
>> VMA_PFNMAP_BIT nor VMA_MIXEDMAP_BIT.
> 
> There were 4 - defio, cmt_speech, uprobes and the bpf arena, and I fixed
> all of them :)

Great, that helps to identify these things. I didn't look at all patches yet,
but we should definitely document that.

> 
> Other than the DAX-only case below of course.

Right, as DAX uses real folios.

>>
>> I assume vmf_insert_page_mkwrite() is fine because it is DAX doing it (should we
>> limit this interface to DAX?).
> 
> That is a DAX-only thing and DAX is precisely a case that should not be
> kernel-owned (and isn't!)
> 
> This series actually fixes the FUSE case too, restricting this interface to
> DAX only seems like a sensible follow up as well.
> 
> I could also add a patch to this series to do that too if you wanted?

We can do a follow up. Not giving others the chance to abuse these interfaces
would be great.

-- 
Cheers,

David

