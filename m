Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE6ACA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616DD8E000B; Fri,  5 Sep 2025 10:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6F58E0005; Fri,  5 Sep 2025 10:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6108E000B; Fri,  5 Sep 2025 10:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 391C48E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:57:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA7DEB7701
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:57:52 +0000 (UTC)
X-FDA: 83855501184.17.FA894E5
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D1D481C0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:57:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=VswTXrJF;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf21.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757084271; a=rsa-sha256;
	cv=none;
	b=QV53TWgvrrBCaK46MfG5YrScFPPzlZAJR965uuQLo9qWSpX7iooC/VRPGB+/83kKwoDLO9
	ZsXs1+OJh2P8AsgiaTwXM4b7uM2tU0GUyDj1scRXE7H1o9Fjlq8S+B/Sw5ruCMw4adl1Ri
	B6WfbuFd0cAKp5LIAHGoT7R4RlhcmP0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=VswTXrJF;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf21.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757084271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCjd9fq4iumbs8QsFB5jw1T46vIRHXwxOd4TSRtAVMc=;
	b=PbwYMJL1NQagHMjeR5eu1KfIYNUkGry9N4NJL2brb5cl7JOnChIniUkDxe7HOfgh6w3yvT
	I26ECpTXUthJtU7+VL26eBXqW5qWOKwsMQwtBI6qY1B/YmRaZIyPsGGG24EIyIlI2gHx3T
	FM/t/N/c7VskVP2zld5Jdb/mRmQu2x8=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4cJKG21jHhz9tPW;
	Fri,  5 Sep 2025 16:57:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1757084266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FCjd9fq4iumbs8QsFB5jw1T46vIRHXwxOd4TSRtAVMc=;
	b=VswTXrJFVf3wRI7VVhbsbNn6Q6DYMdzl2Ffz06eHxQw9bXNzHiY/jbBNh+bta8vTs21IPu
	wRt2vmH/wa2qwkWbu+t4kcm3vdStLphRNEDp0CDSlkTw4qapRB2abtrfVpCI+PssbrDps/
	QhPFQ436JAFs55fZx0Ni2AYu3JnvRUWHydY2KBW7yGYpONIcdVATSA4IRuvaul2Hcuv5nR
	N7V5hDd1lvz9/di66IleyV7fMFqsAyEXQEoxDuaWQ6cY8hfaW8fhmrQnsa0z5Vj4Bgmdgo
	Hr8YYq4bu/MuxGmpKOsb67clLfJaExMEnxPU81dSe42T+KJcOXqoDfRvaImWYQ==
Date: Fri, 5 Sep 2025 16:57:40 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>, 
	Kiryl Shutsemau <kas@kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Message-ID: <hfljftvow5dzmkfgh3cjuqmngnmg65o4r4mpp5u34zoixwmdl5@ohnv6bbqavyu>
References: <20250905131352.88069-1-kernel@pankajraghav.com>
 <aLrrQDCBzaMwwmA-@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLrrQDCBzaMwwmA-@casper.infradead.org>
X-Rspamd-Queue-Id: D1D481C0008
X-Stat-Signature: 6pd1fxyu6dkpytkz3jykmfhsqagnxzox
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757084270-143070
X-HE-Meta: U2FsdGVkX1/359erSWEqIcIuwVGOY/unoAjqed1vPoqkLYCPgP3+FMumx/gG/ox7qPNmzqtOWWwkwenHEZCfozsM3SbaIVQA8piNRpI57UrEfipRNfEzCQbOCacK9KVjShFt+CxmbRRlIEAaEPAloWCuxhsf+CihTGo0ofKK9bGjL+YfBSOHuJaZa4+J7EPGp/s/nObar/gtY6dHbI53N9503aWOC6n/AeL0JUC0pwzyyQLx9myLNlAFSVFQQWzVgUv2AbsAAcN4XBAngltY9Rf0rs/pIOXw9Q+UYqqxoQL5gsKGmB+DoljK8YyOs1MaXanQ+pKsNiTYXTssf8EBW4i1rreMMQNcr0DNIGdChSJiezEyOEz7NfPCQV7uZVSke4vz6sKRf7OsRlhvb0mkirUWYsMhpOp0HkpNtwzvCAV039tkPxc8vkzIJcGq3ssguDCss+3SJw5lqiP+Cje+N4mbVY/M074YLz3qnfCG/id40wCZinhQdk1Y3SeA0z8FcucKVjHvic041+L7BMojW1kXoDRqnyZdc/dKw9j7+hDmRefY6GSNu+T0LgtsNv/z2qdw2hl0/AnybWU2vJ1D/Ol6TSA9vp0bDeJs2j77dZ3h0+U2NGwGOirrCjlSYp3lMxJCM3JXpaty+ITA02bvsDaK64iGB9I0mWjkr95KqSsi/iwgpN2h36HZuYnidlA5sqe0YNy/1Wmr36fF+g1AF1cjgwMhDU9GnHP1CU/3xuWNyRo//ZK0ncBlRAgyHOKWlVjOGnTLsPG7LLda2nKOZuD/8PR423EGGjXFnDJt6cyd9WM93n24Wi8iazaWHUsEQdrsZGY5qMgv6w39Oh8YNxthnANTa+vAB5s15QKTjwqnm1Jiz5YdYZysDv529oFI11nr7M13U5sgwSNoic20cDUY+5ySLXGQ4QTuEVUDlzTc+AxZEUS5306C6zT/NgH+1r9YIhdFpftjFW3HaN3
 QG0vjT7f
 Tiyhg2KJw5GM2Wqxi/7alWjPZep79/Ra6tXs0KVrY8m9gnn5H/XkhmjdORCZs+IWDIlzCDljmyWfzNjdsKdNuEz2OB9hiAsGlbSoXVOJ/Pw7tSVjqIVqFUEnCsvz3KmU3KpYEN4z+CQgKvEgCEDt1CIHBpd8qpL4zrdTzFOnFdyqv+cTnY6CX9q6XQUWNJKpZN1zh/GOJgPuNbWYlNfgkUeu7mScgDQ3RQn5YhUox1OV6uVQTdQI3UMtFXl1PQ+l+4QLB//4sdYtWgWhDyzxgSFbjlan8CskyIQ7ZCABIPOUvaOCELXHvdrmihHTFgLqe9pYw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 02:53:04PM +0100, Matthew Wilcox wrote:
> On Fri, Sep 05, 2025 at 03:13:52PM +0200, Pankaj Raghav (Samsung) wrote:
> > Changes since v2:
> >   - use page_folio(page) directly in VM_WARN_ON_ONCE_FOLIO
> 
> ... why not use VM_WARN_ON_ONCE_PAGE?
No idea how I missed that!

--
Pankaj

