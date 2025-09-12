Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E32CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4FE8E000C; Fri, 12 Sep 2025 13:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55A38E0007; Fri, 12 Sep 2025 13:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FCD68E000C; Fri, 12 Sep 2025 13:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79ADE8E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:57:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39A63140903
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:57:31 +0000 (UTC)
X-FDA: 83881355502.09.4CE8175
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 09EFB40003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:57:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QpymrnyH;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757699849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWibyIDQ5IpFu2wsAavMRvUdSscXCQdcm/6IEQcQG6k=;
	b=ubfMREZqbCa/+AGRzC1ljyw7sv3wHVgAhqmJdeRErAtS6Hsqimqhb+4k0nLlA/9Mr7+0Pd
	2ewIRkb8nhIm0q03WEJzZiv/9eQbyNI49q87UH8CNtKa+UQEA2BVkC8QUGH8elQpTWEFLH
	2pqpFjQgXQGnjCIquQZYhokOvEevYdw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QpymrnyH;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757699849; a=rsa-sha256;
	cv=none;
	b=Scy5tC2ghvPT29Tp5KtrDdCuIUIIukZx5J+uMxu0zRVUOhHlYgLU4bfW8d+CYP3Qi2z6/q
	W/cDXVQoTgEsTt/gOA49NLxCC8eiV/hueu7CEjfgZjgJS9oSPkc84RcNEegDhshXpdPmuA
	HzYqjWOZ0ySechNbd1mowtxDHSVsz7A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757699848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vWibyIDQ5IpFu2wsAavMRvUdSscXCQdcm/6IEQcQG6k=;
	b=QpymrnyHxP4/vkZHkz1OXJMaGwvuHlaC7rXlb/D7835rm72ugbWqlpL9WosLMJHHgnPbKc
	zTXDjcWs0eAQnqQfcSDoI7cvOwQE3LM6bH7NLklCv60TXLDKMyaH/B7j0KqZmiAWoVHnxb
	0bT0UTrbZ2XHFB7kO93h0r/0WCKodD0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-0802XmHiODSnv81kAPI8fA-1; Fri, 12 Sep 2025 13:57:25 -0400
X-MC-Unique: 0802XmHiODSnv81kAPI8fA-1
X-Mimecast-MFC-AGG-ID: 0802XmHiODSnv81kAPI8fA_1757699844
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dd66e1971so20091095e9.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757699844; x=1758304644;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vWibyIDQ5IpFu2wsAavMRvUdSscXCQdcm/6IEQcQG6k=;
        b=dZqaKcoxNuUgceNvrXlgsumHJ72Li2p0PhZ+vNkO3sljylwC8Ez0N0oWj9quR/Ag8H
         0Q/egOqqLrXUN5nviJx9v8uyupXIRRsmmDlkitpv9RFhWwI7FmBIU6FQ30XHaIaYuRae
         cZJHpOzgF4uZuvFfA/L2xn2a4+p8q3aQeNVC95dh48Fh/KRQ81+ViSBsCGiz+2p2BQKo
         7nkSEE4/JTzcVDQkw2iUDYLzgZpsXsLRHAUIpzX850fJvnxL3ZcIqrz3JISQwlk1zzNN
         tp8U5LG+SyNFT4umyM3wrul1ZOCL/M3C6ShHLCd62k75t17iktA6/2ZLN2ENGfL5QUMm
         81RQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqXxBgugS8wPz8Lwneen4kXt2c/YY1BjYTyA5QBSoFTZgQhSViE0dJ8oddqJ1Vc95oQB/bMtbb7w==@kvack.org
X-Gm-Message-State: AOJu0YzECsTSia6RqEruHodO5EohypIn6F+HxAsuSt6fq4Oh5ae7F8XT
	tNg2tXMKIYZlbDq41P60y7b73QBo4szEPz85kWh+WaK6TyLjzdjti1gdw0kP8NMbYTn6Nzdkjtm
	4fWXzxdggtICAQbixM2DapjXg3iV2Zfo6MM/FIO9x3WriKMZMtdMr
X-Gm-Gg: ASbGnct1V5QWc6NxYkRwalk0jZMshi9oNKN1NB1w+/goRm8nOFQE5LIF2eBMKAX02QP
	nh8ELOxEvvNBiX8K+lHdds0LYFJS6y2ls1ifcOLoVw6YP3HkGUKcg2OPDL9/kgjNdWes/nHeL+j
	6E0zfh0Cbh4hrQroluJ33HVb1H9ujHRM8rbP5+IjtCbi9V9TbGOD9PU5wbWoclJODG1C5SS6zhq
	imSiorl2P/+lP2/6Fp4dVM1sHmf4n+PG3d8YmE6vY86Sr5t92gF/Xv5tcOa6CTfIZ1PJfYS4CrP
	KVUUemM6sFZwqLXhLGmJHI8Yui3jRqg3igQZyc2fT3hybf6BkMg7eBIKFU/DHj1hvuxEYoY6ZfC
	5ZyHc9fS4BBSGa2gIe4Qq5nc5eyZOI4k1WJeH3uMlVZRjP1mgR31KcDgk3iVcUo7+DQs=
X-Received: by 2002:a05:6000:26c6:b0:3dc:3b91:6231 with SMTP id ffacd0b85a97d-3e7658bcb7cmr3820043f8f.12.1757699844088;
        Fri, 12 Sep 2025 10:57:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAJ3BMi02cBWJuMziTY5RdO0f0DkPd3wf8o1VrSv24bbQm1ywYm/YJSelHvVNfN205viam1A==
X-Received: by 2002:a05:6000:26c6:b0:3dc:3b91:6231 with SMTP id ffacd0b85a97d-3e7658bcb7cmr3819999f8f.12.1757699843578;
        Fri, 12 Sep 2025 10:57:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d7bb1sm7362076f8f.50.2025.09.12.10.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 10:57:23 -0700 (PDT)
Message-ID: <97117b3a-1d92-418d-a01e-539c77872ff2@redhat.com>
Date: Fri, 12 Sep 2025 19:57:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/16] mm/vma: rename __mmap_prepare() function to
 avoid confusion
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
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <9c9f9f9eaa7ae48cc585e4789117747d90f15c74.1757534913.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9c9f9f9eaa7ae48cc585e4789117747d90f15c74.1757534913.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FQrQPCvz8pFewEjmIiVu4kcDRmHFQPIfr_zslvA4MhY_1757699844
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 09EFB40003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4eo6p33deaa95us9dud46zejct8ksoq4
X-HE-Tag: 1757699848-366882
X-HE-Meta: U2FsdGVkX18wIkbVkbrdIgjf/tJoyOsASFHW+WHieOrATGgVpObqaCbP0dY+zPlrlVVowtuN8j2bYF3fSMh5cYsRW+mJH3cQkXzwFCsqnbEXfXv/1aI3+Fmecej78dYek7ZTmuJoivkzqabmqNTCK5U54hVXqKHHBuYbhQ8mdXZOUdTC2RXEHmeBhQjw0/Bvb1g5veEEJ4etuIlwPuITr4AiC+ix+Smag97jsFQ3ztiYCXX04B90oYxkJdblMQU8dXDW9rolXtWvNJrnunnKj0H7aGCmEW99VUVTbl7BNUs9FcV9z/AqEZKgnWBX/qL08H1aEdoLhy3k3uqF4pnhJdqd858Brzp1Mu8L3NnIo4XQsesNrGB1C5bHeazTEkgsCArPypvR3LZOlqJWpP6vB96R2tRlL5xje2KBKZrC7KAhEy874QMLU9DOvyo0N0gywSqwBzIxS8J2DXs1rRghD4/mzaqfSt1BA1lEacI5bBz+qB2jmP7b4Bj8lur7vbxBz394Gzz2BwzvPMJl2TKssgrhy49E4QemP+YOWdtixnLXRaEIwSmdPef6rKOr+Nsik9byEiiCzlYCoprdlwuDaZSLYROI6pb9p38Xbyi0xy0w/NrlXKJ1CFAVwTgpApqNTGAdDrdF4SBjYS5YP07AwsxRJldhVCh0rxvltfL8rtZFgb/GDsL9Ha+8a+K8/WFGos24huQ2CTPrHSERZh5oCfY+J7FsaDR/Ab3PiQ/B0NrpitufjYMdCKo8PrfmT8bBONm7uUkSJEHSHxWLbr8bp6U1llewMi68daBrrLb8hCz/yKp/En7gkwNMmbv6vj6s6uQSYpXYSC+j1t8RnRQCKowoFs5h6WwXtKKqaPtpVWqIvW2F3aJXwVfyQQ5WD96/tn+Mz8gXkmnEQPzSI+n670XDpaN8FbswDJTjp6ACakuCanz8KlkjZqW9+CqHabSmvR6iWZchWcYt1zb2qQW
 lgyok5iX
 M00B6g6EjlqV/TWysKahbTDKhJNQBbIoCj822gejrPf/A6LtmZ8tgnzo0XdsLx0124xPPMrvTDGdhVADkrBMec5fuBbpQRAKMDOaG21PPpI3SJBx1vjZC8C54OfQ8PYO5VPQn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 22:22, Lorenzo Stoakes wrote:
> Now we have the f_op->mmap_prepare() hook, having a static function called
> __mmap_prepare() that has nothing to do with it is confusing, so rename the
> function to __mmap_setup().
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


