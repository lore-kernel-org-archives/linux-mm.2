Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACC6FF60F9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A08F6B0088; Tue, 31 Mar 2026 05:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351266B0098; Tue, 31 Mar 2026 05:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DEB6B009B; Tue, 31 Mar 2026 05:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2096B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:50:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1939E03E8
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:50:57 +0000 (UTC)
X-FDA: 84605889354.23.4B36DE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 26F6B18000C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:50:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u6Ps/L9J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQLLv3DBtL+O2T4WLSUue27GAlQOhDRFAruuUtIixPc=;
	b=nnRV0eW0zr5NuueUvVNo3zfMnowhVXV4OFpGE4/07OWw6GSqhiG5/NSDFGIJV5KLKIpYCr
	YeSQo99dHnQHT9j3LcK+/ZTD10sKE53eP3iY7c0UZDiAktVr11PZ02j93nNe0MZEGQWc4B
	e5aVbQY1vrHCvqZLNsCCCd0w5iVVH0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950656; a=rsa-sha256;
	cv=none;
	b=X88dEXIqlu0M0+DQn/cxQsEcTDVl70cPt+CjYk1Mz/MqogkvS2JkGWuiokfU3cBam4sb4g
	cFm1OqzU1iyToX4Vx+Yc/PjaIjsK2GaWRQkOgmjHnZ5u3USui3ltqaPXru99PT6KnHL3nx
	12K04eoFas29mo1tDpF2gjzGsywPFJs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u6Ps/L9J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F8E56001A;
	Tue, 31 Mar 2026 09:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B1EC2BCB0;
	Tue, 31 Mar 2026 09:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950655;
	bh=iW5cYp4tpvQvWv1eWidkzQPspDciK0ndjT3ylVIbj8g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=u6Ps/L9J6YYbUx34Wm+ui0TMF3DfzjAf5+Sb8dAJdUHRXOFqhlfTBrVVdIJgbJ50G
	 TMx+1rwt4gUXcFnQWQWbptj+A6Z8g9mWpbwNiYeu9HFGffhS/En9zzxgyH34eKwN3v
	 zgpLp1x3EfTl3r1UOMIexnZf9Tq0ay86diB02hFkO78x3y4viFw+Hesq5DgAmBe3kS
	 02QUIqkDO2QMei9P09YzCWU4PQbyDNwg1A3ptnySeIFaC2V+u3p6BgG//lg27AJLG0
	 k0gAp4gOxV9DL378oDQva4CBcPmZ4irkeD7gTanVifXOWRJuS90qQusT5v+EDAZ8IS
	 jaoYBMubVeDjQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 01/10] liveupdate: Safely print untrusted strings
In-Reply-To: <20260327033335.696621-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:25 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-2-pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 09:50:51 +0000
Message-ID: <2vxzikaciays.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 26F6B18000C
X-Stat-Signature: w99ea37zsa6u4itns149ddfm45zbgraf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774950655-337574
X-HE-Meta: U2FsdGVkX19uRxCBoWOwosJDV8+OrFuZQwx13BIWJzRy2877rPkx3XAsSDc8hSlpFWAvXg5KqOEwfx1PsZ36PhH6tvh9sqEZnrPrMHkJEeP9oRuyFiLT2C85unNQSlhe7XZyaf2Ebju4IT/55wIVsPgzFklMXGvndKpI+o+IpIVaW4q8Sv2JEn/9bRWpbedG6dOGXC2zxWuJEgG2nrUxwHEad7SPl4vGJ4nTX2+opPPz5tJdMyvOzg4YFoxKIZmDM0lrTrBnJCA+Dq4M/C9ftJMZDtZdM2klthn6omhHTd7j/giJIgy2Ne4FfRr+Ut/+y1XLjzwPHsmYvKwbg66FmzQPRZYyt2DjVjrpR5hq00yeUd2uwdkrpKPhGcULJTOWbSgq9FPmoKJSNLevRBtYoV5ns3YaQZ6ZlIRKfcKtyXdckBEjXEqu4fYWTnpUsLyLVOg48+OWWOkwCTebhIlshenHW3UuRW0CViAAes5EflMPkivl+eAzWsWN4QR/zL+ml3d/eTi3aSQzN7BRIDpl1NFOvmUFgg7zfjTg3tP0Q1d93SD4BDUQJ8KIzrpnO7dB/bqvVTcUZpcfeW2P/oepiNWtuy3ZILAFJMvC6BXtjiQNfWu8NIHrQVSJvU5cFnnEuYQnxEv/3/J/IarUtBx/TdltD8pfy9fSrCJ+0hheR+OlOKwk/P2VCZWMSECRpfnkJUrk14mDVsB3KS4YxrZsg2UcSD8Azlg+4c+w/BVFzwzhhuEBY4pVAkjKxf0LHOhDx03Hh2Pod5sX3XAS6RJodSgqBGZjsWB3HnLt4aXghMoznWziY+mcImF7E9SYPDKFGARFVlY1t5GkGpfQTHmL1Na45ErVF92OQJdz7uIs2LOWsKvP68rZhM2hFLzxWdCsOx2v3N8ciJmSG1g2UzHljqRZjdIRVTZQb1Fk+Y9Men48QtEZr+Z7hqijtAxhvU08fC0BrbpcH70d5B5lslU
 bTJL5UYJ
 E8e2Xllwt5tOrMZf1u8Zp6g9HHzibvUF85KIHDVGjw6VItMSbN3jQQQpDjiztbrLdLQk8P6ybim6B9BhQyUyIiev9qvYJfrN+FIqhFfPBSlDph0Wfu0raZyMYDhuZqqDXzYeOGLZL2Ogcp98t3wHoYu+MHyyrEwVC8gLBSAWXKkwjS9RDcFkRvOTe3qJ2m6NS/K6bFl3jUVjuwpy+cFdZFhDuvfnkSMJ+h5FDbLMT4UnA2GEXevNHP3u83g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> Deserialized strings from KHO data (such as file handler compatible
> strings and session names) are provided by the previous kernel and
> might not be null-terminated if the data is corrupted or maliciously
> crafted.

Nit: KHO has absolutely no way to defend against maliciously crafted
data. If the previous kernel is malicious, why would it try to play
around with session strings when it can directly manipulate the
serialization data structures and the memory they point to? There would
be no way to detect or defend against those. I don't think KHO should
even try to defend against malicious data. It should only care about
corrupted data and bugs in the previous kernel.

The only real way to safeguard against malicious kernels is to have some
sort of chain of trust mechanism like kernel signing. That is of course
out of scope for KHO.

So please, if you do a v4, drop the "or maliciously crafted".

The patch itself LGTM.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

>
> When printing these strings in error messages, use the %.*s format
> specifier with the maximum buffer size to prevent out-of-bounds reads
> into adjacent kernel memory.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[...]

-- 
Regards,
Pratyush Yadav

