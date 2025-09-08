Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75729CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D607E6B0012; Mon,  8 Sep 2025 11:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11466B0023; Mon,  8 Sep 2025 11:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD93F6B0024; Mon,  8 Sep 2025 11:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABCC16B0012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:15:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 773A3848C4
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:15:24 +0000 (UTC)
X-FDA: 83866431768.02.A268C39
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF15D20012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:15:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gq+/EeAT";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757344522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/hWHs+Oc+ZmanXHj1zb/uT9WG7h+yFz4TNF11CDu6c=;
	b=tcNduZJeErWnu6Ej3F+yq4ZyzpHMqF7INPL21JQqn9Fyd8UZKca7J4Ixbb3EjWjSqpIoc5
	u1ZYOomBZa0n3ig0ZSvAFbzmU+0Fx1gpvul8K4Utd8tgbpwGnxIZTuKe3YgSUrunvWCn1C
	EZ696PzTx3GvKQTLguKoovLV/kZhacA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gq+/EeAT";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757344522; a=rsa-sha256;
	cv=none;
	b=H8E84VSyIBY6qpovd5hso0S2c0ZonHdUkLSOBgKgGILZr9P5UnVkcxC/kC4UuQ1HWN1haB
	0SPP2dPCnvTonP5BJ06ZZTO2V6Ib0ib6asDcX6nxWa3O2OZwK+l5qGSha6lzvAdukZHsiB
	cWSocpy+CDFdrRRRMa4R0KhPn1Vi698=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757344521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x/hWHs+Oc+ZmanXHj1zb/uT9WG7h+yFz4TNF11CDu6c=;
	b=gq+/EeATKVIlLEbA5e6H3V0yI9gcv46sCqtFtgil0oltERVGAf7rYW2YQrkcml4R3Qba/H
	GGtchp3vrORW9E0n0wajcO9dGcn0MPURRposdLM40WyOJizjKQQ9yDsfcJYzlazYwIDtHb
	0g6uTSs557n81WHIJi/hhQOnQ1MoyEY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-_wfESTDuNZqlhWph5VIBuA-1; Mon, 08 Sep 2025 11:15:18 -0400
X-MC-Unique: _wfESTDuNZqlhWph5VIBuA-1
X-Mimecast-MFC-AGG-ID: _wfESTDuNZqlhWph5VIBuA_1757344517
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45cb612d362so23609095e9.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757344517; x=1757949317;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x/hWHs+Oc+ZmanXHj1zb/uT9WG7h+yFz4TNF11CDu6c=;
        b=gkl3zQOGI8qS2qf5KVdMr9ax2rk+TRamoq5anrGojqrunmBOTL2XRi8nCS22z4TnDq
         MEHFk3sFUp35LrwbjUE+jbvyr0djQaIRp3fGUNryXc6RLQeOmFSpVfYo6dxATHNgJ0af
         jYJ/ZluLz0ZukUYHIR59ZO/JXDOYOD/jv4zu75X2l1wnPsxo7qjQ8ibemUkh2aCKFksY
         FyY19M2u0VBLNf41mOlRSqTZeCIy024vqWl1Z9Anbdlwoxa9Vanq0FQWHkCC7oZuupcd
         w33h4YKmziGotLuZ1V3vLkVcAU1nW/Gvvr5UVHSd6FjQ85gfbhp3h7Zp0MX/dM8uhesj
         jw3A==
X-Forwarded-Encrypted: i=1; AJvYcCXD9dlzg9f0zMx8FWU+/yVcTqzp1OGr9QzP72xEMFDt1nmZh6T0GCRz8B4FG97MHEk1ZLio7mr25w==@kvack.org
X-Gm-Message-State: AOJu0YzBa5aEy7kTjcMDPxMpS+qSXZRoxMmspqU7Xte/SIDL844KovqB
	mHCLtyRg426MwzuDQSBSxtdiVmG1bGGsi4R8EYOE3LO0pJ6ssRZ5mEFJpa3vGhk7U0jQ0q5M1V1
	HPlOR2oye8uiWtO/osF8AvLBRbEIF9MOCBSAn4APPO0xBWzbx6cIl
X-Gm-Gg: ASbGncsyqhT8WP3u+ZYYn/R5WVAhiDtY2lpCXMmSBbAxhgL7TxqqzSNRT8L5dnarTLr
	vc76mjBX8BwatcFH09nMfI44xiR2iEYhh0EWggqqKeQRzaIPKSrBaiiVroqOriAhckHQeGLVcoq
	HRN96MYfjsoHQUvyu2/g8D0/hZyi2RMfj7myKS2VZg1eWEFOHtM/ZfDKdt+EJGg50nPhUqi7FUI
	ar0xgaR8turWaUFpaB3pathwltMXf8kG/ROxaIJ+8sV1dI34teewwxWPboQ319SB7cvVaBoYiHy
	49eDJy0wSCGyuyF+wispcpxNzBlIpEzIETmwIHXSruB2Fj8iVjoThGlBpckbZHZjL4wRcN97URY
	XM4Q7PNjZtrWzJrnSLqPn5q5WxlAV63YWGyi9YIGKHrKHCUwXiKgSu/9u1OiYPMVI
X-Received: by 2002:a05:600c:4692:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45dddeb907dmr68698495e9.13.1757344516476;
        Mon, 08 Sep 2025 08:15:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAYV3WnrUtHwlEp7ubFGe6B7naJwEV3uFeSC+r+JEU0bYm5LBcPezZQJbxkrEzDV02gdPnSQ==
X-Received: by 2002:a05:600c:4692:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45dddeb907dmr68697815e9.13.1757344516004;
        Mon, 08 Sep 2025 08:15:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e23d29bb9esm15808547f8f.4.2025.09.08.08.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:15:15 -0700 (PDT)
Message-ID: <e9b9b4f4-8ed1-40e8-8b49-22a0b10c72e6@redhat.com>
Date: Mon, 8 Sep 2025 17:15:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] relay: update relay to use mmap_prepare
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
 <9cfe531c6d250665dfae940afdb54c9bd2e9ba37.1757329751.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9cfe531c6d250665dfae940afdb54c9bd2e9ba37.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kXLUUBd-elx_zu5ej0S1wqYnM-41_NZJVDqAkkLnJQs_1757344517
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DF15D20012
X-Rspamd-Server: rspam05
X-Stat-Signature: ci48phqicajcmc8djmcouonra8h6dt4b
X-Rspam-User: 
X-HE-Tag: 1757344521-396582
X-HE-Meta: U2FsdGVkX1/b/7tCn1Cm1B/VnkWeAnDh7kQ18/1dC88xwV99zyd2qV6K/NyEjmwzUEdRlwftY3LCW6jmTsVrrkXpMwse9FxGsyX6hGma3Rv6xgTTxM0t67fnUyAifeNhUlp5MdN94G9qzZkpWBk1C6J0/cZSp/2+4aiCZCU3tLPWi0cYH7SslBVsD8O0bIDEUIbB+WWVQ9XLPApu0+8QtmhyA8V1PVERsY35LuQQucmmevK8w9xWSN714v6WECaeR07utsL86gw2cgQ6f1Ol7A5NtgYIyJIlzBc6LHO0yG3n9g927efMvxIbX1AaujCCYw2YoqnbqESpMMpWgLMw8NeC3Is3a9oZEhMcaKB6nokO86DdOBdc+Swv01EQZchxb+Zcr7rOv3rQxswdCyw7dMFW82eWHMPR1tjQxSpuaS1T17bdUe9o9DU0vfpjX+cZ+/lkhaSorFdcLbioIs+NavBNP2DZDea/aqfbOuBsYnThqtggStnHqKX6qtoUCCssUmqY7j7nsTKqXH60qpaXTlf3GNIEt9VZ4vqf6Zjq/jahhd+eKOXFyl5ol5dJUdmMVBlu+Eih1sAd5wBkWpY4wmjZSqzHj9Va5hJN/KA6VIVrx3ZY26LUlEmqnzGi5jilbc7RD+tb4q8eo3F/JfJqQ4myuGRnhOJ3CCKPEKfUzvc6CN6laecQ5axCIT9HZ+GrYlC3DDsnGHsYGBbyLR3WyiPELhiYGWEtCKX8WUnBKxr5sc1T1jsR6bYkWN98yviMFicrqzlrnoiddIRGBCel0CXX7P7QJCphPa7eG4i2CBdkteOSpy87c9pvfKzOQf9f92eYaDnh7RdXUGIzlnNt/5wCLubDcpV99egx0ZL+obJFRto0ltRQkwlbRkvYa7OsEqdIgL9T8SYNeAXX2QW33O45cJXJfgF5042//g8V9dpFMZ+PTjWkqa553NVZKIGXyu/+TSuqhOGpGbFlQSa
 VAMTW+vr
 4H2GMf2MjoMCLQeQwompCPKU9yrwvyywcPU93VtAWsmY1s4ISir8Q/tX/S/8lsZfYaWqjR2f1ykrD4zSIWz5aVg80dBoDaxdnntTBWnmSC/NUSmNew/7bHSk/TCiGxZAx+8kbDOcLbSPLJomejMardre7NyMT6cBkAmUvl66kzDt0QbG/tIIS0B7tekFsveQxQjd0ARFJ/6HY8EYdQAlupyam+udh/uKFb5Y5fOXfeApiUvnjob6o94KI6Vp+dEn6eC5uImjWPjDhSPmL/rG6CSoMePp0dd0Ndh7dv7+b2qPvZhD2CbDUa7GAY6fR7i9rmrgRInq544kg1m5IquSnLF92HFnpdUHihR7JGudsLWgWEgulZtxONsjTrEN7ow0yzNo5VJwLWuriS2EwlXIIVhrYF8coqiLIl4O5bbaYad9x3odjJSKth2d2JewsXJ9i3sVfbX/t3V69QZj0ApOOtfnXLAtBk3yywPXxQetCBeVyiyDgfsNkT5EMuwrBAV5bcmN3cYGEG0j0/5QarcPn5D3WjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 13:10, Lorenzo Stoakes wrote:
> It is relatively trivial to update this code to use the f_op->mmap_prepare
> hook in favour of the deprecated f_op->mmap hook, so do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


