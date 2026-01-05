Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86B4C2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 05:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAAE96B00DD; Mon,  5 Jan 2026 00:11:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D592B6B00DF; Mon,  5 Jan 2026 00:11:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31E76B00E0; Mon,  5 Jan 2026 00:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1F336B00DD
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 00:11:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B13398496
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:11:07 +0000 (UTC)
X-FDA: 84296736174.02.BD3180A
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id B8E9F140008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:11:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0gmyZ7d5;
	spf=pass (imf26.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767589865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvpNrM6V6EQoznDW/e/eykjEU9kcBlSrOOOQoJkleao=;
	b=LSsUtNliQhYXgPbXJjo6hpVH4lKWIKgtAHdYX8mU1oeQ5dfD7G2AuW26POnK8ww2ytjb+m
	kMR0WdsOMOQB4L8CnEGAVJLX/eDCWrutgz+cdWvZIqW6MAuVeI+UwU6q5wPdgKnA5PYNee
	EsXGJasUp8q6agYs5dAyMyFYK85ci4Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0gmyZ7d5;
	spf=pass (imf26.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767589865; a=rsa-sha256;
	cv=none;
	b=Jgztona0ZUK33mb3cznobLdlKH0ogkzx8057Xtod1/lIGbwAQsjPXQcGMceMt+1NA9O7sh
	fSU5jwsKqix2/J8JKvqaA2Gmc2Fs967vtsfR5p57Ac6qrt2xSyvGMAotCxpzEaTcmTw/Xl
	Gjp6J2C9MOlBK3MwSg+vWrZaWZJYjZQ=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0d06cfa93so155305ad.1
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 21:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767589865; x=1768194665; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MvpNrM6V6EQoznDW/e/eykjEU9kcBlSrOOOQoJkleao=;
        b=0gmyZ7d5JMRoyunSxZnB1z6SEZlCNZLuEiSSqFYz1ZhRkHUHIwQt7Luxa+ClQXW/Xn
         nwPqmbMgGllaNlnZGvYWabllt7sjInVpekwTNfMZRJRpK/ybRWFcRuQ+c24U7kxWbPHa
         kFg27aQwYCrewm7syvWRIRTuNVUG9E47Qi9R69Tfw6TVfmZQtheqDMlSMz2RnxyWK0p/
         /KjutIOa28wr/azspgHth+8SwLvCiGwlXHinyjiNtscf3CUj08rIn5na8Wx7ZXupcrjp
         Viy8lY9opcGrdOPs6jEI1bKZP6XlEz7abe1GMtb8d5A5yQEa5q6epWtR+z7pBMKkAV8u
         bavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767589865; x=1768194665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MvpNrM6V6EQoznDW/e/eykjEU9kcBlSrOOOQoJkleao=;
        b=Yu5z92WxrIgVXf7uwcfGqYivobbyJXDc2DBI54j3YMaQuGmIky0fshWumVowHIrnco
         4F6vn9legZdeGcAprIisaohEutSCk2qIJphkbYpSlb8jMPH8m664JMVifGhWcnchcMz1
         W1gxukJ0bCd16MVIwu2Gt3AXXmKgC2EynjUfUkCz+Iy8VWtADPVVaJYLdlxsByYL0SZb
         BlsojtmzalU24K6haRNZd59yIgkmmQ++ZsSFz+D6uwe4brDoWRh7frfjcT/wfhGpOOp5
         GFMao+XSFTN8lOi/6TP4bftF4GXpkIL6+PHk9eeJ5GK0Ny3d5t85VD9B7dPHYkWdTrha
         W1xg==
X-Gm-Message-State: AOJu0Yx5X58r2RHcEZNN/brr0fAZDkd70dmHa+k+vleC8FC9R1/iWMPJ
	zjgc+oAgIp6dX4xhwy34M95VrZoEeDDzUde5w2D/5LJtBbOxszjlAZefcZqRukDZQg==
X-Gm-Gg: AY/fxX6PBOArdamQfOHUAkrNpnRlAPPaQdsllYPVb2jQaEFb7SWNY0F0NYgKV8xAafY
	pa6S62+N3oAxNfYdMjx5v5TjC87dWuQgRqHU0ERBJLvqDe4FsHnOABJtyLrPjZN8GuGGeeqexrc
	Ey938sUoG2Jxgf4iGQVPWG8Vp2JwtGrtulYF5U1yJg1lKPQKdGRu9QV3T9p7zAL4+ir6PHggFQ2
	Q7kVJZW/IGEJ0ocW4mldtabCKC1CQowMe0rtTgft9Ti0B4JFCfgL8xjFLfsJBLYz1URitsIMUHt
	j80hyIyqNe8HsvNxDULQONeZb4q1xH8ufT68NKIyScuvLyn1d7NJ4UfMgzcYgG8n5wcBbodPSdV
	gLepIBE02Af0XD8Z6McZlbCo5oyy5jSn6nFQsASUApHAWLpkg5iW8at2OnsDRHMmjjddGWD8b31
	2Kum4W/tabFZjaLomt+cJ2XhOshKHkWzHvTZ9m7F25q9js/sdTAcESFt/tVr//Gfo=
X-Google-Smtp-Source: AGHT+IH6GRc2aKx9uWPc08BhMYf4GulScHtpZeTvi1OKubAvka4Vbsx4UDJ2sIYfstiF5FDYFBSb0Q==
X-Received: by 2002:a17:902:d4d2:b0:26d:72f8:8cfa with SMTP id d9443c01a7336-2a3c3188ae9mr1797925ad.13.1767589864039;
        Sun, 04 Jan 2026 21:11:04 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7ae354easm46697199b3a.16.2026.01.04.21.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 21:11:03 -0800 (PST)
Date: Mon, 5 Jan 2026 05:10:58 +0000
From: Bing Jiao <bingjiao@google.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, gourry@gourry.net, longman@redhat.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org,
	mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v4] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aVtH4tXHgx0a3udf@google.com>
References: <20251223212032.665731-1-bingjiao@google.com>
 <20260104085439.4076810-1-bingjiao@google.com>
 <b55451ff-b861-4e4f-bc79-6de0c802d64e@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b55451ff-b861-4e4f-bc79-6de0c802d64e@huaweicloud.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8E9F140008
X-Stat-Signature: pacd1buch7h3kzbwuy9863rzwc1ign1z
X-Rspam-User: 
X-HE-Tag: 1767589865-84644
X-HE-Meta: U2FsdGVkX1//SU6QeFjArld92vUg2XEqBNZYuoRdAonQd1khjK/vEbPK59qv6+zpha0MAXCnc7GhLd8RqVWdQYFg3hKyoWA0nDxQiO6W/FgzSqtSc5Dybv0tKyEB/AEDmzNTNXkvovseNZJTtc4xlHoOCLyWxtTOmsEl96ym8sBcIYJrOauwJbi+FCJWkcFilIHSh6FPPqBNkFhUeYHsawBYIlTQB0zkY+TlAB6c8UM011WNSa5WEHZQp+o0NFa3xoi6oqc0CDdpebhJnZoSmK+xYC/Z8gdHXfUxMJs3r4Id37ZWMv1/scppW4up0pfSwGrkBSX5ioCcBB8lrw7yZaVdzFuAt0vE7Aj9bDhlyftnBdswFMG0q482RwW/fi3flFh45vN86VlT8tnP3qCQfaIQtqCWVtkaTX7HivotChSH9aBDd4ojC0Sg4+sCNeDV+dQ0jiA6C9BL7W3B5T4PxU5M1JbIjx2irp9FM7LezBmjXyhOVKU/dvz47L/X1XmPE6bz7m2xUuACgetgmYTTMME97txpj1h1vp842VCj8wMhCR4Bu1llVi+KXt4gRjtH3ifNmDzAknB8GxDZuKFXQpETUgYEiNtuUMPkltaVUvtFUPeAi4f+VC3DxFTStOp5uWQeTx5ng11My6VlyWOHAeXbnxA1K2BTQczSYbEne8WJYc3cr4PffgmLBdQgc3fSOSJ2odjfcPMBpe0uGFWE++yiEfmmvsqLNonW4gWEQhyOl0HUqa3oefA+G0oeUg4YcHz0/Lfbf8MoHGsDUr7gL6u03I9iz+OoUJW7ecBIgg/0vygEvFDbI3fE4YQfaPflkdLKxd7UZfaQsmbqrFLcVBttPnosIkezQPNB/VQYLrqCopWfXr1qWgWYPyQV6RxALT6TR6dlc8WznAkATYyI0zAHMS0Adcp5VhfFEUyfyMjcYgQL+JOVWsvlyJeF23oGP0GgEKuWti9E8jnoTao
 yl8DAA2T
 jzNKZCiV9vVilNxJ4h6tD2CNs/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:48:09AM +0800, Chen Ridong wrote:
> >  	cs = container_of(css, struct cpuset, css);
> > -	allowed = node_isset(nid, cs->effective_mems);
> > +	nodes_and(*mask, *mask, cs->effective_mems);
>
> Why do we need the and operation? Can't we just copy cs->effective_mems to mask directly?
>
> Per Longman's suggestion, name it cpuset_nodes_allowed and handle the filtering in
> mem_cgroup_node_filter_allowed. Please keep the allowed nodes retrieval logic common.
>
> Best regards,
> Ridong

Thank you for the explanation and suggestions.

Patch v5 has been sent with the corresponding updates.

Best,
Bing

