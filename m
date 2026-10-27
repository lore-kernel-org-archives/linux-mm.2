Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DC3606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gLb9YpG7
Received: by kanga.kvack.org (Postfix)
	id 89DA56B05D3; Tue, 27 Oct 2026 06:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D966B05D4; Tue, 27 Oct 2026 06:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715176B05D5; Tue, 27 Oct 2026 06:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA8486B05D3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:29:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60457140930
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:29:41 +0000 (UTC)
X-FDA: 85368034962.08.08A4BF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0E59AC0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:29:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gLb9YpG7;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793096979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h84z7fd1Ik8wN7YTsUmwTZKDWUsWH0q82RExH9eag3k=;
	b=ZyZIOjd3lyl3eJr4b4VYsnxM8aRdjHIsj5GifWSCPoU+/972uqLiHP25AnAoimRwTen8vP
	98VwkF1zh3lNqYjzGtg3MCzPg2mySeMraaTDD+yTwYX089EpKldFdL3CuEuDqpPwkLtylT
	SklbAYcgItsrv8ToyLCmv2XWlVPE4EM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gLb9YpG7;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793096979;
	b=3GdsvxElmxPLu4LbyvO/reAWTjH05ZEDq1wQmKVU0EgUZxq4UKJtbuVLik9EXLKuTdTKSQ
	suUS4i7iMV9f4q2lGrSWyLc/leCZNPa3EGvJpqdJfcnNhw224jJnWtp88MnsDYu0IgrNOY
	mmMlfUjwXJXMYYevCtdtU9lVpZ3UAKA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793096978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h84z7fd1Ik8wN7YTsUmwTZKDWUsWH0q82RExH9eag3k=;
	b=gLb9YpG7t7aAG5zdrtnhvrwl+EWJbl8BAas3vnSQvE7RZFC1to4hrFJ2HzYEXlEd7BUFNl
	AQp/dEfFDJW0EhBTKWGntzjWOoRNCmTG3CAPNCoGP2WFDppFPrRHTHwVg7Povykn7MS4Hz
	YOoQJy/9sO9n4UL2QB3b4MknMrzEpLQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-hjp66_RXPuKu7DPPyfzBww-1; Tue, 27 Oct 2026 06:29:37 -0400
X-MC-Unique: hjp66_RXPuKu7DPPyfzBww-1
X-Mimecast-MFC-AGG-ID: hjp66_RXPuKu7DPPyfzBww_1793096976
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e1291432aso2743684f8f.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793096976; x=1793701776;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h84z7fd1Ik8wN7YTsUmwTZKDWUsWH0q82RExH9eag3k=;
        b=BaUttgVDPVqfXOKoqniQn9UgnitQkg2xN8FThjRc9qzmYBRM0mxvvKEIzVzQ+JDJlz
         HnbVxfsxDhprI6eFWOm/lz9ygwFhm8sX2pTt8v6/bzl2ijJ1Rz4h2SXkkbAwB1VnLm0b
         J7vbzVVXjLUhrvZ0hXAIFQVqtkLTK6hiEVLLMn5PEUodUKGRavrjk1jj6uicto9UjBtz
         aXxzx44MdMvTcrVNs/ffIKSo6FKPgkl4Gp2R3vhkHYF3MmQQe4Bn1usOkb/uLrHKP2bz
         0l8MOKduLDYDfBEUNwv4RC3jQjkxTwcvIwO9U5t4OMec/J5JfhgBbnVVuRSEsZb3Sc/m
         k+fg==
X-Forwarded-Encrypted: i=1; AKwUvBzkITHMQrKCJUfreOU4ZbzVdXaWROLT3lTb+wFu1jyElRl2P6TdcbRi5xH2+s2iEEk0OqdlVE8ECw==@kvack.org
X-Gm-Message-State: AFq9FYKAbanuzk1tzLL3v2F3t8h3NbAsCFikQNSksm6xwWnFXLuAbF+5
	1pEXGo/Gn6Ee+tgOBEZglXrc65uHlrAtDJcSN/H8Coiwma3pgQ+ZXEG/svHHM40UbuH4+5gTZv7
	2leS/qd+VPwd1hmX9B/xAu+19Djc4/BBuRGo7ojmazisYU5/tQ3PY
X-Gm-Gg: AYBFou08nURVVVgregj9Jt2O4WrzOxQtPgVLHnvirxv7YB/KOctg0c/9K7Gc/ZDFARv
	aFy5ebh4ok4SvVJxgIGN8oCy+PjG9ZafKHP+yJDumEPGR7EbwayfnqckR+RVlaJvrN/iBJUrH/X
	J7NVsltqezb+2Ae3lpDSQVfotQ7OLxAQ/NBBYTrWnSD5j0Kf8RQzOHzp8+peCbinHcgbyfnV9JF
	Kqq6qtjz2Xgnd+iKYNKj2EITbCQLLU1yUnihYH3N5gKGZGUKU0pkqfhxxqJreCEm2eQJycMHnk2
	1vuhoTg1OpMIFUbQFiL/3d86MWGzWsvwKROUAg9Wbb+gcUiFhChZzrNzmhVBb774Yjo=
X-Received: by 2002:a05:600c:8b86:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4a35acb17bfmr175618605e9.22.1793096975895;
        Tue, 27 Oct 2026 03:29:35 -0700 (PDT)
X-Received: by 2002:a05:600c:8b86:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4a35acb17bfmr175617615e9.22.1793096975354;
        Tue, 27 Oct 2026 03:29:35 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a2d9280sm254068375e9.13.2026.10.27.03.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 03:29:34 -0700 (PDT)
Date: Tue, 27 Oct 2026 06:29:29 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidharth Telang <sidtelang@google.com>,
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jacky Li <jackyli@google.com>,
	Steve Rutherford <srutherford@google.com>,
	David Skidmore <davidskidmore@google.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
Message-ID: <20261027051245-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s8BbZxGY5OUF3IwZouJlBKgCFtjQFOoFiO0gZfwncuM_1793096976
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E59AC0005
X-Stat-Signature: w9ihcekrz411bdksmrreoh7r4if1tita
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793096978-311314
X-HE-Meta: U2FsdGVkX1+GlJ7kQyyF8i44NiCsuPhK4DATzW9NZKUDw5zc1iTvrNDQ3hS1bGC7zEAdtJRtK4+ZN7HxCFsFk+/m03SN2Q982fhqUI5w+e+jMTfKrWweF2HIvm+weN/8j0ikMsDiYv5RSFGHicefZ3yJmiIwt8hcGzmwRiKU5KQbMcwFTxxj+kAY9jP3UqIK1MNYX83ur8QxID8AuOitB/SV4KakyrbrWb8R4JT+3SSL+6HPQBCakOmZri/0KOsCrvUeMwD/SgCKCKppXTG3VStPVx6MMCmLGbTpoF+mhwxbfAn/d5tGHoek8v1ofwjM4kZG3tXmCsSoOCxrPRCL/cjaatwXVyuMxv5j6faTXHUNWxblbbiZblgNq7xVMI25uPo4r+9LkpxGmXvDwdDMSQoxQaCG5j111lxibGSeA8z+oEcvgn+M/Vu5WHdECAhe4x8pqOACdGXBSvTavTu5YaZQ+qwuNC+AMtxWfrZnQ76cb8UZDg1dzYEuq56QXXDH6m8MwqmkCN0INWr3HBK9+xeaok6sAWMM2IHp8nxZh0P4emi9RpIez2CDJgbInn0eh8x7OX8bmRu0aUmH/u6mLWHU0F7MLGwuTO/4ix5AZZ6Is1znCRUFwi2EjwlYspXrTshkYFczx1FNSmTCLeR+eTTB2vdidPhJmjlTOuvcbPWgMBHcrxfxiKzkT3LLH8bOZHmLmZ2xM+zN/mTQQO+edfJX4EjpuUiybJV+9mpmNJqRxYfOS2gCTjqzNfzXQWtSpMCpRHdVOALoYP8oxx/OjxrKGpt5YwO7lWWdq/OXB1PpmkKfhA9nyBQPdbSKAfco5mQRokylcwbHRp00Lw5IqFLAmtuJq3WIxVPuU9rd/99WpwJjkwzKut0jYi/R7eNpJ3f4S65X7hsB64KnF3mMD8RxhXbYzhZIAqA/lLRx4Ee+f21fbI4jllJ9xPfl+12Xy3QjxLOKj0Wq3jGEki0
 GUhMfMml
 yO765P5opMBTuDfr/tN0JjObwkIvI8ArdFMrk1fu0jkyWeoXusRTx4yFXgB+e5OI+wG46wf9OcEEKmdrnx2UJovQOVyktXVvMSSgSH/lavUtMl5oal9a2BHUNObrJdOGpHNnjmZcQyuLqd7CXVHM5iYsEWfUFwnRu/o7eHbxviRNnaGUM2L4yVQawKtJZ9BhF61lYK6dFIoH52nEU57tqW7eM7k3w2MIzm8V8CQZUIbMdxPQ6NtnE4haBEs1GnrzRNIwOxI1YFsUi+4ogD55FeNyCr+G/XJ4/Llh2Ic5yCsjNOwR+Q9/ZBhi5a3ajGErgsAJW/M4rLcBxZY7nGPW+u726pO1DnqCcDSD+7R8cKYAiYFvjxxDPpdr/spgNt0cbQUEWhg5R3AoztllK/A8oH5mDxjEPlev0NO64HYcP9ag9U5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 02:56:03AM +0000, Kevin Loughlin wrote:
> This series enables virtio-balloon free page reporting and memory balloon
> inflation/deflation in Confidential Computing (CoCo) guests, starting
> with architectural hooks implemented for AMD SEV variants, in order to
> support dynamic CoCo guest resizing.
> 
> Today, memory ballooning and free page reporting are essentially unusable
> in CoCo guests due to three main roadblocks:


For me, the bigger question is not whether we can, but whether we
should. Considerations I would like to see addressed:

Security, e.g.: does knowing which memory is free leak information from
the guest? If no, why not?
Consider CONFIG_SHUFFLE_PAGE_ALLOCATOR, RANDSTRUCT, etc.

correctness, e.g.:  Linux has init on free (and default on windows), if
initialized pages are dropped and host can not be trusted, they have to be
re-initialized. Is this handled? I don't see it in code.

Also, performance, e.g.: How much does this re-initialization cost?

Management: it was simple with balloon off unconditionally.
Now we are in murkier waters with various features offering
various performance/security tradeoffs.
What if some guests want the tradeoffs but others don't?

Documentation: for all of the above.

-- 
MST


