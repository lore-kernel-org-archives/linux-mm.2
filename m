Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC14C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1636B009E; Tue, 14 Jul 2026 05:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8F16B00A0; Tue, 14 Jul 2026 05:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF6B6B00A1; Tue, 14 Jul 2026 05:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4E096B009E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:47:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43870A028C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:47:39 +0000 (UTC)
X-FDA: 84986905038.30.3C640E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7708AA000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:47:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0sXocaS;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784022457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cRD5tp61vGr5S2DsLizm6q3lmn7Tl+FjuVbnFjpaWY=;
	b=2CoxlOvBYYZ49FFmu5kPptrJEWzp/MfRiaiY4S8d3BMNAEFiHukSE2Z+D4nmMlUZqnzws3
	oTCNx2yDXsvn64TBnycfZBhIK/QU5YloRpeZCb5rHkN9jfRUQjTac7xNw114r1iBrIds0T
	Yl1eL10SQot5UpZQogOC0s0KqrhRTF4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0sXocaS;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784022457;
	b=eIMJgNxzlq9yDzP/gTnSU4SfkKrXiWsy87v6n/y2+Ss+TD+xNDlJtK5RwT72o5l2OLoXHr
	wwvfvJlNBOINTEuurXtj9xv4KeFePC24ByqWDnOfEAIjZC0z+hc1w8rREdJq8ya5AL0EVy
	6QZMS5p0m7ZA2btk87jL2eMYYUo6njc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EC3543896;
	Tue, 14 Jul 2026 09:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44AC1F000E9;
	Tue, 14 Jul 2026 09:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784022456;
	bh=3cRD5tp61vGr5S2DsLizm6q3lmn7Tl+FjuVbnFjpaWY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=V0sXocaSYQi1xJqIt1MJBdQzPhZD56BHBzx2m7Yw0YvJlKm/n/fHnWNSauFyKWV5z
	 zNzTWGK/iFFwE+3x1Ak1tagoeCjsnadtm9wSEkHbw90gj+TOltpVAtj9SXn43yKJmf
	 0n/67q79i+1sQA53I2SYp+edL/sjVAnbH56U6DPa4G9rAY6EusqDThdfaNYdZroMDE
	 lzwZ6EroTsbWJw6S+IjzuD0irNPcqh8slpr3mzTzFQ5oR47KkQ0VmF7KH9jsma9UOV
	 4A4d/TMUv9TB6ORGVL/BtfLzbJPS2jeOLBLIQFffPB2cUzJfzQFXluodTlVZNLTyu8
	 hVfMkzX/tHOLw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH mm-hotfixes v2 2/4] x86/mm/pat: acquire mmap lock on
 page table free to avoid ptdump UAF
From: Lorenzo Stoakes <ljs@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
In-Reply-To: <20260712165341.GAalPGldsKpBs5treJ@fat_crate.local>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-2-ad134cc3a12a@kernel.org>
 <20260712165341.GAalPGldsKpBs5treJ@fat_crate.local>
Date: Tue, 14 Jul 2026 10:47:20 +0100
Message-Id: <178402244099.69739.5281491459981359633.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=642; i=ljs@kernel.org;
 h=from:subject:message-id; bh=t4XiP/IHs/MAWTmAJpg8U8XhqPVl/Di3JCGllCa8vzE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLCWFcta9IJr9ALSwlJ11PfNz119ZLQC4ssPNa9fy9c8
 53xZt7HjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEwkkoeRoeedzY2VCb/y5dql
 I87/W3A80feA/QmBunpebqWfO4IZyxj+J/eLv1gpe2b6b+2PijPuX0mbW1f4l+297Me6f7PDA9j
 CGAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7708AA000E
X-Stat-Signature: ezefb9urkgu8sbbdg5ssqpqsi5ucdq6q
X-HE-Tag: 1784022457-233705
X-HE-Meta: U2FsdGVkX19VMb5exF9RUUtSE1ipk8NpJaaLB28++6fugmAmAJG/oD+9nAF5hLgjKdvJWbb7mfmIj3HpPAxCAphx2Ly63r87NxWnUFSShq9Cb4bAK+VlyJgWAi5EnG/hL7PzCRpproOxrh9i3kwYNyh3II48ILH6iOA3O4EChn2RueR3dHUFiO9CH8bHn8SsgORNIrE0u2MQaTlk3pQ6f86YtAg12oyb2jvrMyvnhV0GXmK3YCfni3cYN3wCx3mq1W5RGZHAZaNn4x3dapNtqIKIh2f11BkwjmcQhKHthYdpVtLLfM6pVTfDzwCj8Nn4pcmOB0iGWND83kMeJMTbbScIdc6pOxDO1qEt+tyYiW0tMVxErukfsn2m1Y1HYV13yYQHySRKH2mq2rLrifPXxrRMBf+/ro3Of698SA0l7ANR+547VuV5xkeeCa1bsK0I1376V5D8/vSMXfbH62+gPi51JEYk/uS2FRlw61eiwVMlKL/Vj1mPveJT77rKQ6RC8Qj4YUQlYiA1HCZ7MPvFCAO3jWHzphdGRcRF4fWOW1a2OJMFIU4zJG8NT8C93c6WFjRSDTpM4W70G3n/PwaHmGaWFOOzASWYMN8K8tVQvoEO+f3BaqNuPkaeN9Zj6TxvVkhbb3WHDR0VMJJnsE3EHYBQa2fiDjpP1c5f1sXuZkQrhyJTvXadz2ZUxhAWvHkS8xcYvCFudmyF9OvN2Qw5kIQ62mfWGZkxuy49b76AOMSsIUm2TiIYS3opWnI/HrmWrtJ0NeNFauMzvTPgGCi/eBFdhGK8MxMbXy4DA87biopzC6YtdpjsU9S3ecZrg1aB/bWaa86yzvu2S2iZJJN+UkNnPfcFUpCaioQ/XKOgqpf4tj3XJMtYkj6rFZe/cUfNZ9Mi2wbXGgnptPz/F6ulpAAj1hd6zw3PRgdiagGs9J1d5JDbC3nquBFpkDkXnAp7be1pkp4IZa6NVppLqJF
 KL6OmNYY
 4F8Vs5OEK9uN/UenTrTF0Et7yl5u8ih2tJfrVn3tgSg9JXDP48bIQWrxFlXZpIDL3tXsFI37jc1pqcsndALss+eTL6dKwslsV/UeNG4w8difqrWi5Wsfo0CoCowHxIr5SDKp0iutS/eaY90PT9O7lpFJF6X5H16JayPmK8uKMoMFQ2u0tWAOWOEggAbXTiPn+PnrsnOOGOLBJ0lRvlB3D0p8qZfXv/7f78ghPcq8dFdGacaMdZFAvTk1rkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-12 09:53 -0700, Borislav Petkov wrote:
> On Sun, Jul 12, 2026 at 11:42:25AM +0100, Lorenzo Stoakes wrote:
> > This patch resolves the issue by acquiring the mmap read lock on init_mm to
>
> s/This patch resolves/Resolve/
>
> > provide mutual exclusion against ptdump, which acquires the init_mm write
> > lock.
>
> ...
>
> > We also include cleanup.h in order to use a scoped_guard() to implement
> > this cleanly.
>
> You don't need to explain that.
>
> Thx.

OK will reword on respin.

>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
>

Thanks, Lorenzo


