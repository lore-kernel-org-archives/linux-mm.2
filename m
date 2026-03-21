Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13BD9109449D
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 23:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5996B00AA; Sat, 21 Mar 2026 19:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A863A6B00AB; Sat, 21 Mar 2026 19:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C076B00AE; Sat, 21 Mar 2026 19:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85BA26B00AA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 19:52:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1EB513A873
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 23:52:25 +0000 (UTC)
X-FDA: 84571721850.29.9FB0103
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1D15140007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 23:52:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hLAFSsfF;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774137144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8Fl1QseR6wb1rTmnSQ7PLssTIc8A2qrS1/n843CYrU=;
	b=YoEg/OyQ5HVMYgAO12Itrzu1TeEyEDYCk5uZJ+alskFS3eoRkCixR24pti06PzRWgZJ9nj
	017/UdZZMFyZRFktzv9LJnjL7ijqdWOfO79vjsQQhMgUSWfvTBhm8gPqhLI+UdUdG1YlME
	EkQmlLId+rxu6qlqsX8v5JSPZ6Afcbo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hLAFSsfF;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774137144; a=rsa-sha256;
	cv=none;
	b=woTqPnjg0qk50uhSip1g9DpWUgmHo/WJEkMtqj3jRIdNnpqmOv5kct2UtECFr+emMzBWPI
	G4D8u8ohFi0SF8HeLPR4U4/+EiZp1o6aqz7bv+lJZYe+GXFkfVV7YSgYqaIZ3SSZScAxq7
	/1ogCXiGBrHBWq5ENHehaPoHS+/Bu6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0909403C6;
	Sat, 21 Mar 2026 23:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496E9C19421;
	Sat, 21 Mar 2026 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774137142;
	bh=limyzeSGPQBoqFrfpinhHaeaEoGt2Vtq+hoBc32Rb3Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hLAFSsfFLYPGP9C1a8bGdVYK1ZxGc3e0S5Ot8nswfkRCBao4QJOoG8pFKcMq1nBoB
	 Bw9iFPfMR6zQmnj0On3/IcAWYVjkcRv7HdQQDIW2LQSmGEX6wEKRqpzkK2pS0cQ46z
	 t6ZqbbyQHozJtsc+UdXa+71x73+D2qATAlJp2hto=
Date: Sat, 21 Mar 2026 16:52:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shivamkalra98@zohomail.in
Cc: Shivam Kalra via B4 Relay
 <devnull+shivamkalra98.zohomail.in@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alice
 Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v6 0/6] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-Id: <20260321165221.d33f56b82dd78b1a119a9c0e@linux-foundation.org>
In-Reply-To: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
References: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D15140007
X-Stat-Signature: w51pebxwdpoyb14jttp8kqpfmn5f185w
X-Rspam-User: 
X-HE-Tag: 1774137143-309563
X-HE-Meta: U2FsdGVkX1+qxzndx1pGEo+f7NPNeNOOcXV+6t0e+PogzqRG7o5QmO+2eoDi2wf9cfy399o388UH/kklz5iL8UFCcojMK02jNy4BM9NqF7jQiYPdOIeJkgEdj9GinCaZqMEL84ecvFVxC6SG5+88O+FAXllfAhnKfft2jV3pdmhB9xPsGCToIDWPCz88YCg+2+3zSDpTMyvrIVg+sbIqBMSx+qGqMB9Q1jrI0toMwAu3qUnUbQnkBYfS5TeJGTwegl9BUlOZu1Uhvot1nJTyH4IjuJFESqihnojJ8hA+Xnw5rucErRyEjcdbHxcx2An1bd+DKmmNlo/TK7c4i3mlI3pARhAFmE1WLIefwR0vQr+JGwGw/YE5nkA7TDuBx2v6t/EcSZxoMZubBH5OY4ffdX+O858dZWb9REaoOZKRBKMGGK3QvoeR/GKfW3Eo/8suKdEJ6eOy5cP3EJOD7Umjji7yrdoCwn5SRShBOk3HcA7iEDjQj/Knb3F9qtp+kDIzAgzHoMfQb+bPKrFj8woFUFl6H7zj74SdahpP34mxoE52lpx0tiY6H17PKWubaAJ6XY3FFVlOeUS8+IcOfJ/q5caPpy46LbvrsTNFZjblJXPuz7oGzo1EJjUslocRzGWvJGr78eZDoDYQbyYGoTVy2gLmrZISg8pFz+1Fh8Xpu3h95zfljcyrdYoNfh8LBsIAgT21UEbvqdcYyBPRTOpV3hUpvNYuw8ESdZrJ8f/Mu46vWM6obX6FZ8NiFaxFk37QHjHmWt0GGmfp1ZGPUKsYF1dpx2onCFYwS/OePBSlQn22hTGTueadp6COD3uRFv3mBVqf40IgkCEEQnLRNeyVR32R2yajcmCBfD3BE/MPpMoRdLf1X5O49M35vyhRqv/x+1R0aiVOPNjD7RsJf7gBVGhU25647ZiBF9plDUGye7EoibRC/9lprQQZP64ZxotLAmBwvR74y4P0DBYfIRg
 /L1xANiL
 n5dKkz7LRwNG11cla7VwZXc2eKRDukoXgJ1DUp+a6TnTh/FxM/ea2ge0221hux484zI2UzJy02NEEaYgMqex9FlHWV0CJkJRsGgcZa8Vo8kEHxBMqRwnrdOz3VhYpMVJB6YFPhPpcRadgZcoyA2Wh2WXB047+Ok6zxnDWT/mvDlIEP/5sTlaLdGMSAEBoiOd5v9uV33NJsqnTnIVt3Kr/yGx9tEuBUEVzMGJmrMJpEj0azktwiSF0Ipvxi/RkrxnjcNFhsn9aMoKdkQwcsS8WZ47CB0f8KeNQJCWSTXNQNWVzEACBFv117W51XCHjRGwItAJM7ThhRMBPjNOuv0SkvDr5cXL/0ankQCVqJEmNLu7p6Ea01G38RKOg9dy++8ga0TcrZefe16RzZHV2sOdT9GfaE04HH64cggEhdb32EXfF55Gojm7SpjcewQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 23:35:45 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:

> This series implements the TODO in vrealloc() to unmap and free unused
> pages when shrinking across a page boundary.

AI review claims to have found several issues:
	https://sashiko.dev/#/patchset/20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in

