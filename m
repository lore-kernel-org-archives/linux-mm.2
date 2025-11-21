Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05890CFC267
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 11:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C38C6B0026; Fri, 21 Nov 2025 06:40:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B166B0029; Fri, 21 Nov 2025 06:40:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7D06B0095; Fri, 21 Nov 2025 06:40:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E99A6B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:40:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2787160591
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:40:20 +0000 (UTC)
X-FDA: 84134421000.12.65582AD
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 992A220007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:40:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ok69cvs2;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763725219; a=rsa-sha256;
	cv=none;
	b=WGkD90v/OjWJbfo8h9J3t6aJDouCxfUnkBHUlTmJN19kemAN+42l3NnNf6JfYELIl3CcRk
	DaUy1ta3EwS/n8EHcNwQoAX9n9E8WMUc4PL3Uu/9NiXOz8CAhCgBMEXGopRXgjpLxLyKGu
	cYhCaB8tX4ToDCkveeSy+gEgsMWYxHM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ok69cvs2;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763725219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vhd0z5G/L7h7MLT55sYTaC/qxnDz9iOOGe9BsQAb9Os=;
	b=1+gKQ1oQdh8S/BCtHurwh/A3aPxg0984Z8p5gS0Snr0sr6GxqWbQaUmjTxbM258Zz8/XBt
	tSH08UKLfkL8ct8bb+3JPrF5mdS2TpQtwYlBN0E/P9rSanJMUlgmR3boJBJsK967EEjwXa
	C9NHjmNJWqEQBmUUJufXZbXxWOkKDHM=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so1076171f8f.3
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1763725217; x=1764330017; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vhd0z5G/L7h7MLT55sYTaC/qxnDz9iOOGe9BsQAb9Os=;
        b=ok69cvs2kHEgsW8+JIqXAWRt7BpntEzoPQtTlnldamCcfusDgUxzfi45F4ivc0qh/0
         trlCSoHXAGm/LFQKhx/cmLiCp5qkjm66fdUPn7I++be7bQGMicsa1nx8+oOXqyD43cQu
         IL9XA0iPt7yKEapYhzeSf/M/3y00p+JS9+bCjJhTSoCArkwGGFOPsOlAMlMa6VJJqKvW
         qQ+ziSp+rorNjoBfjxIlNAT7fomPwCuqemMOl1AdfsDeL2jIvtNDIJd9FSsIEJ+WWWTF
         A4drEiQADBxTGBu6IukbXdP6gx0zGTXxBcnLgUnmdR0lLSw3XmSOu/b8rq3tcidPbh8V
         d5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763725217; x=1764330017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vhd0z5G/L7h7MLT55sYTaC/qxnDz9iOOGe9BsQAb9Os=;
        b=RDv7ycBOwvTFlJL7aH3SoTTLZZcag4Ad37TsyEe85+buqK4atc+7ZDdXj8XpwccMOc
         9Gz0jtpK/WB/vJn0QS+wc+vKT7WjqLPkhkG/VXOE3E8f3ZMbeLxaP5xwz3fYhDmjxicQ
         UyW3AHHC9yeDoYDjxpaHDflfcT+CYBbGQnfFywRvyzpdziPPB86Z+qt+CyMkJ7z2IXWI
         w/Ceelaam+BllqHSHU2buel+le1/152frzeNsIVtrZ57Lf7Lchs+TZZNAxnlQtuGsywb
         iEDGv0YlxY6XRV1+DDzmN2QMq3ynuTeee2SxYwFuqKNoJyhZleVXyx67FmnApgJ34yYF
         zPLA==
X-Forwarded-Encrypted: i=1; AJvYcCWoUWCeBD6VhFkhgnuKej/GJgWP+/W4uHOJah8QQliCPy2q+gWSM0l7fNGvSgo8o1SK98F+qWImJg==@kvack.org
X-Gm-Message-State: AOJu0Yy4Oqwb0Mp07GY64QFhSiFo9qtu0ikvhPoel14WOxbe+eWl+j5D
	ro/9wjaG86KylsIIWyuaR1kEp4Yes14NVLH2kwbl+3CtdlQMhqCim2ryP38tjxqlLlE=
X-Gm-Gg: ASbGncuK21FvzcJ/M/DrwJmdu8hSfXHCU44j/hDN6tnHXRMY1n0iR1k0QAyYmVu9y1s
	y10j/54G4y4TT/J3lU2GM9Ujqq5sQflZZsy2+TR8JsIAIYuSRPCrMFprYEhdaDh0F06t/0yTukz
	qbjyN1a7+3vEIqUM45/1kGOCDApznbFMl9qnigaFel55aMYU/k36YZD9O5xNJ8h5IXpH4hDL+qv
	fwiXqTam4274Vly1JGQUQayCnBdUVHYkJa16mxVai/0TmaoZN3u4EkjaCBvOzDOY3tgShN5yGn6
	pl3y7IUKtLICK4jTSO8dzcNh8z639sngIg6d6Xo156gsh041WEYbYlK5XHNUd79FbeO4RJt8Ug7
	uYQfHXfeyYpywsSb/8y/M/jHxfXH8yuwU87tl6Hs0LRITRk7o22ij+0hlIPVafZoXNl06
X-Google-Smtp-Source: AGHT+IEgsvla2icfCYM18HjMX7hO+ZfzwY8kLg+zvj18fqSOqNkdKKiBm7nhf0ttJREO7eB4OShiRA==
X-Received: by 2002:a05:6000:2909:b0:42b:2c61:86f1 with SMTP id ffacd0b85a97d-42cc1d0cf81mr1931981f8f.35.1763725216785;
        Fri, 21 Nov 2025 03:40:16 -0800 (PST)
Received: from localhost ([2620:10d:c092:600::1:610c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fd9b45sm10401328f8f.43.2025.11.21.03.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 03:40:15 -0800 (PST)
Date: Fri, 21 Nov 2025 06:40:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratmal@google.com,
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <20251121114011.GA71307@cmpxchg.org>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 992A220007
X-Stat-Signature: uqp8c81u9k4f8jxup684rmnkj4xaingq
X-HE-Tag: 1763725218-27049
X-HE-Meta: U2FsdGVkX19ZpS8JitKNcuKVzS+a4XtVGzPk51lSoiK7xwBMakKZ3fLeHW4kxrFdEl548zLgJQ+R3DAac01Pmk3mOeslpOiK8WidlwRXbGxbcrb11Ycjw9oGArttaWMwuA8ahgv9pd3rhBZwaEQ7kwMPWkhGs13ANf/2Dcreix3VI3BJ/GiGZJ0Pz16Ut2pSb3RYrZoGHB84rJUAfOn9aIl6RK097hF4lEctoA+GmsRxjjXPOArs3XMLmUyWLuI2lZTk+leloZFO3m70nxp6rcH6qb5YWTr/hzhxIjeWe0sIyUCeXtoduQYM6b3ZUQW8UufPxpiFO5Ad5K2h3dFahNv6tC6j+oGrQD9IQjPCd7a2CKbtls+s8pVxGJDlv2mRmmoGK1bJRlokReV/p8FHikV9IMsXhsmpVEpC9QAU8idxxzy/46Dxgd1nCxzX43asACuVbqi2CEmO7+kg21nFK6UErh7AtE60zrrfENLBGOCSUpud0264hlAvQ8BjqhcpuTOEo6j5BuQjNh1XPH+qHKqrwnfBILZ3okVYF+NzXMf2Ch0h3TyvQpVE6vncOIOxBdpvMFukzRnV5v6c/dTNStI7ajt3+hLnkikMXRBOlW1lIK53ZZ42aob7AT5AiTLLZNiSS9PybYr5R+j6htAKvkrdQwn1sh0pMIfF5ZseApjDKa+hPWR9maYun3gW6jHRVfiunR3YH/bVsEHsfxvEuJl9ISyjsAC12R8/83k91mlJn9BhVgSSLd4/N/V1kvAs8qtCfSIOINaS3IgkV1aTg646AbzGXtQ8MtZ8mx4qN/GUiQCQSm+2fBVeirS2/gQjJhQCbQ1o7OjHzrp21BZRVbyDACVz8Ygym+QvBmqLtSXrLH1m2VCDp2VpGL94OmdaaIfLBlQfaOxMh+1faZhmEDC2ZLly9/sbLuGV+2AbCwdyp9TnUqDCpXhW2vDWUrRR6HkW9NCJx48XzQnWuo/
 EvpRgpid
 9nUmlDHySYE6ALYlEYJyPTDWSv+2NbelFJxoyWyzjkDfskZF97LIiaAcIsv5Z6V4jQHQ8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> The current zswap requires a backing swapfile. The swap slot used
> by zswap is not able to be used by the swapfile. That waste swapfile
> space.
>
> The ghost swapfile is a swapfile that only contains the swapfile header
> for zswap. The swapfile header indicate the size of the swapfile. There
> is no swap data section in the ghost swapfile, therefore, no waste of
> swapfile space.  As such, any write to a ghost swapfile will fail. To
> prevents accidental read or write of ghost swapfile, bdev of
> swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> flag because there is no rotation disk access when using zswap.

Zswap is primarily a compressed cache for real swap on secondary
storage. It's indeed quite important that entries currently in zswap
don't occupy disk slots; but for a solution to this to be acceptable,
it has to work with the primary usecase and support disk writeback.

This direction is a dead-end. Please take a look at Nhat's swap
virtualization patches. They decouple zswap from disk geometry, while
still supporting writeback to an actual backend file.

Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

