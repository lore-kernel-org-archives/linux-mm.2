Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCCCCD8CAE
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071DC6B008C; Tue,  9 Jun 2026 03:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0224A6B0092; Tue,  9 Jun 2026 03:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A856B0093; Tue,  9 Jun 2026 03:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2AAB6B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:28:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A248C1ABE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:28:33 +0000 (UTC)
X-FDA: 84859546506.03.E718371
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2349220004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:28:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Fj3rz0z8;
	spf=none (imf31.hostedemail.com: domain of BATV+083e98ba33f2cf22ed17+8325+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+083e98ba33f2cf22ed17+8325+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780990111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsYD70yDlULNNacQZMULeSKit2kKkOeG2bxsH2JA33s=;
	b=0ULzVO93JKREiRsrchhCYlDrOJuzW4z9EiWYKtABmZs7CZH/MkUlJoV4x1wPuuS8QMGuCG
	fT/dvwp3G+XSgEtWGTYBDJnan87dlSwFRuPmJR4gBdPYHKB0WPYhdNeqQO3aXGRDquIPps
	JcgaSEtzFJvKlScxlYjebBpZz716Kqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780990111;
	b=GYB9X34M/GMXOLYJcgo2VvyQSZOYZOQT10FheYIo63ssPvpgXpoq6ueg6O1l7WCtdrKIMm
	2TdkS2PhFyqyrRQtoxtloLp5Pc2Ay7nnA3WStaHADA32vNluu+CAozuL5+kb685/tv35Ku
	SToS5bDfexDwSXEY6GjDU8nns4vt57I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Fj3rz0z8;
	spf=none (imf31.hostedemail.com: domain of BATV+083e98ba33f2cf22ed17+8325+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+083e98ba33f2cf22ed17+8325+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=GsYD70yDlULNNacQZMULeSKit2kKkOeG2bxsH2JA33s=; b=Fj3rz0z8vRUIINuAVgrep0Zngq
	gDuXLrdoeg3qqCDzjX/AOiVS8Sjymv+yhklZKcMRAKWnB8tS/OunasqODSncPkisaOHAhmnKk4nrs
	yiknhs7XOv0kPWXKnU63Ln1hankeNynkAcZ8SujWHl3sMLj5VQ0VD5VqOtrZ0wHeOLLw05cvFM+p4
	I7Q9IZGdwPS1ehTIEwtWbajr0Ea8oI39eY326H6LuEx9WNsl3MjvRQ9mn1Z01qWSGCReqrjqICLdw
	qF4x8AJpWyc1u+GNTMS2k5COquIDfDahrwlu+rB6o4P8NXT+nRnlRqm80cA/v1jc1jJPh16ThVAVu
	copdZOFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWqst-00000004xsx-3gM8;
	Tue, 09 Jun 2026 07:28:27 +0000
Date: Tue, 9 Jun 2026 00:28:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
Message-ID: <aifAm1rRKF75HVeM@infradead.org>
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 2349220004
X-Rspam-User: 
X-Stat-Signature: 19fjm58mrama4mjuqeuc7j4so3e17et1
X-Rspamd-Server: rspam08
X-HE-Tag: 1780990109-661290
X-HE-Meta: U2FsdGVkX1+HFaGcWCoZRqaRvw3wooq3qfzeehQNtmeXxXGdsps1lWRzpvhpQupmQzNBKEgOzcr3dqyvil7rUEm0DU8meMy0nFn1MAqr4LmoTpYsfGHODBvVk9upmtUbD+CUk2G9+NrT2gXOD9HAKz1NWxPrHgB6UNYZO4/Y1SrW8ozccW+S8dgzzbgK9ASIoWf3/prxkk+w95D/pfOBEE0JgyO6p+EzJYQEYDwP/5b76bxENG2oDDvxTROIM3C2sYemIs+HpC396CQFZtrDw3ouawgY89Q1KDvyXQ6UbX+Cl7OlTQOqRBEAsmALYRjknLEQ2QMRdhgBCPXwhm5gaXmbK1xENHePRAsWE6QZOzg6TsYzzgaWcQE9aG40jCEwMidnFdBeKc2ocXPfpczCwHxk1chRCXKuj7MzK4EKSO+Lw4VCKZR7xNrU/2E5LQWrLY1Hfg9O4npVc5ewpEvQXuAnPeyNYm6LTGENiT93GZjGG0CYDsUSSpZ7lsMH068lKQXlgdMWNfo6FSOW84G9jFfDxNy4i9aXA0g1/TlBQg23fsk/5QklfxWn4zVObQ/O7RLBdJEDao/n0Ta9WYOmQUkoxDeK0pfovIzRR4vS4iXG5c7bHV6bU7Pzjk77K8CpHQf6ahxXX0rpoN7uyCiy+Q3FDijPm1+I3S012E89GSVDifwqopY9pLE05ahRk4q+jBRmh0aQjRzlV3IbX4vSzLjLOZwavmUi91hLcKAducOU+Frka6SBAbRn8SlH6yOpfDe2EVbzCTL7BusF22ieJh7kGBg+6xzGbvyM/AHegB0Chw1Uc4sXtB6mjtI6x+04ToevL1iXXpDGaGghs2hdbHEQOVKfgIY2MHfnwWruKGaw3jYvrz/u3qw4c6BKtyZ86O7LcWvsmpv8i0bH4nFPG1fpFh++xCIN3L0h9O7hC1QA244bF9tN8pSij2Pimxf+prM2tWadalRmdM8+iJ4
 ahwf65N3
 Fod/Gq9ptS3dxzOZJrpFsssg8f9L3qYwSDceeTRSQYJLmsKLzJuHq9VOq5W2SkZZ4JALdeEW1jVqczt1pOWppmsFdOfaKE5qpv23eJHUFti6HPOF9hj4lMKA+2GPbwMEkkh4dDFp+IpJQQEhoiM6ZzuTap1Ligfyo2fIcVpOBa48iTkjivSBW08oVitRH+2OXThVvzr6RxoAQyOm7xDBEVMfytPl8lArFu+PjdPeRC11x3U4NxEJwDNySEQv11HaPg28Wqx5FXawx9PgCPID1qH2hzcH85AQMQwzHp9302rbgvuOaJ7EQTGayIxnU0IvJnwOCnhRvBODVZyNkvsMu/LC8UtYCWVh7nlyPR2/URYnG7OFwredEoRYY1y+zZfmEzfa3xf8cdkm6DpVkSbFOAVFuaowOicx48dFFT9TRKeY7z5M2zBkkuY9znwNjoKcaci13VVgeR/E+xdb/RgbNSpt342PL82JjQwJVdGGqrdB+6h59ORQBI1khEzH3ys8YtjYhKcbOYF1IG6PXYHhDQRuRfAaw57xQgJFEdf4vzLarPel+m6xbO/aZvL50hOpkQo9F7k/28xHDuhaCVr4XbTXaeAWKbXkHgMcz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hannes,

can you share your results on the mailing list?

On Thu, Feb 19, 2026 at 10:54:48AM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> I (together with the Czech Technical University) did some experiments trying
> to measure memory fragmentation with large block sizes.
> Testbed used was an nvme setup talking to a nvmet storage over
> the network.
> 
> Doing so raised some challenges:
> 
> - How do you _generate_ memory fragmentation? The MM subsystem is
>   precisely geared up to avoid it, so you would need to come up
>   with some idea how to defeat it. With the help from Willy I managed
>   to come up with something, but I really would like to discuss
>   what would be the best option here.
> - What is acceptable memory fragmentation? Are we good enough if the
>   measured fragmentation does not grow during the test runs?
> - Do we have better visibility into memory fragmentation other than
>   just reading /proc/buddyinfo?
> 
> And, of course, I would like to present (and discuss) the results
> of the testruns done on 4k, 8k, and 16k blocksizes.
> 
> Not sure if this should be a storage or MM topic; I'll let the
> lsf-pc decide.
> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
> 
> 
---end quoted text---

