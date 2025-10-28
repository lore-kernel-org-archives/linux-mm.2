Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD66CCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36E38800F9; Mon, 27 Oct 2025 21:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DED800E4; Mon, 27 Oct 2025 21:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23421800F9; Mon, 27 Oct 2025 21:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 116EF800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:31:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF96DC0300
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:31:32 +0000 (UTC)
X-FDA: 84045795624.15.45C757D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11CAAC0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:31:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bYrDOiVt;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761615091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wyoIZYTrVDDO7g+99sSfbwUrHDKLElCNrsKfYNRevE=;
	b=cA8UPQsYPZKDjKOL4+kvrHUlQuUDapCLc5bfNe5dHdvZqK1pR6TBNeGRl+UB3OpKRtNRlA
	Nm4b12tFifqSn4rMny9zEtChWHReNdTBT11uyyEemfUOsN6wkSieSqV0sAyKv1ufLMfYAH
	jjJLQlfBp/hHU9LnKm4rjg9PDZr42U4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bYrDOiVt;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761615091; a=rsa-sha256;
	cv=none;
	b=MiLwJsacoHuOkz+fPwlne64uytSICt4Lej21ygfXf4bNz1uiwVpIWHg6odCX/qAaVt5F9M
	u2lPqLdBVgEzp976sIjvxMJd0vuI1pSlgSp6GV6EXClayaOkxxvc5MH+wuJ5IEWE9wrBlX
	FuKX47oL5Y8sAZkSC+A/shk+v+RAOno=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9wyoIZYTrVDDO7g+99sSfbwUrHDKLElCNrsKfYNRevE=; b=bYrDOiVtr9EnBCfWeyaRKsN0Rf
	zO8thzgRBHKXhYx/oORvEyK4vY6Lh/KF4IU6ZB+15g7s1PWyfACnJ8ZUB6uKhzi/ywkiIYACjMEUA
	fOg/T6QctXpDZBgXPrUjGIXpN74nbg7sXP6WMlKmHnvhs7IHmvDQ4fSsxsB2yNVu5WDBqRWQs/4mu
	VqLVY7LfZpSLOBTqqDWt3Dj48aR9TI4boH4iE7d+iH4XNY+K7frisMFDEpM2MGAIVw+TcCyv2B6mW
	kN/vCpaOPX8rpp+QhOzxzUmHJjhY2L3aZJAJ7ZO/UnNOyL+2oM21W4iRjm1spaIvxuG664KGPM+x2
	2gK54TvA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDY3h-00000001wen-1zTr;
	Tue, 28 Oct 2025 00:59:33 +0000
Date: Tue, 28 Oct 2025 00:59:33 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com, selinux@vger.kernel.org,
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 00/50] tree-in-dcache stuff
Message-ID: <20251028005933.GK2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
X-Rspam-User: 
X-Rspamd-Queue-Id: 11CAAC0006
X-Rspamd-Server: rspam03
X-Stat-Signature: qq5g5paciaf179d76exfbpd7qrw8xotr
X-HE-Tag: 1761615090-273908
X-HE-Meta: U2FsdGVkX1+Q15sMPwie/wO0kyw2E4v+BDip4rAwHyBlcWec3KvxHXASvJ1ZmCLdE/dmzdtWC7vwiAIqt/pAA4w6TWMSaS8qRxSAct5/T6L3ZG1s88buE9v449Wj87dsm/BFZcLq+ksFbnRrnCXnCgi9Yd+hAI7Gr7vqJVD+61UeyZBzZg2xCS5i/At7bJnF3Eyur/wxj/hP6/rzydnrtiLFDRe7ivc1axU5duwOF01o2clC/dwwxBzWTAGYO4wskmpVoUMntlFkEWxCvMt79cQAdI3gBM+HelbmmVhTAcI9E5VauzkmGOonJ/QlfCx+ZqO4Ex4TSOP55nKFn16PYwj3xtdAz3pOpR7b5SF2A0omKiUgEKc52gHFpNDjvx4doShdUPXS6zqVKYcPwvhQgyjdUr0U3gcisF22nhkGuNR/dgwaTIZveZBcg+cmTuOSugyPrsVpr4UC5mT5aO7ROyX6MqvhUQLmq1ogsrcUZxWkLnXmkyODCHhTOXPtcyoJBUDHui9WGUMpWO0/oAsb2D0dPXKYoW4IfxHGMstBHempWMT55TY+dMVqD/V01Ylz4xD+t1Op3J/LAYJSfPeniPCIUypJ56z8saRAO9cirw1Q8woWDEZ6WHvfQpKr5OuDfynCDsGBsn2LxhirtLdPnLd+iCKwufgMp26UFbJkHXES7svpplq+CED+2IhWVH2YZ1BneNO+iQp0LOO6LxjLjR/VNiaJg3CdrPMiRTyi3IDGjKfIlyQ9ryvuaix+UxN9ea+sMxNtjdWeEMykQwbX9QVT1YO3t5lKH9CLcHf//eGSco7AxBWRUcaAKDxtxpn+LOlJTSTh6BBrKMIcAM8pn0tSeGMSScFAG1ndhGp1Wa0f77qtgFYbjUQ0VKmi8YKGHXE50UpI628hIgXCqWyNpU+enIE4T2WsoTV2iqBgXe8nDRPGtvx2+zrWHXbOLDpkBQxQlJ3pA+/6d17SW/h
 4JAXw38i
 OeMX9sTU0uXqPEqUtLZ3FFaeFfn6ZTnnsrZ3HX+1Y/E455B9nr+dM+YJMstuq90vgQbSb44qoNWXEYJlWwb49xNpMERCjVrrCA9YdFDn9FNk1TAyt3GWKKtGATTD4COapSOSE29nP/763tKfPRhShsBC+u8Lpfrm7MJAZNo62NUH20jmwxK+GbwVGr9lnoz9+lZAddYgnftfL+cwziMoBWErAumWEblrcxoi+XfW3edlyF0X5UPvSgVlxhgh6G9Ti4EOunyuiY3h+r1GaU/77en9MJhpUBKFhhCs8qzkSRMbFhcZjhj3lPtIVqrAASa7C6OSB4XFa7NEfngZSMznuTBChQUE+N6Gojkc+HO/xhw9wwlOiSqZtgH/htkQi2O4vYwUbJ4Wxie2zpu477KEnldVSYut9r7Fhu9Cqhwnk2cRVMJxEMwcTP6c+gJdq0C92LRSF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 12:45:19AM +0000, Al Viro wrote:

> Compared to v[1/50] 

*blink*

That should've been "Compared to v1:"...

