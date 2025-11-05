Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F02CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4998E0008; Wed,  5 Nov 2025 04:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C558E0005; Wed,  5 Nov 2025 04:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9548E0008; Wed,  5 Nov 2025 04:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F03728E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:44:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 973C0140274
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:44:30 +0000 (UTC)
X-FDA: 84076068300.23.629BF89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D20DC100017
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:44:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sPcNwgIi;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762335868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSYtVYesPT+uPOSCEtsHnwsEoSoALSXmDXfYkOu/A/M=;
	b=h6jGZoSHmBc7moSZi+4dneQXUGntnXyHTAr3mPOmbnRo+ZMtorX5ac+PA7/YLwYZElW3Tx
	TvCwS39dmfRPcw2KcX8MdaCvII1vtiKw/QL1Fldof8T2SyaplHoYsT8+FFdT4cjhl5yywy
	Lxd7hUzgCJ+jjImXWwsOyg25VVipEpY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sPcNwgIi;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762335868; a=rsa-sha256;
	cv=none;
	b=RmoD3AA71paeqPQquHSFJIlPkD5iuusOz4xLLaUN8yLN9WDlRqr6jvK3n71GtRLl33oJSx
	BzfHgKPO9DontKSHsUCDTz6LdZB10xFPKP6FcONvB84XNvVwZ6xyePWg6MzA4Gmf+gO97c
	bNdFlKuGENdoNzMCDsmSBzcaV5sTjxs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93C3F40A07;
	Wed,  5 Nov 2025 09:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12BFC4CEF8;
	Wed,  5 Nov 2025 09:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762335867;
	bh=f3wFnyn7p1ibiWpNXb4gDEfB5F9l6iHTRscnD2GSoXY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=sPcNwgIiiVHovHHsqHZmZAIiEIWadNXqW6T9n9yqfpChf6SOVyUkgo7HYHSyxc5XK
	 e8HkW+LZT1vumMdFE2XHx4eJi+BZFM855xUeVfMIKfHpIc83km7fyBsVz2TOBVYHiU
	 4tofgurwBmk0+3xxiVWrfFQoNDTXYvV7C3I9vz3zMGgssfMUSs0cHKyVNJ4NaUV3cy
	 8sb1DJJ0IPdIe4cAgKNPLsqczRGm0rkgm71t3HnD61LO2UVbqDnbJiPvMmoxkVuX4H
	 YUMH208nwqYPuo6tSUy3abEdcIFsQUbEFUzzJgT2EPKTPqvJrRxVahDt6HK2xoFWiW
	 p1TJe/OZD4NzA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Changyuan Lyu <changyuanl@google.com>,  Jonathan Corbet <corbet@lwn.net>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-doc@vger.kernel.org,  kernel-janitors@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: extend file entry in KHO to include
 subdirectories
In-Reply-To: <20251104143238.119803-1-lukas.bulwahn@redhat.com> (Lukas
	Bulwahn's message of "Tue, 4 Nov 2025 15:32:38 +0100")
References: <20251104143238.119803-1-lukas.bulwahn@redhat.com>
Date: Wed, 05 Nov 2025 10:44:24 +0100
Message-ID: <mafs0y0okbypz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D20DC100017
X-Stat-Signature: 7zw6btd91up7wibnjxpbbj1sq1sjrsxs
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762335868-683509
X-HE-Meta: U2FsdGVkX1+jTmZPkrp41+tucZDS2WnCEg8dIDS/A+9LcIbXZeiaIyyxRQsCCmmIh+GlBJ3Y+JraV8WJuQRf3mVgegppEVY16yWptL01d9j9Wkzc5JfxOa52a3N3NsRWg3G9sc/oIeRQSxwaMpyxSU0XDWjRpSEUBIMQ/4KPet1+PAPeKBiTVdps9pWxaadQvjumvTFxn94i0GSPuOA8/8eS2cdHGuwbzulqHygHx59D7zfGHsdCVa1WCmA69/nOtsTeczj98S3xi9ZTu5tg8uvxAn3mvbHbWKGnuOalIvj02OjgF1BSbtatkH1OJzc0+Dyyn/z5LEXlYXyI8zb5IM/CTBJsIa+ZM1A8ovha87i9qWS8Xbi1AgK7/rpnIDWx+xcy3ZDfdwxsE+CAoNYpnXGYqRhFvi8VDzpPUX5YK/Mv1zpk4b/kIqO8239aCS5x97HgjD2KQPpnl+U9UqQIMFni2/qH7vfQrqOGMeOKfUBqXEOWk1s0GQYa+7p1AaM6TeWCgqLk5+8EOu8Ijy1Ip710b+AgSgX8Bho1/RqFa0JZ2RGL+7aqY7ZWZ2fT6+kVBe31m7VNSCWNK97H9FqqmMNtCQ/rni4Z/P22l+iIAKeRqtUlMVpTrTvo9Q7xYbd7EPVCyU54ylI7T2LgPNJmjGr7S2KLULYgtNX24cBzC5g8065MOiXN2l8mlCpEUpmMX04+GNHZuRbiXLDhN7gEDrjUqb2jk6wYhW99oimpnsL+83PJUUBzoBRmb5hgZK7q6TlCP0BS5+wnopmOwiUBdaAH95IFZd+F1Da1Vlhg5ZvO1OHlsooOLRIEEc0mcdOGiSstnUYzG49x9aZblfOnGNsCa3KEBnN/JgdT7dteX8poQBnvBjuQ0cNOMu6PVQUH1+JoBRMxvm1kTZUCipMSuCH56IJKX9jk8a7r1k3FagQ4A332Ru8pSoziA/ik4GnhlXqfkFtB9MZKhhaBhcd
 cWGY9Qz0
 LH6s/f6kSWdaKQJ6KwOF6fC23mDMi2L7iYPRJkeh1uDPc+v5IG95tzmir/xprf0YSCxdyXOL54SNXqsryl+/sKRNyh1KHltfNI11HnjWpf4Z0BKdtnIfExDFuYPT98sUVYmZwS3O9tl4hYF1pRPtVHNMCt7gGepbUH1zOzbZOlXaLUdaAhNH1tGuxyNk+4adVduuuhI5ZM3sfpC/8A/UoSCel2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04 2025, Lukas Bulwahn wrote:

> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
>
> Commit 3498209ff64e ("Documentation: add documentation for KHO") adds the
> file entry for 'Documentation/core-api/kho/*'. The asterisk in the end
> means that all files in kho are included, but not files in its
> subdirectories below.
> Hence, the files under Documentation/core-api/kho/bindings/ are not
> considered part of KHO, and get_maintainers.pl does not necessarily add the
> KHO maintainers to the recipients of patches to those files. Probably, this
> is not intended, though, and it was simply an oversight of the detailed
> semantics of such file entries.
>
> Make the file entry to include the subdirectories of
> Documentation/core-api/kho/.
>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

