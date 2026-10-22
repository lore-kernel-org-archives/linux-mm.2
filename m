Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923D9606A324
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KG/ahhDT
Received: by kanga.kvack.org (Postfix)
	id 8BB906B0970; Thu, 22 Oct 2026 11:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892D26B0971; Thu, 22 Oct 2026 11:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8F36B0972; Thu, 22 Oct 2026 11:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61E9B6B0970
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:26:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2416A716A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:26:25 +0000 (UTC)
X-FDA: 85350638730.15.1C7844E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66425100002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:26:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KG/ahhDT";
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792682784;
	b=qAPQo9UWxDhEYZEVRv8TPn8QwPIbJ2D5liVJMNcoDViTqQho/9cBsf3IvWqxAo9GtTkNZQ
	Fu9Cvnc6A4guIhWn00OsvqA9wjjKZZ5ynIEO2tDaInxclNGPJqhbyzt1FWMcXY/dDewYt9
	9N/Dxq/7W3MfH2YzCzuAgQWmQ3ebuxM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KG/ahhDT";
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792682784;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShNiCMk8Kuf8pc2qB+tQRe+Fq75YJp+jO77Paj5vAT8=;
	b=p4GUj/XjAvhu/zxD99n38G6YmlZ5qipvuBCXuJll+ZuQa5TppymJZccNmFRzzJnFLqFLvP
	bqfmMQfGx+Y5Ry0RUwj8vgXDdvos0EDq/zd9C6Sc6jBPOoYzhcgPXxNXUgKKx8dnO07jok
	SPSoMrEyMdtUMOnDdf+LsE5TL+Czd44=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E96D62CC2;
	Thu, 22 Oct 2026 15:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB2E1F01828;
	Thu, 22 Oct 2026 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682782;
	bh=ShNiCMk8Kuf8pc2qB+tQRe+Fq75YJp+jO77Paj5vAT8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KG/ahhDTlLfdPHHLRIXec/17R576tWHUPWqYwwZtqRAkH9gmk96VkUbys9bFRitIz
	 hb+W/lY6cQNa2FAKkCQTHppIq0ErCF6chSi8acEObQHS8drrpFbsvrr0T8tmBToh6l
	 +6faJfTY035e2rxW5JZGK+e0/5k1yYr3wObGkLqjPPQPcWqcinYVLyGsnLA624OYnr
	 xvnoPipWUv+m2tGCZEG/J6jzXmcUwmnfL6sTfoRDtoQZvnvXtOHUdTDK9qviFpTFRs
	 FHsqYRElnShhy52IA7WsxqAWEsy/e4NP2E7YRUuUloiPNvuaeXIbrk5q1G8UZOXbbi
	 lyuq0A5swftPg==
Message-ID: <sashiko-outbox-181698@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature
 header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, joro@8bytes.org, "Mike
 Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, "David
 Matlack" <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Alexander Graf" <graf@amazon.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, baolu.lu@linux.intel.com
Cc: sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org
In-Reply-To: <20261021152527.375070-5-tarunsahu@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-5-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:26:21 +0000
X-Stat-Signature: b8wdjjh6dghy8ofuzdx8gcbqof5trsqp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 66425100002
X-Rspam-User: 
X-HE-Tag: 1792682784-772428
X-HE-Meta: U2FsdGVkX1+WTT2D1a/BrrzbMFGyp4puBs1Kd1iUhJPd2hiYqLcn86OG0Sv6Ipkb80iJoFsKqksSI6jgq2mlvGx+p0D0AQK50P7LDjekO1d2aimsEavTlnodzRm0LLE7oflIgbzlZZ95MMbMecVnnuN5RitrpdfcXPknAgXY/BJquEa7Ckc0s5FzXLdCtUxXmaSywmM5tXa3NMjt6/qmiLM2Ka/iYddqf24Huyya08mGVnkDuG/onCzlg2pEnfkscqN8VvNnvqxntO5vJy/WL2lAPWjUygzK97x59K4lxOvhJF47WAMkgFIeH8L2yDMvxQTO7gysoW3sHKi7ILxpbgQLh9j+EAnCp15CWYlMBrpYVkKAb+FAmi50x3gxnacZUX9EQvyV6DWUUl1l63jbF52Jx1W/2ZRMN36XfidLj9bXBvwJUpXbSz9DoVE7c+z4YrJYy3gnbeihWctMj7VzSuPNtxmDUP+mogYZF3dWiZjXRub9ynHZBxr6x9kroPuwssJ++HN2WdPx3jkawxzUye82Nk85osuszIynMRyD8jFmmQ4jCzYTJtf/1/f3TRyxQb3aKOyxM9n+u3ykz5adArkCqmZS4ZVfmXoOYBu+odieNNtcrX40VOM5PUhhMJz8ONR3RF8LcTZNLmGbNgB7iYzzzPpc9DNoOc2WmhUDXDRTLoHqWtbcl61yc7Io/ZDTKB8NP/t3uAy/FbUR0jsdeAz7jeHiJHmD1lpq+g7EUF30HEUvaKlK5lsQU1cOt8BcA4TmwTz9xu3qxr1X2OWQ4vRb450zB95eTL/6Ej71RbvsQ/Jcdu2YK7PNxpdFONdpWttXzpOXbKvXhdCrwdY9Vn4F0q17o8wvlU6wcUCd+ahPaIFLNcpC3+j7kxw7fUNzG3MgV5ptIw/TATWNEmmYBptrTwnZ4BuTFDvy6cKlb6MzWCKcuOGkqFs3D3AzEnRmx2cSuzYufQbO4HhyKBw
 /lYUgj27
 YvHemJSyW2xNUseQLUDa+Lzd4GDUtDxihk6WxXoh6TTjgr3idSoQITynivuSsSnDVesPmcq2m1VZj3n/aZy1xnKnmTSYcxdcqCLjXgPCLDXrTBeZxRkfz9CLiedvO30ie6VSot6vWA8Qh+J+4Arf/7zDK/S3UyUlCW8/kdgogkbL/TLzjdfQWR3gOhQcDMVfqeocJmK0SfmZpvZTB8mgT2ZXzWVcnhD8CgjfcQ6RerHiuvbfb44EvOjI+UcxbXhIINd83BAawFWAm+8mfmvMx6wbeMIj3LtGzZbU9knvJ+oCPlEesRYLBkkkI76MvubuL12nKH9Qwbh62bP8iZURt1oPRHJEowfUKe5tA1GchguVb+vDGSyi5TFdrsgfvDhUOoXTQbRSaeHgAQ7Jvbl2cZsHaNFvIl12zWbiTUbeHv+ugyp2oDIWvX1pf1Y+fS5VpWyyiXlUs9VQ9MHdD58+IWPDa2hSp6o34Jy9BiF/3XU8QNRz+/rcvjQTeDCRraOlelGvh30TSiGoF+titqOXYuWX/kvM4Kn5cW/cIuUC/9RApCkgC7bi6ASllFMBpwb0WrdoSdCFXOUsl4zeuUyua/p4amuklpYxjGAiC4gLMm/kJ1xvKCweUgyCoRmZuKnZY9tUr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: memfd_luo: missing feature header validation in memfd_luo_fi=
nish()
--

commit b960724786ac11078fdfa9ded6bcd2355170cf0b
Author: Tarun Sahu <tarunsahu@google.com>

mm: memfd_luo: Add the 2-bit pair feature header

This commit embeds a 128-byte struct luo_feature_hdr at the start of struct
memfd_luo_ser and defines enum memfd_luo_feature with MEMFD_LUO_FEAT_CORE as
a required feature. It initializes the feature header during
memfd_luo_preserve() and validates it during memfd_luo_retrieve().

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 64f8b8cb75bdb..ea1f4c8cd2591 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c

[ ... ]

> @@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file=
_op_args *args)
>  	if (!ser)
>  		return -EINVAL;
> =20
> +	err =3D luo_feature_hdr_validate(&ser->features, memfd_luo_features);
> +	if (err) {
> +		pr_err("memfd_luo_ser feature header validation failed (size=3D%llu, f=
lags[0]=3D%#llx): %pe\n",
> +		       ser->features.size, ser->features.flags[0],
> +		       ERR_PTR(err));
> +		goto free_ser;
> +	}
> +
>  	/* Make sure the file only has seals supported by this version. */
>  	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
>  		err =3D -EOPNOTSUPP;

[Severity: Medium]
Here in memfd_luo_retrieve(), ser->features is validated via
luo_feature_hdr_validate() before accessing any MEMFD_LUO_FEAT_CORE fields,
jumping directly to kho_restore_free(ser) on failure.

However, when a preserved memfd is not retrieved in the target kernel before
the session is finished or closed (for example via luo_session_release() ->
luo_session_finish_one() -> luo_file_finish() -> luo_file_finish_one() ->
memfd_luo_finish() with args->retrieve_status =3D=3D 0), memfd_luo_finish()
reads ser->nr_folios and ser->folios without validating ser->features first:

mm/memfd_luo.c:memfd_luo_finish() {
	if (args->retrieve_status)
		return;

	ser =3D phys_to_virt(args->serialized_data);
	if (!ser)
		return;

	if (ser->nr_folios) {
		folios_ser =3D kho_restore_vmalloc(&ser->folios);
		if (!folios_ser)
			goto out;

		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
		vfree(folios_ser);
	}

out:
	kho_restore_free(ser);
}

According to the ABI contract in include/linux/kho/abi/memfd.h, fields of a
LUO_FEAT_REQUIRED feature such as nr_folios and folios are only guaranteed
present once luo_feature_hdr_validate() succeeds.

Should memfd_luo_finish() also call luo_feature_hdr_validate(&ser->features,
memfd_luo_features) and skip to kho_restore_free(ser) if validation fails,
so it does not pass unvalidated MEMFD_LUO_FEAT_CORE fields to
kho_restore_vmalloc() and memfd_luo_discard_folios()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021152527.3750=
70-1-tarunsahu@google.com?part=3D4

