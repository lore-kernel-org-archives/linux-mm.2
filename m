Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A734C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8066B00A5; Mon, 10 Aug 2026 10:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F036B00A6; Mon, 10 Aug 2026 10:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCBB6B00A9; Mon, 10 Aug 2026 10:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5AD6B00A5
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:37:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95B3AA181B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:37:19 +0000 (UTC)
X-FDA: 85085612598.20.49A1BAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E62EF8000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:37:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/fgzTl9";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786372638;
	b=15Edhcgez9YdsN0dlTBLcOy5AvvqYbuA5Er0PvNHBCwQM9UAOaJSFplF97+9pDyA2cQED3
	YFt8qrYRP2x+ZZB+Bo8ZDgA2gL/L9votsMEp6GXQZeo/C8uBJLT5nJ2y9zPdNRfws5Erqp
	Fj6xUd0YQxvgja++NLK5X4aXlXmOw/A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/fgzTl9";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786372638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2Iw3IxT8IO58jdGL/Pq6sBuEnBqkH6E0zGFpouWcLI=;
	b=OjSxzpYuSi+lH7qpe4rlCVvnh7JKeq+afgv4GcnzaQckJhk7OF3mPjLoGDqLLvbaJdKfh1
	vZZ4DUZ/reCq56OL9ZLk8ezC/DF8urmKRFlHMcctS9QB64Uvn2B8KEh010lSzQ79tcUZS8
	wKtixFmBs7vcX86DP/50nV0E+ihStBo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2719F433D5;
	Mon, 10 Aug 2026 14:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DBE1F000E9;
	Mon, 10 Aug 2026 14:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786372637;
	bh=G2Iw3IxT8IO58jdGL/Pq6sBuEnBqkH6E0zGFpouWcLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/fgzTl9jyROkQdOaDMRtcE8vjeYcllTQcSn1X8rT3nx5X/ZKeWNHtKf2/H/XTCNJ
	 TkSQthb547PasR8wsBcGbliRXyFui5i//xQThKkM0bnMH1xuxYlAqoNyVsHOY1dHbh
	 khfXi+uHbsUtQ1gEUQIBR2Cv96nM2DfD6sWwXCwh7ryJWvXM3tVIp78VIvTF7MsETu
	 vBaEhrDHcNS3cOZrHiNr9U8uPlAnnso6TnZI3v0QGOuknN+K0aACyyAPJ2wlvQ+GB0
	 o6eBDyjL6nbGF8fytvoJKKhgxYnt/UKxWJV4klX6N3fQvbBGomG98I4qXXgtYL19aY
	 LjdjAN4h0tHDQ==
From: SJ Park <sj@kernel.org>
To: "Yongting Lin" <linyongting@bytedance.com>
Cc: SJ Park <sj@kernel.org>,
	willy@infradead.org,
	Jonathan.Cameron@huawei.com,
	akpm@linux-foundation.org,
	alok.rathore@samsung.com,
	balbirs@nvidia.com,
	bharata@amd.com,
	byungchul@sk.com,
	dave.hansen@intel.com,
	dave@stgolabs.net,
	david@kernel.org,
	donettom@linux.ibm.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	kinseyho@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	nifan.cxl@gmail.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	shivankg@amd.com,
	weixugc@google.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	ying.huang@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Mon, 10 Aug 2026 07:37:05 -0700
Message-ID: <20260810143706.93163-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810033814.83951-1-linyongting@bytedance.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E62EF8000C
X-Stat-Signature: 9aohesuz8n45na3q3reof1wbbjkett79
X-Rspam-User: 
X-HE-Tag: 1786372637-160825
X-HE-Meta: U2FsdGVkX19A4foG1udZruIygNx+W8SErLw3cTDev9D4/PxIfw0M5VglSTlt1JNGCphMs/fiEewj47BP1K0aDbv1cHhYBCF0ge6JDOS7q8fYU2NTioSO1gxkRKINB9a+MSK2iiXY0RnQVPz9hdH5RkQ+D0lQ4gRUcjcD/JV/ty6OBYRbOd2yNZPO0dv22Xc3D4yzjPTFVHQgT0ZT/DUNdF1tPKPoJsUcNj9nNKHZfV6xslPvrlZEVftgeEbLT0Z3j2ivZlDewIwVdV9qBxwWisrEJLDqlM3Oouo78TiRgDLh5GODqRe3+AGJoMLL+1RbKobgRt6zTwnzyHonMU5p7DHEmctknN0Lnhtdefk+8DwIzql6aEb5+AZQMRDYLhGa32pwQqljkrmOpH9X6pxX1paSoQhnzkAerPm7I2O7bOjJyyTZt7BP4Rokg8CLYR/Q81P5U3pFxKXgjjs1GwkIMiLyWPbEETLpIQI/e3i2JNjXEP2pFG+AjrJOPo4AP+ecRy0VoFBgdRaG0ZfVVtjxg7xMHI/pcghSMfIaodgF0dG794pS9qqQcD7cVQ6I3NxDURJwEyOQgQZXkZf5F04Dct5SwBr4p6ahEB2Ok6I8EwLs1tMByinIS3fWDLMvSBFtv50yPZmdMffOY0Hv/Mxz2JlYescFjmVP3uFmFsUL7hvMwkj2DwCl/MWZyQuq1+4tAA3KMS3AaklUBJqTxKP/HCgKDIWvmP2F2iw9iTnnfovXv2bbizlocSBzhHVwI5lm7rOVW0VOdch0miG2ZnMOkM6BgckDkRemZ+P2xJ4TNMmvneeCujTu53o4DcbZbaOAezDh75XSqKvSAkF6tin2kv06+Xq2qppak0KM9JxqHAVdxF6IoMyLDgnlJNitqAHNidaEhpRVCF8+hMHO+op7LJbsMYLiN1tzNiAiIT0D4RZBmhiJEJJu+sRzBZTIiAcf0blgPpN3pbkRdzlHTe3
 cY2a/nNF
 H1Y2opk0T+vmNA04zGwVr1BcK1ACFJEixyVjyh1sK7ab/qkqjxtnRzDDlLEnsnlgvQotSanoeHjBe3+MxJZyqHTe7xigY/ZD+B9Re58U09VPruWebql+dsmVCQB7kUNUOwBEnHj2Ev48pgZbxGSnX5gCtFGhiAY/nvHX41NccqbmxqmyOL3LxixnoRHDIUqDwgzrZdy3vUz4PnHU5kvhc4byam0QxK4PsOuoaTKtLXMAd/ryAimXM4r59LYKCpbocuNq7jpO3yluQXuHC2Hn67qnOjnvALsYtlvxpO7/SXYax5j8LSraGNobkd9+LoO9EzK1pwkjFp9Ky3FDSyC4/dIxcUqaleBMzVMIe0FoAlKaeEaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 11:38:14 +0800 "Yongting Lin" <linyongting@bytedance.com> wrote:

[...]
> IBS is not the only possible hardware source. CXL 3.2 defines CHMU for
> device-side hotness monitoring, and CHMU has also been discussed in the
> DAMON and CXL hotness-monitoring discussions.

Yes, we discussed DAMON could be extended for access check primitives other
than page table accessed bit, and CHMU could be one of such primitives.  The
extension is in progress [1].

[...]
> We would also be interested in helping test and compare the different
> approaches as implementations become available.

Please feel free to let me know if you want to test DAMON-based approaches.  I
will be happy to help :)

[1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/


Thanks,
SJ

[...]

