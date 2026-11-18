Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9AC606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=AcQ17AMw
Received: by kanga.kvack.org (Postfix)
	id 814696B00EF; Tue, 17 Nov 2026 20:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79D9D6B05B0; Tue, 17 Nov 2026 20:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63EE46B05B1; Tue, 17 Nov 2026 20:29:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 250DE6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 874741C3F26
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:29:08 +0000 (UTC)
X-FDA: 85446506376.08.C7004C7
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D1A440002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:29:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AcQ17AMw;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794965346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QrBc0w3KV6ChVNAVMzB1hWL9AMrXve7Stq4IEHc3B0=;
	b=uVaTm3S9SQREOHi5MbYEVd461uNMlDaX85jRyPW45hHETBLftCN6I9GXk5g/7DwOX037k/
	YTxgLwyvXyYFvL36MI72fisP1UR/CWAc9DVqlGkVuluriRrY6ygn6bpezy/Ma0kFX/U55s
	TuXOTJOCxdNSvhONqQGwybitfvyWPcM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AcQ17AMw;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794965346;
	b=YfODRQSDm37mymaNqwMB3P5o5ZVkBp6yRHX8DlSvvpKXDQS745swKtnYFxJvd7hcFsmCEx
	9OGHiQJexiazfjGc5VIAxUHK0nmZNVTTAI24gmM0BKfTXAcSv1tPqvRJRv+Zox5msiMMBi
	6dRhXdURaxr3COdk34pe99rKd14xaAc=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3b0b133f64fso39500a91.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794965345; x=1795570145; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9QrBc0w3KV6ChVNAVMzB1hWL9AMrXve7Stq4IEHc3B0=;
        b=AcQ17AMwJ1l5UeNebkYyxNsd9kYAemn7VRDH7160JNqHAm9zhA1z1c0QUGdcv6xlDH
         C3hiZXdWGONdRGaZsf95+fspx1SUs3VvskiMSK4Z0jNfgqDWMYsfHDHVkAYszZaPec4k
         YSr2RG7X19WRGoDvyt2S3InROnGVdwDGULR7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794965345; x=1795570145;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9QrBc0w3KV6ChVNAVMzB1hWL9AMrXve7Stq4IEHc3B0=;
        b=ihl22KKKzykYa8VTQXtEWiS0ypXBM7F00ODSH6jc089rIIBueEWJ1zaNEuDgom7CIi
         vmJBvi3q0P8NFHsBNOcnjjmhVFhINjvapXV1fc22BhTxWO0sQIA3fMzvUAh0hw0pDXtL
         KAXCQw1/+bkNXLrXD/M0SyJqWeEqqSpNVKozpBjEB79QAdvUkRXUU75n6Q6oIjHoW4PJ
         jzao8jpYYez1EWSMcaCX8Jceat5poCjkxNLwJdQmxH/w2+g+a/ZvCgZmkqn8wKoEnnO8
         3VJWoC30gAsV8qBO2ogAWAffgpFlQ8Ur+PfJ+JB9FVuU43z2//bSK8S0ZIo6XS6//wYY
         i1Lw==
X-Forwarded-Encrypted: i=1; AL+hErFWJw0YPOOVl7crbYHrlBjuJ6DhhTvxx9lGpPIbzZbi4aGXhB8NDJ2qeJDKXJwkzYWResHmyGe+xQ==@kvack.org
X-Gm-Message-State: APuU4Z/oV6GYpNw7TNaTuKg2RBe8D/6iV5mvFtRdCsuk12ClBKPl+2yC
	A+xDMh22SBLbM4aurhMG+I7/nb/XIJLgGkW7de9H89oxzBOecd3QM7pP6VweRJJh4Q==
X-Gm-Gg: AZFdTZfKFI98VzlPSbWjWdxqIgSXz1+J5MPSXV1Nj5NHSmX+o6OOy3fq9Qpli+Qs3Ec
	WDbPfp9CKGHjA7cIstcwbEUC4mcQzfWJPruSnjWgBEu3dgjXW/TgjPM+reOfQOsxXGOSRxKBFki
	cqwr1JaMNMRY7zmckj08d+cqKeBweUMJTgJmDRo7CboX/nzk7t1hckZmy55UbXls1YS0iVo62/l
	LeSAtwkYO3vVcm9jDPEG63E0uH4Za7BvdkYpfUCecIF3BfW2TzhqjR0W8jnxbT1m0OOegOR3oce
	1KZfKg5miel+8iEAVxH7Be49yjyQbiFn5KkuFoSi0XAKXAOKN34uemHtIiCsI5/6+k6s/zN2OVC
	mFYYUHXr10ee4Wo1hp3M8JSoTpvIlRdnnHEmTtSHvgCGSmsHI+sQaQkemSYiuDiO+nqqAzjz6Hk
	CFeULXkw3N+NimXEPZU158GBkD87RrS2CWQi3JAlcER5JkpvgqtHTid9hgwG88x6lVoCiLjzCVP
	B5wgGHGYMB9qAB41hxKK3WAxioNF5/Ep5ZOzyKNgqBZBMYxkvqhwkN74YQKXd+TmGV4q4ekTh81
	0Y/xNarQpuvDGahN7VG6PA4cjAdr1pL/KiSlftcFrySm64orn6r3cfhFBLMuOWIAZ6kf03s=
X-Received: by 2002:a17:90b:5390:b0:3ac:a11a:7c88 with SMTP id 98e67ed59e1d1-3b3d07af9f8mr1892178a91.3.1794965345247;
        Tue, 17 Nov 2026 17:29:05 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-cde3b98c75bsm243073a12.10.2026.11.17.17.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 17:29:04 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: David Hildenbrand <david@kernel.org>,
	Tomasz Figa <tfiga@chromium.org>
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
Subject: Re: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Tue, 17 Nov 2026 17:28:58 -0800
Message-ID: <20261118012858.289236-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.703.gf848ed807c-goog
In-Reply-To: <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com>
References: <20261116230627.3537051-1-jeffxu@chromium.org> <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org> <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D1A440002
X-Stat-Signature: agf4df6ykemor8ne9s9hpfhazp4jeixk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794965346-618601
X-HE-Meta: U2FsdGVkX1/ovpwr7C9avTaEaHV3H5X42K7apx9wHiMfwUsr9QgS83l2vFjduHgcDgthPHuCoKsaNOeEN8v/sqfp8LYd9xmyxUdrFNbVCjksn3zzA7tiRhxDl5PARK8wP+mrOAwaVfH7iJDxggsdQul+l5/eAsOmtuLCUIFYx5/0Xj+QWPnu/r/9LHwyRK8ipxDak/WRwkWBMBe7qSjM1LCd7j1Q/1iu8xeT8ADBin4gFvey21o7gGAZ1qZTm0R8HSFJUZaFIekx5hLGLUZ120CN9wfBhr8sSORWqSRgOi3rtxZ/BwCSU1AWEUIt2VISmoeiXlS+29NGUWCEhQpoC1vkFmFp1HtZ+o7UvsdGkQVvdTwwfsgx7WLQXco0HGbIFuV7/5lx+q5pM2mWFBqB051lgGfGH+RevpkQwAYJJ1KLfDPoRCLKlG3DvSmzyuhdXu71yPV6iAoutNxHgLYdBm9v87nFq5Xv40GAhfesGpbj0poe5PJdv+wIn8I8L2tInD63qnML4e3W0WSLH3e7a/DKjAOnNO/jlMOV6H2jMqJRzY/Pcz3IHZwCKnuGfxhoW/SynzZZctniiPNN4zs9QcUr8AWzSz0MhwfThzWHG7yEJvoPOUYeNfRR1aVzyQzOH9wXOEQvpxfsiRMhRDj+iTY+JM7HP3ZwhtZ3X/9AnYzWsoDz9t5nrq103V3oURDer1/Ug4TYTCnYW5l52uQeoIAOAIwVra+ThTRVUOvqh00fV04LFjUXmp07a4yj4+SjculMjYuYDzMz2K5H00HSLKT1nj3wH5Kn0+P4UIg5dIi2mcW+irfTHmfc1ftXt/p7j0gsYXZSmEjlGMucShqIUYl1fOn1qtdyo8gLFGoVvN8FwZ7XmrAyM/FeYiuPhY7lYPtC1aehYRfNIrA1xSdIlhrjU4nm02gKjcqaxNPdPFCaD7alQMTpjKbGPFaz/OrZDgJlVxnx4Ts3DTT6JL9
 C2Ehktl4
 /FsfZL4/Nz+gbKsoAUV+7V4ATfyakYReFPIRZjAIo1J3vazRezob//Uwrhm6arWm9KF8hJlI8NuhVS6JNo558wlfMXemBeAvhsIcM9dj8+gHw8WLMkbdWlolwV0JjOsZAu4Dd2ET9U7cn5Id6nj5JjMDwqYUT4ns5fT9AHcSuLjCTkKa1pJfwTu2Fee6S2VyL8mv0/LifQ7OS6wWAMSs3BPFEooijueoH97Q6yxNM1v+M2uG5qtCyO04zBly6gi9UJY8bQHHa4nHt/cuN7YPSEcOt1zIsqcHA2qpjZX++gbqc/KGg/H24vE6QyWrakb9w/XvEcjFPyYT2mYcufXyUpB0xj6eI5aMLWHNKjb+orrb4DiAw3u3eL9Vqwh84GiqmCxshOO+t8Ma+mcFcmk20O1rjyj7Wr3dzZtHSI5REqSx1VJ61Xly6S45v+3KfQ+TqzYCpB7NVHjoU2bU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:11 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Tue, Nov 17, 2026 at 7:10 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > I really don't want us to spread KASAN-related GFP flags in the kernel.
> >
> > There must be a proper way to abstract this.
> >
> > Why is GFP_HIGHUSER not sufficient? We were already told that this is memory to
> > be mapped into user space. Placing data structure on it and handing out pointers
> > to that would already be a bit questionable.
> >
> > So what are the ways to avoid GFP_HIGHUSER_KASAN?
>
> I think the idea behind GFP_HIGHUSER_KASAN is to make it possible to
> skip KASAN for GFP_HIGHUSER by default (for most of its users), but
> keep it for some of the users which today use GFP_HIGHUSER for their
> memory allocations, but could benefit from the added security. As per
> the other patches in the series:
>
>   pipe, fuse: use GFP_HIGHUSER_KASAN for pipe buffer pages
>   kexec: use GFP_HIGHUSER_KASAN for segment pages
>   net/rds: use GFP_HIGHUSER_KASAN for message pages
>
> That said, I'm not familiar with any of the code mentioned by those
> patches, so I can't really tell how much they would benefit from KASAN
> or if their choice of GFP_HIGHUSER to begin with is correct.

Thanks David and Tomasz for the feedback.

Tomasz is right about why I added GFP_HIGHUSER_KASAN in v1: out of
caution, I audited existing GFP_HIGHUSER callers to find any that never
map the pages to userspace and instead fill/drain them in the kernel via
kmap_local_page() (pipe, FUSE, kexec, rds). Since this series intends to
improve KASAN performance while preserving its security aspects, and the
performance impact on pipe/FUSE/kexec/rds was negligible in my testing,
v1 was optimized for minimum behavioral change.

Looking closer at both of your questions, I agree that the security
benefit of keeping those 4 under KASAN is minimal -- e.g., only linear
overflows out of the pipe/FUSE/kexec/rds page, since none of them store
kernel structures or pointers. That is the exact same trade-off we
already make for GFP_HIGHUSER_MOVABLE.

To avoid introducing GFP_HIGHUSER_KASAN, I see two options:

1) Simply keep those 4 cases under GFP_HIGHUSER (drop patches 1-4 and
   7), reducing the series to just the GFP_HIGHUSER change and its KUnit
   test.

2) Switch those 4 callers to GFP_USER. Since CONFIG_KASAN_HW_TAGS is
   64-bit arm64 only (!CONFIG_HIGHMEM), GFP_USER is identical to today's
   GFP_HIGHUSER on arm64 and all other 64-bit builds (and if 32-bit
   CONFIG_HIGHMEM=y builds still need ZONE_HIGHMEM, that could be gated
   on CONFIG_HIGHMEM, though that feels ugly at call sites).

(1) seems much cleaner to me. David, would (1) work for you?

Thanks,
Jeff

