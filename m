Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE5FF364A4
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32246B008A; Thu,  9 Apr 2026 13:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2B86B008C; Thu,  9 Apr 2026 13:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1956B0092; Thu,  9 Apr 2026 13:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9C8D6B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:03:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 056B813BCAC
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:03:28 +0000 (UTC)
X-FDA: 84639638496.15.BD68237
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 26D3A40016
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:03:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hTRlqvo5;
	spf=pass (imf07.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775754206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlbtUK11ejlh+AbZO79lglXrLZbQabCI4s+8sUt4k7s=;
	b=Bk8vcaZpPZ1y91WnJoyBbOPCOXnTznM7PWerphdKxAxITV0+BoDiA6TbUDi31x96TmT1Fj
	O/0cpoiIhjdm9J+ezTD148jfmD1oUDHY5prxdR5ExI8HEBFLZ6MfNlCAeTkR45Lik3r0sp
	VhxgHINFCBwQjbaFaF0xO+w9kpIUkR4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hTRlqvo5;
	spf=pass (imf07.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775754206; a=rsa-sha256;
	cv=none;
	b=h7VQjI7Siho4narksRSZUCKtokAnwfHVZkQkDsTQtaFdLZLyI/SbCeNwVMkZxzKq2/Vm/S
	EY9HSdra8eGsK/hfnXg4PqYS6Q96+tz2vAj9aT1iB8sz7lhLna484yAYIaeKCAdeV1zzel
	WHunG2iSiAUeX+o5rYwNh2CvN1z13yo=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aae146b604so8518795ad.3
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 10:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775754205; x=1776359005; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VlbtUK11ejlh+AbZO79lglXrLZbQabCI4s+8sUt4k7s=;
        b=hTRlqvo5WGy5Gg22T9F55gOU9FVXO+ym+btQB+HRTk3ouGUXzqyDoiVbm9r3wIFTkk
         rxy5QQk/R0k/n3qi+UBSrPfQT9YOZFTVIr0DtYU1+/69Ge+3kk3WB2ldBccPPrhYvt9a
         HAKg+5fRkFUp1clgYUFfLE3w+5BTkuFZOxCYNHVlzUmrQiZFJgp7mLoWr48ysP0gADpL
         /QMxWZAORwFl0QvvPIGjRaYtjsuFHn7ba7ztJbKuHmFwzOfrdEIyJKgLLILOdYGqBO7H
         y1Gk142qHZArC/F3uuyCHq10UrgILMUIdidH1BGlwiSprcL/5vtfyVk4O7/FH2sHTZi3
         FoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775754205; x=1776359005;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VlbtUK11ejlh+AbZO79lglXrLZbQabCI4s+8sUt4k7s=;
        b=PchSB5kcr52WBzAcOrmg2su55TBOSJVWXJS5O5ABqocS+8aIEbtXWSvYErkQ4fXc7p
         JlthnIukpBcb9SU6fF4UDKbH36FQE5LUNGLIfjWTw8knxsnkGwKufzlrvnNo8dRj4b2y
         yB/vGAx50oWSKmHxdvOAlGNAhzqPjrA+2eXCWDi+Bwlj8TdrK+J8E420GUqTh5kdWDxr
         y9BI3SlrECG/pL/ehZs9EVX/fB7GdWqrRIT8lCaS69GIx81Yp66/2NC38+BcS3ZbMEeC
         GrDnF4IA649gc4n9AEOnYXatCky65IYXnKS1Gbs9piiVaHPCxcXBRumXPyJ5MjlQ5zYF
         UDZQ==
X-Forwarded-Encrypted: i=1; AJvYcCV76J7b4sR14vMauM9ppvPi0AtUcQscn9IROUKClZqyfGYVL17Ue9KSBfp7fiR39VxsfdhGpN41AQ==@kvack.org
X-Gm-Message-State: AOJu0YzWax3TFGSZeBx1c14MlyGKE1s99DwIExMnQJ4ybdEwjE7uuqQ+
	yOfRNYpWRTr3TtoDLeaN/X3qaB30NyIulz4g8Qf0p2ArPM3P2hzW6ycv
X-Gm-Gg: AeBDiese2SIHfjzENv9HcX3IwlVrNFLkl6UYWwSPoO8Was9pF5Cr9wkF+O2wR6YmBbk
	lcxvS8vgN/CzI/z7eexWOGHFfclpEK8LkBM6rpTu9/iBOknPyREjALq4SUXsdqrU6UYgI/dKgRn
	ZM5SySrNF0bX4wG/W//6aZldiFCObdGNUnvU55txNor53W6PqF3gR8ePN1pNwXeKyiRxDKS3Rlb
	R7ehilR+sUWTaOZnHei/qfmtLnMOgajPJif9pnXF3vA+Wx+qICILl7gO07xq0sYycwrHsu1zPGX
	Q8eHQiDr6Plt+ASCUGxQiu6mMRmc9ZbUHdXKeMxnsFF2TI78E9oiOcG2Zek22foh1Dq79Vs5ygO
	PdFyx+uYZJXh7/VBE/RaP7qZ/JJBN7LeuD/a+hw0kdqIwzNEeANY4dWwliabw4xWAXOxmyxOo/K
	49CoFjwRrJIzYYbMzw/Bvx6cCg20QKb1PdiQ==
X-Received: by 2002:a17:903:1ac3:b0:2b0:62dd:3a80 with SMTP id d9443c01a7336-2b281868e69mr284863465ad.17.1775754203306;
        Thu, 09 Apr 2026 10:03:23 -0700 (PDT)
Received: from google.com ([118.150.148.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f27048sm554505ad.62.2026.04.09.10.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 10:03:22 -0700 (PDT)
Date: Fri, 10 Apr 2026 01:03:19 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Joonwon Kang <joonwonkang@google.com>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v2] percpu: Fix hint invariant breakage
Message-ID: <adfb1wrzJjuqHEuA@google.com>
References: <20260408100642.83919-1-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408100642.83919-1-joonwonkang@google.com>
X-Rspamd-Queue-Id: 26D3A40016
X-Stat-Signature: tgy8hmgisqzchgmhpto7b18sxdmr6ccy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775754205-93968
X-HE-Meta: U2FsdGVkX1+9rK8DUnm22pilTr8fogc3Ko8nf+hS3eXdIzg+tGZPzSYAFeS4OEfwdH1yQAlI7ZtlrX574baJVlv60zFiB9qeGe/nolyzHXRdbZPjazQjx3YMTCHphYOExSAKmJ6W4byrZnM8v//GbzhKIY2WO46UCB/bGtKzOUch7CCooyiEf3TaejvkVc/Y4SI7tF8X5R6dWbBZIClj2Htkr4iqKUvaxSKYmSnVFKoMGo1I9zGvAFTwj03U8vZIynFPVpWSfkYVrTm0AENdGuqwnF6agwn+/GsOatpMTwBkL7H9GZ9mbcWnlMGQifcGpgr9qpqpMf5E484Szv5tJEL9voIbzJITZ50T1JknWN0MobX3/njn8f/qEQ92k3CKXlb1POMEnCMHCROYptj7OOpy/FJHf+qcuifF8AL6ggTwUcv2tDMwsLP1U0v9XWAhTAQqgWXDAByZNDTPylZixS1jlykzjqeD7xXO3zBuj+5xVEzYppM+FyXXWORFWexMI7gn5WjEahegO6Vkmi/xtWan0qx4eeVbbVrztu/OuluAwTvU9dt0ne8naEg8ly6yWEX389izg9M6Lq8vMpQG2+CQbnIsZfOTs24urFZsL3vNEGlexW2+WDqbeYFsZ40yrHVExFDNJ8OTswhP4nMe+gzhVP1LIp9LDDFxV0zLoNEeWyooQK8hgjMSJNcWciE3bATaH1nFrfo8ZmsXgw585LWbUGQo2cCc6hLHpC9qgvpRQJgqDYzGuQtgwbmoMfaFHFiII37gJj/sq3VqSembXDvam6w4snBEDAr69i5Qc4NTU5BXdsLhs3FtrLB9PtD1Am/n8Hx84L+op4+J0DtvcGb1bA1jml5kjeX4xJ8n0j88MoQ1dffJueTWyKqrr0C7zFNcLEiqkIvqhTzYgaiIQfOz1/sr4loaND6ctXLCnaHJgmxA5c+R9hZI9dIJkVfjvLMDxQVpX9fIVCcPtrw
 tUWcsGSJ
 GnJLfbxWtvR7RRyc4RoANylyAvRtWEv+ytkaJy4YmrhStDI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joonwon,

On Wed, Apr 08, 2026 at 10:06:42AM +0000, Joonwon Kang wrote:
> The invariant "scan_hint_start > contig_hint_start if and only if
> scan_hint == contig_hint" should be kept for hint management. However,
> it could be broken in some cases:
> 
>   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
>     scan_hint_start < new contig start) && the new contig is to become a
>     new contig_hint due to its better alignment, then scan_hint should
>     be invalidated instead of keeping the old value.
> 
>   - if (new contig == contig_hint > scan_hint) && (new contig start <
>     contig_hint_start) && the new contig is not to become a new
>     contig_hint, then scan_hint should be not updated to the new contig.
> 
> This commit refactors the percpu block update code to make it more
> visible on what to consider, e.g. when the new contig overlaps with the
> old contig_hint or scan_hint, fixes the invariant breakage and also
> optimizes scan_hint further. Some of the optimization cases when no
> overlap occurs are:
> 
>   - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
>     contig start < contig_hint_start), then keep scan_hint instead of
>     invalidating it.
> 
>   - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
>     new contig start < scan_hint_start), then update scan_hint to the
>     old contig_hint instead of invalidating it.
> 
>   - if (new contig == contig_hint > scan_hint) && (new contig start <
>     contig_hint_start) && the new contig is to become a new contig_hint
>     due to its better alignment, then update scan_hint to the old
>     contig_hint instead of invalidating or keeping it.
> 
> Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> ---
> v1 -> v2: Consider cases where the new contig overlaps with the existing
>   contig_hint or scan_hint.
> 
>  mm/percpu.c | 124 +++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 85 insertions(+), 39 deletions(-)
> 

Just a few minor style nits; checkpatch.pl reported the following:

CHECK: Lines should not end with a '('
#173: FILE: mm/percpu.c:653:
+       overlap_with_contig_hint = pcpu_region_overlap(

CHECK: Unnecessary parentheses around 'scan_hint_cand_2 > scan_hint_cand_1'
#258: FILE: mm/percpu.c:699:
+       if ((scan_hint_cand_2 > scan_hint_cand_1) ||
+           (scan_hint_cand_2 == scan_hint_cand_1 &&
+            scan_hint_cand_2_start > scan_hint_cand_1_start)) {

Since this patch will need a respin anyway, I think it would be better
to address these together in the next version.

Regards,
Kuan-Wei

