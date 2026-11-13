Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E3E60A380E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=dGHxsUlN
Received: by kanga.kvack.org (Postfix)
	id EA9F06B05BA; Fri, 13 Nov 2026 16:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B196B05D9; Fri, 13 Nov 2026 16:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BFD6B05DA; Fri, 13 Nov 2026 16:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5B546B05BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:49:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56C07140169
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:49:37 +0000 (UTC)
X-FDA: 85431437994.01.CD134BD
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7847580002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:49:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dGHxsUlN;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qcsr62uFOhvdCv1Z4CFJXXaONdJiHRFO6Btz2367L0=;
	b=NgYso06hpTlTJgngALvS934oIZ+py5Xx6lXB6QdzNfA32lzGu6jJkA4iPMo3c6GyBJlNL2
	P1xw2xeQi2GUeO9PH7snYI9JeyHQ5CfpshR63ZD0Y5yllLIL9WyK1dZba2OL47TnwCmCLc
	zmMzWdAWApvNnW/NyDK/0u3swdl/6gA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606575;
	b=qhaC2CAY/HAwZ37KQOeUTmL5k4HR8P0A071ejXhOH0Dhh3ltAfHDxEFNfOjD7xXGTFNDOA
	nEMDx6BzQwcqto0jXC5fosnDvESTz3Et3AoPw6ufkrfq20ORXGdzjcVIIgn2QNaZyQgxIV
	VAtpxivXdhhKyoZ16/jOkRPpMXhXlVY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dGHxsUlN;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91f0c4f7a8fso25036396d6.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794606575; x=1795211375; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/qcsr62uFOhvdCv1Z4CFJXXaONdJiHRFO6Btz2367L0=;
        b=dGHxsUlNRBh7tDGcNuUN3y99lnzt7ONsTAclS71pTeD7/wEbIGH23ARF5RdNORi7I9
         uVuhKOB8xspeChVH6nTP3FCYGcgRy9DF3dELvikQ1ByxaL2yXHzsGWsgF7yr3daqsW1l
         XVFybE+6ALZgcEVNfHoLWro6+UguEA/49XZ8/EZqWaizs0N7dQkNGrt4rP4di9uJl2lI
         CwTrQiKmQUIhOe56bHkg2cPR7pfAKXkOiTD+iZdQnwaWOs7fI3mANMywUMdJl4Bq8O5q
         5ZUosEHijmL9XFjlil4TypybCRYBF5Q+3cbxG14G27QXizdxcBlPTrDMZvU6wTc1r+rr
         M3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794606575; x=1795211375;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/qcsr62uFOhvdCv1Z4CFJXXaONdJiHRFO6Btz2367L0=;
        b=uwzJSsKPSUfPh7keO2YKrgG0KbYaF4TIknWrRn/xv+Ywd1+Jc9TbrwJDigykTIreWg
         x8P9vEO+Brug0RbTVTLOitr8p1f0yuziblrTJMYHhuKb3X665YmN/T7zfy22/DRpcajI
         27s0f2DcVLZGPs9dM/P4EjCdP4T5hIt73OZ48sEZ26qmn3ORsk4J0BHPv8lWdVsSxQVx
         0L6iK/ZLXw9lUeG8ZsgRGzcpnmMgKZjocSIUxOtKuB+zguDh9PcYPzs48U+NgNv6hGqR
         DhTEsyjM6nG7qXI0tIeY7oT7eYDNichoz0MLjXN8rYSx2GN2lfRu6W42FH8Z+3sKUW9g
         CMQw==
X-Forwarded-Encrypted: i=1; AL+hErF7U29WYMc6caYH174iBmaau+RIIhoZrgYQHxe2ixTEBR2IC8VFQmGoo3XjIjE+dmm7A85rT0clKQ==@kvack.org
X-Gm-Message-State: APuU4Z92sYCS9sgESoJeBdIWf5U5VWUt5wQEJjBvaPiACWOq9pYf5qVR
	fBjOnAD+5cQGpOJp0C8SfRilAusiXUCWvdlZylXDZMcXIQCEyp5pDnkRWQrpArlGeuo=
X-Gm-Gg: AYBFou0iLk8HD88A980yiCv9OdwNJWDXA0PXwn3NRVVff64AXrZZTOrGHjjZfcodCdt
	LuznnflR08O7IA01QY21bYyriXBsmb5j1jbDT0EuGRkvmeAZ/Axf5YoWFtFQSsRXGQFTKxweI5Z
	BM/DpwatIFOcbMT9/TQEmHCRlSebg6PM9FXfbwrDI1FK360gw2mnh0otN60uOF4Vh65ygzkgdZk
	OWrwNBelKyyFMyfCbx86XvN7vXRFHQe5EVmnXbIf4kUE5rUpEj/JH4nkz3+Ns5DZ/ASbZo19GmG
	AdMve2KgINY24+NCDYstpqJzy/bfmQSOz6mVtLPtsUTZukj6Her5qDNf9OPrn0CG9jQgFOgav/8
	7nu7QocWqOCOISA3s5ibzQ68yJY7INinL613Wsx0Eb6ccsa2oBTMqJiNQS4uewv6av48sfQCAzX
	jptniCOuZpYwyTLyZOn//O/iRZuyyvlQ5SwRiqT2lfKBevWYxyRDtn61/ewBAEywoLTFMFkxtn8
	OcIk85AOzgIBAV0VqGYdr2fiXIQbM7kd9C3yz5mIWRfPQl9cfho9Z173ZCx6jtdYxX4/8XW8C9+
	/+AgMs/edTwzel6e73bQTsLTJVGmWd047LspBdEjgRjtuvtPx8SF+3+VPcJgmv8Sx2EBAJ7aXX7
	3R+74Rl8=
X-Received: by 2002:a05:6214:5784:b0:91e:9437:95a6 with SMTP id 6a1803df08f44-91f24222b57mr56835466d6.47.1794606574483;
        Fri, 13 Nov 2026 13:49:34 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d459c6sm29868656d6.14.2026.11.13.13.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 13:49:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 11/15] hugetlbfs: do not grow a sealed file in mmap()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@kernel.org
In-Reply-To: <20261028-fixes_hugetlb-v1-11-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-11-a0a033db180f@kernel.org>
Date: Fri, 13 Nov 2026 16:49:32 -0500
Message-Id: <179460657279.482102.3328777708780344971.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: ofg78x1ysfq14ra9y3w6ijhrdm8ty7bx
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7847580002
X-HE-Tag: 1794606575-780728
X-HE-Meta: U2FsdGVkX18L18UTKiDL0+uEcN0ZR7RAi/2b+UchD0KeP2QgPjF7ITHmkK3Zdd0EKj10cr8/cJtGvk5hKpNxcwUVchZHsThegLIGtquwxXhHmfmBgm46/6ulpQ2SJXmjc99bRclpFjQx2ro/baPKjPNvDbl18N0RuwVBXGMeodBJOa++DQM9GeUdOsMR5ZfcwGaKQILqF6GIaFpalghJp9wHgHA5DG9FjsyTVGFKBhlggHm1FtDQmdqOza0GCH4/GMRID20ZYiZ5E83FQnOd+7p/f6xkJdq4tTe2KvhJlgPlJpBtHIsCfJNbP5w37DNMWw1x9bYFTjXLSlxwUY7A60OlqRGj44eKOKzOV+t7uJdsd51OUw/XLJ/wD5JtKFpZG4BkAHbCY9BPJos5WcMhH+Xa2PfBj/Jn3c3LnxgoA17huSV1e/QRmKB6xXZKGj0VWvAz3aKbx5hKSDoiA/aaduaZlA/mVlwFAZpUJkhLZ5vc6TX0gHAh04CrflHSsmC3d9fWfj1EWYFPzFWF0ePOlF2hJAJ6G/xqOe/ckHG5tdvvCn7GSqX6hDoWcNNXCKcYS64mF1lAUgJNVziNRR7C61LP/XCTs7d1JumgOq8CuXoWehpmzcAbxQ/t1HZvtIKVB19KWvgWUO6DzOK90X0x0KElpCTbhQ0w0BzmLeZ28vb7veTIntIh2U61Id6jIZfS4swqGSxp2Rp577DlPVgonImZWWCf4HygRY3fdgaCm1ILNe3yi75HXIjG2IQPIU6A5hXS6ORR++TVw49KLw94WifNZflRJll76cD5l/s6K4iV6GwtZ7BNvzvPyAPLQmpbQjSrkAdoX8Krl1jgtaX+6lXp44XxCa+8udlztefWfiTrfJEUdijroFXuO+q+zPg0cYoa5qokP9CEQFfO7ubqvG55Z2ULe4/wl2adIWWH1HO9p4Z/tRpafS4AueZdBeO0u6HhbS4jctxOEsCDyRa
 aFOiM0iS
 wKU4pBJobl3ZfZaaea3eIpDaIIu/AXO+1BCVUJCEV0Qp6SLdr4uUkwPaaww2wtqE2IMXuAxeAUiIKNT3y18kdyYd1MBTev83yIA0nzOAkaJ1RXIHmRPp71pb6q9qmAU0HstDUHV6t7fzo9BQE1zg1WLQHDHs1mi/8iF7J2YJO5M+CAcIeWdGWYE8cLUB4ox0AEYVjHhaeeYwoD53gtS0xLsMopusP/Uj/Uo7Tz8ZFwkVbEXlOoknMFcOPur5uBn43UypqjSNMgzj8iaYCBWPiu3w715NRrLMxSnvfvF8BCNJSYR7h2svD/qZa5NbygPcwH1oQ3jyqX6YByvsT76/HuqPtI3OuGY5yIcDb+DPipWqaxDVcMss6zb3Y5MjkvM93QgGfNBaEPr1A42zG+JIxvCsTeWctTFMbiVHh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 21:13 +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> hugetlbfs_file_mmap() grows a file when a writable mapping extends beyond
> EOF. We are missing seal checks similar to hugetlbfs_setattr() and
> hugetlbfs_fallocate(), allowing a user to grow a file that has F_SEAL_GROW
> set.
> 
> To fix it, skip the resize when F_SEAL_GROW is set; mmap() still succeeds
> without growing the file.
> 
> We currently also allow CoW mappings to grow a file. Disallowing this,
> maybe even only for read-only file descriptors, could break existing
> userspace, so we have to be more careful. QEMU's file backend is an
> example user that might rely on such things, and would suddenly start
> getting SIGBUS when faulting in memory outside EOF.
> 
> So be careful and focus on F_SEAL_GROW for now.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: ff62a3421044 ("hugetlb: implement memfd sealing")
> Cc: stable@kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: drop comment; simplify+extend description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reproduced by growing a sealed memfd length from 0 to 2MB.
With the patch, we stay at length 0.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


