Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D53F43849
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA546B0093; Wed, 15 Apr 2026 11:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B4F6B0096; Wed, 15 Apr 2026 11:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8D76B0099; Wed, 15 Apr 2026 11:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F57D6B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:29:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D65D16050E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:29:09 +0000 (UTC)
X-FDA: 84661173618.01.07967E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5D18D180008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:29:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uh43M2OF;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776266947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oeNtCczUh2lxL29EmEDKbVDUJQiFjum7UTi9H1Z0/Q=;
	b=krSmw2Ln1vDftyejSaoRLBTYasQ97JnQl3UerewbxGg3ADEdnY6gbTpC7OYzUvvsQ99K0x
	M70dxoaWNpY28R1SaJzg4L0xdkjPqghiQZxuf4JwrYsxuWu1lEnNQ+h9CTF7usl/qrn0QE
	CqYw8m/zBcLfQT/HXhVXm9NwGkbpCpM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uh43M2OF;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776266947; a=rsa-sha256;
	cv=none;
	b=lvzVJvElPA/z9yS32PnFlDiWwRMCnLoHzwR5tLV/7PnUcnlHN+MyL0VSBdHUHRiOa+inkX
	F9wqoUh7aTqpKeZDK4XXz4oqhHscGve3wjyOp/AUSQC4awhbyqYF/2/vAON1S2Vg/qguXJ
	SJWgeJWrtSIJZeu2+exuVLouvZCop48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B26E434CC;
	Wed, 15 Apr 2026 15:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42692C19424;
	Wed, 15 Apr 2026 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776266946;
	bh=b7F6dEl/fEDrYP//U5wNccvIPE7yc2JN/vaCoN2DyCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uh43M2OFwIS3dJsit5Sm/nu4DvzvgG54RBiMqoErTLLRQ41CfAJpdyXwk4uM263PZ
	 55MAPapME/Hp+hI+K4/xZ7NSZSBXwcoBolNvR0s+wr9y/pRKf3spB4EIloCgMCZdH1
	 PCNliafYveptLE1kby5seoadkVZ7w+5lt6P7zo4zrmlKCJGe4eMaSb79r5R6VPMIN3
	 1l5ZwWwIeeTFVMWSWN9KZ4Qv4uRt8OSj6sjuwajgaR9sWu6BYWHeEtyv2E+K7X31jN
	 mSZ1l9o/2qJPECv8lvU2GdTLihhdWwcjAEhQArPLDEgwvaOvZlkJFAhQ8ZZJP/dC5e
	 NCFzaXXpjchlA==
Date: Wed, 15 Apr 2026 18:29:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 05/11] liveupdate: Defer FLB module refcounting to
 active sessions
Message-ID: <ad-uvfHVCRje0odk@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-6-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-6-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D18D180008
X-Stat-Signature: f3hnrx59ifh3f5573rkashna8zu5bftp
X-Rspam-User: 
X-HE-Tag: 1776266947-145863
X-HE-Meta: U2FsdGVkX18GqbfY80RSIGWtFFoSK84+eORmUqo6ZFe4hR0u0CvE+984iiOW9IWkHNEoHKTS3OcjrcKNUHDHJHSaCXbKDuBUKjQQehbbLoO487lZx9NgBChPX16Qhemh9S8WoGYkztDpvPMWmLVr73jmIpfOIbNacl9IdsqaKr0jvo1aid29Xv19dUo2UKx1215lveV06gO9DkalUAo5nwhDvzbrQKE5Ng83Uj8gM+03qOtrKcBhRqmvEo6B5r9PL0xFujLMx+Z20tlusPX8RHySB39WzkWm2Zo5pIQQgmLv3trwrmRUr4ThVq6Ewiu448uIMUE68GIGeGliYyq+Le6sSqpaXtsG3NjkoF3ktwVC4IY6TuDn0FdgUJL+xTxICyRkoNz9OGCYz/+UaKLn15MxAFlriIjP89kUJruqHIiXZYmYNfZZkB4t3zA86WCWOsBPDXn7UCQpdQGeoLvh/h9VJD7wv+Hv/rwz6KjtkUx/++eZQFwXBtL+oAsQnZ78olqGc79v7Z2lKt7NW/ygBmsqEk614M5UKOS9aR1xrOyM9qBFsZv5UeTYO+ahajcApCvikK85e1bM3MCL7l8B3T8u/5qED0MlqPH+1XsmxBrWIacENtfNlrXJQbJUxlOx0jD8Okjv9QAPLki/7Eu49nj1Q1OiMpzhiXaJw413GxxGSd1CyA1EVN4qbgLuDeZybyYK5tuFe5v060vJDRGNR1ZazD7591NVKUsgatruCaXCef1Mi/oynuLx5adu9p8ll65Re9sSX+Fpzi6Q/D9Qa6GqBhBDqbnoDgrjgkhrsIu9m+RMmVfrPRxM4SoNTq2S1LetExCVd14H1r8kaVAXf0Pfoa2sg49MaM1FcEbDIGS443dD2Us3CPs26RDT9bYNq31nC84PD67/wbzCle7i+OUANEPmzKLXR1I/qynf0E/1zwLIhcQ/9r1l7qE6UF6t1Xayr/2lKeLpHpTWNtN
 8oTex0jh
 IlSaV0C3MfHvObiWx1AqVZYmsBxW3jqgJj4/erw5ioPJjX0ZCxVE+6rtykYfvoYPjNaupzqck0V4nXC3/hLj2pcgGJdKB+g/XGCs36ToQb53snT4qM9MPOBYyby4YjVYXBK1eWJOjgYT0qX6C/2nFjolYnTs9bpCFE1ucqYsk0f5B4eYgu3DR6GBFcRbBBBYqfYDhJYNlulqnRzac8kvMCn9D0zUCNvrrIrO1ko3hoRVtwHkch3jqSp80pFCL/Nq8+BU3Pw7k0yyTLgUaeuSmDKoiv+y5O99eCkAHtJJM/6ZdVYix9VyYfK4TU4gxrIRjc2tEVBDWsZWhZU0ftV8Zqs0M++JW1FMByMyA65MlM6KSOZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:21PM +0000, Pasha Tatashin wrote:
> Stop pinning modules indefinitely upon FLB registration.
> Instead, dynamically take a module reference when the FLB is actively
> used in a session (e.g., during preserve and retrieve) and release it
> when the session concludes.
> 
> This allows modules providing FLB operations to be cleanly unloaded
> when not in active use by the live update orchestrator.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_flb.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 

-- 
Sincerely yours,
Mike.

