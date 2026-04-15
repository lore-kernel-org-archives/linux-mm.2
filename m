Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761C7F419A0
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE74A6B008C; Wed, 15 Apr 2026 08:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBED06B0092; Wed, 15 Apr 2026 08:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD50D6B0093; Wed, 15 Apr 2026 08:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE35F6B008C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:50:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D1D5B9598
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:50:13 +0000 (UTC)
X-FDA: 84660773106.02.7D93209
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5CA9020005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:50:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SW9O1dYe;
	spf=pass (imf03.hostedemail.com: domain of dhavale@google.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=dhavale@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776257411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4tWC3t3xANgqGsaOz03y9MNl8MWkuRMcvKOFAlOirc=;
	b=WerRjvf/RDcBuxxKuz4ze5wfq6+OBtm7d2Alx4LTYxpsaMpOoaAvU2GNWzOIexeD/o/KoE
	9pzg9PBW5ylZHMnd545WJZ88R64xoY3L84njVegIxknE+XGc9S2X3TxhfGz5KeQejDqRfM
	CvXItUK74xWGo7BWYNav6IlvzRyFZUI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SW9O1dYe;
	spf=pass (imf03.hostedemail.com: domain of dhavale@google.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=dhavale@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776257411; a=rsa-sha256;
	cv=pass;
	b=acd0pr5cyPrIx07NNQrX1wetDeFOwSo9X/nV5q5vdAI7NFbqvHwrY/Huq+6lLa3F8Argz3
	ygANnMyPDI6s1cta6mxgLCj6hLRRmJfc9Gc9iQYlzAwjJHE1/nFNawDJqQniajNa7Z24a2
	RwF4y93Xm7VwzHxNYmYAInB6+MJn0oY=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8dfb9139008so314213185a.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:50:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776257410; cv=none;
        d=google.com; s=arc-20240605;
        b=OoDjdUNTOic09Rz5jCLoud4JD/dQoldDoiTiV5Pe1FF+wjgsIa3PpKfkf3LsVFohf4
         dGeZCXe7yJ0Tp1UNBmyFs242CN0dx1XZqcKJ3xTcupOXxB03INZc1PXnSBpqkZRu3awF
         /OCK6h0V1ZWWZT1gY7guLq52ECrRvIKjWpwSdRCedxHPouTYqYCld+lf0I0edqW9dqhe
         U7VhRUax2Evi8tlPA1W7khB5AYtOv7N8DaPQ+oUm8bdhz2sxDrQT5N3Hv1lxLv3wTatY
         /omhuYuvkYea1cCnl1VrqmGy0p8uHULye7OKjX6SUK2tW5uKPwnHOHkNZe4dRsdyYQ5L
         HdVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=D4tWC3t3xANgqGsaOz03y9MNl8MWkuRMcvKOFAlOirc=;
        fh=15ofGgjxs59vGfo4x/6PXIPOXxuuuUMDYREmjKvgvp8=;
        b=ARo79zCpultbmWP11stihmV87G0xYE8v91d+AdyUzEv30NTzjcYZLXbqDsl8yRJP8s
         2/xPetYooofi64T6N/KtoB4YUljAHkEaEQR8HGVeNmo9vKdEkBMQbyJ4xXV00ve1/WKq
         sNucqvjmhuzMhMZ++rtGbSEVXtedozECDU4MKlrGNFa3Ux+/mZlk5YeOWydHONqrVx6y
         PLHwC1owDVotrenjUH0kEecZgd/MwuJvU7pZFFlvz/fG6gtDxw+6cpAloeDjuqjaHcP5
         AYubPC4nMgihb7QSqdXw0UxVRzxCzIA0NFkMrx+v99Ba82o+HQvAJSZbGkSy9lK+RGlG
         QcGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776257410; x=1776862210; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D4tWC3t3xANgqGsaOz03y9MNl8MWkuRMcvKOFAlOirc=;
        b=SW9O1dYeX2HZOoVqOYGkCf2j/wtwwnbcR7au+Hs9i5m4EbegeZ+CbOIRa9r9/khwGw
         FXZmwexVEZpD8oe0mcAArw18ATT0P62dG2dz964ioOPoIOqb1Cw00DOWOkhnd62YiHE3
         /yIccPtZjPzYNGTRzqJD+OUw1dDA1IfTDc0Xrf1/Ub/4HgJd4GtRZhOXnCADvt1XK/53
         XUxl1FItwmi2zHVgXo8plufya1UkVdYPKBx4fmoIco1PD0LSGpTffiMX5z617NcUOR8G
         wUcdkFISJsxNApoWUmp4250snEyBG6rynU01iw4dxHZlIBIKT9whJN4NdE8YTsQLD+pu
         bZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776257410; x=1776862210;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D4tWC3t3xANgqGsaOz03y9MNl8MWkuRMcvKOFAlOirc=;
        b=bDN6O2Yf3T4JP7JGrg2hrrCzy84qeAcIx/BEtzPyDRoiVH7Ue8/3ucnF/xecP/mqTx
         /nyc9BA8IgYI9WeRK8a9cff645AVfAapJ/++T5SQO4wA07igbvzxY/P7w44DSVEIefDy
         BJo4epC49trK99/4HyYydr2+gxtb4awSbKnM+4uw6T5LRlxl55jUl6NHZ5Cxo4dlWxls
         ZPkcLotNuKSVPpij6/dE16/xH598npuHOCmD2UM5dLhIkt5DxQ7u9bGGQQvd0wghVzVq
         xM1lMoWr52Ah1v6OyvX4CTF+xmgFjr7FC/pZmkqMMUZvF5VOcwjEo3ltVivACatRyLkc
         mfTw==
X-Forwarded-Encrypted: i=1; AFNElJ/aYUjU57sL6s8PH8aDG2afsloroaos4Obz6qzoUb6q/4+31+FFgbZoNXLVHVFL+NcgiYIG+hF1Ig==@kvack.org
X-Gm-Message-State: AOJu0YzbqIc7ESdUF1B/WAwh+qvIZh/Xkdb7RwnrVXNTp5+zgNra2Nsk
	//TU94ytQ/YaVohyXTYD5FCIBlwknS0e8Vm4RaFYftPkASJoWEBenYJ6Be1euUG4fOA55nbSVQB
	Ms/L1SIfyCWCYURMF0mArrja488sANszjg8czDYLv
X-Gm-Gg: AeBDiesobOShJSEanj/+2zoo00v+zvbptWVyd3WsoBeH/BlouTo4qXSjOnAFIvc00xH
	TD3gSIoIe4CX99b28wDwIK3F084g28Yhs20ai5uOxWUS/vaKwyYj6C83eqAZe84L9gP0LaVKKUn
	UBvhePBilxlSkUvZKIAXw7gbg9gLrkSe6yjT2677945+2xGO/dSl4KWUHvG5Vgxmb+lK7BS9wYP
	Zi0tFVXiRevFIx021VS5Aqs/ekPjnNHlCyECXMSlE7XOK3u2894vi9q4Kzk1BwC7vgmNs4dGCgD
	NWpEsKiCy4+YX+IHoE+dVa+/azSz
X-Received: by 2002:a0c:f40e:0:b0:89c:ede4:ea35 with SMTP id
 6a1803df08f44-8ac8613e90bmr340193926d6.24.1776257409637; Wed, 15 Apr 2026
 05:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de>
 <adl1iqhldFvJwSw-@dread> <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
 <ad2RKNo2FGhpzJQp@dread> <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
In-Reply-To: <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
From: Sandeep Dhavale <dhavale@google.com>
Date: Wed, 15 Apr 2026 05:49:58 -0700
X-Gm-Features: AQROBzBdnyNeg6M7eBa34eLrstKbL-D014vWbc0uebEOU17jGRgdz997IpSMUAE
Message-ID: <CAB=BE-SObq4hSO9s36H06eVtZzyj5OBPKJSOOYGJDDD38URN8w@mail.gmail.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion support
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>, 
	Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5CA9020005
X-Stat-Signature: sgwgup1tdy7d5ni6uu6ra71kkgxwappd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776257411-654940
X-HE-Meta: U2FsdGVkX18WqnYfrng66HoXz4y8Q7/h2U/hhpNGAX/B7fa0GnhY04Saox29kSK+ODlTsQzwZXTb/zVaDhAoxBm2KgIgVRanVOHibU5HAkt8awMGOlBNLfCp3n00ggbwvzh5GWZNWxFx7eaWMHyF4sYjBSa9e9wXwNZn5n7YVbBTyt/At8alNi0oX46pOz5kLJOjiNupXiGoGy8a6rFfxOhhLPvcm5IO2n2Xb8hrj9xk/GrvuIYnCgtjFg4s2glUFbr4Zvbnr8v0xmUVCv8cz1LHiMYHHfey+J6L9etEhwpGw89LuSPlOQdyadshegulPtRITLGoCerqtG7KCWdTgR1tNjcVQgfTKtGPqszQqW5Fufysrfs4xnr4uetF7C3cySb0JRk26/BgXqYLFhyuzbwADaVxGTQJsCCqHaHKKr5wVFz03w8zPCsrWURDW7A5Bsn0x/IQAR6i6Pa8PM1iUawXtmgcFyIC6OL4RmHqpELqxM+bbySrOHx5ulVf8MR7gE8ajB3F2uZKe4aRTn6AvSirYhEzD752tP+3JQrdF4Bfs2NdrDouXL+P0Zaxi77JEsv1DOH2BNBlX3RRfg4wz2yIRxBD+2DfXp0Jd+fGUPZWpACbWsbU8UKn/bLM/Am50HejTT47IEfFzOwhzLhNqgAWmkiGQkgarb45doIEVb0Kf6aauHG0TyNrJ40cQjaJ+J9gmlJjqSAwYxopyDFt11aLPnec2A3A0FsPpTGlqBZ36Z9V12V28pnYtTPjo7VLybJAL1Y94qh7ERvYXLEiYr60uZ7A9Dreh7+j963x+XoGPvSqhtTZhcxNxv8PSOQNNBKiHZipiv3h1OEXTsRkZkbzrL8hV3+5ErK5AH7cVVRTA5t3MOxx1TVgQjMZAsfjXvVxPf8k+j/GGDDTxCjX6V2+PxIN5thH7MZlom53/UOEamvwggn63+jq5KIKT54T2iLSTffQlRLBLwVmz3n
 isJwysY1
 T5lXxhCX6Naw1SoQjMG6RT1i5dPgi4/AMRDIePzL9FrlHqxbUYjlbhP3ns1lrH9ILohVCIPi2+uAedmlR1Z9/ZU9NBEfBSSEG9f0HR8FSjLtZR+qcepo8dgqp6ljHOgxa6rr4Ri5jvcz6KX+5cLjTNdGzyY5PecLKQUgLUOkoAOa9rEKvu/RFOoPipUR1P8nUgicMIv53j85FOgorn6RU4ryJNf6rg41iaL3OWAcySG4m+HE+oMUD2yTyEufHK0J8IHHmMsfg/WbyZ6Uz5FLQEuLnAxRcp6on++9J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Basically what we want is to get a non-atomic context instead of
> using the current softirq context for read post-processing and
> switch to the task context immediately as you said, because:
>
>   - Our post-processing needs to work in task contexts since
>     advanced features like compression deduplication need it;
>
>   - Even regardless of our specific requirement needing task
>     contexts, using a dedicated task context for read
>     post-processing is much better than run in the original
>     softirq context:
>
>     - Algorithmic work could take extra time (especially slow
>       LZMA algorithm could take milliseconds on low devices
>       (however, we need a common workflow for all algorithms,
>       including fast algorithms like lz4) and verify work for
>       example); and long processing time will interfere with
>       other remaining softirq tasks like sound-playback
>       / network softirqs;
>
>     - If it is then deferred to softirqd, it just makes this
>       latency issue _worse_.

Yes, this was the reasoning when I narrowed it down to per-CPU
kthread approach. Patch has helped reduce app launch times which
has a direct user impact.

>
> But anyway, I think nice -19 can be evaluated if Sandeep have time,
> but such nice value should be set by the filesystem instead of
> the userspace since the reason is as above.
>

I will find some time to re-do this again, including setting nice -19.

-Sandeep.

