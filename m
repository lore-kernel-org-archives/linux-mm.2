Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C812FE51EF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 09:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8250D6B0005; Fri, 24 Apr 2026 05:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D5836B008A; Fri, 24 Apr 2026 05:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB966B008C; Fri, 24 Apr 2026 05:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD056B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:11:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFB751A0872
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:11:54 +0000 (UTC)
X-FDA: 84692882148.21.59FDD09
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf29.hostedemail.com (Postfix) with ESMTP id F22EA120007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:11:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=pF0brLID;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777021912; a=rsa-sha256;
	cv=pass;
	b=bdWwd6PrOm8AcD2byWaVrfVuQIcpEsGNWWIpz2a7YteCc56L3RaP20Cjrd5zoI0vV/OEdb
	eIbRvgut1TRsF5inXXYzNYu7SX/OeAKuQ/6B8IJU0dzSiOH43vWT9hvYAP+XB1su6S8AT7
	5DGMqA8ElRk9BCQ1gXg+YIP1rRH118w=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=pF0brLID;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777021912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1S+XNViJsK2dlK5vthdolcetegYkFpsmkuQs+AM+8w=;
	b=eRVRoGSi/vHTI5BvRdRQN8ovyvwtByKBnV5gXhI+TI1sCa+CcYt5KdxNta9KvVWuSWgfmP
	CLNVWIoqYxUPvqtTz/xpwIfehvHYA5d/nOSBbc6T0SUq7LFCORXEvNiXPcrCT3/ZlGNnwl
	ThXJCwclx4krzUOc2JGNhom7YKhhIm8=
ARC-Seal: i=1; a=rsa-sha256; t=1777021896; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=YsWDG2YExA+5ljaUNqt9Rbfa4Ju83XEo4L+C5gcLEAHGIxXTra9trofCM3cDUthQ0+a8XA3PozRQEcdf2g0HadzZCYuR1xHXyJqHnzfYixU4tMSjMKMPc9js6HlSf9fVd50M9hiaNOzGOxtPCqkQnyrR0OhuLiNvHIgpKyHrZz0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1777021896; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=c1S+XNViJsK2dlK5vthdolcetegYkFpsmkuQs+AM+8w=; 
	b=ZcRvbcHq8rjgGejhv+4V2pXyCgmjuCRimln1ra51DGdAEs7h2n5sdDr2BEWxIYmynsTTn3THMt/P3bk2VmCStw152HPXt54mREXjJMueOKJYpeCQdU1Puo6qRUEy5EjKDSaBDdF8xRhBoZBtWURyBqLOIQfDmphNiibDtoVe3Qg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1777021896;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=c1S+XNViJsK2dlK5vthdolcetegYkFpsmkuQs+AM+8w=;
	b=pF0brLIDHe79zIJVPiJd5CYMAU7F2jNWsI+vZwEJl/AZWjXKR5h/MKqpa9R2w6bW
	dNJrZ5AwPZ1VlM6LDDSgqDs3wKYpgL/MKkLoPIyOgc+WUILGrbot77EbJQtUi5d5JEQ
	w6idHLSUDCKVpqBMUBH/tbgPgutUSMf/uROUxUXM=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1777021895533927.8659684351834; Fri, 24 Apr 2026 14:41:35 +0530 (IST)
Received: from  [14.139.128.24] by mail.zoho.in
	with HTTP;Fri, 24 Apr 2026 14:41:35 +0530 (IST)
Date: Fri, 24 Apr 2026 14:41:35 +0530
From: Aditya Sharma <adi.sharma@zohomail.in>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "linux-mm" <linux-mm@kvack.org>, "akpm" <akpm@linux-foundation.org>,
	"ljs" <ljs@kernel.org>, "Liam.Howlett" <Liam.Howlett@oracle.com>,
	"vbabka" <vbabka@kernel.org>, "rppt" <rppt@kernel.org>,
	"surenb" <surenb@google.com>, "mhocko" <mhocko@suse.com>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19dbec24364.4b5b174f164.4542907846511755351@zohomail.in>
In-Reply-To: <9b993dc6-f8a3-4f39-b9e3-3b1da29c8343@kernel.org>
References: <20260423165609.251787-1-adi.sharma@zohomail.in> <9b993dc6-f8a3-4f39-b9e3-3b1da29c8343@kernel.org>
Subject: Re: [PATCH v3] mm/memory: update stale locking comments for fault
 handlers
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Queue-Id: F22EA120007
X-Rspamd-Server: rspam12
X-Stat-Signature: wx9niqckqaornh8j5nqxs74cojassmby
X-Rspam-User: 
X-HE-Tag: 1777021911-216897
X-HE-Meta: U2FsdGVkX184a4Y/fcFNmc+VTdIzjsUDmM+dEOPCImaHBnh4SD8enywL1pABgdpI4SPxQB4ApXjOX03xPwjeZvrF/ZSvl7gcbd4UWvX9OzGYGBoNMqk1ca6O85rDPfhOPhFTsuJ8jIcvsewrvO1nSZVNnJIy9Y5jN9X492XuGDWG/qLsgA3+/R9sCIEnngPF06DlzJ6+qz4rCMhRPsN4Yi6Vi5KVEBUuzj6QN9hqio+LAOimegTdXXmEKqyOg5DdbvR2073o29Od3jtwFQPhMPA6k7tfXIMU9IOwMXPHeZT2kpLUQi11nJg15sQ5KDEe323uSVwKHSfJbNTfgiQwMyWj9V2Gw4keYJdS+HjN2p4SDEZDIh0cT1GuUjPVv6/X5a3zQagvVqAsLF+NQXoOwpX5BwyFZs0aqZg0UD2ZYe+wOfM3ShgiIHqicNvK0Jj2kqWu7NWfeQrPQ4ObYZEfmAh/GDjOqHQYoAbt27UsL9I31juPNxqAcdJEsBPhxpIr8bo8bTKf38qsJmoiHgJhNdXDt7w6FEZZAA1/exU2dLpKfu1Oo4N5VTCA2GqElE4dGaJZm+4z2o2VqaLQOMZ4W0TF0oxOunRmo2Fv+toI2CblEsoN+No06uKDnlj5FjLdZ72ZlbXNKElx2Fjg5gCKuKXavd1zD/fnCIlpXzxrCt8d7g+5d09yCjsZ5N3/OEjkO8aJ9k57WlkW7oOhzx2s8rQUTm9d5l+hob0scL0QFJLfzKuQAEtQowLsdwtw/nlfuLYZX5yu9KcPP8cMI1j7R1J9bT62yZ8WIDP3VXgEEmznhjl/9Ug0jZmu5Di0AElJEqCYSQjXeHbYwDuFiqPK1nl/8mP0EaIjgDaQ/Rf3s99AIWag3cKGshKYHX7CyKbVGNGvS3QdXVYO61kueDKwodSa+dpEsQsmjwjTh6OoSnun0h6FAjWFRKhAisnSDdZVy1dRKoe9cxhcNXgk22I
 JTX05haC
 f2LBWwcFB5zhCUV9K9VRbfhtNVCvQSii88KrDipbjKmV424WhAV01IgPL7BQ5e5rO3EXMkeYEyNQEg+NJJ2ZhAKOuVRBu8wsgWgPXKYquOwljGeSfJqM+PpNr3kvvKzRGVN9joyGtfGO2UbC7E+R5GdcyiEHWAZIfdvk/DqEohOGHgTSWUufyvTkJNRo35yzAuMHyxTXlGdg2ye/ik/01tzCAGPutE2CZhFMfAYOh/QFZ2u8fVNdkZdlnjav33zm+Ylcz3jBIsuQwhFZ6km/3joO7Ny0wAFMPAMJMp6tzT48SqVMdlvUzh7aIqL1m0XYNPySCy9P8uHD+C+IIJU8B0/Gf2uJhn9qQ4nTV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand (Arm) <david@kernel.org>
Date: Fri, 24 Apr 2026 13:37:01 +0530
 > >  /* 
 > > - * We enter with non-exclusive mmap_lock (to exclude vma changes, 
 > > - * but allow concurrent faults), and pte mapped but not yet locked. 
 > > + * We enter with either the VMA lock or the mmap_lock held (see 
 > > + * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked. 
 > >   * We return with pte unmapped and unlocked. 
 > >   * 
 > > - * We return with the mmap_lock locked or unlocked in the same cases 
 > > + * We return with the lock locked or unlocked in the same cases 
 > >   * as does filemap_fault(). 
 >  
 > Maybe phrase the second part similar to the other statements further below: 
 >  
 > "When returning, the lock may have been released in the same cases as done by 
 > filemap_fault()". 

Okay, will do in v4


 > >  /* 
 > > - * The mmap_lock must have been held on entry, and may have been 
 > > - * released depending on flags and vma->vm_ops->fault() return value. 
 > > - * See filemap_fault() and __lock_page_retry(). 
 > > + * Either the VMA lock or the mmap_lock must have been held on entry, 
 >  
 > Do we want to also add a "see .." here? 

Will do in v4

 > In general LGTM! 

Thanks, will send a v4 shortly

Aditya

