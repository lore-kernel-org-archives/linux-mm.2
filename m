Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B70FD9E14
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6236B00EF; Thu, 26 Feb 2026 16:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659D96B018C; Thu, 26 Feb 2026 16:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B6A6B0193; Thu, 26 Feb 2026 16:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0F46B00EF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:49:04 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E62AF1C0A6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:49:03 +0000 (UTC)
X-FDA: 84487948566.06.C362161
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EADB840014
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:49:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DcjIXeLg;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772142542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8h0E2AoeIQ7Q7IEHkeloRVm1CHFYLJOi16YgreKPWm4=;
	b=durJR0CGzUJGpgN8F3BY8qCpR3+S4zDQhZAxrMOghuSJKZOFj9GzubrAgZP0xyGS1CNo7p
	B6ZD9czYTSjYb4HYbNXo52Gp5VipQ/ShY+7mVDa9ITa9eF/H4fSXI0jB106UeZQwkVJJoL
	8G716tGA8olEphK5DwlyzRdH5f3ksoY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DcjIXeLg;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772142542; a=rsa-sha256;
	cv=none;
	b=K3oYN5qIDYKh9vSHdvn6fygDnll77JNUolbAIHMeTlhOehu7WEP1Z9JXg2NM3SeMNYfon5
	Ruao68HoSjtNMgW7FJs/5FbgcTFFHl5dgSeqlmvWQ/xlRQ2iy2QPVDuxjZvPx2fEZKU8jk
	e6ZU2Aw3vd/984boTwd4UWrpspIfZqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2E1B41B09
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96268C2BCC4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772142540;
	bh=LF4bwcYv1+PfMspbbpqO2VzfLK8CTRaCpOj6mQJxZGw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DcjIXeLgrxqUYwwv+2hZCBu8T09MVdaj4sSw8in+d9ikwiv6jPM/YXPBL00H8vz+L
	 ThBlz0nE8Lf5ETYcNtggwxUpTaTtpxvJzo6zuFsbRb8XoqlA9Fh9yjWBh0hxolp6uP
	 F4RBlPeM6zLgUqIIeXrHHNM23II286EyJloqnQZQDeWWJH6pSFZ/PCtkdKVacnfQjO
	 j39CTWgFGDhh9HZ9An7My+BGm7MDURWMkjqHI10HW8SaosV01xNYbdS9uJSRV+fDJ+
	 jhAZOaOllUvBy/kqKwJuum3OskFoy2GeMvvV0xHQSbc+35MVaFPFbyqJ1+b6Gwa1RP
	 ewnbRhbSJ1htQ==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-64c9a6d68e5so968400d50.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:49:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWrbroqvbCSRJ+4dreJErOpPGWqRGZxU1bOfj0dnH7aiaK/uNRc83s/qTdE5DoN03RIV8chFrx5vw==@kvack.org
X-Gm-Message-State: AOJu0YxxtJLIUh8myYND7To6Dh0oqhj5NQw553sTzhmW8SZ1Ze+L4qsU
	obfX8BrIXFvbgVKnPnX3i13giX6hxd2zNmIKqfnMkEjyLNfQsLJ2gTIGT1M3WyPqTVEYcjGiyWq
	1jlD8cnspdFkRb3/irMcDKzI3fGbzv3zjuvRYgvL0JA==
X-Received: by 2002:a53:e8c9:0:b0:64c:a81e:f2b2 with SMTP id
 956f58d0204a3-64cc211f150mr699646d50.27.1772142538704; Thu, 26 Feb 2026
 13:48:58 -0800 (PST)
MIME-Version: 1.0
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu> <20260225-pagevec_cleanup-v2-2-716868cc2d11@columbia.edu>
In-Reply-To: <20260225-pagevec_cleanup-v2-2-716868cc2d11@columbia.edu>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Feb 2026 13:48:47 -0800
X-Gmail-Original-Message-ID: <CACePvbX5Qm+kQLtCWynvO-2YtoW0mdR+V6rfq=buR6tfR1A9FQ@mail.gmail.com>
X-Gm-Features: AaiRm50fP40RQkljlPLX-PI1NSM3iQnOuQQEi7r5tKbV7kaWVe_vUmPk2uGLYLk
Message-ID: <CACePvbX5Qm+kQLtCWynvO-2YtoW0mdR+V6rfq=buR6tfR1A9FQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] fs: Remove unncessary pagevec.h includes
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Paulo Alcantara <pc@manguebit.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-ext4@vger.kernel.org, netfs@lists.linux.dev, linux-nfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, linux-btrfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zb1y3xy9p97153k6md63wnoiwpuoeix9
X-Rspam-User: 
X-Rspamd-Queue-Id: EADB840014
X-Rspamd-Server: rspam04
X-HE-Tag: 1772142541-745746
X-HE-Meta: U2FsdGVkX18+7JHgcBuoI64xOfVyqrKG519x0T/PLsWeCWF3fM4N13ojZcQc+Dl0CnkZezucggGnUBtlJ+T0ORjba3kfQ5srPY/+YylOgRt1Vlj0TKDCsHcUX6DTrlYMnxtyDBNN/E6QOECjNx8qKCk5MA4Zw96mPjSb4cF7uAQ01yltkF5RgqzSrH5GzNO8ESCCbnkNRZBH5Vo/TpWvY8r+G8lmMI/bx6FzI773xFmUsgkGYlARDKirS1jWdGnpgjTxW6G2Gv/4PbQrgx6ih1Uu4GGFSpxnPwEA4JG/DyWJ1yl8yDNa1lUy24mFfWLcj4g1T4E9CO4ZOt7X8DXuyA29KJK97BR0DsYkFQ97/tt3kN36hoZfkEgrE/yxHNE1YP3v4JwshlXB2xKOPwM47/hq0IQWI8AxDuCiWhnAvbDeaJL6eCOKw145bsbxParm2cp1/1Bvp+mBcLCYxKbDcI1lp5MIPlLy3wUw84TJv9U7MQeje7MSuwII6nYE0yRph0OiJe7HV/tmOrzKKpnN16DsczAcHolVz+6ocJ1rywj7IPDth7r/XPFOqgwjdYJGoKSZ8V6RphF56emlM3XgIIwKMdJc69cdUF2508WlP7p6Br0jI/ExEt6UGmZlJqJE6zDa4rMNj9rRTdyWdbABDMv2YAMbZkah/FqXk5hnr8iW36/EJchkIZacyBQuy2AeB7WMIU149oAboeG6WTrOwusleICWOjQ3BlK0sv14vRYFKxL7GYr5CR8WMzXueuvPkG9QZfZILkciSSCJKlqF7NcKxAWroCry1TEa7jU9/PiFqBAVxqBYccmRvjB2E1/9U6R64ylDJpNE1+uDNOU/7Imk9UHh4++dElO4As21HTh8G7OhSG4CuHFiyfAqFj32JABVbzfMwb37ItoMf8p27wOR1mJE/7HJat25lxlJOnN0/mDXpXtPLarUMlxS4xVtG1mHVc374FzxkJqzkSy
 Dz6RpcXp
 1yR//t+Ob6l6PG5XGrAMGcT6Z9JHa+eGAyyE+X4Pdm6zwr5zcxhimLBIKU6EQvYUX0s9BGCQadpZkVwmKDWhr1Qd87bKXOL8lxq24eT8Naxbarnj2f+JOazUmWeDLLiwEINzSAcXceUgf0huYNyoeXK6MaNiqpJ+yD9XALc9170Xok0HZrERW8XlX9bfTkV9CMqvmaq78Kagg6tuuPcxr0HnZNtQdeAaDcHjfqSKtl/8os1PWYVZfETvtkBK0l57FSNOZs3jvG2JEJWz5Z6vvXTvFhiu8096i59NQiSbr1d2v+4Vu0NSVk5De+cpQMNEhKVWNvite7HhqNxhrAm/CxGX0c9md57xeWKYfOdYai8IesB4HKy2ELmo/GGWQrO2hIoJZdAScUNJnf0SXBFJUPBil1+eSbzfnO9Gr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 3:44=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> Remove unused pagevec.h includes from .c files. These were found with
> the following command:
>
>   grep -rl '#include.*pagevec\.h' --include=3D'*.c' | while read f; do
>         grep -qE 'PAGEVEC_SIZE|folio_batch' "$f" || echo "$f"
>   done
>
> There are probably more removal candidates in .h files, but those are
> more complex to analyze.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

