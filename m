Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C79C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BED6B0173; Tue, 18 Aug 2026 05:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD0B6B0175; Tue, 18 Aug 2026 05:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC216B0177; Tue, 18 Aug 2026 05:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 831D16B0173
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:30:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27E78120B79
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:30:36 +0000 (UTC)
X-FDA: 85113870072.20.8AD69F2
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 414D01C0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:30:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NlxuYRxh;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787045434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35ePu0j/fJxnd8bscjQ+2PUiwSdonYWgCTO9Zio51yg=;
	b=kHMGShjTOBiYRRSrADw7U98zAlmy5SQEOAmBpTkzufdK2SmqDHwQPgyWFVlw4cX93Ojcw+
	bXtfCE1lW2Pf3tBIhWLcb+0oInDqeK+s4WAaaYAeKYnhF7Y6FSpDdxwdWlERM2O2VbTgtp
	A5wgapzZaeeox47+ZLOuK414n4ACiWw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NlxuYRxh;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787045434;
	b=gi0ttaY7PoJiqFWgXasoF24MIX8FoT42lI1ZWWdM19eVUtrP1HzQkxhWX3n/43UhjjWzTb
	Ba+2dg+z6vJazMJYiwsF4LWM/+9ZgVDgZZwItuh0K1SYr8SY/ry3guYP7sL30C9kPe2V5X
	kl/UX1fU3uXOwIbit0YQT5Z8M8/uDjg=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ccf2360620so42731985ad.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787045433; x=1787650233; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=35ePu0j/fJxnd8bscjQ+2PUiwSdonYWgCTO9Zio51yg=;
        b=NlxuYRxhzVcjSWGN5m3HgrObJHzECeoqIOa0Kejl2RalVePz5MJo9BSlsjv4J+I2hr
         WVW5Xo7GgFAwMJ0U0S763E26TQZRZpyCuHPfQwe+JHJIuwySAqktmlG8a0P5QrD54xYL
         vEwoObmPjzrXxdk4MIJBehnQYq2XLQSSmg8rxuDardjdhcpXG3D7GBdm5n9xIiovccL/
         vPthtNrLdWA9zlJ5eptzmFfDQNOrjnXotgP/iE0gS9xfpWIkKYUOoE1hFNd/oVsc9r+S
         sdhMnlZYPUVYrUK90YJKehFAKxTt0Z+5d1fVgsUc2JvtQC2hxbG0+Za+YncXQ5lnAdXQ
         RGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787045433; x=1787650233;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35ePu0j/fJxnd8bscjQ+2PUiwSdonYWgCTO9Zio51yg=;
        b=Y9t5gxsxnL7GuhhkQeW0mTDS4WwMf5f5CdSDRQ+o8zS5cV+kgDnZJFmvKz3bSPt2E0
         FPzX1nkDpwbq73BQJ1anxWp+9lkf2/4JiCetgbH97S2Drusg0VaIDlJoSJL7BUCaIUMd
         UmRLfC8R8vb1E0SQnd8yEeci8xILQKwuKwKzRUAhyZa/GdOhMAHdJwNsckfamKvaVX4S
         kyisGrI2RJJEgxPd08E0O8wbDZM+XKdRFcglybN0fyfMKtxMo1iJTA+sHi6Axo0OvzLo
         cV6ff0d/n2mUoTWHCuLy0V0Y50FRPLUgJsC5SpbUAR/zRYOwToHfVPXKTmwBHKfRqO26
         XGNA==
X-Forwarded-Encrypted: i=1; AHgh+Rou6uX35TzZNBXoGgslo+lz3ymPyk2innNSJkeX/GKPLRfbjjxLRx8tLlYiYmCFjY19FA6G87oWcQ==@kvack.org
X-Gm-Message-State: AOJu0Yxe8lVvyUYpIknPH95W+sLYVmwk2vD+ti1o0U0swDp65thcz2hT
	RlBaqufVqA2JZ27ndP1f67RNR3REuwu56TSCbeVv5UFHWTmGEUTvYvUy
X-Gm-Gg: AR+sD10UtHApyuQNES27rw7ta2oyLsIs43GNGoBOcOztoBo2LWbB0eS3uEVo/IujO1Z
	GF9Hxq/8VvHrdh1mWzyLdZD/mpXDUk8j/Vnu5o4ePMfdWHq9boZpCgbjqXWt5u7QH/UYnVayWTg
	V7LpTm3p5AuooNTKaojzQti+H+Kyel3AG6TvFEoO69lWFHRhcaG09qgNSq2O16Yg7Rwme+Jv86m
	wmvPWOFNup7YU55J6M/fgPyucWzMMj9jlKeCa8+54XPEbOzxki/dImo9xlQrdsVYRHWrqpFRPtl
	rQWdnMem4o2q2RM4cv2YSAteKm8jSc+Egmhz54UdMBoJPIm/5s3urp0pbLL4NIXJacm5FBk7YIv
	YgWEAK5Ql1chO8Z8imWmuJ5J9P395oFccMmF1BdvoBuGqESJNp7gXK5Od3MiFiZmXRY3H6yc8UW
	dGtaR8uqLPej9iyDKx5qf20l2WVuIRiTmm/SGCA3U9q8yVtsSUHk0aeWj3ZUhgBUZOH1yJFVGjg
	gzKcSW/PI8MlhRZ1I4/+Kpa4UGA3PVXTnupU+gseyK2jbHl0/g=
X-Received: by 2002:a17:903:b43:b0:2c9:8f4a:90b with SMTP id d9443c01a7336-2d3b0aeea6emr364809275ad.3.1787045432810;
        Tue, 18 Aug 2026 02:30:32 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e8de43sm12264735ad.57.2026.08.18.02.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 02:30:32 -0700 (PDT)
Date: Tue, 18 Aug 2026 17:30:24 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 3/3] mm: fail the fault on a malformed swap entry
 instead of retrying it
Message-ID: <aoQhNdJEZFjW8TuV@KASONG-MC4>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
 <20260813-swap-v2-3-4a625ccabdae@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813-swap-v2-3-4a625ccabdae@debian.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 414D01C0009
X-Stat-Signature: n5jacnf7aggqud9ajcxrc4tusquijmjs
X-Rspam-User: 
X-HE-Tag: 1787045434-699772
X-HE-Meta: U2FsdGVkX18Z0VS1zK4L/TFHOdU/Cgb29BSPwYTTLSwWw32kXCgdCo4P2ZSfsmFtSqLXfKEZn8hCA83EFL0afHqGJgYRN6kJVNOJVjE8w5YWA3vNq69N6h07BJR7YDt1Xya3HiLIdyry8e8xRXTfbrmJZKypMsBia0kqtnm0DRNz2eoJiBSVpAcwrG6QWQnnCrrA8jNXAKRwHkvYKjHfHrveLKIibt8+k1FX0l65sGnp54MJ/zRaDwVpLt1xnmmJhlBRkJTsOQYS+xDzEOa9tASYlZYo6M4ji0wi/g5RSUex/OGY7R4YC/1bZV1LSeYibXQCluIHKn/Y7RX+A83QAth+xSUZX6j6dWXEc5ffJotvJDLnwnkDN5TIT+sjTE5v+g0XMdnb6eclJNBHqNp5gZ1qiNeQ1FRrvagyzeRTM4i3NAzuLGZmEd5y0qjHGHOsBCkMGwbpOY5N8hnWiZOgS+27MbYY5l2aJDD+tGu+fWYeM2sVfAXHICnv8NFBPiEcp2bMh1rcljLCMIoxN3shoIjfRfoyLBEkk4y7RYvFAzRwHAvngryfIPJDAstVB9W8Ra0Id+En0A/TfP5Hl4pEumMbmdXWXzGirQOKrOmke2rLV0Gqto4Miw5XO2Yhubk5NenScZTE9oCL8BztJBzD5jZO8/wQ3B2UsVB8VSNLDa0asSGgP/5+R2iOQylZM+VkndsfDuJul1WAMO/ykIngNxtxYkg4hdgJPZUHtXupcjhZSHbDi1+MMAPTc86ArNAmKL/wjtZQ6EjOsNWQ4FufgJwMIi6JOmaHDUErwS+EJjnMSLHRajy1XjpYjZOaMe464SKTD0xRSPnaHbMRQyjxNVK2T5XTYp1Uw5xaCqV/Zq9oSJtXQNZZCXs3pccjDIbVBKzrp6oxmfvHvt/6mZJBaGRlv03J1BgMyxhdEpXPRr8lJoMNLgI9yVV6fnehvaBncqIEOlbg2iCypYQ+n49
 SEeFWSPR
 VPRT4ghCzk7j4Jh0m2d2/6zXBCAJfbrvFthCIGCZ1yIcuNoEL+YlXWF9qrfwx2EVmwiMqmMqrmMgObH1lihP/WwLBZe7b0Sly4vlu+GChtTQLJ7D5fDLJdJ5nF7pFZeh9tj9SGxFk7IS/9ktRMEF+aaGYsUccoWp3n7j4mQyG4CZAxNfijcR/K16k/xgSaqp5DrXFFjOYfyyoIB647GaNxqksFRQITmiSQYIEZqqmfn2ukxq2k4HUQf+eHSD936HIZsSp7Kcco3RlF1kSFRTwxvEp+YHhe0qUX+iRVbsuA123hUGAvT9bRQWfoCNpnZzgvnybCOKc6RkK/siRKzTKfq4fnOgU1al/bG/6m+Dm3vBj27NTIBfXHnATdyM38ccOletyMKz6y7sJ/XHXG1G25QpT7Rh77it+xU0q0sQyJnrqs/+yywEQKeQYpDWBa54PRdkMa9SC/hqc7ZtrKvVF06p+7OAlCL9jVUEUgAHeW7dpZTaG6J71mG0eWgMB+yROLQZN8g+R9W+kWpCCB/n6UHMQaw7a+X0gDjOk6jlIL2OwGBnkYJejTtIKo+BVoQDhB6vp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:02:22AM +0800, Breno Leitao wrote:
> do_swap_page() returns 0 when get_swap_device() fails, which the fault
> handler reads as "handled". For an entry that can never become valid
> the retry takes the same fault again, so the thread spins forever,
> retrying on the same fault.
> 
> Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
> called at get_swap_device()).
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 7201e848129a7..fa2b3d2ad3202 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	/* Prevent swapoff from happening to us, and reject a bad entry. */
>  	si = get_swap_device(entry);
>  	if (IS_ERR_OR_NULL(si)) {
> +		/* A malformed entry never becomes valid, so don't retry it. */
> +		if (IS_ERR(si))
> +			ret = VM_FAULT_SIGBUS;
>  		si = NULL;
>  		goto out;
>  	}
> 
> -- 
> 2.53.0-Meta
> 

Looks good to me but interesting b4 shazam will apply a Fixed tag to this,
maybe it picked up the "Fixes" in discussion.
I checked the discussion and the history behind this, 2799e77529c2
caused the loop, and 23b230ba8ac3 caused the pr_err spam. But before
2799e77529c2 it wasn't correct either, it was OOM kill.

So anyway, the fix is good, we might omit the fixes tag on this I
think, the behavior was never correct.

Acked-by: Kairui Song <kasong@tencent.com>

