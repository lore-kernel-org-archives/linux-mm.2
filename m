Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06BDDD6AAE6
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0936B0088; Thu,  2 Apr 2026 11:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381736B0089; Thu,  2 Apr 2026 11:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270DC6B008A; Thu,  2 Apr 2026 11:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 136396B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:45:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A40AE1924
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:45:51 +0000 (UTC)
X-FDA: 84614041302.12.3838A87
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4C2F18000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:45:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Io/u5ljh";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775144749; a=rsa-sha256;
	cv=none;
	b=SjJhwHEeujPqIwZ1Q84BN5FvfQND3RW63utGz5qxsRXzeGElZ5ujTQ8KeHb+H2GOwdtwgM
	kCOdO8ALquJRBXAG/uNc9Ekn0db9uAR6TimYav6ftfnnmT/Gil44IJwmrQRGyZn5/eQNFJ
	lhC+Coz5af/bKXYohQiou9Zg6w5sAzs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Io/u5ljh";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775144749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kn9LhZDdj5iuA1v5q5IVdjZeWxdxeXHN8k2hwKy76Io=;
	b=jHXS1PF9FJIIui56RxTV8hctpd+qrlod+8NwoBcQEb5ymzdgBnRr4yi9SlGqtdgxh552l8
	Eyn/wZyFG6ON88BJ8xXFeZn/jzC74sBDjjhvkz3/MswsBIKJKzNWGFBxM+ighlHmYVRNxx
	3rNP/NcE51Hbo/SAKPrzeVfqSmpnaoc=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38ad26e3992so9559141fa.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 08:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775144748; x=1775749548; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kn9LhZDdj5iuA1v5q5IVdjZeWxdxeXHN8k2hwKy76Io=;
        b=Io/u5ljhOpT/oaGNUIcv/dxHVub8/WxuIswkjICPLM2l+X38Wrlmox3OzPd7julzGz
         pLXOC4hmqNDQFQIZNzly62rTO0OcwrW03OxziJaY/zo63b1hD7esWwvMjLXC9hIabAfL
         jG8zdRzUcsc4FlJ/VVpVoKzEnm/hhQPbnJNHqJlrhvWhQTr4N5zw1SFlNnXklYXFC9IX
         vBXT182uof4YuqjG1UEwOmzcGlvsr3lp2kUwwu8WAXd/Mx4wjHOy1Qxwrnxj8VULRYq5
         0KB2i8Ehdsrtqkq5VEWMocZa7gesWXJBys2NVsKvH1xS1FCqE/rYxZu8JT4FUctcVpo/
         4NaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775144748; x=1775749548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kn9LhZDdj5iuA1v5q5IVdjZeWxdxeXHN8k2hwKy76Io=;
        b=Bo1Deixn4MM5CeeWImRDavy//xA8kmD7oePocaFlJ0aDf2pZSBAsy3yv36hlaHVc+K
         cA9VA6Bp5XN1C9BHXZJ1/WB0C4LFU5uRIcY8nq7/VT2M+96q/SaeenWHA/p4xXmGVABk
         uqDtapcxMNED3uVViHJrm6BH0MxLzVmxz9zQ40HHlzgK5iAWAYX95M2YzsNmpEAthkPt
         aE9x/R7pqXbhFK9lG3meKfN7i/Zh660JQHjICnqI5MUb+N8Ls4vMU001radDlqwBTqwm
         YePVxR9Aji6Z1AVSzgB8rQlzbEMZtg4Uc38K9YX7bQSZy8mHYaXg08ztlnWA2Pz7woGS
         dTTA==
X-Forwarded-Encrypted: i=1; AJvYcCXxbSfOMudm6wGqXtSjUvAuC6lCy+wafEYOBmt78VmCRGXRw4T33RDF2kjnq0kBcNKhaDaL5yNfrw==@kvack.org
X-Gm-Message-State: AOJu0Ywp40KiBPUy/qDJPTJH/NWxWbwGVBzktxGv6yZyVceZLnMuNIQs
	djp2sIoys8F8f1V1kMG9PEf27bxSbqDcQQlcKFhoq7P8CqPKmc4CIAVU
X-Gm-Gg: ATEYQzzjqeUSuWWhaPTxdAP7anq1V/XR9lxjriCT/p/rt4lKkifQxu+IsdA473Z+fir
	UpfSHRg+R0JoF7KZnb5K/YFHw/jkcA4/UZZolTsNWiR+nNHN3qVhqgiYLvI0ObfNam1o5Kg0IXv
	5fkDA3KUGo8zZzCJFxn+Ip0HIxngNe5SQ7x7/OkKTYK+gY285QYdZEoYYhXlxHhsz5pO4eTXY9R
	JQVtNE7fGm3HeN/yGzxr2tU8SAhLJq7zHGy/mOxlessNRVdiVolaR8Zii6W22/dZsvsTV7h5hfc
	42B7YiYP1Y7H0aFH8odElNRyjc6SQqpvax6q8QVa7oyMn7MqfDFxN1HpVi4ewEMF0DnthoFwsKQ
	4PBBQBu13Z4rXSqlUpwby9hb37RUXOoKligAPzXjNpEsbH6+mcK8W0JO6pg2+wfyp
X-Received: by 2002:ac2:5f1a:0:b0:5a2:a97a:4b5d with SMTP id 2adb3069b0e04-5a2c1f344a1mr2471856e87.35.1775144747272;
        Thu, 02 Apr 2026 08:45:47 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2c6c951a6sm750289e87.10.2026.04.02.08.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 08:45:46 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 2 Apr 2026 17:45:44 +0200
To: Qing Wang <wangqing7171@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: fix KMSAN uninit-value warning in
 decay_va_pool_node()
Message-ID: <ac6PKPR8vMlIUdwT@milan>
References: <20260402081413.1896640-1-wangqing7171@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402081413.1896640-1-wangqing7171@gmail.com>
X-Rspamd-Queue-Id: A4C2F18000E
X-Stat-Signature: 6nuwm3tga6xm5nhp73shikyrn61rs8xp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775144749-293031
X-HE-Meta: U2FsdGVkX1+75k4xc+oqC5/yxev40BhjNP7+xrAU/62TnojoQJIInjKPB/K+neiLJoE4LszT3TqS0PxZLT61EBchy/WyK0NW11wOqprS6OlMScrdRWQVUSOId19SNEzQ2kcdArg/On7bFPnBA2wwgOZJ0EvFaCFmwHJ4t23jj0rJlSE5Vc3J2fWOohDOCR9Dm3ZAkW7Sh7B6DwtjHq/BlJwn/OAUVwiZxxQ+y21p39EHba7YLyRNvoqLYQ0DIG47Vo+fHyJDlUTL/ssyZqG+bOg3NiazKwNmcT+uEC7tJw2Ywo3Ujt0YYydXN73DrXZJLWBAexPpA0aHMUb/IT3Dm8W/SOkkuYgXzbAtqrjELC5x1PS/K61vRelt3k3um+e9W70AAkhPHv09b2M2Yhw3DxLj33+HUs+Hvyikvzn4ATlHaIh3ksV7bMkfGbIoG62zn1ccab27LANogblcbVgCt2HGksGTJH5BR3lI/GxqhUCBaTvtrIcIu2JmPAfxeLIFPzCVuMYZsbPx1yBGrPSDEOzZ+WsXLFN4ySE20kQS5DY9UU6WzjXoAIP88BBAHBqfasPq3XBFxiBmOwXswMqyYoSbVfwuE3F5q1eR1Onh4On2NGsQSd4zoZsjCkreoWUouvMqb0sWgs2gyoTht/JJQuWAEe4c6hrRX2xGofQAIcv9soCyEdcU2qJYmundI/0OAQkTuv2tcmXcCGdnLU/+NbsHZvTK8PkQx4gxxUvBrOIqymQg8xGr0Oyavr8UtszOPsE6Q3+B81zOnu8YkB5iGYnxMvq4J/cWHYI3uLbnw6meuycVXnlwYzqqCS6Yx3tfBxYuqw5Lw5bdW791yDZXcd1Qp0+HulC+zADXOEL4KK3QDzUUhfSHDk86kE3TrWV1FWnX93zSKPbV2jhvpb/H/7NXVALWavhesGchmKBPAgjCwaZKUWwa/R4Pv8DT4FzQC+chgasLqdOJx+8PYqN
 eZ/0lfpp
 +cXcu/b9sxYAOH4ceq+G0EG6hyGBwxjmCV4flFgLBPm5P0JdnSggD7oeQyYRiAkCgDawWq9DCDVR5ra4DwFFvQ3UDo6cjbbiZ7+1OFv/KjBGnJ+8/9gRHF+OQS5e0DUxYBFa8yFabsiMlspW4/T0VpQ+pjS5Wft1I4fHcWRk5Dc5dEuonUtFs70ZcZhX6pb87XRf+O+Lsj4EXf9Iua8gSriFRoGe/cGqde42lmiWimBuqK5vmeroNY2QaOaz1GzTIMNkL82uXB1IYztt2QrnpIE6WyZw4AsXiHcH2y1CE/QDWy/aM1ZoWyJQ9eMmRw1HsVL9DOzvdIp6MuWCEGK8mNFBhYxHSJXSZLFYEnKt3zlmmwqrtoVEwdfkoLDTDONbINTHiGQGlUc7msDLBTnvPM5Lj4qJbOUevUjj9ygAFr6h9TUNJ1gHeyNJyI1K2PGnR+663gb+lv6Et3NQpHhwG/vtwFFnsfbOppoRYzuy8eqOwQoSJ9oShlQicU4vg/o0a7qsgaxBX5h8mg4jEzFEJ9sltIugzN2Zy5bHpopeUR74c04ZfAk//TIvhEdcCMN5neH/L4JcTDtEKOMgCiggz01PJaP5VQYTkt1u4Y8jnDZzeh+Uo+Jzindfp9Gov0Y9kq47cZCvPyH53pB5nY6JdAZngS8xQOEFNvkj2QgDwuvhcCbWuUrhPolBPfDEnn6LlSATk5d1he83AO8ISMbgL0D1fz/j+WTNuhtnkC9SfXQ7SF2apHO2vh1bIWoc2TNn8cfPb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 04:14:13PM +0800, Qing Wang wrote:
> KMSAN reported an uninit-value warning when accessing vmap_area->list
> in decay_va_pool_node():
> 
>   BUG: KMSAN: uninit-value in __list_del_entry_valid include/linux/list.h:-1 [inline]
>   BUG: KMSAN: uninit-value in __list_del_entry include/linux/list.h:223 [inline]
>   BUG: KMSAN: uninit-value in list_del_init include/linux/list.h:295 [inline]
>   BUG: KMSAN: uninit-value in decay_va_pool_node+0xf78/0x1dd0 mm/vmalloc.c:2255
> 
>   Uninit was created at:
>    kmem_cache_alloc_node_noprof+0x3cd/0x12d0 mm/slub.c:4918
>    alloc_vmap_area+0x327/0x2e30 mm/vmalloc.c:2065
> 
> The root cause is that if node_alloc() fail and the va is allocated via
> kmem_cache_alloc_node() by alloc_vmap_area(), va->list will be uninitialized.
> 
> Fix this by explicitly initializing va->list after allocation.
> 
> Reported-by: syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=37b7f6cd519f7fb8d32a
>
I can not access two above links. Are they valid? I would like to have
a look at report.

> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> ---
>  mm/vmalloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..8aebbb51e178 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2071,6 +2071,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  		 * to avoid false negatives.
>  		 */
>  		kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
> +		INIT_LIST_HEAD(&va->list);
>  	}
>
va->list does not require to be initialized. Because:

	spin_lock(&vn->busy.lock);
	insert_vmap_area(va, &vn->busy.root, &vn->busy.head);
	spin_unlock(&vn->busy.lock);

when a node is inserted into list_head, its next/prev pointers are
properly set by the list_add().

Or, am i missing something?

--
Uladzislau Rezki



