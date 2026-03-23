Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990F9F4613D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5266B008C; Mon, 23 Mar 2026 11:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0762A6B0092; Mon, 23 Mar 2026 11:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE3D6B0093; Mon, 23 Mar 2026 11:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF7436B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:49:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 978121DB59
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:49:09 +0000 (UTC)
X-FDA: 84577761618.21.CA799A1
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf24.hostedemail.com (Postfix) with ESMTP id 67974180006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:49:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=h1ep4pQX;
	spf=pass (imf24.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=h1ep4pQX;
	spf=pass (imf24.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774280947; a=rsa-sha256;
	cv=pass;
	b=oNwXQO0eGexrFECGitAJpac66a3+oheaSeE/+XdkcCkIYt+tg9XJ5pskPV42TQLz5hLbuw
	mPnCIu3sxoFTQBIqohgLKzPthhK4LZmFaVqXQT94ZkfqaWd/cxUARvTv3HRftNm6QKpMWH
	akzCuTmyO4xGhbY0lDmw9fH1nFKKY5c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774280947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqFlklrlq8f8GMqCaRA6JQDMLtlxicYYgk8CIa7235M=;
	b=1n6MOnE9igE1jjzsagBqj9k4E9oALRpUdRM0zr883YWEjCnNcP6fR1R7mDDTN6JgfesM8N
	vdZoqUq074O1439pE5VUgqstqasBFMCNVq+SFi4G4scuAxstzjVSZnFav3JpmjCTca1yR8
	6/aUFY05yuCTYN3H52/iN16zVy5Z+9s=
ARC-Seal: i=1; a=rsa-sha256; t=1774280935; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=CbbjtYdP4E/xtQsdx3+okOUtXQbDc1SOiN2xE5WVEx3gtwbaHTWnmiUI+O+Bu0YGcE62s7SdpU31AwicDgN48WX2m/VJL4HNVJCzEzyS+mxo50jZFFf4CTWqpVivGNjggjiessfXPh8E8z9Frl3k50miXdngG5kC+3evfp+yn/Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774280935; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=wqFlklrlq8f8GMqCaRA6JQDMLtlxicYYgk8CIa7235M=; 
	b=Lr8dxg6nZ+YV+G76OS6FVPIFay0DIb7cR4jWx7rnCHdWTRsVnLRACWjziBMldZS9hLmDcsHzVBfZGUXlOEHaArtg0ZsZ/OHdN1dfc964cvIOTKXeW6UtcqBU3I827jgKmbiIllpIPQ3UTQLcuwecNlNEKNiLis01eyyiovJltOk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774280935;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=wqFlklrlq8f8GMqCaRA6JQDMLtlxicYYgk8CIa7235M=;
	b=h1ep4pQXMZO6jnepVRwIj5Sq2N/4vnOJYX3HjjR0lvSgWDXwhiY+ZFeK+S4tLFFD
	HKf32O7YMlbpCS+Flqlrzraez6QkbbpSJdbL+MbFy8dzhR93yHbHgQIm56slZABrghd
	kOVHal1wxL0CJscvM9ZNVZMDVXGBl6qO1BCgibEQ=
Received: by mx.zoho.eu with SMTPS id 1774280932246117.62916547273733;
	Mon, 23 Mar 2026 16:48:52 +0100 (CET)
Date: Mon, 23 Mar 2026 15:48:52 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>, Markus Elfring <Markus.Elfring@web.de>
CC: damon@lists.linux.dev, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5Bv3_1/3=5D_mm/damon/sysfs=3A_fix_param=5Fctx?=
 =?US-ASCII?Q?_leak_on_damon=5Fsysfs=5Fnew=5Ftest=5Fctx=28=29_failure?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260323152453.81603-1-sj@kernel.org>
References:  <20260323152453.81603-1-sj@kernel.org>
Message-ID: <96C00873-532D-4108-8FAC-80BAEB5D503F@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67974180006
X-Stat-Signature: ijap38jqnkoe156gn6ipainakhp6a8jo
X-Rspam-User: 
X-HE-Tag: 1774280947-579613
X-HE-Meta: U2FsdGVkX19ToLq5JmP89ssCMV/0stSUsJPiIQrQO6VTJd/s+dAs1ATuCFqRtDVnA0JAT//E6/ju6uoqtBLMi39NusPWbmIvF7bnsmXJr3yCZgw6qImMCy+ycok7HJcvWTfD0QznLBswv/eDSMbe3ONkoRv1Wb84q1dwwwZRcpzejNSbolUXyDQrtcjOkjdM+nQscVCd8jP7x8DPDJS1OdKA+PKGuEiA+miAO+dyTL1Aa4WAjP9y+OsK4f4OXr8WTxNXqS5iPVDssD1EFVdFTxfVoz6GSfPgavlw+ixlErbrLMF20dzZLdL5+PaWRiJMlr5CC94fsYZkN30zBCx8+RCQvPl3R+uRm10SbrX7YTLW2BW1bEnfaLDxx+ya58aHrRi+gqVnX5t0mFyc58v2myshsBGqJgzB8+FhMPHca6ehyQPOg6cFStgmZCrJTKbXVU/9ODaZ8c5jUF6QGq2ZPMcyEtiqK/y0Q92FMjPUNkngApKOAIDgXO0gFGTW7IU3RBdAlNlliSHZS9dvfr9u0B4SjZXU7Mzr1NpqJNUpCV83+JVf0UW4PdGM3Hv0wL7LXcriDEzq2Qu4dW+0NE6Og52uIuhLcFSTfPibsVHBksSIJf3vgCxJK120CfCQRPJvuEyZs0NfGRhaxZEG+Kz/XJj4Qi7jW8KcL1KAKqpPBVcWSg85sklqLKQ0KsiljbJn+QIuXzE6ghdAp9qp4U7yCQC/Vl0EH6iiBQrggPZTzcu/ypsCsk0/ufqhtpCZ0Qd8dq939o7Cy4yIFtEkV6n/B60J7KhLo7Qp73DuRINOpiUwLbbyIvfu8rAEqtLZIXtIfF9ywXeiUOESuKfqsxAyoO8QNeP4K0tAqx7dpK96JFpKDUbCrZsqEOugQTHvwQczVYX4qei4n5vZHkK7wnF9bHMw9uvEpvu404Q21wiZmqopJx+Ebcr42Y2bNNE1nVXEmDtITW3oe5b+eFoIEBL
 mV/M8Wqv
 HDB50DNaRHDXPuJAlaG0gNNd4zxC4VLp5m+2dzcY25EhyumSgh3RJnLtfHo0731NHYY/Itngar7iOpEWwzblCSR6MtVPyfruSZMQWMu6Dd2hZEHzFk0jnCD4h2pCMW9YPyeUATMnSvgEri6boNOG7+uymDoPxX1EZgTL0sBqCtru5c/zafT8G/9uf3DqfmnVe4I5oLOPjeyikA9KYe30fRJWbmX4TqCGsHR07yvo6KPfseRwfIuZ5/My56JTKWcTUTfjnDy7eC/G1qYgwT4x/D5GaNcdn3E18g2aU7wFvRg8Y+f6V6FryqDybBGqUzMZOQI6sGLUqW3dtBvwkzi/scDmV8yY105Bj6AvCTcP46bc3g+ia5UtBo0kWj6/wTHQGExmj1xiq6yUGF7N9ZUVALHXVv/oVxsvo8AsGJGocZnjlEx3nNdkNHQx0QElqmpDFXtcPI8cx1aq+7vdH3zgdmHdbWFTlRWTjFEguDhQyoGkuFuwdui5+JqGJut7miN7Ts1SaZyrPrO6TAxZ5xFvyfo3mxKypAmryeYMolzF0y6ne7oKmCwDjon4XsSIGhV3rkdLl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23 March 2026 15:24:52 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Mon, 23 Mar 2026 09:25:52 +0100 Markus Elfring <Markus=2EElfring@web=
=2Ede> wrote:
>
>> > Markus these patches are already merged
>
>It's still in mm-hotfixes-unstable=2E  We can still make changes if neede=
d=2E
>
>I understand what Markus is suggesting is adding another goto label to ma=
ke
>the flow cleaner=2E  Because this is a hotfix that aims to be also applie=
d to
>stable kernels, I think the change is better to be as simple as possible=
=2E
>Adding another goto label could make it better, but I'm concerned if it w=
ill
>make porting difficult=2E
>
>IMHO, it is better to do that as a followup cleanup, rather than make cha=
nge
>into the hotfix=2E  Let me know if this change is somewhat critical and I=
'm
>missing that=2E
>
>>=20
>> Are there still development interests for the application of a better g=
oto chain?
>
>Sure, if it makes it better, why not? :)
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Yeah, I understand where he's going with this, but I'll possibly make clea=
nup patches soon

V/R


Josh Law

