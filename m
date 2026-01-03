Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA80CFC6182
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 19:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76076B008A; Sat,  3 Jan 2026 14:00:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57736B008C; Sat,  3 Jan 2026 14:00:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56A86B0092; Sat,  3 Jan 2026 14:00:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B33F76B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 14:00:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 296F18C1D6
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 19:00:00 +0000 (UTC)
X-FDA: 84291567360.10.73AB382
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 936E640002
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 18:59:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=daWX40jT;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767466798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxmRlp16vnAjFvCk4KFlk0C7OnwvbDobH+tqhbPlU1c=;
	b=owfSty9VuYmGy2bBERrHM5Ceijkll66llZfI1pPFG4hfEoPhRG5NANwnYFWRbofN8eATRY
	cuZdNipzllqyNpCV+mnhuWfR4qCRMZW00ZlIfd4AJClrav1xP+Pab+Ya2yqz75BpSQQQNW
	/S2dmIpmkUWLk5paPPZXblI79L3Mcqw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=daWX40jT;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767466798; a=rsa-sha256;
	cv=none;
	b=P0AgWH8h6ap0ZRHOJ1RZKUwcTp2nu9v36TP9Jyg8fB7NzeFAxKIC81ik5robiqQDJYwrwD
	biHz3OtDqjvyJQceItgllkdcxEjMyD4cX+mvImjji9NmCrWuS4oEe17m+XN3WamujmHQNw
	nIdYsnyTF4meX+IAV7KbKTfUlk2V2qM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09ADA60017;
	Sat,  3 Jan 2026 18:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB19C113D0;
	Sat,  3 Jan 2026 18:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767466797;
	bh=omBZBCfeRSyWOrBJ6BZZYx870z71q5DnTs3+5igQ37M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=daWX40jTgv4j4LKq0g1uveUBTG7eo9odO7BGheJ+fHT0MwEC3l0Y4KRMLSyiZRN26
	 /EWuxz7s0xZI3PadQZhOcP8+upJrUpGh7VZvt1smhEnRryciGxID8pD0bA3dEYTDfk
	 5dVz8IzZXmPQAtm51yk8bubc0zvEhxgjzCJodcyGJOMRg65iaqQB08RPukYR7A14ll
	 JoYjx+MPJfr+DUcgeRKqGyukoBzyf0mHZaGEZqZxrGEUZR92ATGKbDGEmZa0DlPKH1
	 /3s1IFM4fEayAHdcVSTRMBfPN6zbXAuwXUvaOYPkBuyInEZaUdd+quJLeV962G7uNv
	 BqniYHmjqzleg==
Date: Sat, 3 Jan 2026 20:59:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/4] Make KHO Stateless
Message-ID: <aVlnJZ7vN6-FEL6z@kernel.org>
References: <20251209025317.3846938-1-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209025317.3846938-1-jasonmiu@google.com>
X-Stat-Signature: m96tiogugswcajq5kub93kr8zo4ujagh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 936E640002
X-HE-Tag: 1767466798-627887
X-HE-Meta: U2FsdGVkX18fZ71J8TQB80IvCMEpWNc5IG94G1c0d1iAivzR3PfVQIvH9g7v6KzK8UHHCW8TNs4/5dcJOOTATdDB/2M7amK1tRtmfEnDHVb6GG6LKpVUtQ7dE4FfSbR8DNAc7wihyOef1/x8My59/IrU8X+AdxVfi+mEqSg1jjUC5MHqfFvNf6+gRC2GjeqoywHaMuBL5UNFFpaHEplYyHS3OKvh9wx45sSrvCXIMS+K2GPW5Je/bR7f2CG7E6Yiqxijy0p/8MtEbsAAydSQT8e2OPDgiuGxkdjByfCHjlP+oTc0Nqq1QYQMEqiAGf+ac4Xtxeum8yohLTTpsrODUzvlOGYA+BYG/tg4rQSqAjMvaT/sD7Cd8AV7d50Oao6Sl50Hmou1vlGEQsoGfmKpx4loXMQjHLUfHT6NK/vsQOa+fVqXcrsBMyJAc4cc0Os4D5MJjpaY4IsZ0Wfhk9XMy5aDC5C8INFoebfVzZf5682T4krGeogjqwrqRa/fqcgnU+Unujy1LYqJGwq2Ema1PfOraQ5S4GCSdXeaQiY/MMb6C1leFneUTsp0/+s0+4lzFtpwqZEr33rSAewV5WiVgSG71ILq5jdzpjNvfnCas5PRyz5EPO+Gnz5APRkalUWkJrHkAJx9rejE51IrRDBG2Qq8Xz7o/9jnUjA3YGMVRkcCGzlfTdjb1Ri8cAHS9Xr8SJMgVU5BM6QovuvJhAJPNN2n+yot3avjVMfH/4HG+XuDcazNIVVQYytvyPyMNladSnv6+CA0rfE2HgrkZansvy1/9+J6t+dckBXD1EB3YDBTrWvcc6YDkqXBLQFYim+kE2zJiU8YJV7o/YuYvY7hezu+/yllO0wuGbeh3VXVwMazjhRGU0ufgDhmM3pkQ7RtPd+ewxrzNwHbamaoFLXavKHiXzU6XyDtgHiSEoExDOGDHTMwL9g/Wg+SW3EC9NaK/zQR5j3sd6JA/Bfabtz
 dPKjLA32
 OTRdbuCt9h7RwWdiSLe0aSEOWwibp9V/FvMlzkRRGtZAkmtPoKmu5/4tkWtohqBZ6TglO91IyM3rz85OZ0LWSdREUV2DnDjiq1JVQIJGC+YzBESVnYbBQuXYRVLByHuTirXDqi35/Mdsv8UMbyKo7IRlDABV7+D1/KgkspXEOVsukePKTXtBuUlUcHwi1MD/dq7fUhiHbCPDcFb76/Az0zppAOQxSUi8lXTFRIz1WvWxkgg+AmlP+OvHkR16Jp3juobsnjIY91fP+XhM8CV54ZlwlMOt85tPkNAwqEdwdxD/npVQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 06:53:12PM -0800, Jason Miu wrote:
> 
> This series is broken down into the following patches:
> 
> 1.  kho: Introduce KHO FDT ABI header:
>     Adds a dedicated ABI header to define the FDT interface.
> 
> 2.  kho: Relocate vmalloc preservation structure to KHO ABI header
>     Adds `struct kho_vmalloc` and related structs to the ABI header.

I think these two can be merged independently of the radix tree change.
They seem ready to me and having them upstream will make it easier for new
KHO functionality, like e.g. "kexec history" patches 
(https://lore.kernel.org/all/20260102-kho-v2-0-1747b1a3a1d6@debian.org)

I'm going to prepare a series with these two patches and some few more
updates to KHO and LUO docs and I'll send them in the next few days.

-- 
Sincerely yours,
Mike.

