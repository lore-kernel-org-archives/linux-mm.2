Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AEAC5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 03:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1538E6B0102; Sat,  8 Aug 2026 23:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2896B0103; Sat,  8 Aug 2026 23:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35426B0104; Sat,  8 Aug 2026 23:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE7156B0102
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 23:59:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CB61A04B0
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 03:59:56 +0000 (UTC)
X-FDA: 85080377592.03.DD90553
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id C032B100002
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 03:59:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786247994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V7hN3UKcbejb6qCoPvaQil5F76N9zADLgcRPsg+G/Ms=;
	b=lVDoDreQZNzaSIUsMgY/yjxHNHcakxx/vOHN2NaG+aZb7b63kYd7XHECOodGU12Ry2LAWm
	Z0ttX9wejskoFSXVuI/4Lowt/wNmtisOtpVSF8JS4mac4gsZINUAJBpwNjsuuhUP5jk3To
	2iMSoFIWfq0EBGAHvH16a/0iGQppZn8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786247994;
	b=ACgrKDbWxteYRG7VXdA/tlMJPXOIXpw7gY6xmlHDzzD+idqhWJzEHokhEwnxQ/Ddc5d1U+
	IJLizO3a9iN0z58OfGTsKMikqYkY31mZxFtQS8UStBVSMGgJv52cC140t/b0hI7lzsGQq6
	N5f0yYhk/RLrgOOyY62yMI17z+m06zM=
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 9 Aug 2026 12:59:47 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 9 Aug 2026 12:59:47 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 9 Aug 2026 12:59:47 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>,
	her0gyugyu@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm, swap: don't free a hibernation slot that is in
 the swap cache
Message-ID: <anf7M08iH4yjJejQ@yjaykim-PowerEdge-T330>
References: <20260806190636.446205-1-youngjun.park@lge.com>
 <20260806190636.446205-2-youngjun.park@lge.com>
 <ancWz-4R93dnNOXn@KASONG-MC4>
 <ancub7whkE-OlU-0@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ancub7whkE-OlU-0@KASONG-MC4>
X-Stat-Signature: o8rh9cyn49uacxqb5cqwp5i5b943jjjr
X-Rspamd-Queue-Id: C032B100002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786247992-665724
X-HE-Meta: U2FsdGVkX19QsqLedIfBL4DLTg4n6HDrWuHyhZED3hE2BgC+T1rIcy6JEnvGI0rCjESG56AElIYFTldR9R94Sx+JDHM7qm+XnVp1BGTw8BeZD3hW4C/ytK2q0dqWs5yw0pimi9e6ySQko/lYE6rhMcS6Ek7izpyxSJSuHfyFZuf+5YZa0r8PvbsnK5rJimPvbMtU3CqRljaII0tnPdopKvKoSSaVCqLC0PEDMHs7ACKCyqoBnpSUq9isOXyKUfdeTDL2MYz3qCnNPtP1lNmbBHUspKOff8+XUFaSh6kI2zCME+8t8pWG+9aCLxmGks0cIk6tcQp0t30ptNqojaYpkdQ+DmwdMdMXYB3uUrSRZR6oqYxoUaoJJeRilYpX4q6v4mzdv+0nU9Ap1n3G6okrOuhwwDzusrblSIzPXMsasCaewtHadN0Mrp0mEOT56AQ3mYaAGKuHzEztMEUjDL/FrqaaFVmGHQMKX+DgQaT9a/vY6IfOdKM3eY2VPa0G9awogrmVH3RFtqIhWDHsyBOQOWU0iEJ2POoStv1t9ogd/koavOr94cfOZFIoF3yEC0kh3pThzvNtWXT2eo2JQSe6l+rOJ5EONftifyUgaW8pKZD6tAyDlBFJGI2ihWNzUrFunxlpsBweTHiJ13zCqWdhHzX6LcaKfcxsLsrldBV/o6EoTVKStUUKpUc7BmR8XT2Ta38qgisobssK/427O5OVvU9lYx5NGzDIqXGc+mvJQeY8v6KqD1osgr5UtY/ML6/AD+I5OVuydeGVI2MASdELP1PskjeEJOwCkW5JP6FqvfXq7H+ESyev5TEvlzFHWFWp/P2M571KFnDlrqj2JG7w/xKHLJxec+FRKyEviTruVMUmy3+knPqYo+oGv9foohDHIPU2LH9Bs7LWsLCOHlcGWhruBxfGakdot8v5VSoEhywc5VxwwrrLh7IHbztJx5CTB03lL12vJMHD4uPoDuy
 WwrmXTOr
 5IhxKpi4Ve4D3zCylV2q9CGNtHH0Bf6aUaQ9UikVmvLq4Fl8jLYCMe8t6AgyYsTm37QhPuGdxNZUYyFS6eHp9kMnkI0sWVssfIRgvFZtIYCuICo5/aYrpOzmH7uNJHIzhP4rnU/CAYhb+buEYwsb246Xz5ulVIUNewBCN3qMjz6aZIGeFZvPra4mgxPA/J2n09fy8o6R20PjLe6WftCgHWXv+dMUpbKcbDUdDUu4uCsvN2XQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 09:26:34PM +0800, Kairui Song wrote:
> On Sat, Aug 08, 2026 at 08:09:44PM +0800, Kairui Song wrote:
> > On Fri, Aug 07, 2026 at 04:06:33AM +0800, Youngjun Park wrote:
> > > A slot with a folio in the swap cache is freed when the folio leaves the
> > > cache, not when its count drops.  swap_put_entries_cluster() follows that
> > > rule.  swap_free_hibernation_slot() does not, it calls
> > > __swap_cluster_free_entries() whether or not a folio sits on the slot.
> > > 
> > > Cluster readahead can put one there.  It walks a raw page_cluster sized
> > > window of offsets around the faulting entry, and a hibernation slot passes
> > > __swap_cache_add_check() because it is not a folio and its count is not
> > > zero.  Freeing the slot then clears the entry under that folio.
> > > 
> > > The folio is now unreachable from the swap table, and the offset goes back
> > > to the allocator.  The folio is still on the LRU though, so reclaim can
> > > pick it up later.  It then takes the old offset out of folio->swap and
> > > overwrites the table entry there, which by then may belong to someone else.
> > > 
> > > Check for a cached folio before freeing.  The slot is then left in the
> > > ordinary state where only the swap cache holds it, and it is freed when the
> > > folio leaves the cache, either through the reclaim below or through normal
> > > reclaim later.
> > > 
> > > Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
> > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > ---
> > >  mm/swapfile.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > Hi Youngjun,
> > 
> > Thanks a lot for looking into the hibernation issue, I've been thinking
> > about using a exclusive type for it, glad to see actual code for it :)
> > 
> > And this patch looks good to me, nice catch!
> > 
> > Acked-by: Kairui Song <kasong@tencent.com>
> 
> Oh and I think we need to Cc stable?

Right, I will Cc stable next iteration soon.
Thanks for catching.

Youngjun

