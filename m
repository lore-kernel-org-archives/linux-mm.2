Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8CACAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792E78E0011; Thu, 25 Sep 2025 05:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AAB8E0001; Thu, 25 Sep 2025 05:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6801F8E0011; Thu, 25 Sep 2025 05:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 548518E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:50:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 087DB868FD
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:50:10 +0000 (UTC)
X-FDA: 83927301780.04.6CF35FD
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 023AC160004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:50:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="B/JWT4MX";
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758793808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5SA3g2hQBRp3+0SVw+2Pl6MqDgnXN3DQ33chnv78LM=;
	b=yAUnDFX1SY4RttM4VNMgi0tUkKHw50mbPFfLphmTe+j+XQ5vi7W4wEIGSgGcqPbUOmW2is
	ZI3m2iLdkPEr+ChOjKABfdy+Pg1shy+N5nfhrpNmbpSBuziQneiUqvYlihuwOw/L2XOcPi
	CNVfM68kupKu5q02JE+2FcXUIaoi0/4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="B/JWT4MX";
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758793808; a=rsa-sha256;
	cv=none;
	b=5NGid0B5rNg1aHxbJVHoEBrgokFml3DnWwwfRiQDpaqmHaF5krctfOQkbISp7dOSu2NfCY
	keERXyqmo93We1QlQp6fAPFxde+2O+mfnmFyp+iOm8hfW0RtJHBkaF8S1wNYBWBFWCyySr
	cxsPRzJJu77fdGiaT55P/bLm3z+DsF8=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62fa99bcfcdso1531736a12.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758793806; x=1759398606; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5SA3g2hQBRp3+0SVw+2Pl6MqDgnXN3DQ33chnv78LM=;
        b=B/JWT4MXTBnIXB/COH/jC/FZ3EZwkZQMjzLwW6Avry6Zf/L0N1d7yPu3BtBaQ3AN+Z
         EWb+ZCqTVj0LaOgZOQlZVdJAW3IijATUJsjEF5e1RS0+yKgOA766C9SHmzMrNytLKJ/d
         +YhwM6X2AjBtNNS4sb/16Bd6qRkmFnqgttl8oE6YTZZ9XUuLGB1OAmiUkEbOsJ3JCDe/
         OVefo27v4k2gFtl0splIy8z+Lq/fKqn3s3TkLTzosZt94cBBcg/tBOv8lnStO6ENV4ww
         iZRvcJDPdTUWWrY4wkgcRmcZcq7TTpev1NwkR5CEtjq97M+IfxE/Rnuui7fQ/xYF3p5x
         q46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758793806; x=1759398606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5SA3g2hQBRp3+0SVw+2Pl6MqDgnXN3DQ33chnv78LM=;
        b=ObZCBk4TDBKt4bCqf3NqRfMguxfkFZYdm4q6TB25FmvKo3KjXQCG+X0icBGlyUW0T+
         PPD3HvoikCKs2LEp2uF9WZmGZmYntJ0YZiLkvx6YnQ7wZDZPwt0KiVBv9WqczM3O0oT1
         OWYiDNIUlYm6VFHq/6KGs335dIom0IpnsaunF2JbtMCc0X/k3/SsbUgkqu1Nmw4tkvkN
         6SgDypUBlXEegMq1X5YJCYOSrpsdOjyMTBi4mI0XR82boNTXUfg6YGRGvcVKXGt0X7c3
         6NPGpQuHf0Hs7ScMyQomLBHTHwaex3eFAg/S1uzf99FBQdaDabS9MyUDAXjZS0lAJJ9Z
         koIg==
X-Forwarded-Encrypted: i=1; AJvYcCVwp2kx5p8TQ8JJctTznXjyp23rWQOfEdjCgrM3jjQLXuwvw0duVeFBA4G+tmWXTnFNyPbJjYamfQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2GPno0Ib1f/yV7wcJQ8cP44NI5Pu0++oXtdzqUa5f9VJcHjDz
	D1BTNjOdsFa7ptjugIOdX5MEi7EQNYJOImG/bBFFTzopRW43zTZ0XC2Kcis3K3N+Ze8=
X-Gm-Gg: ASbGncvthHlKKoySIf5PSuhfbKJ9xQb4rJHLmhrHUBB+mSpn1llIgI6qZ37YNQ1XsYu
	qrNar6ciwUUvmxqQFfwF8ukxHwOx8xf83rdpbxaeYBbHkmZTyS7befMUQd6sqXKWrziyWpQCqaA
	NuSHXm4VLORVdndQ2JW/8v91GSb2+Z09/8Jl1+tP4UJMZC7UQQr+7GOcOWYchNnKNr0E+HDZADl
	P850iL8jHZJul2C5nD3fOwTl8P75otrjRmWZMq+wdFdFo7fsvsJKMhWYKCvV448FKwv5ArIikVI
	n/zvNNk21zqYwkAo4KM5dTX8YyQ4VslOb0/yqpPZeHkRcznih1hVoyWLfjj3tWQ1bmHpiFvNOfT
	/Pox0vrR4zqV8E/O94gqPaIbkv17zEe1kqLox+hxmKzYY
X-Google-Smtp-Source: AGHT+IH9J3+c4EKdcxiVY9Hfp6apDROPjd2eZB/SeqRqT+QwlKjqPeubSM1X8lONtRMijE3JcTCuLw==
X-Received: by 2002:a05:6402:34c3:b0:62f:f910:35c8 with SMTP id 4fb4d7f45d1cf-6349f9fb219mr2048180a12.9.1758793806202;
        Thu, 25 Sep 2025 02:50:06 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-634a365093asm952264a12.18.2025.09.25.02.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 02:50:05 -0700 (PDT)
Date: Thu, 25 Sep 2025 11:50:04 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Message-ID: <aNUQTDkcbvImdMgP@tiehlicka>
References: <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
 <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
 <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
 <aNPW4Ynrxyn23Ko8@tiehlicka>
 <81a827ce-24f7-4038-bca7-c96dc558cb38@redhat.com>
 <aNPdkABVUvJESoqm@tiehlicka>
 <d21d6cf4-404c-4a28-aab3-03974eaf806f@redhat.com>
 <aNT5y8k3ZDHbQzyN@tiehlicka>
 <d2f51ba5-1f3e-4a72-89ab-23a11059d971@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2f51ba5-1f3e-4a72-89ab-23a11059d971@redhat.com>
X-Rspamd-Queue-Id: 023AC160004
X-Stat-Signature: un6f86nyzxnonemej848c4fin7mr6yd3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758793807-245829
X-HE-Meta: U2FsdGVkX1+CF2BI4suifthz8QW29u7KEy3kTp+AfkL6QweqHTw5fz3nroT03l3OsJY5SywDkvHUQKcnOBzIRRm1sI1ai7ZGRPmBbBnkz3fT6hjwxFuVDTaPVnY4b/cA6CNDisUrL18ch5Wl0AMGu9beog0hWW71ZIh1LdBbGhAoivve9n0vDEw3AMWzyJHc8a8sUso5u2/1QbZxvDjpcl5UA6Lu0NE5ibQqLkHMjeed8hHSvAx6N03GH614MxTcIEoxA1alae0I5zgAFa9k5KULH1q/Z9CHDWw1oaU6aLiQ96lcRT10xKMbZzjWtCD9rpu2Fz6mg5jE7kG0s72ekw7PX4yvQk0w2ANwQithu8GqRTgvCoMOQSp8tfYRr7PYVgorLn+bKDXj2nf9AiBAjBt5I6QG82Wn8QD0yJ4soGPdJQkp6X+1FKMrPCK+kA+vhZDwLvmUwTb1ElcmSiOZyzTNWDJRRKmsgYCpDqQYx0gNKUfvOLGoAL1lwTUnGo+QZDMnzRX61DlYzC/DmNI7Z2c54ziV6uhFJD5udaON+RW3ipPqy+wlFTVGU6BeeEhHNly7QnmoxH8awLnFXhnp/Betfe1dZUrkMnkJJEmV8juj+Hbk4xhJplE56G9zBt63nd41dFtiIjdIB0ohShDmWPR1rs6oF4ZQ5vF9HPp48LbfC9EtDa/2LG4QyjSsX0qFpNl+6V9TvBm3zlx/aVpyKOM2DQYhXJufBhEOD6SigW6lfJtTni6PFWh+X+N1CCYjA8SR4ZXsaVvRIBXNUZEhISaP03sF+LBM2N9ZfuL2ybCBYycArDYHqyRPhnKyqyK+2+U2a6fo6QZl49L7oJxYxMBbTxFvHTnRt94IHDXzzjhRqSKO4v+p9GXnpH3RJywoICaweeqrzTSphss3a7AP3zA18K/NWCkWGWBgz+RDw7uZnNRi8NL4qn0ILyPuRcjFylaRV1VpUkKOWVwdSUU
 GWaZzNop
 0yeyKwUwet6F8ukJcouyEW3/Y7fTnzsRioKUVyv6bXNcHj4YHGrT7a3qMO3BpiB+XT2sRP2V9nVjTSygryD4aoPSrwMTGbeVCvZfFZfLX4n9O1VNkh7u6lcS9zRVmNMF4kmKpJDHbScJLpkREtakFvFv/+sV22/NHEQ8LmFwZgxdncaA6Y/5mU/j9paPt5KN/TmT7oGYF79XAQqMpZu5AWVprT3LP7Irun5136PpwRvioz3vpFcvepVUOSHVGlqz8Mzh5vdty0lxFIw8EoAhQf23gHBFUF+q0s8h7M1nuE0D+fgn6QQjVhCMMTKyvbjKFu/+kbRBMarsYULM/eWNQuB1R90F2iIQ7a+Vj/IwqZsTdyH3/nSr5OOBjVYVLSxXmioA/Ahx6Q0Mh3+VZerHvo504j1T8atY0vZKsEgXVClhNXCAQKjSrUXC04A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 25-09-25 11:22:26, David Hildenbrand wrote:
> On 25.09.25 10:14, Michal Hocko wrote:
> > On Wed 24-09-25 14:19:37, David Hildenbrand wrote:
> > > On 24.09.25 14:01, Michal Hocko wrote:
> > [...]
> > > > I thought we have concluded that there is no user expecting a specific
> > > > alignment. Or have I misunderstood that?
> > > 
> > > We concluded that for users that don't pass in non-power-2 requests.
> > 
> > Ok, my misreading of the discussion then.
> > 
> > > hugetlb->folio_alloc_gigantic()->alloc_contig_pages_noprof() certainly
> > > expects a suitable alignment :)
> > 
> > True that.
> > 
> > So effectivelly there is nothing to be done here right. Those that
> > provide power-two requests will get what they have been getting and
> > those non-existent others
> 
> I think kfence might be doing a non-power-of-two allocation. TDX maybe as
> well.
> 
> But neither seems to depend on some alignment, so all good.
> 
> > will get whatever as we do not provide any
> > guarantee in that case. Maybe something we could add as a comment.
> 
> We currently have
> 
> "The allocated memory is always aligned to a page boundary. If nr_pages is a
> power of two, then allocated range is also guaranteed to be aligned to same
> nr_pages (e.g. 1GB request would be aligned to 1GB)."
> 
> What would be your suggestion?

Suggestion to self to read through the doc before suggesting editings
and suggestion to the patch to not do anything.

Thanks for the patience with me.
-- 
Michal Hocko
SUSE Labs

