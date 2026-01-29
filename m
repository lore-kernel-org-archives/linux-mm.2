Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D9BD73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB536B0088; Thu, 29 Jan 2026 16:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E946B0089; Thu, 29 Jan 2026 16:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A136B008A; Thu, 29 Jan 2026 16:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFFC16B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:18:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B1291B09CB
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:18:00 +0000 (UTC)
X-FDA: 84386263920.22.BA83B7D
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id D693380007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:17:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EdSrYtuG;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9xIkbZKM30zA9x2QI+alFDGiuf8CP4pmINW3Kx7q0w=;
	b=p87HDhAoMvHmMnIxvhm+muR65F05zaD33NzATcvdt611EmvqmhfCQYkaFwbAQoeWATQjrF
	1A41c9Dw9BktIiBjs3QcX1FZb9YMwPRpXA4s8+sIkNqfLGXnkGGLXQLCvxAxanhjp1XGTU
	ALf6KO8FQ3YF5Cxckb/V9T6Rq0cKmMc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EdSrYtuG;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721478; a=rsa-sha256;
	cv=none;
	b=TVmH1tXlnHGcyVKxxHF38vGqSpgXFzNwtfSI/yJwKkPnQ3Uo721P0+i5J4K0e7nnFArrY8
	nw0POtqMDNK58gvcH6P4tKhWd5xrQaa3ARsplv92N4BQD5KeoNLPzafYLEQ3hZiHafsh8+
	DL+/1yThr3NpW7Y2SUf64byg72sNczc=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8946e32e534so17063596d6.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769721478; x=1770326278; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l9xIkbZKM30zA9x2QI+alFDGiuf8CP4pmINW3Kx7q0w=;
        b=EdSrYtuGthBdwGmjVv3exmmB8YozobgnPUcBSiinLXOXwrZbzTRqfiRMPegYZYpOQh
         FvNvPD91XqLnFx/TnDd2ebcSO7DQFufSrNEmUSIX29LbwOIiKWM3K12DxtKqv5ZkbFq6
         31m+cB9/8Sta1aNo7xnmbHUa9p2gey5p2c/XeY365UmHKWntXryTNInEPOlq+iaL5YHA
         GdHjhVtCUWq6VcHGZL2arL4VTsWAnseFRxoti7pwUBpyovSHP9oX5lhl9wAyGcXmt6zQ
         6QXhukIbjBCnqkjs0uzcovBzLzEk2MsH9Bt2uj/qFJBG2TyM3yn5qCfhACd4Ahc5KfyT
         hv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721478; x=1770326278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9xIkbZKM30zA9x2QI+alFDGiuf8CP4pmINW3Kx7q0w=;
        b=SQXoLSW99POmjEGI1DyjjP3MlMLD+dr/3X4BjIVc2S9XnxJkmBHigFDYe9Z8tqzL0Q
         P9SGxYmniUjnnlJ76hjzBrABRUnaB6BjnY99EUVXj693og+09LFm3zGX/6LIbeJ18bqA
         h+gknshwstL1Q/ZmNp54PpPZdldKLVj3rC+jAjJgsSgP+JtcCKjWcjQn1xEXI8cC1fz4
         jwxXY83rzIMx5Z9IRqO5kgm4aHyaYMT36QdnFTRDDSe67YH3eQtF/fI/ZTjaHrzI7fMY
         9jeW2Bz0GqT4GykzSmnGfCTEACtAmstmCkBUhxGTQPy+5ee4ItneGyCT9kcnaMYfH0Yf
         DnhA==
X-Gm-Message-State: AOJu0YzgjgnGSGqIJl5lTOoNL9aJKQWjuuZRRU/vfQRJI3DX0L0bEfXQ
	uEy/MoVCGj8Mc4mOcvbAp1URVgCxxIA3t63uSVLqIhMD7Otx3urA3GA6nwZzRM5L7FYFrcXs3dJ
	G/j7SG90=
X-Gm-Gg: AZuq6aIChlbzxcKCbEFDUMaNQ6skc1QOezxvutycQZTwOAPreRDKNSoWrVZkBxoNJnE
	gA3Z3cV+8ClXFE6tPPWEmuXGegGg1yuvAwXEKHFz94h1Hs+rgVRwwUX86POj7o8lQRgCzkBV6gV
	UvxR/Rw2epUV+2UNT+NX52ewbihEeBduBHOhrH/EXJbIzE60ldt3fY/I9roz8UHLMTgamDvdaw6
	rQEBWy/lKT0jcSAU23ghBhrkjccSjrgWsxUs4wVdMtpPl1AtbDjmViF/WzZ4pI2XSLdgUi9IZWZ
	liWyejcBeN88Kv8DhLIBqqeF9w/lMSNZooa31kY0KG9qnqJ12uAff+acxP69wgR2jQ0Ss4nC9Bt
	HcKarPE6QOqazOX9EoWajSLtFv+bRKgLy/yzTzFEPzXCu88TREAYsY8FP/AQdX71LeeJqL3s3fS
	3dgI7ef95sG/MjvEYK6DvUzOzxEZJ3Ub4qty4ryZpuLCbXrsSLqDts/O1vw2TR7vd7j9MT/A==
X-Received: by 2002:a05:6214:401d:b0:894:71c0:6fc with SMTP id 6a1803df08f44-894ea1170b8mr13110576d6.57.1769721477709;
        Thu, 29 Jan 2026 13:17:57 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36a5ca2sm44936276d6.7.2026.01.29.13.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:17:57 -0800 (PST)
Date: Thu, 29 Jan 2026 16:17:55 -0500
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 0/9] cxl: explicit DAX driver selection and hotplug
Message-ID: <aXvOgw2rc8X7Cqxa@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D693380007
X-Stat-Signature: uzhz8ndkcx9xs6c5uswyfoja4pbhqhka
X-Rspam-User: 
X-HE-Tag: 1769721478-696198
X-HE-Meta: U2FsdGVkX19KcubfuC5MGMYYB3H/WUQBt4h3MSNjxqyXPJber2bI3lqyLNekKlp538Yh9tznBreMvb9E7ON24kPiIdLzfQ/Mvnfvzrm8JMDU6gktvPMdsGfpZ+JAyF6PKgCAQfk8sPLCrVV10Y62a+ZrBxRcJ28pou6jzGu6g0FTxyW4NJ0oPVl8EHPeIlPq9xlrco/ZFfej0mCVKhw+QzSDx4wccirvWmvVssO6IHJ/pRzsuqBPOm/W7yZAnNq30+e+aNdtRpUoCEHyw5EYJxQlNB5LUVQyoOQWbUCRLVOr0f7wGdHWZyyHpi16CRKKa4BM420d/r3evAGaKNImhw9j9a1DplsGoaWPes9+IIPvfOW8mXOJI8reZNsKuZEz1NoQucBHEChFXiisv/bolwcrPbiYhlDlCa1I19UZjDF+qUVn92AENzIfqmj5j2g5xXQbAMCFvQe/6e5/nqet6Owv2ZhQCvfMfT5tuHZaxhEvCgvpLEl5gX0uQZGCyMQv7mGukttLm/l6JVa2Nrm1YcqR/Z/fKMZqHG2tDDsr1LaSuzCsm+m37PChzHFz9PvfnkTTYtA0melunFOPM2ffvdpzENA9ODZiNOZLVEI+fbzwOQewPOYwP+IhjsfYCc03jzP8PICk7O4miH+V/wxoThwHHHIuRP3dUPI8TmNKIxhyiS9ftSO1ninfV1Ib/yI4NRr6l+epug6gRj7+DwykY2sZwbwl1A1ktmRZziOruaaeLM36HxAhwOTzT5DO4hn1pUPuQFrismQrQluhcCcJhV3zHoLG5eJU7Scjhna+Cgancii5aEguwPMpNWMXTk/6AcRP0ntb1JbILbK0ECKwzxXrGLwSoxPGENCTyBSwce5mLBAqtzXJRX9XUTwZVbLRdziK0TGafILQTZ/b3vXH41J9gUeyHWdCZaa5TJoCLRT3zzq2Cpa4GNoEXn5j8//cvIU0ATxrosFPCFLVTXc
 sHsJqqBf
 5Hojme7ptC53nf6QbZ5eA1/+m/2mAD6DKnJ2YlC3V6aI2N/qsIqxD/35fgZXyoAXg2kl63L5PPE48L4nS7oNgOG5yt+t9L0t64/Px+fx7NUSVXdfJoUE2k7GmyVYQIRKbzZXvKZ52t5Nkq7txCWbHj+FucA2cm2ofdqWgie/bf4r1NJWGs9z8XpBZ5/HfJk3Rzlbw1dZm0GOg1kBWqJv+8pNPeFpMjyvOb8+/xkGNEEYuAhyMiBaUbIGsWWLyNPYGFCB6SrpOTyE1FfCjojALOuR8OavZu52sSCXtr87MxKKGuUdyexdMrybCQlqBnpiYRFVkGEqnPSu0dMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Annoyingly, my email client has been truncating my titles:

cxl: explicit DAX driver selection and hotplug policy for CXL regions

~Gregory

