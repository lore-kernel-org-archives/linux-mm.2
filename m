Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276E3C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117336B00A1; Mon, 24 Aug 2026 11:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF6F6B00A2; Mon, 24 Aug 2026 11:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F208C6B00A3; Mon, 24 Aug 2026 11:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE8C26B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:19:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50229A139E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:19:40 +0000 (UTC)
X-FDA: 85136522520.05.0233DD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5BA8920008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:19:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LC36phps;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787584778;
	b=FYDbm+HId/3XcRlD7U3m34fGXogL5/559OpGF+q2haw3srIr2n7PZf6zSywdQEHJoxtlpm
	2kxQhTCGqYLdr6OckIM38yxYUUQteqg1puPhqTV9G+w5MPwtNXGPQw+Q7Nd1SEGUW3VLrd
	WHOMrnL7bFbVoyKg7jbZj/noGLgeFtY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LC36phps;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhObASzU+IfR0vAcTNmjdJh1v1AW8fzRga8XEXTHVUA=;
	b=sDDARIJ5m45zgvh7lcS4KbBVhNNkSxy80foyjdB+p2B7GG987kmT+8b9slT3NcRQrq5WnS
	G8U0gJtACmqn9aZ4m+8H1JOe7IpemmnvZw2Rqk9v/uv/0eebATOprx5KMOCLAY0wmEBXMm
	2pvYtZN509TJJCyM6XNYqbj+ozPD21M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 801D543653;
	Mon, 24 Aug 2026 15:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AAD1F00A3A;
	Mon, 24 Aug 2026 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787584777;
	bh=KhObASzU+IfR0vAcTNmjdJh1v1AW8fzRga8XEXTHVUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LC36phpszc3Om6N/zbMxn3qMAaW69FAFVObEdERNIgzHvNnwi6kqgufIEU7/UIWsY
	 krth0vZ8KBkoVR2jhi20myZTjDkhMfwj0bh8fKkFO6Cq9jtg6P6nCbqcFUV5jB7MMH
	 Atx4872f1nd1YEddLkLsnZfeA38+HMzpmURbmib3a6OO3LnOhDaSE6pNJTv9+0hTPy
	 Bjrgk9LvrsETUGXLygWv5zpQuxjCVbMH3s6RiwLjTKFOe+Ay7EtwFS2q3XS1NpfRKm
	 8Z0HQsSlyzqvXZSW1e+1oD5IZQqNP9BmPLOW+iaXG9B3F2Jb6iX1rSTgDIYMg+P6Xp
	 8/2udBbC4RLrw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2CABF1980064;
	Mon, 24 Aug 2026 11:19:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 24 Aug 2026 11:19:35 -0400
X-ME-Sender: <xms:BGGMatyGyn3hvJEAL0fFVjsBYh6gFUw65lsJrw_6381KetY-a1qxIg>
    <xme:BGGMalHPhb2XHbU2FL6zGJT2A6yE8C808HEMrw-XsTFRzBkkDK8YaH-6SScXzeiTF
    cj3wzC4PcJqjEIF5c2m5qGUfrfw6Yyhf-ybFPELzuLx8ScJvRHuino9>
X-ME-Received: <xmr:BGGMaiukLLHf90eQribcfkvQllhnvFKo9aofwwJhz8uPgwNUtUoji80uTlc>
X-ME-Proxy-Cause: dmFkZTGmehEwlTpaGnlMoJpjXQ7nDLGKNpzYXa2GqgT7N6wq+ruWxFOqugBXByk4sBfObp
    8DXKoBbmhM2FrtuaF9WZfWUm/XSEbXQJrXuwkZA4vndDzrBzxGCewc1r+D79yU3xB5jMSa
    B+LVxfNdjqdsuQZAIZKPCnVgEizP998OPUYROmwf7705WA1lsJP0FTniXw+j+FTLaPgO0N
    pd/+oAYahWf/yETAcvBK1S8P36SGEYc0d+vgfJCIyGHc08xJ91rRcqKCNPSEZn0qz0TbQ4
    K8qMxtX4Mw5iXxoWJmcxU6EWREGiIjkBV6LuhbNuw0VpdhCn2mkDjHa2YQj/22JhnN6oEm
    4gxVYethYAkikekOYpmmy2wE+3KgV9l0KZncUeQMPVLxTPopcHk7B/t0+PqwsnOycNBrd8
    vq6icxUXHj7Jja6KFHTxcBoUZDXTm8d53gqsszOR2pEv5+etleh6hqokwfs/29Ugy955AD
    ofBgQAbcPGVZP95X6cOumcWEZoV4/S7+8hr5oxlRtC2g5pwOGUXxs6/iwmqb4/tH9V25nL
    73WPOd3sIE52G6iY59hh2iDy+8Xk/ff8vm/m/EawJVtYutWKH2BHuPh7Vw9D8veAMwYHqW
    IEoiv74acRu1a4kH5h9pzMzAk3ntTtdu3nf9xvRv3t3no9eU5wynopTneZKw
X-ME-Proxy: <xmx:BGGMapXg6FcpXm7Cm04GaXfUrtCknQ9pxDcfaUReND3l7ZNV_Ah3sA>
    <xmx:BGGMai6vp9i2vWDcbOdl3gqXrclWdmYwbf4bGbwOm_kT_osDA1thtA>
    <xmx:BGGMatZTApO_0kD9vDLGKSJP-KmLtAz0lFDL5oYGcOjIy26EW-hXaA>
    <xmx:BGGMamBVp9A3SqBBtHKv3fZdBI1PIl_5cHBIM1ar4qVw-wYmajWJfA>
    <xmx:BGGMaupDZcb_xUq5ERgNzieAYNoVrTFRpliEkJTvATSIEQPawMJm24EX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 11:19:32 -0400 (EDT)
Date: Mon, 24 Aug 2026 16:19:31 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aoxgwbsdy0H1OSBm@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
 <aohldTtzE2GJ76md@thinkstation>
 <aoh-3XJw82O8SmsA@gmail.com>
 <aowcYuXEeqdfHmn6@thinkstation>
 <aow_bfUQWZWh7Kxb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aow_bfUQWZWh7Kxb@gmail.com>
X-Rspamd-Queue-Id: 5BA8920008
X-Rspam-User: 
X-Stat-Signature: pyxhghest58uhdj911gn7izt4o4pqucp
X-Rspamd-Server: rspam06
X-HE-Tag: 1787584778-885592
X-HE-Meta: U2FsdGVkX1/aDvGYC7tYRkCt0IW5cQhL8/LTcNfCe8jiKfsr0ZdW3q+FnnntXi2p+pv294GCjYeBp2IQ0JbknzRHefY/l8xPXzgvfNYesmVwuiRnBKdbSSamZyWGCYFrDpTa0gZDXufK87qv6yrvoL8XKIi/OAF21zEqrwXtaBDJ3a0e0FodldwMsJepoj0Aa42Bc9dOrLCGCls6vobq3UJusW50oqBE7eWxC471dgiYe4HXcqI5Le2we/L5ejb8lNzaphsrBnKaOMq5FHBQ1vOx68Gx8XXK63cS+q9MbG38cqbCgGt1VIJjBfLe0OGHyU0rphbTJ5gmnfgOMpjXHVPBmGu/sYQ2OA/0eZt9bjNZBRCM39prRuLj1Q/uE1DTnjv67eCcVtpfNuM0vPr+8DVrKNRlraVD8+ioXmJaAOUCVcS1Ljml5rYEH3jJZBEvQdQ24hatmg5iUVuVqqTh/oRFTPlbgUmGx+e7KQStwfWb7xBFqjDjdddA3qJgPf6goh+CWZsvs+aPmt7+aiDYk7Y/Cw4asrs1ct8fX/VXm7gIkOJ+4Y+iY0u53beQ1sFubXSFclOQqrru6OgVCG6lRRpIUV/V3jY4pEiRxogHgBC97Vj4v5boRtHWTjz+5Hxi4qGTB//m2mYGHU0Lk8MhjgnJWzsVV2fy48VIWBhUzggg3gG2dWC5tNrlcVCgUy2p4QcBKnHe2WNolNXQitcoHpfiKH3BKUiA/ykr18+Co/8kyb3mYcraG+cIV5Nh/wUuvzW5A5j6YFInMM5oShS5PB3R+JSyYb4QuHCu7YvasThLZ/A7/+LagXnJ6p0xdG9rmgYduLGyEzyAcpHPZAbOJ/OTMWcWDicGe11gqqhV2XzWDvL1PSU20zP7uk6CRHjpZW2JjcxyEoYwijFrofsPT7JHtc5OiMl2h2rz/r2fX7k2cjt3VfpAYRFfYW/zY3Gykg4UCqOUoSEpWG8bF+/
 1O9fQmDr
 SHOESCuywNnLyBf12/KKaJaFiiQ+X1PYl7clJFHMcNDqIdmo6BZyIbVoUfYblNnI3g/0OA05cAkG827J8Ne3PNG4zGWIVt1RRwAtxla/bD4nMRqdDBRJFENZPCJKPBzWZ5zHQxMm2aU8CMEOEUF66b0Q1ku/Mh8LTtYEmKnElyRfnwMm6jQ/gETXFgrDhp854PWTC2O4HULguvAyQnigPgjo42Jh6U7pIo7aKA005qbCxRP/W79YdukTCWVNmr/Cm0XvA4DAEvQok0hqQLpSH0uj2h2UBLbJAGgZ+c05D97TRKmfuRcgfdmBoo9ls1Ai8fLRIBHyd8uFEYtGW+8A3cQlWMfrhZX+29vRP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 06:03:05AM -0700, Breno Leitao wrote:
> Yea, this seems better in fact. Let me know if that matches what you
> had in mind.

Yes!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

