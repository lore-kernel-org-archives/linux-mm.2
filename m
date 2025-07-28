Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C96C87FCB
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 12:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE5E6B0088; Mon, 28 Jul 2025 08:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D58B6B0089; Mon, 28 Jul 2025 08:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612936B008A; Mon, 28 Jul 2025 08:17:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52AD76B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:17:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1E181D8DA9
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:17:28 +0000 (UTC)
X-FDA: 83713573776.24.4EA0F82
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D0911A0004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:17:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=X3uT0Jd0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753705047; a=rsa-sha256;
	cv=none;
	b=qgrlkVm3R0TGolRQOYpGRwUrJWcuDal7YXHMaK9CgZI+Z7ArDc6eDvebOZw5ay3XguLbHX
	DqUSBD3UhLrr6Va6sleh0xMdfYIJWkLiAnX/J/fswOT+UlYZhh1ET+iLBNQ9dvAmFdbeMd
	XKRg/FhAavbuE20oCbSEQBtiqKVlNpw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=X3uT0Jd0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753705047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKwFshXl6708YNUqX8UUs/w8wlLbfeDR+Z4nlVVWrlQ=;
	b=scKGwdngFvIgHh/WaVtDeNg/3DQl/FgpWxvDy+iFN6Rj9wVacMwisKyFv/etVr1fyNQGdA
	wt/UiSE0Lv4FtS+ewzDN41i2ht2fosrWrxDhHaj5ELrqyROGCUl3pw4v+8GuuW14vkerUi
	Z8nt0kYvPdCLYRW0GHbr4tFR/jLESdY=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-60c01b983b6so9259209a12.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753705045; x=1754309845; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKwFshXl6708YNUqX8UUs/w8wlLbfeDR+Z4nlVVWrlQ=;
        b=X3uT0Jd09+/wEZeVFzUteCXJCJ5RvBzRdaVltV4RgVs8OEb2ihLZYAdJyUrIDT8ZNX
         AX8Wc3scA4TMvgnI7OGP630siPeI3cordY/CffakHJADSuv5FGXMe4/1qS2/8EKG2Dqc
         EokTgUum69gj61kFOpPbPaEeOGtapUOtxTp/kTOERbTN5Wz7c+6GVneYlIO1Yv7C5F/7
         wkcDuk/QbfgOtVcB9ressgiRStsGaCLXsWTZbqSKHd+e/qAisuvd56UaJDTSZEfzkhyQ
         A5WU7+Mx579OqMMaiOHONe+TlnzIgT49b5c4tfDn/4gXJ5vv+PCvVSSLz2hHWttKw/y6
         rCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753705045; x=1754309845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKwFshXl6708YNUqX8UUs/w8wlLbfeDR+Z4nlVVWrlQ=;
        b=ETlTxh/LPA8EqD7tJHyAGwGFZ/0in4kKQ//SwOa2N71wwT6PXERpLqMhShe+1CR9ix
         XeWHMkyDOoZrDbOVVcO9WLJXHku7rzDZGc3pxA4MfdX+BB3mbBOl5KL0WShdGM38sg7D
         6ts5WO9X7R7FUM53XqLIieW5xCBggt1MyshAEXQ3PyR1nWK12fvI/8BmhAiq75hrfzNJ
         YKih19yjPQ6NBACADpKLai+5mMSQp39JqxW1LCTT3OTBaaJ5HWws/Hujy1FJ8GN1c8du
         ZSXIsSZgiZ0V2ovifNJzlVGLXix0sE2saK0CLla2ApM07WNiQ4wHJ9O/v9jxuwU3N1hi
         Jl7A==
X-Forwarded-Encrypted: i=1; AJvYcCVoZSg5psxQTi03utrfl86zFRQo9rghZDELLOvlOeQa0T0TsovHdAlwdytYBF240TeJ41tNJ215zg==@kvack.org
X-Gm-Message-State: AOJu0YybDmSsFEtkWL1z3H37kHpsVfmw01RMzay4VWpecTar1lYCy4bz
	zyDckLVdI5T+JJf2V7e8MxZMlJdBekYRCA6QW+UFuMCWNLHKt9gT0K5MPNHPKs3nuIRe35Vlnhq
	hwfY8pds=
X-Gm-Gg: ASbGncvIBliR180WiYEW0Buog6CPDMBhdtAlLJYn5ztZfN7atHOv8PpFmb3Uyozy/mw
	9NxZRYOL3yxU6i8bQD33Bab8fJvymCzJJcs6Z69gVIfESnxXtyyt6ojjFhNQJuasyodb8sW3MeU
	EwsxXX0E3fCFjkPP6IjgtDiTARgYYeH/kKFcJbFyE5ruKS/m71/bTKEt6mmAL4MZcXi2hX08prB
	RPfX87IkZGCNTDs7C4N2n0FmqKmWgtNLjFBCQXwGygiiHc4nnHqa+gVa4d3DVtTXr5JFrGwA5SO
	Iqy7p/8BJAeaFhTk60752AekxMYahDpqyp+vHaYaJwl3zfvBjOCN3W5VZTnKDU6/UDS6hqUeXZO
	hLQI/4U6Mhc4fcEinLFUuLvhRaobzYW9TkAU=
X-Google-Smtp-Source: AGHT+IEspdWBkQ2+iy97ADb3/zSC34bCTFsjLQt5CCCoZjDD9JKrJbrhr/jWrpDBsGuoj3FtA9QQOA==
X-Received: by 2002:a50:c00e:0:b0:612:e841:5630 with SMTP id 4fb4d7f45d1cf-614d1b47fd6mr10815474a12.6.1753705045248;
        Mon, 28 Jul 2025 05:17:25 -0700 (PDT)
Received: from localhost (109-81-20-172.rct.o2.cz. [109.81.20.172])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-61548bca6acsm817008a12.17.2025.07.28.05.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 05:17:24 -0700 (PDT)
Date: Mon, 28 Jul 2025 14:17:24 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aIdqVNCY-XMNICng@tiehlicka>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
X-Stat-Signature: hmmhfa53jyzukzp7bpjxsx7du6iqysed
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D0911A0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1753705046-50033
X-HE-Meta: U2FsdGVkX19pjNCuhf806NzJfmMO+hk6dROJwr2/f3dFlSUOHMV30e4UcT6xzTE3X3PTbB3V+iCz9VFhM7irKNa3nDSLluZ4Afw/ayLL7hxF3cjaLF1KsGYP1ot442bbqyK2Ht1S4M97g6uCxXgjV1UcaOUElgJ8Fhxsc4nuvV9ej7gxchmPCNNe+TchZbydFCs0DmWc8t6SQVbKT0+tbMW9uBtFdt0EZ0JXNxeoqqpGpNXQht01rwTVMOj/Y/VtnqYaM74vOSl2kfqMFlo1ou9mHJ5FRpAECnWIii6zHr5TtjPMcZXRgkcJJyEMZ5HfhtLKrdE4tlEz72gfQqwedjJG5fWhV6OhtT82ZS6b5c8aRC0tDvhCK2w9OunvBxg9UDFXqdkxPWaCwhEev6AIaSCpQI3N7qAeofS5SrDKFCHzzwkvZeBI0qRNyylnUrBRcXDf2HPf0c6BTzFBBd7Yeir6TKlZbyary0M2B40pVkc0Ky0QN3Pn95U+SUr2ierqJ/1GeXhRD9zgtR1YwfZyje70qeu8WnNM1c5CkbBfYKfdTFJE1q9OlZSD27jByKElpMdigX0gg1HEhci3S28K2G4FLQ6ydeQlWLUY34XV9W+8UnPwQckugMaOFSPk3yIj+1XBf+rhckSpS3OS0O5RWtJbhJQkEGzjKLrEdaTjJqtk82/SdAtoPO4XnKSMJQXZJA4nOARWFPX0VPqVl8MjrBB/QMigzZq3KHWGzcb1DfLiJHspQu2VRUUIUegleowTo3LqMVKHmDUjfFaKz8iujFp+g/mgUZRYr+ywJ61lWDPc0IU0s6FcH76LfOGSwHCPeV7/P1MvXT4EFzxZgp6srVP1WDvPnZVl++Er0JAOs+qp4yf2xy1XkmQM1IQUyRwHJ19ZMhGybyxmc5ntE+sHEzviwt46ZFVTFtNYL5P1DLhC0yfT6PDzk1GGIBTAjAeWomucFCrHcfUHLe5Qjrf
 6lE9dfku
 FMw428xU12WxItRLcD53zomO8kgBK2HZA9udv3hu5stZEOXPCgkF+PkHj5RCpB2BZKmt5cdF1DbrtDFXA4qE0HbRYiDVz3GzNsBfQq0hmUZbtxS68JAl5Q/KtHvGFbIg+pXrxuKP7R7nNx6CINDq98wEeyNvxcvk/5v1mBaBM0T7+X67wle5J/h6tX+mk1rDCPZvwZE43IawwcKJZClk753CUu+15Y1evg2gdc75gJrgvz0FEk4vfD5IpW+FkF4+loF5UPDVMmajzCq20lWfvjuHMzbpFsymtI91X9GfnuyG5Eaj9RlDpbabtwl/s4oLPIZarAfDBlfAlGEsyD1qFaRH5NSK37J7Ur4ea4HCnDpi0UwI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 28-07-25 11:10:44, David Hildenbrand wrote:
> On 28.07.25 11:04, Michal Hocko wrote:
> > On Mon 28-07-25 10:53:08, David Hildenbrand wrote:
[...]
> > > daxctl wants to online memory itself. We want to keep that memory offline
> > > from a kernel perspective and let daxctl handle it in this case.
> > > 
> > > We have that problem in RHEL where we currently require user space to
> > > disable udev rules so daxctl "can win".
> > 
> > ... this is the result. Those shouldn't really race. If udev is suppose
> > to see the device then only in its entirity so regular memory block
> > based onlining rules shouldn't even see that memory. Or am I completely
> > missing the picture?
> 
> We can't break user space, which relies on individual memory blocks.

We do have userspace which onlines specific memory blocks and we cannot
break that. But do we have any userspace that wants to online CXL like
memory (or in general dax like memory) that would need to operate on
those memory blocks with that kind of granularity?

In other words what would break if we didn't expose CXL memory through
memory blocks in sysfs?

> So udev or $whatever will right now see individual memory blocks. We could
> export the group id to user space if that is of any help, but at least for
> daxctl purposes, it will be sufficient to identify "oh, this was added by
> dax/kmem" (which we can obtain from /proc/iomem) and say "okay, I'll let
> user-space deal with it."
> 
> Having the whole thing exposed as a unit is not really solving any problems
> unless I am missing something important.

If we need to handle that thing as whole we should have an interface
that allows for that. Per block breakdown doesn't really help anything.
It just makes the whole problem much more complex.
-- 
Michal Hocko
SUSE Labs

