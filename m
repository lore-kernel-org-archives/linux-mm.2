Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB0C606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBRYFQz5
Received: by kanga.kvack.org (Postfix)
	id 9349E6B02F5; Mon, 19 Oct 2026 12:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5826B02F6; Mon, 19 Oct 2026 12:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB4B6B02F7; Mon, 19 Oct 2026 12:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56D706B02F5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:38:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9FB71607C1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:38:46 +0000 (UTC)
X-FDA: 85339934652.11.0AB4968
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E773140007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:38:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QBRYFQz5;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792427925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=782DsQAc3PyqP86rwUshH6wFfstxk+d0IqNd3tGjmLM=;
	b=1OWo5/4RtpJEaR93XeGv4D92Iib2eK2nHUCKIBBCIwFxaO5vaA5mbluIGYoZlA3EkIb1Xw
	1YjSImFJG8GLTNTGV7Gm3Svo9heGHCVfH5qfbTzHh7uJktk1RlUU4bt+Yiz2b/MJJKHX8H
	so1pWiPJp1roJJgto8jj4bQDvUxTE8E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QBRYFQz5;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792427925;
	b=jTg0bD+TJz8p8EQGytI+69YmPr4vKSHhJ/XyPt7oJe8Uy6XfnM7cntPYJGNMeQ3AYlH81q
	ehlvgSfvGZTT15ZpxD30z80xKg4CaJ9vOCULMqvOT9OURfIzcibUQP+1qi1zLKx+k+8dsx
	gfqMz1dCFUP2hxX4egL/2+FVsX3odHQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1026407FC;
	Mon, 19 Oct 2026 16:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1041F000C4;
	Mon, 19 Oct 2026 16:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792427923;
	bh=782DsQAc3PyqP86rwUshH6wFfstxk+d0IqNd3tGjmLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QBRYFQz5RTCmVbvuVbgrR2TdBhZPz21zHiCpfBbQ/2P+18ztTuSIwWEN7fYxYK7Go
	 2r0/1F5w1jdvDFBaJfn2Idama23UR+CceHtAKtV4lhy2qc6XE6yaDx4s223npvokb3
	 ceYc6aYzP8nV1pVgNqT+RCPhpX9Z3jYTUOj/S9ee2rlIBT1MlWAQH2D0RQhTNzhU5L
	 nE+30paIAZr30qyAzEFaiIIsVNhvuC/GjPL9diq/bHKKumMlblrLS2+yfe8ve6qbl1
	 jTbHjnWViWqsQJGDf1hyuA99Ky2aDigW+SDvSSihAfC849JCTGlMaRhiyT7rgSuObU
	 q+vmqhOBgSofA==
Date: Mon, 19 Oct 2026 17:38:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, 
	Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>, 
	David Laight <david.laight.linux@gmail.com>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com, pbonzini@redhat.com, 
	Tal Zussman <tz2294@columbia.edu>, Matt Fleming <matt@readmodwrite.com>, 
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <atZHdYrihStO5iFc@gremlin>
References: <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
 <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
 <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
 <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
 <atI_yuCc4BiweBQP@google.com>
 <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
 <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
 <atXXma5NXxoSWJO0@pcnci.linuxbox.cz>
 <atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
 <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E773140007
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,
	RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6u1cyhumh5yo3bjkmybimsrmwjk6qdc9
X-HE-Tag: 1792427924-944938
X-HE-Meta: U2FsdGVkX1+1MJD29ePTtdORi5lfik5TTxZA5vIW5Af8UJPfzESgHHRWotr7C02H3eVCoiFoWszolFDy7OlFRfgC9k9f8JiqHthtLDMQtmfoY4uC33htTxInqmB85lSsHfzglbpfp3koaUNVydv0tGNY3z+xAzcEJhWlFNnWjmw+v+p59rfx97cUjHi4saz664KhucKQGlHf6RWZGdRBwINFLnHytTPc+v+n8UfX+Mn1CKmTXKx9SuRuULnW509/RfZ9oCEnkH918Im9J6QJQ+fS6QV+V4KTiH/LY58Vvz/RF6wmU1I8LpptFBb77blqJPF/ucDDRPnZk2lDuk7mVjId4S5trxqIRg9r6hk4SFd3eVkwpIPtYRoAL7EL8iPSB9wULNMUXMJU8JNyJcz4AmwEWAcYK6Cm1pnDHiyMUjaiK6w87c2GyuLFaYhnAS9SRDZibcIFxbYMeGT8buIJRN6WhjoTy4wj95upexYeKPZGWo6mQS78fw5KIzlnNLblcqeMK9e4aRxSV0tnxd3VooWv4R33sRhMA52D8hhqjjFrBSYKfq8Je4UO2iKQ6q/TD3VG+aIemrc3wNyqn0pqcDezygONlwckafJYgEwSg8FP8yTrzupKJ7M797TUTpbXGb+mCuh1P+hP85aOFbPZd7VFVz9olio30Ulbg1ztDXV3adqwIRDhJQlECofak1N+TbWm9Ht5L76G7ltqzhZSUfT45arZkEtqEsVfMK++0dwrfLdpcFUY4TVB2n5D5ee1VasaWfVzmFnBlIufCOLcWQ1+2rtXO4BOkCY4HoYGzqWbFhraUArYp0D4fweRGeNiANBmvxFwtjg+RC7a2bWprW0P833kSku/F1NGOx24f4o54z+t1P7wyllxoDwLwkGGw2YgaHI6S2rdVDSkPgmHH/qrtLsyU1HdeLSVl+d+fIvSYdLtqMMAqmo2Grnxv4b648BizcnO4W4K5iaqvCu
 /RtdqzE2
 fiO2y2TWwrrH4n9B5i5b47yTaGDKvgOC07OzxaTsxzee//O0oiQpvRU723ZnlMdBun8ZP9Ew2GX5O5gu64y8UcFDnK2UoCKzFHUz2IZgv1p2a2/tiv/V5q3HbeLiUtGz+M7ufEJa6zYw09ou5t9fwQqJU7Y6ZcR9Q5igGPtnTRL2nFdYvIdUV7Mnq8BbKOtn/udluK9KXT24lfJ9m8bAITuR70SatDDdQAlcXzV2xhAV+HChezpuDZfTn9T3ztk5eu6YB43JA9wP4z8ZukFKFf0Vza+uwQVK9Y6EIcQp15cyh/ow4Rr0ZUyKNOkENRTfuy8c1pKXGrNSARBBujdIoKR7MTxHCgu1mrC+j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 08:35:29AM -0700, Andrew Morton wrote:
> On Mon, 19 Oct 2026 17:22:37 +0200 Nikola Ciprich <nikola.ciprich@linuxbox.cz> wrote:
>
> > >
> > > Sure! And I have more good news: after applying 55780d8a1dcc
> > > to 6.18.56, I was able to perform more than 30 migrations without
> > > a glitch. After booting back into 6.18.56 without it, both VMs
> > > crashed within 2-3 migrations. Furthermore, some memory apparently
> > > got corrupted on one of the hosts, since various commands started
> > > crashing too:
> > >
> > > [  303.466091] traps: systemd-logind[3085] trap invalid opcode ip:7f7b5667e616 sp:7ffe1afdec38 error:0 in libsystemd-shared-252.so[7e616,7f7b5666d000+22e000]
> > > [  303.493810] traps: systemd-coredum[11269] trap invalid opcode ip:7fc6bf67f614 sp:7ffc075da958 error:0 in libsystemd-shared-252.so[7f614,7fc6bf66d000+22e000]
> > > [  377.528955] traps: systemd[5607] trap invalid opcode ip:7f791447e616 sp:7ffe83e61cf8 error:0 in libsystemd-shared-252.so[7e616,7f791446d000+22e000]
> > > [  377.556993] traps: systemd-coredum[12080] trap invalid opcode ip:7f97ce07f614 sp:7ffe28b56a88 error:0 in libsystemd-shared-252.so[7f614,7f97ce06d000+22e000]
> > > [ 3746.173043] traps: hostnamectl[45846] trap invalid opcode ip:7fe00cc7f614 sp:7fff89916e48 error:0 in libsystemd-shared-252.so[7f614,7fe00cc6d000+22e000]
> > > [ 3746.202305] traps: systemd-coredum[45847] trap invalid opcode ip:7f7fe9e7f614 sp:7ffea227cfa8 error:0 in libsystemd-shared-252.so[7f614,7f7fe9e6d000+22e000]
> > > [ 3750.581940] traps: systemctl[45903] trap invalid opcode ip:7fbb8967f614 sp:7fff733e5748 error:0 in libsystemd-shared-252.so[7f614,7fbb8966d000+22e000]
> > > [ 3750.612651] traps: systemd-coredum[45904] trap invalid opcode ip:7f90d347f614 sp:7ffdc7f55148 error:0 in libsystemd-shared-252.so[7f614,7f90d346d000+22e000]
> > >
> > > I'm not sure if this is of any use, but I collected a vmcore of
> > > this state by intentionally crashing the host via /proc/sysrq-trigger.
> > >
> > > Anyway, I'll give 55780d8a1dcc some more migration rounds, but it looks
> > > promising.
> >
> > 500+ migrations back and forth, no issues. I consider this solved and am rolling
> > out the patched kernel; I’ll report if anything new turns up.
>
> Great, thanks.
>
> oops, we haven't been cc'ing Yosry.
>
> > Definitely a -stable candidate. Andrew, will you send it to Greg, or shall I?
>
> I volunteer Yosry or Sean ;)
>
> I think 55780d8a1dcc should be repackaged before sending over to the
> -stable people.  Its changelog is very wrong: "The bug is benign
> though".  Update the changelog to explain that the bug is in fact evil.
> Otherwise -stable and further downstream won't understand why we sent
> it to them and won't understand the impact.
>
> And that repackaging would be an opportunity to add
> Reported-by:/Closes:/Tested-by: you, which is the least we can do to
> thank you for all this diligent work!
>

Very happy to see this tracked down :) thanks to everybody else who got stuck in
after me!

--
Cheers, Lorenzo

