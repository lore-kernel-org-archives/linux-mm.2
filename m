Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B31FD8FE7
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883B66B016F; Thu, 26 Feb 2026 12:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CB46B0170; Thu, 26 Feb 2026 12:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733436B0172; Thu, 26 Feb 2026 12:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2396B016F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:43:53 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24485140332
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:43:53 +0000 (UTC)
X-FDA: 84487330746.27.0F1B631
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 470322000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:43:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PQHN6d70;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772127831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQ5DBtqJLpJ/f9Fcv5GpC1oAxf8goYYwoevTMdhm3D8=;
	b=ohL+vx3TEPQrMkItKiOIoznc+/n0DhE03I1Ojr8RqGL7q1z73UyM9Y9pOebLzAE4vOyLE9
	Ho/tqkfgTRATXDO20JplL6Vox/kKCT8aoKpa28mR9Rnk+d4wKfvoT7v9cS1zGuqnDPEqf7
	gj98bfDDulyarQtEo0KnWf/yBtrx/9A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PQHN6d70;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772127831; a=rsa-sha256;
	cv=none;
	b=5A/BxtbeNOqWFcdoVoll4CMc1OBpE68+hKZuW/7w2ul9rHCdyqtxiiPBv5oN4V1p4D6XxH
	gH82KG6ikPHvZVdIUosP2sVIKQTMAueF9w5/zrDPIMATCSisDqUfwZxrVf3QZdJYVcepak
	oySUSSjzl6dPq9s2XsuMbHxYMm22Sz8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EE0C43B46;
	Thu, 26 Feb 2026 17:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B34C116C6;
	Thu, 26 Feb 2026 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772127830;
	bh=P8ldSxwfLZVjMH586whroUmxuPZFLnNzibkezo9KuFQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PQHN6d70ELrN3toH2TcI45DI/G35aRETlgWeripiFftg7n1f3wItLYTdAiL6XcdU7
	 bIou2KquSsNFB2kkrZvgJJ5bO0EA7BJTLiLrTWCZJXtTdB97Nu3YrDBfjyYz7RP3GL
	 gH3aOyXxcR5Cb+IgAMaHDHCT4bSCL5i217xbDQK3cA25va6um9p5upgf3kRawBu87R
	 6HwwWYNR8B00JgePqDy6EYgpf6tbu2PcxH3Y0bEPXz4FbUS9jokKvAPEuV+khMvKRw
	 l5PFM2D5oKdE/hpJEj2xylh05fzWWStMNiUv5f3y5fjDfWVAreM1ylu2dXMg7ngL40
	 sjp9XBzoYXw5w==
Message-ID: <d9294aae-b91d-42b4-9e8c-cc63245a3f43@kernel.org>
Date: Thu, 26 Feb 2026 18:43:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] virtio_balloon: Set pr_dev.order to new default
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org, mst@redhat.com
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 virtualization@lists.linux.dev, kys@microsoft.com, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260226070125.3732265-4-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226070125.3732265-4-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 470322000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 7uzsgpzy61zuodsxhk96oxwhmceufdjd
X-HE-Tag: 1772127831-485122
X-HE-Meta: U2FsdGVkX19tFxUMgxf9UL7spGU2B0753/ORKPQJwFOPR/OkyyvD1sdfy+acnl831lcxPCJzJGRhYSINSxkNEbYHCldqsXRZdM6vZCkFz2jYAJYs7uCj709WbjxAcMU5VL2tTnLUiP6KDiwLFccMHqIPAoll8dcYKUqHvzxYNi+Fh7k5NCjD/hOhelIrUvZZEKAm/rBnxxJcp7oMG8mLYqtn2ya4kbgjP2sbbEX+wo66pkV7Vd5ycn+w9GNZjCGonpM1udu4hTbKwthbLQjrQem1YkIK4lAViiIFO1c+PfThqrYt4v6FBnKrY/4cbVQtY32ZLel070NgEw9P2TruksBgAhHPHEjXPRoy6s9S02OsnnjMDSYPs0zeGpqJKf18PUSutRXRe8h87YWglb8MvPRbN7Q/H+a+H0cbITkGvFuJoKcoltlvz7z5U1i5xieRYJQq5zLHhaXB3OO8XY6SLJGRhKlhVJPWv4Obik/YX/Lkmh6+gTVWAVa5qyZxqDcAHaoGPT1O4RvgCe25Xll20KPJbKlTha3kZjkaeZZvXZYHRdMo/uiVNQ6KgNJRu2BnB4f+3LevSYWFHhpGCG5V8lsDUerYYTBitpBoE+eu4NCLhEeJE227IreBKkVAM54kBRusWmI+rcGeDZhUV9qmVu8QZfu9ODYXPHjd5IyhGzlyCKloagSFayGsWBzbHQr3+WamJB8dqTEwrNR7e1yQlWWy+xw4JlxeKcXc6Nx8hNvcUXywpR50BeBv3qNwWKP2DR057IRF2FdZeLUwdr0IwxEfuOg9cGQTuENLniB/bq6p9BMiT8tcKVlh4R0eE42xlSc3/X5ekIjUil0dThlJi3N1hdYV1MdD8/3kRyrpeWXcX4Nw3p+IL96afhn0ROJ602sOj7UpaeQwUqhJLJx2Jaz2MHtGwcE88nt+KQajn2ihsKDfdbIldEKYHVzh8UeaROnzTdVz0GKbFedGbz+
 2R/kez6B
 81wlefoKjHtDnjiEcD32kbDoYNZMIPR8TXFzFjb+A0e0d23AhMsQT18KBsc4OWBbDjJZmdRV4VChbaANNB0B6YbHId01cwUUeg2dmtMGmzoDFUHDp8xTJKgLC0UnV35yyXrXOTciRor7cExxaG9RgBuDBDjeGtud7RZN8irmSVa/WGfEfz6+Ez61hDn7irMR8aMYAetG2BvyPz4dfWl+1Qwqzt1ICQKASd5Z46zN9FwPMKw/6ZrJw4Lov9tBMkOXSzc2enCnhlSI/c1zCNBJYsipwxZT+mjkOJoT2pMUciqKZ+HZjhfzjLCV0TguGYzjbFZFigU/9LHXROK58ZBp46ndEEg6fiM/anHVxgi+nm1rWCoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 08:01, Yuvraj Sakshith wrote:
> Drivers registering with page reporting used zero
> as a way to signal page_reporting_order to be set
> as a default value (either passed as a param or
> MAX_PAGE_ORDER).
> 
> Since page_reporting_order can now have zero as
> valid order, default fallback value send by drivers
> to page reporting is now -1.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---
>  drivers/virtio/virtio_balloon.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 74fe59f5a..3cc3dc28a 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -1044,6 +1044,20 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  			goto out_unregister_oom;
>  		}
>  
> +		/*
> +		 * page_reporting_register() takes the order either
> +		 * from the driver or the commandline. If neither
> +		 * are provided, it falls back to MAX_PAGE_ORDER.
> +		 *
> +		 * Order given by the driver is required to be in the
> +		 * range [0, MAX_PAGE_ORDER].
> +		 *
> +		 * One way for the driver to not provide any order
> +		 * is by setting it to -1.
> +		 */
> +
> +		vb->pr_dev_info.order = -1;

That overly-long comment indicates that we can do better.


What about the following:

Patch #1: Introduce PAGE_REPORTING_DEFAULT_ORDER

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3a7c..3e21bfbb49a4 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -8,6 +8,9 @@
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY                32
 
+/* Specifying this value as minimal reporting order selects the default. */
+#define PAGE_REPORTING_DEFAULT_ORDER   0
+
 struct page_reporting_dev_info {
        /* function that alters pages to make them "reported" */
        int (*report)(struct page_reporting_dev_info *prdev,
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..d5191cb6b31c 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -370,7 +370,8 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
         */
 
        if (page_reporting_order == -1) {
-               if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+               if (prdev->order != PAGE_REPORTING_DEFAULT_ORDER &&
+                   prdev->order <= MAX_PAGE_ORDER)
                        page_reporting_order = prdev->order;
                else
                        page_reporting_order = pageblock_order;


Patch #2: Use the define in hyperv

Patch #3: Use the define in virtio-balloon

Patch #4: Change PAGE_REPORTING_DEFAULT_ORDER to "MAX_PAGE_ORDER + 1" or sth. like that.


Then I think you can just drop the comment in virtballoon_probe() completely.

-- 
Cheers,

David

