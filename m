Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E3FBF5A8D1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9406B0088; Mon, 20 Apr 2026 22:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1436B0089; Mon, 20 Apr 2026 22:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED876B008A; Mon, 20 Apr 2026 22:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F11866B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:01:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CB838CD80
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:01:58 +0000 (UTC)
X-FDA: 84680912316.14.C068C82
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBAF74000A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:01:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARdUND9z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776736916; a=rsa-sha256;
	cv=none;
	b=pyT/kX6Dzvlp8nSGMkrfwkoFv70G1JM7S6FqLBSoWLVsfij70jPv0ROZ5Ss5Lv/nPEb88C
	La1Je8foBO7cX8gWsXzZrBA7ATemKzy5Vm5nwK6mBLGo6HcaNMowjFucU9ZGjctf88eTza
	wyFgqqrvp9S3GLzf0zQxiUOG8mUt5Y4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARdUND9z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776736916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=HAfyiA5fxqYXT4gYRX9zfWikwnCgQwE5e6No9OGkL8Y=;
	b=jznUiibwVSNSNzGXu7M1RSnjlT7kUQ+yItBaRsHQRQcBkOahywU4je7mdNlZJJGe8ptR7k
	uEad1orAyWQ8+io0mPUY4p6PurNDZkMRFdn5yeaRtNI9eAUV85NPjLQLo9c6ohtwGyKeP+
	pM30uqUgaJKsnP1JoSnHJyxpCckLfdo=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2addb31945aso24230495ad.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776736915; x=1777341715; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HAfyiA5fxqYXT4gYRX9zfWikwnCgQwE5e6No9OGkL8Y=;
        b=ARdUND9z+7wHrFoM10jG8ja4uVMCs+m+nLa3T1egihfLMgXkp8DJ1sFCIYZdh+eydC
         Rvl5ees+r69ii8nrzARI0juxZhTQLWzvqcwxRQFwEBt1nXhfCVUP8ZcIja8BmxFcYUcn
         Bz8wdoaDCRAGn5D5sLE0Zdns5xhFuLSxEFi1KrvANVjWJUmdZtMNPfs08NgkGVjUXApm
         RPAOZnoWLcFfRa7kUcIRBNng3bG/K545T/o7LnOtmoSgFanvY4fPsK35I7+Kni68tPWu
         WbF0T9O691kGt/gT3ytPfP9a5B9Es/hKoe29l/eLNy+lVzEYtGa3Gbnif7K/fZXDEPvE
         sMmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776736915; x=1777341715;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HAfyiA5fxqYXT4gYRX9zfWikwnCgQwE5e6No9OGkL8Y=;
        b=FbVqLhWM9S7VpNHaXqTt9jRnrOn/heaitr9U705cT7ozGLShabhf6kwOeZC+BS8J10
         OSkMWz/FwlJskQkrT8PagqJ8Ydi28RvZB3YUUQ7idMPLEJVlgdRaKH7HI+b5OD/M6zrE
         4WAOORhZvLCuN34sMuuHAoSE1qytyB0udWMdn6xj9bENb/xM3KYRKWm3p2uBhx9at0zK
         MSOSyscsYDYW6lGq0tcRKE8iiN6ezXVx8Y28Nz7nOyduSrRgKhKKY4U798GfwD7AIL1f
         hvLK5ZFBM+XVyQSuktkb12lpn2AyBNIkr/gFFSM9lbRl4v9tOvt5WHof74u9vV6eo6xC
         jDEw==
X-Forwarded-Encrypted: i=1; AFNElJ+JAwxy4C+JLxa+j4pV22cY2vOGW339L2/trGudGHxQA3Ik3gO7XoeO2TJFye6IlsP+/rHh8Lnjdg==@kvack.org
X-Gm-Message-State: AOJu0YzDn4u6tnRhey3iNsI86bZ6P75CQa3JYD6lV50N1KaBuHfUJEWE
	+AaEHMsoQY4CIu6anVbS8Z82AIJPn0YtPokGKKrNvtsqd5ISN4gm739G
X-Gm-Gg: AeBDieuVHqzI7ueFD/jaA00co0/TslI+/RQ2I2EwEGKhlpd34MpMe4MfPPEYW9IMK4U
	qayDfDY3NAlfBD9T/e6KdOc+kBtEZ0/+CMMYcEymzckIDjiEYJlNyxMaMiu/MNNz94ODHRyOe/r
	rMevUDbBQonnZJixwfW2J/w/Du/GsMtyXnH2IC22v+B3FyvFbWjZIc0s+xvzRxFoskqHbbHh/lu
	fWdWtaUsswBkl21leGag9JU5vyD7C24FX68uBUFjvor/UkFWwxYfVQxPCt0y4J+k4uPYpWYpl2B
	HFLSSN2OcAuJnRXu5SuyZfY6wFkddxs2FkGor6Eco9EhPxVD1IQGb6dHgc41oVRWDfIq6b4SuTl
	MTiRYZejjOjhxlFIaDh4Z3WxWPPUND0colXQ0+xhlaEOaqg4TmNqRctSwS8pkPWoJhWmArC6hiC
	lulet3N30q/VoEDbTCHsd8kxfmW9YW0aDU
X-Received: by 2002:a17:903:1988:b0:2b4:5cea:f618 with SMTP id d9443c01a7336-2b5f9e7823fmr164463225ad.3.1776736915460;
        Mon, 20 Apr 2026 19:01:55 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff3b4sm149129515ad.2.2026.04.20.19.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 19:01:54 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: Matthew Wilcox <willy@infradead.org>, abuehaze@amazon.de, alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <aeZ0Kp8dBqjsyWki@casper.infradead.org>
Date: Tue, 21 Apr 2026 06:46:19 +0530
Message-ID: <cxztt8nw.ritesh.list@gmail.com>
References: <ldenszsy.ritesh.list@gmail.com> <20260420163328.22104-1-dipiets@amazon.it> <aeZ0Kp8dBqjsyWki@casper.infradead.org>
X-Rspamd-Queue-Id: CBAF74000A
X-Rspamd-Server: rspam12
X-Stat-Signature: gbfzme3mh8zuj5zexkwdzu3accyy533t
X-Rspam-User: 
X-HE-Tag: 1776736916-141198
X-HE-Meta: U2FsdGVkX1/Q2qFjQ6j3OBL2HMZlOEhfcixr5+5VVHJPk6Bs84xErwrNTVHz+AWBhfC1synr2cVOzie15TLqTa/mfJEWssxLYJU/hNXtEQ/J5/VOoZxqvcFxq2RSKLjszwJRYuWJfdAa9/BEh26JHGeTOo8YwX/yvCa5K/rNpzpmA2i/Gx4+KNfOfb2P/k3G1HR3P9qTnqxopDyLkStkmtdaLVRqbQGjSlHlckQvmvyKYqWOgoQuIqwU3EJ/hi+edsn3KkJmqUBjM/jQ6b1jZ7ROy9C5MVntAT7WbfwPv3OBGqSoSdsp77iCUsuJ/nUfSnGzGt6ykM6KZNa1VlNBNuUvdUDBjAubUvs6waGLkIvZUKpsi4303eVN/AdSxqbS5M13JTJvzdd487XC0qdYoxAWnQhp4bRktHZt+dDLF+BWDd4jp+zPw/12mS5Og57hBSAS3ymenSaB4+UPwtZbNm6J/2gy056vXnqj0zpZnMDXo/sY0RHyv6YD5Oh5K5jkZ1h5JDyKCeMYZ2O+RyocKdjsKCNjwprze14+TXH/DYrEItF2CVBvR8/DHz/1NcylRE8aMAaQqkReck7WEt3ZllF94kQjTlxDb8vcJ9s2Y5r09gJHTQiSjRbF8Q6DPT5GOBXYmHWruWIUvXfSssXQ3vxL5zd1F3mLkrTIK81dYaG5qZSYd8LwJOrG8thCTmupNQCv45x+3beKX2e1UOeLqeMIUJmK0sEwgOnTLL0TmF+4bJFXzrIbDAE+ZZdZ/Ya3uFBwZ4etuN8ja3eZZgljf6w8OrmPbDZtFxY1ivG4T1E5+aV3RsLjQ7ev5Pl2nwoYV84DslRKhuaqYyciZ8FO1n7Tq2HH/69U/zRIJqHa0NTRDnJgJ+GwkNqKeGXygpKlQxIfaqfFgvrPlxez29INn6xbIxmlAF3AmgHHVJYnITWhgzwcB1rZFcSXBxh8AXgoMOXeIVPJA9SaECDFHeL
 B1y8kX9/
 kQFKQJjMHj/vb376AlFyFUuLaqzQNsPTU2lpe3MPt94gInWcly0b7NEfIjBKS/JfNu7x94QyHERBZ8+RtSlj6RNro8Xv5TzhBZHiNoYpBX4SgPCPV8LXsOOrY1Hn0vekgEU/fdkMFw/Vj8Y+H055GJrOunt5JRnAhPc3/lsGtbQfESiLMkpdEyjfaLzu5snxeHU+EbZU8aWUfEGpMLVtZ4adACRqGsJhS8KC5e5QDgGS3eF2GSgjC6+dGglYUSIFAA+vsuXCwl5TbeWlc5T0ViPKGtcZ2dgilEgZUcdzzPSZepYWTrTUWprVMOdFcDt0sCi1NE3ElHYHtF5sHTGposQoamVFQ7UaemPVRIKB5d7FOFAu/Qfe1at5s34lELc+3T39aYk4uAoPGKW24LIJEu9vtU9Gc37WOPU8yTYdXNeK4CCh5RELoQatK2cZ8eBUcNuchqc88N1r8xgpB2wDubNDhHAv5Uc17Ie2rzHfJPJvpI2UTHjzQitcrJtndjEGVPlFOiO7wRpKqXuAI7NVUmHvc9euRuZGqijA4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Mon, Apr 20, 2026 at 04:33:28PM +0000, Salvatore Dipietro wrote:
>> I have submitted a v2 of the patch based on Ritesh's suggestion.
>> https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u
>
> ... but without linking back to this thread, so nobody who was exposed
> to that thread for the first time knows about this one.  That's poor form.

Yup.
Also, given the Maintainers (willy, Christoph, Dave) shown their
dis-interest in taking the patch in it's current form, the right way is
to get back with performance data with both the approaches (which we
were discussing) and first get the consensus from everyone, before
proposing this as a patch :).

Having said that, we do care if a genuine performance issue gets
reported. In that context, I wanted to understand your setup a bit from
memory fragmentation perspective. Are you trying to simulate memory
fragmentation and then benchmarking? Or was this problem hitting when
you run simply run the reproduction steps mentioned in your cover
letter?


BTW - I was following the other thread too where PREEMPT_LAZY problem
was getting discussed. And from what I understood, you mentioned [1]
enabling THP on the system made that problem go away. Also it looks like
enabling THP is the right thing to do for this kind of workload. Does
that also mean enabling THP fixed this problem too? Do you still hit
memory fragmentation and/or similar throughput drop w/o this fix after
you enable THP? It will be good to know those details too please.

[1]: https://lore.kernel.org/all/20260403191942.21410-1-dipiets@amazon.it/T/#md88ca4258766e897e432df85874d197db476c7d1

-ritesh


