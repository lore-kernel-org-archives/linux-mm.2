Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1607ECCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 08:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471828E0074; Fri, 31 Oct 2025 04:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4483B8E0042; Fri, 31 Oct 2025 04:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E178E0074; Fri, 31 Oct 2025 04:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 225468E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:27:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A934958CC5
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:27:25 +0000 (UTC)
X-FDA: 84057730050.01.EC66433
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D157140004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:27:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KKyDWj2O;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761899243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/fYaZtBikFS6oNzHl/Bdj60BD7iQqSjLDzNr7ZdDK4=;
	b=wDbpPQRSQxNLiJ9JBgg+ADbjb2HoNL59JiCrApw9YgrkhOWoDoU9KROqe1THGIZnaYRDzg
	G2Vu6HijTN1d7lgMzaEioLcbNauifjrv5mS4rofe1V3S9xV9khBDTjv8qWKMkkbl7iBYLF
	w8gvjOxR4SSteb0ahnbOHLVcJH1vsC4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KKyDWj2O;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761899243; a=rsa-sha256;
	cv=none;
	b=p+rTF1Z/GFAZflJ7JhgqK5V7fq7tV6HQ3LwlFntnGuq2DQCmFnUOn908egX3+/T7iJeH8f
	sc930knB/rLkRWllH/XCNjbAH++cpjA4aTGWDW1IxyuhWa+qTZEzE3QqcJc/YAWOvIlk/Q
	GK3VbIuf+XVqwWyNXoOUk9vwZR2YJSU=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-429bccca1e8so547480f8f.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761899242; x=1762504042; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i/fYaZtBikFS6oNzHl/Bdj60BD7iQqSjLDzNr7ZdDK4=;
        b=KKyDWj2OhW+sIg5e+W0AEPj0Dv+HBJ/p82vVWwjzDNUAGoRhrfySitRxhP4ri2iW+g
         6JaHG//i76XpNWugIOr2cpGmBxeSsJH5l2CM9FN25stIJ5tFDv7zSDr4KnoE7M5Lo41v
         wmKABJ6p0NSYnJz1lglM2shzTKUTdPC/ewbdqtk2dGipALRXQztH81dxPvvTKigT2YSM
         wI9+UIVAZOJBbspQKzPd4xLlENvCGcxUgpX1S4KoFVw7iVEywdiqt8zydKSCD1t8hEqY
         afkvyrLfMtF0Pon1gdYzcAl7J530z3DfjDkNU2d8lMhXNiepg/PDI64bHm7C9QnWwRA8
         xJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761899242; x=1762504042;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/fYaZtBikFS6oNzHl/Bdj60BD7iQqSjLDzNr7ZdDK4=;
        b=PJFHBQOYebFeWyOTzMVNcYdeDJ1aRo3qm72oCfAq1ZgeVZl3psQAw1/WrSL7kSGVIZ
         v8Kbs8CP33BJ9YRFW6XNzGex41thNJetFQq5THhUdmEuF0ocYQQAn9kZxXgMSSN+Rvx3
         o6zPeq0yjDmSFCMU8kjW3DRfqGYX7Dg7GYeAovJe+c5tc2p2XDvdQHEEvsCc8J8kALZy
         oT6dhM/CilMAd/cM30Uuhh+F49Q/T1OvoITQLSd/+UMSnUqZh5nInpv07/cXRVriz/hg
         Dm2e4DybJyiJ74Ks2r89LJk/5Y/NP9ud22EyZJE2ACo29YSPF8+KlihxtS1UXR93xPqY
         qBAQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0OTZIvv2HrMCpngwBSJwqyaQAsV/bZtOCz7RMHQDmfqYrHZU/5YwR7YS1Pkgaws1ameEtammPOA==@kvack.org
X-Gm-Message-State: AOJu0YzEBL/4fVepF5ObBHTegj+mAOMzvRViGSyZMBIIVKekxRSrioQQ
	300fHAOZ0PGVG0qRT6f7ffD4lB8kAT8w+3rsWM3kNEEwPRu0YkEkxlpxd4+ILNZpjmc=
X-Gm-Gg: ASbGncvkdHh6WxR61TJWu9yW9Q1h+mziWSKdAe1IhQHuFK2Aa9VIZY0vjL+kMqIyiu7
	bYaMLKdFyIiSyEuNwhZNQz2kMkK9j5TiWN8PXCnI78Cq3tWz+v0gkmxeOMxamLWVxdzZtmRvwQX
	Z6W/BkY3iEGObAYnyBRXO4VAkiCUfoHbftbC6QYitsXm2hSIJuOIl/FtgXUqLQuZOPq3HO/7G/+
	Va4sukt4EW66Wy0F/x0HhnioNmwqtOFbFtEhyu/SC5yCFngkgGpLqVmtcqLVw00KC2oEqDw/6aw
	lffioSnWlur8BBzBH9EfmGY7WssTHRMCKOLby0mSNN/ABT60OIufFQu1q1To8teOC2SJmFoJJVv
	EO/1XHYN0SBnRUXWgoqiZqI49ImR7PGSdGG+btb1lGDiybEC80pbELyPxk5mYe1GDlwFLCce5yl
	319WsCuPErBh2kZODft46LFtME
X-Google-Smtp-Source: AGHT+IFSgi5NgEp0bWNzIHDj0wUEorxSLRV/wRdPuexvpAZjr+shE6+j17OmyoRsqSiC8CijMQFTMA==
X-Received: by 2002:a05:6000:26c5:b0:427:580:99a7 with SMTP id ffacd0b85a97d-429bd6b222dmr2082292f8f.59.1761899241764;
        Fri, 31 Oct 2025 01:27:21 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c1142e7dsm2242752f8f.17.2025.10.31.01.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 01:27:21 -0700 (PDT)
Date: Fri, 31 Oct 2025 09:27:14 +0100
From: Michal Hocko <mhocko@suse.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"guohanjun@huawei.com" <guohanjun@huawei.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com" <Smita.KoralahalliChannabasappa@amd.com>,
	"u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Message-ID: <aQRy4rafpvo-W-j6@tiehlicka>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D157140004
X-Rspamd-Server: rspam03
X-Stat-Signature: j5whkqhdbbucjfjfjmpqpckkepk4qcma
X-HE-Tag: 1761899243-100270
X-HE-Meta: U2FsdGVkX19k+kql6fbPsG36WcaIwtZ4rlJwmTTbBjRRN8Cm6gIMUbqwk4VDnzxCKxg9a38373VOPlWhd+odSYJLpe5QMTTfN2N9/rG2GGVzjH+HC37ncr1dsZZRseVHaAvkAxCFxBd6yjEGhTCKnzlPS9QwQ/+QaVLNCkJV7Y9M95vwyLK6uG/aKZP6jdj4rZWRH1ZCmBvT/0JkTl1QD9nwwzEpXKsqvBgvy7zQGd6YFlWTL3puDQ1aL6bMTlVI7KJvHDpHDADpTFDUtfpiKwDiuCqQCpH3gr+aEHjzL3/mho5KzP2s8toS52OTVECS0wXCt3Psx3NjG2xGsGYrIMw/Z2IhAAsCXfjk+DDyhJ+oFCE6UTvVQxeOei1z1W8D03HRxOS1ITbxiKTrC2CtcQtQD/L6AnYTvYe2sUPGXo8MBp2eOjdRC6UxPUu4pWEhVoHRJkBQS4IMSB3Nz2JnnlqoAhwRJ6mme54aqmQZxBXXNhOqvYBHTkWCucZoPYyq1pbQ5WVpHrIoV182pEDU+djUez0GkeJ8hqoPqweH15e5EA38zKvKfJDJqzcIkmKnIUxhlC/0XFvrzdJ3dllNVzRCxnLt9bRtzpURQX/WTdtAzMDoEOCH/Xjg3R5KofUqPttHRbdUczlMjg4Im66IJO1Y0MZYdEMuoxQm/SEDDvUUIDlJw0AoT5gdxctGXYX4+h+opJvuwA/LHXC2IW2gspeQhp4NTMzmHASLyBqV7S0ZwitAo11dZiWId96IisOMjrIvTnBpJVQ9g1nMskrGySJhPVX64OjQaLjQIWtUSmzejaebYINOpV48VP3Fhuy3CWAWFL5PYJm/AOKFlWEofrUcLgp+xTii2wpJTzTvlwwdU6vocX94TjNR4CIQgwngjlKKpw7okDN9L33D8Gps2OcePlPfeYLAwtEDmZ6MQ6r33Bs/SzLZbQ6YOTluthcEe8O7rUMNNl4Nb3TSjy9
 bJmLn2+h
 hGO9uVGforN9ITjL9Uz+98NJkveLbAKU9Alq7S5N2Kc01GoRfHHieXSO8HIeR+s8M6rAmY7GQeSd9UjEARW8puohFIa8fjIhVcmyrBmuYWuIuV0AX+wFLw4on/WtIYMWUewWUkzUx13xB0XUV1c8CCJLHW4GbrWIGXk9fWHIg7shOx2cBt2TyD0dAZzFDj4zzReWWYsylqW/czO2xki33FgWb3GNgQUBFSuV9teWH0qjC/379vrHvBxq+fjLN1TCUEcdOfhDNEX2ADPFP5gXYOnYLown8tUxrV3PV6TlLDBD+jkqB0QM2MeJSAXjtAb4OZwr2dfeOz9exXeAkmjZCQCqzxgnbwHUIaBg4jORPBsB+h5dZFpOVxqQtDY5WxO0WtkRxccDGdNz23CFnnRt3R95zNG77Wn0e11hHnco9POrLWrgDAAwKc8/IrSMKTaJQoy5bF0UnKzU/n2/uLRzRjWacSLt2RKreiC13TgYfam0v/w1g0BrJiMS5fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 29-10-25 03:15:08, Ankit Agrawal wrote:
> >> +static void add_to_kill_pfn(struct task_struct *tsk,
> >> +                         struct vm_area_struct *vma,
> >> +                         struct list_head *to_kill,
> >> +                         unsigned long pfn)
> >> +{
> >> +     struct to_kill *tk;
> >> +
> >> +     tk = kmalloc(sizeof(*tk), GFP_ATOMIC);
> >> +     if (!tk)
> >> +             return;
> >
> > This is unfortunate.  GFP_ATOMIC is unreliable and we silently behave
> > as if it worked OK.
> 
> Got it. I'll mark this as a failure case.

why do you need to batch all processes and kill them at once? Can you
just kill one by one?
-- 
Michal Hocko
SUSE Labs

