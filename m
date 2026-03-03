Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31F0EC0463
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116F66B00B6; Tue,  3 Mar 2026 05:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EAFC6B00B9; Tue,  3 Mar 2026 05:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F896B00BA; Tue,  3 Mar 2026 05:04:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0C826B00B6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:04:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4E6314024E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:04:41 +0000 (UTC)
X-FDA: 84504317562.16.F5335E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C938F80009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:04:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mx2DtyDJ;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6toeGU0nhKwnX4pwIVqNYv0tZDnPxk1H+3bmGB4yDbE=;
	b=rs88h1e5uFM2RUxIFmA64Dw8AZz2rVnY+84Q88wsf1Yvk5kAaLks20iO1wsYTUt7Szj1eZ
	H5uiry93uNGydRpXqUrRIPqyhLsCOLUvHbYQjkZeGkClQ/S3b8xWFOrQ5wYwYyy/rljZCc
	JyKMcr2qabrMbziC570XWXilGfTzwhc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mx2DtyDJ;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532280; a=rsa-sha256;
	cv=none;
	b=flyIWbXjwgdRw5GzkRt3yCm095Bj2WDmu/zvyuzztQLFB3yhpesyGJVH/Nr7gyUxARWUz9
	HOE4+rTEggM3UIRi71+etmrLI4XFviByZQfmtwTU0ljH5GrduFpynoe9EvcG6snjG07raw
	Jn0RjQAvpv8oyTLvXrsO1jxczgLm7sU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E406D43D31;
	Tue,  3 Mar 2026 10:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB44C2BC9E;
	Tue,  3 Mar 2026 10:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532278;
	bh=nBHk/k5yZiF4QDZtLRFyMKhnqvy9lUM7CbMD3M0dOaE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mx2DtyDJxOxcvJtkTJ14WZx+n43p0eMn2oSshRNuNg6xwLQVfmgPttBACZ9PwVrH0
	 +0LeBAbi+mclNpvLi78y5IAI2qQ7SPxlrfe9YCx9K/SdDivgyIyZX7BoMfQzpZcjYl
	 mAysBAWJUiT3Ecf4vSaLx2I04WFhFPLMT/akz67y5gXR7QFLPKSFXBIfzXBeJ47rUJ
	 vfFiPqltsncVw0olAEdOkoQWp7CLijdZJ40iSlwTA5ON+P3VV0s/pJVsY1DCWgIMuE
	 bo/MYkqphL7BjK2EMT5ojcNjMMZnmU5kKII1gwJMXmE3xqjvN+gddFEEjGbn9c+hHb
	 bXVzVyHiDdM4w==
Message-ID: <2d11be07-c142-4cc7-9fa9-f6f3243b5c72@kernel.org>
Date: Tue, 3 Mar 2026 11:04:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] mm/page_reporting: change
 PAGE_REPORTING_ORDER_UNSPECIFIED to -1
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>, mst@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 linux-mm@kvack.org
References: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260303093341.2927482-5-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260303093341.2927482-5-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uj6qtyicm5xp7xje7topc4bpq1wecif3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C938F80009
X-HE-Tag: 1772532279-741474
X-HE-Meta: U2FsdGVkX190+jPBlHlGucFQ3azOyUKNylnz98xFHdc8HLrkRQZwjV+OyN9tS+bU+z/XtccBJv3yIywxAFVTWri69qQD2eK4klUZzJPsrGxgU5IYaHHuhSY8R+H7uz6uHMRDcGHoIyr2CJYY1SHz8zl8Vx3Bu5lj2HKiZ02KuGdywtbN2qPinevqVkMmrBwr+Em9Pfzhg6LcztT2DPBh5/3/hTg4qb/nRTtSYozU4b89J2KTLsJgH6djkA+sdaUUJv0NZUbUeX3vOGrza78VNemzmlKY/5QAg+Qv34YRISyKSWtyRdc93pkoBaGI/PUN59lwYFqBpZ8FBRgZ4/TPJhWnT0MnGypknRacQ2WV2hVUiZfUBj/RKT3mKURJ5eRPqoKEWX1OewY/5lT6Kq2gYNip9JHBo0yfQ2F820YggZoTddwiQ5l2TQ5OkVS6R0/f2lRHC4x//h1rcCjG99Vf0zIl7Kf+FGUN1oIzZg//dT1Tg8VF48RSPbFyU+9bpAF9d05q5cfODie5IHOT0pljtohgk4/qX9KN1dzi3lND1Q/mLMb5b4FgqrOqIsSrl4zNL62T25iwBWXcovurVWNwgI6yhOAiiKoOdOzOPQ1viZdFNBeNmSK970xoWkfphQT+kHDxKvGm8XOmReRjJ9UFDnTssXBkctEQH1xmm/tpk4UeQnNm3tpdzuH9pueYMf3p5i8jMQKLejATCOQc6regPbtefTMpuafR6VU4ZGN00HsQuCDF5ob1J1gFKEs0XD+ThFP5p8UBH9KG0fKBfNYj08APod5W+C14eVtTROQ0MwPtl/m55eQYfFn+5OmXBjQ2g9LYCNmIZ3Twr3RBADYf6XG7cT9F6c5UD8JoiFt/CYBgMIwojMlCArN26vPmMig66sCFvxUVfJD5roMXCTcSB1qBk0oOJRBG5TLNdt/ZTMkoVXbB4QX4PLi7V+sunK+8Ps2G+Fr+sKAEiFc6dXY
 Z1g9ZyuK
 xvUiZYkej3EQw9U7MXDZ7bR5eGCC9sFP/Uk270Hscioi/wzQJYp5GRZl2o2hGOHH6/I/ScRFb6OUuXK6g33C4AVo2JIkfwOpSrOkJ//gApqtBWz+ZSV3yK1lwTWtNr+tqxih4y9SFoWjPpxwOxueNYL/06497RgSzAkYXZ7BbZBNSXqbrUAtJclm/mKGygFjMEEfWnkRG2Opv6sgmORrej61L+ko/MAOgO/OaLQQ97uEGt9HtJWVoqNjIgZpsQ5zmS997SlQRzmKAYuF3VujUlzs88m6+VcAaMphs/74tkeaJxWeQdmR3ebBcLYhG3FeHq+2ZtcWaHkFcB83n9TgWuiZg1qhEPVpj+14F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 10:33, Yuvraj Sakshith wrote:
> PAGE_REPORTING_ORDER_UNSPECIFIED is now set to zero. This means,
> pages of order zero cannot be reported to a client/driver -- as zero
> is used to signal a fallback to MAX_PAGE_ORDER.
> 
> Change PAGE_REPORTING_ORDER_UNSPECIFIED to (-1),
> so that zero can be used as a valid order with which pages can
> be reported.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

