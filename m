Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A586CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 01:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE656B02E0; Fri,  8 May 2026 21:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5E96B02E1; Fri,  8 May 2026 21:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802996B02E2; Fri,  8 May 2026 21:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 724726B02E0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:18:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FB6E1C1070
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:18:17 +0000 (UTC)
X-FDA: 84746120634.17.3E1FF0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C410A0008
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:18:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PgJ95s4W;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778289495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hbzRVeIkqGo31CBIiCGqQkeUfrIjB9K8LCQkVXLf54=;
	b=syGWGqUktXJj8XCjN2H3hg7WXSDlpBNvrAjS2PbNEYBd1qBwSjPrlMpI4fZ/41diBAFQ9A
	YpL4u44/s8tMDq+VgVhFg5cxEin5tWD/wogvYjw+4BZXnVKTR75S929ZZb8roZCx49DQaj
	kUqdy0um7R3DA/nI+dBo0K3MvU6/t0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778289495; a=rsa-sha256;
	cv=none;
	b=sfWD6e4a2HEdEEI8r52Tid/ehkqzsW9KYYrFlxLBrRAE62ZhnbHCLISiqWkevSzNp7EtgR
	61xcVyor1X5R4UrV68LNcX0jWXtH3TqVB6aGn3oudMtTTGNJCeAPBeF+crRVTUUoDYgn/q
	qOUVolY/2Lxn8Yfw32V7FsSkIwMJg+U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PgJ95s4W;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A65441A21;
	Sat,  9 May 2026 01:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36013C2BCB0;
	Sat,  9 May 2026 01:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778289494;
	bh=nGj4J+QpMJlpSmjnqYl5LTOGBhNjbPlQ6Cc62dpz53w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PgJ95s4Wbn6lhlVSDMo618z+HiOmsc6BnovtkhY/w4PwPXdjYtD4bV/UmrclFNDck
	 W8k/7wce0gWQQ5S+CgA37+MfQgCAVf/4Th+jO8lwCxt4Nw6I81f4X69OcoUPDlOKMR
	 FVPF0/Np4UppbWng77SHO14N3DYaANg9uTPbsE3U=
Date: Fri, 8 May 2026 18:18:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bharata B Rao <bharata@amd.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
 <gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
 <peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
 <rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
 <willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
 <dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
 <yiannis@zptcorp.com>, <david@kernel.org>, <byungchul@sk.com>,
 <kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
 <balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>,
 <donettom@linux.ibm.com>
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion
 infrastructure
Message-Id: <20260508181812.d2ab17b08529f17b330e157c@linux-foundation.org>
In-Reply-To: <5110e313-8c1e-4f73-b77f-68d20c2046c8@amd.com>
References: <20260504060924.344313-1-bharata@amd.com>
	<5110e313-8c1e-4f73-b77f-68d20c2046c8@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C410A0008
X-Stat-Signature: u3uubbrdzz1jfpress1uxo9ra7tmeby8
X-Rspam-User: 
X-HE-Tag: 1778289495-309841
X-HE-Meta: U2FsdGVkX19OS7D6XYPRaPtwqmj+JvD0qTAcBYuE199F1cWndpntxFbEaKnaFbO50ZYN0X7skQSo1PPz6bIuvmdTUTHwoDS+Zk1eqZCBj+qwKjzGGON0Sy+eH/V5GwF4pAO7HiVmom5sW6h+KRxiUf/h3L+6qCh5ap9oS8hjbnJPKuEE/Pw9uGce++jc+iaR1xPdtv/Lj0QWbEkJIDA3WbHDZL4jA+EbXu9D4AHJ+UNAAYIGlc9cNKrl3WRIROxy/f5VBh++7Ldx1IOzfcupfnsUFyofBLHo+XbxSLhZik6qmQvnJS0aIB/seN+JGx75Orw8xKdOZ+Ayo5CNNT2UdcPjjrzr14csO402c3s/BjcAoD6/MDk+nPhGLjE//4pcy+5Uv4FT041vNs6jK0cykoSOTUiSsdqD99EIHuMLyZYXXKtLTykRNSo1sihZsPNjDioOB5+cl3j2KF0zQAb7h5yfbKBaxW3vRmsmr/Iy2kmwV43sZtMkHV4rii4AU6IiQRWOLQ6pjmefM++FqIP6NF0oeDxQIpTPmyzZEg9TAOYrgEqDb94yaMVD+XC+XvC4CCzdbrH0oQbkvK+7nKBjCPK1OwPxjj880AXYS1h9dhBxIW0zSIpjkIMn5ayxuSM5JgB6ve2J2/0IRgm3klHUTj/tsxPxm7qxpIcCwPvZypWgZCSaDjGKuww6roelsIS78oSKRQKgu3RqSW1fMNWDEUx/ULAWh7XgHEMXIE76B5TejXpRZjaFj43/XDu/+nSl4FxsEQfFozsw6wGjGuTfWA/cCDQgY4Aufw3S7JIIwsGT58QtXXa60ex0nxtzvmbalsOD28mSPGU249pXpIxja1FtsVPDZFHNJ2XiAkx/0KlxwvezaD/MPdc3tUOsW9hxZRIt4UcIWm147i3+OX/xLDNhvEIwkebCB6bnWvIuqBjKQmnRBuVb5u3vx1O1X2R4rNntCmdlghWl4lS3cZd
 orzruNO/
 C+XKFhH9h8Ld7fNiiz40IK17mwjcg4zdwFZ7HfYAyiRYngm1tzYbMR/+9jBeNUUjOMSIBFftAtT8/CQmGdzisc/KNPsORS/l5zEafw+dIr8FfT2smBMBw5dFC7ZfhA3bpTPt6TW9mPdn87sOdlj4QtniLIaSDyp+l0h4Vxkxk8Yay7XHrj0fs0A6wZO3ACMVQ3C/saQysrJtIKsPqHWcTERvNv0qnqUtjZTTdxAmUZ1I7E3j+fVM54JXBiTKBBnzYHATtDC7sW+4T/Vud1gE4wAkBRAMMh9ubTr3TlenJyJmrdGOqmEdReYFpipZafzhCxhpQjQI9CLpFRIW1KNly530WXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 5 May 2026 16:11:43 +0530 Bharata B Rao <bharata@amd.com> wrote:

> On 04-May-26 11:39 AM, Bharata B Rao wrote:
> > Results
> > =======
> > Posted as replies to this mail thread.
> 
> Graph500 benchmark results:

Please include (and maintain) the testing results in the formal
changelogs (perhaps in the [0/N], in a condensed summary form).

I mean, the entire point of the whole patchset is to improve
performance (yes?), so this contribution lives or dies by its
performance testing results.

The first thing your audience will want to know is "how good is this
for our users".  So tell us!  Up front, within the first paragraphs!

The better the results, the more motivated people will be to help get
your work upstream.


