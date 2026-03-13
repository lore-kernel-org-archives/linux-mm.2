Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297D0106FD9D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9266B0005; Fri, 13 Mar 2026 04:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254E56B0088; Fri, 13 Mar 2026 04:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137496B0089; Fri, 13 Mar 2026 04:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F29B06B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:00:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57F0C1A08B6
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:00:09 +0000 (UTC)
X-FDA: 84540291738.05.3380140
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D716640012
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:00:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JKWarZ+k;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773388807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUt1gcYqzrYknbcgM6G0CiCCOogoU5FAXbp8MqBc1GI=;
	b=2b5mr9mhtLScumbTGZfPkU7alL2kxTivgry6nmpUnTjvkK0aGxdFCOiWOD2uCf1NC+1uCA
	5tvHNWzl1ETL/bW1EF5FvQ6KfxZuWb6V1NDpc/zwSabVIunkjJrddvGWKXTNQ76QEQ0NhA
	KvEWpj2b3i/Zlou5EONfHuYDgPuWYrs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773388807; a=rsa-sha256;
	cv=none;
	b=F/I439BkI0M8tNXNKmGwT3YcU8IEfX+x0aKTfi2zUvh1vjHMnK1pHtchHNhejMwtbT0rjs
	SOhv0d4+Zwbs5G5eOX7Y1ezgcziooh21kM3I4A80B3PoP+U7aRZ6Y0/YWmdzpvCzabCN65
	W7atKoZ1T+BtcEoQS++OznVAvBYOHgU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JKWarZ+k;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773388806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lUt1gcYqzrYknbcgM6G0CiCCOogoU5FAXbp8MqBc1GI=;
	b=JKWarZ+kUjLyrMuARXWufIgSH3UiqVa3XckLw+xKTufQZ9pT3pjLzUVUZ+bS55eD0yz9+C
	PQVVToid44GsT/75t68MsFJVfi03NYaUl+HBzicVamrZOBEEJyLOTUGrgy8Y2CTolUOMKi
	cObybQJQJUGulTxAPkTI2uvgC+ndHmQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-8HpY-TbnPbqc6Wy4yMt3aA-1; Fri, 13 Mar 2026 04:00:04 -0400
X-MC-Unique: 8HpY-TbnPbqc6Wy4yMt3aA-1
X-Mimecast-MFC-AGG-ID: 8HpY-TbnPbqc6Wy4yMt3aA_1773388804
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae6961bff0so150934005ad.2
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773388804; x=1773993604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lUt1gcYqzrYknbcgM6G0CiCCOogoU5FAXbp8MqBc1GI=;
        b=iUm3Q6jXJpqzI412DLKTsLFpLl55tqkwZ17MSqHgk3R6pSS6CPbKrDQWNcH4X2ExlL
         SA9IFkofmEgSzcKPcYUI1csT/DwQPRyOnzXVoqq7Uq++Gmc5u0SbL4mCTB2vJSv1dmBQ
         rHo4On0vIUo9O3kJ2pNqn97Evy0XYWVsiZjSMGdChOaMZL1frhUdb/2ndxMIgrCsR+L4
         t/P9fDn7Z3m7LoQDqo/3pCj65wF+FC8aaZhf4TgfjOq9X2QWIDNX5s+qmrIux/Zywprt
         Wf2eIYqnHgdF1VIJmpPmApPrSalDStlmG/tCQ7U4BLgSgQd7BLPjbpb5DzE/+CwNe9Zh
         GnFw==
X-Forwarded-Encrypted: i=1; AJvYcCViDMR4p7N6xV0QdQmpgVidigJmM0B+8H/Mb25udVRrewFKZgjmOv67qpjZGcm/poFA4uWYpKg86w==@kvack.org
X-Gm-Message-State: AOJu0YyNmO2572VVkqZxl5CmSSSZLCwfwdIkSOxDXl5v3Ji0/BKUTmgE
	OCVaqJQC8MRut2r8wH91BNh4c7+E2JuSLgoK+N66YRbKpzLITLbDuh3SNAvj4BKiKqqG682y4HR
	/bQsqIi18LoGHIEM7Bx5uIbK6+wzI16G1XOMu8YcneOjcUMBaC3jo
X-Gm-Gg: ATEYQzzcixswcVBnkK7SITObvWDjX2oa/56zYaV23h6UXFH3W6qAky0RuBLKlJlh+k6
	eKJ3gkw0cZ9DRFhyA7DX9Rj3OfFPRGjG555xSsiN6+jITTbMiEQ3X8yWpuXCxmysb4vxFDjq5NI
	lmGUiBbGUKv1ks+0emLtVng1NpxI+BDQpgseoPvSNhD9zpQgzHVe7yhjxzR3z+CiH8YJlHqaD5Y
	36OH6yByssnWhne/mf9UzxODKbGHTlOzGtYLV2edgsL7gj1jz+dDARZrz1WY6cvIo9OzMZIEgku
	SH3G1u+5n3D+v8IilvtxHVoabWjiwdjxagSJBtSxX0zg1tZHzZH5HnhPFuHd9rfkC2Ta5kEFLr2
	YG/DNtCmCsaYY+Of1DQ==
X-Received: by 2002:a17:903:2ace:b0:2ae:ba41:55 with SMTP id d9443c01a7336-2aecab1f315mr23815195ad.26.1773388803688;
        Fri, 13 Mar 2026 01:00:03 -0700 (PDT)
X-Received: by 2002:a17:903:2ace:b0:2ae:ba41:55 with SMTP id d9443c01a7336-2aecab1f315mr23814895ad.26.1773388803242;
        Fri, 13 Mar 2026 01:00:03 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece825aaesm12117585ad.73.2026.03.13.01.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 01:00:02 -0700 (PDT)
Date: Fri, 13 Mar 2026 16:00:00 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: yosryahmed@google.com, nphamcs@gmail.com,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v3 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
Message-ID: <abPEALhYmtBnEULi@redhat.com>
References: <20260313043532.103987-1-liwang@redhat.com>
 <CAO9r8zMsbVHKnCzfQcdtomRMWTNFgTGY4XALxwm+i9m1SUPPvg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zMsbVHKnCzfQcdtomRMWTNFgTGY4XALxwm+i9m1SUPPvg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gnUFgBUZT34sxc5gSHxUTDVYov3HmJH6ZPFJKaL0uBY_1773388804
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D716640012
X-Stat-Signature: g6u3obhgyxbwffkw9dsutpa334yhzj4w
X-Rspam-User: 
X-HE-Tag: 1773388806-593541
X-HE-Meta: U2FsdGVkX1/oddTZoJBFEKoGQbJlm78rB8vu1DJ4YmdYDZ7MIisomuf8j1YB2LeSYZVUtnC6laWBO1VVOh7JKNs31MHWAvbzblkAxOtsbxFOyku0pHaJ4cbraZ4NBnecz5MPVVhNfExzXhSJmkKGWUj0sC8zxQ6vXhanbn+nUbBKnOL7RFcmTzsBFa++2aRkWkphWpDrn3IEyFEbOHX6S3APa167lXMdr95J6yWFGPdY366mxY6pNi7qRAjy5GfiwGeuXkTdC/lnqA/c58FCvmGly5lx/Z/HpxbiUezMRBBQWmIdiai96Bx1fhcBkynmCON7cd2LT9ETWzuMQG7UchioX7DxEZ34HfgCMDy9u76ctj12mPijSRfMqqQgzh1g/PGAw9CwidoSzsDHZmvo5vU+kql/xO5U716vOCy199QnsqzemWpay3/aaAhauAozZz6E8xJ9N/8XjB8v3byeTFIR5ZwPGv7A9PHO/eyVOhWglluymKE16gh23uyEdYOh/fLYMweKeMJm0CHA00v2VRe1yOKxlCvkQ4yZhBr5clPDgwvFU2i3giDZ/m2pLZ9AWhDwqw4w+5eVK+iGk5OUu8Y07OckaytwHMllOhcCBaTVcWJd1ifGws1xE0nqFTk2pg959jpx+CXVM5eNuDncWAl2F6d0gK2+v97aYIyda/S2nxxyb9lUf8Ey3Xmk1ch32Q3MxGEVE3EV0WjDgcVXqB40rkra+g3yqC8slq6xA06EVrgoVORr/sM7gG+pYruzFUr9/+F9AZd5/H5NIjOrthcODZ/r1f/BPX4j4Fj2pqH4NHdGjaKCrC1L+GwhkQ2oCH3Wd4zm2BhQqZU2oVrTGNQicR9+etF7GFTQSk6t1xHn+YHoI6g7ChHILqYCrXcrUpd3aIk6iZWa9/Sy27ZaVjR1TO+UbqX1Ve7kY8RtIOInv8q/9SFva+AueMWxG0EveszFPDCnuvX5XlE3hSI
 390/xUAU
 r0wRQoNAKBgz4YPut9EnX9Zf/OytRaY0aARLFMviuTj3dMpkXtXJknU6uFMPmDVqYvY6JXbJQlZ/UjOx83a+Cig1z0I0GI9RJomRg5hnJGpfYJeTZGvyvFFfu9LDOwvk23IbP1Pq7x3/UqAiv8k5P2bAM1N/zJyHM34CuWD7rXjtFKmZuWwMjVqAjJIk1xr1giykXv9QJXdkduVeCqO3ZRxURYVDqnM3ALf0t9H8qVrdpobhvfgpdxWcwwGN0zlw8kfXWvb0IdB1F5hNNcv0U7vtmpiH0mPUsYtT26M/ZGs3la9wwnhckXagtZrpVRzJ/ybl9AlG1af/0cx6AoReyA8vvMJF3an3KTU3oE3KkAjcvlZ3jb/CDTcg1JgnFKY2RzALabD63t2jkVjKE7OaQ9oY2dbqLurKT44jUhRhALliSStLxfqwiKwkjUMRKdHb5Zxr2oTi41Ni5rhTz4axFY/dILYwlaNQnVOuG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 11:34:41PM -0700, Yosry Ahmed wrote:
> > diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> > index 64ebc3f3f203..e69d845d3592 100644
> > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > @@ -589,9 +589,21 @@ struct zswap_test {
> >  };
> >  #undef T
> >
> > -static bool zswap_configured(void)
> > +static void check_zswap_enabled(void)
> >  {
> > -       return access("/sys/module/zswap", F_OK) == 0;
> > +       char value[2];
> 
> Please wait for discussions on the previous version to conclude and
> give people a little bit of time to respond before sending the next
> version.

Sorry for the rush. I thought that I had clarified the issue there.

> I think this can just be be:
> 
>     char value;
>     ...
> 
>     if (read_text(.., &value, sizeof(value)) < 0)

This actuall introduce a problem to the code, as in read_text()
that achivement is:

  len = read(fd, buf, max_len - 1);

When 'sizeof(value) == 1' pass in that makes read(fd, &value, 0);
read zero, after that, the value is set to '\0'.

With your < 0 check, this is treated as success, then value == 'N' is false,
the check_zswap_enabled will report wrong status (enabled) on disabled.

-- 
Regards,
Li Wang


