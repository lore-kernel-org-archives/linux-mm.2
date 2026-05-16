Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41B2CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 00:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12FD56B0088; Fri, 15 May 2026 20:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA6B6B008A; Fri, 15 May 2026 20:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB3E6B008C; Fri, 15 May 2026 20:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC6816B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:02:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7C6C16021D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:02:52 +0000 (UTC)
X-FDA: 84771332184.25.66715AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D4071100006
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:02:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vFPDmMyJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778889770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfoOctsdxXISBewgemqjufyCrZNHDlzdZa1dUb/+T8Y=;
	b=8WoZKGXgurQh6N4Mds/tXhRthwkny9AWhIr5pj0kwd7+ojtlPKEthDwE2AobzfM2lot0B0
	pBUtcTBTdImWwLLRaojqhtdLHHiW639x4VYJBouwPXwg3aMWmqnApPAK3V4VHinDFjF73u
	KBCPVwh49G5Vp7fhWOr3wdjePemk61g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778889770; a=rsa-sha256;
	cv=none;
	b=IGnnc+jET4Y1K33dkSYnQdr7QBgQfouyR/d2SSwQBH52DWDyzgU35bwwhLBPvS7thpDYC7
	qOvJNANUUWIbYHKYxDPIBnx04sVg7InnTNzBdvXz3JnMzKzwFzOz7A6WF1kTxVcovnkpoL
	iyKR01zpwmRYKSjnPDReC5D4NeCuxOI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vFPDmMyJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0DF044122;
	Sat, 16 May 2026 00:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E51C2BCB0;
	Sat, 16 May 2026 00:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778889769;
	bh=q/RcEyZ++E4Irr7VcVtFjd200tk6TSDeapQfTiXOsXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFPDmMyJRZjBMvPujRgif2haUPlvdyRr18wue+QSCFbkNhBrC2qF+WXNk4Ptsbmps
	 Vn04LzKadVYvMXY+CDbqspOKnEkSEEBYmbmR3fbNut2bIH7AEcysEYHFnuK67Lz/Le
	 +8FHFd7tJW6CDKYaWcoaK7hLwg+m52HM/CfAaA3O7/lyM2KigZVaPOx+K3jZNdlkLY
	 xPxBgEkfJwFHs6hMpkTRDGV1z6QX1C0AxLzfGZd4MvZzEmOU3al4vd9RQPiuNI+weG
	 NBulSeJUl2s7iMRB+pFKsz208KVeM/u4+4/k8vettcF0RBXtjdgk2Lq9moBQeTyJRD
	 3ZlIkg4t29n1A==
From: SeongJae Park <sj@kernel.org>
To: wangxuewen <18810879172@163.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: Re: [PATCH v1 2/3] tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
Date: Fri, 15 May 2026 17:02:41 -0700
Message-ID: <20260516000242.136498-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515065325.4009527-3-18810879172@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D4071100006
X-Stat-Signature: ho8brs91exwdobin5k7gba3q7n7mrr78
X-Rspam-User: 
X-HE-Tag: 1778889770-804215
X-HE-Meta: U2FsdGVkX19W0uw0G9nBU78QBNU3VH9A5eS77eRbp4pkImasjSg9uO2J401u/0vuJ11D6dsY2QSzd9WZ/z9b4Y3BXPtTsz3881xyMyqfzju5KlX0GO2MX76i75QYUe2vVz0qX7Y4FxJEzeCX6X77mL/kpBsWDMrzCMyOHBH8F6ErUDGD7Y/j1UOPANZieqegLigJvZkBOUXIFNEH1tFEbf91pNRg6zw4rNxWA47y93P44+LXaDyQwEulUdLddjE3fuvA4RLZtBG9Q6YnCfCRLkUTRB7X5W//IuGYYMAulV8hFn4kJc/OsLGm6MKnjWCh1JcxHT6pVudwgV2nrkLA9r2Blz+8Gkqtcyih/GjEEaa3siNegdPrIQ/FjbG7+IOvEPxriE7LaRev3YmtJCDOLbA/tOhO8/QATmw4ywPo2uC7N4su6n88l9jmZ7pF8vWBS9PMIIm2UsBy9wWYjwQRFnvwffcOc2jbGfzq+yQdELhLLHvi5MH0yRygm4dgy4akj9greNoxF6A4BFNZWVfTTb3rBWY1Ws73IS1KxdaLQ3SWmC5MOHRTXpywHvfh0e1kOyGQM1dp6PllAcX/htlw6XBqqAtoKuPenTAfpbBI1yPREZr6kvLrgbZ1kqNZNVeuHe6a2nh+eM2HyaqRVOC5pmkjxweeB8OFjoPbxCyLrT+d7uNo0hSWYYlMtHLjA9SBBkSLIe5eS3AaRacc3WYu3Z92L+3AZPCaWeSbI2WpyqyoqsoSPdsGnap6vtEEjBjTYzEeQ3UgqxlTCWa9BkYcCvyDE3yG+NpYbVvTr3zYOwsWPWz5cX3/2WEXw0D+f8iXqzivAkAOU/JTcIAC3n5t2eUNmGWLwQppIGxsN9PlAY2EYzmZ4KJfLxh2T8FehTK8u17FIGn0jDJU/Ob6AOLkXgtu097IyM+yhX4vJtsD1FmVHQucbbC1oV3BfKiTXO0w8d6T+jA7L3vpYjcO/NA
 3PH81Sft
 pkKzB6QnuAAddIBPcm1VmG/e1UInblMC5vnhLcTpPQRooArdX2QF1ZRzlRj5PVwYef8WHy2PEx43Ry1xUbmd+HKUgkGh5+/R4ceTS5Mm36PWKZQZuWoUhotju9B6sulunZkC7Bc9SLHFHHgnIdbEtbLMHUBxCmqiJHO0+vr+cPyewJACctTGexWPGQ1IbOukeh2CRcv7mNiosIpr/wv6q9Sh0gjuwO+PJ4rUyeoC2X6h0+UHNIcisMaRnO5Nz7O5Q2Mxi1EXwG3x9wEiBPNXffk6XIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 14:53:24 +0800 wangxuewen <18810879172@163.com> wrote:

> The assignment `x = NULL` sets the local parameter variable instead of
> `*x`, which is a no-op since `*x` was already set to NULL on the line
> above. Remove the dead assignment.
> 
> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>

The email address mismatches.

> ---
>  tools/mm/slabinfo.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 39f7eae7eecd..ac00daee41d1 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -194,7 +194,6 @@ static unsigned long get_obj_and_str(const char *name, char **x)
>  	*x = NULL;
>  
>  	if (!read_obj(name)) {
> -		x = NULL;
>  		return 0;
>  	}

You could further remove the braces?

>  	result = strtoul(buffer, &p, 10);
> -- 
> 2.25.1


Thanks,
SJ

