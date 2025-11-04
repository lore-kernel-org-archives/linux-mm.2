Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34BE4CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 10:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6178E012B; Tue,  4 Nov 2025 05:37:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877538E0124; Tue,  4 Nov 2025 05:37:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766218E012B; Tue,  4 Nov 2025 05:37:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 61B538E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:37:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D576E880B9
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:37:26 +0000 (UTC)
X-FDA: 84072572892.22.06574E9
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf29.hostedemail.com (Postfix) with ESMTP id D325F120006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:37:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a0dKZiRg;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762252645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Ne4ZDSlj913IS0afaCeah9/sHQf3Ytf7YNZFUi1jMY=;
	b=JH/+TxK3stEUig0o8+YDSf3/zQoLzsJvB+EYdyVUAh/MVUls7uMgSakWNlIt4qUb4LKBtE
	yUTn6pns4KVS1TmQ495VXv0irhrcxYmcTGMULFw6+dOb87DtnJJ1atxoE3L51bJ7EK3Pc8
	9H1plLh2SDymQvzJbszqOfhOJzSeFlk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762252645; a=rsa-sha256;
	cv=none;
	b=4wSGlj/fhF3U7jfYu7bYPAWL1jmyQlwUi/NoOazMAc8sYrhOcPeLLKa3aiANEH/BTiwQUP
	CnudZ5O8b2mRhDb/RPDgttzHW/PUD1X7adU3XnPgR7btKExcQWzspbB1lmpCFpl8LaLR7R
	GlHSNXXu3PtH9I7p0L/Ft/PfOCrcyXs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a0dKZiRg;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-47728f914a4so27485985e9.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 02:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762252643; x=1762857443; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ne4ZDSlj913IS0afaCeah9/sHQf3Ytf7YNZFUi1jMY=;
        b=a0dKZiRgAKat4u7hnPb38wgPR5KrV4jp9KgSdCXOqCqs63rRnCR4QxVwpHPXfQBdKl
         Evc5mc3T+/h5u80grNVni1uunOe/u5GH4+QSxt8/JD4rzcA+08XRZfwpaQAJgyp/DAcD
         TIBocOSlTTpinjHRBH1xswfmcU/kDif2rAVVggIimEOZDnsD8rAUKxRZnFskiQOnaJSO
         fXwIMIKzkW//j76bOfseT3lVfHTPnFjR5v79iymfrcRM/0YUWdNkDf8idakg2okYgyRI
         y9G3iFa4gTIqTMja2kL6r4+US7r+eGF7Uvba8YchN+IkxaEXif2SY0oKYDiO9aUNBGs5
         zd7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762252643; x=1762857443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ne4ZDSlj913IS0afaCeah9/sHQf3Ytf7YNZFUi1jMY=;
        b=kkhW8rnL3OcVxN7I1lfIXgDNlXA17WEMOm2cDOHjdmoLBEBC+LnM1s6oWbq4cxlhZt
         320FAB0jDI/J+0ZdVU18dIPZqIfW5Zoo06Zrn8SDAlhkWwMiDqeucmg2t/+I0ocSTcwa
         Iw9h1qJVsHy7huByC/qHYmUMjWbTZC95VZyh6Yc4Ai7ESdjcERYamRmHa2bVqxEFNErI
         wQHtJ74Hz6HS+KmdhfqvmD6khwewKi/6W6AXMU0BMV2S7OetYvrYQe7R27CYlzqn/5SR
         uUVqnLxbcQaSNrlnW3EGYIyqmBMSpaxaJA9Wc+ga3Tuvgp48x8D0FGGwjyFSo6svKtCa
         MO+g==
X-Forwarded-Encrypted: i=1; AJvYcCVYKcudk6xObFynigEC1Ca0HMN73fzC0BIgWomv2FYK/rFeAuBu+jSkak0qyYUdVT4PfwyYnT668g==@kvack.org
X-Gm-Message-State: AOJu0YwAKbZVLG0Cw9jOcQ2Z/fkWY560bkpej7x61pJr9WQ56kxMlYjl
	DAKxnhaj8PTeBRIUvZJRhp8gOoQA/SdvBoCdwnQP6leqsSf6N/whr8Yg98vOmB0Q14w=
X-Gm-Gg: ASbGnctUykybMG1528zhF3mDyGWZlaBSF/hG0RbkaJS6cWaEAj9p1QFWQx+e75v/8C5
	CobIpdbITtAnRti/RNevR41kiqHuWC4GHrUgC7quiUYtoHOih1Kz1ryuIX2WKBWaC1NP1A2Tow9
	9ixN6L8sWHiMsYJOKz9wXg2PdUl/x3LDjNjCrVFVSV/yshGfrkzN90gTQSd97QIA+/TGEN6q0XG
	DS1IiOiYs5UeBPWtqrAcSVBlLQU3V/qGiSmhYo9Jpa9eJEKOJl3x8RTDR4/OL/OqDNgZjRPUjB5
	bSxKEmu9GMQl8Z8W+Ywh2ukWnxDt/L05EpL6Vm02wOfEA3AQdGk2ACuDQ+3bEWUCzaBX0LV7mz7
	1FvIB5yv8GLZt+czhOdL4XddaDPbc7sO/+x5AFOioZO7AV6Cz5BhvG7fG7YUzhEqtWVRliq6CoY
	veh869s/YK
X-Google-Smtp-Source: AGHT+IFf1wOTlsdo8GWYHh8jAMEFl3Fd6ZMSKUjEHUzMaQyfhIP4OVI40+a/WDrXsXYVLl3vLVN/Zg==
X-Received: by 2002:a05:600d:4390:b0:477:333a:f71f with SMTP id 5b1f17b1804b1-477333af9f8mr83874795e9.17.1762252643284;
        Tue, 04 Nov 2025 02:37:23 -0800 (PST)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f5be4sm3680221f8f.31.2025.11.04.02.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 02:37:22 -0800 (PST)
Date: Tue, 4 Nov 2025 11:37:22 +0100
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>,
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
Message-ID: <aQnXYsPR7zkV_ram@tiehlicka>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <aQRy4rafpvo-W-j6@tiehlicka>
 <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aQjy0ZsVq7vhxtr7@tiehlicka>
 <20251103185226.fea151c58ce7077b11b106aa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103185226.fea151c58ce7077b11b106aa@linux-foundation.org>
X-Stat-Signature: cm3c3uuddtjbq9e5hnrnysxp5oi1ixa7
X-Rspam-User: 
X-Rspamd-Queue-Id: D325F120006
X-Rspamd-Server: rspam01
X-HE-Tag: 1762252644-318310
X-HE-Meta: U2FsdGVkX1/H+l/8T9YkObNB8krG8cD7nfbkNNedG0+OtrRFIwz793FaXb5rD914HN3n/64p7L2pgBCwdW+fnBd9yGNqx+mu6rWyUJUYOZcKUVmvuZs9CqylrN5DrRnelOLcc4KgnXNAntSHi9Dv2sw+235PLCY0p5c3mcvzTOMVElxh4aAJC7jOZS/9f2wmudkrEvNFmhj8Er5dn3TBACW4+WgbVu9T4DN5wZFSpg4FCWGj3ZDj0ZuZzYnkVC33kXwtf0SLKN9E36Kzibx/1LIa+uZyplL/A+CpO1qxMa6YEQVKIE6xHqeb7XOq1Lj262hmlUzdrJGFWtqAnfQewxTYKGZdc4I6QQWuHqnNk5uKYVhVOChA4Z0M1ceWfsS5Kp659s0VKqiW0oO0Ix02f9LGZmm3Qli8R/BvAmOHrPgBerHnwk+049OcHC1GWrVNUdTvETyeElvZNutVZ1ZbyjAdcWLK1EydwAqmJUz6417qPrOIFQCTWSk6qQK3oggiSzQ22DIAagRwLsDyq49EhNdEUiItzbFqWU2a08xTAQMBjPG6WJYfschVllKDl2J9glM1t3KrZBf9XSjvAUQhi9/FF6zxmm5ej929pRcbEyUik1jA+3ky/Arv5ro1Yr60idBD5PfN7/lgNbDGqCjR5ukPsdOLKKPbVQhGcHS4LXCfrfwR6/INqARXUOv9h/ngJBm4AlN65548iPh/NrPEpRWEPqNPtN9c7z33xeZWBErRITNJt/rm/GL/l5tJRF0iq2ceIebViISw+pH0t1u1Lay/SafYiOn08/RAQZiF9tc7rZryusTjkPRh3IiPgR2Ty6R/m27G7FtktgF7IO7vMENmbl1UVORvmOHPMQAFB6ozyHLtb6TAjhgTL9TcX21M6n1YnIofoZI9Iur7VcUjX/TbHbWA4m3Psr+MJk+Ee4hKkPT2YXxA7x7RuzdTWaO3R4BW48j5fD/d6zPi8j7
 EZ2sVNK7
 VvnDoW4DupFRCCNijxBW7SdbUlEBxrRNCcEnIYORBXO4b5qG4As0SzuN3Q1ldLLujttNswxX13/22GUgDxlnzacksii60SEB8EwTii30MWkHxV/b+FZhb1hSWFq8dsTzaxwhELLDizn9p9JnJDEDppbtuUtahvlQVUVDJpxj7cEhqDtodNkEUHk4jQwGvRImMxOVwkIFb6HLvcfK3LKAJLkPe+VLPamKQDmJWacvv7VniB0DX/1RZuEvIPqYlBke4efBSpGkllCJQJwTXOF/ELvFs36VfQ4xyrPJ1dS3VGRM6honFzAw1+Oty0wD2yqCt+qMONc70f4xG+0V72Xa8fSzK/wiy/B9bqIhxtRXIdY5fWUcoiAK09vrs15ZQo6j4JrxD02JXXdP+kGfFltOZ2cd9laH+E5CpQ8R0kqSPzHsNvqZa4UAttPPD/tDj7C1GJ6OFX3cG5DTv46f2BmofGMOMzgkvKlrfNWqcfhbKid6137Fb5JQzQrwPICw3pplap7jyV8pMn+TTGvXYkNe8FjiAIEpQO5yUOglSyHGJgU5+KKTKsX2IP1bZ6O9J4/KTtW7Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 03-11-25 18:52:26, Andrew Morton wrote:
> On Mon, 3 Nov 2025 19:22:09 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > Hi Michal, I am trying to replicate what is being done today for non-PFNMAP
> > > memory failure in __add_to_kill
> > > (https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L376).
> > > For this series, I am inclined to keep it uniform.
> > 
> > Unless there is a very good reason for this code then I would rather not
> > rely on an atomic allocation. This just makes the behavior hard to
> > predict
> 
> I don't think this was addressed in the v5 series.
> 
> Yes please, anything we can do to avoid GFP_ATOMIC makes the kernel
> more reliable.

This could be done on top of the series because as such this is not a
blocker but it would be really great if we can stop copying a bad code
and rather get rid of it also in other poisoning code.

-- 
Michal Hocko
SUSE Labs

