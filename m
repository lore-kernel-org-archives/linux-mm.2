Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E5EF53D8C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6BB6B035F; Mon, 16 Mar 2026 15:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E436B0360; Mon, 16 Mar 2026 15:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D216B0361; Mon, 16 Mar 2026 15:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 341986B035F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:17:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D29BE1A0461
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:17:03 +0000 (UTC)
X-FDA: 84552883926.25.82CEEBF
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id D93FC140010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:17:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CSvYakm9;
	spf=pass (imf26.hostedemail.com: domain of groeck7@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688622;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Hk2XaBHC8Qa6dgUkCoPcN4E9YBKjMdtHqI5bOd6Xjw=;
	b=8rHf/tvq9X3R60qTrmv7N14fA2zEL3NEUZsZcIy6plVL8WhDTnkSU/eRBh6l+FFTdjFacG
	aBUMLvKb/nfwgnVqD34N0SgCcHwCY0H1lx2tLCx6vVhKsL3xz65rKLOLmeim2AmDylBD6m
	LaBaOobj8Xql0UXS9wmX1ihrhDqExf8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CSvYakm9;
	spf=pass (imf26.hostedemail.com: domain of groeck7@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688622; a=rsa-sha256;
	cv=none;
	b=JlfrI+dvuMn+YSHJQPMbd9Sziq0oPW4nXi4PJQXPXHdNptWEUmgIFKy7lwVuaqDxvI0xVz
	SZC0JAIHbCMEh8jVZnfjPaseW7CItPu+1HOCWrQyDKkx6h3o9f3D8zPDCSEDRX4o7K8x7Q
	7M1CN27tUSQdJ6WAzfbR/F2/FMqWwIc=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1279eced0b9so6626400c88.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773688620; x=1774293420; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Hk2XaBHC8Qa6dgUkCoPcN4E9YBKjMdtHqI5bOd6Xjw=;
        b=CSvYakm9boumyQrthjla9PabdNGv3sDDnMMp6DS/26cFhIFMHKf7uoOvCp0RMOaAYF
         +4pdgPnUnlUVkZIx0tpbj+824PsyTtNN6TgDvdMC9D7Ny7m/TSRtThG0j6TDWPFteJjP
         lP8bGxswidC0QpW9PwUh7JLHw090IDRIhnPfLqrrCjMd0GO0FwF0cqX4KY1M6gfc2B7Z
         AL5LJa1zQn0hFT7ZbYlSkc8UKwr8dzk3MU/JIbDSOcZAn3izstkQSsgrc/nFk0lmRS7q
         PlTo15s9tIrNKKYWlJLo9OnU73vPXfftbcKr9Mc0wgzx0aDOXS8Mv2fGfGcHVMcQ7k7B
         62EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773688620; x=1774293420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7Hk2XaBHC8Qa6dgUkCoPcN4E9YBKjMdtHqI5bOd6Xjw=;
        b=ZYWf+9tReEwUzWs0w+/Izht9B0rImBU0zHXSKcee7hJBGX3BU8UFLx/ypG0oP6DyO+
         sUeX7pmHO96obmdJjNAGkqtytLSYTXn4RD3m/b0NZwMFwejYb1Cp/lkC8YiFknI+1T4O
         R04U2d6K8PtytQSVmDtZgWUzSifIvWQCjyu/GgDnWWuSO1l31OyE3iYVN65GHeWITfKh
         LWCNQ4wfdEZ5w+M4ZWK+XWr85zig19aprKCrxhybQxu9mnuhUoUKue5OxPYOQ+XNe94a
         NnrBfbbzu7y/8FNhyFfq6GrK0/qZNMZGfulkWGyI2B93uncI86OP68b/6QO6R33MIBTJ
         QgZg==
X-Forwarded-Encrypted: i=1; AJvYcCXPCkyVadn6GJFV8OTYI2s0W/FdVZazzEOMst4IS30emo9ak1sjrOanlSecClWx9ik4WSxTO3LbFQ==@kvack.org
X-Gm-Message-State: AOJu0YyfYKOYlhb6qq07FDEkOh1bQDHcUMoT4BFlxVpJqxNbZDIkYyO0
	uQptPNoy9Eism1omQ4rfjDb+HGQFUcHfYy5LkJHqxzGuevoPuMq0Xq2p
X-Gm-Gg: ATEYQzw5aPVtu1xRs9x2HN7cDDgbBbpQDCKia0l/Zs7Sk1MSAHJ7MQ4k3Qqu07+1+7J
	qlfvht401Nnc4w0sKvuSnmqchSfUathjYXFKT1oDryhblaOYuiTNBV7QG8yPHC3uVBS5NF8lstQ
	4tbc6YB0c9Om6ZlotLN2AxmiRRz2Zo9am+jtgKXcWI82is4kzQl29pudMzlSrAgG2I0PoJX7kgb
	+vqoZtnU6ywGXYYmH19fdjjOmNghKZLdAA6NZBOn4p8PbU72IbpmMTRzAlFaythS61CcosEpMwl
	vUz4cxnjamgn8vGvUyOm/bjuEH9ut/suUYk9sT1FEzGjyj5VQqP3TaPiXyqf6YxJ3X6YoLa/qh1
	y9124fVVfwfrJwbwgmfnIf97aVQbsgH6/E4FLus/fF30QfeN/iuLBx6k6RjwDbZdZ6u7UOE/Py4
	H9x75VuQFnmHDoccabLcNO0h6iSU55oA+oggOJ
X-Received: by 2002:a05:7022:925:b0:128:bbad:9a52 with SMTP id a92af1059eb24-128f3e52ca3mr5874419c88.39.1773688620362;
        Mon, 16 Mar 2026 12:17:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128f62837ccsm17035721c88.3.2026.03.16.12.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 12:16:59 -0700 (PDT)
Date: Mon, 16 Mar 2026 12:16:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Kees Cook <keescook@chromium.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
	Justin Stitt <justinstitt@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2] exec: Add KUnit test for bprm_stack_limits()
Message-ID: <a3e9b1c2-40c1-45df-9fa2-14ee6a7b3fe2@roeck-us.net>
References: <20240520021337.work.198-kees@kernel.org>
 <20240520021615.741800-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520021615.741800-1-keescook@chromium.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D93FC140010
X-Rspamd-Server: rspam08
X-Stat-Signature: f4u1b1hqf9ttmqxtc77nzopctc7mwtpy
X-HE-Tag: 1773688621-172894
X-HE-Meta: U2FsdGVkX1/cR7AOe7LDT92HjxFdJA8Oe6X6WKWNEZ7RzaWFftOywpTAg9MzawW4jN7wHv9pUym3SsC2WysrytZ5I9+ZE1LIri3PKUjyUdURL32yAlrZrHwBoRLLRBOBt0WB21m5zyEQlilR1xaUXWsU3fmphF8QinvGGSZYMxN+EDCLGQu99R0IYU3My8ZxhLV5KGtEPd8lvzW8s4imEqOm4AOu3QProvYO0pHx9LNh9miahzb97QMgzPFUTwd5IcGTc5jLKCgVZi2IkHQbWd2spKyWt+vt5Bxs3LIpXS84pUYWQrrAmGpIflw8dzxjzO7wGckMdw6zO5JJV2MMlfjR0GBdPbYYW02aYp1VUG9Jra4aYxxP9/i775Dg8sSEVWc5D4u1qP+sQ/hZuWo1DfoNylHTuGQ21QTXa8E8jXtWpihHQ9nIFPBj6uxLXF1wd9+aOZlBBqL7tFGFlupoDEZNbNLark+5BcB+KDpMyy92RtSLcUeCqxzdu1XDZhxme81Nqi29EDXidOTlvWne04oje/0JO6v+Zv2ExRmFDrMBQMDbjiYczg6LMqCaAP3W3B+SDhJqkVes8ZPb6v2amR9UQfEJwIWeWclVZcfB2GaDrliyhRlGX/P1hziFKk8t9uvgIsKu5h2F31JOFWXkzcQRS7x0mBXNRsebRogvm2ccMQfFT3Gmn8hS+xwuPdb/uY1FxyiLcHT6hM62Y/7mJTZUtIF9AMU2ibmvw9Mw0PkSDhheXuOWMHDo5aEDxF/kOQOy+s+CZUGP/8yBlmahwUzidKEF5DWsaUjqCb0/P5EnohtG8Pyiw4kyc+eUzT39YS7KiZCqUSvsWs580dazWdHNvWrXnsTHWdx5FL278hRp8IZWw2oCPa13EtMRarMnRVuS5ogbPUZcjr1YwpXydHSKp92GpCFq4OZlFEHYrCdvqt/rEmyJ+3t5LPwq1hfY51b229XqRvDKO6JtOV9
 CA38Ohuv
 CRFlzNFxzleyjWl0ExVCJB6XeSUODFQ2/WwldvmMosydl2B8cpvlFS4Y3/zSnGwO05JobVVtle2ln/0Hdt61RSNCjY5WERqg4cUlv6CgP4Zg3e4oy5LPStk9GG3ylr3TbYFmSbmGvc147TVobZ6YBFguckav/Ik+x8utsENxzYUGj8wy/S8n5riaXMYjzEgK+eZ8EiIEuOaIuZD0vJNQ2QVRwbYZiy0jGJ655pK0RzDvmKmKEGqKhJ+MHqwTEakCiEuVaFoMvqG16PIEc3+nBqF3DyN7MG1QfZnXS+489TFaBDb9IZP4HftOSwGBBrjsTwTyVw4z4KzADPsd38tRX10R45Wr0pESbeIEhsINEo4GMflNSWLuFYI+YEaxaF+B49Z0paUGSS3bxUnKUGg6aT1qx/iuRBLl67hp0dX+3mhAN1MbK9hKE6Z8JgbIGKjJopJ0va8m1Fqb94CD68nUzKzcCg/UI075jdpO1pvMOru6CC8I2TuWXdVb957W+L/18lp0ToqZ0ASKWcra1OTWbA9812TkYFub0oRquV9pz5gKNcf8jnyNLg/RJBV6CvblDCNoSy+prLSRUkUL0W7THCr5m18fyfKkAGcG/RN+ANFpXeGzfHgJ7k+n34Ntfh4Lj+bsdpmddbB3ogiX2Q2nhuBALOsdepU+e97KxPVJyWHBdoiTF/Rq1kWGh7w8k3D1yOPT5Bim22z0AAxUJcbRXdbmtMwKvZ2gI5YDQ6kxYfmb8QhNrNa4fqXB50oIUvShRGUeTDbqEuT/j7YnCJsyfHq/nFLXilqdvhD/QfnJd68PFbvguCRpHVKAbtxiiYuCrZRjLzb7HDWhFiWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, May 19, 2024 at 07:16:11PM -0700, Kees Cook wrote:
> Since bprm_stack_limits() operates with very limited side-effects, add
> it as the first exec.c KUnit test. Add to Kconfig and adjust MAINTAINERS
> file to include it.
> 
> Tested on 64-bit UML:
> $ tools/testing/kunit/kunit.py run exec
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Justin Stitt <justinstitt@google.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
...
> +++ b/fs/exec.c
...
> +	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
> +	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 *  + sizeof(void *)),
                                                                   ^^^^^^

Google's experimental AI review agent tagged the above change as syntactically wrong.
How does this even compile ?

Thanks,
Guenter

