Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA5E10F3DCE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 04:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCF76B008C; Sat, 28 Mar 2026 00:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4B16B0095; Sat, 28 Mar 2026 00:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1916B0096; Sat, 28 Mar 2026 00:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 501266B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:03:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D173D13CA46
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:03:03 +0000 (UTC)
X-FDA: 84594126246.19.12BA287
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 01AFC1C0007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:03:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CRu7QRl/";
	spf=pass (imf21.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774670582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3Zdm9QRebXAcvnQwXWCkI4HeWD2IUP+mu0t1G2C/Dw=;
	b=P1TTRbfuOHA9cTKNYIZolna4kcgGibmDwFe/cCHKQB8VPsf0vfHDdwIgdNTTWCcBBkIUxK
	OdQkFPpKshpyI6ys5h3kVeON90j88YPRBuu6UUpo3o8484yV+pbzqfKCjkBG6tcoBUyBdr
	Y+uIvdsBLen0SOZDoKh/UzWHjZkrql8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774670582; a=rsa-sha256;
	cv=none;
	b=3Hu6PnY8kw9B3tSMUHEZeoLEaURSUMR00/SNEwxtUC7ILvcFnNkjL/KXUMzs86PN05xgEB
	az6EWcK1wQBxfy0QHuxvjLdsGPnFIsyjqum2hGrvJsmuS3hAQvGL5huPgTMoM4eeT1su0m
	2GyYYyNaoVLONSLmiGv16YzN585Uxr0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CRu7QRl/";
	spf=pass (imf21.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ab232cc803so13138905ad.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774670581; x=1775275381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B3Zdm9QRebXAcvnQwXWCkI4HeWD2IUP+mu0t1G2C/Dw=;
        b=CRu7QRl/iHy9MQ08LVMhHJu37pkFuF/0hQzS/1eizIQd//cEEdD5GlsyXwzTIFF6bl
         ++WdSlJBQshDID2ru5bm5CjXGnrLtglINtLW2ErID2DktyInwP/yO2BD0bhl18XDZS/b
         lJNOlusZ6jmNP6SHv3un4PDkyqRvLVN5VuwlFDI59gx5i0RtmO1DLFHVh0CY5+4iMRAm
         E1HSWZqodXl5ub0vSt9RMsBhW6JoCPCET5Apl6Gz1ANrjPhVgby/hnjAokVDrsF0veu0
         fj3X6qkVxMSm75roVAVfhl875HrmyyObmLuPs4gVeYzPWiCkMDN/I6iMOwS9rvUBndd2
         B2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774670581; x=1775275381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B3Zdm9QRebXAcvnQwXWCkI4HeWD2IUP+mu0t1G2C/Dw=;
        b=hx0A2jKJLHDA+XXTn+SgfpPDlRHNb+Dh4FrorGb5h47oiIsAbikyMLjur/goouUemZ
         8JcyThg9k265Ql3cIISXxmy37Qt5cxUvKa/npkYhNP4l1t17+6ZOS5NqITNYw/IEwKeF
         ZdJfQxf2iFEOdWGhUXrJQA7Gw8035giU9GJvga6FnA74cHhrFlNuO8z9AXtahwbIK9tP
         2Q+Ie0nxYm/Fv8dRuUgen2I8COyyfzUh8N51ZGZ3SmyEpETB6tirdMPjaslQT+78tRwK
         hJXhHXMeLv3jVvOsXqIASJZ8Y0f7IcRLzobgGz6ytHa3DxT5Sc6haSenv8ccm0ZNBSji
         6T1A==
X-Forwarded-Encrypted: i=1; AJvYcCUTW3p2TmgiMkI4RhzQbg/cA1Xq6dNJSR2ywCPXtnFfMEbsYSJoks10NUAUMxQUgVh5Swihsantkw==@kvack.org
X-Gm-Message-State: AOJu0Ywym6qnFWrmDw5qWV42LqyXJSPIP+o4oVEtG41OfCZ5ozTPOV5q
	l4gOxQ1PnyFT0fJRdKb9wAAdrRqasgMmlmjmXNIfvs/u+lzS+Ez0mx9w
X-Gm-Gg: ATEYQzzUfiUo73rH+sUx0y9EUYX5cJzLCV3vpWm75k45JVYSpSR6j2PAgI2Otc8bfIk
	Ly+nQBwFgEN9mV0SoZlQgBhKz71MyAMPiodfpcV2fNIilYDSZGg7obW576VMC9jy3d7WdlwsC8Q
	PIw4PGnvm+j9lNp10RdEZRw/5eeEJ5VxwHZykHWC3iiHL6WKj3slPlnEp1RT2BzRmCl2fyyW1B/
	z1elYd5vBLs4rEvXWhsp/bYzhvaqj2OU/02vPTad1glLgevTmSDDldLEbhdhjIv5zsiyzLRYEkV
	qFLegKyhEdopvEdJWeI04NYi7dtfWSq0vIgrdwjfMzGSt2Xab8zyuNPjYQbzEZ+itD2czjaSR/6
	331NEs7loKCTD1MWED4K86CGXkEQ7DDahXbqqZo7E9KbpgdntHcGtXwp1ZkJb/OMeRM+KOQ1G21
	iVn9XuI6x6q3/LH7vcQkLdx6Sn3//TyszxeTNEvgbe8FreKKOCodU=
X-Received: by 2002:a17:902:fc48:b0:2b2:4029:d773 with SMTP id d9443c01a7336-2b24029dc6fmr23134875ad.22.1774670580723;
        Fri, 27 Mar 2026 21:03:00 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24264287csm9018315ad.3.2026.03.27.21.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 21:03:00 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [RFC PATCH v6] mm/damon: add synchronous commit for commit_inputs
Date: Sat, 28 Mar 2026 12:02:56 +0800
Message-ID: <20260328040256.51726-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327071410.73642-1-aethernet65535@gmail.com>
References: <20260327071410.73642-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: yrqkcoedooeticmti16t6tfqerftifkd
X-Rspamd-Queue-Id: 01AFC1C0007
X-Rspam-User: 
X-HE-Tag: 1774670581-989888
X-HE-Meta: U2FsdGVkX19jZ6r8ISfnMRdEfvidRunaB/O0NHY2ToGAwEgASaZce8C11rfXJweC1+je1suvWhAPUe46ST/uP+OHGU1uYgaiezjVrF7UQMc7fz3iclWo6P9zjnvQlIDOA2edbRTJ5OBz19QGIieFY9xi4equP4xEFWCbHnRpOtCU/TJF6zEmmWk1xYShM6vpj+ADmD1Ir8LtYLDaJ/6tOvgZDXVtJnoVLS9f/N4LpRtslr5HTY2zj6W9sQ/MSbgjesjVibrmukKJc/RMol/uWybYOWUGuAjbkoEltOzBb37AELqIZs53jcQgjbS5YLMP9XyBspyDTCn669f9Rv6iu1OC7YCZuCZusQEHN8swSzunjYOF4X0d9jqSa+9zB8+f1LtmRtTeg120tOqbPku0I6fl1+JtUIBxbQyBZmq6l+g7dogJbQa+86e0DtmCd8lfezY9lQS0XlSAlKpRQsChl/JJIzxsEI4L4KQShcfsBgvVtvCzVo5buIkErusbRYPTapeAPAGgClGPh+bk1w3Ve8Ir7NKiLJbkpKjgt2sUk2r209X3ycjxoCoq7BldS2z0g5QDEBQqW0rn2je+vH8kRSf/0pgsg09eNRyduw3XpUx5vswvacxzk1fdkt655xBPDs/hAM/3yZNMcpY2sImxIkBDwT6PG/PkkNfvy4DWHdIXzJsxo2gZ4vkxRLJKAyW9uVoHLmNzDCXqENFaIjDYVxJklz4XXqWPUmh4oCI/9n7LXaTPj94x++bm3UUK+tGrkIETnmWAXZ+fesPfCqKlqN6n8NEpbHRPW32pJy2ldYuzPVJQ/L59j+lX/7YF+bj87QhggeZSaatlcIdAmMB1AQC6omDaOrrfMlCyz2nmRFtZyqfCz2lPaI2CZyKytGQquAY1mKTc9SMI+nl/a4+KA/tQmew05Lsfp2Gh9KcY2cOWZUNUyhmGLd2nTZAPhk0V3tw4yT6JbtO2qDR5Bv0
 fTdBgWFB
 sBVHz6wi/WAc2guoQEkbmpmxe3j2GA9am8lCI136OeHC6E5Oo2Lp25sP4UyY4fh/7Y0VqXB+zSdzZ7rG5FoQDUIBaOUG1VtmD1+WdRLCpT8SGhp9QA0W/Z0BYWiQibBe3ulP56zOy/KwXmvhy6r8ZXlIl/3ER1XprrZCuh1jNFWhnURbhKvfDUUuKxa+2xOXu39ZoXF4x5PIpfNDOLLuGdxnEOAQGU+G/ErjghjIL7iLexd4Uzz4BVfV09r1AIPTyvfvZpnq72l5S5c6l0o2dFJkjsGHRerTrpCK/XqDuJvcx/kmc45FsGt2t18ReWcMTRCUsYD6nF0we0Z+rxvYUXSGhVKQxjmbs1Ycy5k2XTMfkvkoMAiPVNjCx5qVfb6VTCw1bAygBgf2G0wFBDcPhK2BkHbjGv6JUdDJ3mKYz8r9I8Tz4u61u4NeHUC8bbfjPLw6Hsw31a+eUD9q1mP5IZmjB14VIfixgGllr9jeVS0LdI0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	bool commit_inputs_request;
> >  	int err;
> > +	struct damon_call_control control = {
> > +		.fn = damon_lru_sort_commit_inputs_fn,
> > +		.repeat = false,
> 
> Undeclared fields are initialized to zero.  I don't think we need to explicitly
> set repeat here.

Agreed. This change can makes the code more clean.

> > +	return control.return_code;
> 
> Shouldn't we return err if it is not zero?

Correct, I've noticed that as well [1]. But thank you for reminding me
anyway.

> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> 
> Same comments can be applied to changes for this file.

I will apply these changes in the next version. I will remove the RFC
tag because I believe the high-level design in now solid, and the
low-level details have been mostly addressed. :>

[1] https://lore.kernel.org/20260327071410.73642-1-aethernet65535@gmail.com

Best regards,
Rui Yan

