Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6568CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 18:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0E56B008A; Thu, 18 Jun 2026 14:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688E06B008C; Thu, 18 Jun 2026 14:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578056B0092; Thu, 18 Jun 2026 14:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4E86B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:20:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEEC31C4381
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:20:12 +0000 (UTC)
X-FDA: 84893847864.25.919FDB0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 16F4640010
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:20:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YfOhqeQz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781806811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nl4WGWLHU2nDZWMLWrJ7XgtTVp0Yzn1ezTw1CgqCOi8=;
	b=XKv5dLAX8TaobhyU9m6wyiIYN3GhHPzl0SKQNRpex47LybXNsyG8elxcJbI6wrT3uVmIh+
	rAgE/nLyrbzUEROkDWXquPI4VTj/gHqJAJmpi6zEgjzn+vJltK64O5q7rENeAinTkFsgCx
	SNUtW9tFNFwQ0oscoWGRMO4IebqOjos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781806811;
	b=yUMB/rHLMXyKJRRp254+TFzM6oRqLftL3qs7q21vXqqQ7EqBUAOfcMKS0akIfkcetg4Hk1
	ehEYik1kZ6EpJZbZGJ+y+NLHudeJczZmjTDRk95qW3fGMLLg346wkIXta5L2qd4X4xQy0J
	JzdOYyIuvOpRZYwXJqLYT667h9sHr8E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YfOhqeQz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nl4WGWLHU2nDZWMLWrJ7XgtTVp0Yzn1ezTw1CgqCOi8=; b=YfOhqeQzj9WoV+oRg3QwFhQ9jt
	CpxcX52Y91jRDKTVtVrVV8WoNUJsjKYKuhxKCWQ5IJ3VDaIvT86OqGZqrhfV0zIbNUby5ohaanAM9
	veHKDsx3ZOnsyW2V/+aBR9G/Y1SGWz24Tv7KvWmsPt8p4GORTJB0oHktohjR7Z1MnUCusjuWbkuYn
	MGTRDgJQ+xZWwgzh4rJ1O+vFXf564efpRh/HOq0YZiiH6kHYxIABUusbolD3azapkziAnrVx2/dXY
	KboJcKuC4N08JqIjCzHahTrThmMXu+TrRqSQsKx8QWMdjy8qQkAIAY2YD8lHQ4v+k7M4vfUmyEW1r
	F0simKYg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waHLS-0000000Etdk-2he3;
	Thu, 18 Jun 2026 18:20:06 +0000
Date: Thu, 18 Jun 2026 19:20:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pranjal Shrivastava <praan@google.com>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <ajQ21kH1ZVajS2Y7@casper.infradead.org>
References: <20260616134000.2733403-1-praan@google.com>
 <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajP8ZTTLYkICFTO_@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16F4640010
X-Stat-Signature: neycx4gwrgz3mey4smfuyx6wsy7sjjhu
X-HE-Tag: 1781806809-947356
X-HE-Meta: U2FsdGVkX18LU+pXZMFRSQL21n6mXhEwroKSpCg+/Vq0RfNKtenw4MqU8cnzfH3SgwIPkRi954tCXmYlQNwfy7Xa9BwEcwcaqNAxYez9POvUPpHbxYhmKiP56cWsvYTXEgXPwbbYyOg2rY2DVRqbv8CVYjLu50zzKNOlxnDc0yd7sXhdChgM5euipSVu5nHVmcFpnDFYOBDj7ZVVmjIFZ5xBtjIIPnk8MvOdQ6QcK2m5CsM0O+iN6XKbM/b7MJlusGpE+KJTrVCWHqAATQgxrfcG/UaK0tGookCACcNcSKGaR5ILRsB+wseaT5epKDlCQ5v1OBFhazRKBU8zsR6yEpbg4dCdwKWWUOD8IEGFCUE98eIw9Y+hDHvGHjNeyVZsVK4Scz3Rjz+t5gKq2B2AUNOTn6wZ8xfcYoqJDfadm2t/aGHAhpJhf5KcS5tlC5M+tx2g3/5rUfGCm89kh6WADX+VOf8Fe4JTIxEqi8To9Cjj2WWNj1ayhDQoeSGYrF+SXbCzr4AWAXTzv5n5SDnHtNYw2gF4p9hj6TcnSH1/Dr3uX4/G7A6qJQHh+mJxCDX1KR3ZgDlRRX+e8A2qFQE1kRGzZ1r7f/+7hiqoDR7JOMyrGF7aLsWatWnAigPwhpCFlpIz6S6Z25gZS7B9/YBS2utFyd39O8qJPR+x12KE4MdJsM6YTeXn7BelAKHo9PAwT2lSnDwGzZTxU9wkolgY2VTEc+sHlC0oFWna4FnKwshKWtu8XJ1E7nWbkOpvO/vByBSCNL+yEZN+1WAYZaF+2lI2/EmxLHQq+LHWuWlL8olnW2WoVhnCoBc3D/EhctHzmfPPEgpijQPt4tjUR3uinV4FVw80MgESNom9BaaXV1jDZNL69aRBmVKRj7Mxqz5Oe0gZra+pLSmsFNHlNyTwE8WammMvJ4NJP5sOlcKBJROpOjW1dFiz9c5XgZg5QuCF/fNjtHSeiQnitAjr7on
 qtJty+pY
 il4UgDuaBOUN68JQ7/Rq3/IDRmS9Ve8lGgaHZCXabKchohE9mUOPug/KNi+5Lh47TfBIToqLYhiuy6MwCIiRAnq7ZvVHNHNIu4qeBp2pyYxwQ7uTqtfhlJsbRSIJsP0V2034A+FYJHo6BU0yg9GIgrYi9ZkSRP3dSqob3sr4sRapMGQNCIff8BrctzP72VQ44bEtjP0ST2WdPm4OZwxIfxzYUxaTy1igD7b8RYlip6ceR9EBwQpsDzqi47Mzr8Gb1MJVe1+lcwfdLsGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 07:10:45AM -0700, Christoph Hellwig wrote:
> On Tue, Jun 16, 2026 at 05:23:48PM +0000, Pranjal Shrivastava wrote:
> > AFAIU, the MM subsystem explicitly ensures that every valid struct page
> > is part of a folio.
> 
> It is definitively not what the vision for the folio is, although if
> I'm not mistaken it actually is still true right now.

It's not true, eg, for slab.  While there's still a struct page there
for slab, there's no refcount and flags like PG_locked have different
meanings.  You'll get into a lot of trouble trying to treat slabs as
folios (and that will include assertions tripping).

> This whole
> area is a minefield unfortunately, and we also ran into it with
> iov_iter_extract_bvecs and the earlier block code it was extracted
> from.  Adding the relevant people and lists, but for now your best
> bet is to stick to what the block code does or even better reuse
> as much as possible of that code.

Yes.  Fundamentally, it is no business of the filesystem what the iov_iter
refers to.  We can do direct io to slab memory, vmalloc memory, memory
that doesn't have a struct page (eg iomem), or whatever we choose.


