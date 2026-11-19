Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B54A606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P5iT/6Xv
Received: by kanga.kvack.org (Postfix)
	id 885A76B05B9; Thu, 19 Nov 2026 02:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836CD6B05BA; Thu, 19 Nov 2026 02:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74B9B6B05BB; Thu, 19 Nov 2026 02:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50C676B05B9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:57:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2F4FA09B4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:57:04 +0000 (UTC)
X-FDA: 85451112768.26.8585963
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3959A40006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:57:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P5iT/6Xv";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795075023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GC19D8QX3e0BMtqC3RPLEBVs8/GW0WZwei27hG/CDHQ=;
	b=0wCL4wGYVhZrTVBOif+3zBwnCgXp6MP54O8aLErKBQTqnymWMGB+yZPjMuYxWdEFKfDpqy
	+tFH3XPcVV5EeSxlUy16NNMG1msFnr/hoCBdMaGPUkR16pVP2kivkZ0UixvaKIAUdJaHmy
	O1JYmcv+6wHUyWOGlPgiuYg98xz9zW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795075023;
	b=dWm0zGCc+5L/vAvcZsSaLnqR9rMDR7jH7I8AUCjLCzuIVZ5ornKSDc/+Nhnrw7c1y16jrd
	eD15JdfYmyJq5Ndtjwt6eaDanZg3HqL0bq4meemUzjeT8sAemvysHTllm7jm9TLK5El1K2
	9BkSwpI0CjSP3dkNr1xAb13e7tyAEdk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P5iT/6Xv";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2C41625A8;
	Thu, 19 Nov 2026 07:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186F91F000C5;
	Thu, 19 Nov 2026 07:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795075022;
	bh=GC19D8QX3e0BMtqC3RPLEBVs8/GW0WZwei27hG/CDHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P5iT/6Xvlz2DiMKIeDEjwktDfpIisglfro6uw6YzeBybw9KYw0q9HUASRGPCx7e/x
	 yAE/72ZGCybiFkav/cusuFOSAbJ7+rDCbQtZg0P7x4hURny1d46AM+RLqu9cCBJIri
	 GuIZCnVr1CeM5iZcae/uj5K9tcRwdYrUt5mUZbl01/DQkzm6WBraMxkJCDSkF/sy8S
	 YbkjMlaRafiV6MT5KG8usCCfhW5VEPWzGWBU5b6r0JOTPb30TssHhco4Whd8IgMbnS
	 a834awNrlhg97f5/ZA8Vnw8SQzOsrDxiNLfzfLMpHpsmkxvmsjQb2aH9ZuEoC32Jzh
	 OJcklxorwNEYA==
Date: Thu, 19 Nov 2026 09:56:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 6/7] mm/page_ext: inline unchecked page extension
 lookup
Message-ID: <av6rwy2ysqCVdcC4@kernel.org>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
 <20261119065812.89959-7-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119065812.89959-7-songmuchun@bytedance.com>
X-Stat-Signature: jrsnzgyeko6ysxbi411szr5c17n1zkun
X-Rspam-User: 
X-Rspamd-Queue-Id: 3959A40006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795075023-777044
X-HE-Meta: U2FsdGVkX19sr3IWPl6Y5fMfMdkgbPFLCBKoCo8ljO1ZkxczMQqwcb/wGnAKNAIn8OahL91oKFHigbN99zPcDGXXJoFlR5xhElI3P00krPR+SqfI9KpDAjNVnQj4shpZ59K/iH7o9qI3NPlu9rZ8jUUNj6uuGvGta8Fiptt/qYmdKbyrZ4c+4Sgt3dTp87N+OmYYpHzup4CTx5ErTKcFPVv3fCEiy0C+mPpAdUBhVidj8zkWoI7HMavmpm43CG03rtF3NgnOq4qOq6PbJ7ed9AzwPmz/gczBVCnyiTlQO+kNWBFqRCEY8fOgUbAPms/ECNHcnie4WNxezMpqnTtklt5NmdYreDyht0+WSNCNdVydsLz0ZyeO1tQeYDIT6Z1J6Vul34B1cOdX5MK9NX7uEUtd1Q1qdkZ3YPU35Lg1AfRz4ntnM2FfsxgCCKxfRNouG0aAmodES03FzRY1RKaNJHssIotmLFvLSHu7GMYoBdJOFYRwJ5woyQLC3HpxlS5DDfx0lCk1O9AC+Lo+4CmIEZr4bqLbMGv4uMM2aslIIxPmn0OY2FPe5mu9jRcnGbR9BvWgCrhtMZTmhFwZgy3u6E7hD2dyaYf4Od7HZ0XcvvP+hVnlA9huaphMtFfTpRhrXuE8MhG02Rx8mZsl2rrARpmQkBAwQedoGZyLsWsSUo36sdo+vX45bVKSnZgpYbHe6JCJksr3azbx6OMeupcBFq3gkBitJThfa1dla0NnT5uK5Cbth19BNCqHZNlEcOIgieBJxDvRJGoj32z4qOPknIG+KTj6Uo8EjskO7G2Fe2VVDzrKg2tiL8fZhXCEkoyXtdPdCzApOVULpRQJobZfz9bFT8B4myLAeKYO3CtkLZaLOK4R9riLQv5apSF9WTuPXiX814osIoCdiJW3bnY1zz+8Fb+hGNxMVfmoh6ww448cH4Y1mEM/Iiw+WBRra/C2y/LUMe36zw6ZiBDaO6i
 1Deap4Ah
 03cImkAcsFTDqpe+LKWtm/eusPWYVOYieooDO6u1zbl4a2hDV19gjegfMZsqzpUqlwn9qUbxVZ2/W0fZvQRpb6NzucKaA0dnCZr8DVF+VmEL6rndZUa272wdk8RcgM1SOboEX4ZugJLNuf9Ow45HG6alkfNI9ihrInbOC91sop1zPtkSefHjrUcp2+WYnNnOOfTrnCM9NvKxa4iBPVSxp1Zw7rt0gjYIM3EVj0vM/bfnhLcgImhsqzMm2bQQu28U/2ydtd4PnVPiwAypq4NNpl+9YApXbmwKa7iO2RU35QRL48Ctc5Y1d6OsyDx6FSvqMtrmUZo0q+Rn4PuCBmhcIj62VVcp29eUi1kI/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 02:58:11PM +0800, Muchun Song wrote:
> The KMSAN runtime needs an unchecked page extension lookup that can be
> inlined into its uninstrumented compilation unit while page_ext.c remains
> instrumented.
> 
> Provide an inline lookup for this use case while keeping the existing RCU
> checks for other callers.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v3:
> - Collect Reviewed-by and Tested-by from Chris Down
> 
> v2:
> - Add a preparatory patch that inlines the unchecked lookup (suggested
>   by Chris Down)
> - Use a PFN interface to avoid architecture header-order dependencies
> ---
>  include/linux/page_ext.h | 46 ++++++++++++++++++++++++++++++
>  mm/page_ext.c            | 60 +++-------------------------------------
>  2 files changed, 50 insertions(+), 56 deletions(-)

-- 
Sincerely yours,
Mike.

