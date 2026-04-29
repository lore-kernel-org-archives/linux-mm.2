Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88037FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC276B0005; Wed, 29 Apr 2026 10:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3E06B0099; Wed, 29 Apr 2026 10:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01236B009B; Wed, 29 Apr 2026 10:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1E3F6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:24:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A00D14029A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:24:58 +0000 (UTC)
X-FDA: 84711815076.23.3150454
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D29E540005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:24:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jp9dPk3M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777472696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oU9QFXFcPvDnOm50j3Pr9oOfENDvi06AH/MQcGw529s=;
	b=BX6RNGTA4f67VnL7UaBnM+9xb6V9C3k+SSNpb0env7Wf8nfzl/W20QqqoihnZ8GzajAihG
	z78bL3fFa8DdlMNx+VnCbJbAX49SsfQa8d9ziyynmNayihlcG/khQ73d7/ynCY5s6K35l/
	6WMWzGzRVyyxaqSFa93LQLRcGQG3/Xk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777472696; a=rsa-sha256;
	cv=none;
	b=rQMmNc03Io7MyGrUbvl2megpnlEJwQ5aY13sVtj8X/K8KsXfRVbfCVuTmmi8QSAJ15+Hjk
	jfh/gNO/j5Mz4Kd7L9i4GvmZRsxryyQCSSfa4lp31/X0lHokZSXn43YYmei8z28vuhVOhN
	gPUsnK2mth1iEzSG4hydlcBHCjh6Y0I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jp9dPk3M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4392260139;
	Wed, 29 Apr 2026 14:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA85C19425;
	Wed, 29 Apr 2026 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472696;
	bh=aCaYorBUSCF6eWCfONlb1C+1m2mXwLSU1/j5XLbpFYc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jp9dPk3MOO+POyRPioFKm05l2fptu95ogwNuQm9g78vurqPNdFM+sJUhiBcUJ8tkd
	 wvPGOxSftrc5G2i+yHJaP/prNYYB1cmZGe3lY5S0ZqOG+sPjQ+LZzz5aKwwZ0pGDtg
	 qLMAzqmfCleA1b/q2FmLg3pHQrzamRwCm5FEuJIprZ8w907bcrsaoufQGgcUVUW/UL
	 cKEq47JXfnO5Kw51LsM6/alYX3PcWaxjr48iUAt9YyUE6NLSHcJAzjC9A+xp4LfEzN
	 1IdTssoGKiDtR1zCyLgeL1Jq4eKjptOwHqFUu46BJZ4GXpFR4+l/IdARlvrDB6+Rcy
	 T6mprKJI2BU2g==
From: Pratyush Yadav <pratyush@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org,  linux-mm@kvack.org,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/4] liveupdate: reject
 LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
In-Reply-To: <20260423234753.3873095-2-luca.boccassi@gmail.com> (luca
	boccassi's message of "Fri, 24 Apr 2026 00:44:20 +0100")
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
	<20260423234753.3873095-2-luca.boccassi@gmail.com>
Date: Wed, 29 Apr 2026 16:24:52 +0200
Message-ID: <2vxza4ul4zez.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: D29E540005
X-Rspamd-Server: rspam04
X-Stat-Signature: 7wkmiah6b8eexunqjnj3q8b3adamgtzn
X-HE-Tag: 1777472696-737770
X-HE-Meta: U2FsdGVkX1/ezOh49Oam5k5Ti6UGWtmoqrUAL7JnSvk4FztA6Nwtt5LkQ1F7eMVGlcweNzi9r2L9PjJMXW2KgZqvDREcIL+hd9OvDIoRBorPOZETKuDbRPtXRyqaPDHlSF8YTb60aIyQRbZsrMZoWx23y9RRmuYgZehsWyF2ZBhJ6f2dFWnp7k3E50Wg3o+NLaSTATw4dS/vmwwFvb7ibmaFOGMu6iK1as/aIugVGh3UBVkRVS35HHHB+RpE6A3AfqTa9i+md/CBTUx2EgyMwhWmX+lkVENz6bSP+Fe7P9WbCSEOa/4q4zkvw08YopTKhfGu72vpBRq92kS13uNidMKpO6+Vqy6lwt05PUCOsQ6GZ+Rxt+hnC9YgqUh+gcDmTj2zQRdS+zv5iZ2/3gRLkn3DOcHv9Tp8Wot3ii2P4y2fDtJRW7fXPPYIG63Zzf5xeKX1qabuMa2/iwl67xc+/Twe0BOvA1Oea9Rr6q//an6K931riHiTV/pFUMB+e/VwKaLX70TabY6Gt/tlSEAiisB1zm95yqS5alxQSAV5kSueZmsKLBd9OFuXmdTOLnV1v6ZYj8DaEtzYhxfYpYIDUTBU6ERZH0q61gUltG7o5rEeR3KHyXfWiCZPH+Zw420Msk7vsyBhNWkUW5AFuwB7ezly7Yw9L46uHefZNPBaKpRqitCu4lwd9x01sJeqXUQSd3CdnjYXlryF9DFFN+OW2emka+TQiINpAbyW30gl/wbXh6/R9aARyxYFLGqGLEvenmrgwuN4tW2hP4XvGhpELYciYx4dn/3GZ/1EtCh/ZejupaY7Gvf6CjkwKm0tT0f3jMBKvIdLdA6voMjaEmFV+Kqhv68JrUc8H6ssfQQgxfescAkidKoChhmnfrOKj8cEfVDOBFO1Fj4gYqlgO93/L1+mE6+PtfIUqf1e2FUiGmT9HgCQ9x2wyyPeuOlpBaTbjqRGrnHPtmPRnTA1F08
 6t9w3b9o
 one09aU8taA0C6Den0i+1Sq1Q5gV11m8jeJh7MLr8lFZhj5a/Kgk9KbPdQ6fbsthhdM415MrvKs8vIqJeyXL8yyDebIlQsE5B9Hz3zVNy5h06EzvXfcsYVdbI552GZzZHv9GJOAFo+4gSxAB/2idQabA9qmEfNLLc5gqO2TdFP3/HWQZ5IInjgmVAwUF58s39NFEnnImWtnLNJDMAWDgIAOIb0da8a09rIQ8R8BtMsGYsi3mFqRF86AqCuVIqcb/5oGHbO6nqW4a3ZVxSvhTKBVAPg5TfWmzvMoGMGLPnJifNptTtnpkC5AwMi2bgucHJW1/x+5CU8tE5uxaP1BMcKPZoWroeBaxjQzs+sRuaKVrUPui6PXzU/18EnyzInUk6FU7Z+RRHbDP69xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24 2026, luca.boccassi@gmail.com wrote:

> From: Luca Boccassi <luca.boccassi@gmail.com>
>
> A session name must not be an empty string, and must not exceed the
> maximum size define in the uapi header, including null termination.
>
> Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
>
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Cc: stable?

[...]

-- 
Regards,
Pratyush Yadav

