Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1E1CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 23:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0846B0005; Sat,  2 May 2026 19:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB81A6B008A; Sat,  2 May 2026 19:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5146B008C; Sat,  2 May 2026 19:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D02CC6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 19:01:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 570808CAD8
	for <linux-mm@kvack.org>; Sat,  2 May 2026 23:01:00 +0000 (UTC)
X-FDA: 84724001880.12.94807C9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id CE17F80010
	for <linux-mm@kvack.org>; Sat,  2 May 2026 23:00:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MAbP9RNQ;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777762858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbQjRQde+bKLJhuMJWLB/NASASENw+79xEXblY67pNo=;
	b=sqRbIswjSoccRp7wZCPQIv1bCfQjlx+Sf4yMlmjjHGfIhaPIJAlO/A4myF9XoVKJbABRx+
	3SgzGx/s7uq7B+E5RoE1FCyR8h8H8uyVgsTA5TyJlBPEakP+bUGEt4bQtQhsDyTfh8zy3I
	qLgA1prHlU0pAlFCZbGskJAGDkZ6mnk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MAbP9RNQ;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777762858; a=rsa-sha256;
	cv=none;
	b=6/krn6R8VRsZzanDCNCuemnfNMH3ai2e/iGAE85DXvBdZ/y2zs/N6AttaiNrrlUqVD8vho
	ZaMCHF4eLy67Ul5xYARgPt6+dzewqwbH0YxnNRkXJ9e27WGbBxzioTwpQeDQUdWGrfTbaR
	bC+gUfzQAB/5j43f+dr3WTn5PP/CHrI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YbQjRQde+bKLJhuMJWLB/NASASENw+79xEXblY67pNo=; b=MAbP9RNQrJif9lV6Xgf0otFK05
	EtWhk3dU04NkNHulHcK79tcwJ6rFENGf4E8tuwOZEYB1dLVS22463scSRS8DaY8QjJfN4rrTIMFCq
	UnPVJgUkQZXQymHeomjQbdbRT/Bsg52+/vUlS+E6M7+BNeon/BYi+nD0O5qw8Y0BUUbh0mSl11IGs
	/IdGiuHRd4b9KxyA4y9CVcgiiagaIsHMgCYBoJ/nhCBJu+ygn29QSjmUhhK9246iS/Aiu+GDSYwxo
	QczMzrMldWN72ItN01ftai46Nq3EQ8+ztgWTmUPT7oAnItI5UJ4ArzcmcIZYZuYaUMh5DycJmgcGX
	0jjhb4BA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wJJKK-0000000GCTO-1GuU;
	Sat, 02 May 2026 23:00:48 +0000
Date: Sun, 3 May 2026 00:00:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache
 Pages
Message-ID: <afaCICnrkTEJN562@casper.infradead.org>
References: <h5ossmwe.ritesh.list@gmail.com>
 <afNV5wbhsFQJLzxi@casper.infradead.org>
 <afYQz3YJdWB2R-1q@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afYQz3YJdWB2R-1q@gourry-fedora-PF4VCD3F>
X-Stat-Signature: abhtay3yrhpotrmwg9mo5zmpmph6si5o
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE17F80010
X-Rspam-User: 
X-HE-Tag: 1777762857-113331
X-HE-Meta: U2FsdGVkX18eMYO1fsk0v3rJYBEOWYC4c/BBdYnmP7JPZgDlxC1ugNLaTArQp1tNwTuMbsAPQinVzyHb93EG1CT0+N6c3pY0fTBkUJRNmRzhrHgz3PIDWeHRURwaenC10H7tDDvmPVF3ak1PNhDuq8l39aE+Ln5sXdJIGXTVN8m1j8m2GFsEyHOJj0zAj7GnAjbCtJG6ojNcUzzb2va8KhUbzYjtTN4hqa2IpSWOv2qKcgMxZhBpsjPhSUypZfVRvcuavicf1mDdjGWVfaJA7mVSDWyT8Ms0ksEDL9guQWmk6zNmCFOCzVCyrmb3TTtIDrZDn8yjWhRVPUoFe35w6jnENBn2Hj/QqaTXT8EDz0QbhXQQrqkwq6cE2czRWEHJCMSl3hfjsej5k43w60p48Zz82WUn7QuIhX6HJIG2XrlSz5Rp9F6zQd/Ds7svv7ZmWRBM+M98T9JnfqRiDvOAzuK4tc4gBQ4nHbxwVC/Qg2SL3Hilm9KXp5o51XtnP40QIo8rtc8UBfC1VOm6cKVMlJ5mWNkANne2xgq2CAvWbNL/QvZXrZUsSRbJirG28yCCgPxUMW781eleTtq0LYbW+kO1f4dO1SFjU9LFNG6f73CnaqF65cBdDnP5PiXNUq+YN7ctQ40sBtuwL3EbRmCSqvmNBcZmYKxg36FeYiZOMVP74Bb6hslEJst6/jLos+YwF38U8rPmmHt8PbmIhPfiFBxkbfAJDwRsHaH25KLlyIFeaoIR0smuipcxR9shd6d0nm0sMqEamaascGARkV/XXYSEkSQiH7vVe3wbSaxH0Ytmd8Hf1dhzGI5WFQ0YXxMMZxu17Rrxgq3mGLA/omVNF7JeMqwOT21aigIZ/pVP0WJk6AS6uHinvZ3v/kLQmeIqcJ7QZk6Du8B6OlFJhgpxwSAl7BgM2pJqogB16m7bHmrm88en5dRZVm7QkpWYjB7pEcuInTdR4vVJ/mi9N2V
 eiiztGzV
 58W7HHNcQuDR1l3o0gzXuM2ofB8aMx67DnZrjYN3Do+RSFdQNNlFx6/lMC+adgOUrSSwgeOXuSyU/Iiy5YuodLPumwpCtw3RH8i8giqhfTospTLjwte9eRjonyrBeUXMARp9lR605KXRs0+Mxg5cDyKB2IVW104c13CyEv3tdB6pDFJCI6YsyZOx2XKdYy/ZXbhcv7YNlEnX7/LGbHBS8HglwqNYuLInd/w4uWx0lZKFfu+wsznGrIgO1RoxaROsWzDKE3wxiKcWeoFxiA8IvdkbQZWpOLAsZFYrU19jGugy1d0cuSpRQDca30NuyiCIskTI3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 02, 2026 at 03:57:19PM +0100, Gregory Price wrote:
> On Thu, Apr 30, 2026 at 02:15:19PM +0100, Matthew Wilcox wrote:
> > Ideally, no, the kernel should observe the task and get it right.
> 
> Out of curiosity, a use case i've been exploring is something like
> 
> fd = open()
> buf = mmap(fd, ...)
> mbind(buf, device_node)
> /* fault file pages directly onto device memory */

Could you be explicit what _kind_ of node you're talking about here?
My initial thought went to something like DAX where the node actually
contains persistent memory and the fd is a reference to some chunk
of that storage.  But I don't think that's what you're referring to.
You might be thinking about a presentation of DRAM over the CXL fabric.
Or you might be thinking about memory presented by a graphics card
(perhaps over CXL, perhaps some other way).  The meaning of "device
memory" has become thoroughly confused (thanks Jerome!) so I sincerely
don't know what you're talking about.

> this obviously breaks if there are concurrent accessors of said file
> with read() (filemap will just fault onto the local node - clear race).
> 
> Do you think there's a world where we can hang a mempolicy off the
> address_space via an fctrl() call with CAP_SYS_NICE?

I don't hate the idea.  Presumably we'd document that it overrides any
mempolicy applied to the process?

