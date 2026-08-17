Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098DAC5DF7D
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 21:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED916B0110; Mon, 17 Aug 2026 17:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75D76B0111; Mon, 17 Aug 2026 17:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17016B0112; Mon, 17 Aug 2026 17:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D48A6B0110
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:47:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA40280868
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:47:23 +0000 (UTC)
X-FDA: 85112097966.24.1CF91FE
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id B236D140003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:47:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h4WBWItX;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787003241;
	b=uEnnSKv+//QK38/6hFzzbZL0hoXkRbN75w5T/0r8u4RRNhS2KXh/qUPXA8FhG77bEO0Z2R
	H+owlMePFyN8PHYy7Qk4QG9+rNawqU0X/aTdkoeXW8qjtM8XuHAoO/Kr7Cr4aZncOwwM6y
	rNDXEpMmz8XxcXa61qTWgSFOT6SEqis=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h4WBWItX;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787003241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxYBvhey30XUfJ4ax9nYh/jGztjdRvDgSMhAvB0aQsU=;
	b=W5k1u34laVW21AAp47rqyiyrTQKf6xoVB2UWLTdiPJb+5emS9y4mIS5ZNSYZTa8Xa8meVr
	ouoaI9i8QoodhsyF4tiPgpenC3yCzCkWAI7n632yKcz32xftRa3lBK83eb86Z/m4osf98s
	R3/b/0QkEDxx6QxQwa9AQAs2kYdykk8=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38759bcd877so4623516a91.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:47:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787003240; cv=none;
        d=google.com; s=arc-20260327;
        b=BSfjWrmhGjWCkIzm3uq1agv4hOLkPajRi6oIbIRsZZZEeF7iSvX4jwCN1x2t3RQ3/M
         0CXh2qSnPg2pGEga3JvRmSgL3TNTQrSb6802oMeB3cz/k4sQUSQAlL4YeIWDP581SAZI
         LDhz+2w5rmEzs7kFX1RKNhSNnDvSahneF0DNLFB/ftbJpOjzIa4CGDR5Z4lRjFj+cl4D
         hXhypTOB262fsfvJgFgDhnQBH/m0BmSaXvAkYleOqFrBHReOBnrUdhu3scF/B8iSAW4c
         OI21T29MgW/T7ZS+d5uzUkjf+OMYCGlXe5FzdR+EZ7SZQ3Kvy0gh5Yteu/KFsRAXnzeE
         61Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=DxYBvhey30XUfJ4ax9nYh/jGztjdRvDgSMhAvB0aQsU=;
        fh=6Z75gwZEwnRoRrFgQxsxz90WHAxMcylFAA0QP3Ytc6k=;
        b=MXXX/z127M2IodkXuAHR3h5TkJE2bZloTLf1Z71D3acA08lYHe03fD77bvJ8FBU1/X
         m4z9IPtFAfNLTldJrT7JfHNOtCoCxpW8M65xrqHn0+QrxLYRpi//ixbO3xhYgO0B2BKI
         xEDup6u/VTI85nR2mF++E2n5g7QZssxC6NqDlLkfcjsT9hXjKTJmzs1SpEkzSD/gYSkm
         jIsJEQQUcGST5b/aGpWg/6pEvZWx96UBd+nkNiio4qwkM7NEBbBd0CqQ2667EgbSUz61
         p2i5bq4f6BY5q69UyhISoJUbqZlAeleqcb7k71kVUwHDCssuZeWsbRX34JLV2S3YLCsV
         RsCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787003240; x=1787608040; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DxYBvhey30XUfJ4ax9nYh/jGztjdRvDgSMhAvB0aQsU=;
        b=h4WBWItXsNMyZgza1IgEA6MH9l0/WXM3WU9yh8h1Gi2vXiief/IAx0iWGhsK2OhaCf
         Z7eIxZlOZ6NPG5nGkAGuGpmzvDfc/NzfqO6/19WuH0Vx+aZlNdJhFgqWtBL+3dBTlB7M
         ahAZUAuzkw8w0cxZCxbqHAxYl7Nq7t9qvnvSUXEAEyP/Kn2Ab/JRffuOHxPlWdpd+Sds
         5OEGPaD7PUsnmPdw6WjePOZMBK9WkMqrTP9KsuhA35ASE+GlskCN5fo1OnTgY/L5jiJI
         A/nSd0Q2YSjPOlOX/132lBiJ1RzC1fL0O1Cnw1/IFDxrhOJexxEmfoC5RdBtru5hITVl
         5QZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787003240; x=1787608040;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DxYBvhey30XUfJ4ax9nYh/jGztjdRvDgSMhAvB0aQsU=;
        b=r/r5fhbvPXkjTtn/P1AKf8wx/dnKrKEKcBxSqB6IFpSOCyJ5+H6SGOqy86B6V26D4O
         aJXD/zLt7p3UHa17Boxtq/M7Sdc+BkLjYD/wiN7u+8JvBpzIe9veFJ5OsO7tp5/uMECX
         6Do9tu61wINB50HoHQEozN9jDFUAXLIdrbmer8ndbTeDXYCqfArKQQ3/0MQMTlqM2c+7
         Bngt7WfJyD9Qtn0+4bhQWJU7fOO+4uctWBSl7pTOry09vzSJVL7Hhgiz/Y14Y47IXoqz
         ShpyzW1Tl0g5Q58T8n43JqDUXG2ugjg6bsYrn8kR+/bCv03V6+thavoFTj1lPS2BGdYy
         I1Rg==
X-Forwarded-Encrypted: i=1; AHgh+RqgdfbQSBuX1dICmX5AkGAUOIBVaAFQ6pQ1CLhQlVrwOtSMIyAECtDNG1O0ZPXSs4Thfvu8Ax+93g==@kvack.org
X-Gm-Message-State: AOJu0YzyEDVXc3XXNYL3CRmm1IREqBsk5Fm00gwFjXQa10OdwtEaNoNP
	oPL07QoNbkgFSmpVOWgwZeyE+EiayIxqwTbjQ+r420OWfueakIWnhvvL9BZBXhpKc1Qqx4TiltX
	GDXszZn6MZMdI5BiQX+0wjUBFnAJMULAq5D7AocGb
X-Gm-Gg: AR+sD11vOQ7eAApovZOWANy3Zp6tHdN/esAyXvxUbjgtWklVVuPVFYBoijxQ/gyn4Ea
	0BvidqhtqTGbo708ygIpySxuXTl64/yFKmXohWGXIGJM259eSISln1xbg+B9eUnPzv0m9v/v8XX
	dXBnMCUIeaUDTskBVxaXWwxs/A1dshEwQ3uzK2w5M4MkCubsa1Zgc5k8O9QDITcg/7RMyNPtYYi
	2hQioTRtwWfz+qx/IZ1DizTM2DKkckw1qf2B5IZTZXJvCX1AQpCIFKtKQSr6jrcrLI4LLlHjIko
	h0qIsx6twwMCqp5ABNLASwbKKgaDCPtGmVCE4twZfmjholz53gSKyBiMD0x33vEv8bjo5urs+jP
	Y6ZCtdB/nI+ry
X-Received: by 2002:a17:90b:4cc1:b0:37f:be6c:f3f2 with SMTP id
 98e67ed59e1d1-3933bd0dd0fmr33755002a91.2.1787003239624; Mon, 17 Aug 2026
 14:47:19 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 17 Aug 2026 14:47:17 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 17 Aug 2026 14:47:17 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aoNrFX9yLfsM7KQI@google.com>
References: <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com> <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com> <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
 <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
 <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
 <an5RJYTwlYeym--O@google.com> <aoKnmW9St5zCoTD3@yzhao56-desk.sh.intel.com> <aoNrFX9yLfsM7KQI@google.com>
MIME-Version: 1.0
Date: Mon, 17 Aug 2026 14:47:17 -0700
X-Gm-Features: AcwNN1VpUAMbtXtdgh721uPhtQzbHJAxofv-9Na5pJ24kSfJuEcCQlHEnwy5G0c
Message-ID: <CAEvNRgH_=8YqKHb_OJfT583ZJ346cceRimd9YJ762Vv08uJGHQ@mail.gmail.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "david@kernel.org" <david@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "steven.price@arm.com" <steven.price@arm.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "forkloop@google.com" <forkloop@google.com>, 
	"tabba@google.com" <tabba@google.com>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, "willy@infradead.org" <willy@infradead.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "wyihan@google.com" <wyihan@google.com>, 
	"pratyush@kernel.org" <pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "oupton@kernel.org" <oupton@kernel.org>, 
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "baohua@kernel.org" <baohua@kernel.org>, 
	"tarunsahu@google.com" <tarunsahu@google.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jthoughton@google.com" <jthoughton@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shivankg@amd.com" <shivankg@amd.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "youngjun.park@lge.com" <youngjun.park@lge.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "corbet@lwn.net" <corbet@lwn.net>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "liam@infradead.org" <liam@infradead.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kas@kernel.org" <kas@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B236D140003
X-Stat-Signature: 36b348hpdmqdxwdtagf7yrprhdtn6sjn
X-HE-Tag: 1787003241-440844
X-HE-Meta: U2FsdGVkX18p64+kiUhycO+hd9ni0J+CgRYkr7VaL4GZiJYDHA4HTr+OV1Crnr6cyysMyUQeSOAo5ZfEPB6+G5yVM+5EDW9PidWHFkG0CmQFrAwcwtN1zcx5NKiIfgEPKGYbIsHyFLATAfkruNdtedr2IP8S2zvOqUON4w9bN3chqBeF4k+rhlPPpr1S1QQK3eAlKs736JGcz5ahyepxMSHk0aV5lVOfihmRV6dcKRMBnq0CKyVIWQgYwt2H5nhuGloi8mH7hO81kgzUg7Mdf1vOuWeEIwoDV+NtxCoO/spHI3V4iqllJ/NXlfMVO2yg0OW4VJbJjy+MF7viSsyrUsGWxwx422zjHKnsZJtfZMLt6GxPoGTIn7sPPIuzhAIDHUwK8B59Ct2et+gDkbZ6X7p9Lx+7OYt/AnLvnVrlDnkPr+QpFh6SITsIErSQiVZ+xPhzT/Nle8knzV8eVYNkE/k4wW4JMml7m661xwRftMuZBbp/MEl4hVe+AWAa0UFrM90hd8kjcn+zLrv2olRJveW5FyWIeJ9trIqROft1BYPUlTmRniqHCDQRQfKTEu93NK8l4mhoIQZoqZewCJuNF/0vDql1AM/3dpQ64FD+ROuIZqfzdg32kAnHEySorGdC7aWiYBj8OXGkcNFLLP37xIeUSO5YUQA34lpd2oFkWUMY9DlGfZ7gyxc6qczeO/tovq5ArEYnXvyCeCL3U6MmWwhk+Q3N/d4CQE3vDjwzm8z54bsWv8DyqnFaPaMalVJpc4Sa82lo2qnmtfEfHYYJM+FLV5P+ansHEzTd+ikUU6krQ7DCnbHs2MDrMxMr/Jh16HLFmUWUOMIzRHGgu1CFH/rwQnplRYXGgoN/VR1jAckOEhCfyxImJ5aRouJY6BVI5X+4rQy9zVeDNj+7MlSxZXFNSIc2Wn0HoUu5Kft00EwfWrwckwJd6iRC9gCyl04qHRL2/scjd971yjtsruJ
 jpLhwoGi
 Ae4xSl0gd3uS06UOYzxTvQQnqGS89BQWJ+oce6KMUw39cpQQzyzEaK8oGRLEaU/sa4wHjjgg2saEOwKRE6AncIplw9QKsSGpTdbsoUlhiq9wiRMzWSbl7Gy8XAzkKcfAMzYMvu5PkK7gWEJ2qmbA9Z5bbssug63HiuOAue20HbiOh4xbz4St3vk1YQLCI0VJI4e6fC8SPSYR/VYN7+L3s8upDRjMIexg/l5A9GcqIcj3QTmiyszGOx0qAzgZUHZSkZybIO2W5v0ThqNmJf0P9/cNPn38nM1d/qtYrdLPo0LQsULE1XE15uIuhd41cqLc4V+xLCyLuVfnoYfNYu2wBLsXmdiz+7Vky7Ze3XewcS09qSMOulGExh54Q8YUfXjrwaVvMtITJcx4h9sM9eMgSz+MDLed3NDFzr8Wo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Aug 17, 2026, Yan Zhao wrote:
>> On Thu, Aug 13, 2026 at 04:20:05PM -0700, Sean Christopherson wrote:
>> > On Thu, Aug 13, 2026, Rick P Edgecombe wrote:
>> > > > > nicely so we actually just run an old branch's TDX selftests against newer
>> > > > > kernels. So the branch is a bit of a pile, and not really suitable for sharing.
>> > > > > We plan to clean it and upstream it when the path clears. So it would really
>> > > > > help to get those basic ones upstream. We remain happy to help, so please let us
>> > > > > know.
>> > > >
>> > > > I guess at this point I'm hoping y'all and Sean are okay that this
>> > > > conversions series merges, and we let this stress test failure be
>> > > > handled later. I'll be around to fix things :)
>> > > >
>> > > > I'd say the line of sight to fixing this would be when the KVM MMU only
>> > > > gets PFNs (and no pages at all) from guest_memfd.
>> > >
>> > > Hmm, I think we shouldn't upstream a uABI that we don't have line of sight to
>> > > making robust. So it would be good to settle this thread at least.
>> >
>> > This isn't uABI.  You're talking about hitting a race condition between one task
>> Hmm. Perhaps it is not a uABI issue, since users are allowed to retry. However,
>> it is hard to convince me that it makes sense to require users to retry a
>> private-to-shared conversion before a GFN has ever been mapped, given that a
>> retry is not required when the GFN is currently in use by the guest.
>>
>> > converting a page and another faulting in the same page.  An NMI, SMI, or IRQ at
>> > just the right/wrong time, especially on a preemptible kernel, could lead to the
>> > same test failures, even if KVM drops the refcount "immediately".
>> Could you elaborate on how an NMI, SMI, or IRQ at just the right/wrong time
>> could lead to the same test failures?
>
> Ah, sorry, my bad.  I was speed reading and missed that the key to your suggested
> "*page = NULL" change was that the reference was put _before_
> filemap_invalidate_unlock_shared(), i.e. before dropping
> the invalidate lock and thus before __kvm_gmem_set_attributes() will walk the
> folios to look for outstanding references.  I was thinking that putting the
> reference right away was just shrinking the timing window, but putting the
> reference while still holding the invalidate lock closes the window entirely.
>
> So, I take back what I said about this not being ABI, and about this not blocking
> in-place conversion.  It most definitely affects ABI, and so needs to be addressed
> before merging in-place conversion.

I thought back then when David suggested that conversion can return
-EAGAIN, one of the core ABI benefits is that this leaves the door open
for things to gradually improve. If we can improve stuff within the
kernel, then the the kernel would just return fewer errors. This retains
backward compatibility, since extra userspace code that handles errors
can continue to exist, it just won't be used.

> The only question is if we want to commit to
> guaranteeing that conversion will succeed in this scenario, or if we want to take
> the easy way out and formally document that conversion can fail with EAGAIN at any
> time, even if userspace has never mmap()'d the memory in question.
>

I don't really think there's a need to commit to this, IIUC in
principle, ignoring that on many paths of those guest_memfd may be
excluded, refcounts can be taken even if there are no host userspace
mappings. For one, memory failure handling doesn't care if there are
mappings, the refcount will be taken for a short while and could cause
this conversion failure.

Here's the relevant part of the documentation added for conversions:

  If this ioctl returns -EAGAIN, the offset of the page with unexpected
  refcounts will be returned in `error_offset`. This can occur if there
  are transient refcounts on the pages, taken by other parts of the
  kernel.

  Userspace is expected to figure out how to remove all known refcounts
  on the shared pages, such as refcounts taken by get_user_pages(), and
  try the ioctl again. A possible source of these long term refcounts is
  if the guest_memfd memory was pinned in IOMMU page tables.

> I'm leaning pretty strongly towards guaranteeing conversion will succeed.  We'll
> still need to document the EAGAIN behavior, but IMO there's a massive difference
> between conversion failing if there's a lingering reference acquired via a VMA,
> conversion failing because a vCPU page fault raced with conversion.  E.g. being
> able to assert success in a very curated test, as the stress test presumably does,
> would be extremely valuable for helping detect/prevent edge case bugs.
>
> The argument against guaranteeing success is that we might make our future lives
> harder, e.g. if it turns out there are legitimate, hard-to-solve edge cases.  But
> I'm ok with that risk, as it seems highly unlikely to be problematic in practice,
> and there is real benefit to guaranteeing success.
>

Is there really a need to commit to anything? This is already documented
as "can fail", and it's orthogonal to whether the memory was mapped. The
transient nature of refcounts on pages in general makes it hard to
guarantee, and this stretches outside of KVM. I mean, anything could
take a refcount on a page in future and we can't be auditing the entire
kernel for no refcounts on guest_memfd pages ever.

>> > As for in-place conversion, this is not a blocker.
>> Sorry. I didn't intend to block in-place conversion.
>
> LOL, what we intend and what happens aren't always the same. :-)
>

I don't think we're ready to guarantee conversion success when
guest_memfd pages are not mapped to userspace without dragging this out
way further.

I'm all for KVM not taking any references on guest_memfd, but I think
eliminating KVM itself as a source of transient refcounts can be a
series in itself. KVM not taking any references on guest_memfd memory is
definitely welcome, it'll pave the way to using non-struct-page memory
in guest_memfd.

It'll come, can we not block on this please? If we find a way to
strengthen the guarantee, wouldn't that be an iterative improvement?

>> I encountered this issue during testing, so reported it.
>
> Thanks for doing so!  I'd *much* rather sort these issues out *before* merging
> code, even if it means delaying the merge by a bit.

