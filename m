Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4DF8CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67798E0003; Thu, 23 Oct 2025 03:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18388E0002; Thu, 23 Oct 2025 03:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DF28E0003; Thu, 23 Oct 2025 03:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4A88E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:32:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65D64BCB16
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:32:42 +0000 (UTC)
X-FDA: 84028561764.16.93C5A19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B2A0D40004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:32:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sSVEX1BB;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761204760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9qKyvCICXiMFj2pY1R/TTIeWn9g2fNIwZn/seenBJk=;
	b=cOsVnWhfhXQWKdIBcNY6j9iN9fKRjcGM+SX2rGl6D1nISYQzAtcbdR5ok7Tq5etVlMwhAE
	JGpBJ5WCcyyJWlQkEPV7dpw7pSOxmPgkewsM9NsGobU/Sq8lhleRRPdB8hBjHVjy8gxHqS
	NFzAUBv4X09Us4B10sjKrxWQFRCNR1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761204760; a=rsa-sha256;
	cv=none;
	b=Ef5x5mKKEtFvM+IbwCJTlTp0RIIxhW3AVLLU5t2Sb6FoAW73yOcRsJGMpH1eR2FMoyGiM0
	n7r4/uuP20Oq2md4CSI/qMDHqw/EcJUmoo4DcAcB3lXuJs/QBUnW70/kiy0mGtSmhOl0l7
	ZZ4GH3YjxJSZt8b+qRuLIBfg8zAVXyo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sSVEX1BB;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86918438B0;
	Thu, 23 Oct 2025 07:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE07C4CEE7;
	Thu, 23 Oct 2025 07:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761204759;
	bh=xRBUS1TSJmYzQmrk1wiwXar89QSiUa7yMM1lGDC//6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sSVEX1BBZL4EYdbXIK7/OYABoeTs33pNLOL4VV35XeFw/ynPTswqUL5/NiYHEtnm5
	 KsI4LwXerl2sJJDuGj3B4MZcs7PJy0PW3UKfBWjAUVYrr3BckXvbH/QEbg8Yttq27x
	 yIkzONzrDTTft0S55AHtDG+rhA52K8r7D2fq+KFT33X3hGPBEIMwc8utSoiFtot6Y2
	 k86br29Ap5DZaKWQ4yyfxuTMG9U4DFTGSDtrKKp25sEL6AwmYMsSylxMQTrAI/Ac5L
	 fkwJhYwjN0wgEQKOXwsyeZ7Hr+1VDsTM7XEQfzR8CaZ52eWi7hP5YxJv96liuba/n5
	 Dh3mwCE04ANGQ==
Date: Thu, 23 Oct 2025 10:32:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCHv7 7/7] liveupdate: kho: move kho debugfs directory to
 liveupdate
Message-ID: <aPnaDxwkvEKAFlRO@kernel.org>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-8-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022005719.3670224-8-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 1br5tzebme6a66mqersfok4m9jfwr4pk
X-Rspam-User: 
X-Rspamd-Queue-Id: B2A0D40004
X-HE-Tag: 1761204760-704287
X-HE-Meta: U2FsdGVkX1/Kwz00UVWNtx4Q4cVVZAW0lhEHt8eH7KMzmTeaGsNmpa8uZmwg4lOYw37/C90UEHBYhQwXH3Yx65AI3NQ5XQrfd7EBZ5+cr2Zg8G1qX3LWSENU0v5agm9uzS0GmTc57qFHP3tQefZbmvK+rpB8JIwiIjc1dcevZi4+ucVQb9enh5SsYjhOq501Js+L2qHDPBr3uyasKEEUwGgiW6urE0J+xvUVXJoVaTSYPFwCRFrjnELiA1VbFA9Du0ZjxJVy6NlIhrBaDxViQdlJEvr6MsEZds09xJne+et+0yqp+P19g1UXt3JeVpCcH0ZYesPltlChxpA9Ts+Aui/1A6isvcwS72URmtZRvEwPbOB+x265J1NVHridLPC4eHuy9FFf0vau10s5g4664JZvrxOMR3AkiU2VapkKFOAJgTkn8MBTXENdOCndVRYHGmXasdgCj/4QQAi8X0AtM4sdLgxVqFGGtxXK/6d8OXLw/fIerS/s7GaRQxmTJkqfJ/IFh/lKbz+iqRq+1ro4Ql0EzNCSfdssn9FOnrVmUepcpjqdizB8zusKlqiN5oyOT9/kP1m4lKpTyOqSNs1WRH635NBz7lAE2CtBmddlTf1bj8+fubNBaNHenTmDwCU+565nCxLuqFI/IBo2x4XJy9wqajBmsCRfUApvXeJD31gpwxXfv2UeMOFIEUllNgiprZoYrmodppMZC5ZHqYn4tJxIq6Dcmi3jteplyOsqabo0h4oGDFp/OI6VqJN7b2X7A2cDraGg4NQbC0tmJZ3SMwIG2taiuRt2wlkqJ/p+2tzDbjPfxUVIafgnhFrcyphf2lTNiUBpLcJ4+dQ/gXy5lrT0XzCU20uj4lTapFBJ2Q2eV/GiMLCl/wvFDET/wl+n/BROyYM/cQ7xAglAACrs819qQFNbnGGleJHuZ4Alea80jcAVgdA9BKysiI9T0EXp5WBikQRet3pfIAQm3DY
 rrmIWUSi
 BXy17/vdYVx00JkVOISSFWZSLMxqND1vnLbHBNeBkC8dDb7bRNjPBgSIoxmNd4mNzkz5RJ7NYrADIaAtcVe9RYbj0NIVnVagTtgEROCl4jde0flkvH63d8vy6hC2yj0eGrDGcLU5EV5fXfrgIxGCk5WTEv4GK78xFeZ2Bef3WkLDJ5y83iENhk91SD+hqb6P+JK9nnU16VcqsJAOzkYrlgTD/YSm/+BGX8A/e1BqTKHyJkwei4TO4qa67YsQBdYSknUtT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 08:57:19PM -0400, Pasha Tatashin wrote:
> Now, that LUO and KHO both live under kernel/liveupdate, it makes
> sense to also move the kho debugfs files to liveupdate/

But we don't have LUO yet :/
 
> The old names:
> /sys/kernel/debug/kho/out/
> /sys/kernel/debug/kho/in/
> 
> The new names:
> /sys/kernel/debug/liveupdate/kho_out/
> /sys/kernel/debug/liveupdate/kho_in/
> 
> Also, export the liveupdate_debufs_root, so future LUO selftests could
> use it as well.

Let's postpone this change until then.
TBH, I don't see anything wrong with KHO and LUO selftest debugfs files living at the top
level, i.e

/sys/kernel/debug/kho/
/sys/kernel/debug/luo_selftest

-- 
Sincerely yours,
Mike.

