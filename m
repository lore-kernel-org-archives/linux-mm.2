Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB49CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F8A8E0020; Mon, 15 Sep 2025 11:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5002F8E0001; Mon, 15 Sep 2025 11:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EFAA8E0020; Mon, 15 Sep 2025 11:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 289648E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:08:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8343140609
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:08:56 +0000 (UTC)
X-FDA: 83891817072.23.BDB83CF
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1EC5C0002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:08:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BTgghYaf;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwFsPBiwikLgXGeg1StWERPB9X7NSPvY1FsUVXJjxOU=;
	b=vAA09jai4A+bHyG+QeAe25t+Geo9sIlvFhigScE+vjtQzGilQkf/YvDwrM5j2YBC9/V4zB
	yKtRpG9vQpAjiOxIrIZ77qSJ9a/LM6f6xup/Us0DlmU5BtRh4VUF0kP3RDpQhSO7TpcJ2b
	XFw7tHgLWNJ0EATABd25vGw7E7FJox8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948935; a=rsa-sha256;
	cv=none;
	b=fA6YEsh9C1d+cer9kS6NwAbJhE+HXvrG9nEJCURDvso0651GgBTKCjwVrt6ErAnumwz1a6
	mp2Tj/J1MPTYB7+N7IPMERLGBn5vTJznKz5rdMMDeZmr1qhAP56QmTh8walsK2zegxoW+2
	TES6yaQUzbjwAsqjqnzqoIkCeN2wUPw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BTgghYaf;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-72ce9790acdso37590207b3.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757948934; x=1758553734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwFsPBiwikLgXGeg1StWERPB9X7NSPvY1FsUVXJjxOU=;
        b=BTgghYafixJFm5TW1DKjc7I8kk/7MzRY8Vvxw0H3sUe206EL712XEnL7LHmeNtXFUA
         z3Ujh+ZW949eVVn+ZUAeVvMyq04qg7oz0xbenQS1gGUHk/Ws7IXFgw9vczDi+s0vVBU+
         kA+DhMCpC3OLhNv3Sduksvc1jQs6U3K2ZT9991WPeF0+NgCknMpcSN+n75+CaS4W8okx
         dPtb2o8l11C80P9jFuvkEUk1MJZASra6a9jwxHE1OkNceAncSTEZJpRkAyTJ6jtmXGAU
         G4USG4yaMg1vc2PuzbHhs0Y782iR7ZyBZzxgUpMkjzZKoX9QdKRSajCNnDFjevyV5dw/
         jfEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757948934; x=1758553734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwFsPBiwikLgXGeg1StWERPB9X7NSPvY1FsUVXJjxOU=;
        b=euDz4phIiusE1bxXS4K9S8YnQRBGxy1PjpX95Ab53sPk/f/LuSg1YSnK/pMlE7XAcL
         QgRxrFv+uF6BQ3ESiZr0ly6YsugBQMFtS8bRM8tzc9cV1/q5GTRNw/Sk0BAFAD5oV0V0
         D/jgeAIoL5NXAtIReKgdutypdUGTooWwwsiz4hktGi8+d31nGvSPyb4a4hs5Ur9xhrJC
         sKRB4EAU5WQlcW4vDz3vntta9g5iywy7TH0nGv48pH2KOaluH5xnzTWj81L2dw5++vyA
         zjBagHc03Jdm32tjtOAC0vdfwy1zvkhqJ+TorDBo58LM6SXWuDFZTVdvA54JXmJ2FP7p
         rQrg==
X-Forwarded-Encrypted: i=1; AJvYcCWbTM5K1ELmYvJ+1TDmXqbwZIp6n/xgTEoLoAvQNIu994YTGZHoEKcciym2eB5kw+Gs8oxy+lRiwQ==@kvack.org
X-Gm-Message-State: AOJu0YxsToBGRzh+N9Z5QOHeQ54dW5tLHlEBAF65Jsx5sqX3sQZ1pkzh
	X0vHU13k1fOTaQvp6LTU56b8DRic7wyxdrPhmsTuB/50Y5y+laiztqpC
X-Gm-Gg: ASbGnctX1a7AmqEZcpCzzvNjUYYnFSl9Owz9clexcEavyIhL5E1uPHey1xWVOUGYJoZ
	DDxwiKWjnFnoFoRF4Kj7e2LjQIzknSXiUGEHQD29q8trvWte/ry4XRMyFKaqX1BgDvrx+0wRT8V
	6h2+9D09A6Xtq/klHiG9pVfLzKS3wklxemUnTD30LBXjDQCn51dG6pgQWdPCCPdr7XkFhoNsnRT
	/OMTDZFj/ZYA147aO/CHJ5YmyW6aIe1nQuKiEYZTd1dRcmsspKMNPTFU/+cI3fomOcqpM+K6vZv
	wMY8VJz88LZ/kkmN9+RquRTK807+vd/fUzsvgTkxWsBjtNwe3lZNGgKadxwiUBCkRm5EQG7pL5k
	AoniGN8b0uim1vMuh6+m0ZU03tlQeJvTXPD308TZTjRBAs7aRYluzUX1Klc6HdAMr
X-Google-Smtp-Source: AGHT+IEoCH4/7SidphYGS+MZaTfXIWw2+iqeHbHWYFRR44N5J03EruPqOb3s6H+Eiuaqun0K37I/aQ==
X-Received: by 2002:a05:690c:640e:b0:732:92b7:8b88 with SMTP id 00721157ae682-73292b78edfmr55749467b3.38.1757948933883;
        Mon, 15 Sep 2025 08:08:53 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:59::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-73453627ddcsm8002397b3.38.2025.09.15.08.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 08:08:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/6] mm/damon: misc fixups and improvements for 6.18
Date: Mon, 15 Sep 2025 08:08:51 -0700
Message-ID: <20250915150851.1508878-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915015807.101505-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1EC5C0002
X-Stat-Signature: h5pmi47aahzu4pfbtsu7ghquycyn7nnz
X-Rspam-User: 
X-HE-Tag: 1757948934-92444
X-HE-Meta: U2FsdGVkX183C+RdduajdzdxSvZxY8tXcq8UXMJwVgSn3vunzd8uiAU16MkWtep4JA2w/R/L5Alxzm7w2D0K6LnXGQHbmjiOvrocO9pC7PjAdXt2bo/8XzCSzR2I5wZb+xW+rXiP0dRXAAri1E470CyLuW3JCWo+2k/CBRUoqufygPpjbjTbqIefuc+5ptSQtx9p29yxaLP7udgkalSCjuWS6VErmaUBfGAJp9sPSLuu/vZaiRCVllURJjXpH6mXnAAQzxScAtMisPSuTmVE39/iTd0DN9V6uTH8o7H6SLPe3wHOUSTLMmV7ZgrWHsNh4ofG6uSC0pvmVWRo7kV5HOulXtfmD8gh3DkrOS7sZvLY7r1AClNiPdRFej24p4X11aMlglIqn7e0+yHezNXZbmWrM0nKUtjy7hJS3mJjbG2BKqLE+DWeYRBjhQD+dPReve3vp9k1tSOQIXDzCa/wVZt4d/fGsb1S+7zKdxHBZAEDCE+6KIdEVAL6D/lImRlgXkbY7Mfp9Yk3RDP/LIa9InaMDKpZL8Tmt00jOZNqeI5fBXAYilVfRGZhnNnV0jI/Lszd/t+VN5x9Rq/xxs2sR+9QgO9iBRf96JbsmAS/Bek9Y0mSLw6KqC33yKMS5YUd4t0tThBK1Kr/RHjiQlgem8YCtbmTjqXU4Ztakx4MwiYzJROfnqsWGGMrpdBPsbHYuCZW9PmhBZcgDXWS853Y/RWnaoAL5bCBfSLp+96vARNr80HaqFWlGBkCI1I4zbKIHI61c1DNRLAy/1G8cwak5rgwMJbaW92wWI7o+fsShIDQ0RQYRe2TaytZ6Hv5X2cOHC21/B1w9r20RC4xrl0C7oilWEeihAWBr4kz1VBhM5tMdCD5U28lShWMbdwHIYrvChWPMDWDRHBSr3bMz5DzH75KjTmgMqZGXdji0omG3B4f5ZKeNLiZ7z6GBAoPCS8IVhUxpWuxz4bOH2Txcvp
 qmhR386z
 seRn4CZIyHOGOVF7Xrtgqy5UKqFyZxy6/SnzIES8DMNpmhsHI1dYKxArMxMpZuuft9GkVqXJ3lyJPfQsNbfo/1vnneQCJLJwtbQ2N0/oLSbcXrjVFzqGdO4mg9Mn8RUx67g+LzlEwhHeSH/ghrRsl1nmJ0cUIs5c0t4R9fqWscEydf+jqXpEHsg49EM5mKpFF/f5ZmeMKoHOIYiJ7513oROnd77Nn4OiZCg0bIqYY8YWnxnoiJAyIh0/eQ6WfuBK2mX1vlrr3nipA9nkZl4W7gcC3Q83UN1y/N7pbvOfNl38fNSrcpA+cxs1rFKhBnyCXHpbp/SwGvqdXk1TQvuKwVKhiMzL/8gXVKcLwHxm6q5jWnTjftjBcxWco3i9QwbNvO0MOuic/aBUB3a4S7aNdNCU/vf6pStiJDL+3+gzzhpA1NfOwWJaYuWwmMzMfOZt4kFDrMkuZ+AV2Kt+W562Qoedw+MXCOvJdZJAPitXCYnfGDL/oOyEEkpAEAHO1lp18M4Az7FVvycIuD2me2XuIw7cEkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Sep 2025 18:58:01 -0700 SeongJae Park <sj@kernel.org> wrote:

> Misc fixes and improvements for DAMON that are not critical and
> therefore aims to be merged into Linux 6.18-rc1.
> 
> The first patch improves DAMON's age counting for nr_accesses zero
> to/from non-zero changes.
> 
> The second patch fixes an initial DAMOS apply interval delay issue that
> is not realistic but still could happen on an odd setup.
> 
> The third patch fixes wrongly written code that doesn't cause any real
> problem but could make code review confusing.
> 
> The fourth and the fifth patches update DAMON community meetup
> description and DAMON user-space tool example command for DAMOS usage,
> respectively.
> 
> Finally, the sixth patch updates MAINTAINERS section name for DAMON to
> just DAMON.

Hi SJ,

I was unable to find this sixth patch on the mailing list. Maybe it got dropped
somewhere? : -) 

> Changes from RFC
> (https://lore.kernel.org/20250909034353.7064-1-sj@kernel.org)
> - The RFC was only for the first patch
> - Rebase and wordsmith the first patch
> - Add a few misc fixes and improvements for 6.18 to the series
> 
> SeongJae Park (6):
>   mm/damon/core: reset age if nr_accesses changes between non-zero and
>     zero
>   mm/damon/core: set effective quota on first charge window
>   mm/damon/lru_sort: use param_ctx correctly
>   Docs/mm/damon/maintainer-profile: update community meetup for
>     reservation requirements
>   Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example
>     command
>   MAINTAINERS: rename DAMON section
> 
>  Documentation/admin-guide/mm/damon/start.rst  |  2 +-
>  Documentation/mm/damon/maintainer-profile.rst | 17 ++++++-----------
>  MAINTAINERS                                   |  2 +-
>  mm/damon/core.c                               |  7 ++++++-
>  mm/damon/lru_sort.c                           |  2 +-
>  5 files changed, 15 insertions(+), 15 deletions(-)
> 
> 
> base-commit: d245e17d619ea0336d50b0a6c914f5701d1b0e53
> -- 
> 2.39.5

Sent using hkml (https://github.com/sjp38/hackermail)

