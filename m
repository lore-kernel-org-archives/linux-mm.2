Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABA7FAD3EF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4756B008A; Wed, 22 Apr 2026 22:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17EAB6B008C; Wed, 22 Apr 2026 22:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045B26B0092; Wed, 22 Apr 2026 22:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8D106B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:37:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86BBC1C0247
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:37:45 +0000 (UTC)
X-FDA: 84688260090.11.6FFCEC4
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id 99C0220010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:37:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gxpqvqGO;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776911863; a=rsa-sha256;
	cv=none;
	b=pRgkyA2Z1Yi9b+RtODrExi560tIkXe79BOW0XTTHUgKxMMj4eucxvke34NQ5mL33myBbaw
	xJMtVHyWMkMrbphXiYrtELu0+PDprInCaf5TdsJJ/5k6QQ+3+Bk9R/SYoJI2+svHhq73v/
	paSoVLOVwRp4RQXqV1x4sMGgRFPcnII=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gxpqvqGO;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776911863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmDiF8YpdHuzHjKufxDweaNIBD9kEOy5KYDQCBH6Ybs=;
	b=YU18P7Nvv2RKOSVq6qQiNQyKRLw5SuqoUNc3836Pf0YugCMYanfxoV+ejJLChIRktqak+K
	ad3ibkkwwW3wYY5piG23teaKi6tNxvB+brJgc/8lucJLgIG7FFGNWFHclikQlpiOym7QJw
	Lun3k1V6J6nnDQWpmfUe2fh0hD39Bvk=
Date: Thu, 23 Apr 2026 10:37:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776911859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmDiF8YpdHuzHjKufxDweaNIBD9kEOy5KYDQCBH6Ybs=;
	b=gxpqvqGObABR3XmALkCVtRl60wpafyapcdgXLHER2+3286Xx8nYEp1Wk+JCN57xjytirSM
	QQIoOX3NkhT9Evh5vmtNQuEHQR0nJ4eBq6Q/OJnI89OkRGh94rB+izVxggdc3X/BDfGDsc
	Jf2brEyoTbedxo1F2P6ZJoVanRRGX00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Chris Li <chrisl@kernel.org>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, usama.arif@linux.dev, baohua@kernel.org,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aemF6D3Do9FQYUOF@MiWiFi-R3L-srv>
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
 <20260417033951.1111038-3-baoquan.he@linux.dev>
 <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
 <aego1T9d6PVudYqj@MiWiFi-R3L-srv>
 <CACePvbVHgry4oeXeouML1YNscpuMNSXSnBY9wd-McDUar4tG1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVHgry4oeXeouML1YNscpuMNSXSnBY9wd-McDUar4tG1Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 99C0220010
X-Stat-Signature: isgkjdowdwgi6br976j7a9zpf9nsoyos
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776911863-188838
X-HE-Meta: U2FsdGVkX1/sDfSEn/FkDTf+t0PuB4UZNvV1y0SyORnlQ5BfERqLhWR04WaUOev2Dx8Gn+pYAOAfIMpxeEUusLUAEh/kOXyq8Vh9BiXPu1nAbWzwcX/7Uz/nWAjXCgjAZGqjR5pi9688wTQaeC/ZrsAc9WFN5xVbyPHUEYrevkGDRw9DCcyXu7JpI+3+28bGlLTukCbxskorIFOavJhJQaV6AWetwQ+TJclN/kzu3ZqjI91VuB1cG9a8tVC8J0Eg81TMoOg0e8fZv2pq5oA6zpT4RjLO2i9aGD5e/fpdX1RRJxNVPI4ruLW4u4jH8ZjRVzThe02sHNfJzD0Xvr6ViPRfP8JI14QfdvAE/VaPOI8AqyYzBFaUB2dNwMhFuQazOh3XJnplaXkTzbYpqueBZex7IYu7qAgSf5R2ENOTcoPTxqQ/HCYGOrTTd3YY4iLcch5CElyRxgxnniyrqyCadA7rNx10H1rlVuqaZDp05+3f/a4O8ZH5YH2ELHh9AJcKHalslzKwg3nMRH9CHk1XEtGZrdnvBek/UTsZ0WU+OKT07sneZ+jHLgYgv7hPfY3KZithLN4ZlWy9UoiUCdZZS7UqF67+TL/iOYNJh5VefHYRintTz6elxui7beQ+ba+cJQmJImHSoWgVZ8g8mUELz4I2VUDIxFL/bDymMWV4Kmbcf//I5E8jlX+8wR0Z8V34VT0kVsM/o4Im7WqT5wIG51L9WTFnXoc6oNS8+2EMcpjtQ7QfSlDtBKsBnPRkuM+aymk22DX4FnVX8XLe4PI6XrupDWouU5STbK+K5I8t4XTIe938bru2JX5FQP2qfR+LNJGw1sTOdqoyhd3cYZK7wRhR4RdbvgKLo8tMJb3Hf1NDdURV/dybUq0FKbC0iSFsU4JchcWdDrZtSXW0iezHVkfIRf4Q0O6mrG/vu84wU3kAtsUQmSv+jCMHm1yK0mo/9FEel8oVnzbGLOskiPn
 CEX0pkkP
 fLEvEQP5xMkzAwS1pk2rGCUVe00CjBgnpe/d6vpMZV61XIV3sQALisrV7fQ+yw/TUiaUznByHW32BrFB8zTnV5SQPyuaGrTgSOMQexZ+FIYS0MvQjZ+tlgKgLuMhFT6nK5SRSItY5Kg8v68TX/nTubATTHee7Ob/h6RKw+rqMZ0nZAR6uPY4LnSXllCN4eXh1WMOCATPKiqg/7jO0N/tlL7J3390B+KrXkkCSo+q8Z1JhBUqrYdybL3yWLurfa65kuxmWReQfS6+Sc8F2UOpXE8KqlcM4DhCOtb3ERbpZTnZ0q+XnVKM9BZOYM1lM6E3cVilM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/22/26 at 05:33pm, Chris Li wrote:
> On Tue, Apr 21, 2026 at 6:48 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 04/17/26 at 07:30pm, Chris Li wrote:
> > > On Thu, Apr 16, 2026 at 8:40 PM Baoquan He <baoquan.he@linux.dev> wrote:
> > ...snip...
> > > > +int init_swap_ops(struct swap_info_struct *sis)
> > > > +{
> > > > +       /*
> > > > +        * ->flags can be updated non-atomically, but that will
> > > > +        * never affect SWP_FS_OPS, so the data_race is safe.
> > > > +        */
> > > > +       if (data_race(sis->flags & SWP_FS_OPS))
> > > > +               sis->ops = &bdev_fs_swap_ops;
> > > > +       /*
> > > > +        * ->flags can be updated non-atomically, but that will
> > > > +        * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
> > > > +        */
> > > > +       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > > > +               sis->ops = &bdev_sync_swap_ops;
> > > > +       else
> > > > +               sis->ops = &bdev_async_swap_ops;
> > > > +
> > > > +       if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
> > > > +               return -1;
> > > Nitpick:
> > >
> > > For int type error return, you should use  -EINVAL or some thing with
> > > error code. If you don't care about error code, change the return type
> > > to bool instead.
> >
> > Thanks for careful reviewing, returning -EINVAL looks better, I will
> > change like that and repost.
> 
> You don't have to repost it as a new series. You can post one small
> incremental update for the -EINVAL change and ask Andrew to fold it
> in.
> 
> Hi Andrew,
> 
> I think this swap ops series can be merge to mm-unstable with the
> review. Keep in mind that Baoquan might have a very minor follow up
> patch relate to -EINAL error code.

The incremental update is as below. I have built and test it.

diff --git a/mm/swap_io.c b/mm/swap_io.c
index 77aa8373c087..e2710d5fb44e 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -625,7 +625,7 @@ int init_swap_ops(struct swap_info_struct *sis)
 		sis->ops = &bdev_async_swap_ops;
 
 	if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
-		return -1;
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index af81fa212f1e..7644049a0919 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3518,10 +3518,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
-	if (init_swap_ops(si)) {
-		error = -EINVAL;
+	if (error = init_swap_ops(si))
 		goto bad_swap_unlock_inode;
-	}
 
 	si->max = maxpages;
 	si->pages = maxpages - 1;

