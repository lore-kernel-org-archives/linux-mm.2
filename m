Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66344C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462186B00A9; Wed,  1 Jul 2026 05:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43ACF6B00AB; Wed,  1 Jul 2026 05:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351AA6B00AC; Wed,  1 Jul 2026 05:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1394E6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:56:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A1F0A02D6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:56:58 +0000 (UTC)
X-FDA: 84939754116.17.ACB250C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 154FE100005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:56:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZVMXwNQ;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782899817;
	b=4w7H9d9uxjcFL5pA7KOaE2AyyIC86z87sC6dzFfpTqQS9aGR0MRCWh6fCnPexVfiv68UTP
	csYExVB2rd6ErJqPRiCjoyQUIgrzoqkJYiiLxKZNZ5JecSDQGuWd8xdJRP9T0Iv8pWNK1t
	Rrpr/P73Md0r55jKdWUqLHs46qZMSQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782899817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ce5x8VsOSihGimDX+E2xZ9QKUoBE10Bad77hJiyAQ1E=;
	b=dlSOOcth82mbaXbwdvVmDthna2/ey9QuXqn2cD07+87vnBYYkbza3l/CTFtNCLTzFpE95q
	H4cmvK92+WIIyxENC4JKJjFVhhahyQYcrrKXduAaukksqIG/3IxqEXA8jfjs7s0HXsW/Io
	BLolswvUdIYAu/41w/uvbUx8ebNChaM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZVMXwNQ;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 475BE60138;
	Wed,  1 Jul 2026 09:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3460C1F000E9;
	Wed,  1 Jul 2026 09:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782899816;
	bh=ce5x8VsOSihGimDX+E2xZ9QKUoBE10Bad77hJiyAQ1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DZVMXwNQ7Qas5su8LVUpZ9nJZzyP2uBxeA7y69zzPN45RtVQlQlUbn6BqoVClF8OQ
	 cdNO1iGygY8gO12qIOso81h2/ovQrZtecs/m5aFsflX56hjaVdJn1UW1oDVl1Yio6K
	 KRPnQX2cEF4iykCZPLFviJvZsj0dccJ/OtNrkWrmrDfd+Zc2DCw82CITQK1lp0tyWe
	 FVO7hLYRhosCJheK7GEd0ZzB4RBxZA6em2G+SdpL6ItiqRo5WAo8LiBboh0bVEWu86
	 sAwvz0MgMFy71FvJ0/B44EaogV7h2VMnc/A+pYGBJOKud9YpmG/8lNeNdIQphF8zxv
	 fOupSSuKidQxA==
Date: Wed, 1 Jul 2026 10:56:34 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 06/30] mm/rmap: parameterise vma_interval_tree_*() by
 address_space
Message-ID: <akTkRC7gPzdibXhU@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <43050b10b53cdfc3627440e6b14ae2a9730b2a5c.1782735110.git.ljs@kernel.org>
 <akPsGrmaOd3JMlC2@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPsGrmaOd3JMlC2@pedro-suse.lan>
X-Stat-Signature: r6dn5z4tmh9345zb6mgn9d35bqw6oysp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 154FE100005
X-HE-Tag: 1782899816-311589
X-HE-Meta: U2FsdGVkX18CqcnaeGrRjsOisFPXQBLx1Aqy/CLP2q5IJ5vWU9VC6COEyCzsD4AjoK0YaO9mwWwG0YtUQ9mYoAsFporflwGLfMi2zX+VNk/DrMiGg0JySzcXMfls5ArUziFb6Dcy9kI8LxqlZqREOVHZCuM/DW6vGrvOkDFDhQZXMJ1InnWulFbJhItgsaA16vUV43zWq0duv3u33GImU4oxNSZVIxcu6nFQ8O5KFTnsyTzpqMNrzIK8rr9NqM7FSGAE9Qha5rgoLPsFIDGfLMITBLlk7hD9++8vCgCNcBT463MSQ96lYyn9LIYWNcybC/eRCz6jtlcOlXJL/0KESLGIDcBCbhshQNxZWZtRtJxE+JhOB6m4R8OcqlnyLJHRJjRvclPrEyWSCFWHYG4U49SilOuYt5+hn1isQzmKXRh11nE55xk0X5cd1aVxNfFoWs93bXyQ3hUPbPjBwWlwyQB8IfX1lRhoj1vP6S+IcbQWPJTcqo4SZtClwIUFD56QeR8h8dNJIcpmyl+aNaYPsIRcrEHDw1qBsO5+KhT5tnHaWOrITJs+zTgBMAMR8tHzxDImobak49nGXi1eFv8asySIpASqJJ7/fD/xkqDCmJ1GN/v5qkewv9Bl4gkmWwZ4YWO3M+j3qFRnfzgxXYrQVSkmc8AZ5zoJrSG6VDlpOFmVh5n8nM8pBVSh6aT4y1o81si8Jewa5webylQwUhENlj3U9YsBNk8UQ0+gThZIhxuNPeqtspX3nH4fCJzo4esziuXai/CJqA3NZriILh/Za/qWhP0HGnYJqkAyAB5ZszBGAoDx7D2V79e9JW7I7i6MMtLGCWjKxkf3gKB7u0rXViWmt8uLZm+BM4NjDfcM6v/RPKAuvPxiEK30K2zMJ/469Reiif91JulQRC5peSIZU623+8cpKbi6KBX6L4fMPnWjxW288T/Kv3GIhgFRL/fZR1GkbTiPJEfZjUxs6UF
 bKof1cV1
 3Xc+UkD151FmVl2DbsP6xoX1ffibmw6g07Wm26SxadV7oInr0tao904GmxkWqWRWpIWq2m9eHzV+eEjdbG6AmqAhvxzITWiJc22ehgImKivMEH4OdZQ8IwcJNAmPuzJtB+9dMp0kDqKbY8wdtWU/rZ9+G0xHCtatX8EfDclD6fFyK625Z16/qH3E7n1TlEYETr2ObmrvOgs4Slp6yD7sjaAF5OcSgt2QoOzpyYGIOVY5V2eB0G2CZjIkYrNKOX0XapoW7pqZsAOTqT9sfliVWQ4IUH4EKj+/8wqO68ST2rhUmn3JxknAWlL6zUnQtGgpGnU+8Ria/tLQPF8+VcbCTG+x5IiJmr4w+3IYPAgsZ5hav09UrVXanFgfOcLVHacPyz9UbLjZP0ghkju8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 05:19:16PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:17PM +0100, Lorenzo Stoakes wrote:
> > The file-backed mapping interval tree functions vma_interval_tree_*()
> > accept a raw rb_root_cached pointer to determine the tree in which they are
> > operating.
> >
> > However, in each case, this is always associated with an address_space data
> > type.
> >
> > So simply pass a pointer to that instead to simplify the code, and more
> > clearly differentiate between these operations and those concerning
> > anonymous mappings.
> >
> > While we're here, make the generated interval tree functions static as they
> > do not need to be used externally (any previously existing external users
> > have now been removed).
> >
> > We also rename VMA parameters from 'node' to 'vma' as calling this a node
> > is simply confusing, update the input index types to pgoff_t since they
> > reference page offsets and rename the parameters to pgoff_start and
> > pgoff_last.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> 1) This is fantastic
> 2) I need to rebase my local work :)
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> --
> Pedro

1) thanks :)
2) sorry :P

Cheers, Lorenzo

