Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE200CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519686B0095; Sun, 17 May 2026 13:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BC46B0096; Sun, 17 May 2026 13:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C6A6B0098; Sun, 17 May 2026 13:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25F8C6B0095
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:34:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C246B161148
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:34:09 +0000 (UTC)
X-FDA: 84777610218.26.0A21732
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26036120011
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:34:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ1GvY8f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779039248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWBCWLK4YOKW66OmMF+gPXIJouaI8UPNNLHz8oyf5m4=;
	b=PBsA7ZvLtMujSw4Aqk2dejH72jlsoQwUK+MZ6anFlm06jPsLO5nTmRvU9i3sZ98/iv/sBv
	scglR9cDXBnqCVVI53eSBmfog2uVX7zysmvQ5iiBdSMbi7xX821ISUnFWJ9qcBusS57lIs
	6fml9dkbPIVYVk+Ia14FHpIy3sk4gWY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779039248; a=rsa-sha256;
	cv=none;
	b=uWIKniKEWMVU8CT5ic5mjZx2ONEkL6n68RWwimNEKOq1RPlomJF+77QYFCQwk77XVPnlmt
	BhJNly8DREPY/o63zRukf3jfuvF0d+ikBZhKuYkVxo06RhKcpRvse+TIkmsuRtFLsPYAnz
	abt11NbgQG/DBuj4ay/AO/DyJeRPt5E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ1GvY8f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08C5142A3C;
	Sun, 17 May 2026 17:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CC3C2BCB0;
	Sun, 17 May 2026 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779039246;
	bh=b1CihbG6Lv3rAko83KCLGmjfW/rZKCyOv9GyH40QTlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LZ1GvY8fdnO+l/zGvP4VDMRnDRsgS23EQXBw0Bhc9SCHNm2fQe7oCHrcfFa0Yayt8
	 4KLpNnniSchkf2IFw75iOUdlxhDlHwo1IIpx/7a/KudFTColN2WspHtOZnrvS/UbHN
	 MIxGswkl9C8QFvcc4zHB4n91IvOS45YuDM8TL0EVJbH6u0O1x4aGLtDsaA9VLfniHP
	 0PyAgLzCHJBByLBAs2QRtW1r1z94kc25XwF+iv4PgVhf1p5BT1yJjHpt2O2mOksKSo
	 53r3aUZnlbpowcIbUScvst4A/x4U6s+WapVuJwS8oLIrkSq0K/0YtK9/WVbPs4gjPA
	 dPI8qsdP8mfxw==
Date: Sun, 17 May 2026 20:33:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 07/10] liveupdate: Remove limit on the number of files
 per session
Message-ID: <agn8B_OIH1fQjwa5@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-8-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-8-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26036120011
X-Stat-Signature: c1qoswom6es38kdx68o5ikfsnaso53f6
X-Rspam-User: 
X-HE-Tag: 1779039247-542835
X-HE-Meta: U2FsdGVkX1/a3EwpOCMky1ONOFgriHtK9UmNur3OxPlwZzL6PqK5ynlHOrZwmB0i0wWrNVyVRXiYabvxY7pNWNfwVevPL3oEAxNtbTuuU+E1A49Udwy5Ke1IzuP4I18ujkdw8kRzYATOnK9jvtQN1BaVKxUzeb+y8n927WfmIyrJdwAX+BkuAhOBHeCmBQr93emPSpk9UmAn0mrjU8j/XzCv9mvBYIMAgVWqCm7d+d3vchghnQlxLZeh6xQN7F69RNki27VbHbMryDsEWOUDyF3iSapblCPx7MLJisUtwm5slELOtWEsEMG72NbGmTLlU8h0KrJh0ZpbRAQtGRCt4OQeKCQxyAyfSwjWgDS9V/Br1PrhrlDb9MzRQvT4rjyO2sTRwGa3AC0A7CfXaJk59L6+S+YsYeh62Kayzu/wnVSKO8WJRqH+CLhnDpmABvrBq5RSG4pGjqy/YPkYFoPdXJJ2oJG7nLIqMSdAuT/6Y3nHD3N2t7dXp9Ey5M/UdxYOi4+o+F3NXNBXbo18tiGgvjJlC0+AZoXrn2X+ErcJnp3mgbgsAflUt6+So3vHU+9Lo9NG/7W0QhYeao6KuestST9KRSn5tcpbYEVk/aofSNaa3xF7j4TmK5dgrin+4C5cEAO+0HY2jZG54AqZVevkuIYrRAvz5ji5b2mm7rTRYjmozfU1j0F4IXlDMVrCFm61E95oKBfnwKJ/Prrpe/r9cx5TGvd6gPSGqJVONbq3s1VDRtEIise+XDDc/yc7gqeXD/gFvkfonSdzZxDF2X5AjgfKzuaSxVtfQCoOgKPU2pLamQiCOVBSH+2HrVhXxMqanAGRVnURycgClq3McpgH1mzwB6Kw00lChgnmnRFfHrd5JYX4qYwTTyNGrrXhaJKsbOwS7LKwrujbjtKTD2SWDDcMbzmQ9/lY/fFGWZ885wHGuq8qvjTiDCRV6wh90s6OPNwzesT1D2LLDGscwSh
 aBUfwIqK
 G1XTFHfx+aOGJIZfduFGMv4BPXvQJ91i7xfRQC28ghe+xvBW6bJ9HvltSWQsyuXssiMyf1k8g1JsWH2MWlCz2rBjf4tiZpfqIMaQZVwNcBwn6V9BnKxjMBGVV+mlBWNcAPslP3g+57ekgWbBaVLk3BOJC1+hiNsPWBelzzoYq5h+6nKd0ffnDuhMUxxQAHE3mYNr+0Za+OCKRgVxPdndS2SglkAIxG7W6pCVJKPgc/lqBCXVRrpwflb/+xJgXuEyakPxZJkoxgfnVtONmqf+0dV1l9uynTdFdK7SfEd4gfaBK4xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:25PM +0000, Pasha Tatashin wrote:
> To remove the fixed limit on the number of preserved files per session,
> transition the file metadata serialization from a single contiguous
> memory block to a chain of linked blocks.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/kho/abi/luo.h      |  13 +--
>  kernel/liveupdate/luo_file.c     | 142 +++++++++++++++----------------
>  kernel/liveupdate/luo_internal.h |   5 +-
>  3 files changed, 77 insertions(+), 83 deletions(-)

-- 
Sincerely yours,
Mike.

