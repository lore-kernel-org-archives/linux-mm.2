Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7678ACC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7422E6B0092; Mon, 12 Oct 2026 14:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719F76B0099; Mon, 12 Oct 2026 14:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1BB6B009D; Mon, 12 Oct 2026 14:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BCC16B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:26:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B84E6121217
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:26:32 +0000 (UTC)
X-FDA: 85314804624.16.33E919C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id F3C20140006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:26:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Adqk8751;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791829591;
	b=1JI2lcSq6URVIGL2Yp2Po25adM985Pp/UQsCV1Eiu6GPZYg7k3+YCd2RhapDH+cVKl3HWj
	nBg8cHBQXHJUv6xfXSID5DBohvaJM7U4cXspJvs3CtpLlNk0yNsUYGQOSmsDXXCmZwfx23
	59AeeBbp3dbgmJxFD8omibD6tPv7YBI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Adqk8751;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791829591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRzk+a0cD7nR4Ew+1fSPNdzcKqVkC4K+w54CTbZN/Ik=;
	b=RUBLU0fLthpqpAw2CfJWnpVvUW8k3XG4QIq/NUV6TWvYLypxbZc62oSdsQHJxc9TLkBfe1
	ImK6bodauARBFC3VeF+vd/ACY3trWjDmdg7Rh6jvIOOtjKxB68sDy6+GkbUGG+aeD8IKfg
	xboK4XKd6pwiKkoVOL1XIc/gwWhHgDY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0132E60258;
	Mon, 12 Oct 2026 18:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201381F008A1;
	Mon, 12 Oct 2026 18:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829589;
	bh=rRzk+a0cD7nR4Ew+1fSPNdzcKqVkC4K+w54CTbZN/Ik=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Adqk8751wa9UQtQQt/iIJK7EtFXxEt2A0HNLnPnGczCoRpgyLCvq8fvnyBveAryL6
	 j9ReEDeytDnObYN9Bt97kB0walwqAuIcEaD53BEvjwML86lDcrAXY2K+Z7xwQKkxGp
	 wzpG9o9NsyoU/fxmF6ca+gbe4z1bnBBeghUipJNrtV5POLFFuvnnXCOrF7c+Du2a4D
	 QZRefuO2RXpJLPaHfiac1ocAqOpRROoWnzK8HvgBobS6YtQ+J2yF9x5lONhJX9vwQU
	 HZ2bzzd59OsE5eXCwtIvflqno6gdE1Xb7aC/mVKgTuCnIy+va2tnX0h8oyCEjUi61I
	 johOZsrvf6F0Q==
Message-ID: <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org>
Date: Mon, 12 Oct 2026 20:25:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 24/38] mm/vma: enforce that mm-managed mappings may not
 set VMA_IO_BIT
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 57ec3ahgg8g9jonbfepoa9ray8udxbhn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F3C20140006
X-HE-Tag: 1791829590-684779
X-HE-Meta: U2FsdGVkX1/NYcjhn6tM/CoqBqOX/7y/sAMX4E8WajETwuIofB3LIKZDNR4lkfEnOBJ7Zfgg4Tr2I4RAg/ROc9X1OI8n3eQm9KozmPHN6A1T1XM8t6syZ0UOWmgnptdd52YMh36LhxjXac1F7BDv3cu3eoby88JxhUX7An0dUbJyaGR+9kzsIBgbM5rYCh8acotC8pu0r09v61HyfgAeWK8E6B6O83cTSZM82pVFhmYJMeBDUc2tmMyWYJHy11Efl0WWX6jvkMX3vJ8KxqMwI/e5JW4qFRqUFNaZ2NY0OqlqQNjve0Q6ldHfcJvlkDfNyOresDKReOVRkrycEIIj/y1uKVL48cylAtyN2bng4kr6X9O3Jqzi8Eh1zV6Ewo6c/pwcEE48w5+03RzdU0Ku2REcyTgxUSyiyfS05sjDUuBpcDdbhVIs9PcNojgm1UgwtPB/2ahjr8e+EYZGyHiSluzLNCksIF/52VcmS+N8+01KJb6S/ggbAnsiNspoE2sv84BXmNvBRbUT1dgT6yGXWqeSGkF9Xyp6dH9VbthQ+4Tab0JvZRVUzE9RyH7GB1AQe3RX3Ad+k5w3s8aElAbZsHoLtQw1AAnIoyBv6YpJh4G/WqZS/PYijOtOjiNDmHpV47Ea23dMRVBAI/DkG3zQhr2tSQeWy1BzGgeyzngse6o35mwkUULLk8hU9JHnBMs20jTiU2sR6ykx/Msx20reJ4RfBx+2/9k4SO0+4LT40aP+O8fLp5+YLaTZWcdb38pC5Nj0fZ0Iur4lMCFFvreADKaadYXkiWig0xIUt7uXgA7rdUqjMHkh3gByOdi+Q4wc/B1mkQv4FkwMmhPKq2nh+qvujobtZXC1vPGwhy5cQYZZ5eXLGrUwA+5Sk0wQiNlwncugpgZmqlg1YqC2nm82nbM/Z9lK+JWntOT4n2kK1lqG94WxpWIrNDunFAEiX/4hRBI60ilnV5hCzBWHeUz
 Ag26qmXa
 ghl1+hmDE35Ul+PpDR39oyqyzvLfPmgY3/nr0QByHMMB8/m0k5WBsSjOJl2134+CVqyNfNTrw/5usMsEdBLZ18NDKAv+qjhkET5Y3fBKY01T2CCqkfgS9vR4bIvDVBmJ6x/CTJDjWAChM6+/urC/zH06lq6dm4nzurJiNqURM0b5ntJg6hTd5I8tbnUCx4LyTgfwAssAhDGKzecb0pHsc41xSgCYT7RyqIfAKCAnJS44aQEvb3vDz8xv2HFVVjnWzOC293oEcuix3r0ku4us9807V0ZOO+Rw1m95l4/HTgIJBby6Deth2QEV10MA+og+p/7y3CTNIGF/bIu+vy4gHweel83OsIKnLQUvA4mxmfnmKOLoGFcgTFmQJ+EwisJ4C0dsBsxzL7O30JirBw0CIecUOZBIJhkbPBB1oS1Zf9e6vxDARJRuoLTHPujYsDBra/WgA5nbKRgtm7kU/pYNVy9CB4f21JrrtAWXA1BSsIMADdvwbgH/9P+wv9hLu4Z249QzVowANkqSQSHYJt9qJ99w6hqf+60MP+IR5KeNWLGM0gY5GyHBpQc5bXMCW9gmA5PX9BXOzupDQI06XN8ulihADdijAiLSLEU4Q4z7qwWdCkYR/0jsnJ+tP5n7QuiCSFupEo0qW8Eb0PZUNH7vp7s8iQY+cUjp9MCs0fT4YibDjuFwCHXLS8TRYAsb/4X88ykMLHnRhUqhv2172DQGDT/8yaBwdP5ugQYQP50sguWTcFexlp7hSGqu1yhI6Qb18fFx8xZZrSh76shvizfDVugfoF3dpw1GrREqHx0veo0DX/i+2utw7T8FBFWFG3PZWZ9+tNkhPzf4ZlCcScxhnZEB4bIbGk/AcnCpS5/vofjSaRrD1dENo6JI6XQ2TsxGNl2N/lBUeGsq16NF0Z/Az0UKi3t4zUtTzsatpiHBSgG5mM8QJ1QGaoo0KgO2uC0cEhb38Dd4YIILaFfduIvzKyTKp+p1C
 E+o1neNs
 NkvwD8eyuat7Krw5S1rYVBV9w256zX5Mlm1OFOEi5rZk0dJtbH/GTOKnhWEUijFvlaiSBzr08o+dqUkUlgY3Qxm5wW1Zj/bVM1UOMfri7wB1U5xCj2FUszWceoKEP/nq6jz4Iq67zgkNihR+HHEvuRjHx471nyjnBVVpJbSwRy4t4JL5T1QfmRlVA9dtQcamTvhLZA6wETBg1/kjlv7sbrdXkzhzzyCgaHjmd7zpkbekX2zTRcmz0GxEr0GzNOSM6uwzpHYseXV9Rsld5gAiIlXtpV2lXFa/14o8am+veINx8SsibyOm/+ltPdfK+ck92D7HjQ0UAmR5oO7We9z5Ak7fSOWTY9V8B7OncjB2nYIzw/PxYcE90mbxCjwQjSiGcBN7h3YRFxPiCmNASk6ddk8EP5W9cagesLD73ILk6H81g2Ex5TMLbjVRA6wkpy8q/CNktF22PoOOVwa2694qA07e8M09KfnbYkMQFy40ZInpPiwOXyAXwuX6/O9Pc0EzpswfK5nsW/9pfK7uRF64fcGMm0ygmmnhxdwQ8VFU/mdV0uKjA1W98nGNODlWDHMCuhhSuS+3g24Xgvn/QL7BDiYC55jO6Lp0sC2gMpbn89jO1sxfrWKi2uHCQDo0ZZpS/BASIGoQUIMODcJg2vjgFESC6FCbhKYy48PObXWg5Z8R6VPCMB4lsAENITj3giJaVdGjqz97PBEWHzzG1gmep60L9txUeuVIzJm8PG74al6+UPPxBspq1HuykT9LAQMXnaXj9/aNOff08EdR2Uli8mBexY54rbrKzHR9KJj8Wcj44scjBKHqzA/izWfepHxIKqRIYo3m+BLsQuMdVhlqMAVy/S5oTDyQWOoEMpdlL/6xGWBK8dYKeQE8olCZUD0dgp/WImzkhk9illZwQQw3RG7rbX5jC1RT+hQAZj4SRTKNJ9p2RijxCKi8j9XAeSqZsb89fPhwP2dr3q7jLaIzTyTLqo9W/
 aBI+6C4D
 HxyMwolUI4z9CIZPWPL0y5UPycxGQX+po1AMELHvLzekfrnTbf72jWFcW6LBYhZSpMY6VHDZJ2KbxUdIcJ+LUky9MPBVQXOUeFXslGEdivNB7v/PB0g0qOGJyAg42S87vuxWb14vtsfdluX2Q7yScMSR9IjNgoevygRPyWrhmLubrZD5wj+CeuUwlW2Fc6d/t7fvIgqLH2HoEHIFVlMDauZWnWR1C+NiAx+b9fdp6TrK10n20aNM5x7tU+F+kyQegXb/i0c2C5p7iZQoEH8ySxzYiDgWm+N/Rv78seTSOXkWGxtFonnOLVHa51ymBa7CsnqsA5vsgHByy24a7aeIASSKmvqPBmRe3bkVUFgG7bfJ8QfZBXshx9FwgyrZA+t8xyVNxACcO6d3VpDnJhnleHyxiWeh0ooz4vh42osaTXYALwla8Q9Y9Aq6zJYWOONrG3ItF5SjvMMc7U+YTTAbvpi2IxiKvOu/wV6PLx6w9auzQDxu1zrw4jsD7jYondRUOvWaWEoqtXxwcY7y934r8KpHh1A9GWVEYxs47d59mcqQbElTU4s8+FmJ+eBh/Hl6CcSmc29kHBe44XM08T4+sZhxS7DbfSuNIBwc+5ipatSiqssQ/kqO/3F///Y8RMCu387Hgxtpy820MB3eE/e4kERvnTqgdfi40IXHTi9wUxe1UtYlt8qGxtL6UddrL7TvDzSAMQUqpAcRIEJhJQlZbz8SScIbDAV3p79rjlnFSbECxcTcAuiaED4dkTGULB8iRi0fQtxOi0ZVznPppXiviHY20SsyxwpeZBZietU436rK6L5DPfPCU8/9x2tBjRBVkirnj8O+I9mBkfEpib8d5N0UPWfGcnq+2BP/39I6JO/wf3gOsd7OPLoNQoNbv57+nUe8TOXo3iBts5X+o+2n0vE1qnUas8YGnvDzjmMDx9iVS3XyfFYt+rd+OTHU5nr1zAt929KnaOeuEVB5FTSN9Qk/KkfQ2
 X8VLXhn6
 /tbZY5ABl9TKWJg//bNvACy4ptaHg6uSY+XPOnmAPq+E1gHAgE5uLrmZy7HkZ2qXoiBS2raIq689bjfDvPJkwNKHQOx2MpEYLIbjlqYQFTYJBb3HeK7zY2y1BeHQTD23wrF/fSq72/qKvmYxTbAlyaX1pD0OtdXGNZxhE8qQ3/AUX+7Y8lHYvwupUW4nYpKPw0Ms5TKqnJoovCgXtb64JEginn3HWNq7wQAp+C99sNrayOVbD8YPZlExKmZ4ht8zcKpgbOEMg7xkbvi61/zPlaUTPskgRbdly6EOPZKlkLLQ9i/p9+cpHpiEsWv9M0EwdQTfMQAa4apDs6T++JbxuZxMVPnAzeCnTErNnGFW2p+MItV8CLtVJ++8axpcAdNlpuIHPhbuF+4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
> 
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as not being mm-managed. The check WARNs and
> fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> without a kernel mapping.
> 
> No functional change intended for in-tree code.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 4f09fb98a2fd..51bdbe08bb02 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2796,6 +2796,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
>  		return -EINVAL;
>  #endif
>  
> +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
> +		/* mm-managed mappings may not set VMA_IO_BIT. */
> +		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
> +			return -EINVAL;

We do have a helper (vma_flags_is_mm_managed()) but we're not using it because
of the VM_IO situation ...

That's confusing ...

Could we do something like testing vma_flags_is_mm_managed(), but removing the
VM_IO flag from the checked flags?

Then we can add a comment about VM_IO in the future getting remove from
vma_flags_is_mm_managed() ...

-- 
Cheers,

David

