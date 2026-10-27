Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A866606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=RGgw4ROk
Received: by kanga.kvack.org (Postfix)
	id 841B76B05B1; Mon, 26 Oct 2026 23:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2DC6B05B2; Mon, 26 Oct 2026 23:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA546B05B7; Mon, 26 Oct 2026 23:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47F606B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:05:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D43841C4293
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:05:12 +0000 (UTC)
X-FDA: 85366914864.22.89B0952
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 465F520002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:05:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="RGgw4R O";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793070311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+m6MAN4UT0/EHYIpxyVZqteSVMfVdSNgFL/Qz2Lnr3Y=;
	b=JzoRSwsSxLEJ5qSSFtahjNFtYJHtNH1ykoO0yjMx8z+92CZLsXz8Az0GKC3rHuJ30GUToU
	7bkCyHVzpNXOARG1egALCsPOP5sWjKNC7/Lo1wqiJzMXHIV459OLESGEm2u/MK+9gOdmIO
	tdtn2n6dA2+docwgFpzCjHIidkcsiyY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793070311;
	b=P0fsi5nQYCyILFv2rCYubdPxGwklfmLAdTwpTY4ygg2RUSwmUtLDDkO2WazzcGs1A1Sv58
	64LdyGtnCE/zYo8PQEmvtm7jiT/J13k50wN3Nu6wOqPbmmtjB+Mj/jNzIFa7pxT9E1WOSB
	2JljA2eUWmT/HFjar12Lvr+Ty8zumBs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="RGgw4R O";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=+m6MAN4UT0/EHYIpxyVZqteSVMfVdSNgFL/Qz2Lnr3Y=; b=RGgw4R
	OkD3cg0cf6P6MGLfRM+m5MvS+GJTc7UdWM+UQ6RguBHrPalIxkK7wcfHFWNFj7sZKNtnLm1zdBkgs
	N8lTiw3w08GyTbklL3MkANvd0R5Vpa/l+ULy2OKc5dDDmCb0BJtK8atoHOWEbl0wIQckJdOqYAXI0
	0pditX8YqoUTyxfvs46eYWQm0tlaMerwC9JI7aOGv9A3zaGQonfYqGEe8qQno7ZJP78jH6v4/N2JX
	pNCEHk4WoVbuUeWjg1nuN86duV8apM2UIYOylgwQ0mmHgNptwLsypcm1xsZq+bvglC4XcRpdoLXKz
	zVSK2VHrwJ/eQJhc2JFuU0IjUvoA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLXTa-0000000B5QX-1toX;
	Tue, 27 Oct 2026 03:03:50 +0000
Message-ID: <8b09a67e95975a23d3a1eb9446030d758a1b5afe.camel@surriel.com>
Subject: Re: [PATCH 07/46] mm/filemap: don't lose a folio lock wakeup to a
 signal
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
Date: Mon, 26 Oct 2026 23:03:50 -0400
In-Reply-To: <20261027-fixes_core-v1-7-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	 <20261027-fixes_core-v1-7-6f74bec9a5bb@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 465F520002
X-Stat-Signature: 7x173dhamx6c9maqdbr1stb6mju3uija
X-Rspam-User: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793070311-712978
X-HE-Meta: U2FsdGVkX1/L3qukj/7M57INuTvlyICog5MlZZXraMebBtGH9Ux71dQ5q08viOjxNSMSJDETDE/BEuKg8PlcV6xQ+2Wle0/PvJXDSyEkKsEzNpf3+fRGuYfKvn4Hs2CsAt14OyZdZ7bOADnyi0FHwTEkxhGoAKMWzK++7ppNUPpdYVfJNpybwYnTYoejCodB5MXizuL/HmqRpcoYZpg11MGgNXOn8mQgGknr8SuNW4YZxnuL+SFOnGkWGi9r1TpFJNHp87+9wKuhsaDTBxi8nPNOktdlv1S0M0F4o3bDD3lG9/tEy91MK9PKt3ey6uHyGqA7PQLX20lUE55JZ0qBKsluMGwKAFhM8q1HTcJDNeLc0rhHPCo85q2H75eNT9jug0+KrzneuQ/ULZ4nNqncEVhXq8gVcpTmtIu9x727OgceujNU/o0V2qDRQ05pX0Vy2BtZea+J5HFBmHmjrd8WGt864BEaRY3wi/4xn/ubdj0iJWQDEeuqKZy2K1WS3gmJljfi1gjH4wn+YZIhWkj1egAxtVeHef090hsVQ1ZB9a5uM1nHxgFHSkC7qUa3Txm4B90UCfIiLCOgRn0QxP9O4UbPS27r7TCSv62mZXRcY9//5yYE2VcIOX9ae17mFQ2/QxPAhOtcVgJoWxGGFrGdiWIFssuUZrmw+zeGsfV9a42sYO7Ja98EobZkEudRcrv4mVlG4FXwvf1lNg/RJFUwdpoUtLGS404+51NnFll0E+gXjAyjH4PjxtAaHDFPYnud7wk7zFNAQ/oqD875tdSQaCZqqr5+Z8fSkLgkkR2ixB5MJMlT+zn1PQ9i78ZUIGHsvY1xYYDuaXpWGwFIUlf+LbtrWG/93I7jf3anICLL9jw/kc6cMYigwxkMFxywA/BvcEIMDTiofcvW4fY7dFcGlvkFHEPYbOivsNeX596V/3bCYY0JJDcYd929QmqO54/gHpmkQL66tZNOf6UskpV
 J2RQd1mp
 zmtoi1gL6sMVRBiKH3fkfe9jY6rcRwDSFXB8QZlgJ0jAAkMdh6yYR9/4ilueRlqKhqC2KAbefKqxdl9KyQpdJAU8FyH1mrbmMN+uOsRDTySvM7mCXUsrFvcqH5zT2cXQ5qabCbGtBAxe0cm1HvqTPvnwGuV/55IDuc2otWgzNikGhE22Rb1Adf7e9Rt5MdlseqXOB4KNsvo1hnw2OMmTus/EwCGlMgttZQI/2yZ9NhvATgIWkFSAuypmuDGHyjPoT9ewAFq50q/002f4W3R1m9fBfQ+/kjVVRrkZYtpmZLC2ZvogFmAklHFMYNxWIFnON5X58HkCrDBq16r15CKPMCqtVOBPtHmDdKzKwarrzUO+x3mG94exQz7xhotudn1qgfcKGzRVriHYpiRI+5w1RDiNenhFw6XEmTC/8ttZGxV8806+YUuutN8TvMmTYGUevLl73ywhZttS7sq1eXnUHi7Dswf+wjVKfj31rJ9RdR5xskFk=
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
> An exclusive waiter in folio_wait_bit_common() can leave the wait
> loop
> because of a fatal signal, then be woken by folio_unlock() before
> finish_wait(). If the waker did not hand over the lock, the waiter
> returns
> -EINTR without trying to acquire it.
>=20
> folio_wake_bit() stops after waking the first exclusive waiter, so
> this
> loses the wakeup and can leave other waiters asleep indefinitely on
> an
> unlocked folio.
>=20
> After finish_wait(), let a waiter woken without a lock handoff try
> once
> more to acquire the lock. If successful, return success so the
> caller's
> eventual unlock wakes the next waiter. Otherwise, the current lock
> owner
> will do so.
>=20
> Fix generated by an LLM and sent by Josef Bacik in private.
>=20
> Fixes: 5ef64cc8987a ("mm: allow a controlled amount of unfairness in
> the page lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: clarify and simplify comment + description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

