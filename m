Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7206CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6666B00A6; Thu, 25 Jun 2026 20:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A664C6B00A8; Thu, 25 Jun 2026 20:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D5F6B00AC; Thu, 25 Jun 2026 20:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CBD76B00A6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:58:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9A8840258
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:58:23 +0000 (UTC)
X-FDA: 84920252886.17.D53C3E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3219B180002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:58:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=G6Hk0z2y;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782435502;
	b=MDnyNyQ51/AIviufu4ugFK9878Qj/nhISyO7JS1XNjIp9NR8nM19J7mo0cIhVCgzhk9H5O
	zihA6/06mhI7NSx+7fKSv8n33je70ui6ghxYjOCcvb3x/eLBp0RFQ6tH+1hH9ZNVKeG9Tu
	GEdcriDK5hCn0ZGfsQb4aQeusSOXkq0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782435502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAkkL3sPm5ZfzdmjNmlGFuALBQCcFtDjbOh35GYhvNM=;
	b=CapknLIrpf8O5C5Gs/QZ5fAYwHE0xOVCRLE+8o214E8p3t9AlgMWvVa1gq/zcsEJoI8MRf
	sxBH6n7y8gyYi4g7Ms60/ZuuRN3zBs3AGnA1jYnemQxOaIbjqsipETYbStt7vxLbksH8ob
	bxQXOm3/CmIQXCFCzvijX9jWkKUGVsc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=G6Hk0z2y;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31A3E4419C;
	Fri, 26 Jun 2026 00:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA5C1F000E9;
	Fri, 26 Jun 2026 00:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782435501;
	bh=TAkkL3sPm5ZfzdmjNmlGFuALBQCcFtDjbOh35GYhvNM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=G6Hk0z2ylq/Oy/aFJH+415QHc50i7/EYqo3wFynduArUqCpblGlirmquZkLrq10MR
	 I8AL3Vdu7/MaQPVyeo6ceuWiGIEwARnndQz4E/EbdM90ufIi2Nz/MhJD5da/cwD+Ve
	 3bsn8HctYrKuNFCbsfe7/CGUvVz5Klqt4L58aXiY=
Date: Thu, 25 Jun 2026 17:58:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>, david@kernel.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, ziy@nvidia.com, sj@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Lance Yang
 <lance.yang@linux.dev>
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-Id: <20260625175820.cdc6716095c3355257726afe@linux-foundation.org>
In-Reply-To: <20260626004416.vm4funxhn42hbi3c@master>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
	<38410976-ddac-4848-a4ff-e6a9f7d9c828@nvidia.com>
	<20260626004416.vm4funxhn42hbi3c@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3219B180002
X-Rspam-User: 
X-Stat-Signature: 7aqyzwofe8nem5wh4m7ft9p4pam3ax6o
X-HE-Tag: 1782435502-287787
X-HE-Meta: U2FsdGVkX18rlR8hCk3uawKzo/s7Yevcvjs5uEfjPAlEhhJu+uj3x1fd3kMkLiX8+1vSE/3sGjyqx89zbgUFdv34NwUEwphPYLZxtQMrZKVvgrmSg75ZgI/JBbtChYcV9gMT31pnm8W8VWyHZhEwxrAmgR31hsLIXC6L+GiLuOago3//6BGh0IKjQGfAKVDDTfW9suSp3N9Um4EViYI1nefrK4wHtuods89u1Fl+k5eFKjqhGn/uIfXajUW3lLrHAp8PGOoUsyED+wwUDeW1iNwuVJ9IDgDlupRlSND5ULbkFmCMePGhxzc/okfFXRjUOYStBq6pLNZ9PBXdUg9z+26SRjq6wnmtNHqNWZTPvLE7jUau4cwvNJZxS/DmSfG398bAksd8WtVe94fG7zFekjdZHKfc73IOrEC5lqA4rkHfD4bZJU69pb81a1eQxSg3sJdJ4c9XLF3k0DaKgkSJsmaVgRqCOuz3HmpPHEWI20zACagFNxCi1F4zwo37diGjO7oGtbhb9vWsqD+xMiHToboXbGNfs/nKWbJqkCQniDauzqJX/5qpRj8tW4f3e4l089wcPC0tmTo+0NhqRBDkEHeXHb5YZlm8GyLUH/gbAP4vlZilL3sBgWxx0eeadfm6pTYQBRY3pcbasSeSgG9OHlYqxdLwi+n0Y7LNtM8JeNPjD9TGOzC6sa89G2K2lpOf9KEur9dIklUbDV5gNB9OGv/z+1CqHkXfUhlH2Y0FyQYNDv2pVSTspk251b2peX5xgV4FdCI3gDNRe7tfegcXdB8dFli2uyvS3l8MIuq5ymqKd8v1NvpIMBCx7wJicNkZ9c7zcMZp/ffLC0dPG0KjlIE1Fe6ozO2vktEw3Wdl/EqX1BHPhWDVkun9s3LHrayDff02LL6ljyGP7JGAUG30TmJFIFPJfCOEv4JEYlzrMxxaeZN2iokDHEHUMUZEkSp1f18jHzRmSvibrVQYCdx
 23Rok3Lj
 nq0Rs990dryXXx59Xz8UrVD2fP+Dxu9TPox8MI3vajLJlWddddEAyPg63ycyTGzTHd9rIDEErqd13A6J3JV+EO9O1BQMqR7iRcBydwRMNehgYdMZTkynzPbAsoTkds2U+JbNnmsf2x3CFVrUZgtbrKWpJPgkAUbW6AJYmqcvIxgTuOuooWvxVoIcdcmc+1c7ZqAh8ndrE9jVg+Kn+KSotStO/bpbyyiUIaPiVtXDMUbcBEzrqJogxzbxCRZWxsSzGEnypiZnPp5khWC/GvUz4X+Lo68PZuGr9q/d8Uc9xheOBW5sL7pmAXJX0AOxXoeqXv1ZL0JtBqZCVJQtBRrlgBaIh4XTJB2la81likzuP1/KB9ojF3AT4UriVA0aqFB3KmmapibZKB3Qd+A+nrOXgLN4saD7qc/KNJVf/BMJn4XunmTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 00:44:16 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> >Should be PVMW_MIGRATION and "us we do" -> "as we do"
> >
> 
> Hi, Balbir
> 
> Sorry for missing your comment.
> 
> Hmm... looks you are right.
> 
> Andrew,
> 
> Would you mind handling it or prefer a v2?

I have made those edits.

