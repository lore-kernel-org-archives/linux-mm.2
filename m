Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F342D609C2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 17:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5F06B0005; Tue, 16 Dec 2025 12:09:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A38C6B0088; Tue, 16 Dec 2025 12:09:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1DA6B008A; Tue, 16 Dec 2025 12:09:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0B06B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:09:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE97D5A725
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:09:18 +0000 (UTC)
X-FDA: 84225969996.25.9DD05E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 251784000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:09:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bJouOwnF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of tycho@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tycho@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765904957; a=rsa-sha256;
	cv=none;
	b=4YvPZL33liJ7eMGJp7M0Khs1eOUppWb08z9ZxF2wdK1s4hCOwMRN8Vq2VNX+R430eX4qtp
	NDVEvq7A0PLv0ix5uwDj5GP0oK4jHVQDouKdpR/wcc5cMMHMCsa83mFhZA8ooO1smYXIeY
	lcLj+A8p2RspkLLd6vmxsnIa8lYa+LA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bJouOwnF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of tycho@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tycho@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765904957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pD1+bUw+JYj6yqrGnIk7l6zAdBaosCfUzbPyVabw94=;
	b=F9lEgdeCBE/QHeKXQcdow0lAphErbj+5LRKXL0nJ6Ujnb/DMFU5XP4iR0jnfVhc5GR/VpA
	UT82b/hunyVp93zLztk6Kor7cv8ok/HMh38UqdlFgrJvp1IAybUQxY3M8OjgANpcuyntLv
	9MjlPv/H2B0lr8aVGKYIfrTaC5NO6SA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3138460138;
	Tue, 16 Dec 2025 17:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32F7C4CEF1;
	Tue, 16 Dec 2025 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765904955;
	bh=S8giOXa+oneuaqnAdz+6zpK2HTbbqMJTM2U8B8DZrfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bJouOwnFdXpyD9Uqh/z5H9qoiIeQo59KWtl8PIQmkLF9cYDkJqad6LYPJ3+0kILfA
	 NwitJJIHP5RXMB8p8qFFemb08U08un7I4Lu9Iw9PefOHp5O5HWsMiDbpaU6TSQlUBv
	 fVijeQtukTwrvNY+rhWBbTcyvAHPmO5asIWxRRUtQppOUK4X7vsIwok6pqhEHkoMBF
	 bieMcfMBvKUk1mIawERgxJofdafcGV0As65DxfSbSGsfXyDqLi4+7+k3cGxBCK+3Sp
	 XuNQJUkmfypHZCVjr4Nrngz/jTpsoa/LtaqDEdNAbFXXjb885oP0aE2W6N7Z2qxZzU
	 e2uhD1jqlE0eg==
Date: Tue, 16 Dec 2025 10:09:15 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, willy@infradead.org
Subject: Re: [PATCH v3 2/2] pid: only take pidmap_lock once on alloc
Message-ID: <aUGSO68Am0VWVAuv@tycho.pizza>
References: <20251206131955.780557-1-mjguzik@gmail.com>
 <20251206131955.780557-3-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251206131955.780557-3-mjguzik@gmail.com>
X-Rspamd-Queue-Id: 251784000B
X-Stat-Signature: cpqk95mi5q4ygiunzih49ssgc67cxcfi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765904956-877237
X-HE-Meta: U2FsdGVkX18btPqW0/tvEaerL27Poxu3QgfhEpK5lbAMA6cuF8b4Hm50O9Txa/BLtdIIHE/cav8f2AgFpsE3SqmEFFjcqdp3KsLFHzCT39mPBRgagmvEvoX3M6QNDtdw31w6DEXZTpFUWRFk1Ke5fBdqQRurx3j7P0ROiTgbfJwF1S46yakBWEhcP4pWl0j4AtEiKkddkM3c/JLaskMr3PKHMfy2BmsSVfN5KWHFCbL2s2OfaSLY9HWCZValpY8uaP8f0ISJ+QOwZqbVpPIEa6LH5udi2l+kKmDGveGQ3rGjOb6bX0UIF43iIffywaRYTbh7s8ArVfsDDi5M/Bmsz4yjpcESUhQW9aakNpjoYqTi2d7XUxkMCNH5CzhVGYqO49IZitA4ylkZM55zBD/Jb2TboDeNlWf0ma9gyC9VhdxXOnSFobdF+Il3O80+xk4N0/FlwDYEoJD0HD0O8FxnTu6UV1aM6sKNTUtN+g3PQItq95C5ShH/yyUhU5KsvJ5SAhdW2wNQFol9m01HKEOzl/+NM0kCXcWrph0SQrWadrw0niAA5lHY2m2a8bsTdoyXYYSYEuH8JX7shxVe0n+5umQ9NCYeKE4xqUeik5EU20Dwhc5xGAGfttQYwYXTnZWn1I75R6khjoHSml8TOYgwQnYfW3ED/bLHZPTC/EtzFyZGS44x13j048TEdRab4HIZfoA3vcD49ixP9HWb6TavdAtCuGEIhYOB+bLMGXr4RUjV5MXXB68kkiCWtxPxTlomDCbZzBXxreA5uTcAHp26GT0CB7UhADqMue6uSmV08UEBYh3xRB25e7YV5cS5qltGhHGYgcrnCKjW3ojWg9vE4oget2kpk2F262IILk5vQbBiq3AIUGvlsbE7PmCFRnF979GlOyS6fVXrDFcLw+/d47uw+9aw2m+jFVSaF0781DCCIcliMQccD3lXAnzbw336fNO+6N3xK+G6hZ1Gvc+
 rCFd1M7E
 6KzmjvvnK+Mo+HiKl/1k1N0X/nmW8sKi060Ha4ByU7XGinY0T1iOLDwXHceItJXe4vuHq3wz2mLfuiQJAFGPN6iElhGj+CYUVKQmlqpp/3oMacKkSQ6nd5Z8/Sw1XJek9lIyB5pjfxvb270+aCI57kqeyUyVNoiwM/yBV8vV6uhUKC5N7lHApGs1qE3gpo73WHlKDmUwwH54mNrcaPmwUxzgYw9MBR1xb78WQt/SgMUrh1MO9tzWt7bTX53pLPrsS27J97trqZ7yBN5uBxS2bsvIxFyDol5B/4WzOFJsktjdiozRKS2rOT8tetw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mateusz,

On Sat, Dec 06, 2025 at 02:19:55PM +0100, Mateusz Guzik wrote:
> When spawning and killing threads in separate processes in parallel the
> primary bottleneck on the stock kernel is pidmap_lock, largely because
> of a back-to-back acquire in the common case. This aspect is fixed with
> the patch.
> 
> Performance improvement varies between reboots. When benchmarking with
> 20 processes creating and killing threads in a loop, the unpatched
> baseline hovers around 465k ops/s, while patched is anything between
> ~510k ops/s and ~560k depending on false-sharing (which I only minimally
> sanitized). So this is at least 10% if you are unlucky.

Thanks for the patch.

In a particularly pathological case I can get a substantial
improvement in kernel CPU time with this patch:

Before:   Time (mean ± σ):     53.007 s ±  0.148 s    [User: 430.891 s, System: 12406.459 s]
After :   Time (mean ± σ):     45.624 s ±  0.394 s    [User: 435.021 s, System: 7692.072 s]

across 10 different boots. Feel free to add

Tested-by: Tycho Andersen (AMD) <tycho@kernel.org>

> +			 * (the routine unfortunately returns void, so we have no idea if it got anywhere).

Is it worth changing the return type? The underlying function looks
like it knows whether the allocation was actually successful...

Tycho

