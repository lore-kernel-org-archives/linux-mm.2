Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A36DDC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 04:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B8B6B0092; Wed, 19 Aug 2026 00:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC8F6B0093; Wed, 19 Aug 2026 00:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB4C6B0095; Wed, 19 Aug 2026 00:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 525796B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:24:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C50471C07FC
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:24:53 +0000 (UTC)
X-FDA: 85116728466.09.0A0E338
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 080A3180004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:24:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fPD45FcW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787113492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iexIkc1Tg7Z+y3wVDAMXzgQEyxhlozvlc08yKQPDJNI=;
	b=Asrwt1n73vLxSKX599vIaROxOtGlGj8Ogvje+qsSRf+/mHQR9b5m9gTkemzeLCGfgFiHVO
	1nATQNkH5BRo0o5g4aXsrbw3D3nFgcQbcJW7eqlquJvfMI4Ng1qV3TUC2yZ/jodSU8D/cb
	2MG5qtFvP5nSqtXUzWlbOGFcqKJMOYs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fPD45FcW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787113492;
	b=3E5wdLcN7SlFKZc9gUYoySWKkq3Ix9nRkjxZNKnUsRTVPdgQv3PnlNdOtme1LWMSEJjHFA
	YM93sQPvvdqkl0BIsNITXgTCggqnotyJfybBG1rl7Ty+h7LXDujVQCOIsEOtJquMojS4VV
	op7sWPZ33en8x6TfitB69/aiAe+IfmY=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7ec49608332so533493a34.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787113491; x=1787718291; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iexIkc1Tg7Z+y3wVDAMXzgQEyxhlozvlc08yKQPDJNI=;
        b=fPD45FcWh7UVFvFEZ3Q6a8Pv2OdyJ1iG6fJKS9zeO8POMMSe7DT6lAZgLbQxWJIEF7
         73c9NaeAM2eY9PApEKET6DE8chC8D79slMfesN1SNSdwFKOMg6Zr09ZZ3ajM8tdkGTKa
         kuVI7iZsX8MhvZo9MgiFZGz1XaaY+QcVtFncHJoyX07Wv4IoBSsOMzo/MoITn7OZ/jOA
         FQeKW0qX2dtErGBMNBe2CV0/E6qil3JxDU9P5WFv8obHpZ7LBq55sIKczSIQ/BklRnNU
         MbkTq1PyRFQaHSr9UwVDcBXA0u8P9vzl4mV/idgEc/bkwP/hxFZtS3ihj/PJb0BDBgzW
         MBjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787113491; x=1787718291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iexIkc1Tg7Z+y3wVDAMXzgQEyxhlozvlc08yKQPDJNI=;
        b=F0IETgixN6sUiJOto36Yt89h3Hwju6hQtQglSJHkwPwMxqS2dBZ0HRWwYuCFi5e7nn
         knUVaQ+chmp8t53bFuB5DSf4/o13JKAXknVEkCIquUNJl/HPyPFlszQ702UIwcUZxqMN
         M0zegNGI1fAWdOrIb0zSOKLDQseEQPC80RfRskAUgVeCqQOXAF4wEEDlWtANqPJLP8Ff
         /cRccbskFhjtTj8Jiv/8L5zJ3hnr6w8FFW27WPnWpE5Ts93ppoeAscHCvYs4m3qy2GPs
         FHUBlWhLrAGznfk1xy6zEUOr4f5nclibdCqulYEArheNdGyyedsLdveT/HnMuBMGsNXk
         kFLw==
X-Forwarded-Encrypted: i=1; AHgh+RoS7ecrEs2i/wHNZn/8fVNH+fLDxdICVVDk52myOrJLzvnBm3P9k+5yRk2DeKmoPj7nwtOLk+ZIJA==@kvack.org
X-Gm-Message-State: AOJu0Yxr7Pez4/0653LfTpr0ictKBpicB7gfJ5qPKbT0vn3isDmCgOAX
	yMSLOkuPBELicfExqP2MetabaUJR/exJ24I4V/BxeYv5Buidn9UcMkDK
X-Gm-Gg: AR+sD13M49mA8vJSlTDxZNwRelhZB6hKyRjSjEwmdk23LWhjZkkxVVcNOZuB9nPScQ1
	MLnpx+ThxMzOmRjbtTCflp3n8iSZyQo6SkbliRWMgoWLqu2W0duc0BaEnwpew35bQa4UWKg4a3L
	EPllyc3XShPPdMKDkvzUxj07FVT0QHqRMIGw179G+ASxEcV4t+ahwdeVEFYr71x/63WfLyMy15D
	qw2dv8mPPc2BPbWGJqkLTKqH7iJbrJPN+4A1FLwPc5sHiQafbEC1CIxe1y0ljkem6dLn15qsthk
	2dmqkxoLmhEimVHcY+J85yQNTjOh60NHts9TCu5orMUiyV/UoBmv28gc2ELYHrUBDNaRI4N9xdS
	xX0XDXzIsYgKMZDw6PEsz2ywC5ke0SmjuhWs/AUgsrQ33H1nn8lxQ2MuNzmYj1kM6aWXvyL37rz
	HImbtZSxVDy/AFqSYBVfkKg3BdYgmlNTl5ifLXL4ZP6wb425XszjpNTIo9lgXZefULe6868Ygz0
	OqcTTZCow2Cg9Bmvg==
X-Received: by 2002:a05:6830:258f:b0:7d7:fbe2:9725 with SMTP id 46e09a7af769-7f43f95b60cmr1996975a34.5.1787113491046;
        Tue, 18 Aug 2026 21:24:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f43fc6c89dsm654187a34.0.2026.08.18.21.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 21:24:50 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org,
	mhocko@suse.com,
	mhocko@kernel.org,
	joshua.hahnjy@gmail.com,
	willy@infradead.org,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	zhuhui@kylinos.cn,
	audra@redhat.com,
	bingfangguo@tencent.com
Subject: Re: [PATCH v2] mm: memcg: release the css reference when a stock slot empties
Date: Tue, 18 Aug 2026 21:24:48 -0700
Message-ID: <20260819042449.1209042-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818130135.154315-1-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 44sx95dso37gmmk8ad8g9ubxpogw6dko
X-Rspamd-Queue-Id: 080A3180004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787113491-60887
X-HE-Meta: U2FsdGVkX18AvIFolkUw3uwk4NZFuzTdEsonKLWj31K/eF62yZ/x4N72BifP4yshMPMo3u4SpW4B4x869gIGwi5CvaUQDs0I6HGY15C7DMYF3fynkrtE22iLhTPEeoT7OCT1j11M7VvBFQUnqh/JvG7UFFcAGSbu7873MqmAdRXCaJzc2vEKqV+UxGZseIdnvovy+ZldMC2SYq38WSgyNr+CTb1FHpFTp1GGfpH7wfSTMkAj6wqFW6bsoWzeoFjul0S+w4QT2t7zihZ9BnAh+BRSej1wL4t+/TRr8OdlA7uViG6q2PfbUuyz9Pv68ok09GBRYGsos6k9Yn0EIav71rg6EkRa+v4CioG+mnFJbRMBeuFaMrj0mbkcObewJT+RqINvqjKYvLoaZZfOQUiMFYwsu5j6MzIUuyFZy8zX719ySSsPsWjBUunNSEjJpWiGqrMeb7IdnimNkBWW4YZSryynEy9xTlq2vUFby7wEjDTssyfOW3kmS2tgWQAibkta8f4iE9p4ctopEDcLZOQXW0grBvwWZYkpsLXZScOyHOfEpJJM/aUspn5RS3XbLWB8VAViv07/3DcjNnCeeq67Vf6rqw0Dpx+VoEersYwHz3RClSIrXxf9/hDmng+4vTFIlbXa/7pXtClXpBXkRgfe9t0ApJu7yTt2Ax9OfAe0xzp1xlFIg1a1s66JwDVPYUrJVQEi8xyI32ss601XBiHLIr1lD6uTgh26R1zDQgVWE2JlqU5XRHOeef/9TWlSQ4daAyUs/LaclCNCRxhXmRKbWeJoRvCgZVkPyIgcFgzTuAxpx7dRe6dBT/sk9GGzzPldT1AKkyOLB5gaWCoJd9TZsNez/maojMlQgikzgDmK1TutxGp2XiSe3OQKU1+A9JlzkQ2A4eY0nAtlQNqmqRESQp9raNNqMrnOK89rcHZN2srnz/vtANuL34kUHOb0/uQutyFlqIoNSuJyU1T24++
 iSFp/mq5
 LB+nWzCtDrqQD7q0El+UUGzp8bulh7TycfW2gv5+BtTTF1dZcLfx0hRXyj5BtGmXQANEG1y72o+i9RRbEwHuXyoIxFUkoyUMzq445U2yQMaMjdJ0QLFEgOfu+FKTrmhBZ4cMDpjDyRNkbnASi0o+MaINTtYUXSTJJmyvVlcemdy3UG6xZKIKtaNtKuU+jdNywn/6X2M2Y82fyGFW966ToedxWA6ztt+dUA/nDVES9PUVl+AeOB5x2GHF7cJwNUbdEdB4VLFWYssKRKCviXOr03IaYQSmneUQUsrNWKMwE32qOoMdZz4xZV1tZw3jslfCJF06aPlE3R8Ol3d3Xsv0uUQlv1TBhma4N0ZzCDaajkd1+5bTrx0P+dPnzZsj+2SqsmJINKpKT41xtKXWbzl+RGW4qi5hUd9u/B6JbiQu18RS6v5cBCf4nYR2LokKhK2wX8D3s++VRA51sSTkXjrg9GEHB0QU8Pi3t0eJJXNQnzmRplB0BgkPFxF/fuu507RREWyXqMz1w9ubA13D6ASq/GaBuT/KSa2dYnhuj4RzI1NrGttvUKrMKbK+dTGGfelwL/zdC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 21:01:35 +0800 Song Hu <husong@kylinos.cn> wrote:

> consume_stock() can drive a stock slot's nr_pages to zero while its
> cached[] pointer stays set, so the slot keeps pinning the css
> reference that refill_stock() took.  The offlining drain only
> flushes slots with cached pages, so the reference is never released
> unless the slot happens to be displaced by an unrelated charge or
> by CPU hotplug, and the memcg lingers in the dying state - up to
> NR_MEMCG_STOCK (7) of them per CPU under container churn.
> 
> Keeping the slot populated past the last page only saves a
> css_get()/css_put() pair on the next charge of the same memcg, and
> costs more than that: the offlining drain has to know about empty
> slots, and refill_stock() cannot reuse them either, so a charge
> under a different memcg evicts a live batch through the drain_idx
> rotation instead.
> 
> Drop the reference in consume_stock() when the slot empties.
> Empty slots stop existing, so is_memcg_drain_needed() and the drain
> path stay as they are, and refill_stock() reuses emptied slots
> directly.  The cost is one refcount pair per emptied slot, at most
> once per MEMCG_CHARGE_BATCH pages.

Thakns for the v2, Song. This looks good to me. Have a great day!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
> 
> Changes since v1: drop the reference at consume time instead of flushing
> empty slots from the offlining drain, as discussed with Michal Hocko and
> Joshua Hahn (full-stock drain cost, refill reuse).
> 
> v1: https://lore.kernel.org/all/20260817025917.66233-1-husong@kylinos.cn/
> 
>  mm/memcontrol.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..1271d390b617 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2140,7 +2140,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  
>  		stock_pages = READ_ONCE(stock->nr_pages[i]);
>  		if (stock_pages >= nr_pages) {
> -			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
> +			stock_pages -= nr_pages;
> +			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> +			if (!stock_pages) {
> +				css_put(&memcg->css);
> +				WRITE_ONCE(stock->cached[i], NULL);
> +			}
>  			ret = true;
>  		}
>  		break;
> -- 
> 2.43.0

