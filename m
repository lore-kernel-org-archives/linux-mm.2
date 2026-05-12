Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E07CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765C26B008A; Tue, 12 May 2026 03:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715AF6B008C; Tue, 12 May 2026 03:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6531C6B0092; Tue, 12 May 2026 03:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5539A6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:20:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE50B1C02C4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:20:14 +0000 (UTC)
X-FDA: 84757919148.03.1991361
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 321BDC0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:20:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=soJoZRoM;
	spf=pass (imf28.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOK7f6ec2LsMgcWQRwIq/1n3zq7AV3Tu58DuoNcWJL8=;
	b=i/w5/bnA88LAA+k6MtDde08rRczkW/k1FUPwexeolA9WpTJiZE15QzKd+9MDsEMvEdN37E
	QaO3vO6x+1REZm7V5XoTJ/sN4ONK0r2nHmQCH9RMLEe0L9a/3wHdw1CNEc/QY63PpYqFQg
	VURVKX829cYPaKIkDCM1hSV/014jB+w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=soJoZRoM;
	spf=pass (imf28.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570413; a=rsa-sha256;
	cv=none;
	b=5M11Ek1VHqGw6oUuRQaWOhlPxfnralxL4qubPgcPtAAIjbREqtyV0zfLSvtaA/J99/FcSp
	6Sr+brjhVJpW7T0IFgnsGaExW3Lk92D0e8590OWrHU9eWZlLmr19897V4CJv4qBlpqCTKe
	ILpZ0jAxSCV2jkYpNRenznLaCGUba4w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 33E7A43F30;
	Tue, 12 May 2026 07:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06282C2BCB0;
	Tue, 12 May 2026 07:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570412;
	bh=gFxSwQ2vwNGN7Wy+a57I0BqMT4+uCuIw9JWDuf1wsoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=soJoZRoMxJtn9BFF3dpQwvk0xi820TNJfptJMtJX/cP/qNW+teYamRrcMVyhtuIf2
	 iR30YL5xnlEO3jTCx2tpM77XOC5OsxBpMB1POJFpEuFKTdBQGIEvxGGPmqeJ32yTYY
	 UA2xlPqKw+9LfjJN4MQdMcexmE51BlA+EqPHlH5f+sN6l+N2Pb4HNurNsKuKugTIio
	 ole6921MHwRdIF7HBTc7tpfjCL6KBtD6BTBQ1Q6GwaBCiWuHWUGJB5v8Me5Q8cQ3NI
	 Tq43OhBP9tdm5zD08MqoxYDF0J0eeB07AIqRJJSRbCGW+bEl8POIDqcxOUAfOS/yGy
	 b9paE8zlD9+yw==
Message-ID: <f157c318-790d-4931-bcc2-7b3c95c8c2b0@kernel.org>
Date: Tue, 12 May 2026 16:20:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/12] swap,block: move the block device swapon code into
 block/fops.c
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-7-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 321BDC0002
X-Rspam-User: 
X-Stat-Signature: nqqfzbq6g88o647crsc334x6q4i4mguo
X-HE-Tag: 1778570412-907344
X-HE-Meta: U2FsdGVkX19FgyhqlR9V4fK0D8h7WGkVD9TFMLoCYmBjrS4/8qlBFw5AhR1jpnEjzGuUE5kj+5xY3iaAHSeQz+2i5WF8YAgf+8eMGYYhta/lYa8+7nUfTKeRtYPqJvNVVvTHDVQwD/FxzqTYoa0LVCqkIHBDLfogENlW1sHz/72ndPdFdWZHJh49ZmnRXIVPD86eVknvruQSM7C5ydWrGBEf2HLHybiNBGH/la2Vxr1HRiz/R4oR0vNNe0fIjPKLgAkdXby1VIqDkzdWLe5xt3g2Ow63bOu1rscDn7EKyc5hJv0E3s4YpxLJnCpDUzkCYuw564moRxRajbbouh2o3ygthcjBpB/Lnq98DHviAkLGyIuMdlM82Bv2mWfQ7nHW5Fv629QxEofNE2MZAdWt4zcSmwHjNgcSybF9EI99NwRGAHy7wp3L5io8weCItPr5vuTVAyxWJ+580mIxzaQGqwo21mSGU0PKnuC/yDHmhpNczb0BgZA/xK3LvKrYO8Wy1v0WIvFezNolFT8OEHNPJ9fRJusvbzVVKKHq2zzjjV43rvxoZNoNjxSEhQ96LRbRGk/bI/u3ZIjoSIyRu4+WKujTV8DnxSplzo+HLV4QtA6EdI2H/ONhQBwWD4QEjLFGkRzTvOcLzxcJAeOgq1hvccjVd25af29uQn7RqLy+ZrnwPQf91g5/KuPtZO3FLQ71q9L8YllGMLLiErXNYssd2+AZ+PNhiew9qIaFDGmABAQIS7q0y7sDpbFGnByBi3l4+cGnabpmHPWWQKWmMPKy7qQ68h/e5duYxbNc2tAOyfeOKu2ngRpPJZ0iGJLKD4ydepIkIT4cGdFKuWz6NlTnMAnhanhiaSBYV/Fwt6xXJceKoRztrHsinNtpOgMznYKykmsabwAjrDCqAHDNDlM2BCgSzEvOG7Fuk2m+Jk+l+OPYQo8QTtkfNK206Lt4Hc5FAjs3PJxbByqu42Bbp57
 gAEQU/Gl
 wE6YBr0CL9xE7yHX9OrmVly3hH7AtTt5HYnt7MNQe85JowCFXsOlpFoPD0iQPINEiVBdwg0Q9b6LGKcsswSFfqR/xodS5rMNVYR+TnRRz3IuNqeErLranPxHq20kvOEIx6p+tps2IQQS1dJUDF4ArWpOyncpHwbgusqKaq+tx8aKJ0I8i08/sro/FGTFjXoI2gG/BfNXLsUlIEVqV8v+Pt7xa5cGKi9pWLKWr/7Arq4pFAbLk+JFkj4qgRiuq7fVgyh8Oil8vVIExvB9QJ5b58MLKcWJy/YbzLTePgMeQlFclmH5Dz5ORdd9vnpUPPMq7y4CG02QqC792azPDsZqrSTQe/hlt1p1k8+18ZMmtaWL7Sncfui9fAUzw5s++1pZaLr9a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> Make use of the abstractions we have.  This is a preparation for
> moving more special casing down into block/.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

