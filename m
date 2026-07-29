Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B999BC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02606B00AA; Wed, 29 Jul 2026 10:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9CB6B00D4; Wed, 29 Jul 2026 10:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE18C6B00D8; Wed, 29 Jul 2026 10:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CAC36B00AA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47C2C1C0EC1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:50 +0000 (UTC)
X-FDA: 85041120780.12.7F98D4B
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5454D40003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=avNH64G8;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313308;
	b=gwt7lgwqxspZc4571c68iHhkfSjkVCG/NZojbRUN5TMVsVmnSXdsjHmV6D6L8g2UjMpdTj
	o4qQ/uMR7VG4PqFfDwg6Y1lmNPqhphVp/WpxXFar2XFttafkTeIdFf22YpG50HuJqnU98g
	2qE1wMlRT7XhRgt2Lpo+DLnQUOFuzqc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=avNH64G8;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kf3hEdsSYCZNTX5rn+lOkaFGwEn2EXdhe7ejyIAKxL4=;
	b=y7FMGx84h3Ek3b9KTNVRRzhdSgvSusdK1JsfTfo2+pxRp8/Zjov8sjJ4dBkfeXr8MLrnfI
	X7rNv1zGW3I3VijzLPmoHQRJCkGWzbbwwE4gg8dACGf8TiZi0h1iu7UqRhOuIee8udpSup
	Z9Ne4q1dofVBU2LzOKYPLaafzhGoFWI=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47f81a3ccf9so507000f8f.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785313307; x=1785918107; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kf3hEdsSYCZNTX5rn+lOkaFGwEn2EXdhe7ejyIAKxL4=;
        b=avNH64G863BQ8LqreMTU5Qs1BOd28EELnNtufI3zMZeVVBDS9gPWPiqArG65ZGfUy1
         DCzHuOh9QT4In0zzP0S5+WniSaeHDFvJu6fF/qShsrKM78VplV9ZwACRt+0u+f75IVCp
         5FBwZtO+j/+aYjbjLuggGOJH/A4jvFTDY4snNzPzPxDADMd8Be0hOKFllG2pBl3a7CU2
         XWNajuwIxiLChhkxZDt/7NYG9wxOCNwS2ePXSyrWp8e7FYJHpJTMoxc+mgf2gouJtpNH
         7FjfNYhY5M8dziODvzF9yIBGc6T4/UGNX+YrzNj/LCXFO0d88eIW5v2hrQGpcsoup3jk
         kGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785313307; x=1785918107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kf3hEdsSYCZNTX5rn+lOkaFGwEn2EXdhe7ejyIAKxL4=;
        b=SCpFrW7BezMpJNDa34z+Y0sFEG/XpR6wnCT3eGlnlJey++fwzk7J1+Ke2o95VwmijM
         KAwjrm3qgewrYgm82NHel2sfyRuowksH62GH75h7ji0UMiPDMIhSBKnrqfILo/KSaVAc
         Jao0XaSqLSEudvbOa2/vMS+hJWOX5uT4pxgXNjcgEOuYpQdVWV9OV1ly4l4ulzLj9xYG
         YFMHl8KNB5hxO2TYHoTKFqj2kaewhbslh4tXUs7ALhNrqhOmmy1G4CxvSPoPIkYJLe9i
         J2CdhRL8a0TGzWD5K9OG2c854wHV7zx19I6hCUZNEr4+KPBhmx5m7P/4t4sAZMwG7P9K
         RBCQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqx/x1PJAC/Rwxvt5iqADCVs+WQUnV/7IaXlF0WeynYZ7EHFS0+3p4B59Sduu7PfhBivTBfFn5Yyw==@kvack.org
X-Gm-Message-State: AOJu0Yx02WJnv7qL0dPH5XrCq4kdjEvyDVhjD/cj5fGp+H9cIiYnOLV7
	Nx6ENb6RGpDMU+vyysZ1MUzz6KaJIfte47hFXw2FFyF7g0MOJFCb3D+HwTSYFhvqzHw=
X-Gm-Gg: AR+sD126Au/QPGGzrNkV2QhQLQs8iNKpGDN+a1kCO8WVy7ql4c4mB9LB9dkZcoNul4N
	P0XfRr51sun8O2eBpllAP60Nh6ND18UuhZ0I455zx89YhfcNwxq62FA3t2eNhaFmsV8gxrPvUrF
	YjN4/gWgKZ6tgWvpHZqCxhPvI8JUCmXiORLjQ0AV1i3GOJDOg//M8Hu52Ohx+cSc57SKefMtvdN
	wfmVTZIxG7OZNcgM88QyX8cwFc4n9D1N/UVEA7mG7SytSuMN0zPGTJTKTR3ULFqKBsl/2ZTKKVJ
	hu6rooRk30yxvOK+7BBPuF3SoYVVX3vIUwQ3Oit/6YmGCNbm0O+SwM9/NETNSEzz+M91lsKYhU1
	RZur93ffCnZeZyrdjZIBXTLmdmDIGbcCRZduKJVz8Aoi9eqU+K8xwnDEPe2eKyk1UYh6NwCvX7R
	vVAA3Pf8Cyhmv6Jbu7w4zAPqkiM3XAloL3YhdB+CSYKHlyFlvefs4WE+LhAny/ueW3aUTy
X-Received: by 2002:a05:6000:22c3:b0:47f:9567:e63b with SMTP id ffacd0b85a97d-47fb1f26115mr7562586f8f.55.1785313306843;
        Wed, 29 Jul 2026 01:21:46 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b0ef1asm5812361f8f.19.2026.07.29.01.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 01:21:46 -0700 (PDT)
Date: Wed, 29 Jul 2026 10:21:45 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amm4GQP90D6Ho6Rw@tiehlicka>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
 <amhZ645Nhj856JfO@tiehlicka>
 <amjeUV3dAn7KPQgK@linux.dev>
 <amkBvRSJm5rgiV5Q@tiehlicka>
 <amkjTk7Jc1q4ubxj@linux.dev>
 <amlkSmMZTWrT4rau@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amlkSmMZTWrT4rau@linux.dev>
X-Stat-Signature: fxhtheeseo5u7456hd1kmft8ranetdm1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5454D40003
X-Rspam-User: 
X-HE-Tag: 1785313308-271714
X-HE-Meta: U2FsdGVkX19DVFJvUZ/8NknwDVYcXLKDLOgQez0UT73RIs4Zyrh8v3n3fhvx/xXaKbMPtkC7jpxu3tbioSP3+uxB6KMblpxoOnRKOnLGzRSj+u9maeuRXbs72/Hg6FOU/VuV1mZI9Zsg84zQ+xLPGHhqycPsgkx1rWFYoD9JnOXvxAMpf6mxNsDBvWsq7YFR8tqVqPBsLWmptRW7C1cladR8EZ8cxS+MUr5VmAz5ucMhLEhXQVLd2/i9uaRMAdsSSPz8h3KbzAenFiLYvdMjESEppJyn0rWGqbysSNDcH4Evqvlmd2H+/wCzhtmtx4z7eBb8+CIHBUWxgkzSuLdpeu36whLw7Dq6By4YdTrMEiZrCEq9pjvZZUGuz9xvKH9w+0tm3sxYYYUuFhrfVaZkkFy4Zpi5Hcc+8Qe20GJ+aB6j16J1xvEvrbQY+I34/SF7tGV47EOElkYSPUVvUOMLpq/V/VtxJwXWFWd8QJK9WnNp6E3TqdR1j6+rIrOIhgOI6n08clMouBRUKt6/nyAYbFl9hlaOp39pPGMednC6e9I7bHAQIuQZK6oYhxX+NtR801l3IQme3qcaRyeeHCsb+Dlm9jpJXo4oMajwaJeWMXQLaCDtyFhaIGSe2vRfwGO1zr4648C44VCs3e4UaQkFIZsLTg2aifSoibvJflGDCCZ2OZM6625q7NnPHedpjw65uK/ZyqZNdJAem4QjQha3val1ryTA6JyX1TWsoZXb/m6fpsA3f0jSVCC7PnS5ZrXF/aSLhhsJusX99+LtEHpNl0CHYMnCrKegX02gtz0wT1O3YR7Qn/kRjzG5C0bgBWR250hHKhl2dJ0hBxFibmzvHsHy5eaLI6jG5aFQ1v7wpDI0e2tBqwyxH/c96O+mNJVtZb7aYNLEn6lZJwGwm54/moU8aPbtqVd7qPPiuB/3CjifykIxyzZXHPtu8ym2lWKsP3FlFXCs/33+lbjhid3
 uw7LkC5E
 G8/wc5Rlh204whdp+ftuNjDCCR7A50GfWnTRKEf+oQwcezonmUh/Qocu1yr9bGZXY2/n7sThyS92F4pI1BaL+Yp9ZynrpLmoD/D6Q72WNO77RKckvpQe8OlKnp5NJmWKCJOfG8ZTfHQh599KEO4uEUcT0YjotxKt4wjDRhNOXfI0c+8a0eiNt8uO5Xr1k8lJgmTULpb5Sj53khRdA8E/jkN8IZjeiD/JXFKpOgBOjJNtquM76Qb2/Gq1Ylrjuau+tYrp+lonSQjMgTcj9mBKYGzLfqGM7vkHshUiBzRCu4aadW5Y0VX4e++59I+WCj1wJ9pPhhGLCX+bGvicPkGuAwQi0SWDB/FfIrk5eizGVwuPy3gSvNVe3vpcCW44VEvYL7jfpKvZzQg6Lqsp1FOrOY/xROkRTMfPAijRWzs17bfVZ6rRvBZNeUNesCH4eNvUv+GT2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-07-26 19:25:57, Shakeel Butt wrote:
[...]
> Now I have much better results. Previous numbers were on a VM and now I have
> ran on a physical machine and the results are much better and consistent. The
> baseline consistently shows ~90 seconds exit time while (tsk_is_oom_victim +
> MMF_OOM_SKIP) consistently show ~3 seconds exit time. I will send the formal
> patch soon.

Thanks a lot for the testing Shakeel! We can always ease the check but
if the more conservative approach helps already then this would be my
preferred way.

Thanks!

-- 
Michal Hocko
SUSE Labs

