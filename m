Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B989BCA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 14:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0E06B0088; Mon, 28 Sep 2026 10:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981E86B008A; Mon, 28 Sep 2026 10:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870646B008C; Mon, 28 Sep 2026 10:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF276B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:03:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7736140222
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 14:03:27 +0000 (UTC)
X-FDA: 85263338454.07.924F9AA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id BBF3A80015
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 14:03:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jWl6Fbud;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790604205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMPWpUD7arT25XYnDYE+j4USf6ZnBjfA/ulK+5UimqA=;
	b=WW3+3EEAtOv5Ir3vVM1EFJbPDoNGOaBS3Vs6mAIxWLWXrg1QDAvKt1wqT3Lh2lqMOBoNBu
	ZoE6qjhWgIREh9MuiD+bA9jb5aA6Iq/kOELlavc3zX+L7JbYSFfsjzxH0N7jtamT7Vuzsd
	1ee8bAKKxwqpTmnig6OdPGzcjBQ6hQs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jWl6Fbud;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790604205;
	b=GyzPO3OcPFitZ/XFJPgilYktZXlJkecXCG1Y2AVAP63B+hg0GiMXWn2sADLzyvqMQhjtKi
	yuYCniQ90B1Pr21BP/DIqeUyWbIWm10rLEBW1h4sJKnMqpltdbhFTM++HRG0kgOKikRJXb
	zmq89dnq5DVynv4NNsrjGTr8x+GVHso=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790604205; x=1822140205;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yMPWpUD7arT25XYnDYE+j4USf6ZnBjfA/ulK+5UimqA=;
  b=jWl6Fbud9myxWW38J1DjKKixeba5Jz9jiXImNruAQ4Y3Sfzi6Zoomzl0
   cF3S9bhxLvnnHyrCzUJV4AHt0InId+E0EyIGEswOg0sL8li/3nDn1ZD/g
   R5inwDqe1i/t6RkUrx2M0r3TThSaowxqcBYF+oncY0NJXb3SHEBrRm9u1
   ICD3axx/lrFdGgynti4tVT/6EQBYcwsW4crkWLUF9UZn7m2fPW0P21pXc
   20lfZX3Lbv2eK/fwca+VUq0EX0hESPyWECEnpLLPpvDzV3olqaJ1kXC1U
   nFT4wep1K+EKREaalxV3/SX0nlvDOMBg+okw5Xj8qHcGyi8/oDkDvsZ94
   A==;
X-CSE-ConnectionGUID: 131fo+siTWmk87E6YLp0GQ==
X-CSE-MsgGUID: nA+ejnrrQw+bGZSqZfLcCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="100636296"
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="100636296"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 07:03:18 -0700
X-CSE-ConnectionGUID: eVBrKQ8UQpqijyDkI/GEnQ==
X-CSE-MsgGUID: gpU7j+n1TIym1oNbgGxShQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="278419916"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.111.49]) ([10.125.111.49])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 07:03:17 -0700
Message-ID: <26827871-65c6-418b-9802-cfd1a5b081ec@intel.com>
Date: Mon, 28 Sep 2026 07:03:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] arch, mm: promote DEBUG_WX to CHECK_WX
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Shrikanth Hegde
 <sshegde@linux.ibm.com>, Suren Baghdasaryan <surenb@google.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20260926-direct-map-verify-wx-v2-1-efcd64a6b74a@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260926-direct-map-verify-wx-v2-1-efcd64a6b74a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8kr4keibhbru1st7gkinbsmgwr54oax5
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BBF3A80015
X-HE-Tag: 1790604202-472532
X-HE-Meta: U2FsdGVkX18kJ1udRLQbCk0R3nk851YFkV+Soy2S9h44IMXHOfE3QniOXZ6hmj3ztnxkQhuD/DNX8N6Hf8U3YehArUw6I2YHjgv6xJ+KcoZXEYxw5u4QdHw1jdin1L5pXKlB2Dtf/Ko2t8CqlW+I3/v2BYYMBZOnzdtuuEBKSpaxWcU25lQVpyvdNTz91Pvbs919fI1VkBkRLMGeCXzdQK7DCVS3xOQ1ir5VaToSA8PkSKoFkUG/s7FK9A0BqYDsmzexmDGlJUdgK4AShD4BoJbXdUkss543wDsFeqZL5GNm5ZSQ9UyaoqUAMXMRCjX2Ty1UEgolkOgAJHlm1QbCeDgLiqCaSbxaRvWpzj+ALStxAT+FoJosPFL7nhMcn/U+hnOxILXTZDSiHGfEWrAil1xL+Flnc1AzvTbmediBkNYJTNOELXaH+sR3gIWb9DQ948Wx9a+9SJ9B/UEf27SzuJjAb+ExnXbdxMdIjWxrDrolmC1yWo0DMsn4jXURQD8gXKnZYFQrZxjhVsfgGeLAGhogsOgPwCTssudWMg78VDIcSlGtP4l7N1wxqIuRmciONEJIlePGS5Zu6PW+5i6e+IoEklCoAPDC4DUlWvXNcGYlYpEez5sQ5ghIITpyeUJrSkckXEj4Ia/Loiweo+r6/ZjbE3z/fMEgCOEIQMLYViGgTEAeDI04zCUfjDVCPv9Fd4wA+uaqCwRqzS1d/rj+YXL2tSr6OSe6cF7KQGqVOoXpQwLN/xbbWLQZ7t0HfJFY9YehcA3QwS/UvCrNpOJJtki8HUOweH5l+0syPiWvqgkx7lmI8D/arJYfI/VFGlzxNS+PgCDmHTLepebQ4/7U/pL2PZEUvcUZ+oY8pi3unvJmhe3qxGhZHjynMHIfUWL0TF1EpyaOT4BUPLmpa7NYI0mf9NQhIv9WJrd4Lbre1Z/lg9r1AvmYrnc3FE3vddQV7Adk7KR03Iy4+PmJZPM
 slCBdpgi
 E/sh9ujURP5ZjkCTRvcKKzX9taoAAjz8ixOt9yFwsvMP1J0jr0HFKYNWWMgtbeD5hNddZq38fix3MqaRMvdPWUR+xMt10bZF1bM80UOaSIGy7cPC7fV6y9VwiSFO58mIdL9kOr71N4W8gwweO/PwxafbTadIKcbK+37esFt1IogClb44jSZI8pJS3euuintmc/5hoPgm3+btSqEXbJ5gw6VHrnlvyOlkMle2VbMVEsPfmCSwVkqjR9zi5gt1tBovdzwJWgYh/In4Nh4+RObGNhvi2u8kcye05dYI9xhAX6PUeKVXZ9xf1NyaKpFMLhrsCSwDX9A3ftfK2r8Una7A2i/1+knhQtoZGxE7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/26 02:29, Mike Rapoport (Microsoft) wrote:
...
> With this, make generic CHECK_WX default to STRICT_KERNEL_RWX while
> still leaving users targeting small kernels the possibility to opt-out.

Thanks for doing this, Mike. I do still think this makes a lot of sense
to have as a default:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>



