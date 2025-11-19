Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52CFCF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFCA6B00B1; Wed, 19 Nov 2025 08:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FB76B00B2; Wed, 19 Nov 2025 08:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7046B00B3; Wed, 19 Nov 2025 08:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F146B6B00B1
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:09:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CC92894BC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:09:54 +0000 (UTC)
X-FDA: 84127389108.04.F4E8BFC
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 81606140006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:09:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dDRtXsTv;
	spf=pass (imf09.hostedemail.com: domain of gorcunov@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=gorcunov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763557792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8Xcv7L+0okxtsjikEPOcHfMR5tUDxOoJBYUzekVP4g=;
	b=WHnqnTL6cIuo1+v5IZ/RPrGTKbMTpWRIFUa0mNZ98ic4YvyzP7gYrm4dGPUHo/xRRbUXcL
	VSUMK4PldcIBUuSGObowxnTn08cRxWibLY3+mhPq1obODe3ND5jPQ7S2gy7xd7hFGXaB8y
	cQSaJNl2IeBwD1iCpe3V2pshZjd3Ako=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763557792; a=rsa-sha256;
	cv=none;
	b=XxfX61PvfNMEtS8Rzn8zNPEmJulOu8m5C2O665xnni5hjh1fKLLLTsTVlzp884fIn8kStQ
	flrMDM9XnmWZSw0j+UqfZHswyN+oF4Y+i1lWfMgJ5RtySVuv3tjp/gy5OyQsFH2eqltQr1
	zi+huB/LV/IDZtrPY/JDwveqqj7o9jM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dDRtXsTv;
	spf=pass (imf09.hostedemail.com: domain of gorcunov@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=gorcunov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-376466f1280so72383801fa.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763557791; x=1764162591; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8Xcv7L+0okxtsjikEPOcHfMR5tUDxOoJBYUzekVP4g=;
        b=dDRtXsTvhW+ruPin6G41aMaHr6/AtKcSL3uQ9QOA31URDoDMPJekXEyklK2RyiH54r
         /qjmFGToBBk/7wZgBlyUwKqYfFxvMvFskxfOgeujaf67WJ8uUyxJdqDrAYfP4mDF0thl
         HUa1mOJbmK11foeOhFfmRrVTANGlsSxw2V6HZFGZArIo00VHf5DtFYSDjnA5OgIUB9he
         YtaiMZCzvIPLlz6RWPbDLAEypQ7IcULHOeFDHUZRbkmvcJ1U8zOhxm1SR9zOTjtzFYfj
         1YEZ1s7aEat0LblJnx/m07lEt6yJjTsvZMTdWqax1Gd/1jilq8RKVstZDEWjux6f/I5t
         l7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763557791; x=1764162591;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c8Xcv7L+0okxtsjikEPOcHfMR5tUDxOoJBYUzekVP4g=;
        b=wtsrRpOK44rNEGBS4H9WQRzCucrOWvV0I/vOaawcJAm3WUTIkOphYXHlZkCkPE5BPg
         D/diKI9Y4Ix8+2ZcpLIwJhNtJQSr5d56vUQa4iBqZPNz0c80ifvMQK/GZir5gToG9Utn
         phONUPy5q24j/QicGqJB1m6J+9qSpwKzyunaKGna0Eqjm+P0EJrfEomx6tGkhv4uItVv
         zGhofz2NyBk2lhu2n8mRzu86RjGSygaIoVrPrhIFLuckYOwvnGiiDcvX38rxB2LNiRxN
         LdxZ9QzDO8vXiTkiwkbL7Jj1C5uHKrx1Ntdhrpwbn6dJOJxaHkuXqxFcLyPS+x2OQLQG
         uf7A==
X-Forwarded-Encrypted: i=1; AJvYcCWZC91HH7Cp+pjX5ktuj3w8bdSsB6HGP02z3oJwFr9QmiGGrgwp32ZKJuJbhpDZWVzMbm1kEf1Tvw==@kvack.org
X-Gm-Message-State: AOJu0YySoA6eejiU4RcQ5WDEkyjmPNOhhc8H6+tvcTqWdh3RIwcHVtLo
	lKPNPo2UBRnUw1/UKU6AsTVrWRyCz4MWc5HJFmFkJuSD9ExjmSbrn5Tz
X-Gm-Gg: ASbGnctfiFxvQjpYFzppmcYC2fQ/S4l6tVmDX/vX963hW6KItUqTryCjfzd0q4rQfoH
	WRJvEOfwsIE/zPMwpqwG++vI01B4EVBDPsoroYcSg8xjCSJ2uJek9OexXJb3es7M+1DW8ztfco4
	8lbkDnbPpNj7AMZWUpLQOFxKc/KABDsc8lgb2ib/peEFs/CTfVdLXjg7KgUwYK07eNFtuyGKjO9
	MGFIA4Dnj49Wc63yjZEDwLvK9oCcZxjuu7WL819cR+z3pQtc/Fu0gL2aKibJxf/0X+TjeuOvO/c
	Pj7YL4yMZrIwhc3HIucKAxABlSvBHyIZVj/sSFVqnr+Ogr17aVqoJKmTQmtg48/HWJ5rHgS5P4A
	gjlZ2wvoygM03b0qU0/lNs8CtzCk/g57LWt0gPjT9yom4S0AVzL+yaMxvR6ehPPpBiiOH8u973o
	5P2dujJWr1p3HCUWzkAmpUwl9w
X-Google-Smtp-Source: AGHT+IHfrwK81dHP0yx9TSq7f7mym39HNGjUSxDJsPi5IK+SsnvtAFvMBaKAw1yCcIbphLLGGjp4Rw==
X-Received: by 2002:a05:6512:1252:b0:595:8350:5824 with SMTP id 2adb3069b0e04-5960382873bmr1039341e87.7.1763557790245;
        Wed, 19 Nov 2025 05:09:50 -0800 (PST)
Received: from grain.localdomain ([5.18.255.97])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595803ac90dsm4722497e87.22.2025.11.19.05.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 05:09:49 -0800 (PST)
Received: by grain.localdomain (Postfix, from userid 1000)
	id 3A2A35A0033; Wed, 19 Nov 2025 16:09:49 +0300 (MSK)
Date: Wed, 19 Nov 2025 16:09:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrei Vagin <avagin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, criu@lists.linux.dev
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
Message-ID: <aR3BndGWuzf8vnku@grain>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com>
 <1c20ec44-0775-47e0-aabb-e1cf1f38ce94@lucifer.local>
 <CANaxB-zPuxtbpt7wcjDE1X5nv4yWp=JTq_MqWSfDce2gx-WKiA@mail.gmail.com>
 <f00a062a-8941-4cdb-975e-c13aad860168@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f00a062a-8941-4cdb-975e-c13aad860168@lucifer.local>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81606140006
X-Stat-Signature: snmbf4tpottycn1wz5zfs7gep1zcdmsb
X-Rspam-User: 
X-HE-Tag: 1763557792-190067
X-HE-Meta: U2FsdGVkX1/M1+nUZCVUTaDQBR/uyOIWyA0PyPMNBTriJk16NxLeq5JKm+QdHL7qE8Sqxktg+9NIIjf8+g5z3jmeNifvDovwv1C1DngI6ZNltD0iyFUM3Xwmv8FD5VaCc1gPGGUewhi90kjDDD2Rr1gFbVNwtyerXQJdWiMGPQX1sYUh1GDznPmpesY5aMBX1NT7Y7e/9T2btXUP6r6+F6HHeeAqwi+QlZJKcWZe5kde+W30FdnzPF2VManql8iIYz44jZGlcgdsLV4tSrQDGcTJyd4QzMBTmcsIFHLZDB/pY9rzs+sSfq0pEuXwjEIV6qKa1DwZOKgXOF8n15rK18c5KgbmmmoCofJDmGlW+v4j1Me6vNAzCDBz24/noJcd1+rHpHBwyOTtrJw0f+w9uZfnsFS7Idul3cyW49qgnWcStzOyaXIsr23OUpAhw+KzxGdjA2MtyFokZ70dY0PsbFCl5LA37MZfvlRIrx3ec2LeHUF5Ivg2A6buYSskUAHrZeYennAhA/h6gl2gZHGGpSCYLSs+2TAAjTDkGU53YHmP6gzGQhqHBhr0ugBgGPPZvTEtNwz2ZK9eERzlbdnW9O1VP0yqR4866ATXiuQ89DMYfx5Y9jDdcVxm6R31knTbJICjtWPhwe6vJ09k4SNKY/ZwcwWbuoniTRJ5Sr60qY7sx1Q1oo9IK0MyWg8P1aTAjXHUBkWJzuuekTAzWOTK+LNgfdRAubdZvjWC8S4jBknYDFf6Dd4zcV0YJBdy9hIicGFE2oeJwnJ6f/SqrGkYZ5D+BnGKO+ihj4u+HXF3Z1pc1ppZNNF6BhAGNCiXhrz4gxqQZRmXjdg4E6qHwukRH0e8NMiFIEKV5sVpphRVrvDMd1g9Y5xO4wCSagLuw3z3IWP2NWM9XIZ/h+2CdxSX4u4fmlqCJP1qsvVDdUEi4+NK1muYGEbkn416wtxhYqFgKoRkksneh0+tHd9kj6q
 o2jGjFTH
 cplfmYISHqPiop3iBNtoloOaUVqbhwI8zmF/0ybI+Htc7CYjF3/mveB1/GTSrBQLVO0MAY0jw8xh/9KNdhELDBx9FzDpYIUqTnWfNBfZK9tJ9E1TCPLs+QDR9qCP0zQlgN/YU1S3XosSBgB+pC4MJTfTdH1ClHrA0HVvvLOQQ4YsDjqm07qQZ7KtrIyRHxLVpnxAd+fQE0w4HgcOeWDE6P/zVLDONmO1FJxoL9TM4+45Jj2VSVdYi7TFi7B15C9s7DMzUuU+qpEK5ed/w/AHIpqW3M54KhQkiSusnmQJw2Aoukxw8iAbxHtVBfs20yyXI0q81sI7HqA2HJoyDC8sb5SVfRZyNTooJdhd1+qddisJ5JF7TRTHvp61K4M4qebCzsqvYZMZXRO3kgljkOyYL2ovdqo1BWUsop2Y+Dxa4AJWhFDpr4ZBvHsIzWsOa3VbPbrm2WLxMLHac9KWJUi2/ZpS+wFyntNSPGlzfgbOZBgoqUm51o1GCPtwBQbh8uqqV5xCSE/utQuiBlAJZuHNlg0+Z2RmiKyFsck6zadA9xi5ctgiJg/3fEJn2Mn/XCU/RREXh1Ia1YnnmayufBaSQJXuqpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 07:57:30PM +0000, Lorenzo Stoakes wrote:
...
> > I recall correctly that initially, merging vma-s with different
> > VM_SORTDIRTY bit values was not allowed. It was a bit surprising that
> > this behavior was changed by Cyrill in 34228d473efe.  Cyrill was an
> > active CRIU contributor at the time, so we can't even blame anyone for
> > breaking CRIU :).
> 
> Well I think Cyrill is in the right here :) the problem described there -
> that of hitting the max_map_count simply due to failed VM_SOFTDIRTY merges
> - is very serious and clearly highlights the issue that arises from not
> merging these - that is VMA fragmentation.

Hi guys! Happen to miss this thread due to high message traffic, thanks
for CC'ing me ;) Yeah, disability to merge VMAs due to softdirty bit has
been a serious issue, so better criu to dump more (redundant) memory
than apps got broken. As to this patch series, I think it is good, thanks
a huge Lorenzo!

Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

