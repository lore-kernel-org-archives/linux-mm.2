Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED97606A328
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 05:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=hyzm2CuX
Received: by kanga.kvack.org (Postfix)
	id 9A0566B05F1; Wed, 21 Oct 2026 01:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9515B6B05F2; Wed, 21 Oct 2026 01:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F846B05F3; Wed, 21 Oct 2026 01:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCAA6B05F1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:20:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C079A5D88
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:20:03 +0000 (UTC)
X-FDA: 85345481886.01.A5946D4
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6988F1C0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:20:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hyzm2CuX;
	spf=pass (imf21.hostedemail.com: domain of jrhilke@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=jrhilke@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792560001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqmI5oTYDX1SfPqyVBb8xiQJ7sNcHlpo9oEZ0gRtz5M=;
	b=qWwBlbJeuh90egoC5zPK7wmaRx26dIFeFeB+48tmBosetorDaAg95zZDGAt5GCXEcudVGa
	LQ5G1QoTIEvc+8ASJvMHztKfy0xuQ+2WlqUHfBuuXi25vfemoy84ayli6wlb47jWwyWja+
	XwkW+g76mHrebD0jkDQ9RA+1/9pUJXE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792560001;
	b=UY+n42k7/mAxa2GwSwgBRRSKoHTHX0h8FdAAp9nHwukuH+HbO+jvsmkbgapFEubof23Csh
	wI2UZKmMIdklvJc4gaWdrUVLEpCOS5tPVW3PUPeFgifculRUXmdViKax50VRkZ0j/qhebR
	cQctZz6zHOtBVBPjDqbQDEYr8jkNN14=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hyzm2CuX;
	spf=pass (imf21.hostedemail.com: domain of jrhilke@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=jrhilke@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-151de818519so1652c88.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:20:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792560000; cv=none;
        d=google.com; s=arc-20260327;
        b=jI5/2EEhpVMXVLTQ8OibLDzTZLMNkF51UkBmMWzp1XbxtkYadfRyjVJ9WUq5EMmXV8
         L99tqLqXvxAoghCC694no+uWdojIJe/q9YDDdhAl1DyephI4HBAk7m13oktgATIy8CuG
         Y0Qx7qyLYCBAUdpPba0/izyULodfl4ZjNcgBJnBGvanebNZU0jWnY2y9Zs1yqTSH7msj
         IiZjrDqzLV0OUNlGzefjngpzB25VNx8PcwFayT5VdSE20RFU3r/0qvk9lOn+Ziw8wMcp
         A+ANEk7skv1QZUKJvLrRdeRG+J+IU8nDGrdlM5GS6qu8lZfB0Df/68m7hpw0dfvmQy4j
         dcMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xqmI5oTYDX1SfPqyVBb8xiQJ7sNcHlpo9oEZ0gRtz5M=;
        fh=KLmi0Q0mpD6XDoizul/kaAQfqZVT5wXwoEfldRYAmaw=;
        b=ipy2Kni0mOr75ba9Ere4SaeaNfEyvh/QajSzT7muyZRo6c1rVodv9Ul3q5z8XTXUrm
         NxBboSfgAFEPY31Gzfbpu1CDA5w5klUU6IJNX6f7r4spsJ75clBAhLi6kG7mup9yNUAS
         s9NPngeyOGx+rW4VKop7YCgl28646ayWHUMNJS+qzSaygKG1Uzm+jVGp5cnSQyXIQH6X
         cQtyn0w/1pflZHUjZoUFmw0La4uRBtp8Bz+hD8NNO4bU23QFxqb0euGhlkClFDEh79fF
         W+zG3eFr1PmQcE980Bc6UkAYqTR7u2uLSEB4Ldle/vG3j9kTHxLFNhzRdiVJxr5G4nyI
         8/ZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792560000; x=1793164800; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xqmI5oTYDX1SfPqyVBb8xiQJ7sNcHlpo9oEZ0gRtz5M=;
        b=hyzm2CuXk/AIIapApB/VRPgdn9Yi20aXK8IUDM50flVRabiqklKf6gCDXDquJ6js+s
         toNFxIb/0bkwfI1RzsoGMoTiYkU0cOfO+kAzhwLoDhOPjstM4+ugRYQ5uQx6BVEnPEKI
         BRMq/hf8Ec8RAV/P+QXAf25zCHjKdBaLmcZ5rj/UCNxTxnvQXqyM9MmA+h2uV93I80hD
         IBuBz1dOgaqRX4a+AXVM8zi1Cq9X2eg8zB1gy3lTEKzrg+eGvBxsztun1ad5ajdn+EVH
         5u1xjq2y/ZnOsmxE8NvGnWMZ1AALB3jq0wTLFoIXxTJxehG37wDy8A9XezhBsfarGPxb
         XBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792560000; x=1793164800;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xqmI5oTYDX1SfPqyVBb8xiQJ7sNcHlpo9oEZ0gRtz5M=;
        b=IcDE/2HzYLvJo23KNPiKgnrWUas3zUxcSZlOfnYqJHjS/scmfDKT81YtSNFdd6eWh8
         M1oPv6jq3EJa1+AjIkHcTLoohHXR1Rop71z6B20Uuao3rC36dmuU4rVfobGcS/0HRj0O
         5zyWtEKuyd9EOGfb7s0I5NIGLYDMFlgk/AzBXw7KKq25aIisZF/i+n0wmautyzEIOxt4
         Qde3arxAyTdueLQA5KeglOizQ1dVKBJUyOQIywJnZowy3JCABN3XgMQDHOlBd5EXdepI
         6+zl2NAgy73FlJJZm21GznbjGY6wsdYL4b1+Mt8RFCFClwY5isawIY+D34kSP2vrHgau
         Jesw==
X-Forwarded-Encrypted: i=1; AKwUvBwD2M3KfaxTOPVPi5uCKufCh0NR1g18GqS6MEczy56BLScF9m7zmqWAoW85HvfNudqSVJoveYTnnQ==@kvack.org
X-Gm-Message-State: AFq9FYL192T1cXBoc3CaahUh/9v7iiU6o30WJNxGbcurNFQtxEuEI9Du
	oFjdpfOmVG7WsoMaFrUUuTu5iD5o6rCKMnigi0tc90VFp2bNQDxnjw9p0rjRLBa4Z48DAZH5ymm
	p8UE5MZ+JYGv+wtDoVgP6tBK9doo8PS30chupyig=
X-Gm-Gg: AYBFou0gq7jq4fEWk5Tvi32QIveqbfXZMphwAcWyvZtPGdlZaeDHONdMQrp7E65EsBY
	R4g3GfOtMYg6hABKfF12lPy+ncU2tRKj04pmcKMCfrH8FclzrR68RhcHH6M8VsObqylc6yPszx4
	b9G+Yi3qbYjPApHhR3kcvT4MYuiZfrFcOPMmliUUXs6HQT0vVSseyiMG1MMKWSRI8taB1QrRDMw
	0aLSpuwnzbUmOxMeLIxvGT+va608+amaggU+ROGt71Ma+FQ58nvI7ZpEEUMheZrLcylsFBsbr3c
	ers6QU+guPz8zy01LPXK5uhjv2DyMduBBcQjdalzQx6m+wYzhqE55BelfQ2hg/7mtPDizRKmIUR
	wrgeqRzGn/hbe6cUuj2NhBndSvcp4wuI1o0XtJQWhC+IC08xwvNXAcN24JR9txjuKcoIelBQCt1
	5wz2/4yfmHzCDEEgnlIg==
X-Received: by 2002:a05:7022:5f1a:b0:18a:392f:abb4 with SMTP id
 a92af1059eb24-18dca4525e1mr532164c88.8.1792559998707; Tue, 20 Oct 2026
 22:19:58 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com> <20261019213054.3157159-4-dmatlack@google.com>
In-Reply-To: <20261019213054.3157159-4-dmatlack@google.com>
From: Josh Hilke <jrhilke@google.com>
Date: Tue, 20 Oct 2026 22:19:46 -0700
X-Gm-Features: AclHuK8_I0lbhT2Ykck25LC8FtHxcLqDsxEKAtZfCcYcVX3702p2AtjdvdGdqto
Message-ID: <CAAdrzjuxL-RCLUK33WYpdvDV38+kFTmoTBVoxK9cw9Voj38wcw@mail.gmail.com>
Subject: Re: [PATCH 03/10] PCI: Factor out bridge window probing from pci_read_bridge_windows()
To: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6988F1C0003
X-Stat-Signature: 5yx6e5e5khjg383dn615qc7ei7w9ewcz
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792560001-64003
X-HE-Meta: U2FsdGVkX18iQTWILTgWAcJFdRchmF1HwwgeYX63Qv1C4udQc3m7H9hCj5Oy3+z58Jlg5CAm1ohBWznnYsFtFs+VaIDRauHfqKkdvo8nXIeyUM4YPlfArSIodHbowXOC/6xYOnO4VT+CbQvx7naERupsAJ/qsRLLjc927qupC88N5F9n8861OLdTw0r93a8jv5ETVcY2Zl4aQ4dp8X3+YYDkjjVjI5KLMq5Jdre7BCHDmAxx7GABZhQ5vqPgqIDLmxs9KAccZ+UiACJXr8DfyDpDYX3bm6DHc7TKXlIDCWx1xosmE5/bDOp5r5QHtQvAYQ3qp0br021iyB8Mj/vrkrE4/ejFZ7UUfQWEllMr8ae02Fa2eLynfREO6Sv2RNIglyjHnOutfucs/PrcSoJJBN3WnC/NN7VqMYu8avqBkkQeh5hZPg4can7be01o+CqJnqfweC/Lqof1W2Jruy1XdnrYXrqLIElYdGmx4teasZ+KUk4jrjeV8FBEOJQ89oVjpT4gNXjRQj1/0f/W+pxh4vj4Q4IpPmN10mIG8aiqyKvbmavkfzIl/j1StZppgDiqcVTMIARX3XGvCav3y5mnGfQEFfS+l6T2gEXdNQ9SiVmfRQNmncn/i4a/Ls5vjU7kNDkIUpY4/HJkC5XmnaRcPlQNiQZ3/RDYpB4fmTXHE+/zoBdGSXN7gxYz8arxuZtHGL0qF/YsoOnyLhTYet2ngYOGwOMAetQakScIKjnZ6mfgoN4G+x2OeN2N/U7sbG5St5CCGnEt5F5qwTdCDJxN7vX1Blcw+2QHeRTXLo0WqpTssesHEweZ69JXznEmC32zVPfCUzwlW4PBDds67G6Z18gBQUwZenC6h4CmrNl0g5tKiCBQoWxvEcLOiwVS4jRR1AFGLMWoFgfmhDYyMj37Jp0n3jHwkrPBDF4GYCAmqumDbrUV4oFG0K6uloNcE0rsy/xnVAkyOwmKBugEnzq
 FXrKBMrE
 hPd9xLmpjjkAn975BEo9/vQt/bPhRNePHQhj31U/KeXmGbf2KpYpJYk4eq3W/PcAdoOb+0SDYphLsaVrEmeeF+P8oXKC+r8D3rSCSQ0y7ZJltuJTqLzS5/o52dGf3z3M8hftPXPRKpoWCbuOaMuEdy5Rf2ObR5CAFOuzn7vct8pYdOTJ5JDZRvCAT8qjsKUw/2Fef6XHU2OxHsSuhea5MB9DuNNUGqmBdmEU+wxnNsgW6+L/87IbIbS1sR5F1vq79Wby62f8wiygr4Yl5EWsazNbx0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 09:30:47PM +0000, David Matlack wrote:
> +     pci_probe_bridge_windows(bridge);
> +
> +     if (bridge->io_window)
> +             pci_read_bridge_io(bridge, &res, true);
> +
> +     pci_read_bridge_mmio(bridge, &res, true);
>
> -     pci_read_bridge_mmio_pref(bridge, &res, true);
> +     if (bridge->pref_window)
> +             pci_read_bridge_mmio_pref(bridge, &res, true);

These two if-statements are redundant and can be removed.
pci_read_bridge_io() and pci_read_bridge_mmio_pref() already return
early when io_window and pref_window are 0.

Thanks,
Josh Hilke

