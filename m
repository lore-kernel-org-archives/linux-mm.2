Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC49C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2F36B008A; Tue,  8 Sep 2026 06:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C086B0093; Tue,  8 Sep 2026 06:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104F46B0095; Tue,  8 Sep 2026 06:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D40A66B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:37:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45E31804B8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:37:06 +0000 (UTC)
X-FDA: 85190242452.12.C3E10FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 93A3E20002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:37:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WqFCWd6g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788863824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lj3IWUxPnXN/+hYVc8SCzN2+G2+iAtVn13tHqCLXkXE=;
	b=32CJH/MxJO7eK30gLA9pIp4RsKagjjI7ciI5aDEygSXYi0Tg/xJ6IE+SgVydt6YfFgPVwN
	Dcv391X334WzOiobsbVag6ccwmxn3gh+LTV9NjdQp72bspC/zkaJKv60qo3m4kE8DTKw6U
	5GEC3ZmXgxHqmzp9eJ/4/hwCVgerBIE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WqFCWd6g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788863824;
	b=pij23GMFanG4jtQAT0OW6eOoY5qtzhUZYFVlPA2zHErPCOG9UFSXCwWPs9J9NlPWAmH5Jt
	eQRXfRrHRZSuRis61P0d1dxxM+rDvKfaEIGAsTb9ExEZK45v3KAhZbJwinbiywcJxPDjI0
	5Sb0HEzkQsJ8PdglEfZErZD+kCRhJ/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B875040541;
	Tue,  8 Sep 2026 10:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE14E1F00A3A;
	Tue,  8 Sep 2026 10:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863823;
	bh=lj3IWUxPnXN/+hYVc8SCzN2+G2+iAtVn13tHqCLXkXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WqFCWd6gGlnzIex63TA8XzjjveHfuwzIBymY304u62frWa3ap20ismfU4Ep72NdXX
	 bdJnw2lZU8YP2xrECCPXfHqw6BoMmwMQ/qaO4N8pV58onIE8KJauJwftOYfO7ZcCuf
	 pqNBaRZ+uF7XuWzXFcQ7hfhhYgDFrfFpwBGS7V3RxgWV3kDoObm21AVhUzEcV4EEGc
	 tN1PBgh+4MOqY6SA81UUUEXC5MX7USb3w6/uSwN4luRIw/wzYXxHPynL458qu0+Kbd
	 hKtxxEdulODPjo1iKdk9fJkFn8EmnXjnxII5cD25SS7Uyx7wtAoyN/UFRALhZNH7Oa
	 oPpiYtvRAxsBQ==
Date: Tue, 8 Sep 2026 11:36:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, minchan.kim@gmail.com, lwoodman@redhat.com, 
	kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, linux-mm@kvack.org, wangkefeng.wang@huawei.com, 
	sunnanyong@huawei.com
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
Message-ID: <ap_lNaMQXx241AEP@gremlin>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
 <20260905162128.46fe06ad3689af1db637a005@linux-foundation.org>
 <8ed3a018-3290-494b-8e67-bf317974d8b9@huawei.com>
 <ap6yUYw-DH3ZZ2_i@gremlin>
 <3d3a34ac-2eff-4400-ba5c-b550d3cdaad1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d3a34ac-2eff-4400-ba5c-b550d3cdaad1@huawei.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: c13hh3i1c4b9pkydoz7ny1zm77maewzr
X-Rspamd-Queue-Id: 93A3E20002
X-HE-Tag: 1788863824-744344
X-HE-Meta: U2FsdGVkX1/EzgrGfQ2kJTDg1qnkB7PJ2VJt4WTu1KBdmp/ik4AuOK6ritZYXleaYwhbeMgFAAhI3evLYgHs4C/vW4quzdUoh9mb4fSWsvDmTw3KTIViM42ti+CSM+vRxDhJQ12m1Z91QhKw6QFChElASgAKNws524VjqrjX1431AyiJJmN+p3k38DODW+kd6vmaFlZ2CicstuC0honNOoJvgQ3+d8HgQGy4oIvgRTHIbP4Wl1V2EsvAB26oh2azD4bH1/UvBdDouhPEhuo/M3GNXggrwWIbEKYUS/ohot9AHPTabH2aQ+RYYgGiJdv8yVUlCgZgDe3i7f66x6Eyk0bxkb7jE1+mmyihcVx3YyQPOxtkHMFRPtfgiojvdFGIsUkT5mvKNbxF8cqwt/5wn/ZQ2tyL39S8xdOdHq0U/z6gl0fTXS436kUHMXVHr/gTAJiYFgc4PJxBTgD0JnJ+NbX1Q6WTWA03cLPGFElrOlFCldyvhRsd9tnTd+/P7kOeinYDADFflISO5edB/gND5s34GI44yfZbTrpr5js43n45YXUZuSgMqX6tWz7DyftL6eC3mLtSwmnKLqXWpIf2y2+aZZ8IH4sNd1t+GHZ7NGkM5Chn/PePGWMU0+nPQ6Bx+EQ1K2eA3Aot8uYVyIe13cOGJv264ehawjuYJFX41aUfFTw0yulV3Q2i+XloCoWqaU2Js/goxB+A+duTnEw4EJillrVm3PSR4r8F2BfgHgj6iiwCWfjH/UTlMM7desGmTeE926KZpv2gGZBPEAds1hyPuElVjRYnbaMtbhpL9uQ8QCgPF3c2kiNUP1uRCGvR6ikh+92EKCdukZxWxBLX9QtWmV7eSOttZ10s/+VBZ64/PwRHvjYFUqmFqyEWWsMaP+jbVCvz58Ew3O8UE9zDaE80JMy7/Xr0cNjK7tJMKNT8wVZZcuIBnMP61Y5xOqLUMalfi4kDBav1x5n3oeO
 7nxX7O08
 mCHy0Ac9HYcUiiOhJkcEuHux5f/Brepfxg0kkZ4F/h/r6cs4+N8YyK9vmZ694rIjut09CRyEbfgSYuBw+Fhx0307JJ5+IShPfN82cboEYJ76b1mHY0rWTau4dhaur0Q/0mwXF8esKM1IK2Do6IK1SXRnrQmljDNUFHduUQdkSVp+rV3r0n6cvpcjaQrqpQmOsMiQIMqIH1buGBWZOrXpXGEQ2nRo26dKLiRPS2xn5QgUqla6BxSz3ylHYGg7yj51AzQ1B7y4PDHapff7PIGfFMbn0SWwbf+IWJ78uqcFw40FLDoueYrs14ujRFAF+huU6oJ6k4wQwNquQ6Qs8geULz2/GDTFWY7U2FlPbDwcHb3BE9v9BoMCjQSDWpx8BmF9KBL5t4o2oJQhl13ahpbFB+QC+e0N7k3O3I0N3XFpT54O5/W0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:08:01AM +0800, Jinjiang Tu wrote:
> 在 2026/9/7 20:47, Lorenzo Stoakes (ARM) 写道:
> > > After analyzing the vmcore, we found the anon_vma->root->rwsem.count is -1,
> > > and there is another anon_vma whose anon_vma->root->rwsem.count is 1, and
> > > the anon_vma->root->rwsem.owner shows the lock is held, but the stack of
> > > the task shows the task doesn't hold the anon_vma lock.
> > Can we have these details in the commit message on respin please? Thanks :)
>
> Will update it in v2. Thanks.

Thanks! :)

--
Cheers, Lorenzo

