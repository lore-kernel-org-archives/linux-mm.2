Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A94D232C1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 01:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60FB46B0005; Thu,  8 Jan 2026 20:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD056B0089; Thu,  8 Jan 2026 20:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C00E6B008A; Thu,  8 Jan 2026 20:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37C846B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:30:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF97FB8455
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:30:37 +0000 (UTC)
X-FDA: 84310695714.15.D1411AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9565E4001F
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:30:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQovDXVe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767922235; a=rsa-sha256;
	cv=none;
	b=hyyIQwMMMm+aY+Fo4he6uxYNIk8Xe8nnXi/eXNvjqC1Pq0bu4OQshn2MYcM/CqCDz8e/Wk
	cYCfQieABxRIU6y/0+PurIVWlEBWnUA6xs4x6V9XS/PgE7RmFACoByqX1SgoAGUYqTpEKr
	hzTVpMdfaKIZRlD7h0YX14rKUqFOgkY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQovDXVe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767922235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUFfDt/XsjxKvJyXwmpR6U8wjvH+z5odcy8xUkSgDo8=;
	b=33ioqq6jdxeu1nA/SxfysMh2SaiUC43zmvx7Ytm9MfKcme9cXIsaoPRMxH/wyooBTlTfQr
	I7h4bU80+mJUvBZuFJ6SUi6WnxBHNNF5QyQbW4bYDiabwpkqRx2/Qtd/7fkXNHNOqhVy+R
	R+GL2p2GOT9/5POTzrf5HDhcw1vNo0w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 138196014F;
	Fri,  9 Jan 2026 01:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1CCC116C6;
	Fri,  9 Jan 2026 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767922216;
	bh=c4Rl9rf3K+A4EsY02anP15UAm6twZEGiXt9HoSy2sHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQovDXVe6c6VHLNf2U5IVI1CbFHOJAuMVIWyauRtl0wVLIOZUu3odYTW/zqZhHXic
	 EpMOf+wLt2LsYaeS6zcGRhy+wiYzAdKwcuz2BZP4KYI1TqC0GwbzEpzB5OTpa1shqt
	 +0a+Bvzn840zp0kJAIc7uTGkAXXY0I1OYWcbAoCiU5WRW02aP7Pa7ChyfC0NpLY5Z4
	 dpE//cZMkaBE115uDFJNH95+KcqKzLIO7guxRmnM9S0MHbKyASgGQ0c6iMznFxysiK
	 DWFh+xvB1P0KzguOOkAL96ZCtvMAPTA6ysDt5YPbLcynlePoOfYPDpljfpGLPxXEJ9
	 zQkn0aBgeaiSQ==
From: SeongJae Park <sj@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 5/8] selftests/mm: introduce helper to read every page in range
Date: Thu,  8 Jan 2026 17:30:08 -0800
Message-ID: <20260109013009.68474-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260107164842.3289559-6-kevin.brodsky@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bkqmz83wa3aitpib39jx7r9rgzitsuan
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9565E4001F
X-HE-Tag: 1767922233-549149
X-HE-Meta: U2FsdGVkX1/OliY+Dd0WkzQDnG+DztcI440L8WBFRTn9bm1kuxtf+9e0sN2ERmb+wgLca12HswvFs9HBF8h5dMIHSEsBCttjZOBLuFRTh1ByE/pa7l3joLNCbiI4ashzEfOANIahoF8YR3REKwBEqVpwdnGUzEMk0gR2k3omemlDUvokmkYonSfRIULr6Qcl0Z0YWNvfOtLgNeTff0o3hmhkIUrmG5wcmNK9x4/4ja5oPGQL0dNdc7Om6HTMjrmaJ+PrTInOzbcfnrH60pI5GALz0nD4sY6M5uFYyiDwfImP8t5nSkKurYfujnRo2SE8Q5KWgN4xB7qMlK13fQRCav1OngNLr49WAhlmc1fiH8Il7fLaVVdYjjITF/MdCnsLECuasnsLxyZVZZvF/iGteI9dc+V+TsC5l23gSA2zoCzBbbQtsnRy8dwksbYH7ihtpWXUiWpRe9H/AoLekbz2m/VR8R/nZ9Kn+93xCxNbjl9Px4u618p+lXICOu+nFcZTesIt2HBIUl1XNN8+IzJ28OgUT4VmBfXZdEais2A2owpQxrT8ZQECHEzqWEcEeSuE+dJFFyHuuDR7Q/9mnjeJpzArBjlzgP6P/S/igXkvwNC3+7LaZZLp5k6mURgtW9be1HC0mUjtUvDn4Af9q8DSbm2J1Dh4Sbx1LGl30btWPM3s1Y9g/VHPcpUjmA2ai5EA7qr3hQsjpK2eGirTy+mxGSRUWcRyqggObcptRvOoWrGLG5H4///Qazgs5XyeeEEVOETSuVjE8XBU1jZW8on/kVbdcsHyijxWh7C89Ma3+JPvfd639468ueCG4SGw8F8CoGJfh59wwzXWsRJNOjpRuDTuk+1AmZX5h33cheOzIqsEHWbGVAsqfmxwqQv7+gMcTCFIRir7VnMVJL1eHjSPs8lpMF2t1RSMEglPLkiDv0TYiH2hLxdRKSmy0+x8fS8Kpk20D4hN258zWkCusA1
 rk8FezOS
 5sY11ZaoUiS3CZcNZ6nvUyHAxGdGqgbjhgIORv2XGbntcJb0euvAeZImHpiqncpDUWu4d/Xm1QcTHEqLY+wa5oziV2GSfYczZ+5UyMcG22+ZRTVo3bISEwrP0/+1QOwt5kvnS/KinAddaAdyVniIVFtFhpnyyGEQtE8RGLY2i0H4zTZGGL5+ibdFjP9kIsMA4BfELigrNyW7NavE/IDrCtzCbGtCX6fZyHfPWyQ6weeuVSF10zlI9pmFuV1WtZytY7drB1E5F5x8HxnY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 16:48:39 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> FORCE_READ(*addr) ensures that the compiler will emit a load from
> addr. Several tests need to trigger such a load for every page in
> the range [addr, addr + len), ensuring that every page is faulted
> in, if it wasn't already.
> 
> Introduce a new helper force_read_pages_in_range() that does exactly
> that and replace existing loops with a call to it.

Seems like a good cleanup to me.

> Some of those
> loops have a different step size, but reading from every page is
> appropriate in all cases.

So the test program's behavior is slightly be changed.  I believe that
shouldn't be problem, but I'm not that familiar with the test code, so not very
sure.  I'd like to listen voices from people more familiar with those.

Meanwhile, I'm curious what do you think about making the helper function
receives the step size together, and let the callers just pass their current
step size.


Thanks,
SJ

[...]

