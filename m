Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57579E75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 12:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96F416B0005; Wed, 24 Dec 2025 07:02:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C476B0088; Wed, 24 Dec 2025 07:02:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828B96B008A; Wed, 24 Dec 2025 07:02:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA046B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:02:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7DB6135111
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:02:07 +0000 (UTC)
X-FDA: 84254226294.14.0ABFCC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2D14418001E
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:02:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FY1b1b2u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766577726; a=rsa-sha256;
	cv=none;
	b=2jvIpdh1Ljoq3pcg6yXiMorBYd4cJLl6DXGMZoBKIzwBXqViKcELjz3ZWMogVTeK9r3Mnn
	17ac5uYmQRK6sGpFmMSAXholeKFDv7aeJ4sjiAols7WZsUTvhQuaSUOf1LUsy3KuSy6LWd
	datC8ybrkBS1JD0Sm1JMW8XNaQeeOW8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FY1b1b2u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766577726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BRazb//YpBUuXuQsI7NHiELei7PSTpncdZMv9ssRZN0=;
	b=D6mgaSEMDe+vGTY9waD4yjTpP3WfCxbmiiO9Dk+vwSuW6I3PTS4OvEZcOITN/vgDsLkZXk
	hgquiJ6VmMegtIQaiirmZZ9s8oKwjX6rx/cHdcDx7GzRxqOw5R4IF3NocK/eSQ9oQ27+ME
	/SAbUM8fqtTJHOIBH7dYY0R+gQQj8O4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 248CE42DBB;
	Wed, 24 Dec 2025 12:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64201C4CEFB;
	Wed, 24 Dec 2025 12:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766577725;
	bh=uBPqXxyHezu6KXMQBRpWZz+nm9zp7C2D106puhEjv7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FY1b1b2utCFXPMdOoq8ndCNnjTuXNaW7HmED9XfyIybn9/6t4O9TBn6CrzTWmRCBf
	 DzV0uk8sNGWBHT0e0hIJUUGnFPYUjyDW438hnokF+br63eXJfp1opNni5v2uh3xMHn
	 EPuLx/iua/0vEldXwaiE1aTVrKqT+IgrWn5jCTM9EKb6e0Rb20IllUtj34SGr5zowJ
	 1AhUcBmkCZziavlIh6PfLNzEly5DYHo0poNTxs+al9f1yoz9Q4NyW58X7WsFXoqdjX
	 gof0rFbzXjx98ncanny1FHY1o5Vr/pKtrsxnQITJXnPcY6CRmzOnLvG8tGwfW8pkYV
	 gdXFNgVCx1agA==
Date: Wed, 24 Dec 2025 13:01:58 +0100
From: Christian Brauner <brauner@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>, "Darrick J . Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>, syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH bpf v3] lib/buildid: use __kernel_read() for sleepable
 context
Message-ID: <20251224-partner-eiszapfen-92104956caed@brauner>
References: <20251222205859.3968077-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251222205859.3968077-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: 2D14418001E
X-Stat-Signature: khsz5szfa5zgz5fo5nd3jww3yrwzdqhb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766577725-91628
X-HE-Meta: U2FsdGVkX1/ZtLVdolCccam9+6eoA4Fe22Zba4GXObDxAY9eIQHdMff1e+VlA1diXOCRNs3UzlCp5Ov9sEXn8sZ/VOKQX8c8EEaluWgAk6SNtPn6RORj9yTPV2k0UsVLuAC3JzZZalD6Hd51rM7Fo4o1W/R/EIcwweIpjQW9V2SWLneXG7rO0lxLyYW/77m9DcWQ1sMJLeqgaXdSPwHzHPHjOKkEtbao4eT1NpUb0gavVRYGoD9cL/gIZ649QfTG5aCy495aakskGoiD/VclB4QkjjeiiPWxKaaieY4Eg/CGtHcu6b7/iWHKA4scA89hQhqmSNG3kXFtpIW42ZDkJ8mivjnbOzhrK1qaH71vkQmBiV7a84kSnbqS1OPFUoPGdujdhfWWZJIDji6wwjGrdeUXsUBT58iubrna5BMuZe6I6QFz+e9ndcuElJyYaiIMZmW7Bw1JbGjWyTR1l9JmlKosBpWQeNXyemiOZAVqBmkSQRuo3vElUaX6josJaOA35x3mu+Auukl7CiMLyTAhF9ADqnQf2x1m5Yz4jULKErS6FSUJ2M46lxs6Tl/E5xr18+x25/OwnNWJ0d+/qpfcGF1xOyH5lehm87wW4N6vD2K15VSb3Tz6EqT4hWeCm3mikrJCsfr5cnc4tbzentJKkH9KfCLFFhwB8HOYOiJUuUXBaPJT8Z3vdkNUs4hs3rvdJ0wdkYhmZQXZNABbI6DUgVMypmDN6e0PmgvVTi+GYRkYv07q5Ufy8e6wpUNuujZm4Le72T8UUY/rb5Lus71iGecYZitxGaMeLNsI8MtUqPqJl1yfmgnudpRUxMsHNwDdyly21BZ+eMWTUpw/fJfEJp0byQPAv/kLo9oqtRE0CGcHM7XLp3TWYv8B8DhlGIgigiLs+KAbdHW75eVuPhm/1jFy9KfcZKNyd0snVqusAjvr/h4anGp51f21x++BHlU2E3uivC0xDr3R5TyLizz
 O/OQfU2l
 JA8eEW0B2WZylHsybAIQ82cEIezmlXKAe7isC8+nS6wdNeUY7nHr5nOc5rSPBxE7rYrUz5JhKaRyRRqbYkE7rOcbXwSKC3PmTl+pZHt62zzmgVo2kSWtagMySFKvpWapJu7IUosVF8E09+IurEzC0vCBgmfX8u9i+eetxVo/QckD2BzablXXSPAZ7HnD/IIfxFTcojCTbdTBwlMBtZgmAHE685mdKQc2eK7i42OMsbiINV30X34a9QT4PlCHGbONF5fJCEjkeEoEztpHymb/uwjycGUdfJT1xDYGpBsyVWUSy+Sd/+AkxSwIQigMJwKjgNglH8EV767yEGTrqha5oBQLP/GaAwNneGrbCG+ARkh16CqcoyIAr7qKMr+pN/AyrIEG19d7onQFIKgnEa/F1naTuubHXHcwOQbVvdmGBG9UHqv6DVaCNqfSbMSZHKJRoJCi495syZ/zNA9GY7JcuJfTHnPs70IMk3CuIapYg7SOs53J695F7y/BWoJKKmJ2e6WgyMXxo7Qtiph+94SVyPYZNDdrhrdBxEMYRWPFxFNnalBocpoSn9L5pHgKd1z3FYqK1IY+n2P68K18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 12:58:59PM -0800, Shakeel Butt wrote:
> For the sleepable context, convert freader to use __kernel_read()
> instead of direct page cache access via read_cache_folio(). This
> simplifies the faultable code path by using the standard kernel file
> reading interface which handles all the complexity of reading file data.
> 
> At the moment we are not changing the code for non-sleepable context
> which uses filemap_get_folio() and only succeeds if the target folios
> are already in memory and up-to-date. The reason is to keep the patch
> simple and easier to backport to stable kernels.
> 
> Syzbot repro does not crash the kernel anymore and the selftests run
> successfully.
> 
> In the follow up we will make __kernel_read() with IOCB_NOWAIT work for
> non-sleepable contexts. In addition, I would like to replace the
> secretmem check with a more generic approach and will add fstest for the
> buildid code.
> 
> Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=09b7d050e4806540153d
> Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

