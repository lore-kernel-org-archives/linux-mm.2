Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECAFFCD5BB4
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 03:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222526B0092; Fri, 22 May 2026 23:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3026B0095; Fri, 22 May 2026 23:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9576B0096; Fri, 22 May 2026 23:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC3C56B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:11:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84B651A04AA
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:11:58 +0000 (UTC)
X-FDA: 84797210316.26.61E977C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC7BB4000A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:11:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZPOfCqk6;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779505917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMUGnr5lHTpi/aIvehDV4/RDimJryM73ojahq5q8smY=;
	b=LJphs+XUvR6MCs+I5vB1vUl7aBjRQ75JwxmhnGicXcc/j/spT2Z1ZjXDhCILMbp54FGX8c
	emip6soA1mbC/tiP1OC5I3C/vPtDMao7TVHMY8lbNHd8Ac2/VMwfb/4Sj7JbXkRpT1w+XY
	KSynvjxjrVuwWZe+ZTsARJVgUhSmymQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZPOfCqk6;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779505917; a=rsa-sha256;
	cv=none;
	b=MxU/Lrn4QXhljQmuWfR9ySAELa7WlxyI2Nmcly0xTFTXvNGi4+cEed9N0/2lhN0rqnVpY7
	Mrve98mozzK/WcwAuay4HStkitbw95H7ImOFm7wRbhsoTQErQf30/phVIEf9XaIrp0yZ7l
	/zSTcfzxhdekbAwFYN4723yMG5oJo/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BA3043EE9;
	Sat, 23 May 2026 03:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408911F000E9;
	Sat, 23 May 2026 03:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779505915;
	bh=sMUGnr5lHTpi/aIvehDV4/RDimJryM73ojahq5q8smY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZPOfCqk64xq9JunmbwUf+mkNecd1SuMFKItRdiNSl2Chh5Sov1fL6jV9APSuX5Gvp
	 CAM7Q0a9rhxjQ7tHv+w1DepxNO3JTi9lO+fXpq3TSOah09XlL3ZNJH0bmJwqQU7qWG
	 Wi61IEYUTS7aVBA+MYGMJoAJwnpfFX6eyRjj59VA=
Date: Fri, 22 May 2026 20:11:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry
 Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/4] mm: misc cleanups from __GFP_UNMAPPED series
Message-Id: <20260522201154.26bc14524c36df15e40c3470@linux-foundation.org>
In-Reply-To: <cd721e44-05cf-470b-ae92-d86791778c28@kernel.org>
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
	<20260518111546.3baebae99dc3f2a4fd65e605@linux-foundation.org>
	<DIM2YAI5ORUU.2YLTV7PWKE516@google.com>
	<20260518134811.b2b78352779d7519e8123597@linux-foundation.org>
	<CA+i-1C1THr6fH=wdTKEngbCSD_DMS5tGroN64BEf3L56DH2XWA@mail.gmail.com>
	<cd721e44-05cf-470b-ae92-d86791778c28@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC7BB4000A
X-Stat-Signature: y7c7aofpise8mti31nnrj57q6ebsn3ks
X-Rspam-User: 
X-HE-Tag: 1779505916-774643
X-HE-Meta: U2FsdGVkX1+iE5fH4BUp9RFy/o1R0NjILpNoO5Og/bGoPi3tUy3vcaaNgfoClcXc8p1sYzg7W2ew00kXTVCGIxPQArmMsPZg339CXw1flm1sQ6GS7RWC9Uqx9TBYh6nrm7ELPSOMxVGleu+7CzzLTO4IyeMkupzG7rra8VaWNvjVixc4xF7EVYhxbNUah+YR9+5O3lHDn7Ojm7QViwcjQkesN6zwqz+5xqTf3AwkM3MT0yiRDBfZfUGrTJWalOpJl2m45GWDSibn3/JrP0BfmJLtJRchI85xTGyy+1Ydl4lozZXXLqOG3tu8nr3fEbSRQ/hU90ijgprYlr2JWcDMFWRHeAmvZshndCcXKrhTYvrBzdp+/8p2eswnn09/M9+MpATvbCUki7CLM2GnWFWwI7s3PoRpucz54zbblud30tVXbd6y7nFIjVwF9PssYs7QCZfZcT3MsfvFZyw6Hlwyx3rEK0lNewvTC3TQlAmEZXHxkQd5/X0VdNGkLD7q6EdyIkD1IwtX2Jn3feBnS1XISR2sJGr2dHBk9s5NgCacOZFYuY/HohoHKjirr/izM0KX1WRuEJ8tMeCfyPBA6ooEaz5F83/QuYDczCogZLD8URuJkrH34Kru2zWw4cpngLroH35CNvoACdLtMJ4b302w9DeZk5grbZyGn1V4T4X9Gu6ZcjpdooysHRc8NI66TcXoR3r7FgyBPXJZjwzi8yhiKClfSGW6NWQikCaooCjCwqVFkIARtevC3JFUJWr1xx7mPdKzXruAT+Nb2Ox8wxR9raBbOUa0EQ1nH0VkIfuz0GcQ99v1sXGl8LTLaZzzCNOq2elZdRsY1oKl/8UMxTPG90C2Qj4tz6t+wxtE9dT/qZ8VOp3Fv6Lhb3yK8/PVjTUfS0p/rxVHvVrKsIcUT/r6qB17TbuB/r8n3GJ7Q4Ck/SzyxlbPvWvm8nYo0XZ7FqM0epA/OaazZc1D5FGGb2K
 dmduYcJR
 QA+te2kyP3193w0ulzAIInbwok2xb4pHxktYs7oxSfBt/hdcNOERMfNVRGCb/g8oDYFqMzJM8dXa6UG1VBpixWD3n9PeF38X8S4j3jXMzBnI7mG6OOWUiH4eXOxJpiUdsn+06XEV8Oi6dykXKDF6KFH5x3wbh52yMuQ68G8+Z0k+JNzfiH6UggIgs7/kuAP+xfXOzRODCFfzqbkZARPv3sm/vbp+ENnNc+JRheRkWsM1saIEBIwHTrqjmE7xWCGcw271Bv/i6HD1JmviqobkzCRVp6EJIWW9baQr2WT3xWA+T7xV0BEOdmHzzPsFxAkNK3bP6U2alYTUdGwS+HAUhxUyaGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 09:59:49 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> >> > Cool thanks, (also I got the "added to mm-new branch notification" and
> >> > realised why I missed it last time, broken mail filter).
> >> >
> >> > The 4/4 update is already up, in reply to the thread.
> >>
> >> Is that "mm/page_alloc: tidy up pindex helpers"?
> >>
> >> For some reason I didn't receive that email, directly or via any
> >> mailing list.  I do have the similar "mm/page_alloc: remove ifdefs from
> >> pindex helpers" from May 13.
> 
> Found it, seems to be threaded well with In-reply-to: too, maybe it's the
> different subject?
> 
> https://lore.kernel.org/all/20260517230556.590677-1-jackmanb@google.com/
> 
> Should be fine to replace the current "mm/page_alloc: remove ifdefs from
> pindex helpers" in mm.git with that.

I could attempt to do that by my confidence that I got it right would
be low.

Brendan, please send us a v2 of the series "mm: misc cleanups from
__GFP_UNMAPPED series", thanks.


