Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6024CA5FA4
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D8E6B008A; Mon, 28 Sep 2026 01:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8270D6B008C; Mon, 28 Sep 2026 01:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEBF6B0092; Mon, 28 Sep 2026 01:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52FFB6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:19:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5311A120B5B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:19:16 +0000 (UTC)
X-FDA: 85262017512.30.BBA6C40
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1FC5AC0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:19:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pWh+GUF3;
	spf=none (imf22.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790572754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wXI30xoHEFIzp1nZZ3HcM6IjWcoLUOaEIDAeAGQdHQ=;
	b=lcDAURaGx54KL+BBxKqzvqpTif9DLQBUwRoGRFyUvzb6R5YaXbuh3VTJN2LdvSSbJWTaG4
	vDE9sqdhll8WCGuFhaM+jYSUg4BIkfoztq7A+wcbS3fqzJITdZZKZM4S1DWp7byaA90IId
	U2k76sR+LtqjjA2hxNSOHXodej/gl9U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pWh+GUF3;
	spf=none (imf22.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790572754;
	b=OAGAzPrhdEmCcdzTBvKRZTCiQWbYoEq/rDDDOjIjz6w/5rAr1PtA8PCTEh7oPkLsHaWLS7
	+bS7+jsk/HiLyqPMCnFEr4LlzNeoraH/6gziDcpmbIUZPPWpjrG6tu4Hl7O4XUfzcRfSpe
	QSgzQBEYVpb4TRflL6Cxggldz4mskQg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9wXI30xoHEFIzp1nZZ3HcM6IjWcoLUOaEIDAeAGQdHQ=; b=pWh+GUF3s5/CFkDVtfkmZ4JgT7
	GVKHQROAkdpwQgH/mbX0zjcaPdKpCeEU+lSfrTXZ5wxa2ofozHMrRK9THFiYZYtygaX7Ma8a6mnIZ
	zmcJr4CsJWiS7umUNA1bYo4RQ830IaTVE1xcmPSc5XHX44c1KUs2p4A6E/GcpEBW8DIlzzqBWsCMd
	vX57SjP0m63bp/8+9uw8ZwQzGqa/YMe5GXcKZ6mphGkpLohZ4vA80mIcUnRGrDKrHz4aEFiL0G8/R
	jeyk8Q8UmR5ulxbTM2CUNN9J8u0iB2JBIEmsXEM60WFfysKhCvJSzzJqh1dgDafNh15/jwd2Fr+Ku
	vf+IJGIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB3lU-0000000HLuk-0rJd;
	Mon, 28 Sep 2026 05:19:00 +0000
Date: Sun, 27 Sep 2026 22:19:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate
 offload
Message-ID: <arn4xOIxFRD8qY_x@infradead.org>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1FC5AC0004
X-Stat-Signature: mjrjb4wyqf85ce3auf57aw7tshjizp3n
X-HE-Tag: 1790572752-113909
X-HE-Meta: U2FsdGVkX1+55wRHMaqHhsqPIo8akrK1VFm4jOYQ+U1PmCK7NgAK7gRBXmM4haCNNYxL3c7sck0qMGrR95y/b/vRyFta7MpFUMFza325tnXQPWuG5NFRHji9A+s5pazriji3OnV2YhfAr9A0alQxH+4Q9ywH6uJ6V6z0s0Y3Q77Sihn1y9tHLGiHK2Ht+znvcgDWg92juuimQKlehbPP9/NG4fZAjnaihXUhxfQCNXfSXGgKUZBtt56aiyDUcvZ7BXbKvdy6f2q35ukUvkx20fG11/GvTj8foLreu7aJGVeqSWSQ90O7XrQCvuIw08o8BX0OJtG6WRS03JB5UgVw4gDqqAdPoTJk4QviXZb/gOdKbxFNCElqfulTsd1swQY0BiWfmNfoEeHksQGwTo+4KrziibUhJwI60UV/t0xYzyhFO5AUYpzBkNgfEUaih+J/mvgHdFWcGVPjqQLVEZ1wRIrqGV2Vgja9hf808k5UQxxzF6vTWdcDwOOBzl2YY7rpncSXhSB4DX6mYYPj+r6/2pfRlwcTu1cZ+YNksnbG2uiEx/umS3kWmLmlTY+vtASkOliuhfb65P1e45CvLXmOmNaweCd8KgGlfflYgarzKJoI37azsLWHsJgMZC+E3rL6NBPmQaHd6O9k6r73ncFCrZw+KjwoKTGBDowuMaCLnDWwJ+wpDm7iaNzDdwuzYPNKufSOi5AH4I/NNfFbdeaxmRsEkFkqOjSs3IN3hMUF56/DJdA2o6zCNa9pHZqJtf/Q3x9r28OSzFCkVi9XxCVm7Z1Qoj3qXCw44UIoEfij0hYV2WVVHF+nY5hCon8kFK6f2hju2uV1mkgupZV4aCWPnanRwogivTp96OFwpvE5IaapATNuV2XnUFWmnYa247qbivtM1ScHCZtfbrBiF5NYYKmr//YdsLlZLZY/AjoDxRenUWQD7M2xDm6cyidaFIfNehEWx91/U/JC2lNJNrc
 V5V48oox
 OpOH6gPqnlCZbKNGGsEis7srCOKHlvjnIV3L1wQUWpT+jzinBvZXrS5Z8DZC1+Q4jGQY1QsLFyIc/JXzZ+T6jGndcBYzamuBvlnVdwYablTv8snvxAPSmPJO39TfphWlcYQ1Of8/uECXljf1PmZybI/2vitg6kRFVkCY4NgFa5RLkbAISOoJuz48iDpGZxXFf4vA5f0V/DqmdSzkhzc5qCuLnlEMk3dRe+YI6ZvI93AplvuVqa2s3jIz9fE2P7z/lqg0kLQrFvRQ6Cfbe5/EAhLLg8Qb9CO3FICZ+ehcOqYeLin8uTIxtFTp2SwkEiHAGF5RlMNJQQ2c3Ck/umDHPpUpCCAZThprBavcBZR4Obz87TCi2JVppnijaCd9Mq01JqCZ09sXl+0rqx1SL2B7BzwqO/HPc7Z/89NgKL6Ws8CzEAK3zYTuYp+v5gTSx/rZlvNLyGsGTpm3CuhRR0E8+Xn4hc7xeMCghubaSimaQAtKzdgGmyjYwXnqbEPKxsUeDzxFkZc1bQN3DdMLq3zig8tCifybU2puy2Q1KXVlaZCUj+Mxyj9oBPnDOfNC77Zi+il1P3WHmMVEw9Us=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 12:55:13PM +0800, Matthias Goergens wrote:
> This RFC adds offload-only swap areas for deliberate cold-page offload to
> backends unsuitable for pressure reclaim. ZFS zvol swap has documented
> deadlocks under memory pressure [3]; compressed swap is another target
> because writes may need memory despite free logical slots.

Out of tree code not matter.  Out of tree that violates the linux
license terms even less.

Either way block devices must be safe to be called from paging paths,
not just for swap but also for file system based paging.  So this is a
bug in the implementation, and not something worked around in the swap
code.

