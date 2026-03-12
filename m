Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5751067058
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 15:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023756B0005; Thu, 12 Mar 2026 11:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13576B0089; Thu, 12 Mar 2026 11:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF47B6B008A; Thu, 12 Mar 2026 11:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC6216B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:42:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F6CF1602F8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:42:23 +0000 (UTC)
X-FDA: 84537827766.10.C9A92B4
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 325E440008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:42:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DfX1CMIs;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of hmazur@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=hmazur@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773330141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUquX7EHFNWPtYB9eI41OZzrhA9/tVr0orl5i+PcmgU=;
	b=IzmdyU5IW36/+mBBGE5JtVau0u7pUUDoyDCzeQeC63lRu7ToRIM8xUMqG3vrEb4E9iMZp8
	g7rN+TNceww11MAnwXkM8QBBXnJktiaRyGGOeuNozlH3sPZNqGTXPwifpvfdN6Ws7T/NX3
	Hy40I6NCBg7TNhGgAbTMZkJ9SDKOAKA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DfX1CMIs;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of hmazur@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=hmazur@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773330141; a=rsa-sha256;
	cv=pass;
	b=lu/FF4zSn64fWV3fnm0SCqGls0CeWr6u/XeW7zg5Oi9vFAfVwV0Em4MsAS25IMan71wKR7
	sycKYHhrXxlByZUTz1zTKcWTlBpfNnAwqXAGx5E/eNAVE/JfgCK8jvV7nS8Xl1ZUrmKBS6
	C7wKMSs6LHX4jTT7K0Nl0h1c+fbA3uI=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a10a116145so8853e87.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:42:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773330139; cv=none;
        d=google.com; s=arc-20240605;
        b=L5vFUSZH5wSWkWD2DFrLpIZc5LIYI4J5rLY3cIHEDn6IfSFS0D5D7Bay/UmzUc1IWL
         uToanxYVNrJTXdEPI4sl/7qZlqP4VsDw9bzXvRlU5lyxB7l+QXMFvPfdcRkwgCjsi1FC
         YGzHvZ1vReIagaHe9pnh6dGpY0l9CYYbaOs/KIXiO53Rlzaqxmi3SruvcRcX/nHxZrsu
         EI4+kEEAoCSsGIzuXSkoSZnMBuIY/+De1Gk3yIm7xi0TdDoMaXn1ojhDOhKHsgAKrqYQ
         kMM+KvZr96eZtcfxkjGJb4EseGLUCrrvJ8l3voNcvnjEXhErs9SLC1pglZqY9cb8aam3
         +wsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WUquX7EHFNWPtYB9eI41OZzrhA9/tVr0orl5i+PcmgU=;
        fh=H2Hvw7bZrK69zxAR5cjmuCGQZlxGFslnlAuSCfpefHU=;
        b=B674NPZm3bQB5Tcxxi8mnJEWSU6xsT6JwubMTU+gbrYR6srqVNjrt1PS+PwTdvCakj
         Hi97iAtL6sA3dI6Lte4S5rx3iGazRzOHymtzqzvQum4oYoNpqLxQNVZ3ZNaGoTfUb+u9
         mNlcMIFDc955MbaXCVRoqmZVsm12AoV17Pom/jVge1A+DPhZLDelzsCPRDANUUtGWhps
         RRXM2cACGZCWXTCZWyDO87OgldecottpFAuOKdKJE951EOlX/DsO3XzSRY983q4fvLry
         J3LoCqq8xG/kFPAM0bhl/sJG1QankMmmF8S8mFYKbdTIAuwxQXYB0tckv8d+2+JwnkHu
         h+Aw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773330139; x=1773934939; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUquX7EHFNWPtYB9eI41OZzrhA9/tVr0orl5i+PcmgU=;
        b=DfX1CMIsGeHnRWI9Nh8pq33FnN1uhU71DsaqPX+WR3z03tShnZrVxHNbP81WtwtsCb
         FhqxOGkD1CzS9ijqvnZqabb27gWhMAjI6LEUxY6Gu1qr0d6hUflYilR9I9AtW6wB9DX3
         QCZi14G3CQg4tYDTfIkiyjnBYN49FXm9JV3nuw1tt7mp2Yw17JO3NnrbQQhMfXBN6UVN
         GoDFj8afef5MwhpLb02ulgU/iyUhrR5dphc3fxnPhgiE4p9o5f2ic51mX9PaBqGxI7qo
         sRjPFQKmQcSpncSS8OFODkEDY21vhlapajhvlu4Ca0CqffIe6Y5bjdk+7fK3ZrHjaILc
         ZciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773330139; x=1773934939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WUquX7EHFNWPtYB9eI41OZzrhA9/tVr0orl5i+PcmgU=;
        b=P8kj6dss1lC8cq6MZ8Sywg5orzGZV3ID/gn+Bl/VqmV2gZGCISZJT8T34YPg8QZ3dw
         jDjtP+63exYRsaLvP8hVMjgzadGP2N6DQ6YL9J2kYKubBYjvD/IX0yrCwHNbHfA1VP03
         h47SpewAalnJ/xPLWxkWjeRvPnfqTa0tDkdIip68KmWh5SILDxEf0XYyWdlzvyckcyiF
         IFUymFrkhMutM9U3+87tAKZCRdxVXYVbbBsLemFf3RI/aDuvcsjbS34Eh+fPEj/4wvhU
         sc5Evu1KajQcBcJHUe1JLtV126KH5jOkituIMzEQbHJCmdW9kiqfOXueCs5o3sxch3OX
         hdcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkuvf5rv3maXXMvMQ7Ds8FBc3EkqPiNv7tDH+Lv8gK9Y7CIVg+/6Vtdn8+HVVd8SI7Q75Ps2MvwA==@kvack.org
X-Gm-Message-State: AOJu0YxrH9DchQJp8JIwfTpGBZ/oB00Y+dCqcurbRaHtF0U6aOc5SZB9
	pS9G65wU3zbB8uYLfkpRMcrRL8EFZSBcjpJwralnMb1d9qldagF5jQ7vqROIJmNAwQr56y7f5Hz
	ezCuobxDrlcADPQZm3XtSbT1hXA0s7krfmAWggBpS
X-Gm-Gg: ATEYQzx/1g1HAJ5+uO2H4Lpm3UlD7CbEnUWu2PmEbH84NhzZGdC/nzPQpGwlzkS8OIx
	AaLB5C40346ox2kakHo40Hy2chEaxcZ0Uu4gAvH3zQXNxjB4BWpCoSaC+Ianw/YbdD4x7SQ57FG
	0VTrVATiE1JloOj7PNIcl2rPfzhMZo6S4kqt8n8OnPxnBBbuJNYsjkpRK9YVFFFtgi46UQ6I8ob
	hhlUOXsdMyd8QyS/gd1SvkxHolD1Aqfnot/eAMChsbHuN1ZRtICNos8JfC7hmviP9g774IOwtT/
	F9mVqy8=
X-Received: by 2002:ac2:5d4a:0:b0:5a1:2665:c077 with SMTP id
 2adb3069b0e04-5a15cd4c62emr115553e87.7.1773330138725; Thu, 12 Mar 2026
 08:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260312131438.361746-1-hmazur@google.com> <20260312131438.361746-2-hmazur@google.com>
 <abLCuVgqKhWI6hcl@kernel.org>
In-Reply-To: <abLCuVgqKhWI6hcl@kernel.org>
From: Hubert Mazur <hmazur@google.com>
Date: Thu, 12 Mar 2026 16:42:06 +0100
X-Gm-Features: AaiRm52H880JLiAiNlotwkATfjl7SNJSARUEeOoq_5x3YSsZEJf-5tAcD1sBMNw
Message-ID: <CAJ7Hp_ptSEp9SkZtSFSSQw0uiDScd1yvG0R7iKyZqxbRBEF2gw@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] mm: fix race condition in the memory management
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stanislaw Kardach <skardach@google.com>, 
	Michal Krawczyk <mikrawczyk@google.com>, Slawomir Rosek <srosek@google.com>, 
	Ryan Neph <ryanneph@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 325E440008
X-Stat-Signature: 1tyo186aj4s87gth91cmiqsbkh3xfaas
X-Rspam-User: 
X-HE-Tag: 1773330140-714217
X-HE-Meta: U2FsdGVkX1/wEhH+chlH9uGuqCs1co/cKJJK2qPKCTb/pUW5Dnm7mQQ95nZNzk8g5b1HW96seDQU6QAHtG8dP29MKVl5x67NcBrWE9C594eINc7fGgIkMXOk5npf4iIhHlUFjA4K9eR2c1SHfOZGPmAMj5otKxWmVek/IVCiaxWljhBzkMtgX/rpXwnfHJRxsgr/ZsI+/0sVFLzHMzRrAVHvH97EZfdnqptABEzAx1b0WBWCgBVwM34ko1INMhg136RTKbSgUbpw+5NzATA23g60gmo3kfhtXrf2iQdAXj9+UCKcP+ed1LcgQJviBWP0XJC7paMVU7jc5LT9nVyXTO5zQyJAlaWFv96OCxUghij+jXSPSGvTtMdCbYs2f3sH9K7YS9A7nLfzdfd/Jo4kFXGWLBvQITFpScmmLx6hins1pUZfnuum2pWvwMYB8YfRBdCSTwJuqUlB5cMt1JQQAVWJ0E7YWwXRVg/e+Sg+aONdd2/qGkPTwsi5H3mAqg/VfKg7n5i2yOyKiIVO0jAtoEe4yZ9wsyQTddezKgxJ4dI0Eer5cdc79Ju2l20HeYmBo6xsmUxVNkb3/fGIPfKBE7pH/anOSNeRo0fZfQysE6pwrWcAx6faG1nX0HkPJkPI3ZOQr0yI31A2CY1XjY9zfML76QSR6K1ddh2LZcZMUqyMFphBrdDMPr4gDiYMqu7w+uqn0KUsWnxsv+j5d/ohovxUOs4YMnIHweDhOAI1LKMl3EZTtO0twX+gi8eOzZeq4XJOkB5oxfQMUQj+vEo7wuCnw8nyoOKCUAzzK8hZSk/3txDTwTtormOaRdIoVO8d4dRlEJRqku1Ea/Ffvr8kaJ2XyxBB57WKIT1nyNfs9bwlCBTZh2SLBCw5xOD5CG8wOhgMcO24YqFiPhpX9ZRT52G5AnjvtRVLNOxn0uysN9zR3sRkiqguX3BBD00sa939CdF1POOf4HjXJDwzSB+
 RQpdEAEm
 RRcFCkMz4ityKQiR8VNF0SpbXlaxfmvuauYx1QfBqTc5K5kVsk0rD1Dds52upsctpUqVb2qvETbpjug4jxOho+ggJka4cwUSOLB1LA4avGs3d6X6jujHhmvIf7e74SyVVpR7UMxnwn9EcIRtrDSmd3hoLIbW3EdsM2Y8jDPAUqZWhCrBWte7TN4jbgX9iGLSbysTMPokbFYoH1oZfr0oDm9SddqfHS3My/2CL/ejf+xVfKOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The prefix should be mm/execmem:
ACK, I'll change it in the next patch set.

> Does it actually happen in some environment or it's a theoretical issue?
Yes - this is reproducible on Android devices running the 6.18 kernel
during the early boot phase, when modules are loaded. The "Out of
memory" error usually hits
modules that request a lot of contiguous memory.
It may be hard to reproduce (like 5 times out of 20 probes) but it occurs.

> It's hard to parse a single huge paragraph.
ACK - I'll reformat the commit msg a bit and add an info about the
reproduction env.

> This is wrong. The caller asked for 'size' and got ALIGN(size, PMD_SIZE)
> instead.
Yeah, you're right=E2=80=94this is inefficient since the remaining memory f=
rom
the allocated block won't be used,
i.e. align_size - size. I'll implement the logic to return this chunk
to the free_area.

Regards

