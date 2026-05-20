Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A0D0CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08F36B0099; Wed, 20 May 2026 17:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA006B009B; Wed, 20 May 2026 17:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9810D6B009D; Wed, 20 May 2026 17:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 837AF6B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:54:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 305D21A0289
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:54:31 +0000 (UTC)
X-FDA: 84789152742.19.B3BE6C8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf13.hostedemail.com (Postfix) with ESMTP id D703520007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:54:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ShiS2553;
	spf=pass (imf13.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779314069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQvrRjsdRj04ghcPF62Yij6UEfGMu+YAIw2HXQuhhGE=;
	b=31I7VHy/o4PIdtvA91EnOTUrxfhyjSsXd8hxK5Wo9KFLbzH4bpKd5i5z3ZMrwhKZu5kR2o
	5cyl67GamyFgLrxk+IbLZ/877DwmgQCH9UrG8ZdW9QOiFxNjl8+pcLt7ut10ZHLIxxi9kl
	0HFniHEogfX+2scQWIXjFQjWX1bw88U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ShiS2553;
	spf=pass (imf13.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779314069; a=rsa-sha256;
	cv=none;
	b=znjMyMFGHPbrEdZBo9JHT63CpsGLUiGhYOu1SyPMFlLVuVa1kDGRl29ObpKs2Gz0z2VAfc
	owAKEBm7S4a9CBDaFrjTzNSRk7JdD4dEvcRL8d/ApdmjDYMqKRuhvMxaxsYeBynUhzeuhx
	qZK2epioQeepOBWC/cUfeI6KACZGwKU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779314068; x=1810850068;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hQvrRjsdRj04ghcPF62Yij6UEfGMu+YAIw2HXQuhhGE=;
  b=ShiS2553POs+YJPvjzWc65EwUH3m6aQspaBbpcW4H0HleUJpK2iDsNGE
   mooaTxNL2kSaNQ//Mz9JL9R2DVrnhPA5jqTgWyxzXFZXgwh0fN8pUK4MQ
   0bOvBDHG8DRaD7566alqV5DVjzWMPpLrHLa13Symuk04qEKHNNkEf6r8M
   97Ia5jTceGtpxz6EuLCUX9QL92S9AQJvcWztmhqtLTmNPta72gtPT7o8j
   fOYSPr/uKXxGHW168OGNDkYQcIcDTFG1n7o6ZSHoSVUTLYyE10e+OmFkC
   oh5hmy55Oc2EiC5CeFV35QJGoqIdVEBMhdQ8u3S9G1ORECAdFvIv37Wi0
   g==;
X-CSE-ConnectionGUID: bOfI41cqSk6/nm01k1hirQ==
X-CSE-MsgGUID: OkB6GeGvTpmNyiXSwU9ZkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11792"; a="84111518"
X-IronPort-AV: E=Sophos;i="6.23,245,1770624000"; 
   d="scan'208";a="84111518"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 14:54:27 -0700
X-CSE-ConnectionGUID: 2Z0D1IrmTjKFUACIXILGGQ==
X-CSE-MsgGUID: 5JJFjbriTImTeF9XyCIjKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,245,1770624000"; 
   d="scan'208";a="235916559"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO [10.125.109.190]) ([10.125.109.190])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 14:54:26 -0700
Message-ID: <78ef8003-9c86-4969-95b9-589127b30be2@intel.com>
Date: Wed, 20 May 2026 14:54:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Juhyung Park <qkrwngud825@gmail.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
 <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
 <CAD14+f316+wMZNm_sJF6ULRDUD9EbkdecdDwhGQKcsu70Bdp0w@mail.gmail.com>
 <9c0e3e53-d284-4675-89d8-943f93436e07@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <9c0e3e53-d284-4675-89d8-943f93436e07@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ofr5ky6y959e53o6ty98rsoyc7c5869
X-Rspamd-Queue-Id: D703520007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779314067-13784
X-HE-Meta: U2FsdGVkX1/hn/9qAuygOh1vkw1EGkPo+9fXY4iB1S1Ij8JvyVO4iTgjB3upE3h2MPWAKlbGgoLrra1f1DyPgCB5858K/TCaWfnhKgWoeu1nHaQvCwLU9R1pG66ZShgTIaFo/DMynLViaJxOrDYvYJJ2RqnQCMqrjCHQ2EGpYm9GufwfT7uihgrTf12oVw3fPDoqooxwFtzOPgQm2Nl7a/omZi7LbTDDU6wORkwZl0GONw0XUAbsJ4PBoXhocfIOKxXSc+RT3OpT6J5kDkBUFspGtLx4Y23D9whCzWPp9JmX223e0T+ZbCQlRDRm+2ljns75eOp9PEdrmYSMZJ005tlvBq5nJKZHeYh/klt1gUfK4k9tYP9SAluiN64YBnGGW/9tkIMH01J3jXhidxPq7/y/4xqesh3A72eUSE+TDz62xf31c2ZuXSUBj9D0is0wTcVvKrh/w9rfJ9Nf2s6Pz4hcjeRJruWB3AVYb34BeLd27FA9QjCJ7prd8YrVCx+2oQ4v0P1CXx3pFWQ5EWe2590IefEBqBSs3gSx+Mh2iKRpwz74ArEyM+3TYMKyISYra2FfHYyMQEGVrutgInBTCeCuNRfFpmSOVPSYpsL6g4yLGN/5zy+EirHrPyfdSOVMHu75c1VqjYl/U9GVgFmDdNY+T9Yn7YLe57EiO/3uxO0KFT+pX7+rienYxq5/yDFRPpcTfLn6x5gNUVQkprrZVuvbyn263GA3oQQRZy34z49oNmMOYZuSl/ugHBapO6VSPu79Co2kSnMSNBDTDdHlApOrYUrOoUCf210fQrvqVeDpdGVV0B1jDO6pTz6hnNbmp59PXO5/Orh/zvWUWPs7cmK/Dhq11yfg79KyEe+qXJ65UEpugecDLEdTaKi/dCqSinp6pszGyd1tO2Fzt95WB2DJqxJJf8p5UEHMwno+0akATexGoKp84wxZGsfp+F8jk9c7SDTXt4njr4Vsnc/
 QYAyiVLU
 fg2MpuczrX9DWdUxd9zb1k5cREiolXI589tyw6oMWTaYdps++djJtyeUzGW5QcN7n7r1jOPeHYAyDeyK0iUk6F17Axy23gJqKbN3fz+4QCdoHqluD2mtjAlq19sGPbkN+98EC8dK5Ihdl7VzQAth/3p89FBuhINPUXXtAn+ai86/P+/0dzdAgBT66zRMepqBEXLwDJKpqrzOSEPdjevFgIb+eNBe5cPXexgz0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 14:52, David Hildenbrand (Arm) wrote:
> On 5/20/26 12:33, Juhyung Park wrote:
>> Neat. Any sign of it getting merged?
> I hope it will catch the attention of more x86 maintainers soon 🙂

David, thanks a ton for that patch. It's in the queue behind a couple of
other things, but I'll definitely take a look.

Attention caught, I promise! ;)

