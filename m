Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C731C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355966B0088; Tue, 15 Sep 2026 12:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0E76B008C; Tue, 15 Sep 2026 12:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2DA6B0092; Tue, 15 Sep 2026 12:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E52866B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:01:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 699B71C26BF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:01:57 +0000 (UTC)
X-FDA: 85216462674.12.272B9F7
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf17.hostedemail.com (Postfix) with ESMTP id 820E240021
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:01:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="vDE1/uW9";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789488115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHorUh9PUsMTcz7XlBSNxIJi9xL/FsLVONo19kBkoF8=;
	b=o1ibNLJ3hNFrHfBtg8HvhUROG3Jv2a+mk2H2eqkFEHkBCcMpdAnpQY1rk21rwpEKlfSJSQ
	0wED25dfyUttm8HwakaXMiEJtJkHBJ9Iy2Bn0z2+56xf7rnlAdfa2FEip6eK/OR3BBYgyS
	jvxz+5TTr227Z2sXNkNj4jlsdJkdaNc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789488115;
	b=zqflxUVX3xGOD30hc6jh6K8yq8T/adwfTjY0/jaUgmDrOLkR14Ba/yCP2wD0V+L7Oa5LeZ
	aWCIBKbinMLSbKcuE5By9pPVi6+yC98sYu1RVv5XdbbPuy+GB4HRRN2dH4+OlKh8k+u9T0
	NwUen0InnDsu7tSfIsYKQ1q7+kTDsWk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="vDE1/uW9";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939ca12ab70so423482885a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789488114; x=1790092914; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cHorUh9PUsMTcz7XlBSNxIJi9xL/FsLVONo19kBkoF8=;
        b=vDE1/uW9lPNPas+Zs5mZ3FTSp2fDzpF7P/zbtQyLFqbij58i+sQZs2F1lR+X78HBuI
         M9Ok4HQxuCuIcztsgObKs0oRL24DklEefHWDxvFoIDmMRnaqdoVBLPfLuFSiNhc4SjUo
         EqgRb5ddiOp6FUlXvHo1KtCopacNMH0UD9Qg1NbsmfljBWHMk6uES34cQ3lkVZjCvJIH
         rwZooVxl+b+wJOajwY18ZGnX0p+u5oWdCKM885ZZ9/iYnn5q+lrGh6DX8WsKPXfrciaD
         kN9hI0k+ySKpdWOeifpeNLlJFiAMkX9L0KPWVee0l1T2F6xznUUuJhiz7gHoHeeGc0xT
         7bvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789488114; x=1790092914;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cHorUh9PUsMTcz7XlBSNxIJi9xL/FsLVONo19kBkoF8=;
        b=2uGjDjhHJCAkMWVsDDwVzOPKN1Y1XHkIPy28hFNRsVqbZ8sqZbY2sHZzTr/VcM2baF
         5ZeuX/7aW/5+V16HMhEB8zGa9ML67RrDkNTZLBxMFuEzCkD+WL24/mNSx1k45bSCSrrn
         jTtdQ0Al0VhB7O1ZFLoQ5Fgx4Nkga1tNll57v23UerVrvMS05zWe3BoJoH456GJP9s6C
         b+eLoLOT27dUpll4NnyXpptB+0jR73yCOl2/RWjaaz/AHzNj5qVWoOeXpWPFQuVPHzwG
         ZNQ9SRO7THlf6V4CmIK6kKCQuS1MjHeY1MDoQS4tp9KhAOPVuY/yTfSrGH0YhITxo/ei
         HU+g==
X-Forwarded-Encrypted: i=1; AKwUvByD1+eQz628HSslvDPX6Vm9LAgnPKjPk1hqbHF/+Xmri62KN1ckFQKXk3bOxidGEOOYQS3YpcAndA==@kvack.org
X-Gm-Message-State: AFuF++kyZQwI49wblhN5dz1+ODSdodu8Nn9L83bCNxXbhVvYB3pF+ItQ
	6FoatZBYMtIx2dvqN2QN+trTPpMgqpNY7m64FDt4qu48g2hMawuWhLhKXY5iWPETRl4wWtSWXxI
	VlM6L
X-Gm-Gg: AYBFou1c5s/kOVkc1E0AD58dZ3/vOXYfbhvpICUnlkk5/xmpZnRZGERE6PJ0rwZILht
	2H7AsRiN8Oe6e4vsY4z6shkFdRSWnk7kkr44/wQBT+hQdCbaigAZougFWDvGA0hrm5yHfPboOvb
	F429+/79z4Cv6y+lZd6JpHtfLQarrH28UN8IFZPZiXNimN5QRcyQ+dfNonita/d7IZrQ8Huk2g+
	9k0nR8VJELMkvmDzV1cXI7ovrR7oEfaX9VoZgssEIwBZbvzdug1wrQblGXOLq7KoN3sX+5+rIxO
	d78Jrl+Dk1FJ0EOYO0jRH9lx0GyEFaYggCW0rJPTzSDpLqZx3H/360l81gRIJbl7AGfZrIIZGDt
	Yrc1oH2YTZu8K1Wvb68I4P44WvvN07XqqUojQp3lFr6xOi1GRVUHvqsAVXkv9XVEQMngxTBuSOv
	KqIASR09viE+7uqNG8gnkyfHhn6oyc7jBgg8N4u/u3t3in4pS/98UNPjAce0AfTQbsLIBR8Kgvr
	oftOuqW6eQ4mJ7U4aW7DQw2sc9SYRltrK4Uq1X0szNaPH3ow6GebZY=
X-Received: by 2002:a05:620a:1994:b0:939:fbd5:af44 with SMTP id af79cd13be357-93a299fbf14mr1209615585a.32.1789488114441;
        Tue, 15 Sep 2026 09:01:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93a0414809bsm956311385a.45.2026.09.15.09.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 09:01:53 -0700 (PDT)
Date: Tue, 15 Sep 2026 12:01:51 -0400
From: Gregory Price <gourry@gourry.net>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Takahiro Itazuri <itazur@amazon.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	Roy Patrick <patrick.roy@linux.dev>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>, 
	Takahiro Itazuri <zulinx86@gmail.com>, cc-open-source@amazon.com
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <aqlpxa61SrzhWF1O@gourry-fedora-PF4VCD3F>
References: <CAO9r8zNJ3mSRf5YyRQYYW-eM2eiFvQMXW4Rh0cT=31jsKZpuSQ@mail.gmail.com>
 <20260903072625.62694-2-itazur@amazon.com>
 <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 820E240021
X-Stat-Signature: wgcx1f57o9zgmsy4fy8j8g3gjpniiwx3
X-Rspam-User: 
X-HE-Tag: 1789488115-700746
X-HE-Meta: U2FsdGVkX187XvCjlfNXyhk1uT8hgrkzdkVBfhnyFMa7cDrEOZyOL5BjsU/OUHCLwY1RIIvKD8C6t+/UxRmRsmjr0/7rIozX/as9XqhTOCwjYQ27RcUsFllILVWEppM4g/uprCEjjAEYgGzWFczAodrqx/cZTJF3L/dD2o98a+ufh3w5dS9DogiJvxdUVQpxTp5ctzLruC3aw12oslSgAb5EhwXYm9qIJOVHVn4m2ExB8En7npdkEAyhXc26fpT9EtExCNWsykmpfALpUTh4MtISneveNhy3SY9iSNP1x8Ju9q0hkVUZ8Kmx1VyrqkxmGZN/v5ZNfMrbJPD+uv2k+vHZ9lU8A7K18JUvhuE76wFtCqbZNBykO6Iy34UUtpkiAlWm2cTN/1FuCiptxD8x3HIdbQlh0bgWZ5sUcWDHMfy376J1y8SqpZ7gQi3O7Fr+0AkRok77E25HMpdo2G6+J6IqsqBswQokqits/OalpVPEn9lE4/sYDW3stXXPg/HHHMniET1vuWZu54X1lcXOUfN8m/uGwfgSyFTcFg3HdmQKDAOLYeuejSaY3+aHU7VcybQaWXBL+vMkKlYYk3yLJHsL6mVGCCwjJjZXX3LaHdmnJTkO/cDllalPmjvSpso48p6lwUMVos58gRZ37AejI2gvqiToul18eHkUZ0OX36VNw+xmTAdw7N6xhte0C76Pb+3lK2Qs1mDXGnOKYzLPMFUKePtRk1/o/VbZv9fDW4shN4iGYgX4jW/xrmNs/JCve/OisMjAA6R9jJvX4ACtEfV3FhWiq3vdNlXpYoJoQTOcreO3VSto3GRBCjOE9ExaaLfXI0PYsKm1XX2o7OnwgmGyyiyigWFBdldfDpuRfaYedJohxYCG8VbDXoUiACgEtm87dR3AoKyFIE2DsXEH/J7GwJiX6GT0dq5aqAQt7dZeKv9VSZDHD1SoVNDdmjan3guOSQJq+kClrei7SFw
 LfCR9m9V
 kxMzmSp5HA6ulZv4Owd75lKApcSXB547fJR7xlwj4h3l/Q3b4VPwF9ZxK5MUdHSOMqcsyqvJ6pzpy7AIQsfirxSxHUL7yQHd+aN6f87TQS28UK0rRces4+CBujNzyqcl1Sf4jn9dbpbMmsMO15OqGWQmAsuGHnXxTUyKk56bKPxpmsqzZQ+iR+eV28Zu7WPm+OKzBCW+WNyHY5Rwoh+kDW92UqLFs/QcrWCO4GZKO30QcKIcFF08L0iu7xSrwdc/0Dit4PhnyBq+Cy2w4ROrpiAzWp1EguVwey0GVnYGgrYR46GQmNYnzUaqr6qaIW6dN+UdXXPMVbUUFZBz9pocw5FvsF+IjhKbtwuuELDjDHgIPHsvflUYymH9KLfpVqKf4MUL79zuEd9ICBBCrt1XE1qUtRjmAKBTVhgM+v6YUlrCJyl6QYPHDOgHTgDzCPVKczr26G/FfPnZTPQg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 07:06:02AM -0700, Yosry Ahmed wrote:
> > As far as I know, Brendan is no longer at Google.  I do not know whether
> > he plans to continue the ALLOC_UNMAPPED / mermap work, or whether someone
> > else at Google has taken it over.
> 
> I am currently working on a new version of the ALLOC_UNMAPPED series,
> I am hoping to send something out soon.
> 

Hi Yosry,

I've been trying to pull just the alloc_flags extensions (bulk and folio
allocator API extensions) out of this set and my private-node work.

I was taking another browse to make sure I didn't miss anything.
I just saw this, and noticed i should have probably been cc'ing you
here instead of Brendan:

https://lore.kernel.org/linux-mm/20260914155115.439742-1-gourry@gourry.net/

Do you have any concerns with me trying to pull this plumbing out ahead?
Trying my best not to cause annoying conflicts.

~Gregory

---

as an example, this series commit 20/26 reduces in size to the below if
the plumbing it pulled out ahead:


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2e079fa3a729..bb43568bb468 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5192,7 +5192,16 @@ static __always_inline bool prepare_alloc_flags(gfp_t *gfp, unsigned int order,
                return false;

        *prepared_alloc_flags = alloc_flags;
-       *fastpath_alloc_flags = alloc_flags;
+
+       /*
+        * The caller may be atomic if it disallows direct reclaim or requests
+        * lockless allocation. Determine this before gfp_allowed_mask can clear
+        * __GFP_DIRECT_RECLAIM.
+        */
+       if ((alloc_flags & ALLOC_NOLOCK) ||
+           !(*gfp & __GFP_DIRECT_RECLAIM))
+               *prepared_alloc_flags |= ALLOC_NOBLOCK;
+       *fastpath_alloc_flags = *prepared_alloc_flags;

        if (alloc_flags & ALLOC_NOLOCK) {
                /* Certain other flags could be supported later if needed. */
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b10f5422b6bc..863074319c2a 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -56,6 +56,7 @@
  * alloc_tag_sub_check().
  */
 #define ALLOC_NO_CODETAG       0x1000
+#define ALLOC_NOBLOCK         0x4000 /* Caller may be atomic */

 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)


