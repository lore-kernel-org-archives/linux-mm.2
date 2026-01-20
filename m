Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C267DD26284
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266A16B048F; Tue, 20 Jan 2026 13:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4296B0490; Tue, 20 Jan 2026 13:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A1F6B0491; Tue, 20 Jan 2026 13:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00ABE6B048F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:44:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A77B1C19B7
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:44:18 +0000 (UTC)
X-FDA: 84353217396.30.3CE4BF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E394E2000A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:44:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rfna6mHD;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGSkGElZi1cLOojEet4P0f949OnKsvKzNEf/YSqlH4s=;
	b=I5iHOEOhTXjLTNTlktjv2a7ktq4UJkWj1lNRzy6JiHX7DTu17KAtHd3cGlPe4jVHluD9cy
	SgDdbRSY86zEefVzp17Trzqo3QMvaSXAuWA2v3pNdVheeYdpffLVSz4KMgFSbtrhPTT4xQ
	l4JZu8pzOD5Cx+6ZFgynE3OHOb/kNmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768934657; a=rsa-sha256;
	cv=none;
	b=8UOsQ43fGgBqkgx5t2w0GkyJTgkZ3XsL4wv/Td36wXgsoMxwKQrNnv0Iaasis7kKSDds6j
	SfQCW8Gfeh/uW4NVEYLIHbPy0/TMhthpu6p477JghLdbrDyhmBFSJ6/3tPfTiXzxwA4V19
	3O1pKYOcAKJ6Q6y8OYI0dvxn3fCU6L8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rfna6mHD;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11AB443D4E;
	Tue, 20 Jan 2026 18:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965E4C16AAE;
	Tue, 20 Jan 2026 18:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768934655;
	bh=+LEXTeoZdMHLGFiNXxSwJZf0gVNOtmF4IeqOGsRfK6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rfna6mHD2LRS7oTOemBIwJdZafQvXxTBtjtJzov0cI2eTcGpPOxG9WzD6132eCHP7
	 x9MV32MZI4jUaUJTgYTtDbBBV8NGFpQtkeIrRss0itkOoX+8rlieEhajWmM/qOzj17
	 amnNjFssKpPSpgx1kz0SfcUbuZDuCj2rqAFs2zmDKUmSGo25kf19/PE4WuwHaKjcqd
	 WAqLKOUi9ZOnLtdx7VUJJ6x/o/1T1d1go3OlbaRW0W+ZMgLMCFzxk6WMbUYL3YNAps
	 vh5SGjE8mhhzYLZtfsTncHoQIshzuWqT3upKMLuEZd/uFM4y1DkE1uD0IrGoFzBmmY
	 KnJq9N5FZYICQ==
Date: Tue, 20 Jan 2026 20:44:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/6] kho/abi: add memblock ABI header
Message-ID: <aW_M-HYZzx5SkbnZ@kernel.org>
References: <20260105165839.285270-1-rppt@kernel.org>
 <20260105165839.285270-7-rppt@kernel.org>
 <2vxzqzrkckkv.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzqzrkckkv.fsf@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E394E2000A
X-Rspam-User: 
X-Stat-Signature: jr9q6qxjf8xmk77u6a37ajwrh4e4wxcy
X-HE-Tag: 1768934656-817966
X-HE-Meta: U2FsdGVkX18Gf6psTuXhBhaOfzEs2bp3wUNUrnVnEOFWDi4Jw39rPT2r7CWVXjPWKJ5tYIAsQhkHHA8GsVau2v+tcbFSINunlr9UzNPLeSrIGa4f7B3iLNkY96HTvVEPqcP/zNIskN60Uzwi+HG/QW8tCkDFBJQLKG8XQ49Dg8mTDKXneTUew4HNk8WRG/+HWCq4XS7YIx1c1aLmHEOkewfqT+0vgXzLWfLBV1mKwHvKCUpYWj82yCJweYt3TfnZgzMu7BcrcvjMeqJ5cbbYINB9r25bsec3TiZVZark+JJ0jl3ZgqQVIgYiSIM8C92CxGWY31q0jP+zi8VgRRnVHn8NcyMFGxTj34MiENRPy89/R816URoRoCvobArOx7KgLQMuG9ZnubA56QjlNuYvRkIttmPvcr6nJGvjMbqqjq4g4hG5EBp7WDvqCgIqiw8mzsUnA8ejXt47oXzMPLyGm0EeNttFuBn3K0G+EkO19khAZ2Sfcoa447kYlxd9Qr9VMgE2bdtonEw/b41ZtrV+CUmbzSAAWFvOZslEbdXRpP3aFTYOsd71qNXvi8T1I5H8qVgeBuZQjLgsPO2i5KZjRpzfdBLeurJWw2+n7r3bbeuLbVzXCQ8KZ4LHuyPykYiKdWC540UFy5yRPrAsm0xMkwLnWBBhM4CWHVk/2se3KFTaUrbqMXrB5RhboyNKJEB3gTzrJfRGykhEqwSZUal7wUwtBi2oqHBgQWBjHf0SXUZ6aYXUzn1SGSqOlIUdbBOVLJkt3Wgrpq8UnXMGZ0WgWvzVh9wKo8qOyLnRyU8dSS17Z3dn4P+WIyVg0ZIIVT26edEy2VzBvg4/CjkJ27TmwHf0QgyY+oDxewdZ2v8lvvRQHbH79C0fgrh4NZUaBq71NM3RNlz57nLDoMjjt2X0HwIOF2e6YE84ShmEjIg8meyhlfhuJRInJ+oeWqzds/iNLTFc/HrGBgPAXHQcReI
 +uWWfDEa
 298m4B7yG8kDe4acHvMParehlB6eryxJt4CTiFNIvx0kc6ZaMM8Xu2mORNzAT7uqVQyB94LB15Pyh35S9aqtKoJwqWtPAgrPdGKnt0iDhtiXG6445Gdc0sUSxwovMtTMllWMWtZ/hURugq8yQuF8pfebjwbPocIIA8/16LNC4GMSJ7n8cHuXKhQ+RXGR/3xwVMuSLu7KlLzqNjtkrJuvnAsi8+TfUvAjmPubMYpRMqJShDY0Wms0kCec6JlJVqVVxYvIiGqp9uozZK9YAfir5WVmG0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 04:31:12PM +0000, Pratyush Yadav wrote:
> On Mon, Jan 05 2026, Mike Rapoport wrote:
> 
> > + * reserved_mem node:
> > + *   These nodes describe all reserve_mem regions.
> > + *
> 
> I think you should also mention that the name of the node is the name of
> the map.

@Andrew, can you please add this as a fixup:

diff --git a/include/linux/kho/abi/memblock.h b/include/linux/kho/abi/memblock.h
index fbfb2eb1b1cf..27b042f470e1 100644
--- a/include/linux/kho/abi/memblock.h
+++ b/include/linux/kho/abi/memblock.h
@@ -45,7 +45,8 @@
  *     Identifies the overall memblock ABI version.
  *
  * reserved_mem node:
- *   These nodes describe all reserve_mem regions.
+ *   These nodes describe all reserve_mem regions. The node name is the name
+ *   defined by the user for a reserve_mem region.
  *
  *   - compatible: "reserve-mem-v1"
  *
 
> Other than this,
> 
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thanks!
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

