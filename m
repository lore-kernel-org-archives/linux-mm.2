Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97627C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82D916B00FB; Thu, 16 Jul 2026 10:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803FA6B00FC; Thu, 16 Jul 2026 10:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C666B00FD; Thu, 16 Jul 2026 10:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43C2D6B00FB
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:55:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C07B11201D9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:55:42 +0000 (UTC)
X-FDA: 84994938924.21.3DC1B19
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF6A5140008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:55:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qw7DCSn1;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldlKJTt83OroR2A75ml0k59gQsXf+w2G0f8AwORm5GQ=;
	b=enEgetjCJxx5trDJ0SfROUGdxxctynKX9pPnRZkXPkOLo8UI/7qaQSV4pRw7+DuAI+XP0s
	MIyOi0CPLz+6tVimUpjy8mKNbrlj6bSk2F4EVqQFKsJ1amFHH/YlIkkpC84AVTrs+k9Mhu
	CLRMj8vJ1far3ks+DE4R46TuGTLpPvw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qw7DCSn1;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213741;
	b=hn6+1TH/5SkEZ1vCWQYCHElkrJyHt2VRx7BSYHKJeD+/DgsMQJbe0BrtVnBiXt6TXxbQ1q
	p+CiG6cahBeyAEYC6Kf2Hg5zMMhq9Dj2BP7o5hwyUbmEK1psv7RZRYnycmyjq/OeoLO0D1
	KWY42eDaTQF15FLx6Ybc1h7eaVIFChY=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-81e86df8987so6850957b3.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 07:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784213740; x=1784818540; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ldlKJTt83OroR2A75ml0k59gQsXf+w2G0f8AwORm5GQ=;
        b=Qw7DCSn1o2SQ2WZVDKhwwOqRWkUGTtztMXopAUprMHwGg8L4E5Ae5NY1wkoyBnE3+S
         XaobbM2Oq6Oj4Oj8zv16MjapCF9AF0tZTT9gC1BfULG4uPE725w2P0ZYVDXocVTkl/j5
         +oVQ0NJArg800s0UCxybWZ81QQRPBvXIdMwZ3zwx9slpETCoNnA4rkDqDVbQSzFlzOMu
         qyKWqsTsGYvV3aQ40tNHbCYSwb07oIDMwlhMnObjbmCNMhIvkxXGfgFT3T/ijZtIzD4E
         DMOLKamZdU9fjZY8YuTm0JDsawbpmI9wM3AXPLXdMPSOJhXozvMn+eTuPqwuAB8khXaa
         VkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784213740; x=1784818540;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ldlKJTt83OroR2A75ml0k59gQsXf+w2G0f8AwORm5GQ=;
        b=hr8RgwmhLrzc0CKV53vQCLCsZ8+vW30l8i3VilCDpjsRTzibF7uPBv3ACrjzxVeSWR
         0CkBGhdax+F9kfC2TSVmn3sqQ0iHZFxnyByM6cgfmP89A8BFv210UHdre/OQMSFbaiy+
         GAwdCiKA7p3ewIylphY19/7RM/AuJ1/3H50CykiA7yuSLbcTh6DDn5KeHsRM98f2HqgU
         XYbizTtvAymq5lx6/0LbLhUJdFli/1Dsdj3im+OtzQKVRKwY1FTZkzkvpLAm/bohQEJS
         N55hwfNNUO0huJvaBayCLQfG89WH35uNYBogKTVRxoTLSdVXcnrL72r3vJsotSfVcDI4
         NG6w==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Fc1kniDCCJlJYTdeuIqMt3VgvboPyscuVbliXSK4KaARitrkCNDsoFH+3hPhbqN/K0Gww13xig==@kvack.org
X-Gm-Message-State: AOJu0YwmJ3T6g2oPw53O4yMbkYL++NHOg56Fm41UUK8B5MAIJvh3Ykuh
	i1Y9lyUEH62ihHe92P5j3sSXW6Ur8veuQIVoAZHiMfPyVmJyOe8vGVSxZu6sQTu2AI4=
X-Gm-Gg: AfdE7ckCmZiGJfQzc8Q2TYLbU2OFeB0WORdRWiTw1zdL5hIHHPQXP7oqnL+YFxMqSKx
	3dF16IMBq2FWGZQ46fzLqR9E09RMHSqhjy1J1ZoDie4ecklAHTp7cioE/ngvt+wY8aFewrZWOBs
	i2bp0+yGQqqsnDlONjhps+2/OhUzCAvENNkqOqbRHZsW+puphaj9SGk8P8w9Pjmf20y1kIom24V
	COPei2X7U2Odl5e2mVhAVr4zD6Ny+sAgq1LqjwV+jfxGVqaEWTdwWr3m9/9x4j5TUWc5SJqk1E5
	9lFaQkdt/ZGKatUkZEGmDIr90Xf2PlDK+kDakE3z3Xu/AyQJe+SzLAoj0SHw4p9aDWKmbN/U3Zp
	YpML8w/Dc79WP1kMWQRxqwssXnDfSYQ2zKI23umFrK6eUKcgx4qn+aDzadVHZrgYq8vLOjuSDRy
	P0h/8cbq9WHPGSOe631jPT5S5lTlvQhSexYHh/66IcuPsQfwTH1scz9QWjaAKkOnwPPq4nRn6So
	2aA9nGNU/F2
X-Received: by 2002:a05:690c:688e:b0:81d:ff0a:2cfe with SMTP id 00721157ae682-81ecf776a35mr56530767b3.8.1784213739802;
        Thu, 16 Jul 2026 07:55:39 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ed77e8ca7sm35824487b3.1.2026.07.16.07.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 07:55:39 -0700 (PDT)
Date: Thu, 16 Jul 2026 10:55:38 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Sagi Shahar <sagis@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	"Andersen, Tycho" <Tycho.Andersen@amd.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"Heyne, Maximillian" <mheyne@amazon.de>,
	James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Praveen Kumar <kpraveen.lkml@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>, linux-mm@kvack.org,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Preserving TDX module during kexec with live update
Message-ID: <aljw6vDaeEdhzZdy@google.com>
References: <CAAhR5DGpL6_ViMwQ0nKzTgOoziE_oq8JofpO-VtHBXK37uO-FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhR5DGpL6_ViMwQ0nKzTgOoziE_oq8JofpO-VtHBXK37uO-FA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF6A5140008
X-Stat-Signature: wscn5ooobb11d6w1asobc5cp9upi3j56
X-HE-Tag: 1784213740-3621
X-HE-Meta: U2FsdGVkX1+2V9I/cXWX/bwoVMvV2PZDSiTBINQfSqOQfziWyHlSWRo9GMeEQcGGOUpuNbgCtWznzMxGLFpfd1BvwVlf3MrtaiI8voDxiUC2bfKMMNcE+l8700sKyFZCnJvv9e2q3TohIB4SG671eiDEaUBHMRrGSn860eMcKU5iiESOgtqg2JWxuEaal9Sr/gH/FzCkYZbOpJ8IeL/QwzcJqq8hBOUQl0HkAayaC8RjXa52na8iyuRZMJ74Xak3jAQR/gOIv0d5iZobOfLEI4SN1EfDdYZwNiT/iejA0evd4DD0HCexFeQSCkVMEpR7GLgt5I8k48oNw/DYs+MqTHxOK2Kyqx/F1yjCWf2N32/R6t1hc92fOOUEikuW9R9BOGSiEU1WFijywR2Y83+JemxWtcgPlJA8s3Qp8DOYC9+6vXo8emI2xZRkQiTJIVM64L8a/gqDPj1NN6TcmPJCDb1W+LLKoTdudMz2HaUN1J4oJh+x6sVYyTWqSSrsQemEdqYDPFG75EamiIBaL3UT8X4phM+EWOz5Dgh0thscD3XhLutCylC6pdUx34mdBgwvS83sQfZt5fEZZzKu0ELZ7eWL66jLc1y+tLYZ22aPVoGu8lBHAkmEaO0aLlZI6hvBi0CAPjWSemo3iiCYHmpQOgIlBidKXGcsb+W1Ufq0bUXU+iFSTHmfRL2RBvM60oR7Go6Z8UbtTJZy0obU7VbD+yk7vGeJpwiPT1GttuEl89XDWnCBMg3SI3zpqqyv44R0ewfyVQ0UhURuRn9pyHLoJgYCTN8dn27JyRYTEFLTCu0vuKX3diajTXQigGGmCt/a6VC7OUbnd5aS1ItHLfxbNPlXnddTsbhT/fkacApVAukZEvYR8xPrtjlzsiLQw+H6uIGrk41v4UkpE4GbRDrBzoemcZzEweZFQw195xslIk8OxaSoL1YJjy8v/J0oo3EfS8OKiuu65kqoI1x7ISn
 cvrQouTg
 Myv6TOnINy4pLXRQl8Tu5L04UnHrYZlckkeauD4sz7+L5ZbiqtK/9cbImOftRIou9MUTMCx12uTChRklHZw52xcCDdwlspnAduvvTrmUd3M6+xIN1eNwphxdHmXsm2oXL6SarpxLxu7jngbY56j++zaLzfkcI18Z7Jxgd91LVeSA8UacAeqv+1P3HOE3K7ey0BxShXF70RHYD/7CMh3LinwH39Jo6t4COPILHv0aEEXY3HeHvF1ivUGETS5kwyafRSfHvipgQhVHEyFzw5sIxx0To3Kzff7FwsqMkvWyKi1hZ+K0QnIpFiemquPrZmjGUUr7y9+M5JTpSqFte7W1pNRMX3KmHUIQqhlqSU2Blv+d8gcWF/B4lwA3Bcu2q1uMDOu5tuJYdei8ujAtI2AcHeeFeStOHgMVWfFhFLeYOms0nxOCLu21fU3i335ehpoJomyvEBwyGcs2LCG89qPlRXQ4+ejAdp5HvcJDi7I9PGNjsHIsnxcGQXoUPXGHiDe//ItKr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-15 18:28, Sagi Shahar wrote:
> Hi,
> 
> I started looking into preserving the TDX module across live updates
> and I'm not sure what the best approach is. I tried looking into using
> flb as David M suggested but I don't think this approach works for the
> TDX module.
> 
> Right now the way that TDX supports kexec is by disabling the TDX
> module on kexec and then reinitilizing it on the next boot [1]. This
> approach clears the TDX module state so any TDX VM from the source
> kernel won't be able to resume running on the destination kernel.
> 
> In order to support live update while keeping the VMs alive we need to
> skip the TDH_SYS_DISABLE call and instead preserve pages used by the
> TDX module such as the TDMR pages from the source kernel.

Agreed.

> 
> From what I understand, using flb will tie the TDX module save/restore
> to the lifecycle of the VMs depending on it. This means the module
> will be restored too late during kernel boot, after the VMs are
> restored using the live update IOCTLs.

That is not correct. FLBs specifically can be restored very early in 
boot. We do that for HugeTLB preservation, for example.

liveupdate_flb_get_incoming() does not require userspace to resume or 
restore VMs. You can call it super early in boot to see if there is FLB 
data present and, if so, change the way the module is initialized during 
boot.

> 
> I'm thinking we should preserve the TDX module during the shutdown
> stage of the source kernel. Perhaps we can preserve the pages used by
> the TDX module as we allocate them on the source kernel and pass
> pointers and additional metadata during KHO. Then on the destination
> we need to pipe this information to where the TDX module gets
> initialized during the KVM module initialization.

Please don't invent another state machine; instead, use the existing 
one.

Pasha

> 
> I haven't found a device that acts in a similar way so I'm not sure
> how complicated this will be or if there's a better approach.
> 
> I would love to hear your thoughts and if you have any pointers on
> where this code can be implemented.
> 
> Thanks,
> Sagi
> 
> [1] https://lore.kernel.org/all/20260323-fuller_tdx_kexec_support-v2-0-87a36409e051@intel.com/

