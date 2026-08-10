Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E08C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92026B0096; Mon, 10 Aug 2026 11:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6AB16B009D; Mon, 10 Aug 2026 11:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9814D6B009F; Mon, 10 Aug 2026 11:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 676BE6B0096
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:26:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1ED93A1B2A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:26:08 +0000 (UTC)
X-FDA: 85085735616.13.6FEEF52
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74035C000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:26:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ESz5iVl3;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786375566;
	b=4jXV7EbDe3mrV7jnWKwwPUpqSIJBueXkuYb5juO7oM53+VBsN5LOGtN8tnehwM5E40qhD+
	6vcbAEw8kLVfkTxBnidm3dHyUSkLjCTf+xF86+gtgbmLGYLv+ClSGGLpP5WMvJJwo0aHC/
	PQ67byZZTdxGKtD/e6fz83jBqW9Ov6I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ESz5iVl3;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786375566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=al89CoQaDzx/rctFP8O0iKVci1W31AfWLwm5PYIfgsI=;
	b=41GxLeVY4+0DVjynV4zUpMxa4joLX146T0eg1/Tn/5MnT09cHF8vwyEhjV1TPTGEaVwEMW
	5xUGN/ceklkzOSNPUogCz1WqfvW7rrWw9lxoZ/pI95Q7UodOTG3XYGmjy+nqAWZX//PpUg
	nvME1izd/+0OZPYhHrF++bFtT6P0VQ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786375565; x=1817911565;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=al89CoQaDzx/rctFP8O0iKVci1W31AfWLwm5PYIfgsI=;
  b=ESz5iVl3ER+F32MkCEjdi8ruUN3W61PdNloHe7/dGO6w1MZtea0/K+Bj
   8J87wovJm/ytiZeOI8mbdFjSOBdwJfvWliVdWBtqnsRiuKlxpBSP4sQ1r
   w4gWJRgHrjc4z7kGlsFWH8nCchjgxp4QLVCOPMM6BWWvpqnYrLqpzO9Cw
   czBZ5pq9SDQJHK+PcXclk6QkZHkKYnMD1EaoXXfHXgFumQ6MLUwHyztV7
   CsE1J4aVnoFstFYGVYAyIvY9IIfriY438wea2mo43cpS4sq6/Tnzsv4A0
   uRC5VQnPhCAQkLt8g1RZEAqGSiF3YBLlVooMuaaQ58kyX9VYtyFqLhAfV
   g==;
X-CSE-ConnectionGUID: LDcE/t9kRuGul/1p1AUhsw==
X-CSE-MsgGUID: q6zt7O3MSLufadiMqX2emg==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="86902244"
X-IronPort-AV: E=Sophos;i="6.25,216,1779174000"; 
   d="scan'208";a="86902244"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 08:26:04 -0700
X-CSE-ConnectionGUID: ZV26ml6YRJ+GeATy+8lkQw==
X-CSE-MsgGUID: 22b8XlHBSs6S5Scx4/SxpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,216,1779174000"; 
   d="scan'208";a="263674217"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.110.41]) ([10.125.110.41])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 08:26:04 -0700
Message-ID: <13c444ae-9da6-4fbc-be98-f107fc3bd0bb@intel.com>
Date: Mon, 10 Aug 2026 08:26:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] tcp: Remove mmap_lock fallback path
To: Suren Baghdasaryan <surenb@google.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
 Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
 shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
 aliceryhl@google.com, arve@android.com, cmllamas@google.com,
 christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
 davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 syzbot@syzkaller.appspotmail.com
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-6-surenb@google.com>
 <anbaJuYXEoldvtPn@casper.infradead.org>
 <CAJuCfpHh1E34LVTd=4y8m+2ugGABc3MSU2Z5N4pFY4ttH0a5Rw@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAJuCfpHh1E34LVTd=4y8m+2ugGABc3MSU2Z5N4pFY4ttH0a5Rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74035C000F
X-Stat-Signature: h83dfp8f3dpm935ggwa9f7b3dd5jgobh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786375565-549110
X-HE-Meta: U2FsdGVkX1/+2owfTbzHVmdjLWTp/UlK8k3M+Jgpi7St3T/o5PDXjOEBASZYgI4zVyB9KbZJcqr14lDvgYxNV/wFUQoBYz4meCqnMvla7z+oj+6z+9FSOMUrJ5CJOl0a0oz5G0sBTB7iBKMoeeo3P6F4phFoCZMdN0T4F/Hc5DEQClRmZJl7Vu2Bui5aDw7k7S8qNCSIZQmCNkk+Hx6hsXco/U/SOx7Lig0YFxqEC3BFMlzBL1ScfhcZPt1WXC8H2NFwuRcNnReB+LyU5FialZ1yUhBXUKqBwkjcdeLOO9C6zQfGJ+mV3XXkfc+zhMkwOBb+z0KTtaxqxWWAxN2QJLXVEPbrMZevVM0VKZPPUc/+YNY/V8SvbmjU9hZ2z3gxBfvM+cGymwJr2OklNQfrlRIL6DLFUTuFxIkdho2YHQw8eMddnx676hCg710uZ/WZQ+H3mbYy8JrlnYwspJPGwoTwA+dTxs9jVQfj7nKZj3lv6snkPqHVk/lKGJikDxmfxw1gfjv4QdTcvo/9KaHxG1gi82KeiVGbyF9MCHaFpx/1i8QQHopEdJ3ypm7GkFkDSZyFUI6DaRa9qH6n5SLQP/m20MsV6UvMUV3tjtnK5Af0EowJKiwJ0lvfvT+G7POyX7m1f99/JGKYil7DxOlz/HGezzNCgCY2Ov0tNzYV7cF9/L9Ww6ASINDETV1AZUmocJ2+0ueFlKHkRt/PeQMmHnvviaFKJ9NfYMQn0q5ZOKZPGTR91483lSZT9/4d3b4Rmf/U0hpIV41F2ZQ1M5Re4e7y0m6zFP3nD+KHjTnuSUKxYx9dVzK5gavioO9N6Lss3wYQzc+OS3p+QBTqN2L6gXnOhLiloIlox4WLXzIxka5OXuFK6629eCN+vHu7dUS0RIyAoNdsKX/02hn54FG3KCILApu+LMIGSrjtKBZYVGvrBeyObm/1DJ96qKCSMnCP+jL6P5nOoIcjJjYZ42l
 iNzbqK1p
 FeMYLEoi6eAShtl6rsvPHEdZ1L/QHTbnldUUNrfXlC2hSa9vnf5UKvkLs1g1HtC2f5hb1jPqxEo0cmP6M7Mja9uRGGCPpOvK5h7XXZ7PlStB7k775aOig1TS1JvqA8asdp2DDGb0V5GsOOLEOFAStz+T27SoQ3GT3HxHv0uR+M1NOquNXi25cU68+aUOSXCqJ8gFbbom7RKlzdzqO+nlQsO2U1JFLb1kPzI1LHK4aaeqpOBb+U/qX2sqE47oZ+0SR+Wg5tV9sKQ8tJDQHJGLVlAJhE/fk0Wn68cQUR7UyQGU6WLfuVchyrmjUYx+T/IA7vunbeL3QjU3eyIOeNzFkTxjL/bM0QAvnlQsx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/26 17:51, Suren Baghdasaryan wrote:
> Ack. Will fix. It's obvious that I took over someone else's patch, isn't it? 🙂

BTW, Suren, thanks again for taking over the series!

