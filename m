Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8041BCCFA13
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 20:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC58E8E0015; Wed,  5 Nov 2025 15:08:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76878E0002; Wed,  5 Nov 2025 15:08:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B7F8E0015; Wed,  5 Nov 2025 15:08:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2C278E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:08:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65C02160487
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:08:06 +0000 (UTC)
X-FDA: 84077639772.17.7A51265
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9CD2B4000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:08:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g+65eTuw;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762373284; a=rsa-sha256;
	cv=none;
	b=vHAnKLpL/TWAkPNwmFIYoKI+wyFAyz2XpjFFszWtBgFGvIgh4WqLcEoAry+AsAhZDWdA6D
	TruAhdWZRVFZm1YNdFsBloLWQtl7Z/1xZbpR+uzhB6uC8eJHU6jZIZoPsKaZGvRqyvyVGd
	f+uwx4nA3lJ8r5D7bhgkztDHcWVYtSo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g+65eTuw;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762373284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ST1oNBMS4hRThDaChGSDv3RZNfWOxmzM7Tq7eDcBdgs=;
	b=m8iasno964jocq+dSnO7C4dSS7iTcedJxDm46rxHtP1zYnb7+61Zk3GdYRGDhq3gQv862m
	UVp5ljuiWRk4qoGHGEfHRXMwx1asM7tBJHm1/qMG88/rpHXwQPcCcpSSt8+I3ddOB52wxN
	cTRUVw8I/cBuWEYk+QQcQJjCOqSsfPo=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so292162a12.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 12:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762373283; x=1762978083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ST1oNBMS4hRThDaChGSDv3RZNfWOxmzM7Tq7eDcBdgs=;
        b=g+65eTuwuizdIN1RQeOzCCVgcRyWq2z8H+EXLNx4cVv7wo3/safljJlBOEZdUHW9X2
         7p3kBlHbcBbcmeLq/RT5EIY08UiCL1wFrcZbimWdx0pPC+r/4oEs1vpoFfuA4ohrl1As
         4GtVxsXj3uZQ1GIWIMsdp+uoW6k4iadtMwqRT011hipyTPC2gd3vZnvPUWaQQHJT4MNL
         ANSJz8ZPSGzFT8YUBmViRKRiq6AAht9eSuwdcMpNombC38Skh2m8QTiQaf4kR2BwcNwf
         NbDbCtXk3k/yJzUiAqigNvJI+h2Xkqx+IuT4DBW8kY1laDYih2VF94/4+7JKDwOl2zx/
         tXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762373283; x=1762978083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ST1oNBMS4hRThDaChGSDv3RZNfWOxmzM7Tq7eDcBdgs=;
        b=OY1gN/QdZrJniZn9Z1T4x8J5cMe14VnLsKqsrjdM2G2g108jYOw1PaWYL1kAEHdWd3
         eQpLFcJWn79gZ/Uu8Sl1wiE3WTAqDQDxeTA+aFzNA8NOG2PuMdYT63jJT2YvPVW4gqRq
         8uuoE/psOLlnPTDIc3kmNXYxfoMDLr8ewnoCBUlkBTRbC8pw4iz9Fx3rxW3AL+9+t8J/
         7+7lUnm2I4U9RkqSP8q6TO1XHBn4kxiwJGFtc6rjrKLGOZEhWGj1uOzMUdrJPYcbpd8K
         XLUsEQrvgZ4UBETGu1GAZzO1AoVPh91e58TIbhuZrfUn4nFAaUCi8SWYr9ovmUYtO5K/
         V3pw==
X-Forwarded-Encrypted: i=1; AJvYcCXMoeeMcxB5um6gmRRzoqZ58RqnurCPL7SE5t9byvyX8+HTKXhTuoL1d6jLoDxFxJmTsoxCCg5E4A==@kvack.org
X-Gm-Message-State: AOJu0YzksOyWakoYqsdbo7WWOtEPAMn23b9E1aBTVFLNh1/xVFCVXeye
	SmcG8/BXqjv3ET3uzj28sUIv7KJ1JZSVy68j1NNvB7xrXexs7VuqkIGQuHmznnZ9oyCSNSSAlaK
	XF8LDW9cPjiN0RuIhob/lDhyL8RR/9ZGEERp7f/OHZQ==
X-Gm-Gg: ASbGncvNlfDbQJdRTPi5XR+NQiLVvOiafoC7EpEWCmj90pbXM5ZwgBfu32WIXvLly8e
	tg3X1uZg3NAkbKvRExnSE9ipPLku/mHNC0gt/2Wrf22a684jKblq4tI9wR6exLF/QnxsHdai4ky
	A+4cgwDBjNR3M7rWF4obd3HJM8TQ8Q4pQb66pyNL4WUbVf9O1u/JRxp5kFsnfYr31FcCcVuOiWO
	o2rT3ObTfjYa72w+e75lYN+wup0OBYCFDzcQSFA1P00sbEXkoaCZIwvOA==
X-Google-Smtp-Source: AGHT+IFO1PbWILyZhkmdzoG1Cq20TQMLfVmCXio+kB7daV6YdfwSyF0hqOCX+kysiN5VcXgBtF/rgyt0JUY9JXLmzhE=
X-Received: by 2002:a05:6402:234f:b0:639:d9f4:165e with SMTP id
 4fb4d7f45d1cf-64105b7064dmr3535609a12.29.1762373282826; Wed, 05 Nov 2025
 12:08:02 -0800 (PST)
MIME-Version: 1.0
References: <20251105102022.18798-1-pratyush@kernel.org>
In-Reply-To: <20251105102022.18798-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 5 Nov 2025 15:07:25 -0500
X-Gm-Features: AWmQ_bn21g6lzNnlKmCfnUIMRgz-n6pxjgW9XHZT8JIFo9Q6t3fWBtoZk10pspU
Message-ID: <CA+CK2bBGvaZ4-mjL2MeCP9650z7XOoB3dWr+1BMKfoMbAUK02Q@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add myself as a reviewer for KHO
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9CD2B4000A
X-Stat-Signature: tmwrtnoqsi4hh53jfcz8bisc8jgyq1qz
X-Rspam-User: 
X-HE-Tag: 1762373284-89361
X-HE-Meta: U2FsdGVkX1+wRQK91AkiSCuH+PEgB1YIeUTz3ktqKgZWwb0LKeetGd1fNQm3JbLh/Hmq5vTAEHgDf+KfZx5+Euzgp4K085w12hmc6zKuycuFY4oJFZu3e9QDhDxVg9sshyeuoHIB9ywCTT/HTvtM8bBjxeyi83t4vVpMVMPa2r9QXMtADDiGWlvzPnH/qV7CTEBcfbFYI5qtY1FtcwjEP2b/z8tHKnJjcC4lXSRG+/tXg1pEPY0sAXx9Zl2rv2lctLZ7HIR+EDGVZJiH4jsHIgdzXiOv5KjgH49rSkzP58pogTI//swH0T/OmjoS8OfEI1KdDw+OfRo/YR72ismRZfZAYqYL6aeYbmLGAU1gaIBQCfBm5aUk0mDWbJaJxiSxnyD5hKhZxmsrSBSF5ImGbQH21tDifBvxQu/t+BfOcTTDY3EelQvc4H83JCh6sX95N9HasMa/RlXWDXPOgy6H3wRjTmqwOONtu1gWx7H2/9pcjU+Q2uJztW35Y9gWcGEuAUwKVWa3sbZHCb3bLJRuqWeIlljsVpjnxC+usnWGjT2tGBgBqYCk2lvbaXVpyrLZow8Nx+biNWXmOHq8ATpsKLPOPenVxWcEcmfhbRTJum+fz6gQt/c1JPa3qzDWrHhZgUXOi8lwuhfTRuSnpOLmFCeprhqxpx2plM3N82ClCAzC6g2sk1DRORehJBDviXftOPlJR7bdaawF90REbbfjHqe6QjUpGMFymXbmmHD2wavytliuZH/gPkcQaJXhR0fM6MH6aK1zmcH60vI/sLvOxoI4NE+pv79aBLvhA9beHMBTFMKNPch0/AIdF/OT1oJNsqiDgQLAx6CEQLJz5Aa4ElMP2A6HXsh9kFwfZjkVyF7BdVngq3ZbcFf6jcLV36KgdbhPz9NlHyQsazr+xUR2gQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

On Wed, Nov 5, 2025 at 5:20=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> I have been reviewing most patches for KHO already, and it is easier to
> spot them if I am directly in Cc.
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8ee7cb5fe838f..3c85bb0e381fc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13789,6 +13789,7 @@ KEXEC HANDOVER (KHO)
>  M:     Alexander Graf <graf@amazon.com>
>  M:     Mike Rapoport <rppt@kernel.org>
>  M:     Pasha Tatashin <pasha.tatashin@soleen.com>
> +R:     Pratyush Yadav <pratyush@kernel.org>
>  L:     kexec@lists.infradead.org
>  L:     linux-mm@kvack.org
>  S:     Maintained
>
> base-commit: d25eefc46daf21bd1ebbc699f0ffd7fe11d92296
> --
> 2.47.3
>

