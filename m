Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F254606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UOKjNxXm
Received: by kanga.kvack.org (Postfix)
	id 849FA6B05B8; Mon, 16 Nov 2026 18:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783F56B05B9; Mon, 16 Nov 2026 18:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF336B05BA; Mon, 16 Nov 2026 18:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 385846B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:06:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C89C31C30DA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:58 +0000 (UTC)
X-FDA: 85442519316.05.34A3D1D
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id F07B240009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UOKjNxXm;
	spf=pass (imf12.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870417;
	b=IxVS4K4Kxsduvu3Sy+kv/GqdkGigIe6HagWO7AJse/H2KyGq1wdGEdCu6lUsQuvhbywHmu
	ilpEgPfpisaTWrWu/fNu8yT+soYTBqz6xsBctE5Hb9d3h/cNw/EGlvLnJeO30pzt0g/iDj
	O1kjj5jdArnyqjkDoWgkelxJjdGxEPQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVQdcEYHvCyjprjE26wtkXBdOfSzxTsxBRAupk9G74A=;
	b=006B/xyxeZONL+zPz62Y90MbGEDCB5+yxyqvLGP6TS7Lo7MCBStoCw9fYnY3FRm/hbypAr
	ww2Yhox9/VbAsm1Dyj0/m6SWm6f5MR4rynpmEzlLBat0x0STIM5nXR6/s1yWssIG+7uNfQ
	/qQWp6XM8ohma5gBgft+q8KTQT2WOqo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UOKjNxXm;
	spf=pass (imf12.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b77e464208so477245b3a.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870415; x=1795475215; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zVQdcEYHvCyjprjE26wtkXBdOfSzxTsxBRAupk9G74A=;
        b=UOKjNxXmvZZXbeGzS/5/k6Ej5V+4NTOq1OvqY79F33XKCvt3cFvtYGsvTx8e5TJlHt
         Mxq69BT/ZMbUC9qbXtAt+5AOIHSEHqopWchgkZh7QlR6Cwvyj5pZmjkOBNlkg5uJgXI6
         jPNE462QG5EKIEPlLWPqQuPKDzjIIN0jKOeTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870415; x=1795475215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zVQdcEYHvCyjprjE26wtkXBdOfSzxTsxBRAupk9G74A=;
        b=QyFHUm+dT6M5EseC0lzkXca2YYrvpTUDgb65NSnDmqNxpocp5huSEAsby9T6jbkUnc
         /sCe/ipMAtnbRLX3/rlq8EVKk52RffEwSgYcMXymfLMdHvwFRc+jUuDBtWfeJrsHpMvj
         SH3mU5XFqq9Gs6a6vwPjUDtTQVN4U8lW1QPDH3hM28lGBgJR0Df6JDkC5alcqhsW+fdy
         64Iz7BGZQLzTyJ5mv3nW8Gaua6ZAbH9SDsrfdvd3+Gv7YLK1P4Es8ePQw29zeQYXDnSS
         W/KqRb/E4MeG5ZqEs8YNY5MCQn9ik5RnUkVM4j+dBBem+F3rJmK5oXyaMtEhg2mNvmc5
         EIxw==
X-Forwarded-Encrypted: i=1; AL+hErHQEBik3JU7ayc3Mer5UCMbYuwlOv0b9/8sLewgx+1v/bRib50ey92Ad+Y8+8DEnOTfe/KdkIwSwQ==@kvack.org
X-Gm-Message-State: APuU4Z/kOIXuJQm+ekC2tCjoCep9hUEzFfRG8mBYQNWVaxHXgmnlbT8z
	Odgv/DGBXci6Z/3EcRnMH8wKgfg4iGq8KM8AjSxhvNEqXBhL4XMgtE8Ni5a1uSfE+Q==
X-Gm-Gg: AYBFou3M+76Kw82WkCdlF1qGVPKoyGv/1FAc8ChNVEULzuW79KOipTtYsJl23RVQrRI
	ztsWk9EQ+6lHygksjU/YvuA3MAuPcCXecl7/gnLo+I3w7ude/FRbda4Ha5pUu66SiBQYpO1dWG1
	q2IbzmMRbNbMMsiP9iB12b7dyLC0wicpd0H/J43hyC5rEEnOuFxPbmFR1ZfzBfUsxTKvKRUX6jd
	TA2Uu7YbRGH+nVlvJTThRRolcEC5e64AHR1JuP7pg7bdZ5uJKn8RJXEGnhqijXWM+z806JT2sHC
	BcPiYnRZjxXDX7Z0Rm3OiNbc31ZSZ7MKkQ6F8z5WRQmrd0Y89NvBYEqsLs9jk4BT2ttrMINZn3D
	1yzCVX2zUM60mRZzqcjUz7vkhBFOfAEtP3cp0k/uGo8kzAqHRH6oqzo20aQdYmzxY1srEj54ADp
	zkf+Cbo9IhkVheAOZvCR/jsY54t4jWX78eJFfu0HTHPWFKx5+L0NB3+6pd9Ws3jxWfTlzUzEa7P
	hjhMITLm4Tv7suiyY2zcaWoxaYs6Dd513DTx/GghfG1G8X13tPznUrIszWwWbjW5G+lwrZziwLX
	I9TrC3M7tHTghi487ev1T7au+aHag0mBEjWaZT3kgec5idvhSxneIs7shNJW63GsZx+qjQg=
X-Received: by 2002:a05:6a20:3247:b0:3ed:b9c5:df15 with SMTP id adf61e73a8af0-3f7a6aa5facmr12150421637.1.1794870415604;
        Mon, 16 Nov 2026 15:06:55 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8bed1a6dbbdsm4310921b3a.24.2026.11.16.15.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:55 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 4/7] net/rds: use GFP_HIGHUSER_KASAN for message pages
Date: Mon, 16 Nov 2026 15:06:24 -0800
Message-ID: <20261116230627.3537051-5-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F07B240009
X-Rspam-User:
X-Stat-Signature: coykrwcrisuu84qmqb6i8iespiyjo1hw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794870416-991004
X-HE-Meta: U2FsdGVkX18kXVC9sfMrOVZzwZcRl1sT+tT7VdMD4Y4H/7fSstezsGMruDDQGFdCfnYXvpcLAGPrIu8VnRyWmJbzezMysSl0ysKfMHweOxjlVqBVOWnoqJHej/d2FQtXSXRPqWZAfUgWJs5a6LsZ43JljOOB2WXTiUwrbd/hdMH/8lrlOnsyBYr907cRYkaIPhePFYFDxGjwXc/z9kMnwXj2H6cCzDPuNZLwU0Q6ThqYBPw7zbd5SZNDmgAOc2MyD5napa9oSUGinfOefyaIrwV/qDrlNwIgGNIYX46JH0F9xNrWnEalf/5kgM/VMMGlMMm+SEUhOh+l+JbWwgYM69cPOH8UJY1hkdaY0by7R3DvMJlrLpVjQtVLHG/9U6kVWeqcWZMfNDv5o7d7OdEGv2bVTrB2cX2OG1F4OSPWT4/8K2rbQLIx/XcwZ9Wi1FdF6gmQCRgqE1PDL6R8u/Zm3w27f2I4ti0X+Ch2N4T2kMXwrkrrGry72TnvZUp6rbReV9RMUQfznF7gVGRmIo7dkbH4JE7WypyrKD3sNDW3nBYeHhnp6hQh2ob2EA5UkopbumVNIANjlhFqCRTZF1T3uTzjXSyU6rr/pBqPJL400gtjPil8KT0RHERaGF2Ncf3CpzUVuL0m/LvyGsDt2HoMBrR9avP3euRct2cNZ+dTHhKl5At9n7fH8gHq/THzlvfywnx5B4Qk3VS6cPD+PysAb4AfraO0JBH31yREDY8v3tCpi4fWEuCWXHgXQR2VK1efy8zqVmJ6F5rCrgxl8hCUifojCdWBUlNZ5p7SZnJJ9kgRT36tq9MsGSqhzwUx3kg5abXs/thwb6HcDtsxKrUALLHUE3XbRBJsSJWMKOw/rbawcMudym0nqzX6GChJMdoOThqUn39DxHvXZQtp65b4yBK5r4Eb1csvyx9Tun7cJ58moyWm0RbSFRkUTLnIY/MNLtESsE6Kjde1IO2FEnD
 02wvUcQ0
 WwaIKVvGnwAVpT4d0wN0DNRH7BG3h4fi94MB9F8XTIWI1QUqm735Fcy6QR/vhoxFK+rclhiuV5QANE5lXQXYvu/78SS52rB8payZgiLDLzjG60WRU7OxVkO+xHJcgORFamOQJXdUYkbUQn9kc7hMOBViS1VuO8uKG2A4R/OYrCtrwhrgHwEjMfypckh9BMKyb/aqyU+IqUyx8Lx6GGymxgp9ACWEkU13F9kWM2q5oZuMDEdbwX441r7XyBAmr8Ph90ayUzfiUKPVrAmSZhhMo+D08sPP8aY0wL9gCPyCtXXUZRNGTxfv/gxFfuslHAfoqSmNEAd0zfG3jevWv9KG5TRG/AjZVgQk9Za/SSblvSNJM2LTWQIqhj00Fwgc6/6lIzXpo7mPStnAwBTdVgCKDASW9x2VdGNgDHyMW+fBK7oP0bLhLwWObf9bip2WqYOX0E9w6QQ3NGakFhmDQUM7PnTfSfbovSWr9V/8wPSCeaIh/ERMwAJuQkDqQRAgF9XSXgqYiBJJkBusX7KqcV5Q1V8Mxyag3jm0T5m/DSqz120LKqJzgA4rnxsN5gBbPeQxXcUTfvy5fyk+dw/r6Q6wlYhwBzIs6WX0RePzUpD5gngZ44fKwEWv96gH4bTpYCFDiL7C5tTPHNHZUvOz8UMmKtbrKocEH3I1jqhPe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

RDS allocates the pages that carry message payload with GFP_HIGHUSER:
the receive fragments in rds_ib_recv_refill_one() and the send payload
in rds_message_copy_from_user(). The kernel fills and drains them
through copy_page_from_iter(), copy_page_to_iter() and kmap_atomic(),
and they are not mapped into userspace.

Allocate them with GFP_HIGHUSER_KASAN, so that they keep their KASAN
tagging when GFP_HIGHUSER starts to skip it later in this series.

No functional change: GFP_HIGHUSER_KASAN has the same value as
GFP_HIGHUSER at this point. Build tested only.

Assisted-by: LLM
Cc: Allison Henderson <achender@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 net/rds/ib_recv.c | 2 +-
 net/rds/message.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index aa50b85b0f99..907bf2977583 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -316,7 +316,7 @@ static int rds_ib_recv_refill_one(struct rds_connection *conn,
 
 	if (gfp & __GFP_DIRECT_RECLAIM) {
 		slab_mask = GFP_KERNEL;
-		page_mask = GFP_HIGHUSER;
+		page_mask = GFP_HIGHUSER_KASAN;
 	}
 
 	if (!ic->i_cache_incs.ready)
diff --git a/net/rds/message.c b/net/rds/message.c
index 47d5e9ab9b10..80171ae2f40e 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -515,7 +515,7 @@ int rds_message_copy_from_user(struct rds_message *rm, struct iov_iter *from,
 	while (iov_iter_count(from)) {
 		if (!sg_page(sg)) {
 			ret = rds_page_remainder_alloc(sg, iov_iter_count(from),
-						       GFP_HIGHUSER);
+						       GFP_HIGHUSER_KASAN);
 			if (ret)
 				return ret;
 			rm->data.op_nents++;
-- 
2.56.0.611.g1030f0b940-goog


