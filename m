Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48CB1C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 03:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274746B0095; Sun, 23 Aug 2026 23:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224F66B009B; Sun, 23 Aug 2026 23:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115BA6B009D; Sun, 23 Aug 2026 23:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAA466B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:53:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6EFC1403D2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:53:00 +0000 (UTC)
X-FDA: 85134792120.08.CEE748E
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 19EB2100003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:52:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=frR+91zz;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787543579;
	b=JrZwa+XX5n4msuYxeM5NjrBxYo6TNBPCA25kRlMHUmBMti2J0/+SLEF2uxDYA9wXYpcUbr
	3QsEmf7UhEzF3oV5im09zA8TtjzMD78S2vnn8geczp+jxSc/iqmy51ZqNYGgiibsYKYtcR
	wyD7WPpYDcHb4JldQCK9arR3SyzMhbk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=frR+91zz;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787543579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NkwZvgRmwHRjzupt0N+f3fvk1vj4jZO7Q0jmTyKYe8=;
	b=WJ3TRmcBMXKmXFSyxIzvvOYOEHXYahbpn1YrzoBPJYH7Q0IM4EwQ29BwN2bWenBogW5I8J
	FESnXXkQOnDvC8bSUufTLdt3q+yUOitAk7swEJlakigzanawJCX+Kl+u7Hy+nko+KnmkRw
	EqMXNaaXES7K6SITeBY3FeCArGiBkfs=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so35370586d6.2
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 20:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787543578; x=1788148378; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+NkwZvgRmwHRjzupt0N+f3fvk1vj4jZO7Q0jmTyKYe8=;
        b=frR+91zz7u+JTN4rEAgF70btPoC/onLFsyPoII7nKioQE7T8tWxuEq0YYc7yLGYLMi
         TympuPXcwDkh03Arb3tkKBtCGM1lg64/3kEtKZd/Nih65IXLmXSOZhPpYSaNtj39FcxF
         WkdeX6b7TP/g+4BIdvKs4irOMD75AeZfbxKjWD6NLy8dlMJREyXpqJa9PdauZKehyC8s
         ML2rHM+TAEjAg/rhBUYdTXD4FD6DpBAiOJUg0u9yw6cRdAK8FIwej3fq2ecjwnj3pJHQ
         Ppsf4+menlVrqUpoDqNnmLa9EFgjEBDNPOt3icU8F4/qMQU0LowRMeJ8NOv3e2edo68q
         7xfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787543578; x=1788148378;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+NkwZvgRmwHRjzupt0N+f3fvk1vj4jZO7Q0jmTyKYe8=;
        b=lihI7YeGi3uZ275QFsrF0XiB5D937Nb0Vq2pEgHhJ3Jh3h9Wt833bxVPc/wsF10Ekq
         bc+YiWJGoZo8WArAqkbI/23ammmFoH6svESSWZ3vD5YDgoDOy9sJbsm54mgWTHKbakLs
         MVr427MKPa7eZQiqE73Gl5EvSn0/T36lxDCXxNIH+Wrp4lLAaavQcsOB+YeShkN8Fznb
         CGlkVcu73GyG5ff2DBcPWvQbf1bDBX0RFY/HLjVDwwdi5RxlOIGD9Cx2OI8cZi9ryh0y
         boUQcfUJ5cLdJk6AEX3rbMfb1HWeucwthAwBtmITWQB7qiiO1m59sYjlD3Wz04rjVgyW
         tsRA==
X-Gm-Message-State: AFuF++l0QmbCiXbRn6Idwk+6svNpvZ1/LaEsAHtIkXjVFGIJ6soGqabB
	ztP1q99+Zp5k5Yy+Kdlt9imfXl3mNpcRMEaqHqPyvWTGcUfR1gACglbyJ9GXqRX5vMw=
X-Gm-Gg: AR+sD12pHJsdf1FZmP3av7/E8LsW5h/P+mkNN29upZfST/RBmCPEoY8QrZ+ne58qFWu
	mAW/P/d9OAsUpnIbMngBiN81gmd5JIxtbzF1msGV7bVwwTmIvLGVXnbIPtVr5AeZJH2cMUJJcFQ
	pvEbXIEgFem+cuzryp7avuHRgLjGe4yZWTWn+bZmVVD7nriDenMr0y10lcAwkdQywH/EiMwiGZq
	oSs4jHm6kit3ZcorhESnjrtfkCv3RnBDoAIryiSfb3H+w7HPqU/+EsesEneGHbVz3jC6Rim5CbB
	jJl3L2pO55l2Eb6TVV2EStVedZDWa6bjlVzaVrPrWNDU/07kogC1jQYJF/eNkF/eXBhcoS7inF1
	Xy/jlF7NqKe6qrkN1AEtx3cC7WfLCfn2ltW+4DH4oybXHeDZ5VV3cAM6FgD5c4yO8hdTTYbdvlL
	2KvZHIOyQAQzA+1YkvxhlXAJKQIN6X75MmT/AJfZBeMqZAN/w3zOOrDe8bVq/gFRzPiuRrHc+8F
	/Pzu7BDyHphJCLzlvjGwM2U+UmLpYwL54kMluVg1QS/
X-Received: by 2002:a05:6214:860a:b0:907:d89f:f9ce with SMTP id 6a1803df08f44-90c8f95710cmr155411406d6.12.1787543578189;
        Sun, 23 Aug 2026 20:52:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c9393203asm51021056d6.23.2026.08.23.20.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 20:52:57 -0700 (PDT)
Date: Sun, 23 Aug 2026 23:52:55 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, edumazet@google.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mempolicy: refcount the weighted interleave state
 instead of copying it
Message-ID: <aou9WUf2qU8UewL7@gourry-fedora-PF4VCD3F>
References: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
 <20260824024117.1755899-1-gourry@gourry.net>
 <aou1Gwxk2s8Qjdm9@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aou1Gwxk2s8Qjdm9@casper.infradead.org>
X-Rspamd-Queue-Id: 19EB2100003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: p7dh4wkefyf73dexrzi1cgdsgtuus819
X-HE-Tag: 1787543578-476405
X-HE-Meta: U2FsdGVkX18klGOV3gXnpYoaz3UD7xipbgCqHHG6/zYcan7gZHFdWzJkoSFS22Fc4CpGs/oTglKUhxeK2SLLO1BG5LDYgMv2A5k/kt+FfAZFJAj8Bb0KfikYIrOGN9qn8z1Ykicl+0SGtr4pr/egj8F03V43TKAuvlSax1MituRnvgN3wh36/WLORfI+clS/+e6VPYLM+pt+idLONmpPWuciRWgtrPbYMC6lpF5PYuZHZ7f2TGylPWV8w7Y1guWU5y+KTUtNuzZgpRZWm7cweRRsv+NMALuQr1BOHNXTzt5B27a1oQW9VPFu4DzQ/yNwsaa437VzjuenZOrA78gd/DkENqFHoQOWz5enPB7OLJf+UdxMrcUAkk7lP26pszEuc/VNZNngvQ0xxA17NExySQBcMeSAPBV/wpHSUktmhJYvyvJ81CcbQ0o1tlWo0wH+elV3hwP9laHJrB1A3Sgcv0I8p+6aGjnJRELvySiVqZXBmeG3+QA9vW+31jxfyQpAk94bFkKe3ayD/Co3T4NBYJT4cP5vxQRpgYOOe8Xbt/inN4iz968RDx2G0iPYFmNGQohBdt3VA+Vp+gi6Q9DYTa5G9e5CqgPPj1ylf/roJGMHJzuSeBlCOWKn0T9+wiumKRBgq6SHkjuF3OG1SfrATkka31ZCb4csJd+K4RPPJDdZsj7KOzQefvG1AmyXMxX6tE38vO65XbcbOfQHDUL2RSf7xYAh6+hxwYg8sXr/L/FT94u13GnJ8bs6N4YlcKWeikNC6N4c90vV0JIViwBdjttCKVCP7Ixhmf0qPeU6mWcygJGiuZ6w8/T+OF8Nr8+oQFZaVJ4GJizpk77grdUvY+4UOjMlDEBCfBjeJa/SC0NvZnNQDAHEOJvw8iU+FVocqGoFV/UrMm0B98YiQDdPEAO0iaA5CyBv0z2cThL2Wz11QMF2iA3N8j7BbxKZZ1lpftVlML3ZBmKa+NKu3LC
 WXuQPhX6
 WHMTQRpwdXUY1HRoCnU0Ao5F7XWXRi50QIRjtQJRXdeB5HuPA82Fkgu40gfTY0IHuh8DW3Q0UIXTJwoHZyvk731fOzYNbm41a4Y8MKClnUje3a/azA0e6TD7XJDWH3LzCXJOhQQSnY+Hs9TEEPzYzdHx5CgIG97GdUhm8RQ78Hl0Lz+7/Z/qOHnswC5hSCAGL+nE9Jx2IDz7STRDmIfzW7M3MOS7jid7F4iKH38VxEhjWi9eKbd1AgAtIKim1J+x+z7pr5tK4LBGMciQJzh78VhwfRa7Mb3hRfLSWip7U6WMEh9C+jt0eA8nsQKxCn1N+H98hoKUvEeMlX0sn26L6L85YpFHfUJRWQFO1WtPYbFsFXXv7o6U9GUlU9nFVdcaMB99Xzp8ON1B0HPnPUm6gVgvAf7Dp3X42nzm1mVRwC63BxFuC0vLwsJ6nDXuKdGYf7VXV4j9x7kRDRS8a7CNbHB0k2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 04:06:03AM +0100, Matthew Wilcox wrote:
> On Sun, Aug 23, 2026 at 10:41:17PM -0400, Gregory Price wrote:
> 
> Bit of a shame to take/put a refcount on every memory allocation.  That
> seems like it might hurt (even being on a different cacheline).  Would
> it make more sense to use SRCU for this?

Bulk allocation - from some measurements it's about once per 100-pages
on average.  Looking back at the data I was getting about 41 refs per
4096 pages (16MB chunks).

Have to imagine there's other cache fighting in that stack too. 

I'm less familiar with the rules around SRCU so i shied away from it,
but I will take a look.

~Gregory

