Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB91CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF7D8E0022; Thu, 21 Aug 2025 15:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590208E0001; Thu, 21 Aug 2025 15:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6378E0022; Thu, 21 Aug 2025 15:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0DB8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:18:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3088138A5C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:18:05 +0000 (UTC)
X-FDA: 83801724930.09.0724FD3
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5F06C0005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:18:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f+vzXQl/";
	spf=pass (imf10.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755803883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIUfadtyrX+885VNIhzlz6298Jbid8a7B3cqJAhGNyw=;
	b=uVz7ZIHRJSdUp1vTzIUaMIpItO1fEqjSW1ksmEaxBS1BNWWoo1TOiCi68k4Dk91wHyvsnE
	ZApEYEHp0fd9CQ1ODXursMgsnsyGkgKZblVr9D55iWhl73Ky0XzLCpUKEGRi6vk/CBsjz6
	37hMNbrurW6ABWZXM2KShSg2/iXQYnw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f+vzXQl/";
	spf=pass (imf10.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755803883; a=rsa-sha256;
	cv=none;
	b=QFK+h7/w+vUhswWY2DiUZc3/+Hi3xJVaze56rgSwe2Zzi811SR2Fwqh2GvE8lkpUMRnWus
	vUv26ShxEqJp7BBlSAYMbBF44QfsBMEnwZm8EdUqHLWiXh+svwfhRibPgj5Ccv77LxrQpm
	66oETGJgJQnM3XK4W9BFXi5vBQOACOs=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3c43399ea42so959316f8f.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755803882; x=1756408682; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OIUfadtyrX+885VNIhzlz6298Jbid8a7B3cqJAhGNyw=;
        b=f+vzXQl/WvY1+ZR66rbGNmqRxlb6ZNQAfvAt7j6T66Gep2ep4Et5EM2lwY/WNC9SB7
         o/zTqvHfWa2Lu8mpSBKsS0kX/c55O5jNS21GPseObRYdhhxP1PvLx8RhBbaw2Cn5oW3t
         CR/dxkG9Kzg7He6Atk9G2pj57EwZa4qk4rFn2VEfQTpbpapE7D1RLm6v7m6oV3TL13FY
         205HTDCuzpzNZ6kYvvQ3N+P1nim5vBlN/ot755UzGJTftCJknKkQBw0ODGv1xJflEDZD
         P4CYFM38c1QNqZPbtmMOYQ9zkEd+H/I8UNzhujZlPdoqoChLly1qDt5UYii1zHkHWAfL
         wLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755803882; x=1756408682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OIUfadtyrX+885VNIhzlz6298Jbid8a7B3cqJAhGNyw=;
        b=ZleBmzHQkms/W1IIWwpLg1SDSIIHy2AC0HrWRsk7dqjYPZwLARU2XUcIysDd59JR3u
         Bz/j6jYggr8tNKTvuXX3Ckq51N7d/78q32SNdd4585W2aCCNKejQPTrU3HTgS7NiEDjs
         2pwJHakiFtmhriPQfUAmtNcx6JVDF5xmJmyYXacYUgOiEbT/P4gdgtaEYrJ09dXcCflY
         JPOG0klrSWrAyC48hHFUr78sHsc12bQ2KfhDm6bEdk5MJmaNNipfCuaIIPhozsF7lcCF
         tuOXwKPkIkd+bJ09v1lCcMEP1vKgk+FavZU9zjrlFDofomiMkEsOA8fhlVxjEf0lcu8/
         eRag==
X-Forwarded-Encrypted: i=1; AJvYcCUITnXPfIXTlPM0BNUMpM5VBoexH7Yusi0jAoX2sElFcuTr8eYFK/cKGukLD39WAtigWwfEKXGLng==@kvack.org
X-Gm-Message-State: AOJu0YwIsvPRL3TQ9gbgM2K4a3dJJisHLokE2AO7XUqtmf1YD13wLBP6
	R4NeL3Qf90vcdvHRnhHZJ24/JFs4Rah45RmcJvx7FY2kqBK+fnSRWHXw
X-Gm-Gg: ASbGnct19NQWU7oPoKWCc1fuIUTn12cg0c+2foSf5PcnoOFrqm1Q3ktxM5bFVky41ci
	vy99Bhs3W+Cbpeu6KECVfKlrGVovy/bM54e/unbS4UhGqhajEV8RLDLhOsAh13acoC5bEIwKbLj
	XcWWnXr+UIFprMnQEm5RayZEJG4oexAZtr12PUU/ztQYihrXoiN4lm5E8LoRxDh46Tpsx/IS51Q
	pYlNVOKF3gjh7PansJRpPerHWatbBrRQWYwxhrsJ828JUsPPyB4v567kD/qLdU7mOO1OATKWcFJ
	AsOuSgENggc8P0ta5Itx7/OouC3PSxnKT95mVaRzdx4vGyxzOK09iuLcZXoPiTg8FMIMcfYSnTH
	p+j4obz8VCPbPX+Hg4+HBPPyIHDZc/opABX+x2Ro=
X-Google-Smtp-Source: AGHT+IHjaDlr+iR209Oc/z6JbUmzDrJHC9V+eZOuu4bHyOSAYWtRWU7bYzUgOQc1ufCzQDegRKL3yA==
X-Received: by 2002:a5d:64cf:0:b0:3c4:39cc:366 with SMTP id ffacd0b85a97d-3c5daa292d1mr128606f8f.15.1755803882226;
        Thu, 21 Aug 2025 12:18:02 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:4e::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077789d1dsm12574809f8f.49.2025.08.21.12.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 12:18:01 -0700 (PDT)
Date: Thu, 21 Aug 2025 12:18:00 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
X-Rspamd-Queue-Id: D5F06C0005
X-Rspam-User: 
X-Stat-Signature: oepta4m5sa1bicixbgssmfham66y9hhf
X-Rspamd-Server: rspam09
X-HE-Tag: 1755803883-286774
X-HE-Meta: U2FsdGVkX1/A9+KWwQOxCSdAhkVoc03eLgzb8S/9xGQ4t+P7NsoWEq3rOUohBosCnP3ekdj0xadkw0GvX4OeWBSxlMxdy3PC5YVGCZTHyLgGAQnOxNG9CXoQoFzNGv3vTmF7bCp5Vg+HBEsU3qwvDefph5l7x4H9CX8CghZw4kuy+WgIHRd9SgWSepLrK6CNaNNQFHtjsaea6HGQ8+54v8LTJyl2s1movgodcA8zL+84Japx8z3fB+mkCXL0OJq9NrWkzKPYb1fARTlMpm65OIW0NzW2Jc0wQJOjh/vB5zMZRiKB1JH6UukReM+hrNvPrcQJoORJLKQNOyUpO6DgnaGFRc7VvRN5gi+gxkgPyJ0Xh8rmzNqoIDs4z0KaaYjqAaFPZviVtqo6J6D+V+0mrYYqwVV/p7VXwX1CrpPNZJSF1a9nrC36/uJ0F44lbGL1L4o595v/zkWx1UQBXcP6M7zKOpWBcT+Qg0BtevpJy39INZjyO+KkjOlMQy10OSN3hTBOenHqvebVfPEkWNmgjVqvj+wnJ/XNSR9aOH4HQ0lm8uJDFKJs2Dqb7/4q3cTjyi6/L7WTla1jCjfo19M5q28NhIhPYcGPI1RzLhbawP7/+ce+IUVXR3uySANKro62pES2sQtDOvsnWX60sl4hJ/BqACBdMMc2koKIRq2xpBLE2gblwtw7crrfkG8p9hvRXGgIvw+hW4jfNpImBg9FdXOCyaLbEJTzUgtANkFWtW0450hhhIvbMENL5XZ6ZaKLONLT2dhGLLRNhp0Bf2zFD5a2Ia2GG3W8682LNkQA4nQmGlRgg39cvFVBGOPNTP9obnxgX0z/AnJ3eEkuvGFxFxEcxCE7zJzVWdG8/lhVGyETSmU/Qi1EOg/OVw+SkhxQpHL1qAVE2uBndHCokT5LgavIeagrK+xc+Jjhw6FrF9jfyCcv6CoOYIUGznUG/meZ9ZuOpmP/s7t/glyiSUW
 G7BXw1TU
 OT0e0HaGveCd3YokM6hVcYSCpVjMWCoNvMcMiW83g5nXlBRPqj/35Zlxy5IK/qI7mudG80VwgimdO2moT3TAaXlvckJ1dZSHwgoygcQDEkvGyf1UIWUpT+RVHf6SHQrgPaKeTRrGVfrrZF8DPtTxZIOgWWn3VlXfBwdNMPkuY+Byt8m7hcZPiTYY/55LY/tjeQD8XNRnX6DdOE5uRflagI4tKqx0ISEpvC3H+uQsBR56d2uJRnQKeDqD9WEjTzl6kKMqHsZnY+TY7tlE4oW1LPU+w6/31w5nje7AkrXg7vIB0b0dZbryPPrZZzNDW7JrxLdPkS96YTaqoDsKAFY2ka69tLyl8R+UFmmO0DIn/8fQ4nwIk00rlIaUMaHi1Db9Wp5klNUgOLZZVG2pEi03BS5bgQSHjN8QLTQjv3PQHFtGFT3/hSVK848SJ/USK10D2emCIMIu9n0Z+aHQpYUffusepyj1rLGtA6JZ88ft89xxV/WQ+qFWaYcqozw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > Right now in the oom_kill_process if the oom is because of the cgroup 
> > limit, we won't get memory allocation infomation. In some cases, we 
> > can have a large cgroup workload running which dominates the machine. 
> > The reason using cgroup is to leave some resource for system. When this 
> > cgroup is killed, we would also like to have some memory allocation 
> > information for the whole server as well. This is reason behind this 
> > mini change. Is it an acceptable thing to do? Will it be too much 
> > information for people? I am happy with any suggestions!
> 
> For a single patch, it is better to have all the context in the patch
> and there is no need for cover letter.

Thanks for your suggestion Shakeel! I will change this in the next version.

> 
> What exact information you want on the memcg oom that will be helpful
> for the users in general? You mentioned memory allocation information,
> can you please elaborate a bit more.
> 

As in my reply to Suren, I was thinking the system-wide memory usage info 
provided by show_free_pages and memory allocation profiling info can help 
us debug cgoom by comparing them with historical data. What is your take on 
this?

Thanks,
Pan

