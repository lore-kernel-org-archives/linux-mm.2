Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B159310706E6
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4A936B0088; Sat, 14 Mar 2026 11:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7D36B0089; Sat, 14 Mar 2026 11:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03AC6B008A; Sat, 14 Mar 2026 11:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3956B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:47:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 324205BB73
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:47:02 +0000 (UTC)
X-FDA: 84545097084.27.DC00CF6
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7DDB140003
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:47:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=SLE3gcWQ;
	spf=pass (imf27.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773503220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcE3J2FqcFfyGlSpJqjrgTPcmLQfS23VafUSp6RS4SI=;
	b=VrptVampP/8ypp44qebeV/FVx5PGD3sNijxvqWUBL1EHtuSOOHM4XRuxd+sApwoS92vbE6
	qkxtp/0swlL3o1cRG7j5l/UdBKIdHchhMZFWQuLDIXuWvIN3wKwIVxAwJkHJDnBW/UoJBf
	bx33Cla2M/Mtccnykgd3t3YaF7ef02Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773503220; a=rsa-sha256;
	cv=none;
	b=l0OWPCsHPzi0gMC5D37byh/zozjchqp/He32h50mKAg5CKIb+5yt0NA754PNKCOzUQsNl4
	7cjkeBpaMzOGu8SFlTbPqT8ul1q7eQ3Up3RByreLCvjUQ1+2u6e6YXGXClabMh3vQmWEYD
	gZWtkf8lgUwS832gt14w9YwEpof3dA0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=SLE3gcWQ;
	spf=pass (imf27.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net CA90540C63
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1773503219; bh=IcE3J2FqcFfyGlSpJqjrgTPcmLQfS23VafUSp6RS4SI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=SLE3gcWQ+vlnWqX5Q+kIlKgT9eqkXbZ6JtxKSpP7PmPKW53EGYvQM8nZijpjnhI7Y
	 7Ij6cwpCTWaTsAKDFjExRJmJkvf2ncbCUZyi46vbCV/Sz6MoV/SxOBd/MlxVZaO1sc
	 gALKy3YVrttKoOncNeIQ2PC6BXWdQgwBuNPIOlFLjpQzi7hi1xgMraQYaeP74bhh3L
	 P5ngaxEEXW0dBesp2iQQKIQjuztFgNU9LUF7vMXRLh8rHT+Zz5T7+vZuHAqehHNO0S
	 ysh8713nc1hFhkOl0tOwd568RDQjdU8r5J4yAfK3pLgn3Q99GmC/sRgR64Ss+ZeJPX
	 6qkw6iTDyWZ1A==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id CA90540C63;
	Sat, 14 Mar 2026 15:46:58 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Kit Dallege <xaum.io@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, Kit Dallege
 <xaum.io@gmail.com>
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
In-Reply-To: <20260314152538.100593-1-xaum.io@gmail.com>
References: <20260314152538.100593-1-xaum.io@gmail.com>
Date: Sat, 14 Mar 2026 09:46:57 -0600
Message-ID: <87ms0ajtvy.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7DDB140003
X-Stat-Signature: 4zbtfwz86rahkre6tgnj6ntyaqci54za
X-HE-Tag: 1773503220-908342
X-HE-Meta: U2FsdGVkX19RWYsDfYuIQ5nQZadVxVq4DI0qrGOKK5MvYYenddodBumQJdV+j+4a9bzgpBPSTe3DGVM8C41pH5kyjqDC8nrRu/W+u4epqEESXbqMsIrOin5h21OmeyHRR6Fl/CPx0jPbzYbJCgYJokPnaYW2neM0blqDCkFCviZ1SpJkwdSA3+nqTAkrlWtAO85CwtBXJboJ0vw/9zG4YlJ+J9tEgIGsouXzL/yvpkMRmyZxrUNav4heNPxcX5Onphh9w1UU89EzWO5zdu5h0byaxZMYPOK4+kV8v2CToKdkOQ3YmcptkN/ID8uNWRLbAaxa/uXeqkKAisKnlUgsVJ0z7sKUftgRFCy7E+JKdJxlByuLRG9LL7xniQR2d1Zsxcoeke8oP/X9qLy80Z3KlVFiDpXbHt8oEs/LctqTxoOd5g5To2xVk5lcYbCmIDuwke9QtrpbBfyb5ntZs+K6AdlH5Y/2N0294kpFBXzA6GDbMxsi0VXoW37jxODq8Iq0gpygrI0s07Xe+mIchpQQf9Mp+A7vEsmqNJBAbIrtezz3emimcFbDBVCAUVntsAJMIZYda65ALRPVRh77u4etr0BcLM3TiHIvF4js0/7pxI8S3Mr1MMTNcoynP7pEdyCHpm+5W9eEAPQjv36vxFB0732C2mXYBL7SBdKr7b3+f8r7qbvjuUJ4NKoifXZFq6jzIlnAzf3A3jBh3iInm+YxmVaBmDd5yJ7O3xPOG2h1eVlgHdktvfn12UAUvUSqpfy7/4VNUeDdq/5A9OBMHJmSeF2hKDMy5cc7/0jNdtet25ePErQNvj/eJpOuHpVsuOjNFHjNGGwKAiBCySGaOEN0akrUjVpo/AjYZ8gJ9a7bcypWmu3SSpnT9agFRyLt5hL7Cq1SZ/uxwcwtGLJpMBfzPol0kFxYI7zRcNWN1PzzBNnwdaHPcfReguYJrKjZV7vMRcDsRm0ZeF0KM2OwIFl
 7j7SzM9P
 OeYYqDugYUK4ybR9e9uZWT5f9lB4rsaoYYJDinHeaUh69Oefzg5l2SjaRscM3gwxcF+pQcSonWcqopc9zTiPgXQK4+pOafGLIDTE4QfJsQxsdl3krg3d+E741Mk82EaIZVFw4Q24mxza2PFJoxun3RCcI8oFnoWEQnSQyESau6MNeVXgmXmuhPx6XzZfANQ2OwJSTkVON47HPo4B1OzV2kfA36UrE8dt09cS8399Y3Jiq5+d5NdAc96UBn6LHFhGYYh06CyMkuKXiCG9rnaV5QFByQrsVnWLV7mYUiOp6wcHNBp/ejm0gl6MWrQSiqzPfZzic3IT22E5/lMMRmEA9MwW9VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kit Dallege <xaum.io@gmail.com> writes:

> Fill in the shmfs.rst stub created in commit 481cc97349d6
> ("mm,doc: Add new documentation structure") as part of
> the structured memory management documentation following
> Mel Gorman's book outline.
>
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>
> ---
>  Documentation/mm/shmfs.rst | 114 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)

So we definitely appreciate an effort to improve our documentation, but
I have to ask...where did all of this material come from?  Did you write
it yourself?

(Haven't had a chance to read it in depth yet).

Thanks,

jon

