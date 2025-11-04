Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A98CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 22:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACC288E0005; Tue,  4 Nov 2025 17:15:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7CBF8E0002; Tue,  4 Nov 2025 17:15:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992C78E0005; Tue,  4 Nov 2025 17:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86C978E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:15:05 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16DB113B8F7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 22:15:05 +0000 (UTC)
X-FDA: 84074330970.06.74FC683
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5CE4F180010
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 22:15:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NKO+ZrBd;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762294503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjOlQAboS1NrJwHowqooRPmaL8+k7XvoQvwz2HCWVM8=;
	b=pME9JwYBARMfdZNaM8k0ROr+dtNmLmINE7hRjec9Keg+W66NY2HLRM78FE9WolYjiGDvwj
	6hG2CyRJSTlRjk6wtxg10DLpBxNeVwa36Nc++VhQqPvmNDrMk+UqEqR97Y9VeoalOVPAmt
	4qGWb8pJ32uUoZIwtoL37ADscsC9RXo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762294503; a=rsa-sha256;
	cv=none;
	b=baVHZyRlTDXPhrh5IV/eZyk3MBlRboOuou4RraLqi5yUSBrJu5ba6MXsROPYVCZLxkaYUu
	kKyBAJOW+SQE3QByNP+C/gB/LjoyaTbPLdd7wGkyglZHhlsUpZNOgxUNcjvwNnunGmMCRQ
	yso0NKPLCAJtBTUA3/Zp+60qacrvLeY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NKO+ZrBd;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 67DB7601EF;
	Tue,  4 Nov 2025 22:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB352C4CEF7;
	Tue,  4 Nov 2025 22:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762294502;
	bh=v+esQas1JeFF71JBjf0xMHyo5U6oIXQScKc+wNUW+b4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NKO+ZrBdlfWjXd7WcH8GvFLTdQ8JhCsYoHPaEI3BlWJ0L9mb8kfb3Lhx3q8vaE2nO
	 DRYUyhnk+Jm7YdZ6e0jqH2o0QTng+MGhcG/Zq8etPnI5M+/Naz87pp0BwSSRGiABp4
	 wjfWtSRynhiQgTbCTGOOnAaKP4mJ7MLH0cu3XRgc=
Date: Tue, 4 Nov 2025 14:15:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>
Subject: Re: [linux-next:master 4972/5926]
 kernel/kexec_handover_debug.c:16:18: error: use of undeclared identifier
 'kho_scratch_cnt'
Message-Id: <20251104141501.48a1f76a3f83967f08d00097@linux-foundation.org>
In-Reply-To: <CA+CK2bBnorfsTymKtv4rKvqGBHs=y=MjEMMRg_tE-RME6n-zUw@mail.gmail.com>
References: <202511042251.paO6f5BZ-lkp@intel.com>
	<aQod7jDFBjw9T-u2@kernel.org>
	<CA+CK2bBYF5AndNHgqcb5zDbUOV04nE6xiZ0igcTdYf-GOU4aOQ@mail.gmail.com>
	<CA+CK2bBnorfsTymKtv4rKvqGBHs=y=MjEMMRg_tE-RME6n-zUw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4oigkjz8p7swdjwri597srb6geye5oq6
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CE4F180010
X-Rspamd-Server: rspam10
X-HE-Tag: 1762294503-113351
X-HE-Meta: U2FsdGVkX18cenNmdnLMFNDmeH7gP9/GHE4sDv8fdUpE8DmyzfNTdC2tFeRT/vdo7YOjHvM2swhTIL5HT/jViw3Nc4cWIreSb3dMQxylB3RtEedwsBi0+NrnCaeuAXdIQhFp1pPDzDslKw4tSZf4Ftct45QonZgCQzre1g2Diynjq0BKBnBIos6vkh0oy+h37863/HTiBGwKWWLiQdlyZfoI63dGSQvE52TbVkMQk+m6iVlO4Czexo5caWlQhVDFaC0M6AeJ5NMdJ4l1uthWqfyAbR8VXcokwKeYCCKyXEVFBdLIgXaTTSFk0Wnmqo74wZk4/OVHT0zTxLtnODUqPxSdkcKc215uhMoi8Gz+d9LRJqKHrzaj6TOXyWUtbyOr8TF1Mo9T2qdYJGkFTSoUZUJPstBwYnHuEdHnNv7MLQQDW+Alw4kySNZ5LJpXU65ysr0bDWyZEkdjSCMkqGxI71j2GcjNcpuj/0v56rcrefV6MwS6/hG8OQxsSoprmaVrIsveQ31z6VfTABFEvluDO+P/wehh+eovOqIfEbLqTfBsD6llCtfOJDeu0nJuHmuueZHfhK9fkoUTbNwKtZ+0hoTfv1NlgL8cM3F+16h0jfygSmDPuZF0WJg51WGCU1ypsE1trVLl8zm5yolTPp3cfiYQI6xAJ83UNoUdQV+kBmwTq3VYnYYPXsddPj7zmeyIPG1xUjsaJFZ0/GHf5crRzwCC6XwTkTottr4LWPtEhypSW50l4Zplxy4ByeFU9lDPCk4AM9MhbRXXKmr9daL7ik5Sz4HtW+I4xErLcvddOYLltJIYO8/kBTLlDtw+PKWKtEifH/ph2K+H5zRuCXE6oq6dki/IKuTWdvcNWEg62yDBdP4WRbeTJs1IiEgCWFAGnk25PyfCuoTJeBceSGc5CFx9faT6NmRRq+2seJLPgibETAOdI7H8eL4e2wvBQtRmNvSv4SqWuvL4fATSGV1
 ycEWg8QT
 YrvyBvntxFsa1W4f7WAIsth/H50/muXW8S4/qLAVEvwNRSi/S9e2uRDYbQTlkOvwidCiFdt9pIEp4Ttacy35q9be2inSrX2kssek60Qmgfyx1PM6v/OVfMQhW1qmmiVeMuYu1XXcM/qH0l0dS9vHwhaHZ5CwXsgKtc5cyCma2rArCSl1xGb7giO9Tgbsroc6C20AWhEat4yazj2opHclt2h0rCnl3Z++cis/KHXrhLgF0RXrZpYRWtq1cpTE12k1c0h0GuGZ4lW0dii9y17jJdXmnk006cCjUVqlOUHs+fp1JlgfTL43e0nvVDgCX37VC+Hf9HULkIsNPOZSvADqrb4sgQ3j8lnmS3/Yg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Nov 2025 12:50:49 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> The fix looks like this:
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index de4466b47455..2a8c20c238a8 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -477,8 +477,8 @@ static void __init kho_mem_deserialize(const void *fdt)
>   * area for early allocations that happen before page allocator is
>   * initialized.
>   */
> -static struct kho_scratch *kho_scratch;
> -static unsigned int kho_scratch_cnt;
> +struct kho_scratch *kho_scratch;
> +unsigned int kho_scratch_cnt;

This patch is making changes which are already present.

> --- a/kernel/kexec_handover_internal.h
> +++ b/kernel/kexec_handover_internal.h

Against files which were moved to kernel/liveupdate/!

> Andrew, Mike, do you want me to resend the "[PATCH v3 0/3] KHO: kfence
> + KHO memory corruption fix" series with the fix included?

A little fix against what's presently in mm.git would be great, please.

