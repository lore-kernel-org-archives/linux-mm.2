Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A17C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 05:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0606B008C; Fri, 25 Sep 2026 01:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98556B0092; Fri, 25 Sep 2026 01:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE2D6B0093; Fri, 25 Sep 2026 01:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0856B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:32:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33F68160560
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:32:22 +0000 (UTC)
X-FDA: 85251164124.17.0E8D6ED
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 77CFC40005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:32:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=MyLJQi7v;
	spf=pass (imf27.hostedemail.com: domain of ayushr@modal.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=ayushr@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790314340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ehv35jM2xSxwjjV6xaS7dv57/W9hK0TedPz2NPct384=;
	b=w/Mh5ai+laED7xxKlKP9jpUxV9HVOXV5/CtIQVyMRRn946mNGkXQl+TsbeBAguccpE4px0
	Vx4jfWfPu1Y1HF3vt4UkqV3g+LC686kk4gWWJj+5SXFPSK4iOroXN5ZxXIFMguDYGfI+Lm
	pptzFXO4ye51cgjlLTMW9FTSDrMFQlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790314340;
	b=mmlmLI+vPa2PGUpO0RFUI70giVWK+sWqyB8/hj9sIQmyQ2HVkZJZ40qitS57VqmE2e+DDN
	s8k0fbv2B9Oits3haCNigYQL29h9V6LUtTDwMknHacMnYqTvlvBwIheSKm29ZoaQVTGiGc
	5TH2h0S5gyOfts2PRbV47kizn4tx7z8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=MyLJQi7v;
	spf=pass (imf27.hostedemail.com: domain of ayushr@modal.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=ayushr@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-3a02902dce2so336391a91.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1790314339; x=1790919139; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ehv35jM2xSxwjjV6xaS7dv57/W9hK0TedPz2NPct384=;
        b=MyLJQi7vmXMqPeOCugw+HiitePyBs47AIDUsKA0hFwcYeqo5cf+oz2nX6OBnscg7a2
         5JTfr0lCJLSezZwm14KYY5S+Tkkh9Atkz/oA4R9rI6UlEIaKN29PpcTaw0Uhk2fEfjJP
         GiUKloYVJGdNYaDwXEM82WxcP7mnLDIrb5pyTJU5ZoPAln3Ks2oOXCVq0wRKMlFo6nBC
         rd2qrN58Mm6Th9sX5TMp3HOrLyFtjfsYTcib7e6X3cCqdllBcCSPgI0IAfS27JeWy8kI
         j/27rwu/0euoDJfw69/QxnP5xKxOU5meRqFcUeWDmd1UETzw+CCpGaal4puJjV4ucT45
         cpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790314339; x=1790919139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ehv35jM2xSxwjjV6xaS7dv57/W9hK0TedPz2NPct384=;
        b=ANrzhXEyHkRLwn75n3tK6nagXpes0THCtydiEfiqh4HCqE602z0AEloHXTGzpFmdQf
         CUnulqL8x7B18YlkPN2U+FDxTDcc0nDH9zBvpxPJZ2ejRxBANOtA2YIX9MZI7VAJATJ4
         fY7Y2xEuZ/ETy4Y36vdLyWrp7SbmFB2GzJyFk99Wki7ByFSTFgYlQ/pOsuWlyGvirI4n
         ohWSXlOEsrrnN86lLD2DK5sk6QxiFf0rrNtcFCoAoV7OAqyQ4QWDJNTDmdBf4IctOnO9
         foU47x/cj9mkLVZgBUlFTC5A+Nn+gQtMgXNUjKx0ZTgKAjkgI0U0Y4W9ofNFl+gXKbka
         ZRyQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5tpmFNgy6MKp7FXLCB/wqhgMMhb+n4O/Jd6qHkZzyVbnjk7C0BL14iK22gNQY64QFS/bminUv3A==@kvack.org
X-Gm-Message-State: AFuF++nRx/fVTqefNH1NcRh92yBw6eCyhvAYG653XjE/VCMvbRQcmN0Z
	DQoLp0+CgAn3GevFwWgHHBGawKp5M60fD7J/9iS3LvfW2F0Y9ARewemQ9aiokN+Lucw=
X-Gm-Gg: AYBFou1xgT7OExKMqwyj5vk7hjwK7b+hBRkSzd1yKC4YvbOIW2jwDaXIMF6+wHBoK4X
	vlxPhEx17unnH8gnOWh5DkT6St1o9vNr9BHuOjbJKBr8jt6CKf7uu0kD4JODIgliAgdMp0xC6sK
	2KEPF0qfJXAweY+0v/wlayXBVBhJcqgGvk5fVmQIAm61tifZHckkoYrwOblkIAn5ASzah9rEzw3
	hNs/X5iG+Nc2bz9Vw3QRP7Ru81P5IjF+yECD91jpiDN5k9KXuEU9luMNL85E7ucZNWwN57hnFle
	cQDBCXQuGC/Dov5K6BX01+iHOEstDNdNYgLKy6LVrh1EVbpAnGbDHlienhGPuTQNsMj6ZvyIRwQ
	+VZDiV7LrMkxUNtT+mov3pbmZQkdPTzy5/8mwa8LRZpuN+J2ZiaPMx7/J2PigzkTt/0fBcMM6fI
	VS3y7qUX3rnWAfFVrXwvjPdohAcp4wZc2njV8orKIh/0T3pg5Dr5MNrlOWiIQO48Y2Mrv1GS3dV
	taou5rcagPNG0vekh7fJ0LKvxnfeQYzLU23gyBkE0oJYRMyltsa3/EnW1NX5U8h11ASRHUMaMTG
	r5886gfotIajfNbPMXNDyI278g39DTD06loETeX0ClUMPtYa
X-Received: by 2002:a17:90b:2fc4:b0:39e:6c6a:4b64 with SMTP id 98e67ed59e1d1-3a098dfb087mr4009593a91.46.1790314339197;
        Thu, 24 Sep 2026 22:32:19 -0700 (PDT)
Received: from devbox-ayushr-01ed.tail5292b.ts.net (ec2-44-242-192-44.us-west-2.compute.amazonaws.com. [44.242.192.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b4f5b1aasm936305a91.1.2026.09.24.22.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 22:32:18 -0700 (PDT)
From: Ayush Ranjan <ayushr@modal.com>
To: Jan Kara <jack@suse.cz>
Cc: Ayush Ranjan <ayushr@modal.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts page cache / rss counters
Date: Fri, 25 Sep 2026 05:32:10 +0000
Message-ID: <20260925053211.2036445-1-ayushr@modal.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <uf7lys6izqrxjsp3tstqxmdok5yy3w52d3bnpkfzyjm7uiyqzr@ickbg3ocvcji>
References: <20260924061708.1645968-1-ayushr@modal.com> <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net> <uf7lys6izqrxjsp3tstqxmdok5yy3w52d3bnpkfzyjm7uiyqzr@ickbg3ocvcji>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 77CFC40005
X-Stat-Signature: 43ok683dn9kj3s8e1kzyf76no8stst38
X-HE-Tag: 1790314340-907958
X-HE-Meta: U2FsdGVkX1+BEmbChe0e6sueaelvkRhnpX6JI8vkDwtqh6dqqvO9n8koL6iFv32vgDbwwLx1jlOPiYtvnBeY/H7n1E2HShAZB/w1hPaEUeO3Ud/GhbPaC/rWe4t5dhJwVqi1FQgbL/a4gh+x623W8/FfhSI56DJFjwI/Fh9rGViWoajkvAFXvHLkuWclYxmRfMEufkZB/umJA3a63JlYOJ5j+JoN5NXv4Qz9i1OZ5HGjGU2ryDeS6Buw59BemljicCSJERL1xC/YIl23X2jSvLqalIhj5b9+8AoRWSgbvplo4qG24C28CUU0nIRj5B68tS4MAwO1L53YGD3tRI0/GadtxgCPsGmY8AlLOcuBzuOj0QJ/jDLL8+Arz/CpDkg9YqAOvEvfD4V6ddwmBb75t3bk3uOb1hkipAf8mget9qWGJ2aS9jNDPa64QnAZu5ROthiO8YufQ+DTD2Yyv4iCKbNHQe3GyZPNzui9qJ772XZFPpB4IaWJo7zZe7af2u9X1F7TnKF5bCoPwAn454XCKRsl9go3xFhZomkPdInSgVCg06P5czoBJLemqNK+bOujg1Zz8zgeuVwXm6eqY8NgIfTM3DcuoX/5wghprWhclUbLD/186tSqWHN6JG5fjIKLtnsfPtxeThim4BXtgBbpkhjzqmbpVh6mKhs7BNAvXRkhlt1aDm2pkFHT7p6PziBY3G7DvqpZEDFieHWAHPGcpISU2N5Id5rWRQ15HitAA3y2xTySuf/q/v7pJQudXH0t1/Z+K3RQBcwSdZDiCdt7cNHuQKmZ3zLP4mtUJMu3KC0NG3iGNtAlYcm1KboiVXvo9xBhThZVRcpGTdlNdw9rrGi6S3e5MOoRrwxkDbhTcaG2t2ZgjZAQWdCwUy2MTMKKfPC+39agtPC/Ck7/S1Iwo2lTFB0kybegB9nVMqwum6uPEqdVEPbSUGNPtqH7e+qPm9cKZSE2Mgc/6Mx31VT
 u11O1HDd
 AzmptalB0elLlmh2VjOa1RKuaH82Z+cUXlSUO/Ssgf9lyl6naUuMy86VyRNoSLj7a7pYGpGgpYe0/fTlkIf7o6fpNx2TLJWneYZrigZkoz5gFDPikD6+xybydJIILmcUKD+49WXTLvhLb1nWx6GT7SnZ4daa91CMWF4GubMGaYIvnnKD8pauSLku+DkWz/mg9hsFFr+RIplgFLRmz6zLbHA+29S6Qp/csROD9jQKO1JVNyoRPlzTxMYJR1RcmClq81YU92Ld5Cfws1bCCL4yiM/11O7Fm/aPJS11OBEfhypsiOb1PmY2Qqm8JkQsi7Bb69SOnjqDNobjCBhE9ee4Hy1zpkuyz+bDlF0dDWEtVQzA+SOsIlBBByiolsWzmw4xWWyarvluPpfwetxC1mceQt6vMTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:15 +0000, Jan Kara wrote:
> Can this be perhaps somehow related to the fixes in partial large folio
> truncation Zhang Yi is working on, possibly even the tmpfs bug in handling
> of folio split I've found [1]? It seems large folios are used here so that
> matches, I just don't immediately see how those bugs would lead to the
> errors reported here...

That would fit what I see, for what it's worth:

  - the rss-counter imbalance from the reproducer is always exactly
    one PMD-order folio (+/-512), which looks more like large-folio
    split/accounting going wrong than lost or extra PTEs;

  - the reproducer's punching thread deliberately mixes unaligned
    sub-PMD ranges, so partial truncation of large folios is exercised
    constantly, and the production "still mapped when deleted" splat
    is reported from truncate_inode_partial_folio() (full stack in my
    reply to Pedro).

Thanks,
Ayush

