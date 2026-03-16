Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD420F46449
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CF76B0192; Mon, 16 Mar 2026 06:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB046B0194; Mon, 16 Mar 2026 06:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224466B0195; Mon, 16 Mar 2026 06:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 107316B0192
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:48:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC9111A0197
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:48:20 +0000 (UTC)
X-FDA: 84551601960.30.E06ABCA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id E9D0F140006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:48:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b1iYJS3D;
	spf=pass (imf09.hostedemail.com: domain of 38d-3aQkKCOQGROIKXeNRMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=38d-3aQkKCOQGROIKXeNRMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUOGpPWcKDo+U5VR1NrHCLemu1A0Jfaz2D2lBYpe4+s=;
	b=YNMk5MF4SzHiqi5bSnqLj/5Kn7nwPMmg5NjuFSDxB3PVwIUaFEYLF/Pmf5rgyCOjyBn/3e
	Qp3b1NFrYKmlDxx/ZJ5LROhjO0d9KLfodNHkzCRcLTfMCCdFyUUN5XiGlE4Rg/X9gIGFCv
	LhCGntFO0oE9ikaWLXjHYOuqA/ZjMI4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b1iYJS3D;
	spf=pass (imf09.hostedemail.com: domain of 38d-3aQkKCOQGROIKXeNRMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=38d-3aQkKCOQGROIKXeNRMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658099; a=rsa-sha256;
	cv=none;
	b=BYvK1XvcoSNOTrG/TWoK4YkoVEOFPTmfR1gZlWlw5hjreOMCleDRaiLHwGfvxa0W+QEUZX
	k0ID4odhb8ILZElhJl4aq+dAPM5fvjFLV1qxiVcaWGg1T/NCc/1hnZDk6Km939TGWBzOrV
	pUUAPJqGf4NMDfNYIXr7M65Y95jGHo8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485389bf0daso30198305e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773658097; x=1774262897; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cUOGpPWcKDo+U5VR1NrHCLemu1A0Jfaz2D2lBYpe4+s=;
        b=b1iYJS3DmiaCsl3YgqsPhmssUitZWBlQCl3tXDrlMzEAF1QAEd4JV3DlPIa2T4TSsO
         6sHICdW5XososYEH/uzA6G4OBukU30Q/GysMYl2I3vtV8O+FdtuN/UIkya5T8mKFj0p+
         MDiYmbXXaCm4DkyFbT/19bK6bVNuzltlKsuHWt9cZYwmMxwxTE6z9dl+nqhBQTBNDlLE
         W4L5L1npyuY7lVKZZeTWLvUme/YDFvctBZZWrNHyU1GdNgYp1zM5ocjonR9+8ltgKqpM
         Q2k299cWSz9h725QAtJt21CzUuialTv7iBpsowJeZ/zhsvm63HgQFAxx5skeDFdEXG64
         cXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658097; x=1774262897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cUOGpPWcKDo+U5VR1NrHCLemu1A0Jfaz2D2lBYpe4+s=;
        b=KMwQAjZWBFfYMbo012mv7JjMiNXFBdIusZnwxI3rgPpqLKcvazlMfXH9mFsNCJQrCv
         +682QDOuDm8Po8nYDUV0ORIRA/gJHsXsgV081bde39Zr0MiSdVjauVoFLMXTOSvsDpYV
         O05pqJZSDeS1hwSZyz/YD6nC1nh+RCyb/DQ8qxi6F0s7SC5owvWzw391HXtaxdOOkogK
         PeYpO36sZQ6zizwhH7aeuxhGz+3WhGuir73st10KFAIU1AeLUE//CsuuZjkvUQhmiXtk
         M8xJX2F5GXmzX5y/drgEyO2EWVLKYi+UHW19Cvk7H5Q4D4IckNZ0HUVTpN3inXSCxzx3
         6kgw==
X-Forwarded-Encrypted: i=1; AJvYcCVfkOc2ESIiUuCtszSEFoSQcHGvWvyPvAlpVP0fopqn0ngPqi6QSI7FiKYSmn2x6rE+heBN//9ZIQ==@kvack.org
X-Gm-Message-State: AOJu0YzX7+W6dl/IQ3QHXBUNZ3vz04Ad44XYg959Ae8rTgyzofKbit2u
	VXjUasjkRPmQJ2wTMsRfsjQ+cgARQI5qWu2ZPUnqIQZwedhJrIPxNu6bgohsUBhRV499A8fgybR
	A+tsa+wIy0GI4s3Bkkw==
X-Received: from wmco2.prod.google.com ([2002:a05:600c:a302:b0:485:3b4c:3e34])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b14:b0:485:3f1c:d8a4 with SMTP id 5b1f17b1804b1-485566d6e54mr215274655e9.9.1773658097378;
 Mon, 16 Mar 2026 03:48:17 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:48:16 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-18-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-18-de9a7af4b469@kernel.org>
Message-ID: <abff8Hb4FAN1e39U@google.com>
Subject: Re: [PATCH 18/79] block: rust: add Request::sectors() method
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E9D0F140006
X-Stat-Signature: 3xsdsro5ikj93xg3ueb4ph36b9y8k884
X-Rspam-User: 
X-HE-Tag: 1773658098-324163
X-HE-Meta: U2FsdGVkX1/K8s/c1z3YfSYxw9D3bfjgRK8sAOIbbw+B/1G9Hcu9b0oiH0e3Elpz1cGSJGChO8bHqsYrZ+kL7xogC59ppm4IrCzDaKdb+1KcB2liZ2sVbbw021xQhnT0RJ0NnABgUShpZLpD3+1lTIhTc/jSzq3xMPtbjF8S1zVU6CTuyIJGGlTYyxOK9qmwc40s9qTy7Bh4W0O1GUENGfC8GYqX4LClvGarf5zwJPsm2H5LDsxiy1JLdWPe0fwHQYedroPu4Ch4SCLvL1fXNSNybiugm94O8V+jNDGO252YFfOdF2vkycMVtKPGltHWEflSBJNFqAjpmVsd8RKAr/58IDA7LAIXvXOz0czt8RmJU79cUiPZzZHt2iU8OHj4j0Co/FJSOyl23p8HXxLAVe1qrmj5ayVklUe6tVydwUPqU/SCtyV/7l3NgtG9ogq24qhnbHoFOz+MbWcluygnedeNSfBYLEcxmtWEKWLIKzqEEcC9y3SX1TT0n/zprv1/0okR4I2qfjh/JBBNNUM0sF67V00Q+Qsx+ILTok4S+3I+e33bBh4+QTHwGYsT+lb7//jPKNd0N0CM6GU1ar8eNdjb2kGZJbElNPLJyfu4KOwsVfwpl+lBINQbi7kRD6+NjJV6UYdr5jAKjIuiifxusI84sDv4vBW1AnPhur9IxuyNX5bjLLyitMjuEXil3a57f/uCUxVmaBm6/x/fvWlHmRgpFJ+4Q5n4xvUQG6in3IFLojbxiHCShE5dwhDSeuijQKU0v/CiCfNrma6zjGL5LgEM1naCIFByZ/kzYSbu1VJNo2lEFQdcAXnawB1VHgfuGZPzm8R8+NO4PCbJ1XwNjjZMEfGFc5JdTxntAD70WQhsjCq1/gHaS4iMrfi6z9XK50HisLaR5Slz5xFDh1a4hKVCKcdLjDk5ObG4N6caJAXHVWpjEnwEnURBtcqzfdGHQB7wHe0fNqK1+edQ/Jz
 mpIcWZI/
 mQ6D8yRWYB+o20OdJWGwnc5BI8EY5QH05iCm0R8jfhZ5IKMg8DaECU0Gb2xUiAUNeDrgCWs3kgZJqvMICGlur/WP8pBgPY5Wg5m1umRPIra9jrCX7mXZCKtB3Wv973esxoAvUcBoaUZtw19ttTSlB7VEJv7KzoRJsmciZ8CR9ntIHVJbwYuYBUG26suw7yee8RXLUkFdrD/Zn9yFkuA60s31obpihwfwFyKvwKRVltF1CgGitD+hP35rkwFlYO9BD97G5lqLsB0r7evzB2MyDTe3U1OmVzLJs1SndteaYbQQI55olTjBlWw/DsR0X1y/VyzUFrBH7J+yWKVcuND8mRHMxDUm1pC6BM2kOmIXmAl+7wEZMDvTy7jWuOKxZdEcU1sPrhql1sUOOCG/wXwx7Zo6ZzY79ewzgun+ZwCBUyRn0Z/SRpt5mKIr9Jzl41vT2OFfB6t/o4CWJzDK9HR4rRdcXEKK6YqcgC7zXwJny2RiJAlcZlyuFiI5gWNyGWgRz6TkWYDqaKcVITsLmVe/32toqc64Wz+GFG10vUQhN9LImWOI0lOATnD6GRhXIObUb3X8xvqi97lcs4wqtwm/ZMLfJrY3AGlydydlbh005ySs/A60MoQ4dFdfAtydeMg+4xiPGOZDYET9H3xMo5rKeXYH8bCT/qlnSSi4akLsfZdLvNciSYS4b5OwJwG70PbYPgcJTtov2sXxHJcKBtcY1dVpKcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:05AM +0100, Andreas Hindborg wrote:
> Add a new method to get the size of a request in number of sectors.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

