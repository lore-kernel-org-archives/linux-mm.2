Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C24EFC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 23:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9F16B008A; Sun, 27 Sep 2026 19:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1156B008C; Sun, 27 Sep 2026 19:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B69D6B0092; Sun, 27 Sep 2026 19:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35BAD6B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:26:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25B51160898
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:26:05 +0000 (UTC)
X-FDA: 85261127490.21.3B69EF6
Received: from buffalo.tulip.relay.mailchannels.net (buffalo.tulip.relay.mailchannels.net [23.83.218.24])
	by imf31.hostedemail.com (Postfix) with ESMTP id D9D2520004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:26:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=E+D62Z35;
	dmarc=none;
	spf=softfail (imf31.hostedemail.com: 23.83.218.24 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790551563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aSMKRCkja4n/VQgEqybQKvbi5xmjbGNpO1qSHqKYOE=;
	b=OKKnZvVeF30w483Mbtm0i5pdEQtrmbKFrfQbkwbir2nkrZ3TTl/zYYOB0MV/Ejkl2qXAjf
	Fd2Q8nOucvySq4eHRhvkHXkvXTKSuOcC5kEWy03vYnfG2yOhi2lCXveh6A/y2/uPDrdjHq
	ToFvSvQ3EHPwiAS4joJwPdYXWBxO/Kk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=E+D62Z35;
	dmarc=none;
	spf=softfail (imf31.hostedemail.com: 23.83.218.24 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790551563;
	b=DOV3/KQmoSeX1ccAobjC3FCFiy4SLgaYWE3wE4sKrceOQGMujW3xwqFjb3Mjw7cyDDQqIy
	3GuLNRM9aNV2+u2NolqONjmxxC2N2OUpnPYHIYzJ0cxGOrhNALQr3RK3vGOLsROS4MaSn3
	L4r5+lOaKDRx+Ig3CCOdv7AZpgAVJ0s=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id BAD564E1538;
	Sun, 27 Sep 2026 23:26:01 +0000 (UTC)
Received: from pdx1-sub0-mail-a257.dreamhost.com (trex-green-8.trex.outbound.svc.cluster.local [100.96.22.229])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 70CF34E1345;
	Sun, 27 Sep 2026 23:25:59 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Bottle-Dime: 1c4e2ddf2127d7f1_1790551561597_4283029918
X-MC-Loop-Signature: 1790551561597:956768281
X-MC-Ingress-Time: 1790551561597
Received: from pdx1-sub0-mail-a257.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.22.229 (trex/8.0.2);
	Sun, 27 Sep 2026 23:26:01 +0000
Received: from offworld (unknown [172.58.116.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a257.dreamhost.com (Postfix) with ESMTPSA id 4htLCm1y6Zz103W;
	Sun, 27 Sep 2026 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1790551559;
	bh=2aSMKRCkja4n/VQgEqybQKvbi5xmjbGNpO1qSHqKYOE=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=E+D62Z35SRdU9cbMZcyXmBaunm2mvKP6J/oet/VsA6QZtvpQwYiEdMZMRoUyLl9Pz
	 uGITOgk2tDjNSsp9tdRkBGg4y2L7K+YFz1cXx3R0R9pMihP53UfFaKg3JZ9g/WjnXY
	 bcTgNtyFfYThp8vCi3wl7ZJVW/h4izJx6J0VkjOEFQz7dopOc4zhI+v6skKcKCaXDS
	 RyKMidAKbn/kGxoRSsNIEfysltrVy52mlJg/87pJOEKLXJbqVrGOiBRj0uIyPfsowV
	 MjgaZdMkHoRckeINWirahjclE9pC4kxzb+4eiVSZc0QEEgVNK4fFw9risHFiKtRpR7
	 77xkxd7s/yiyw==
Date: Sun, 27 Sep 2026 16:25:52 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	gourry@gourry.net, mgorman@techsingularity.net, mingo@redhat.com,
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
	rientjes@google.com, sj@kernel.org, weixugc@google.com,
	willy@infradead.org, ying.huang@linux.alibaba.com, ziy@nvidia.com,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 3/8] mm: Hot page tracking and promotion - pghot
Message-ID: <20260927232552.u6iypdeadjf4nyla@offworld>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-4-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728054356.291998-4-bharata@amd.com>
User-Agent: NeoMutt/20220429
X-Rspam-User: 
X-Stat-Signature: nrysxix7ajooaekjso4gm53jogpe7fb7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9D2520004
X-HE-Tag: 1790551562-552244
X-HE-Meta: U2FsdGVkX1+acUS6V3XK/d6p5YVR/IZJmcPd3885z14yXt1M5iEK5yaCkaFRoCyLswl+/K18DrbdPHoAvL1ckXreaqAUpQ34NyKBj6AgbPqCpXDqB7EJnIL31aN94DHnlOBPA+p4tBCNJySY9AsDiT2XIUdcUiq84QiX+nY9KSMsYut7dfzJae8mKbJPlNMe8cnvs35DOQDezRWDSRj/ru3BCca8qo6T5JEFGqBCDs0M2qALg0L7lq1l4XHKUnA+S79i62qXnjaUyqsb17qAwS5aUl0MzwhqXkBb84UQ/SFV9Yoo8pw5d6fnrZ1CSABOgC9gZNoYmiki7bosqjJoxJ2QQYUPJs/U579GoVNbMo0zgQRJwkpG8bY7L0E5s7UGkXRFv4iJIddcQUtjlfgJRhC1YR6dNb42MtSw6Xlxnhrx7nUGWJkDV6lwr/RP+E/t5CQ2+8W+tW52OCejXnwQauyQbtNOk3fQbAbxEXrg46/+ExoJrcAnKQ0R+Vw1Q2tMs2110ssBo9fCclweSVfHoUc0sVlkYSBR/LtuLsrHtUqR7WyJQ8KxyLMKWGhJtmLF4e2hxJFm7yIM+2m14ifgAFSI3YVUlzTN8ydF+ytLoJPB5XyUV0JGlhoNvxhC26hcgfE7LKbYDK3djkEGB2R6/qJQtC+03cwLMLvcYF0qflQ6e0ChST+Mgcy4UmxKOPeyBbTMBJ5l9irRCVimcCZszh22rw5DhYBh+kn2xoY6cT1xZVop6ts9NRrsF0nejlGyxmZXCyHAwRZxrrSZM0t0pQODhRaMExZEjLjahlR4vzanLBc0z+7Ukj5iDC2ifoBCgNnu+ezoh/2dcPXtR7cgxbcHive+uLf7tn1TFeEQX+aPPsheXUIL65k8HBBXyq/WVLfvCbBpHpavnjYAjHi0hVBmCdt6ruxYlJBiGXp5Rd/nhGmuWU6BRBfDyUGMailXjlzxsfNMjdfo+zhkwUT
 IVGIWnbv
 FRddHY1q46UdmWckoJQfxy2AOlwNT5bsPjT9OEqv+fVK/83GRfJKg7na77EFtFmrN2nEWSamCJJM+Vp8zUWvpwFT6s79pz1v5QonxbKjql6LNGJhrsYktqSSxsm3DIzM1axgCwMW5KyltuBNWhrkHTWvsJ0Pl5D/90hZAKVvUEVlO+ekctNSBZCmnbNz5AuCn9NvIqj3un1rcuWXFKUgMWlIk2CHIYCVEwrDPO0yUzmRSGZ0TElHoQIsls7HoCmQpfak9N6Y2FzBlqMTt+/BwMDrV0tstTBRvM0GIE7VqpeDr/O5XjR9MTR+GLiSUDfpzvrVwY1MGbt1mt5CDa9GgpE+/IlqbwTqfBgPVFIbZMqr4ZNojRswSJoIEyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026, Bharata B Rao wrote:

>+/**
>+ * pghot_record_access() - Record page accesses from lower tier memory
>+ * for the purpose of tracking page hotness and subsequent promotion.
>+ *
>+ * @pfn: PFN of the page
>+ * @nid: Unused
>+ * @src: The identifier of the sub-system that reports the access
>+ * @now: Access time in jiffies
>+ *
>+ * Updates the frequency and time of access and marks the page as
>+ * ready for migration if the frequency crosses a threshold. The pages
>+ * marked for migration are migrated by kmigrated kernel thread.
>+ *
>+ * Return: 0 on success and -EINVAL on failure to record the access.
>+ */
>+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
>+{
[...]
>+}

This needs a EXPORT_SYMBOL_GPL(pghot_record_access) for any module based
sources.

Thanks,
Davidlohr

