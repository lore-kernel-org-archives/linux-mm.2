Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B4BCCD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 10:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26ED6B0005; Sun, 21 Jun 2026 06:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8086B008A; Sun, 21 Jun 2026 06:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE836B008C; Sun, 21 Jun 2026 06:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76EF26B0005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 06:36:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B03728DCCC
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 10:36:26 +0000 (UTC)
X-FDA: 84903565572.16.0A2858C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1FAC4160003
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 10:36:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVtQJTae;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782038185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7n88puASKdRn7LSLUIyKwIUjfNUuhlCupcWE32IiKc=;
	b=4LTVf4J1sCBbYPIuQ2Q13fMsSu7dGzb9LpC+eIqkSSYxgYuOZ0tj2IiKUBCVAGE/MteezR
	TlGvkw32XFEGNxGEEBtI6zZbBj/N99V2dH7sAtrxjfPRVNHSI5qatgrIUbR+AeNQMZjVEL
	5ikoU6qEiu6rf57wBKj5C1vC07L9BkY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVtQJTae;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782038185;
	b=cI6Tu4qoSAePveu1nVNQotpL6XSPs5ATktr1NdvB6i10GfLm10+IOHPrUXPszU8MT5YOVn
	QyxwvxjoEfTFMm2LSeY0blhC+tnYE+DG3pgB8fy+hLVCxDRQchrl0cRdXKBBiB3uM7FdXr
	5Sek9UrIhcuPpAbBOWre+faTEd2fQRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1D3A44298;
	Sun, 21 Jun 2026 10:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3726C1F000E9;
	Sun, 21 Jun 2026 10:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782038183;
	bh=u7n88puASKdRn7LSLUIyKwIUjfNUuhlCupcWE32IiKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bVtQJTaeCkbJtYPLyIXvXF62RPr79fPksVMk14M0zYNX96o6mnHvZFPA0hibhxeHo
	 eEysclkiI4gdSzS6seo2lZ1GnN0cHxD0OLsUdJs+8fu5GWUOojKTc7iVwSQNWxCLkz
	 NeJujBZLVSZmSKqPiolja65PdQe2IWZ9KbYqagJW6TagyYy5DsGI/Dfcn4WqhlCDBK
	 NdACIAkSoyfexQTpPgAhSe9jb0ppgaxsnx0VTxOTB9EkT7naGOqv87ArIiEGUexrqE
	 J+MmMWHcvyWBIENEIWGKWU6/aNbV03JUxv6U5v3cXrfQpAfileqR5zL3eFY2k3lm9C
	 Ap825Q6Z+dW5w==
Date: Sun, 21 Jun 2026 13:36:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Shyam Saini <shyamsaini@linux.microsoft.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	tgopinath@linux.microsoft.com, bboscaccy@linux.microsoft.com,
	kees@kernel.org, tony.luck@intel.com, gpiccoli@igalia.com,
	bp@alien8.de, rdunlap@infradead.org, peterz@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, enelsonmoore@gmail.com, kuba@kernel.org,
	lirongqing@baidu.com, ebiggers@kernel.org
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Message-ID: <aje-nY6QbwZP9XLG@kernel.org>
References: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FAC4160003
X-Rspam-User: 
X-Stat-Signature: itfh6crcd91eer6xdxgiu6fojmhwyeur
X-HE-Tag: 1782038184-583555
X-HE-Meta: U2FsdGVkX19b3Vc/9DbUGoD1PSGpE6kZnYDeB+0jqs0/CW5Yrklzs3PWy6yXt5o0qW+YIYw0Dp5vNnDv19OwyVBeUUUhUqaJE+9Jy1k2EQacK1x8yHv3MQKwjdzeDpfvIb2a40GNqonLSuEBKQAYStLrkcIcNx7Rm+CkSktKuzpd8VbMjEsDcZ95ouPSEcwvlVIz5Fyl40rQ46uAgRO0iXyX107JjOXWKtIXYHp5envNWBs2ngA3vCFy/b6N7vYpcaVYyEUIzzP5Dd2vBVuinLr7gF//drU10TJEgww1zKaQxgtdjxQTFxTURbp/dmb7ldWRspiPC2LCdVlHiAK5yKwaJxcsurHxR07/EaZl0cUAcV9OW+f4+zLlL1bfDWi6coZD55iFS/cTuyuHJbg+BGp/LFouRC1mXV/4kVYbVXNAvZpEI1pm8cT7TxqC/Wg1kTrRTo8mAu0Rwq6rvr86MzjuSkjAMCiDV575VFYq4wzE0bUxb+zgiFuy31fXPzowMW7veq71QoRWWjPtLEBqPOTg2225a69E6dNCIxFLoA0DDmcJJ1pp3zN6Ak13yaLwNEOxC0Mc+X4XV1a3VIa88DCngFnyQ2Cn7+0Tmo9cWknAIGF9QkLWCsMnLMkK4eC6r97UTTot7ibPSDG4o9XoNdDGa270zniR8tsmljdSqdIWQ+Vb2Bu0+Ji4lKwtWvGNQuXbvMx//ZmvRUkOnvh1a1ElFbuRce3sx9Y0B6rfDSu+11Zk2T/PF3zLwhuHJWYcV33u7y6fM/NsnTPiYNhV18YquY9TOT527LQanA/HJIuiSm586v1TNNKzMKXnj+91YNVZQCF2wLHjezzrD83nS2mXM2M+Y/XTI9SPqWzoYvMglx7LaDPPQOy3KXaoW5hO54+AArgRh9SF4xH5+5NsTKdmPovRx7U6Wx9F2U7JO+lPKJ/wz8/TN9XMZavGg5gBZrQ9mk0m0gJ2glKjR4f
 3gWwdB/K
 +dAAEr9yvtCm2N5+I2i2MlYpp2eEPkaGNuUYoMJsJbcXws3x8L0gW7XWt2hBiBAS707N+pyPloYvSHlzbnFn2yivhf4InCbf9QnvX68AUqZA+TLEuYXzrCTUFuZDqXqOl0b9NsgfIb9polDDw1nBvdI05U/6CEXR7kYSonXz0HZKOhgCqKI87pas9fTZ75M2d+pn5ZqMPHkPt/7rO431CAF7U7U/zlS/S3hcWW51J0vAsgN7CdnCp2OwzQ8dQKbqluOKduxPzK0uLdG4LV99NmNRO0txv3/Rk949dMNQQfA4CIHtU5QNembimQ+Czj7W5lnuuXfyWBlns1EAfhUanKHgfh35lnNYTJmqSDaYOK2NXPC2bFaEN4L3sDbrXp0/pN3ifNgtGlsvoNo8xpwpGCdbLAS+ZX0sbl9bn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 11:23:31PM -0700, Shyam Saini wrote:
> reserve_mem relies on dynamic memory allocation, this limits the
> usecase where memory is required to be preserved across the boots.
> Eg: ramoops memory reservation on ACPI platforms
>
> So add support to pass a pre-determined static address and reserve
> memory at a specified location. This enables use case like ramoops
> on ACPI platforms to reliably access ramoops region with previous
> boot logs.
> 
> Also skip the parsing of <align> when static address is passed.
> 
> Example syntax for static address
>  reserve_mem=4M@0x1E0000000:oops

reserve_mem is best effort by design because such hacks as well as memmap=
cannot guarantee this memory is actually free.

If you want to preserve ramoops reliably, use KHO with reserve_mem.
The first kernel will allocate memory, this memory will be preserved by KHO
and could be picked up by the second kernel.
 
> Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
> ---
> v1: https://lore.kernel.org/lkml/0eaf3be2-5121-48b7-aeed-196405c0a480@infradead.org/
> v2: Fix code logic and incorporate Randy's suggestion
> ---
>  .../admin-guide/kernel-parameters.txt         | 15 ++++++
>  mm/memblock.c                                 | 47 +++++++++++++------
>  2 files changed, 47 insertions(+), 15 deletions(-)

-- 
Sincerely yours,
Mike.

