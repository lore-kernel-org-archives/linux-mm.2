Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0D7E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235186B00A0; Wed, 18 Feb 2026 08:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F58D6B00A1; Wed, 18 Feb 2026 08:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CC66B00A2; Wed, 18 Feb 2026 08:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00AF66B00A0
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:07:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C049914012B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:07:44 +0000 (UTC)
X-FDA: 84457604448.28.8B5808E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9D94C4000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:07:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jt3wPQRh;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771420063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRGYwwW7dZPASMBAQbEnUUAmVM7Dk5+BeMxteCPdDpY=;
	b=FaWa2DSxb2fHtuIPbcaVSH1TLYZVohEvQOMOG3dT2zE/ZX90onknp5BwBMdqjxCKboTsTC
	7dMgT73xYU86B3rDu51bxWcn562PHMdJBS0zJNsNI0R6xBl7dXUs2Y59g9Jj9AK8gibuLc
	4MEVJIGR73sy7z+WEy18r+R1ieU3eRw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jt3wPQRh;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771420063; a=rsa-sha256;
	cv=none;
	b=rJ+YTZu8EiEoEHgz5Bm4x5gHRwS9Dza9x0y1pbKeHn3UtRQUWzh1N03j34XC1OSJ6Bo5n4
	yexlVhcCzVnF/VGJ7Q+CGfoUN9rpRr73fg0xvFKnmHff8LMQcpPweVMO+UtDGNKp3J/rq2
	1xyf+7uLQKsBFgfx8maFJKBT/0Rtf5A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MRGYwwW7dZPASMBAQbEnUUAmVM7Dk5+BeMxteCPdDpY=; b=jt3wPQRhLZbn4iPv8TKFakFnNd
	8Gnijfv23M8CBuaPT69BRUwG1x2G0CjlMJvSY6UYI/JS39Dzrg4EGSmimCAQhdRTFyTSJ6utoS57c
	LHiKYdiX5Rr3LReSI880z4nIeBHa/10dKYxt6MwSyf7jVkhN8XSoufBePpdcTeZT/RAbcoKx+UQB2
	CbsvvNEHV603uZVde4B6xz1tbSwntTNoW6utsGgcv/OE3sa4Ol+sF0BJeiQx6666E05koInrZO1yx
	P2jsec9FGpHU+MlYSFJx23LqWaoVns3jq1hEwOnc1+bCjy0g6s6zbjiqFC9r0bCpFRFSISfEbKfW+
	yD7yl16Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vshH1-000000063U6-30XM;
	Wed, 18 Feb 2026 13:07:23 +0000
Date: Wed, 18 Feb 2026 13:07:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, akpm@linux-foundation.org,
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
	borntraeger@linux.ibm.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <aZW5i4cqU1qUy3aa@casper.infradead.org>
References: <20260217163250.2326001-1-surenb@google.com>
 <20260217163250.2326001-4-surenb@google.com>
 <20260217191530.13857Aae-hca@linux.ibm.com>
 <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D94C4000F
X-Rspamd-Server: rspam02
X-Stat-Signature: k9g9fkhh3bkchn54js3qd3qgimfijw9w
X-HE-Tag: 1771420062-392687
X-HE-Meta: U2FsdGVkX1/s62oluvsp+vdOggsK/hYuaqhiS62J6aX7aJdo/ah4S3IuZZ+BrYceLlpgr2bcDzfKzKHnZEb+f+3NkwErbygN6jUX9cdj06Ne6t0cw9VtAW7Dkwm8SEcPIkwphiCUR5wehZnlj184kDtolu44ltCUadbwPvPjeEycVbXzMaa59dteWQ7tt5p7etAorCUCnV8b44PfDJiEnn/MTjXOJa22C+9QVE0/MnPQofjyNKoHw5QIaaB01loNsBmmZjFV2Do1ObpOzmUok5ISgjNUuQ0hY4p5WuqJQtZv6C1AsU/kZLaGZ6HOSNwqtWjowenpNWLueM50SUUFM/ZEaAvYS8XcePDs209le3nGOhkJsNRmIx7yVG5PKzuI+H197YBwWsk80vI+x8KfyOjUrc2P7ESMUd+YAiEc7u/5R9vDRcNlhdO8fIKcZBZYKbJYN4c4sBqnfVEK9qq9oSb8TNI6LdA8QIEdqRsnk86NZnu1oKMQOsB24hKOIHOgHa74ZdSG4JZoXcqFAKbb6pStITHHpZ8Rqa3rPTyIeVLBinz76BN1VGQn+kWo8ZEV8j3WHCGG8wRrzTWrGMdQBrveHQB1PFrk7GUi+ZuPntOtgk2IAPlVcxNFEiyJ6Hpbq0oB2mcBKKnHqAp1JXikZS5YIXU1T4AVFFtHxiZQqpDWXxtCvp042P+hEMGBqRPWNMFbS6B+oa1IYRvrcId2KBUxvvTlMxB6h+oeyFVQf91vMp45fk2ooSWogrjIHUsIdvrTM9OrOLBFAFI1oG0Fv+uA7ivT0HmErDAxYdcydcNFAL2E5FsxwnSBS1rdm+OpP06aiu4nLiSc9vjHsGiLUa+S19RCJglcYMJQDI0c4c75TEWfDrMmE6T7mz+NI7SBHe+K/1hhj72F8TXUhrEUWvnLYBlHu3D15QZmC7KTu9WacLGq/XVRpq5XKy/nsYRmR6qTya4c4750jcy4mJz
 RiwyKPsA
 tkR3Ezp+MHn3F1vj930BngWH+sTqHl7N8qww+O93DkXHZVZcEaxVIbCN3KCyW4jAy7jUugcqwEVQhLD2ttbITKVdvLsBGbIl2bmSOxlGOw77XAF3v4hpD/p3EZacFtRWTPOPF+yDUHbe7vaQ1vKdQebuvhvzvjIDUiOrVDetdalWuxGShXttAz9mI59XsY37Wi+qNLqusSJ4ewW1tmpA2CXl2ZFNyU6QrkbnN+2W97l+cw/qTBQEmPHVPY5mX1yKK2a//ET/t3lOS53EMh8xecZNbezXeU9VINs/8bgbclhRzVpClXNmakYo5q2gV9WhwpfzHrXfomazIC7exJt9a24Qqd5zGJVKzdwiZ7L9/q1rHBOobAboxrYsfYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:31:32PM -0800, Suren Baghdasaryan wrote:
> Hmm. My patchset is based on mm-new. I guess the code was modified in
> some other tree. Could you please provide a link to that patchset so I
> can track it? I'll probably remove this patch from my set until that
> one is merged.

mm-new is a bad place to be playing; better to base off mm-unstable.

