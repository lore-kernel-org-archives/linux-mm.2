Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D164CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BECA6B008A; Fri,  2 Oct 2026 10:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296856B008C; Fri,  2 Oct 2026 10:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1853E6B0092; Fri,  2 Oct 2026 10:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFCDA6B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:00:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 697A812078C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:00:07 +0000 (UTC)
X-FDA: 85277845254.07.E9F9715
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C0E9F80008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:00:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCWn9cDF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790949605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrJqgz6XBqr0tqvrPwuWu3EbEV7kVO9oxqBplkAGfJ8=;
	b=FtaHUgRcLacYcIuGPxc1sOkA8pXR6GBFwM4xmv2+EtT6iANXty+AQO4aH2vii1e+tAndl6
	kt+hFVtVvFsBnwFhp8RcvHVkGGZxMQBj4dYKTKVoHaP8Bx1tYtLgxX8QI/mBHwKiiayu3w
	6893iq8Oe8/JjfnmjZHADsFhtsMeBi8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCWn9cDF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790949605;
	b=JY0I2o959QPE2mIkpNr3noGhKIXqSHLm8wCkNDaCTZ3t8P8nc99nP3tCvVXeu1CmjNkHge
	nOg3BDE4pGUC5lcXTdJR6Q9CnNiAk+0Ytbc597NrEvfmBPSrsO55HTIrq5M8CX/4Vqyg9o
	kZEwmWCPFOsxU2sMv4Lnpe56fZYFKyc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25F7460A70;
	Fri,  2 Oct 2026 14:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501EB1F000FF;
	Fri,  2 Oct 2026 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790949604;
	bh=JrJqgz6XBqr0tqvrPwuWu3EbEV7kVO9oxqBplkAGfJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lCWn9cDFMJm4u1OpaqsPaifDSAYxVJq/u9IjTjW8VHaCqg4YN9JjvyLsXvAqt1QNy
	 kXjsxEDBQVVSiIroM8JVx8jdbn5z+D3ALO2UR7Dt4oCwXbWLHzPI9wUTMqgwfU7Krj
	 IZwSxYhHFuMLnMs6YBDMSwGCVs4RhT6DtJPo3InMpggMiPIDm38MOeNSzD7sXk23e2
	 RWLEF3oKpPBtzGR/mrLgeY6/R3hf0OeJ04oxiHGDqrqFlOeh7T6MsnVwgAIQ5juixO
	 EyqksyZMc+ThciZZQxHOhRow8uXbh8X8CGyWqfIqAq62o4uBFfPnhBhtXmHvotijgD
	 QT9fd+pxtot2w==
Date: Fri, 2 Oct 2026 14:59:35 +0100
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
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
Message-ID: <ar-ux41ILjI1Px9S@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
 <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
 <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org>
 <ar-b_Ug__TBzIZsb@gremlin>
 <2e5a4e6c-8f9c-4050-8998-454b83f4823b@kernel.org>
 <ar-luB9QVCRshtIw@gremlin>
 <3387642b-c39f-4f19-ba0c-267bbd2fe91d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3387642b-c39f-4f19-ba0c-267bbd2fe91d@kernel.org>
X-Rspamd-Queue-Id: C0E9F80008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4asuc3gwimpqwb4h347ipwt8ickei987
X-HE-Tag: 1790949605-529379
X-HE-Meta: U2FsdGVkX18Z1FGxObmIrGUkM+a6f4sdEA9H9xb397qTqau+MDteBaapFJCLbocV18HLxqs6dtFP8CQV2VAkcaWU2i/FaPF4u2MlEdKLQK4UDH/2RjFa2iUl1xwpK0ApIdm6H5e5NA/WwmvBUK/r5tDCm38U/4uP/1t+i3DEGf1A2QDOfU5yj06xg8W8wfMc1wUKJDAKvDZ/B9C1OtxRKTVjM9tth4ne3rtwIV9ivNmQGo2DK2u879QZNPwELIg4CpuCYa5svaBjDsRyO+5jaL9+5mIHN+MFNnxte6XIP/PafRCPZzmjCCPxtTpkSHq7Wo1lFaNv1+VQW5f+Ar1sgHPQzMQ4MjnQJ6vwV6Fk1GCXN1ijzUBafRA98eHCCQxEwB92YioGp3O1Uz1vYAJ3shu57krgNTqh80JvExnqRE9wZgX3naEDKC+rJJgaK0PfbTpl1v0nGHclur/zVrTkZSQr3aIH68g+i8+dNfgMN7xKEZ/7GqO7LaUxWfO8vuEv+e8bOTj3o+mnoHvxq36kJe4WNE6QsKNCgrv1XubhsNcdJxmgQhpOCOYb+Hq+R61Oim6Cz5QGwrd7vXpyU8t4QjmxCSa5WBW3aSKZow45KPIMPgJvbPf6ybCaGTreqQ1aaH9c1v/WEOYXDQtpAlmC0HF2KP8+8lxUyzCN1Fj0ga/tiujXfEfee9p3woeYH6z1is/2vFtP6Rda9XTO8chb2t7Sfpe5BIfuetQfRA26kmsmTAcrtNAhWpF5IKthunZSKfUTx7CyH4lkNuCViinzhv538DL3yKA+QRYhBbQuzsOiWAkNAHtnUzrvNA+v8aQ6myuLGjwLcXukYyuY6egNeq8c1DusiPR/Xl1PwI4qyUgxgf85PcI4sxuqEV7sPW4mEYHXLutfNj8YoA4s/dyBwGJszfvQb85TnLuvntASgjw4qjlir9uCBo+i59eWoP64FJhkuPVrYsFWm6Dhw8O
 fNfyS/KR
 IRcBWIaQhRaXF4wa4Tjss1yt0Il1jNYaUAaxpsSc0LdlrH1Ky70NOsqMA8s/pHaEz+mqGXrNMGDVM2zdGf2bX8YIrOJjsAcaaTUmsVjUkpRcSt5U2EPY+TCrhifZTyGnOCtQggH9p5c4BhR04XuGbXY34OGQuYFsCZg6HU4cZf9L3NS8nQlm3AJWvwCh/His+oD/oO1/LPwur/EEnF7pfnDOcdsJPZQCIg4PtBGdu30tl8oaC3tLbmCYcIJ7PP5mfjPrQxs3IaXK/H+vC9rZ/rJ2Gn0k7+TL4tBY4GXujQRX4p9hMGwjRA5t5FJx8VQmnhYIXip1DD6tye+m8MHxRtu3YzSvp3LIENKWJjqeGtRq4nKjBgRtTw317jaYZ4uSwvS2YyTwiG7zSlTc/T9Oc+HdSPXtTLV572qUwqdWGL4ttXFOr4MsrzaC3CAOw0uN0lsoVbPirz3LRvnBoj5uIa7KRpv39xlQuvzeMvw/4SNEJXVOytAlBfd82UMssMoJKEUWYfELGQ7l0w+D/Xum6Uxg2tw4TGFg29UWEC67bVHauVUK16NCsp/aiLxxbOPf1oGBgT5p3q8yuSjX3m4rMYWEhGUTaOGXrHFbx9ZbOAYUYgutCvm22DNfvPuoRHfxeo3OMJwZC7BtgPvoDW5xmc1CTFCIUkO9xEkmXSN1w7ArszH15Z7FMKO3v6jshWL9VqJ+OtizVPWg36ffiGWdwEB6n33efIzyIBL+HV7KgQNJNlhyCsdAwq/786+gUt4ZfLKD3WepqZ7IPvyKOhKmYcnvoEKKCwTDQXqKp6d1amlpTxhVosSaZSyN/s8woJ5LH0VXqkC6ymh4UzH/SnwCGoaq+w5TiSfon9Ddh4A/v9RAP8YlW25F3Yix6j8fNLx+Mfj92nyY1Oyf3n8X5JAGKTslTgHpEOmShYwMrC3DNcBKqXWANu3By5ypG4FyDGIpp2EmeJx1D1svc0wdxvDQHgdzCsx2Y
 Bk9m38hs
 QFZxzcEQyi84ceFU7M0+kXajy8+AiauO8+5iPpT2hLoJiuGWo/XCx5SXTqR6yjKkKtgx4qpLhM+C4xY0W9YsPNy94Ks/EsIGbDPa+utAr0TIMGekObOkfh1/bdHYwAzc6TPIqq4hZi3dHc/Ooj56ZqRv0WvZwLwhZaLb203Fd45PT/jxPkDpWsv+IC7IvDQhMGYq2cmsDQ1nURoi3dKM/mRY0X3LVe0ZdfHU3PUFoPCuPlEKLSqeS2TaI9F3XjtlLiqP8EBBHls+79JcoWkIMuzl3tzwsZ9g69TSEK9sMEnlWUo0i+DvOJTChQhAJW65gKuWWpM6l4CkkTOUiLBmmwZiJiBD06Wh2tgeerDuxxkW9IfuXKzuQ0El1siBTdxHDQBFHXTWI2QUhTBCIxhWBnu4Y0HylBjYUKGt6uiS4hgTQZnFF3wdPGbBIEiP4hWGMsnPJPkWiPSCBpAvU6DKUIs6seEIyW913TMnzgmcu3J3wI66ke1GINxIqg/YikpfJDMyWyTo9jmJK2wa+s4kHGimYMr6Nk/wTSln/VlWRN9WROU7203IqI1BsMEKlK0pknwcW4J4yCHdhVS+7ddX3Kol3aZTTOhmHEbabSak0g6P4hgFZwEkaMk3EhuJHhd1G/xzI54mCU/qd0w/EuhLzrYgPzxdFckp8KVB8M5FBNtp2b+6NsiuOp0laUTj9Y5hbdXDO+8oIfMLo093R72YSyNqEkEWHuog9QphWoHMhlNY290g5ywWCepx1PakL46X306yc4pEs3LmJKp50mHb0SxriZDWE3LsedzuMLbV6zpc7PP/22smtec+4SpLH84lOfVlyj7QHBDISnwhrdj9OchF9IPoWbAR2QZndEw5D9MBEwIpxQQBw+PqW+i0h1jopUmRNYZshg39KxRu2NAgbz72Vz01khmQSsWBQoSW++AM7MfIbBLxrPcSA1n0ZXlLVygBrw5zMP3uMQ20wsSJ2iDhc4Zea
 6vZWAzw9
 8Ny3d9vXrHHTox1t3/FSHTDvtpwaxiIFLWmGs/f6aOGpozfatjk8h/2rydA3RkJPcG0Isp5kcAYptPty1LZsr/ph3R5FYev8wg8eH6hTTJLDMSaMsAwoY7ei6c3xL8EvyNQzIAVB23iRYN7yj/8ZzL7kHFXnkmE/lJcX7hPwNBhj83srqNDln3bqPWlAs4+4eqIX4TUusZ4vz+1DvudEjOBYyj/Bal3Oa2uELuRUVqAUyBG4WUNgeL8pAn1EHiGE2VshD+5Oc7upnUL+X7pOHgXnWFsiFQ5JADDQI8QdbnWoYT36DgUxE7zyLfUtoc0nrNSfr1Q4z67U2cDHay2eGPUPMeScI7KPk0JZkQrMZ3LfnVGZj3arcjtjXeZjiyeYMiDyQ+i7dP8H9EPiZJ6pCLFaTSi32jLajNQS67Jid4h57N8ecUlTD7g4p2LvWwL1eo73f0XlgGp0uQ7YbTYtt+F8+5dD77uwNGL/zSR5S6Bk/J+BJoDLXS76GXm6uM4D4xn5E2OHaj2/A3R/CbN05w6R0IYPqInWQ1KItbpfEZEp3hz82dpigyOhaQLiYBge46WBtEN5bChse2XYT/uk7jDywH+sAAaCKp57Ti9yMAN92Js+uZl9LXPyEt0eIEH7+uFLyb12yCE7r6p9jvpfLhuexmbhH+aG6315yjWSnstbzCzjztSEiWXGldHBVNes/18TEr2yICYAT8HkIV00+9HGpX3wZl3sQm9VGeBqww1s2IugBf/9Is+Iquq/t0upbcIpnJ/ymZTZEMOMq2mhVy/PCJIvmszmyKIVqoG0k03XvT4bk0I2f4FGdCJwOCnBbykNkqwGaDm7sRMsjrYvVnZtbdJ1p1HNtH6HW2tXqTgOExCMaVl9LW4wWxfE8dvhlspcZ+igNkqINsKGdrnQGOl/rNZ7JpPC9xC6blv4Imfy17TY412arAFYhZuFvZls7oHpCjRNRlqws46wovVXlhMGneS/2
 Jk1oYNUg
 npgY/ypDFWQmqdWhhT20+PmXMtkR1RNwe8DaawBuSHIQrQ4RVn/M4jvTvL+p/6iBtfQnWcTQv7zxkXf0EJjNIi9tV5Yq+r5S+CvcYEEc4qvih4YjhMuGtDylYGnDFj4qx3X0I8L1LmTl29H9olpa/zv90IFcsBWuVOyzttbYwsVQJ2tYPL5Lv2MXW10P2aQs13F1aTVoGkosKjuszjrQsHyoCLIWYcmIBdtqESxXbwz7tEQVYVAoDv1rapgHxX5z8U4CLJo/LLEegaDocpTBF0LJz+nUyT5lBkvVaqxjeXXdWMH99xT4iewxEPFh7kKG9S93Hc4Zaiz/or5EVNsbSW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 03:11:27PM +0200, David Hildenbrand (Arm) wrote:
> I'd be very happy if we could find a clear way to describe "this is what we call
> user memory: anon+pagecache", if that could come handy in such a context.

Rather than arguing about it, how about shifting things to 'what backs the
mapping' and something like:

/* big long kdoc... */
static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
{
	/* hugetlb is a fixed mapping, but the mm owns it entirely. */
	if (vma_flags_is_hugetlb(flags))
		return true;

	/*
	 * Kernel-owned mappings are populated by their owner, and fixed mappings
	 * have a layout the mm cannot assume ordinary fault semantics over.
	 */
	if (vma_flags_is_kernel_owned(flags) ||
	    vma_flags_is_fixed_mapping(flags))
		return false;

	/* The mm has promised it may discard droppable memory at any time. */
	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
}

?

--
Cheers, Lorenzo

