Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4283CC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16AF76B0088; Tue, 15 Sep 2026 09:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1429E6B008C; Tue, 15 Sep 2026 09:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080236B0092; Tue, 15 Sep 2026 09:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5AF36B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:24:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1FCE803E5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:24:25 +0000 (UTC)
X-FDA: 85216065690.17.973BCC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4421F4000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:24:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clJ0vaxp;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789478664;
	b=RNfvwIMJ9Y8V4tS3dMSXaqOy5htIiKIKAa3W/6+iiV89GqKjMvaKXOJSv+MKWE2HFl3xiV
	U2LJ+6P3zyaL9GO6bmtYf8RCdqHRcRGjZfJVXTafuMbSs1xSZLHf6AFfOCT1bADaLgX1JK
	4K5y8Ys3xK46bCNB7CFpXM4ywp4Xmoo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clJ0vaxp;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789478664;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kk0XHrASJtDcqcoYjyv1OoIDFhfagge458V6XsyOmPk=;
	b=xQQsjH+dPnowsZNIAKXx7lFJ5hoYumSrkzHojWikkR2Xbj9Q2kXxAY9G1aedk3s0sMSAVu
	bjnJT6Cza5gbyVkFhm3ASQx4DuElcDjcQOvk4BfDmPQiB16aX8f7w94s0trdCWKrC+calQ
	cI4RRZT2wz0wZx9Oc5tGbQzut5m0jQA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E22F7600D1;
	Tue, 15 Sep 2026 13:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5371F00899;
	Tue, 15 Sep 2026 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789478662;
	bh=kk0XHrASJtDcqcoYjyv1OoIDFhfagge458V6XsyOmPk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=clJ0vaxp3sZXKwdBpf8y7D4hViqM4nFJmYSCrnv83plK3mCCe1Vo5znC49uX5JNHp
	 6wrATjKzdnxnx3VpdI1iP7I6QMX7RQAwtLdtLnna1m+FdWYHgCtbX4LUcMSkd5rKqM
	 vku4yNaOwmyZlw88cwMp1mr/E5vrxzrwO6eqRPMKYdn976UFdvVX7nvi8OB3baQ9Re
	 9ovAl0QjkuXwklvSyFLaHZdl/yNn6+scd83y/4dwu22IQuhTLRWuPGPOPyQKH4CV5d
	 iJzdHcs7SQMO+Jwp3IPkfx1iVIY2Z5TlFHKYC20wxoA75OJUkwf5p786a7f7mYPXnh
	 5HlyU+wH7Cf9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/9] mm/memory-failure: efi: adopt the inherited
 poisoned-memory table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Breno Leitao" <leitao@debian.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, hannes@cmpxchg.or, "Ard
 Biesheuvel" <ardb@kernel.org>, shakeel.butt@linux.dev, "Borislav Petkov" <bp@alien8.de>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Thomas Gleixner" <tglx@kernel.org>, x86@kernel.org, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "H. Peter Anvin" <hpa@zytor.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>, kas@kernel.org, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Danilo Krummrich" <dakr@kernel.org>
Cc: linux-mm@kvack.org, linux-efi@vger.kernel.org, rmikey@meta.com, harry@kernel.org, riel@surriel.com, driver-core@lists.linux.dev, kernel-team@meta.com, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20260915-hwpoison-kho-v5-4-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-4-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:24:19 +0000
Message-Id: <20260915132420.7A5371F00899@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4421F4000C
X-Stat-Signature: 58d5eo3hmfgy3yccb7f4nb5p4wq6ci5u
X-Rspam-User: 
X-HE-Tag: 1789478664-605308
X-HE-Meta: U2FsdGVkX18tCtIwpUlp5qRj9QNds6euJrsgBu4zbNNaVrA2xsZQivRyUF+Mmrbulo3m34SLtbDkBv9DPV/SibUonrVIx1neuumZNqrM9ailK3yRRs/fz0GhZxBaTkuHwIhb3giiHSN7Az8wyJ15wBzuehXe0AY3l01vB6DZdO5rRpbFYbWryLINqZM5WNijvRXleLD0s6jKtFA5TlLcEAhuAJlBwpqYumpZeC/gozadlqHHFRuWZNqygkDNfktAF9usSFOMiU7AJ8RY8bNvur6aF7raCM+dHf0oMTr8lTx1yq7GwZwdqLUzTj31CySeaHbIXZqZc5SG6A+OtSAITlwLLborD7pcTYZ18O8q2Gq+sJ90HOKfoyZNbntqruSMlt9WUa6U6tyaoExuLgolEIwnM3yIW6d3G212SyNx5MDLq93A3hLj2Rix0f9H9/X/SuZpE7bo4sXdGc8Qe868xMuhrvZ0QEkZMV0MIdtCpa3ZWhuz8624BoIUnf6PipIUVCylgTfsybYyXNLWbWBdC2HkG2ou7S+3tF/cQXfYu7h6+9GyqK3I6t1zlz6XoY/wCO1LrXIa2sVD7h4R5c6MJfDUW+26UOZ3t8JWoXau911/K/45estAdo26EKr7cKI39Ibmj7/xfFWdA458xK/SuOL2d0FvlRRwPIIdHhuNx+zUATQIop3vDIRgh7gkaPEl33pva4gPiMrlbeAJ/ZioKY1yMKYVElqB2+rL6+wcsFe9KS6WNKJlXL+cN0YhQR1y9X+J1jspt4IXnh26zSBiXTbPlsHwk5qRhssRDGWoh/WS0FjWYY877s+oXTiY/uwimb1JiiJVrRqGVh78wPOHSH2GUbWiDRQtzZSnlhDFWNXWcXlrob8YKHfIvojzGhF/FoXmUyQVNOZ+xizJE9RohgB/bwSuiicA68rpwHduagRoi1XI2SJI89+zKPPP5yP4fEyTaPWQc0P91C6KnyL
 sXSDZZz3
 pdj98tDICx8Bp9hAo+cJOEoWod0G1zOXsf/iSvbvJvEbetHtxaP2iCfxMJXPeaF2+nrf6yNK8BPKC+DVgx3oCjzDmL1zA+U+8L4xjQ7DG4KY8fChwyrPpQh7eueeU88KgDJE/7kdT3FoRd+D8BjnhvumVzbz5KRhiztjr0GA2SkicSnhvIYmNyBCIrczxcIOMZcL2MxuXS9ndFGzjoRzLjRDiTB7dr9IJ6aT2CSR3b3BcNp57uTrdFqquuvPoDugV7dvWEPEKepCLxIBBp1aKe7GrxNN74doyw3qdM9g6xxymjdV97drWiAv6HO1fY0cVXJkzUyt1xkS9zdy0dsMbWxlQV2w37ux5G8I3RQ7PMM9Jn4IgmeuyoxxJlISk227f7wis9m8JCYtwCmPO5iVmW7w/sm5HwtyR57mJrmz1sj6azMGqEBUWwAVooEe/Y44qXyKVkQphZWyP3iSErNPhXk+/yGfJLA8VDY+AGbZe3Co1joUtqYzTeZb1BjTbgIya73FTEgUe2DT2zM9n/i2wmumX1VUjfEFPU1NjSPiy9aQ0Ta5hUrF6eDTB6WOL6kdvTcfkdd4xZKkv8+81J2YeBm0EheGJgiURoqdK7feeym67jBMN2TzRnmMGFpeAsG9cK4y469XmxaxbcICjrQcq9itK0IsBv8haqI5Qk/oXnfz1Ab8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] efi: ABI incompatibility in poisoned-memory table due to unsigned =
long
- [High] efi: ABI incompatibility in poisoned-memory table due to PAGE_SIZE=
 check
--

commit 213ea31d156bf79dbf85ad9fc8678fe09bddbde2
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: efi: adopt the inherited poisoned-memory table

This commit takes the inherited EFI poisoned-memory table into use by parsi=
ng
it in efi_config_parse_tables(). It validates the table header and hands its
pages to memblock so everything afterwards can reach it with phys_to_virt().

> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> new file mode 100644
> index 0000000000000..3f12db3dc9b84
> --- /dev/null
> +++ b/drivers/firmware/efi/poison.c
> @@ -0,0 +1,93 @@
[ ... ]
> +static bool __init
> +efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
> +{
> +	u64 nbits, end;
> +
> +	/* Whole words, and a bit count that can be taken without wrapping. */
> +	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
> +	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
> +		return false;

[Severity: High]
Does this validation logic break binary compatibility across different kern=
el
bitnesses by relying on unsigned long?

The ABI structure definition for linux_efi_poisoned_memory uses a
variable-width type for the bitmap (unsigned long bitmap[]) rather than a
fixed-width type like u64. If a 32-bit kernel (or 32-bit EFI environment)
creates the table with a size that is a multiple of 4 (but not 8) and
passes it via kexec to a 64-bit kernel, this validation will fail since
sizeof(unsigned long) is 8.

The 64-bit consumer kernel will reject the valid poisoned-memory table,
losing hardware memory poison information. Accessing the unpoisoned memory
subsequently triggers a Machine Check Exception (MCE), crashing the system.

> +
> +	/* And a footprint that can be page aligned without wrapping either. */
> +	if (check_add_overflow(efi.poisoned_memory, sizeof(*pm) + pm->size,
> +			       &end) || end > PHYS_ADDR_MAX - PAGE_SIZE)
> +		return false;
> +
> +	if (pm->unit_size < PAGE_SIZE || !is_power_of_2(pm->unit_size))
> +		return false;

[Severity: High]
Can this logic break kexec chains by tying the acceptance of an external ABI
table to the consumer's local compile-time PAGE_SIZE?

If a kernel configured with a smaller PAGE_SIZE (e.g., 4KB) sets
pm->unit_size to 4096 and kexecs into a kernel configured with a larger
PAGE_SIZE (e.g., 64KB), the new kernel evaluates 4096 < 65536 and entirely
rejects the table.

Discarding all hardware memory poison records can result in MCEs and system
crashes when the supposedly good memory is allocated and accessed. Should
the consumer instead accept the table and safely round up poisoned ranges to
its native page granularity?

> +
> +	return IS_ALIGNED(pm->phys_base, pm->unit_size);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D4

