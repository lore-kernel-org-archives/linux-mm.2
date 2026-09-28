Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5DCCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9D26B0092; Mon, 28 Sep 2026 11:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181896B0093; Mon, 28 Sep 2026 11:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097736B009D; Mon, 28 Sep 2026 11:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D75CB6B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:19:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70B2340269
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:19:47 +0000 (UTC)
X-FDA: 85263530814.23.E166D89
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8EE36180009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:19:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AYuUPyLB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2+B+TCtU6LhjPX3KEHp5ZhDWyuT2oD8RctAdhdkStc=;
	b=eLENwwCLiBtd+WKQugRdS028VzGLVMFCl4D/FpvzeIvK1g1pgPC+/TEBJ9lbCGQqiEvWCy
	i6Qjv1AjrgQAdtm8OnfL9H162sDxgKxbSbUt3Fwk5zaAViBGol2VvZea9fzkzMMobzJmjt
	PfY2h3GpgrECJ/sQo0zwwwN3F9u/kxI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AYuUPyLB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790608785;
	b=5YwTChgBWODobyaG9oELHZk3dRJnuK4MC5vz098m2RmuL9pTl+/KOzHctrrnS+UqXZ7C9x
	oORvKMz6LY4qZ2opg23z+bgORfSUqv6aIXXAivi5OqtChQqA0h8uFCPiLHvpIzPoc5dzl4
	EYxxuqFrsPls5p4b50mdj0WHAb6u0zE=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4c3304784so1287636a12.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790608784; x=1791213584; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h2+B+TCtU6LhjPX3KEHp5ZhDWyuT2oD8RctAdhdkStc=;
        b=AYuUPyLBDPFYzX5nmoMMwTmWno4tAj/Yph/IBVIs8utIiA55doMJV2kTo1faPspp0L
         X7lPA2Z841r2AVjmsmQtt/1gTNoFO5P64NpL+FlYyqXbuhd9zXXQWncSIXyIOgpHXdhc
         UD2eiBqqfxqHQJGIvb9OPj+sik9994UJEJLXXFcXeHRIwZ+NBDlEoFLxQ1sQX9w0uwnY
         9pYSuVcKSuUr5lvNoqn/RsWTWJy1Q9vgK+81dOGNytjXzQg0K/gP/5CL0bNZ2sm6ObxR
         ATnRbLUhT8alwg345cwWqbrcj6mz/63rVFzAsVMbAxnG46s2dEuoEu3uoyyJ4/vGMgqU
         PAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608784; x=1791213584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h2+B+TCtU6LhjPX3KEHp5ZhDWyuT2oD8RctAdhdkStc=;
        b=aYCPg1qKvm6mW1HeFGjdN4A8pLhwxDP6rPCj/2+S8+OzOJch228NoSjv+JXEVDRIzA
         XHd8rzuzFKl0IkfTIPLcriv1ss0nIhyAGiO3Y/8ZmTNHsru4cuOAfMlawAQy2dv5yOQr
         mYzVlYllSe4NVtIWk9sK3WgkiyVCtrgtfXnmLsnKulEcMrE0iezc/vPx/zzL/EAx+onV
         hYgUaBGeizXk4GWfR+tjzXTBGwQ0JNTg4sGKaPazP8RKJ0MRHYcNoVB4xF4tdcrDgmxW
         PeB9WjWAxIw4snZ2KmKS1F85Zk15qU5u96iHtSkBSJPv7Iw3QsFPJKP1l8F5tXqKt6rR
         rIaA==
X-Forwarded-Encrypted: i=1; AKwUvByW4RX5xoVDJeZrkqFIZwXUWUNC+STITWupXubwCbEJXPXGRW3fghKiK+1fiaMKnFVmb7M1BQ/6sw==@kvack.org
X-Gm-Message-State: AFq9FYIgYddM1aAO8Y6oO7/LmCsGuiBKiz5Gg3HckmIiIZZRT+RC80qn
	/ejBRTaOKL08fFYyRipGbq7FLBX+iCQ3X1w4du3pNnNfWeufCM7o6Jlc
X-Gm-Gg: AYBFou29GZn8Cuj5RsnWH2c0WNqvdAkhHkqTxUXV1IR5C2MEu7kLL96OI/MgHWc7sIy
	YnmAPoW8HmlGRkAv36e67leRLK29kkUilTYq06LWue4y6N910JOwhEyzwWxi9nifS63xuETxxaS
	0qFyWD3kRo0SShCb9H8ddTXj0LKl1l4IlSX6yV3hZIAgVBbRJ+JBDDy3BXGlqPFTBKDnjUJ/Ydr
	NL5Pwc4U5mpiqHG5RMqQrtiF7Yx7hKSBQgZYakVxzkS5UuDkJkyTFvo9A0eEj3GrT3xach1gLdJ
	Z35jC20kvsLbg6G1hrIThl7FbUN/mjHsnt1eMZuRmcIXELgAbvDX0iNgIyTz2JdqLM9zDsmSd/B
	OxvbFxE0ZEZOqUyWQwUnUs5Zp89xqwsZr3O8HrhS4j3hNedtgzmaxMXKngHZdOkWz+y7LgcEHKY
	WOBhrr127P+b5kkH6Ca/KnfsBtPQGQY1ET0OXmglY3XTPLmHWpOVGmmlPX2j0tnTFdVi1W5BfOY
	zanM3g8Hobn056h1G3KRl1PmTKgeGhzW6QLvsheT+C9aOtj5XE6yIqSl4jYkHaayCqgyt/q6ht/
	1eBKFPh7l3A5ZqB5dPVX758sw/C9VAeHAgvxBilIIZRmvh1SxPe9D2vqcZI=
X-Received: by 2002:a17:90b:3908:b0:3a0:c20b:2fdf with SMTP id 98e67ed59e1d1-3a0c20b3132mr6450444a91.17.1790608784281;
        Mon, 28 Sep 2026 08:19:44 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9feddd0sm7247965a91.2.2026.09.28.08.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:19:43 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 28 Sep 2026 23:19:34 +0800
Message-ID: <20260928151934.2686418-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arn4xOIxFRD8qY_x@infradead.org>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <arn4xOIxFRD8qY_x@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EE36180009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8d8wsnf5w4zhztsuezgm1yx1yds9u3on
X-HE-Tag: 1790608785-206389
X-HE-Meta: U2FsdGVkX1+RRGoizZwyACL+DkJebijgCmLy4v6SllqvQ1EZySd/aN6m2zqs0DZ+X73Qy9cwwL6yTFfteD5C4magNDqaPm0C+toprtZ5hZX4oCa+ztql5kWJr67792Xcn/ahWUx3RVv2h7GjmqpdKosj8V0UY3cxU7Su5t2P44lg5y366aiZKMSXR6ynz42PFjvrIjYCRRK4nJ2HHRULAc8khmTl8JKjm+H8UYL2c147wAJQZz2wENOfSYfmhtCaEu/gEj9x+gbRMAovHBliKvr9X83NF1d8gPam/viWMHOvOUnBukbUs6rm1dWSLySZh1QtMxiZvARC+LtQlwbrJclU+HlCKy8t+9L+Lwd+ox5IpnWvJPb/YZmANQp643ynE2G1JmnfazBcOIG6r6pDppvjCjH2b25mXZ1+9yiIeSMOiO94tKunLFQrra2A62ZCCZh2WerPCQE1UWbVDMqZHjMEnGylps7Wjs7DoqdSWdguKh0Zg+RV53N4skMrVaUVYW4dIt/1V8mVgL2krYnMuRBgN0D7QW2ylcAQtPjh56ZBzMTiqUyQJ68SOdOyj0XdkKj2rfiicYp9oIx498BJVaxA8vskfRcJ6YJvAwr4wNClYIdx7yTUT8zRtycSZLrE6FisRnX92iOPxwquv4Caef6Z6OtB6c4wTRVKdjV5bR6NgFz3yr4dHlJnMaVYz6Lv2Enl9TV9/YYLzt9UCzCI5ke7S+cNiv8Hcaw9mWfXfBCF8uJigDXKJE/LrImC+XHcjQ7sWEr59Li5vkg21MFUF+A/upSvXHmObys5EfzEvjKhIr71/vGFYu3ye2FF7YmJ8fuDfmlKUDJHyHDWOMjbRpouHJRn7eGihFIXH8tiq/vK7RrqfJyDMVskEq3b/NbebkYTlAV1V+mixHF31L5LvUTKoYDHPdnBkQrhHKIBIp9Sle4v01Y8ybe/Obk3sRRCgP1oK9q8WosjygPXJ5f
 IRpQJHwj
 p3Zwdbuz0eZfyy64LsOmLn0Xq99+ZtBrMTmNVWRTl+Wr/9GLpGYOmMd9JWpvoCUsOCH3hWggSb4D0bjpZ/gfYF0iJS4xIZKoAKLOE0rBqvxJYDwuNXbltmUGl5vtJfOkE8v854ud0zxWchccOhP06eItMAOB8EFGvF2LhnRysYGn/rwqkBf7KVM5I89OrD8+ZxMLCQidEYY56pSFHhAWAnTKdbX5wPgEPAeJHZ0L+3xaIW0YYiP2YU+c5FIDjoJLxBtCKsjzXXTSUXPNuGipBLPwjCoEVJo4in988bdI4MDlKnSzxmc9S8ptPNJ8ne2bsk8yrV/z9g3nFNd7XpSXplL9Ec+CbysBoJyVFXG2lhXECqWbMGhgIHhNIBaaYA1Tz3VfSwnrrkDiDsxgnqvNQ5RaXgjA5L/UzP2MKs9C3lgWnifg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christoph,

> Either way block devices must be safe to be called from paging paths,
> not just for swap but also for file system based paging.  So this is
> a bug in the implementation, and not something worked around in the
> swap code.

Agreed that a backend used for paging has to make progress under
pressure, and the zvol example was a poor lead.  The series isn't
meant to excuse a backend that can deadlock; that would still be a bug
to fix in the backend.

What I'm after is different: backends that are correct but need
memory to accept a write, where the better policy is to use them for
cold-page offload when memory isn't tight and keep pressure reclaim on
areas that don't need to allocate.  Two in-tree examples: zram
allocates on writes and fails with -ENOMEM, with no fallback, while its
logical size still shows free slots; and filesystem swapfiles must
give up copy-on-write, checksums and compression today, because swap
writes bypass the filesystem.  I'll make that the case for v3 instead.

Thanks,
Matthias

