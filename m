Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519D3CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05DC8E0014; Mon,  8 Sep 2025 11:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD898E0001; Mon,  8 Sep 2025 11:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB9D8E0014; Mon,  8 Sep 2025 11:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3D88E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:24:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 474AE1401CF
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:24:33 +0000 (UTC)
X-FDA: 83866454826.27.7D0D5AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id E24B8C0009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:24:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="htBqgRd/";
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFR4fsYCPzy26gT9T9kYZtLy/SzbzsJmYYmla+zsN4U=;
	b=5V7sLKg4O1eXADeNqLpX3k6+noeGaM3cs0aIVkd8jFAAw2r7Nw5mW3l4UEKjsSTaF2zbX+
	GCSGtLhIVx2IR6HUwidO5e9lzyTheS0y45z3hEjlPxO+LzPZgibB1QPpzaHa3TWLAsJkIs
	BMP43vpb9GW5qRHr8dNryTTxubFmODk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="htBqgRd/";
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757345071; a=rsa-sha256;
	cv=none;
	b=kvDBPkLj+apDN4D2NWWPyHcp8YQrs1nJh9xPH+VmeehyB+OkHwYmO7ICS/w6yTzH2JoudH
	w5J7HL1YcqLqESlmWiNh+E2eLLI9IYw7QL0eYLVMwIRAe3JsuEh3ScQ4munnFB1JIjJpcP
	kmAHWeHQLKk8Z207FwFcus7a5eanBSg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757345070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OFR4fsYCPzy26gT9T9kYZtLy/SzbzsJmYYmla+zsN4U=;
	b=htBqgRd/qyFNyyTi4BFWHd6hVcEbYVVz6ntBKZt3GbW6k1td4G6tjkcFR4qz6CzYujKRix
	XoctZf6Yk4TZcG69SM9UE0Jow0nqjHNoEXj8RPfDS0ehPu3zf5vIzEQi1zeJBtduz9VrzP
	VTxNheMK1F6TDnek563RUKtJpR+Arlk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-4Obb_63wOzikj_CtzuaNCw-1; Mon, 08 Sep 2025 11:24:29 -0400
X-MC-Unique: 4Obb_63wOzikj_CtzuaNCw-1
X-Mimecast-MFC-AGG-ID: 4Obb_63wOzikj_CtzuaNCw_1757345068
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3df19a545c2so3477285f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757345068; x=1757949868;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OFR4fsYCPzy26gT9T9kYZtLy/SzbzsJmYYmla+zsN4U=;
        b=Hr87jfI7M+bxKt/kevsksfQJpQ9uA3JeaJySKo0E6CLU9DRZCv7VTP5NDhupjDYVQ3
         mzgaFpZyyFm8aW5C29UzSUnDmc3VM4xvsWIiXHEq0NfcPZ5Qvz2xR6RBaGxSllA8pmXS
         HctyVt9W+RgpA33A5GlCjMrWEPxxic6XVP5KLSiS0055IqK93FZEtwk8wiCR83172G29
         9jnnpU9jQosDCTQnPcG/EM7VQw2lmEeR/70qs40tIdoqc8RWNnz2ftsWNn8af6QTkbfG
         hNX1PH0yZQB7rBtAakc2QbLJUVbyeLx+FKDlRE1uEDEhKSBSqHItR/V7KYhERRMnxX0z
         gSJw==
X-Forwarded-Encrypted: i=1; AJvYcCVvxmhf0wjl7Nh5prD9nQYijaYEih1z+d36z7QhXY3A2mYwYv/32vDj9yq71ztuYGi6IwlBp6Qdhg==@kvack.org
X-Gm-Message-State: AOJu0YwYoZD/Xjknjhmr5KFenyXdRXXxrCTbC16PcMNI4NoAl4IauNll
	S4NPEIKLWmQOvqxu6ln/W4dIkHGwIoUz118m+sdzkApq+kKDIcSpi8xIPCxa8i+3tqVdjopuqe0
	h7V6Si0j87Sixv4vx0OOyvC2ixd2KbqLJAOVt/APrzLT7PCfRWapr
X-Gm-Gg: ASbGncspZwO4TetP0DoSStdq/B8fyiJwpZr6faEqrXA6nXCadRoZAF05IgbmjPB0YqI
	bnHbiGFlI3qJo6gKKysSHRrpvNS9P9MCVzM+1WnRrzd8adSjk2wkBL7dCKxH2/wGvtu2w9mSvEO
	IYtzNrEB0tqJWmULRPDwlHOgbmKp6kwoQOVUuiKLX6fhRWOvDhM7Z3yaS+NAvIxLFjERIPJWtSg
	xze2lIvazh6dps5qCmHhfpKEv3j6jlYSVcUpfg24biXoAmYIORW6XHCd/+hSaBiKllDeQYiVCz0
	EnK2JOt3d10cSFl7CgyLTbZpGDQIiNoDermNDBPRSDX4/JxLkURDPc+yy+JMQYVSAb1U/4UecZO
	jlmX+OLZnjTcggDTbZlOh1PZFhMr9UC2JopMyEdP/v5wVTBYyvK4nSWJlj1QKVvwt
X-Received: by 2002:a05:6000:2087:b0:3de:c5b3:dda3 with SMTP id ffacd0b85a97d-3e645c9d0fbmr7224248f8f.44.1757345067799;
        Mon, 08 Sep 2025 08:24:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1+PXcaDlfYMG7l/tiEGAk9GKqnsTr1vgulen25L6LSRNlWKiBe/sZ6bAf6RuwddMzqclqxA==
X-Received: by 2002:a05:6000:2087:b0:3de:c5b3:dda3 with SMTP id ffacd0b85a97d-3e645c9d0fbmr7224167f8f.44.1757345067184;
        Mon, 08 Sep 2025 08:24:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33add504sm41539994f8f.30.2025.09.08.08.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:24:26 -0700 (PDT)
Message-ID: <8edb13fc-e58d-4480-8c94-c321da0f4d8e@redhat.com>
Date: Mon, 8 Sep 2025 17:24:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
To: Jason Gunthorpe <jgg@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
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
 kexec@lists.infradead.org, kasan-dev@googlegroups.com
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
 <20250908125101.GX616306@nvidia.com>
 <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
 <20250908133224.GE616306@nvidia.com>
 <090675bd-cb18-4148-967b-52cca452e07b@lucifer.local>
 <20250908142011.GK616306@nvidia.com>
 <764d413a-43a3-4be2-99c4-616cd8cd3998@lucifer.local>
 <20250908151637.GM616306@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908151637.GM616306@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eb1Ja6956CBvpzNz3CGu_N5U6PukEvLXOhg46XzLtRc_1757345068
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E24B8C0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: t7bny7etsrskk4zdczoxa8rmund6om7r
X-HE-Tag: 1757345070-296194
X-HE-Meta: U2FsdGVkX1/7HuwltjYhTXsRKCJ3cLPVnJbOPhsY/caoQPDNggwZhJAj9uHvHyGnQSjPJjt3jEojyuP47I1xiM94qxHhpl4086ehvlaw7uaqFCvTryoNx35or5+SaX+TDbpYzGjUFl5VZPI1/RzS1NGdz1Y8l0hP/3UJEM4L5oedk1Qav+fgoluyF+/iK8ENXoLDEDOBJMxRDnAIVN8uhcJ5Qnq9kQ9mEVWv2ZiETNcyfJ3KOJYukpaIAoPTtO/FWSFLH9tg/K7vhcdpNEJv+272DnVP0neZCuIuzEbqFqudnw3rg/hqHYYWrr7+3bBtZ1T1RdO7I3Kh03oihL13Rlr1aDZ0/WBN4rfTzZLCU97YM16bCYu8W6LUlvf7AzvuzSLvCuQI9ytWYSP92BRoH/5TsWo+sTesVZg/ixjh1OyJMKGRd3pofA3L3IqZ4bQUk8AfvkjZ9wHAXQV3lg7Xjhdt/uL/zxCGKOx3mBDKJHyy8BltVZpEajhq8F3Xbw/qbUyF+JR/YFaCC1muwNX9wwBOM26Av4eduMZ0Qhy/uQ/eEsPwL9qG3+niWGh5KgivCFfc6MCno3TeLCf2/u649Ot7MLBr6szRBwqTD4KQlsKgQ+EZuKBxlVt8kBxFRLVFe21lc97q2WK6PdRfdL7FtIKnGEqAVgkh7dDKTJ8XutGj8Cu7O3UnAhdAbQT2Jevr7gze0PmO7hCM8l5fTLpPNddF6TUlSASMLX/yMccQhqV7mwL16BXnBjVAkHYRIz9W+xefdRzaNv/EhnUN0ogZaS6OvNS3QiQ972uczLexkiHBiU+XkRm8OkQGBrP8hl7ybzQK+meeKSg1euL6irUsysPPmHDD+n0gMGMFfBT2zukzhGM7GMOHhIqwzqZ567vtrnfOaIC2vkuu7MKWCaYPkUVrEhJmVZ797Q2lHEi0cmOQahzYa1EMiZHbWKc6VXbXUkNzGLds1STSNdUBHwi
 qWllKhUi
 4sC4Zi/KRHu7Y0EvWUzQEzjzZUv0i3w61j4qiTWknlcyZx73FUhJH6PjmWkBemimcdw1g6dteFDTOUbBAAt+Lu6PeQ5o0gynvRb8T6xGDguW01rJzDQoiNxIOkrl4yLRFx6jTRYLSIEPt9jVKBjTePNzPAyPDRoB7mdK2uW0D5ES4f/RFAticWfhWfUqgJd3g9XySpb1IXM5/WQB1JzV/Dd689IsoVt/NhJS2XKVkGwGSF0WJDzHr3SQqHe9udazjwrCMHnncuPo7uKtCEwzifQkoP64+Q0fL5GSqWDwrXZtaKUKC187v3dFm1VMihsY3vUUVcyqoVMBT+mD+q8C5a/JE5KfCumWVWJ5XIL93bzUt9dhR06OBNNzM7juEPdqoNFcNBLEyV8/w4eszyo7O/xJVcO/YDBiDe+Z/Y1gwsQHva9z6h+lLA2t1AVROy2idKyNteRda9VpE9uzlROkoW8X1E6klaR82QhjxTEYLdFyfv/2yw7cpyjUHnMfuskO479wOabHfW49wTeMTsDqdgBK0Cl4D5640t4Xauj4Rtl9wU7F2NEl4a31nwLZYIBNQ5IqALQ3RjR7rakOB7jk5KTI2ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
>> I think we need to be cautious of scope here :) I don't want to
>> accidentally break things this way.
> 
> IMHO it is worth doing when you get into more driver places it is far
> more obvious why the VM_SHARED is being checked.
> 
>> OK I think a sensible way forward - How about I add desc_is_cowable() or
>> vma_desc_cowable() and only set this if I'm confident it's correct?
> 
> I'm thinking to call it vma_desc_never_cowable() as that is much much
> clear what the purpose is.

Secretmem wants no private mappings. So we should check exactly that, 
not whether we might have a cow mapping.

-- 
Cheers

David / dhildenb


