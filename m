Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF3BC5DF60
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DBD6B0282; Wed, 12 Aug 2026 09:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535746B0283; Wed, 12 Aug 2026 09:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4734D6B0284; Wed, 12 Aug 2026 09:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 281A36B0282
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:37:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5C05A039B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:37:34 +0000 (UTC)
X-FDA: 85092719628.23.A185565
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 041F940009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:37:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1mlH5ct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nktaYrQMsX9kCJcq1vQI5eLxnBANn2ueYfqaIw7xb3M=;
	b=A6m2yNKbQONepWTHOv1fxT5rSFI7WxPORZzN2dE93T0i7CtQORmJOCx0Ci49VJKbAsmh5E
	B0saAlVwGtQBMbybRpTNj9orT3/AjBrGDqMtH0UWtczCqyzUrhRV5tdYy+dhL6MpjI5nBl
	mcsdNwkTnTpJE6TlRQqXzvTJbDIkUyU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1mlH5ct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541853;
	b=flY8YuRsXXsPy4hDcR90BcAYrNEL6X7JbNUV2hApO0BB8b2UCNvZUCpfmiSHbS8fj+UsRG
	7qhSEtA67d3V2qowGDkUrjvXc0wlzX3+9H8xXKQt8KcHVvyG+bFAk53Xk1IUeIz6v65Qeb
	zNj0kPo7mrL5W0F62uD00S+dsq3zDYY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47E0541428;
	Wed, 12 Aug 2026 13:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C561F00A3A;
	Wed, 12 Aug 2026 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786541852;
	bh=nktaYrQMsX9kCJcq1vQI5eLxnBANn2ueYfqaIw7xb3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1mlH5ctSn73LCSAInu+IRpXfrDqwbM/4k8vU847fCi6v1vkrFR5Qjm8jZaO9ITmq
	 cme7uuNedl71OCBETtRJ9QZKgikZ63PJOJTiYObTRhTN54rHrjSxXXgCPMTVLlCrzQ
	 HbdI9YPYNHhljYNvELunQBiHL252/BUkkQ4UaK8j+jaimjbuwXzhSiB/hoSzK+Ds4B
	 CFros/O6uQNIuf89zKJGFXbh0w9CrAP1ktPpxXZEDTbkTuwkP7yFTwe8MSqHjGON0V
	 MFL9rS9VTVXbpZ/t3d0r7whm+D9PbP8BFocLfuehi0cqDqnqC+0Irt29ZJuJCFwRQX
	 kTksztgFqC/aA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Wed, 12 Aug 2026 06:37:22 -0700
Message-ID: <20260812133723.60261-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812104002.15225-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 041F940009
X-Rspamd-Server: rspam07
X-Stat-Signature: nsct8xtb3119m7pxkwwp9zj6nwf5xtae
X-HE-Tag: 1786541852-632561
X-HE-Meta: U2FsdGVkX1+q5mGEu9FpW4gYuAGqlqcJ3WuKl/FzWeYZOIqDFZmI9VT0OuzFqlHDnTKzOywFSdWy5VF4j1AADSWgSDAizzoP4SM1yLFeKUjpgbBb2NY5QYjeowQc0Pi3b2Gsw6j76cq1YDkvGuzz1BFIzMHMoA/dzKjaxxy8Vs1V5OtBo0XZmkeG5KonT2LiL6Se9AHZrdhD276l4dstk9KMRL8NdNby8m0mpBsGjmLbbXKahhZobg31Kg8l9DQPBlDzvuUi757EQ4LQ1ZBIGiMAUE/BV1ZrgPF4pzaAH1s28uw8PHnAG9NMKCAfq5DLYGnIlJy+xkHVWilbf6bhnDt0mTl23BhmUcl9BZax2MDitc7fiQ583iVYLwK12nfjl4uZE1GHqzbRCQGjfBxs9cCr8Cu073W9LOvYbJqnzJtBogqDO/F4puwip2hUPdGWmEFfkDRdPlmA1qfwPTso3ZuptHokJlacsgXdkedZGSAh992SRvlzxYgUWrBmVQhkatMqO7IYB3zzXZZ1KfMZeI4SghttnWZorwJF3Uee/AaldblGrCYXt0Ek098S0cDCWDjWUFrXy986o8d/mV95yCwlREK+UCnLf1BG/tVDEXfD6IH4/290VwJwgKBaRxrmKR6taIKmY2CkHWQabmDk8ofIBUxEHz5MNcqAWM52lbwR77kXjLZTQAM7cgpVHpeeyj7bUssnmSx2wALaP9/zyWWVaee9Bac/+GbHfk70e4IS9MgxGMLNaxlHD26SN8io2aAy3GhjJVE6rpov8vdolDFNkuCXahQXUYgDRUQ8ywhZXJdx8CPREzG2fCrwuYqfTBJb9Jn+oB4ehA/hGk8x1BE5sLzHZzVkIbpEltYSvIdExKW8fSrCfLYmSxPh/SLY5Rvt8xcF3F09RXnIPSHHrqx8u0Sa2OsYHrcSbtQZSR6Xa+wlr9GGJZyZNhlfD1DiJcnKQXA4mtRyVL5fgzZ
 TQWb/uw/
 w8TpZ/Wmv0p7ftPSYqGGNjvBZFQ5Zy9tC1IX1Uqdi0jTj8OfhEw9SFSG963U1KN5kcZJkqD092Qj+bQD5tsZcywAc44nYLVMctH4AClIiM/Y33EjzucQ2uivatubi+b14ESGpk5b0OvCkrvRUhufAkVU18jWZG3Gs7EBYdi1SmJbPI6S0fq+hVOe3NewnezEUYbHLgwsxIFy8OP9BvCDM/R3yXtdnmCjnH6TjRzBEyk2VYRDENtpNvuzT7CNDtB1gGT7+d/LQ37bUQNoPagA5ZOQvvVcRkIwkT7diNPrqtXGvehLEmhTQFJp8idkDaUg3iw2Sqzr0N7Lu8oZVTWCpIdV3jJRwKAlhzvjx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 18:39:59 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Add an explanation of nr_snapshots to avoid misunderstandings.

Thank you for this series.

For the series:

Reviewed-by: SJ Park <sj@kernel.org>

I applied  this series to damon/next [1] tree.  We are now quite close to next
merge window.  We (mm community) want to focus on making mm.git more stabilized
and therefore ready for the next merge window, rather than adding more changes
that are not really urgent.  I understand this series is not really urgent.
Hence, Andrew might not add this patch until next -rc1 release.  In the case, I
will request adding this to mm.git after next -rc1 release.  So, no action from
your side is needed for now.  Let me know if you think this is really  urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

