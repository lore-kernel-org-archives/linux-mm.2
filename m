Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA8CCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D23E6B00A7; Mon, 19 Oct 2026 00:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CAB6B00AC; Mon, 19 Oct 2026 00:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044646B00AE; Mon, 19 Oct 2026 00:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D11FB6B00A7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:15:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 530AA1A0187
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:15:17 +0000 (UTC)
X-FDA: 85338061074.18.3164E13
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 421FA100005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:15:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=krQRunRK;
	spf=pass (imf05.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792383315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7h+Wad+pyLNKMyu/1QoznQu9hqJDkJyBcK35tN0uCU=;
	b=EXZDnIEuFCDgOtFHboPxfHKfNbtDFQPLXZ88b3GrgvX9OUuZHSxOClJhmAx//f2kkXIILi
	p2kr8cAJjSnd9B+nY7ATeA3qqITL5MBpk4RvSe0+CLZYnXoj1iTVKFsS4OaG7VF2aFfJkX
	2qYBo8VtkUc57j7PQ+rMImfHr+ZlMTY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=krQRunRK;
	spf=pass (imf05.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792383315;
	b=ppsqccEiJe1fg+PhP/FJwR24o4UDs2qTQ9pLHR1grDjKLKqgCooTrdbpWlgEnehoNXZNTh
	kAy+5rHY6flWYpRiMw8hyMDruxpXZtZHGTE9Nn0yUleZ5WC6fqKejnSnfq1mZkHVMGz9o2
	3hUC/A3p6P9KNDvadFdBD9GsLCt2GLU=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D5B6740E015B;
	Mon, 19 Oct 2026 04:15:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ErKCFo8JYxqO; Mon, 19 Oct 2026 04:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792383308; bh=p7h+Wad+pyLNKMyu/1QoznQu9hqJDkJyBcK35tN0uCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=krQRunRKTqK6d2hTGjOH7yn/uQLDHxmKKlr1aGOby1aaVDc3GQrHaj1IbHWOFlLpQ
	 T0aQX0GmkWvWAFeSOegTniHGVsARBfFAB06fcbjuLrWPhIKC/oAX7Bl601zhD8ndNq
	 ptyxCShUW2IE9OxOjox9vj5EQMH1EUUctJ2JrLryVXfJ2dV6U9hoowGqsxUAxz9nZ7
	 b8/vjju9uRSXpWyG0+CVSObizaWmtlropor31KW9i7tzRE0Z5aZEpEjEOKu4sYvDgX
	 MlHm5C5wZcM+6vPu+wG5g7WynB++k1HYbh8B4mEwhJiTNThdlr0MSohDfmpmAh4gD3
	 iyIu+YfaXIYay+jjre1VSA+hD5Rp5W4+Cf0O1E1baJaIVH4Fh00se5dOdIn/FjZZ8f
	 x9IAGu5v8nRy7U82DAPnJGWcEto1cmy0Y7wrdvheY+mSWJfVs/GWse7sW+GdrOlMP1
	 7ukpv+FOUfYnAl/Twyohy2+MffdW2FXFdcg0WMVznkid71/QccRVzn+MK8mNW1TLiw
	 AicMdVAv7J5PoXdnDUeE0PXklFDbyX+au9v0CfMXAD70lX/nXv7mFSGiQuM0KDy90M
	 9XuIeljxPNEzFtqGVD9zd+gQm/o9UaoecMe/PHoqwnbBVuPeUYOCdfvvvCMIh1un+a
	 1RBQnMXpnN4JqWjZTLBCi1W4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 465DE40E021A;
	Mon, 19 Oct 2026 04:14:23 +0000 (UTC)
Date: Sun, 18 Oct 2026 21:14:20 -0700
From: Borislav Petkov <bp@alien8.de>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kees@kernel.org, rppt@kernel.org, juri.lelli@redhat.com,
	nik.borisov@suse.com, tglx@kernel.org, vschneid@redhat.com,
	kprateek.nayak@amd.com, vincent.guittot@linaro.org,
	jpoimboe@kernel.org, cgroups@vger.kernel.org, tony.luck@intel.com,
	david@kernel.org, mingo@redhat.com, akpm@linux-foundation.org,
	linux-mm@kvack.org, seanjc@google.com, ljs@kernel.org,
	zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com, mhocko@suse.com,
	vinicius.gomes@intel.com, vbabka@kernel.org,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	surenb@google.com, hpa@zytor.com, x86@kernel.org,
	dmatlack@google.com, tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org, pratyush@kernel.org,
	dave.hansen@linux.intel.com, rostedt@goodmis.org,
	gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de,
	graf@amazon.com, linux-edac@vger.kernel.org, liam@infradead.org,
	ridong.chen@linux.dev, blum@kernel.org, longman@redhat.com,
	bsegall@google.com
Subject: Re: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large
 systems
Message-ID: <20261019041420.GCatWZHINJx7DIhXSP@fat_crate.local>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
X-Stat-Signature: sgghabxinr15xj4spi3ch4rh53ecrjom
X-Rspamd-Queue-Id: 421FA100005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792383315-84981
X-HE-Meta: U2FsdGVkX1/ixK7lmoN6mv1nLmAk4yEZH7lT5zeMI3N3a/oFqjRal9Rrnt5HoAy8h2VLWGb8va2kM5uGWcv64S/C4AwV3nVyMsD3B5GSzThAak1tiQzNDecjkZBfhotzlIt4FQ1FlpP7Li4wk1wyCfKiihscCknG5CJGw4gBwRQ0Fg4qdFzHfOtY6Vq1IjNeoztUTvStfiNESGeLCMapkPW4t1pJe6hPOmowCbRn6edMCU6XU/9OXOrA/AlBCifk/Fy6eOKncKoFsSzUD2acfDasaro+Rvo24xZkXtr91sZKfHEk6vDav8Hh55+LkLYRPplHCCECG+ElraV/rWMpneNUdJOpGzuX3PyotF9uchUxsbAzYDnCFvqi9oyuapKLWS73mXM7DGfeiXgrii2YgiRW6qJW595zZDag8zugGBEEnx0A5kRXCHgyXTKYKBJeE6z/780zyGcC5AnSnKvz5INPHkN0HpDBYEpbvNrD1GXNDLNi0TMwNdelYtVG6s6Sce/IjmPXqhPX6liICokleikn6fhbM+wBDOMQWCZ6lfmMEH9xZyAbkW+xybuSLmlQ4krLde/uatahqDLcsaMtjI2y2yxynO+ZIjB/A8EzcLSxhHeRlSArf3XNItSOQMkIvnXKYnSwF7D2CFjlDCvSxiwt0aDD382rcvglelrW89EnH786cvHjxL6Q0J/k5CBWYDI8OJlgCIWtxM9nExqKxgFMgedscfn003R4gBqokfTEADwn5DMd3Pd1Fv3QmEFozE25LsHGak4dj+Yjtfp6TBmGWia/S1OCnhza+N8YEzBVAXBS6vOuBG1MV5assNj1zzbm7TZMRXRDndQl1Ln8vKeZnFA6iOA6Mb/OjxmqaYZhOQuAl8MvBoaVgUvVi8ZwivJPCDA8Fqtg/VgYGRtBWg2kt/CrBHAIj6i0/YLNMQjtujyNukPdnc0W4cnR7FCf01K8/blQfEHYrK2dI1I
 e0JqjaWj
 2hwbRirDM4QKDrdAlIgpBFk/OxAOeXizmGklyyriQ28A32YqGhYH371IaBlsMX3HawbQIrPLf7BG70Xpr1fjwGBK6lnOis6ZylGhCZNe90S7jJ1pMSmBDKLwOacs5cn0ikZjAoRgx/wDFEhIormjBQ0ygDs5BKC6Sep7ORBbs+raqkCRcdZUIRBUfv0KqUDU14Ebnq3QyGlohsA3MPay0y1GaYX0MIrMgX7vdikFYnqaKl3Xvba17LDrsVoTQxvDrAbYLATUcgIKsV1m6ziFuqkDoa9jCuHFY7ovGIHE2NN2ZsP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 18, 2026 at 09:14:38PM -0400, Pasha Tatashin wrote:
> For live update we require a fast CPU online and offline capability.
> However, sequentially offlining and onlining all application processors
> on modern high-core-count x86 servers exposes a series of hardware and
> algorithmic bottlenecks across arch/x86, the scheduler topology builder,
> deadline bandwidth accounting, and vmstat.

From: Documentation/process/submitting-patches.rst

"Don't get discouraged - or impatient
------------------------------------

After you have submitted your change, be patient and wait.  Reviewers are
busy people and may not get to your patch right away.

Once upon a time, patches used to disappear into the void without comment,
but the development process works more smoothly than that now.  You should
receive comments within a week or so; if that does not happen, make sure
that you have sent your patches to the right place.  Wait for a minimum of
						     ^^^^^^^^^^^^^^^^^^^^^			

one week before resubmitting or pinging reviewers - possibly longer during
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

busy times like merge windows."

+ the merge window just opened.

So stop the spamming please.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

