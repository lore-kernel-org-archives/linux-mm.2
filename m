Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7204BC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 13:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538456B0088; Fri, 25 Sep 2026 09:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8726B0092; Fri, 25 Sep 2026 09:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3216B0093; Fri, 25 Sep 2026 09:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4FE6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:22:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8833AC0638
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:22:27 +0000 (UTC)
X-FDA: 85252348734.18.0C0A46B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 146A1A000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:22:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fOKfPt2k;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790342545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mfp85Na3VIvxFepbe+2FVNLR998tfGijRwpOnXjXS0E=;
	b=Af/vnNJN+vYmYZRoLL+2uYbpDhty2UXQuI06/twCVim4AgZMCnaf3xtdpMuLXWvyrIIZrP
	EO3PHjLsE/+rsMds3O6DokI3jMTLf2RBo7jzpvI3JZNYmK18JvY/T9bX7BI6190wmkJTM9
	zfhTT0Zp7AkmXj0w+oP0Ep1G0yYD2BM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fOKfPt2k;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790342545;
	b=0h4XC3TNHNCtKEdd3ZvUArtVz/ahrKI1XILcbq8Ae9OdB7lS+5TazscWiYK0ooReZ2yEZ1
	eW/TOP5jbK/xlGsBeeD/AKMEB79SfVZBsVcCcXAuyuo8ahu+9/vPfln32hgv+Tjz4HqVWk
	ayoFbvEX/VIygM8wdq4pSsZsxieok1U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790342544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mfp85Na3VIvxFepbe+2FVNLR998tfGijRwpOnXjXS0E=;
	b=fOKfPt2k/qkngRrNihgEPzV+PiFb3us9Y3/uhFjMZ1TdRd3BmG+M0oag/GpTFq7R6JyCkM
	nY45gWV1lPCbKIBOvDkm2/XSodcCTqlJLPz4K7ZHGOcU2wezsvP/3R90SlndcwzSHfwzSH
	tWy7KSCpXER0hwV0VpWlVtHWNBbQw6c=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-ZoziXem6MqqCICd_zC7nlw-1; Fri, 25 Sep 2026 09:22:23 -0400
X-MC-Unique: ZoziXem6MqqCICd_zC7nlw-1
X-Mimecast-MFC-AGG-ID: ZoziXem6MqqCICd_zC7nlw_1790342542
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5b8edbf7cdfso35850e87.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790342541; x=1790947341;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mfp85Na3VIvxFepbe+2FVNLR998tfGijRwpOnXjXS0E=;
        b=P1yPsSuX+CQe5wC5X1j++HyLYpYW/bdUyFZcGAdhGI7Bx5Ex1Y7nYnPJh0sL0dclbB
         FkaUIhPr70wE9cnv05G4/vAWjdL62mQFFSZ342vLGGS7r5c4pCvn1XJn9hN43WFcnF3I
         bs5K1trQ4gariLqolglmV/5Qqdt/8y4GLG+lUSuglaT8J4d2kHtyGp0TXhKVhekfn+ZH
         6BYFYcjfFGX+AhccuBMDLLNsq3bf90xZWDXcdWAmIXVQAo1Spu0q0EvA1mbfqwyZouoK
         UqKsLJk0Nziw2xwB2wozoAyk4ZJnNncaf85fIHKWGA41aB4dFpPcgXEezK4fjnAJzEit
         ZFEg==
X-Forwarded-Encrypted: i=1; AKwUvBy1NX9XQJSH0DzJlXiqw8u6h1CSbrWOQq7etNtCLRI7uF+zn8UgjDociaZFmdG1naE4YpCe6nRk0A==@kvack.org
X-Gm-Message-State: AFuF++ni7oMA8DOJ7MDcA87F1U/5dtqgJULbi3OKvawao1ziQANab25f
	QB/31pApPXjdQAX5gK29m2ob5Gwbnt+RsFHTo27fPmRdFv3ydBHlxqcn0viH+s5VvoPD5N8+X9S
	ni2z/LnJIl2oQ9JJCri0+AP2XR3seETWIqgnQAVa6sE6zroN3ToU=
X-Gm-Gg: AYBFou1+oRXZxBFPug7DTcc/NbAN6QluII067twQMwJvAKVk75+L5rNSVEfs7kiP/sE
	7y/TrdgHyiv/dAhNrvEoIMqHP2K+ijJo17od/V10ityAbZK4yrGvEP14QFyT3TT9o36YfHfDusR
	tFZSTYnY/jM2+mX7KxucwTooG687/yOD5vUPM5P4SmQ0Qs55RrGWqA8+81H4uDlFUwBGUyHuObV
	p3sFc2Yqme+iLIxsMTXSnDQHsvTVtw9tGSOawMKhQTeiFI1HdkKMYV/vBCWw3t4oXwJDPT9ixS8
	w9UvLDsordCM6h1j8RLo9d7dQFs0Z2+ggEy9y2N5mdpxlLeKKdJv3ZpRPE1/eRRKD++szgi5GYm
	CjfO8RoreFjNmoZlUv4nJLkvBg6vNOj0=
X-Received: by 2002:a05:6512:3e10:b0:5b1:121e:56c2 with SMTP id 2adb3069b0e04-5b8e6b36729mr733457e87.0.1790342541322;
        Fri, 25 Sep 2026 06:22:21 -0700 (PDT)
X-Received: by 2002:a05:6512:3e10:b0:5b1:121e:56c2 with SMTP id 2adb3069b0e04-5b8e6b36729mr733437e87.0.1790342540724;
        Fri, 25 Sep 2026 06:22:20 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a64c2ea5d2sm5510451fa.18.2026.09.25.06.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 06:22:18 -0700 (PDT)
Message-ID: <f7cc0ac3-729e-435e-9062-3317d0a6517b@redhat.com>
Date: Fri, 25 Sep 2026 16:22:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 00/11] migrate on fault for device pages
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
 <arY5zKsLuf7f_EYw@infradead.org>
 <65c5c412-56a7-46a9-b22b-22077a8e9727@redhat.com>
 <20260925124737.GL9354@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20260925124737.GL9354@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pW1mSfm2G-qIuE_ps_IZ5Q45ZrLL-5TI67lwF6p2sKQ_1790342542
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 146A1A000C
X-Stat-Signature: yoeqfoi7yubprwqethkfa9rxrjk3sfa6
X-HE-Tag: 1790342544-48494
X-HE-Meta: U2FsdGVkX18BEWghYfg/FpDXE3NloHlG4DKy4iAU+bChXSkCk4B7O8fOk/AzAifqP1rvmM3IvuwY9eaEMKDLZo4VAA/4BxpLQlW24/QW3SdmtbGdcA5ckzBQNuoqCvpnZj37ooG/Py80KJI7oSWZewetFpPuZ9ZZwbcLuHwpvVEDvGAQCYoQ8elbKOL9jnee0TX7cUzMwrmNbGnCM/53KD2chBFXknCBchue6U/nNRAYq3CW0OrHO1GxpEsognJjC175EPz3S45ezGT4NHTRL57kN4oWggxDXqyQGYwpkAAPRgLV8vEakgV2jQ6B4En4axTzh9pwhZpCi3UP/WuVSqz/mdyJpimJ5atL3wUX+Hdx27SAWRYCr+oMrs5EasaQDrbwKdaGONL0CEJB1DVk/by9RJUJSzrzkpOwY+GrBRtr+gP4OXib+XA+lyvSW1kJBvnCf9znE1qhc1tH766s2uxvJyKZc9VSWWMgi1Z8uJAzm0EQloN7ahfCKXp95XXKKgCBvIuqLi1FYa2MuNjAPrAfMxa8jzGvtuwBuJeZzuC6U2lbJ6etV0OKkD1Fw0Gj2RvEBX1dJE9gpIJLa6OLySeqHL5jHGkCpDtPUpmzwBX1NfETX2v4Zfoy1SlVnlpBudntgLxbTtnNLIQuXFQrcKNmQpFJeZ4DDa85LXG69LG0AD/BaRD99WifI0ewCFzvVpCFEyi3KUtxlKnjLPj71QXhVcfsTB2su2C4Wqpafk9atLt025FRd5nIZCp5FhgJRuelrgtrGPL/E1K1wPQ/wKBfhZwVlGkAprcgY6XemJ4NppJZIjnZEgb4xXUkHBEpeiHo0F4uyb0g0PD8yDQvmjH3FzNmrym+g9hzuJoA0U71Yr6/hIM7jbv8UfsaXlWn1RYIsSx1UqnFp3O81JEtX/uoGS62amMua/g/mG0ia5+Qf+pnfy1v5Qfn0q0fdKmpO7YQ6XxYNPPa5I46Mt/
 RUd/2bEx
 CDLGkR+KmltlPfYmzDI8x/LufWn0Ej30WpiZ7F1jL9QqgCEyWxjfpWzmcQQ53xa3qvO/a9qJeEejTMYZzLoR4O/M1tzo6v+PL6zEc3IJAXyzEoYra0deZ0k/x6xpNlKsoHrZmYrO3XgaSKxZNl9975FdH3gnIvAR5zISNbdaSd8NXAG7AcfZwKDhcqlu6llkwlrO3rF1FODELfM6hgI1/8BoeDNf/OY7oYcuewL0HyekZu2Unlz2KTE6QhKDODT+P2/I/XEhNEeRQztAngQ1POTmZxx+Zv+7mwac8X1BfB65MDSh9FNzF+KmZ0dfoAxCB2hb++llhETrDV00S6Choia4XTVM6B/GL9PvYCw4oheLpGHvVUM4pn9r8NcGH2QCohjM0H4gClFZw9ND63fGU7LE6bSRuLZiJ/VhyzWiADR55YAn4DCjJ/2i5Bzwibhy52/wWp5XpaiX4rp70b2Co324teQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/25/26 15:47, Jason Gunthorpe wrote:
> On Fri, Sep 25, 2026 at 01:23:52PM +0300, Mika Penttilä wrote:
>> On 9/25/26 12:07, Christoph Hellwig wrote:
>>> Who is going to use this? The series seems to lack an actual user
>>> for it. 
>> Two users: For one, existing migrate_vma_setup() callers, unchanged.
>> The series reworks migrate_vma_setup() to collect via
>> hmm_range_fault() internally (it sets HMM_PFN_REQ_MIGRATE and calls
>> migrate_hmm_range_setup(), mm/migrate_device.c). So every in-tree
>> migrate_vma consumer — nouveau, amdgpu/amdkfd, drm/xe via
>> drm_pagemap, lib/test_hmm — runs on the new path. 
> So split the series so you don't add unused interfaces for now? Jason

I think we get the other for "free", migrate_vma_setup() ->
hmm_range_fault() is the now used. But if wanted you can drive the
migration initially from  hmm_range_fault()  also from fault handler. If
don't want that then it's removing 
EXPORT_SYMBOL(migrate_hmm_range_setup);

--Mika



