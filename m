Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F82E6FE23
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 18:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781D16B0005; Tue, 23 Dec 2025 13:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738F96B0089; Tue, 23 Dec 2025 13:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B2A6B008A; Tue, 23 Dec 2025 13:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5486A6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:06:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E757B1401E7
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:06:47 +0000 (UTC)
X-FDA: 84251516454.11.BE531D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5A565A001C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:06:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FRKXB5CX;
	spf=pass (imf25.hostedemail.com: domain of namhyung@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766513206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEereEf/9PxHA0EG75icsOpp3z6uKrPJc3+NiNjat8c=;
	b=1YhooTAEUzR2lJLsoobeskeTYwWICLulmF+SvbEDSztqB/dukkAHe5WS3fnt64Cqg+ni+Y
	UgoyxbmabPBlN0J4T8HAuqpnjv7kQMW5ThgbXKhbHg6BBEk1xGPM1zBlqzgL8lfoQ66TcJ
	KJDa4/C1tZ1yxYLHJ519j3egat2h0Pk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FRKXB5CX;
	spf=pass (imf25.hostedemail.com: domain of namhyung@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766513206; a=rsa-sha256;
	cv=none;
	b=xoekWEQmesPqr8CwvwVxlw9Es+boKzZS/oe4kuV9awl15x3Lq+9OtEuArJun6CiPaZE7Ac
	/MRRX27rPus43Nm5b0eS3uUlU4uUz0mpnNwMT85RwM0q1nOmOhNH+Qu8tQo+k4itdcbZDX
	8kdIFVRd/Xhh8pLV9OLWA/OFVjNQ01Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF6E460143;
	Tue, 23 Dec 2025 18:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D467CC113D0;
	Tue, 23 Dec 2025 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766513205;
	bh=p4oE+5o9bN0kXgNRRBGEZJVGoL3abU2EiA/DKtkd5rI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FRKXB5CXPr/2qVqWwBw3KOJ2f+ZjW8AXTnkL3tDS+isZzEVGahJ2O5inD4lY/sQ0Q
	 v9Sy5UXYy52nuEjM3+RQ+UZx3EfRzlBTTKT2aVFkCsDpcWTaLGGzVuaPY1mVXn+cNW
	 BomlQLRSEBlHCJgMdJq5KAolXb8+xjkQ4oONZoXT/zsI1NX2hnpcb4Tp86oPMl2lUF
	 0VDJipxWpp4R44TpryHQN4AIhdyOjJV4dvFZsF+ctKsVNCgeeScvVDkEQL85BvahRI
	 lhm962IHjpzhvPZNLL11W9//slDMK0zaeGAoczpqQ8AAnuWGUTGrM01RXn03PY7DEl
	 wR6nMYFqZUhfw==
Date: Tue, 23 Dec 2025 10:06:42 -0800
From: Namhyung Kim <namhyung@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/11] tools headers: Sync linux/gfp_types.h with kernel
 sources
Message-ID: <aUraMnczL_ba_zes@google.com>
References: <20251222225716.3565649-9-namhyung@kernel.org>
 <20251223010057.4135-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251223010057.4135-1-sj@kernel.org>
X-Stat-Signature: hy4y6n8xa3udm184xj9adhgd46wi3wx8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A565A001C
X-HE-Tag: 1766513206-309940
X-HE-Meta: U2FsdGVkX1+6CM7Kx0ibpipxlMFm+MvcHakjXTuS1OfQr6xVb4yyHzPIO+2jTPKsOsk/BVReSns+jP05pZLsWg6uN8MtVHgR6+xHBoKXKZOugB8oFA+WhMS7nm1KkGsa078e6M+0Ga6BIs3Fz8KCQ4WOWX12v8A32kVi8ZdITcn3RcF3bJ4X3/qeOW1kVBDPCi4azi7QMGExOmmjvCwBQ9gPr5K55+G7lRt5QeBcca3OqaFP8pL22svsATLaV7qsxzLGtWaPex2Q/rwVJP8Nbk+mdfkfAVQdnomBqxMTWjoCwoX0mhXt6HnR+/mTIhjNAzhyYBXrnlZowwjTXLDhNF8fzNu3osLc8dskEf4PYwhxYyRPDaP7BDr/y7vLR3cYvBk13cdxglZpJAaUB7v4M5AJNe+XUtjXUVFuB+W8pbFKVJ04+PzzJ6diYJobWj9tHI905HtaITYeV3MxodPz5nC1RdmCSOkV+vDhPKJmTG4JFIKzAiu00R5QrcNXZMdJ9aiV1BkE9ysLLwtjDxD4GyHANwhmZeS0Dd3WT7R0TaKUBA2HTTRnsw3l/y021HLOQq4TWtOiS5mlPQ8y6svGvtcpT6gHybO+wl1senNxDDDcvoFJ1pzFx3jLA5x8jbD45zWImCINbbPOT7UxMaaTyPNmkIeBkLRIHxinZcpMgEiX5zZBMwiaPHe3BuZ50pwjxDLx1Cw5hFBUl3OL6uiUx0zCYFSaexdlB0zskG2BePDIv8Kzq4xCFr5iiUhItjctVGdt8HrM0/OjNR+TKNWGjiqA2hk/RCcjK+kh8Xx8dSXK+oRXgs4RQMej+OYT6J/fl5uo15s3+QNm2QZZ2ZImAVW+hqSLO7Kwa3gF7R30ERRyiA8h3XKieksfyl/Eis2c3AqLXLinib3sj0A850OkQMhmG5hAWNlB2FyzbtG0cnT0bU1IU1yw7IJQ6mpsfU/nGOi/Wp3jK8jnOp6gjir
 yMK2enzv
 OKGgt533MG1qNS+fA1Kc1jZMuojHS1ipmdydGjeBKqNG7WQ+h0ZYurb76vLroLLIOrVHasUn/8+Q8PDEmjNty1yvFrhZvQd1t1IwYxxVMS+ek84zsVQk0jJPFlYMNk+ccwuYXxr8A27a27yJywkZNR8dSm1cQ7uKJBRf5OXnbGluTqH6ZH7oy7XiZpiotcP7MqU9ZBOhMbzbBZrzZwuIEXur9susUv2oCmZLMcEnULuQ7/dPYAOJ9XZCFXxCt+5PV2s4pXSNuSslB4zhdKzNX7Wv80sL3DunibM+jefVeMw3JCMPm9Sp7CjRpvRwbcBTQr8nkz0fRrxdtdVpHqlBPRW0va/phn3eoVaC+KM2ogZCFGDuAcNoAJvUNTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Mon, Dec 22, 2025 at 05:00:57PM -0800, SeongJae Park wrote:
> On Mon, 22 Dec 2025 14:57:14 -0800 Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > To pick up changes from:
> > 
> >   4c0a17e28340e458 ("slab: prevent recursive kmalloc() in alloc_empty_sheaf()")
> > 
> > This would be used to handle GFP masks in the perf code and address these
> > tools/perf build warnings:
> > 
> >   Warning: Kernel ABI header differences:
> >     diff -u tools/include/linux/gfp_types.h include/linux/gfp_types.h
> > 
> > Please see tools/include/README.kernel-copies.
> 
> Nit.  I don't find the file on linux-next tree.  Do you mean
> tools/include/uapi/README [1]?
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/tools/include/uapi/README

Oops, you're right.  I've used a wrong template.  Will fix.

> 
> > 
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> 
> Other than the above trivial nit,
> 
> Acked-by: SeongJae Park <sj@kernel.org>

Thanks for your review!
Namhyung


