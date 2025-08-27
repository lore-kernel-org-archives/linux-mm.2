Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB70CCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11236B0027; Wed, 27 Aug 2025 13:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2366B0028; Wed, 27 Aug 2025 13:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD77B6B0029; Wed, 27 Aug 2025 13:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9544C6B0027
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:28:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2205DC0790
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:28:41 +0000 (UTC)
X-FDA: 83823222042.21.70EEE96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7949140007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:28:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n2GEqtHi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756315719; a=rsa-sha256;
	cv=none;
	b=dCoBOjhay4Q4ZVI6Q41O6A/cZsU31+ss/OxoWgIy4mILxpJ7amSHNaPVwgEyPQiBBdnZsT
	NySKZoq4QWnuUHcYbzeVnRUkAtXEvwgIfjmPDQYEEA9f+03cVpTVC8FW8ThQf1Ay8JUV0A
	qjNLCSJmfwlt2EYmgYm8dBX9hLt7IEQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n2GEqtHi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756315719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKuPCrDI3wr8H8Nz5kfvvUgrdZn5U5Fu3IefUzaJckI=;
	b=XQkKOtMaMhoEyW9svOQN6kiI36twMjlbOCjlHO3L25JNg1HmFDC6vnFCbvr6Bejgwsv6ey
	O2lM42Z+vnAle6aAN4KfK0XyrSmo8DVOvX9wn26gsf1YPPdrwEQxaT4AGAMfjXuZquyFMh
	UYTfA873Ef2vZzHxZhmkoeAqrvEngZc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 240686027F;
	Wed, 27 Aug 2025 17:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95F9C4CEEB;
	Wed, 27 Aug 2025 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756315718;
	bh=Ihd/WN/NFD7DgbyYCHyUYrG3OoCqvMMxeCfn7+DAdf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2GEqtHi7T9vJRjyVbY5sSlB8/fdDmk5i180Zhsei6CtJ5GkoP000/FREiZhYHZ/b
	 1iV3oDiCAWSYXmfeU1VWMhYiSuGwZsGjq5oDBQgn0U6mwLLftOAKyGZolycNZVCpZQ
	 kHoIl53CBR3/NI4yN0MpPK1TvnMrk9E1se3TAtRtLuTPvs10k91+RKRbxS0aMGilg1
	 7GIEPn8IH4WOEEL82bA+QNRjpbyD1BJYZk246azDiMALKQJCRzUCcxvYXFjEjTk6Mj
	 /6A6L3ggBjRci99/laP+nhya7VXnudwDD3fgnovqIEBZBebF5J/5pI+5DgIcE8U92K
	 Fq1Ax1RM7lw6w==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 0/2] mm/damon: void divide-by-zero in DAMON module's parameters application
Date: Wed, 27 Aug 2025 10:28:36 -0700
Message-Id: <20250827172836.105335-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250827115858.1186261-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B7949140007
X-Stat-Signature: oyn7yc6kbhcr6cy8mmpwd45mkzoozet7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756315719-719284
X-HE-Meta: U2FsdGVkX197Yslveq9JXGkGxocQ8A7NY2/mRy7Ne/e4/hKYNwX51suqEcYNCGP5JnzggjA9lnLKI166Kiq2IH6FJzhSX0DIa2nRQLhCDHjXI9KHZbXLIwSZjG6FXAR3D/0RGhs3tzzwda1OAjdA1U1N5ohJeHsHc/VxwpmDqOpYjpl2gH0lAgBrAbyeMoLnIazu1k2Cr3VWf9clssuk69B20VHP6T9YyUPknzYlSGZt8fPkO69jWyo6jujIjMvYL/g4V8+JD77EMGmFRcJdtOWH4kFjZDNrGfQxxpjD8e5OkPyALsl7dD/5xnsdtXywcWDIlNPINkU1wnUCofxslcT+wSLwIlkhH2E8I8OPZjupDsuvA/MCPrK9VsjQic0lMiObV9LGMd5m34UbNu/tfu9r1aehNzH8mOmrCVim5TLGqSnwCWRLq7bf2HXKJT1KvX8ygjp8ajuNy/a1s6nmym+HUne+yr2yHpqYGSU5TfNph2nbwwJm64uml0j6iAyupq8JjwQEefAbT8T45RIpJ/Eko5f5od27cw1cUeyOg4TnRph7TprlUUUHeK5UsMadg8SVAd41eut5q5ThonTg9Pqv8azjVhj/QC3jGLDV6U6pwETBBsncrEnp1A7N/z9Ay48MxB6PHU+AAmJy289Isegb6tiApVD1Te2Em4CNVNJqJhWCmuRCEoZXIkQ/eiQJnxXVwvOdxL+WRlwtTkzcYS1dIw/XyVBEnPllp2Ea8Nng9U617ZKWTjGZTiFCsram/hPOF8JDWPGqkiY182/OwJZyrFzXMPRruusuHWV8LLwCBoluagPPBqal7IvA4gDgnyowS1Yt96/88B2kI8YGUBhcapmvjhWSNvfFP1w72lOlT1N6/NpPh6y9e1DZSCBynLxko+TQdGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A trivial typo on the subject: "s/void/avoid/".  Andrew, could you please fix
that when you pick this in mm tree?  Let us know if we can help.


Thanks,
SJ

[...]

