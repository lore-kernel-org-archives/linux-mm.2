Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA269D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0839E6B00C8; Thu, 15 Jan 2026 13:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B986B00C9; Thu, 15 Jan 2026 13:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F726B00CA; Thu, 15 Jan 2026 13:49:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB16C6B00C8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:49:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B8571AE53B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:49:11 +0000 (UTC)
X-FDA: 84335085702.21.BB4849E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 988D9C0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:49:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OMPqv3Vb;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768502949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThW6vYvjdr3pPjrWFyNO5lbZkr9wIvw5pYgIyDBpjoM=;
	b=Jpk1ZgMCwMqktSLqlOw+RGTpZsKLNR6pbXcF3MjmgnkQS8UNFShxcaILxHnZu2+MTDafib
	kDrw5PvRyVEa3BNQmfEL4hYISJ3vpEczovBaiQWYEtCP/9lA0GUUJ2PkrCawqrdx7XkqbG
	g8rUcRBDWI5KW8kjbs+DyRn6/j/ml9U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OMPqv3Vb;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768502949; a=rsa-sha256;
	cv=none;
	b=8MnBfEW7iedW46Vfn2mds7rVa95XxmK0GhxUiCW6slLB3ufJaYbK7nwcdvkPIdqVxrMitK
	pa3rjg39lF936gY4/z4JZIEHykMIDsBRTVlb4B6SGe2zWzWzOueSuUYzkZ6BAsGhYVtBVD
	I7wVh8LM52KtZMxOhHygcwHTrREfQxk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C92743462;
	Thu, 15 Jan 2026 18:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B856C16AAE;
	Thu, 15 Jan 2026 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768502948;
	bh=WCyzLTExsBoIYI4mj69MYgmS8ij3mWHLUriLEtCRl4Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OMPqv3Vb6igzQ6J6yeedeDADZNmSJcTS/NqTR8QuaY0arE+RdTkkZ/LG6Br1CzeEc
	 Mldf/qb9ciqHrV3QcrtBfcSw8RKoikT5GffwGbIKz9eJUZ4C9P9tbXXEIBzHqM4A/n
	 eT+/3C1vuKZsdshnSo1UGFdGeRhce11EHD9zLCSI=
Date: Thu, 15 Jan 2026 10:49:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Oscar Salvador <osalvador@suse.de>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas
 Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Jerrin Shaji George
 <jerrin.shaji-george@broadcom.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Zi Yan
 <ziy@nvidia.com>
Subject: Re: [PATCH v2 00/23] mm: balloon infrastructure cleanups
Message-Id: <20260115104907.96d2aac4de42dce12d6064d9@linux-foundation.org>
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 988D9C0008
X-Stat-Signature: ungk6pmqgp9sawk9a6y6sxzydq8fwce7
X-HE-Tag: 1768502949-161110
X-HE-Meta: U2FsdGVkX1+UeFxvWVaHB9cCAhoIJO+gXJ01rKRMblsm+EbqrOfc86Mceo3BwZ2NNy8UmCl3KrMSjHqPiVP5OfaoCYM2J0AUGq9Bxdfb50nGs7REesPuvltYt966XJaze8FWEV4J3zfh0MfKcne9LGL8KIIp33jreTLwV+z3yGKY4IZQyopthJNJjHoWgoTdN35qt20XEzNK4UMIUx78Ux4EA5sPk+E0WDINVMUFCmEYKFLiSMA9kHJdCSNAYzbhWaYPY500Oh5lGOO1K4LKYPQvI9ZQ3EgtujKuY/W98vZDrt6HH2IOObqf4IGua07jhGHX7oWHa53ro2iSdaxfbVMxTDiBRLTtyBfjT/h/ZKnSwgIkU2WDS6aCbIWL5LIUHjfhIYPb7T/yrCrcg557s4C7K6nuRigGJByWs4btTXrN2uznUO+qbe85arHv0lOrwIYx3onBzK41CYMaMJ/k83FEhcAPbgk0hqsnuux1q9q9JGO5+mfed0Lzm52wAvpeAkbap1Klqp+1kGa3Qp/Ebhn1a7fEtfrAk2ffphkosUMYkJvavlsojQdVq/h7C20Yfl8avSHRlksgKDOLjroaITR/opCPVL3wJJ7YxK357NHySUjDk76LoW948D9arxRsPxlmLEy6f6JZ+eE1OrTgz6hQgmvZvviMy5gvixx0PBhbmUgBNktvdhadZmcYEoZpqSxmKzlbWVu7NBqp5XhA3JNQKHDsx4lRnkTn9X/icFDjezyEYx2hf10SIx/SO8lYb/z3mtbz4EMDkdRPX8ThmYQ7I1/q2M1pi0XfbbsYE6to5BMjKz6wAxLENrhmrvgYB+5D1WXIrtO3wwpVrUU0qAe6pTEaxdeL4+eOav81RzTO48DhlPPVuSqJn3i0mZ/mPSDiHLAo919cAvrdHZ0a+HxkDfrirwTscri5pGR4TbLjcqrbvMD3pK1nUescp5SlOKXxVSbOqKW1E/ZNDIS
 UTi581O1
 P8WWC6r/wZUFWn40cQwNz1yJMKfUwjzydneFeA2NmjZ//oV3HvTd7M7tW422x7MqDx8a8gfxADuR9FmDw8jEMQrZwDtE7WV72EJchw7eGCINI0lFA13IlJedPgVvjpBh7RYuJzQ3nUGiHGIX/rpoWeIYjaUiyiAYvxNMMIXTS6AqLz4DOUpJLzS6XTxbX0u4grNHcz1/1s+y5CfaO/ig872+HQeXG50Igz0yPB8Mgih1z4SSPEFo5QrwEbZWOEwqjmIY2hJE8/TsekFJFXI//I2nh+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 10:19:50 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> I started with wanting to remove the dependency of the balloon
> infrastructure on the page lock, but ended up performing various other
> cleanups, some of which I had on my todo list for years.
> 
> This series heavily cleans up and simplifies our balloon infrastructure,
> including our balloon page migration functionality.

Thanks, I'll add this.  Again, I'll suppress the ensuing 528 emails.

Sigh, I do worry that the ongoing email deluge is training people to
ignore addition of things to mm.git.  Maybe more emails like this one
is the way to address this.

