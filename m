Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5750C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAAA96B00A5; Tue, 14 Jul 2026 08:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82E36B00A6; Tue, 14 Jul 2026 08:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99206B00AC; Tue, 14 Jul 2026 08:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6C56B00A5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:40:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 280D9A0315
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:40:14 +0000 (UTC)
X-FDA: 84987339948.03.DE37C27
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4148CA000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:40:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FGtpS3O1;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784032812;
	b=6Qi6sYC3j6r6aHx6+ZqLcDCW59rovUGYhiF7bYVCdqPOawAPNXCKXaa1Gg6vbEVnafAGXR
	DnHaDi6d5cvaqczQ3Du6ngYiOL4Hz7BXubDy7/8rP0tJW9zw1DXVK3Y8ct2vU9OmpA3K0/
	26461g2RmfBVqjyA7qTMCT8JLL7ZEps=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FGtpS3O1;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784032812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owHKmrLeWwtOxoZ0SVDBcimIGdjvIGLPxWpdQRnedLI=;
	b=iyBpfAQrk7JSMgNI+kqauHy4NX5km6CxCsDkV+rjiJKAVNSeC2zlHXPdR3vZhEqhNlZIcb
	6oCRWa5VZHt8upmIkWvN2xeN5Z4mDMyZYuVRU6eJRMRRgouLMTwQzkV5lHHkQA9q5wm10Q
	M40AJMwCUXEKlAN0jN8GFK8V/zzqrRM=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so3754269f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784032811; x=1784637611; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=owHKmrLeWwtOxoZ0SVDBcimIGdjvIGLPxWpdQRnedLI=;
        b=FGtpS3O1NEKGWjwwLW/l8u8X1atHe4HXD/WtCxWo7yY+eeL2bw60b6b6mmJFcankbV
         doff7wkq5h3rFnrs8GLDDjk98L+C8gYYVinPdpvvnPWGJPwTXj0QRHliV8YlBKgw92BC
         4MtVZOeVI/t+zscIKmOMiANRznTx/BJnsIgWabYwOGX8jRq4K9HhaVJ/blr5B/ZIuXh+
         NUvIgHgFW13CUv3NSuGcOuUPQDTMJLRX0L2jMEZJEgx5VlWeYb2yFPp+g0xDt9fk9BUU
         nymN1K9mbaCoK1klc7NkNhyKvSslIxDDJa6y9HRTVUzW61rpqgOOO/DoHuOxI4SRRWne
         xwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784032811; x=1784637611;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=owHKmrLeWwtOxoZ0SVDBcimIGdjvIGLPxWpdQRnedLI=;
        b=L07UA2ojEZCBlcXT8GRvdDDyVQ+aKBaW9tz0zKgm8PDQD02Bin+77svaCCCUggKsO5
         7X68jDCQw9g9j9u2XuBf6X1xZ8hNaiUK6EatqWtmnlqcr59ET+l6C1sNDWmSNWQSMgFZ
         DPNBpxz6jOt3xreQiQxNERGgqKXxFVcqvSeIZQIQoRsQnCPXmuKodSSf4oeMZFsixuo+
         70Ww6wkFzmte7fAH0f5aRfyMSMJB32fTkmD4GBmF5s2cFQA9E0OxmvfswnwyEyKedLw9
         J2+7SQNnwloHICWtg07swqF56RK/2ysrsOj2owoo5/wDAKcRFfZMmY5wtN8yq/uMU/6/
         6Lvg==
X-Forwarded-Encrypted: i=1; AHgh+Rp4uIC7VV2CDMP/Wj3I4tgYgABIS8yG4j2YG6h2vbe6YHY9/L1F2MTdozb3hUGFD8I7T12pkB4buQ==@kvack.org
X-Gm-Message-State: AOJu0YwzNYBm0nCUlls96xApODBUMIb9Hd7TnEEbHSGiC3MAvf8x/Quu
	czPMcPntvc+mqTAK4iZ/Gb2HVTkcrURKVMfgQz+OM5nAABJkz8XM8CvBJ7agx/ZZDhE=
X-Gm-Gg: AfdE7cmWF8/E8ntvS+U4TVzh3rdLBvkisbgB5Mj+UQ+zAjaAdi9NyoifM+lWp8Rwd4+
	fLrDeg6m35AqKkuOg3wMA4TBxNQ1ehkpPA3c5G6MBXERSKKcgHSJVXYAR1vm4irCv414vrIBjXh
	z0xDI2NhmsCl2XBFul7KpUO+MD6PBA+/uMmnmOM4quxezCczajltBm4OS0xsHwmtMVHuf6WN+BL
	LBy3jYlcnEUvC26r/9dPnu2x2QCmThaNIPOzsmKJjIrkY1TdHL7OeF598XPlq1M/TfTZFh7Evrd
	bKc3TzqZ9mHCNBmJ4+aAmt4oBKJ0RW/LY9O+m6AbrVR4pJCN/73Vdh2Ot4vMQtk7R8HzBlgLPiX
	T9HoROIpW535mV2UuuKpymFMz3g9DCfsWOMA/JhLdj5H8fC6MQUNHRJ5DIyHth2ExL2zgQezUoC
	fnyPWRt8VkD1WWTm/6LxNQT9gCJg==
X-Received: by 2002:a05:6000:250f:b0:46e:8226:96ba with SMTP id ffacd0b85a97d-47f2dcb517dmr16034732f8f.13.1784032810707;
        Tue, 14 Jul 2026 05:40:10 -0700 (PDT)
Received: from localhost (109-81-95-153.rct.o2.cz. [109.81.95.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4634e5c3sm7804069f8f.1.2026.07.14.05.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:40:10 -0700 (PDT)
Date: Tue, 14 Jul 2026 14:40:09 +0200
From: Michal Hocko <mhocko@suse.com>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <alYuKYnHgAaOFz-z@tiehlicka>
References: <ak5-qwmpXrYi5md6@linux.dev>
 <20260709072231.3163082-1-richardycc@google.com>
 <ak-OyACkE8lLaRRS@tiehlicka>
 <CALC_0q8O1uw18aWM8w8be60TxW02Os90AKSOLFoqubYAbLjkrA@mail.gmail.com>
 <alCQ28gBclWOFF4_@tiehlicka>
 <CALC_0q93iheF=Y36SSTg-XCoKgHrhxk88LqcQkDd-O3ymMVmxw@mail.gmail.com>
 <alYqVPEyZ2ySrdAm@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alYqVPEyZ2ySrdAm@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4148CA000E
X-Stat-Signature: gk7s7hyourb4qt59rqqq4xz1y68wxsgj
X-HE-Tag: 1784032812-307589
X-HE-Meta: U2FsdGVkX19qwyBp2/WYYUoxINGl/ZZKfZy/a6lZGNC/tOCEGHSQA1USRWfAmbBDvfdvHTyEd/gd8KHPpTp4+hseRnlkEutGjWwWKm9nMPlfo3M197XcfgLN43t9qOFEAZc9IOEWYfegwK5i5U30u+PtRSxUam0vF9RLUmjY2tEuBvX9aJ5q2uYqQLAU3zgpGuK97LyCEOrc/nH7R7mp03chbp0CDnBEInfiWpFx8x/tg6MrOXkBBW2VEg6Y2XTV8oEwiLLn/GMP8NLqdJtVI26YgpcXg6MKNiRVBQ5tP5d+cGNIPiaSIYHVU2qoKNdFZEI9wcBEe9VBBLtDeW0PuxIBr6MDLEn4SNkOozCE37QIJpsZI5QD4dTI89BmyWK1urcLBICd8/mQrJ4MBLd36kml28SOdV3xFZ6ZyjNuzMYLI16rvFNGlWxdFLLjwGTCNeA1rtYaXnlcjgYXaL5D14aDGtq7OUS8u0FM7G6feLN6/Z9aThHo9DBAd1pSrseGTmuzSPgHdgwNPk57acle6xMwi7j/emzZie3kr62cYg01infhpZXxI2bxdQeFt+1KOPZn0WCXu6snNm8i/1CmFmpawWHH+0JchPi5i9wEb7u77KOb0Uf7EOm1RPCupGfQExiDGRS9CfoNc+ls8os1SuJ8860nllkSaGfB+kfGTJP4RD+N21CwZspcdHnaNER6t+CPioh+D2JCt7pWFkh/PacPG5/0mGnL2ngJp04OZuS4NWGkZ/HgYj314zx8dSh4XoCg5IIFx0E+S98KcB8uDRoH6J7d1px3QGB28ne776eyV3RVQT+ieCqa5gJ0E5qabJKauovUGwCHHj8JJlLzzDJKRd776iitRuxljscbFPrhn6bG//Ng4EexNTk9oIcegNp2ztOS1ycFezQ/X94+Q0UXTXAwfiZbHJSn1VvFKZru9kN+H9PVsxctXhbh+F9grPPESMFRZlNuz+Eqdv/
 kT83sxb9
 g62+jYAllve7MP71yKoChfbDk4cwtnGaRJp7rFCGs4UCO95qHGbMYgo7qAz9PEaFOGZZY5bT8Of7pvjpbVBbLxViCkCRVzVWi6e6nyVpTimyHWWwA/wh41ZG7rUZpzw00iiWTVDgC6hdGupofwSSC9fDlgR8VLJ1tjgrJB7pjWdTJSdnoJBzKgdCkLqA889LB1dkLZ039yu3ziHWkzaCNlbm8cZkwgUfpOUtDu9r5Vda7XiBGhXTDi+ExWpMKNXyudwhRn3PlBI6k0JaIrHpfqaG0gc7VGiF/5EPi/sSq2hKf2uSPcQpG/dt3B41RoDpzpSQAiMDAnLKrpFlGv7/isp4O8hPTho0ahU/adHzRbzYtR3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-07-26 14:23:50, Michal Hocko wrote:
> On Tue 14-07-26 17:00:37, Richard Chang wrote:
[...]
> > On the other hand, the freezer timeout/suspend failure is a genuine
> > bug currently impacting Android devices in the field. The proposed
> > patch safely addresses this immediate issue by leveraging the
> > pre-existing -EINTR exit path in user_proactive_reclaim(). Could we
> > focus on the current patch and open a separate discussion for a more
> > ideal, long-term design regarding freezer invisibility as a follow-up?
> 
> I am not insisting both to be addressed in the same patch. But building
> more on top of a broken behavior is not healthy either.
> In the current state this should be as easy as turning signal_pending
> into fatal_signal_pending and try_to_freeze at the pro-active reclaim
> entry point which should be safe from the freezer POV.

Something like the following on top of your early break from reclaim
patch. Maybe there is a better way. Freezer has always been quite
confusing to me but this should work AFAICT.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..3795734b3a22 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7909,9 +7909,15 @@ int user_proactive_reclaim(char *buf,
 		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
 		unsigned long reclaimed;
 
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			return -EINTR;
 
+		/*
+		 * Make sure this potentially costly operation doesn't block
+		 * freezer for too long.
+		 */
+		try_to_freeze();
+
 		/*
 		 * This is the final attempt, drain percpu lru caches in the
 		 * hope of introducing more evictable pages.
-- 
Michal Hocko
SUSE Labs

