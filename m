Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4D1606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=iafCo6+7
Received: by kanga.kvack.org (Postfix)
	id 1CD3F6B05B3; Wed, 28 Oct 2026 21:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E266B05B4; Wed, 28 Oct 2026 21:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D6B6B05B5; Wed, 28 Oct 2026 21:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE06A6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:48:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B003401ED
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:48:58 +0000 (UTC)
X-FDA: 85373980356.03.C3D0459
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 80AE340005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:48:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iafCo6+7;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793238536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXOkghG3Xos0XUP5GgF89q+M7BUlh3Lrnn+tFu6rFN4=;
	b=ME+WEZWUy8an/IGUroNAgoGqRi4r5R0Ekubjp5iolGwu8c7IScVWEW1k6Z2X8M8BXmDxVT
	Z4Dk8LfP7yJ/YnqC+tYRiHzQXrLO4uIgAIDAQHDkUrzPsCTNN8jKAVeJWOqpdd2Th9Txj+
	9pX/gxuKHb3VLlch/iwvlY+Fp8EVnBU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iafCo6+7;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793238536;
	b=CsBrLHQ9Nq7qjOeCV+eHHH2IqgE6WaTPO7a+aN8I3zH+fJTebOOc9vu9/dL/DAuFK7Gu0b
	LtyNz+Z4xcz+5QJNbURbEoHkZ1xyUf6UxcRaCJT90WXIK0T/EwhU/LcURK3HjRvHKPhj9P
	kVMCZ6I3fukQ4j9ZJQJZKNETM9hrQOo=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1931ff67a29so223027c88.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793238535; x=1793843335; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oXOkghG3Xos0XUP5GgF89q+M7BUlh3Lrnn+tFu6rFN4=;
        b=iafCo6+7YAuh6ma3WsT3vnlIXHin8qufqD6x35c4aLC1/I+/VcCfK3X3gF447Ug5X3
         ODnuxRyIUhvT7vqzolf0ajxBkx591qgZc+H0HBm4TbY6lUwJoAEG2XidEAv8lMqdITnC
         qS9Dk3n2pPjxZV/EIS2WjDF0aSYKrA1/T541E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793238535; x=1793843335;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oXOkghG3Xos0XUP5GgF89q+M7BUlh3Lrnn+tFu6rFN4=;
        b=TAcdjUO05PJhDctz5wNKyU2xC/fIoDpXCHVIuSKAmaTo7WzCrEGs1rRU1g1rw3yBhL
         eVwEX8j/QfSPCF6zDANVFnTQ6jVZAzkGPeBeGe+k83PVFlwZvaT5Hnf3MMyipF5cBQX5
         bXqzVLW2nWWiPCbvrmUQnsZE5PXItTg1xd6y7UG7RWDI4DDp775RjPib/m/7Zo/7X1xB
         rYloU59hFcyr+WAESHXwUn5lgdSzbda0aa89Zb5sX8l9t7nkfH0gkZ2eXW3/yq/jasn2
         qv46EHNHn2mWl9ztHAnSNSl+19l0QlfoaEosMV9kEaTI1n6aJFv8W9tbHezXxzpto5pN
         9szA==
X-Forwarded-Encrypted: i=1; AKwUvBxm54E8eNV0KUoJ/dy7T/0vl3U8FGtMf2sBuiLez5IiJ5ulm8y39H/GYLHkki1v0nMmNuPwbEBgBw==@kvack.org
X-Gm-Message-State: AFq9FYIsI+kPh2v72UeauwU6GNAG5S25/XXCoClttjNIe8oS1ZFbD3jo
	yW930e7s1EBxrkrC/oEyyGA3MPFZHRwrD6aebMYVKD+LWoU1ma1a4YAIRafyH3i7QQ==
X-Gm-Gg: AYBFou34OgpTsv0GNNgU9ystMOU7l0+N6GKLdLS/OeW9JuViAoz0kVdqivi3C4Xr4I2
	hncgerFJLeuGTgLxtl9tA1PiO6R3t8yQQlNRyvLDFKIaqQLqZqwLufYeubbmynEL6O4MPpnA1ZK
	JtBOywI3DmnpdZjd4NQ09Knkf3pqIdmCABmVJnQM7+ZI5UbazJcvZu8f48ClupQgYHDV1QtFCl2
	GYre7ut60CVeNNFxmTBcyzJNGNIVPu5ZGa4JQ8CXTv6i/1atRrX2p+ttQqwVyDIp5Q1qQxQdY4i
	WVKmjKS38BFJlx+9lfgaNPhTn3WLN1Rlff3iCjUPG1Cf3nYNYyH9Bkr+XtWFk9NuPCrMyq+2gwR
	z+ff+OUCB0vtUTvKHQgzkgJKgQp87kZTbnPUeh2m9hphYvyK/2n3Fg7rAz8gkGuGLrAke0YjcYe
	aPd85ZVHwdYH47+8hZwjV/F7hUH5MuLvAGEICH6rQ9f7hpLw6KIzCAZhvqOthHhCOj4wZ8RurLG
	xzTxGw+7ExQ/3jd36jps2y3Rha/Cdp1luDjfdvMCnemdjHBje/y1o882BhqDNhxxDNsFVBsH0dV
	48cIjxq5P97AT7GbBPqzc4c4WsA/bgDvdRAL9qHpjaW49TTeOcTyjqrhEzbdPEUtgcNA/ywRh7J
	A9X7Q2w3Gc1thyk8=
X-Received: by 2002:a05:7022:eb53:20b0:187:eb7f:bb4 with SMTP id a92af1059eb24-1a6ced8f913mr6113117c88.46.1793238535216;
        Wed, 28 Oct 2026 18:48:55 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:f72e:e03e:c64e:b5b3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75d85f23dsm8564749c88.11.2026.10.28.18.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:48:54 -0700 (PDT)
Date: Thu, 29 Oct 2026 10:48:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	xueyuan.chen21@gmail.com, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <auKlTdFbOZmAuheo@google.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKjuiRxQwtsZF_0@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auKjuiRxQwtsZF_0@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80AE340005
X-Stat-Signature: pir3a5s1nr5fmzejiybp55bugygjihsp
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793238536-100670
X-HE-Meta: U2FsdGVkX189PO5lnRdCdcr+7IMlCA912ZZ5ec7ZP3i5RMdN/AhOQOsJsYTUjbO+WCPWFAM/Q+Xca9g+1G2UggK/Mf94+Q/2INwUGsq5xb0RBq+hn9kzchR7XQc90g2PS47f+tzJnlSapXtkyNZ5Aq56rQqAZKqGMXDMCAnx8e0qw5HXr4r6EwrUgEPU6XYUpU0G5j2mis44qalzi9i3Il1mMqlxTFWistS1owRtmt0PYnkv3mS2wkUida4To3b6i/9GM3PHf2xcUEQbvDpocSs+N+SFlRP+eIiJmXlc0toWg8mSal5jAM7DPufXXWAYhnuVd9SxKGDcGYZd616f7VMUKb6jSnUufTi1+B7prnC/DTC6MCSJTVzgp9mIPJJ85vdgd3rq04MVCB/B0jz8o1eNxKEvORzj9vmOLclgxvR5FO2ANvsigcr+OvXppG76u1AJ60QZzi4vEdDllraRl+KTv51/2rBPk4Kim/hC7CHkxRQcWSTP2gAmZEnX0O6ZHlr2qZR1edxP2ASgAMWO3z+a6HRso5PTXSXCuOWybdQL77E/FjwDnS83Yg6v5+yXvT3ijW+wAhaVuvSUAQKtrCspIqHn6OIT5Unckw7TRaKba2RzRj69BqESWvXsQNmaYZ0y8SAiWVEjHLdSRWmPeppk0GnGX2dc6jUnCtvQghDbIa6B0SmN5QykXkZ6tIc5sysOh5hdZwb7inASO1sEyGLfchgRlHQJSB4AMtFN5jMIeGL0nCziHMfJ7N0hrf9+WA/xd3NgY2+x/yrca6k5yZYXbuFkVK4PMzqs+xFDjWtV2B9NGggMFj46E0psgCUYYpMv9kaeATsmQ02GkfBknvuC8jJL89ITMIHqyQhshMZLyxBQEja0DZoY5KXoXdEu3grW3uL144Xe0PwXk70jFmmlAvmsnpn05L0gvXxQ7JGLxTbQs04P5zVGGXh89Njw1+ig6PA48xV96Rpg2sC
 yt5/sRwm
 MNrCQDfqGBm63YLJQHX97c5dCSJ9SINKAhsruRmhh9UdmNCdij4YqFYyjraqfrEaJ7xb4QP+MXDyZhvWYssMzRDVs4cChoPMQ50e1YrSW5kcHrStb6pm37EqMo3kutLqFCMBwkHgXdwUf/1P75r31PvjrfInaxTvlfJE6Dks40tFQj2OkkTWz7oyH7bvtMAmqC1wvE2HKV/oA4Y5LAuQhbO3kvA6RYUM7ghIVy4+5FGcqHz2r6zhy413ecE++PcPKimkJFSwczSneXXOnQXgIC9O1ugXJp00VBDevpEkyEHEzGXAmoJBA+ysgIzyOLYjDklt2Q0t1RiVUccPNYucK9a4/pbjO47WVhPh9gmnezBhlHM/q+1ZTn7VOjX5FfnUWoD4XvAAQ5E7zCDHHhH6Oh/Am8gDQ5uz5fQmG/pTupof2xtrFwOA9FmoywQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/29 10:43), Sergey Senozhatsky wrote:
[..]
> > Hmm we'd need to collect more data in our workloads to determine, but
> > if we can compute compactable ratio (freeable_pages / total_pages) on
> > a per size class basis, can we just skip the size class whose ratio is
> > too bad? Would that at least cut down on the vast majority of
> > fruitless memcpys and lock acquisitions etc?
> > 
> > I'm always a bit hesitant to over-rely on userspace, especially when
> > kernel has information to do something smart about it. It might not
> > react in time, and many proactive reclaiming schemes back off under
> > heavy memory pressure.
> 
> Apologies for the delay.
> 
> The thing about shrinker compaction is that it's sort of on the
> wrong end.  It doesn't trigger compaction when memory is plentiful,
> no matter the internal fragmentation rate, and start firing compaction
> scans when memory pressure hits.  The problem with this is that, now
> compaction moves objects (if can compact zspages) and releases empty
> zspages, in parallel with potentially heavy swapping out activities,
> which can simply allocate those released pages back.  Which seems like
> a useless exercise and needless memcpy-s.  So I was thinking about
> either putting it under config or just removing it (this might be a
> harder decision).

In embedded (android/bookOS/etc.) there is a daemon, that triggers
various zram activities.  We can wire in pool-compaction (once under
memory pressure), which is a zram sysfs device attribute, instead
of pondering zsmalloc with scan callbacks.

