Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DBEC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5406B00B1; Mon,  6 Jul 2026 14:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56036B00B4; Mon,  6 Jul 2026 14:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44E06B00B5; Mon,  6 Jul 2026 14:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 960266B00B1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:17:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14E028B484
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:17:33 +0000 (UTC)
X-FDA: 84959159586.21.08CC66B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8CF9EC000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:17:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CNyUy7kr;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783361851;
	b=oHaP+NILAsjv80T05DXu1yPfZ42ebW6e4nR+YLhLBttc8tCD+9chg/PqpQyFqsWOHDv0Co
	ouJLnWhsUIKMFx4RN34rQmCui3QGrqjr3Dige7a+lExRXHOL/wQsSIcC//fRUE2boJnN3e
	aHqzwq70ZUi7s65U+8sftYDO1AVKMF4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CNyUy7kr;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783361851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OW/CenuU9P13pzjhjZutuMsDUz3ebL4YDkxxEUpTq8=;
	b=inAQrCGTNsQpy8hpzgz50fOTyo7SjywUS1fKVUIHkHSgceirlh1kZbroq9/Vokd4ata9NI
	wLky2H+VKedcSdaJH3g4JXRVUCCsXu2jEdlsDAkkJnG/ElU4REGEmGFn14NnQeqDxtILnx
	Lka589By+bl3tWzJ0lsyq60PLz8gZ68=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7OW/CenuU9P13pzjhjZutuMsDUz3ebL4YDkxxEUpTq8=; b=CNyUy7krT2KWgEwmWVKxtIQ+mF
	Vb+1q+gyB5yQGtWUUUTFfkVXSRepuw7fyFqIY66jb6ov+a2TSQuU6Oeko21f10IdvUo87ND796N2s
	r4dJq4T0v6JLzeGf9VmqXcqhhRS0zxb+AYnr/OkLGsRdGJ59LoP8x6HtyxyIaDGX/UNF4eV4mx/6j
	9DFL/3RA2rxLGItPLNRlN3OyyNrc4LrBZnn6Z3pAqvn4XXv6D9Sm5JmxAl/Nx6Vi/43ITWBd3Tatn
	UF0bFlXL9IwSqecAJqVY3MLm3w3NDEriZxsXwEytou0y28YZK6qZ/ZV3pvVIppH/oIVxHPm218vXX
	ibjZRXUw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgnhQ-0000000GLqy-1n2W;
	Mon, 06 Jul 2026 18:05:44 +0000
Date: Mon, 6 Jul 2026 19:05:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, will@kernel.org,
	tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
	sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com,
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
	david@fromorbit.com, amir73il@gmail.com, gregkh@linuxfoundation.org,
	kernel-team@lge.com, linux-mm@kvack.org, akpm@linux-foundation.org,
	mhocko@kernel.org, minchan@kernel.org, hannes@cmpxchg.org,
	vdavydov.dev@gmail.com, sj@kernel.org, jglisse@redhat.com,
	dennis@kernel.org, cl@linux.com, penberg@kernel.org,
	rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
	linux-block@vger.kernel.org, josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
	dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
	dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
	melissa.srw@gmail.com, hamohammed.sa@gmail.com,
	harry.yoo@oracle.com, chris.p.wilson@intel.com,
	gwan-gyeong.mun@intel.com, boqun.feng@gmail.com, longman@redhat.com,
	yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
	netdev@vger.kernel.org, matthew.brost@intel.com,
	her0gyugyu@gmail.com, corbet@lwn.net, catalin.marinas@arm.com,
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com, neilb@ownmail.net,
	bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
	alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
	lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
	tmgross@umich.edu, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 22/40] dept: track PG_locked with dept
Message-ID: <akvueAxPl8aoLvMR@casper.infradead.org>
References: <20260706061928.66713-1-byungchul@sk.com>
 <20260706061928.66713-23-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706061928.66713-23-byungchul@sk.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8CF9EC000C
X-Stat-Signature: 68s7f8m9n6bkc1bb9psj8b5f4gz93qqe
X-HE-Tag: 1783361850-39589
X-HE-Meta: U2FsdGVkX1+GNOAi8HF65xkmgsCvwDJMAH5IwjkGZHkBFOki0RLx51gN7WQbIwUQFuogM+hu87kQbnjBlO8A3hlTQTyOREFHm5EP9odX9jmzdDVp5UpkD6V1XVWT0sSNAt1Cpap1VcOYBszdDieRTklAuXWUAXziS/yUZTf3ExEsrDhx+LtjuXcNdI8+0Fnwdo63UR+5KkWr+2G3N4bfNi0BjtZ06ruJQ0tJQUWK9qnrpnL2chjS3Sy3O13qXZbdHncsMYN5Q0lw/ITlrtGEn1Yu7Rqf5O0/ZW8j5Xo2xiN/JuAs1WzBAGkxQq1FV5c/jo91G98B2NmjVAcJdWw8AyyijiMyg6uoC5t4VHLhSQYhps9puz70PDST+sMZjcwz00IXgXU5dPuZ8xKl04nTG5fnrnPKafLAW/QZPysU/tkhiy1fEXO4IKSJB3Q9Dlq6M8zrnmkr5JbvL/YtFQa6kiQatl3yn2jAsqClAYyaBqjaJpzxda76e70D09lo9D2f9AG+nqKD+O0ucsfkQn7NJX8KQ7R17z5NTt2Fj5FPoYXoORGego4l1tOi6yBPo4hjtVS4xbDnSEKaIfsRU5MzwOcBI070E4ZXV7ft6UW0Lk+RfUnQ0JpyVmN9nj2FY2NEqGlhJ56jCk1yoB7Czwqs9++rKym4rQUiNqMGsfo9DjlFpewp/S8kWX8vY1J9WTF7/1rfzOGfPNz4fOPjiqzrbIeh9e6LqC+17XwH3PN4G76imF+ur5IjfTY5wmSkdJxEFgbn4Q822GWzzpCLO46Yhxvs7hyfaaWCswQ1RQXLGnpyWHBpr5s7/AyYI223al01pXinnGSZFKU6swBIsiwPZMkaq+U7PLz3bm6r1/kS1+zMI+cgKzBXohbbxf7VsiJhMu/wD3cci6sUV5ZdCD2aCsD+rtl4sCRrsBWQtn9caEZrP1EU++snDaOr5wYfV9J+jD4t1DCn2QO1HrV5uW5
 kvuYpxNw
 z6Fp9WMounQgqN+oTwbkuCbXuym/jQ8O38/29YYl5Ra67IH2+jQOcZsWSoA6OLkgBOYs+I10/aOfo0CxeJkYofw0vC5Y4zRGtuQ36yTnhHQtHOqsbImpqU/OFmYPK5bJQDAuwpJOz73xAOzPsMdrDlfDTqegkdfo6r00dmv9WkrxFCUHInWeti9lgNF7e97InB66Aol/6nrwT4kaymjaA1dm0WetuZFaNCPlRtPtUVIV5Dx1yEGHd+CDI6R3XcHvCZAqNewtB2M+WPEmtdB/BiHRDF/gv5Ic6pq+oKS81oXI31ZgUIbhn9rairr+RJdJ0E0nsqxeBmysnZsFroy7mcLwEYulppsO3hY2Kj6DpoBuqphXGOE9SMxOsNghnTnAsBAAQwiJrQSqCHTvASyLfIG8/P6duI/CJq0sbs1fwHkS5jqiLF5TMzcZuKJgVQI8UUdBYEmRkKOGSWEnauSsNf1NqaQH0u6q8Br+EzHfNwg8O2SQzBuIPgl5jua/XicXyXjA4zjOqolIqxgos3Y9PRnufV9TmvocJ0c6ZvLSckcyYc3WRbTq9shJREChZjMtmAAqXXWCAJO/m1hmkrF24Z4OyYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 03:19:10PM +0900, Byungchul Park wrote:
> Makes dept able to track PG_locked waits and events, which will be
> useful in practice.  See the following link that shows dept worked with
> PG_locked and detected real issues in practice:
> 
>    https://lore.kernel.org/lkml/1674268856-31807-1-git-send-email-byungchul.park@lge.com/

> @@ -219,6 +220,7 @@ struct page {
>  	struct page *kmsan_shadow;
>  	struct page *kmsan_origin;
>  #endif
> +	struct dept_ext_wgen pg_locked_wgen;
>  } _struct_page_alignment;

I may not understand this quite correctly, but I think that tracking
PG_locked dependencies in the struct page has both false positive and
false negative problems.

Imagine we have a file mapping M1 containing folio F1 at index 0 and F2
at index 1.  It is correct locking order to lock F1 before locking F2
(for example when doing writeback).  Later, M1 has its folios reclaimed
and returned to the free pool.  Then each is added to mapping M2, this
time with folio F2 at index 8 and F1 at index 9.  Now the correct order
to lock these folios in the order F2 followed by F1.

I don't see a part of this patch where we clear pg_locked_wgen when the
page is returned to the page allocator.  Maybe I missed that.

I think we should be tracking PG_locked dependencies in the owner
of the folio.  For files, that would be in the struct address_space.
For anon memory, I think that's in the anon_vma, but if somebody told
me it was in some other structure, I wouldn't argue with them.

This requires slightly more complexity than lockdep currently has.
We don't want to use a lockdep class for each folio, obviously.  So we
need something to say "I already have folio F1 locked, is it OK to lock
folio F2?".  Essentially figuring out how we can track all folios in a
given mapping the same way, and making sure that we don't deadlock on
folios in the same mapping.

If F1 and F2 are in different mappings, it's not a deadlock if F1 is in a
filesystem mapping and F2 is in its backing dev.  It's also not a deadlock
if F1 and F2 are both filesystem folios and the inodes are both locked.
See vfs_lock_two_folios() in fs/remap_range.c.

I have much less knowledge about anonymous memory locking order.
Maybe it doesn't happen.  Or about locking one anon and one file folio.
For slab memory, we don't sleep on PG_locked (it's used as a spinlock bit).
For other kinds of memory ... I don't know.  Page migration is fun.

