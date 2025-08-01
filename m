Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9554DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB2D6B007B; Fri,  1 Aug 2025 10:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BB56B0088; Fri,  1 Aug 2025 10:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3726B008A; Fri,  1 Aug 2025 10:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC8946B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:48:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8624C14023C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:48:45 +0000 (UTC)
X-FDA: 83728470210.14.F49591B
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9DEB51C000E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:48:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kKhLeIyp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754059723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TwxNi44Q9HFmkSLoMLMwD0FlHxsUEyWfhiB5kFV0nj4=;
	b=EmPZvVYan2upq4ibyntYpsLSyL5B95ObYH2K18vdiRJPrAXbCV4WxWXz1gYuj9A7SscHW6
	l8pTZvcBpip+Z/GGMGFsWTh/GfA+8BOjh64TW9aDlIe0oOuZUut8m8ZuT12ubwa1pH51VE
	vcsHZS5tn9huTGVgie6Z85uiNBQAPQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754059723; a=rsa-sha256;
	cv=none;
	b=I0+rdF4bVGFlkl/LwnMg5D481BBduhaLnFk7OV2Z60f6+PemvoKTFS5c6NGbYaUoIB5VdH
	+G9vX/Ylgci8egl6QJ0/3qHVAbNSDx+80O59doV56hD92h39l80o6qgIzgbnFtUZ8c2Dv0
	m4KqpoIIcfpI1i8UamyivLEJbNnouhQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kKhLeIyp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-70a57a8ffc3so18117847b3.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 07:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754059723; x=1754664523; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwxNi44Q9HFmkSLoMLMwD0FlHxsUEyWfhiB5kFV0nj4=;
        b=kKhLeIyprbdi5GamPc/zqaTGmAshC1OAp8DZGvwUiQZ6vi9c4DOOHx0n0B0NlvwOAZ
         CoNnOxKMnOn3AXqW+XasdlxdgfuaNYzjf32n7frvXtYHLegxecYjR7VgA4RVOto6Ze94
         g7I7X+KBUqFNe8ne/E9D+pzx3zkYGMJPDbgshvbFVe8lC/jg94jZFuHvmBuMFMDcInK8
         mpWgYQpl4+DLh3Ue8rRG/1QvUjUUtGSa4IyvEfCwdV75SNIPRp5WxfxP6+aIrfQEe3uA
         SWI7vTGj8TXqFPn7YizGgfQaGxAEKD3cV9XdhTfiiPmDr7gwU+OTPALy3CWLeX5YLTXY
         5Efw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754059723; x=1754664523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TwxNi44Q9HFmkSLoMLMwD0FlHxsUEyWfhiB5kFV0nj4=;
        b=qu7R0Wq8UAhB46skBOaMsKrzFpoBi1F8GRmTDC+yPOxGgMuXD5/sFd6Fmgtstn1ecq
         v3XwJYlw/pg0VgOYcgVJ1TDjt+n8KXKwgedXLimEsM7HhPICRE5+cRyURvB6eXeFn+uF
         JrUTsNiu1czCH64NAWEn/KDChp5+z0FRJHDbPLWqmyKqSxcMR/97s5wU8hlb7+//5hMl
         Os7Y7KlfxSlmK84QVqagoebWL9Po3bOeKJNoiK4zuWwnfoHdWAMBZLyFYwAgf2oEkNhM
         2lDZa62yqXVEXseXxh76QNNh3qUkv0PhQN4SEdHSwsN/K2FPohX8/VGVS29Mb03o7lWb
         +mlA==
X-Forwarded-Encrypted: i=1; AJvYcCWwaArLXzDvgKsZv8LZBvwHuKfn1CYqHd+K51vb49MriPs/NdUsWx+MMHmMU9kPgU6n55iesCeu2A==@kvack.org
X-Gm-Message-State: AOJu0Yy9SZQ5HWQiWTynI6TbMddCup4SaalgcVkyOBvcmw6EB8eJyYJ1
	tg80j7vPDkif/OQMRu9uxwTBgVpwNwK12oJaqHxFFfiT8kZaO/S4z5YD
X-Gm-Gg: ASbGnctR1+m13Gv97u+gFLvcy+HiUAfJ97LTn+2vGAR8HrFLLN2jtoj3NHIsiiLS0kA
	wYt9b51vUsGPjOGRAPI8M8QwdGdheSZqce2Hwzwu5vg8WUl1ZAowMma8E7vkZAO5ULXbrzPDQtM
	S446eDumm3qGRbWRxPvIV49GqmkVaK6iIO06i1kUALf1Xg+l+6TL1z9KGDOw9xUVKY4jW/TdYgF
	7OkNAkSiRiPHsky7B3TgEDtLKF92nFdwgWJEc0whvu12y+jrx5Yd05NLz7m1GAj/fVIH81d57sy
	V9NKGebLUsGB9+LM7nLPqX3+aTKNsC9FJXzFZeArDxKY+xhV2EZspAt9cXejeFaaGf17o8KRWUP
	NAjWpVei4EtttrMTP1HaDcA==
X-Google-Smtp-Source: AGHT+IFRRoU6dN6eBPzOGXEZv+hhn2iNZpcOjnYUmOm/adUBtzqRYSVGAKD5VXXsBvrVU3+cejB68g==
X-Received: by 2002:a05:690c:7247:b0:71a:35e1:e1d5 with SMTP id 00721157ae682-71a465a20dfmr165964817b3.17.1754059722557;
        Fri, 01 Aug 2025 07:48:42 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b59fdcdf5sm10799037b3.0.2025.08.01.07.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 07:48:42 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
Date: Fri,  1 Aug 2025 07:48:39 -0700
Message-ID: <20250801144840.2067350-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <87ectvamc7.fsf@DESKTOP-5N7EMDA>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DEB51C000E
X-Stat-Signature: 13umfmkntphxaa6w8kaqecoxj91fdsew
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754059723-556131
X-HE-Meta: U2FsdGVkX19C/vLEM4IQQIksEq1ZxY+vWN/btuaR1UwS8iwR1q/eJsaGqiSYunl9oQLZHt1ZPepHE++eSCRROZxDLEb+ARWaXAThhrj5NznZde3/wKp25PhFGdDWN35mxwgIQ+wU/6CQiFZy5boTx/VYXWM/WhSUk/ErITc5Ntt8isaI5gS8IQuPXPgP+SKMUaAwaxyoXJe30n1YgJJbR2Crf4JcmHDkY/7fKxgQAnmpn23itRnsCaf2Zfo7e5iblQSN4WbV/L5te0aVsBm88of/beRv05jUDt/oewH+U3AS0ZpTQ0JTSrmNeD+7pX3RFTbgcuL5GFPtdEUHfAM2RQypNymCGUrujqAVHR52YyiU2N+WUNdbD0ha952+UVPORCri5teHJqr9mvsP7RvOfIt0IfIAtTSPU8gWmV62d4/KBds39hrDmQMQqVWLloai+/I43K5tfQnVJdjPZhUY/ViTKqEUUaTwyT2ehdPrpMr1OB/Gxlf2sIv7cxyOaHCMY7D3aJVUrWgKKs8kkn0lqcoZmpdLdCaEYtwlSeXkvud/pbEeOnssQVS/SddW5u/iwEukqP5257fxPqz4ETpkBmZSo7tdEbeZAz8i1948ayLsj1qeQMYYzjtpdr6z+PwNSWSjm++k12/VrYYO8T0aJ6T+EMs99ZLsnN/nOrLTc6XFPTqRMaOF5DANOsXLYMEP3MjHj+WsDXVtxk0TT3UI5RxTijPCtk6HaQlVkvPBz1eKMjU4u6YSAiQgxYv2IatA+fz9lcokPPlPn0/Uoaihxq7h3jB5gEj/7JE7W7kSG5MfndJD56cD52eWVF1hFPzlt3aIpknpcWPCBTnTNpDNFH+jFHCfYNJ8nq6IFvmD+67furxbUKvHeAHldoZTt6Au3fZgA0jz5d8HnIALYfR+jb+XwOKE+eM9qg888UpRZEh4xNxHJTZa90PoTS5Qdl+B/Aofix62dsk/wdz8MtW
 HAuznfDG
 J2zfm+56/tvEYhF8dOCdlh9kP4YSB/2GKm8HColLm+RTl4SJd5+qLUFs/TsdYRBAsXX2bnUz2tSbBxn3436OCr5X7Dl7Ro/zs62xBO7MXRg3beeDK6PwpKRCmLJ4r6s46lgb8XEbr9bkLcAjLvU4GJy+YbfQ1BX89vcwd0GGtvXpM5O0EwEvWf3B51PVJ2YeDB9Dhg2NQJRqfpVgdWatatbR3oH+/1f8fvwPRjlp5+F7R2AL1UkPPtM77n39NkYQNJ5ELWqESUs7cEzQnHVTQUlL4w/weQaw+8nyKIDWi1ADU/JZ2FsE88CV6hAUkcKBHr7pHrdOHvA0yKVZNPqvaWFtcyF5NrgP3mV5zK6HZgtiTY6RxyDPL1IjWOIgdlGcXYae1d7nk/yrbukO5P8U/SqmLIE5liOrQmJuqudxeHI7x/ywfn222vzi9qP1P/8cFRjOE8+cshFz6v/YnR4WbfNNKt+Yt+ifNpWgFCuXiiXyX7D/AAjrlGD2Wcv4vdKkhdP0gwu84z2OP9yaj5frx0rtzjwHG45sdcx3ivVWUKjsvEQEVN6zEzskJBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 01 Aug 2025 08:59:20 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
> > memory. Contrary to its user-facing name, it is internally referred to as
> > "node_reclaim_mode".
> >
> > This can be confusing. But because we cannot change the name of the API since
> > it has been in place since at least 2.6, let's try to be more explicit about
> > what the behavior of this API is. 
> >
> > Change the description to clarify what zone reclaim entails, and be explicit
> > about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
> > past already [1] [2].
> >
> > [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
> > [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
> >
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  include/uapi/linux/mempolicy.h | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> > index 1f9bb10d1a47..6c9c9385ff89 100644
> > --- a/include/uapi/linux/mempolicy.h
> > +++ b/include/uapi/linux/mempolicy.h
> > @@ -66,10 +66,16 @@ enum {
> >  #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
> >  
> >  /*
> > + * Enabling zone reclaim means the page allocator will attempt to fulfill
> > + * the allocation request on the current node by triggering reclaim and
> > + * trying to shrink the current node.
> > + * Fallback allocations on the next candidates in the zonelist are considered
> > + * zone when reclaim fails to free up enough memory in the current node/zone.
> > + *
> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> >   * ABI.  New bits are OK, but existing bits can never change.
> 
> As far as I know, sysctl isn't considered kernel ABI now.  So, cghane
> this line too?

Hi Ying, 

Thank you for reviewing this patch!

I didn't know that sysctl isn't considered a kernel ABI. If I understand your
suggestion correctly, I can rephrase the comment block above to something like this?

- * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
- * ABI. New bits are OK, but existing bits can never change.
+ * These bit locations are exposed in the vm.zone_reclaim_mode sysctl and
+ * in /proc/sys/vm/zone_reclaim_mode. New bits are OK, but existing bits
+ * can never change.

Thanks again for your review Ying, I hope you have a good day : -)
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

