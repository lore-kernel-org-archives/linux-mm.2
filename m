Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA38410854DB
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8656B0153; Wed, 18 Mar 2026 05:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0A16B0155; Wed, 18 Mar 2026 05:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EDA66B0156; Wed, 18 Mar 2026 05:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 219876B0153
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:34:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E70FB1B833C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:34:16 +0000 (UTC)
X-FDA: 84558672912.13.4407D86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5A1F0180008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:34:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qamBkgFm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773826455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEeNeGSuoJbwavsVGKqIrrGpZX/tRWL23KECmmLaw5o=;
	b=BGS1qSOdwYrTNgx/ubrc5uY1u0v3vR3e6ZjAPQKoQ8EGWjfkVKi+iXoFwFIVA8NxnDPKXz
	uzWRSYbD11OZYlTddRmTJdbeRTaZIq8vmTuidKrkzQJkrgTAQNntRMWwTO6Wi2reZl96HX
	Tjnvf7I3gIuqEIQ+VNd2iHs5Wzt9oS8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773826455; a=rsa-sha256;
	cv=none;
	b=UBl/fhl87JmNguFpfijE74B+Ao3Fm2QiDoY0s3ghgjK2cSBmlYCjvia+iNbfJcnhCnzANn
	IqzZGxM4O2dEdMBTpflL+PPuf+nrIhSo3/RYMmRDfciUhu9LLZR6oeV4pQmWsDPBmA3Zbu
	h2R5TAotMh/lYNDWb5boZ7I9L79cDWc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qamBkgFm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF58160131;
	Wed, 18 Mar 2026 09:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834DCC19421;
	Wed, 18 Mar 2026 09:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773826454;
	bh=RNmLphyfgBoFzN7pwRjKveGHVFoZvoAzSTPSlQqJSbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qamBkgFmmvA2Gb1XpCOtLpa/pLT/8rI3SHSEPpp2OkOt5UqDx2qZT/QqYKxDgrx2N
	 auNVEDZQD45erneLBRq49YfmhkuK5IdkzUk2TUbiYSIN2Zgjj9jau8jp/2obyC1mlt
	 oiDCcn9ALby+qpo0uT2L18eWQqJy3pzpNQPrydq7ZbLA+B3GHaJ5KWHfS89obCvnvq
	 ZrNeEA9QqK6WY/l3FE9ahaKbNWHy99ZlxS0hcpwUnQMDVYBgBM3bsPBLYL2b1SekYN
	 sXCLHta8bd6bDdmYU9TPJnuA114W3jzhAU+OFP3XBQTOMiDMgACy9H3dKiD5v54H4X
	 zdUI6ziOS0f+g==
Date: Wed, 18 Mar 2026 11:34:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Clapinski <mclapinski@google.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] kho: add support for deferred struct page init
Message-ID: <abpxj3hOmNJlodvF@kernel.org>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317104625.fd6a006871dcceaceafe990b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317104625.fd6a006871dcceaceafe990b@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A1F0180008
X-Stat-Signature: qzqce9dqb9wuurcn4ajfhi6r3bzthrrz
X-Rspam-User: 
X-HE-Tag: 1773826455-192096
X-HE-Meta: U2FsdGVkX1/Ayz8EhQFK0YXoec/UQcgYa1TnCF47GjBAAftb1OGZRY1WmmTBQWwHT4cl8cRNg6IbHODlcSD3lkuggAD5g75ABcaAPptmectHew4zFd+X1Q0eDgBfthlqINsVZje0m/6071oF63LfEYdVIjDhcb2JOBfbQLkW4hPypU8Dp8ffiTOYqGRyiEy7uL3E6KZp2nYqkrfwD/yPOJZKIQTOjT0sbndm6QivbGq9DLxWyWMhyFuMEt0t/wkvcHqeoHbqUjrJBxWvrNkDcvl+rTyPpWC7AUv5C+FeGqOpulfdGon+CYDZl7ytrzuv2v0+PNBS/53serW27wGo1X0tnmKjdoaRYe+Dotf4saG8DAFfd+SjCjpxBaRrNfnJtRncukDpQjOE3iRoquLO5iir7oL0wWi8/ahLVVpH7+vIwssyyecJNV4ibHdCaDrj6Ct8/egE0cklV2EF04bije0s9NyRzLt8MU/K7fZovAtaZOUbgWBTEVObPl0ZLXlknTtldad3ngbgR1j/MG2HTRIBhwi6VfSjVczDp11zBQsJkpWDxU91ceh8A6ye0ItaRijaXp3F4tr9K5PZSkvVj3mBmDoA8RGbXfFLo/E0P2dpKRNzq66l3s8D0B3IMG5EuDa/SR+yHl2VUDvLRm86R+CvBlwtfblct6GEAlRN1xJQp1jtD1rCFJx+85bjpQmG0uo4UfDKmwdCbUFR4JhUs9BauaNQL/VH1EPnfDMaF7Rk31g16gn/mkBs7gcAV4KqeU0JFsM6VZYF7zlDJaeU5yM2813ppYyMXwJyO/QrRfHL20+5+9RrAbf4+vBAmPYh9fiNAtXVXBMX59nl4hRSi6UAbbCckTC96Jj1Zr4jOMfO2gn4t6HTEJIU6LLIDTplxxHt+hdTzbCcjaJAlU0S8DrzPzcIrx6mJsrR6oPjEsljHKQInH0kdg0fNcreoolLtlh5QPGvxqO7E46qwob
 gxWEMMSk
 7R7DHDde4PzMDODLkGtt2tpXaKKC+xlSwVL3x1LOK5vdkLOPWAQnSH8bM6VmyiIh3c2TdxkfHVdSxkAQgjjfNMwGyQck7VRMhjB5Vrsgqp39fRONwbVNuZfRA5pWS3qvbo0HjJYFrpvLPe6JPzKMOGwfMrWXVkf/Q5P/qnTJMFfSwimogTTq7t9ztsKUTXi/2fNnWoynyISfs368MXpwZeBQYYCjAxEw05XTcB/3LTB/R/qbo4v/7u0p+J44kBDSMbYVrXIxz1gw72Tdf80HkTQSvvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 10:46:25AM -0700, Andrew Morton wrote:
> On Tue, 17 Mar 2026 15:15:31 +0100 Michal Clapinski <mclapinski@google.com> wrote:
> 
> > When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is
> > enabled, struct page initialization is deferred to parallel kthreads
> > that run later in the boot process.
> > 
> > Currently, KHO is incompatible with DEFERRED.
> > This series fixes that incompatibility.
> 
> Thanks, I've added this series to mm.git's mm-new branch for testing. 
> All being well I'll move it into the mm-unstable branch (and hence
> linux-next) in a few days.  All being well I'll move it into the
> non-rebasing mm-stable branch a few weeks hence.  Then into mainline
> during the merge window!
> 
> [1/3] and [2/3] aren't showing any review at this time, but the

They keep changing because of review comments, that's why there still no
tags for them,

> well-reviewed [3/3] is the meat of this series.

-- 
Sincerely yours,
Mike.

