Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D35FE5204
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66A06B0005; Fri, 24 Apr 2026 06:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEFEA6B008A; Fri, 24 Apr 2026 06:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7CF6B008C; Fri, 24 Apr 2026 06:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B58886B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:30:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E67F1C07F1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:30:48 +0000 (UTC)
X-FDA: 84693080976.11.4D0F6F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 76E51C0014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:30:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gQOY41Jz;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777026646; a=rsa-sha256;
	cv=none;
	b=STIaLE52vkgWflqAvJ4TOdep2EGg8prLjYg0ctA/17r0RFgZBmhZ4HC2ZyLf12F9oWn5LK
	BIt38YhTG61aY2WGnHcRdxWwPgkwQOMTmPgUMrDD5t96g7/IylmgLIY5LRt1l3h8XEBl11
	g8gYfDk9kVlnA47Z27HBVlANXniGMdQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gQOY41Jz;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777026646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xYRFTsa+snUwsnsMlD+flP8XlsjYGjzwbUWIong2Ao=;
	b=V5fd2unr6ZArzb8dchYMts96dJAT7g3eLsaxNEPEbSXabq+bkPlhdf7r1Z3ZA+/j0ZGbOM
	I39PM2l70IF5CJcDON6OL5U3xXGx49MqnWOmonCMoKDKczs0cakxZkEppp8gfI/qjL/Aui
	hVXxJBunvB5Q/mK+dArxz3EFSA28D4k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B61243E3B;
	Fri, 24 Apr 2026 10:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D67C19425;
	Fri, 24 Apr 2026 10:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777026645;
	bh=4xYRFTsa+snUwsnsMlD+flP8XlsjYGjzwbUWIong2Ao=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gQOY41JzUhrlE5H3970ccwjTNwmN96kWmFFRqnM/fHwgXOe7doEV0seAfQ6jigNCP
	 ozUA2T42qL9kFIgNzPFYogwDvXy3/+TjJhF5wet0aF+1PW50r7Mwm/r+y5jrFMOOSP
	 mKaQKAnxeW96a3B6qlgvePIfLIqJ9uYZHXO+IczU=
Date: Fri, 24 Apr 2026 03:30:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu
 <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 00/12] Remove read-only THP support for FSes
 without large folio support
Message-Id: <20260424033044.440cdbb6ee872f9a815c841a@linux-foundation.org>
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 76E51C0014
X-Stat-Signature: tchnzwyp1p9ju9crguuqywdsy9mm656m
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777026646-930228
X-HE-Meta: U2FsdGVkX19xwgnzPl8zkspwgN1EXOZH1O8+3T5G0EoCBV0tOdiDEu0BLaU6DkFBbMVd0eLAmgAMMebem3hXypeLXT96QC5k23Xn+zI5UVX5eKIh0jn2SL1nXGn9EJszzcFJgmQL3igc+k3stLpkfGeSP3e7GxXtUaN5DTIJwzbe6VeFwRaMiO6ME6rFc6qWoCoFfzSFlLEFR+bIBSMJD6svdX1joMjCsl/vBurXLd2oVBb5FmIbNvB+ubyMuFyKd/KrOywYluGg1f3RvzGutJ4B9BOX8U/VeMt3ayODGFdG1q6llAxmqRDRjrSaicb6J+Mp5zq7xkS7YnvmjsyP5f3EJvvMM9WbXa/8h8xXMLVNpLObxVEvyFIA4DI4/Xowe/MwH+SLEWMA+GjhiBiCMCNlN2GixllQdKpKjTOv+vEJ6FGsZnZzaKSkgQPpick/YB4Kf1i1ukfmadtelIEpadVUw9kfxebWv2DuZi3efMVeJ5G1zx8Phj+l87+q1xEh6+yY8W2rWCBCFT6V10bzevkPb4aFM+aSTxL/9QRO1ZNXDtPiNZoaJ4I+vIJb7B1kyq+i4XVLF5Ezi9h1q3cKnFFiatZj/o9yRVLKRu3Yzz1qeEf+6bp5otl0pe/3emI3X2wdp2zWi1gnGyndHN7Ln9XlZrkrvg2Rx0ubQetwUKL4sVVAuO3ojADKvgseKkeKBGKlpqWsU6iMPc4yelH7BQPDqOsXQ/XtRdu3zSSUAcvEtusYXylssKPIHVNOSR7nD/JazdvT3lHM6x/ys8PM20Ir7OUDXyQivoNa99Yv+mSIRUzT23D6XTPRnjnvQnfH6So8Vz3pMrJgFbcjKiQGvnX9SXpkryIsUvuG6tvyNdZe/s3E6GWajqUmym1DuHr0hVucKEQzWDezsG3IjZwvackZ5DzVFTK3ZtFtCwcJXh31sVkzQ/lf9VmYfoCkMnNTNT4WlOqIJtMjzJstcc+
 QoqGFbdM
 8eycOtNORg8SkMB/LKMIkQn9ifBCuVwEKHOzpN3lh0NafPOUq94B4+6Jy1OqKzXFk7IcrFatFOcvwNQBJK3JtSbx4ISilRwgn88J/573ZXKTSIDDlRSP9ZJ5Dx6Vbvl9CKypH0avtajUsnw0uAG2oGC9fTSsvWhb9kQeF/aA715x3x6/VeW9I1JJw8Ye0gDuYcjna5WA68OCV9Pv2oWeHky3wibOXPqeON4Va7JNMbdYgLKl5XWed24Rhu45iTJOH1rocec+04JLC5fvIbOFvZvEHfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 22:49:03 -0400 Zi Yan <ziy@nvidia.com> wrote:

> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> read-only THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default. It is on top of mm-new.

Thanks, I'll add this for testing.

4 of 12 aren't yet reviewed, but that's what we have akpm nagmails for ;)

