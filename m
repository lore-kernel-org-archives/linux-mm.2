Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2C1C531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD736B0088; Mon, 27 Jul 2026 23:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E853F6B008A; Mon, 27 Jul 2026 23:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84716B008C; Mon, 27 Jul 2026 23:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9C406B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:02:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 333B7A020B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:02:35 +0000 (UTC)
X-FDA: 85036687470.18.EA73CDD
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C9D88000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:02:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X1TzGFwR;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785207753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXSQdKo9ljS7GC2evl70cU/DxmVCFQ/8TIH5wWaTpfk=;
	b=JxSZDOq6viu0jgrB2/PJvOfVaml1niX76SxqmHAS5A/rvttFpq2YZXXj+EPepJeoD0XdaP
	osQ/soMutyYrVf9RHcGT8z4XE0/oVeNVQcvb8o0ph+jFIxZhZgn2aGVVqYNqiHXBLQBJUz
	RP5eLWJYnCrNyvmt5bJ9Go4NsWJ4wz4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X1TzGFwR;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785207753;
	b=dpuxWES8WoJeFR6MYPMjq5CsO0rltijFSW5NamivKMNCVpO7VgzUzkIiEtXzBOkN8qGDGg
	pBZiOTmUkTEQ7dsX4oarb02268McTtyaDnvPXuejIGV718KiecQxFdxIB1/KYM8JnqTQ2m
	Jh/18drgt4OTFIt4PitVDnLm0iXS2CI=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ff20870ac7so28038986d6.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785207752; x=1785812552; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BXSQdKo9ljS7GC2evl70cU/DxmVCFQ/8TIH5wWaTpfk=;
        b=X1TzGFwR5hygjpPtHA7UGeB+B4Ex4OHpXaKT/lhDUOUWc/kElB5M7fagx/WMn7ULur
         QFomh4t8FoVWgd4TjhMi5mpx+a741J5TLmGZl7ZDLyOQw1z6HtgSdxcdmHjMrHkaKubs
         8JjTeQ2jdTBTUWZj1heCUUnBfmvkqEXmQurSeFAwLI717q3wyK8rTLz8nNnmB7lh7Ton
         +h7siy96zuCmh72IjJxZa9UMq+2dBE0Gingci9mRio3U6Pv+VOzVjrELIND55MWN3jH/
         N6fy6wRDHkkekIsoAiO1XB9ZM+OgnozSm2tFx2kxmB+sJWuUE2NZcm010QMSL+wQDJhp
         wAdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785207752; x=1785812552;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BXSQdKo9ljS7GC2evl70cU/DxmVCFQ/8TIH5wWaTpfk=;
        b=VXdtbAmQKyazhc44wsDl5ymFuIZJP2quIZal1TxGKNwl5d+bcTHGcWT1VutZ/eK9dx
         R7uijarQr2dTbG7dmMtYcM02kpXYVSc3G2DB4c227oqAH2EM6waZKIhBGSnjtp4vLJBA
         PsPBelKpYNm0XGKGTiJ0v5tu0x85pMHvAzBRmvtBBU17ihkZLJ0sT8GPCO+foVuEVNGN
         QtZLgEPKR5CuNAXndrfaDSRJBDVcahpinnDV1v90joOaSqVceVH66lHThr9hfdGW34zS
         fO5ykfV0vElvf2cmMpzzUuBQiCqOsrq/Txz0o9xk55uODiK6iuwNaVBuwicIhLnHVvLH
         OsFg==
X-Forwarded-Encrypted: i=1; AHgh+RqJWJFTvjeSNDsLIFdgRPiCNKk243wpgZ/HmDJetSieY/NACrEgK8HVAV0JxZqOwIUcYruN1fompg==@kvack.org
X-Gm-Message-State: AOJu0Yx4JLwNt50uXrDOg2Rnp5bA3GXgkwSvmQKwzUKjx5EMh7jOeJol
	kUWUW3dGI19C7WbNKCWz49C9fde3z/d9lBxlAVThdrwDdGDdf2jEorIXEYO4k1TtnIw=
X-Gm-Gg: AR+sD11UBosWeUN6GGv6gIm4IoHBlnJPshvp+1YAiEerA48fAHtX8J+uvQGA2C+hi71
	xfgGFlvxMaj5AGM3VitLi22HgVJJRcRQcS6Q5M+cXMhegKP1rrFtvzFTtMW4l+yURRy3zuBu8EG
	VfjVTAEYX3ulml6NxSSmwtzQS0mQMe8aVxWCcG8j7uqSeT2lfUOAY25ATzTWUgHyccIIuRoYIgp
	DiaJ2v9581qCrQGYxYSeZCZem9XlmSotpnMCETn50P8cFlgT8fG+yEhcfElN87MGsesuftnOSE7
	WxPl9pO8rgnInt8tLP7Jhv2H/ioP+f0WI5ZuQ4jHQZ2kFNY2T5uVZRjd0efdSb2AyHac7rX00uc
	jo28LxJGzNqqemAZz7D/qBKIh78HAT4GrSY/I+xOdl+UJB4iGDm9E83f6GJug46WdkPOQizPmEn
	F/N2QApkaBw2jmlBdbWCs/gxq741sVR56ATyyAGi1GT/DupFnCVMHXOQ081Q==
X-Received: by 2002:ad4:5f46:0:b0:8ba:3fc9:88ca with SMTP id 6a1803df08f44-908172f1128mr5966836d6.39.1785207752158;
        Mon, 27 Jul 2026 20:02:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e851b717sm78500686d6.7.2026.07.27.20.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 20:02:31 -0700 (PDT)
Date: Mon, 27 Jul 2026 23:02:25 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v6 03/12] hugetlb: Mark some function arguments as const
Message-ID: <amgbtoSMtlTDXgUs@gourry-fedora-PF4VCD3F>
References: <20260727181310.2671972-1-willy@infradead.org>
 <20260727181310.2671972-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181310.2671972-4-willy@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C9D88000E
X-Rspam-User: 
X-Stat-Signature: n7m8fpacfom8ohbjyu3mqbxt5es1jhra
X-HE-Tag: 1785207753-717712
X-HE-Meta: U2FsdGVkX18MXSNEJrba9dosfpBOIulNy9zRMY7oM2+rqlWEcuHDNZ7ibpCoIftKD9XjlZD89uPHVUrS+3AAMEr5mRi+7bl7jCDslSsP/eRrylacOhINkqe+ajc06piDoIwcfD6RprUK4FtTnGxpxzu5hooI2qQsMSaRNiqaVWMl165yP3vMPEp8hxS8uxLxYwp7BCfn8YUXRwH65yfo44kulJ+RitY0xD3RNMOvzkuLkGKHC7vq8C/yxzahscGsQx77GMQ/LiV6ZSOBPUEvwNtrDPUfkcIjv/0ohE72IgcPw6HoNZlriE536GchgkOFf0r4UyASKm8oi6vnj1+o0/Y+u8lJLhe7Y/UD21SzC6ju+q4OgoioDri5kgPrrTwtsnLXxwvuJl+VQiWxfyQPJJbgk++tKAbP7gO5OU81DQZgvFGb0DXxPpFQJaqaoBTYcEaUQZSiRYMWprC/a96o55xwauO3eRPw46MhTmOmhe4OYvUM2UpFAk7YbaS5Nbh86D9XoaIeJlL/kM5nvcfBASzaiSyKz2M8nenP8vmS4YgZeMb38btfFuFwJ3r7BvS4qSAaR/9NeqFsRPtBCT2J/o0ojOUmKcgF03rek8YQ4EUcvQ0K8A1crSIINLkAb6JiObaSNkny799lMc1oQG++n1VhSTRLGy7H5x0WKA4FVEAuetkKZK1+3n+tVtGTWLuyArkNoMupXt1xdVEEgI6VnAFLweIkk4vGvn+isDsNnb1LQdxRh3TKQKyUe9wpkhCjdlaZsvZDfJxeblJJvCfjFBP0Rfki9oCzwN6VjDvYb3sklPmGbmdRirZ0V7xZwKmd7Gk2vyZxcUaerghqPZzOZ7YE8Mf/z+vo4uGOsTdQSDuZh8PJvP699bIOEnU/l3qruqB5aUTaZ9X+YSIPMnamIiRzzR1uHYmTVPuCnMuXTyWbX5CZ6qFprKAbYHrHcbki/OwGQdm0/OktGkKBkCp
 ZuV5EWvd
 2N0DGHsOb3IREvKOBq97xL33r4bjZtSWSg96AzqONByKiK9oTpk1mpwkTAlTbZJcuASdAaV8cQD2/kcq6pJvfejYi8an5BY+ryAurItXgRZJWEQd+yKNff3pLIKv7u+9D5ZNcL0F1YiswKRjZa9eWeW6ROBZaH4CXHWHrvrEex0D+gBhup24MvBjkPBmpu4vKvxZeKveA6LxJgWQhyFlQ6xPTleCp7XhjRic+Dp6yZnjGKtM64U8b23zuiOxcaNp+gwUM23gTVZ2sEfdz5R4A1WGouyneOAY3jsRmK0zDG7hOJ+gw43LEVt/BBXGG7I6TEChFrR9EG+0J41e0Sc5b4mpEHV3ELt1hZXDs1Onbr1uVu8JU4wG3xyvf/uVQAIo7YV/fdUGSWf1XYRnd0qMGfx7j/FQ+JMpu0+FfW0Z10BgpoMGefNb7RFrc1nWEjbWT4Dad9JmX+Y41P5ATRdGKjBlHNqql7lO/6CoGdDk/SleYC6hnoKmM+8vQffHdLhV/zKRl8lmun64OcIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 07:12:59PM +0100, Matthew Wilcox (Oracle) wrote:
> These functions do not modify their folio argument, so we can mark them
> as being const which will allow for some minor optimisations and let us
> mark other function arguments as being const in the future.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Gregory Price <gourry@gourry.net>

