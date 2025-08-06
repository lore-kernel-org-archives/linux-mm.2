Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14738C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 09:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860556B00C5; Wed,  6 Aug 2025 05:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837C96B00C8; Wed,  6 Aug 2025 05:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D416B00C7; Wed,  6 Aug 2025 05:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6208D6B00D4
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:36:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7F66B87CD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:36:17 +0000 (UTC)
X-FDA: 83745826794.18.B872C11
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id E1F2CA0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:36:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Afit54FH;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754472976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lYYsLzSzPrboBgIaB2CsUlJcp8uiiPFpeJB8b2vvMg=;
	b=lW1TzMVp5vhnqUYrX4h4zcSUHFiRfyfKZcCyhE2ZsVYYRDpTEjurmqOII9S/bw47Q6hgsA
	iWvHbUPLR484ZSy6jNlno/hUWojGLiJkjQSkWbgHibqFOkALcMHCn+yzVyKFHEv97NPllg
	kHlb2AN4eumCb0R3PfIa7jW7psCAntA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Afit54FH;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754472976; a=rsa-sha256;
	cv=none;
	b=bdvindaI7WSYtSqn+5AofawxpGMssrwcJp4+HWvwZyszNy9lldRa7ZoDHywofdrXYCBBfm
	z8l8NV9yyV+t8sTvPzrKMWA37eh5D2wzK1eXzui1cY2Z8pmOjshh0z3AZyCSJyC4ap7CPS
	qoreD1I/SOX/3Wr1pS8C6bOutaqiJ3A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754472975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9lYYsLzSzPrboBgIaB2CsUlJcp8uiiPFpeJB8b2vvMg=;
	b=Afit54FHTc6bhKrzZO3d7Rq7OQva3qytMknYWR41ed0OTYLwmy84erggGd6xgxxtZ5pkW6
	Y+9/rso0xdOphxOmucoinYUeZlAbTwv7vRR26d5yzrvX5PeqPuFISyuzTBQ23sTmaMmn4p
	fHCy0PPp7zG9xhziNpDEDoqr9kUifjg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-UFCNoUSGPC6BIOrNHzU-2A-1; Wed,
 06 Aug 2025 05:36:11 -0400
X-MC-Unique: UFCNoUSGPC6BIOrNHzU-2A-1
X-Mimecast-MFC-AGG-ID: UFCNoUSGPC6BIOrNHzU-2A_1754472970
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1772619560AE;
	Wed,  6 Aug 2025 09:36:09 +0000 (UTC)
Received: from localhost (unknown [10.72.112.218])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 791923000199;
	Wed,  6 Aug 2025 09:36:07 +0000 (UTC)
Date: Wed, 6 Aug 2025 17:36:03 +0800
From: Baoquan He <bhe@redhat.com>
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all
 three modes
Message-ID: <aJMiA2hh3S9JCqOu@MiWiFi-R3L-srv>
References: <20250805062333.121553-5-bhe@redhat.com>
 <20250806052231.619715-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806052231.619715-1-sj@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: by9naeq4qmefwmwzwy4jqiq18zowo7pd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1F2CA0003
X-Rspam-User: 
X-HE-Tag: 1754472975-759898
X-HE-Meta: U2FsdGVkX18FmiuDm/spups/HUSv3IuU4f0S3ToUcCy6gDnQ8CMAtXxCpTGY5euvSXNKyPg62b+SstTHHVAHF4t50uvxrmCedVNX+112bGwJPWKFWcW4keweOu9EyD4+mQFXAy3mdyaxc7ztHzadP+HC0gSxXCNg0hRALo99yDbOtDjnREMz650gI40szDR7za0Knx2xf3sSqznpDQvgoSnCXolqSlLei7Nwf6G8BMYXJdIFucAQ3ZYjjCsg4Pp91jUIxQ7T2GyrEES9kyg6EzfKfvwqAV8oCi1eeeDxb8bLSj6SPEscp+JpMNJ+8mjOQDqr5HJFYueXVdW0t9+mWaQAHcoik1dzPu6zximWmXBY7IIgFnjYXrlB48M22dsAhOQvl8knssBow/ZhDasS89BqPi0x8uNKDcm1yWi2BCUR4Mu7xNN/x/tQtH9We1wbHZyX862lmRUsktZhPO2v8UZQrFEQVljet93yt+hL6D5G0CFrQNumrIcx4qWH3GlGS3Mr8LRhLeno4WfRHyO083OasPTh+p4BzFOhr7nywiK8fKpWP+m0jSwYkhUnnkUuG1t57OcT/iM1EMhLia7GYyuvtTwpauUfOQ/bXNuN+YWrjnicpzRW5L+CXBqlBYK/15zPNyiULgqDVhCZcvtqnV3gYPPcnaCUArV7fs0j5EYcl+Q1e/ukeO+qky9tsqM29gy7Telj0JM5Sj16JNQlRyGOilueMsC01l1e+G96mQLQyci0pN8C/MCPB6NR5tcHX1d4b0UyDHKKPP3guFQUXa2wHvfCpvjdbS6pUzfAfDPsdcpfz7cwb9CLyUEPYlaGk8jFdbqL+T0HqerYiikVOZl9z+DFTB/sf7ZxAEB5TRXrNIovNngUIUa33Q2bDaNMQCInmlqz0NpwIVUKsLe9QJJSak0oovMcqLErovbxAPaLf618I8RI6GZsdRcnEBdmnE2Ad8AoSVNvZfz8zb/
 zY9kDS9k
 fmrqZj8y/3niFm6cMwFKw9d35v3/Wooz16b7iVqP/GF6G51bACSoNHSmI3lteCiSY4igHZnO61G/vYdJdHLk7ZtgicLBBv7HefWVLc9VOHHQjppmhXWSIe18fsWp2BlIWGltiRCkqHounNCL2zThGq/T5rN86At+NMaXvgHYkzPPqM4XOj5Nl08XGm/PDep0FAi90K22NHNSXUZ8VmcPQbOqEMLvcxAvCjRXDhl/4z3pF3AxF+xvCVSQhE5CFqgrQTUR5JEWB5v4A4mWnY8revAwBRVC/9nDo5c9ULITgRBo8K0mfK+hx6XgnEzVa7TAysJbSm248B0Ed3T9tYDHJ4YrWz7lrT1XyUHaqND3wzH/sO0DMTmCa7+Y0mU10QnkS9j3FQt7HjIAg0w1NrSCfQkPH7HBk2ArgX9A+wnrRT0TBSsWqaloqTAzhC2yijwNAoX5Or17Mk0UJxCFrWhXA4nOBmnfsXCovsBVvgr+kzbXPC5iB1ZYgarUVjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/05/25 at 10:22pm, SeongJae Park wrote:
> Hello Baoqua,
> 
> On Tue,  5 Aug 2025 14:23:33 +0800 Baoquan He <bhe@redhat.com> wrote:
> 
> > Now everything is ready, set kasan=off can disable kasan for all
> > three modes.
> > 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/kasan-enabled.h | 11 +----------
> >  1 file changed, 1 insertion(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > index 32f2d19f599f..b5857e15ef14 100644
> > --- a/include/linux/kasan-enabled.h
> > +++ b/include/linux/kasan-enabled.h
> > @@ -8,30 +8,21 @@ extern bool kasan_arg_disabled;
> >  
> >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> >  
> > -#ifdef CONFIG_KASAN_HW_TAGS
> > -
> >  static __always_inline bool kasan_enabled(void)
> >  {
> >  	return static_branch_likely(&kasan_flag_enabled);
> >  }
> 
> I found mm-new build fails when CONFIG_KASAN is unset as below, and 'git
> bisect' points this patch.
> 
>       LD      .tmp_vmlinux1
>     ld: lib/stackdepot.o:(__jump_table+0x8): undefined reference to `kasan_flag_enabled'
> 
> Since kasna_flag_enabled is defined in mm/kasan/common.c, I confirmed diff like
> below fixes this.  I think it may not be a correct fix though, since I didn't
> read this patchset thoroughly.

Thanks a lot for the reporting and fix. The below code is great to fix
the error. I reproduced it and tested with below fix, it works.

Since there's other reviewing comments, I will merge this into v2 post.

> 
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> index b5857e15ef14..a53d112b1020 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -8,11 +8,22 @@ extern bool kasan_arg_disabled;
>  
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>  
> +#ifdef CONFIG_KASAN
> +
>  static __always_inline bool kasan_enabled(void)
>  {
>  	return static_branch_likely(&kasan_flag_enabled);
>  }
>  
> +#else /* CONFIG_KASAN */
> +
> +static inline bool kasan_enabled(void)
> +{
> +	return false;
> +}
> +
> +#endif
> +
>  #ifdef CONFIG_KASAN_HW_TAGS
>  static inline bool kasan_hw_tags_enabled(void)
>  {
> 
> 
> [...]
> 
> Thanks,
> SJ
> 


