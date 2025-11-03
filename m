Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E7ACCFA05
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 10:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2318E0050; Mon,  3 Nov 2025 05:35:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392EA8E002A; Mon,  3 Nov 2025 05:35:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281FC8E0050; Mon,  3 Nov 2025 05:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17E948E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:35:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3FAC160AB6
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:35:42 +0000 (UTC)
X-FDA: 84068939724.09.628B784
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id DA94840013
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:35:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zuEOvzQK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3e4UIaQgKCPYhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3e4UIaQgKCPYhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762166141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIh+p2hn8CWwp1yzNpGitqYXRaRZUOuOWC3H0V0dQOo=;
	b=RIyGdL55aT4NGdjnU9sIAW0acs/8bu2HXv6JJ+adGSbdurNPhqcK9eLSXptBI5NxL90fE+
	nomrV3tUNIlR2AFmoOCCcjGR8peLB62hi9W7OgG3LYz3ss70eW8bBglPhWb0SosH5WLTu3
	FIuHvtZdXTO5nTQrA/oqhNDHQz3M1bY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762166141; a=rsa-sha256;
	cv=none;
	b=8MZFnDy+MfZxYOT225y0Fef+oxOFM3e9iEAUeFRFy1tggJJzPmIyZ7vL1Um34CyAF0fDYa
	ZKDnRseaOIW+4Aa9zdQSnSeVLMvbchONgeHzCnQuqQTVCkfom8XEREU+IZDWhR0Q6c5nka
	Nd7SG2sXXI7D8g1kT3yQdZ+P7nMeVdo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zuEOvzQK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3e4UIaQgKCPYhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3e4UIaQgKCPYhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-475de1afec6so14048425e9.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 02:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762166139; x=1762770939; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HIh+p2hn8CWwp1yzNpGitqYXRaRZUOuOWC3H0V0dQOo=;
        b=zuEOvzQKIFXSyGfNz489nASiL4GKjsyIKAZs/YZKb0ZF0CCFP+J+t2Z6NVWRd2cFbw
         t467bbOYR8w6Js2r1BdFH6/M4cWc1al6VU+m+ckAXKBhFbKfO0a/007Ap5DjuzK3pqDF
         w8vMOsY9gu9Rx9V6rvkdirC3RmsazuQyhRzW/Oo1Hqt2vatZTJE7CFsfVYAmXd/nDx9u
         3yQZ5jedbm4kslqXcNEbV3/FkPubuYiIAfWHb3nchsfB7kzQ6wMO5eMOoSNbIe+03pnw
         5a+3d057eULjx9jA0oQuHqsxPnaQn4gvXC+ZDzhgKl9cLAInMK2k1B1c9Z4O19GmfzQK
         nLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762166139; x=1762770939;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HIh+p2hn8CWwp1yzNpGitqYXRaRZUOuOWC3H0V0dQOo=;
        b=nnXru1Jy9b5gXqefC2UXSu9K3TSE59TyTQ1N3Pj1X7b5OXtM56tw9QuTe3EKRZWnA4
         BtkdlZF6zKvtW+I8VBBEYpC3iN85VZCMFQOWvOGWHDT8Z/gKDd//PhzHYVwLFgW0cNxH
         IXnjL6pdTEssYDAWftQmNfPBKvdlRLmycMJlvtInURuqWpSqR+9ODvIEMfWtbmPdKAKD
         5PhUKUCjBhfSLrRGryTpvJvvaORzirBmfPQXG/RGnYmwR+CG1NROHsMpLUBFQ4L6V/BS
         fvlwY7DIF4dDLIDFqp5S78tj1DMrBFns7uaGCWRaDe+mjhXMXVkd9KQOryrgxrfvByOz
         cB8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVcAFhzNKUoEMbkq442pejWJvvhi9yV9eKhCmK8ZpMrQQDSgMGp/l904D1cisHeFn96HMthN2es/Q==@kvack.org
X-Gm-Message-State: AOJu0Ywd/yyw2EqeFFQ2livwgccqrLaXBr1/EZUqjixDuVUDXZQYvEYx
	IqA+Gw2R9nlMOxHmuFlbh5xZnZEeO3LnG5aZy/owWP5U9C5oXJkTYxwh83ZjzkUL7/8B3Raaofz
	vGu1u9JMmqhVeLQ==
X-Google-Smtp-Source: AGHT+IGsdQiHDuxdy1N3E7iEx3V3SXYmD4K71IvzTwmgh+q16FRulMDnGB/75cnoaLGyb09UfRoHjiberggitA==
X-Received: from wmco10.prod.google.com ([2002:a05:600c:a30a:b0:477:cf9:f4a3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:699a:b0:477:19af:31c2 with SMTP id 5b1f17b1804b1-477300d96c2mr124516735e9.9.1762166139059;
 Mon, 03 Nov 2025 02:35:39 -0800 (PST)
Date: Mon, 03 Nov 2025 10:35:38 +0000
In-Reply-To: <aQXVNuBwEIRBtOc0@kernel.org>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-2-roypat@amazon.co.uk>
 <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com> <aQXVNuBwEIRBtOc0@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DDYZRG8A99D1.2MYZVGBKJNHJW@google.com>
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from direct map
From: Brendan Jackman <jackmanb@google.com>
To: Mike Rapoport <rppt@kernel.org>, Brendan Jackman <jackmanb@google.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: pbbo777cyt51ppdn7big5399rxex7d7f
X-Rspam-User: 
X-Rspamd-Queue-Id: DA94840013
X-HE-Tag: 1762166140-472695
X-HE-Meta: U2FsdGVkX1+WAj/j3qi6LYh322yOOQzU5WOwEwOAbyDZwEP2Z/R89v/gMzLd+q2GuHwZlNvEwa8OTZzcbN/3BDMZoMUXvKznqbw2sl1wmkkW1rE28w5snK+hwXHtrsJ0j0YSUPcUMpVmD47w312i959qGdKCYBrhGUI844O0JIWRFjbg1Bzm55TFsQEix87AoaPUxqO0mEHNJyDNwVvMMCDY0w2+FuVaPJN+ddPThQuicayqs6ECLl1cuuK4sTo0cCzpJ/N5EQ7gTcaJPn0giOeizBPl9Al2zMDG17H/cyWjBFB3LSOQgOTYf4ygSCZgXrMopA4Q4OjGniaY3o5RrYEC5hNB1GF80kKSIzq9O94zMiVPgqzV3N93LkpiXtQLy50+gFzQy0rBWt4+VVq2D4AzlVovHcyqGLZttLvOkMj5gJoxIqf1em60ekY+YTRCwODQQwRJ+y8NyUFrb85BT6cSR8Jxy2iRtUKLfkWvoRuPwmozYqROePi96areWSBXbWAfzrQb2uVHs+Xqs0aYXQZtL/VfXP7PIZAQIUHIj+o/DK2N/HYq0db5RoOcYy2Jihra81LQjLJ1bRBHc4a8k7tozRLRAj8Tu6qLaWqeNRoCxe8h8syiKUD59qvnBTws1w+mSXZWHjMNoU/UJ6v68rbTTfrB1wP/TiyK4bzB/ynu6O1tnOBkT3ngCvgpYQH/h9Kpia2v3wSjVNbAkT9p9E2GBWYsfrXe78n7SyVZzP4ygCwOHB5zl8LWhTawfrtkPltAtg0oBETUMpAWY8/VxMuk1iMbPmLfHwf7S2FHraTBlYYtd6v9vUejCBa3c+Gz4PrSMbrMiibwSFqOcVzfhhoLe1ZYERVObIw5JZ6iyacffmCCj/iDCLyq8FVUApnnbspJPuwVg0ndzcGairXUwikFv+AwXhTIgPnlZIoTZbmpS4n9urpe/o76KmW47mta0wGne/MTZy8pyJ8pXD2
 q2ABylMA
 POV4VxlkBUhQIPk+ywexsZFmDQShwW6To/S6RE73rsotEEHPh9k9pgTh7VJpQWwxDVblC4yA+XLY3+6Gj5wAPCJxoFoLpzeSfu8Ljwoh8BClXCvIWlwF038Fxj0fT65c90Jaz9wIU2gm3QUX+wtaJYq3SEBWPmOj9TPk41RhtMV6gEdesIDrldh/zHTRl4CAgfrqIE/mF5TdcUEvh+4CAVeIkZWy+ZYDsiM6ktklwjCwW7QB/ZPXX2kOSbrUZ4SPFe/cKXFSq73V2f3VwWQQoJ1R7uBkimDDhcB4crhrwrvTF1ypfibjIwgCrIL/msl6ZfDDc4M22mClxE+dNLNgFItzRFc4Rz0AIsq1QN/5LQbGSmMOkM26+YGlNQUzjzgskCHwemSkKXpQQr9Vr1YYBl43p0oKihb9+df83SGVy6/ZOX/N0q5c+Gfsl3IudsrQdppTUFJM+PY90g2H2b77sAEf5Yx5tImUl5eeeQ7XNi0oSxg6s014f0rj7snZsavH8Fa/GkD7qeieO4hhY+i4F0LowkYd1Dya8TVD89jei+4CPCKfms4LHpLEuU5QNIfd80uH7nzB+MnwfAJMF07QsEjbtS+kaMXEyJf6SgpcjyiavNSPStGJWsvt/mHrB6azpGvMcKWHNvcGTwJlCl+Bl2VG4OIexYJ0QJfFqcoxlyEq19yISZah4gU39poJK8Wn154eJIcO328sePXB+OLr9If+7zMm9MpQGwIxe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Nov 1, 2025 at 9:39 AM UTC, Mike Rapoport wrote:
> On Fri, Oct 31, 2025 at 05:30:12PM +0000, Brendan Jackman wrote:
>> On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
>> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> > index 1d0585616aa3..73a15cade54a 100644
>> > --- a/include/linux/kvm_host.h
>> > +++ b/include/linux/kvm_host.h
>> > @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>> >  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
>> >  #endif
>> >  
>> > +#ifdef CONFIG_KVM_GUEST_MEMFD
>> > +#ifndef kvm_arch_gmem_supports_no_direct_map
>> > +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
>> > +#endif
>> > +#endif /* CONFIG_KVM_GUEST_MEMFD */
>> 
>> The test robot seems happy so I think I'm probably mistaken here, but
>> AFAICS can_set_direct_map only exists when ARCH_HAS_SET_DIRECT_MAP,
>> which powerpc doesn't set.
>
> We have stubs returning 0 for architectures that don't have
> ARCH_HAS_SET_DIRECT_MAP.

I can't see any such stub for can_set_direct_map() specifically?

(But again, the bot seems happy, so I still suspect I'm wrong somehow or
other).

