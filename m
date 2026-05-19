Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F01CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360F16B00C1; Mon, 18 May 2026 20:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EACA6B00C2; Mon, 18 May 2026 20:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2DA6B00C3; Mon, 18 May 2026 20:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 032DB6B00C1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:17:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 999DD160115
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:17:13 +0000 (UTC)
X-FDA: 84782254746.03.DCDB121
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1B7FC40002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:17:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TUjWG8Q9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D81K3docaWG/x1qpSjLt0Au5m1lNY/N2gbUzybeQj9U=;
	b=H72gTtn136tzRQy+aaVSgN0HmZEZp+q8fd7n/UMCEBemNQf6RcslV7jzLsbjwAGuoC3j+r
	MTwwsOjk16moXO8Ig13TQzR0FBDzzBWklk6JX0k63A6JG9qIJV/BRxv0dx1rKjvBq36T/0
	2GhZdlZrFVLs57cAnWhDtSiil5X+d+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149832; a=rsa-sha256;
	cv=none;
	b=kjNwcsE1PVlv5xRBB2957LBLCTJvXL1b6h4BkOk21k7f/aAAbl1igS2NdBRMy/83oOd6+S
	9GjhDfE9TJ+KrWqEKhiboUnZX6jh835GwXqh4cW+1VG8GCxPoAHssvWRTlucShI9luvB9D
	/j5R/zBLoRs6J2uWvfB1Rr44/2ed/bY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TUjWG8Q9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58176600CB;
	Tue, 19 May 2026 00:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E85C2BCB7;
	Tue, 19 May 2026 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149831;
	bh=mxj47XeUru82Pt8pJLXY53mHkRiq7hhv4CRlGK/7boc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUjWG8Q9IZC2UVyUGXZLtuyJapt1DpiayMo95tUuaJqADSEPmFRR6ncWdoX128Hrr
	 HdXVxjLRCd0ugRtu827ZGvGiFdI0BuhNYHvalrXtm1asqbysmPjS9/4GslKv9xRTwU
	 3/Z+qtMpBh9EeSrfMKoNX7+yzb8M9tcEwAdKkjEroTvTU3KpRF1x8/nN93rC9zjEHH
	 2o2czCRoJikBmL/UfCVe5ookbOUyjI9Pjt9w+lx/JPvzxofklUuogJwY3rvj7W9PVx
	 Z8bezuqzz/JkmZSX6Upinw8jKDI8Uv4gJvDeeUIA9X4kUyiL8IXkq+d8tsIIwklvLR
	 RFqJjt6MzqRVA==
From: SeongJae Park <sj@kernel.org>
To: Maksym Shcherba <mshcherba2000@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: Re: [PATCH 2/6] mm/damon/sysfs: implement update_schemes_quota_goals command
Date: Mon, 18 May 2026 17:17:02 -0700
Message-ID: <20260519001703.99264-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518190932.42270-2-maksym.shcherba@lnu.edu.ua>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1B7FC40002
X-Stat-Signature: 3gnketm713z4waudhfiw6x418i4c4iwa
X-Rspam-User: 
X-HE-Tag: 1779149831-608195
X-HE-Meta: U2FsdGVkX18VWYAjYvbZusyIpbrIkxwb/c6Dx4GtAQ4H9Vw/2JI1dXfOI1ayC6wrUIzIOnqHbYR4DWpMg3RbUKYX0R/6BjuY5RVtjYxKq/M/EhI7Csfhql+7/MOyLpRJv8RUwN71CEpob4KBemjc0iqhwOt5WNGGu+YdLkv5R9wzUrojLUgo27Hv+qpn9g1/2tWkTsy7XVt0GY77ncwJMItOi2G/mdGP+enJ1jWRMfAA/2WidSRvxVncPC1lOKDgcwWEVugyEoyNJuGFvMfvjlDLSj4tV8p/9/epjz3BrZ+VCqTjo5kGDaKVdVtp76vp61hGFXs6NnMGZ66eLr02Z+WIiMDU8kgWSrUdd3in/tJ50OmRdLA/lCkf6Pf4TdXg9syLxSbw2DUsjEOZebknTZ7oGTmyCyXcdXe+6A90TqcpmMuxq+Y/juu3F/v3XIcaJr5o2XddhXJVz6nruV8MuoAu3AD2KdQuMo3NEuvutrRDYFQxb04KMu9rP1g/VpDuqKWXD4mIu6emH/VqBVldKME51n7cgqyLldGW7vbx5XNCdBLLdoOIN1/xM2bkHFBnP1Xv/5xoRXkN8eXS465ak/eoEFkKRpIfU7747Y85PShNn5Dg9G3EAPIJf5DIYztQsAJjnPpXd6yIvIFlHDvMheoMSxswjPzjojYLb1caUU3N4drIDF60JJYwcivc5RVG4G0cg8y8r7w8ioK0I1AqB9y0pz8obsWPOb/Gf8e/2+GETQ4G9rRm/VqddfEvsC7PkyQlf1mtogmC2DvIsQRU3OVjutB5ATZ/2pNZK14Ti7FXYuUxs0tbmscEKGazef6h4+DUwI2CuqZ7Oa8ybdvr+9TUkF0DEHPhqFzu68BWQdNLE0MJcIKumEzN91v3GiBSS1PnLgZGPoHPuvvjbobzajHmfyJ4v8SAKpQ1qJ63ovMaKuq/7oJyvruHZBd2zL0KvMHxwDRUp0XQKjUf5Hr
 rtjZDA5s
 EtKynbo+FicgNQVjohRI+E13lT1qD3BfRpdcs/X/wT8n///a7OdgGekneCAswgmLRlv3ZGVGU13d3M0AKFkL7NAJj5xH7ZxHStdIh/SAgKf1IaheGU6e+VsUjFDyyktIVCmQgUndi4TntQ6UpLIVM2siPlsbQzZoxB6mblis8noQs7g5xok08FtIA6S02UPagFEgy5eKGTvLbM+YDFk8ydaRRv76qnkpdukwajR3spsZ2intX8HgY4rzmIUI/g1VdffvGyvzeVcSph+V9RwT5gu2DJYkAnjY8e0arSSL8WgVHB7gFGEkCgM5IWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 22:09:28 +0300 Maksym Shcherba <mshcherba2000@gmail.com> wrote:

> Add the logic to copy the current_value from the internal
> damos_quota_goal structure to the damos_sysfs_quota_goal sysfs structure.
> Introduce the DAMON_SYSFS_CMD_UPDATE_SCHEMES_QUOTA_GOALS command
> and integrate it with the sysfs interface via the 'state' file.

Could you please further elaborate why you think this change is needed?  What
is the expected use case and benefit?

Seems the following patches of this series depend on this patch.  I will hold
review of more details in this and following patches until the above high level
question is answered.


Thanks,
SJ

[...]

