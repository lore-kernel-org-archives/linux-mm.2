Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD08AECD6E8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 20:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1505C6B0005; Wed, 11 Feb 2026 15:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDC16B0088; Wed, 11 Feb 2026 15:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17F56B0089; Wed, 11 Feb 2026 15:07:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE2F56B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:07:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E99C8BEF0
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:07:22 +0000 (UTC)
X-FDA: 84433260324.09.1D323C1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33371180038
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:07:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XNS48cTp;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770840440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sqBidFRQ+ST/YGTo9ZDnULRr+F+RZE96QEIcss1eeHk=;
	b=X4Ys2KcII9tt5Ucy7p3lMArVOEh35NWtJyb/GG3j7w0vv/fHSRyFg9c1mOZ3L7l1gplzz0
	kirvi4J56H6ArEs5pPs2pD10CJq9LP4SaLtbvDOSONxMQrO41yTqOq9DfVgZ0pKmMquQMm
	MO3UrkWM2JydgEWWRLMyX3b2he7n4Ro=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XNS48cTp;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770840440; a=rsa-sha256;
	cv=none;
	b=CGOq5lqQrf3kg5YyiAAWdy++gzu2NWmFY1pX2IZICVe4bNMv7wxJVYopIgC3aNsvdnZqEj
	hco6AtEy6KLoH7VOHQJ0BBGsDlQ9KP25vv/5VBEB/6zsihhZ/WKmLYdzG38hG8XNdFXDSA
	CkVgMk8fbgY/9gMKls2Y2ncZR8105PE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770840439; x=1802376439;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sqBidFRQ+ST/YGTo9ZDnULRr+F+RZE96QEIcss1eeHk=;
  b=XNS48cTpgOl+BcQ/Yxhm4prgofKolB99StFbPxc+NRGqHUqS/n3VojS1
   wG2oHXDLDMAaR2twRG9+oLJ67kLg4rHlSTPj9G+lXa7fJCSH6qJklDMQk
   9nb19LJI2sS1FtSRhnurMJtUbzEkb3ppqAAPkwS21zAUCCS7QRfW9IlEx
   bKVmoZKAhdIGk92//Viq1VqwzXQdYYB1jzoVeo2xkm3THXSJ1mCSM5WSc
   GR3fndnHg7idmrQN5T583wG3+U/188JWiUr4Eo/XRubWugVSHOeV4TnUE
   ZYWJn/9DNVtHWLhpZZirOrVPwGB0t8yHyyV5wzLw0eWWCHJr+dag9M4EB
   A==;
X-CSE-ConnectionGUID: NXZbqXoQQISOyo2b2wfKOg==
X-CSE-MsgGUID: AMKU4CbWRX2pl8uGM0KZrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="82324695"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="82324695"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 12:07:07 -0800
X-CSE-ConnectionGUID: 3tI4nEuBS5OPg9kHE/5ToQ==
X-CSE-MsgGUID: 4LUtJmqFQEmxSs+x2ppV7Q==
X-ExtLoop1: 1
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.146]) ([10.125.108.146])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 12:07:06 -0800
Message-ID: <29599d4e-c2c7-4f40-a444-28dcc3768ce4@intel.com>
Date: Wed, 11 Feb 2026 12:07:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] x86/mm/pat: Convert pmd code to use ptdescs
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-4-vishal.moola@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260211195233.368497-4-vishal.moola@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 33371180038
X-Stat-Signature: mfq7ytbnejqbq4x3nqwbm5f58wm3yoik
X-Rspam-User: 
X-HE-Tag: 1770840427-26815
X-HE-Meta: U2FsdGVkX1+oTV6x282VQTSAPOzqWRZSZUOEDvwJBciKLBkNAAJCWx8X/eDts/sAo8ma0NeljSEPb6IsTEKNo4jlIaTbYXnNdRqfnlhjqPmoUWLGFsBYL3DgK+aXC4pMb1ZpfVZN/Q4YmMGPAqimwoqN3oX4wPRJQRx+fvTPnqJJocgnRywO/LYO/oZWGPqCSl+uDZNMjRmohgeMpo7+u9ztQPImiPeSDCWqbU9zVPcxqDzJrGn0EQ+fXF61sToHslpRMVr7IQj/PgL3yMtjMQzwQ9yVmZMD6enREqwJ7ume+3qzrAXuS+nNAXtKBuX9RRYTa/4I++rCQlRQmGSe8cy0oXq30vxhHAfsekOArqs2ou3X6eZL7CzvTKEeVADgYkhHcB/a0rhnbsz8a25L8RmO/ah1tA5DTdLRXoed4c0K0r2XE2T36jecPCb0UnlgVRgby/vR78mn1ALbeq8Hi3jpt06Z8ANd8P5PbevebWJGoA/qZn3Ktbz1KxksS2oTIZTmzRQbMqtSHNbuGb8xXX+SKV5YWzTHHMST2b2lHpEORmV2ki7LMmQPqwwC+YAI60kvISuLXEmJLGOcbwgIgC+qIRCFWH1IWDZRsO2bxe1oTiZwUaMUtdBHVS+1Jtpcx20TrotdCvC/T6Q89Q3veGXhgTJpSNnhsdByqN30vIofVyeD4UPpkK35gTBOKSDgwq9jQE3df/SD43NckKi/k3BkASE54A19cn+f44+78ow47i5fwke1W8FUxcGvNtknPsXGdxzHKrdQihnrNnYANCSLpZAD4lLZpvEpB5AYHksPVOpeVetfn2dwHgcD/2+oI15QtAWswt+iyW5eTCxX+USnQJ7C8GNxn58kImjLMO6DIuez7OmAY22Ba2aJouYaF2DMQrL+sKB3lGCYfNect78W5K+nm/lMq+HxTUfYrzWIfVRpKuKKwS+wFIVGl1ALY3RF2mrfvnilrvvugT7
 fMYsn1PN
 CxbsrFFiJH7PuvzbNea9Du8tlqjpf/lp9PCw7lx2H+6OofOAjKQTh6PdQ0F9PfA+tcT1YBWv24pzWz6JCYdOBxJKJ1IABnym/wSyx3PhDZqWeO/RDfJdByYBxCWw4PI7kP1K4ZwOENIXljtITdFPQQQR2OZW11BfDJAo6MtB3usVbkiR25gVpTVDroOEFa1q0QDB27XhAXYcadUclcIRFq6O50Qt6k3vgv11ScR30Y4/tGXQTX5HFOt1OAYMxHXbt7Zxwisly1Xdh3TLe8b0/x9yBhO1GcKcYgbmtX7KMFSOcOpo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:52, Vishal Moola (Oracle) wrote:
> Also, rename *_pmd_page() functions to *_pmd(). Rename them now to avoid
> any confusion later. Eventually these allocations will be backed by a
> ptdesc not a page, but that's not important to callers either.

So, pages are still a thing, whether the API says 'struct page' or not.
The hardware kinda uses pages for page tables. ;)

Could we please leave out the unnecessary churn from the renames?

