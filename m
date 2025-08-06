Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF52C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261AE6B00AC; Wed,  6 Aug 2025 08:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212816B00AD; Wed,  6 Aug 2025 08:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1292B6B00AE; Wed,  6 Aug 2025 08:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 057AC6B00AC
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:55:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9ADB7BA3C3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:55:46 +0000 (UTC)
X-FDA: 83746329492.15.C93A371
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id F28D014000A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:55:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iv3VRSG0
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484945; a=rsa-sha256;
	cv=none;
	b=2ASBnkRwW7EXdC450o/I81QliVUOkEDjv5mgBq3XGE3ny7Pwgu0y85MoctQ2cWizVSRXPb
	gpGR6h9zP+7hPvJ+0Skrdb8ED4RdJ30j/pWX0yeAvy9Mmkjx9Xf2Dl3Zr2oetxqZ13N3ga
	SWMXEUByudAKQB1LYk1FUbe3g6o9+Bc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iv3VRSG0;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=For6rattvPC8+RKvw+qt9VYJO6+JT5cp0bUvwsDrq7I=;
	b=VZsVMmPrHMR3gwCX5PG7s8cWyT+zGmmMZR2EtBEngzUMrbgcyxOK0oHA47YPC0urKXf/04
	ZbLk+6mwEbk5iIlZD+rnS4bT1ugqgqEm39arNlCFQL2UC5tsCBQtw/p5k34CCKaV4DJnZh
	WcxhY07eC7VrqjtVrttrR463iBX9YmY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=For6rattvPC8+RKvw+qt9VYJO6+JT5cp0bUvwsDrq7I=; b=iv3VRSG02kMFUoblG0wKW2/vFz
	4kuGujwPuCHuT1jDhhkZ81+uDUsh5ivtTAaQE6ikVdQRjW86l1qeD0XVHQLDWu/YBYF8Vnl+6+YOe
	P9j53slzEVSGElDUnea1aP4UN9+mlEFrF3p4sj7myFmeB5bcPBRLubNnZZcreHBGC90inoV/FdZ1K
	y0d7EpEEUx6QxT0k/TZfiZdFlF9Jz3QbTqx/nAsEoCB3pCotyQ8LgURhfN3Ms4aq0OCX9I7mQa+zk
	TGIdBF+G73p+VKLCbsOqGkDDq857FGxRgmBKN3Z8mr8VRiwNuWZ06dVcJW/zUz/HLCpkZi4nPR63Z
	vicbm6hg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujdgE-00000004Jw3-3boz;
	Wed, 06 Aug 2025 12:55:42 +0000
Date: Wed, 6 Aug 2025 13:55:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 00/11] Add and use memdesc_flags_t
Message-ID: <aJNQzkh3vHhGmQFl@casper.infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <kj2ram3biys2ew6thxq5dlbfl3h6g3pyhwat3yzm5wo4pahe32@266jiri3eokk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kj2ram3biys2ew6thxq5dlbfl3h6g3pyhwat3yzm5wo4pahe32@266jiri3eokk>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F28D014000A
X-Stat-Signature: 7cz1w9cc6pjr7aj3p3t8tx1xnc6i4yei
X-Rspam-User: 
X-HE-Tag: 1754484944-89542
X-HE-Meta: U2FsdGVkX18Pl1jNta1JS4qm5nzNDhXZdE6WIrnuQw/LkOAQDFN6HquWE0huj/81ULGTxkKMpm5j3cVS1aO8LVO/YclHiYA72/TltbWrapn1TM5xvPCiXOqPsSTH0jpsQRzY7Mmyz/KAkmGFIeyjxueaSa/ridrbVru0XqKZutXeAZNfybm7TzzvMy9aM67dHcen+bdFDMrtHSo4BxfpRfuniFOEjIOwOM1m7MWg5eTg0Sc4HEsHqwgJdceoY7pWcqbDAeJpm0xx/vAnmHPFqxrkk0UbXcwGKk/Caw7vJ4791mzUpUFdl+dAbLj/NJR/CJo7ModZ/P7e9FZnvRrTbteq+WGWNoHU7gLWRnjy9WX+q1O5y23U/9/U9jHy60Ox2GB5vKhxkS3nUY6e71QPxiyq+0RCpgb4fLLP6T1KIIYiEfV29M1/TH5L/5Q2orH3ZserElT5+Du+KQcLPXZh6CA/PowHWWZQIMTuAcxgjvwTJHOVa/8wWk8u39AZSHbp6pEc3mkDpwgJqCb6qw1juFd27uvW1l6SvZ0uuFX0obD0dUCSjQw8v7DUoAP2XMf8rHYYdQq6ecb1U82J6aCWziDTbkY++lKM6sMEnAOyfJfHDIjZVrKjrNKW/e/WX3iYFgeiw5QjAXB0QQGtjyL2CaVnPhZC0JgEk1G6B05YETX0pOFFXoA7jbKnRVaQuGPmObk6CbN8InitF2FZo60zL3lEyJWaQpmWAL1/K2gwUp0lvAp1mX0EML5dppr64EdfgAUN+obNXDZSpjGxyoy8Fab+dbb3y4Bb3PbVivdzG/oGhB/nWqIogrsv8A2Ly/bRESoydsfJM/+vxa2N3qxFgj9C6lI/zLYI2mSXMQTCKgg0YY9ylzjk1D+hj9JMilinU2zQSmjlogEAiVJlOR59I6vDsvmjBZYAQMocgycs1LEDYKZnmp2xvQzV6jGorf2OOkjN8NVyIXiheUPrUdB
 CHUFpvva
 yBXaU21lLuQDUHV5X4te64QdM8eM30xW+l1wGYyNqyhv3a2JBKhV2AOzeaJ8DPf4C8Q+mA8M/AOxvi/jcFUY/QPWgDffRo6J9Mk3+xCjbmAXDKrWSkJxCZCKUHC2nMQUcygEOkUjsuqfDm0/0YV33nifItE3JxsnexbTvPRZG7Zp8I+KNqjtB/xCA8g5wRNhH6lhcG5nBQOoZe9pKTBKBEEpQjR/imGk8EKL5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 02:40:11PM -0700, Shakeel Butt wrote:
> On Tue, Aug 05, 2025 at 06:22:50PM +0100, Matthew Wilcox (Oracle) wrote:
> >   mm: Introduce memdesc_nid()
> ...
> >   slab: Use memdesc_flags_t
> >   slab: Use memdesc_nid()
> 
> The above three patches are missing in the email chain. Though I do see
> them in your pagecache.git repo.

Thanks; I resent them and they made it through this time.

