Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C94B1C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9195B6B009B; Tue, 22 Sep 2026 09:38:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1E46B009D; Tue, 22 Sep 2026 09:38:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A886B009E; Tue, 22 Sep 2026 09:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9026B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:38:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D33CF120476
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:38:53 +0000 (UTC)
X-FDA: 85241503746.26.5ADC1CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DE4A32000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:38:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LgHLZOsa;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790084332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/a/f7Jh/MiC/swvVwqUhEXfqYE86b5oqe+3Ff4G++VE=;
	b=ZQLZr1uHDcQ+yGMtXuwUBa3o9SiaziwDGp744kibLjpMBtjGp1Epvt2+a3f8nJceBTZyZs
	RN18f+Ipg/X+se9+wvgEoLfep+D/cgmpFIBNLAyQGgIT0ThSvgYHwarrF880oYbPu5Tfka
	woAWxLKDtBUyYe5JPAP4EflDY9uVXV4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LgHLZOsa;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790084332;
	b=7jkldu+v6cb4eH08mhiHOKqdAYCYR3HC/OtAMNIXUJI0R11RPCcTwHhaKxJKtIVUTgH0vU
	abxbf1TIZ4wlVNKABaKhGPVU8yXFVzXU7f/nf0KXsfeZGAWZBcENcCg+MAUqpVQa8SLDOf
	DZCPyFzZdXjxyTbKxmtJgWmh3sm/L9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 280F944E4B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9621F00921
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790084331;
	bh=/a/f7Jh/MiC/swvVwqUhEXfqYE86b5oqe+3Ff4G++VE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LgHLZOsaiLR6vEnfNUlQTY6oZ9lvgEVB+v1NKXB/7X4n71pwqtLIrApTSiD7ySt7S
	 HyLboP0B3gSKrpbNLp/+DPYLQXPZgIU6Ll1vfcQAusS8E8NtWyerjL6tgSbQgSItT/
	 zOqiJYMTe8O/M9LtX5D3mTo+SOV917k7m6JLtiJck4QLNWTOpao7KN2sUUmA03IqGr
	 a+l8rch10YaCJPB2e0Zzk8f5oorNcgMbz47E0UM68z5IWhrkPjPm4VkhNceNXsDuWw
	 jRcKi6pdnWQteSxiKx3FG7TdgBsDcrhFvBqVKTSnIfBDeWT3iJ6o140rLWVMCCwfju
	 6PSOxO9vrgInA==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4aa8d881so4311988d50.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:38:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwF6VRU+7i8xAOC01n4P+wqu0lUUvenjFoKBoXOyUPPg9ixM21Kot1tZJRJVa0XwN//y8NfnA+Qlw==@kvack.org
X-Gm-Message-State: AFuF++lVpfRo1J3Amwh4LUhXfMh3tNYEY6bRG7UwuQKjvK/VTeX6VObi
	ARtwgfQMSYe4fXjwWConb0pXHTRv1WdW3VGCQYWJArMcQwCU061DCiSZPJfqi09Snc1Dc6DJjr2
	O3KiwVRmFpM37kxU9reV2GpeEQ7UHTh65TdpHmErC+w==
X-Received: by 2002:a05:690e:a4e:b0:66e:542c:cb48 with SMTP id
 956f58d0204a3-6717fd907d8mr5090744d50.48.1790084330182; Tue, 22 Sep 2026
 06:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
In-Reply-To: <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 03:38:38 -1000
X-Gmail-Original-Message-ID: <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
X-Gm-Features: AcwNN1WgbakYkTh0yR3GKDNbi3ffYcCIIuJkVAws7zFs7ymxySYDN4SZgg1CLuk
Message-ID: <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE4A32000D
X-Stat-Signature: xrofcmxrhpszt4xho3io4dcnz1dmk98y
X-HE-Tag: 1790084331-332087
X-HE-Meta: U2FsdGVkX1/hdeIbONaOcE28Wmo3eNeSJW2YH5g/x5xuxkwwtTIjZg2mtMhyga1Ma8xug3qYBkqz+uDTxmrRHR3SOyiLcJr9SkSXAFqP6myC/KVDfCFCPFH+BqHQLRzBZZYgNT/mXJsBK+qfZ5Bn3E/uptv+uY0XLYhREoKodRjI2EYmTMhP19+z2jgV4PE54KxL36BWpJUACnLVej+TSgHDom8jEi/UKAC0lvrPw3peecsZmh3aJmGCZxKsnlC1Bq9zCzr+i5dtX+kUESUeUr/abJJUHfMmrIO1d5REHdQskSvNH2UJvd74vweQ1rmkx5q7tTj+VLCM8JVzpWtiRwH2um5zBG2peGKT5c0XuTz4UmU4fjJqzmj1P7sMk32tXNpFCU1nMdhuf0RedLef/qZy27tZg2qbsnuXiIEh8C31O5DVumv4DEL3byNRAME7LPzZZ+RPMigfewl1Jj1qya0kGa+dhVB5Lzorc2jbZQ/49VydtPZyDamAXEo9fEAr86wVBc/QU9DmR6NvBuwvMUSR/T9Y86OwYUfvfAx+iowVGMjF/y6puOQrhjj0kgqAOnAemTqi++5s5CwyMCmVlYdvz+m9OOXwZGRW/I4e2aO3GNkMbffGd6wU8vzWBKpemQU5DDtRn/aKtYbJLcJQ9N73eQgKNTCZsRphvaqHrPNUKBTsfC0kx9b/iMeNDzgKWahs8o6ILfwKYocMndX5JcokHf7tBGZQ+kyq+PwwXEt2IhVqLk5WyEuGumHD8vjpRQlWkgssb53LBBm4wiptYAbhIUff3mBSMNfLttLE08OJjNdf+G4XcrEA542KAmbo5lxoHQ6ViCEVYqnjGHTF50Wqx+CDaJh1U26HRhaSvF7VQK178VSOmkdGBupory/yHSZ4y6U17EDtJwy+ONUfChLVfs7lGIBFYR/Aqz1qRR6qYyYRbSxW+t84eylyYdtAgptEi7s+h1HVzY8p+1k
 W8d93QBc
 mJvWDFNLKWg6zKZa4nr7wegu+ZZWnzziZA0aluHPB8DaH5a0vZAXp7nt4blLWuLEkxU1xDMdCCkLbNpp4tzi8qCCytTLa4uyztMCxNBJQ7sz4EvvOpuBqgCC4/GRoj2sP3Lk6ePN2SjLSURkrYLsqnQROCpsgQ7E49AnXU8xGBShZn7wt/YyNt54fPHtZoqJCnWiSjbnFI5B2YXjL99TcGvqsFPUcj2VuHVOJXOCgCBQFIg7VY6Cp/df6oUyz5pyHJvDxh6dyIy1dd8ohly93LKmJa+lS9LMEGfE10DoRIiAN8B9ZtWWNH03UWg/MQK1A747KdxNaCEUiWgZRpQfguKj0u2VjkJvp46tALgU9IjJ6XLROuNAcjGI6dtlJzOfT/uOf0JI4SNf5wSfgVZ42AGEk0ZKykYSvxcgs+rQ3tgUjKE57Ee9Awl3GeGcpHKtL3yW3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> wro=
te:
> > No that time slot is too late for Asia developers. I don't think we
> > should use that time slot for swap alignment.
> >
> > We should find a time slot more friendly to Asia.
>
> Any time slot would have that kind of problem. We're spread out across
> the globe.
>
> Let's just use a standardized time slot we have for MM alignment sessions=
.

There are more swap maintainers in Asia than in the US + Europe, at
least based on the maintainer file. Please be more inclusive. If the
alignment is done without key stakeholders, it miss the point.

Sigh, we can't even align on a time slot.

In that case, let's keep discussing on the mailing list. At least it
is accessible to every one.

Chris

