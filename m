Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1673B606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=heDsfP4w
Received: by kanga.kvack.org (Postfix)
	id 120566B00EF; Tue, 17 Nov 2026 20:59:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8826B05B1; Tue, 17 Nov 2026 20:59:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035B26B05B5; Tue, 17 Nov 2026 20:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3B996B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:59:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 209E3A063E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:59:41 +0000 (UTC)
X-FDA: 85446583362.16.4587EC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85B79C0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:59:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=heDsfP4w;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794967179;
	b=1XBPaTGKykJW3AXJkn075AK++JotRdQ3MEKWe4sFy7j0Rhv2kJKzi4vxkrqmEovR7/Laol
	XoA5P8xOjid6W+N5sa8Eaj8NZgBvwdUJFp2jQjBQfZ3KgyXBnbVhzvkjmgEpHkJUgpu7om
	Ei2j/GxLvyR7N5SuWXlMWxadHdu/bwM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=heDsfP4w;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794967179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5s/uyGsmm1S5dXpHxF7VvkZ/WKC43vJPwYlg7Viw64=;
	b=Dw9rt36LayW5UFntiKRxyLHFBvyfit3c+jPv/pUQuviySHJfLiwa6gVQIgKSDIfk9cM/Ye
	fd2Y3+a6UcDrHAFHOY/uMAMuZHJPqnbmsvZF+WktR7oEoP0cKF68ZJswVGMLklduOKoCox
	HXBSbvMDxIG7PGo9MmK4qBNV+OV0nWg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3B9C404FE;
	Wed, 18 Nov 2026 01:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0C61F000C4;
	Wed, 18 Nov 2026 01:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794967178;
	bh=c5s/uyGsmm1S5dXpHxF7VvkZ/WKC43vJPwYlg7Viw64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heDsfP4wTRMcK7Zb31BbQz/800F4lPsuTxcE2U/Q1tbaUg3Xl91HkckJcmj0LQFgD
	 xosS6hOBcKnHxdOHMFmKR8oOSKzMcnbaXrTkXZjaaGE48imeUiy25Lb+wa6hmVXy4G
	 VO7b51oYC0GT0TBzGtnwXWVf3FACMVf9KyrX9ihBLBPOqgrJq89VCwuvj9PkMz/pzT
	 J6pIOngDvbONNR7/gZdCz1mTs6K2iK90RUg+Y1ZMl+FY6CFqLi5QJijdr4ihr90Ts+
	 G1D02P7L+AJ0Zz/iCnF4p2Z8MeniS6o2bUuz3dmt4y/8O2QIk1+zoAtWqZ/rENMl0s
	 3wy5YG5aZjZBw==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH v2 3/6] mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
Date: Tue, 17 Nov 2026 17:59:30 -0800
Message-ID: <20261118015931.96943-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-damon-sz-ops-b4-v2-3-439888fa04ac@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3wynjtsh8edetbnm6qcm417fc89bsf7p
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 85B79C0008
X-HE-Tag: 1794967179-273607
X-HE-Meta: U2FsdGVkX1+RW+Cp0lpYAdbgO0xpLw127VSuCsoLOEGEE0TgsCKH5uEzaVNd5hdg8cUwgCnWmizhYJQtFyprAyIe4A1vl9IzDsRtuEKtvJAzEoWTc4sZ0bVB3BeY+IitbpCzze4+9mW++mrDvJFKOmgy4axxjDUdAN1fefPERGSbPdU7WPEEeuNenCLCgzgYkDcvl9e1FrfDSPC0F3xAeQ8+KZ/K4bvI1YK+CxYwky9kR9ed6lMJU2yR7n5w06jKGsuJIAWmXYob5M1rS5WSHeEujjkiwxbM5Rq3yHMe0Y/fFCnRFyrwQOH+H+bch632XAOs1t1pMI4V8E98t9h2pI4O9EasCVY/8v8wVm3LfkgCUslRSVlmesSEUlKD6L/p1nCbJ/TdD80ghKzaI4HxM0xh93eMQVWYT5RQbLZ2xPlc4NV4ohaOvbBN4Fzd0q8AkMyo9VYBe9eS4Ocpox/fI/eJnLQ2kI1pPveg58xfyC0g+9j22sdpt24tUHw+A5W84n0NdL64mX7EKi09hbL5X4XBNhU6FeBkM4/yqNwSXwPhmI/jCVmSCw6Cr1v6dJvq5KHh1nPX9WvvQtemoKas7l/BPWethoDqrPwA3QhV3v+0LwJh6+BNXcI2Yrty07WDOw2opd/pQrmP7f03Hjz0rBlihhz63hEei2OiLDwAQa0m6eQWUNAA/leF1/gH5aDhmqFffr3jOaoQPAUHTcGGXnGMkSPjjmQ0pLwV9neC50dUYpGCFYdzJjerywbCGKFqycddztz6Iyn0oOrLXOd1fQ7s2GaOPFe2GhYdvP0VMkLVzb/V2V5dqwhlUZF1NfeqiiLaiDJ2IhZVb8LCgeSJEV/MGNC0/JJteg7XwRtKOn57lnYpyDBg3MqpqI3TTqI6xv2JeBMSRWoMHxVPaikxtYRAiViPVwdZfCKkYB+ayamX9zqTVEBvRwOLnjIacSdwXQmxWK4w9dQcbbEvfJb
 C75Nz4IF
 Jlnkm265TvMgeT2HCYIe3iLAnSA5MepaVtw9Mq6nSbfBBYm9jHveSAJCrmHS+QwQTBpJG0M7GyGihCpYgo+rJRGTjj2ePKqOYQWMxKmCeNVnHlXFIUPvNjqJzNulzWjrAiwEZBg/Z2xLS9ULxqQ4YqnumE/pvIEerxs19eNEnsN/tJJnlZpivZqMF5mZeYYpraM3UmT0mrOno7aQUarmBUH4y8mSRb8An0rk4WixR8Sm5Fy4EIcTcEfhUMdyODYKga9Yabhlj3g0DPqks9Qlaqwrq/nmTv/3jMEYjYAtgtsf7lZR3MGzlGadHBC3qxa6bOMJUhvXiFv3/1mm8iAmEa8Q3te2oCKr0qDE3DIvEKKAwBHUSJjaVEeg2v7KubATPzcKAlAPSu58Ld3Y4NV23k3schbsMTZM/e8lwaYrFFIq+GRfZm7KvfjEwO06GeeRr+Rji
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:22:17 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Add a kunit test for the sz_ops_filter_passed_last DAMOS
> stat.  The test runs kdamond_apply_schemes() for multiple apply intervals
> with a stub apply_scheme() operation that reports a given ops
> filter-passed size, and checks that the stat is set to the value of the
> last apply interval rather than the accumulated value, and that it is
> kept unchanged until the next apply interval is completed.

Looks good to me.

> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

