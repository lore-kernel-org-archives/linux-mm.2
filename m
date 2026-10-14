Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC1EFCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14EF6B0096; Wed, 14 Oct 2026 09:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CED546B00A2; Wed, 14 Oct 2026 09:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03956B00A3; Wed, 14 Oct 2026 09:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F64A6B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:26:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 260AE1404E5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:26:41 +0000 (UTC)
X-FDA: 85321306602.06.93A5315
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 567B24000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:26:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j1CafOv4;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791984399;
	b=RbsdYEbH97j3KohRdUMF/J78PB/xofYJiXJYqWJdzRSfC03Gcd1+kzWNa9NDuIiPLUMf7C
	9ujQXUKOzE6C/uHrwYwEWrxg6g5a/cpEETTpe5VixGfylaPR9k7YBiMlEMLIjjXNxrZGgH
	teUcChtWCQEyvUVDf8+4+wFz/oOfmag=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j1CafOv4;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791984399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9IOcxSqwYrBSr8BFbrbfz8etoo1JAf0XtOV1kMheuQ=;
	b=PEZrdguA1zJKcjh3F10MGgiaZPS8DcPVKWlQ0v+4j8/foVElUk3lBR2bqyWflDjhKR54Ly
	aZv618kODQnS6rLybgl8UkWr67V61pu743gmTYi/d/CamyFHsHH2D+3VcAQxomonNttzXM
	6Twfwl/xYnpy+fkjvxAlcek93wsE7Hc=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-535f9de49fcso2290491cf.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791984398; x=1792589198; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i9IOcxSqwYrBSr8BFbrbfz8etoo1JAf0XtOV1kMheuQ=;
        b=j1CafOv4n6MTMWn0jC+gnYhfUOU4yT9hw14USd0bFS0ytAI8aI0uBFSYlP0zdJhO46
         vmaUHfkTex4xRxufXYCgTWyyDNA7xh1VDEz9oymuFtK+rNBYEApOA2LuBdxrm7ryHAEn
         53/ytLfKYvyovkQqM73Vd+gqrFT7rmH8yPpGZTiM1bIDbGyvJWRwpnyHzP8Zhs1tQ2De
         0QQRK0gkUU6Qdn1+PJuxTZxamltxygbZ51TdVXy8aq2ebQmNUjTupNx5E+MHedqNWBYh
         kiXRG5gubVmSdCpUVfNgDHnYyw0pNeVv1bIUaX553pzTODdbxiOsy7eCzZt5Fzx5S2ON
         vrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791984398; x=1792589198;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i9IOcxSqwYrBSr8BFbrbfz8etoo1JAf0XtOV1kMheuQ=;
        b=16NUEogKFRgb7lfUgA7X8BhL4qO+0UCyUMbMBe+bO8ORZ9NqjHHkGryhPpuR/B49ch
         MNdfuZuJ6tI6ttj0/l8dXE7eWgtbKOaK4ybTF+H2I03VZ/vbwbpjZwOKmYUi2y+Ut/4w
         ZlMCy1bpQrHomdNgxvoWZOlMVyQWSsA8kafnVE/Tobritq2hdVgoBZgsptRHv+xk3pN7
         3ficnzNsmLWKSrY8TnkqpYFk08ICsxruWsu75JK4qtxJXzUvTxIVdedhxPPfGDwSsKdr
         UQCgVMyNjvm31Sb6GCUoVPNBe4pxSKdNJ2YA5P1d9L8Vt3PZw7RhqjuDBf+5Oc6L8Ujr
         z2DQ==
X-Forwarded-Encrypted: i=1; AKwUvBydAEGz5CnPD92fndS572pgRD8FFiqdcERhng/6+vsw3ZFoTcuj7ne3kpV3Xyo9cviiQOGcQz3kWA==@kvack.org
X-Gm-Message-State: AFq9FYJKMPw1QfoTd888ZF14AByxsv8QuH19urg80VwzIUyunfDsMPX8
	AHTfXeZXPcf/ztH1p7GKT2Illp4mxP48cEIRZJD1w5NE7SmktYT6yLq44yEBpCd91k0=
X-Gm-Gg: AYBFou3/1QEkGLsf3ZX7bfAz6t2kUQIPm5H5p0z/AComcFUUzrm7lFL8dp4zp9UnNBp
	HCug890yElsCm+bcEANVn5FyyCzKF3agKZYinNfopXCw6I5FUWJ7RZ8vz5TvLg7WBK3laLNAUwZ
	RzfoWyRd7HYh52MxTy83RLvK6WDUMou7gXeHYrJYQJWgqfbmEhseOCvo/c2mZ/KvqktYmzhi4+o
	egut0/5XBMC5TwrZtfjNaforsW7lIMkfU+NEsyyfBv4vKwIOuTzaaeQojT400Wl4PfuPIvq/fI8
	BpVFh/E44oMEiC//WOCC40QVrA9wkOmG0+zweNl4a+4cS+NvQYdSX4KjMgGrpxvF+hHO0fHyrfL
	7Ly3dFx0LqXdGLm4L7Ycf3Fm10rosTbKbVeW3DpI6DQg0d0wVlJq+CvU1h+fkxYeZSpIFjBUvoq
	D+ZW0cmtzG/zw6rBmsWejZWJA01VWWwZED5v1mQ2EvXk6UezchmeF/BvXh4TkcTwmCjHrqT4gLy
	94InVfHkz+NnVtH3YJrwIQZebVRF5HcanxJN/ZLJt25WaNL86PAKrk=
X-Received: by 2002:a05:622a:5a0f:b0:535:f9df:cc8b with SMTP id d75a77b69052e-535f9e049f5mr53842251cf.21.1791984398464;
        Wed, 14 Oct 2026 06:26:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b731a6csm125043441cf.11.2026.10.14.06.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:26:38 -0700 (PDT)
Date: Wed, 14 Oct 2026 09:26:36 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com, peterz@infradead.org, 
	mgorman@suse.de, riel@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] sched/numa: do not feed tiering promotions into task
 placement stats
Message-ID: <as-CxqUTS-DjO5HU@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
 <20261014094347.99157-6-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014094347.99157-6-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 567B24000D
X-Stat-Signature: pa71qixxok49eecwnn3ept7cfokdiksm
X-HE-Tag: 1791984399-976134
X-HE-Meta: U2FsdGVkX1/sQHP3mAUHyjJ2i/kpywUX3nZeA5fMX6CM6WkhocOgEv2S3uY24VMrqA9+Y2Bm+gL7QobiouxW6dscV+PhFUpnz/5H6uaVIZPC4NW42TnvTWKJ0u8qFHAOJTekaIH7c6CsPtQJYH8RKol0iGy45idr62ZIrFCFr4y9eHhjX7RgJ0G8lYBkY/CCPoxYs5W1OmwdTUA856GkAXXw+wZqMx6nB6XQ9cdd1TE7YuoWJBKreLl5w2S1ShvzicSUeH44OynTBXqdxLXEX6pu8MBzxvjvcwL4OZVx4xfhYPgK95Ghvfx83i0rY8xMl+WEWaNWNsjuqPZG49nPDTx1nDMAsiaQcfG3uJAzlUKTpd0BK1/dhusK0NcALmco80BrPfagNVYkapJ2+zzCYkObsOXfcNyZJt7pHVnoODnQMW3b4MrMy5as+yZW5aQV9nbLoX5Wype7mH8ZZhvhjJyMZvuelGPQC/2G4rfgpv5jUaYBTjUOBMwd4O5h6K75TzD49ovYwe4P+bZtcTxGWObOKvNWdpCWFkoIyAdgwWNKrU9QOtERXUQZhifrJkclJVQvLQYOA+X/JSgMhssM7PXipxFQr37gkfUVy5JmntDntlVrsXSL4m9M6DU/cJy3Q7cRLNRY7NsmmPvaGhtSW4B/kaeao50tQKBdc+N9FHbK6QrMPd9LILgPJu4NJVulscKeHaA27TolJ1nz0YJyWdicSIKssZsyaMT7sUfAy1sh5R/0DCVp3i8ALUET8c+Lw9M6HXFig7hu0ZBMAwoMpItBliClcukYuE8nt4z667rhHI1VXhYiCX+eBg6GUHoBFUE+zIoEeXSoWuQG0qI7wmdZCFdqe2i4SD6lTBTSWbMA4GQd673LqH9x0evAzH4n+2hODwN+jkYRpu6V+hBal6kje1h8dQpw3/Bl7soa2IKLaY49TFp6qgGDAU3gfpMHfqinpuNlFJiygkfQT6c
 GxUoPc0b
 H/nkifpC2MUKsCeujsrfJBBBbUgzQzwDsvb5Qa4T5VXz+/GHmiwqOAf/XNOn/bra2AdzHN4B5Q/amJeK2gxibDjfv1nqDKMTxfsT5gsinLDam86xRtqecqb515te1M1IgHLLYVE8eTjaNUPS7FN5u0h4bkHyhmb2RYzWYCJWMOhPqo9aQK6twD7aaee4ljWz7KvxCGx5bIn5lOWJxJNz9jP2Spd3/FLdKiyzplpB9iSfEA+emFgnjLekdrfK2MVlJ/V2LTHD7TPvy6WvzA3PVTICmjNuBI0ORz1sRI9OqhodsEldvk8MKgSGG2YsvWvOlJ028w21B/fAavKshA61h6yBWiwdEhYu90kyzwjPeQs+oKla4JnAf32XcvI3ZQrwwpX7xmkkcxxGSmWdwovykYXQzUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:43:46PM +0800, Li Zhe wrote:
> NUMA balancing has separate mode bits for normal task placement and
> memory tiering. In memory-tiering-only mode, NUMA hinting faults on
> slow-tier pages are used to detect hot pages and promote them to a top
> tier. They are not normal task-placement faults.
> 
> task_numa_fault() already avoids normal placement accounting for slow-tier
> faults while memory tiering is enabled. However, a successful slow-to-fast
> promotion can bypass that check. do_numa_page() reports the destination
> node to task_numa_fault() after migration, so the fault is seen as a
> top-tier fault and can update p->numa_faults, task placement state and
> the preferred NUMA node.
> 
> Slow-tier PTEs store access-time metadata in the folio last-cpupid field.
> Before this change, numa_migrate_check() returned the same all-ones
> last_cpupid value for those faults that normal AutoNUMA uses for a first
> or unknown access. Those cases are different: the ordinary unset value
> means there is no previous CPU/PID sample, while a slow-tier access-time
> value means the field does not contain a cpupid at all.
> 
> Name the ordinary all-ones sentinel LAST_CPUPID_UNSET and use it for the
> normal first/unknown cpupid state. Return a distinct
> LAST_CPUPID_ACCESS_TIME value while the folio still carries access-time
> metadata. If normal NUMA balancing is disabled, keep the migrated-page
> accounting but skip normal task-placement accounting for those faults.
> 
> When normal NUMA balancing and memory tiering are both enabled, promoted
> pages can still feed task placement. In that mode, the user has enabled
> both CPU placement feedback and tiering promotion, so a promoted top-tier
> fault is treated as an ordinary unset-cpupid AutoNUMA fault.
> 
> A stale access-time value can also survive after memory tiering is
> disabled and later reach task_numa_fault() from a top-tier page, where
> the slow-tier validation no longer applies. Treat any remaining invalid
> last_cpupid as LAST_CPUPID_UNSET before task_numa_group() can decode a
> CPU from it.
> 
> This does not change whether a page is promoted. It only prevents
> memory-tiering-only promotion faults from being consumed by the normal
> AutoNUMA placement heuristic.
>

Similarly with prior patches - this is a pretty major change. Although I
agree with the premise, do you have any performance numbers that show
this change is beneficial?

It's quite difficult to determine what the user-face effects of this
change would be other than expecting some kind of performance benefit.

~Gregory

