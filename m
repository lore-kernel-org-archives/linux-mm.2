Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41002CCF2DD
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 15:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928036B0443; Tue, 20 Jan 2026 10:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D54A6B0444; Tue, 20 Jan 2026 10:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BE86B0445; Tue, 20 Jan 2026 10:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 71DE46B0443
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:49:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 084A6D2401
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:49:01 +0000 (UTC)
X-FDA: 84352775682.23.FBAEB4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 66BDC4000D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:48:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhkDiB2V;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768924139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPrnJ5h+JTd5xfQX0msksUXYMd1kTQebAy6gvwTvYy4=;
	b=WCWU9pCeLLDZmzGBNwy2weY8rDX70xfOp5ltdZjGFGfjNbUylfjVLoEacf06EEQ0pLzQ15
	n6QwupYXvIUvjiM6mrN71utYyB06nA2Y+8xwLf0bd8BsnmME4eT/7lrDMnob+OK3isFtn0
	IS8YM38zmYUTK3lRVzJn3yWQpfEM3g8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhkDiB2V;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768924139; a=rsa-sha256;
	cv=none;
	b=QhuacJajWl8JfieOE4bJPhHrwjUIolc1+fqtusc0k0Bw8rBUuOLbraWp2+kCk7nfAU7FGN
	3l10T5ILCKRK4T4HZdC2rfXw1RH3dGbdtSXNuVXzKWs3d5zvQi5jUa5y+fMUv7gx1p7zLE
	HHNC51Pc8NXCmUcAa2dcr6pjQrKczBI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 680C9600CB;
	Tue, 20 Jan 2026 15:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B08C16AAE;
	Tue, 20 Jan 2026 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768924138;
	bh=Sibm+aZ98LIkL5kbuZa070QHCHMd8TMrKU2FEeENzvI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GhkDiB2Vp1VQB8+q+3lgV8ww3kKRKo+NC2AOuTXsRDcK8rLtDeAOOvRR25qyOkbDJ
	 A15QFxATiZSqYrRwpleFYkpRYLHyPxiuJ0ALEULuUJHTcS7GR2Sf0CBPSCCtrVbTPo
	 GnLK5XOXviPq0Sdv++gz07BSE0UjK6kkHVQPh3AWLBoUMa2vtJ05mFEHn7Fttk2hUm
	 0aGYilay/5fTAwUq70c0ukjadN/sh5lIOaHib2CP6gc/G+dEu3I5kzIY+0Pg4kaITt
	 Nt2C9z4eMdxr/n+/INAP0hq5Im5Otbn83ml2ISTrZpUR2hmIW54KqlowRHJdPy9z99
	 YfikI/LkK4b6g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 1/6] kho/abi: luo: make generated documentation more
 coherent
In-Reply-To: <20260105165839.285270-2-rppt@kernel.org> (Mike Rapoport's
	message of "Mon, 5 Jan 2026 18:58:34 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
	<20260105165839.285270-2-rppt@kernel.org>
Date: Tue, 20 Jan 2026 15:48:54 +0000
Message-ID: <2vxzikcwe13t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 66BDC4000D
X-Stat-Signature: h5gc9dxh7ss4pqjsxf9c8mbs5uko7es6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768924139-13491
X-HE-Meta: U2FsdGVkX193WpPvCluioWP5K18prntp2gSNt/GZ/jxpnc8y65LneRLNXpX2hbycM6W5Krwcsd3LcEDs7DUee5YpWraX1/8QZ7bvwNB30SO9nmHINubcK4bZ3N3K4tzDWlG6u36JzUsWqC7vyxicnASRyiOeBC6gMPMDmDMWC8TeugTc+VxAXf7X6qLu0cF5cqGy43D9FXShEnYM105GEKiDLCFn3KjLA92OttcOmmLpJ9RHYF7hB5goXlDUxASsbr3SBc9+bdGu0x/FajrhEY8NaUR2+X31KKX98oKMd/d8AQ4AXJCjD2kSTBSyMja4f07b4oOtOTOKvJ7ADPvsf1rZdzFn8EU7G/w/7bMZKNWRmlLDRARF8LgiO9Xdy+zAAYof3Zjwi/Vz+jUVoKOLinVgQjs0WvgsIp8/XSSsS39hcR4rutEoSkBGiPZDEQH9kk3sObPheU15I00tOcmov65TeUffEM8hR+N0sgWcU1ZF8tb3iVYUrFRYlWQoJa5782Qjy01OnQUI3w064MILahbDFZPugfSUMEv6geBdblxkVLaPjmtjPbHZjHppQSOrINl/YE+AJMENB7FWnOusvw1grqRQ24V6sZSOenhEBIJCPYTYVQZLts1BQhQJLwj1An3RHmJ6npkQZyU9KynJ342ayEZPtanjImgVnzkHjMDGrIsFoyVVJS3ALIusz4ZhD4biTeB4WlUnlTxxBivACkJ+0U2/FYaceGvgsOwsTbwmhy0MRjwYH7sqzqp+iWwbXdxrD9V5Ck/Spjf8taFKO6RTu57z85s7C3CcNcBwwnYo8SzyNXm6OVGaNLkYZUBuvjIkZbvZkbqNzSHXxjxdm5SQt5+LaJP0AkRkLb1jGtXHuiKDuybWNEC5fxQzrwhpZ4lhBqa2IDVim4UG7nCmZVIabcOH5hKztMcilJMzzYsGqbXi9fEsC/7+ybVtLoclQdawx1tghu34Gp+47ro
 NZPLj4zx
 sZAtOdtliGAmT4UtlICRBKKjzGeLjpfNbQPVu+Lc+cXmqVFYDM5zaCyzQZZJca0W3VE31mbrPCXv7u+0FeYOeS+A9jB4CZV4RN/IkmxroRe7BB5ruSBG4eVIhzfb2SKECku4uz1O3ztm5ypo8f6SsYzRgYTgg/RwLwlycl1zRa36+bc8BSJ/uQORHcMzLTY/SKWNm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05 2026, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> LUO ABI description starts with "This header defines" which is fine in
> the header but reads weird in the generated html documentation.
>
> Update it to make the generated documentation coherent.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

