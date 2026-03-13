Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D847105F782
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773836B0089; Fri, 13 Mar 2026 05:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B116B008A; Fri, 13 Mar 2026 05:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EFE6B008C; Fri, 13 Mar 2026 05:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5821A6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:34:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FF0DBBA4F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:34:22 +0000 (UTC)
X-FDA: 84540529164.27.832F289
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 831C3100007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:34:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKndTr+z;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773394460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ5uTqUJ+QW1yUxvaliHmvxy05jN68XiBCO4RD+PoU8=;
	b=fTeFOQPFab/thAMU/bWJAQJEjVE/LhF7VuAR4UvQYDnf8mDOw4d+cdHemZU40s5hHHLuou
	dxUX28gJotB+5E6bgiAyfjhliN+au/WRKbiNgOQbVQ83NIVzvscwdsdJRpVp270Zo99vCS
	8nMXc822v5wu222o2+0KlVx1HxtEaFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773394460; a=rsa-sha256;
	cv=none;
	b=ZucCQJcLdvhDG9mbXQ4Roq8WKIZwrqj1+guIlA1JVKJKI1K/hFd0uNHG2yQBlkJMgRm5Js
	woNDgdOFdsJKLb05SEfar4JTwbpwHUZZ/ZKkIn2RXKnM0Y0Wl1pYF1suhaqqg/hGyMShGV
	E4sGByjnwaC5QSCizyTCSFwN/S7cOGI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKndTr+z;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA2C76012B;
	Fri, 13 Mar 2026 09:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A62CC19421;
	Fri, 13 Mar 2026 09:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773394459;
	bh=v/rvjqqtoL58+wHyLrFv7Orx5p1Iqjy/QZxcEBCnMfU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eKndTr+zLS0kx+l4EYxG79uG9nv3jRbABElRDZSfl3PzejboVWk4txr+URAEymiCE
	 oI8wPYfLSbwTnTBiWBTERSkqDS4/xYVrMx3PMsI1iL2FBrY4zaYOOsEiVmQYXyB4pf
	 Atrd7o9DmviyZdxVqWBWkfAzOFgfJan6xPI/q+GLeS6MQOCWfM71HguM4ikjk1Xlu5
	 IxcIL3Ew04pZ/aPp8lBl8Csjlq8S/NDzij9UYeuLJUKMIyBM9mHBUB2Kyziz/Pkmip
	 P5Fb3iWc5/jNJmCmg2FfY6WohAYufLClf11/B5WtkqvsD/ujgFcfIUEk36jI5O3pSf
	 FZoukOmskuQFw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v8 6/6] kho: document kexec-metadata tracking feature
In-Reply-To: <20260309-kho-v8-6-c3abcf4ac750@debian.org> (Breno Leitao's
	message of "Mon, 09 Mar 2026 06:41:49 -0700")
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
	<20260309-kho-v8-6-c3abcf4ac750@debian.org>
Date: Fri, 13 Mar 2026 09:34:15 +0000
Message-ID: <2vxzy0jwf4yw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 1m7qn8ycxerg7bsootqkbb8g96bpnpny
X-Rspam-User: 
X-Rspamd-Queue-Id: 831C3100007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773394460-978510
X-HE-Meta: U2FsdGVkX18QPAZR90SLm7IsECQuTkOxRHcNIovD2Hrc+thNHI5T4r7k/mXNKTuAGNpDGm0VQCw1mvYos134bx3OF60yBkWlSxb5hmv9FBjBQRgbFfHiQj8amJxEvq7NkUocMHT+AQc19oNE9iw9TAAe2dmvMdNp0tclbKKsDO5fWOY6ekav3cZ4YyUGOv9RKLvlqGqLr9x4pEGDlIWbFUbboKISp+eoM/rJF8sjj38zd6iAWtMW3sYBdGegGD5KwRl/Ak5h0E5Y9ZOju87KCY0Q5BFtL8kYivV11Zu1X2QyeMcCQ/hFY9WqWZRGyFsaeoPTZ1aMjlaIK3deoezmrJzxHZSWMkotwkb5OBKlHvwTc6SVam1NTQg9V76FEbzofE9MeCM5PjKFCGyJQ3YjfSGTtzg2RG1iCuaUorkX8GF3VmJ94gtSlunka8ZDo6IUC2VEx6Xnf69Nhrp3PuECaDScxUajdeG696iXXqxcqrr+Rg2nJb/WOJSC49fwoOAOmLvCtkcHKAPYjGCCFBSgWr8Mm7FrZrNdrD64lhc1YmQaxJ4xq+meamnSLx1/xOG9muE0Sh5+aH7IyW8znxmax1wTGqqxz8e2TRT8OH43hUNEVBr7loAsjwSIiPdzsiPs5ccxmmWK7/jDv2cKe1O/4rv7ZlE6KFGbrY7MY0h/jb+xh5nBaDzHMOzlPQAHUBe3WccTwqHT/9bZAOv4IwnXvwEWyQ3qzWMgvG6cOIH18UPj+E2Vs547bGFopXBmsonxdCAYmWOW9aK+eGsUyI/Y6Tp/lxIjxtZSqI7IHkc90rA7/6Wg7JylqfRNvZk266AlJ8YcSDELLuUyIKOFg4qqCHcy9Beqh+uHsjbsSp99D1PDvjIGapuDbP0ifPuzpHLLDseMjv6Kx+UpXzspOWtlARbeCc4RxURAXZrSpHJIj043fLLOc726CuNMGW+6ZwxwMJwSAQKHEsGchqvMufL
 QVyCseRg
 aqgm6cLTw5wJjg2iHToVSFNrn5TzHox/81bi5eJKgcl4rTpq+BsE7Fp1TdoVPw2+qgkkH7rytziNNlpbEgceKD15nfyfBEB4QKKisDFMQAi+aUO74iCFVkyylLoxs9QYD4r3cCcOLUyMUVOv6W9vhps5FHmIXY1QfsLFmebIAiSPT0iVi7TQo4RiZwgOYO3vObQ2lwUsoHq+k6XDDCMA0Sk2GLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09 2026, Breno Leitao wrote:

> Add documentation for the kexec-metadata feature that tracks the
> previous kernel version and kexec boot count across kexec reboots.
> This helps diagnose bugs that only reproduce when kexecing from
> specific kernel versions.
>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

