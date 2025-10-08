Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9316BCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE458E004E; Wed,  8 Oct 2025 15:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA59F8E0002; Wed,  8 Oct 2025 15:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC6C8E004E; Wed,  8 Oct 2025 15:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8A938E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:44:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F49013BA0D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:44:09 +0000 (UTC)
X-FDA: 83975973018.26.DD0412E
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 507CE1C000F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:44:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pYt9mLcd;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759952647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vflrBSpkNsrYFG4aEkF621olmmdCSiqIKbvUazecPWQ=;
	b=uNJpg13v2cueR/7sojt0SL2GnEYVbth1kxCS86TNLzPv/E6hEd2IvRD8k7TANrX+3iOog4
	ojxwZJRG3dLvbrP9wgaVBqyXdcndjLXcLeCaJ+xefAMgSS3g56tOZa8cmo8hmBVszOmmV+
	/AoHDm+FoHkbrNRb6YmJuB4EhoRXdTA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pYt9mLcd;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759952647; a=rsa-sha256;
	cv=none;
	b=3Fz1trTggtb3nZZ3IZoE95jYQ+sGd0qdhm52LpMc6OOXkBpBe5zIZ2u93qY5CZFrnu7jOF
	mDi+yETWo05mPrGlIxZ/dgOLXbCqIW0mGIOfSWp+CsxZWm+EDMZ+sG4pwdBIIh3LSwkKW2
	quFR1R7XR/W8guekk1fWjk3Y5d7oC/Q=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4d9f7a34daaso1490681cf.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 12:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759952646; x=1760557446; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vflrBSpkNsrYFG4aEkF621olmmdCSiqIKbvUazecPWQ=;
        b=pYt9mLcdjDYorlsW6urov04GAYqYPbeHVsr64mIT9JdJkO/Toz8W1zg7O4n+Ir7U33
         MXKp1sdqHI1DShqmt6OyxtTtkVFnkWvm1+wH9m/pkJO3HYhNuvPXjVj5q7UC95MRBBmO
         2N/QIIjHUYUOlWVvds1VGeH4WgtQKivKpqVcAqDioRqQoRXoFzp1hWVywUoWFd4rkpDj
         hYz0qlpTWhGvTM6laymYh6skUWp8Dc59Ub7KDg7F1O7W6ZbLNQkrBu9FoRC5G2D7mKhJ
         BocjZp3yqqfS8PH4IOKx4PHy48cxe1uNoTmS9vs488PFKF96vnGSjEbdWUzAgDvPKBMw
         QTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759952646; x=1760557446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vflrBSpkNsrYFG4aEkF621olmmdCSiqIKbvUazecPWQ=;
        b=DrHmmLpefSS9AWAFRzOfgeU6n3HXUvXo/tBH7rB6LW2n4K/WB0SLqOygiio9Cywyqs
         kqQz92VoLoz4zSHNSGobhXH5ooSQSB1+oR8hOoZP25nszEkTfdYX800rqzB1V4aehnfr
         uw17+XhqY9rriHPcZSSuT9yRHSS+e6RUMjjUsSJYuedBwBnHyMHSGV5gP8Nkrj+/K4VP
         fYNVmVOqeLbgeWYjHqsytwkcZV/RIplaNmSHa0oM0Q5uUXNivWrLBZlH/aHZV8IeXo6T
         9qxrofbib0DLDe0s1TF/gXyr6wqE+9HvyKStrSBCAgebWQDNrtsMNaPr9ajP1nGV/HwO
         eJTA==
X-Gm-Message-State: AOJu0YzUwZ+gdWdkw17NbtdMZ70qJXyB/EcDTbqPTAe9uDX08KR/bGtX
	8/hXvbFfJCOsiJOKzFhsYUne4sB1Lh9vLnTc0L2CfpxtTN9HeCSHKiSKwjKO6qMtURA=
X-Gm-Gg: ASbGncvbYKNVLsJRB4hLRlwZ+EI7ED+LSLJXyC3b5UbIE3Ef8WdVMCOTFzTpOHjeeL+
	4EKxzo5vsNHKI0vtz17+eixl2JPYNxxIcJ9VDUh5g5n/roSJNrtRqot9fMopn5q+/Bw+1s2C216
	w1PNHMDRh43TGLLz6gBvIXeacXzHIgsD0H7iQs2CM57QhZjgEfQGxLckAeRTA4OUhEj+05BQ3Wn
	txaVyZJL8UabRFMHkKsuerCO1b9W4myB8FxAoPQjoPHwyhPBExkjiwdd2P3QKqkSBxMcwx3EGqZ
	DS4A6cn2ndXLeHU8tMzx+j2VHCQ+LjeERi12KjfVcFqwEo5hUbOgziT71mw768hOkjRGX3sl0T0
	AT9EvwcpNxjzwTLWgVh9cfunGNNiBdixJUreiNLG8z/NJlYPVKZTfUC2wayYDXhNFCNuikEQffk
	nyeo5MsNbDeSp9hAygvCQOIjkfiJ7+36wpR8SjUtqd
X-Google-Smtp-Source: AGHT+IEt2akHgGZEKwCwlTLJzKYM/iMK/f7JPmuxQehpQT5vGVvCZLvTXGY+F0lhMaWM66A92qQEEg==
X-Received: by 2002:a05:622a:590b:b0:4df:bba:5acc with SMTP id d75a77b69052e-4e6ead7788emr71769211cf.79.1759952646315;
        Wed, 08 Oct 2025 12:44:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e55a34c6e5sm170740411cf.6.2025.10.08.12.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 12:44:05 -0700 (PDT)
Date: Wed, 8 Oct 2025 15:44:03 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
	laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
	joel.granados@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOa_A_i1HUt1wzCj@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZyt-7sf5PFCdpb@gourry-fedora-PF4VCD3F>
 <f4d0e176-b1d4-47f0-be76-4bff3dd7339a@redhat.com>
 <aOa0UPnxJVGvqc8S@gourry-fedora-PF4VCD3F>
 <b6d472ba-e6cf-4c96-935d-88c842ab3cd8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6d472ba-e6cf-4c96-935d-88c842ab3cd8@redhat.com>
X-Stat-Signature: qwzqzn41614qynkhkk5pbfuyauz4z6po
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 507CE1C000F
X-HE-Tag: 1759952647-12069
X-HE-Meta: U2FsdGVkX18qxn6H3gHRhcJ4WxaA1J6QOP37d/ufHGlwXPrf/hmVYpSrtk1oBNK4pcmfwQ3bmNFjHrrNWCInkEu47TdhjPrwIOBgUZSWhzTYdZ7xABqYVDZXIHtFmqQhQLl+kdChjN0mXaP7hzbo1kGOSAMFdwX+4/QmSKhEKVtKj5tBzDLr0eLUaqOUeICiL/91uJDATW8DAdC0ls/TsYzBdna3//CRrY/YDvrzKScQmZpSFKP/mt70D1x/wyEvfz1vcEew487k0GT/AKma2fLsCLlNkLZ40ulVEUH2Xy4SMzXqWE7x1kBKGgOFgATWrma0WyO6NZSuuhITl49O8mh6eBCW37ZkiD38qyrXdxT4otzAEVLpPvDVF1ZztaYE5ug3OglWiaslqAZnPf0ROXvzYVct9QLtj2oGWs5bOOhK2Z3DMbbu2AenzXSB73WopvwZ0btnU3c0TXH59a8d5ehJYzShybkyqWYfzeplhuuuoo7jTF9HQMQoaSE/MSuX89JmGoTo/tPXTClkwERrausb5zxkjcxQIewm9iioYyqnnH7s39RWRBiVRzRc0BXapxmmqqeqMlLsBG2xIQytFEazUfZwj+hErVodHqvqd3q77Q831MDDgtXaE3POeka5V/UneUaC6bL0nDLn4SAx1x2JTWEM2aM7LKm/k1CL2d4QEanLBYPSYxnOwrhqn6zdLLXjblqa+f0yI3lH3lCvvwE1VsW61uWA8zI7Wqpxb49NCJNvnGTlT3KKu7DcGl3VKG81l9nt2NQ+Qv6Z04wov44nMWfOd1Xs+/yMyCNKOMOlqhzt6qZ/FlK1UWsj4Vm4I4WAEl0Iq8x618CNXjxnbtj2mOD2wq/7RxKNDutGYu87t06BYXXEL5MVnmD2Cqb84jL2uDrI65jNttzDwK6kIIv+5TdJtUyNxXSliHcHMwP8jvJ4Bxq+9taSc9VlBt3QWOGRvX7gFmIXROJHYKf
 11lRF3Gw
 Oig6ivTpl7egMsiobXsJNxFre+Jy6K92vDMX+J4cFnJRp++Zi29q8RVrJHEDrnDVo6dr9/kVU5ZEXDGY9jm6cv1iWZrSCvQyZXSEBMddw2lNQhiMimgV1fpoVwbE8Gb6UCd5Uc+8lwqj3oUJzvHS+9shPSUD2kRNcT9LoauCcRmwMZr4LwKVqoHF6VxzYOT+bOWaKGukk4WzpSblb/Wv3Uxfg2MpFyuQU1Nnh1KocxvT8DKLRwKY06lihqMYU08cN2DjyJq7aGCTPp+OeRH5bv2qqzdvPj4/8nc2Z1u0kaGQ0YcpRiC9FSea3GRl8i7xLEMmsC9kfForiaeC+oqIdxLgRJCoxEOD8NzKO9diBCA1wrsrvWa59qgKGKAU9j5C/VIn7Nb8ArTMibh3UCd9zUcz0k3d1dYyAQIQweoeHiP5EDT4JCdUimqrVcwTKzVD7vBjg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 09:01:09PM +0200, David Hildenbrand wrote:
> > 
> > fwiw this works cleanly.  Just dropping this here, but should continue
> > the zone conversation.  I need to check, but does this actually allow
> > pinnable allocations?  I thought pinning kicked off migration.
> 
> Yes, it should because longterm pinning -> unmovable.
> 

You know i just realized, my test here only works before I allocated 1GB
pages on both node0 and node1.  If I only allocate 1gb hugetlb on node1,
then the migrate pages call fails - because there are no 1gb pages
available there.

I imagine this would cause hot-unplug/offline to fail since it uses the
same migration mechanisms.

Worse I would imagine this would fail for 2MB.

Seems like the 1GB limitation is arbitrary if 2MB causes the same issue.

~Gregory

