Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026F5C9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A806B0092; Wed, 23 Sep 2026 11:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102996B0093; Wed, 23 Sep 2026 11:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018486B0095; Wed, 23 Sep 2026 11:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D48A86B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:21:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FCCB12028E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:21:28 +0000 (UTC)
X-FDA: 85245391056.23.6AEFFEA
Received: from mail-vs2-f41.google.com (mail-vs2-f41.google.com [74.125.227.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8CC341C000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:21:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=AFku1+3n;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.227.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790176886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIwOLjI09a3UXj303jplkjBLREygxuyiG19PHUNbQ2o=;
	b=6Kq5GzOknztOnFmD2kjwMKvTXoPzf/5Knz8mdvzx+3vx5zsYW3E5Qok32f9kA5GgfWYi01
	nslr91t4wjSDa2Gp6NIQZlRsSTb/UFlrrBGszgXj8GS1MuV92S4Kn8JoKy8FslYVsmFx6J
	BxW6H1QRQMsMldIMIdXYtwA3Ob2H1UI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=AFku1+3n;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.227.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790176886;
	b=KX99iWRaWdAt8FBxect7JcUqjAPeMuaGr9AJ7P1EF5M7ADLMdtNTzzBhJ14iVXQiycR4lv
	MhnFRHGexGjuZNd5llbh0624nsLVGDJzmuE1EAQoxKresKXbg+AUjqFftNtQl3BpfWOY2+
	B2aoBydsD0I6yrBOSC4nR0AogTTy3Ug=
Received: by mail-vs2-f41.google.com with SMTP id 71dfb90a1353d-5c67e5292faso501350e0c.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790176885; x=1790781685; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SIwOLjI09a3UXj303jplkjBLREygxuyiG19PHUNbQ2o=;
        b=AFku1+3nRk94PTy9tG2itIIkhYM8asrd50+6XX3Xoss9jijA+B/aAUgNZ3EV7J9j39
         Sa4TKdmMMT+On9zuJJna50bFEUNDhTaTQy4fAIDaaABBSdlqRYPMhF+bHCx+SwTnUXqn
         oNAbU5sBdlfOvqYZULO3T3WnQA+uiVGMnJjFVp+LSwFTBD8UgChbGGg+cHND4QFMtuAn
         dbosLSNOnVpBxPZvJMsRdva/EKM/YcNis/Kz03maMOUDwQrXXPgltANFLZ0oQCbJM/o8
         tTcyfeeSIuwY4UgK1uU1CRMkF86mSs1atgrXogz09am7OZSDiJi2kp3dJfOyFnzt0zeY
         KsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790176885; x=1790781685;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SIwOLjI09a3UXj303jplkjBLREygxuyiG19PHUNbQ2o=;
        b=jo7SR4y9hU2o13DMJP5uQZFAnCoqx5sC1oAALuS6BqGB9LbzUj1igaQGfhr5TOWsTQ
         ErR0ZcahyPv9PHkZWGKnLY/aqVAr5y4/OV623FWIpKzMWDvGPjI64KxBn1rvfuuA9O2Z
         6jUJub0favc0S6Zhwk47aH5x9Wl3T0eMpcEkA474DeUEeeYzcp1pztdBdmLBfH7rO1NK
         eN4n+BC9AH5Pb9prKeyCzLxGg1wOZFzrTUfYsAbA/wjmPZro4/NzoDFaRM5FHZ+70C0E
         2w9o1nUaA3x+P/CjMwxy0sRGGsFufcYHYYicnxZfpe1c8ozx0kRr94DWO3yx+IHWu2jH
         BxRg==
X-Forwarded-Encrypted: i=1; AKwUvBxNOf7OFWCZ87jpy/wszGPrvs0dJHOdBfvUySTgO+ItqhqjA+dXUskNRZao9wLvAXecG2X69JNAQg==@kvack.org
X-Gm-Message-State: AFuF++k9hziqn/s0KDjMK3Lx7KY2lavnaOH08Kn35LkmD6jPo1Oa/3aR
	cTSkc/C/E7nvntYZfXOhjDJEfljgbGvJKUfsMixqjBYrWNMa8JiFGxTx9xvMCN9Qa/0=
X-Gm-Gg: AYBFou0tczIY2gPCLx/KyiWsb28q3EEDEL3933cKGqCvVO+HjdJU8wUWtzFkLkI2b0X
	ECkYTa3U4Sxm8+NN+11BUaBPg6mPP/jDEDm4n63sda2TBezfvzbB4Xr5hGh6Ld79tjOUd9580CL
	vIUuSkZDV4kmk11gio/Wk7EVzLay3/GG24X8JJ8fUYf4Cg1kLkvfNcsaqO5oBbkAB0lfoMA9dzq
	bnj23RFMeR3dt6SU6tTHpPw1+n+2Kx0oMpjJfmMa+Xpqnt1BO9udud9BNe+F4Wx2prxlfU9kgq/
	0ON36Ujomo0jiSrlyijnB2wF0WVkTblPqzczYVN17/dH0Y9BpC8rtljRGhsmFJRjRga31ZncPqO
	tlJ3ul0RFFqMv+zcBjbbF6c3g+lp6SP2M44LBFyFLF6iTJAJXrPaCvBqCAS+BKkSWoIxqK/RCLJ
	BZVMISKdr85IyzdXo0q8loihf4fpVdaVr0f6LuTBBAlHux
X-Received: by 2002:a05:6122:4896:b0:5c9:a60d:22cc with SMTP id 71dfb90a1353d-5c9f16b9729mr3999503e0c.21.1790176885467;
        Wed, 23 Sep 2026 08:21:25 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c277636e4sm181224485a.41.2026.09.23.08.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:21:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9Omi-0000000DrJM-1RIj;
	Wed, 23 Sep 2026 12:21:24 -0300
Date: Wed, 23 Sep 2026 12:21:24 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, christian.koenig@amd.com,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260923152124.GG1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org>
 <arOspFxWZ1DjgcAr@arm.com>
 <20260923130611.GF1540250@ziepe.ca>
 <yq5atsng10b2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5atsng10b2.fsf@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CC341C000A
X-Rspam-User: 
X-Stat-Signature: 1ygzeweygyrdg7deg4crs5am85wen8eg
X-HE-Tag: 1790176886-712720
X-HE-Meta: U2FsdGVkX18uHam4w8KIOj3CIsCnm5/BBRkGwctnTSkDtPbC/RYeaGEr9CSnlDcazyCV5uAiYGiReM6NrNDx3NadI2nqSK8hQnzRognNX5l+MZpkc6pZtFrkUfNv3HgBzavXx7W/VyS/eojoeL+OYmfOQsAhoRv1c6x4FrKSgQZxWgTTwgZSOpuWlcAIKz8MVSJRdapruLbxmkl+3SgHhNLlxdNdNax98UzoOsKh3rQ6kYIaT2hN2KpITO2KGIWoAtZzRJmoNEaUqzu4WMVPmbfDn1+esLvZY3F98FbiaQpDcStY7upYfYRaA0mG1ueEM7l1jl2wLrt1UQEVbSVhhkDgaCmP/fPfgqDYkHBVHMgJugkGct9uccSwmjA0s+JoWv078NUvKGHD9HOF6NbPPXttdPfrGCHoF50X/K8xHrPobsK0+cTSBCC83gIMCiJVLFF79oWd90Yj28HcknYfaWBF8nmv04eV3QJ7r3/k8ZNf/8y/g3AgZoFJckE9Z8sqT70lyg0dSy/zUPweuRHtxumqmOSQpjQD7qNeB95ee4LwV3wp4yb4qDDt5yUkHcGyfVy/mPR26vX4cJrcGE75UMAWMDSu0gsgQTC7bdZgsAw/kmOEAHsXBXy/SW3vbgKzJTZv61lqqgyLvnL7EmK+ZMhyXK7sTjA6b9sfjwLerNNCcgVqSCAur6AY0hCJlE2evRyKky3mDUYEE+wCiRtaxaQixWndjmtAHNkDMFQs1iDWsYQw+2skXIylmLUxpR6JANva761c86YPap1OmfEyF+RgagepAuNH2fdeAxZaPThyMYtIyoTeKjguDWuZnQ4zlJE1PgeOQBZMS9ojake84K//K+rRxPTGEoFItteInO6O3cCfmF4v5bzjpIw2WUXG3gFh5ISKQ2SLm1/Qq2aY8WanRuppkG+ZMUSSLIulF8d/dV5lP4tDO2z4oqEOodXvn03GjEN1Xqvu2Py0cPw
 SfON1Sjv
 fThj1zYPmGI1x67ZZnsX0MktE3BSSxTzYkhpvMQEg+xJbz6XguqRGKkgjEvLvH5Y+Oz3UzlP9VxUu9Kr8wCm8RmNjgcGDi99h6opd4nPQGs8Y+2Zf1XQo8pw9LtS6eUGhA8zrlJjfH4TfexzkKuxdDE9a81MrHHVbxWLtswu7+eul7BimJpHIhyHPbRlLHmqJFKbPDmZqp48ZKOJLhahvuCZaX4QVyymowxglcWmy7ctUkWa8+i8GxcbM9EJtqzZrSP76BowEFqRLwejFIlwA+7/Dsse89zhrsD5P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 08:28:57PM +0530, Aneesh Kumar K.V wrote:

> I'm also considering requiring the address passed to cc_make_shared() to
> be in the linear map. This is currently required by both TDX and CCA,
> while AMD SNP appears to support vmalloc addresses. The only user of
> that vmalloc support is Hyper-V VMBus GPADL setup
> (vmbus_establish_gpadl()). How should the generic CoCo shared-memory
> allocator handle this?

vmbus_establish_gpadl() is the the same wrong abstraction as the arch
code. Get rid of it and use vmbus_establish_gpadl_caller_decrypted():

		pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);
		if (!pdata->recv_buf) {
			ret = -ENOMEM;
			goto fail_free_ring;
		}

		ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
					    RECV_BUFFER_SIZE, &pdata->recv_gpadl);


So you made an allocator that returns folios, now you just need to
use that allocator to implement a kvzalloc wrapper. ARM can call vmap
on decrypted memory with pgprot_decrypted(), right?

Or maybe this can use vmbus_alloc_buffer(), it already does it.

Jason

