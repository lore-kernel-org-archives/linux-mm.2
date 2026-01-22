Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20847D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ADC26B0302; Thu, 22 Jan 2026 13:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744CB6B0304; Thu, 22 Jan 2026 13:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D466B0305; Thu, 22 Jan 2026 13:29:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 503236B0302
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:29:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16E09C1C8E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:29:30 +0000 (UTC)
X-FDA: 84360437700.17.6F2D009
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id E527C180009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:29:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZX2VllEv;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhM6KusIxk5pLuv1MBKQ22c+nR479iQtC12L+zVHy4k=;
	b=rBgTfv+wy7zOpAMvUWHW4Kwswn4vKfXE9roQ9+N3S6X3uN7HSJo5O1mwohBRJCtak6Gne/
	hH3x5tonOW9UAKdAK3UnY2vWTI9FJAuSzuuOx40gXMnjVAtC6jFBrLANJPldTHQMMUww5g
	XLMiFwartf/4rR0xdrBttRDh9E5yeEU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZX2VllEv;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769106568; a=rsa-sha256;
	cv=pass;
	b=LSrBhdNWPc841qPeZNlWmJazr2Z1u4AHv5iSvH70iQTQXoxWeGzZBgObo1O31Uu4nDGI9I
	pWDxGUAQqHD17UOtiUa54JgFyTpVGRGkkPkSXcgw6MHpdhdM/oSmIN6zqNkMzDpw6okMu2
	lMTwfE5kQlJ/b9R8+HFnYqOFqNjsM24=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso2224224a12.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:29:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769106566; cv=none;
        d=google.com; s=arc-20240605;
        b=caMmHl2vgFBcDX94kaNA35c0kPahPQCL8pp4KRH3ZQ2Cq3jXvVVbBGFA78G3CSZPo2
         fDeoFrrCihVD0LH2D+UPdUHHFZuhgStu3I4rYeD7SUUL0T0C+9BqCDfX7798jU6Mt10L
         UC6Oh28KgYajYBW1mGBmyOE8slntiEndoc4m6ZoHTTGJWt7ihzDVnuszxnXFYB6gPLau
         PelrhGyhM9eNJSZ6lHIKVBaf0dGEglkvRq5m8NUgPTLzQK29bYVqwYntHw5O9OZY6HKJ
         dWMxZGupBgSmPnS+Td3ZIpw7V6P3OoMm353IixiyKZ9ffecvNNgSXzEgx6xfp+rsv00e
         8ZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hhM6KusIxk5pLuv1MBKQ22c+nR479iQtC12L+zVHy4k=;
        fh=TZXNRA7199IIz9RQyhcfSxCiz76+u+G1s25r8A67Doc=;
        b=B8q+Fhc5UMzzlDnnj8zOAFnpDzoedgHWn1JurQf62uFOaBzXk8Z9rjsQEx+Fu24J4Z
         Dr3trJKZEIts6rfaeyzu9valKURCZSKerjWC/4MNREzuVACCLj43kqikWowb9LOusZfA
         JJ/KmUjmA7EwYxl0z9E/zE2OM7vcVog0DSb/y9hvspc+p3Ex+rHAZcSM2nBfLtD1rrjQ
         Z1+yBjLmXawh/EfkbUc/V+4A3X4rWgSVT+q4NqsVqrgXJsIpTCwTAEasicFOc2nnxhUY
         SQkO+lVmTrobiOqa+21Pv8uBqyHS9X1E/TlJdofroHxfsx4hwAyKsW9F4jvGCgHuIgAQ
         SUQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769106566; x=1769711366; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhM6KusIxk5pLuv1MBKQ22c+nR479iQtC12L+zVHy4k=;
        b=ZX2VllEvjCmXLE9oTuodiw/kTE+1znF3T5wyZpnB8Nl8c/IDmA3F9yHslobbx3vTdQ
         bWwfzebjixW3kNXXhYToev83jy+COaOGMdhPKZD16siMKcSacywamlnRIYRVTU2XKZXp
         JMqbS1hZP4cylpRVMYQTfLjoPC5KMy7YSO+jjyFv3e2y/oRYropOqj7BW5EhoUJ7OgAu
         9ut/Ko5HNA5CsdbwbMwyAFtiLq38hUQn/v5DwmJtSUfiO7kZLIIUfDXe/GQkPpuStAfx
         uJUrPJMGtJ9hLrxJ+/xa7d6TE9yuwm6O/8xG4+bJjPs/NALEIEL8BQDdP9dIw9Emy+DA
         Sv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769106566; x=1769711366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hhM6KusIxk5pLuv1MBKQ22c+nR479iQtC12L+zVHy4k=;
        b=Faw8jobw5wjySWFHBd6uQF1tlL2O2TPSIViobRRcCt4KQXs4KuzKftZp38Co3bSahM
         0BSJBKugEmq0YBsnnMUqRV62OifUN+T0aIDOVw78K4XKDZpa145PEYo/X/5CYPezcDyq
         vYsS+dZ+np7a6zFtYesefsEtsV5+BrHOaFFP8dtek+Fh2dcE0JNHTCV5uRV+WM737C0Z
         t5Jf5L85t4PeIHbZc/lQF9hMSvBEB9+To2kt5ZI1EtI8IKLhRiJQO9TDzozZT9Q7z7vp
         9CfZghVcVej1GdYCfO/0ktSOsHn3iPsQiYAfFeGOgU31IwshrNsUqNpEDvaEZ1Ejrh+U
         q7UA==
X-Forwarded-Encrypted: i=1; AJvYcCUdVFDuXccjg52KO5BszRWvsFyPM1v6B0bOvk8yIsxZgmF2vwKgUcmH9h7W8mrPHd4csorguTRULg==@kvack.org
X-Gm-Message-State: AOJu0Yy0sDBcYj0RjdaNsLOS5LU6rkPVGtUis951a9hHTmsD/Yu02kK0
	gdFsNg4g60i2Ktt3/XuBwSWTxh+wGiwo2PZtkK8jJGdR3Mbdptg8HUhytE4zh4OxGKbiMkNArrj
	xxwPEm6mmoFdbEB/ns9eSRUAV4dm3rLWRMePDdOy6MQ==
X-Gm-Gg: AZuq6aIBXcDQIgiajaJ+RdRZum2bMAUsIky3Ee37qCUSARplWn2gJU1YetO64w/PvDE
	SWS1cx3p3P7arpqaodo5zsikJ8HWP6H1IQoLuJ1itZ+x47hqKxHwpxhHaGOiPgttsY/BeGPcbBn
	d+B6T9qYW74SFux96hdHM53B4+txjdO2XRKG+32FV7Qv7S6Cmu1r0sC/ToS1gJRljt0g4VsyikD
	gPD3Q7RpsEk7uE6M0zimVnYjeOvjmFi/O5h1y4otyB985L1/1JzgD6WaVDy4JJ14mwRDPHSjw9D
	kyP+Fusp3e3cOC02Ynt+zyOWYjmAt0ysG7Rj/uPFb+calLg=
X-Received: by 2002:a05:6402:268d:b0:658:31e0:4ab5 with SMTP id
 4fb4d7f45d1cf-658487626dcmr360840a12.11.1769106566431; Thu, 22 Jan 2026
 10:29:26 -0800 (PST)
MIME-Version: 1.0
References: <20260105165839.285270-1-rppt@kernel.org> <20260105165839.285270-3-rppt@kernel.org>
In-Reply-To: <20260105165839.285270-3-rppt@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:28:50 -0500
X-Gm-Features: AZwV_QiNfRhOr3LvFRxRYZiugzOXBGGS10OWpm02Kx5rrzXcYiqpJE34NwK_FC8
Message-ID: <CA+CK2bAuY0rKenkEbaAfnwYd8q=ER=U38TGga_8CkqZze=9Yjg@mail.gmail.com>
Subject: Re: [PATCH 2/6] kho/abi: memfd: make generated documentation more coherent
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Jason Miu <jasonmiu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cdebowic3pckszpinaq4nij3tks6fkdk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E527C180009
X-HE-Tag: 1769106567-872804
X-HE-Meta: U2FsdGVkX19JPXUCd5CfX05yUCJOddpmYpkbE3goGoFa8gz7xRd7m/K9JpWBsLXJfMnymXZlVv8DwxwWJZ9TW8aR7/qL1TXjR9caeMUSGmPBnRvEk+bblxFjxyTRKfR2gldhHeuMjjGzCME1Hze6DrdQ0n89mQnookR238ex1m4oZP6VBN41yCAdY1rArcNmdO/NxQ0ozzLbJT3a35y1RegaRpVePo43i9pd4ObKK+BYvbkE6lYUJBMlUmAC+MK5HbJc8olIiYCipzVk3uPlD2OOfUQwZCd/PyY6XbUc9mtomCd2uMNHQNpdNHuCL0asilsJAg9vbJVVMd8C5rz8lf0ipGQaWVcc1H1bKxaF3Mn2j6OXmv3Buc8G6THh5G5auyV2wgdE9PiEZWd6KEyLc7R9b8GlXdgtxDU1IaD1ayZpY3CaZR/23zJL5otE6MCd3Wli4oRUZbdyRON/q5ApIONhbshXko0uzgts8hziv+uAHOZr+B7JBreOkdEbxYBc4BMcKw7CQzjKyUWrJyB8AGx7/gtxN76xv6hzAEFlRDhvGNASObkmyYOL17QmgrBmvTIfTeiAl/Ri6u//hZq0j1nKC3fVCgcH4dOmEit2VmeFG5eiM+xnavhbF98kX2lvEL4XF3ZplUE8h4MM94lYxE0snwn+N6t1wiYysxd4t4NJTMymkqRyYDi1GVaYWR1vHdE/mRXTS2AdliWgYzaQG4yceJNlgdHmNzHbw3UwHrd+UvjEudtD8Bk3BX4Ur2Q/dz39qxtRQDOT9xPBdpvteGcTAP43w9cnp+SKZMRLu4mOgAbMK0p6xhg7zYlljhbSEou9mpdSTLqRorIGnPUawRs65u4y96LxKjdUT1zdV67js3IEZ65F39Bfk0OlwWNfE/R0Ao5zfyNOhsM2qs9kOOcunIOZ9Rbwv0I+gfe32eD23P4q6nANhWqPkO/+YsVYcvLxeEHr2Lh+CKYRHxs
 Y3toOQlX
 AGPfsXNgimBZYcx0ccOzfjb83PmF/7Kotkyr075Qm1CSCC2ureA7tUBx0Mk6O2rIaTPT6fV2gWHzatn6fmjrNY2E6ekCNIDZ95SrXD4E8j0hcbMDMZbOfbXAPnwYv6DjLhcuQAe4ZTBhbV56KcZ0H9Aue8AYFAQe9SPD1s8rhei+i2vKQ1BqisiKMxD/s6X6j4SOvXU2HoIlHGeJR/2RJTOB5N0KojGn+N8+LjryQTXP2JOikpgdorocItSNITDVb+pH1G4Ghk8sO50v455Tw8GrUrlMhxoXMmmrx0QmN4/10gkZTBUhZK9W1qyGVJmYjy4XOWepnYF6DjqLl/F459BpZBnJABV84Jms9OEopyx+x8+z68wpJneeEIz5vhhaax4MywsunG1lKhPbEF60K18zlvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 11:58=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> memfd preservation ABI description starts with "This header defines"
> which is fine in the header but reads weird in the generated html
> documentation.
>
> Update it to make the generated documentation coherent.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/kho/abi/memfd.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.=
h
> index da7d063474a1..c211c31334a3 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -17,8 +17,8 @@
>  /**
>   * DOC: memfd Live Update ABI
>   *
> - * This header defines the ABI for preserving the state of a memfd acros=
s a
> - * kexec reboot using the LUO.
> + * memfd uses the ABI defined below for preserving its state across a ke=
xec
> + * reboot using the LUO.
>   *
>   * The state is serialized into a packed structure `struct memfd_luo_ser=
`
>   * which is handed over to the next kernel via the KHO mechanism.
> --
> 2.51.0
>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

