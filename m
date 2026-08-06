Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24549C5620A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE696B00A1; Thu,  6 Aug 2026 05:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F616B00A2; Thu,  6 Aug 2026 05:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8406B00A3; Thu,  6 Aug 2026 05:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3FF86B00A1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:49:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DD4B406CD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:49:01 +0000 (UTC)
X-FDA: 85070370882.13.71EB9AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id ADF5C8000D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:48:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H1M6zHDY;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786009739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaAAeEbwqzKwToy90LuzRfiT0XS68eqv5FapbEIYz4E=;
	b=n0aVpI5a1OWeeWX58ophwXkCXPQRb63tREBCsdcUcEDm7oD2tRjxxVmpt8rlbU5guVyfgx
	NTxmxosY1LskHl8kzwpMyeQImEUhBapfIMj18Zfl3PC6gXDELi/p4jT2F2OPmJ58BgmMfF
	5LEYPrJ4mRk20qG0YZq0Yk9+mS0ICRc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H1M6zHDY;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786009739;
	b=gWZiXy51tRsmJ7+Svulkr/9K8HZ4zs2EwzO8ca68JaerHnyzDKGur3zNH4vbUXO0r4TFWE
	3wp5GgssE6yvaYqhxGyHxZjTpUihDCQwjYwIEl+TRlD61k/hD5HcDUVpXe7PtnwK0adywa
	+Q9AYnTwcQBZtxEKf16bF3xYSNtqISc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C0F0418C2;
	Thu,  6 Aug 2026 09:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4C31F000E9;
	Thu,  6 Aug 2026 09:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786009738;
	bh=zaAAeEbwqzKwToy90LuzRfiT0XS68eqv5FapbEIYz4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H1M6zHDY7xKJ6TiAV/oLvwqhETK5AzX+0vWa8UnUQuFRXz4mXn98+RMq/TtJCCffJ
	 p/baFnXOL+1ZdBET2YZ53PL6MIZCijoNGq7xv2oYU/PL3L0HIu3y6jClOgOcsVkVcf
	 mby2UcjM0JDXqugvBtHv2tnzE30sShNr7pol4xQn1f2GBTHjNR/Y6kFPUKQ71OMv+8
	 CXAV0pUwcKSiBmpUSs4KwamCMs5Mp41rhBInVa4aJkWcpy7egqASOLKiXruSj/6Oet
	 8z00rIo6NpGTeXkw/SmuHqDm62zSehwdp3deWGr3UhHVfwMcx8DsNDEejqcmoR8b3x
	 LZ0zEMUwuLprw==
Date: Thu, 6 Aug 2026 10:48:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Juan Yescas <jyescas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, tkjos@google.com, 
	minchan@google.com, dskiba@google.com
Subject: Re: [RFC PATCH v2 00/16] Page Alloc Hogger
Message-ID: <anRRLwa3N5bVCHET@lucifer>
References: <20260806011048.517229-1-jyescas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADF5C8000D
X-Stat-Signature: xx8zkuk656wg79yypycut5b8yq6mzasg
X-HE-Tag: 1786009739-612032
X-HE-Meta: U2FsdGVkX18u27wMckl5P5CXSRxuptizeTncCygrYTJT14Dl61evrw+4NuTJydrLShQSVcY5wItK9/Jl7yuOrxIw8WFmL4HxVimTzTe2+0ZadPYJXJ1caZzzlsJg8sLQ4yELK2dSxHRXy5zvQXSf4ojKI5+/Z2AZ7utPLrUjKRg8fmyFCShMMfXwn2IvcRy9p38ZF6Oc09haNibzCqN8LoZkkpo/HIljqlLZVGBYOjeJMsh4iAJO03aUz5goCI8YkjvIKmrNV+H/LONkzDZ5DjhYSQp6AwjrIUgmhT9+dv/lErxzGUorKYsqD8qh1nJboN3GXPumaa5u8ClELEbCpcM+4ASPgAy6kMsW5ev481+GbM+rB/DIgk6utGFZBFbSA42yMnoPYBnXuiHxM3rahAaedhnBwXoO1u032gSP2OzxG4YWC9U1+pL+i4Xlbvvwq1OXYw++qyeJm1hnENA0wiPMRxT7RUo36am3Vm89YGBHk9Y20qC1TdvvrJLPCx9UZNG5yBNlycmrUelriaEHSSrxJwS8jLejw/wcBRg9R6p9j1oCTU/wno16PgBXbrYJ/82o+IMWHERUeit8mIo1j1uV0/VwKouHt9ThoZ4/7mU9O49yCUk0jK95uL7uf6tjjiNdk4awdEePtxQrjAOQlo7lCSSOwZvhCRwVd/mQY7CsIDCheT4Mc1Ksp+dCzaUk7YpzaOtQYrqFuJF1IEff0QinE4CIJ520g0oPtmhBFjwONftWb7ofTgN/qCdmTgvXOKswyRmpcL65ljDzF1PrnDmsRGMebDY8iXcGNlpbmEToER+csFuFBdiIeRNxMtEDe7AD6iLqI29Qkab5pW+XqfY3/n4xYyrLI3xl5x1BCH3nSFxljEcZxZmGlTrBTdOmmr/aZ2GfSmRAooPnmbf0alVNE+tJPdoEBcFHsQg+7jD40VxnX5ZkApJFFJX0k8/MR0bW6/+eAkhnI/q52D8
 lzvuNlzl
 DPdtwkM1HeTiUM5RIQbjTlwfgY+YWwYKQY8NdT2NgwTcdVnmlFkMJKFzKGfZA6Bd7VVXeJRm/AtQPmQH2YwQMbiSSSN42AnXIVuiHgA19rvXiWIHmMNSUGThmLva+BGnZerMQkM3Kdp/bjOEf1up5nZMHNKNWsrNRlGRE/05LmAZ3YfFD6tAxc3H8rdDHUrUElFzg0LfLLvMJ6VMqt3AxkxrFZpQeJvjmrcTCLWVJMjWgq3WmA/tSuXfuRPYPElVgHekRRrZNaJi3MRhk6b1aw1LTwytVZkgRBCRWES62dE/Ib790ArNVs2AbkVcEUdmPwqqnCA+jydpNHYydxr/PQ3SS4Ebl2qbvUvemCtMY9SAVbd3D0V7GrEkmzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Juan,

While I think there's possibly value in people not re-implemented their own
allocation injector, I don't think there's value in having this be part of
core-mm.

I really don't want this to form part of any contract or to be blessed in
any way by core mm as it exposes internal implementation details and I
really want to avoid adding extra maintainer workload here.

I'd suggest keeping it as an out-of-tree module as David proposed
previously ([0]).

Alternatively, keeping it as part of tooling (e.g. in tools/testing) could
also work.

(This is no comment on how useful it might be for debugging or testing
scenarios :)

--
Cheers, Lorenzo

[0]:https://lore.kernel.org/all/97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org/

