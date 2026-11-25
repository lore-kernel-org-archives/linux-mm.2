Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24369606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lEbTm6yg
Received: by kanga.kvack.org (Postfix)
	id CB9926B0A92; Wed, 25 Nov 2026 12:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90E96B0A93; Wed, 25 Nov 2026 12:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7466B0A94; Wed, 25 Nov 2026 12:40:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 820466B0A92
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:40:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAE7F80FD2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:40:52 +0000 (UTC)
X-FDA: 85474356744.29.0B9671A
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id F1303C0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:40:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lEbTm6yg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795628451;
	b=zwMy6/doit1TKheIbRAc/BhT7EC0h4pwojo2Mqqv0LL2iE/CBJbgdAlsjvvzTYHOqoWyXP
	hdI4Vp8RiSDRClKZ4CHNKACghUuPZOaUCXEH0qwgqd1jHugbf189wGTobTHPLfRWkFeYyh
	/3KSMoPqMCAQEd6F4uraftSpiTwzOpQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795628451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYycouvr6zOSJsdG8B1rvzwHCG0khxitcfoXgjaouMs=;
	b=GcK0m/XqoC8kmn4W6KkPMPhJ9V/CFw/RG7SfVxuHcyX9mAoqlzg5Z+/ALaojdHnVyGVoSm
	9XGAUx4mB9e0GYbYw66QlibijULk4i2E9PzVcRMYplBIq7x0nxP2oBndh1CDAbj86FcHr5
	fflkMn5ZBarcHXl8mC68MWwyWI/KdnE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lEbTm6yg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b402824d07so4086210a91.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795628450; x=1796233250; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nYycouvr6zOSJsdG8B1rvzwHCG0khxitcfoXgjaouMs=;
        b=lEbTm6ygnM67QDCgHeB/ZFPe9G4VlPyO7gz23Mpggb7KiGkLZplssrB6+i36JYqWql
         nr7XumBhjD6mbC7vRWY/FgKpxm90QvlB7+pCeXc7dhmso7QgCsvNSzSdtX9uHgF7/gUQ
         kT4F6NHheI+lb+WlBkNQMw58q+0hqf1jCEbftLTGSIUvFNTn3Gj+fW1i7r2IhchnTLGJ
         NSyQ/djSMb8u52ZePCFsqqvMGHVwL6pPoNQkCIKUe1iXjob9jDoEPuo5NwwLWumf7s9Z
         6gkLd5AX+ckxfKIzhcgBkPJr9tFpHh6oiRj9uBYJfHrn4j96Zl5PJPGZxavXW2jn28bI
         zYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795628450; x=1796233250;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nYycouvr6zOSJsdG8B1rvzwHCG0khxitcfoXgjaouMs=;
        b=I7nMPL5TYl7kaZrQWV0go7d4QbYW9C3qmHXi89PcErcDgcEqoLJ1vDbTqhiGqIYdt+
         xlrFumA58Fih2qN3o0r0FoDWcLFeW1PzDmtdGiARocvTxNbYt+HjbyO84MGTydpchjjs
         xpGRZOZyG1RVbo0ChsEH4iSwHOxjqYlbgcpbzAQ5ZUhQYiOfzuNlE01e9xKQwJensZuL
         IICuQHVVP/YKVEDshLOIsP/qD0wonn161N3jTV0KkqQjpaUAPK4O/ILn+lT578FJHEQr
         kjhhwI5TsOZ8cpArpioSkVW2VZGy6qCItDp7FNu1VM8Gi93OLHVPNfVMUVf8A82gI7Hr
         XvBA==
X-Forwarded-Encrypted: i=1; AL+hErFRjkgug98kF+cGwzmBMb1Cs0rYiWVU/KGcWwJYfeqcimVey8yTRMX2Ztr6KNMKrAakN0ixkaJ1AA==@kvack.org
X-Gm-Message-State: APuU4Z9YSOePA7YlSC7Rusea5H7QcOn1DVq2IFMaG1ZRwn+VnQ5XDXol
	rMluZ+l6YEkTpK9JGE9TIjoquSV6TG5nTqeUcixwrzerUe1yr0fE6i6aXm2vSL7LnQ==
X-Gm-Gg: AZFdTZdlbWVa6M6ReZNaeLYWM6npZstNSpdutbQBZQIqLj5hRphEip7bgyQJLC1EB6p
	H+gxK0zWYJDgHBmQz3QOfX5mkdchtfFiqQS0XyyeLFr8zTevYtqR3l4AZszU0wDUxhF4KRY6BG4
	SrcDPONtngk7RFdGRU1qTclpdrMNuRPtZ780JO4pxQ45zoPHZDsUcSIkDpSR0derad5cmsvRD/O
	c1PXNCzd49iTAn288vZO5j6jFxxfeVALZqxtFicFTr+2IJlCUfc0PWwX20HnW9NBmeeSh7hsfLL
	FdZC59brQ4H4qycwf7rwceBPSryiw33SB0eFyYUcrciQtXSB4ri/U3fhPFUerHPTUxoZ9kTWYRD
	Uk2prriCb5ltCOE8VyM7gKltKjsRcx2o7iU0MGh6oqsM9g6C5XSeHovpaAdDvD5wgSlBN29d2mQ
	yi7GVk/qcDqyQA5zSvlh7oHDtm1KyFSn10UXzSGPqBoVbe+WYInbpmAalx+IBn4koWEryIjYWCE
	QeJbzzH6fQ0YtmZY3KFu7COJOxd6kLD9CIMaxE1jpDzhI92K/IVeu3DBGSDQDGBm5QrscE3NrMy
	UTtJ9n70a60ytRqxvcHEHhxZWhX1pc5I0c5uJrReoKbt6VQfSG03Bu8gDNi6KCdT
X-Received: by 2002:a17:90b:390b:b0:3b3:fe22:2745 with SMTP id 98e67ed59e1d1-3b41c933edamr18216503a91.45.1795628448898;
        Wed, 25 Nov 2026 09:40:48 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecbd0bsm31676002a91.15.2026.11.25.09.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 09:40:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Nov 2026 09:40:47 -0800
Message-Id: <DN4H5ST3X9L1.3IUEC1CA5QI8H@google.com>
Cc: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, <seanjc@google.com>, <jgg@nvidia.com>,
 <loganodell@google.com>, <arnd@arndb.de>, <dwmw2@infradead.org>,
 <baolu.lu@linux.intel.com>, "Bjorn Helgaas" <bhelgaas@google.com>,
 <oupton@kernel.org>, <alex@shazbot.org>, <gle.com@google.com>,
 <pbonzini@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <kevin.tian@intel.com>, <joro@8bytes.org>, <kvmarm@lists.linux.dev>,
 <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
 <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <skhawaja@google.com>,
 <sagis@google.com>, <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-4-tarunsahu@google.com>
 <2vxz4idb1i2w.fsf@kernel.org> <DN3VG4JCILOO.YN40XHHSWRPH@google.com>
 <2vxzld6hx97g.fsf@kernel.org>
In-Reply-To: <2vxzld6hx97g.fsf@kernel.org>
X-Stat-Signature: d4ffy7e5cr3k7tbs4mzgytq59ccbefyr
X-Rspamd-Queue-Id: F1303C0008
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795628450-360115
X-HE-Meta: U2FsdGVkX1/97OoyfAIusdEpxKTtH1b8hIsMXSL0HkK6Bh/7A8L6fQwQ7enzD9VcMP+KjdXUXx0F2tRCKzLjUeXCjWOqtNdeo6Har4wZu0x53mxRuWjpoyp2H71Tswk+pStEz3/4hRDvfAPhZ92FreM3vvRhwdt50KtMOaj4vQm47Dq/xNKSahHan0EbWZElnyIcv/BcqNcxJo5mZYymlJM4cTPPK7UHc0X7GBJDQ/sV/Oofdktfkx5c+mYQZFGJIb4Pfh0ZyhFLiy8cLKj+6wd3DPKEAU0z2xP3drNizmhoeGjZD+5Qd2saT266dfWYv6teDSz52htUmegJ2HmkXKXu/z4VJ0mTtQAJZVVrGfHnJKhySYig81+Kf2U2g5pCJ+V8NNnTzevS3i9EQHzVN63U0x1G6w8E4eMuasYPTWWMTMDcdciiNFEG5U7AD7CdLBoUgQN09l1kJKkzRrncoI2aWXU0t96+JMkkQLJJJa9uM5CvVkpnAlZ+aOywbY3xqe+ZWy8/VOw7tNFioyAztFyLzF5pAqVl6VsZlHIXt8uG1J9RaLhj/nTmKnvb1NnPpidbl4xXPp+zO4sRQLygwxb+aFBulcRk2XR5i4JJolGLBnfUb+hTYgG2/GZ2LCbQ9A75SJRrDM36SZcbfRMfLjV5oVKqWJKieaCrWY+IqHBDA5kLIvCOyBZYcv8r5/LMZ8nvDLNtRkW5wXxnV8J9jBFNYzd836zy2T9URwsjJ3H86b/5bAKbcd9w2SGF2nBZwv3l3kLNNkPElJCtb16VLFI+oDV6Oe1g3OrBVuWq5Tn/dNsKUsQ8KB5ivRwHip1Xi8MmLCXe2JJtuHgidCmE3AxwD+Z5yr//IdlY4zY/zTzlEqismZ30UK3hW0m/nrv+tnSJhKP+8KkPzjx2NHfnd+PKt468+v75Bk3e0ehu0hVR+ecD8ARujgIoAb4G2Wt8gygtfLHdqh258OG7o+g
 5DLbnqlT
 c3BfBVUnA4sFvnxinz63JNhQbDJni5+LpkoD6uWtJyEO0zOZZJn699GwqCBguolWMcnR7vtkbch4ThsJ55KSg+1yTgk0AIJ8U3gFaGS32N8Xa2stQ3kJualz7f52wq7T812YycBNrvc4xdSptjORTIej1e5wHWOIc6BL9NPuUEkeltZ9vlUkkWqWAYdl15xK/c601EMENJT4jGfLUESb3Yu+pPitbtKwIuLQmAGnPgbyU0AdKXmYs5bO7mj6X67p1o1ZpY41nfrkuQmOA8bWpGL1PwpxXlliA6c3tnkktxMpq3gw1B110ft/lTK098YKpqrWV6lgmBPzRZZ9ElZzCbee4log9YmSVVgBkGL3mAksTkM8qo74GTpjoIbXS0nLnA3Ins1hw06yLPfAk1XYGVeeBiITtV5M8pUu7a1qLx+4XXG7zerO2HBHM8d+Yw3ruz2jxsAMkJj6HULvCivPuT51fUazRHx+X/puTkRHONtNzhgolVnxIK31CHbNskKrFn0myhi/A027sCWlWeydEGzWpE0064SdEvUmTQhiueDFZro/g7fmEcrko1KpO790Q6kaLm8IDL7b23BV4PwMDnhZ+NHtVEIKtllWZMNtRdrXifc5bz66trXSt8aBiSU9lZQEKwM2ZU8bTha0FJiKHXtaCvZIHa/q+myKJiVoCvGy2rY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 25, 2026 at 6:43 AM PST, Pratyush Yadav wrote:
[...]

> So I wouldn't want to support slab until we have file handlers that
> churn through a lot of preserved objects.

Makes sense. If KHO slab isn't coming, then I'm fine with the arena.

One thing I realized is that the choice between the two is visible to
the incoming kernel. With separate allocations, the incoming kernel has
to free struct kho_vmalloc and struct memfd_luo_ser separately. With
the arena, it must only free the top-level allocation. So we should
pick one now (while memfd is bumping its compatible string anyway)
rather than switching later.

Separate allocations leaves the door open to KHO slab but wastes memory
in the short term. It's not obvious to me which direction to go :)

