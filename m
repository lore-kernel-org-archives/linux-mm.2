Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1762ECCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741048E00D4; Fri, 24 Oct 2025 12:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718538E00C9; Fri, 24 Oct 2025 12:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607E88E00D4; Fri, 24 Oct 2025 12:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49EEB8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:32:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DFDF113C4D9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:32:14 +0000 (UTC)
X-FDA: 84033550188.12.AD6D46B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4703440005
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:32:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQBvotmE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761323533; a=rsa-sha256;
	cv=none;
	b=KbZxTJwPHvEdq83mF6vqKI5Uvw+FNPF2JIuxGfrDIFSVrnSr61A+WMVNMtycbJWOjbLfhr
	CPn/8i3LLUcIgMdXfFZi1mdGYNBqIbWY9+p+ArdVPESFVS76uzGPeR6w3NEp5jlaLUbi09
	WbPhcLCDuloEaFCqqF/ON7HtbUD+QyY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQBvotmE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761323533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZKnudL8+d2Bae4BxQkN1jbmVKFzIvIa3FR/H9u1aJ/A=;
	b=ig8+iT36HKjU536hONj+bUhb8a2MGPhEQaMqOogg/xD90UeafhVfY18wtJxgweHrz04Wqo
	myblijTDgWugLSORaLb3NyxaQxh2A59bGzrSbw8mX/lFI8Y3/CqI6a6jqD3ChNk5ujhAwI
	+uiUxC2i6P169QQ+bkuHMqfO1sxjjbY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B4B560355;
	Fri, 24 Oct 2025 16:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2000DC4CEF1;
	Fri, 24 Oct 2025 16:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761323532;
	bh=QJbCv3dorbwltFD/bJzgSaTHfSbrFysNBhH68NyQCsQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BQBvotmEc5dzMUOyFMp+OMBmfTgmrRhBErDoqsVtOUIac28Aei5feBsG+d6vWY+eH
	 4rAwrLMrav/Om5Wu+34l5Zh/ZdiKAZNe/spxILBg7OvBrf96+1l1WkxlPvIpTqvRQ7
	 o19C49hbbzpyKu3z4AaWqKMsgc3zYpt4hxwzt3IhoN+3GnU6ixD20eF3I/5RBJLXXV
	 6iLI27UaGc5v+ZFG/JA+jKVBH4F0mjV5CP/w8IDhuoCcMoM7xc6rvJ1jlUDafQxdnm
	 nHkhw2WOVMOY7nsK5QmVCTsQspttcngQFPoqSJzd4afy/wK447GLF80f+oEiQqctyz
	 ak5vAp0wzFTwQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  akpm@linux-foundation.org,
  brauner@kernel.org,  corbet@lwn.net,  graf@amazon.com,  jgg@ziepe.ca,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  masahiroy@kernel.org,  ojeda@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCHv7 3/7] kho: drop notifiers
In-Reply-To: <CA+CK2bB_xPAsHXU62Hd5iBt-+Jf2BiXQM4M-QEL=AA_Xu-APhg@mail.gmail.com>
	(Pasha Tatashin's message of "Fri, 24 Oct 2025 12:15:32 -0400")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-4-pasha.tatashin@soleen.com>
	<mafs0ikg7fbez.fsf@kernel.org>
	<CA+CK2bDrrg0UoJXpeN+Au2-sreYrZ+DHVcEUidzPw2Qk60orgg@mail.gmail.com>
	<mafs0o6pwe1sy.fsf@kernel.org> <mafs0jz0ke1qd.fsf@kernel.org>
	<CA+CK2bB_xPAsHXU62Hd5iBt-+Jf2BiXQM4M-QEL=AA_Xu-APhg@mail.gmail.com>
Date: Fri, 24 Oct 2025 18:32:09 +0200
Message-ID: <mafs0frb8dzw6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4703440005
X-Stat-Signature: cdkf68g4whmc855bwj4faexdxg3hwmxp
X-HE-Tag: 1761323533-642614
X-HE-Meta: U2FsdGVkX192GjbdTFyShxR2hiatPIvTnjWaizVtBw0z7Y7JnMEar4bv4l+bHm3U+OCQ3wKYISqagrL2yK0bfBxCHfovK9KQONLTT7fyMNBaObbAOKdzeQYuuePRmA9fonsACrH3VMR/VYFWIyQs5V1f+kq3/eqkWj1eVAgh5hn6HJPZQGLUmhfc2F6vRj0k+xzdJVqB+t00mdYaLbrPy76onuMSckcI4MDcmiAVP1CzjjRAHDQNMsj64jhuMbrPe1C+zvUJwjZxt0YNho/qW4ZJwjq1HZQy4SDlx2/2ake0oNMrLaB04eTcNABYCRCKHr6u260IK5mLIdA0IVEl9l8grpKJUuvKBhO58280m0Hv9rxTnvEwPrJFAJ1G/Zzj5aa5fITc6rN7343nh27D0glrg5ul3iAWPpJcTH791tTjh2KEq6eG+pW/60cMDI/e/HZbESlcREeP+Cbrnu65aTXr7fWhCyyeRZ+lN4pnRSKEGsFErXvngwIvW/hTD/gFXVDf6f+KUPWTln3r95GXhBVtVUbpvpmjgS5mc2hPhVI3t+G5DdxopZlIkxvikSUvzSFBPEeGT9lKrbloyN/yOlAiiNqmpsNUWtdvwBYOrKCCPJy8cSreLvN0YWn0kUnKUiDQECTXtwdpGIE/sc3Zb5gOrcPuZhbyG+ArdAJ2+SY7OeNSBx+7rD9jMWmCXm/Z6yCQ0Dt+TZA87oSXHp0ujx30jQE+IfpalLX8e/90f+pJ98Xnm8r2afE2/AQZUS/ywXXhgXT5R1+sIhITOAL2Gytg1aczGuI+A/gMgGAAvfeZK4bcqn489sJl5nYHD2ZKipz2s/AYFO1VI/l0o43BUVCfbDGmm93ct/pREwgZ3pJfV3maCgKGWtoNY3VuKBW6jHCIlAHMhqqQmW/Y7ugmlCNAzxnpldCqlgdvbyOhHQkGAjHvRsWs4m5H8i1lXYOm64IMS9yx1hH/0Dxs9H5
 dppd06my
 7cXL4pcPm4dBdZq7KzCkpfTiV8jK0fQzXsDHYSdFrZ+dbEQQ89NAHYGVpfLeH47v5K1caoH2v0aeP2txWJCODo8NsfAgCib1jSb7rZpfcqUwUDVIwPYU0YhkRcr4fVPHj15igbzofJTZ8azTOpsC5LNB6Hmz0XjKeC0VqSmKMx03ySwYWL+5IIeCXyxyL3PJ+1TIcc73/4JDvvXA3x0BSW7CUZZwlBCxG24AKJID5QY8geKkMWTtH3fse0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Pasha Tatashin wrote:

> On Fri, Oct 24, 2025 at 11:52=E2=80=AFAM Pratyush Yadav <pratyush@kernel.=
org> wrote:
>>
>> On Fri, Oct 24 2025, Pratyush Yadav wrote:
>>
>> > On Fri, Oct 24 2025, Pasha Tatashin wrote:
>> >
>> >>> > -int kho_add_subtree(struct kho_serialization *ser, const char *na=
me, void *fdt)
>> >>> > +int kho_add_subtree(const char *name, void *fdt)
>> >>> >  {
>> >>> > -     int err =3D 0;
>> >>> > -     u64 phys =3D (u64)virt_to_phys(fdt);
>> >>> > -     void *root =3D page_to_virt(ser->fdt);
>> >>> > +     struct kho_sub_fdt *sub_fdt;
>> >>> > +     int err;
>> >>> >
>> >>> > -     err |=3D fdt_begin_node(root, name);
>> >>> > -     err |=3D fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys=
));
>> >>> > -     err |=3D fdt_end_node(root);
>> >>> > +     sub_fdt =3D kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
>> >>> > +     if (!sub_fdt)
>> >>> > +             return -ENOMEM;
>> >>> >
>> >>> > -     if (err)
>> >>> > -             return err;
>> >>> > +     INIT_LIST_HEAD(&sub_fdt->l);
>> >>> > +     sub_fdt->name =3D name;
>> >>> > +     sub_fdt->fdt =3D fdt;
>> >>> >
>> >>> > -     return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
>> >>> > +     mutex_lock(&kho_out.fdts_lock);
>> >>> > +     list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
>> >>> > +     err =3D kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
>> >>>
>> >>> I think you should remove sub_fdt from the list and kfree() it on er=
ror
>> >>> here. Otherwise we signal an error to the caller and they might free
>> >>> sub_fdt->fdt, which will later result in a use-after-free at
>> >>> __kho_finalize().
>> >>
>> >> I think, it is better to simply do:
>> >> WARN_ON_ONCE(kho_debugfs_fdt_add(...));
>> >> Now debugfs is optional, and there is no reason to return an error to
>> >> a caller if kho_debugfs_fdt_add() fails
>> >
>> > Yeah, that works too.
>>
>> On a second thought, maybe pr_warn() instead of WARN_ON()? This isn't an
>> assertion since the debugfs creation can fail for many reasons. It isn't
>> expected to always succeed. So a full WARN_ON() splat seems overkill.
>
> I sent it with WARN_ON_ONCE(), I can change it to pr_warn_once() if
> there is another revision, otherwise we can just send a separate patch
> to make the change it is not that important.

Yep, makes sense.

--=20
Regards,
Pratyush Yadav

