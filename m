Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C481E6B26A
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0A86B0089; Mon, 22 Dec 2025 20:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7B86B008A; Mon, 22 Dec 2025 20:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE446B008C; Mon, 22 Dec 2025 20:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE5AC6B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:01:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FC32B8C9B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:01:08 +0000 (UTC)
X-FDA: 84248931816.24.33E6A17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C11CF40015
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:01:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sKXOod1D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766451666; a=rsa-sha256;
	cv=none;
	b=a1pOW/+pNyPsKGClvPFznhd1be62t+Yd2XJicpH1fiqCdPVNptJDtfoYbxpqtP6q/dUDcm
	4Enl3NpCukFmDADCkNxLk5lmAPqepYQ++dRzsRTz3GfGY4NIyt+PkV63oGwvQuEO9uSJK8
	pNijb7ahswfWh5gWvG2hCcJ3UMfIY2U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sKXOod1D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766451666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hz6vuN2+tW7bppaPMqpZ3TNFSuQST5OiJd8i0ajQHc4=;
	b=olrYpYX3rIjdcMVWRYkYTK8/999VlAjawpxbjljiwZivvVXD3IfCBoJiEGntjdNQCV1CE6
	4C543yHfLZVfDQdgkoqNy0lXTFyD+vfmhksVqLQx2uX5Cib3zGSln7WyHzwIzahX9KqhPg
	vp4hNpggKSbjazwjXBj19vRDosXdI7g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35D1960136;
	Tue, 23 Dec 2025 01:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDFCC4CEF1;
	Tue, 23 Dec 2025 01:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766451665;
	bh=2r+Tiz3V4y6CTzvUEe64MBbKMKKAXzykFnfKZv8E7bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKXOod1DQEHksmNbUU5BF4sr8bUpQw3a+YSB2GU0WjWrW3HIhEgiDp3Oq1DR58s5S
	 cs4UZRVxczFzSlo8zgvKRTqCrsQtqHhVPiRai5Oz4buLWLAUtU34SHqm9yf+siwz3m
	 zff6KSKY9nicwx2gbDNIojIMkGO8ZwYqo+3VSQKzUyLlI4HWm9Jr1cqsNEgFxSnfNN
	 1z1NVfEahqwNpgioukKAYpYihS/Nx9GrUpLfwPPBi6mHLRK3jYAoOzSK+BUT7bYNW2
	 +OiAqZqAwXSXlSVJ2lBGOSb63o3Hrp3AG1eoxPy7NHxx/fq95X9llbYWk33NmJ9yGO
	 UaKFaZPzKXttA==
From: SeongJae Park <sj@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 09/11] tools headers: Sync linux/gfp_types.h with kernel sources
Date: Mon, 22 Dec 2025 17:00:57 -0800
Message-ID: <20251223010057.4135-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251222225716.3565649-9-namhyung@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C11CF40015
X-Rspamd-Server: rspam03
X-Stat-Signature: c35okok6tp3abcxfsh8kasyj8gabueye
X-Rspam-User: 
X-HE-Tag: 1766451666-776605
X-HE-Meta: U2FsdGVkX19IMoARVrbehQjJK5tq8jrQCCRCr15k1Pl2fTOAB4wa6XHwMNNB0rivODyhRzNiEf177tf0buC5uunHhBpQnDlBM0GZ4EUJbBFN9hDSnVWs4zY1GGKGwbvqS4Kl4z56FKn18eTfsKdSljoiMHECXw5o76LbD/suGCQAj0ArANx9/IyT1h8H3XWHfZGzLdGtMeod6XkvR5/dYwkNf6dqStoQO1xf4aNrhgEtJMj2R6RW2p7nqff6OWLNc1bHcyO0W6qA3X+VBKDazoZH82RC7UTTqOkay6gzneuAnQTSetvG8B0S3/w2ITSQUlzZLJOntps6KMeNNvAHI9B6CcgUB+bKTcv4zbuKo8xcpO4Oaq90dhE00WqdvOFdiaxfy2bCVwnN+u0HpdkVNF6W8pQHQy4oNLL3NO2s4bPQ3FvJWpg1tfbpKLZJ4y6t7q+Uj0t6b8bPw2B9Y6NLpJHKrGVHOEQpe3I9iFdXkYHklckhU+/mRJZLKLo+c9wQEIOQ9LqfY08xN9MG0rDy6cDpM5bWcg+AnDdlzNTyys/LXaCdlnhZ1u2a8JylUCTFSo40LeNxbtHDIS5+31svJVjyk0JhqwaL5Q2McAId29oUSqoXWgR9R8kT2qrViWsyW59pwEDN0GRoCDttpz0sSFqfUInxxtiScQPvN2A52d65mtJNWxwKUIx3KUh+h1P5kQ6goJ0tsdG+hsI5e5gCrXaj/IW/xB3yKIUqaueeqp4VMeBxbYL4hm/7lxsWZjlHCCbEizHUl3r3l+xjmwtk6TQELm10N7Eav36Rb0F+L6KpwiaIA52rxOceyULS7L7XR4lcAEsGB8a+7BlcJcD1KgSu/CTcg3Wa+EXYx591IC7rWji5Pg/Tm2d/uuzi2Knr5gwIOk+VAiumBcxomPd+n5JMOVC14UUc9fXEhjmmXiB/K2qOxOBKSb0Y6Js/EtwI/MgjtroCY4pWWa2G4QY
 jAfsCuWA
 wEM/OFsqhjnBZ929Y8cwGSRsB5xoMO9+eNakIznQfdVSKTl8YMQ88AuTZmhqcJg+KQ+BtQ5MIAKaDsE42QkioDxfzGAPhf/T3k6dVJJc/m56Uskh5EU6L6yNaYKpXf6kM+Ib6RG2FXu+ARR7kUBcfaZFAxDKSGx4eUmiKaFbJkBu2WIrNrLk4SUxb/U3LITi16wR3K61E3i2R8w+e+GYGJ58gFguBLtBVL41U3ty4AsWgu8LPpLZiSBc61g6ebOXUKPp1wtFJiUNre4E/UZmNpy9//RTndmmvrgigcZFdUGxyLMKSpCkXsKu9PXpILPDxfBzMb61Fqj8hnLWL8KU8KGRo7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 14:57:14 -0800 Namhyung Kim <namhyung@kernel.org> wrote:

> To pick up changes from:
> 
>   4c0a17e28340e458 ("slab: prevent recursive kmalloc() in alloc_empty_sheaf()")
> 
> This would be used to handle GFP masks in the perf code and address these
> tools/perf build warnings:
> 
>   Warning: Kernel ABI header differences:
>     diff -u tools/include/linux/gfp_types.h include/linux/gfp_types.h
> 
> Please see tools/include/README.kernel-copies.

Nit.  I don't find the file on linux-next tree.  Do you mean
tools/include/uapi/README [1]?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/tools/include/uapi/README

> 
> Cc: linux-mm@kvack.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Other than the above trivial nit,

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

