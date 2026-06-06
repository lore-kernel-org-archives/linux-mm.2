Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31544CD8C88
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 00:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FCA6B0005; Fri,  5 Jun 2026 20:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F76D6B008A; Fri,  5 Jun 2026 20:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134946B008C; Fri,  5 Jun 2026 20:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 034096B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:54:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B247E120342
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:54:43 +0000 (UTC)
X-FDA: 84847667646.18.09FC74C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0187B40002
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:54:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nvLlx+JX;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780707282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bazsBwZAqXEpICcoFUWoIJvMdHrXGA7lTnnh4WSjPGg=;
	b=KGwa1+DDZtyeGwmZGMEE7v+YcdEYqXXAPa4j1z1j9+RQXOyWGW2RUQ5FF6TdJUt3VqTr6q
	fQEp2RjKl3AHqnrTYrHCHp/lmKICrOqwWpiso9FRxHo65C5nmhKgAFemNibe0GgByDJn/l
	8rppWfgIC+Q4vtlie0DyJRnp7c0d63E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nvLlx+JX;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780707282;
	b=YTlLx3ovTJJGwGhipuHgKuRjOTeFqHUpD3YyV4x9XpEd6TZ88/30cDnTVr+YxfdPRJs0UT
	YfAoY646wRrpaRlmV4NnE6X/J+n6RSD9BEOVGfNJXDpJAGoK0+brP5T5hIYNvG1zZ9rI2X
	NKAc1RKG4QTFqp6NjE04h1mWcDGwvYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C592404D8;
	Sat,  6 Jun 2026 00:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160A51F00893;
	Sat,  6 Jun 2026 00:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780707281;
	bh=bazsBwZAqXEpICcoFUWoIJvMdHrXGA7lTnnh4WSjPGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvLlx+JXPMuOfA7Efk8lfmz0Wv93vn7jXgI+HQEq113UtqBFcb/gZip6Qi/Q/of91
	 pJKgdBlQGU8pKabFx7bzsn9GmM8xMqHgs6+BXxZsRPkSTTh9ownIcxYO1fcX8jBTS5
	 HbAF5BBlHwXil7CtDIi37axnnhhE799MEbhqz8bblYIpdb5dNv7dmSI0zMkP88D7q6
	 T+d/Lu+//IrDhyVHDgk+Gd43yYPlPPEghzMSYC/6UOlwD+2Y+USiOL8U5CpcW3QW6f
	 2MCib+KAUEsn8m33Gk5v8Z/1guRrPooOPS6B4lackZR1Vx7fKe0EpFmyOkhxUgccsC
	 P3HANo7QAA8QQ==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Lian <lianux.mm@gmail.com>
Subject: Re: [PATCH] Docs/damon: add TLB flush policy document
Date: Fri,  5 Jun 2026 17:54:31 -0700
Message-ID: <20260606005431.89186-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260605031008.397328-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0187B40002
X-Stat-Signature: qtjs5uhrsbaw86d4azu3uu1zf3zchr6n
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780707281-216938
X-HE-Meta: U2FsdGVkX19PW3L9I1eyl0283dRBupwfYYNc72FbMVdWK9nY7oZB1Adlpb2YQSFqbs2YinnBLzVdSYcwyYxI9sR0KUrZpeOm7QPIYuBy4PQ3eSSu6kxGsCYLK1FYyQJ5pAu4+DePV5/YBncSLSKjX+mOnD6bLHQt8xBy2rzuYMMDjP28DA26IMDIUtJ7VmcRYGVTnVz1B/pbq6y3OqZD36324KsazOGsJtWE/lIo/0WmSe0kQPQOnmytdZBHd+Eu5mfEYgz0KqKlt69HZqJj1c673ChoI0Bm3PpM1XZ8rSoHJrQCsBYg17Lshp6YRbR8eRhLOc5GlG9lZ8QJCt7vxhp6PjOGB9e7cea1MZYaeSOGeIu+bPEV+kTmCGbvsWozx1nya/0Y0l9m5uwwXnxqhut7bM8jPt2R3IV8xAJXgUahsJH4zvYZczebPfM3JJ/VGrlApSf5Z+NQz/shyH09/Pk2kZ06eoqY3icwP5+PWxa+Moak4UHodc7BHwke/JX5kZ9xTT6gnaqsC2j3Lc7JxwlcXk6RvpR3V1Zqx9S2mh2w1J0/heocyPrHZdjyOe7f+ZplDMBoF0UV8HSelDjkuHU0w16Vjlzk/DKqHitRUoFQSVPd9KpnYpB6mWH6iaV282PAvpG4EYDVbYtgCUUAPXZRu0EPv1p4V7yXrcGo9TtizCZnH5xogZj5cvFdNLgwgIjAmbcmmGjWDDzgaDyg0LYVX9tac4a1swrz5Y8yzxVvyKpRYiIfdPsQaISGS81iNMCmIAL4gxkUwht2fFrc4pZGle+3OGIplmJgm7dD7LHT6ExPonr1+1lH/hF5Q6DDgyA93NZJ+lmagZEWoWk4tMA3DfXWltQKXhH0gfQzAwKs0iTBM1c0Ta6AV984oTCQiHE6S0flC1Dvc0CcX+cx3qaxqGM3DpvMfArtmQc6XNA/XEflfE5XItLKx/RGG77g2ruKSZahVDtCsq1+dXO
 h2WtsDpB
 gW4vBkuItBHlG8VZuvddSRb8xyreTs2BXJBZFKyOOLtuAqLCiOR9+H3d5r5nSWX7fX38N3mblUUnAKgUSFupt+R7LX9Pi0tO2aNuv2LioNaIJdPWuhVyrLFYkFCNJMTPtCliLlvEAAg6MVPpgEAtoj0CP10B6MjRkE8eUqAQEKQzeU9BGkMcLGlYOM4Tv2SLuD9/ME6AX9Y/9+WbTxJOdJj7hTcmjMM9aAmhzkBdozJGkf7sUWG5vYwoDynWQzI55i/XmJwIdpIcMurO1nYFbSjpa9qHd68TICod53ObBashVJQ2TIDrHDSC5lHRWQwX2mqfyGcxIsFSIMI4rLtwckMIrk9ZfWgxXICcDkcNdPPGcFdbfFB9IQJmlMbZRKUo8yXpjjFmewTLtYXatqa/mHh9DLYLWnyVCtehumCeueABQPU7IILsRunHQlUBdT+1qio01oQ7CJICcl6FV8VkpCEdPYR7SgjtRjuzIqEu6jYxj6nk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kunwu and Lian,

On Fri,  5 Jun 2026 11:10:08 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> From: Kunwu Chan <kunwu.chan@gmail.com>
> 
> DAMON avoids TLB flushes after clearing PTE Accessed bits for sampling.
> The overhead was measured and found significant [1].  Production
> workloads with large working sets flush TLB buffers naturally, so
> accuracy impact is negligible.
> 
> On systems with large TLB buffers and small test workloads, stale TLB
> entries persist across sampling intervals and produce false negatives.
> This comes up repeatedly on the mailing list and in private inquiries
> [2][3].
> 
> Add a document on the design decision, trade-offs, test environment
> problems, and recommendations.
> 
> Link: https://lore.kernel.org/20200403103059.12762-1-sjpark@amazon.com [1]
> Link: https://lore.kernel.org/20260117020731.226785-3-sj@kernel.org [2]
> Link: https://lore.kernel.org/all/20260526145034.91594-1-sj@kernel.org [3]

Thank you for this great patch!

> 
> Co-developed-by: Wang Lian <lianux.mm@gmail.com>
> Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---
>  Documentation/mm/damon/index.rst     |   1 +
>  Documentation/mm/damon/tlb_flush.rst | 131 +++++++++++++++++++++++++++
>  2 files changed, 132 insertions(+)
>  create mode 100644 Documentation/mm/damon/tlb_flush.rst
> 
> diff --git a/Documentation/mm/damon/index.rst b/Documentation/mm/damon/index.rst
> index 318f6a7bfea4..5e239437dab3 100644
> --- a/Documentation/mm/damon/index.rst
> +++ b/Documentation/mm/damon/index.rst
> @@ -19,6 +19,7 @@ DAMON is a Linux kernel subsystem for efficient :ref:`data access monitoring
>  
>     faq
>     design
> +   tlb_flush
>     api
>     maintainer-profile
>  
> diff --git a/Documentation/mm/damon/tlb_flush.rst b/Documentation/mm/damon/tlb_flush.rst
> new file mode 100644
[...]

Great document!  That said, it feels like a good complete article or a paper,
rather than DAMON documentation that pursue to be short and essential.  I feel
like this fit more to be published in a blog like DAMON project blog [1], or
news site like LWN.  If you'd like to, please feel free to upload a PR or send
patch for DAMON project blog source [2].

Mainly due to the verbosity, as I above mentionedd, I'm not sure if the current
shape of this patch is the best to be merged as is.  I also find the background
part of the document is a kind of duplicate of some information in design.rst.
What about putting only essential information in a condensed way on the
design.rst?

[1] https://damonitor.github.io/site_about
[2] https://github.com/damonitor/damonitor.github.io/tree/master/blog_src


Thanks,
SJ

[...]

