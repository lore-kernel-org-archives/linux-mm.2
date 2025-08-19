Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96859CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 12:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3620E8E002F; Tue, 19 Aug 2025 08:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2BB8E000B; Tue, 19 Aug 2025 08:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA668E002F; Tue, 19 Aug 2025 08:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 086DF8E000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:47:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E09F1DCDC6
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:47:23 +0000 (UTC)
X-FDA: 83793482766.23.648FBF1
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id B7D7B1C0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:47:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=utizinmC;
	spf=pass (imf21.hostedemail.com: domain of 3V3KkaAkKCBo0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3V3KkaAkKCBo0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755607641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCP3mARRCmGSyA8SjIJ4WFibLoFzgkIzQLXkcV/592w=;
	b=5iKrPddTKixkwKohC+EARPRGYWzqDYCl1usgrEPpubW1OhgF5l2vh56cRdxwTAsMqwLqUj
	s1uZWGz+XFOA/Q6O20t1N7Gxf2Q4sgV4quJPpnrtXwmS2KLebW1CsQ0On0k4ncMxuc3K+2
	jxhiGe6Falu8mXvQyJ+XhJR6nxHTzwE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=utizinmC;
	spf=pass (imf21.hostedemail.com: domain of 3V3KkaAkKCBo0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3V3KkaAkKCBo0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755607641; a=rsa-sha256;
	cv=none;
	b=i1S0NJGZ9ZXOjWGR7Ff76f/S0P7458hj5aij+PyLyWUS9uTue06Pb/NMoavINaR3fCpyQt
	Z2IYXYU02kRo+bReOHPdotJPZZAO9NuLlNYBMbKPFY7xfu+kWIhIycME6ziwdF1oK7VqAm
	I7JhAuvQ5YmDoATZwwDk2s69DGGmGt8=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-618b3c75161so3289554a12.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755607640; x=1756212440; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yCP3mARRCmGSyA8SjIJ4WFibLoFzgkIzQLXkcV/592w=;
        b=utizinmCNyKpa+OaNNW6Dkg+KyyNuepqwVhR5reNYnnBV8UJXF9C60UOsl7eSaK6y/
         cZO4aMGpawCWKmg2gnq5FhOHM2f4Wt/MPV4uPEMXKXylsVBoraHhtazmBKZUx0+hMlCu
         arE2GLSY5UUepjLiNt397+/hGC+CCTabUEZyFeHsld3QHjsFbUX67Cko7Ak0Pxx2oiCo
         MVRginvqPDPuF4nyaAW7X2f2eaGnoMjwLuragjzepzyaVhuoIno/SO91r1SrcoPbi983
         FnJXt9UOSBbzkw7h3JADHE4G00+7R8iSAXxVC2/MecESUrgreYZt8JRkx/V0dEsfx1Eo
         JZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755607640; x=1756212440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yCP3mARRCmGSyA8SjIJ4WFibLoFzgkIzQLXkcV/592w=;
        b=QaZZ5ZJSW0k0rDujWtBGioZ0em+aDK7HEW51J3lFXGkisLfmSnXKm2dHdhMnRK2oh7
         026Qy7SzmLRBxSdmOZcXmweCK3rTO82NJ9xMx/MO8tNTaoCu7lhdpOHQ9tJhEuEXp08C
         B37lboxuXlj5I8b0l2VEcbwyBfJ7DoeKbeKBzkHXrRykknLwDdctUvwFbMdtJFN8c6UL
         Y5F5HL4oTVrIl8RQWWMdMyGZlnCVUS3D7gPEU7YHzXJybTO7CyewuY8jHhhCSz/0zwnG
         oQA5TCWnMjqaYyLQIVP/qAqNASZEmxvTDOwwuGH4Uj2AdDHiq6bUlHWwTxFmCOlc5d74
         5u0A==
X-Forwarded-Encrypted: i=1; AJvYcCVlNwY8BUiZ33/LhzjIqb4gJlNx+d1OsrNxT3Bkhjom1FxJzoI3ncWsk18Y/y0OUGhnH0pgoOc32w==@kvack.org
X-Gm-Message-State: AOJu0Yz/Lv6zsMKRpwzcrNB7GcaNCGlrDixHHNEH0F8BZsoWOBhkykvs
	8PV38FJB7lU1lC59doQZeQqByeDcO8gnAWnYjwtPD6oURPG9KcGV/+lw0NTah9pmChhfuIzm+vc
	2UW0LqjdeRtRKB5Gvtg==
X-Google-Smtp-Source: AGHT+IEm3E+YxF6ba6FVTvvJ2UxOIsdLdFxvx7w0w2FiBNMNteR5h1lV12gqN201Yr/4E2dtrSkazbFRx81rp1Y=
X-Received: from edah9.prod.google.com ([2002:a05:6402:e89:b0:615:3b67:8aaa])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2351:b0:606:ebd9:c58b with SMTP id 4fb4d7f45d1cf-61a7e6dd3femr1764482a12.1.1755607639860;
 Tue, 19 Aug 2025 05:47:19 -0700 (PDT)
Date: Tue, 19 Aug 2025 12:47:19 +0000
In-Reply-To: <DC6DQKE6LVNQ.3BBD8WF8XGROO@kernel.org>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-5-229b48657bab@google.com> <DC6DQKE6LVNQ.3BBD8WF8XGROO@kernel.org>
Message-ID: <aKRyVwfwnn5_MuB4@google.com>
Subject: Re: [PATCH v2 5/5] rust: maple_tree: add MAINTAINERS entry
From: Alice Ryhl <aliceryhl@google.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7D7B1C0002
X-Stat-Signature: qw3erjimryidpf5fpqnz96r4znzum8ki
X-Rspam-User: 
X-HE-Tag: 1755607641-750198
X-HE-Meta: U2FsdGVkX1/RbT97xtbmoflAEASExNwAilFLcs7Tcg4t1s9sLj96b527pvZ+XiLjvJIDH7DNO7vqnjFECRAEvSHshm7F8gA79m1IjjVURHkPka2BIpDSgsvfHni7kJR58HmzM6QH5mgxDSMGmtqK5pxBpH7tDC1B4XkLk/FukaL00+wv1g0Dfjo9GYlXCQA2NUHAxW34LbOpm0dMXxmkvhXLgJdSqlwhk0Ey9Xfr6mZSIDUMn2J0s/TCHV3GJJPwIts4uWzw+B+y2BgLoUAFolF4TdC8PmbsusbF68kF0fXbc5ugiwo72fRYgnc8WRLsft+l/KjWmuo5i0VdNS1I35w1t90h/F19Zpw1KsKvF575yD/0ojhckZSok98l8GqL8jKvLRQmjbrqZ5pcbAHkNsMJbCaFitPwQqY8WkDqALTEJhGnH8ozfAY5h0RqaVvRDpOPAdMKs9ze8eKYKGS23TMsFTikLwD+cx27az0E72oaJ15UPoOQNCUaOB47vETOqbQvAnLwMyxkirQzwViRJGB8S93cU3DJdB61wyt75laptN3WRYEHh0avuBB7nrY8uWT+7q9M0/kOplLBVP3E+BMpwm/zuf5n5I3cfSsE89OGkKliY12/JXDJO7w+gCluQlnoyjUJbTS+qwF5L1+mG/9hCEH6bpGmVhHoeeRJumYfejZRMXobCWFicKqMNwtfHRDWk5OCYJ/rwWWLPPR4Hn32u7BoC+L+uAfZPkXlaBvepV8YG1Nu5tYdj3HjQTlNFen7Bolvtr+NMjs9R5MCLSDVQIVm/S9EyQSWHJbC6aLl0Da7It+xqdfwB8rnWgH0EdUhVOjz8DoJhO0IvliqNmyPfR+wLmnoGawPWFNzud5a2hPfT/g40HBJQu8hAHj/5sRrfGzDA8p9TLwnBzdGwVBVuXp6WhxRVTrADBgqo+LLusEY7s/quvTbfbEMdmbTzun+QaZTgcR7JvWuL0j
 yHrCIE7c
 K5dImRi+NDY50X40YUir8O5yuw0bjOpIggzcifn5RDx/jf+hp9kKkaazjSIe0+oAl14HcwPw+N3yEWVU8CvwYn/dOos51GwsvIdkiTJF1aNfNeKSe8JvdIcxrje+4ZWHTTpRETogOiR3pMc8PeW/GguQKq63kUT47cxemWHStAcXBL58dIK1Yx1I+RXGeHsNnrhT46AJ7168JVHO1vhc4llo6llIJWFdvijLQA0Vpl0c5nb6Dda/bu/YgAuHfF14m2TPfir++K347wNdWPrtOspZ9X1raa713PIpf76Is/cPNGjnNNmbtOEmH0Zn5ejDCjmxXYay64MDmK93TQzmmm+EUYw1lqfWcO0xhPGXr98ANZ3ctWyTTSb/vOq4A3W8T2Optz8WRWjuhei+nWLD6IduYoDwfTsL628/bw7SXvE4esdkHddlDqI27Sv7VmkXOLM2YBd5BvipVxIhzzjxMnd2v5yt3lEUQbG5pZ8GbnAYNe6nbaAVQy2+MMeb8/67UBuR7OF0NDzmK+ZnOBnS8YrbZY+EsTXI/FbQKrAE3vFFnBYoy9jNjq+iY3eWwdroGeYzFDohxhmX8Y5mQekaLWyYdDMLdQh8ZXpQrmjYFacWu+jpXlbi4aVPcMQCXubp6iL1CxxQiSQWzY1CcM/IN3vyeDbUjq2RpLbPYEE4BTQAfqOD4tbdE5rgMgkElo1/5/JUQjXBnRxJUhSuYqmjzPInVCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 01:49:27PM +0200, Danilo Krummrich wrote:
> On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> > Similar to and just below the existing MAPLE TREE entry.
> >
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> > Liam: I'm not sure what you prefer for the MAINTAINERS entry, so let me
> > know if you want anything changed. There are also a few other options,
> > for example, I could just add the files under the existing MAPLE TREE
> > entry? The get_maintainers script should still send any relevant patches
> > my way because they also match the RUST entry that has a wildcard on the
> > rust/ directory.
> 
> From v1 [1]:
> 
> 	>> We should have another section for the maple tree, since it's not just
> 	>> used for mm.  Your stated plan is to use it for GPU allocations and the
> 	>> code doesn't live in mm/, wdyt?
> 	
> 	> Sure, I can add a new section if you prefer that.
> 
> Maple tree is already used outside of mm, e.g. for regmap stuff and I also use
> it in nouveau. Hence, I read this as moving maple tree to e.g. lib/ adjusting
> the existing entry.

It's already in lib/ ?

> I personally think that - of course unless the affected people prefer otherwise
> - it is usually best to keep a single maintainers entry for the C and the Rust
> code. Maybe Alice can simply be added to the existing maintainers entry?
> 
> What do you think?

That works for me too.

Alice

