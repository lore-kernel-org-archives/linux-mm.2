Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B723606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=Dxk+QBhb
Received: by kanga.kvack.org (Postfix)
	id 3AF1A6B00EF; Mon, 16 Nov 2026 18:03:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385D46B05B0; Mon, 16 Nov 2026 18:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275026B05B6; Mon, 16 Nov 2026 18:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0E5E6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:03:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9248C40262
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:03:42 +0000 (UTC)
X-FDA: 85442511084.10.150A4A9
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id CA91016000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:03:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Dxk+QB h";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVgWDrzcdGHN1y6Zshz3gk11ql+dGTvhjArhMrYEQ6w=;
	b=HSwddw/SaeThN/sHwuklzoT7kHpqTaM3zvn6gjUzxJX1peKkAsZBcFQJCJG0W6XWfrx/7N
	f9JCboecKZZYPGqjyGxpQD7siF6dIdNQ7jez0cYhk22VPuJbu0MLmqP0GkwurKLoa0tZtV
	a9mqS2WYr9jy7eQs4rfAwQ874HlQos4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Dxk+QB h";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870220;
	b=geh25dO5tJefv+zjsN1lhng93p5hd2FTBSc87Br5FsyqwgmsDyxYhAdzPdT+S97FwzgTR2
	6m220FTIWRVy535rRH+hk6UTiy74/XZZPU6nEbSzTVzJB8aSGHCzG0GbUnVa9YzhBf5nqd
	fA/+VYoW0/e2BoerkBcTvYpThjs7ras=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=IVgWDrzcdGHN1y6Zshz3gk11ql+dGTvhjArhMrYEQ6w=; b=Dxk+QB
	hb6dZ6KmZa+hJakYWtYDdfO+tvoDqaBizMEnCmzLyhwBVwVYz+qkFYQbhbHuESub90ch9ATj9p92m
	r41oe75ZGsnVznINep8+F60I+PKMXgR0cZjivLzb7YY/G35qq/spOd4dNeypHy1K1bQJiOj/kXD8V
	BPApD/wz7RdeWQirTBxhAOhkr0XYCwwH55GJ5WxqOGh2tAnIGTbaTtl3riTso8KQ+yx4/U8WSc6OB
	gjtsTpszWWcDn/VVkAIF1rJRitJLJEdz5u5WFfbam2Fq1PTMnO8co6cmPhUUvlf+XA+gtxG0QhedO
	oZLGtUnKo9W2UEdMhnrH2A4fv8fQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT5Q5-00000007pj3-04ju;
	Mon, 16 Nov 2026 22:43:25 +0000
Message-ID: <4243e7f0873529106634ef3f720b7c7035750599.camel@surriel.com>
Subject: Re: [PATCH v2 03/15] mm/hugetlb: preserve reservations when
 shrinking on HIGHMEM
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Muchun Song	
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Naoya
 Horiguchi	 <nao.horiguchi@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Andy Whitcroft
 <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,  Michal Hocko
 <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Dave Airlie <airlied@redhat.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Lorenzo Stoakes	 <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan	 <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu	 <peterx@redhat.com>, Breno
 Leitao <leitao@debian.org>, Will Deacon	 <will@kernel.org>, "Aneesh Kumar
 K.V" <aneesh.kumar@kernel.org>, Nick Piggin	 <npiggin@gmail.com>, Peter
 Zijlstra <peterz@infradead.org>, Heiko Carstens	 <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev	
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Arnd
 Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Gerd Hoffmann	
 <kraxel@redhat.com>, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org,
 	linux-s390@vger.kernel.org
Date: Mon, 16 Nov 2026 17:43:23 -0500
In-Reply-To: <20261116-fixes_hugetlb-v2-3-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
	 <20261116-fixes_hugetlb-v2-3-4dd9e94ea9ac@kernel.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: hffk3qetxbr3g6g37b6e6gcfeyrebei8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA91016000A
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794870220-394181
X-HE-Meta: U2FsdGVkX1+X4y89jNlgqsPR3Br65XVL5AnTGcBFLnvadR8RPwwKxifFoZ5QWIj8n8rAqDugbLe8/MSpLeoD6WdX2xx7697dBBWTqQHqMl9rSoqLNya3PRhcv1cT9plY8SxK6QXo7RUE/Rrv1eMt/QslN5hm5CtoA1sVH/ToXgqk6+aPpWprxqKYgraV8imtZqWL9rJfF4sQWHE0LSW9d3klHCK8x5sbz+/+oq3r6dF6dcBg+nEeoW3kbMtftmQutcccWgKfrbuAhxHDS+U/t/vg6uwajUIj7ybebiGS/4g3vH3lBpuTLIzJoVPyQQWKMFwy+3gxieoJhoZ5ZbdpNNDcRLWSJ4o17rk8gsSQjEr4KQBJGcAB+JJN/D0uPiWaQ9avPNcPxU9071MyKBkge/J+fp4oKWbWEU9eRTWJgIfjs8Sbfm+rQGOViuE7G4FBqArIVMaq5+LtpjM216s4ZYmVvS0slsfheLnDlS2YsG8lUxl6fn/AvXWLqFlpks0DmdY7+L0li8KFUBxjf/PzL5z0OoKvVIUJp4FZanaMjp0xtHLEDLOFP52eSKs8R6BTr1H0916KJ7Yu2Vi+A0induPlcAvCKESArlexagh2Xv5mRw6QnIC50adRSdiE3utiREfOiGIwPTlMhtwOg0yBQ79GTAyoK4SVIqkPNy4s82O16s6DJDV+o7oLOmujMaHEiIP3A5gCwJbl12PNdf2abliaGOjPSdvHZ7tZ2Fx9ukx5QLuaAx6ejTH7blO5qZc2uDP3JrnbK9Joj1cl3GZDGrG5hhRAzyzPMbM+mPxWxaqbzCLMfW7Mhrfw+Ooq/GcRl+Zx4GxUzxMox7CCWOAF9bWhj2QJSZ50Rx2WjBn+JHUt4J11PKqlo+89yhxlN0pSXUmMDw/YlFr64qTp1eFUbvwT9rVAfJPWquTHDvxb11/NWeop2stZJ27Y82f/WVwqr2pw03na6Z4apzno0zV
 jS0vHl+b
 XdVcNWtPMe4prNqinuPXix67QDpNLsLjpPRWh9MxJnW36vrl9dfB8YziqHKMGGxjv9Rv7qZ6AokG7FzFzOxsUMRp3ucWjm2Rx/f46vZdPqsm/5wK24veJsKjHP+xZIavBLlUD6Sm0Y47rY3iRYDjTUL08v/g9dZqEz6QwURLQfGPdhWD2PQQSxMz9KT2Fu6rb8FZfLu6luTX+9juQ+xhAoeyE7wOSybvYeeW3NGDo7mxZIWtVa66iQRnVPwATZDZzNXpg6MMVj5swITH7NxT6nXUTj76tEXdDnpTEpEvj4Bv0mvrj9Sicw3pdNZ8NCmBxU85eZO+7n/s3Ez5Obp3yGUAvUu9WAPnYrzgcnw22cRCzLXQeQzluhDYb2Jj0OJT5Vx+VvmGCRM2GbV7AqTBMeUFJljodkA/fFOv80XfnMmFyRouZkzzvsLD9AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 19:29 +0100, David Hildenbrand (Arm) wrote:
> try_to_free_low() drops the hugetlb_lock while freeing lowmem folios.
> set_max_huge_pages() then resumes freeing folios using the
> min_count computed before that unlock. Reservations created in
> between
> can consequently lose their backing.
>=20
> Collect lowmem folios on the caller's existing page_list instead.
> Keep
> the hugetlb_lock held through both selection passes, and free the
> combined
> list at the caller's existing unlock point.
>=20
> Likely not stable-worthy.
>=20
> Fixes: 1121828a0c21 ("hugetlb: call update_and_free_page without
> hugetlb_lock")
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

