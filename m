Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 354ADCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7228E005A; Fri, 17 Oct 2025 13:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780678E001F; Fri, 17 Oct 2025 13:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620C28E005A; Fri, 17 Oct 2025 13:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 47A118E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:28:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6D481A02AC
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:28:55 +0000 (UTC)
X-FDA: 84008291430.27.77DA4C6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B38140019
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:28:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZYj23XdT;
	spf=pass (imf01.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760722133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvKQ/17WNYzFeQtnqjZcX24DdJXumkbVdSqHG56jAyY=;
	b=ZyC8nTi4qCVHUTaQZy/vMfSqKni6qwZI6C5WPXmmRW9pClIPQcpA7UjugqwBi670s98GOg
	pdJc8wR1Xg7c3gV7rAnnWGinzY/R+7NwvySkkXQ+3educSjoUPf6uPwYf0Ud0145a2hgLx
	lmf8977ui6BfJ2h2ctAIjEogZw/n7nE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZYj23XdT;
	spf=pass (imf01.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760722133; a=rsa-sha256;
	cv=none;
	b=45buqe2Gxsl2S7EYSR4+P8t0xFUw0DoYxaCNMKiCcYXOOim6d/7pf55A3IVw3y1zPza1W1
	YPiiGL2PKyuG+DrQ9qteG9v1JFtHtr3Qu/O+bTZPe+ll0fkCNhNz8aJX6RurqtSA4yjJCZ
	Zk2Hzzocxjxq5lWgbhFAHOGZLGzUPZo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760722133; x=1792258133;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=SvKQ/17WNYzFeQtnqjZcX24DdJXumkbVdSqHG56jAyY=;
  b=ZYj23XdTeyH+gai4U4YKJpOt4gtMUg45bnsvBqp3I9XFc1sKk/BHtqCL
   8xZpvVZPRac5d+4DTw7/c6y/xqLqlt4rwkIEgYNQL7J5/7UsjQGNsCXyV
   ee7/AONfepqfrUBbYbjszoaNaJTWc9C6ssb9WPpL+wl+Da/yiCSSff+jq
   15XGrU5tzIbqYIc0KzuMcsLTMifFStvww+icBW9drKctO3th/vWKLZK97
   JN4J41WMrJGAyCbWIqE7V0Di2OkGjBfFEMhmsZaRQxRcR81Kt7UNsEwEy
   BwmHqttbzdGKuVz6u4AGI4vL+ZNGPMzWw2t9XQhe3DAlFf3DC0v9x+Y7K
   A==;
X-CSE-ConnectionGUID: cJ9IzfjoR4acxQRk1USn8A==
X-CSE-MsgGUID: jfLZlHTdT3yH3LGOipTlgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11585"; a="80383761"
X-IronPort-AV: E=Sophos;i="6.19,237,1754982000"; 
   d="scan'208";a="80383761"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 10:28:51 -0700
X-CSE-ConnectionGUID: 4dIFaWtDQWWjFKptpRyRCg==
X-CSE-MsgGUID: uUiANFI5Q9uSKDD5Q5s3wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,237,1754982000"; 
   d="scan'208";a="186807165"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.108.40]) ([10.125.108.40])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 10:28:51 -0700
Content-Type: multipart/mixed; boundary="------------GwXy19Mun0gf93RLFz0jKSy7"
Message-ID: <c3eee56a-7fe3-454c-878f-cff37467fb7e@intel.com>
Date: Fri, 17 Oct 2025 10:28:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
To: Jason Gunthorpe <jgg@nvidia.com>, Baolu Lu <baolu.lu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joerg Roedel
 <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Jiang, Dave" <dave.jiang@intel.com>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014174339.c7b7d2cfb9f60d225e4fe5ec@linux-foundation.org>
 <6b187b20-6017-4f85-93ac-529d5df33aa2@linux.intel.com>
 <ecee3200-c8e2-47ec-a219-c88e8e905b32@intel.com>
 <11cad2be-9402-4d45-8d2b-c92d8962edfc@linux.intel.com>
 <20251017140101.GM3901471@nvidia.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251017140101.GM3901471@nvidia.com>
X-Stat-Signature: kw5e6ttnjyyr339yosgnkp3knj9xcn51
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B38140019
X-HE-Tag: 1760722132-889681
X-HE-Meta: U2FsdGVkX18wGQxLza1xJUyI+EA7RejWYYGNMbEVlq4p3vEO2dswu/zAfUc8pj80JQSsAg9Trj9gAhmiYLlFtOSHRVeilGQVeWr1qfV4piTvdOrzYZURDqsgXmy3PbPRGo3xmVPVT0n2L2cuZxI1aL5584quUn5cbmUeiEefvi9vPpIvuqyrbp9ixTEKTK6oPcdA86rb8N0CY73kvG2/DBOR5Ilp0Pn7poIxbJT/MsdHdBEPXXYgP8Z1/aOJfwO44p7cN6dum71B/exTLDmQU9PBIokFKtf2MIypmacjo5YQuCG/b19rl2sK/0xNVxxgLgzteEtvtloQkzJr9gWZ4k/7VWA6sTFjwLGid94JGZivti09zMk3XdQ9rqQG2c6yvSlwaoO+md/JNpJpmDpCcYevujrulhZodjw690ze7tLtN2Nmt9+M608L97I80k6zoqVPHukz/F2175S3JHBewJrFsbbCxRc9fQGQ6+3leh8rMI33c4Zkh2mYUaKPiNNGPKRP9oLUsxtekUNoWc0REnjYskf3K1kEjcUx4tFi+pKJHLLo/hpbFvAKX+X6UA73NW48x49CYAzOP6kI+gpUojpOiCpdnHnUpIKmHzawfaj6P+ZXjl3210nGD7DZ0wj6ONQI9Qx7zge5yUa8X7yk3+tEewYtCoa8kvhLc3/WXEgdlQGX+CQS+PT6QbW8ODgdarL1AfS1JJmpME9Jk7O+wHNA0rkIVotyvtWQr5iPPJkNNwO7GOXMQ/Zfn1s9xUB0uuZzJGqtU2k/gDTP7Zf+wAAoFdhTFNiLwMpXjwGqU3NCwVCxWeGPFE8uFkHSEwwG96hSxC5cE9Hkwt70w00kSy410F7C40nPJhgak9yTsLdRlhYyuA+B78qOG0mpFbC1MbHvmSb+9Z9AsrQW5aIAHYhaaRBqYcSzlsp+/RJCQ+VHl6/AdMK3eJxxSgma+PCMgsqPOZ8RXbQJ8ID/LFE
 hKkJUV+3
 sNDnsj+R1TcR8zTBXBiF16wZv8BFX7vl2nH9MCyjdohGXEOrBruEokTBBnURn6jJvOQh17fFPPQJTV66iiu4LJrTWL5/2xhun6l0Dq/sEZIu8OKs/02UoHd+8fNMSzM7w28Ks2fR61S0+u+cKHWrWTRf/uqgEvbBjB8lESeWUDqubVGPBGzDq3nDgxnqSf2KAL2/IxlzY3ve50aIvPTb5k4ZUiKTJoiWUgoRrCdoZ6Eocz1b8E1n2W4VaoCq0CRk9LqT5RWvQbjN+k0T3PHtJ93JgXUjF/YP66KY+fvh5hQXY8DwjyBRyrbe00FmxM8yrRsOSEFqrHaJ94u8XDU+/SeNqcCiU2P/SVt1aW8oWnfG/2Y2tk4dpMkgDkh93sJyeGXMjTHkAKb1UQkG+P98ui5Ph0SGQGLn5wXojzI5qB9WcHB04aqE9L411+fz9IhQTWLs5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------GwXy19Mun0gf93RLFz0jKSy7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/25 07:01, Jason Gunthorpe wrote:
>>> The other alternative is to have arch_vmap_pmd_supported() return false
>>> when SVA is active, or maybe when it's supported on the platform.
>>>
>>> Either of those are 10-ish lines of code and easy to backport.
>> Hi iommu folks, any insights on this?
> IDK, the only SVA user on x86 I know is IDXD, so if you do the above
> plan you break IDXD in all stable kernels. Doesn't sound OK?

Vinicius, any thoughts on this?

I'm thinking that even messing with arch_vmap_pmd_supported() would be
suboptimal. The easiest thing is to just stick the attached patch in
stable kernels and disable SVA at compile time.

There just aren't enough SVA users out in the wild to justify more
complexity than this.
--------------GwXy19Mun0gf93RLFz0jKSy7
Content-Type: text/x-patch; charset=UTF-8; name="svm.patch"
Content-Disposition: attachment; filename="svm.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2VudHJ5L3ZzeXNjYWxsL3ZzeXNjYWxsXzY0LmMgYi9h
cmNoL3g4Ni9lbnRyeS92c3lzY2FsbC92c3lzY2FsbF82NC5jCmluZGV4IGM5MTAzYTZmYTA2
ZS4uMGIwZTAyODM5OTRmIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9lbnRyeS92c3lzY2FsbC92
c3lzY2FsbF82NC5jCisrKyBiL2FyY2gveDg2L2VudHJ5L3ZzeXNjYWxsL3ZzeXNjYWxsXzY0
LmMKQEAgLTEyNCw3ICsxMjQsOCBAQCBib29sIGVtdWxhdGVfdnN5c2NhbGwodW5zaWduZWQg
bG9uZyBlcnJvcl9jb2RlLAogCWlmICgoZXJyb3JfY29kZSAmIChYODZfUEZfV1JJVEUgfCBY
ODZfUEZfVVNFUikpICE9IFg4Nl9QRl9VU0VSKQogCQlyZXR1cm4gZmFsc2U7CiAKLQlpZiAo
IShlcnJvcl9jb2RlICYgWDg2X1BGX0lOU1RSKSkgeworCS8qIEF2b2lkIGVtdWxhdGlvbiB1
bmxlc3MgdXNlcnNwYWNlIHdhcyBleGVjdXRpbmcgZnJvbSB2c3lzY2FsbCBwYWdlOiAqLwor
CWlmIChhZGRyZXNzICE9IHJlZ3MtPmlwKSB7CiAJCS8qIEZhaWxlZCB2c3lzY2FsbCByZWFk
ICovCiAJCWlmICh2c3lzY2FsbF9tb2RlID09IEVNVUxBVEUpCiAJCQlyZXR1cm4gZmFsc2U7
CkBAIC0xMzYsMTMgKzEzNywxNiBAQCBib29sIGVtdWxhdGVfdnN5c2NhbGwodW5zaWduZWQg
bG9uZyBlcnJvcl9jb2RlLAogCQlyZXR1cm4gZmFsc2U7CiAJfQogCisKKwkvKiBYODZfUEZf
SU5TVFIgaXMgb25seSBzZXQgd2hlbiBOWCBpcyBzdXBwb3J0ZWQ6ICovCisJaWYgKGNwdV9m
ZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfTlgpKQorCQlXQVJOX09OX09OQ0UoIShlcnJv
cl9jb2RlICYgWDg2X1BGX0lOU1RSKSk7CisKIAkvKgogCSAqIE5vIHBvaW50IGluIGNoZWNr
aW5nIENTIC0tIHRoZSBvbmx5IHdheSB0byBnZXQgaGVyZSBpcyBhIHVzZXIgbW9kZQogCSAq
IHRyYXAgdG8gYSBoaWdoIGFkZHJlc3MsIHdoaWNoIG1lYW5zIHRoYXQgd2UncmUgaW4gNjQt
Yml0IHVzZXIgY29kZS4KIAkgKi8KIAotCVdBUk5fT05fT05DRShhZGRyZXNzICE9IHJlZ3Mt
PmlwKTsKLQogCWlmICh2c3lzY2FsbF9tb2RlID09IE5PTkUpIHsKIAkJd2Fybl9iYWRfdnN5
c2NhbGwoS0VSTl9JTkZPLCByZWdzLAogCQkJCSAgInZzeXNjYWxsIGF0dGVtcHRlZCB3aXRo
IHZzeXNjYWxsPW5vbmUiKTsKZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL3RsYi5jIGIvYXJj
aC94ODYvbW0vdGxiLmMKaW5kZXggMzlmODAxMTFlNmYxLi5lM2NlOWIwYjI0NDcgMTAwNjQ0
Ci0tLSBhL2FyY2gveDg2L21tL3RsYi5jCisrKyBiL2FyY2gveDg2L21tL3RsYi5jCkBAIC02
NjUsNiArNjY1LDcgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgbW1fbWFuZ2xlX3RpZl9zcGVj
X2JpdHMoc3RydWN0IHRhc2tfc3RydWN0ICpuZXh0KQogc3RhdGljIHZvaWQgY29uZF9taXRp
Z2F0aW9uKHN0cnVjdCB0YXNrX3N0cnVjdCAqbmV4dCkKIHsKIAl1bnNpZ25lZCBsb25nIHBy
ZXZfbW0sIG5leHRfbW07CisJYm9vbCB1c2Vyc3BhY2VfbmVlZHNfaWJwYiA9IGZhbHNlOwog
CiAJaWYgKCFuZXh0IHx8ICFuZXh0LT5tbSkKIAkJcmV0dXJuOwpAQCAtNzIyLDcgKzcyMyw3
IEBAIHN0YXRpYyB2b2lkIGNvbmRfbWl0aWdhdGlvbihzdHJ1Y3QgdGFza19zdHJ1Y3QgKm5l
eHQpCiAJCSAqLwogCQlpZiAobmV4dF9tbSAhPSBwcmV2X21tICYmCiAJCSAgICAobmV4dF9t
bSB8IHByZXZfbW0pICYgTEFTVF9VU0VSX01NX0lCUEIpCi0JCQlpbmRpcmVjdF9icmFuY2hf
cHJlZGljdGlvbl9iYXJyaWVyKCk7CisJCQl1c2Vyc3BhY2VfbmVlZHNfaWJwYiA9IHRydWU7
CiAJfQogCiAJaWYgKHN0YXRpY19icmFuY2hfdW5saWtlbHkoJnN3aXRjaF9tbV9hbHdheXNf
aWJwYikpIHsKQEAgLTczMiw5ICs3MzMsMTEgQEAgc3RhdGljIHZvaWQgY29uZF9taXRpZ2F0
aW9uKHN0cnVjdCB0YXNrX3N0cnVjdCAqbmV4dCkKIAkJICogbGFzdCBvbiB0aGlzIENQVS4K
IAkJICovCiAJCWlmICgocHJldl9tbSAmIH5MQVNUX1VTRVJfTU1fU1BFQ19NQVNLKSAhPSAo
dW5zaWduZWQgbG9uZyluZXh0LT5tbSkKLQkJCWluZGlyZWN0X2JyYW5jaF9wcmVkaWN0aW9u
X2JhcnJpZXIoKTsKKwkJCXVzZXJzcGFjZV9uZWVkc19pYnBiID0gdHJ1ZTsKIAl9CiAKKwl0
aGlzX2NwdV93cml0ZSh4ODZfaWJwYl9leGl0X3RvX3VzZXIsIHVzZXJzcGFjZV9uZWVkc19p
YnBiKTsKKwogCWlmIChzdGF0aWNfYnJhbmNoX3VubGlrZWx5KCZzd2l0Y2hfbW1fY29uZF9s
MWRfZmx1c2gpKSB7CiAJCS8qCiAJCSAqIEZsdXNoIEwxRCB3aGVuIHRoZSBvdXRnb2luZyB0
YXNrIHJlcXVlc3RlZCBpdCBhbmQvb3IKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50
ZWwvS2NvbmZpZyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvS2NvbmZpZwppbmRleCBmMmY1Mzhj
NzA2NTAuLmE1ZDY2YmZkOWU1MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9pb21tdS9pbnRlbC9L
Y29uZmlnCisrKyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvS2NvbmZpZwpAQCAtNDgsNyArNDgs
MTAgQEAgY29uZmlnIElOVEVMX0lPTU1VX0RFQlVHRlMKIAogY29uZmlnIElOVEVMX0lPTU1V
X1NWTQogCWJvb2wgIlN1cHBvcnQgZm9yIFNoYXJlZCBWaXJ0dWFsIE1lbW9yeSB3aXRoIElu
dGVsIElPTU1VIgotCWRlcGVuZHMgb24gWDg2XzY0CisJIyBUaGUga2VybmVsIGRvZXMgbm90
IGludmFsaWRhdGUgSU9UTEIgZW50cmllcyB3aGVuIGZyZWVpbmcKKwkjIGtlcm5lbCBwYWdl
IHRhYmxlcy4gVGhpcyBjYW4gbGVhZCB0byBJT01NVXMgd2Fsa2luZyAoYW5kCisJIyB3cml0
aW5nIHRvKSBDUFUgcGFnZSB0YWJsZXMgYWZ0ZXIgdGhleSBhcmUgZnJlZWQuCisJZGVwZW5k
cyBvbiBCUk9LRU4KIAlzZWxlY3QgTU1VX05PVElGSUVSCiAJc2VsZWN0IElPTU1VX1NWQQog
CWhlbHAK

--------------GwXy19Mun0gf93RLFz0jKSy7--

