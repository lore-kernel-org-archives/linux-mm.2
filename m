Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD30CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79ADA6B0005; Mon, 18 May 2026 17:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C5C6B0088; Mon, 18 May 2026 17:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662266B008C; Mon, 18 May 2026 17:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51CEF6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:33:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC8D0A0968
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:33:18 +0000 (UTC)
X-FDA: 84781841676.08.5C2B9F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BC20E2000F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:33:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BiKbDEQz;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779139997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKWo27Z+f2DcLf24bk6E0KmJCuO65zyx6oi8bKoZFmo=;
	b=5XYVJawLnByvzh/K9SXtitwtpMMCnHdu9F3r1r8iG4N++dT4TOD5vw4r874D2DSrFIZbFk
	FBH3aGyTwP5VZRw7k8mHiN86fP3VxjzMDgfbIyBPOYiD3kpc0w4JlzwW1yzAVdu+c4Sg9B
	8uk10jwP1dBpbQf8cnTBpUh0C7EoHaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779139997; a=rsa-sha256;
	cv=none;
	b=nxT5u19KaSOaYbQbxobZdCPFbMERdrA0aWVhoy0RDvItnBeCkW1drXdUcC+zjeKl4N/BvO
	KjytSGXgNDTptV7nPnYViRpIw0RXSR0Kg2QRzfQrSaflbks/m/eqH+b66ozbcw759kHclb
	9kRnq/3sRws6/hBw0JGaQ460ntaeSFs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BiKbDEQz;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0C4F41ABD;
	Mon, 18 May 2026 21:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635E1C2BCB7;
	Mon, 18 May 2026 21:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779139995;
	bh=XxRzFcUOc98Gp/mHuZcGG64BOJ71fKEnWXZnAvJc0JI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BiKbDEQzQ58qu0e7GDRbT9hKwt4toitW8/OuRnO44IwCj5IyMyMRRWQwDSNxrRPov
	 N2n28dWcCWG1CciJrF6jsigM6lKnC4WJao28pQYe6evG/VgfdR9OgZn751xt3udzLy
	 Y5nh1z4P/5FeVKZTJm1oZbGriADdKGTtwJE+kfpQ=
Date: Mon, 18 May 2026 14:33:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liuqiangneo@163.com
Cc: apopple@nvidia.com, jgg@ziepe.ca, leon@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qiang Liu <liuqiang@kylinos.cn>
Subject: Re: [PATCH v2] lib/test_hmm: Check alloc_page_vma() return value
Message-Id: <20260518143314.dfd290f5a2b553a8e11cb2a5@linux-foundation.org>
In-Reply-To: <20260518031903.63455-1-liuqiangneo@163.com>
References: <20260518031903.63455-1-liuqiangneo@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC20E2000F
X-Stat-Signature: 3a3hn1ye776it4yysnyedhzmx6wps3cf
X-Rspam-User: 
X-HE-Tag: 1779139996-87161
X-HE-Meta: U2FsdGVkX19xCp9S449Fy3gpsdSBV4Hul2O2E/xdY2m3IznGWs8bIAb2siIJIT5pF4KA6dYZVTaQ8Dk8qmFqVfr+OVP0X2N9CtdaSjjlTT7s37DhqAfFXa+rBqADvUBZ7aexx1rKo56yeM8LAZoF/jXWuOsaBh6bfk7E8L5FJiZXPyT6Y3jAvah5i/f2EPmFAjKiEgN76uLkIq2VhFcQtct7H464Qyx0xTEx2ghUVXyze7yn6Fn6srThNplpTjkNj0lY3PphKOVg1xKQN0RYUIh0TSqEigNPIt5khZ5Wk+FwLnIngBb37ge9AF2QQQ1NHWJdv41TS4XDT7yKSJ9HrRlMMnVLuF9QF7KM/lhSRhQFP9Ppi2BXllgsA+Lnr26tyCpC0srEpGK5ip1IlETmdbtCNtYY9+/evsfnJacNXjkU0c4s/sNeke+uv5cGLrczoxL2kOntKNV6up6gI52mCfIIbRGQf2/g8DG+AlvVsy7aHcr5yQgCuAW9HmRnML0cSJD4WCSrHH2NisV5vQRPuWvFRWYCPpDbTdUznK6BAiAb8LTDTNpj5vS066ESOshgCZxlZMc3FAZmLk/hx87VNCN0xWZLg1KVZRbMYxptiLD/vQLftJUcIbXyrbI2jr6fqBxB1/1wqN6VAH3mY/ycq/5n2Apu5Y10AqvWNMvKxi1IpPhNP2jFc9QKGCztrxl2ktMxi4WC7lPWX06swj8YfQesph25qItNIDlWwpRsfbOdJGDokQLLhAaJuNwQn55GMi1y25K5zi6OchwjbmGO7IN1bJ9vz4zdaV95S8SPAE6YqZAlGyqEpwiZX6bNRmPba0fe8Q90KtKut9vyTMFCl4V6Q3D+M5WkHBCMAUapIjkxY9jGrYl3TN+hEkMaaqFpe+rIodS/ay5v11l/RzjJs5Ir5Dne8A34+aKz8sqKhdODtQzQ3pfTh0biQBervzI7aGiFoGW7UYiWQq0tvkM
 qju9q528
 WljvlDtBYKiLb1J0DI2c9zRHCjFJzLvbIFjsn5/KcywwQjOyRP1NMfjHF8aNpf91sOYNs8Z2g+atGybAit2GFWbeigGlJfxEUKXsaNgni2pMSPJTtiwqjN1aKqqEypRcBYmeJWqkR43xU9pnioY81un/fOZA5ll2sAwGg17z8/l+YBVH5IavXWUNZuBXk1gbmnwUAAkMGuGNE0f338HdMJfaWh8ectueFrBxemvB67IgdD/2LE8YGmN4wSFtcP2nArNgPMuU94dEDZfKCouQUciPP697/pkRF6zUUx4BlSccJyIjWgtBnEtDX+ZwfyzfxkvG0aRqyxP03iMWZdPX1223CWG05UcUABpnPIGY5+56ZF787b/UO50Yedo1+pQhW/8b7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 11:19:03 +0800 liuqiangneo@163.com wrote:

> Return VM_FAULT_OOM if page allocation fails, which
> avoids a NULL pointer dereference when calling lock_page().

Patch looks good to me, but AI review is saying that two of
the calling functions are junk, and should be taught to handle
callee errors:
	https://sashiko.dev/#/patchset/20260518031903.63455-1-liuqiangneo@163.com

