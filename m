Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D1B606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bUl1Sy6w
Received: by kanga.kvack.org (Postfix)
	id 1B2896B05B2; Wed, 18 Nov 2026 10:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A496B05BC; Wed, 18 Nov 2026 10:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004326B05BD; Wed, 18 Nov 2026 10:59:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C542A6B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:59:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F209C07BE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:59:10 +0000 (UTC)
X-FDA: 85448698860.07.FF1D613
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8A5D6A000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:59:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUl1Sy6w;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017548;
	b=qcPE5aa8jyah/MYobNwEr7XChCtm3cQ2gMMvBGlR1t1AYU1Sn2s8RQhtX8SHFZ3RTBRNwt
	shABD/KWFyWUHQH1CnJqKbTEEvCpvIeBy1oN32S8oj5gefiSUdcCXBPrm/btei26UN1wl0
	zAxWQuUQeh1FwluMuDtQt6lStieIFvk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017548;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4eYjkyW3i82Rheb3jflbwVIOwIt4h9ILc15rP8EiaRc=;
	b=sT4Xwgd723qUzL0ffG2dO32fB/F5Hj7AaWmwOoa3GQ/JxlzRqSHNVEDM3HCtgfjXOBIVdV
	fVAyGYYJDjsURQIj/rPtmW9GZSLchMIHIm7NesrINaOwHPhhLMMx5cJlB/jllhHxQcWwKg
	xSY4tGcVpbaGU0Mv4x9xDiJIVGbeZLg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUl1Sy6w;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBBE644762;
	Wed, 18 Nov 2026 15:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6BB1F000C5;
	Wed, 18 Nov 2026 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017546;
	bh=4eYjkyW3i82Rheb3jflbwVIOwIt4h9ILc15rP8EiaRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bUl1Sy6w8s1GIA2EqOed33vRd9QmF4UYhZwvLeLyScwpKxBovGIcZ4dThGLNXvMSK
	 Qu+EjcRnVDccFe1edUmhR4VSGhLWFnFlhq8PoKP9tdA9nBq+/KHB627GUNdkGYzvwi
	 O8vwBcMrf1O2e6SHRrWwfYi7LOMAu7lIqdglO6q2fJsLJgfUO2R1Ge1Ew485N+Jv7r
	 AKlywCTOaF0/QVFy3YT8wO69NumyfwjHudep0Rkxg4cvNaPZGjFdOQv6g7imAG2nOt
	 aLHIVgS094mSZKXrVNqNqGaoDp+Pj1YBM6M1dMCuPiMQzkiM8HR5l2PYqsZv+05Udx
	 D9STrD34hnSDw==
Message-ID: <sashiko-outbox-221397@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ==?= <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>, "Jingyi Sun" <1045704958@qq.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Muhammad
 Usama Anjum" <usama.anjum@arm.com>, "Peter Xu" <peterx@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 15:59:05 +0000
X-Rspamd-Queue-Id: 8A5D6A000D
X-Rspam-User:
X-Stat-Signature: mojnhujg1wz3sat9cyhzyih98hmb9izw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795017548-33889
X-HE-Meta: U2FsdGVkX18ZDmLrqUuhChTldtCHKxb6MVwW7vIlZN61zF5NBpiuukXByBE28xtkqtkJd0pN8KP/k3Vtu2wYIKYJIO9XCSAD69v2P2+YG38aoElBsMNok511EU/NHwMrsMfCx0ema2A8Qg6lpnxJuFJ5h8b5TZnmhi6rriU4Wesu40YP0NG1GcSmN+Y15qMs5AUE8c/TYweOJpPJa3QX5QJfpYo8xLgTDltMLP/3hCdUebNFdfDBuWbko2G9wLfemejbYbtvgWXg/ZaRtabq4++Er3X2BHh/1co5VG7BWUXqFA+wNajQbYWQwW+dwO55cF3BvNmq8igrEYY0NDM85Q4jqIwB+wD8DBF9eLCPU/Je/zTOi/VONSUnbw/53LH3uxr+hkWIRDv0CMjMq/ViuRypbZr79wyJlFl4GFlkTgZStsmdN0hIPGL0yTjPGeQeTgatGcIvGyBPmDSZlr2GK4AlG4W/dJqFT/uzpwDyMEZdyFxEVlp1hP15i2J89PgYeU9nHtFMcNEq/BPsn1arTqA5HU+0crgWzxeKgoKRprdf81r4vxPkX3KP1mAyqC4XUgDaO++L2kbIaY+Sq24DFQwrKhgxrjxm/5d70kIYp7xvOH19WX/ji6jiLojs0lGSLHdz9QgFkW4WaNtdFbUszuP8RWMVyZoD+1XNqbjIQ9kwLabHKY7ohUsKjTZ5eJvUvr+GC3Sq9aF0yRkbm8k79MfyTVn685m3kphB+tRPwMHDrvzv5Qkm1Yghb62Ltwf7jAckUxX1WfAKz6W/YqyKRkT5UkeWBphVZv50MfhDBFtXXRGLiFALZmWAiQu9zHmB8/FI9/4yVtt6B0zPWcEc+IP6Zuc0LHjQRHcPn/ygDKWxaiLz4agGeUKDO0w3POIr1NjZ/hp5aF1UCJKgWJt3jZ2T9j6Spl4VA/p9U9fUW8n0qQMelQyobaDoug86WVdkPurnaZyOtFno3ZvQuZB
 IdIBMlUP
 DpmNDEbxtji9RVR8LKbiNWa1HOj1Zl4J4ELDzD+uAakkxFWVGOtUl8iSSOJAFbzVOXt2tWq6TzJmO6nLy+/kptbHZWAjIehu1py3WuuHziDMJ6IHvw2Dk9b70zfMNI9ON3DmnOoMOCJ4QBc1+Ns228nvQzce5W7Zoh3SxBI6HRiign7JmkWx8Jq2UMBQ0vXiPXnxxfcXvU7bq2w8tm5jvXpSvCDLBjqj2Rm17Cbne/cN3aq2dkVE/OqVkDVOeBmJ6Ar0zD53ur/UVkmKSHICM7wwOobkKm2F4GPwmBN60NK+elZM5TVu1+KvenGIffniIIYjapTXRclZXj/ZSV7HMitqVv5hAEQS/VhN4W/i5XqFCbSAPtvLxTct0uJThkHjsT9+QdKIphdmFrJOGHePDSuXTzs57F5WjfEbmxgZ+AWlG7ND4BMW+Rvf21gu0d9WnqdxT2apjI/4q6Y+Tn/QUTVoc0slhq6NaT/psro9KBMSeW5IQD6U16udqYOhz8+l8CURJxOORwogSO0dTACd5Elnwtn1LPfy3NHb5lQ0Z8s1QW3d/Hq2CCTUAnKeii2O1kAdWMTl2SK0xshQk53c5tE+sfT9S/0XW5GhfcWKKhjbmmP4ipRvk6WHy5fqeHyh9nIp4xcb/9VhQeJO7SeHiqquIUtK7RXQ300+ol8fUpSvw6175gPbLeVOdlPy0ytQj44p3kZ1yvWWoaofzPoioAX0oeOx8kuDBIcxSNzgHsV2/tznlva+6D5VQz31oCnXyyLpk11dmpMJ9eStA6PQ6Jj+/UKJTWHrM/gL4
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
- [Medium] mm/memory: insert_page_into_pte_locked() upgrades uffd-wp
  PTEs to writable
--

commit 62002bc33a7233bf10217f5cd96cf7d78e384960
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()

This commit changes insert_page_into_pte_locked() to return -EBUSY when
encountering a non-present PTE on a write fault so that PTE markers are
retried through handle_pte_marker() instead of being upgraded in place.

> diff --git a/mm/memory.c b/mm/memory.c
> index 66ad58429967e..a80925c61706d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_ar=
ea_struct *vma, pte_t *pte,
>  		return 0;
>  	}
> =20
> -	if (!mkwrite)
> +	if (!mkwrite || !pte_present(pteval))
>  		return -EBUSY;

[Severity: Medium]
Can this still upgrade a present PTE that is write-protected by
userfaultfd-wp in place?

When two threads fault concurrently on a PTE_MARKER_UFFD_WP entry in a
shared DAX mapping, the first fault installs a present read-only PTE with
pte_mkuffd() set, and the second write fault then sees a present PTE and
upgrades it with maybe_mkwrite():

CPU0 (read fault)                 CPU1 (write fault, mkwrite =3D true)
dax_iomap_pte_fault()             dax_iomap_pte_fault()
  vmf_insert_page()                 vmf_insert_page_mkwrite()
    insert_page_into_pte_locked()
      /* uffd_wp_marker is true */
      pteval =3D pte_mkuffd(pteval)
      set_pte_at(..., pteval)
                                      insert_page_into_pte_locked()
                                        /* pte_present(pteval) is true */
                                        pteval =3D maybe_mkwrite(pteval, vm=
a)
                                        ptep_set_access_flags(..., pteval, =
1)
                                          <-- pte_uffd() && pte_write()

Because maybe_mkwrite() sets the writable bit without clearing the uffd-wp
bit, this installs a present PTE with both pte_uffd() and pte_write() set.
That triggers the WARN_ON_ONCE(pte_uffd(pte) && pte_write(pte)) in
page_table_check_pte_flags() and allows subsequent writes to bypass
do_wp_page(), losing userfaultfd-wp write tracking.

Should this check also return -EBUSY when userfaultfd_pte_wp(vma, pteval)
is true so the fault retries through do_wp_page()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-uffd-dax-a=
sync-wp-fix-v1-0-c9a30f27f452@kernel.org?part=3D3

