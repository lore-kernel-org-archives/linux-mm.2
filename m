Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADBACA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7078E000F; Mon,  8 Sep 2025 10:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487598E0007; Mon,  8 Sep 2025 10:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34FB78E000F; Mon,  8 Sep 2025 10:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2358F8E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:59:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF3D4118692
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:59:55 +0000 (UTC)
X-FDA: 83866392750.25.CFA4786
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9145314000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:59:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g0azDLjH;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zj/W2A1w620z3uj4NM/KYzIZPfPCpjNHUO9sqnkbSZI=;
	b=l/3MqK6vp2wbpyFohneNX1bdF0DE/JXHqoQTGpvb7hlnGFuTmkg37/UVBPx1aJLnNGx0a/
	8uTnUVbSrMfYX4anlbWpASzNP0lITu8nwIKPlJBo36MsBq4OrE48XqGB2vG5De5gNDSBp8
	bIbY7XQSd/HV2thvPST4fv1/fb9y4Rg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g0azDLjH;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343593; a=rsa-sha256;
	cv=none;
	b=xonykV9HTRNWnCQUIwPo/XRkXx6wc+mAcXCCGiwwErdfaWfIJA2+o43H2G6QmTBxPGX/dm
	4UuHeh2ZixQ45Zu/nvU210IDIGOSEhfUev4hfOgHkzsIpyip660xKDo3at6egrTqgTlLSN
	oCczlKWLZ5NihRKVmBVhrmuNgQhbFrM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757343592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zj/W2A1w620z3uj4NM/KYzIZPfPCpjNHUO9sqnkbSZI=;
	b=g0azDLjH2FGswG2EkIm7gDE9ga15Rezl2FR4a2MZUO1iV4FbT08oQ4W0B/MtjDF3b6aqR0
	xvj8f0AZZwV+bRgx6SmMSyn0sh54mO6mDVE2EIHTo2CQakl8fvZn9bbE1Cy58+5j6UqKxg
	J3ZbY0ezupWWsXGlPb26pwm98kcoz5E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-u7dA2CltNGua7yLzKNh49Q-1; Mon, 08 Sep 2025 10:59:51 -0400
X-MC-Unique: u7dA2CltNGua7yLzKNh49Q-1
X-Mimecast-MFC-AGG-ID: u7dA2CltNGua7yLzKNh49Q_1757343591
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45de5fdda1aso5112325e9.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757343590; x=1757948390;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zj/W2A1w620z3uj4NM/KYzIZPfPCpjNHUO9sqnkbSZI=;
        b=STFx3FxotO9jcLahr9QhMC0WSe9BwcNr+wD+W5PqRxQOSx0Trf7Sd27K59evmjP6iN
         azwQ2queufZoBI/5LdESkNFUGcbS+Ho+VF0/Zty+W5wRYKskBttJOQplQJLwwmShGKdI
         9WhO0+tEhBfmLq44V1G0xaFZ/Jpgoqm7LQV5qKZ7ARnvKKS2vyQ7LpxbjONYMA4+mWbb
         gbZBdM0XROksHy50V48Mh49VC2mLhtwEI4L9q/Q0DwK1yzygorsroeeryn7x9sKNqW7B
         rJXmPwFRU5k1M9z7JTHurUXtFOhAhKFTFGQRb5M1yMKQYFzZUqI0RnUSKrki9zcSROKA
         rBsA==
X-Forwarded-Encrypted: i=1; AJvYcCUYjtljeuPdhnVoodnLtLTIbcN43Dig0B4FNKDUjd8I6+a3aUvGtm3L8quSL8TOe9/KIKuPJy1TkQ==@kvack.org
X-Gm-Message-State: AOJu0YwuvELWII4hgx8U1JKLcAEWL/B9nTDWPXtDlMmYl7YgRUgYUPvt
	d3QhXjOuyq05VUBuWyzSprqfv2NQWxNc16hsEqNomXvVgsoRWKyDmxh69TbH14bjcpMyLp2W1Q1
	focCpa3lmbA2zM+E0/vs5mxy81GgMNwYupfTYlFbduIIg94Oap7mU
X-Gm-Gg: ASbGncvty5ZEcewidW/owUiXLU6giKDvmum151oTuLP/QBRdiWXiQxbtBm1BVGuf002
	YHYFZFvhuUy/JiYj6FT0Wa1FzKmb2yxevBtY1ZtStM46Vouk18lq0TCRRcx9f9vBIZ2bzrCmUXv
	jWD9bl9/OVn/jjJoR+tSV2glU5vAcL5ThoDH7yZ7dfAg2CHbi39Xos8dKcIeY1OhEvJux90YPHj
	aJe8dStWeSA9g3OY6NygoPD07vcDRRW7HhGh3kuRUg7Hhy4oclk+P54zpa0j3bnZZxsZ7cmulyb
	ekgJEfZm4wGsN0Zzb+XMpKslukB+VnPJo/wc+IvEU7UXAltwOSK8qMDtjV2JHycF5lffo0CYYE7
	TIOVBenl5LnggGqtbB0m4oDbEc1tGae0rHSXOe62zoUEC9meZPoJsxpg7kaqRMv2y
X-Received: by 2002:a05:6000:18a9:b0:3cb:5e64:ae8 with SMTP id ffacd0b85a97d-3e636d8fceamr8124661f8f.11.1757343590421;
        Mon, 08 Sep 2025 07:59:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9Sl+7I843zNJKDyb1TeCWtEYDDRjw0tVeJKWAZDqQ44OZCVI4FghBC+qHaOA5/2UP0jatjQ==
X-Received: by 2002:a05:6000:18a9:b0:3cb:5e64:ae8 with SMTP id ffacd0b85a97d-3e636d8fceamr8124577f8f.11.1757343589898;
        Mon, 08 Sep 2025 07:59:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3da13041bcasm25975587f8f.35.2025.09.08.07.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 07:59:49 -0700 (PDT)
Message-ID: <cc59a58c-266c-4424-9df1-d1cec8d740c5@redhat.com>
Date: Mon, 8 Sep 2025 16:59:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] mm/shmem: update shmem to use mmap_prepare
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 kexec@lists.infradead.org, kasan-dev@googlegroups.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <2f84230f9087db1c62860c1a03a90416b8d7742e.1757329751.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2f84230f9087db1c62860c1a03a90416b8d7742e.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RuvIq-cQMwQCf0ZIW0m99p1p2sNss5c1fuiXtNfhC9M_1757343591
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9145314000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: aoijkkfufsh4sdz9o63bhjqacz9dtw8r
X-HE-Tag: 1757343593-220496
X-HE-Meta: U2FsdGVkX1/210ngF+3pyJOlWaxIPJk1MV6XsgscTlRGyW3ZzEzMl/FNUCwMIe3hbHaC0HvOZTQCPP0QfFAqo3JmCKdSDMwggrtA8OgJbWdu0lTs+8nzJT4wdz8h3k3zsvr4NIBNpfPyYOkWPjaPPx45L7SYS2jtd8G9j9KhtS095UAyAWvscW8Bq1BWhJF/b1yEs9wzIpw8V+sfb1Akd3WySK6e1rumD1Pr5zgJPOjCZl5TnBtK19BXQUaJIiqP21Bi7b6cIIP6vlcZmZcBaGWhdP6B7VJyYc7ZHqa0aamo8C3Exiy0YSl4hulGi4/7diOhmSpcEEAtUhCltoqbrX5WJVezZBjXPJip0zLKVf2sGy/YvT92oEinpfcd8tO7Kqnr9jAm1cZQ9n3QtAkaFLpDC4RFTT+zlKZpOc7oYUm25NU4HSTZsG37gbA4pnskMnazcx7h+hVkaSYQHF4dFLjDzeyWo0NqYXlIYx4WlG/BWWXGm74tGShn72yOJ62voy14yp+j2W6b9TE9iq1rRs/BVc3m+uW5PqK0XX0jFZy7MbVnGwW7e+/cwBV3hlasKkHLjMuTzRKb5UtCOFORv3Tns9VZC7zQ7dSPral+fz4Fqj03fIdWcCCc848mYqetFtATyHMbAtPGMW8VxC7ds3uRZBRaa250GvYgs1UZtX6sqyqy4xHMqWtYn1kGXELg2T4IF4FfxzuXQS1V6QqLc7/Y+ctvuaCjQyCNMcDCrVBdHiA0tHJfggGwmCovtzZzO+PbTEq/bpBAwLZ7VKgwLI/Zo2IDu7aUCaL0n6xWYO0hnnNsterJE1qe2+9zLW1jOnzDM1LmYYwY+OvNYdO2sdjGldT2qWTm4n7gzw/yJLbB9YuMwDKY/bmhnh+PYxKZ2vAtFzlJIxFONE9uyONx4vTZ8hUj49UaHfZEOQU/6avdkErv5tYrdbpA5T33tEO/6v1L1euT1UkFe0vgxde
 C5S80pfh
 tGjHPM0CpO0ZfOWN/SXYj8qsK3XI2aloOFfPGiJIj6R3Uank/2GgdMUwNIsaPu4y/qD602COF0FthvQSnBqZ6d1oYXVpp0I3opPMFxkEGUqVMmvnkKX02cOnzorTGNGLXD2GPki6NMMbvIq4Dub1hJXotuA7iSkWHGgo+/HYaP8JRV+STZGjWDeckazr0sdzB4d3CR80c0vt6trLuxUeCGWzsQuSKzOFVCdl4LQWBB0GTblh7SuXCwxEEQyPPvpztG2py1PlOPgDyynJhAoSNDWgNSjOUPgLRgk1TL4U8XXuUlP813m1BVkBBq+PqnyI56InmbBWKioDuPEOilUqfz+7PX4N5UCpbGEVaLW7mK244BUfKPfMNQK+HkGpkqY2ePBspNVMIYZwHMiCpfLWxyzJgk6+/t4YT2DMQ+TQ4x7QWXwLAKN127aGH9OZ+cnVgthQEPYYH0E8QmekoQIJXNLBzEzLevLWQ6Ih+EeEHiRiIbBrf3YsCTNa+9/DmDrtpjYxtJKcYks/+8jgRdDCWGyQuEj6397ub2C7bXSqTpj8x9Gg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 13:10, Lorenzo Stoakes wrote:
> This simply assigns the vm_ops so is easily updated - do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


