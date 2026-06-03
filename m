Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0102CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0336B00AA; Wed,  3 Jun 2026 14:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1878A6B00B5; Wed,  3 Jun 2026 14:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4956B00B7; Wed,  3 Jun 2026 14:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1E506B00B5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:17:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C37FF162EAA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:17:02 +0000 (UTC)
X-FDA: 84839407884.20.989D720
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 327562000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:17:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSLKO+Ut;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780510621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxQ22KcJJP7bVCdFVSScm4T4WK7bH7Ys2cqAdls6sJQ=;
	b=Q+27W+trRKF3qfXYTUQqX4rbZ/FmWP/0X2GTWds+N9jD3syqDnHro4XqeGAvk/3GjH1az8
	xzHur2I2kdvWIKjvOzd6aioHskE4AdxNuQhU70163LX3DOFhqbFNZ26MbPmj+R6VvVqnmt
	2U0V0L7j65pAOiGBvhN4mm9xZUSimok=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSLKO+Ut;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780510621;
	b=2DtOpNdSpvysnut03Yf0RajvPekDkxgVLDY6Vicn1BYDB/xPa6gVSUzTtBYMpI2e/AzpkD
	jUDGIcfBTVL7mDZeKBIDu320Ga789LgTZsQw3hkREA7pwORqON2tJAwryaSavtCPBgsZxM
	A0Cn9h/2nd+3gzd3m3ykFfuiu3uVhF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFF1E6008A;
	Wed,  3 Jun 2026 18:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5594A1F00893;
	Wed,  3 Jun 2026 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780510620;
	bh=nxQ22KcJJP7bVCdFVSScm4T4WK7bH7Ys2cqAdls6sJQ=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=YSLKO+Uty9Cb7gb0+g+YURmGlAfgJDL1bkZ3upC7pCzRW257ES511XK59cObIdiLp
	 HQLBUG3vDvVuHsHby5F8udil1Anpb1xIEsfKK6txziKZubb3wr6xFoqqDdA6qeIGi+
	 IlXPtzuptxb2JFv/3bKMtDLvilfFAJF/lDPbXMlmFK3r0ygLOVQbjzEtiVBB0FTZuH
	 IhdHRNMtb/2RYH0gjiarVrBSivGLVN6SJ5wOArrtGfyPFukeCboLnQBsBtzGIKDjda
	 SC1r3BaxKQTAvqhGzJ/IlLGkLhuWSL9lCQwPbyV0EZsAaZEv0ok9PIFUHxdq9AFQho
	 nY/BZsoKlHezw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-kselftest@vger.kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com, 
 Pasha Tatashin <pasha.tatashin@soleen.com>
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
Subject: Re: [PATCH v7 00/13] liveupdate: Remove limits on sessions and
 files
Message-Id: <178051061274.867224.3632796902576075261.b4-ty@b4>
Date: Wed, 03 Jun 2026 21:16:52 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 327562000D
X-Stat-Signature: pkbdgdfoanh9yzu16a83q61ezbom3tph
X-Rspam-User: 
X-HE-Tag: 1780510621-422633
X-HE-Meta: U2FsdGVkX1/7o/Qy+MUVaGBQP+V3cqLEP7cioHpPj9pjcEqafyUoTQDcf6q3Ji9x+OAYaVYG2JCK1rctV4TQzbGOG3McyrcMAhWDPAK1/p5udhCM+s03n58odMkIbTQMfhGyyTQyS8bLg1cBPZbKpv3edY9cVwiGyudZzSLLEGTp2wYiQH53RAHz3kdP4p+ug9psH9gJa/tfyYUHTsnAJ6fFpNl7/L+R+Oh9MO/V9G1rqfIrfcrDFx9myOX+hNFYsxfdsn2NpreIKx4N1yWvyZTI/Hq+SAqAexPFP6LakXPhOy8JDvamLNNLOaxZM9stbeJWQaoMD5qin3y1Ly4WrdPfduQxDKbW7vxbuDJ/pEWITf3/vXBvNC+pBeIQKn2EO3C50F9f6kiuRfbhX3nWQdQuoitGJvBJJ7CHchNoDLemcr4hs3qKkdX1mmWqpd+bbJaJxpDDvO0FI4hbcCEU4zUZqPN5fgFooEBuj1hn0bMzUdD8vFBhD9I1cP2d9JkLA08yr5lXyEDk5jEyTv5WFn3uqnEFUXDNOvxUPzGwHEJGBUFaChXpxiZZbPWnSsu7try0B0RfwX6FEWADjZQ0NZ98/ukr8TyuYdTHw3DLBdY50ZKmT+UbvaZrXQSPzsPebLxYMrbHEO5f3m//8F/pNawK7cuhU17AztcgREonOcSbJL3wtOnxIY24UGsEYK3paCt9+4gSuLh8/ktqEKEp1RFiHWckLXLphS7oXvkcMRfvK6F/wwPtDIwRXz2X9RFruyCA/Sb7y/fXuHud+RWB7OQvK0MG3+/ff15OipJgFRTzOeshnuxS7uvqeJfwlt6tBkK5g2y6yhQTLReOW1SpTlkY55oVgnWgA2wXiWn8xXZq1d9GLQuraSLpz1avZylmAnfzn7usrb5l1xS0sd6Utem4wqLlLVdI3ntyeCpxjjDNgep7hpmssUX2u/GTSS1XQ5qRkcXZ95wpp38FAgw
 uEt9aJM5
 WFlB9YFZKWLWwTf9aRIg2kJUVrL2mjzFmqKhYtSaBNn75HxA81l5ZvMkgCE019AHeYstk+82yLke51eyme8QuvejU6/6JrNT66+EcZNUNh9S+fzVk1EQ9sUqAikfEAcS3qOfdPNXGogpCnd0oVEbUNsZioH7YoPugm0b10FuxcT89hJ7Slzaga+zm7kru7ZGJQiKccD5FjjjF8cbgLaikqwaEC65DAvIR9g/89sRrMuHRP2F4/UVlgAkFHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 03 Jun 2026 15:43:49 +0000, Pasha Tatashin wrote:
> liveupdate: Remove limits on sessions and files
> 
> Hi all,
> 
> This series removes the fixed limits on the number of files that can
> be preserved within a single session, and the total number of sessions
> managed by the Live Update Orchestrator (LUO).
> 
> [...]

Applied to next branch of liveupdate/linux.git tree, thanks!

[01/13] liveupdate: change file_set->count type to u64 for type safety
        commit: 81fbb909ec07868415f6b2269922c8d1cc6a215a
[02/13] liveupdate: avoid mixing cleanup guards with goto in luo_session_retrieve_fd
        commit: 6af06e11bd48bdefaf9381f6ff0bd65b1e5d98ab
[03/13] liveupdate: centralize state management into struct luo_ser
        commit: d376e4b55c9a0adb3e701c7eaff21d9ba655a1c6
[04/13] liveupdate: register luo_ser as KHO subtree
        commit: cf071b3536df76a2a75b83ca1fe8c043824352c3
[05/13] liveupdate: Extract luo_file_deserialize_one helper
        commit: 51b71af922a7145e63fdc0cab075d681ecd89e4a
[06/13] liveupdate: Extract luo_session_deserialize_one helper
        commit: be9d10d167652e11283cd07c7daf187222808db1
[07/13] kho: add support for linked-block serialization
        commit: 0349ff2887059112ce06831ab29aec47a2a7285a
[08/13] liveupdate: defer session block allocation and physical address setting
        commit: b5a58a922e6f2f9f40faddd8e0e1fe3ce0ea9c56
[09/13] liveupdate: Remove limit on the number of sessions
        commit: 2a441a14c2c03b39d1c89438dd28cef9d8fa57d5
[10/13] liveupdate: Remove limit on the number of files per session
        commit: 1d1153097f4dd417e2ea00404edec9fbd1d88f28
[11/13] selftests/liveupdate: Test session and file limit removal
        commit: 5ba3f30643cbdd79fb82e525aa1ca55b62fcc7ac
[12/13] selftests/liveupdate: Add stress-sessions kexec test
        commit: 3432292fb9130191dca57953941f7ae3888d52d8
[13/13] selftests/liveupdate: Add stress-files kexec test
        commit: 46429a15a6dfe522880d5085f1f6999357758872

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: next

--
Sincerely yours,
Mike.



