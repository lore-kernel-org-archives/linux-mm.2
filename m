Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E110CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CC26B00A1; Thu, 28 Aug 2025 08:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D236B00A3; Thu, 28 Aug 2025 08:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5166B00A4; Thu, 28 Aug 2025 08:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC5F6B00A1
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:50:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD3FD138AB4
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:50:19 +0000 (UTC)
X-FDA: 83826149358.02.1FD1756
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7DEA5C000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:50:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aruokTaf;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756385417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6iCBik3cJC1ZHjD5Ysxv05sd4NeodNwL7TaQOabYOc=;
	b=6GZ9ioggERZck3PN6861EmANtwoO+hEwG81nyKHQ4hCVlpdmKtqDd0Mj5QVCRllSm9vSLf
	6ia0/ddYlKeVjAt00h4LG99DZpb+DQWnMfqF0cWB9Q6qqa4FV6ZusgHD+avmgBtZybnA0s
	4NqX4wvqICqdELpYKuLgpH8LPqGnt9g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aruokTaf;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756385417; a=rsa-sha256;
	cv=none;
	b=CmFb1BiCBFQOjfclMlr+UcU91lDRepA/L3Qm3x2B5TflbBRk/VJqc0YTAp6qESerYH92nc
	1+A9w3odX2e+V9I/JacQ7No8Gjauwvn1nnsN2SbZPMGKSiEB/a6uUEmFFIVsz0whOEVumL
	lI8vLR1DLKjq7XpVoiyu78gRAz5qJKM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756385416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C6iCBik3cJC1ZHjD5Ysxv05sd4NeodNwL7TaQOabYOc=;
	b=aruokTafr2v2Fmm28ssyUu4JSW0VmA+uSAdALjQWsmiFZNWfVsD0x7qljaFpYUpDXS9aJ0
	LgBKdZ7+K13lQJq9xkbheGH5D7TMmyh5XqzOZ69s9bfKSI6wSsksfkFIIAJTbq4DOiM5OQ
	KGPuAU8pi1WitLjHlOH+jcK0xMFU0jo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-aTvhWDHhPbOvnOYt__4hWg-1; Thu, 28 Aug 2025 08:50:15 -0400
X-MC-Unique: aTvhWDHhPbOvnOYt__4hWg-1
X-Mimecast-MFC-AGG-ID: aTvhWDHhPbOvnOYt__4hWg_1756385414
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c7aa4cf187so636710f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756385414; x=1756990214;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6iCBik3cJC1ZHjD5Ysxv05sd4NeodNwL7TaQOabYOc=;
        b=A8Chu2rR0ukaSX7m0ZWXtv0eFqqi7Rb+et4mMeXLz+rCR6GXLDErDhMNfxMeeH1UhC
         1BCDOJjv5GRhC5NlDpE2f4gC6KcK++txzxXj64mNlsYMBfFlBNCgWD/MoaWat8Rcd7Gn
         uu904CVY9Q5H94Hz9O/8JRs7jMRoDpABtt4O5A+BX7g/DVYOB90v6gyWGp1tYNTyIeqR
         7A6jMIIJY2zCWFTodCuQNn5mMskBypV/JW3Ovtf/cqflfIS6ARGEulfRqH0xKxg6H9MH
         ScY9bLHF1mFsv9JeN8Gq6JUBNHpPLLTOWh/i2Dmrm5jwscnom5p2ZG/l2Wp1SCDCLRqB
         i9VA==
X-Forwarded-Encrypted: i=1; AJvYcCUnqIq79Uzgj86DPJ9BOwx9RNCkN4FQG4yV8zNUj+Cavtyh+DmaOx/pn/uscI1Kd+upMcUABAB8pw==@kvack.org
X-Gm-Message-State: AOJu0YzSyEY4Fqp2lMwWS24QeRW7Bjlpvyuycj1+6EMmX8z+qcQ8u4Q/
	5zGOr+vDaswm2BLS/fpyHa+CspnOfJ2s5+DMPQ9EVVU1HB/TQSTxnThoshVZnmbc5zyTzNq8uWS
	c+EoccK1Bp3x2Qww5TuXNMu2r6rvfpTMhI570rXwTS5O90BapWsue
X-Gm-Gg: ASbGncvuTYKcstj0AvK8/QqFMwyVSMktOuOplxbIX5aE/9akJYNxEA2G/K1xHELAed8
	JWJaMtZ+SHbStjHDJpAYYj05ffGXB218dXDafW4O2PEA3usubq7hsTk5Pi6/vYOUSyzYaVEmGR9
	6zLeXosCPqAiwN0O6cOCS15aw16EoyXiQ/b68s/ReOjR1Ah1qqcXH/sptc0lBk5LWJkavSOcTDJ
	bakdTcCfNoCmADbsX94nAVuHeOce9EkYjLVP5KnE/Je8DJI1Cf6ULPJrgR6sJvo9FZSBvkYZloS
	i1qmdNcALv2Pk9FXtRrpQEhpWhwHdK3SQWi01QGeCfhIZyZTl/OiEPsV1cpDrHDP2CMTXktmMkB
	VOFjvHYrXgNms/cU44aKbJCfuSQUJ/T7QDNP2MgVTnogfQe7JviKyuX33tlxjSFDzjv8=
X-Received: by 2002:a5d:5d01:0:b0:3c7:36f3:c358 with SMTP id ffacd0b85a97d-3c736f3c59cmr13147599f8f.32.1756385414265;
        Thu, 28 Aug 2025 05:50:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2soHNJz3uNCh9kCpxwV5zoV5iezSYMFN+6bV3UPfCImuAc7IMpQupU9NYnIVeAMq/TCo6Vg==
X-Received: by 2002:a5d:5d01:0:b0:3c7:36f3:c358 with SMTP id ffacd0b85a97d-3c736f3c59cmr13147562f8f.32.1756385413775;
        Thu, 28 Aug 2025 05:50:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba44fsm24519526f8f.5.2025.08.28.05.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 05:50:13 -0700 (PDT)
Message-ID: <a777f88b-ea12-4aad-88da-2e7011e151b8@redhat.com>
Date: Thu, 28 Aug 2025 14:50:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] Direct Map Removal Support for guest_memfd
To: "Roy, Patrick" <roypat@amazon.co.uk>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7qqF0faNTQJznS_1Xe-Zpg33Wz88zXdDWFoU0ucoCQU_1756385414
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7DEA5C000A
X-Stat-Signature: ydgsic8r7u446axuiysp7n339onxjt4j
X-Rspam-User: 
X-HE-Tag: 1756385417-924170
X-HE-Meta: U2FsdGVkX1+KrtfvhSvBlnD6zkB1kNH9fov39gZMcVS/ZgK4MZJjxGwj58fR6v48iQ60tTjupzPzeZEQa5Msf/OEKq66F5Dd/dsx8iaFXlEVS9/IwW+4btBUMIhnRbu8gO81OPuZfK+SKjFsEYybAmaiVH3Ziih+d5qF/pYagm3rjeeu+tnk70EEctP0sXA9okinmY0OFZdekQyiReu8JR/jW2BxNqxLmEGZuz1AJCgFpsNti5NpvciS50c95M8UQC7W9gSUiTRNsC4JG1ezmP3oR3PyAga6utLBVzNMfqDhX3zQCJkcu9QH46kJ1Blyzf9QZAlK3SBiC2Z2Zg7VMrg/YMvzjfbQc37Jr4l7+6mSRqEradDLe9aPftlsL+AMNF7axXpFKPaTRm98sPEm7UoEm4zah6fN22U52rvgt+ftToxpSVS2wlGmDuQR4G2rp2FuHwIPqkyJ8sl5tuJuV2iJj7vTQTU0c8VJK79Q4LQHozZOq7AH20Yv3c+leXuXV315CzoEfj0sWoZF59Z75PzaC+CROL/0kYXlt6cTVojt6pIuGURxvicJVVz//Yt7PBpM27cuLN7C8wSCEw2M3qB7cz5b/2WiVMGKx1Xx7QSEB59d8529b5+rWqBVKoND87SdliPg0FwgZhFTT73KVh/+TB+uF7CIUUBwyiNxg7gAPOeLrhzuvudKVZzhm4gP6TZwm076f4RkY3+wFFZt/Xb50NvWQyrYnPgnPc/r6mKEANaJv1I9TVvLD+acBX+sDsKzxz7VV48gbkhvZEaj6W4dW8wEwkhnAfXAOr3gfVFSvTdKPTKNsXh8uHC9Xs38SVPiGBpznDtnTSbMHUVXgnRZbL4aeCCnJ15WOC2G+YlWA3B0YyQ/gxTaHWfO3Dnc6MIjE2/4r3GmZDZMqhcUnvt4iy+SEIFCEQ3vE63ThCdtJq1KM0pHsIj7gkS85Wl7fyf+mfHDnBZOVJ0q34r
 ReP454s/
 IiwXiP/uPz232blECiMZLjqgXHYaSnFJh8odWWt0wYQ0MnWYPgLIICZWljuGbfgOKYF4w4sC0HH5K+tOoA5BFYnq5q4PgaGYxLiM/ML5d/LZLFZ1FGDZBmpS/veh8k8WfrgQj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 11:39, Roy, Patrick wrote:
> [ based on kvm/next ]
> 
> Unmapping virtual machine guest memory from the host kernel's direct map is a
> successful mitigation against Spectre-style transient execution issues: If the
> kernel page tables do not contain entries pointing to guest memory, then any
> attempted speculative read through the direct map will necessarily be blocked
> by the MMU before any observable microarchitectural side-effects happen. This
> means that Spectre-gadgets and similar cannot be used to target virtual machine
> memory. Roughly 60% of speculative execution issues fall into this category [1,
> Table 1].
> 

As discussed, I'll be maintaining a guestmemfd-preview branch where I 
just pile patch sets to see how it will all look together.

It's currently based on kvm/next where "stage 1" resides, and has "Add 
NUMA mempolicy support for KVM guest-memfdAdd NUMA mempolicy support for 
KVM guest-memfd" [1] applied.

There are some minor conflicts with [1] in the "KVM: guest_memfd: Add 
flag to remove from direct map" patch, I tried to resolve them, let's 
see if I messed up.

https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/log/?h=guestmemfd-preview

[1] https://lkml.kernel.org/r/20250827175247.83322-2-shivankg@amd.com

-- 
Cheers

David / dhildenb


