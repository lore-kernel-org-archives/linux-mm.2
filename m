Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B82BCAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54DB8E0006; Tue,  9 Sep 2025 02:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04CD8E0001; Tue,  9 Sep 2025 02:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41F28E0006; Tue,  9 Sep 2025 02:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A03F68E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:42:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51757119CE3
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:42:03 +0000 (UTC)
X-FDA: 83868766926.13.DBEC9CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9352C2000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:42:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i6eCdJim;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757400121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAl5T2uzyYRA0jhvrrnRIAi+v5sD5GASLiZc32IGpkA=;
	b=usyJhEA49jCj1cZvTwLSeNS+sYVar1NZcCMezsFIUf9XmwOlZMKZAkMBjP0mTu9vcn6ohn
	WN+Doin8zfQwwCsPoMMcNqkn1SWZNX/ydZFihY+cIkdlT+b6qPB5bJvD/GOT3bPGhjtbjC
	hD9N7sCccsn5CV1J7mCrvVkn9ov+ytQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757400121; a=rsa-sha256;
	cv=none;
	b=inN7JNnOjFtmfd8U0S71aKRXX8umzvtYydGqY/FrCxufSpqXpgZfjhZkxBv7zvr3QlgeVE
	EoqGJTNKMrLwoAioROi+jmDJ000E6u3h17iRv6NRUkqe6R+7zw1ivkoM49eLOXJaS7JzNL
	mPAa0PYdS+bzNDsWDjw4ireGNKn0k+M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i6eCdJim;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BECC438EE;
	Tue,  9 Sep 2025 06:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D94C4CEF4;
	Tue,  9 Sep 2025 06:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757400120;
	bh=z9USPhHY+9Jdat5kLEGPJra+nU71S84ypnUOyEpudyU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i6eCdJimsH7UduTxeneMp12UCWtoA686ChRmjfa2V41DB9KViGwygBjNs2mPN4gYd
	 xFa6ux6/vPlFwRaAyjcA+Jo20+xRxOkFhdkTj3m1+/GCa77hnN+t7tQCdMNkkyQGrl
	 dZK0O1Irshrlw0ro5kpeFROad4MAdnzpVg9iTf+Y=
Date: Mon, 8 Sep 2025 23:41:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youling Tang <youling.tang@linux.dev>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, chizhiling@163.com, Youling Tang
 <tangyouling@kylinos.cn>, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH] mm/filemap: Align last_index to folio size
Message-Id: <20250908234159.01dcceb3be97d4db541cf686@linux-foundation.org>
In-Reply-To: <953544be-1be5-4745-a027-e8c0be7b027d@linux.dev>
References: <20250711055509.91587-1-youling.tang@linux.dev>
	<jk3sbqrkfmtvrzgant74jfm2n3yn6hzd7tefjhjys42yt2trnp@avx5stdnkfsc>
	<afff8170-eed3-4c5c-8cc7-1595ccd32052@linux.dev>
	<20250903155046.bd82ae87ab9d30fe32ace2a6@linux-foundation.org>
	<bv4t7a6boxh4dmjl7zsmhd74wm5hyfpdivypmrqerlpn23betz@tw52mlf4xf3s>
	<953544be-1be5-4745-a027-e8c0be7b027d@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ryh63fcsae48xksms7wfr8tzwuw9uyus
X-Rspam-User: 
X-Rspamd-Queue-Id: 9352C2000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757400121-976940
X-HE-Meta: U2FsdGVkX1+/h872Y7E4EzIdelyT2NMMuIFP1XR0W8GhQ7KMWJgtl+3AipOtk/IKVvaiysJ+g8L6mgjz0N4ETBvE1dtPx0kHQrYboYEhDhwadkZxTw3CBfIC8a3hUC0XuvaOU7nIFmNpuZV1HpRpZlRt2ZoaGONXO4M8YgszfFyAPMuD4UlKCr+IiJ7kDvvc6sZSzCqN/Usp8HJJsAsYnaMrs5BFYXazCcJTfCU2E1jHqcxkBDpemqzrUn06bUrP55Sq5tiXQKAoUD4b8KICDqNBr+rxVMhHYgI36I9MhA0iRrCf0xwH8mHtaUxd73NE8p6NIMZTmK1i7I54pH1rOgI30JYO0Zj1jPCh+8w5F5ijfPgykKZLOVtfFYCcTKtPfWgOHPb3p80jlyWg+hhRt621k9cmDupflmOTSOOK+wlTfcgL3LwPaNxPQZ6CIdAMIvTIEyrHRD/e16HSfv5uIgRq9s0np/9cGcIJ1L+UvoYuto7IgHNqetiN8OJFv8/LqlPQRDyAAGQPKVvIXp/gy7JnUKw4098J9RMb5/WbGmhd+lMD/Ejox3rbKGVlF1z1ibOrnas3kAOD+f++aDLK/A2hv99s71m1F3i+GejtgF0prGRPjzIVeKBV9IAyww6ecAPD+kaoD0uD7muL4RhL7ad/iB3Zv4lMnWPe9Zbk0R9K2x70tmZVK9weSOinjQXRfONfu70xiSbyPaTERnht34cA5BcYo2u0f7GP0JRaZceDnWMGTFPpW9rEa2BOdf3E1WhjhPcAXH7Y2y/uuOaHKLN1aYtsyDULLdGu2dKYfyMPnYdjniqYCTL5/76QfyJPemfHTc71gQyOu9GlE+TkyheD6z0mW8Xt3SszGby/LFdjqhiivKGUza74jdtg0xs95Eb5zRIhJZbKGpe/+684NloziKXHkfROfF7sj7NQCvwU6WdUE1FHvGUzPoBxgUNDkju5rrOxo7fl6a+TCbO
 cvFpNR5i
 5A0RgaNNQ4bcrsLHThN6tis5TE2ygZQBXf+JyidpjfQL2oHBRBYiZeD1LvO1/0hKwQpsv2dNM2yL/Y0UGcMLNeMldiftKoCUFSqcjDwsj1kRFkDlQglEmEn+kW/hLAplxpvCLj8VlR7uM7N+7BGxjn7ose1AaTDyAY7VDVL5GnR+2kZwytCDk02AnnVy+WyjicsQNYdUSv7dKwss5WcrTY3eNN5qjWh05fFRv4cCBeso2OUXNMx9lMGjPMbvirIIN/Ie85OqVf26qTcEoQiCNjKSOGWaIBg4A3uw8Ykuidoh6AlY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Sep 2025 14:15:12 +0800 Youling Tang <youling.tang@linux.dev> wrote:

> I see there are two fix patches for my patch in the mm-unstable
> branch, should I send a v2 that incorporates these fixes, or is
> it not necessary?

That's OK, thanks.  Before sending upstream those -fix patches will be
folded into the base patch and appropriate changelog updates will be
made.  So the end result is as clean as we can make it and the various
updates are shown.

