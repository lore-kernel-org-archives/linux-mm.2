Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CECCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5FB48E001A; Mon,  1 Sep 2025 09:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C372A8E0014; Mon,  1 Sep 2025 09:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74A38E001A; Mon,  1 Sep 2025 09:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5CC98E0014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:15:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B2D285FF4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:15:59 +0000 (UTC)
X-FDA: 83840729238.02.C9F5527
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4771B1C000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:15:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rqfjciJf;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756732557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BN0YI0VTrPJW34/bhwOG+9A2ELNV6FGXFNTIOkwwG0=;
	b=57pxl0CVHVtpSTM51Udbs34oi5AJu6HuSnwMqSK/QKYZMP+15ydZ+I92R6VqzAVRZT1PqV
	WbO6pDpk0XqHW5mnZaUgoAHFYPdhlK7F/ou+5lmNDUelErmZvHyDts2J0niISQKp+ehlgq
	1SAcP3cTH+Btlodw6PcSFG7ku8Booi8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rqfjciJf;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756732557; a=rsa-sha256;
	cv=none;
	b=PiJ8FitFlmiveehLE1oFVHtv9s8CyvDouE4UCXt9Bz31biTTHPmp9wjTEEQySoWwCmSd4W
	weH+uDwAqU7m1cnUfB6lajby464NKBdrdIvyrD9TPd+JSCa2wNadNEgyhbDqIKw5fCtEAO
	h9dchXVtE/zNvU/xzTqywDW+uJYaoIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26DBE409D4;
	Mon,  1 Sep 2025 13:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E490C4AF09;
	Mon,  1 Sep 2025 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756732556;
	bh=lbW3NpZ8OMo5vXUuKLW7nyZt3k/KN4KzLKs5gPRpd80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rqfjciJfccU1D1ZON4qOg99kMBRfc+vamtPwzv58LXNYrMImE77fIglM0Dxhplsrh
	 D+gHNIRG4LBZV2kHxPTCvtTq7UL8VTjhyaBoVGha9dJqxd2idy4SDBH7e6ERyLLRT2
	 zuFxiJOzBaedX2S9lkWw4A16ZDPwm8jtZkk+WEv+WpOj21U0nWlQIaLbbjbl2fap74
	 WgxWux9mhRyF66dKOper7+TSXeCQ9cwanT9aeOVX7mfHQI1UYOdGN6dIf3NWBescdB
	 it8LAOIXnL9SqK/D5jbayd5b54px7aq3l5hLrRN7Ll+DbSySr17XOe1WN7rE9b3i70
	 a+GONJ6IKRniQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id BB291F4006C;
	Mon,  1 Sep 2025 09:15:54 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 01 Sep 2025 09:15:54 -0400
X-ME-Sender: <xms:ipy1aNMlQM8QTmBk-zWJqi4g7f1d7WwLIvW7BtYarqxQ1bVQODusFw>
    <xme:ipy1aFHDc0JV4RcL9PADZN54oMFRfz_rs5NINo8gN0dSYdWraSYlNRf-A58ANkq5i
    pNbCNSlHBf8fdTbzOo>
X-ME-Received: <xmr:ipy1aDj5IekzhJZDd2PwoPNKdlzlx9Wn3tMcTMFXOgNaiQfgpg_L_WSQYzrj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduledvvdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopeguvghvrdhjrghinh
    esrghrmhdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhi
    ohhnrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprh
    gtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeiiihihsehn
    vhhiughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfigrnhhgsehlihhnuhigrd
    grlhhisggrsggrrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshes
    ohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtg
    hlvgdrtghomh
X-ME-Proxy: <xmx:ipy1aBROrRYmndBY8c9P6MCYv06D1z-6_-xaIEvM93HoAH1mfcl9EQ>
    <xmx:ipy1aL-Jg-uKbWAJ0SZ7WRGmO4xisifTHeQ0dJBjUGUXQXXtULFtcw>
    <xmx:ipy1aHQqkvcML0xmHZJskeQrIdfIQc1EMIDuJ9rPNPtfYSTWjJP4bA>
    <xmx:ipy1aCbPm_I0MFPuepm_yqb9zoRDqNjjXTNG0E8x7ELw3rL-sf_eWA>
    <xmx:ipy1aAS_4F_qwHHmt32tyctlxfJLALBUcDgcMCFyJz0M-j0cjLGOC7yc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Sep 2025 09:15:53 -0400 (EDT)
Date: Mon, 1 Sep 2025 14:15:51 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, 
	willy@infradead.org, hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
Message-ID: <csqlc5ajszg6bybykeezkpcfqlx7nv5ochikrgttzrhqqjaxjv@y2hwbmqu4qfr>
References: <20250901074817.73012-1-dev.jain@arm.com>
 <7towtl2pjubgdil4csn5rg3usbai5xvzz73wqkwj5b5awh2iim@wfvahykzjrlo>
 <9c3a2ecd-ceae-4e87-a6d7-6a7121ab7a15@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c3a2ecd-ceae-4e87-a6d7-6a7121ab7a15@redhat.com>
X-Rspamd-Queue-Id: 4771B1C000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ghs741n7d8wqq1faco14xxsbeueqoq9w
X-HE-Tag: 1756732557-71964
X-HE-Meta: U2FsdGVkX1/21lzgQvWdIxZMHL7cDbfXAfIGbPANC/RCIhFxLuWr1UoQ5y+Jxyoaa4efz/pP3N8akhU3uZFAmZjG559c17Vx3tPN6l9F+wOnAQ/KlDpE+zgsFqjDUV7YoAfLif97XI90AhqzuIMkUbfUCw55Jb++u6/TFpVYpUxvkB3LAsG+sSnuVSxZCWP074BgwaO50eLesqvKhN6JtbiO8Htlf3zcEyAv0aRYQ8qpjljY3ntBlJ7wLbuTAs2AraND4yy4ryOMcVk77OFfoqPkI8xE/snZUKzKGJiqqm3fC9KMTmMxQCWLvTTg4kYfnUnme7cMRJKJ2SkRyiKrRqLILCO4ok6PrdQ/n7pWGACIPXsmTAnWNEND+zJ8uiv+uwmIUJuSsy6HYJ03G3hfTfm0J57KYT034Fc2/2UYuiJsDMxsMWVSSqM7fXHlprmjbLn70XYwlTO4n6SRfyEHGoGzdZ7upfgaOnT19oJGpjbL54g2PSbt8owVrXe2kDJLPVNl6/aOlqIvL3vIXfvFzbPCt14qGwtXAbjeHaxF6Tw/iACOc3zxE0DZhOnhqawqS482IfRfLQ49V20nV6CA8BrdhAB5EwLfiT6z4U/Y4oEzOYB9DXtlFgbJqLerREXkYwkGOjqJc/pF4krRS0ANd+4eR2IkIg8kJI/K2h4dhAtQhQk6S3GQxKAm2xSMwm86MBosNESjn5RDALyTJK6caD8dI0m6qpTJD/4lGBuRW4TSZYoVD+rMhZq0YoAJGWJcITrRTJN2DJ40GYcHelp3z08w3hfltS8Lv9rn8eK1g9bk2CayOVxFrqEz11VhRORQvCwp2krARauGM4E46ydX8w9Gkd9YkO3yRA0YxqkgHcL//FGSWbiT2co4Z7nKWc477zwDDKu4fMkk2nZv6gM8kN3LPWFtmrRDz1kj/VciZ7dan1ZkCtc5szVYMT7FHcBPsliAOPygE1o1EgzjI12
 8rA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 10:32:34AM +0200, David Hildenbrand wrote:
> 
> > > @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> > >   			writable = true;
> > >   	}
> > > -	if (unlikely(!writable)) {
> > > -		result = SCAN_PAGE_RO;
> > > -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
> > > +	if (unlikely(cc->is_khugepaged && !referenced)) {
> > >   		result = SCAN_LACK_REFERENCED_PAGE;
> > >   	} else {
> > >   		result = SCAN_SUCCEED;
> > > @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> > >   		     mmu_notifier_test_young(vma->vm_mm, _address)))
> > >   			referenced++;
> > >   	}
> > > -	if (!writable) {
> > > -		result = SCAN_PAGE_RO;
> > > -	} else if (cc->is_khugepaged &&
> > > +	if (cc->is_khugepaged &&
> > 
> > The only practical use of the writable is gone. The only other usage is
> > tracing which can be dropped to as it is not actionable anymore.
> > 
> > Could you drop writable? Maybe as a separate commit.
> 
> I think we should just do it in the same patch.

Change in trace_mm_collapse_huge_page_isolate() interface doesn't belong
to the same patch in my view.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

