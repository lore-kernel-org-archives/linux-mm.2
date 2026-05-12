Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C817CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 15:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B39C6B00A6; Tue, 12 May 2026 11:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D1C6B00A9; Tue, 12 May 2026 11:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE3D6B00AC; Tue, 12 May 2026 11:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6926F6B00A6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:40:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FE56C1F4A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:40:15 +0000 (UTC)
X-FDA: 84759179190.16.20766E1
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17027180014
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:40:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NqKib6Al;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778600413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRmPo6ChRyQRQvzU7w1RFJ68U7NrVdIIy+TpNNJLR10=;
	b=ToNrT1G9yyBVQ3pJK7RlaJ1dEbeMnwrQzCQEjzJH/whl+jtMKqtax4zrc6N2cehFqW67zv
	Jy8uF3HmRiVoXPxXKILDLZWnfZLbTppjV7lp8fVbb0b291G48QPVJ115gIutcmRnG2oAKG
	6K/bqvSdPEE3H/Ah/BQ2XDnuZGO6cE0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NqKib6Al;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778600413; a=rsa-sha256;
	cv=none;
	b=zPb3HIinFv39bLoJ0SULeW0tcaAOzp8wcR/0FFaGOkA56/ZwjwDcopbHwvBINshYybdgcI
	cFb5xCIAhUs1fSPXDT5Bq5n0+9XUD8H3jdTvB6usFBt29n9nYAEcKT4OjmJ0pUMRzqOpSY
	hR7YM/vvWUFpcCcEvWerZAe4AAMaA/w=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50fb1ad3734so68588501cf.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 08:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778600412; x=1779205212; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nRmPo6ChRyQRQvzU7w1RFJ68U7NrVdIIy+TpNNJLR10=;
        b=NqKib6AlUCwagv2JS+j0bI5oYepj4b2odWm+PZZ3qtQuUsshmtDig8JrX7owQdYTT/
         2mJagxXlb/STQ4ZPeYuQpD8ywmQzF0Lk1INKOs4YYpNjlcWplUNpz9tgIob4he6/l9cq
         bCf9Sdqk0r4jPwTrbTjSuiw9snevFtLdTWonVjxKoYOrT6SiJl9m7TrCtBkmtL1B02jy
         kDrOn1N1ok0Gh4bcmrBg2TQkkm4Y3LU9XidKWxbTs1bP7JYEf7pww4u0CCCgaWX7hrjm
         CRBO6awP64v2wRZ0DepW7CoLuzdSKhNB3i/YpncZGJA65st1iN1PctXMk7kFvWncr4xN
         j9MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778600412; x=1779205212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nRmPo6ChRyQRQvzU7w1RFJ68U7NrVdIIy+TpNNJLR10=;
        b=Cj+SZGxbDSkIEMq8SRQD0/eC4D03dazpwXXUtmulobQniiiuhqMPKLIdehU1s3PKVn
         saBl8Zh+5QvmPrCI0xJ9VeDfiaguZAbtMvlnjvW05S6O/cPtHdseT9J4J95dAB+5t3X/
         ozztOoHC4vX8gDKW4Zwf3xVRKd6KZ2AUgqtncDcxQOD5K8hZqMZ+Ee5AObVbogOfug7e
         Yhq6yrF8aSugcPL2OskxJ8TytRwOkB+gP+OWsLr2zQwVlZANC0XStpQe3yzh5EOk6EeL
         JvS+KqnQHhm2+v7c2V96zF9kWVOp6/UaoqDP1GgM6jolBpl2ZM+HJX3g15eAMAb9Bc1b
         O7cQ==
X-Forwarded-Encrypted: i=1; AFNElJ+cK5cz2xZCu/xa/W3A46iEAmeT9g3qzh0dKrbt1pP+wapXTdpOoowwgJnR10fCSPdIM/Y/xE5XGQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1cPJEPnXRYGwhOS2KXMeKLmNDanDz3hGMN9U9gr8JVpowpdvu
	fICH77/ARd43K0Rax1S4YbusCPXqtloSd7FvX24kapo492ku1ItRosCex06+rKq0Qkw=
X-Gm-Gg: Acq92OEhA5Wj8Pe4woMUFYqlzHMjR+N6zRJftgITlYLPxYExLzOgWDSHvTyq71g/v/F
	CiS+5HuCGdkb3y1P/yBmuI6v5OE8SmYQS6Y+bhODC6wzuxcCOdd/NurMGtKeg2h+GxJtk3EGfzc
	n0RC+TRxMlMrbTXo/Pka5nbfLxMYGBUnZqPs+SRFdT/PR1gNn0Q9sIzpJ3VIzilE3HBuBe4VJr9
	8htHKCmABgaMvXNvj8qclFi6JzLwaiVW3naiJoSDeD2RoHxU3bTEnemNNPKys8R9DoJhxQTY5El
	nJOwZlW+nARWgKu5RpAcxJBSvx+WosR401x7BvIP4Qd/cIPpmqrVHNtcaxh9CbYUnfndMwNSG3G
	oMxNa5aTWIQbFW2ji1MvTmbEbjGmI4Jo3vC2LOR5qlJFVUsy7vsS/cDnwoGEXw5y0aERCCL7bMd
	qlOSAcpcmdsZymP5uYU7IiQ/lbHZJxfgBbbX1TWnJFo6vvqH8dGtKbEmtsobFGpdFH0aSUACYnt
	RvFTunLesZ9
X-Received: by 2002:a05:622a:1a85:b0:50d:af03:c9ca with SMTP id d75a77b69052e-514cf02bcabmr55182511cf.38.1778600411826;
        Tue, 12 May 2026 08:40:11 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e83dd35sm121584711cf.29.2026.05.12.08.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 08:40:11 -0700 (PDT)
Date: Tue, 12 May 2026 11:40:08 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: Re: [PATCH resend v6 17/30] mm: page_alloc: propagate PageReported
 flag across buddy splits
Message-ID: <agNJ2BFRVTKINliT@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <6d98a35c94fa44b550afa66923c620511e2826f0.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d98a35c94fa44b550afa66923c620511e2826f0.1778489843.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 17027180014
X-Rspamd-Server: rspam06
X-Stat-Signature: xxnsbbiaawgeyrti1s7xqo8mwq876ori
X-HE-Tag: 1778600412-122971
X-HE-Meta: U2FsdGVkX1+1HHPvATt5jD5HZIm9atOFJ0tYwbOUoSWsRVD24p0IDkJum0eB5Sl8ZAXPNDWbeKBXh+Fr6RfDb/HhrAV4iKmfjWdn4PoWXfRrOZftg6w3F5hFTLkKJx1f/onIj3TUOoiOh2IoMb/U1OY74MsLDhtcTrdkZmrFBEr3Xm6bac9mpfIzUII01Bk8Bvys7Atis0X5mRXslJpterLadTM8Gq+H5Gpn39nh9K+i30prSZtKEYu3Ts1ujV01EOFEotnvpXpDD7rg8NFtRQZuAfVEB5GNqrca47KJIcvrik3OciNlLVbHta/h9oC4mcbW80+vKeT1WUM6CMaW9F7kDOy4cSJTwGf2ZhL8uVNEoX5zVim+1M1EGIcwO0C6hBfrYfyWvu3tHLQu2QnnNkO/Y9fqciTNzNB5ncC3pdPCAMApntxonr37msN1Icd01p+u6t3q+oINWMQJrpGjvZD9Ytf5lrh8NjNaeb0ofAlSMc5jbpOCAIuan2DTy2btd43eKsCXJxF3K9xR2pWtVkrcprESCyqgxQUL210xPKxvuXOUDtPb1X9/jFRzsp+NLyObHmQc5p6vPEOA+Odea3CYMo24NtKPYenKB2QbujEaKKxggnaNDe/KT4mLZ3cth8dLRdyxUd3NUDut5j/51FFv5WNGPAX4VbxtTk+wGxxwubZuuwDUY3/DIDdkyYJv0cJ4wOvvq0vHxWvJj2Nz7z562Rcpgkxjx7hDSG2dLOcrn/bfNC4kZeETNwJQNmjVOnPXZAExRkTtuUbR0vnOEw9K46bzI1t81L3oqTGWTNUJzH0OVyl+DO/YBVRhBqQhDJjJUk+RpkKuk8vNm2aarncCuxAaUaHPdfVou4rtmxAeFpeZEuuMTTltNtfTyol5AMwIwi6D2CruikMhximgNdhpdPqRHkKqq4PeWeQU9lcGQFkI6k29Zi8W1+pVIY24dgsZsLn+pb3PNJ55MmO
 JWK1UxLG
 b8zCGOdKe4AMzh66L/B71PH/ejnms7Z0c2ZV18OmnIEmuPBxzHN+EphzNJvNYrrajLhzXjTugJfY3cWugOuaQP2JQDJRizI4XmU2NFGTV3lohSYOxGD6U5qbAkcMdEmYfK6m0F3IDc9vmHp4gE4q7mo98DWi+Ix97uP1ZU7/Nhz7RcZyTZi38JLqYnDwXkW/NHMJTkx5XdK51FfITpuIhxZf31bX1itNUBnHjIqc1HW/wpRn/b8psI4qoCKFTRRvfV7+P/WGFe5UNMXWicFSB2FI+wdSxSTmIBpJsBktf0KloW0Aqssio+Kxc1AsECKvPtzNjOqb+s8lK3HulVs4yF/UteB+UFdTemr05NIoWUABUXEYDUW+3I86E5x6ZKLJm+T9vKjET71XTem8lyMR/x0iqr+5eyL9Z+9zik0um8E57eMyvZCPITo8bEYND6RMB0hZds0GEIRDPHI5fw2dgmgZJSXn3k70Gqkp7jJ6HUakzp5s7saq+XVTVuYfPiX6+ep94bb8QnYYh4lKZCXyzUgssz0xmMvCsE3Ih
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:03:19AM -0400, Michael S. Tsirkin wrote:
> When a reported free page is split via expand() to satisfy a
> smaller allocation, the sub-pages placed back on the free lists
> lose the PageReported flag.  This means they will be unnecessarily
> re-reported to the hypervisor in the next reporting cycle, wasting
> work.
>

Is this issue generated by the changes in the overall patch set, or an
issue present regardless of the proposed zeroing avoidance feature?

If the former, then maybe just submit as a standalone patch, seems like
a useful improvement regardless.

If fundamentally tied to the zeroing-avoidance feature, then nudging
this to the front or end of the series (depending on conflicts) would
help focus the review of the core new feature.

~Gregory

