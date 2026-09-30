Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0716DCA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 08:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09F36B0088; Wed, 30 Sep 2026 04:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1676B008A; Wed, 30 Sep 2026 04:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7376B008C; Wed, 30 Sep 2026 04:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9664B6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:43:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0642B16071C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:43:54 +0000 (UTC)
X-FDA: 85269790788.08.B406C73
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 292B71C0002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:43:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mvcYkcUL;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790757832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11O/i4eaHiTKOHQj5oOKeDGVuB1F5PuQ9vQoJ/Gyud8=;
	b=GKgsSaE+gEWM9opBKBVYCtfhlcsl71I0Ts56HW0zd45E5wqBVbWyYYnRe1bbNDrQJ6A1gI
	rqyxiDAe7FkL94HA8zjX54u3z/L7ScuijFyPDTHtz8xf5ifk7/oYRfPyabp1VOjsYRvPoB
	9dPNwCxDfFedw76M4SbeAsIBrQoQUZc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mvcYkcUL;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790757832;
	b=jUxmr9FwCDKrmdAJTrmZzT57RYrztrgFNda+4O08VDxfQu2AlkOXnExuOtfVhCMPj9dMel
	jomVtvAFVtg9I9F0q3kSD4Dq8MGDk9cHqIuFfyXGij9udjCklVvWZPRefRTmlPjuQQsw0u
	r0alNTYueTZEhhBlFqFKQy5PLtsJiEo=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6ae185cc40fso325599a12.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 01:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790757831; x=1791362631; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=11O/i4eaHiTKOHQj5oOKeDGVuB1F5PuQ9vQoJ/Gyud8=;
        b=mvcYkcUL6LGZIp2dsOHkwnteBDIFU9ihUt1u4PxGHmuYF6WBwx7zrZIC14UD8VCcEY
         qDvgN7h/+dXHZxZYSnPo9IypQhzHUUkYu4++ckPdmWzzXNvFh4/AQPXRIvAO3GO+ksHJ
         BqsDfH7xsu5heuDh4mxW0KKxO9mXp8BF0YQrZoer+7tg3k0AFk2qW0Ge4at0LKbK4/4h
         14zcH+i9iLi5uOUzkNSiY3moLeuOHrMsgq8JPNzSLpO/3eOj2wQ4uWDamqELYBCrFXIY
         1MxUuJTkQAwievOvda8cQ2ex1ckx/Jh/1lEK0RyPo4ApzoTzMWWV5rJxZEiYqNINWDr9
         LeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790757831; x=1791362631;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=11O/i4eaHiTKOHQj5oOKeDGVuB1F5PuQ9vQoJ/Gyud8=;
        b=T1oBCctrI3TvRx7ITlL/iVzTbCOg7nbBy2N6M6/woWcPwTk5ACy5UXpMTGpQEjMHbr
         k6VvJEcNmrZwj4VeutPcreOsyaZuuxGYB5sWFvt7YBw0/POf7w0zDYLsscrUticIpxQo
         XT2tLAoHkdbkxjCrXs6gyBwTKcXlMx5yzAhBxsZldtxm2ht+ibqNHgLfOxKb0vS4gGnR
         1Qmg/5Hlxy8Nx4qfS1X/g8CKX2O+jHPyydE3DvnjoG7fdS2xnZtWf/rC8iXKfmCKQlys
         kmx//ASziVLBO1SCUbkgWY2bGcEeAHdKRbUuEmWEj7hz2Pwc3gPcPxrfHSlj4uXoyACZ
         c/Zg==
X-Forwarded-Encrypted: i=1; AKwUvBw1um9VMZsuzJGV+WfP6L9NQK8YgE1RLoKPHIrBDANMzyevdQ3ias+e9OBhWD2CZmf6WkIcqA5r1A==@kvack.org
X-Gm-Message-State: AFuF++le7Me+W8lGqvn9VTCuDD5j+XBcegSriS+0mNDoUHb13dO7bGcW
	mgU0oiO8X8erJObxVcCIIZVm1iU98SqyuVXWAFNPZf793xsvXInmtMpJTQqaDdTP0iE=
X-Gm-Gg: AYBFou0T39kuW/EpvxJ50/iUO0U9udZtp49fn8CNPlY3nz0wQ4Z1B8yJsZb9UYvipQy
	uaZ6+ogxrQSVdXkEG0z0J1OCg6I/3B4NtZWYRnjneI78RcIuT9StWS3YNdd75LH3o2SeVYcEYLj
	SFhU8kmO4S9DH5gwxKofmIY8RK2ilEPAhnCiDo4xzrjbJxXg8/IUJzHJOecSknWUlTyiEHqTlvK
	kUN+aUFS+opBT6N9n2/O6p7IqUbCFnbSI+6FgB5ipFRHXGby0+ZrbPnf+dp1uIipS8p6/es857j
	5oh3VgmuHBfchVFOmMhpgX8mjrU1gvNlmqkMEv4x3Y735Q353+DWt7uTPFZo5JWJtVelbs7vUEy
	5hiT2T5iCTdpP5LkU/cKzCRAcIISSZXKSePtZPkoSGTqkF+971BDKIpc2HPSoWuJ+N9S5dsBkez
	f61KAQguHOVF60REplvnpVd8K+80Pslhn3vJ5BGq0k+0Z1ENRstf9Ry7HAxK0=
X-Received: by 2002:a17:907:94c4:b0:c2e:22f7:59c5 with SMTP id a640c23a62f3a-c2e23cabdb0mr57793966b.7.1790757830388;
        Wed, 30 Sep 2026 01:43:50 -0700 (PDT)
Received: from fedora ([84.207.203.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e22f5f676sm29571566b.26.2026.09.30.01.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 01:43:49 -0700 (PDT)
Date: Wed, 30 Sep 2026 09:43:47 +0100
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, rppt@kernel.org, mhocko@suse.com,
	corbet@lwn.net, skhan@linuxfoundation.org, ziy@nvidia.com,
	joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Message-ID: <arzLw18RiTN6Hmey@fedora>
References: <20260930072617.64665-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930072617.64665-1-lizhe.67@bytedance.com>
X-Stat-Signature: kyji91c7fknfocewc9rd96mhsu1rg9h4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 292B71C0002
X-HE-Tag: 1790757832-869438
X-HE-Meta: U2FsdGVkX1/xqLL+Ml3EaaoHqWmGb/Y16QpAC+V7wSrqQ2Sil9Bp34ogJVG4xqaifsCTCafXqUD+XPjURtHAP7gi5zI4kVLSlK3LqvM/zbSagvskBOoOs6JKItjapX9TjCVHUnyYLAEhBL82Hctbe7EVLLjmrucanRnEehan1hB1Oo2OFHgcH11YqNHCYd608KmfKsEiZ/Qp3BueVpMyNxeFmz3Z8QffvF81fAVPIgpKICB9ccte1K+jqO15LfOH7UtCjQlLvpuV5a2JalsDLqZDAH1jspgRAbrkq+mDWY6PB8UpYKjPSXUcrqtZKSEpjaQwDWfQVj5xazWSMBiTVAek9L1d7aLnhchPNehrPPy37AzCEKwoE2c+WCmCrZeHGG089hZ+7xNmG6thq2kdQ8kvPl6GY+RylRIsx3fWFa2IhEHquBFis1gf8V/Cp8GXOgV8YAJ1/R0RVCVJGtWQ9RU5znnqNdN04n7H5DzJo9QCwpMBRRf8dQJHo+wMni0PKayp0Z6cxLX4jDknezT9SrSUNwi6cHctYdD4ftUgDlNVdfzIVIP0y5wUZcL+V/e+Yu9eXV5j8V/6viK5Ew1+yY7vHY9QwPyV98CkDZlBn8vsFKsarQstRBXoaZ2Vk3DYQZVdxRpD+EKvy2P3ZtYZ1rp2b9/vc46KNxM/ecQlv3NafYYw1Xny/2GXcpDDFEY1dKxLemQWETpf9v/ZV9AxizwgI2L7o12NsGDgEGbpW1HESiwHvszJDwiewBbGSrdLKLaSsvyq2nCh84zKG2EOLiMnGErUrY2pEFIkYuOa312ky8/E+A3iokdffr3kTNGiLp88+mByXs8hF1cmupQcdp40lgCrjbfxO5CqI3GrWBP2ygVt+Jn+Bc39KsXkLRdZcsKT+NLBKwSh4d4RONEhPO8EBm+NOsEf7rovl5yjhUVTQEwK1cUwvpdsiJx+C1zylVDHdaShR5N2ap4tcBp
 2rgFMzim
 dk0i3NV7Tc/mqqw2NU0KXuOJe5GN/63Sud7j0SwUzszKwmNFXBVsuGCHPT5JEWWA0MyNbObNkDWfAYkQTNwCM0XrrGMhYMDqwQDIHUikNaV8gTOq91jXsKTEOXI8+V843uBqORDog6X+8Q7TpfIapEYdlQ6KFLNVPezjhmNjbdcT2ttTojwEaHtUl1VVq9CNzIpzE4+Hnd6PWJ8MmkR74LNn8bAufxiXnW1Iwyl1x2QIp1WxF1VGNLGKqal7anoOdoJ9PBQ8zfSDMdkhjxDtp9y5ubSnM6/S3n6jIaZQI8GdyUGS9gLpSZgmFkfnbqnpnGMcADdC/0wqYXg44F4c35hH9yxlS6cRw2BdM7qUfKU1rd7XklrIDDu8WUd1yHnbiYfxc+3NmCShznf8EIncMAaS25Oj4JssDu68w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 03:26:17PM +0800, Li Zhe wrote:
> Allow MPOL_F_NUMA_BALANCING for MPOL_WEIGHTED_INTERLEAVE.  As with
> MPOL_BIND and MPOL_PREFERRED_MANY, keep migration constrained by the
> policy nodemask: if the CPU's node is outside the nodemask, do not
> migrate the folio there.
>

Why for WEIGHTED_INTERLEAVE and not INTERLEAVE as well?

Otherwise this seems reasonable.

~Gregory

