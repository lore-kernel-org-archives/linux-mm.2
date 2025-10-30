Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5620FCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 13:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE5B8E0148; Thu, 30 Oct 2025 09:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5D18E007D; Thu, 30 Oct 2025 09:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917A68E0148; Thu, 30 Oct 2025 09:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA778E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:32:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECCAD16015A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:32:32 +0000 (UTC)
X-FDA: 84054870144.23.D4CFA90
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id B656F1A0013
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:32:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KELMTzqT;
	spf=pass (imf19.hostedemail.com: domain of ptesarik@suse.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761831150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtQl7nZ6TBzZdXHchWa3vh+730SdPYteLuoJeZxfyQU=;
	b=gaibDDBB7oxXd9JfjYlNKzYRDdRWQIuduMAzBxhnf7Omg+YkpgOcP42EZ5if2xqaWVaVRc
	4vsTb7Vq9v1dPP9na9kskoPQqWF7zIW/KyKszUm438h6dKhy7RbzlPt9O8DYSXUn25lQPk
	G5XaYNjkb/5lyWrFFLGm9EVodlJQ/1Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KELMTzqT;
	spf=pass (imf19.hostedemail.com: domain of ptesarik@suse.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761831150; a=rsa-sha256;
	cv=none;
	b=vIqvqvLPh2ksrWqJ44PDPK1SOUbSm/BBCpI58HTiJUA42ZYimE3Fo2LRTwIZMPMdssbhIj
	6v21CFZK6Ck6w4XEiQETFufoU0/sNTINN/LbLrAQ9+KFtGWLoNcj075o+6wddEtgX3w5Ks
	ffa4+EJKroGNyisDdrQ+JxogNzXGpQ0=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-63e484f8e54so204688a12.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761831149; x=1762435949; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UtQl7nZ6TBzZdXHchWa3vh+730SdPYteLuoJeZxfyQU=;
        b=KELMTzqTe9QQBR0oelH1jP3HymYNiFmnbYqDJaEj026UUOaKmz9UwFEILBZNBqJUY8
         R3FqHgVLn6wt85WZ8DSIn48qHdY7gl28eopDKKKtVLa6Qk7vIDXrzGYkTkXCbzbhwwFR
         f4CkHxi5x5gskqWDpy31H0hLTIm3jyluRULljFd3xH7/6+FMSP2DlyCgrjjwsJM6Hrm/
         F8A0aoGdm5p688NsAzrMdPwtsOPkOUgbZcXb+FmJQZW+YA/GG83z1/ZEcyrwDD4ceZb3
         /IsVlD8bQNJjTkbtvB69IfYAF63Cu8DcAzeaBbdsQ3cVZzAlJJlVpg95AJKaWdf58a9D
         x3zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761831149; x=1762435949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UtQl7nZ6TBzZdXHchWa3vh+730SdPYteLuoJeZxfyQU=;
        b=KS6U8Bz8K5sGYDSV22KwdeDVz8WyXOHRf6mPyyqz9ibHSB67DupEg+kQ9elXVSCfpe
         Tl2mYv3YoBc3SACMN6loRvMXgOlP0zQYUHHqtbUcOd0r3cKolI579Uq2kN6iFMNRMKRy
         60WWsMWNmwOZ2ULTVXsgMKLLkF6sZHo1vooT8Qwnyx5OfnzKCJagshbd5zG2Z4mjw56G
         6kFPEZaW9loV2/IZ7JTAB0O70p4kyfmcR2AhmBfhaL7KAPNwCj51a5C716DyVoLaZqAd
         mrgP6n6jm4GAHmIkkHmgkev/mrhUnLJgzF4Be55v7dE1C2wLlBpogZBJ0XWpxpbSW6Rf
         DRAg==
X-Forwarded-Encrypted: i=1; AJvYcCXJijGlP9sFSK1jPu5/kVXt+P8eoANlSLaARolXuCqnypNtewv6zFJDFRQwvHVeSXnhPNfeyr8YXw==@kvack.org
X-Gm-Message-State: AOJu0YxyD2tTLThwl41ioR0/SDGVn55Wt5kmXIuCcQ6hNkzHoaEwXNRh
	i2484phPCzI1Ef/DTGPt5c1FFNT/KqDDWxP5I8abAgxOhnMiVVCPQziV8i6rijAizHA=
X-Gm-Gg: ASbGnctY/gokbM+kOQ7hQpJKm5NkRxh3y7ru7gZ+t25N80ZIpuzQeij0Vt16MBZ8H67
	idfk4yud7MY0pTNrxX9ggaaz4KqvSMOanQ+F0gDJXz1joj+bGC4CkRiXyIrBY8urxxpzUI+IBHq
	Mf0gUZd+SPV8lMkn6tdfXRWM1hSfi0eFlWkHIJI9cxkv/GgzAKMurty8pMhXaAPyC9ES0hI3GBT
	QvG5zvYV/tEktWQgjtIZNK/YHrI2UjDMfZAtFlbUhtkNQGKRxOfBmg4kDXeuBUvyCqd4sXuNNQQ
	X1v2JKlHJbtQhf2bkzvTGaM3YKJegVkAu03Gs6hw+bmOaSIz86iG7sUuTybBvcEP56lI4xjfZwB
	q3kQIe71SNZdQX5pPsXOGg5ehgA2Cq2/FXYoJn+TObA4BL06Fz1XdyV7NXcGrWH+6oW/QJX38EX
	L4NcNXb+PcczaIZvgnjiiReRUTgXaRKZFtcI2SmgzXOwtvOJyI6HwEeIwkNY9ARBiCIA==
X-Google-Smtp-Source: AGHT+IHSGEOvYjfz31tHH/a6U1P7PjQbpJ5lLtdmmZBnBXACF8RPqIWku3GmTxQ6eZGROIpWePh0aw==
X-Received: by 2002:a05:6402:42c2:b0:63b:f26d:2eab with SMTP id 4fb4d7f45d1cf-64044195dffmr3098104a12.2.1761831149005;
        Thu, 30 Oct 2025 06:32:29 -0700 (PDT)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64061a5b7b5sm2281942a12.1.2025.10.30.06.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 06:32:28 -0700 (PDT)
Date: Thu, 30 Oct 2025 14:32:26 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slab: use new API for remaining command line
 parameters
Message-ID: <20251030143226.4661857f@mordecai>
In-Reply-To: <aQHx_vx1ElIBh7tq@hyeyoo>
References: <cover.1761324765.git.ptesarik@suse.com>
	<6ae7e0ddc72b7619203c07dd5103a598e12f713b.1761324765.git.ptesarik@suse.com>
	<aQHx_vx1ElIBh7tq@hyeyoo>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B656F1A0013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y16jdzckjqzsm8za8gq4qoctmkhr3snh
X-HE-Tag: 1761831150-623997
X-HE-Meta: U2FsdGVkX18Mxm2YTqiLkf7p78O3dyUpo03Cf9romTno0NOhaDcJFYLoW1/PiKh5aavgKs7204AuVYd1/ojE/nnu67sXqHgghYwstNWfKhDYQg1PuCNC6qv3sF2K3/h+RVpPbT7wzFlVIcPtT4V4txh1bWmVC6xINnCPY6N+9OeCssP5A6WXMpF+M8gnEAJ8q3BVImoPYZ2qQkvwg1FI80UhN8J5d7opoVgIGsx6NnIDvR1ZyL3RuntTMH3miX6ry6lw4XGJCBdOIgVEsKKXfNGQRWh4zTXYBnFwT0PXo60vHUDRU3w1y7VhccsFpKTJCKwmLV6O2ELSoWUabnxOMX2Fnwja211mkBU+Ts2eydIxMtzv8GpmBp4ypmBcWRgKw8Bpr9rB1e+Qrf9AZ7lRMaIYgm5hzDOHm9CKTQsKdI5ZPuiWXRTvXDzmEj7KpgpBn2BV/nFE1ptlsA7IlH0QmhUA+RbvPwexcXQYM6YP390DOsm3E1AqcHPZPRpk1xkxMWQ+7oRo+CEhcC2qkGunPmGWArz0tuoqDGW9ICpRgW7klcU3+wbvCTr8Uw9H7QAIIyHx7t0EPUKhI5xNLhHWgV/N0qm3okVY9pF6YQGIV4Ls2s/3rgXGtY80QM5OEC+4azp1KykVaZJiFICF60fe8zZTtNQ2q1AVVOVr5cU5x6BRQ9RIJizKgOFrlaiGB9dF8Y+4Cmmz+CNc9S/czTu40a6DT90SghZsMqLYWXEZXv2HDoVEkEk5l71uz+JdWtUfRqdi2Hf97MXEL+P84OEJ00xuQmaBvraffNRi91+IYplKI1x1hS8HbJ/IrUheq7ZVQojJwRxHGLN/OiP24976MIya6bzA4lr+qJ+0L0pdec+pGLXg2q1yZlIhOJo71SVO9vbi7+KeyF4iPjFby1O3W+peAn6TBxwY9iNz0NQh93I1GyuNQ87ZfdaLbsVQAyckchw1nxsGnzjsfdMLZ6i
 RiKhxBte
 r0iDVn+ga8VNPKDmbC+WK04xiEU2gVeao3UzoU3s6p+EgplhdPcnV9B4m0mBetqZvAa0ArYgRFBC5r+YjEpPPYVq4fkW4xLGWx9BBK4mH7QcDRZXOWpuvtWmzyM9W9W3+kJ+Bxb0ZvZTDyQGLYvHO0qqAwhgZCwVauSfGAMJZpEYkR5xKAE5Bi2cLEMTK2XvAaFt/voSAkqL7/Ks1wBy9pIvxM3XKi2s+2cm7zymr02PdBBsE7uv+1yVwHDt9imLRxQoidZ6heqTrW/jg00ukQ8NhJyX5trezkQTKTElWJtKEcowlHDDDbsPWyOhz2tkaXJ9SGQ5F46qdks9pYNVKE3jiUuxe+p2VDmzlKbSfC6r1DzI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 19:52:46 +0900
Harry Yoo <harry.yoo@oracle.com> wrote:

> On Fri, Oct 24, 2025 at 07:06:54PM +0200, Petr Tesarik wrote:
> > Use core_param() and __core_param_cb() instead of __setup() or
> > __setup_param() to improve syntax checking and error messages.
> > 
> > Replace get_option() with kstrtouint(), because:
> > * the latter accepts a pointer to const char,
> > * these parameters should not accept ranges,
> > * error value can be passed directly to parser.
> > 
> > There is one more change apart from the parsing of numeric parameters:
> > slub_strict_numa parameter name must match exactly. Before this patch the  
> 
> nit: ^ slab_strict_numa

Indeed.

Petr T

