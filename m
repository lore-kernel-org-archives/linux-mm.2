Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B428FC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 23:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50BE46B0096; Sat,  5 Sep 2026 19:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BCDB6B00AE; Sat,  5 Sep 2026 19:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2D36B00AF; Sat,  5 Sep 2026 19:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF036B0096
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:09:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F97BA442A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:09:30 +0000 (UTC)
X-FDA: 85181252100.14.1782C5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D772014000C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:09:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C7dIJfzp;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788649769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MvH/fL/MoL/0Xg/K8Z12nlCW6Dkm7qOIbbrTCfZHRA=;
	b=vb8zUJ4axUg4XVmYhvg0BpRQ1wRl6/Jp/NKux69T1SsDfIxDqzaUHDX2iWQxuNUhS7WG38
	4s5jf8cfS5dIIJM/fdAtPqjWQKIdTUr1RTsV7xrziRmlVu8KYLHWN+086oV1X24IhrhQFp
	AOHZ5J/FfzL7zeZfKksp/sFkPMLa40Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C7dIJfzp;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788649769;
	b=OQzq/4oH84gsgwA942aWePFq4R30ggko2eOVQ9tK7iH4R5Z3awem9Fe4f3w/A/4xihfQVr
	S3qWDZ920mELHNA/QY2/sTC6HZcIbwFEgAQwdG74uub7u0XCJsQGX6mDkvSW4Y3vFg4Egi
	lZ0IpK9pc6am7h7Yqzt5Hwu9PL9YBLc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF89160AA4;
	Sat,  5 Sep 2026 23:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533DC1F00A3A;
	Sat,  5 Sep 2026 23:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788649767;
	bh=7MvH/fL/MoL/0Xg/K8Z12nlCW6Dkm7qOIbbrTCfZHRA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C7dIJfzpfJ+sDTZ1NygWVigYa2VcwgEfAjj9LTpyc1yQQ8opPo6leshC7FwEejVbZ
	 7qqz3rLYlh/DRo55oG9x9cF3zOwXJ/+q7GTzBYovAJcEEHlPdUFC3vTKJeo2gw4gM4
	 dOp4GufsgbaFSrNdmD7dnvrK9H6DLOXBS6ZyDufw=
Date: Sat, 5 Sep 2026 16:09:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/zswap: enable static key after runtime pool
 recovery
Message-Id: <20260905160926.9836f2ca0dc977b89f2f146e@linux-foundation.org>
In-Reply-To: <20260905125101.2970456-1-xialonglong2025@163.com>
References: <20260905125101.2970456-1-xialonglong2025@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sfe8hw7qkn9w4kfcmz7iiapyaps5934i
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D772014000C
X-Rspam-User: 
X-HE-Tag: 1788649768-85085
X-HE-Meta: U2FsdGVkX188kbohGtTGSiLvXt7r9V322ZAdWdgnWfhHrvYfiNb/BBpcT+yf8YSa7H5EpkIfEJAsTmkVW19iOb6+MqcFA8TEU68FADiE7Tofi3XIkDCsPiNsSfpnU+qY7sbmx6eqeU5s9z3/NzN335InMCSVsJp3vTqh3oUo/SEB6Bz3L64kWFJbJQGaDZ5PqqvEqfugTs8mNTMezwjwwQLQGQFZ1pMiOS4tLeBov/MpKEmVsEMGPmcfZoxfGNZcuWPyOWamvYRECyOgRl0DFfZL8bG3z/llrh6MJ89bWwmrtGF5pKCzHbVw1QZYX3Inozttc2nPkbD+CjE3yq0+mH+O1izs+Y9ZvgbwBABYq+B2gQxXWT123LClIxaf7UbihWCOKz02jBBNWg/m8USdUozEEZZBfsFy4d8eEi6WhoBeXYBwfOJfA8GErmKh7UG6NVVMQ1s3xuK0JrBTFgW5ZjJTOqfRhFb8XEffNU1swinm6Q2TcZV5LJRFseTbjeEyxaWvcqMuo5ZDC0B1EZK1GlE+5rGIrOwOtarWqxpyI9njyDwyp/R+BEZqHCQCHHhHOiw2FqoNCmqxF+uJEyZ82dEaVGU9A/rE51khhcr0ymsi7iD83VLxTiSbUOpAnO3GsTR+6l6PSamQ3tr3cpdUUbda8f1VUPmxQte2Fs4ebFnDH4fjqCTKi2erWlTuvtbospggX/rtDtlqs8JuAY81zPMCgigiMTVwDWd//4mB7g+4UVQokWE91AnQe5H2ampmTBRVix1+nVarQoAg1gk4+SKQjsPgr+aLrVaqVhAEpOvGp3sKns48WS7vSRfNZHd4s85JVuJLq2l6Lkg4C+6Ap4Vt2pmIpZXG9J1sbAQAqtKYRXm2lJ+Qy8jRZP90iBw5/1/l2Uly8orWZ5ns1kEsW/qTU2N+Y+kN8GZxs1IGd/N1XmYTt8WMfnVkxQCRNTzgVLOoSYm3orOlOfp+BEq
 DmicxAm9
 QX4ytHLMjvaXIqtCWhrgG0SY5qsQthc+FP0VnWk8EkMCi1C4lzhQffGEYJ9HnDZ5LKHiXDWSWDoy5yx60QSUn7X4XxlIi6fFvbsRUF4t1pxSEYvpN03fk7plZfuvbTPvYaslIeCi2ZZTWaiuj8+4ma60abvG+AKTj5kJcnrPy1ugRZFhxuaf8jqJm8VrEuFosq2M/FawqDdkxICLh16TgV4Ao65wntEoFLj0vmarQh7zCiWKkyt4VGwXV+ka6J9k5dRugG33awWhnttRFrSzSFRGP0gD585hgqWOQImxamR5qex2tSTycVGvyK1ikFaHhMdqMqHiyP+9IzcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  5 Sep 2026 20:50:28 +0800 Longlong Xia <xialonglong2025@163.com> wrote:

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> When CONFIG_ZSWAP_DEFAULT_ON is disabled, zswap_setup() can complete
> without a pool after a failed initial pool creation. A later compressor
> parameter update can create and publish a pool, but does not enable
> zswap_ever_enabled.
> 
> If users then enable zswap, zswap_store() intercepts swapout while
> zswap_load() still returns -ENOENT without consulting the xarray. The
> swapin path therefore reads a stale backing swap slot because the store
> skipped writing it.

That sounds bad.  I'll leave it to reviewers to suggest whether this is
a sufficient description of the runtime effects, and to decide whether
a backport is appropriate.  Please.

> Enable the static key after a successful compressor and pool update. Do
> this outside zswap_pools_lock because static key updates may sleep.
> 
> Verified with fault injection on a stock kernel (compressor builtin,
> CONFIG_ZSWAP_DEFAULT_ON=n):
> 
>   1. Boot with zswap.enabled=1; pool creation fails, init completes
>      pool-less (static key off).
>   2. Echo an available compressor name to zswap.compressor; a pool is
>      recovered but the key stays off.
>   3. Enable zswap.
>   4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
>      fault it back in and verify.
> 
> Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
> without this patch; all pages intact (zswpin=131072) with it.

And thanks.  Sashiko might have found another issue in this zswap code:
	https://sashiko.dev/#/patchset/20260905125101.2970456-1-xialonglong2025@163.com


