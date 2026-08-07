Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E13C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 14:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA21A6B007B; Fri,  7 Aug 2026 10:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53186B0093; Fri,  7 Aug 2026 10:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69C16B0095; Fri,  7 Aug 2026 10:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3B906B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:34:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17EBD801C2
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:34:54 +0000 (UTC)
X-FDA: 85074720108.13.9A5A7E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 77178140007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:34:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYiX7IKU;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786113292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQtOV0NZ3GRZjvi/C5JQ/QIARX7I/ykUdagOLiBrBtE=;
	b=g2si3nrKUolziPB1CI1ALPEzbkOcLnLVLQUdXw83vKAGk9AFDRZanGZ/ChD920LT+8eiII
	FIaKeNq+H+NmehqF3zwXfsFtlzKy5YLhxkz0plIGGRYsno9CHUSbpFj1TqaJ+OhV/y/TPj
	voBIAChuc8uWBQBU0Ojdz0lpEni2Q8I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYiX7IKU;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786113292;
	b=ZhbV4ej6c1YeZw4rrvOYcmKq2/nScSVZu+tTpmavcKZMzANzADHJmglYCWqzF+LA4RJ5Bd
	QsUTFku48kxwyvnvuTc8AYEfczrE4HbMP2xxVn2eEHzoSdBkFmE5wsy/BfYT03JkkjF5HG
	ErsAlgvHmcqF6hZ18XCf07YIKSA2eKI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC0EE4197F;
	Fri,  7 Aug 2026 14:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878891F000E9;
	Fri,  7 Aug 2026 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786113291;
	bh=GQtOV0NZ3GRZjvi/C5JQ/QIARX7I/ykUdagOLiBrBtE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jYiX7IKUNH3jXPSIpchsDzDLTYnFo2eKiA7FjkHTUz4yAJFM/DVt/N7PBtCyx+zKa
	 wsmH5ccVl+8a9WmMEkkxO4pHrgcm0EbLOQQ953Kbk8memDgkI8t7zOB5PiBa2f13qS
	 SvS1tlcbyY9udoYXfdmiDgeM14q3qgpqQ4oHfYlGv7MWmxd5XMEgN/cfenFguFVPig
	 KLCBfXzNErb2INleDqpNCj2KgTzCpJ4+F8q4IJbcJuk93t1a2ZRokM9Xer04eXjH2p
	 zHgKWGdVpTvwR9S0KyArixVa3IHj5pD8LSO+nym8iMVxCb1Gn1O5F07+mq71DR7QQK
	 niyX66kGFR81A==
Date: Fri, 7 Aug 2026 15:34:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org, 
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <anXp--mLLEE2Qo0g@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <anCwUb9lV18v6mfN@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anCwUb9lV18v6mfN@kernel.org>
X-Stat-Signature: x5ntmgrwcjfhnuoudqo4ojqdbsy66m38
X-Rspamd-Queue-Id: 77178140007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786113292-533283
X-HE-Meta: U2FsdGVkX18Tv2JD12DELUqQtnBay+tyI7YtTXdV4GAKw7m8Lyk6sOQi2RYrCIwFullHEy8W0lkw9LcLYX/SwteBiJHtaT9/SZsna0iHT+9TMcqPEKX+OFGNvvKvsg0AZWm4HkDmr228p7oq+4QSn8iTzaxbcPySjivLyo5faDzKo26li7xz7EGc0ukOzzPOBX3E48XwaxMGZdcwgJP/sJLXTxKOzDtF2146CjUCFX5AJtRmVIwWR9cy4tTBv/JgbppQlUDb13kX7o172BP42lrSVSOvJdHGjclZjg9exyp+g6/LPLd0cnJivgne3nN0bUgH2x4nYuQQLmK5AgEaQEHNjgEDU37d1h2xYTS7TfsoiTKVzixpU4UbxVmN4sI7gDfT1T24CpS1dc4FcSRwaSKSXT05hPyPjX1GgsiEQUd4bb2pe43RG5n/yvNNx3r+QFuJ4bjN+BEb11cAjdwyJk4kwqPMurMh7acnMkh9qvueaynBqK7Ciq+yQFECbdIlIiynsZBUm58IeaTJ5KSbaHg8eIXFNo69ErVsKe6kAG+l6BtVX48OPp8j3HJmT5k+Qy6s0ytOUBK7SmfFbCrlNdWWvFOTlOZWDUrqWSHiHGJedLwC/6r17y8XD4YsDx1Z/dUzT5L5LGS9Hyzhn4ZmGqmECdSu3yr5gNnrW4bsRs3gdIF87sWeb7gDwCEmqTz/FyFnlbGYwoBpq5cL4h35BBe4sOFqm34Hz5ArjY6FtIn5uPCTUcaxoybXYoRbJn/NzFyb52GzDHZVjL8/vebi1rH4Fhh0iSFkG86nrnot3uOBlbRLT9qdsmFjd0lINkiIqLKahqKV80jXnSfKJD+FJT8yccVPYjHzZ/W0gaW5Wehb+GVijl3x02M/j5kuiqWFmRbaBp469Ja01NYxY7W78OrgmODKIY1k6O/zTTbeB0GEg4ouollvO7HzPWLMXtMAh0+MSEpAhWYsSCdrO8/
 bdk7yfAz
 68jWziV5SNILVhCSeQkOv6LqZJ/K2xertBSFwumNtamkNlE3/zebRSMZ1PVVPLJDIV6q1r364k9kUgGccD8znOUFBIPzhDpt/Jzvo+7PA9me5hp1kfACVuX6uNPcMh1n3JYMfvLs/VmAlOAkjl3A1hh/YxyKyiGBoy2m4EkOMdJoDVtT2qxe7kgXv0omD0jxIDDdEAIZSCv2YKU6rqQaPCtVMdifAX0hKZeOP9UezMymLwCMubVvnbYv7ADIAvYyCchpQ/5ZbngPSHQPdmfZquNJRwPEFfyu1lVlYJG/CAjL3aWrQmK6HUb3iA9qF/y3BT7Gg7AuFPnUvbAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 06:14:25PM +0300, Mike Rapoport wrote:
> @Dave, @Peter, how do you want to proceed with these?
>

Hi guys, I know as discussed off-list that you are snowed under but there
are bug fixes here that are worth looking at.

I must say I'm a little surprised that the series which came out of the
discussion here has been taken to x86/mm while the actual series hasn't
but there we are :)

The core mm bits my changes rely on have been taken to Linus's tree if that
makes life easier?

In any case - Mike - I think you probably need to respin this on tip
x86/mm anyway?

Maybe worth doing that and seeing if that makes life a little easier for
the x86 folks.

--
Cheers, Lorenzo

