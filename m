Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0ED0CFA74F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA8D6B0032; Fri, 21 Nov 2025 04:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC29E6B007B; Fri, 21 Nov 2025 04:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF526B0088; Fri, 21 Nov 2025 04:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D34E46B0032
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:00:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 825CFB9DD1
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:00:53 +0000 (UTC)
X-FDA: 84134019186.08.1546421
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6427E8001B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:00:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XjU3gOx+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763715651;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W26CMu3AXw9oYQwfLB4phSs0rfnDFGTEIKQ3z+xXlUc=;
	b=fVhxDlpvXwM9Z7SIzMLcIs9CkPZSMAL5N3LJboQr56G530VzRfeFJ7vjk/zLhnLUC6f3nB
	sddzG+MyE5MdqDOXFB3+uclVJfiT4YhKLWpZ+1MqL0w73sglE40DjzfrJoL6S3L9h9IFS+
	XaOoxuhrLr3sPl7XQXsG18RV74aLNeY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763715651; a=rsa-sha256;
	cv=none;
	b=LdORJiGMlPy8ehof0yi2FExKtlH1gnQncPLWIgoiq8tUJF32mBNQ5Jwoob4DmISjz0+Cc4
	RD4ifyDxYqiwfzBkYZdzmOa9AsLL987OfTr7VzUMymGAK/x0/BS8R6LLCfT3NWHYS6Hgw3
	Kbsra39i+gJonMktdTiNTHxCz5VXDT8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XjU3gOx+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b75c7cb722aso263002766b.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763715650; x=1764320450; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W26CMu3AXw9oYQwfLB4phSs0rfnDFGTEIKQ3z+xXlUc=;
        b=XjU3gOx+h5i8oZgWXs3sD6loboOUYSZKyVNOYiQ0ETbfcDnWgXBqXkJSCZlhHkzQ6+
         dAbFbMvwMM9Oxc8QCtDvtG+meDJgMIkbcZnnU2p5tshMrivmN4i48loGLatiCPm/ju/S
         jMvzz3u753X4HLCp1+RdSudO+0sE4B6y6LrGp8hH5aRvW3DwLngZk3+e0aAxPhY/uqt5
         uj1jwSTd7HGyR/ZP/bx3X6PmEQUjWCuDWkkSHPn1+Gzj8URsdNiUiuaJt4qWYImVP/QU
         37GS+v/BQFDNhcVKVDpOzGykfACiqde+HvqEhg/GGoApEaR0lc+g+4kU2h/HZvEvPDET
         d4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763715650; x=1764320450;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W26CMu3AXw9oYQwfLB4phSs0rfnDFGTEIKQ3z+xXlUc=;
        b=Ur+LcUYCizhHM0uoT6LBhXDkzP9deKLTiqq5cHg1b/b2SExEGS1/xblUxc757b/Mt9
         zL+4Q817qZmApDpyfwelMTlf8Ior8VCIq2d2rqfLw9K9Ng2qNEDOImZ17Z6GUOVxLGy8
         31GWEqzjjGJjqDRK+tB8LXGW/ezkiWVtJWEFfqEuzpT6AVsx0n6iWDB9Bhos1vQO+fwc
         gVco7816Tm0Dnez6SdPUoBorsVa+6IlDaPb12Hj+JyYGE4WBe/wphipbEOXGn1AHoqoq
         e3zCylqKngxKAON/bNpMLakl8ONPs6ncQG875DondB/3+FkfIm1wQXjHVG+O7DG8dh9K
         o+lQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjd/U86i3DqQFWRg2dqzLaYEdkkTeLZSldQ8VNuZ4B/8Cng1Hc4IBj7kfzZ8CQ/2wGxKWrflmbSg==@kvack.org
X-Gm-Message-State: AOJu0YwWUBEhEHN8QyjDjJZqmqUQ32u3z6Do2UbNi9wMJoi5CNLp53X3
	R8yMlNuAUc3mpMnpmXrHmuA8uvvOYkl421bB82sy66UsaRIARorV7RUN
X-Gm-Gg: ASbGncu0HcvFUjOym5FPk0K63bZZIR5aQ7icK2WYeWkebSuZrRyQJu5UiKYkPEW8jDJ
	jGzE/b9gOuYsyKwvGOAFqAxyogPOJB4wkYFEn6mM/JjV77wlpL0AKb1zypEu+Necy3E71lNdzQv
	iPNxSV+kK0FW1E12AbOEk/qCwVP//IDxNbdoNhNNGSBlMvuh80QCVkVPyGKeTD9ESzvs+Wton3C
	u8Jh7b/Qj/HRfJjbgeqdVY2cpBLn0hBvbsoRhioxc/m32mWnYDCiJZ9wjzSv70vEoiw5KMST1a7
	yfHejdrcoR5C0qyJIVipeob0k4pdSGVN3KDSSaOfl/pfmpcXCkFbe66Bq3kcjDZbl7reL013XMc
	hNhHTr15cgopmazAFrmmdhc5KUPBehfZvQp2oBnxYIvxK4a0F4h71rCTSoQoBlvq/TBYdNkmNho
	jsEk/toqpNFb3W6A==
X-Google-Smtp-Source: AGHT+IFeCLe3rY6BQZZW5xr9trl3OV0DU2ys8532NU2n8eWdQI+RLYoGBV2NKgCCXpf7SHAghSWXVg==
X-Received: by 2002:a17:907:3f9d:b0:b6d:5b4d:7277 with SMTP id a640c23a62f3a-b767127d919mr130611266b.0.1763715649473;
        Fri, 21 Nov 2025 01:00:49 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7655050d05sm402601866b.70.2025.11.21.01.00.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Nov 2025 01:00:48 -0800 (PST)
Date: Fri, 21 Nov 2025 09:00:48 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251121090048.3n25tjhusu45xpoo@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
 <20251118033339.7rukw7vvjvlbj5jb@master>
 <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
 <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
 <2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
 <20251118140658.9078de6aab719b2308996387@linux-foundation.org>
 <20251119005248.ddlbhokgjdmlkhkr@master>
 <20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: zzh5j31q3cm5c5bdxdunp8xdex4gm8q7
X-Rspam-User: 
X-Rspamd-Queue-Id: 6427E8001B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763715651-237729
X-HE-Meta: U2FsdGVkX1/EZJ7AK22TPFaDDmF2dwpURSHml9uNqfP2jDGptthYZERL3HE7q8KHCay4tNTli22x9oFwjIBlpS97XxSAfeWucPn5CYGitmbQHPzWuvfOECU3e/oJ/2COt0dHFiykMZc1rlWCOtn60qd/efzSFtlwSeIKKGME18vNXWyJuap8DlMu3Ooi35Wye7ATvAVDd0Bi3i08mjC9HCu2c9aHafGo5YgF9sNAcHaCkno4tON6Yl/xUFf8IhgWyu758BJW1O56T2/1G9kNHQUreqd8RimuDTdfZPtzRwElqttB78yXXFmoUtxwosFsmDPXxRWYlrnKJ4OYjG8hmLTfqKYTCQ/1lGNt9aNWOXqLqzFGSm0ngHuyO11KzkS+zttYGatBbD/C7b+qHEWqkjr0ckanSoBEJ0xaaNjhe9Kn+b4m6GvQAc47nN4lSiILM91njPTWhth1wQBMJglA1+sRjWCrQa36uXZu4Gy+kbZ/gFo/8LhCRRT5AxRZijtoIxMB1xiJjwQSjA5gS1RWRU3vB9PGAl+jx/9I3c6f7hipDuYVRrUnel9qco0TXhGdq0Cfjegk4h9g8vE+ohrmw2yG2ZJFXLhuIFaDFcE1crGhNfQFQF79TTS8DINhoXc0oyWd0WqwUffRbaI9xxQhl3gj3pnPExtoXWydqb+T5KWE00AtWWV8oIRgR3QQUTOGAIU5y/LwtlPZ+sxo81SavujhRbFk4leJf59JPRTF01We0glvsqRFHo8xPgcfc7dQW+MIrv8SAXoHBNXPKwn78QwhtdjyxaO8cLGlZCzyGcEH6L4nGwL+k62tNUQkvH9STQES7c5wv6XewlsWSL4K3QQXgCZ2gfvUVeqc0nVfcoOxT5n0BexQFa9VY73aTPOE5RZ3fDIGlw+2W9Bh4ERuqyyU2vR1Rr/ESluvl3+PcC91WfbHsqJhSiyvEedJXr1mmegb6WIJXZPSqcsKK84
 0v4v3sbT
 nYZE6/8tK1aZLWYjV+QGGh+k+z2sunLv25j5a2v8aTD/HUXP/3rHsAJGY/xlEHTz1azJhu3hpjGjl0lM8Y5bBhbld+eUItIe4kM/pMqoUL7NYTqnzLH4WvnBT3PfsZEPFeO/VzWx6DepmmVaSbaOQ8RlSFIUaYQuP8Pc78YYXPqKsLz3hK5PxB6eIMZaj6Xua9U0hnMzWRtsOahexDcJqJAXLDIHYR/xCq9gEHUx6iVM3oGw+WHUo0z+PLURYmXHiDALYvisoRlW4OJ7T5p8RxxulvVGirY6qhj0vFc7FHwT5Ri9fMFUVlhi15MOtefav2/RDs1M1GzMt1VYdCLo9O6AqMvBrjk4n+tyL2OzfdBn+fWwjjiB80yIIl77S3yW++3PpzKGle6OEjMjPmYqXxlM6mAHIdGFgJN9W17M/AkAeGhEpWHhxYPJhDrqf01hOwhbgaeX/ScnvEFJ1H5DOKw0wnbqhwyPnlTSOsnRBK9tiebdLv4VN5APObqcfOsSlRKtfGV2cPJXSBUqrTlUbH2rPKmxCoc2EgeA6DRbLj5CtCkfYltcrSXjDKWCvt1eyI4VxxM+acPhucID9FedOJZXRu5C/LyPkO1/cKaONBNaiMQQBhNr7RGe4wW8QvLaCHPlUgmi4HsYi09YziwhltTT2/r9MuyFjxE4t5Y7gaTE0N5JDqdR5tZ/pOvnuZP7sm+OkM5ZivQTiT2YqcYbZPvm3Nm6JBRu4kye5uysLsSVAc6YVaLdI6lQ01Jglz2bBJfpx5Pn/GQY2/DevBz1a7QS2cnWL915ksKbP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 01:16:21PM -0800, Andrew Morton wrote:
>On Wed, 19 Nov 2025 00:52:48 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> >> Hi Andrew,
>> >> 
>> >> This patch does not fix the NULL dereferencing issue yet. Wei is going to
>> >> 1. send a patch to fix the bug on top of mm-stable,
>> >> 2. resend this patchset on top of the fix in 1.
>> >> 
>> >> This might be easier for back porting the fix. Maybe you can drop this series
>> >> for now.
>> >> 
>> >> Wei, do you agree?
>> >
>> >Dropping this series messes up later patches.  I could of course redo
>> >things but would prefer a fixed up version of this patchset asap, please.
>> 
>> Ok, i will prepare a fixed on top of this.
>
>Did this happen?
>
>I remain unclear on the status of this small series.  Issues which I
>have flagged are:
>
>https://lkml.kernel.org/r/20251118021047.uyldr7aay6fb5evt@master
>https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com
>https://lkml.kernel.org/r/20251117012239.lqm33uu4vl4y5zqc@master
>https://lkml.kernel.org/r/337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com
>

There are two related topic:

1. A null pointer dereference bug:

    https://lkml.kernel.org/r/20251118021047.uyldr7aay6fb5evt@master
    https://lkml.kernel.org/r/20251117012239.lqm33uu4vl4y5zqc@master
    https://lkml.kernel.org/r/337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com

This three mail are related to the bug, which is fixed in :

    http://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com

Currently looks good, and will do backport when necessary.

2. A further cleanup attempt:

    https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com

This one is the related mail.

I proposed one version in 

    http://lkml.kernel.org/r/20251114075703.10434-1-richard.weiyang@gmail.com

But it is not proper, will do follow up work later.

>and a couple of comments from yourself indicating that updates are
>required.
>
>Have all these things now been addressed?

Hope it is clear now :-)

-- 
Wei Yang
Help you, Help me

