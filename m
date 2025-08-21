Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37D5CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8A76B00E0; Thu, 21 Aug 2025 13:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89196B00E1; Thu, 21 Aug 2025 13:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5D16B00E2; Thu, 21 Aug 2025 13:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA9716B00E0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:10:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5443C140478
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:10:18 +0000 (UTC)
X-FDA: 83801402916.09.46249CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCC3820012
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:10:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=exGElCHi;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755796216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFVlK039NeI+AKLJORGIX/fzlpgo/tZ5moUFZ1xzdgE=;
	b=17SsRoBkDHQJ8ekORCLhvZ7zt/lnEEvbKyJ1gQ6nbjgCun60d3ET8VkORVLTD7VHdg8Uhn
	pnW4I65O/O+Pth0fRk/ipW7jT5PB/uWAlRMmDNpbtSVL2EPCZY4aB1yZJ8+TeH6hqKSJht
	MC6ywPIHycKldXgVUjAtYGjRqrz6gAg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=exGElCHi;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755796216; a=rsa-sha256;
	cv=none;
	b=a5iXHWLWuINIJEk/Brl2ikJ0ulniWoKc+QAuM6ejhI1gelHKdUDSQN0H0bx6pXm6CLib2X
	YfBrDKNG7GNr3V+AxK3u5f1C8aqwesFKpqQaycz8gFtna9KbzgK/lK2gcM+cm3bKLDIsnE
	yT6sHLuK5+SbRxgTHiWPMJWMxJLxHo0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E680601F8;
	Thu, 21 Aug 2025 17:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C9BC4CEEB;
	Thu, 21 Aug 2025 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796215;
	bh=iI8uK540bgopoq0pOE9qeewmZlSP/Z8gE7wwo6c/en8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exGElCHiv1aDaMOYVKOe5UvmhtQYYptdFQG8s76oU2GVNQnRQGLLnBevGW41uja9Q
	 TEbxmCx6gKNBjjLv3OEa5RD+pnJHfYG5xv+go8Mbe1OKOWq7fVAJt9hUQmkIM4+IBh
	 krEaKKkeUKCAfPmxQgykRtTu9lE7plOLxQuL8hKviEXvAPp/mwMW9bEKmsZeLMexDu
	 z7TYbipA/1tzu4p0OAyPE91WsTaMJy5z9xL19fEiw7ccBFFHFhrRj9LgaHSFHj51VP
	 RaS5pd/0K96+KYagyRoRXEbqlDWZRGm86uJAd2wfQFQGpyo2KrYpEbiGYlhjPTAX1e
	 ksKIjwy1kjDbg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 01/11] mm/damon/core: add damon_ctx->addr_unit
Date: Thu, 21 Aug 2025 10:10:13 -0700
Message-Id: <20250821171013.79499-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-2-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hnk9i4h4d1zmr6congbaik4s4x147jrh
X-Rspam-User: 
X-Rspamd-Queue-Id: BCC3820012
X-Rspamd-Server: rspam05
X-HE-Tag: 1755796216-524912
X-HE-Meta: U2FsdGVkX1/hD8tR4FUpc17Tq9O8I0orOEjBBPi86meFpZss2PHh9m9psbzH44euImsw4AqbLNYHGRhb8CbJrEq03K2VhLVrRUjGFK+iSuRJ5oEoE/CqoZlAk9fCU6wmprNgOg9DE7TC57H8JQSX0GUF5GWalYejsOnXemibHxr2q2rQXEpTc+lmaxR+E8mdQAFYyB4Gef/pu5njZ4nLCLKPVZxlI9VZg1vK9Ca58ZSDQpt29Tf595wfwdyNcgObKN+GR69alcR/0kVJMZpJSbLethE5r13YXci7W79vMgtykgCyQLkLo5jLEUIv6uHsEA5FXLdbpacSEn85ukoWQDcG7X27nv50TBJBKh9bXL2WjA3iIg1m22AIw3oWto/RTKRysdCzJm0GlseYrXZ8E94KoC0XoRiGcXcAIJc7UntltDVv1/ZxnDULIkXLE+3aJi1N0CqVvHEtjxyt+Mg/HP+AwXT39ra81PXZAA/muVbkbHOiurwh6rCS2j68rJvnsAIb1TV2esWvQr+EDS9ROeu20NCw2Q20KzK+Vvzc1/kD3TH4itw7BY0+ORsbU5ThGxSJ84IIQEJDCCiLDs1x7H4Z+Ag/4evBdr10ftW4UVsEChoHbZ3cbGOeY+dWjxR72VNHS1hmhcccqYoa+DAGVMFnEUNboArDcdOmMwj1BlkhvJL4+ccUdBTqseAN2uKaZrsU5nivLF6dIOgX/bBhOJgWrD2EB0IuQdhkjLjauUMOW38okAprbUP4407EhEJdr2cHoSWAZYH+WOhefwYl5aDxqVDBrD5GdjvPAlSFZZ0Y3v6EQyxVMmTTlf8/qKvfj3s8zb/6R+vaqm8Z3CjGZVl11JGsFAeIL7tUHMy5QET+ZqOwvGsCbZme67lQ974la1cU7LQ1iJ1delXIpOllmzF8j6aLR41qELgeNmJp3i64aAVlTOuVVkJe0UGcNs9YQzgYBOOuZPn2SzYDh/+
 xZeQnvGj
 qJYrCN+EpNLVCsZ5nNdq6QOxQEY5XB7WUTk+B0sn8XjBGK+TlbMgFCBYK8+3htawuk/JOZEYxyvIcvL/9sTU1xFZZir+/SFUqSHB6bcVqGVe5rcgjgJmGtYgM0SD3ZFEM8AdZXBeE0y9KI8Im/xk4t57OnkmZG5ioEOL9Qt1+JT4mZ+PlmsopczjKSOdIlUvh3bziGEcr0mY39Rlux13bGFJgSHqeGAAtOtKQZTBKp78549QEBE6J7blgPEJqDx6P12iGmjyIUTxigKW5ffWVNaCc253ymKr4v7Hkv+G6bjPfs9M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:49 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> In some cases, some of the real address that handled by the underlying
> operations set cannot be handled by DAMON since it uses only 'unsinged
> long' as the address type.  Using DAMON for physical address space
> monitoring of 32 bit ARM devices with large physical address extension
> (LPAE) is one example[1].
> 
> Add a parameter name 'addr_unit' to core layer to help such cases.
> DAMON core API callers can set it as the scale factor that will be used
> by the operations set for translating the core layer's addresses to the
> real address by multiplying the parameter value to the core layer
> address.  Support of the parameter is up to each operations set layer.
> The support from the physical address space operations set (paddr) will
> be added with following commits.
> 
> [1] https://lore.kernel.org/20250408075553.959388-1-zuoze1@huawei.com
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

