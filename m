Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63931C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D7C6B00A0; Tue, 22 Jul 2025 10:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15956B00A3; Tue, 22 Jul 2025 10:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B3E6B00A5; Tue, 22 Jul 2025 10:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C306D6B00A0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:45:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B486B91DB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:45:10 +0000 (UTC)
X-FDA: 83692173180.20.A4EBA6E
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id BCBDF12000D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:45:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ds4ObM7g;
	spf=pass (imf29.hostedemail.com: domain of 386N_aAYKCIQ0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=386N_aAYKCIQ0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753195508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZgPKLrP/qotO+TNh068TYlpA/4yneLkKMwvnezIBBc=;
	b=grry8KqUy5EYujHqmmb+1xFKSyTfWsXw1VRfKeVbWo/TyeOBqSrxtMcse9L24ao20n8+fq
	A7EA9KEymYmFQdmiOlK45gZglSwRjykE79fJkn3VxzCxg7W739J3t2AblJUBafOFNgmdEA
	WjxE+Qz8fYDj5+coEQYSQ1sSgSOkQBg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753195508; a=rsa-sha256;
	cv=none;
	b=yieHv1+xoIFrDJn1/QzmciMa/GhBNvN+a1AolCjkcHmMg5K1JBFAxZsgA2Fg/SOY9t9Vo1
	4OAB4VroV36Fm5x9VH3sGzVDtMk3LSAzosl8qmjKZsKorxt9GFy4qyHmptQM3f6A6UIfBq
	oFlvMgHaYZy1zf5V3SOr4pzQalUXwfc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ds4ObM7g;
	spf=pass (imf29.hostedemail.com: domain of 386N_aAYKCIQ0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=386N_aAYKCIQ0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31bc3128fcso7295755a12.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753195507; x=1753800307; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZgPKLrP/qotO+TNh068TYlpA/4yneLkKMwvnezIBBc=;
        b=Ds4ObM7gXHCwz8Pcf7oekmQXG4Uj5WCzLmujvTgEgBU9Mz0vgeQzMUCXlmOpBzBsjq
         RC8XLkWG1Qzma1AMx6m8d0T0oaaiBusl8PRzt7XB8kq2VyBSX/ETujZgZBCznO4yyEX2
         GoPxIYgHrgtZ1JyEyiQ5txmtkbUCFsSyueNe8q14zxC75ITELja7Ym9wo/q5aAORg9gL
         +Busx3C73AGioITVnMSLZNyRg30BdWXv/lBdG5PUr50vj+ol4s5xqG8LpbykCwtihNMF
         yYR9NKo3vqHkR4e6o5Q1RCe7c3DlJenixz0LXgkmSI/JrUOGWovyys8NL6oYNaPF+08j
         iTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195507; x=1753800307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZgPKLrP/qotO+TNh068TYlpA/4yneLkKMwvnezIBBc=;
        b=cc7Li2K+Q7OWp3yMxr4o1bzw8WVDX2k+WFzdtozgmiGYcPRKi4AZk1zPjmLSCV9a7L
         0wlFw/GFeZ2u4AdvEMFTeI83WXnGVbZTho7UZ0Ey9/HGvYwLByu8Nodqg0Ydncu6wS9n
         ZrII51Aj/OHrkY0ubDm1EVYYb1bViZ3LiPKa/Z1fFOX34Z8P6tYd8SR8RKS+GzREgIEz
         i6ikuDxoHHWVcyHCanqkjmLVqS7PZVLF+LKbO9aPHZhHc0nQ/TCg9VAoGbp3DQRj2AvN
         MU8TGxxiwbI9+/EZYsglOZiHtrZikIcZl3hDtxFNcIJMmNdLo0lPcOuNZ1lMkGNEMz5z
         08BA==
X-Forwarded-Encrypted: i=1; AJvYcCU0qjgbEBXtGeV4lPv1BpU5b3mvs495P/QWeWDWdjvjNfPVcOXlmh5df9qo1bllwgGMkGG7Bfv5sg==@kvack.org
X-Gm-Message-State: AOJu0YyDJJq9YF0uf4S0Rn8Q0fpAlBJhIcpZXjXzWD76nxVO1c2v8n2Y
	yVpdddeS5i2x+IUuVg99uUUqygmZA5DBWQ8wI/e31rhKL/IuNSsfB2oF6W7161U1dKFr1iREuqQ
	Sl5Ozjg==
X-Google-Smtp-Source: AGHT+IEye6ryF3i4GwrrW44YhrNpbw96+Sg2XleT9SYl1PadbAW/x1ROmWdG2BYhq8vejYeKBT2EUnzq5Ms=
X-Received: from pgbfm10.prod.google.com ([2002:a05:6a02:498a:b0:b2c:4fcd:fe1b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1508:b0:220:94b1:f1b8
 with SMTP id adf61e73a8af0-2380db8e8d7mr31142351637.0.1753195507419; Tue, 22
 Jul 2025 07:45:07 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:45:05 -0700
In-Reply-To: <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
Mime-Version: 1.0
References: <20250713174339.13981-2-shivankg@amd.com> <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
Message-ID: <aH-j8bOXMfOKdpHp@google.com>
Subject: Re: [PATCH V9 0/7] Add NUMA mempolicy support for KVM guest-memfd
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>, vbabka@suse.cz, willy@infradead.org, 
	akpm@linux-foundation.org, shuah@kernel.org, pbonzini@redhat.com, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, ackerleytng@google.com, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, 
	bfoster@redhat.com, tabba@google.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: BCBDF12000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: czts8phn3x11sgmt7wcofagbk1cbg3jo
X-HE-Tag: 1753195508-397814
X-HE-Meta: U2FsdGVkX1/GlKNK3FS2/iQOFBT8M30/xiJk9aZkzV6LZiJDtWO/kP2tbkKpqgL0KSRtFV1+a1ZhBtcE6TBmD3knZwdn+2t6VrO2tVmVMuYWbZ/fAZhZdSbcnGszirnKOgJzjODdsEbPLf4Lv4ofjrbLEngJNgkk1hgbLrmxAHRtWInufyTt1YBuUwHLdP8hGEgqOnH32Ovgbxfh1lU230kqCjJH4ZfSBZsUkUwvMrz8blax2tae2RZP5Y1DDBEuOJlZVfcpRJ5P7vrcc30DSEW68YYyAJuoIojGtyCtNaOQ2usKJad4GvYkf1Ahtch9GCleNSInuYgqPDgL5mIwmlTM/zxoJe7ddnObaOwKluXYOb61EYBs2D5MRvShkrIM9V8f81YbaU7ZNiMS+qfrPJDYKJq/ZPidfmLekE8I2C9s6oRH9toc+JE/Z9QbUUK7lmE+MNk9HwUimxwgcpJTlXVHm+Gc76CZV2ge+tJJonWiW0kPODWu7X7R05zJ33PwTVpMNLviDOJEkx4SRjjWjv3SrnOG48E6C3pcOPTVuutNiwLXPof0EYswVm7f65o0vZm6IoTqNEXgPDmD9YYAhmvltFxMGQa1slqPCMntbkFCh8pirXtzUrXBOAPWIx6FA9K7NHnlBYLgyH1xyVBRFLzskwdKQL1fXQN2fs9H5+SLfbq/IHWyC/MvWMMjreTj5TRXvCrQVenWT1v6hcIzX+DwuIURjuacqRn7A45cqSCq3x+23E0YK86QoOixLYw+o3f3lxl8aTuLf9c9P8IJWY9Rk3Vg7+nRTcPd2W8tVhSLz33TjDU60GHecXPbq9copQEQxyCgZFbF5Iw1DTKmYb4ppapv8haLyq4+LOi+m52Nb4gVyjwFTx5Fwyby0izQ/eXLajHQOi9W8r7vPdeg8ufxaCjgESXlJU0g7OGbO/g2GE9KxDN+lMuoDqaaMYggdRrAfLawRPamai48VSV
 DlXmZ8HZ
 X04prDpAMKJExOLk6Bsv6CfNWuQMRCHz4B2qG6Ha4BL3Ui8CD5ZmNYbxPaI1SxRQ7MmLUPAaiRO6oQdchfuvsn/J+/O6m0Y3hfIQYf31+3yd/kCta1Hdqez9VhbHHQpDoeR5dk1N1ZQb2pfLoonhKvI39hy+5YCFii4f66Jo6EPTtSczg9JufnpAFlaW4AE+Mibss9bc3XsYnbM4cQF+R/f4fgghj2dhpb2DD0W2Mb0xKvj6RZwobQVcRLLa54QXMSFxW9liwQo3zHZrun0kA0KQnpOKd4SflRlMD0tQFsqk3R9ncsJnuXwoorQCZ7fMfWM2Nifefb6MMccMRBAtBG0ZJTEFmVOzIhKGS92/Da3G+cGPTgoP/Ms0mcFAY7a6E2hAE2dolO8abuOvaNyuZfr6KO70NNTpmHNTqrNi0jXaE++XUaV2QNcL4A99qY3tC/iF7JUY7Xv5e1jCM6ravHSQgQRB26I6/v1jn4IZJeP+dFjfsTpU7/Kca5pMe+ZaogLLB0ZS2D4w7Be2wL0jrdyzQrBHazfsqcUQHK/aQtBNnkxJWEDJSQw7ZdLJtx5SiVGID90BzlVjdbeZD4re5ewN0kkG/R/TDi7f0o6LZ0jnfODtyUrhAx3H4/j68pvaSoeJ5/mBFCEy7mdvGF/O0WRMrCDO81rz09nVk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025, David Hildenbrand wrote:
> Just to clarify: this is based on Fuad's stage 1 and should probably still be
> tagged "RFC" until stage-1 is finally upstream.
> 
> (I was hoping stage-1 would go upstream in 6.17, but I am not sure yet if that is
> still feasible looking at the never-ending review)

6.17 is very doable.

