Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC7DFCB618
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A146B008A; Fri,  6 Mar 2026 10:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1EB6B0096; Fri,  6 Mar 2026 10:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE2E6B0098; Fri,  6 Mar 2026 10:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F78D6B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:48:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF538160607
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:48:11 +0000 (UTC)
X-FDA: 84516069582.01.BF50D7F
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0126C40010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:48:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JDl0tLy0;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772812090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ltlmh5+xfasabBt3G7wfvJiHvUvttPKwWWOjoNqhRlQ=;
	b=4n4tz+a+2B69luyTyO/4HduMDaYS3PLa8OQUHIt76Ghke0Z7pXknwDWp0UEBRAMoO3nFGJ
	GbH8Z6Hv2a8R46pjOE2j7qJzM0I2kGqXXcwpkZol5vd8FbhzUPnnC3EWvcTc2wxPmC1bSB
	ikb5ciy8LLqwl1nuuXTu2pyIhuFr1Zo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JDl0tLy0;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772812090; a=rsa-sha256;
	cv=none;
	b=Q8fLSTLdzE6dLWMnG940S7LrihCliIIpL3hIW74mkFPk1gVwiZL9RSpGJRCyyOYyEXPCF5
	g8i3bezLjBgJKtUaSCEKi8BFGyqZDZmFEZaXkd7SOOxi0XaGXcCrzhGKJLfBRwqu63Qabx
	PAdfgjorF4SMtF9x9arL3BJCj08OEP0=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-46398742245so3444075b6e.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 07:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772812089; x=1773416889; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ltlmh5+xfasabBt3G7wfvJiHvUvttPKwWWOjoNqhRlQ=;
        b=JDl0tLy0cNIaqzKudkp2NcKUowo5rT8Cpo9bUml4vRJVWIuNPFN/nStFImUsr3ChK9
         w8ktx64X+ejdIo+otuMIzvlYyeROlAzrvxZ4L0nXNQAmVCOR03hL0SCGoBnzUfye3I3V
         VKPJcnqwYaexrn+YU6arKdOQjrMeTiXetTxqD/YKqC7wz6qBEUAb/gb75Cce9upDKmWg
         JgX4T9bk9bn2ISLwlXLAuMDRk/gizIBXVrqcUeisXDXHX/AbAKKB+6HTrGRckqZwrryB
         VisA6r4SoFfnEpURCSFL0Lxkbw7Mxet1S0aKqn1xKiWP0xQEB7oE2p7l1ZLrkzhABNQj
         1c4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772812089; x=1773416889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ltlmh5+xfasabBt3G7wfvJiHvUvttPKwWWOjoNqhRlQ=;
        b=kgwSwWN8mh+RVTvYFb4A7Y4vv3TT5wR4j4y26ObgcdgCaAUz3d5NzGaFZTXCSzYEsj
         1G1gzG4mM9lo9dePzmLtEJdthjy8o2B97FtxXo8jpFLl+DDSiC/tLWZqxeysWZ9kst+c
         FQeBtc7CaKbhOVutMoQtAC7ucIz4lU6EreYHKEkB+dLAL/Z3tQZjCgm0qrHEP6BqV9sT
         a+t3brfzR3XZKJMLZE6CToJMa4LaUw+fOibJivCNL8Yyt30TcdsE6gzG4D6IU6buSxu/
         DIYfD8uTObd3FM33JN0Xqq+H1TBb2yNDR4BV/pUVv0CbVY6bQiouBDST80tKfq6/F9eH
         6mog==
X-Forwarded-Encrypted: i=1; AJvYcCUAfpwsBWi3XsmabuL9kKYpzt/dyhQ0fgtU0Y1IQT+auREgKvBD233JK6g3/ZovFEnhhD4xEl/Uxw==@kvack.org
X-Gm-Message-State: AOJu0YwOZNzkJDcN2TFIzteSdd2cZtb1huSQwzqADEvrkvoD8UE+zA5m
	/yCd5Rwjuz5aClnYCU+L+Fv4AGBlsOLm/vo1eZ/L/N2psCx/f+xwoTQM
X-Gm-Gg: ATEYQzz5isZA/u4ky5xbJAZ+y3Le+JTUgPwsqty6Ng9rmdgAvTEdWYGjDf+4VpFzSpY
	WzcMZlU1MKJANwFeX/Qbccpz6TP9YzX5VhxOjNc8QACaAQR8s14+XejlGW0tE9mBpJ5a4UbhOQw
	Q3llwOowH2vqtL3MLgM8zAM2vA0UlMyiO0M0I9a+n5uQqrFeUoJNX785dUgAROby8YnZcUUnoTz
	/ZAkdsQ5mUjEd4bkSfbDBTPGYeeu+NAuFWf3XGZCFa9TPFzwiZ3qVzeRzaxePa1IENbUE3go2UI
	XYSxh8O6mRvHgxERRH4YdtKgC7S5nRuWp+nplgKq69iTOz72Yo2Uf9HPzJ3btKUf9Y0UytI1RLC
	bZTpGBKWm4BM9NWiUc3NnsARGxMNjKc27LqSA+hgiFUqCBD9hbzMmVDOXaZeW7+SlJ7jsbakHYq
	6k8Nxr055nrYHiUPMgsbT5Cw==
X-Received: by 2002:a05:6808:4f08:b0:43f:5c61:448c with SMTP id 5614622812f47-466dcb0c3bemr1240922b6e.39.1772812088834;
        Fri, 06 Mar 2026 07:48:08 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-416e68369bcsm1683173fac.15.2026.03.06.07.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 07:48:08 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 3/8] mm/zsmalloc: Introduce objcgs pointer in struct zpdesc
Date: Fri,  6 Mar 2026 07:48:06 -0800
Message-ID: <20260306154806.187506-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aapO2Pd9d5B6MEtu@hyeyoo>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iaa6wmfnusgtjbk1nd93me7u6ht3q8uq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0126C40010
X-HE-Tag: 1772812089-943809
X-HE-Meta: U2FsdGVkX1/Opb7CqgDYtifl8StVm7+ewwy5ZzzdhExSH7G8Fqz9ffyTKij/hPWuDYeRh0OxQ93cMIpwyhx7SYhAg/Qo3M8+VgA82KgD0O1tA1tcVMg36EpW5EVZXLFkWdh8y+zSu+WUGJXNmxAf6icGPw6ARMIDCZRAQ8e1YbPRZromQnkQcs0voy390gz04t8GF/sBcpQjqTD31yvtXdGcvAf3ZfI6BczLIuIU9HcSLgVIsATacj/s6VonTQvnwVsmVbAoTsqwCepJwVtdMcuSpX3J7Ch5xUjumaAfPruLN8IpB/SXVEjbN0xyPP9g8gybL+ZX8Y/CKTJnNODuWv5Ln6aUwtJG98GJtDWqcXb1fIzLa3RYmwDFddAQKi+7/j6gvYD+fcfzvxrd8EYs/oKDuF/VrNmMt11GZJ8Ej3+8rL25ZK3pewwm6x1aPc1zDFLGMfEQFfvDl02qkhxsqBQ4pwCRBbaDUi0YwSzonmtYk8SxJEIAXs3L0dXkdfnm8wBmUa6e6mKyeKVSmlHNd68zP/2cmTuFZGGwOmbcu9tVS0x+vp94dze2Om5XNziAGLHilvbCbQ/5uZkLFz50j+m4gVktT4Qk5Eh+la6aGWHaEX8+f39xUsRay9ZHOIwhj3118Qgig/M8wosb1SAzGKZKlngdryGSHaN6QEy74JJEv5fnsxBuPcGf7eW6zX4tStgq1oIRypzQfni4kJ+4+MhyKg0r1nBkE2zPURryB4TYjaxSTPzzVIC2k0MAoTbqoI7nDPRII0b25FSSplX502lakdCDtdpvIdAgV80osz+JjRSlrGyXP0gN9X9xWl2hguk7nic93VZZCmE2t/WK4lt12R4hRc3Bcp2IzQGe9cifTW1Rm/V3C3CNjmp4v9id+su4AaIJg6oxsXbbYnu5bZ+rStGtNC18jd4YBEm+JNO+uiHpNJ9uv+xrhQ/sMDkbk8sRIzau2DTWbEzddk/
 tyfwuOv7
 OWTemKrx1KAUCvEwU3V0nt8XWPpW5/Pbm4DSNGQxtAu1kXOl4WAhQlT7sq8hygM95fVt1yoocoaoQk0TKEChQkpldHILvAKUC7wkKWSSMR6viZ6Pvo4cOd2qkx1sK8GCGrVxiovaqKUqUSgjhOpfymcddn+Ek5hdOc259dcp8MSJ48CfliBWOAa7zDuSqnCddLsAo5Q7RIcC9oTTUa1isnbKgK0QSoz2RlbjavXpxWl7RrPNfCnYSmPJFWha9vWLVfoHh33PCF41Y17jxEW/7WKI3HNoqgYTocGo9r6hxTy6zRqbStPXArW4ZFP4RfZ5Pj2BBwZN5XmZqpfk3uEFhMAJbu8lBPe940ZTP64d5qtVXSPEfZ+bJKi2RyapGl2R+MrTblTegAwwGLYQx39Vv9I0SoAMvFOlfdUtyFlMQK+bAGa551H1XLqY1NMCW80L+Z3jT7XPRoLF3a7JaF+g1p/BhprfEcxUYxS/3iuuyQdnhCNwCx2WQkVpxQAYvjTcGfjqDvlP7w+aO6UBR9nLU36dTto3X0ncWehz0Oxdj+uUXaobP3y3xhquNNdDd22wLLiw915pQDFjMgHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Mar 2026 12:49:44 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:

> On Thu, Feb 26, 2026 at 11:29:26AM -0800, Joshua Hahn wrote:
> > Introduce an array of struct obj_cgroup pointers to zpdesc to keep track
> > of compressed objects' memcg ownership.
> > 
> > The 8 bytes required to add the array in struct zpdesc brings its size
> > up from 56 bytes to 64 bytes. However, in the current implementation,
> > struct zpdesc lays on top of struct page[1]. This allows the increased
> > size to remain invisible to the outside, since 64 bytes are used for
> > struct zpdesc anyways.
> > 
> > The newly added obj_cgroup array pointer overlays page->memcg_data,
> > which causes problems for functions that try to perform page charging by
> > checking the zeroness of page->memcg_data. To make sure that the
> > backing zpdesc's obj_cgroup ** is not interpreted as a mem_cgroup *,
> > follow SLUB's lead and use the MEMCG_DATA_OBJEXTS bit to tag the pointer.
> > 
> > Consumers of zsmalloc that do not perform memcg accounting (i.e. zram)
> > are completely unaffected by this patch, as the array to track the
> > obj_cgroup pointers are only allocated in the zswap path.
> > 
> > This patch temporarily increases the memory used by zswap by 8 bytes
> > per zswap_entry, since the obj_cgroup pointer is duplicated in the
> > zpdesc and in zswap_entry. In the following patches, we will redirect
> > memory charging operations to use the zpdesc's obj_cgroup instead, and
> > remove the pointer from zswap_entry. This will leave no net memory usage
> > increase for both zram and zswap.
> > 
> > In this patch, allocate / free the objcg pointer array for the zswap
> > path, and handle partial object migration and full zpdesc migration.
> > 
> > [1] In the (near) future, struct zpdesc may no longer overlay struct
> > page as we shift towards using memdescs. When this happens, the size
> > increase of struct zpdesc will no longer free. With that said, the
> > difference can be kept minimal.
> > 
> > All the changes that are being implemented are currently guarded under
> > CONFIG_MEMCG. We can optionally minimize the impact on zram users by
> > guarding these changes in CONFIG_MEMCG && CONFIG_ZSWAP as well.
> > 
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  drivers/block/zram/zram_drv.c | 10 ++---
> >  include/linux/zsmalloc.h      |  2 +-
> >  mm/zpdesc.h                   | 25 +++++++++++-
> >  mm/zsmalloc.c                 | 74 +++++++++++++++++++++++++++++------
> >  mm/zswap.c                    |  2 +-
> >  5 files changed, 93 insertions(+), 20 deletions(-)
> > 
> > @@ -893,6 +898,43 @@ static void init_zspage(struct size_class *class, struct zspage *zspage)
> >  	set_freeobj(zspage, 0);
> >  }
> >  
> > +#ifdef CONFIG_MEMCG
> > +static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
> > +				struct zpdesc *zpdescs[])
> > +{
> > +	/*
> > +	 * Add 2 to objcgs_per_zpdesc to account for partial objs that may be
> > +	 * stored at the beginning or end of the zpdesc.
> > +	 */
> > +	int objcgs_per_zpdesc = (PAGE_SIZE / class->size) + 2;
> > +	int i;
> > +	struct obj_cgroup **objcgs;
> 
> Just wondering, perhaps it makes more sense to have an array of
> objcg pointers for each zspage (of size objs_per_zspage)?

Hi Harry! I hope you are doing well, thanks for taking a look : -)

Hmm, I think you might be right. For context, one of the first
ideas I had for this patch was to have a per-zspage array, but store
it in the first zpdesc. As you can imagine this was not a good idea...
(head zpdesc page and tail zpdesc page? ;) )
But! storing it in the zspage struct makes a lot more sense to me.
And I think we can actually simplify the migration pathways as well.

My immediate response to this was that "subzpdesc swap ins/outs would
be difficult" since right now we can just move the pointer, but
if we have a per-zspage array, we actually don't have to do any
objcgs pointer migration at all.

And I think the cross-boundary cases are handled a lot beter by having
a per-zpdesc array too. We also don't have to convert the per-zspage
obj_idx into a per-zpdesc obj_idx as well, I think if we do this...

Let me mull on this for a bit : -) I'll give a shot at implementing
it this way, I think it makes sense!

Thanks again for taking a look, Harry. Have a great day!
Joshua

