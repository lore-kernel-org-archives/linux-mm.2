Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A0DECDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7A06B00A6; Thu, 25 Jun 2026 10:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298716B00A9; Thu, 25 Jun 2026 10:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13ABD6B00AA; Thu, 25 Jun 2026 10:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6BEF6B00A6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:45:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6ADA38B436
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:45:07 +0000 (UTC)
X-FDA: 84918707454.25.8ABFABB
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5EAAE1C0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:45:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gb2nqAxL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782398705;
	b=48/pt67d5cpLrtIPO8/9CYjFF+s+ZfGWF9Se752DYJwiaItccGUlRMr01sXdTcQCN7+8PG
	LfJZuLWna3SnExs+7rfmd+BKortxlWzjnPJ20KFKZwabh30HUFBuqbyWMJ0T7HPm8M2hZg
	nlzUFryTTPEpaSR3wTagZ3YsaVAc+UQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782398705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QD7qKXZri8t/p+ksj5Hmr6AY1jQNXtkjjrL5kYM+QzM=;
	b=dKOwKPT3djYOIPtSp11pIjyLwg1sv0aU/EJA8mpDwQDq0LxFFdtJQkgIcapLCk4ClNPBFp
	QCIBar45fpNaDbsKfIwANlCMZ8Sa049EDfgiSmjlF5qW4Ghzx15uZJwUwl0ioEH63DUiwQ
	xn24BY79++rsz4C0Wfi8AjO9mihvFrA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gb2nqAxL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c0c5d170ad4so378649266b.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:45:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782398704; cv=none;
        d=google.com; s=arc-20260327;
        b=cFTdhKNN1hpTR0pwWGrR5ovLI9txOsWMCqUWYcHc+RcdvFIWwpi627UozxIO0SnRSV
         5yCQ3hUHQU0sp7jV+Yw2w7eWdJZIu12k6pR6Q+osq4nonLW3iuTqNVJi4PDg5MIBu3vp
         xFFiDE5Osh1bsccaXAKljyuL3nu39X49dX2U5D+y+pvHlRuEiAoa6t56ul/fAU1qJW62
         kmczQkAiTGbC/Q/M301Jr+myBtCE05Kp5gUl0Ccgs1WkaMMwhke/2lZU7rmehiu0BHSp
         siJGCfhRcqSJSQc97v60ZBOkLBen/CQjnNbduU+NkjKkkkoQyxKqliIULEZwIXXBNxcf
         ++Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QD7qKXZri8t/p+ksj5Hmr6AY1jQNXtkjjrL5kYM+QzM=;
        fh=0uQmkSDDpeyjzPr5eh/5fGBa08r5H2o43+Kut+lbPjo=;
        b=ad1B/o0XtrOkvAqN3ivft0xJ+Axl3FHKjfLboLUsZ+Xx1V0imNFiTfrrNBg0McYdxY
         v1BZiZZ+glnmqME0TGxg49FVfYJSDv45v8ildGamLoYCWQRhVnGK7DienwqsGhs5IjZT
         TUIr/xnEYggetI43v8VykG1hAKjh3/g5wTjtG2IVPBiJugMu+0pjhOIRALpzXxggl/n1
         ahDg/HnQ/J2gKN9C5IwBi+GX+P6hOCSLKowdauC1WprBdtuyoA2e0ml0GpJhB9Lj1TPw
         Q7IrEKAwQt6Ir0rwZmQoAXHg6TbBt1F3bFIUH5yBGLpa7Q8hd9v+R6PU3XeGSwHU+2bZ
         A8Nw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782398704; x=1783003504; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QD7qKXZri8t/p+ksj5Hmr6AY1jQNXtkjjrL5kYM+QzM=;
        b=Gb2nqAxLHdaH4gVVDMqrsar1hw936CyxlL7PiJAqu5ouHZ8KTjyW9xZ4zCOIG7R3I3
         KMbRXTrhleZtSUZrsT930TeWL0xs2XFM5rC/Q768gkT5SgzJ7ZWPPQPAMKmPnbqlj+t2
         Qf/xaKfJ8xMRp4eg9WqwinaO+u/UMYrC4LJGwv12/gOpqmybv2J0kUEi1ON6QT7kb9Jh
         8uxj+zoSzCz6nq/LVG4rVrupIRq++PYKVyuDxsYf3YRaHJlB8gbbLk0ShMuoqviaYW0q
         0RlJyvKuzj2eMDLl0vFAP5b7HS3s6evS+UB/bkKJhMPuAKljM0Nwf0LGO21ZJpQnSBvX
         ME0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782398704; x=1783003504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QD7qKXZri8t/p+ksj5Hmr6AY1jQNXtkjjrL5kYM+QzM=;
        b=kralwrBuRoYczKc6Y/eQJ4kyOL3JOUED74z+RMzwneQPWlooAO+/i/xgQxb+W1UgxE
         VaX4wnyFN8woi7OjYfN+I+IBIUixaHCfLmCBNUtVM4HKkSUjKot0zL5j80EkStCyPaS8
         o8geBntN38LWEBSi0+jpHVR7Us6PGDoIAehhHZZsZP9QyTt7Oo1YyXZH5c3zG2OY8/ll
         1l2SLtuAv18z0n5hocdySfvJJjqzRj2WLmK3YtG55S7x01ayyApw6Ku008yGQ73VeeH4
         x2cNq80lHms4o36fW45CXopLz8hhCX+iEAkfxNSyV0lsVXX8YbZu+ay3RcenmVbReh3g
         AbSQ==
X-Forwarded-Encrypted: i=1; AHgh+RpURvUSpgPRTdQTN3U5EiyG08gWzDXNqMMZ+NJWkWoiq1aUlt+ITvRkYzbODyF5FhDNW5ntWfI6Dw==@kvack.org
X-Gm-Message-State: AOJu0YzV5EF1tdqlZfzMPIqem6qoPsGxsqB4SIKjX4Q1HS6D0mpYrnqI
	ahtgywrB1CO55yw146cpkWTEjZbCph0TtrLULfMLKzxxwfAlhrWU/UblfU2ot4vHgF693ElgXMD
	UJQnsTxgSv8jk8hGHiCz+x2pf4wmqYX8=
X-Gm-Gg: AfdE7cneLMB0gZr2DWb6O8MGlTyomPWhsUaHwib9XNnYcTG4d9aOYj8ixXtXsiMWNAb
	me+NIdd/mA5A2qUsOAxsxJCNNHKIQqRwLr0AqJoHs56WJmpvluM3Fy4RmB5FBDUBQPRtLeWa+3N
	qVkKFFM2z9kt9C4I7YZaoIYm8BFa/I1jh5SErH5bQVssu0LwL7BV6aZQiNuR9aP5w7iotbi9kyS
	/pzxj2en0FyoAlrCHxYJFWdq2aSJ8uzbNdNp4tfXBithKI0ku4eXavgzLhmIYdnUEolkXLeJw/l
	C3VWWlx30l/0SLzj5QaJtSlyhLcyWQ==
X-Received: by 2002:a17:907:3e86:b0:c0e:e136:5dc9 with SMTP id
 a640c23a62f3a-c1205f2c8d0mr226469066b.37.1782398703578; Thu, 25 Jun 2026
 07:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260623125723.2503832-1-dev.jain@arm.com> <20260623125723.2503832-2-dev.jain@arm.com>
In-Reply-To: <20260623125723.2503832-2-dev.jain@arm.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 25 Jun 2026 22:44:26 +0800
X-Gm-Features: AVVi8CcEg4tpNCCqREmU7byLm02gNI5kQBx-At95xC_LwssMDT8tIDVuZmtloA8
Message-ID: <CAMgjq7AUMTK+Qu8-mpS_L4Zt=+RVJVCWvDehe4qM5-_8mbjUQQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, liam@infradead.org, 
	ljs@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5EAAE1C0002
X-Rspam-User: 
X-Stat-Signature: tqwx1edpgor5b9bt3fzohy3qdgtuprim
X-HE-Tag: 1782398705-313052
X-HE-Meta: U2FsdGVkX1+dTZE/cHNr21uVwIaG3kmBUCzRbH+sOJ5A9JQK6EY3RwVKJNpkA1IkYTQMQ+VNAyAdRBUY7NCjEzKwXSPdPjeTO0NO/bOrHU83HOGEAaeZGNgWhvNWv4Cx/NMU7qJ2WjITAaal3AgxSpM4hOIA7eY+7wTrHnXTqD9VMTeDrPoTaX0WrcM7oxJZte90FZwhvgvRKO3zwRe756+AZrAOCRZ0KkBgnLtHFNiMGJ9N0FZPhTVM4i9F/tUf/Ij5TgrNlqeiBzB3+pziaXxbJmhGng2/Y0qJZpNuqKsIbXuPM9xm8oD4Y8jJiWt7Wy84hynwhvXbu0qKFemVDF1R8djxh+gkrnttDI5WnWm6YS3YooJIA6bQr8NzyXqRzTHeVFQe4R3OiDVvxjlVzxIpra8yqScOxwGsctQfN1dnZtyWKIxaJlGk9lgQXEVAEfFgrnQIKp36+34kz05t6BGMVXNR0j/hk6hUtOwUM7mFb+B0innmgbK9wVoqWVhLp/8QbZKTO1g45dyjC4hVtHqwBh30wbUrhyZxU5lJiT439onVerWEcVdIMO+6lgaAc/y4UJ7RT+s+THS3xnkcKdLSZKJB8r5v6h0T0pl0zcsWmRNxfLO0Xw0LXknHIv2tpmZ1XJqJWXIlGWwn+YDezGqgmaI2/4FIWqDSKUGo01ZCBhuYYIzpfNkKvLtAeMaE4xCbv4zfOq7ecge/OwdnQ9UdusC4Tzmj4W1X6KVvU97APS7QgiyXecTRziJTfaYTQMBEmHbltLkIIVeGxodT6gnvGDtOggH3j469JF2Wo49c2WszR6MKbMHIhqvgH1Y6npluhAIsP2f5i5cIkcfcn2/ES/0UG9cTRMNYZG7nUB2bB/qnd0i0DDKFlidv6NfhgZ+0kS740dQ2xXen8bu1e9QKXhEAowUkeoNcKXeM84z8ZTa/QBLO1T0+RfIAzn+uu/YfupHl9WMs43hq9YK
 8+g5Z2Ql
 p4SrlMlZ6cranvKiqjFT+BixxYFhWrtV2vTa5G6rBf6bWirtvrSy/O/LNS96xNRSYTgUZX4o/cmWf5MfNxPxKguk6CcJmWEysZbeP3X1Zab6awix0nRqAyC0x1KfqD31Zd4wWs30bFIsRp6kezEdoa0LZHJUsnYVbNgsytc3RCHtZX4KfTxljys0t89ULfbCLPNyGFPnolK53+84kwlm03AKjgY0XD079D2rfPH6F0J4OXbJfPHuvCeGcjJMeQuxFD40SWRO/L2RJOWoWzPp1iiF2y8VvwsC9bOwTS1W/SyxmSswDTy+3FoI+ouozCsWnPPkImWNTdwMZktrP4P5919LJ9R5JyprQ9qGpzm+H90XapjcGqXsHYn3mTSA8LpipZnf7MmyjnRVJxZ73fShbqIZ/nxb8j8+56pplhn/4x/a3c6YCpsu3eKgSQ4cSdEKTgTLOdshO6FvJvTMxIGki1xK1xr0DdC+5ZPZAtz6e83HkqqN9Ls6LALfrei+aoRGq5nSjF62i7E6KSTx/JMq6OjFlqo/Dp/XGw+GNrUxLP1su/Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 9:02=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/swap.h     |  4 ++--
>  mm/swapfile.c | 16 ++++++++--------
>  2 files changed, 10 insertions(+), 10 deletions(-)

Reviewed-by: Kairui Song <kasong@tencent.com>

