Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8997CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 22:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF3B6B0093; Tue, 12 May 2026 18:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6E96B0096; Tue, 12 May 2026 18:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4566B0098; Tue, 12 May 2026 18:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFE7D6B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:46:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 705581C149B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:46:32 +0000 (UTC)
X-FDA: 84760253424.10.8FF0524
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8F039C0009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:46:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rjRg8MmV;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778625990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPy3gIsURv7pAN6VRzjUMIBegKeAjj2OId9K2rDu8PU=;
	b=SHU4KvBNQzk5w4Td56Sw0NpxUeQtnBANMfqaUEVfhGMfzF7KBzjXBgqBummniY7dcOIzJX
	ACMNnDAlzlsFpeoVZ//OGnxy98RAFdliAcDNqOccuf4t20hkVPg1y86hxFp4qJKht0DWpZ
	6DsdSvkALccft6Fir5Clgxxc0Nglqow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778625990; a=rsa-sha256;
	cv=none;
	b=VXNWUym8/pvBjzeHFpbVoKszh3vZAGWai0oqNsSJ2mkLf1S+dJu5UH4hY1XwzC9jWn5qlt
	YtE+yK8VumuRmkptlSoycvC06KAddyCYoWZb1Q7eeK+7Zc24VHMRtb075B8KiuQ8Dyzaz2
	PSmHSb4Fw31emCL0/5vlpZOq263i0Nk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rjRg8MmV;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F2A2406CC;
	Tue, 12 May 2026 22:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ECCC2BCB0;
	Tue, 12 May 2026 22:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778625989;
	bh=SMUx2+NAIUaALUF7jFMmKKri2IWeIDMtw8A52vqEhKc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rjRg8MmVMQX/cuud2vWEUG7rlEBs5/1tlb4i2HZuNoDMhuoP68UCCkK5SV72FL/dV
	 q8WwTI+FgGEGLrsiIUPywyExff7RJ/vq4H1hb4mpcCxTpSRanZE7ZItuDvsFQbYcOk
	 tLSknkZYN/ep5ULvx4wtEMv9fruY0RZEMYQRhB8w=
Date: Tue, 12 May 2026 15:46:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v5 4/4] percpu: Fix hint invariant breakage
Message-Id: <20260512154628.a30e8eb1827c80e0529b672e@linux-foundation.org>
In-Reply-To: <20260510072149.1279887-4-joonwonkang@google.com>
References: <20260510072149.1279887-1-joonwonkang@google.com>
	<20260510072149.1279887-4-joonwonkang@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F039C0009
X-Rspam-User: 
X-Stat-Signature: g5cnjwkptmjzu4xjxs71xzgh3aewo87n
X-HE-Tag: 1778625990-527794
X-HE-Meta: U2FsdGVkX18Q40Eib/JhuSpUnh0+ppDIunu+C8k7gBFu8Dfg+CBl1aDgwwXZfLwvCQNc/pSTMkwoDj0UUP6p9CjOrBkAGOI4c5SsCyip2FiNbDuIdIRZIQpgegpFAS9RhR0daRoRe6oS3tXEYKTXxsot+xpju1GuMA3X/FG/x6gsv7LgekKPLaKx17A2T9K1V2OGH0iWPMgsXI9JoMFbPy9qRPcHuzcpSohoCBm0AWHZmr9hP+siJ2SD6Bqi0r1gDW2t6EiGVHOgpWc1bEyuDjCT7CaCW1uLoLdERH8WpT6whWeD+hLXUcX39PFi1gZgwuLziuQdkc6L/9ClAVPMc2ffNo5Z6cH2exVqSWzGUDJc/K/2cXUL4SpHQJRfOHcd85I0qgkAHMt1eQDQX43XYjclN4XWih/AJB+4lvdnOSSQdeo5ZBkb8zYpmKvYUVVqrQ2bAPUJNF8VPyDHUUFMeAFeKdLDUPk/M+jsNMNXCqHNaxPwqP2Ezk/4djIEYQNOnw/jUPQbvdSGVKUQ+3Ld2441rhUsYfSoMHBbwb/0s7ZzONjiWxS32npp9n90rJcLnoauBVpg8bXAcPWFIZ1TUERDHr6TUi8n1bpqF4sfVAd9zXrxtFrk/Zeis3d7Tq2rUdaGdsWcvsN5h8s28AfiEMA5UzUhfAWSA2/AeER6NfheeV1VQ3jJz432ZJumJJPoYB+VLLSQ8ECmu1ZY3NENrGHrx0o101RBbZPC/GJybDd/EaFBn83jM3z8cUZ79SC6zG5Rf7b9ujJGm7yN6NYIyHJPvApFUg/uM4cNGuUmq6nTiJvbW4J/uAPzRjaKPsCx75MhmwuCtIuEzAN5c2G4qdHbDIDSsKWJTXcWkPCT0mt4rWiPl8cs2fCkSTuCbTA2FGFpgVxUzuhz8oVGpuYSxNSokBnChN+xgjwk3r2Sm/NidWnV7SidVF2yDM7/0C+K1sXJeSsVfM8c+aw+G8D
 34lQfjWc
 zQR4UsgUo5Y0I1uxkApiDIpOgC/KgHLHrBvWcPmUbauPTBMsG8TOZQH7n634D8jIuiEubmXtiOp7wBqaPktgNDz8B/YwFRfeNSy2quuO1eXKv1uU5yW4jqm3oDdjNTCD0Cd8AY4W/vo8jlVGVh/vdXrWu+SwrZDXFsg6p1KlpJeGXg1hjJiXY2qrFkA4nsvZzFedI8geztDITUU1y0Xj4I5JFYFZXI3jNlY/zMES7U3Ea+E4+Hv8jcvixJFDfGejpBz/57CHkfpEjr1/Q9zKkhxsKefTqHCPJUiHJfnJOL5eD+2SDvfb5ew7rVkij5duDtMNHn/OYBB5Dm0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 10 May 2026 07:21:49 +0000 Joonwon Kang <joonwonkang@google.com> wrote:

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
> This commit mainly fixes this invariant breakage and includes more:

Thanks.  AI review asked a single question:
	https://sashiko.dev/#/patchset/20260510072149.1279887-1-joonwonkang@google.com

