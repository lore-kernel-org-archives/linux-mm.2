Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE35DC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A296B0088; Thu, 27 Aug 2026 04:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAFA6B0092; Thu, 27 Aug 2026 04:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2A56B0095; Thu, 27 Aug 2026 04:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD106B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:24:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 724C740354
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:24:13 +0000 (UTC)
X-FDA: 85146361986.11.58CE34B
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8F67920002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:24:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BaoaDNFR;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787819051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53SA5jsB14fklHtRYEmUAlSS2YNOxZbTqVCbUtQsPlw=;
	b=PXD1y8pBVHJBeEs8G/eIVwI1ksdk5KtHRxKkCmkrfxcU+OClJlqPIzS3iCxMSiXhekQa5k
	ATIarz2VP4o34xGh0JyqlOYbiC2xdtajBfw6hI8mYzX4Hr1SOe0C3y06YVVgtB0couwNzW
	qD3R643qLR217dGG+H8JFkq3BtTQZKo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BaoaDNFR;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787819051;
	b=AnLTMMTMEoz2p8RqlpMWmSqkT7CvfPsp4RluWWAlfgELkZ+Gi5VM5OuUSu/0v66SoSe3gA
	G6cywXirhYYXPbbTT1s0Iccoumh+1NvgN/UjK4G2YUTrqLaqefqi6qrTjx4hdp3lGzs4UD
	+aT7wej1VYpsvrGZ3vN6p/a1npmT/kM=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d71d1cc8b2so10040245ad.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787819050; x=1788423850; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=53SA5jsB14fklHtRYEmUAlSS2YNOxZbTqVCbUtQsPlw=;
        b=BaoaDNFREEASxb0bUZLdfIKXHjgj7vc5mDym1paGIQICcHIpOQ5fh3aiGLxzBYPmZ/
         HO4lbr0rBdEXuhl6SiVckEM9jeYV+arERQgjrjvUCvv2iUn2eZ75gNVHfFWwgimGq8ui
         ATLla9ATHXlgozXjppfKBUkmQ4Un3GGxcnlvznYKwLQJqIOlAS3uQ9tiyowEqAHt+q1P
         9tieJxSWCTLZUL7cWL37okfGzOS6YnL8tOmdt8sCzEjgAVgk7Gxac3pbspKRAjOHcKJV
         hJLrDinS4UgF56EmIsOur1etTmDLAmx1Et9bkMjCPpTkFOdnvcD99O/M0iuyfJmEfY82
         SLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787819050; x=1788423850;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=53SA5jsB14fklHtRYEmUAlSS2YNOxZbTqVCbUtQsPlw=;
        b=qP9fXGBBvzYwxHlLPQWXBd1NmEidP0q1rjlrIm6fScjX+6OHOQ9+Ip3Wm4jPzhoD3L
         KnMsEsNfXBAkuXk1v+nXbxldTH3KBWys1fz2zfuHscBAtP1Td3CBp1X2e25+LC/hydOS
         MNm3gEKvpo4bcABUfg01b9SemT1PX/5EmB5ArrMIZeozcBAGqg+5C9Tuj3EBkQCeCQWR
         ofPPWeUCdouiFBH6qI8pK1vvv4z0B/0A+2mabraD3WES4OcWvQAK7iELHkSQqa9sgpNy
         VbM5rE/6nFq4fLhq1/ajKHiqfoLrfxy/0WsKNR04ANUwB/0s8aUdL4muHP3yfqCrDEcb
         t6kw==
X-Forwarded-Encrypted: i=1; AHgh+RppnbQ5p8mBPtyIlI5hrTXDUXlG3Mbq0qoOScTDIPazir8hvhlOfB3O9+Y53YGQptvnKht55ScqrQ==@kvack.org
X-Gm-Message-State: AFuF++lCwEeLuE3Fnak+7acDC0vbVBbdHTby1KJHNUYXLbevq601Gz99
	j+yR7Kr3/jFSRFNG9HcP9FLiXshnqoK60Vmnuu0zzv+zWcEyJXvevs/J
X-Gm-Gg: AR+sD11UzFQsggVpqy1QsLeHK96PTLUGAwY2XEVLzElqlOZnchpUk7wvjlatbsGSBd+
	fn6S11yg0ss/B4Ika1ZUP9JwkM07Z70R2DEKZH0/ILo1kEtkSgtHOM/m4Krr857Oo27T9ASX6Tx
	YdhqiKcx6PbRH6XdsuE4+QpQX46ihI2QWMJMIbGcEhrKEsm+ZG5oiwNGsKo5SeNDUh5QO0l5Kre
	bkX4CrfTOeyAqAyFw1MPEz1Af5WbUkGpxjNZySEM8YeE00i1nsmjpn2dEYjcmrXy89pBlRZHCEY
	UHbL4YLPbj2prfdW00DaYwjeM+0btgJBCMoUJEJKv9KhH37oqZL2L0WFRrsEiha3Ondjbxp+69d
	5z2w0JvEU/GHH6LzTl8j4k+lKhQhkRIV/IO5QW8oBwqZ8obrHuEsesarGIWMj13oVBczGU2O+j+
	OMAFnt8MkJgQut4dNZ6FTqAMCWQTZvVGjs6EPSsTm8AHhS2ZDemcuGtIfkWxHyzyrai9mqQ9fMs
	Nis6mds0w==
X-Received: by 2002:a17:903:19eb:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2d707bc0823mr263048885ad.14.1787819050220;
        Thu, 27 Aug 2026 01:24:10 -0700 (PDT)
Received: from localhost.localdomain ([142.91.101.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d70498d74asm14491125ad.29.2026.08.27.01.24.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Aug 2026 01:24:09 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Date: Thu, 27 Aug 2026 16:23:27 +0800
Message-ID: <20260827082352.26769-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ao7Nr_FALfP7cTY5@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org> <ao7Nr_FALfP7cTY5@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: an8yaetcghrbf4owd377oadhpsidi65c
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F67920002
X-Rspam-User: 
X-HE-Tag: 1787819051-284419
X-HE-Meta: U2FsdGVkX18y6Cn/eawtddLi7zXvR05D71ZE1SqMyJRbIkxuibI9+J8z09NuCy8Q+UGrK5Io1xguTnsRuyyAkGPDxTDh9JaISvqP16fQAdcOz2af1YogJUpTq4UpMrrBA6ykJh+/XQrDbG/hYih+uMQ/1nMncDoy5m22L+6XV1LcFDAgxlxPxdLAvODt9nEGZ13uKEYX4tyJj2+TFwnQW0bZ5LFBjkdeQrG9wvinO58bwNUXbGpbczFkr2/AUfzyfXKcVfYbRHLywPwE8QRjiXh/t4EP78XLTmE4WJZ3DxRVBtDlnrMj9lh2pPWh5iCEKDg3/6Gg0qML0wr0Vmhq9elYT1A/V5CUuv9AK+q6zG7acofGyPuoXIjMr7LdHQQav2o5ZRFy77WIfI+GsbSfUwrPyEwzflG1WrC6UR1uQZtO77l2Q24Oo1HCHWrvuLvFuygQa8p9yhfx5cijV/OTui1d+r85yEN1q5vtLrKzFxovOS1ZHKUVND8LuwK7qr7VOz5gg/PlaZ4+kq+Qz+KjA6aDEFVkSG6DIqiYksvRF8sPL0EQaNirfDwLw45fpW+OqdwK1+9PwaB/FVj7m2BIYKmPdzs0dCzXvWJZJAyTXnWLhhSF28+WLMgDk82IS/q1vk6QpbDqOwlNGg0bDtSOQADlbp9uiQPYQcktBt6KgnDUUhdNWhUvIxbMRoQ/frCVU3o5m7VfPKr7oevCo9ZuHYAE3+qiJmLvVgoQi9TEk0dGPi8Vdx1n8/REXYU/X5jRuCedmJ8PQX+8Svi0/q2WFdC5OAYXygMo6vU21R5Iemj7RzJktP9EVwOwiZ9w+N5vVOxsmzwuP4Km2sVgVrJhbwjPXizbKjmOpTZDbMxwQxnBNuzd+rE1zZwLOGIw1FcI8U/ZW0s11TyWijH0s4EU/fBhVWQvAZ8I73VV/Q94zIEcyiTsplQcGhJgtLvuV3ifvxs51Nd6i+/dGY2evt/
 CNg0Og0O
 5iAskivq6niIZkONNmvOyR0rEhm4VltaUYEHzJRD9mpj2r3s/XsfizhrFYS8qPk/OtI4iC7C2fm1EWbPzapvf8B+PykC1AX5j3i3f2xs/HL57wVVy1+zkg3Y2HDX8eufoqunDLvH+cVkM0wxWuos8QdHREvwX7ehUL1hvu36RJDVrR1u25glnmNVfQgtx5LIt0Gcmpy2/yZeyfdn4lUj32BlP3s6+ruPavpco8QdE0vnmoaQg0L1blz9Cy+YaL2zqaUPIJgfS0RAEJrAvuvRc0FMHm5u1GZ7peYo51lsdBCD+8e02xxuwMmHrSK4jGCpexAJJ8OhMrbl61T3qXD/KHigH9oEMehwgWUSs8xRakMQYyewfKRYys2YMQjsnoHEwkkYRnl/1+SqIOaPO/Qo74HwVzEuQ4zAnkPydCiKl3mKAZHoCdwzr53hBwNuGoo97Q6rfSz1TkeEc+wAyPhKsuSa4dKSa7U3DcDl3M8hKPacH60w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 12:31:09 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
>
> 	~107,000 words of review across 948 emails (in 279 distinct
> 	threads), counting only prose you actually wrote — quoted text,
> 	signatures and attribution lines stripped. That's a full novel's
> 	worth of review commentary.
>
> 	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> 	and your longest single review was 2,404 words (mTHP collapse
> 	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> 	of your top-10 longest reviews).
>
> 	Estimated review time: roughly 300–500 hours, centred around ~400
> 	(i.e. ~7 hours/week for 14 months).
>
> 	1,615 THP-related emails in the window: 948 reviews of others'
> 	work, 278 replies on your own THP-touching series threads (~31k
> 	more words responding to review), 382 patch emails, and a handful
> 	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> 	emails), June 2026 (113), August 2026 (111); quietest was December
> 	2025 (5).
>
> Think I can be happy with that!
>
> --
> Cheers, Lorenzo

You certainly can.  Thank you very much for everything you have done for
THP and for all the people whose work you have reviewed.

You and David were among the first people to review the first patch I
sent.  Later, SJ, Zi Yan, Mark Brown, and many others also began helping
me.  Although I kept making mistakes, I genuinely wanted to learn enough
to share some of the review and maintenance load that you have been
carrying.

I still have a great deal to learn, but I have started to slow down, think
more carefully, and improve both the technical quality of my work and the
way I submit it.  The help I have received from the community means a lot
to me, and your patience and reviews were an important part of that.

I know none of this changes the workload that led you to step down, but
reading this made me realize again how much time and care you gave to all
of us.  I will be at LPC this year, and I hope I can thank you in person.

I will also be more disciplined about patch preparation, testing evidence,
email formatting, revision history, and the overall submission and review
workflow.  I hope that, over time, I can take on a useful share of the work
rather than add to it.

Thank you again, Lorenzo.  I will miss having you as a THP co-maintainer,
though I am very glad that you will still be around.

Thanks,
Lian

