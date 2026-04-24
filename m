Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACF5FED3EA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 16:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81C76B0095; Fri, 24 Apr 2026 12:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33216B0096; Fri, 24 Apr 2026 12:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A213F6B0098; Fri, 24 Apr 2026 12:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90DFA6B0095
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:09:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FCE514026D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:09:57 +0000 (UTC)
X-FDA: 84693935634.30.8F86B6E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61BAEA0006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:09:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RWaBeHjd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777046995; a=rsa-sha256;
	cv=none;
	b=6EvWMaV3HG+xn22kBk4KB0WqxbSk/pzAIpmg6bj4vkktlmmpmo7PUtURlZmdnJVSegZ+nV
	sW+FBYgYjhHEe/gOVZItU/MarcNp7/bkBDkoNQpEh6knpnT6LvTWZSxm5Lx3rVlUSP5O6I
	vxnblehpd2Iw7Yr3ksa31paQzsKgNaM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RWaBeHjd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777046995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zynltM+qCB1+gf0Itcd03ZQyLMvAA175jbKGHoVBPI=;
	b=JNFLb6fXN+Hip4z8P6/1Jl443C95NJxXByzsfG8bzgOKbxGZjo2mR9nh+TKR+ouhLvkMSD
	F0m07P05wEfhlx8E5U/M5Orf4f0elr7PQDk9huBmoKubwcXjl+IBpDWJpWxI1RUn30ih2Z
	Eze+6Nto1Z9li0NwXdghiPZ3lOCF0Lc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777046992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zynltM+qCB1+gf0Itcd03ZQyLMvAA175jbKGHoVBPI=;
	b=RWaBeHjdsMzSJ950NO9DaOZbAglCUIFNjndnTX/9GzGSZz1KVztUVx3VQDCl9yyZ7f68UJ
	KDUX1WfvtdAF5qC1Od4LmFUm1Gbi3Q4KqawfzG9MOnvttKFExiDxHhUGgui8ciMkhN6vcx
	Ua1r+g8L33SkwwNusHFKYwVCDmyml80=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-ptCVjvV_Pnqn0czftTdx2Q-1; Fri, 24 Apr 2026 12:09:51 -0400
X-MC-Unique: ptCVjvV_Pnqn0czftTdx2Q-1
X-Mimecast-MFC-AGG-ID: ptCVjvV_Pnqn0czftTdx2Q_1777046991
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-651c8371fd1so13226048d50.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777046991; x=1777651791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zynltM+qCB1+gf0Itcd03ZQyLMvAA175jbKGHoVBPI=;
        b=mMXj0k/gIHhw+LHgJyt7grf7MlxusaIL03CrhjUQRLmcA5k95ZCH7vHM19LzWTVTEm
         +dxKtMUdEcR/svGbElBXqqlbDg5dJxRRkyiRDR/MIt4adNw/yIQU2RU79KkihlSbS/YH
         NpznK8JLmfd4J2AWvSRRa6Seo2Va/gr0o+bwJWzc4QIleBE6MA1+xrKtAWh710R8jBuN
         cEa59MOnIXS2z5wfxT0WMwDpleZYsJM0UyoxJGHw9h14Y1sETAPOAXHgNYap3ERuKaVG
         5Ie3qMw/xqxcvjv2mz7m1/KvxOaQyCeRIKQZ5PG+CtLPpdkxcWhZyK1Hf3akCh++tg9C
         ChbA==
X-Forwarded-Encrypted: i=1; AFNElJ9R/uATAVENY4G7iRL64DGYulxOveEvBTAxxh9BO25/eq2emIyTrkTmsAWBlyod72ki1RdzkX5mVw==@kvack.org
X-Gm-Message-State: AOJu0YwSwJAUE3w4+tv49BHDar2gb+TFdmv1sx3sWlNN0LFOjulxqH5y
	pknbPPR2w8NUzJXPMYR/l2Q/1lgDkE+TGCNVvjfeVibXeWhKSeVRNIwU4M6wa9NJ6KjG40fh32C
	c2oDvATyjl3XZMgSaTFSOYMr91lYcZIRTptoU5oTyb6PqP/vHJXVO
X-Gm-Gg: AeBDiesMevH3JH5CKi4EwmW5mOrqbeWc4muzPCmvjnnpDEAbPd/1N5ystVtpTWwNppj
	QQKFzJ9hO7lYYJA8qZ4j7a4pww1VwBbPP/lZGpfLWBsoPz8QdkUaAdOyUN9cpUIYhenovK+veef
	wn0TqZYcj+t/FX0c1ZOs0cgg4i/Q74BYy9jwdLLVcZOj7EVFyvyLiJBRILZY37ph50Pv0KbX0Vm
	vqThHB9BEakB8UF/aKArMbON5TRePPSmyleg2UGRU2mpAvppTnnC6I53/tKSxWyMYSIu3/X5Fn5
	no9B/Q2Ygyv54lTgHnkRGfRz2PqX03U/IrGLZ6lwFNmniFpouDov0CO6Ns8eCbltB0wpFYIxj1c
	f1nkISCHs2geTka0cb05hOCTv+f17i+oNDoVJuBtJz2YJQbam5elDwvZBzw==
X-Received: by 2002:a05:690e:419c:b0:651:cf84:7744 with SMTP id 956f58d0204a3-653107ebc28mr25160550d50.11.1777046990818;
        Fri, 24 Apr 2026 09:09:50 -0700 (PDT)
X-Received: by 2002:a05:690e:419c:b0:651:cf84:7744 with SMTP id 956f58d0204a3-653107ebc28mr25160511d50.11.1777046990305;
        Fri, 24 Apr 2026 09:09:50 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae5eaf1sm191939006d6.30.2026.04.24.09.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 09:09:49 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:09:48 -0400
From: Peter Xu <peterx@redhat.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aeuVzCUJ1P3pL4rD@x1.local>
References: <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <aes7b17nG0cXrtEd@thinkstation>
 <aetZUOINzfTXChLL@x1.local>
 <aetyhki-UD70dyRL@thinkstation>
 <aeuSe0PY-g10KNUF@x1.local>
MIME-Version: 1.0
In-Reply-To: <aeuSe0PY-g10KNUF@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9r10RQLZaV_J_kgDW0nXdEtgbSlRS8-MABYuBgYSYbk_1777046991
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Stat-Signature: zqjkiuxanbcy3afcdnnk74xmehk3xqns
X-Rspam-User: 
X-Rspamd-Queue-Id: 61BAEA0006
X-HE-Tag: 1777046993-401222
X-HE-Meta: U2FsdGVkX18UkznFA3sEXR7ZhgvylQiVAYgp7/25KUN71ehl91umLz1kkhwIeXYtD2d2EIgTkjygt+d729JHd//MiLzZYr78QIs1YvZkiBZDnzrx8LG5y51B2yCk2H2HA3+JorpB+OYHAYOGk8ubyaRg9hFyONC+j17e5wEuuN4DkOTo9tjsigMtYSbRkwv0FhOIMyiLdlhzI/1eCjUuOHii7gqpa2kd46lgbyYcwFouQCT9o9StSPhw44/sqX9l0Cr8rbBcHhUEaEkfF15D9mIAUVzqTQ94/p1e6nTFU1vQtPKl6O64LRTMHYZM+LqwO0IgEXSOs0qfDBCinwiS98NRPd3YPm/ZOZYz2sgDt1i/6NbteRAFabDAH/hMm0lqUq4RDXLtelOU/NOkmcNutKL+b/dAUrs78FXexiy9/vGZ7ZnqU/KqIHKZ1Yr0Y/DfVVq1KP0dMyUyTw5hYEBvCPLvoauCMBUZR8/PSUFsaTTR053aNhbntpkbKtaM53PMDATMYQt+dfeJ+3FoLSV3HZXwmJ173HQb/bSRDlBCnEArbYTaM8C1XFWGcEP94E1rIMWdLdikISzNcrOep+7ERoSSZ4xs9Acmo7UhVebRddREAweBthLBdU398RORNdObu5/DCO2qd429DYd09Q6iaH1LGzw2F4MyMpLE/HfIG0Oyihcju1COUGbBY8ivPUnwifIq2HOy2gqFXyitYFxg+UfY5KGB0m+mjQHlgl91jGXmp+QBUa7K9FZM+/M8ZuwDTY9UP1ytji3Rce+0yAQa307XM/RsOIy3zW48Shis74TumLF4QYVPL+uGDpJXtsoG3DvU38CSO9z8YmjW//K2KhvgBDpSrD8uRKKd98PCuP2vI7mZs0yUzTpNNFWTwec559qS1Tlx3T5nsexvHtWK323FS3qTemIvpIMNVA/H8RouH+iXFPCVXZ+BlxssEQxwlH32sfrjIVdNvjw7zgt
 aHzRKFwY
 KQuE8riIIHMLaRwt8381KVlWBTeZ2Jgi4iF7v7PxokB9ZCzUpqvPMR3KZTXid2uzvIKfxj8CMz7lOrvbQIXCrW1hUFxyPm5CqIU9TszT9I3k/trQfx11pVVFEM02Pa2gNNThb5C4dG/nQpg+i9b6XYfU93c6YiDMQJww59ktM87oYKDeCRM9DWrgf+5QF7sK9GgLUJDPDAsXqXbRTg/7JTUn0efKg9cWqr0vz3Gpv7JseALmselT1Pp0gIYdTFQSI66wu9bf/6wVvfmb7GWTrv0SjpN1d2Rrl5R+kO8UUZyva/CSi/yAklsMqNx2+BCbGATwJtBeNZ1EqOV7e+SPxc9cY4xePDC0D6hS36636ha112svxmBp/4S8GsgL6ABmwVCFK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 11:55:39AM -0400, Peter Xu wrote:
> For us, we know the overhead in theory, but we never really measured how
> much.

I think I didn't discuss the other side of things, where hypervisor can
touch some pages and mark it accessed, even if you don't want to.

IMHO we should track most of such accesses, except special cases.

One example is when the access happened because of emulated DMAs, then it
should be marked alongside to the guest access: that's when you mentioned
vhost, and I believe whatever vhost touched on the pages it should be
marked hot even the guest didn't touch it.

The special case is really migration that I can think so.

When at this, I also want to know whether you can benefit from something
like swap_access() / maccess() that I can propose when it's ready.  It
means we can shift some corner case accesses from hypervisor to that API
then it won't cause false-positive even if rmap is involved.  Then rmap
will be a pure perf issue, if it will still be an issue at all.

I can also share at least my plan on our side, in case it helps to find
shared goals. Basically we at least have two ways to go:

Plan A: propose maccess() then use it in qemu for migration purpose.
        migration is so far the only thing we want to rule out.  We want to
        keep DMAs access promote pages, for example.  This will keep
        relying on kernel to do hotness tracking and evictions.  IMHO the
        best and simplest solution so far taking both user+kernel into
        account.

Plan B: if above didn't work, we can implement swap in qemu.  We need some
        API like what you're looking for, except that the major challenge
        to us is MGLRU compatibility.

So IIUC if you're looking for completely flexible swap backends, then Plan
A won't work for you: that'll always stick with kernel's swapfile
managements and it's not always flexible enough.  Then I want to look if we
can share goal in plan B.  But if we can find some shared goal in plan A /
maccess(), then I'll also be more than willing to know.  For that part I
can definitely see what I can do.

Thanks,

-- 
Peter Xu


