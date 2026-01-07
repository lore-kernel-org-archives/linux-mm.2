Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 757D7CFD647
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45ABC6B008A; Wed,  7 Jan 2026 11:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408576B0093; Wed,  7 Jan 2026 11:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A646B0095; Wed,  7 Jan 2026 11:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2200C6B008A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:01:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6385CB8DE2
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:01:02 +0000 (UTC)
X-FDA: 84305631564.02.A9A50E2
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5BB47180020
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:01:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BRzJni7L;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767801660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3+MM7tobpT8iFiKLyusxR6cK1SXJsQSVXCJN0L9E9M=;
	b=VPaNAm2C9Q+JYZrNOfJEuZOUx6e09JdHacJ9GYrsdqW+eK0FpccDcZxJ17yxtMVF+l7sYY
	4WKoQ08dpWU6BZeKp8CDoEAfV7uS+soK2tQMYOZgJF3pDaATmCocJxzrmU2kWtD4ZCVKKy
	zv75YkpLN3ZCRq2YLBGtdYMlrqm7LC0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BRzJni7L;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767801660; a=rsa-sha256;
	cv=none;
	b=yfB5Sm/ez0rKQ0KqV/n2c7mlJoojBRKbIae0NUXmm5mXgGE8olDp96J51ztDDjNMyYYigq
	0nzss8Gkq5aYMJ9utHpMXMRdHcLnabzpoOyy3uAVQzJM7hd4SwmWSoEjz/pxIYmEugXC51
	RgImiBs76bnFCYbjIIY/jRBA/sXbC3E=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee0ce50b95so8812421cf.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 08:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767801659; x=1768406459; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E3+MM7tobpT8iFiKLyusxR6cK1SXJsQSVXCJN0L9E9M=;
        b=BRzJni7Le1pSvX3UsTggplSU2UGNpi+bvgYPqvM4m0/VGMSLfQ4RcrMdrvPuo7Whvt
         FvhirlqOOAZ9mdkrte70q7iOEloK5pDecf6E8qT2GnoqYpycqSLIZ8nJ10kd9z+KotLh
         awd6Nq/76WUarpBMAcySoF4LGtstTA9YUl7tn9WoIYwIKv3dANe1JfjwwsqjbeIk33LT
         m4klozF/sv7/r+HoUusay8W/thNLyw5ZDcF0VQHmNZuHIl89BiAJkIfHx3+iWSQM6hnM
         1pYp197j1prC6HodDk8Jlw7TZ8evsMPdXTsFjoQQpiy1b+wDensYPMejIv+KgJg8B6h0
         9DZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767801659; x=1768406459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3+MM7tobpT8iFiKLyusxR6cK1SXJsQSVXCJN0L9E9M=;
        b=AMrIY0Oz1saNZBtpC5xG8dWTVQAwIkCYC74osXrDzNNWxmD6oRnyPpK1q3vwId0D+D
         d+HhvKZCikLD0/suZCtc9hjJJiPelXd2l8mhIvXhMELerBdccRYdpdzx36BUJyNrfPwj
         +qUy+5maq10usXlPJf5oKQ19rwwxcIcXESY3yj/So0hxdeOSlSsDBm6qNO+Cl7lAcnGT
         zI0ZWOd44sG3n7OVrHYWJ5u5MVc3k4xxD4lekFdA+ZZiMaD+qh/GzYF4wUgldKVmAZXJ
         6ElxvrsZ+92yNDzM96IIPThQxslhWIRPWSurAQjAo6DBZntxWCgDHuINBy7zlw2u1ac5
         IT6w==
X-Forwarded-Encrypted: i=1; AJvYcCX4u/L+uXk4Vy10SM4xq4kzq4Agw4P5S6W2vG4JAdzwpvt2rwKgGBkt6gpi8SFY65u5J73+nnr8AA==@kvack.org
X-Gm-Message-State: AOJu0YyFfYpvORWz5DfDX4D9R6DeoarsLbzWeW/Zy5rftNa2YRAhOsrX
	bCR/U+T5iEW6aIEFVYH406Ky22xv1jX/++E4JGeI090y3iLJ08oca7R8Jd6FxvOz4MQ=
X-Gm-Gg: AY/fxX5BP8GNDiqI6Ucv73O7a0/uzk4yJNqX/hvRk1z/fsoHVjgBQ56ytyNoffLjuG/
	psBJBm7xIQA6rhSxV5yU8QoU8i5axt1kJdnj/AJ4aRzFcb9DNRzhbmoifXYpv901B3aGkJMCl7M
	ZzP3Xq6YwlXh1GvqQauLSKKYO/p8SLYUBTUYsYWrqxIJiZij5xOx60/z2+wlUgmdu2zCuVRiBWE
	bZmCiD79JE7o+KM3sL9PqRDHaYXQAqSvjdZwwxJyRnuQqR9Kwtdpxz10INamJeYggKksoHjmN6A
	fBgwoCvB0yxSKCohWIUtdZA77Gpp0CXqq8oVQPF3WmQQ7W+q94cXGcII20c9Rj+fNAPyo3NvNSc
	+VxyitbhGr2lJYixsMoGmw9YdrVPMUxwjFJsigooq7peMz35vlf187+u3bWxznNMeurDQMx3iNa
	wxKK6qFVlMhkWQMvsAHSofm/u7PYeHuzn/cPXkHD5TIOS08f0szaFoelC/IRxEfqamckhrzA==
X-Google-Smtp-Source: AGHT+IFAe+h/qbJUDO3gQDsebQZ5B6ZQswuRD21Zlq6jITXPFCkVccHvnHqclWnOxjx79CDvaT4XpQ==
X-Received: by 2002:a05:622a:54b:b0:4ed:3d24:9570 with SMTP id d75a77b69052e-4ffa852b431mr97724731cf.37.1767801657128;
        Wed, 07 Jan 2026 08:00:57 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffb813ffb8sm9862841cf.20.2026.01.07.08.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 08:00:55 -0800 (PST)
Date: Wed, 7 Jan 2026 11:00:20 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, hare@suse.de
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV6DFJAg7yl3qXHG@gourry-fedora-PF4VCD3F>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <aV0kzBxg57Mlw8mx@tiehlicka>
 <aV0-ChclC7SCrxcg@gourry-fedora-PF4VCD3F>
 <aV1nPG1BgBQDWkjE@tiehlicka>
 <39533aa8-ca78-41a8-b005-9202ce53e3ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39533aa8-ca78-41a8-b005-9202ce53e3ae@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5BB47180020
X-Stat-Signature: 743c3nsciqsdttfn3yd5gams44qbbath
X-Rspam-User: 
X-HE-Tag: 1767801660-294402
X-HE-Meta: U2FsdGVkX1/21nsbBiQ9AAhxkMQb1MvEUgsrwCp0s9FD7ekSweULQ83aolXLxhC1ld1qddT4okS9nMtkMyNiCia4aPMLCHhMMCB/BXhVNcnWmQNgj06gXA//B5+2oo4RiT5ISdSBSt5pccJADnP89k5vK69fy9p0tkyaB83ZArwpDBCnKnwocEqjUcYnGHPITdbK8V7MRaZnQn1sj5SjjYFhALOZMY/+rv4xrsBO9a8QVwFjYT2cDDu6+50zzi5tpoFZ2XMWHKMDoe2GWoFH3Uqyjfi06MmGs96l3rvaauqdVo264WQIOH1YSjpM77RyAc8yISgJ6BsSV3DvUVZ+tSkPZ9XrhZbVkBJmuMCk49yvDiYw7t0rd9+aCc1jfPXh0tDdFOid6DRwesoWG+tLiQHQGof1ZSCtHK2LM2TA+pRv5pWETDK6Fv9RBKElqNx4icP8z3W+q9kX+udRaWON6XNrN5zBcEEW3+vQgScdho1rIgBudx8VROaqmiryTTUtTu6mM8vhRBpoReX4kYiCJnUWAYJS5BIer8zEAaytI41Y57a6OUt+aui3Cp9poqqQ6KBZMTkdXV+5H87f6WBz8tnalR3cf7QleStXCwqvyvbKJ86i/pAk7BdKeuZjXTtOD954mnVXljezvHgheGDG4YyO6+Pvx8OWB8yZJRo2te7wqtBP+R2YaxdM6u63pQtn9ATe56844Ed/iozxE161+SFtVqu+jm36WfdU/huWYng/yqo0wLkx4Qa4tRKJaj4lyeoo0T4m+9vAEyHqMZnkxvOBVsbjpDT19gmly64U+xrZ/uqQ5DfgXgN3lBXux07UeMuMr5HCzMfo40y0cGRAmwa1mH/NB6R/HHfkvJ65FdnNgGn0GjLfMiJ+fx249gepZmHvqloCzUo8qHl8h0181yWaqOyvjbkgCrugsomiRy7MjAWdlHbO1/7hzauY0VvhbezcsQ20qka/EtYbNqJ
 XQQ+h0dI
 3Gtoo1FM4u+W7htB969Z/Qy9lQ6kMe4GkRfiIY9Kfm1idEnOGpVziDRMFkq4U/g5vOL02PGqiffHDtKS54QDcQbvMJ9znxon0VdWP4OagHOF+V7yjte8gCAjslQhOKr0Vzfr1AU2bTRNFh1Rew+PA6J98spGQUlkJWgucLDJCx3L6Q27Zg5PcmlbkjGvNIvF5EELq8h6zCkg0k9HOWASAADGeo/1jJFJ+bsTFsEb+i7pm12Jh2yTET2yd4MCldb70fZcTNyMzzD+VO3/3oa2ni2Rcg16LFhyAd7h8FuSMP5AiceoRU5qmBalco3ciVYdN/QiuWZzPljj8xhwQn69xXTNrTbofmZu4zQuJCZ5J44RyG2i9xSMdUA6mCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 04:09:34PM +0100, David Hildenbrand (Red Hat) wrote:
> > Sure, I wouldn't push for more complexity just for the sake of a
> > theoretical extensibility. And I have to admit I have't tried to a quick
> > PoC to see how complex this could grow. I was hoping this could get into
> > a simple mask for online types with default MMOP_ONLINE_KERNEL|MMOP_ONLINE_MOVABLE
> > and special cases just choosing one of the two and zone_for_pfn_range
> > checking for the compatibility with the requested online type. But I do
> > appreciate there might be some obstacles on the way to achieve that.
> 
> If we want to go down that path of failing onlining, we could likely do
> without any core-MM changes: dax can simply register a memory notifier and
> fail MEM_GOING_ONLINE of its memory with -EINVAL when it sees !ZONE_MOVABLE.
> 
> That works, because online_pages() does the move_pfn_range_to_zone() before
> calling MEM_GOING_ONLINE.
> 

This would be clean, and we could add a switch in dax-kmem for something
like hotunplug=true which limits zone eligibility to ZONE_MOVABLE.

I can look at this next week or so.

~Gregory

