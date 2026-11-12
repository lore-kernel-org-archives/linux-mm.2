Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6576606A8B1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gPVSqwts
Received: by kanga.kvack.org (Postfix)
	id D79316B05C4; Thu, 12 Nov 2026 08:30:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B4D6B05C5; Thu, 12 Nov 2026 08:30:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18F76B05C6; Thu, 12 Nov 2026 08:30:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A11886B05C4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:30:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B001D1405BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:30:47 +0000 (UTC)
X-FDA: 85426552134.05.1D7A942
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 132C2120015
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:30:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPVSqwts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794490246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIJ/B4xCXlnMR973pp/iagBmP0zyby+RS+bYxCX6O/A=;
	b=0g93t4QJiuoK7gxPrF8fiYEJqI6l0HJ0gU3oGqO+h/fGttnk7g4QFZsoootu0dLy+ZVhnV
	SkcJKQ/sy1aq2QA91QCIEVcB5hJ2hlPyIcQe6cpHOi+3zUnF7vTro0SQHkGapn/rFxVUbU
	wgzGQ9qqvGGt5COJ0siHbycUtGKEjss=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPVSqwts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794490246;
	b=mUOnBPMix7wvF9uJbpWJFjy0t68Bpj1enW9cvkk9tCuE3rqlW8Twb2+Gv602JPF6rXex25
	CQn6VaGqRvR7dQ2gAjRH0dcYVO4/t5ipPNT7j57tfHB0ulvpXnVZj5lPg7o+VaNzDWPynZ
	AEkadOBa4N4+za3DdQqlh4ghAud1iQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09BE441332;
	Thu, 12 Nov 2026 13:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA581F00A06;
	Thu, 12 Nov 2026 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794490244;
	bh=TIJ/B4xCXlnMR973pp/iagBmP0zyby+RS+bYxCX6O/A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gPVSqwtsS4+iVC1025PcArimiK7ZsHRGSfLl/9vWj0OFRDu3FHfI2SLPjoziXSFGd
	 tCksDvCxQdG6NdNpsUcKUfbfZFW61q1znvRx0Qpmku3wmIYklPB4XX6DhKQYXGaKsu
	 Xbu8aacc3lRj6gAcSN/lrVVf01PuoNk5mZjnlcQJFKlFMAcHSyCTa73yoMurgPflNC
	 +UAz8LhHJ0LNk3h5Bm4EgtdH5kI6Vqv03I2ajqOCLPe4CMU3GGMoZS/guUm46MlYOd
	 hXbG+m9rvuttdDpzt4Bx5O6QJ2qbbqx/z/Rw2dFI2uULXT/u3EvIyRvFjV0WfHh5Rq
	 hE44LMljP4V9g==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,  George
 Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,  Randy
 Dunlap <rdunlap@infradead.org>,  Shuah Khan <skhan@linuxfoundation.org>,
  Sourabh Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v3 1/5] kho: reject zero bootmem scale
In-Reply-To: <20261112-kho-bootmem-sizing-v3-1-f0c8d00295d5@kernel.org> (Mike
	Rapoport's message of "Thu, 12 Nov 2026 12:38:53 +0200")
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
	<20261112-kho-bootmem-sizing-v3-1-f0c8d00295d5@kernel.org>
Date: Thu, 12 Nov 2026 14:30:40 +0100
Message-ID: <2vxzjymigosf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 132C2120015
X-Stat-Signature: 519jgiqrh5efp1jkm9hk3orc4eiawwor
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794490245-704598
X-HE-Meta: U2FsdGVkX1/NcolJWOHOI8LJvPY1NkmJY2H8Jxh2OD4PVB5tAfc6x/9uD/j7z7OODdua45ziOE9yl+z2uKWrBfa8zY96Lz9AUaLsA1Y2chnEUcXODGkS5BUNEGKcB7XV4VAsFQeDh9JJmE14M5QvYXa/h4dnB9yHNzR0xc59G3LBcfJJ+UmflKyOtbPxRxhi0Iwj4MB7RN959vKtwEfsXUe97wwmtPM9VrRbwxaU4lOteLVazWVAqRKFUccc7p0inAPPgi2K0/hsy9vDd8gykARm+HDm/fWZGP8tI/kd+Pl8uk/VxlqN8b8/PHl//Xqle9xu9ddVaIP7EmrI7hwGYb2I+SdA/nWbdNSvTToRQpNPoddSWQvOZVy8w0asGCfOQpKZTQXNx3Kg5gGj1+boso8fiKE1qLn1eHz/OeYdGyjB+m4cPsggKjb2jvKIgBMEpx0NuLNzdEEeMs2iEPrI3kMHFVWqqF1yu2T9OsyhX9DPdAa6xKEeG5tb2KolqM4+4h/PfqCoWJZYUVOFNhgT68kGKAhBQy97W9YlfrzGfduFUOnxQbD9gwL+0yLZwHBrYr7bz/cvdQDyZJN8+HBNBRAe68gpp+LsRILGqZBUCJ6RSPCzPw3lU5PVuvGC7X1RaZKTGNpWFtPTozbH1GHYNzb4PlbYCOK+g8J40E5zNAOmlZwJKBVpldZ6lBgm9o5lBMvUvOaJDYP2hJ7zEQOzf6ifKpL+Ny4xczNSdrgTpj5n0oZkDrAPKxjsS9rtIU6byWbAM0iwwOHcH2xbacFprX9N/p1wYAYBw9gauqyVNkJa9e9tAKpXeOMuHqq1dJ989nFuG8aa8xEIoINJgUhS8XQKEdfkRKw6/YaI16rVIADaRa7v6NU5vmx6xLriG8GWy3sh2VBTYvF3QBOTULXRkJ52vuy2OTPEp9Mtdug3IATBbs/llJVhds9VxBQHyoV/mrbxpytDiMKw9Es6C7V
 f4syi/Lo
 b9AGVzqjD3tX5hPgAzq2NOpzACNqKxlocLrWw5APxWqB9POwdMP/O3jdBfvdJzbyOuQuQ0E0EOTR7T2XdJwTttN/0KmUwga09vAa1wPitefOgM8Wju+J/E0V3MwcY1DqbKlMGlcnN3q/V6gmPZej1auwqXJb1W58Anj030Q2nMdS0mIq9OGv6PsaNae1WG4rRnEHv3X3usvGs+T0EdWcoU0u+sFKwns4nFjA4mIJ2dC3y+l8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12 2026, Mike Rapoport (Microsoft) wrote:

> kho_bootmem=0% sets bootmem_scale to 0, and then the bootmem areas are
> sized using the explicit sizes that default to 0. KHO remains enabled,
> but there is no usable bootmem to load the next kernel.
>
> Reject zero scale the same way zero explicit sizes are rejected.
>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

