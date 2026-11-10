Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC28606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 04:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=BQc2216W
Received: by kanga.kvack.org (Postfix)
	id 3AAA26B05B3; Mon,  9 Nov 2026 23:49:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BC16B05B4; Mon,  9 Nov 2026 23:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C346B05B5; Mon,  9 Nov 2026 23:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F14D46B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 23:49:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92574808B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:49:39 +0000 (UTC)
X-FDA: 85417981278.27.73EB1E6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0568C180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:49:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="BQc221 6";
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286178;
	b=jiWS/ncmqwTZ2QarzgH11s6Yd0KgjKN7tlwV3Yy+OeiDnroUg6Dn6hkA62qgcdi62C1ilb
	1Yfv1ANn02SvOu1vn0/AJgv6CvktMeWaOHBKbsiX+1HQhrHCKLQ8XebxJWsZSgZc6LWhKO
	k/Z3NVpCsoBKwVw/+VGdf9QXmRCALd0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="BQc221 6";
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zESBlF9yMWYDqGeYj3vcFt5dsseLPnqBkvoSTsbw2vg=;
	b=Bor+LiUdpVPcGIxnC/bq76uso3MN6KOaQ+GWriNRPE3ZWE+80Ig1xWCWuPWjryLmtFfSsq
	wq9Aj7f8PMmyrEefuwuBSAn+WLk6UzhQGkX5MpQJPREZPdJICGIqSIQ3q6wy6ENi+uQqzx
	AoH24u1B4NsT4EhNucvYHVN9xJljoYU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=zESBlF9yMWYDqGeYj3vcFt5dsseLPnqBkvoSTsbw2vg=; b=BQc221
	6WwZ7i769dfufowPW3gY8yxmHx3SDNl8ja/1tsSP8rRziuB5x8UoI4tOQE/8XxrcX7h2MOyilYq6b
	n0nY2mJt7w0xMjzArPm6kVVB2qaJQx8UxvO4/QmqNespCqYHeiAImeJG9PB4cW0VqD2ksQUhRFoFJ
	q7EpSh0j67D4tdjtXo4//Q/Qk9VIZ6PokaMv1ugPAlOfzALj6I5Vnfpf1U6eNlUpxWPDgSyeM+DpI
	qdQEPygFFKdq7GB+jP+w2dDn67yJBwQWNcZ3q6LMpe0Kv1276kIl9THr7b47R0volSr9wLGViJKWz
	CQMimulXpzXGeqviYyFkQycjeIIQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xQdnX-00000003WVz-2kI3;
	Tue, 10 Nov 2026 04:49:31 +0000
Message-ID: <401ec8b3e4da18381af8f3157d680045829f5ed8.camel@surriel.com>
Subject: Re: [PATCH v3 3/6] mm: gup: move gup_must_unshare() and
 INTERNAL_GUP_FLAGS to gup.c
From: Rik van Riel <riel@surriel.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal
 Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand	 <david@kernel.org>, Yuan-Hao Hsu <aa9736195201@gmail.com>
Date: Mon, 09 Nov 2026 23:49:31 -0500
In-Reply-To: <20261109-refactor_gup_fast-v3-3-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
	 <20261109-refactor_gup_fast-v3-3-2aaef02df0e1@arm.com>
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
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0568C180002
X-Stat-Signature: ebx1a6whgzyy6u6b5od9mtyt93kec13i
X-Rspam-User: 
X-HE-Tag: 1794286177-830327
X-HE-Meta: U2FsdGVkX19k1U1yzEKpxIIbMulwE6+4GNT/LUJ/Diy0mJbtOZYBwFnv8RPU+CqoTBt1cKqZWm3ewboeyBpO4Up0YA0NO/LwXtVzvOxag/mcVeRKvRr/5VPXRQtlt/g9KhSm4K+Vh2ebT0i64OoDYuZzHIE5ce2sZAy1bx2nhxGy4d5pBqsoP4RbkB7fGRC5AuSps6X81yOEwC7hQ8uRRlKfuLN0rUZ3WD/0VVkhb96JI9yHNBpFX8xvITqTRqKVOiDJHE0D5MeAenh7t3UqmHy9Kmb9XlEGY6EXU56nAIMl7C68BD6sn7Ib8kM0sjyMNtH0xA6BBe7jsOpWnnPUxLMGuz87n0eeog7dBIZVyhX6rUUpvM0m42avHkDDlL76sHTqA23KvF6BYguEbGN0tfnyBdGz/3uasDPjaYO5iqsHpQoYHavBT9gPnDacadj+uVq/sEkTKDSpTQ4bY0HZZGwYeYlKo/BH1cUfwteSUh4mVTQP1iS04pekW1/BNPlD2fRkpPTKwU4dWP5WjsSqmfCFHxhTo78evBshTl2HxnCxn/I6UVgQNmL+9PXh83z6aeLRqnwMh9Gmg4JDfTbmlxFXUApvML/p4OX74PfiZepVTaaZabRVdCqcymJOVhIstIhXEAOIh8QQX2Tvqoo33M5xq9wNNTu6p05HH7giauppMFCy10zZeSoL/CdIVXwKPdJSAb423B44M+Nw3dEOv19r1iLryM2QwAJcX2KHLEpiJ1Gu8p21ePYiZiI1vQbG+ohVjeWohV9bz3G4ubP5Uj43E3QC7nVubfRqnfwtwfbrU0MEyXuClqElsAU1SPLFiH/zaRZmYgyoXDMSgNY5BjJwOP+Tfd44jwHP7PTtHoKxRCp+7CqmrGMZm5YSvz50OJB9eS42u1LtOgDTjW9jr4ixEOTovSL56azaJO32Rd36KAhIqjB+KrgpciSRa04FX/HjVLysn0NRPZYuVON
 fX4Sie7R
 +vqedI9LW8WPTjin03Ncu/Bbn3uL9lrbDT+Eu/PpVBDSeUatLkvlhHR5dwTtKurlfTfqQzsHMqhMzOyRxQIK13hLWznQbsKeQ4zTKznz7+E5MPHhR85izqUYrSlKfZXpwOEEuJmFh1lIF39jx/hzBL2IglQujZ/2DNfjBMyPWlFENa0jIgab0ePoHdr1o39yGyP4CMoB7ldgu0/tg+QXfVNM5y7Qbw5YIbwoXTlyvOyocECzYSxZj+vvefz04qLqg/wljuFU5jT26QkmiugMIxP7IaVrXeV/aeFGLr8dKiJHe1rHbsdORGoLE7dbGgCaM7WFCvhINYZn1X1STZTAR9OyxYVX7wMVHt7a4v99Nd5DlgE6vg7Gz5QEpPadMp/EaWvBvBEPozVowyTFUofeGTu5J/wXcgZ3Sp6YKHTdSbNbrmYXbQzLzMw14RZuMqPXziqD3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> gup_must_unshare() and INTERNAL_GUP_FLAGS are used in gup.c only.
> Move gup_must_unshare() and INTERNAL_GUP_FLAGS from internal.h to
> gup.c
>=20
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

