Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098301061B37
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 12:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495906B0092; Tue, 31 Mar 2026 08:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4463E6B0095; Tue, 31 Mar 2026 08:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335386B0096; Tue, 31 Mar 2026 08:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 236726B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:08:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9EA316011C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:08:14 +0000 (UTC)
X-FDA: 84606235308.13.D23B8B9
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C98610000C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:08:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SmhGWX1l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774958892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWnbOpzONRGJiLmoV0vKu9xzFQRSedr0o6MAdYTsM/w=;
	b=A+ijViVho/E+DQ1VZaNGEyovLrqAcFysPTw3m3rZgrArPiWS6lIE9n3WxioyPnCbT+fiSn
	P3ljHk1w3L26MpEm5ArxwmYbs9Lc8aJWXiKXT66tyeU9bvKwgQ689O0dvxZqT4MUMMUmi+
	9LddSjNTcNsIkKeJztl+abJRan/mJIA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774958892; a=rsa-sha256;
	cv=pass;
	b=2f8tOFBsf7Cj89FyHiT5POWQs3JMPEbFMx/4nrXD/6/xVzK0ZwlS6VxE6uB14D/SLKZKu/
	5sJO6kDwmn81DkzRTMUqdgGSyIIHzn+gqenYogrHXl3LJXnStiNVcHvgdoG03q1r0zhKn3
	BIEqKdmrooGmTrHFD/W2HvwTLsX2a4A=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SmhGWX1l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-463f00cda04so3159976b6e.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:08:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774958891; cv=none;
        d=google.com; s=arc-20240605;
        b=ieMgrD+L4NAgMsAOStXTu12kT5tfDyc7zt7lkFLpy+R3HmFWUcFzSI94UM8GTj0AJe
         O1dl+BaEwOvjMnFy14hTtoEqQ4mAf3PG+QAecb697KbpjZ2PXQh8UbXtfXKZO+61DJo7
         T3IgB4O1/nR3ADFzjBp8uahN1N7pPAc+XhIHOKidUKX1nOvGV611Anq2L1VSODyAIsoB
         x2vqrNN2jxbgGEnNgLTG4c6hgFvyIgfXdFDmqKGQy/4NWt2FL/JkYQudURtX2Jmonm6x
         7x8rdiSZBwgQeHxH+KzpV7/sISgx70ZwpzOLCYXocSOWYgKrGxV3tYpj5EtbYzkJop9C
         fdhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LWnbOpzONRGJiLmoV0vKu9xzFQRSedr0o6MAdYTsM/w=;
        fh=XNANgjDpp4BDT3hOinkzYh6G4aKOZCmCAK7iI9sLM7I=;
        b=H0HKStTIxQN+Qfd8KElZoZKZ5BTsORaijRLHrqJDYyiTSO+SRRLJtCeU3nCdPSSMve
         jBjMD/kZ7fpuoCcye0s3ay0NRFrZrmpBmNqIc3NbPqvvVj35b7zfLfZD6fgfQ1BCb+mJ
         NLpH/8q5MT4ZVYRMDjRgOW1x1vDintfyFsNhdKW7E/3QV8Lm1y9kbVnObAV5c+VBHxbx
         ubkUgCeJQTWAABJyxN7iUSkFeOtkVNIjNd5S+W4L4aW+vRdVJ9tZyLlAgvVkBFHxAx2u
         5sWd7F5YwDMOOQgKEjhQXt0WHCkTXxDZgYtc812Thg8UjEcGDftwy7Mej89tZo0/AxWh
         TxoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774958891; x=1775563691; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWnbOpzONRGJiLmoV0vKu9xzFQRSedr0o6MAdYTsM/w=;
        b=SmhGWX1lQt4BMOQN4mTDyfy3yxjOKHN+WaCKTuqtBh/IcQy/sV9ogDDyD6WJZr0E57
         4EkmIHbFMu3ROFXz1/Bml9rVL+k2YeNFN8CPXj1deUK4Ise8nLyFQxbIjaX3UYdhEzTL
         fYZrAxn4SaCf0LTu1kwDJqi0IRCJ6MRqlWqfkvmkhXhlSmPFJiPXsX3IpNUpyaOYUrvf
         A46Jxd9lVhHrxsC+VDmVQdV4VVLXqYIHfRD1wemnhfnnMQANUSGv9/MpWPqWmdhvSTZB
         fxIxIECZdq9g9c28gKy3uHslIQmzfVWUKFkJQYXD9oQNk3kuHybdDDYb67B/MiiSW9f2
         xd3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774958891; x=1775563691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LWnbOpzONRGJiLmoV0vKu9xzFQRSedr0o6MAdYTsM/w=;
        b=byP14ozza3fJ74wXXby98dJGB8FUmJlQRA9H6DXQ8RETRIPOQ/GQ7VYk5KghWIUZa+
         lJ3QeIgi4Y/CBHJtFXPe8AW9F/P4jyfxm+GAFfw+TWkb8BnLLYrhXuizIq1YnNPTMTd+
         52Kg1fS+6PmMVuDMJYHtXWR3xhd/DExhMmazLvog7wWe4P5O3wdnzwrj1E8jYrXlxpYt
         64DLOYEMrtEIZRtjA0avpUBD+QnwkOF/B8eBIcvQ/xrqQrKVMKYT40UDw+m++K+pgelh
         zuiBVBpjIrRaruxZ4pkK//OdlPm3RRjm4KRirJpo1CiO6E37ZYdAGX9Bhe4e+r9TxLLK
         WdXA==
X-Forwarded-Encrypted: i=1; AJvYcCXplonWXezXOH0ExmEYZcnRiuALelyjYWWP0LYyqa3mRaMqs+4Ez9YcNCfuldx2hryxcO1VFJ1M6Q==@kvack.org
X-Gm-Message-State: AOJu0YwxS8IbHAgfeS1JzDUoCEN+s67CUmjz5GkUSR2FV/MWj1ErRzJ0
	1I5Hqmk2mSDJGFleopYOGj3TiHCOjD+HE/M80IUrpoxfGWE1qMmLlhb4/IkHwGVOZ2SgeijlaD5
	eWjM0+NVaGlGSaJ0pCPNehaX4+0rKMow=
X-Gm-Gg: ATEYQzzV2nyGLR5m5brHKrOy1ToEo2an7VHwmq0DnOSuxIcC4vqdg5c/eZ4eGN3fs4I
	7F0dfLbeUgozbpaYgvmSRBrnNi1I/t42fVVFD3EHBR9Y+fwrZeLGcZXCP5MjDm2ae8iMPuDiQdI
	XK/gxrcbXslRwgbJok3jVjW8DwzigBVWXOGfo0+asuzusw7QcsoufN/J7DD95HNuDVchTUE8llN
	dNoFHSJL/QYiKOxyOgCU+T1hSGWWWqO/s5i5AUIlD0lKxDPcE8PtO69sRqiq2V+xiYVctlHzSak
	KbnX0Y5Fl+eNu9JmiOUE5Opfn8iZ1+PFqVoSvA==
X-Received: by 2002:a05:6808:4807:b0:464:74e1:45a0 with SMTP id
 5614622812f47-46a8a591061mr5342269b6e.36.1774958891506; Tue, 31 Mar 2026
 05:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260330202909.136776-1-devnexen@gmail.com> <acu2cpUBS0ahkgkx@kernel.org>
In-Reply-To: <acu2cpUBS0ahkgkx@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Tue, 31 Mar 2026 13:07:58 +0100
X-Gm-Features: AQROBzDFhnb9rsW6pTaEnek38J3jJ280IK1AWIaU5LoK8H-mPw3Bt7Fpj5Pl2bw
Message-ID: <CA+XhMqxDqrWaOTCE2YKLu8FQPCiVkOxLBOQyVpZe2KxdHFKAoA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
To: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9C98610000C
X-Stat-Signature: uxonwr6ygnxqizn4d57hpdjdoz8jzsar
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774958892-358400
X-HE-Meta: U2FsdGVkX18qEz01a+z1RaXJNGDO0K5KmdiuDOS+nuEXQhMneZcRmVLHaOHS+8TUTS8lQ0cFbrQgAwVslLWhIJ1xwpfdOT6Q2wXqHOFVVLv87Qy2eUfyUyz3+7MOS8kGbVgGootdXiLLVxmTu1zOT/Sp5D5GGps3QnAYxl2P+CsuqtLJbD6scR8VqwK050A2yCJizUQKnVIvMv4vwWHB35fbD0DWgtcHv+zIjpkFY2leWdM8/MIgTFb2do40Y/rRQvJEtNGHqkWhPJz9YxL/0sGc0+aqT5y+LAGFKS7RXwg3jFv2AacqwvV4CC3L+gGq3CsPLM/0OLjx06xa37yKRy7ajl16XQBGmNnsjpFprfOZBdeDq54ioXaTkA5dTEAyy268GYYo2iK2xXBFd7LzVnCVadUdBpyPblNZrFVBVnlO4GysH9peXwKFqouJ2Bm1iWwDgMXAj3JspX0hEZmZx/B3dGdUxVrHFbOgSS84WOSMqjoPkTLCEqmyUOlPjdNmdz2XHnBSWSh2l0ZziZqTsSI6Jq6Zi86vNtvZ6eS29bmdRKAlFhsnNBoYKepuofcaJ+3mKK6Sbmuqm4u7bktssgJIOKWfqNWZhsR86ZEjn8htxTx4rhu4OlEC0AeNKOVbEqRxX3E/gIbrHCBygAp6he0UjoPF3OP8V5IhQIrYZlnMpIycQtRT5wsamMWV6erNasr9tUi8b/2HrRf/lVq9iWyjHV9uSnpRO7yo6I6CU56oZymiQrtRMdO97T5LDQnZwmKi2Lx1D4xbIfF0g3vGkIqwh0H6Kgmt9tdvA+cK8cSPjRfWD6VyuMfOfwdpOH8GNdUUcbvk1/3ygBLM2unt/gBbkLEMRltOh8vI3b3s/vy8+L5110QsbMcNyMwziwbF0lDYRpK3+kku1kR70/o5CJSv85N/0QVaIG2ZRnGr1XFp7QBPHFHQtQ4WUTMcrPmrPt30lqmIrqu9pQRJ9Av
 oTNYr5eW
 ZQhgmPZwSjl7SXXRr/mY2u5wEqeqxmfLCW3/r6ctK/UEX0Tnt2HwlgUXEOz6xrAkcoxIaZUY3eJ+dF39hThGd6bAmEpRi9j232kFxIi3qNLk8Na9kmsp5jRwdq0pMThDXyMVltbfidigANAn4urMZzqymtk8Wj/D56P+txJGlIlhPCgGbNWqmxp38R2VMD2+2AWab8YnxQkIgsg00zE9ALIipJee360PC5C58uc19AJrYe3NnYdI+g12D7ErF/z9t9oScEwEVpzEW/dtx8knEa1+iE2x8TJXxFB7v6AYbiTXzIDxNS52avAPh7jd4sED7AM8gRsVRvMR03bHm4g30whmv1Jq5LCpn/rLO4nuO1BYP46nnx8E7mU4d6Ajau2d09yuAMzV+H/xToIiV0laL8uTKIAO84eP0UigthPDLNijOkrbGor3AOgG8wmWTReb4MSyP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

=E2=96=8E Is it possible at all that after all that dance vma pointer will
remain
  =E2=96=8E the same?

  Yes, VMA structs are slab-allocated so after munmap frees the old
VMA
  and mmap allocates a new one, SLUB can hand back the same address.
The
  pointer matches but it's a different VMA =E2=80=94 which is exactly why t=
he
  snapshot is needed.

  =E2=96=8E This isn't a bug, but struct vm_area_struct uses vm_flags, not
flags.
  =E2=96=8E Will this cause a compilation error?

  This is a false positive from Sashiko. vm_area_struct has a union at
  include/linux/mm_types.h:956-960:

  union {
      const vm_flags_t vm_flags;
      vma_flags_t flags;
  };
  Peter explicitly asked to use vma_flags_t / vma->flags since
vm_flags_t
  is being deprecated (see vma_flags_to_legacy()).

  =E2=96=8E If the original VMA was file-backed (s->inode is non-NULL), but=
 is
  =E2=96=8E concurrently replaced by an anonymous VMA during the lock-dropp=
ed
  =E2=96=8E window, vma->vm_file will be NULL. Does accessing
  =E2=96=8E vma->vm_file->f_inode here cause a NULL pointer dereference?

  Good catch, this is a real bug. Will fix with a vm_file NULL guard.

  =E2=96=8E Filesystem eviction paths often acquire locks (like i_rwsem) th=
at
  =E2=96=8E invert with the mmap lock. Can this cause an AB-BA deadlock? Sh=
ould
  =E2=96=8E this take a reference to the struct file via get_file() and
release it
  =E2=96=8E with fput() instead, which defers destruction safely?

  Valid concern. I'll switch to get_file()/fput() which defers the
  destruction safely.

  =E2=96=8E Whatever we do verify the VMA this should not be EAGAIN. EINVAL=
 or
  =E2=96=8E ENOENT like mfill_get_vma() returns seem more appropriate.

  Agreed, will change to -EINVAL to match mfill_get_vma()'s validation
  failures.

  Will send a v2 with all three fixes later on.

Cheers !

