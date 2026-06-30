Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F6CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42F46B00A6; Tue, 30 Jun 2026 19:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A2C6B00A8; Tue, 30 Jun 2026 19:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09AA6B00A9; Tue, 30 Jun 2026 19:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8537F6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:40:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3B0612016D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:40:26 +0000 (UTC)
X-FDA: 84938200452.05.C2009B0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20B96A0008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:40:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OI68xEbF;
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782862824;
	b=TLbFoTH4oItfIkh38nIlUNnXdu0WlO8lvjnMU1Xy3LQ3cTePmM1tuqH8ZtoTpq8DiGutYL
	jl83PMhwa8i8TpxF3inF3G2KzD9aKVutIN5Zm8pLNtVewBtrQs3XygfNElN7m737zr/dbD
	DJbxTJBz8CG+riVFnrd0AMrJ0ZuDFds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782862824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUHtjxFNfdWaxKYchv7hYWXqSJ+aop85JzjCokVpdGs=;
	b=gjmBN78Buq2wv13xOIJhrPKBlIr3C1b4pUgqojIr1ENqUOYxgxyIJHbTipaTtszcWqmMz5
	LTy9HkBs7b+x0BM03FdFSodyEUw4KCGaTUQe3i+hqDsG3/0wDBpUdmacQOeqcFPEKjB3qI
	0BLuSCHnuapZoylzhLBCeu9sN5i8oME=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OI68xEbF;
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782862824; x=1814398824;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gUHtjxFNfdWaxKYchv7hYWXqSJ+aop85JzjCokVpdGs=;
  b=OI68xEbF0MlkOCmQk2BjwAV+KSsEnPCegljxIi7PuDwyNUwyVt91LFs0
   /SOlkQEiqUNHsIykOsdV/cL190nMUt6Hn9LGd501FCwEtUpt6p3BvsyCm
   4r4blHyFDXnYwsjPkFM//f1rkAb5uYyhSkzYcxjM7QWMjkz435D3SKZWl
   mb043DWU2mK5VvPtKutC+aeK8YVlQSTRO3rxru5dC6WiBzq+mW9W1LSC3
   WJbLfzMCKVUa4J1zxAL2roWh44II83JD+5mcpA8BVTBTkpc2dNakglwl1
   xYJ3+xycMqe4btmGngGJ5I14WGzhG5NEhPcjma7j4aOivTkDXIgMp2XZ9
   A==;
X-CSE-ConnectionGUID: XLT/4njsRvazwaVXLstPeQ==
X-CSE-MsgGUID: obWRwYCORU65YML82AuvPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83723095"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="83723095"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 16:40:22 -0700
X-CSE-ConnectionGUID: bmJt1NaeTX+tBoBmeea/zA==
X-CSE-MsgGUID: p9X1TkUWRXyWjGo24xiNXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="282466646"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.110.36]) ([10.125.110.36])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 16:40:21 -0700
Message-ID: <9ac1d214-aa8a-42e5-8903-15f8eac5cddd@intel.com>
Date: Tue, 30 Jun 2026 16:40:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Xiang Mei <xmei5@asu.edu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, linux-hardening@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
 Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
 Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
 Yan Shoshitaishvili <yans@asu.edu>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
 <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
 <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
 <CAPpSM+QVOwhmwspjaUg+FqKsHjiEn7C+gYPEcpJ_UZA=JMj7zw@mail.gmail.com>
 <cb547653-0ed0-4fc5-b022-6f0b9691a4c7@intel.com>
 <86e805c9-ede0-473c-b8a4-8b20439eaa6b@zytor.com>
 <CAPpSM+TM6VL36XAoDMsoCr6u+c0feab8DzXuahjpNfVJQ7g2JA@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAPpSM+TM6VL36XAoDMsoCr6u+c0feab8DzXuahjpNfVJQ7g2JA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qour8irt5h5khf775ekmn4hm7jpbfmpi
X-Rspam-User: 
X-Rspamd-Queue-Id: 20B96A0008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782862823-610958
X-HE-Meta: U2FsdGVkX184L64p7+0emIYzp+N9xDazsKMsZi2vHCOSp2J4RFQLWxx4G/FLirVuoqV0Jov/kPL2dCkrh+rZwZEPNhepkYztgrqGWoWSM+o7v64qGDPDKJw0g+rqJ6VIZapdUidepsF6LdpBeG8VrpJxRR1BQk7iaUSgYlXRyevYCNzk8A40jZSH1wFvlS+PVmkxvISvDfjsFdbEHKW+9fHikLbybN4JTaKkdWCFSZ/16nik7cNw1JMS3wl7nsUECUR1Lj4U+t1jlghVUuvzSFLRGX16cCnmspbs9E2rfd4eCjsom0E5qlm+s5Yyx0z0eI7tUqueO2+TbPS4GTcUKlpNjAoCEQIv/UeVyBseDT846R1u1edxKPkNFIHhcNHIQFmbEPDUidXy2ur1Xk2lvGcFOcb72rA4fDKuN9YPs/1OxOlh+MweMmG8Wj2Suk6wYZmb0m6YCutCF3nynnRTRxJbDY8t6NxnKBIUyIIOWFFBLMal5aj+YJpaakv39uIXLnxh8rhAQjpK0numcb7Ieya/yBm/a/3Ojeipb01FRq9tutCBjI4jjo4PYZpPSQqz+cmv75SalpDpi0+g2jBzKQjSlPGXA8Y5vf2MWqh0htCFtev5u6a4xNqDUDBu4etgPaVcQa/ixHex/zvEFcb1iaKVMfxqeaJ23VXxQ0mnfffrqJD0me/g3YTwvIX1G3VMUgEpWJ7uywvfOr4v00Two5hS8d+tkVXfFGFNk4hsrx2ujoUVmZXpYaswUEhlMHyfSTEKsif/vtOlpyZlgDbthIk6Qlt3P+fQhyVHj+/jCHTWFhVZYymVx1ZthC/seYsu5RRpainXoh+Gd7iY+bChSf3hIz/HbWMslmfuFWMT3me9zvbqeNmzFuBsH0f2cxQqC7KY7F1Ng9XzFELHePJ9uXIVCr1P2q+WJb3EjbZvS2QwfvyWSSFndIgI8oAcsOjy25MZ3eo58p7OlR9KcmQ
 aKFbQE5/
 sO+nnawjy+EJRYkwNwxrzN/hz7CDBIFoY26j9ttLPk1+Ja+9lwMOZqie1rzGwU2VOyQXaBWczeAVyNE4GQ9XsdRNlx/ABPqIhxyJqR55Ul2SG8M764tfrOBqe3p4xMFGl67Bf8WwMOtByr4D8BBpOaWUKRSvLcaY6FwPiGpxlFCixIoblR9swcHzDOPXpna/bXMIl3cB2x9itviSppAR/9rixSuWAYJ9DVONIjJHGuue6WA2piVa9EAgwhz3lEUP0XiP/ccd+NR6Au6pWZuBTuyoVim0D50McJwqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 15:47, Xiang Mei wrote:
> On Tue, Jun 30, 2026 at 3:14 PM H. Peter Anvin <hpa@zytor.com> wrote:
>> On 2026-06-30 15:05, Dave Hansen wrote:
>>> On 6/30/26 15:02, Xiang Mei wrote:
>>>> Please feel free to ask any questions; I am glad to help.
>>> How do the CET features: kernel IBT and the (theoretical for Linux)
>>> kernel shadow stacks impact the situation?
>> CET should prevent this from being the target of a JOP attack.
>>
> You are right; CET breaks the assumption that this technique needs a
> CFH primitive.

I'm not sure what you're saying.

Are you saying that this ENTER-based technique is worthless if IBT is in
play, so the new stack gap is a worthless mitigation too?

