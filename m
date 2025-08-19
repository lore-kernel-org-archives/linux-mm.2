Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9324CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478936B00B1; Tue, 19 Aug 2025 02:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4502C6B00B3; Tue, 19 Aug 2025 02:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D996B00B4; Tue, 19 Aug 2025 02:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCBC6B00B1
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:27:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7DE0116FDB
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:27:52 +0000 (UTC)
X-FDA: 83792526384.27.DAFAE2B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id 56D0140008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:27:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h2xVcKYy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZTj5o7ubhdJGq1DQxACRXTS07t5f9fJHptp1Lp2OVrA=;
	b=iXCD7T84x3RBOcGRgjjW1EfMPNn8cFlkqJmUKKahZqG0gEaB8CKxaJA2lqK57FYD9PhqJq
	yFS/dg58myiKsUrgNl2uxtwAGvN3a6J+iUo67wgyuMv5/ZkCPaCgxIPsvYY2wX9z0JmeQo
	0sucRi+qRc6RTa2Ibl7Dls9AcBMetNc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h2xVcKYy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584871; a=rsa-sha256;
	cv=none;
	b=ZnBuZ/L507ETkgoLfuOWyBtxZ0GdieMakunQ8UQH+TgZ6vVG3NJek+L3gEpdBWJYLQNc+L
	XdnnrZEEwaOLkDK3Q7N1tblXCMMSOy6ble0Q2Nhsjs87Sef/vyCL9UJ9cc2WXwgtK9MEUQ
	G+zlfQHcRrxvHn6xZPG5KUMydVniYpY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 916905C59ED;
	Tue, 19 Aug 2025 06:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEC7C4CEF4;
	Tue, 19 Aug 2025 06:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584869;
	bh=AwJvsFLxwS4iuj+sBbq471Qe7na3TD9I6DWOiSYCPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2xVcKYyCz8zH0A41cHA5/5KzkzTWDc0ZeVVESjbJldNtbfYLfmz3vVrsphAclUph
	 HsGPkNLUlnBsetxjioJMFbQYY+/lSM9yjFdjzSdbjpApwnNc3u00PdSZ+LfBz+SchI
	 o0XdMK9OmbIzGvl8fXzlvpthBkxLqsrZh7QF6e16/vB3hwf5kBHiAsIF7mv+NHj+qp
	 DvprCneFcRxkpPHuR2yVtdorvHr3B0tm6f6o0yR2T1GEXXE60rHTVDK/SbLkhfVLKt
	 4/VqoWcphkOLmDnkn2ewCrlsBG+BSjpZAG+jGi1nzNdzeRLD7J5nmGZ8rFNqNcfVLQ
	 WtYUn+JrNHlJA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 06/16] mm/damon/paddr: support addr_unit for DAMOS_STAT
Date: Mon, 18 Aug 2025 23:27:47 -0700
Message-Id: <20250819062747.40259-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250819062217.39729-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56D0140008
X-Stat-Signature: pgtx1a1jmhaxsjtwfnwnq6ucscxhay51
X-Rspam-User: 
X-HE-Tag: 1755584871-386618
X-HE-Meta: U2FsdGVkX198uSNIwESEYCmzYOYh8cQwlvp9Rr9C0yKm2raFShSSEtTKEDfI4VMNIwViSoPYWCeYGI/BkTWR0Lh8e+Na3dMG5OGQaHP8XV/ZpebcBy45Wt7Ib+9h8nW1bdfWx++55CULAdYtM9owyPwsCayq631gd/7tq03wZKa9zW92X5o4TVHw7YyTluM/V/afZNii3p9zMsRa6dhorv280ox0gDQdkqN2cCULHgxBDADfJIgpQZZ8A3mDQmV2XghdA+uqlNnPmmW0juxj/JmtYjTFRwhPR/ncR6r7LQFeItUnANJY+p3jPNTS7OY46d2iGrslz9B2McZbp0NAnwiD6iWBWcFAMvixbeleuSSRqcA7u5bGZhyeVnwHti3jqwNZLRj9aN2zOCts8YeVxSHH7yMd3+4VrdO4Ebh2nVyan7Zh64mOCsV2wN3YhIKPnN72FDh8ZNGNhTrEXe+WYqtliTrKS/4aWOFEiXJ5EkA2fDiBpdghz0g/yHTaX0FHamH5ByNkj3cbQ8wvAkfRH7aFImUWQjuNU8tWG3vqFnSvMjdLVkrRpDodSSkEqo7hP1k3myNKabNs0U68DczF75Z0xclxtGM43M7EYIOs44zSF2N8bbv61hbQpRhZAS8Tj+kmTgi0iyNavhYjs0SvE28JGw+tzZljuoj0DU72zVzmBbqAD2ubr4r1OXlt6jcPCQ2Iz5y2duc7MKlp08QiES+URwzct3SG24afjDYEXhTG4CtszeOn9Q9f80rYqLC3iUnCNJqRDrohYPpF32JcFFemJ63TDL7FaOhb3ktLBUbqfoMQC14l7poL2/3DWextJAPyr31VvtCsOuKd4tj1ukqfc+eFm1q5yL7eWhn2G8l4pogrpnCIt/+Wy+B2Sme5zjxmpNwTnZddeP5Rhu8uPlq6ewGxfl5aibUrESvDeurH/+9iceQ4wIPjYNVO2FuiycUd7+4XalmEq73jXyD
 xW9mtbNB
 RyeLDiULPtLGmPfYne0dimqk3jqWa3t/LrLgNYyvbADjzIfiKzs9aWYyab9A0KF6rPJXtDArOFpDIMC20acSfyBdi/pNAkLGjfN7UpS7WLAx4Cdy4VLaEz8+al5D/x8Ujn0udB1yEVtkUnS0NuExTn93oklXQUY9PUkF5mLwRSfincaEAjk5R0FfnvTzqjBfP9EAm5SnPh8KHL087oj/bKdfYD18FD2DiZMP7KV3hgcza6wFGVkUiJpS3k0fycTvtofR7+7kP6qQiwleHV+lslbNfjnD2sbGTmK6tWgegSHqFQ8E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 23:22:17 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hi Quanmin,
> 
> On Wed, 13 Aug 2025 13:06:56 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> 
> > From: SeongJae Park <sj@kernel.org>
> > 
> > Add support of addr_unit for DAMOS_STAT action handling from the DAMOS
> > operation implementation for the physical address space.
> 
> As I suggested on another reply[1], please squash attaching patch to this one
> when you post next version of this series.
> 
> [1] https://lore.kernel.org/0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch

Sorry for the above wrong link.  Plese use
https://lore.kernel.org/20250813170806.6251-1-sj@kernel.org instead.


Thanks,
SJ

[...]

