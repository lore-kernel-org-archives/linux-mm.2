Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158ADC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067326B00AB; Fri, 10 Jul 2026 10:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017766B00AC; Fri, 10 Jul 2026 10:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23C96B00AF; Fri, 10 Jul 2026 10:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAEFA6B00AB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:06:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C8FB140477
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:06:19 +0000 (UTC)
X-FDA: 84973041678.07.3DAC246
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 72CF7A0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:06:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="izD/LZLr";
	spf=pass (imf25.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783692377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zqoMSC9CKLV7T331cHIk+yii31h/xyMfRSAoEynpd8=;
	b=3Sx2F21RqOOpj8epbKgA/jHyz8Q5via6lbY08LfhTWyR6cedPsWwhovL95w/BYIaUau0xT
	+/UqP8UbWehSTOgrZdmTyC3UWcdPhmebv3AhGZXOvsQDbOdwVdo4DlbF9YFVPGHan+x89z
	Qljc1xgfMkizxyOi0EnrmSFySNN49b0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="izD/LZLr";
	spf=pass (imf25.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783692377;
	b=zHUlybzzGJLUX486sohCXwfiJ2vAFgSYnG/BL37QaVMqdfCo1F89AfWLJ8cB3/Sv+vWQ+m
	OZ3et8TaJyjQ1+RUol0dzuV1StBKSdlE0qKTRt4AxiCUjDOajQ54ZMY8CvnSClwldepSvl
	hORChsIsGCBTjJf57O1qxPWE/cnt8JY=
Received: from macsyma.thunk.org ([151.240.45.41])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66AE660J028346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jul 2026 10:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1783692370; bh=3zqoMSC9CKLV7T331cHIk+yii31h/xyMfRSAoEynpd8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=izD/LZLrNcYJlmA98WB7rJMHDCpuwZoblZaecWzVR7nBh+GXIC4umyXWcURJwfi0O
	 6WWuP6xzMThrqr7JfhOR6kog63mYv5R4jV/p/+FTxd/4cu8RnmuWtHW12s9koFEwjN
	 YNh9Mrl01WjMvJJVPmGUR8ZzA4vN3J2OXvT+D/XDES2ClRO/+8O7i1TBRLW9PytlAH
	 YPkL8fis/pizDGNdhWCqoRPSY3m4lVzwbl/SiRkbm+sBBDmC3kxya1BQJL3D5TtdcE
	 bAGEMPy20l/7WMYAt5Vep+DWJ1CNX7U3ee2Bs2hB3d3YpsZue3iv3C8RQz28oy/iwR
	 L9tXi20wtyTuA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 09B1B9552B1; Fri, 10 Jul 2026 10:06:06 -0400 (EDT)
Date: Fri, 10 Jul 2026 10:06:05 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Longxing Li <coregee2000@gmail.com>, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion
Message-ID: <alD7q_AUlNaUwAup@mit.edu>
References: <20260709075613.854-1-coregee2000@gmail.com>
 <ak-mQ2DnbaxIO_WU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak-mQ2DnbaxIO_WU@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72CF7A0004
X-Stat-Signature: imdgnxr7moyacwm1omiqr3cjareaz4u8
X-HE-Tag: 1783692377-517979
X-HE-Meta: U2FsdGVkX1/CTYXLZDvz/p5W6oM7PUOwlJWC77WSXlvbMVo03hs+kMGwhggwKstwCYsIthRmIMQUVwVpVgB45q1qgbDN93pp31E2eDwsrdGSuImatKBn8YAtwKkhlfJbnVVvFkiG8lTQ/V7iXCiSNrbi4U/nBCJaUsyzPhcz8NJe8p2hMAUCviQiJ1U0lMVKDFR9h4M2VfC3zCVoWSlfmIAq9Jkyq9dFnMLHykfKtu3Ud0AoyZiKBZHOTCjA2wnWFOHMDzBq1rTpyO9C35SNwxevmaOodxeisWVtFuvf6bTGzLaVySGEYNTdH5TQmgCiN/I/emMO47aem+eWe3FJXJRANVpLa7hUL0XBkwPL3vxRJszCfgSWJm8z4W1Ul2bwXFLoneYsk32cvK+xd4eRIBVSJPdpdY84vLD4gGVazqTan+v3ddlH/iymSppCBAAZFmly4rREYGapKr9Rr2ZlweweRrg7d8RiySJ65nS9UVLtRaJYZ1I0aTMoDS1LGAZCw3cFsI7TL7JVPxXv8ueSjVR9FbCP6SzPmaKEIvmFvz88qlq64/As+NKYy0Nnr7VEe+N4eKVvKU0zhKqa/ctSnvFq7O4JOgMsW+wMBIaJJ1rkvaU5RwJFY+iydVmYEDevmgVrFibRKMMWLIKtcX2CdYfhrLvcRpYOrg94Vekn0lBjhTi3EUcTc0oLBv4DzV5SeHy0DLQ9rGI2OrHzTtczzPhlJ5bAkr6DHl87agq3Y9obcuq9070028GZFRed4zvg4RUVOMVKtbw/s+eEtnNUDX1eItvQ3TbLGQumaonHwsncAW2+rT5MZpqagMqoiRXYRXRkAaE37wnxIgnGZIUVqMfP2bdzxo0qxJ/1eUak12eQqSeAsMAI4SBeGL4NcPFCB0YFqi7odgJfi0jk1hNZXCfEhh7y8770MjjO1ChCHy//WC1TFTPbD6JsD2rnoQ6eQqwUjL2YvpB0Dh7YVZv
 w/Y+hfIU
 Gzc/UxWlvgzVH5acluL+zTEEcVLp8xwclM8FbjAFgOPnPPFfPB6dGkCngTKBr/2a7S2Hm3b71FTAdjNxXa/OjloZd4UacdXmw1JdCvoZp+b/ctZ5gUE7lPggq1PQyEkaX4BrRozSNoUE3LEne/Uh3iP7u3HU1ZQoQhzxNer/v7lIpa9aoWl8Zl2o6/1y2g0Rt44NMPcn9BBbSm3/iR4zjTz91vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 02:46:43PM -0500, Matthew Wilcox wrote:
> 
> (also if this patch isn't AI slop, it's doing a Really Good Job of
> pretending to be AI slop.  Why would you choose 'unsigned short' as
> the type?)

It's AI slop that didn't even bother to run it by an AI patch quality
review process such as Sashiko:

- [High] Skipping `queue_work()` when `igrab()` fails causes a permanent deadlock
during inode eviction by stranding pages in writeback state.
- [High] A data race and logical flaw with the 1-bit `i_rsv_need_iput` flag causes
permanent inode reference leaks during concurrent I/O completions.

Syzbot also reported the inconsistent igrab state issue.  So it's AI
slop that wasted resources both with Shashiko and Syzbot....

Longxing Li, whether or not this is AI slop, this patch will tend to
cause me to distrust any future code submissions form you.  I suggest
that you test patches and look at the code much more carefully before
sending, if you don't want to have a bad reputation as a patch
submitter.

Best regards,

					- Ted

