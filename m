Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C28C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 19:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4243D6B0088; Wed, 23 Sep 2026 14:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4FD6B008A; Wed, 23 Sep 2026 14:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA866B008C; Wed, 23 Sep 2026 14:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB7A6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:59:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB1DD1408B9
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:59:56 +0000 (UTC)
X-FDA: 85245941592.13.06C5942
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE468180004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:59:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FMo0I0mj;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790189994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxAHc90wfm9SnYwgDzQ3lzFeh2jo+c35yDwusOijFh0=;
	b=ZuFrrC8g8FplbPkSjQny/AUSaxmfVV+aw05YpU0XkuI6qN+HLHdfMm/3J53LcZCQNulS4z
	B5b+M5NhwkRwlpneDsVpXbNDgcjHlkUWbvPkocEhXSCsD5DJ91Krv74pnWT6hVpHc/jhgK
	OpvZF9MZ6t2IBxh4Ru+Ea10SeVJ+ERw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FMo0I0mj;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790189994;
	b=arZJGoMHPUeej1UOfwTy7k/cyp9ZGGZ9nulxaWxWAGUtfqBnLnSCUPHYcG/DjQEZo0CrvX
	Q68caI+WoS3Ey5i8wUtb9jS4TsJxl6EmOHlr407rrzGMkdznR3tcTlmK9yxkeMSZea8zeu
	/V9rL9XqdRmvK5V2ba5Y9wk6VxDveXA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AxAHc90wfm9SnYwgDzQ3lzFeh2jo+c35yDwusOijFh0=; b=FMo0I0mjZm80/tjeOHoyWLWDzl
	+JuS0LUThspgxfePa2m6QvZFrVS2IkL+fMSRLNOGnm9aK2VsDTg7WzZFfIFia3px4gILuUpp2t8UQ
	tR6TQDgjn1eveDqqZ5pPLymPIHQuWVryk1YIFw66DQ5XHmCNAgFfQB62LewPtiZ2y52cIfLOXK0zz
	BsKjJl2nJ858Zb6VNfGOLDZwwvq/DYzSN1trSEYTOv4Gzmpq67PSxlxjLdCiEAwWsBrULYuhmlWem
	Dduf0jWFkxom2bLboq32Mh3D2rdqxFOHzyxgfq8ak/0OCMAnfz7iwwWX/RpUFmovH/InQrYrhF6ra
	BGNX3Tqw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9SC6-0000000EAf9-0aJx;
	Wed, 23 Sep 2026 18:59:50 +0000
Date: Wed, 23 Sep 2026 19:59:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 06/15] kpageflags: Use is_page_hwpoison() to set
 KPF_HWPOISON
Message-ID: <arQhpW5tKmu1Vqrh@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-7-willy@infradead.org>
 <3e609c64-a393-4667-be74-6cb2bbdcb717@kernel.org>
 <e68018a5-a8d0-4ca6-b3f7-7a151d17be31@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e68018a5-a8d0-4ca6-b3f7-7a151d17be31@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BE468180004
X-Stat-Signature: dzsq8f5o3so1e3eaqsf65skfnwakiur6
X-Rspam-User: 
X-HE-Tag: 1790189993-763979
X-HE-Meta: U2FsdGVkX1/P03IsKhiBgOO8MvE3wx580YvQo4SfvK1Uktj0RPIPJqdlhIiDJsMhL1KLrdJxuZaElVeXNyo66VomrpgsTuKvrr+YHvTs3IKp199w0wSocb9z5PpIHpHyAYUxH7rbktJzBGkZCFxOx6DKb+cVwAkf67MevSeWqFgBwUlSPYiWSX8fMrCPht8zfkhFkO2LbWJZgd6Cc/xP0MMJHttRUA2MW3NLDBsiSaJCltqbfF86+dJtRDIGPtO5Ol+0yNGw/8mEXyT/LE8iH+goDjjrNocH014t66Sq26ayM0JqO1rlwAebpmjsnJFHSSHy3xhNwOAy0KdajZORT0KUMHGsjOcUMpsogGpv7SYNZit66ztbm1+mYPCw3Cfm5yiXOU4c4PBq+bx5GUZN1BBliduuol7VAqyPUTNwRn42WW8+LHCAJwhD5/M5jAxfRJfKJEiwb2BpjKt6joTzLwYoMuleEOslR8zdMRc/Vrlk1NkppoQrK5zVQe/ThBiKK+gvRBSpEguyWxlKqrLa9tBPNnKW9wvuOvRkmL/5XPdWmxtoHvwrGhgReuAPW+BTSOfcXMVJ/CLOPgdsWCqzGlEVBMHZ7mkyr8b77rAqBf9pu3zVtMDADanukTIrCgPhdHwBth8BdpZEECyh55wii+Nr/AgSqVm+GrDNil3iBtSArjuvZ7Z0JSpTLCDmeYlRRMzevEhTthcLsKtyDD7Zr37R88F20oSUtmneWx+TplHIOHExdlL4rHCuLs2Lp9Zqq7vc5A6vw7gCm6bPKaMtet4PkKTxGhm+gsAiYKvEmw8qhuVkNWjzz6WNGDuMKDACaVhKdT/lvjCBgLyARjXxe3uTr8Z3czatyTWgGqIeHeofBgDUuW9SmRDbu+TyTOo0CTBwoYxOaeat3daL4mAqbnUwpVP9zP/270rrYpmgNA5fHJvsSUd414v7yQHFYTz/hNQTdoWl6rCb8D3OXV/
 yV0HEy4d
 dsteYmemdpwoHM20wqN6uVGB7SXEUDjDUmaEgQVEydYtCA5x6oNUIkr4ORlbLVrPaA5CcH7qwtTnfZ3h+QAXbNK/muJXyDqWchhJKuOe5oa/Sp44zMys98hMCBXRwyu0G5puaUHvrPMFvtzozjCFiwRJKePkGeK6Lhwk4ilaHFBfHV7OPvIp3CePRhbsMwrHxa6MLRnxKJ0eklzHxrq9CfIYJM3keCS+5Wit01USgO6p/pFH383ZpBjy173IR5ovzdo49DGLOoQWcQIQyFAEiGqiortyAoUssNwecyol8p3fzpN3MH0cZgEtpf27lJ8XC8riG9P5ixRzk9R2+LAndf9bQyCS8xFqqPxg0rK2uqDTgcmjlizmnTXiduQBBojRe+sIdty8J414PwnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:01:02AM +0200, David Hildenbrand (Arm) wrote:
> >> +	if (is_page_hwpoison(page))
> >> +		u |= 1 << KPF_HWPOISON;
> 
> I also just realized, that other users in this function now use BIT_ULL.
> 
> > 
> > snapshot_page() takes a snapshot of the folio and the page. If you look at
> > "page", you start going to the live version again.

This is now:

+       if (is_page_hwpoison(&ps.page_snapshot))
+               u |= BIT_ULL(KPF_HWPOISON);


