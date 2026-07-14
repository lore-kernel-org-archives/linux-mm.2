Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E14C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8507A6B0005; Tue, 14 Jul 2026 18:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA4F6B0088; Tue, 14 Jul 2026 18:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C0A6B008C; Tue, 14 Jul 2026 18:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7E16B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA928C049D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:09:39 +0000 (UTC)
X-FDA: 84988774878.25.3B71E06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38C1AA0009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:09:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgUvvaPk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784066978;
	b=uKS7kb6KmqQFdsk4vyqKeW6RULQp29M0GzqWtifXpPTF/8e/Q2wDZGG0xkvBhVy9AgOVn8
	Q5FK5pNwsvxsK1N97dIcFEgLTshGsNlUxrGch+MXkIDIxW87qeLJrNMAjhCX1XYrfDYAaq
	ttl5q/8/YhwSLI7qp7ggwvq2kgLzLR8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgUvvaPk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784066978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFlgzQECQrDdonMFLsDXQtPgInSoiKKb4T41DNzYsQs=;
	b=G0t1Co+hrJ8lixlNhlEB+4dcOUdhBiOMvVvSpD/gJsPTTGo+xEX8jcF1mDCa0pKESn3Zdz
	x1fS9DIBLTkG9C9r0UFuASO+0XNe4ylJGLDvZwvzqZE8WIi0rq1hFe6KvRhr0FpkjvF2f2
	w3TC646tGoK9bgWDOf5N4OLl1CTuCzo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99B426111A;
	Tue, 14 Jul 2026 22:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2687F1F00A3A;
	Tue, 14 Jul 2026 22:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784066977;
	bh=LFlgzQECQrDdonMFLsDXQtPgInSoiKKb4T41DNzYsQs=;
	h=Date:To:Cc:From:Subject:In-Reply-To:References;
	b=kgUvvaPk9+Cb2xz2LPxP5PBJ+qnwBudV88vGc9QCOMc3DIiwbct3wfpcGw1UDixas
	 iIN4n2OktWuTErfRBu8Oh8iRL8oWjnD3gvFVbBFeL1YY40mYX1upOZltE3ZhxHRuJV
	 8m4JKft07enHltFRWYNdrZwxcNzNIYtW0w24PtBDP7tT7Al3bgJTRis699ziipmxjO
	 I/lAOdqdcVx0J6YeOLPyz7hJEFQx+VrJvR1DZy2x8pAOccXVnEOtS6QC1MHgZxIuiG
	 /cX17EUF4qbrOgbgmoYxHxJ/yDuKFMWGldtbplm3srCYKxzhZe29DpIZ4uwl+kA/oe
	 VI4J3KbKSfDSA==
Date: Tue, 14 Jul 2026 12:09:36 -1000
Message-ID: <7e40318f1de2594c9aa53d2a2dc4324c@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org,
 muchun.song@linux.dev,
 osalvador@suse.de,
 david@kernel.org,
 hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 mkoutny@suse.com,
 shuah@kernel.org,
 cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] selftests/cgroup: fix missing TAP output in test_hugetlb_memcg
In-Reply-To: <20260714021511.1063700-1-husong@kylinos.cn>
References: <20260714021511.1063700-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Queue-Id: 38C1AA0009
X-Rspam-User: 
X-Stat-Signature: ddjmgfx1psq6cmy38kpd7y57ww8faikw
X-Rspamd-Server: rspam03
X-HE-Tag: 1784066978-633670
X-HE-Meta: U2FsdGVkX19k56yUjzCSL8u0mbKKIgX4Xh8OBoml5WJvq/EtosfKSLBZ86kylV6NvyHV2LwxWBlP1DYyV982BOQbQWtGD4ksrVI/yoLaJ1Jw+me7KODfAHFewjKd8y+EUpbq9Dn0OwewRJUnzVWkGgs9rmmH521mLFMu6IpkKbxkQs6SmLZ4dvSAtdii8rUcdVuoLsp+rZhmV7oHnlYAEH8OgWNIDfK0F7O1NI7a4s54fTK2tHYCG0fFSTjggfHeROQklVwn4qeVHJZJXcg2OA7E0DrYCY2GVqKCsMq+iBoFQ6W8ymTHbi5A5QuzeS0ZCwyeeusRioGs3KGSgF9ugw4LJTkLkejtb/sdRIybxA0bKJo5ne3lZUCqGH8+c55VOBWBnzPyExDCF77gHcMxTepmLgLyzMXpiiuAf1vUGSQIT166TBaKwzbJzGHmcy8lK8Fm/A1z6llk53FP65D0D/hZTzbKu0SLc9X20ovtV/DSDNxepZZ+T9J9Lq1tJmrAHevxKeDsEmcaP5R8m7i6Aiiwn36avlpUcIrBGzYMLcmIlizQvkfIjy90FmZvgGxDOMGcsMN3F0pKxQqGMHeUjr7BXDC9KXc2nSKEnDYFe06hsZUB27n6uj532CK/hNdLb4/DAoWgNX2fqvDKAwNTNxnSoP1nwcWlRDxANoMkHyYfT6Q4vjtuViTY/Yw3LvX6mJ3tZgUtZM5HuN3Rlev868tw3/b5N7RpeG/OGmRXbFYZoDfOi0qEtYKYpTWaOsBQy0BaWqpYfn4FRcmdq0L1Yf1ha5E9P/QWV23NvoEirx4fnnd+rXu+WnZCSRzcfhGZeqrNUSxUkvZX+FLxV7V9dmwCLHuOwu+0SxhxcfbEG0Bq6DDBXfXch3pbzQnGAgpkaGZeThuozuScWQXublSLgvW9JWcm0EgRyOoWwJCkD01VZ3kkKKsvSQFvayZm79TQdHgR6qDrYIkPZI2Ym0P
 Y5yfsT7L
 kik2Gqjp2wzK+lEzzfM1arbpC4R4tsFI3DToYjp6696BAQRh3U+3LZtePJJZywpY8hSUvXtiGIyN9zhau/f8r2s4cEn6d+EthTvgeh/rAp4oMtpjOmRx8VWT/NhZ9n+GVhVnxl8v0yOUvkYEzlcmvnDAqFZoFn5eaQOL18nkt1300j/No/wDvAe4YG1SuKQtbuAkgSprKAwHyGoZ6rzCkx05Oo61U2IAkLnarnJ5hzi7QVTUg9tuqHNMc9UI8Znw0g0gDcxOAQg8p9a1YZjOMjxwuaKR+KXRGT52dzKJFSZCsrPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Song.

Applied to cgroup/for-7.3.

Thanks.

-- 
tejun

