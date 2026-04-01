Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA9A10FCACC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FA86B0088; Wed,  1 Apr 2026 16:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF0A6B0089; Wed,  1 Apr 2026 16:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0AE6B008A; Wed,  1 Apr 2026 16:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 955386B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:05:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C9381601E7
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:05:47 +0000 (UTC)
X-FDA: 84611067534.23.BFAADD6
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 359AF180007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:05:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="en9/rYeQ";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775073945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQorzreAA2R4OJHpB/2k5Ejfe7f/juBu0lAuIW52RoI=;
	b=H/2HAFJJgHYzAgyjvbg1Htnt005Xluw+3MjIHYDlIREC8CDpJ0seUz6Q+TyGCHYRLYL/wI
	vIw27MRbQXwo8w6VAo3QUJM4/bZrhMVVOMZTJn9xk1vluQv2uw/KRV4xrcZROFHKLvkush
	zH4EUi4J9canKstF6BIKxAuJlMh7QBk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775073945; a=rsa-sha256;
	cv=pass;
	b=8Hkf9wHlh3yWnnJDSQKgh+f2rq4mgNYqzsjNBsHR5YaGp5anyOHVpuOueyUGhMztqdbw7O
	vYzaPLwtv/jbyehM3CGk13vf3TIFbpFB301hIk2ROa0WWpS5UHZKibBw/GPdiXiu8hr5jA
	VArNCk3GF8a9urT1bVWxBMq9xmiy1Ek=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="en9/rYeQ";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-463a0e14abfso88469b6e.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 13:05:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775073944; cv=none;
        d=google.com; s=arc-20240605;
        b=jwY6TFRjLnOj7PPMFPlo4KyWwWtKKgpYooGEqd8Td7gYTvrwsVbK5Tb2/jJr7a24uE
         gR3RJWalGgNxJpjSJpe68s+G/sOnd/lNPKDRnc3FeFw6QyN/Gj+Q9EVtrKR7YeORc65Z
         vpBXCqExh5TGDNLpTDQSbs9wQqtYI6O1QIjga6MoTsNhoknqS7MALAQG/dbh6T+F5ShX
         rIgyc6HUmZJF/sCRZXcqc8m+3qKOfHzwpuFTKeePiiaVjEZ32DdsAakJtuJTywOVzNpH
         QtOc91jyrs5Tqkgb8mNnAE6MIHRZWQxDiiyahohgaElUZdc/ENnFJOjOsi0r2ItvxPA3
         1DhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HQorzreAA2R4OJHpB/2k5Ejfe7f/juBu0lAuIW52RoI=;
        fh=eBlTHkn6fVickXEqYMONeDwRYWeMmAFVsCHmrf1RBWE=;
        b=RODoxz9XoofmhqpNZWIoQsTHNR5WpkZMHGc7xGEFyy2wGMKFSpieyTM+aDa+aXpkss
         uTpe90B384rLjoqlHXEWuFilSZVUigRHZjoGI4Hl3h0xzMYetjX5POf2auodBipXiS65
         cZTjyS3btWn//Jb2sg1dxVPYE9WjmzMp2ZJTkJ+MIMn+mgM0Sy+i08D8YVYY1fLdiLxv
         jkdUmhs3bj4Hzk28negK84Tru2kVuoOxr2TKmk656WUZ45F00wY1OMhul7lCaHoMt/wl
         5CK3NXxR6TIPGE/+pyJmfYhDvVTNaemkNaXm2D6Gedi0h53EpSbgnhgg0RC/K3kTxI4n
         f93g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775073944; x=1775678744; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HQorzreAA2R4OJHpB/2k5Ejfe7f/juBu0lAuIW52RoI=;
        b=en9/rYeQFu84cQCe65NLyA3nNrC49ETcQGCUhSRt7Z8HM+QH1vfOLq4on5tRdcTrC9
         Z4RL0xBoeVjxf2uIw/782yNnkoqE/tnvWBmE+P4DXoFUtgkqEVLnWtimq3S4KUZoUN3p
         apA/mK0tBjCrBG+UWZIc3mDJr7Y7DcIyA4zhY1345ZVMIyB0QkRWjbJvrv9f9/yFVV0x
         iWO1gj11S6lWH32jbv1C4GRf8gSYql9bjVpXY/l3x1QzagTKOfLkD9I+k5AaoMLS2KRH
         CHuhYJDtaq5tSpQDIYdZI6V4ZIWPXxQL/bDoRp48aMOa7+FGN10/aIKjIrP6lfWuNRnK
         pX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775073944; x=1775678744;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQorzreAA2R4OJHpB/2k5Ejfe7f/juBu0lAuIW52RoI=;
        b=fKZoJhr2QQEKVuSO6faA6K07zbZyhNv4+eepldq5rpiz8kTgBBxdjNHedEBbLiHXlu
         LP1RDMM+VrrW3053+uRwY9T8+eTUJ8LOO4XrO5JgEk68pHsVeL9g3MYbc0FaNPiywdKg
         nc6dVTbY3gflCTqX/K6lcGRWbXPehJIqDXBCvCWLe8Slof14yVaaAFl9p5lkfRcJYFbb
         Dn/b73hJmtwx6kLPSbJxtxeZuK482FZIiqM/aK5yv8GMnpRsKV+/bjTbvrg/K8MMcIIk
         kXl5+KONzOxaeXMSMEqmbNWY/ysDOrUNX5Ik7oNCYut29PWep+6Aa/Qm3XaA1qAepGHL
         RDXg==
X-Forwarded-Encrypted: i=1; AJvYcCV2EM7ioVHS0SAEHD4yomNj9XtgnCd3Qr1jARzLvVwJH3FNFhz78se9PGTL7Psc1iOx/D7DaVEMdw==@kvack.org
X-Gm-Message-State: AOJu0Yw+DIRGkq1wa7mLwkkwSBSLJfvVj5VSKYddJuXq0KHLHpyOE3No
	8eTjXsRr/La0gbCKtLD/Wm1MqpH0s47BsT1HNBPgTJfdruLJmZaRRLupkDcHb/7OnYCGYE2hZ9i
	8tUbbra/1vhvWSNUADwzwWcnauXPP0Hg=
X-Gm-Gg: ATEYQzyKp3LZ9/qDTJ87dIFmOqXpOIWgc1wkELYMG0kqX4RnFaRpdLJ/pSarwzkhxzh
	sZBnUDr0CeRa9QmzuFAHDXRuKsKtobrgIiUaeF8ri0jrt9x8cfwu/hZg2tQXKu7K8Ub7aRIvQKa
	86M02FxI5Q6hnb0EZs1p8r5B/tkEOFM4vgUw3SKbXPeR4Q0YfruJBJKeydgOuXtkWWPeKZQdCkR
	cOaXfzGvdypJK7HAZuYM89MZHzzC4yEeLztpW4+JKAs3hwzhGZLZMKTQt7OypiyH/3oviNQ+vX7
	kIjRrTwgTKMv2kX3+nVDk1h7wlhepZvUKRm+pg==
X-Received: by 2002:a05:6808:1521:b0:469:f699:af80 with SMTP id
 5614622812f47-46d8a88c34fmr606090b6e.55.1775073943972; Wed, 01 Apr 2026
 13:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260331134158.622084-1-devnexen@gmail.com> <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org> <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac04ZeFdz7yvByRp@x1.local> <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
 <ac1wW6LHzzkXBeSl@x1.local>
In-Reply-To: <ac1wW6LHzzkXBeSl@x1.local>
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 1 Apr 2026 21:05:31 +0100
X-Gm-Features: AQROBzDepiA8nWeW45-9o8fU5OhH57cwCWdR5XQtZW4sMyLftuPZNGBCSivb5fs
Message-ID: <CA+XhMqwW-mXGuFgA4i+0JKW551CS9h6XczKY8P==DLwfV954TA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
To: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 359AF180007
X-Stat-Signature: 343omm7poxgmz3rm5nif4rixbs1sk4ek
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775073944-799265
X-HE-Meta: U2FsdGVkX1+JQDmmmv5xH1jyhr+obZwmGVahLU/sIlTbDdYr5BDK9JVDAjPoB5hFqJo3CBuGUIdwdzVsJrIWsuga2WJEC7GzCzpST5jT5rNoiCuqfcu368SyZQodDv0FwT62e+EURK7JMVP1ZgAiN/jk1E6OwLSlgR/P9JKxtQ4F/3vnCKucxMO6KHEjiyVS69l3CJ3lyn5ZTC/bv5F1XeVQDYEtTE2RO+vuIHCFgfKHIWFNVZ4XCsDa3UxXEfrr9aJk93M5Tri4kVuxShxmiu6jc3iyFBnbXNB5Aiz07z35grohbLWB8HiUs2gg/G8xRTAUWudao7j0vWiNN3IhXRTtU5eIH4sIn0xhTE4w9hqFpRCZFsgDnNCFLC2zqGLjWXG7CdZTit8rFXSAhnC+YtHR5BjSy5snoCxHPNRYo6nK+wAbzk6MRdGW9XWwF4EIh77C7ZG0fJEbpx364CpjverUet+JfscOsxqvBBu/YJqWiQpYwDnZ/KoR+PM9s9z3nQevKsFqdp6VnLsO/L0BQvJu47u6NT168ooAhzVSlxM458B1viIVEIyjHOnL+homgpgBJ8bI17nUoqbzYmyt2C5MIr0Wep3OnnBSEVICpPhXyyT5tLJPpTH+mf9gBpJ5nwiwLGDWJYigq4NO4Hk0xlVntptXRv8rQZUCxdnCEAdCulBMVMH5wtb5Y1j/hNIaxGrGBHbtkGYav7KET2Y9S74aLTMjS+hCgLPWd8S5jZGlS8Qel9AsebVXOgQ7Usy4lW+5uEkwVm67RsjP94aiwKXfywxP5Ouj7ZyljWFGu7IXD5UBRLkkCy7Z7WSsMIGZxXbKJdGifHCSCmRYVAvGKTZKs2ayDVy4Qcv3eEut4YqcwlMcwNYAPM8zHgVXYLCl2a+BviCytFhlMpRrjFR0l3yXaFI5RTCHKLLTvmVVL8XIwsrckOKz/hORxNGVSxN7gNxnr0mvrqB0ou2QUmg
 nWEXvUtU
 WXm3hNbUGHUWISLSDJtgGghn2saBzjGhX1PdpZoXYdf8UeSWLTpOj0O2XHcm69LqljREbH7bdWuLGf87bLiAgaHr7VCK66+euN5oyiT4PWApZIl2WaoahmMBAIQD7kT6XtF6Hgs1owDQ0+asGfWb04grhg4QMZnxjWXUIZw2K7L4acFbmVK5k5VQhPKZ4WeyEtG4ihCwTXREuywhiJkQumrSrtq4AQR1nFfhD7EtVcNreFQvvj7QU0QwHkdqM8PiY9GyVtEo2i5EJeKFEld3BumAgqDyMBi6tjRItqh9JSYCWcFY6uykhsNS35DorCYUGKyS9XaQghgD0TywmKvs9m4174CtWDiTacA5N6ObiqGgTKO7KDFjBR6IAnMSJ3yyqwhV2msFh4Z3zZZvunbUx19PXDzNt/tL1pR8CPHydXfrlJfffxKq46Xc6mTj+nZsT/ILq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 01, 2026 at 08:22:00PM +0300, Peter Xu wrote:
  > When caching the offset, we should likely use linear_page_index() with the
  > address provided rather than caching vma->vm_pgoff directly, then
it'll
  > avoid same vm_pgoff while VMA mapping shifted like this:
  >
  >   VMA1:  vm_pgoff=0x10000, vm_start=0x10000
  >   VMA2:  vm_pgoff=0x10000, vm_start=0xf000

  Makes sense. linear_page_index() folds in vm_start so it catches the
  shifted mapping case where raw vm_pgoff alone wouldn't. I'll snapshot
  the computed pgoff instead.

  > The other thing is I just noticed the err code was changed to -EINVAL for
  > snapshot changed cases, sorry I didn't follow previously as closely on the
  > discussion.  I think it should be -EAGAIN.  It's because the userapp can't
  > resolve -EINVAL failures and app will crash.  In a VMA change use
case, we
  > should return -EAGAIN to imply the app to retry, rather than crashing.

  Right, -EAGAIN is the correct choice here. The VMA changed underneath
  us, but that's a transient condition the app can recover from by
  retrying. Will fix.

  So v5 will snapshot: vm_file (with get_file/fput), vm_flags, and
  linear_page_index(vma, dst_addr). Return -EAGAIN if any changed.

  Thanks for the detailed review

