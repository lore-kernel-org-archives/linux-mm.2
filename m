Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AF6606A333
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hrwJiClt
Received: by kanga.kvack.org (Postfix)
	id CE92A6B05BB; Mon, 16 Nov 2026 21:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99F36B05BC; Mon, 16 Nov 2026 21:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD69E6B05BD; Mon, 16 Nov 2026 21:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FABF6B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:03:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1067D1602EC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:03:11 +0000 (UTC)
X-FDA: 85442963382.28.0BDAD35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 64F6C40005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:03:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrwJiClt;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xk4s00lH1jP8Kym1YXaLQ7Wf0LEh2ORBX1GhbZk7f6s=;
	b=ov+RR4EiLZXzinQe2WP0apxhlFb5iEMb12AO3hBWED8FrWXqOrOjKdgBoG1e8wH3eU7CKL
	lCgFTHLJJkDFvwolB3XEYpoXyZbS+frpA+KvUyFyLTBQ3YzzuHL1yg5o6J5Seb2fOTnOiM
	CxzNMWddjTceiN4Lux7i0J/KqUMH3vk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880989;
	b=BnzF9T5KdNk8kEthgcpB3OXlz4iFOpbMELLx72i1sbjDCQle8bhF96OO58upSMwKtAGTFK
	WwrfJTwBtxg0SY0MGB0w9nHUE5aCQbv387quFKXK0stadRJmT8RsBUIU3zJ0D+fmzYnEaA
	2ZItnN/96OB5z9H/+a6tkFKF9wQJ+/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrwJiClt;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 930FB45E41;
	Tue, 17 Nov 2026 02:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF621F000C8;
	Tue, 17 Nov 2026 02:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794880988;
	bh=Xk4s00lH1jP8Kym1YXaLQ7Wf0LEh2ORBX1GhbZk7f6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrwJiClto+C48EC49n/1H+Cjq63wAPZR54SZhU2EAPoOznhGsCcLABIaJWwDaJbw6
	 rfN8nr7hASd96R0hpYkrxOSruU11D/asS2RZYm27yucpVPGnrqDCA5cgjVZU/nW1mW
	 Ln45+zLNkAjf59tt4NtJhM11f2uAt/96RnwjFz4kiqDAGSzzp4ac6X72ofkiJ1yMBQ
	 j/NLU9aJTIhW4ayxlU1IfkIPaIe+KOp6jom6cXnqtTTIpcmMaqIxLnzSM5wLjbUiBw
	 KL5dH8sv+n9Iuu9OzitAAlg3DQf5bIpi7NjAN3evObsWIZS2bky+RYSCYwzjJ0ftMj
	 m/gPZJYqROqiA==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH 1/6] mm/damon/core: introduce sz_ops_filter_passed_last stat
Date: Mon, 16 Nov 2026 18:03:00 -0800
Message-ID: <20261117020301.109715-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-damon-sz-ops-b4-v1-1-1cffe7227e6d@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uh8snxfabgtqu4p37ddau54ybgg3anuu
X-Rspam-User: 
X-Rspamd-Queue-Id: 64F6C40005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794880989-707091
X-HE-Meta: U2FsdGVkX196y1QeE3CDXpVopDJieqoUbfjC3Ap73SrGiV2cpwMuEOyyXBv2K9FdCxJiN6GLRBlWHAK/NToZolwPjUGGdja5/Ro3UWtQ3npWV1jYzy3sF4i0dwZPWvxetSW65VGKk3chSkP+qPIxtuq/497ExzByfG9/gkXgups54YXOWx86t8AI/01AUUpxrEZG8CfuYhgw8UiDGYSxDqeiPwMW77LTIaoQl4JrML9oIEQ27MveTnx/j9vuvO+DA5vuf33Xyn3o4Wx1JU03KsDESy3pHEeXB44F/zDkANFdYCHnadnS2ysLnWbvC8Wq2u+2vMrdM7E9pDiAVoEFMWJ4JXA2IwIqmXFITVmFPaxZ3dytS2DXagvQ5+w1zB85eMmdMZ6T7T334xI+aQsI9kSSfJaA4uFq8zRV3iLPLBDrMyexEr3CrMt9lrTDhuNI7Z9L66eFgFYpZe2sngh1o+X3XNZVl3I2/+A7aIWnXeZRYzORdV5r4qqGeaNssfnnouTQmcvpQc/MpkMU27EVsO5O+tSWz/0PztyaVCmWt+ys8/UcMUJApmRpdExxheQ+URL0gin4NcuBNySMpRgCi25LdyqpvjXFaCcP2+OcLa+Qq4SNzoLFiLJS8kjx4gEbuJXOdnrIwu1zwTHAMoYR9pAQC7CsLuNUmOuvhwU3Ed2PIamT4/c1EnAaqCPerBqfHZiSu4RWD6MdS2xMxJcnaxmLzK7Vz77M6cbt/k1/Hp0qOr1/KuiRukgiWxWUal8aHQDTyQUJdY0R9qPxo2xZLOe35rtd8beq6Fbv9/7k+26ytBeuJOER50LkGRCroWvpAju4iQjlq7LEvDPuuQq9hta2KSC/X8fNyBwLd7YzZ0UUCnoF1hbVSlOZZQWnnASy+5mLbxgemBvZlyKafc8jlTnbewW4DlpSV4XK4TvwbZkM0rJwR9Eg+uyy6ahEGPC5pYW4w17AEAl4ZnjEvyL
 KGpZYHkF
 XutDobLYv4a2lEapN26lLR8BHo3K1sEdbd1BzrVrLuh7cRsYvf4zMKP+9YVMrR+j5AqF5RTzekVesEQ51CRickrSu5oTDCqgUUbLT67lEmToqZhERrbLp2TBIZAuP6ZgDVUiuJMfMeqWhbNhBFy9ZQht5V/0zUJADO/NEP1k/Jo9Hst4BshKpjvzIgOxZM2IVeGB0gjWh64qg6fAShyYs897ApLGBoUBfmhxhJ71IX9GZD317hbkiXyIBrpmpYJYOUWgy8rSzDTh6kvSjt4VZhQCGhHQ8DX5Qg3no+G7PTnOxwPZjr+MHtKfuG5FupWN3XQvatRPBslofci8MQYXiagIdaYp0yESUQZGzfnohMpwcxtu/lVmI3Fl7JD+hn3UJEkRUdYSuDCubpbmWiVDJh+b+MLBCgCZEHib6MG7+1pvx4pnwg/AIEjOtGG2G0M/GoRsy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 19:10:04 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> DAMOS stat sz_ops_filter_passed shows the total bytes that passed
> operations layer-handled DAMOS filters, accumulated from the beginning of
> the scheme's execution.  Users who want the amount for only the latest
> apply interval, e.g., the size of a workload's anonymous memory that is
> cold as of now, need to keep the previous values in user space and
> compute the difference with the help of nr_snapshots.  Because
> nr_snapshots is increased once per target per apply interval, the
> computation is complicated and error-prone, especially for contexts
> having multiple targets.
> 
> Introduce a new DAMOS stat, sz_ops_filter_passed_last.  It is
> updated at the end of each apply interval of the scheme with the amount
> of sz_ops_filter_passed increase in the interval.

Looks good to me.

> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

