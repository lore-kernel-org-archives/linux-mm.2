Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B4BEA4E19
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE78A6B0093; Mon,  2 Mar 2026 10:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9056B0095; Mon,  2 Mar 2026 10:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB1B6B0096; Mon,  2 Mar 2026 10:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBEEC6B0093
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:00:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DD291401C5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:00:25 +0000 (UTC)
X-FDA: 84501434010.10.D61AA63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8A41240022
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:00:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pjqz1Pt7;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772463623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A89kf/Bwbb8Dohwa6arG6XODIkceBQEutwJ0mGu13bQ=;
	b=kWWxfY1BEA/73YVx/sCj78eQ00zJFdliZRtUw349c+cILNbvUcGi8NXqv4CmB17ufATD8a
	2dyHPSzYFAxv+H+usD86nHWTC9EE4rseR5JYS6EzJMCCbK5X/nTxemF4rPDiaPDn2VolkL
	4IDS82nVBfHOHap99HnabincGwx0XAw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772463623; a=rsa-sha256;
	cv=none;
	b=3ZNYodfoGUB2qm0HQtOyAbiW/0ishluy6oRnQ25yCClWpSoNX7LDGKC4kGf+Fl2dB0loSH
	tGjd0/M2xhDm3lbrSPYSbC1Vx013ec2crXeZshoFBrnZ5F54ywMtVnNqWDyc0hQ8Fv5ANz
	x2UwVEuE2SwIL+KQjY7qlsCFYVFnBMA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pjqz1Pt7;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0425060131;
	Mon,  2 Mar 2026 15:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B8BC2BC86;
	Mon,  2 Mar 2026 15:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772463622;
	bh=FJrfEomTCPEbX6pYpVuRyP6uRh1ciBrKEA6HVw8rwRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pjqz1Pt7KOQNJWbPfUWTxKlJ6WG9y3JkvBJ4JiRh6boUz8fOfN8tjPI61CyR9A+uy
	 G4IGFfo72Cs5pQs78PAdkM63S8AaY2SM7xWvgGMaTKPB7ILa+6lW5P3Z3+D4BDCHbf
	 FkwA97dJVEPf68XPURr+PBk5+OXUtcHh50d1h0QOG/zLkypHQx0vvUlxXHbV3ikYj3
	 81k1YeAT7FzR3TXZpZgQ3UEZ6oJWRsi64pgMsCdjk+Zi+XBARDoPos1X2c+i1AUAex
	 5V1CU7nrgbQkGmK9ta/mSL5+DDe+apFefPYr/GDAgXnqSWNk6N8dV3Zw1MFjhHhmPC
	 67UUFjiPoiYkQ==
Message-ID: <6ad9abab-3241-4f5b-9116-7f4bd880b117@kernel.org>
Date: Mon, 2 Mar 2026 16:00:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] hv_balloon: set unspecified page reporting order
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org, mst@redhat.com, jasowang@redhat.com,
 kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
References: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260302111757.2191056-4-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260302111757.2191056-4-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A41240022
X-Stat-Signature: 5zqapighsmf7czpsndrfhwjqwwyrt4n4
X-HE-Tag: 1772463623-804742
X-HE-Meta: U2FsdGVkX1+ubEl464mwszgccQ3g1HIJH1vvOqDQehKbNCihrVFWuwdbm72m/20uchp94dNnAdUWnA/gpRiJGTYBwK1k9XRGVPQAyjl/w864KOD1ojQFhq+lOCjQR5gOq1UvktyRBVgRk5T6O4M2FKMocnroLfyhVJf0mvT47B1H2stRfthP/F9//N8IPx/X7yeSxPNU1NAZfnKOVmcQPjx8ETFMMzOgCjzX+ONND1e4AmKFZC9+iXx8+5SZcZjKTFjo4BhRm87PmSm7OH1wU6wT10NeM1I4nCVklfkPtsQIud6IE9gU9n8rwoedO4i2lWbO17Q9fWCJ6SgCpboQXg7kKqCHBwud7hW8FfBedqcYq50p9ogK0nUmwyNurV/F3vLj8WHDmR/kMwGg+hol4TSwj/kt3Cux7DSsqjTlPe5gW8XJn05vp9lHRMHBH96zLgSF6TpzcLJcsWqM2g5pA1AXUQPmSJ5XuNQALxOdzboov+hR4PoHz6Y/WufVnph9WhQNiODOXZ53IpsCIfsv4queJq5+JSqXWyTPV49u49ZgRcCzYypVkToXJ7nQeQTcaCYxbPA4eJI+Nemc93AIwC6s4ZueE/HYMXgxE4yJOJv4r2Si85shC1+n7J9AZLiKTuQH5qG20ZP3Us62ZgeUB0O2KZ+DmzWyf/8r7EOMZ0yVMvfDUowrHc9b3W3xPZ0Gh1ZdWwf6quTfqeU4A4j2tqX8Lv8LfXHnK8y4O8Met0FZBRMazF9nzY3DQUTkTgqNQvXo8Z+w9WiOlXMBf37KWQma/1oxvAvftBap7BUBDUh57jdjAZ7fRMqHG3wZZ/+pTtxxo7tMm0M86IQIAWX+IYmkIi2xjr/opZ24DLJ9xHbouJpfBzWiM2jOnxmpZCK/+Gl7gV+Sm6nS394s3n1T78/cuE89X+jEI4BuMcgY2HGJnSzHi3O96IXeYN5CSp4WFjcZPoRFlMhedQ4Pecp
 QmlZackg
 uAoFAyHQhOfnnNIZXYEjBWL/WHBa0ZPjkp68Yyyhn2eJ7Lw0aLfy4Yl4RNWSxyt+ZzW8ywR00LRrYEj3m3Dj+ElFfEKeBZPDFi2rQdUO6kWYz/X0OJic7a4r1VpA8fKpwwj1F52DP68IFKoXdqHKXhCQL2ZZMp5FTtIS4l7echvBhX8T+1FroC1HzkspBcT42v5ZFnsTxJrcLa911ZzCbBHkZxqxSz24FEkV1BRK1FSHZfr6tMNBShKAsrrztgN19RKcenNb3gmXfVXOKZjPz3OyVsi4imwQJ/t7oyPtj/HStnKikBexLceEPgQ3TwtrGuqJTCIysXlm9kOCGKYhwK8Ye1CWhEMOHvBNP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 12:17, Yuvraj Sakshith wrote:
> Explicitly mention page reporting order to be set to
> default value using PAGE_REPORTING_ORDER_UNSPECIFIED fallback
> value.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

