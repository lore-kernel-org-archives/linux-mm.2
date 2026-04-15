Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23301F4384C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF636B0005; Wed, 15 Apr 2026 11:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7873D6B0095; Wed, 15 Apr 2026 11:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4E76B0098; Wed, 15 Apr 2026 11:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D68E6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:34:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B28B8BD3C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:34:09 +0000 (UTC)
X-FDA: 84661186218.28.F87C359
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 80CC4C000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:34:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMJlnArs;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776267247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZ2Kj6v6uCZk6BVd3QUk5da2h9BTon6LMqfBZaxMEW4=;
	b=cBEoYrTiRysclK+ifdLd1xF51lW8HFQBgLcmI9ShkxqG17K5K0p1WoFXcCEw07feVTE57R
	0uQw9ORV16yGqJuGSkfp84Q76SAgRta+Y2nzvls4iR2tVocanJKFhYnvCLm5Y+2xy8V9Ln
	/RLaZ47qRXt57tYWDIbDP08EwWmkRyg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMJlnArs;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776267247; a=rsa-sha256;
	cv=none;
	b=gVJUWPNko3kENBgLbYIjAfQwUABeEvZ6YX+7hmy59nGpjJAHkVw1IZ5yo1massoatQAjxf
	6KR3hhbS/mQggNT9F84063djyKZL4RhXRX/0YLtzeyOYYbsHb24lkMfxhL+Dn4VdsdBei7
	BJRAqB+5u3qpu5q17X5WaXSJd8bR3no=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0DDE600AD;
	Wed, 15 Apr 2026 15:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBED9C19424;
	Wed, 15 Apr 2026 15:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776267246;
	bh=op+9SmwNWu9WUokAubo/m89uRY9vqEFKlbQdtN79HVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMJlnArsw+4LXD8h8cHFtttm/2EI1x8c47Ja1yMVa/SJ51u6NjRFToVGcXnn095ve
	 8hqMSd+E4CIndjpkvYErxrpbJIibYCjm/yroL14oRr3J4EmjWHMp8ZY5x16dyHr6YX
	 VP1ZnnEHcpsZa072k3Dj+nbWesIpgnt1w5XTrz2EX+VbfAxTZsx/CIqkZSq6etuJqR
	 DO7NmvZVnVo7npNyWPAVxd5xNJpZNdfQ1uhqv7LODbXAbnVs8zC3LAhDWnRD3szfgg
	 7LLAWOwn8aAGkbs3dcgyR1TLvZUf793ULwFAAQj3DOF2lsr3BHskFVJ1xhIiIe6Glb
	 dv29G4OUau+8w==
Date: Wed, 15 Apr 2026 18:34:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 09/11] liveupdate: Make unregister functions return
 void
Message-ID: <ad-v6OcX6jKihCJX@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-10-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80CC4C000D
X-Stat-Signature: 5x1w3j7es1dkqzzhtptyzdwo4cq8pz4f
X-Rspam-User: 
X-HE-Tag: 1776267247-883296
X-HE-Meta: U2FsdGVkX1+dFMTHMKNZXxrDO1DzkvNHzFZveBi0W2bWK5ZXtFuQkoyqBjt4tUahJH0bstxpKx6YauE27IHNIXABOBwQwMhbnL+oYZ6urP+mbX/ZXIf8pMpe6srwXZXXETfN/kM2eddZpdijQ0m+METf5vak09SvEE9yj+VNLbVdvdauh6mdoDaCQ7HJEshEC1WitoZF9rvQIADakjMN5lZHiujh01hKd1DvRsSTf430zn+CRrXVHpssDU7x1FazEfVcXr3BDaMO+LKga6q1iYnAjFNOl/TFcyaRsng7Al9jW5Y7oQCEmlNoq6L3BCXlKPwBD7E5M0texZHkyRPl8wXfUNQF+qAnHTTJ0gwCTjH31TRtEdHOTaw2KX0v/rdAXmyDam8Q2cOwY3Aq7RqFhEqvoyExT5UWguT7hsB9u+l3jUu2LrREhsApRhZcPN90eTgx0YJhgRw9W/7KiQMwUOclc4/YBRPDyflxbdV2G7Mfpom9B6OOs+uVaEHIJ/+ID2Ub2DoEyhqqRA+kJX673A2QB/msULlVnRdqtWFFq0cAnfz9ubHPtDkqt+uXXmb/k3hOdVBho5hHs6Ovf0Z+TAKZOZ+VBGp92L5q8bJnHZQToxwHNz4zLP3T44IYCro1t4pOhXzDErt+KCfTn5ejJyym6VGw8/lKrq1GtCtDOyc7nKnVhKLVlvRRM49s3ieYRMVWt+qyh8cxYLyoAaoTqpMu9+MCiOwi37XKFQW4qHx6/1zybxmWFjQlkaXXgd7eya/CK9zBt471lz8LnVL3VFc2AycoWo9QWw2nGBsqsE69L4jxjJEEyg+n5CkP7+91yqrGNhn2YQfL1paLpIQcsG7XZJ6LjGM4O/JwSsSmbpwRg0jEQEFOG2MMZMInDGZRykC5/39MyJNEDgFLibFBtJwcYWUpwVrLAn9PLm5d1SqQbAhntUTcEiyjshYKAGASmo0h0bN9SofVnBrY3ra
 RYklElxq
 zF/n6940166ndOH5/k3nvmfuGayY3vWlCq3O90i4A8ZNHdN7svYKg5bg6wD8E/nTsEWK9Fo7JyXJ6Y+I8v7+mYcj9ngBaDOF2ZjVZLonz3glhl0S30IKvKSoFF4BrewMdEGFbWNk3AQSMaao1YtDv9fXeJ8RQq/+cIjRpXb3cMUlMAKKBVxgxMnZKdiyZNfuWw4Jh6RjRr2ZENN2qDcR7VWMCEYV+1sf7GaVSGt8/iz/GY96EI2O+vqxqmvET7EfcBbT16rTza+q8WqidiaNM6OpvAsv1/i2/sxRK2IFHf59B2ykixp0Ppccu2b3zqBcP6+QhEk7edI15PLDVjc2pIehHXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:25PM +0000, Pasha Tatashin wrote:
> Change liveupdate_unregister_file_handler and liveupdate_unregister_flb
> to return void instead of an error code. This follows the design
> principle that unregistration during module unload should not fail,
> as the unload cannot be stopped at that point.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/liveupdate.h   | 14 ++++++--------
>  kernel/liveupdate/luo_file.c | 14 ++------------
>  kernel/liveupdate/luo_flb.c  | 11 +++--------
>  3 files changed, 11 insertions(+), 28 deletions(-)

-- 
Sincerely yours,
Mike.

