Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6A8FA1FDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF14C6B0088; Wed, 22 Apr 2026 14:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8886B008A; Wed, 22 Apr 2026 14:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04C36B008C; Wed, 22 Apr 2026 14:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C12086B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:04:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 413E114019F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:04:35 +0000 (UTC)
X-FDA: 84686966910.17.E3133A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49C01100015
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:04:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ICwhqcWp;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776881073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2F3g6d6VA15BeFGaNVIkae7VZCuf6YcespTT17PM5hU=;
	b=DGwR5fB1UinIxMdlD0ifEnAD1NccKB5Xu7+6auuF5xRPqQw6kfgUKUFcoamAss01X2uI2E
	H6WNrc93mgnOll/bkt86gQbH86oS2YKndFXL+T/k6ly+VusSMT+Tvgk9sYm3CccR63gRdF
	MPzvPf2HstyVnd13eAo/hCcbQ2oqsts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776881073; a=rsa-sha256;
	cv=none;
	b=vxm8yRTxyQSJK1TeeFn5C4Vjhym5+zeW6JoFENS7DQLU8UuvXAWPSFuq96eUzelxZDKeYe
	WprVZQo/zeOlC0pwbyQ4Kkd9Ha+NOGVToy00YCoj+dlO8SbEXeEHgAgW6PWcsste3q4WDu
	Ix0mPMawKotb+FoXfX1eqmiP6OXZPjs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ICwhqcWp;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13A9A408C4;
	Wed, 22 Apr 2026 18:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E69C19425;
	Wed, 22 Apr 2026 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776881071;
	bh=FT7qUlRZU72eX7Ib0Otymj+Rfvzh6OZI/mPEvRmG1vw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ICwhqcWpHc8v4XSNAW1f41qODRmYX7cmtCF5n2ebEGRaYMlBEhMEpeMExokjNbg8K
	 rMDn0VpBgimcCP1CM+aifHyf+4l3IpxcQ5wC1pHYxRoTlYYYt/lrcaJriLl6ixTJjb
	 DpKTrZwT/CBdmjGbc/MYopcTv2i0F4014BjefHLqkJ5erQDewA0FTdVctgnVZ1WNZz
	 UcC+pOVTUPz7tXPH8q6szr+B/Tdclcv0+SG0Xn8umLDmyrjS4HcUyeWl/mDNzQeP7q
	 ueQUMcJRHe91b5Nr1YK20TyaESmTcFR0G2A2lwzAHOGvj0t2CYzUkaM37eG0R+eyMq
	 7XlqRoYy47MJw==
Message-ID: <03a23a7a-58fe-42f4-a294-9d688ce33e2d@kernel.org>
Date: Wed, 22 Apr 2026 20:04:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] selftests/mm: use pattern matching in .gitignore
To: pratmal@google.com, akpm@linux-foundation.org, shuah@kernel.org
Cc: yosryahmed@google.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260421183000.1541546-1-pratmal@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260421183000.1541546-1-pratmal@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h6mg89oyo6k3erzx7tr5cyrrwbtq6356
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 49C01100015
X-Rspam-User: 
X-HE-Tag: 1776881073-515422
X-HE-Meta: U2FsdGVkX18peRDdibJKWDcGyAztiwLG6t1D+Rv2yWZCrIaWFKlAWiX7cf+dzc1jW5EV+elamtBckB1TMOsbd/hYSJrPs8cZAIqDhkhelFtwBD4RUIR77o/x+Zl/ohRFWpJfoy1hn9p8K3tqh6uyeIJ5umslsaDp2ole/uArDtLVdGp6kmsKyecrXXg829Dxkjj76feGz+S2dCbkEd4wE9+Bi3ZR96MSdWJKhaIZnCmzKhzBKq0iHHqdH9W7dktkYvi2smOLbcx/uNyP38gnTTTbPsaIh/+/Dw9QGVMe1fhuG4FY3n1rXgnARaEuChe3RaBJqTnTuq/GMyg5AK6xWPEHKhqduRhVUOUuqtEZ2DE/1c/JuXakgxfTBI1jzCs1LCWBeol3MIAxnG0/rS3Q/rfYD8NyePTvW3Mo59m9TAlftybIeeotKSEsSe3i2ChIS+BXmOz6i7pu2c7MHG5EicZIi82/XNhY9aLAwc2IX4+RRdasgTGY7LTouKiqjl5Eu3m4A+v+yxduxHj6IdnfhYY0MrLeijRx8DwSXJQ9tfinGitLKAEvV18AlhqRBcZ9fTOFgIJnI+iSEKvdPX+nbOnnzqIxhrb9hKQSDVirwBznXY/irDVp+QH9phRwqxtqqrBVJep22fkOlMfA8mjVaiT9fTL8+ylGa85nTzfW9sJx2s8+zc3+Im5Kb0uaE20lrk2zEC0XVf7uHKq+Zr/gCf+JoiY74RPfCgk7UOdI5GoPPJjVRkPQqSWkyJZbmr0Z/EFYx1QQjYa131TQzUNbomjNdS51zXfI0gVHsz7IP5/2D1h9TI9TRipk8xqYU5NQE4ovooMgfs7ywDqy8ncPK2pUencHFn9Ff2zgRWVoktZh3l2zkUpw5Ok/t51XvmXhLNIHpFFCcpFtkLNmgH8tGHNEFbVO/IV6mRJwm+1HURxnPz0+RG/41LinNCuBuCxtr4HKUMziyM9SdaleEuy
 SSOC+Y+G
 ffmJ+mTvXf1EXBkD45JYdqGQ33o3o2LnRxiRh5Qjw74LIFuhpM952AwpRBmRIju+re1SMFfqJj2XHqIXlWycmaBXfZ3KE3G3HVu03SmB7FcwD9qLy0LVFyitj40rqkiwjw79fE+7i4/MN2lrBRWas19ljRUcheGxepe/K6+tG3ZYljIgA8XTxm1J0wMH5P5NKd6Mh745MgYNDgNiCqqP8UhA099j8yEVVcH5Q84lzzzyfxUpGB/QlzJPehknyrdr6WPGSEjERlcC45pqJlnLnjVw5MZjED2sy4nAo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 20:30, pratmal@google.com wrote:
> From: Pratyush Mallick <pratmal@google.com>
> 
> The current .gitignore hardcodes each generated test binary by name,
> requiring updates every time a new test is added.
> 
> Switch to the patten-matching approach similar to KVM:selftests.
> Ignore everything by default and then allow source extensions (.c, .h, .sh)
> and tracked non-source files.

That looks pretty nice. Any reason for the RFC? (iow, are you unsure about some
side-effects?)

-- 
Cheers,

David

