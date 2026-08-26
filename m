Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C011DC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 04:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926306B008A; Wed, 26 Aug 2026 00:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6EC6B008C; Wed, 26 Aug 2026 00:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC7C6B0092; Wed, 26 Aug 2026 00:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55DA56B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:42:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96054A33A8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:42:47 +0000 (UTC)
X-FDA: 85142175174.23.4ED1B00
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A740180006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:42:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=eVVT9JXB;
	spf=none (imf06.hostedemail.com: domain of BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787719366;
	b=67nnazWwB2L8tw0SrPRhOU1UwZukG3/j9exD0Tq02YG3z3103GS9VL0Fb0ZxxJsyYCcK70
	exzsQFNq7o9bHnM+qYE+r3Vf7DJuNk1ZqvzE0vdWnjBZwqNH9nnSlZL73dB2YRKhXh+gtx
	HX19DNuf1RrU0uPqQpb/iwp02qf8NR8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=eVVT9JXB;
	spf=none (imf06.hostedemail.com: domain of BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787719366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTnPcAwpdtslp34DtESY4j72LmM8BtuutB92mivhMWo=;
	b=IViPUc6sLI87LTKirx7Xj9yUkCFZAzDcjnbAMpBU+djzdGJCnCAOJ8ax7la7RYOUJriGyz
	fgRDSuyWywdyiqA+187WKyFHPd5+d/G99v3xeHchqHD6zY9R226DEGmzmAyBplK1LHqotF
	7Y/zC+LmLR9Hr+BHMDSbpNhsysC+gKY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CTnPcAwpdtslp34DtESY4j72LmM8BtuutB92mivhMWo=; b=eVVT9JXBdSRKUp6qQxUQLXchhT
	qj8QBK9B962lxL046rXbK1vBJPd+a43Rup6i70SvKU3jCe2CzFYFhbzOrfMU/YOlnVn6D9Ae7XShT
	g5yr7AArmwxZZwFjE8s8Tc8fEj2sZ1F0L7Iek2JSPqKm+TwP5tRnp40I7Ebr7tI7fwNKRGp+UXt3M
	/WVg711wrSU82epSp+572hJp9MEqgvSi5YH+Lg4ryDlY79Vg7ODaspwAP5qnaiNEofm+bphChbVZ5
	UPzj586ray+f9d9JeEDLkS0syJNRvWpuh/khp2uCKGy+s+EQlpG3jVRdCRBWyKxo4vRbXNbtXvY+p
	xtlSodyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wz5T7-00000001tSg-2zds;
	Wed, 26 Aug 2026 04:42:33 +0000
Date: Tue, 25 Aug 2026 21:42:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	usama.arif@linux.dev, hughd@google.com, akpm@linux-foundation.org,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
	liam@infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev,
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com,
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
	kernel-team@meta.com, stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <ao5uudXQVj8JVoG-@infradead.org>
References: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
 <20260820061337.24669-1-lance.yang@linux.dev>
 <aobp2CtWZBlw4w7E@pedro-suse.lan>
 <aob9PF_H6CCJMdkk@thinkstation>
 <aocFPRgqieScf_yo@pedro-suse.lan>
 <ao0vSde26_Qar0IZ@infradead.org>
 <2614286d-19ed-4848-8ce6-59ebecf19d1d@kernel.org>
 <ao1R1Dh-42ALMq7o@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao1R1Dh-42ALMq7o@pedro-suse>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: jg5hpsqpki3t3hard9ubd8cdi73rbxon
X-Rspamd-Queue-Id: 7A740180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1787719365-585247
X-HE-Meta: U2FsdGVkX1+ZIadA5Ef3TY8pgfW3aAf9puh9VjbM4+ELytO5hQcjRMp/jcQur6WS1FLt2phaHBmTg76L7kQxYFvRAvbPK13CEbNgHDU9Vkt3y/CHSc9DG6JrVtRPhrHFLryn90L6x4u/pK2I1rVNnNikxVpPH495oZuOq0pThsu3tJzr7ferg3PfxAxP6SZBx3c2jbpUiBfHmiilVgZzqaQ6LvfRsjOhD74+FKIxteSi9utiEFmzb44ZHCcefKsZKoJrV1Qk3FfVj7hEgYRwr1sIUMFVM2czW59QaR82lfIqWcjQ53K4s3WR7ceHhb7/WIgUhqFyiAuyF2E0clahIp5BtYKBSRwupalxSdKvEj5Fjp30wZaERvS6ylIZ5+tDBk3CSKVN8/+cqdRNfGMlQ2UpQIpEtRPCvy9/ogw3VnJcdakUC+BWJKZqA8rhwQCqgAzML2BNpUFTq20VaOx+ShG1KtWeq152rVLm3BssPx3LlB/jNTU69y1HDCoWy1+4NW3dfWOALvamnPPv5XyZPyG916wYqpvDoFSYHRdf8krS15y9n/seX0oKWqx3xztMIlb8fp5xO5CnJBH6/VqMO6p79ivuRl27DbdVTIxgBLC/DbAXujzETJenNgPxZOpssMphBzLu+g87bK8Ixq++wMNRRm1LaO0FrsuIOfQtNdH2NGVVy2xqyk3mciMwyPSjaqJQm89wHeJzWueEVbBsdVdp/uqOrZHDYh/4NOhvuun4hQVW9B0geKJZaffZ5OXdmVYTOMb7jdVmrXCTvJnh5kvM5qnO3z6cZ1Wg+Z6rJ5rIqV4vcCJnhJoz5ji7pO6MD8JW2wfmLjf1nQmuAy4zJ8luf4+d3TVpLLEO7QMirlS9hNEVNOhmzi2CEKSbLq53WWcpMy/cF4nAXpB78XORvxYgJGna4PSmaySKb4j9IAtekM2zmFqALH4iLPwetU1CjCXeFjy5NExEa24x/xi
 npnuKrFI
 Ag7Izzd5fx8K7KBfS5e+Pf08TZa7Vv94Y7k1DDMxeZBTfpCvLQhP8NqMXQvuniRtrQKnTqkEBfwaClvTZ1RDc4AGi9J4Y1k+HaK2OHabb01N20kOI5MZjuZ4SXGbBIZvFOy/lTViK1be1mJpmTgoGl2qNGKcu2wENbvwItf+2J7dilXcvvFtXNZZqePskJh/S9hO5KK0HOXFzGuHdWAykNMkEpn8i+0DNZdpNMiRJAbJwb0Bly7c6olELtXyv1c9ZoQItet+Fi3tS5OmnSSDCkWRk4bszOLVEV0BytPzBV2BWgA8IBY0jB+YuDGnlrd/l61HUxrF44NMf5q/L4HwMNR9us9EL4Oz/4+md4N8NdwXi603WowCHp9LdVMIjokVTzR5NSr3hisv4EhHhDB3of35CX/lsgR/JrONkKDheYV2cfZ49/wyZMHIupA4TbJ2EGPn9SIbnm9i1PEW+/hlkzSUoPuuJgCnIZjIXs3CSbKOX4+3Laun83hWtUi9+YRQN3nnEe4CgmShJZELZcuVU7dDj/mEwYwRJXU3vThhynHhbFdGXNBxTNLp7MMqvRzaGW5JY7PHtFz832Bg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 09:40:31AM +0100, Pedro Falcato wrote:
> That is true. However, I don't think that should stop us from providing
> reasonable semantics for those that use mmap.
> 
> Fundamentally:
>  - For the common, PTE-level case: we get the granularity for free, the
> filesystem only needs to be notified accordingly.

Where "for free" means that the mapping granularity has to be reduced.

>  - For the less common, PMD-level case: we already aggressively break these
> down on mkwrite faults; I think doing this is the right tradeoff. Screw the TLB
> in that case :)

Puh.

> And, frankly, half of the problem (and related to the GUP thread) is that
> page_mkwrite is a crap interface... Something like ->write_begin() being
> generalised to more than read(2)/write(2) could possibly solve most of these
> issues (or a ranged dirty_folio).

I agree that everything around page fault notifications is a mess.
But ->write_begin is worse, it's not even a proper method but a layering
violation that needs to go away (or rather moved out of address_space
directly into the user of generic_perform_write).


