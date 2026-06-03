Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5674CCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5D86B0088; Wed,  3 Jun 2026 05:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99CAD6B008A; Wed,  3 Jun 2026 05:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D94E6B008C; Wed,  3 Jun 2026 05:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8125F6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:33:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30363161AA9
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:33:06 +0000 (UTC)
X-FDA: 84838087572.03.7778E00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8292740014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:33:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rx1cSpJl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780479183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3CPe9L+Xkc56uXDetG+lvovbz0JWP1jQopKoFbSJqc=;
	b=JaLZGwPSNKlygOMaEtDFcjSH3+j4cI1tRPX6hyZQ+qaJaf1wbc4/1ac5UwcErw+Hcplkz5
	bF1FjgTMc/GN/Bc5YiRoOjjaAFPAW72IUl3elcTJYH6vLBWbcGb+r2yp8n8gJWMBCE49t4
	xG4tvHDcdhvTjxPgR4uhp//muZrH+6E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rx1cSpJl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780479183;
	b=RTTcwpt3Y2ZOEt8EmMGLrKhKuTqMaSk+TrGYUpeD7lmlMkf8yOmcz41f0SxOxyA5VtKIJl
	qxisCXbIMH5wXVPJ3e/PbrUKbCxeTpBvpD9u3U+hj7+EcX2iCgViJ/w3rF97lCTvXMghUV
	d5qLuLgjMs2s4LE0PzO4QVANSnRuGVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE1B241AAF;
	Wed,  3 Jun 2026 09:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FAF1F00893;
	Wed,  3 Jun 2026 09:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780479182;
	bh=R3CPe9L+Xkc56uXDetG+lvovbz0JWP1jQopKoFbSJqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rx1cSpJlGAM0YKvGloDx4NCqR14Zez0e6wNchackcfyp3UWVdcBZSI9zTWDzbxJ9K
	 0bxYsTiuDHtW/iHnjIsxs7z7YmLa/cvEP67GMnbC5TqLxuuYjSd9o2npCUDV6PIt54
	 kYFUq53Ow4olqnLx+dT8XKv53t10rlH8/YbanQ4smjEdtkzz+MkZIos8WgrWvz8Hgv
	 GdrOWQQWdzDSFzD42zxtkp5aHFnN/hw/tz7d4s5PJ4OE4yrRKkGRclDGlKGRnYIs+2
	 4M9Mq4C9Ui6I3VnVRfzjhRHXZlFvXiHaWX4z0hcmznIOTu5avK9NWnL1AmPAJAPNMh
	 H47PAq9cno9jA==
Date: Wed, 3 Jun 2026 12:32:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v6 04/13] liveupdate: register luo_ser as KHO subtree
Message-ID: <ah_0xsPC_oNPewVk@kernel.org>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-5-pasha.tatashin@soleen.com>
 <178046942429.468621.9591914636403075487.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178046942429.468621.9591914636403075487.b4-review@b4>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8292740014
X-Stat-Signature: cporwfmi5t5zmxp4nh3e3xwaiocmbzde
X-Rspam-User: 
X-HE-Tag: 1780479183-436120
X-HE-Meta: U2FsdGVkX18iAGauNOkZBP8nWCo6lsO1DiDMqUGbYoeilOQQB7993WKoVHljXY7eGE8RTeorqvwLVW/gOQrJ9IIPM7Cy2H2D+XUFCP8FKkSMSdHBkiMpbFqEoTg3ozllSyS/Y2AUKN9YDZBPo5Z7xy1zsPgEIN90TP5MO50EAzAn50eHuvexUmBm2dEdmz9Zxlj3sV9Ya9VW7zRRhW89kzSeiTVlaTbxc1J5XgEVcrPgvx8zpgWffuwuWpPJLvKeIBo4jKGBBrSXVRnqUyP50QgxhD50lFg7JomixCSqLf5QiV26FqWuG2QQRdh5F/wNNNF9lVhH7mq6F2VugllVVgG5QFR5lMI7PPQ5oPoEJd5LSyhrQ/uiSr2XUkuvdmsmb6I9hC6AvBY+3Ozt2NtxU3rmFyBlKMF+LJs0M/nWAK1mCZLUYoJ/7aDbaoRhxHo0zbRngibAHKsTD76njK5eQE3Z/DlxqNdQcmL/wKTyEUu3zbTsWGp4h6cd8p+y2VD/hR6CsgM59X4cZTfYr0arSf74yOJ+/Re2hfSSONHnHtYZH5/Lo8yTXr5jlZjoXbeBeq/ppCU3i5V6FGpksZXrf4W4ge9+OqSPbjsv7wa4xGgRFnFZloTAKJa0YTNrSsYULn9IdUA+xyLnqcGq+PNbmPSjYzYWnbAwtfddH1qzRQuslg58ap922vLTr/moLTQfU8LzZMmE/NUn6lCvE7mcwqR0Vcz2QHLeXI2vSWZz9CYosA/YfEdkqBo+MXTsmxFrRQwdCNwvqtJrdybnDfqb/0HcpKkkAw7szuRXjJ7EWhArR2DstCmrE+0em7LKxT3DGUOnSsAznhIgOFcekRqqqp3oEXtfp+pUX8KpqoVCtb+/F0lpkRK9gJlJOFlaAHeHk8LfMaCA754BHeoeYvwDI0/SnRk7fZzIPzB+0wTvTDrG+7HBpExTxia/EWZ/gjSZTsIu02Q6t0Z9jBexzKN
 OWRVIC+4
 BLAeXGpPsTZsrcYVUXhbRGqHzIav05dHqT+oF8tbqce48s0nQId5nWGUIj7NsAfzZX4FKhJxGG2eUJ+0n8K1nH+PAPUIkNBvStAheezi9AqV50NMkpX8tiCTUKcYpA0V+n9rJoQEOez4iA0Nzp5uKkji/108+v3n92OY9+WErHyW9cpIy700Hwl4IaLx8hX8Are4Wl1B55TGclDZ3utj+BMwqddOug5ceY67axsM0wDyIeje2BLR8LxyGph0bsbNMSWQpNocH/FGgIEvrdOx4iuo5BMz21Oh9teDTJuUbWctQ+4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 09:50:24AM +0300, Mike Rapoport wrote:
> # Add your code comments below. There is no need to trim or delete
> # any existing content -- just insert your comments under the relevant
> # lines of code. Lines starting with "> " are quoted diff context and
> # lines starting with "| " are comments from other reviewers.
> # The final email will be reformatted automatically to include only
> # the sections that have your comments.
> #

looks like b4 review bug or misuse from my side :)

-- 
Sincerely yours,
Mike.

