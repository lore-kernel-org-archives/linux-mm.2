Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB484C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74876B016D; Mon, 13 Jul 2026 12:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26BB6B016F; Mon, 13 Jul 2026 12:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEBE16B0170; Mon, 13 Jul 2026 12:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99D3A6B016D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:59:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C379400FE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:59:23 +0000 (UTC)
X-FDA: 84984364206.25.E9C73D1
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4AA25C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:59:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GBf2BqjP;
	spf=pass (imf22.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783961961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntUweueTN5fRqaQOoy5Hqmcgc1LaFPt81cAcvUtqRRA=;
	b=5jRkHiV9Y4ko5INAijZRMHXf6FdzTMWA9uoXY5XRRHvtuAh4yUlc4VKov8rmej8xs/Wq4+
	lS/PJfuzh24+3laXwuoDrbVKM+QZRFA/7rOskJ0V/W+pVthrRecTj3cAzB9D0Cdm6xieyF
	2av12LMCP2vZcm5MfvRvSxGcM/77VJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783961961;
	b=iER5Q0IlWw+z7QeDeYGLXj0FQrix9niR/pvMLEM4+tAZ6kEFBcQG/vCo+faYFl6mQ9rcQc
	m3bm0/tHQZvB4UUZnHqkt3MlIdigyvjWaL9wRQ4aCbI5Ql2Ju6IG138B5GRcawXtJgTMOk
	G33bpRJK1fr5Ic5XA6TLsVY+ccyzNyc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GBf2BqjP;
	spf=pass (imf22.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca88130e09aso2286266a12.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783961960; x=1784566760; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ntUweueTN5fRqaQOoy5Hqmcgc1LaFPt81cAcvUtqRRA=;
        b=GBf2BqjPsq167cJ++6S3Nf1NcQ91Lmi1TYfX/YfNTg3RjL4TMfpKTP+rXGEjt51ltt
         sQTyXlnQbl3y0e2THD0J0PNkNqOC7G5VLi4BaT37aboGnOt1ccmfis+mqyiw0d5EBd2h
         DlNP8+xh1UaT9Vc3LmT8l+dV/ZL6mEgc+pWkVEP3MUAzHumlIs4VHh/Jukh+iwy2ZqJd
         3tfPzhCuaP5wPsylAXbfcJiFUg2rTv3cz//sHPTjVHitEmFXvxi7z2CTnHj5TyGITD6A
         B07pdcMfcwJkpRUn0HHxgJlgvsnYZZvaeRUCUPdcO1AL7fCHyFLRGPV7H6rX4g3GrHB0
         EZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783961960; x=1784566760;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ntUweueTN5fRqaQOoy5Hqmcgc1LaFPt81cAcvUtqRRA=;
        b=oOYCzMT1Tut0VGlV3UPdZ3T664HWI9KXTE/bBWu75F4TRWz7PP4xq1vQ39rkIsmGWG
         Qg6xXmcEbx70cTREnPkSr+4tCHVK/VffHMVwrtVk9nm84dn2v/+Zu/TFkissNW0vSdAN
         F6cHbRYPp/MBdLThACQGaxTlK30snGZALS6DZkpxOcV9lWMW2V7ZmJ3ePsSB0Bds58M/
         bIVVrW3WKMPjWW117HL73Z3vGivq3J+I5juA/6BE6OKuBjcYV0qISifhJCT1p80/yzs0
         WKau8DC6fa9ISMPbJI3iZUh6A6A22eKh/l2jVXxd0YW78VKJOeuFYLlZRdrpU5DSNH1M
         2jCg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7qQuWtjp9iHYaGPT7toqhHsuFoknJf4UvkgpJpwGeLZS984WpDvOq7fbuhB+x9/w9nPc7YUWYpQ==@kvack.org
X-Gm-Message-State: AOJu0YwYWNQvK7GjtUpXFFIroXlrip0CwubxNLv6YrCRMMwooawjEoEw
	BrqO7YHUIQdMWyemTLoTFYFivvTLfKgIfzp9DDAat6vFilkWL8SWzqFH
X-Gm-Gg: AfdE7cn8lpZvogIQpuisQs1C4jxIIdDUUPQS3ZbJb2LR9nMfw80vWtiyehwIMVAT4mL
	2YZ98ox4XWghBSVQeZ9P4hjnZ5AluQyE+TPLkUrVcWggivo0T5FGaxZ7qQaWxnhkbT88If+uayI
	MRBizF7XIk9K2DBAdwbpZf2ulwfAVOVLyahP8DHPrOGjhwUxPhob6FVQR2OOkRGjvjFiHIA6aVk
	AnU7BcNdqAEERT+dhNwNlFi8wFlKn44UybSx2gCvQ1rmf9yR8z/GZAx3nmHQodU3/5jlGposmtd
	AIfl6YGUR4ah8pBnvszUWYHOKdmeirCxh+0GBSeUeyRcP0hps7I4PlGsP/6RZZ5fYUBeS/Ncq3d
	FsPMhy6XEAclouIMPinnVP0uAw8wA04oYR/Ilimy+fS3APwnxd8iHruIuR93bba//VkjrQ7ZZf7
	VHaZGQWvnv9QDz4X+joTX+jagLPM1or5+Glhm5NjP01Wg5lKMsq6yUwdo=
X-Received: by 2002:a05:6a20:c907:b0:3bf:a1e5:ff62 with SMTP id adf61e73a8af0-3c110cdb078mr12110955637.47.1783961960162;
        Mon, 13 Jul 2026 09:59:20 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5afbc1208sm8643053a12.9.2026.07.13.09.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 09:59:19 -0700 (PDT)
Date: Mon, 13 Jul 2026 09:59:17 -0700
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
Subject: Re: [PATCH v8 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
Message-ID: <alUZZYIPY-UkhpY4@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371881847.900500.8789369230260725500.stgit@skinsburskii>
 <20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
 <alG1k3JsoywE2CBM@skinsburskii>
 <20260710224833.9caf2a0a9906f0515e326a45@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710224833.9caf2a0a9906f0515e326a45@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4AA25C0003
X-Stat-Signature: h1n5xxoypw1jcwpt9ueg6gudmrx7caii
X-HE-Tag: 1783961961-75652
X-HE-Meta: U2FsdGVkX18xGt6Yk53YD2DmSQKcX4WEzY+TeyxsPy2SzoTQ89PRJz45Hk9QHgZ+9r6NnQ/OeVlXp/0D/LxW5kRp/ZHZ17iZZrkGyXAV17sC3Ibo7FK9dD8B3cVAahANdiporI5XUZzEVCCyd8xIYP0AFCtcGh58s+jmU6DHqIQmkOQM7OXxCH4rG9djNOngqGYdc+2JGVkjS22SGBrWffWZgIg0Jk5C6L5xV9Zg136WMaK6BHgt7k5iz5BgGB4jtIJgbLataRkFJj+j+DfaKxcv8YppCrKWoW3Fo/cLIIufLfH7Ox7R4TxXfbk3TuF59PkEbnSpTVkpkiaRZ4x66xWiexbvRCLHStL465ocQrzB+qkiR1VlBzrX6QD8hMI5UBSWiGkOPeI2MY6dnROyVMH8kIKitIWz/+KfFuD84Hu/5G0FHKSG9jKhLPtg2alo9aIZtCjUnJZ0qgTSnfJnez4xJ31tY0TNHVKF+qPLfanR2VOO9HlhFACvQK9xmgT8DafI7LSvifwel+CZkK294fPIxfAs9vr8QUdorWiHzNZBQzfJez4aZMykE/17mpKOuLflea8O7IozgxdpYbAmDSZSQZVs9q4ZXA+okcpjZHY21SizrWAtR/ZFregJ6O44YBzZX0yjOyDBiekPQdIM2Z2E46bvvY8Gfbw/crtu6OjbhCLvJ0z5/GLJ2jUfBQ7jHsTlLmeJ4WJnAXnYlv1GaNTNWFSVQbl4QDg+44t0MmzyBCtlxnfaLCWsKF0qNdehyFl0HSTvFtO6Mol9qJKyt6BhFqQVINBqDFO7MK5JxpHUi7SJWuy+ykoU1QfqgJwi2DWzGsYbWtMSwC9kyg6pYR0r2/Z7HLActWoFPKV5Jw7QeQfUMq0dOcdDtWFbVA7vsYnLz41ErZYMNLIrh3gez1b1/geupDr31Ikd7UBoNVtsxpuJV6TcMwq1GT5SnXh2hOKGLUI0wtagHQNv3Sy
 CAZamJYL
 LDulz0ZaPfk/nMC+KMts/xfpoVP54UwBj36erKnv8+wLTlFWu5V7sJmSzTGiuJTpRs1KG7LsgCRwS5kZck1XliLHxnYpQlcsA+Vn6xsXtxo0fBZ9g4OQiyzvzebOWJzYUfXNHO724WxQOnNk1w0gPjc73lVvRGJ/49K6fpiuTlSdH38Bm419rgwqVUNDlT8ulx7thqGjgJ4U0kCWisAL+wUPQm6JacKVudCiIb2DzFlFacboezf/OFx5UyEj5n7MG8KoKysR9eKd4LHffbzI4K4PMIbatRKTb0ytCHGDgV46aZ+NA8/DZnkP1UwEjB4SHCrGu0vlZh7Y5p2hHziycsOl/4KBFv5MYPTSsRZdEplib+TRcvkGXqBYPn5eg4Y8lLe0TYCcuk8uCHCkD5SKYZH5vsygR+7Zfzzgyf/39KoUXZC/2audvQt3t0yejX6ut24pbulzaOojyax2ksxHVHhFURd1/n3S7f6C/UQQg8w5bPfrGEcopdJCEGqcoPNEeUVzm1slGDP2pgQEkNWy8NAKbIEVVoir2B8+VtmzKZ0LZeTFXKo4JfxjQ/HdY3Is6+2wQRAfvrKnVGwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 10:48:33PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 20:16:35 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > On Fri, Jul 10, 2026 at 03:12:22PM -0700, Andrew Morton wrote:
> > > On Fri, 10 Jul 2026 14:26:58 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > > 
> > > > @@ -683,15 +683,11 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
> > > >  			goto out;
> > > >  		}
> > > >  
> > > > -		range.notifier_seq = mmu_interval_read_begin(range.notifier);
> > > > -		mmap_read_lock(mm);
> > > > -		ret = hmm_range_fault(&range);
> > > > -		mmap_read_unlock(mm);
> > > > -		if (ret) {
> > > > -			if (ret == -EBUSY)
> > > > -				continue;
> > > > +		ret = hmm_range_fault_unlocked_timeout(&range,
> > > > +						       max(timeout - jiffies,
> > > > +							   1L));
> > > 
> > > "1UL" here?  I'd have expected min() to warn, as it likes to do.
> > 
> > I'm not sure... The "timeout - jiffies" can become negative.
> > Won't 1UL convert both of them to "UL" and thus make the comparison
> > overflow?
> 
> `timeout' and `jiffies' are both unsigned long.

Yeah, I’m sorry for the sloppy wording.

What I meant was: will "max(timeout - jiffies, 1UL)" correctly handle
the case where jiffies < timeout?

Thanks,
Stanislav

