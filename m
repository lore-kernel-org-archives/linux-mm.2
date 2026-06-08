Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C62CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967E26B0005; Mon,  8 Jun 2026 16:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917FB6B0088; Mon,  8 Jun 2026 16:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFE36B008A; Mon,  8 Jun 2026 16:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 686EC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:02:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FDA2402E1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:02:55 +0000 (UTC)
X-FDA: 84857818710.05.10907C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id D84F1140006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:02:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kp1idXUg;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780948973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jC1tTvHqlbFZPbaAWrLUXLjciqPdje/xAc2SJm5nUKk=;
	b=THQ9nx4KmC13DqEnpoZ/XaYHCtDSu1voOENJ0OPPmLqUIHI56EJUJLCbLowA/NFAlbJ14F
	w3DDKkz4LD8OBVzxQQ/QVE2x4SJ7U0WVP/8z3uxwfCj6oYyqte40lFLAfJb1xC77h/pJ/i
	x052UzIsczNFwHpFSApkhjti7WiSyYw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kp1idXUg;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780948973;
	b=cm2Vl9ck4hhuKrX03YQTITciA2n2ZwGI0/NT+n2ePIDbe5iV/3oDnrweZ8D29CeYfdl7CU
	gZxBMXfGoqJ1YzrH4lLCXZ2qtDKeiVIneVzsI+wprbN/7mklhylTocMWy/sUTdLVrcpJEQ
	SxIsnMegGinwfru3K7KzhVoxcnkXYYI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780948972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jC1tTvHqlbFZPbaAWrLUXLjciqPdje/xAc2SJm5nUKk=;
	b=Kp1idXUgo+IjGLwjX/4AE+At5F0/chRj9agnC8h65SmH5xi3zF/UlnJIBfr6/a9KSCg/MT
	W4IFJ65OW0S0qNJg0SIS2QXhgBUFm6lwO9FIYQnkPtLslDin2L1IVuzyu3yqo826vGhFLY
	iM1ynNhAadY6zdIsQP+LM/r+0D4R8q0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-2N6vzEQMPpK5Ch-4Zkh2Ow-1; Mon, 08 Jun 2026 16:02:51 -0400
X-MC-Unique: 2N6vzEQMPpK5Ch-4Zkh2Ow-1
X-Mimecast-MFC-AGG-ID: 2N6vzEQMPpK5Ch-4Zkh2Ow_1780948969
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490b9cd54f3so38955965e9.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:02:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780948969; x=1781553769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jC1tTvHqlbFZPbaAWrLUXLjciqPdje/xAc2SJm5nUKk=;
        b=GGuPSrButlNm9qzfmjLUQGhkAbzehcjnq5R96IqTJYByHVaqPQmVhB/BJcz2Hi83ik
         wv0fiVzSpupvMHfoa1wpD83O0jMa8KI2O0qevebIHWnLfn2Zy3MDlY/1DKzBd8q1gj/a
         ZelGeUvJ5aGeliTMgkQjaNtiDPINpfTtdCF2Q2I5Nx/3mKhjlaJQYTst3SS8k0xVoUEm
         9CxKP868gb/ZwlTf/CNXusb5uHdEQr1SudopnNF2p11phMOR0h01NiONxDUMFZFOSNfG
         CLxuPjh5N9kk+r1eR7seivEMFu3u+aFdNT34HjGEhkFodrs9Kl/ahDAsWijmi8S+iEey
         nTnQ==
X-Forwarded-Encrypted: i=1; AFNElJ8A5vKs3W2yvKfxpL5V+OEqz67wGrWyntR1F4eucDELMPUW6VbyDSkj2PINUvhURJD7+xs8vHqo1A==@kvack.org
X-Gm-Message-State: AOJu0Yy2R7tFvT7NZNIy36XUs6XYYjdyueFdvwJaDAaufYUq6O/4iOnz
	rd6U7GnBLDm71belmHsrvQ1qDc0BMxz1QNzqQ/BE3qtCTanOFa4A2N57yQTRqe9ltDH4S+TIGjv
	qUJwY7k8s4Z8HJ2Ncu+6gplVnAEPiPwzI2psXGdIBzOOo53pHhjvR
X-Gm-Gg: Acq92OHLRJAPKIwtUd8xke3Kyk9ByQMnEVLe524dnLjl2RABgtcSECC6GogHTPgRfFU
	aCKbMWGMfNrbJ2fXSf1sdjtLtGetbAclEJNfMUleSLhuDpNQQeJLer4FlgqWQv4t9STtupk1kFh
	CKiCqzChSfTNEyWOeiMx1aUPQtqcewM4flDGLNmJL8ys0d99FYp3xAEdSvcWsNizS00BSv5An/n
	8uKmpvXDg7/W95w7CiLkYieQRFxMlMCXHNm48n2J68lqqCtwsyFy3t7CX84KsiY6kYjg8HwaGUE
	zKSPFeOvXd20hSjv3j+D8PIaFFybRTnn5/aCo9GhYbDXXadDbQgaDzcx8Zs0vvuKUG4hrPqpC80
	/AWJ8mMIYu7B5kxvRx5tAjZOaPR6PNl2N9zYLbupcM9Ls0JQVjEdmFQ==
X-Received: by 2002:a05:600c:8b6a:b0:490:688b:ece5 with SMTP id 5b1f17b1804b1-490c261b08fmr264136195e9.30.1780948968659;
        Mon, 08 Jun 2026 13:02:48 -0700 (PDT)
X-Received: by 2002:a05:600c:8b6a:b0:490:688b:ece5 with SMTP id 5b1f17b1804b1-490c261b08fmr264135465e9.30.1780948968213;
        Mon, 08 Jun 2026 13:02:48 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d663csm466704125e9.11.2026.06.08.13.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:02:47 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:02:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <20260608155918-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <aibP5W-fGcyPp9e4@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <aibP5W-fGcyPp9e4@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eZRH8amtfOWN9C5qw9knGiOyihPjGsnOUCVWlNLquxM_1780948969
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D84F1140006
X-Stat-Signature: gccubxf58x8s994a6s8g6euo7gqm6cfx
X-Rspam-User: 
X-HE-Tag: 1780948972-905486
X-HE-Meta: U2FsdGVkX1/t8mZZLw4T1gW9NYYg2+/qN9qZcqYiqJ7PLHQm4wubXBsh00mj690M+VJEm5cifE2XTwnkv9EHVDGaTht77BRn7vXeoqOLnE8vqWxlKSdr1ysU5JrIInKjOHpmx+izLClXM+5OhkRzf4KUztbJxib7QySjIj6Trwmnhk6fTKjBI6gpcyyLvlmK3tGO5bUDtSgTp9s8+QyLu/Rzeqrp0cRAqu4bTArIgNZD1E7vsWINMKhOo3+PoltqxRKLFJI3dvHuHnfm3cW43Ytk7y20SKPYxeyQIPobXMeOLunSTR697rdR49DI3XtAC+C7p62nfTkzRUzQ2jjaOJZ/lanqDFLw2hybdGAWqlgXvnd4bEM73dAFHquBz4p1DxnFV2GHA7m/FiSLBZwxuHdn55uIalI7OQbJr+YsPhodU7TRwee1WtYs3PrHI6E/UMog8EgG5YNVhkwmdfQndiFXJH09udx2Xb6/kpWLYjFm1r/eAL2swd22foBaPiElRi29zZnSi83juIyC04jFiLZ//yssTXvoNdbBa97lA039c0UvuXQqTnHBhiLPTB8JiTjG/oRmOmoKkpH1UNzG87xTEIiORV+Ao1vOKKKTeI/7YJxEZ+iy8wQgxctHQS3HGGEM8diLVPqK17gc2zFTkHV5zb6ub4ydgrTUjodeUgIJ9PL68iu5DxfV+awgAkvcWjUmIWHGXo24L4zk3ChWRBpcvIh2tbNmJQEAvuQn60LKhcVeJAL+2I+PpceD2xVHdbzLo/FfHt+8s6xQY08O5zwdJsyCoAoJ7Jok7e1gDQc4eZBnVgadj1X6cfXDmTmzXz0xC9POFynt8XFKBXUEDB/CvF5fipXmk2ahVQ+f3FKNjk5su9IVXq6qB7dzOXWKUt5545NVvawb53jFvNXCPAgX6bnP8/ia/z6FBiaSKuQofrJFA9Q4IPbMPWEOFGc3CPEv53KH+wdPpm1JJWE
 Z+PedRiN
 baQ38Onuk14jI1cBQe8JtbTAw8uRClABR/h+Bkp88/tJmmtldgdbqjgMI07Q0CGMDbcldrRt6qxPF801WzOGOK5BFhNn3HJDsR7Ljj1ynQ2nOtz6GCLtupKqc1I+rtRxhjO20rBw6/oC3/hWCe4ezJi/Bgc6d8//zsK6HG7xDlxNl27u7LZHAFVrccIlmUGTWiZjvpDkOxZ7oIdItVVktf8KJX8d6izzayXPD8JzVAtxlqTN2LQukDlg3fxlmQ9nwNUDz3hKH115Egq6fjoIn4UtISCs83rTo9Oxc2YEftHv7tuJ0W3O0I7Wl8uw3vZfVM19xtek1XjX37CuFXcHp5tcrvnmG57QIkqrU+0y5evH5FvfCX6oSyPDL8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 03:21:25PM +0100, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 04:33:46AM -0400, Michael S. Tsirkin wrote:
> > Further, on architectures with aliasing caches, upstream with init_on_alloc
> 
> Further to what?  Did you leave out some paragraphs here?
> 
> As far as I can tell, this patch series decides to trust that the
> hypervisor has zeroed pages that it allocates to the guest.  But
> as far as I can tell, the trend is towards less trust in the hypervisor
> from the guest, not more.

AKA confidential computing. I'm not a visionary, no idea about trends, but
yes these are used more than in the past (not hard given it used to be
0% of the market in the past).

Page reporting already leaks some info like free page addresses, so it's
for trusted hypervisors.

Anyway:
Subject: [PATCH v10 35/37] virtio_balloon: disable reporting zeroed optimization for confidential guests

makes sure guests that do not trust hypervisors are not affected.

-- 
MST


