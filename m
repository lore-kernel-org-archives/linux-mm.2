Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 957D6C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918B56B00C6; Wed, 12 Aug 2026 06:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1096B00C9; Wed, 12 Aug 2026 06:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E3C6B00CE; Wed, 12 Aug 2026 06:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A13B6B00C6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:32:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FEEB1C0CFA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:32:31 +0000 (UTC)
X-FDA: 85092253302.18.6F88722
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7836E20002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:32:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HeDSLgDM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786530749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7enFee0jAt08OEyw0dUeqUaEU2QqTLX8gKg/GfUdVQo=;
	b=dykjeRMvespTZKBEWCJapScU0bhxLU/aOiPsBFb0ie6K55t5ecoCdFJthKTdsk0Qnqa2D9
	2v5lhcNFq+P/yaRvz7rZmk6QRFj58mBQkzul29hZL7/gzRbOQM/EEWGzNzhuY63xDe7n7p
	N3ibeveizNlwVZ8Mc7+W8Dlj6nDqWnQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HeDSLgDM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786530749;
	b=74kCtau2z+Rj/x5IDwp105CpsKp59NWR/q88ZpN+t2QVPXHWOXyj8nxdu0nluY/09VdR3B
	x1p8TOnUuGzC0PqZ2EHLUK898csJhMBP21fwmvPaFMY/ZAI0GNgtAqgB2YstHlqHDOK4bP
	6LW+ClpCI2JE9Wb4BtOoeJPSfphDNO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03CA560A88;
	Wed, 12 Aug 2026 10:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011DA1F000E9;
	Wed, 12 Aug 2026 10:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786530748;
	bh=7enFee0jAt08OEyw0dUeqUaEU2QqTLX8gKg/GfUdVQo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HeDSLgDM6lV5H3FjBS7R0fKuLaRZlILJlBAykX+QILIl6u593Cn5+YEZ6cP7bAL/z
	 1hIIuDEvmhvWJe+sAi4nQNciJis5uxa++bY8vAFlUYXmTa16eLXdK8I90EKszZFt+y
	 6XOWjBn8PaGLWuYCWt7CgHfGYAeXpNUsCB/NYAY+I2Ein1nwAsySA119VYUb3E406d
	 FipOXlUdZIXF4n4qEfdue4yR74U85S59MD2Ej43NemqcvyFM4raZQTHea4HVJxJ49j
	 hP9S9rigy180grTLHjxasl+WKjERwi+MM51yB3PKYnrUuZqGyRbN5KFTJhRK5KMY+c
	 MQwBYbMgjsw0Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pranjal Shrivastava <praan@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  David Matlack <dmatlack@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] kho: support preserving high-order non-compound
 pages
In-Reply-To: <anr4-F-e5_vHEar8@kernel.org> (Mike Rapoport's message of "Tue,
	11 Aug 2026 13:27:04 +0300")
References: <20260803113944.3694290-1-praan@google.com>
	<anr4-F-e5_vHEar8@kernel.org>
Date: Wed, 12 Aug 2026 12:32:25 +0200
Message-ID: <2vxzv79f39za.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: jxyr7xojmz5h6bd7wosa7tyobsfjia77
X-Rspamd-Queue-Id: 7836E20002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786530749-136253
X-HE-Meta: U2FsdGVkX1+eszjbgc8VNTbGRNHH7E75jtK9Z4GAWHHLeiu6FcDJDdc+3RcTseWOrcYlcM6B19/sJBIFJdJrCGYQR3za6pfgz6+2Nf2VByNy0Vkrf4gfjhtxSMuYKwtJKasr9y5jP4LR2IXRLzpJMj7KMLrHfDZjYSw1gZz+7wyjjOLUteL3QAso44oUv0ZOGjL1atdi7QyTTelbkV5UDz48ktLTdkxfpjQ3fVWISAaniZbVtWPNSmsIMDFBTyLzv9db1Coj4st6Hd8PFfYFqyt9JHjVnFe4kTjj1S84N4jqDoG/bQv0+rcdNOWOpoSvHzm9rXKOo0aRFONA3Wi2Ii4gcVr7j5jSM41caY4ZBTtzbuve4j0y5IiRd2rrF4Oj6n9qcFf/4zAg+U1MO6KEypZsb66t2WLtlQwM9h/GNl1TRJs0kzvuJWT6WdEecW6dUcs19ZgfbeWkYoWwF/M252erkU6PMMbWRiCRJvyy1Vk8nLWG949r31ohG2bQW99MHvaCR08/HU0ExQNGc2bDPFcfgoyBvu9RLCWKXrYn4g1r6b1d85ONXaMruY4sTvJ9MrO3tORHioiHk5EYRRVH6J7Jk7xTiLKuiE4xTu6Pu4+s01Kw8CtWKBZsJVk6xZNsngxJy/EzE+rEbDNPYLt+hLOJrvhUBVwztyVjqhRn0a7rGsepnDCIH0IAR9eYnjZudzbUkhMUtOdvS090IfKSiJL8dz+sjKOjjcv3rbdhVJiBRFzEdfRFw1wvHlFU8kgAteExoWU2XB/XsUjRQBaaMIiyrsbu0tEqrtikwPCJ7SLbXxYEzOFC/GVUEGYU1fU1KkiAg2ysluUq+PbgwFMmfwi2dI4xrE5QtN68INMfMK4ZpUSMLCLqnyLYLjXhDdqJEakToNbE6SXlLaYDSrnNksx5gjxuqScMgfcxKi50Uq0uaheCT+507jyF0F5NNq5HNzQs6x6OdXur2O28lE2
 kmhD75LJ
 cIX1Z3TNa77IQLBf67ajKMflYyCkTRgxzmfSu+CY0MqyOxjJ+kmIqv4Oy9Sfx1XzCINdFoxx+xrC3QcgMR/qZjrAbGE3GRMJ/j6YFRM0yGDQYNY5Alia+h4+G46ugaAuAi2fjPTP6MHnW0RYDUjl6ccWaSCyHQBvnNZ6zrPNP7QqQbfxh5qdA5qg/wi84sfq1q1st5pU11lQweGo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11 2026, Mike Rapoport wrote:

> Hi Pranjal,
>
> On Mon, Aug 03, 2026 at 11:39:41AM +0000, Pranjal Shrivastava wrote:
>> Introduction
>> ============
>> This series is required for the ongoing effort to preserve DMA allocations
>> across KHO [1]. It addresses a fundamental mismatch between the current KHO
>> restoration logic and the physical reality of high-order buddy allocations.
>
> I skimmed through the patches, they look fine to me before the in-depth
> review :)
>
> But we are really close to the merge window, so we'll anyway need to
> reiterate after v7.3-rc1.
>  
>> The Problem
>> ===========
>> The current KHO restore implementation treats all multi-page blocks as
>> split pages during restoration. Specifically, kho_restore_pages()
>> initializes every 4KB sub-page with a refcount of 1.
>> 
>> However, many kernel subsystems, most notably the DMA allocator (via
>> dma_alloc_coherent), frequently return high-order non-compound pages.
>> In this state, only the head page carries a refcount of 1, while
>> all tail pages have a refcount of 0.
>
> This hints that these patches could be a part of the DMA preservation
> series, unless you expect other users of the new API.
>
> Generally, we don't merge new APIs without the users and if DMA
> preservation is the only user, it's better to fold these two patches there.

Makes sense I think. We can review the patches here, but then they can
go in with the DMA series.

-- 
Regards,
Pratyush Yadav

