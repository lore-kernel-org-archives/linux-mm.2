Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3DCCD8CA8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 07:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1A666B0005; Sat, 13 Jun 2026 03:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB5A6B008A; Sat, 13 Jun 2026 03:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1056B008C; Sat, 13 Jun 2026 03:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99B8A6B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 03:06:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50E751C34D7
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 07:06:22 +0000 (UTC)
X-FDA: 84874005804.07.4EC2D49
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 50FCD120003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 07:06:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sbVKK8zI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781334380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pF1QptbT4ANn9dIzeaKLaJnMG/TsByf/t+R0Qjd78m0=;
	b=qrpC27/Uxe7HGchZHE8Hwde6ZYn8xtl8fimQ7TQnoV9YGKJIp4k2cV2juN4jlStT37FL53
	yiSvIQLFgAvb5FOHyf0qfGI7YNyUPXNFuXOPj2at4ptBlwMDKX8WJLAYKu+WF+GaMMGkub
	SticYgoPzsO8Ocb5xA8iEKlLzHFdyYk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sbVKK8zI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781334380;
	b=xCoTgQSiyy61XTC60TKSrlkP45WavwrF3teJbBNjbu6wmqT6bjYO0MIlBLUYLmrdiW869+
	537wVoSpQMRAUj1LEsbT2b022cS2MRQWVNKNp92Da8bBAh3gGyhoZ5mI+tSoZ1MkY3lI6b
	CJsft+RYDEIrxet+w4vaiPpSerUJQNc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781334378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pF1QptbT4ANn9dIzeaKLaJnMG/TsByf/t+R0Qjd78m0=;
	b=sbVKK8zIzOChSg5o22XKRCzvqn9ogGWt+uRgS7n7cGELmP4UVSHuxv546SKLCTu72hnLJx
	BdFQGAUCzrbf7mCfdmcX6+EWjYoMGuI1Eu2zr20m2G8J05zf15Q/5MGvAmaU8VbEB1M8Ix
	l4+fDxaTOXTLgZuqNSpnaKB45S7FJw8=
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev,
	willy@infradead.org
Cc: akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
Date: Sat, 13 Jun 2026 15:06:01 +0800
Message-Id: <20260613070601.90382-1-lance.yang@linux.dev>
In-Reply-To: <fda62f90-2c8c-48ec-88ae-310bb5adaa37@linux.dev>
References: <fda62f90-2c8c-48ec-88ae-310bb5adaa37@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 50FCD120003
X-Stat-Signature: 6xk18o537hskombq8epa3u8e5ejkzfdu
X-Rspam-User: 
X-HE-Tag: 1781334380-769027
X-HE-Meta: U2FsdGVkX1+bV+b+XzGvRMSlUO5gJUriVzbBR3J4DdYyATdpCxw7SyBYIFPUPyIXLldc6k3Jk8ZjgIn6nKzXe+amiiNOtJUM8R7pYEdJ4GkRgvOBvgwbI++EoI3UlCdnnmfoZ7saSIVOTCaT9LSbS05JvsruydHPzzjnBo+oRSdOWUwy7+fjCAwbxSuySMIrS5iknzST5rsk9Fu8E7xfTK2oZnURlYOdI1pIIGebTHR+hRC93hMSL0GSKt9HZ2Kg79nLMjXxdlR0t5bvQ6KRAjY9GjyeRuyFRn9tgBpXm/tVUmk9T/5sti1pm5ZedGokgMSg8YvUtZWPeirMDdY5RLfuuUWd10oXXgA0FasVoLkXYB5iSmJTRJmpRFlTcuavTMIjKOSeBouOw85qe2qEsb4Nz04xDckJBdSEtRGchzCo0kLBJLPU73Yh7/ZQiY13tPW1LTYNYGbzkYFifRomsVIZ+oVjOKRl0ceSWdot1/Muh/9lgN9sfTxKy3PIv/fX5mfWSl/JXQF2FcPG+nfjuiDWnkfQPJ+wdLAi/faSk8hrd6aeWRlBAWlJWZuy+nuvHqcGcNWpfatOv3QGmpfgOR+OZivH3Y4LM4iqVy2EXDZRvXXLOMZyzEcXzqO5uI5d8PfjGCMqgXti1S0vKdm/hCKRBiJI06kIWvQEhtS79hGzKVJ2z+JSqnKQD9/DrD5XxkQDHrNt8gOBUqSKG//6ysUtUFVQImqanaORBiHVCEO78KeFx1e9gfsTszOC/M9C2yPYr7M/Dys3OBlm4v5sXOFAuPDr20YSl3jVpo+6CJTVe6PX9mC24oWsMbZmtEY0Gtnubmri61nRlW97JP9vEs7gYcPzssEuikr3XchFZOsNO33QFFdiwtDu+GigzSWn5xVj5MhY8q4QCoIQxWI34sjl10GMSwiCs9vNFcdznzXfmVoMB3Z1+ADafDMJJIo3SQ8SjNyEM8l34U1xCfq
 XvSDJKJ6
 ofGwFoGCgFS20s2ewtcDLZj0+mfkgve5HnTvksd2FAl6fTXGHHXnwzbz0Wm6W6Dq7JQ6WALpKl8W8Q1GlSO3xru2oJJO/bP5WepT2d84i6IxoeLhmIx6Ehjs3wMmUA7wOOBjgHaUyb8HeucIb4nILN0C6mB3SXLSjBGlxXUjbQqWlFg1PJ7z9aG0vrf0vQLxNgHBC0T60WS3OhHmyAN3+lGuPak2kNSQ79Q/kR9R5TzXLk4wL3TOGeDATN9orzrbaF9Mb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 09, 2026 at 04:55:03PM +0100, Usama Arif wrote:
[...]
>> 
>> Are you saying my transformation is non-equivalent (and I have
>> introduced a bug), or are you noting that this is a pre-existing bug?
>> 
>> If the latter, is the error that the else branch exists, or did the
>> author intend to write a different test?
>
>The transformation is non-equivalent.

Right. Let me try to make one case easier to see.

Assume:

  PAGE_SIZE             = 4096
  page->__folio_index   = 2
  pos                   = 8192
  initialized_size      = 9000
  i_size                = 12000

Before the patch, the relevant code was:

	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
			(initialized_size < i_size)) {
[...]

		if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
			clear_page(kp);
			return;
		}
		kp_ofs = initialized_size & ~PAGE_MASK;
		memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
	}

For this page, the outer check was true:

  page->__folio_index >= (initialized_size >> PAGE_SHIFT)
  2 >= (9000 >> 12)
  2 >= 2

and initialized_size < i_size was also true:

  initialized_size < i_size
  9000 < 12000

but the inner check was false:

  ((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size
  (2 << 12) >= 9000
  8192 >= 9000

So the old code reached the tail-zeroing case:

  kp_ofs = 9000 & ~PAGE_MASK = 808

and zeroed page offset 808..4095, i.e. file offset 9000..12287.

After this patch, the outer check became:

loff_t pos = page_offset(page);

if ((pos >= initialized_size) && (initialized_size < i_size)) 

For the same page:

  pos >= initialized_size
  8192 >= 9000

so the first half of the outer check is false, and the block is skipped
entirely.

Cheers, Lance

