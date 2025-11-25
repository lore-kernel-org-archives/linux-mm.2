Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2542ED0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0596B00B1; Tue, 25 Nov 2025 13:55:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792246B00B3; Tue, 25 Nov 2025 13:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A4D6B00B5; Tue, 25 Nov 2025 13:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB956B00B1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:55:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDD0058A53
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:55:15 +0000 (UTC)
X-FDA: 84150032190.14.3ECB074
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id B07F51A0013
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:55:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=bxhPK0pB;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJ+bbVVxrKVD5C0WKXzvpmMcj/N1KvFhB6EMxCv7yw8=;
	b=6hMrJhRg8+jvOgFYRruH4sceef+TR+wnD6nmCdFJAw0ygxWyCbcPWEx7ZgViUOzk4i06XW
	xnbxxxqJa1Z10nJnkr6l2k3r5AGO4uMXrHdfqvYvoTFet0/cHSIMD0UGUyMj8B25NE+3ss
	SvAHV1nvxTXK0QoE24Yi22LfjUTWXzo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=bxhPK0pB;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096914; a=rsa-sha256;
	cv=none;
	b=1sn8vzAT6feb2mQiXSDpfYZBVvTHsBZTaxyaS2Wb+f2q8f650ikq8pAutmdP6LrAX5r0R5
	pV353e37IH5nCLFO/NsKmc/nnYRuKJne73jNZYhlP8XxcvNtS/kY3i6vmzwMJorTn3zvoS
	2dWm1NVeiviwcR9zyttcgR/fiWglJ00=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8804650ca32so54276996d6.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764096913; x=1764701713; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mJ+bbVVxrKVD5C0WKXzvpmMcj/N1KvFhB6EMxCv7yw8=;
        b=bxhPK0pBFlzWMRG6uP2pg/n5Dxod4fQ94QzanaKoA5bDOk5Xs1NuDUKMvPyVFKEbOD
         EwU6Ug35Kx4jMrKmtV2ucHlZByZ5zEzDOp+S8pAqXykmZrd4KHGZy3sIa2oQUXTZ+V6J
         tbdSb/NS3bVavdwKz/22uj2ZRqZzEMG4lvkInfLiqvI/ilkm1Ne0orJhj19yGcfJ3e10
         ReDko381aMDJ7Cx+ZADxW2U1kJLzllJF5JRyzQ7QiWym8B8cgbMvv9DinUrACXL5hgX+
         zMSLvyIh0OEX9jwTiuOfPyA4q1g9660gzTTwz6xljTvYJE3487/kINdwwhhbwFi2dEOE
         N5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764096913; x=1764701713;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mJ+bbVVxrKVD5C0WKXzvpmMcj/N1KvFhB6EMxCv7yw8=;
        b=G+mb9cZFXnL+4tYkZZw/GI0zLj0iiP69DmVG278MDKTPlNBzlcl05xQxTN9Z333EH3
         4i9ny+XT3MNIzy1ZmZeQphIyut/E0Y6MoytS/SM/TlCZe8WaSsyVi6wGNabOTHuRsKuB
         rmt4F0nsj56HfGhiz7K88Sdg3MzOyUhUN2lY+OcIAeTHueeOvG1YTdpwUiP/fzvJbP4C
         FiAgl8hfiCFaznt3B50M77T2TVstoK3FwAF9P1VkuV4p7AfbR1WqzTIWxc5WcqF7SMEY
         V2ArikIQkT4n45DxenFQjE2LVYndiTtkd6GEj+sd7aAM7D1LO3oGDjFAtQh6jmCrSfx7
         yDkA==
X-Forwarded-Encrypted: i=1; AJvYcCVL9LKx+D4ow2d8LgXt8UwMnZ7/HZ6+3QfqOIhe9vkWT3oGcztiaXDW/EG9WNbCkV1cnfSP7mhC9w==@kvack.org
X-Gm-Message-State: AOJu0YypBwtAEIvTHS8H392xoHjYd+UFwiaOmhImWB85q57xpVq++YAF
	EcuIRnWmbx5UVfGbPUiUDkO0xET67jP8D2F1i5OqLpzQRnY+Fg9QUAquhjfUuEYYeoU=
X-Gm-Gg: ASbGncu8lK06QwItdarPHyVC91Z+vQPHRU854gqu3J/QXNFdt/1GsNwphMbA0AlrQzN
	jrQkMPYZje3z+5fI9gMBNzq/PMnSfmpD4llUfPD4NIRqn+4E1IO/2BInIMS0oAnNZbB1Jn0+cfj
	oBgOK+U2FLoaM7hylebGBHGj6sDgvKmkduI3tI5cd760ng7XGCLOLFdUGo8DGdy1Afo4tCceEnX
	7vtexeujfjW+dseboWTyRW2/ZKTjgSniwYJYvlzvLgZCEgFJBS4BfQ4g78ka+4vCvlIswmTZy9D
	lCivOA+VPzSO8xlV3mPCYmWYDUokI/6wim2K1p4eNA1WBRybU4NEEmbi7b3ZWLQPSK7YG5LjjKR
	WOevr1XyUYOrgacvGoYZZ5z1EL9/NliHIvGt2/JjgbXn5a4Z8dxj+J8X5CxmH/vHjdBPc5EKy49
	+OnrfxnPUn/g==
X-Google-Smtp-Source: AGHT+IEDvuOBPqwKmRQc56aYDRMDLHc01rINDPPcJSg/6v8oq66YL/0zUMistG8IG4ckBpIrHtKqkA==
X-Received: by 2002:ad4:4ead:0:b0:882:44cc:f587 with SMTP id 6a1803df08f44-8847c4883b2mr229163866d6.1.1764096912678;
        Tue, 25 Nov 2025 10:55:12 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e446a06sm130735276d6.2.2025.11.25.10.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 10:55:11 -0800 (PST)
Date: Tue, 25 Nov 2025 13:55:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratmal@google.com,
	sweettea@google.com, gthelen@google.com, weixugc@google.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <20251125185511.GA135004@cmpxchg.org>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <CACePvbVNV_JRRY8p=dXj8YntR-0nRq3dbrBPz1G2bEmGH0jxpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVNV_JRRY8p=dXj8YntR-0nRq3dbrBPz1G2bEmGH0jxpA@mail.gmail.com>
X-Stat-Signature: 6pm8b7xoszeact74of46thcbfkb5n96c
X-Rspam-User: 
X-Rspamd-Queue-Id: B07F51A0013
X-Rspamd-Server: rspam09
X-HE-Tag: 1764096913-553529
X-HE-Meta: U2FsdGVkX1+RgMPI/LSvZpNVW+zxj92gF8ePQmw0ZLXRx86JZc3csni7gzA4zcr8rooPZ9GNl0mm5LXsSXH7JtqSAkmC5LWFO5kFSS/bgr/eEWD+T2p7DRc6pkGV1YL2QiwLbk72Srd0MbkXIs31Zl641/ouLCz+7kxMAs87haf0wf1vKmdmWJbIY8f7ICzAwpaqlDn1EmFSXPJvDLTcVZz/LfNT2g5O8dNkEn8J+XJYLWRnaXrZcigFoFOLAal6sNwkncScAbmXS9Uz7mm80tjm25YHL1Sasm3HxQKWF+vNNADm7hw7f11zKnsy+sKBmI+/f/cyK2Qy59CpF8lQDwS01c13jiFp74eBotS5VglS1z6hst6CyiHcdYqsv1w/+dlIpJResYGVUWOdF8cFbKAJQqD63NtxUkU+OgPjJ5/7sVUv8xwh0svRtR5Vw1xGMfysZs7DpVqeZSvBEGEc1Cfz5fEHEjAptcoaL7eHsV+EPA3NERlCMahZsmKEOzx+THKGNC28X3QUFgLAGs2YFAaacp39kNO9ZA8dKbOQA1egqejhfn4g1myURcYx9WbbOgOmk5D5MciItC8xf8TpgkSkM5TSZ5YgTeER61a5d4viwIkfscSJ+I2PXtiYLRIGddtMmCsh+45oHLxjKOnydUd3kxFZjf4K/rhegEf3Vs7UKs4a9b82FO9ElIBzRx76WBG/pAdRCGv/2pPQf9h0sTmF2JE2X27H6SCJyg2qearpkHWL6JPOVGF6YJHtWVD92c+RreZQ049grrZRfWBchXEdJFKlnljuUTE1xajqILKQsAcKUiJKtdx6yN7eeV/U/jhKp2NBhI8zQy/Vp2Amrnk0tVXxILPzjCbY5tRSKS2pkJSAwwWIMGVr+ZR7+bfvnGlcXS5G5Bjmc+GWicv/8YM7uNdmxoPoUpCPIbyAmIhGh+tTJNXuYu3midTzmit3MYZ8Aag7FjTd2MDglGu
 43HaxyA+
 mV7Dg6vHWuOIHt2PyNYFfZlH/bzLAooqt92Dm7yh7AtByx/JkfDHOrnWLsyAGp0jkS7zaGrFpsyvjZge1CvqGb17BLF8bvrSwxRcGR6Yyyj66Fw1GPaGmp2nmYeIKDaeMaNkUdKI25FVSUdN1U3eqpm9lKqmp/H1qLUs9EzGnnSG9vKmSMoKYhB0le4K/agUqOZ9qBodBbCbQyZUAni/9AM3aueosGawWuBynLmqxv90yplfvfhYJlXxslp+If2jSV7MMMorS5L7vzWaACKOScKaD4CmZtFrZrKsk3RrjR+ouuO+5DjXilf0Edg3za3o7v/WLFx4BfTIenqkejzDQTDWQHAmKmxhiT5q3owf0A+kFaDB6jqCoBGx0upzkvuKdXvNXRzB8gzbNkr3RjxTYaHeFUErfqMDdx80nHk0t0CK+l/kM3YQROl8jjobHdX6/kJk8MuZ3xnkAFjYRcNz6KjJ2+0TULL2F3dW9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 10:14:40PM +0400, Chris Li wrote:
> Hi Johannes,
> 
> On Sat, Nov 22, 2025 at 5:52 AM Chris Li <chrisl@kernel.org> wrote:
> >
> > > Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
> >
> > I take that the only relevant part is you are zswap maintainer and I
> > am the swap maintainer. Fine. I got the message. I will leave the
> > zswap alone. I will find other ways to address the memory base swap
> > tiers in swap.tiers.
> 
> I am sorry that I have said that. Let me take back what I said above.
> I was upset when I considered you and others blocking the more optimal
> solution and in favor of the less optimal solution. That is my short
> temper, as usual.
> 
> Now I can see that you might not see one as more optimal than the
> other as convincing as I do, or I haven't done a good job explaining
> it.
> 
> Let me offer my sincere apology. I will reply to the technical aspect
> of the question in other email.

Thanks Chris. No hard feelings.

