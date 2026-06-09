Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252F3CD98C8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177B56B0098; Tue,  9 Jun 2026 11:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137586B0099; Tue,  9 Jun 2026 11:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA276B009B; Tue,  9 Jun 2026 11:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B85AF6B0098
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:55:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DA411206A6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:55:27 +0000 (UTC)
X-FDA: 84860823894.07.BEE5B0E
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3B22B140003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:55:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ay5Ciskt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781020525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVW8qj71/+Q1WHcblQi3iYQw2OS0VBC9fdNyR+PSVz4=;
	b=A1poCQ5X3zxK9IbDNvmBMZ3mCV+tZffCvSffMsUUj86JBnZMmjzVh9wrVjRNh9Mh5A7/Qf
	Ig+JN+txuGZ77uCs/jB6h7RFCWO3FjN3a6ZXzLx2tAYXhFowkNrwsIlYhEAAhibZoGMm2i
	dz/GymqYA4z+b7aRcFP/2JPOFWgyeGI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ay5Ciskt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781020525;
	b=agxrNWefoiVMiKSMkzDRnkTUlS4FthfnFhmQaiSwfIK+PR7vXmSqgUef+zOvomTMmMX8pm
	wOA7KVewpplZyoM8YAFYoI29O/OJL/r8qUwgbC0fuRo24CPaVMLTqcxU96G8Hfdw7ykjVj
	CCewXeIp58yAfkQyC5hkTuBQzcDfdHM=
Message-ID: <fda62f90-2c8c-48ec-88ae-310bb5adaa37@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781020523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVW8qj71/+Q1WHcblQi3iYQw2OS0VBC9fdNyR+PSVz4=;
	b=ay5CisktjARNBPfV8OacmD2GFWycwxxTEJdtdfuqjaIIwfUgr3EaK0yVRNBZ+tqLXll7V+
	YiM/Blhyx/Iu3sztfNBbyInOJJZtNmlMBDePIfYFt18G5wQTBVFPaVK7TG7wyN4vicbqfx
	BPsr8vEC2gezI98cRBos8x+2PouCE2M=
Date: Tue, 9 Jun 2026 16:55:03 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in
 handle_bounds_compressed_page()
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260608210618.3437216-3-willy@infradead.org>
 <20260609131724.3114804-1-usama.arif@linux.dev>
 <aigkhkcXuQx7yfPu@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aigkhkcXuQx7yfPu@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8dxt7nttqmaxemzj41f45steg5i8ekcu
X-Rspamd-Queue-Id: 3B22B140003
X-HE-Tag: 1781020525-80656
X-HE-Meta: U2FsdGVkX195bHJBnAy+mdGaGtFwftPwlg4ym1K19GMfQDZOaAqEKi3hMSG7hRrG6EZ71rmb0nc+JBxCTcb2l0r10tcnAusUFEA5AYyO8e2i3qL7//dFSsIY/eCvbTQMmcj5XhhLoFl/gtfRwlUUEsk+XjqfaEMvSkJbpMQg+5BiUtacwzMN7wFoOUiVFOqPwH7nQEZEStVSQNBBtbpxA8RzWx1dcF9+2ZTsRbJ991uho3zPcU2ycHE1+81qQ2uTfpqo2x5bsI6Wdb5LITgzBQ0V/G0/zlSJiqiSHoB5ugBP6CKuUfsdGx10yO4BLj3cC1cg8VQwPuiTPvs7b+07uUEkK/fuxGzug64qWWkwYUghXxcObjMw2NQDzi/jCtHI+ojWxDGUSLLnXvODL3kCDtxmcTcm3Chx2Gbiz52kO/Td3aI6lgii5VuXNGDma/nYtSP6xlS1WP+OD+vJEBRLi9JHqdB7aqRL1+7KN8jdQFzqdHs92TNufiNduqcNoM7SmFcYZSAkqQ8QpWBOhrDm8e5qrGDsDAQwNDglU08z7XLHZfDZEt1pN1jWKbiR/UJ+ImDNKOMXMm4P6HRxxwVYsVLCMOofq8iwaMCmn/2R/IxrT1A4PSOg8sIX0ZeVeGZGppYZIAVWSRjHVfdqxgFiVBd5bFkmWKtlRv65U9iv+bqaYfWSLhapYYXkYrh/IXVDiYPHQhTQ89dZuYwX2eNJxHOsPy4IfJXn+OMkdIcXBk0I8VeuCrhfqt9q2d0JJ3Vkwri2gISWqyMw/ZA03KMvPCkXQkdHViI0lT8RmahQXKYDns6YTFb5TFAYt3o3HcvSx/tz4l4aOMa1iuBsEuoDR9xyDjcaEJIPUJclm6r/Vr4iJEhDu6+f/ZqO9h1DtTdSh6bJjdjEgqtDGFackms1TUtIZb1eDKl3iBjeOu7KelIe2Rz70Ae6MFjy40OZQpkH0TIKrY3ur+sJdot8nTp
 4PZId9zL
 FdN6buybznlKMnQlLcuYM+ZV37dxzJENLckqX9uxA98KJX8+FZYpEMy00G4UwJKZF7aje23zN/48l9MXTajqUQ7Llx3j+pVGNNYo8tvWhT2RJ9ji2SwlcKjZsxamI7JmUSRwnE3iHVaCT9s3irg9JkNDRzad86gnoimEkvCzX6QJs7ulij28IQw/vyIHY2LceGLcjenRGZ7ZnD6zlKC8ksQnE+gTF+f+NIZQXcoXnQPis/sjoDrEpA8XvMgnwJ4wzMVyp2Pwula36NmvtdjC4ecV1maXf5t07SicveGAxIZKFkICVWuCFZXCHgTV0lpXaMs+V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/06/2026 15:34, Matthew Wilcox wrote:
> [Editing your response to patch 3 into here]
> 
> On Tue, Jun 09, 2026 at 06:17:23AM -0700, Usama Arif wrote:
>> On Mon,  8 Jun 2026 22:06:12 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:
>>
>>> Nobody is supposed to use page->__folio_index.  Use page_offset()
>>> instead, and simplify by working exclusively in loff_t instead of mixing
>>> up loff_t and pgoff_t.
>>>
>>> Signed-off-by: Mattinnhew Wilcox (Oracle) <willy@infradead.org>
>>> ---
>>>  fs/ntfs/compress.c | 7 ++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
>>> index c904858dff3d..b279f38636d6 100644
>>> --- a/fs/ntfs/compress.c
>>> +++ b/fs/ntfs/compress.c
>>> @@ -105,13 +105,14 @@ void free_compression_buffers(void)
>>>  static inline void handle_bounds_compressed_page(struct page *page,
>>>  		const loff_t i_size, const s64 initialized_size)
>>>  {
>>> -	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
>>> -			(initialized_size < i_size)) {
>>> +	loff_t pos = page_offset(page);
>>> +
>>> +	if ((pos >= initialized_size) && (initialized_size < i_size)) {
>>>  		u8 *kp = page_address(page);
>>>  		unsigned int kp_ofs;
>>>  
>>>  		ntfs_debug("Zeroing page region outside initialized size.");
>>> -		if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
>>> +		if (pos >= initialized_size) {
>>
>> Is the else branch over here unreacheable as the outer if statement
>> already had if ((pos >= initialized_size) &&...
> 
> Are you saying my transformation is non-equivalent (and I have
> introduced a bug), or are you noting that this is a pre-existing bug?
> 
> If the latter, is the error that the else branch exists, or did the
> author intend to write a different test?

The transformation is non-equivalent.

The original code's outer and inner tests are not the same test.
outer: page->__folio_index >= (initialized_size >> PAGE_SHIFT)
inner: page->__folio_index << PAGE_SHIFT

These differ when initialized_size is not page aligned, because the
outer right-hand side floors and the inner left-hand side doesn't.

After your patch, both the outer test and inner test is:
pos >= initialized_size

I think the fix to make it equivaltent is to relax the outer test
so that it includes PAGE_SIZE (maybe?). i.e. make your outer if
statement to be the below to make it equivalent?

if ((pos + PAGE_SIZE > initialized_size) && (initialized_size < i_size)) {

And then the else branch in your code should hopefully make sense.

