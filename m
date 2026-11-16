Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E85B606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxlMV0OZ
Received: by kanga.kvack.org (Postfix)
	id 07BD66B05B3; Mon, 16 Nov 2026 02:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BF46B05B4; Mon, 16 Nov 2026 02:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E846E6B05B5; Mon, 16 Nov 2026 02:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5D426B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:47:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57BA1A04E6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:47:50 +0000 (UTC)
X-FDA: 85440203100.07.0890210
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5ED341A0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:47:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxlMV0OZ;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794815268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5lYApGjKPqMrWsyMrRgAHHRvopm83QOmd4lVVfjjUc=;
	b=4Qt6XGC71xOztNmczJC5iah0tTsepVVGXaZpVnNpmgAcY5FJIPJG1lNRCnr3KoFJ0dxXM1
	7R0ZtZCDayeujDeu9RTUtGVBFWu2AYHHi98iGT8CdC4FGBn464QKA/6hCxe95rMZKCibBG
	VVXVjY210lsY7rXT6BoLzWY3EHiPfSU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794815268;
	b=rNciYP3UREIy2TfnlJPkMhMq0jM7PWyEZorKCf/gR+LNBfm/IXTCKdqa/hT07mEONgfoA4
	zNsCafu+aT5pZAWpeNpGL1qOty20dk6nhhpt3fVU1lQtg5kqMDywUrTdrDjcHwW5GeGyv8
	nyeLi+rQS5zPSiGrliyMCzkvcMpoAcM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxlMV0OZ;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4CE445D31
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0E71F000CD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794815266;
	bh=L5lYApGjKPqMrWsyMrRgAHHRvopm83QOmd4lVVfjjUc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gxlMV0OZX/KvUEidAvZnU4WOmQLnazSER3rpxnedcoROUu5FE/w9DgHZkuXDMPN5c
	 ff6zZpe+1k0Krj8w/IEK1Y7nRQ6ECZ9AaqwWJl2cIOpcAfgz/0o5RrCG2FiINsOnUY
	 D/JsEvtGkl/ly/95IIhkJw2wwZGxCHTKaN9GW4vIkUT+XF6YOy0YZ0ZbK4YernjEfq
	 InkdrdKclgZrL722DtaxRHCdolN5QZOeRe+Fhms0iuY7cFcxcbssLGiuX4oDVfwCNU
	 CQjebZ1yTEowqVgeyAbd1Tw4UIT8U6PmOQLyaZ7FB0KFRNydlvvkQLHpx4qXJsRXAS
	 ET4k1fLSURGlQ==
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-7cc0e865dd1so868516137.1
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:47:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFDC9gZjpq64LtDvuUP3MLd+XLx45HIOoKhXjl3NPjtGJeYISFdQX9JRMb3NIVxktgClrPVnYzuuQ==@kvack.org
X-Gm-Message-State: APuU4Z+H30NJJoreD35OK5yhlWF3mVUphy4WyK3t34JW6vGwNwUUC7JY
	+LiR9vy9OZr7IYcSoUi3qHByrbuj1d2DtMSab8GWW9CmiJJU6y87nF9FAAAqDZxnt6vp8btUv5t
	cWH8YWqLz7gl0LiVh5Rgt7zgy7nMVgdw=
X-Received: by 2002:a05:6102:6f06:b0:7d2:7266:2c8f with SMTP id
 ada2fe7eead31-7d64d7f2269mr2150167137.23.1794815265800; Sun, 15 Nov 2026
 23:47:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116061158.333826-1-hui.zhu@linux.dev> <b6449fe5-a697-4fa4-8985-fff2e0b0ed76@linux.alibaba.com>
In-Reply-To: <b6449fe5-a697-4fa4-8985-fff2e0b0ed76@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 16 Nov 2026 15:47:33 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ztHS-6HmEFZzzua7MnnJuoK1DHr3_4uEwD+SZGN9NuAw@mail.gmail.com>
X-Gm-Features: Aa3M54oaeNsr3g1DbmW6duiSC8_BFTUsMZ61-jbI6EoY4IzgGR53A8wPlm9__vw
Message-ID: <CAGsJ_4ztHS-6HmEFZzzua7MnnJuoK1DHr3_4uEwD+SZGN9NuAw@mail.gmail.com>
Subject: Re: [PATCH v3] mm/mglru: use a smaller batch in fill/drain_evictable()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5ED341A0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: yhr1uq1ozdo6c8btewnnneiuaw53r8gp
X-Rspam-User: 
X-HE-Tag: 1794815268-359449
X-HE-Meta: U2FsdGVkX18qQG38ElfXlh3XblxY9IfSVZsBdZ/A6AZ5zHkvn5R7nM7rSia6HBMht24PalaQXfcXLxEHIa3MwDun3ZFPVyjbhFTZDk3+jHqYFLIkkgoXWN0SZKvBfYE+NEpU1NdOf0shrFcao6ZdZFM20nMybHbD+pNQsI+UOq+8Tno1Qg8UsJfZyf1o3+Kw47O66jRA5/rRbYddAfaGNbE/W4art0+oXg0+RRTb78j4+GnproOv80ksQAO6URhcvHtfz34unsBuQ/u57N63GxWk1BM2Y+38eo8Ev27DPCVMPN1RMyN2eSFtukcGLKtc8f0m+qB8Sell+HpXp2eTXlxxEl6SGbyyIq3hsHASA9XNuBXJTtsnJ5RfsnRLk4EuYvUWjZ+YpLtJoBVuwcEFzMChRs8paOrIZ/vUF312bzfVVI9gyl1bYoeEs2Hm8sidMqZWHJAkp0n6LnqVpj+o+EL5XNO8bIMrRSX5LvslmEfZyxoJj4zLjkokQ5Kld50LLBw62Ud6fmIKEWexYs2jvpPNaTQXToYOD1DyVBWWRczCB0K+/XZIEuQLsSHVfRteR9A7wwBWRhnk3XdHUIcYPK94n9uwXUyhYJ0s6agF9uAp6mO9pHXuExyQW2BDRc96hao5tdXTTZSGSgudteOj+eEfkX21PU2aelCS6Pxbm/+L38vItDd6H5oQ+oGX3VVALUXRddMkvJhxeuayrYcN9EsJ6LyI/nc154BANuwnnji/hQdYnV/eu0yV2hXLp4EJaaU4YUzMlY4eN+WQ2uSbS71Jc3+72eUkIaI6JNYUBleFiBnxEA09si7dcx9ap/iBZYgTmglK8y25A5LTJy1Rlz7Xxy22fOS/27pokdK6xlKartSplI3sWIg86ewTT2mOz+w/8E1JTJVDpAGQ4Edk/UvAcY9zCKRxWWh5ITemupR6jT8ISpOYF8HilRI4NhWyXIdi43g87heXz6qR7nx
 4jUDs4NX
 QqcHFWfzkjXjnCf05BBVNSrcQMrj5f5bA6gQjZzH+p0/FGuRTuvdlQr3lbjIca+gaPBPXaEUk2iIa6rZ8McpmbXqp83uBXKFSo/uiEEcdkPFcLIAbXVnnr+iOlrtIGVh/qMT0c8wntfGB5XI6U3QzBHud8ha09pQLwWtQPW+aba+1OiNNFcPcud7d3NjfrMnTbZEXsmIg8Z/g+5meMJzhM6TKjdMLSKRxWVDGRVyPPJlD5X0qHCPkaU8MLOWrxy0Cn6mZ9z380Olqdu3vBHst93iRRx429tjq5ePKHS2Qp/onsZQOYGphTm3SOHCwZU+vkZEU1bQftvN5mUpABzjhzAJkg7Z9UYPToOceiVWohKq//aKedeDtbqs80u0XwC6fmZnt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 3:29=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 11/16/26 2:11 PM, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > lru_gen_change_state() migrates folios in batches of up to
> > MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> > keeps local interrupts off for up to about a millisecond, and CPUs
> > contending for the same lru_lock spin with interrupts disabled for
> > that long.
> >
> > The caller already drops the lock and reschedules between batches,
> > and the restart protocol does not depend on the batch size: both
> > functions make monotone progress, so a smaller batch only shortens
> > the irq-off section.  Use MIN_LRU_BATCH (64) instead, bounding it to
> > about 15us.  This is a cold path that runs once per kill-switch
> > toggle; the extra unlock/resched/relock round trips cost a few
> > percent of wall time on an otherwise idle machine.
> >
> > Same change as commit 6e9be217a3ce ("mm/mglru: use a smaller batch
> > for reclaim") made for try_to_shrink_lruvec().
> >
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > ---
>
> I'm fine if the small change can fix your issue in this cold path. Let's
> also see others' input. Feel free to add:
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

+1

This is a rarely used code path, and we may eventually remove it
entirely. So let's avoid over-engineering it.

Reviewed-by: Barry Song <baohua@kernel.org>

