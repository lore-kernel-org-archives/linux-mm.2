Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D49CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CFE6B008A; Mon,  8 Jun 2026 16:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27526B008C; Mon,  8 Jun 2026 16:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7B26B0092; Mon,  8 Jun 2026 16:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 787BE6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:53:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25844402FD
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:53:20 +0000 (UTC)
X-FDA: 84857945760.12.D8382CE
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2C9A5120002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:53:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=V1kieY6E;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780951998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ay3/m/3X5+0dQjvVaZrZxESaXlBV8MmvxOSkVFCxjsQ=;
	b=ETrUhbnRNkZKYUJ3/fktNlds95cswJqqMkFSetQ20WkFZSUXUbh5mz0M6Y77w29vPZ0Jgs
	MZFgAzFPRlauHrlbCtD4oTjIhVxaJj+UPxD8U7WpHHo/75wsJIWOfetX5ujIeVQOQfby5g
	j0/FUp75H6GUUC/IvlJNLn+ImYINiyY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=V1kieY6E;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780951998;
	b=DWxCR23kwzW8tuBwG6OTud5HuqGBJenvGMxiF84K6XITlMvDKEM+2XAsyZNXlqAJVH8sri
	41YRjiZ1bviSshlbKH/xazmHQQQZUsoi50Sa2aiHGaJEIlv3jiY+JEeLJuc1Q0RsRIn1F5
	XUO33O2kxPDXawHDi6TybG0kjEPZkhc=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ccda0ac4fcso49113686d6.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780951997; x=1781556797; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ay3/m/3X5+0dQjvVaZrZxESaXlBV8MmvxOSkVFCxjsQ=;
        b=V1kieY6EDpSiVTU8TvdbQJaQdMdqrEK2eR2cnK2LbAR4L4tXA+ZMIgXGpcGHMVqt+V
         tT5qiSJRbHMBk3TuXJ3MyKLRJqnv3jLYfRIKwSwbZ3QoDZmHi/6ZGE0Pk88NT6xOOdem
         SBLXkT3vYyvPJTNzwbNTVFCyZXdtAO14NiR028VqLD1hFQddrDEEbSGkXIxJxe6VaOiT
         Bf+iHcV9mi8vi/h0IOxt14PYEt/L9JSj67TClsPFDjs/sAcLm0QXmJV7RIKNH5yyXasu
         qCbsboz54Bv3AM9Nme5Xj9McfQfaVcEBJ7cYdgARD49Ma7YL9s5vFN+TFCwqQw9/eVmd
         X4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780951997; x=1781556797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ay3/m/3X5+0dQjvVaZrZxESaXlBV8MmvxOSkVFCxjsQ=;
        b=Sf1/OWqeLXhXmVObNFsaUM46yHFSqyqYKm1DAQgrZ54GnOZJbYa38zD0KYJ47L5okV
         /UWrIyzcB3GbwIv/Dibhsa0Wpom2OEdJtouWj/A98siZfYAMQJ+d94oFtknlAhNRgtCl
         NgGZmz9mXmZtmRP/XbG8ZkU8aZpDlPadICUJopnZbPkcP20HGhahafxqmf6hk3ry+fip
         AnzOo4uZ8/Tj4+oo33xmvWip2oMEoqm4f9jBuY0MGGlkjFQ2DZzsYTyOdHFtBngKutTN
         e9+0HPAgRD4zde+Qd9K5KaPnnfkctaRu/xaiV+d2J2saYmd+gW8yR8XxPc6hQqJLJY1x
         nZYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/W8ejZ/IqLEq5JS2uXcSC8y+sVpW+9staS6lVlmjWz/K9prnrqKWOo50w+c2VBXHeY+pBS1+mw1w==@kvack.org
X-Gm-Message-State: AOJu0Ywp/Hc2gMWFba2Se+QeRdxqA9boqZFOjsYhbgXdBWLQF6FMBclX
	Km2jP8eojHCqo8LteDyreYgWq6GzK+BmNQMxqItvNIYONpKT0A7ZK0243icj75bXEik=
X-Gm-Gg: Acq92OEfnJJqJOAS8EHV8eUNz6l4W4DcnELcX2xYKl49AKK2fgzbfO16W9Mn8mR1eoo
	0N0+9a0qF1kjCyvTHmzWSiYvZ590bBZwK8Dm8LqR4dGdJLVzIxHRL51SmuTfbiDnc0DjZkBPAs6
	w3arq9IMgF3+gsZ5gAvdI2uXa6XnSTtVhj4C689ThKCtDinYBTi+6u7NIpd7jxxq/eqK0/2UyrX
	pnBaVH3ODjl30HA6WrWJD3UXb0QuCuJgwY8X41XEesJ8WBbyM/GYAT81IN1hneAFwSuKF9UENYq
	CZMiUb/aTOOIYdTlUoCjdrfUdptvNrzff9Y+kgij/RiPX899Gfign7jbeW0a1mNgNnXO8ik7NJl
	2s1CJpfQYoRAJm+09a44zmXYprVgraNvbFkE7jXLA0oN3zvOLbfvIB5JPfeKKwksPCQVZb4TZlu
	eYi0SefkYaC45dmvo2XRRIhJYGBV6K45XWYqJyKUb07KvK4wrd8D8G38xVdHrD5pBf5pwFMTGJz
	ggn8dnhslfcSv2KPg==
X-Received: by 2002:a05:6214:4809:b0:8cc:e8f4:1636 with SMTP id 6a1803df08f44-8cee6131695mr193150026d6.25.1780951997212;
        Mon, 08 Jun 2026 13:53:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecc8222bcsm179103816d6.0.2026.06.08.13.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:53:16 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:53:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <aicruns_4nOx0hD-@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
 <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
 <20260608154354-mutt-send-email-mst@kernel.org>
 <aicjNRrHYOOBt0Hx@gourry-fedora-PF4VCD3F>
 <20260608161810-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608161810-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8yh86qh4udsahncrtr6rcse7dg1dsp3i
X-Rspamd-Queue-Id: 2C9A5120002
X-HE-Tag: 1780951997-444059
X-HE-Meta: U2FsdGVkX19X0rEnoySaLkekrQJqgeZ2TvA4S/FHJ6I1hUaTwKaYqw2/MHo6jsQg149/MFr+qRwHRAxsBZb2FFzKcrEHs3D6ipAY/t2pLKk9Dk2cmPi8xr6J6IwqYLZbu+HkZzcIQLTie4u8mDlNGH2AVf08fBDuXIDcqS+pR/mz7LzTdqbIIeEp3PJrd0vOFDd8yjE8ZoGoskmDVzBJO82GFAjlGDoxtULXvgRqyBptVJjJ2dFBXs7ORBJQhIIdfUg1p58LEPbkMWDtviPXKteZ9B/pwSLaGdMl8iRGYepxyI/CEDBuThB7IfLYn6PbCItdOvtI3SkgYgZwFqFin3fxg7LUQbMXpLnOV0LzElp39QdVCY/1ld8xeVTrQGFogDCtiyJBe+8Yd8fxHigc/hgcxXH1KaOUPO3RRXO9JAk6y1H8CUj8oIlIIe9KbzqzRXB/2n1+roSki/JrU2SWVQsUvjT9m70BFMtFqcN+e0AxCaLt6uq95MbMOk5j1XTfrBDCO4P+4VmBm319EskQsHf+UAdQPcVlx5N41jJtigXjaIPZIdAbzeAzwlFKzUtp5g5OSrh2ovnI9YlB9wmqG8YH25LiJl3yebMlymX9TBvg8YBZjE6f+HPqh3IjTP191NpZ5r+KFB150FE4Eyyenv1QhJ4U4qDF84LMiMBBuUMEjnvO0oNlfe646qNc1EgL2qDbm5Tes4FSJzhzhX0J3JGCs7HqCFMAiJQOk1GiqRtmlhOn2agaZpp/XEZUURJdOnDRkpx3AxzsDPP8cFWSzFOesXUMYWFhmdTYiCkic5aHFlhGl355xDrAQzqIwjaf5Rm21IaUqwpof87Wk1Dviab/RUj7ITLrxaPRJjkACelZBdWLuVKr7sE1aqIfrxzUYguA1uAWhUhb7/sn70xnDLaKS/WIQel1ft4+1HaYbz7dxP0mcwNvLzYCUxCojWeA2UGQXyBZa/YRsoIdgl9
 DAqvnyps
 K7wH8Mm6fWtozHKZqohOmod8grL0jWBXJwgQ9bxOQ140y5uPsDadROMsUi7HhAfRNSqSlcbbH6DMBg2U09yJruF+8VVRCKJi+7GSaqcSp+OmSW/Q2K3Um7fYw99eXkpfauaPt64maIDwNqoqtDLLfTOE4Jah46MGXKyoJ3UhAh2thwvUuz2Vq7Bmoqr5l9ZpF/d4NJxjWFTL2thWACoaOZNJYdv81LOD5htBJi6a147CQ5+Wq7ckXwMYPc49qUL1oOzpXt5Yh/XyRMsfsg8N5eK00X4wuy3H822hNkigetEiDjJa7gUsUep+l+vlXck5fs55Bhl22dFHgH9ejIKE3jXe8OUnt0pKrw86unCKBDP+I0t/dX0z7reKAzH7bMg1lJEARwgG134pnuwceHvZ9QCsauuh3FcfcIbDBlvlWVgI8ud9E+P38rEs/Lg8UzKlZynT156jQKnp1o98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:30:46PM -0400, Michael S. Tsirkin wrote:
> > 
> > Please consider that this is arguably the most fundamental interface in
> > in all of mm/.  All we're doing is going through the process of figuring
> > out what changes here are reasonable while trying to meet your goal.
> > 
> > ~Gregory
> 
> I don't mind discarding all of this and doing something else completely,
> but I dislike it that multiple people are apparently now angry that I

I wouldn't say anyone is angry, I think most folks are tripping on the
complexity of the set - which has increased (at the request of others).

> don't address all the contradictory comments at the same time.

Such is life in mm/ :] - it's hard to known the entire state machine,
and sometimes the contradictions aren't even wrong.

> I thought just sending a patchset to show how the result looks like
> is easier than arguing about architecture, and would be helpful.
> 

Notice: When folks argue implementation, they largely agree the
end goal is useful.  I haven't seen anyone say your problem isn't
real or that it shouldn't be addressed - just opinions on a particular
path forward (which is utterly normal here).

Getting the right incantation of an API is really hard when the
API being changes is something that underpins the entire kernel.

> I'm not pushing any of the mm rework, I was asked to do it,
> myself I just want the ridiculously effective optimization in there.
> 

As Lorenzo, David, and Matthew have said, the focus of the patch set
does seem to have become unweildy (in part at the request of folks
asking something be done differently).

What needs to be done now is to break it up into some pull-ahead 
sets that are easier to review.  Having a brief RFC doc that lays out
the set of patches might help clarify the confusion going on here,
especially as new folks come in to ask "What's all this about?".

As a start:

  1) the user_addr and zeroing piece seems like a discrete
     improvement worthy of its own set - aside from end goal.

     This is needed by your patch set, but was requested to
     try to push us towards a more reasonable pattern for
     folio_zero_user().

  2) There are a handful of patches that seem able to pull-ahead
     (some of the mempolicy stuff), either as prep work for #1 or
     just on their own.

     Some of these patches seem like latent bugs that aren't hit by
     current users, but do seem to be doing something subtly wrong?

  3) the final virtio piece seems like it should be entirely separate
     once the core pieces are done.

It's not uncommon for core changes like this to take multiple prepatory
sets over many major versions before the final feature lands.

~Gregory

