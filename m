Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749D1CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E5D8E000F; Tue, 11 Nov 2025 04:35:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EB68E0002; Tue, 11 Nov 2025 04:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34AC8E000F; Tue, 11 Nov 2025 04:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A235A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:35:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57CBBC04A3
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:35:22 +0000 (UTC)
X-FDA: 84097818084.27.B765BB4
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7EA454000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:35:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eV2To5OX;
	spf=pass (imf04.hostedemail.com: domain of glider@google.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762853720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EetqUyAEJqiuKxD3fEI2nbY8lCOitzdVH7lF4O8jjNY=;
	b=VxKPnrRSwPYkABmHbOwTBK6XJ+h2WarXNSU2OfvtRRgL/B0CfBdLP6mN3kXpBQO1GxLvic
	F4Ob1JYA8bTlX/h3pPes3Qy+3Tfm0gNLpYzlibSopLAoL5PX7dpCd6JIPkZzyKSY4gnIKZ
	FdFwf4R6zsP7Vc+xSJCeGZ8w86Y+5dw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eV2To5OX;
	spf=pass (imf04.hostedemail.com: domain of glider@google.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762853720; a=rsa-sha256;
	cv=none;
	b=BtT+frDPWG399wDrvKWLA3/oixdR7WOppjMw4GHtgaDiUxtp+UqGNeqy6sBxUdlj1PodVJ
	Ce+XPg8016ceWaa6BXva85O483hp4wKTmSM+iBC9YIF2Qm9WSXjegXmyImUK5iBoWasrdN
	n11Iqjttn8tzzDSwyC+lzWTl7JMEvHk=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7a9c64dfa6eso3197088b3a.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762853719; x=1763458519; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EetqUyAEJqiuKxD3fEI2nbY8lCOitzdVH7lF4O8jjNY=;
        b=eV2To5OXiGTNHR4OHz30aD1PsZhJ0YkGbfJhtraG3RBCnkroGVubl0X5fUBc4PF948
         yVgQtlhsDrMRhoz5fLEjp4U/FeQ7JJss/ZF/Rpzmyo+fAxXlXKjemmbC7XAZFpmjpLXI
         oY3eJsQPDUO4bLz0MRCXg84LDXlhQVXDjrbqSQSNvMlwmv4Vqydg41CElP3Z8dMP26wF
         nyS3LPcFBjakO5ThqW/P2HWHsmyBCOPK1JTSzmGFtKlXmXYQHsjXR14TSLfGSa7sZx3t
         uPQkVc96pYt6EMo7gy9LGV4rp2+AjyAOWeyPaX3YyrrIjUsC9WYzsDcFpj4KZxAFMQqU
         ey1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762853719; x=1763458519;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EetqUyAEJqiuKxD3fEI2nbY8lCOitzdVH7lF4O8jjNY=;
        b=nnlLhK756Uh+OGm/p3ks5AF/DcIcAdoCkuC/z0DH/2Zlek7VVWJDFyStJeGcbjpS6w
         JjLE3JIAOQCgYZ7s/bYbxQvYUG73HCNP1GaXo/CaR/WR77ioOST20hNXbJP+lAu5t9n4
         W9PRTuw37JzvV2G2KSWwYsx4Le51k/3uv4b/R+oYqdX8LkL17LsQZH2L35sutkhscKTF
         twXx052ZtO/CJWnD/RCX6bTEG3nmT5VObFeVO9nAtl98Mbs+YpY8elPfojLMtHQSrS3E
         qBZD3CWdD5Y4nJqzMKzXh3ou7U1Oc1kfxJVfHT2I7brY5EIVch8BgDWlSQttrCvBa9Eu
         b2mA==
X-Forwarded-Encrypted: i=1; AJvYcCXA31jW5h1WRb2LaBihn8f4LdWEuo0fGWgG+u/MDn27Ik3CeudOCwG/exbFL1reJU865RujZHr6Tw==@kvack.org
X-Gm-Message-State: AOJu0YxOGjYhzDECAL4OsxsJiEPz4h4m/HAKnNNmrglZWziMbvvOU/GH
	sSPAqN1UORBIXIHbKlTpHkfufHLITsX32+DdujHfGlRl4rBfYIOvlE7yhnIhh3RZsOv/wOLVMPl
	Q+rDMOo8/N8PHEPN13thuOkZLsraQdOSjdESsRCe4
X-Gm-Gg: ASbGncuHUwglaxJPjzuvoboHOlrez3wDGLS6vBAqgAW9GxEOvAGDynIY5SlUN1cF7K8
	K0+uZZHuFvy79L/vVHBB+y79YBrbUJcQ588DjEpdJ7796gnq933wHudbfY452IKTsbCg5WdL/EC
	NUu8Q0j7Mi6xzRGymllY3j/BPU6f+ldcFRATOtBJ7mbuK2EYXRqqmom51A5ROV+VuBT10ScXx9e
	0bUpAX3Dyl6eXlKfW/Pg1vbtq7n1L0m/jFDSyGZsAXrQRkQEyNAKRzpUWwPlqeqj90jfYK/cO4N
	vuZpTdZZG2GgnxgnDgTFbyshCQ==
X-Google-Smtp-Source: AGHT+IE1gIu9BAiXsX0H1O+GFnCkjCXA7LjUzdEGNtie4OCQJL0hEG9RvsKQFDwhfkMp+tiOpjzqm/vRLg5+ZmsNZZg=
X-Received: by 2002:a17:90b:390f:b0:340:c151:2d66 with SMTP id
 98e67ed59e1d1-3436cd0bb4cmr14245240a91.30.1762853718758; Tue, 11 Nov 2025
 01:35:18 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <fd549c974b53b5410dbf85c0cf6a1f9a74c1f63a.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <fd549c974b53b5410dbf85c0cf6a1f9a74c1f63a.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:34:41 +0100
X-Gm-Features: AWmQ_bkZUqiS435kDnMhK6mmvyG8PwqBjo8fr1ltJrKRlyqzMnD3vTHwKYRZs0Y
Message-ID: <CAG_fn=UoQeoHh6Bpy0YOCywpfaimuYZM_d043JfxLVReW8PdJQ@mail.gmail.com>
Subject: Re: [PATCH v6 07/18] kasan: arm64: x86: Make special tags arch specific
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7EA454000C
X-Stat-Signature: tbfjhoew63ubqhf8ppwhm5pf1ir93gkn
X-Rspam-User: 
X-HE-Tag: 1762853720-283368
X-HE-Meta: U2FsdGVkX18HAqxYNqJOO5JXF7cqwttJTI5vq4Bbf7lEdkBoDwu5BXcJUUxdpnuFm5IqHvCHd09cNthXXH5QbgYkBCPQph/gHR3ekkKpxs9O0rv+i1VVTy6qnSr9JwS6rHOzB5xEKJBoaHC0zzAEG12NClXeiOu+Pmh49ryoFD9Eb73J/TDreqovAKbdc9+//zenwaw5MquomPNZo2vC6NLjunthwCBe0ll8bgfloyh9/BZgRz4a0IGMZGSC3CMzmYkNpljUTFAM2KlyKLdbyvsCoXzXjt6tqQV1cSSJ2koob2x9T1W6NBW8ENO2vGZxBHj6bxvRKdHQsjKtkSUykJcGioznPC/sbF62b4mGA1azl0fYhPHnBiR2fAtOkQLKSogoP2bsSAY4H3HY2XgCphh0gXIu8u+6lYWTAYPK9tyNJtxTs6KVX0/iQPHUCgnbMUN6yA9eCcWsG94j8ImuDc/oTWN1xWzDOiWqMzWXnKOXbWEsY5/+/H1xumQlYAPr8jxkIOGwBIbe302P8Ko4ceEtviGQZKEpo8U1R4+nHunt6QpLl4vxQ7Rm/nv9C6/4XgwT3MQTMKO6dJqW964ZdqE8dKWzoVqfznJ9PUK0mgiAaTlz3NQuTyVWiUdmPpxoWASXq1vD4Br+elhwZS9hGUzxjKgZOarnitSn/gXh86WNNsagdgLoJxOCms/JlJpL6hl0zfnCElIGQIUohygcGyygCGAhslILgSEIgszGAMv38Xz4I3ZfMXn9ZGR3gdF6QX0YkI4SNjYLwdY5zWT+Rq8YKy2UQpweUUGl2ah7Ag9wGTSmX3XmKH6+qJZm9bLipptms/MRHvyz1aYnh6PMnAzeWp0RkaJy8TCWCpiDWusJnW0STc3Xmk/aLVeQpr7USYYAj+uVA0HdMsWg3N0PODvPmK2EnknE3HO4IZiinawpvbrrzlnoQpyBTZ4hYJMEOOGLryurauAopPPi0/q
 7JwOrPVq
 5yBVqQlVMdbSZ0Y3ZGflD7EkMX7getGN31rKcnNH2p2efUwnEO+j6Cs7qSjUzsRwwp37ZRRgXhZhtRJuBm8/BBOnOQPS3wccIl2Fek1B/p/Eob62ydyN5V/y040VBQhAFSVOwBUfJgQmyG+nh6dygVc9z3hqZ+S20E3HEidI1683QYb+ekMl88JyHY2bNCpMWrEJmveamj+YF+M+1hp2pq9/eDyMtGX6tSBksFzX5sVwoyq/JH0IPHnFVZ0VksVyeuL0l7Ccgcac7bZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -#include <asm/kasan.h>
> +#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
> +#include <asm/kasan-tags.h>

Perhaps moving this part to patch 04, along with the newly added
kasan-tags.h, would be cleaner.

