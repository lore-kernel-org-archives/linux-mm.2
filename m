Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF39C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952316B0098; Mon,  7 Sep 2026 08:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AA96B00A0; Mon,  7 Sep 2026 08:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A3A6B00A4; Mon,  7 Sep 2026 08:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62BC06B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:58:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6E9614015F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:58:57 +0000 (UTC)
X-FDA: 85186971114.05.ADC959F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 43BAB40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:58:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=oUyzEpfT;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHdOkbIKfr7/ASq37mhCdAbaAVm6/fScVRomtNzy0Lk=;
	b=51GIiu87sKmM5RrBorpHkv1hf3PXKuIrWBP73aSqroqLx8LbIWH2Q9KSfJmOZq0FCVqpX8
	m/aAa1uNvpaPEnqztpFhsLjmaKUyOKmxRL30NNKc8LfcvzO9pFHD8Bn562reo+OJD03SRg
	90sCiVlwr39ApOEbJnUWbXHYuvzMhao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785936;
	b=mHALOBLlUu65xVV2+uShty2+g/F7sXB82Fnki0y6zY1NV0776rjxsHcFY7AIQsr9TbjZ8U
	mEbEnmh4a7ULNKIU5qGsDmcYO+oBEuNb1WOfbpoi1fhlXn8ziEZ3nSrg/rzVyy8m9OQjNW
	qW+JZTiFLL3tm52AfKCOUk25X5LJigQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=oUyzEpfT;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iHdOkbIKfr7/ASq37mhCdAbaAVm6/fScVRomtNzy0Lk=; b=oUyzEpfTycyS0r3ntkq/mfmtZ/
	cACWtCsHksclpKdb2/Fem9oyipif1F7zu2ixiszE1Q1feq0ilyPydN3B/RmwreNRX5HszgbhKNkAc
	tFrE6skJR2a+Cm6KowL++qdXCcVeBSdBZ2dCA+p+5N7EQeP6bOsS3CazzRGe7bNIZUE0M3fUjlprz
	CbW+Kd5mo4yyFK/fbpB7Lcii2axsrZke086LQhpvNWwyb6kw7Tw2OXaPdC4HvOnlrE40O1ioE+MG2
	39aAJ9smkmAJ95p0PPpjNbxozGyVwUVBV1lW0ipBDTYEW3fX3xEn+UT3ukorZbDtEkKHzOQC13yzW
	Rj5PmdAA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x3Yvy-001WXe-1k;
	Mon, 07 Sep 2026 12:58:50 +0000
Date: Mon, 7 Sep 2026 05:58:46 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/5] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Message-ID: <ap60qTdp1Tpu9oLg@gmail.com>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
X-Debian-User: leitao
X-Stat-Signature: 1muuhkmm5x6c4ytryy1o7c7mnoxwsrt1
X-Rspamd-Queue-Id: 43BAB40006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788785936-343809
X-HE-Meta: U2FsdGVkX18f9uYCUBqs8fo/aB1W8pUIp4JKvdoR5a5Tmp5WNts4wOlMBFVi91uCOb5YqqiLBiZDODo0n6exwJO2z8ROvB1xBuGa2pyhdawLSc+sOsy6P4qXMmx3MNHgb03s6Uez6V2NppK8D2dEmqSGaOllqKdzDJI4A91VB1s6oGfISkShJLtTXYXYGcTO6pUNIKVR7sldAj7/nlSZe9MXqRY2Zr0YoArWwV6rXGXRCCdIF8tWhBud4zbIV9Ll3ArZvcT6kbrrTM7S/NcGMtw87MeYISpYTeR4mXBVnqMmka5MpwxNjac+aXuvdNxrx6NGxZB0bmsgb27dNp3m6eaMfvKThJABJniT7hNbNWPBh6nTrT6tMkJbVACXzAyUjjVoCA4Vq6CcwUKE7jfaLIklg9O2Rp0yvkLoLRFgwfvcmCf3x+2SXOa0uCjZrNIcUhZmaT1wfyMDafcUt7x6nCls1MXiRlgtUOX+pGY4SGsrBaTKU3xgQNrGlXv1ec2Zxp3lRCWvjBbtMA3iIDTEEWGegSJaEjq1/HY+j+7gRhD8ualF2y/4E3qOhI8XR1izZi6N3xDKcgBpsWCyIixbMnWnrswegfw8banhIgiQrp4v/eSN9bMkD30q1sDQNDRjWiNidYz787xMW53F+YuPkiFymfq/a20v4G/4HNIKg5x3AmpVosaCwhCGvLVPL9tbGUzpvQse8y4lXKsmi37oXlVWf0vvwwvHtFmStOWfa0tvcl7s5GXd4fkXBIue/QXV2bq700jVi+JyRu0evbcOvidPYQbKKS5OC1xzbeRB399PTF4FjKzMhVLHGAaoshaGcNoXLdnHMxe4iaWUzDG7nqAyVBcBsm/eLjt1uKWIDhN/Qp1uSuxdTu8P1Xd6IEMC9+0oPffAgI5bihz+VKd9REAyAJ8eG5xnS4+WSf0Zc7oc5x+f/8TTx8NdKOc+eAfpuYl2q/bpWPU+hPTuwwN
 dISH8tis
 bO8iZYIgGmzAldaR3rTDesloRpzx0IGV+KGOa7GrCJcnG0rM0LE/sQIgtSxxNbc3cflQlhunQxwfOh//GddGYZJqEsR9/1+HngjqHpF1FKxO5RuPbVnPk4vNpkCyidVWQdgfz2RsleqcKiErv/BnThFpKDzPf+tW/IxoHdDqDalstn/iLl8dkopShxxB9Zfu6ju6uH+i6sqTJlKhGc2vcEnYzcaMPYRFxSx3BDfkpJrP490lmKtamaeRmZZ+hQZkobWxbk6LAOiR+dZmoCiwbo86siA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ard,

On Wed, Aug 26, 2026 at 05:03:51AM -0700, Breno Leitao wrote:
> Proposed Solution:
> ==================
>
> Carry the poisoned frames to the next kernel in a new EFI configuration
> table, LINUX_EFI_POISONED_MEMORY.

I'm updating the series to address Kiryl's feedback, and before posting
the next version I wanted to check whether this approach is fine with you
from the EFI side.

It mirrors what unaccepted memory already does, so there's nothing new
here, but I'd like to confirm you'd be Ok with it.

Thanks,
--breno

