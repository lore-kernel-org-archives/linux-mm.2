Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F6B1049517
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F3C6B008A; Wed, 11 Mar 2026 05:32:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2796B008C; Wed, 11 Mar 2026 05:32:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3BF6B0092; Wed, 11 Mar 2026 05:32:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 162D96B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:32:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 986FD5A5E5
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:32:28 +0000 (UTC)
X-FDA: 84533266776.09.48784F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 955891C000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:32:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JfVWEI4z;
	spf=pass (imf18.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773221546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGYhPK256pxU9EiY8jbQSSjgozqR8V5kd9EUseD+GRo=;
	b=zxyXrFVY7AgKsYD/05GbrcVkdDpBYtjHihNuJk5rBhx8o82tO8sfnGdchgOysOhOat+eAd
	OztrEYE0RlYqW0BI5PYOpu3QvUkym0TY/mHOemVMd0ftqeJ+TuO9X62kBjf6ExzKT2oWjl
	tkZJbTfK2D2pQPpeJlz4XjaIvVqCvaI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773221546; a=rsa-sha256;
	cv=none;
	b=dFD6AkTc2McNYOkPGdzJU3nGCM87pALTvjKbPDd/D6JqGmlGzG0U01leU9figpeTPv0ah3
	UOHkEi3bqO6FudNSBCRHjD/L4QusqMK8B6GswLJdNR10rWF0Yxs5t0YJ+7Psv0Rtiyo3lS
	R3vNshQOh5i3yxyIkHgRTospBbqsaLg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JfVWEI4z;
	spf=pass (imf18.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9012643D98
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEF3C2BC9E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773221545;
	bh=JGYhPK256pxU9EiY8jbQSSjgozqR8V5kd9EUseD+GRo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JfVWEI4zDrh3iHX+1r4cle8Phcf0RBN0zERjJ8PQNA3EYWSATJ9h5lha/xBvVFGnI
	 lElqdFOyu5rUcg336ldY8JBHZo/CNZ6A5HFkXurPLCqwCA7763w9Gzh1MrCiovz1O6
	 4/dhditNlUPPz/o6nb1awN/pC+8W+SveVLbbW1M3XSJ0LknHbar0z1P9mnX5NF58yX
	 1Uj5dsDyxTrkO1DJZv/qpV8j6iPNzVVJVRqNM1MXMlgjgqpNnn65QlcqD5KydSFEzI
	 yLns3+tdmVfBsvgohk6ekX61JLdkJkatIbZorvb97Pbamw8/hcF79oQl43JkoSoDtA
	 x5H4ornHcPhQg==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64ae2ce2fe1so13016793d50.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:32:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUjKTmTPnu6nlkhs8OMMubJcq3zG1yiqsdE2bKZULcoTC5/RioeLKHB6r8yTLcauR41hTgBM7TBHw==@kvack.org
X-Gm-Message-State: AOJu0YxGF20aAt42Nl2Vsny6Fip/RQR6ehZLZOAzJOUQdGuzYd3/0iir
	7m4p3kdQrDbSmx0DDAhoXjVLawRCBLaEIJpJeLzAdjc3K8pTd0PNXNbweltCqPa09ZifWFN1hee
	Hke23SZibUZ+8SLyrUbk39x+I/4U2SAE=
X-Received: by 2002:a05:690e:144d:b0:64c:e890:fbb9 with SMTP id
 956f58d0204a3-64d656f696dmr1649157d50.20.1773221544775; Wed, 11 Mar 2026
 02:32:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-41-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-41-bd63b656022d@avm.de>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 11 Mar 2026 10:32:12 +0100
X-Gmail-Original-Message-ID: <CAD++jLnDv00ErgVdQ4EBpKH9KMWrPD8ODrQ6m846zyQ=wNzCzQ@mail.gmail.com>
X-Gm-Features: AaiRm52aI8z_G2E4qYaKWPEA43RhLektjwMDQXSLwHd-Xy_BYcin-6heFFY4jM4
Message-ID: <CAD++jLnDv00ErgVdQ4EBpKH9KMWrPD8ODrQ6m846zyQ=wNzCzQ@mail.gmail.com>
Subject: Re: [PATCH 41/61] pinctrl: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 754pro71pnnkwd5kpe98yts1w3yzkt9f
X-Rspamd-Queue-Id: 955891C000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773221546-552698
X-HE-Meta: U2FsdGVkX19ruWbfh4gJo0YhQ6rz5qBO7T/J9Vr4+yrpYNvRDI0XnFhd3AwA8AOMLbI3YZy8M+Qgk3Xx54BERfI7A/lsaKRZeGiWE+3rblAqsdKoiRWJ2nEsLor57a+B9h459MRWSCnuwtjBoUuDFkzyI6D44zaxnF0ZCsNVHIqDk5xQctm+NTyyzhwdE+SfX4Di89YkkZvDM+53U5UeSCcx0rXr2fl6lvKsAdjdBKjViKBgR1mGYKLlxex9Py94LCN4JI2jn5QPk29CS8VPdTiL7O6yfWEVnyPZ34FlNCHjRH4njX1Weu24sS5LT+8FLEEA9bt3+NvO6QGDvTqNqaK8JFshhCJ243ygZSH4zrOYO6lE3jsFfd3ja0fxoqL7JfSbKfGX33lUotsCHU1kPKrPqeY2DrSt5C9W1N3ymo72cQ8Rt26vWeo0nB5OFeeHfMtDsWHRlaQrb8eJRnczZdk1j4BvqCizu9NsIKRk6Bm4+A9tCTCYllIwtnxt+75R4jUNFD7D3ceUDlWWigPzHkKw2GyimOfZllmOv8lhT9CIaiKnuKRUnvojVuaHKFfX4SiGqVTUtoKhmeqKLwO0OMFwbhVkYHpHu4lgJ1FmhkvUOAdEfMKEmZDkFW0zUrfI62fOTkUvhW2ZrSfxtjsm8YUivHBujWQUzKeYJpgxe9FN24KIiDXizuXaGS2ZumCssewz7cGlHcr5GpumRIigUdkWkBytDqcNZ+xGFr+UKvgi0Bo5ByiacLdEw5QoM176FbQPwPbpeaqZZBSqGah0co0FgVj6sIPR4aAcd6UqI5+lY7mksLicJVoCeedYZ7itP5AI9dThUlYj/DWOg6wbdodkpOqKuftPpsNfg/jK71fOU49Uu/RFwnJxmF7waosrz2IX01uUDEm9lUrWcsL2VPiXeVp0RDWmAG+bQqNfLDWAnrWbX6LXQgm4Uwccx4v4H+LeLL+8gdIRTOoO2So
 UtYMuc6Y
 RBvCV1ZIh5zRWa6/UBffqmrYnnf3Pqk+Yy4qqMFZPUQZg0vpLURVBrnw6SxxGfSaYjsUC0p42lqZe26b9Dk+XwWTO4VvrtRHvjp0gs7kk9dZpCtFdlhASbdWtxJTzIGsGpvbiQjbFAXGsxTt+iNZXk1Msu7jVyJ+0GSdqKEqqH032lHfu79m8lDhRkdWlPTR4UzilQOtIBHao2T3GYCbM2hmo4ygR2HTHFqgHfJ92WwNFVyTVBSOWapo1m2Y2nPP4bkxtoTZAWGJAi2RLTyes9iQO8aSWoGccCU3HFbp2eXOzdTUGWAXY6I9DP4DsDiHTTi0c4tV955A4sQIKLQQoNc4Bn3q9YUS+tWOchuEVw3SbRVMD+NKairgp/BQciKbwNA82zYiI8q+dB3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 12:55=E2=80=AFPM Philipp Hahn <phahn-oss@avm.de> wr=
ote:

> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Change generated with coccinelle.
>
> To: Linus Walleij <linusw@kernel.org>
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Patch applied to the pinctrl tree as obviously correct.

Yours,
Linus Walleij

