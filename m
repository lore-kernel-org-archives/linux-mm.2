Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB009C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53936B0092; Wed,  2 Sep 2026 12:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03F76B00AD; Wed,  2 Sep 2026 12:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF30E6B00B2; Wed,  2 Sep 2026 12:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 833486B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:36:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 126221C1898
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:36:24 +0000 (UTC)
X-FDA: 85169375088.22.09B3923
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22871C0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:36:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Te8Jy+zU;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788366982;
	b=T11SPEq++vstj/GW82HsuoiE0ucv6AGAnhMgVASk2gNkJLAaQKbKE2ewG6LRghLPJ8iknq
	NDZhR5mxaE/9K2ysTaaXhaJoMqp9woAXSq32L8ddUXugUgG2fEf2RZ857Xww6EIwIUXRt2
	wgWB3dSQVhSiJWkXw+RyVzYZbbr1kG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9qWhK86vAI0vw7PjTHIwO4q0yPRh2De+EC1ifXqR+I=;
	b=GF3gTZuFYS8eVs2zCbvAfGuYrdVHWxfe72creBJKJqhZLmzKhIEb/YTwYBKqah+iDr8EdU
	Jkl2Li/VfImf2uN8gX1JOc1cVjngHxbXSnMDaVuN5MSfNtlmKBQNe1lbCWSAyFHEgXl1K0
	v5/iGCMY58zcwgQ0Z9zgJYKMvxzOeHM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Te8Jy+zU;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EA9E41942;
	Wed,  2 Sep 2026 16:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A3E1F000E9;
	Wed,  2 Sep 2026 16:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788366981;
	bh=X9qWhK86vAI0vw7PjTHIwO4q0yPRh2De+EC1ifXqR+I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Te8Jy+zUvZ0hd3XPvJweck6BpFfsKl4b97KSDSeiEwaoxE8x281Ees0rBoToIajjE
	 VaBnjFMzSefJGYmXbhUagIcNzPwWXHZIbhu5C1r9Nz6l97tYk8i5D8i30945uNkD+/
	 N6uO+Jz651ZEyyf9kDC9lkHkuN/W8Dzrvu34NsDPALyCF1jTmSc8IaagV0zXrh8YqM
	 SG9dUmXPNncJ+LMw6rlHX6DWA5kWD+JN884AXB2TAuJEGk7mQcGfMBBltHfReDw+6L
	 C5vMZb/dARDxGVaFxBZnGQuxfEXA+uvI04JxDzmZtlLjInnxlOv5Msta+IqaZbOts0
	 jKL8IRkjqT2rg==
Message-ID: <a16ecfe1-5e1d-488a-9c63-7ca38f099117@kernel.org>
Date: Wed, 2 Sep 2026 18:36:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: replace PF_KCOMPACTD flag with kthread_func()
 check
Content-Language: en-US
To: Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org,
 djwong@kernel.org, cem@kernel.org, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, ljs@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22871C0007
X-Stat-Signature: bestx1o5a55zk6aau6rrg9cjb5u3zkep
X-HE-Tag: 1788366981-823043
X-HE-Meta: U2FsdGVkX18EJn4m+4I9HxsYj/Y7c/TpqtTt6/U1343XbB0vsAZ4eqxa6NVQLu1u5Tl+Hvz8sDFk/PT0CYRGsfOEjXDjjLuAsQZTqxwRLaCS6MC7lq1MdI3k3vGYRYKAei1DKOBTR7DNK6PbiIja0+F5a2SygXEZfh7wjlW/Q+lkIKnZYzFjuzxcqPJaJM94EFQmRy7eHWHNBnFZQFEmzhm8Pk9zRPiZRIJI1CIpG/qUFGju3dOjaduOefIA8Mh7clOn5UoVVk1dUydOrsK/1Cm6BhDbKOFaMTVkk+SPr16DHgUCxmKtHCH80zpJvi2cRySGncGTc037KiPlJjt/6U7rrstH9Gwo/PPWHO6vNm1HKAy3uE4EuJoL74jWGowtMbOCyEryVbmpndqO3YDJPu0SXqA+U7wT3mtdQW/tBZB0cR/88zJMYYIX5CYd1qAfJLj+gZQNnU2CR0fg5sBxFaGs6zflcx2Zpn46sLwsmqdKj3myXW3nBUJmycEnJ/pFuXAbIvZD4KD5s3Dq6k07M+TFKp+j2wyYpTeBSp5P7SYuzU1gQPYIicHqa5YRP1IOmydE5WuHLMoHMC0ncc0SIapdiWPgB4LykkKi/C2Fyl9hmxiB0ehu2ZeVMUn0c3VAaXAWNAM4NupkRnE9c5eekuJiVlwKuTIByl1gfkwFeuQS6Wk+4peeiiRUTsKaoJZXxGtm+l5BTGCgnEGmr2lj8XEUA0RngoYMTYc35HkR36T3vPOsP44/oNHVpauklYAEJqyA/GaWscH1d1ThnpS72ScAR2U1yTNlqhPhSewNZI3SFdwmX4vgc35zA3sdEQ0iPYk/5PjIteVuqynqQ7jiX1pvSLgScSTV6vKUpFtvJAWXyZhkdsfRwB7jIaQYmbRnw5Mwi1oF2qKyZ1Gu8a5Re74cYo2VUrxOK3usYcXLrUDuOWx8fekkblp9mg5XSyhAUvgfQiO2GbIasAARxdn
 KfsEJJvO
 DTDstz2KFz78b7fSvLEZ3YBxvFqvbTlL1+hlJMYb4YEalYN5+1a9fAopwgMopVNr90gvhwvGjpwfQC+NADrjnno7UIRXyIQnSdxROKuI7VuuD6t2ZSkHFUlwFDzBvHaBzazU7tIyT2dI0yXQNvnrLoKh1Zf7Z5NqFiH7zz4qqtXEFnoyFRINJO4fn0f9gNcwY6Ag3Pw7ISbI2ONu/rntU4aVy2Uam35zlfunz6B28gTZOH6qxR/v9VKEZIMFpQmc+efBA7gtaQHRYbzomTBbkrGFQHgSoj+ZW1VtPUYJjIZTEcikEtA6tjLSSjPCWyywZhpMnYC/5x6/YHBLwGuhNDZwE4t9FwJ6Vze/E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 15:16, Kefeng Wang wrote:
> PF_KCOMPACTD was introduced by commit ce6d9c1c2b5c ("NFS: fix
> nfs_release_folio() to not deadlock via kcompactd writeback") so
> nfs_release_folio() could detect kcompactd context and skip
> writeback.  The flag is only consumed by current_is_kcompactd(),
> whose sole caller is nfs_release_folio().
> 
> Replace the flag-based check with kthread_func(current) == kcompactd,
> freeing the 0x00010000 PF flag bit.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


