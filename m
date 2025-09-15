Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F2CCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE798E001B; Mon, 15 Sep 2025 10:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F8D8E0002; Mon, 15 Sep 2025 10:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC838E001B; Mon, 15 Sep 2025 10:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4128E0002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:12:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E596C067C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:12:38 +0000 (UTC)
X-FDA: 83891675196.01.1503308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D36F3160007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:12:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xu/aNln+";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757945557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xy5GXthPruk62ZFe8cTV3mdpr8J0Bk8I8JUuAq9hXaQ=;
	b=pfY/vNtyht7uC/vEztOLXvae2Ot5GjMva5F43SJd/OCAS5gZkYx+ZQIAvXQjUB48eEs/dT
	KpF/tSEeT3FDwaGIsviXvDfnbB/S962NpYOEEpPpT5DpUYKpcJ2e688fWM1C0c7LC9MJps
	XTmdHRWS1igZBCuP7wCzihN99Vi00gI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xu/aNln+";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757945557; a=rsa-sha256;
	cv=none;
	b=ZwMpmT9BgwjiGHYpSzQGRBW8TsfOZuZz0QG4Mnhs1g88iNTjkvzoOfbN/u7Z8Nm3hec0sW
	5ewID4oc0SPqbTypFEsjeW27HZ3HEWiXNHa8ACNS4TTBrELa7RIfNK+meucS1UrR3fhmP3
	zjnbIULBGosjj3aZPNOV05qGj+Ui+ns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FF3043EAA;
	Mon, 15 Sep 2025 14:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C51C4CEF7;
	Mon, 15 Sep 2025 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757945555;
	bh=7vkrO2WxsSWGdp6lM9Hcz4HCTPOoXFcwzPiEHHmzBQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xu/aNln+imqUsri9j70nV1KvIF4p98dag6M1lNrYGxFUCD6+B9Q9QdE+IbvcpraDj
	 +tvp2RSzHST/mVvGyQn8g8yRaufswSezFjAc4r0HllLrMgfd/7TBLoajKncb+rOgnx
	 yf07xYdO5umarJHmhwO/k1CpW/xc7Regd+H6FDUHfeGUpyQiv7VCYgn3gZfQSlySgg
	 jo9tLBPVco4L9uJ32BP50/ILm8XYr79T7+QRJ+dL7fplFJsRWgRZAlnTz+9afjJrA5
	 3xlojUa5SVh4qtR6CZGxV/bxvIjXFPfqfcTczB+NwgfPFp4F4u0eDokpq/HrcukpXn
	 ggk/7yST2yjAQ==
Date: Mon, 15 Sep 2025 17:12:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <me@yadavpratyush.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <aMgey9qEC_XUejXm@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
 <20250908103528.2179934-2-rppt@kernel.org>
 <mafs0ldmon784.fsf@kernel.org>
 <mafs0ldmnlmq0.fsf@yadavpratyush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0ldmnlmq0.fsf@yadavpratyush.com>
X-Rspamd-Queue-Id: D36F3160007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3bqrccybdkco1xtpd73xffnpu6m3z1zi
X-HE-Tag: 1757945556-134920
X-HE-Meta: U2FsdGVkX1/2q5ISNj4jsDs8TuNH4qJ9zmIfCzjpEG9PSreq0bmImbFzpA2WfHpUhtRPhj482Nl9uJM2/rehSJ1qIgN9sWBtKLVnRRQxgqSOx26ZFHraqZ0hSuEWuBlF7mNG8tNXxsUoMycnTgMQNL2BHHs9zPSY8uwxO2AeR9bFDSrgQ4Cs3My8W2w773Ac+Q8aMCu8foqYGrOjXAxuvnlj2zD+pTVHeaCjyQGn45IQSHP0/efWzJY8aN0o5fnCtu60yM4UI/zfuZbpQSZ/HMp/Sm6+FTBUJvtHcCkM4MMs8akFXC1tuelxUeStVOwDJY7abT3gQfzDNnfahHd5QIjucoIbSwvDJD4hUmine7joXuagHINqaem4iGNHPwFxQ4kNFbN/f+7NVYKrpf1QL+PuMrLFtVYoeW1oyaTJM9p0/VYt532zHyD9eBH2otKn8mwWADaKdYpMY/DTzKFSNSGodLDhwWl5Y5Dwaa2w4+svjX+KDl60gitZyUU+BDs69Fgia2DDhhJt61h74cccL0ailGAnWA8eY8INoSswldIMy0TRD7iErYR3We4xM3Ycx77fq/T+CN2KZvgS7qbhhbDbv3eoPcd9oFdvDHAHbiJhOpEi5kT9brfttkBlds8fHhUE+pYHDBrpWKbH1XAYp166iYRObC+Je2LveN4EG+B5z2UyHmwrRbinWwCI3UX4ju4hyWAE216PHwI83upvPIz1nwV5tE5NF2Ni2Co3LKTPeVYqgH2H80v3CLGe1atXy9fnqYE2Zk6WMduThHn1H/MPELJWIKM3ZP/hZ9Zv4pKxCG5pWslacfFw1c+2+jMxzO9dqXh/Sl5t28HlXd4JcWPH6wIQ8CuTnTYaYjDpZ9p6DqaCnurxs/J5BqJiOhgFoNGQNOAtWaoBwT2g2n3ADsboq4JSNYTcfRMGoZ7TJ1tS4PFZUb5mF5DaWALUvebgvUoSn16Ik5MmkTmd3yJ
 khCx20Jm
 d8+ay7Hr1H24zIR4PqBCTv++WoiOxcpmpxtGZGMjX3CpeGD27U6iEv1BnWiGaATVmo4P1rvn6SZMaAPQZJSL1VZsc2z3Tvq1yocRVbDrTRrixRm4OWIbpA8X+zjQJ9jRibmJ9VI6Tbm3mXbfFrgzPFPa1ccs7mjnIfAwKuk28gOQY3nzQAyAmi9XINmhaWMrWIj8rt+F0D/QJMB+Tp7j27TORpwIsQQorwk5Eu6xxjExJZVhV39E2jZ+c1tugp/OHECVO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:33:27PM +0200, Pratyush Yadav wrote:
> Hi Mike,
> 
> Couple more thoughts.
> 
> On Mon, Sep 08 2025, Pratyush Yadav wrote:
> > On Mon, Sep 08 2025, Mike Rapoport wrote:
> >> +
> >> +	while (chunk) {
> >> +		struct page *page;
> >> +
> >> +		for (int i = 0; i < chunk->hdr.num_elms; i++) {
> >> +			phys_addr_t phys = chunk->phys[i];
> >> +
> >> +			for (int j = 0; j < (1 << order); j++) {
> >> +				page = phys_to_page(phys);
> >> +				kho_restore_page(page, 0);
> >> +				pages[idx++] = page;
> >
> > This can buffer-overflow if the previous kernel was buggy and added too
> > many pages. Perhaps keep check for this?
> 
> Thinking about this a bit more, I think this should check that we found
> _exactly_ chunk->hdr.total_pages pages, and should error out otherwise.
> If too few are found, pages array will contain bogus data, if too many,
> buffer overflow.

Sure, I can add the checks, but it feels superfluous to me.
 
> Also, I am not a fan of using kho_restore_page() directly. I think the
> vmalloc preservation is a layer above core KHO, and it should use the
> public KHO APIs. It really doesn't need to poke into internal APIs. If
> any of the public APIs are insufficient, we should add new ones.
> 
> I don't suppose I'd insist on it, but something to consider since you
> are likely going to do another revision anyway.

I think vmalloc is as basic as folio. At some point we probably converge to 
kho_preserve(void *) that will choose the right internal handler. like
folio, vmalloc, kmalloc etc.

> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

