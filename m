Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BD1C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 18:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F926B0088; Tue, 28 Jul 2026 14:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27A86B008A; Tue, 28 Jul 2026 14:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9162D6B008C; Tue, 28 Jul 2026 14:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 569006B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:57:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2AD41204A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:57:19 +0000 (UTC)
X-FDA: 85039093398.10.DBB81D7
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id DEEDB12000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:57:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="knAp/RSr";
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785265037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APwCzgvOY9SQ7SXzciu0ITTDWBHpnumKI92Kxm1rTyY=;
	b=TQElrgOrbE4kdr362BVsRPzqJpo1BQFS/DkumYIBRJ4vlG5IrzmIlNoXKPo+/CHYd8Ym3p
	znW87jJQgqRveGBwUBEWKaoVTftIO1RqR5UMGZbkzCeLYHuAvYqfZIqwcmuwixokQE4s2M
	SP6BYBTgvThzXJ4a5Xl0jSN5ykddAuU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785265037;
	b=KBN1GiMLohLkSn2FLJY+sOFSKYQvtRIc1N7ffwF+Um/vXh90CAE5K/puu7jdh0ibqlo0OB
	AtRYE0sMtMNTb7qClHmvQkOrjmgzleiPMmiJSttOoYX0qP7qH49CU80MtYH/1mF09jm+Ql
	a+tkWk/hKogZaD/g+2gHmUgkntTiK6M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="knAp/RSr";
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e53581361so14342985a.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785265037; x=1785869837; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=APwCzgvOY9SQ7SXzciu0ITTDWBHpnumKI92Kxm1rTyY=;
        b=knAp/RSrr2afGIsQZ04SHnQDlAsM9zVAO+WL2cumaBElHCOSKZ828mMb0HteDeG5Mm
         J+iMdiZBH9lnLKOifiZ9ZCgLj0KK37DOXg+yBXgXAI1KnKMSfQzXqAJw7465DByu+Dme
         o7mL8Tjz7K/XQu3Xi52AI1SqIiMpL9V8Zujy+MBTKgaBk9QI2fk8fuic1CWbjOKRpfDt
         +TqDVuAi+62hc2lht83ngeYIU8wc9ajfE9QHapUepV4nUAS5nbhp0Ou8ik27r/uVreky
         HCswpE2tpOCNx86yZK6PqoyWKfdYaRTuzpBJXfWpq8fiyGH7VexTuNNSopFhilyjsixQ
         tJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785265037; x=1785869837;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=APwCzgvOY9SQ7SXzciu0ITTDWBHpnumKI92Kxm1rTyY=;
        b=SruFcv0ryshAqf5PmH6MYSMjG+V18unGeXRGgH5Ehuync8sSawn1nnr/RzR4v7jz01
         0qLGzkG3bZvPVviWjbZYujt2RCVTgF/bs1KDjVxFl2Kkt0fkBc5PKg2+Z71spcjFZp93
         2rs0bTfCYFnPF2EZj3rlYU3KndlCk9yENYfXcAbmGeznLluXvCWihE92+sjDQnE7wQ+o
         YDvaZxu/EHxk1tipWjVaq90UQ//ls5YQECEkZeS4k98zV/yxk3AW1YzyFIMXLio/4PsL
         24Uc8EQsXGjCCCKFPwLXOLht1HTWELGjsNWEbPzzHMzuipM8Au9NyrlRjadNpE45F9HF
         VcAA==
X-Forwarded-Encrypted: i=1; AHgh+RrZsGFBGf+inRIKIrTcCNfEEnPkHOmVJ3JF0aS3OoiKC5jfEeRPzPDADsdluZCzWDGSG1Y2q+Oe/g==@kvack.org
X-Gm-Message-State: AOJu0YwYvnQd41o3f5+s8v8SRG6SHsS6P4wqPOxs2wBrUqzXMZ+ceB6M
	5gRVtwg33MW/gf41YJZFLdQ0trZuJ1JbiijXd5yGoScMDF/+c1UgP/3vcNftE0x5mYQ=
X-Gm-Gg: AR+sD13ZtJVApvoFSPxi5tgKunVADp2Nxls7SAs++6d1UaK7wD332eWtldWTKEpGXGQ
	7daD410xGLLfIN/xtTva89+pmfp01MWJp7cd3bVJcwn4z4LcgXFL6Typi06I5WIP0q7ROBz+ck/
	ol6S7ChSk6PHNLvgy+I3xXpyG0hGh841Abk8PXNox0kIM5QwlI7tZwATlZV3ZxTrhRtYW1aciLs
	gESLRbbSKC4pUBrT8QUGdyk/3xiJ2Plc1feJ72hAgBFjQHqa1J0shzLhvHNaWpuTQLqYmse1sid
	jAFNYJ9tOmNtskNWXGmQCaIHKwZb/KZYfwYBYHie47Rm5yW9HKBfyj6xICArjSjrE+ALFou0eA+
	tK96t7NauShCBDGzGih9Orzarfw7G24euPC97JjDjYDKkj7XE62mb8weZr4+87GOGucrq35Nbre
	N3ttQWvtixPi0AA0BnbPZL98Vf/KVizUEgxIZ1FRu5rylpu03PAv+3GrV99Q==
X-Received: by 2002:a05:620a:46a9:b0:92e:d7c7:7de9 with SMTP id af79cd13be357-933026bb4a7mr360163885a.8.1785265036887;
        Tue, 28 Jul 2026 11:57:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de6724a4sm904385185a.43.2026.07.28.11.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 11:57:16 -0700 (PDT)
Date: Tue, 28 Jul 2026 14:57:10 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com, mgorman@techsingularity.net, 
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com, 
	rientjes@google.com, sj@kernel.org, weixugc@google.com, ying.huang@linux.alibaba.com, 
	ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com, xuezhengchu@huawei.com, 
	yiannis@zptcorp.com, david@kernel.org, byungchul@sk.com, kinseyho@google.com, 
	joshua.hahnjy@gmail.com, yuanchu@google.com, balbirs@nvidia.com, alok.rathore@samsung.com, 
	shivankg@amd.com, donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <amj3jbvruEiHIZvi@gourry-fedora-PF4VCD3F>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
 <amjz7kIDuZH6gBx9@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amjz7kIDuZH6gBx9@casper.infradead.org>
X-Rspamd-Queue-Id: DEEDB12000E
X-Stat-Signature: 6sj9ir4bsdpfyr9xd78sd77ux918yoxa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785265037-568268
X-HE-Meta: U2FsdGVkX19czfBLGAbFXRUg5aNDLK7yS07XGQ0IFbnZ4wu+Fhnpe8lW7+8aciEBT24z9h8RoYNeoT7ZBXIPpX1ZB9qvJNg/048AiEEXcs15q3fIermWYvo1AYut3nUvwyw+2XtCQVrYdd9O3tcnnBQ8tgDqmvyqS7T0YjfR1z14tLc1Fb5/QV0rUdwNb8Lwk0Ymxptiyh8ppJhpJgiUZGu1EMU5DwYSubjPcDyJ5+UPGsV5eC32MIAGU0YWoFL6RSVDDiq5A7oa0jMq6nGTseyepJlGDaQ57wKd6gbNvPxuVxvUeDjWJSavcJABdeYPkbgAUoZxO8gOciKgOABPNDV/rdLVNETbrT5/acMIxmsnkeNYomjXN2F2kxzto57P4rJ9T08t5G2xroBlTrRiuWivHpgKn/Sa28xMalzdhl9F1p+8d8a2MCs9KxLp4aiVcF+YZicTuRQAKrzXeUPRu2ytwaZYXofA++kunSrRWFHNlQGUWH7GzEdBclT3hMXdE5zxdizeeYbar6dzXGeiqBSdEgdzSCoUpY8Gce/GVRteO73iqMjQcpymot0/ktLIGGBKyn9TN6Y6AcNtB9b2AFsrrca+zq8ZndPe6mKmAHuLJhoRFMXDhKGQEjhunsCAU+Qs33N29xOna3F62NJcVP+W8Ilf7RgFz1p7kF4mFGt7rXBLWMMrgpc6JMZQ5uLrE0DNjo4kCSye+TkzupkDdEnVxH+zaSdxAAE0sWKaF5xoqk021YtHu6mq+hhI62wgUtMjDPIwHxNl/FwE4BKVQsZ+KHtBaq16v9DNsyqjV2Ashm2NS9v9iJjmKlsCleOHNy+kUu0hVMto7c8Lw9dc/eodsSvWipmg4P3k45uPolGbbfUlS1PM4v9T1OxmymnksHHGKfpej6LPB1+jMjBwWwrQDg38jx9gzl9Z1sGPiTbtYF/IB4o2PI3KL0Spvz8kdTfMTw3CKseMU/9Iwr+
 sPcP76fY
 noU49pzHa/IIUE0D49XD5KuIIxaxe/24FVLNDIeik4LIaefLf7H0KVct8TOXZmWWFk/HDiaiXluao6iqS6tRnsWrQmYzsWt1EMOFLo+Ep/8lWWQeQO+KrQkk3Sfq7XzIQR2bj5624LhJ7WrAsg9E88bfr7b9S5Ly8xLdWqTiQljXVIuATwDGsG/Z3Wf24oS3Q/HC2ZeAdhNGpDbkgTUdViNTsa2E3pzKMeQqf+ybVKZiorNbVlQwuYQa35ekj0pt+yFk4aQWSr3Fzs11pdWykGya1Y8Wdcw1UV5GFMftl7bVlWcAqLbehY9FwkimRGDozf65Q9PqD+VZ2fHXLTVukGZIxUtRMKUNMb9pdED+SV0P9Wt2EN5XGAI98y3p2HR5afFBofrYu1HV67GZZ3gZXf0Q7iHdHil/drJOZL2l7a5XFt8Dbhp2ENlFxM0v0zLoHDtUbFenEiXNi4Wj4jwzJAy4QqcG3kbds0BMPTXH8ruv9sSLzn03gjYzlOAgvHz8gvClt2EIXYbGeq5DDlND07MBpFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 07:24:46PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 28, 2026 at 11:14:01AM -0700, Andrew Morton wrote:
> > On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> > 
> > > This patchset introduces pghot, a subsystem for hot page tracking and
> > > promotion.
> > 
> > Can DAMON be used to do this sort of thing adequately?
> > 
> > Thanks, I'll await review input on this.
> 
> I don't think we should do this.  I don't think it's a use-case that
> customers actually want; I think it's something CPU vendors think their
> customers want.  I've said this repeatedly over the months this patchset
> has been in development.  I say no.
>

I've been consistent about saying we (Meta) have been actively
interested in this work and helping to drive the design of it.

So it's not simply something born out of a CPU vendor think tank,
we're actively working on solving real problems with it.

I don't have data I can share now, but I think it's fair to wait
for that data before faith-merging this on the hopes it's impactful.
It does make it more difficult for us to do fleet-scale testing
without it being upstream, but we'll get something.

Tiered memory is being deployed aggressively [0] for considerable
value, and is here to stay - like it or not.

~Gregory

[0] https://jovans2.github.io/files/vistara_camera_ready.pdf

