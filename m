Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45195D46606
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E656B0088; Thu, 15 Jan 2026 12:42:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28E96B0089; Thu, 15 Jan 2026 12:42:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955C06B008A; Thu, 15 Jan 2026 12:42:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 878BF6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:42:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40E271A041D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:42:48 +0000 (UTC)
X-FDA: 84334918416.23.F95E45A
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id A63DA8000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:42:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="BKjh/WYK";
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768498966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzIg+4sDQXFup5j8N72u0s9znKRCdSZxBT6As8A61p4=;
	b=ylWmVxVSEqyVnilhLrDJvb9RbmTjTbj89RZkXGKL0T96vnHxZS+BmnpA2t/xja26Pp1Yig
	SPtaYTavBsAmqf/UrmXBzZw/0GQNyhCgx76pGfBMfsN0zEuTGMiDVx7i56jJ/2ZLCTZlY4
	T2TQkMTVhOKR52IdSP3qeulsU3wpjLk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="BKjh/WYK";
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768498966; a=rsa-sha256;
	cv=none;
	b=scUCZ5O14c95VwhLkmxRPqlMZ3icGWXdm39+hUW5HElQ3ORZbv1LvO4Rd7iU793DOSma20
	4ZAnlyppCKBz2lylgey0xiVoEaArSvDqcikV5ZB62i8N4DCoF4kchzT23zfw+QZ6bgT5rR
	SJOsyzikiniaFALS50itfXf8jj9/8x8=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8c2c36c10dbso139470185a.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768498966; x=1769103766; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qzIg+4sDQXFup5j8N72u0s9znKRCdSZxBT6As8A61p4=;
        b=BKjh/WYK9GVSItKyw6uu1vIWfXUkhmq2uuE4q5eVgvTGGmyDxUeIKjtQD2MJTsujYN
         5OrVhQexD/wvMym1ogRPXJtFHXOw41wJaG6Rv11rGb+1JnNBiAma9693wEi6OHemPxw6
         n5zDPditgaN6D2i4Y6rofViGUAtN+0u7IEaAIK94HfCsAUY4N2hpBKAeJJ1TpuSwloik
         7kr8/T1IzU/EotufP/lMMdWJ/N3ZUeOOZAjGnQtFhBNyqT41vrX5uXZIM1csPduFRExQ
         GJDNo99Gq3hfMkUQcNPWtDiYIeGLH1CoAzBgFnTtlU9KUtCFCZddyF5RHI/A4a5tKigt
         izDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498966; x=1769103766;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzIg+4sDQXFup5j8N72u0s9znKRCdSZxBT6As8A61p4=;
        b=g/qVFxMRhNLx3SQsApRkHWfnYuIEb3h3DdG1f+H+pCkBpTnJj3as5Yy5RCkwYEgu3h
         hrSNvsnWIUBHXTay2SXaBFE6fDaMz2Z3oshpw1/WQwVFeKyYB+efgIwpa6BkrmjPrKvi
         ALnLC1iHg+PSGsdQIbfOeAo9M/C7Mqi2LYwfCcSt+Ns7MShQ5yyvFnt6eewuwpNrEMA0
         +lWSaE3gWkYp/Tvv4FdZqiCWEAag8nXN5Q9n3I7yvLBJPF8y8Pxlp8sM1FY8tX4cYv7l
         VQjyFBx93UTi2J/QTolVw7qmj70ELyhWUM7HJtXJCGjkskYYJfSDt9jn/IFvCYssNJth
         yOSw==
X-Gm-Message-State: AOJu0Yxq9MpdiEWYzo0Ge9YIql74yX35b7A4JvS2MQqkY8dMVdQvpjx0
	ErM4uWqC7l1bh1oRRCICZgaTIu9j6/B+SLBJcLxWkdnKL2Toyc2tHaunWfvYGk9SIJq3XxAW/+M
	vhZFC9xs=
X-Gm-Gg: AY/fxX7nXP80DMl5KXtL4ddCmofu+l30nxpMBTNcXMmPQM9vxPe/SraNRAkk0pFelUJ
	dIEnSP81c4nHU4z26PBXTVY6YR1IcUGHzmZAbuj1WWrvZW/Ow9TS2uQNGEfBzUZm4DHbmePy5Mu
	AQ6BjZcOLeOumLyK+OTGBy+Ph03UXPlXuCsCDCgxGeEJx5Bm1PwH2xDJhWGo4cqdTwacZ5fUdKW
	6rwHzg4e34tn2/0Ytamn/xOITlSWkLNMSUvLcUHB2WHMYzmJTN5kP+xdrrRwjHElw/gLrLwIwrN
	VL4mEWovvTCnPRoGw4PvXRV7pgk+GQKORKEUyrtRaovgDF4jBmuOsTFGcX6Ixlm84oqA7sy3IGM
	8qa93vr2Xwa0kh7pdP+DbfcI25xONkZXTwfVeq9jxJP7O3oRbFWqIgU1nEMNygjlhCR4VMiOmZB
	ZFbPPWg+/W75sQ5FbPNwzNtCN2yHnrmg2tg3/xhQucWMbHQaegVQnDvNflezPCXr2Dp1jq5A==
X-Received: by 2002:a05:620a:6c0d:b0:8b2:e533:66f7 with SMTP id af79cd13be357-8c6a66da89bmr35061185a.10.1768498965430;
        Thu, 15 Jan 2026 09:42:45 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530bacb43sm463952585a.41.2026.01.15.09.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:42:44 -0800 (PST)
Date: Thu, 15 Jan 2026 12:42:11 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/5] add runtime hotplug state control
Message-ID: <aWkm8zVc9zy1w3eM@gourry-fedora-PF4VCD3F>
References: <20260114235022.3437787-1-gourry@gourry.net>
 <eb3e6ae9-d296-465f-a5a9-963da4d8ce6a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb3e6ae9-d296-465f-a5a9-963da4d8ce6a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A63DA8000C
X-Stat-Signature: 7oxge9gs91psxk6giiyua8tji4kwmf5s
X-HE-Tag: 1768498966-174792
X-HE-Meta: U2FsdGVkX192LCiH+lyurit6MPBwXFH+wFnVERtzqGuOK1kwefQFXXHmcTdOQQdqKk2PuMN3KmaurN+t0bAgDL9fR+P5CDFAm8k3la9L/T12NCrLeajlD2971yONyKdKQ4Ny6cs0thhYSTiQIcUJ03RWicrWfxSJO/8a/Qp0/PqObsNSCz3p0OsxhNOX0M7J42XxQoj8P2Gri5BZ8zuSqkcBeE5KVsIlywmXVCeLLd53tdfjAmjZNDwmypDWR+WWSEpELYx6uGMvFQv1fwnN4q7dtEkXBAwiXmPKdEWoqHwZXkjiMXSqzRryn/+LkCNhTEBPmBwRhr/xn3DjmOuas9JStLvXfm6BfXg+VWDr1CypsGs9AS0JPpZM4Ba2qqi4kF/Ep9p/OXzVCMozZ6yv9d1743W86fPvtvz3Ac3tCefvCjIWlpsLJsv7a7XqwgU7QGCVxwxfHt0+uGoAS9F+4Abdl6TO51LSvzcXwtyEgh/V1+JqzIZFOrd2vt/5HlXIev4KCASGGaBWFvaE4w35pkmhuA32t9qq4KBzm7yMku3ht61C3TOm5nQfr5Fc9CmdfL7O7GXah1g4JH4bAg7mmiyjbQ7M3DYLjmDMDHXZVUiRiYP0gjZ6qxM2kHUjMX3XqsvcCdhhes2SCYuF9tOg+hn6csNnCfsxVqgrMVpVRmvPtBN/sQotteCf0BytDzBekYiqBslOItukoDjcpcjuxoaf2sETBTqW/Lqhs9TAyrJ+s65wNat8kGc8m/fJIpPwjBqDRrzLaEEWvtwspFrXAHUFq4xt3HuWz7pZwdQl9tl3qyY6qbHqCS/MkBLFYlHTyXdgUxfbdOBPFOO8sdpWbJ/MJ7M7Ui5W7gEjwoJtdg1CNdTMOOpOj3ZDa2DMNEMp0Tis61Ip+WbcJCoTyee1rrr+jstvcXX3XLAq1NF5W9gEDeW4DI2pNf7AS8gL3qITPgU5hG4EawiDz/JLkgL
 HgEbALPh
 wyr0Tth88L0klSCKR+M6K1LNSa7xCrk/fXDAk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 06:26:21PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 00:50, Gregory Price wrote:
> > The dax kmem driver currently onlines memory automatically during
> > probe using the system's default online policy but provides no way
> > to control or query the entire region state at runtime.
> > 
> > This series adds a sysfs interface to control DAX kmem memory
> > hotplug state, and refactors the memory_hotplug paths to make it
> > possible for drivers to request an online type at hotplug time.
> 
> Gregory, slow down a bit please. I haven't even had the chance to go through
> your replies on v1.
>

Sorry, i realized your feedback on v1 showed there was just too much
complexity.  I would ignore v1 entirely at this point, this version is
significantly simpler.

> I'm currently on PTO and don't have the full day to review stuff :) And boy
> oh boy, do I have a lot of stuff in my inbox.
>
> Maybe given this is the second time the patch subject is suboptimal is
> another sign to slow down a bit? :P
> 

Apologies, and I will let this one sit.

~Gregory

