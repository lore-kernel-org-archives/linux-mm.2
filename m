Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE3B606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=SpLO4/++
Received: by kanga.kvack.org (Postfix)
	id 3F77C6B05B1; Wed, 18 Nov 2026 10:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7A36B05B7; Wed, 18 Nov 2026 10:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2977F6B05B9; Wed, 18 Nov 2026 10:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2C0A6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:56:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94C1140790
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:56:18 +0000 (UTC)
X-FDA: 85448691636.27.B830AA3
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id B55C240009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:56:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="SpLO4/++";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bQBfuPo4+GA4H58G8tofWZlnWMcm4hxNRzjXZBoZg0=;
	b=c9K8QZv4RBHlbolB6NYGF8bLIzY3Yw3xYHl8IqitsUj99djlj7qCXT4rvfA0TTbwuXUX1o
	HEb8bu95UCQBGyXR8q7b4weeJkEkDUsypXcaxvosTZjVgAT2+6/PupxrtgRynonFPNXtHv
	hfv8nqQ44vv9t8wP6DEjcTqcjauvj9g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017376;
	b=6h8TVh1BcBCdnnwY6zlSJzMnruSNi/ZEPbfeXpFTZrMlnDHtY3ooAsXhW7kcgky8XIZxms
	46PiM85M5xwC5Z2NbvfqKNBelpHHoDzEDmoqIErLGJ1w1zlvKREYTVTzRECivLpNjRvg2k
	st6diHJmMIh510t78mLdWaNnH+d7+X4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="SpLO4/++";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91ef011e338so5495446d6.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795017376; x=1795622176; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3bQBfuPo4+GA4H58G8tofWZlnWMcm4hxNRzjXZBoZg0=;
        b=SpLO4/++g5YMKzwyYIbiKIuSdZCwGUMsfINp87UamV0lAmrxn5+CKBpVHeYbzmDxSw
         cZv3dBG3RX6mdIZyJUa3Fr4QwBLDZS3CSbhT1RLQkvTvGYo06jQpb0EiwGrx1nQb5WJe
         fWR/Z7Zz5vUx6AFMNcc8fJY9fF36auQnW12PcKJotgC3w6tV1DuGZ4qgpfc+NwazNdQe
         Ba21zsNPMsSGJ1xbmiami4/SKgzFMuqGY/XLZ0JWXem6NfRZww0EKaJfzF+9Lj3J+fgT
         GgsYKllefNyJrUW+rPN7WwGLhs1XdfoSQch1bPIT/hym9WoXyibn6XFSoYmTzNfe8mF8
         s7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795017376; x=1795622176;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3bQBfuPo4+GA4H58G8tofWZlnWMcm4hxNRzjXZBoZg0=;
        b=FvddSsVVBq+ZnH7QwRKZr4Zf4n5eCnS+JaksHt1BBaQKdzuovLbH1IyohJuMID2zRk
         0rwWaCSkab5V1qf9qcGCNKwZci1XqpSEFwP6z1mwQTa5D0tLOSSgJQ7Way4E9RFoaNyG
         kGTU2pdPAhk5dCxAw/036OIUEDrmQnTrhHy9pws3YSfSgySu9l/LVc61Y0n65i7YgZwG
         rh3xushqRGoR9Q5mGjo82tDi2RLVwC7JVR2Lgcm4xaLbTGV84rAouIzexBpmvMIREsVA
         pYWFCm29mXxSvqbdAMfmhk4lrvbnvgUN9reuNg+x3N065EiGPZORzmm2KzfUBX5QGHu6
         mAVA==
X-Forwarded-Encrypted: i=1; AL+hErFSFC8KNVbxQtBLXX/uPtxhtRXZDwWOHdJZUtiWguAebsypnaLO6lIsgWTfEkvrWvNpSW/kVzmCRg==@kvack.org
X-Gm-Message-State: APuU4Z8skuVc/tbL8ppPWxAq6/ueJvBjzceaxqFpy+/Pe7G840L8Z5zK
	9UbzltoHWiaWpaDZVftk0CXs9G7QZ/kBI2ibM+sTWwflG+elO4y2mdj574cDGhWo24Y=
X-Gm-Gg: AZFdTZeG9wQ6riFkUJX1iumRJd6zGmPxfkUcBGdYa5aispyfx+Vb43Z40sBv97U/mDm
	e1Sifl4OtaHKBm2f7AV3xO45HXsDDDevR5FS3cFc/h1e0xSnbVezC6vS9X5Po1/AoLU2yiw3g8/
	s20OODuOE0IvFxwuKytJ/yE0G2eYSXH9PXfu4CP/ezsd0UxeIWRC1PI257Y+vfefHxpbxhxRQ8Q
	elS2s5sIFO2fdLfBGzVmNRaHTcI5EjP/arE+FfQ5IvxayqA9g1LOHZp31doz0E/x6kkGTkOUkM+
	Mw5lvPTdVLjdVQyRjMRB9h6CZbM2qXzRcRr72wXz+hPuDwIoPxufggZguJT8g8g6vEB4tzFGWYt
	8ekGHcEp1uxUDuBiLkwtwOFtTPz5Rp3QircYfOYHMCwxEUnh7AaHtRBGWiQpOGh5i/+TjSSOouj
	ulPmAzT3J9Wjc2kc/mB3eT+QsJYkM+HIt/zNHoS9XC7TTjeVkB/Cirus0hIOMbpIqecKdOZM7dP
	DaeNqydcSj5wW8qlUEr/Pw7op1oZqP3MaBUl0QU8iygCTAtZIeEFdoDyPFNTChLmfdg8WWzmBfS
	gtGOs4TiCjUhmTR5SrjFbICTEFIPjR228xxISJIzflJX87rx8sOTYJcz2hTEsWls3wsHgSXMtHH
	n4Y0gMnBI4878jwzxqwlNLZCftTKM
X-Received: by 2002:a05:6214:8013:b0:921:1890:b77f with SMTP id 6a1803df08f44-9211890b87emr29798426d6.47.1795017375668;
        Wed, 18 Nov 2026 07:56:15 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d28215sm24719106d6.16.2026.11.18.07.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:56:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/22] mm/mempolicy: keep interleave and tmpfs mount
 policies on common memory
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-serial@vger.kernel.org, linux-pm@vger.kernel.org, 
 damon@lists.linux.dev, linux-cxl@vger.kernel.org, akpm@linux-foundation.org, 
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
 skhan@linuxfoundation.org, rdunlap@infradead.org, 
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
 johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, 
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, 
 linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, 
 hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
 sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
 xu.xin@linux.dev, chengming.zhou@linux.dev, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <av3EGWuHX2JDdlrx@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-6-gourry@gourry.net> <av3EGWuHX2JDdlrx@MWDK4CY14F>
Date: Wed, 18 Nov 2026 10:56:13 -0500
Message-Id: <179501737390.1206716.11014097946405277594.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B55C240009
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: x84ujotgkg8dkb4s3ecg18zbxfuoehx1
X-HE-Tag: 1795017376-840993
X-HE-Meta: U2FsdGVkX1+lJ5oFHW0Jk68bv6QRkQtU6EpPLZRPQZMcCzPp9oRD0UOodXIFdhIeSJpfPf5K+8oCNHWKTboOagvWUZK/gwftbka49oXbpSQ0Mmhkp7RO4fo1THcv9BXWrdaram5c88vim8jmsBknoGXzr5JYd7ZYP7gSvepIwn8pOYA6RJTfepfhcLS+bGtK83WVHcWPmbAM4yArrSyFdzXhoNfTCetonki7/fJbJYyvuh6ZJ0QXr8bjdxtFpT59MIZZgJeIAjTUub0Vtbws23CBEJEl5Hw/7aEoeudmUXmN5P1dL2OglsNsEWqGW0MiizR1OL4HREEGOcBtpyx9JSy3sjhe9FDzTx37s0yoXukISaJcIOVQtmHhC+es7XRJE55f84QK5++3ErtMJs6hOWRk10/KUkA3MqnIZHQz4l24av7i5dhL5grQJ1XPH5dOF833fm9FHQLc6/ikKerP66XznCq+2CdR5tZp8b/XsXsQnLj6+VfXreQWtSEH8cl0x/kMizPQnytxGt0aSwJowYzzIUOU00xKaJ6h3GFGMFQs0EescHiI5mvZZwXsSTYuab7iOZkeKEy4MXBHmkIkx3lNmlKr8TVusOwLiheJQQHr20JXhc9AOGRJ7YCgEB+0biR0lC9gBdQ4rmpvHqDwZKTkmkigliqKlJiK0Un12nFV7gcRowY1qGsJpOnf9jayyV8fzZERwLObkXlADoMW9ogoy6rv7E1Mj8MmnCs+2FopGuytP2aBoXh5YjK7O3zbeqaQKC4E1qe0n7W/3K4mwRn8hraiymsMYaB3Ov6UDTZCTuTwZBV7yAa5w5PX1qZW0XDYDYjxDBfsBW6lGwN0wBRVM8zPkLleEsOaxPFbO8/JTa7wJQwjFF/sIzSN9McRuHg2u3OrYl9+aDw1M22NV85HB9Pj4nhSoQVcyOO+iKGIXlZn4ozx9n/IqfqFwBZg62FZCe3X8PJiQlxS7Gf
 E/yt5n2b
 j24DnYi1nV+oLCkEbixkktCJTGn9IsDdhpDgZj1u5d+WCvMB0tJmtTLNQA+V9dT7v3OH9vHkUcK5HUx0N2uATdowW0iD0CkPUgpPYe1tfQOClIe00DUCOkpCKH1H43U8s6huPIOCGkhsVjNW66284YK/mqT10o0L1qTlNvHHWWHJetYJHVKVRTzgA7X6BxDLxZqW1T2+K7XWv9C7eaSZZ7ZltU9Fh89Xlw/YzBAXDiV400l7NE1DmUtp2EIIEb0QrPEf5gZd5yPAgzltbe2d4mDb5jBBUfw1AeRWyE2nSj6LJIUtJewJ9anoCRQbOkHo4g6cI12verosaFz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-18 23:30 +0800, Richard Cheng wrote:
> On Sat, Nov 14, 2026 at 02:09:42AM +0800, Gregory Price (Meta) wrote:
> > -	for_each_online_node(nid) {
> > -		if (!node_state(nid, N_MEMORY))
> > -			continue;
> > -
> > +	for_each_node_state(nid, N_MEMORY_COMMON) {
> 
> Maybe I overlooked or somehow, but when do we have the assumption
> that common memory is definitely onlined ?
> 

For this particular case it's not particularly relevant.

This code only runs at init time, so it's either got memory or it
doesn't.  If the memory is present but offline, it still wants weights.

There isn't really a bug here, but the existing code could also just
check N_MEMORY and end up with the same result.  If the memory is
hotplugged later, it still gets weights accordingly.

-- 
~Gregory


