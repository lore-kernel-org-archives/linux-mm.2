Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7DDD14882
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 00:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248E86B0092; Wed,  7 Jan 2026 19:57:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5E26B0093; Wed,  7 Jan 2026 19:57:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8946B0095; Wed,  7 Jan 2026 19:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 004BC6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:57:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B56528BEAB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:57:16 +0000 (UTC)
X-FDA: 84306982872.20.BF88721
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 44434160006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:57:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmWb3HEQ;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767833835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omoYf2l5EKK8p21Rzds5j+ZzNMO6x9ffCy6tRFgNUcI=;
	b=CNuVw8oSgmGJZgJouTUgGJy7LcnFIH1ZXMPgMfK1tA6sfF++o3vIgE8D3sxNUYc41URDNB
	W6tlxuTYwdCxdFub1nbzT+C8svpBS/xTktke9trIXoZy21/13nnYZRZ1kBuG47JloaNq2x
	9ieAAuVZI7P98zHdwH+LdJu6OaqqHh0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmWb3HEQ;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767833835; a=rsa-sha256;
	cv=none;
	b=utZPFKlEcH6rjh+JvG0vnCU8apjJGZjpPkwA+mXFQ9mlARr66oO6Xx9OKrzRP7DhIhyolK
	03hIN4QDkhG3ceuUV5Fv91+EtG3+WmTG7EK59b6b4nZDJ6x8Q8wnyvv2yQUzOJsQKLpEK9
	RG8aTMs2NM4haQf8oCDLuMo4QIJcVq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EC4F60007;
	Thu,  8 Jan 2026 00:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26A6C4CEF1;
	Thu,  8 Jan 2026 00:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767833834;
	bh=CgxeBS/toh4Fwo2zQBVbFoBCp/GRXmjRjFe8ogXrwF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmWb3HEQV6CtMvQoLUAWpPxdoEJ4TlLE18UlBE5XfBXdhVpS1Z+hYgyjCpJFxf5rl
	 AQrpBdhSXCr4McJx2ipBobWo6GrSiXn1DJeqkkX194C2HalqzgrDd6RUuiyV5PAkFk
	 KtNKyTDYf4mhbtrZAwi8P8lwykDtVW/lI6uhcb7e/G9IZwPcv0JFEu4U9VIn+4zFoL
	 1fu9nuBy5bP5BpYf5H35lUi8qFUyB3LvQWzNuyQYNtSzfF+dzkuQ1aIXdfYAv1/m//
	 n8hOMgZ3vpyJcJQh9zEsKr1MwniE9Bi5sOQcwjWagSZR/vA1W+R5mCD42opep9rsqS
	 03Hrb5mG29Uow==
From: SeongJae Park <sj@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 4/8] selftests/mm: fix usage of FORCE_READ() in cow tests
Date: Wed,  7 Jan 2026 16:56:59 -0800
Message-ID: <20260108005700.79922-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260107164842.3289559-5-kevin.brodsky@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44434160006
X-Stat-Signature: ye7ij7dz1xs66gjo8sy8m5rqqtmyn3xp
X-Rspam-User: 
X-HE-Tag: 1767833835-984520
X-HE-Meta: U2FsdGVkX196gKeF2oZzCWhOWeN6ZVG+vp+4cn6AxEY+x1s09K9gasSalFDkv6TX7pl+T+Gen+w2XOxq0CEbtqPzs0IEEj8VbJEv/jM02zHwbhy5P2E0bDOHPwwuCggDqUqSKn8uG9iDc9yqkfvVOEvYxOx18NXMvYvJ6XYqdfyYtDQcEWih/WHRFAPsiJBUWoR+sukrRBeM4wKZidSG9QpNwZ9M8bs4ywl1emx1epxqSBAdm2u5Xtr3YtuwJbX1MGAAPVdqWBP2+7IaRVwBC0B/ZfSHX+Tv/narMgfEyyjbR0Fq9hhkTOWHf3K3Ul7vtq/stUisTraLvcMkc+1MzI69wauNw+3zpJP0yZlCMrTgWfIo51ZesYgrPISTAE1rAhhHcfKEmKl6vNYzcu0Z03g2Ap5BgqPXQ9E8pKC6av+BKV+pNGqCQzODkNFRD7+H93jIZ/1rNIauooYqUX9HO2G62quW+wr6AMotNvBgPsAt7XJ3Tpx5lpb97CAg02t8P9WpBXLugqQP+EChOPod+gXnjBRPAUTIrB/86E/XATTUKCytXfUGsK+KZ78oet9/IpNzeauzxE5OmTOge/5qqntZozUqavAPh5zlePJlGClRH33BCFn8AbMMLbrCId9tzt1kGzIZwXckdmT1I2bkVU70RYK3LmUcx4lEqfrd8w5yfSCT6V72s13k2uaUMoZvGcKbjfHi90OzaQ6NZ/s0e8UFWC19z4BAGZBpXDue9cY03hb/MvT7lDx9zKW52PwCRivfEa1aDR0oXDAx0EiWpGIOtF7+dSnRb1IbvINS7DMVb0d5WarIKPIz+IPJ9lkW3+LZJySMKRKbC9+wMs0WmGikTO0awaj89hN4a0F9V1Vznan4Mwj5+F8U0k001VfM0fIS/6UwD1eZellFdxeXpk8OrK047bA8WOENTVIcn3VF/FQA/XKJSKllXpEj0X79BNJ+nXSXE7TDAzhMesa
 hxxcZ4no
 2axCB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 16:48:38 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input
> value correctly") modified FORCE_READ() to take a value instead of a
> pointer. It also changed most of the call sites accordingly, but
> missed many of them in cow.c. In those cases, we ended up with the
> pointer itself being read, not the memory it points to.
> 
> No failure occurred as a result, so it looks like the tests work
> just fine without faulting in. However, the huge_zeropage tests
> explicitly check that pages are populated, so those became skipped.
> 
> Convert all the remaining FORCE_READ() to fault in the mapped page,
> as was originally intended. This allows the huge_zeropage tests to
> run again (3 tests in total).
> 
> Fixes: 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value correctly")
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

