Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91365CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05D26B0005; Tue, 19 May 2026 14:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5F76B0088; Tue, 19 May 2026 14:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACCCA6B008A; Tue, 19 May 2026 14:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3446B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:20:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 430F61A050F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:20:53 +0000 (UTC)
X-FDA: 84784985586.08.ED6ED13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C39A4000E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:20:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OPRFuf0A;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779214851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97o6aONR0pA8HdT9b0kQ3IHHh29wOmokNwnoqW/HyTw=;
	b=ew/H0O9YCkfiqGaqoOVT0PGkH7zzwt2XCOaPfWUFM1iCCTDbPGuDUJIiO3qG6bVcY6Afxf
	xBVpkneerCsyWv9+Dr8T4YbaKOdLbHaqvTYVPEVYj0/XMLDo0wkU3xohB0N/JylI+hApx0
	IaYgAmVKl0AF+ikU62OnCQf2bf0iTu0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OPRFuf0A;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779214851; a=rsa-sha256;
	cv=none;
	b=e2atvZaY7PJzYYl5EVVChnzowpRnjPVABBgX9v1frYR4UM4LQdEuyXc+vNsF447hjbYCba
	/ERElYk+pU6yBzaH4c3zHOELnLg+tBDuYIg3GE1BLImYbXH2X9LphwGNxVYDFIyAYLYuSk
	ffLdoccep40f3wu/VyuvEDsHGHehRpg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DE96C60221;
	Tue, 19 May 2026 18:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EFCC2BCB3;
	Tue, 19 May 2026 18:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779214850;
	bh=pqzU8mXuzzhrRUfzmQOzq8JDrmun2MmKpWrEicP9ns8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OPRFuf0AXpK/r6UWnzz8bUMh0BLWYOZzeANHLn78a9/BEaRC8ddDghRtg4wAS8Bmz
	 s2CS34wuni31S0Q/cX2xCxKfxdA7vJwD6Kgcuj4dLFUs8cU9ijnJTC5EtSFYVQ1MlZ
	 oKmrFjPVXaMG+4UIgAuVZBWg7tvbd/7EfeOs87mA=
Date: Tue, 19 May 2026 11:20:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter
 Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/2] selftests/mm: separate GUP microbenchmarking
 from functional testing
Message-Id: <20260519112049.a85f34eb5f2af83e11ffc777@linux-foundation.org>
In-Reply-To: <20260519120506.184512-1-sarthak.sharma@arm.com>
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h837jho1psrnzm9sqp6a4g1q55cgjxjf
X-Rspamd-Queue-Id: 9C39A4000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779214851-771004
X-HE-Meta: U2FsdGVkX19fRmLTHXCiYCzw5MScgJDEqrdcWFCqVMJ7H8EEudP/QZC/ziMGTpmWoYq9EPOqs+yV05GmSjJ7uOUt/TuIS+xQZNJhPr8uUEiaKE9TmOol8quj9LJJL9OApaPU+J3WllFyNsMajsw9eaahFNhoZ/pAH8DxH6f44PpX89UT4K9OitrY9uWC/XX6YIBJWdOVFYl/j8ydyCMj2pX7qXGwWS1WaWvpsPZqkM87jEYsM1YIW0k69bBZG4dUadxBTSBnsske1UCwPE2JRd18TZcjS5DDynRZwa3EAhd3Ync/bNfcW3ampOpt5JQUrIojn9IiOCOh9ZkK8dj+vsCu1MAe9lT3UFZcb8b01IsD3TV2pwtzQCVklWYR3Lhm1l0I7VlTEQEPco4O5sIgbtLPomPrimZ4zdoPmKjfvZUb9QXNWuXPQlmzkeRDEvJcKZhnUFzc6Ab9zsH8G9RQosHPc1H2YSb3ND/TsOqtqmuFRzsdoOWQdn41HCFMO3VnKryW1fUlFp9+GudgqExINLRdQ2b6vf7XNQXDkDEf9XLhM8F8S3JQ+rR4wJmu8ZgSkCuQnUHIPD540UikSKPq/ebvCnBzYgC7Rqqb7/FoQ9pJ2rqsJIU1qEX8lbMtmjvMkt8FfyBeewxcjNRIFwqU4DKO5RFu1fGX941jWZRpYCcHJea/zzsOxSf0/5fSQz08+I0WgnwY5AB7cSP3ydVfDRw8pef5xxvw42OgnwCXj6ulh+oudHRkrgUOB9rn6i/CXqVLleZGVYekXbO51PJhecV7KTVUCVXGbtxbhQkywjatmp40pYdIFLtxmMm5OIfJDe9C3oW/NDHr/nIVqyzKxakR63nG0e+NAHWtAs0KArrf73wVL2CXwMUceJPJj6Lhmf5jbwmHv8kRcGi3Kx8W2Fkir0Hezni5QnLdEyHN27MBMvk/qpDW1v9xlN2dWBWFPCok97dvZPiuD7vytYw
 ZeyaXWBP
 mA/nfHbCkbvyEAwrlCeo9oBgQIJ5wx39RfUAd+wi2AyCEy3iICNS44HQ7bQ2HB/WljBuc3dniR/p7QQo1rAtdCjqytSagHnT5Dkp9g8krmhPpv3hr3wFwbnbVHtRW4CDASzU5ZNnTf0Sv/wro6scA1s/RTRigP6eZW+h+Z0l7gkEssAtGAic1et+5ycYYEn1pGT3tX/Q4fI4Pe8OBGjzyD09qzADc1Yhq2z3g+TIKeaehhkm/ZeBRHZZ+zYPtZc5PIeDMADUS0DST6jne5jfO+SIVmMoe+2V3OisFDcCn+xqgdDWK8z9bsbBLOek0oVTDUMIRuYpQ/+2VjgKTuTUNKo1eA6ANqmOgtQ9sNbEehiLFZcXeqF7DMPIiV4Z578agJP1Wyq2UpBs4N7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 17:35:04 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> gup_test.c currently serves two distinct purposes: microbenchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
> functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
> DUMP_USER_PAGES_TEST). Mixing these in a single binary means functional
> tests cannot be run or reported individually, and run_vmtests.sh must
> invoke the binary multiple times with different flag combinations to
> cover all configurations. This patch series separates the two concerns:
> tools/mm/gup_bench for benchmarking and tools/testing/selftests/mm/gup_test
> for functional testing.
> 
> Patch 1 adds tools/mm/gup_bench.c, a standalone microbenchmark for
> GUP_FAST, PIN_FAST and PIN_LONGTERM via the CONFIG_GUP_TEST debugfs
> interface. It runs the same matrix of configurations as the old
> run_gup_matrix() shell function (all three commands, read/write,
> private/shared, four page counts, THP on/off, hugetlb), but as a
> standalone C program under tools/mm with no dependency on kselftest.
> 
> Patch 2 rewrites gup_test.c as a kselftest harness-based selftest. It
> covers all five GUP kernel functions (get_user_pages, get_user_pages_fast,
> pin_user_pages, pin_user_pages_fast, pin_user_pages with FOLL_LONGTERM)
> plus DUMP_USER_PAGES_TEST, across 12 mapping configurations (THP on,
> THP off and hugetlb, each across private/shared and read/write variants)
> and four batch sizes (1, 512, 123, all pages). Results are reported as
> standard TAP output with no command-line arguments required.

Thanks.  AI review asked a few things which seem fairly minor to me,
but probably legitimate:
	https://sashiko.dev/#/patchset/20260519120506.184512-1-sarthak.sharma@arm.com

