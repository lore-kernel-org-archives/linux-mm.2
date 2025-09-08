Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D757CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D146B0027; Mon,  8 Sep 2025 11:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD626B0029; Mon,  8 Sep 2025 11:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E736B002A; Mon,  8 Sep 2025 11:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 230116B0027
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:19:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C628184B62
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:19:28 +0000 (UTC)
X-FDA: 83866442016.28.2A5DBE7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B7E3180003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:19:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=INUYLamX;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757344766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLko7oepEfn3Ol1TqVFkknNfSGDQeUkDVqazWBqSvlc=;
	b=GU152O9XM8OrPuTO/v2c106715BWELkEoRuxt2bKLg+S+hJYexwUKmkdMdQ2K6LpQ65Z/U
	jpZXCIMYwcQ4Q+O8lDDKnfBkmiQcaH0w1WNibKDkVDLsv0Yz/kZNERa3bKqEnhuuNbJ2z1
	vXIyDQRHcyz+nXc1JeV8uNAo5yraNK8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=INUYLamX;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757344766; a=rsa-sha256;
	cv=none;
	b=WCsOR367R1VNc+PyIvNRfgjRvgEeAOlHnD6sGtvLfOm81W8Rwu5RfJud/pis2uE1PyQH1b
	29M8w/DVXlb5H0seXhl2Tv6pR1EMGBIHdYvTJmooXDRvY+ArJOPUEmo5MQKUds+yKar+g5
	TkRyKcjyM4ilQ2pNmEJdBgRy7UmdBQM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757344765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qLko7oepEfn3Ol1TqVFkknNfSGDQeUkDVqazWBqSvlc=;
	b=INUYLamX2kuvjz0IsB+3q0jZ0wmO/Zco3JoXYefQtsBOKvG9AgNqWrRB2hn/LO6/X7CvST
	WC0JsrI6D31IeYMvCfP9u2EZ4fX5V1SLirQ97eaYrr9+6HxMHuDIA1vDiCxJi2iAzkLE5W
	52WypxWm/AC9hll2DmTo2fB6MAmUHOw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-7oLs3n55MnuFxWUXrNH9cw-1; Mon, 08 Sep 2025 11:19:23 -0400
X-MC-Unique: 7oLs3n55MnuFxWUXrNH9cw-1
X-Mimecast-MFC-AGG-ID: 7oLs3n55MnuFxWUXrNH9cw_1757344762
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45dda7c0e5eso26663855e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757344762; x=1757949562;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qLko7oepEfn3Ol1TqVFkknNfSGDQeUkDVqazWBqSvlc=;
        b=WYfCht9ZggEg/0//zcni+VRbMF3Dx5dhwDm1Yx6L6HANVVM/8R1Tu71jipZzEvsvON
         +l6Z+No18PPa7k6UU4NvoTk36Ki+O9lmWURM71TkkI/3SLXhYpAYh8wk9qVR7f3TA7WM
         mpTO52AaIEs6QBlMNfhfflgBpwj8qP0jGf7fI94rO+wYtw4UuNXiY0frSvqIXuMUN8VI
         XomyJzouCLUvSVdbHWwje+Qsk2MKrvimfyOshWepQQDjq+ldwpzMb0pIA6M4NQU4XD5c
         WNJd+HZOFUSdBQu5JbXUM3HoAFB+Qd40EnvFH8RUDqHhVE0GS+t/NxTyRlsiMynp45/x
         +HLg==
X-Forwarded-Encrypted: i=1; AJvYcCXEhBYeTC/Ug0UexPB39DKm3/Naj+OmD+cNggZysw3rrnRRbpEXtHeMNPTzlaarcvSoM4WWr7tGPw==@kvack.org
X-Gm-Message-State: AOJu0YxNZh4u3yrRYgnLJoq2h/CzLi0SL7grSYrUYBrvA1EnJ2QHaskI
	Ko1AtJD6zaq0Ec14ne1JHUOmVJiMWeW5+jyPShZcJLbgrZ7Cg+Lt98GovRQVdqc1q7GmklrZR7s
	sXIwX7HFPNjqt/7j4qaZ68SVHlrUEQLagSpZfrgj/a9/QJLVZWSZr
X-Gm-Gg: ASbGncsUBf+Jqf+s0tIiRIexw6ch0hLAHZWcsVDww1HVr9cpHN8DBFbE1a31Hf8N4bl
	Ru7ssFiXn7tJomY9lbYRbfNDK/LfJPshljR2UAo92CQs/udSQHx93cMjUeuDi4PRULsyZZ5buoH
	3KNhVEMIPPBTlwzxswH8KRCCmUjihNvkZybLgZcL72A78ojCnInzvpRBvS9qX2VjVfqUNPOjVvi
	F2KyM+y1+43YkrZAG84npwW/5bD4Oi52ww8jl4vLFjUVYIyHu+HA1hZ3hyJdUVqbukpiGL3tpso
	ppa9h1m3BzsFP2UezPHomEhqFf+/xOFMzLX+XrgK0ZuJZmtikcvhDncvAudXygEu6TI570lhik3
	nNgmvqgRrrjNZPlcIqYX6ImWlXmz2b3dghuh1qsx43Ix7y/5iXBqDOmS1w0xaoklq
X-Received: by 2002:a05:600c:1ca0:b0:45b:8352:4475 with SMTP id 5b1f17b1804b1-45dddf02148mr79226155e9.36.1757344762210;
        Mon, 08 Sep 2025 08:19:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmbO59rXqfJSN+yXWkW7tAg6FvCLMCfm5bfDHTfJ+YCQcDtPKiP4nLWj8T83dJ6eBAHi1Zhw==
X-Received: by 2002:a05:600c:1ca0:b0:45b:8352:4475 with SMTP id 5b1f17b1804b1-45dddf02148mr79225565e9.36.1757344761709;
        Mon, 08 Sep 2025 08:19:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9a6ecfafsm298385255e9.21.2025.09.08.08.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:19:20 -0700 (PDT)
Message-ID: <07ea2397-bec1-4420-8ee2-b1ca2d7c30e5@redhat.com>
Date: Mon, 8 Sep 2025 17:19:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/16] mm/vma: rename mmap internal functions to avoid
 confusion
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
 <626763f17440bd69a70391b2676e5719c4c6e35f.1757329751.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <626763f17440bd69a70391b2676e5719c4c6e35f.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xWPhSqpbHZ_izPdSLmN19_NH6PmFbOw72bNXDb1zkJI_1757344762
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6B7E3180003
X-Stat-Signature: m4hj9ka31iu5wqrbwj37uhzboc37ujx8
X-HE-Tag: 1757344766-786460
X-HE-Meta: U2FsdGVkX18Npezc3J7LMC0WB4h7eIgdRw6CxWrUd35MCRWHvXXHjnAZDgKK/pyJPRKTxUuBqlMgFIwUogcu3eL7K/1/0U/RKCBcUxBrTT09s8qQl/mlwPqjkxFbzwlFMhj/ClyDHgnS0oXrbOksEr/EyKEb7x+Ca/BjgyosbrVVaJ/JfFnPgp8mmgHWH7SQztNXOsbbrDpYctQqN7Kw5n6XXmg42hMcrz3Pe8944EsTkIgC8jIc6Bo2W0fnfOJwjhywNARiKtoD3NK35ifjnz/ibHcPPgqyxQiWrPa6nSPAhjIvqtA2KDM7b7J5tq0nYYcBFJ/zuf6L3hVds2RkPtviFTXAO6+HchgrE+yZpD4lr0FaVMQNEFHqlodidaAdvmUsTobLtZ+DykZ/7oPAR1S6CnFHU/w/eeQr2zTBFE2H4xobgOKKixiESQW5wDKDkbAXmfB4BsbI3QKmpBRGOUPwDO1TVnVR4DSL9Kgk/Cnp5w3AMRx00v4ySv5rq8nWdMBAuK+Zzuu5SHXwY0S16+A34Ov4TuqdOmZjNQLtQ8ujN6XAOKwYt3gvQkGWsV/YxBwN6TJvoC30QnOE0K1h5o7uPzWO/I8sH0f2EgQse0O8X0Z7qTUgt5Mb4bR60oQD4wRglu6a79rflJ2X7R+HPODwEEW/R1q5RGjEeLP9ebBPAEG2n0a7MDrGVcsNXEWD69+Wuk830B8QWhBD+N5RIAcj2CZrJpLOfrj78iDm2SxHOLCEBGIVjtrigz/CpFLrWRs3v2fYSs6fCD284z33Avq2ZsxYjdbUXfvlA98UI0lMyBRx8cuFka0F5AOEOoj/myFDYd4AOhretIkn2+IsAcjSZ0BC4qBGoon7PvuKD6cE0CYakyphJm3lZeRiT84ioxyWSt/5giUZqnd8gmEO3asPNtiHrUB8UtquDP00/zEppqy4fdt7uRSrvunk1SfkdpzUKEseRHb0JIDOr+X
 EPa9xHEJ
 LvcL12NhdEKPp+qz3W2CTO3havDfr+ptTJ2jtG4BYJP/qFlO/9VeO91O2rS2VDtw1D2vo2RJqnbm+lbfPe/MgTO7bN44z2PU8XcQtB3fApN66dNR6JYKhNO1qZzimMaly9Au0VD/jg5hWVCfxufnFu2ebxS2X44zxFjhMN+SievYOA3/1WKSVIO7xo1/nJHOVxCL295PleuMvRPkriZ7BhU9oXCZrJQH3oMeFc5AcXItn8zuhMQBRESxezBG0SIRF9ZW5cBAs/5eqIcbf15VNqOp+tmoulAW5fk0SvX98hAjGiQpVAJ6cEcwpUhQKbajfg08gUSZlTfCqQyGFQd4TCoBgTOKozVQ9Bl1MGDp9QfsHCG4re+/h6rwDwaoqNbE8yYRFPUR79qO+ogDpH4AL9RVQW01H3npUFGkXRKxx0CVm3qE97VBlso89EeN3Gvk05Otanv+WkWvDfFbpmf5lwpl+YA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 13:10, Lorenzo Stoakes wrote:
> Now we have the f_op->mmap_prepare() hook, having a static function called
> __mmap_prepare() that has nothing to do with it is confusing, so rename the
> function.
> 
> Additionally rename __mmap_complete() to __mmap_epilogue(), as we intend to
> provide a f_op->mmap_complete() callback.

Isn't prologue the opposite of epilogue? :)

I guess I would just have done a

__mmap_prepare -> __mmap_setup()

and left the __mmap_complete() as is.


-- 
Cheers

David / dhildenb


