Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF793CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 02:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2742A280007; Thu, 21 Aug 2025 22:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E878E0056; Thu, 21 Aug 2025 22:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CF9280007; Thu, 21 Aug 2025 22:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F06988E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:01:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C5B81A0619
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:01:34 +0000 (UTC)
X-FDA: 83802741708.12.C7EC48E
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf20.hostedemail.com (Postfix) with ESMTP id DEDB01C0005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:01:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755828092; a=rsa-sha256;
	cv=none;
	b=WuAL4+SfAf2W3sLd57FQR0rMsjocZsO+ggAVeGT16s1Gxad0JrE9sOtqepS+2HxjP9RgRz
	4MlsGqagWeQH1yHvafm7j+T9rfzf+08Cug/BBS1iaHNtbZiTpIw9U1OFVS6IXXK9L4milK
	2yHQDMatW2sCP6VVz9iHpypS5AC0qM8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755828092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IdLWXeDWl9pCD5D4sY9b3UoHjcmQ5mBfOjHUzl63O/A=;
	b=iYPEQ54EPHbni6bRHfku1AK5K7eCUDN/UHp0WS/z1iv9ozAQs6qasoAlBuBAoDaSIgbM+T
	R5NKSgzNUjEjUJX8CuT+w2zY8xpszARnZaiq1RTapBVCTHQ8LDxT1z7y7AJVyAX3M9RDjS
	l7Fyr5Bk9POVYvFAAGIbWBAwnm05+5w=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7NdP1ZZbz1R8kT;
	Fri, 22 Aug 2025 09:58:33 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 083361A0188;
	Fri, 22 Aug 2025 10:01:27 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 10:01:26 +0800
Content-Type: multipart/alternative;
	boundary="------------vsv5Kpa9cMDEP2Z9L30niGRU"
Message-ID: <4bd32b35-f244-4f39-a009-38c028d86a06@huawei.com>
Date: Fri, 22 Aug 2025 10:01:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
To: Matthew Wilcox <willy@infradead.org>
CC: <fengwei.yin@intel.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
 <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
 <aKcU-fzxeW3xT5Wv@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aKcU-fzxeW3xT5Wv@casper.infradead.org>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DEDB01C0005
X-Stat-Signature: es5wo41m8s6ahsemqea3szctbr8jo8h8
X-HE-Tag: 1755828091-798254
X-HE-Meta: U2FsdGVkX19hyyRVo8dGY8A1kKHMOkk4UUPVpwvLYzOBx10sBQ2avUJpOrMI8seKj8MF82Xh8rrCpp1+nPVvWdt5IlmpB3pkEy7Y8VDpWUFpmiQmRwOlgc79+xEePPKJikIjfio9oDa1ItExg9UncwJtX82N6flBcuaoIMI87cL3CoKyEU8z/uk2bDVDwrYq+qEEKU5yd0Tvpu4nEw79/RlQV2DgbXmBRMGOXc0vbmJ3yWHXupeeg/514ArWvvbMBnjuIePDsyhVxWY7uXY84upXig4IE4lC9c/Fh25/DKKOhGjlXXpSGBek+vVffCdBOBs8tclAzM1oFG4aoUxXD+CaUbsxMLdwHHbagD6E0VUiHJn7J8qVpMbTasIf2vacQMJzBDjRT+TL+B+8bdK6B7kNy7JHALOV00aam6qzav/NoeWR/qhDSmZ0zAIKJh/xQxDiQRnD8Qw35bOMOUd/eo/XZKHQ7jMdJd5bhJSrONlqsGUhZn6Cvkd/w9cHEcZaIGmGltM0cCjyas0xj9z8ggtFzf1FikswuOAbtiEZI0dJOc5xRykTVyvKrsaG0hLjURwD1poMOC2atMLxRXiMblMh3G1oTKCdO/+LDzElNu+JQcD97k1ZCAF3qdoe7KWv3NWF6vaaDbqeWNHS1TExgUIGIlWtK9EDOloQ0OZKCokMaMm9CCQRpmU9kpxQuWWF+QZfOVQNBLJ50xAnCZj51tKWYvx28Px++iFdU5T5fknlvV68XW7FcwenV+RKNK/shozgZ2IGQlujBMZkTnL3qGLsLX3tv8Uw3ldXNPVPp05vFyg7traCqeITTJgWu5iZsJTVI4FMTiPWsMzWUIGAxk3rH7kiDfTuSvPDGQClzFNV40ix8kyXF+tTRhIpJ+f4qsYo2wATY+hyfSgghWKsvNUX153N/3xWa3TXZDQ6VPdqVBVHtLr+VlF+2z95a7mAP8catFoMV+WhnM23O0d
 Z3aTIuUO
 N8/WCZaqngxWto5682ANevP2eWjYK4RGb2yqv8wo8KegLx+oXvb7tZI1ALJCEMY79cd//yW+O2vOD2tSie9mytbMspuxkGQlVuF0C5JZt0/hbDHC38D7UpsGU03dbC0DjWvqLuVpbQQZc0Lzk/FIHkzL+x2Wy/d51vRnOCHpDtqNmgtUA3z3CvmRyslFNn/smGtRkgik9Qorp9CQ1Boby9csN+yRbXZReWOf1qlHgkEueXusEkNJVm0MvsGg2t40ag/ypOKUgppBXn3YveKD7fRtC3H5s8V0Eapz9Hefm2kMUGTNEm8K6vz2b0/AC2CefNay8Wq9mVGENAIPJVFe+TB4Onm9CsMVH2vfJsRqzCEQit73d+z6ZlrDfMLk+3vnewIt3XkPhzuUNProoomT6hNKNBoOQr7t4h6XF6eGyi5SZ8obzERjsBGHFruBVxFlYy49p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------vsv5Kpa9cMDEP2Z9L30niGRU
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/21 20:45, Matthew Wilcox 写道:
> On Thu, Aug 21, 2025 at 09:22:48AM +0800, Jinjiang Tu wrote:
>> 在 2025/8/20 20:42, Matthew Wilcox 写道:
>>> On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
>>>> We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
>>>> if we doesn't set folio into pte, we should unlock and put folio.
>>> I agree that folio_unlock() needs to be called before folio_put().
>>> What I don't understand is why we need to delay folio_unlock() until
>>> right before folio_put().  Can't we leave folio_unlock() where it
>>> currently is and only move the folio_put()?
>> In filemap_map_order0_folio(), assuming the page is hwpoisoned, we skip set_pte_range(),
>> the folio should be unlocked and put. If we only move folio_put() to filemap_map_order0_folio(),
>> the folio is unlocked when filemap_map_pages() doesn't hold any folio refcount.
> Oh, I see.  I misread your patch; sorry about that.
>
> However, it is still safe to move only the folio_put() and not move
> the folio_unlock()!  It's a little subtle, so I'll explain.
>
> We must not free a locked folio.  The page allocator has checks for this
> and will complain (assuming appropriate debug options are enabled).  So
> this sequence:
>
> 	folio_put(folio);
> 	folio_unlock(folio);
>
> is _generally_ unsafe because the folio_put() might be the last put of
> the refcount which will cause the folio to be freed.  However, if we know
> that the folio has a refcount > 1, it's safe because the folio_put()
> won't free the folio.  We do know that the folio has a refcount >1
> because it's in the page cache, which keeps a refcount on the folio.
> Since we have it locked, we know that truncation will wait for the unlock
> to happen, and truncation will be the last one to put the refcount.

Ah, I see. Thanks for explaining this.

The performance gain is from decreasing atomic operations of folio's refcount,
is irrelevant to folio_unlock() call. So maybe it's no need to introduce this sublte change?

--------------vsv5Kpa9cMDEP2Z9L30niGRU
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/8/21 20:45, Matthew Wilcox 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:aKcU-fzxeW3xT5Wv@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">On Thu, Aug 21, 2025 at 09:22:48AM +0800, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">在 2025/8/20 20:42, Matthew Wilcox 写道:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
if we doesn't set folio into pte, we should unlock and put folio.
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">I agree that folio_unlock() needs to be called before folio_put().
What I don't understand is why we need to delay folio_unlock() until
right before folio_put().  Can't we leave folio_unlock() where it
currently is and only move the folio_put()?
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
In filemap_map_order0_folio(), assuming the page is hwpoisoned, we skip set_pte_range(),
the folio should be unlocked and put. If we only move folio_put() to filemap_map_order0_folio(),
the folio is unlocked when filemap_map_pages() doesn't hold any folio refcount.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">Oh, I see.  I misread your patch; sorry about that.

However, it is still safe to move only the folio_put() and not move
the folio_unlock()!  It's a little subtle, so I'll explain.

We must not free a locked folio.  The page allocator has checks for this
and will complain (assuming appropriate debug options are enabled).  So
this sequence:

	folio_put(folio);
	folio_unlock(folio);

is _generally_ unsafe because the folio_put() might be the last put of
the refcount which will cause the folio to be freed.  However, if we know
that the folio has a refcount &gt; 1, it's safe because the folio_put()
won't free the folio.  We do know that the folio has a refcount &gt;1
because it's in the page cache, which keeps a refcount on the folio.
Since we have it locked, we know that truncation will wait for the unlock
to happen, and truncation will be the last one to put the refcount.
</pre>
    </blockquote>
    <pre>Ah, I see. Thanks for explaining this.

The performance gain is from decreasing atomic operations of folio's refcount,
is irrelevant to folio_unlock() call. So maybe it's no need to introduce this sublte change?</pre>
    <blockquote type="cite"
      cite="mid:aKcU-fzxeW3xT5Wv@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------vsv5Kpa9cMDEP2Z9L30niGRU--

