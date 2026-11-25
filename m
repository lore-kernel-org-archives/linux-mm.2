Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D5A606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 20:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=lydh+8Xk
Received: by kanga.kvack.org (Postfix)
	id 7B8356B0ABA; Wed, 25 Nov 2026 15:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742036B0ABB; Wed, 25 Nov 2026 15:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3106B0ABC; Wed, 25 Nov 2026 15:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8ED6B0ABA
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:37:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADFB1C0C04
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:37:09 +0000 (UTC)
X-FDA: 85474800978.03.6BBC646
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf19.hostedemail.com (Postfix) with ESMTP id 98B0D1A0003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:37:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=lydh+8Xk;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf19.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 103.168.172.157) smtp.mailfrom=fthain@linux-m68k.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795639028;
	b=RScriFXuNFNTyRn2mYYst0hpOI/JBJCbm5e9Z4uyc7gDJ27wb1OSdwl65/wF+P7g1TEhfi
	WqXEJaDIzP6kNc0OKnxoWvMyMizEAlEGxvZ7gOmAdm+DCmoEJxP5hrhGNF8eVP7X0g7nxn
	dazEzqkTlUknKxPbrX/KEPylHLLBPPQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795639027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqJ6XZKGRtlH/8E+zhGGZaWzpzwDBPjUVdzg/9BKOAk=;
	b=pJLd5iMvwlA+nfKeP2Pwu3xcmQhoOvNtwx2cr3V4f9em0G3dPTSDGOslrPMGTT1nqssgwU
	nxbLflMvQCIEyh335SX/gMLg7mESShK97wF26U13qkFSvEcbgvspBRFW8kqRpE797oVOMs
	KE3ms2OEIcw4hpaT+8/ZpBmuBAo4qF8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=lydh+8Xk;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf19.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 103.168.172.157) smtp.mailfrom=fthain@linux-m68k.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 54F6D140033D;
	Wed, 25 Nov 2026 15:37:06 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Nov 2026 15:37:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795639026; x=1795725426; bh=eqJ6XZKGRtlH/8E+zhGGZaWzpzwDBPjUVdz
	g/9BKOAk=; b=lydh+8Xk0MGqTZ/BJX2Z6Cs2IK3aS3rdIFEUFPRJMmrRD/wuVhB
	s1KqtK8dLnflf9nqM6ZBTh+WM6U8miNmsWsHdbIVJGYyPfgjMeR2PhBF3Rps2Rwd
	9H/S7qEUh8Tz8dhUiazLyBVSgp4hdz2/+GOsmstYU8or/sfa5ioig5CM2TTT9pBa
	AKIDPbuxMdh7dG1KITpwJD1nIRqkP4cgeNBTshaP53BuTK4Mtoop29y5voVhobXI
	B3cpsRuYvx8ToPmrPI1uyVWBICwdL9AzLPJaEL8UsrK5QyRaRw2xgFSv1EVuh8u6
	UkXx0NKb30Teyw5jbuL7DOnsGwkKuVl+UVw==
X-ME-Sender: <xms:8UYHa6ig08f3GNJljEQUfAewZu9BfIB5djjvBF8dajcYwXS24ZFAvw>
    <xme:8UYHa3uj_A-_mDvRpKSf-zu_WwedIfdRHaaI4pGLP3NWKL5y2owXRbNA9SwN2vKIJ
    VHDXi-B6VMHBMsG6caUgTOf_ES-MB_PDt7HEnVAz7uaX9o1VfhaRkQV>
X-ME-Received: <xmr:8UYHa18AxKLUpT58y5x4kIieiGlnMc9HT0GmcnacqzrzkvLuquVzBxMD5q5v>
X-ME-Proxy-Cause: dmFkZTE6oC/3NKlSbtcdhhLp6bo7OIaW4366gDdTfMdjm9SykY++SSM/TEWaGAAvy35KMC
    lxAWG9OufPRkcrncDlANxGdF47KxYiNt3+LcLZ1AdVjC7RH+J95hEfatvaWouFhxcisjyC
    41l0S8n7L0LE7Wph1l0Q2S3YU4YHhBRpfYkAz6YOfFXts3zpBRv1j87Y73AlUgrJdxB26H
    7RI605+wYb+fDH6JG29F/k5f6AdtzP66K/QeDXBNSLfIOUC+0Tk7vLbPW3bzgEGJEstx4h
    qG2GkcZkx5+A4ACW8HzP8mU6tIhphjcuf8nTOb0kys6y4vZ0pLugHkrmP1GQKn8pNdm9aI
    GtVyIsu2iZELtCL46Sdmcb8gIj7WfwQJwtRw1hHyEikVO7Q88g8SwxeFzz39iQ8tnc98mL
    N8tlqzt5jyd47t7BKz1eyO/olFKTePXfIYHn6rARmmgmPsyxwukb5axoR3xXWOyTH06SuM
    GW4cmZEHBG5CGQ/DKhq0bLzc7I/L25fe71YwM6IZPZuMXHMYBBl0edjyKNIT98eZyCbefB
    A0AC9BZMC1OBbN5+2hlPII1Niq0o0C4B8LQZtw3lDnLgUazcpau3eQIq1wqhw+VEdEbnK2
    B2dghq2G8sDogFfQzJqfaledsnqYKoFuBTNWS3iraTzpwvkmUy1YBSoSPIgw
X-ME-Proxy: <xmx:8UYHa9Z1I71tZcRG2S1kg-B83JJ4FUuIzud4DGneq4j8Y7nBCSKMOw>
    <xmx:8UYHa7q9tmD5nRcKujQB23nR2oFYITBHF3j-3Q6d4_wp9pY0jNe4XQ>
    <xmx:8UYHa60rPMDgYTXlyTFPhLIwnI8z0Z94CAJ4QMfUcH1mh960w9otUg>
    <xmx:8UYHa7mOwlEa6ebVONYY1-LvPOVpDExs_TTkVz51OrlKAzQuz6R4aA>
    <xmx:8kYHa82sHtck2rdJsn-QlEH_StK340qt5XURJmTLYZkG7kiNfi_TMUKR>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 15:37:03 -0500 (EST)
Date: Thu, 26 Nov 2026 07:36:56 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Bart Van Assche <bvanassche@acm.org>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, 
    kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>, 
    Nilesh Javali <njavali@marvell.com>, 
    GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <cb52daef-8182-1821-60bf-ccb6475b613c@linux-m68k.org>
Message-ID: <8109e47f-b7d7-80a6-6a0c-73613683b495@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org> <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com> <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org> <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
 <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org> <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com> <9120b892-6a31-d161-381b-809191017bdc@linux-m68k.org> <9ada54e5-d80a-4d3c-a491-87e7a99f2ac8@app.fastmail.com>
 <cb52daef-8182-1821-60bf-ccb6475b613c@linux-m68k.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspam-User:
X-Stat-Signature: miztamtuxna9cfbnih8orar96xwace4x
X-Rspamd-Queue-Id: 98B0D1A0003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795639027-670617
X-HE-Meta: U2FsdGVkX18KMU/toukzCOIP9Vdf0rqQ2GIhepbYvZOC0KE9yeCKJdwUHGF+uDVy20E0/89C+DWkg1Ax0pnrg6G3ad/X/IrtLzIwL0yP+XoMDJuSiZM9AGjWzx2wTo85Ll2jpoSEFkfqUaQh04SbVwqHGKcvg09bpDBQyTO6fCR8oRYy7oHVOd6Xo7Y/OR1t8hu3vFSfj3Izycr0YcdT0uqE94qhKGkYWZ8pCQkgPuZ0P04YQqaUfYHtN+Zd+GvFVntF933T6byF8/rIayeNHHhB4w9HxoSbBoSssM3cKv2mWNPba+vGKSN/N4uWeFgTknsxfVlj9t9TfmuQHT0pli8EFemYQcvDZKtGS372K9x/QjS45yqzUDWCL3rfdKySdi9AvSMa2zjIqdFxbB3rsvxxkP/+50bimgnC0X2vEQ0bdvcWvfeQfsQM704akIld7zTejOhkwQ6UqUMiXbwx9GrP+OsJbCUqYBA2FzaMYhYM+kXaHPhCJkhP9fPRfos/kYpEqlKWfbQeXm7vCAhhMi3IBMtZFVjcO1xTpfGqypoYVNiQI/HpUyMRXx4qHEkaf7eUUN3RP1dvf/UZAXeVAHFrbqgJUrXHW5sBAx5ydFKPbpq0yE8LopmmmwGsRpdZmgWVVzZcIdCCMgIiFcN4GTPP6be/wJXJQH3JFKaq2H2uv2JgqbNZMf8b9b1qH6xWlwqYz/lGtoqhnaLisPht1Gzhga4UHGIeqBiAGJi/dWqAAbCIBfsE/i0sB83nO1VX/tEVidq848IYRB0uLKGaqrcY2g1nIEA20aqIYUr5hsZH7lbw0ujkwbdqQZuSMMxIZdoRi9VnVqqMCoboiTq8Wz/ULCW8czmmqfP2kgfBF204xkgRRgo6yaD9DsYG7pwm5pwDTNIHi3Nqm0z0+xWJO31uzkpnyvWxzUia5Gcz2H+Wh80Fdygj9faBxNRqJBL4X913NU/sPic6d8CxNnU
 ztjK9VxW
 +ntgvrdwAu7JaNC3JEeQ0TP5cWG4p25SNgzbVghVtYXDDcTCUO+7YMDVh7s8duGplcDSqvzNhZHaH/RsyYQnDDE8dtnD+Y96SN73J18Q66m9aRbBjiEfqp/eevsSB+L59JKKP+DzkzuGxQq/CxuNfOo+owGaRD8M+rx809WoaSr+VotjPlTbVx0LbWjUWjcFFMrthix9a6qU9VwIctqrPf+aNe58TAvWZd5kwwhEWVjGngKcH7CJjEDnEwkf8Z1asaWutuW6DZ6Gr6lU9rYiVyskQfNqaN/KUVHWWPGV/6snpC8VVjd7vjPhxTLyzrbjRxnNap2uE800lOfstkVp59GVzoA8M6h9rGDJm9WtG+Bu3MPMNMIu7srp9TM3LRdUp3/Cl25ADrTt9EFx08U7lxEGgkYH8dIA/DD3sNzTPILJlb9k2UkUaohClGnLGWjFQtc+TjAMdiP7rxnnIPPjmBFVFD0rLlK0GQ/R6tdiwXiB3LhoF0v0aLfBjIP+EZm8F9JmE1mu6a2hniBpIozxxDMBIx4SYBfoUjretpWHzGzyqyqjJ7L6ylITa/zRRjCfTvl22fZoQKWs0ZvaXAgoffG3/nUS9xQR/DeBSwb/suBaSVNv1HFzHHE2V2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Wed, 25 Nov 2026, I wrote:

> 
> Perhaps there is a way to alter the struct layouts in a portable way (so 
> as to avoid the build failure) but it's simply not worth it.
> 

To be fair, your rework suggestion might have similarly negligible risk to 
my "remove" patch, if you could obtain your desired struct layout without 
altering object code...

> There is no actual bug here, that affects actual users, to justify the 
> churn, or the complexity, or the regression testing effort, or the 
> fruitless discussion to-date.
> 
> If there was a maintainer who cared about this issue, perhaps that would 
> put a different light on it. Maybe.
> 
> As I pointed out in March, there is already a comment in the driver to 
> make the bogus BUILD_BUG_ON() effectively redundant. So, at some point 
> in the future, when I can get interested again, I will re-send the same 
> untested yet risk-free patch that I sent back in March, to remove it.
> 

One reason I'm against reworking this assertion is that it never did what 
it claimed to do, so it's probably worthless.

Also, the kind of bug that could be caught this way could be detected 
using automated testing, so it's probably redundant.

Finally, wouldn't it be better to feed the hardware design to an LLM and 
validate the actual constraint that way? Guessing at all of the ways in 
which actual constraints might be violated (i.e. new struct member in the 
wrong place) seems likely to miss what matters and check what doesn't.

Since the vendor probably won't allow us to see the hardware design, why 
not use the (existing) natural language commentary in the same way, 
instead of translating the comments into assertions or tests?

