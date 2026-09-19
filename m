Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A467C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 08:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFF26B008C; Sat, 19 Sep 2026 04:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0DD6B0092; Sat, 19 Sep 2026 04:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B81D6B0093; Sat, 19 Sep 2026 04:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39E586B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 04:47:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF6A5A4291
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 08:47:52 +0000 (UTC)
X-FDA: 85229883984.01.9A46BA5
Received: from 9.mo576.mail-out.ovh.net (9.mo576.mail-out.ovh.net [46.105.56.78])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2F72B40002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 08:47:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=ifxda4BP;
	spf=pass (imf12.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 46.105.56.78 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789807670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJ5AQwi4ZkHQPw/8D79gm21ialov4SoaTR54NOHjovs=;
	b=KxxklMOXgWb6tJgU7UjnCKXCozlNLfgBA+DCL5HZdr9bd6cipE+l0cmGaxjgnfvGAhWUhc
	AdIKyZXTqstGFB53u/+6qf0mdBfcvWbYWpIaOppHNQcBvZpXxUA23pDOcYFyl8epLWfcnq
	V5/6tKDfqR/M7w/YXmwu09OyU2AGgVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789807670;
	b=YFJAuYt/egiH/B6bK9QOsmQjAsmYSpgNp5DHOU4BJ+vsEXqD4wkx8nR/n7o6Ndy5phNu6f
	SOwc9RBe2e5+hHDvL7V3/2gZClfrT08ydml5WRA3rkAw3SliIH7DZe4SiLtarwKEcBf5Rm
	/ucSUJ0qItkRQcDCi3s9sGEkIrNkhoY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=ifxda4BP;
	spf=pass (imf12.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 46.105.56.78 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr;
	dmarc=none
Received: from director11.ghost.mail-out.ovh.net (unknown [10.109.231.204])
	by mo576.mail-out.ovh.net (Postfix) with ESMTP id 4hn36D3sk9z5wJp
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 08:47:47 +0000 (UTC)
Received: from ghost-submission-c7b579475-bj6bb (unknown [10.108.54.81])
	by director11.ghost.mail-out.ovh.net (Postfix) with ESMTPS id AEDADC2D7D;
	Sat, 19 Sep 2026 08:47:46 +0000 (UTC)
Received: from quelquesmots.fr ([37.59.142.107])
	by ghost-submission-c7b579475-bj6bb with ESMTPSA
	id DOQQHTJMrmqqKz4ARPrK6Q
	(envelope-from <l.wandrebeck@quelquesmots.fr>); Sat, 19 Sep 2026 08:47:46 +0000
X-OVh-ClientIp:109.190.254.62
Message-ID: <45dc4a4f62e49107de788b4be9a4039e0d772fa1.camel@quelquesmots.fr>
Subject: Re: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD
 F15h
From: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,  stable@vger.kernel.org
Date: Sat, 19 Sep 2026 10:47:46 +0200
In-Reply-To: <20260916200247.GFaqr15333nu5IAfjU@fat_crate.local>
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
	 <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
	 <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
	 <0B48BE2C-2E72-4961-91D9-35E215F537A9@quelquesmots.fr>
	 <20260829185120.GBapMqKFM35KtL0Mod@fat_crate.local>
	 <78225f07785ed89e0c3e5def8a8bb1a48e444322.camel@quelquesmots.fr>
	 <20260916200247.GFaqr15333nu5IAfjU@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
MIME-Version: 1.0
x-ovh-tracer-id: 5490732374257761563
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTGPq357b6u3PaYeqTnZgFYWzVaEMDvfgxX4qKZ/OTzfZmZGHXOAnED6aCURb3o5qqIJGhv99/gJQ9pN6ZCHH+p9yKRc9PmTLqO00L422g/1qAh4ZmTErP0wiOx41xpEXwlXWe/9AEfi8Fgxng+8GzTuV4Zfyg/vxgID600Hsp0iuMDl3sdKDXVbGK6YpKV16K64DK93XshX/Q0puDwe/qxeaIBr9PecvkmFxBfFwnuljEVhuHR4tCS9vF5odTlGMPn/88wjLgG6jwwZFQPqSScT/2OUW+wvAm0Acsew7OBeLXT2l0VuRY7dAf/CSuiywzcB5+5raygS/2AurzAAD0NUXBwcSaDfgwD4BrHklToPqhHopwxt4FEYo5OSWln1NEqsdrSmbbzs+ACmDtn4DKj9wWPWhqHrhGmvdYlQWdAa5Oo2kHz4Drl2HENwlgDqOlop9zq3fwfS3lSMT8x7cD2OF9A3dUZWOgrLSG3wqs3YY5JnWGPbySLbfByc+w6IWtBQsLj2emhV+KEiBepWWBGlh8Sd+whT09+HOtuapG+BZ+oAD9fxBokEKyxBLTNwI3AMhSXbtWiR7zk/8gwNsfuB73vKLldmfXY6AqM/Sxd87Ltv7qReNkr4lPoWySky7Q2A6FM2ZMYrExIt4QT033NMKKjg3hyw16ZiUuB+aoXMQA
DKIM-Signature: a=rsa-sha256; bh=dJ5AQwi4ZkHQPw/8D79gm21ialov4SoaTR54NOHjovs=;
 c=relaxed/relaxed; d=quelquesmots.fr; h=From; s=ovhmo4049951-selector1;
 t=1789807668; v=1;
 b=ifxda4BPcutZg/RmXXbM1TRNY7BDmuwrfDdRJaQ2rz99cFcLvxeM1kfIE25DtLkvbTxMjaFY
 QTp9QYPeVicqXI4BCxt5FWYtCPr99ZYx5Rw8GguPsVmAU0SylovIIwBAQNZi9WEL9IMcHKZW117
 aOk33DpkkvoG5HI8XX7ejGDzZZu41hWjgaxqCXUWPyXdEnMQdfAmSUgPzTLMw/LnKmM5w4HQEyW
 uEd8N91mgoZd3yxKPrsxDBEf9hx056SPbUHJ93ZMO0xhbe3I9sXT1CuiXoe0LWAegn6RijoXwRm
 T/yjNfOvCuoOCTfOtWU+Cr16zM28EBFX00+nZu5Jz8I0A==
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F72B40002
X-Stat-Signature: q93huxb63j6maup1dfhka3m7mjmz8myn
X-Rspam-User: 
X-HE-Tag: 1789807669-936579
X-HE-Meta: U2FsdGVkX1/W4E9L/Z1hXRPe+qnhgET0cclt438CNM2BKSy+bYnZ06h2UjAtaCF2i7B4Uuy8mcSsH/nx5dm/GhqTCiF+CWRpyK+23ibIOrI84QDDL70hoGDGjg6SrCPzTJJvYMmipGVMf01p/5qVhTB7xpG6OFJ7q0C2lbV4BUi/1O6OxGpt3zSvHg//xCvmu/Of7g93YKhx6ukMS8spU4NjI7gvAVQVxlFEDiyUgZLm1maFnIl5y3hv/2su9s3CR3iCZ1YgaX2o96bEclgJZIBkHU4NtL/hNnNeVUCG0ZakyUnapc06OFzHYiH5DPqY2mWfLB1B0bA3dwYODnO4xuafzvO9Kzfz51nrKUe4z+ZCXggJx5HxIawoT5qnHNYPS64ZC+nXrINcZXQX1VvPqnXoxaCf/ODjyJJ+uhF0jf9hGQ2AeZXUr8URZidho5elE+TCxnJ7LzRe9Hx8suGPsfdHbMa3j/sQ/TR3O5yLrTdiJAKrz7gn0pZxnenoGriIPFMsWwkJom+BT8OagBvhMW/agj4p/GRpXMIeJ6BGb8Xs+4aniZtEPkV1/XDea5vYauZ2L3bjdwConujAjPx+N5rxPLNVytpVUJB+nLp3ou2+HDZ2arZQ/GtSndTvH0BCL10ofAT7OubZqhqLhAI3glr2TBY5NFkWuLCIAI/WUrD+R2EHvYIVgLF5ErLakV+zOG7x31abaMz26QvW5ESTPCaUguu0KMjsDoFwHvf7xN970pdkJDy163e7OfFRZeFI8eG0uR5W3rGxVuhU07/UPzedPnclp/8N0praSA1f0uBJj0b+w2uAyJ/kqWZnL0bvm4UcT493+BQ+fKX7apKjUKTKd1x+dEYYMT95MT7o5ibCyGojafxKopqGCyNbobCmdKKhEd/XrHc14G/9zv1+OAsCWu+DgQ8DKY9sBBfNW6lAgQOpGjxk8CXE0GCFhenakUeuI//FlJGtGhzOg7t
 +b9+Trzq
 IxkH0uqciWAknBNQb2vKGRZzEbS/gJSMLVooJfKIbkEZT1bzbaBsqj2vR3M06pC0ryX/syYTWWymCeEBp0goCwYYfIOoMnrpuoqL2vON2QYts4dWI0r1taN2HgnjshMDCMiuRP+SXpI/VMwBWmkE/guVYs+zlJ699jvrVUmpVIAiKc6TYb2O3tgaVFIWw/x2ajq69HblVEoieHHv+qYDTZHG5nr4tH8g4/mWcWvX/6pGH56j8HKJzrbimyK4WSOlbCYFIeBH3e5QJtpYYDrwtAejWNG2PWjaOxr4K+tyIRIer2srO+k5olKb4g9ROxYTstP+ZBhu5oe99aM4MYsyAApCZBEO3NzIU+3EKYqD8Qz4NmuUL62lCe1KLEZ6+ImWuAMIuOYx4TX5Og9Vh8PJ4ORBgoa/cUCpF8SAEw1zTcjkODFwSz6mGiNj5ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-09-16 at 13:02 -0700, Borislav Petkov wrote:
> On Tue, Sep 01, 2026 at 10:12:07AM +0200, Laurent Wandrebeck wrote:
> > Sorry about, replied from my phone without thinking about it.
>=20
> No worries.
>=20
> > FYI, patched kernel has run a couple more days without any problem, and
> > I=E2=80=99m now running 7.3-rc1 with the same patch flawlessly.
>=20
> ...
> =C2=A0
> > Can I do anything else ?
>=20
> Does Dave's suggestion work too?
>=20
> https://lore.kernel.org/all/3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.co=
m/
>=20
> Thx.
>=20

Here=E2=80=99s the =C2=AB v2 =C2=BB patch I used instead, on top of 7.3-rc3=
.
Works without problem (several hours uptime).
If this looks ok to you, I=E2=80=99ll follow up with a proper [PATCH v2] ma=
il.
Thanks !

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 776ae6fa7f2d..a54f930e2c9a 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -28,7 +28,7 @@
  */
 static unsigned long get_align_mask(struct file *filp)
 {
-       if (filp && is_file_hugepages(filp))
+       if (is_file_hugepages(filp))
                return huge_page_mask_align(filp);
        /* handle 32- and 64-bit case with a single conditional */
        if (va_align.flags < 0 || !(va_align.flags & (2 - mmap_is_ia32())))
@@ -50,9 +50,13 @@ static unsigned long get_align_mask(struct file *filp)
  * value before calling vm_unmapped_area() or ORed directly to the
  * address.
  */
-static unsigned long get_align_bits(void)
+static unsigned long get_align_bits(struct file *filp)
 {
-       return va_align.bits & get_align_mask(NULL);
+       /* hugetlb mappings must stay on the huge page boundary. */
+       if (is_file_hugepages(filp))
+               return 0;
+
+       return va_align.bits & get_align_mask(filp);
 }
=20
 static int __init control_va_addr_alignment(char *str)
@@ -157,7 +161,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long=
 addr, unsigned long len,
        }
        if (filp) {
                info.align_mask =3D get_align_mask(filp);
-               info.align_offset +=3D get_align_bits();
+               info.align_offset +=3D get_align_bits(filp);
        }
=20
        return vm_unmapped_area(&info);
@@ -222,7 +226,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsig=
ned long addr0,
=20
        if (filp) {
                info.align_mask =3D get_align_mask(filp);
-               info.align_offset +=3D get_align_bits();
+               info.align_offset +=3D get_align_bits(filp);
        }
        addr =3D vm_unmapped_area(&info);
        if (!(addr & ~PAGE_MASK))

--=20
Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>

