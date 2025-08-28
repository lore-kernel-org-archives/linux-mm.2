Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27909CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 03:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498406B000C; Wed, 27 Aug 2025 23:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FBF6B002E; Wed, 27 Aug 2025 23:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACD26B0030; Wed, 27 Aug 2025 23:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8156B000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:22:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C2B7119608
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:22:22 +0000 (UTC)
X-FDA: 83824718124.27.D8C3C5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 16D7E1A0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:22:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZHglEs3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756351341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cu5f4VvZrTJ519GliJ8yOk8usTPau/wAkoGAP8IJDNE=;
	b=VgchTRU8S3Ck5Ew/UCIl5fwYS10ooa1bzR8qrCFv+I44T5zUkq4nIx438CnTs/WCmBCLYf
	j6gCsCaF3lYuXTnsSZ3UlZPAkWPQUZrqJE9C3wn/z+RQY0ZPfhxHwXOtPzPSGlrXYGW07C
	BHXF5cFtQnpOgMf3XZqb3gZs0Imqd1w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bZHglEs3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756351341; a=rsa-sha256;
	cv=none;
	b=3z8Zw06RIfE1sCarJgo/Zdz8roRrtDcC3HMFq2esSfgAJueURof/UVqwLXw4bhxeP2JUw5
	tuJmVNvIH7vCn1nlDvjkSB9U2NAenmBvFMFqh89LcgJrgrFXOtj83MQTSSFtvtNCfrWF4u
	eXpNkh+JxLfsDSQOYf+v5PJq2x3UVGw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B84960204;
	Thu, 28 Aug 2025 03:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B7CC4CEEB;
	Thu, 28 Aug 2025 03:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756351339;
	bh=XhDmvGrWM5u3/B+0t0XrZpoX53G2CFMHZKZ6r8ZGMTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZHglEs3FJELZvP/pdWLwB5gUcEpjTr9V7vT4Hk+hpdrUQVxWU7487LCN8ASr9xrm
	 qZdIVlmUQQFR038mZpyXf0anTeKi8VWLnAADaYZYr7YcM9VDoCBPP/5ceUr0l0uumK
	 5aJbq05JPXVGumcYtpBmKsZ9TUVuhta0FJUmtFRvuezNDpzL/u0CqbUnE1R7Jlrofu
	 wy7VbfQsk66zGIAl46GPiBC1hp078w3WfesOuVby3NvPurSZuU4a53UPdConjEgwp1
	 dxFgsPM+FyMSXZ8KfBEoKNXi2VKOWniGfUVxwvvcSJHXOcM7ydvmCxl743i5ZQwLw9
	 MaMQ9KYEz0Z3g==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Wed, 27 Aug 2025 20:22:17 -0700
Message-Id: <20250828032217.6458-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <2c0477d5-217e-40fa-aa26-1dde19280779@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16D7E1A0008
X-Stat-Signature: k3qopwg7rnnyybu96y7qpuxxi71y4stq
X-Rspam-User: 
X-HE-Tag: 1756351340-465585
X-HE-Meta: U2FsdGVkX1+8+RfMEGsQxfB9l3vF7uun/lhIeD6HCm2jHkVyAn2BZQxakz0TKabHGcJihAwWfKg27WMjaj8g4eqbDZFM5yaqQ81V694dYu12zbt1vjTgCiCCavyp2xya2oWjsOKUKluLgyJ8zjWWoHIiidmxnTSPoxI8936zThO1IVGaIEea1CTlXpGIsCFepZpKptibs24zdUnMIu9YC0Z1Xe2FD9GdLo3bx3H8vfTqhrSvWcab8eycuuETZ5pNnmrMGDJSaa22lRfec3kFFtWjHhxPY7UeNHuGKEuYdAQj0CnT6OuwU31uPjZ7yCsiPAmMvSkXT3J80tbmuu22+d0Si3RgahMNsIpoAI5BSmhCYUIgx7jazO1Qb3qnGJyaBAVomzgONwoPG4hHi5hDJ23v/reFB4ItCJWmmtZ10xKGFNPSVr9tj2kbS99htwoBkT3prXNf7E/hT27xFFyTbMmS9P5nlL8ckLD5zULRcihPxCrQMx9A9ae5QwUMaJ5GTW0enasAcdMiVCMgvLJsczCwnxWlDSpgs/KtpcKJ8K3A8iaHIkjQybh/NWZImW4ZSHqn7l0Ge0kJd2KC+k448NxTklvKTGSOZ93agu1TrUN6g+rHtEssaD7gCLWpCSprm1oNyntLazUp0/MKYbCXEajswsRIoOOYI4kcDRJ/m8LgqxgybhF+z+PsJTbkrSy2SyWFRh/mTudS16Ppm7dyj6Iu6AApoUvfHx2b78Zf+gzGha/MY1Ge8hPTLL9aglgd1CEYQDXeXnPzIumuk6aFiCxdX3YiqM8Z746xSYtP1ymih1lqZMvk9daBgMSGoIiypENh1QAanU5YHMH0WcgQQORxTgtb2nAifrkklVM5dvciUQa2OoiJ+pGBPfFIAHAbZ/xPWWuYsW0s7hK9121ES7VBRxxRXOjIbYljpUCDttkGck9ZA3KpNDeU7KfCWuYzre0qnpilGMNULago8t8
 +HBsIUJ0
 j2JzqYSqheupHVtMpxeAoo/BCw6YwJVS8l0bE4QqfHgqAx1QcZKg+NXXnlK937C8Ad5mgndJYFmoHB7wJOUwzGM5f2Hya7rS18rj1oj0w2Fgn+J5P4eCyAjE6qHSfi4BUupdeiccGvT7y/tfGLF+HYDFlZFmVa1/95la0hzF5UNuZYiEk5EbtM9k4fKlswWCRQAa2v/FwSSSnfcrCQ4QH751j9cd/CcU3a/PASFH8hH/52MWP+NO1YlAvTZ/Rq7wKCZcm5Uz0NC4SA3V2j4z2/aSHnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025 09:38:34 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

[...]
> Great! I believe this approach is better. This modification is more generic
> and eliminates the need to deal with those messy configs.
> 
> I have also re-validated based on this change, and it is working correctly.

Thank you for reviewing the code and further testing it!  I will post v3 with
this fix soon, probably tomorrow morning in Pacific Time, unless someone make
a different opinion or I find something I missed by then.


Thanks,
SJ

[...]

