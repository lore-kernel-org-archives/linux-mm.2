Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBBD0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AAEF6B0005; Fri, 10 Jul 2026 13:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B996B0088; Fri, 10 Jul 2026 13:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74BF16B008A; Fri, 10 Jul 2026 13:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 314F16B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:03:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2A82140516
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:03:02 +0000 (UTC)
X-FDA: 84973487004.11.7735452
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id E142F1C000E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:03:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F90V4c9T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783702980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJt4dduVMLAOIcmpuYMBgvu3eT4RLvOgifRZbg/Z4kQ=;
	b=sG5JZ8BP/1cN+MiK0q9uFkfClf7D43jZQ90yaKSHThsrA6j+Te7Q/UyvbCFcgArb3wkxUM
	5BwGJulppuHwFnRUiDKDogqL0meMEejulvMQjWbAB7CUm3OGYnj4h7kM9p9DhyEh/bBjz0
	M8N35WI4fzXnAN61cRtuYcjIHFzz/0A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F90V4c9T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783702980;
	b=63MQAytz2YgyblnkEwEP5aAt3Y+41ZvTyOKN9TvWEPLoPyVbK8/JVG+Fm8HbOu9DJ0kUMT
	LKs3KjmcKI2hkCJV63M63uIvnIohJ0qzelak4Fo443jzZYHX/3xMEF9LgfEJyD5r1GLOv4
	6jHTSpNP0Qh7lFq+rVTvuxRxCVi28iU=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8478fe07f0fso1239144b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783702980; x=1784307780; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eJt4dduVMLAOIcmpuYMBgvu3eT4RLvOgifRZbg/Z4kQ=;
        b=F90V4c9TvrwPWWFJYkJx3GPW4OqWV6VstJC0ksk2w6t8Mktwc7zPTUHuet7b10EDQB
         OxvirjcfuVxS9P1iR7dzyyhGRs/G3mrP0DorRnRq6PsgdwEO8uS/daHDHhH8Arlx7oqj
         mIknM6yxMFhrea/GfhBrwT4TuF6Qu78WwTKFyhNpkykseFLM2grWn7eqI1ZlY+pTrQFR
         GhC0MLhH5VvCILbVq089907p+dHG5XqyDWj1qs9joxP23uIx5O3x1VE/2iXiBSGbwnVx
         2P0wsndMAiHW5bsxglmV0e7RzFzpGqyHtq4iQhIqotPQA/8kqE/lzkiS8oZRF8rP9Guf
         PfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783702980; x=1784307780;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eJt4dduVMLAOIcmpuYMBgvu3eT4RLvOgifRZbg/Z4kQ=;
        b=qxAEprF/5NLYuNGPeCDVh3MQ9hr2EcsNtJixU3P7gq1iCApCReMoANP8rwn726Oo5Q
         6u7JOHeOhQT6KIBubD1ceYTRen1fAaQ+RacNqRFTMGYaAdh7xOQo3t3agBcHEfiCTRzl
         FlxZ4Amq3R+1+kvhOAzlrvJ7oJ8DqIzCcEQ0FsNyJcq93/Zf1igYv7Un9auYLb6pEGJe
         Wfvq6IYiGjxYHHG/3SV/bU6MyzWL999kA5DviocPtm5MLEvh7+o5S2oZlaIwcLDtYLT6
         Ul2QJKW8du0M/HPwn4jqGEi9xtu5g0xoGI6DPjrfhZ9pXtq+NJfMZFDke/QN4jGTet1X
         ToBg==
X-Forwarded-Encrypted: i=1; AHgh+RpyyoBB/IbyGxjRW7fD0iM8qG2GpmtFsMVvepMta9G0p1IjV+Hix6vvCum4D6c9EkAvUlfe7kGbJw==@kvack.org
X-Gm-Message-State: AOJu0Yy8RQJfEsfQfbWTRWT/VGcfkGIi33MseHyGQB5kbyPzSLiZxjg7
	cGIaFtfHr6LM2/n21dVCmUnlQNwBvAYnMkO86wNoc4wmfr8QxL9EU8ze
X-Gm-Gg: AfdE7cnLoJwu9BjBUmqYZuU2mW6V9CQVmkcBj7yQJrc13Mk6BsXEQ+AKDxC9/u/OD6J
	kJi0q4BO7lbmQEV3TlrzMOF1AUd5tVDDcp3xJFB+h5bMknMDsmjcsKyvjFJKoUXGx1Q1tFZg6DN
	KfiYHb3eDIONkc3AldvWLNGcZ+YDWVJfWdBjgleMqkckcUjWZLasj5kWmXWwWWXmidIhRJT9q8S
	BYKr5oKxszYn/c6pYKICTLmFYskrYBJDYTiMULd7p2u50SxpBDn3+a06gv+vu/MFOf3mVEogpbj
	c8ki1GGQQIK3ypg96Oenwk+3XebTmaAvG5MuPPQbBjpXeZFoq6VIOWAs1ghh0jin1kZXkjDrksc
	J7gAtVFuPO46F6cOSfT176+yLX+nYdHhnSIb5AJ8qkN6H4kUc4QuZpUbxCxshWJysnb4fKjI5gs
	I3xtTuLMLntcBAwc64vCis3UlTZO3G7psAmjQ4PLgmvIVpryHw2drSzz0=
X-Received: by 2002:a05:6a00:1f13:b0:848:6ba2:4139 with SMTP id d2e1a72fcca58-8486ba24522mr4844235b3a.36.1783702979579;
        Fri, 10 Jul 2026 10:02:59 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8484519580csm4394040b3a.32.2026.07.10.10.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 10:02:58 -0700 (PDT)
Date: Fri, 10 Jul 2026 10:02:55 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
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
Subject: Re: [PATCH v7 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <alElv0EKjLQXMNK8@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345362182.660027.12809852179204464964.stgit@skinsburskii>
 <20260710162749.GP118978@ziepe.ca>
 <20260710164743.GX118978@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710164743.GX118978@ziepe.ca>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E142F1C000E
X-Stat-Signature: 1x6y3esz85u195w19wxbp1ix6gs6t5yf
X-Rspam-User: 
X-HE-Tag: 1783702980-653601
X-HE-Meta: U2FsdGVkX19dWCAVQIwwRpQUvMnG6dZLUGIUOXZOYx9lvcw00pMr0VlRYh0MLF9d/3z/gcZPUfUo24Wpg9GVl8/str8AaL69m/xXUtU+AdIilsLpW1J/i3gbr59DLXpe+ISzdZ+cm48Hy5YRumFovVNdQ4D7CxQHYp/0avCS3wV+twR/VezXwV2zGbHxue4BPTJ+ItsQ88Zqf34LGFxMe7kMKW8Tuqlfo/Ol4j14UvDGS/zyJfWHw2nlKVLQPiv9ZquSafXLClLhtfbvSmA+XWgG1GubmiZBRZD11pBscUzN77w6Xiu3BHNRjhlKwokcoiFZ5JsMQNTmql+AvfNJMihq+zLGLkjKOSGcMhNAe7ZCpSfbZzT6pEXWx50OPwlWDpREjqtnIcW44bsu+4KE2ENTNEyjxFYsSS96vEGt+MnD2jBbPbl8fGrzwLeTk5K/ZKCul4lVwYykoTh/SqZGcUkYzmMLaKG55+HqOkQaPm+POKZgmnYwyqMY8tf84mwMCbMR+kLcWQ67Fb0JcJIy8DI2uyc51K/IXUYogcBPt/izuGdtpKIYYpLGhmR0zXMvaGKvw54tohAioxDHjCoOHL1zufPq55hni60MIv9XGrypo2csgvChgxhyieZhd7iapvhF7Xf0AqBSk/+N297ZU1PCvY4M5Ae2l/As6+BKHBoK/grdvtbDjIEYUjjrDvKMYd9BoTfwdgnARPe7JWpnCu0/rdZ+03g5p9x4RIiNacgtuvN/vUKRSdg4G62iVIh2xAfVnr2ohlO6hKNSlFF+rwo1Ogeq7PedCksAZFXjZWcAFVtkIbC9WbvbITeLMIOW3lRlAVKnbMoFoUOUCRFZ7bei+b4t9srcYFErSOEJoqenEPxDRpvOypniys2nMvgPOGOCHrJoFYSlSh7gdpnaLMh5z+q0Yf/rpbrDizatLZJEMmRJ3//VnhJ/4Q20V4MRk6q5eI5tEiO6XSXZ5Ey
 LMxA3W7s
 apr2vBDz6t/4IfJJGfTXO76dy2A9KjwBsAKGDC/Z7o50ZYvakIX1SRN+4a6bDUKzW0D5Reicd1w9PmLdkaNQc6RAW1pYzQeWzY+KWdoEZTh03+zUdGloZZ/1ChO7rJFf8ZkeCr+XE91+2bL4LTItQXd7jQ5v29uXC+2aCPSFsIHaCL9wZetQccNQ7Bff3clyPGf9XtSYUVrBM5kt59BUd7EBMZnsWpLkowbAkFWnsdyvCV1TEceMRa8Ne8cHOi7mv3oLdULPfSskec7SH3ZpzagnHwzq7EUy6EGtVtaZ66m/3JkVDvdHMjDrJ0r7EuMvW8VHGqG9Tr+WkZ1DgUL8xD+SK/uX8NT3HXVyQM4EkGeKa4Vw0xZms/GcTOc/cJUw4sD8XLU/1guFx9qVVrJ+JW2/2YHUC9NyITG9Sfvv44sjJbJPNT5yHzjw6Y8DR2bvd0ILNCQPc2z3lZ+s8ekxZPDtkEbFrzUy3i4v+uXM/M2ZUVMX4LBUy9mBvJ+aZHdzD8vy5sCnXhkZOi7+O31WfRymcoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 01:47:43PM -0300, Jason Gunthorpe wrote:
> On Fri, Jul 10, 2026 at 01:27:49PM -0300, Jason Gunthorpe wrote:
> > On Tue, Jul 07, 2026 at 12:47:01PM -0700, Stanislav Kinsburskii wrote:
> > 
> > > +int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
> > > +				     unsigned long timeout)
> > > +{
> > > +	struct mm_struct *mm = range->notifier->mm;
> > > +	unsigned long deadline = 0;
> > > +	int locked, ret;
> > > +
> > > +	if (timeout)
> > > +		deadline = jiffies + timeout;
> > > +
> > > +	do {
> > > +		if (fatal_signal_pending(current))
> > > +			return -EINTR;
> > > +
> > > +		if (timeout && time_after(jiffies, deadline))
> > > +			return -EBUSY;
> > 
> > I really dislike there is a timeout here, HMM is supposed to be more
> > deterministic. GUP doesn't have a timeout, what is this about?
> 
> It looks like you've moved the timeout processing related to the mmnu
> notifier sequence from the callers into this helper. I'm fine with
> that, but maybe add some comments that this timeout is helping
> implement the mmu notifiers, and we do expect that the HMM part will
> not timeout.
> 
> Though it is a little hard to see how your stated purpose of enabling
> userfaultfd is going to work, aren't you pretty much guarenteed to hit
> a timeout if the userfaultfd process is adversly scheduled? That's
> going to end up broken.
> 

The main customer for this new feature I have in mind is the MSHV driver
which backs VMs memory with HMM, requires userfaultfd support for
post-copy live migration and fast restore and it doesn't timeout.

I agree, that this current timeout value used by the other callers might
not be enough to repopulate the mappings with userfaultfd, but there
drivers would get -EFAULT for uderfaultfd-backed mappings without this
change anyway, so getting -EBUSY with the change instead doesn't look
like a significant change to the behaviour from my POV.

> So, maybe the deadline should be resetting after every handled fault?
> ie the timeout really is only about the mmu notifier and we don't
> count the time spent handling faults or walking?
> 

The timeout was inherited from existing HMM users rather than introduced
as a new HMM policy. Some GPU drivers use HMM_RANGE_DEFAULT_TIMEOUT as a
budget for the whole range population operation, including HMM retries
and subsequent driver mapping work.

Moving retry handling into the unlocked helper would otherwise hide
repeated -EBUSY returns from those callers and silently turn their
bounded operation into an unbounded one. So the timeout argument is
there to preserve existing caller semantics during conversion.

I'd say it's up to the caller to provide big enough timeout for
userfaultfd to succeed.

Thanks,
Stanislav

> Jason

