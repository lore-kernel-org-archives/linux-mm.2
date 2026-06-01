Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB88CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA706B0367; Mon,  1 Jun 2026 08:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA8B6B0369; Mon,  1 Jun 2026 08:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99476B036A; Mon,  1 Jun 2026 08:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B78276B0367
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:15:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 886201A05F6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:15:20 +0000 (UTC)
X-FDA: 84831238800.19.FE6794B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E5F661C000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:15:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LrLGr0LC;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltaXiFoo1nairUBpGpJ8j/GAOTH4OfEDT0rk/sDRyic=;
	b=B7+qjvzIQlFokt0S7EO8cfnYBgRWiLcl7Ogrg5m8WThuYoIJ/eeU82cH71aZ+SVMskUjYp
	tdSKDeUGW1j2JHYSLxgtBDYzA25RMd7tuc9usM4v1c5dhrrPclkzda0PJZFBGpa9Da9KiO
	VsrhcxZ1ipdVCb6DmXbOLRk+a+mQONE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LrLGr0LC;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316119; a=rsa-sha256;
	cv=none;
	b=A9D4wbIAykcv3z0DLvFpyuHZidlejZ8EY1J4UzZyC0buMXBQZ1kaivh0q9DRd4ST/bfoaj
	xK/SPEAosH7FiOQqJAikQHTc3ueFUts9lR5+R7fFwThqqFDsw5pPgCI+kEzeU9Ujcr5bZt
	bjyzH1frcaPPBGrJ5CuKnLJ9I76C9OU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B05B6001A;
	Mon,  1 Jun 2026 12:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7B11F00893;
	Mon,  1 Jun 2026 12:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316118;
	bh=ltaXiFoo1nairUBpGpJ8j/GAOTH4OfEDT0rk/sDRyic=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LrLGr0LC0lZ73GBlsNqoWTij/nowRsxj8FcJtxGy/x3vJbBGSFfxhCHJ3TMxPXTMT
	 0l/fsBT3+ZQ6P1KG7wGVm9h3EuXxXAZp8vIPj5l5pX6Pr+anZGp7Hh3nhmvIp3TTvk
	 DS2+wYZwNDCpfNg4pLx83G4y+Kxtmn5QvYwDxqAAcnhoV3TNbztDhfedUzdD02y3ff
	 3mAMVOGycckc+PHcLi3GJuwhqiygfQDjtvAT2rWr5vEWcJ0GudPJVLdh7MDzWWmAU/
	 YjJi81zfqwBHk7JorK+28N/GZ3am1L1UaaB613UCfuge+P6IY51C0aZlpR1PWWIK3K
	 eucUyEKcXQ5wA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v4 02/13] liveupdate: avoid mixing cleanup guards with
 goto in luo_session_retrieve_fd
In-Reply-To: <20260530221938.115978-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 30 May 2026 22:19:27 +0000")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-3-pasha.tatashin@soleen.com>
Date: Mon, 01 Jun 2026 14:15:14 +0200
Message-ID: <2vxz4ijmh2y5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 3izzkgk6uuasxaqu31uzhnkhtsq4nb46
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E5F661C000E
X-HE-Tag: 1780316118-128175
X-HE-Meta: U2FsdGVkX19Y2bc2PSRrpslU//hGEDqJQJoYqDMouRrPcTjiYJWEPDTxoevvxeh9DxoDz9KJ0gqKoH4ujLdzXOTHhmW4Kfrbt/6q9Uuhi6GXNWL6c1XdU2haRPEhMR6wyIU8txx924uqS8hjFRtKSo9EZUmEN+AmfAcHHw76xlkKtGym9CBn0EHjrqqOq5lNOhr4hCEUGMQOxof7hUln2O4oMSkVXekLSx7OvTE+itHjQEIgG8q8fdB5Y8Hkd/ScqIBIBkcoQ3C3ioa3nccKoMPUDJoyueuF+eYVJ9RsVijwgCc+eGbJ5G/8rDfEB8Lu2jKkCG7G2FMS1FpBBaJFh3/kzWnJoqbV/3mRIFITScDBMVLppMwuWUA/5tIEecLr6kvZmrhoBdfG/AZLljWUU+BzHsX8PPKFBuP/KHf+XlbMjG06fcmx9jiuH0YinMvkCliGSU/7DjDlVOs8XYVRizOCO8zDFDrhRYQcD93K12Nb+8vweUqrVwb5TFKr3E7vujAoAbXgQiibaBBn0Z0k4EY3ojH9Nw6v4D3TPCg2kZm6fZNhNJrAyq01s0a9WPp7S9rYs/S9L4vjU6VezhXqpiM+vgoaf9irtkOQ1AXb0OYZRKtQyGUoc8rkc85GvU9FqAD0Rd7ta0QmqpFt3UsWJ2r1E8WnF0SVoU+J70TTxW3l9qcHc+eqxg6eB/pOThY0eSGFj/2H88b2Ep6PjjtMEXna6M7sOY2Voak1sYMqDdNFnewKgkpKCJ7pi0MfsscdpFGFBXkIdNqWY8MTe2yei5zda0pNZArN0rc2OCY/rC1TaoEUi4o7Jlrsc0VNxEbRHn5TF/1blCv6EABo2RDhkp1oh6+jPGAx8C7GffatCj33ePyFtimj00am/qwK1IYHNBHfwV5KuiMDgqnHsnXtwC7axvpz62Z7D1zpBC6OT49QJqcoDGweBQ4HG/OSg8FojrBMawEasfNZX08/JMu
 4IsaLTqV
 56LE+eJ/9b9y4GkBIX9M/AoTwl59B6hBykanD17JlHGQizkGpCadz907QD9gb5nPtoRv9Xw2TRDVdv3rkP/pljxhMraM97RV1UG2pMvrxhAUqIn7rsc+6/vcmMhPhnlb1qDgLIFwxmB1s9W0bAW2+RBl4PqD3E5fCW4gbOhAfyYT6sdxOh5dTlc8efhGazyjIo6PFiNDbkWdEFkMNIkWlH8Bm4bKIKXTSZw7YIejeNBFzgV2ZfqlaPMpQRDh2iz11FLCojdOGDgdhDettWRJeZ96kbMRp15EQPmSOLnNG/hsFbwVm0rJmLwrxSL19Fl11D9ZJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30 2026, Pasha Tatashin wrote:

> Refactoring luo_session_retrieve_fd() to avoid mixing automated
> cleanup-style guards with goto-based resource release, which is not
> recommended under the Linux kernel coding style.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Perhaps we would be better off moving to FD_ADD() at some point, which
should make this a little bit simpler?

Anyway, this patch is still an improvement, so

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

