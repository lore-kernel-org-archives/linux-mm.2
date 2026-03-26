Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A03F10AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253726B008C; Thu, 26 Mar 2026 18:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6666B0092; Thu, 26 Mar 2026 18:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F35C6B0093; Thu, 26 Mar 2026 18:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E82906B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EABF13C2A6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:32 +0000 (UTC)
X-FDA: 84589644384.18.FC4F13E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4585D4000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RM377iQM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.jiang@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563870; a=rsa-sha256;
	cv=none;
	b=H4a9Jk3Ul/RCJS2EHqkZaGQugBcCSEjm0WjCKVDbrMshaRrgYc79YgcajGCjDKgAUrxOcM
	pP5xrH+2Ax2lGYp7Tv1W18nSjbqbyi68PkL3MlkIhvSfSKXa8oHFW31lShhPSSgCvJFlmK
	YTmAjacxoGEoMO35AMy9EWdJJiN1uAU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RM377iQM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.jiang@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMIq/eOjuW3YZ1JkT0rCtlSeIbJT4jUvGVrneR2oxD0=;
	b=mEQM5bJN8Ya4M4QN7YN0UFRuYi8ePEgAnwoExCyqbag+RE5NcAJoV4KNGXTP+3L4DlNKLh
	QY2YoRMisDook0GCSHim4o/eoJotW0LfhuqSD04TjOWJK5PUzT+uFu0ISvWYvORmxqqRRz
	PKXs3vSvk7OQuGLeO9H0+gpwLVb/NJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774563871; x=1806099871;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3YFTy2V56orgyhZxtiaVDkmsOBqj4WEHYrioPuzpDTI=;
  b=RM377iQMH1snpfAc9gGJtF32oLEdvYX5eWjeW+9UxfjrTGP/PjJPOUD5
   mCr+xQm7gsDemnCU81bT2zvPVaYW3EJWmnp0Nd8Laa15jXMvFkzyySjKN
   rtU4TTj3J/Bb87VO/6oOJVaKjP2air7MteNuzRYTmrNntaZCzK5GSYIgC
   ebrBKb9iUqtObZ/KWXXLZZr4b//X3VzfFDM7YD6IqzBxxmTeb1oBJFW9S
   ZzaUmtx39ATeMO+7AfKvmdNb3UTgtIjR/wslObox5xjAG2sQIRh7cbpSD
   CYZhX49qsoaCwH0QEr5CSWGSLZ2n6dLNdchPHfmUn2T2ENU27HizzRkmF
   Q==;
X-CSE-ConnectionGUID: xuRnOdHDRHWk/Ft99CNpXA==
X-CSE-MsgGUID: WQcqbbldRqOdHfBsBVJr6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75351716"
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="75351716"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 15:24:29 -0700
X-CSE-ConnectionGUID: mh2BvPkTSQ+0bQ+FCapQXA==
X-CSE-MsgGUID: wvh2xao3RgK4tajqGik0WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="263048884"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.122]) ([10.125.110.122])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 15:24:27 -0700
Message-ID: <66c7fa22-5980-45cb-b1d4-94446231a6d0@intel.com>
Date: Thu, 26 Mar 2026 15:24:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
To: Rakie Kim <rakie.kim@sk.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: akpm@linux-foundation.org, gourry@gourry.net, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, dave@stgolabs.net,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, harry.yoo@oracle.com,
 lsf-pc@lists.linux-foundation.org, kernel_team@skhynix.com,
 honggyu.kim@sk.com, yunjeong.mun@sk.com, Keith Busch <kbusch@kernel.org>
References: <20260324053549.324-1-rakie.kim@sk.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260324053549.324-1-rakie.kim@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4585D4000B
X-Stat-Signature: yicyipfoge57ato7tp1ebjkth4mt9n1o
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774563870-343756
X-HE-Meta: U2FsdGVkX19g/1/LAFQX+L8udgrESe6z/j+rgWR0BZWDpg0gHYAbJILHGrWAI4yUMNTmiPYkmlp33z20G+liCLkrgMvywPMkIfUsfMEH4QRUfnfOR4rriDg8pg4+Oo+tM3dVPAF94MmIF2EuDbej0iJxLlq9NXeCwNxXqz4x6AqZ5oRh+0Sk4d0Sz+O6ATC3sgKly5BvT+fXiMERrhtugURfz69qSDugdZCYML2lbR78eCpA8kcacZUHor46qEKloifQAhpf6VI06fiOmXNYS5J3FkD/PguUO0y7UZje7PTKdgP2mPPXzalxtAupSBRFdjAIUkb6qkP8o+x26th7s2hm86mkmZio1tbL+m4DlxDbFpMPkE4CAFZRGg6tA/YvALoH7uWcIidEWzRwrCRwbVkaYwNAaiVwCKOc5KFwCE8lzMnTAA4kXGuwJTP2HnA/ePGIzneElFCh/g5OI6lSFbhr5+60Jjn4OBJCXjyzIx5vSyaE22x6ySJLZ3BTTfW1GqnJR3mn/jHkFUacNls9nuqK1JsHxzjvGXTyQ/Q3S2HA+NY9IYc6rHT99w/5ApuOrpzj6ixTHENblLv9Q3UXbfpFZEGJXdYepozD6SVoR/MudMmDhsIGwPHduxRFe2COqEVskEu1XRpuOeiv1p/9hkZzb0Lvs4Pdje6tzn3OHWC2RWwcjSJkpIjFiJFQzpKhLDtnZsru6DsLHeAWg8Ohphitc5erWn5JBZbz4ua1TEa2kSS/EhGyjHXRTO7w9T7sq7/bRt7YmCRNJwmo7c04APOb7HH0oMddP7gk25woBAV1m4tKxxW7En7bMfA9YSo9hGLg9p8p8HyP1m3cHPH6z7XiKYUfrKnGm+pod+x6yXGcQM8ECZ344dMOngCf1BxJoNnyIzRDsZuYysErv6ohVAq1SiRD95ASKUg9faehUS0TslHPPU4zS6WjJKpte2B2YN7o73z3LPsyjISSPub
 gXvJ/DjZ
 wdncnuffuWRUeL9pWwmpq4n6fjDdpTOyrwZ3VJmQs6KR7NdTX65xnu00Tgg1GeUtcMpRIqa9Tv+wQsoIjauaVds346eVZ5HQLroZbfdHkr5lPHksvVmgFJI8MVx2NPXe/jhAQ/Zyggxa7D3gLmZNL6PZR1Qh9fBZ3OVDoAgRZ69aTd8F99QS3zDTHk/T3WmyN9GeVKOdTsJzOj7EWxFI1PyLTT3O/okgcKWZaiBzf5uyBHiXxb3rMyAIcVF972eSFa6aMC9fEL5qKpHnjXTQitMVvR4DsQEJKBUVkc9jlkpDX0Ao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/23/26 10:35 PM, Rakie Kim wrote:
> On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
>>
< --snip-- >

> 
> The HMAT latencies and bandwidths are present, but the values seem
> broken. Here is the latency table:
> 
> Init->Target | node0 | node1 | node2 | node3
> node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
> node1        | 0x89F | 0x38B | 0x3AFC| 0x4268

Do you have the iasl -d outputs of the SRAT and the HMAT somewhere we can look at?

DJ



