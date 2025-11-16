Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA048CCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 15:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC808E000A; Sun, 16 Nov 2025 10:59:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ACE18E0005; Sun, 16 Nov 2025 10:59:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C27A8E000A; Sun, 16 Nov 2025 10:59:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4588E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:59:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14738140A27
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 15:59:37 +0000 (UTC)
X-FDA: 84116930394.08.6B78216
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8531FA0013
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 15:59:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZWaUOFXU;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763308775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNaXZ1HZ8quPBvDs3XIMOSEtH4XOOaS01RIwgPxaKpQ=;
	b=HyYeg+WOMxlOHxMtr9CxZCoVmrcNxRpjlfkEUZ52bKM4L7tW2yrfaiDcU+v8DdAVdtgYxv
	4nVZbqz2o0TLao93+inoOx/crHGs5RGCZSLHcf3Z5Yv6i+MBsfxLmTljDbpHc50H4FefkB
	LV/5Adm69SOrCFnHCl08j5OH36wmx3A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZWaUOFXU;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763308775; a=rsa-sha256;
	cv=none;
	b=qNHrB0rLSdIwxf2I1cI+d5m4YWU/sgl7ZemRxFqb1+Ne1k2r0OY5s3XGrZu1Jc+a32xbsC
	jIkunWSsJsqv+GIAxlMgFJP5FpumZHYRS9B/uGxeq2VG0z4Fol0iXS00+7+gqDNP7TLBMc
	xbs/dMOiGozjneEJviZUjQqBJyU6lPo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6C3D601B8;
	Sun, 16 Nov 2025 15:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA5EC116B1;
	Sun, 16 Nov 2025 15:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763308774;
	bh=N63MAb0KyWTLgugvwb02lWipwcFSizrU41RSsFJPrxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZWaUOFXU1BF3rtnMHUXnJqXBf72dlojluApzZ/78UYuVKYr9T2oylyFP7GB+G11gH
	 UnMiyzIsJDZJGxgAHLuOurbnbgvp9z0YFvfkPlCziPvqzt9POBKBSVowbZydBvv4L8
	 Vke+aEbM5uU0tCjHPEmm81FISLwm33JR+ozwEbSGICoFVW9DqdjymXc01WvzI6fCDp
	 UnF1MYAI6xhEalgiS4e+QhiKCI5r4BvNeWzpogS0s8JeczNSalPQkncHvFP/7JzvJT
	 /JxBMfvC/zxhS+MkhDAt7h1Lr22sSH29FWqWff2U0Tg9HoKb03p6HGpvwgwuGvNo2P
	 SocREtGkCs+lQ==
Date: Sun, 16 Nov 2025 17:59:28 +0200
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Christian Brauner <brauner@kernel.org>,
	Luca Boccassi <bluca@debian.org>,
	=?iso-8859-1?Q?St=E9phane?= Graber <stgraber@stgraber.org>
Subject: Re: FOSDEM 2026: Kernel Devroom CfP
Message-ID: <aRn04ARB1wFeL3_C@kernel.org>
References: <aRM6z7EU3sNljgx2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRM6z7EU3sNljgx2@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8531FA0013
X-Stat-Signature: mmaoabe9nh3qzmn3tkc6w19o1uewgzoe
X-Rspam-User: 
X-HE-Tag: 1763308775-558836
X-HE-Meta: U2FsdGVkX18r8DWAyEs3PUhjsZmno7t75SvU7Vds1YbE7T/RluzGSQTIXNk3Svp2vAZR6JrhezAtT4myCxzaXNR4HdBFe0VlzFTk0gRth5LyRc6OtFuOr77DJFcEFANFIiE2Yg5J8biyzn32FlRlTbAfLVAQsj3uGAxKTLENJKb4sJP6+GnTJ/7nbpSdpi0BWW1Cnu3kG/2xWBFth57xMwPspbT+fZehlah410xU2OZ3WQ6f5wtiSgRzBChguV2ea57HdlqjGIjZCse0eFJNnwSBpWuqhicfVBlobmmHjIaGg07kq52shjeKmt8CDafJkIkW2ELq5PX+N7gGU2Cssr3ekURDZyqEwCeryqL89fb9Wbn8isAvUJ5U4/ZwsqOKFZqbOJh6qsLc2TTV/Ru93heWHaQngWzxgImUGQVuC8wUerHPSGc/yRe5zKgHTVJj82RtJMgioUuvwbCBDelsNmVNsCPfe/hae5AB+jnwkXeERxZ8znE9LYqWWZ27O5F8PTJaBqYnR2izJlpgIPXZSMu+wLshrF8GEi/fqkxESGs3sNrYToL4STSdX0ylSF4D6vLsiNEBwg2AYq6DttzBwRrljPK1Qd/0QdzoIch7c8dRsGnpk6/8KSUiKLiMAA5zq8AViSL6+kSETDjmd2tCv33Z7y3jgNuprVe5B7e2SoezooLuTpnDiBjZBMYkn8FJPwg7T7O5nIKLMx2rQFSUzpZI+NFtdXOlj6Dg/jUEzYvZHioT+W4VZmdEyjZrIkMPtaisPKV232FGULJxu9RQYxH2QQwmJ43IdGSj0Isdshu2puOHi372egPNwT1aLN5gChPtLJVCCLKNuS9uUqMdBU+suMyjgKRb4zkEvxDhTWo1965ubkYYpkEk670JkN0lFAKrSX+G+0H9IVh4xXYNR+n5o4efboXUQfdTfb/rqyTx3xoU5mCZOzDCEisNs5tN0+ErPU3lqeGyMHyjFpe
 xMiv5Jfi
 oqLQGHLD+SHC3Unxv0iyf++D5TJ4PFJ7Mlyf3kvGI0rXXM7Y/6i+unzbCZFdHZE0dzWZavOI1qpOqEGuXE2ek0Db/TFkqRsthjhFmawXoaZZ/ejyB/gEGBf+aCxIYUJf/E1IHdNXjmrj1WvYk9NHj8zGYPBmfzPmQechjhF7QVlsRZMdFE/Y3GqWMDFyy/2AXqhIh2oaWDeFKxQC+B3/53KEp1Gh2grOIaqQcTU2GR6tb7eY57BSuOXmvVmQ+FxBUf32b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 03:31:59PM +0200, Mike Rapoport wrote:
> Hi all,
> 
> __The CfP deadline is Saturday, 10 December 2025.__

The CfP deadline is Wednesday, 10 December 2025 :)

-- 
Sincerely yours,
Mike.

