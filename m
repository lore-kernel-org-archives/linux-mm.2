Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BAAFCA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DBAE6B008C; Thu,  1 Oct 2026 06:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38BF26B0095; Thu,  1 Oct 2026 06:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25AC86B008C; Thu,  1 Oct 2026 06:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E017D6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:01:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77D75A58F2
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:01:56 +0000 (UTC)
X-FDA: 85273616232.24.47D0375
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 72319140011
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:01:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=VXKIJLxc;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790848914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qhjkz5LGIQ5OQf96jD8ObHxGuARoVZWuTiE3aF/pzBw=;
	b=1amRL33BRXjqeO5O1IYCN6IE5hHop1ayCNgLaP5xkAgDMhllIO8ucEkaRubPQmRmseiyUC
	ClNk1BpREvPbt6tKiCjvmv+LkMqNOfGpiF8uohyuEQMhWjw+UcSJ33HGhNt1z0qw1LZass
	1V5tJ1FCYNjnfLLFlUa2q8QlvYScgyE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=VXKIJLxc;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790848914;
	b=jZUd783fG8zNR1+A/ymGl9CAf2dSFB/qMjJvyFqyjMtzfVMNepKNbHPQOUK1r+KNReKkbG
	SLYrguEtP/pyeHTG3CF/kQen4QP2LzYXyin2M3jpn0RVGTCBuZ4HfHeC+GxQBkfSpTjSTW
	Sw29diaCYQ71Xw8qF9i/cuzG+034f+s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Qhjkz5LGIQ5OQf96jD8ObHxGuARoVZWuTiE3aF/pzBw=;
	t=1790848914; x=1792058514; b=VXKIJLxc5T2tqoNLiZx2TMwJOexQRKXPgoGXBsnfID71TFE
	Qej2l3MRVT41/GubbM6Mpsh7C5w+0VxKSKBYa//tif0xFOYv6XREYlh4Ao2O2V6GMNG0cpaT7QHIY
	UmQkX6hq6tZ6kidWfn5W9OjOrvFxd+cGedPqDh322VEWlonVOdN+VA6Xm1MkboJ2m+DHySrImCnDt
	PSvVaH8N93NbUpK6rN6JRtQ9RVErGTDN7jiHpsiyRWVjeR7fw0/tzUOQzHitQxNeyl6t2ZBGk2Ery
	XfjpwuDYvBKUBZL7JuWlcPNu1NWmhvVcJcEX8lXkO93+2gnJvV0ROXTLGhRK1syw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCDbn-000000001cC-1VvD;
	Thu, 01 Oct 2026 12:01:47 +0200
Message-ID: <94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
From: Johannes Berg <johannes@sipsolutions.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "David Hildenbrand (Arm)"
	 <david@kernel.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
 liam@infradead.org, 	rbm@suse.com, akpm@linux-foundation.org,
 luto@amacapital.net, 	brendan.jackman@linux.dev, liuhangbin@gmail.com,
 corbet@lwn.net, kees@kernel.org, 	broonie@kernel.org, mhocko@suse.com,
 rppt@kernel.org, shuah@kernel.org, 	surenb@google.com, vbabka@kernel.org,
 wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, 
	geert@linux-m68k.org, daniel@thingy.jp
Date: Thu, 01 Oct 2026 12:01:45 +0200
In-Reply-To: <ar4br2vW7yZGd3gt@gremlin>
References: <20260929235711.2287931-1-thehajime@gmail.com>
	 <20260929235711.2287931-2-thehajime@gmail.com>
	 <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org>
	 <ar4br2vW7yZGd3gt@gremlin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspam-User: 
X-Stat-Signature: 98e7zatwn478c69z9bfbphidc1zfiobx
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 72319140011
X-HE-Tag: 1790848914-26455
X-HE-Meta: U2FsdGVkX19tlB/7zgZHMJOSTu2Eo+myA4fGsmaAuuZ2QSNa9/7fxFE+LZavR/RfC+AdVS6VaNsvvQDtfmofkaTvf28QXJyo+X26VrSxEdifekO0tDX9M/tdgFNszMshEBrTH6dtSoizfhwMzmfJoO0F5I0qSgtRN+eFY7B1mzgE7QzVztw7GBi9GvyoovKoE2tnXE7yPNHjUk8lR7kRkzOxjPHq7AdbVkpETyy+kU/5jC0u16UkGHPcBH9KdZaiIX/PgVlq7/it35ZEofsaC0nqcSGyd6fyn7LqrchASBD/nZGp7gj0atjODx7lK5ckKcmrQnTKupctAIdjGN+2CUpAzR7PDner+6AFcIikxrgGje5f3TjT+y/nSceUjysW5CxX4DbaAYPCM/bnMhPQU9Zzwgvfr6Qa74wuZGK75H6eLxkpHfr+oCo7AoC3ZhYw8haNS3XLtoufLGIfvBdPoxoikPgvR5TvQI4Zo/NSGLQ4/OEsAKoak0onD1rnTV92HV8kjitZIHXCNyRMFfJC8yb9hps/7+e1S/z4LBL5xImBOP2/EmQ4FjDPBnTZ5fWEpqyqszLHt6k2hIhdJrdVTVJZUs2Tqszz2zpMtGaWRpqyGY2A3fYJ51tAURYi9nLvWdn6P+fDSgwED8eyl/ol1OY74p0WRoyWEGrZl+WUtsvooEmxpwuQKbCRKKGhDmznwt8HPnS8UfgarVOuasWUtFiHFY+F8AXKlFP50nuS9RdMCCu4DvYE6OwwLKNArKuKLjFnsRBNd3odl4nY+3bhTQsiBQTyptOB2r09C0cwgxB+GuzK7IdeqizNbQAS2V6oUQECNcffTwrWWGUOPVwcQyJgiDJSy1y62igg07CHe8E4gewEgh8wxPuOBCByGLjv/IPedSmaz9Y6H3V/QBHOWcos56ga3PRaquDfhNXqamwTuPeyxyEmWc91vALdJsMBWdsrz1NGYPozzongWKG
 o7uiBTih
 vxW+dti6XXVuQAkOU9xG1uEBNdAJzq1e3CgWHFy1Yt03P87O86YWdrWrb3acGsPYDOkacEfwhwb1tk0lYoNiXI7lhXiieUhpC2PeoLV07WpS/R0QkZf3lm3aKBmu9xyOU+2NRS4ZNnB03IhEpsAedZsx2ZK1I8xzm9IeIN0sKcXtg+g2q4ekhUkXufutIYb0TLRHhVoukKfGJrSXBWDAiWCZ2f1sQ24oE5ClTcZ+PF8FR6PGjC41pkbyRzXe/V8OLYzjv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-01 at 09:42 +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Oct 01, 2026 at 09:08:33AM +0200, David Hildenbrand (Arm) wrote:
> > On 9/30/26 01:57, Hajime Tazaki wrote:
> > > Architectures lacking MMU don't support fork(2) syscall and only
> > > vfork(2) is available with limitations.  Thus, we cannot run kselftes=
t
> > > on nommu architecture as is.
> > >=20
> > > This commit addresses this issue with the following changes:
> > >=20
> > > - on test run stage, avoid calling timeout command when NOMMU=3D1 var=
iable
> > >   added to environmental variable, since timeout command uses fork
> > >   syscall which nommu platform doesn't support.
> > > - describe the difference of nommu tests in the document.
> > >=20
> > > So command line to build/execute tests for nommu should be like below=
:
> > >=20
> > >  $ make ARCH=3Dum NOMMU=3D1 O=3Dbuild kselftest-all TARGETS=3Dnommu
> > >  $ make ARCH=3Dum NOMMU=3D1 O=3Dbuild kselftest-install TARGETS=3Dnom=
mu
> > >  $ NOMMU=3D1 ./build/kselftest/kselftest_install/run_kselftest.sh -p =
\
> > >    -c nommu
> >=20
> > Is there a way we could derive that from the environment in one of thes=
e cases?
>=20
> I thought maybe uname could help but our LLM overlords tell me no.

Hajime originally wanted uname to indicate it, but that caused
regressions elsewhere, so we dropped that commit. I guess we could put
_something_ back?

> It pointed at something though.
>=20
> In fs/proc/meminfo.c:
>=20
> #ifndef CONFIG_MMU
> 	show_val_kb(m, "MmapCopy:       ",
> 		    (unsigned long)atomic_long_read(&mmap_pages_allocated));
> #endif
>=20
> So MmapCopy in /proc/meminfo tells us definitively, weirdly enough.

Hyrum's law and all that, but I guess it's not highly likely to (want
to) change :)

johannes

