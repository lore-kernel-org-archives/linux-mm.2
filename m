Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EB1C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A4E6B009E; Wed, 23 Jul 2025 06:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741B76B009F; Wed, 23 Jul 2025 06:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2FF6B00A0; Wed, 23 Jul 2025 06:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47A5F6B009E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:42:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3A351405F4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:42:40 +0000 (UTC)
X-FDA: 83695190880.19.903504F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 66B751C000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:42:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JnH2x8C8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267358; a=rsa-sha256;
	cv=none;
	b=48sXF4r359VphKOgy4PHowkXT6BCtwaRBDEEEof6tSFCwJ5yaMJt+BWI17QKo12DSM0B1q
	MvK60wUkq+XPcSRNnCdFZ0BPgeqoD7HwRh38ZVaeaiPNrkU7xGnm505GIlR1XO9ia3w3a9
	4J+nGxw0YY3jjdoParjJRXrHqBsm7Fo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JnH2x8C8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5UWNNTGLGmTszxRVUFTgBdkzUSoxVU+yLV4M7VYTtM=;
	b=uqAqynewgkQv9Foj6GjDXEPH8GJ28eerz7j8BE5Mr84uNcOCKBdVr97v8Vv4uJZ8NG3aQv
	wxxGfhqtGAEIDvf+EU9Oc9qc9UHve5ONP14gWOPpTHzd3IbOSv/vlKMxf6CKrBsCSj847/
	rmrEzOCZHMj8HSerl8/7+EVXIcvtGc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753267357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q5UWNNTGLGmTszxRVUFTgBdkzUSoxVU+yLV4M7VYTtM=;
	b=JnH2x8C8qNKXKIZW/lzgnjNO9ZYRbT8EYmDo/uh81k9dcWys/5Mrh8WSLvP6qqknUFJXOw
	rLGwOQhrBDNR+Hz5eSIsfIe3nhmNCUtPVJKgcS4MVAU1oPX5lwokUUyVkju8EcobRTf5E0
	3zAmaYVd2gAPVFo+2eM2Pd7Hn7JYqcQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-G2oHN_PPOT2T6unG7iKicA-1; Wed, 23 Jul 2025 06:42:34 -0400
X-MC-Unique: G2oHN_PPOT2T6unG7iKicA-1
X-Mimecast-MFC-AGG-ID: G2oHN_PPOT2T6unG7iKicA_1753267353
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b39cc43f15so3075631f8f.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267353; x=1753872153;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q5UWNNTGLGmTszxRVUFTgBdkzUSoxVU+yLV4M7VYTtM=;
        b=URZr8EYhNnQreMDXPmPazX6Oro7AV9ZbGN2ts2qWhokbbcJUecW/B5ae7bxcD/N5gX
         FRAOYDASNImRI8FkbukSU6lorIhEo1+lM7MYLKlm3xMPGf+1RPqBBnjLADuuCrD87/w7
         cI9/ObEr90Y37F9HsW44dvGBhVcmQz4A2F7J5p3PKVN2TAKo8ZOUTdCYOyvTZE5tcfgx
         GLo0ZPLIFEry0EcmsmOsuYPk6KmWA291q9Y3uMW4uwWmBpoDnCeqPPLrX0bi678nfQ2u
         R0kV6iSpI/rfk1Ebp6az59VK7lXEKZchQ7qhmAvUXyYsLzXX1Gk2t5W8B0ELCnoRksSF
         oJtA==
X-Gm-Message-State: AOJu0YzbCVAKz6MMg5q1Viync7bhIGY3Pr5AhpA8jhX3C0TT9GojrGrO
	ZPJ79d7adohoQuU90qTjARhrt9oaxFvbd1oyzHQDM0jq+fJMYpa+aK772Zg1Sm26VXjLBCdo46j
	ESCwQPpkB2AimO7j91Gjhdbp1y8t6qeGb5I1R0htVJ4yvl2Ji6iD7
X-Gm-Gg: ASbGncunWtxSTk9+rZ+KPz3Mqp40v45JGyXS1Y7Fm8+aD+ZIfi0SbaLWy/R4w79kZ6p
	eeHyXPtnP/FLGWlCXRlk5Ln9UfySUBC/kCRqBDHNImhBZjSxktHSwUGWXfxcMmPvLP/aYQ5yko5
	6yEYgrzK9u0dy9XAOPpfEw00fJBlSPKddXmZJ/oXjg36lNuGg+8Hi6mYlVrg4sfsLoBPbcDQ08p
	ZFiMa0vkbdMyRNpX9AFcY5CdsjRnSiuzeMDhO3P+Ln97UAUVgZLac+iEhgHgpyWy53v/Doluic5
	CSffL1EjcSaxHur4kv9M+AUa+EdSxHILmqQODWQKfWARECkKT/ZisbxZ5NTSxvEjiI/dH+H2X42
	M6hxWda7kOnuk8EKnzKpJmLi9BokhRTo9/8t9hq1w8SxlU00AI8Q6htzUa6yQXUniQe8=
X-Received: by 2002:a05:6000:1a85:b0:3a4:dfa9:ce28 with SMTP id ffacd0b85a97d-3b768c9e9c8mr2141929f8f.5.1753267353155;
        Wed, 23 Jul 2025 03:42:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBt4+93UoX/205gdSVHqW6TkCtkYcBPzB53eQgybG4ryPkzfHwVCMU79xDSUPLge1iyPsKBw==
X-Received: by 2002:a05:6000:1a85:b0:3a4:dfa9:ce28 with SMTP id ffacd0b85a97d-3b768c9e9c8mr2141897f8f.5.1753267352597;
        Wed, 23 Jul 2025 03:42:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d732sm15854726f8f.61.2025.07.23.03.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 03:42:30 -0700 (PDT)
Message-ID: <da0ef45c-7e31-4e87-a4f5-c320c25bc7d8@redhat.com>
Date: Wed, 23 Jul 2025 12:42:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] MAINTAINERS: add MM MISC section, add missing files to
 MISC and CORE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PbKTkjBX0-Me7GZ1b-CJDTB_614Jths6qVkEoRf82Vo_1753267353
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66B751C000E
X-Stat-Signature: kjnkd6njfo81uzyd6x4w11ictft9j8i8
X-HE-Tag: 1753267358-594362
X-HE-Meta: U2FsdGVkX1/eiBRO+o30vbpgmazr4tx8CCEkL9UAFxaVx+rbwovFBZss9QjDQZM6pBpEsUz5s+mfTOeVM/noNbLvnugjT36MaGH7SjhyavTYWBMxrBYiFvEihuggKEuWpLaxidzduz1/d0ecmdbrwuAx/TyPoWYwVZftFWnO/Ilh3tIdHf/6WH08DsHP8Uoiuu7XSiweJdsvKBJOkvKEbemK7yfo5ZiQqRfBKZDhsYBxWwNaiMXeFpRTZfLzJ86v4GjI+3KKF0ZOSjKsBXkFXLw2bAngd8oJOyokzN/dl3iucg+qiJ3kSJmB2M1HariDO0ZP6WaDhJkXp4Irt7Mx4MSzDl3HdMIukD6tR0YVph6Y17uGNkF3DbE34T4RTiU7sdxQ1Nf4/2P7KDCjcDh4WCaHcmNEuNgpOKwLIOiTrqGPvj/0003R1w/3FkCB4P0Fhw9spBWnPLDxaLrezJFoZD4TuhvGA3qZ/A2VnrXEbrmNy7A2hWoU0POS8tttvnBsMh3/T5or4RfAd4Z5MdR46xth0U7hmIMRPeLdJWpaFprwqOz3YJOJng/COaHDG+zGMwDLTvdaF0nJbbRliEQdWjbedPWcItC+u/7JDWGZr5yh6X8GJUTHebqCNIdH4Qw8QQWqkyP5MOzFTzGWZ4ao7FeXc/vAlJjlIWBpt9+1sJAsRSPfuQgqU2TLfG08g5qHedxqEJmViMf+P4HEz8N4eepJ/gVvplkNLrwI9Quu1iQkuHN3Qmlqujw3A1sKcUBYjROy1aJisDhbKc8KDyfAoo8Eja3XtqgpVWAMKt7Fim7b5rERhRHPMcfmGWmE3kNpO3sMRpBSbHaKkS9ms5ukG8VYg7ZpVxMSauMECPUS/dHl5+iD4AnjqCVOI6kKEAfv0aD2PycKT2N3iYrUA9iVGqjHQy+ji6lsnjqR9p5o/lq3N3JDSe/MtOQ8JS3D2142ejEdYFar1hmWt/T0pMh
 IE0Jqmk3
 z4jZjPiazT+ZuMGK/VNXvaW+7KNFAMxtqihhRnEcx6tXgurTusZYw2Qzf7tCF55jM8GwyfujSLZZ6aUTj6Mm5axN4tjgj1Io4274ZlyMNH1D8PpBYWIk1z6Q0evYOQ9FVxkk8KNH5We3QOF4qiyty73VuEdcXMvOZK5XBuev74ddqkQC0jgsKANPUA3eWES/SP2g5pn3jkNWqBppqrKP/y+sPIwlHAxgtsD7O8wQQYAqpa45IFHIy6ru+nRPzzCwu1ZpmjY2N0DtMjzrodvwbSvcj31SpR8U0Z1L2yGvub9fRCS87iT+xwjKswpPubeGIFv3p5nzhvXomJlt98a20ykksMzW4rnMtdlmOBHi7NJL7ofu54A5RITMqas5O8T0+7jnAn2aBuQ+uFoDsQOpCRh79H7pMCvMvzN7jn64nPTsRya1YB5msvZSzD1gTcpdFTDqfNikQ2Tn/V73aTbM3ZU7DAAcNwpymr5bJAYwqonRqmjVO5Y3BkunwOeqqK2UWbZHdNb2cQ6+mVZPBL03tOKLOytB04SvcMF7dZ/uLa7I49eHqgJmf4gDra4Rr/22CK29dkjOCXOjjVjYlX5S+Gjvf0Cndz+m7R5Mr0fd1F63a8LEEgELQbej1g/EdtIoM5w7kqQHjbFRseOmfaX9rNm/f7sLSCMWdUgxpKF691+5MhQsJ30tApb+iluPLaQxmlBcRDM6hgk6+qc1JgGWLCkPJUepR56Q9KWHN0pSAdDLRn1PWS9rIUITL9TNKNDICCigoqSmqK4zcoB3X3rKURKqMXlAo2EQIO6Nw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +MEMORY MANAGEMENT - MISC
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	David Hildenbrand <david@redhat.com>
> +R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> +R:	Liam R. Howlett <Liam.Howlett@oracle.com>
> +R:	Vlastimil Babka <vbabka@suse.cz>
> +R:	Mike Rapoport <rppt@kernel.org>
> +R:	Suren Baghdasaryan <surenb@google.com>
> +R:	Michal Hocko <mhocko@suse.com>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/admin-guide/mm/
> +F:	Documentation/mm/
> +F:	include/linux/memory-tiers.h
> +F:	include/linux/mempolicy.h
> +F:	include/linux/mempool.h
> +F:	include/linux/memremap.h
> +F:	include/linux/mmu_notifier.h
> +F:	include/trace/events/ksm.h
> +F:	mm/backing-dev.c
> +F:	mm/cma.c
> +F:	mm/cma_debug.c
> +F:	mm/cma_sysfs.c
> +F:	mm/dmapool.c
> +F:	mm/dmapool_test.c
> +F:	mm/early_ioremap.c
> +F:	mm/fadvise.c
> +F:	mm/io-mapping.c
> +F:	mm/ioremap.c
> +F:	mm/mapping_dirty_helpers.c
> +F:	mm/memory-tiers.c
> +F:	mm/mmu_notifier.c
> +F:	mm/page_idle.c
> +F:	mm/pgalloc-track.h
> +F:	mm/process_vm_access.c
> +F:	mm/ptdump.c

Another thought: mmu_notifier.c and ptdump. have the "core" vibe to them.

-- 
Cheers,

David / dhildenb


