Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716EB606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jdmxpstl
Received: by kanga.kvack.org (Postfix)
	id 743DA6B073B; Tue, 24 Nov 2026 10:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4D16B073D; Tue, 24 Nov 2026 10:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCEE6B073E; Tue, 24 Nov 2026 10:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 317CF6B073B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:11:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFC89120BBA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:11:13 +0000 (UTC)
X-FDA: 85470350826.07.49B1618
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 16F2440012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:11:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jdmxpstl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795533071;
	b=wa7fFFImo2niAe1eme7yrs4IkkDij+FxCW454QEqSUiKGe6dK7aQKacgqsTGJsr82NdAUn
	LLCzHJn4MdL1fzv9ot2egIKfbSRFcEcIU8c8XHbrC2k/6fFKktUe6FJ0J26taM2EIv7vqa
	t2qg1db79FPO9XLXDQetFy8YrxkvmT4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795533071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4i9A70D1gPOP4oksoFqIZyMS3O6430jvP/+79vhurdg=;
	b=lDj3pxX9knBc62/c2YGti649LPYA1bQyGOL7LxdSPqcxQYZVhUojm8wKCgVnYcA0LEP9+K
	JVZPuh83GIhxZ3zRBhapQL08+jgykSiI6uDyRWBIIuNoq/096kWI8OVwgAUeFU6FZncVWD
	4losdHlViEwCQpKNVsjwquBsQX/JfQU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jdmxpstl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795533071; x=1827069071;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NxeC1Wybb77mO9Kjd+nB0CN+fae9IJOOQ1ybh9mDWzM=;
  b=jdmxpstlIex3Ja4vTb3OsFT4KVnoN4JAQi9MOOxxoAVfBUwEXfqq50Kr
   mIfdJ1PEgpPAnEvYbZu4XtrVMe/9jdEuXFpbv1J1r25T1lT8QKjBsKeMx
   ffX5HozHYW07kuoaI5vNEBs7MmkV40rQ/ARpLY+vnhmcEiwqnAPj3HRqx
   MTW5GmwO6leGRThQ32K3L6SMkPNTBtaobrHjEZL1fsgflKRGFmyguOUKa
   HL6c3OvPzU8jiwwXmVVu46ojWafp4i6Yg8egUgP+1QY9RUPS3gk9VHAf3
   VXzjgXFcu/pLP1p87/F54k99YXrEDMORX4RdsZsaZls/Kc/mNeW173+bc
   g==;
X-CSE-ConnectionGUID: uf9jWujKSY2HcbBgGug0FA==
X-CSE-MsgGUID: zBjGVPxER6Ox4iOoxBV5Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4270712"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4270712"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 07:09:40 -0800
X-CSE-ConnectionGUID: rYqzc2CPTh+6pvl8qSuViA==
X-CSE-MsgGUID: GXBH/9peRMOWfKr0EK0fKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11709101"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.20]) ([10.125.110.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 07:05:04 -0800
Message-ID: <90346f3d-6b46-4786-9d57-3f39b6fdd7b5@intel.com>
Date: Tue, 24 Nov 2026 07:05:03 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] x86/sgx: convert vepc mmap hook to mmap_prepare
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>,
 Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai
 <billy_tsai@aspeedtech.com>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
 Scott Branden <scott.branden@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Richard Cochran <richardcochran@gmail.com>,
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-sgx@vger.kernel.org, selinux@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
 linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org,
 netdev@vger.kernel.org, linux-mm@kvack.org
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
 <20261124-late-2026-mmap_prepare-v2-4-0b0d99d655f9@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-4-0b0d99d655f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: o438wqowea1enokgng86i314ueqi9p6e
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16F2440012
X-Rspam-User:
X-HE-Tag: 1795533070-226435
X-HE-Meta: U2FsdGVkX18EB+/KWuy88vX9PD4lSw3+zM0tOUCmN/tXosC/ZDsbqgOEC26wjlJCoSnVzBDyiBBv+Bn496dqw58eeoKOzKNtUokK/qqM1oSUbz/qk7qVMegaBjZcxj+mbVIoPi1yCccXx59233msnrviJHGcIIW/eu4iAJWeQkH7F8Q3ZW88vndm7WoJLLonR3KF2Dd16dZrbnexdRdZvGcMXrSrWZnc+NuWjzF04OmcD3FtBtTCxssgdcS66yolqHBw4DnhsBtFr7DP+BZ1IfwD6jiU3hnLw/CMqQOH3wtWq2KbWTurr6eO1dxK5/3TOHSNffvLLhodGwxNSNeelU/uT2AQQDS/okJRmCFPecQbP4RzhgPj5TO/VJ+QbvL9FDnub6/8Hb1Cqf8eHS2pSXwPWoz4DPiHWi4QY9nGzL6lEBBl7Vhub0rmKX1RQ7ITivXyeIjLRyP1O5TAzvtE2L0PFhdZ+AbJxr3TFEsS7jcsZ8OjjguiQfu6gpGgAtH1Q6CKdHgItGdwExcG7DZkUL7dtD9LgWc7D6EqK3Cbk+dh2V/Avfc5W7zKGgxKBhE3AinVcBz/laqgrhz8A1eLq1bdJWmiq1Z6LHx8hRKDDdcffJi+3nLZcvWJQxOiQiNrX7aYxSaJ937XK5DZRfR6RrJfPxopI1I8PoTREdCxzzwZEzrq9FvQgQxgaAeaBtVEiFNuz43jsZkPBDkJ+ncO85Fxf+NQARavMgsvva6CZCignWjkcKjZuDesGJrt9dXFbLiNr8E5QzhrRL65gmhYl6ij4P7GfpWbdSB/MpduMFkJI9vb+Uak1/odMTZcqvNF1nFah5GQhj/rUK7kxHNgEbWWTJ4bqTNGxbymmjzmpbJWiSAkDqVApQSIMR2KQ8xa/2midJJVuFCY+1BvLXIbhd8d8mSf0gvi+QV4GF8K2OLlB5Qv8fwLVPz3n5DihNATKmyVi0tFG3io+ZKfDps
 zoYOFW3t
 ZhLZymu36G5W3r7Qmiv2NtaOFP+Q8E8KzZlpt72Qfsfbz2xeIUky8GddinVDB41PUZitGlwiQDWjWE3MX3iSVjYrJfgV3H6Vy05xMk9ZKl21gYZ8YUruRG/nXRRiC4FtGSM4joFnR2ihlF/IDJtlU/c5cBsvkfheeDB/uO3kdnoOs8i5wG4L+tNRbZ6FLz0ynm4p8mEyzKFE0BLgUznnoaDzDi8qn986qX0gOXndxwpM/d3GKSrQrs1nFLokTOGpwULLkVQ9eURi86hwrGVmXdZbZXRtKIjC1nkvEY+z+I2m+QxsKsKa/+s4Mu+WKUqGXxUYxS79Se6GGwk2mKrIdcXtXk6IE9uaNjkrOlok6KieBZoXUoqGvIZd2+4MuVpcy2xQrOqw9WG7sdN08GtVYXj3/C9qcHJTs8ViY8WHTzWtwJAuvgJPmR1MUjmop4Cs1IhbW1TFqY5K7who0bc2JjafcVWLvt3N7wxS3Lap9Ztd7zCOBMzg39f7hullTd7UMtAgLYzKkLbS0rnwkSH91FN/LydoPfLQT/uNUsaWGaD87iPmS1x8f5gdptJmeeMzVZefLxdr/grDkERlogNCRlU3og/DWZ3+QrnfqF+V2JUgrIIri708zMM3Gjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 06:02, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
> only checks that the mapping is shared and sets VMA flags, operations and
> private data.
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Dave Hansen <dave.hansen@linux.intel.com> # x86 bits

