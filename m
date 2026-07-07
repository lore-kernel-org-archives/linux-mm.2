Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDA4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F656B009D; Tue,  7 Jul 2026 17:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E436B009E; Tue,  7 Jul 2026 17:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B642A6B009F; Tue,  7 Jul 2026 17:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 897D46B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:23:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DE8B140579
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:23:18 +0000 (UTC)
X-FDA: 84963256476.19.59F1CED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65008180003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:23:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MhTUMPx8;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783459396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRzd80y0ws0+Q0zWRglAwGcH32IHJNJNmc8s9zz7a3k=;
	b=2LSAUWn0HMh/kNBfsRXGHjDOMGHXKb0EweTm8bXSh7k7n1T7S0pW9piUDSbB30qDsgOELU
	zCoWYdYmfOCBkGZgo8TSVyuqlC2GkI+zxmbP7FrvXiKLnNmwN75KmjhnHNxGnJr5f8VMM2
	ySxioquVwPURdp192Hsprkx4KgQJNW8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MhTUMPx8;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783459396;
	b=74+uO5iF9OL3Lt19v28OTLRRbS8mNKViSe7fQIf/2Y163B3vl0eaBxZyfrJHZcwDQpEM4d
	02MmgG+sSuOtcYHyXwTOahuKsIJqCGvCWIw6BQcZJkY4EpwXA27fkOZFkIk8wArcVISCSA
	BpddJEZhcNHPzeo85BCV/voCkz9yJOE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A63586001A;
	Tue,  7 Jul 2026 21:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0461F000E9;
	Tue,  7 Jul 2026 21:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783459395;
	bh=PRzd80y0ws0+Q0zWRglAwGcH32IHJNJNmc8s9zz7a3k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MhTUMPx8rbjt0YlsDVrtU/D0BdrszyaWBtjB0J9y7amzbmpLZ9RA+prqqCW4M55+C
	 tC9e/ljrVS/EKkjpW6vP2tI145aVESuwLaSzltE7+GDW0jcgikUDZrERFMm3MaWoTb
	 fDUjKIFy/Pge1Ck9mCMV9sMK/+0DP+C6avownUEU=
Date: Tue, 7 Jul 2026 14:23:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?546L57+K5ZiJ?= <wangyijia.yeah@bytedance.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-mm@kvack.org>, <muchun.song@linux.dev>, <shuah@kernel.org>
Subject: Re: [PATCH RESEND v3] selftests: mincore: fix the readahead check
 on large base page sizes
Message-Id: <20260707142314.a421d05c05da56260d1bf085@linux-foundation.org>
In-Reply-To: <20260707062505.3171552-1-wangyijia.yeah@bytedance.com>
References: <20260704203616.1ce10365e07c746f1e805cab@linux-foundation.org>
	<20260707062505.3171552-1-wangyijia.yeah@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yyx65tosn7ddcwpqpejq7gwbsyd74geq
X-Rspamd-Queue-Id: 65008180003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783459396-905940
X-HE-Meta: U2FsdGVkX18SN/v8cvKHGfVH5Pl4WMmV60g0ZV0TS+JvsXviIiTfV/6L8CuSSmanLjaZk/kCdH/21m22KiGTCeYgm0Z7IdOw6bydWa9qKUUKXIkQ38vHfvk/PULbHcSPsnzce3yzeVYECy+D34sAPogEDyjnbrC52YB6mhKYN6hU2BNHtgutHRMlGPk6WeXjsd/gsavXUdwcV9kYB0nT9j/zrxM0YoRhpjOa2TpdwNz9W/RfpuC4gIlMP5KVuOH920cBhyuIph6S11wO+snH6q/pj2CTS2kJ1Av4KVRRm6oml2zTxeJkvSeyL6QGJXgT/msdtw9O/yvEa9P5ledTvTnPh8p1QSmltvVqzfokB32Q8Ab0KuiAClxesaWz3sFPVMEkFZWC48qnznr3KtshenwkUBKEYCN8IArr5Q1YUbrQZIDTjO6dKFAqUfzKNlZPwciNiUnAIC2H7rA5z0ohR2SkEUy8EZbK6BBWSbkLwsWjVctKcoahxceS86XKD4FJEEt7IkJa5jvtO9g0vfaU1J9l6NsfIA/vO/eqmC0ZKVbX48MVG3y9Mosz9c3RWH6sH1J67xCddyU2ObRJaMNPRnTACGLPOjTZ32aHY5NIRyLMEEqFxzkL0L4P+FXvIrjEC/xex8qsBkbQBzz7hQwkoW7LRVvT5MarfElHPmZlGj5CZ1ea5lZq4p+LY/qQ6PlKppeH8Zx5N97NEuQsvDC7Zb8N/4CaDTPvEvjYd3wTHRd33xzy+u05yVfILmHPn9jZ2F7zCo6Xqt3grT8QqSMifpAOpl1U0daeDSwFJj9kEZrCPfNxTre0INxaGk58pfKbWThO/40wBfc7cgW2n2PDT/+dgrdAr8x2WA1/6M0xjXIlqE3t6weIZwG74pBURub9vPYv9rG4dSSdeomWwD8P1Lhoom2UF/1L+novaNzMKoMFcgBb5+/GJPPzo5yRUKD0U5jptPrN8JXmnu/movu
 JygbqIxm
 ZqYX5LbuFOP0xqYaTiCgCbYZDokW6XoXRkIhhS0mB2zNLV7wGIeHmy2UvIxZna14wmg3BbPFq2oQj/fGea94hV4y34nT/DBfP0PdgNAYGZtocMXqCRilEQSG6BBBvLdG4iQFx/VIPt1L1j1pBUdNgM7PJLUnolAFuPVpA3INMcoH/AhMPBGeh/crRuyt9FgL3LDrqKyq5XzRAvCfiqbY/3sKKq2cgJNzMh7PPHQnprMMfC/xmQntsF3ZN2wFIL4OuDCkpXAR3wnmppEVPSdTsume2865uduQZRS/iLFd6wNfxOK+BG/2NbSk86JQ+diKPBaD4uPes1VYGS71ww8DoEcvXQr3/kbPK8RTq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Jul 2026 14:25:05 +0800 王翊嘉 <wangyijia.yeah@bytedance.com> wrote:

> On Sat, Jul 04, 2026 at 08:36:16PM -0700, Andrew Morton wrote:
> > I'm not sure this is a good thing for us to be self-testing for.  It's
> > poking pretty deeply inside the internal implementations of
> > kernel-of-the-moment.
> >
> > Oh well, I guss if the test suddenly starts reporting errors, it might
> > be something we want to look into.
> >
> > Thanks.  AI review might have found a couple of things of interest:
> >       https://sashiko.dev/#/patchset/20260703125253.3016281-1-wangyijia.yeah@bytedance.com
> 
> Thanks for taking a look.
> 
> After thinking more about your concern, I agree that teaching this
> selftest how to compute the expected readahead window from sysfs
> read_ahead_kb is probably not the right direction. The failure is related
> to mmap read-around behaviour, but adding that policy knowledge to the
> test makes it depend even more on implementation details.
> 
> The actual failure I was trying to fix is narrower. The existing test
> already expects a neighbouring page to become resident after faulting the
> middle of the mapping, but it only scans after the faulted page. On the
> 64K-page arm64 system where I reproduced this, with the default 128K
> read_ahead_kb setting, the file-backed mmap fault on page 32 makes pages
> 31 and 32 resident. The original test scans from page 33 onwards, misses
> the resident neighbour at page 31, and reports ra_pages == 0.
> 
> I tested a smaller version which drops the readahead_window_pages()
> helper and the new skip logic, and only changes the existing check to
> scan both sides of the faulted page. On the same 64K-page system, the
> original test fails reliably, while that smaller change passes. So the
> sysfs/read_ahead_kb logic does not appear to be needed to fix the 64K
> failure.
> 
> I am thinking of sending a v4 in that direction: keep the existing
> EXPECT_GT(ra_pages, 0) check, but make it count resident neighbouring
> pages on both sides of the faulted page, without trying to compute the
> expected readahead window in the test.
> 
> The other possible direction is to remove the readahead assertion from
> check_file_mmap entirely, similar to the tmpfs case, and only verify that
> the faulted page itself becomes resident. That would avoid testing this
> implementation detail, but it would also drop the existing coverage.
> 
> Would you prefer one of these approaches?

The second approach sounds saner.  I'm not sure this test is overall
very useful, really.  But it's harmless as long as it isn't causing
these spurious issues!

