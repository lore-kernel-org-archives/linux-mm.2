Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0CC3D10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F846B000E; Thu, 27 Nov 2025 00:42:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00A86B0011; Thu, 27 Nov 2025 00:42:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16336B002B; Thu, 27 Nov 2025 00:42:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5A26B000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:42:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3769F13BCF6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:42:15 +0000 (UTC)
X-FDA: 84155291430.04.ABEC271
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5744E180007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:42:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764222133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WBXXxo6b1t/jTwxmAwFWvV0Wy+xNIpn4pwaD9LbDBWA=;
	b=27RyvmzpnLLqHOtbwLXGZwo1w52t7JblmafICdt8rr6jlppcpnNFaJ2pgoggQ2O5l8EHdT
	o76UiM8G8iEX8A9XeD2wKIoWimOwIB6Hkc5eCyKO3PWgTFxkeE8eWdnYzV9L3jdWnHLw/+
	879S/9L9dFtoTjBxNIwVqbkzEXxa3ak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764222133; a=rsa-sha256;
	cv=none;
	b=7+rF2ri1cm3Fl2+a7Odp8fhv5N3czGf/NhE0/quWhUQqlbNsYZuEwAfhUg3IIQYX5NfX9c
	rKOUNE0UQB+0as+7tgxI7jbTp8BMJMz/XEvWjaXNanJInD7UXu39wk1DAecsyz9N9cU5nY
	l6rYF4iNvKjM5vQDlmyKcz7q+30whwA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 27 Nov 2025 14:42:06 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 27 Nov 2025 14:42:06 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSfkrpV7T7g5mhpI@yjaykim-PowerEdge-T330>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
 <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Stat-Signature: z59ehrbo4cudt3uyx7gyccq4gnwatujb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5744E180007
X-HE-Tag: 1764222130-338404
X-HE-Meta: U2FsdGVkX1+L3l958znV752/yv5ySPIZ9purulcT6J+CCxo6F2RLAjlFezMJKdTt4rd0nJ/posU4Mb7TKF5GF3ZpyOvKv5DnYPZC6zwrZtUqwfj//QPkpwC4Ak6X5pKKGrhPBaOgvZ+JOqkuAoGzB1cxNt3aj7EUxZPjpJ5/cp2HfN06FD1lBcRuO/z7EDy09ReihugJra+yDHrAFafpVSnbuzV/u+XerLH8uB4S9bpq5O67jhY5o0MOJnH1V6hhyzSZI/eLW1Pf9QSD6WOf9k6i74Q+BhVVHZIvc6MRehQp7azbTMivRIZgtynJi+smQwnsjpIzwOWbAlLALeEBQ+L6CS/NfcbVVDFD7EJk8hheNIxNHFwokKSZ2VF/YhAT88D0HIVfhwkI8LGShOnW6wk18J9YIphDBKZFXO4jaRr7frcAfTXt53+W4h+ioP2UZ3nkK+U72mpdcU2eQQzfI0IN3kDrdiAgumcv9byT+04W3jEx+l4KyRdmYyjuLgoWAjOEpgSWca+oHbO4EyIjDHorxbXerUTHCvzg6IP5ZgYkp4IjHd5rFS5eCNpAbF82C725dIIK+6zSXOMuJ/J+eO2nL35RgWED0S5F9NmahH5TIzw+RsDKsYwMqtAMdW6NJDJk7owlxKAEznPG5gdxVTUMIaBjHXOpFx4lY9UoOitVK3IS7NYWNVfuIbiyZZ62oxfUkT2c6cy7+08cK6bOsBc4K6DACFSOpFA2bK+lSbYHguyl7mkd8AayePs8j8jXMNor5qbNqnbcab3PSjIsWLRfT0jROggkQrzejMk3Wkgm+sG9JKLkjlgz0EX2Za+EgqsxmQRj0xehRy0Dqp0p2twXe+3sPz/2N9DU2pqeqOapqmonClN+a6FQqowHuMNnzQVqmrica50+xTefBZSM46hr35ylOOZW5ux3/g7XMNpqGtZ0afyQsP90xllpmg39UuB0Dm188Tx/tijYF8X
 JHphrIkV
 /S0F5RnE4JyCg2x1rc5mgpM0brx9jinUyYFRcYHOVj4v2cZRReElPfFpVZ79w7GeX16oEnPnidT9f4C40Q3HhMiE9yPbttp/Dgwf60kmUiEET+9Ui37KDP3Jtmg5v9S+Mf4Z6OBYDOR4CK4ERkynOfNlTwNO+8FLhUA8oKgeq7aSzLKTFj6eSm7CQ6wc5gyfygw11OGlP0LSANgEY6Q+dJwPj4LO9slwwnHR2lQ7yiEUtPRUhDQIl1z15IJJpvylzEGYYNfDDda+gJJ7QIffQ0Z8u5MTJHsv4KL0ppBt5Px7d21tDMQwSHGo5dLx0jZVHmFqTVlFWPUF4xls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 10:15:50AM +0800, Baoquan He wrote:
> On 11/26/25 at 01:30am, Youngjun Park wrote:
> > swap_sync_discard() has an issue where if the next device becomes full
> > and is removed from the plist during iteration, the operation fails
> > even when other swap devices with pending discard entries remain
> > available.
> > 
> > Fix by checking plist_node_empty(&next->list) and restarting iteration
> > when the next node is removed during discard operations.
> > 
> > Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> > swap_active_head. This means the iteration is only affected by swapoff
> > operations rather than frequent availability changes, reducing
> > exceptional condition checks and lock contention.
> > 
> > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index d12332423a06..998271aa09c3 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
> >  	bool ret = false;
> >  	struct swap_info_struct *si, *next;
> >  
> > -	spin_lock(&swap_avail_lock);
> > -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> > -		spin_unlock(&swap_avail_lock);
> > +	spin_lock(&swap_lock);
> > +start_over:
> > +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> > +		spin_unlock(&swap_lock);
> >  		if (get_swap_device_info(si)) {
> >  			if (si->flags & SWP_PAGE_DISCARD)
> >  				ret = swap_do_scheduled_discard(si);
> >  			put_swap_device(si);
> >  		}
> >  		if (ret)
> > -			return true;
> > -		spin_lock(&swap_avail_lock);
> > +			return ret;
> > +
> > +		spin_lock(&swap_lock);
> > +		if (plist_node_empty(&next->list))
> > +			goto start_over;

By forcing a brief delay right before the swap_lock, I was able to observe at
runtime that when the next node is removed (due to swapoff), and there is no
plist_node_empty check, plist_del makes the node point to itself. As a result,
when the iteration continues to the next entry, it keeps retrying on itself,
since the list traversal termination condition is based on whether the current
node is the head or not.

At first glance, I had assumed that plist_node_empty also implicitly served as
a termination condition of plist_for_each_entry_safe.

Therefore, the real reason for this patch is not:
    "swap_sync_discard() has an issue where if the next device becomes full
    and is removed from the plist during iteration, the operation fails even
    when other swap devices with pending discard entries remain available."
but rather:
    "When the next node is removed, the next pointer loops back to the current
    entry, possibly causing an loop until it will be reinserted on the list."

So, the plist_node_empty check is necessary — either as it is now (not the original
code, the patch I modified) or as a break condition 
(if we want to avoid the swap on/off loop situation I mentioned in my previous email.)

Best regards,
Youngjun Park

