Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0937F531CA
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 21:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEFC6B00AC; Mon, 13 Apr 2026 17:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB0116B00AE; Mon, 13 Apr 2026 17:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6876B00B0; Mon, 13 Apr 2026 17:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBD2D6B00AC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:08:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 606258A9CC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:08:46 +0000 (UTC)
X-FDA: 84654771852.12.33F3C2F
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9E1C516000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:08:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SWPUnu5R;
	spf=pass (imf08.hostedemail.com: domain of 3WlvdaQYKCNsPB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3WlvdaQYKCNsPB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776114524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdsNO9c2Q5NZsN7hZZ5BDljOzEMaKqWGBnMOCrBmEmM=;
	b=loZKJjUH+Cn5681V57BT5u7H2yeakShyqEgDg9XW/sRZDzP6y8uoBgLFK2rzKdceBww3UA
	CYsJ++qBT9lohlAQxCL3fnpjAOGz+YKrLeOTao1WCfchcox3kWOhg00v9j51/p0Ml4v+9G
	OqLsT5BVlzjg/zozW289OQMxgFVi9gs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776114524; a=rsa-sha256;
	cv=none;
	b=2+B9c08EgM0ltVJXQTZLZ8TAghxPt5ReZ+cI2kTCoWGu/IlvS+C2OsV5PoF38gz0i+6/WO
	ZF8ODf2McsVJOYxQyXG495EmPm7EsmNZcx8zwm06YtxRJYBg8g39GJcnRkeiiq1HRweWef
	8TCfl7vkCUTqTdZjitjIYL/Wv/rVHec=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SWPUnu5R;
	spf=pass (imf08.hostedemail.com: domain of 3WlvdaQYKCNsPB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3WlvdaQYKCNsPB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b465bf993cso9681205ad.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776114523; x=1776719323; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kdsNO9c2Q5NZsN7hZZ5BDljOzEMaKqWGBnMOCrBmEmM=;
        b=SWPUnu5RIdQlqioYR8SRd2uRvOP6itaoLs21gEXFmaLLqffkLrpj2BfEDiOHBk2200
         freTmFur1tDcFTdB0uVHDVfZbVhZf4plLu/e5wz488O7jmrW1+6nIj7sHSbMq/jBK8ZT
         832s8rvCAvfz8FXJF2qcWAvHSZP0EaD7dm4a8t8NyFmxg35zyU5e+9I3bFnUtaf9E12J
         OtbUoGxMrydSspXlCDG/XQtmzIUjaUrNGymW3hsHoTep9Gl+HomkaVsJ2reG0dUrJ4zV
         RmmSI5hqkjB5I1SIsLdmS12sIRP30fmcmrFVAwnBY77sbcn3vJFMU/a6mC1ZAg3evsqi
         mzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776114523; x=1776719323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdsNO9c2Q5NZsN7hZZ5BDljOzEMaKqWGBnMOCrBmEmM=;
        b=d+9yIpTemG1YzGbcq87D+m/sOAcpfZ9pX0jUt0wjARBE3Xw4kF6AOdPQhFUDHInWuj
         V9SlW7jAGDCldTLfkUenlad1fx3wIk6g0xNl9iPBnDykoyj9V462NcXckN/2szEjVz65
         C0Oi6n6BUSYVlSAZPN62BKQQcZRvZkoL3u1YQc/7xyR+4Wd8Hesy3f4WkWFz72mV4OxZ
         vrGC0Dv0jcYupghIV3iJFXB8r13Lhs0tqWSBzHdNpH4CTxGRDcuLU4hVpitYqfbYRbHv
         Y2PZhzaFLIOW9vdqXUkRx54GGAAOdKHh+CsUkV4WgytmPZWxwOoNJ2G1TirDxWH6/O7e
         ZyKQ==
X-Forwarded-Encrypted: i=1; AFNElJ+TReXkZOvwrZweY2WnAPpCCFxjOEcnPLulZ9nrpsp+sY9UaPPAfjSMLDwjUk5TWki/zLFIvAjBww==@kvack.org
X-Gm-Message-State: AOJu0Yx59kIpPO1GCpPaj49RFYl+wjdlWlffYhTtxfnI9e3wpewkRITK
	GOwZ8NPhEA6ud4F39Wr0FxtKzculLMTwdx8/Ld8StSAJj4ExAe12/if4bFpKXvvaxD/pZXKFnaO
	rkwIaPg==
X-Received: from pfwz16.prod.google.com ([2002:a05:6a00:1d90:b0:824:a65c:adf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3384:b0:398:aea8:a9bc
 with SMTP id adf61e73a8af0-39fe3d0e025mr17171043637.18.1776114522737; Mon, 13
 Apr 2026 14:08:42 -0700 (PDT)
Date: Mon, 13 Apr 2026 14:08:41 -0700
In-Reply-To: <CAEvNRgGz6CHgCtR-PpyiRDy4tMioTGgYDFrzuWCmAodMcg5EWA@mail.gmail.com>
Mime-Version: 1.0
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
 <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-6-718f45eb7c75@google.com> <CAEvNRgGz6CHgCtR-PpyiRDy4tMioTGgYDFrzuWCmAodMcg5EWA@mail.gmail.com>
Message-ID: <ad1bWceUiQCtnDfF@google.com>
Subject: Re: [PATCH RFC v3 6/7] KVM: selftests: Add memory failure tests in guest_memfd_test
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, rientjes@google.com, vannapurve@google.com, 
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com, 
	dave.hansen@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 9E1C516000C
X-Stat-Signature: r9fjjouifr9epxy538qire9hsxsj3xzm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776114524-104881
X-HE-Meta: U2FsdGVkX1+TrDkU2PyxYRBxUIUt8XGd3rTfLPn1APkcr8DMD2IhisBP4IeyRz6f+5ZQi5xgy+VkJNwFLFCxYyaGttoEtyMTwtYDmvc/jb2T/yLOb+SB5QAUoCf+NyXMf8sF4lJd6sGSiAHlPFYNvNWMsB9yPi3unnT1cH8Ik69ntdjaW5bFBOiLBMCWL6DboynhO289ewQut6YHQhT+Uaoy9MEY86ggG22J+yIUHlELLMY+w2pMWIJGuy9C4ZNXkXfniws22g2HQEx8rPiTW0OMUMbzJMaZfihbzhVrwBTQnKoN0tpxRlrI5BiiH46RoW3lrfyRpyl2QbOmmNPcB31rDDd7jDoq9kQlB0HNNQDy/4myBd/gBwDowd9HlYxZjUNX2fLrKbtCUk0ZJ8J3iQjGo2/amYPZKDzRASU1HQTTpjpIm7TMPatTHzmBHssLaPh73uDsV+823fTUViv4bG4yA3OpGXbE/3HjUSkqCGe9cHuqR0RNBLiSXs5tGjzh/aC4WaxX0m09e6c066PfPR5NI89i9jmebTv2BFD2fKrf0VcyjKmYOAdkrMfarhsXCHrdWUsw1Bhcuw6KmZc0qKZ+7M/LGorbcmInBT9dZ7akGCvVZYxiOyXoFIfB0qUU08G1gF1aWb1wapWK9mU6ZsqO2BbtkjMsQTBBoQsxCeGhx6jv/kWonsXa6PJtuUMZlJ0A5Iafqn5ZquGZgJLwfDQeYHu20HNnvKsi0vw67fZ0xtyd1hOTJD/FWaq6ugM6fjMFxwbkII6URUJON+M1qsOpAl+pBMn/PByoaFjij9ASiQt+YTMC+yc/Vki1YsCertARoRUW27MmEkPAFZiJyXEg2EHXTi+q5a1VTKsgonCQ06Bir0BABrPPtySqrkoJNImXUN72jpmSDBAj1WRf7p7RHi924GjEO9Tzf7MIDE74zN4HAyB+ZrsvyxBxHtV2lsnyjALVxxg1bkoO6nI
 I0V2Up6F
 l5v1Brurdfe8GlsSoeBqAbW5mtAmZUKwsFxKGX//ibH3n23uFWk1KnOuD5f7wzluk6LrLqNFjXHNKxWiueTCUyo68qbNl2gXFiHNAiReIl9pDcjmefn3VWwZSe9Jt0rU6rv75NgnfF253rkIhIQF17j5O791QVYbVzjvaqW3HRdRzIABSDIxametiTPc9HY7EfnP4xSxPo3uO9K6fGlS101obbiNGJZbfc+MqGzfDNgAwdQK44YDVFgRKhVionWXIFBwkJOfpQj/5uevlMvq/Ao/tGbskbnrqPmicQq8kOYuZaCWU0MyqUZ4VK5SedVbWFAMLScXJcD0xnCxis7oJaQ1mFxksg5to0ZDpgW/a/JhdX9ho4xNRgQL28e0tn88N3/Cwz10gaLuiYsnCS0P9HVxqzAHF11O+xmK2JJWZKo96kEihb5WhkFooqYTt/+F+ywZ0g4oEKFn4iqE1B1pqfAphwYbpuv8ODwRxZpm3PHLFGZLaTFNAOhro9i019wFktgNIl3eW+e9MkW/qKO8fKeAs/QyyRbDa6yndc5CFBYzjcU4CXp1cJ0LLnyGlgvEYzeQrv690V2rLelrh3TKFpajFnOg5D94p5u2ma7Sl5/9zsRc5Qt73pFq7TlgMEl1Vyia9obtYvHXYnTgPaT0QDHITEjAmu4wsNA812RjLFumS0gFsPWLBSSSDwT1yt2vI04UpjkcYCGs62Yg8Ow+W/MnX9MHvOBAbsvY87DrHG13OmbI+TQmwQOBoRh4BR66aNwVBFPpECy9MM34/v3EJymA1QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026, Ackerley Tng wrote:
> Lisa Wang <wyihan@google.com> writes:
> 
> >
> > [...snip...]
> >
> >  tools/testing/selftests/kvm/guest_memfd_test.c | 168 +++++++++++++++++++++++++
> >  1 file changed, 168 insertions(+)
> >
> 
> Hey Sean, what do you think of adding even more tests to
> guest_memfd_test.c? Would you prefer adding memory failure tests
> somewhere else? I recall you mentioning something about there being too
> many tests in guest_memfd_test.c already.

Hmm, we're definitely accumulating a lot of individual testcases, but up until
this one, they're all quite small and so there hasn't been much motiviation to
split up guest_memfd_test.

But this one's quite the chonker, so I'd say yeah, put the memory failure stuff
in it's own test, especially since testing the debugfs path will require elevated
permissions for many environments.

