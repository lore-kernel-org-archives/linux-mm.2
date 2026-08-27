Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D752C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860226B0092; Thu, 27 Aug 2026 02:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810DB6B0095; Thu, 27 Aug 2026 02:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E396B0096; Thu, 27 Aug 2026 02:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7066B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:02:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B473540323
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:02:50 +0000 (UTC)
X-FDA: 85146005700.14.EC1DE1A
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id E2F2914000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:02:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jX6soOmr;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787810568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIuQzA83NVqtXzGO6/EiDWZtsLFaTyo/lSlonpMYRbk=;
	b=iBqzyJu33tdfhQMIgaEymOKEFcdzXx0dN2lYqzK5NI1fdx5QWbznlUpotodglPj++JtYgX
	CJ54NIXeDjjl+9UAPqCMzO7boIsT0ioBuEaQCn4djKhrJEiqaQILqGIEHBNcE6lzFsLGX2
	m2bTjQtpxT2HAlZ0pySRUKvg6mornhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787810568;
	b=INsWwdJO8+a1WBzJFK7lHgJUTXlelrZiTwULUpFBw7E1REslYL9MFvIXIwOm82+NA8p+c9
	UPqURDVFcCb0F6ZZ2zB5y7vfctIFht7+fhLMcpkkcepXN4n8bq4zIQoexK5ofDBysheDUy
	PqSzAgLuDw0OnrgMWW+bNIXSiOyXCqk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jX6soOmr;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-854f8068301so323542b3a.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787810568; x=1788415368; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OIuQzA83NVqtXzGO6/EiDWZtsLFaTyo/lSlonpMYRbk=;
        b=jX6soOmrZVDBFEy6S9IWHuRBRlNQMXcUm2Reqxv3FV3rD3f4kPwG9iR8etXaIPl/RO
         PkrtIZxUFvw2CudFvx61NB/zyQVp5lmm5OEoFLN9SfFYxplnQC6bVBkRK0Z/Ige18pQz
         YYwlL8XD6ATF2OvRPbBOIrs2IPDH7AwiHQt0zNWa4FWayzxOWQ3P9SkN2kB4CwTAa8k9
         0SkAenvMz7C4qvJxWJQvOuoid+/CTGKu0CTZQaZluK+kFaf70pM91ALltuzpm8TfQMcP
         YE9NwwYhjOhWqoSOFHaBU6EM9WIFqOX9JRs0VQo6iICGPtGyMfHSCkhCeMf7j6Kl+/Ua
         tXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787810568; x=1788415368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OIuQzA83NVqtXzGO6/EiDWZtsLFaTyo/lSlonpMYRbk=;
        b=oknPl7l/N4p20PH+vdN0P4EwDYZtUjQMpdvhqgAP+MGk60F+qxWE9ul617NSsABFxC
         ZgHn+D7mzp5CMg0KKlXX8IdCvmCQW6bqneoUnbeE/sfaXMaRWuq2GDwXhPx1UAmWfdYM
         J2dbH/YDsxnfxXVDBxUOCb8L3D2J9QoULGzkojFjwrH+gN5YvG5arCIzgdwo15Z3JXY/
         /aB5xRtRpSg/zUtSslGM88ML+RPEiCQQ28zZq340pa9tb1qG+IdTNZDMXAFF1YHU7LvI
         lxELyI1Ab2upY/7xHSARpUZ8G5q/iLdcC6wIM8tcD+Psp/m6b56voJMVyWUjFj/pCEMA
         eySA==
X-Forwarded-Encrypted: i=1; AHgh+Ro/dTyjV1TRdflCDeTIvDXUqSiANoQaN5gabedaH+TzN6Ks/WpLQL8A717Y3q9HFfLlo7M00KDwoQ==@kvack.org
X-Gm-Message-State: AFuF++mFA/AL7kzpCS/xJD2S4qL38+wuzaGdJnRtf70+QNYV/h6rhTmV
	lo1ObDTeXaS1Jol80v2Csi68rLeJEpKOPPVzmLP3GHtgSUgm7YXDRYmo
X-Gm-Gg: AR+sD10auQyOrOB6H/IDFh6a/SwvX/x7hDv8qyA/DRqmXX4ZUaCIpZNa5NRNjBGddB3
	tzP9diDuzinjWK115o1VGN8fR1lC6S0jaTclh91VgJuP/bN9dWlT8oAfUTAJfvbjxdyukibTp6D
	WZJQx0Ru2shLZ8bcsay28B5MO/QYEu+8zW7r2gSU6XhDYpMrryxW9rtSFudzq0EyCRKTTdx6ueI
	B5Q9YH7c/YCeKqBaUGsFtBUW7KzuyhUnGpfBFSMuKPdlsv3n4kzwdr5KqMsXDtj/T4kHW3M3u1Q
	8Ut+BF307VXAyLuOTQ0gaWX7c9e4B2Wrl3j2wU/ch9A09T2OEiCEspEHEhZhl1LUEVAZg5Squl2
	Dlh/Kt56fIxtpLnoYb7Qd+wJXzQpaaenMHjxU2PgkSK5oTeTeEjMa255AV6yZx1VQ5VJcCcVJft
	tdIfq/IzsiepaTNQRrnoxrw20gFerkWjoKEVdOKRo8nY3VAw0dzjHpFQO+tSYu4tAgUPPtcvdNN
	8aj
X-Received: by 2002:a05:6a00:8c5:b0:847:93f3:a4b6 with SMTP id d2e1a72fcca58-85375ca6acbmr21643818b3a.17.1787810566706;
        Wed, 26 Aug 2026 23:02:46 -0700 (PDT)
Received: from celestia ([2402:1980:88cd:27c4:5897:46d2:587d:19e7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85359cd71e2sm1648618b3a.12.2026.08.26.23.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 23:02:46 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Thu, 27 Aug 2026 14:02:55 +0800
Message-ID: <20260827060255.18114-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827055426.16874-1-aethernet65535@gmail.com>
References: <20260827055426.16874-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ffwqmfat9kyg9xmpx1pnk6afr7dcgqws
X-Rspamd-Queue-Id: E2F2914000E
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787810568-121088
X-HE-Meta: U2FsdGVkX19nwOuGAtg1H86Kd8sJEInLp+7XdQcGZznNjTr2r6f0NLUi2MRAvVH4WcNf2eA0UgwGIkucHH9DtugCb0/Ugtmgjv8A4NPPJq9RPx/DwjQt5E9A2LWGClRVP2hy52ubAQl9T4otR8ZACWNrOONHnm5ZIQ0HANSFqH4mJMC0/n9vGs4EN6vMKxLeN5azA3CCX+nYBa0FknV4erWFG3acF3az0MmSQ/j7SnWKUbZTPaCh5SsvWt0XicbVwp3eyi2jK73vJk13JNKfpPxGQRkbPj4rypbT+kR6QpNmuHiqdnLQMg77r/UnDIqFU44KnQLHBIpx1mcQWjbNXM0drHG/LMQ47NIkitPGUMafJz7i/4xFqfEJfG+szm/d+879Q21aH++QmQy1m7feh3zO2UcII7YON4ZWNlelF41ur4GW1haB3cbm04SBdAu4bkr9ga8/vg4j8jZgZINIEonvBglrk/eDorm2OttsJRvL0tkxG2GH5ELUpdGqDP76vsf8YtGAqoz0eylf0QlaNwHrgozHxiCw5pSjVcRwlrH9D4eWF4/zoqKT3Ot489Bn7vjMvEM5y/lpJayjCQZLGywCMNqR7CgxwWu0UT5OdTjJ9RdEpkpD64yX4HKduRDpG2FF5e4ndJwN2C6BOVjcnKksSwP9HqVBnPt3g/kSRbe6sT0XtJ+/E0ZWh3yVtjIkm8xnVqkhJpCoKMLcBPAfe4IKCcV1/VgUC+Pf/pVrb07wZ7jCQEv0Hx6WdhYaKeACcM2JAWuwUiKC31w7x/9f2MpkzFNr/u68iuaPUxfNX9XQ4CBsKcwVm793uDh8cxNwzTSoebL5lgTd33TedJjjkmIu+qlL0aEMIH6S65yOxEpc3Mh8RHJkeRftyWtuO34uVgdJM5c6Y2mTaLk+AtvIuZlcVxUMpHAHXqBdLgMyue+CKgO9KheqmIy2gJ6tJecnjlltFMu/rrWjJXQV/18
 c9O7TJMj
 8ZNaeLZaDxheARQEWfIwQrNJassSbALggx2u0UYQ416vDuoQBks25pS2eCwD24jZAPhmwRxDiCZ/mNLD3D7BGsmhrF8DIIoYlr0YyjN4hxeGBWUyOOvRiUooa6xHDQu/i+h2xC6xJCcJ8PHKUT/Phcu0TVaWUh+7M5Bx2/2cgo/olth0wlIw4xvJhkWAbNhcfEPVkymaT0Ew/5MagbxPJO8tTrzTMtaOZ+J6vtFnEDOG+ISwBPlLQIZOZfOo3SYXbptkgUVEZuCGiPr0Ip8bqsQrWsruNn8a1OlQOcIYsDwdGesf2Ci/dFjavoE28wmy2uNBEm73E4uvUoXQ8g433vRoQlj2JlD2Uvhwt3cEA/LU0B3S4sDbQTVf4d/EzwygN3iqIfaRgtYu77QOvA0KFan3j7oQg/UREyVoj2/seDHtdJvjQoOzK8ISn9UY6Hq80d7qtP5zgokJXHxV/A121y0usx646/nwSf0KV8kwORfUavtOvqehU+TILnsQqXZzncl9Ln3OFwRUUULW+X5Oh72TO5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Apologies for the noise.  I accidentally started a new thread due to
missing --in-reply-to flag in my git send-email command.

Original thread: 20260827004438.82746-1-sj@kernel.org

Best regards,
Rui Yan

