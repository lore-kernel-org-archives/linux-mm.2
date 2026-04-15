Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258AAF4384C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456976B0005; Wed, 15 Apr 2026 11:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407FE6B0098; Wed, 15 Apr 2026 11:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31CF26B009D; Wed, 15 Apr 2026 11:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23D846B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:35:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48CFE1B8045
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:35:51 +0000 (UTC)
X-FDA: 84661190502.03.B54CA5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9C1E44000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:35:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=USzvepqJ;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776267349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZjl25O3xkFg3hlm+EDY1MLPEwR9xGYjw2OX1nyc+Nc=;
	b=zxb+32OEN/xAIBOOqm3crc7gvtiT/aAHsWyu1B2mYPKceLP6P6IRVTC3TmYC//yZbTAcbX
	VffTKFvrbdgC2jMRrfnpXdtcxmIU8/4aEtW4VP/+D5fn3AZHnOKC4NUioxN3tEPPhfHxKG
	91p8bhlKSLS+n5cpiItm7SH5aBr1EWk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=USzvepqJ;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776267349; a=rsa-sha256;
	cv=none;
	b=ga/lvQzFYbGHIy23E+gQ/qBYB8hFB1Byh/uVE7rJ+GS48kMC+L+JbfQYM/COu46lbjjmrS
	QMcjNzrQkUhpHLlj2MT0lNTBuRsbOa5SZ4MEtwSr5HnDZFYLpfpfs0oFk/soRz+iRvgmAj
	0Q4NWHsTs6F6FXKwoHd7LkttHlmA6sY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1FB9409D4;
	Wed, 15 Apr 2026 15:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1AAC2BCB0;
	Wed, 15 Apr 2026 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776267348;
	bh=Ikv0Ta06Ao9KyftfJm/r17Sukwd2geSANmn4udd7V+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=USzvepqJlJ+ljNLIY8vRep4l2fDqacmIF98vHX7Pkhxjqg41V1wggCQ9ohOGr/jrK
	 E5O+ceMCq3OHmTkuMhLovkklqVYeTx3QG/4qs/u416wd8KffAep3qlYekeKTttfM01
	 MICKk3wcrrv8eSQ8nhTjPd7I7Coxa9dj2X/+LvHVgUBUXlzqTah2oMjVaJl3bDiPBW
	 xoYAGfSgi+bDmAWeE9RGJMI027dWjr+qULu8bRIwATp8G2gBzc23OLzIF5KcR1hp8z
	 cD9Rn2hOMTuj583wTFKpwuKWVQL/o+n+rUGQ1D0qDYdLkECgcvLevW0b08XAmZsREH
	 vZmphXEezHphA==
Date: Wed, 15 Apr 2026 18:35:42 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 10/11] liveupdate: Defer file handler module
 refcounting to active sessions
Message-ID: <ad-wTlt8-FsZpbh_@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-11-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-11-pasha.tatashin@soleen.com>
X-Stat-Signature: wjmtmy7fyzyro98a9mtik5pjaraa1f3c
X-Rspamd-Queue-Id: 9C1E44000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776267349-866982
X-HE-Meta: U2FsdGVkX1/v3vEISIkq60xPUni3A7oGVkEVoqzmHVc+N7FxFsGnMARg39xHYf2EhvS5RuE/Tv1NzbYTL7iU24a9dckhZnIVlHMh5eiZJEzZHpR9vQhp7OYGBmTFTUYijB8HW/xXqY/C2L0Y8n5M+P2SYs0cncfxRTF1u3E8IpStVJ1hsUwxHCvKSEgmt3GKRfVgx1ASicVO/lFMMwskeCaBptn41kWr5dv1KxMTDYOO641B5a6l66tWOQ9n/oonf2GqpAuBLX5YUrovnPAszCrISPtE+4LCouyG0OsKgTV/FaagjErrPx/oInNFhAqX7tSDr0YypHSql8TlVQPIurj3v2wZ03aUxIQrxPAFMVRg9TK7A05rQknyyHvtsoZ23HHzf0RzcRnJSiuMH99DlpmrTefEZ2cspcxGbhLIINfA164swLQ/QqQvzYq4tV9cFdL1p8547M+QrKmfAsYgJGEhE07kdpUxo0DWSbbMN4GS6Qa4yJ8zcTg9EbG1VqxjeYciBZ5V9v1mvekg3+MxNj2qHlALn42IIBHKgGpsYnyrtL1JXxTv51IozNWOe4nf5qipJodHkkT/PKCWnEovNhz8tbw5ppRVtYcVk/HmzcDIztOrSPuVLUi9brorTTWKkItS7X/QkFRZt4mghLSTI/qsf0ommlsmw3AyhDyvcBBZ5Pa0rPROEjWJk1ae7VnOqWWxHe2XOW1OC0AkisSt/uljOMCZ6DwABEZvsKRC8ZmQH40PsNO9uaxfnmdsFvMMFW2XQMQduBNA4broNx9KSLZmnoAeDZdGwQhGpr6EOlJcQ+GtGOFt4P2qHochHxzEPdc/j8KimwCurDUx35ikfUZIHwxtUBo7RjFfvtpAS19pEgP7QoJsT45r6iW7BlhBsUjtXKunYl0Nr6umW9fMIFG7Beo4msu0DDHF16BGATPCmbcZxzWt9UA2F4wJ2GiIvLiA54MQ99fDPXXyGBj
 ArvxoGdP
 PIqJNtPl2Er47uEOHSMhZ6t17Kaq3i2CCvMQBeWyrQxx5aZqPvrne2pzx69UJgDEtJu5EkC9grXkyM/dWqXHrNsFtOe/6P1ZEESqfi37Ji5q6NEXUy+Nx1ulf1j2+WSBs5aWaXV1LOeHSjZ4GWxw4qeBgMzk4n7CSVCH98iZjdtYkagUnFLde8fHCIPAitEa3daLWSVhmGoAbdHTImIkOPXCjuG+6OrptoU3gFW33/j5jIW+mBnUUb8V4YoPssi0ls7c7uhAf+2C1juBIH09/g8MB5ugUZIZTCcUGO8QkkOmILjQ55tgEzE6EcY0p1AriBwUNWAuAyGUX4Egnt4kOKr0AEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:26PM +0000, Pasha Tatashin wrote:
> Stop pinning modules indefinitely upon file handler registration.
> Instead, dynamically increment the module reference count only when a
> live update session actively uses the file handler (e.g., during
> preservation or deserialization), and release it when the session ends.
> 
> This allows modules providing live update handlers to be gracefully
> unloaded when no live update is in progress.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

-- 
Sincerely yours,
Mike.

