Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22FBC88E40
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7096B0093; Thu, 10 Sep 2026 22:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE416B0095; Thu, 10 Sep 2026 22:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4546B0096; Thu, 10 Sep 2026 22:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE476B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:01:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A973980681
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:01:01 +0000 (UTC)
X-FDA: 85199828322.17.DC26DD0
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id E4DD24000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:00:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="keSF6Y/A";
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789092059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9aokmFcZIJ0AXOYQkqpTsd2jezFgj/8e1f52oVYV64=;
	b=wNkgig/PunNiW7WpyoYggPPTq25VyqJLuIWtNXR91Tnyeaf/2JHItOtXkWjdnKgNoMtIxB
	B2cUh9XbHDoE+9/h/vUAEgzBGFURTG8XSrYsDYfnzhMqxynOw2KPeDKd2sSNgFNJhjmtiz
	WZgGMDPITY9SP8UhxA5HQlrYoinGIRo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789092059;
	b=NSY+XUmx0g3AGAKQmZa0XRWIXgO88WcRUBfXKufMcweP1qEy81rw9+KxCjo6EWS7jTIr/1
	L6xxF93AHFFJxqOxW1httyKYeOwJubE+PS4wf5ydma16APC/A+CHVhOE6XdfUCmSz5QqJ6
	MX8ZA/J5ILwgkDkMNh6IdUDOlUBk5Mo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="keSF6Y/A";
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc891373e0so3717625ad.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789092059; x=1789696859; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i9aokmFcZIJ0AXOYQkqpTsd2jezFgj/8e1f52oVYV64=;
        b=keSF6Y/AocMoa6c29DDsreBXVk7TeizNsNELvdOfb/Ziwk7hWtRF6mlclqEn4IWnLW
         fLFVxwYQNfwz2Q26oTMKOgeLpdyuivtFulU7q51oxIDCKGcvpO3UZZsF/DHRALbl2/Hu
         0q1hsASs1ZFK2Yfy0JBrt1pyZALsmRs0vOIwpzKgTa5f2gmWOJofWxVo2PW7N4WdMIc7
         0mjGkrC5CEJb0KXmDyckdydp/9dUuuyiA4pxbllVaBpLikedx83n+t+Lop2rMxGtCbBa
         IFl4/bzrQjysRm/JRiR8eyfSAbWzbKhHXFCSe1BhKdix67486WIV4LUPkAJ3EoF7nucR
         7l5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789092059; x=1789696859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i9aokmFcZIJ0AXOYQkqpTsd2jezFgj/8e1f52oVYV64=;
        b=HhiRKJEvEnBKy3cvnWpjLId9YoWkbqqZQBD3eG1U1UkEXBiF/7wt7WFtb0yleTgeiG
         yCY8WuD27MEggZV5oouEn48VQtf01uY5trAUMaE+vepB8EtIH/4n5ky/Qg6gxI2R6dVo
         IhfOvQLb6Im8/hEpdUZoaduwgiXXzXY7rLC0wfaXCu9LOrlG296//j5l65X5q+F5vfDj
         MdWLbExxH0GvYmS+7ts6x9i77jRpPHUnL7HOcBQZEjulWGIo9LieE9iJjqfup26YL5PE
         59nvWImrHfN9Eh4FS38VxsScb3D8kwv0Bj+WAb7exlgq/7z4Fjqk7/g2Ov91adZmQ7EQ
         ldEA==
X-Forwarded-Encrypted: i=1; AKwUvByYEuEQvjkB0l9zmTZkFCk0j0YdPJbtq4KUJnYwp06BfkYZThxfxHYq3u0LlZus9wXpBQWmR1rRjg==@kvack.org
X-Gm-Message-State: AFuF++lnOzt44b4rBF7fF3CDHutCrjRnduC6KL23EfmN+Onws7oYcRMD
	Pp+dhUrTpLy0/7BMQVoTjGVgSisauB430vBSJwxRn8z/lTGLNMEeWm+g
X-Gm-Gg: AYBFou1w3HVaPPXb+Et3UYYK3xLatuGJfFCVEHHBdF1HNmdvmD0WE/vA1EIvkNqGH4h
	WcV+5/sc0xZaZImCWP2LYjBIIrncezl0c2ED/Ys6yR3PYKnNKVVrdzyq19a0ilmCo4CLgaU+Soz
	oYPB/5Z2BR2b/MSKiDJdzoPRQ+XJbzV+DudjAMPacjOh56D9qMZbT5w6jbpZQguyAxxaqxoJi6i
	UMCZv8QEvGe9Zi2lSFqxKTBi/J2+eP6nVDQjsR5jfjXWN8iiVfKmIK0IisYHub0nvJ96U2QBwCi
	y79fNrC7uI57wrPyV9qFHqW5eGfWVqm8vksasb9TaGEF7p7HIaBBBbsDch7RMeHjETXtZzPZ6AI
	4dR5po2cvFNOer9q8PWyMc2rl7UVo8b2xa1YMorbKg/J3s19x1d5BiPvuzU3GxfRTaZ7pUSpU+S
	TJtDb8p6BS1AmxqIPB0JXUNxmAfnUdacNtaTbK9qTfJryeXCoWqhMe4mI9+lMot/wUMX3PQv8nD
	ZTd5rxzJtQ4+b4ukFl3zvkYchGKJxbg2u3tS/lx
X-Received: by 2002:a17:90b:54cb:b0:39b:51cc:4586 with SMTP id 98e67ed59e1d1-39d9c21bba2mr2583345a91.19.1789092058595;
        Thu, 10 Sep 2026 19:00:58 -0700 (PDT)
Received: from localhost.localdomain (vmi2317697.contaboserver.net. [85.239.239.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfce707sm3587205ad.55.2026.09.10.19.00.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 19:00:58 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 4/5] mm/damon/vaddr: extend apply_probes() for hugetlb
Date: Fri, 11 Sep 2026 10:00:36 +0800
Message-ID: <20260911020044.37520-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909140408.104699-5-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org> <20260909140408.104699-5-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jgim3ubzujt7unbwdtbojaqsusr9fj1j
X-Rspam-User: 
X-Rspamd-Queue-Id: E4DD24000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789092059-486697
X-HE-Meta: U2FsdGVkX1/sLo2Loo8mZNlzEKlnQS9qCeqxzX7n5A6CEoq/z5d+PU7EFt6/RMnzbvgNnK/QUUyyvdmKcQ4KS8TG84i54tP6vX6RCJKE+SLEGuzFVMSAI3GFlVsOftCcd/330ZbVDeHsTQj2SiHoBpUp4tF2wGsw/8PPnYD9v46Mj5LUTOuD81VuHUBy4L6c/nSz8sQDHIU3p+Gv3YeG5NMNJ+5D/egkV9E6Xk8rQJatLkazqS4PijoJ9s1IaAC5JdbmLTBBOvi8m41lSvt4bU5HqSFP0rAjS6T6AgMTCwvX2hF9xJmLG5KjAVcRmQmBS553CEKWFDA/4hKlbs/rmz1ouzKy+e2LtZmYe0IWXHgze/SA/l5QDXP5nwIYH3o31cagauAPdG/Xlh8BbwrXOTUiX0NSz21yFwwnXGQTgazyA+pj67jqNYlyoT8MjNd36EzDuzo0A4JqoawXa0UsBpE8nwT66yNJf/7VOWSJ+zC6DtCw+FaVkBKqbH79Q0SX0mIAmkcE/ETPzsVbnmjv46yezAh1pQ2SQQGv+aTGskGgm1mO4RG/tZ16hB7gZulngQLA/JyKqOaR/OaPKg6kXMf2uLyO1t9KrpXoLF1paryjdce21860HroUpSJk+jU4sFO654rtiSfnVgf7SBxmxdI1Ds2rsMzd2VDyBTeX+B8ARwzypnzpx2EYwlCbxOobPuO5w7olNxSmFgzAImCmnasNxiYOvaHq/tQYgFuNhZWXUy8DYgAfW82nsfpTCBQLQvw7qVd76uLZxuPG7tOcSQ0yPPGu/Xd+lE5Y/oMfM9JQce2lgUFKkRQOKesVRSgZGgFc0NvhAmKMfqDmnfPcRHBcebuia9Wo8zBv2Z/WUL41TwtvJ4IADDPMWiRPe1nd/e+/hiEgX8QxELNywAvstmDHi13Xc2vepAX0JpNjIi/Ms7P2hMfvfC67iajGNq8WxepSl5N3JKX/uDZ+xQA
 77cbd7+g
 9dx3d3qamIDE6Fv8GOtqr8x6v3sZoeU8fCTsEWXxqa61OWnzRVvmZFM9PkKPtOmjOXHaC0c+vm5fIWhr9BKiytvQJALrLvvAyQ2wJQ74UFJmMGZtAmD1gf7a7Hysfu+X398F4oBiP3nCOFHEHFJRDOO7kp2pEjaUJ1JhYDas5UaYXlFQGB+bRF2bejgTu217LHvVRAS06VZG9qOkT2+RAohmFourlkmKtcZvLqie3wyOBzYoQCtYOxJrOqm3UNZs749iTfyQnOORoFQlRMxYpCxpsF99VppF8Qv3GqWLE2LZZ0l7PTLjnSV+5Nco9CcDe12oo8AsZ3seBfCvvy8SxYRbyoJRWu9sdsZ4X2M7fP89b/rGyTttkA+GnUSJ9KnRhqANCqDfldWpc9HZW1PG7G89tjtJ4izJ1aX1jR/nIT+ock8BQiKoAfG8yXmqA2TyVNmVDyrWZ+Frp7d8/yohqT6kNR3ZX5q0pt9tXY0w2Fep9DxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026 07:04:06 -0700, SJ Park wrote:
> DAMON virtual address space operation set(vaddr) does not support
> hugetlb pages in apply_probes.  Extend it for hugetlb pages.

This looks good to me.  The new callback follows the existing vaddr
hugetlb walk, takes the huge PTE lock, and keeps a folio reference while
the probes inspect it.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian

