Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF60606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SPjTzj7v
Received: by kanga.kvack.org (Postfix)
	id 28EA76B05B4; Thu, 12 Nov 2026 13:16:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F906B05B5; Thu, 12 Nov 2026 13:16:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106A16B05B9; Thu, 12 Nov 2026 13:16:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDB0A6B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:16:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66589A07B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:32 +0000 (UTC)
X-FDA: 85427272224.21.11A9FFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C5DB71C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPjTzj7v;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUe1wz/CrWVNCtMb2GLITCPnYQzWbEilhJvzzVB389I=;
	b=ZbFVdUiAbL81TgA25hQ2eBgaJCxL3Fx9A2HQMFrAW9pz5K21n50CjQWytd5T3elYBxuqJz
	AKC8WqPXRFEiu443OR6c04qxd1EXzyhRiGgzLpPbhf4172ttwS2Qe1WJEJSbC0rlUDlWdw
	RY+bfOQkZKb9XleFUCtTmdnm0IbLH0I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507390;
	b=pJiOPPccV1NtAwFWLpb0qUW4RDDtnGQsgjH8Gm2qCs93Gy8ZsD4iRMnVsx/NeJqiMsLrQS
	hbsbzAWqo55Fw6HZnGuwYDWmYCaiI40BF/0t9iFUlVlRFO3wwn2gR21MN6vJUczX8WmC95
	tOAyzuLn9X7OF2K+hzzR8zUBKvzgNfE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SPjTzj7v;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 198B843E21;
	Thu, 12 Nov 2026 18:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BD01F000C4;
	Thu, 12 Nov 2026 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794507390;
	bh=vUe1wz/CrWVNCtMb2GLITCPnYQzWbEilhJvzzVB389I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SPjTzj7v/kqU3Fsx1i3FfE2xoVVCiONYTjZMWRhsYt+zYpMFY0KRT2q54lGo1RuXs
	 Sdg9BFiWzoxB2bMQnw1I9KiBLquli01z/QDD+zcIiX8t4Kj7K2A8vU5+UoMjYutXRs
	 7Rq+/TgqLorMPcLuS3hA4zFJcM6Ys5Dl5ZY78uKgpblAqnijQ7m747s6Imvu6wRG8Z
	 ZTOm7ydEuGTiTYLc/t87bSxp5RuyCnzYQcNPK8RDUFFn5ghuwolJkHYoECkcliptqg
	 OPevNr7YiewicmKkl5ygy3+VZSs067OqITSOu4TPuWlgN2BJ/ePjpXbqaQv6SuqLnA
	 gsebsm3S54vnw==
Message-ID: <sashiko-outbox-211679@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/13] mm/migrate_device: fix ksmd oops on a migrated
 KSM page
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "David
 Rientjes" <rientjes@google.com>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Nhat Pham" <nphamcs@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Usama Arif" <usama.arif@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, "Balbir Singh" <balbirs@nvidia.com>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Yu-cheng
 Yu" <yu-cheng.yu@intel.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dennis
 Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Peng
 Fan" <peng.fan@nxp.com>, "Josef Bacik" <jbacik@fb.com>, "Chris Mason" <mason@kernel.org>
Cc: linux-mm@kvack.org, =?utf-8?b?Qm9yaXNsYXYgUGV0a292IChBTUQp?= <bp@alien8.de>, "Mark
 Brown" <broonie@kernel.org>, =?utf-8?b?RGVubmlzIFpob3UgKEZhY2Vib29rKQ==?= <dennisszhou@gmail.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-8-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-8-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 18:16:28 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5DB71C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: owr644dibz1r1r3s4yh8hhnh5i6fpjq8
X-Rspam-User: 
X-HE-Tag: 1794507390-152095
X-HE-Meta: U2FsdGVkX19nRfTfxiaLkJJELnVgu2csssl8Wv94XBHRczgIDXdB6IG/iGonIN4AWHyKGgEDK6w2yWju1iCMAoFXgXFoRa2tKY4KiuBpSzxIEP0W3/7TxxaYYY5mTBAsubFyZG4RPBvWWCcsP+723gHjIpDFMkVDUVMspkrd2xXS2h3xvKkhRwIotTB6UPDZRUKiQ/vHqDa9vUFrENpdsNkBOxBhHIeejhFymkH7Z/jxUO2AjDX3S2YKMTxrJAfg0cT1Vz8fQwlD6RMzZdrn0T+KpYk0bngFZy2X4wzoReh1B34ot0cod+muwKVd+9u/DmiWdKDgioMGyxa9pp0FnttLd+/Y7flscjMAsGKgZe09SmniKnwRts1Cc+YWhAuw/KoRpFMC64D2iYny511YFjGPhe/y8qtFVEjLGO67n0VclAG742CeLohBhmb5JyCAvx5hsPooMLZC9OjcuyJAO4MDLI0Lxs+xAip7Jpgkhu2WJHSPiTDVuYj5EUpg04c235l/yu51TqrdwnXRn4ruK2IxzchncFtBsd9H2WevOfPp1ekbdNshOMCx2YWufq92XlomX4ifSaRhpWjmMk0v2XMAeynk8JIB6nWJYwOUXmsoSRn0/z7dDG13vA9BcBdS6UDDZZkf6a4GNIiMtA/NeTgHHEEVBLnDO2CV+qaVMKGPa5XEjU8byQshMSWx3T63IrL5CATRYDVjS3inOyE9trFZlAgphC5ZYRNnF9LJlnGLNhl7Rv8MVjFpwKUz4UQXPNzUWxmbNQBg257wV5UAhwl0wkxxxb4ByXgneMjFGk6rfVsxQvsqssoVwdzaQyD3xUBce+JaMa/9kTUslI3LOavUI0I04KPnOQHQd1POHeMg8oWqMVdBdV8g9TU2bhA5knmU115Bn86wSXF8+MeIt+5UpTqKI9pzLP9ND7uqX51imSNHOpLnmpSIMI/WXQ8xckDJIFpWhZtDWSUr3tG
 HdJtEoPo
 U8InrKt1L0iTgAMXNNwOXGaGsJZ4cfgAUpAweBi7TOnOETTrb/s3Mxb8ZFYE5rr86KErrvetS7kmRiXvpH7B8O2ZMCjbk3paVMrmMnVLCEXBPjbENtmDUo3wovMzGDiW8r4U5Ee4WfeXHEqGUFSEqtQD4Jg3p6Z88qyPOwJs6jngKOLJq4n9Nyl4d37ZV+OXsZ+kJR1+7FhcZi0XTqY3fI/5xA2WwGHZ7PnaHKo6R5wbaSIhCDzlkGlF4B/0/HDd5s1Z1lHNW1//GwXsaayRjKRdhsXj3qCWKZkYz+T4f1lK6KEul7yW//oRO/MZw+UnNcDCZ9xfgb2lVyH1sixfXJogldmihPMGOblpyQJ7UekmBcAgF5yAqwwhPHiT9v0aV3UzKJCiBoSVfF8JRdbUjcwPk874geC1iusJN0rvHJSwJP0OKS+1NwpEPJ6gJzdREH2BpYPBEx9OSkNnULfoXbIB3vDrhUbNJ6s/Haz1eSMHQ8t6QPHww435+7CQkWDsPf3AUQOLV5aY5JDRXtxZaMUEcJRk18ByWdqlC6SjxH5+zymEWKTvcxSohwb1sHrrSv0RPE206DgoPqDZ5AVBrWdXe40YBjYYYI4w87Vhs76O1Ta7amP4TmWOEt6289BpnPuf+zUpfw/UNVaUTGmR1JELN71q8+kZA2Trsh2r5m1YdUhjSUaa2OVnYMBLSH872kWVpn9ItUjruqB0CrU0D/dR9tLAeDZMDrKdteqniqNgN2MWP1bb/t5Fyrg==
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
- [High] mm/migrate_device: disallow migrating KSM folios to coherent
  device memory
--

commit 3977d2303c0d4387359f5f7af29357634f5745a7
Author: Chris Mason <mason@kernel.org>

mm/migrate_device: fix ksmd oops on a migrated KSM page

This commit disallows migrating KSM folios to device private memory in
__migrate_device_pages() so that ksmd does not access non-direct-mapped
device private pages.

> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 1784765188394..f5fb7f2d616a1 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1212,6 +1212,15 @@ static void __migrate_device_pages(unsigned long *=
src_pfns,
>  		}
> =20
> =20
> +		/*
> +		 * KSM doesn't know not to try to read device private pages, so
> +		 * disallow the combination.
> +		 */
> +		if (folio_is_device_private(newfolio) && folio_test_ksm(folio)) {
> +			src_pfns[i] &=3D ~MIGRATE_PFN_MIGRATE;
> +			goto next;
> +		}
> +
>  		if (folio_is_device_private(newfolio) ||
>  		    folio_is_device_coherent(newfolio)) {
>  			if (mapping) {

[Severity: High]
Should this check also disallow migrating KSM folios when
folio_is_device_coherent(newfolio) is true?

ksm_next_page_pmd_entry() skips all zone device folios:

mm/ksm.c:ksm_next_page_pmd_entry() {
    ...
		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
			continue;
    ...
}

When a KSM folio is migrated to coherent device memory, the next ksmd
scan skips its virtual address and unlinks its rmap_item from
stable_node->hlist while newfolio remains mapped as a KSM folio.  Later
migration back to system RAM replaces the PTE with a migration entry,
but remove_migration_ptes() -> rmap_walk_ksm() can no longer find the
VMA to restore the PTE, leaving a dangling migration entry that causes
the process to loop in page faults.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-mason-migr=
ate-et-al-fixes-v1-0-3d2454362e8d@kernel.org?part=3D8

