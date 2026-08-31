Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D63C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 21:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C05F6B0088; Mon, 31 Aug 2026 17:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3718E6B008A; Mon, 31 Aug 2026 17:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF166B008C; Mon, 31 Aug 2026 17:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA8626B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:29:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 667A0C0281
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:29:56 +0000 (UTC)
X-FDA: 85162857192.06.7759B3C
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf25.hostedemail.com (Postfix) with ESMTP id B0B4CA0009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:29:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=kJeI+ul1;
	spf=pass (imf25.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788211794;
	b=I/BnBTrLgJasoPqFEHppA3Pa0PIcg50SEjTToabjGO3aCZCMU5AOFrnW16yJmPjr85cktH
	rVtl4tWH/Vt8p2vUkohdMmhogdalKsduN9RA1FvTjPjOJc8rXgFoS4B/GBctK+ZdPVp8vM
	pnzV8ZitqcW5SWtRyJ7/FIyU2vcColo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=kJeI+ul1;
	spf=pass (imf25.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788211794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rv1SKUb4sWsIeu5cUgNjrE2nPRcoJ2CH6rXxJt+O24U=;
	b=n4RIeNQqPC9yBDSzumXrVaGubQBunsVobypLySJZ8GxUOsXr5oeIaQ8uGx0PCqXB+HDoX7
	SMb81adIyMEi9gwb4++iT/2ya1GrpxJ2IT12zIO0s7TtsXMmxFX8ytnHpGb9pjaXMA5zTt
	Ay1lI+yAlW4Xu6KrkEjglnI4c7Jgbig=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 505D6408DB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1788211792; bh=rv1SKUb4sWsIeu5cUgNjrE2nPRcoJ2CH6rXxJt+O24U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kJeI+ul1XaGH9zP2YiYS0RJPWVMbxcNrryo7mE/TZlYCgLrOnXq4TvB+r+EinrpuG
	 6H+fvnkg3JZoWVLrTzOnnSFbgWYU99UzZROphDykv9gp5b7jDtCx0Rg9ncHuZisYxv
	 LwkxeXZxu1lobIPZPJjt/XAT67qeUrwlVRb0cr5MXSrSit8kdYV7xRuF5N5TZkxyyZ
	 qcJpi/KDwXwdukxV7XsqcraEg/clZfRRv6+zplc+h/HQ9eO0hu7kWU8+cGV+MQEW2K
	 MuwXr4f4o0/LxaSFGAe9eeWNhbrq1ks+q5Cd6SHPnJoLR6FpVu7c8Rntj6w7rXyuPu
	 8sP8Bra6fZ34g==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 505D6408DB;
	Mon, 31 Aug 2026 21:29:52 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Christoph Hellwig <hch@lst.de>, willy@infradead.org
Cc: skhan@linuxfoundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] XArray: document that tags persist after storing new
 elements
In-Reply-To: <20260819065714.1358822-1-hch@lst.de>
References: <20260819065714.1358822-1-hch@lst.de>
Date: Mon, 31 Aug 2026 15:29:50 -0600
Message-ID: <87ik4qger5.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: mm7s39jmzugdf3jjei8phea93np4z9qi
X-Rspamd-Queue-Id: B0B4CA0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788211794-917048
X-HE-Meta: U2FsdGVkX1/7F6jX6BS4h4meXnI0vO8TjVrOMcXkqJI8SOBKCGIqGmsmkz+Zwk5rD94G5LG8rUI9RgezQDQzL/jLm2WR0Sm2P7aCuuLFt7WFkYtajdvC4Bvc7qrqgKgeWlHP5ASgW6J6Xl2/5lHruBePpMICtW/IDmpi43X6zOgkwKktVaVqA6NsNnLo5GMGb4mwyW83FaGLf2VqEpJCaS3Kr2rE90E/Gbkyyx6+T1Pkq7PBlmfFZPNR7pPda75LR/kuHS+kqRHPlXDpU4RlXLDXNiJR1nhGpJQ+n/QkktDoiy9mmCmvrrlo9aANFDu2gP4xo5/8C6Ih2PRF5rq8WbYyU0uSc4o0UM67nOZ8Fw1bIL2z2K1pQ2rS7/+glEgfqE7ES4bifTUHhLlXm/E+vNmIQ2BckgY7xgg4L3BwsIBDtTHOUVrmMnGtmze07zQRr1wTusBtb2jP/2hspr1c3e9q0/Ya06V0JBBXBUZw3iAkL8rDIZ2OT3P5yz71HDxZu6pOlf2v6Q8y0xa8167KvipDspexRoehGUojkpMZg3nGw+UpjciWJSYAVwHDdBVKxMn3dD5zSMzT7+Rd1Lm0QYdvz9yby3whS9aTpeRTIK2iatnrEt5MfrTU2weOqHNEph3s8plcstINmx3AsMsgaqpUFPBiXMJTIJ9Lqc3j6wVULMAD+Hnz72rOBuUKG+c34IZSSGyOZFbJLf+i341MsrG8021KrYyg0i9nZsfGYe9wZ7bBzZwz+Mq7Ear073K8vfx5LDI1PtpqPEnxltVvf2t1xt+uQ9/rIRPI5OP9XMOnfR9aRu4X4RW7bhMBTgGqsLAllik1WDXRGnGcW+D1PuOd94X8IxJ/GjApSgp/SB5AwCbqobmes0jMd9y8N/XTB4rJtCs0BODRCq6RDstm7oH4QgADZPmQbLTDZcbyb6GzV10X3ZnEFqg3MRlSwpYhmGCqtYXU2GnUja3VkOf
 vX/+fSSO
 zUjW0o03I9BWNIho8lbCKnsgIeB0YZyr86pUNe+R5q0yCSu72TKnKgmUdGRp0WN/rdKMcWijI+TcODGOh2ZN9GM0PUoeFSqxG77+JC567l7JEN8nfiiQoPjPZ1m0aoblrKxR/RrmhS7wb3HPwrN/DwSOlwYX3Zot1Y0MXN1IhwqB4/+pz/lZVggDRgUI1JXTGjHt2S5w883WyGvsTuQU5be7O59G+1KmlUb5FbpiecGm/hYZ6PMnfk8pISdVtzVl17AOjurkU/YNnhwBHomgHI4i1mE90gtAAA71SeDC2VZUSwCEZ8nVsXrAXbDrzX4bZq7fJNWh1S9TBSH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Christoph Hellwig <hch@lst.de> writes:

> This is a very useful feature, document it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/core-api/xarray.rst | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/core-api/xarray.rst b/Documentation/core-api/xarray.rst
> index c6c91cbd0c3c..9a0d930a8c79 100644
> --- a/Documentation/core-api/xarray.rst
> +++ b/Documentation/core-api/xarray.rst
> @@ -127,6 +127,8 @@ by using xa_set_mark() and remove the mark from an entry by calling
>  xa_clear_mark().  You can ask whether any entry in the XArray has a
>  particular mark set by calling xa_marked().  Erasing an entry from the
>  XArray causes all marks associated with that entry to be cleared.
> +Storing a new entry that replaces an existing entry keeps the marks
> +associated with the index intact.
>  
Applied, thanks.

jon

