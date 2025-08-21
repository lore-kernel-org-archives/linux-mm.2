Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B382CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E708E0009; Thu, 21 Aug 2025 12:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36638E0001; Thu, 21 Aug 2025 12:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D739C8E0009; Thu, 21 Aug 2025 12:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C73E48E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:17:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FC80140450
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:17:56 +0000 (UTC)
X-FDA: 83801270952.05.2311987
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3BB3C0007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:17:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNRgbDAy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755793074; a=rsa-sha256;
	cv=none;
	b=QiIOYEXJ24hh2EdQVVCHwvaJ3/QV6nkIgSD1vbvI7/Nwd/iCoYnGuAd7xbxFxuM7OiONEB
	3rCA6UqjA4g6ij7dMIXTDDZ/pxEhyh7yCOrZDPGV3yoDmNUrKLCVQMm+0oXvPEvUzjZWHO
	W6PIDebFzoSs+u6osxCar7f34mgZN6w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNRgbDAy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755793074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VDo/7VpOuAq5LBVG5WXQmT6XIsPED/75UrMMJI/okM=;
	b=sxvaBsR4B47YzAJ9L5/fFo9RbUu6jL0Y1uYl/r1DgXRBfIrOOS4KuU6uL2BLYyBoBJjuXY
	EMf+cChiAVtUkTyBEpechRilhVVDWRRVVsWt9RNWwCbYLy4EM5mEorAt8U43pGcHFR8X9D
	/2S8Dx4oyRA2s3daXDmAXa5mIpxcGdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 823745C67E8;
	Thu, 21 Aug 2025 16:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEC0C4CEEB;
	Thu, 21 Aug 2025 16:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755793073;
	bh=62f4v2C5TZWy6Ea8Ev+LCACWGOLFhbSa+Hwla4aQfSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNRgbDAyKKEZl9+zRwZ0kIv9nDBiiUGI9iztOq24T4ldF9Z2DjjelTFyu7zIriKB5
	 TQNUeYu8OEEKLXsQI1N46atx+TjxBWq6QnbIadfCaJB/5OkqSVMkwaW/rDI8xXpazE
	 OF9Ow0REARBCVYkUtWHxn3SXZSVT/+VyAyHGNdzHtwdaJ9nqB9lU83Ct+LWfXHv0Sw
	 im9et2TzfrDWZpfo6sf8Qyd+/oMfHy1zmIUTU/IRIB66iCC8ZRN1F5qcQM9Co9CW+D
	 K8j6GF4dPZ8q5LnxKgFTXS5wcAWAndnqOQn3ZcbnTV2zAQQnRAWZ1hKuadFAkgJ/VY
	 lucKDI8oCBRrg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu, 21 Aug 2025 09:17:50 -0700
Message-Id: <20250821161750.78192-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250819193404.46680-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A3BB3C0007
X-Stat-Signature: gybe3qaeu4uc5ypyp8c6bnjnp4dbmiw6
X-HE-Tag: 1755793074-431252
X-HE-Meta: U2FsdGVkX1+se6W38BcInXMI3qd15vHNVp/QXSOGwfecxHtq2/WrgBIu4VqD4Vpy1gr2e9QODqOpwF5KLMoZbD8+T7euaY24ainVahD1tlPOyTyIn2ODc/7WLa3uYY5n5mZYkya4ms7gUT47eA/LqmWqeceXX80yr5VhYPRpL3WChSa+0kH9skyu7HBPbBZfkLCRH+op9xMXk1MfMbq4poK3SgPBin6BzZcNXv3TipxBHCWYbFZfMa3kP0ZYlxOiZtHgmpnUeprEVVy4kdwt1dH0fbN+LZCZaExc4mIocn24mdXm0QyN8KhOZfByYViXn4gVS5KEq9wGUOjOoeYJktXknPVCNKNXUsxK+UtxQnXpXWHGe5khxcDWucvnONrLY0c9M4fPwRZjxEjeLzifymf3d1wC7u5CyQN6kmPE8eiDJBo8BvBRuFgcR0hIar7qgfhTwBAEZ/zPWFqH/NVzEQx/68f8++obvw+pLqXD1xkHZBPKAo1SJeeEf44JOXJYh7gyjSZkVLtedQlrSYskDcrfb5d2IaNMw8zeGXJZFLmCSqR6cVdGV4RlGychmMMnTtVuyE/fiw7txPRWOf6g400pVithITbJB6CjeVo9hHQ1yP2jPvoiQn3SNFEA7pTBI53K4itqu497ZjTjcNZNcLHWMzC99VafXOnlsEldb8KT0S8vJcLm/6hrZZBcuFUSmX43F2ZG7HzhYQsbb4sE23lQi/Xkj5JARmwUJiYKW8ZMR2xIBf5PsvbUuNGjbkHB8/Ruaup+03bok5ZEQwSdsf66Tzk7Ii+JyFjIGVC2j9F/MN4aTDyCFaZmMNLveszkyK5pVNvIa7vdoOC2giAXCs2IfHhhIU7a9/FqRUU+WICSRnOfCqWhPLjJrVmvqo1zuKmRnQNDD1HNjVExxKJYZqWDY4tXcGBPdsMiQkRU4J7CUAtlmVPJbYP4shbM03mxh5dMpEndWDMzN+nLOZ8
 iSFH4gTv
 /MfCz7uq8Fj/4NS1lRnhaxKQ5KI9T6GD+1I0j/dHeBzSrAMe2B70Bz7mOXk0hgmkTWqtblK/f9kM6TiBHpiRQntZd8DxK/GaxX5goaltZ/Q1Cpzed1r83Oh5AOVz4nOUHMakdYelTxbRGdqcuqzw6jT4UcGFXAry8YnPNtqMSZmfAd4A3ERNyLHLDVEkBsuzp98/UQe8edcV/AwMRn+2Hu0Zl8FkGZPOGn5UsYnamS/EkA/hxXVQTw0gRR05TvlAlii6/ZRRL0eEBqSmVW6yU68mvfLMhEH31HsZ2X13Vf5bBCF7EX5T+j6yi/AeISjdPUsR8X4SgZmB8s1UDtPzYo2iFHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 12:34:04 -0700 SeongJae Park <sj@kernel.org> wrote:

[...]
> Knowing how many compression failures from the crypto engine happened so
> far, and how many incompressible pages are stored at the given moment
> will be useful for future investigations.  Add two new debugfs files,
> crypto_compress_fail and stored_incompressible_pages, for the two
> counts, respectively.
[...]
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3c0fd8a13718..1f1ac043a2d9 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -42,8 +42,10 @@
>  /*********************************
>  * statistics
>  **********************************/
> -/* The number of compressed pages currently stored in zswap */
> +/* The number of pages currently stored in zswap */
>  atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
> +/* The number of incompressible pages currently stored in zswap */
> +atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);

Kernel test robot reported a sparse warning for the above line.  Andrew, could
you please add below attached fixup?


Thanks,
SJ

[...]

==== Attachment 0 (0001-mm-zswap-mark-zswap_stored_incompressible_pages-as-s.patch) ====
From 1d41d75c47a6d3ef3cbf58636faf2b4dc04616ba Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Thu, 21 Aug 2025 09:10:57 -0700
Subject: [PATCH] mm/zswap: mark zswap_stored_incompressible_pages as static

Only zswap.c uses zswap_stored_incompressible_pages, but it is not
marked as static.  This incurs a sparse warning that reported by kernel
teset robot.  Mark it as a static variable to eliminate the warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508211706.DnJPQQMn-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5dd282c5b626..ee443b317ac7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -45,7 +45,7 @@
 /* The number of pages currently stored in zswap */
 atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
 /* The number of incompressible pages currently stored in zswap */
-atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
+static atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
-- 
2.39.5


