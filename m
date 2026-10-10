Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B7CCA9ECA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 23:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1926B0088; Sat, 10 Oct 2026 19:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98816B008A; Sat, 10 Oct 2026 19:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5EB6B008C; Sat, 10 Oct 2026 19:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8E666B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:50:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0061580683
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:50:04 +0000 (UTC)
X-FDA: 85308362370.18.2B0B219
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf24.hostedemail.com (Postfix) with ESMTP id 215CC180008
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:50:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791676203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FL9cUDrGCp+qMK51gHAgC2YfEkxaRRY5xGgvKcAOg8=;
	b=yST1mbCIM2FErFl7o9/UO0RwDguUFUm5MjVZAIINL1II2221kwSndi5u0NoUQ3tvQNvMTr
	fShMr/n3dP27UEvgUZjnSjolKmVIOjIGLIufZjYQBhzS7NkMDSemaOYSuNxNKISm63zvfK
	FDM8PuGX23qXK+RWt1dU7alxlR36K0M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791676203;
	b=JIvH7Ir4HiMnRC9c5P88x2BMNZHi9C93wDRuTMIo2ILoVZgyTn4SNVZ+xoSUYSjXgu86ts
	Lby5wuEyKQbzEBn7JUEx0arTp/5n5j1JIlIztGQwMtBaNbkwEntQSlKpst1fQPa1IqEuDc
	fdBHW7tHxhfD1JFWLMKjLHpdO72nPW4=
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28FEC405D0;
	Sat, 10 Oct 2026 23:50:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 72D0E2E;
	Sat, 10 Oct 2026 23:49:57 +0000 (UTC)
Date: Sat, 10 Oct 2026 19:49:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah
 Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, David Laight
 <david.laight.linux@gmail.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, akpm@linux-foundation.org, Yafang Shao
 <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
 Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/6] treewide: Replace memcpy(..., current->comm)
 with copy_task_comm()
Message-ID: <20261010194956.6933a224@226.227.38.69.naturalwireless.com>
In-Reply-To: <20260911-tonyk-long_name-v7-2-34e1ee1564ae@igalia.com>
References: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
	<20260911-tonyk-long_name-v7-2-34e1ee1564ae@igalia.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18aOPZdFzzPMcDV2LVtTbVyS5dgw9MYz/Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=9FL9cUDrGCp+qMK51gHAgC2YfEkxaRRY5xGgvKcAOg8=; b=fl3Kqq1YKaNwUAT2ewO8D37Si2di3QECApP5IKx/xRtmhETBuCicqagOGEnk+MxahX4DFkIqvyz8yqB67h0zwH4P22/9Vi1IuZcDU/dtRio5piddu4fOn5o03+m43fJKGd81NA1c5LhgtCasezWRD/U9fEFzq3MK/tDnWg/sTYo=
X-HE-Meta: U2FsdGVkX1+wsc8QC0fHf+UbyellR29lm+C/KUyXjDtET6zrwfqebiXgzyo/sWYepWg2KpG+BTsYJk02OhpsGn4BTl4DliD/wdCa9XSreOsKru+DcKWBaONbFqgieOYFdI2oT39c+PV9V41OCZ/dMEoU08PGbiPorkytl1K8CGxM1DYQsC254CddrjZqAEwbiZzlervoin6exIeoOFRpo/hjcurftnLW9pfWsTI40jjI5+b+rzPHeWovsyysHMHa5zPKRZQAUyf+0pFS3nBhrCccXGlj6WeqArb54058yQTNmxkTKPUBxJxgxh/w8GhJ0hMSiIy6Q56ViV1LF2wOONf7t92dbrtZu19QjOQL9/72CCQdRf+ZPmF8IWOTxbXB3vjho2ch9QBw/LxRUSzlQsRSMXqVg74rXjY7ue0LozwwmaBRBdUNkAsJSYFW/t8HUlXpzdV1m6S84TsuiicAPw==
X-HE-Tag-Orig: 1791676197-585340
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 215CC180008
X-Stat-Signature: us5mpmssduqj1be3mbmjhfoyx6euk8qh
X-Rspam-User: 
X-HE-Tag: 1791676202-576624
X-HE-Meta: U2FsdGVkX185RbG73h2f/maBXpR4l9WpEsvPR0HTdEmGra4thT8Z8PlMBJB8uS9fQBeSBNMjIf54fg8munlnDCUDVr1JYlBp4yY5Mx2dY0OaiHRXaLpJNlScdD/XlZlPjVPBwTwluN+ZG+Hl/zctt71bXp/2crN4syoutOA1GSYEnzr8Fa/6mpmMthk28b5VMBIT2HVy8EN8G6WYgFT/vUsl/XOeEtaB3C5ZULD1Za9QPc8oA930sxMjnXbwOhbxLJEovl5PJe1uCRPBiV5MuuWfkTWOkyQw4S2ZbFfpgxggBOo8NcPyoYZDFHtaE0QGvEgaQIi5QKw2+0rR7jOqhXjWTeqFIH4Ke59GYv86P8J+StX3+vLMK/O+6vHHFcm5MD8Hvep39ldNf5sbLVqh74wr0/19HTxJDwc3RDvEmi1jeICvOUHlF7kb5M5EAn0n1JBi/x9Ie/sbJVTNe8sVXfkJehWPzzDgjvvbZdAt+6vQfzpejvqdvXYRei2cue5EsBilbv4c6XrtMB8XgNXRdpRDniDOTDmy3nsEcIjbz7b6XPdz0EPzKQPgEJstYQ2xTWkg6ALlwHaEXDGk+peONn/DbYeJgn7eOzNRM3Czz7qat4XRcgLxlp7m14YErc5b7UiYv3z4exBxnATtasOAvN4R6Y86rPND96T6RidMKEEqKoGaNRgioqVgf1j1lnf2e7OlAkkn9v925Mq8BkM3IGU3gp6dOff2VBtBt6KWjFK3w2uaIpIGsg3wcBePo8JI/efWXupecawDLagV4lsd0z2EuGezZIoyjLhrvPKoTILblPmudEErDFGCah9IWqLWqtFaO8TQGr2KXWeTOWOUe5Fuq5rmm449Fvf7alfImyEHlw/2kKX40X8JLTtcQZKzAENsMdHYJ9vMh1uSvhuMo2rC20q5LFXzxYhY83LYcBbn+pSUsipraZCznUwA2pPmZjMWTeht9xluK4WBMWd
 7h7tXLwz
 9uKMs/WZ5S3iCS+XTT8MJA/zfknX6AUXL0El+u8g3k+I75vept5q2dVGB4wWIqbBk4XvQVai+lKX5pB/NAwa0E7Hbzx6lsCyT3zXxIfQk6VTHq6uDuopS6oX9l04XYOiALsYwXmMnMZGe403oK9uDZ7W8Eg2JV2GklEGJs91XmzPUE3tANs0O1HKpQwda+D7nTkSjx+W6jS0G2KieLkHsKd0SLNMzkeMbc2184aDpxLes95UPfow3D8fLT993EIVkRLrQIoKja03FCvy0O6EBq+HtPRX30g9wv0plGhLJQquTm/QTIVDuukh/aeAmkZesF0PEDsTLUxlAgOLM4w845ZWiYSYlkB4W6Toj1+aCY4xy/Kk8/IBTLrf/qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 22:23:59 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> In order to increase the size of current->comm[] and to avoid breaking any
> existing code, replace memcpy() with copy_task_comm(). This new function
> makes sure that the copy is NUL terminated. This is crucial given that the
> source buffer might be larger than the destination buffer and could
> truncate the NUL character out of it.
>=20
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

