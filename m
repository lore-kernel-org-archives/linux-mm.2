Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF8FE7E350
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 09:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641556B0092; Fri,  3 Apr 2026 05:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3066B0093; Fri,  3 Apr 2026 05:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507EA6B0095; Fri,  3 Apr 2026 05:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 416AC6B0092
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:07:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD5FA13B3EA
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:07:45 +0000 (UTC)
X-FDA: 84616666890.06.27A8B3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 45A384000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:07:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZbGkZ0Q7;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775207264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBiPr/LPaDiI/+Zua8YLdBj4vw+9Uuswp0D8BLXsUFI=;
	b=wMkeULVy0ZTeLxbhL7IRF8Dz/gKuSosiZU6QgslRvKiK5LgN3BmeFS1oEdPh6uWAmLosJe
	TtRczqZIfRmYsIO1ZVi5c8lH6QhNfJeadUKqVqdXm/zLV/YepJJzAgreLsIcDJVhhlwqwm
	IOaaQNJFjMtIRzzmmij2OXpsbCLawl0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZbGkZ0Q7;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775207264; a=rsa-sha256;
	cv=none;
	b=mJhnn77f+7jodLVvuwgMmJ5OLTYRtjppOfwYELzwpW8lSq3hmafg+tj/mnSt4oqP0emQFQ
	5h8+R9S+vwbUu83uQvUpwYW86dRFxSm0okvUGhgUqmx/DAN4mplWT6f0wBl3HeEKbzbdq0
	KJbMZqHnqwwY1UNejJXzGFiXsFXpaDs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A59BE60123;
	Fri,  3 Apr 2026 09:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F5DC4CEF7;
	Fri,  3 Apr 2026 09:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775207263;
	bh=vowq8IJG+Pp2R7a0Oh6mtSU+uGeLVlIHd8LF45mK0xs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZbGkZ0Q7Wk0WPub9h3c7r3PS2r9Vw3NwWoZYE5qjFuloFWkpL5AKiZRBNYzRPOxMf
	 MCf4Ys4+VxjB5HngHaw3w7nqPXqolsGMYiASr4sLtTF9bWoPnWvQTuabABEEJDPNjP
	 e8/N/KHwOav6EUpEnj5xjk9sGbtGK8QtIbn+o+tH1xipTdaihQ+LDhKo4/z+n8ThrZ
	 cpdQ/dWiuhTNdTdD4H1uJPqWTW+pqNUrNtmIoquk5kRTDUyqMOcM8NNWC117GO+RBL
	 gpbxXq4cJJJGyygnWOMoOk+MKgrAXsXKGWx4mwNMRXmJx+wcm9PaGkTV8cYKd50l9g
	 crSv8Ou/q9ysw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Chenghao Duan
 <duanchenghao@kylinos.cn>,  pasha.tatashin@soleen.com,  rppt@kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 6/7] mm/memfd_luo: remove folio from page cache when
 accounting fails
In-Reply-To: <20260402105417.b495f2fbe9069caa19ea7b05@linux-foundation.org>
	(Andrew Morton's message of "Thu, 2 Apr 2026 10:54:17 -0700")
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-7-duanchenghao@kylinos.cn>
	<2vxzzf3lfujq.fsf@kernel.org>
	<20260402105417.b495f2fbe9069caa19ea7b05@linux-foundation.org>
Date: Fri, 03 Apr 2026 09:07:39 +0000
Message-ID: <2vxzmrzke7j8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 45A384000A
X-Stat-Signature: 5ekwdetsnagi8cqmnczxssjdtkn9nwpz
X-Rspamd-Server: rspam06
X-HE-Tag: 1775207264-567692
X-HE-Meta: U2FsdGVkX1/taZWptIx5PB2Df6rANq4vy/AxSv8ulzDSoQRh6R8tIl/o7BKw4Kon1M0yW7y/yes8cuO35DdT6isaAE8GFi9tCkahhVGnNLC+mSQfnngUCbLe1Ibe6CJLSqQMPD0nGc3ocPuEcguYaCnibxXPQ1b6m0f6J9CteBuN38C0dGzyoqTltLmZAQbJiqglaKFIc+JUK5BtmoKYmnpWXJ996+mzzknQ9aWlNZVn9eDt29zWBx1Aq+vOBoYejKE0Vr4Otv9zPRC+tCX2kEYDpiD8cNUZHuKgjAIO/xCjBF/I1UvA+0wmLwLgaaccl1E57qnkXbpj9FdWy95x0wQqVp+DFDYPVIS/xqjM4PuOoLQBoCwLyqFTU73GkfPmkPcONC0YkJzHX1iRcMrE6mG1CsOU3c1v4WdzlMr5s+Nl8toVnwozqQZ4UJiEACRv/eUkTBP3BWNEAlYb/wcaJKM4Z7Vxv8MQ+/vl79EltQuWf0UoK6GCboJ5bl9r7UF1+CHxu5sU1UGyGLqvgcvw+XZERTGi7YtyESXQGWogYyZUbgkt+SEF9Id+BLUAR4o8v98WlY3U6C6FrbsU7bstd2w8iTXKe9+ewDOv3kQiiAj7QPvf3+qmc1CB2tTCECECvNJXks4c/90/8WBa7Q94qYOd4XBBLkAhNoMEiOzTduv1exEugtvT1kNI3dAil7r+A9My73VvTCssVm8CQy4uBafhRhzEIRwel1O3zxfqAoGRgivw4C4OXr2hdHrfXtRhuzKX5sLr83YfHyBhPG95w2mzwyR1uMt1G8NqdALD90sakd2gyqUty8QnAJaHLdWhybZoWm3PFX5MWO4p4AFCaa+WY77Hdx2JjE3S0gHEjqEvBipqc7POn1zyNmmN1ej0DZa0Ss+yDhp+TfF1lQMbujVvcZGHUOAQ9VbWvN+hOJy0XgNH6FPK6N2Nlf5EOiPG6Yy0aRmwisWK1o/tmSJ
 67yVg1Z+
 9GFCgQ6gn5AeEj/GxU4Y3HSzv6Q/MIkku0oY0c63laF+NcN6MdnKmj4zBnekI5uGzBKwXLIrDStyrkHprG/PXsgwwF3qdU5My6BcBzGiwo2rfykvmA1MIIp3IQf0Mc9O1LWnqp+18Etc0yrO1NObpr9H1zcW8fsR44DYrTY8jf19DhrFcrJVIhs3omjZeLY2URc4F0RkOhhpL91P4W1ndeL7xZGxIN7e5hl+QJ206muD2Lp2JGza14RxWWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02 2026, Andrew Morton wrote:

> On Thu, 02 Apr 2026 11:52:57 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:
>
>> So I think the commit message needs reworking. Perhaps something like
>> the below:
>>
>> ...
>>
>> With that,
>> 
>> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>
> Thanks, I did this:

LGTM. Thanks!

[...]

-- 
Regards,
Pratyush Yadav

