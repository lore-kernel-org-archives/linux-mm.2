Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B2B606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 21:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=WYUvmlwp
Received: by kanga.kvack.org (Postfix)
	id CF5B66B0185; Tue, 20 Oct 2026 17:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EDC6B0186; Tue, 20 Oct 2026 17:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46866B0187; Tue, 20 Oct 2026 17:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BAA96B0185
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:20:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 030BFA7EA8
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:20:21 +0000 (UTC)
X-FDA: 85344273084.04.3DA1537
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id DAE1140012
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:20:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=WYUvmlwp;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792531220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chw8LHvkOCiuA9Bl9ETjtRb0/vjR44eNojF89t5j3yU=;
	b=25AL+ssQgdCTdBD4CmiFWFbQY59FKrGIQLDdcKCFHvVJaBuaabYXnOmjWikAfswfzzPM7d
	ty0/kTjvGnAOuTWwhzvFLuiknjGMc5583k85R6m8RvPlkUChUwlnJ9Ysqbj6WaH+B8fmKr
	Q4ujoFIvy03FisRfspKy0fhbGJAiIgw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=WYUvmlwp;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792531220;
	b=JnWXmERi7zwxkQ7XoIu6N2dS0XoyTMSnV9P2w9LcUVwBI+rmkYlx2HEQ/B2sJhW09PdGkE
	fWiehLHngJcNpDJtEnrT8u5iaW7GA3wo95L909DxLj5i+OVkSaN3Se+TNkvhUDdIuRe7BZ
	3k0W/74FjCVXdxQOHn1d4tWaRCPdEYs=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso509356266b.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1792531218; x=1793136018; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=chw8LHvkOCiuA9Bl9ETjtRb0/vjR44eNojF89t5j3yU=;
        b=WYUvmlwpUJ7OhbeYBZGGVg91gUOE8k2jxc5Rj27v7hWKhKW+xhb82BiASi9A7o9tkO
         KVTkSlQR0N2a3s7hAJJ4hRqgJ+VPoVkFoIK9kGmPwloVJnya4eqsJHbndHpsvYUHMXUS
         stJEWgey6QNRoNP/mlkpRC6COQGbgn4FL8dco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792531218; x=1793136018;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=chw8LHvkOCiuA9Bl9ETjtRb0/vjR44eNojF89t5j3yU=;
        b=iDG4ECiLwIp9GEpYb8zz8zYAAIccBZC+jEBoTLDNE48+5G089tgyKESLGbuzgrxRbA
         3gOiXeC+1j9I8KJEIZ8TBXHHky6kBJ8ZHSuYw/ryJjZNk/mqFJ9fLZX7rdbsC5vEmZ46
         rK6+G9uOh0ymeZCQroCKAHuACueMGDze/poi8oirVpjgjZxkiyrFHBraFmq/Yonebbxt
         +vrNHx/HZjydZj19/RuDiHB5L/3zJGv2Ig89IKMtkl48haIIMnHRnzULmK+K6VBk6lgC
         VYdRDwvym/3xXvVemwSZ3lPV2PXyqanW38LtA/PkyJOamnqDnRqBgXuXpR345f2Bk6nF
         KGMQ==
X-Forwarded-Encrypted: i=1; AKwUvBwJEXjAI3YjNBYoRZG1tsnjiyKsS5gFqZ3r+RoLOfNRZRbQR23mg6nxWeM7Qde7g0YJ/s/8WmSdHw==@kvack.org
X-Gm-Message-State: AFq9FYL1q/uyrb+paXZKYdrNhiaBsZGTq3nthJcfRVySFnB3uCtjwYT2
	/Bl1TIbDeeH4XiXoOz+qlwrenk95d36xlaY9sQ72VkKUopRfo0IN38zj66Q8VNri7eZkgLrCVLU
	/KtgG0rdm4A==
X-Gm-Gg: AYBFou375MX8ll0MzWmmuT0Ee+b7DYN0xs23PKLWjroQm916Rt7QOleTe4itk+TmRcN
	y7eAwt7mjM2updvEW4SSW+XmAKfQyopCS+TPBH/njr6D+2HuDGZwgM8aaqQGQelkMEIBMh5hcG1
	G0CNojH2/EbOiexrY9NK7dzfWh0AHBotwwqQNSa6kl8k7/6eXGyGv4v4THzKhlg6Q7MkxR0mqaD
	zQZBjQbgKe8ZKJPsZkXKT6E/unzFqQG/baTJBQnCVdput4xasHTjhxA+lYNElwGzpVqu7EhtKHW
	FNE4nnFUF5jNbLHHohk5NB/QkjZuCgXQ9OLULeAX98UT75p4cN4Zmg+a4+WMlKqXOenYCbxjOUV
	JVoLPF63BOqLOCHtyTd7+97gy8Px4XNQBB1NSPbiYn+1RlgJDItvWisQQgpYdcVXVwzenDNGWaJ
	6J7TprK1Gp2bCohlFNrTs7TQ1lLxHra3SL/2Naf0WAPadERI56pgHwvAzoE5z8OshtH1JSJxupq
	qmNjzT5WbawcG96HwNw8XXvi6jU/OzC60fYjvHlsPURrR5k
X-Received: by 2002:a17:906:478c:b0:c35:d50a:1356 with SMTP id a640c23a62f3a-c467970b85cmr28019166b.42.1792531218202;
        Tue, 20 Oct 2026 14:20:18 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4679005e04sm13180866b.71.2026.10.20.14.20.16
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 14:20:17 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so463947366b.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:20:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwlSxpetQS/mIFP8j0/o+SE6bqGITJh5BM9zL+/UQd0zj5owIsk3Cp6hKQpqjqVAO4x1MqOoa1aaA==@kvack.org
X-Received: by 2002:a17:906:99ca:b0:c3e:cb50:b7c8 with SMTP id
 a640c23a62f3a-c467959382dmr29830166b.12.1792531216713; Tue, 20 Oct 2026
 14:20:16 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019154913.1765974-1-kas@kernel.org> <20261019154913.1765974-14-kas@kernel.org>
In-Reply-To: <20261019154913.1765974-14-kas@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Oct 2026 11:20:00 -1000
X-Gmail-Original-Message-ID: <CAHk-=wjJpuLXt5BHieXV1qBE-uoWDXKugcfGgR+DiVGVZQ8RvA@mail.gmail.com>
X-Gm-Features: AclHuK9tJ1qytK1OXr-yTM9eIoQeaSqd6mgYmdK2yrKkOU8FofcfrEV39uaS5Ds
Message-ID: <CAHk-=wjJpuLXt5BHieXV1qBE-uoWDXKugcfGgR+DiVGVZQ8RvA@mail.gmail.com>
Subject: Re: [RFC PATCH 13/18] mm/filemap: store the end of a read in f_ra
 only when it changes
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, "Paul E . McKenney" <paulmck@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DAE1140012
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: igafic8ufedkxbuy995t6fr1w833t3du
X-HE-Tag: 1792531219-203609
X-HE-Meta: U2FsdGVkX1/AWHql+el0SXPQoWU3dkf0k4DyhOl39aW7hKJP4PEhbaJpW24ZgkBSJoWtZbkVDLPaAN6ra4+vjI5p3gN5C3nBqPN9vBjoaGXpXG4BIfkGr+iX3HafoNh9TwLM3MAlBJkpzA0FsDRLJjli5bIUtvQLZ7r2avnIJhxaMRUvhH4fTYJ7U6WvXDet/nMiF8iubOB8mC5frYpmg7KZ7eB04arrDCO1RLhf6EO0CpxYYICW5wDK3CEY/RzJhQ0DXn2+Wwjf5qWnv6remFaFFv7Vzkd7nW4HiQ+B7mb7aXw0GGgI9wq1eXXiIxPF+xCY69SwzdrYMoiKDSDzOC0siMSkOes3CM+oUvuDQ4J3yTfIDp+lkeCNLFTAC/6xF3ktvUKM/t9yACzpKdsVSNzbSF0N80gAFJswjapujmD0VSEnKq/91spnC9TUasT4HIMT4RaB+INr8jcz76cEPElSDk64FCMzm+B7YeVu/84WFz9dE3axT9/pZjYIPYuf+aRIdYXdinDnlMgnMriBesnffxPPOV6efITQQ94rO8MLIrt+ciLYZ0Ek1WW171FZQ+4CMnQHzVSUXQhc2KUWq5pENMK7fKVplTz34xcvpqasRZtauatCBIzAu4+5HEZkZiulJQEHQFSbQZdCpOykrv4wuLe5CsEwj/r5OquMhenmmLIktbRfFMNpSZyMBCG0cmNuhahpD1/6i0rJTXRBZ/6pYQVcnCz5olkeURlGm3nqpPJUB2aHapkOMJUcU2ypto8DCYpIwhdXnWxv94dTfJowRFOOt4efr+fFXx4JiSKXVWcB8qyHJQ7gXzQTw86ePFu6ZHx5+YhsZri4ekMUY9zimnu64ZBqsUXUt0CczxvJAgxdVddxmV7bwDXh06PIQB3/8Qb2h6sdkHQwHCUOiqc02BvkgYwzL9K3NmTkZ6YiecCiRA+EzbHtV8bmBRWNMDTFZDInSZ/nOJ0kmqf
 GK37BGnw
 szgcyyusBYAH4HE+1pfFo8P631NXms3dcbOyRpmfNE8jzvH3U5wkJK3FmVSVjEJK5y4FlDb7X7YuEBOwGUWIGo68JeyeS2lxnoXFlmyPyqUaiJ315BMFbCuQLer43XVQdUiRu4vGQSHHl1uO3iOLJ7Wu3QnQ/poXTbXen/GdVN6+o56kTbVcY7QDsPXUEfd1vknAe/DudC5wuhb1Ja9b3UrarlA6st45cvA+hz2DXDL+YPFOCQc7BsRm3T+TGsQt4+O+IJvi0beq0WYfcphbSNCJ5mfidZnWYyRXlvXDhGXFsOxyYaBeB0n3zIPd/Zb9SOj0DY0I5vyIW03kj2kaeHCaTOLlqXwX2NMZfarJtfXyFuL1CWjh3Rc/lBOz3Yd9H3q/KZoHwKu9IxuRUcLs1bN+UpwW9YukJ+1aWTInJIE1prvnDyxc0jzWO2iOtpKhPCvdH1TOQECh9oF3oepgfyIx8Je33nyQMXrF899H3aqjsbzCz2EAHeLXqiNFpySeHRgXxebxw8EtJBiIUR5ztQyDEgfKICUwwpnQO9XN11Hg0MUNW/K5PxHg/QN6T82GQccTXDzx+q7ZfCNwTbOdiV+lPW7/uKQEEYJ6FEVRENcdTBmiFayON8DgNXt8/SdMscztIYzUzCzed3ov1LQrGUusX7Y60XA+f5QNIEL0V8z3P7ykgQPjkkWpAeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 at 05:50, Kiryl Shutsemau (Meta) <kas@kernel.org> wrote:
>
> filemap_read() writes the end of every read to file->f_ra.prev_pos.
> Threads that read through one open file all write that cache line, on
> every read.  The value often stays the same, as for reads that start at
> the same offset each time.

This seems silly. That "often stays the same" is only true for the
pointless benchmark, no?

I don't think it's ever true in any real load.

            Linus

