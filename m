Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0910EE9B248
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3A76B0089; Tue, 24 Feb 2026 04:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A15E6B008A; Tue, 24 Feb 2026 04:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178DF6B008C; Tue, 24 Feb 2026 04:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 044626B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:59:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B136F1B69E9
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:59:08 +0000 (UTC)
X-FDA: 84478901976.27.0EE0025
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id C606340008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:59:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vrMu1Cfd;
	spf=pass (imf01.hostedemail.com: domain of praan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771927146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eblwuyUmTR+DmwKKXt5BlH8l1BOeREzivs7XkohPLYU=;
	b=G04waCquSQyY98QUl090ENtn9eDR/5XYVUsmWjvSHlitI/ZSidlPEBR4PTt4VyWzJso1Et
	qS/q1074SjD9R0zHd+HjD6rPYA6WAkK/PW5mSGC4pbNb9Hb+qfzSK7keno8DZE+rpUO8Iz
	FFSPLE5iuPGbUurdaSnhtUAy5Z9NR5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771927146; a=rsa-sha256;
	cv=none;
	b=7qjwxvgVQTsbo1ZjONRcIirQsyDujp1yEFoZmhcRLtxtD4UnGydcRM/fQkjIr+zNuV0Pnx
	3/1WDdwSpmX6qhSbJ4KaPA6ZcHzHpKkkuGepjqG11hMSQgW2Oue45lrnuHjHnzIn5SdRxS
	hz1jaW/N+igRXgbjsBWgL+yHNh9cxdQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vrMu1Cfd;
	spf=pass (imf01.hostedemail.com: domain of praan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2adb1c1f9d4so17265ad.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771927146; x=1772531946; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eblwuyUmTR+DmwKKXt5BlH8l1BOeREzivs7XkohPLYU=;
        b=vrMu1CfdvpT9lF0+yb8hPDjPyTIqwu+tuPZgXfyb9EfRmk/m1T8BU2VbVWzuI8LjC9
         CNDNhdMSyG+u0r50E0FO/xQMSJGUHClK8bomhvjkB2+sDXFVOZ+s6zNJ8jWsMWgneT8l
         9cBL4yGCvaNmaopnslWgBo94U2KvScLeIVM5l9VZAfxzzMxIUUQVQtzrxIMueCJ9jkbK
         I5ilezmGvjW5It+XgleohYf/p0LvbOiTztQ10JsczEpO1wYuMWkR8+C8OIvAgEAWWOcA
         tH4o2LwneGGjb8KWyZbZEEMv/ZUPDK9UEpK2NKxQrnLvyzKwGEuktc3fPWqUPokITQVa
         N2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771927146; x=1772531946;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eblwuyUmTR+DmwKKXt5BlH8l1BOeREzivs7XkohPLYU=;
        b=HcEz612GW9T/UKYWYFcBYSeLJwxn0DRM/Mgn0WD2+FbkOTajcrNK01po4uoLCAVoBw
         o780P7vfjP0Go/5KA22XiUrpgiv+HWugWyTBqT62cT8EcHfl2/weF2OfX4HtvQNgv2AG
         FPr3fvQcKRKZXTPH9ilW/+RiN09jOxuBGvwsoPQZHnbzmR+eqPOJxU3GgMxcj6V+CMMv
         OP/GiC4VxgBLDqvL2MuH7kcEatlO1AYmFTQSCee07D2+zDgotgiGLyrATwfnO2dJOlu/
         jh+q9W8l1yT+S1765VdfEKeuF1oyFXl3DTjIEL1awHoe2xufcuGZot52ace+OZCFlY98
         pcnA==
X-Forwarded-Encrypted: i=1; AJvYcCUJ89xhW0v3gYD5Aw12TJ4hZon6KI0rZhNyH/1bASiSLufmtr3L6jf0gYfbYlvA+Qvm/+f3rF7yNw==@kvack.org
X-Gm-Message-State: AOJu0YzkSh2FHgjyBRdllrqLhmeMTQs8kLOtsCWCiOV4ZnUKB76wCOJU
	sA2kMVvQjtt5YhAhbVWRslxc4ZnBRNu7ZX/gNhrJ7+hkDOVyvzYGaWl2bYuHD0DD/Q==
X-Gm-Gg: ATEYQzzccpy79T9lNF8Nk5Zp32+uDgxDZNUw/H4S/Cu5ReZzF6C8nbt1zCevfAhwuhd
	hm37wKbou8viCYMwaGOTr/wGF5a8+QM53wmTXyFJCBdwBp4oztnBMv8IwQDpGwqCceVFurD3/0d
	B+adDJG8VMcgkXzcFXCLbLYLi01DE+iRUWLR2Kdi5QqLsbvbMl2ep6GTVaysc2lOx1L3H3Pa7g8
	xlSYrHYZyCzLWuiqEQTtacyEd03dk9M3GZiZrJj/DhL866rvN1/0isx5ww382o2gMV5Yc2lias6
	FXBjCeGiCgbQ2/XFQQuLuN8rBSAzYiLKRBQ/yPXmwSQrHG0D8EQJSJR/3abomzTtoKFSY0fxxZX
	lCxu5AmKNvFLFE+oQFLJJ5R/Xk4xJlMluWTGBHK+iTIqJEB/JHjKanetKnY57zYK7lq6kleSJM3
	UkN/8SDRAXG5A6UWEZb5ozfq7EtgFF6pc3qKt/S/W0I33p+Nf7CGx5Xalmj6s+SBfdYDjvOac=
X-Received: by 2002:a17:902:ec89:b0:2a9:5ef5:399b with SMTP id d9443c01a7336-2ada3497c30mr1333915ad.19.1771927145136;
        Tue, 24 Feb 2026 01:59:05 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd47c737sm9949341b3a.0.2026.02.24.01.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 01:59:04 -0800 (PST)
Date: Tue, 24 Feb 2026 09:58:55 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: "Yanjun.Zhu" <yanjun.zhu@linux.dev>, Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <aZ12X3tGn3W7YP4I@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <6dc423bd-36e6-4f97-b2b2-c7030575a3a1@linux.dev>
 <aYZ15u120FEa8Qw2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYZ15u120FEa8Qw2@google.com>
X-Rspam-User: 
X-Stat-Signature: gco6bh9smfbx4qiewm1kdeogtik83p59
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C606340008
X-HE-Tag: 1771927146-663858
X-HE-Meta: U2FsdGVkX18r8E6dbFvN7tafXQRYz9gNjJFwxU7zznrc3nr8IVGYeECw3rKZSMh/oCU6CRvdOIR7cYlbCRHc2fjmL1MMXsedD22a+yTAfIYSu/qPXMMoSggSWaLMiumNVBJ44K1X0uYNvRWGkb4BxfRB2RBxYDwPhbRNPhBrkar1qjpYimm1jFVl3VyhiTHOkvgu1jCkoNyTl7ltOvSJEq2eAqMTOAd78c4hbiDopxDV7ZC1FhHYf0SeWm45TACq1TG8tJhpE+ygC6dPZwNlGpXjjR1P/Zc2g32z5lB8POlRM2MOXjP/rLyo1cNbDYpJMVjGCFgYkfXzs4ZMnV6+rorZJR/fUpZbtUBbuJUKwbX3z8IpTZqlbU/ZH0jvQmLo5l3Cip87gsP8EubWeJlkA3nuI0BqqWHMWVPKNoPfDQ7hFfdVonwhp4EEvV2lFhDPYI3BQ2DziGPu5PSJYb8N7AK8dGCbJ6yp62x+RYmTs3Ig6T1vRHkXrCLLhX5bkWlB/6ojKLG9e+5r+oLlDpFxrwXyrX9CMigcaAbhIwUVnW284ZyO0WLF9S4l+QbRBQJFn9OUSZ8hSLbP0SIc00/oH0Ia4I2VTYGA2VpmqX+l4Az0G5pneJKhN+F4nz8v2N8W68L0lW0VzlN7o5wppeOql75rSZly2C56QpNYIsfIrePbH1o3o55254f79ljNnNL8AgzpylEjH1Ll47dOpv/J+QyqwyKisVtz4DzYNNO5FurGX5TInMe70tkMqauBszBfhNZHwCvlcnujLEGMAchifjP8+oraV0ZU4q+YE2hmrtiSev05gPCaMqEHgVGWSQQzII6R//a0ccuV8WFf5BjzClwVsC4lTc+nD2LQiE7dHu5Dy6vbQFDUMLR1rsxadpSwxqCOxr+YEyRuYWY1iBgZTUvJpaDCp5DOu+fecT8vsAApKDr1OlaRm0FSBxWjjbM4p9+0iU4LjeM47LQEaLY
 BB01KsDa
 0UpTbeT9vCuj/F+/QIHkxcRv960C3xrIz9MXzMC2irKidPYBz0BDGMmJboael4iFrn8GLsQuQmHyL4paR3q6bKWFN5nrGmakEB17JrnbKpRcZJDN5ce0U4y+crQNal+rWpFmchI7y7ltA6CNtpg0DO+/+4ZGFE4cqWHxr5ihgDI1fzmDIoua80XC8VF0ARSeaxHFFyzaJ/zl/77W0zhDKRCvO9JxJfQF0cNyG841pMdGbMG2FjGdLpf8PTPjlhsqMQpUfliHkoDtr5oGz7kpQ0ysBTUTsRyHUEPrpfTIR6DAUoX8WnYjfc0mzDw+qwjc53mdo+F9GYOgqI86op4Or2iR3ENC+WVDygy6silEV0AGnLr1Em0xNOjXotQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:14:46PM +0000, David Matlack wrote:
> On 2026-02-06 02:37 PM, Yanjun.Zhu wrote:
> > On 1/29/26 1:24 PM, David Matlack wrote:
> 
> > > +int __init vfio_pci_liveupdate_init(void)
> > > +{
> > > +	if (!liveupdate_enabled())
> > > +		return 0;
> > 813 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> > 814 {
> > 815         struct liveupdate_file_handler *fh_iter;
> > 816         int err;
> > 817
> > 818         if (!liveupdate_enabled())
> > 
> > 819                 return -EOPNOTSUPP;
> > 
> > In the function liveupdate_register_file_handler, liveupdate_enabled is also checked.
> > as such, it is not necessary to check here?
> 
> Yeah that is a bit odd. I see that memfd_luo_init() just checks for
> -EOPNOTSUPP. We can do the same thing here.

If we move to checking the return value for -EOPNOTSUPP, we should
ensure the pattern is consistent for the upcoming PCI registration in
Patch 7 as well. With this addressed:

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

