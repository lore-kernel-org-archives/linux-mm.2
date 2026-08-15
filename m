Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65510C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 15:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4066C6B07D4; Sat, 15 Aug 2026 11:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7486B07D5; Sat, 15 Aug 2026 11:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD016B07D6; Sat, 15 Aug 2026 11:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03D586B07D4
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 11:02:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FE66140405
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 15:02:18 +0000 (UTC)
X-FDA: 85103819556.12.C1AD63F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7693180002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 15:02:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZMrSC82y;
	spf=pass (imf30.hostedemail.com: domain of adobriyan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=adobriyan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786806136;
	b=KJJsBZ6A5xJ1ODiF0nXxJF7CN9SBUtth1SL29ojrYYzs+IVHKCm/EIPwmVQ5dnacFHNZ62
	GAJWYJY6ZUX/HXh/H6t5lrkkdWpwe3lCei5b50CShIxfgvK9/UP9fgVOGSMuddMtMhNA9+
	Vqr51o0njGhw5p/mvWy/JeYszRy8+cM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZMrSC82y;
	spf=pass (imf30.hostedemail.com: domain of adobriyan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=adobriyan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786806136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EbqUSbxnlQHcRzjEdjJhxWY8yLtgyWwJdG/LIYZkXjo=;
	b=25P7LUPOfN4VxXJ00c0735gKp52z1dDRrZpUsMWEfmMz7se2cLoMKM52svkqWDlD5pmp5K
	SxY0p3/3K6wvWo9r8hmIJs2v65lMlqAWNEgDTYEn9fxB1Xv+O2B96JwIQFQBzEFok3udXb
	mJ5fYamM34+VYaWKPbv5EluS2hk7Au4=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4957eefd361so15109525e9.1
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786806135; x=1787410935; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EbqUSbxnlQHcRzjEdjJhxWY8yLtgyWwJdG/LIYZkXjo=;
        b=ZMrSC82yp/pzdxtCZ4ruJG7bibFOYTetatrSLk+u1kdbxdVCHhodwxTWpXj+3vhTF7
         fg+CZKjOmVJ1BShb8KOHM/mXGddNgiumxYhmE3f8Tix6Q2eVHSJfhrzRSFvQEY124zMb
         NwK8N7sHCKHtVgzT9wX+5kAldeIv86+xltTfAiz5Sj0tQPioinqZFGCtOFQwI+ZK/xOZ
         3pG50n+N524MEPKeung9uOlzlejpWL9upjrulPFv6zbza3euetptc1+AO07TXA3jwqyE
         saOFhp9puIHY0JywUOapJRRCEaUORq26SWz+emvXkVQLmQ98swyMFJ4wnz3hB8wdMTnj
         F3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786806135; x=1787410935;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EbqUSbxnlQHcRzjEdjJhxWY8yLtgyWwJdG/LIYZkXjo=;
        b=j4xSKxqTt7rMO6YCvXvnBAIw+0zFmX/JlsTDerKf6Gn+k/+dpUevXSv6eyUBHEJPuD
         fUtLl40yJYWTewzgWgX73XEfJN0smBGpiTpE3zqPPnEGgZG2Ur2X2ZmC7WPN1+y2NFQn
         5bSmfBry5vr7fyMw886IJKwNELmqHF9+oIxwQ2LJS7VLfOxvxzI5OttHd/QgN/6RWxs5
         VEDfhOCI9HZYYWy3LsvNeBWy/Z8D15OpCnjqWJ56h88+WaCk8/r/AGEutQHHAvDMXRmU
         sTWKT5kirwvoa3vHUeOymqEDp7qrclC/49yB6hBQ8GzFUQQxGvwlPLgyYeBBw95SkLxU
         Pmyw==
X-Forwarded-Encrypted: i=1; AHgh+RoQcwGVNIBX2+s/mQocfsASwv6c/ScfI0OC3/tExKMXYWZta9K4knubn99tOiHa4DpXsLGVqWJKZQ==@kvack.org
X-Gm-Message-State: AOJu0Yxca7VyqF4iPq45kKN1cjs17aedWnCazHFFrbUBs3wahe3NtgfY
	cLbfMryZco9YKlzWxeEY8i/fQp4+QjovN1getq8z5EoXn+aUnjdc+N8k0SoP
X-Gm-Gg: AR+sD10x+j8C9RMzIMre99pFkLs3ZzNHtG5qUFRHEVmWETlDW0zslBDvVTGWv6TovMS
	9Ij2OuBrH5XVeaCPpEkSfhGkG6U4FIaiO3Mucm+viARtiozv0ivtWdZxRqorcWD4ZRna1y4VD/z
	N0xFzP9sJs0dS459WfwN5sN6d2rk+WANa1WVDRpvTcBmPNIYe1obvvmHa0aFNxhoHt47TiFlqMG
	F7m4uMPh7itc/o+c3/znnrCGVe0BwycuQH4HDd3hPd5SAS8kWP0+o2d306mwBTgYizAFlYzT7Hq
	F1wGuzNnAF5nVvtGoyecC3wGpH1vxmE4z22K2Lj4iV8W6z4erGUhXNdQ9Jq3RIgM2n6ioDXhK5p
	tggQb5mjYpzJ4bPagPu4H5NGpLfIP2KDaYYjYl5EmOr33QnUivdsmZVyl6MfHVrQvC5LdbjP7yn
	e+bOJnc7vfV6KwnXel4ufJWUXk6ApbL+zs73Ssvm00CtGJGGessfKluCFITvUy
X-Received: by 2002:a05:600c:4f56:b0:499:7312:2d5f with SMTP id 5b1f17b1804b1-4998799eb7dmr203923655e9.19.1786806134927;
        Sat, 15 Aug 2026 08:02:14 -0700 (PDT)
Received: from p183 ([178.172.147.121])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998fcc1b9esm105402305e9.2.2026.08.15.08.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 08:02:14 -0700 (PDT)
Date: Sat, 15 Aug 2026 18:06:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: joyetamdk@gmail.com
Cc: kees@kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	shuah@kernel.org
Subject: Re: [PATCH] selftests/exec: add missing SPDX-License-Identifier tag
Message-ID: <b1a53c0f-98ab-4f40-b295-a7839a5a3a8a@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7693180002
X-Stat-Signature: srbfejzmtoocce4n7dqxjacf7ntsfks1
X-HE-Tag: 1786806136-748942
X-HE-Meta: U2FsdGVkX1/V1N78ORMT6qAjuuupGsJrxaIugf11rreEPqmM4vdRXXiMa9F2RlT9Zz2o3DCHK+tKWI/jpCRSimhJJgmViM1Ozs0WiXgF8cVZgEzPMB4kGurVYx+yIghQWVGBckflsJR1YqYyBqMFetYPZrgXIO7QDTGAU7cbgMWJQ1/k7HR8/VU91CSZcmO+ynW7MLMdiWcyqEi/kODdR23RqfPJWmz+yEbMDK0ZlpH7yIkXzKbUVIkYilY+eRSyStNddFnlDUhAN5UM+xkuU3MGJ+USfbXDCzJEsDjZnTh3GjsXcTKempvx3j3kxrZ0fYbX6kIOJThKWRIfHrDp4b3m8nd6bBd2vhWm4OcG7Gjp1GcYYlznesIYUo6E6teVEsHQ10ENuPOEIUBRqQ2RB6zX0wwB4n2gtVnLbd4wy4h5Eb3M0RCIxB5tFqfOIJKPI4EIlaUblHCz9PXlWyrL0KrlMVhKv1HYqGC9trQxj/2qGjK79J/qnvNkZWNFjwF240TOf5r0B/L3fV2o5h4kvIha4FLOVeL8FHTbKb7U9JxCBdt92bnfGoLBCUb/4V+z4Rb6yQdpVGuoqcKTG3awRuNj+MM8+hNbGMHDjhTOgBJ+5zA2TZ9X8wSzG18p7mZnQs1p50Ly/wYJHpg3nhWjAqQVQsDJnbWWReG/v7yIn++9ysEi0HQoknHsAqJzCvXnxSu6Q2LcvtyU8sa34S5gDD/DAsPnZQ7BtkKDtteCBVa7WWcytLDre+fcrtuqEu3zzGNKGkAJeUwoQ6Xi+yrKWDE/H7fb1U/GaT42RQ6mtkWR3ajiWnO2ArX8x4IuxJoAn+tUIrU1TPYpQN5uJOVDxrwW8zL/R6YeKU4oj39zfdWlYUe1rXowXukiHL1SuKRD5WkCwefLsz6UNbocKEUsHdIMvmvtejGHWxekwPaImW83FW6XjpBWJZlRnOLBOWHZC6ITlNtXv4cKWK3qkeI
 IW+jm9p5
 0WE6fRat1+0ktBVdqcuIPfnb5yL7TaodZHXA2mdXpXxxN+yV3aF+XLGfO1y8av+3qJChedcPSySb+lVUePVHESHqJkU3g8ex50H/sU9AI4E+yCuq/LnReCFN72wV39IKHaAJlr68C0ZrMjlte7/nVmKpOroHuzMBeZ3CKDuxylxFlUXTlVnsslDOr8Yyl02M+RjfRVDV8flvBWSARVDpx9+JLx0bLx9carXeTELRpouHTt1xFTrK4UvrlmJahSRNkog26pxDG7wSkHqMupeAcwERB+CSZx7fNQAkhPf7dU5aKPjRe4oKVuJPiEYa8hfogT33UA1C8+CVrXmEvq9YaCnTnb0uQDmyMWxdrKwpKGKII11cfZRmJS5l7sc27p//Swzll+Inf8YpUMfKJbHHKX36TkwPYL1Hdl1FDq05FPEczcs+rRxDlfHFTsX88Ic9PSqEJuKcjuAbBbfmwlwwZh/jQ+kx65Sy7ty59hcN7ClZvvXiUos0mDGHxbNeqWTuaFlMFMb0HjjNaTJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> --- a/tools/testing/selftests/exec/recursion-depth.c
> +++ b/tools/testing/selftests/exec/recursion-depth.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: ISC

The license is OpenBSD, not ISC.
https://cvsweb.openbsd.org/checkout/src/share/misc/license.template,v

