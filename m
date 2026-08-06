Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A563EC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865646B00A1; Thu,  6 Aug 2026 13:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CEA6B00A2; Thu,  6 Aug 2026 13:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779F96B00A3; Thu,  6 Aug 2026 13:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54FA26B00A1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:09:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D196E4017E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:09:19 +0000 (UTC)
X-FDA: 85071480438.14.62A7FC1
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 07CEA1A000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:09:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aIG7gNhH;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.216.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrNvbsHqFNUR3TBZVVh5jck8vhH3UNtuIjBL6oQXZGU=;
	b=MW/AxTAJKWwETUDDVMwjKXqtlyVUBeuwf5pZ6OwIfU1LaOg1pGm4FSV66YaXgZ4Qxzg9uE
	VU9onAs5xpiM3amDCzJKhaF8iXQ9o/Y1N6NwaSh37z5Pr9n7b1F6AECFNaZ7JURoONdUPr
	5b9Lp/BIol4fI+JAihx6D5KdvV84yPg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aIG7gNhH;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.216.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786036158;
	b=bLH4p3o6v6Di9LrYboCxs3afA58J7bRvqYnF14e8nFXFrrB5alFyt0VCIztMX+HBZdfpE2
	fGFpyN8dndKEQ4uCd3hfNuZV3uQVuM5czOQZJTwrnZVbe/IAk2xKYOy0ziQQrVQ0UIBjha
	3YH6KcoCjqcA6R4fcP3gYPTUEgpaxwU=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso2867533a91.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 10:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786036157; x=1786640957; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BrNvbsHqFNUR3TBZVVh5jck8vhH3UNtuIjBL6oQXZGU=;
        b=aIG7gNhHxJVDSzLSB9gb52or5WiVM/Yc5AZNrq7b6BYt9kcufNAXvsoXn/kryL8fY9
         R8y8E0jhParYB/kidvBmcsvHFVhk656HfLeVpicvo5+ZvfwIBomS/NYE9qeXkkWd3ru3
         r1P/hZ+CmueWn7J2oWVJ/vjYyz2VJ/LZJ5sSgzuoFeMzqzaWCogt5WFp4Bvlq9EVWcs0
         ZU0GTtD2uxoHgWdU+Jhd48TlrwJ6+ZcLSZR9uPkDAob3o+5wGg+V9YICisdnl9ltwnra
         W+hPMCgZzed3wTQJ1UEVMkJttx34xUMorMLqNWJy+7omY7aHyJmcqwie5vttw7wN16+d
         F0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786036157; x=1786640957;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BrNvbsHqFNUR3TBZVVh5jck8vhH3UNtuIjBL6oQXZGU=;
        b=V8AyERwsjlDuR901+r7gOOWOGV0B6H3lAU5ECeZRBf13WydsjojeJQ6pj6VcHBqsbi
         BgzNxSH7T0i/D0sBxat8Nc+2x65LWTO83q4XceFR4PLOQS/lOcueAhW07sudpe754vZS
         3zl+xGC1/0gnyxVXzNolIdLiGFqF3R7wIQpA17Mw7AyE9t0yImApf6YjHjJCswQSOnIr
         5/XbGFcUlM/xdVXB+k4mOBCZ7YVDbg5i5q4PGS9b3fOpQze2MYh0lKjX760eajgpVbns
         7VBFgreAWysFyXpRQAMXHz6oYgfLf1yp+mKxbVchdydjwQqYXjwgIgyX4qcuuzTVeImA
         HOEg==
X-Forwarded-Encrypted: i=1; AHgh+RojNC3K010ZrAwQMuPsZ4/zGUG9qfH615jXIH9UJNZm/nxGf6Z0gWQ4icaGFZda2k/oMXP8D2SivA==@kvack.org
X-Gm-Message-State: AOJu0Yw/Oku9N0aKCXwunvAn1QXmFl1Q1lEp8BuVOz//A9a2ZMc5iuZC
	F+H22Q1ipAqQmjRWcThcjmZNAMxSTiKHVTyusl8Jl/l24IYjpmUCs98zR/MSsNCNWG4=
X-Gm-Gg: AR+sD12IQi/nmp2hUdBdT2tSpvQtaoVQcRtC6jZFvygPgD7tsWR73LnW+bNE9VVuTos
	wcurY9TX/8UBdkkvQbmvaEkGeUvxc3g+ww7++B5tsp92V+7+tJnuqFF43RK2q1skV4r9YqGOTkt
	SFIgm+V2D2WZO9ctVWtM2xI4no5SDTl+KEwzBTmHE41Xiqtgfq5Dkw4XmdS6bWWcikEIMkgKSSW
	Vk9WVFa0aK5HVrK8/uyHVHiY+mh4a6NCBCXx0FLxhlkhge0NKs54oK8eTAJP05mCVxGdE/KCpv6
	uM1GzSgvMZurepaYjGFiPS41jFlOrEblRzih58/TFmN0ZLQPmL31tdCRU5z96Zg/vWXedTeqT7v
	9y2aElHpT7Et+P+6fJRAlv3gIMsQG3Cg/4NynVgZFd/4wk1xjYWPIJ1cfn3PuxR69vj0ikOWsdH
	HqpP9iWt0azzVAZ7iUCPQgKJO0prj/m/1ynZQBhbOqh+QTWXmCt0VL3Q==
X-Received: by 2002:a17:90b:4c86:b0:37f:c22a:c188 with SMTP id 98e67ed59e1d1-3903c5590dfmr14716699a91.4.1786036156912;
        Thu, 06 Aug 2026 10:09:16 -0700 (PDT)
Received: from fedora ([2607:fb91:201f:cebc:3a68:390a:144e:1b87])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-140f744adb2sm13381819c88.2.2026.08.06.10.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:09:16 -0700 (PDT)
Date: Thu, 6 Aug 2026 12:09:12 -0500
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
	damon@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	vbabka@kernel.org, jannh@google.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH 4/4] mm/mempolicy: skip zone device folios when queueing
 folios
Message-ID: <anS_uO-ngBV52d5Z@fedora>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-5-gourry@gourry.net>
 <82f6afba-756c-4ffd-bd5d-c3432179af28@kernel.org>
 <anSNk7zgoGj62CWk@lucifer>
 <0c90b9ae-48ac-407f-9d73-4c501c82cf40@kernel.org>
 <anSXFHZZPUf1iFSm@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anSXFHZZPUf1iFSm@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07CEA1A000E
X-Stat-Signature: izey3euwocx8r4b5gtkn6qtpibqzkhqo
X-HE-Tag: 1786036157-152750
X-HE-Meta: U2FsdGVkX1/9F57BTUbyx/+jYCO+ChzRIVvVstfEhcff/j3LhcahL2zKGz3cl5LzZqwzd1FUi0h7E4DB8WtCq65uj6BCdqlyDzOs+3Qzy1ogqhwneqYiEKckqqCV17uqEk93Z2b/yV0RqmecitWMbx9qB3VlUmjLP+UG1b1U1z+FNdgrEXFhbJns4x4qLZi37R8UGrxmed5LmQ1dDX+L57quUBxviyIx3VG50pwE7BeHOP7b+Gzr1xZtaXH9o0SoenM8WbywpsrgRmp47PeYNAuAqWvz6NB2J9GUy5WFZHGxV2ZtEgoZ/HZiTT2enDn7wTlwjP2/OLbKPe0FyjPlMz3F9hiVIFP0pX4kXXYj3tBWRRyG47bM1Am/BjudJUkSmi2Upcicbsv5qqAl1Ux1Kkvemm3C7i8ApvEizzTsdY+mkkbJZagVQh2K8dYSRsuDfl5PieysF2F7ruIdC67sP5FODaWbsnjK4x1MEzNcw5nBbWAws7UoMMWIN6kNZrVd5aMiysXrdEAdv6Xm6EG3XFG+oSAfbHqWwKVghJtqmJU2hxMdzPk5pjhnOKUO4vxUceE7uNm2lsMy+HWf6XQbouICheBEfTDksJu2+jT8jHRy2P+FrQafxYYCif3ZhnYlriDG5+nlE24XVgUXJRMXg0yC7DcqY4Gm8nXZ8Fbjq4kpqqOLByvzYXiQMtq54ldpXdeMcrcxHnz2CFhOCSD6EgI9X5t7ALVjFjZszXlkF+deoAih84sOUJ5tUg5BF/7Q0jhUxC8CFD71ZTaKl7Gkt45CbN0AvOPcGeq/Ye+mIHeO2Ry/+o6fW9JaKBB9Lde17X5gBb3/dfCqcFRrKkyUAnN9OXYVu8yk7QZGNEhXhfkF53MUXxsVTrwEOuz1NjqUXxvZ/6i5S43Z28X1E3SubpUrZrVXlwYUC7ZtDCupUsIjros7x8GWa5N6a0JOJYxF/hbEI+bqJ3ggz7n/akk
 bB9RaCAT
 rrbUznonVXF32gIQYvVPpexoCf/wwa2AEWkfBTRXSWst+UshO7k6KuyKPHnrIs2IZMtpSpgVf0fmFRwiZfxeRKl5jcRp3aws5CFck0VZbkt7KkO73dTVwJYcbdfH3GaPNu9t2hpT39sHFt2bNs1IbuU3U8+vkbtyKbgcjUukQi8mohQcIG6d+Xd6aMMqZwGASPQFwZC2T1F6hNKINk49+MBnefMD8rykNS0Dis03AosaonaibtbTvsP/zSb0FvCjgkcvhxHhVKELbVc3ZGQGV6SLviam2G0WbRYkXp78lP1by0S7ZJJFgYbsv8tOBQrobO+ZiiHFmYxyeSAVnyC9+AMaHCaFGbgFnTRRd9Uie/4A2bT3VTSVUC3grMNgltvqn+VcQ1R3WG7rQMIlJiQ7k/parhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:16:03PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 04:11:21PM +0200, David Hildenbrand (Arm) wrote:
> > On 8/6/26 15:36, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Aug 06, 2026 at 03:25:50PM +0200, David Hildenbrand (Arm) wrote:
> > >> On 7/28/26 21:47, Gregory Price wrote:
> > >>>  mm/mempolicy.c | 4 ++++
> > >>> @@ -797,6 +799,8 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
> > >>>  	folio = pfn_folio(pte_pfn(ptep));
> > >>>  	if (!queue_folio_required(folio, qp))
> > >>>  		goto unlock;
> > >>> +	if (folio_is_zone_device(folio))
> > >>> +		goto unlock;
> > >>
> > >> Leave the hugetlb part alone. hugetlb folios will never be ZONE_DEVICE.
> > >
> > > <Insert leave Britney alone meme here> :P
> > >
> > > But dear God we have got to find ways to stop hugetlb being this big stupid
> > > nightmare that every single path of mm has to put an asterix next to itself
> > > about!
> >
> > Yeah, possibly unifying the code (possibly, because it's a mess) but not
> > replicating checks that don't make any sense for hugetlb.
> 
> Yup agreed.
>

No disagreement here.  I'll drop this.

~Geregory

