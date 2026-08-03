Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92E4C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C411E6B0092; Mon,  3 Aug 2026 09:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF15E6B00AE; Mon,  3 Aug 2026 09:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2EA36B00AF; Mon,  3 Aug 2026 09:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92E426B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:49:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A17A1606A9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:49:36 +0000 (UTC)
X-FDA: 85060090752.11.6948CD1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4012540009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:49:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pyBDnvjD;
	spf=pass (imf12.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yjIW+VRJtzsg7DbnLhnMVxD+3GdhQu5Eec9BWT6UUdw=;
	b=z55P0MTK3xOYUjGZXA8eeUZzKclveJ9cv9vG8RsDJ6eUMtbMgzxMasFGQ/3r9e9AX9DD4+
	2BoI9vQyphM3a4s+/wNgw1KHr7AqqPqVMkDHy4kt5uRYsqNe/ifN1HjEhXnQ63PxlDi04T
	upCT1kCAQCTI0J3vA8v1LzKc9dLWY2E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764974;
	b=TW35yfld51MTaGhrxQXNkhrjcpeOVzuyBhGRhnoOg0U9iJvShHufzw3bWtIE8ZdaNEfi29
	jOlJyitL3e0SJCqjAU5id2OZ5S9XaiQ96rSFpqUHofHI258lOLd2NLd7e3p9cBFMVzdq5H
	9MEtyDTgZy0hnzMqmzQ5zj1d7gz2By4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pyBDnvjD;
	spf=pass (imf12.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55DE81476;
	Mon,  3 Aug 2026 06:49:27 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C81693F66F;
	Mon,  3 Aug 2026 06:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764971; bh=RDdpyCKc15NK9uw2pBkfSrDD+en2rKAJPfOEa+//Elg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pyBDnvjDoyaRYk+MG4Ev641S05Hf5gyE3GRP2/eECObJNpWEoJpix+UF3tgrxPLeW
	 shzjjcdLwOqIitUYsR5c5s1MO29/Z20LMTALuHB+BQG2Wb2zqndYK40IL0XKqr6Unn
	 Ux4+f+2YDpu/9ILumuY2Ivo7LwrFHp7wxItKeMbc=
Date: Mon, 3 Aug 2026 14:49:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 3/3] selftests/mm: kmemleak: drop stale
 min_unref_scans default from comments
Message-ID: <anCcZUynHWBDoLLr@arm.com>
References: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
 <20260731-kmemleak_hardened-v2-3-7b9689ac77cb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731-kmemleak_hardened-v2-3-7b9689ac77cb@debian.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4012540009
X-Stat-Signature: 15a59n6byzzryq9wbz7j7s41eg4cw5z6
X-Rspam-User: 
X-HE-Tag: 1785764974-232779
X-HE-Meta: U2FsdGVkX1/Gja8YSZY5JXmziH+myrwAx5k0M9oLEkQIuCcTevJQuKB0t3csylfY5YY9/xXCkMTUWEtp8b+3VUzGqOwoxjSNI7Q2Y6wX//7of/9li67I9sws9SRv0rUDTiDGuxPb5liqyQ2GteWhdbDI2JL/2noDm7eMH4z+RX7hn6oZtxEotuiaAtFtzoCm3jkOkoAGC82HW3IuvAZcnpyuWFDtjce3bEFHtg+HLoQfw7b63HfzEOcNKsVuDl41g6l5LezYtLBgLL9JmFBDOINed9y1W8UEcXD6HAbCue5w/OZsrJxvOnIdF7vkXB3Td/Leg6r/p07VUujXhB2e6UZQ/pljDxN5yBnf8Rn0VjIL1YlO+3fR4oR1qTeZcRQNecK/YM/HJTUMmGoHiyv4JShhAh6Ddso/zZ0Hgw6fwapV82CKxhmInFVtFd1DwejZiXY0+z2kGzy6WVujIfTuMWuqPwF9wtSKDq+FriYaezx3GdLXBDp0pq8N9nMOAyycuti1rpt1uy0heCBgCfHcFMlqZ7CRE8hJVoJfqfaOe6qtfywOEKT6GYeRLUgFUIY8a4C1NdYjEkW2899b4912drylQ8GsY+twuR0pT+RLoNOHvlR9Zq2a089QKG3W5liwbX9A13Jqd3ECVIobmO+Gqio6/GwSAjrBZzGpg61qwGh5KPLfkyWrBJLQlqnjANAM2yGI2Toa5wOC3weDPqHGFFBoZCZuopCGtOC44TEE35jxqcmCOelV/Fatpg4vaMK1Pv1t3zdznqJaNSxUE8oMU8MdUhoyO7dXFNoLnlZeHFZHqKVHnAcVS1eOV4D1dWe3wMPcMhr4v7YjVbyLJdVW/Guze0PLMbKZtCXDJqj3QRWP5OF78luIN06BL4NxOqg+BHWqCIbMLJOGUPTVv0Z+wrEXIBPYcYbleos9tGjecCPE5UZvYsFq25QJgL3Bg6JdEUfPXaldYxvOMMghZSE
 mCmNlvhZ
 mdIzIaYKnp3SebEOaUeUPcaOoI3lbKccZcRIivcPFlsMlXFLXaX7H33ZegLrAurbHr9PT1eMADw3BuhSgvL+BX/5+PY8Kwm8w4OkeDngJxUFEMbERg2MUgrkeJNM08KG5NuWtFrOVwgB+4svIApy5qSUZRPycP437bghY0T40HkpC+6bM871SvK8l+QkZs80dFWc4hEMMSWxOIb8ubgREa8SFcXx9DShV/P0+lmo2WOWiaeUFSCjYZOEm583F9rfYTSI4jKKYmBjmqdZGRzEs2G8vq82Ocf0TCzj/oNu+BjHebOObe/plk2tAN4lhg0/qs/aFwa0NIesUBvVtR6MYMSskP04rDZVD8/eBf3sr0q8mvV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 03:13:06AM -0700, Breno Leitao wrote:
> The test writes min_unref_scans explicitly for every case, so its comments
> describing 1 as the default are both unnecessary and, since the default is
> now conditional, wrong. Refer to the threshold values directly.
> 
> No functional change.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

