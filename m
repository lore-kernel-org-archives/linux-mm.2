Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA7BCA5FCC
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8DC6B0093; Thu,  1 Oct 2026 08:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9896F6B0095; Thu,  1 Oct 2026 08:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851BB6B0096; Thu,  1 Oct 2026 08:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 633F66B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:13:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D58CF803D6
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:13:26 +0000 (UTC)
X-FDA: 85273947612.17.1DDA475
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 292F340002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:13:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xl7mxiDq;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790856805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3He6dk1lv+d03oE0kIODLca8X0OJPESUHdmrBphA8c=;
	b=faodQrTYdasErxPlRkiaeSr+tn2957+IqJGh+X+clWDNVpmHyFppBvXgRz7PzIAnxiOFkj
	IDl7DZpzoEoIv6BRl/Th0Z0LIi6YZHyUv9sMlIATmdNx0PLrCvj2TfdjJQkusF9t4arMN6
	MzZPBKe8QMu5WAdQdACXI7eu22YjrwY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xl7mxiDq;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790856805;
	b=8jOfhIvXldtaAHi0IfcGtjdfT8NsmJGZJG8wrmIYrZlo41gGZytoJ5NxYht3Lae0jj2Mz3
	7wCn7Ek7W6TxEa85sN8+QYy9twwLrpzVuxZYFi+HuWhVlDMpFyirgr9vVV/bgBhf76wOrb
	JbC4GVugG/7oE08eY+yG42QJbIw1ciE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB7B960A55;
	Thu,  1 Oct 2026 12:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011231F000FF;
	Thu,  1 Oct 2026 12:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856804;
	bh=B3He6dk1lv+d03oE0kIODLca8X0OJPESUHdmrBphA8c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xl7mxiDqPEStYHDqrgoerrLfkr1hPhZttyBeFQhA2Dmp3Rdc8p9y/gWN9OO3br7Yl
	 Zhwo0lzgeYoHcJDhIuV5NtOgDP1YH0Cdbyz1p9nV6Qg3uHFEL75hK8fN1Q8b5cZFbC
	 8Va1ZkkNv+tkZPD3lHW8F70EV4JF6LkqYx6mczjqOcb7fDxanM+pHHtDWaz99bGpfi
	 A4ZYUtois7DLpVA0ZtPURvYcWxxhdiRnKBgo/2ZXKB/fWOU0h9m7YG25OOgRn6N5Mh
	 mNadmlupayCLQJ9NhlkOhnqz+14JtL9advdUirIXqmhDSI6/l01PjDbKIcVoIbiYtZ
	 A7BapymuqJu4w==
Message-ID: <62e903c4-46fc-4647-b173-3797b2a77865@kernel.org>
Date: Thu, 1 Oct 2026 14:12:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/40] mm/vma: tidy up map kernel pages enum values
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 292F340002
X-Rspam-User: 
X-Stat-Signature: s5d7zpgj6hiabiihxzee1bk19chsb1xg
X-HE-Tag: 1790856805-955627
X-HE-Meta: U2FsdGVkX18cUn3tYpiVpxRAUyf/tSerz+RXicQrHp1NjwSXweXBKtBOvycd7Smu6kJjKFYfQAWvszWmb6s1+H6nZ6ZJNDuTdI28jjBlzrSRekPOFp0zQknoxnqzutSugYe4TmkfHWPNv65x+rYSceudMxmGSi1efYFgBobmhshkbe3oYFR4RvAzJqb+pLje6V/isZR0zmTc7s6hbbArAi4OVfypJw4G/tf1xVU5VOj2bZ63qXasIZwsQayEglw7QdoHtpRC9hymw6Wnx11Xyv+9v+3RtBhBM9wNAbijYYuwbg8VXHs4h7q0FAvybNs5dysZWN5bFAivPIpuWmOarKTF79Bp4iF/XR8oKfiKOqApPZaOL8fvok5ChApugTfC3S0Z4iu/XLntNfDaXU/zi9Fhkb0xJnOc4My8v9R/6rswKRuGyrErl66MjNVnhNHX0jJvqYPHa/i1hibJ+lrG/5UaRfA8DkC7KNzSuBAeqDXZtZbB6bdROjWCPQpq9r1UC5Yz+YoMoo2dxPTbnVHCk+yzebYRrnZ5ZMZQxKX4ow49KdUZrN2TDJlycud1X5v29dikfkpa33dmAZQT2CNDG+L4Dbfjj4iFz6e5L0HVoBVMQOt9lZch7iNno47tJKsPTyprbB/teC9n0ply37wAMPm+B80gveNtxrFzatJ1SXYaq4HKtVZ4/dupO8qxkULYZ9StS/woQx4HTsLjTwyTaSl3DsZkqHt4BKIj5f4PoLdchT8WvV+dSkcJLF8++4GoJSec2n17g95DBJSwTMRtoeOYVPrYbRS9jJcNag6TEJlAJSkapsWuOuCeQvqBqjUzhQCrJFYd/qARlSNjaKjjbYGHLyXKzTOz89IeZmJGt6GoP2lb2frsAfP3m225HRbRrHz/tUnJWqmsL25HvYSgdmgW9AKabyvxfWLzrPERQsLqwLIYjwxMqnACO7+GtYDeP6wCUNP+kM38UiCPTug
 rEfY44kJ
 wuJo0oyYZaCGiTeB2qn0oIPbEXFIrR9G+ndkv7+uqEvwhIMbZzNKJq6h5SWmG/M0OmJ/F2A4eIiJTeOUpxGkiS7qVBNQbco4RUxzhXTZAh5zWce2XQuSiDvbihOV5TP0r60sLaTvhCl7h8pqul3Akjn8nZN2GoheTIfJilH6apxhNkqkOdFM1b7q+siB1lHFXCFxniXf5rBu1kJbUFKnUO5ZHJGwbLYgdsfTReheDdcQqzyPibMYtkolmsrToZib6JxvZsbEihxep1oe4mz/KEdzZA4KqGHPrfu/n4ChsgIbY0Cf77b6QlgcJmwB5cC9AtgD+UWbZpzh2bJREFAooTtb98ZwHA+1AhxX61ZS4ofPSTnhosMW4NJvqaOdAUOG87rRPrQcw5vcWbOp1EbeCNZBaN5HZ+UV0yCkIs9MCfAJ5FweFXN6a3r2liPbuB9sKE3R4n5Z4ZPxI+dctIeXqgePslCR1Bg4OcB7oRat/PSpZlif83kKjRTaURQkejfLThgLXVkh1W7IOPZ1lN5u9J0Drmp35ql1UZn5sFZoscSVx1lZxw6qaK+XnWuU0t/Vu+SMWlCkcLGz+UMd/UoLaRsUveDnG8zhb2KlUeO7G/V2jHgt6J53otu9jG6dFgCYVYWLigfW2M51wqq59r5lb6zMjM+jd19DdwW8w0eJ3ts9nDpuTTkGh40MnFQzGsdfPfXEy18NNgYgSQbJt+4NJFJARvx5dxAhBo1iMQe0XURRutxx8wue0Bzag7npfGsRJww17vhjvRyUjvJmkDEsiZSyXNgtpMaoyKYCN9lS0I+ekyagua8tEU224yDFJ1WKtYpi6AXJNoz7PwzicmQVT67e11pvHegJr6rStvGe9jHe6nebUsO98HxkGD7L4WQiA55VG9wH09uetDLd2cR5FBkVYfnjpD3gpDs9ONaN3HjQy5uca6Ie1aE5/tQHSysYz8C5OzK78BvoHNmG0/uWEUZIyrC/M
 R2mvAFHQ
 ncRDWrOYL+Vl+GJff+22OvonzksKIFomOnKbTZTiAYVZQX88dl3Tz4XnqzJwAJBFovLA4qrdg3P17dI5jCH4rr76l3DL1D9+xeLIpn0UY1ZmAC7U4ZigXZ7qtTz9xgOWpL2AYeRYrleOOkEfhooP9GKQpA3zwLdQwrg9FFfdMOUJxpBx6TUNy3DtIvbV8ujnBDrqdPhdXy4YqMLPR04elNnY4wi4W58RmH1MVySQHYv6RZ4RC71WIXeaQEKfKudt+MCybzbyNql5snryPdTOaQpxTfZa3wZOwDkdPZ6osdUkL6y9jwg2qT421LCf/Q5RPTQKfDWvTGmnQOiXkOmOC8m8Xpvqpdw8Z0Ad+EqhWREXqkqs9HdG40GVKuGaj5S2M1S+xr+icjI0XBGxMlpnTz46IrEaJaoT0TcFYCyPsGCw7A8S9fZHgHudb/Oz5bmMssasCdteYtBDZSk+LDDuTKbiia2tnxcdUCTt7uuFb3sciTK7xAlKx7/3TStXczIcy08lcyslUlmqmViFcouD4vB8x+HwkGH+hovqv3H3bu0NwG7G4sd2QO3Ir2LxO3tcqk65itqAbXAK3jN9k2rEj1Vmc+wthQYxaQL8eiMsQC/AL9gl77dukVuknUoAzWX3iMD/YwfrT221LHD3eRY17n+yZcm0B4+mkhLDye/HedX56JVNf1YtgcBtCukGCNxth2A33OfXBkQ5xBaUbu0QKVQeYdFQf9T73VFwpeqvp0evWhAtxgZkJmV0r11E+8iIZs6HHl89gOxGS6cV0qd5YhGpd4O/EY9OqDGo+zwel1D9ZHCu6Qr1mUZdBTHs6Vt/VeAUsxO4FJ51dwtkr3jyLOX3mpPwsbmePV6T/oxY1F4e1R4ULIQoPmH5aTAr1H0rPYeVptZsUYlRwJmqZZcJ7weL1mKNommpxGH6lI48MpbRsWlqwR7yE6+XK226KLt0uVVgBCkHuNcGcebn40oQUhWgSpPSS
 FAW38fVQ
 ovGuR1HXcwkSD4ewZDHLu+qbAdJ1Bj8pXxUxxm6/72j7U/7aEpuE9vRObRn+u/EYeQ4UBJXdu2l+vjw6m3Ggy6+FVhWnwadFcinNFgQPHepwSVxOkikH7zm4xFWTbZbzDgQeqblREG4CtEv56NAiQVOJi3t8quZq91hwnf+80odS/8UCy2acbZxMzkvq8jcWvzElzDNxQLXVmlcBJ25n5r0KiSCMVOLa/TTDd0bOgHcjyHaMclabA9eKfR9dWNKhIlkl4aBQV/jpehUPO0Zxfe29hCSurSbBU1KOixmKqddUHXp2YD2jCprBsURo8fpbUGrIdqvriAqPHwH/V+BC/82mqkcZgrC4BH6V/7BDRjClvJ8+XtiBNJx5pDWTsH6U6KBibPXDjE/UwNmajVZ8QVvDkhfztRqu4ApKR2U+BtBnoJ4r6f/smqmw+gxhi2KAzycLFzaSNjE6Ze+lW1RmsOGgXLvtCi0JSeNxVxwoelCbOJ48cFUBwcmGTKMc1NT+vcAxNtXDQ6wknlfk/DouznI5HshUhZUPrs2AuCmXmMFqkhowX496DSPUZ2oSB5QWn5EE7J96DguEocBBYrwPh6HhhPn4LJdKcAqkm57j4s4nlRhoFwwOs0vLtK23cYuYuwV/TGuyOQgXg5NOxQ/3iof3iV7ZsHXFMca3KKTUrSuFtarrAUGsfa89MyTMtRHcYlLVy8cerBk5uZ8NgViFWTEcR1CWrUs1CuEfTLm+KYPBV9R/LCcv+xLCrRX0xtL1wjWavkoMO6rdQ45iewhW/VVQ5Gai+9pzwC8AG8TOWsq4HS019zKnHNbsqVihqLqcpPPHLNlhqib0tsVu7judV3+pQprqoR7sL4/FCfnf+iWSf8g1VJE5n/YEEucY3jICuiDtsvhnK7Sy5hQ3bQXNgqI+GBfZqxWhVWA4ycy6jkBnXIUd6LWgiccPfuWHuFy5znRKm+MGtofFah3kRHetSQQ1lhW6b
 Iws23zTy
 kmS+PHKNnDwFn+cykOiKPEHsc5MZkqqOf56FhyEr9DwKWcBzzRz1ru1llJSOzXiSmHLeKI8PQzkMjuYilD8dgllqVqrjxbauWhJ6KBB7b7Su80sBsyCHiCXV0pN6CrCnqyuEEadswoKmZf76FrivCwNZXZmBPBMVe8lJjBj9HG92u6KbFIwsYMZV5NqKDP1e5GiJA8k8liEM080B5lpwFpoGVRtuWfcLPFbGy9rWgHNWztdcvDHssk+skve7fMNjfqcLnLAG/3EW6POHGLlhpMTWPzZ+kh0vf8SU3tz3id4LVdAxnHU9HrXt2m8JvsIYTieLFPV0RKWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
> MMAP.
> 
> Also while we're here delete useless comments for mmap actions whose names
> clearly indicate what they are for.
> 
> Also update the userland VMA tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

