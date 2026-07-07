Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C47C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE186B00AE; Tue,  7 Jul 2026 16:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28ED66B00B0; Tue,  7 Jul 2026 16:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156446B00B1; Tue,  7 Jul 2026 16:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C92696B00AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:27:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B7B6C33CE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:27:15 +0000 (UTC)
X-FDA: 84963115230.30.F2186D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E27F7140003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:27:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g/Q4rUjV";
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783456033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAVMhqlCwglZDQHNAKH6+ZrmFJJ54m+xXUdMMc8GRc8=;
	b=ZyEbb9mGAVBZqBw8Lqa9PgF0tcj2JG0j/mhTs+hST/mlkzdbDPYPRy8ClfI8jf3KIr0S0Y
	sNPY7ZIWzpewPe5+3yg/hxz7069t46jRO37iHVdzEmCYJR1UoMunBgAnP+y3KSWqKDWeUD
	JOfEQsorDxrx6QAgTXQ1lpb9vmUnOcs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g/Q4rUjV";
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783456033;
	b=lVkasHhbDShH90lH+OviGRfgEg5Fx6X+t4JNpE8uMVjjWALioAuoi5NXfiOxnRmQUEEXsl
	CYzBfqomHzaC4LXkNDSQffHk4Vts4n8U5+7YDY01qDEiTJ0FKAyTTzu6z6NjW2aIr+BrzC
	u1eqa8MYHG+VQhugpaQelXLtz12ruGs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783456032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NAVMhqlCwglZDQHNAKH6+ZrmFJJ54m+xXUdMMc8GRc8=;
	b=g/Q4rUjVkcbNmRjOVzeEksUS2+j4d2P8KHSIG1T7TwSbPf5bKp3fSjf7+LcWZRaQUslXOd
	NwpSEnp1+bp7dLVx3QKLe0qoGta6SbEfIM/8h2D9HwttXAryeOg3f8rnUEuLndXj1r0USr
	CjFg6ux1kIi9YqqM0UWWHQZngbHuqCo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-Oikm61_pMCiQ--DQBHyaHw-1; Tue, 07 Jul 2026 16:27:11 -0400
X-MC-Unique: Oikm61_pMCiQ--DQBHyaHw-1
X-Mimecast-MFC-AGG-ID: Oikm61_pMCiQ--DQBHyaHw_1783456030
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-46fb9079a04so12338f8f.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 13:27:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783456030; x=1784060830;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NAVMhqlCwglZDQHNAKH6+ZrmFJJ54m+xXUdMMc8GRc8=;
        b=gsHxAhzdn1090YF6D3PNjuavLJEgEZMQGzWcgmLLSF3PLls5SPvNZ98Ohfi+2e/dlq
         sEqnWy3ot66GlPwc/gKBTX42UE4OF4XsfGLGKw6+d07a+IXupxlwN+QZNkiZmkP32Pfd
         yVQdlOeT3fn7T+Q9S5FeR55yRwl0Shd3sF7HrS/gV37mRcUD5M/j7eiF5Znx1+cEmhuZ
         tkfL7E/gbPE8jPqX5tO7eFl1ySRGkVJwuxjMmAXlMoT7ORO3ESkQ8h13WhDvnVj91qJT
         bUzA4021j/JbLdrgYMXD3yxHW3Dg/PXM1uWRKgX7HUMLFnbsK+SnZMEX8IGLbqoQnOrN
         kZJw==
X-Forwarded-Encrypted: i=1; AHgh+RoDNfYsnCL2kBzWBAkrpHFc9oFizMigG3p4aG8AXW0XoJKuUSfPJP1jQL3AX5iVgtORSxBtUuRouQ==@kvack.org
X-Gm-Message-State: AOJu0Yyu8hT4lv0ue69J6vdorBu0+/dYTWw3CS74y7dtDezfCiLqnDmT
	0S+lK5X9GcoqaQIlcvBjOp9w37hvAgPPHfu4b5AK7RqfPa+CPtYSTkW4E//v80mq1Yfo/RNCiIm
	zb/S7JZJeTTKCABWw0fmGSzuM9bf99qLGxAoO0F9v5OFpF4O0PCHA
X-Gm-Gg: AfdE7ckren1V5rsq9oX9cXL5OssDCkrTra2PCsah/0YCkSrMV6aMABDWDNDU+rB1J5p
	5NXYLor0qMoAP4OgpR05nALRFThOU7zrxuGDngJIB+6nD8TrmD5ugnHkWJQMpCQqnKXdSw3/7+j
	8xgHR+6iaITP3zmOTRKdLrMPGXZZ3KReyUkB/Q9phjYjMZCwbVdSC7qxKUjs0FFVwnAQutgkh5W
	LV5ZK+JqvYD6B2LoongxUUDxp4T8Iby8MagpGZBAcN3KuiPkB/zCuw0H0NgURoxj2g4g66jtgLQ
	qsF3Vl1znqPm+p58VcXzpdomV2zH9aj2Y0Q3/JM67X6wfCEo79vmrgSmq3537vsjIZqmEjutNji
	UP/I33NhDSQ0EMq+zGAYSTyCoB44OxvsL
X-Received: by 2002:a05:600c:5292:b0:493:c10c:22f0 with SMTP id 5b1f17b1804b1-493df08cd64mr79673065e9.20.1783456029697;
        Tue, 07 Jul 2026 13:27:09 -0700 (PDT)
X-Received: by 2002:a05:600c:5292:b0:493:c10c:22f0 with SMTP id 5b1f17b1804b1-493df08cd64mr79672845e9.20.1783456029187;
        Tue, 07 Jul 2026 13:27:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d910sm35459713f8f.6.2026.07.07.13.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 13:27:08 -0700 (PDT)
Date: Tue, 7 Jul 2026 16:27:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andi Kleen <andi@firstfloor.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260707155658-mutt-send-email-mst@kernel.org>
References: <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
 <20260701043024-mutt-send-email-mst@kernel.org>
 <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
MIME-Version: 1.0
In-Reply-To: <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sh1Ss0JdA0TTQDnNFev4fXQ41Mm5LL16hOPlMS5NNLg_1783456030
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E27F7140003
X-Stat-Signature: 91wieeh8693awn1ti7rcejb54atbjctp
X-HE-Tag: 1783456032-694401
X-HE-Meta: U2FsdGVkX19HCcJtt2v4bf62FtPbBWLkdTv48nHzjbFrw4Ax332DMIqJLmS4Gc6rVWOoN9lSECh0zCCgCaj5PxDnPXy9qr0PBAH81sJDP2rYD1mipq9clea+/tBbneHdcO+/jcPDbXJFLJg8BcV5lkuP9EQwMNaWFqTX8ptxCfaZl+ySkjmqG1QT9J6MchTOC/HzfG6asDgmGn399piZy9wrvHua79w/P8+ecThOqB3yzSmGW/s6RAXh5/Zipb+a6xZWlMlf6mq8Xx8+hBSWcc/3qDHBaKkEX9Ks0zck9Sc9Zsy0+G6r6m2rVHmgrV0sElXTFW6wIDaaKZH5cY8hw3dVQUrIkoYNSBO53YIu1onk10KT3Akbrk+CYJNnv1Gd7YibgbDDAtdy+c1lOuKWD8JMKyMpmT9JIWnJVB/o/kKeD1hsOUoYEXhOgPV522l5qyH7rLoY6afBHdHWnOxXZZgBKfaGCuwfzsk+5p1NaGuRyEohO/I6ebEJwTtiy4HRBWC4fepDr+M27u4GT+ZM5KRQVa0IqRa2m+ZAWEcjOK+50njprFZL+c+oushVkjcSCLX8N3J9SHvub4fcSl7o580DIsYoo7KmBaVwbH9yt4F1C0Na7IxtaEpfSmfjgaBDskjTjJpnIZ5ljy5DLLokuMUXDq8T8jOjdCZsPivEZZ11pNC8zAR8uHvI2ptPtHtE/gKL6gHwi+2ROt0V8RrOLPnZmrRlL7t+vkrcirvnj87qtPPgQuI9SwRFuPagiHhf4vqvCP9csBXO7/lSXf5CjtDhyNnbhzX7Qdu8Jwb96nI2mjPeJjaTE8iOEJI2zfAodwjJa+Gg2GIz+3qTcHUnsU/y/ll55sgTbb6K/ZXI3P4u6AVejp3085LWbY8qfLq+OTJ2onNuyCCzYChPfwZDCXGT5zAGyXkvWj8+KyUkx9YI8fjOzpMPKW2FlcEaE6KS2vx8yPpWugwJDthgubP
 EScEkoMv
 Xj2Qi+I5HZPqnVJ5zT3C4fbD8yVopFE7JKL78816Z1FyOP5eSKXWL2rY+FBylCcfLobe2BXv3sR5Zs7LSrj9gzapkXnntfLITMizT/VBSF/ABPJv4fk2ayXuLfV2w2xElggEL/aO9eZiRYehFRGVDKWpu6o2eROr+KFkww4mgPp+7E+lYcTL573SwwnvXgm47QzlBr3t4muAwelRqLNyv3E5Qx5ak97G3rI6ImfgfM0BV5hDb7IF7xwCviy2zfZ+P4WqeRMs6e2c6X6u+yUMuMhGj4O4uXiLj+pzEPw16WLSEpElMoNPVl5Q902y3q+KWAe4A1jMPJL3IERR5XNt5H5shYWsmqjVdrqFSZ8+9wgp+xb+zNsbSn9xJTzqYJdGGSaqSYSCX0g8g6hR4AfM7JB4zdJHQAymPyRXq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 10:36:31AM +0200, David Hildenbrand (Arm) wrote:
> On 7/1/26 10:33, Michael S. Tsirkin wrote:
> > On Wed, Jul 01, 2026 at 10:26:26AM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/1/26 10:18, Michael S. Tsirkin wrote:
> >>>
> >>> So on this idea. It might not matter. What I had in mind is:
> >>> 1. run the current logic
> >>> 2. add page to a list of pages to check, then invoke e.g. call_rcu_tasks
> >>>    (or call_rcu_tasks_rude) maybe
> >>> 3. in the callback, recheck and if poison cleared, go back to 1
> >>> 4. otherwise everyone will see the bit set, remove from list we are done
> >>>
> >>> it seems to not regress anything, and for the rare race, we set
> >>> the bit eventually.
> >>>
> >>
> >> So test-and-set (and friends) would also have to check the data structure that
> >> remembers bit to set/clear (and possibly update the data structure).
> >>
> >> That does seem doable. Do you have a prototype?
> > 
> > what do you think ;) post it?
> 
> As RFC please :) [and if it's AI generated, obviously properly reviewed and
> reworked by you]

I spent a bit poking at it, and it's hairy.
The issue is that we have calls to both set and clear bits.
When we record them in a side side structure so they can be retried,
we have to carefully record both sets and clears and their order and make sure
they do not bypass each other. So if there's set already in the
structure, we need to take it out of structure and only then add a clear.

It gets very hairy because we want to set from NMI.  So now we can have
clear in the data structure and set from NMI bypasses that. Now what?
And set from NMI can't be 100% safe anyway as we discussed ...  Kinda
reduced my motivation to try and make this reliable at all.


> -- 
> Cheers,
> 
> David


