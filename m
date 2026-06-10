Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85B6CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 21:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8A66B008C; Wed, 10 Jun 2026 17:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69A46B0092; Wed, 10 Jun 2026 17:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FF86B0093; Wed, 10 Jun 2026 17:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2E996B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:12:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E7D01202DB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:12:23 +0000 (UTC)
X-FDA: 84865251366.23.940CF53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 608D2C0018
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:12:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U+mfkNLX;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781125941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmtOOZoa39cljsiuXiJJhknC3iyZnCTNqU8ztufU8ks=;
	b=07OaoZgeMP2nIGNAEs+5YwigGjag37gzL6JoKrthScMrVk9VZWok4ViAMmIzOPZp7pLH8y
	Md+E+rWWuPJsFQ0pXWqTJjopaGBdBZBLZrrxSbzqkInZHNVr7jJlvOHIoNfNSduIGyj9iC
	VbAW2PDfdC5RrbgXk026jcjmSfT0MCo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U+mfkNLX;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781125941;
	b=2qnV+xLScbN8VRFj2ERK4q8aqLBimm/WlYrgoF/jEd4mFJiA50TIAxhT0QnceguHUBAltL
	0KcKy3B5n3HSc/9wqG77+qGoh9C7Eyn9X9zcjROvag/tgHGJoqYjLu4/UGw8J56+g3/GHQ
	Piw8U4ThUyXy+gbP8zFC4GFKAvbi7zI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B32326020C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7A41F0089E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781125940;
	bh=WmtOOZoa39cljsiuXiJJhknC3iyZnCTNqU8ztufU8ks=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=U+mfkNLXUspW9aH9ETn55CcVq7WrA2+yedRZa3ktc+HsypOHZvn+ejFFvKB+75x0U
	 f3UoWcmSXNl5I9zF/gIdP5ljmwUZlI0BIlMpfXchxhLoI4VR6LXmbot7zOS2l2ZjR+
	 C2q0NPKtEbEsTAFJmaRsId1oBK10e0GFXNjrTHN0xsUkFIMvBzpoRA9kmRBtTxPvU/
	 JUKGwSqjDI/EY4BlceoUAyVzMAOG1tfW6ZBqyVMTAiLSXAVaJsHxpRsnUQQGCQhuGt
	 JxAVT2PHfGOsjm9NlX7cIk8cehR6/uqFk7QMnVsY7mO+wEdsX2wc3LtlqE67aKsOjV
	 6stuGZ1x1d3EA==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-91588056619so505805785a.2
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:12:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/pgvl7M5+Pdi58dbpLkoNccDvp/7GoOvfj4LLF7RcJJR4UGW1CuR4kM32ZqmkWGscY8wcN2Q+lcQ==@kvack.org
X-Gm-Message-State: AOJu0YyYVfOdMkW1MMMDisYBx60I163nk89XGn+j87yOagaZO4mKbr6O
	2X9sEiKZloY4nWiyb5V66XaQ83GpyU8PLF5QPijJ5QiChAtJhq5JFsgoP9F07d616QZYjiDCpcq
	r2/27KZK4kLCii+/tIA7v6gAnfHPE8Gk=
X-Received: by 2002:a05:620a:470e:b0:915:d322:c465 with SMTP id
 af79cd13be357-915d322c6d2mr2656769485a.6.1781125939515; Wed, 10 Jun 2026
 14:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781000840.git.ritesh.list@gmail.com> <68591daf0d679e5a0072d63751f187d14613e2b0.1781000840.git.ritesh.list@gmail.com>
 <CAKEwX=NCB6yrf4Dc0yU_CwZWi0Kk3tBup7yvP7EUz2k7_CR2RA@mail.gmail.com>
In-Reply-To: <CAKEwX=NCB6yrf4Dc0yU_CwZWi0Kk3tBup7yvP7EUz2k7_CR2RA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 11 Jun 2026 05:12:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zFi78j5hz4=B7-25y__zOi70pzsA4c+BN3weyJW+gpHQ@mail.gmail.com>
X-Gm-Features: AVVi8CdJOzMhytTtNw_cCB_84EbqZdsx2mxO9urY7WCpZCzlojMVKFUa_ya4iOk
Message-ID: <CAGsJ_4zFi78j5hz4=B7-25y__zOi70pzsA4c+BN3weyJW+gpHQ@mail.gmail.com>
Subject: Re: [RFC 1/4] include/linux/swap.h: Remove unused leftovers
To: Nhat Pham <nphamcs@gmail.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-mm@kvack.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 608D2C0018
X-Stat-Signature: 4kcmru9fjx5d811i4pf6z77gcxtkkhra
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781125941-345483
X-HE-Meta: U2FsdGVkX184L674BH+vw3fghqg9xkBCFstv2F0egMdA2QvUtZKgYgrWCIHs77fiI2WnCdCkeqyZE/7SHrnElOLBKhmbEC2sOsvfHn8tb4pzDjm+1I8DxhNmcohTE8XnB0G9IYMJEgwAv7aMg8Qfjh3iox5Y46LaDlkOxMR/HZ10nEsWRsLcklPv8HIWgJoDZ4uL+Nbuyb2VonCgynqiwJqMPV/67XWHlIOApmTbF1vGtwZKtSReEEroHDajqVqKzpg9jqiC0UI2N8sEHcUI71HEauZfXHdD0MOCQaAgQFOUkS1I0cmxK015bdlgqU2135Qln/fs3I2HZtidJUYtBSOUT0p0X0EUs/Xx0RnkGPqq/EZNSYREZ2rBkzBny3KRR1k1UAI9/HCm1XJMkgOZM3rH+VemfqojOcrCiWRE26lwnF09HMitrsDH794uvQ80EohMDWmo3/W1yRPLfnNh0OQOoMcu5hhll6Li2uwduMxSDBVbIZpLVcvsjEfLz16gZ3PTSU7gcdr80ILxlbk0+8Bnq3Uhj4AmWPxK81Lx3GmAS54dxJrBTtGYNkcGJJp0mTL8ScC/YrzD9LLrw/KOt7dCxRjwC0hymF+ItlpOz+GM8P35F5UB3cbU636k5rGuyzJNj67aiFLv2BwMGyH4ZuoQgz58jXFkSAVaCWmR+GGR/QE1j6b+PLqQ+x/ngwaH8ENg0lc+7T2OgpqjHQF2HHo+p/E+DFoU7nUoAMZca2+e0UslyO7GdhK6hXcikRCQxDJFkHprTD4XdASwzeWk0glRyFf8mYvWeDF51+aqs1DfQcgJmp6e24RWsZtwQ0To5QzvT6YqFdVzkqcAM95Q3r+PD9kSflttGoFFJ0DEuEXxG5J2EVb26qKmFXKQxQsqcwvupFdRrDfa//8SPvIRyyQtxS2+mpN8HqG73Og/Y6eQEPIc5qM/hpdUhrJgAwnr8i7RbK+kk1A9RQfXg+3
 I39bWEYD
 tRk3LXBw4Fv3FQhX0crc7F6eo8iZ21plXe+vR3KTamt/xFYQWy/ya3rLdieFRMa9bqDwYShHsIpjSvTp8h1kQg1G3e63XlxKb73ohvTmf0PlwUjij+fTJn3aKQULVANWtz4gVYZd3IQ+9zALCk4CnF3GfG+dwyArRJQGktUuMcoJG3eFiTLoRP8DaycYmxiBGy593IA2aXlaeS25EZVclIAmtC1fpAfpsYJ2M6zMt0eT2KOBN0vhDL+iyDKbg8O4ruqWNOdkpVW0/VLGJDmjtuWME9CYAUglUsYMUDzpyN8GzeJowr+UOjbfj88Wx9kt6qvSP9dYNDTtxJvPfdULnPj8X6w0zKrLMpAFlTRgn4m/0v2kNb3VocteOkW+Qr+ADC5+0eFdpSa46TdQfo52Wg0uc2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 12:41=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Jun 9, 2026 at 6:20=E2=80=AFAM Ritesh Harjani (IBM)
> <ritesh.list@gmail.com> wrote:
> >
> > This removed unused leftovers most of them are forward structure
> > declarations. Also removes SWAP_BATCH macro which isn't used any
> > where in the code.
> >
> > Found these during manual code review.
> >
> > Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> > ---
> >  include/linux/swap.h | 7 -------
> >  1 file changed, 7 deletions(-)
>
> Seems like this can be submitted independently of this patch series right=
?

+1

Applied the patch and built the kernel. It seems to work.
Feel free to add:
Reviewed-by: Barry Song <baohua@kernel.org>

