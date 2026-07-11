Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346CAC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 03:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1A96B0005; Fri, 10 Jul 2026 23:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A29B6B0088; Fri, 10 Jul 2026 23:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2C26B008A; Fri, 10 Jul 2026 23:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDFCB6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:15:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44573C3DE6
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:15:00 +0000 (UTC)
X-FDA: 84975029160.11.5EF4E45
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F5491C0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:14:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PymkJ5HA;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783739698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrd/oJTRX2Uc0zxJ+R9Qjxy6xmTV66E4ZoYglWTlGgs=;
	b=PVoQ3tat5dRfPSBlO4H/Nyd3fiIAIkixXDwzHGkGK7HM4gy7wejHAhZDISa/2qk0ReRcVC
	GlGAvnCnGEt3Lk++ip488NGBx4NIQw7Bhafmwp2PX2yS6H3iQAx3q9m4by3AY8/NC5sR5C
	My6wvrOKb85AvWvf1bKwQuCUSEAdDWw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PymkJ5HA;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783739698;
	b=bSG1yqB43p46DaGkMC9DZBUnBpFtljQcEmOYaPVUECcH/B0AWR6oWATEmLGp8G/1TcXkNg
	Ia0ceG/5uh7eRr1zWgq3FB/MAakH9xxxndL7DdQ4O69xUgqMtgfoZ/2Se338H2mKn5vKuQ
	WFLiIu6LVqoRBGhQ9prMVGhjfiBxEoQ=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso1828919a91.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783739697; x=1784344497; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xrd/oJTRX2Uc0zxJ+R9Qjxy6xmTV66E4ZoYglWTlGgs=;
        b=PymkJ5HAeDcT3v2/xAWu0mt8Qr50WFw0+01m1KUKGfb6p+3YiBykd5O21LbLFBlSx0
         u94OWvVN9Zi053vPLfvNfrP8J8c09VyPWaDMZAhrX7fYn/KjO59SlhemsX9fZrjua3uk
         6bP884MMgK9tYmbJ6S8Rwt1qwrgoXXhQYJzNuhgcDW3DAi+OcdkKUpWJeqzCQb1o14Tg
         BDbL7WhJ98X46rX1Ps09Nr2oTLZP80ruAKqIda2qIowX4ZLY5AryFJ608Pq0Whou9hvn
         WPMiFwkwNeeCYo9By3Xu6e52eNRQ1+TJP40TgP7dhxpCciw99gMFIWZT0zwaa+hZSnJQ
         4Txg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783739697; x=1784344497;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xrd/oJTRX2Uc0zxJ+R9Qjxy6xmTV66E4ZoYglWTlGgs=;
        b=ryOeZ2xNDr/6kqVygLSSkHWIkQES0ybXH6C9gBftIdjZaS3GpO54R7Izz63/zBhngu
         XiNQrzyGtEeKTRfJSvtUnJnf1HJg++PTXjFu+7r8wRIrT6RV3aNpHX0OT1vYXPJnBK+r
         yML8QAvn1jCiF01vTJrgNrWveKlbIvl33BIuJgyH94VvsdtOx9XJD7ggBu/tBfR283pF
         izBdvWqcnjaJj+UJMnhwpJNYFSy1SgVZCebO08X1wZTtPdPshR48U1unWl7/nfcFmFWs
         k4X1MJy2JHyq6n0Vxr8XGYfhp9J3ZjtjRiFZ1cPOIW1Ck44JVk0Ee0qupISEhFL/wek5
         R3fQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro8/otJUQlqaSB111Zzk/nsFbLcmdb3oGZ1QwwhyCz5vFjMeXSIwKxC02d8gCQVn5Nt8z8dk31XVg==@kvack.org
X-Gm-Message-State: AOJu0YyDIficfK2Hy/33+8UlmiMeGho1LYL6YGZvaRL7vZY6AMZm8yvk
	f6EMmlxwnDJZv9G6hm7lgOL4cCecQB5g2Ofeb5FgDJH/1SFBGH0sks0q
X-Gm-Gg: AfdE7ckCGKODdx1JVE9poB7Oq75RYQXSbRKWnfjau1j9FCx9oeMMhCXOghnHgbmMgFO
	fQkEyyE2jJGoo313Ak0o6hpFidcQxlewZjXohLmLlbrMPZIBcs8mia9eM1Q3oPFJpS+23Qekt4x
	Hf8PeRZsxJMEZ2ZtLCiX4SOgAKOn4O9JLmdlATilaHTEDAYNt64bmtMAyL2ZwVi+3SmqT+fN1cV
	UNEAMGS3i41wnvWmGriqFhhbV82A0s1EGb8KKEjvKwtyXvKqYP1/1jdsHYgXDeWlNujftwCOz99
	bKVegRBHEGW0d007DRzGXKU6Ur17k9CY/Bsl0duLXxpDEhfcys1BouXUqppPf5AOamD6H0nyU7V
	M90opyvUpIwZ8IN8XnKGIgfJORXhoNn/sMyi0aRfnB+PdtWt2kXOXbeHrAqCj7cltejZMo5y5Uv
	S0J51//bjy4MhZkM0U4f8SnWQT3TFq+y4/ut2aLUeeronSYTKrXxHOzTs=
X-Received: by 2002:a17:90b:5688:b0:381:29f2:481b with SMTP id 98e67ed59e1d1-38dc74cbe73mr1405854a91.11.1783739697430;
        Fri, 10 Jul 2026 20:14:57 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a55a47286sm3463061a91.10.2026.07.10.20.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 20:14:56 -0700 (PDT)
Date: Fri, 10 Jul 2026 20:14:47 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
Message-ID: <alG1JwgUK44dCiN4@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371881034.900500.5214601525971121683.stgit@skinsburskii>
 <20260710151216.0397a6f9ac5c7b4ccd274cc1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710151216.0397a6f9ac5c7b4ccd274cc1@linux-foundation.org>
X-Stat-Signature: dt4y6ifzetcxx8hwx9fjuhuzhuie9c75
X-Rspamd-Queue-Id: 7F5491C0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783739698-100310
X-HE-Meta: U2FsdGVkX18oGSZtyMd+fmavTf6L4bd4R0y2gChakZ816Ho9MkhtGYqeXG8nw/xb7iEe/FfPPuGmS3a6Z2bSvoW28rprKzTweI1UUXNRBUCzCvOJ9ToqFs7/Szdlr9njLecx+KDIUp5HqoG2tbIwGMR1vWDHGbd/eLEXnkyvS66uJcxLmKVsf3Oq8n12Y5fOlxBwps7BcOTU/W7/nNMswpLR4z0s3eCzpD5uCQZ6ylRTYthpCBMDnDxn8gKtwSfF04kl3ScL8g93WyDIQ7c4ef6v0AHSq7Tlo3Y5cfJ87JPcsErMKIEN+5ioVDchhn2J2vkOlUceSPgkm/yWD+iClu141JBRldqWhkbCjhGbKudtJaTi6a6GsYLguL3BY4uQ+YZ++yxit86aZhAMsIWwTfWPzLVq+l5N5wGvTFwiwGcEVy9szxHEl3g699ebtJi52nYVheauI53wrqXH7+KToGXt4ikpi6+gFQxVXGMt+LXiUR4k+UB2LZnBkiXJvBd9OhFsV/EyDBdAR7CHTVYRtU4nySHufsZunxOrTTlC0ITdUwVmRqoQgXJEuWKzMV6bTxPTnzAFa/VkKYVvgL7raUq01Pu96JVEDX2iWrBOJyEv7Rofieq17S2km3EpvVw5JSyG39OW8SO+TLSRO12Q44x52O2Zq1lg5AVrjeLkjBDGFXWS0mtj/EkTxq8/w6IrTR7sm61lDLMgugKpNWuda3bN3EepD/dGPLjgMSJbG7zGBv+0ACow2K8FpdlbdQucYXRqpE+SaHcH/13Q8lWovQS0if8ssuhKcEWyrAt+ouHKhS2C0vzEyZB50NrV+oFO1A1G34rYh/xYL0r1QLWso262pdKuGzQj0rIc3KkEgQ6fYxsKrc6JcN1HvAjZG9zxaPsiOmIEWVLuxbj0+MqvCzAxL7rXEUdzvQkop/QwLXFOJlTRlp9On3p5q32+6jAi/EM9AoPHOlAq6exZrZg
 a2suQHUu
 9jPrcZD5+YfwLq99zS/An61k+WOlho80Rr7zJg0fVnarQZBfuh5pS1cG5JMFT8EzKYv2VCqTimKmkWOmRe/8Bgr29eDn36wnQBUBo118zg2olT7zcLXw66HwKfwLAweD5Wom/bqd0plt2lBj/Ymh4qPKlbITR7bNhyBXdRQGTNVv6i+ofjL5rjPGcN0bvN+eJ5n/erfji0onS4sKRDyqQTPq9CZdgG04sAYTQU9SZx8RLA4xGEnNqmhqJJEUYDQCDclpNtQKYAVVrCk90KQwAKrNiI8kjikHjxcg6qLLI8gc4WPsca8GhYP8hKPpCT8gSx8PL1PtOqr5oNEuvu74tbdkL+gNEW4ivkLV8vw715XUUdZWdhh0KU2RFRgHA0AXkTFyL29mQ2SrGaj1tYUeyGIi4TBxo7obQj+XOji95r8ly+/2OHhc1ePWXZFzWLGM8uAdMC7Y5wQIXyNc2AGPCV0ckk2xfCf/D5DxpvOh8S4/ADah5VDMFwU8vURwjrcUI9w7Wd9io8oNWrRjds7rP3KUu0NEUCJ4Ui7h7GisQKUW6VTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:12:16PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 14:26:50 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > MSHV currently faults movable memory regions by taking mmap_read_lock()
> > around hmm_range_fault(). That prevents the fault path from handling VMAs
> > whose fault handlers need to drop mmap_lock, such as userfaultfd-backed
> > mappings.
> > 
> > Use hmm_range_fault_unlocked_timeout() instead. Passing a timeout of 0
> > preserves MSHV's existing unbounded retry behavior while letting the HMM
> > helper own mmap_lock acquisition and refresh range->notifier_seq internally
> > before walking the range. After the fault succeeds, MSHV still takes
> > mreg_mutex and checks mmu_interval_read_retry() before installing the pages
> > into the region, so the existing invalidation synchronization is preserved.
> > 
> > Fold the small fault-and-lock helper into mshv_region_range_fault(), since
> > the remaining retry path is just the standard "fault, take the driver lock,
> > check the interval notifier sequence" pattern.
> > 
> > ...
> >
> > @@ -452,13 +412,19 @@ static int mshv_region_range_fault(struct mshv_mem_region *region,
> >  	range.start = region->start_uaddr + page_offset * HV_HYP_PAGE_SIZE;
> >  	range.end = range.start + page_count * HV_HYP_PAGE_SIZE;
> >  
> > -	do {
> > -		ret = mshv_region_hmm_fault_and_lock(region, &range);
> > -	} while (ret == -EBUSY);
> > -
> > +again:
> > +	ret = hmm_range_fault_unlocked_timeout(&range, 0);
> >  	if (ret)
> >  		goto out;
> >  
> > +	mutex_lock(&region->mreg_mutex);
> > +
> > +	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
> > +		mutex_unlock(&region->mreg_mutex);
> > +		cond_resched();
> > +		goto again;
> > +	}
> > +
> 
> If the calling process has realtime scheduling policy and either a)
> we're uniprocessor or b) this process and the holder of
> interval_sub->invalidate_seq are both pinned to the same CPU then
> cond_resched() won't do anything, and this might be an infinite loop?

Yes, looks like it might.
What can be done to prevent this?

Thanks,
Stanislav


