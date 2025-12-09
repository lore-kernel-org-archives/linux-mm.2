Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96206D3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FC56B0005; Mon,  8 Dec 2025 20:47:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1166B0007; Mon,  8 Dec 2025 20:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5806B0008; Mon,  8 Dec 2025 20:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC54B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:47:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5810F899FA
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:47:39 +0000 (UTC)
X-FDA: 84198245838.26.F60AF18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B742680002
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:47:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d+DcxBjg;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765244857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjhjVV39WMHuZ5/VFyDlS0BZ172MSmO7iFwB6K30eA8=;
	b=15NQi413RaQ6WXBAzXK1e9qtzAob0pumO7SkYXbBBz2f6zY3EW4/6gHGCyz+tO0BqfS3DH
	5KPcyZLxqC/sV4OkBJq277/zO1RxE9ZMJz+/1sg/TWCxnLJO3YH2TjBAUMUNaX7AmXgTdn
	hhQHUFMtG9aSLc8sepcqRqxHh4IJX+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765244857; a=rsa-sha256;
	cv=none;
	b=k0aVZZu+7Omu1D0syXWoHOVZ0PvcoMo3O0Z2MWIcgkBCpQTyF5wdweR2oTHoFBdGa/aSCB
	0WsOt8oZwH6TSaerkp9H/Hw+ekualQ7M8QcG4kkZxQsc1CFlLtlFL/yyppuhsTT/Ypqe+E
	xUm9Leli/BmT/WygfKwCi3zjhFBZMzg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d+DcxBjg;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2A296016F;
	Tue,  9 Dec 2025 01:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B769C4CEF1;
	Tue,  9 Dec 2025 01:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765244856;
	bh=4cKepWPJcFwPX4THOx/vqYkh+UCHtZ7kDQ2aqoDPkm4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=d+DcxBjg5jtSOTqE0qSB+K/QhwVBgzF+xRAiQmVy2Jcv25IRmejK0ZvuvXCb4MVYZ
	 rltceVBT3mjL/bFp1ljSmf6rATb1gn7Z4jNELn9jVdWxCGqzNVWCZcqI648xY0ZU4N
	 34mK/77uPBCNxsxVKSQe3j6hNKkJxULaiKOG+DxU=
Date: Mon, 8 Dec 2025 17:47:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ahelenia =?UTF-8?B?WmllbWlhxYRza2E=?=
 <nabijaczleweli@nabijaczleweli.xyz>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Christian Brauner
 <brauner@kernel.org>
Subject: Re: [PATCH v2] tmpfs: enforce the immutable flag on open files
Message-Id: <20251208174735.35aef48b1a15a2d08e073bd0@linux-foundation.org>
In-Reply-To: <toyfbuhwbqa4zfgnojghr4v7k2ra6uh3g3sikbuwata3iozi3m@tarta.nabijaczleweli.xyz>
References: <toyfbuhwbqa4zfgnojghr4v7k2ra6uh3g3sikbuwata3iozi3m@tarta.nabijaczleweli.xyz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B742680002
X-Stat-Signature: 5q4gocoszhj78ugyrogzh4x5b49kq8g8
X-Rspam-User: 
X-HE-Tag: 1765244857-623491
X-HE-Meta: U2FsdGVkX1/pnvkfPcv8lJXVq05TOmE+GC58+junlZhfsUV46HQ/yU5egTJ+4IQ7pHSa7w3L0wAmU4xOKaDy3GRfu6+blekqxfCSMIF1HYSNRu1Qpc5zgtd7NynsT+QUEo+HE1O5lD9UkxDpewJTlmoxEMJ0rsaJUZbUCh3pTkoUgWnzqsJt9qsTtHZpEG5/6MRgEmV8kskQaorkax0N2DB6tYiTj7z7QhcexeYNv4WezRos5pyuLOGfkZdXhPXIlhNL5H/YktfgEnrBhjj1d2YbNyLocZqvUwiAdh2R9duj3GYMV1PgAOWviozpCmf8ENkMX3CGSDeLh7MZz4sJmv2l67xNQw/5FPhnUCrD0Ai/FJlCUL3gs6Chg5vieXc3ChgKHJ9lCXA/7au+ejwV3OS8eui2O7asr36dyfpzJkkdMafmRnP55r189wezV8F4Y3uM143lB97ALeTOV+F6sL/2dPgx6dLYe/vDVxHayXGVifQXKJAdIUVyXphRBaTg6p4Gh+CAx9Ep6n4kz5atzspvvBAqElWamZrPUlV1W1MZ/oSXARQwLdRven20KYGc0/3G2bPJj4vrIgl7/IAZ9pVjrCZZKfxsB/k9zT7zeQ0QjH5am9LsSeQvMpAyWuNn1nfRbyP4JT2h2hqwcS/Vf5i6r0ZE/pEvf1NFFZ2b9q4F+YRVoH1deuWqYHOVdnoZxtBFoQsslYqeFDsry8K7+YHBxmI1/kh0JgyO/KLzoyVoJi7QJav0Jdh46Dt22I6F69SmyGunOADz2a2zP2Ljhx8cFLtAz5viqSbbJIf377tN5H6frWCZ+gmrnQsd4abWipFYbxItwZuIhlrs0dbxcnQNvMBEgF/Dgr2ei+xwjICTmgLCNaM3k6YFX9qt3JRxYPDRV4kJpH2c8MgUrYoh99K3V9+FknaNSoVXVKmyizSmg2qH+w4cGn07FyyeAtMUuCAWhpesIK1k3mo0nrU
 dEecU/0+
 rkL1RZPxCit+4LiT+ToNFPJv2C3Op1LxI7nUEYWszN/M7MQHPKCXAsLLtCuzLYn6HVWEoeFDIR0sEvgPLWOiSLmOj98mTDpgFFf4W7aubmgD5X5lvzUdiyLa9ViMFOOWeyDsAl5iMtJsz0sIhqLz+ZV7s1+4e4HcVnmLvUCj+fjHQLKrubnmmbRSABrhc8fcs5vFg8rtck9myD+pj8bYq1fiiScv4SHL5L0Y9IOWVuyGao19bgWH3nj1PJs0N6+VvBVGf651MW/nw+Bvb02VqVe0YNSYtmXbBj+dFb4VrUm79VcFqBxRhdN8Pm4bAy+J15EnHPHX0pdEwFE47ws6Ue2CQjzT+HvILK+jhaXV2oc9YBggh6fR7/LnaTzcle2NXf3bg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 22:50:15 +0100 Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz> wrote:

> This useful behaviour is implemented for most filesystems,
> and wants to be implemented for every filesystem, quoth ref:
>   There is general agreement that we should standardize all file systems
>   to prevent modifications even for files that were opened at the time
>   the immutable flag is set.  Eventually, a change to enforce this at
>   the VFS layer should be landing in mainline.

This changes the VFS parts of tmpfs, not the MM parts.  So please
resend and also cc

linux-fsdevel@vger.kernel.org
Christian Brauner <brauner@kernel.org>

