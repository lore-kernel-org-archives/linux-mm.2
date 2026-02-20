Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925C5C5AD58
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79BF6B0089; Fri, 20 Feb 2026 14:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1AA86B008A; Fri, 20 Feb 2026 14:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26566B008C; Fri, 20 Feb 2026 14:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A09286B0089
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:02:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EFD81A0292
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:02:53 +0000 (UTC)
X-FDA: 84465757026.30.ADA5B81
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 326D218000F
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:02:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fgTUQc5q;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.217.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771614171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trvZR2sCF4V60jHjOkl0avZ915H6as3fJB6OlIOoH5U=;
	b=TFa/lb5NI+nxNiT25ydHZncZf6l6vgNQNafwQEwCPqHAAUGv23aGJNyfk6M1fJxCmymOoy
	jK8pJgL7CpDQ1DssVKl4gi2jrFLrvBEohRvH0BBLxMk0KJ6ki+pnkXkCghJlBhGPTzdm/N
	VVtfrRtaelrGLK0vV5HR7wUVSy7DDT0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fgTUQc5q;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.217.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771614171; a=rsa-sha256;
	cv=none;
	b=A+h5NfQTHhfKSufqBK846e7dXyNtFXxeBNC8EMvzwDosq53E1aleKv1F9W+OkLaOXtIdpP
	lAaAe4wHxaGMU2CJzuMqXPbz+Xg1dSQsiQkZ+4N6DceZkaGpmMZPsQ/Ef9GYiAmgshruIY
	HjnoSo0WMSeSRNVu/HSa1V/m9Kc4L1A=
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-5faa8a9d7b7so911571137.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771614170; x=1772218970; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=trvZR2sCF4V60jHjOkl0avZ915H6as3fJB6OlIOoH5U=;
        b=fgTUQc5q/m5Ce7T9Tmqp3QOPD/1qvdV1j7FBS8UZXwpzzpZi1aAkkZsJtqfOVocklv
         3JW50UWhmluBG8YxuhaYjrEq7vpgbr/WCzQ78JU+67As3FUUe1wZsrEimSZCZgljG5iT
         Tt+7mxQTwx3Flp8bwi2GBwalIWTX0cAXZenf9b+ATdg/syyVdCSsYkW4qVgLI2iXm/ke
         l/Rymg40CT89ZJuwx3Rc0N4umQBbIBjN2uUU7VFhiscEZnyaD2oRXVoQY4/0mxU1mI6I
         KqszQ3VPcWixqegM3ZSTWBK++G4SKTZCee6Pwaz//r8UaRB0yUQOKjACSe8xy7fHBc7l
         dYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771614170; x=1772218970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=trvZR2sCF4V60jHjOkl0avZ915H6as3fJB6OlIOoH5U=;
        b=ZoH1z060CiSbVUYTakRIHW00Hfe5IYMl6qad2m+7929rH5FF9NpQWPFGaDnJr1S+93
         8LsJws5e2zOdkgQQHCqEd2fOL3lfW9AHzS219dkay5EraWqX52RrplKcXLjoBEgkMWy+
         MNKrKS+E34p4TyJIrN49984nqs4dETxJfHFkJMSOwVZu71VdjCZHPIYMnGrrCDxA5foY
         mmCvvlulyk9kAw7Rj9bOFblCmCuhYGFVO/2p/lOoPlJQYRdQoxpge9QPy+Kn51Ye+SBG
         BGAfzGfXwwhP0BiW9zz7HRFoizXvz4RdmtxCxrHEgC8RS5C8yQaoBqZ0VTYyE0G9VH87
         od2Q==
X-Gm-Message-State: AOJu0YwVFjc2Uz1LGWfohk/O76xuwGARuvmSW9A5A9cS61jCacvx0/w0
	anMg19DLNqjKzeEdvyt6nwNrdzBu6IW7bd7mTKXwBMT/JeXgkvgBd80QnVt6/zVmlNI=
X-Gm-Gg: AZuq6aIi48mtUJ6AjzSSGcN/fZaaMsmmQTcC1X5IHGnyrIPQm4iZUyvtTSQvZMiCwK/
	xypruI+NDU8zZrnxm6QoaUcrXsUuRLbxbrwQXBjCe4n/pu5rzJi4H0/DfcM2IjmFshEKu5WY0eS
	lLYTje/q5IGEtbmlB4KcCTnuv87N/+B6pAnq92ApvAvioWnAT878U6x1P00q3p1Xg7Z5ep8xt4n
	gAAQGtqU0wldWjyQnxN/cUQmLsC3hfOMRZf1jd1Grbe+FppsWr7cn5dFJADS6e7aommfhNktu+M
	x6Gjs6sF5qOGqRnqmL/gMvAqaxZPtFgkjN2StE/qfC/lu9XzSA+yU+0UOP/yOCqCoJOZkPoWW9I
	MEpTfTyTubjirmwbC2cvs7LY5uL8mb6QyzNdZ1Lot70U1iYc7h3y9hJXipsp3n6UYiYgRX6kYdl
	Rwb+z40tvlxbNsGSzHhWyo8g==
X-Received: by 2002:a05:6102:a4f:b0:5ee:a7e9:f157 with SMTP id ada2fe7eead31-5feb31253ddmr438759137.40.1771614169735;
        Fri, 20 Feb 2026 11:02:49 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d6df498sm488911cf.30.2026.02.20.11.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 11:02:49 -0800 (PST)
Date: Fri, 20 Feb 2026 14:02:48 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mst@redhat.com, mhocko@suse.com, vbabka@suse.cz,
	apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH v5] mm: move pgscan, pgsteal, pgrefill to node stats
Message-ID: <aZiv2ASYc46m7K_c@cmpxchg.org>
References: <20260219235846.161910-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219235846.161910-1-jp.kobryn@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 326D218000F
X-Stat-Signature: 9fx3oxzzbnwjqcx8cux114kew6rej89c
X-HE-Tag: 1771614171-836421
X-HE-Meta: U2FsdGVkX1+hr1pQxF+9F/u5x5dI+ElYJx9egEnz2dcKQ6Z/Jx4gPxDWbO8jPEpovjTIyGsZExXcEidqbdcfz7eawI/0Q/o8Vg9ORdbi2BOG9EhafxrAmffddJNeOf4F/ulMjSJQMuuaUyyB0Xin3fyyM5XzHSvicsIMMUS8yB7AtxlNSgyqjop00ShCWCVz0QY15HGHJDCEIYn8bshbk29aWAdAejB+KSy7VM9eivecu9Ay7aJRH6s8o4GX2TOeUZNxjO76u4AXv1PJmszIXUh5JFaF4SjUCcF/QqpECcH1gzwMkd5e2gIWGUl0pE2D+RK86E+Y+q8AwDPXjt7cRmDqEA9kiiRSIoVGtXQzvZ5it/gQwSAyC/LNGg1wch9DG6L/DLPyPSx84VZLpo7W0Shig4tOdWATdulFgvxRb8rz3Uuas3XvFVdXj73JNScqxVCNauY70/czzx6mpcpMMOR7fqM7XQC6i2m1gMBcK33QTfHznhT6l97RVU/1FlW27Nqw1JG9F12rMuxTyiHVqx3eEifK6OkUZmp2gtDyLpcU8ZnrFBVgNYGHc5vi/t2bQX2iOLB3b1FP7uAZ5ABYGSlHU0z9EX2khGmdT6X50H+yeoYwfC6JeM0m3ZSLds61kX/SuHRh1Yyu2W6y3WNqC5m6O3vsFvJn78l74D00YGKJx0LWMtLQSUYSegroo0/fvvVupiiFEjQYl4VtaXKvnSLvycLXDn1hgDMjhVqtzXzvrqJ9DOt/VRkd6ZZlAXc9euGFqYnPExEZgvnQ1kHxQZX43woss+Dn9ToDaD3YZO1UJ4NuUIMIDcu6N1vbHlREl3rxsZRYjE/DkSBw7LNPqzRLqSBiDrw4R+XryVxVgROkc2e3bADqHLo+pLeQrDzkkw066NeQJY8l3fHm1XF45Dvy2519r0yWLaC9W6NKm5luNE5OknQEQH9IP4QiFnrdTlH7ibQtDtG20YoGjP0
 EEL+GYK4
 YxFlAdID6ysRkhfnp7gJq6F7Wqz13bE3kFF4eyR40rJocUQlEm4UYpBL6C/vo7SWLeAYrIt2LbjRPEd/CSkZM9IiRoJFRvOotNltG6e//usbr+ahXMSF41pHwhcRH2Etu7pUkEjNhb7/vwoIX5psROS1UFhk4Kmx/jYx7lumykLzzob+IDD8Gq7bAZYO9fceHuWicRf3HeK38ENP7rDwJKVpnrJAD8xsb53cacckz7wfFUG1CD98akkcFBNU/hUgav0xd7Ov5LC+HggwkJIvkMjGtPuIgS2bDvl6us2PzVvlxchqZU9vp3EF7a0AOS6uTusm5kDVerspm8WyJCH53pPdpBKu1pc0AZM9D+QRv1POHdPHJCqi5o9aBsErEq1QRjE+5Mi3KwGWDRxhdJUHAb62xJMaFFrTjtRHG0EZZk40R4gcuAxtFbw2zZls0ItfeOTtxvLNIEVAUYZg15+jfxFUmqyjpTAMipRQYNfS45Te4JYM880vLFdvrR11kGwzUdliGlOHvRl0N4k3uA0kLELFyxbCApSpTFg7oxs+qPLP25rI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:58:46PM -0800, JP Kobryn (Meta) wrote:
> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
> node_stat_item to provide per-node reclaim visibility. With these counters
> as node stats, the values are now displayed in the per-node section of
> /proc/zoneinfo, which allows for quick identification of the affected
> nodes.
> 
> /proc/vmstat continues to report the same counters, aggregated across all
> nodes. But the ordering of these items within the readout changes as they
> move from the vm events section to the node stats section.
> 
> Memcg accounting of these counters is preserved. The relocated counters
> remain visible in memory.stat alongside the existing aggregate pgscan and
> pgsteal counters.
> 
> However, this change affects how the global counters are accumulated.
> Previously, the global event count update was gated on !cgroup_reclaim(),
> excluding memcg-based reclaim from /proc/vmstat. Now that
> mod_lruvec_state() is being used to update the counters, the global
> counters will include all reclaim. This is consistent with how pgdemote
> counters are already tracked.
> 
> Finally, the virtio_balloon driver is updated to use
> global_node_page_state() to fetch the counters, as they are no longer
> accessible through the vm_events array.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

