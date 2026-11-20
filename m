Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAA2606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mWKv2sBp
Received: by kanga.kvack.org (Postfix)
	id 247EC6B05B5; Fri, 20 Nov 2026 07:03:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FFC6B05B6; Fri, 20 Nov 2026 07:03:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15BAB6B05B7; Fri, 20 Nov 2026 07:03:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBA506B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:03:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C46A120EA9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:03:00 +0000 (UTC)
X-FDA: 85455361320.02.134A689
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B595440012
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:02:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mWKv2sBp;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795176178;
	b=VgZVS30LCNX6lABs51e9V9MASk3CwZB49rf9rKk3rJVj1CjXBCYIV5cKMEyzaiE8YDtK3y
	qg3oqZ71h6SnhRh/fKCcV9x6AxD+3K3uUzlLya/k/qAfjQ1u4HmmP/AQ73LNmMWoceM7/g
	IjRWpP/3SwX3ajDJd8DlEpzZCdT/PwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795176178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5J72X3HPA+7mSwk7L/JqiNlhfSlr+OpvNLs81RwtBM=;
	b=zOPzGewskHYTdXyzz/Nz349tx/8V4kkva7wWG29rp8OUFTER+VGisceneoLS0uX+NhrqxG
	vWzY5ckWVpiyCgkRrm5gHtqIrd+UynWVuqL/4dxGjXSF3vhoijQfT+Tx6DlXTiQMXv3oXs
	3I+ODnszgE1pRGf+5Bnx8H5HAZ6TvlA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mWKv2sBp;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA92341075;
	Fri, 20 Nov 2026 12:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EEF1F000C0;
	Fri, 20 Nov 2026 12:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795176177;
	bh=a5J72X3HPA+7mSwk7L/JqiNlhfSlr+OpvNLs81RwtBM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mWKv2sBppmiUSdyRqTHoLy0JiF4sgo0VjISutNKO+L9E1A83mmNl7o4OwDh61EuPA
	 pkCfeqgSsgrgpvW/wxbM5oLmX/qWpfSJ7NynQQUHRGPa3Q9jhYW57wuSAfo34EBEMH
	 BFj7Y0k92tluEyBqvMQkOh67LrqF5B1Nf3Enowz7pr9aLKaU8TYe76sGIE0FQUN+YA
	 qlAUT2yUVqmA2bJkml2+T686GxMFtvjN1hiizEyW3szH9eADb4nM1pUvd3H2vK1uNf
	 xb5gzP2YsZBAP82sRRbl9wKGk0mrFqfR1C5SzEUC0tu7o6LCIY3d7PNaa30kWXRK5n
	 Yd1rQsvYo08eQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4 10/19] mm/shmem_luo: Don't make early retrieve
 failures permanent
In-Reply-To: <20261111002358.1842967-11-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:48 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-11-dmatlack@google.com>
Date: Fri, 20 Nov 2026 12:02:51 +0000
Message-ID: <2vxzy0an1zis.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: mspmsc39qo8rqg9ya5uw7z7phamjuhno
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B595440012
X-HE-Tag: 1795176178-796807
X-HE-Meta: U2FsdGVkX1+kZDpc4G6o/lVI7Hy4UiTojvCJQIzEQvvNsgR2JPNPcxuZYYMCWv7IyQQ/XlTl4YQ6076sDTxYKoATEi5hwYRvLtoToLBZmPOOcRM1jF95EE4Sod67XJI76FKA+13lU5gKYSIsdYJJPalcLirUVu4Yc490Gte1Tc5NKnPQPQUqqLobe0tx/dt5rkqVY13oIxYQFvzRH/3ztXYfu2lNQNIBWAHCp70KjiYcontfidXY62aMFnYxwrDYpOscsxHekcIiMfVRdBLxjHg0HQQEcrnwoPyD+W2HVDTyGC/XYegdR9wKkPdvoTyle0SVg2X648iNEIG4M6S0Edm5d5AYXllgwT8jmI1cqbbNht4VQ6VupEP3MhXwPYCW5hhD7crB0tD+L+x7+PjKFDfL24IFRLsCPxSX5nnJZOE8pZEjq85IqXnHxVUx0oIjZ8daD7WQ7IUvg914NXer4KJnESUFBHKQ0hFR1BCF8wYfcgsRqzF1DRhs0PQQ4YgCyZDtg40sJGT84ClXm0lsbZ3YejF+pvs2tCo5a0PK2mbwzi2gUWnRSo9FhWcbSqoI2qY9dr4VRDqICCx+5NTAyF3+gZuvX8HSRxGEC6j5PzAl9Os8QUoKEmOI+u4lZk2M81+A8cQFZeCqu33qplIHLSaPfnEVKhlfPTEm2ZdcfRmtrRmN+wNn+5NXEk5zeQz9ggzHI6dDMkMYwca2hiYJlliEOIhaShZ0xd30TNIiXkzesmne5P8vYLvynJyJM1rtWJTLHveCZxodnuU+/SWyCrdfm0OVFxVKeYp9mC0h+qxNgfWsN0rWbLP6VVWHIJZ3hHjqu5PNiPhc3Z6vdVUOzf1VrA/Vxmfxq3I7fLeDflGU0CaiqPeix6hKqPE3R/XdOuZWMcEcTvR8ZhyLP7rcFDpf1nKWnmToku528MIgOM9jlTui7GH7y93NqEJwPIVI4Zgv4jt+0KmvNVneyJD
 TsnX3cJW
 CQu9P3pusOceaGQHItqLlJHSLYj/RWmgf1o+nmnJUnL2pgg7rRjdIZT9ZO2o9seZNdCQF1DFVjL64ZKye3Vt2/g4YGQRFSLDf8oCUsebjCNBqNu1ch+zC+7Nl6Ptpgvuv9OaSPpjf0YGIouISeSt3q2WghIyLNFlduFWyLr1W8MRBoI2QAWbmAp/8HYD4ENAAcU1Vj7+TkvgkfXMn6eNeY7LGg0BaVbr3U/gm+aU6c9pAX5LuCy9Gb9NjkG3sMQnD0qgHe1e1u6pLBUwY8CPWFc1kzIZs2otLujz9r26k0uSwrGGiEpafOZm6zJXY+j/IQgQkLBDXsFU8adempH5kvG27kQ3vWu1BHCTj/fquO70BYE0crEXNlHgYhiqhDjJ7oSSrmX2DhOwfbOb0naGo8uf53blvR/B8hJsIFEWkPj+hnTEjWMid0xB+ao2rvTBuGdEeYggI/BYUzK0KCCtcWKUfTKaE2Q7ZVtlclM+ADXTE3vn4OxngvMd5Gins3J4MBTR57OOJ4rJJqVc4fjEVKknG7LMe0UQm7/lc155Zkq7BerLxFg/fDxiXJRTzoiSYuA83IKHqIfdbprrgcr594rPrdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Mark failures in shmem_luo_retrieve() before it starts restoring the
> folios as retryable. If no retrieve succeeds, finish() frees the
> preserved state, like it does for a file that was never retrieved.
>
> Until the folios are restored, nothing has consumed the preserved state.
> Leave it for another retrieve, which may succeed, e.g. if
> memfd_alloc_file() failed with -ENOMEM.
>
> The exception is a preserved file that this kernel can't restore, e.g.
> because it has seals that this kernel doesn't support. Retrying can't
> help, so keep that failure permanent, so that every later retrieve
> returns the same error.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

