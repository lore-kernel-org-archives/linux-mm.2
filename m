Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 780B6CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E9B8E00D5; Fri, 24 Oct 2025 12:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A016C8E00C9; Fri, 24 Oct 2025 12:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9E28E00D5; Fri, 24 Oct 2025 12:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76F9B8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:33:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E817D499EB
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:33:24 +0000 (UTC)
X-FDA: 84033553128.24.ACD9821
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 60FC71C0010
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:33:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TmTlFHF7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761323603; a=rsa-sha256;
	cv=none;
	b=wTg9X/Xv9cWiVqJUA0aEuz6m9g+r86Rj2+Com4uh6WM6BcUV/HmLqTO2OAdY1yoWnCJ/F9
	p0G2DKW4QsZR5eCcOTOU9wdXu4qrnCJKFTK9Hf+eUeN0J3snv5i7t3Zf8xgX6ge7+x2bcG
	8eOg69U5z+Fe0+LNCqVXGv9fmK2AHKM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TmTlFHF7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761323603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIC/csduTZhGCHCWdpswm7eNgSxzcwLijVF9NZDY3Fg=;
	b=XvG5a1lotgF3UOjFbARmgsXvq7lMx3iRkdTGLBhAMQFTnVqVoRPamCVZjOBkLgiBrZKiaz
	S1i6sv7sgMDT13ZwBn2Y3iEN1CoeSjSbEZQqm5D4qdM9+iBxSytn5XdLv9dVshWNZtQzHq
	BFM/uX8M8AhX/G/v6g4mrK+LN4MR/wA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACE1E60210;
	Fri, 24 Oct 2025 16:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240A6C4CEF1;
	Fri, 24 Oct 2025 16:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761323602;
	bh=XMFgwNWwAN/K20/zNCeSu65GygTTYqfFzRDZdRxe48g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TmTlFHF7zZ8dPZGX3jEH/pSYjzxolXyF5dUE0S+bL+Nq+hpo1P9ou18OJNUiu6KBI
	 NSS3Xm5dytcFzfJ7puDv1DsP7KGA2uEMxJXDWWiL3vGS/ELCNIULr40DEEajfZrYqy
	 qTpYAvlJQobc9AHEDUYmaq0s961QH7d8g/xPl1jFWOAEVLEPQOV8Paa8m14RPAPxot
	 NH+OqVP2QIpszLJHcV4EnBFFxrsuP9ac79OdrpmNJfnG+aj598hT+O64jUZa9Y9OFL
	 LUz2EMmzrLKkbiTR1MVOlnkTT5nZOOEwemDPmZEmex3FgyirppOmfweer1mxPrJE+Z
	 N446Xpue2eMkg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCH v8 5/8] kho: don't unpreserve memory during abort
In-Reply-To: <20251024161002.747372-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 24 Oct 2025 12:09:59 -0400")
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
	<20251024161002.747372-6-pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 18:33:19 +0200
Message-ID: <mafs0bjlwdzu8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 91mu8xfjocboxh8a8y41pttxomm8i7ec
X-Rspamd-Queue-Id: 60FC71C0010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761323603-966418
X-HE-Meta: U2FsdGVkX19m7ZqnOk/40BaOFfJi/VFFW3f5M8n78qpii46eglB6KUsF0FoPHG7YrBX3ePhKmBju1MFcLphTRBY6Gbo5/UM8mTKOklRVsT8j56DXL4XquH8d1AwI46hfR0t3pTfl0JcQRWhDNb7279PhJyxEwICqG+SjuDFisehCvsocsta8aZmfXEMf5YqvJ+rvsgAKmZbPT+75P7A1yuq64YhaXto7Ot04BtfD4DGip5aRkfatMgmhqjauFZ64mOXZcsIa89gw9bVGyh4CZ5rzPkzsWbo2ytgf58efSmcoopDVoYU3E08kSCLjag9MOcVLxXd4eLMHIbNmQdRKGWQ0y44YLo6EeWsLLuPR384QkkJCOnows4QnR8gbxTicf9W9vyd4VQiLO4d13PpGDLNv84o6Kx6UP8aTuyWuM9ycQpICwjZEC7CORr8cY/HnmWU3XRBcagmCj1ba/iIfJ7kFilNaXDd7IgChjpOVF73ZQuOSIGbaAcnoogIVhp81lXQvzoehImHlglA2jffaKbdUyBsre3oWLXqgLsyxstBF9225/V2GnDI+aQ62mPZGXh/uLXpE9J2CFgIliD/e3VfhTmP8Nx9mA1JxBq5wSrhrkB05+b4764ZCUgkMVV+rcNfqDItY5rlXXzhDwYYuXorsZOJ4w+5PSRCECAZHX0vp6JWGartNj7vJE3W/H+L0/u2imJPwVL0A3DCdn7nsXp76tQkKtz21tOHQ25dA5QY8hutH2baKuAcBoroueaVgcbnJTyxrbcgTA809uD11JS38VSCPNwzM7aqrsa3TVhGFCSXOV97Z5JcC03ikCtCsUFRen/oNlgNuYxq/tGW8SqwEbozUmgcav8gNOzmslDDKqCc2vjY7vvkS+P/T0eNIhuyMypI3jY2zJ3sw52DkXw+g8EoMmpjqt8WWOmrX6yDqCnhv8DCi59Iv6MtnHzx+AvwX9xtUjSYtTW56cUh
 6yEQrcT6
 ojWR8yt1FiPf+kmr7v/LC4SQlX00Y1OJ+0rs4UA+sWwlnH2JabqSYKQMIODKqRcuEdOPn61+QV9BgD+hukHzhf96+Mjj0t2VpaS8fKKflRREONYe+bRhCza8daNT7oXmHwN7plYewQdlgGeTnw0SpEL6A0QpiTwtP1NIQHdmslv2ViiPy/XH/y4JPFj7Avte1fabLovXDJruGVtURq8rCptjPdbwcYszjOZEfeFpsfyJPDj/TIFAbLzlhvYltzFA6tfBm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Pasha Tatashin wrote:

> KHO allows clients to preserve memory regions at any point before the
> KHO state is finalized. The finalization process itself involves KHO
> performing its own actions, such as serializing the overall
> preserved memory map.
>
> If this finalization process is aborted, the current implementation
> destroys KHO's internal memory tracking structures
> (`kho_out.ser.track.orders`). This behavior effectively unpreserves
> all memory from KHO's perspective, regardless of whether those
> preservations were made by clients before the finalization attempt
> or by KHO itself during finalization.
>
> This premature unpreservation is incorrect. An abort of the
> finalization process should only undo actions taken by KHO as part of
> that specific finalization attempt. Individual memory regions
> preserved by clients prior to finalization should remain preserved,
> as their lifecycle is managed by the clients themselves. These
> clients might still need to call kho_unpreserve_folio() or
> kho_unpreserve_phys() based on their own logic, even after a KHO
> finalization attempt is aborted.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

