Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C4C7C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8DC6B008C; Fri, 28 Aug 2026 02:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3738F6B0092; Fri, 28 Aug 2026 02:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241726B0095; Fri, 28 Aug 2026 02:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9FBA6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:42:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F3F2A028F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:42:09 +0000 (UTC)
X-FDA: 85149733578.28.C2ACA2C
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	by imf23.hostedemail.com (Postfix) with ESMTP id 296DE14000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:42:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JLc7M1BJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787899327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXRmLWTxklsm1zcLkmzlYzJZu9xlAGNyhvOD0WxKqaI=;
	b=Em+mLzjKNkrp6NQ6aTZA0IOptcx6RUROc1ai2TDCnc1k3dA/io1TmG6lJMnlT7GIG2N0Dh
	p+HdvJkTS18NM4QXk7Au/O8sZgC7i075ULu9VPeR7KFPXV9g8UHpNODlgspG0zjBs6VXKm
	mWw6gwYVSuzptNymQKYjHyrdvY7B/0U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JLc7M1BJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787899327;
	b=Ju9Su+KcTnBe4LI8P0TboM7lAy6Tf5dJEbykJ+E6ioEOlMNzSiUYpBDVslquCZ1vAQhnp/
	gNn5/rfkiLxubHNp9ngyc5bydiJkrt7S7f1J4BYkGO66OIcdD5y6cIBsQRZcXGbb1Nm0t5
	m71hjfNVW8wiX+CJEE/OPhgO/mTSSFg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SXRmLWTxklsm1zcLkmzlYzJZu9xlAGNyhvOD0WxKqaI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787899325; v=1; x=1788504125;
 b=JLc7M1BJjBBxbWiRMu24+tnS6++XVj1JJVdzhO1VKPJyNQ8SNPfipZoKA6yAngPteCtdpRFo
 sQ9Ijf/MwunWIkFEK0yB7XvnSNDo8dOcnamoba8dFVHtEApWNMK1SbYwHAUFdAKunddx8Kq34EG
 2n4z6UgK5lfuL2dsfvkELqAE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id da3454e6c9281e75;
	Fri, 28 Aug 2026 06:42:05 +0000
X-Mizu-Trace-ID: da3454e6c9281e75
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 1/2] mm/hugetlb: do not dissolve gigantic pages without
 runtime support
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260823044118.1097121-2-xialonglong2025@163.com>
Date: Fri, 28 Aug 2026 14:41:51 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 david@kernel.org,
 mike.kravetz@oracle.com,
 mhocko@suse.com,
 linmiaohe@huawei.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 xialonglong@kylinos.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <E654A716-5F59-4B7B-B402-17B1A776D541@linux.dev>
References: <20260823044118.1097121-1-xialonglong2025@163.com>
 <20260823044118.1097121-2-xialonglong2025@163.com>
To: Longlong Xia <xialonglong2025@163.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Stat-Signature: 381j7kdkj7oduccc8ndbtk5jsijpdz58
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 296DE14000A
X-Rspam-User: 
X-HE-Tag: 1787899326-402075
X-HE-Meta: U2FsdGVkX18t9ZX9fmboQMvaAkR6yOYNdmn16j1xVxKaXBdkl5X8ZobVyhzDiwGg3QQHMfYNDNA8AVXACbmt9mV79CnTOEhOKkUrsr6SOavtI3krR34ypG6+YlTCDKBIzk3xE5T9eIcg5vDoE0RURe+0bF/ksEAW8lMFubvKZrTixLT8NM632WtJyNm/d1DJivMpCJXCUQrYxJEoAtsUfnhRXvKBiUM4lLN9aYhEEqN89lLdG2K6zqRjm5CiUh2i/zKTsz/atoRPAWFMF7rhUnTAaQ2uf3PT8/g8frNELwHxhBb5t1EWTMynmpECriUc5X/v5c542GoWgw7vdsBs0+/7FNDwo0t0dyrLnfV3izPPru2RnYqlN0+V/X6zFaPVv+lyBui3bUsZtkQWy2ZrNo3F6GdCeh+mBMNd8gRs8ftKxW64VsGqYk5gPZGtlPqU3S/2RER5Dq0lfTYFtKoEoVl3B6moSM227YrWDRmuaBTbFVJkIgNG9DBPM3kukHk9goFXvnC0PCiXXyJ/Bod8qaeHi1XIbnLpz/MKFRGCgpfc1d4RzLL7S6q1yQHfhHgANLtocCcluewup1OL3RUJzjdrvDJt2jkwxqplbBNeB4SVvtQKdkckJLxkAA3E+xdlfz6xjwtz1oKgO6EB2fYHapKWkCHX6LW1MN5FduNvw+dFQOb5DrqS5zFFcnvn/9QUThFldoSHCKFMTZdcX7mavHc6mKTbdErIcPbfZ+KwAge2J/U79sD6JorPXrR4oESiS4dHZJ4z4X/UjketCV5HkestWt6atSzR1oOAngp2hOw64ZE1kmwui168uRIp4wnPSeuElII/63ghhiUz6Gp7Lw8PN0d83Txjf0H0EvCxasedZWBV35+rChRsbG7eVvo8aL9bG9n3SJkV1nhdjm8sObV9j/kNwP2vebLNlyQxKvaaQMnkVIUEtlfptjatcis+Lm3x9Ut6LA0O3gE9IAI
 zoLdLAxJ
 Hp0lpchbn7Zl9HPZ/cO2M6EpXBRZKh2CeAXzGOvQ4vCyCXjIh5hAWeDBNxl2Xlti+1SHlZeUTxc2mbkkTlc5tdpmc/J9dG2MwFr2pUy4Bv6knsEgN20wxSHcW2OSojZdMaC35regVYrXh3SPoEUJGcf1C+zBToAh5nPmQN34+zYgNjPL9gMH9Mh9i7icHzaKp9PopxC+fBsMyQmlZeipWEMbNOHTaQw9qkYrpiO/VUuIXZG6wMh2wu5zXUkrOa+x7Wn1T0Eed9QfqVJwwHxQTmIaUekV+4KNvOb8VUTVj0sHfo1YRNkv4wjbtMe/lwAp5fyZ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 23, 2026, at 12:40, Longlong Xia <xialonglong2025@163.com> =
wrote:
>=20
> From: Longlong Xia <xialonglong@kylinos.cn>
>=20
> dissolve_free_hugetlb_folio() doesn't check
> hstate_is_gigantic_no_runtime(h) though remove_hugetlb_folio()/
> update_and_free_hugetlb_folio() silently bail for such folios, so it
> frees a still-listed folio and, on vmemmap restore failure, the
> add_hugetlb_folio() rollback corrupts the free list.
>=20
> Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to =
separate functionality")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Again.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


