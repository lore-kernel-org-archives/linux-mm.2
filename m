Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F77CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2E18E0008; Thu, 25 Sep 2025 04:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A388E0001; Thu, 25 Sep 2025 04:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7238E0008; Thu, 25 Sep 2025 04:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C09C8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:14:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB961119BB4
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:14:08 +0000 (UTC)
X-FDA: 83927059776.06.3B39A67
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F51F1A0002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:14:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=B4DPngOS;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKrIJrMAmvpmFe/UMTQVaVONPOE5ERyyE05tx2beeU0=;
	b=La+v2NffuuYa+7FaOaAcfEDcIG07lGaJeWiwPVVihZzxTRfOPUCBlpWjn+neLL2Dft+7rv
	cXTHXPwMuWvRydz9Dek8zXLFU6rhpClZXvVviWjdbpAr/yKXj9wb4LygY6FFwYqHq41Xs/
	Nftz7JlqDKsCuzxPyrcVvmt5rlYP+iw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=B4DPngOS;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788047; a=rsa-sha256;
	cv=none;
	b=ANXeNRPwsIV3EnN4cc8RW2oC6DWrG1UMn4Bj4pZCkLY5tbHij4+yv/J3+otxtHfa4hrMB5
	SNuYDJWjlWsEI03l/Fb8nG6mOEtHs4rTXrE/X/3azDVhvSSzZSa+JUQUEtblrbALkX8taY
	iBzIvdJ0uJBRdYTbif7ktPMa/391ZBo=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so837535a12.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758788045; x=1759392845; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cKrIJrMAmvpmFe/UMTQVaVONPOE5ERyyE05tx2beeU0=;
        b=B4DPngOSqYlmtMe35b4ptuhQatxm34mDuB2eRme8K3cZWtC/+wiAef6TyeAWtXYxwQ
         v6q6dptrMYGaD4nJcj5bQSI1cXTmFU3R/76cQf4USmp91VbzitsiznebIjXUnFylEHHL
         0lgumUG+Umnls/oIsXNeXsiODG8yghORVJVd+M7k7Kk11pbIlgpHXOEl3EQn57fiF6R0
         7QMzuFWPrIuYXKPPYdIM+9R+xJEJUocqlfa56cmBQnT+boBcB++Wh+haWepsew1M4riO
         cAWOKjVaTjw/lHJFZgHBZ6uwUKLIZ+n4d2OvMoYibCbda6F780wsWeLtTh9e82+ZXEm0
         DHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758788045; x=1759392845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKrIJrMAmvpmFe/UMTQVaVONPOE5ERyyE05tx2beeU0=;
        b=Qd9mkrU8mOrl4IwJL2q1mmqYHRnTS2VhaEVMOi3iOw6t6g2ZI6KM/NEJtaGBEt6iXO
         IaNO/jNZKn54UHQnAQoGeUMd1BUt3QNRVOSCzaEJ7TmA58oLvfbsn/y8wnEmb0MrtABz
         bLm//bheGvY41keyEBsl3iqrmIWPu/AL5hq/AAXigrIEte6b6wews+WqYyKN0QLV+8JM
         3RHpcaNJCjBhNyRRO/DZsAxcq3VjTSJ7LHvn2bILvUUJ+eYqetVqaE+WsxmFIy+Sgh5r
         gmpfim3GiZoz5kEm6vtEeyrz+kyuCjfXcaMOASHaeE/igQ9iPFjCGlvmpZWA7CINkOpb
         ELuA==
X-Forwarded-Encrypted: i=1; AJvYcCVRCMVoRu7iZeDm/ga6pOHIMOz4TUEAMyvEK76Fjmdp9DmPJ1WKV1OqWfJE+QPpOd0v4yFJaXZ2dw==@kvack.org
X-Gm-Message-State: AOJu0YycdjEEDzoLA4RgSrwGmmGprhVe0pIvW0cRz8OXuiYdU1zsEwEI
	EvOyMQAMY+fE38doXHzgnQQD6XEBn7w6LGPJfhCr+/3JQuXyQ5LBYoAsv9PwiMo5Aeo=
X-Gm-Gg: ASbGncv2LO9mQts/AOa+lqip05v0+62PciNXteXtcxehz3br0QYLkU5cIfCERGq8Ld8
	Qk7rMVhyXltqw4FW4lR8svQJyMOyc+BlYKGuVnM6wx/8RT+7BlgNxvFI03CR43qAg6cIezefB1f
	KaoMvugD1s62I6TDJPM5I07pnBVUDsJdxlL59WRO+Doh0G7ttI2k2iqv6UXMaa8BOdfgNtEWtKi
	L+fmyzZ42Nc4utB6CsbKc5/T9YbgjQTImqrOx6zWM6sTwe3Wll7Vm0AcMRRclai8KC+CA5oi6OH
	YVD7tr6B+mfESzfa6YtCfH8qyssTcyva39KJRaLFsH/GnZ0QXDLROpdhrG7CM5yA8LBmgTWV8NZ
	aUQVRwPLTXYjYPnRtV4YNQewMn3dKUHv5fQ==
X-Google-Smtp-Source: AGHT+IEdevdmxqtLsa0qAquG9FJmTuf/cvAJIBd22ke2DOnxkJlwISmoE+GPHilkuCpqh3/67G7FfQ==
X-Received: by 2002:aa7:d588:0:b0:628:7716:357c with SMTP id 4fb4d7f45d1cf-6349faa99edmr1621985a12.25.1758788044916;
        Thu, 25 Sep 2025 01:14:04 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-634a3ae2ff1sm805385a12.26.2025.09.25.01.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 01:14:04 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:14:03 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Message-ID: <aNT5y8k3ZDHbQzyN@tiehlicka>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
 <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
 <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
 <aNPW4Ynrxyn23Ko8@tiehlicka>
 <81a827ce-24f7-4038-bca7-c96dc558cb38@redhat.com>
 <aNPdkABVUvJESoqm@tiehlicka>
 <d21d6cf4-404c-4a28-aab3-03974eaf806f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d21d6cf4-404c-4a28-aab3-03974eaf806f@redhat.com>
X-Rspamd-Queue-Id: 9F51F1A0002
X-Stat-Signature: ab9g375peagu4abkdkc848fwm7ddb64e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758788046-266661
X-HE-Meta: U2FsdGVkX1/wpurfiN/HNByM+tY5rznleLzSELBXelDC4q4LoskkITWIHafII4FnMOcB1D3fEHKaV1jMUThS1EC1eij6Mqdp7hMP8eCGoF0RYn37g5LxLY1KEryUpvWtN7Rag/uYhN47gvSMbmZxLkEMIsMfNTHRU8Kvwl6eFPKYU+A7euRbOxMNidf6Y8FCRABFYLj3f4JRdbz05u6cQYJ7hYUDBCbLzmvb1ffuaT+kGQILetH7wAZfa1QVdqwu23JIb3jtk2f5OhaFNSIanABTOifP2qQ8cOzXoMOeRpNNrfFxzc/5Q3CqO7Mrgj6GHxQGw3bNP4+X8mv6lrosFAKU0CtLFb/KaNoMpzBAFdPNg+O+6NX8juQ7e5k5Rhtq/ZYmk96pC+qmfWox5H319YaSqqfX7DCsYs7fdYP899ab+HYCu6W/nUx6/u8FbAhr+4MRAqg5kiJ1S9DKC00KdNmXYy5k14x0evxoylxT3R7xCZ66abFLAYh3BcK+ucWKh5CHIsk8wAsqN1Y/vsBmEDkJ+7MjIqwMrn0W9erSV0e41T26ODhK8qGUiVrV0zFj2Ptk/9mOJsvnyp6rmvgmQHWoMaJ1oq3Ulhel3XX0kZy18FMT/rK0lOouqVglBp0RWlM4Vp6ljt/kld35x3ALTN/wq7Fbqnump/TQoOqpxXHhr+A7woDx3+TIkNlHxoOPHwh2hgzv8P8xpfyVj+x51kne94Oy6TtgY33/YH6G5l4CBj4+NguiMhYQYrjYPabmyGir4V8QTHC2PepZaE/xc93uSb8FT4diUi7ZTan6YdGxpCn63tHnfjBrkvd0vWPtoRFcSxDp9mXGQJlx9/n7cFQgE7I2WQ3QtgbeYYUCXwpmj9qc+MNAqP4N+wlCe+MatEgf51QoaALvCatSQOqRaHWTzW5CrZ2JNRpjnH4gzO/U6rOtwbZk+niq5af74gqCq9Erq5H7PBVWOnRdYWJ
 lgAzfxpW
 uuPcdfNz/sw5cUymVunBA8OBmMCWrCoW3ATph0UTjdMxtz05FlzptM59ANjVC6L3Ou4fJvLaGeWujAHuBIT/+8okO1Fs0eDfOD1cd2VA3raLMJUymoH3ZJ/5wLfrX5VyKA5Kff8VlvBvxxWD/EnHbyxaj5TeChGlKZgBx9fYgi7fp0UPdGDShsfmoIEj0YccZk5+QSP80qAZ11SJZoBfHvTCRgxx4LKpdVNUKUU5KIUZAa6Omeph7y7dYpRAWdgQw4sWBuwRwzi1uq9wnGbZVt+w1/YF0Ps1Ze/MYvmP2+NdHMWBYgAv1YCSk5olx2fi8BGKm3LO9VJBaES0IcvkFMaJRMTjsfmlpeptFKQsHvUpzCI9hcOMihaK0vpXE4DE3KgtnX2A7KwcBuHVejwe6f0GrYaxjA1nvov7yUtJsQTY7TW5QyTubQ3noPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 24-09-25 14:19:37, David Hildenbrand wrote:
> On 24.09.25 14:01, Michal Hocko wrote:
[...]
> > I thought we have concluded that there is no user expecting a specific
> > alignment. Or have I misunderstood that?
> 
> We concluded that for users that don't pass in non-power-2 requests.

Ok, my misreading of the discussion then.

> hugetlb->folio_alloc_gigantic()->alloc_contig_pages_noprof() certainly
> expects a suitable alignment :)

True that.

So effectivelly there is nothing to be done here right. Those that
provide power-two requests will get what they have been getting and
those non-existent others will get whatever as we do not provide any
guarantee in that case. Maybe something we could add as a comment.

Makes sense?
-- 
Michal Hocko
SUSE Labs

