Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B8B7C4450B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00796B00F3; Tue, 14 Jul 2026 16:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7E86B00F4; Tue, 14 Jul 2026 16:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9126B00F5; Tue, 14 Jul 2026 16:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 639D46B00F3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:05:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBACE40363
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:05:53 +0000 (UTC)
X-FDA: 84988462986.27.7F17930
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1DB6940005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:05:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oQOka9op;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059552;
	b=Mv3mjE7Skfylenc7hzhGG17c3vG2VkR1czAXRnzqxLqJ+Vo8AQyCE07bgX5msC7b7l82I5
	TTXk9eALqk0/P6tHHUuCBE/rCw0hVPTm0dcX/nqYDzyhgpXaOsVMFOcnoRNR8/banGGgYo
	iiucwcvZvuRd5k9zR4RIILSSA93rWz8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oQOka9op;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TZmO5aEOGXmRgWMClTIlhAZCzNX5InAxzEzEi9D4GA=;
	b=xtL10YbJyKa6fQNt1zL4mBbAznIdM7XKYZYRwri+nhweCxwPN0nEnUF8vgkg8jQi2sx17v
	uF05HXBCjvAjFLRUsFFhCxuob/8nLiZFLkoEUlqlCPZyhZ+iPwuXeAXlyyL1psrdfy+Tux
	pjpdSQ4wd7tEyykfQ1GPFjP5ieZWIes=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38759bcd877so4105142a91.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784059551; x=1784664351; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TZmO5aEOGXmRgWMClTIlhAZCzNX5InAxzEzEi9D4GA=;
        b=oQOka9opBkYR+XX6VWuZvYQvkz+rfQOweXMMogwO1MO8D1+9C0C861yubVFgNfJO+v
         pOpp6cpYNeL8T8XMmnIkCyPVOIehK/CBjJwNLbSPI9ctDQgvZvb1GCtUYXGGBQTcrhIY
         ZwGzPElqSE8xY31yqmj3sL5Kbaa++vOcym1OAVjkvDL19v19TB0MPUPFS5Z1Vd05yR1S
         LqWYnJuETFbgZntzXAUHlO5xEAC6O1UlFeOpfSuVG7NASnyxCpArrhlgqgqLqCvBRxMy
         evYJHdm6whYntsPnozZ1urvjLNi9K6HzL6Pd9gW5qk7GwiQJK5c26B7BveY/ONRoxPE/
         BJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784059551; x=1784664351;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2TZmO5aEOGXmRgWMClTIlhAZCzNX5InAxzEzEi9D4GA=;
        b=VmJrnZj5TfHhYLUo0E/iK+3GOj6Jblrv5XyBAM21hMTE/myKDG7hVwtURmmEh/Jqxd
         hDKK5NYgawQkOZXBrHfzICkZGCML/2xbC1zlP34urn6owOzimBCrc4LjSp8u5/Og4zoK
         s2z40ZxmirBqfyPH9KWdzN0HefE1k+5IPQcHqAKTFn/4sa7ZXhCUWE6srcYK1bloCTWR
         iAyXziifFHlt/xjJbkFbFv3qy/B9ghfIbskISuOqPZcp3eXKX3HAp8XjHeXhG/lXJ0Jn
         6VlLWGqF8M23oTvOlAS4GUi/MR/BsDyhdZ//CmVkPs2ar+EQdSC2OBTiTWBmSrJ2FE60
         Ksjg==
X-Forwarded-Encrypted: i=1; AHgh+RoKp7ynz5tpGSZz3st2zDe8ZQWImLrLm+igXA6XjCuePF+5hxerMC12mFFjFWha/9w9rburOawANw==@kvack.org
X-Gm-Message-State: AOJu0YwvLMVs2YvnmCq50pEC2gRzKX7la9P5TlHClqTXql9g5en5mmDJ
	bowg02nAG434XNanv+92aUfIzABb/g7K8H2rKzshfhUH3uKIQq/IOKiY
X-Gm-Gg: AfdE7cmYhG+HwleOhM3RTcdioTKWCZqT5S4/cREA7hLct0qv1qWb4QkkNmxEDrk8bSI
	zNvLDd0eKGLaz+1kjDr4qXdLbST4XwSpNa6x49rWDfSqZKxpb6WOnm7x22jz+5nzGE1Hsbr6mXF
	gcghO682S875NlHlPBrDhZGO0iuo65fQDDXA4pQkjK3+QTBP58f0ol7PPUv9KWsWYF10Te/hFpi
	0Qj2fsV04GLMXD5clT0sBiICHf/QrNtiXt6BAFon/xjnSSg9gm/Iy6NEmy4WUIeIzmYNhlHVoTk
	vEscgruE0HiZGLR/8OzK4N2WV5J42nG7q/EI9mgpADzmNY1U8ghEPIWonaX+/DKoHrtcw9pxD7q
	9fZlYnvVB8p8vsuEK/Wf9b8CY9o2taMM06WyuZG3sT8GYkCVSNqrOVAlcgfft2VIFmK1iVn0kNi
	DP3tiNo/E3ovB6YD43CVFBFy1sm5/bGqOSWjrm+6wD1eKOXH1yNchJfCk=
X-Received: by 2002:a17:90b:57e5:b0:37f:be6c:f3f2 with SMTP id 98e67ed59e1d1-38e29ff93eemr138372a91.2.1784059550783;
        Tue, 14 Jul 2026 13:05:50 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172b6cfbsm2007674a91.3.2026.07.14.13.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 13:05:50 -0700 (PDT)
Date: Tue, 14 Jul 2026 13:05:45 -0700
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
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <alaWmUEeIBeSkmO0@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
 <alG2-RSitzPWClAX@skinsburskii>
 <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
 <alVRU38lMfvmUFqJ@skinsburskii>
 <20260713154535.7656b3a630e2f6f076b4e76e@linux-foundation.org>
 <alZfTxfypj39OrCE@skinsburskii>
 <20260714105751.f45ec4c70702c222febdbf07@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260714105751.f45ec4c70702c222febdbf07@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1DB6940005
X-Stat-Signature: qg9n3p47bc1r4dx6nffwgoz5pkx16nge
X-HE-Tag: 1784059551-849399
X-HE-Meta: U2FsdGVkX18GeP2A6P6zuXpdGHsqWXDac0/Aw2fzMVub5qPI6TWq8GDqPzJxpeLU6qLE6IOZyqeNS3CPZTIyzPTHIqx5gOcQSWerLzo/UB0d1tcq2cMyCxtsanfkkM+TpXkqu4WicxGlLY7kMKopLlqiNmcLmk7ljjS1oDmRBMVU2VJtkatATfcgLId0leTByzii2xyCY6INiBoCoDGX5WvsG7EHhYuJrg9LgrVNMfX5YAafy/M+DhYEdW/M5TNjPFUCLerxAdpvVEQmDmpoCB+Bxs8BpI+VW4NpyVmdTyjl1ydgLy9qHAZjf0Us8e1K72z0YkCAlkMnuwp1u1GzpxSww23wMNbkTSnbd4VUTnVCMJ9rxOq8K+E+DN1ozobAaTMJR+2JqCdCp4aL6T5loLPWAhR5h+yWenSxNi47XgLT0+BOLm4J802yoeHqOUNIHCZzvGCXso3rN/6+LUvtMgWPNZxaH6b6EK8jeEXxYXQEo9TpTwBYHZxhLOHA/BP79I8YSE9vjJ6vTELMD/xi40nHqk2dn6ZZHRF778Ozx9G621YUn/tjlfOYidsSCDg0hmHwl34NerMnMRCoiY6Bq0NlRvkhjJdDLlqWzizWa7T6q7vSNrS0QDglZg8425jE0l6AxnRy4a0fJtJa+BhtkRvsKCnl/7SYy3E7wwDqQCpH4cn4BNU6EfFQh3Ox6NJBmSnRBsWWPhbmqw2+tc2g2DaGtSnkJWc7WZPrjKhfMskd1bYtoG6qplTg3TEPJ1usNjsVgeo8oG9a8QOvg47MeFgLiWgKZRu4zAZLkbYgePchOomwZ7SeedK9Ugh5NaVJikRwTza3w/ypW7VnC4tm0ierRRCXvucFZ8QbgpFvurs0YRRdxiAKQ9gXXrdEEWrt1mXmv2VxOVXe27HAW7p4kP2cfjbvmpnAplj6d9+NSNV5wqhrd8cRUCYLZZX72Q9+4kL9Cq6OC/1oM/sXYWf
 Q1bOJbnj
 fikcQwhG5j+jYXX1RmBo1aMdM9N0dEWArK+2cttjRSHooWANP4UhubImknLVSwV2FnyyY6ar6DcJA3TWvnFaGBFZquEC4Bk2p6QDrekonIXymRgu3qdGevj9DYzSG+A8vxYyDZGBv8lz0MtRgPcrfCUYVi16w26WdV+zrtE5meQlIggWLPt4Qi4CQdCaXvY9yDKSsEgHg5gND8+VmyQXZ3YcqIfrKL7fM+fg6mJ32QPkeIrWV7rh0KQl0OEMRJ6EJpXd7COFwAnyDfWJMYdQShI2Tosz9TMl0qgCNL+6p0XGnoYR6haxziIsTNhe6UD14ZKOmSU3mx9lhSmwf1H9O+axDxBJQWcl/8NQaTPQVvuXd6oqIf/+zy+9Fz0Phfx8HYimmfCv1T71kPpvuY232+O7pXyMy+mM0V3Eo8KI7zrWHj3rsTW+afAOL7++8q29I5ylFzXoXTvs55WUb6rOcal8YqS04BXtylzYr/FiIY+D3OGTmCmogWuWznY8hsubaKf4w+qCIl59yNZksevte29rZgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 10:57:51AM -0700, Andrew Morton wrote:
> On Tue, 14 Jul 2026 09:09:51 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > On Mon, Jul 13, 2026 at 03:45:35PM -0700, Andrew Morton wrote:
> > > On Mon, 13 Jul 2026 13:57:55 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > > 
> > > > > > I rebased this series on top of mm-new right before sending it out.
> > > > > > Should I have used a different branch?
> > > > > 
> > > > > mm-new is good - Sashiko attempts that.  But it's changing rapidly at
> > > > > this point in the development cycle.
> > > > > 
> > > > 
> > > > I’d like to send another revision addressing a few comments and also
> > > > replace the `max/max_t` check with something simpler.
> > > > 
> > > > Which branch should I base it on so that Sashiko can apply it
> > > > successfully?
> > > 
> > > mainline Linus would be safest.
> > > 
> > 
> > Looks like linux-next/master has been updated with the v8 of the series.
> 
> That's because v8 is in mm.git's mm-unstable branch.
> 
> > I have v9 with a few small fixes, but it is too late to send it out already?
> 
> It's called "unstable" for a reason!  Material in mm-unstable is still
> under review, test and the latest stages of development.  Getting
> things finalized for movement into the non-rebasing mm-stable branch,
> then into mainline.
> 
> So altering or replacing patchsets while they're in mm-unstable is
> perfectly OK and expected.
> 
> > If it's not, then what should I base it on?
> 
> Well it's a bit tricky to replace a series when it's in mm-unstable. 
> One can do a git-checkout of the commit which precedes the v8 series. 
> Or base on current Linus mainline, which usually works out.
> 
> Sending little fixup patches against what's presently in mm-unstable
> also works.  I'll queue each one immediately behind the patch which it
> alters then squash them into their parent patch before moving the series
> into mm-stable.
> 
> A third alternative is for me to drop v8 from mm-unstable, then you
> wait until that has propagated onto the servers or into linux-next,
> then base on that.  This approach is OK but I kinda unprefer it because
> there's a bit of latency and it makes it harder for me to prepare my
> "here's how v9 altered mm.git" summaries.
> 
> 
> Which would you prefer?

Well, given that Sashiko didn’t pick up my series based on mm-new, I’d
prefer to send a few follow-up patches in the hope that they will be
reviewed in the context of the original series.

Thanks,
Stanislav

