Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E84C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 17:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA8D6B0099; Sat,  9 Aug 2025 13:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B6A6B009B; Sat,  9 Aug 2025 13:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480E86B009C; Sat,  9 Aug 2025 13:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 380006B0099
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:38:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC5E71401A4
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 17:38:48 +0000 (UTC)
X-FDA: 83757929136.06.8A6FADA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 00102180004
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 17:38:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v71QqACL;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754761127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=koFjiF/kAEQdMPslyFm015mecWl5PIz0kECR7Wjk8O8=;
	b=slaiSaA6ZlqZES7QeH+KHdpzg34enTfqqSf/ACX1yP1R2yuePwzhNHj6shpHqWjRmqD8c1
	CEiRFYVmCMqPuPiWZjpYIzu8nDgbpns4+xmU29WbanietVIfJHjFQgDT1vyrBo+2UYhEDm
	9vQVyq+zhojQn2fe8rvf2Svbl7abETI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754761127; a=rsa-sha256;
	cv=none;
	b=yIW55ExPE5T8LuXaITmHwiX06hpcbhBv+y5p/3d9t8wetm9zm46+srZO9mFtEIATS84CnG
	VG8ob3JCvCLGff4jiqiVxLyXyNhBBoJ7m3o52IEd6+7NlEqyUjskxa7+6/jAeCteTfWxdZ
	7LjIosuRLxlIEbY7qAEWdXMt5c2eO8k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v71QqACL;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22B1F6141F;
	Sat,  9 Aug 2025 17:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B8EC4CEE7;
	Sat,  9 Aug 2025 17:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754761125;
	bh=Wot/69dsHs/GESb54RZeUFnXDmcOEqiL63MrJD9t7XU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=v71QqACLAlEXZHsJC8YNMN9x1cZKNM313wf7JjuOJkxWPIINOxUYRf1+qfmLGBBws
	 dtp/D9xGTnOqAUzIqeAjnr0aSpvDo7W3WqVEEuztO/9dZCASuFpXPUTKxCGDHqI7V9
	 a+9ZDQnabITo35u/Q5NJ2P97bECh29wOOR8T8eXI=
Date: Sat, 9 Aug 2025 10:38:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Subrata Nath (Nokia)" <subrata.nath@nokia.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: prevent RCU stalls in kswapd by adding
 cond_resched()
Message-Id: <20250809103845.21ca58f0a97c0c1f61c0879c@linux-foundation.org>
In-Reply-To: <aJdkmCP41RhNC9FH@casper.infradead.org>
References: <AM9PR07MB78119166E41E86BE5E7DDCC0882EA@AM9PR07MB7811.eurprd07.prod.outlook.com>
	<aJdkmCP41RhNC9FH@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00102180004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: axn5fpweyznxnbfwjte1ajgim1ktxuiy
X-HE-Tag: 1754761126-833456
X-HE-Meta: U2FsdGVkX1/ftUxoedavNJU/EEqGDRNpKRkfC0+r7sXUma/SncXfuOepK6Jh8WOfC0ia9jU8Nj5uOV6mNHKSz4geo+axVfN7Ic0CHsmp3Rsj4L5Fc27eGRFpbJxp08cFFfOTnntxwCAkYQRgfat9dvJDfDiGRX1xZl7FDRNIK/4gKIgDnvhG3fXKZ+52P0AcYmt/MVZ5hMzLSQnbScYmls0RVnmRO27ZWg1ADp1VxMrdgMyD54u+dD2VumM2YCNM2rzjLI47EaZGalo1T/Vt413dT+lfh4i6zjC/CKTUnL5fj/lQKcRU3w8pqfqH9DbpriSx/J++irjqOGbVUkJI604rdDBMq3+X28GtUerzJUqxATDovOloAfVhb2NHuKtswYWaxS0DnIzwjezzs8rVuLYM4Or/TtLXmLN+B2Mt4cMC0YcyuSQGWWP3o40QuWt3bIYLf5o8HBAcsnQcQ/UiLrzf7jzpGIit5eYKH+8GJcEQsAo422nrkOPpYEw4vyzCcp2IMP8Lc5VOtICb+RpJ0YZE8mffuvEoAH0WMsSGvzPwMrklfsY9V7P9Uhp+pUyT8P+nmBteG+1bIEYrxFSEEaXF91OS/797YLZYAAsBjvueG5CFf/VkllssmckR5ddd5Ji8bwB2rOE/5DjPM6xh6M2QyXM9WlvxqwzB+MnqXNdZffVNE/JdGDXVpNW8cPfXU3wYkvd2jL8XulNbJhHtHXiWJQ4BeDq7eGLzLNelK2IlmoWidR50fGG+Kuv/1Q+iRIxVqdp1mnabVOH8sLyVEyt5GN6WLBqYyKMpNe7DPX4RYbciX4BbKuNIsPciwnjTPJv5uyc5mAKrFpZdtnAvxbw5gLCUCC3QrGsq9HZ2iWJ6LwaysD6P4v+jsDYOHn4XBlHdAn8IE412mAezyz3Fqx0eV+2WydO5B23V8hCbKvAj11Fh5rbxlpsUhY1nICKeGT5Zu0RAdr99eLsAA7m
 hbukJu3M
 uqp/t8yiLuPq1ZJWQr94QKrjwV9PTmQlHYlBPG0t4ayYavdo1Qcky6P805Csv7RE4AdklwHw0KrbEvPPAwc6t4VpgzDiGWreBq5Jtkw78OIC8oMCtMCK7bdspLHYbWeRUgPgpA3UF7ZJDDlsUkUTnCJqFogyO0ADG9a7PulK14sPovXHmJsnsJpBLva7JMmMtGyRhdhSnI7u57NC//4wiKrBgPeL6IY8UGwo6DYOScMNuokktJuayOt5FwMyVF7KIBfNs7/MLOBErVCi9nLjKdgl4IknFlkOcThpQE3UFht5nH+/jkH3sFDhnSmDWqSC+vbiCLW5GbheesyDSTU7DH1bySL5KcLxVqWGLMBMVt1J8pYZgmEZ5aMjvHYSZa9K9DDgBiM2n+YYysB0o1uxW9P94A/fBT+gY89nO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 9 Aug 2025 16:09:12 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Sat, Aug 09, 2025 at 11:59:16AM +0000, Subrata Nath (Nokia) wrote:
> > Fix this by adding cond_resched() after all spinlock release points
> > in page_vma_mapped_walk() and in the main loop of shrink_zones().
> > These calls, placed outside spinlock-held sections, allow voluntary
> > scheduling and ensure timely quiescent state reporting, avoiding
> > prolonged RCU stalls.
> 
> No.  We're removing cond_resched().  See
> https://lore.kernel.org/linux-mm/87cyyfxd4k.ffs@tglx/
> and many many other emails over the past few years.

tglx's email was sent two years ago.

Meanwhile we have shipped kernels which are emitting nasty warning
splats (which are indications of possible other misbehavior).  So I
think we should proceed with Subrata's change and give it a cc:stable
also.

We already have 285 cond_resched()s in mm/.  If Thomas's idea ever gets
implemented then six more won't kill us.

