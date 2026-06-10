Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4A3CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 22:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969026B0005; Wed, 10 Jun 2026 18:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940BF6B0088; Wed, 10 Jun 2026 18:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856316B008C; Wed, 10 Jun 2026 18:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74A096B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:23:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10925140325
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:23:21 +0000 (UTC)
X-FDA: 84865430202.08.C393051
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 183C440009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:23:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OmxV9loH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 31eMpagYKCJwOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=31eMpagYKCJwOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781130199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98nQEvZDyKKcPdn3AcVzWFv9XYmn8L+0P9K+2v5L7Fk=;
	b=AR83Lu/noxEKILPwPi0WD2T5dJFNFDIMCuC0mcHTcib9nKE+RWd+jVhIxBlI0a+3lc7eRO
	tVwfbgN3qqX9aSsmN/jdNPVb7Z86aQpC6JnT3lwDa6AhoO6hCkzAELMAvvxnB3JhiuRPyl
	Hq5fLpp54x3zGLef/bemRv/SMqG55wo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OmxV9loH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 31eMpagYKCJwOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=31eMpagYKCJwOA6JF8CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781130199;
	b=yJNdj9eCtoeUz3TorLjQ8NZvAtB678K3o2O7lY7WPBlFGgMJl8umnghycL4NokFRZE9v7Y
	XlO3vxQKb6ASp70OiHw2uwsx2o5+maF4TCKgDBDv3qfVHyJDtvt4gDNQ+cfxlltUw/59iM
	As7q0Siq46Qmjl5kiXKutLxUcn19hw8=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2bf11699875so3294815ad.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781130198; x=1781734998; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=98nQEvZDyKKcPdn3AcVzWFv9XYmn8L+0P9K+2v5L7Fk=;
        b=OmxV9loHUrrNdstXIporR9mDUvKU/k4fPKl4jUfD2yl9HRpNaZJZbcn4a3g4Tc5W1k
         yBt5k/ZOmthrAGHP6bih0WN+ZlBEr8h9/pWod+CvjmWSxcW96/DdDQ2eDl9o5d3JgQDC
         gsHj+3Uvf/ATavwVjrnFPZWv0pTZ/eyg9Itsr+zn3WuC89QvqI6ApLVXBYViyFePfBV4
         zE1aj15C5ve9poNyQMOg20/r4/PZ5Ay049mTsKW+hLcGIC2VXZq/iBTlRLR8eG6nKb4v
         UckFk3hxKPCwXdzVCXURYgPBYTyHyLIgbokDnNjXS/hG/2/VRh7zq+0togwtXZmb76a5
         Rvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781130198; x=1781734998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=98nQEvZDyKKcPdn3AcVzWFv9XYmn8L+0P9K+2v5L7Fk=;
        b=f4eecN1LZiyfCnc5gKDQoJWkTrDIo36dtAVf3ksXO36Mi+hKtqqDiX1LkZYLXeXnKv
         +9q/tQQT389I6h4SAkn622myA4GbZQRsEaWm5AakbyYte8rFtCyLz2KNOyOBOM2MPFYo
         PpQHYT3k1GCk5xvi5UQFEzbdzOSpLQJUr3nZ7SxanjwZdxLBt+o44M/d7g51GSXmgqk8
         P3EkQAiuslj0byddfPod5fdealg4fiQ1Sh7wRlleaWR7CQUVX8QoGU98uJy+tovmzxoV
         uc07/iHpQZVdUbuiOUu1VuO0JID7BXwx/czp0AVRhMCSBKyeJtKA9soUnEH0AlDE7iQ5
         cAHg==
X-Forwarded-Encrypted: i=1; AFNElJ/X6tRRth3MXQUpeQIFGbCSRacQrkAYidPH4SiVJrsp48gaYBLgkUO4uZL2hvpnoCXuTUGXbGh+iw==@kvack.org
X-Gm-Message-State: AOJu0YwWdPFWn3cv7l8lJDM0RLBCHb88WNVCwmtZbfvOlU2L0lEpFIhl
	5PsZTezsY5pY4AV+LlT1EbFTaP7Sr+XHqSyyLD8UEBgRVfvaC1yNwYFkTyXLScmiKDqjj/zYYdG
	IV/0wmw==
X-Received: from plpv10.prod.google.com ([2002:a17:902:9a0a:b0:2bf:224f:daf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c6f:b0:2bf:1aa9:6c8a
 with SMTP id d9443c01a7336-2c2dce83fd5mr4806375ad.12.1781130197572; Wed, 10
 Jun 2026 15:23:17 -0700 (PDT)
Date: Wed, 10 Jun 2026 15:23:16 -0700
In-Reply-To: <20260522-gmem-inplace-conversion-v7-6-2f0fae496530@google.com>
Mime-Version: 1.0
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com> <20260522-gmem-inplace-conversion-v7-6-2f0fae496530@google.com>
Message-ID: <ainj1B4jB_XihoHZ@google.com>
Subject: Re: [PATCH v7 06/42] KVM: guest_memfd: Update kvm_gmem_populate() to
 use gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: em7c74u1mktkz1kmq4cymr769jinbi7y
X-Rspamd-Queue-Id: 183C440009
X-HE-Tag: 1781130198-900809
X-HE-Meta: U2FsdGVkX18/odpprx8Mzyd+7EA3XcY0d13FsYgvMgXK1+G1mlMxK+mQPQzFZ5tTbiw63p3ZWmgad3R3SFC4FEcVgRgEbBK1kTthCARRhesu0ybXTfKALHuVn6Fe4WcF1T/mms2kUT6aOVKiGBE2teB/pMwW6jEsxiFGYZDLvDyniC+HIw+XN3pEww31ndjBCzse6YY5833+YItLM8mhqw+k9xLQSJ2ANgjVbLv7H6uX0K6v3LRh/nm03dIqy/+X1e5BLAa/AWDcUH8FvfJKP1DAg51kMMJXIwjM0uJUxs7FCUiQ3nYTWSGij7Rz44KxYAFGjmfohl3m8knf0TM/1f6ldgHy6zOWptFybukCR0NRULwMzEnhS/49Gq5me2m7wIfg2cPzop6R9tsdEOdLavTB9ehcYDV5MWf1PIm+hj1Hg02zHp5jNJIy4tGHlbBEoY8qpJnFJbJAC7mxYvMWSQBfkdG/RErsKaeCzmbXcGsnDU8OOe61dKWMicmUz5Rb19CKY5Ats+sfMi/LMhix4liyDfptyKp8F9T1/7Fqb/OP6evowSsF4fYFE8/OBXfN7+C7at5GB7Pvnf4497JKiOfFRJgRC+wIk5d23gbmnFu5LqUaRsRUxKqO4W2KbPb/JtFpdLT51CeuZZ3J/AZl5Oa67ibPRJoMv9nkn7ibDx+DQiRVkJeolVK3/7dHRJCtfhLiU/L/AZKm9p3E5YbamC8o1m2XY/NFz0Gw7G/9H3oHXFvHHGIfDFRjgp9wU5PI10UKIkJRODFADWfxjiTy+y2AABgGlO4WNad8RPI+PZp728OGfULSk5NO66URtFGOiwCUllhYHuFZmugs6eMzjkzfAVrMLIgsIDTOxIUU7yGxvGVqMPlmE14on/ZYTDd5Gl0OgfoSr9Q6SfC/z1wzmgVXd+EOvvLkxvXvcFMoli39ucP6CjY4vtg0XOv1Qxv+5B66FZc1/nFntceBrRk
 AfWQtlO7
 0Vle9e6Q8REo014W7iWrW9i62R1QEKSU8vXUdkdVplIQx6AafrPYn2/tB4w7QPC9QJjju55GkJ2eeNMOI5SQdryTyrWobA4/OVZH9fnbW+0CU2RMnD3gPv2AEGvmWKFUXLX22BT+6nTILJyD1O5rb0tvUOl6UXmoFAFZEDjkB4YoOy27lG61AiofLbDjc0GapfVmj/cM2N6nyGpi9E9a45YURkym1mwjLTbDtqPhGXSzxh1owXezin3H6qacXFkNCTH2BmEFqDJ+SzYbkqAipN1KOafuEFq29dtz0NBQ1mCNmPfPFAtql+kmkcHF6mSu4FuGmYZXnzFfCB+cIyBzGOrs6LRRSDbF+vfg0VRT26ijZXMLOl9DNhhRno8nvPEU6LJUlQIi688GrGe6jHqE0XRQ2Y8nDQ3H1vf+8wwgyIVc61ilQf4sdZvf5THnjpGy7tVgccaS0vJpA2TwbfA1KpLeCauM/MCNFM95+E9KdxK8rg/oIcAWDGpt/a/lBdv8nt0T9PsAiO6HlFJjcQMx/juEUba6T1fxdbzTZ9vjHF8GKMSvoDqfRzq6K+M9LJ22JINBBck5tLIC69U9PNqiioY83PEcx9RSfVijHNPnj03K7yN/ec+LVRem/nN8JJVB2ye4+PDktAzOgp3uM17j8O8/YD9+KGc0PMY8B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026, Ackerley Tng wrote:
> Update the guest_memfd populate() flow to pull memory attributes from the
> gmem instance instead of the VM when KVM is not configured to track
> shared/private status in the VM.
> 
> Rename the per-VM API to make it clear that it retrieves per-VM
> attributes, i.e. is not suitable for use outside of flows that are
> specific to generic per-VM attributes.
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

We should squash this in with the previous patch, i.e. wire up PRIVATE to gmem
in a single patch (sans the ioctl support).  I had a hell of time figure out how
the range-based lookup was supposed to work when revisiting the "wire up" patch,
until I realized populate() was handled in the next patch.

