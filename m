Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F4B4C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8DB26B009D; Fri, 25 Sep 2026 15:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3EC16B009E; Fri, 25 Sep 2026 15:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BF96B009F; Fri, 25 Sep 2026 15:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73CDD6B009D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:38:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00E83140257
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:38:10 +0000 (UTC)
X-FDA: 85253295582.23.F40776B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 53FE518000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:38:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxbIi28P;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790365089;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LEsbhIDjBe66cbu0GZSdPhdvVGyJ9cnICBeyy6iWkk=;
	b=dLOeYGQ0ygh3l3mf8F6JybyjRiH/8SRCalEsXfttVmzTBW0erMOZ0RTkZWdiOJHEll73wN
	ivIEe+raGGWX/SSfAj9kZQvZgTkEAMY/zSNbo0/kdFINRjJdZ/+vWku4v06mWV8/8UB+Rc
	MgkUrKvGm89eNCvEpzcXPQ/HtKnRvXQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxbIi28P;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790365089;
	b=1Fv0s48ptNQvej00OUteGZDlq1ylFnB8xs0FVf42VXU8CnWWrkTBjif5HucX2emyGE1TLF
	Y9xWT0topyZFKWi5qZ6YMZ0MDAiFTudftyuJlsQ1XMAmeJDVooSORKFxbTzYT6Cf/Sinaa
	WfasmzO43UwEgIUHF/EiCHxb2exkRnI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 875BD43765;
	Fri, 25 Sep 2026 19:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F401F000FF;
	Fri, 25 Sep 2026 19:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790365088;
	bh=0LEsbhIDjBe66cbu0GZSdPhdvVGyJ9cnICBeyy6iWkk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DxbIi28P95AzIzpsaRJqifwhTdKpAAPYMwT4+wQMpyTkmjQuoUxKrj2UjvZ1CzDD5
	 2dz5GyyZf+UVrlZzUi7246Dh6pWzJ9W7Wngn2hPuK1aiFavZpjeydxRVuDNMIUxFq7
	 X17bAkTBN1fMC2PylaMk7Rvp4/A6m8r52ETGTJMC4t6XJXPofRdG3WdbI8bKjXZK7g
	 G1JU9ZU6xnROvYjqRsDVA3WL2Wh4bkp3mkF7Lz4mpmR+9iPkg7uMvQ8cnOVC11EsoI
	 5m7BmFWf1IT7ed9EuauM/1lhewkRONS0osKU8zKGAvl585hEth7Rs4equHnAMtEzz1
	 wUQlc7U9HlCJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] kbuild: Move gen_init_cpio and gen_initramfs.sh
 to scripts/
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuah Khan" <skhan@linuxfoundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Alexander Graf" <graf@amazon.com>, "Nicolas
 Schier" <nsc@kernel.org>, =?utf-8?b?VGhvbWFzIFdlacOfc2NodWg=?= <linux@weissschuh.net>, "Maximilian
 Huber" <maximilian.huber@tngtech.com>, "Nathan Chancellor" <nathan@kernel.org>, "Willy
 Tarreau" <w@1wt.eu>, "Randy Dunlap" <rdunlap@infradead.org>, "Luis
 Augenstein" <luis.augenstein@tngtech.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, "Askar
 Safin" <safinaskar@gmail.com>, linux-kbuild@vger.kernel.org,
 =?utf-8?b?VGhvbWFzIFdlacOfc2NodWg=?= <thomas.weissschuh@linutronix.de>
In-Reply-To: <20260925-move-gen_init_cpio-to-scripts-v3-2-99c493f76722@kernel.org>
References: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
 <20260925-move-gen_init_cpio-to-scripts-v3-2-99c493f76722@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 19:38:07 +0000
Message-Id: <20260925193807.70F401F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53FE518000C
X-Stat-Signature: aoxsjgdbce6az4qpmoyat3535zeyu45j
X-Rspam-User: 
X-HE-Tag: 1790365089-340094
X-HE-Meta: U2FsdGVkX185l6+pJCe0lAnwwPSkFVFwP/uhe//sU+5t0KiV2ZndHj9ujqWy1CFqpxQ0nsX8a80raWFkKj4urTI06rnEGcFezNu0sd/E76QYU5WpMet1nSMpyObUqhNQBHGUBp5wPOstz8xgDXsacHUgQ9b+qkRisxPLH30cv2hRg9FYtqmfy5ae4wCdopVyREMNn++rPuKPAr4KxdqhYzavKs6vYkcUTgz3HsIEZxr0yw6pk2vg/TV6BnZWDDQfHLO8/0Fb4ck6o3aD2PvEpYwWuyVsWM5LnLjAK45KdNyNz9qj9PYgNqrUNH0VjoFx0OF1HnVqLXf7EsGg6cqo8+0PUsA/zzcwUWCiH7eG/BUs1AdEVFrekLy76k2NB15xXcPiU8kNv1uWuFsfUUe68/XNMQLXiiwFT/9Tc3VUjpZpvR3FYuFx2VegxnsnIeZeBmUIvEin/SYOm4bKGhJdtGvDO3oFHlIj9ZlgG9OqJzMAuSG/0iemZKi2WSb68IyqZTFjYTqTh5qHHUMX+85ZvnQ9y0CTIoUT1XSfF/vjc7H3O9A9OgCnQGA/BkDti0hdGNtIjAzoI2wHv2Z6JT9bxBH3AwzQDqua0lpxjWsilSwkLEGdnHSUOAwi2CryK9U4xwTX8GNQDH2HW/iCNOPx493sUunTCGdQudeFCOP2U1EsWBxiQ62NpOCIiDv/p5EKHLBGH5RFpM80EGIEabNhApWDwB/xa6fSg+Zc2HOM5FendrFEqFRcI+PKZL2rddIA0S0BCN6/tqM4hW2QrA6U/qKmq1T8Td1a5mbDCIuY6nZyPStzlvA0c5n5Q3RGYoXa1dzaL1q+h2eGFELVq9poZD77El45XKHfTnJOG8tBB5+5G2Ct6NJos+nD23JO3E0+/90qob01KRgZYnOnOp4gbQQtUoR/lMb3AaJ91r4xtMjHjtH6ZhR42TM/m6kNj/8acJejRBPhzFELpWUuX6z
 hfVGnB4k
 u3weWqgONeG/ouxis+nDB9CTxKsA1dSdIc7zEMrfFsDehhb7TTGAsio1vXHSPILW9sWKxxV2BoOkHj9uuG/qfc2YNI6yA/uMfiwFZYRhAfuzeA/0xfhaPc0YpkSz1ujPATCmNruEx9nH3K9PYGtxyCfNQvmLj36lsGGCBeE8rLY5uneSNyIWYIA8DdRy79QPrPAXxkPVugJEg2Pk5njcdf//gOUwSEA0Imbm5hwy9r8355+UiE65WEqG/vz6VRUsCAzvgUcq6w5aCxJlpWzTMFPkQ94CVueLO9nhhpqDKmudXi1HyN3wePvqDJrJWyZCIhtqsb0FcdU7sDJTRDwVu000ADs+F727SGxXquok0tiDMH6RH0lw+gHNu4O274sY4G+VEAsvicAhbsMxaYB2kLrTyui1MB1aZUh8reCjL7H07B8kkypLBFU8eLs7+e1f1lNKhkeHrv/5YatLetu3TcmBngsJlH4DNOw3a9zNj2/OTr0lADe/NO5XM+cSxYS6Y3tmoDLk0VVlSbsMEfKg8DkJaBXeyuQ9wQp7WXxD7p+51wfNf87cTVMdDCRqE60JP5BxoymLuYyXA+ENQGlVAo9JvwMdk6/hglKhomnxxS/wvnNLoSTMGFa6ZB8BLlrWmYvizjizDQaHri8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] selftests/liveupdate: vmtest.sh mkinitrd fails due to missing ge=
n_init_cpio
- [Low] kbuild: stale comment in gen_initramfs.sh assumes old usr/ location
--

commit 97c7fb8e47f1b247f157846cfecd29ff5f239ed1
Author: Nicolas Schier <nsc@kernel.org>

kbuild: Move gen_init_cpio and gen_initramfs.sh to scripts/

gen_init_cpio and gen_initramfs.sh are part of kbuild and required for
all kernel builds w/ CONFIG_BLK_DEV_INITRD.  Move both to scripts/ to be
more clear about their importance.

Link: https://lore.kernel.org/all/aSdrCFkUQup3qb-q@derry.ads.avm.de/

> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selfte=
sts/kho/vmtest.sh
> index 0014bd76e88de..1e86ffcc3a79e 100755
> --- a/tools/testing/selftests/kho/vmtest.sh
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -100,7 +100,7 @@ file /init $tmp_dir/init 0755 0 0
>  file /kernel $kernel 0644 0 0
>  EOF
> =20
> -	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
> +	"$build_dir/scripts/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
>  }

[Severity: Medium]
The path for the kho selftest was updated, but it looks like=20
tools/testing/selftests/liveupdate/vmtest.sh also still calls the old path.

For example, in its mkinitrd():

	# Generate inner_initrd.cpio
	"$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list_inner" > "$worksp=
ace_dir/inner_initrd.cpio"

and again later in the same function:

	# Generate the final initrd
	"$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list" > "$initrd"

Since this patch ensures the old artifact is removed via
scripts/remove-stale-files, will the liveupdate selftest unconditionally
fail because it cannot find gen_init_cpio?=20

Should liveupdate/vmtest.sh be updated to use scripts/gen_init_cpio as well?

> diff --git a/usr/gen_initramfs.sh b/scripts/gen_initramfs.sh
> similarity index 99%
> rename from usr/gen_initramfs.sh
> rename to scripts/gen_initramfs.sh
> index 7eba2fddf0ef2..27ac1fd48001a 100755
> --- a/usr/gen_initramfs.sh
> +++ b/scripts/gen_initramfs.sh
> @@ -247,4 +247,4 @@ done
> =20
>  # If output_file is set we will generate cpio archive
>  # we are careful to delete tmp files
> -usr/gen_init_cpio $output $timestamp $cpio_list
> +scripts/gen_init_cpio $output $timestamp $cpio_list

[Severity: Low]
Is the script header comment now out of date?

At the top of the renamed scripts/gen_initramfs.sh it still states:

# Generate a cpio packed initramfs. It uses gen_init_cpio to generate
# the cpio archive.
# This script assumes that gen_init_cpio is located in usr/ directory

Should this comment be updated to reflect the new scripts/ location?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925-move-gen_i=
nit_cpio-to-scripts-v3-1-99c493f76722@kernel.org?part=3D2

