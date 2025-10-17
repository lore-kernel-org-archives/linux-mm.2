Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D128CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671BF8E00A5; Fri, 17 Oct 2025 10:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DEA8E003B; Fri, 17 Oct 2025 10:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EFA8E00A5; Fri, 17 Oct 2025 10:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F97D8E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:59:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0B971601E6
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:59:06 +0000 (UTC)
X-FDA: 84007913892.06.BE8252D
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3C76F4000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:59:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cqv8JRs4;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760713145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTA2mSeVwafy9i2CstFmFNoFIIutQdKDJAn1493tDAM=;
	b=g6jEzEL2jr7CVw5ul3AnKWOysSz3bW/K992CgZUqLgjL148NZsOPBRNRTea/LsSNqo0fQp
	pck1oikuzPc4i6P0AjSSTXL5u9RVxVfQpSyGqqVya6gcsXVDQtvkYh0Cu5G3Zg+8qe6Xpy
	TR28lZXXIraCUH5SOeY48ywBpgSU/64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760713145; a=rsa-sha256;
	cv=none;
	b=UcbEagQu3gEdKeq/OzYTTRphGEgStmAVtuZyCDEICW1V2AMhAP/vM3zf7YEEYtM8pH2InL
	86Yiqh/lutu0xJNKMBYayaiRc9fX0rieAmIG6Kl5k6tc5wuG7foK9EUPt05NdEKvWOjQ6A
	VPS26FJvuzlsomDkgyqJfDRHPq5gRdo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cqv8JRs4;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-7f7835f4478so22690776d6.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760713144; x=1761317944; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TTA2mSeVwafy9i2CstFmFNoFIIutQdKDJAn1493tDAM=;
        b=cqv8JRs4k3QKdC0/uiIVh8wr8OJk854rkAnTyd7oMXftnc1XincCQvjXu9mJsMSbay
         xTC/3k2LPkIyA/ASipWaav064RspjHOBrYWRJCej5kyyDAclSbnjkks0M1CJFYg3SJEe
         6aM9vUKG7LEqTVl8Lv5Mo7mAaF8PqCcPnaN/Xeyc0hmCzgvFAwDieZ1m3qmBWR/aj/Wf
         opnfGT26N/lzGWtXPlpAoGkq4JC/6nSi4tz0mASS6itGw0kBXpePomEIDKDl7AZCZjlT
         o2OGYNl1a2/cLSv2KSlelQ0PazV3nRygvNhK6EFBHqHBHzhZV3TZxm+uUzlcU/SAYCi5
         qQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760713144; x=1761317944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTA2mSeVwafy9i2CstFmFNoFIIutQdKDJAn1493tDAM=;
        b=lccnLnPmSRF7ojvRRmd5fKiq2SbOs1DJ7rsul0OoLY9ZOt1nKLdzEPEdcUuwmbyyVF
         FchuRYT4uBNU+G7ymX4G80rsqbFn4GuO8aARN793ONvKn8TVXkmy77GrLzUkJQYZlEsR
         Azt9D2SB/omEwG2wNhayvuq6TruZYaR4gbQIMxQy3uPr4/EiQNaadS7dd0JmM2Rt+5hs
         9imdYYkreZIXyfsUKNSHcrT75+uacHvcQ3D3i2VcrmAlDNJY7HSIPO2y89WnpMrFyj4H
         l0PsSttEILL9dXZoofH8HUnsOUyfweDhg3zhZ8ad8my6sdgja0XW7DhRE+8WTpB+WPlu
         cB1g==
X-Forwarded-Encrypted: i=1; AJvYcCXj5bIV49WT4Wvp/d3FRyw7NqNl2vpsieQ2M29lInGVxr8VL/lZo4hqYkYX/oP4XSCD4wEnw7Ne1Q==@kvack.org
X-Gm-Message-State: AOJu0YwJmtVjn2nOp3dSV3Z7XwA0W+PLRtKC/p6AR1IeyIR5ewII6ybi
	uQ71HJqDtMM2NVsTSfIe1qszk6X68VccD0b/FKjh1GDJUQRJnVsOT5Np0jgYeKB9kUU=
X-Gm-Gg: ASbGncsKtDq3guIHN0Vls+XCBeFtSnpr0tOMWb5nRtPpTjJ7FffjbUd7oSMwup7WFbz
	jgoKrAzCw9fpTDpi3UnFBWfmE9nijA3E5nMy5vgrgC4sQR79p1tIFbJ9EuSOPLDFemqw69D0lG7
	OwPt4gNxSwElpeNZ0jljMqdrGyZwk7uh2TLsvt3w/X58gh9VIdfxuyWTkMriRBJtf2EgxObN1Ed
	ZQwzgZf6Sezn6OgOZ/K3H11YtKR9gLtdSzNf92EM7G16lYbntrX623d9BVOyfZwtnKGwN51aDVj
	3DRLhmEPLxrJLeFuUQ2C/7CZTPYUs/y7nicP1e1NNRs8ynwkdGoOK49sSQK6l2uUqKIz0qUgMIW
	ATFxNCLkq84YG0uChWpkqGTRiEsh/hGuh/Oa3/qYDPU+KrCNyBV+B7jJp2w6BHJyjJJjpNwdKaA
	Ice+yiLSE03twZ1aER7eX/E9yT/r32QY6P20uHJf8gqemHIS6bDfBXmtQzf7SiJ49iwmR0Og==
X-Google-Smtp-Source: AGHT+IHd9zHjRIZf+Fc4DlDtuF/M9TYVelSUZFnURBj2UkXNmjzNYhJQmkX3naUgJtLXTWc6eW6+Zw==
X-Received: by 2002:ad4:5e88:0:b0:786:2d5e:fdf1 with SMTP id 6a1803df08f44-87c2054aef1mr69129376d6.2.1760713144231;
        Fri, 17 Oct 2025 07:59:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d028af525sm59946d6.51.2025.10.17.07.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:59:03 -0700 (PDT)
Date: Fri, 17 Oct 2025 10:59:01 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aPJZtQS4wJ1fkJq-@gourry-fedora-PF4VCD3F>
References: <20250925160058.00002645@huawei.com>
 <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
 <20250925162426.00007474@huawei.com>
 <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
 <20250925182308.00001be4@huawei.com>
 <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
 <aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
 <CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
 <aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
 <20251017153613.00004940@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017153613.00004940@huawei.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 9qbwagou1z68fintwyx1s3akedo315aj
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C76F4000A
X-HE-Tag: 1760713145-453209
X-HE-Meta: U2FsdGVkX1/4sgQj7uLX6hDxjPx9aBlro+2bD3Udo6ACiD9Wts2UlEmXr/z5tio2kneG+WBiEbghCQbB63XP2DHZpnh+RaHpYjQxsoG+uJzhFrmqZ/oIV+cO8izUUGmvz7uZOen1Ayr2hdB4e4tJU9K33XMaT4wbidznLmTYbJIN2M9SskVjumYEXJ4DgWDNy/hlcsQNESshw6x6a18y2+TablMXMBEXXq3V+F51jhAzlGFPOwZ0zjRlg1IrjLnemqeA4YS1bxJDdRO4r9bYcarPMJyLjx/Zlz+HwZRYcXS0kbD1xxV44uJkdeZcBQdNYph8Y/VR8H0Y8KHqb1ig3opY4VxoLd17+2XpDCFjFOydPjZ3H4UxDDCZI5KdKPptm/DB6NiRkZX8ibSxa58yMwWgI3STv9i3eiAmW66laFYkIL2Eq9nzrERbHXVyAxbqduzOY1ztQqE/r5gKBurMCpk/xSHDZz6SxBB4BO+i+hqF9LQkylzkJaN9blqoQwqusfuAz76p2E6qDcN3W3IlsjLclxy8AoY76Mrn41XJrsYBcg7HpHCjHYwQo0buBXj1XSElLPmxqFmy4Ij0z1Olzq9wvLYnjVUnaC7rPgaKkNlZS3EUXYeDfeMW/2Kf70mCZSy7U1a82Xtcf1HMDwYepNxB+Ibqs0WZq55Jf1jTNhC3YP4tek3700CIBsO/zE2KVF0n0gSw/Z6bpcL1uq3FYEuII3yis4knxImQw77+genHbh5SsXPZ5hZhXrw9p/+hBhgk31CZyTmiCZW9b+c2CcwlDKa9CX63KUL5cwXJtXSvLmLlq4InUqpxByT/OiTEjxzbr5GCxXYyWM+CvTK1EJIbV8RTLU00UCf7duLiUfT/Ob8gcd0LFfCjDOGi53tfBPMM6+uWuezAaxi7sRNK48RaRfC9ySnGQulqnqeta1BfdRfdjIFYYrOjf0ljfaxhqmCIit1V21FKfXhvA7q
 79mqmz7A
 KFDwhCFVWWwN/CpSz6mdMkH3pcg1Z8vODXpWe97vPU59VjP8oV+YffucY/xgVz5R8BAKn7rStAJzyIhugqqNeKBotf0xb/z+05aXx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 03:36:13PM +0100, Jonathan Cameron wrote:
> On Fri, 17 Oct 2025 10:15:57 -0400
> Gregory Price <gourry@gourry.net> wrote:
> > 
> > Essentially the platform needs to allow a single device to expose
> > multiple numa nodes based on different expected performance.  From
> > those ranges.  Then software needs to program the HDM decoders
> > appropriately.
> 
> It's a bit 'fuzzy' to justify but maybe (for CXL) a CFWMS flag (so CEDT
> as you mention) to say this host memory region may be backed by
> compressed memory?
>
> Might be able to justify it from spec point of view by arguing that
> compression is a QoS related characteristic. Always possible host
> hardware will want to handle it differently before it even hits the
> bus even if it's just a case throttling writing differently.
>

That's a Consortium discussion to have (and I am not of the
consortium :P), but yeah you could do it that way.

More generally could have a "Not-for-general-consumption bit" instead
of specifically a compressed bit.  Maybe both a "No-Consume" and a
"Special Node" bit would be useful separately.

Of course then platforms need to be made to understand all these:

"No-Consume" -> force EFI_MEMORY_SP or leave it reserved
"Special Node" -> allocate its own PXM / Provide discrete CFMWS

Naming obviously non-instructive here, may as well call them Nancy and
Bob bits.

> That then ends up in it's own NUMA node.  Whether we take on the
> splitting CFMWS entries into multiple NUMA nodes depending on what
> backing devices end up in them is something we kicked into the long
> grass originally, but that can definitely be revisited.  That
> doesn't matter for initial support of compressed memory though if
> we can do it via a seperate CXL Fixed Memory Window Structure (CFMWS)
> in CEDT.
>

This is the way I would initially approach it tbh - but i'm also not a
hardware/firmware person, so i don't know exactly what bits a device
would set to tell BIOS/EFI "Hey, give this chunk its own CFMWS", or if
that lies solely with BIOS/EFI.

~Gregory

