Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75492D6AAE9
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 16:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAFD6B0096; Thu,  2 Apr 2026 12:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2526B0098; Thu,  2 Apr 2026 12:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC85D6B0099; Thu,  2 Apr 2026 12:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC0356B0096
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:06:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B84AE183D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:06:19 +0000 (UTC)
X-FDA: 84614092878.28.D77A7E0
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 272D218001D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:06:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ajo97nw+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775145977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ax0ee0zXk96CqJlbPgmPN6rovtTH40aoKmXSHJn/bVQ=;
	b=1a/yn9LsU3fyxQ5ezHcRthVUxUaHxhXFMWSXguoPqXNp3EzWOSiYRdZfLOR4I8N5RnHIuj
	XW5ebKCsa97KjcUapy2BG1dAo/6lIlQu3sc8p2uZc6bv0oGQBKFKJvV7R+xtMpxf9fBWx5
	EGGTz9dzq4y65IR4TdzLcEDLnaXv1OY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775145977; a=rsa-sha256;
	cv=none;
	b=g/vLRr3C4Y+FW6U2rMK52fOloEkXcXx4rEisSGOcicDUHm2GxWu02lu/T7gYkQhOkki+jf
	U2qcSFaCutNQ2ZIY3Xb8pRau0eii2gbp3p+rTZCNlOo+uVw4gdIMbHW339QMMYKRLQDqFM
	Y00bPy9/JVb+2I8LyFaQ3Rb3rEBMbuc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ajo97nw+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-38c551f2497so10349711fa.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 09:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775145975; x=1775750775; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ax0ee0zXk96CqJlbPgmPN6rovtTH40aoKmXSHJn/bVQ=;
        b=Ajo97nw+3ok49HTaIkPzts4wKBB9nN4yRiX9EVFLMll9alps8kDwkbblOxBNVsfD86
         bmyzYgbtKYMqSPOvSWK5fhAaOFR8wJgqiG+CtaPyKf/6K7hlSQklG+QGgD9ofn2wwBI2
         +TLZzCkinHPSE0IgBMHAYYZtG9JCFdgWVtiuJe/vJVB5yOlibABp8ze026BengOEPp8d
         WbMcMPPj3NgqG1rh3zHJOjZ1MWUNDobTgZyS+GTLC6bsGktXKKybWfUiWOBoGknzgsug
         SLEo5l+FLG/PFJ8dPcZJs6CEqc0ExT5NyD9Np5OyhnAeA2zCsxyZYmdKyx/kddl1F51A
         qSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775145975; x=1775750775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ax0ee0zXk96CqJlbPgmPN6rovtTH40aoKmXSHJn/bVQ=;
        b=XlVOlwG3Yssc2RJ77dOLOQr9KGpLa8wsuHz/OJXfDz6RXap/Y/I2FZwC0WGeh7Zlwe
         o/gUR/3YeVQm8SZwA7E2oyaTZFg9qnw5dkrhBKRT2QuPCXIeGhv5MMgcHuY8ANnl43u1
         jPT+aoLVdqkhoAf7pMzGjDPlF6DlJ2k+JrY2Mii3Qx/d3q1NiIpjpCDEuyDikan0Y9KG
         Dg6C9IvaWSWK9ZzEdgfqTqQ6JZvyq9qJF6O+le9ePiQKwIdhV3a1uPOlfPGl4jjmoGxY
         hMg6wxgiV5og12EeFfs5sVVsSEupB5Ksrnke0MmNtdDU9M3+ZlLHaisI37auLqy9ScKh
         ZIeA==
X-Forwarded-Encrypted: i=1; AJvYcCUJUmV58VSCth3I10cHxcyTEAciKTmLOZ0l3VjMkyLN8C8Zn0hndLvK2Ft0amKBlqwNolLVPRky7Q==@kvack.org
X-Gm-Message-State: AOJu0YwLbceF/ZZ9BK/qnKjqbAZUhA5q1HI0h3nQJccednj/sQt9pb9N
	tHFCZ6H1GFqELGgTeNYd9xicDYnA0ca3OfR2GW3vAUEkgQ35605yWAzz
X-Gm-Gg: ATEYQzyaHh12VY4RKFSFGAY2rKF82I1qCN15Y9P1k/RFN+qA/IyinHHoD9VVeKHGHGK
	hq//27zwBCjU5z/1f89deU1mADpkcvS2wLtZKXXiVJn0GiDHzgFB9ivu6lRMTfHcUGEhT/DZxO7
	iUvdkXX/81TF0V58sUtMU0iN/QRBRmH7vKQqkTCXPPdNgbz8inZGWtWDVzPgwpZyTlcXmHfIoq/
	45jjOS2HHx4TEbvxSdAmNdDBozHaGFyEf8/rPoV9EXRf5EQjjfEM5Wsrks3ow+OL+cGn0Ncbxmz
	AIgUc/xNhbBgmsDBjTNURVbwr2yu13GDxr1hjuGh27KV3CYEWGZqBe3tWjYvNJa95ZfYPud7aiP
	OromHAoZtd4XbVW4DRYtKLtv5SROuhi4V6QgILL8oH+ET1okXgd1+1SR3RYyjH7fT
X-Received: by 2002:a05:651c:324b:b0:37c:d689:7e1c with SMTP id 38308e7fff4ca-38cc3072eeamr33114671fa.23.1775145975273;
        Thu, 02 Apr 2026 09:06:15 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38cd217ba60sm6326461fa.38.2026.04.02.09.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 09:06:14 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 2 Apr 2026 18:06:13 +0200
To: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v3] mm/vmalloc: Use dedicated unbound workqueues for vmap
 drain
Message-ID: <ac6T9YJCA2xUbHsv@milan>
References: <20260331202352.879718-1-urezki@gmail.com>
 <ac227uLhjH8pETb5@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac227uLhjH8pETb5@fedora>
X-Rspamd-Queue-Id: 272D218001D
X-Stat-Signature: amghi1t5z88c3kpe9geu1bbkhwn1owi7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775145976-595259
X-HE-Meta: U2FsdGVkX1/zKcDrVOoLMAg726Ws2wQ5y05bIwFJYfI5zOKPc/kzs4xx06npRbFy/5MHkK+UkteNBEgtwi3aseaTqZD3eQtVA/A8azwHC1jmCNMuemjtCZ1r8Wy+vNoGRCDTcGYQCrxEm8rCmXagjVDWhlU5JfVQuMI4Gv1WBsvREsHGmxZsB33uhaESbzqy9j2VBK1e8vT6M2DYn7cw96uEeQd+OOu4tb+JIP448BuRsmrM9ufgVkFWndlL79ibc7OaFFLy24NoprhJ9UJNIVOq/WYfCYOQXL16CYpnc52wHyIAPUhhkTskDIgRrSmwc5yTTbgIaAnqy8QJTTaP3CkuvaGMtTlbrpWVThGOucYLVaaOKRmRpvBE5CxS4I+RH4ssdE7FD/DwRaxNzKx7qwXpywizOyqIQK0ItFCDu+FnGSDADMiBwNh8MqnBq9r82XvN/6g4NtXqoP9AWyR//SFFWYUqyYrOwerNOO1uoN3AMsZSB7SnD9jPVIC8PZ7XT9Ow9+ROtWwz4FssseMtWPkJKboGQglA65wlUlGTORwZ7/BEDZVWC3uP2VOILkB6YB87wC7QktVKicUNnPNbCvMHBU/Qa+IvJOCSIjs6SBOQiiJCoTtUt9quMeikpLvLJ2/q59iucakETsLd9H21bfHbm12lfMeYj4wGHCsKPa6BRulcwFNQu5wfvffzhRnfvtF5nMlJEkGsOm20YhOFVZPHpfRg5p/Hlv3ofEG4oVMjoG4qo0dowYW8Tv/ejqV5h0kr2FBej7gQxEoZPcA12ljaKfxRsntLRFuKf3TkqlHBnKikKPSWtfjwbU07a7bdGqGvkqxGtV8DzMteepPvfVGKZMVaVdjb9Ig6h57VNuhvO86nn//PpzbLvMV/HTfYfMkTmNDK+4zDs+TClWbqAmYalclj2RreGwKsw/2NE1kKmGnDu9qNhkuoQdefM8dr73lXqiG8oTxWfBwpHSN
 fCsXyart
 Y+GazeO9ve5WZBQpaqD4Alj1q9Evv4z7KC9akjjSF1V451SXQLfO4QARahNb6XbvTIlAayIwc10ODQwjsXOdt3ZGHi8GYQx1O4y6PznAUIKnv4hXTjTfC8csPWzVTeVeisEGSwh4xYCGAlnVUm1t3tP4tcSIhm5Jrxn03BO7yiSyOs7y8JL9WX/6C/kKJw7kP9W2//5fKQJFZrt85vuNIU/PLZPsBd6+oyoKjjMSfxlKrR12Z+ZzfOynUghtN/OuOmpM4+gjyKz2pW3q+h7axRYkwZLipD/7VVCCT/MiCsJgRZ0C6lIfqF8mOaJgmNNs/nKsDrplXBmZ3nRvc2hcBCn5fNu9rZJGa8JSaKGV68rNb+XmhhvQA+3owTP/h45pymrg+WgpeWvReha3ujgiXh1ZqstQLUht4o1vN/Qt6f7INrx75xdrgMDXwtf/Pjajc3s1Y4ymQ8lzJtmoLL0K0BPB9QgHGVX4yGFJDAkF+xFlypPXVyY9SF8Ok8QnpT7KMNaKAM9o9Yu9xposhdjkwHVZqmUXql5YyQ5h2O6+PMPdLyErR5Jhx1Fg3u4WK+vmMcQ9CyARMGc9h4MO8j4k2xS1KfRiM/vq3FJX/9X8oEbXVdmgYRHs5Oax7jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 08:23:10AM +0800, Baoquan He wrote:
> On 03/31/26 at 10:23pm, Uladzislau Rezki (Sony) wrote:
> > drain_vmap_area_work() function can take >10ms to complete
> > when there are many accumulated vmap areas in a system with
> > high CPU count, causing workqueue watchdog warnings when run
> > via schedule_work():
> > 
> >   workqueue: drain_vmap_area_work hogged CPU for >10000us
> > 
> > Move the top-level drain work to a dedicated WQ_UNBOUND
> > workqueue so the scheduler can run this background work
> > on any available CPU, improving responsiveness. Use the
> > WQ_MEM_RECLAIM to ensure forward progress under memory
> > pressure.
> > 
> > Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> > workqueue. This allows drain_vmap_work to wait for helpers
> > completion without creating dependency on the same rescuer
> > thread and avoid a potential parent/child deadlock.
> > 
> > Simplify purge helper scheduling by removing cpumask-based
> > iteration to iterating directly over vmap nodes checking
> > work_queued state.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: lirongqing <lirongqing@baidu.com>
> > Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
> > Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > ---
> >  mm/vmalloc.c | 79 ++++++++++++++++++++++++++++++++++------------------
> >  1 file changed, 52 insertions(+), 27 deletions(-)
> 
> LGTM,
> 
> Reviewed-by: Baoquan He <bhe@redhat.com>
> 
Thanks!

--
Uladzislau Rezki

