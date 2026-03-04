Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3887DEB7EAC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817A06B0092; Wed,  4 Mar 2026 04:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5BA6B0093; Wed,  4 Mar 2026 04:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A73C6B0095; Wed,  4 Mar 2026 04:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57FA96B0092
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:30:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D889FB97F8
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:30:39 +0000 (UTC)
X-FDA: 84507860598.21.30EB026
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id E52C34000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:30:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CDaALdUp;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772616638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUzQoESoh9/PqMSFbMpuw4Pmh5IPXiGP/qvOjxX4wwo=;
	b=F7o2mTHfZmSJelvrIXunIvDerNm/TKOTQKDWEc01G2muDAVNzpRSCEkSj6eUQ88BZArlSn
	Q47WScH3RuswPhsM7GdG3ayMcXHK7X4Hi620v6WsU44l4WM1B8kxzUyrCa1D6E7uApGeB8
	08pjiOa/fe0HS9Hr7Gy0PqJmfqm/Syk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CDaALdUp;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772616638; a=rsa-sha256;
	cv=none;
	b=s+VrJUk2/JyGHp6y/982wRMP20Lb8bp+eCAhZ6p8mLq7tZal9UbJu9hw5c2956z84oVi1y
	WfiBOhGKlS2ddHjkhlkVU7JU0QMYfe//dJIK9hQGvpfKvPeKrZ+lrTyQod6QlJBK59ikXE
	QNECLnd7vh9rTX/W47yXskh5EL40n90=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48371bb515eso99247645e9.1
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 01:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772616636; x=1773221436; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BUzQoESoh9/PqMSFbMpuw4Pmh5IPXiGP/qvOjxX4wwo=;
        b=CDaALdUprZmgx9tWH+AgrjjXuxP/h4cdWjUyuXkwyFbIRWqGtZp4GCDqBvhkF8TZvD
         rQvLeO/9gu3gSE9FEuX+qpPq/V+BysI0mkuY+94Au3Qa7Wq3bqdhG5w/yJGISLsqh3DG
         y1tJ9Wv6V6jzKFFV0ZpN6/RGP3NzaFp0XtN2e93Lj+oMsZYsBKk61lddDKZBQt7rFVE0
         33crKQ2HYUmC0c7kdDRN0FjsXKQ1XC60whCjA4HYyrKHr9UCUGKfK3qFGfA/l1pOH2FC
         BV2cY2Y3HP35FM9UQfvnrAQ3/rlbU5CqeNDAm/aUFoeuYCM6aXx0/YMz3wxJGhmdhSCj
         uacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772616636; x=1773221436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BUzQoESoh9/PqMSFbMpuw4Pmh5IPXiGP/qvOjxX4wwo=;
        b=ZCOoVpsoSuJr6t4TGcP3hkIPjuIq2TRuoHf3UO8EkL64YAPBCvi7PN13xNcrf0jJmC
         6j8i2m2x6Abi7UuYiItw6XxNw00LVUhRJIg6Ia63/IFcyHI1gu1RDvwuY30a6ypxyupM
         j/4TjQ8ildFGkZt8U5079Qay8RN6XY7XJxbep5C0jLhZ13JHVFNtt/cTMMiiVr7yhklL
         PRyW+VDrnxlAYHLmqG0m89DgTfnPT4XscLpZCKf+YC+xuE1galvSdWpmPkrDeL3SbkXw
         nQt4X1WHaXFka4dZ0FTCrSOD6tTQ+h7eBDyIXsib4+OW6qA6f22c07mUbOc7XpBkell6
         22cw==
X-Forwarded-Encrypted: i=1; AJvYcCUC9qq8DRWTaFPWE2W0J8h0VvpChIq7eucjGH3Qt/SafLRnTq3ZowhmCV+oRIbiQhID0coy4kCzeg==@kvack.org
X-Gm-Message-State: AOJu0YxIlMINEdx6pTAThlC8D2o7lhdwZWPwZZngSTIQKAwnVsb3LdMc
	glGjW6rb2VO/vvBSh0ihQAcVeJftQdoNGygKsvAKb6o43G0o5KG/O0SR
X-Gm-Gg: ATEYQzyCw9mJoeyV/PrA7KBcBBrmzoTYtYaIbMOsgz+JadI1LvLLjNk90o4hOa/31bV
	L6cVty70IrrYnj5N0+dVTCzd8M6K6E7I0uaLLUOQF4uZUdMOql4UuFkSAixiC+09I+M4IMSqk2A
	L47Bu0QhI8qSSktmpN4mGaXSfoSG3AgIE0BNHkbLX0LQ/LcGaxYHWq9ikuwkYLW4t/D3funEz/C
	XctfqAov9HgDDt4/fBwk+ErXruLy5PA20edQXvyrKe+b1GBXV9N1qtrGgpOdP917H/v8Mm++58N
	IeB0iAWq41tuyYcHZ34ZbrCeKNXrV7SlopqHTmUk1eH/lDSuvWvMcT7ozIp8/hnj79yntTmJY8I
	Gblt+FaVZWjAUyEghHXb3BzsYPy8cDRTEhqvvYHeuNyl8kaLwlJkIhRPYsuX/Pf0QIeHsJg8PBA
	PK3Cx70qon+Ea1clo4B38+Nw6b9aj1ZKQMkocXYedDpYL22wornEdHin/o9sY9BZJj
X-Received: by 2002:a05:600c:8b53:b0:483:498f:7963 with SMTP id 5b1f17b1804b1-4851989024emr19550785e9.26.1772616636117;
        Wed, 04 Mar 2026 01:30:36 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851884225asm38972555e9.6.2026.03.04.01.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 01:30:35 -0800 (PST)
Date: Wed, 4 Mar 2026 09:30:33 +0000
From: David Laight <david.laight.linux@gmail.com>
To: NeilBrown <neilb@ownmail.net>
Cc: "Jeff Layton" <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org,
 ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
 ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org,
 linux-x25@vger.kernel.org, audit@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 000/110] vfs: change inode->i_ino from unsigned long
 to u64
Message-ID: <20260304092559.554ac9a9@pumpkin>
In-Reply-To: <177260561903.7472.14075475865748618717@noble.neil.brown.name>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	<1787281.1772535332@warthog.procyon.org.uk>
	<1c28e34c7167acf4e20c3e201476504135aa44e8.camel@kernel.org>
	<177260561903.7472.14075475865748618717@noble.neil.brown.name>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E52C34000B
X-Rspamd-Server: rspam08
X-Stat-Signature: znjgzzy43cabzh8dwyu7boct3fhgedg3
X-HE-Tag: 1772616637-728132
X-HE-Meta: U2FsdGVkX1+jUODk1qQx80ygh1lV9b8MYlcYIGIvtsD4UIkBR4jy1SMo3DjuoxyvKdcR/M2tBv1SxAWTSTmsmJQakM9hdciS4Ds1wqOrTTuEkB1UCj8JeCR3wdNF6g7SSlz+RrM8aAzFOMrvCh+kggBxyGzVx4CI0kDQJqhOz4Kmwg5jNSRVkQiEfs+u7guU4MbUnSqJEvQLURJtgqZhzOgerE/TrsgfuI7jS7yqy3POD0yh/qkB8B0dw4OpSWljQIaPU57cEKAqLqY9evqlMGsQO95aySztGgkiKX3Sq7bfWw0U7qDOtL2SC3E6totwRPTO+Op8J5eKfmlm7STVximPcTiEvi+T7vZEGewRsxLR66Gei19cT6PlLf/T/Gh8Y700kwDtG8yMQ825/fWHTO7/9G9kGRNk/LWeW6fQepKVpycNkyNk2gwQbDh6qTULp9E/byBoo1R7etpcWwettcfTekIhRPa73DU5tN55nUauGPkPi+krGrPkvcxynXMxl1acDN3GJZiKFsIWmGXyIiL9Yq0UGgu7Aw4IuaHm1TcKzQbpsPfsyjYs+WpmLyGcPS1bt9SwTvoCKkRFKKMmzeCRH34szer7fPisQBCUaytdcT4gC6F456YYLWur+xHxE5dSDqa9ZSoMCXdHyZE9VjbGhiAn+Gu/ZeaUws9bxHXrYOZNPswOiTSi6cxghHIbip7/dZvLB3g80rNYyyZKM1VLVssIhS7yP8mRki9TetmP+fgbxOBhen2XypcFVEbQmITtuJRpkfr5lGb1tNZYY3EyDZH/hPzE8tEejUZatmZfJ599OHOnKbbkwFl0dBE2jk+erA2sQFScUiYTbq2roogaU+ZywvlhT8DEt7WSCAcUi+QtANVJGzmKZwzVeyEg1sxg9jZOLwXL7e+i66s3zi4juiDQaVz6mxTW7F7R5MCTizo0PP0lYi5l5oGgwN8zB/v9NNNpbPpBLT2fgAO
 t2TgFZpd
 oAIdcmhhkytJJ8s4WNVUyv2VKqWw2EALJWaK41Btw46V40oNq7WtRzis6q3DtdNHbIgjWNJBM+tKiBLdald1mVNMtfcskG288hEGSzk7xAnfDd1NMNFQux34raCuFg+R2Eb+khc9Vajv8V1zyOKXiHGUY2+H4N4xfH4pdLemRgSf0qExGgWrW1L4x0xRrAiGFsrThKa5B+vUWhx32CHijQ9ukktANz5H6PUx2Bgrh+HiIb+14gLHQTyxroWjToOtL0N+lGLjjRV1FpzSuAM4nGCJgk5OvFsCBzd35ObiuLrk5vEtRJzfsMNI79CAb1Ns7GHeRTs9lYwtFgheqAqd1iY3NzAGcrXpLq+sQJacPrKRJ7O5a65SEU67cawjtUGJivAjnlcDV+lH6LJQ7Q0LiLh9CANcC8I6m6xYn8BgnDWgo8ua5avjC8xUgAayH6P9jMK/+1W3SNNS7i0tx7nQISfCSSFCeu9TBIMhnNQ9vxCQUoMhFt/It6jXuohK9Dcdzl+NLhGxVvG5EJYLS943Zs+I57Pzi8XOyiNJpsUmPwYS59pwrgk8BUznvLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 04 Mar 2026 17:26:59 +1100
NeilBrown <neilb@ownmail.net> wrote:

> On Tue, 03 Mar 2026, Jeff Layton wrote:
> > On Tue, 2026-03-03 at 10:55 +0000, David Howells wrote:  
> > > Jeff Layton <jlayton@kernel.org> wrote:
> > >   
> > > > This version splits the change up to be more bisectable. It first adds a
> > > > new kino_t typedef and a new "PRIino" macro to hold the width specifier
> > > > for format strings. The conversion is done, and then everything is
> > > > changed to remove the new macro and typedef.  
> > > 
> > > Why remove the typedef?  It might be better to keep it.
> > >   
> > 
> > Why? After this change, internel kernel inodes will be u64's -- full
> > stop. I don't see what the macro or typedef will buy us at that point.  
> 
> Implicit documentation?
> ktime_t is (now) always s64, but we still keep the typedef;
> 
> It would be cool if we could teach vsprintf to understand some new
> specifier to mean "kinode_t" or "ktime_t" etc.  But that would trigger
> gcc warnings.

A more interesting one would be something that made gcc re-write the
format with the correct 'length modifier' for the parameter.

That would save a lot of effort!

	David

> 
> NeilBrown
> 


