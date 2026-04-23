Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2F3FC0379
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 15:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785746B0088; Thu, 23 Apr 2026 11:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736356B008A; Thu, 23 Apr 2026 11:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C556B008C; Thu, 23 Apr 2026 11:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5301E6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:52:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0316BA02C4
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:52:25 +0000 (UTC)
X-FDA: 84690262692.23.5AC39DD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEA51A0019
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:52:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Hs98Pqfi;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776959544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s7dVmyotR+x5luJkgPqMQsXitkiIGB3igWK6sal+AK8=;
	b=O0eFvEYMBXbQkOy/uLYSpnxI06I3+4jB79dxpJzsgiXxDrGQAj084IZ36msHPZNqevVy2v
	diKtTQRrOVjjkQeC9z7HwjdOs5FbGyFHJ1ocXmO02wPw57ODEirYM84omRjpzK6QRbDYAg
	jfGZGEclvvZ4QP9p7NyuXHRbU7IhRhY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Hs98Pqfi;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776959544; a=rsa-sha256;
	cv=none;
	b=aW6xeoLCpblu6hZTR6TokfAhT0XVxrk/6mQ1Wa03Y12ys64RfZIMgMnmOnC1UbrKXIhKOk
	jzVucDxZX91+bLjPvw/OpIURSUTEwmd/CE2C0auJw73jrbKzpwpex2EaJBPevieHy6Zhc6
	fyGcyFTTDVSfW6pQBQbBNsaUjwUbzeE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=s7dVmyotR+x5luJkgPqMQsXitkiIGB3igWK6sal+AK8=; b=Hs98Pqfi3nbsmN+61Ftj5DgfFv
	5KJZefpJKoR/aKuQALg3271wthU3G3mMaT8vHJSBseqGbu5aK8L5ru17Syl7ErVlgSiNAXJDOiziD
	QLt1lE/Jb1Vh2pzaT3U2h9a3e/FRPshO2HXN8wpZPO2arWiPKJdkTP136PIZPphOSCVq3WZnnw8rW
	rd51LR1yndCL6HWRIDXwEkfNuWSrNjb/0ye64SUWOTr8XJpFgiLM2Q5p10oSGrfn8q2ZbYtLh/LIz
	ppWtb33W4QvN5PMdTQQpqVhIBcu6B28P2lzHvWsCjaSRWSsbTPjtnC7NGPFcx/jw+158jBf5t7rxm
	9Jxg6H8w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFwLk-0000000DgqX-1yo6;
	Thu, 23 Apr 2026 15:52:20 +0000
Date: Thu, 23 Apr 2026 16:52:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
Subject: Large memory allocations at LSF/MM
Message-ID: <aepANOFKoA4jn8NN@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CEA51A0019
X-Stat-Signature: dunx66jon4nzpy3knng1tawycg8eukyd
X-Rspam-User: 
X-HE-Tag: 1776959543-25214
X-HE-Meta: U2FsdGVkX1+ZGvZbLDkzqgRtz+QSx3ziBn/Dg7IUE87tAB6JRtX9fKnifYTeKWrMeRSfYWzcYN5KZB+5C9Vpp3mgi1PWhnu4GCK5Z1PFl1FRMbS7vjQ3ZLzJmgI+T5RDvo4tUKv6VVf5WC6QmFd8r//ozxqVDK8D+bqOW46ulvinQsMUWIjYFakrqhSihMYoF19L4Lua0v5eLB1zXtknji2GctLYp+/MUWWYTucWmZX1Y+cwDidpehvXBKE/0JlIOJeC2nPY7kn7wwbmKDYsFHcQ7Ui9EJ22XqowHiEXZ4Hb0EG4hoQcsD/WTi6CoHMeCSQJXmK0dWi4zV6380qcvLGCfj9AuMmZghEyrplOPhuhHEsHWuyo+A/nTBh+kqDL3wL+opmYWHJxxJ/G50TIoWP4qg464hg9StJzSx/gjvMqO0wHda9tEadRacQQ4aVEahBEn7LUKlHV3eGbzKiSKI8zd8AzFS944aMoWA51VU0SrG9WojHw36nqY3RK5jyPtFr12x3+LJP731Eq1cCdQKVZf3+hjGUtup0L3JhvelmK48faLklbyZHtOU2N2YUotOCvi2M0ns/flDNr8D/J1cFn/za4oyWW6w8ffwL4B8aVw51OAZUVQI3RzPzMyrhUP5Q1DJn6fGk8j/r/Wex9ZLFuz/wdGkXby/jKM/d86yTGsAA2co7auNAo5pZG5tJAIjHx+Kn4464STmKC9LKFPPT20YwkI+vahuQl/aOIzM3l+VP7aGuCy8kZpb9zPIjca2PAMQdooRgjH5SrWljpIU3tHXNpdle2rR/SmDfQCQWq2R5hFFCC0gsX0DvY94zirvQcb1t31A9OV4OVtZ82TWPT/Jy47Xx/aA8rAKs+NiuDFapd/FLEYPzfRF6q0WdWeHIPyBZMzppgvVrbdYBK5WTzKhQOYJGgWhD1LP3K/UIrQxUbQbkeGgdDR8nb/CHKWhv9zZ9EqDtEA8Fs8X4
 4561/wzv
 HNA8RJnQ/7Gz9EiISiDk7Cj0nTafThPEo/wOZqtZjBWF14/Te/SbTCrLVIY4y+T538umIVHP7EyN0zBBcP9cb9Cx65QLmVzCh2qwt6wvfKanVX4HbZwZokA6k0dVskXyai/O8Ry0/DFY+MUpm6F6SBzuXmlyG5EdHb6pHMgECDHrFwpATXRtsHgcy8IPE4irRTb8CxUxEazR5H+qwGE7czMTv6A++1TrCCAjdGetRHz3qVt0eujzTj7VIfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We've had far too many proposals for the MM track this year.  In an
effort to squeeze in as many topics as possible, I've currently
scheduled your three talks into a 1 hour timeslot.  I think there's a
fair amount of overlap between the topics and we probably can get a
decent amount of conversation going here.

If you feel you need the full half hour each, let me know and I'll
try to come up with some other way to squeeze something in.


