Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C0EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADEF6B0095; Thu,  3 Sep 2026 12:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E876B0096; Thu,  3 Sep 2026 12:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E546B0098; Thu,  3 Sep 2026 12:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B53B26B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:02:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4946E160597
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:02:22 +0000 (UTC)
X-FDA: 85172918124.28.67982D7
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6CA1920007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:02:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="adp1/wPm";
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788451340;
	b=VhSC3gA3NVKUgmwTwXBJ/cDAfKYqMCw1fJ2xqSm8v57xNGr6ZOHuU3VYad20uV/p+zPFEk
	pGKA9trS1EDnogei8FyQTgsGSFQIyjKASjah5qVkf0Qo4/yQyQhgjCw5+E8F9AccNDSh4s
	A+a43f7ybi3ge2UeqvvW7uHadVTvQKE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="adp1/wPm";
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788451340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeBLEUe4Txls7CrzDF2+rKGQwzvkjoK2NOOxJbGtILE=;
	b=M3sNfmSaDP97MguAl5sFNZDDIu9VNCusIgMnv911HekBK2mtrF5PcqVk6ZvhF1zJWLszVa
	dN4nz76Etr7+sMhmbEZK6R94i4TPvdTXpyLRTluUBfuad3OSrsgevZUoHU2HWOgpymeaD9
	Z42mR4VnHbc1W8cxT2DJ80tHnGubR+Q=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-90cc372d6b2so287076d6.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 09:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788451339; x=1789056139; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IeBLEUe4Txls7CrzDF2+rKGQwzvkjoK2NOOxJbGtILE=;
        b=adp1/wPmxgCHO0arkzCjkvGYZFrjyrd4O5dmAA3L7n30CFdwRIz4+tOoxon2O3MoeL
         cGJ60gsKHxXRFBRPIiViwpIYsAzOFZ6g2pgXSqdW/Z8KEGopUaL9WK98C7wsUc5rOewb
         iau0ICNDiNZsNXPfxPL8zOSWHBSbUBDUDYnDbZrgNJKZPyH+dVux/m7ZR4v/SZ0zKY9G
         TKpDa8XHZELxE75n6EwZXZlxnJBu69bBdEZKJsieo+qk3AiDEpfgAObwS5gi3tchUaW1
         6L+fREeJ2bGrhz/63RU+u4OZtg2LT4piJtH9ys3NVy4pkciMX94En665y1FlgnlNaG43
         Kklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788451339; x=1789056139;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IeBLEUe4Txls7CrzDF2+rKGQwzvkjoK2NOOxJbGtILE=;
        b=ZFlaAwTvjwWpbFqjd4dWwRcbtbIscQYFR1I/QwvwBnhpkLyvW6Jti/4gL6pdFXimKY
         AFplQM/fTXVHEI/Mu7et7QaeZcHYZklt6TmceIEaonJLz/2MSTPn4BhDRH1Yoqkt4/KL
         lS9GePS23CV00/SHl5mU0B5McDkKQEWZljfy/tS7fnBs2lH728CpnR99Xh4LU7EmZsqZ
         cythbny/vu3f9RZ8fBRb7v1cB/biYqUQwd1rjHpnCvoqWmW7Wo7zpwwDgGYZF6vuQnlp
         DgJcm38gUQl2pGw7gFwTzPiRGI1IaXNPKjFbk5XjkV9vIdDCc3y6ACea8pToO1m2ov0I
         h8sw==
X-Gm-Message-State: AFuF++nYQRu0SbzkvQpgiBAxN0OkAMCm765NpZ0w9sw8XGdjV/Q6QaoU
	PIkzs3eUYLHHDa4JAu/6Dyb1T+zTt1HnfUrx/h9Jq2FxTj/aO4R8EZ+BwetP6wLqBuY=
X-Gm-Gg: AYBFou0/924qEKo73LD+B452hKyBS58KzwwXPeM4XHBTv3R5nzATXrx79AdZPu2Zg8y
	XvJFU/IDBJANdXaQAThnzyzeeUo3OCns1aoHDRpBDyJ9ao6s5TBh+YS/dvxd2WwW/iXMs/kOe6U
	Ys5J+SqPvGFoBF/zUXj5po1o94iTa58CZqth+Js7jpfXOZ0ovlPEZj2Jlfq5BFCnK+ln/BGDGin
	ynY9h7diB2kcYTT0yUmUeYHoKHHL9oDIbhz/eSAo2kPsuqrTpewJmKfpr0/My+mMaxy0whuogD9
	WSpTkrZEaf4/QYrlTprOE6498p5HVrOeOox/T89tyW52wSqlkfQDiqRQ1lk5F3ehNzQ1dDO49uh
	X2DYT5mvZcs+SFstxCgh/yci4fQGJCampsN0sb6wN2d7LrmrmYb7sf/VwTN3xf+unT3PxFZ3Aju
	DzP6xnk53s6l7lAKdD10nXB0F39LoppcWK5fE4EAdzZf14feKXcCrQq2Y0ONcNCQ2G4HW9FsXKP
	u4C6rqsXULdS5lXicDbyKVZvJTTYPpWkEGtCLuKNS/y3X00Zvqqzwo=
X-Received: by 2002:a05:620a:2893:b0:939:13bf:e861 with SMTP id af79cd13be357-93960fdf704mr1567190185a.40.1788451337838;
        Thu, 03 Sep 2026 09:02:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ee06c72sm47345616d6.3.2026.09.03.09.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 09:02:17 -0700 (PDT)
Date: Thu, 3 Sep 2026 12:02:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH 2/2] mm/page_alloc: refactor build_node_zonelist() out of
 build_zonelists()
Message-ID: <apmYmJSrOX7JyUVY@gourry-fedora-PF4VCD3F>
References: <20260902215853.156267-1-gourry@gourry.net>
 <20260902215853.156267-3-gourry@gourry.net>
 <9f67cacc-b063-48b7-81af-09858aa5dcdb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f67cacc-b063-48b7-81af-09858aa5dcdb@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CA1920007
X-Stat-Signature: t5a9gttitrfon3ebusk4hjbzmzfxq11e
X-HE-Tag: 1788451340-984214
X-HE-Meta: U2FsdGVkX1+itBxFwDV+O/DcvWJIVl5tIQ9qUAGzct6QhnuWr/IGrTu/PSebM5J/OrxXiv/2d0nkNiD7iQKe/LqBBZ2fnQ9QW3a/K5Df2NWQEkKRhHxKqTpkkwfSn4A54JMV5NuWvoCbDdjWcKLFPXVXvYH19DcVsaKOmCF6LTd1WTMTqidafSHE/3e1YxiCWwhd4PqjqhYBo5FdLIpprnNK+c6SI4JN7jBiI1DiU3kLeBQGMdMHnS3gKw3KUBtbtSCzRGSYh60erkMscMtGlOyMCkd7bQioLkqBkLRmKUwzxZ0DEYcHIXrSksa75NWcSQ2L1OHgg7chSWM4lrX0vDiaQ84MZwd57kMzCxIH4mw0VfiCyVhiiEHN/lyPhv1sAmYFDnZaXiX8lY2uf0eKc180tuqTo5L8GIVBGxgbdJBwnjFodngYYny1Y2CAH+cdFRu2UNTuAYb/PK/vzPCl39T09L9hGCwO4j9XvOKxGu8xVTfbMg7PFzyEaWRYcAfgKLRdhMhSiaCjoF2PizfUC6z+RgA/Kbw9IwKRYQN6r+K4JEDexzE7s2TdXkxjzH8goO9F7klODzHGGlgRSr9dT0so0voszXmOihcRHmX1wBeP/dHIpf80H+TfVB6NR47iAXQ8wEMnqboTtaeXkBiazmK7zKSbtqTw8UQkQq4c+KO0UY3nHGr/LJP0XAAuWChn1KN3nWWDj1a2Gvwd806LdNr2imb4Q6pg0+TjR657cAQ/IRFl+S7dL0FEJgn/rHK/f04zrOjVv4Vapno6hX83RmeqjIKl542bFfovnYz11B1QBh03aYZYKRVQ0C2I6gEIyeKdIClm24K07CgMIyWsvKRV+5UkC/1Gl+3vrw5HNMutZMJcbZq4gTNzXi0lxwP/z1QUf70GLTKfz/jIcjfOfd/Pk2hOqaEMjidHgogYx7PogBv1C75rxLIymrxN5rk/kJxytG4KOkxjzq8PQ2y
 /fjsm8nd
 G4b6ESKWd9CQNTGIa5zHfVKz8TTAIJhpdtmPvxtgXfMfSvsJc91IV9h22n+GutL+zwMg2wzRcT4qV+WFV1TeXFReUwILgFaw2fbhWM6A0Ux8c1TY1U1qpMmEk644zXJGxf+M5PdMJnKKgTD07bdOwvMEJeIyhmm9K/58XkoUMAO0SORSvd1ST7jWUKECuzQfWX+JN5uyKpAqvbibURQsgsZvEkeo64p8TiRw2NH//paSR56UPLYuTqqlHORR0EbVnuqI+wypbD+BqG/v5AndkWQVm5WfwGpflNZcHqi4d9/LsUgBAqLB6M3fFnF4mShOP/UHFZfdDwAb/5Ztaj7E73exocP5D+vEVxwifC6w5dbvQGD0enRIAYI2qClr/H9W+TzsX0+Ks7lpDkeZh3a3mVNWpEAMMLEVnAR9lqQK/jx2eJ2mcYuDermhgnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 05:33:42PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/2/26 23:58, Gregory Price wrote:
> > Extract per-node fallback-list construction into build_node_zonelist().
> > 
> > This lets us build new zonelists from candidate nodemasks instead of
> > just the default N_MEMORY node state list.
> > 
> > No functional change: build_zonelists() builds the same FALLBACK list over
> > N_MEMORY with node_load updates as before.
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> 
> LGTM, but, while we're at it, could we just do the pr_cont() printing in
> build_node_zonelist() itself (maybe behind a flag if you don't want to print
> from future new caller) so it doesn't need to pass nr_nodes back to
> build_zonelists(). Then also the node_order array could live in
> build_node_zonelist() itself?
>

Seems trivial enough, will let this sit for a minute and spin a v2.

> Actually I wonder if we could get ride of the node_order array completely.
> It would mean the loop processing in build_zonelists_in_node_order() would
> have to be done piece-meal in build_node_zonelist() itself. But seems
> feasible? Depends on how you intend to reuse/extend the new functions later,
> I guess...
> 

I can take a look.  We've been testing a couple different things, will
see how well things generalize (private node fallback lists, inverted
fallback lists for proactive reclaim node ordering, some other stuff).

~Gregory

