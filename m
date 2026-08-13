Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C1FC5DF66
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBB96B026F; Thu, 13 Aug 2026 06:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CE56B0271; Thu, 13 Aug 2026 06:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A576B0273; Thu, 13 Aug 2026 06:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61CBB6B026F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:40:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6AC080472
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:40:04 +0000 (UTC)
X-FDA: 85095901128.27.1FD2B61
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 93030C0008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:40:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=r+6bX+6A;
	dkim=pass header.d=suse.com header.s=susede1 header.b=bK52L1D3;
	spf=pass (imf28.hostedemail.com: domain of jgross@suse.com designates 195.135.223.130 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786617603;
	b=ea6wuRBEG1jqBEHsHPM+bFdSwaPJpXBsidRhLv0wF911Z1ufQKTwTVC79iItnBllvMEq41
	nrZlhJWiW0n2og9f38ND7SqMNtqurNN/Bpc3zO0M9dEuL4wBgZ8EhYADq3o3ovd15441Bo
	o/rgsPzOGcUozNOk13hKtdTw2gxgAPA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=r+6bX+6A;
	dkim=pass header.d=suse.com header.s=susede1 header.b=bK52L1D3;
	spf=pass (imf28.hostedemail.com: domain of jgross@suse.com designates 195.135.223.130 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786617603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mby0JMgwZ0EWkWrXcLy1dExsgwJl7Ejt0AYuo/6h5Vo=;
	b=ENkedcXp1YRUMU+17rBfetHXY50xsK64qVkP9nS1IHkin3vlh8wPvHS3XdCrseKyvoRz3J
	73jf/ISvWaA5G3G97mZiA9A/IXOYU+hhApXLwtwaJrMFo5sfXGF8WIAw9XD76G59qsB4l2
	uhudXPCbuHtCmQTQiDi9q8n6UrGPAA8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 834FA8262A;
	Thu, 13 Aug 2026 10:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786617596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mby0JMgwZ0EWkWrXcLy1dExsgwJl7Ejt0AYuo/6h5Vo=;
	b=r+6bX+6AWVMSGnXZwwGsjPOwKRWDz4mLOKQAL27A98lhztNodMiwfm4ZmMPVBPB1VO/r3F
	TK0wWbhHXPT1Dw530qkI9vEwXAwKZn2kNoSQbU6sdDxWvatlk1yQjiWeMHDy9lXEoz7V7f
	vuh70kZAUJRiXAzxYvRonjRzltGWiis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786617592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mby0JMgwZ0EWkWrXcLy1dExsgwJl7Ejt0AYuo/6h5Vo=;
	b=bK52L1D3K9mbxDOsdWNSb6O2/celtH2wKe70H4hnLOMq9n9cltPsYMfOJgZy6oPXQT7jGH
	BKVxeZ4Y0Hxxjxw6tw6mfoX1eoUfx1+oVM2F0ZBpdCoIUKCUe+adwArqJWvT5+Q2DGIcAY
	6UyBb5DtERLTA68VybMXZzHKZWXBF1w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 259FE77D97;
	Thu, 13 Aug 2026 10:39:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m4H9B/eefWpBaQAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 13 Aug 2026 10:39:51 +0000
Message-ID: <47c411e5-5321-4343-9aae-9e16dbaedfad@suse.com>
Date: Thu, 13 Aug 2026 12:39:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] xen: use hw_pte_t for PTE range callbacks
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 David Hildenbrand <david@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-10-usama.anjum@arm.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20260806083926.1807279-10-usama.anjum@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ypKYePDac7DgsbAphlTma6Kr"
X-Rspamd-Queue-Id: 93030C0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9anratbuyxy1ox9gozgo5skqouz4pepx
X-HE-Tag: 1786617602-207690
X-HE-Meta: U2FsdGVkX1++HyDtcJ+TixBCshe4XvHTCZMshkQ8C554bx7JsPK6RHPkTYPDQBTiRjPEnuQYSv+xqn6LhSP7klTpr3kfNSTsP0D+VaCrLNRz1JsaPMq0/1wtJWNd3yki8suUkL5w57/mJqYyym+R6BVB7zfJJv65XpHFIaeieGuis7R9uAyxWgNPfAKpr4Dn6XqLK+5w1rZEkQTyfxKewi8+rapr5Sk2xslx7pCuGk2rCo2a1EfpGKoFRS+8VrTT0aW13kOC069zj6U/K9iO/HLs+ceENoN5RLwv/y4jSGO7qW2G7zjDD7Ez2rBQU88B2QYsUoz37SsbA3VW3hbX2kSjc21Zv2ocEeZ7ceA94uZo4FRudi7QOQHJ5gewwjDMHs929UjxjKmFJLF+vsJ+K2BCGA8JCMhiKlVrQ/Tji87zSSUBOOqoOmuPntCVkHAmfdOjXzG3MSK5T2uaEPZbmDDNd//ES1+DRFCprF9QKJo9+K/Tp+RofV3opgc1LBPo/S9pCtU6RcApNnek5p5kpMHyV/mHhXP7GqnFbgmzN7WNZUh0wRW1UdBQDbKXZP3oUUWYHKJOGtHENDsVD7HcuUqtkQ3bQoq382WK1gq97rt9Yjuxk54fw40Ykv5ZZm8SPafbPkwZuueITbaB/3d6lqHco5ER7m8OC1vLrabDUsm6P5PkdKG0saspNeSlHAv6aLORCf2QirQVgmxsPk2jpURFjUuD1hNu/bwf8CQmf/RtkOk0WBewm2WJcMjwmsrjtsCKRveae42h2Vdl3DB7NWVvvWl/9sVUyDJCFdj/BAoZqNAZghmIOOLGPLEnU3zUlRB8N1Sq5M3r8aEOqHnKtjHwVbyV7POlHKGg8VkPUjp2wbaltclBOzj1YzqLZHPtufAvufoBJfivMvBIyjNbeNteu2YUWnDEO1b2bnU/itFlhBohkUO+NIt0gCAitMKBReMYTxJp6mzyPgLNUqj
 J8cYmUDx
 ez0eNHbMxY3dYOayRuPHuokb7mnG1QY3gB/hlWVX8xtKzufn9LeX/8fUnNAM4/bR/Z05u2tRPc1myHE9Vq7As/mW275Os44YMRt98d2cBzXRchhglfVyaodpgCpsicABM+fF6Qw7sXtjK7Wln9V7kz/NL/nAOffBvXyW3dW90vKZXR2NQti1cHyDik4ehPpwbCw2wjdvHZpPzRVWbgmviHoohNx2wwzVWJ4XRwc1SWrojUU0bRFxEUC+MOchLJW5mgsMDLIFet7bJTy9a0TnU967h9PiJeHYZeHCxsns1tfrWhCREP0ZSxX/IpiYOHrUNuh+liRMZ+yIWnsvaSajUJM6bUCSmTJ3VaD92zXMCDH5c7aOhLi89z2Q5vyIKHGOaqPqev/O2dbTbGrpBkMSVXwUA65viVJhWOvu3dkhmgglHNLWjY1pnH1sp4BCfJxlEyRBcolj1QbHSue/rezvCh6XOQ6Sq5sjP4p/uOeE1yO424/PR6gWqCNWS8ZtwofyEMwXYZ8MgvMBTAaBCnrH+Wl3hyVXByIEKOtC4nNMpTzAKmhnMSbPfCo2WSlw6/vnvwR0hD7+kyTRRIPKrKtH7FG7sKcZt8bJLZXPAbzkqe1cggRrhgCgGGvjkKYForgbk2+BLvmelYv43PIGQE6Mna9a57JsrFBNVbiUDG7gclgUgNi0SPpoluQ7zZ/tdW17gqRI8DyJ3nrTDNzNPx3E+ivxoIlZw0fMMas9EBpElOx2ja3q2ftdEOvKXYZJ4ToJWUJAKussWVCripMG0m+T8h7+qpEJs9DZS2EvIVLndKDqBzflbfAB+/a2+SsIps3ud7L1bs6t571zwX9StslggALqRMMVjNopH5q7MX0Q6iUYCQMHd147AwqjyekbtqQoyhNQnZemPhHS1ozAj/AOnm6lkZhJjwLTJO0X+lBVMbq5oU0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ypKYePDac7DgsbAphlTma6Kr
Content-Type: multipart/mixed; boundary="------------c720gI9EPuLmVtPBwUUV3q9s";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 David Hildenbrand <david@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Message-ID: <47c411e5-5321-4343-9aae-9e16dbaedfad@suse.com>
Subject: Re: [PATCH 9/9] xen: use hw_pte_t for PTE range callbacks
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-10-usama.anjum@arm.com>
In-Reply-To: <20260806083926.1807279-10-usama.anjum@arm.com>

--------------c720gI9EPuLmVtPBwUUV3q9s
Content-Type: multipart/mixed; boundary="------------N4sVlTeyaJaCa2dXXYReUSgH"

--------------N4sVlTeyaJaCa2dXXYReUSgH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDYuMDguMjYgMTA6MzgsIE11aGFtbWFkIFVzYW1hIEFuanVtIHdyb3RlOg0KPiBHZW5l
cmljIFBURSByYW5nZSBhbmQgcmVtYXBwaW5nIGhlbHBlcnMgbm93IHBhc3MgcG9pbnRlcnMg
dG8gUFRFIHRhYmxlDQo+IHN0b3JhZ2UgYXMgaHdfcHRlX3QgKi4gVXBkYXRlIHRoZSBYZW4g
Y2FsbGJhY2tzIHRvIG1hdGNoIHRob3NlIGludGVyZmFjZXMuDQo+IA0KPiBLZWVwIGxvZ2lj
YWwgUFRFIHZhbHVlcyBhcyBwdGVfdCBhbmQgY29udGludWUgdG8gYWNjZXNzIHRoZW0gdGhy
b3VnaCB0aGUNCj4gZXhpc3RpbmcgUFRFIGhlbHBlcnMuIFRoaXMgaXMgcmVxdWlyZWQgd2hl
biBYZW4gaXMgYnVpbHQgZm9yIGFuDQo+IGFyY2hpdGVjdHVyZSB0aGF0IHNlbGVjdHMgdGhl
IGRpc3RpbmN0IGh3X3B0ZV90IHdyYXBwZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNdWhh
bW1hZCBVc2FtYSBBbmp1bSA8dXNhbWEuYW5qdW1AYXJtLmNvbT4NCg0KUmV2aWV3ZWQtYnk6
IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCg0KDQpKdWVyZ2VuDQo=
--------------N4sVlTeyaJaCa2dXXYReUSgH
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------N4sVlTeyaJaCa2dXXYReUSgH--

--------------c720gI9EPuLmVtPBwUUV3q9s--

--------------ypKYePDac7DgsbAphlTma6Kr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmp9nvYFAwAAAAAACgkQsN6d1ii/Ey+y
sQf8DyaOHOavz2N3DHzJxUcqzEKPvct49YGYUyCWLiVDfpU/dpETsiy0py0gy/1OdKNz9fB5DRbe
8Lm9XXR/UA/+mo2ngOV0fERizvAf0WXGi+VEEW7PDzNBMu5+fTyUHBsdVauem3ZGFNpeLgtOb0MM
EcqgvRhDtW/55HrfdAsGA9Q4ivaZcEuTMIFI3ojyqkHxgNQikEPueD43Bxa3EM+YOonkbXl2mQUx
xH2+0EIyIOPaED6aafGCFJfGlEgXupdjwl0OO/KOkyheUpsriWyps3GfVCjT7AyeOZuvtUVi4Shh
FWH5ZonhLSGDNLa3ew45F4gx0bBMXKT8CAuY/VKjPg==
=OUNy
-----END PGP SIGNATURE-----

--------------ypKYePDac7DgsbAphlTma6Kr--

