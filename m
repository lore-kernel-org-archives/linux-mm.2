Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACF3606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 19:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=CXlYNn2b
Received: by kanga.kvack.org (Postfix)
	id 7F14C6B0850; Tue, 24 Nov 2026 14:55:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BCE6B0851; Tue, 24 Nov 2026 14:55:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C7C6B0852; Tue, 24 Nov 2026 14:55:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3820E6B0850
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:55:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA8C440D0A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:55:03 +0000 (UTC)
X-FDA: 85471066086.21.F6621E4
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id D1F9A100002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:55:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CXlYNn2b;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795550102;
	b=DI+ITlLDiYWZrU3p556XUmPhhOZEuIIrvTcbda6k91zHdd9zQuZyPCRxtTOkb0qch3bxU9
	KXqFJ8e/rayZ03/fomfPGFGBiW6wyxokOnsdcnQMXwNJRc4mIHgm20y23xsg0MYrplgu+E
	n1OfRk+vEuT644ebCj8b6qUaleExxIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795550102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IV7aCStFZdnFeaXhFPoQdGrpPnMKMt+5GDtnao0aM7M=;
	b=4z5qQ9Eg8Ol16Y3Y7FBFuWDfj/Z1UBtflBKlqavlbi8raaIQNWRRky2yShptDHy674pTvg
	3PeqHAQZOOtNQAC7m481ieLpYw9r28Sc6QvHuLJdOC3QgIXCtWj6izYR++GmkpXUPQx1eR
	qUtFv8UkbB7SImYDqTPY87zM2WCKTMI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CXlYNn2b;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc785ed8aacso122756a12.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795550100; x=1796154900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IV7aCStFZdnFeaXhFPoQdGrpPnMKMt+5GDtnao0aM7M=;
        b=CXlYNn2bYBT3Rq31uf1l0rjIhb9aacY5jy5HzWUZC4GxxhqL0M1R9OBJpx2Xb4UCXg
         fcPh2cAY+97S6US/Z1oFphqfyLZLEvOhHJRurxUC1rLURTr8/WkOK4HaxaQ3Z/yW+c+p
         0uVB2+XdyBKtJE9SRAH22kLzoJXbwhzMnOFcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795550100; x=1796154900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IV7aCStFZdnFeaXhFPoQdGrpPnMKMt+5GDtnao0aM7M=;
        b=LQZUWKnnNwr7EVqy8UQpkiOHCYJWNcGXhJfskJ9k+FHW9KAiqJePzfABSqUNyvi5AM
         n2NFeeIRO9E/usvO2wMdveI4fqdlIuM9OVvRIJg6x/ng+zzp5eB+n8OAK1yDyc6vEk6G
         vTbU46hcitdyEHmOwWLUtLf5kP1pmSAHdgBBSa69A14rEBLmbcW+aVYdqtwb/t9vA4Ci
         TqNaD7yBDdFvigznVSy3INIVheCPqzFH9afr5AgC5L/PsWKu4hhEHrba67t/3LznojcK
         5f0iXolkKt3fg1QGz5C7G7JuKwJ5dgWQMT/LB3jxucURNpjfXdNEzGCr2xoDApvQm28S
         Sndw==
X-Forwarded-Encrypted: i=1; AL+hErFz6alx42c/NmU78AapBatRc3FTmfNtbjaejNJUFMFGkxvE8TLlVT0jp3v2QOMz97o/PIKa+AwinQ==@kvack.org
X-Gm-Message-State: APuU4Z/5JBjwDGLr8/4WXvxo/2yCVKGNZDrsfsw9/CmxxyyZ1FnK+Bl0
	Ui2L4+fckY5eI1zocfl38ztpWzjwTftKXooaKsTFAeAvnIniazUF5ub2bBvRjVFVaw==
X-Gm-Gg: AZFdTZdA5O3vGfxt5cbknm+eBXQnDNh4+/GgLeq9R8LjeAleFSsn4GVCzps7gRkFrnz
	ZQgajG8CbOud3aWpVXL8y0+b8P7FZV5W4UePZ764N/wsS7ZnXKWn/jQZg/vMEdvr5gGgb1xBY7d
	wn3jibFHPXV82Va25sdDb/x/qmYs1Yznd9hB5PjOoS2hgK4zXkISylFv4HjKSaznDb36JSCEFNH
	/4Q7Hj74HYxVmpzQmjDrPjhnogOJcUhJPfI8Tv1/6N2EiYByGw9IonahA1bs4nNKiMXVct/0Xed
	RJnIhyxNzvfSXWMxNqiMlAuxA2PkQp/EvFiLAIQ+8i5peuqmBApBMQQ5XVlNV4sQQgLexS0pNlq
	jLsE2/H6Sjy1aJ4WHYJmD9vBVuzcNhREVHYn4Mc2OXuKuI0Kd/Esx9lSSx/Gy9LJhzG0304RmcE
	wtYPdw/vHmLSA0NYAr0KOPSe0PCdsKKbyARlyB4Ft2pKju3V1l9s+CwDfcPXK6L+9YZqS5uBTmC
	vAZ4WIpo9IIZe4gET5h4mrjWLdAYmoo7F5decn7WJksfw96pyXaLU3z42VjNasRuV05QwV3lYaI
	fJoMYKz3K4lD76QBhBC8zNfK0Lv3e9ctLwsCKaAGkh3rFailCIFzjrRJ8xY6q4HRRS2e3Q==
X-Received: by 2002:a17:903:4688:b0:2f0:7d6d:4a09 with SMTP id d9443c01a7336-2f07d6d4bc1mr137239435ad.1.1795550100419;
        Tue, 24 Nov 2026 11:55:00 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2f03f142b8bsm72335435ad.70.2026.11.24.11.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 11:55:00 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: David Hildenbrand <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
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
Subject: Re: [PATCH v2 1/2] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Tue, 24 Nov 2026 11:54:55 -0800
Message-ID: <20261124195455.164425-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <7ed1f755-5759-4b5b-ae00-a814f16b7903@kernel.org>
References: <20261123033111.2349160-1-jeffxu@chromium.org> <20261123033111.2349160-2-jeffxu@chromium.org> <7ed1f755-5759-4b5b-ae00-a814f16b7903@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: erja1gxhd1wr8zerwrkrohpqeahoqtdd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1F9A100002
X-Rspam-User:
X-HE-Tag: 1795550101-996064
X-HE-Meta: U2FsdGVkX19fYzzpittqs0T1hk8iZmRxtk+CxYvnWkhDscl2Mfiwc0T+lmVCB9T9Cn2HXez1frhZTs2KAA5xNn0gcVqrk29GyA7uh7F5ZX4UYOPxvVMkvl2+Wi67o6ecd8JpdFcP/lJ4Rk28r4zAV6TFZBCajPLB2Yz989sbFJpvcFPCyGMwt/NS+T/VBFjsofPX854q1JmZLlPWnlnve6bI++Htf9y0CF6kemxb/5EbW+k+Y9Jd1mk/rSdSG2MSSV7ychI0DnPTuRv67zuFCaF6I1hw/EoYGObhJNpDbAIhXY7VcIZbo0yGQzd3n7Qy5nm2lGGEGDBFvCZ6aDHSs/VY9CJfxzM72ZG60KSW1uwLBdk2haRhDKi+F7/yEexxNufWnz1KciZ6bfm5/xZ7HPf4zLZMV5djYWDpkSArqz+VpOflpEiCQ3aNoHpFoCd2Arx8V4l6pZXbRoxl0QlfzxKl8l0vv6l0sMt6wAWHFEU/lYmMYhPht3rbNh7T9Rm9x3pumPLgFly8WftVzhG02aU37EQSeRjfDvm9lcMAkx4IgXlReRKqp4hWiiOSgvRZJjvMXBa5rLYD8teN2e5fFc6pH7LkOPf3+/NHxMpQenS5SOWpZwsIbJ/GOqjeFhn+V2s61AcSpIgyXVY5nL3l+OepgHNnR0CFPPw1UvHSGaj9rR4dxA1t1En4XNaonra1qlkkO4gQMAokXUQzPWwqcu96ZkO2vj0hi/XiOL6jVy6fnSfQPLBl663yvc3lw3UljcmnqulrqhzKM5+XNoMlHfi46izSe5akEAbZ9/rc3ZLmRjP1xd55qHS7zt+h5LgyUuo5g++9N/4MXETcYt4NpZnSizg8JOcM4/+S3b1vBI4xAZPWppOHkSS3kvB7IbuigUMRxflhQ/xGX6RZuMDoAQSYox4Yrq1O4sGiNBRCaW34h2tQBGPksKauvDa/YFdzAavULJVPtecswNUFmOZ
 JHotPrg7
 ++jhc0d3IrEjNQrUQm4jLgSjwcYkU91w2GsW6IRuRVc2P7u2JbeKH2H6UMs+aPeEr02SdMyLWMf2JwFHfq4OR2RjeKgICvjELYYN/aJ3gueJ7CZUsIKvX/9eaZg/PVP8f1o/a3t3twGL1eI2GebAcOkbOt9gjEzSp1fLD6eZ3K0zpOGMGxWvLdUw2peHZuYFuvnECq8PmpUChq1TC0ynzVQfvg36me+OUUZBb1ql/fUe0ZbUb/euAV8qJhPPA9OsD3tU8/eRpGYnM2x/SKSQXC8vaccN5HmCisiejZZrv+DTQnzzhKOWmF0HPg0jL7WAMMMlmlnHR27qG8QtHXhSpHTL6WqtFD8aQo3cO20fdKli3TQ49yvPAheVscIfmccBBwCjZlZDsJOm9YIAbZSsGbIcpYapmbO4cB7ayKnQaXpCDdGxWNXyP4WuurlUu+jdhF67Ypm4MMmLab0oKxo+7LHGfJNg+0oHQ/Al9bQjQafR8yIDodyGYHSFRp4o/NnzQSrSlZD9vII4tU7tLN7T23MvAd3QYRH/cYV7h+7gs4b4OWKyAS9iuqLQfDdXaHVAq59b6tuFY0d1vdutZ6eaR9lj88oo4HtUqbasSda1J43LaDeeKLwLTwgkRFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:10:53AM +0100, David Hildenbrand (Arm) wrote:
> On 11/23/26 04:31, Jeff Xu wrote:
> > -#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
> > -#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
> > +#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
> > +#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
>
> Can we please add a big fat comment above GFP_HIGHUSER, explaining why we use
> __GFP_SKIP_KASAN and which security impact this has?

Sure, I'll add a comment above GFP_HIGHUSER in v3:

/*
 * GFP_HIGHUSER (and GFP_HIGHUSER_MOVABLE derived from it) sets
 * __GFP_SKIP_KASAN to skip HW_TAGS tagging on allocation and poisoning on
 * free. These pages are meant for userspace data (e.g. anonymous and page
 * cache pages, DMA-BUF, GPU/DRM buffers) rather than kernel data structures,
 * and tagging every granule on allocation and free is expensive.
 *
 * Security impact: under CONFIG_KASAN_HW_TAGS, these pages carry the
 * match-all tag (0xff), so kernel accesses via page_address() or
 * kmap_local_page() lose HW_TAGS out-of-bounds and use-after-free
 * detection. Callers that store kernel data structures in these pages
 * should not use GFP_HIGHUSER. Generic and SW_TAGS KASAN are unaffected.
 */

Thanks,
Jeff

