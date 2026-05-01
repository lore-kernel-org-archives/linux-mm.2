Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E06CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DA06B0098; Fri,  1 May 2026 15:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE276B0099; Fri,  1 May 2026 15:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B596B009D; Fri,  1 May 2026 15:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60A8E6B0098
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:34:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF877120257
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:34:31 +0000 (UTC)
X-FDA: 84719852742.22.A4020A4
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id F05A71C0006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:34:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Vp7KLRZG;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777664070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8gPN7kNDbm8qtyNa0nO5GiXBN5vG7cPKkydh+QrL3Q=;
	b=sPbWrb1qZ2Gu5nNrns4msM358OjqWWRRMCNKcCQcV0mKhSIURBDv352bI13eDQZrYD/4ss
	FWbekiw10Nql4eNV4G83qY2go/Nv+j088Jm4uBtekYoStjiomIuVRuerFCPpahT85eZ4vJ
	WF/iKZHjQSXeM524dThtWEjlOEs4xxk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Vp7KLRZG;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777664070; a=rsa-sha256;
	cv=none;
	b=Mb+8rfqIStw67QNbYG3EB6O14+naqFimMYXLEL7ndwx+IWzSL8Z1J/jmuGLmVWFfYM3zSa
	pVN2NqvPIWKDCecoHhqsjBHg0IptMSqpTcqZfwHAUmvGxZC7sI9NB5QTstlTWOQWBEw7f9
	jISqyqEY9qvB3/1fzHZwROt2g1j/T1k=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8ee62a19730so244880785a.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 12:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777664069; x=1778268869; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8gPN7kNDbm8qtyNa0nO5GiXBN5vG7cPKkydh+QrL3Q=;
        b=Vp7KLRZGhLeEUSfKl3MBWdsaixlUlNbtLyO+mjJJEON1VoknoD9ATFWY6O+GDgXDjE
         EMQ8oe3hyR3QSlpnViy/D5xSqcxHAvLTsSGtOEveFx6cyVATdT22KsmDYe4pr4oolvYD
         u17Q9hqZGqMkXjiCvOMeuOLkfyNgYF0hsVQa9ndU7lm56iLlJ2ffUj+sQG/4ZDFWtlot
         edJJYv6yy1Yyz+ESCs8Sji+jBjGnshAbH+Qa8C8NqVWqL9dczv9VWlIInlCGovjRcBRA
         3qooGOJHwbAnQhu4s4jqazebtZhSqEULyhUyAGY3b5gbW0vPOVVCAMY4ucAJRizZGQJ6
         H8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777664069; x=1778268869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8gPN7kNDbm8qtyNa0nO5GiXBN5vG7cPKkydh+QrL3Q=;
        b=rDk6IKw5lxY3iKaMNai2uJrcFCal1Na9jRvHwahtJYB+CPkk5IKG5WCI3svR4j1hNk
         g0Sxjz1bSM23jFSQBmW1ivgbD1g1Cvp9J48NeTs8JztPipwF4D/E4NW9Ilfb5/8j/nqk
         OTCaF1oxpK9+rRrAyOjyPi8WB9F3mglruK39ZVuU4nXz7bLZKnVLZ/5295U6hYPZOSrO
         SariuPBSNBNmeZiTQQh/5m8MFFx4GDAxTlmF72CRvKBIsRRsx5vUIiKsHJ8oVx8tPgaR
         jMYknIsZAvJbu3YLaZ+m/pVAtKdQ6Yv74BBzdOoaZthuDafIGeqdG4rfklUqIq3lQOkT
         xRCQ==
X-Forwarded-Encrypted: i=1; AFNElJ9xQDHzjEcKhcuaDqjFQo2ZeEt0BmXxgW6h5Cs1ZUF7FEQuyoa4RbLiA045dFyyqJgAm0MhD4ug8Q==@kvack.org
X-Gm-Message-State: AOJu0YxicPosmZAbFID1c+1mHeoiOm/NMIeEY+vUsyLrBAisS6Amv6gH
	+Qzq6C1L/Ec8t53ydesgkY0A9SCkNuXjd2RO4u+fceLS/0FlWA3W3h4jH/yRHUpHUiQ=
X-Gm-Gg: AeBDievslG0Cvyt0Zi/xMiPftitpkNfrrLj7tI5xLmgWME3OF1eMTcrBKOPd2Wi3QGp
	SoEA9d/WACk2GNvFLPKI62lasKleQnI4CQIms2h+qgNT0uP5AXagUgSQloPk7Fu561GdSRS4EzC
	1R+QDTqHwPuoNKd9Gj5/M0SCDOVgRAfetFqhYTfn691kMd93Nv42R6IzVvg5oWiru171Iz9Zt4x
	+PjOWC1vKAxCULwMl0DYxorjuppVo5oZeCsurYadqX4cctbcQaPZvqxgesE/KF5dg2RPgS/aufi
	l1QmlOSFlG7DWhMPd1KSot6r1/u7BwnuBFxipEXEzlPUkBIbqugUidXeCEEHI5wYV9nmR7S8kQb
	ceO3gPtE/P2+2Dy5bGtKNgqKZn4RiY7At/l4paBvr9ge6kIxuEoSoc66PRIFjufT3l9xDa3f3Vr
	ga4c1QGROHNhbD4mP7w047BAoiSdjQoNRj9k1nGtn4yjC+PNoP+WXKdUMJuUW3vg==
X-Received: by 2002:a05:622a:3d3:b0:50f:b1ca:6eb4 with SMTP id d75a77b69052e-5104bdf33b7mr9482351cf.3.1777664068181;
        Fri, 01 May 2026 12:34:28 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b5d1f8sm22318571cf.22.2026.05.01.12.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 12:34:27 -0700 (PDT)
Date: Fri, 1 May 2026 19:34:25 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] liveupdate: validate restored LUO metadata
Message-ID: <afT_xHDuFwAUSR0X@plex>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501173053.73116-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501173053.73116-1-crisjacobmaamor@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F05A71C0006
X-Stat-Signature: d3tind5wtnk1nnodow3y4ykufzznff9w
X-HE-Tag: 1777664069-91183
X-HE-Meta: U2FsdGVkX182/mi6OlYzSiWHjCZqfQy/eLobSPp9j9c9buVFhhZNhNuN1C6h5JIz5yDNzkBKtIAJ8YZiB4Hi6BxjqWjILW35fS8zkN/tuZu8ZwYmmwMbRPzQTnTse8ZKwJtN2w7cYllxLDo9/vYcZMcCavKvMhIjqabM8SOxVJXvnk4Ooh+weFhX7rwzD5X0ES6B7sYDvX1Cdoi33JCnRJk+E7bN5KUhztEpVBehME7y2rEm0PeAbf8ssAIxAOrAtsldxA8d8hfONwhPnUaZQVF3UJQ6h9XSollRQsIgcm4xkosjc7gbP7ZnH2aQ6tztsvoKfCnsGoobgM8Xupj+rqXkAICDaXiMq42IlAil6VFqo6fKz6HbMxVm6/8ruJ10Tjoa/ROdI4QIT6W2eEVHQ4FNWTG7tQULiMfS2Cmf8RyKYU3ZTd1M6VaM0EQH+5EqMcWBpKjBPCzwvdMYgugwkZnJhoRW2PGEW9+1S5uPltU7QL8E4YmrcPvXMgHneV/IjW0xF7GL0Uk0dn75zBoFBy9mtTY5T7boejldZeRXp8iZY/XcYHmopQzGdjwIdi7A0MXl7yjJXXMv+qqCoJYuQiSkiqLvg3EWOkgHV2wky70kQoLzyLsVzKF5lifvI4x77kOlvPKJd4JLI4tQ8Sfl/wF4YUkkXuxOCi3P82fdF0NYZi4bgyEsR4QPlpVjdT4Spmyblx3566/YRBlAJe8diT7KwTYOoneKj5R9tdRPSnxOxeduUrJ9SBYGGSX8GLENMBojT+RI3nFIcD81yFW1tE/MNX51lYtNkeJ5nk+i0FP31IS1aaVOCOE3t2vrGIjScCzdyRPHURU4T2HSEGOuQsCPBBgakB9/BzYRH08cTOLasK4852WSaNoMn4r6r1lydDbn72Ak8N/rqEffH04BOLvhuVOOhIblhuVfjlnoWQwXL1T467tJrXoPMEuj6pjaNKMvIoCTxUrSb3ajs0J
 Bmchwyzq
 vzyDQZZKpUYfJSo3c0MF8Wl7k1SP7ZQzt5Fhd/iTlAL+WTHU1GlckzxmR+8T5Qg+mkWfsXeqFl3pSMpnexc7vAi0PqBMqobqdo9ydELQ8RKMLcAu84MSXxPzxWZKjnStZXig/TvE8QZWxug1eVy6BuaWKQlUHZWDT/V0TRumL/BxvU9sdvIfSoao0MvMx5e0eJMUJv3ZRcNvCiR1Xg9fBczvjyH6XN2udVUJEGV+cQ8CQtr9/VdzAyyQi+NnoMGvgE6IGS4bkEnQsVmeeKHC4T/yENTe+3R5qk1AgPk3JaWBNlXlNDmSybiCvsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-02 01:30, Cris Jacob Maamor wrote:
> LUO restores metadata from KHO/FDT during liveupdate. The restored
> metadata contains physical addresses and count fields used to access and
> walk preserved session, file set, and FLB arrays.
> 
> This series adds a non-consuming KHO preserved-range check and uses it
> before phys_to_virt() on restored metadata addresses. It also rejects
> restored counts above LUO_SESSION_MAX, LUO_FILE_MAX, and LUO_FLB_MAX
> before traversal.
> 
> As far as I can tell, this is root/admin-only; I do not have evidence
> that a normal unprivileged user can trigger it directly.
> 
> Changes since v1:
> - Dropped RFC marking.
> - Added changelog text to each patch.
> - No code changes.
> 
> Cris Jacob Maamor (5):
>   kexec: handover: add helper to check preserved page ranges
>   liveupdate: validate LUO FDT physical address before mapping
>   liveupdate: validate restored LUO session metadata
>   liveupdate: validate restored LUO file set metadata
>   liveupdate: validate restored LUO FLB metadata

I have replied separately in the security report to clarify that this is 
not a bug. The behavior follows the ABI specification exactly: we use 
the PA addresses and ranges provided by the KHO FDT tree.

NAK

> 
>  include/linux/kexec_handover.h     |  6 +++++
>  kernel/liveupdate/kexec_handover.c | 35 ++++++++++++++++++++++++++++++
>  kernel/liveupdate/luo_core.c       | 10 ++++++++-
>  kernel/liveupdate/luo_file.c       | 14 ++++++++++--
>  kernel/liveupdate/luo_flb.c        | 23 +++++++++++++++++++-
>  kernel/liveupdate/luo_session.c    | 22 +++++++++++++++++--
>  6 files changed, 104 insertions(+), 6 deletions(-)
> 
> -- 
> 2.53.0
> 

