Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4780606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dovYivkZ
Received: by kanga.kvack.org (Postfix)
	id B80AD6B05B4; Sun, 22 Nov 2026 23:08:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57AA6B05B5; Sun, 22 Nov 2026 23:08:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA2B6B05B6; Sun, 22 Nov 2026 23:08:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 804576B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:08:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 751CA12078E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:46 +0000 (UTC)
X-FDA: 85465052652.19.7D3BADD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DD1DA140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dovYivkZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795406925;
	b=4lVQPrWeYz5tJMU9CMw+hh9YKsdI9iN0yrxMm8KjwLYh4tvJ3CSeG31H1NAVsOvPS/NYTD
	gcih2SD4pLLM6HzSU84uzfJiPlZBkvLpqt6AmxrjGmlKOzorfcfE6j54JK9Fowgcm5GpiX
	LYkYXTDMUocaaWOE0zAUCmWJ7HwIkkw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406925;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqpT7dCr9qlveBIEzUUp39PFxV19LPx9fvtVDpWayE8=;
	b=m71R7Nik1c25SgyRq80S9uImM0GgLIvCJQyngi8vU0AnMpd1pAJyq36dQgeEZW4I9fz1sy
	OyxdwFIGn4NIm6MBHPOUsjmQtyrE6sRn/rYkGoEEzDmeQKZZ/Is7Q4sp177zVh0KVW1iPb
	TIPIZaKntk0i5bdnp8IXV4mXb4moov8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dovYivkZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5329F60148;
	Mon, 23 Nov 2026 04:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5E01F000C0;
	Mon, 23 Nov 2026 04:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406924;
	bh=BqpT7dCr9qlveBIEzUUp39PFxV19LPx9fvtVDpWayE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dovYivkZsu51SYF9i+8+KggRj/B0Son63O9nj+DpR9KT7n8e6Jgoj5+rvfsYpdiVp
	 gQdMoJwmRTFOx4g8ZBmYxHvMRTabAFofSQcNwOmZbxKsnGNGIg8MQsn5Cwxx4Ci95G
	 Qy12QTRD7YzzgkeWJbFri9ih0gKCn5e2LIV5hu9u4IKAKvknsJcahEhW37UjfGQiSf
	 Bu+vHRh4Vhbh1nOxVNGW610u8oTTnMjNYk8RAeeGDs2uyMWPfY29C+g1rDNgtCSTnH
	 Lxaow4oPgZcf1rWvkxFyUDFEDMVWek+AR2s437MKidj1COEXGEfYzxkU6WJ8k0wyEM
	 +ZZ+ZAP07FTbg==
Message-ID: <sashiko-outbox-228633@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/19] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Houghton" <jthoughton@google.com>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "Linu
 Cherian" <linu.cherian@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Nanyong
 Sun" <sunnanyong@huawei.com>, "Yu Zhao" <yuzhao@google.com>, "Frank van der
 Linden" <fvdl@google.com>, "David Rientjes" <rientjes@google.com>, linux-mm@kvack.org
In-Reply-To: <20261122184453.2668189-5-jthoughton@google.com>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-5-jthoughton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:08:42 +0000
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DD1DA140003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: p3jfjq6kf9ek1uj8pmrc3qdz4pdaziwq
X-HE-Tag: 1795406924-781691
X-HE-Meta: U2FsdGVkX19l7a43wMGD2+0pbOhQIREbvd9XsnR///YuuD10p7ckB2VlJr/tfnZalDUhvscY1URNUG+OK9CoFX9epKMe1ZLZl91pF3uY55upiXwgVwgtmbENq7EXY5b/eswKNSfOTDkXSr3diRvcJyGQ8z2zfnMo8t46aEhcME+amL5N2HhZyeAgLcrcVTlAXEF9h98VB0JSF1pjxEw6VsnkLU2zuTrJMkJ1oIuUE/kNWZkyfTniiYGSRH+FVUxW5QYbl8tjVY2ML9TuhZSDjE+3pKROnqX/OE99J2CMhHhgTzvSFCf+oBCJT4nEQ+8QO+EEYa1i5bWCR4JF2+uo+iONzhXVxer8vbi112LQf6v3YSvON84yjfOZ6BRZvnkIsAZY/+fNCNoiTi3RpN3NinlTCATkcLbdlokiLajCr2JmWjG/8dK1ua2dXebFwDQX3py20g47K1+CqdmZcjVk03tGFzhx/PdEp3/JwTm7RozxiCes5yHxTlSsshTgJARcK9hmvaQyocG10TzSUo1No/KpGH6yXS8XBcb039texNmv7teVt5762qRZEDOyRobC41E9aexo1Jpww1hwLx+2mVq0qMNcCnBHCZst7WwXI44fLNzVDtJ0Rx7F12/7w3FS8fPTtMBuDNjOZmd2XZuO8Lmch403xYBfw8n1H6piX+i4Ea8pKKv8CyDrIltEHlkruzIXbkTloLM9HCrzN16slyMZAr7b96jc7JSisvmNgg4iqRD5WCTz93c58OappulkzFLy70paPvTt2wVzqZ1rJaz+y4gYOEHDxtj80HH66fgf7G9UQDgYUwizEqfPoWq4i5zG28FkN8/tBdvfOPb40NebfyjaiP+e87GaUTzw9Y/g3B1kJWe1MieCfix9zjFjNQiNiCNrc1Onyw3J3gZoyYzeyRU993RDNg5DWzfTiRC5tx/FO51flEyp5Myytlh4Dk1gzdI15mIE4EMGXvn
 VWS8SzvU
 UOr7TY9kzqqfFZFAVgHPkthf8v/uxZI7xuL16ImJi3j7LMKSYxGehHLeAXQ3v9v/x69di4tFVx5q0P/Pw+hJ7M2GDKumAZMl9PkU7amAbWywtoR4k0jVq7dRf99PEtT3Ipn6rtpzucxMVzxh7JK3FMHuRxk54WNpjmGdwaUft37Zdmc+z3Mykn4XfjTYdvv1PowlCp1DpBMPJ8YdmEPoxr4WDDXwp0Tf3ZwXTS9gx5IzvbOM7fjnPBYEmpx0P03f2nsDArkPPMFVfBe0MEobU5bwCDQk6y+U+4VXD/r4IZpouyTY5tIh5V1hbeYmUQvFoBvOqP2QeHTpT5oLFTKFVHAQBm816i0QUMZCeka+tZe9taFkDGKXOStnN5LWlx93Nv6Gi/XQTQfwfCOSJnywGsSB16Y5WQW/gNcGf+u3trEYsWANxNwQcBVpQie1nJW8l+7lvMwjjEHrjqK02VHeeE2xC7+YF0/1hSb9e7urW+evmxkHpeBtszzrv3k1s8QZI5vBJSpjCpEZBTbAEaLMKU0jhiJ6haTHsL8sUvQ84KWM52LA5aYkW7kTrFBC62dqVtZAU4rBD143rUd8EN9e+cVzoubLtvJ83GGMfezMnE257VYbRNUwZI30SI+j90X69/ATBiFLD9t+NyPK+blpSUxo+UGjANMkfTv/+BdtdOYmfSDfpVk9SN9pH9OaL80UqJ3hMW8mxpZB9xX1ncmIvoXXDwTgW/Ixsja5ESZuEieBzBntzINdTiT7FLng08C6tZOUVNBMrEJZG26a6mQJZn3apRQhOBsScpCORpYV0LhJPLVVPqNHkzCI34EKR1xi4SuJE63JIjWzUw2AD0RSregFFtWck8PalRn0JmFk4C6aQw0g=
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
- [Medium] mm/hugetlb_vmemmap: missing TLB flush on partial
  vmemmap_restore_pte() failure
--

commit 8b77f3aefb06415df030fdd341c5e065dabec71c
Author: James Houghton <jthoughton@google.com>

hugetlb_vmemmap: Use try_update_vmemmap_pte to update in-use PTEs

This commit introduces try_update_vmemmap_pte() and uses it in place of
set_pte_at() when remapping in-use vmemmap PTEs during hugetlb vmemmap
optimization and restoration.

> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 2e9cf8d39c892..b4d0311bcc4a2 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
[ ... ]
> @@ -291,7 +309,11 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned =
long addr,
>  		return 0;
> =20
>  	dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
> -	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
> +	ret =3D try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
> +	if (ret)
> +		return ret;
> +
> +	list_del(&dst->lru);
> =20
>  	return 0;
>  }

[Severity: Medium]
Can a partial failure in vmemmap_restore_pte() skip the TLB flush for
PTEs that were already remapped?

Previously, __hugetlb_vmemmap_restore_folio() could only fail in
alloc_vmemmap_page_list() before modifying any PTEs.  Now,
try_update_vmemmap_pte() can fail after earlier vmemmap PTEs of the same
folio have been remapped to new writable pages.

When called from hugetlb_vmemmap_restore_folios(), VMEMMAP_DEFER_TLB_FLUSH
causes vmemmap_remap_range() to defer the flush to its caller, which only
flushes when at least one folio was fully restored:

mm/hugetlb_vmemmap.c:hugetlb_vmemmap_restore_folios() {
	...
		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
			ret =3D __hugetlb_vmemmap_restore_folio(h, folio, flags);
			if (ret)
				break;
			restored++;
		}
	...
	if (restored)
		flush_tlb_all();
}

If the first optimized folio fails midway through vmemmap_restore_pte(),
the loop breaks with restored =3D=3D 0 and skips flush_tlb_all(), leaving
stale TLB entries pointing to the old shared tail page for the already
remapped vmemmap PTEs when the partially restored folio is returned to
the hugetlb pool.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.2668=
189-1-jthoughton@google.com?part=3D4

