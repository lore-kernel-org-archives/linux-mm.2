Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DCDCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D631F8E0006; Sat,  4 Oct 2025 05:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A638E0002; Sat,  4 Oct 2025 05:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76BC8E0006; Sat,  4 Oct 2025 05:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B565C8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:03:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3435A4561B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:03:17 +0000 (UTC)
X-FDA: 83959842834.22.1D5D84A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A94B716000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:03:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M8EWH0b+;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759568595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAmil7yp8OGbUbDEy3MdZr3JV1nJg7Ok7ksY0e7fU+c=;
	b=2ZxFPQOJmxjiLD1c/fEMEADuqYOEAClqACsOhEuCsJSIM3yuvuupfRjX6BbsfE/V64qHiL
	rKixpxlRBdV6xyftGQbV2Z+8JY7D0Z7AotbnWF/ykYWBdgwyoDLSnosA1UygkqHIMR9PKr
	czaDM2y1VoNiLCT7zqA0On7VDj6gXhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759568595; a=rsa-sha256;
	cv=none;
	b=GvxKqVHFy98oUrmSk7iW38mp2+OLmn9In+XRsDftNzN/T+fNLyBNx7qWLuBJDo2GHk+6R/
	jKHqv8X4+o3ibj9K5XFMviFi4Dnkbdh3nqGZPNBYHa16KjDZgqNpVFD6lLXplX93VlYCpm
	gNRypWYc2UrfemQRSBQ16qA8jN1Vk0o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M8EWH0b+;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 987D26013E;
	Sat,  4 Oct 2025 09:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4080C4CEF1;
	Sat,  4 Oct 2025 09:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759568594;
	bh=HV8LeKjunDKSdv4Vc0T3l1XGLdhhd5UaHkHDYrZJLzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M8EWH0b+klPlJBbx7UYfq7KtxLRlB50sGCp0ZifD7Uj7ndbIBOu4+wH1vbtN4FeJ/
	 QKdTBDtTqwoNQmAdeWUpUrmaO3BNhs6Y4UdXYi5Ujbs4BKjvtHCABca7bo5+dVKzCw
	 c5kJV8nD3LHiUHTE1E+S8ddMZlWnwBqGiU4L7fKzPKhNjltKcZF7rcKEId7/wvMTWv
	 o7EFWOooK1FWx16oLQInjVTpiVN8ehV/UDmT9gSbwUcod/c2dK3CVZtGisOXbKrAgj
	 jgsRKSaiVivXrXTSnWk4yZmyYDdOyKV7cehPpOEb0Mvr+dYPJLMfS9CncBuCAH4eDd
	 Zrgi/65wP/ASA==
Date: Sat, 4 Oct 2025 11:03:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Hillf Danton <hdanton@sina.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in
 drain_pages_zone
Message-ID: <aODiywgXvAL5Ia_8@kernel.org>
References: <db51bcc5-aaf6-4cb4-ab62-fed9d40d6caa@suse.cz>
 <20251003100245.8029-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003100245.8029-1-hdanton@sina.com>
X-Stat-Signature: nbakphmgq4je36aof5j1bky1bpnqooej
X-Rspam-User: 
X-Rspamd-Queue-Id: A94B716000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1759568595-213254
X-HE-Meta: U2FsdGVkX1+Ne4jFQWeXR5u4aAuM/vwiWnAKQ+0U7JS23eeChkpS2onBVWjKWEDQZlWHuZDaOqv4iazxj5PmNj+3+8zgQZcPBhcDAOqr9k2bV7vcnnqhnfLmvDm3oVc3jRx50UvmKHVzktWA88mzE4OKkdDMJeGvpAW8EL4Bb9aCSdb12SeZAZFAnBiPXcUxIlYJVAj5SWVz+ZgVYuHvSLNrkJS4cvnNUKVEYBA4DnycFKuMXRUUcWUe6W3Qxk2AxcGdNFpp6iWp+HCYC++I2sm89JmoGnERN4wKxu/WdFF82APUFrDfG7Lqb6you60euOi/6rq4EPT1IqmxY8hHTQv9RfhK419aGAahaOgSwKHexLZ4Dh8BNW+jtGJTksHn8OnXwyo9WwF7xQDAfmC6LKQRPfFTKX3Il33t8LD2dF/7vOZx5+acVA2N0pymmXcmiuH8YNZRPRnc3Qz3iwQ/VpBXPc5z/pdxOw8EW/hyLBHTZOfcHMKrFXR9JCR4vRY/2OAtFqtsGbwFLGnooc2jXUscu9chkmrS9LFjapL1f9e63ntbiU4CYm6zVcSK1SfKUoVAFi8y1LOp4SHTI43qKEd46pyYO/uHry+q0CCC0X6Xk8S2hvg+jRDpKatNTBZFuLpHZM68lCL4kcbuc/P7K8xEGZOQy3qWwry3SD3Kk9SDLeUNkNLEZahBAlT8eM+D536Da9fstsM40miXtk91hsnPJHIvKxuzV4iQ8Ts8YSg9s68cGyezCKCIMG3mK7p4fgpZQIPiCax3RQ4QtFl7qjWmELEhwcqGNMiGmMdNp6zxLEwY1OxdMrFxgqy8n2hcV3aD58en6je07CFEmT9iAZCzWYr7T3e9RpR3Bml7xuUgitDqUisw2kKuWmePvayjXVQtNUp5G/jkwD8QRGgMCyRWWi68PfzYmdpBLlZCIM/akjr+4ZpBgspfCe0NN7bYIJeWa4y0bSmNioRqltz
 WpqqlXTL
 q39p/9ndqY3PN2+aEpOHfNjvyVXWRpnofDnls+yU5iPF0RpWt6ZSPd1Y6kr68t9ZKDcC/SvXsE2ng33KcleEsBR8W7E2i1elCKjUjhoyKzk2oKWPmKNs8iBMYVx2boLSOC6yntmJwk8Zl97UcVuGP2N0IiADkr+QhjumVOre7q1jUPQi/jncAPs8DWeUvzeI95x8+IKFFWfCqlucxzov/MxfDgNHgcwtX3gNW6Z0cDY5+w8AZMM1msR1pYv3dgtzaBvjK3dgVOzo4H9wk0jZN4/rR//pPWEvgox6jX1yFfVawIXC6BwDLhE8k1egWsJiPYN0a59mV51FzIXvubMMh5uW/ANxxgIA0T+DwQy48GaFAdkMopOy7oYtCv3mL/RvQ86uyE7KYW+3pMDg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 06:02:39PM +0800, Hillf Danton wrote:
> On Fri, 3 Oct 2025 10:35:46 +0200 Vlastimil Babka wrote:
> > 
> > Also you should really stop dropping CC's on your replies, especially for
> > maintainers of given code. I've only learned in the v3 changelog from "as
> > suggested by Hillf Danton" that there was this subthread. This is not
> > acceptable. When the feedback is wrong and uncorrected by others, it can
> > mislead the patch author to do wrong changes in the next version.
> 
> The Cc list was cut mainly to avoid getting guys interrupted in accident
> with Johannes Weiner still Cced. And nothing more.

Please don't make decisions instead of the maintainers. Cutting people from
CC actually makes it worse because they need then to spend more time
looking up the emails they would have got in their inbox.

-- 
Sincerely yours,
Mike.

