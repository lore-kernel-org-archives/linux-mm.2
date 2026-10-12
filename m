Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19689CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313366B0096; Mon, 12 Oct 2026 11:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3F86B009E; Mon, 12 Oct 2026 11:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA5F6B009F; Mon, 12 Oct 2026 11:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEA276B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:07:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EF8D40F43
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:07:21 +0000 (UTC)
X-FDA: 85314302682.09.DD6FBCB
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E9A5100008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:07:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMyRuc4k;
	spf=pass (imf14.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791817639;
	b=0fVE3AWbiwxJHmc9PXqHBITBasRPL2pX28j7x4UZcX2qyRURYCHd0j5ZFv+srMukOf+MsA
	2AgA3VNhXzopxuYCnfSDfEDfLBTRLkxYhRNMb+e1zYvf7yMBV9eeC2/Bmgai+xxnzChwW1
	cotGyLks5TRVjLL1oB1SRRiZSmLeW+4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMyRuc4k;
	spf=pass (imf14.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsVU21nxAD5GAzHrBR7QE3ds3Y9VaK8s6sj4rTQ/imc=;
	b=0KxJDJNQ9/1eKRKwsycbFcC9RKRgjZrXUqz8XsmRxVKYwhApeOXqb95blBp55971gniNvn
	9uoBSKuTL7NXsyf4ZgdpzG4+ebH/zuZHwQRdPNXpvDPQ9j/OEeOpufwmUfSEhTda/OmXq5
	DOnksTOQe7OcbCwCj15fk2TUJCk7NJA=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-486e8faff03so851608f8f.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791817638; x=1792422438; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tsVU21nxAD5GAzHrBR7QE3ds3Y9VaK8s6sj4rTQ/imc=;
        b=CMyRuc4kHFxtSZEbmS3K56mhF6eT00JwBIEeLVUuOPzDYUULrfqDd4X9OzMi5O2d9y
         m3/Xs5WcqC0kDvXAUw4yFR/Y7PoUzou8SyEBztcs7cTKSM1bYTMBqgHwCIJBFmZv+1M0
         hCXT5b57hNwhr6MyFyhADCAu0Anc1WoHQEFn0Yb21GviKOGMTp5JUSjlADR8nA/cBe0l
         KxWqmgfr2VPNWmgJP9S0kjxBkcsAUVISGvCObZvJWT8S2ZrJK9pmE2WB5WjVQIjHtH/B
         M5PkNaHOuuf4Pab3Q1OZ0GI/LVhkcVZILLLbXvYUrfJ+nBTshAwi6hTGqa+0itwhMerB
         Dv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791817638; x=1792422438;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tsVU21nxAD5GAzHrBR7QE3ds3Y9VaK8s6sj4rTQ/imc=;
        b=VWMJQzv0DBBNMYjO91PPml/RE6xGC/gumR3fUnzKo6oa2bHwUzyRr2VomhkquZa+Pl
         pc/xAWmPz06Te/RFZkqPF4KyoJ1VCKWtSt8ne0zjxcPE9VpV8k1O414v+IsJQ5+z+eRI
         pDMQ1VVGCAi3jU8OPPDxySiu2k6VPAOznjsjzCU99RIEtVH5WsG2fAlcO4dctb6IOurf
         hRRhVDFewtTSyPvZjCcnZCgmdxEZp2vFr1jTdYaGZ9d4eb6qBQFXTOSZdb1bv0UERN1m
         L0BEx68nQUNz+P2xs5kh1/g159jsYBtF37sPtkh4FGkUioRohsY2OzueU6WB9HB/eADT
         Ca/A==
X-Forwarded-Encrypted: i=1; AKwUvBw2wn231v7NM6nc8xgFHYpxzVLSQVsMu9K4fUSrNnlSat632NiLIJd2/ym2lVjWOm5OFU82nQFPjw==@kvack.org
X-Gm-Message-State: AFq9FYJNbpk9vqyYQtDu2Y/dgTbCGC0yvgSNS7ZH6YbezUvq9FpMOaFw
	XJA4E/v8wm0mZbau4bHqbpB4UkiBDN2B2KQYpL07Rssh3eLwycXMQxbh
X-Gm-Gg: AYBFou2EOL2JwCJ1rqai/mdMS1sjrqcegqTl5UyB1x816efoo5s8lz8qn+yOxwSrTW5
	VipYhSBLV2JfUd5nuze1mz/OFYDJiwSEl5VQNBIYg8wWQY/N9q6ZtZhArXi2JdGq4/JE1hVT9id
	BwL14mCwWCwFQQenvIZYOrg5Cc6OlcyAHmI4jmTgXLuqTzcyznP8HlNPVWc3GZtBly61MBg3eqx
	BfEmUyZ3V/5TSCBdCGnzXQ+0X5TmvlXCkJOlUSu7r0keIYW+6RV7t5tNxunbuLj7ZVTyr6CFWbm
	FbaFYHVOsf75A/QfZVN9Z+80mtWcBjojmJCecGKWHwha4kaOGmbzaWboNxJqrRtu3/ojVRsCLBd
	eHcMmYOYZxHqjgPp2X9k4CNID0IWoyTTOD0andXNROuNcmnuEK/tCdfIZezSEIyHbS3MFyeHubm
	gQzey2Z33X2pmAI8LepNPP09cDwArKwG/caL8jsN57DJUhoV9VN2VgU7cOZhGMHQm3aehXhXCvj
	8l/fag0bY7TciAngwS7M5ByKeJrvGsy5ceML+XCel4ggfpbiwwXJzzRO9Y3WJbAAf338ncRYoei
	J0qSfDm7UAn54miBYh3A1bT68K4RQ8tX2W+nEGE+K3/Ixg==
X-Received: by 2002:a05:6000:29ce:b0:48c:6fa4:fc89 with SMTP id ffacd0b85a97d-48dbaadb050mr12203015f8f.12.1791817637606;
        Mon, 12 Oct 2026 08:07:17 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48ddaefa06esm3451088f8f.20.2026.10.12.08.07.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 08:07:16 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
Date: Mon, 12 Oct 2026 15:07:15 +0000
Message-ID: <20261012150715.25132-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAEvNRgF1hMz+4ivH6WhsEOLTJGOegYO9AYK6OByYysPp_nVJ=g@mail.gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com> <yq5ald8680t2.fsf@kernel.org> <20261012095800.50250-1-griffoul@gmail.com> <CAEvNRgF1hMz+4ivH6WhsEOLTJGOegYO9AYK6OByYysPp_nVJ=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E9A5100008
X-Rspam-User: 
X-Stat-Signature: ykr493q3ta457511a8ij9z3ab8s8ybws
X-HE-Tag: 1791817639-724398
X-HE-Meta: U2FsdGVkX194HGEYM8oquBNZDqN8FNrOG5e1gMj9jB3tBhJWnJQ3AgJf+Q5Rrns7nevflfQdM/llNs1899hS50TtIO0CMnQ6O3QxAvATBpEpFyhFvaj6qWEZNIZvuZvvpCJiKoA3Dz3kg0ICsoHRYATYEqTbnDs9MmZagG9v5B9SPrmhJxc8U1nLlMiMSQxG7OAfb6tVD4gsLlhkcf0V+yN2C0BG41XwXVKOvvOXR51V5+q1CptkgzW7iSQhc9kOT0AH6aYy9mxwnOKxeb0SUsYvzZmjaBNbcXyHAPeDjhTzuvBzWy8FhGQfTYUYUfkKO+1uhCpC+OPqiCbRdSYs1Nt+FOlpuCLxr2TcSWvmWguv5pF4+Tl5bXyEV25BSDDCpbJPX1ethNxdJDBI9QcvDVuJMfcoixDVSay6LFsVcnKreyACwlZqA6tZjm+wg0+jSVxvQDF9SXaJ6M5cFebhcUD/Eynspuu7sNW7mTh/R6B+RbdXPT2+MoOGk5TJbpzbQdcLItHSTLLw12e/JGLUzc/W0COow8S/jPpY+ocAkIddtPluu4OSX+En/c9CGNq86gRqMtXu7RXy48D0oCaD3bjuWEYbZJgcMCnXVibGk1utkr/YzKigMrWaIA4+amEcaNLmWWI9IqcE/GtgN3UXMiR/eLV79VGh835vWpIOYp1yaxXWWm01eCLfV9lA50P3zGLh9RCjTeDSwUlFoYlQjouU+wvA6/Ay0YVy/1fXuDht07tceXQsOLrWEhu4J2eqVr+LAI0lwzWsfJfCdUFIoT3+jRbW6AYt/B0WaGsOcJqHGU3Cjl3IPSkVPWf8ZpnamwH+481a87Sk0nai4rI/DJ+YcQxPpkleMVls/W3ZITkFbQozVgmW3aooxRBQmj44/tJ0k941zXV8h6nlWBH5SNcxghkSaIS7gt9PWhS4axf6GSo4J3MnZFUbxK5P6uKqGRVIVnMqUsWl2ZdFC/G
 h+G8KOD7
 VSVDQ/JomRmj2ta3K0h4YM0Feqltn6xfgk4HRIzvgx8fuqCpgcU0ezlcOezfwyufBp1ptFHQJ3EyYWKsU7vBPU1I2l4oROgATSbWUi4XUBeaf1+osxSpfamaqPHtQforcIj8qO4rz2LFK6SmZaHpvROTumYifW8hKVSn0H5JGuyHrJkFAQr9kd3ZemYQKw+q6UV49bVGkyJRHUr81WJYoTL2XPOawohVlUsxkNT1RydwtvlY2+rPqhVHnktNjGVKLjI2dnLT7Z3E/UcucnJIzP3F7EWSYUcCWmOuKrDfd+12CkyYxyv/j1b47OGwnOTOFL2hA2zmAk0gjQjdrzq/NBtxQl74ZeVd2prkBjHMxUzmYQJlPCyOlgwDYObJVTu5zpLl0zxLzC1ZTcK9j1XmEPnxYkbjrmtpSXP9J0t15E9vStllhqiCJ50D5HQofenHA+PF7TVrnIBzqp+1j+fFzcIVYMzCkDeyFJjsogxqmV1NiUZQtLaNbXxA+KxyIzDt+TEwZWjUEav23xZHYnj3Cr7w+ZPs4+QIMkoD3IZMLFeFOv1UVKyuBopYvjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Wait, is there some magic done to make struct pages represent different
> frames, as in PFNs? In your model, the struct page <=> PFN mapping
> doesn't stay constant?

No, our memory has no struct page: it is a carve-out hidden from the
host with memmap=. I meant the mapping from guest_memfd file offset to
PFN. The PFNs never change, only which file and offset they back.

> Do multiple VMs map the same physical memory at the same time, or is it
> a move like below?

Mostly moves: a page has one owner at a time. There is also a share,
where a parent keeps a range and gives a child a view of it, so two VMs
can map the same frames for a while.

> I'm thinking that if guest_memfd wraps your provider, then your provider
> can issue a revocation to guest_memfd (ctrl-f for
> kvm_gmem_provider_revoke in [1]) on the move source guest_memfd inode,
> then wait for an allocation request from the move target guest_memfd
> inode.

For the guest, this series works the same way: the provider revokes the
range on the source, and the target's next guest fault asks the provider
for the frame. Devices are different, because a device may not support
faults. So the provider also revokes the range on the target once it
owns the frames, and iommufd maps them right away. In other words, a
revoke means that the frames behind a range changed, whether they went
away or arrived.

> guest_memfd is going to support preservation [2]. Tarun's series just
> preserves memory from guest_memfd's default provider (buddy allocator)
> now. For your provider, I imagine the preservation flow would preserve
> whatever metadata in guest_memfd (like the attributes in the maple tree)
> and then go on to notify the provider to preserve some range of PFNs (or
> folios). Your provider would then basically do nothing, since those PFNs
> already survive a live update.

Yes, that would work for us, as long as guest_memfd does not also have
to save the offset to PFN layout: the provider keeps it across the
update, and guest_memfd can ask again afterwards.

Thanks,
Fred

