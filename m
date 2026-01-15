Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E2BD46606
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6E56B00BC; Thu, 15 Jan 2026 13:06:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151656B00BD; Thu, 15 Jan 2026 13:06:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D996B00BE; Thu, 15 Jan 2026 13:06:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB17C6B00BC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:06:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7A27B9792
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:06:14 +0000 (UTC)
X-FDA: 84334977468.29.1F95EF7
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA9A64000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:06:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4SK96QaT;
	spf=pass (imf01.hostedemail.com: domain of 3kyxpaQYKCOIWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3kyxpaQYKCOIWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768500372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uqUPVaTEkff6wsfE3L2bqEiARCuGC2uqb7juZRSNZw=;
	b=3tJv4k+dGhKUMHR1S3OXSbQ+YJcIUlqn8wS/f61Ydh/dsZMDKwzKReufX+4U9am92h7Xnn
	YCMffJUtzgLk7qY9UBdO0jbtjhL2dV8/L6pRM2+1SXE3qEQpx7ZJd8O0kvY9N6KIIP2RZU
	V1fm04BL8ewwvlA6qJV/Mr7FN8v1Grg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4SK96QaT;
	spf=pass (imf01.hostedemail.com: domain of 3kyxpaQYKCOIWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3kyxpaQYKCOIWIERNGKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768500372; a=rsa-sha256;
	cv=none;
	b=PARf9cqHuZc+QAKHbLmqFNFmYbv2WH0AJ2SLFOUF8L2SZs6yjbKGd8LJIe04734+MHrJFK
	+1L8yl+JUfoxc0eOWmT7Gq2ZI5+hhm4aBZ//56A9N6J4LCC7tGXgDIyvPHVbPyNDTAyh6C
	MTx6rd1Bc7BB0Td64siJpR4b73cyHao=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso2165342a91.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500372; x=1769105172; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1uqUPVaTEkff6wsfE3L2bqEiARCuGC2uqb7juZRSNZw=;
        b=4SK96QaTBZ2PCyBxK6b6K4cvF8c9aD10MNL+Rqs/JBNENRZmehDT9iziEG+hJE7I8d
         1eA34zfq7pB68SVYktDQ/HdtVhqXnd8fcPcexDt+ZaLr5ECmxgtZWN8Vqs7LTxDA7PU/
         Lj+Q38NlTrPqyaMlVgUih8HGwjCUr84emPzP8rzTkwqfMRLbbh5GwD1bM8NJSIMAxrqP
         qfGpMYoN606jlJbMrCLL1+bkIdZrMnXoBFQ9s2KKfLMUX5AuZdXWmafc2iBOn88cT8vP
         hwxNI4vxycoSmC+lAXnK1PGA01Za5eBQo4gMZc/2VygFL6H1WanEVhA3TbruHdthX7kV
         xrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500372; x=1769105172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1uqUPVaTEkff6wsfE3L2bqEiARCuGC2uqb7juZRSNZw=;
        b=PgoUwZavUnF0M2svz3JulfGBDTQEij6mW1eZHDrxGQ6uXwZjvJ+lU8SE86W75a0Wzg
         qunQtWC2zx9Eye/kC7rALEttzcaB+iViyqEIQ7om/GzFd+JcZHdne8+N478kV+8D8qZ+
         7zQ8e6qPLmdzlVn6/EGdE07FTMAiixB76O1rPKCW2PiVyipRhw3ENAM2eUJ9r6VWBhAe
         hNpTM9/Box50r3w0G9mFzU28UpJEvoKaDaQokim40fB75i2Dpc6IO0t8vBPLk6yNSz63
         hruM/tF6jTHvZVFKit8Oj/HnLD0VLNcNlmdggN/ojfJS366Vac2M7rAzlSUHCdUX/kup
         pvYA==
X-Forwarded-Encrypted: i=1; AJvYcCWOOgBjNvw0Q8axI0gEYgoMnqjZuD5nQDjBMDNnCVw8MSWmr7wkFReOQDnDPV8h2H+LHewwYNzLcQ==@kvack.org
X-Gm-Message-State: AOJu0Yxvty+msEC6OAF9hkhxm5H6tTH/93oGFQuuBjuxoeKFKkLxkrXJ
	ExEh1fTv8kdcdRo2bvzASVfrVBHaUuZK+MRCdovALOXRkjzxhzy5xk7uxp8c00nT6Y/wpgmPhP6
	y0EgRxg==
X-Received: from pjzg6.prod.google.com ([2002:a17:90a:e586:b0:34c:2124:a2b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:37d0:b0:33b:8ac4:1ac4
 with SMTP id 98e67ed59e1d1-3527329c896mr168776a91.35.1768500371573; Thu, 15
 Jan 2026 10:06:11 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:23 -0800
In-Reply-To: <20260108214622.1084057-1-michael.roth@amd.com>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849903000.720660.2401438098975748028.b4-ty@google.com>
Subject: Re: [PATCH v3 0/6] KVM: guest_memfd: Rework preparation/population
 flows in prep for in-place conversion
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA9A64000B
X-Stat-Signature: tfjxp1yre7e4s7g4zfnxd5r4uiyw61dy
X-HE-Tag: 1768500372-459749
X-HE-Meta: U2FsdGVkX18f3yPDQgvRwxeIg9xS0X6KBKu+MBfN46KJ4xPZqLMgUT8WHdUbqMOY3OudFYIws0wRfhh9LXG4OT3xjafeQyjHhjLSgS3s541Fe5foQ9PBAd9KHhrAXiR3Kigev1zLZ0zyx/kXdfDz3GnMnKC5rmDXkekIZWiD2Gjd9Eg42kUfhuNTiiu7tpuZBqYczesDihKCWIrGnOZwIz2vCp7ExyFm4BZsg7/lLU9qUu5NPB9fG9YZRpsk0jmWWypsrNTHd6bInl8MaSpwYBEuv7hjXdAoRKQ12lMN//LAljG/R79jNqmafTtTVsFu2WxicocLD3aeCGDd6dP0B9ySy64ey5KARGrBoeEv1zVOMIxJfxl4yk1e7qLcQK3j6ghdR0nF5aR+ib9L0kKZwdHi4DpZkCnka2sSfDMJ09Ki0hm2enx6VotOV3DN/7CgdrtVLtW75lPyq/1T+Q9Pxt3OzuNd1SxsZT6wuXsFHbIniQ+vgtaTlMMlHWE6rMFOsMkGfPnVdeauLTFcXJTN7yKxlyxsNbiHnzd1HVHhMRz/TMrWIKrWOLWY3fCD7q1zxySJemhDeyMyjKSyi1UwwCyTHcjhjUId+AIkIE9k1U81HIkBlWwba2Ra328EvxI3E5bZ1GYRuDxlh/gOTa4QE/pxf0VCUMPfxswORGXGDpb6rnQKStTSNLdgtbP8eE929Hqy39BW7ycrD2xtHC4WTu6efkb2alCAFkzSW4PV9cT9JBS/hrWL4RYOVrK5LHx2aT5yeF7RpndAQIgB9f984iY0ogjE3Sm3jlE7zYO/7//LNf4zb5pW5wJCOi3DezUki70YlgMxyMB9m4jEeHWing4r3RPR3YTmtLNOnnEz5NqNiLRaYZay30wVocC67wJFtrC7kyOmcYxt0mqIdTrdILl5+hGNUd2on+ZpiNKQcOmTouRgoJuxdHYxOAKl9bJNiMGLVer0jaa3xkDdGMB
 89F8XSv/
 uqE2LA1rTYeHtLKbJ4266EhSsMlhhrCzZ1Z7f5PFDjXERjPTQf5O6Mmef7kMZN9zfvjbAwAXcC8gXWKuGM3Ox/zKZR/MQgEyMd75oQk/ZlGkirdedwSku5PkjloLRRimz3SYeK9EFMhYIUxL9XovnQZJifU0h9VVDNei0Q6QYrU0ZH7wr7jzCz6HWarGA5X+EOe4YeRVtaSuJ7/M2B3P+RTFOXPhuaeH1HjijAi3k1JP+oyGRJkiEfd0ogEi2rclxMB34NzYYBAgp1Q/MJDIbiD5IOhfCSKRmxWleWROZPuuy83u7lxgNRGnTfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 08 Jan 2026 15:46:16 -0600, Michael Roth wrote:
> This patchset is also available at:
> 
>   https://github.com/AMDESE/linux/tree/gmem-populate-rework-v3
> 
> and is based on top of kvm/next (0499add8efd7)
> 
> 
> [...]

Applied to kvm-x86 gmem, with the tweaked logic I suggested.  Thanks!

[1/6] KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()
      https://github.com/kvm-x86/linux/commit/60b590de8b30
[2/6] KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
      https://github.com/kvm-x86/linux/commit/0726d3e164f1
[3/6] KVM: guest_memfd: Remove preparation tracking
      https://github.com/kvm-x86/linux/commit/188349ceb0f0
[4/6] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
      https://github.com/kvm-x86/linux/commit/b2e648758038
[5/6] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      https://github.com/kvm-x86/linux/commit/894c3cc35b89
[6/6] KVM: guest_memfd: GUP source pages prior to populating guest memory
      https://github.com/kvm-x86/linux/commit/ba375af3d04d

--
https://github.com/kvm-x86/linux/tree/next

