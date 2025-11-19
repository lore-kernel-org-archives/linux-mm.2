Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFFBCF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9BF6B000D; Wed, 19 Nov 2025 10:55:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65ABB6B0011; Wed, 19 Nov 2025 10:55:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570A06B0028; Wed, 19 Nov 2025 10:55:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 473946B000D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:55:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08E65160533
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:55:12 +0000 (UTC)
X-FDA: 84127805664.15.8F9F3B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 53EB740014
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:55:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZHNRg/4V";
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Cmpu4dlPICQ7jEZW3q9WrL3LoFxSpfQ1qa9NR8USio=;
	b=Bn+6DQDJeAqLq7t+SHzuCVi6gfUFezcjKtpVrsTvXGA4IAXlMQJsUQkGRL63rQpeLzv0NR
	2LGTB1+1WhXzxmS4llTy85Ewzoj33mhK5FIFMoulGrMf1pnrpwc9+eEEdfDRF/Ck0ayyQz
	FM5aOpDFSpRLStWQKDsCO5y8/fjsg30=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZHNRg/4V";
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567710; a=rsa-sha256;
	cv=none;
	b=FOjspxes6I5lQOIPi5bY3dz2hjZX8XSIkTz57digt3fw2TVDpu1CWHX34dPJdwIs9EMB6x
	snmroDDtTH4c8KdDpLjgANIm0vK9bdteXTfrVY5zg48clA3JLlCxylB6Qrt8yAg6MbLYJW
	7U+u9kxdVJGcnoKIg4BLHj4dtvFbxMI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46CD3442FE;
	Wed, 19 Nov 2025 15:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C35C113D0;
	Wed, 19 Nov 2025 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763567709;
	bh=gjDP2XYX+ovocOAAnCbnLjruEh9DhHdieIst67As1IU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZHNRg/4V/VlqnzWuKRvqScmKkGA5uOlh8+un22hhoP2BOPO7yDBoSWzRXLxlUCSjN
	 da8rWk89W3/awMVc4m+xhFUOF1XxpM/jCc4vcpHNdv4FVpYx35Ht4KQPQYJpv81vto
	 G0MJwcyuMBFQbX4yrbE4XXw0vBIPCTozn5HrwbIsn0+R3aYugExuJjlavubeRKWSma
	 isEAg9nLiTFySCB5VfdL0bnb77o2vU7Mxkl6M0PGY58R+LTlpsT9olP1QVvEJXGwul
	 Ng5nR0UVCzKTcEzFKSgj4CCPf7W2eGI+qjyyj/hT/cln4EqIXXerX5xYsZPX9N22X9
	 GpNFfEyCnmyPw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Mike
 Rapoport <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  stable@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add test_kho to KHO's entry
In-Reply-To: <2025111944-tracing-unwieldy-1769@gregkh> (Greg KH's message of
	"Wed, 19 Nov 2025 02:36:09 -0500")
References: <20251118182416.70660-1-pratyush@kernel.org>
	<2025111944-tracing-unwieldy-1769@gregkh>
Date: Wed, 19 Nov 2025 16:55:06 +0100
Message-ID: <mafs0wm3m2f1h.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 53EB740014
X-Stat-Signature: nxztkg34i19omwxg6yi3qczo5odoyeg4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763567710-551345
X-HE-Meta: U2FsdGVkX197pPRFIRtLDmLuHtZAfAaHJAfL8pgouDvGI9/+usgqMlH/NH7qwIzg/2bwVaXDlk3OOp4HdTbiPHYcu4WpcweVqVZIS9kQTOksE1TFxTDdqgSuxl/1ondPYqD152IwSX4OjQLQxXHAnRIZEpMCvkenKgcDUXCf84J92FTsHZJKhiBmoS/QDizueDtjQiwe7JUvzewK6urzpyYEByMBBLv+AnsS/DZBWrDCNtoHvd63N/Awy90J5sNCKMo5c4oVcnatMYY+DeNQlDO4xsLVY0UqTm9xddSiGbfQ38usdxoiFOJvdmBxPDnLmyq1y5rVUeELit7mcNS8Wl1T6fBWAgKA5tpxHyLnQVoDSwoQOsEV+X5wkjooS8M4Kjnw7D1NoMJUrHNxGXa8aeObEx85UXs/VwvU2iSISS+Sc5JCi8zAyvjCOSnQJoGfSc7hU9yxJMv29qGicftQN6yhCuhQGUENvl4eF/Ze5FR5OmTQDGMZDCnr7pX8jcp1cKAlVxsYWuwg9xJuFedQ3fJFcLWH7RUg4D0URLIVcxxEf2ZN23HQ6HdX41gRmj2u12bUUNhxmH0KXc364drTVxmSdI6wTwY4DruGbemcLnfkdCzDxpqYqLfZFRGYJmJFr5U1HLh7dZHy4vXmjka1kM+HcUkctYy39LjPh7MFcuXfWhcLIbQFaiSyhY1jy8JCj7mclX7OuycB5coMIjwE6qS/cPTRbSD/QAm5/w+uGKvXdknPiCa9thsxFJkhJU0KXjtJrbmJoPXZVI6xm01r/km84pU8JS1fC6DgOyFDqmfqsIlgywUZBQEbbitNd38UUuaDXKqNmIagnODekY3+re8RcxMsBUiNyuuMaTtKqYc8Hox+MMN/zGDHEwqMhsrC+Jdw/85mapE3Tv+Unzgpp8GIVNInapUe8nubZWFmEK+isAievElCtZ4t5UG8F7E21j8KTMBE9f7MBY6NR17
 sbmIfOjl
 6QsTpZ3d1e12NLHZfqRrUDjrymhB+fj+KOmHDqsnbSZJWFjd7J9kZbXtLXVynkBqG/NiKHjHSBftUobg+OPcGL6d2C5+J9vZ8lZcDS1OneL8lDfxHBz8wWCdnmNau9Vzko2JX0pjHDUcFGIsy5lDWUMt1SzMPMLSzQUyE2GV59iqyo4anBzlKIDbnmoNfGdHF4yHctx7c0wtwP7WaBEba1F4E1OTburGLfJ43Eu6zmMfzpWe/lQFQerGy9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19 2025, Greg KH wrote:

> On Tue, Nov 18, 2025 at 07:24:15PM +0100, Pratyush Yadav wrote:
>> Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
>> KHO test but missed adding it to KHO's MAINTAINERS entry. Add it so the
>> KHO maintainers can get patches for its test.
>> 
>> Cc: stable@vger.kernel.org
>
> Why is this a patch for stable trees?

If someone finds a problem with this test in a stable kernel, they will
know who to contact.

-- 
Regards,
Pratyush Yadav

