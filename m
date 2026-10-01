Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0584ACA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 14:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFB76B008C; Thu,  1 Oct 2026 10:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70B26B0092; Thu,  1 Oct 2026 10:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960B56B0093; Thu,  1 Oct 2026 10:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8316B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:17:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94C7512045F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:17:49 +0000 (UTC)
X-FDA: 85274261058.29.46DE27A
Received: from mail-dl2-f33.google.com (mail-dl2-f33.google.com [74.125.229.161])
	by imf05.hostedemail.com (Postfix) with ESMTP id AC4CC100002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:17:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=cvjRgWYV;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.229.161 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790864267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDMyZjpmBuMrFbLISKqTNyCUa2kXcFY6ppx5n8yKikE=;
	b=S50YpS4mxzUBzw10t7O5SqYXz25MfiTwK2U7IXuphmMMr4EA+KrmvVSDhWCguvAM3wnFv8
	mbnWYgICXQU1ci5qrcxDeA8e0xAUe0T/uMK2Sk43wMZPfPvMo4INI+qizFMNbJZm2XfUVH
	7ClhUlWPEEgrQoxJqtzaiimptXdLjxI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790864267;
	b=KoteFpt+bhpiSlX4zKAQQ1xwLQpgupgm+xR0cxUv51/1qSO7o0BRzyXU5Lspl2u3b129CO
	4zIpsQGnyKqpIa+r38Q7O1UTF5p9L9XEqnUC5HT4s5VZeN8HQiZ9ef7/Vy+zUnoKigsjgF
	zatzznI0cV8q6NhDbO9BrdDsaTpHSfE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=cvjRgWYV;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.229.161 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-dl2-f33.google.com with SMTP id a92af1059eb24-1438e88300cso6808088c88.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 07:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790864266; x=1791469066; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xDMyZjpmBuMrFbLISKqTNyCUa2kXcFY6ppx5n8yKikE=;
        b=cvjRgWYV2Z8Yo7FXv8asLpDGlu/3Tk2Bbo1vLNjl8Vb4qciWNbql7VOrD+llwB17Vb
         bus4ZWzlODoG0K26XOfHajDTS1hZ8xGDOj9LjcVXbgQHuXmCY4sGsnB6tecxAygXnl3v
         z5qL7B2lLItsvpKEuIjJg5Mq1pU1g5TZQcGeGqwQkB4a6wI86XElMoRidUSHhJ6fOTHr
         7dWRVkBB32dz8yUYwH8/5oSNRpzzs3nfsKPG158SMNhw1KRt4bnZSGFOhjn6xfYIn2NE
         yyJUF06zfwSDiXUgH/ZGR0YA1SPbaElaHUCHod+Lv0DpTWYR0U9uaKK5+hBjg5cgqivk
         JBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864266; x=1791469066;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xDMyZjpmBuMrFbLISKqTNyCUa2kXcFY6ppx5n8yKikE=;
        b=dF+CC2086F9sHAO2wb9Eu9hI1vKXx2oTP/IH4cE72hNHDYRYI/EjuQ1NP4vDrRkxu3
         geXL3XB2Hd/oQgNR4XGAIKfrhnsVs2/HnlrIV14lFnFE/Mv7kGaaBa1jkNzUpuzMosgH
         OQY6LKsaAb7kcU3lrFrzd+b4cgdDogQJnBXAiuNF7d1UmjxmtpRfR3SjpmEn8ei6CGbZ
         VWdjCPL8+yA2g1xbOWt2XaU9ESNHJjbjKVmwgnsbUZM053UDxNEiO/tnwibbxkb5HxO0
         H3ak/Uqftz3gFOX7vM8RjvCrFm/WgNyKncnNkEPivTzb/R/bvoXKXzqZWQ9YqI6i+I3O
         GQTg==
X-Forwarded-Encrypted: i=1; AKwUvByWi+s/+SiQuIedQsRq3mVyJ0MpUw9nHD4ze0mT9pqtPJTvRgoPGeGKn6ByTYzV8LwuKFe7OlhUhw==@kvack.org
X-Gm-Message-State: AFuF++mYWxaruPqw6bsd/9nTgwp+1s3NMnsKiVRDj1JMTqiv7fnBODdI
	ps9iQ21Pj6avTbbWOIw6DgBXB6ZnqoOVvgTtdixm484+C4MUDlVgB/N0HJU/LWlTn/A=
X-Gm-Gg: AYBFou0PQ3HRpyL9tim2DZDYNN4pSzfLvd37q2bTlk3aBi6dzA4Dd3g0k2yd3wqzLZY
	AJ2p6541jnVZHTDExqZPEw6XzpMRZAnH6xPXCpBGXALYmSKmRQmbuqaAKTbEYuzQI8rnGdzWvL0
	W5ncCI2VNlj3DOySmyFi+sSfiim6wXC2I7StHnlWcb3c2ekzZIN/KaF1Nm/yo7IXjO3/sMh9TVP
	yJgnEOwCRo5Xo5hybaEYsSmlxw8sGgcW/QdvQoYOH7Mkd6VbXM4VMdnjJ9f4dKqdRcS8h3g3FOX
	7dgpP2D6Fcwjo0GPVK+Mu2jvO+KqGAeVh4ReMY3a04AX5uQGJ6ZViw/GfX0hqD3fJfLBG7yKYAk
	pHQKq48Gp19/C+XzPD9rIkXcjIJOt6KzOp3Yw25KxLQC8BUoT5UmCe1giPHXQQJl/v0lkBSbhqa
	Ah6gaGGV2gRYiuL3rLGF/AtP3f6OFIFcKk1DwNNCQ83hoM5BGLUhvPFYA=
X-Received: by 2002:a05:7022:ed02:b0:147:5149:d12d with SMTP id a92af1059eb24-14d33f39e14mr4209784c88.18.1790864264892;
        Thu, 01 Oct 2026 07:17:44 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14df3ed1adcsm6451579c88.10.2026.10.01.07.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 07:17:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xCHbT-0000000EHOj-0Nin;
	Thu, 01 Oct 2026 11:17:43 -0300
Date: Thu, 1 Oct 2026 11:17:43 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: ackerleytng@google.com, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>,
	vannapurve@google.com, erdemaktas@google.com, jxgao@google.com,
	rientjes@google.com, fvdl@google.com, jthoughton@google.com,
	tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev,
	Gregory Price <gourry@gourry.net>, yan.y.zhao@intel.com,
	michael.roth@amd.com, suzuki.poulose@arm.com,
	Christian Brauner <brauner@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, aik@amd.com,
	aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>,
	Fred Griffoul <fgriffo@amazon.co.uk>,
	Connor Williamson <connordw@amazon.com>, kernel-team@android.com,
	kernel-team@meta.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 01/17] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
Message-ID: <20261001141743.GB3019323@ziepe.ca>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
 <20260925-gmem-tmpfs-backend-v1-1-d36159822d18@google.com>
 <9292b27b8f48c515bee3246cf3b3a60762302186.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9292b27b8f48c515bee3246cf3b3a60762302186.camel@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AC4CC100002
X-Stat-Signature: m7y1d53wm6itrwfqxxfpn7bckfre73yy
X-HE-Tag: 1790864267-431228
X-HE-Meta: U2FsdGVkX1/Aw7MBWKhSSZg9YaaL3xvBDkkjjvG2ZdRFQWNEgrGxn2bYJ7TPy78cGC9BC2uHlW9Kkn1ji4d7Rm/zy0bYKDvr5UDlMPEuML+3xMURSJnnI0CBueJKQovyHrw9zOaa9jTNluKjrdGDW5yrngTRucsuc/KDqZKUyqWkYoli3Yuk0gIhDW2pFR3PRCVGcKpluLuZkkFrliry8ccimYix33AxEJQ83eR9gh83maC0y586ODUBbIUx2pqIg5DIkRAS37BM9Qlk1PUrLCnXbfBm2R4AswGbN3PfX/YyeZvfi51kN0C013vfaJHBTOkE0XjNAiCwIgsCAlE5h0XLkic2oOf8/uoWr/WRfzNaB8noahy7mvaPadqPOFcxGRtOFrdroX0me7C9s6zMK2z3bx2zp8fUAvWXcK6m0DrreG8lk/E3P+0MSscksELYNjWWUzUBYontJHVFBRPdFWr3BuPiU9zlIgD7/bgh9CVPXiYmn/lUc2ArD9Hoi281kwayNT7Zy1bX3D/R3+kFi36G+j8wp8YrWQx2r8xg9gw+E0/Ic5QnXCOwJVNibFS9cUpvcCXqmvTzhmYxoHxmPyMy0eDuA8uG0sXh3ZnoTQbGb+K48H120JXfoREVSHIWrv6KULFLfhf3U+m2tWe2xdyAk1mxfpDEByr/EC5+9fHmfnHZY8C9+Sglp6c/rLtwV+YHBCQ5DaaNGyh4PJdvw0jd2Rdkr2cQ7ocsOgHjE58BsYT1fXwR1LXplNgrgZTzcH7GQfAI8jNaWbuuFvrMwE6k7zxUdPfGQGp1UyJoSxdNoiEaLesS+uQV7TTf1wh8gC0nhAGjtC2WllbBFXDQmlNjElK/lYdKfkDpa8tR49DI4rwjr4qj/GccjUqkLc0zVMz4c8AKFkJIgN+MlDNaBo85yytbzPXYD+CQoFznuZLy8NYQ2yUY36ppKub+ZLo1D4nnTUzxATMLsc0R0cM
 qK2zZY87
 i+WSf7LuGmYtRfxcejxl7QUYHQjW7PtC8InyTUnlx8lZgMkf8dsv59nN6Ztq8uiOM59CQXVqlv7jJWzxbwM8HoP56f92SQqxgAw/7G66hFVSrsf+t9bCTkdcjTKfkm1yLg88QuoNOgO85/drdq7sFt53izqMdYKrOwDiDTJWgAmfCqr36t2jicccFi9s2cYCWec8ETsugpnsLzvTPPJPfXXPm9RhsZYrcqrduy871TvN30+H4sGNZvl5zfKgJqpG86/WFc2KUtTwep5GO9s7SnXdDE2qiX5Y/CXuSlX8lf5jFu9hNrbOTia64XYsESfiQL/z05927Olcs1JA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 02:07:40PM +0100, David Woodhouse wrote:
> The *consumers* of this memory provider API will include KVM/guestmemfd
> and IOMMUFD. The latter *might* be through masquerading as dmabuf, or
> IOMMUFD might treat memory providers as a first class citizen and be
> taught to consume them directly.

If we are reinventing a dmabuf improved for these use cases then lets
just use it directly.

It would be nice if it could handle MMIO and "cachable MMIO" as well.

Jason

