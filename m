Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF724C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 20:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922606B05C4; Thu, 13 Aug 2026 16:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC806B05C5; Thu, 13 Aug 2026 16:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773F56B05C6; Thu, 13 Aug 2026 16:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD2B6B05C4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:49:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2EB1C0239
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:49:42 +0000 (UTC)
X-FDA: 85097437404.23.30B01B3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 80FCD1C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:49:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JFEcIGok;
	spf=pass (imf18.hostedemail.com: domain of sandeen@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=sandeen@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786654180;
	b=5sbmcSbbU9hsQtyObAEjB+Ih/oMoKs3YFIssFwTKsgsCw+y5P2bUEgTF3hT4aHOTjln3Ia
	rjRdv6nfhV8CHleCAVlTkgHAnsXqXTSKQCVYZXCydDf/JN8VOvGCVUzzfkgIzJHT491NgY
	BmqN3f/co91t4IzT3vcq+zVjwhLH9AQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JFEcIGok;
	spf=pass (imf18.hostedemail.com: domain of sandeen@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=sandeen@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786654180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8ee/7/7LFhDMIG88sH2aB7kMuWCpyP7z/i5rm3JMrEk=;
	b=nRccJVHpoi/c8ovqTuazFrhswi6TAaUSuzJzlexEwge3pwVr1g6cARUTN/ULoPy0yUxEcv
	FmCAAk3BW/E4bE29eMxoL47suHJUfGcqcefyy4O0eAu8BmLkQREKohhluGrHvF1xw/v5xy
	iUZBCZdTRsiR8c3YJb+vb9ho0p84VrQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786654179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8ee/7/7LFhDMIG88sH2aB7kMuWCpyP7z/i5rm3JMrEk=;
	b=JFEcIGokf83niZnZ3vBTLlBQ7wzmGZUBKZjc4m+V/1qSLkqIgZfyXp5AXCtVzX5BJd3PmU
	In1/kmZzCOeSVJrkWzIZonT7usbU7poyJ0k7/IkaY+QsLgFzt5l0wp3FLAXoskE0K2HHYw
	Ltjk6L0XRIBW76+C82Hxw6LcsWk1y8o=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-XfB2LLYYNOqg3scMNsBZhA-1; Thu, 13 Aug 2026 16:49:33 -0400
X-MC-Unique: XfB2LLYYNOqg3scMNsBZhA-1
X-Mimecast-MFC-AGG-ID: XfB2LLYYNOqg3scMNsBZhA_1786654173
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49f3a97f1caso153684b6e.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786654173; x=1787258973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ee/7/7LFhDMIG88sH2aB7kMuWCpyP7z/i5rm3JMrEk=;
        b=jXeI0K1FSfVNAi6DfwxnA3IlPDYeN1Y/fdA1kVO27wRIV/Nu+8buFFDG0838/iGGLv
         0a7b+q4O1pew6+PqdlkwJGVVSHG/jW2ecOL8KWlXsb3lBnliYpZO3csNf81qT4alDelw
         TR2TaFfNU6AuuTVD7787eScqtvC4j+AvEh8sqDJvTi3/AkTU12GwZ9TIIXdp4CQ38Fn/
         wZySD/GQUA/R2tcyUDT5+V43Npd9T+HvslyTc9VJWRvrJacqlYIaxc22rxgubWu3/PQh
         hYr6qqr8SF5eUGiJI822cwWUB64PpJKmlZ7wZWCgcmCntK4HRWKoiufErjzjsJv3q+Kk
         CitA==
X-Gm-Message-State: AOJu0Yz4hy2Lzv7J89be27/Uq3M0CGfDAEt6MYrgzIjixCGvrclvfxE5
	ka4UQabrPsFut/hPOhVoY/1odp6FSy7jJEv7OFVmJ4KTNfu6cS77Di22S8U4HoLWGs2VpA8YRMs
	QLZOuf6KYMF9kdGJ+BzoM7ebSHqJvAZE68Sn8TBIzuRchiOjtTAS/
X-Gm-Gg: AR+sD12oWmigkcmK7Ta4qXsbs+SGjMjjWKMP9OUgAPm8bvj4GbhKxII4ccJ/l3Wtl7C
	0qKT41Frt2oeJG2ufn1lTE2G4aELcEkdlBx1H8DTz5K/xpOB6OEswyyiMRvxPT6On87d9VyrW7T
	DxD8InWXQ2Skk6Cc1oKcrf8BqwMd0CQpOBhyDFe8PqkXy//0clHlcnPXfbc1iASh8HA925ZTOF2
	6xavezZ/Yuql6EXKAg30iQcPCeVjtqvPZGDy55Kg6OfZjYtXg9+GuZAL32av75Kb8uQkTsmZDNb
	S2bDXr0if44LyTSuhsQMosDMGBo4gPPQlZRfvCqEhKGNKEzqxW5xbOtqQjJseYMEXRUx6hfw0/k
	fVQrszyrPKp8i+9tDu7lgnuQbMg+IX0qKvFvydQ/0+Fg=
X-Received: by 2002:a05:6808:538d:b0:49b:33c8:4b75 with SMTP id 5614622812f47-4b2412c1b14mr769291b6e.5.1786654172934;
        Thu, 13 Aug 2026 13:49:32 -0700 (PDT)
X-Received: by 2002:a05:6808:538d:b0:49b:33c8:4b75 with SMTP id 5614622812f47-4b2412c1b14mr769258b6e.5.1786654172451;
        Thu, 13 Aug 2026 13:49:32 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b22d004c3csm2555958b6e.18.2026.08.13.13.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 13:49:32 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: xfs: properly account xfs_buf items as reclaimable
Date: Thu, 13 Aug 2026 15:40:51 -0500
Message-ID: <20260813204929.2253988-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bykcP-0J73zWu7dxrOfVDnXKQYkXKha9YceASiiRtFQ_1786654173
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80FCD1C0002
X-Stat-Signature: zcdqzirfbzs4txhdyzqxkek6s8pgzh44
X-HE-Tag: 1786654180-452835
X-HE-Meta: U2FsdGVkX18vvCluwAyfUjwitapzHzCuxwjgeVbiuF/Pu8FZdLfkj6Q6tpooIcaE07dvcs6O92i02h94tY+SDJ8hVWUfVxlois2JJXRFe0MyDc07ZGcYgPP6Po/vW6QfCzjIsw38uzcK1V/AX+poguKZyqzEl7anZa9f7rv8RNXS9Lcx9obhKDJParD+8trF4DHk3LuF3YCvdX8CRi4Lvo8iLQzCqAoaB0y274rjEBJn1N1goLW1DfXdjIXmRjhOZyVXOaobW4WkIA8ohnQ2uMtnecj4WTqRNFQb44v2byMRFTz6A56SIewRE94WxAQ39CvJcj67HG9O/ZguOjTrj3vuGX+PdG+C1BPMIcUWt8lo87CbL9LSyaYb9WlgIS07aaDQ4C5Ro30MeuHl5p9x5js+pJ1H5XNnt4W1q7jgdbU8Lx5LNMqpzSVB2pyy/fg3cUiKpGcJzKKXIJdYVxYUVSBGxGy8e3ZqW+K30XQ7nUGa6mg20Yabpz3MBH9xb3LN6o56Y9+H5LCThl+4g18YZC1J3wfrTXQLBc56GTYJT0yO6e/KLbBsB8VsYQ3F72M7tNvXvXPWEly90Uw/hkK33NkAi3W4Vu7Ry4PVWMEgnXDuAghAdwPINgTTTj7wlRw56SIOXrFnzxfblaeal9GmhEkl/wjsNvvf7X9CXdBMNZC6j+pN57jnRprbIgc+sujl1DcxCQb6yfDAuW0dPv6VB1A8FDUc4llgA8f0VqIS9kY1lPw+jFOVcHazpYgqfAG4KL757DzC1KvaJ2M7TaK9Z+lMdcgNj6zrOcsEhMsSvmmRz8bL2q/oWUcFeV/sLcAR+oLwODDbqUrW3ej7/+SDEirrmGvINBU7f9xUT9lCMg82jMvqwucqq6cUVvHq33yuO44eBxx1Umk9OHD0iDHZCPeT8gcZvmxoB4WHePTMuhd4hjvPtvYYdV0mk0pvNoKjcyqLcIEBfqkmeuwY9Xy
 t6dM5N05
 CRz1rSdG3IEDfJvMgT63b8QJNAONHZQn50wdsv4nc4o/ipI5fSdEeHkT5XhLQFAT2tvKP4ja6c52DIYTweT6mCaW7gWBZrbkMnXDBd7PlmorkZ/nYp1qHU/Oga2lLWS6r9efnBZCXCgqDrDCBwEgjQhSpHaUVF8BGoOGgjdhZZrxDzCm18sMwyfKKHR88z3dLvfi+Fzl5ZzuIcYEEyON6abs22x2VqsFkZ33SmDspJisL8SPUJ04GJuQbP1gKFZplekCqd8H6621tDUHwyA18Pa+aevXFQPJxhUXRksMm4bO8Pe00B1I4KUcDEMpE/2XdUDgGc0JqI3tdl++ryj/BjuRROg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was reported that xfs_buf items are not accounted for as
reclaimable, and therefore various statistics in /proc/meminfo
and /proc/vmstat do not reflect their reclaimable nature as
other slab-allocated items with shrinkers would do, which in
turn affects the accuracy of stats such as MemAvailable.

2 patches here to add accounting for xfs_bufs allocated via
xfs_buf_alloc_kmem() and via xfs_buf_alloc_folio().

I was not sure how to handle xfs_buf_alloc_vmalloc but I think
that's a relatively rare path, and the above two will capture
the majority of xfs_buf allocations.

I've cc:d linux-mm just because i think this is the first
user of NR_KERNEL_MISC_RECLAIMABLE in the tree?

Thanks,
-Eric


