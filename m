Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A02DECD6C1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB45A6B008A; Wed, 11 Feb 2026 11:38:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62A96B008C; Wed, 11 Feb 2026 11:38:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A616B0092; Wed, 11 Feb 2026 11:38:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6606B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:38:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1372058EDF
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:38:53 +0000 (UTC)
X-FDA: 84432734946.19.FF68EC7
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id F051640004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:38:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZvO8RgoH;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770827931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0jBOVRTgFoZvFipnRn5zFhtmX70ZXn6LNFpcY6w9QM=;
	b=N3UcbT+uS3UJhrcINzzHbGqp1tmCa8LSGnFmPt+yAKn9MpDg81PWvH6a09i1D10J8HRykb
	kmlfL9Fr1eIfBdMawFRQsUfcvxvRfNQhBPHhXdIcJw4hYxRGuJLzftjxSIzGupkzyvro9O
	t/BZSCmssbmbHnxhiW0UCqUXM0IMaos=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZvO8RgoH;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770827931; a=rsa-sha256;
	cv=none;
	b=OrRjiVzXD72KAitJMhXWbGSfiba6EQMhniI//V/cWhYSJiDNcmfguZLr5+ZoKIFczcgGvZ
	lO3iEdYvrd13W+T1CQsh0Im80xBbrhbLd36dN98VReHOLhYnU5BC79x/uV6iM+PLcfycMk
	27r8j1XDHZx8uFhuFeuoTgGx2Y9OCVw=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47ee0291921so53669015e9.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770827929; x=1771432729; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i0jBOVRTgFoZvFipnRn5zFhtmX70ZXn6LNFpcY6w9QM=;
        b=ZvO8RgoHITA4cUrYsh9HBVsUjbqldtU6dZ0sWkKpzb9xbhZhHn5J8A+TtAqMhnfiOJ
         iixjGAzSDmHKQlW6s567Mn69CC9UFXGrGP7Tl3PUtqIEEKKppJo0qUA2vrYieIdgCTE5
         rh0lho8rwUegeyu3xcgWlwrvASNFV1AkXhmGNw/grSTxT/nMTKCbK8fEIKArniyu1Ft0
         pt4VpkNm7A0YT0e+eUrwMlUIxdR2Doe2EQn7gq50FQvwcpQwl4mZQCkpSlVHj9WXrifo
         GwE2LaXreKr24y1O1pYG3a34E022V1zNURoFPJHY1VxIn9Slo+/a9qrWy4fhHlolPE+a
         +ZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770827929; x=1771432729;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0jBOVRTgFoZvFipnRn5zFhtmX70ZXn6LNFpcY6w9QM=;
        b=ZhaH+r7H/S3OVV0itEIAoMLgvgLVBWl8Z6ojM6P25pTShaZV3JxWnzWsdvNqa6jGEG
         DhCANDOWwMw9wVhntvutGd3nhQyWOsx6sqEFs1iHUoWPCnsGLMmrwFGGmA9Gfp2GjEBQ
         P61Jo6sKa3PXW+olTEiPKDnn3VmusAQkHqG4hiZQHBZABg7R1aGm5Pe9WwiA4PrPh5jY
         7TIfwsnr58WvflE5ThbAIqPDyaIOMjLshGkOLbfuXMCb3gvc9XBCLqyDmpNmo6/5n31v
         RICu7B2LMZlRP1/0lj4ovHk1NaQ71K6nXKdnTr80IFnOe+xrDybz7DWDXetBzltVOMsn
         1sLA==
X-Forwarded-Encrypted: i=1; AJvYcCVdFNGkMLn1+KSn4spDOCua93XsRFMQIBZ/p+BZtyiFGCSNJc9K7LNMC/OTExMVTOWuEN9ZoxTeMg==@kvack.org
X-Gm-Message-State: AOJu0YwyCg3uDO3vb5Tz2NYXtR6EE7YEu5bFfiBhJwKNl9ADzzPqFh6w
	gypuFy/q6m95vtrx5IAK1yV9AotCR9IVAOTGUzVsDhN5MroRjRi8oDhD0EX6s6tzcHY=
X-Gm-Gg: AZuq6aLU8DF8TWcai9Sro4Ic0VkbNuBhNDM1SbaoegaZ7sKamftYS8MYDDViwgDhNL4
	ki6EP3Vjw17vmZDUwVS+LihqSSHh47/Zs6gnTqwlWoS0AWdbX0EOvf+1YVqusH+fkWeNB1E1N4v
	AewXvWquL1ZiUGitmp7/MOLu7amyogiBlDdGM5FTDR5KLb1f+ZeZegwvAEDQ+wb95L/mso704Gk
	pc7SkisC1H14MpPaJuuQdfYEOTBdM/spLCaf38y7593wnpWpU/04etIQL8VDFryj7kNju9O/CdI
	HQSf7yF3xCYCUnwHL5moOhUsGuKUvRaBLwgXPrH1Yh+Qkia+FSWTpR8cT/hB8qWWo2qjZsGMkCJ
	Kv+tdcNEh+LvkDKUe2zdR7ocaMGwwg6ULgtBQSMYJZ6JAxWtDt2OBKmV35vidO2S35g1wFCaEQY
	hP7jD5U+UzM6vQr1h43fLCliYxZc+QK3ZKyP03
X-Received: by 2002:a05:600c:a4f:b0:480:4b5d:9ec with SMTP id 5b1f17b1804b1-4835b947ce1mr36415155e9.33.1770827929279;
        Wed, 11 Feb 2026 08:38:49 -0800 (PST)
Received: from localhost (109-81-83-241.rct.o2.cz. [109.81.83.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835a5bf1efsm47887645e9.0.2026.02.11.08.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 08:38:48 -0800 (PST)
Date: Wed, 11 Feb 2026 17:38:47 +0100
From: Michal Hocko <mhocko@suse.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aYywl1hdBQP2_slo@tiehlicka>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYxviLoWsrLqDU7o@tpad>
X-Stat-Signature: 6m51a7qkkz14y1qpg8w9mhu1kyxsuxuy
X-Rspamd-Queue-Id: F051640004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770827930-23006
X-HE-Meta: U2FsdGVkX1978b/Ne6bvMlzshl8wLrTKTVotZmrU0P47R2O0JAvIpC0BL7o7NHpk/LZ8p0a2fOv664nx6nIq5WoOb7kG2WrU//KroyRofiNk3T9+/KkrnJKdS7skE9go34+Q1V7NCtfRcp5IPcRrM8giBmLZrNUmktXAySm4pDw6tv5wsRi/1lhXBB4HSnCEDNUV9AewnGli5uL3aF4Hyjbl3dFLbvq2uY3HV6JWHEh/VkzLykZSJ/vS1auTV6GGHiSIf3hHyN+9VGawpamGHJSJqDVQyTM0affn8aU2UDwJgCRHlIFKWG7VNpZron+U/Cl6agQkGUS9CkaXTKRNiyXKbDzewdp09QEcSb+PX4kGHxKaO+LnrTYBEIMLQ+7O/lX+UK2D1BvS+TnqxZtkw4M2+wkGSwAcJY/lTTR2xym0//vKOOmEolI6aIrRADVJj25T4qpLw/hY5249fbydf/KdEXeQo3zzECzvt1Fd2qabPLLcEoVbqAeElUJK7kQdK/rhtjgDt67tAgvvPpweCRvJGQw/wrzjlJTRDwltbGpquBVG1LsjXwyrd4GwYloUMqPK3EfJw7KaYLMArAKLjp8UBIwIYMGzPMmCHOX6UHXDz8Mk9MSF1LPry0A8qlXOfZovo5WyhJPYRC2sPE8/eRnv+fTliWyKFP1ARRST9lBimIqREy4hmyIea5wZ42mK3zf7ziMl6iIQncoGkX4TqnoF9EJNglzLUzIEvnYzzmBc7Iw3DhPgJU3I/QdIX6TrSJgGgtqyVbK+q7sGFi/1CCWSODS6vq7mhgw5/x1KAqB2/vWKFlBanVbX+zy6RihWZgTCmMBr6YCN9iKTb2EwmOW3ur+2vKIJRw33640F4aQCPTYXRr2KvycQzgmKPIFe5hd+qdQ0pKmjuS+spw6anvC7z+5LZ0ZPupiAN+dTsyeHi5izKJyZoZ0UmTG2rjhxVrDCUe2PrV+psDrjSJu
 nbnN40Tt
 2E2XmpPmOO50jKgYz4rZ53Z3on2F9iX61O3mucbKuIbwC7aZu2dW6qgUc37fXTSgRC/XGfnd1X60TqT8RiL61c/T1JCaYsPa+mqtYkhtn4F54ZLTGIX7f9gTE9Wl2+jL3r0K31Y/4FiNJvsAk5VzTLCXNYKP2bhwpnLDEMPNTnS9Hiqlp6WDJ7D+f2B7Cyc1Zzqoig3WH+0pDYSzdoUr4hPeYWGAgIdxu57KwqvBj/u+x98IpZGkGNetg9eEuGxlJCxALh22TQ8u6jNY8NZ1no5anMddAwnWgGVIBjQbi0NRPdChnpyz7RNwP8u8AiHPvqY6k7qRULjsCxrE5DB3DE2TxPDdz4Unw80LZwlGk6X2/WtFo0X0OqRrnz40XEttR6YBMy8rIiqalTJlBDFxHsScfLoVrCp2zl5wahLWqwVTAdUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
[...]
> > What about !PREEMPT_RT? We have people running isolated workloads and
> > these sorts of pcp disruptions are really unwelcome as well. They do not
> > have requirements as strong as RT workloads but the underlying
> > fundamental problem is the same. Frederic (now CCed) is working on
> > moving those pcp book keeping activities to be executed to the return to
> > the userspace which should be taking care of both RT and non-RT
> > configurations AFAICS.
> 
> Michal,
> 
> For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> boot option qpw=y/n, which controls whether the behaviour will be
> similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).

My bad. I've misread the config space of this.

> If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> (and remote work via work_queue) is used.
> 
> What "pcp book keeping activities" you refer to ? I don't see how
> moving certain activities that happen under SLUB or LRU spinlocks
> to happen before return to userspace changes things related 
> to avoidance of CPU interruption ?

Essentially delayed operations like pcp state flushing happens on return
to the userspace on isolated CPUs. No locking changes are required as
the work is still per-cpu.

In other words the approach Frederic is working on is to not change the
locking of pcp delayed work but instead move that work into well defined
place - i.e. return to the userspace.

Btw. have you measure the impact of preempt_disbale -> spinlock on hot
paths like SLUB sheeves?
-- 
Michal Hocko
SUSE Labs

