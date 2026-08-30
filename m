Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80C93C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 16:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517BE6B008A; Sun, 30 Aug 2026 12:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8B16B008C; Sun, 30 Aug 2026 12:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7E46B0092; Sun, 30 Aug 2026 12:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF8B46B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:51:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBBB0801AF
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:51:01 +0000 (UTC)
X-FDA: 85158525522.10.935C19C
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 22B3B40004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:50:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=D+sil5Zn;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788108660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNKyczvWqNAkly1A3l3hEKTWoLpnZErs8PHY6+e1IAQ=;
	b=7o0zFoh4xonVgCD0fyWM10zXslaip1wnTSuBJ3lN+HiB7mruoGX1hXW+RgwURA8QuS78a1
	efA72mTDY3vZ8kTX8klXg8Ut+oo4A+H/dlgDWQzc7c/q+3t7BIc9iWSkfiqJ96dC+92bUT
	nkkSxoQJeQ2351YmDPqw3UJYTRS3nBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788108660;
	b=1zzQmzFH1OOkTkmR7nTcqmSVicA+GKfZJlRPRRf3P/IAQiomj60cJBaptbX9/iDeZFFS4X
	6m7J7h+JQQcf0qvSupL8SBHWIgLn6clutue4tgCF+PA24iQ9AA56r6VUegiRs62eSPPlOc
	rVTVoCO0Tkf377sXa8DuGtcVyGPcuzk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=D+sil5Zn;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-90e8095621eso8666176d6.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788108659; x=1788713459; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SNKyczvWqNAkly1A3l3hEKTWoLpnZErs8PHY6+e1IAQ=;
        b=D+sil5ZnPBS61gLiVeFE4IcsuW72QvYaJ1RCcwDnx6X3FcHyVwlR9QlLoBuZoBnBC6
         NPDrS+6Tbru/LCnADSABWKwMhGX5sgadhhVV0zVK0iU2jaj4KZKCcLliPdilm0e2efP9
         gzHbVMP3AiQfvV7mdebA9e4r+Y4CoB6mmjmIZbfjHssS4U579+sHtg38DuXQTK7Solba
         Eem2g1ZYbDBVRkRz5D1xjJjETLt7yTNQu2aakjO7mllZ34Q+vnWLaSxEZv1+KQPTFJLo
         kv40s+NzZNN9Ku/VfLKSiX6JX8BqYPo8bcdE9o2+Flxvo42YhXRAMjpxnDGC5z6lZYDQ
         LRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788108659; x=1788713459;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SNKyczvWqNAkly1A3l3hEKTWoLpnZErs8PHY6+e1IAQ=;
        b=s8ib54xvcAxUQ00ohtCK5pMhKIfiFwuoITm5u4IXTq1oEw2sn5RCEbQYCByU0m0DIk
         dfPRXRAxYyMg3fcQ/q+pW3Sw+DJZYU/9CmDDvuW9GcTM0AcPUo6iLtKkY5nN//yr+pl0
         OBDMmedMAS8bdLGvmYvxGqgofxU/rjBmLB8PQTVV0Bz4BPVSaHWmCnQIVuLuOXacwGg+
         V09WMLefKMB71rt9npcTx9h0PQzffcFV12nF+fW16l4w1aetD+OAjtrt1i8ony3iwc5D
         MZ2uxN6HXBhPuclBWs2v1NjXo962CABfk/wDJJlZp3BOz8ZXgW9QN6TnTfJULVEmHqYy
         Mpgw==
X-Forwarded-Encrypted: i=1; AKwUvBytYy38NPj/00Jv9a9xSSSPLtzTv6/BbYnkKVLzU1f1cME+GD6hGB3HQNIOH9rcRtUWim5dPFATdg==@kvack.org
X-Gm-Message-State: AFuF++mWoa6y+CKt5Xwg6rKoAlqKql2ASF6EHkHNi9ARF1Qw/cArHFJD
	Z3iTNdkfoq36id8mOuEs/4sHGNiGvDid0+dV6uAfpWUo3iwR8qmhgvbcgyTXuSqGNQ0=
X-Gm-Gg: AYBFou18BGo5VucWTCbZnAv8MCvPKcz8NMkUeIsNITvMiArgWidUtCNznm8LV69++FR
	w2iyLmDD4y8SfdBdHqdqB+rRDWMAFdhDu811OGwxbePqDZaqSn+8Crkt2cDzl1hcHX5p4y+iWxI
	f5aQehPJ63u0X0umGzRsDsHrGYdoShtdwds+tYlfOkGeOQZrNpCcF7MrRBEle3c6DlwmuIGzLnw
	yT3iS2EZcUZkLnnwk2nJOwvhUIwK0TEj/IKITot+bNEJ7iTXtagP69jVr/uO8iJzxGgMy2KcbLK
	Tgbn455WJWWUFZzhI1hXLlk6Csu1l1H3WZKh4hiYwnglH4E09EgMc06HuO9njvplVANG/u146Z3
	N6VUctdPv1B59S7HZofxKnna9y6V6j7iSUUBv4mklqTsA2W8MX2p9lUdwd2i8CCuo9RhFQHYgfd
	FklxyJziFHhB/JezcmZ5kwiH1GDnPvlEKfszNwyljDgRAF67M7rJvpFzH6wZmA3g40dRFRWpztq
	etaxhkYRKg2zWG2S9WosOABuQ+snCaYy7dH+cX8CqEr
X-Received: by 2002:a05:6214:1310:b0:90c:bcd4:e27 with SMTP id 6a1803df08f44-90ce0c5cba1mr282798086d6.7.1788108658494;
        Sun, 30 Aug 2026 09:50:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90ce4512dcasm64404836d6.34.2026.08.30.09.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 09:50:57 -0700 (PDT)
Date: Sun, 30 Aug 2026 12:50:55 -0400
From: Gregory Price <gourry@gourry.net>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, balbirs@nvidia.com
Subject: Re: [PATCH v2 0/3] mm: reject zone device folios in more folio
 walkers
Message-ID: <apRd6_7kzBO8aTQi@gourry-fedora-PF4VCD3F>
References: <c2577ec5-acf6-466b-ba66-0b3bcabbef7d@linux.dev>
 <20260830074751.25370-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830074751.25370-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22B3B40004
X-Stat-Signature: oxeprdhcmarpqtzy1h5ju1g15pkxm7fq
X-HE-Tag: 1788108659-174116
X-HE-Meta: U2FsdGVkX1+4nOrUcIrPFNfl/uBGIf7QihL2hKbsoIJzjmTaZsyAEJS+JBT2vGXIpJO2LIQv6Hv+ajSzKWwSrGhUhiIqBBuIkEEb0WtpCnW1HdqpmIlrovN9KHmbkc7K83fKhzDuHXccRCAXkT0chIbC89YfW65uvBYRJhJBVw5B+mddADX5WC+kUaLlI6o9zyis9c7FLt+BvtciiyTWFRY3sd80sAtRFv8UnR8PW4+ALHJTBW5dnfVsU//3YnqhS/ZDY8zd9uGwKyIMiUQTY6lSNNW2FxPvPTTyWlWVQ5HXlYrRGGg9E375rSy2KLOLFSmiJCGSuTl/bPcgFoU/jmpOVODow6nsFMcxtLItQiHjVEWQv0rVgM1XWDVZoXK2bcvD3KCPCpoQHEiDItbS7lPPJyBu8b0Ic7EfArsn1ThdGj1h24j7dZJ/RHATKvYByQFC81nhXzCp7VVwypFQ3TjP86XgruOh6d54XanUrZVOp+eqz77UZte638yMKkBasvv9yUAr1ousoFnEAkSSdC/oIZBb2CIYZeQ/WQoLF5j0aExQiwvoWZvSCHvulDxuvsh/sEi1nzGyft181yJSHigfBFwbQsJCVf+FqPWdsn8YEj85PIXBIczHIUXCj77uGmyWm/PRyqSKoSj4nwNvO+7vedZQWc0KBJ4vjHtPTt3W+SJVxSPv92WC8HdkfM4mw62GurRRSPlCWH+Je4NVqel1Tv47C0a5kMcCzWJdC4i04GgmtBfcOFdx4ctAZ1I4hzRXTM25Mswoxzfrs+//ZC4twsWdQ+bsbnaiUV8wVB7KWpFIM4LywJaJ8y6ZzrZ0i6hGSohN9iUYhvSW1vEILe58QY4pG8y9lgePEMwrRX2WC0yA3HhpF61ceR0jloeOKdcwrlZ6oQ9swch+zqPqqFHuTFLgsSgPsyDSMy5Q5KXL1qF1pPIoim45fXBNFhRevaAcWfPcNk8PfNGQ6Oi
 6S24r06z
 B15ETkJX9kfL5SBvxHn3KqgvgStLlsnj/So2A7/7G6opw+iN1B/icuDy47tLyt8khv2PB8Xm+GBtuttLvJ5OesIHHGYH4ddzD0XvnqmYVi78EQzymvij9+Vj5JzNqnUM2PuEb0q3FmxX8celkIqosPJ0pAaUQ5J02Z0Zu4s1R4Qy08bc3Bu/VC2EHFnPywpfcxHG2CMMScwdLtivKnioHyc2igNZ8jeL3vqMs30Yoge/sIBnD+IR24qBBb1oCPBRkigSFRNEM0Pk59wge/cUUztBiU+k6QKWMsEt7iVknk/Rgag7GDHg+BHBa3XzK0LDixYssUrjaorcFT4q7vVB5iXahmCrlCnhaijxaVAACKgzcXuCfdZi/L9aeiwM/r4RZKc52kZUKqntq7JW3Ucy7+wHUDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 03:47:51PM +0800, Lance Yang wrote:
> 
> If folks think it's worth having, I can send it as a follow-up :)
> 
> ---8<---
> Subject: [PATCH] mm/huge_memory: don't split device-coherent folios
> 

First - thank you for testing, I was struggling to figure out a way to
test this and I somehow missed your email where you managed it.

Second - I think the split checks are worth it.  As I've worked through
my private node series, I've learned there are at least a handful of
missing zone device hooks throughout mm - but there is a lot of nuance
between the modes that is frustrating to keep straight.

Every zone device patch helps clarify how coherent-link accelerators
might manage its memory as a numa node, so at the very least I
appreciate it.

~Gregory

