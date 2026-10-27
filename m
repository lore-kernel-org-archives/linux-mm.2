Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6998E606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 01:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=P6A7cpQQ
Received: by kanga.kvack.org (Postfix)
	id 7444E6B05B3; Mon, 26 Oct 2026 21:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CE66B05B4; Mon, 26 Oct 2026 21:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6326D6B05B5; Mon, 26 Oct 2026 21:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26A216B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:33:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 942A81A08C2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:33:53 +0000 (UTC)
X-FDA: 85366684746.19.FE18518
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id 411AE140002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:33:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="P6A7cp Q";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793064831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdbWZsvYj0rKy4CApupNo75UEMIwmD/zLLPrgjCeTQg=;
	b=Ns/VIB3P3qMZfyXMpruv2nd9T/F9Bss2HVPknLPG+408MaiGwaP+R1W6ZRFz96YGl1/3xn
	Yl5DpdxOZGmX6CuoTdHZUU6Qjk1aWZFV4IZB3i7y5j9jaA0N/D/iPNqU1KMMEYYaqjb7Ap
	DyrJs5o6uXPXOs5X10LwcwX2LWNM4P4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="P6A7cp Q";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793064831;
	b=UZRjNwDMjjtz0YdRQFnw8eq2kXEwsLFD2s9MacXkv9eYFoNwjBgmjqdr1Andzmjafi8dPd
	+AwNE+9Aew/WORGWAivILY3cLJuL/4D6zbMH5HVsV/rDamubewLom6GSZXV/pzgu6+/jod
	8xef4zYwVA+3w4ju7tRkMzLDgtqf/CA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=kdbWZsvYj0rKy4CApupNo75UEMIwmD/zLLPrgjCeTQg=; b=P6A7cp
	QQ/mw34219jr1ZuLpn4iamDW/lpfHuUQAejSgfd9BCQ+6dbG1jEIeTK/B5qrfXMwDQwiwYopkVf89
	RDL48DJQKppMXWlSLowCroa4B9N8NkB9so/a/O1EdaipGzthBuOgtQ6miY+TQlLi0Gc23kaqDGhbz
	hFAg6QHgsWRPBKIc9fgHYDIRtSnzsVLvNkBDVBSRTMzZkClyzjAiC+5YQ76L8OgzEtrHYkiog8Bon
	SZNOnQbqg0yUwWcATv7qxtnIAKScTap8K5B6T16gJc3jQ3eRGg74sK4y2Ml94noRb+siX7pAMTbQ7
	ytwibybZeR87iCV38mXRV3hUtenw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLW2j-0000000AyHo-2cK7;
	Tue, 27 Oct 2026 01:32:01 +0000
Message-ID: <03495f2191fe78352042d859b6825e7231239de1.camel@surriel.com>
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton	
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko	 <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt	
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song	
 <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen	
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu	
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>, Kees
 Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn	
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins	
 <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush
 Yadav	 <pratyush@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Lance Yang <lance.yang@linux.dev>, Harry Yoo	 <harry@kernel.org>, Alistair
 Popple <apopple@nvidia.com>, Nico Pache	 <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain	 <dev.jain@arm.com>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau	 <kas@kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, John Hubbard	 <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Will Deacon <will@kernel.org>,  "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Oscar Salvador
 <osalvador@suse.de>,  Minchan Kim <minchan@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,  Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>,  Nhat Pham <nphamcs@gmail.com>, Youngjun Park
 <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Ying Huang	
 <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, 	linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, 	linux-cxl@vger.kernel.org, Josef Bacik
 <josef@toxicpanda.com>, 	stable@vger.kernel.org
Date: Mon, 26 Oct 2026 21:32:00 -0400
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	 <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 411AE140002
X-Stat-Signature: rzagndt4sj51r7jsmdtjqsn38w46jhos
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793064830-416195
X-HE-Meta: U2FsdGVkX18kj0NOu52G4rlibvqiPAEyIuWsd5LSPjPTm1DGPXHKyjVWn1P+zP8c2xkQ/syF+AFJUeXM0JNSQVp5IOpdF6QJ/m2lR7qFY/9+iI1TAHi1t1X36xkduywUHXIr3dXwhtgQ49G2RUU6dMwYhRGzizN0o2JpcsyrpYwpORvkACcYxODLm8eNg1ABjDp5lCo8hZj4cgWg8IUSGgUUzI4kx6Wygq2vHPNbe0+l0bufOnkHwEMAri/Xy7Ex6/0UbNRkzPVk1Lu3SANpw7pc0gNK8ngg7EJ0GaK/oVjBZh8z6lGEYIHs6d4Llo/I7wAfyD4soZsslRqsDAzO2oXUTPDJfqu3HqidUMeoIWcHV6WO4186nHR43vj2pvgorJmSi0AI/XryFWJkJjeSFotmnU+1vMlMgiO0j9SoKHUbdSNmmKzrlgb8bOqufFoEQjycVUEIhyRmZUUQwa6mkWP0lpwMPSmHe8xBA+ROiiA21sTh7kG60h8BvAUtACQ4GQky0L92/3V2GUK475ePaAfg3B4lTf9laSWgzBtLFW1KURgKh2FWl2Am6XSTKkjCq3ZRLw3xHx/voBqgezMYtkw66BNGVU33IJS6b24OJriPQYXHnvossRLne0H6BzMTCCwnzEc4rmYCWvp0yvu4d0FQg3rxEXqiN/vMgHfjsCsJitfOu2fAAhG5RCHmrITPwIrBJ+tEMCbK+og6NTc3v1C+L8gffPGYX8DdIV2UIUe54BS5w33N9hEE6HQe0xGb6btoxQr02XaQtwvcDwORteilwd2ixZvRX2dAVxviwl8xv9npcVRr0hdIBH40zveeOKRrpTUOHevazULeX37bbtfB7FtThh77VpweFt1O0l70c8OJ0u9WD2dNa1KGGbciqXRx1QQ1BCQ2uyFp9qkOsaKBVhmZ0YinmY2NB28oHr2kqKJdGkMYuKLcFTAcmYwQlT7ZGCihEkcWQUxQIp4
 z5AIkUWL
 EBngdwWdAnLxtFSSByGTgf5LdGWr2zZNWaaZrl5u6dwgzTXJ+rJmzlX0cEoiGA/JBvb9kJ3BieJEHhSpZdqLEWvuwptQ1E8oHrINX5Qu3m1RTvK1mjZ9+XaKT6f+huBF5/UsEBrfp3UvzidYPiP9T6LjMdPCMjMPD2tTVCO/nS9KxaVVc3gVsR8GvOP4v3u3+JdFpWrsreWxlBx/d0s6SAuJWgnh3b6wOuw00X8AAGitg/WKKGTN5evnjzFvV4b6pghova+Tq6pyHuZtaFzp5NayJu39rg7Qlk8Qnflh1H1KNqZcmZQ2G1t2JOnPr9VChpJBcIy//+TnsRA1beBijWjQW8n0Cz5OZaMUsF2ntLQ9zkXTSZ1t655l8wyv9qo+8WiPI4AjxKL++4/LoEcjCLJwCZ9/TAW43d+NlGs48uU7/bB2iPWjZUpvrjCgJQabF2tBGVzMaUa7zFV1APVnQG+D8SCXItTE/8P12Q5WP0vCCdfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>=20

> The fix is simple, so just fix the original commit so we don't have
> to
> speculate. To fix it, pass the actual PMD/PUD pointers. This restores
> the
> RCU-protected lookup and validation against the live PMD. Note that
> the PUD
> handling is required as well to handle folded page tables correctly
> in all
> cases.
>=20
> Fix generated by an LLM and sent by Josef Bacik in private.
>=20
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: handle walk_pud_range() as well, clarify+simplify
> description,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 adjust Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

