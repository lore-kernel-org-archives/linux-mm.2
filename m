Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBC1C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 09:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B8C6B00A0; Sun,  5 Jul 2026 05:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B8C6B00A1; Sun,  5 Jul 2026 05:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3FA6B00A2; Sun,  5 Jul 2026 05:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D56206B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 05:03:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46ABB404CE
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 09:03:22 +0000 (UTC)
X-FDA: 84954134244.05.B1FD2C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id E171C1C0003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 09:03:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aZUcgZyJ;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783242200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yx1i8H1guo8skt2UVrwpIqA49iMJYRdNcjVq3Vf0DQU=;
	b=VjRZN0dCkbKpM+kKFOcC5vGrtXLN8+QGvjeMuGkgwVbFYByW8om4vDg/kaQ2z0sP8oMPbS
	eeLqGFX+wbs0eElr/ZweVnvTaaf2L6CEfGbHYpDbSZ/weAVPDny67QoHye4ZfrK4ujgRX2
	J1v2fLChsrdLKTK8WHYEn8dQa3D45Mc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aZUcgZyJ;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783242200;
	b=MeBNdpw7+5WIwFwj4DfF2s2wDO/B2xsF91p5zqKOHwukpT+vpjgVY669seEU0xJOj/eFsO
	athtf75ej5gjOoNinx/qvVdf+7mOk1wtyPWciS87wno+n8XFjcKVxv1HAebP8p96PQS+d9
	HcwuBTj3sEn4pCsEY7L02Et1m/+bItM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783242199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yx1i8H1guo8skt2UVrwpIqA49iMJYRdNcjVq3Vf0DQU=;
	b=aZUcgZyJxIogRvxzR/TfbhqXPD5WYsScmQoF+ufnqM+ZUW6JKtycrwYgSCu30hKxhoi5xF
	/DiPFgnqr9w94QWYg/KpiU3g1Y3JAp3b6hZVBP6vxEHU9QudNYmKnzflgIB10g1d2chZa7
	5v/pimNk22ik5RO4Lqn9STAs/2vzQVE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-nhO0uTEGMQWW4_lcc5-V2Q-1; Sun, 05 Jul 2026 05:03:18 -0400
X-MC-Unique: nhO0uTEGMQWW4_lcc5-V2Q-1
X-Mimecast-MFC-AGG-ID: nhO0uTEGMQWW4_lcc5-V2Q_1783242197
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4767036f8faso1174906f8f.3
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 02:03:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783242197; x=1783846997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yx1i8H1guo8skt2UVrwpIqA49iMJYRdNcjVq3Vf0DQU=;
        b=Iq/2bOR0XzT3vmClZ13T2VoXBm6Zayy52JlulYIQ4jqBSIboYXTurv21IOtW2wLmiS
         AZ9YG9KvrcbH7MW/6YxnPc38/ESKQwslqxW+FHnYDHMzoG6wGb3E9gsTv9bPxTHlCkRZ
         W/yKTkRFlhNHHc6h4dqcO4086df5kZQBUUPtsbWW/ooAILFp7Pge5X6+GEOtcpSA/V5H
         8eSxOlijxYPxaEkV7qkkP4syG7dJkaYuqQwjKm6GZ60rq3nIJCkGMwM/IF7UpgyzsqdK
         S8nxUtXLNta7L5Qo7Jgpgx3rPCamSYNUm4dgPCJ3QsQITkcLIElgJqiLjcyBFCYoaiKI
         844Q==
X-Forwarded-Encrypted: i=1; AHgh+RrBStNR6A+E5JCgqrRbdGpdpo9kUAJLnBizWpNupdZjnr8IhTwsSbggG4Iir7PWz8BzN5JZVgZa9w==@kvack.org
X-Gm-Message-State: AOJu0YwAWnNDJ+sM+VPTCCxqA6Wp6UI3z8ZN18nDbKwiy58nACtCISj/
	l/48s4F2sBjtrI39aR48N181AQHqt9NIQij0kv3nA4mvBww1FMQYnT84+3hwJHugWZDQiNPP7rk
	6v7rMOVDpgfwyEfsevK7CJZosumxwEmGWzWtjw/IurMIAHs8MIfGG
X-Gm-Gg: AfdE7clDJDJA9AVsOpf8KaBybNMij2QkcLiQFo6nTeT5iVmugLJQSB+mTr2qBLBFYEf
	7BX6JT5bUlzsQZgOrWNyj4HmVIWkK9tfAnVL7CoxlMYaGyhoy4UVl1/TENsRAx0RbipXh1ayO3k
	QFmqEJZ85xKeEcnB8DwdWUMtjSAvh8xcSgPb2WNEPztE0Bielm95F1AwOsncZZHvB5SuoYKrD9j
	eoT4ENSNiykLydOA0dFXTiJvuW3BcwxlwD2hjkQ2g40j5ejUAzujxr7nLf4FEJevmfzEI0SPoIV
	2nv0uL07lbH/F0Kg8L1uhtiqrey7joEa+ypo32/r/a+7ZGzJQzVFTbp5MI+ksDSgaYtkjz5+Jri
	bgEn9vN+P4gQCMBav7R0xXv1riwK2d2vA
X-Received: by 2002:adf:f9c5:0:b0:475:f100:3605 with SMTP id ffacd0b85a97d-47aabe31110mr5574728f8f.52.1783242196755;
        Sun, 05 Jul 2026 02:03:16 -0700 (PDT)
X-Received: by 2002:adf:f9c5:0:b0:475:f100:3605 with SMTP id ffacd0b85a97d-47aabe31110mr5574682f8f.52.1783242196164;
        Sun, 05 Jul 2026 02:03:16 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d6da9sm14391797f8f.12.2026.07.05.02.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 02:03:15 -0700 (PDT)
Date: Sun, 5 Jul 2026 05:03:11 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: page_reporting: allow driver to set batch capacity
Message-ID: <20260705045807-mutt-send-email-mst@kernel.org>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
 <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
 <20260705042313-mutt-send-email-mst@kernel.org>
 <20260705013956.36f649b5cb13409d9088838a@linux-foundation.org>
 <20260705044139-mutt-send-email-mst@kernel.org>
 <20260705015116.bdf3335e9a955f057a6d9c5d@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260705015116.bdf3335e9a955f057a6d9c5d@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fL9q9oXQ3kiBQMUjpiLfX2diJwgiSouK-qtOLdeENRQ_1783242197
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E171C1C0003
X-Stat-Signature: k9sorim7powmykofmgiy3oeru7jp534m
X-HE-Tag: 1783242199-691888
X-HE-Meta: U2FsdGVkX191mm5WgBvPmQkPcwdp/9Qi6xDwQanBwqqDe/XfLWFRvICltKsaqWhe4eyg2jM/yjruAlXd7YxhOxQCjLuMM+1eaMWYErZmv/BQpQqYownJWEqBK1m+LN3oudVanKxA7RN+4eA5YURHqvffVPyv3avmI9xo9w2z8XsW5tOI1Pgko6UbBHRhdAWaYshN3RvJ5pqOzeSNWPTOO2hJQorWoGpiba1QoDJiTIgkMzTUqdaYX5vs/bQH5H5Uq88p5MKFZ/yuzGbRLdgEAF9vV3e+xkvtsrcTUlrxHpn35rig8jsQG362sx+D9MAZVOEwuy7OupCXDmGfqeZ2PWh879qCPBFO2LElYkLFerE4ZPH8p/u4GreuqyknUfAbsQV8/KFtIyT0SE8vZgUcFf4dzrETFo5s3JuBkWxVte89uIwuCbMk5qMmZbRHYhil3VVlWHV5OjKNAkxLWrgSm+UR8YldQf7E/sVT1XFierU5iJpD8Y7vibTbKPSqQXib9FjlZPHp6wDMfmZ/qIiCaT59kDvKenBff1gTYuUXjtWAcWdgbclrzhUuLqY5ZdUj0mSuyNYt2PR5I0bkz8Mg0Fiir80YcMIquPAnMRDhGDM2hNMCGfL0VmkXR+m/A+NQ9GRoWXJptOXlZ1elfXb3BG2gZBqBUOl+jscz2VuHLzmRT+kbB4PGMnEZNXLkiE4cEPXh7/2h9t6WQdgy4joDEirfOu0NVfBaDc8jOqaDE/fpsJZrYu2ICKRp1BAgt/dcKASvHrn/4z9J1WwaaSL5z3ex5ZvQ4+ElxjSKiUsPAJewAfdBI/iPgCJjJc/ZEyItO1PuK9Pc+b9nCcGQw0vJA7yaIMRsoKO0nTA7M/URIQo+Gbpb4/GS2Tz93/vSMqgrWNUhE25QtLsZ6SPXDHX0syF/08qiICZiiXxjWZaXmtLgbwW2aOhb9EADEhQ7nC3IvYcob4i9EZrIb452+Ez
 EyVH3u4C
 hQT0STtPTU1LMo1QK9Yvq4SgnFUUbDGraxe63I+BgbuwBDJv67uVi7oixQ19rC0PYdFTnGCxU5E0C4DsGUF8T8EJ6y4oEskcul9ej45VCdFEVFN7W3Pq4wVGU5KwUv4cKr5nzzAdVFiH0cHrOmHlRjjsRRQw9imuVf7zR2m7OJiy19KMIxFHB7fENJ7fNG6TV5kS6cCEzJ50hVE+Vr4yaDIF2y91AlxBm8CDVPy903gvN7Fl6YcmKlMmVk2usHJHC7hzxbEIuNm4S8NF+lyNjIFGYfK/dA8qngLb11NlCZMxU32k8FPl88R0fWSgzziOMVI1a4E/EX7lrOm8dfdyLC5cKpAeWOHIispZ0NoAcrg9Ku/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 01:51:16AM -0700, Andrew Morton wrote:
> On Sun, 5 Jul 2026 04:42:38 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Sun, Jul 05, 2026 at 01:39:56AM -0700, Andrew Morton wrote:
> > > On Sun, 5 Jul 2026 04:25:53 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > 
> > > > > > If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> > > > > > to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> > > > > > page_reporting_register(), before the reporting work is scheduled,
> > > > > > so we never get division by 0.
> > > > > 
> > > > > Thanks.  What's the priority here?  Should we fix 7.2?  Earlier?
> > > > 
> > > > If possible, I'd like it in 7.2, have a setup like this (small
> > > > queue is useful for perf testing).
> > > > It's very early in the cycle and the code seems straight forward...
> > > > I judge the chances of breaking anything is tiny because
> > > > it just failed probe previously.
> > > 
> > > No probs, I moved this to the the mm-hotfixes-unstable queue.  No cc:stable.
> > 
> > I suspect the Fixes tag will make their AI pick it anyway. But hey.
> 
> -stable maintainers have been asked not to do that - only backport
> patches which have an explicit cc:stable.
> 
> So should I add one?

The "scratch my own itch, I want my hardware to work ASAP" part of me wants
to say yes. But the "decades of experience taught me I'm fallible" part
says let's have this out in the field for a while first. I had time
for coffee, and I'm dr Jekyll now. So no, thanks!

-- 
MST


