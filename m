Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0858EE6689E
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 05:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CEDB6B008C; Sat, 20 Dec 2025 00:23:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F5A6B0092; Sat, 20 Dec 2025 00:23:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B756B0093; Sat, 20 Dec 2025 00:23:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36B5B6B008C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:23:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC14E6026E
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:23:32 +0000 (UTC)
X-FDA: 84238706664.18.A0EB69A
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 21AAB40006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:23:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E96iMTu/";
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766208211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NH84hFbT6mBoGZa2DFioRDPIdMVCGgqrsbMckQDnZaw=;
	b=oQI9SAA+brnzt9o6vjDxBaajlFf9vaMJfdhku4D2QYJ19nxvnHqAXT/O9OOajbWf/Zlx78
	xuOqoC7deosGeISmC0EWuvpdIuE1vUuUJFNeEYvOcgeYI5GpgHr5Bdg/iArvrrTcALyV1A
	wRQfD9Z27F+Je+ESeO2Otl/Kk8Oayng=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E96iMTu/";
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766208211; a=rsa-sha256;
	cv=none;
	b=irpKxgxILx13KDTiqyRiQUSjZjrr9jyfrYsE05stUOID7+TX3C+cFBjQyNKrfowIrZGJN1
	0mUX4oz6C7kncc/BdeGhdWjsDHwrf/3ehcSxynWPqzinu4uGifAgco2fSX1DEowf7pMPTS
	uZhtsjCPKlHWBYDrWLC6/4HWRZJio3Q=
Date: Fri, 19 Dec 2025 21:23:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766208209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NH84hFbT6mBoGZa2DFioRDPIdMVCGgqrsbMckQDnZaw=;
	b=E96iMTu/ccj8rZ2OJ88bXrZmfzS69LJE9K7c+HWRq5tqJTDvsXer0hLUATLYsIb/S+392Y
	68swuO9gt6T7oTDcCCQjUzxYAJAqjy0tpD9z3NtC4Jm8S4LviqvjUsTSL6gmCIC5iFcBue
	mvxY2QGcrGxDW/bBXlI8lcDc5M/rtzM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v2 6/7] bpf: selftests: selftests for memcg stat
 kfuncs
Message-ID: <cipotudex5346rnml5fnzdghlnuhdtsberlhmmphsjrvjyy3bh@ozwywiozr26v>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
 <20251220041250.372179-7-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220041250.372179-7-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21AAB40006
X-Stat-Signature: qfxzhaqd5ixtao3ztpurzkcxbwxax9po
X-HE-Tag: 1766208210-734793
X-HE-Meta: U2FsdGVkX18V3yYKNnBFIAa0kXBlH6x/K9JiGrZp8gR5Sf5d4xg1IK+T8uWc73OJf7fEjbLV/EPPgD/wArCG0PhqeE1/bMcTsQHYJBjPrUa4MStXB1s9uBCiWFLT0nvbG1eLPZ/SYW4KX96/cRqJctjdhUWaD+yngvUcChDaz48rcRYwlqMZFZSE71BJEWatE7d9OhwO1SDNzc4ncc3j45Vy/skpcLa52Mk1muls9pk826GRZ0Sv2c3hYTIRpwCdynk2r7dIDMGiDQX8xnEqExrlTRJodqOsCd6UjYwDsSaOgsfPwhg2Fc6ZUwnV92k4/Andnqcwr33Eg7zU9s9jLtil/FMr46hrzrc830gVMKvORg1wZGNgIqb33yFuBC6O8xiOXl6+o9v1fkGjEiiD4+kOXaCMy+mGAfQ/8aCnfHrynAxdMq/OoRC5mCQTn+sT/SyG7aYaxDKX1erdmp+Xa791hRnyr2Dpotg9Uzfo1mpXR+rcf46svKC2TKPIpeS3APpAC1go1LWtkMY0J97EptwYROCit33YmfxNn8yM1p1gnIJ8qP98sRYqx2qdF6R0aufFisKjQ5rKAbSJClkOfLgqU+29+wWjMlRH3MFZNWu1RrPrsumsy+ZzU5BGLqT+rHePfgdTHruyorJB2h3TkT8yOt9vgap1OH+5yPBIIip92tOY4s2wz7X1UzeXBEQMdITtkTugi93tBQIBiUoEvYEgUPvvLy6bWN3Xn/jVxOYNjIBx7jjhUG1rKf+pi2sCmuk1lAOIZluhnBexzM/9MLfOX/2BKH5dcA9MkuMmmSLAUWFVFssXJp7QYtVcmujEbs+66IYbc/GH8qIQQJ8EPb7r44cOsTfjldx/0d+GZ8E4bdIVF+IsA+yR21N+SbrUHqHcta0P08dk2JhfunUFMOarC3C9HmURFdIcaQTorISd8CSaQ1e4AfbxR4lgBdyWVkmoPgInfnZ4uJu2UPL
 1Xkh03OM
 IXTwUM7E65kz3hc2Nb1o0NSawG/rOOOOZVyxwVxQd1OWB6CNdYB47peQwMrbwf3cnovSlX17sBUb47/29ua9mPY71Kwfv/CYq/OjAZwFM4QydPi/fadYK0AF0/BYZ65g6MCgAuPUdQLxIVi/Jj5xR+G6H/z5uPtR6gTaprMoMaIgMy+fhvW8rtkFjpEXkUHrLScSf5FCv+HDlNDYemFut+bJogtKPrTgcY1jvEXcMVrONRZ64+B1OC3Zu9qneW+ENA4bEyICp500YreBOYIGDInb62O8nsJCg5bHt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:12:49PM -0800, Roman Gushchin wrote:
> From: JP Kobryn <inwardvessel@gmail.com>
> 
> Add test coverage for the kfuncs that fetch memcg stats. Using some common
> stats, test scenarios ensuring that the given stat increases by some
> arbitrary amount. The stats selected cover the three categories represented
> by the enums: node_stat_item, memcg_stat_item, vm_event_item.
> 
> Since only a subset of all stats are queried, use a static struct made up
> of fields for each stat. Write to the struct with the fetched values when
> the bpf program is invoked and read the fields in the user mode program for
> verification.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

