Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8CEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235EF6B00A6; Tue, 30 Jun 2026 18:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CED6B00A8; Tue, 30 Jun 2026 18:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123616B00A9; Tue, 30 Jun 2026 18:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E48B16B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:05:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 634178AC1F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:05:48 +0000 (UTC)
X-FDA: 84937961976.05.C300831
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E1731C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:05:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IdmT96Mv;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782857146;
	b=LP4tZoq2Vpgzpme34MCla/wHS9d73t+NfFIp7ZDyS/Vf+9KBSyrKLvLQurObM5Pv3Vel3L
	k1ew8U8Ko2GtLem+fx949elwV1ZblguBKOayjh3IgsWE0M2ZoG4LG6bQyaSu/Y8nSgcqiC
	1CDwqogYrW6WfN1/1oL1s7LdEts3QFs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782857146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JM0Gg350zihUghPWv7EhTbi/JtnV2EWeGqpc7grmOrA=;
	b=NiwN2j9TETpX7Jl/6MTJEfS3I4rsDfXDbxbmayeq8c1nvRG3RwWSUJGol5R9HThN7Z0JPC
	KooCpq7ZJV7F5J/PH+bhPa7Rh3mbJqrFyl/EqscrSpxsy9O7DR1X5ZUr7yHSl2K9/f3sa+
	p31VLCTCggZ4/R9nhs/DSQrdiCI1rxQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IdmT96Mv;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782857145; x=1814393145;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JM0Gg350zihUghPWv7EhTbi/JtnV2EWeGqpc7grmOrA=;
  b=IdmT96MvbUg83zcY0DQbbKnsj8Mz2yJKQ7mnUra37c1SxnPFFKpeZQBn
   IZ4Xt2+xHgDmue4aJTcvWBnsLEPkzv8z0bSGrIhtAAx3J6IvZmuWeI1/J
   rNecNzLV2H4uUlG1mhA9h+n+2ic8RLfUXP/uLiS4hua8G0LsXIUEHHcEs
   vzEEEOSbyOOKwj5D6gF1IjLgddVZ/Btudct/uImCQi/zC9N09YyvZp9Ar
   eYe9KIKB/Xlze2Fb4XHsP+S9fIuUH3iCpHzVIQ8SbkUbsMEXgqzHBbS0V
   hDS8DWVQ6KoBhBBNvI+AkJCECvYHHfxU+fukO14ERfKZUaiejkjI2u4/O
   A==;
X-CSE-ConnectionGUID: KSjv1DyeSJWbCXFoWhz2/Q==
X-CSE-MsgGUID: BGYqil8/Re+96Pa+v5QQ2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87416721"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="87416721"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 15:05:44 -0700
X-CSE-ConnectionGUID: y+Un/B1VSKW+EIGIZkrn2A==
X-CSE-MsgGUID: jITv+qW7T56FqOr88N4aow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="246045418"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.109.240]) ([10.125.109.240])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 15:05:43 -0700
Message-ID: <cb547653-0ed0-4fc5-b022-6f0b9691a4c7@intel.com>
Date: Tue, 30 Jun 2026 15:05:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Xiang Mei <xmei5@asu.edu>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, linux-hardening@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
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
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAPpSM+QVOwhmwspjaUg+FqKsHjiEn7C+gYPEcpJ_UZA=JMj7zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tx5pz43ehzafbg7nrkihyi6ds7txow4w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E1731C0003
X-HE-Tag: 1782857145-977574
X-HE-Meta: U2FsdGVkX1+mGo80p0AnRhoqsza7J+f9dvI25sGeljvLK9MXOkCH35M+qvoKPbwDbDgyEPim1pm8NUGl/PyFKk5jGz1RK/vrHBDBfU903TnaCkXqXMdTwLrmV1Y1ChzIuc7eT9MPsiXv2xFtkPPvfsNq36avP2/0H4bPNwFB7iRBk/X153ciqXtafI2uEKdRNvs4qNpF1qQ/Wcad3SPCaR8WUvEoXgilOJI7SFUsAYAjeiGHqcXdfRE3blLUzHnvSANUAJgKLGydm6UP7CNKdAqKb9Uzxo7riMTfUk51RY40h9+sxEVE3mn7lawjPCLvPTcygNzzqauJePU1yevrbWYH/ASSZK8TQVt3Vz+0mnVj0XBHSjQwoyOFLRdS0Hk6K/FFKNhMSjia62QuvOQu/rxmO1jpFaOYMTR9Beu0o2qFXCyoVEsv9t17+BnIlu+FN/qSUh4C1/NdJpj2JJH0NRL8xtJwHmiQRechWeltZVhzo+D0JVb5jpA+eSakGDSuI5OgUKSaLDc+F8JboWWHrE4/UmiaUiUmq9g/4V2eNM2u3ryZph0RN9H2DseGEAMf7XNbiIK4NGXS2/QvJdbvVUa+60CfGDL3lQt9b2feQcMbsYRM5ep2bcDWAsfX/wVWtmUDwJEI+5DN1oxtr374eKBXIDccDfcYrD+8vrXCYp659N2l6Vo09l31CEqG2B2SZWteXJK4hhcNHiXWkDY5lptmItIHpBrzCOxxlkebRKG7SOqc/LTqAh7dncscYj4kUPWujJCVoJU6kyYZAFiUzHnWhkukmtUPTfg6j7D6d5qXPCkH44dWGH/J3kIbmj8mFRjaHRvRcxwLxGczYOc+to7+m1PKAnU92q69ZbE/+vV5dSECDYyT3Ge1/+l9oYJ/u/9OM0ljQjw6Sc4mcaXuOck7QJofSAgwlEG87kgx19WdS1dgQnJ+OR9N+s8grHyYosH7hWCV04KyGnHcVlv
 oKcQm8PP
 1lICwlPjxHeytfoe0Jqlr+o8Sd5lGV+Y5sT0gkDqa2A1xztUGzM7Kwq45Sy/zEOyevNH42yC5c/Jrk2rqONPO/O0furU7Axx/teM4EtIjFIH+5Gq1EsejY4zdMJR4vsMb5ouYLRlPuxrWZHH5YKxdMSCHTrlLeL23mE0n6u6QSXshWu0LaTt8iQW0hQOlUq+GCZlvQIqfjvHg9nU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 15:02, Xiang Mei wrote:
> Please feel free to ask any questions; I am glad to help.

How do the CET features: kernel IBT and the (theoretical for Linux)
kernel shadow stacks impact the situation?

