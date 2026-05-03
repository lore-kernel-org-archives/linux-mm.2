Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A29AACD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 13:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC876B0005; Sun,  3 May 2026 09:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85D86B008A; Sun,  3 May 2026 09:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E016B008C; Sun,  3 May 2026 09:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A01636B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 09:32:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C5961C12DC
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:32:31 +0000 (UTC)
X-FDA: 84726198102.10.6A2FC77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9356DC0014
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:32:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VMLUKH1y;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777815149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLLG6+1qsjUFR7lYuRdKmtxK7BRythtvpaDXkaE9bzY=;
	b=GRvhSQCKzlYzsOaFz4+0BomQ+Ur7p0+n8jJtu7ypX/KrFoFIpYLY2/9dkHr7tkzKjFDcBJ
	PDFw/Co0SNZj1yt9kY9oJxLjuCTWZYjyJCmzk0M7WNgOfNQCpGvWHi096ZniFPjpC0rcW+
	1UKzWi/a4FzdfDkjuVSXlMOypFAFsyQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VMLUKH1y;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777815149; a=rsa-sha256;
	cv=none;
	b=13bCzd6QhV0T4WFrzQP9OD9sEQcoyjaDbp9vZA6gYeYctz6q/pSOqwMfS/x5D11DYRuI0E
	TxP8jHC6IILSG1zfz2g1LaFWPemLPmp1me4IexkjNg7RrkKiRqsrHijv0t3ob7rso3X4Y6
	cTaXBx3mPuad9JcY3vWzlGacER844f0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB0F860120;
	Sun,  3 May 2026 13:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E258C2BCB4;
	Sun,  3 May 2026 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777815148;
	bh=8E4wEVhoxVMJzvt9Yay3GcXb/sDexIP/V9W0XqAZf1o=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=VMLUKH1ycv36KQvHnq5rSyu9FU98Uiqe3ehx+970ckoAypeAM+PXvJdKFdOk518cg
	 F+rM0924/bGMboA1NclQRj7A1a6x370rN92Jr4wfl4rd2ya2blnUDGH4PdXlm8dfEE
	 EAy46h3WOH7oQmXVHZYQhk9D06XPN1NVQizvnvmI=
Date: Sun, 3 May 2026 06:32:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
 hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com,
 jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
 lance.yang@linux.dev, Liam.Howlett@oracle.com, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 00/13] khugepaged: mTHP support
Message-Id: <20260503063213.b0a84d44de341575f8854f0b@linux-foundation.org>
In-Reply-To: <20260503062109.0469201428642a4f7fcfd915@linux-foundation.org>
References: <20260419185750.260784-1-npache@redhat.com>
	<20260424065828.031775921990de37f83a2468@linux-foundation.org>
	<CAA1CXcBJFoqDrkQbRE6JnpV-gjfNXe2sUxaCyXPC82h3qk9Jig@mail.gmail.com>
	<20260503062109.0469201428642a4f7fcfd915@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9356DC0014
X-Stat-Signature: u3cx49rq1tku1dxy4cotpbknnenypcw5
X-HE-Tag: 1777815149-864217
X-HE-Meta: U2FsdGVkX18IyAK4K0eStvDkGq1+l/TKv6bY+KDsu5J9A3pjT/rfC3noLwTZfD/YThs70z6EmoJdIq8o4J11OYI6da6sX+pyNjzIs1++YJRhbarG1PZ5np0BN/rvf5Sdm0hgnNoZVZJthOvxnRFr5Ah7SBZiQtLm+Wjj9G9FYyPBEQKhQ05AjCjZ/L8fp/hosVOY8ioEqgW70efszKs+TR0RM+JsHN0tpgjbXLrwSMwDpWxFqAGOKc0kAJqNJe+J8mh5yi1TQGBlrDUCi8WXreZdNadsopGKHBb4SlYUc0Q/ygMHJov++13SebP0lo0K0sRW72M1UYp3uzmkfoRmzAhGj9J2XMy7XrED/gnMsjSSD9rXfih6fL6OnLj6qzVSchyPeYMakx+owffDcmfDL+yvZTqjbPNr+sN7rbREc6hRJOwkcEEk3M5Fh4o6yDj2OUWicpSyJKI/6K4zvfHOuAhzdLnrzXeYiHnqoPxbOJpyX4D1xiLMV+BTEy8Yb7SH6818KeXo8F9tE/SW5rX8TuOaG3lzVq4HjpUph0dySf4F39Kom6tc8TzuNsz2kEKm6V02SWZ79fnZBh1BiLYg6Ls0svsbPmXyCGulpJkpTogNxwDu+YsPk6uFJNhZrTWFtJ9MamD+Ixy2nEG1eRWjkZvyoshTr9CbQ2KKAf4Q5gq8RWRq7mf0DruGK1V2oRxwVq9UmDrPOEuUkbCuQTl4FDCfmKSqiDymuehSDtLrGzHqwd+Gj/fwgo5RHmqiDlQcQGsN3R7q0RVOxDr4GGy0+5FCEZfkdqiEhV7T+BFPaql3gVOhXfnkTwjy3H/xx8Ox34JDRWTkEZyVcWpe1REbsP4PpieHrFbQ2WhGjbTZYGL+vB6uQAx9a1TjSrO+sqPygVobanDlv5enNu0lQSt6Xww/sXolgNXFPO9LWijsZbqeqU9lSU69dl1JBNEhCOZfyxpAn5BasQA3E1r0mdR
 TOZ4FxGD
 w1bQOuVcRNtX43L0T6+Lrhl0G5oVgcKqc95WlOeD/cYLxekT/WY3vG7n0agVRWWBnuUnebrL+dbQpFXqW8uh4Q1XGHBvdEa/l8+ee0zhSIINhbhjqgHP0cjK8lG0XwxUP8N1Vay9fEq49hglttTbDyMz/M3oK1OuNpFvWhIhycZ1eil4ItQzaCMj6+5v8m/R030Oj+LBkZ5KWrGa3EuAb+cZ0hrltR1/COYnuhj4nKyH9BwS2fsGoD22yH/V7PBSZlx6kKWLqf2M/7tzUogBQ1Ae04um8QaHir/7ntV/FmtvPAzuQuwSax8opUvYYLt8aBK0Yz0G86sFXAOLqcfBE3MQlI0eZnu4U3qmtbc+h/OeYjXXwf1KaRjUHf8cap0iaN16+c7yFuZhRLDPdjwjnZ3ncSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 May 2026 06:21:09 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 3 May 2026 06:23:31 -0600 Nico Pache <npache@redhat.com> wrote:
> 
> >  Can you please pull the changes from the
> > staging branch so I can resend it soon (probably after LSFMM, so no
> > rush)?
> 
> np, I've removed v16 from mm.git.

And that messed up Zi Yan's "Remove CONFIG_READ_ONLY_THP_FOR_FS and
enable file THP for writable files", so I've restored v16.

Please prepare v17 against mm-unstable.

