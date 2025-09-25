Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2DECAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429CD8E0010; Thu, 25 Sep 2025 14:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401E98E0001; Thu, 25 Sep 2025 14:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EFF68E0010; Thu, 25 Sep 2025 14:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DCBC8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:28:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D128811A082
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:28:02 +0000 (UTC)
X-FDA: 83928606804.14.3648D98
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id CFC0A14000F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:27:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TnVkZeCy;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758824880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gllL0jFsSMTv+WKLgz1TzNrM4HELZ+1hcm3IMJUm3Jk=;
	b=QMDCIZt6LdOn3COsQf9P74v71eGM06WyT7JedkdeXelhLEz02h0F7ZFSSp0jLGlKe+bFER
	tLxixGX5IuSEv0ClVV5d8wqhcqF+mNOZUTMpEFPzwTPlmR+e7KRIoDCwm9Em6nUjpt2m8u
	pL7buTHiGL0U1B3MD0V+h6UIBgv/BYk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TnVkZeCy;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758824880; a=rsa-sha256;
	cv=none;
	b=lroy8R+1DPb/YJfw4t3vvMvTWXGtIF6yKYgIUSLGv+zmV5GLhzLlDYT2TzjgaBHmAblbfG
	Qh+GQehRUHIK34Pzv/O5/6SEu+PhgiUR/5TTgLSdEMqycCK8RF0wHy12yF9wO/JRbeWNBN
	iOaYdg9Q/JjNXNSjat3UxlhxPznYo9k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758824880; x=1790360880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gllL0jFsSMTv+WKLgz1TzNrM4HELZ+1hcm3IMJUm3Jk=;
  b=TnVkZeCyWUmzloGVxvu1+LPZPYu/t1GCxgqq0gdM2BT12NCFKcEyxtx6
   C64FUzQ7cUWRvJbvNB94jq6GrMZH2rC+dTF69BUXKmOgbkXvNmLsmhG6L
   trzUVQ6kZD8osK/F+bOCMH+6iUlqsP/PB6AQvMr+NGHKmcgdCSNMSUHAy
   xYlsQMtrsgEGXM4c3Mk0Nsqy7tGY+Z3QvRBGGaNeMr4kHiwohqdmCYZwl
   vJATxhdi583V/fX2YgmfE5rtUE+bg2XduvdibE/CiadOLmkq/dnrNcpTo
   fY5lsgQdeLbHr1lhOftM6qjbe73yBUyVoYt5MSiVGrjMUdJxdEYyCSUfq
   g==;
X-CSE-ConnectionGUID: asE7GUFqSJKCwb0z5ltoBQ==
X-CSE-MsgGUID: 66jb6kKSQWeXCbA2SgMNKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="61206593"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="61206593"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 11:27:58 -0700
X-CSE-ConnectionGUID: QhFvsIm2QUGJPg2v+owCag==
X-CSE-MsgGUID: O2Oud7SaSaypMhr6Xe/2hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="208338229"
Received: from unknown (HELO [10.24.81.144]) ([10.24.81.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 11:27:54 -0700
Message-ID: <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
Date: Thu, 25 Sep 2025 11:27:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@redhat.com" <david@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250924152214.7292-3-roypat@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CFC0A14000F
X-Rspamd-Server: rspam05
X-Stat-Signature: yw6zuyqqybbounwrsoj59uukyqkhusqh
X-Rspam-User: 
X-HE-Tag: 1758824879-28472
X-HE-Meta: U2FsdGVkX19wHhl+fqJWnK8A2UFvrMBk82fynOj0jRN0t89iHtwTxn6V8AtckYXBMYzbrd6ANu6zP7he/e2yiGNkulYMPPXfu+muwpTu29LH5abneb77MlE8BwiND1qZ4+7hyM0/lqpjqb3zrPHEEoQ5QzEotR5E1WqYwXJuqZwpAm7opB6pKFMNK6VO1nxrB2a5WpIZaxk3miy/ORSUjWsI/UseX0kvldcU9RPyyORJ0gYBpSUR5PDPLLUwBS0fCb5jUTytQ1iCyQkkC+cF6vfV8JxoT9wqvwL3vNrNDuUamRgqUF/DGLnkqiLpCVCu1AGADwWPACN2EipY7vWwKl/AGwWTfBGn2wz4aTJo43GwYjT/BTir0phbBI+o/8Cw05SaIVsrGWyBsiromXIsDIv4CbIU/UzxIhq5iliJuqWG9tC4qDpu64+9BpX5MAGyMNllfSgWgxLimncySQdVH/Od/SjVBIokglQeD0dXyOi8LjX4VrohP7tuLWYiPwQ4OCA1xa4YNvsltY9KAdal+dokkJ0W8jc28VW2/FmUVxerdbXlSadPVCiZS9Gh/MQC/GJrCCs0PljBjF4ZycSxd/xrHtxU09+IpkjA6az+ukoERsWl7+p0KHZQ9CzPFh2r4wAk4XtC7ev75RQkwUS+XSPeDOmwVZuABXorXQtp4yA4q9cpk+YN0/DrUJjc7w6vTvsIuraPr76Y79432w0DBmCMpMFC9CcM9ZwxfnukcLWT4sokj/TYpaWPV68OuUFyTPDZgg/277ZB2xH2QnQRqcoUMAJRMDiYaXNaU2HBK74WuJboIrL+TklhmS5Oh9SfhrG4JwA5ZE5IsxFqtrWHXWo4sse6Wf/yQ0woIfU0Vf3ikVmUY5OYUh3VvLQ+2FiNGGe9GUl0NYYuHsZtYVyxs1nJGvVAPW/1NRCc/YA8xpRxZRaNrO6BpC8b9oMXxuO+kKuWYrugBoA4y0ctOCC
 QBT4WCpf
 1ull+iBGL8fYPxmPd7AJCBJAgxh844eGzsr3SDRVOcW/5tmUT0Ui9t8Aybc/7yFdrpgsLsre24ntV2Wfm7T+grBWjVnKtszDcFcvEbqdrPfRPuUzP5N0ghG8nyDcuneril1iZsec1v1HthBa8p6Q4g8L7RuVfA4UThncjO8Tukp4J2KUyrmHE8mHvsfws5Ra14WxZf8DXkTyeLFxngudIvVku/1w9x9lx64Xk9L6K9IP2Guh1ZIftbmmKs1MvX/Ybvsq2UdAGxouk5mjAh0cEWJ4XSb+iPQFc4WDCb6dBMaNilWwXOpZjMbcB5/ZJlkbxkVpcGVt+e1lwlxUeuIPsqOW34xO6NY75XufIvjixqG8Q54yYmHnwk9UVm0/tmOiULsJ+8BX/aPROF+EIaPWuXzwB4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/25 08:22, Roy, Patrick wrote:
> Add an option to not perform TLB flushes after direct map manipulations.

I'd really prefer this be left out for now. It's a massive can of worms.
Let's agree on something that works and has well-defined behavior before
we go breaking it on purpose.

