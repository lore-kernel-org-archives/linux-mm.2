Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCFACC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 16:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430BA6B008A; Fri, 16 Oct 2026 12:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA6F6B008C; Fri, 16 Oct 2026 12:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282776B0092; Fri, 16 Oct 2026 12:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F36D46B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:44:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9EE71604C4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:44:36 +0000 (UTC)
X-FDA: 85329062952.21.B2E6F64
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 29611C0008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:44:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UwgfNm7j;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792169075;
	b=CQ/RQoH+JzVn2ONt0lCGPykWTT2tWJLbzBNgWLSfcW6mLiEDzITt13AgxhsjTlZRR06pDU
	0RgCZucuA9a0o5F6sckBDMiPUYksCTOqMaE+GydLLYyG2a+eBiY6iUXpUBWdeIPrlELNxH
	CyfrEnCCa229HOsmyhvH58RLgIEX65A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UwgfNm7j;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792169075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEVFUYbKAFDbpMze0BDiWYsy7fzEm9zY0vOk13vTjGQ=;
	b=chg+RV/QqcowLv2DLAUhIfvQSUMNv3jT+V+HvdYeqsdF7cjmPfkcCQAdjIGtds4Kw4KXuP
	+glz6jES7MDbGw8xjl9eKqCNGrHZvk+yx1gL9hOBTEy6R8ZL32ncQsAOuz/8rzXbr2iO+U
	NzMBNIi6CNTSruv10tbNgCvgNNe8nAk=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e76469b93so11141685a.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792169074; x=1792773874; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wEVFUYbKAFDbpMze0BDiWYsy7fzEm9zY0vOk13vTjGQ=;
        b=UwgfNm7jIfG2ceO4aZ3Y9r/7JvqeMtxGvUPQnAGQFwVgi1xKjzQW6sBlE4Rt74MtIY
         DGB0GkeUdg0ru2halTxezsv9o4pSer622QZr7cdMpRauMPytPGmi3SecKLJMQuPFY9+z
         Spp6PuBxiCh8Z6cnhvo8sgQfyt0BKID6juDK6eBOTMyz1mDZYmEojJS7I02nVxux0zUY
         AMs0U/Rs+/r+YGFET2ab10IyWuu7FxKm9W4Rt1uC5lkbUcICZEmiUN6KlCcqjZdL0oKW
         pkiv1DyNhkMf6nm5guiV+JevdVJwrge67XLbX0yvphufmOsbvqQynsM3C63oj6wa2OJZ
         3vYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792169074; x=1792773874;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wEVFUYbKAFDbpMze0BDiWYsy7fzEm9zY0vOk13vTjGQ=;
        b=eRwIVhnXoNQ0ShsoFdKxhFSceH1kWjlfIcTnY6XZJVWOwhdwj3qLYqrVZR6VSgbkS5
         MXdr7GIW1HW+pVYUUo8dhgwLoTBlZJygOGuFQ5ZrgT1FR4lBfa72sSUhzIEqnnFPf48u
         fhQ4XDMpwseyUdDE8L8EBdr08vdDQ6A6B4M4WpAxRmcmb4YJJLD0YRXTYWX4hL4dSN+L
         6KvAvDpkVBV8i9lADA8T3HhDI3DGLmRKu+QkR20HwLncybDthkFyrfAqYBOG2aH8ys6H
         Yk6eY1EGkp2k1+1Wh9z4dZPsFEeKD46i8t9Te+7xPGBLWxSst3W2GRtNrbDPUSJujrnR
         KXjg==
X-Gm-Message-State: AFq9FYLZkAxy/Evw8mvsboOYje1tHvNZvtqNPv1xTutz0XLDAL9nBN7x
	EW4p4u3e6kPkL6L9vRhQvh2LgL5Z3Ef87MCJnW2DWZ39zKou9tWrVrrXJaw5yQYMDoh6wVQPS7/
	0Rct2iDQ=
X-Gm-Gg: AYBFou3fuIywEy/DRulgbaJSN3+fP8eqDNWTv9tnD8Cz2t5Ck4TKpKdyiIyWFvJkzk1
	rnbaAWteEmb2+8lsoKidDiwHvfhFwCJm+2lEy8zff8afBFo7fRLbRycAdvXyFpYaS+k0wg/f/Xz
	LRb6pzsYjgKLrtcb+zKikp5qn97obKLFvvkacD2wZOqkuFbPWyCVwEebCQtt2bPc8hxgKUEF7GU
	jcCVAIAcDw6MIMjsVF6KO0n9EnM25DjFQfCw+Scgl1ZWve6y3mk3+IE9LWnig3aWkKqIWTDhFm7
	wUgdqCLyfuRMF6qQ/lHhSZlGdZcdmSoTo8OuALZNDRXDwtLqxTNfgesI4gJmPt0l1sp6fZJ8HO/
	XX0KgbJ3x36VDNqpphE4PW4/28H02eFApHWuyCtEA4XgTPs+zD716NrJz6358fRiOQ+5E57o2rT
	HIS1UCnXYQRENf5Wa+SVS1D3bln2a8uaFzOfvZd0VLuGF7Cl/c4FFPgv1sez9rl93LRt9MWoiVL
	Ra3irVOfPIsgvG4tyieLdNeH70MiKHETkWJ/0gl1yYS8bp5MR1gdR/5
X-Received: by 2002:a05:620a:269a:b0:93f:26e7:844 with SMTP id af79cd13be357-93f29d68b94mr65782485a.55.1792169074078;
        Fri, 16 Oct 2026 09:44:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcb8b69f3sm27054236d6.3.2026.10.16.09.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 09:44:33 -0700 (PDT)
Date: Fri, 16 Oct 2026 12:44:31 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com, 
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, ziy@nvidia.com, david@kernel.org, mgorman@techsingularity.net
Subject: Re: [PATCH 0/2] mm: fix two allocator races with zonelist and cpuset
 updates
Message-ID: <atJUCRRcgRkTPigw@gourry-fedora-PF4VCD3F>
References: <20261014222456.2318284-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014222456.2318284-1-gourry@gourry.net>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 29611C0008
X-Stat-Signature: wcyo9b1ki8dibngg6k6babm4faqer5i8
X-HE-Tag: 1792169074-959970
X-HE-Meta: U2FsdGVkX1+ZCV8pndKSoeCZGcwfySfa/ctgJY3a08ANrTlFtk+LqP0Jg0AzzXU1XxqUK9u1CQaUdSAwW8RR+9DIo0e+mtMVVO4cerdKQaUqhqZ+qmgQWhXooKx2qNSp4x75VQz4nIPbtB4NKCGjeW1Gz9CBAmWFGF7IknTnaVAT2sv6r+xFHrqn7rr4B3qlykdvg6QlsQ3IUq1mA8uIMUnuBcjdZ2PsSYgH8iHSmrwDRD+/PxLoMAmknpy4QlX/f+drKTrKcIOuvypAZ9XU8a++KAtQ9aQrE+D4nsY6z/5Lb/KNdP+v4ptUgCVCfV4AX92lq+Qp/E3h5D6hjhLpTfq5zQgrNhhWQxrtzSlOGopDFE0yJDouRxdmCG/6PN0PpqHsvZdpU/V4q0PKpwZIt6L0KrRZmqRuNk7I7EwNvKxLTwG9NRqax07XsacXD3RxiSUJL6Zh3lFrZ7M5tyjSCWNKP/w+T9naf9B4RSnwzAstN4RtsjGJQoulY+lfwoDQz40M2xfSFsKLAIrFoABmywIwdYQ5QvwuKMVKKj9GhpO/NR0/hpmTD8roNjPQhhMxRT56U6VfcGDo9z2xy9lVtiRljq/fxfibWz6fX3cZ/TsTLVHSVZN1vG10Swp+/xlK+gQvV7Y907bc6t575iT49dVRTSqAVBXdkMn/hwIA6S8igK/sbo5aBIjhurKoDzlXcZC/fPyVJGCLVqze1Nev4xiQPwWMYJPXf5QrNmk+AE1/zjq7pd6O+9PscW2WqBbpEWAYU4zJ/LRkQxGDi0s6iINXVIfwo/Fjqpasr+yN5gm6h7iE0l+BdSdZzJRSBrRyA5nND1lK/SIlwP2YrbPjXJ0zF7RaxMcWBTT/twgtpBV2baA9lCD9QlASYuPH+Tr8Z63m1xeID2H/Qxyg3OR1xkhUF02c8Ti+Vqy/smA0HmSNZeM22OWlMqA0o1V0lP4bByyFf8Rjvq2anhOV0oP
 dbxk/MLw
 NnBMppAH8jZalVKL7bXzf7M7WvxTatXMfBAx/3JUiqS5bY+bjOXjRuL+6zEDvzBhVqkrjIh/ZSv3yLbP583QL/IDHdzlzsqW9ytV57GHea6MlV6CA1TbarFz3fmV5h5k9TKNjiXA9aQ7dt29pnPJo5Hq3TCNBbdejBg5aVRfoQE+/wbZ+jxLWwZLCHlMv+OKxNckghsxaPhE1UUhwy+bAyU2JjjzFYk6DCpkanlfzhwY27rNdPZPdrAYrnhJIcO/OmTpY31MJFtIcOthjw6rnCSiL1xyR6Vqj9jzK72sgNQgqw6hB83fOfWGCgnSi3O7oCLohvTHkvvybBvSdnrD5bAguPAnjQu8WXdNS082G7n+3dv8d3EDd+7MkvpKF9PnfbKsrKaY+JST3hRttwjHRfvEB+6/zwpPJWvVC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 06:24:54PM -0400, Gregory Price (Meta) wrote:
> Two small fixes for lockless allocator checks that can act on an
> inconsistent view of state another CPU is updating.
> 
> Neither of these are stable-worthy.
>

I'm going to need to repackage this with some additional race fixes:
https://lore.kernel.org/linux-mm/20261015210539.3243563-1-gourry@gourry.net/
+ 2 others not posted yet.

There's some mild conflicts with the CONFIG bits that make the entire
series worth backporting for ease.

~Gregory

