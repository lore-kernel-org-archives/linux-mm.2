Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01792CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 12:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574CC8E001C; Mon, 10 Nov 2025 07:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525AB8E0002; Mon, 10 Nov 2025 07:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B468E001C; Mon, 10 Nov 2025 07:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBD88E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:15:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D95C614034C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:15:49 +0000 (UTC)
X-FDA: 84094593618.15.28C0E76
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 319841C0005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:15:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f1XEqOV+;
	spf=pass (imf21.hostedemail.com: domain of 3ctcRaQgKCLcgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ctcRaQgKCLcgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762776948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7u+CaWniXfNbRMSrnjLhAt9t/fpHXv3Sd1ZHtazOKg=;
	b=2ZoqTt1WTll2zVu9l9iT+a05Vdce599XWkVi8on/U9+sp14aDj/VRnfP4jZQym24DtLbIz
	fozam9OtE2WLxzdkeSSSbtSTq+OWNWrN42BNyKdiBVWX12QHB0de6tqWBVTzXy8XeTOGus
	spEJpSyI0abq3S8i9ppKm+DjIPEhj/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762776948; a=rsa-sha256;
	cv=none;
	b=E6hlGnUGdhuZPzJbs+xu/vuslxdQ1pb/bq6N6HvvSTTG2taXElZv8PMl9ag3xe8Nr21jUe
	NBiU9H9f8bnIwfGYRZYdPvSkOW+bAK0RZm4Xjo1hGu3owIECK/eWOBxMRFTh5k0JLy1r1w
	kknf+IGAB2beycp+PTAOzNFpwE93QkA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f1XEqOV+;
	spf=pass (imf21.hostedemail.com: domain of 3ctcRaQgKCLcgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ctcRaQgKCLcgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4773e108333so17923765e9.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762776946; x=1763381746; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r7u+CaWniXfNbRMSrnjLhAt9t/fpHXv3Sd1ZHtazOKg=;
        b=f1XEqOV+KsKAtZcVh3Sefg5gWCHhe1csccyMrz2Y418HVmSX7OqQ95liGYUdlUN+nT
         a7sldE5NfTRdXQpwELkopQyTAZRZfx79H4Uj/feEbXyPGT68W/iqD1nx5yorbBAtd+8/
         GqsGnN6308/sp/5QT/BUV/81DjrgrXRFTsGcyz2MPO2t6rVXH+Wj9LHntfNU8EGvuZAj
         43omHmM9OBVrQUMNbqWNcbyVs6R5Y5pM1PGC0L2tVrbnqnwIUNL6O8eiAkRC1LQJLVgW
         txwBIJqR3k0gmqL4aokF4v+QNNTXK1Vro48PuFAdmKaotKabKpEaGKY5uVcRF0TWFg0+
         UMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762776946; x=1763381746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r7u+CaWniXfNbRMSrnjLhAt9t/fpHXv3Sd1ZHtazOKg=;
        b=YqTw6fkzRwKK0+h7jl5+xjLnvzSKM/nO3PONsyoGkMf1k7Gvy868KViTUivQBSpxuc
         juYOFiYKTeH5LxEhNJafzhNfZ+bZOfKD6qRlWrFOCsNv8RPhKHaY2vXXBxBZ+f5Gjz+U
         jwRkqG0wzVTN9Pvxm2uWYTWgALq1S2YlAnMLM3QkrqEnyrOGfRtONS+ZixCeovWkzEYL
         qKZXJocs+uXL+j5Eh2mSZTRJBsAA/KR63qxwscd03ivbhGIDqvFR45ig02/+/AuMvZ6P
         Y4R4zdldN/1lVwvXeQrblxjA4FUzc5OXh7WFppwwpRDWM/WM+nnxlhAdlSmVn7qKoSSv
         Wqjg==
X-Forwarded-Encrypted: i=1; AJvYcCVzXMf94bm8O8bGWICFRijrFK+bCyFY/i428q3l7eAV1mgCEm+l/aVr0qYmSlbwdkFXzBwistsurg==@kvack.org
X-Gm-Message-State: AOJu0YzfB1N+LykOlFRGMl0jwRQor1Tb2cZ0MRGHWiTXR3GUzsF/gqs7
	JcGgpZgbNx/TvZ6CrDggraszwcYm0Z3PEgrCCGs0IfoEwI5KZkmdS2npIaGVW+h4ZleJDTVoifZ
	aIVOex71HXz/toQ==
X-Google-Smtp-Source: AGHT+IFsVkAJqDrA0QC1vNQvIugx9gGlCHC4/kl3pctZZHSVNpuIB2x8+7Vb8XbTb0E+0lyCnqY/M4AHDRthJA==
X-Received: from wmee11.prod.google.com ([2002:a05:600c:218b:b0:477:63d9:f561])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c15:b0:477:7c45:87b1 with SMTP id 5b1f17b1804b1-4777c45885amr34406585e9.36.1762776946520;
 Mon, 10 Nov 2025 04:15:46 -0800 (PST)
Date: Mon, 10 Nov 2025 12:15:45 +0000
In-Reply-To: <20251110112640.GVaRHL8GME4ODowica@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-2-2d861768041f@google.com> <20251025100642.GVaPyhMp4CEmsYW3xy@fat_crate.local>
 <DDSLTWM2FL58.3MIDS5WUOEEZW@google.com> <20251110112640.GVaRHL8GME4ODowica@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DE509XAYNMVR.2UH3ZEC7HIU69@google.com>
Subject: Re: [PATCH 02/21] x86/mm/asi: add X86_FEATURE_ASI and asi=
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 319841C0005
X-Stat-Signature: bnu56kimyt37jbatenupn85xywck34z3
X-HE-Tag: 1762776947-668754
X-HE-Meta: U2FsdGVkX1/UZQ3IGfCn/Ii9eULgbe9/BhB9Ae6IlEXM2edmlla0daB/OR1G1ye+4pNS/siGu3Ybqxy8hnB12y+/+BwVfo8DkUzqm43JqzRMBJ74BPW8KFkDAprlaagQDvTU2s1HC3v/oSziCw4WYEHoQLfnsbIhAaKXlkFciVuRfJ2N8cjYMFebArE0vONHFXRmsrUfzA7XoNkCqntURH39oJ519gI/rC1xjDZKj8r5hKvihJRAlx6jfz49hCBFDD867DckegBFBQJCZbpeRZgoUDi9ybkKEodTcZuSYIXlFZKNMpfT5ONxAo/xoNhc1CAI+dK0T0uW/K4NXlQm/+gFUyaSUxsIAsKUmFepcX75djNO950PYG/fRVK5fC2obLUR6mihFfQ3crqhu6PdaDAGtioQaWe/7Fgf2inEE8pU7h0+fbwlDsjJacPVwOkmQQFusVw3NjPoDlE+Qc5hDX6FUGWmrGOwtJjjuB0f5anxtcqCmnITGK29MHMArTsByGYUXg3Fbzv6yXkOgXzcGrseRCXUfnI2W+fCNE8sf3vRIyKdYLrKvIsvMUNbnDz1IHcgjeIE/sBimZGLRgojTTWf27U5X5+sGS0yDrAYCI5INRAuivxbhPNBqUFDK8F/TNVxZFO6tjn7YpmRc7wN7Y9PjjaoTeQ7erupOlLJBNAM/7FeCVu2lwvkTp6p3dA42wmMQRStj2b3S0fnOMuNP+N+MBVXcBESn1PF9GPhG7BCt8sEiAErOAG2uVI1Dewe9aGU4/A03SmCe8ejCJbZprrnpcfbPmXCv3wLzD7M+UVcy9gM9B2akeyMQ6iiJmii2UnKNiTfl2b4LdsAXcq87a+Ah8eW4dPxwg9MVoD2SLAXs6rBqyqPbpKg9yKBY88vpR8fDhMdKa88cJioBSFKdmUOwMbNOJjEdkIhS+nUybBy1tc1npjm4frgWYOcfGqKG1lWhpzarURia6siifa
 pbi+NDb6
 DEviRkjUjfu0hXoG5s0GiF27WCjqdgYK5Byb47N6ODwZ/GbaBEcjfmI/DWhVYFyDSS78wN1QGC6rMJGVcag6kZLmhrykMPXDycPn8OzmyhSOnB6IxuiduD8KJK871TJ50Y7OF+2hgmuc7taTk4MwT+mFdQ/+6js3sg+kRmgiaBEJppQ9slqzWbAerHN0j1sKh3O7A2Od23xk7zRW1XJNvS8PdqOi/RrC+6eq1ip0wnelxGC9OXCW0iNlA+iPkLmltcvCZ4O4R5LqtKJi1EB8HlNGnI49Ia/2RpXxDbBqLz5din/mEqk3K7o/RiM7DZ6PxolqQ7fxZjz4xpq9ATj4XzJL9Qx/cgLMSO4pcoE2BzYKVi+g3JKBmmBR81yyTvN/cXXJZ+pPWY5AMFnW0XIId2JVfvtYdrNfht5NxOBybHqpDYYUOBB/tVUD7Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Nov 10, 2025 at 11:26 AM UTC, Borislav Petkov wrote:
> On Sun, Oct 26, 2025 at 10:24:35PM +0000, Brendan Jackman wrote:
>> Hm yeah, I actually also thought I had some direct feedback from one of
>> the x86 maintainers saying not to expose it here. I can no longer find
>> that feedback on Lore so I think I must be misremembering, the flag
>> was already hidden back in [0].
>> 
>> [0] https://lore.kernel.org/linux-mm/20240712-asi-rfc-24-v1-5-144b319a40d8@google.com/
>> 
>> If that feedback indeed doesn't exist
>
> Just ignore everything whoever might've told you or not - we override all
> previous statements! :-P
>
> From Documentation/arch/x86/cpuinfo.rst
>
> "So, the current use of /proc/cpuinfo is to show features which the
> kernel has *enabled* and *supports*. As in: the CPUID feature flag is
> there, there's an additional setup which the kernel has done while
> booting and the functionality is ready to use. A perfect example for
> that is "user_shstk" where additional code enablement is present in the
> kernel to support shadow stack for user programs."
>
> So it is all written down now and is the law! :-P
>
>> then personally I'd lean towards exposing it right away, I don't see that
>> much downside in terms of ABI, since ASI kinda "doesn't do anything", from
>> a SW point of view it's just a very weird and complicated NOP. It's hard for
>> me to see how userspace could grow a functional dependency on this flag.
>> Whereas for general monitoring it's handy.
>
> The point is: once all the ASI code lands, we should show it in cpuinfo. As
> in: "this kernel supports ASI" and not "there's asi in cpuinfo but well,
> that's not the whole deal."
>
> Makes sense?

Sure, sounds good to me.

