Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDA0606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HcX01uNn
Received: by kanga.kvack.org (Postfix)
	id 883BE6B05B1; Mon, 16 Nov 2026 03:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8345E6B05B2; Mon, 16 Nov 2026 03:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74AD06B05B3; Mon, 16 Nov 2026 03:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C02D6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:01:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2107408FC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:01:04 +0000 (UTC)
X-FDA: 85440236448.13.E4B98F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 22D2F20008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:01:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcX01uNn;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794816063;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2U+r5omMSvTNilYbrVDSHAYW6jmnL3FBKnknVs4aUk=;
	b=6o4B7vezZhvumn7UTd3WGHZI6I37FtW9pGs1n0LJxpbHQsBfgdbceFWP2aO0aFUj9T0rV0
	LGV4EgMzh/uNar31tc0NetuP5tP8As6VmvJOb6sxAA+TP52a9iXI5R3cEN249dB8rmNEMO
	5kYyvqnO0l0Tj1x5lQo0x2wcP6l0ZOM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794816063;
	b=qQkXxBASEVBZ7vnROFrFMVK0W7Kmzdx0L1+KgjKhD22q+CGoidWCPdvdJgAFYDOAB7Nslt
	RhEdlde1LY6laSPw9FmxKr20eqQmFpJq913uTrzvMvl3LUWE60SPe5NfY0r1/3Vqs09qCs
	JHZ97Xefh2ilB07YaVxNjPOl7CJ3enE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcX01uNn;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CF6D4177D;
	Mon, 16 Nov 2026 08:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1B21F000C4;
	Mon, 16 Nov 2026 08:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794816062;
	bh=S2U+r5omMSvTNilYbrVDSHAYW6jmnL3FBKnknVs4aUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HcX01uNn2/09OkEGtqpsJU8FriKXne0zHaukY8JEFsDmzVSvB6XNvWRs6Neui7t+u
	 r81Nj/8K2ET4wtEzNr8op3oy8BQrohtyANxlO1X1qm6GzcjA6ownjmvSYh1AgqWUEH
	 uIXtBnHMD6X/EnR+pt2DE4tGh47RM54P/+PEjYy6SZ7I2N6aPDq1+hq8mtzc/6rNWI
	 PbUri01pK6go5DzMVxReivWqKvyMKlwpvU8/ywjXNJ9suxtBQ9CrCJpGjQZME3wzAA
	 5f/kWQOg3qbbCWYYtT7NMbU/pFkTrtjL3l+vifYCjbujkC3yjWbpk5PP+gpgvLdBqU
	 sFtYfyBpGOerw==
Message-ID: <sashiko-outbox-216493@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] mm/ksm: add initialization helpers for
 scan_get_next_rmap_item()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?WHUgWGluICh2aXZvKQ==?= <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, david@kernel.org, linux-mm@kvack.org, ljs@kernel.org
In-Reply-To: <20261115080049.132515-1-xu.xin@linux.dev>
References: <20261115075832.132109-1-xu.xin@linux.dev>
 <20261115080049.132515-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 08:01:01 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: omkxjzswgg9ky9kmaubno9qsuxnykzup
X-Rspamd-Queue-Id: 22D2F20008
X-Rspam-User: 
X-HE-Tag: 1794816062-954992
X-HE-Meta: U2FsdGVkX18ABf+l1/z3UFJ51Le3JkkVQTKEc3SR5toBg8dLNSJA2DpC1U7u1Ep0FhnGgK3f5fIIOVRN/2e/aI+h28XlxbsyFMSwXzl8YrGuVVeWE5q4L2Z3zLtNs8vnhoz4RdCzkoyIgWIW1usR9L0cSBHOolHj7RZxlyU3VVVQTXPgvdYjpHgOEMovE7hBYMJYbIqpsqZqhWg57nLJr56twdQqQBf1wW75kre/4oA+k5m0q0uSLd2Ek2fENgglp5/ZpHfa7h9MvddVyZZxhrJqZQXtqPMsIU+PfmnLzALX8ZrAdrnkx4NqcUOxn1oMfvz7rOQen9w3BUjybGfXXC93TyhpI1fayv6hHhEnMCr/8wwiDWzO63eewmH8sCSFmoAvyyVnDIaMFfh6/Vthjqn/X+GHcitzXbH/QHmMT7N7z30FsLFGnPVKsfDgLFqvGXyjwNBUnGkuVcrzMesDSWn5J+CnTTlcqkJuoAbwlMBASsnUIWtYfhyFzoTiV8gGxI3GASCo48pdO2F/PaPGlR5S90xofckhGUMUOZc7mr6PxauLvp0dVSijRa1UKrz6gnIyMsMC5EJ9uyEphxKsOadk+Z+5wCiIyn3M6Fcqc8s7a/0hNcQf4rTmj5AwE82FFkaw9WksKXRVs3s5k31tH6Kmv//wtaDx4D8QnVvOGWbErUkJyLrHt2/rSlks0KXcl01Ylqdb3XZCXR545vyRKIDDHjFA2cC6zEicPUpjlr5qyFnpLb5zXlxJH27Mc6DJV6iSHUs8tvR2OgH2XH3WFCv0AXbOleRVfsTC8WBCEwdgtspy6tjyIp/p9nIi5sHa+buDbUocXP3ZTNtDbwdc3tqmGGtCIT2wRXjsak1JFLnwqguKKGiixLTMgcYKPYurauWxghQV/sPY7Yf0EOQ5t+Yc3Z4xk/SjPj8/LFXWPPv0aCpSwRCp6XAw1BNW9azT6JI6O8C64VyPUNiYwVs
 YWMdW+iz
 4b/uLF9x05y3VkWrbDCJFHstCP12Tg/ZKxHQMh1mZ6ZZZwPyx/mUHmDvvg24bc/5TWHsX3RbX6zp2HKL/33Z347KaQ6NAeoiQU8caPzZFaaKDn2mnTN1P6YhEnvjGMnrvz1M6XA2k5wgwIyt3Nkuq8V7KXSOSqlepTDpsL5M4Wpug0oMJy8jVNr5hs/cOTHLVe/KA7L0m74pXHbb8GJAKi6XH216YUIMn5ll7VKD2qeGw/rCZuSNtfxQpWQB+rIApQ2FWr23HlJx4VCoFYr8RB30aiw8HzYwYL1WgVMgWG8It0PPB/Y5PXcP/GnRJI0nrO1Ryt5/FCShrQ3l/NI1rEG1dE2wZOKwMmKGN4eAXHC2z05SYauGft5EXZHtyUzhaeCqHOYDPjrOjP+JTOHKAVZGaG028H+SYKud+xf2nBIKXAjJhSuZyo/Tf9IRuBHF2nkYetINOnrev70CrtBGyQOJ4Sm14PrHU4PcnjI7ciKisj1IkIx9xqIIwpqFoYrxuy5zTvugaMsyBlwcGaSNJC2qF/hmUBJiEHLvBgVZWYevzynsHYtJD7p6y41GJFklJqu88gYK8pO2j1II0XfNkx51ave0DvdMMFE8MCIRPeKs7/KJ69y+hW67cq5BIbMY1eLbQ7qvcLPNvKrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/ksm: uninitialized mm_slot dereference in
  scan_get_next_rmap_item()
--

commit c379de4f41203759cd851dbc9790adb7f3dde0fd
Author: Xu Xin (vivo) <xu.xin@linux.dev>

mm/ksm: add initialization helpers for scan_get_next_rmap_item()

This commit extracts the new scan cycle check into
scan_should_start_new_cycle() and adds scan_get_first_mm() to advance the
scan cursor to the first mm_slot in scan_get_next_rmap_item().

> diff --git a/mm/ksm.c b/mm/ksm.c
> index b81a49c65030b..7d0f4bad53b28 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c

[ ... ]

> @@ -2662,8 +2690,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_ite=
m(struct page **page)
>  	if (list_empty(&ksm_mm_head.slot.mm_node))
>  		return NULL;
> =20
> -	mm_slot =3D ksm_scan.mm_slot;
> -	if (mm_slot =3D=3D &ksm_mm_head) {
> +	if (scan_should_start_new_cycle()) {
>  		advisor_start_scan();
>  		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
> =20
> @@ -2682,17 +2709,8 @@ static struct ksm_rmap_item *scan_get_next_rmap_it=
em(struct page **page)
>  		ksm_prune_migrate_nodes();
>  		ksm_reset_unstable_trees();
> =20
> -		spin_lock(&ksm_mmlist_lock);
> -		slot =3D list_entry(mm_slot->slot.mm_node.next,
> -				  struct mm_slot, mm_node);
> -		mm_slot =3D mm_slot_entry(slot, struct ksm_mm_slot, slot);
> -		ksm_scan.mm_slot =3D mm_slot;
> -		spin_unlock(&ksm_mmlist_lock);
> -		/*
> -		 * Although we tested list_empty() above, a racing __ksm_exit
> -		 * of the last mm on the list may have removed it since then.
> -		 */
> -		if (mm_slot =3D=3D &ksm_mm_head)
> +		mm_slot =3D scan_get_first_mm();
> +		if (!mm_slot)
>  			return NULL;
>  next_mm:
>  		ksm_scan.address =3D 0;

[Severity: High]
Does removing mm_slot =3D ksm_scan.mm_slot leave mm_slot uninitialized when
a scan cycle is already in progress?

mm_slot is now only assigned inside the scan_should_start_new_cycle()
block:

mm/ksm.c:scan_get_next_rmap_item() {
	struct mm_struct *mm;
	struct ksm_mm_slot *mm_slot;
    ...
	if (scan_should_start_new_cycle()) {
    ...
		mm_slot =3D scan_get_first_mm();
		if (!mm_slot)
			return NULL;
next_mm:
		ksm_scan.address =3D 0;
		ksm_scan.rmap_list =3D &mm_slot->rmap_list;
	}

	slot =3D &mm_slot->slot;
	mm =3D slot->mm;
	vma_iter_init(&vmi, mm, ksm_scan.address);

	mmap_read_lock(mm);
    ...
}

On the second call to scan_get_next_rmap_item() in a scan cycle,
scan_should_start_new_cycle() returns false and execution proceeds to
slot =3D &mm_slot->slot; mm =3D slot->mm; with an uninitialized mm_slot
pointer, causing a kernel crash in ksmd as well as a
-Wmaybe-uninitialized build warning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115075832.1321=
09-1-xu.xin@linux.dev?part=3D2

