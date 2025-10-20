Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D8DCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 08:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E438E8E000C; Mon, 20 Oct 2025 04:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCC98E0007; Mon, 20 Oct 2025 04:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBBDE8E000C; Mon, 20 Oct 2025 04:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B360D8E0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:03:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5065D160768
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:03:39 +0000 (UTC)
X-FDA: 84017753358.04.C3B1D8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E7A9540004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:03:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nd0ZDtoE;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760947417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KdtxYTgN5v2h5htk0HiX5xDEEAlGSkB9dwze9GVrM10=;
	b=BznI1s0+9o14hIKU9Ly7JuZACaVPvt+1Nxx25sSzOdlohJPK+ooJx36Oet3TVOxDaB0nSn
	7MNG/XRWbYtP/NrSOb29rt+t27y6g8UbPvvMVKUMegdVkzgGPvpa2TYd1b67Lw2XabO//3
	QqrGPVNLl+FyqMm1UrWiVgjY9ZNlOEg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nd0ZDtoE;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760947417; a=rsa-sha256;
	cv=none;
	b=2BIOUO7ey6UNOwt2+cgLinBXFHm2sHfNmV+gziSVq1PvdhjZUJUYT0YLN9w2p1kYnJ6F1n
	15yK0gKqpROmHzMhLRCYzx14n4JnwIm8bNxEu+VGU1m7Z+/5f4w8o4ahh+onuOYESBWmps
	JhEUhhOMoxyhCv5znrLQfkZYvb8n/gA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28D48615E7;
	Mon, 20 Oct 2025 08:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1AEC4CEF9;
	Mon, 20 Oct 2025 08:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760947416;
	bh=RlHfCrz1VcpgYnaW4DqMzk0+iamM6HgIG4/sR6KXbB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nd0ZDtoEuFOr+zoWoSMvb4XzMTaYscSYSJMWOmFsE7Qxub0TAoPqFHR7bX9fFW39X
	 LkhOKYUgdo9ZFYeks2Kagf/RlYbLwy6Q7L9Djw0+WcKn3fC+iqd9r5/tiPurqJkLxo
	 FIxmJCbWLpvmL4Gf688hl/e1aM83KdUe1K7pRblXH8Jb5FAdO9XFL2C/Z0bMYcHcEz
	 DHIEyTGuFAsHD2XGYXNbQAxg5XG2KV2tG2g87NRhRkQiItfHBFGAXiVsr0M6SeNDej
	 PWhCgW8HIBEKYkVZUYhdRVf4s3CL4kA+9/Mb7bVN0j/zXlbEI6Rkm6hwBKkCBjcWjz
	 2JK74TNLMXU8g==
Date: Mon, 20 Oct 2025 11:03:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v6 09/10] liveupdate: kho: Increase metadata bitmap size
 to PAGE_SIZE
Message-ID: <aPXszzdehAbkPOAh@kernel.org>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <20251018171756.1724191-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018171756.1724191-10-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7A9540004
X-Stat-Signature: kzfjukgyj79cfstxo6dwde3uc4n7usfz
X-Rspam-User: 
X-HE-Tag: 1760947417-743400
X-HE-Meta: U2FsdGVkX18eLmrqOSHSwaXMqrzzxA0nPNDvId06Tq4e2K10PW+CKyaLtKbWfNSsVw1wxsEG9mF6iwAETTLlH2BUiJfDs+LyNRECWLawAJ0lcfqfIVch0B7hAaD6ZpUBMhLGfoL0q94mO7p7sK1w+fYBN4QIake2WdFXyi1EskgSBt/uWipWpbVkt95azBc5c4eUDhW3SeQoYexm0pv5V/s3cq6N8vdM5rDJbSYyyZOQtyyD1fcsqIzgHAbYeISWDbx0DFKvRQ5UJ5oU4JofTr4vWQIn5kBx7IreRhLK/Emnw76ms45vSEcltux3rdNVB9S9cNXxmlAG6n5Z8kKBH3J8C/goG8pCTl6tvuYoEbrC7B8xI9duqA32842ggwMzdAorrPMTrD5LwIVmeQh4DP/HgWxvcApjeyexVJzkDVXta3AqsAIU/csam4cN4uXVIK+pc9MuZBmBXrmrQvyfBMkj1ShlIvpk0eMc01/LXL5kz4N9i7G4Qusutpf3N+ZtFpLSq+AsTDlSmE5LPJEHbwFIHw3KnQJF5EWSwL8zdtTlifZEPkgJBSzmZ9YPaVyQ32wJLRzcuXOWb7tMUYTNKT+y/jBCr4uUa6o7MDx0gC8Lg/U0jUiDwqMjGztv1A4ALVLFDwY6CPzQU6H9Lli2Zw/zR8h1SRApOyJ8KRCPh0Sz+tlKpOG7lrGIBLIQiyn7EKxpvvO7hnIYuk8NhPci7xEmcNDRuMetzdMGG30B5uTA9cmNQ1q+hxOjUQyUJyZYRUlPggo8mwmNVlnx8LkqrZKkMhEHaT1ZJgq4ab+VKZ2vHSkXHE1XdsecDitmfW6hpgnxAblmxhcVANN6q77DIYheE2AvGZdA+k3LK3TY7VSVBk87Mh6yOmNvha1oUvkL0v6o6RE8dS3UcOrIUV0gHFsMK095cNHiKpDlncl/cZ47nC0E16H2xplExs8uT+zhFmtifrfp8SVtEYCL/3e
 PdW47Uyo
 xkb9S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 01:17:55PM -0400, Pasha Tatashin wrote:
> Metadata is preserved via 512-bytes, which requires using slabs. Slabs

KHO memory preservation metadata is preserved in 512 byte chunks which
requires their allocation from slab allocator.

> are not safe to be used with KHO because of kfence, and because partial

Please add more details why kfence is not safe here.

> slabs may lead leaks to the next kernel. Change the size to be
> PAGE_SIZE.
> 
> While this change could potentially increase metadata overhead on
> systems with sparsely preserved memory, this is being mitigated by
> ongoing work to reduce sparseness during preservation via 1G guest
> pages. Furthermore, this change aligns with future work on a stateless
> KHO, which will also use page-sized bitmaps for its radix tree metadata.

With the stateless memory preservation there would be no problem with
kfence, right?
Maybe we should accelerate the stateless preservation work?
 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Sincerely yours,
Mike.

