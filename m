Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9F4C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116F46B00AE; Fri, 28 Aug 2026 14:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7EE6B00AF; Fri, 28 Aug 2026 14:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1FB56B00B0; Fri, 28 Aug 2026 14:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB63E6B00AE
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:41:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BB9812052B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:41:33 +0000 (UTC)
X-FDA: 85151546466.16.C01B060
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E58F180008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:41:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bAYu4fB2;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZhNp9hZHYOOVceBfL/gOW5jcyTZH8S3/g7aNieeBbo=;
	b=yM4YMoK7rM4oYzumcxBSCniE89B6bFRkQkQQZmEwV/Mse1ES30xTobu/0iVxI6lpscUOjT
	VD2HF43eJ9w3HZeP+Opba8dLtMcc65KwWt7G3yZNGz7WPignBI9x83gWQO2e4UTj9QhFJS
	9z/8hmlZfL+Ya9qO0S2EfP8QJkBjITY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bAYu4fB2;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942491;
	b=zh1uTq9DzjPQIBJ8dCHMF6+/Fx3uXxg5TjUbHXVtvFsmCLpBqnuySCPm3nPSSZ6szvzg6G
	dVcIBZ3ypjvG8kBk6Fn8YfV+PzVe9+ySCAWG5E1uPAXXkcVCnQkSd0GwbQbGQIB/wQzQnX
	mFGLijNAJWE3z0Zr704clZmnsRBpyWQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B53041FDE;
	Fri, 28 Aug 2026 18:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2482A1F000E9;
	Fri, 28 Aug 2026 18:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787942490;
	bh=JZhNp9hZHYOOVceBfL/gOW5jcyTZH8S3/g7aNieeBbo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bAYu4fB2Vn7jHtuvEIkOFv7rZ2Pnjv0Ywg2pTxO8qQBc3obpDI52eV7FcBLa0yxeW
	 glk+5YOwgRKgcCQQwKyVTDnlSMZepvRAEO5Zhy7R6oXaTKn+E8ATHRAHiOc+U40HaC
	 h4UgAEGYUMyNvCvGaMRYJWhDUPpxfNlloOyLA36c=
Date: Fri, 28 Aug 2026 11:41:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 1/4] fs: fix missed removal of
 super_fs_objects_eligible()
Message-Id: <20260828114129.909edbfb7e42b36af2da6a98@linux-foundation.org>
In-Reply-To: <3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
	<3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: o4k4bir9fnijoua6gkq1or7gk7gjz6pz
X-Rspamd-Queue-Id: 8E58F180008
X-HE-Tag: 1787942491-228256
X-HE-Meta: U2FsdGVkX18Yv19NkpO831OkNkWdGITZnF3uHmfhFelO14b5ZR2GLjWUhgMFq9c2xulAFELwoME9BfQQ3fyFAxmd7XkKf5bJ5lRU6QsL3UD6m3cbNaRhveY1ahNaq26ADB9BjFdjKpKNIPGeacANrx4lW+oHBU8nkoKQyo81Nror3joUBdDlpVL+LPuAkU7aIUP1GwbkTBiCtySZ4qrwJIlTpovrng5mxDjq+u04y8hDNpvtgsQg0qB2AIkFq7oeSqXjcKl/FGSoaNrwBS8pE1YGZP7BQ33v0HW6O1pxY57JsXF+zLZTvciNAJW5IRXl48RG371/nddq0rJQdkfXqU5HSFTcgIKRFsqU3w9KTtdZLzRB1m3g+Avke+d+zUjl/Xe6C6+OicHgFbR4TdhqgaJURPqGzd4BgrBL/zuNlhXP3gfIdL80iWRROUFBmBKNO+QFnPbSUUQVZlSmX7mbi51Ze+6FNpzh1q6RhctRSjWsbzRXorDNfpjqu5yhbovP9ZePQAKS6L0r1ntFmzNwFx2TZNKSV8KrN3Vhd56mTbPBMHHxcI9A0vyJCw//HYEzcqZkuG8pUmzRZzjT1ohj7IraUIJS0ZnY9A/QxB38Z6GtTUUxjLUeorSCPbhZeUq6EkwarQdF7lLQsDgWOP75vjdHnFIrwXPFcoofheqx8pQRcdHWDtoP5zeA7Zznz236ELf6vZfOF3urjTJT+ca14+UfAqTSjLfclyCPYrQGD23w0XRx1/XYuIEIziKSCnLSQzAPntR++jj4SrsQeD+TAkfJ3RakZ3O3LBkUUoaxTJkaeqWmkCOnKEzwqUuv4s9WR4yrdXwrsp5NEHh4IQ4T5VhGaEI/wFWtH0udIyilLgDZ2gS2dM9Pkp0vx7vf8vrj/ECak8U38RLNw4nd0zmIGc+acp4dDEybUjnJ7xbi3xihBkiD4MxEWirnrpnfJQvegb990dP5iG+mUg/0QnO
 stfBnhmJ
 +aw121Ey7DD0F3ku3fauJ0LsNbA5swOc0AO0mbhU3CDR9+FfLrMARSlsuh32cllqFFDWtoQZ4V9WvPJ8bIMSysxQPiVg0al345j9wBeyO0su5cPVnj6qhNgLlQhMQOefO6UFb+Mtxk08Le26H4v7ALhUc+TdK/RzrZ6EdRlb6gNx778h2eRa96qpODmMn6DieAKomxzR8dyxq+QlRhClEVEvv/chH4qCVEn0tV//d78WF13bmtgLEYCFvg0OAQdk/9oo3ZnTRwaZ8IFjK0wFSIgMrLbzwHp0ubUgDFagelIaEvWRYBJ/hAVo5oYzWD0JAlkbi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 17:03:25 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
> individual filesystems") forgot to drop the super_fs_objects_eligible(),
> just fix it.

Oh.  Why?  Please can we have a description of what's wrong with the
current code?


