Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE21C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8A36B00DC; Tue,  1 Sep 2026 11:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359216B027D; Tue,  1 Sep 2026 11:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296116B027E; Tue,  1 Sep 2026 11:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 065B56B00DC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:42:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81B611A0461
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:42:35 +0000 (UTC)
X-FDA: 85165610670.13.C83FBC3
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6FB11100009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:42:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Z/rFx+cR";
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788277353;
	b=rC6/yDSotCIVEQ21NgiAptzQHJym929BOMK+coRM37fP60v8j5i6RskvXI19QbyPWIVEDL
	HjAVYpuWEgIAXY2KtkJ7P22YBKtmDF4qOSJM94OQgb3XMwkLzjV7BwZb93E0zeUF56d7Bi
	3v96sK/yR5Dwxc0U9bu/8XyjJLWmH2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788277353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieYVRl/yPqLfVFpGgKDnoBwKi1G1iwV5CrGT8xV1YeA=;
	b=UaUknkIQLzQ+y8N8fHlVpaa3nNDEU1f625XYBPhjAbxH1HxU7mucINUJVdF2JI0B+ieU01
	4RqaYl9OBx+sCRADnMAttlTvYmj7zPVIbOhQ88ij9cBa2l4IiKc6apKAr29da5M+oK9cNb
	zPbMpqN51nc3il1kKLFSPXWjCYhaf9w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Z/rFx+cR";
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso26737555e9.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788277352; x=1788882152; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ieYVRl/yPqLfVFpGgKDnoBwKi1G1iwV5CrGT8xV1YeA=;
        b=Z/rFx+cRTaYU32VLYWppZcQiHxgAK5zp4L4zxBSXTIEaHlc8nheKYxYgD6tBlswTsZ
         TFTb9svBdxys1KQML4jUGvnaWP+Xw2sNoY+LIV1b50NZx4aiDEuXwm7FZfoCKB09z5dK
         0XlAuaetNU6+EuaTge0muHKefbt7BSfgMcbvc2Pxk0AI2Avzip5TE5SGpJB6h4kVivo8
         gW6/TDyHgV9aJ9fm7HGLk/FvHgrEqqiDjfXSVGjuwWKiaLcVQsYmRS+zNaUxewLhcdYL
         GCQu5xAIgovN/ky/RRFX8hEHef1gQcSZF6zOZ17yUfIl5FtRpzEgmw09D5E1BM5rFxBG
         rsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788277352; x=1788882152;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ieYVRl/yPqLfVFpGgKDnoBwKi1G1iwV5CrGT8xV1YeA=;
        b=oivD0vxc1yxchzE1c4Tcf/qWDbUe4VECmnjgEzboCD5Qvc9xQeopRqcWd0fWBsLlzs
         rkOArnaU9+qQLEjUo1op6apWZAiBLiFeG0/jcwswIgJjpFu70qcgfgi0iYyC5REbhiVT
         EHQXbju50H2tdcoW62u6uOK49YbXTlyt7wnMbW/EHbRQz3Q98Da3dPgbrSScoewsC6oN
         k+I5AHckVuTNHH7Oun16ATWYLZhx4ekvuQ9XdqqgQFZSfpJ5uO+u0Dkvtk+59XAU24Ma
         35bS9jkIHLgSczVHAtuzz3ynbCwY0pV42qmsW7g6iEwQv+8XMZUKp16WYY0bCbMbOxCZ
         a+tw==
X-Forwarded-Encrypted: i=1; AHgh+RoSkzzb3sb0fqjW1Czeocu8yhzgNghZdI5qUU1UfCIqQt5Q83bBMkpvV5mKNkUWWUQH7X28s4tCDw==@kvack.org
X-Gm-Message-State: AFuF++mZ5Wj9hCg80l+yz7bNZjZAAwz+tJZvld+N5dDjoxC6buh5ItJz
	bJHJ/RVqVQOewIhco+vP97u8txrEVvN7ecuOjbBfRpTF3TReJSZgG+9C1LvP0iVLfjPwgfNhpIm
	3k2tAZJE=
X-Gm-Gg: AR+sD13gsdRx8yUbBI/BcVfMV1fa44k2lQq8QI5W2psy/qg79F5L8ptWgNvNfnoz/c2
	b2qYuYmaoaxU5VchuselRBNcybqHl/YRKGsM1WbO1MOKGrC2x0iO9uTeydxl27bj4I5YFz7DcQM
	qky8fQ/bOtdlWjDR278txKsEO/Ibc1RBEATjP17Vc6jG4Hy3EWY1N3k6fJnSYUqzAGnv88velBW
	HS2zb2a9tHWUWkrPZr5nz6migliVRw/utVX36Xp7kPP7HIjF2naisTOx7oTVPPC8xLUijpiJutw
	GanunTmUNFdeeqFFWRC/8pt80/nP64ZQZFcDsAtYjq+elutPJYPbX6K/rzLPL6cbIgLHZiMj2gU
	6Bcwp4EzcXgcSOmNZrNMLbTyH3mSYxbobitlLfSfs5GZu5EQdYSQ9+YImpl9KHnDFQnEFyZPFID
	l+wqCyZdyKl3oTrheszOsvsEXDv+RhY9gC8RV8dFf8Am0T9FfFCG81DZJpza0chlTi4hwFjsNk
X-Received: by 2002:a05:600c:1e0f:b0:49b:9113:e04a with SMTP id 5b1f17b1804b1-49b91c19c77mr582161655e9.1.1788277351867;
        Tue, 01 Sep 2026 08:42:31 -0700 (PDT)
Received: from localhost (109-81-87-32.rct.o2.cz. [109.81.87.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b927d462dsm171147105e9.0.2026.09.01.08.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:42:31 -0700 (PDT)
Date: Tue, 1 Sep 2026 17:42:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Stevens <stevensd@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apbyZgB_Zu-DK8pN@tiehlicka>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
 <20260901142552.GG3004@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901142552.GG3004@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6FB11100009
X-Stat-Signature: yxn1c8fr1kqstno4xpexcr6xw9bjttea
X-HE-Tag: 1788277353-473656
X-HE-Meta: U2FsdGVkX19vWK0nSlT4H1Cd90tq4k1rAfEwpOTYXavGS//5Q44DQyEOycfL5a71PkmYq/zpqcH+pEXMZp+ktCtD8eUWT3YDqubIavVEZuSVF4ECfqWVS28mSMmSlFMn0THcaxZ+DIclyS9nh42jAKRcjkcWshBMHOPJ9dRYcJmmt4OsiErNuK/9Tv7TpKlO6KRMwTfOu34cWOPSxapV3SZpi4T4lSj9U61YDMXjgnX6NIG2S4gIdv8BctiJkIkKuK0/J8n8w/wdopTxQj3PeG7iQdRIU6meIrw3h6wzu8qLgVwHmCLeL+b+IThmQgjA+oUeVpa7N2m9NyPJ+7+5a5G3d5XsJ5jboz2rrrOvH9B+M02s4XC6njCrZ03WjjQkUfWc3mRpEIXUo+v1uOPprVTm3JjzDWRNqXQSZruRwqCSEra3DxE5bcq6vV9P2Gk3eEwVboS2VKdMlzLB1TQIpIQ6rIS4LO8jeEgJOyJTnSNof+q6zXaNsBn6dgZsWA/MJ1JO9j9tYfPjccoezJSIhP8wSGQIKeM2hECyE4iFG82tx35rSKPK3H6f/0O2pcg/bEaUybWJCFrkI6SGV9j/KFAJiErS1pNE3+QoJBHX9TafTQrkNgLJhcS7LxtWoFwd9Jo6qw897w9npPVxhfXS1xt1VtDXyqBO4HOZTfdy4I7VGa9IcbVRL65bX9OpOwAOn7tvO6+r4uSeHiRwzqHgTbtuFeH9hb/Le0WCitaoFOMWgBNai2qxuy5DP+M3v4mxUEJnVPrhYe24E0zN626cdvwMluhnx6YY9+SOrSZo5E2XbCc5POSuTNd1+xVjtQ94otXpWoOg/qHHC36Mp9wKy/jeCH7yz8ORolHx450PVC6rgddDddyOMo8GV7Ks47E6vb0wttyMIfsyqEqu/jWnlKy3T846rtRltz5WxoKohhPt5DHuRXAhadrhneDmJhOW2SrD9qFLGygQTLS7LV4
 U6Dj2vyF
 YZ8pPXd6SHn3iXftw1xaB7wL/MdWTi1orw5wrIL2GJST0dDkIpeRcwOn8+BA+WO4Xd5ThjQrGjPRIFRQfADhkysb74/pG1ouSLkaXyUfQqX+7WdD9mx4kl34tJ8w0ibYuxAO8snPccJStDoabPGs3Jg9W2kcG55yMlM8V73UYd6SItrrUu/aLS7zcj3gYam4ANkAvW7qAGyNmKRncByENfSwAhr/9HHh/gpIa1zG18AN4qdFdW3JFimPMW5U10wSsehuRxPHZROfNjPQUgt22T2nyS4vrQxiQma3paZeUM9V1ElanHi/mpKKf9OwyghLAz4FCt9rfUwq4Kp2ojUrolOyWODz5YYtQZu/PAXYrMGipRQUoNUCl4hWdcm0xmkqdQhc7qfX52+8Ec3btxRsxaMXScA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 01-09-26 10:25:52, Johannes Weiner wrote:
> On Mon, Aug 31, 2026 at 06:04:57PM -0700, David Stevens wrote:
[...]
> > There would be no guarantee that memcg reclaim would ever be
> > triggered, which also would also stop MEMCG_HIGH events from being
> > generated. Overall that seems a more serious than just dropping
> > userspace notifications like is done for MEMCG_MAX.
> 
> I'm leaning that way too. It's an indefinite error, and it's a freely
> programmable surface.

I am really curious about the indefinite error side of things. It has
been my understanding that these NMI safe charges are a) rare and b)
there is userspace running so eventually any discrepancies would
resolve so the excess is temporary.

-- 
Michal Hocko
SUSE Labs

