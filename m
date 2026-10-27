Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4134D606A330
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 01:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=hLHADdJY
Received: by kanga.kvack.org (Postfix)
	id 507656B05B3; Mon, 26 Oct 2026 21:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469FE6B05B5; Mon, 26 Oct 2026 21:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A0A6B05B6; Mon, 26 Oct 2026 21:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 033F06B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:40:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B61AA85C6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:40:05 +0000 (UTC)
X-FDA: 85366700370.09.4F32C65
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70910C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:40:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="hLHADd J";
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793065203;
	b=yI4iv7Fw4E2EsSmYufuV1PFGD0+jvWXBKMXbaMZmbfB07J5xLXDucrJLSrPlz4my+0eB74
	wJ3PBq4wUkT2JwirRhJNh43hPzkc/iPT7UqLz8g+Yw+nHXnjNRt5QloCzXmEfGgQH/jas9
	X5k8ZU7Ipm/H92f8hiwxkPi8UyhGWDk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="hLHADd J";
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793065203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUuA7+chWIhLu+qX3DDV5gWAGrlrfczNAdJpLXe+OFs=;
	b=5seDDMr9SXz7cyjBb2xo+FDaT4krxHKYAjrNtrCuJfmkCZllkmd6zyVyZ0t/n65i9iYDIL
	1sKlvuVc6aLUnAB4P0YMVhaDer9DhgSJoZrNoU43K6gJVWGZNNlbiUV3vzzEQQe/WKxh7f
	TUaASLz9o8Uy+3LZaTUBoaOObPjHEzo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=lUuA7+chWIhLu+qX3DDV5gWAGrlrfczNAdJpLXe+OFs=; b=hLHADd
	JYpcXFYTdIkRnelJUktscfivm4kwDbjgCJ3oKz+6xIqeSecb3hHKgagunNCrtnoqN8IQD6/REH25s
	oHxZyQSCr0OSEiqSi9Os1mhnjxwRqGWFbbumNQDd1oEhret8XLlNZtgONJZyTclZm5WpxtQmyWuhS
	8hjwzAqfRD5ea3cepZRKgnVd38mXxeU0fx0Vvpx5yXaqmpkPi1NIPFAjqK1QEievZKt7FLcbA0WoV
	A1CkwiQYO2zNKD8dQNoCPMBm3AxtWxJpcVyZPk1xkQAUCCyI93gHTEygLADW11NuQ+67ga/vRCIlp
	DGjTDp5ID1o5evE+HPpbi2ITaPpg==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLW99-0000000AyaG-17xt;
	Tue, 27 Oct 2026 01:38:39 +0000
Message-ID: <26a54fb0de70f23951e524dccd7c905807278deb.camel@surriel.com>
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
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
 linux-arch@vger.kernel.org, 	linux-cxl@vger.kernel.org,
 stable@vger.kernel.org, Josef Bacik	 <josef@toxicpanda.com>
Date: Mon, 26 Oct 2026 21:38:39 -0400
In-Reply-To: <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
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
X-Stat-Signature: nkij36xhb31u759z7sj44nom1xnc4oqi
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 70910C0005
X-Rspam-User: 
X-HE-Tag: 1793065203-929439
X-HE-Meta: U2FsdGVkX18wU4pKfPTv4OGx8S5HsUlKUUIgImERv2fXGcy4DIanNu5+Ni9vzyABzLN7V4ZybXd63MIpnOY0i0hE2uj6zCqkUGoOv9eY0sSnvCJuevVPOOaPD9jyZJhbQyGJ8GxQCRSL+r0wsIFVWBTO4bHTyry/0TGg2vW1/dVTNUPEkKpgB2ZKxwNDO4IONdocqgrkvFGNAAGD5tkZOBGC67lXpgdDDNZHJIpF7H1sg7YfFMI8w/aIpU+4HpP6Uk9essCnP6JbWrjR6ePlNp/UVvnihoMHkIv4XHBn0/RblX5d5GDxwRY16Ctf/uFNfOoglBSWghk+Up5rGtklcUGc3xXILEB2hJBy3Lh3KY1bBbZXrbgY5fYCXqcI+aXWWiLEZOshDpno/h2qlagbaTtBvLCDEIU4eMPkTZ2p800oz2tHgdnKRplbG0jcc9Jb3ayCiENwqSa9RNYxAD5XifUGJ7R083UZhTqMOL9fLPTBJnsb/i8OOzoDMk/v3ZNNktPQfJbaIV1r6jfDCVqCi1BQ6DGSLqg//UTwiOey3vjm9SkCaEuJAuX4twV4AOdYjuxLtPBVhvs8RpjiYclL/CMF1GG6S626EJz5sYB7M068OIXoHteVFHf3Vu6FYKb+FYKNhRfsqtC/5Ph+E3rkm5YwO9h7k3S71pCiStLHkAoqFdnWKoX1zk2p9hka68QlbhuFiRtJooPiC6GI8Bzfpr7bLCSaLIJgoY5HXnRDJYjau/P5/v7lvf0zn3MUgXBI22WC0LIFMqT8iXuTDP5o74jFspFhLcxt3NzITgStkD8ofO8EGu80XDrl14wciBdR9QAzJDgHbMaWhJ35LCf8NMfe4ZTxenp9VMHJFAxe92JfuqNHF297J5cEMqxL2RpygeQ3mr8/jX/4O1hx4cOLaTXZrHgl5bo2XAIYSdn54dR9QB8NfVOWLLsPo/NgeL6JBqBF6IwGkX6T2ljaTgy
 ZPdmM9vz
 ADvD6+/iMwPn7Ugh5QF2kR5Gkioeq7a71I7KJYdY6+d4tRlH+72Z4eFCbR1lcxXC8EcGfwlIrwzjoSHuSd0tGWAs9B5Hw/KVp2wIoxL6MvnKndVs/oThLOLsBdhZFmQshHj38w5Wqju4AvCWVg/M3j+Kqag5OFrreMJBAyqBTprjZnF5LxZo3PCprt2F4Kzuz4m6MzdspDnlhiNEoYcfL8noTZcIb5Hdb8dxPzEVIJiiUlyQ+kiNVbROBpHvobLcCRYh8Mv0NeMn5mQUphkvPIZXRZfjHVLWLhpAIexllweqkt0RwrBC1ljgLxo0xGn20a3DKifw3Yq3nEIG/giEicirKpkJedSGabtNcxlv8gLIOQlahu+5z+ab4xcjOd7haJ5elbDtxUve2keYf9S1KeFE/iZkMTanf073eibHvQyfsvn6+A9k//8EANgn0IQ9AEqiF2W558azPteY5vaGRqLLxBeZ+WMo/kHhWalyZcbMRUOoXcAJG8wvS8Suq4kUuQAuhVJFIP4pVLv2V1sLpZxoqmZ67yI5cmtR7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 00:17 +0100, David Hildenbrand (Arm) wrote:
>=20
> Move uprobe_start_dup_mmap() to preserve the lock ordering.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

