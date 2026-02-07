Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B85EE0AE7
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 17:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DA66B0092; Sat,  7 Feb 2026 12:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7856B0093; Sat,  7 Feb 2026 12:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA3B6B0096; Sat,  7 Feb 2026 12:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D79C6B0092
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:21:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 518B8B97CA
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:21:37 +0000 (UTC)
X-FDA: 84418327434.12.0C5E00F
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3F5C14000A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:21:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dN9hRZbl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770484895; a=rsa-sha256;
	cv=pass;
	b=MaUyrG4r8qa7fx+trivissv6DvwqhHYZGRNRo+eifnnwIYOIApzFa0wLeDEjzHMFz46L5Z
	oq9NkMG81PrYtXwGiqu58Ye8Sb3jlPSZadEnuxffPJEiW1cBKdueyqznklrH8kmS32BlO2
	Wvj903nJdaF3Sx1wo13gxQ32fdWHa9Y=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dN9hRZbl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770484895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sx4rS67cG4S34nhsdmgDxAmcYKec2kH63rww2byzFQc=;
	b=PfXy1R9xAxOr2YK3HM/BBZ1DF7cAKECMNKhBiwP1QArpv46B2yMIzQprOr2vTx9ySO3Pb/
	86tLTBhX6zdMG5rZyCZTEUQBJ2bXxSJ57QAwigW7BS/+EgDC3ac20gZIY78sz0cHmXXApB
	M5DlfcEquliq54/TpcJaI2j6Jh+790A=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so2119107a12.2
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 09:21:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770484894; cv=none;
        d=google.com; s=arc-20240605;
        b=RrR4MzAQBDU6qIk1iys1ba759/GkMaCHgqyUBn04E+KzsAxZI50nnAvkiTokzij6SW
         z88RUfzi9ax0KXnn48JjUfoHdp/OvUgUExlcssPdtUMjMktZLoaP7hm5KoGJQwATboV9
         qdjVKuBLKWED5irDaNVkymaGGctMyd4P2UotLMLDWF98u8KAVE+HQJ9VeBzzB5e0oZYW
         dueeDvk+b/ZZ3hX9IoaR+mLcK+UtuNIMnHTlOMgynjJbXtxOk9jAcDdWzqqMnq6baSUR
         C4YWbZUaa2xa3G107XW4LvuRF8pVBjqJVs5X1sSh6MrXYaed6NMP3OOM+GwoVbKFtMV2
         iE5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sx4rS67cG4S34nhsdmgDxAmcYKec2kH63rww2byzFQc=;
        fh=4FUG3qt/39Ol2HTPQiMpPL/59odi1Wbcpl+iBqmNZ90=;
        b=BwLPnyKsp5mahUm/s1bFbqVmuRZglwV1Vz4CCg/iFSkbNJ65HciN6iJuLsZ2jeZ956
         2KUckKujNN9K+84KRu7OMfNUa09g2hzP1z4NcdcVxo8m3VHRsGypJTL0l0AqLSnGvJoA
         zYpKlGsWXmYU9KakY3519buzGJWLFIPVReFWANr+6x3e4aWJ1Gcz5tY/BIWJYm9WdzNO
         Ul80iL8s8/OSMba1Ertd1oAW30tpDaRaX/xk/eHGCp109O8aKg8sc6dbDoG6j1MRCz2R
         LUQchXFs6eHJ2PPuc+cxqtp/tdQrJUZZieZFmw7x8eYpOkqmn8UTI1wvMRSzld6BB3ru
         27Rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1770484894; x=1771089694; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sx4rS67cG4S34nhsdmgDxAmcYKec2kH63rww2byzFQc=;
        b=dN9hRZbl8ZHApCEPmARqAgYk9Dfxd7IUovN9hdxSPWnrBYwyD0X/N2CExhYa/Qptw1
         JtYIMh660qL2kJr2A5kCzJt/rizVg0/muCA214OhKB/RVbb+thxpzJ4j5t4mgjR+zIox
         4//U1wliMadAET0VMgjK3ZzNJNtzVyg9dg7r5BLdBudzVxLM0r3XiUO3aDpEnYt1nnsg
         q8zV39kY2TH92E4a82tzwnrEiueLGPXYpE4J7Px4VyFbifL1ZjU4bYQlQt7j3OW0j54/
         rX7XG7rdTf4i22FKjYrk4u7Qn7zmP71+rUyumM/H0arvQTG5DXp7VdetTOmqK1Z508H+
         rAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770484894; x=1771089694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sx4rS67cG4S34nhsdmgDxAmcYKec2kH63rww2byzFQc=;
        b=Hmt8fFoqOMojcO5okWUCwQ+YOeQX/vrvpWxVYvmCSURUvny3jCJSp1rjjN89zW7LRH
         u6JHaslZwaOecLGEV9IQ9kGH26NCOPRLJcIgZCkceRcAe31MOgeGi8byHj6VzpYzxRh/
         U/3Y+yVdbatjY9jpbvuq7/Tfz16qGDFxGdb9ko8wLag/KDl++AcKtobpQl5bpNGaGSVa
         at4xUKWxRAS9E6dUod56acfqqL3Xs6bbeK3X5cTSIeGjVvJKeKPJg/j5XTF8zZupTmX4
         KBUqUZxE8Cy0M17iPkLEmMFZR3xN1ktL6QhGgJOXqSDMhJO73rehXUbCLYeCUtDy0qdT
         d40w==
X-Forwarded-Encrypted: i=1; AJvYcCXP1qoDJ3w+17rOklZTXQfiZzR8bf2qFwTkVwHQcT4R9TXrQTLQCP3T3UIOBWNIvbxCbh25CXrV+w==@kvack.org
X-Gm-Message-State: AOJu0YxzCMeMSHGD7YDRLuaIDgcNTWiMFDSncuIbIOOc/uVWVCk0mPZ2
	l06E9j2tQdrKxMKzRvqMaB+7vbJtpMbvX4W3Z3FXvEBl7yARDSP53HcYQX9kOp+dXhK0Hph7eo/
	RaizFPPgC+HedXg+yU9cVnr/3uXuTRu8HJAPivcQ8cQ==
X-Gm-Gg: AZuq6aJe0khtzF+2xjQhdKUjLYn/Lh84N9jnVK5bPyfzwr4OhCNHPe6SQPZUNj1652S
	XpXvIv7XYJR0MDUwiz2xb4DO+T5+HNeheIZuVMbRtNXKuAX6xgrSxD5w5k80wu07/1uTUA8p33o
	0quIv3BwTq2jDsVBmiXRFATjRigx8sp2Xqtilk6DhYWo0Lm4AAdHvECsrFzBR9HPsGo5Y331YZz
	MyMAO+RoWdIEI+VC2vEHQFl7V1/PPKARCrXM5/nmHnnHiI2NX6fs6Wrfh/7W56UJm8QmBJRPYyB
	q1eZB4iO8ol5dBKzwLG9XAdGI8I=
X-Received: by 2002:a05:6402:2341:b0:64b:ea6b:a884 with SMTP id
 4fb4d7f45d1cf-65984182adbmr3191869a12.17.1770484893645; Sat, 07 Feb 2026
 09:21:33 -0800 (PST)
MIME-Version: 1.0
References: <20260206021428.3386442-1-jasonmiu@google.com> <20260206021428.3386442-2-jasonmiu@google.com>
In-Reply-To: <20260206021428.3386442-2-jasonmiu@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 7 Feb 2026 12:20:57 -0500
X-Gm-Features: AZwV_Qgs2lvBObdzqTBWi1sPRFrPgIC4WFHX-PUrTDnWrxF9xyUyzN7LEui9kbQ
Message-ID: <CA+CK2bD5n_fB0+--QURJgw0OKJUuCuS1zoRY==1rVjXtVC1aGg@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] kho: Adopt radix tree for preserved memory tracking
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3F5C14000A
X-Stat-Signature: ferfk1dkjwnu5m4bh17u4wqox9yorsqh
X-HE-Tag: 1770484895-773168
X-HE-Meta: U2FsdGVkX18hqXBypNxPy9DgQuI5wWKihGJtXHTwYxKL3NG4VyfucAjCG6ZlV8jQUDEdq4DE1NM+ZL+9vEd4keeWGN1cGZwmmk3WHsE5u0iT3DEIEkvaJ0PkFutrHqwh7qpAe+hM5b6XuoYg3J91vyIOSThoF7JNFKguJbgBcQNl5AQhVz0Dt89yRyDQuv/fpNGdy6Fkgx4AX2Chwdp3KQ0qxH3/lFRAkwjysbI6Y49v8jzIp35YEUqV4vo8nMrEAqarIMFE459u9oyZc13Z5xe0ZE4BKjwUds5Z3l/jHpunHK9wPx12M8XFB1GBoqyij+7xErg1hm9MUjHrdtLEaHS6fDejFJW7Jq5Tz/tR9brH6mbxvp9kW1qVaYEcI8KMgaIUNLUDr7dv3kOhLn/VMcMYWnJ3HnoaE5Tsnnh9u170f2hgKnCN2E7HdlcrgKFx1bAJV3JGqW6/LhJNSbMu+OX7mOnDOnZHuM7RwsmGKsMZP48Vc+hRHbViHoRQxPR8nsvXL6GfD4vrhcWl5bQ6MN3R15nLDLdt3biu6WNQDb/NAAwA8rt7wp0Gy7PMD6ZosIO6fe6iSTVzAEGyZilfb2vV7QHwTlrNJxcXEZmKHsmhA3DAHFXZBhRqarO8ubmabyQPjXR+V+FMW4vsxkDlS70GmRLpn4WT3lS/9YupdiC+nmgBc0jEOJs6uGgHo92OgLv8fKEg+p7cf9hxRodf3qQCYoHmIDzx5wpDZm2UJi5Yiu9swoqzHrZ4ZQlhcRgoca8ehDqkn3kKaS/ODgHdA/hXztKE34pKwMSrEOiOT+J4RBU5436V62T25HKToLy96vyyL1TjWTXeDd8ylWDzMuFQXhNKcy09B81Q1vsCTMBNJx+W/I6t21fktZkh8jOEyGpah3NTS24xrONpyOc4/ojhJZCBkEacD8+XlOLF+VuVcNtBZp70gmhSMQUWRE/AIEzYbTXJBr/zIrr/sME
 9zyBRKuu
 V9oirXc8gm4OS9tW6wThwZG8TjqKxaHHjhTb8B4bWCW+8FnbulGDQV/1ca1Gz00KMPZD0ktFVwxrKCrrnyOcNnhpCL71eogxcL167++n8grGYRE7SkNgxAeQDsMngHixGkK5AyZDuyuLB59OaSq50/LH5OeJdkoOWtT82xBbofMB6eJ4yrWPTHcnf9JSJlvck+S0WpfLR3J78VO/L9/wmj8h8eXvoo9x1IGM03gQlS6HfvOv7YHJ8E9t8oBFXVIBrNFgAx1WohsvQmvNl/F2327bF+IWBdtfbT4IYr2ALMfDA2RySWD2oTxQhXO7gAmRio9uJOuVinPBhOoEQ5/AAVT3fcY3vNblIMxdhkH4yt45ot8J4YT6Bp05ThlI/HsqBu98Jh9Zkxk6yyxt3E8WogR0+rA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 9:14=E2=80=AFPM Jason Miu <jasonmiu@google.com> wrot=
e:
>
> Introduce a radix tree implementation for tracking preserved memory
> pages and switch the KHO memory tracking mechanism to use it. This
> lays the groundwork for a stateless KHO implementation that eliminates
> the need for serialization and the associated "finalize" state.
>
> This patch introduces the core radix tree data structures and
> constants to the KHO ABI. It adds the radix tree node and leaf
> structures, along with documentation for the radix tree key encoding
> scheme that combines a page's physical address and order.
>
> To support broader use by other kernel subsystems, such as hugetlb
> preservation, the core radix tree manipulation functions are exported
> as a public API.
>
> The xarray-based memory tracking is replaced with this new radix tree
> implementation. The core KHO preservation and unpreservation functions
> are wired up to use the radix tree helpers. On boot, the second kernel
> restores the preserved memory map by walking the radix tree whose root
> physical address is passed via the FDT.
>
> The ABI `compatible` version is bumped to "kho-v2" to reflect the
> structural changes in the preserved memory map and sub-FDT property
> names. This includes renaming "fdt" to "preserved-data" to better
> reflect that preserved state may use formats other than FDT.
>
> Signed-off-by: Jason Miu <jasonmiu@google.com>
> ---
>  Documentation/core-api/kho/abi.rst     |   6 +
>  Documentation/core-api/kho/index.rst   |  12 +
>  include/linux/kho/abi/kexec_handover.h | 144 +++++-
>  include/linux/kho_radix_tree.h         |  70 +++
>  kernel/liveupdate/kexec_handover.c     | 651 +++++++++++++------------
>  5 files changed, 561 insertions(+), 322 deletions(-)
>  create mode 100644 include/linux/kho_radix_tree.h

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thanks,
Pasha

