Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4743C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCDED6B00B4; Fri, 17 Jul 2026 12:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E8C6B00B5; Fri, 17 Jul 2026 12:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBAB6B00B6; Fri, 17 Jul 2026 12:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83AC56B00B4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:52:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96A961C0063
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:23:54 +0000 (UTC)
X-FDA: 84998487588.07.C5A9EBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E6DB41C0004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:23:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gMS4b0B6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcdtPjM1bbPwPM506mATotSv4YstCKTDfUkEdecfsbI=;
	b=SVbWJkZNWBSbySS48DIZCjeygn2jCw/qtsXJsVdi8OoLtTpagLheAoa8x5vpNDcmo9CSCo
	77jbaTb3Z91E3jqB9jxDhwKcCRCU8xDdHIDoODMNvyvehNWc6jGFUm7Xcr0EFX7+Zvlh15
	lHYSDRYCvJozPPJesLVnQDJ4EYAAdSM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gMS4b0B6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298233;
	b=hWwzo6ysUzc+Nl/8L6hXJy3W/Q7idcr/CWmbq4xWVX4S9d9DBTgnXMfZfrgpTJ+gkiQpW8
	v1PR9xikKthCE4oV8mGN5utnJ68GgnJlwvEtkkaXyW2cmX2FXgqVmdjPy83UpmCx2VNo+Q
	Jwm/vSQHwfYNeOa9/aVFJxmmfVP8Yqs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D10A940598;
	Fri, 17 Jul 2026 14:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1011F000E9;
	Fri, 17 Jul 2026 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298231;
	bh=xcdtPjM1bbPwPM506mATotSv4YstCKTDfUkEdecfsbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMS4b0B6qIQdlCdkrH81R10Sr9oN6Zo/1NYWWGrB75fggNBQRGXQnu08IWmsYgJOW
	 JcjMRJMfmbS902Jysdfd/4QbY4Zbfp9Bvk4lwMgXODxokJwPjdHFIMqOZhwTbD0QAd
	 PHVj9Vba+dzTHV4jWEVFpOK/ULCrKmpre7tK+oN3n96fdSnonv+Yyqqq8a0CCyb4G7
	 3tGY0ezK1fMb2Cb0XUrZXio5F0KLuDokd0qAideQhEqgVlhc26WPncLqqo3ZrQK7s6
	 e9LDBBufypTdKj71hUxYqOViK2XQriR0zD7pKELMujHgehhjXwRMVvh45N42DX0c6R
	 fpUTmqsqaW1QA==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] samples/damon/prcl: add module parameter description for target_pid
Date: Fri, 17 Jul 2026 07:23:47 -0700
Message-ID: <20260717142348.27427-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <875x2ej95p.fsf@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E6DB41C0004
X-Stat-Signature: 7gnisq6n5u3sot8tehgqy5ymbpt43mec
X-Rspam-User: 
X-HE-Tag: 1784298232-6699
X-HE-Meta: U2FsdGVkX18ukq0oyfDiOEncIpU2dYrrZhDnHa6VLWOuTZLao+jetdUHs/a/4HRvk4Ae2yuwLDCkJyO6q8B+XmTN5ChRMsKKQZG+1qBvqoKZxzkqP3Vfdj8tiGWN/yeZAUdnrXafic/5ubw5zK9LktwtuyShhX/CQba0TZfeD5dwYt3Wx9S+iteJ2WaRJFPxsQHii2tF5bjWx69SIZT/gzgiuthl0onFHUJHMiw1UhLDbChtzZNFQcjgMM21ODiPZgWShxNBTDI5HSwbEbF0fapLId+W9dYZgOCx1ytpKc26QOTjM++eTVkhpg/14+RNvHE0SVTxE6Kp8k4Vig4ko67xaf9rPFdJq6FnEMBBjnw16hC018SUA86AV6W+vuKqZcvCjscFFSGoZcxj45HcwAJcJF+FtNNrOyIjsoluHDrnvNVsQeOk0+sewGjZZflNN0ufoyuLqclTHfwUdj3a+s3SCMHjF6oW30bRhsESAv6XqsFJMvONabxaZ25dGZ0ZAM1Fm77eRLRQ/wOw1SMAMaD4Z+cQC9ui9+bx1/sxcWMWF2rNFsEdcBNo+NUA64cskTCeWDAyGK6GKizI6dvAf7UNZ90vTSJhmmTj1jNr7u2ohKuHZ8S99BNv0alVz4RzPpFNabO/e1moLwa5UdBWOtWrNm29uc0U2Z9J3GaRMX1fr1RAMpMJkcAHaGqq9xq/cGp/0C5M06Vdk5uf73oJxN57I3sNf4hefhcB66XKZZKVXUJUplMP8Q320rs2fZBi+IrEcccCnPY0FDJnGsjcxrwoJ6Iik645vzcfPBF+XFHAI9ab4qg7bs1UkTWjOlIkTGfYqPfRMDjEDo/Hfadh8Naxv0nQ8rQlChcuf/5RUHBul4p2U/ZCqM5z1NFMctwIiYyO/l4oF/uCQOEHqy4vJwThkQGWlxYP6poALl5Hl4IdSTv7gRdulM3e/JzbqIZtvUambqJhSV7ltCvAgW7
 VZu+737v
 wFITS6nKTa/JBzaEbkTr+t+An2AqyJcEgqhv2YaZBlWRh7XpZe8ynyN8crnfNIwGWQgbNi4WLRZPFSKcNwUbqnbZcPr6KNHXqkqXVMt/jAgA4apdmpRkJlKc1DpQcazFL3ltEo3eTae4oblaFcfpOL7Vxm3dueXOwj0NnJX2JOPvIAGuPPoPvT+soBD3e2y8E5BUCH/yS9RHn64SO4dB60kxDRegkuNsjUCpc94UgTIp0QKq40EfY4MLNUkn2bu9J7uSHG71pFKjkUtTJzlLTLPHmu887zPTNVWCC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 16:46:26 +0800 Enze Li <lienze@kylinos.cn> wrote:

> 
> Hi SJ,
> 
> Thank you for your review.
> 
> On Thu, Jul 16 2026 at 06:54:37 AM -0700, SJ Park wrote:
> > Hello Enze,
> >
> >
> > Thank you for this patch!
> >
> > On Thu, 16 Jul 2026 17:14:44 +0800 Enze Li <lienze@kylinos.cn> wrote:
> >
> >> Document 'target_pid' via MODULE_PARM_DESC so its meaning is visible
> >> through kernel command line usage and sysfs interface.
> >
> > But...  It is a static module.  Is there a way to read this documentation from
> > the user space?  If there is no such a way, I don't really think this change is
> > needed.  If we want to document this, we could use comments.
> 
> AFAIK, MODULE_PARM_DESC() is for loadable modules.  For builtins, it’s
> effectively just a comment.

Thank you for clarifying, Enze.

> That said, if DAMON gains loadable module
> support later, having these descriptors in place means we won’t need to
> touch the code. WDYT？

I think it is not too late to add MODULE_PARM_DESC() when we add loadable
modules support.  As of now, no clear needs for loadable module support have
reported, though.


Thank,
SJ

[...]

