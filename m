Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B8410706DD
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 13:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450576B0088; Sat, 14 Mar 2026 09:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE966B0089; Sat, 14 Mar 2026 09:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ABC56B008A; Sat, 14 Mar 2026 09:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158E76B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:21:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8D1713BC0C
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 13:21:13 +0000 (UTC)
X-FDA: 84544729626.12.3A42A22
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id CCD4580009
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 13:21:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=zxlE524Y;
	spf=pass (imf30.hostedemail.com: domain of r@hev.cc designates 209.85.216.41 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773494471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKSCkW0BeK5up66BRXXiiTYFSs9Fl6al4vvswcco47o=;
	b=a7RIDquHTDspDHbA4PrtRZeEBf5IWm5Xak9ua1A24YpKTOCSjAlzntVOoGLrVpFZ11kGf/
	LJzdyVubGdyp9juFkK8bj9lskDHuZCxRZkJbkI7bpUWGtGBWYvAZC68MpvVFay5MfTPWLH
	iJ5ROugY5FX1DGl++KKl/6gHX9ZV8ag=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=zxlE524Y;
	spf=pass (imf30.hostedemail.com: domain of r@hev.cc designates 209.85.216.41 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773494471; a=rsa-sha256;
	cv=none;
	b=22ZnnegFRkz3aocpu8r50V389yPZ1y023PooKsNTY99EJvo9qAjQFwTENiqoQmwPbiEuJK
	GaIidOpBh/wdFcCKky8xg2Tk5YzqOevuI8KiU/fkZ5SEDlYcAmZ2X8Kb0hARB7oRgPIVfU
	adc8LdaH6pznm01xRzMPWHSvZxV20/g=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3591cc98871so1469425a91.3
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 06:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773494471; x=1774099271; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKSCkW0BeK5up66BRXXiiTYFSs9Fl6al4vvswcco47o=;
        b=zxlE524YIDMnWA6oPM4433gWwC8VnsNAoCLQ0U0pa2JaSb+p4B+kJKi7wdytIubQyT
         jthee8blEadfumJ9On2KIrJYLrEesFooMztNc2NxLg674dSetMEBph3nTzBPihLVN84X
         yVSway/44oUiCjrZm73kO6VwF47QbVq0Y+q3biUUSPBi5ucvZ/W+Jy4gr+Mua3cggqB1
         Eu+oq3pHfZi9UBfUw1EVhWZjskoDDVtWkRfA3jZ3OV2k1KjahaE0/brRsen6bW2X1TQJ
         xL4loHn/MBuxoOkQqjcTbCjsc0VYKISha0fLcAEfJihUtP2jnvYfxgeXvgoZFIr30X2+
         Mdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773494471; x=1774099271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hKSCkW0BeK5up66BRXXiiTYFSs9Fl6al4vvswcco47o=;
        b=bXWSGOETZ05fITGeLbcwSxBMCJnZcfM/OM4LlzLAierbBpRSqB1+q+Zxdsjl7SZiqw
         RdS7dKuxYqo44uXphnhd5as+6uSKPwS+uljCE7PV1Gqgz0PVKs2wZPhUl3DkpmQ6bUYc
         btCERuryxjxfKw/leDaVAEHPSzB3KMnTzSXr+EbA8sl3eJkaFIQeksb1hLzGp3U20yKw
         QFqCqaJH68wy0zL57tF8U28xZ3PsN5IZqMLY7LUZJD3S8BCK4Sj0SNXa2QPTFEgFjI5r
         i/6HuJvksKZbVIVUveCp6GEOVIcUg3nDCL5b/TeBbJ2y4OVuajv2gFOyMVBzQuajvUSu
         XRaA==
X-Forwarded-Encrypted: i=1; AJvYcCWPIGuStBvleCoQfcIJ/tDodrw5kw0QXUL/ghva8BpIB6msCC4BZfchOcfVDsEa1lL+82IwtIXyXg==@kvack.org
X-Gm-Message-State: AOJu0YxZ0MzQHg5V05UenPznGcp3rXfkmK/crbUW2TbpyfrXrc9nNxxt
	6Yd20lZgjVOOly2mceLk4JUH0AV/8lMYmu36mSLvh5gII2NeEeQBg/cUCB5G3hYCK5c=
X-Gm-Gg: ATEYQzxsLdxwdqCKcNuO5MR1A6fvU4hqEAThXi+NYRA54e679PJeE584lpCBB5c5jp+
	b5s1Rx46tL360TGG4Okqu4+aOI+MtszZu3FFzE8WO1jL+9/Dy77BnkwifeXWNGKgul26ameOnCs
	fRS29r51FGseFxuLVsPEt3oSzKkF2B1o6xvtLI/DzZmWEj9q/5ojMRS6a7BBdtLJODXAKHDxrM4
	xi7hCbsg6HlpdNDxoEIjJ1wnnAXpkt3nXcwhZ02G6VGiArAg/K/t+binU+79EW/Scz8XTMD/yAo
	8S7ocu0zGuDt1QFirV0KyWryzF3PiYw98qUJinCQYQGv04UhrdOsVSaVWHuRkyVNAAhYS8roKn9
	r5vA7zdFtR6XeljVRR2+ehyHxWQFty+yRWMc0if295dQOcOZJJsmDOQ2FcqiLB+PGpTIJCPHqEj
	X/
X-Received: by 2002:a17:90b:5306:b0:359:91a0:98fc with SMTP id 98e67ed59e1d1-35a2208bc41mr6562451a91.21.1773494470557;
        Sat, 14 Mar 2026 06:21:10 -0700 (PDT)
Received: from gpc ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a03005f7fsm11288866a91.15.2026.03.14.06.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 06:21:10 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: ryan.roberts@arm.com
Cc: Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	jack@suse.cz,
	kas@kernel.org,
	kees@kernel.org,
	kernel-team@meta.com,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	shakeel.butt@linux.dev,
	usama.arif@linux.dev,
	viro@zeniv.linux.org.uk,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	WANG Rui <r@hev.cc>
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K pages
Date: Sat, 14 Mar 2026 21:20:38 +0800
Message-ID: <20260314132038.223901-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cfdfca9c-4752-4037-a289-03e6e7a00d47@arm.com>
References: <cfdfca9c-4752-4037-a289-03e6e7a00d47@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCD4580009
X-Stat-Signature: qsg7jkhfs5i1kcki1ywg4s98rnqfmmz6
X-Rspam-User: 
X-HE-Tag: 1773494471-844269
X-HE-Meta: U2FsdGVkX19Vc70k5hkAwIBGMQQlViGTkfiMQ8ThUVoHpi7L/+qxbWR9XSBupC3s/xboNFYzOE/BEpflG+d8E+HXwwO6zXX6kJwZmbQMb61MlIlRuLfebVq9INTyAjojJa1FsWNatkCyiK4A8VTrPIktkCTKU2Wi8jtiLu4SOevDEbOdwq6VSTFjeWQ6X3xw4GS5enzL/4Cplxyke1yq9oUn+HGG3mumMxKX22f3oh5zgZx7N9teCiCIogkA83JmFaYtMfJfp6PWruRyCi+FN4yupoEo4FxOK0fsbCIdF80yr55ZFWatk3v+RpVdJxs0oMQcMFzWjdPe0WQU/8HuuvkswN9Jz15yA5987rtvo579Icu06TM1hK7bV29slse1bzxf5m0eO0/laH2sN7rPjXbDS6WSm8uGfZq8js8FfbxN9xyblzzkjKsCXCMOCJdXRtBHb03fF1JlTvc5W1zXt46BbOZMGxB4zNrNTtSO0E6YWMlKYLv8mwyBydhUNeZFWxpjfjj8/FUPd7fp4xFeDwI3xR944aXJlUt6aECfcExLvibM5kkXpXvILb/1kC3Xah3QSSd+5Zuj0xR//wrLUfNk6fYDolwTrN+z715/jZoe6QQeEN9rdMSbyzkyleR9DnedMjtLmOeTdFJn4vWCODgXu5xPrcqGKMH1e+94VYk1bjbPpxGnCA8g9m3GSY6U0S1GDatXuHUck6s9Wmtuaf4zQW+8tHsXRBcD/GjB7Z2nj/3njyZh31k48c/MrGGEhrrHJn/8mW6saBTONh3il0OlWtlfgZ4MlddHDUob6dgXv3OP/wgRsSK4TiZvEjszq4nLhsj5CCAqyCLcLFRcbLXrWc6mVQwiIOkvzP+V/qx9Udmon21xFn9MyKPL7WqrTWAkzomftVLkFPgdq/m7p7N8KYOM5OOpydCjMg4iJoYaJO81b5RdLn72sOymvGJfH2N8GdA8p59wEkGRGnD
 /LkLv/CQ
 kNleL7iHVti9xsXw/bSLyX3PLNHCNKA6nrDEpro3CTy5EIXG8RKjxukS0AdB7OHJ/gBKCH0Exs+Oj3InkCSVFwxjzsId6/oVWFKWFS/Fu1qEBPQjGHQnLo45naN3nnAISYgCHLXJv8a1A0h5Rc2AsFvV5htshwTLDlwpo04Ym4ZfToxod7eViRhScO9llVw5VvnIcArfNfrEi7Uk+SKEujgbPpamLZzZZc3JCt0lHbG2g9RIreyIhASo/0x2JK5otK9BBqWYzxDLf4dLv6qUr6MbmOaoGeIadlraRP79tdATsjahIlqI1lEQE74RpxZDXZqn0qZn9KZsoQXNvv9glOlzUO8zB8Ab8Tz0Tn+EFxCTiC8lc251SXbOmFuWl8/1NZdQxA/LVURIkqDFj/uF5fx1IBIphuV6qeL+PfbF7KJ+Ppc4D1MbwmDBYDPfdPi/OMN52W+U7iotcRIGUgR0Pn+aS7CTCkCt/3l5Urjs29ShtmBtMYD0Qx1NtNmGEcQjSQQuzEtXMGW7CFynJk/9IgA7NrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryan,

> I don't see how you can reliably influence this from the kernel? The ELF file
> alignment is, by default, 64K (16K on Android) and there is no guarrantee that
> the text section is the first section in the file. You need to align the start
> of the text section to the 2M boundary and to do that, you'll need to align the
> start of the file to some 64K boundary at a specific offset to the 2M boundary,
> based on the size of any sections before the text section. That's a job for the
> dynamic loader I think? Perhaps I've misunderstood what you're doing...

On Arch Linux for AArch64 and LoongArch64 I've observed that most
binaries place the executable segment in the first PT_LOAD. In that
case both the virtual address and file offset are 0, which happens to
satisfy the alignment requirements for PMD-sized or large folio
mappings.

x86 looks quite different. The executable segment is usually not the
first one.

After digging into this I realized this mostly comes from the linker
defaults. With GNU ld, -z noseparate-code merges the read-only and
read-only-executable segments into one, while -z separate-code
splits them, placing a non-executable read-only segment first. The
latter is the default on x86, partly to avoid making the ELF headers
executable when mappings start from the beginning of the file.

Other architectures tend to default to -z noseparate-code, which
makes it more likely that the text segment is the first PT_LOAD.

LLVM lld behaves differently again: --rosegment (equivalent to
-z separate-code) is enabled by default on all architectures, which
similarly tends to place the executable segment after an initial
read-only one. That default is clearly less friendly to large-page
text mappings.

Thanks,
Rui

