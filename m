Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B58CC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4E86B0092; Wed, 16 Sep 2026 08:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D826B0093; Wed, 16 Sep 2026 08:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E606B0095; Wed, 16 Sep 2026 08:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A44D06B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:31:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7CCF1C2D15
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:31:07 +0000 (UTC)
X-FDA: 85219560174.21.94B93BE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id A968A100017
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:31:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZS4nFMqM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zk1+2yje;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oc51tp1u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mujbKWPw;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789561865;
	b=poL/GxvhL3GrghCnPd7eACbbYqDTj3kyBlCienbBdxUdXaReZolpzWrWlUHeWZZXT4jKFI
	P8Kex6NtXgxlgyq7ilL1dEPhB93fsfAQqFnGI2RQRhsZIcwiVKlD10B2c/WL39qQwCx070
	aTQAdWdg2eWrX17luHokfSsw7ByNMPY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZS4nFMqM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zk1+2yje;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oc51tp1u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mujbKWPw;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789561865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjfVBm7I91MT6pxmKQiEMS+G8Y7KPUVpFFxcVhkYXSc=;
	b=XkIc2pJiIP+dpaYeoAxO8dCjyaKv0AcTk5Qb8IT3H1RSUcYu/eaj/uV6Tw7yxz608K/kQR
	rkAusiqa5o59es2qxjH0jJS5WzGwpAQuxm4VRTyYGVkC2OqzUVEtkoVy2JzPWtCAFTsEGW
	fuPU57M7yRcJHRg6MH8LSUmVVYfOhUM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4FE9E21B4A;
	Wed, 16 Sep 2026 12:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789561860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjfVBm7I91MT6pxmKQiEMS+G8Y7KPUVpFFxcVhkYXSc=;
	b=ZS4nFMqMdsXkhyrXhbDEHbA0IiPeTV8QJfflkgHGrJSWv2IUhOrDycp2BiSMAFx5WYtcYX
	y4se8cFnBicwA8QqTX8yiaqtalQ2VfoKIjpZFHyeNnZ5HoCPNsXTfyW3ww8wMoWYBN5lYA
	LnYx6FwSVXLeV/C7xKWL+6UZp2Ye74E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789561860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjfVBm7I91MT6pxmKQiEMS+G8Y7KPUVpFFxcVhkYXSc=;
	b=zk1+2yje99viimUYm7SXTPHKh59pP6PP4zdNCb1JnNGYAuMoD3PB0X1nDl2oZrmf/X62NX
	1ZIaLyQ2BLRHMQBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789561856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjfVBm7I91MT6pxmKQiEMS+G8Y7KPUVpFFxcVhkYXSc=;
	b=oc51tp1u9cFwguBSWS7XdcjbDAZaIMKQidiIWQM7A6VrchHf6nLOUg6xItb4WQ/Zx4uTI5
	TLk5OwzrddleJqH81akN1UP4puCP9CREM2AGylqA0Gz05vncm9kx/KbVay6cnnIj1ahCCy
	8nMKlPvRfJ2k+JCHVl4MbcOy+iAqj5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789561856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjfVBm7I91MT6pxmKQiEMS+G8Y7KPUVpFFxcVhkYXSc=;
	b=mujbKWPwBP7JH5GsyBKZLpcjRpFgqaVaSP4ct6B/XEqBAuTMzM3LJS6gUdOXn7Y3r+3V85
	pGtUp6hMifipi6Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81F1A136A5;
	Wed, 16 Sep 2026 12:30:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EsgJFP+LqmqhXwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 16 Sep 2026 12:30:55 +0000
Date: Wed, 16 Sep 2026 13:30:53 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-new v3] mm: mincore: use per-vma lock during page
 table walk
Message-ID: <aqqK378rhs5g7Wua@pedro-suse.tail5790ac.ts.net>
References: <20260916043153.2631696-1-wangkefeng.wang@huawei.com>
 <9da6298e-485a-41af-a42f-7dd05c571125@kernel.org>
 <1ddf7304-70d9-4e35-935a-9d622b022e4f@huawei.com>
 <aqp4Uvem1MWQOUZA@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqp4Uvem1MWQOUZA@gremlin>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A968A100017
X-Stat-Signature: k35851d3xe51p9m6rq6yhrf74kqyndrc
X-HE-Tag: 1789561865-53095
X-HE-Meta: U2FsdGVkX1/kbGJnCBAU4ZzEQhl7twoIo9tch469djJejC6mMNNPKBHVvSmelT074eWoArfTLI8+naP/zTO+9xYbGAl19+DTGiCGx6lU9YDsB3kXfWFcKaf72GkgmOrdTCHkJTR90Sgyl8eE3lLE/yCTxA9stjjgFUvnw1BBLxnMkFCVheX/YBaEDjtSUECS/1Pvl9LAvO5u5ySwo2qaSlJtkSLD9h1SXgYMuykufwuKJfxnIVLo3W70m+XsCEPXdPpCmy6ulN+/YW2NDm7wDtYHLglu/VCRXf5YQv7rTvdhE8rfKj21GES+CIjE6EGwNULGh/gwETy/R/6smjc800lCxXjKhE56ehOIcPrns3yufL81MzAp95G9DDyQ16DGmVql/uZGJSq/bWEyUbgUa33UfF4i9R+eFnmtYwpfI1CSb3xHl/bpumuM6Dx3ezn8jw4OxE18jOI4hYKvcSgUwtRGHxt4aFFrOkOVFLhCNkxs8tLujBR15SWq9fOkSNOH+4I4G57O/jM0Or37ss0Fhd/egRjBKrPIdyp3UVA40WdluLOczo/eC/t84eGnqOMoMo667PEwHEpA6dUxhf9gHpHgqCaK36CeDYUyuZIWLk6gmcHFhxRrQUCuQnpiMpOTfjgZh8TyZpKQKUV4IN1U9RKw1sfFrgbfxC1CS6sppeCC++USzv+uQ6wkxVdnG11m7JqusBxeUrPs6VaHU2Y76R4ppm9FuLSITMbMiPHRiqynRRByxP+IL1Y48HOuBImUcOhne9aEdgHTlRAeSg5IiHqxwezzSRePR907hCEpOYsx5IIJTuS23W/aJS8oA5DApJG98eRTt5cTD6y14mIc9CiRbibKOTMnp81wvU0lgnXT9dpQFNhFPHI4ojgco4Va/3llBUt02lZpj/4m0sGJnT8Fm//T9tUNRcpz0pjG7Ro9EcT/lXj+l6XM87fQTd+4ApxXb8Gkj9jDiAqtbpl
 EMji1vvH
 w90zNR5jMD9ovHsC62YiW2BR2SNR4dKldikISx/he1vMb4oE+nnaXCi72JyEE5PBC2UFIOBrLlY0J6JFPwCRaM9bdw/hJqyJ/vI91nq/qJDqVN2Jiy58YjTMnQUKLWMiLuByVwHQLzjKCPeBUXZ/srmFeLqJluSp0xZSVaHcecIdF2DJsY00otWRTp5/AHX+AHgNelJ42lIc1msgTaLOgqJr+YyLVsrWzqkdkOHuVwZb1a7fEkRhOeoMrEj0diIQlSUWv97hUCYvJHcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:19:50PM +0100, Lorenzo Stoakes (ARM) wrote:
> <snip> 
> It'd be pretty broken if the VMA lock provided less guarantees than the
> mmap read lock in VMA-specific operations.

Well, there is one big case where that doesn't happen: cross-VMA operations.
For which ATM there is no locking scheme for "lock two or more VMAs" so any
operation loses atomicity.

Which isn't a problem here, because mincore() seems to have been written in
a silly way.

-- 
Pedro

