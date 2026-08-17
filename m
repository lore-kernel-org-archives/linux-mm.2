Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E13C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A146B00DE; Mon, 17 Aug 2026 09:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AFC6B00DF; Mon, 17 Aug 2026 09:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A212E6B00E0; Mon, 17 Aug 2026 09:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9356B00DE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:55:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 825BBA074C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:55:39 +0000 (UTC)
X-FDA: 85110909198.26.025A8F5
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9F1F12000D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:55:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b="fgZv3/A8";
	spf=pass (imf13.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.160.173 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786974937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSOG0aCeKzmBcbFK2L5HxIleTt+ydcZD8Iul4FDmFN0=;
	b=fyHQo0ChdtDNDSXj2pRk0Bn4jU+Lw8zWXFGiDj/1t4IJfZfy8N4vUM8U8I5DWH1N2Hgm7g
	9lmwKKMiXiKdi8b09pGXH2Ah9gnvOZAZHdJFbHOfmKeW48KWf9U7l1O9RWD4Uv/nQ2DHdU
	Az8SLpsJCo7BQBJ0W4DjRnmEX1khe58=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b="fgZv3/A8";
	spf=pass (imf13.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.160.173 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786974937;
	b=PmAWieNNn1u/IZCczPcjdaxr3FU91VLAbDMzRt8wpGa76wAPMv6V31CYhNHwePqOM8YIxJ
	+pB1sxffYzTs9k70Vao/rPeSJ5/0vhX5A5u02Lzt/zf+o2GEP547KATnAD43k1aLs6zf5J
	NNTFS+hN4EjWCfqy/FIrWzQdRfZBHnM=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5276d598b96so16739861cf.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1786974937; x=1787579737; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BSOG0aCeKzmBcbFK2L5HxIleTt+ydcZD8Iul4FDmFN0=;
        b=fgZv3/A8ZZn/Cf+HNQYcqa+uvAAKNem3G1pP7End4UV489qYQVfaMXHo7DHmN9DSmZ
         okq8bwaTpG13KeKm93+oltCCt8/U85sOHRMbCTz33htnGH9gfmdijd/Hup/Huw4MyHLQ
         00I0sc5O3hSDd9WBNOe8Ne50wP8mRkhf0tBsEj4GfYu4ya2SGYh9q7FsqKKPJL5bV/FR
         A1nZl4h8czPPiy2sqNnbCYzqb5P1DPgflz8Z6dokaHuLFWHkmYAlnpFCMxgKtQy5+129
         ALdKlijHDKf9mHXLokSncEgX6YpQsI1mh/rt+vlvfdqoWriuMW9RdxTLq6Q6CL+kwwox
         ph6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786974937; x=1787579737;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BSOG0aCeKzmBcbFK2L5HxIleTt+ydcZD8Iul4FDmFN0=;
        b=bZH+yZmsKUskiHvP5gzxVMR1/0xglwyD7ydqss1oYvbAgQb+G6Y8/z0a8hhJ2K9Em2
         alzVZonurdax+fKR3SpiqSfC9VXLta1gYm19P/ecAM1ItGNT3snMTLMwpZf8n9OGpS/q
         IJgYvc1nSpzE0Q0xp6CM0opq8LIt8idkCQ2mZvrW8+OIfUwPQd5tTEupJeAkYg7juceG
         +pktTgzSDknk4BIGO/aZMj0P2oOtWsk2vuWLQU/8oy8bfkQ5i2x9RMlh3I8vummVmgIi
         ehtrpgP+jK0DxOBGYehQv/BQr/AvKnUiCDQBTrzka36l+fWp55tl/BSOSxCcSj7E0JKw
         zOwQ==
X-Forwarded-Encrypted: i=1; AHgh+RosM4/8uV8XWVcSb971h8S2f9UUN97Kft5ucUqRbH45w1pqzUwm/lEzTxJvw8Fpdl5EfC/oaZApxg==@kvack.org
X-Gm-Message-State: AOJu0Yw6ZsKlQLCuURq2iOdPiNQX9cXJ9d8Nlmn3XiYAzk0gDwhLQvAy
	CRbin5S7t8K8IIS6fYh7PYLBiuUscEju6IdidJfepoQhve73FHXihP/EPxwhPL6Raw==
X-Gm-Gg: AR+sD11WYuDK4IegSn7rhTfjMEWhsoW827fnFqS0WoJQrQqzWFCIteQ3Cb07PCswk9Q
	u1lQt0KBBNPVpCVpUPE+/JFP62w+Nt0QKYqcbnJh+aFYZ74BHgPHfWLsT/x4lPCl0hNOpvqolrQ
	2GiA4SzRL7T3xCyiwGIH/kwSrQuxFa3kGmyf0ewigPnEyAi1C/O9qhf2fJ3YMC3QM7z16zjqfJd
	AIyK2+gLQW1G12jdWV8LbiwqaOmX6lFHIO6O9GmX1lfNyTBVh33eSygHL/K8nni+5eh0eQFOat/
	B3ZRvuJKBkin/WoNXkgNn23HLHH2ntQPZpv2izoUuO++4TYQxSukMwUCCYWEDpkHFQYGDT+mJen
	o0PrKa4PFVtqp2uWlAuSo+LPWYT5qWHZjiyuFQDj92rkUhPwIQyVbvSHjXvMHSjkYDK5IlqyQgL
	mR1nNh7QpW77GgWytmq4+i2asGCdMcEjeUkRPpIduNIs5e0LdzhesZsFneafwAersUJyMQJFDFP
	LwTQ94=
X-Received: by 2002:a05:622a:4c06:b0:52b:6543:d8b with SMTP id d75a77b69052e-52dbd62c0b7mr10215561cf.12.1786974936397;
        Mon, 17 Aug 2026 06:55:36 -0700 (PDT)
Received: from rowland.harvard.edu ([140.247.181.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c4583aaf2sm9701736d6.15.2026.08.17.06.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 06:55:35 -0700 (PDT)
Date: Mon, 17 Aug 2026 09:55:33 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F1F12000D
X-Stat-Signature: qd3s6tj593otcoqahn8d5iw95ukp7rir
X-Rspam-User: 
X-HE-Tag: 1786974937-1123
X-HE-Meta: U2FsdGVkX19DiZs0QpxoWKVpyinkhXgUmC2cUIwQ7UweOfq1lqnQdX0qVb9Tfhznv4QISDkfIa/6RjoW1ZqMZHpvv/6aAJDKF3FmMCYqjfMyB2rv8nDJ9RiXyVXkYg0EG/V+x2EsDV6cLfm2b6s9+S32qnczRWb9nsWczNwsZeyP6OKsjGXaablCIwxA5/4eP+kUiXwz/M2tdzB5ri+vVZkNy7PNVSzFJI1nqRjGk/xyMx0LgAYVwgUQcIh85TGO1TQYLjr8+oP3R5mBSv6D7FlX3NILB18b7chIpzogogQddQHAjHUoHSUrM+Ov6Y0TUs9iqRuS/lutu8ESihCufu3QLhOKWys7w9wyF3U2ZTtwWPt8O54XM8p5j2WxYr/WccI6xaVT1TIAxgVtUxEV8/SkTK5mjkVzFb+i30hZ5mRo/r8208TfGyYseatXQEIk10dQUWQgX1xBafx2pwmbt0R64TNrXJSmJ7LnP/Bjfq0z6ChisYO8+7etzYrb1pVBNS1+Bhx94YZV9P24RDFgIrWMBHHLnw1tgw88w7bTnebXdv4p3lapVJEV7MkBEw/FcTdxv5mb/w7hZQTq00Z3l/9qwaMBitlfUIYAU1hIZxLw68NfjYttw3SboWm8ZSowoFaiNvsoE3Cgidzso3mly5tHQpRuXn6bI/JLJtx1kGfimMoWspm0q2+8Bhlnpp/HBCC5hxoMeC8o8iDkQoykL7LwU6g12OEnsVohEhTmu8Kw7SqEpg/oUj0qGCfS2k7qd5cdn7aaPLEM6jFeDvWouCbKlzz1KCnVR84269WPh0AeEQDDv8y0uulVhiCOEEJulVDrvzgLtVCGuNTzxopIgbvVCTUbza172YDtS0O7u9Q8KIiZZTvJ4sn6/utNZvZ/aXdC0l9wwWGzp7bzcE9eqG2uNZ6p5UxtQJbC7Ng+rk7ld126CGrGa9IVyrMjYfVM0AMeM+h/hA66+WonUcz
 JIFqJIDC
 QXVE21DMcRFegHgWPRZzRF72N7Ymff3nD13lZr6MQr0TYJeMq7E2N2pYcu4uNTtV2/zV/DOjMcLQ4LllnRFH8fVXyo1nAyCbUKIq3TO4HZe4iDLnh8YbzkVTgq9Z71Y7wKz0cqWI6tj/nmWqktxahtrB4yaimwrpQl4ibAMFjveHOvcbbFeG2ydAVEGXg2R/v+7Qt6RwV+TR++uVAPcyhbqYS44utKdw3vQ5g4w8VxCs2Z1bQaExCKHGZo/QtqBDM0iIXctYRypPvqV8aBIkWVV0EdS7nBpTSr9D+au0Tkjz+fZ52i0PZEv+ac03l69n38R9AvufTfZhsUWI9hx+lNSs/dDWM3uzOe64oloxHP2RaMlBLi00AL/Oly4iWFGg+2HnB0YDFq10xo8vjBOPdPFlOhBVqBdcaKmELQOA4x4ikRKCFOZeq7gjXJZc18p9l8OaB9UO5x03bdE5RNey2PJnxEk2eCF6NyvQfwdGuuYv54XYV7uPeVDw/Ws5JQC9bIFSJk0O5nMhID3+2TnH3AQqwwcjxrZixzqofhn/jdbW/Rz5eYXO/l2Q7qfKyIeVwsxPPoOzf9FLX0mXJUTXmZ33ZyXyj13kHfoPJcl/Ia8sEupTFtRFZz7PHYeyeQlZZZQ+fBoADXCwi/LHxR9xMa9x1DCIAm2Wh68bcfei2gfQ5JTUKr8CZJYir7/Rk23QLUkFT1uixPOaue4XEXniKqB97+tIf6xWp25wm+oh9rUlvlTHBek9OADmUGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 07:42:13PM -0700, Andrew Morton wrote:
> On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
> 
> > >
> > >> > I prefer Andrew's first suggestion.  If the user asks the kernel to copy 
> > >> > too much data, just fail -- with no warning.
> > >> 
> > >> __GFP_WARN gets rid of all other warnings, even if user asks for a
> > >> reasonable size. Why use such a big hammer?
> > >
> > > Because on many systems, WARN causes the kernel to crash.  You don't 
> > > want the entire system to crash just because the user asked for more 
> > > memory than was available.
> > 
> > User asking for more memory that what is available is pretty common and
> > should not trigger a WARN or crash, unless you have panic_on_oom set.
> 
> I assume Alan is referring to panic_on_warn.

Yes.

> Heaven knows how common panic_on_warn usage is.  Gemini tells me "There
> is no exact global headcount or precise user metric for how many people
> use panic_on_warn.  However, the setting is widely enabled across a few
> billion Android devices and many cloud/server provider host kernels
> where automated failover makes a full reboot preferable to running with
> an unknown warning state".
> 
> So I do think that WARNs are more serious than we (mm developers) tend
> to assume.

I do know that Greg KH has pretty strong feelings about this issue.

> So we just shouldn't permit userspace to trivially trigger a
> page-allocation WARN.  Especially if the caller is perfectly capable of
> handling an ENOMEM allocation failure, as appears to be the case with
> usb-gadget.
> 
> (Does usb-gadget actually get used by Android?  Surely not by cloud
> providers!)
> 
> (Can this WARN be triggered by unprivileged userspace?  I didn't look,
> this matters a lot).

I don't think it can.  Regardless, even privileged userspace shouldn't 
be able to crash the whole system by doing something that ought to 
return a harmless error.

> > You can mmap a virtual address range bigger than your physical memory
> > size plus your swap space and try to fault all pages in. That would
> > cause OOM and the system should not crash.
> 
> Right.  As long as it doesn't trigger a WARN!
> 
> 
> 
> 
> Perhaps we should revisit this.
> 
> Why are we emitting a WARN if an allocation fails, given that this will
> often panic the kernel?  Should we on the core MM side dial that back
> to a pr_warn() and a helpful backtrace?

I think that would be a very good idea.  Only the caller knows whether 
an allocation failure will leave the system in an unstable state; the 
library routine shouldn't try to make this decision on its own.

Alan Stern

