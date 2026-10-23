Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D20C606A32F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=O3DSrObh
Received: by kanga.kvack.org (Postfix)
	id B9B2D6B0BAB; Fri, 23 Oct 2026 13:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73506B0BAC; Fri, 23 Oct 2026 13:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BD16B0BAD; Fri, 23 Oct 2026 13:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78F486B0BAB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:23:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B657A01B3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:23:53 +0000 (UTC)
X-FDA: 85354563546.03.1BB23E1
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 441B180007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:23:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O3DSrObh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792776231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9U8BJjnSyQLu8vlmMN8CV+h3S1yPSnSBNwOLGcNxzs=;
	b=rK5cPZcK+qpvZQoKVkEiIrwnpEO3MjVqvqV/vzk3Vatz60mdFiKwUUbyvILm21SHu2dF+9
	KzPwzf2lHHcF2rww705FyMWVGjZjLag6liBa9F/pXL2joDqwxdHGVzNTSGpE3Gfc0nOdZe
	A6cS1TdD0ickWe6v5iiSw9QTqh/RQks=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O3DSrObh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792776231;
	b=ys4uWvq4QDdKdFBqHSblrFHmSEeSMxfgbx1c8L9nTo44Fdbd8f0riwzdBIhGjfRcqAqXV2
	a3Vy3tzqIu86j3Rm268JOv5WmsiOLZeXtiu/5o+81F8CIEQNb50NgAnKxAVcV5TkPTRXww
	OHGrmFJ/9hN5VyVu56Nupf3jcW2qarA=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so8163085e9.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792776230; x=1793381030; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b9U8BJjnSyQLu8vlmMN8CV+h3S1yPSnSBNwOLGcNxzs=;
        b=O3DSrObh6buaGCc1piaRIszs9SZfJGP2Hcvor28lAuDQcbXjcmllOxm/UDeUZOHMSl
         xQ7mfSHFQ/Sz6K8iHDOIw6m3oqh7E78X2pCrfdrO0fIoZ00Me02qs5w0z6/V4e5fm4Md
         rozZqhD9FySNsY2oyRuKIBNuh1sc/mbFy7PZOWjOtCQqqUMDHZDhPrO7GAM2HIKTTbJC
         NZsUDkA2bEw1GieqSK+/+ZDMlGH+I9iUQ+omakDiETZNEV+zgWZEATDifcn0yLJ+IjXW
         0Q7YnWAcav2LbblsKtTQ6l5ZN0827RiX9D0Dj6+inR/gBCjSelLj8xz4zcBgsNAHFRik
         vsvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792776230; x=1793381030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b9U8BJjnSyQLu8vlmMN8CV+h3S1yPSnSBNwOLGcNxzs=;
        b=cAv0WJlkzbHflX85PId8jBZ4cxGcAzxo+hbnFht+aig5X6JL96dKvFRySOVZoyIyVI
         nu0qn8XEVkUkcz4yINJCpDd4spDqG0wYfvpSeQs3C+XLx9lD3mZfFp2KTOV54g6o0etM
         mltMYu5P14N9yu+uYDX+PAZ9NRNV72pZBmzuaD4yaug292P9dCn4Ftf65j2iENIc52Eg
         DBuFgOposBbLG3R1uKD08K9tqeTEVRIlFRC2wUYzhZ4IsCgF/PX+3Tom+unUz1sfBIf3
         /z4WoTpDSV4Z728S9YcpsnNAMyEoz50KI8yYemkjnepiuS+kxDQSDro99wBUDlCwhPao
         l77Q==
X-Forwarded-Encrypted: i=1; AKwUvBxjRiwWhelD7h+BYMITLuVnv2jE0zMWMYpmla1MTn8wLTrdjQXFzTa4O3StMkX4UPl+XM7Tkmfg6g==@kvack.org
X-Gm-Message-State: AFq9FYILPsiyhMssOc2IwlgdvFKI9/DD1LkukexiMtCFAJ6WxSineehE
	ms5hdfnRFFPY37yeTQ0CJ4mpJ9TdUdAvemB71whobx0bafkIl5v70fgF
X-Gm-Gg: AYBFou0shZAjFZkm+RJxBGMnrce0TVej0iflppBV5I7gdqD7niTv9qJco3ajPi5sOpF
	CIMUQ7zjh5cPW/J2T0LDBx6GFc0/nsE7wTYBmRwHexD6QCiNy1LNNzViekSZL5LSrvHjfun3iTG
	N4RzFMNMnB3UwGQvfE+LPFlqfGwSSf3gD+vmTCbeKi+FEmiZ6UKgrUuyEIEBpsiUdkPwKGK4NLc
	B/1IiSgbe3H9Ke+nRF5exe15gWHMMcb3H1kzK6ksT9m+BM8CEU7k1a5vo6uXmt4s5Tl2D+ia2D6
	Li2f+NVDVpDLzsWrjetXqrbmwVnFkX0oZZHtNJr5X2WZOCHwIMysFyk/2DrBlNl1UsXxsKdZg7X
	gO7wUdCHezUSa72YvBO0LDvxLorNdWJofxpuJDs+bZmLmkHxbhWf1AVY2j0lLJNgFtTfxOSbPIO
	3j2LN8sTbt2a9uMhT9Jptr6BHYE0mzU7NYdYRe85HdoqLR6AXGbfa+ljucyTjIwhJXtkP8HgWe2
	e0rfv8Hb//zU8fJ9OIPMe1hvpI3yN8mTMjet879m8Qunh1B0BXHkFckU2YP78zIBQhe4ar3ctLe
	O9JxVwfZBXQIimDWCCbAnCmN/OMV6sRJ4BKBjGEydwe5mxFWvyoVmJqLZtwZX5A4TkQZ4oXazpI
	/wy1UiIhnHZ5TzXbf
X-Received: by 2002:a05:600c:354c:b0:4a2:1197:1de0 with SMTP id 5b1f17b1804b1-4a211cb23f3mr50233895e9.19.1792776229374;
        Fri, 23 Oct 2026 10:23:49 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a30764e9e7sm17932475e9.2.2026.10.23.10.23.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Oct 2026 10:23:48 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH RFC v2 31/50] KVM: guest_memfd: Support getting PFNs for stage 2 from providers
Date: Fri, 23 Oct 2026 17:23:47 +0000
Message-ID: <20261023172347.88443-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022-gmem-alternative-providers-v2-31-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com> <20261022-gmem-alternative-providers-v2-31-5dd1dc6c660a@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 441B180007
X-Stat-Signature: xyx68d7bedsxut8z71higg7hmzyxdt4i
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792776231-399519
X-HE-Meta: U2FsdGVkX187jPUX+NTWVhw3YTT0A0unUE+XvNQoJr6xCfF+6kBPJoMMd+XQIilynqXi1UiAdXj9dvmb5FUIKVUs+YWzTIFCf+qkqkHDKxnvtyDZ/IJnNGJ++SMm12ZRwtwZGufT5AWFgxi+DnBMACH/wBgDsHJyhdNDBdHqNKufMYuXcLQduLJPPhQ58j04Dl4qJ3kbIAAdrTX1yZLtYiQe26cYN4Cd1RfhrHQ7JrtNKZPV+fETJ12/e6BvGPXdb8r6ezfdrMr1STIXRLh1mE0ifRzEuGUV5bkxcmOCn4BKWoDdoFUtI6Ih/qR5/O9yCrsY1xn5ehbSdS/G7kJ8uVINFC2u1CJYUA/d2GeULZpGMjUX11Yd9RE2IABgPCIf05vguHZqiF2KA0Ma5r0JCi25wFPiPPguUdHjY7jScr/oBhxxOfBqfu99CGGpX7i1Ja4BzNjf65aalQqb4qC5VLOZ6+fPybSl622NXehgftM1xQ4NUgIPt6RclMwYgy0BXqnOkbgtS7gRcni7r55Sc1xKvdgMiCSSCEBUrKDmVshrNHr1RhTjeupnltd3bYrM8TPRyyKpqO/WBqTjzBuuoXDn8gdRaG6PQoC83BdxtMDblQa/Q8KW1Su17nd3qvxfkqyhEUFqS0AFzbCsbd2daBy8FuAHZS1KosHqPAFrO6pGkZebE98DRGwgWxLAVzt0tQuLq07PE/W2ytRilfi1P4YpJnUbNWvGYwIuE4/bctLJ34/UEI4Sb5RntPiNBKweRaF6NVLdP2O3UNqz1XLihLuQ4lVa0Vr4sFd71jZLKpxc0G1h6WPEwFYDA+RucC+YZiry7HCORjQ243wno1jzmYct6q80KZ0PQwHbp22nXt/67XprY7w2Qhx85X62soGkQRv0Y/YLmLgtKO8f9lJN/uvGKx0dv88K1MQivmYdXFj2fj7ZYNrGwOBW4pexPYs5JGnVSVs1gx+KyIyNcc3
 7Zs/ewGk
 Sdxv/3VB6hkOpX5S84t/z9hrMH4i1dHDTiM0hy7znL3bqRmHZ08GyoFGTQMPun2tlCiQRvDM/kC//qQHJG0WE9p3wgdVq9UYu645oJQ1zc8N5g3P4VyvxDX5Cv+iffYONI92IqzJXrdWJB8T32z8Z6LGU/JVZATOKIesk4kyMGdVSdzpNq+KB73zU4NxkfELq2gsfuL40Jm4Bw4hyPyXgx+As2CLiVcO97zJrUu2gXKsRWmWvoelqUqOxEZxN8PkpXUi8SOGExazf+1ZkMJdAWi2ELJ4XvxzNDGFL8a04K1Qz5cFMoEFHYheeW5KhgZWM9vwvzI8WdXaMM2Xsb8X4EWIeHu54zIuf1ez7KjSCaJEClIL5RCtK5/tNQJpMT3PI9VeEogou/UTC1l+difPzpZjRS9nrZPv0/fKVnpzudZVqA6baFjrFIPQRj+zJkKq7c+1pvNg295hXKpo2Ih3nZNiotbfPXEsvfD3Yo7vtzJQR8sdEIdzlY2FvC4Uw0rYhHVWQCwb2uVkSDPDK5rI5KhEAF/+8ncHp+qPBArb2uglvH3yfy5DknM9a/ON3SKT94iN2IzlqY1oa5kL5hJ3Xg8jjBeucjnrudtAy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> +	int (*get_pfn)(void *provider, pgoff_t index, unsigned long *pfn,
> +		       int *max_order);

Should get_pfn() also return attributes of the frame? Only the provider
knows them, and every mapping of the frame has to follow them. Two
examples:

- Read only. A provider may lend a page that the guest can read but not
  write. I know you dropped this from the sample to keep things simple,
  but without it guest_memfd maps every frame writable, and there is no
  other way to make a guest_memfd page read only.

- Aliased. The frame is also reachable somewhere else, e.g. a ring
  shared with a device. Such a frame must not become private; see my
  reply to 34/50.

A u32 of flags, with 0 for today's behaviour, would cover both and
leave room for more later.

Fred

