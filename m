Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA5DCCA472
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 13:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D570E8E0007; Wed,  8 Oct 2025 09:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F058E0002; Wed,  8 Oct 2025 09:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C5C8E0007; Wed,  8 Oct 2025 09:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B65898E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:40:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52DBCBA23E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:40:37 +0000 (UTC)
X-FDA: 83975056914.23.5BFCA34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5444040016
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:40:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GBcbjOBR
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759930835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSR+OAicaMJG7hAOQdZGFYmQwq4m25NNDfS7Fm4FF1A=;
	b=dpc7MHazkJzoqc/JfBrFA0y3I/o7+lbNfZmPFGuLCSkJK1M445Idsk6AKnODL73mPhIrg9
	5qvFsgbz8Mr/20YIkw24BcydLWLExH+GDCBhHyT3DT1llVrxY8nftyZNpkUQEC4ldZizPu
	MneBKiwwphj3jR7+fIwl4kU77eJeR7c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GBcbjOBR;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759930835; a=rsa-sha256;
	cv=none;
	b=7jZEAGzSiY5fr6QX14Dx57Ib+VjDg5QU8GN3ss88eH4DuQtoDu3KAA2e/XHKeXvESYRtuF
	6k6Axqf3Sz9FtvYutvUmqKGGFmNZ4ibNzWI1ECwYtHtIz1QgJR+TF01fQZtqoSc1qBMUKU
	dGtu9QvY9OGGvepKKCDR43/FfthSTkM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lSR+OAicaMJG7hAOQdZGFYmQwq4m25NNDfS7Fm4FF1A=; b=GBcbjOBRjpqcrTolR56nJh8rzY
	yWqLurKTHGY7dnX/f1klPuUKfN3G7Al+8qWBSQwWjwhFFtCYwTapWKcfGEtEjS0GkF8HwFxg1F+hD
	HNYiwuvhwlOG98YBjchx/OCD/xFUWhMKltbqtP7rqbIgS+eavY+zM6E13GqkaiG5eDTvuII2B7uVg
	DznQMKemRqpDeWyUVu4qtobekFIItRHUANiz4OGms8xyeG4kl4aaAwWAGzhtJqdlwVukcFlmtVAtJ
	2yTGjOX8w73JyzRF6ijRJ4d1u7e+wCmvDRvV5l75uwkGJPtNbAEX0FjJ6pP0EkQyTatslFQG1o5Ki
	kiwvdtPA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v6UOv-000000064WR-2h34;
	Wed, 08 Oct 2025 13:40:17 +0000
Date: Wed, 8 Oct 2025 14:40:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	rust-for-linux@vger.kernel.org, ojeda@kernel.org,
	alex.gaynor@gmail.com, boqun.feng@gmail.com, gary@garyguo.net,
	bjorn3_gh@protonmail.com, lossin@kernel.org, tmgross@umich.edu,
	dakr@kernel.org, linux-kernel@vger.kernel.org, acourbot@nvidia.com,
	airlied@gmail.com, simona@ffwll.ch,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, corbet@lwn.net, lyude@redhat.com,
	linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] rust: xarray: abstract `xa_alloc`
Message-ID: <aOZpwUD50MwSBycB@casper.infradead.org>
References: <20251008124619.3160-1-work@onurozkan.dev>
 <20251008124619.3160-3-work@onurozkan.dev>
 <aOZhS9nTDnH3Zh7N@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOZhS9nTDnH3Zh7N@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5444040016
X-Stat-Signature: j95ry491synninjo7wsci7bzc8zpq4z7
X-Rspam-User: 
X-HE-Tag: 1759930834-98769
X-HE-Meta: U2FsdGVkX1/1TmwJ0BsyOAVYSsv4OmtjP7lUXutrZu3WH7250Ks/+Cd4siKz5XoHcce9RsOog40SJDVmudaRiRWr8+z3iC+ACSqsU3LMzOJqNcPLx5LXyksLnYkqxkERAGOB/0b9Lkvfwt804qki+6hUzSsvtTwVT1AmWNZ+5b9QyKuG3X6x8skadlboY7xjdkfzGtEAmqrE9wYz/eLrGsKgyFPg9vGFec5UlzR3f+pP3f+QnXz65n7jxo+CRlLPI/gFj/OuDsfun9g0WJce+e5MC3d0WMyhfpVxmtjaXVzKL8sFgRwzHYEVQPClD2V/J8s9L/UR7+//uvy1mdsUN98e2pSZnXG5ucmKBkdn9S2vShgckcWTsivDk/+og54MbGHg6Wpv9jzp8YQPGQbUg6RszLwzXd/kczT8AUetE2awIBsRWoyPrn83pWs2GqqPXD0VnQj7wTQIrhoVg/oWzD9I3wUx08vBDe+2HnS5VuxtOcreppMjU9SfqRhCWkY36AON8FSCZQ8CCKX8wWftrLHMcy9+Sqlyy2ahEFAgcV1WRtram4FJ4/y5fDzGvGqXULku3ln5PldSshADelNXMBgtT32gbLN5QacKwzLqZqRnO7rcMCyOtPdGHSBm9d+X6iF2TOHldY9V4o1dwu1q0xIaW1onY8dnIj81DtkeS6c6HtodbBP2R1uQKalBgdJCS2+lzKOfmSRabxdBOaCbyCBBN2gojRKe/UZz1qowgd9c2XuLMXZM67qqezv2rjvpjZIfT950oEcHCloeM+RfIio2ZIi0bjHrU56W1EdnVwTl9aRLgIKxm9OECdKTrQOqDExVssckZI58eU6aZqfPP4ASqN1J6WwGoRHtXVXvis5f/cjPZBPsAPdhvlFZn86qHUyAR/B0EhVbxEY2SJPsGZuvrywyP6f9rNbpMj5rDTY9n4Ty7eZ7WvOJrHu+7d3aworG/hhNV+wmYt0c/ca
 CPe9uKF4
 s0eqfaLq9SLBToLoDtMCa8/9Z+13KC3pERCcsZ35XueIylzASLBN0yzuqHlp2mhcvOe9j43wxRdzLaF1wJ/6K93Dd68/1SRCQbe4U3b0txtDl++EEMKmpskBrH7F8WNrciAfw09vqFDHueQ+Ih37zeQaeHx+PdDkZNfoC1benhHAk3uoyfa1xwbziFibSOhQrdWtQ4PnNO1NjG1FohfkdIIMCDwbxSsAVtYeckelwtKAOlUflah53jpO7Vpmgc71hzhE5/eSoOjXQGYc58D1joncs99dxZ2UFjzWUw3+7Jd6HM801u7AmB9MGqzj10G42n646
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 01:04:11PM +0000, Alice Ryhl wrote:
> > +        limit: Range<u32>,
> 
> The Range type is inclusive/exclusive but xa_limit is
> inclusive/inclusive. They should match to avoid confusion.

... and xa_limit is inclusive at the top end to be sure that we can
actually allocate 2^32-1.  Or does Range handle that by using 0 to mean
that 2^32-1 is allowed?
> 

