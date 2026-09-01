Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6796C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0D46B00B6; Tue,  1 Sep 2026 04:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5985F6B00B8; Tue,  1 Sep 2026 04:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF336B00BA; Tue,  1 Sep 2026 04:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 221A96B00B6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:12:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C7DB1401A3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:12:14 +0000 (UTC)
X-FDA: 85164475788.25.D304305
Received: from 1.mo576.mail-out.ovh.net (1.mo576.mail-out.ovh.net [178.33.251.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1890A20004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:12:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=YO+VOiUT;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 178.33.251.173 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788250332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUaynCIfI2k00quB79erNLXXPtwh5LI+gQzFVcNXhSM=;
	b=KzKUciL4hmf+acy1P/2wigxkoDuBe134uYchwamNQAHqMC12nUeaqsbHETovvLuO+tjmlS
	SUi3Z079RTBBXO99n01e4jk1ElR0E9I/9fU4lwX9vk0v51VvU8TEuh9pEDk2gaplCv99S5
	i4cUn1XVkkEhyvftgYY6UicNgxL5rss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788250332;
	b=eaGQwy4XC/xNworiyDYfxcqYwU4Yc3cOxmSwDEcl4cr9Eud+dyee1uNX5b07pGmSMwjgEQ
	KXtPNLqJEZbzVI/0LJkng6esDcqQDho32ZrSD7gQWYXdP8ztwUeK6xTBE4mtVSWEC3/A1E
	bRVxyvZXozrFuQc8fFC3WEeVSmONdes=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=YO+VOiUT;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 178.33.251.173 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr
Received: from director5.ghost.mail-out.ovh.net (unknown [10.110.43.80])
	by mo576.mail-out.ovh.net (Postfix) with ESMTP id 4hYz9Q34wnz5wkm
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:12:09 +0000 (UTC)
Received: from ghost-submission-c7b579475-ct55h (unknown [10.111.182.37])
	by director5.ghost.mail-out.ovh.net (Postfix) with ESMTPS id CD200100109;
	Tue,  1 Sep 2026 08:12:07 +0000 (UTC)
Received: from quelquesmots.fr ([37.59.142.113])
	by ghost-submission-c7b579475-ct55h with ESMTPSA
	id Vk3ZJNeIlmrHvBwAxQ/CHg
	(envelope-from <l.wandrebeck@quelquesmots.fr>); Tue, 01 Sep 2026 08:12:07 +0000
X-OVh-ClientIp:109.190.254.62
Message-ID: <78225f07785ed89e0c3e5def8a8bb1a48e444322.camel@quelquesmots.fr>
Subject: Re: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD
 F15h
From: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,  stable@vger.kernel.org
Date: Tue, 01 Sep 2026 10:12:07 +0200
In-Reply-To: <20260829185120.GBapMqKFM35KtL0Mod@fat_crate.local>
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
	 <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
	 <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
	 <0B48BE2C-2E72-4961-91D9-35E215F537A9@quelquesmots.fr>
	 <20260829185120.GBapMqKFM35KtL0Mod@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
MIME-Version: 1.0
x-ovh-tracer-id: 9860912862624480539
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTE8Ay7Pd3mgj9+Qc6lwFaY76eU0vJut+sn3595gpSzk/DYX0M4NxS1EwI+hz7IR3cb5FqieCB6ahFV9nqnXcp9O/J+XRcoQxejrvM9UB+l7IH51R9mNhRQ6VHZzoaJWDOZjimS8re33Tqp3+AF1CXQUq3w+gvzxJGHFt2bwLb8TEGPZ4l1ts3s1czfTSOICv8X5Ysv8puQMC0+gnupaVpiyvmOkCsXNTW6/xcqFnsK9EL+kt1yys03qJwohTnqQCFVtLmZJyJPFJBdd6SN9CjOHjvHhTXYhiAf/Oo/RPRC/KkF2tlwQ7qjxHxZaEbRPWZgA8GQ5cnWxCDxW9Jj7T1MuKirEuyHvKgAJ5HMQzr5sk9QtLOuTDX+c900kjRqeFolBBKHaJ4pDMcUUqVZR4Luil8UMrkvh2eQvUqUbewQDTsYPs6EwFPacuw2uGCp1Ef3fbQW+YELcj+fp3jFbixgx10/mDgJaInyqBsvBZWhaG+b5bY1ZkcYcOUn7F6eF3gUpEXS2PBKbY4BgjuymyEjrePI+93DOg6sFEI2iWmwAyK/kzce+BBoAuZU41++LIB7f6SZwPlx91onLzm/y18Wzn/zuyPRE1i+O4hE5HUOuUXcbudy75+C5uvjZWnAA1gxvt/KRIgkTBpFvdZ6NM43lYsOJS+PyCxAiWsTaP9qA5Q
DKIM-Signature: a=rsa-sha256; bh=RUaynCIfI2k00quB79erNLXXPtwh5LI+gQzFVcNXhSM=;
 c=relaxed/relaxed; d=quelquesmots.fr; h=From; s=ovhmo4049951-selector1;
 t=1788250330; v=1;
 b=YO+VOiUT4XZ8qoDOI0Sv/3sl7ux7MlR1c9FPLb4+gbU6h8q9lAxlS6tp/xFtxh1jkkT8QKkE
 /zxMZs+6DItQA4fnklzYurD//FrJ9OE935U1MsVOu81gYq00Sv/GQFGmPg282ir2KfgLkV2iA1E
 jXXJ5758nEK5fcsBkgrUcGvQGxi/Rt1Kf16HvXxL4rTbl8a5aaPKl5QbK/y+NXYT8Co25kaIL+8
 R5Lyy4gu67PhyqbIli2LKPvRbbQgOLmtnwJEbQ6k68uk0CkgA/Knxzy6MaJSOhFrmb2BykAcR6r
 gNP6PUjosKEBX2vD9UqJS9Be0nJ7z0MPMdLJBZg+aiG0g==
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1890A20004
X-Stat-Signature: 7wzxcged1fmdpbhympaqf4nrwc57ai38
X-Rspam-User: 
X-HE-Tag: 1788250331-746098
X-HE-Meta: U2FsdGVkX1+uOrAHlYwpDKy7J5lHftAvBlzjn8X7UB0OopkBU8b2jeB1wzEtvpMIMhpOswNvFxgC/OyMnH6nu3s+kyl+3VRPf1rSKEmZtLn7HJ8RcaTJhQ9SxwLnG/zvHukm2HCRG5BPS0xA98S3Nd39Bkg1oiNFncaTNyxyewCa/DR1JXExPMcqseoUz5OZXJPr00qCCdiIbxlOaUdOiCqVUX6vFAnGeIPxB14sTq0HSG34n5EFbgSoRCySIsUQHlaD3eaZQkos8BSlvuq2Ny+8Ob7AYHZqffDcA3Gl5ZO4Lxz0grBOV0ZPQuJSOVpQaIu3oY/zGTfPndDmmljvWek10xZxrGLresQu7qorb6nyMdUV6n60JBhWmjmz/4amFNU1kT7cvZH/FW7OZEbsKRYvyr73vO7+jLI+rLZP13lebZ0NzUs3gtlfvshCeQes7pb5oQZicFEx+Kaxe/iCjBtu12LC7Eqx28HHFBR1e4nD0rlLtrc1V5ljdYVWgGBT8ZtPWr+ndv8zZKofbP/QohmkPaqYD1nSwTi9B4XJJb2rkx81MqQOTGiLygJ3n3bmGs7wMtDaJQCr7uBd4qB6ASV4dsVod5n49PxF2v83+DWcRRP5NsiF5lQDCxVSsGE3xSFzioEelhwRByfKcMUcHM1yvSwOSNAkypV/E9iENOkP/OCH0VpUbfZsL287vOB52Dy2lR7INy+Zakfz3Fqly9mHKuN+C1biF5ZHldezPLSzpKbMMATQ0Y2MpJV9wm5zuNFSAjfjLWZwTn+niUdjP9NveT0a0TzddNRFUH9YvZzyUk8N6ptS9wJ5WobMrR2fv7WzJXmjUWqwXYZt0Dp8qdj4X4RNoO5hZi0rULBL9aR7780vW/WCRS7aRZkWuNvMW6zmrItranoCZihUeY0l8WQwIkWNEXkDEydveXCLR86GkbXjbJZXLmoyJWSmybYlconXjn1vByrEidIc9RQ
 npDs3lbm
 qLT5QK34CFoiCQcI0gNCb4q8ADEwxtwrIRtl28EY6aPOSK0IS/uAnS5pVYiDcueY4ehtjIAoz0VTfR02lQ3tUweYw4oAjzsPveEM/dizFIEzLvnybTYR/4S3INcstRqH45nG6v87RRtwaHFzBTLqUCRuzxdUKBW00ENLhVTmSTo3gJsxVBoLQoUdwlydBYEceD9GiYCfKDRY9NcMQH9incVLsDM3ScjcaZP1hSf/nmp9UQ6m4N20tCiK4iuFPtL3Ubc60FlJeElE/yd6AaGBIBBqlA2tjZ4f28lfip3c1+C+1nXZSJ74SJJPTcv567Z0t5f0VYwx+tjx8Q5+fiV6sRi9oIRI55aUD60BElrCieTbDC8WNtRltunolmlLxo7PGCO2f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-08-29 at 11:51 -0700, Borislav Petkov wrote:
> On Sat, Aug 29, 2026 at 08:15:40PM +0200, Laurent Wandrebeck wrote:
> > My homelab is indeed composed of 5 thinkcenter with a10-8770e, and
> > desktop has fx-8370e. Actually I hit that bug running 26.04/7.0 and
> > reproduced with 7.1, 7.2 so I dug a bit more and AI (I'm no kernel
> > hacker) proposed this patch. I'll happily test and report on
> > whatever
> > you'll propose if that one does not fit. SSH+sudo access is
> > possible too
> > if you want.
>=20
> Thanks, just please do not send HTML mails and put your reply under
> the text
> you're referring to when you reply. Like I just did.
>=20
> Thx.
>=20

Sorry about, replied from my phone without thinking about it.
FYI, patched kernel has run a couple more days without any problem, and
I=E2=80=99m now running 7.3-rc1 with the same patch flawlessly.

[Tue Sep  1 06:55:41 2026] Kernel command line: BOOT_IMAGE=3D/vmlinuz-
7.3.0-rc1-hugetlbfix root=3D/dev/mapper/ubuntu--vg-ubuntu--lv ro
hugepagesz=3D1024M hugepages=3D7 mitigations=3Doff crashkernel=3D2G-4G:320M=
,4G-
32G:512M,32G-64G:1024M,64G-128G:2048M,128G-:4096M
[Tue Sep  1 06:55:42 2026] HugeTLB: registered 1.00 GiB page size, pre-
allocated 7 pages

Can I do anything else ?

Best,
--=20
Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>

