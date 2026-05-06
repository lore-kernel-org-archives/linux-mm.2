Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4E6CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517FF6B0005; Wed,  6 May 2026 11:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFA06B0088; Wed,  6 May 2026 11:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C996B008C; Wed,  6 May 2026 11:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3217C6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:05:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D30161A0122
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:05:37 +0000 (UTC)
X-FDA: 84737319114.03.634E12F
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id A2C5B14001C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:05:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AT2nosJh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778079935; a=rsa-sha256;
	cv=none;
	b=JP0EGWFOpasi09q5Bv4olB5Vklv6YpylR1DOafXdehH0Mj03oOLeDOonT7jJLXnYUECblm
	c6jpUOyjsC+7hnMu7iNgEsh4mNHr/YcFGIVflyYMHXjYKfSW+tjAAka2aAV5SOUwDGwG3L
	rpxMLwtlV8GwUHIVIXPqcWTg0QGdR4c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AT2nosJh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778079935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGancg+Hm6RuQ5CrvC9iAES266oQrizaBXy/zKyB4a8=;
	b=7LvLiNYsuZTzeZProjTU/U9hLUyMHJ64E9UuWQzmHMj9MrFP8jt7dLwqeNzaHbDKVMgzaK
	buBFDLp5lE6kP0g4p6eLv0czpyL+PZaYP0/WD5x3pBvEII6ZAa5+6o75dfzmHKpASIoDnb
	YCEqZYF+fDVpiCQs6NzbNuAYKWv9aRA=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-651c7ddf514so6801851d50.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 08:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778079934; x=1778684734; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pGancg+Hm6RuQ5CrvC9iAES266oQrizaBXy/zKyB4a8=;
        b=AT2nosJh5fds8Pi1+Sn++PnuSvX9f3q0r4cYqDPCo4JUEspp9kjGR17Qn1Epe+roGr
         5RnM8OA/zgES/SiXSpd7U/pGtl6kckI3ufb4c/WTdPl/y4c4PLNFCiDXnRjARFDsZ/8+
         dlBWyXqxpDe1NpRY0dYeln+KXAkFpQSvcTA9uTKa3dxY3iiYnXH0MqUw2/5iqCMOy9oS
         KZIz9Hj5YyWnJzyQsbyz/sAMSj/Enn7fCNkSW7LZ+NBPAQtswwPyCLk0xtS5Omph/OQ3
         IHXfGnvctzkABDnPOeQ31eQ8JTAMkETaa7/21wrXBEkkruzIEEDY2Ge0eiY1bPIr6xfy
         aB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778079934; x=1778684734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pGancg+Hm6RuQ5CrvC9iAES266oQrizaBXy/zKyB4a8=;
        b=NEn3v/jo14UdHX4/0A6eWFFQwCVHLxWjo+vQQAnF3/a+nOGIYSOzSEKcEK34e3Khx+
         0v56elGxlOQMnCOwiVk01K68hk6YbszQZcRzP+utsvgtDFVtSn1+AuuVpnh5WT8oPoOh
         aAQF5UPOYG8umit49k2oWwDboYYaKhEy8ohiaEAlbHaONcKt8Tl6txlTyKgw/+fF2wND
         bd4EpsRNz9p0s/bkUSueHS8+lR1S870hLHS9dpMUK0GUSpZYIJaLnVibR0+yLN/gKzbQ
         gaOuHIWEmLJ8s9T6R6JzRLDkPOE37jwW+XTbLJI3RGk1jl5gB3suijShbHWBgTn1/mDo
         qrOg==
X-Forwarded-Encrypted: i=1; AFNElJ9rro/t0v/X2Ar+lTbJ/a4VrjVlGFn3iAGdgk96UOZdSdCm2OazBobKEeaGYxa71QoF9BjB1QSO+A==@kvack.org
X-Gm-Message-State: AOJu0YwfS1udNiB2TVZHtDGexP3rEg4nK8RGfx3a3ppmEsf6B0ZWplqy
	CDxX1/8Hl02GnZjoL7D05gR8tlP5fAXlHAVsOBcZFuzOIomxSkXZe+OkgBnDwHtE0dA=
X-Gm-Gg: AeBDiev6ccv8GUBGQ96CQgmADGuMW1dbicaUyJ5D1N8nvv+Ut4iE0M9zEbcQqLn4SwI
	MFV76sFoVdUxq4kyPhwRGPK5aI8cLfbg2ITYxhpIGIMF1CM2f30eocQs1l9TJTf0PbGCoL1kT3V
	9nndSn8TrbDjYO2y0eMclngSoOh04v8aKgEEJfqpm3MHLBoANe2/JoXZpZx0i8Y4v1BJ8q0Vmhw
	Ztcn564ytDrRfU5qCaVkSFTyHDGY3IntfekaJhEOhD413MGgXEA0/x1VK+OkwS3L8jHrT7677JW
	1J8gGBJ0ZIPV5GykIXi91qblY0iLS37vetNo9DaAE5whGF4zipVhI7u5Ca0/AGwdO/B6m8hzJ65
	vENqV63rYii1ItELYb3/yf6Y5zbcLbKwjoKNo8B1/NfRMfAglKUJichMBIFyB1dUW6xvXtOGBbf
	tmK0FYdNLUH13KB6wUFnsn3HIL4GgKzm6tNFNUHmvigB8xkjRj6nrkUPLXn+AIMlADKwqZHLGqg
	xOJUv6XL0pXMSx+93dsdlUDigdvt7ycKOuomaf4
X-Received: by 2002:a05:690c:f13:b0:7bd:4792:66f0 with SMTP id 00721157ae682-7bdf5f24c83mr42505907b3.46.1778079934356;
        Wed, 06 May 2026 08:05:34 -0700 (PDT)
Received: from google.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd665694b8sm79860377b3.21.2026.05.06.08.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 08:05:33 -0700 (PDT)
Date: Wed, 6 May 2026 11:05:32 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Cris Jacob Maamor <crisjacobmaamor@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] liveupdate: validate restored LUO metadata
Message-ID: <aftVd5RnpnAi2jdc@google.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501173053.73116-1-crisjacobmaamor@gmail.com>
 <afT_xHDuFwAUSR0X@plex>
 <2vxzse84zzag.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzse84zzag.fsf@kernel.org>
X-Stat-Signature: pc46mdpcrc3s6pjkhaq4sjtg1i6r7e8q
X-Rspam-User: 
X-Rspamd-Queue-Id: A2C5B14001C
X-Rspamd-Server: rspam07
X-HE-Tag: 1778079935-255714
X-HE-Meta: U2FsdGVkX19X4S7butQRhy8rrwdLYmR+ybJ6hZXbsYi4UlDUhV+azXxUFod2vdZZrZDDqCH7FAA8IFiT8A4ZYqVcOsVgNb0XLS1vp+1JAQi4qaDqRnKjTHZsQ6bgaHiFwTRmQo4nXMJt5nTn142ueBEeZtkniAjDcJPS6ACd6xpHAkhni6MkVtR4Vv7Va12w4VpSV7lsrl7IPXnKZpGXx7nUUVlPE/Dj6bMYvOBQhIP4Xc9sffH9OKrfzpAJO5jhfmIt8JYhOTedGQHdkh64rxTJ8PVyQVgO/kGXMgsaOW2clvO52Wdkb7HqdiD2yf/mrfDy4W+vzl0Umsw/dJFx3Y8oOPl8cmfUtjhpKbpnV272EZg23pcoNBnA/Jt6B5/UUDW8rJJJQvrQ2Zhudf676UbZ6r8ictnkKNRd4QaQlXBlmekVHSx45F29Lv5HqB1fz7Lnji9Mu8ZuAU86VWInJw1dyPD4CBI3JQjFYuRKUAkACy8RXYCYV0b5DM9TtVOaE3ou9fZHMpMp1pqK6x5Q/WA8S8saCp0GwU4x+TvoydrAdOqPpDwP3mYhRMkfoMFok/ZpP6pagQcb2LGyCVkSSIk407LJ16O26xxmNr123DGxOhoqq0r6fFwj1TOK27a2SiKOj8basdPhf+vyULQrqnJaXrQ2YvBOzHMCHhI72jOtmxwY0EzOaz88trICl+Lc0sfXZNSxmhQ5F28x5mUL+kEo5AuCqqK6XtIOHJQ2Tl7MXLCGLmEOWvBx7QTkWtMJLJmTXP6nO/1cjzE6FBJ9Ic/aRckP89JTEpK0xGBQeYSZaXMd9rPbwhO96afHcTF5v4WjxI7IKfj6fsSq7o/Rl5iogF1rFijhCe6sKynjtFiWbc1W2sOlarXFEpr0EjhOse3YyeAu/zpHnAIybixCtDBbzAnyq7eNZoXnJKFCnrqJ3fbwfsjCOoZ6jDdDjoyvwQtzz1un+DwBtUqo4BX
 cz+Y5TGT
 N7PB8es6gnPE9pv+F8/r0La8Ca+vTiT0K3KeYKTkj6fqsTAmp/AAIBqCtAG3yIkidDuWOzWl8HgFgkGlD2XlbLzRBVu0qYLM8Lh9MubPx+hE4dz+0YeT3In11+uaOWUmxjq7/Cr5HeIsPI40HbMqr07L9svsuwRaWaYxIv4+kBAUe1X+lISJnN9TGYno4NrVJg5AKNoRtimYe9YxGk+z6tGbg0QoSsSisuC3zB0kY8tC4U8LI823uVOqZoWE5jclXpDci7KVwTvu3OLh92vQ7/xuGJ1VBId4vNaJB8ulRAEc+aKKTvKcl9gwz2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-06 11:02, Pratyush Yadav wrote:
> Hi Pasha,
> 
> On Fri, May 01 2026, Pasha Tatashin wrote:
> 
> > On 05-02 01:30, Cris Jacob Maamor wrote:
> >> LUO restores metadata from KHO/FDT during liveupdate. The restored
> >> metadata contains physical addresses and count fields used to access and
> >> walk preserved session, file set, and FLB arrays.
> >> 
> >> This series adds a non-consuming KHO preserved-range check and uses it
> >> before phys_to_virt() on restored metadata addresses. It also rejects
> >> restored counts above LUO_SESSION_MAX, LUO_FILE_MAX, and LUO_FLB_MAX
> >> before traversal.
> >> 
> >> As far as I can tell, this is root/admin-only; I do not have evidence
> >> that a normal unprivileged user can trigger it directly.
> >> 
> >> Changes since v1:
> >> - Dropped RFC marking.
> >> - Added changelog text to each patch.
> >> - No code changes.
> >> 
> >> Cris Jacob Maamor (5):
> >>   kexec: handover: add helper to check preserved page ranges
> >>   liveupdate: validate LUO FDT physical address before mapping
> >>   liveupdate: validate restored LUO session metadata
> >>   liveupdate: validate restored LUO file set metadata
> >>   liveupdate: validate restored LUO FLB metadata
> >
> > I have replied separately in the security report to clarify that this is 
> > not a bug. The behavior follows the ABI specification exactly: we use 
> > the PA addresses and ranges provided by the KHO FDT tree.
> >
> > NAK
> 
> I really do think we should do a restore-only variant for the
> kho_alloc_preserve() family of allocators and use it everywhere. It

That is unrelated to the provided patch series. The author of this 
series reported this as a security issue to the Linux security ML, and 
submitted this series at their request.

This is not a security issue, and in fact, it is not an issue at all. A 
restore-only variant can be added, but I do not see a reason for LUO to 
use it.

> would prevent problems in the future. Not because the previous kernel is
> malicious, but because we might have bugs and the KHO page magic sanity
> check acts as a defense in depth.
> 
> For example, I am currently looking at a LUO bug where LUO does not
> track if a session is outgoing or incoming. So you can do a retrieve()
> or finish() on an outgoing session. A lot of nastiness is saved because
> of the page magic check. Things like kho_restore_vmalloc() or
> kho_restore_folio() fail early and loudly.

I am not sure what bug you are looking at (please share the details!), 
but the fix absolutely should be to use outgoing/incoming sessions 
properly, and if we mixed them up somewhere, THAT should be fixed. Using 
KHO restore is not going to help much; however, I agree it can add 
some extra scrutiny (i.e., similar to an ASSERT), but it is not really 
something that would help improve correctness in any meaningful way. The 
correctness should lie in the LUO logic using incoming as incoming, and 
outgoing as outgoing.

> 
> If we want to squeeze out more performance later down the line we can
> move it behind a debug config, but having this usage pattern of always
> restoring before using is going to be a lot more sane than just using
> physical addresses willy nilly.
> 
> The approach this series takes with kho_is_preserved() is the wrong
> design. But a kho_restore() or something similar (maybe we can find a
> better name?) is really where we should be going.
> 
> -- 
> Regards,
> Pratyush Yadav

