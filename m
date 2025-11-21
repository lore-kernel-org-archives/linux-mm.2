Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C2CCFA47B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2056B002F; Fri, 21 Nov 2025 02:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B5F6B0093; Fri, 21 Nov 2025 02:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAA96B0099; Fri, 21 Nov 2025 02:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9CF76B0032
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:58:51 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A03912FB5E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:58:49 +0000 (UTC)
X-FDA: 84133862778.27.19AE1C5
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B13C160004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:58:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M4Ek7kNj;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763711927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULtA7+no79tQHYGo+HGcPlA57KIY7uM5/EPUmiOFSmo=;
	b=mfKd+o8ex3q5d+S2x86j8bd9N8TQ9VLsspfiiE7rIDom7wQJaOJbtw7j8NNQg74FrsrK88
	8InWcBK1MGkINe6LH4luGoS7qeoKk9PpP4+9nREn+Y60sidRhK8t6iyzqMsEwVngIWEsva
	CJ/GN81wPGQtEeCo+a7yACZzk7RxGOw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M4Ek7kNj;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763711927; a=rsa-sha256;
	cv=none;
	b=D/cr5kQuOCUbcsJ4sb5oGafcTam/xvTHAnN5J/vpVe/5cKavoY85LJ1T0JcA3Room8QZPq
	z93JZg+iJg3uUnTgfEJUVcDrbR3InyKuLxRsA0uDYaUW6EAIfR+X+sYcV1btOQOYofVpcq
	In1OwbbpCTK0fL2GVSsDJuHjRjg1yn8=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7ba49f92362so1144967b3a.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763711926; x=1764316726; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ULtA7+no79tQHYGo+HGcPlA57KIY7uM5/EPUmiOFSmo=;
        b=M4Ek7kNjLMUZNImyWn3SXb0ZnTnmuuuNlMU2mNmiAFhkRo2SIi2+reGq5exVmMctWQ
         na6QO22u6TLG6BTT7wD2rLtJ0am2U4+q3kKPhqcnxgACg2AO3t7Nk4BZxBslvuhd9haZ
         FrZmzZuTJnRJT+wzf3GNhnzXqkf+x4cUYLUeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763711926; x=1764316726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULtA7+no79tQHYGo+HGcPlA57KIY7uM5/EPUmiOFSmo=;
        b=qIZF+IoG9yTMZ/fCWH2LuSGK/RlqoApKNrmZ0zB+xIXMe1WtaG9R08sVwVAiPp2Aio
         oqExLb0Vh4Zvi36ryfgMP35ntu7rNCPb4fpLGswBItQEJ/Tn0/80Z2TIIe+wqSi0UUHV
         cDKkLZvGPAf9EZmEm3yrGwgUt+zeWXWht8qlLJd+llGZlk1Hq5WXH7p0R61AoYDIUS2+
         w4fTz5/LGGBDm0AxjV2DaxOExzkAn+b4SpGiyHlApUU4pF/9E+KeeVZwH9JA39q/OhjH
         kiqBZFTklwrFm5AgDYuAXw3HKNBkAwFJiBA4cAn7b/JXQji3fwO1Gmmi6oERc+GCwt7j
         gTFg==
X-Forwarded-Encrypted: i=1; AJvYcCXEjJyDq5ZEig33RQfeAgQTopNRsmCZaKgUjg+qggJrmelbknw0m1kXHmApgrRyGahOR6O2DWsnsg==@kvack.org
X-Gm-Message-State: AOJu0YxmuUTjmqACi5/KMs3TvD6I39vv9PRPtvI3nQ5vE796NPLAEuRh
	SNxIkJya3r9NYXlCM45RkNZBQOITwagGbjADEas9mr0UajkkZnNXGtOJRedKbAardQ==
X-Gm-Gg: ASbGncvsFoc4puXOqbOvUA9L3uBn8iL6StWXRsIrKZN7a+wA86Xm9cfm6qfWtcytypd
	xreL3mAleSkASS3pS2YLd9bLVSk1QUlipaFqgzuJzvJYtF9ZUKp6leyrWKN1ePj0NV+wz7414ns
	us+T0H8SyZ0z2vWqyWfLpwUb9C3NrVh4yvNSGTPZls2+dVhAZB51PYqMD5Xbvtbfg+AF8YpRHVq
	+8SU+dpaqZ8mOyj+9q83Xh/9oPn8V5qAintIi2HE/t26y3j5s7xDZgp3oDtuRPZoD0Flj+3qNl5
	TTBDmxLd5X2og23rXJuQruiv7mYUQ6+Vf2TKa/KOgEGc/3zKtsWHTF1GMYDR7TLv/nBYSqekidp
	xR7kGmiI+EoI5bskH7S6Wq6Pj2JDwZ0QqGdB8QImgCkA3PKaFzertBW238+aqlvXF88KYLKOL+v
	IMMbaqhu4SbcpJ7yJk5BaP8Xif
X-Google-Smtp-Source: AGHT+IF8r+u0PMm2TNqKDmt9NgdUlfFVT/4Cdqlq2JQX3RkS5uXvuVrL+4bKtdDMN2zzv+JF+RTdLA==
X-Received: by 2002:a05:6a20:7289:b0:2cb:519b:33fe with SMTP id adf61e73a8af0-3614f506763mr1920075637.21.1763711926304;
        Thu, 20 Nov 2025 23:58:46 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b321:53f:aff8:76e2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ed47b388sm5171421b3a.27.2025.11.20.23.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 23:58:45 -0800 (PST)
Date: Fri, 21 Nov 2025 16:58:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Message-ID: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
References: <upyms2wnksojg6ix7dha74bjm2gfhv6ieef65k3f2our4r6fp4@kjtpmu4mtbay>
 <tencent_7F5D453FDCFFE315AE59E73779635F865D08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_7F5D453FDCFFE315AE59E73779635F865D08@qq.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B13C160004
X-Stat-Signature: xwk3zp6g1dpunt9t43iz5xhw6o1hpg4s
X-Rspam-User: 
X-HE-Tag: 1763711927-251828
X-HE-Meta: U2FsdGVkX1/x4aybHxiSC2rh3OUHnakePtDvajwAyNFM5hEW6zaQjVwdktMiE6IHBCLjhO6R2/fXLNN65F+s17Y/mMIDbS+ZEg7baGS+QPznKNv9JAUKuSUfF+Og6d8TcfNgPe2EB3NN3mEqBLxoCVFxgo6J9ZWhq/h990BEWii3+KoeWkwDhgY86HUV40kuf+jDtM7Y1Gqc7vK8TtDk6au0z0vqJaKxrzi/qTVbQC5t+0kmwt7GEkczK4JjJqgXoklxZBynfrUGsh1mlPEwwktRXqf7Zo/W1LFOykskClk/SuRg8YBdxl7WWY1gYKO8v4rSyd+3He//v8qbtlz1GZYeR7082lZI4NlslgfXY4H02giCyGGgTrwf4/0hoDidI7jmB1X3NCuUpZkDG0YJddfiaspVH40f3SRMrx1SyRL1XactRiwFwZBTzr28n1pjXntuJomTPCK8uulB22EY09HRMjdvxcvq/gHzf0skaoMDp1uqRc4YZIF+3E21dtnCcMKjGHPuQ8czEK89HOk7y9c9sQE3TyAR5esqRp3xs0v0VmvWM4pjB2dn14xnQw35F2M7Cmf/c4ryGg7H0005qwpDfiTguGizI/sH4yBTjjH/o8Qno9n7yj4IusMJeGxaMiSx2O5rsxqUg/ebDMDvXui5h2FhkHVFwyANfOtcuNlYfKsYpd7NbrrHBRaWYDp85qq+e7DUX+LdYhoDnb6i+hU9DaP6PSQzP+6pS4+vaNt1PwIQc7EW4j+Ibk+oPSD0I67l5VwTwd8HFmWoicHn7d+A3Vd0JBhOMHyNG2RuFxySPTLZI+9LTZ3XDJGAEdK6mbBeeH0thHbdjQe7uK2xTU5LvAmB1ay4Ivh/OwSCmce4Ev/yXXZu4UdJbpK6Xy3xlbWSlrom6+64Ec2KJXibTlubajY5i4hEaI0UHysGuoSTj9PNpxbriLT4xrON0Gpv24YT70V89vGgOOKYv97
 BYeD7QIj
 mtFFrbykn706IjLsiipz46LTnvRdmKTqhcXJUPzCfpIOsYwLP2XBhpiCF086DqzYxXt2wIbzQay1hvcdR1YQ3tyJOmsllv9zFCObFdnb9xLTsSelVpIqUdNL/Zbd9ZtOfbS8BhQ4YkuBs4ev1VrTyCaM7L53J21q+UCEUy5OMKVeqcLqfWq6k0fLxM61Hc+Oc6q84AJA7Qe0LL4nwAtBmoeq7sibGzDoMHGGQ8WU9/Ggc6aH8xSv4yHYfRijFBH8t9FZuUINeOLIcLcZEO22Wlf+3yRjeJtE22NdwYq+p4lzsMrdWbiixDthUkBIA6P7gqHgqH9pXkaoVNaIS5Bu+V0Cg72PXRGCOyoi0VkCz9+Z3cVM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/21 15:44), Yuwen Chen wrote:
> On Fri, 21 Nov 2025 16:32:27 +0900, Sergey Senozhatsky wrote:
> > Is "before" blk-plug based approach and "after" this new approach?
> 
> Sorry, I got the before and after mixed up.

No problem.  I wonder if the effect is more visible on larger data sets.
0.3 second sounds like a very short write.  In my VM tests I couldn't get
more than 2 inflight requests at a time, I guess because decompression
was much slower than IO.  I wonder how many inflight requests you had in
your tests.

> In addition, I also have some related questions to consult:
> 
> 1. Will page fault exceptions be delayed during the writeback processing?

I don't think our reads are blocked by writes.

> 2. Since the loop device uses a work queue to handle requests, when
> the system load is relatively high, will it have a relatively large
> impact on the latency of page fault exceptions? Is there any way to solve
> this problem?

I think page-fault latency of a written-back page is expected to be
higher, that's a trade-off that we agree on.  Off the top of my head,
I don't think we can do anything about it.

Is loop device always used as for writeback targets?

