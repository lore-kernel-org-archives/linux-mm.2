Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AC3C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 04:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DEF96B0095; Wed, 23 Jul 2025 00:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6C76B0096; Wed, 23 Jul 2025 00:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC8C6B009C; Wed, 23 Jul 2025 00:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 391406B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:03:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFC9C112CEB
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:03:52 +0000 (UTC)
X-FDA: 83694185904.03.F2570A6
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 02561A0007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:03:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Aj7LmtyB;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.210.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753243431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA745yoKZM+y1Z9ywfes2QtRwxYl5/Ynbkdt1hGqcxM=;
	b=aOmnNau4EqYv/IPm82wxwR8GCEwtFMnMFN1ESovvZicBXBLGADP5ZS5RoA0oV1RLnD85Hn
	26TZkdwbghWzemXL6pnuJqiQBib9WKxKZhtZHHmQAVTmqvQghFZsvl/hu73xnxqe2J7YyC
	vgyqYdnJ4JncicAl+fOrR7+j7N1Zf1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753243431; a=rsa-sha256;
	cv=none;
	b=5gizSQrhMip9VPsILpM2CjolZDUy4fHoJXKYEt6Xs4s2cMxA+iVLmib+rWbofK4721yoPW
	Vw2JO9A23y8KmnYRemJJeIMLAfrMXc04hzPOtkIM6o17ZCqQ/rP8JwUjIQToKnbUKiRkQN
	b7Rw+/sQ24LFeGoZlYgcmR3n2Srp/EU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Aj7LmtyB;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.210.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7600271f3e9so490031b3a.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 21:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753243430; x=1753848230; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xA745yoKZM+y1Z9ywfes2QtRwxYl5/Ynbkdt1hGqcxM=;
        b=Aj7LmtyBuGl8HGGTXwPv4pBG9SXcQ8+eqMztjoe72+IyykXciyYa/gLrnSlc5rzlhD
         ujiG3mQTevJ+ajhtGnJdRMg5j8QEBDelzMZLfRfLh0uW4+nBDX5+lE8xyMQsiSrNuyTq
         9hDy1SuE7j97a8COcFVsgpi18yNNOQov13KBNvnibWnKd/lpcshQtUXPec2IYLz6CbwR
         YEIuFBRpuqELV5ME5DOg/LXlZtqmDZidF108Kv+P3j4TOutKP726F8jRf6n70/YgZE+O
         I4CiQ4jtbhfKGptxxNHB5E4iMX7mKdW28ffcK6zNZ55Rdq7bjmCGzWCmRjaLv76NW5AK
         id8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753243430; x=1753848230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xA745yoKZM+y1Z9ywfes2QtRwxYl5/Ynbkdt1hGqcxM=;
        b=rms9ao7xcjWBynAoZ/W0HXRcPrJdhMy6pU03GGeAw/Yb7TIqptkvLxWlEUY5LHybSk
         9ItDfrNkUYpCLX9AthkK6KlGGNBKOGGSNXBBMrqk6npMSDDe3pvsHj44x96979tVRwYr
         00upNdtH9svwl4feJTjIjiDaCe+iJcgSL5/E4vQvjz2Mv5XbBtGGZWcZfj/rwGmgoFOZ
         UsVUTI9DCOr8plOUpEjDJ0JfNZc5v2ZNiyEbCkJwfLsyAED9ltin4Zznd12dM/RuCpwF
         wNeLXT7yGD/hmrvd4igDmFtD7o1ZwM0ERbFHkuAw9IQn0/3lo0OKnaYuofNnQIOtNkWM
         hEAw==
X-Forwarded-Encrypted: i=1; AJvYcCWAWq4GPMYQtlJu4NGiPfoX1fjJJBE+qtc796cCipIV51K2vk2oSIbpc3//MlfY6MQLCDMJweNEYw==@kvack.org
X-Gm-Message-State: AOJu0YwEfHF1xD6LwmAb7S3/Fy9yYG83cJCK4b3s7uRpUhVQzxOPSi5O
	Wsw5yJg8HcQrSPdmC5+WhYYJNiKp9Q1nXKagOGDZgAQXs1E83ZTeURD/mUeH2w8/jdQ=
X-Gm-Gg: ASbGnctObGtCDhg50f1k8K5YTYEIpRJPomUzf2KBeGRiauiz5NRQIgg5n5ASQ7Wg3WS
	jw0/yFy3Is/eOwmhyMRRnT1sxWKApPaPiYdmukJ7UJ9+wfSzEqpgvwqGcnyo6EOkQiCrHZGj9kU
	6GwWfXESnKWzAyFAdLNa4oTy+BEirmZns2+WxyrP5wgYSXIkOD4jnRGvwIUYPXdCpXFzljW+8qk
	vYE1Q/nAvh9NsG/sNvZs7gZ+P4Rfp/VgifKAzEXK2XRqUbmoeaQRvZLzIcY53hzO4PjsjbDha4G
	Qy2bSjZ5wzbgG+4qEzbrVL9wsH6ZW3SNs4CJ6DKN9MKhQLSvow591FuD1aHdLCAA8IpJhFlySE0
	yOSpel8XtZXHcSmaTMLHxXaLly+s9O+9Cblg=
X-Google-Smtp-Source: AGHT+IHWWupLuqc8e5GXXzUXDSlEt7hhxnTZrQ9aJK/Vr+sC9tvcbfe/C8gT9skU6Vf1zOtykYPZzQ==
X-Received: by 2002:a05:6a00:4b56:b0:744:a240:fb1b with SMTP id d2e1a72fcca58-7604b947a05mr2140480b3a.5.1753243429711;
        Tue, 22 Jul 2025 21:03:49 -0700 (PDT)
Received: from ziepe.ca (S010670037e345dea.cg.shawcable.net. [68.146.128.183])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2ff62789sm6731701a12.44.2025.07.22.21.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 21:03:48 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1ueQhn-0003Ip-M3;
	Wed, 23 Jul 2025 01:03:47 -0300
Date: Wed, 23 Jul 2025 01:03:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Yonatan Maman <ymaman@nvidia.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alistair Popple <apopple@nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] *** GPU Direct RDMA (P2P DMA) for Device Private
 Pages ***
Message-ID: <aIBfIxVBR/3ig/O/@ziepe.ca>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250720103003.GH402218@unreal>
 <35ff6080-9cb8-43cf-b77a-9ef3afd2ae59@nvidia.com>
 <20250721064904.GK402218@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721064904.GK402218@unreal>
X-Rspamd-Queue-Id: 02561A0007
X-Stat-Signature: j8d8hpo6kpwn38ai7jg5xuabpud3pk9x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753243430-82350
X-HE-Meta: U2FsdGVkX1/c4HSfdeXkTezwVnPg1vzks0rQfDC1ck+7JdkCG1F1qn30yrjhzRG6DzfuMhBzMkp+qpqcVxv05EGiaY1aRUs9xCYhQ/o42Tg3R0XVcm5hU5I9L1KUopnMTYY3urqz4MMe0Kl0Ujp3Sefbi/acljSBTg1boi/ulq+SfXCydFVWpXMQOWlx2twProgZhmJGWjLIcgBgLh8qOsop0VUuOxjcDDD9OjvIiCQZotbqDx0d5EWoLZim8FubKA4wXuXnYsHa8cV16QXZ2YMZ786O7AOinnyS2jRpszDS/kVreyzUD25O+0pU6bfLU9P1gprpohg51jL0KEZg2auSPJd5DVkgDj1dT2Rl5QRutZ1WZj/lJBu0gDbS+/3w0tbWqFfsgP6ErOumP9OYnBiZlFkkHR5IXsr82lf1CQr1xfh6PCfB5J6oIUlaIWHfDC2txiTG/8bu2ke7rm/ryD0HecrTyRPar2M96mU3LJOLeOP2Z8oK77ToZkUbQQtowZ2R1TDH6gxirzNGJXOjxK4CtaoX7CRYExZhrVAoXYT/PrviT7QowdmLHJiJ5wP8v/ow1BUz7HrAltGbKhrU5nZv2rybr3dGDZcQQW8uBfnfCGXiVlNEZFhKsZlsb3fZwhHYdOpYQg6itCTdn+U5zOk64cGE2UnD3fKxt739LGrQmlO3PyCB3NPzsrcNRKXU558KmG5dMebzesKFCBFIlkTJqFvR1zDB72cBf6xbh9CTVOIIzsoWyf1xIJJ0Yv/jnCXDxSQ4GonjjIeqnCwE1PreQYvDf81WdBguWvSML74Z11qp8wvn4Tu7bIpzDZjz8Z3/HZNU87ffMDq3blnw7aG2YnFJrf4CEXT7rJQw2amS/kii3qFWwsU+7aU0H9mjYazen+UruqSoNgck5PDJIDWXaWG6EVDatD2Pjsm7G2efhBiIYb6Ju6O8dg21gKnJ4qMadWYK2SIDpKpR+cw
 bGbth1a2
 N/3HP3HYMmTpONKlfNKiG8FdTqnBajOc31ZeYdRn5VxFYRKbkJhgYXrEsua874X6VzBke9BGuYRHGJvetRhkcyeJbIuWdvJj38qnZDIyHdZeeCWpRxbKursPtYwxTzGY+HlPVmYo//p3OYZPQTyO9U4T8xKu0zb2N5vyw2QSIBrrU9d8gTxGd37yA82EdJhWQ4kV4Tgg0cQLdIhAKyVHB1cV5DdV5taJf2FLDe4/+IA60drHsFJLUHGbEiZ/2C4E43DnP7s/oEXDP1VwisO1EUzt5/tZPLHB53+1u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 09:49:04AM +0300, Leon Romanovsky wrote:
> > In fact, hmm_range_fault doesn't have information about the destination
> > device that will perform the DMA mapping.
> 
> So probably you need to teach HMM to perform page_faults on specific device.

That isn't how the HMM side is supposed to work, this API is just
giving the one and only P2P page that is backing the device private.

The providing driver shouldn't be doing any p2pdma operations to check
feasibility.

Otherwise we are doing p2p operations twice on every page, doesn't
make sense.

We've consistently been saying the P2P is done during the DMA mapping
side only, I think we should stick with that. Failing P2P is an
exception case, and the fix is to trigger page migration which the
general hmm code knows how to do. So calling hmm range fault again
makes sense to me. I wouldn't want drivers open coding the migration
logic in the new callback.

Jason

