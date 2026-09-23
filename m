Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F57C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8FB6B0095; Wed, 23 Sep 2026 09:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AA36B0096; Wed, 23 Sep 2026 09:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049816B0098; Wed, 23 Sep 2026 09:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8A3E6B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:00:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BBE11607FB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:00:40 +0000 (UTC)
X-FDA: 85245036240.03.9F12E5B
Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 51C8E80005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:00:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=HBGWbvQC;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.229.12 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790168438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lvjhy1fcuALXtgW37aXB9csFPun7VRHCuWT7ETMTgM=;
	b=bZvHt6Ett4X6mSj6OFOaelojOvF8BGYdpbnIMvIZAcetD+G4I5EGr+drsUB2IOAVI3Etfl
	K9YSOa2UjjHClpeuVzL2Nn+41TTNaVGD6YULeAWMOIRuYVoQ4/FZtIkggmtBkIEJJ62TWr
	d0125G+9tSGXvpSVGLOwpCT3NLtnt1w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=HBGWbvQC;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.229.12 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790168438;
	b=lm5Y5N4jKByfrgCu7IavK5GQxpRjq07/S3PDmR/Sg3GGszNejdgPT6WYXF0/qeqBaelIoT
	ncv472lV2dPAYwE2TQKMu3wQ3kcuT9LnpZ6fond2dtGvwlbisC/zfzJ07HQf7CkkSgxXKs
	K4r6wBzpEqlekedyYFLcyEkZsR7r7Qg=
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-328664d340aso530732eec.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790168437; x=1790773237; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3lvjhy1fcuALXtgW37aXB9csFPun7VRHCuWT7ETMTgM=;
        b=HBGWbvQClazmaYMluI+Xvqq4TZXJQHaEEc5bhXsXx26y52VgtZoieh3mUxeqR67SrA
         qmKSG6WrWw/czti2hwAV6XYhRkYN1XE4+AIhGngTFxzEemh0Pw8cOHAjzGUfcWnEv8Pb
         hUTj5yPky4lRxRK5GS8w7+BckrD1KtBzwbhdJr3bgVziMNmEzXb3TclmgXe24p9CByGT
         zQqPyfEoc+YDFf4NC8nBtPJzjJrlcdAlGM3xVLfmLLYH/B0c3yIQXiV5df6pc6bNdJTD
         dVUAQAiqpVKPhd239c5CYmYZ2/Jfi6hd9dVRMvLTXcqORJqAZVF/ZJhORz3wjQvAHuQH
         OsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790168437; x=1790773237;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3lvjhy1fcuALXtgW37aXB9csFPun7VRHCuWT7ETMTgM=;
        b=EV7Jre64YWcqHFYhl+9QkNFGmS5W+GS8wsYRAfdx+eaSj4h9+ClvTbWp82ipRJqG1s
         bxh7mUjvj2rZcnG4xHJBoCRSMXX0h7pGaywx5GQ+hebtNRsPuBgsZSM4KdXyTOWktRA0
         T+l0QlBYWCfLwoed1g/V3KCz6ax2XjeK+m5wXbQ3Vvelfcpr6A81Dse2C+NW3MPR+BvL
         euJwFvi9AMMzdqPyr3+VFugWGW1vbo/Oi3W4wDp5Bp4cfOFC4+1RNukb3feUVzlgWrcg
         AQKkq/4Z+76VW5OK0c3do4Cq+ByTbfJnXtJAsCU7qBTl22TLbmQghaQd6x3hENF9o6dA
         1teg==
X-Forwarded-Encrypted: i=1; AKwUvBwr3B/rakCWsXN38omhfZqavKedcQPkPHzUYPUCVAAFG7FAUVhzz4jhVD1enCD7+9aaR7OG588pKQ==@kvack.org
X-Gm-Message-State: AFuF++nwNOG6uvkZPBXeRurlhYMtB5FYTwXh0OX/ywcJonMsa8Rgg27I
	x7wHwXCakBLnlffKcUwKfTIY+WkZYCXvb5eLzh5WjAQoiHdlqcKoLs+21tGsGWEdrYg=
X-Gm-Gg: AYBFou13tBpq+1nCtldi35wVy7fcsqZgAj97fJyfjOQ9+TfHoGEDgQ2wINwjVIOxpcy
	jNZbN3lhgk1OR8bIk7PoyL0cg6KfS8nTDu1fgtft0uEsyczDtt5kD8H6yIjqkKvNHmhp4EV7Eg9
	HSgHaVpRYliFa/ivOYDySDfpBwSZn/Yg4x50SIChsV/sk7r/cNGo2NhUwau1Xcot/Il38QFn5ZU
	rJpdOFJaQbdXAYtwpifqRcvKmZiIsOflfSgvu4tYd2QufgHVyk/UbQZUribZPzEsbF0sVSUGi7G
	O8liuVgmKVvG6IA/V4bxcKkC5Z63FL6m5p7LoBMTXDWG5+RlRg3j3JHQPF0IT3yt5Z2HtFH3IJy
	bWuWAB+4h1ntT8hEjNEaVchTwahO2e4DDnyIl9JlwDrAw8ueiKCYVZDnImDAEBAcuVgfiAM7C1z
	oo3Gqe8KGZKH7mSYKtl6TurWj1/AS+EgynsPbDKX1+Pm9V+xT+naUsf5E=
X-Received: by 2002:a05:7300:7949:b0:31e:b832:be with SMTP id 5a478bee46e88-33e8c24a34bmr2627336eec.10.1790168434062;
        Wed, 23 Sep 2026 06:00:34 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96358e2bsm6859478eec.16.2026.09.23.06.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:00:33 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9MaO-0000000DYPQ-01dr;
	Wed, 23 Sep 2026 10:00:32 -0300
Date: Wed, 23 Sep 2026 10:00:31 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260923130031.GE1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOfD6syXOgQhZYA@arm.com>
X-Stat-Signature: jnpristki3e9o6ecndyij9hfyrgosku7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51C8E80005
X-HE-Tag: 1790168438-264845
X-HE-Meta: U2FsdGVkX1/OgNMfxVyDuZN/zn5JtZKAFVV0YA/1QO5zpAIAflyoiV9jMrgjYIHcsezHo+HwzxKZyQHaIfpsvZgxiQweQ1IJjVqNv7PuYfh0+KKehYottb86Y0tisgmjMtz6lytBlDITlbNdX9hIyxuGkQTtkK/tAVNCLw0gNLtd/p46MsZLYp22Wokzv8N0dukHsRuGb8lBDqrth7mEydC/1T+8Mwj1kmIH1mwUbAI1R9yBugRo6qdNUk/7QI6797StG6dk2WzLOs0h2qb62x6F+EtKC5EK+VTGh1HxXYGyL0ZTyLt0H5+Q03ZdrZXXaJXmwaLAbAjJytFW6a/03bLQGrwcKpu/gC2AT6YjYqpqL5r1uSfRyC8m18xJuJfS3vI4zwl8oNR7zYye69e2YjLmpg6e3EVltC2h7w0olqchs3wWop6PytNOKNVOcKAHsYopbssqaK0vczZYTznyQyUg2AN2JsDxhyH4ChOU6L1Be6W2kGiudCO6kNlSRLgP//OZylvR90k6Ud7NBbtUGZhXiuY2OfGXa9a3cn1aFbrYcJxHszGF5hYDFadEUfdKComvA7wnChglQDWvTRBi5cFgaz0Rw0sYsCCPWD6dkDA8RYiXAYRMM6Ez9ed/jz8IAWIWmlMx8z+HT5xLFtfyMBtv89LYhlzj4LPt9FEGggL3t0K4FVFZRCsAZgtXILACIuvCz9iTW1k/R6s3Btmw9lZvwpwfKPxNc07fGfJm6vzkjD7ttRyUeGkq4zP4YC+/jU5I29HIUREB4Ss9Oa44Bsgrs4rJZAHuk71jpjn8boSO5eZ7ZgpbC8hWhAGoRmKbkWhazqdBxjEgAD7eWskMhBSMEGpRH5dR/PTU5nDehzspjsTalv0UHC8KBfW4gsk3+pACssjTcXeA+lDjNoFsDMtja1MnBAOgoCFNpdsPyUnD1I6lYT6x+wCsO0i7YuFBwgmzO790d5a2IGPXVXA
 XpJdjm6N
 wLhiVIkLTugV3pjmSFEeryBXvG6/mom1Z80vgUbmepFqz0o+1Ty8aOmxED71RSXH94SOu+rmrBrg4z7NTsQjcIDARy0H3lT4dMsLanzEsb9TbCkkCWZq8RVOihSFPRjgbufVxIgZ5Y970NdlDDY3odEMCKukneoa6XOHD9VvaUAKtbs3ki3fAqqe6Md65dcpP0G8JghHnOg94BCwTNxlBuo8LnXvxs4y8qEeCZth0R4k8PD9SBtVmnB+cqfRoF7nF6KOAUwrunwekConpLWXWQzCztggNAkXvk9gqDaWnDCKnEdBZGxtrTH9G3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:42:39AM +0100, Catalin Marinas wrote:

> On pKVM, we want set_memory_decrypted() to zero the buffer
> before the host can access it (I guess currently relying on __GFP_ZERO
> allocations). Since no cryptographic encryption takes place, there's not
> much point in memset'ing again after the operation as the content was
> already zeroed.

It sounds like this a pkvm unique thing, since RMM always makes the
memory hidden, pkvm flow should do it too. Either inside its guest
set_memory_decrypted() or inside the hypervisor like RMM.

Hypervisor doing it is the right place, hypervisor always needs to
ensure guest memory is cleansed whenever the guest gives it up. Either
via a private to shared, unmap or just exiting.

> I don't think cc_make_shared() has the right information on how to
> safely and efficiently do the zeroing. That's only known to the
> set_memory_* backend. So you'd have to propagate the flag down.

+1

Jason

