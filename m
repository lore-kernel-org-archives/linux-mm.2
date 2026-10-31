Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5302606A323
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=8alias.com header.i=@8alias.com header.a=rsa-sha256 header.s=dkim header.b=Uu3KFHHX
Received: by kanga.kvack.org (Postfix)
	id F221E6B05B3; Sat, 31 Oct 2026 11:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2A66B05B4; Sat, 31 Oct 2026 11:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A246B05B5; Sat, 31 Oct 2026 11:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7CA36B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:45:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 465171A0781
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:45:33 +0000 (UTC)
X-FDA: 85383346146.06.3FA45F4
Received: from mail-107169.simplelogin.co (mail-107169.simplelogin.co [79.135.107.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C7E240007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:45:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=8alias.com header.s=dkim header.b=Uu3KFHHX;
	dmarc=pass (policy=quarantine) header.from=8alias.com;
	arc=pass ("simplelogin.co:s=arc-20230626:i=1");
	spf=pass (imf07.hostedemail.com: domain of sl.lmysyibrg4ztkojygezdonrmeazdknbrgeydkxi.cuedpvy3pntvq@8alias.com designates 79.135.107.169 as permitted sender) smtp.mailfrom=sl.lmysyibrg4ztkojygezdonrmeazdknbrgeydkxi.cuedpvy3pntvq@8alias.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793461531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzUzEHBbmgc5bGwSKasygIMu+7J+1rdvRalQ/DDgKSA=;
	b=TlxmnpCjZFZkov67H00ascYhpiDWWbxEJqfwiu7IKf4/sLE67Ffrg9Vf5Lqbj59N6XKbGZ
	P7hQaecgfl5aWzMYTtJuP/cFnNlnn+lQUS7h2zYxh6/WA0ZVUWrmtSKPPQ7IwDhYnxJGMW
	xg9a6Q4pk/Y7PbzIpey+0/ZLeFvb0aQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=8alias.com header.s=dkim header.b=Uu3KFHHX;
	dmarc=pass (policy=quarantine) header.from=8alias.com;
	arc=pass ("simplelogin.co:s=arc-20230626:i=1");
	spf=pass (imf07.hostedemail.com: domain of sl.lmysyibrg4ztkojygezdonrmeazdknbrgeydkxi.cuedpvy3pntvq@8alias.com designates 79.135.107.169 as permitted sender) smtp.mailfrom=sl.lmysyibrg4ztkojygezdonrmeazdknbrgeydkxi.cuedpvy3pntvq@8alias.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793461531;
	b=lcq6DWbIrWhHSf5WzPsILSsOBvEW2PAdjNQk3P0ROpjTnhXeClmgXJ0cwlbAjQgDdrhPDT
	a8gGH8MFjdtBu2b5e8lcY411rGM5SqM0wieU6X8HvHMMXcffkEnESUYZRm/LdHKo0D6xFa
	XWFljTbYRvXxO1UyYfnkRKz0jA9WJzI=
ARC-Seal: i=1; a=rsa-sha256; d=simplelogin.co; s=arc-20230626; t=1793461530;
	cv=none; b=Uu6UPx67nmHQjF86wBhXtfp6S+hA8FTOtZQPLOPwGjM0NEEsNZNTbyZ+UYj5hy/EK5ZwIxnCf4E7hlLctnsZDq76OpqDqf7gtenDfW8iU7lAuUOV3FlMJbX7I1URjr7ia4VsfULG8IEHkRSusjTTYRUgjuRFmBnoSbBC2HD8a1b+rKSt9clh3gBozsg79BkDnfAMIAh53JpHBXh8WYi/e7ypmL6J9PV2ukenZ39tff1bViWupC2OgF4x6rz0RcvZJfpOsCbw/ONNlnOzvv2we7o3MOwxGcnjmTx3rnJGMi7eDWcC9DnjfgLdHBGn3Pz4gnMq7R9o4Q+qX0Y0N8MVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=simplelogin.co; s=arc-20230626;
	t=1793461530; c=relaxed/simple;
	bh=KzUzEHBbmgc5bGwSKasygIMu+7J+1rdvRalQ/DDgKSA=;
	h=Date:Subject:In-Reply-To:From:To:Cc:References; b=2KY8BK4t0yfEQL1OyFB2x2uoodbRJIvnUiAYqZzH3s9npGOJAXHqEGTHs8Vwnxp0qtJHmvpi7hYlnZnWUC73WkiOcD7E46BmPv/kfDMFo1zM6eyYOBYLkyDD5H2b+4N14hl/znVU4KxKWst9FHjrgKOOnvkkAAWl2Bn9B1x0LyWmrbkyCBY1k6dDYOXlD1WaZJQXoGaw2FDzgFYydWLC3Mq0XIwaGjbmOMa+Nqn3qI2zFMN7r9AvwJln2HjftTvee6xQzIia7uXs5sR3p0xzzEm0Gaek/M88TH+zsRGEXpkycowV61Q9UBvojHrt+uBJSZtKXjgFUwDxbl0JoayCcQ==
ARC-Authentication-Results: i=1; mail.protonmail.ch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=8alias.com; s=dkim;
	t=1793461530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KzUzEHBbmgc5bGwSKasygIMu+7J+1rdvRalQ/DDgKSA=;
	b=Uu3KFHHX88CcCh5JfEviiqH0gnfXqkGciAG7Z/cRJX72aW0pV5QhdC2h1Lf6uOFPkwn7Lg
	Axk0u/Dyqd+UcyeDZ/GJQAM8A0W5sf0jiOPFyd+RRFPoTRF/j5OcW4auCXlCjXKA2VUlWE
	MG5BAGmFhROWyvP9eggB2X0mEa1uGGo=
Date: Sat, 31 Oct 2026 15:45:21 +0000
Subject: [PATCH 6.12.y 2/2] mm/early_ioremap: Sign-extend PAGE_MASK when
 aligning the physical address
In-Reply-To: <179346145167.7.7861216093151225931.1735978772@8alias.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: =?utf-8?q?Radek_Marci=C5=88a?= <github.unusual340@8alias.com>
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>,Ingo Molnar <mingo@redhat.com>,Borislav
 Petkov <bp@alien8.de>,Dave Hansen
 <dave.hansen@linux.intel.com>,x86@kernel.org,Andrew Morton
 <akpm@linux-foundation.org>,David Hildenbrand
 <david@kernel.org>,linux-mm@kvack.org,Arnd Bergmann <arnd@arndb.de>,Michael
 Kelley <mhkelley58@gmail.com>,linux-kernel@vger.kernel.org
Message-ID: <179346152914.8.7838190602983146541.1735981230@8alias.com>
References: <179346145167.7.7861216093151225931.1735978772@8alias.com>
X-SimpleLogin-Type: Reply
X-SimpleLogin-EmailLog-ID: 1735981276
X-SimpleLogin-Want-Signing: yes
X-Rspamd-Queue-Id: 5C7E240007
X-Stat-Signature: r5xdse66qwu5z5e5ueqkxjmsbwusqhyy
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793461531-576497
X-HE-Meta: U2FsdGVkX1/68A3QqIbKSPD+qgDnkrZ3QrcjU6jriJOsS9/58dwkkLs5d4t8NkeuZVjT37kj7PvoSFguvviAJfKsEOCxWhEjkPSdbyPzp9PkP150oc0HQUoXGzyP1bSXnlXjFRGGCYVo/RrNJEMMcBOl6ZsivwerIR9P1CE9Uhcc/6cELdZYnWh657KNv4svDDExxuYIcFUY6abXQemDIIVaf7pWZIDP7+1SII5Xr/4xVZSrUQFA0ZTxehhpy4Fke7KYjigQN16yuywWOLtrbLPm7eiVq/60t/p8u3XqXYTb4fpYA9kQjSdlgLg1bSrAOc6IhTkdxZO911hJSnywfOYbwXqG9jYV55aNNyOPwpSX7T7gV7B8Pu1l45dUCE+degJCwzxrjCLbpuYqaNId8hKp0ZUOlsAcChW5kovhR8kgCPnA5EmIXFgCrM4mh7Z+wtqEox95iuwpqWpSp07az8aAJcolvR7e35jDSU4y0I8vvcT1+TfL+Y2ryvjg7oxK7+qi02inWt+snJpEzakwCaH2SyxqcGol/7bzFMLwBpY/T+5EF05XRDDqjRvNY2lrUcEFOEPD6yRV/MA542MTPTBWif3ZPL5r/gXxm9OM2U6r/WYdq0FX6ZDoH6elUrf8ALXQt+NgpoWUJw5lHXBpqT1p1hqo5w3zTgqRfnEPSsnjWO4MrAhCQzI/uP13d+QzzBScqR/7YlYrfBvheYgXQ2n8yTqevYQUEmKoknTixtoGTliXvPpBu/DCMDy5irG0rIdjCETt9OkVOC9L9FlVC36sKNz2J4pe7HzgXUMu9ITyWEzffCjYWLQ8sI7gnoaes5pZZWT23OtXNe1y3sCNye8pq7NjwVFEUCfCU8QOXHHpobxK1qo/G5MLasiHK/F48L0rNMtXL4qwhGwNL/NHK2SldGpt4oF9V+dsmmq/N28rdKu0vWPC6kcLGDr7PJEz2L8G3e2oE6fDZlZqobc
 wk7yCHL4
 o/WTMlNofjkit69AHU7ChlN5eFc4kdu5AVHFFGDMOLbuVzRlEytkZUBR9EJ+x7jvTUxYmHmPne9iULSw0kdL0+S0vsSRYu5HzSZJ1KkL42C9knzEaC4A3DyWrZ34K9Zmjs+mFyfVFa6NhpT/WxWBK1uGpn6xdNaXqZYNdp7nvzSjo4nc6edNn9sEm4GPiSG7E3E0Hssg2WucowM5cYkiBhLZZIRo9iGUN0HM0bBnPo5fK4+o9fEGJJa7rY6FKZmVa9eS9gudmo0EFnr8Nd94FTjHvrwHimnwFH9pulCinQ/XT4n1RD6+EDbyQ913Fh58QC1bpLvFHqu2KptmFB8tecUH94ktA6Czog1A/MAS57p9rQ68lQOr13L6Gis+qz8DT3EfN8HNjp4slqyaoix2njhFanMiSjJS/Vr1kF0PSj+pdfguRAxM8564sn/+lfG9NoBRBfngdZ7n8fYiz1+aiDADYLKrE6FhSSPJKl46hZwjLCziPCuCfUg6hAOkiv2hbeWt/3K/Da+8AFrG1VJibBfmUaLw5DaSCOTnuQUcdKUasF7g78XFVRIDYeUDiQfZ/BEC34ErjwzQVj8n2tAmfXQV9gdOFyn4ZjY08gIULSVNOcFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Radek Marci=C5=88a <github.unusual340@8alias.com>

[ Stable-only fix: mainline is not affected since v6.13, see below. ]

On 32-bit kernels with a 64-bit phys_addr_t and an unsigned long
PAGE_MASK, which in this tree is x86-32 with PAE, __early_ioremap()

=09phys_addr &=3D PAGE_MASK;

clears bits 32-63, so early_ioremap() and early_memremap() of anything
above 4 GiB map the alias at the low 32 bits instead. Cast PAGE_MASK
to signed long so it sign-extends.

Mainline lost the bug when commit efe8419ae78d ("vdso: Introduce
vdso/page.h") and commit d4a65302dd84 ("vdso: Change PAGE_MASK to
signed on all 32-bit architectures") made PAGE_MASK signed on 32-bit.
Those rework PAGE_MASK for every architecture, so they are not
backported.

Fixes: 9e5c33d7aeee ("mm: create generic early_ioremap() support")
Assisted-by: LLM
Signed-off-by: Radek Marci=C5=88a <github.unusual340@8alias.com>
---
 mm/early_ioremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/early_ioremap.c b/mm/early_ioremap.c
index ce06b2884789..ba0acdb72396 100644
--- a/mm/early_ioremap.c
+++ b/mm/early_ioremap.c
@@ -129,7 +129,7 @@ __early_ioremap(resource_size_t phys_addr, unsigned lon=
g size, pgprot_t prot)
 =09 * Mappings have to be page-aligned
 =09 */
 =09offset =3D offset_in_page(phys_addr);
-=09phys_addr &=3D PAGE_MASK;
+=09phys_addr &=3D (signed long)PAGE_MASK;
 =09size =3D PAGE_ALIGN(last_addr + 1) - phys_addr;
=20
 =09/*
--=20
2.56.0




