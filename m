Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA5D1F8E4AD
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 06:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5D26B0095; Fri, 17 Apr 2026 02:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573B66B0096; Fri, 17 Apr 2026 02:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489426B0098; Fri, 17 Apr 2026 02:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 386B66B0095
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:24:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5AC31B9045
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:24:25 +0000 (UTC)
X-FDA: 84667058490.21.9F81001
Received: from mx.fmap.me (fmap.me [51.75.121.85])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8B61A0005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:24:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=fmap.me header.s=mail header.b=M6LzZe1i;
	dmarc=pass (policy=reject) header.from=fmap.me;
	spf=pass (imf25.hostedemail.com: domain of ab@fmap.me designates 51.75.121.85 as permitted sender) smtp.mailfrom=ab@fmap.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776407064; a=rsa-sha256;
	cv=none;
	b=vRpQ4g8C3T9TsGkQVdF3JAxsNgjXwz1mMgOIMsIfMRA98nagNwzy7Up6soC3Gcqq/JZmxp
	clJR7Oe+wJKz+2cpCzEI9cScujqOjy+d9iH86rKkCot5C1kLoldrpi32OvaFdGKxolDh09
	m59SyB9RRt0CydsRUjbSZNWGEVwehIM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=fmap.me header.s=mail header.b=M6LzZe1i;
	dmarc=pass (policy=reject) header.from=fmap.me;
	spf=pass (imf25.hostedemail.com: domain of ab@fmap.me designates 51.75.121.85 as permitted sender) smtp.mailfrom=ab@fmap.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776407064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvBM725pvZkYGHsMicUi69obsFFOz0wr4by+//XCUqM=;
	b=dIXobzaj8Cxk+LVnMfw6i2j++qAmiW0wCX3NTjCQKzA/MpqaZZ3X6l9uS2aBWOCoPXlxX9
	stKOVBVJOXfflWzDt2ti+fZde9XzA71ruCctt4JQ3fDYCfBYAzwZXJe0omAifV9EYOZbHb
	cJMI84fwaseKjJBdl5uGLV1m3FHkJ6Q=
Content-Type: multipart/alternative;
 boundary="------------S7egC2o6fx6v7bQu7uy3YITQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fmap.me; s=mail;
	t=1776407061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RvBM725pvZkYGHsMicUi69obsFFOz0wr4by+//XCUqM=;
	b=M6LzZe1iQxPksIBf/ww99yiB6SWjhIGQ96xDOvwOlUjhQV7KKDBhRi+CJSuQyNv6MnoeOh
	B8q6U6H1MaZLf38zhF+eVpAq8RkMtGOQLktLSjVj1JNyoLbL0Nkr6ksjnxMbhzGHz8W7oo
	BHXziNF7m8AG1PCYn/oYqjiV6do2W0g=
Message-ID: <800fa535-da92-41c0-bea9-40ee27639502@fmap.me>
Date: Fri, 17 Apr 2026 13:24:16 +0700
MIME-Version: 1.0
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
To: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, fuse-devel@lists.linux.dev,
 linux-mm <linux-mm@kvack.org>
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me>
 <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
 <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
 <aeFuarTL7xBbut0F@casper.infradead.org>
Content-Language: en-US
From: Nikolay Amiantov <ab@fmap.me>
In-Reply-To: <aeFuarTL7xBbut0F@casper.infradead.org>
X-Rspamd-Queue-Id: E8B61A0005
X-Rspamd-Server: rspam12
X-Stat-Signature: jtjutwd46zddgs9z7txcwrzb3946z139
X-Rspam-User: 
X-HE-Tag: 1776407063-713449
X-HE-Meta: U2FsdGVkX18c67A8DONz5d3xBp0v3aT/sdLSaSfvrjMJ1669SSOXc+Nr6gp/jQUeMSvGiTAjq+emsDLPDh8W43ogpmAqHYo9JQz6AZsK6RnnRIAcl6On/eikOOEGjZRMf5ou7st5QUY9OMjcJDmVqTZalrTHIoSrZcx8Iyu3bhaTrzzgENP9//6V3BJeRDfGX7HawfBSCWwhuDF8lbKO4D2H1whU6uy3DYxJQAqn60ormJLuIMf1lJyPi30zGj5XAO98ixXoNtTMxHKm2tzALu9/EjRf51vTsrS4/w0CiW///uECM6oGQzeScTTYS83FFD+CzYBtWwci0lDYbdD6+b6E1dDGtsKddemFR+/rqwjS/46ztu6CSy3Ato0uzW6dimNT5/fikU//gVv15uh4r6rC4kqJSa9V0jsd4RqcsrPklLiKXNQTd+ZNHWFLMbO6mZ7z3aUpDZVKhrmaoGQokVE1v1fXxZ8E0vtOt8bQ3s9DWtL1fLHJjUr3PSRYr2JLEuRnU8SPc1yX7N82QvcKVPj9WnvC/D4xuoiAwJxmn3aMJUS5s1YPMzGIm2nP9X7geeQpuwlkMnR3ykMBNvrpDAMehox2mHlS3HJyd+TThk2KFWIwkv4XAI2MoPXJlVbb9dut7Iq8T7LeaffF1dlcdF+2oDfdy5nO4GeNBo16QbWPQVwPuAkk3aW6+DIkQEhGVLIDyNv/aFhgCSg0b3XVrjIHw4G90kTj0XEsCUluI7YErNCEYtWpNTrEbhC6HvJ8tm8rhD7F2cybcK1G9Qmf5JVS4f7MBw8sJNjMHoAStZLvmW/pUl+Dcj1oRv9MbC+snUBvHugJp44VEy/nuiF9gFFUgF5TNcOX4fuW/H81PFMOqlQsuJROSCwXOKKPRv5YNrnV0MuisXEy2JG5dNQGWJGyqoPJ8DKDOQgew1AkXM0ZZHvmExl1nizoABEAr6Dn41ZIE7JmPT3DcKTzLRb
 7m6oEqiu
 Z4ihjwTe3n2hEPMIR7SxFb176nmOzR9/IA2kPVIrdGxXzkNHcgRDYtCQzNvK/aU35AVcyMJvbZF/AjZlTArIkwnwSKUH06mYayqmyV6dqAO3usZSvGv6yNHpecQvCTMRORBAjoTcalQzGSHFcMxdIoixubgjALIEHt12SS8grjlltiAFFq4+8J9ih8C5qdBDTEIUFD6aaizTMrFfE4TQWWa0yC8MugGwCwtGsJHndA4zypZXDqBv8wyBI/fE3mRsQFE2g2k+0/3pKGK0Yfsb+GPtvyuGHJKGGLmTbMub/di55MwCioxk9wIJHog0/VgALBviixpy3XIaZ0TPnM38yCWHlKCajOmdRidbOQD8Ky/vzGJ9eXsGMt+TX8cGOW7aSwXk0l8PqHPPekQ/9Jgy40nqF5X3WcURoSHZJ0dzsiY4z0kk8pd3oY4r19WkawGgG0I5gluNs3t8u7dEnWQ24+8kJMFnEyuH/b/nv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------S7egC2o6fx6v7bQu7uy3YITQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/17/26 06:19, Matthew Wilcox wrote:
> Yes, at this point, you've left the folio in an error state.  I'm sure you
> didn't mean to do that, but the VFS interprets unlocked && !uptodate as
> "an error happened" (there is a minor exception to this involving failed
> readahead, but let's set that aside).

Thanks, I see!

To save my reasoning somewhere: another way to do this would be 
NFS/CIFS-style, in a lazy way. They set a flag in `getattr` and 
invalidate later in `read()` instead. This could avoid relocking the 
spinlock; I still opted for invalidating inside `getattr` though since 
FUSE already has invalidation later in the same call, and the cost of 
relocking feels low to me in this case.

Any ideas on how to resolve the remaining race condition [1]? If I'm 
correct it affects any network FS, and can't be fixed without changing 
the common VFS code somehow. I'd like someone to confirm my conclusions 
though.

I'm way over my head here though willing to learn; if someone is willing 
to mentor me on designing the fix, I'd be happy to. My best uneducated 
guess is to introduce another flag for a page and check it *after* we 
get the inode size in `filemap_read()`; if it's set, retry reading.

1: https://github.com/abbradar/nfs_stale_cache_test

--------------S7egC2o6fx6v7bQu7uy3YITQ
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 4/17/26 06:19, Matthew Wilcox wrote:<span
      style="white-space: pre-wrap">
</span></div>
    <blockquote type="cite"
      cite="mid:aeFuarTL7xBbut0F@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">Yes, at this point, you've left the folio in an error state.  I'm sure you
didn't mean to do that, but the VFS interprets unlocked &amp;&amp; !uptodate as
"an error happened" (there is a minor exception to this involving failed
readahead, but let's set that aside).</pre>
    </blockquote>
    <p>Thanks, I see!</p>
    <p>To save my reasoning somewhere: another way to do this would be
      NFS/CIFS-style, in a lazy way. They set a flag in `getattr` and
      invalidate later in `read()` instead. This could avoid relocking
      the spinlock; I still opted for invalidating inside `getattr`
      though since FUSE already has invalidation later in the same call,
      and the cost of relocking feels low to me in this case.</p>
    <p>Any ideas on how to resolve the remaining race condition [1]? If
      I'm correct it affects any network FS, and can't be fixed without
      changing the common VFS code somehow. I'd like someone to confirm
      my conclusions though.</p>
    <p>I'm way over my head here though willing to learn; if someone is
      willing to mentor me on designing the fix, I'd be happy to. My
      best uneducated guess is to introduce another flag for a page and
      check it *after* we get the inode size in `filemap_read()`; if
      it's set, retry reading.</p>
    <p>1: <a class="moz-txt-link-freetext" href="https://github.com/abbradar/nfs_stale_cache_test">https://github.com/abbradar/nfs_stale_cache_test</a></p>
  </body>
</html>

--------------S7egC2o6fx6v7bQu7uy3YITQ--

