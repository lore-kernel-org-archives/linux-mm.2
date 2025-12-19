Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB6FD711CA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 05:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65996B0088; Fri, 19 Dec 2025 00:21:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C125E6B0089; Fri, 19 Dec 2025 00:21:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F776B008A; Fri, 19 Dec 2025 00:21:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1DF96B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:21:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44DD11603FC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:21:24 +0000 (UTC)
X-FDA: 84235072488.30.033EF10
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 681624000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:21:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DSfJjcJc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766121682; a=rsa-sha256;
	cv=none;
	b=NdSSXgHKcK53jZkhgCzVH7sUkx4b+pqsVVLhCRFjEOL27CwYqcGX568yu2ff3R+bEss+R2
	P30OTtPC2WHbBxN7I/peq33frjN5M52vbFjJL3PLIrDg07CX6o0+JuwYDhmx2CFbnP733j
	9x9EwU+hWGnNKKT4l1bn2K2YJku6dB0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DSfJjcJc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766121682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDWkJ3YEOrRSKB2Alc1vWqr9rBKhpwuW6X3PBLpV6sQ=;
	b=utpk68eQRHD9vRRoKB19FOH3AzgkaaCUtgpnki0CwAww2NCv6mO5irzeixFFZYIXeR7utL
	ERViL3hh7/478n2kmQ72PQqOyO3i8dC333ssk8Lt8gU75dZWwwh0+AHuXCwjOoL7CZyig6
	9lpeBA7VDuFb/B/hd+aE4Iwi3R+GMVY=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7ade456b6abso1205373b3a.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766121681; x=1766726481; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDWkJ3YEOrRSKB2Alc1vWqr9rBKhpwuW6X3PBLpV6sQ=;
        b=DSfJjcJcnqTjTzeuN9I63NeMGRHQRBw72S2IHM5CnzTqDnOpM0A53+5Z1EmlEoFeV5
         8KyWQeAxkbLfW3QN/JQWgBEtVsVC88l4H3Ns4pYNdHC/tYmsXR3hSlrhGML7w6Yc/f23
         KNpzjsryFZ1AxKwQIpoF9/DdHnSxg09M5161v3L92uaPXwtzYaf4+ny/bmd3q0gAW2Fm
         Fk6lwZgu48zKea/YBzRRxA5xNztmWV3J16B4R5Ru/Qf99MjtUzZWYozAYq6SYcF0kZtF
         6jr/CF/zUi272W7Q8Y+ZqB2awcb7XKnQe18bOXPovsL7fr8bbkHS6i83yIegYu9jVMsy
         S69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766121681; x=1766726481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vDWkJ3YEOrRSKB2Alc1vWqr9rBKhpwuW6X3PBLpV6sQ=;
        b=w9dh48U9gggDVs+uFyF4RIWksjnyQ1BMCq1gsf1V1kUf/F4jPYS5whVAoMTPc2hNtn
         xYxcNV4LIM38ugpwvWuah4nZd5MrCBzmUWUm6UKomftwo/zBFTVyAVU5X1jsSVj+dilh
         voVG1M+VFBVVwAzdHvxXb/s67D9Hfu1aWjFSbuTza0vUnk55gDs06/BA+CWmMXCcHERr
         n4BxCRv6pmisUR4ZKy6gRux+od+MyY3hTQ+o//nqfsoYmfYo7PCZc2JHLCBURv268vq7
         7viybymfdD1MNvB6eBcX4fnLMKL4sAYxVy+9aO3zmilDw+5dVsXjewnaOhQXZnxmRVpI
         m2UA==
X-Forwarded-Encrypted: i=1; AJvYcCXOQ/JxBzLkfj7nY2OGrpZt+hc1PnlKYXXqsYAb3wfYBWVaIOJ2ABVSnW5w89FJL9r/sBWRE5OIPg==@kvack.org
X-Gm-Message-State: AOJu0Yz1iodKengndtkbjpgeewzQMv7qpKW0787vCBONhe+5ZC8X2DTt
	HS65mq7BJWy6ZtmoiCNBc3MkJCPVvc7a+i+sDePWDJ3HqtcU30R0g5yt
X-Gm-Gg: AY/fxX6on719mWM1Uy/22LGC6q+d+CMPlWzS726KI5SMxpXsht9RnnI8i8v2fQSYxuw
	xNW5BXUo5xaHDJDvNtrbx3H5EPIFkK+URmS7q+COXBvDBo/hXwaBLwauWueNSwBmJh/4s+D8WxI
	oLqZHXLBIHwIZDSY4iPNWtKEtkfthRDYDHUxcndC8wnMQL195CWZ0wqDVMzEc0ee/l4UliDmIZJ
	x7uIJ07poNnXzwFTvlTBre98Hs7dHbJv75+kyJp4DmAsmu2ZScU4+bPwd2wp8dZhhowOyutg/cO
	z+4oVmTLptHkxy18omm6RNhjDrIHXGlVTuv5XhPof7/3xtF+udm/SHJdT5hKLJGDlA8m549KNoa
	ivLIcLqavGyyd/OE0MVPka1vfs01vIPy+lK8gpiLBmPMHCyPVloyOKfM7IQwiOcpbpMdFb4JRan
	mGFnX8uEcvtzM0jLyx2D056nyM
X-Google-Smtp-Source: AGHT+IEHX3n6xMTF+Bin2s8e7W/NHm03DN+R2TdxZqr14ucvOSjh03rupRurW78qcH/6S5GA5J6bzw==
X-Received: by 2002:a05:6a00:6c95:b0:7b8:1a40:c47 with SMTP id d2e1a72fcca58-7ff646f8afcmr1628411b3a.16.1766121681022;
        Thu, 18 Dec 2025 21:21:21 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7dfabcbcsm1009363b3a.31.2025.12.18.21.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 21:21:20 -0800 (PST)
Date: Fri, 19 Dec 2025 13:21:14 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
Message-ID: <eblxs7da63lg3bgbngq22kprlkxv5ggzpkfcktg4pl756tqzse@tk5gyu3ytcja>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-2-yanglincheng@kylinos.cn>
 <83f303d6-ab03-4e28-95ab-04c5e879a916@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83f303d6-ab03-4e28-95ab-04c5e879a916@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 681624000D
X-Stat-Signature: bftrbsjkpcjw8fa8b9dyq8qz8s793hor
X-Rspam-User: 
X-HE-Tag: 1766121682-84376
X-HE-Meta: U2FsdGVkX19Im9l7ODcBEQUN26bqszTX+B+KtGrCWPlWhEBUj27QYbq9566Y/G8MCwFSxCrtQ1teM3sH6wtzcr5s4uT2qVicFPASVA9v/MWIhg7ttk+yOlFIFkEEFh3mfpW9BLijOJukNH9A9qr5b02Td97Yti8SUddylB612d9opAYCbh7CMhml4V4+Rr6fPDy+/LCfZ88oVEn6o835hzk2rW8dqbO3ObbgPvFy5t+5uG1MHoW993EfU+pBrfilAMbLu2a1uy0TFTp1W8KwlNp6yJ6RXZDIib15g6p9/c4AItZFafde7XKGQQyf2fxq6edGWBIAH+sDtyfSskGBypAXBOuLTB5I2qJGeWvxl/WfB9aZ7AfSooqhWEYKouzK0FchPG5FF4gQT1jG86a/5HVbtAgB9bBJQeuPUcPjVzAjR7hmqXaM+GqVRFSmwbKZLCLAjAdV6cDgy/swXBKgFrkEr2UpXGmD/bzOF7JyOy2FD/7XgjRBBanUzwt9oJ5U0Xs4C0ye5z0rK/tIIPCrkyRCKoM9WQigElFAfMK/OXXE92VvvOpTbiKh/Iz/IZWMJxEf/8yPTc9q+YqgnzUp4vD0oFTSfd3dGde5TrCZA5nL9UGyeaPiHqb+UwD+XxFeOVx6SVVrw05qmkthdRIFyvRopyDasGXNkNbuFgjnPOUOmEtkXeMYHEuWFVvax1SlyMb+7g2A1SWK4JiM0lHvwjSGU0pzsyGtcPYpFpGB3jL7FSS0/qnjXOxMpYh2vZp2OXzDBCSg+VBTTgOkau4uM5Mwe14OLveqZFmMX0b4uzTJvqiFNW18JDwdfdNbTrp/4bMqKfzMDLdDGelxuckto3TkhC3Es5ezHHuUbL2JX+edKXVCJBboPoRTnhod9xRigETrXOHEhtukuGPx3xNKH39shAqQOlsoPJxgfQOVxxzAZ4zOaqkRQJS4qINrfFFooRH1ufqYHNDDoKYqsJh
 He2G3EKb
 KJUFtNSDiKgZWacuAAtJdTPkcBl7ZunyOsMPH5bs254cGoWGmz8VzaXJGs6Ku+1dHtXVr44DQbnjGpbh6fF8nOq7HgZbMI2gu9k2glv0omz6x/7okuqkGehrRomiolQT7LgQE8RDo6zQ0EGmwn+lwkiwCRxezPezKyQXD6AQ1M32JO9SWeoP3FXrg1KB2DfqjmkqhLG1+exC6vlF6MCmRSlmZ/+bst+m65cvm+PQISBxua0Y+/DBiBj0m3A72SmlOWaOs6wlPoF2u6HNL+3GGPLLF096x6SYfFNkkYKn0vUmzl0yvCN8PFgqynkxMlR9qpO02+XS38IzRXeuM6MGtBGUPcwFvh1dcfvSCkkF0PvH2FvCvykzOn5xWHn0AoMoKTb4nuumXWwtvEvliGJ8VYBFjqvyWf0uJXZFBHRSri3aoaBX0SS7tE65qqIKIgFxlg4BfXyB8//7r4SdGhUXWvH9eQdljCfNdzNBFO1QXVMH3wFw90Nwh0GVneaK+iPFgrgFt8Ip9wWS51uOn9ygj48ffZbFAvIuA8ZMa2nSbiuGva1ouL/iDnBjhWhLQRCqXdNkQbQl7YIki+p0yiJRV8Ohj2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:24:05AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/15/25 10:04, Vernon Yang wrote:
> > Add mm_khugepaged_scan event to track the total time for full scan
> > and the total number of pages scanned of khugepaged.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   include/trace/events/huge_memory.h | 24 ++++++++++++++++++++++++
> >   mm/khugepaged.c                    |  2 ++
> >   2 files changed, 26 insertions(+)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index dd94d14a2427..b2824c2f8238 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -237,5 +237,29 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
> >   		__print_symbolic(__entry->result, SCAN_STATUS))
> >   );
> > +TRACE_EVENT(mm_khugepaged_scan,
> > +
> > +	TP_PROTO(struct mm_struct *mm, int progress, bool full),
> > +
> > +	TP_ARGS(mm, progress, full),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(struct mm_struct *, mm)
> > +		__field(int, progress)
> > +		__field(bool, full)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->mm = mm;
> > +		__entry->progress = progress;
> > +		__entry->full = full;
> > +	),
> > +
> > +	TP_printk("mm=%p, progress=%d, full=%d",
> > +		__entry->mm,
> > +		__entry->progress,
> > +		__entry->full)
> > +);
> > +
> >   #endif /* __HUGE_MEMORY_H */
> >   #include <trace/define_trace.h>
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index abe54f0043c7..0598a19a98cc 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2516,6 +2516,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >   		collect_mm_slot(slot);
> >   	}
> > +	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> > +
> >   	return progress;
> >   }
>
> Nothing jumped at me, except that "full" could be called
> "full_scan_finished" or smth like that.

Thanks for your review. The full_scan_finished sounds good to me, I'll
do it in the next version.

>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>
> --
> Cheers
>
> David

--
Thanks,
Vernon

