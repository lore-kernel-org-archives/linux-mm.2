Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828A4CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED236B008A; Tue, 12 May 2026 09:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D836B008C; Tue, 12 May 2026 09:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB31A6B0092; Tue, 12 May 2026 09:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEDF36B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:34:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CFAC40500
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:34:11 +0000 (UTC)
X-FDA: 84758861502.16.83EE637
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8427CA000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:34:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=DOX6gKst;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778592849; a=rsa-sha256;
	cv=none;
	b=b38EjOWXlk/Fg5ow59Gq1cTsaH1yMpthvoXUvUM+VvFlM3vKo1NN7KbJ3b54OxZdMJQSZn
	rKSz72lrfaVFIPs/pfjkN1EeYDwkeXJ2xgADFnJkh2ixu5OnuQ3uKhtY+VP9J6GN1AxTyh
	3NYiqICYZXTkH8s1RGFuH3kwFqYhveY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=DOX6gKst;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778592849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WkcVadBrY1XKpqeX0xMjVFVAlCVexI4mnyeEkffHUE=;
	b=2q8Yyj5GbBBPp7i7IVzw/lqTs4kfWyonBIoJyVTJ9ZSfPiWlSvmaCDLLZ7vMc64BzZQLv4
	YER2RmbyyLjBUixa6Ogh/B5RN/to+J+bfpNT6UNgbEmloE9ysoVUXPT/ZeYyGtHDHU0Hvh
	yCKie6OxV8UmDwbXX6Q1mNfrkX6XAyA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7WkcVadBrY1XKpqeX0xMjVFVAlCVexI4mnyeEkffHUE=; b=DOX6gKstXwYkD/1QVtjEgDYhjg
	xMQ/0N8TErdX0WA4LFweELRgU+9lEIJbdD5IJkkFgbNULe7AGsD1U+vCIP+QXYJqeh8sZ0KuqZilG
	0xt82S9d0KoknAVHlrKCDRnHgiWf3I+qy08pIXKogB1L3P64bAtXSoQX33nPD0Y8+PXNcLGsS6s12
	2vlSK+O5cFSCjPFYUiKYQXaFMW05cG5TldGW3RPlF9DJbXe/UnxiijRdkKOHeR+q9xoJAsJ++awON
	OEc856Y6OErMCUcydm8uArBRUaxKx4FKJ4TSnSHzZ6STcEzROb12BnNonw4bnjMCpM/syN9MJLQ18
	E5i00zbQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMnF6-002PSz-1Y;
	Tue, 12 May 2026 13:33:48 +0000
Date: Tue, 12 May 2026 06:33:41 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v6 2/4] mm/memory-failure: classify get_any_page()
 failures by reason
Message-ID: <agMpqhpgmezqnaA_@gmail.com>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
 <20260511-ecc_panic-v6-2-183012ba7d4b@debian.org>
 <28b01c14-3d87-4cab-b695-5b9015578785@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28b01c14-3d87-4cab-b695-5b9015578785@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: kw9xhfrr54w3o4k187bfa4aqdui5j11x
X-Rspam-User: 
X-Rspamd-Queue-Id: 8427CA000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778592849-717940
X-HE-Meta: U2FsdGVkX18+RxPsXHsx1MNJP7wUb1/a2dAg6TSlKo1BrFHQoKII+07BwsV7OmPSwa8DiC8j6kjDZrFsuYGIO6wK3oGgSbPXUCwzQj8j2RzpSzeGMOczW3SE1rYQhQzGntfEvVUYRvA4y35xZTKw5i4H4/fvKO1Tx+pL4q/HJAUwg8ROp2ZClm6MXqootfzegSbLMIH+J29hJzmvU4a4DjRx3+NGGFQ9wOBDnGArjulZ52VZDPtqF3/b+Tjb26HgFZ9VHk4TuPtFDSnyh4zmePpvb9kc9FPLcIDBjrS+O77zN+RvoD23BUKyp9ewhc1iwkyC/VlXLh6dZpF98zUtiVCm/aKirTXqfPZ7Ay42yW7vLDFz3fU1dbJHUuuloMPuscASL2OdLEl8QcSPfo7jROiRLzeIrM+Ryav0jsPFtX3T07TH1QnTm9AngXRpGyrhwYSxWdoyokY779VbV/mm+EnBkiDduMfFw13ZQTqnWlusDFbMPddztgxy8y0D1CeyCeFJwcJv+kw5t6Zy56htp6j6PCVDH1LASu0M8WhQ1S7cRcjPr8xpMp/QEWEF0LcbHzgj/KGU9LfPmBpQdbHHess+4ivnWB7rpODykgH5YOQyB58OVnmNY4QS0PhgQ6xon4YqvXLidl9o38pWq9kNJ68cTk9ZVi/dI8sTjxJU+mBM7UdJkTKXFyJhOlr6THbjPtOISJAQ+gdFGo75H3myMCkqTAQjDcLJ6Xi1RsDqsVCwyA27MqO6nZz/MzgPCIhg7yVqMPCszWldXkooyqXVAjRbXd/VC5op1wDZmfCAi1UD78h2xbhKN5/TXiuY2ihFKXhr0qV9Jdtcvq/t3gCtbZnti6oNnjf9x3PaOr2iIfj/TSqQDgpZx74jL9ApinXHZ0afecu+xx6ES0l22svQximKooeg29LE7ZYh5wMaMJWwhlePFdb9yZKO6DBHEiuadnpqyqX4AfqGwUtNz4e
 tD7t6TI4
 sgB3k3pPx0SzA4EbagGArdVx+K9A2fPqO8SyXy924cu1vLWxfj2da/4DsUAxOASxzmrY2Zi33AaK8jlsTSM1Pv4HzbHVSdPWo9SotDaIVWJbkjJfWs5Yt/Q1lF441dtacO/w3auESYhuzTaKGEPk2f2wY9g127PliR0sfLOuiF3fw3imeOgf5KoHBLgu4GeRIIrFxM2BS9cNSCyXw4VrEz4HfO01RPhXiqyonKORJIdXK7fs8RYSnH+ixnX1DWJZ0iOOPqxFAWESIycQXd4KoWrNEwXnEbRttUL44Q+gDL7SPsZ+B6NFPLLzYIkPVE6RSaA9v+y6EjiXzFYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 10:21:50AM +0200, David Hildenbrand (Arm) wrote:
> 
> >  		}
> >  		goto unlock_mutex;
> >  	} else if (res < 0) {
> > -		if (is_reserved)
> > +		/*
> > +		 * Promote a stable unhandlable kernel page diagnosed by
> > +		 * get_hwpoison_page() to MF_MSG_KERNEL alongside reserved
> > +		 * pages; transient lifecycle races stay as MF_MSG_GET_HWPOISON.
> > +		 */
> > +		if (is_reserved || gp_status == MF_GET_PAGE_UNHANDLABLE)
> >  			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
> 
> 
> It's all a bit of a mess. get_hwpoison_page() should just indicate that a page
> is unhandable if it is PG_reserved?

Are you saying that we should identify if the page is PG_reserved in
get_hwpoison_page() instead of in memory_failure(), as done in the
previous patch ("mm/memory-failure: report MF_MSG_KERNEL for reserved
pages") ?

> Why can't we just return a special error code from  get_hwpoison_page()? We ahve
> plenty of errno values to chose from.

Something like:


diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 866c4428ac7ef..0a6d83575833e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -878,7 +878,7 @@ static const char *action_name[] = {
 };
 
 static const char * const action_page_types[] = {
-	[MF_MSG_KERNEL]			= "reserved kernel page",
+	[MF_MSG_KERNEL]			= "unrecoverable kernel page",
 	[MF_MSG_KERNEL_HIGH_ORDER]	= "high-order kernel page",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
@@ -1394,6 +1394,21 @@ static int get_any_page(struct page *p, unsigned long flags)
 	int ret = 0, pass = 0;
 	bool count_increased = false;

+	if (PageReserved(p)) {
+		ret = -ENOTRECOVERABLE;
+		goto out;
+	}
+
 	if (flags & MF_COUNT_INCREASED)
 		count_increased = true;
 
@@ -1422,7 +1437,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 				shake_page(p);
 				goto try_again;
 			}
-			ret = -EIO;
+			ret = -ENOTRECOVERABLE;
 			goto out;
 		}
 	}
@@ -1441,10 +1456,10 @@ static int get_any_page(struct page *p, unsigned long flags)
 			goto try_again;
 		}
 		put_page(p);
-		ret = -EIO;
+		ret = -ENOTRECOVERABLE;
 	}
 out:
-	if (ret == -EIO)
+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
 
 	return ret;
@@ -2431,6 +2448,9 @@ int memory_failure(unsigned long pfn, int flags)
 			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
 		goto unlock_mutex;
+	} else if (res == -ENOTRECOVERABLE) {
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		goto unlock_mutex;
 	} else if (res < 0) {
 		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 		goto unlock_mutex;


If that is what you are suggestion, maybe we can create another
MF_MSG_RESERVED? and another return value for get_any_page() to track
the reserve pages ?

Thanks for the review and suggestions,
--breno

