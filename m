Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0297E74917
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444646B0005; Wed, 24 Dec 2025 00:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425D86B0088; Wed, 24 Dec 2025 00:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348956B008A; Wed, 24 Dec 2025 00:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2559F6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:27:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C158FC0330
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:27:43 +0000 (UTC)
X-FDA: 84253232406.29.03AF8E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 264241C0002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:27:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aBN9PvLW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766554062; a=rsa-sha256;
	cv=none;
	b=mWoQYo7viYPwIhl+vaiDdtXKQ5pRk1SbtHQezq1Pf5nNMY4KUWfJZap8f9VjQgZaGPfq8Q
	iKpzeIsOZ+ix9D+pBkRjkk/jpc2t0RHtIoBqSr3Aw+ciYslPpewONvheFDslivsFbFdHvw
	NgeJ+EXbx9EiKESoygUinkyk7fxZ57E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aBN9PvLW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766554062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZ1ccsNHjcD7Xjezt4+gWMU1S2BIgMyDcSNVRjTlFsA=;
	b=yAwf/Dc7trQrOH5UTX/9UFzFASA6vo12TKPfIDBT0TuGI42vK9s4MwE3v6EXgW/M3OLX3S
	+GDqbP2NkKuMN4dGtTXUQoaVQuhNXL0bZDfqfCWKMD+mubUsD+GsZqfSmQgLb7u6PfH7yn
	eWraS43Xc9ExW10dQrO4ll+bhErsgS4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D4D1416BB;
	Wed, 24 Dec 2025 05:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4649C4CEFB;
	Wed, 24 Dec 2025 05:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766554061;
	bh=QDD2sVHnW4PwLhM9+5VNIHHAmrIHl3UBjDIC8SA2AdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBN9PvLWUFGOeKoJtoX2EHuqBhvQIVCL7wohcinsBgPE9A/kqIfTPo48wvLw1FEY+
	 wSMgIjUvX7aZgxxgTgE2GeIApv1lPQPpL/lzrjKI5KKE5zCJI+z6e1V9sTzlQhBPH3
	 o5E3tTltwe7jlqV21lfFBCafxAxnT9xPB6EECHHLTf1s9XhfNjQUSKPK7WHxa8v7oS
	 /nPHNSN2mdmk82bRqzL0Ryh7YeIG+ySMd10JLRyqHoH7JSUn9O+sM5xrQ37x6v/wqf
	 7uwFpx5XxbZ9fMwZ3qLieDf/Hfl9Wj5Jdkm9os3g3BDLIpz2AwyUxjaLY3J9+i9s8P
	 jttH3lMXafLww==
From: SeongJae Park <sj@kernel.org>
To: Shu Anzai <shu17az@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp' fields in damon_test_merge_two()
Date: Tue, 23 Dec 2025 21:27:35 -0800
Message-ID: <20251224052736.81694-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224042200.2061847-3-shu17az@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 264241C0002
X-Rspamd-Server: rspam10
X-Stat-Signature: 9b45cruf3obaz9o3zk8994e873d37ncd
X-HE-Tag: 1766554061-428238
X-HE-Meta: U2FsdGVkX187JuqKWq9G77mZEBKo6ULY0VDOEMxvFF/Y8xP/vMJjYH8qiwL2ipVWbHkweMzHs7ul2qpSARGYZ8li2DUgWX9Dd2Y0XyaSypo40upR9nV9Ov7777wtQKPcQU31fR9FVWipembPZ4tKswnYGKiyEJ2fXZbuew79GqFHU2Ix69SZlvL0agi+2N/MfbKF1BYu7eC5oxCaBjy4y/G7rGxzxTWGU8kBMfOhnBt2Vm0EKHhcdUpc1EtribZE82pPZLtAzF2ngNMZhqls1NVoxqECzjrG6zGtFmgtArV4zqoCCAKvJ8ea8zbxsBJoZaG4/KXsyZ1s7/eEUtJALErjWA0J7UagIoePgfCWPA4nN0DGdnZpeA5KmUqQkYYa1eOi2qMVmr4/Vkxm1F/4n+yjqo5xExN72Y/B995u1xAr0w5yGwV5ORBhku6EMO6wAFUaaKXVsjIj4JcH1eGOQh+1E+YDKa3u7l//xMo1aw8dpAsNj+lz/ibp3cBscEFZTI/pd+KGtW7jAV6adBXGJ3mLAWq2LO8Q+txh4IloTvEk4v8b/H5pam0S6P3DVnM8wWVdLr/utfqnarx6ubuDP6Ke0/FyambX67dodtsSnoYdxsfsweaylR0GGSL2YvlPcwFN3eeDddch0UCAFktkAikhdr+Cpbl/U6ks8M7ObkmyJxR8PdFauKKeyKImvGJX5l9nN4AglnBgffv9AeDa4FkjWiFPsvBwAVLjZPgPKKDU6PxM/XD0WikEqjLr7dLNODDj4D/VHPILKI8kx2IOVmNZbe6vnoY52Q7+s75RXmT92i1ZP+zrnOr8N7zSDwq5JI3DOGcQ1neyZRR7q4CceGSes3W749WUGXTv6ApRHfGpIbDwaLtJsQ8/WF9xVzyQ/ZHw65v4qKmxjdfS5sO9bjiFszpvzE5IgO6zlHZFyHFjL4+KgVjQYuulR42Y4/6ycQtT7PNi2iSNoNxNSMV
 BYiATx5S
 exM80bN8FaaFp0GhxFORFjdMza04CssuZOrOcc/bUE1ziUsc7qGecbDm2Zb/uiW37UwzfjnUsGllve0LSthxVm+6AvdLmX+eioOu49mVCE6MYyQ2/ci4XQNwSHh4U1yocIW6Z99PiI/rGXCRoM1kjF9ULecGi3uYoj+B3cvTFGSMcLPNWi4koV3DC+YDG9E+ythTD7z77scGimVQrmRnYgdeY8Q/pCgVK8aS5mL+JHz3BjCq+aWE1NrhlTsDdrAlDXkrC/htAswmTZGkMdNWuPbC3ri1UNR/Hh9nBmAwxVO+6TTaBkXdhkAEGDK/FlBHQYedDVrGYCYlInb2O0qgaAbXW56joxJ0XSJ82
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 04:21:57 +0000 Shu Anzai <shu17az@gmail.com> wrote:

> Extend damon_test_merge_two() to verify the 'age' and 
> 'nr_accesses_bp' fields.
> 
> Signed-off-by: Shu Anzai <shu17az@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

