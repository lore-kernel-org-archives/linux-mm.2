Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1A3606A334
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/u5PWkt
Received: by kanga.kvack.org (Postfix)
	id 123376B09B1; Wed, 25 Nov 2026 06:04:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4276B09B3; Wed, 25 Nov 2026 06:04:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BCB6B09B4; Wed, 25 Nov 2026 06:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2D2E6B09B1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:04:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65DF6140B5E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:04:24 +0000 (UTC)
X-FDA: 85473357648.10.E57DEF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B999C18000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:04:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/u5PWkt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795604662;
	b=s/3KMkgbngpQj7vB+WiudfoRHd1d6U7BPJBlXziZett9YoACs0SymOSEHSoOLIIjxC4KO1
	p01WcIAYG34PoS+qux/Mg+mfxcZn9RIAVaHqi3ZPCaMwv4hnMUJC2xks12SuXr+AAZyve5
	t0OQ4IKt+DYQUIhWjOKPpwE/nne47VE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795604662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUA/rTYvpBA7QiSm2QIxyI9jS2aZK3LguZKch6uReEA=;
	b=LhSvE3C0H/8NuBCr3TZK279PTJm0Dx9eoYdAF2EzmKgTOXZZft4aKIfE2adl3ShuxsUvrG
	J4JrcRLrSG9rxIa1en7UqtTUS9wGu+PmgL0KLlFH6JRLKOIN6VrGyeKzASQMUR6a6lQmwC
	QjXw1symPid2f1ydLHtXy8IbVTRw4k4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/u5PWkt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35F886283D;
	Wed, 25 Nov 2026 11:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0131F000D0;
	Wed, 25 Nov 2026 11:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795604661;
	bh=bUA/rTYvpBA7QiSm2QIxyI9jS2aZK3LguZKch6uReEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/u5PWktp5kUyRuHcHkzj7sus+CpW2DeTbpNjtCetpIBLPYILSCpknyVhQtRr/DQt
	 aR38ubzw67fB+4RezvtuWdE/zgzAATh1emQrSrjFGeo3cinGGBMUPHaQs/DR01O2/o
	 C65jl9qlrrOcqGL02Tml+K/yS1E9kS3r/qDFRsQ6yx3aECBA5KFA+eeeXte2XXXT8P
	 RcI+5bK3PCFM5k4gig/bFtgdcnCCTTCUVrYzBCyr+DKoNvTnyjsTf/T36oT54BPSue
	 37usOl3yRSyKlP3ho4RxisxiECRsr4ydlSMegvN5j4y64D4aD+/lhzEa/b9yijPxFy
	 QhlOAO6sLV34A==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4] mm/memfd_luo: don't use memfd_pin_folios()
Date: Wed, 25 Nov 2026 13:04:15 +0200
Message-ID: <179560454433.2878567.12692470017046498393.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124184042.1823277-1-pratyush@kernel.org>
References: <20261124184042.1823277-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: B999C18000D
X-Stat-Signature: 4zryb8iigqz83hnkstdqkmuc71z7wwcu
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795604662-258922
X-HE-Meta: U2FsdGVkX18+07xZluX113URnyFHFArQmEkwbwJthUUXsJN9/5zTYw/gHL5rbPaWSJkasaPCUdsCmWoj9bLG377Uw+nl7pkh0le1fiFbWsLpd93p0C9ljgc+r1TKPCfe6PmCh9Gvh+v6I/JztrwltY6TBvOweXOzbP5YGJlXhIWRd/AKMumWVQwO5DC4oDd5LKwchixXjvOlD2MohGElUzUG54yQmo8gXEnMD1W6OhCKKmd3GhTw/yxUPA3ydMYbFXhcaKyMbbJfOxm/VbbqO3ih3ptVo6Cp7cSMMQw/4VkL1PLrzP1hbxduR+kr9JIlzwXSM+YD0e0xmWzKJ9TJXGfzBU8jC9QbmurDEWnc+4m1Ms6LG+p0NLn+x26VfY523dsMWgC21GiKqnkB6d+PfnG9V7IajxntGeYiBh9fkHYIjr+x07zqckJuoWJ0jPDDlqVizUVBkHOUU65EKl3l61LFdDcTAKe1k3PnuFR+fb2I3WYOtoxlvKY+Te484fT3y9T3XQpZT8AxcB8B4aDqA+DqFRdLoeXyMIQrIU6/R6fXKoE8mfySoD9t76dBnGyTd9lleoBofPivcRWi/5+yrfXVIDPRuZfWmh1wzxwBQV78tilV0s8hBcsBisUtj4/A2iKP4HbbM5sKS1a1nsDEzBaCNmu1d68za008KvJz/rXGMeutQpRrvPJ3jd/5/a1lrvDEvMeyquBVcdgfdUD2OHtOE6xt3zDVaLSk6AvToJulr26zotUiryXq+Yj92U6Air9hUKGwItVQuVa4dvDzHmTrZY2cGTCo8/EqL6DcrI110tqgRZ5uFxlOzTp41GFAPm7C6RzWGyyG0vvipvBUuAcEjROZFWLZzffrRhwPqJnVQeekqTBXG1OQMnhF0YBzyrM3zS8HNP1EjtxYbLaaIxEC2Cmv5ra6B6x+NTqJ6gy238MTRCriX76T93yJ6TombrePJ+7LN1EqSPin53m
 AdHkiLIA
 5EDwwEhnUW0+56MTyqhbIud1vHBhuxaKa6bkhLJ8/1Nfm7L2eXigiOlllvsC/41zRGphLrvfYIv7itACFtJQ5f7sXjqYUgSkXXBP2kMGTMPa0HTZw225b0dlr+oQ0+1of9luDuLiJfnM2A4Ws7uAEsrKUeGNOIjPywiHI1EbVPZ87LzEjpVpCli5IEJGB0c5GfT1xDEqiOegnqDIkPq8Mv7jNg9ve8sHhNg98LmdHq/rcVzNzWnI5lmRlJ2kYWEbA/gqqvELxiSGWzqTv4EdJcB4NTGLUajYMDvtXdUc9kJvg9tigyI5yRy/MCXUDBOXl0yTeEIjJV6b35DTIGoqF9iG4F3FdzpPfXT4kjoRlZ7g5jKs2DA1XS/SNZIB1R/SrHxdPFxNwedGlMLuaLEWLVxKESx9QpSs2U5UqedIJfR+3272nye6W0VqoSY3hfuNgvni9d5IzaG9IWO27+M2PqRvTLV9vhxara1whIjyMsEyX1L7zuVcNRXxQDJViC5jxyWZI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Tue, 24 Nov 2026 18:40:41 +0000, Pratyush Yadav wrote:
> memfd_luo takes a snapshot of the folios in the file's mapping. To make
> sure the snapshot does not go out of sync, it pins the folios in the
> file via memfd_pin_folios(). The pinning also migrates the folios out of
> MIGRATE_MOVABLE to make sure doesn't land in KHO boot memory or in a CMA
> region.
> 
> memfd_pin_folios() does not lock the folios. So it can race with
> shmem_writeout(). A folio returned by memfd_pin_folios() might already
> be in swap cache. This happens to work but is fragile. memfd_luo looks
> at folio flags and index on a folio that isn't in the memfd's page
> cache.
> 
> [...]

Applied to liveupdate-7.5 branch of liveupdate/linux.git tree, thanks!

[1/1] mm/memfd_luo: don't use memfd_pin_folios()
      commit: da08a6d97880dcda906bce04539ab25c98b0fb73

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: liveupdate-7.5

--
Sincerely yours,
Mike.


