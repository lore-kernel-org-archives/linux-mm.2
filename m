Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01948C88E41
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2E76B0089; Tue, 27 Jan 2026 09:43:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67AD16B0093; Tue, 27 Jan 2026 09:43:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7AD6B0099; Tue, 27 Jan 2026 09:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49EA86B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:43:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C0BBD29F4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:43:22 +0000 (UTC)
X-FDA: 84378011844.26.61A0746
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 80F3A140002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:43:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jTI7IY1w;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769525000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t599xbmZE2GB13LKvdMLpDhqpSryEGxxihUq+rs7ENk=;
	b=J7EkfcvQ5B+Jepr9Sn2fRo3oSOONSjQDP+An3wuge21//FWLTsafOqAs3sQPkWUeT1p7KO
	daWTDigscVMt0yem2oH6gkobS18WwhJ6wYfe5W3x+6bCw58cvMNSxqA1w/rLJ5GQgoHpFR
	n+7EhF/yU/YkyZo+eT7cWWWyGf+LwfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769525000; a=rsa-sha256;
	cv=none;
	b=aUAphK7iP46N/oF5E3WOo8Epdh6bwiQJjvzEcnDXPjEdzUEOz0MPvr/e5PUVvHv/Sl5ZHE
	7kQ/2e3p0AWjuTo+WhpHTAZgXpG4qvLdQdUFH82wdZB9A/Oq18BxB3MhlObyvKJycX7Wzu
	IWwlKQodgu0ZpIaQ4iGDfnq+RW+LEYs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jTI7IY1w;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0271960133;
	Tue, 27 Jan 2026 14:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0350C2BC86;
	Tue, 27 Jan 2026 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769524999;
	bh=ZGQYIyfjcPJn4+omCcIuFsQUbHXUEiUGwOQtBXIp2c8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jTI7IY1wCiHRVzID0jaZeAUCCEVb2t5bMxEB+keEfYqAeKCU6tjToAwpbqp94zCgt
	 ZOi/3R6PXbhc3Diq0i4K+Qqlfpf9xl6zkkQ8yPUjn2ut+K1KUDK8k5gznF/pstw0kq
	 YmjMTarMzmoPa3CYXoFHK1Od2wuANFJwZUVBRXSJzjqXe5hlIMHmVvnWDQjLaCd/5g
	 a6040u2uwRYXXHq51ZVf9BHX8tn1P7uOQ/0PhBuxFt9m6MoAqNd4ttqYHXUrLItStO
	 8gR854yvXHWPSMhGI4voNwPZXUZcyqOjZfVn7BmzvR3bV302jYavlkgViFN9lQ5Yss
	 vQwxlS4AkL6wg==
Date: Tue, 27 Jan 2026 16:43:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com,
	riel@surriel.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v6 2/4] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
Message-ID: <aXjO-jQ2_pzVcp9o@kernel.org>
References: <20260127-kho-v6-0-56f9396681c2@debian.org>
 <20260127-kho-v6-2-56f9396681c2@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127-kho-v6-2-56f9396681c2@debian.org>
X-Rspamd-Queue-Id: 80F3A140002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 94c6rsc3suop7hgyfycfr4478rt94eti
X-HE-Tag: 1769525000-820431
X-HE-Meta: U2FsdGVkX1+8EMx8u0oW3hsN80OYGT81Z0LHAwdDrtilOxO71B1a7j2SyV3Z6maJRnMoRkPFsxeKhY2nFrmGJLT2zIUyWKeoj1EBpR7/7skXm37G9zp6Fifzq79ekwUJMRV6L0E+iiV0uPKmUCvg/g6DsV5fl8WqS7wnSoapgr2625u6ML1kHq0Xg+PINDYqqwTAX8m4RdaRxQE06ZRmcpLCGc9ito/L1wXvSQiez503g8Q7HAkF3lkycv1CUcpIqVovb9iOp+YhrJg7L513yMcnFxcLBA+2DYCGIABcPErpLGqnvlGCjdZoIr2mkCrWy8mEyqnTEPLN9k7La/eTMHLWKKYrjzWqAtcE9Y0e3mF5fyeqS3ejSjnR3CVPxeBitAquCUgCgdHNxy+gVa7lvSbYXYU3f4eeiI5HsVpywo/uIgGiWfCytJGJKhOlBlRPshfEf0qVQuZj15Ga4CBcECNmAwn+vzIgtokskcr9kcoDcaBYNo092tRyWH14UDY0pCuGDZDOIe1KLBKftBNL20dFZsE0zT4XvPs0g0eoNPWmgnXAh1xWDZExsj3o9DtDif+/x1ZvKhSlb3Ro29c5cgbg5LVu2Lx6BDuGauG33j3pPvH+iEiDYApUzEiNB9C9iNBMkouBVSllIRVvuYJq7HyGrFWRPEOdlebN+yE8NcuGslzCqEHNrPQgcp6AVrnFju5xQi8uxzp6N/8WffSmaB77+LJroQy/7rEnqJHt+ILz2UGaz/dya/vt6+3+hwek+BxRiXoUrUgIv1GrnyK2ptI9bM7m4YY8EixXXKX0Jrwl2ChGFTtVcLIFBDZGvljg/m9ZyRmHlaNe7M92YvWu5laJKz0sF+gTrxxgsExFr3KWat+ayJ6KISEFONEaGvsjocRDJZ6AIzL1+3pg7X3JO0R8FlOzssw6kaJxtkPF3P1DFw9NU9R28w/FuEUoLZ2/q4M3DjQrr9g6JYcqAYw
 Ef3GlFJM
 LJEtP1VXqeGEg7MMGeEurjK+LELC9nrRJg4FzjSyyTHZGJbIytEb3J6cQdr/YkmsGZVgD8nl/sIjWuBftoq4bZdYkUnp9SLaxWYlU/e+h2zSFP+dy0pbGRVWNlHyOmeAfCIxD43LflE1sCVEGZmFoZBmAn3h49KK+Yogp6ZN053O93RqMUVoq5CHF8V/ZSdUvHQcY+eB5J8fuCAeVMWq72qW0jZX/V+VMMwPcvDg0qdI/eWeCsjZ2V5N+Lt+xeHQ2GX4KdPlQ5W0iLyvzbn2XyJyjPrZQUar7vL40U8eoZrT5xVXBN55bosfDri513tUsISRmknXqCLEquoNEffJ0Tppq01H/f8fi5OK3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 06:37:37AM -0800, Breno Leitao wrote:
> Since kho_add_subtree() now accepts arbitrary data blobs (not just
> FDTs), rename the parameter from 'fdt' to 'blob' to better reflect
> its purpose. Apply the same rename to kho_remove_subtree() for
> consistency.
> 
> Also rename kho_debugfs_fdt_add() and kho_debugfs_fdt_remove() to
> kho_debugfs_blob_add() and kho_debugfs_blob_remove() respectively,
> with the same parameter rename from 'fdt' to 'blob'.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

