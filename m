Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC18060A2605
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=nthMw7C8
Received: by kanga.kvack.org (Postfix)
	id 910546B05B6; Mon, 16 Nov 2026 18:06:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895466B05B7; Mon, 16 Nov 2026 18:06:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E846B05B8; Mon, 16 Nov 2026 18:06:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 467866B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:06:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97E284022C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:53 +0000 (UTC)
X-FDA: 85442519106.18.66D37D8
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA18416000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=nthMw7C8;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04YMYN0F09iXpQbtyDGXKPSGIzq5fh/Gsn7Dty8ViAw=;
	b=73Tj+8tIecP1CXahjJHfunQiLC514T453uPh8lbinytr0J3U5gafwB2IyCrzELsJ5UlOEA
	OTL2h2KK6IhTciuJiGSyDbsXNNmi6s2lyZmqoPgPaTvTgWNfnDPGMXanSiw27hBNrpW6Ux
	9ZRV3wLLQZjoCM6Rxqo+W0vBuNqkUrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870411;
	b=Ar+Hr0qV3OXju/KkxDkWN4Jw2Sxn8kJ0+3deSkORnCH3c2RaK3FEKbLFbs54vmdWWqGRNP
	3RjFp6tlBXIoYk++aQ7RK+EI8+PueDH0JWdbNzP1PLJ9Lu4ZEVSCE5MqzgluJfiGhwRLj5
	FSOjn6nuXqzny1qt+/rRhMX1UP0dhPM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=nthMw7C8;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3acb1224533so613009a91.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870410; x=1795475210; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=04YMYN0F09iXpQbtyDGXKPSGIzq5fh/Gsn7Dty8ViAw=;
        b=nthMw7C8KbziBZURaQdHiYNVcg2KJOitO+3pC+DD6PVzD1EpSQ9KcUceYG7XOWCS/9
         FHqQ8p57o/COZCo/p2WCAY0XfFzrdWUczYjz+oNlC9/DkrwDRc6Az43F/Uv05XYp7Etx
         L/v3Tqde5CbWwZGG+WEJvwoPCW4XPaNkH9ci4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870410; x=1795475210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=04YMYN0F09iXpQbtyDGXKPSGIzq5fh/Gsn7Dty8ViAw=;
        b=LF9l6xy+jIMCjDqoon3+VpVYIgzUqKF0CP6TqnuIvf2I7CVC+StiUIJI60V3xJgu+Y
         k7ElHGu8i9AxB/K3I3KnNU6m3QyQyxHz8BbiRvJVNL6p9FJlSpMxAslFV8kZDCkVZt/N
         U3eT+Q2Q0wjcrO28Tp7lFut9LPnN1EUvp8bfgyo/rjtlwGmWlIlmA3kPG/npkOfRKLyE
         4FlWIh0qmPhMsN7vYSfeKG93EawDBGqxgVQzznNy/7Aof/JR1Zpgs02bK6a9KrjvkdvC
         966+JU5sMES4GJcvOIBUVdIR6xHPXDMCUnNjGx5NI7UVhiB1X4y8KMUa+idF++FjzZCF
         c3Kw==
X-Forwarded-Encrypted: i=1; AL+hErEcHwqebxP1yirWya63QZIJU/vB+gIc7l1h9jyKxZQZnLbS697P89yYnr4AYnqlvVXYCbmjdrOiYg==@kvack.org
X-Gm-Message-State: APuU4Z9STcUIkvRdHmGEXC6R3FuLvDX3VVsqmGx7rZEYBdOS15Oqjfhi
	2Oq9Fh+pxOJkBpUWmx2inq8viivznFvltzyYB0c+VNeoKgqHNRbPx+ykzU4NCR2fMQ==
X-Gm-Gg: AZFdTZfs0A90rJ5Bkhb/Fkx9Zmrf3+ToedfwFCu/eIF39xnfODU0qhzkWqOGXmSBAum
	XZLjTELuG1uWO8fLPRJocakx+nRkWYDqV+0EFal+gRozGqTDxjWxskgaOhVNAC2w4+XLEobaIRj
	khVkciF2AAma0fjRkQwqcTWyzy5jNpTLzA3Gi4wtJ3ESR4NuA5wYjKc4j6g03vLdi0fjQFCn2TV
	WI4S++bCGkq9uSccaNk1hVtCz0FBXynJYtBKYLkANV1DJzRLh8PNVUOy4Z17xbge4Z48I0i3LMn
	fsuB7MbwVJHgiqXPPrUXvpUq+8cnMWhWKiul0RfAUcqJbd9HrKg0snz/LSZHfYh1Rl66yLmvQUp
	A7LBtamWWxRnL6569S4blx2ko3KQANraeIvPxXDyqTJ3idtjWB7tZpiDs6qkf5RWOSo9tFErc4d
	wUGIsCf2lFu+OUZQPP6Zz2SPZAMwuuAAqAcA58Uo9GnVrHbxm2mrcPfsodVxzYfNO8zXaov86uf
	CThcu2wrHa79LoxF+7JqtkHwGJplr4rCvAjURSWzaO88SwlVi1C0oYGQs081X4V7U4RXfIqueGx
	L9ImdF8ush83JUJJWXI1kuupkW2KxB7zDbdcx3HPkgPnksZuolho67dSn35qMnHHWJl1FH0=
X-Received: by 2002:a17:90b:1650:b0:3a0:c162:51af with SMTP id 98e67ed59e1d1-3b1b05fccc2mr17699416a91.0.1794870410469;
        Mon, 16 Nov 2026 15:06:50 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b3abe8b263sm1120355a91.13.2026.11.16.15.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:50 -0800 (PST)
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
Subject: [PATCH v1 2/7] pipe, fuse: use GFP_HIGHUSER_KASAN for pipe buffer pages
Date: Mon, 16 Nov 2026 15:06:22 -0800
Message-ID: <20261116230627.3537051-3-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA18416000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: h97zhbqt146skwjw5fi7tz61q6h6rebg
X-Rspam-User: 
X-HE-Tag: 1794870411-268909
X-HE-Meta: U2FsdGVkX19hRBDsGohYO5fttUqIpo55HuFyb0VPQ209e1Kv9tC3ge7oQyHuEVcHn+5WBkB+XXZAC0QKngeMrNEfe2SdO2aVxx+ad2FbBApmTSFOV3+xLjW373agQlkWmTTOMvrjntBvoR+inM0xlM5OxklBBRo6bYqaUHCKVCVdpQi9+1rd8IoxnkNnVzbCA+64kGVtWImWKn92RPcnaup9l+FzoaHKEI1DsXgF+Ek1/3nrkMDmLqV/hwi4JZNXIxyUl55tGgzHYxFR/ZT8Pu9swvknBJD+jMdD/XkZtFrSOJZjqQ0nP66hUGUPW9uf8i6+to5H9D6/2Qy0ejNpfpyvd9kqjKjJL0JsqgdrhhU+DiFat/ZdCj0B43h4Cc7ckPaCb0UKjS3yYZYBFoc/4JNAMFRrvo/gdhbMjhxFPzdsX47cXSE4VtE25o7qAxSYit/ftZz3nW4/3agcnIokKTD6kyt5AAeORfXetF2lrDeG6jPcJPS007VuYTHDHMNoZXo3efiFylr9I3hnBQAJIYnVN46pFrVrdcpdWJ5OOsOE9E0E4gyu47YyFlc5dlq38PBYoVD8QXdixYeDe1Cm7RhPrG+vO8otS6CxNYlmY6B6aKedolvP+DXvJ9Ik91ALn78jluCOD9Zgxl2jvmQXrLkWiv1Jl3Sr2doFjbPttwhUOzNaIpsXB5mqtkw44CXcU1V2MdH0tsZUDqYOrKP7T4i0h2MW4VjrxZ4GSNWT4u8Fqnn/31Sj4ozHbY/5oftpMs2UIENgHyrBdSAJXxXgcTo4ySiDeiqcMVj9HHg26GcSOccDZ1bhItKg1UvDKKATOx1YyZRPi3fyBYvohnwkSChi7xmqCYhR0tv++zf8YE3PRjRrliHLx08++GCmcHRrU7s7cWR3A3vEH56kq1Mhr8wL65Gi2XDx/+f4qRKxfMYG2/QkZbsBRJtGw/FlYp+MWOqPr9pi8iQDCrLcN4S
 kcZARC4F
 I+7W8yXHDORWvtuYlOgt4q6cVLMtPkSUMtCecCVm0RbXZcfNC8T/tvH4NaKq95FIrVqqz1+81vf6uxR3bS210DyfivegSrb/LwSqbg/i2hkQBrSsjDFinNtqW34Qy/ix/UoafsIIY2T02Cc70vuGfyH9Fjewy9n88SpTKdBzq0Wiwz4ITz09CDcfCc5vGcc5LHJFTDgXgxozoXMzJCra/x91vjYwCMwIOoi435mFgRJif2SFomjGKvLg65qk9Vb+dcaNR+p6gDEUqWji/TGHxhYPyK5iPxcJD1AEHPx0pPHWczt+iy40qzz0FmAdLxINi/wemufTQ7q0MkZOwXqCHCj/Cesivq+69xabKoGimvWv2vd6/tO5n3rjJTyOZ4LXToSkKuLYetIvSFWLbF0S4Crpg1hzGpCQk7aExqEtwoFcBzv3L0hwJrp2asImRWh2ZG5DZtuTq7IyHdmVMrtRSOb8Bnzy4JbVZo/U22vDMb2NnVkiDk3TqcDOanKo7aCPLAScK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pipe buffer pages hold data in transit. Pipe writes allocate them, and
the kernel fills and drains them through kmap_local_page(). The same
holds for the page fuse_copy_fill() allocates when a request is spliced
from /dev/fuse into a pipe.

Allocate them with GFP_HIGHUSER_KASAN, so that they keep their KASAN
tagging when GFP_HIGHUSER starts to skip it later in this series.

No functional change: GFP_HIGHUSER_KASAN has the same value as
GFP_HIGHUSER at this point.

Assisted-by: LLM
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org
Cc: fuse-devel@lists.linux.dev
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 fs/fuse/dev.c | 2 +-
 fs/pipe.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3641abb90d6b..fdcb11679dbb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1044,7 +1044,7 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
 			if (cs->nr_segs >= cs->pipe->max_usage)
 				return -EIO;
 
-			page = alloc_page(GFP_HIGHUSER);
+			page = alloc_page(GFP_HIGHUSER_KASAN);
 			if (!page)
 				return -ENOMEM;
 
diff --git a/fs/pipe.c b/fs/pipe.c
index 4fa69192e6fb..87792ef63564 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -155,7 +155,7 @@ static void anon_pipe_prefill_and_lock(struct pipe_inode_info *pipe, size_t tota
 	}
 
 	while (n < need) {
-		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
+		struct page *page = alloc_page(GFP_HIGHUSER_KASAN | __GFP_ACCOUNT);
 
 		if (!page)
 			break;
@@ -201,7 +201,7 @@ static struct page *anon_pipe_get_page(struct pipe_inode_info *pipe)
 		return page;
 
 	/* FWIW: This is called with pipe->mutex held */
-	return alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
+	return alloc_page(GFP_HIGHUSER_KASAN | __GFP_ACCOUNT);
 }
 
 static void anon_pipe_put_page(struct pipe_inode_info *pipe,
-- 
2.56.0.611.g1030f0b940-goog


