Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AF2C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6E16B00A4; Mon, 21 Sep 2026 17:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787AF6B00A5; Mon, 21 Sep 2026 17:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4B46B00A6; Mon, 21 Sep 2026 17:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB506B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:19:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB266A02DC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:19:48 +0000 (UTC)
X-FDA: 85239036456.04.3004028
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id C325C1C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:19:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BGqiyqf6;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790025587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsKa6xtGpVrKjIKV82En0dvWYXbJt5+yoZDKyIsIQkI=;
	b=iI5tCDLZdXmelZMFCPsWuTKYHP2R6C6mSQLEfzHNQ0NtcYxbx9AzKDPY5Y4ia6T/GLH5MB
	MOPAXqhB7vrENRFAoH1oL6HCGufskA9vr6G5liC4u2HWj+yL/yd1lx4dSLlwfit6x6cmJ0
	whSsx+79in39s07gs7WjUqvA4hWAD1o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790025587;
	b=haEByHd9ouIENgojCeEWpZONpiqiMlbnt76Xwe95MS6L6uoMzvWyjAwqK/b79nZhyPyKVq
	Q9NHADsEKjl8eSt+gaevwQueLFMp0P6114QHJ0GRoVV3MZf7Tz3UY70w4cBm2sEfnP6qzK
	ZpAvnuYwwgRtfnNfzcfCBI5DSQ921Bw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BGqiyqf6;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RsKa6xtGpVrKjIKV82En0dvWYXbJt5+yoZDKyIsIQkI=; b=BGqiyqf6xDxb3nrgigpwzr6zw0
	TsULh7HP4rRDfVuvJZdXyMBCWNYoLFwJiSlbb8HEl/J0WO3r6BYhGCrzTBGM1dmzVPFYwffeddwew
	LOapQ2TrqU5dhgRK/8UbAPF0yTfcj7GtckO7RxKUx/lsw6dI3Hd45zbaJ0xTLFy4ryv2ZQMe0OfQi
	83tGp3Q96YEkmcZ05AySXfFa8mIn3HFEbWVXWyqaqi2rVRKGyPZMhT2Flx3KpsU2VMe3qA9MR2Bof
	J5ImoJnfCyBOL7PuiDVZnLRRoPYg7g5OeoL1RdcRrfoZY/dZtqK7ZUYjfnrHibyUTrA24W4U76tiK
	r8cHKrhQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8lQM-00000005Xnu-4A8c;
	Mon, 21 Sep 2026 21:19:43 +0000
Date: Mon, 21 Sep 2026 22:19:42 +0100
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
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v9 14/15] filemap: Add support for authoritative mappings
Message-ID: <arGfbk5Yv9UTlNqB@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-15-willy@infradead.org>
 <0e0a0908-8e5d-4cee-9fbb-ce730bb662e1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e0a0908-8e5d-4cee-9fbb-ce730bb662e1@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7ng9px6xzsgmshaq77eghso3iarjb9qe
X-Rspamd-Queue-Id: C325C1C0002
X-HE-Tag: 1790025586-1115
X-HE-Meta: U2FsdGVkX1/5SHp+nP2V9d2D6ZIi04TZR53o6sKBA2z2CQMH3BoUinL/lPC/DGvH8iG+cDPtbWEXIfERYB/t0IAOrhlpMlR1Dr3w/svt/vUfbVpvZJAV0XgOYbRwH1/SuvF/DMbVgRbF7CYf+BM20H8YvjfZrk/x6iypz+N9j+f0q1NzLxzvSuK8Fi/CaZk6avtRNYkZyYJQPxPRN6Gipogk4d1wR2a6i53Ycihl+phM2BjbAupjk26slHrPl7FbWizTnYZzuelDezmV254jyZXwMF+AIvof+sXbQfS+gtq6M4VzHwtOW7nGKsWZbf9jA1zXCj+zI2+I3Ge9OTCf1btRrFltCuK4/DhVZd49qRfE1wtoCu3JH8wrzImK0jvbUI21e9h65yf9UwQDYpJDg60TSUlJSTy3djyc8SQsZ9eHkQCfLqvmcUmgpoErC/LkCvGVPoaA9oj+EK9ELsmoW7k5FKwihhXg3+obMcAlzdtz5cI3+riH092kqa1cBg0jdHQo5UnHeY6xwYBwmcDHLQcqxGiPqhuZ6iUjuKesntNiPEQICbVVN3lqhrE7/VZdGvlRgEp3wQ33Tk7F6VhM94rNx0z70y9eaJTiGWd7/3y/gH5MwvDTsY4p65D6yuOckJXe2pqBaARX8krgWE/qbA0D1BkbnpnHXI1S8uy+wmgl8plnpppj4DS/zZ9Bxnw1IpdP2g/5RHx4CCI098xLS51SL/VyG4uUH1iFI6C3Ujt3PKpQmockNBV5pRlBd06dIue+bbBeqsAjKX1uIsRoPSOp6WsZNal7mqBYQapjsQ9RB3vpP1Ar1DzlbFuRtrwuHEpVR0ieZUWoBSLSRQQL4Eq2Hia6f7JK+g9269rZV3vWMr5z3IR42lJXdx03hUVe5nVSu+i7vXUc2EIuQrjc9zO8CSY8Vtdb7FLjeDjIZtlHWAeE+mmcRqKadPeItr0BvN8eD7BaHL4bln79XYS
 EUdhGth9
 zF6Eo3K0nNNc3EdVtGK7VeMZqV7q/or/K8X4bxWZ/mf0poOgwuLeJFboESCShDch9IZAYKOSulr8Nj3fedwVh/3Xicn3pzuJvCGfj4ScgJ26GuHl3jRC0GmwZuc9PfPLwN34snJyeZdA0DdOcsThTpCCvQdxBtKveuNIuqgVIW3s+53c5VrFS+BmBczPDi+1T5SqCuaNbUUrFvrvO+AVpZXqNzAgAXinqeiI26gOWPvqGsHjD20AF0pAbTnDLzuJEbasyrrhWD+v5wKSHh/Z6c4jSVjyPV3c0DLA8sydIvMD1p2wcJWxPkQI8n8fXhceYzSzn1EUxInsBapFp9y5d7KgLOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 03:51:59PM +0200, David Hildenbrand (Arm) wrote:
> On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> > +++ b/include/linux/pagemap.h
> > @@ -210,6 +210,7 @@ enum mapping_flags {
> >  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >  	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
> >  				   account usage to user cgroups */
> > +	AS_AUTHORITATIVE = 11,	/* If we miss in the page cache, it's a hole */
> 
> Just curious if "in-memory file system" would be a different way of looking at
> it. There, a hole in the page cache always expresses a hole in the file.
> 
> 	AS_IN_MEMORY_FILE
> 
> Just an idea, because that's why I always had in mind regarding that (all state
> in memory).

I suspect that's always going to be the case, but I don't want to be
quite so prescriptive.  I'd rather describe the property than the user.

