Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DEFCD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 00:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C7F6B0005; Tue, 12 May 2026 20:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34E36B008A; Tue, 12 May 2026 20:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71186B008C; Tue, 12 May 2026 20:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6A126B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:32:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33B6714065A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:32:03 +0000 (UTC)
X-FDA: 84760519326.21.CB01E14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D350180002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:32:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NXiuTDlN;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778632321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRIVmmzslEnMMj4gkxGSwH1gCFpnWMBxt/9omMoWGVI=;
	b=bRiQBi8RL8g7d5FH33J3MlaDCI6Bg+gnpOH58Ptz43HyQN8MHH8oArnr2/SsfiB+rxLF6T
	1/M0cgY5I4vDGfwh8eJhuKSUWOLFWsGU6l/yJqd6lpkty8DTm/OOT0VBdQu2GW60LH1EOu
	DY1OC7OGHoFN0XYgYqeCsUSmyqqiabs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NXiuTDlN;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778632321; a=rsa-sha256;
	cv=none;
	b=fVLgPk895urTxwF7vyEpPmOimXljCSOivFEBOfdF9AjraHxwnJPkQOXcZ0rTLXDBSiTMQx
	ZM9KzjMEhSKYNpWWT6LRE8i7BINSaZygCmb6Z1kNhqqkdExPSqendGAtwFS2/6Tt9Iz3Xl
	eHEihsoZ4sEZt4a1DObweZGFzz/OFqM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A4904442E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE60C2BCB8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778632320;
	bh=ZRIVmmzslEnMMj4gkxGSwH1gCFpnWMBxt/9omMoWGVI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NXiuTDlN8qg2q/M6bl50Lz1X750XQKQSUGkpAZb3mpVVjneb3Yz+tnFVrAyXboO4/
	 sHzc97I4qS4548mZHQBvADB48HFkvtbRF9YlYms9wMHkH64gZEgqYCTwYqUYYMhZOs
	 eSFTSFgvuJOYyd7RQLSj7h/UHwjdFaAR2tTd6xET+rldSX5KDg+1+dRFQL2C75U2do
	 W1l2gDEbA8vNefMF/iqMsJcn4raBdvgC/cV6KEbgBQjTtcwMT9R127u0R7sbCLFB+a
	 az1EYkboPHN4rzZC4MpQyFNJJ6BulRz2AtOoKq8LGv5U4+yHz0GBxFNYkYxBDRGwwz
	 tBrGRFFmL11uw==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-651c5d525f6so6885627d50.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 17:32:00 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzw9624EZvgq2caIzOjvH7qHYIm7WOBQk9GnrFxMYX1CtIk8qxm
	aZE/7J10UpLpgiuqGeHvWdTpxqV3TzgUhlGJAl6wcLgklp/WAiqPev+OJHYG0mFjoJ/GuZtPDDO
	Q5rC4+hJKE5q8R+xGtg7OmTJNTPN+C4yAHzr0dNZ9oQ==
X-Received: by 2002:a05:690e:130d:b0:651:b86f:3657 with SMTP id
 956f58d0204a3-65df828a702mr569521d50.36.1778632319451; Tue, 12 May 2026
 17:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260512104201.716213-1-baoquan.he@linux.dev> <20260512104201.716213-4-baoquan.he@linux.dev>
In-Reply-To: <20260512104201.716213-4-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 12 May 2026 17:31:46 -0700
X-Gmail-Original-Message-ID: <CACePvbUGhEXOKHA=-CYu321oNWjKLaUHE30gpRPS8JDOY7=77g@mail.gmail.com>
X-Gm-Features: AVHnY4IwjcRWYDnAzrUZGUKTb8K7WPH15eC2A3iHQv3HeHB0Ond3Gk6bhsZLI6c
Message-ID: <CACePvbUGhEXOKHA=-CYu321oNWjKLaUHE30gpRPS8JDOY7=77g@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jqcug651sy7jq9ypcyawaktptpgfbty3
X-Rspamd-Queue-Id: 4D350180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778632321-338352
X-HE-Meta: U2FsdGVkX18q7CQbOpW9iszzUb+6sCPXBH9IleylFIZ13Bd80SHfReOPI//XfiZ5Z7urBQD6X7iks398bMxWT5zbCShVbZvFpSkE+n5XxLVpcegodZ/KDOq9HQx8gfQQVxqVpjBa0qjxk3y9qx9uQ8OQN1v2FRiyZaT9JoZK9tUckVr2nXfW7hGpR+rgqh/AtGnGbsvN04bRqT+VM6PV94F6JhOXgRWdFsqhRmLYgQfu85/mIIMeBm/mO5U/wmoajd2Ot9a83RohyCZncGkPk5y6R73dIMPVITnqlSMOfJ63gzxHEQPR4TD8SrN5jSWASTtxvmZ61uUUVY8qzFKGcWZROJ7qBxkD7OdCaxXbtYUf4t2OM6ii7H3LBsjuQWncKweDL0hbebdSuvyRiWIMQMAjBJfVGt/F3zmxVmIXExhrwuqjuTIzayaTRYiFWoEtLEx85xhcTa2u4myzn+sbJqSPuSEO+/BgGjptPsUd1wPzpqoZ+AdOINc++/UwaU9kQe5I8w3cQdS2JDLXqc4MjF2X6rwu/qlmgncAqNXS60g8KaxJ0O1DMvc8Y/BXjcSZEuzLhSIi/ED7AbiJxppaUI6tVjL0blyLdmgiuVwhTjTfej3RDnQo3fUH8P5azWEqGLoAann1ykloupMLe9n5flAG1a2IxOUh7nftd4BI7ix3LHqQXPsSWLQ4v7it4jX+aBmwIsqmj3g6n2rUGLqq7I5bU5UDMhK+uJcYhe6b6+Qc6a4JCgtkwhRir9Ci4KhhQWG/GV/Ar6tHtU2DQ10s3/cyTFntdJKIx+EVOWeFPV4pRpBnHVKxxNq0THfYynMHperCQN/PaIwGnZ2kXi1ZW3aEWY/Gi6qSO6TRv6skn1G+98EuzFd4qtktwFVsRJbCQZFcdmPr8UXVs+j/K9ljtjD7XXSvQxJamB2yIdBsu9K6Y1q2Q4ZHiekXxeuk7rR7oCw1YcpjFxhGs2ytPlm
 XulU5/OQ
 2XOeDNbgkcXdhMgHf+FT3R8VraCRuUwrR2+3IE228IU6GNhfVjYBBocvE9lMPkG892TJFTqhh9r4MV8sEbPRXJfGSyX4oQJ+v6+oCKaPra1sv8KkoC+Ou3z4+3Znk8R5l9c2KO6CZCyezO7JZO7W//dHcRqTaTTsRUazRxyLdt43bSh/O8P7Vc108ljfb6WogBN9mttGoCMamc8uYSUq1ny6n6kmC5QyUb/qmMmfAUKsUumPDZ0vwIjuedVpRt96IWgUTv/cXdr5EkiJSntqmmZYKDR35EdMJ+wWJXumYQxReZs8GxIf6O9pRrUKcQT1BJQBhDtAHU2HtpenqLMDEA5JVbIJ4G8KurAsd1sUAQtyg1QRndHmBlGWNf3oJfTJCuP3r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 3:42=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> All these swap_writepage_* functions handle a passed-in folio,
> not a page. This renaming makes them consistent with their
> counterpart swap_read_folio_* functions.
>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

