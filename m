Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033F9606EFC3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YYbUVaVN
Received: by kanga.kvack.org (Postfix)
	id 209176B02B2; Mon, 19 Oct 2026 11:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9EB6B02B4; Mon, 19 Oct 2026 11:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0466B02B5; Mon, 19 Oct 2026 11:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E27EF6B02B2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:35:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 709C6A0772
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:35:33 +0000 (UTC)
X-FDA: 85339775346.11.56B2497
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9197640002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:35:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YYbUVaVN;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792424131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pctsoJTIi3PIcREBl4WC4IIZ1RXf5gRECxbUB6cpZoM=;
	b=XpvtPwfEEtUxk/vjIFPJawtkB4/cEJWJcBzVkDCofeshAb64cRfpxJkbZ+AUlPEOU032OW
	05v133B9ibhCgvzjOkd4aFg9zpj+RBCJsEsMMTMIbw0IanACatTjCPMxylLQkQaTRn4v/o
	uk33vfbIQemFQbn88AIDfcuMCiVMZ5o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YYbUVaVN;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792424131;
	b=RuyY+vLu/8VHHXkI0c9nziJcb7qtG6GNw5IJV32X9SkVl4tib9Y2RqRJNLblcHoHZ01PVS
	Q2w+cUgwGfAKXXRi9wrx9k70ulwpvH0q1aMSp4uGvMyhx5N9EJH81zhU64cy0eJ76jQzqp
	KXodos7aq05bcd/go8+IQ/F/e+9hjko=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E67960DC6;
	Mon, 19 Oct 2026 15:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5701F0283C;
	Mon, 19 Oct 2026 15:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792424130;
	bh=pctsoJTIi3PIcREBl4WC4IIZ1RXf5gRECxbUB6cpZoM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YYbUVaVNFOS3ikdPPAI0feyllwwC0JAn5J9+vzlGaHw385Cbra4uKCOAehI4fLL8d
	 lHqVkJr9iabcTmrdzSgeBqF6ufaO1VZQSw1fIO7wQjJxWubhEDsZZl+opqfQn0DQtO
	 x5+6ZpH9ghkNIilJ1vs0fiqHzhnyP3e7b78PTCkQ=
Date: Mon, 19 Oct 2026 08:35:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 David Laight <david.laight.linux@gmail.com>, Rik van Riel
 <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@kernel.org, Mike Rapoport
 <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Pedro Falcato
 <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com,
 pbonzini@redhat.com, Tal Zussman <tz2294@columbia.edu>, Matt Fleming
 <matt@readmodwrite.com>, Yosry Ahmed <yosry@kernel.org>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-Id: <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
In-Reply-To: <atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
References: <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
	<20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
	<20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
	<20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
	<20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
	<20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
	<atI_yuCc4BiweBQP@google.com>
	<atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
	<20261018201538.d0957878f378a9821852836f@linux-foundation.org>
	<atXXma5NXxoSWJO0@pcnci.linuxbox.cz>
	<atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9197640002
X-Stat-Signature: khf5bxdsmrkj918aysokm1785gpezb57
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792424131-156187
X-HE-Meta: U2FsdGVkX1/IOuwP+CxrTsUJa36sphtJH2+mvkbs9qBfclP5mwk8tZr2RtEqRX8xV5DIpBw7Km7iPa6pwCsTC6+8KJ+SAZJ7w6HRWLD6sT6cOMHCcr3O1ekl/LlSSgHgIyFcShgT8M2RdiWVNnxF7IIkEsktKW2FM/sEdS8bLXfWHwMd8/fqkRiL+lj2cggbsZTYA0jNl9t7WHJZMUkjfp4AVG4eqmTZwnK1/1soKCssLGsbd0F83qdQLGcbEpXR6VON1VghNQzmrfkaskvNSbZ5q3V2iF07XKTR/1VWK4Lbe1q2ADkhTnuH8KZ14Adej69QPUExA6cVKObyBGQXpfQm4DMKdHTDdsKXsLzd6EZbytIg52YQBgCDhXjQjpnM/DQxRbZi3cAyXRmilqDBXHRhSofA/kgQez42doxyg7HbiKTfhEo5irQC178FqOxXRMj+C9DHTiaiW55vt9NEVLbc0dK159DTueI7f5OwZrhzzUaRpnVvwa0Lp2yPwyWcpGHxCvFsou4rvJfRQ+nD9b2RBMfFV5iZP86AdT4CHdmah3Lh8ex3PuPPgx0RTMcPs6WemMLGuv70afdBaI7SmShNgajbKI+PYx2W8osJ77rBqLU8/EP8U/AOOKJyKfSBHSZmCKKycoeHL9EGVl1o+dP8JXJh+CDsi/JsAZZguY4iUlMoHGVdP7C7uoc8uJkIIQf6jnjOCH1SYWE7ozz6zcWpCECTSIZCVKlvJoxYYAHOs8hG07ML45Kmj8RJZvtviUn4Q5YvAMZfZPg7xZOpI8Qll4s5tJFuWU/fSXbviPXibHh/cq831W+hzUjocyIT43iYYlxiJ9b+VAggHVutQFre1D9Q0sBI8Ds74cqxavK1WjLzW+clZfK78OYiWIMdOO594kMsNK+5klZtydgR1e8NajfPD/mER3tEM7zeX22EmYzpN6giaY0dxELJs0PYXzODw0qzipq4XHf2Uqr
 ckEsZCs3
 Rtyf7cYWnlZyHoB+XaCddiNk2RYhGGuHA3DCjy0lXhcJ1ZJ2UFig9DaL4q8qachJiTXwQjSwOWXGrEA1GS+sdAUh+/hTUK5VFj0hvZL5HMHMMttt+G8OnYhTzeE3ZHBhb4Y9K/Nd0nMxH8B6jfw++EgBo6uEtVjNYOKY7WJaQ9JVkYAUcsjd1yQy3yKLWEFQXrG6L1WmRGntXIiFOAipIqUqwFSkBGeryvAvCWz/Emdx7mcaCz7oNDi22kKKg4M31OeIxhQzoc79PdyT4SWyf3s5HTWF2WfZwhoQsHlSlhcqU4jZa+eeKNPMb2mmYuI5VRXFFVePeeowREaXlxCxeqF8NnTnBXBdJoaQF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 17:22:37 +0200 Nikola Ciprich <nikola.ciprich@linuxbox.cz> wrote:

> > 
> > Sure! And I have more good news: after applying 55780d8a1dcc
> > to 6.18.56, I was able to perform more than 30 migrations without
> > a glitch. After booting back into 6.18.56 without it, both VMs
> > crashed within 2-3 migrations. Furthermore, some memory apparently
> > got corrupted on one of the hosts, since various commands started
> > crashing too:
> > 
> > [  303.466091] traps: systemd-logind[3085] trap invalid opcode ip:7f7b5667e616 sp:7ffe1afdec38 error:0 in libsystemd-shared-252.so[7e616,7f7b5666d000+22e000]
> > [  303.493810] traps: systemd-coredum[11269] trap invalid opcode ip:7fc6bf67f614 sp:7ffc075da958 error:0 in libsystemd-shared-252.so[7f614,7fc6bf66d000+22e000]
> > [  377.528955] traps: systemd[5607] trap invalid opcode ip:7f791447e616 sp:7ffe83e61cf8 error:0 in libsystemd-shared-252.so[7e616,7f791446d000+22e000]
> > [  377.556993] traps: systemd-coredum[12080] trap invalid opcode ip:7f97ce07f614 sp:7ffe28b56a88 error:0 in libsystemd-shared-252.so[7f614,7f97ce06d000+22e000]
> > [ 3746.173043] traps: hostnamectl[45846] trap invalid opcode ip:7fe00cc7f614 sp:7fff89916e48 error:0 in libsystemd-shared-252.so[7f614,7fe00cc6d000+22e000]
> > [ 3746.202305] traps: systemd-coredum[45847] trap invalid opcode ip:7f7fe9e7f614 sp:7ffea227cfa8 error:0 in libsystemd-shared-252.so[7f614,7f7fe9e6d000+22e000]
> > [ 3750.581940] traps: systemctl[45903] trap invalid opcode ip:7fbb8967f614 sp:7fff733e5748 error:0 in libsystemd-shared-252.so[7f614,7fbb8966d000+22e000]
> > [ 3750.612651] traps: systemd-coredum[45904] trap invalid opcode ip:7f90d347f614 sp:7ffdc7f55148 error:0 in libsystemd-shared-252.so[7f614,7f90d346d000+22e000]
> > 
> > I'm not sure if this is of any use, but I collected a vmcore of
> > this state by intentionally crashing the host via /proc/sysrq-trigger.
> > 
> > Anyway, I'll give 55780d8a1dcc some more migration rounds, but it looks
> > promising.
> 
> 500+ migrations back and forth, no issues. I consider this solved and am rolling
> out the patched kernel; I’ll report if anything new turns up.

Great, thanks.

oops, we haven't been cc'ing Yosry.

> Definitely a -stable candidate. Andrew, will you send it to Greg, or shall I?

I volunteer Yosry or Sean ;)

I think 55780d8a1dcc should be repackaged before sending over to the
-stable people.  Its changelog is very wrong: "The bug is benign
though".  Update the changelog to explain that the bug is in fact evil.
Otherwise -stable and further downstream won't understand why we sent
it to them and won't understand the impact.

And that repackaging would be an opportunity to add
Reported-by:/Closes:/Tested-by: you, which is the least we can do to
thank you for all this diligent work!


