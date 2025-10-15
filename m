Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4879ECCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 20:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84E268E0035; Wed, 15 Oct 2025 16:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825F58E0005; Wed, 15 Oct 2025 16:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7632A8E0035; Wed, 15 Oct 2025 16:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61A6D8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:09:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE0FC1602A7
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:09:05 +0000 (UTC)
X-FDA: 84001437450.02.1C3D6F8
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id 207CA10000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:09:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ER+FfBxf;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760558944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QE9+6/UqXy7fEFgnk3w2iHUsxl9kOSZaT4yz9NSkM4s=;
	b=p2UE8TsXR8SbC0KRy3TT4b0SloS94KaIuAs+lwZHErr7FvBXZULO7I9OG+liiVHxpEP155
	tBHpUYuStCuNyqvcC8v6f7Qo3A2QnlIlWEogX9Obx/8rhsjCRL9tEraKfvlFA6bXW6iRSZ
	2kIlV/4yuseqNjgfE8f0cOz5dPJ6554=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760558944; a=rsa-sha256;
	cv=none;
	b=hyyBye+sr/cQsj8eE3Z3p55Zn3ma06XTve/nQ6SMfZDR0+83sJYTKvlAOsh/3XcM+nZ/qI
	23UlIFjS2zEB90j1Y8piqTah3FSMnACXQqEpFGzfkpAOLn1FhPgS6qygxGeeZxW7RRAHD6
	mFE3mDy8vSKZcF0i9lUBg5X0DRApFHE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ER+FfBxf;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 69C46932EF;
	Wed, 15 Oct 2025 20:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1760558942;
	bh=QE9+6/UqXy7fEFgnk3w2iHUsxl9kOSZaT4yz9NSkM4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ER+FfBxfjxx+qQF+sKdm5eOSvgvyKc/qweUgWMKkQV4OH4mCoyHiQTcSxNfC7POen
	 iTn1wloJ0iGmGu3mujVFGrzAj9aI1UVzaFZ0eTwlr2l42+w4wqmN0M7M84cqeZWUPq
	 JEsfeT0drWKpkCLAcWWWd4YKCh74AUmCEs9UNj+M=
Date: Wed, 15 Oct 2025 20:09:01 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	hughd@google.com, yangge1116@126.com, david@redhat.com
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
Message-ID: <aO__XXIJShKz3-Tn@shell.ilvokhin.com>
References: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
 <ltvv3v4vibvlglpch6urayotenavpzxc7klbcyowjb4wrv3e7z@pzovtvtbmnsp>
 <aOaoD0HQk7YPeLkE@shell.ilvokhin.com>
 <20251015125911.0f0ebf87b278324667c4dfc5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015125911.0f0ebf87b278324667c4dfc5@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 207CA10000A
X-Rspamd-Server: rspam02
X-Stat-Signature: da34fwowfztkan4gxbxp6xwm5ebuszrh
X-HE-Tag: 1760558943-283974
X-HE-Meta: U2FsdGVkX19nllnof/xizc+FVTfh5nvNhzIARAstTTUGEL/jDIhg9Z1VwdQJlPOjyYaGBcgk22CcJTb4mGP1jpSbWhOSZjxzyQRyoWGJWSG1WQY7DjEM4ABiL7IK+78oMBQHo6HYeTh2yg2LSyWlPWbLSbKh+kXpZsEGwljlKl5ZUVcgI1nuzzo481C/ZdOM1X0xqVMWCsY7Jhqh1rTkbZO1bnoawNNwVc56puT7c0iidHiYLM1HkGC2nJLEcx2F6Ef0Vh0W5dKcWYdtL8Ut2hLgAVEp2jqtP7lJHlgj8eeEITfIpuf05QMwZq+cioggkI4WejU/3DsMHkew/asRffOChUhbai/TXdZkcrkMg6CZG+dPLu6Fl/ja1UwOj/OMKkz8JW67heb6qL5gVDx/+Dd6YoQTx6HiaLFfLYYYjcYa9kudbjF0bXZzrDoHCh7TSsT4iC5BpkXRv8aJ8U+hEIdQ6zViMh1g6gZhagUgdktDx0QzLK4d66X6Kwt3+h/hp35ythDYHCpW7ydnH2giZJD9+M5vMyYsjNThmlwWJY8Mbxcm5T/629lxQLdwhC+xx0DGwhioO4Fnougl7Mk5qaYo0o+XO7QdSocYtIpT0C6zSQV9dcMBjgZV/RynofpkRzRLDvYFzO7EZaEW0IO9HkbF/GWkC/YsRnd0iuwGeLXuDYWFqi4Atuil5AxWQVOVTKTOL0PM0ploYkWM3n2ZZJXEKvhVfL7AFZMNXf2hJQ4mj+j+NOYURQleGB1rwiniItqQY9FZH20ZcxIuxEhLaJ0jZ0XQPRgprD2VYf2mymca39hRNm0SuT2dBqHTjV206OP65C/PtyYFIq9u9FwxzBJJdNjymVc1UiQk9FHBkXNM/tIn9OxZ0xv20AwhK2h5Yzyf4UNjL6KenIiMbt3Od78jO9wsqucW6rDcBrLYDKOpVewuPnqSWNtwnZzYzCBnZMtuED/ejEkTaMzIFYi
 t7aVGnUP
 PJO4vlCAwGG/7G6b0+hFYhaV8hod0ExJ8WZjgFhIz+QXieKAOFSgTwrEz1MCOMR05V2RfVepvvQp6t+pR4bPleiv0bmEEJPxU0VIOqc30F31sYC3QJZgwPu3irxka/CvrbS0hdxVqG5YsPog71csYwho3lVp1l3ljR4PlhD0MBi4dYWrN9m1h/h0OvXTMTzLDjxquUw74dpta48sC2oeHx4FJh82kC6G8t6XLNEun7DFMJ/IUEjJhwLuuUqSUb6OdCYUcHmUv4QVgOwfzdWlkUDYDpW4/EtonNFl6QGLi4wkfB1qWw+Isg0JLkQ/rK8vRY08RhzVr0VoxMzDYg0e9Jax2B4JEZQ8sOHTTcdIPIph8rjoRY/S7b70q0ggsSfO0R35A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 12:59:11PM -0700, Andrew Morton wrote:
> On Wed, 8 Oct 2025 18:06:07 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > > > +		 * They might be still in mlock_fbatch waiting to be processed
> > > > +		 * and activating it here might interfere with
> > > > +		 * mlock_folio_batch(). __mlock_folio() will fail
> > > > +		 * folio_test_clear_lru() check and give up. It happens because
> > > > +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> > > > +		 * folio to activate batch.
> > > > +		 */
> > > 
> > > This makes sense as activating an mlocked folio should be a noop but I
> > > am wondering why we are seeing this now. By this, I mean mlock()ed
> > > memory being delayed to get to unevictable LRU. Also I remember Hugh
> > > recently [1] removed the difference betwen mlock percpu cache and other
> > > percpu caches of clearing LRU bit on entry. Does you repro work even
> > > with Hugh's changes or without it?
> > >
> > 
> > Thanks Shakeel for mentioning Hugh's patch, I was not aware of it.
> > Indeed, I could not reproduce problem on top of Hugh's patch anymore,
> > which totally make sense, because folio_test_clear_lru() is gone from
> > __folio_batch_add_and_move().
> > 
> > Now I wonder does folio_test_mlocked() check still make sense in the
> > current codebase?
> > 
> > > [1] https://lore.kernel.org/all/05905d7b-ed14-68b1-79d8-bdec30367eba@google.com/
> 
> So I take it that this patch ("mm: skip folio_activate() for mlocked
> folios") is no longer needed?

Yes, this is my understanding as well. Hugh's patch addressed initial
problem and this patch is no longer needed.

