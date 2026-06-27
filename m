Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45A2C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 20:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9621B6B0005; Sat, 27 Jun 2026 16:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912B66B0088; Sat, 27 Jun 2026 16:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802C66B008A; Sat, 27 Jun 2026 16:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5512B6B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 16:42:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2F1AA0243
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:42:23 +0000 (UTC)
X-FDA: 84926865366.20.9148C0A
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id F1F8518000A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:42:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Ws//CmF1";
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782592942;
	b=aT7PjQLcK6D8VDLnD6U+og/D8kra/GGOZ4s0Cw+B0hisDfzWr5yxVahBQHzVO5fHz1j9z0
	IzTE0yNd+eaL6PEt3T19MgM3aA7JG00qNaYxpPf2Cqby8xihosn+l6qCK1KYr1xdMm9j/x
	1vU9+MYekhL7DfHy6A3uPrG+w1nPEgw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782592942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvBTXqN1MAazPmYZrbZsf15Ac2BOg/NxzUUoaLCPN5k=;
	b=NmQv6FyKQhXSJwlseT17fQ/yGWjDDNJVOx3N/wzVAXhtsTm/7xxFGDDaEXmOwZj7Y88s/x
	XZ5ag/+w8o6fcx5f+rqGMqS7fctEqAXds4wAqSbGkyapqbYaTcVJelGODXrRorcic9SeKw
	zVP0jcO90WY5Kct5plf1cWnccyy2u9U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Ws//CmF1";
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-920fbdffa31so174505185a.3
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 13:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782592941; x=1783197741; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UvBTXqN1MAazPmYZrbZsf15Ac2BOg/NxzUUoaLCPN5k=;
        b=Ws//CmF1Glj8WAmZBN1hgXG+TqBDy/uaMcZDNJGp1gD2ZWt2iin7buUQjS8lYQw4mv
         hr38szD4kAaaZAVRafY4yjOK31blamZio1V7bOsd/QTNXi3d1oXema6FoKvZ3xLMX+JQ
         ry587PMesppUdQsGjNaIBlJcTRHpoPrpNoSoM6L/BsGqKbifDyS7w4cLRLwr6HdkshSZ
         iZ+KNdLCPzMDfxTiSGVU2iW9cPp9EpEnnifgRBFrje9sP37ZejFXTj5fTDY7Yf9JtOAX
         lKCGo9ZJi5IXgavJXMq+bFb/7YenKTFqx4whVvreVkJekvvWOY9X/5W9CthE2QLDQFfz
         b2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782592941; x=1783197741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UvBTXqN1MAazPmYZrbZsf15Ac2BOg/NxzUUoaLCPN5k=;
        b=onHi8nb6tT2s73KeoiOAGBPnGSvfnqrrPuhEFMd8To5RTjLnqJt0EkUEO+4htqll08
         uR18+Uywiw6wA76uQ6zhV9UtHh3qKvngPyhbWRYnobIM1qsQR+VVw7iwwwAnnR+CVKMQ
         8tOXCLnWajJQOPciuB47yu7DWMDb0XBATSff0VgfKb5AzP3AAZjcYP7H5nevunnzKYwK
         IqMZfBD92iIIiKZK3fEUJthZEbigo6+mzsmTnuz8gygFXeOBA5XiG8f8380yOMkAPRXW
         0rGsKqhNLD/b4xPCAst/Dtc85028A0IbJgDS6a0U0ItKKYXPMlC0qTeklDLrYGCMkIaw
         mCMg==
X-Gm-Message-State: AOJu0YyNHFmXBjYJCt9TqRpo9tM6BnZfTzoDeknt4rVIBzNd0CEEi+l6
	EhL4ISrA4uW5lQB+FLZ5jjd5FVntHk4WMrZ/MSd/SAoReriCy+O6WqtE8UfJRbTsYRLhnCjOTsW
	YR3Lu
X-Gm-Gg: AfdE7clPhD/UlJ5sg8b0LsbstyrCxc71vcNLeGeITrsbRslVeFNAu7XNbhnIXKGgBf+
	wMvk5hUvHm0YI+dLDmBBx6Fq/81k5djrRZDCKSjrpC103fYB34HG0W2dAEdftxDLWT1N0iQajqn
	KlaqVxaScE8HCpKKnKotp16wia9n9t6IeL+70TbiQkz9iSf/8wKLOz2kk1z/K6xc8GEyojNlOBp
	cAFKEpIfAVuHVKa+DNfjOa+xHZQ7gEPeZ4baXjAgENBVWcIuzbpOv+f0sN4sXppsxZkCvgrLxqT
	MFBBFp8TpB3KSQQsw6GpYbVcxTnsq/6a9XQo/PsJLmGgf1ypkMrTA0muex0lbTtJi5Cvq5EH39o
	sPOg0EMGvM80/RzcoMZRj3UC1b0KXUyCX5IQLRGZ/MwrUHywYOcvAzpl9CCA/c5ForSSQfhT+ZD
	z+fQHFxywNw99r1MIdO7IyBsy3qxSPVWmQShghnmToO8/R8uHl3y5DQJeUcZOUq3v0n5bGYULJ5
	W47I5o=
X-Received: by 2002:a05:620a:2915:b0:922:2baf:d757 with SMTP id af79cd13be357-9293d4a105fmr1727191785a.58.1782592940972;
        Sat, 27 Jun 2026 13:42:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-925fda626b9sm1585236085a.14.2026.06.27.13.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 13:42:20 -0700 (PDT)
Date: Sat, 27 Jun 2026 16:42:15 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	kernel-team@meta.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, hannes@cmpxchg.org, mgorman@techsingularity.net,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: flush per-cpu node stats when a node goes
 offline
Message-ID: <akA1p_scgVk5FTmA@gourry-fedora-PF4VCD3F>
References: <20260627073107.523499-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627073107.523499-1-gourry@gourry.net>
X-Stat-Signature: ywxayysk7wtjx9qaah5x87mwo3dpnnde
X-Rspam-User: 
X-Rspamd-Queue-Id: F1F8518000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782592941-684468
X-HE-Meta: U2FsdGVkX18HVMbrPZVsRMu+t2uNLqoylavEFVlWlY0meacaTuHhop+eWRmUnPbbnXkorGDC5PC8LsxfAiDLbmd2LRN3GxNIMhE0Th9c8+BL/EfPev1+rZWAXI0ly6EzQpTWE9ecxwepqFVcaWiyZOxmVyqGOApOrUUumUn5olspSIhZOPx6Z+WVmQeG7uw7k5RSKWSco9eEASKt9MYo2fRIJ54EKKeA9/fS3RLnE9jd8YSTKT2dBGnq9oHHwayUbA8QFcbHeTSnyH+l63x3rB2cFPFMdgQ2vKZFR3iMi/8qegEKM9zAapyj/87nt6Le53ebjf963ZovhpgiHUHo60/UzNtq1ovhdMtqM4QApuOF3H7iEy3XqYGjKeYGj1jiaNpD6KMjuaVKK9DIZ214mgXYvlDRLGsIchJJpGVFAIaQByaB1auSF6AIiifJMSg/Nco1zKKx4OsBBSDlZyhvLW0JFmH+wjkcBu01W571j5XAKRzHmxPxKQxosplJaaVVicT76dXB6xAsKw2rSq0hhlU4WlrXBIV4WTVU1gN8KQCtZcrjFeAzab8gvgGl1Sf/KnFpY8S6eSLqmr+FlbPKyBKdEFzbD2dc064fOZstugF3fKty1A4xQ4mHfbpndETCPcrc48DwyWa460yw9T/85Me2iiiYTGsOXnt1yo4dia4Vlk3decC8Y+3m2nKEAaW+UcmGB/nJdxBbc/oPPq26qRxhDSYgFAHvJ/dlyFG8tmeOWyVYnBG4sDQvK6dUOWkjgZ1mECF9TShjz2iNaFeAYNL7iLqZEFkRjx8JZvxgKB/qeXAAxGzWkos9fUE5oTSFFPURwQ8XU5LxggQlC6rCAmMFWc5exUHK+Qr1f0vGdFGy21Ej9/0LWoN/KTyhuhQ4Xz0CUC2ZhxjhQY2FXPbEgHYVcQkioe3W40693dLQ4Att82UbpqkcHJyLbGZbMZX3O2E3O6cM5RLEXrJZi4C
 kct12vDD
 ry2b43dvHbcEYrgQQTFUpsXrNirEw7Eeo9abbJSB+JHrBfQN0TWKsbmZOSmamHaTm5m1Rk87uQ5BNQIf8jluCP9qP1PMbNC3g4QUR2dDtGg2MkANZLN/9hYzDXrkd3SvSvDVvAnFiHZ2nEg5qL/zjdK5EU1qYt+pVpuRteyyJ8H7xGhFXoqu+/VZxOE7a+lBNeLGIzJI9EksIsM5peHz2ce1a5M1k6mVyrrY9kTrhwU+UvdrtxQnlsP/VijPVSPGCkq95vSOmaZjU4iHISnMzLW+pl9fr5iAfr6OElw7CgFnO9CNIiRe0RbV+U9QVrQATXLJn8RBQ9e5HvCIbxa8zlWt5Rlgn0x4kf+9jo5c1V7QHvI0BEZE4brKwz7tnx4Hj+3ODyk3Hm/nkV1kgCE0FeWBVcW8r1H59xyHq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 03:31:07AM -0400, Gregory Price wrote:
> A per-node vmstat counter is pgdat->vm_stat[] plus per-cpu deltas.
> A balanced counter can sit split as global=+N / per-cpu=-N.
> 
> The folds reconciling the split only walk online nodes, so when
> try_offline_node() marks a node offline - per-cpu deltas are stranded.
> 
> A subsequent online zeroes the per-cpu area but not pgdat->vm_stat[],
> orphaning the +N permanently. All NR_VM_NODE_STAT_ITEMS are affected.
> 
> Flush the deltas before the node leaves the online set.  A remote
> fold races the periodic per-cpu fold, so do it as per-cpu work.
> 
> Discovered when a node/compact call hung for a nearly empty node, as
> the math to determine throttling broke. Reproduced by repeated memory
> hotplug/unplug cycles on a node under pressure. NR_ISOLATED_ANON
> ratchets up and never returns to zero.
> 
> Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price <gourry@gourry.net>

Realized I changed the title on v2:
https://lore.kernel.org/linux-mm/20260627073107.523499-1-gourry@gourry.net/

Core issue was the zeroing at online time causing the skew, just have to
do the fold there instead.  disregard this version please

