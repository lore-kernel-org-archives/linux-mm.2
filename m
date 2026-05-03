Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFBFACD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 14:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2056B008A; Sun,  3 May 2026 10:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362B46B008C; Sun,  3 May 2026 10:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278BE6B0092; Sun,  3 May 2026 10:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18E466B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:56:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B740E14097A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:56:20 +0000 (UTC)
X-FDA: 84726409320.14.615C9EA
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf12.hostedemail.com (Postfix) with ESMTP id 077FF40004
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:56:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=AZE4All2;
	spf=pass (imf12.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777820179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AKPIGhRNxK+F55Mad0JawX+0GWunrA5WkX6nSEFGLc=;
	b=rIbppn1C3O3/6VS5P81SZr8a7UtHMJ0nUKMX7fhC30jhDRa7/050JxLJr1RJ2I3R+fSi9S
	DLRrAMmtkpja3j4LWUO8PO4oAddPEFvBOW2r/nQGWIvFaANoumh3z3qPWZmEpsb/Xf3eRH
	XJds066KlzVFi4wcfbuJ9a1cPSxpvpY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=AZE4All2;
	spf=pass (imf12.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777820179; a=rsa-sha256;
	cv=none;
	b=JsAjqvt9LCxfwXaxyYTfmS84y5woFlACMBdaZXok5oqhYNUI/hUdRgRDKw54hI3trXWwf/
	6OKLgd77SLXvhDZxKtWA7z/jipKQxUFaIZ8R70Ixh3Px2EEaRW3jNSafX6yjxMvfZWmIfB
	o8w/enUNH43xEwRydurTDFCIDtWqtc4=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A43DE41084
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1777820177; bh=1AKPIGhRNxK+F55Mad0JawX+0GWunrA5WkX6nSEFGLc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=AZE4All21O1rxm3+Fs4hD9srnEfVhetFdksjrOjV3VD83csa9mPQsIaE0wida9+9J
	 N+/xzjN768Ltum5SPW5NP76mL8D77ZLeuY3QwLSSpZWPmw7VTqr6LcLxxFsoyryih3
	 Cw7BRrH81/AYfcwvJ71axSfFI/4S7mM2rQAHBsZnKVA2mA+9rgikt6qRgqBgHa/ToH
	 SEOUJ3eoxda3ocAZisstFiiLSLe7COi99q7zzLDnR3vl8PISisuLK1ag43oadhDND3
	 Q6gvfwOjNy5JPuH747ES0aqGA8aejR+WZLmznez7o0Kb03gnnNKwpOq5obvRrNNsCm
	 1wUuJoEIqo0BQ==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id A43DE41084;
	Sun,  3 May 2026 14:56:16 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Manuel Ebner <manuelebner@mailbox.org>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, Kees Cook
 <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
 linux-sound@vger.kernel.org, rcu@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, Manuel Ebner
 <manuelebner@mailbox.org>
Subject: Re: [PATCH v4 0/3] Documentation: adopt new coding style of
 type-aware kmalloc-family
In-Reply-To: <20260429070759.309110-3-manuelebner@mailbox.org>
References: <20260429070759.309110-3-manuelebner@mailbox.org>
Date: Sun, 03 May 2026 08:56:13 -0600
Message-ID: <87o6iwczjm.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: pdrht6cdcdwg1a6bu63kyija9xxinr5i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 077FF40004
X-Rspam-User: 
X-HE-Tag: 1777820178-353047
X-HE-Meta: U2FsdGVkX1/cj6q7I7vRxgJh3UmdkG9xhueXtDWHZoaTR0Maso+wuU1q90W7BMPeufIdPSk6EIvZeIobReRM9BclSnOs6D7Zmzor4J35wtUjKO915v+fZL/ePhYYZig2dYXdEBr2OAY67Z/e6VfBg36FC/VKpb8UoXLypr6rTB+0WLXWYPSB3JJUa1kCtInST+8XEBY1qjejntdkx6IS0uhw3hRAjTLuj/s2UH/0OHSVB6i28vsXnrmuVK5+5ZXR0a89FuHMUd9jsCpL/2Y6R0bmIOZANMbAODuWMNWrK6fEC4AMmXNVPM45jXu5k4JqTqf4jQy3CT95wDITuaxRWdgcTEnVq7TIogk6HgOEvsrE71anmAcwQAB8ZOppTEN01oL1WW4YTqwRcVpHyNoE9hLUtA5F0jcMqqxJn08nOKWILhT3ca/xH0crpejOGYpFASCmvSxDDF1Y+L7lc9LVGeEfaaKlSqmGOec/AvBS5DNcEtAFqqheR7wfB6GBKhjrGcv/6/+VHfJxdnfjQmIV1Y13BdNXfPpR4DkoRz7ply7QUeYwTSav+pD2OSsyL8uZPF3+wyRMyb+17ThRJ1kNFWsFvyZyY4K4yqfMIUSzAxTVqXfpQDaQn9+wnOoJUVB43qbeD+wYVpJkgb/rj5X2GDGVZ9/cg0iMnoxbnjkw/kvi1vfHut7mr9HrmLn3/XkJZdqaHOo2ZzpQkzXpG3YUjsRcQW50/GXcGsr0WlbhWHqCcH/5HR3Q291xQtyC0CrvgwGmDd4K/PIUgllxokzJd6h81vLJh/vgQfYV4fa4e8ONq/fxFXycN7IIOHQRL8OR4++C3MtKVUaBrIbTJcom5IGO5Br2UNXQs3eeJSHYYWrCZLFsTIrzn1m7IOPusuiuvkSpjS3boAC5RWR+Dnmqz0iMo/ZZiHFtNEH2Ih3Gbqa2sW/6DOLx6w6hDnl4zfiIvZ5OINYubZUJFkZIdmz
 OvxCzqid
 XgTCOC11Ory6K0JPCJ/Q2Eap1Im/NbWUQx4Qo/QAh7U0ZfjjEyOCHCHdEvbyMf6TDv+pfN/KIXR4/ycsyAJId9b1Lpdz04YiEJL2oS39QZ41cIc3H9iEZ2oik54VuM8NXt6GkKd3G4deIK205Avs9CBqdE/qDXYqfKMbWl98Mqt8YXDbL7c07km1TNEdGU2fD6hQaX8lKB+qiqZ1VU7U3SHcVins7hdnQ0pCm6cCgaZM6P4OCguuJyJBaoZdScrIF06Lx2lXVfnihLShRCL4LBx3a2mzfkWkOhZXspdR1gVdSdm0CiFztD80GWAnIBDyJ2QjC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Manuel Ebner <manuelebner@mailbox.org> writes:

> Update the documentation to reflect new type-aware kmalloc-family as
> suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
> and family")

OK, I have applied this series.  While doing so, I restored the "gfp"
parameter in the changelog portion where it had been mistakenly removed.

Thanks,

jon

