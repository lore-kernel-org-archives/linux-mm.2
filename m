Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8CBEE9B37C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 13:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C123A6B0005; Mon,  2 Mar 2026 08:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBF216B0089; Mon,  2 Mar 2026 08:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0C16B008A; Mon,  2 Mar 2026 08:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 994B26B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:25:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 066EAC03FF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:25:35 +0000 (UTC)
X-FDA: 84501195030.17.5D92435
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id D034FC000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:25:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cm9ngEMd;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772457933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTMVDbQbeLRI1ElLa6iq6RC2XGlgXIKOlV1kIiCGHmY=;
	b=nlckt0eAS9sdXTT7l0kxaKNLzFEZAgCi7lvO225fTSe/LhsRWYzaFj6QgBQLz5Y1yOW33T
	gB/UIV0n4m8OJki3iRBh3p54E9L2NUarAUPb60Jt/VtGO1hjUtMUG0P7vgur1VUzZbV2ss
	aVD3D4q31WIokGT/bOqH4WExR84m2xw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772457933; a=rsa-sha256;
	cv=none;
	b=aV/9S9vKBl21i5BkFllMVFfnYdn2CFvyuufVqtyiNHKrsSdjWxil3ix16cFWfr6ZK84GnH
	iWW5Qzrsk4YzkbCx2Qi5ntxnaqTaCVu8+fTx1P15BDn5tKYgTd9TVBWvlrKOsvRJBpNgkW
	Z72709D2LTc1KDsWngIx7YqW3sHFRtk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cm9ngEMd;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772457932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTMVDbQbeLRI1ElLa6iq6RC2XGlgXIKOlV1kIiCGHmY=;
	b=Cm9ngEMdss2jzM4Wx+ibnvs7x45hhrdVHKis5CHO/CFK/AjhnDrvD6VKf6w8VJYCagknHg
	fQRjT1fgAhyJ3B66oMAHX2yO9gCswDfMgPVLDtDU34a0tFQ/5pPt6m77IcDcLd4smGM1fI
	6zLzoQLPzA6r3nN+hfjevN8F5Nw3bPE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-WaiqILkFNXikWOoTPkAxNA-1; Mon,
 02 Mar 2026 08:25:28 -0500
X-MC-Unique: WaiqILkFNXikWOoTPkAxNA-1
X-Mimecast-MFC-AGG-ID: WaiqILkFNXikWOoTPkAxNA_1772457927
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 542F319560B5;
	Mon,  2 Mar 2026 13:25:26 +0000 (UTC)
Received: from localhost (unknown [10.72.112.98])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6125C1800576;
	Mon,  2 Mar 2026 13:25:23 +0000 (UTC)
Date: Mon, 2 Mar 2026 21:25:18 +0800
From: Baoquan He <bhe@redhat.com>
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	youngjun.park@lge.com
Subject: Re: [PATCH 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Message-ID: <aaWPvlK-cHBlnvH4@MiWiFi-R3L-srv>
References: <20260302104016.163542-1-bhe@redhat.com>
 <20260302104016.163542-2-bhe@redhat.com>
 <CAGsJ_4zBG96YbL7YpZMyLUsNOc6WRCZgntx0mSvJjZvhturoyw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4zBG96YbL7YpZMyLUsNOc6WRCZgntx0mSvJjZvhturoyw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K_iZWyslzTKX8LqO8oigIYCwqS5jkWv-TjtbAyjFTBk_1772457927
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D034FC000A
X-Stat-Signature: zxcui6o9y5geiubhc9m4s48943m8zzmp
X-HE-Tag: 1772457932-57669
X-HE-Meta: U2FsdGVkX198iEUTrl1iBWS9XCNoQ0sAx0Q+ZFPkcsjkbcZ3QtMXCiLni1elT59o2eHftxGtyVEDiW+LThGS/kvR8emgb6uG6u4Bpt9M+Vjtjmb1n7oulufAu518mwH90etCgprwyoxZn/P2qGvAhAJ1/yOROVez4vST3rOoSMDJobH6L3rpUf0QHTxEw3TzyByAph9HOvYZ5fuWl8LSa0y9Q5X0aHDbNtEY7R8iUVGhwXNGQ3gSsqW7k0xsjhZTjVSHh9DkT2FtapNTKvhFVBQrGIT67XXQQ5uFNKiGODlrp7sJSxAvVbjiA9JrVHapDIcsDm8nL4HnlcUo+RtJAkPGd1i5lfD1ekPjAoZPfInBf4Y3Ldp6unSfS/e1BttOZ3BQnlDUjn/pnMWg5H9TM4NyPvhtWxzbIKzsMByeSdSzc9Q/p0kmoIJzNxdMDC0n7TRoBLSRtbxPGbLD7mOVp7ZRiZud4X+1g2it1Z/bFxg/4r0hjfeTwHUcx8d57nXDRmdNNliu4rm7VXS0JUiqIPAM9/6+idG0rXKN19glQZXCsAJuwQWS2g7tPOOfOz2RVJ6ftLBeeoiJxkglOGhGr5LKqqbNaOt+T1YWFT+j3mGlt/H5DgSgLV80b8EmJNpbTshxz2dEOuysX2gYTd/C3s8e1pnboEihCsQMnNLokqs9hJRkzJLDV1vCyvjPd+1hxP2ibfeKajGOui1nYpLZwhxxPGoFtP+UknBsXhyW51aKi8Ayanv/HlodaR+FIThsirZ5sLBo5RPuAoIF7oaNf5hOTKiDlZtRdlmgG38jSk8BmrpStMzkrMELPyKNYp4JEKE5GHbPuFZjXevgDhn5zwYQpygcjxVmRtkzKx8FVx3aSqwhQAN2EMbI/23AbziVh9aZyk0XGQ5X7w9hoHcUoXfcQKdUuod45z8uIMi/1GMLHAGUdVYse4+B9MIgj7pqXiqsEK8C4aZz6RZqk7A
 +0p2zrP1
 FsRRQ/JqdNynYX/SBAI4XbUPcaGYXobLzETqqwS7u5t0B9sapL1jUOOoYkAzAS+PaQp9DLjaqhdLDJSIVrspZDFmcDFx0JAaOAIUS2laJVTIHLvXhI4Vikih+sXhu03IDmZouHR4EFrygSgPu7uqdg/O6Bl+wpmeKQDBsC/R02i0cJncVsBfq8rkGg/Q5UQhK2G8Rmh65nTcHQG9h94NQl0x805WEV19dZSFIWjw6c/D/s0PfLjYxEmGy3w+TIrY3/6Zh0ZBs5aAr0xFGiJjHpqAff5Faw5M/jITeyWsJt0G8swupSN/qtJpTdCMZNw4dJkxEXjMWYfc1GDzTt3TQPd+ZeSaFLkmdIHj9P2yDwunFARe1WkdsGu2KCAX/UAQq/dWMJKfxqHRLmnOUsxNrbUxNH3YFd+plzSsqM9BUFyVATro9/6Blxw5xrqKfn6KG9JOVVLUAWYC2LSHIPzTxAp+lw4i4PREcGonAN4K/9o4ufqayoMoo6JKaYAkWhqZ/CMfsRSzUevOXEcjvCFXDxD1zJAuRvwBn/8aU139UY71MEwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/02/26 at 06:56pm, Barry Song wrote:
> On Mon, Mar 2, 2026 at 6:40 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > Codes in mm/page_io.c are only related to swap io, it has
> > nothing to do with other page io.
> 

Thanks for quick and careful reviewing on this patchset, Barry.

> That is true. Meanwhile, swap.c and swap.h contain a fair
> amount of non-swap-related code, such as lru_xxx and even
> file-related functions like deactivate_file_folio().
> 
> Perhaps we should consider moving these to more
> appropriate locations.

Yeah, agree. I will see if anyone else want to do the tidying up,
otherwise I can do it later.

> 
> >
> > Rename it to avoid confusion.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 


