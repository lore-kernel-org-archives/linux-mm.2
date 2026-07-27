Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E024C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 08:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C086B007B; Mon, 27 Jul 2026 04:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD1E6B0088; Mon, 27 Jul 2026 04:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB9E6B008C; Mon, 27 Jul 2026 04:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 796786B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:19:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6DB6A06A5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:19:57 +0000 (UTC)
X-FDA: 85033858434.15.EFFA120
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1355D100002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:19:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NqbAP8C9;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785140396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ADtoclqK+MoHDwfgYPV0XT59G0S5UqppnClfzEaKuk=;
	b=Sptw+SXP3IBmmQ/+2w5XHtlju/2FaD0kK6XOCCr7cpl8USIGlRyWDpX/5xN7KaNNTtvBse
	g6C06wEKak4Hjtrsi6ephx7C+dBjLOoVf09JV6FuURHqq8EjhB6yD89vPBLGtFWVsBz35h
	bANMLS0MljV8abDTe8WAayDSo5H2Sy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785140396;
	b=J4ltE1o84xRbjnar4oM4TklI5KLMe/2U8VLrQNsickPAbkmokfotD4Lq5/nlz2BBYaZM3D
	4ne8IjIoMMp5Jb3izWfNfREyUWCoEbWqkkgrSPvUi5dbB13h/fk+sjsM8y0IQfG60mUhye
	a3enXANNNjG3mYSwCGSzN39dYmKgOl4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NqbAP8C9;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4957eefd361so18247145e9.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785140395; x=1785745195; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3ADtoclqK+MoHDwfgYPV0XT59G0S5UqppnClfzEaKuk=;
        b=NqbAP8C9RkXB5LoSxo7t04VSoai1sCOAgBNE4bIF9cq+8tegzUnC+2uA9MPik2ujDm
         /BxVCCrFFc+OOtpV5Q5mEAZpY89xBDewXypTOpLgqUsUg9wPlcn+DLjKXdIgiKQhFbMw
         SlOdsNSPe6HhO+jng7Oj6c4dmqKurOwNwA0yH/lZqET+nSFu/vPlkoM//02H3c/1pBPz
         GUjhdXQvOEa+OHgOEIRxTxO81q8QGvlOadnmQIN8xNDeacBTYvZDqUVgT2fRPCCDDLQT
         dYAvl0Wt+tsu6h76XMv7B5h5d+Bavb8iGX/YKWtnheBdzx6ijetzD0yFPGYAK9ZWIR2Q
         0teQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785140395; x=1785745195;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3ADtoclqK+MoHDwfgYPV0XT59G0S5UqppnClfzEaKuk=;
        b=pXOYOuFWUlQX7k1v8sV5HV6XEaBhMsukt3H6xKE0tNAqG1tCx59fuD9thUaP6zyeGA
         z9iM4o6xIeYhpwrmGAoWFPb5Kxsfy/4A/0HuENXq8TXc+q3fLw32cIbwNbCeErX/UGQt
         vxzczvJgc2DHd+WGJmuV417uf0az8XeyMVAdj0gBYBSSKy37qWxlYKutgK1b10vmdbpd
         bV/mRG+ed0a9kW7bIiRYa9wX9C2I08D2CkfLPzB6C6JbeVB/n+XiT4I9epExbbnNFuhQ
         sw6ee+P32OdKtTOhNUXtg4tLsKK35vG7tVHFk4VzV0lI5ID7kTWpdzmGaeQDnRT/GnF+
         foPg==
X-Forwarded-Encrypted: i=1; AHgh+RoV1pPu3dwe7M93KgnZ/pkbb7T2tp/fDwB6kbc0jgYws/3VGUPRZWhh08XRMe7TkuYoNDpVWEngNA==@kvack.org
X-Gm-Message-State: AOJu0Yw/KbgD+8mupqRid0QpyulipWCoNtj8Rtgjcq3Tj7uO6U7E7smG
	lSZV//KKRO+LWt8rtlg08RZUNumFPGhJtDEX05FhPguwTIe3ey2q9So9sfl4IX8ZvKI=
X-Gm-Gg: AR+sD11RfADOwhWWAOl46fcxYMj3lkODK0MGtZAN3VVfH4NKJ70BAd9wfdHlJYhUYrm
	yznbRF3BEJGGqJOkCarn0fHv28yK0wStX9IlrMzss4AbLs84fy3cCIBhV1oswYTpWbqfjsiOyiz
	ks7RRkQagCPVGyFglI3MEdRcmS+fSie7DVTidKNsgb1HrK90vAWdu3EIjS47PDrGw1ogE8yNPbF
	P4bo+vqyynrUvKXNEKSKPfQvx7QIAWPM2DoQHGKfpG1HCjNuwQLLVnoj9oq/L6LwZoyYkbODlay
	FQAFMBEv2EHFQKn1Dm+i1kwgKngyaviRUWkeK5sXgWSkNm9PSH3eT3lh/YnpXc48v/83NnsE2Mn
	wpJI3bqdc83hWKiJGlBVkJjhI04Cwoc4dkkdSOZOR/0mTrvyQTuCn7xgKD6Ik7vY4uOTny8lZS/
	MFCGd8Ns+wMe0+14xx/R0/fKU1r3nBXBiATGEmWKQhbMIy9TG0q/JovA1svjMiFcJvwh6P
X-Received: by 2002:a05:600c:3113:b0:495:4811:7998 with SMTP id 5b1f17b1804b1-496b57013f0mr92292875e9.17.1785140394639;
        Mon, 27 Jul 2026 01:19:54 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4866ddbsm237975535e9.7.2026.07.27.01.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 01:19:54 -0700 (PDT)
Date: Mon, 27 Jul 2026 10:19:53 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ridong <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
Message-ID: <amcUqfpjE9lnXkn_@tiehlicka>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724033435.2573323-2-ridong.chen@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1355D100002
X-Stat-Signature: am3s5zd36wxfu1qpw16fnj1ctiqxfuyb
X-Rspam-User: 
X-HE-Tag: 1785140395-770217
X-HE-Meta: U2FsdGVkX193fR3VjSzKuiDb6/LZB+kF2/kYqtbtaDZ9F8349y/ae6ug2vyB7wCBc1dVMgmpRJ5GNYSc2vuM+lupbg+6cLt7BLXDSHzsDCDma3OXDHZ+rSzfxbS61UTTZTZTIfiAvkOpMu+OpOIbQLzs6elYy1lHTQ0Tw1iDXQJpQw4dRGt0Co76TzShYD0K58WmRvZByP16MKkz/XslADa7W433D2Ii2YbPdJSckkor1xB4R2gSo2HaP4VL+NiWkWayp4a9WxSN6/rpHvDL3/DhfAJ4QtscBz0IUx23k9yHqs/ZeKPwngxnPszJdRDDtJ/oS74fjqLYiwS1tjUXGJ7psJcV0wpybVO96So7VHqxUo3YV9Nl+LdcJl/CDQM8ls553pyUfxtnD/yNWwmbDIzodRuGkum37ejpe1OSwC3gMatbTxWHxT3SZvSJ4P3TiLG94KWX13W9XVViQnrtt38liMX99uyXNwh21WwrSMDjb0s8AiJHX6MjnLEhzuEfFhiNpIKT7WaFr2/S3vVibCXNW7NIaPS5QexrCk6Y8ViEvXJxTolstsapfJxWtY37Y1HzFTYfp9c1jy05tKa/CWsVNETj/wHGbcIGYCgt9eirlfaX7W/pWYUvF6uBeNNfjfA5BeATeQa/Aer4K+tnXGpTCvgkfY8cpwygIgUY0OWFB+ULsC0VmvFG6rnIrUdwpUeiedPIYp3ggZV4evNtHqnRvaZ4Vj0XkrCQBXz6lLpmGgY2DKZxJGQMABwzuUHbIoV5YBNAFqajNQhKRLWVszajzi1XJjx0wLESYB9LEdR+z8QPNuErFKnfZnRf6wydmS1kftSCm56t20RcQ1yVdYlxL2NKp0Pvx/j2z4O7qwFqnZ5bDBjhxeHTuQQJupe5b8E/02BQjjjcDoOUyilLbY7QozSrSZMScifFWM+AVMz2+Do23MK/TKLg31mfrhJbnQCt+0JAd1sjW47ZIqF
 njnWvgeh
 ao82YAgjVAEcEP5hFjBQWJ3Mb8MeS8uE6pknrK5X9E06c023jsfXwsejUAOkGwqMdqzCR0Q/s4EhfAaGSdHe8oSvg4JI8tQekhAlG0e+NP0L6s1I/yeWy6cr/q7S/Rr4C9VfMsiuNciYeJ3f6ZKuGa/68PHuhAE6Pi83XQUcbacSYUwtQEC4aCM/tLBwH5M2qiAVTZXHu3f38Nqks5varDbVdJDv3+lbDN/2810AMhoEsK+LB44r22RNs+f41H+BvJzA+A4u7kAz874TgrLwNsXhYXaWZwOXeBhMSm8Wn7ANhmoBVBMrX2r8ofk5iPtSFXLB5DHz1ApXbbGcvWOJ9HgVQ1DkWdGt3v41EWISH+jiQANpua0JxsJQ4NHg0ESqlMudi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-07-26 11:34:32, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
> the reclaim logic is expected to reclaim anonymous pages exclusively.
> However, due to the current ordering of checks in get_scan_count(),
> file pages may still be evicted if can_reclaim_anon_pages() returns
> false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.

But if can_reclaim_anon_pages tells us that anonymous pages are not
reclaimable then it makes no sense to try that, no? What do you expect
to see? An OOM killer?

-- 
Michal Hocko
SUSE Labs

