Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8A9606BFFF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=RxqJZNWt
Received: by kanga.kvack.org (Postfix)
	id 2EB356B05DE; Tue, 10 Nov 2026 08:10:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CFF6B05E4; Tue, 10 Nov 2026 08:10:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B35C6B05E5; Tue, 10 Nov 2026 08:10:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E253E6B05DE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:10:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 800EA140839
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:10:37 +0000 (UTC)
X-FDA: 85419243714.13.F142B8A
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id A068E1C0011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:10:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RxqJZNWt;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794316235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQDfTOBLyQYKItk/7IbkqTdv3CPMUC9LzGhAb3DHHto=;
	b=i6GGtXlTNNP1owrgArsJm8UHNUIi9h/orcBr12IX0rbFY5Ru809B2r1Djdtx3IV95VjveZ
	2RgBCQmzjGCEmgREdMuLPJvGkbxQ/Up4UsaeD+o1kFB71cXAAbiNxsgrHUeoiHfHm/8GGr
	NEoHdRpKt1yAdwqm9qWjqXauF8YB1D0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RxqJZNWt;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794316235;
	b=LQtM2ik3iZhIESsjg3eqQ/BTu/uCwjxbpOVHc+JThuv+NdgBFqu3j2oKHrL85N+P2DeUyr
	R3C1oGXl8gOAl6gsbzhxz/0LxDKVxrEGd3g7WKP1/JWjeSEcyEGcPQB1kVnDYc8j/MkZax
	WoxlaCu696DiuHWVPE6q2iwsKR4xcnA=
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5e9528732b4so724482e0c.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794316235; x=1794921035; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XQDfTOBLyQYKItk/7IbkqTdv3CPMUC9LzGhAb3DHHto=;
        b=RxqJZNWtpFC3tb25F64WAX0CKwI06WbKAspBM5+zJ2J1UBnAFxfd6xc8fmeuu1zftT
         s4Ru6Zt/Fq6QyHTumIdvC7hWpKmjeZL+Q+TNWMvUXbjPngqhl1o2q7e8olwtxEaPoeA2
         qH9qEKkT3PjZCOHs/89myEydkElDGAg9jyaOXJSGRQCH59yODMlFpSfvm7sf5ukNHfsH
         8ShWEGsYa7iol3l72qkvNZgFs/wRDX+fZTVS70rew6Y76e51R9d1tEa6TZlOqw73gegj
         DqLj554hjXRpK2r4hp3SxrMD2v39enxLxEPuja87h78oKGJebLCyGVx5S/58+vcSRwef
         ugoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794316235; x=1794921035;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XQDfTOBLyQYKItk/7IbkqTdv3CPMUC9LzGhAb3DHHto=;
        b=FmXJ6rQQ27B2HeFgOx9SPxhcvBD9ER9pUI3+r8hDNBUnZA9USBlq3DK92/IfDem5ot
         5fNVAceQ0nZ17aBtMsNx8O9bqIdHyrpHMWbTjdlbv3H7TfGC3OCMXfXpHREsWuw2+BmW
         cI0xuGmfX4GQyKo27lBVi0tN5rQdhberTiVkvjsG19jaoMpsUL8NBNzNi8bl/F7/Y/YP
         ZbR7yZJuvkET2tQO8r/xscgCW/zeJn841RnlHfDNx8Czm4bnnTf2oQzHI8HO9D6bmqTk
         NzePMBy/bN25rZK1kN+e4v0WykjLfb3xQ4iZW/3rKINuqK9SaVEOd7J0L3nH4/iOnfdo
         H5zg==
X-Forwarded-Encrypted: i=1; AL+hErGqqWJ3K8CpodWrMP3p0jCPf4bD6GE/fMxsL1z3Yj49Fmafz9g6buvhcf3Egz1v81xTfaAa9h6tCg==@kvack.org
X-Gm-Message-State: APuU4Z/lhsLNbE6wNV8tyLwzKlUfj2lNZOicsKpfwADzYHijtbSlG9Ez
	vCIq1OowYLaw6xLyUSa2lwmrfKkBfepRL2rv8vPOTwNS4LExRvs0e+F35f4nfuisPgY=
X-Gm-Gg: AYBFou0D9BKnHcZRET7JBXSbOhOXASa0esPBtjocR/vykwNHlfMnp0QBpDJJXiRcGcJ
	Hk47MelSveJ5oi2kvDQPb1zJdQzp2F2dD4AX2z28C3EAF/JlBNfUTw9xlA6ec1mzP5c+Fq8mJ5g
	xp+0W+/VEBTCS99lvyPBLOLwUzMKoMg9Kd6TTFILKvj88c6DISkhdInDuxUd8hT0Cv4lPU+qIer
	na111TdtshTfYKC4gObRc9oheyBQ4vcJxmNIWH7GNVpQx7kIBvyJTaL9KniiyrEY0jIkyM38cOW
	jQik93i//IZ3AictREPewSnm0Wg0ajf+fJINn3e/C8v+bBVF+aluTB0bHzewajHZELG7kGcAIZV
	kl2usQhLrQ5rSNRZ32KjE97+98MBF+Go8pQnpoQR/4pVp/jKGUkefJl5/8Q+RXVe8w9vWW+54e5
	kT7C88i4IYt18wua5TLvMUAZMH73BHgnkDr2gu3n7qRE31kiLud0mEWYSt+NmUmFXsT+/ztDGXP
	pmgLK6chOIIAtvEFYThe/4mEC/fskYgYcnCdQOWEP4ci17nBNIOd9qGEgvV8LhPmRDbFykTcR5X
	nXW67CGAHRE/lv6/7GpQ5fhk1h5R2m+EcgiFr+fUskuSbwyGy2TZIvDxMyVzVSzQUvMpqLl71Hq
	SnL0tac1JB/bvUZUVJpaYkh5n6f+Xh8A=
X-Received: by 2002:a05:6122:222a:b0:5c7:fbb5:6ea0 with SMTP id 71dfb90a1353d-5ee0d068066mr932090e0c.4.1794316234604;
        Tue, 10 Nov 2026 05:10:34 -0800 (PST)
Received: from localhost (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c20081409sm1695863241.8.2026.11.10.05.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 05:10:33 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 08:10:32 -0500
Message-Id: <DMRK0PU0VCN3.15F59WLOQ05P4@soleen.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block
 header
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-3-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-3-tarunsahu@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A068E1C0011
X-Stat-Signature: yjhqoryb6qmxrgsjhhd9afgnjqmkjq8n
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794316235-199365
X-HE-Meta: U2FsdGVkX1/Y8GnxXWn0U4asLGejoQOwaXtNU2vEP065muWvqGXO6zGuexgHYt+Ahc5wAM4AvTTK7EPnel4MUjZ0ATdfcsrCFCBM60PEU6dg47x5SfebNczS+6fMf4Pj5qddDUDUag5zbQ1VXzkyQn0IqocWRY6tLLt6niA8VPAeUtwkwCpDKMWZiot4Vn9T8VxNZHK8tMdAVp/uls/1FjNsay9oflFKKc2qH8V9jJzUjnZsxr4/BdP54fzbsQ+OI4dia312Ahqx8DoHPmUM6tdamELTrodnbTmSjScWcpDCc9www5EgIzljWF4iIFCUSSMlPdU0QET0CuMVbrxlHDNF6gh/2EbEZAsckE4j+V3n6W0Bynq6+vby5TZccf0kV+m8gl5fQN/67V+aqOeUaOBlC/EdE+vBBeZ988FH8wRNHEwLA7F4rUcSnI4LymRkBsYfgcLTfVaAd/PxfUGe/4yMJCgbDlXd9dEJ1zfsaLcpGPZStZSWw6KLSLOx1Gfjwj5P8xNytCPb1AFXrWZLQRU9yeSpyVkxwQGEDRvc+Q1o2F/AWvxcQiyVwgAQCZK+fL7YREd1t3GaEzlgJ+QAh8RLJ3RByGLz1roRF9oQHyS2IpAWK9Iu6TBRMStawMi/WfYlQr61lhAU02bvmdh97HSzGeXmIejcthbSwQwxaaAN6/cbkKWIdJepNz91ojJZ3BaBD23ynGMYIFKt83eAISQpwtf+htyXQtwK+q4LnJjyS7ambHXe/NX6iQ8CacYU/Ec2DFHyQcWLG2ryGUCzIRe/EYhOZbcpD7RRlPls0JDdbfPyS4Wdrh8h3/J6iDs2ju3LG3yTbzwp99Q2WE8Go87szvcWqQsGvs9cVwLe6Ki2cniY/ps63foM721vSyFPQM1TsXQnA14cQHX81Rc/sckAPemnSqSGwtTw8ftpVLFxrdsx/kceHMP1SOPtf4u1NvCcFOCqkRxJaBVqDhF
 nu/I+RDf
 1qfvgkGljN74oHiz/uCPurhkoitbkIWa7goTmGRWOB2LiVhWq/fjSmOcHsWNW7v4gQ9qG0ajfi0AWfmfXeOT8qWNtOpMccvpGMDWPXWmEKQbiPV08xKmE7qH501Gx70NZdzxJuUhq8FkFyMJ7nxOW/tVeIGVTO+SsQ4aI1Y7sVXYx7OdLCNCcZBFMVRXQYK3UDgLGfK1ty90oExauriG7jp+944mhV/Mc589dpS597aqDCkRg2koiAwE4Mft7TuSiAIsqHj6089Tmqeh+gylfRm1q7lP00wc4cvjW3Qg21DyFQFjFJ99pM+3U9VVb+Kxm/HZTwyKTRsVM5Vp84sjZeVbsAN0ZdHVleTnaBy0rYKyS1UoGYEwoQVMNBt03o37xPgZUNnLVJbjQY7ydM9rJplSKBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
> Subsystems using the KHO Serialization Blocks framework currently do
> not record the serialized entry size in the block header. The entry size
> is only known to individual callers, which must track and store it in an
> owning serialized data structure. If a newer source kernel adds fields
> to an entry, the changed entry size breaks the stride when an older
> target kernel iterates over blocks.
>
> Add an entry_size field to struct kho_block_header_ser. On the outgoing
> side, record bs->entry_size into every block header during allocation.
> During restoration, derive the entry stride directly from the block
> header instead of relying on caller-supplied dimensions. The
> kho_block_set_init() interface remains unchanged. A zero entry size,
> or one that differs between blocks of a set, is rejected during
> restoration.
>
> This change modifies the serialized layout of struct kho_block_header_ser
> and shifts the offset of serialized entries within preserved blocks.
> Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
> kernels cleanly reject mismatched handover state during boot. Also
> update the stale compatible string example in the documentation.
>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/block.h          | 10 ++++----
>  include/linux/kho/abi/kexec_handover.h |  6 ++---
>  kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
>  3 files changed, 38 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.=
h
> index 36bdbaf9b3b8..a40b0906c821 100644
> --- a/include/linux/kho/abi/block.h
> +++ b/include/linux/kho/abi/block.h
> @@ -40,9 +40,10 @@
> =20
>  /**
>   * struct kho_block_header_ser - Header for the serialized data block.
> - * @next:  Physical address of the next struct kho_block_header_ser.
> - * @count: The number of entries that immediately follow this header in =
the
> - *         memory block.
> + * @next:       Physical address of the next struct kho_block_header_ser=
.
> + * @count:      The number of entries that immediately follow this heade=
r in the
> + *              memory block.
> + * @entry_size: The size in bytes of each serialized entry in the block.
>   *
>   * This structure is located at the beginning of a block of physical mem=
ory
>   * preserved across a kexec. It provides the necessary metadata to inter=
pret
> @@ -51,9 +52,10 @@
>  struct kho_block_header_ser {
>  	u64 next;
>  	u64 count;
> +	u64 entry_size;
>  };
> =20
> -static_assert(sizeof(struct kho_block_header_ser) =3D=3D 16);
> +static_assert(sizeof(struct kho_block_header_ser) =3D=3D 24);
>  static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>  	      __alignof__(struct kho_block_header_ser) =3D=3D 8);

The above change goes away once my comment on the previous patch=20
is addressed.

> =20
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/a=
bi/kexec_handover.h
> index 2f4fb9c63942..6f12f5037ea5 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -41,7 +41,7 @@
>   *   restore the preserved data.::
>   *
>   *     / {
> - *         compatible =3D "kho-v3";
> + *         compatible =3D "kho-v5";
>   *
>   *         preserved-memory-map =3D <0x...>;
>   *
> @@ -62,7 +62,7 @@
>   *     };
>   *
>   *   Root KHO Node (/):
> - *     - compatible: "kho-v3"
> + *     - compatible: "kho-v5"

These are just examples, don't update them.

>   *
>   *       Identifies the overall KHO ABI version.
>   *
> @@ -90,7 +90,7 @@
>   */
> =20
>  /* The compatible string for the KHO FDT root node. */
> -#define KHO_FDT_COMPATIBLE "kho-v4"
> +#define KHO_FDT_COMPATIBLE "kho-v5"
> =20
>  /* The FDT property for the preserved memory map. */
>  #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.=
c
> index 0d2a342ef422..9b148009085e 100644
> --- a/kernel/liveupdate/kho_block.c
> +++ b/kernel/liveupdate/kho_block.c
> @@ -16,6 +16,12 @@
>   * array of serialized entries. Multiple blocks are linked together via =
a
>   * physical pointer in the header, forming a linked list that can be eas=
ily
>   * traversed in both the current and the next kernel.
> + *
> + * Each block header also records the size of its entries. A newer kerne=
l may

"newer kernel" does not make sense in the documentation comment, as any=20
kernel can do that. I would suggest "outgoing kernel." By the way, in=20
this series you use the terms "source" and "destination" kernel, whereas=20
traditionally we have used "outgoing" and "incoming." While both=20
conventions work, it would be preferable to maintain consistency.

> + * append fields to an entry, so the kernel that writes a block and the =
kernel
> + * that reads it can use different entry sizes. The reader steps through=
 the
> + * entries with the recorded size, so every entry is found, and it does =
not read
> + * beyond the recorded size of an entry.
>   */
> =20
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -110,6 +116,8 @@ static int kho_block_set_grow_one(struct kho_block_se=
t *bs)
>  	if (IS_ERR(ser))
>  		return PTR_ERR(ser);
> =20
> +	ser->entry_size =3D bs->entry_size;
> +
>  	err =3D kho_block_add(bs, ser);
>  	if (err) {
>  		kho_block_free_ser(bs, ser);
> @@ -242,7 +250,8 @@ static bool kho_block_set_is_cyclic(struct kho_block_=
set *bs)
>   *
>   * Restores a serialized block set from a given physical address. The ca=
ller is
>   * responsible for ensuring that the block set @bs has been allocated an=
d
> - * initialized prior to calling this function.
> + * initialized prior to calling this function. The entry size and the nu=
mber
> + * of entries per block are taken from the restored block headers.
>   *
>   * Return: 0 on success, or a negative errno on failure.
>   */
> @@ -250,6 +259,7 @@ int kho_block_set_restore(struct kho_block_set *bs, u=
64 head_pa)
>  {
>  	struct kho_block_header_ser *ser;
>  	u64 next_pa =3D head_pa;
> +	u64 entry_size =3D 0;
>  	int err;
> =20
>  	/* Restored block sets use size from the previous kernel */
> @@ -264,8 +274,21 @@ int kho_block_set_restore(struct kho_block_set *bs, =
u64 head_pa)
>  	}
> =20
>  	while (next_pa) {
> +		u64 capacity;
> +
>  		ser =3D phys_to_virt(next_pa);
> -		if (!ser->count || ser->count > bs->count_per_block) {
> +		if (!ser->entry_size || (entry_size && ser->entry_size !=3D entry_size=
)) {
> +			pr_warn("Block contains invalid entry size: %llu\n",
> +				ser->entry_size);
> +			err =3D -EINVAL;
> +			goto err_destroy;
> +		}
> +		entry_size =3D ser->entry_size;
> +		bs->entry_size =3D entry_size;
> +		capacity =3D (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
> +		bs->count_per_block =3D capacity;
> +
> +		if (!ser->count || ser->count > capacity) {
>  			pr_warn("Block contains invalid entry count: %llu\n",
>  				ser->count);
>  			err =3D -EINVAL;
> @@ -370,7 +393,10 @@ void *kho_block_set_it_reserve_entry(struct kho_bloc=
k_set_it *it)
>   * @it: The block iterator.
>   *
>   * Iterates through previously written entries during state deserializat=
ion,
> - * respecting the actual count stored in each block's header.
> + * respecting the actual count stored in each block's header. Entries ar=
e
> + * spaced by the entry size recorded by the kernel that wrote them, whic=
h can
> + * be smaller or larger than the caller's structure. Fields beyond that =
size
> + * are not present in the entry.
>   *
>   * Return: A pointer to the next serialized entry, or NULL if all serial=
ized
>   * entries have been read.





--=20
Pasha


