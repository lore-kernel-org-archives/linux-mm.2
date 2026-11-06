Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C19F606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UmWKc631
Received: by kanga.kvack.org (Postfix)
	id 769366B05B4; Fri,  6 Nov 2026 12:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740A06B05B6; Fri,  6 Nov 2026 12:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656EE6B05B8; Fri,  6 Nov 2026 12:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4B96B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:42:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C048B1C21CB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:42:31 +0000 (UTC)
X-FDA: 85405413702.29.35731EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24F4C1C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:42:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmWKc631;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793986950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+q4fBaayeFFlFMq8uGMRkJxmg9BxhSzj1XcGm2+OXbo=;
	b=NcxeO32Un061ZxV/qJkjmU5/gePR3gdu7aPy+AVO8lfUp2ba+zSj5O4oXmm3IZnO9e+yfF
	sUBDgHC5CkjL3whd9n0STTqkf0PzGjIv3LZzMRaJnMfd4NcYNc1msZ38mSNF7ujQUbHuKz
	MVce0wTKEmPv2TsiJBCss1Ctc00++w8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793986950;
	b=kvc1/HoQRy2gL9D4rjv489tT1Mb3Z7WkN/i+0/Kj8oPxhvP1Abzt6gbAlAMrdCZybq4D0R
	aLYi3fIsKztmUNKM4irYA2F0bo+oJXmkAKfVlxxYJW0HJPKtn+ZLI0aWzUI/UUYO/B/EfT
	t7r9BEadFM2zpOdGwJGEV/APYq+boCc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmWKc631;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AADA43830;
	Fri,  6 Nov 2026 17:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0F41F008A1;
	Fri,  6 Nov 2026 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793986948;
	bh=+q4fBaayeFFlFMq8uGMRkJxmg9BxhSzj1XcGm2+OXbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UmWKc631vhsumw1+vJW8p01VmsJppONkP7+d9n+c7QE9cbCuL9v6MhyWuCBuVtIA8
	 yypFhxl/2SHSuvD4CVkFGQesEcEhZO5HjxsZC3XrWsPRRmom/QtNGIg/q1wDaCXdHu
	 BBUuItdKUysyzWtUrG+dxieJ9HK3OjlSC1GlnvkWiUnZndxhiaGDETZROxPWf4aa5Z
	 MiOJqckFCt764nU6j8YQ6r8Dr7STofUYda3xazb5dCE+SSo4YaU6m4jUzIKqX5zZJ8
	 WbeogzAp0LyGLyWAmUFkR6T/SiJsU4MTKBR0TlDui4AGXycpjjVRTFOJ1Pp5er2byu
	 sBdCo4xzbeRKQ==
Date: Fri, 6 Nov 2026 17:42:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Gregory Price <gourry@gourry.net>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/vmscan: consolidate promo vs. high watermark
 checks
Message-ID: <au4REhIF64b6TUms@gremlin>
References: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: j9sphtqw1yuy3x8mye7thabskzgz7fns
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 24F4C1C0006
X-Rspam-User: 
X-HE-Tag: 1793986949-513555
X-HE-Meta: U2FsdGVkX18Vz7upTJsYN7+MEyw9jt7mUL61irg4JJWEHSrpcWxhBo/vjjmDH7nDGq16hKlc/d5oKdBhGRgsq46Eknqw8p+VYotm5trHjMtIkgYkGhzYYLpjyaAzQdi5oq3Pq3LWtwVFAz32RfxtETAKMDemrXMZ+63yx+C32Uu7OGM0NL+scxxF4jKrwLr7xPFwUz9oItCGcwnyAymBvwLwFAFbIRqkkqp4aTZWR/II8GMNCOQKYn2ykGvQqsv2SEargL2XbXvvX9OWeJVVrO+hozYTvrrVmt6jPduoYizLlY1l+tU7eArrHLsUhAKSPu199zUcwuQBjJVHT0NF/cJw+32xBL7bTlAOzD4SnfxtmhPW7ueOT+BcmrZ8tjcHxMjoVhCwsXssSMdb13jJ9u0x1byA1kfR37RKjh66/ni7V3BsvCWCKP+07rsCZ9Bc2QnIG/c/ScC+ukpqYMe7bnQCLXDPo7n2FDAz4dA55ViZOuY60qQVLWfb0VelsjaKej4udTNsVCydEHGqoE/KeXrmZ88AgcSi7C7/KzgNr0Zm+RbD/27DG9/aIEtQWoYgw6qqwhAPWSVKVcaKDy1t/h5RkejxDIbd4DJiZNxheUwAnJyTBOZhhcG/bJWRlULoauyui0Bo1HEayTuJkF/8m9XVHKdqMmvy0EPtStoOAXSnK5OQD16cavg0w00tMwHg6C3jliklG6BUr9UuBSoUVxC4pfOGYAdvkqNBT8zfGSj+03zMuStF4WliBLD59LyTu5VzA0vZxjBsgyAcRmqJm/ZXwKRBVpecMGe/ejJWTz5vywolXvA03ElH3psIzERBV0rIpfaH8qSrQPR3gaLikDIGiAfw3x+wPghZOcm8W2opzP35nQ7KXdwQ6tyX8+EVnJKl23+hRbvVezux6B496a4BXr8iyNMqevkdhNBOstvoJIh7odYZ9vvIJfxnjTmt8lRUByfUYq9iy4lrAug
 xMKEiZ4d
 vXZCd+P1Dy/OHCPVzHZPRgCUOt7G+59XWomYDBazNadmk0oO9qWUPhSctdeRF+njWL01qFQ9oUu9q7iuM5+0SJNhscgCcSrvxhVKEbsmUt5GPfh6+iM7IuH2Zpyi/+qcqEJ6LOfDAdC+vzG5AUm3cwOaul2+rZHrLj3hp3aCFq7kf9bCEG/YQ4ESJ7zOFrougZdCXn7pb7jgfJd+A/Ksk01G2zq11sl0rifoIPKzwoaHkFxYtWpqp4fkdqnagf8BBzZpK9IPFmmGQKOlMBq1gMRfaYuAmEmTQPvEKQLX0gacmzLlgKoncV5YEmQ0ZnUsLkWYf6YH6rsuVsdRDNQt24nnQVgnCQMuv05w/unKL/0/4uOUJP6vH0W3heg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joshua.

Please send patch series of two patches or greater with a cover letter,
with each email sent in-reply-to the cover letter.

The easiest way of accomplishing this (+ our preference) is to use
b4 [0], otherwise format patches like this:

$ git format-patch --cover-letter --thread ...

(You've got 22 patches landed in mm, I shouldn't need to say this :)

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

--
Cheers, Lorenzo

