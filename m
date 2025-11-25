Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EFF0CFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 09:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB1A6B002E; Tue, 25 Nov 2025 04:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84196B002F; Tue, 25 Nov 2025 04:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72DF6B0030; Tue, 25 Nov 2025 04:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED236B002E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:10:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32EBA1310C7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:10:29 +0000 (UTC)
X-FDA: 84148558578.18.1EAB50C
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0196AA0012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:10:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=r7dexYiF;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764061827; a=rsa-sha256;
	cv=none;
	b=dP9B8SkyQce20ZArZtSrAhF3m/vXFpknErg855Xsoh0UpMil7TryiLh53MrxUKa6v1C+Nv
	Tj9Meupy0jpzZZbKFW5XATJ1b88MSETZiQDPCIH650InLvEt0mnzVN4ZqITiPwMF2LL27N
	Z8s0nnGuUA+Xt74hUe58c5BuNfA6KXk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=r7dexYiF;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764061827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkPO+JMkDG1D42iF1klXuu9GSgaYKiSAv7mDALfM48U=;
	b=oFnAN5wZSrYNuo1UkOUTwj7BcGiC7m9tkdsDuulo9E0EwTZBTFVfrlz4rEkxeWZt+tsYeD
	k/T4xs8lSqUAOmRllucTAimuS/Wqpy5X/zvNL//0pIixFAFuoKuk83foTeAgeBCiCJAfrp
	WlAZt5e09bhVkA7RZY24jWnij9SXUAw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fkPO+JMkDG1D42iF1klXuu9GSgaYKiSAv7mDALfM48U=;
	b=r7dexYiFIm2hCk7dul94a1FjT4HB7yfQvfavfRvzS8+KcaZ/CZdxOqCGrQx/m1leD0JKmpN68
	l0h/1XbGYPCbUYTqNPijWgfObmPF85SKSVv765bINaHz+4ZTQReSV1mL3/FUhsiVwnUsitXkBIs
	QfrseM6JUXhcJhyIVmQFp+4=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dFxgk0CHFz1K97x;
	Tue, 25 Nov 2025 17:08:34 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BAB161401E0;
	Tue, 25 Nov 2025 17:10:19 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 25 Nov 2025 17:10:19 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 25 Nov 2025 17:10:18 +0800
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Balbir Singh
	<balbirs@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
 <33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com>
 <34bafd06-250a-4019-8b34-5ddeedea1cb3@kernel.org>
 <66C159D8-D267-4B3B-9384-1CE94533990E@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6cce0756-cfe1-7b39-d81a-ba1b2cb32fb5@huawei.com>
Date: Tue, 25 Nov 2025 17:10:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <66C159D8-D267-4B3B-9384-1CE94533990E@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 0196AA0012
X-Rspamd-Server: rspam07
X-Stat-Signature: 9t9qpwd5dtsynpi5a5icrtrt8rrtjwn5
X-Rspam-User: 
X-HE-Tag: 1764061825-57365
X-HE-Meta: U2FsdGVkX19Zvvj3aML+6XC/66Yt2l5bnNdKkaEXDNgzIvj5dPDSnToDmCm0a10oW2hDEFayj0+2yDYjq8VkXnXRgg2MlBgLAye1sSaQ05aw4bzfgy7jo2ij9Ssl6jy4rhThtJCD+tZvWizVtCF3jRysvzf5CRS/mBNzVv7JtdNXPbEul+QcFDUv5NTKpqGojhBfLGawG2y4FYn/5OoSgCm+UAtNYiEof5EX2nJNWD3zg4RNTv/AmGFGexFpIV+IGkEg9Po/ch4iZ0gPGbL5uuawhDzVdpRlRQI5DFZbiMW2TaBB2d59O00nu/1TYjkiKZzOCcH5pTJZoPHpjM7wixHTS0CG2Pp5GUURvVuUy/Lc7ZKV//QnwU+QPqXTbW1r8MgG/ctC6uwxWyY47irRw79c83zfjtoJRVTkEBvEy1QoKsYHW3gGumv5DSdC8E76xQZ/PkXJ/uoYGH9EEld0zqkYAxq82b8sBjFYbaODQpBpD+JVQSyXSNVGcRUaUEhOFVk+I/CXMNBGmFLNMIt7NjP/yYhCKVstToBlL/Vdzc0S2ETAUY13nj37VtwYyG/zb6C7brvBrxu29qPImTXMTvtJqQLYuZQIibxPXEBFK5vvaConAx8JW23Ir1xVNmhIrG2HF+m02ZkBY+Zh9ggVjQdW0Qom6xJQRqhjeqNzOmzXvJOPIzFv/9mGIrqrKCIdkqwW4A03ujMJyd/QzaxExHTiByTivH7gAhczkz67g71q5X9WOMMA/q/h2njl07ZKU/kbNby4Y4O0F6dYs2kEkchsxo0VAUy/L4S/K6rStGednC8etd+ebVfnLyMYyq1Y+uGHqfvpxEokT8PaUVHN5HOy7s1vuwe86PGXglr9DsK0jKQsrPOBPJ0ejX5ICb1lz8HeVEQit+ZBPdvT6iuRI1jnuF/s0xrArF/+gye2KsoBIyg1RwiN1k9bldtrVqO/zCe3qccvPfbpQYPBD+I
 t4h2uE39
 ww6GIkbsqQXO1nZr8Qe9pZsNkzFCrKAbTq5Xq1e7z2PAyDnhhTkmFqB5SIduTEjq7DPkGPPajh9vNeiCTMrlfKdFBiAd4rgiDo/xV2QKKarVP0VdMCxkYMHsk/TroUmem4Eq7EXy/NSI/TB48DaqCMi1eMcS4RmM8Fypxu/JpA799/M319zEiOQUDtamQqC4IHyc/dMpJs9IdpROlJYqniSFI1HrqCcQKGTCVJobPwAxVsrJowi/GTZbkKWzPwdxJAmXS8l81DujjHRX6Uyk9/PfJ47RB4jKtt9BlxHD7CugFrZ+jkeSLKPUzpULkvjhBkvI77cKV9V6OvF0HU4L6ZrLu5C81R1T8zXlQehWDIcG5N0NjbXfQDh+uJRSjmBsYW/SPlktqENTOckjdwjKud/CdqPOJU5I1AGPvSRWrqPFMt8c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/11/25 5:08, Zi Yan wrote:
> On 24 Nov 2025, at 14:22, David Hildenbrand (Red Hat) wrote:
> 

<snip>

> 
> BTW, this page flag reuse is really confusing. I see PG_checked is
> PG_owner_priv_1 too and __folio_migrate_mapping() uses folio_test_swapcache()
> to decide the number of i_pages entries. Wouldn’t that cause any issue?
> ext4 does not release_folio() for migration when PG_checked is set,
> ubifs clears PG_checked in release_folio(). I have not checked all other FS
> yet. Maybe later.

folio_test_swapbacked() is also checked in folio_test_swapcache:

static __always_inline bool folio_test_swapcache(struct folio *folio)
{
	return folio_test_swapbacked(folio) &&
			test_bit(PG_swapcache, folio_flags(folio, 0));
}

So IMHO the reuse of this page flag should work fine.

Thanks.
.


