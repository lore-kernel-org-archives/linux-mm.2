Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C6660A260B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Y1cod5qf
Received: by kanga.kvack.org (Postfix)
	id C9ACC6B05B2; Tue, 10 Nov 2026 09:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71506B05B4; Tue, 10 Nov 2026 09:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B871D6B05B5; Tue, 10 Nov 2026 09:23:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F66F6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:23:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 256EA807A5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:23:58 +0000 (UTC)
X-FDA: 85419428556.21.B61A27A
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B30040004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:23:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y1cod5qf;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kh3fWHtVs9ElLDXrVfG1M2iBA/DoCWf9txtZMpxB3YI=;
	b=qNVgWaAEueJmx7TjFvDX5QUkm+sEYllUN4iiczYIq1GXsmjxTTEjE+w6ZBniuFqruRrKgW
	gVszPIiGIz7UTBx3movSwJh+/A8qI7P5OoMeDIfe6kt/NPZqy6/NfxTHHvTWNqoFfqKP5v
	UpbFlaSaEW5h67HOGbm1Ef+4m8YyECI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y1cod5qf;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320636;
	b=PZKTQZOYK80HDZ5Tlier0wjIza4r+jY7CnqZnRyAqjL4KQZ69tMkjMvAG1MPgM+0AL6Qoc
	5FVNNypf2b80MpR5UDez+med/xEhHEQiTaTW9NZgPIH6/zAbXJnYfCssd0E20O5KO0rjvF
	S4joVIjm74bG404CWXma+w2PpMuGVwA=
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-998d151f441so519707241.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794320635; x=1794925435; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Kh3fWHtVs9ElLDXrVfG1M2iBA/DoCWf9txtZMpxB3YI=;
        b=Y1cod5qfbLnf45c0QKRuZybRwmPERTDJYMhO2i8aWVcONtNrF19z9HWJmHYa37GjWp
         gA4M2dhzgCTZmr+rDQc4Fz8d+7dcbWsGx89Eu4ssIL0HPB9vI+7hjGWBDGv/3n9+xKb1
         2+7NDZGZ3SsBi9y6DUXLVXCrKgEwVWIX6ZPqxeZRkPe2QAAwJWJHM+SkJ5Bv3/SKD2Qi
         qwM7dyutR3zPJYOu9kUGVg2/NqGbuzJfnhJvBgy0vuB4PenJWuzgSxpKAyVZq+aeZkWT
         vWTQNF1G0r2hCDuCkKDcTJufZ9J5iheDSd2YfeK82z+F7xH+uQMBw6e/st+yE80K/1Ii
         EKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320635; x=1794925435;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kh3fWHtVs9ElLDXrVfG1M2iBA/DoCWf9txtZMpxB3YI=;
        b=ZpM5lySIcW6RzF7HTB3M6gSESph78FVSqBV6j9zoKW5OecSSjBznn1Ye9CkReDzyLa
         gLk4RAvbYgSopp2ZtaeFcWJCEf3Mj6YYFNatGovdMnqgBvAnDjFOzxvyaUWHF+0dRIE/
         u/kaYnAvGLJIawKg27n2HajtOYYHPTMB+VBrMEW/aICTOQmN2mmsstSYG21G8DpmENEU
         WvCJd3+AyHVEkRd+j9//IXJtCrC+l7eFevFQhRSq28HC/EnzfhKI5iVNJqfGN1xJajQI
         OStYMBAi9uu1/zY8Yr7gMxUG7fnDDh4tDGRbdXU0+igHWKWuia1sOv1ygKZNETXOji8+
         hXzA==
X-Forwarded-Encrypted: i=1; AL+hErHpZS1B901wNixdmczyZ8OhgvHtAz/wvZaTCaPd23YT0GJ/v2qHDmQDwscoChZAZq31unQHfYr2kA==@kvack.org
X-Gm-Message-State: APuU4Z85tfYDRvVIcOM34MpzgzMB4IzMXnSP5GTTYpDkpprlVpn094jG
	p6XoGm3jLKHrgrTyLbrwsRNjpT6E8wuziaZ/2FuE5fQm+QdrO2qo/sM01vWqUjmW07w=
X-Gm-Gg: AYBFou2MLuNJOidrrR+ArJaXRl7Uep3w1q3YjqeLl1gwRj15Me9QMZfIBZumlzANQTW
	HNhdE5/HDZRgcUYwujsH/Y8qFTD5fYsWW3Yy8StSrgZbPdGr8aUlCUi5TAq1bxMIaM2HitQDypY
	O6DbjtiCuhbW1uMC/XyiwCGrGbqoSVRp2ppPkZhqNOLfKrBBEitGUc+v4D6w2eK0dtnJ5x6T427
	+0HgkGruT8IdjU7rAN0aUEPmEISBYThTtnLNDw9kJHCc5j9/XK1riajHt3AQEEg2/VKfLWPT5VN
	T2z/GaL5ayZNscQmQOYGmQY6Mufgqunl7yGlQhPa9FS80n2YhpiYR7t9LSy+D3zEkKW+BCP2eld
	JvohcJbMSMOPRqp+v/6xVpAIj9OE/UpRTzlgNnpXQlGJJM1rlKhkZXIbIbeZSao+qhXjKs27i3/
	8YiUIWBVgMBkwp4oMlJs3mQIsuupyFblEneSRTzWfGVVw+YGhZ8Zx8hWis49Tl02/un1ZKb5Zt0
	8LSRCmp7p+2dTMmksS4+XJyCNZIxkxqJl8VM/Ep7YYga/Ho8yb9fqEEyFdnmN4kzT8Zmb2ZBD0+
	hU4UND1wobj+M5nCPKlB92PQCPw9VbkTg8IF68ElOp+N5+qgXvcuppw/Whtti7pqQMr6GXnjb7Q
	RaWSLqGpZJh+RwuIcd73xJt3aNpfT7WURTFYwQBuyN0h1eqk=
X-Received: by 2002:a05:6102:6050:b0:7cc:2cef:b341 with SMTP id ada2fe7eead31-7d301ac2767mr622566137.4.1794320634935;
        Tue, 10 Nov 2026 06:23:54 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c200838f0sm1837111241.9.2026.11.10.06.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:23:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, 
 will@kernel.org, David Matlack <dmatlack@google.com>, 
 Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, 
 loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, 
 baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>, 
 oupton@kernel.org, alex@shazbot.org, gle.com@google.com, 
 pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
 kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev, 
 linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>, 
 kexec@lists.infradead.org, kvm@vger.kernel.org, iommu@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, skhawaja@google.com, sagis@google.com, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261110050202.529473-4-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-4-tarunsahu@google.com>
Date: Tue, 10 Nov 2026 09:23:48 -0500
Message-Id: <179432062803.2329176.7220119921541924936.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7477;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=3MeQeXkemHu+Wr0/oMRB7Xn+2Je8r4E7OMIYcRodeqI=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8yj5YKX9YmXwBRUiJpQxd2lEuERo2IgfqwM0l
 IVRH3L/L9qJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavMo+QAKCRC7dyhM23N6
 3qK5D/9g7VLq2y8fSOMG0PAMp3BX67/XRkPN7ey3PFRx5aKMUM07RMgQmzWBgUvl2Q6gNiQzkn6
 PzGX64l/U3Obis7LYoXZVjFyU/Y1E3VsLm3pidkNnIIr4W6pd8fWOLQ1uNuf7+Y+ZNq3oJq7nS1
 4k2nRqLY7pzJAH9m8n6ub9XYCpLh3WeltCRtRINtCyceucFzMTRCUUdV2RUap7fL6Wumu3QX5eS
 8i1d0l/SPxERlsryDD5cCykkv2QXhHkfilL/BhVrMdy39RdMo4gj/FfTT94+11QgULuudAtccqO
 U5L/QQpjwNg9nTNZkz1PQTXGK0J2aU/renYZpknMh5BplqfPCYnmTetLfrBpsDzfgey8RLF8V/Y
 Eoh+ESh7BADOSLIg69tXGp+wnSKKHwkjEOC7OQCOwY9QDGPzUzCgkpdGdmzDoNKre2SpcvdIZAR
 CcygD2hatCPKtp7iIAcav0qx3mKfHiW2V//Tu09m5IEQ7l7pd0mWhE4svcffc3miVXPGWhYrqmd
 PVunIgq+xYFl+QWB7LvoZyaTxHcY3mbTkzsfJUXKDzZ/cqAhA8jR6w9agPlhIgaeGMrDR2m2MQg
 C6Ovc0HMEbvS0tj7Rg3+WW5boGrxb4k26c6jkEz95OlytA/VPaKEpi+/upamWNVJg+P9KkVBlDM
 /j4Qa87px1Kor9Q==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1B30040004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: b6dsiozufaj74hresipy7zs31wgoo9u4
X-HE-Tag: 1794320635-140587
X-HE-Meta: U2FsdGVkX1+bIjRJKBwwYgthMGOk1AwlBvUDxpM+mWi8L+W3QDRyX9fS/Byj9Wn9/OQns8Yka6ABA13xb61/9GSf8tbu8KEETDX6ya1RdARJDQXcxlBc2Cy4JJK2jLp38D9H9roWX0Wn8wlkF7ssea622Zo8EQCiXP/2xQrMPRzXqnmHIS9gszY9tmHPYkw6/+YE0qoc7xUWrV3TSz3Dz+8UFr+QLvlMcbDIHGjscZXk2cU45lQ25rOgtb1T1PHntn3PK6o3+ZpKmI8krqPVZGrah62gZykr8yZR+cm8fSdIRD1JUXuOyHgATrGiEfbIKUsWHm4QtSA7/wWE2j2JtuH1sF5FqnwNiu1UQ/la/VdE6S18RgGQRwE45Lown3rMm9sw6iLmoKuczveOtUtw0nF24Ei2UaFJcPPgUJr9/x2x2BUbxsaKdjcNgC9MoEis42gWOoNuPsDlewWQ7xbxZDaiQYe44Bu1CfzQ7YNN/SktD0He//j12GiB+3hWkZXmKMaXBbkTV9ndQiIiEDuc4vlGZHVZCBn3yVQaJmOWgN/H0FZci3fm5lqeAaDwi8M7fYpcigpVyYkTFXd4XuHp+jHIG/8jfiW+qCe+TXLnQRBZ5fJgPRzuDjeNDNX3I5FE+I+p2LTpSobYSUpRLxeQwRF4u9x3mYMjzUngomfx2EKtGH0XAkBdT+hl/ZFgk9YskwcxR/bCcU6zxsh5nR3TVhvwygmbG3tsmElMq5OnnqyRrMTC7vlW/0JyTqxxnmJ3pM2j5iph8SNmRO37k1R5R53BbKfTvU5AqnD/vPx/3JcF7g9+rVkHZWv9ozAOnefTHn6p2uIXg6aBvpKpnkP7RXkGIG7tdnhV7X2jWF4k/3AhE3jkSXEpWOHNK/VV5IwAI4BzRZiP9p7yHRSe7shNEiwX2rYaogfUSbSrPmuG0x/qfqZRkYp4YIMnqeLWK/m+zThq4H/+jSLO7+wKeBy
 Ttc/aBg9
 7LP3SC1rhGDbHXM0nSu3LqH93DyHfEeyALdxtREK4ZQgq7+BhfldCGeD3Ir1l/0Shu6R6acnmKNT1+qMAf15Htva8boMOrrwNTb2zwh8Fo774G+NqNrnOXxUZ5Xpcebx8IdPaFiMFr6fbygJrPiBBLhlde6aShl58FTFlsmXdm/AUe3RZ8ZKm2th1mb4CixLGdRYJzXYQ2EzaoiUH0LVe/D2r+tPZYTyqzpjcShQwCR/sLwhiLJOgH7cXlhYWYXa+KNNIYrAVn0yRpH7/2WF9C4YVBihSN3fcYm1A4/Zm5cyIcPA0AQEDoEdXvRfHtjAXmjXPoUwJUAlwc5mSMLCv30sSv0vNDnttRM6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Subsystems preserving vmalloc allocations currently embed struct
> kho_vmalloc directly by value in their serialized structures or device
> tree properties. For example, struct memfd_luo_ser embeds struct
> kho_vmalloc folios, and test_kho writes the structure directly into the
> folios_info FDT property.
> 
> Embedding struct kho_vmalloc directly couples the containing layout's
> field offsets and size to struct kho_vmalloc. Any modification to struct
> kho_vmalloc shifts subsequent fields in the containing structure and
> breaks the handover ABI across kexec.
> 
> Convert callers to hold a DECLARE_KHOSER_PTR pointer to struct
> kho_vmalloc instead of embedding it by value. In memfd_luo, allocate the
> main structure and struct kho_vmalloc in the same preserved folio, placing
> struct kho_vmalloc in the remaining 8-byte-aligned space, and bump the
> compatibility string to memfd-v3. In test_kho, place struct kho_vmalloc
> in the remaining space of the FDT folio, store the serialized pointer in
> the folios_info property, and bump the compatibility string to
> kho-test-v2.
> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 6f12f5037ea5..bee75a7006e8 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -11,6 +11,8 @@
>  #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
>  
>  #include <linux/bits.h>
> +#include <linux/build_bug.h>
> +#include <linux/kconfig.h>
>  #include <linux/log2.h>
>  #include <linux/math.h>
>  #include <linux/types.h>
> @@ -177,6 +179,10 @@ struct kho_vmalloc {
>  	unsigned short order;
>  };
>  
> +static_assert(sizeof(struct kho_vmalloc) == 16);
> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> +	      __alignof__(struct kho_vmalloc) == 8);
> +
>  /**
>   * DOC: KHO persistent memory tracker
>   *
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
> index 376a724a1d8c..7b49dd6d7e2a 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -81,7 +81,7 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>   *             to directly use them in the ABI.
>   * @flags:     Flags for the file. Unused flag bits must be set to 0.
>   * @nr_folios: Number of folios in the folios array.
> - * @folios:    KHO vmalloc descriptor pointing to the array of
> + * @folios:    Pointer to KHO vmalloc descriptor for the array of
>   *             struct memfd_luo_folio_ser.
>   */
>  struct memfd_luo_ser {
> @@ -90,14 +90,14 @@ struct memfd_luo_ser {
>  	u32 seals;
>  	u32 flags;
>  	u64 nr_folios;
> -	struct kho_vmalloc folios;
> +	DECLARE_KHOSER_PTR(folios, struct kho_vmalloc *);
>  };
>  
> -static_assert(sizeof(struct memfd_luo_ser) == 48);
> +static_assert(sizeof(struct memfd_luo_ser) == 40);
>  static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>  	      __alignof__(struct memfd_luo_ser) == 8);
>  
>  /* The compatibility string for memfd file handler */
> -#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
> +#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v3"
>  
>  #endif /* _LINUX_KHO_ABI_MEMFD_H */
> diff --git a/lib/test_kho.c b/lib/test_kho.c
> index aa6a0956bb8b..cd0f183ff68e 100644
> --- a/lib/test_kho.c
> +++ b/lib/test_kho.c
> @@ -25,7 +25,7 @@
>  
>  #define KHO_TEST_MAGIC	0x4b484f21	/* KHO! */
>  #define KHO_TEST_FDT	"kho_test"
> -#define KHO_TEST_COMPAT "kho-test-v1"
> +#define KHO_TEST_COMPAT "kho-test-v2"
>  
>  static long max_mem = (PAGE_SIZE << MAX_PAGE_ORDER) * 2;
>  module_param(max_mem, long, 0644);
> @@ -34,7 +34,7 @@ struct kho_test_state {
>  	unsigned int nr_folios;
>  	struct folio **folios;
>  	phys_addr_t *folios_info;
> -	struct kho_vmalloc folios_info_phys;
> +	DECLARE_KHOSER_PTR(folios_info_phys, struct kho_vmalloc *);
>  	int nr_folios_preserved;
>  	struct folio *fdt;
>  	__wsum csum;
> @@ -47,13 +47,13 @@ static void kho_test_unpreserve_data(struct kho_test_state *state)
>  	for (int i = 0; i < state->nr_folios_preserved; i++)
>  		kho_unpreserve_folio(state->folios[i]);
>  
> -	kho_unpreserve_vmalloc(&state->folios_info_phys);
> +	if (KHOSER_LOAD_PTR(state->folios_info_phys))
> +		kho_unpreserve_vmalloc(KHOSER_LOAD_PTR(state->folios_info_phys));
>  	vfree(state->folios_info);
>  }
>  
>  static int kho_test_preserve_data(struct kho_test_state *state)
>  {
> -	struct kho_vmalloc folios_info_phys;
>  	phys_addr_t *folios_info;
>  	int err;
>  
> @@ -61,11 +61,10 @@ static int kho_test_preserve_data(struct kho_test_state *state)
>  	if (!folios_info)
>  		return -ENOMEM;
>  
> -	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
> +	err = kho_preserve_vmalloc(folios_info, KHOSER_LOAD_PTR(state->folios_info_phys));
>  	if (err)
>  		goto err_free_info;
>  
> -	state->folios_info_phys = folios_info_phys;
>  	state->folios_info = folios_info;
>  
>  	for (int i = 0; i < state->nr_folios; i++) {
> @@ -123,14 +122,19 @@ static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
>  
>  static int kho_test_preserve(struct kho_test_state *state)
>  {
> -	ssize_t fdt_size;
> +	struct kho_vmalloc *folios_vmalloc;
> +	ssize_t fdt_size, alloc_size;
>  	int err;
>  
>  	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
> -	state->fdt = folio_alloc(GFP_KERNEL, get_order(fdt_size));
> +	alloc_size = fdt_size + sizeof(struct kho_vmalloc);
> +	state->fdt = folio_alloc(GFP_KERNEL, get_order(alloc_size));
>  	if (!state->fdt)
>  		return -ENOMEM;
>  
> +	folios_vmalloc = folio_address(state->fdt) + fdt_size;
> +	KHOSER_STORE_PTR(state->folios_info_phys, folios_vmalloc);
> +
>  	err = kho_preserve_folio(state->fdt);
>  	if (err)
>  		goto err_free_fdt;
> @@ -234,7 +238,8 @@ static int kho_test_save(void)
>  
>  static int kho_test_restore_data(const void *fdt, int node)
>  {
> -	const struct kho_vmalloc *folios_info_phys;
> +	const DECLARE_KHOSER_PTR(*folios_info_phys, struct kho_vmalloc *);
> +	const struct kho_vmalloc *folios_vmalloc;
>  	const unsigned int *nr_folios;
>  	phys_addr_t *folios_info;
>  	const __wsum *old_csum;
> @@ -255,7 +260,11 @@ static int kho_test_restore_data(const void *fdt, int node)
>  	if (!folios_info_phys || len != sizeof(*folios_info_phys))
>  		return -EINVAL;
>  
> -	folios_info = kho_restore_vmalloc(folios_info_phys);
> +	folios_vmalloc = KHOSER_LOAD_PTR(*folios_info_phys);
> +	if (!folios_vmalloc)
> +		return -EINVAL;
> +
> +	folios_info = kho_restore_vmalloc(folios_vmalloc);
>  	if (!folios_info)
>  		return -EINVAL;

Why do we need DECLARE_KHOSER_PTR() in test_kho.c at all?

DECLARE_KHOSER_PTR() makes sense in shared ABI structs like struct 
memfd_luo_ser where both kernels reference the same struct field and get 
type checking between KHOSER_STORE_PTR() and KHOSER_LOAD_PTR().

Here, struct kho_test_state is purely local to the saving kernel and the 
handover ABI is just the "folios_info" FDT property carrying a u64 
physical address. Having two unrelated DECLARE_KHOSER_PTR() declarations 
doesn't buy any cross-kernel type safety

Can we drop DECLARE_KHOSER_PTR() here, keep a plain pointer in struct 
kho_test_state, serialize a u64 phys addr into the "folios_info" FDT 
property, and read it back as const u64 * + phys_to_virt() like the rest 
of the KHO FDT code?

-- 
Pasha


