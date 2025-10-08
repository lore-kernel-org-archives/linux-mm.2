Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF591CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 07:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122068E0005; Wed,  8 Oct 2025 03:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9BE8E0002; Wed,  8 Oct 2025 03:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FF78E0005; Wed,  8 Oct 2025 03:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E455F8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:52:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80C4111A1AF
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:52:56 +0000 (UTC)
X-FDA: 83974180752.14.FE3B391
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 751B640009
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:52:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AzWXa9sD;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759909974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76QnbLWvvAjycOQTQs6+GkhYdZ45i8Lt8AzKn7SU3PI=;
	b=tndReF33T70yuteIk2FpVMmJ66PUuKn/sX8sRY7TnW8WZsLHb7wL0qMS950mU6DQxZv6lT
	AKRK1M/T6z1ex4xPeGcW2YC3yhLc42iIFuySTw9R8tXHb/DH0I3Hv5qutHzeQlEfxxHnYb
	22WUuOr739nR3OYqGI+B30GxcFGNcug=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AzWXa9sD;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759909974; a=rsa-sha256;
	cv=none;
	b=5AGZz8NYaFtzvWzPF4/JDdeQucyTC68EMY0zyIj9bsRhnvi4tYaUN2C4oyqhUtJ37lI0Cs
	fvbbPlq2fcsFCkiduizdTZ87JIxYET+tFDbE3mDB7a/RAoA6ZBfmAg2enMzyf1hhWO5lrl
	v7hkBl06uqaqwD4o4NeChbWSqZT0+XE=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-637a2543127so13164230a12.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 00:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759909973; x=1760514773; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=76QnbLWvvAjycOQTQs6+GkhYdZ45i8Lt8AzKn7SU3PI=;
        b=AzWXa9sDwpNLkNnMnPjXeAxmN91h06UMxcR8C/Vb8GwJOSMDJsfUqlPjxTtKIFuMFq
         3R56se+Z7igz0y6CcmmpNPdYAH+LFdG6UP3b9Gf0MUBYXmX0DEIvLnZMxOrawej3cwHy
         mmJGTjoOBcLp93Uos8RPBDCxtOmELcim58/66ebEPgEo3xPixTSuPFkTuTaRDr+Udc3n
         wMMdwA2cpZk61imCdodpJiLg4qLAd9X8NUJ5BSrzoio9IONd7+DU4nITqXQ6QmfRrR3l
         rdxeu2Kppl/65N2QJxkA2thznc2Dojb5Ja2a3DAfNLBe01i1BJixlEfN/8drm6R1w7+f
         8cyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759909973; x=1760514773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76QnbLWvvAjycOQTQs6+GkhYdZ45i8Lt8AzKn7SU3PI=;
        b=MTn3sIv5D8xQinzQVaopXWBpzjo7rCcAPjuHoOaaUklylOEDPzcetyM89hQxYZGBkq
         4bdpkK+0A7+Po2G4ieVwzgSrSFSRp55cGgDcHd86oR33pHAK0cA2H6FNZYSt7JL98e4x
         fJkEy27VFKsSu4A1xAPHZgksGxdJ4jZSmjabFA5OIcPd62O8xeYenOfB/BOaMwzb0LAB
         mbGNpzEm0m7YRzgHsijx5KaXJ/q4f/dQp+0k7WFdGnd2Zwdx6BwGmoWwARRwZ9Tbp1ww
         ljgVcnMfog82muIl5GkQ0rm4FHk66dIEsVpHRnPOqPgo23Hgc7c8cHyG75+/6KDgMFHj
         hYVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXubPYL/rgoGKmgDp0kxU+d6LYzYqAf0vmrJJb+2LTHMyIz/Nr6H376H0qeDc7LNe/GJlYcdySBfQ==@kvack.org
X-Gm-Message-State: AOJu0YzZL1eGK8Q604ZsBNt6sN82coA3wpwZLdBt167da/H4qXowWNxq
	ZFxpVCkhIvfUCL0pUVmIG3S+D+IAOiWmscnZYoMxBONFCOTBr+H54m2SD32pNP8cv5k=
X-Gm-Gg: ASbGncu68D06PK0tRW1h4Nq0MltCpARuYUE68NJivbpQNTd1JTdfPlofE7DWXvmRsgA
	UWCWpRy86IhMUUSjafqWRZfYavqHENldZRELVTUu7b4iWKo7LeL44yv+hzC7xvLBEjiheXM8FGU
	o2I+Ro1TOyCxR8VPfuwihWd1yOnLA0aiXTjwgaLKM2z629+nF581ooj1B6L7Bs/l59AtqtG8LhI
	9jDvY7jpTFZXb0d56rfOXpjdmJzNrxSFtqRVCYZAG/4DXpHZ4zeBgF0QHp2NdvDHxZg4Ce06ZAa
	cJQcYnc2meV4aIMxhze94ZzusrJqGE1Vd/IYDYca/ibvWjNMw6eSsm8beVoC2hPz5AK0I2PsSnz
	CeR7fkpBF+5x4IHfQY78pWaDRvdv/mYCJIuq+4PAF79FWp4n+OAei1kYV6hDc
X-Google-Smtp-Source: AGHT+IFoOZq6N7Iwj/6V7pGw/Rx5cypjgZ+gwJrqYXbaYR9kCiceJmXs/lMpayxUdNMqlbM3FH5Bhg==
X-Received: by 2002:a05:6402:2787:b0:639:e04d:b0f5 with SMTP id 4fb4d7f45d1cf-639e04db6f1mr876777a12.3.1759909972798;
        Wed, 08 Oct 2025 00:52:52 -0700 (PDT)
Received: from localhost (109-81-95-234.rct.o2.cz. [109.81.95.234])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-639cd144d13sm2491125a12.19.2025.10.08.00.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 00:52:52 -0700 (PDT)
Date: Wed, 8 Oct 2025 09:52:51 +0200
From: Michal Hocko <mhocko@suse.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, iamjoonsoo.kim@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/compaction: some fix for the range passed to
 pageblock_pfn_to_page()
Message-ID: <aOYYUwyt-v9ivU1g@tiehlicka>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251007182922.4a254daff78633b1452bdcc3@linux-foundation.org>
 <20251008023218.g53gm33vmrdt5nw7@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008023218.g53gm33vmrdt5nw7@master>
X-Stat-Signature: 8tsm48ft6xz8yjrnnrescd6qwrerigqx
X-Rspamd-Queue-Id: 751B640009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759909974-691159
X-HE-Meta: U2FsdGVkX1+yeqJ9TnZVbNC7diUSfGLKRR0XbFbXD0rgT5NyIhOi4cdKFIk4EjXHCAZzypO0eHmbh6FZnoZ41JwPAGNmnSJBKKURxVoX+nJ2vO7WhsCoy4JTVUvly/Z7aHAZx27HAgECyuRSG97E+bfDFxQ5AfWAOYmAMfOCRjarhmY4mzuPT/zDnBe8wOaYSi2ht10MjGv4yWtzwlT+bvcy2rVwG8dcaQmignl9BijlZrquiW05vkvii/INSgfajkGNUqH8N7gL9UcNSi4imyJQR1/vOE6q9EwqVZEtANB3PE/MA7ZE2iZFbcHUcrLQv8mC18E4xpfuLSmwap5bW33HvY99J5HRtg0vFPUCDsA7M7MMR6vBBkD9/UN6xK2UuiEAhbLiQltWCL13PHxpKMSxrGtZDrYWWgbp/fJIcGMlg6wXpuIe2givbqRzmPdSVqq3jtJYPEO8vpB5uC+KCaTQmmBvtO1Yf5LURqVN0LGKZ95N5FIYsMM6+lkZXDIl0lswDey68whX3cf2XQqBoC2c+2YnqmsM6vEuREar/OvyhlD2q2J3gczD3pQx+0z8nbiTDSxfe5P9poVMpiY2dJVD8OAFYGP7vfSds2TphSu/0RRg8CaPUjcZaNnkdxazJaHSC5WzYhMkSId7CRJ5dTzL9H+1fyKCSkjiOcmcHAY2+WLJ2DylUg/+rLodXYoZ4/nH4/SgvwXTel3GtUh9rVcYkGahUj91l/RUDRttT8gWSg2PxR4dRWlJjInCoxbWyPRyuLavDTs89pPWHQaAljk3wIIUoUq6Heg2AZpyPgiWFIv3EztpsT3ymDvtc7CBjU2kl5bsNyyrL/gIDBhRiEnbrQG1IGOLBp2QUjPcHMnVB6lEipsuHKtlAGxl/2znIHHDEZzLXk0QRtW9FvBxpqpZKUIj7tt2cf76YidomF1FR2cuNFOm8LC1zH99c/ug8C0K9ORLTnOKhyEmH2S
 Ul5TLQpW
 9K+aEHt0C+eeU9TtrnjksjmzVVuuytETaap44IMuBaGdRyCFWj2uCwRzLYZyRAIUqByRqxy7P+83B1uzlztjrCHqjO3EXkoCBFhYyaZ15dgLjOSUZlKeVN4gbJJWoXtAkyOvhVvcia0YQ/O13yS4+DBeq7rqNV94XBmDpdEsA3K4vjZEXpHZJ7Z/pCOkt6G2eYtA3SqX6Nt3dhDZNkyYX5g2ehflCDeJC3DPj1TWiL0O87AIVplQe/QDYNoiSUK6AvgeeyN2JazaQNal3+KlQUuoTS85eEKSBOI1YxQgadWgXFptsjtcGbvwSQGeLn6wtAHNTyFEnlZIv2ATBIv7z+rUTnOhrTqeDvRtrMBbn7AfeGi1TMbKqC3CENks9f+cw9/2hgeK42fpo9kLlzM42p88yuLC4jRtPnFxSK0V7UfKOdhXdDZgKQJVy6EisI1ecfQwnvzX3do7dgFUx8vIbWqlooji1wY1UskcizqBtf7tBw+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 08-10-25 02:32:18, Wei Yang wrote:
> On Tue, Oct 07, 2025 at 06:29:22PM -0700, Andrew Morton wrote:
> >On Thu,  2 Oct 2025 03:31:38 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
> >
> >> During the code reading of isolate_migratepages_range(), first spot the range
> >> passed to pageblock_pfn_to_page() is different from that to
> >> isolate_migratepages_block().
> >> 
> >> This implies there is a chance that pageblock_pfn_to_page() thinks the range
> >> is in the same zone, but isolate_migratepages_block() will isolate range in
> >> two different zones. This is not what we expect.
> >> 
> >> Then I found pageblock_pfn_to_page() has an optimization if zone->contiguous,
> >> this means even the range is across two different zones, it will think the
> >> range is within the same zone.
> >> 
> >> So introduce two patches to fix it:
> >
> >What do you think might be the worst-case userspace-visible effects
> >of the bug?
> 
> I don't see userspace-visible effect yet.
> 
> Since I lack the knowledge of the consequence of isolating cross zone range,
> currently I can't tell the effect accurately.
> 
> The worst case in my mind is we put some page on a different zone's freelist.
> But I don't totally understand the behavior now.

Is there any actual problem to fix here then?
-- 
Michal Hocko
SUSE Labs

