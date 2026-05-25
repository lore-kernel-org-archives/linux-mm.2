Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601CDCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7B56B0005; Mon, 25 May 2026 15:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958DD6B0088; Mon, 25 May 2026 15:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E7B6B008A; Mon, 25 May 2026 15:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71FBF6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:31:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B5131201D0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:31:12 +0000 (UTC)
X-FDA: 84806935584.26.8EB36E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 61402140002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:31:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CiwsqtlS;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779737470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvrEoRjjhq9hE4z0e/L8Y7gfSYwRsEYYg3744tOFPOs=;
	b=6ZoB75L2et34PA/SYi4NHjfqXVx1mQPaXgmEx1xIYBM+7k7MvlCaWmEDl8cms/GW/M5Q+q
	vm43M1iBgQslTBZXEoWLm9WCYAedw7lAls74j1duwei3CW/iNu3zM3gX+UlLQR6V8C5i8C
	Br/7E1gmEfKNbb+phxf3id2irlsrLkM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CiwsqtlS;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779737470; a=rsa-sha256;
	cv=none;
	b=odp193TQdAIPJJKn4JDRqqP1TbjBtaZPqDL/b5szNvSrnoce7Pke/b/N0usZpk9nygruhH
	9p3K4G7Yg8h1xfO21j4S1vRkvJSF86DEZYEp8dZcxr14H7mj/wm9xZTkLVK8FjpubsAEjt
	bosQtTe5sUUICoFEnTFIdNa9UGjvB9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80DFD405BC;
	Mon, 25 May 2026 19:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC72C1F000E9;
	Mon, 25 May 2026 19:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779737469;
	bh=QvrEoRjjhq9hE4z0e/L8Y7gfSYwRsEYYg3744tOFPOs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CiwsqtlSv5tLtltiP4np3cPPoXXu+ECJba3j5uIoAsOrZwr1PKr2Io2fOFRsFVGbj
	 sNOM6allwT3Ub4CpsT3bHF7ez01xQ60dt2dY7DIdIZU+YashBqk0aLBV2JXYaT1SJo
	 AVofEgKXf7njpIj9jFN0NIytr2OWDcVqwi99jS/E=
Date: Mon, 25 May 2026 12:31:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org, rppt@kernel.org,
 peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com,
 vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
 skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
 jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v4 03/14] mm: rename uffd-wp PTE accessors to uffd
Message-Id: <20260525123108.0b66d07c4be97dab3536dfde@linux-foundation.org>
In-Reply-To: <ahRf00RTI4_0Puux@thinkstation>
References: <20260525113737.1942478-4-kas@kernel.org>
	<20260525120513.C51E91F00A3A@smtp.kernel.org>
	<ahRf00RTI4_0Puux@thinkstation>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61402140002
X-Stat-Signature: pdi5jfqn8jqoiu5mh3ru4dc8ywcxueqz
X-HE-Tag: 1779737470-229694
X-HE-Meta: U2FsdGVkX1+q0fEbgKmC5OTrMAWEuJVUmnYNBtRAkw9Tdx9j9WflD+4heJnmMcniGOb+82xo3V1POBnndNgB2iFjpWBSe+ebxNM3zM3XlDUqgpzztsGtn6eao3pmMY4LCxwpSd6+FVCdMxH6S2n58TE/O49JDdTRqVrXEz0Ztp5D3TNS2yHYM4cSoaQ35H1MjswgQaFAz7qRnpe07A8V0wKww0PZgBFtQhuRedEx2CBEGr4TtZFxJvWASck0qBEUZ9pSpnGP7KbSpqEJPDbD8//mLDwbADa7QUT7W91xey5HaOE/Yb0rneuzyizxgqqOXW7LwektxTg9+me5cVivk6XBBF6zzfDm9Salg5VZdojbYyWatWM6lWrfQE29CWZLEbfSVMiMPwi4LuneLfSEjYXLNOhXJYapyA2E/NZRbJjm82A3IlfVPIyUnQLsPN61r6AaZxVhZC0sBYmA5l0Mcwg4BFBRBvAKgOFP0QfmzNk+lrxl/CF8QgMHBhX3PXb2la2OQDQHaA7Cx3BrEC7yBNyuX59WVM8xqzWEc5210WdwVVdcBN6jKQCtjmEs+un+7spoOprCvH3ZPWm6HeaRjR5fObZVnEbSM9+YtdZbzq5O7I6qMsfX53BbCMYuvEn7t9+7PDCnGyrqEQMM2nxmCaCi631uMgSpKwZSXTrhdE0yTJbEQXPe1KhOrW9NsaSqAcB/KbNWW8kK6oQWpe3ooyhdpIjyiLCGdH4GtiiJ7fC8QYfE4SUsoT5D5RYvR1RkwmDkWr6J9niccNISOJNbXvwoCTuasPihSbfZZGXNbegP0quQ0orCqWEXQpLpSpzAoBRwof7v5RC09Sd16jga2lt6LDxH43Qh8EeEc6ts8UE7JJ6SqtD3uLjIYqNNlm3ARzxoF26Z4jjUaKDYhOgJVYdkzM0i1tapdA1BnJGpH+dgXablwYn4lDEAZ5Y4Vr8JKBUBLfLckyk4MqKI/NE
 urzTrF66
 pBUw0DV/K4Z0unwyjfd6z83ZIkrXlZWW3fgAN/yZJJ+hGGJPS/pztVO3JJlo0PUiCTOyiN82NJrHDxo3sy5VVbWMgsnhdI0IzCctOosZIsZlELSf74x1ws6XJwjxazBFAGw7DKzAdGenyqgdvo32sFoVgGDj/l9gbuUWwgQ75kc7pwdJvu6DeMZ2NvRpHZzfrgyITngyrAq0x1+LDOTz/SfapdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 15:43:32 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> To: sashiko-reviews@lists.linux.dev

hm.  What's this.

Sashiko seems to have been useful this time around.

> Confirmed and pre-existing ... Will address in a separate
> patch on top of this series.

There are quite a few like this.  Would it be better to address these
existing issues immediately then base the new feature-add on top?

