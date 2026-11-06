Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C871D606A334
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 19:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TQt8Fx08
Received: by kanga.kvack.org (Postfix)
	id DC5EE6B05B3; Fri,  6 Nov 2026 14:01:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DD06B05B4; Fri,  6 Nov 2026 14:01:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB38A6B05B7; Fri,  6 Nov 2026 14:01:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A10126B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:01:57 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97D78A018D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:01:56 +0000 (UTC)
X-FDA: 85405613832.23.2CB9EC6
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 87C9940003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:01:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TQt8Fx08;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of lrizzo@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=lrizzo@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793991714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnari2EfkfcqWLrylXnWPpbFbNnmk3zqvy2a0yZnams=;
	b=f2utEQPWQnqJsyoUSAZajpRA85uIy+OnXEAKRXYVgsLj4BeKdgyyvdWITmL8QWdf0QsPt+
	7T+OK+vqRSvBdcyn7rwnwtUj7e4urm5fox8KTh6o6AS9Q5x3PRMEmX9rSHMbwwV4rmolUZ
	YyB6XhpNmYEpWkftm2iL2ZuJt6PLT2k=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TQt8Fx08;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of lrizzo@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=lrizzo@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793991714;
	b=P+sM4PQeA9uur5Gl0e0UQ1qbY7Ud1Kj9jkFvEhJTZz9XI/OiwAXcUZyNs0Z/PCxQiZP7qs
	LbSZgx2T2J4Xlhi2BJFo1mGaw6e8Nv4Lujq+DJSVT+tfynC+TSVV7hAXDkFDx9UnR65y6m
	hIbszOEw4F3CFmRFw22jLVsV0x2ljrE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-533202fe429so102011cf.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 11:01:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793991713; cv=none;
        d=google.com; s=arc-20260327;
        b=GGYKKmAN2qYpRigg7xlKa+qZngRXV138FDOgpgwFNIhKLRUoxwSg50rW9obP6ef7Hz
         CpHTDR8lAvCbXCwsacUlgeqgNhu4KOTXC0gtne0/sgexy7wh4iioWQMHMk2AhYwi7Rtn
         TiV0nhsGe8W2P99Drw2/rsb3NabG1vUHexFfc20YqHyxn2WQvnEzApqCQOsEMxMTa47e
         Kod5V7u0uCXxBoxwMpsXqVjjOfernFY09tJfmUVtk1oGKrYnVN/PzeK4dxPW0CF9aN/u
         q5SCVU1ZBPf73WQXOdc0oD9mKz5zKR4TJ8iTJgap9S9gbmUOIxfFcKTuyHQDMd+sE4Gv
         3knA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cnari2EfkfcqWLrylXnWPpbFbNnmk3zqvy2a0yZnams=;
        fh=dii+X5IU98qFC6ISJlD/BQ9jhbpM+3m4WPvU42vnj9A=;
        b=f2VvRoaK6egre7GuYJKRHmCpaT22RNLEl6A5GqZG5rM6GvEGdp2kxTZHbAhtPH446v
         sE1VT/xK+/sVDmN1Q5MUJjAW5d+516DBxGQyMZy8UUAXpwHuc1/Uz7Vf1oJS7Ta8aLrW
         oUo+FRICqZNCGEqhKlF5pbMKNV7Eh9NOvdXZ9gF9y4WxId69Vafl8cfYMfRx+v+rbegA
         wVhoL7B7jPsnmISD99wuYj7YknmdQiTFcVNl1FbgU7nNmfEq52dIcMttgk2WXGJE7e/e
         T8fJ1aSZ6O997Wtfs5v6yeygcMiFj5OZlosM3lbm21cSwFg5do6/kOEQyEwcrEmcXxK0
         oEWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793991713; x=1794596513; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cnari2EfkfcqWLrylXnWPpbFbNnmk3zqvy2a0yZnams=;
        b=TQt8Fx089OF2+HT1Db6dHqi7KMR9uFzZqLe2+VnVEohBP1ILvvHYKLrhOxePRyHrp9
         SvGkcn6ILhvEx+3uRI3Kr2ugEkv2UFSA1230uCdHTr9hfaTMCT7JfxDCpSn1/YNHz2ke
         SxABvfoRm8QBrf4Sxjf5TF9Rr4xIAfPsln2EFrp7FJnQ3VFdfCY/oo6NQlUW5fNe3B4A
         +GltVivU8R/d4Zp2R5GpJMNlJgP+BJflo7836IIeqxSSxWlViWG7xa+fY8kAZk1R7wCi
         k/7ByG3CO7XQ5EdihsYTk3K0pIy6BqCTbsvKro+rEmjABqu+Ona/V5LaNzV+b4kewevc
         1ehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793991713; x=1794596513;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cnari2EfkfcqWLrylXnWPpbFbNnmk3zqvy2a0yZnams=;
        b=Fz1Qx3oHvqi0oay1KwhIUQbLZv9n7Pu0jniOjr4diS8poc9Em371NAg61BDjwSkJ7Y
         octyUzcz31EiO2gbvPwiATu0qsC+lTYU7YejyzV8SUuJ7J+7C+po0NLiAWZvuZeNRPlI
         JpOA/z9F47rKZKbKZk9xMd8Ewls+vhriDOl9PUJpj2tp+X66mhZu64fKmq80mA9NLvn+
         mD/tBEr2q+7o5baQHavvjdX76W8mOcwfndlk8cCN7pEnZwHQgB9KQLRg9Ca5I9eN9m8f
         B1yoClYCrylsDG3tjPTGIVywjC3zk6cPlTmWHeFBKhdqkO/H5n+Kjg/PeuuW7EJ7B6+e
         so2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwFohwXu9cCSR2bK9aY+d71Kx1SrEV8s3SLPH++Qh1DZC5DfzjZWd5uChOGx5Q72/HzRq6bF28kXQ==@kvack.org
X-Gm-Message-State: APuU4Z96Te+bC7l+KikQlMAvaZxAZoatU8lUvLbBc/xRHOEr/GqIh9Cv
	6ztP9Iw9mtpIXpp4gfSZNYQMmhhCoOlKPKU+yB4Y77Lv2HiU9PGsKZU2EItfRGWJuFJDbgUU4tC
	3m3PmLvMqkn5W2l4WeVSe8WcIVDdXAKAdP6eyuxCS
X-Gm-Gg: AYBFou1JdfruOKwiFb3Ix9tExjS7bkOwfr4w6fajJTGN13cKv8K0PXRHbmak9oJlEH5
	iv6cuTawCPt93+sKxUAmw7OC06f9hnBG2FMvoCqrwEAPu/JyF0ooQY1Pkn7H3C5hq8Kte3LhL67
	qEkCHZeCwRRAGWLmpQ5/HBKxfM8H/VHAIF4WazMvxp3ME+ZFbS7Zba83dMJ7UxJbBF+MOrxgtFh
	YseW+Msyzi1JtHZFAttIi0f30CitydivOsEY29Yp4SnSatThJbPBp4lgDkn+HltGW/orfc+5tIk
	bUNjfUMz5sUruwKoIFKiV6+QtcRWSr74dC9K01lzzVLdiPsvyQYCQT6W5G1yVQ8kT9kBxjwdNaR
	GSL9qpvdSBk0x7IC7M9KJbf7YOQPKFXySHkKiKQ==
X-Received: by 2002:a05:622a:90c:b0:533:9746:9a86 with SMTP id
 d75a77b69052e-54f5c235197mr4277431cf.5.1793991712760; Fri, 06 Nov 2026
 11:01:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca> <20261103080933.GA4213@lst.de>
 <20261103151021.GK3889730@ziepe.ca> <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
 <20261106173054.GH663069@ziepe.ca> <CAMP57yU-VhZWXijvwAXcN9=zZ+eWXZ6J1bkHuCJw3ocRaFaV=Q@mail.gmail.com>
 <20261106180714.GI663069@ziepe.ca> <CAMP57yW6Y4g-xM9YTB+MpgxPN7RFeEWhAPWvqrfOoMDEuL8HZA@mail.gmail.com>
 <20261106184346.GJ663069@ziepe.ca>
In-Reply-To: <20261106184346.GJ663069@ziepe.ca>
From: Luigi Rizzo <lrizzo@google.com>
Date: Fri, 6 Nov 2026 20:01:14 +0100
X-Gm-Features: AclHuK8RLl1nJ3Ebb-rbtl0GPWPY_LeKIqNGDlWDxF7jQ269eiN5kMKC-Dmlr_c
Message-ID: <CAMOZA0L3c0zWvvVF9btAxQSox_hQTZP6W1sK0vgYPQ2OMJtS8Q@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Naman Gulati <namangulati@google.com>, Christoph Hellwig <hch@lst.de>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87C9940003
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j8yssjjgdxnorci393ugkgo5huuo369h
X-HE-Tag: 1793991714-585477
X-HE-Meta: U2FsdGVkX18oZ3vm+PoBqii9eMm2YLbzNnLTTZNozDM+iHiorLHPieU1CFl2QWcwRaXJ/52b1M0vtDUpgAyLBo1aX1icBqMFmTzC14ytzbggFH83PACKG2tcdVN2JPLIVUt3iCcmO5idu+tA10ybJukYPe1uVmk7xuyW2WSf/TSx+cwtbuVM0NyJcODjLg6K6vLrhnlO6L+7aDSsYEP6pHvMBapqqZfFyBOCRNBMQnecpfIcWNOVdLgE9nyg2Ht62RcwUbLY9Tw4WtAC3usfjoLDzETh2EBsiGCJir7H3Y7S6atGwXTY2yL/etOU2YFV5HlaTHuLrLZANpc4H01G8dlLyfL4Ph2rXKwZOfJHJAGlSKPTHA14rGMfvEoPXnd0blplwudF0WXrvaNmdBkuWqfknaV64D9ulwRg3fBMDpnhAjczDjmGM2e+/HyGF30v8Unta7HsZD/qA1kLm0RarHVzdDjnj3/9nYGhWiG16qSXw1m1oN1pkwpRyASUxR72fmdoYrNFEOcpyqBOw2hkhV3f4/wL4RKYfQEd9ofneCCjHXOk0B7qDm2IeRmRvope8n0hwsvUYXpL6mbrn+I74CbGBcTDbZVL4DlIFx0zf+Nsy26W13rF+IhWhjINHgmWnAGQpz2CFOW64J+yz6tQmsqdy1UGfoQiT5uvM3eZxfrp+FxkoeO1orZyaNWK8N2g2Ig1m4o4nx+zfdE1fgdThtXuWSx98Il9RYRHSoijftIfGr/OrczEYy7FsfOt4sjiCq5Qp7mBDQQonVjBtlEuZPj2twSkDwKz5kIn5KD3FgPqdNxH+jtDU/HcJ7q90QRO/KohJQu52GVv5Ddm+nv6Dk5LCZV4oOTXSzVqghzC1JR1b3OaerN+kT+i2KnXJYj0ViwaUynQo+vfiYcsfiqSNRW8uVDYMaNgqTkj7ANvzLDIQtkCkd6i2DL/TxWSn/JobInGHwfPNpVd6Q4+r1v
 Im85/+Yt
 cej8xRCl7K1cge59O4S4Sso+Oss8QTUVYsYAcHvEqNZHZH+9J8OfQ+FCnuue/PBgIraXF13gOoFgBxPKK326IHYuPSdaZ7Z/nW3tEM4g+48jDRebTnQzqJ2zh7IsCBL5yC3L2RQoC8iQccFvZoCY7l3IzbXeJK1/jMSDie5GSpM+Tn3c4PN32aJQNAD9cTYQZXeMeh2F5gGuvVoelZoTFuDrSDMuEyapHBwukdiejI8mYl8J4QmLCLkqzQDfAnlybxtuW22cqefvebMQ1DQ0+56UngmYUyRP8FsVaB8L8cCp4rSP5T7UXKDlqBD8VNZDL4PDPbMVScpw00VBr9Ytn91SA+ZhQIHzDSlWoND4j2mkeiliza7c4NApBS632GLy7AAN5uzm8F3yBEHyT9dfTryW26EXgXz0arbAjgxPDQjfS3Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 7:43=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrote=
:
>
> On Fri, Nov 06, 2026 at 10:17:38AM -0800, Naman Gulati wrote:
...
> > This problem extends to generally reducing IOMMU overhead in
> > networking - taking the dma map/unmap cost out of the hot-path and
> > avoiding IOTLB thrashing.
>
> Sure, that makes sense, but just having a pool of entirely normal
> pre-dma-mapped memory is quite a different problem from what launched
> this thread...

Since I launched the thread, I guess I should comment...

I wanted to address multiple problems, in random order:
- IOTLB thrashing
- better security than DMA-FQ
- reduce dma map/unmap costs (both on the host and guest)
- reduce/avoid bounce buffer overhead in Confidential Computing and
overcommitted VMs
- not just for networking, also for disks and accelerators etc.

Now it turns out that one way to address all of them was to
- create a special memory allocator, which distributed ordinary  memory but
  with additional metadata that make it easier to implement large
iommu mappings,
  track lifetime etc.
- hook this allocator into relevant kernel subsystems so that consumers
  could use it with little or no changes.

As it happens, the first version I posted last month was not terribly clean=
,
and possibly not terribly well presented, and had some redundancy that
was unnecessary.

The next version (hopefully next week) is hopefully a lot cleaner,
and i think the best witness is how small is the change to pagepool,
basically "if the device has opted in, ask for that special memory"



diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b775b6305fb78..e12ba47a20e43 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -16,6 +16,7 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <net/xdp.h>
+#include <linux/pisa.h>

 #include <linux/dma-direction.h>
 #include <linux/dma-mapping.h>
@@ -602,6 +603,8 @@ static noinline netmem_ref
__page_pool_alloc_netmems_slow(struct page_pool *pool
         */
        if ((gfp & GFP_ATOMIC) =3D=3D GFP_ATOMIC)
                gfp |=3D __GFP_NOWARN;
+       if (dma_map)
+               gfp |=3D pisa_rx_gfp(pool->p.dev);

        /* Don't support bulk alloc for high-order pages */
        if (unlikely(pp_order))

The network tx side is more complicated because, as discussed
earlier, we need to be sure that the leaf device is one that needs
those special dma-able buffers, and there isn't (or I have not found)
one central place to hook into for tcp, udp, zerocopy,
security things etc., leading to a plethora of small hooks


 net/core/skbuff.c                                            |   42 +++-
 net/core/sock.c                                              |   62 +++++-
 net/ipv4/esp4.c                                              |    4 +-
 net/ipv4/ip_output.c                                         |   19 +-
 net/ipv4/tcp.c                                               |   23 ++-
 net/ipv4/tcp_output.c                                        |   12 +-
 net/ipv6/esp6.c                                              |    4 +-
 net/ipv6/ip6_output.c                                        |   19 +-
 net/tls/tls_device.c                                         |    4 +-


cheers
luigi

