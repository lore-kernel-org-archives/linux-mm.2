Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D63DDCCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27E3F8E00BE; Mon,  3 Nov 2025 13:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255228E00B8; Mon,  3 Nov 2025 13:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B2D8E00BE; Mon,  3 Nov 2025 13:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 057AD8E00B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:22:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFBA257F05
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:22:14 +0000 (UTC)
X-FDA: 84070115388.02.37C9E1C
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	by imf19.hostedemail.com (Postfix) with ESMTP id E65771A000D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:22:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a4XaTIpi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762194133; a=rsa-sha256;
	cv=none;
	b=B7HoF8lRN3qL76SVomXmIK5WoYNOqEgPgm10gLDtOOSYLEOOS2KIrISok1EiQ1W+WIWxh3
	yXyr0GpVRcZmWv+KItCvxGcLGoJoxLN2U0Qm+FXr+ZgSRv+7aG6yS5EtJLMUOCPxKjky0b
	DmzwooT1zmjJsvC/kc/9filIxb1gwJs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a4XaTIpi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762194133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CADywisMv8oKHI4QSeR7YMm7LIR82MPNXUUykN5HtdQ=;
	b=Q6Ayai3lqmyuJZue+8MF6BcmC24vkPpBM0Uu6aIJQXmM2g3ua/tLQZO99zRiQWXS6dZEIR
	2o/xZa15M0TIu/bo6dLyOCz/JbtQgOqCLZvgeZqZS8uiUqaL2+wmh1Ntdi2MssKMO8+2Sz
	WX89PK2q//69L8WKKGNmu0I/6z2149c=
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so870306766b.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 10:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762194131; x=1762798931; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CADywisMv8oKHI4QSeR7YMm7LIR82MPNXUUykN5HtdQ=;
        b=a4XaTIpi3C4tSh21nWRn3dQTlsQglJDmVZHTBriCDMkMcDyqxpTFLIqsyT1H3pzX7U
         IoynzzIh0RKpexMyaFCTocC5L/Rd8HYZOcyt+vuzVCUHs14yqdju1sQ3QxRWlCySVvC0
         kv15WtJ9mCjevG+6AIUR8Up8Dbp654upH5ZYP9eNrIyUTh0wWpbRYSAlOI5JsMVkhEDz
         l+Zkp1GV7lbLrLa6qn4dJndYaEs7V40or/gp68DDMP5btNwVaz9BNkdJkT6D5NRDlVlX
         8wQH+/zcfFwbwjgpX5a60y8KUr4qmPzRZTNiV2qyySLo+CAa1lKBXCP60Iaw1E+fXICR
         Nfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762194131; x=1762798931;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CADywisMv8oKHI4QSeR7YMm7LIR82MPNXUUykN5HtdQ=;
        b=owqqcEGmvQ2zMs0YDWN8lhGbJY+UXlhWSrWBJFoDTjZr/baVkSXrCawLUpHVWuF0Yn
         Ug0dRId6nh3QcxblS9Rc9CLe5FRVUSZFP5xxj0BBDFt8JKZ9Fx7T7+pz7+PqwdyKGL6w
         1LECOf6RqzpsNOXttRidCUZHykPAQQL1KrpYOsbBH4st8CJa2GAQ78IVn2nwmKtKfXKK
         ohNmGIqiEyXsvG9Wg5gnc/OzYgrxComvJbLQW2TGQEx6bdgMP98C42n5uJRrPNbbd3Hg
         mjmsONGLKmp+g2167t4OgdboLbsBJxXH1+7V633d1CsGS79nL420XVAdOILsI9A+Gqjr
         nmGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBpJUmBKW4Y9w87JU/gpY+FhX1YGZrmfiRS1IrosL/m9gZ+FlyLqNOnjtLWIYioo7Ddhz6R7HBXQ==@kvack.org
X-Gm-Message-State: AOJu0YynP19G2mbMjW+d7Id1utILrcyB1vSdDl4AYTHrFM0NEFF+7R8h
	qrqV2iXZ1LgecLPUjpsV4lCvzXp7VXenk/Ufd5S3mslErIYKie/bOPSlaHxZJFOHk2c=
X-Gm-Gg: ASbGnctFfKE5pu2bWilafKyW1bDcP/K/KNLq7OTLs4gPu1bVdSqENbwxavcEYmuv3qj
	S1SpaVUnxLs4kTtHHekmWsS1UXesnk43JpWHqqggRsXE+/6h/QQhBBNwLb2gZhei1AK2Ps5LAAR
	cQyUUuESZ0vmlfq87d2fDWe4DOazoP/zM0+WtHbi9eN8Sq/iTcJtvcbUtBlvwImt4zibbbsdrAE
	m9Pd8GzA9UGrt8IwXSn0ACKxAEdAg/JX0EWJpxX0joleiIOshALgZtNoZe3g4+OqEHvOA5xITiN
	8ROT1BbuMohTzfLbgxW5sa4RxZUW+cSnNITYMwSs5w5kuniSFo1bQn4abb5lDP1M7aBHTWDcwcj
	vqoVlhXQH63xPxguCdfyJmSZfMn0Sj36hSxxFknsaBlG0+CGTjVC9BJYwwKxdmRyBJPxS/2N/XW
	xoREAmzAw76cpozg==
X-Google-Smtp-Source: AGHT+IHNFHN7nALHAQI3py5s3oB3pNSaTHU60CtQtHtaXj2ajzjyABGHYsA7JkTUyfWfWQz+8Ib3/g==
X-Received: by 2002:a17:907:944d:b0:b70:b7c2:abe9 with SMTP id a640c23a62f3a-b70b7c2af64mr561377766b.38.1762194131429;
        Mon, 03 Nov 2025 10:22:11 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70bedcec19sm413921266b.7.2025.11.03.10.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:22:10 -0800 (PST)
Date: Mon, 3 Nov 2025 19:22:09 +0100
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
Message-ID: <aQjy0ZsVq7vhxtr7@tiehlicka>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <aQRy4rafpvo-W-j6@tiehlicka>
 <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
X-Rspamd-Queue-Id: E65771A000D
X-Rspamd-Server: rspam07
X-Stat-Signature: oj8waj8ira8zks7oqh7pmwku76gbtwdh
X-Rspam-User: 
X-HE-Tag: 1762194132-991781
X-HE-Meta: U2FsdGVkX1/1ojdVntpWnEmfEPBj2rtv+h4CO2Oeysdbcxt2VNQkeoGwaEBjd3XssbAUJ4yQr0/eCwOSoISokN7qhEMcQdcUQbKLsh1e0jmU45dgsPdJuZMCcH433AYKfNd/ym4G1h3D5aWq39Ng6I8K6tWT/17tIgfrltJA5/5jpKj2IZLtaFxd8oJiEEXnzsmz87YwdjOamu40suuPG40vsPBqDHJeZFjHkM2je8Htm3UHV8KgGfzqB692/Kwx5/tj9m/4F5wQA7YfAWLBX7Nh/VeeFFY/YXpGfELQMVJx43IY1hgLJGRRYowKyTeQDXMpI0Aze/TvG6sQpSNAmj6AfuHuHJSfhS74Og7C8CNLsr/wrvatgXEz2wVSf6kx81T+rsfTKDXpXP+zsS2947u1KwgIxoxvVVaQjuK2oNmPPqf+UXFkc4JNAIzI/HynjiUN8Hjo6zOkEgEbc2HdMEYQwuID6d8+Q0b6aPok1pG785DikfpHIdXfkExJXv/YHRxBPIfCwUIC04xp0LVmy+1jV3/9BnhBoMVflw92HbTusCvPynEfmSBmmgUimE2NfHsko5bNd6tEiZjf7mteDyVXd0K87rfbLivZdHox6Ex2jgc+4aDi7tIG2Z+x2KmqrbJJd9udfjPbtvYBFLdh/XbF8EXj7pBtLDStShEnrvFSjF2hU/Kh4YUjNR74o6VYXDVPfJx9HAASYvPqGKD8ev19wbulHo4lSz3YZ0/Bdkdidv/7sJQp//SSVCn8q4DzxgCusOC/Zz6kHMwfxRps7GMTQ21UM2fUSUf2xOhlYMC0glUfxi6d7jfREWUsGqpF9K6ghAeUWRfpxv8+sT601K03jeYisFaiEe/FKJtqzS+n/QK0CWkQUtfwuMYe5qT0RRwJUB9iIaUl9sbn1E6s8vYFJJ7FYNYwqpE0gzrI77yB3hewaV46UqDLKQiv2Gag++Nv5fTrL6p6obRTVlA
 8ckzJW1O
 p9WntGcFZm9ogEpKviXB2cgo2Bx8a2hmhlHfY5DFkC80xywHY99WmdrxHgwtwSV++B6ZH3jY/mf2yEy1RSFhoQ/afSg0y1OYXIk7dGtbA1Mtdt5R11lLp2a2MGY/Zj/SsfxkqdoyVWODCbSagkufJ5xmo3FMglG41snAZyYS6KA9mqy9S78PE2XkOaZ8YyJ72fJIrn2Nvc1zfPBXcXuAUYQB6FMb+5gkJwOs82i7pWqNOWsFIqSw/0p+/kOTnhKe768Va
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 02-11-25 11:55:56, Ankit Agrawal wrote:
> >> >> +static void add_to_kill_pfn(struct task_struct *tsk,
> >> >> +                         struct vm_area_struct *vma,
> >> >> +                         struct list_head *to_kill,
> >> >> +                         unsigned long pfn)
> >> >> +{
> >> >> +     struct to_kill *tk;
> >> >> +
> >> >> +     tk = kmalloc(sizeof(*tk), GFP_ATOMIC);
> >> >> +     if (!tk)
> >> >> +             return;
> >> >
> >> > This is unfortunate.  GFP_ATOMIC is unreliable and we silently behave
> >> > as if it worked OK.
> >>
> >> Got it. I'll mark this as a failure case.
> >
> > why do you need to batch all processes and kill them at once? Can you
> > just kill one by one?
> 
> Hi Michal, I am trying to replicate what is being done today for non-PFNMAP
> memory failure in __add_to_kill
> (https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L376).
> For this series, I am inclined to keep it uniform.

Unless there is a very good reason for this code then I would rather not
rely on an atomic allocation. This just makes the behavior hard to
predict
-- 
Michal Hocko
SUSE Labs

