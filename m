Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7506DCE9D7B
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCC36B0005; Tue,  6 Jan 2026 11:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68816B008A; Tue,  6 Jan 2026 11:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6BD26B0092; Tue,  6 Jan 2026 11:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4E166B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:49:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BEFC8BF3B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:49:12 +0000 (UTC)
X-FDA: 84302124144.21.25E349E
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FE6B40005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:49:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=TWfGZecQ
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767718149; a=rsa-sha256;
	cv=none;
	b=x2sblVdg4kvbHnpGvuId6LismXbqIVDvwmVaboIjVgM/V2WNrzegmfowR+9Vwy4m/y+u/o
	XxuHG5e/OKEvYh17PVZKVLWs8f7EVh+Dhdl5lAIahFY1F+fXeopx8UJTtEET+s3UzPnAlB
	jRZ3XlPQ1waEYGuNuL3N0pZzCi1NMM4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=TWfGZecQ;
	dmarc=none;
	spf=none (imf07.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.218.52) smtp.mailfrom=boudewijn@delta-utec.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767718149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/2hOfQwWsFzjkLVUeSCjYmpOw68MXiDDJlSVEBxaXg=;
	b=th27F/iEK6wFYsKi8SFChPZI638rXyK55cFjUJCsOmJnzF2WYPHHcu3kPo131IY0Y72N/5
	Snm/hKZWXCr76v1jxtv2VewnAYh9WkGGmqTAjLcsj52810yYou9B9f9ZbLGSJCdYFiXO55
	VReBTiCXk84S0bGJTWQ9BGb6NM+oHoo=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b727f452fffso204866b.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1767718148; x=1768322948; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/2hOfQwWsFzjkLVUeSCjYmpOw68MXiDDJlSVEBxaXg=;
        b=TWfGZecQsdy/kWkGdwe0H03cHagWMflTPl5LYs+Apd020+01dSfs05/9UgfutI6WZf
         xsYYqGumP8pgf1i/youzw94Y+XarDuSYdsMZ4y6p9S7WWymLccIHkqSik6HkpWeT37i0
         6WW3IRVFWbPrfsJrVoSkLWnDZSZpXjMsQw21ux2NTsvCSXmh0FMXo5CSiF51DWurNxn7
         hZlpFcfgv+IHkPM9VVj34g9DLEc3nSyphPLyHSeF+eDGuLEdD8D9IGb40QGqaiSHPWR/
         uQO0K2IX7Sc/tX1XkoJvZl97LHFZiruINYVFGUvKvJK1oyKX6Hl9v8OsV9BqntjiXZN/
         LxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767718148; x=1768322948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H/2hOfQwWsFzjkLVUeSCjYmpOw68MXiDDJlSVEBxaXg=;
        b=mHTnWSECJ/ZHGywcBcEd5gRhur4Oj0PAYrNBOB8xA/97Hr1XUaRHVlA3qVbfk9nQGA
         bu9B2hW+B5JIi0DzpHieZTI5PdGQEHdp14ugH4YJbXT5uOkkQyGaQ86feMxWkQzlsYcD
         /iCA90PFTukIg9kpZyrxWgAo7TvugrIrahXXbc8605RcoPzUmzW/ELZDLsmeay41FJW+
         ytc7bWZV31VL4kjbFAFYp0tgx6oAWOp+xqDHRRYX85YalzN6b6ERPiVd7XohFX80RxpW
         KZmV212BSorPbd4i1l4tgbABGQ1Y9QFB/aeCJrf+JeOApIjjh8l+sVaZFh/1T6WxJxDc
         zE0g==
X-Forwarded-Encrypted: i=1; AJvYcCW1M8dDb5/aQlIB9fOwO6jxnjYz1SixN9fOk/ZAV72J4u8EStjJ4WV2M8POAvasuMp9WheKx27Amw==@kvack.org
X-Gm-Message-State: AOJu0Ywy9W/uO66+twNuie3fMgguRcbwKJxkbffNPMk44eom2HzQz6UZ
	wJCz5s2VN4oNFelkmJBQo+MRrsdotrBALlfYD95evw7rgmBkufex8lYPUKajRLKTqw==
X-Gm-Gg: AY/fxX6AoRHujEQe2KZoRHr7B9UwvHwuizwauwmcFILQk9PvSplwY98gCZC55zHgiCA
	kZ8kja+53TzM+eUnzzOVA0Wuvnwuzimxt/U29T7MgEGy+hxMzr2jBoZme+j297TaIg0Fbswftg9
	fy1nc6GDCK608SzfyuclMgjb6HfgW9hl5X957JvlD2t0ft+rzUauvJk8CkV37WAmCVupX/783ZH
	lS/5A6bWfCf7iQTVtpN+itGldcHKNH0c9MfWnJjgNDrLvNLj+AUCNlF4CENAuZLvyD1csGs6c4F
	4j4S0Lc47Us4CoL9ls7xrQgcqiIWUQYXaixR3QUcjYYdObMzm6Z8Di5mP5x07Iiqij7+JCttwOe
	0POjZQ/U5+Zd7qt27d/qwzHw8Cwsd1P271iWL05s2Ek+l9EZ2b75mf90K/h2dmBpxA+AYMcgHOB
	n9C1Z804PsxRZXCaAOUdFJ1k148DZPtOMpDQJSw0RF9oZs0PDtjNnTsqD53XisMb6Xu+mUyl0uC
	UMKvqQazct21/L5ciNNsxJt4wsoOQ7icB5gP34I
X-Google-Smtp-Source: AGHT+IEHCglQNO0/MVSOt8fK8+G32v50l3Jpso3LgWYx6GLnM5uCEhibt+qUpj+mRzM+1ok5vuYFIw==
X-Received: by 2002:a17:907:8e96:b0:b80:3ff7:e43d with SMTP id a640c23a62f3a-b84299b2a7amr363926566b.26.1767718147469;
        Tue, 06 Jan 2026 08:49:07 -0800 (PST)
Received: from localhost.localdomain (2001-1c00-3405-d100-fd78-186a-9428-6b97.cable.dynamic.v6.ziggo.nl. [2001:1c00:3405:d100:fd78:186a:9428:6b97])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a233fdfsm272017666b.7.2026.01.06.08.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 08:49:07 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: liam.howlett@oracle.com
Cc: akpm@linux-foundation.org,
	aliceryhl@google.com,
	andrewjballance@gmail.com,
	boudewijn@delta-utec.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org,
	willy@infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Date: Tue,  6 Jan 2026 17:48:44 +0100
Message-ID: <20260106164844.280106-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <vaz4cykqkaa6qksfp6nsnta4rkzqpvaorzdsgy5orapkwx6mil@knfau4tgxmup>
References: <vaz4cykqkaa6qksfp6nsnta4rkzqpvaorzdsgy5orapkwx6mil@knfau4tgxmup>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2FE6B40005
X-Stat-Signature: m1sttbib8tw676d7pp5zowwbrffqdphn
X-HE-Tag: 1767718148-387048
X-HE-Meta: U2FsdGVkX19c+/Fn7zAX+Gh1Vn603YtymeJQafAGUAeUkmCSzMHM81XkykLKW3Lul4fCUcZ9ONvuoNI8NHnLc920ioicplZk49vf/SAur6yXmsgGHT1gW33emIkJT0UMgS6MGQKPswiHWHPOouj3CBQb5dEVuN/pHsj59y3WVj47DAfuG8q/zVphqiy45/N8Pge3PoXU6DZwS/Ajq6iUMcfG6yqvBiZEzLPQL3ai1uyDWpBePhky/KzUagcZjCQ9Ixqu611lQc2uTFbcooC4d/o0PqvsYV17UsA61vk7mB43BFjJDf+IOE7W+pVbwudSm3VI5ZcC/bpyQLgSLxRXxILxDphQ/09M3nFZYyFk7dvJ4qslvFpnv1yhSD4I7080OgnWpLvn1xcuDYDh4vUhWOhBdRSyS+yaL+gOGJrENBUNXOiOP+4Waw4gmK+K1qwQeqX0xVPU/lpyNJ3JEFxZ5ApST0wLh9LTSwCh/m02+z7v/c1eK5tVTxQoludGu3afzKPGwfE8dQIUriqvQ4wlhMBQbpneWDe7lz35F4N6LxFIgiUk1dvxD+ypp9JWy/Ku5d+7X9HEXMxN5R/RXHM9tPWMBTFHIo/Iav4PMk0gogk6yBfP8ucx1pOcbwDZ8LDoiy+zNBP0KhwPuoij9tfHHx69J1Yqarq6K0/y9nteFk2UH0k05KrAa2Tfi1LkZIRMt/cHjxxo+GLaadiCKjTUcBsFZzfzFwIo2dMtJB70VvMf99fAlmSJe9K9IoBgvGLqZ7kGpOFiIxPpjvM+yhxKSOKCF/cHZ9S3be1JbOP+YoBJJhRUpfW5MBb1L8jVa605KCeCyvwEQRbs3SsWbBoE/vpWHsQgd/Xj2AFb1+eq658BaBKUBiycoCoRLLxZyTXhjW5Bqev9RXyYFcUgFAfzxXmdfeejK9W/frL+2yZ+Z6C6jQeNCi6uKLmAQ5V7sOFSMv889oJBCp7uMduqTWn
 3WuFWRrs
 K+dPfroFx/3585CsdzVTuL+ygbLONJL6nAAm7P2bW9+oGvpU1pBnzqgMeDi0QPpKoRp5Rt+q45giTp7fujyU1d+au9usI/jP90fPBniuQNxH7FPeihXxXSabN6MWkSPtfQOsnqHhuxmuoTyf8Xu3c3o/XmIFw0UeiCs8oV07iS3Q9yDa/5TuxTDpOVGmoWynz6qNVBeKW4LwuiYffczVODQm1ohzA2lG2bgznuene9tOYpuMvoytKBTuQGWG5KOtsmMP4OhLvjwCISydq+7u6pUSquDmSqUaDSUL2Si+//Nvc5MBZNLTb+cW1hOJDAAwyBPXRA2dlGsbrBhuSOueakb3Iu7zdckHuIa3lyEgzr2M4IjyVxryS2DU6uZEEj+vLU8+Pw0LKMQYhxFTgNcMqgqTRdoVR64GEOPVDOG3hjH/vbk6tobO4xpOLgQRO7GJW2fx3VLGKArsIe++yEfv6YZT0UA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.010238, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Surely this should just be a lockdep assertion that the appropriate
> > > locks are held?
> > >
> > Just to confirm: do you want me to remove the original runtime check entirely
> > and replace it with a lockdep_assert(), or do you want both?
> > If it's only the assertion,

> Please do not include any runtime checks in this change - Just the
> lockdep_assert().

> > that would mean that production builds won't enforce the check, right?
> >
> > For v2, should I add a Fixes: line and Cc: stable,
> > or should i leave it out?

> This does not need to be backported and does not fix anything.  It's an
> attempt to protect the user from shooting their own foot off by using
> the interface incorrectly.

> The fact that no one in the tree uses it incorrectly means that any
> backport would be for the benefit of out-of-tree drivers, which we do
> not support.

Thanks for the help and clarification! I will send v2 with just the assertion,
as suggested.

Thanks,
Boudewijn

