Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231C4CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 19:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29CA46B0088; Wed,  6 May 2026 15:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D8D6B008A; Wed,  6 May 2026 15:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1632D6B008C; Wed,  6 May 2026 15:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04E2A6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:44:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8691C88033
	for <linux-mm@kvack.org>; Wed,  6 May 2026 19:44:04 +0000 (UTC)
X-FDA: 84738020808.22.8C436E3
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7845C0002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 19:44:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=HGYtT1iv;
	spf=pass (imf28.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778096642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHp9EBnOI2lnH7H2uVcbDAl5cHHKwOoWjBp0ldA7Dnw=;
	b=HmQFusCcrx5jlZBi0XGRA5I++hNbRvTK/KDLHZx1579cE2WZ07JkkwiVgDrMMnNELA9Ll9
	b9T/VVKEHs+HwA1G6yANwrOox7uG8eLCDNUubiT/5PGucHqjc5+Ix43I2DRHB1ckPxaBcw
	+sAh7US4CLn6VOU52s3hDHff1Kd8D6A=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=HGYtT1iv;
	spf=pass (imf28.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778096642; a=rsa-sha256;
	cv=pass;
	b=r4ShXcHh/VfUJUmwaGD1K+O2eBfPsrC/gzGtOCq5FBJxM819WsKlJxUZpwTpOb7oqpTNMl
	M2GO9MJARGKRSt1Gp3DY84RnuJas2Xu5UaYzviFDVe61oV7zUyAiKS5Q0p8evWJbPZbcoV
	pM4SGw+e6BgvKg5H0OLXE8qr5hVP2f0=
ARC-Seal: i=1; a=rsa-sha256; t=1778096618; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=a80YWPevAVlJgEiu0SA8chJlgb7o2z4a8dZQGCKmzv6To8OEiplB7nmpRBb7YP5CXGjNTKtuV1PCFeMtLOJ2LkGl9tfG6KY6miKRL1dAqR7qFBaOFOkIOuKf3jMeRM3bZ8JY0cAAjZbJbbWtajPjrEQH2ukGPWja0YHdJeFtpww=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1778096618; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=VHp9EBnOI2lnH7H2uVcbDAl5cHHKwOoWjBp0ldA7Dnw=; 
	b=OIvx/d9gQuNU4E6Uh5LIv8V+aFuY3WeUAloUHhT5ob1cyBTERkj1/tFFBoIU9bVUiv7OEbwnsx1D6HNuxnpiMkCJrqzxii4Wh/S6q2r1mwTlCBxrywt+O6ZWb1MEX2cHJdwmlZJjfqCr80lfTT8UEn5eRa2x+wVquiYkxh8UDKU=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778096618;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=VHp9EBnOI2lnH7H2uVcbDAl5cHHKwOoWjBp0ldA7Dnw=;
	b=HGYtT1ivyCgudr3tFe5EofPGjIWU2EzjSZgNBs+T4yLZkpZjNZ6lJ8tQffdxSX3l
	YM5L/h9Mz2SHZa3DAr/82JI3vBHBVQxWL5haA1Y/7KzcohVlUZiLPRZsw+/x4fBGIcf
	BnmdPX3gI81QWbsrIcSId/AvTv2TmRa8M5lnQHaE=
Received: by mx.zoho.in with SMTPS id 1778096616740677.1226131288619;
	Thu, 7 May 2026 01:13:36 +0530 (IST)
Message-ID: <ed1a55f5-615f-42d4-805b-5f53ae2a529c@zohomail.in>
Date: Thu, 7 May 2026 01:13:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 2/5] mm/vmalloc: use physical page count for
 vrealloc() grow-in-place check
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
 <20260428-vmalloc-shrink-v12-2-3c18c9172eb1@zohomail.in>
 <afuMvOTfj977Bex5@pc636>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <afuMvOTfj977Bex5@pc636>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Stat-Signature: mhx8nbydo53zj191h74km1t8mamju4ee
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7845C0002
X-Rspam-User: 
X-HE-Tag: 1778096641-597948
X-HE-Meta: U2FsdGVkX1/xmXoFaofr7rtiy9ts0i3Dq4fVg6CD00H7Mozeem6DscHyFWS3QpVM2ERZuSFEV6JV4V8WUaNmS9IDXr+/3y0IQEHywywSe5TRdO1Z+l8N5w4R55PpFADYEkb2qj9xrLbsSi7NaiZ0CvyjzY6GiZEqVB40BsdhhxUkEoLh1RxvoNByhh0J1nWdHKstTWDQlmU9YW9fEVv9ANE0jRe+Lzfq9Ph1QPxJLVQySZyqaUDU/8JguG2ErbVNuK2183ZWbl1NupLGiGIcBolOvVvC9dDWqYWewcQOMZBEyVJ6gK6dWXhR/JdtqhtU4GE/G5PiWo4ciK88nyxtdyTuZF3W7SlWaSqoo3ygA7ZIPFdQhpKMl3PrV40YTdcdPUEf0hUbBBQ7112owvfZoWGn2QeQkaIcO1a7tBNcoyqsWtLzZnYfoPYEqc0lLQl78wAHndJ5/5EfF8TH4G8L/vyOSwEdGvXE/3Kzuv66BOpHCa7uZzFVUGPf/SRu5Wj9qssxOc2uv17SyTgsZQOYgVOyLUxic+n6xK4KV9NKfVqYEzKM0U/eo8gwXsgJNDAbSIsHzQ6GIYM9Nv0fYsvB4u4Kmu7bhSr/k68VyCWsr4tKmgL42yIvjjBdKszxVctjGNNE75hNI3iCtpFrHdc9fFtQUCSDGWXkZsYan1ShVL9MPg+4LC706A/R65IEMk2N6taXZB7fnM4I4yCiczNnRtGjThjNsZq6/uEe/BLf0tKQMUJZG6v4HainRYKbkjlJwQ9H0+f3K2vM0gV0f+n0t3unwy4idIbVhoOd26/6DIrWG8KC4+ZRVcUDYqN/TVb72wIWGqAyIWOkC9cBxh/L27w8g/od5AxU3BQ89C4NcPY+GqjFSmdim1mtAAvpEdPE0t5fG+qyRW/xWxzAqfxLTpZq1juPACcMHZ6wocjSPNhwnEIDQUoPgbcwDtrb9YctJlGIdIFDAEODMSJKRKO
 FEN8iZDp
 e4HXy7a0uXQidi1etjv2HKNxcg9opk93FY4cE/o2m+MDgSAki1YyAYGPTEgkCZ/uUpJ0PHNHiFXZt8LHQitvC1WSpRrjV9dlgZ5hA9cfopHa8W+M5PyEU5RVGoQ6gr//Ez5KNW1rMeLtKa7mjtJWk20jnZCCJVyAICRWBgvYkKwr7m2yJaQhlppsdmE75vEh2Waue6KuSzEHuHxNTvuYXhBnRhfoimhBYRxL7WylJitjEPJ2xY1lfbjdYqrzgEk7Z8C2s8n2Nh+bTSix9BCjgr5Dc9TA79GKndqCmfZ67NqvjZoBHaIIKi9DxCXFs0y3UXx87IaarfSipb1Dk9qnfEN+aJWAu4txpSW0QK8aNmUfSrP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/05/26 00:17, Uladzislau Rezki wrote:
> Maybe we should consider Fujunjie approach and borrow his idea to shrink VA also?
> In that case, we do not need to switch to vm->nr_pages? And we do not
> need
> 
> [PATCH v12 3/5] mm/vmalloc: use physical page count in vread_iter()
> 
> ?
> 
> --
> Uladzislau Rezki
I didn't want to change the va in this patch series and wanted to keep
it simple.
If we change the va, we will also need to rebalance the rb tree.
I can work on a followup patch series if VA space pressure is critical.

