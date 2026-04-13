Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D530EBFD21
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23EF6B008A; Mon, 13 Apr 2026 05:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD50F6B0092; Mon, 13 Apr 2026 05:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3C36B0093; Mon, 13 Apr 2026 05:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 894FD6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:10:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1927B5D262
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:10:54 +0000 (UTC)
X-FDA: 84652962828.19.6DB7013
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 595E7140002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:10:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JPAQYOSP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776071452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3m0nuFmJ95eN01aXXP2pKahqIdOWK977I1fGu58zD4=;
	b=KldM5bND9RiBE1xPgtOkF9C1D4SM+IM3piqrY3/cdJvw8/x1FAWs/l2eJYmZWe3ClAbwq8
	arnZr2umObKghmMA2GJ3BD9d3xJs/3qiyQHI2lkIVfEVY33ilH2MyXpvs65BR4vb0fkJno
	vFOnJOEXdBwpR79ZL2tWbDgu67szN2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776071452; a=rsa-sha256;
	cv=none;
	b=V3zxji/dx28Tg9N5MqlIBvwVvkq5vXMeDVrxNIbpBSA5KeK6OJJwW7I6fQyPFS0ok2jfVX
	C3wmhJ9nV6vJ+75oZLq88nFevTFpRTlZIzMzLGWmQwQ7TbF2XyDJmIzYyDPaF7jtv0OkhI
	DQUA2Zq7q6kBKZD2FNSY2PkGqsQSSvY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JPAQYOSP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B0D9A60172;
	Mon, 13 Apr 2026 09:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80E6C116C6;
	Mon, 13 Apr 2026 09:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776071451;
	bh=vLctE0L8gyL4gYx2UojMwYE/cL0iFzPN6wJKGthmZZ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JPAQYOSP+82Mrgd3K9LX+JOgRGR+5JCTGIcm/aWhEaYJv0jtVi+RcP/FTnbHyT7EP
	 rD1UGTsjwOk5dpx9xu86UAGLCciY6IwSKJPP7IJvzyIp9rlOS7Q0TSAy1rwDQYR9iv
	 4tURTBnXBfuUOt2u0Wo9tMjI9NW8yybRToaIK/WEtBu36JG/w1oFn3pvFyksXcLKcf
	 D4dVLqGlr02b58+Wt8cOtNTYUqqUHziJBQF32lq2s9uw+LgtNW2velkwt65hHTMv1Y
	 P6rJwXEhFodMpqLfRStEU7CwE+zRnvTuf/bbAmGJ5xr1tR3vz9Nl2JYz/iuA8AglOi
	 N8VgDPMCz8bew==
Message-ID: <7feed614-f59f-4c03-b745-2306450a899d@kernel.org>
Date: Mon, 13 Apr 2026 11:10:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests: mm: skip charge_reserved_hugetlb without
 killall
To: Cao Ruichuang <create0818@163.com>, rppt@kernel.org
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260406053126.217196-1-create0818@163.com>
 <20260410044139.67480-1-create0818@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260410044139.67480-1-create0818@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 595E7140002
X-Stat-Signature: uqion13up3zsh7dnq59bmsnrjyxa86br
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776071452-904026
X-HE-Meta: U2FsdGVkX1/CdCuOVrndAOZ4w+GTtG8PZ9hkOEUV+yd6D+6IQHV/PPNj1tgf9oWKORR72BiDgBvkBwUl0fVjKAdWcpwITbcsk7LoEmBXtc+Lt2CnAxUkNtbLgjGtEJeMz4gjSvmP0dIJ52QkXq6aIa9QDmIUvm2NfCD3DTMH1ZqAwcIuAKq+3yszD3fuhDKGRT3gRTC7iKbtYK+gulkAgbPAZWotLd4LhtCdMRkpQCKqrggXagmr1us/XgUoKnIJvPRFJre5AJSwpcvJ2+OxVvn3GnhXyLeRciDD5n84bxWdhkHPN1jtC8mWFIAFAHUKFx+sgHX2lrtJCRAl9Z7ri69WMiz7knSW++3ollT2xkEtywiRNU1zkh7XSDV9wStHt2D65jQfPFjAEbuC53RPqdHR4A257Haruw5D+hEg5qjBlKO7uc7sQDnW80w0rriO6MSeiQ17MWS9WNoU+i0+Jn1JxYoT9vEPR9pFCaWr5o+lwFKW9uIfem2+1p5kk6IKA6GkNWQZojOuEwyqVlTobz64WaQQdTLwzsfrCi9VCbRNpG75xgTXWdsHIeUGqfxeY1Tsb6EPdIuefHmkD5Ynb4PidEH9jIzh4JzVJ10A2Dfvly+ZGn+ya46VcXeZpFSNoZqiakWUD4pnqThWKH1X4qUkK6B9gput7CWY6i0yDpJLtChueTA9oEfhXYtKQHVIAnbSzO4CqntNrVbdcV6NVXEB/KpFEAXFaryqJmz5GHGH6N2AuQElax+fb/T7hDB1x3Xyxy+GTfURCBf6kNxvz8zUXZuRFLIVwbdcNOQZE2PfpkyxWJbDOImi4a5PtvkGEfLNLxuiHqBxMYM6QWdhYvN9vBiGfBNiPdyXLfHi7g4TV0lbyDBrsVbizxgeWmdQ3zQsUjwNxColb5zMPTwUALuCzIDwk+iYDmkDIVboKBdGIUj5Z5MZmKBw31ZG9+QFUoijBS5GSnxvaDjBbq/
 IqoQQcPg
 EheMp9Ydo4ZMXREzzZlCnZncgc/Jl+62TK+55K5D8DTJzHfVz+DwCxvAW9DoegMNBLLCWSgL1KdnSFBF3IlmJIkySoKUWuSqW+I+K4m0wryj9bb+m1hD1gXsVfQito6zyGE4Xs5Qm2jVGGjvuu56dumNBmmrDJTl5GpunKmtZwIFtrYoTx3CJYsvQ1t9mhY9tvvKD69+IprM9sYCSRKWrMueGg/CWa6a1n09jokAnO6oMpAr03JJG1jRoH9Uky4ZO4DzJ6GLDmOvPUeQYnG3R4DynztfxgYtOHhoBCihkJkYTqnISs0kWmLZpZNcvdqywOJ1OBwZ0qxPq43DOEbQsbHKIKJvDAGpZsPNf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 06:41, Cao Ruichuang wrote:
> charge_reserved_hugetlb.sh tears down background writers with
> killall from psmisc. Minimal Ubuntu images do not always provide
> that tool, so the selftest fails in cleanup for an environment reason
> rather than for the hugetlb behavior it is trying to cover.
> 
> Skip the test when killall is unavailable, similar to the existing
> root check, so these environments report the dependency clearly
> instead of failing the test.
> 
> Signed-off-by: Cao Ruichuang <create0818@163.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

