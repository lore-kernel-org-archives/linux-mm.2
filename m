Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A182FCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 22:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D048D8E0002; Tue,  2 Sep 2025 18:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC288E0001; Tue,  2 Sep 2025 18:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1A98E0002; Tue,  2 Sep 2025 18:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA3B58E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:38:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DFF7119CF1
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:38:02 +0000 (UTC)
X-FDA: 83845774404.30.B9EED3A
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4C0911A0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:38:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gjrNvu7S;
	spf=pass (imf19.hostedemail.com: domain of jstultz@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=jstultz@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756852680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2Z2q0BkPqIY+E04bVXl2gU0zLZQjMNqg1qcdhYoTFM=;
	b=6df95Cz7o23k5eTWwRq1ZqGXP07ePusxFFzh5saPCXXiqyCvRpcVUOfRdpKRFaCYYSLK60
	WmmxO00oMVUpwv1k4bRjhaLuwaXZ0GK3yRDDQk3lvWAkoWC1XXVgkmgM9jjHKKZi11+t8f
	tHH/yXBEp/+jIpoz+eAPXpBAavEsrAc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gjrNvu7S;
	spf=pass (imf19.hostedemail.com: domain of jstultz@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=jstultz@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756852680; a=rsa-sha256;
	cv=none;
	b=aP/BGMu0d4WLcNWYUbHqoAZabCd72fR/EUFezKwwdsQ/eiWsydkrPDE7WmIO7/FZOtGQJU
	5ygwzKgiHL+7OgKowhmT7issbvVdRsKYNyhQKU/YTaXV3zHFZDPk/k4JMrAU1wz+91gNFZ
	jFuTJSeMM7K2hMz63lDJJhVUcbgCe38=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5607c2f1598so2253038e87.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 15:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756852678; x=1757457478; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2Z2q0BkPqIY+E04bVXl2gU0zLZQjMNqg1qcdhYoTFM=;
        b=gjrNvu7St+nHRFmJh0QsQNiTh6274b/Tn/Ta1HHX2BZ2FJh+MkeHRBFNe0G2K6aurK
         gw+BznzcSJqUSkMB9X72bQr0G67HV1pbAgYKr464B+IMWVAsJ3dwfbzPepaJXgeruMJT
         h08Voljy5QmcT2R9LGlpag2HIArc6PbtjMkUU3vKLIcoFobftq5UwuODM9HjPrKHwwjF
         CKS/CjPBgPu/FKY4KsR4T0NEFjzXDajE4ChI9p5YkF+a+zx6i0UJswXbU96W3gWaIs80
         VpegMpJ9bgGi2BlkjvykHK+NcZzOUBVfeQT6PAWlKU9dixfxrSteCxtEJa+jL1YP3Xl4
         MCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756852678; x=1757457478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C2Z2q0BkPqIY+E04bVXl2gU0zLZQjMNqg1qcdhYoTFM=;
        b=F7pysWVFLLhhcg/x6Bg6xTJbXJ6jZHGBf1aBXzN4yACu7V4QRzKeYJoXn4XwJiHX2p
         szRzYnb7VQZd2e7g8dc41NYsxN8FcrzSID3TEYhNPNH0BkaSIIaGx+e97GGGGx83aqiM
         3v9NLh/jdpcusR7gQpP7vCdiXSBeiste6Gyyxtslo2WT648XJA2HvEEqaHV9RtGla6lr
         yj9nJ4nLlGScGnRGxbqdaxi8tyd7NiFakUDnMQO6dSdm1HZsib18sos2KaDUxwt1/5JB
         2EZp1zkeahuCqDURO+JP9vY4ZPoYWcKfq61UgMNPuMMLZ9uh/mUk/+hLUiwcwcgdhJ8j
         8euQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNFFsBmtQe2trfumG31XRG2SU1uFKOwlGIm86MJlFfPg6TJY8G2NYTYf5Kr6Yn/9VkeEGC2LlF6Q==@kvack.org
X-Gm-Message-State: AOJu0Yxq55bV5wKbI9ou0T17reETpqVYbj5ZGn3wQkhUY0JqCCTPE6jm
	BpaOhWPF90PsBFQn7YOOJDxBmuF/OZiKh2WJzpnuHJ0mK28Nw1Qm5m0b4Sx7RqMKLVbTi48HM9b
	H9HfdVOEWlbH8J0kxL5VQqGZfqFvkTeGYXjixjuw=
X-Gm-Gg: ASbGncs3HtBfo6CCjsrCbRDrDDgEK2KrqaA1+9tkA5X8/F41SMyITcPzrcuD1dwEQ5b
	XOppvXcwwYHeNUpsOhIvdI+UIw/wwpFL495igxdWG8Jmp2fQtf5FuuNO2MAZyqdSEWbvn3xrp+G
	e/DVDkuvwXa8JqKM0V6Qg75Y5N940/U3VOgEBTf6hNbigRwLaGldHazaXtY+bfvMK8QEjafatMl
	uJT0IefCmLP9bv3oJ49zxUqJgmlgUFVG7XDfviuzHxNAVccEJ8tpR4Ib7vuVJI/
X-Google-Smtp-Source: AGHT+IGmWy6Aq1ZCfTZaoiG4mkrbhZY4MfRXR19EYAWZXvoUsJvrpBj01w+uPYMLT8d4w27jw93YIe/anSgqxv5w//I=
X-Received: by 2002:a05:6512:32cb:b0:55f:3bca:b161 with SMTP id
 2adb3069b0e04-55f708db526mr4266129e87.27.1756852678372; Tue, 02 Sep 2025
 15:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250902154630.4032984-1-thierry.reding@gmail.com> <20250902154630.4032984-5-thierry.reding@gmail.com>
In-Reply-To: <20250902154630.4032984-5-thierry.reding@gmail.com>
From: John Stultz <jstultz@google.com>
Date: Tue, 2 Sep 2025 15:37:45 -0700
X-Gm-Features: Ac12FXwG3iNj8EaL9OuUHyuMyacZ5I_i_Y3lylzCsdPDiddwbaDN3qJymljUZSU
Message-ID: <CANDhNCoM4RFX-QccF7xT=+-tduGj9OZ_8SgrTVyRucMwyVc73Q@mail.gmail.com>
Subject: Re: [PATCH 4/9] dma-buf: heaps: Add debugfs support
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C0911A0009
X-Stat-Signature: t3z1ycyhm61qagqfsk18iu6qbd4zgw41
X-Rspam-User: 
X-HE-Tag: 1756852680-264773
X-HE-Meta: U2FsdGVkX1+LFU5yl4phCMYp53FCg8oqSjMKy5PKceamTUMeHdzcOclBxxCAfRI2piaiHgk6vR0Ww6zrz6oIJkPcRqYYv0BkHX2xRYdXoxId5Pk4VgZc6BG4Wk5YYhG/S0zzPdudh+UJ9L1xNsA5f4sYTJ/PWbN0BTJ1Ohny9LsHZd731da6yUTN+VN1MY/JCtv1foZ3h43Q+0Iy8lv1/cg/wUDOuQJv0B6f1+Bxf2Zu3nyDG2Kn6gXD/kUfIqx37Ej/xd3dbo5SCH+jNGf+ENwZnwkYtJryzxcJbKKgyAufhTYT4vSHyFPMy0aMwbOq1a7p1OPJtCUsqUBpz7gLGe3mDFKr0c8lxZcCvA5E4KWA5/JWG86ToJ69ImViJvpj3CALnJsLnRuJMS7kkeXpRFBIDY8xcmj4PJer3HqNCO/+DyYgwTW7+vx6iCu36baa/PjPvwp/oxjoGue/M4FCTl8/nAcV7NV0GW7LiEfHIX+KhU4k+YkvAZ/PTBlxRvGLDL5joq6bOu0adMM/gM/rAC+aF7IEqTZQ4Uid5X83EHBOQ5ivOG4+MJWHb4P7LT+jxWP8UUYw7hoQ4Y1OpGFNDa5jWNS8KiDL94aPQOttAH7LkGncVLhj3ZwuZ/qrRF61DbMMgGKPE7fJty3BokS3mSMIIkgngEsgnzl32bfJ8dRrcmKYqQbMasc3Pmo63sSOSEpE4IftGJZK3BqyJ3bAkHuvzp4FNnpkRmhg98PVXm+oxIw/UdClkBEfCIumBS2VZVAaJTJJRhWPAWNv+3/ike+L/3vPiixa9N4fcAqKy+CsRt1KBu69ruBzfJZWzOUojiexv6KHyhkOMwfjc7WF3zFaqpmBYkBkrvCXBfOk9vwe/UUuQbFC1+LH+QFTjjpFyqCAPMlgPrWQi4MXevrwVwIC5inbLyk4PLy2/0lsrwQyCfhUBPbEDh45oyVcG7AA85ycH9xTSls2ewk/Ilw
 A6dQa88s
 BRKtwm40cz01oVCppKXySbQ11C2Z0G34OxCI1N3x5Pk8V5Q/c7JJABvmGSl4GhqYFytBiXbcXJVdYPxtzGZIVvj7xZ6roKoreCdrqBYtjl/EaQZeFl072htL7XY0yB96dIOnUc6UKl8KtlC9uV4WcJIpybzrHfZnFcDPddbsQCM0tGvTede4Nz39ZuSvoM9WMw1ZUnUv5L6nhUzQPmhk7jLAu8PkdUhzWVAHfEH6OgWwGLFW2agKdkI/Uxf3au+ZmLR6aXCqSJBm11tpcBAl7n8brg0qT66HLtsOnVRNk8xJvviuA8kfRM9RtGNJjq6Qe6zNC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.reding@gmail=
.com> wrote:
>
> From: Thierry Reding <treding@nvidia.com>
>
> Add a callback to struct dma_heap_ops that heap providers can implement
> to show information about the state of the heap in debugfs. A top-level
> directory named "dma_heap" is created in debugfs and individual files
> will be named after the heaps.
>

I know its debugfs, but this feels a little loosey-goosey as an uAPI.
Is there any expected format for the show function?

What would other dmabuf heaps ideally export via this interface?

Is there some consistent dma_heap-ish concept for it to justify it
being under a dma_heap directory, and not just an independent debugfs
file for the driver implementing the dmabuf heap?

thanks
-john

