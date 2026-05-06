Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E813CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 16:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7BA6B0005; Wed,  6 May 2026 12:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378906B0088; Wed,  6 May 2026 12:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267C26B008C; Wed,  6 May 2026 12:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16AAB6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:34:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA7BAA0141
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:34:15 +0000 (UTC)
X-FDA: 84737542470.17.BD229A8
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id ED9AD1C000A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:34:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YW9tmzlo;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778085254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSINYmJ3vJWPFl8vzHtHzlEblnGus+VWg6G+vnhXyiw=;
	b=fetiwhXsLY2AejcR0+yXmjxButb3Qe/dc4CtVaxDXmiPt5FdUT8cI0OFkLoEqqjbmjOwrI
	xc2XVezGDKZQtkf0Rfvt5bi+Nt0Gz1r0yVv5/Fex5pYKbMSWf1QKCHu/YNVAtDUR+LzORL
	gD5IwvkErQgHveyV2liwdvE3Vcv3v94=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YW9tmzlo;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778085254; a=rsa-sha256;
	cv=none;
	b=xgE+DCAF+TIs1vRRlVOKkT/GpZCfSPKhs4HKbVh9JWjUAHtNww8Jhlv2RExYTxqVXvdfGW
	OhlPvtugrQc4CyJ+0D6gjoaI/VAxeWwN3RUCoXmxAjWbcMB2GaGYJg2pb9uRv8qlSjtayF
	0e5MYCd259WPMYQSW0pnXWgvwqguxnA=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7bd5c582c47so60194027b3.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 09:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778085253; x=1778690053; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OSINYmJ3vJWPFl8vzHtHzlEblnGus+VWg6G+vnhXyiw=;
        b=YW9tmzlorp4Qp7kmRAk0v+eGf/KIPUgWVmLYweNrwfiT6IrhaEV7ESJWSWIWNY2FYa
         1wN0TNc8BMLqLMYfzD3WcPEFQtjkXXxM2MNHXFGgJFG4RqzLohKuzYjzyfspolqHnFz4
         4Fj9Xr7E6r1CxgThOjzN+xRfrPdLXSusLxAYGlOJSWsV3CrTfyzAIM5+zkBNx2HL4q3O
         ktMp7DVjQyyL7ugUEJYn1JSw6ukebL/KJiATaPT26+MXnaIJesl4+yUGLbqL4NtdI8Iv
         OAK+LMpbJsJ3uSsH1Xzlx2UpOOVlstpwwsxjwv+1B3p+6zdsVA00KYmtC3gZ76Go2x5/
         lnYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778085253; x=1778690053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSINYmJ3vJWPFl8vzHtHzlEblnGus+VWg6G+vnhXyiw=;
        b=OMoQWSjNUPpFkiRjWHhIauGt2jSSmyJ6j+O0D4qUtKUxu+ZqbA7n/7//3qAqf9uBf3
         GccX1Ya7T0sFwGgwrzQjsQcW/XFfssHX7qNpTaN4FkVG06deJenANYdKYOX/ojsxPT4A
         8+ao4yetgqx1TwvSEwWNdF7NkDC5ywRd9qJSZZPn3DLZSfgYu1eyv1EByITLqD/ozpzC
         GnDtrTn7vZYRGbY3I+r8pG4I6leSvxbAVw+b1tgXmmFccknMRbHd7GnUa1m0Jg2lJ0lU
         nbQieklnqhEJAukrCjcNC0HKZ+uoCkRzloqVHc+7U2AA6tIwSTQCm/SdoIJsXLJo7rBk
         Jr6A==
X-Forwarded-Encrypted: i=1; AFNElJ8uUYyW2ZwBjzXXs3ddQtalP3OG+08BzIJJvm1qSpBr67roUBgCb44CS+StME5DR1y7wWwLwRIFcw==@kvack.org
X-Gm-Message-State: AOJu0Yw8ARMA3BMukD71cddef3QSSgnAkKVrSdIx834df7dKf1fxpwLz
	FV4wg12T/DnG9nh9GShWYpTvWJtp0WWTBHClAbqOuC93qAik7DwhWGbIY+RGg1tddA8=
X-Gm-Gg: AeBDievIm4imM//t6x/YqQ2RCkWXV/SKUHmWTzToicPBAfVOEPa9pbWmBF0uzZxeRB4
	APFMivUIbzgQOdpa1XUgU7FiExzXtw4s/LfC2SgV5EQeZ+ZwC507XWnhjtMPblW0vUTY3xgybR8
	zg2nAWOscx2jMnxOcZmROlgN1Z++HqMeC43HLzP9+m699a7KxImnun66Eofk6Fw3N8S/y6XZH46
	ev/RtWj7WfPw5d+Q64n36KRHn4XjsF0jruw92C9XshzSy5KfnvBfVu3VF/J8m4xA04X23ff5TxK
	qbmqKqlOL5jWL55tQi5R2sDocBlYPEZz30C5XojfoT9pK74DXAX5FV3j+7rABPs7mF1l4UnOnxF
	D2Q5h0o6Bj4O5l73LCmZHJB+fn1zgNGhukZM/mn+/zp08IOU6JL/Hx8pxV/sg0GacQmSiYp1qf8
	r+X5y0YKWp0uK9IsA+NtRfLx0TiHdAL2q1c50HvDlPLZOK/k6Nfuy+7AGuAblS1SJ/fDF3tnMfQ
	GgqpioehQoAaVbCbuchwCOWl6kO/fJ/2mi+6ozR
X-Received: by 2002:a05:690c:8e07:b0:7bd:d145:3af9 with SMTP id 00721157ae682-7bdf5f265b3mr41479677b3.47.1778085252743;
        Wed, 06 May 2026 09:34:12 -0700 (PDT)
Received: from google.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6654cc7csm83105227b3.13.2026.05.06.09.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 09:34:12 -0700 (PDT)
Date: Wed, 6 May 2026 12:34:10 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Cris Jacob Maamor <crisjacobmaamor@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] liveupdate: validate restored LUO metadata
Message-ID: <aftsRFhwjE0mq7pb@google.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501173053.73116-1-crisjacobmaamor@gmail.com>
 <afT_xHDuFwAUSR0X@plex>
 <2vxzse84zzag.fsf@kernel.org>
 <aftVd5RnpnAi2jdc@google.com>
 <2vxzfr44zf94.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzfr44zf94.fsf@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED9AD1C000A
X-Rspam-User: 
X-Stat-Signature: irjrsdf9zyqf8m5y54zmrugqwn9fu89k
X-HE-Tag: 1778085253-326480
X-HE-Meta: U2FsdGVkX1+dzvH+ZPHkhDEKLEFI93Elpa1GJhk2dUENxeCogFynDrFizPqVdYLXeOHqPlVEJF+m+EFybwm71doQ5IhiDJE6OgHtfiCQeSXYCHc+xzxRCCZxl9ws6QB4HtKmzkCZ9WF+ErleSglTFrz6HomkSYHnZjdp1TQ7lZiy8G6VlmpuyAC3/A0pDlfyL2V4UlYNGYy3ybVIC31hYis+td5bR73w5nk2HXlumGtkycxs3CNLVWeQc/XgzAm8VepTerbOM3KsFgcDbhUyTp4udJqTf52O/eHfzl7SBOVSGuwTwokmwAg7DaGY9wjLLcG0KE4H2waaGsCx1COsxYEP3A2gBR2zA4hoXe+OeOtduisKhJOVDPyTYER3/8QwfHx+DYISS/f5Bbvoj5Ja6kS9mxJ0acQChDzWLsXBAcBenqx18RKi8wBNKv4TgZdvahaxFBNYcj6xQeSg14+AuKPFrBIolP25iR5fgkw0MJsPMsvcQrVGkaU8S1R/FxVJBYNcqc5NdnNMkF6s5M+3hh0XnPVdKGZvSPoaJ5iPQamDdAkPDcTMZSCVA+p2WvHWQr3i5ts+BpxELtuZvrlwDrWAhpzBM5LFMOg3ImVq64J/XMTnMS74MhYqOozXvlIpTe4btL9EJexOcTa9Di46R7FL5nq9F8Dya3y9lAMRVBzghsf1oPB7yCK4HAcdaLVmH5yfldbthG+T4WPT1JzPPhl0f/ZyZbh6IDH02fGhk3Fznc7LejCGbtt3h5evSNOdHLrsSxWyP/xQNIaEHbIkEm8LJDr9w4Xfx9rXnE695d9yl8vuwSK4sEC2X0FODZnhdQlwh5zFgRRIwnpA3394uP18WupVjURpssTCKqMYQy6wsLqZ0FIQ/dO7tXaDjSI7WqIAVGZVHNQX3MsbnKpxxHvvXO3q3JW8EbbCCOL2L4zFWzQWq2k97WCtrk8iH50sKB/J5tEwnO8VWZwUaNx
 vCe2X/X8
 f6pKn+YRvXZJkUBndEXt4e2qV0ZQS0U3Fo7X1Jsp6NzqmvM+owfF7aOmqgm/mRJ1q19xOgqhPcpgHDNEi8i+oxf/r9ZbNMF9ikoqcXWcIDsP5IJfRY34SAmbeKIHFgF7j52P5tBcihbUC8SpJebkyVcgHVXwR4SUZ4Gi9dOJ363jZghrG0XbD3GDBQRzvfWm94CIZJpcpWzx3zrmx6tgxTk1GZWmpFjRiilYbnF2OYGh+Z2z9E4NalFulrldFvNcSGXd4IVis0B1gdo/igM6ryzsHSRSphePJtdJQGr8YGPodtjXwswk8VDEUdXyTHKps+CmnEtqGRP4nMfnyeltyg43NQ1Exi4ZtJcsd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-06 18:15, Pratyush Yadav wrote:
> On Wed, May 06 2026, Pasha Tatashin wrote:
> 
> > On 05-06 11:02, Pratyush Yadav wrote:
> >> Hi Pasha,
> >> 
> >> On Fri, May 01 2026, Pasha Tatashin wrote:
> >> 
> >> > On 05-02 01:30, Cris Jacob Maamor wrote:
> >> >> LUO restores metadata from KHO/FDT during liveupdate. The restored
> >> >> metadata contains physical addresses and count fields used to access and
> >> >> walk preserved session, file set, and FLB arrays.
> >> >> 
> >> >> This series adds a non-consuming KHO preserved-range check and uses it
> >> >> before phys_to_virt() on restored metadata addresses. It also rejects
> >> >> restored counts above LUO_SESSION_MAX, LUO_FILE_MAX, and LUO_FLB_MAX
> >> >> before traversal.
> >> >> 
> >> >> As far as I can tell, this is root/admin-only; I do not have evidence
> >> >> that a normal unprivileged user can trigger it directly.
> >> >> 
> >> >> Changes since v1:
> >> >> - Dropped RFC marking.
> >> >> - Added changelog text to each patch.
> >> >> - No code changes.
> >> >> 
> >> >> Cris Jacob Maamor (5):
> >> >>   kexec: handover: add helper to check preserved page ranges
> >> >>   liveupdate: validate LUO FDT physical address before mapping
> >> >>   liveupdate: validate restored LUO session metadata
> >> >>   liveupdate: validate restored LUO file set metadata
> >> >>   liveupdate: validate restored LUO FLB metadata
> >> >
> >> > I have replied separately in the security report to clarify that this is 
> >> > not a bug. The behavior follows the ABI specification exactly: we use 
> >> > the PA addresses and ranges provided by the KHO FDT tree.
> >> >
> >> > NAK
> >> 
> >> I really do think we should do a restore-only variant for the
> >> kho_alloc_preserve() family of allocators and use it everywhere. It
> >
> > That is unrelated to the provided patch series. The author of this 
> > series reported this as a security issue to the Linux security ML, and 
> > submitted this series at their request.
> 
> Oh yes, sure. I am not arguing for taking this series. I just figured
> this would be a good point to have this discussion.
> 
> >
> > This is not a security issue, and in fact, it is not an issue at all. A 
> > restore-only variant can be added, but I do not see a reason for LUO to 
> > use it.
> >
> >> would prevent problems in the future. Not because the previous kernel is
> >> malicious, but because we might have bugs and the KHO page magic sanity
> >> check acts as a defense in depth.
> >> 
> >> For example, I am currently looking at a LUO bug where LUO does not
> >> track if a session is outgoing or incoming. So you can do a retrieve()
> >> or finish() on an outgoing session. A lot of nastiness is saved because
> >> of the page magic check. Things like kho_restore_vmalloc() or
> >> kho_restore_folio() fail early and loudly.
> >
> > I am not sure what bug you are looking at (please share the details!), 
> 
> I was looking at LUO code and realized that we do not separate outgoing
> and incoming sessions when dealing with preserve/retrieve/finish ioctls.
> So you can create a session, preserve a FD, and then immediately call
> finish or retrieve without doing a kexec. Of course, LUO file handlers
> aren't able to cope with it.

Oh, this makes sense, please add a self-test for that as well :-)

> 
> So for example, you can preserve a memfd and then immediately call
> finish. This will call memfd_luo_finish(), where it will try to
> kho_restore_vmalloc(). That fails with a bit WARN splat. And then later
> it calls kho_restore_free() which also fails in a similar fashion.
> 
> You can do the same thing with retrieve(), but that also fails early and
> loudly and does not cause any problems.
> 
> I am working on a fix for it. Should have something out shortly.
> 
> > but the fix absolutely should be to use outgoing/incoming sessions 
> > properly, and if we mixed them up somewhere, THAT should be fixed. Using 
> > KHO restore is not going to help much; however, I agree it can add 
> > some extra scrutiny (i.e., similar to an ASSERT), but it is not really 
> > something that would help improve correctness in any meaningful way. The 
> > correctness should lie in the LUO logic using incoming as incoming, and 
> > outgoing as outgoing.
> 
> I am not arguing that we shouldn't fix the logic bugs. Of course we
> should.
> 
> My point is that this sanity check acts as another layer of defence.
> Bugs happen, but the earlier we catch them the better and this sanity
> check helps us do exactly that.
> 
> For example, if we did not have these sanity checks, the loud errors I
> described above would be replaced by silent use-after-free, double-free,
> struct page corruption, or other problems.
> 
> So I would like to understand why you _don't_ want to have this line of
> defence. What's the problem? If you are worried about performance, we
> can go and measure it. If the overhead is too high this can be behind a
> debug config.

Most likely, there is no performance cost, because when we free 
preserved memory, we still need to do a KHO restore. The only difference 
is that it may occur after a blackout not during blackout. Anyway, if 
you would like to add this sanity check, please send it out, and we can 
review and discuss how it looks.

> 
> >
> >> 
> >> If we want to squeeze out more performance later down the line we can
> >> move it behind a debug config, but having this usage pattern of always
> >> restoring before using is going to be a lot more sane than just using
> >> physical addresses willy nilly.
> >> 
> >> The approach this series takes with kho_is_preserved() is the wrong
> >> design. But a kho_restore() or something similar (maybe we can find a
> >> better name?) is really where we should be going.
> >> 
> >> -- 
> >> Regards,
> >> Pratyush Yadav
> 
> -- 
> Regards,
> Pratyush Yadav

