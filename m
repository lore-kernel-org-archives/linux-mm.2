Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54379E92FDA
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D256B0088; Mon, 29 Dec 2025 16:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB806B0089; Mon, 29 Dec 2025 16:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6E36B008A; Mon, 29 Dec 2025 16:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AAAD6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:09:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 281E91A6129
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:09:30 +0000 (UTC)
X-FDA: 84273749700.27.AAF0589
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81ACCA0003
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:09:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N9e8bCrV;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767042568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUVk1CmbFBfYMnd+onKI6dHabioivTyCBsvilOrGEbo=;
	b=Ql11F+85O72q17OFOv+le58+stbP7F77OZMGV+nJoYY/952lwrrcRh1ypcCYyUYX8k6ZUr
	7HiocGu3Bajvp3rvBxJvEbGeEtzgEeGqbltW5nUwWmumHCTE+11zCBkH1GdIDPVd+D5WVL
	gOlvpnb5SxqSg3/TpB0t9TA23fEdoYE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N9e8bCrV;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767042568; a=rsa-sha256;
	cv=none;
	b=M7vQOXEIVi0KVH86809+FcKXC4tMb3wB3i1l0TFBYEWFNtcykOLzvgJiRSB1xcq18NGEwk
	oEquVS9TIidFmZ4TpUuazIEd4sJKsWAd7CgRhb7cUlEXz6k22D2kmAsmQeVukI3O8Op5+e
	oRHKxHNyCkAP8ZEnoeaPw8biwn328M4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FD78440B1;
	Mon, 29 Dec 2025 21:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4386CC116D0;
	Mon, 29 Dec 2025 21:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767042567;
	bh=VUVk1CmbFBfYMnd+onKI6dHabioivTyCBsvilOrGEbo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=N9e8bCrVuBEncQY6DY/pq7L587pcxnuZNkUiX7jAH7g7gNTO0y0pXZPeInuYaf0m9
	 812ZhsV0+TyJogWbd9NPmIeqMpvofs98qURaj9WiG48AwIN7WvvmvCmSzSWgXie0KA
	 CCAy5b26YL9gzrOmAo6bPMUaYRtYNsuJiVy5YWpxZpJRA+eh0vBVaHHKkn+5dTKB9q
	 XCga1hD5U5zBXosGvPjHHU92N6xxbsFtWsf+67cUv/sWP/Ntbxl5dUA7cPwVE3XsMH
	 a77CArbgngll92iBlUHc4ILjqjWsepe7/hqHpU9yHYBS6tEI+xdWwAPg1YhKoLEg35
	 nTP6Pz7wt0lBQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Fadouse <fadouse@proton.me>
Cc: Evangelos Petrongonas <epetron@amazon.de>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Andrew
 Morton <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
In-Reply-To: <7024cefd-bf27-430b-b8fa-04e1457e0eb8@proton.me>
	(fadouse@proton.me's message of "Wed, 24 Dec 2025 07:34:04 +0000")
References: <7024cefd-bf27-430b-b8fa-04e1457e0eb8@proton.me>
Date: Mon, 29 Dec 2025 22:09:21 +0100
Message-ID: <86zf718072.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: n7f1nkxgoi3bqdbs7gcpx6k44tmd3koo
X-Rspam-User: 
X-Rspamd-Queue-Id: 81ACCA0003
X-HE-Tag: 1767042568-418864
X-HE-Meta: U2FsdGVkX1/k9zIlO8lG2N2J5gbhqABogWhHN2+nd9wr45wJrWy1D9l5ZPrf4cRtElLzNs4+zeC5QuU7lomyXrq3B5TKlbMUhTUd7RcYdd/UTsmMB3ooskjOF3/WVCFplYu274jHDFn0jlIvneG48+vO1njx4mSctiCpmR0WpNeQmG4Xvo7hHoPdYg8GBgGwPebHdy3WyVKGWIY50L5pbiv1amef1vchCTis8pK8tMIuh1ignJvR3+vHY6CvBCJ+ZHipI6AJWP0zTusxH/J9SkO/9fWwa5uVN+xc5mtSR7FIGKLdLkTTCvOsItzr7bzaEBERfeg4vJ7jSIO5Jq4G4WBChMcAF9afy1Aeuiynbrr031xX9YISIO+QmJlBlrowe4urYh79cb8UKfE+tDBcDOUKa24XUj9F5pEtryw10suodnE3qEdHN7pnHMHryqWAgwWzTT3SHeeq8aWfKhMEP789z0lFoO1qiegKGlzrLPs4j/l7tyGc80Nn4SheC8QShrq1RTGBqlKj//Z4FwivtJqrNSFfZXqjEMQ1LIOQcSpH3izOqrw8385BPBb6Z0NnBU89fdPyr+Dt3+rJg5T8qOxlpNvpTdPlWPtZfZJTbVQVpNpmvoOww4ukZb13w/TRpd5moQAgWeoJfQlTlWvLJmbCFVkQYawwDvdNvScs+CnHPlJePLtbKb+I4osfplUSzcYTYHC7QPuTSeYwAmcGK9QTUerUmX6oBoWlhRRc6gJMNyVByisqaElvs4hWejH5/J/VzNbNG9DoR/zDSgCqcmEiSjRdqkZJLXtjcTqBVjnukc/cYcVQCofNp/TOxIoVZS4Qs2PPKisV+G4sTGohf4wUmHrQrsJnVIrmArAIRF90S19Vh2GK5qVSC/dKeK2lJSyvw/7rRrptN/6lm/wo7ocxiTAPjhdt0Lo4yani70B/8UmyxvN2DXOAIQaeEcV0ilNeCamFVy17X1Oqnif
 W0wt+Z12
 5QkTl+dwsyWg0/sEMyDXklUqI586nAYzM9JsLGFh4Nuve6vG6x6W4Mx7VWGCMnkiUiOIpWPckMCP1GaqMXxXBmPJhaM88Vln52Z3Yn1dJQXlww98rLI79S9Sdp1f1KtKFIzvnDv2a+bVrlT3xXYycYafDJm1QpQJnPmO9wFTb5GjmqDJXr9WVm5aozDbicyw1p7ipi6Ba5HiBfA7bZGIEBqEtEdaM8LtItvlt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24 2025, Fadouse wrote:

> Hi Evangelos, Mike, Pasha, Pratyush,
>
> I independently hit a crash in the LUO/memfd restore path with
> CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dy, on a local build based on dd9b004b7=
ff3
> (x86_64 QEMU, 6.19.0-rc1 timeframe).

How? config KEXEC_HANDOVER depends on !DEFERRED_STRUCT_PAGE_INIT. So you
shouldn't even be able to enable KHO or LUO with
CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dy. Are you sure it is enabled?

>
> In my reproducer, stage1 preserves a memfd via LUO and kexecs into stage2;
> stage2 calls LIVEUPDATE_SESSION_FINISH without retrieving files. I observ=
ed
> a reliable crash in adjust_managed_page_count() from kho_restore_page().
>
> Minimal excerpt:
>
> stage2: start
> stage2: retrieved session fd=3D4
> BUG: unable to handle page fault for address: 0000000000001410
> RIP: adjust_managed_page_count+0x29/0x40
> Call Trace:
> =C2=A0 kho_restore_page+0x18a/0x1c0
> =C2=A0 kho_restore_folio+0xe/0x60
> =C2=A0 memfd_luo_finish+0xe6/0x160
> =C2=A0 luo_file_finish+0x188/0x240
> =C2=A0 luo_session_finish+0x2c/0x80
> =C2=A0 luo_session_ioctl+0xf5/0x170
> =C2=A0 __x64_sys_ioctl+0x91/0xe0
>
> Applying the patch in <20251216084913.86342-1-epetron@amazon.de> makes the
> issue no longer reproduce for me.
>
> I can share full logs and the small two-stage initramfs reproducer if nee=
ded.
>
> Thanks,
> YanXin Li
>
> Tested-by: YanXin Li <fadouse@proton.me>
>
[...]

--=20
Regards,
Pratyush Yadav

