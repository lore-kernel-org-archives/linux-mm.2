Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E906606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 08:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuObBb11
Received: by kanga.kvack.org (Postfix)
	id 2777C6B00EF; Sun, 22 Nov 2026 03:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A656B05B0; Sun, 22 Nov 2026 03:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FA86B05B1; Sun, 22 Nov 2026 03:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA9DE6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:19:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4A1A1C3EF2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:19:24 +0000 (UTC)
X-FDA: 85462055448.03.7219C77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1BC3E20008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:19:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AuObBb11;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795335563;
	b=vrj5B+fXGpW62RiiHt/ek59tU7hD0dwe/tt42JWwzfq5Ia1KE9YIRPQkPfedxSkJMntf/o
	E/HgpviZ/OKyu4lGbMzW5aNNkm0SYlFcJ/uaZMgIUIw4LLaruIo9doGdwubuhG1e9GcUrA
	GiqspjOkC9PFlRFjAourrk1yBDtFQl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795335563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZZ+FaVNZ81W5N9A195kfiFuUgvoLvnOZsjSHMvxU8U=;
	b=ZHgV7o6Tig+bP3dG708NHLFVH8oOsQjNK9Bjt2Hx1g/gsPLRgi8WF5DJVqiGO/k168b27T
	YCjFT0WzawOmGiilrmevCB3iNWv2BKDkYvgjKxamjTyh664DmdFISm6bCBlS+tN+xVZOpd
	YebPtUYWMRYfEpfrFgjc6PdKJ6w99NA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AuObBb11;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A2014351A;
	Sun, 22 Nov 2026 08:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AE91F000CA;
	Sun, 22 Nov 2026 08:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795335561;
	bh=SZZ+FaVNZ81W5N9A195kfiFuUgvoLvnOZsjSHMvxU8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AuObBb11SmjvobS9klEq8nSSkb5UNYg6rD8AbEZBcdTNHachQcn5GeDysByNH4JJS
	 K9sSWZGaYbewG8ddLA9UBjTs4AZZ1sYA9d2g8w8ebb45svMEU1fZBurAY10RtfBQD/
	 PPXtWjZ57cRP5bM2o6916uoRN4HSwyz3b9PlGUjQr4y6cZRaU8zJejjL3MdZqdJtLq
	 tluupgXdnz9FwtBqMMXw4qooXJGWUkxsZAeJ2wSH+5CdidkOIqjY/bF5FR2ZvcF7re
	 QxOAAGM1X0eHaivJl+i5Ytw4NqrNhdB3pY0xZVqk/vZYqkZey8pdRW80e4VO5zMSQh
	 GrmYuI5FNxezg==
Date: Sun, 22 Nov 2026 10:19:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 00/13] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <awKlfqlQYhphXCvf@kernel.org>
References: <20261118223704.3286085-1-dmatlack@google.com>
 <DN0FL1752MH5.1FSZE620OJBM0@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN0FL1752MH5.1FSZE620OJBM0@google.com>
X-Stat-Signature: rfrc7q14mb4eozy3tiocwjak1yefracy
X-Rspam-User:
X-Rspamd-Queue-Id: 1BC3E20008
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795335562-305911
X-HE-Meta: U2FsdGVkX187XIjkZQGWcuD7fhA7M7BAANIUecOdqTNhbjIOUlKNo5Y5xzNAvqKHF/z/DylazQDzktK4x0S5r9krZjZp6aEnbw6uqnX3fPCcP7eUM8vCAbtScpbG8hNgOJb5Iw+9DBfLtebpbSQUc9j1CS+65RLX7mKhxYo/Xii8u0gFqFdU+PjQY/bUH+kC7oQt+ScnMUdRiJfBwfV0YrK/u7I7SH5XwmeHomJPqKkCUmxFVM5f9033sptnhWjxjiR4w5xgtjZjcUq9TaPnwcj+VosluFhCBgf5lcAW7Zed4blh/6pPyPVcNuDqfz1D4HGlFj3bNuqy+4NXiGSS9yCa2AWtVkCCvTEO4WWtLEjOnasx3MN6yPjyKravCLAkntpKwwqYqF3paNfMwif14DpZ7J/2P+IA/XfWJRcvyJFMavtYwqxHBEdwyDLzGDg9hS2AW1asfX5eRIpHZ6t+wsb1cxpWz9gEqnv1/bJ4+o1t8PVtXIWyIU3mUeWbmsKt6EuDArNgeV099nnq+AZhISETK6gkyE0vvxgV4bW2bkvq7YduDgryjy0BYnFwFP9srVy7kyfjB3o6/WP/rzsQTGjHQmw9FBYbcnpFrJDKhQUoEucdXgP969Sh20lT+zVVZtBkQWDZAj5hTzyIQ5oWuOJPVvXiP1f0OOQ7OjugAX92TxPPhHvu0uI3+5H/rJU7vH/ZZ8iTsJljRnw9nOI6dflIlUEQKmAhyY8kphvphxzrsYv9afiuVmDPVEcyx/gV5zawqk8C85VvQ4CLzyoGIFdE9X/5Lck5dvVMNkTlmUUjdWRebd8TfvfrmSQ/xS0TAGvIBjwuuqRT0wokZQ3E78wFOL8QeoChaChvBWZmblVFYk47W0Gi7kIpqvxwIbylNWpX/vZ85clLJYLbxn+2ZcOZ8w4aqqqgMmcApUolii7Qh23Pe6tCi2JpUo9d0JsJQMum0UmJJsvQlQ5ChRr
 lI69tXAV
 ewR7Wr2ZzPQAHllGXGIYOzBDruBH3Hne7djhIoQmDrHRqUwOGVpiY7tkehVUKuie15e+vmCxyaEXfV2e8tEbDt5BThEWF/n9mjlOpgShkCa8YZHJl+Ryi0Hcae+pnd4KRqAe6i1KKxT+s5MOLI0ppbJSyqSNXMCtew5rXcPaF3EU6NNYSj3Wv3ICJfh9CYqx5tv0sFJJlLJ5QfzCN0DuovCm+eJqF0c9ZfMovNo/FXeZck/tMgDh+njCly4OoLSBC5Otbu+dviv6oIza/oRUJZlf93lzI8NrdZ6jBI+lW3ojZOSb1EALHhkgwL8D5iNTlDjprz4RUVw7Lil5D7IkuOLqJ5lJ+DWZLqJsOyKWtVORrPQDfEQhe8TaTdGzDjLxzGEtNzL1Q7aaea7rHSQeQh8NrtZ0ksMoUCaqFPqV6FHk2WUK9zm0RUZ/ZhrruDsuWQpZdM8KcV5/g0fX3Hmw3cV6b7OVTLEkPPHDXFZQoGDa4RpQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 03:35:58PM -0800, David Matlack wrote:
> On Wed Nov 18, 2026 at 2:36 PM PST, David Matlack wrote:
> > Merge Plan
> > ----------
> >
> > This series is intended to go through liveupdate.git, the tree listed in
> > the new PCI LIVE UPDATE MAINTAINERS entry.
> >
> > v10 and a follow-up patch were applied to the lu-pci-preservation branch
> > of liveupdate.git. This version is meant to replace them, and applies on
> > v7.4-rc1, the base of that branch.
> 
> Patches 08 and 09 have Reviewed-by tags from Alex now. I have a v12
> prepped with some small fixes from Sashiko and a comment cleanup from
> Pranjal.
> 
> Mike do you want me to send a v12 with these changes or send separate
> fixes for you to apply on top?

Three fixups on top will do. Just please send them as [PATCH] fixup! as a
reply to what you are fixing up.
 
-- 
Sincerely yours,
Mike.

