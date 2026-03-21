Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64929109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79C16B00F8; Sat, 21 Mar 2026 14:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A4D6B00FA; Sat, 21 Mar 2026 14:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967096B00FB; Sat, 21 Mar 2026 14:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 826136B00F8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:04:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DE391A05B3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:04:19 +0000 (UTC)
X-FDA: 84570844638.18.AD7548B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A0239A0015
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:04:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gFKe+KLy;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGJkWIuD7KxbBrepJ9pHT3Nqi1tKyin/fHD8VBXUy7A=;
	b=RBubrIdd4vQltI0J88nY/IGvhU5nV8+uBeF18dmC+XKtosOtQasy3T7kUeDapI5OhuoyIF
	FBCSRC8fsh3Tu5Fjlpi9Diqt5fqstiZLHPTfxmZhbxAAQ+k6Wuvtr1kzZcpCTXaf67MxrH
	/DxayTFOsdHF9y6XKSTwJPboLZ4ypY4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gFKe+KLy;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116257; a=rsa-sha256;
	cv=none;
	b=OrTEL5WAO6J2oHX2WQPvMgqZvl/tUqYJlPfrK6jzkmY7n9innMItxPlsi9jIt19Lxo8711
	MwfgeGBsfaIm8PBsuN0atUliA6p8JiXMIet8FxD2XLq0J9/XRYISM7ODMv/MIEYbXDB+Hl
	QHoPfdj0Z8pKNv/6PPWuw2b+vs4DH5A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 01153600AE;
	Sat, 21 Mar 2026 18:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C03BC19421;
	Sat, 21 Mar 2026 18:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774116256;
	bh=7Ziz3FEBxwDfrBKEkvwU5ZBuK95WeSzFK10QqzMJyXY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gFKe+KLyaA/XnO3WRfr6lUp6fzd5+vRpvLqQ88zZfPnolHZerNDFM5c4sy6qRffV/
	 qzlGT+PxB6RB0uv7wzTs/9gFgGbo94IKjO9DbQOPepYeGtXDOLx4k9bXnI24Wgwmsz
	 pw9p69pxRInlmQ02RMEubHuWjKPNbV2IGeD886L4=
Date: Sat, 21 Mar 2026 11:04:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, Danilo
 Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v5 0/3] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-Id: <20260321110415.00c6a8bfb324cf5adcd2cb01@linux-foundation.org>
In-Reply-To: <03262674-2df0-40d8-b411-4735c6f43770@zohomail.in>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
	<03262674-2df0-40d8-b411-4735c6f43770@zohomail.in>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A0239A0015
X-Rspamd-Server: rspam07
X-Stat-Signature: 3iu6xgaeb6gzktagzqakittxmywbdhti
X-Rspam-User: 
X-HE-Tag: 1774116257-718174
X-HE-Meta: U2FsdGVkX18FNdjB9q0Ztfu8AlFq56lzRFnyR9ruqmVJsxF3jXu5YL4X3f9+3JcpsQgnnSh7eyvdD6i7gHI0nUTbqYMpARSdT5GIzRqUCksvFHzRVDRIbt59+We8CeVgTYApc9TVlsAINhvbYMfZUJXJATxMuB7vdntgn4df7cvQpyIJFaUC94HTkEcBI6/EvivDS5QWk4gjLkXxRGcHSa4dEzV0M5q21zKlDABm7kHkGRX644ZxG9vBKxk+PQD/o94zDneKqb/A+kPwCyfrFqeiDnP6Fbjs+QPMftc4CuAkdf2qCQc5eA/iIg8nX7iP5MsVenqdi3ozht7gq1Oir+PjOv0DySoa2i0wzJ+hZczoqNCzP434MYUduRLRlQBW8lQlZS+sgGIlO885PS2YON29Z4HeONi2VtJDP99Cvd7YHLcdmOdQqMPUSYH/LXHHHNJBs0ONW52DJkr1kH1FS6sGCf5HtuwUzA4PyyXTeAJPf45+05cKTC0Q7Bql40KAeFLeGfVY70XJ+w5hzmiFrDXbFEvx3ZK0JXGB4JU/FtBLmdCKNVmp16lI/oJKJeERaLTnlV6+12VGwHkIZQ+nRtgxVjl5Fd7iXMScHBoH1GEO1nA1qgVH1RsVtW0Y+CTK/fmI9HFcFr0iWRqI/ekNWS2/uHZj+HgdAL7fX+Dz7FK9hdNqWP9T3IAsiVspVDbevgUD/umCSw5ANSPfpxTOpUhs/JOSuQNctAg+HlcuYxwNiWYZtFQiC8LQEyy2EJzbYI516CD7Eu9ak0Mvm7dDJkfcb6trujZy7ghwspftHyFsVt1xDnmDe5B+4T/TcaIjAi1T5/qRjAEfGrjmG1sAo24IMNYHxtCgjsoUQunH3X0JQmHqNv36OPv5YyJYfP26etvciW0YkUFxTRST3RD6IZwhpzJOBcpORS8z2Dl2/EttoZ7ZUd20dED5wJETzuyUTNq1RqCDyT46WpoVaFx
 m2JymFfR
 nsH76dil+61PQtPY58n39JP/kmbbslRnApBPU57pAih61acZ0LeHpZTrhYPlUSfLZdZYxTwM0PNVfJcu3kYd1GC5T9xuADcgjQpKtvAztEl+KaubP0O9wBqCiyqPh/MYE9DBZx0Yj47eHvYKjLwFUC6IFmCTqRGAzAdOzXnbyjGJkdmgvisp4SpYNaIodY7S745CisgfwYpvzcYBGx9aMq2bQAfgV79jt6e20iO0chXLOIdI+l+i67W9ewj5SgargpZIOiWiI8VnNdWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 13:45:35 +0530 Shivam Kalra <shivamkalra98@zohomail.in> wrote:

> Thanks again to Alice and Danilo for prompting the closer look, and to
> Andrew for providing the review. 

Well, thanks to those who developed and provided the reviewbot!

Reviews seem to take 12+ hours at present.  Go to https://sashiko.dev/,
select linux-mm list, paste in the subject.  Or go directly to 

	id=<Message-ID>
	https://sashiko.dev/#/patchset/$id



