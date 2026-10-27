Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE922606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bc71X7f4
Received: by kanga.kvack.org (Postfix)
	id 0434C6B05B0; Mon, 26 Oct 2026 20:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35FB6B05B1; Mon, 26 Oct 2026 20:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24586B05B2; Mon, 26 Oct 2026 20:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C46E56B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:11:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 486911A08A5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:11:50 +0000 (UTC)
X-FDA: 85366477980.25.CF4DC07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9FC14A0003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:11:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bc71X7f4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793059908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1SFQNo+l1KuH2xYEh9agzXyBaFApHyliTW2I3WAcVs=;
	b=mGKLj85JFEL8MAPq6Y2Om5JrcGOwhFjPLfsEb1pYsg4o1nhqH2lyTmEiOUSt+7J7auZ7To
	bQ08Pggj/O9jPwtx7tSFAYVmSQbM4OTbAd81os/Ro6A6w/C+Zilz614C84n/56d+iMm0+I
	v47cPfeVQqLd/Z2YLnUzDEguGdWnQ8U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bc71X7f4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793059908;
	b=fqn0hgNZRNRE0/GvuYmoWSnorr+4cld1enXB1t5wR9uOw86P2/qlGEhqR3ELFAoTFPQJlE
	2I7gZ+RvN6xGYO0a0gR9XKtB4iJVy3cWAphQ7V5IpFIqptVf6Ztu2bY8NymrTrCBZyb1RO
	vIBAdFuAhzxEECSZRRVS7dg/4JIVPUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24E8A600CB;
	Tue, 27 Oct 2026 00:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834D31F01825;
	Tue, 27 Oct 2026 00:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793059907;
	bh=U1SFQNo+l1KuH2xYEh9agzXyBaFApHyliTW2I3WAcVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bc71X7f4rfISVUR0Q+mRib4UDa8SXxUWoc6UT2xY2SO2fApAG1z/OSEaUSnyeo4Br
	 8peydQWyrzSfkCwNYMC0wjL41Y0vFPFhG49//dKT9C7skO2pobu6cL9sgI2IRWlu4o
	 LCLFeRqX9snStGV5ZPsMzuFhV2a4vDFLpw3qQjRgROrukMZhWJk9bl+Vj1m8QapCMg
	 5/imp6wcDRWsxCKqGsmloSl4mypLGVsPfloszOFnwWua1Q0pkxYFo81a0AtaiBXuNo
	 o9q0MVyWgdBSoReJUwKntEURHZH5IqJKa6yRn11hDHMtu4D9d3rlafywHeTkxwFaHR
	 smupkFF+1f5lg==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
Date: Mon, 26 Oct 2026 17:11:39 -0700
Message-ID: <20261027001140.156967-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <72437017a038310cad48a5ff488377a9f8eb89f1.camel@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9FC14A0003
X-Stat-Signature: 4nos8r75jew9qqgnbpqttwx73ye4nek7
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793059908-232877
X-HE-Meta: U2FsdGVkX1/34xLT0GYaoz9p82kgXMt1YV7YdGoPAV3gF/a6MsTOCDVVYIxxuVUO/T+7GC9GcTBNCKDl1YCkhnYzwl7jZL+TAXoD2qFFrfgJz3ZBRcedZ8zgDJ4H6WVGEsb4NLiDPJ9H2ViJff67K6IQ3ypMEfgCru78BLgwoSCttXQ9Jw3LMuVKfpK+oCJGpc4FWkSY65UGAgL8rNYuzEj2Q4Xu3YwKF/r9rWxJBk2KDVANdqxrnvmplO8t+AQJwkX+mgAgnq/mg2HgaxWUt1MR0kx+8/jzZALLYAoSUfptGkViRJZH3HK6rNSZrMds5BfLCAM0KBAI7E4HxoU9h9+c18HLysiMBnokslajLzmMhMZ55QSu4bnswhMvZel9tN/DPWKOKWXv1dZdU8AfCpf0rwxUxtOaw03zIu8rKZv0CtHnJnqhe/CSq7SJaU+dirpfHypbSr/OdqjtADgLSojCRTB/xpeU88FAdtoZMav+Itv6kKBxP9nt/B1968Zsd/5/3hRfJUllb4Yb5Q1cJMWGd5o+hvuYFw35EHjhGr1wQzo2liKjV71YMXs2yV9f8wqHLZ/ykJ4wYpxEG46VsOC0QM4R+bil1qkm1ITIa7s8o79p4PhJFfZVTpe4CmxIM81Dzi8s98WlWmGy9w6OHMmVGZ3bkTc4Dn5WTMCi3aBn6Zfj+rRgtNQIlL9u931eJ2mm0Kii+IZqrd2iKgwolw46vBBmfhO8KsssNkk5U065LNz5Kr7AfN3dOMYG0SPdxt///ULWTgmUCd02lxBcdtZ1Yttrpwgvj/a3MmWbqjMXdT4hgrw9G3gjY8e6R5b7SHIowYOIaTK2BFH/EbIltdko/VvhHV0qh+uEqD1nKl8hJUPPtFWVCGbrU+rVW0zkoYDWpmO8yQxzI66YdRRKveWnB+aVGkdQFc/H3b1HkZVMx2Z6HHt4mgABPtfjsqMw0mGmj4s44hXi13yWus8
 B3+dBmSE
 K3lu43G6EaY8YA1aoNxhK51cBXNIcuGdCezFRvH7Ge9sbUaphnr/4i677lU6ClMHQL9FfxsvYnTtDCLEN1C3yZVfD/vhQ1aobx2oobqEIrcnayhUMdhHKQhkpGHwT+1LCzrsNrAsDLXQrHmFmykivj6QJpNG0DqMLQCoMa9r125DknGhSJVJcSjK5SOCDwS5iPH1sAetO/sNxFmvsKYO26JEVvxR6JyzkkKEtc+RyFVK2oWQmW7SKGkZrQ2IMUsfeDzA58zBndWVoAnsXV9vRhjBwxr3EI72prEniUIk2wOLL5OFmd2I4vjwHyT9DRa0hpPdE4lb5Y52bacyLo2WRnU/New==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 18:51:40 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Hi,
> 
> took me some time to respond because of the procrastinations.

No worry!

> 
> On Sat, 2026-10-17 at 09:27 -0700, SJ Park wrote:
> > On Sat, 17 Oct 2026 11:18:34 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:
> > 
> > > Hi SJ,
> > > 
> > > On Thu, 2026-10-15 at 07:01 -0700, SJ Park wrote:
> > > > On Thu, 15 Oct 2026 10:06:23 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:
> > > > 
> > > > > Fix tenses. Replace 'set as' with 'set to'.
> > > > > Rewrite complex sentences.
> > > > 
> > > > Let's put two sentences in one line, while breaking it for the 75 column limit.
> > > 
> > > Will do.
> > > > 
> > > > [...]
> > > > > @@ -113,8 +113,8 @@ quota_sz
> > > > >  
> > > > >  Limit of size of memory for the reclamation in bytes.
> > > > >  
> > > > > -DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
> > > > > -window (quota_reset_interval_ms) and makes no more than this limit is tried.
> > > > > +DAMON_RECLAIM recordes the amount of memory which it tried to reclaim within a time
> > > > 
> > > > s/recordes/charges/  or s/recordes/records/ ?
> > > 
> > > For me charge is such a weird word exepct in 'charge a battery' or 'charge a fee'. And
> > > 'recordes' is a typo. Does this work:
> > 
> > 'charge' in this sentence is somewhat like 'charge a fee'.  I personally don't
> > feel it is weird.  But 'record' also work for me.
> 
> I will keep 'charge' at the later mention in the file.

Thank you for accepting my humble suggestion.

[...]
> > Sounds good.  But let's finish the discussion about use of the term, 'charge'
> > before posting v2.
> 
> Then I'll head to [v2] and make it a 2 part series.

Looking forward to v2!


Thanks,
SJ

[...]

