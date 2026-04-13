Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01539F531CC
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6981D6B00B1; Mon, 13 Apr 2026 16:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6485B6B00B4; Mon, 13 Apr 2026 16:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536C96B00B5; Mon, 13 Apr 2026 16:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6416B00B1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:25:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD81DE3011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:25:45 +0000 (UTC)
X-FDA: 84654663450.07.3818979
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC9FE20008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:25:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UH15o9qb;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776111943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YS8g5QJFR8jK1LSnwP5Vk40eZgK6L5/v75MzQ3NX6RY=;
	b=nJGCAvANff9LoRgZb44e7Zb26Zzk5HQlBvioGn6HrHjNlWrPcl58x4i2/WMAf5FPnNOKEe
	TA4pni9geFRgV8pul9gkEPQBqD/zfFMc4Hf86pguWWHIVGBXvpCZaD/OJYQl+g0h9fxJ6R
	4ckSdQTqmjjdmqiOa51Mj9gN4+AlvDo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UH15o9qb;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776111943; a=rsa-sha256;
	cv=pass;
	b=B6YPbBsQoWWZI2Oklb5NfHIhM10YCVh89DvAsIo79JD72q4xlR0OSQ+8H8DgDzBATeuzd0
	d5yv8e/6oyFg0RNA1/QhkZ4j+yA7f3hXh0e1wU2KZ/hV2kiflAcVHdd2cO3ORKA4MyV8VM
	khBbLm7W6tURJpC2DJb2GTAPmXw19hU=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-6102bac3752so735930137.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:25:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776111943; cv=none;
        d=google.com; s=arc-20240605;
        b=Avo7dObJcNJdHla9LBgihQdANdrHd6nygBPvlokQ76umvdc7+lKSUIxw921ErXG3JI
         TDYf1bHt0fzNJ7uq0W3zSErcATudOcN6tujEb+TljBbRF7/WsNbjpZkKgI7TbEG+wf2X
         yeH21ELBx7kDgSFj4/+PhaO6TYbNidNBj2AyA57LVsdT/X0HW7YRFLoTEZ9MejuiQBP5
         ezD6XUL7fOx+bEijk3MpO4YllSJooME//DdTl2bTi31TjuF+1Z2tPXWG0rfl/AILxKYk
         4vtQbU6M7NCu2X2lKNYiy6GoL87vknNG9rLJZSdh1IeFw3AfjuxRfsbTWUvYvo4MpNFB
         0KHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=YS8g5QJFR8jK1LSnwP5Vk40eZgK6L5/v75MzQ3NX6RY=;
        fh=kwOiTHtxTF1wyNnN4zFSrsg5pKPYhrCfGUPwNj1OHu8=;
        b=YUMMvtzClswBlTNPABSm8LM3da7IT+msEFiiXrO6PBldnFI7Lvo/ADdMdMAtH31ltw
         s6Bu8pw3WAEzL72PPdFpljlg9vUV53iEyDfmkz6PLAqYamGCJdBbFx4LHeQbdNzLhH0W
         0S+/LbDyWRQ1e1wRlqJ/q32ts0qY0mP5Br/kBTvjT/+chwNJ9Nli2xhXc2KbK7i2ARYs
         iQDbUKHpTp+8v9wvjP1yyg0wiIsyAZSTA1nqkpR1f0gHgOH4pTOSExIp2Oo64Q3J2s/A
         U7qE0US5X6+BmBpFJBjF4rM2bVCePDXV9qX31zoigOse7YbEmK7SJnMvdwbuXdU+Tpo7
         fzlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776111943; x=1776716743; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YS8g5QJFR8jK1LSnwP5Vk40eZgK6L5/v75MzQ3NX6RY=;
        b=UH15o9qb/Ghch/00oPOQrQJSWRu9P1KcmMpnOzobRZsIRcsp3KWynVDCMCvtHLAH6v
         z52xSkFN30+XZ/90HbzXGXL9VCCDsTzeSx4ePzs2ZS23i80Y2hvtfUbmbJcDLlwC4oqH
         24XwU07bvM3UzZZRQHMgKezgquIdYgGzRKjERxk5VPCex8tsm1oADzOHFYLVQZrjC3q4
         fN7WiFLrNI20ohXqOncsOpTGsjd1/rsnXd/GiFD9e9FwEqnRoC0kM+MP0Z8sDZBy/mS3
         cZRLgrPLQPlk13b03GuDQzQuJlXXFCl6cVyG7WkcqebQRXdIdU2vI0rZwPAbh5g3HUVj
         XAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776111943; x=1776716743;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YS8g5QJFR8jK1LSnwP5Vk40eZgK6L5/v75MzQ3NX6RY=;
        b=mciaeQWGkKv9bX2YslPudMq4wkIRYmqjPrMLh7FdxV585mD1FfKvvOvTlqK+Sg1FUV
         nD5lQHmlPpGYYvd1E16w9lkvcYove1Lj3bQRcl+hZUqGWlyOV4biChLkZ/uEP2BeiJdI
         zpTkP+ff1CpLaLpNhJN7pslfdNkDmkRFABi1pmzejT9Ckq8XJxWJAe0DZ92UzaMVAbZk
         3sYLPJHJssct9EMhNvSg2qKXRW9abr867EpwubIWeDWJWd1ngmfefXFncFx5hwwBkVK+
         dlUAT7qXm14nQPrmOR29VwD/gj1k+/6lgm9sRrlT2MvZGLihSzy3OwmudvJoJpL1DGGG
         FRCw==
X-Forwarded-Encrypted: i=1; AFNElJ95JV8QNzMlqEu5Hm5SQLaXYX3R7Gx5ZATN6ju35vlkZv+yLhXogM1g+ujdTvi/rxeE5uZOHDvFOg==@kvack.org
X-Gm-Message-State: AOJu0YyeGfM9RV+JGDK1rhgrIcS9J5YMHKValG9QQknqpjhoy6x3zbNG
	tF+v62tVNnDqqXTKb6dkS20uR6RDR+SXg3lBxs96b8Vo5neXE9JRbbfbQxY/Rxg6SLg0M34rRwm
	N8rVD/OdFQT/uHrlskztE1cCOaKeb/7w8A5QK4oDm
X-Gm-Gg: AeBDievDx1foyHaX5svzffhFA9mwNk0Ce/xFYgRoq5ohE+50RncXPL90IfrEVY/Kp+h
	DEALB1T3teo40TaN6m9T2/TQFd8kmwJ575tDSZogw+0Wxf76KKCdiFVJMQMU/yb5dnvEmZAq2Pl
	hhe5r1mXg+0HwkJnmwETbR/5+WuszPj4UQVLaTwQqbnHhZrmMImYVHqgQn7OzpLe+ByPR2iT8gm
	nkgSihpo5O5NUxlIiPvEzy0J1OXBIB3ddOXbzby5AjVWPToqTOorS25Ap5ivZVdZcZHwL89d0OJ
	6uZPUX6bmdvKGf6QemAtDam092AH49QoOf5Yihqv+6rsa8xrtgOlfp6urKYGTxZb7l+powdEoDx
	S6+tM
X-Received: by 2002:a05:6102:26d2:b0:5fd:f2ad:c653 with SMTP id
 ada2fe7eead31-60a00e44498mr7057732137.16.1776111942452; Mon, 13 Apr 2026
 13:25:42 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 13 Apr 2026 13:25:41 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 13 Apr 2026 13:25:41 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-6-718f45eb7c75@google.com>
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
 <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-6-718f45eb7c75@google.com>
MIME-Version: 1.0
Date: Mon, 13 Apr 2026 13:25:41 -0700
X-Gm-Features: AQROBzDGuqFmnG3vyngPb8K0V-pWCvWE-2AOnqZC5LdtA88YUYKMK02KSxNYndw
Message-ID: <CAEvNRgGz6CHgCtR-PpyiRDy4tMioTGgYDFrzuWCmAodMcg5EWA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 6/7] KVM: selftests: Add memory failure tests in guest_memfd_test
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, vannapurve@google.com, 
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com, 
	dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC9FE20008
X-Stat-Signature: c4qhfduppzzco995mwetmdd1jth81weh
X-Rspam-User: 
X-HE-Tag: 1776111943-234272
X-HE-Meta: U2FsdGVkX192lGSWo0/C+0CHH4DulgQREf6Gj9ymali7GWfsb40D/EBsJL2BVO4POyzQdBcLNWzjtGsz+nf+mXuXp6gM5Hg8fX2+4kzXkrabvPFEPNA5GcCAnzd5Fuw1yaDmDdHm2pckJHijvRFYaj/LxmVJCDVC39F9VwOI9wPOU6qztEXB0t7qhkTNilRkNNoG/eWrTkfH6QSIWhgKe8JcP4X5gkQT2sSIWNfGfNi4BkYRbxFgwn90WhEaQqBWDlA9a6kA5bTD7uw2ii4vK3rf8VqXMpdQHScND8PDefDWo6DXkwG7JXWrRaHB4MRu7KfP+HdmtMwqykq4ws6WzTqNcyeWB2EVkVRidURC0HqVus3rfME2z+oDEswi2iPHT7veKsbFz945X0HjOnSepYJJ2/NWbSrqKt8Ql/Ev2Jr4fXjYZAFv8Y8zpZytMq7tK6AhfV7HmwB/lfk2sNh/EdTlGC1vW6PyIbY17W6yVTZV6oEpoeswTJiGLAXCBEEF0E+Q0QilAcuxTuaglgmzFRhvaH0WFHMTMeZyDIWL2+ZMo9vKeRhnRcvYmX0A8SIswjQtN1VwaPyu6+hz+p105JupqvyuCrNDHviBvnCf85VbceB8KBIgwhn0KIlgcLvnIxHtoxX7gm1gKbSH1uipe4OkWxi659/YNvT03T7CFIHOTO6f+CoMqFDz8XgR4x9fX6ujVzln/eKnirw1dt1tsLG6Qr44dbwjgZPl8xlGbIe2JRsv14+NXJOd46CSepeudXEv7VMa9QWkjTXtimVTxXzjxH18J2+VaMuRWqnlmkzWKiENbiUY0dvG7efJiwExQY9fwh7AntmdKT8hxK6rGFA+/GCaY0aP3yJOfjOrJJN2OVlhVXfX5Jp5g628Ikah1SYb0mQzYuqMlk64Ccz95zQK0a9/XUSoJcDoyy0HXE0qehnMMU2hsor3vkiiIBl39uVK0gcM/W7PijPYT9c
 kAzHtZzv
 Wz2ASURduNcHgDvWR1T/K3U4KRQ9Nt/MBZa5pHhrPPzBXrCsi96FcSsQTX6FZvPiqnerskUo6gsuBcMuguQiO44BhSHHyOn5aS1r8i/s+GsMn8nHx+tStgeb8QOa6RQl9xst3WMUwo78aZ8hTNVxZS8hAZ8ldfVktkq38l62qTfviizG8Qvq2UKH78h0H7rs1sjAq/eAzLHit+zx6s2AOTIjkoCBnTurGnMAiI5HoSPjqcLh3E731AWQgHf3Hgts6Px4yu1pOb+R/wJFSh+jlxssGwusIa4cGoXnDJRRgc0Ej34QBqQh2BhGanoCPgKT9uV/ju66T0PEPEeVMeXz08UW0h7isn9vx/fFF4c8FTepkwElCNiX1JVcXg/30oUfp73H2FfN7paXoaUCNWhJjSGgqvPQsg+3Ekd/MZ6eVRzXLyMZJFgRyblXt9N/NntJTdo/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lisa Wang <wyihan@google.com> writes:

>
> [...snip...]
>
>  tools/testing/selftests/kvm/guest_memfd_test.c | 168 +++++++++++++++++++++++++
>  1 file changed, 168 insertions(+)
>

Hey Sean, what do you think of adding even more tests to
guest_memfd_test.c? Would you prefer adding memory failure tests
somewhere else? I recall you mentioning something about there being too
many tests in guest_memfd_test.c already.

>
> [...snip...]
>

