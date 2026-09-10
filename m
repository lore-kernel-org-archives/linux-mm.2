Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 380A9C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198166B0092; Thu, 10 Sep 2026 18:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141526B0093; Thu, 10 Sep 2026 18:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059AA6B0095; Thu, 10 Sep 2026 18:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D66196B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:42:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B81A120484
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:42:40 +0000 (UTC)
X-FDA: 85199328480.08.D605E47
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8BF3740003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:42:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hYB+M/Wf";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3XDKjagYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3XDKjagYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789080158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UDtbunOd+y403pbt73/1ep0N3wlp/Y+kJJQS/7bASM=;
	b=i+VmS0laZMArq5NbCxetHECGRblX7kgTZkEGWXq3ufXVPTcqAIl0J0P2bvMDhe13TuLptK
	Y4kJWCR6xqTnUEF8/4fVltW+LRtC5CXPDzINVXho6wa78+6ZavAy93bZlkl7khv5Q8VSkK
	8w85zTHdxL+REFpfJPUUYOflVDIq318=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789080158;
	b=D/qmTubvkMJPdKIu+46zNWuBWryTigOpNiASHJREI54c1PYwnZiqaZl7hFnpqHWCiM7zyx
	Xds8oaN/FNUAGgHcuwL/uQIGf6UzByLwZkfkMVdEfM1i5WthRgGLQaINxgyljcpUQJ7JRV
	3tu08wVnwu/540BALLNKkrCmgEHhLy4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hYB+M/Wf";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3XDKjagYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3XDKjagYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so338867a12.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789080157; x=1789684957; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4UDtbunOd+y403pbt73/1ep0N3wlp/Y+kJJQS/7bASM=;
        b=hYB+M/WfqA1atw/rIOtfDfQv7vHtP8rP2dQeEeMo0o2UBcD6v55R6jfwrAtEdnTPLO
         jOetz9j98TEdcwBgfZ/hA4aBydfJEw8P6N2g/KN31wtUZt842Du/NrhxPLABSyiUB8SJ
         /wbo+TL0taVAPDf+1u/dSIAxGFw6newnu568zvyUmrRFQ1CLFyRzGxI/mjHtmXhg7x/i
         GItUfHilUPYoDbObdm+oTFdvPfRF+lP8BA9V0cSw+LVo4HyS4CYw66MZ0nm5Muzf9TBt
         fKN/syb7WsMXWgn125KFjTMYtj/21HG4EGgZkZ/SAulFVU/BbZzmTed4+vz2J3B7nxC9
         gjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789080157; x=1789684957;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4UDtbunOd+y403pbt73/1ep0N3wlp/Y+kJJQS/7bASM=;
        b=myIPT7kzsvwaEphWZRI8htKvnmkYB3X5dx43Zdq+bIvS+Orrp7m6OAqjbL5caUD+Do
         lOt0qZPnZSsWLw+6BQZpYUkqRq8quXORu6jLorj1ZxlgYm34Tb4eVfbFnygslvOM2aSf
         +1PkmwSbinEoW47nSbKd3j7Lm3vruQgspJoBMdb6ApPHsxswBQgJpYUvrAF7T5NTJMb2
         ddAW8xPITEEvCaT09OQ6DeFoCF4AT8XHHt3cMJDXYhDvm6imWMV0a+b960gA+qyVD6Yz
         mJpRpQROhLLOuELYdfRN5sHzeq0LjvdgJi7oxfe4YckbUyHOMTF0RFfQLt4NMb0jT/bP
         S2/g==
X-Forwarded-Encrypted: i=1; AKwUvBx02Yvyh7+KTjRW/qfa4DdfxxEUNerUCO/5FKzmWolNfBbmW485f177Lbynea4hM1Le+1i5qqol+g==@kvack.org
X-Gm-Message-State: AFuF++ko1hti9sH3ZHIvcw4b/u12nXEQ6K4m0in/9Qao7PGcav08a/mL
	geWZm2MhFhxJOxaaOUlrr+8W4odtLJ+ewBeVrpw+iqoUc2o37SM2py7HkDVSt+fHqm8hRZvtkr9
	VqR/3TA==
X-Received: from pgdh15.prod.google.com ([2002:a05:6a02:518f:b0:cc4:3b8d:ea37])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:22d4:b0:857:73e2:9103
 with SMTP id d2e1a72fcca58-86b336d6a0bmr1513199b3a.19.1789080156858; Thu, 10
 Sep 2026 15:42:36 -0700 (PDT)
Date: Thu, 10 Sep 2026 15:42:36 -0700
In-Reply-To: <20260910221832.GH3968357@nvidia.com>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com> <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com> <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com> <aqLOWkuVKccR-I7W@google.com>
 <20260910171210.GF3968357@nvidia.com> <aqMgjXfTJ8u3n7Kj@google.com> <20260910221832.GH3968357@nvidia.com>
Message-ID: <aqMyXE-fD-UN6w5L@google.com>
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Logan Odell <loganodell@google.com>, arnd@arndb.de, 
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org, 
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com, 
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org, 
	kevin.tian@intel.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8BF3740003
X-Stat-Signature: 5msi6xqjuderpat98x6jrshgfc3m9z9j
X-HE-Tag: 1789080158-545388
X-HE-Meta: U2FsdGVkX1+v/Miow7GBuwYGOuF0b8nGzYUEy8xqHZQu0tuFGYkGMzqrUDiKxw81oiiUXQVhK5XWZA/Koh2P26OKhqhPjZdWjf1Dx/YmFYuZ+fURxkg2GptW1G12Cr4LaHvMirop/MO2iMbZHewjqvkiIvPEVUf4lHF2n00VVfup7WMan1Oadb27rEmWVjyF4rK9Po91t6rR7zbvCLIyATapqNWq1dFSTVxBkZE9khN9M5wwejwdevJe/TndZx+vE/kT/KckHaKjtE2ynkahSJtWf9k46P0mRTphyhA6XTLcaupKyc3kv2toauBEsMTM2siRD54QO1upG8cvCZ9cKuV2If4wqrONlZKgHYFkAuR/FuDczdsAvd+Mxw6nc6L1NWL+b1OSu/OqhRE+jbBHWTLYJbi9V+XwsmA/V3CBat+ZrQbQc2CgcuM/iFzQXDeIDjZ18f55nQvObvPX6E5ojIXmeQBYOEO33hJ1pSKHISTuZe36NVDOWQgyfS8zwt+TLC4dR+CDCDBmR4xJjC1LZ2Il2zg21DWR7wSHSr1yU17fk9tYzEsIHDqImcrOT4wykAKc2j2iL93iYKHjOneYeBj7Q3tOaxQsNp8AY788qj0TuPPZSZwubeYRe6SE0ipLjXLmEFniOd8VqRdGbukz6gmD7wiIWbCpqQG6FEng2P7J1O8GgP1pXw+hF3l1pZ53cq4zLog6t6AU0DukNCRTXOQqLxZvz4kscPQxfgNuWESQrHU0oLo4oXIpAm9S8rY/4/3guLZZTPuJxbQNI2rmJRveYLSoDYtO4yAc/YQDJT12nYFRxPzPqS1l726g4DW3JCcpXr0mES4N5K2fGnCfIoKzVE9U46pEHxM0FcsFAheRK0ZSOFegdS6wGF+78jOJBZezygcXp/09gbyKkl3lM66tsL2W33Isz4lGM2uGyAMX7BbRpAIegzUpbGpRJFE7COGOZZ3fzIrgLGvAyvs
 mVFAn/k0
 y7qgahhZ7wS0o2mFGXwzGrPktM8/CJmF+GRPq1o5uN/xjQkmvLhfE5KHUHszBTRN/DzsrbNBGeG8n4ghkXs3cduSwhAPmc4vVW9sIBwEKQeX7GmNSz0GHOaO+q4tOKAPX5WOuJQLOaPUDZNowg7Ic7rvwG9S2ZwoBdBU3gXHq5+bX7+Zmb/o6vZxU+6HK6LEls+ONIkWGyzgMqT9hX22Qvj12wJ3Qyz1JlYZ8xQQ17lHakVGmoZ/txFdGTYU6NH/A1GfOYc8lBxew/AIUAfXh9GX/S6SEro2ead3AqVtXESYp+1lH93Z5FunHJ7F8Si8Tx6fRZEv1jILjU/JIEuT7mMV/rRdG3BY4O9xfzF+cdOLPnqaHGKgNhyrcmw7XgBFWnHqZRBGy2IDNFhDip5fw1ZH7cxFVONCr9x4KfftapIcj8AcdAXdhJO+0LHoLpUpuMwb8hrI6vacQglCKTpWlnsNpF7zElQUGLxZ/ul7l86p/bjyMvrVA2vrivgMgTQVWBocXa7kqYCtodptdPlfgOAFLePwa5S8DzlvEuc5kwegGspRtNdo9pYv2L9VMPU9gjTbXtHJ0YXlKDTP1+fJZJAu2zh0GoqiKyUKQ+BrM7XmLl3zHfN+z10adHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> Sean's initial email was asking for strict never-break ABI compatability
> rules on top, and that is what I've been reacting to.

No, I was never asking for that.  I think we just have a different interpretation
of ABI, or rather are talking about different pieces of ABI.

I am still asking for never-break serialization format compatibility, i.e. the
more literal save/restore ABI.  I'm not asking for full backwards/forwards
compatibility across all kernels version, i.e. the higher level "kernel" ABI.

To phrase things differently: I am a-ok if kernels are inherently incompatible
because they fundamentally operate differently and/or support different features.
I am not ok if we end up with incompatible kernels because the save/restore
interfaces and payloads are poorly designed, lack abstraction, etc.  

