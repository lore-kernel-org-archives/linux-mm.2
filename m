Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3484B606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=karaolidis.com header.i=@karaolidis.com header.a=rsa-sha256 header.s=protonmail3 header.b=wRvZOb3s
Received: by kanga.kvack.org (Postfix)
	id 48A2A6B00EF; Tue,  3 Nov 2026 12:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461896B05B1; Tue,  3 Nov 2026 12:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3782D6B05B3; Tue,  3 Nov 2026 12:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 166346B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:37:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAC4A1C3C85
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:37:46 +0000 (UTC)
X-FDA: 85394515332.23.509D808
Received: from mail-244117.protonmail.ch (mail-244117.protonmail.ch [109.224.244.117])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6BF2A1C0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:37:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=wRvZOb3s;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com;
	spf=pass (imf20.hostedemail.com: domain of nick@karaolidis.com designates 109.224.244.117 as permitted sender) smtp.mailfrom=nick@karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793727465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFjhgIGgPZUYlvL+RYcSfUXPWGvrnI6FenzKH94jOMM=;
	b=OvURCF+cLhbs3XHYDDqa275tQnGYA+Bjk/GLnn5X2Nunjh4awq/KolSj2wujg8vjJ39+CY
	SyQMx3dMrBtDnw46yF0ZKBgnbwhPMs+NHDKwQv4L7CY+mjH+NGMmId1DWJ6+xYwefTyge/
	Uny1SiBqvbJYWGgRHfHOgq8Wm2/Mbb8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=wRvZOb3s;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com;
	spf=pass (imf20.hostedemail.com: domain of nick@karaolidis.com designates 109.224.244.117 as permitted sender) smtp.mailfrom=nick@karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793727465;
	b=d3X6Ni08cXvIhWsapa6GxJe8tdRV52ndDRWMWnnYpoVrrSnkyjNN7u67sVR3YTetRGlF1t
	F4SDMHBKU9D0RsO7vrdFMWyU1k10b+0czB2f+ISMDUbrQZX/krZqxYtlS7kM7tEqEa8MFS
	JxsVD2tb4V/1CKL/u348Bdq2+u3mjsc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1793727460; x=1793986660;
	bh=qFjhgIGgPZUYlvL+RYcSfUXPWGvrnI6FenzKH94jOMM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=wRvZOb3sE3o59vmGwvbkJ49QorWYcdSvzlj8XXAZic+nqaL8DGQ2lwfyGveYMZn2+
	 uP7JMbZVJ35G7ju606zIJ5GiIZSqJSqXFJYsGPGBUvclWtIjwt4ZdMY0X/IoAHZbxU
	 8RjdHhuX3k8ycoj+Pz9FBK5a2cAcWa4Z9ClukeMD1E2MWkBcqXGTrcppA0GesLHMSu
	 D72mvXFvpKGF4eGLnNH5F62MiL+ctCnUL+nl8ryPaLXa6AMapR+KGcWco3+SorPH9i
	 +1v+mhfGSZvbhybpL2OCZ40+zmJIv3BBkLF6hcRdQUDakvY2l4ZCgZ7WqTdrGp0J84
	 k2uSOebhIKFGg==
Date: Tue, 03 Nov 2026 17:37:32 +0000
To: "David Hildenbrand (Arm)" <david@kernel.org>
From: Nick Karaolidis <nick@karaolidis.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Oscar Salvador <osalvador@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?utf-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Hui Zhu <teawater@gmail.com>, Georgi Djakov <georgi.djakov@oss.qualcomm.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH RFC 0/6] virtio-mem: support memmap_on_memory
Message-ID: <TOhF_b9SkdekrK9Ee-ti1ZwiT3wqERe1fpF8nA8WgHb-MX26lmQTex3l_NDfWzFKR7gcmLfjxB2YWixGw3LpR1mvgmPWR7uy1bkqbGREMpQ=@karaolidis.com>
In-Reply-To: <fd6094d5-50d3-4e73-8c09-91b0769476ab@kernel.org>
References: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com> <fd6094d5-50d3-4e73-8c09-91b0769476ab@kernel.org>
Feedback-ID: 101209095:user:proton
X-Pm-Message-ID: 08ccacc36e0bd2d68f132c0bd7bb29272cb682f1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6BF2A1C0006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1xj8wwpqgnyoabif7rn8nui6jpup5xgi
X-HE-Tag: 1793727464-714225
X-HE-Meta: U2FsdGVkX1+qINrHJS87IiA7Br22aLziNdZfPBfpcvtU91tLbV+Ya6P8S+UlKCXy6soHltJGD5xTAGJYtT9xFCD0gQE61arEav49n4+Bk4vaK9eOdbl1Jlmtk9MZI6zPS19908LfjX0Kx5MhThnzMNQ9pdk1XUVFvnLE/oZ4n6Xz+o5AWEeXHGTtsr7MUvm2ap7BwfWEg290alGQ+j1/6GBuMjMGek3r25vZt25yfUPzJSb2s8Gnsc/aRF8FMn3OX9eL2pT8rIGhNNUaMtvDhpQwhRZqMfupFTiD6Ou03VbjjNT+wdVcejDlsUoGUtTHY8Sue47yEARe06N5+lCq4yCBJr67SpCOa9eFpn1HbFYK0THmxIayVBj/BonbAn98YVdxSil6IKyPHVQA3B3AGKe9fTc5aS3eg+imPgFjXkNLaPpb92VN8QjzH65qBI+J+MmuBr9KLAuoTjP2MnLA7+9STpm7ApeIH0ukkCSVhGVtmi9ykBpVfmv0IKmFt7dMx/oC4PPA40PnezWydOP+YpuIkbyVhpsqhXTTukAViEbZN8CM2oeK0ynjjygYlpjN9ZS6DCG1YA+UU5tZddGfCtj38y4qh84NWgTahmM/DkMijNMic6EvG2Ni2Bj+xb3BaYr4+Gi+hGDgB6LbEGiA7aigWCmbXIe65BCO6TSq379HQsCsb4ygeR7nyRY0LSttUT4Yl8H58gPBJqIamISkNqVOXfmcZ1nwzwCVJDzJCMMXqLmfYY16AWAWSu4cTV5N97DTgOxuxB1Dh1HkArFOPxqFVM5efkNEXOXdlRAIddKn1CPoftQ9w5HReBuWil/EAsDj9+KCyFLwLoaiMmm2/xOF4s5ygBklYWY03+SNp05Za+W2jz5ec0dCfRhNgiFAS9/NpZf1CJH2gf5NwMCCruJnsOrL5JJkgnTIsPpRj7czOaxxZWnrCeEO7XrvzZgJRtg9VE4QfiVo/ATwJsT
 Cmm4LnQn
 B+q4l/MK8yDZBZarRY0DgzaiZKt+fq96xqPPnSWzG8JsY4IlJT6PxSHLowZuMP1sMbWHOU7YSNEGN0sGs3Lo1JfDBDyXTnk4d001k8tDYTXhg3pz26TV0Ka3vFfer/BE7m6EmnLdqGZvJp7qJRoqkMnsArrJkIkimhzTvs188b54XdPiJlFWJfwz812edmN64Vza1xo5Y2cPsFG7zNSFQ/qVnrd/vMWquhTZLDy8hmo5u7OE2wVYClyJqL6yjdxDjLTLpiiCw9wnaxLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tuesday, November 3rd, 2026 at 4:29 PM, David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> Care to pitch the use case to me?

Sure! The point of my project is better control over guest memory.

Each VM boots as small as possible. An agent in the guest throttles the
workload with memory.high before it OOMs and asks a daemon on the host
for more, the daemon grants it (or not) by resizing the virtio-mem
device, and the guest gives it back once it no longer needs it.

From there, one can set up VM priorities, revocation policies, etc etc.

> Is this something that your use case would actually benefit from,
> or was that project already discarded?

It is live, though on my own server for now, and nowhere near
datacenter scale. It's a 32 GiB box running two VMs, a CI runner and a
game server node.

Each used to have a static 32 GiB with a balloon because both workloads
could potentially use up to that much memory.

At the ceiling, the memmap for 30 GiB is about 480 MiB in the kernel
zones of a 2 GiB VM, on top of up to about 360 MiB of other unmovable
memory.

> Why so much MOVABLE memory,

Have you seen RAM prices lately? :)

In more seriousness, giving memory back only works if unplugging
reliably succeeds, so hotplugged memory is onlined movable.

Onlining some of it to the kernel zones, as auto-movable would, makes
that part hard to unplug again.

> and how do other kernel allocations (page tables etc) cope with
> that?

On said VMs, page tables peaked at 75 MiB, and page tables,
unreclaimable slab, kernel stacks, and percpu memory together at about
360 MiB. They scale with the workload, while memmap scales with the=20
plugged size, which is why I started with it.

The other problem I hit was inodes. Their page cache ends up in
ZONE_MOVABLE, which reclaim for kernel allocations does not scan, so
they pile up in the kernel zones. In testing with 1 GiB of boot memory,
that meant OOM kills and usually a panic. Working on it turned up two
inode LRU bugs, which are now in 7.4-rc1:

  8dc4116041e2 ("fs: don't lose inodes that another LRU walker is isolating=
")
  8ee09f597763 ("fs: rotate inodes whose page cache could not be dropped")

I have a series for the pinning itself that I'll post separately.

My VMs have been running with all mentioned patches (with some minor
tweaks) applied for some 5 weeks.

Thanks!
Nikolaos

