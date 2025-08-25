Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C5F1CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693978E004F; Mon, 25 Aug 2025 12:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644278E0038; Mon, 25 Aug 2025 12:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B2F8E004F; Mon, 25 Aug 2025 12:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 335828E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:19:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9E261A04B4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:19:16 +0000 (UTC)
X-FDA: 83815789512.17.BED7085
Received: from mout.web.de (mout.web.de [212.227.17.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id CDDBA160007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:19:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=VP9FrBJH;
	spf=pass (imf08.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.12 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756138755; a=rsa-sha256;
	cv=none;
	b=TOFbpbwKPQeD0NOmf35WFjuecW/LrVb3s7DrCc4AzZHEUwIHSN9oXZcUZGLDMYorTqi07F
	gr+/iHIowLaqFUNlHBkkSGqAKAgNor+8mIoVHFZcP9XQjX/hDknSBkqVyUkDjkxq4H+Q88
	qb9AREm4SZcHJ698HYdD1XROhK/e/PI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=VP9FrBJH;
	spf=pass (imf08.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.12 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756138755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y75WJecyZH/ILGMGG6dZA4C5UCx0iBq32CFgVYY7k4g=;
	b=T0zeE731RHP1uZzV4vueBeCFYEuPxe7XTaR8Bg2JSAxX5t9RINh9AlQ7vQRihnR/rPsYaV
	cWV93aftCKyaowMKvuxATBXzWDuaKyYROZpko4uPxACRFGXC1d1hCTmeX0SXLVezIOxZzn
	tuARKNshvKsLNzTzXpECLiyBSwSajks=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1756138733; x=1756743533; i=markus.elfring@web.de;
	bh=y75WJecyZH/ILGMGG6dZA4C5UCx0iBq32CFgVYY7k4g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VP9FrBJHq9byB9hm14eI9TV4s7ciwevgz3c64sdDd/h83Ojw1d93rz6qNCyKUAMD
	 1gSWPnII4k3woBZsI9+FNYubEuDD+htLk9lWUpx9UauH69r2PM+LRwvGMzN/yVWS1
	 z80XP2lZ9SAcom7UQimZi+SpDLh3i4/TDbJxB/JTbE1Y/PuCLINVXWusECY75w57F
	 lW8DE9dZMN0Drx5Fnd29kJ0xdlIn3qzZ77sdzNQ9TZlr4hgmB1REZ9GRtKu0ltjIX
	 Kq1NBqzCWCAA1rXwFrIkdjY/Ux8h2R1ZahyDJyaQGvptW799ACJIF3CHvYGMjYsbQ
	 HBFX8P6BO6tHinfJUg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.250]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MY5fb-1v0rQ02NkD-00IVrz; Mon, 25
 Aug 2025 18:18:53 +0200
Message-ID: <ab8d12b7-7013-48d8-8fd4-fdafd514f4a9@web.de>
Date: Mon, 25 Aug 2025 18:18:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Xichao Zhao <zhao.xichao@vivo.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
References: <20250825073609.219855-1-zhao.xichao@vivo.com>
Subject: Re: [PATCH] exec: Fix incorrect type for ret
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250825073609.219855-1-zhao.xichao@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HM/bOy/cIhgXchmbTixKhanMhi+hSbgQqT2u/TV4uXh0/Xhx6cg
 4Kw5WMvHPUT/x3XADeJbeC4JZYhtehocVIxjmAGT8S7N1i5LO2zgb9OIJBHsPKpFU/s4MfA
 4ccUmM3OXDvJ8NlkAP1BJEQSeloXDpwmpW2z1QDWI7yTgtVCKueHDUhTEaRPDgA/8DdjDSB
 KgrOrSKsRranxLQjo6flA==
UI-OutboundReport: notjunk:1;M01:P0:4loINY1IS1g=;fdM/XQgCup8b1m32OwKp2jwDS1l
 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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDDBA160007
X-Stat-Signature: 6p7ozkzskzbdco5rabmq4i86q79zm7c5
X-Rspam-User: 
X-HE-Tag: 1756138754-7318
X-HE-Meta: U2FsdGVkX19QVhg+LT8FjL8rcrI82C6zl9alKmVzCe/Qoa7+sp92HzFheZPmdswfa6W9fnxPhe216ckxs2b4rMawqWJjp3/AB7Egvpxj6WhpzCratSSe//4QJou1xWgHs10G8jK0jDK1si0wUufz4N+VRnfZFuZd6d+qmHQ2PkHuHMGZhKKqD2bPc03+vEcSKKJV8I+R4rI3MDTon29jLNqtTvdguK1+otD475A5fgCKcNl0Yb4TtHH67O7d7Z3OR3lYSTKd53HdmlAXnus/dyBsGANjs7tbaioTwbbtAmpEwp178YHyVzGXwPqgRgRwp10UtFRDqsK+igCTsg36W8qi55lGyEr6jTVeYd0s1nK0PbTdfyRgMWc1xsAmzUd/Mg3Qv/1KbUlZLqoajYglTTS9kVZoiLOQNpNY3AtnSWW3XSJs6RU4OjC3UwroeZVPrCzy7PcLYJoOTimnu4PN2FdK/BjPVUyaawOrOVfu8BDsr/qVjlp5T/yQz2l/8YINwo4AKsGWLZd/M78RTj0xfeM97wxRJPs2LiEt/h3wVrJUebcMWWwQAA5fBvZOSJktaVDPK/vi/lXXReM4Uy5tp6J8EsucUhU3AYNKJOIKx5LdG22nduquuxHvcZlmnl0Y+GdOBCzU4dWO8CjuzS5MW4YzUBZlSfhqFxJyxxlIxjOUPAWjEjZ7rRLMwZzhOtYgIPWa/5dDdjjiFt+s7C3VecCuyJlMllmnSWRs9M2Cy7SWEIukt2VGTYbnGlRNlt2YPblM8MIMCHhgOc6gR8mBowxYuazho6PUB0GG/jhcBg91IRVBFohtXBhWd9NyaVhEv7leI2xmcpvVHCIJRIwV/eppSl8VIjNjLnm2ktUn0IZiXYx9yIGC+Fz3f1Ig+jHbTFuk3SZBpnRzl3URrVSqG6W2EA3uol+bKNa2lLr07beoPSGkqdV0rM79D1gjrQrKIwIcx4hNfDdATYdMnz8
 zVUk1KVn
 fis3ffN03ugwxR5yVFn+0GoQ+8P1RVMWnuDx+Rc1JF3BRL9IzDSLIFUzw2QAZjBTSvfGt05t4Spbl7MkSgiuzy8PJ3P3z1UTzCUA9ssXJXVrac32RljoBi4n4uJUmPvAl7MNR1RwBdnfxL34gAEs2AQP6SZhWq8qg6GcFy1l9bLbtUWriuJuzv5s4J6EYwH/W9TjDuunhuBFNNBFZF9HSsO+FpZv5Rvr19ZB/5Ljy62A2kgCeT1DgDhZF+U/gaQiI8611TL3KnZJP9zA38JHRa9AvO0jpUvq/vNeuCNDomNy+9kd183SycQDv+I3LDoyCf81wzygl1pNrcepMLexsSEsadxCbNt9jXmpUmCmmiw6FdBdVHekjoEH/uQd0P90g2GLf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> The ret might take a negative value. Therefore, its type should
> be changed to int.

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.17-rc3#n94

Regards,
Markus

