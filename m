Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8623CC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7936B0088; Wed, 22 Jul 2026 10:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78F546B008C; Wed, 22 Jul 2026 10:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658246B0092; Wed, 22 Jul 2026 10:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3BC6B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:02:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB3F014016B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:02:41 +0000 (UTC)
X-FDA: 85016578122.11.8422CC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C8A8140013
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:02:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bfyt0B3R;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784728959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgzAv324wbWpcz6dBQ14sGLLSXabiEa87HpRWnnfqqU=;
	b=cSJXzv/PkejFTUTlr0fUOgnXQfPUmMBbi+O02nff/R79uBW4+ayEfpWmfgn1hESBRBqVHT
	QKRQUB3XJpT96fzRFrLGBuFNHfCsrpSnTwgz5QgYBnxi1C3mmmWCzLKz1Wasl/OFjMgMdn
	TTj0mKZ4Qz1mZikp3Ath6vA9E8H0Ynw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784728959;
	b=YvMNfu+pT+ViHFBntmMfYfIwD2XXcV386H/4DmlGmdnT8lHljVERiZN1Ifmd/06NR5kQkP
	QI9yRZ0zAJZJa0vW4wLY+KSwYulttgnrldrE2ljFLUbUOYNHDCzzY7XR6LD8NkhqpcdYFo
	BukrF3WG+8frpINWdR28ihuhIS9wk6A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bfyt0B3R;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09B2B42B05;
	Wed, 22 Jul 2026 14:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EE91F000E9;
	Wed, 22 Jul 2026 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784728958;
	bh=EgzAv324wbWpcz6dBQ14sGLLSXabiEa87HpRWnnfqqU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Bfyt0B3RXEPX+KCdYlIAAjVVmIoEZZz9zHzxtgrLHfjS3pG+M7QY3KxLGxsg2e8ZZ
	 zSB+0YjDPXhySzgSAlLU/hTmWfrtzz5wQ3N/+Rb21gXYpIVwPN+l30xgnNxEPJ1XtP
	 mem6wGdkgKAfgwySqRYq72mlycMBJEOYoaJ9h7oz/3KViWJsu48iBgaRlsKRnBizgv
	 AgAJBN41hzTjp10GBaaFfNLI7AzzwfSHCMvIeDjQn6H+1esaYAZ7OGm0Wab8+4hmSS
	 uOO0ZW9wTUAXPO7MusbJhxzDm9udgi9ey/MlTlUCde2fojRmx1s9xLcc5eGlLLPnhq
	 KgWzrhuDsa+7g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] binfmt_elf_fdpic: only honour the first PT_INTERP
From: Christian Brauner <brauner@kernel.org>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, stable@vger.kernel.org
In-Reply-To: <al_MqBrjDW1QjRau@daedalus>
References: <20260721-gezittert-medium-kreide-b41fc1f0277e@brauner>
 <al_MqBrjDW1QjRau@daedalus>
Date: Wed, 22 Jul 2026 16:02:33 +0200
Message-Id: <20260722-abgehackt-gedonnert-bekunden-39413664ab17@brauner>
X-Mailer: b4 0.16-dev-2f6f2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2431; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xW6HEANIwzaL9qihei/h38a0uLj9ZZuqjYQn7dfmeOk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlnK0u5JO9/EGm2TVjkoP0wUCeht1eE7KfLfq4r8biw
 KplDk5fO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbycDIjw3uWshOfT5bVmq9a
 FNi6vFP/qZu1yLfcl+yXRF4/XaK2NpiR4SyP0NHv74XE7VnV1pz3kXcL7cvhuTLxRcOuqWY7WHO
 28gIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: C8A8140013
X-Stat-Signature: bnyt7d7fhpkf4kejrbrewi4kb66j5ai8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784728959-366955
X-HE-Meta: U2FsdGVkX1+gi1DFgWka4wnPAigR6IzAQetSkPUVMjrhkCXe0U2h36ve9ZqLN1caYjisU2D1iCXAYoCY2R210/1Mh2AdngY7hBiFOoGWplAbuSs2zWUsbPNef9pMqaEvMvD5xe073FXU1LeEHgm9oZXQ94L1pOqylltbY0bfI1hHLhq69lgIHCw+PpMOxyrqeq6UzEIblZa50zSmy3935to93SJyllnS6V5IK51RWdIyggPsYMLf43dUbJlt56YdxAwNQKOEFW/n8AUp0bjSXmpY5J0s8aU5rr/NIrr4u4JEbd2bzGDerTIvBhzNERZ55DnLuw/wGUmO+klhkYY2e1aBfq/TBzTcB5/aMQbDJCu4ey64eloYY4XRP7zeAMq/+Fy+ytdCd8e61+BBabXaSB1LqqOQhcaH3Zz/L4t7Tmi0CpmNDkQIN3Hhe5X1jEVLIMOGyjHCb/U5Os7CRCa5VLdqQZpUGbdzO6t889q5jQo86DRaZdtGmkBer6EgBTdq+wHcF4RnUcN1M62oQA6Vvgy883DMr3ptC2mkmgbo3Jf0gUTRT+MR/I2sntKwYIWFWbUGvcWYscQxOhlDytGZ/Bgw13J69wlstWuENAgixdy3Yr/KXQgkzjjBm9oWl4LCMXCxixRTLlfFzqRmJQuzpwCe0uYF43zxm5JsMbX6k4A1RI5Rb1b0Bp2b4pzXYAFW2dzB3L+oTkRXz5N7lffoc7YBFHdBcwkmniROueZNdnydr73eFwQXz8Rw2o3fIIE2MOZ3eQOFI6twLuNhWMSo5FQLVTOF7S7dClyRQm9AogrO2b/hNMN/DfJS13ZAQiBKJshDxwl3etYBytJrLcKvJvRsa4Ov/RUoPiCe5PenB0Bgoh3o3X+Wbg/4CIap6hHFP+Zy91RamzpfP25s9XgNsecg5bPNmdzGnsC9g6+Dk+vu1DzdO/xVbMvTUNMF91f8T1wRi5IKHVRHIpjXcE1
 vq4WilIg
 GMYNN6Id6s9Leuywmn1+tRxSrkawQIVD2DaldMLBNywv/yiqSBjG/6WNsKCIiaMn1Q7fiRnWx8eeQXQaHi/GbD1YGH1C7EoCaoYiLehjeLU4zWVRBSjaQSwqtYZvkhxAj+7VeTy2JRR2vdtO8fnW6MHS9XiBmBniAtMvEztHafueoFN8j2wEu7sAcpHF9GtaDP7hdbBQH9/8RjmqH8cGrB6LvCRPuzroDCuHOwDpMo8OZ9LBWSAH+OwcrmLEbTHH8d+OsNYLW31PUhsGMTpIYey9KgiLs/nHcT+pAR7YDwiB4u0JGsLbmSap+gLHoaSv1Okm7cgvAL7Rjl2mrcA3EmfqvTrZA3yaXC7qFp95rQltETBFfAX7U7URkkm5fSE6SIH+0TMYKU85Bni3z8iwEZ3Bgy+LummMosbR3LYk86yZ2zHjTnEyeVPMGHkYSWqh7sQPvDZv3+bypNIkWH45b+WGWcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-21 22:37 +0200, Jori Koolstra wrote:
> On Tue, Jul 21, 2026 at 01:20:45PM +0200, Christian Brauner wrote:
> > The program header scan handles PT_INTERP from a switch nested in the
> > scan loop, so its break leaves the switch and not the loop. A binary
> > carrying more than one PT_INTERP runs the case again and overwrites both
> > interpreter_name and interpreter. The previous name allocation leaks and
> > so does the previous interpreter reference, along with the write denial
> > open_exec() took on it. The denial is never released, so the file stays
> > unwritable for as long as the system runs.
> > 
> > An unprivileged caller reaches this with a crafted binary and repeats it
> > at will. binfmt_elf stops at the first PT_INTERP. Do the same here.
> > 
> > The flaw dates back to the driver's introduction in the pre-git history
> > tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC ELF
> > binary format driver").
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> > ---
> >  fs/binfmt_elf_fdpic.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> > index 7e3108489c83..fe0b5c5ed2bc 100644
> > --- a/fs/binfmt_elf_fdpic.c
> > +++ b/fs/binfmt_elf_fdpic.c
> > @@ -231,6 +231,10 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
> >  	for (i = 0; i < exec_params.hdr.e_phnum; i++, phdr++) {
> >  		switch (phdr->p_type) {
> >  		case PT_INTERP:
> > +			/* elf ABI allows only one interpreter */
> > +			if (interpreter_name)
> > +				continue;
> > +
> >  			retval = -ENOMEM;
> >  			if (phdr->p_filesz > PATH_MAX)
> >  				goto error;
> > -- 
> > 2.53.0
> > 
> 
> Good catch.
> 
> Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>
> 
> Btw, it seems that elf_fdpic_map_file_constdisp_on_uclinux() has no
> check to verify that phdr->p_memsz >= phdr->p_filesz, despite elf(5)
> saying that
> 
> 	The file size may not be larger than the memory size.
> 
> Afaict, currently read_code() may blow past what vm_mmap() allocated
> there, which may result in memory corruption for a non MMU system. This
> is an LLM assisted find, and it may be that I missed something when
> verifying. If you agree this is wrong, I'll fix it.

Seems like a decent fix to do.


