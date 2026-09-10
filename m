Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDDEC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940EB6B0092; Thu, 10 Sep 2026 02:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0836B0093; Thu, 10 Sep 2026 02:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8059C6B0095; Thu, 10 Sep 2026 02:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6D46B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:07:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96C3A1A045A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:07:08 +0000 (UTC)
X-FDA: 85196819736.02.2ED8867
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 100A0100004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:07:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjqdE17x;
	spf=pass (imf14.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789020427;
	b=rQAE8o8tgMA5b+TXXFC+RKVk+HbljlYSaeMfWo7NPHr5JT/9bDf2uWAoKHbQolm+hTr/1V
	zpRPJ3uzvsA4RRLmMB+pytBuTxEFw5V97YQSSuBukSGiqq2SorZPI8DzrE/0zOjBfTFuFR
	ubAhO1Gv29urTxgl1xt+iouKHzKNhbk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjqdE17x;
	spf=pass (imf14.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789020427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOylofx3XljWsfWb1rgg2Z8rQlbMXk1v7xJM3t4UkSE=;
	b=Q3b9ph25viditiPnqCk0Ls1xhOGpchDQp3flBGPAOakcRPsldyRvsq4x5/WhT8xyd4UZHZ
	oQVKlut4JM47Ji6wWjUfcWKiSxaCrMRk5LOtbMrvJ6N0eRmcYB5O95mMhPw9ly2h33QvCB
	69Ka+3wV9heSQ7uMboMF+m/AbH/Hn7E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 32E1E41FD0;
	Thu, 10 Sep 2026 06:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0DF431F000FF;
	Thu, 10 Sep 2026 06:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020426;
	bh=nOylofx3XljWsfWb1rgg2Z8rQlbMXk1v7xJM3t4UkSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jjqdE17xFtq86Ik5aSiQ67i6gtXd+ynBI2lrwVfYA0zuXjgU31NEyhSiCB73Ikn/v
	 jDDUKPhYAHD1vTFRh1zn++I5dlp6obwoUkabyC1ocuQy+kZcdSdGU2YMqPczXG3Bzy
	 J/ULaw+WHRVaCRrAvuOf7JOgiK/DHDfHT/N2LXF3oT3UJeuEDfitXvxL/JLSm/qdRP
	 4Q3TDdcuSdCpMPByMNuMPazqnh2+rwjRV9Xl+MkfpPpoW7Q3Pl4mLRGj0z8adVuMSJ
	 17DdVS/UloQT8ABhf4xBWQfBy2038qjcdbc+e3q+MxetpRMKYxNbr2ihG5lxGRZ5KF
	 0Ii8eQ210zevQ==
Date: Wed, 9 Sep 2026 23:07:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org,
	cem@kernel.org, akpm@linux-foundation.org, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Yun Zhou <yun.zhou@windriver.com>
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <20260910060705.GB6253@frogsfrogsfrogs>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <aqJEWmUN3Jsajoyl@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqJEWmUN3Jsajoyl@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 100A0100004
X-Stat-Signature: ybmbfaewpxnmmtuerog655h9izunhkbk
X-Rspam-User: 
X-HE-Tag: 1789020426-109074
X-HE-Meta: U2FsdGVkX1+5sL6VUrF0ByzznFdl7d/oo6XREJIQWERc9MAFxwSIekqNn96gwyR9pd1rnbl5aJJ84FchKoBB5CabzR69SgOKvofABqobitiazyRlciqLxRhEjKp4+PKwMVvOe3xS57xxO2gfLD9vtRCEsLUOzmtzq9aoOcCGN8lMmglw2TRDV20u2n9gIXnphrtxCKh+W+OxTUqz9M7nH0g2Rapyrjtz/BuDNdwz/phqbTXcirsKjqkzu6f3NvSGznpZpRxffFd8YCmIABK0FRwNsAANIHsNPYtolewcteAAVwPTG5HoevuQwbeplityXm+sIID2tU0n5W+6NwCeHRBNNvJllgJUZBOMM01eP9tHCxH/cSpuxPRmpPiFrDLmi6jjNUt2VTMFAeyxonc5vR3PqsnfhIlRd/Qi2VdHlouaiYfCOdwVW2Qff6TMs2aIkkSadpJLFlPcfxFqG8cWzEme4EWFeUytvPoYnSRPvMbKnSn35hPkYyw7M0/Pjeyf1JOUebSVbFcZfhH4JuarhWPfUhJ1v5weIOSr7ZFOhHxPOvClcYLaJ29mfULykBAdOgVKITkSYQxbhdk4SrPObXU+fcwKML+soE436WcdYTY6QIBnw0A8WO0XciSbM3gGAwrl48EGPRhUKd/Ir1EbxcUNTYcnFFzSx2Q54031QB2D99PgaFdoIKh0UOp/jaWBh+lD2RuQwKns+VBbh2fk3ngx2F2JsOX9saJLGyDB8286hbF+MyUDfnc0Dhdh0a19e25EbXKVwpS9cPzbwghkjlCdlfcHxdw/y9eTJwVA4shNex3X95DWgoooEiJl0/IFybvcGZK97FVezRdSj1XpJ4pQF3z/VvqJEL2LYTCS+VMnzwBDrKnEgSZpausGEjsCZGcx3UZDhev23MX9ltewTTjavP+pLk4J3YQlXCZHKpdkd/qn5NvweD2kaGXoAGit90VhOhsj/Ic6HiYhOPi
 gRQvl7Gv
 RmIaYxiVr0qN6kfj3GzCC+AKQfH64VO6gjOy13jJ3kRl2Y40G4bRFfmiP8QTagjlCyFPUSRCu4wW4ddIvrd5/PMip+Z5qST0uGlsWQfOMBdSzu7utfsfCbe8mSHzvPLBcza9xWacSJlAnA+h+CCyqjnUxYF5JVuc5bRxYdOGu7oUJsTdy4Niz9w40izXiORpeCJNqW6YcAhSBrY6V3xLfB3hYRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 10:47:06PM -0700, Christoph Hellwig wrote:
> Adding Yun Zhou, whoch touched this area recently.
> 
> On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> > xfs_btree_split_worker() calls xfs_trans_set_context() and
> > xfs_trans_clear_context() on the caller's transaction, overwriting
> > tp->t_pflags with the worker's NOFS state. When the caller already has
> > PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> > the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> > the caller's NOFS protection.
> > 
> > Use memalloc_nofs_save/restore with a local variable instead so
> > tp->t_pflags is never touched.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, if you have some spare time, it would be nice to kill
> xfs_trans_set_context/xfs_trans_clear_context as follow up given that
> they keep causing confusion.

Yes please, the wrappers have not been useful for making anyone's life
easier. :/

--D

