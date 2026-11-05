Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE75606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 23:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bl0/J+OI
Received: by kanga.kvack.org (Postfix)
	id E3E4F6B05B0; Thu,  5 Nov 2026 18:39:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E143B6B05B1; Thu,  5 Nov 2026 18:39:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50FB6B05B2; Thu,  5 Nov 2026 18:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5E286B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1495B80C24
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:39:49 +0000 (UTC)
X-FDA: 85402685298.12.43572B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5716A20002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:39:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="bl0/J+OI";
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793921987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCoKdv5eyx8+bEKQ/D7gBxIEUDff2HqusNXsd9z3Zfw=;
	b=i7vDSs3/iDoKls6RcYh78k1tmg9fAm199mph8g3PkSvzOANtRxD27nK672ADMQ8NkxOD25
	xpEJ0TsXr1Tych28e5szUOmTONyzATKcWPMioeuhD4suTy2qQTfef5pBMGEFkNrOi5xxjb
	JpZPSdrx0OrDlm9YauwNymzyjgnawT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793921987;
	b=tnGSL4v+5BbRrD2kdjS/zKb53GOgpvv5DFfZH0gjGpefHNw7qAWhi5tDCvY/2dFIAkqpVk
	KHtOeOzihbM9CgJebUt3rUtBNR8doW03jtgp7nTXeKtMQ5a0LbqE8eJiKOUmVoFSLyms+Y
	2R2qDHSeJ/4bM6opA6V/aXDwhgYoMnU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="bl0/J+OI";
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98AEC60147;
	Thu,  5 Nov 2026 23:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8051F0089F;
	Thu,  5 Nov 2026 23:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793921986;
	bh=rCoKdv5eyx8+bEKQ/D7gBxIEUDff2HqusNXsd9z3Zfw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bl0/J+OI4ezSk/4AHOsUzY1DM5c6/1998yEWg2PnGHys9rxGEnN38LLVedu7ca1zc
	 m6OFdKe/0gVYUJRUyjaUR2owSy8o7wVgnLtbtYUhrjTy7HpXtGg8GchEbNxi3iGtZW
	 Tcf6rC/GUxnX3T5NkJK/ivmLT4CxHW/7tVxqBL7g=
Date: Thu, 5 Nov 2026 15:39:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Bundschuh <mkbund@amazon.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <jiaqiyan@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/hugetlb: add htlb_dissolve vmstat event
Message-Id: <20261105153945.e4a6415d8d0e8742887e9a86@linux-foundation.org>
In-Reply-To: <20261105191508.1021974-1-mkbund@amazon.com>
References: <20261105191508.1021974-1-mkbund@amazon.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5716A20002
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: m8ny37b9h8o7nkjy86c4nn9jouybjj4z
X-Rspam-User: 
X-HE-Tag: 1793921987-631455
X-HE-Meta: U2FsdGVkX18MwT6clbnb/zck6UBqz5tgFyFIXpxg1alBEVjWUv41QzlkRBOPxz35fKHf4r3u3UK1lwS3lHk5SKckFDJ9qsH1nvTG3hOtfa+i5lnCFn4H+7Zgm1z5rAV+YqOsZJC5bbyZWhssa/FSjjvwV2rz/IARbxNQYb0lOc2cHxXV56jfT4k4ULKYszvTfvA6FwHWKMlGRW8qYPE/2ygkDAbqdDLu6x/iKlC3n2TkZ+95tTL5VnU47eFpQ/pKUR7Pv1L2w/uOC1wPcXtFfahWgnHEaSamMVgUcVuX3os22nSi9XYX2QvWgD8bGQF9oP4LQgv8XgEF9Q4xt2VIZMy00xqybbnMJikzbU8IglrwDGBaef+LSgL0Qh3PCd3pLgNwOVVEfUl2Cd3A9D040R+yDMrdFgIgwn4CdbDehyIsmdU/665DjGphQOqNeU+ieO1/oZ66cpYB5xDqkcAJaAfhyyY/UGfTNP4R7JIX5ByzQYDg23rIKkRR25XlGl0wdUg768LR/ImUvH1SVQhjFuK+uJg/E2c5PfcpOAeRw/8WBXwxAhuR3c3T9uqbRxFMq44OpywQp+jhPu3l10L3WZHHrhEzCG1e5BeIVyQ7tF6MFetQC8rON65R460FhzZpmewCoHiWtFt0UUqaziFi4aiKlSmOUzC70jOEDdw8pA9M1fQ3rUS5/fWxXiAGmZ6IJmkd1YQ27HIFdt3DWtcXxMCOS+NI0pBoakY5xSlGTk2wYwwrjh8lFG4Yyjn1RRARkOhn+LS2qGwoEBxWeLzMQwCqP4fZvj+959lvSYSlwr1C4iWbNJ59EoS9W8LZOd0BwdkqtbAkyYJgvoffP+rnVhWzKbxJTApNn3/5ttyigM0e4jYUcwKsg0qZ84Pq97huYzMhycxnrT3gWvUoguyIY4k5CogpeCkuaI82ByC5wY6OcwCY+HdiikAoZ9tQaH+4Fch+f/Uvylx3eH3TKHf
 0yDNqP4T
 j/P2HhaNrOJRY4a2cRBrEb4lcaHwvxpW131A69PqEi4Q3MR+vAy5mMEhugU27nshvNrzB0i5BT/Uwn/UEARE/4OgogkpVXu8BqMy0SXYY4jqPVn/pXbjvu7GygIy5EWKqxMfJxFgYfY8qeOit9kQVKwBOGSxfmclUcNmQSPxg8/3PRFL0TfigQ7wbMqdNHuH/YbOd5JAwpHyyvz7wSc6UueEKr4PbdPdnPt9KlbYhJHRSxRWh9/qAZAd5Qln6/Qv4VVooSLiEu5BSXZT7S+Ow5VUEi4DxKwYSRQcFCCS/FKTKZ/r9uNYI+TZJYRvZpPct4AGQWlkwvBxMt33x7MVAs+Vbzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026 19:15:08 +0000 Mark Bundschuh <mkbund@amazon.com> wrote:

> Memory offline and memory failure handling dissolve free hugetlb folios
> and lower nr_hugepages. Nothing records this, so when the pool shrinks
> it is hard to tell whether that or a write to nr_hugepages caused it.

Can we please have a much more detailed explanation of the motivation
for this?  I assume it's for the benefit of ops people, but why do they
want this and how will it be used, etc?  y'know, that old use-case
thing.

> Add an htlb_dissolve event, counted for each free folio that
> dissolve_free_hugetlb_folio() takes out of the pool.

I'm wondering why it doesn't account offline and memory-failure
separately but without the above info I'm at a loss!

Thanks.

