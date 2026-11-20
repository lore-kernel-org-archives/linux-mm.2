Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D024860A261F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=a/BKgRPT
Received: by kanga.kvack.org (Postfix)
	id E46D36B05B1; Fri, 20 Nov 2026 14:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6216B05B2; Fri, 20 Nov 2026 14:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8E26B05B3; Fri, 20 Nov 2026 14:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9A8C6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:12:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C7CBA018C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:12:46 +0000 (UTC)
X-FDA: 85456444332.15.25CFB13
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4B8A21C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:12:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="a/BKgRPT";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795201964;
	b=Wav3NHEbHFYQWQE9MRfZexNwmFXcQbv7jhMhCc1wQIYVhXQagGlc9vXtNoePtdsrCZqZ9M
	xxkaMTy/G+NzM0sb8OrrknOYECJBBVQ85XFNSwOSv7cHncdjKXwpKapSamVgvRjdAeCP+J
	TigLnrNiFbmAW3fhzLH125w9wXgfQG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795201964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9RQqwSYuKH6BmFXT3u1NJ8tFtpyybE8Xg+Th6P/DFk=;
	b=CKETa4jVT+kwTCv1FDOujl63O1MojkKBoiC87qwe9Qlo+yoSz7XbesEivdsceu+h2BoZ29
	PkW8+xPHHrxRGq3FdV3WZRzPRehbCM3HB452I+aCqN1OOfo0lHf7KKGfN80jwYpAyqnmRq
	/HDmHE5l1Z166fAiKIQFCN8O3mMT3lI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="a/BKgRPT";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5366ae57896so13184011cf.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795201963; x=1795806763; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H9RQqwSYuKH6BmFXT3u1NJ8tFtpyybE8Xg+Th6P/DFk=;
        b=a/BKgRPTYn63EriFF+PWeXGBqoJUawhU3zWpTdVA8uoTCIoigjWqcKqYcAnDWCJ0Df
         sSBl2XRUWr+AXMVuEHjhiwNLkzsRY9SJ8htk32eq2Y4QSvOqT5nYsLEjdCxDLn2t9bHE
         NBk/kBjVLMTYdQ4oIP8aR2s+zVR5rEZ7adMAZfBAnIXJ1gI/SeaJDUfbNILMLA73mcWQ
         qV5OCXeaAMC4cHLEncTFuHhP0EedhSFnKkBbOdhWhnGWNmVoi8Rk2sMBQ7zgsohV8kkR
         Yas/+M+Asf4LBFyN6lZUH02w/oaFMHYMCx8tqMrSzlAWPF+xmId3I3wgI4KoSD93QswZ
         VlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201963; x=1795806763;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9RQqwSYuKH6BmFXT3u1NJ8tFtpyybE8Xg+Th6P/DFk=;
        b=S2v3iiu19ohlm9ZQ8uryGuB10khNp3RBxsphGYQA2hIvz5yLrCWH2GboUExLkRMg3M
         T96t4/Sjj/+L7usjLNw1xMKv5iIcnlYI+GQtkRHQ7SJ1kRfjYuqvzJ0RDW18UyYo8zS7
         sX6F2275vcEID46q81NgQ8k/ZlcI94ZiMG0jmhQ+wRb1l+RystYI1ZUdYZrjl8H64hi6
         ojpcrgQHbYsqDtjcdfTIw9G6On7EhDaMR5b6xxoHXqMlNNwWUHb2dgHvkwhhMD1dlXjc
         3iYhsOqb77I/6QRYuxG8cbuxkkgs0+SZtSogZhj1FXSqZpuSCJD3xAjmnBLZJVUzQYJh
         u30g==
X-Forwarded-Encrypted: i=1; AL+hErF2k3HR1gXwctLfaXO7p/A0WR+k1zaviJj/GNpFuSq2dfMUlleXxv4XERBGp8CFlOrS+v9S782eqw==@kvack.org
X-Gm-Message-State: APuU4Z/bUkUStqGcxca5A2yRVf98lRVsm/elObb02k8zWsEuyulfHnZu
	yod+5HtfAUmz8FJqcpN1ZE5BJLslsVdHWZVq+Lb6qMHDDEdpMNXvOWqDOgp6IOCjRgQ=
X-Gm-Gg: AYBFou0zzLNENyiYqe2dQoauQdxQ/Y/aay5fxRV//FG8CmJRluMyVdGG84QrUEBfd2G
	a9QVxkrr/KaBVtD6pFYmCwW1lBn7U0GevnGSwRYB8Vbutpy5IrxDowlk9kKyaOMURhuvCtAATVW
	5E7GYNGQTZUAUBkG2sD4UIS4ZsbkAVYv3TpWkH9fP9KB2m4ErLHL2UAV3UkTRvuDvL+KGXWtxcV
	pdZ9qbEfRj6MDiVoJp1y2Qed8V5b0h1Ff91z0wMUVHOwOqjqmiwRKvLnSuOp0AFRxa3dJ9wUEVm
	pIXGw0d8R7pbnaoO/VXMn4z0BYFNpAtLR6mTnUzeJ5hHCy6I0jUTK25Gs028hGnqAZIy0ni/QKm
	9/A80Y5NVCx6I9zhOzgdjp9Cx2ckVhVcWutbbI6Yce7R6ZTuCbBnUgPPEFDYbi1fUvxFmhjtmYd
	+n3TcRBqamKznpUkS+W99U50naqocniMmHSM0qi3W3/xHDm6DoY/FQJykg8vUu8YZ0RSDK0rG5A
	jmrZMAeOddx5CjplfYb3gvlPdRsF9Q5Pj8lQHjqgKiJjNbCI8fwrY1X/Qw/vhpHWke+tjdPm2E/
	GlKJZQpSCrkeRGn98JmPn/c43G0=
X-Received: by 2002:a05:622a:598d:b0:55d:3540:5da1 with SMTP id d75a77b69052e-55d76a2799fmr67233091cf.19.1795201963342;
        Fri, 20 Nov 2026 11:12:43 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788548a2sm29714901cf.19.2026.11.20.11.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 11:12:42 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xUU2L-00000004oEv-3NN7;
	Fri, 20 Nov 2026 15:12:41 -0400
Date: Fri, 20 Nov 2026 15:12:41 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Graf (AWS), Alexander" <graf@amazon.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
Subject: Re: [PATCH v2] dma-contiguous: support percentage sizes in
 cma_pernuma= and numa_cma=
Message-ID: <20261120191241.GD1133597@ziepe.ca>
References: <CGME20261114145340eucas1p2f7699b88eae34f7904cf68109dc3eb4f@eucas1p2.samsung.com>
 <20261114145328.1307-1-graf@amazon.com>
 <fa38a878-1735-4682-b208-5de1616f7e4f@samsung.com>
 <28a0f946-af4e-497f-a923-f11b79d94930@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28a0f946-af4e-497f-a923-f11b79d94930@amazon.com>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4B8A21C0007
X-Stat-Signature: f3e7ds6e831fwfotd15betqsoqhx9m4o
X-HE-Tag: 1795201964-353606
X-HE-Meta: U2FsdGVkX187pfVzG2OtpH+8u4tSzdmHi+XRNbDLBpAxi2kmj2nnbK9L7YA53DgFwAYl/qm94o+VIT90AOI/MD675BI3BT+lLlrUsTlrBc5zeILM7MgPs7PXGvKMNlqgOpd7qcBlcq2xeUBpCMM1J5p8133GpnM5upVofeTHb5OGk1trVQqu6wSFwUYNBaTLmdeBBb+AgwjpU76Y5BDUznms3Su4EC4iOx6q4tWphxW7BSzMcx4zbKVE2kn+oAQL9IPFl7Qf7ki3ucRUURNJECwJ043l1EAa9omcFGfGjngwhNpUZ05w/9eHhC+liiqsGB1kEKX14f+X5eVpfu1aBtbdKqYYAeVH8oMjm4lvPo9wGLy3YmsCnhCcTfJKpSUzokpWndpsBABjwDihxuxmqX3NBcYOvad7kLNPPI82qRbMq7h3rJl50AEtxXCRiaonQG8G+z+96KP3CK6oNTM2vOebkCwfPuYI7tJy/4xgfqPZ0iImhOwKbjOGDVlYzGYvaWvXOJqplf/j/G8TYusj4oPdAhzsE8Wmyeq2S1k+CB+4ic6dkdR2k1PghVkw/IbK9sX27z2WXqMU5i4rdTy/SFkm7ll/MWAF8XeAQir4G/E1sRzpb30OBd0lpFwNfCirdtRv45Oz1olfzbc09YUtSRsQXpIVPut+/hY6Wb0RmWPtnQLPYzSWuXC/iqG47hB17CZNGznEHTuVUJ6qbCp0uH3VMhTacA6EEeAfSh/ZmewIA+DstDNpGCG2uxmpSPRXmiUr+pxg6dCBn1DeEkdFlNZu4GJkTU4gA9M2aY7yjlcrhXI62FJvxONrAue887vxgEGTatvtcFKI7t09i7dxn7KJMCcqiW3RCVYSXJl3ofw8rfRCR+3bBlbr5lgHx6Zi7hJWMjfePPaGTRnlSaDhqAFZaejnszAlxExvNecAIaXw6aY5kgUcBVbLNqNt+AHQOtAMCDlthSrTfEIp8vm
 Tv5fmS/f
 NVDsBkAH0jMmrCL/QxLLDff2X9vqNPwnAABNlXS74BchgQQ9xOObVOXFEE1LRKB+pBoXzHMOBN+zStxQRDyLaeyFMGyaS24vW0nokXf9SgivL9DMJj25npiGZDlMXnPQqlX0McKikUrn35dBX2kcM1rDPzhUBcwxo/6OFQzLQzsgo+ibC7lU25VI0ks8Mzw9CevTbIkNn/qlEitlmy+ohSB8GsilC9I1wyAiEjDZIXgzoAGNGVbyQH4TQPVNYaHaKM32wxUxvkWEOoMQb1YPf48hXeWrXUl1ElBdl0jjqWI2A/qM0lyTpjWcIGRm+4RCxjM79UuHgS//esp6OmXUe1CNuoRwhllJgKelJ+Q+aGH3YuFZTpetzOdJIsnjLTqZQFxH001O9BZ+yWHsjM20UOZdi0npCyY+4SX+vefyVpkfkJ++NnxGo/gjVHlTmprszJYILIzeAp6N0jDZV08BWxgGSrUZpdHFra50vKF/0d/q+tXiooeYdRlEahbcpzSUwjKzBLt5UWKRGSXEeHp6XjsMGVgMIgM1gQ6DGAQ6p4y39cRg5Nf+CY8sD4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 12:27:08PM +0000, Graf (AWS), Alexander wrote:

> Ideally all of this would be policy that only takes effect later at 
> boot, so that we don't require pre-boot logic or a reboot. For this to 
> work, we would need to have Linux restrict its memory allocations to a 
> small'ish region instead of spreading them, maybe to the KHO scratch 
> region, or maybe by favoring allocations in phys addr order. At least 
> until the boot is at a point where you could perform the allocation. And 
> then we would also have large physically contiguous blocks available to 
> allocate from and potentially change the tag to CMA.

That actually seems like a sort of reasonable idea...

What about the reverse, you boot with a huge CMA and then shrink it in
the initrd to what you really want? For this you'd just want some
command line indicating how much non-CMA memory to have, which should
be fairly predictable to get into the initrd?

Jason

