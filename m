Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD03ACAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 19:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065CA8E0002; Thu,  2 Oct 2025 15:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D788E0001; Thu,  2 Oct 2025 15:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBCA48E0002; Thu,  2 Oct 2025 15:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA8928E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 15:19:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7730E13B615
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 19:19:59 +0000 (UTC)
X-FDA: 83954139318.22.CE62079
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7151AA0010
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 19:19:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hAYSQvJa;
	spf=pass (imf25.hostedemail.com: domain of 3W9DeaAgKCMQtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3W9DeaAgKCMQtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759432797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIPuw5PXf537cGjHuuOBAnE/qD8vkHzGaf9rib+Lq+I=;
	b=fS5GihRdSl8/qGMODw1rsqKQD0dFlEbYJbVD+6mBIdt5UWU9X4jy+WiVYjw11Wu3gXK/vc
	pV1r1uvh0D+5XLTjy8Bsy//tgOWxJCb2stB1F/rXe18dVSu7VLSvm/pq+HBZjxeWP9m4A0
	yXWvyLiG0Iw29ix8iTxESut1b+N9mls=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hAYSQvJa;
	spf=pass (imf25.hostedemail.com: domain of 3W9DeaAgKCMQtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3W9DeaAgKCMQtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759432797; a=rsa-sha256;
	cv=none;
	b=2hhvcEMK3CKU/z86ytKaIEIxewr/HEgRQtpysG9UOiJVqcQ1isTbmy9t0Z8C3XTs3ufWkj
	bPYVYkl8mOAxjGHEslwoa2rMlfz6Ovvddzx867BIwVvZFX2kH9hHG+SCYEIxnda9rONpbN
	37aqlfYTHP4mg5xKnCwf/bhkZJgQUOo=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e4cb3e4deso10517535e9.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 12:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759432796; x=1760037596; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OIPuw5PXf537cGjHuuOBAnE/qD8vkHzGaf9rib+Lq+I=;
        b=hAYSQvJa4ez8TV8HWOtvDQzBTFnm58FdwVklfgVtTY961eFMIPcarqsWI6CiDelq7z
         6l+B5ZSfTlxdfFSEsCKpeUYnyRt8+Dc15Zpd5qXuVJUSlOe6pdQ7HkgMS9u4D9xnJEWM
         S4VXBj812xPSSS2ip6AePxJnmiYLneY2XwaxMJahJmIf88DMoy8WpAOtVwtY+cZB0EmW
         fUL196GmzOPVXAzZ0qFPJ0mPznTd9dAN4aA1yQcbTmDk1JbeDXInHJ8gXDDTNPj83rSU
         +tHqyY6Lj5Pcm6YkEZfiOE5gg2JN0LZBJ7L5oTs664GydeIWqlUDaNhkIgggRjwZ+MzN
         Yomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759432796; x=1760037596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OIPuw5PXf537cGjHuuOBAnE/qD8vkHzGaf9rib+Lq+I=;
        b=TY6hWpZCBxd8Y+f5XgkN1a0LQ4av4NNRbV6G2oJ3FQ9wyZfYo2HrIJZUg2kwOEUIKK
         7QJaidhhIBwMDCflzwd0C3nOug0boUiNQ9DQ4EVVUjws0M0Bm8tBJuF9DZDc0RQCxNNv
         Q2Re7afNFHI5wOocatHdWstg5zlBPrcTQWmZLJvTysxgGwoszTvjAXxSh7vEK8ntcavT
         4wOL9URQSQWPHd8yzmyxMn0pyG+HL+E3VG+2W1aBgalkXXUu0Gswh2HsO1mt0YEWHWcP
         Yqx5efcEL2Adzs56dVbiWtadanQRxvkQ25rRt3R3jh2o0756QBlu86FoIb1pnCpi3hkr
         uMmA==
X-Forwarded-Encrypted: i=1; AJvYcCX/uypugli8+kaFniJNS84k3xKgzWrQj8D1PiHYl5rKfAiril2i6Ni+wNs7HwnurNzOQ6jJmzubUw==@kvack.org
X-Gm-Message-State: AOJu0YwGupNPfRMcJJ/3VALp+WTiP3NSFU2/aydKFe76jNP80jbg9nsK
	G+eaeaCIt86kDtkrnyuOLrtA3oDCX1Kc4ajiiwugJ86dH20YjIk3m9ZH3ko5Vs2yUznd3KVWHKm
	jRcbkalYmVkpY6w==
X-Google-Smtp-Source: AGHT+IGA0hBUYWEjVHKMSca9g2yFQ2NDxY+JABJUK7tlQgJ95B/8XPbRxR1nSAIBjkYBvuTBmTOZLYFHa4lk8A==
X-Received: from wmz11.prod.google.com ([2002:a05:600c:6b6b:b0:46e:5611:ee71])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6092:b0:45c:b6d3:a11d with SMTP id 5b1f17b1804b1-46e70c48dc8mr4571415e9.1.1759432795577;
 Thu, 02 Oct 2025 12:19:55 -0700 (PDT)
Date: Thu, 02 Oct 2025 19:19:54 +0000
In-Reply-To: <6a97031d-33d4-4710-ab5a-7d8947936038@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <00e7ff5e-fe6c-4edc-9bf8-2352321f74dc@intel.com> <DD7SQLDVNSRL.XJ8PUCH6GYR1@google.com>
 <6a97031d-33d4-4710-ab5a-7d8947936038@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD82VFJLMSVX.27GMXVWD0A7UX@google.com>
Subject: Re: [PATCH 00/21] mm: ASI direct map management
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7151AA0010
X-Stat-Signature: wnioge68kaqtpn4pr6nkxe884m4ntfub
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759432797-521218
X-HE-Meta: U2FsdGVkX19zwTKsGS76pfQvLz5LuNGD3MLOlulonRyyoJxAitW0bX2Wfls3YHNkPLsaNvmHEcthQQhBC/Q4zWogYIxvhyNkZUj75RMD8ApwtGqdARhCJB9Cc48Pdt7DieGF6AmOfA7itX8tiQx7grfyQYcHBT02QJTyIr3nGT+6cOt/expBUoeYo5mA+lnf5ivXgBhM1V777eDxN/9qfpF9YFOI9VVutlWXZV6h9Mgzh0eZmxFm6CYDwltK98+LSUkyDizLQoKvblCrtwBKupw/b4swg0GZx9qUOj9X/KcyptEqBbVumIaQM+PskAMnVVAqoVC3xyNczN3/5W14KWETCwShFufTKYGPLdUXQS2uBYta9kds+mtLxl7fielus/CO/lHgvn0dmnz4UCsMNys9LdWunrz+hhQ8IAexgxLZWaAtrdRxEoy3GmoS8mrlQYvARLPYvKxBB/5IDlpwcAv53c2O3tXLnmeQXTSVta+svhu/s3S1B17XuQAEpmwDB0G8TUoRNOYGbusmHXDOqopqmlBSa4+c6gw/HrVA475bmK5/bWnq68oXeW6zCFr6wiWomo8gma4KzrBK0RO9AUgNMpkGVN2UH4oJfe97+rT2dKUoQRKSfaKy9UYx7bqyKofe7vSM4OYA0KdlhEpAxlKX8q1kGVsEMGfrOjeYlqKFowa3VGKXUiX4mZFhjZq5OgynSQT+GbArmfRYeQCN4UYJR8AbjkDQH6OS5/+QV+UcFFu7TTqt5d2S3CJPX4LtLBMDaH67hBdowPsixkCJAdupq+iLulSkziCuJhRze0UGUKHHbV/8lgY7sYA1RKIG2ZbUb17hls3riPswoNMpe6c4weCITiOqJxUU5bj9C064F4gSoU9TocGlbpCKPeOblwtn2XppPOnYm7EVhW+2IIEYKIRaAVAuJSXFKwIQbYAclQrjiJgkBtSItc5kIsH1Pi7XjNpnTXUnPafGqaq
 6ql4TfrW
 0W7zFXZbGb4/H5EjUciiWqyVS748bT/hkcDvuj9kL6ElQWW0gT1z3ani4pplme7NoHbSUAXtuRifflU4fcW1873vBYrSgBRPMxKvNSM3na5Eg5EfmxhK/+9De+mh5JtMDKwQ1pm8W1yN+d8x6J+rMFEkhmD8LTGZfiidRQgVe/lhhDqeHv56nZTSUMxnFvirYYwjFoMOHH/eY+QcZRLHumd4GIE6e7iurI2q/Ds+nEJ8yqJCGpQ9nh9Bi4F7PMM4/GjGL1p+gYxuta1RFiqCVnjsb2eOgy4NYxTxYmHkDNJ5IGVj4yB9lC7344m9Mv1RZK9A9YzOcd0aFzKrmn80tEKBlrvwpXL2nxxpyz30DsLC5FKe48aUxRguZu6Me3pF3GsZ8GkgGas4KSjwG04NGrhmhHo1k1/OZnqQN2xtxKUTiCYJSkRlIx/rVgPWWENRtamXU+ToM8IjKx6Sn1atgy4sBCTQ8rOpG+j2NQi6uPcuI88duZ899uzVFggiZuAceCZu5Sp6dDqVyboOqclujmYGLsdLREcTTXBGNpJqARjT1WUzd8oTPfhm4diXuyFyzMCiMeHKec4d+7ZEJMpkcM3FRODkKPHZVS7e6vFry3Zeb+Jt8hDfOtrB9NdIpWVL4U0o1ktuixbBdof5My+YQ7Re5TrW14cGCf/hh4+cQDb0G5CY69yP+etcO7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Oct 2, 2025 at 5:01 PM UTC, Dave Hansen wrote:
> On 10/2/25 04:23, Brendan Jackman wrote:
> ...
>> [Well, I'm assuming there that we include the actual security flushes in
>> series 2, maybe that would be more like "2b"...]
>> 
>> To get to the more interesting cases where it's faster than the current
>> default, I think is not that far away for KVM usecases. I think the
>> branch I posted in my [Discuss] thread[0] gets competitive with existing
>> KVM usecases well before it devolves into the really hacky prototype
>> stuff.
>> 
>> To get to the actual goal, where ASI can become the global default (i.e.
>> it's still fast when you sandbox native tasks as well as KVM guests), is
>> further since we need to figure out the details on something like what I
>> called the "ephmap" in [0].
>> 
>> There are competing tensions here - we would prefer not to merge code
>> that "doesn't do anything", but on the other hand I don't think anyone
>> wants to find themselves receiving [PATCH v34 19/40] next July... so
>> I've tried to strike a balance here. Something like:
>> 
>> 1. Develop a consensus that "we probably want ASI and it's worth trying"
>> 
>> 2. Start working towards it in-tree, by breaking it down into smaller
>>    chunks.
>
> Just to be clear: we don't merge code that doesn't do anything
> functional. The bar for inclusion is that it has to do something
> practical and useful for end users. It can't be purely infrastructure or
> preparatory.
>
> Protection keys is a good example. It was a big, gnarly series that
> could be roughly divided into two pieces: one that did all the page
> table gunk, and all the new ABI bits around exposing pkeys to apps. But
> we found a way to do all the page table gunk with no new ABI and that
> also gave security folks something they wanted: execute_only_pkey().
>
> So we merged all the page table and internal gunk first, and then the
> new ABI a release or two later.
>
> But the important part was that it had _some_ functionality from day one
> when it was merged. It wasn't purely infrastructure.

OK thanks, after our IRC chat I understand this now. So in the case of
pkeys I guess the internal gunk didn't "do anything" per se but it was a
clear improvement in the code in its own right. So I'll look for a way
to split out the preparatory stuff to be more like that. And then I'll
try to get a single patchset that goes from "no ASI" to "ASI that does
_something_ useful". I think it's inevitable that this will still be
rather on the large side but I'll do my best.

>> Do you think it would help if I started also maintaining an asi-next
>> branch with the next few things all queued up and benchmarked, so we can
>> get a look at the "goal state" while also keeping an eye on the here and
>> now? Or do you have other suggestions for the strategy here?
>
> Yes, I think that would be useful.
>
> For instance, imagine you'd had that series sitting around:
> 6.16-asi-next. Then, all of a sudden you see the vmscape series[1] show
> up. Ideally, you'd take your 6.16-asi-next branch and show us how much
> simpler and faster it is to mitigate vmscape with ASI instead of the
> IBPB silliness that we ended up with.
>
> Basically, use your asi-next branch to bludgeon us each time we _should_
> have been using it.
>
> It's also not too late. You could still go back and do that analysis for
> vmscape. It's fresh enough in our minds to matter.
>
> 1.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=223ba8ee0a3986718c874b66ed24e7f87f6b8124

And yep, I'll take a look at this too. Thanks very much for taking a
look and for all of the valuable pointers.

