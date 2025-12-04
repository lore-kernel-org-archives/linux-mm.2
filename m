Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7377ED29FA7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 18:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7826B009D; Thu,  4 Dec 2025 13:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94CF6B009E; Thu,  4 Dec 2025 13:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E106B009F; Thu,  4 Dec 2025 13:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 854A26B009D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:17:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F6C2B74CE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:17:02 +0000 (UTC)
X-FDA: 84182595084.27.7DD3C2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9B5294000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:16:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="dutGMv/N";
	spf=pass (imf11.hostedemail.com: domain of clg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764872219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eirtc4OeV7lF+HDc34TcziSlprrtqsjl7v9RehYvcZU=;
	b=DYvGaEwLisTN3T1Ti33wkzyQ2AWZp1JqpBGScae1RvbfiddpyjJmod1L3Kf5u9yknT1XkC
	EQWJxN4NzOfozjkRM4f+cAaKcZpKeA8YpoALH/X5YCQrvJBaniKKHhDa373y/j0X9WnIi0
	lBDWyC19JvmNNnHYmOuNNVEZe3vpvlA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="dutGMv/N";
	spf=pass (imf11.hostedemail.com: domain of clg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764872219; a=rsa-sha256;
	cv=none;
	b=zsK5FsvpSV3TtjmLzMmcthiIoO75xqVcih3EnPkh4JEyfbgc1gf3i6qxtOtW+r6LyPV9KH
	Va2BOn6t7QqNllZP46uVKblPDVzn+0nIWUV6k43S7p3e0kafick8+Lct3JCQOeswCSOM+W
	ShNiV9sdeJUFVGbD9Tnb3o2I6PT/9wQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764872219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eirtc4OeV7lF+HDc34TcziSlprrtqsjl7v9RehYvcZU=;
	b=dutGMv/NZGXlHE+xCf1PoqCjy8ynOwICAoyRNOF7RjhfsrWrZC3tshiTFFpvSbw1mUfnXg
	m4vKrVzdnJziSCmKR4KzS6jev4zv5kVdgaRPxcBqgcsfAs8lh7A2I2vW30QV94G29sq+K7
	L5k4Gv6XGK5QQ5sw+0Wj2uEGVAATY38=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-uewOjQCeMfiajLUBdTsZTw-1; Thu, 04 Dec 2025 13:16:57 -0500
X-MC-Unique: uewOjQCeMfiajLUBdTsZTw-1
X-Mimecast-MFC-AGG-ID: uewOjQCeMfiajLUBdTsZTw_1764872216
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b2f79759bso823945f8f.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 10:16:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764872216; x=1765477016;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eirtc4OeV7lF+HDc34TcziSlprrtqsjl7v9RehYvcZU=;
        b=YAAMKRomCXTOVYa3qlcybHq3OAeeLSHqIiPtfjrKLo+X4UZwF2eONyM8xks7JcNiH6
         w+RCOclX2EMHIAEKc+1gChQMwHY+Uq4CPsme4bZWryd5dYbQQPMo4Wig2nnXv1yn+JeH
         fD/rKqTmxBp4DFpcnUY29rr4tZjLQngiLjmpeVtsy7ozIXbKudhJZhQ83OVGZHrMQTAq
         OLBnslKQajEVA+wv1kVMJMtH8gYtAa03I0w88vlUJOEk6CyIP0Wd8S1ppcfB9elXxsry
         NuoIiQ6oUZu815xZ0VrrjfkNlx4kjSaxFYXUp580Q0XISisSsB0CPU1W3m41XfND27lG
         J6rQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHFph4QBXOOMpvvcJw1jr6j2uROIq5zKTvK+nCmqN2AE0QQqztNEQaHVAZDeaHPlB8En6LkA9USQ==@kvack.org
X-Gm-Message-State: AOJu0YxxLvNmdEk1jixrlhpx2SibolOUySYgHEAdEXRpZTsbkFB5wGnR
	bdZFrwiSPQ9Aua6r9HZiAUjhxk6t+Dxi1RmBcMizGhsBvkZN48nipMMolHiYSdtDEzpwEkU2f3a
	5phVfp1T7r+Wi2+5C1VDD483igxdFTAJOMiAGxxCit6grg/TO0YEM
X-Gm-Gg: ASbGncuBhNIFMpHlvndI9+P12xlYqaY5naerfPxK/+2m1kaLN7XKSz7310z+beEHcJo
	j8fp1Y1UL0BTEW/oMXPaaPxBeBhwTxyQxqy8iOku4ZwhQf4F65VpcVctyS6wMP7T+2vkFFxQfpj
	ykqAYR552muIJtg8WUqzR3ynpiga7Z43BuYAMxb5lhshcV7681T+CJaRGMDeSzPjv+N3pHql0+d
	fMZ/menI9nYif1QnsB+KAMWCRCkg6qFsSPRV7lVIQB3R6GspXeeHof38dS1LTtbfdsqALFAMbRo
	5vV+yklSy6QpkZhdhUMIAZumOIPCg6BtHDs8BLf9jciiWIpXJLjREMoLJTDLPe3rTTb23emu6W9
	LHIdy0QWR2GVn1EeybEGvaYwJjXWDhU4CV+xdwdII2B9SEa4u
X-Received: by 2002:a05:6000:40cb:b0:429:ca7f:8d70 with SMTP id ffacd0b85a97d-42f731728cbmr7553700f8f.15.1764872216017;
        Thu, 04 Dec 2025 10:16:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHsNa2uHt8wNcyB2Wb02dOnnMd8Uiu88xRl/KelRrPJiBftSyGR+BDd3v8V9I+wEeIzVFlXA==
X-Received: by 2002:a05:6000:40cb:b0:429:ca7f:8d70 with SMTP id ffacd0b85a97d-42f731728cbmr7553657f8f.15.1764872215452;
        Thu, 04 Dec 2025 10:16:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe9032sm4052320f8f.1.2025.12.04.10.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 10:16:54 -0800 (PST)
Message-ID: <e2033095-9bf1-4d9c-9a5b-01148eaffc30@redhat.com>
Date: Thu, 4 Dec 2025 19:16:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] mm/vfio: huge pfnmaps with !MAP_FIXED mappings
To: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Nico Pache <npache@redhat.com>,
 Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
 David Hildenbrand <david@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Zhi Wang <zhiw@nvidia.com>, David Laight <david.laight.linux@gmail.com>,
 Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Andrew Morton <akpm@linux-foundation.org>
References: <20251204151003.171039-1-peterx@redhat.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KS2rYm2Hx02M_I6DhxKfEf1Wdvlc4J4WNsVIBEV9zbU_1764872216
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9B5294000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ijetrc8s3hqnuczx4cnoyjokfmqpibn7
X-HE-Tag: 1764872219-847650
X-HE-Meta: U2FsdGVkX1/rJe5K6R5U7U1MCFfTttDUDcafvqrZqIuLgUZHhzSt71Bq5g+WzM6o0tbgyzBSsVYccqloedgi3qzdkWkkKXvrdWAO1diHlLNNYaaweASqGnk0X/7p3Fm5/TS7CNBb8GEmhgOnVpJ4w8IWIUQKZZDlew0i3bCrSU+Hlzn+KfDe+kt+qJ/MlMlGWjFRiuqUzxQdzn6B8Jxz3LIBkkDImw2rVhwfH3g/VbLecviM0/zbubytb7UKXgWrJlKXOLtHbGhSU1fHBWM7hXUOd7Aj8hZBn1Dv9k6KFU7G1ke+VTwBN1CXJymY6cJa/IF0agWnm+4s4LZxF/2JZxNcuD3faBU3Nz+UFJsJ/ESPbx8dm9fbV9d01k1YYIq7/ElyzxWFo4Q5KlMB7n2PXaqXWQuu/SDQ5EFK2ITD5lJllTwEOgkqZQmedp9FCgllSPcHRK4iWjRfdA5Vo+AkFmwf018T9AKhNPj//n72dUaSlWBz6lJHUM9+XQsGIG4mQxpqchOb3bko/jzH8/GT0cOWJes4EhFaM4E8qKvTYt0SuyO7ieuFzN3x8GtNFJlsDJZd/eqVKuJmUeNnhQ3zEtjedaXZHl6CgCflJdBkfusDEGLgJ9qtUqxO/MB+nMZJX+9rTZ4VH8xfvoVeqiaTA2x4muxsxswGXtUgTc9sTLyIC786FCIchZfA+Nr6pky68Zyd+9I4psU2KHo8jBhEWsVaAwgm/6U83TpyxwqhJUjCGC5NAxRulkSOLxDS3Z6ghXnlrwt5domdmqMLy9q+NW1gp6EWvI4cNhiyBbQGA8Ed8z/8nPzWh8YMKHmjfQm65J2ISmCOhv4JiI0iD/pgQgzq4Eu7FyeOAPqo0y+jKiaYn1nIoIBQ7i5nepeE5/c91e+2GX3fAOsAxaK0M2ZVTmehBkzUJKfDI7n0aapvxPAF8qdFBwCr+rJXeVfbOVGru+8pBoGvlbD2+av6ruF
 zIPtOoBg
 60O/zKLS/Z422QdigpGgUMC0ODGfW5VBpMlYZHtOoZNm9D69sxy4HAwdlLedv6pggEiSnLaoKAPELGYkh9qqBfI/XDtkWXt06I9l4uq9y5CSpovlv+zPDBccwFDtV8aViPboAY8Fk0J8KUfX/BI+Cx9y6fyMrDCGHEnW7X/Ecnh9X2AAI+itFKJVN+zgL5i43emGzeQQ6Yzcn9TYiJLRh1hpYCJiX7gAEwvoNnylYawDPp4arrbOSkFQEL8RpGMFl+nnu9lLja+G08uDl97ASvbFt8BL5hwEtIQP29xWngvXTthbuGa1YkNyhjolPzB+1MOviuaIIpNLZZjGTkM1jKKR9xe40eViuI0BBkQeJfwpKOc9sChBPoByQDmPlmsgeQtjbCUoXj5/N0WiUr18cBlug86iTl3Tu3MwLPN53tyhxjAWX/gKu0IwUMhwm0pO+gVsdRm5W/qTln3eGg5xO3ycRiWcoVmd/ncOxaQDwmAzw9t7SCpTv7ijLBXQ6HuHVSyOczAQb4C6zk2T5RD+GOnoDkEPzYDQ4LcuMmFWeyfAT9zpn8E6PDOCe2azYxY4lO8w66PgE3RZ6PDM2k/jDPMaczHze6tlH+fEESCfObRvPDmkj9BbWDZowgxS4JzAZ872e1YiHPNayJyYsde7ODOmOCb6NGPRobkPwde3CPd1XSsKmwrH2idvf5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 16:09, Peter Xu wrote:
> This series is based on v6.18.  It allows mmap(!MAP_FIXED) to work with
> huge pfnmaps with best effort.  Meanwhile, it enables it for vfio-pci as
> the first user.
> 
> v1: https://lore.kernel.org/r/20250613134111.469884-1-peterx@redhat.com
> 
> A changelog may not apply because all the patches were rewrote based on a
> new interface this v2 introduced.  Hence omitted.
> 
> In this version, a new file operation, get_mapping_order(), is introduced
> (based on discussion with Jason on v1) to minimize the code needed for
> drivers to implement this.  It also helps avoid exporting any mm functions.
> One can refer to the discussion in v1 for more information.
> 
> Currently, get_mapping_order() API is define as:
> 
>    int (*get_mapping_order)(struct file *file, unsigned long pgoff, size_t len);
> 
> The first argument is the file pointer, the 2nd+3rd are the pgoff+len
> specified from a mmap() request.  The driver can use this interface to
> opt-in providing mapping order hints to core mm on VA allocations for the
> range of the file specified.  I kept the interface as simple for now, so
> that core mm will always do the alignment with pgoff assuming that would
> always work.  The driver can only report the order from pgoff+len, which
> will be used to do the alignment.
> 
> Before this series, an userapp in most cases need to be modified to benefit
> from huge mappings to provide huge size aligned VA using MAP_FIXED.  After
> this series, the userapp can benefit from huge pfnmap automatically after
> the kernel upgrades, with no userspace modifications.
> 
> It's still best-effort, because the auto-alignment will require a larger VA
> range to be allocated via the per-arch allocator, hence if the huge-mapping
> aligned VA cannot be allocated then it'll still fallback to small mappings
> like before.  However that's from theory POV: in reality I don't yet know
> when it'll fail especially when on a 64bits system.
> 
> So far, only vfio-pci is supported.  But the logic should be applicable to
> all the drivers that support or will support huge pfnmaps.  I've copied
> some more people in this version too from hardware perspective.
> 
> For testings:
> 
> - checkpatch.pl
> - cross build harness
> - unit test that I got from Alex [1], checking mmap() alignments on a QEMU
>    instance with an 128MB bar.
> 
> Checking the alignments look all sane with mmap(!MAP_FIXED), and huge
> mappings properly installed.  I didn't observe anything wrong.
> 
> I currently lack larger bars to test PUD sizes.  Please kindly report if
> one can run this with 1G+ bars and hit issues.

LGTM, with a 32G BAR :

Using device 0000:02:00.0 in IOMMU group 27
Device 0000:02:00.0 supports 9 regions, 5 irqs
[BAR0]: size 0x1000000, order 24, offset 0x0, flags 0xf
Testing BAR0, require at least 21 bit alignment
[PASS] Minimum alignment 21
Testing random offset
[PASS] Random offset
Testing random size
[PASS] Random size
[BAR1]: size 0x800000000, order 35, offset 0x10000000000, flags 0x7
Testing BAR1, require at least 30 bit alignment
[PASS] Minimum alignment 31
Testing random offset
[PASS] Random offset
Testing random size
[PASS] Random size
[BAR3]: size 0x2000000, order 25, offset 0x30000000000, flags 0x7
Testing BAR3, require at least 21 bit alignment
[PASS] Minimum alignment 21
Testing random offset
[PASS] Random offset
Testing random size
[PASS] Random size


C.

> 
> Alex Mastro: thanks for the testing offered in v1, but since this series
> was rewritten, a re-test will be needed.  I hence didn't collect the T-b.
> 
> Comments welcomed, thanks.
> 
> [1] https://github.com/awilliam/tests/blob/vfio-pci-device-map-alignment/vfio-pci-device-map-alignment.c
> 
> Peter Xu (4):
>    mm/thp: Allow thp_get_unmapped_area_vmflags() to take alignment
>    mm: Add file_operations.get_mapping_order()
>    vfio: Introduce vfio_device_ops.get_mapping_order hook
>    vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
> 
>   Documentation/filesystems/vfs.rst |  4 +++
>   drivers/vfio/pci/vfio_pci.c       |  1 +
>   drivers/vfio/pci/vfio_pci_core.c  | 49 ++++++++++++++++++++++++++
>   drivers/vfio/vfio_main.c          | 14 ++++++++
>   include/linux/fs.h                |  1 +
>   include/linux/huge_mm.h           |  5 +--
>   include/linux/vfio.h              |  5 +++
>   include/linux/vfio_pci_core.h     |  2 ++
>   mm/huge_memory.c                  |  7 ++--
>   mm/mmap.c                         | 58 +++++++++++++++++++++++++++----
>   10 files changed, 135 insertions(+), 11 deletions(-)
> 


