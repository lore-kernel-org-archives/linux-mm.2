Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7882FFD2D87
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 13:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19646B00D8; Tue, 10 Mar 2026 09:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7406B00D9; Tue, 10 Mar 2026 09:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5A36B00DA; Tue, 10 Mar 2026 09:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6896B00D8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:34:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31608B6531
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:34:04 +0000 (UTC)
X-FDA: 84530246808.21.16590ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 948A240003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:34:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gbboZny9;
	spf=pass (imf04.hostedemail.com: domain of lee@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lee@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773149642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJ66tlRJGWcr6zQKUuqut9b4VgLqQ75FULJQ++XQI3c=;
	b=6oGLAA1axWuqlGudQqpsfcOinrW8VyncRwBm3jiTIMVYvV1s952u2lx/XsxbPQdaOJ81zL
	6MDCEL+p3E0GJ/iye0OCBZdpiVpqrg9WX4XnBmDBeg9GvleVaAp2zJtM1mtTEIIR3m4Ntr
	cXKSLzSsyTtBjXJe+1yWnfB0LB1nJWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773149642; a=rsa-sha256;
	cv=none;
	b=pSkAtM1LOQuXXpKdX4dH++/L17JBahb9+wFHu247c/nm/lIuPZ3ILMmJ+B7zxelayg1vx2
	Xed8lLGitbnYqWkImKcagY9C01vbvLljvnK5fP3tzmt8zpH7qley/AAl9WJcWMnoGRyf6z
	/59x5O0ZoY0PrhuixTTqbiorNhwi9F4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gbboZny9;
	spf=pass (imf04.hostedemail.com: domain of lee@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lee@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DBB2D60054;
	Tue, 10 Mar 2026 13:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1338AC19423;
	Tue, 10 Mar 2026 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773149641;
	bh=1YnmztTcNk3Ff+PgeiUurE/Sk941AjWRBcXze9NtmZ0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=gbboZny9vDD72Pka+n0iXs0baByjKbSZoFC4cppvyGvi6DURLPzP7/PURy6H4x0SE
	 hZcTDQvWtiIR96dUWEkTSxfg7YW1/icauTRQtPPhn3DjatNJnXXgx9ePr2EFS/J1xE
	 m2MZHJen8/8vAxVjX4Rh0mvAwOneBCTEICPjlkx0jZOCBN/iedVV5+9QBqwIzFk1vO
	 tVOWY5YqoR5nPBwka2P8esnXtwU65aqvGrom7R8xo/zbp7HcZsAU1Ct1Z6jDsVgPm9
	 q6q+cosYNG9tKwHqU9XoTXUFgoVy3XzQYbAwRSYwrOvATdzUAyZiFt5O4W3gYPYlF6
	 gVdqFVkFvSybA==
From: Lee Jones <lee@kernel.org>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>
In-Reply-To: <20260310-b4-is_err_or_null-v1-51-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-51-bd63b656022d@avm.de>
Subject: Re: (subset) [PATCH 51/61] leds: Prefer IS_ERR_OR_NULL over manual
 NULL check
Message-Id: <177314963081.2226692.3105447886678957300.b4-ty@kernel.org>
Date: Tue, 10 Mar 2026 13:33:50 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15-dev-52d38
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 948A240003
X-Stat-Signature: uqhfzwqjrxp4rcgas6k8h48kqdxpfrme
X-HE-Tag: 1773149642-343891
X-HE-Meta: U2FsdGVkX1+EYk9EsOgeHXwkMgFFQ1FDZd3/77wNjt7LJLLbnirCUg/hi2YFofUCnLM9wlrHNyNGssglkPYO5+7IXM1IrO1XFJLGMMUJBaBpQqg0zZf61Yuj6nrS834kTU5YQz6zROHsJOaFxB0C7O/bsoY3E82jcKJXlTgRfTmRct6zXlaYS6BhbFX6gOowL3eDjECipsyF4pHetCJ0eAXVpdf5zoF9EIf9h7ROAbVi19JpT2fi990uICMze7xitMuDGERFZG2/zfhFxkSpKleA/04T2MWQFDrJULCZCiLl3hqTStc02styvuLy6DD9ix2pwa/qA4XUI+RNeARBsW53IfC7Oumig7xrcnjhVzhkI2UnAri9l3osDVoznf2hnk2g08/WTtoXjZAKfGs1t2mhbVcy+hJVjoWt236py+GBkeVXtswZGBBnqM7t/WGzDyNiQqAGPdFqiQ0W5y70wRcZ9oaboQrW4Q/Xt+HioCLywihYoi2+JXn1EFH+VCfaGOAs9l/Nh2FHrdk9tkecDP1vAzyLuEHxcn0/irxaYJgZHjQ3slUWXf+Q01zr8wTPNu0I+OzPAdxifj6jjl3nqhL8PSnNc13zqz2A+Q4yQsMW4RXoU+bYvN6jqnUtmgKOmbclnDk6nhM1Iehj9yFmKR6P3yT77JiKMC8tJu8fmNqR8Kd7fm9cGNiCUGsbOMT9m/V424xbhPBbrfRJuQDc0xM+wFFoMCBNsobJyS6uivoV5a5IK6jWg4tdlBDxGpUgbPtyumQENiBMbhQJuTAHRAi6dMUezrTr82aMNJpAOQeST4TYsJY03k5W8cjV0aV103EMhYuKUymf9YcM8ENo54gqBLV/jANizd68XDlEwf4sTdxlwrMs85/1zjUTAETnfXGdU/kOqclUDxWFZ7+DSXRL078vHkWw/MPQWnckT4tHepbnb+dfd35DHN8Wgb5sv53lcXVD/fV3qq3LhvC
 1Rvyyo78
 o09epJskXP4xTS+SVwFJ9FD2aTEtOSj8ZaEfCMVgV1qlrCUzUL35zDmKN4oB+A7z9gQtO5bgOuJw7EooPy2nqBg1KWbdcQYikpgPH3pj9cqvmdvEnTi8/HioSCwg8q5eZxO9C+y9HOXI0ot4N0y/L1/lA/K9AtxtwgYpgCWX6iMRNmYdPBrdsP+DlLY1llRfed4dsomifzhRKEMg6X2k738B+TYq4+ymZ5DkEsd66AhqtyM4tteLoKXSp5yr16lJdumNCNdOzZxWzDgMCq8TE59Fe7e6fZSDBYc0QljtXhEaGOzr/qdCBDvwhGR+Lc+C40lCWk4GERtnx2qY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 12:49:17 +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Change generated with coccinelle.
> 
> 

Applied, thanks!

[51/61] leds: Prefer IS_ERR_OR_NULL over manual NULL check
        commit: e68f95a51d1a8c1594b536c4d495cbea38d47561

--
Lee Jones [李琼斯]


