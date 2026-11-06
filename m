Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD93606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUZRTMii
Received: by kanga.kvack.org (Postfix)
	id 9589A6B05B4; Fri,  6 Nov 2026 07:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D186B05B7; Fri,  6 Nov 2026 07:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843826B05B8; Fri,  6 Nov 2026 07:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 646076B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:38:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D58BCC0D46
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:38:55 +0000 (UTC)
X-FDA: 85404648630.25.A97C5EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2431010000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:38:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUZRTMii;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLdUC4Dy0rzYN6SNOPoi87adYyDpl146R+DLmZmqN5k=;
	b=Zj4ewNR/oSk5NVCC2RCrMZuWJcxgAr5e+mRHh+FYl9BU+gI5KP/0yopXNW/25vbn9tXULt
	vWqKtu/demWLB09KqIYIuN++N53zoi7OBlVT0WeUQ0TKKsxv/fldiuTb5U1r7yMqu6LVH3
	KK/UZeGghDC6D5KeSD3qFgPqafqgaPA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUZRTMii;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968734;
	b=4J3blx9yv9qN3rvS+juZLAOI9MkrFzTNuwOn9L/8KoKK5RvVBc2PFlFXSd9NsXdb/qgC7/
	1PV2yT8WT8tXSgvp8NVOlIAhG90VYXk3XGgXt8UrDQ6VHjEMhlVmLG/evS3IH0BA6JBjei
	CXC8OkQ6v5FMIGsG29UJJViiGuFDbZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C869601E3;
	Fri,  6 Nov 2026 12:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ABF1F0089F;
	Fri,  6 Nov 2026 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793968733;
	bh=sLdUC4Dy0rzYN6SNOPoi87adYyDpl146R+DLmZmqN5k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kUZRTMiiYfuTSKX1UiKtrxAx8J7ITGdv0i/nEpv1JHzH6XuLBzRZ2oI6n9fgytLqi
	 wejIghDottL4e2EFMBAcTNwRosFRy2YnOFiaCgUOMJ2Bq6PPHFuElG5HMsjh3rxfpl
	 7lL4v4AuLXxbb5lujDWInFq2T1SWeQLsnrIUGTfN8r6OVki941A+WzyWflcppAY2LW
	 uJvJ8HgoFKbYE4BWF1ud6nS6XFo0lnA3f+qrguCXbCSBbr+pTB3ohqDTa5CadmVJJ9
	 ygVrBsz+nJtjtXo6xG7ZOgrcnvzVBcby11/plPVs9RZjs439vedhKgalK3fJMAcMF5
	 tiSRAKXr1wnPQ==
Message-ID: <1904cd51-66d5-4305-864c-57219b69bca2@kernel.org>
Date: Fri, 6 Nov 2026 13:38:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kdump: Give crashkernel CMA areas unique names
To: Mikhail Zaslonko <zaslonko@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Jiri Bohac <jbohac@suse.cz>, Usama Arif <usama.arif@linux.dev>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261106104309.3669583-1-zaslonko@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106104309.3669583-1-zaslonko@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2431010000E
X-Stat-Signature: ytgtneirw4g5gaeorm5roys1fa34e4an
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793968733-340915
X-HE-Meta: U2FsdGVkX18GtonPLNX05Ef/gTLqBbKjjxlNSpRknJqyLImS3ULUS8MSXkc394TT9kNzCAucnfZ0yyh2c/mgZRsquxlbB1/jJd9DIUFwnk7jmMxRQyfefLA6WnkRtova5HGH38Yqboh3NwWh5QF3AkPUnOLusO1L+WjItsCJtyCCpH6u7GIhCxiKgJbWpC9t/YnTNhzTVjd6jX3ew/stIqFGeNTnULLGrLtAdRNW2G1cQ98yBw4K24Og/CnKF6HjsLNM49euYqCGvu8cegheu1SWNS8NsI+Y3GadP5Mr8JvXh80UjVuWUehcJRGfDLz8FER/cdGI7w8BySO1yjp3nRX5hvevlyGykLiNaxvKasNtphn+3rTLwtpXR040/O1K9ll0JtGQyJawPoRGdG/ikuqNspLjFxiqlubf2i1w5MDBFoeux+utboB3w40Uh1fzxJjYDzvWm+HaKcHHWEWzTZVBL+Na4eE86e3GVC5O6LBs+/+wEnpebJKvqtB33kXFu/wsaYFA4fIQH1ntIq6Oe8z6YXPGMBnGqMe4McIDtd+mddnZGaTXl+4uTO9dq/JLJCWYQHS6289J3nnEyF/rETgiX/GsWDNugli9eu/ikolzRHjC86U+FirWSUIyH8+eBMIZGQTiSJoqWZj1fxmr9EHSUwin5+KZzj2ORqI5AORKKxRsyV+X+x3on8Oi6mGVIIJBuNNBKjlxfFX+40Ycgkta14VlvdQIiFnTuEb3jQBUWgK0pBMYtB3AaLpbLN0pXb7jkk71xfd9D/TTOk3IC1AXUNEBFE8SC3Dh9zpclIch9Yp1A0LuSw5kiVnSD4Vr/32ucOSKPvOAOyhOpkW41xEz/B+inleie//HWpBvuXvsmUsdTXpeT7hqJNY+ydKJSqfkMyhkkyyE+RUs8Gf7iP5IUAVJl5WXEEmVIXY6lf7/vtGcEG3DM7hqmeLCxyy5zs/lOJpR8hZyq7or6Eg
 f3x1gMCe
 cgRwt5dLxBMQNMYFcgM1oXyfQAjoWaB3qBriInHhw5U6LygEM9xXhzb6Sb1tdSAQSCt5Ea0YGeEMKfSNenKHGqsEl37X0wYp3jkyNHiL1psjEKFRffjRTVgXGqQpiTOvHnsBcOOkTZ+0Wz0rUxcwcpWnOyP7f29mqSocv2eITpUuVH8wZV0ApQiG3unzhe3+vrX5V94ZF+Euqv20+9g180KIli57gJ1us8UDuSYdJvNMQnUNhoob7II8LMFq7RJzYr0sXz0o142B+H+awXqBtGjpoiGGbCNiS9b2UMwUAeNWvxo3qIaA2Ae/6qPEjvt2KgipopDEVOp4MrDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 11:43, Mikhail Zaslonko wrote:
> reserve_crashkernel_cma() names every CMA area it reserves
> "crashkernel". If the requested size can't be reserved in one piece,
> it falls back to several smaller areas, all with the same name.
> With CONFIG_CMA_SYSFS, cma_sysfs_init() then fails to create the second
> directory:
> 
>   sysfs: cannot create duplicate filename '/kernel/mm/cma/crashkernel'
> 
> and the error path removes the sysfs entries of all CMA areas.
> 
> With CONFIG_CMA_DEBUGFS, debugfs refuses the duplicate directories as
> well:
> 
>   debugfs: 'crashkernel' already exists in 'cma'
> 
> so only the first area shows up in debugfs.
> 
> Keep the name of the first area and add the index to the others:
> crashkernel, crashkernel1, crashkernel2, ...
> 
> Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
> Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

