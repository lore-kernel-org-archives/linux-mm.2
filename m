Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5E4D6AAF1
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 16:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0166B008A; Thu,  2 Apr 2026 12:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7915C6B008C; Thu,  2 Apr 2026 12:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7A46B0092; Thu,  2 Apr 2026 12:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C69C6B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:27:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0009AC2987
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:27:40 +0000 (UTC)
X-FDA: 84614146680.16.1A3915F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 56F47140005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:27:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V0AJPJph;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775147259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TR13+UmNP0XDrQPli4TL1B0J5V3Ei7O3Q5TOSo9+bLw=;
	b=ZF5sItxThFYZsgfIpiMXe18SEulbKQWvxTehNUz7odLSp8OzneUwvfMuVKgPZNOvDMPqmQ
	y5XZbBy6jJDYNjRfrPozp8GL+HZNvwIBqsIrOHu4fbGFWGVKnThcDPEkAmQ5/vjuh3Caeq
	CCuAzlLnrvG97YlSdknxzm1C6LOG6Q4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775147259; a=rsa-sha256;
	cv=none;
	b=uAO3Z6OwoXbyjf3dQs3hOQYTAoIw0rqMZ4VxCPZyVLOoRisF0i0gC1FqPDp2e4NIgL7DWs
	Z/MO9AOYDFvfJQwP4jxoHNiWlG430MwPt9LJ+igw0f2zMQ11lAesV0mNp0wfVn8RY5rB14
	RKeddsvZrL8q/npL8yEeQhhixSBI9DE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V0AJPJph;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F2C94194B;
	Thu,  2 Apr 2026 16:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450E7C19424;
	Thu,  2 Apr 2026 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775147258;
	bh=Z61IRcinV1bLPq9E7pOsbX6b86Htif5YTJG6VYQte5U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=V0AJPJphBCUJERSSNRpe/FlPuwcpojkFZm1Uj5oQKRhIJe2d8VvsThoJ5edQKkaRC
	 s6CeNiQZRxFYNTkVYBuiVpyHComYHva/LZ15VwsJQHmCbNaS2XDHPUu5l7t1x8ZZJj
	 FbfdMCrTug/qNGmRo63c9VBmQLJFA4XbKMxcSRrVl3sFb0Iww2I4fjC1WEhJYJc0RT
	 zS5bl0h6Jvv7CuzCPurt3TGbwTHOJR7CJJtZWUcfkmP2rs41XFQeYpNww5ZZeCCFbq
	 cG8FoR2iwwoKcBiQQeGqE/c4wSc7wrj2sLIZi3W38V3T+ezUTakxAybSa2oDe5DcoW
	 IwFQeMSXkZryg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 06/10] liveupdate: Remove luo_session_quiesce()
In-Reply-To: <20260327033335.696621-7-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:30 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-7-pasha.tatashin@soleen.com>
Date: Thu, 02 Apr 2026 16:27:34 +0000
Message-ID: <2vxz5x69fhu1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 56F47140005
X-Stat-Signature: msqg5ty9qbh53766ging8u9gitrjkpji
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775147259-735451
X-HE-Meta: U2FsdGVkX1/6wKCoFrz4gQeNqxvavrtVrWzLGyGbCxllTdYhwc5wWx4TyqNVeTvV5BR5qkvfJ8NXuH+3iP+Z23YiPoF6n7vkmWUfAk8uicoUZG46CzRJJnAJEbyNqLM+j1GGjWh3IsNeae0Ljl+V2BUGQqfC5xg3UgWZ37apDaV3TcihUlSmobm8hinWbXst9V4D7q7sIRdBZCE/UWvv/hxETojMoe7Rmy/JnkK2o8p5OdMyJgSEn++dxleYRUlNofbZ2uwU0a+TCrUr5gVE57wWCNCJklmUtCEhAERj6aemwEFQSnR6dgAcES/2KNrb54v0zxlVLtozvXyK4XZQIc59N/lhVGQ7TXCcHMShIH7HsIXORPy1j9ImGbAoc7C9Tbc0fm0xCbYSMkQk+JiUtchz+PZ1SWvpKd/vBsGGtQcNKAip7+syaOOFMYjNKbVqKOUzXKSZi5UJTFY5CgrjgNnLUR5cynGVc3ncJmNG9B07gmgCG6kwZdmfcTETuP/o5YAkqB6B3NJewLnOEIVa+XYh4MdSJ80uSn969i8o9P4IqvIGz84uobwcVpywws+8t7lwhFDBsDKTZp/AbC3KH/uIAUr2Gz32ZWM608sSthQ9VBWNvPCdbRJTGkol7wKh9wqoKbFMLBuv+hU71T192Mt8NQLZ0XZVnj/pTQwwn4A9ZEeSDGj09Wgk0Xtbx9VWg1YyP2LZfrPClT85pMA+Ijjna04pJzKRLKYt+YliqsNIvMMdvgqg5vYsqnQCTI5vjsMOFhGSK0Tqf+ViuwPEoI3OtKuXLcnu9z0jPMJzQp7jxHw7WGvlY8BvrsEVNJp4F0M2E5+LlpHPpQGK0jjFrKdu1xJ+HcFqJR4JajLazcapWW4kU3P3WsB7k4A/ffQkYEQRSamH5MNmiZQGlw4+8OEtIFqhO4u9IkYWk7TcxVzGxFk8EOYJ8gqbDnSaW3VdOZvTdzo2jVWCL58/9Js
 kncaVmpX
 G6UyuCwq39HZAZf9DZ+hj9hwZUB+t5GtSkPDKjg/tK6odPPxa+Pok0P7gzbDGH5wmzrrKugsvoFWZ8vU/ZvnEGFqakn4RU2TFUS9DywEZaWrWQMu+Qd8z5G6Mp0/YNw1yYM2+38JwEtmKhP8DNUfk+ftYZijAKNwBpDDf1w3XujC8FbDS7sArjb9cPcbltGlYbfrPzy3rs7x38eG+DsU71u8+ZsLSNDpRAKoPvByxc97Ye0w6vnrNc8Ai2jWF0IIBSTbFHsF5HKDJeGfYaewDxJ8HHLDaAD3xpFsgNionjatZBr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> Now that FLB module references are handled dynamically during active
> sessions, we can safely remove the luo_session_quiesce() and
> luo_session_resume() mechanism.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

