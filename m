Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30447606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ey2bJUPm
Received: by kanga.kvack.org (Postfix)
	id 47AA16B0790; Wed, 21 Oct 2026 16:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B146B0792; Wed, 21 Oct 2026 16:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340886B0793; Wed, 21 Oct 2026 16:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3ED6B0790
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:19:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90AF6A06A5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:19:03 +0000 (UTC)
X-FDA: 85347747366.04.6C162ED
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id C011A40005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:19:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ey2bJUPm;
	spf=pass (imf27.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792613941;
	b=5/5iU0tqF1DDkRQ9z1D4NNGcJvyhNm1WV8JqwGj3CbyW7UgqANiV3V8389k49oDm12Ozgi
	HyWgL4cP8xqPUs7qN6pXPaBzYl7qQfJtU3jEJqeHTL6Oio++3XABmDCTlya5zBl0gCgNAo
	G703hGoqO7uqjzfTmcysgJglpKQx+hY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ey2bJUPm;
	spf=pass (imf27.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792613941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7A3Qu4FeRo1KfTu4t3Hb9gLExSWYXnRTXONAqoE3Ds=;
	b=sFjFdL3QpdS4SaNUmebU8W4XNAr3aG8rBGUpPqOFuTcFtQhlrV2SFNHNi2QcArnw1KiTUu
	ZmBGu+AKxHjq18WkjABGxX/otAqZnI+nRJsiIXBx8dUitm79kFhUWO+r9a89bJ3rS7OURc
	CTFjj/GT4sIYhNP++/QexarHW1eL3pU=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-35f036b17easo1091877eec.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792613941; x=1793218741; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A7A3Qu4FeRo1KfTu4t3Hb9gLExSWYXnRTXONAqoE3Ds=;
        b=Ey2bJUPmp9J9xBE7RNG32/xpBP6re9yDF9vohDsTeiE7XnAtli54NYqetplmlKFNrd
         B60DmCFyZsQFOMyzEFXJwRTj5njPBoCb/bOK1AffCYHhUX5rv4kEuxVcw9g+9w6QqW85
         BAs9txH6pKLR0NG45YEvyyjueb1bpZWOtmz2NA31WdPrMv4aF49etwFCwF+erzI2HILh
         bq01SJBOyaSfLq3vB6PwGzQNSO9oHhwRa05TmApHKxThJBkMXtMct/FrOfa4ymNw/PhL
         JxWMdedptZlrT6RJKbujyW3xPXlWuW179xEtMiFn0r67rtam0AJ3g3g1AhWHYbs12EhV
         YNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792613941; x=1793218741;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A7A3Qu4FeRo1KfTu4t3Hb9gLExSWYXnRTXONAqoE3Ds=;
        b=XzKiobpc7aavkXGuDc3xhQHgt2oD5cSyf6MV8AH0R1ckXlNCG/V5mI+K6BUvN22YwQ
         8lAld5zgl+9VKNzGP0F+v7zB2WNzcCEokWucsgsI/sdhhLzCuRfqXQWqFZAcq7AMniNt
         sEQP7zmiOdBWH1LN1Ynz0JLwLUXMM/7elgAuuCoUJuQX13yeJ4vgTMb57W8fjVq6FrXF
         HiWa8E5FOlTd0doJTII93yweRLsz9avVeBjqiwJhnlyGK4aJCVj37l7Oev4OFZYr+0uK
         qvwI9OIITaOOkVMcjnuGfHVqr8gCOWiGfESmWIQ3GfZl47z3v+Blp14CXJXEL3uuPG3m
         E8/Q==
X-Forwarded-Encrypted: i=1; AKwUvByhC64r1yLk8qGiEORJvOZevq6yECWkOzy9VlBhHI5mIcMttjsOAtoUP9cyRHHOWrntA6LknkQJFg==@kvack.org
X-Gm-Message-State: AFq9FYKNIdIojI7gaRNG6bZbH/dx0cEr2KnbfZIkHFPmrYmDh6ZTfBVs
	4L8EwZDjhiZ+gWlPC8F5N8bpR4M1MlOHBoJz4uai/fHfAoc9E+yrdOyu
X-Gm-Gg: AYBFou2L9bM2pHEWJlw/ZXbqRmlxyeK/JHcSkjA3+ois4eNw1cp3gtB0//9xwF6306j
	zY5C1zFZ29Z5ocNBe6oTMyPdCYestRlOLnn/wCSz36MUP8iQZGlkjBaS+wJIRjAp4EFfoKMunaG
	dNkVYF/4ObQ2dOd1JmmaEYQrt0836VUIBNDrE4gZNBkNYhIbrM6S84XvEQsiEms1MHc90j43BT9
	mBSDGQdYA1N9su3TAR7CM+tUjFglb+Z9BzUpNINZP133Ee16yVRzGnb2FYWQ13s0TFrT19REIbe
	yuc+9WT+riHOOyS7e5QQ1FCQvzx6PNgfYmuj6FUkO5SY4X1MKHFisdWH4DswR/Bw7WoNS3I5ERR
	nBUSyS+ZJ2sv/L4ZFI52ltcxBIEydDlecBvG/qYAkk10XoL5eY9zjKMzOLtlWnM7n8NauNlBjDV
	lEbVoQITuzmevs234yzQ4dqea8LGVs0WyfRPd5u7/hl2C987pBb9DLXT+OoM/iQ2IFEQv+JQPS7
	S6gHC/Tvs4Zwlsp98kUBDRcZQkhAdJYwcybPHqeXIjM5hup+zOhDB9jIM4AHYMS
X-Received: by 2002:a05:7022:e1d:b0:141:4c37:a212 with SMTP id a92af1059eb24-190a051dd9amr5401751c88.2.1792613940370;
        Wed, 21 Oct 2026 13:19:00 -0700 (PDT)
Received: from localhost ([2409:4062:21d:8dc5:7fa7:1adf:a854:c40c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903e4f2eacsm7986001c88.23.2026.10.21.13.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 13:18:59 -0700 (PDT)
Date: Thu, 22 Oct 2026 01:48:55 +0530
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>, Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>, Richard Cheng <icheng@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>, Harry Yoo <harry@kernel.org>
Subject: Re: [RFC PATCH 0/5] cxl, mm: Keep device-reported poison out of the
 page allocator
Message-ID: <atkeL1aBD9p5hQgN@acer-nitro-anv15-41>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <ata_pfACXdlQuM_e@aschofie-mobl2.lan>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ata_pfACXdlQuM_e@aschofie-mobl2.lan>
X-Rspam-User: 
X-Rspamd-Queue-Id: C011A40005
X-Stat-Signature: 4mexbp46xs9hpktn43axs6p3np6f84sp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792613941-936273
X-HE-Meta: U2FsdGVkX1+Lpv3/uGeQiOQiPLH2KQgSQg+dXSksQJBoA5q+rmYYQlgJ8pdDczaqNQEkPEe/RKC/pQm76NNvEYigP3iKMrZywuQu+tqaNlem57NSeabdTxndO1ruDiFkSy+qcvDOvcNekrdylGIiUcIfJtEmf0UFz6eUV6JEICuBNAFJnBhIIvanAfSpSuEE1W0QpR1rwcRF2QwdU5b4OMY2gMWEAuGItMTHRDGFUB4RUHg77/p5FdTAYh7App59wE+B2QQT9c8QQSnjdGiOLyiyXCYBrG9OcYSXzumaJ0zfWKguTNl67UKMrxnfJf61hrZmSPE3bRD6L+fJPySpNxN6dBZMeoOeDxkk0r3N8jBmieTOxK1y3zchyiH82KP2m3LU0rq/QXOmTNmKSceKBRUJct0Gqxq+0nBA5nsx74r7XJOBoaee7OPWKBFrsJP57viWkFXu/sHdFW42OLq23d/9avy//1zbW/nof6xifq2W9Fpg+YgxVQPbUUYA1nLrOG1kXMmxNpZe3fJVPAtA2B1kICQccmtbGge98pgrdW1Xlh5X3xfy5ou0mUr+oywP2izcTRBzSM1bcIcwez9JRQWA+mfqcjkJaUIZJKe/kmPdOorTINwHJJuAIZ0ko8aeySiW9Q8GMD8djNBR2fWQyrNa6m0MBvn+2ZmJrAyo7OfLJnERM9BhMxn5dn9H4WwVCMmsTCLQuneeaRvmrdEbRgZfLjHOl25OnNTBwQB6jaklJ7IZma0GfnnRVrEguSO+wDH5d+k6G2mWutCk/Zt3doH6Kvf3rd+FIEYU1RK98u0ui3xbKvhMYwCWjeEJTeAIyRj0VwiJw7MPfSI8CDzxbP85g27Bl7zRvJSauUefPT5u77YNrVHSKeVm5sH9Eelsby/Bl9arr2lk0cVQGN0cugIzjgYw0UNevOCcmF6yUv6PdO3+R2g9RaGhrcuFWDJGHNGy1qmI7dJccwN+OV1
 2PYA6c6+
 q9Giih0Gyy9y+eXC5KmpmgY1vUPfyJQnXMubfszlx6Yeyxs7PX7XpyCUg41MFkc8nCTu9G2lS6vK/2og8lQOnA1h33AmrLvOT+d2ChksL1q+1Fg0gTO9OprVBSEIzhCHmS6r9xzI+OopiCYIhHhfklZ4ry5E59knbwoB/iqHOkLlFc5ecPjAqE8rMWH7inwxSAdrwcina/Y+zUX8i9OtaVTEFv+EN3MDV8pfM9nnH/UfI2WlLOScNmWpk8w+PiBkebpLz5u4bVnaKzeMsv8CZL6ThDeVyXp1nZRqB6/BpqS/XPA/dCz7gBFi8XcVIEYY/9HVNiBXAVzTUaY/rvAX3/ECdizZULF6qIhexi58j7kCRst9hwnT9W5jszKN/oyiH7mdjsgNqx4gtDUiZNGHTANk/NloUI2IQuqZkXMPFnX8EzyOqRKjtWBUyx0EF5GomfswCvKCrDApRhr1K0u2/vur+hYSZDXd3VcZPPEfIYQbuhTfUjrM21EDzIpSHSdmj3DZtHIbJhcXLcpPhTdt+CLw1lA11xMQ6XGsd/SvEJW4mXZ0d+vecfuqbdAtUxHNvupx8N/HVD127JtKYnarkEEmVg+jCHW+Xv6PLYErWAjkNutM1932gdJTLGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 06:11:01PM -0700, Alison Schofield wrote:
> On Sat, Oct 10, 2026 at 09:50:08PM +0530, Shaikh Kamaluddin wrote:
> 
> snip
> 
> > 
> > Applies on next-20260908 plus [1] v5. The num_poisoned_pages_inc()
> > change agreed for v6 [2] does not touch these patches. Patches 1, 2 and
> > 5 touch only drivers/cxl; patches 3 and 4 touch mm.
> 
> Hi Shaikh,
> 
> Can you share a public branch with all this code in one place?
> 
> -- Alison
> 
> snip
> > 
> > 
> > base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
> > prerequisite-patch-id: fe9d44deb8ccc48c0311bc4131bdf733eb353b34
> > prerequisite-patch-id: 4cabe6adb37cd8c218bd43c97970bc65f313b671
> > prerequisite-patch-id: 52ad24bceedb9c03df167f10573166a1d97ba97d
> > prerequisite-patch-id: 44bfbc8aa3c4b19593f7b0d466fbc0cb99b99f76
> > prerequisite-patch-id: 2d344a5322ff07c7895a59d2425540a30e4e0630
> > prerequisite-patch-id: e776f306dcbdda3f6972187ad1e43a62c2754890
> > prerequisite-patch-id: 3ef887599e31ef973d6d9ca15d0462d55f5f0409
> > prerequisite-patch-id: a23fe88ab4529b6a6669a991e15cf1631311391c
> > prerequisite-patch-id: 111c69880ed0e148cdda285896c006e8d1fc98a8
> > -- 
> > 2.43.0
> > 

Hi Alison,

Here's a branch with everything in one place:
https://github.com/shaikhkamal/linux/tree/cxl-poison-rfc-Breno-v5

(top: 9e63fdb "cxl/region: Register device poison before exposing RAM")

It's next-20260908 + Breno's hwpoison-kho v5 + this 5-patch RFC,
matching what was posted.


Thanks,
Shaikh 

