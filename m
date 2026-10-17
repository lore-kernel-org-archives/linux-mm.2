Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F65CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C856B008A; Sat, 17 Oct 2026 12:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D266B0092; Sat, 17 Oct 2026 12:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531F76B0095; Sat, 17 Oct 2026 12:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34F146B008A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:30:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BF481202CE
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:30:04 +0000 (UTC)
X-FDA: 85332655128.07.672AA1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 911DDC0009
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:30:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PeKmOw4J;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792254602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0DmlSRuNRCJbXtkSTjE1NDx4IN1vmXMrnRQ7uFb2H0=;
	b=jwvmxyTMqMng/+rI1VseFfGV9ZmdboEvnCxUR2Wa6ksRGUcV8jGPluHX9AHejIDB+fwUvz
	wXeDPLrS2Jy2773zLr85nF/OqBIQtgUEtJu5fokc9jvg5sAZ5aV89I4mc2CrobqLy1UXuL
	9bf/zv/dvE5u5PbMVlfb99GvzQpie3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792254602;
	b=neej3FfVW8WfE9uFffMZIiTWCJYRQ8exJ8kj9z2Suh7osViR1wYjB3xa/eqZtmtfMVMMl3
	UI0umw41jRZP72PdJjURezAGjhU6PF1XmkYOwBhUR1DnJWJKpSUWMt95z0EvhLwutZLWBa
	BNEg9n2l61DDlt/il65XdhfGPO4C7/Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PeKmOw4J;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E495560AA5;
	Sat, 17 Oct 2026 16:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245001F000C5;
	Sat, 17 Oct 2026 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792254601;
	bh=X0DmlSRuNRCJbXtkSTjE1NDx4IN1vmXMrnRQ7uFb2H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PeKmOw4Jiki3/fJnnAJ22M5qF9oJIzt1qIMerDBuwvmo8EqZCLozJKW1Ihpmg944G
	 99/UgGyFtilWGzHziQ+CviBtvZwzdfMdEOlbNfPUkv7z8veajSn85RyxLbw/WSh/1a
	 PT7DNvFmI5IuBUg+BLAoFDvrY6v6Uy7MdOIvA2j+NnVDN5Qnl0y8ti6ZF/GYwZqpEL
	 E4sNe0SQrXbOD8A897GjW6N7g/Lcwuv1CFFnN2OZrMDbV0aytqS00JjeEN7s7e1vaf
	 B1nnGFXH5+upytKF2oEAJpyYXLmY5FK+4VtrNRkNxaQoNFonowvyo6RVd4W9hEigTy
	 QSfYTlWEGVCUA==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aveline Noir <jm5905938@gmail.com>,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: Re: [Duplicate Text] in mm/damon/ and Doc/admin-guide/mm/damon/
Date: Sat, 17 Oct 2026 09:29:53 -0700
Message-ID: <20261017162954.104148-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1061edcf257c9e625efe5f6f000013e9b2d4c650.camel@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 911DDC0009
X-Rspamd-Server: rspam08
X-Stat-Signature: h3dn6nigxp6hynfzjzwp7p38j7et569b
X-HE-Tag: 1792254602-113859
X-HE-Meta: U2FsdGVkX18+36JMHiDgaA1eWi+MLt5+1ElP6uj50kEB9xUT/PdLH2QNOPkVKBR6LuzsyXaEsAnBE83ANhK6Aae9Tc8Gvx6QZo11+TAx09YRzNleX4apgQsTBc+hUYuxa8oewtwob/4coHlsUpzGXcgVfh+FJihfZK6RNZ9GsHsm0+HES4c7Z8MNKLGXNP+b6rlmOejBSXvjw5P4I7xt8bJOMVv0VDryVwDneBHx9E1IYFm/wzAtaeBgcpGdiYzDGzqRYJAfs8cEXQGfSvO/pKeuuNyPjv77zcCxo+Chvena5t91Xc6h5E7GsM+tR46B3q82Q+8cYHMrJ1RT89bmp0I6xR9xVBnTXmY+KspbuhtHkAnY8+ZsbufBp8QNh+EoIB1bGWURjXytOhkwL0qFMy1gHq7+IXcvxCoCo3e64TfrsUJCzlGXqCsqrPAxOriteYbIUU5esKWGiKELkSiM1OwJygqrYnckiV8obQP1CsLzCQmQga5eR934fno8ndcZVCAEvMqTezcHtxDldz2I0SleGBskyod3X2Fpvk3L2pF3wyznyRmYjxqG16PfkPI4feq5E8jxjBrFlT7BaJ4OyzeTnjCfe8P4o3es6ZK3If9YJ4OfeceSLEbn9LS/P5UuGR6I9wVvoINoWsHXRxwZyWxz2nQtPQyfYRDlHbs8oXYWdomnDr9BYNOBTytwVz6yz1oWuvO6A85Wx/hH4+sHfE/+igdaWBztbmLZcTSaacNAbnsr1yQG6Jk50kUDpOOr/qSmIYoB7+VKraTDSnlVv3ukOPNYi7aRyct+HEcTv7VQkhD1qW2+Hsj9wNy9+bS9hvYrXby5qBqRjN9TyfpsS0YTVFGYzJig5pjzQB3kTIbmj2Nhu45tGtcYOar/+WuIOadfevlChX0mnQ8oF6iVRlMffdCCzrk0s1q2MtFhzp7E/2q1zYjmmYNvDES2nOmKcISxiyY5nPUDPWNzL3A
 U0QcjaEP
 ghBflQg4swGdsV72Pb2bCrri9WR27YOJQSZbaUATrv/avvDOTIg2l3QRSk1+hNiSJ6Zn1I8BbppR5M7KniPNrVJMrNL+Ubj0fZ1LtcCOfujRKoGOqrM1EW+Tbffjj9ngLmU4pwOo4Rm1tEvCCrXnbaPxMOrTAoKvWYN5h86UCl4tnkd5vdvihKRrAUVMCojGwHHP4MgrQ06D406QtToE0Kb86fIdAXCiP4TI3ZmJoE7IcAu5kT/DiwTyYt8EbxSWgBkxAtLIJPxqbO1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 17:32:47 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Hi SJ,
> 
> there is a lot of duplicated text in these directories. Diff doesn't show
> any because in mm/damon/ the text is a multi-line comment.
> 
> ~40 Lines in lru_sort.c and lru_sort.rst,
> ~50 Lines in reclaim.c and reclaim.rst and
> a few Lines in stat.c and stat.rst.
> 
> I think it's important to decide on how to handle the duplication before
> patching.
> 
> Delete one set, keep (and fix) both or add a reference in one place to
> the other? Could sphinx do the duplication?

Let's keep and fix both for now.  We can consider deduplicating if it turns out
to be too much overhead.  I don't feel so yet.


Thanks,
SJ

[...]

