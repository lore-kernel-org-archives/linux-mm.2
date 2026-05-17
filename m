Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E2CCD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B9A6B0005; Sun, 17 May 2026 13:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C0C6B0088; Sun, 17 May 2026 13:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBB96B008C; Sun, 17 May 2026 13:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEE506B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:35:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6DFE1C1A3A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:35:11 +0000 (UTC)
X-FDA: 84777612822.07.7E7F4A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 451F34000B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:35:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V8zZOOis;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779039310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ANGdet01btbIVwd5pO5dEijpIwWAXlcSALe+yO4D/s=;
	b=CWnRDIAl2jv9/G68ONM1iQGyAv+fuWsfx+tc/tf4cpzee/Lh0SwncoRTWyqmWCtXeDXo6u
	ZrEonMgDeQdN2nVcxwUID0DyzJ/ReVVAj3TmM0m17jRNfqTWHWsJjxZt82Kw+q3dwPM+p6
	sk9UlR+Tx//LSYBwmQ081ha0k4eaL9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779039310; a=rsa-sha256;
	cv=none;
	b=ELaEtlLs5me+KMaX9l16kjpRbQTxLzKc+k3v+GGnQMFsfBp6uoDEhOu3FCf0zS4dokw903
	9Mnf+chEPC6K1LQUbhjQSZQj7098oHSR1ockHpQi9Oembwrps5a9A+oyqaG0wIYLsy9PW7
	dAx34WE9pbLBvmBH/1rlghVks0+but4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V8zZOOis;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A63FF60125;
	Sun, 17 May 2026 17:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE652C2BCB0;
	Sun, 17 May 2026 17:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779039309;
	bh=Z12kFRYy0M/EBrdKq9sEAZ94/ePFMsKWkRd0ZfTHxeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V8zZOOisPy/dfHu9zDiX5r9+1f/foenG+EZgtGulAhMTuEQ2qVvK4717slDC7SCLg
	 E/B7XlG86btudizxXtXqSE0NW0I87DRHbeMEC/dMrLEN8zwI31Efv/LevZZQEXrlvS
	 HgauKMxBADhqmfIvQrJEfAMBfTO2X1kHe74Ep9Jq4Sc4CIt+QqHx0tloWRB21GHkYb
	 N6Hs3zOcdKc7bASLfS4kj2KSwTynl6TPJQg2QTKrIKId8HpQbqGewBS+kqZ0z6c08X
	 eQDfp4yYE2BZorJA6AiqM48Lr76dbJo5JCK9p3YPX2XD2LEKXSFaz43wdZDS4PZaZC
	 h3O5unJAhv+Rw==
Date: Sun, 17 May 2026 20:35:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 08/10] selftests/liveupdate: Test session and file
 limit removal
Message-ID: <agn8RUGJ5RcySkUY@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-9-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-9-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 451F34000B
X-Stat-Signature: hnaj3hwjc48w8c7ckrux8kmz796e16qx
X-Rspam-User: 
X-HE-Tag: 1779039310-29388
X-HE-Meta: U2FsdGVkX1/FiC6vKG5GuDycBAzQEEKj2HPgFe08iO9+Nv7O3Tef/Hr7n1+Tqm+QTZaBuqljwSUfkoUVteIFcXtCTwaIeX7s3odkh8sU8d99hiHAVgLgDRottXk1xrpwHOzXuNlvB451bENNAiyI/etV8HQXIhmAF7duc4emcEwG9QyNwJeujNz7cHYJzhRqj1gJvs2+Fv8amVfpEiPWBx2akys6XiXFmyqzijNCHaxgI90YpbRxPqBc9P/zcG2P+TYUbt0QoI2Ev3WDSichPDnPm3fSlQAcT0cUthlthBfMhM08C01GEpB9stTTevNN/ueBMPpCz+0q2gNvfkQtr3EyuG5ro9H61ceKk/nmFlR4n/+VN1tMoMYUMOBiyYXd67mglKIhnNXYqdd4BCpw7LTj7rJsQKvC6wHzLcUycVHd0+okmlQ/Qawns6GrSWxsC7B7KHI+yLbA30xPt28rRius4CINUuzkUS7ltvELuCdkhblgMMFDcbyuCw0cMRmFykbnZX2KpAo38OJpldge2XXQYpdhQZPiKgTKyyHHFlsaVBuAoepxW4NcirwH6G6EgS9kHv7UFBSC1BEysYqcqLhwYj7bKYmsxtN0pk3mA7obz9cMstztUcL6biJJGetH7FmgqRnhhJ8YGzLTwoy8vOL1bPjdl0LEVMCLe8oAG1DIdzM7mhWmwHOlXhHlvBUUjFZX8/2HcF6RHyXFCD5pxpXWyeOxJU/2npjh937rvUOFznpVrBMhNua3yIMKJsV3xuJS/487q/2h5eH4C26Gw1PzRDEgMsWpyHlX92gCwdNK+lyuktTSOI3I8RSRVbrsQ0xhrqLfmYwfPNmIj+ha6AXQXV8rkrEReEQ+P3eCS+eR0PU4pwzLZvzrMp13ZFxzoJMLDPcn2Bn4l8giH/ZlIHz0d7BVcrIYPF8OXU49wfF6Rws1zAqomY0HNJecVKkKP6oMb/Ulcu/Ld98hMtW
 eeDZIHeO
 pWsU4IYHXd9Z0I8ZMSmXXj5Lxnebe/wstVaJVOc7E+WIEqWzUYMpcM8JJOF6Fe0ifbmyBQjuP6iKTw0A2pmXrtRH6BCuMH0dkafDRTpytLXTYYQRcy6aeYmALFqnyXX92IZzhdmRx90MsdSai7vALV4eOQMklxqZkZZ0qL58f9AYYlQ1Dd9vCajhXt4RhFh0OMoVOHp8Kluh9vsl/uv/P3P+ihnmS0KqBeK7kAMTN/OpEZMy5yvd38U5tJfGcN5p3POpSplx+RndawuFL47bIH05cIfMryFGLPo7/h/7rt/XYutNAWEcm6xmDSjVGmqQ1qKZgMHMmrT7lAzsdmT+vASubmH23+E4cE8oiBXCf5uaHjBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:26PM +0000, Pasha Tatashin wrote:
> With the removal of static limits on the number of sessions and files per
> session, the orchestrator now uses dynamic allocation.
> 
> Add new test cases to verify that the system can handle a large number of
> sessions and files. These tests ensure that the dynamic block allocation
> and reuse logic for session metadata and outgoing files work correctly
> beyond the previous static limits.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  .../testing/selftests/liveupdate/liveupdate.c | 75 +++++++++++++++++++
>  .../selftests/liveupdate/luo_test_utils.c     | 24 ++++++
>  .../selftests/liveupdate/luo_test_utils.h     |  2 +
>  3 files changed, 101 insertions(+)

-- 
Sincerely yours,
Mike.

