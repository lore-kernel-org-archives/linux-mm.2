Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00C9606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=NmKxoPwv
Received: by kanga.kvack.org (Postfix)
	id 1AAA06B05C7; Thu, 29 Oct 2026 14:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C816B05CC; Thu, 29 Oct 2026 14:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A936B05D8; Thu, 29 Oct 2026 14:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7EB76B05C7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:52:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A47D1A051E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:52:55 +0000 (UTC)
X-FDA: 85376560710.11.6DB30B3
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7BE7E40008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:52:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NmKxoPwv;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793299973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPPto5KE/jC+RmkH+6jKlnfiz+VihZ+geh+WGRQD6SI=;
	b=lSjmH2VNc5QtdmwtjjMNGW+6fd5bfV9dFPlvZFbyttEPwUFNr+azMCpn9p1QmY7duhBvR/
	x9ZHpzibsj9M5CCTtREDa82b4B/0i8eUS7nWyHE7qvAPY8J3tB3i69lBTv+IYkxNQtS9nJ
	w8ne97R6MSzHmZ9mkiGPJkXAHLYRfmI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NmKxoPwv;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793299973;
	b=XDVNKm/afeQCbMIaLCpd/EAQVOTE6BFQN9WKKezNvNLmzANcVxDX9ykfiaEKGkVZrIcKwd
	9ewFlKm0cccOpyVxPVGKBuMAd5pJ3OCeWeEd0/A8yh1w5q5LVMCyqPReejQreQJX2Q4wIe
	rs4aX5/DOruXnG8VF9gAlCZKZNOxmWc=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f22a8515eso212007885a.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793299972; x=1793904772; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kPPto5KE/jC+RmkH+6jKlnfiz+VihZ+geh+WGRQD6SI=;
        b=NmKxoPwv+3Honwo8t0ABhzZDXR7cunyh1eSxS8qKEnEyPActzExSBYi+7LPItOy/qC
         6hXrzuRRszaGMISq/0aEgpv1JeKCamcsndybfLc+gO/9n2uOBJzROYljZlskvFfot1tz
         R0alNuNuIr71QXoTMj5lCNfYpzzlC6eyJdFmkHfADYyN19qlUADleUXW3vFer8cYUliw
         hzeQsEn0fP370eZeW4FWNGo2U1qGDsF7YhMF6zILNwyN7/xoCKhfgK5PR1PvyZiVNfeZ
         bvs1DOlnogj3hcgZ+lBbKGrPzQslBpCOQUiguri/4sLbXMu55t+vlVWjuL0QWUWxfgwD
         D3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793299972; x=1793904772;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kPPto5KE/jC+RmkH+6jKlnfiz+VihZ+geh+WGRQD6SI=;
        b=XVlLp2RTgzHSibDB0Dc+zH027gk+mutKESPpsklVr8CAmkcXthfDNyEcBA5CRDZAha
         dnzmf1Uoq532k1BxJAq2Ffp/mZ1/a99cUAiLjxTp5TijBb3ylJ7as7ZSHIYjG3Xtdlwz
         YHZy1IwvQL/nkAx3ZRYgYjCEGjCeC2ybmivuSpYzfAb0j8iJ5Pf4tnPcewMmSrYpPPqx
         90RouyBgAsZLWpOKQf761alyMCaZw48IVMLe4UK+FDQqgGOy+kd0s4/iK/IJhrfBVwKf
         of7Ypd2dipOK10uDqxdu6Hpnmm+Qhf6NX4eaf78Yiz9IyZkwmGXETeMLHcPLGaWKnucD
         YZzQ==
X-Gm-Message-State: AFq9FYI/mLAdcHZQUhWuBE25kWyejeDyaLjMzEfBBnwLZ453S2Rejdyb
	OsVAYiooBbzHV/j5Y8KiQ/DVsEEF2EZcZIbrA5mBE5nulveUr+W7vCg6XZIJM03GU8Q=
X-Gm-Gg: AYBFou397IjX0updAAIWiZ0gUkhYJyx3XXOkwL3QSSEbH/ZeGQeBUI+orfaPIyulT0/
	rgEnnrypWRLU/h8+Z1wlOpOhC2wxQwTM0X+boCQeh5cvT9cMVuxY3Arc+8bK1cx0Rs/Q1cTw0VT
	3fUs7dxkV0HjrrBW2DHLpof8CA69Np0NBMCM+WF1bhbETC97SgvJexQWEFisZ45dNw1AjpFdWJl
	2V7kun2rhrHDkMB1SYpoYCOCCuIEIPsY6Ig+LiQYPZc+JlVg622BqjLtZd7WDNYFxWNhF/vTFBt
	BllBqqFwo1JbTQjRhd6FnBusfCrGn4HJhCi6X90DdSTgLGtDmt53K0gRkj9ewnm90FtVcxHWbYG
	te0U+VusdSyHGmhVvq1cnNnt34rYpoCPH3jH//ThG3dphsME2xjJ8WEP/v0csw+baCFoZT0xgwm
	gr/vQS9ZS0GdSIbxcSjuIux69vQKiR9iiUfZRf0TXnbYmkgwENtNQajPaxYh27zJtONQ45bG+be
	FkJIxuZSArWlXkwObtkDISKz0Wgyaco7Ggv//euZ1lWXs1p2OAlNLk2ozEwGO6stZT84fZnXi/7
	1aQGyrX8wNzYdJfGNSBunuUEXIFTur6H2EcBV0FWtk9x/seYtVkuOQ/QFoLIl17sa30qOpRZecW
	9
X-Received: by 2002:a05:620a:2686:b0:93f:5f83:2cbb with SMTP id af79cd13be357-94421581847mr21461385a.7.1793299972404;
        Thu, 29 Oct 2026 11:52:52 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca31581acsm3343856d6.36.2026.10.29.11.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 11:52:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 0/8] mm: fix allocator races with memory hotplug
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
 akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, ljs@kernel.org, 
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, 
 mgorman@techsingularity.net, anshuman.khandual@arm.com
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
Date: Thu, 29 Oct 2026 14:52:50 -0400
Message-Id: <179329997091.2127828.9582419476069377621.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 7BE7E40008
X-Rspam-User: 
X-Stat-Signature: c8ntpeqg83xfikmb395u9nputjcew39c
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793299973-856144
X-HE-Meta: U2FsdGVkX19V0hkxfTNrJRUGySLzI00rysftZJsC3u6xGSxdEiFcdi44KdyZhYg13rzbI5Ygx2+HPo66khSTPc3Q30q22n7952afuJmLKXiIcnjJEhvIGq4v+EyUEZbvakgNS35y7gaBnUUjRayW8qTL51vOVdaD16Y/rKFLfxQcqvqTZNqoo/CZRAzgKKk2TXCZnOTi1ZmfhQcJ+P2QLzmDcptS9d0NcqBgbii5kILdPrQhKuuOeZ0xKAQSy1QcEa+9DVMXe70ujd7wflVvxCllyR0nWLUelLow6wPVQJl9wkEn9WnbU5QR5jWwIKV0n9lTZ1iugZBl7ytcAI/M5uiavLCNN0LbRU/h2CaImvz/4enHA9BGbsJBo4ClFBxpOI6Pn/WVhYtuOwn7FxHf5FzHo6laP/PKoq4XVOliAZI+kilPWDIOBCsr2NRC1C3sEqCkT0dEAQNNdIavB65DgSUkRCs3yUBN8Pis7dvUyaq/22GKsfAwahfIA9Q7uQyPViBT2K81YrNsU14wlJiCXEggHjBRX+AENZWR2lv8ETvI//0CwCYCFnXKVPc544RRTXBPGBDSby6rigR+8yEsBsPEWSTwOofS6C0xuja96VL0HLKiCA0gMR5urIzsMpvQFMG32JA2VgbrXlEhakmYQE4Vwz4dco2JJ00ohZ8W3LiZUUCLkjTlFrawjyjZ027Wwkd1nE5h4sLC2Omz3LnjZ+4k4mRKIVSn/g7e4jcHhMXxsv1J7t3eTc/iEXyPBQr20IW2qNzgWqxfrA2CGL4WuoOFyAl0HvyVKhvi1zMc23hkFDRiwIrarIqiVX82/2t0zN/dIYmNiNBmMDnno1hiivbK6wbkK2oFlE2ACWNM7YkXK3k8ZVX+Z0LJjpLiHpblw9d8W0nMTwK5J5W+DDVawHUgbrl0T6JEQPOSkX8mwhNMOAupEGy1PB8Ie4CacPtK453EQZNUL9Q5l4mKIqY
 xETEXQdo
 iHDfkG9zsBBWBd2xP0VnInu+n/4PNtfafiHkEjh3j/5x9Ray8chZQKLUGfhh7ewWgc4tdfePpjEYUPJZFf6OeazVgYTf0VLbwtouggeAs4ty/2sdngsW91ptoxu93Z9qarRFqdOXOrA0GIPnjGiRu9q7c5aq7xT+94iNqc1bdeR+QFx6NEf/ltuwv1xeoYctc25PA0qIlf/CuJFn1Ut4P2mR+qTyTUxlhJyU9ogEK8T/bmZuxhxoEBEeIl+5on1L7cGy57xFLqkKXrTPDN4l2S9gG6urHQlBm2v8MdMan1JzMqB8jJgzUaHMziMRMXkFyvQ61yKT61Xrg+nhJ3FdrVKGOdvTUGngEF5J34NSnG5VrTeV3Il5uKqr5Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 17:19 -0400, Gregory Price (Meta) wrote:
> Memory hotplug rebuilds zonelists in place while allocations walk them,
> and offlining an emptied zone frees pagesets the vmstat worker can still
> hold.  These eight fixes cover the walkers that crash, fail, or pick the
> wrong zone or node as a result.
>

Andrew/David - please don't pull this for now.

We're solving some cross-over between this series and Vlastimil's
set of fixes from anthropic:

https://lore.kernel.org/linux-mm/20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org/

Have discussed with Vlastimil, and i'm going to pull patches 4/9 and 5/9
from his series onto this series when i respin this for his updates.
That should keep the backport issues self-contained on this series.

-- 
~Gregory


