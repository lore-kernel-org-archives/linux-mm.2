Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 265A3D39418
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897156B0088; Thu,  2 Apr 2026 08:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848366B0089; Thu,  2 Apr 2026 08:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E0A6B008A; Thu,  2 Apr 2026 08:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 682CB6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:25:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11124C23FA
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:25:02 +0000 (UTC)
X-FDA: 84613535244.06.4A6BE0E
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id E1E7E80010
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:24:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OCMbu1BU;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775132700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWNBOu549I6UawEB8azvVtlnMXVCESZYifMy8KsFwjs=;
	b=k5sxt937qf9tnYwwD0DMFAE5QYWW1sHHpNasPzgXViluksm0OkDowRFYhukTTVo9kWu6VZ
	qg778Ra6MdZrfnUBPviuonKS7AUOu/P8Yt7jK0ZE//KiHD4GrIzii4WEUDnC0dQaB1jo0e
	J9yzYXcNa09utBBTIS5An1/1ezf8ipA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775132700; a=rsa-sha256;
	cv=none;
	b=KX774ZMdQQ+NCg1uErc2w5paTWQ4uXtfJrw8rtJbiZiepwj2VYpARPY0mHcQPmPZB+D2xT
	jGscYyDFdTrWVH3IeUDVP7vSBhUf+GQEi+VVfHDhypr4v1w+ZuKYOj+ip/lFxe+XxH4vc1
	t9N3H8dayVVWnL2lwcgtY/JyrMo7RYg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OCMbu1BU;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48702d51cd0so10213705e9.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 05:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775132698; x=1775737498; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pWNBOu549I6UawEB8azvVtlnMXVCESZYifMy8KsFwjs=;
        b=OCMbu1BU+Vdsa3JoM44xwbmpnFb9OtCQxUIHF9O730DB+in8v0RdaCYZHp97hAW4wp
         bStyMxnPriawngP/ePW9/oGILMqy9gZ+IMXhgi3Gc9N2iyTyI/PHXd+ukpDfCQjZInZe
         BjQR6hSbjDKqXqkx+LENsTFCwaHzwEvgKBKvZTOxHLzZ0FqjXlHM4+uIGpvZT2JqnYI7
         hXkV1U0jY4MUoMOOGAtixHUzyH6b45fLdtd+1kiqL8RDn33PxaGjB3Hn44yzwcJuNQ6E
         aVyuoV8q+0Nv80kIS7ThlH4WqjM4fLshQxpAz70m9QbVxoLhC6PKwqvtWx6NLV9E/XN1
         HEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775132698; x=1775737498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWNBOu549I6UawEB8azvVtlnMXVCESZYifMy8KsFwjs=;
        b=oBzaCGKXo+jveE9yVq1YVQS98zqZ+MmUOGJL7s1F+wEhqvnWFZ0at6aaefdSJnK0C9
         KB+MUTOh4o1DQAkv3mKGwVOmUoxbqXFnINLmdRrJJtCCxvk6gS8CBfLY5du8WF7yPp62
         DpBmjNsACJNA+CnhrPiPkvqHXY0q9bnsmI5svn4iDpTzuJY0ZDpuHDanrBeK5MrCDuLQ
         cjpDQwoC5Re3uexJ30amRgZ6felLLgjg8AZEd0xKgPcdjlYBGuB83536b44gjNPp0GjB
         cEYnhLR2IBiwM6vpwgmA4+KNqSonueT5S5Q/dMtUvyB7H2d+H+G/xjdhS6sqXOugVMBW
         DhtQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7tUSlFaPcEnd+8QdAAlR1FRg6kvZPTLYs7eSHzjqwYnPdewZ8/645HiLgNSE9De5XMKFMhjs4sQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7geZfTYRqsYcSjJAQh8pI9XddFLDQ3QB7TGgkitQBtfgVxTPW
	Q0QG/KXXf7I8tcPQ6I92np85kiQJ4Urg3ZKKEbqvi3JxWLLLBvZUh2vaIsmf9Wh3dV4YbaycjOE
	LzgYFe2k=
X-Gm-Gg: ATEYQzwDbmwfOgr5jGH1w0MWBZaiEL3sSKeLbGHP3pcY8vnMoxggZbuDAye6re9Y1oV
	SXBjWAnl04eFbDONrXRBMOBGT5RSomc4JJN/u6+5tkqzs4fQACdiBtdd5CAAdy6eRsrgtXd8iNM
	6HFQawkigxw9zb+lT9VLraG2LKDS/gdhYRYjdTSCpv11hkbMhPx4MHoU3QqrsFOGDgSEkH2iiMQ
	eEmV/ILEQYUI0a17q2JOOh8he4dsDJVTMEixXuA8YM+abPuadxSvgPKfxZiyeUy7ynCO4w2pmjz
	Cxk0glHTRDU6noFtRQUUtaVJtwU6YrwZ9mMM4JeZehv9b6rz+/d/YPrB3Z5dDNAbsxEKF++j+9y
	JZ3aQdMhr6xzTcJHlt+4sNH1JVlDlfno6BXkJpskoBUWv646WntxIPB4fy5HU1zYvGiPZ6BjI+S
	+27X4f5k7Ij5A39PNU/jZB2q/tbcBsD3M=
X-Received: by 2002:a05:600c:821a:b0:486:fdba:f5db with SMTP id 5b1f17b1804b1-48883307a37mr124889995e9.0.1775132698332;
        Thu, 02 Apr 2026 05:24:58 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d282esm7670221f8f.18.2026.04.02.05.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 05:24:57 -0700 (PDT)
Date: Thu, 2 Apr 2026 14:24:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Message-ID: <ac5gGS5eMFFCNaqH@tiehlicka>
References: <acqG2Mr5ekCn2HD0@tiehlicka>
 <20260330145608.3574897-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330145608.3574897-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 4am5i9duso4u6qqeexacj5cz1oatkyib
X-Rspamd-Queue-Id: E1E7E80010
X-Rspam-User: 
X-HE-Tag: 1775132699-701772
X-HE-Meta: U2FsdGVkX19eozMSrAYRSpIShZ7ULSIERXGgiCIctT9nqtD31Ie7JpugXEO3ArHyj9RNUcgbSNvOZmYR9h8AE+0ceBrXelrsSf2LoxE7+3cAmZbZdsyjgXEDKX3UtQ9hVCAIvvVH7D/xBfOoGlEKIG7gp7Dy+duR3rARgE2CfYV4AeNTkl8ZmT4nPO0002cqchW62ipPn9QL1RMmnjDJSGDXf9JtONgSsUGU45fvZ8J58RlG2/MEWryWUECNFNciA7tVqBVscPo4yQTl56wvqa4WgSZNm1dhVnIVPGlmHtZ//m1AGXWnaYQjkzTmagvnDqOgrjYSFCAugQIvfgO+53ZH3+xFnajvKX/9dLut8+xazZVsChKsRUTOSqxeEc33HNctJUufX6HgQNEBv96x6GC95EUOGiKIgcC7xVu764VCyvuIoVOO7D5iUkqrLu5xOETw0TEbhQv3uIPg5MwnSilvqCSHfLNf/UwsAyKxtmfR9EuW24NMQrZlPcsefjQJvZsR9FlMSycsfmJlIYngRIwORYp6Zj8/9Iz3nJ1LYsfHbyMsOdjLlTaicnmXPvjHubjmglZxc8bbvDFmqBC6Wv7KiXSf0ZBM9fEeOdcanEXq+tz9k2VGZjm/lz+xDnvFRMOgdYUH65IXv2ZW94Kq8KD2T7a465MBe4S+3dsHz4m8INcWAwMfEv70IoPrrHGH9qyItWOvE9gUCPSzOq+x0GAdx6v+X9Lkg5kswThkNZytR7wOjXiL9JjXuZA8QAqJY+acbYT2R0jr6lPwtIK740bKcGQNubRdFBjXcwxdSHIM7dRqNPZ6g9ppouCYO0MqLXSIgN0RsQ1luevzFFFNX9cdWL2MwEC+XeOoTvyoultWrGAvXZ6xfBq1a5/wpOTCWYI1LNj4VS1u2KZahWE1825QNsbI7YuMJQvQK0aNMyqvYhcl0Ipa3JIXZee+qdsUwRhkB0vEZZVSs50IG//
 plfOfhGN
 7dp4G0EVV+QywSE0U5KBZXjLlmMUrnBcVkExk6cIlVtLsT+3Lm/mgdri+63L9acoZjcOiOQ/Y/UqBZkXWKktWjOrOLjpcpyUfG8+dD8snKCs1cQMZkA9lV37w2IpkHUfhtcpeZtEYWUN9YjjNan53AKr2b7f9LMOjt7R4/C+Ay6b5b7TOlatK+DoE7gsPX3hAJihQcrNaoZ6M2dlrmVt5kXV/7CW/ApVZAbJlPZJThEBRbn1g0uH2Kapo87e3GYk2pvNZark6x8Xcqf0R2cXeG8BtESb6B5KqlFAlYggnc4+Snjp110pjkmYpOM0RlaJ2M5AVjcItdj5Wz1/KQFGkoFNSdKLNaMivEFz+PYHIOsGRxp2TcXUzkBLnk7A6FrtL+fzD5i1kYxi3rjB30/Df9/FEw0ww9UlogevyszLDYIbbrtipidTzCqXZ0hmHdphRzbTLeUgf9EvrAiEe6LNin8I9v08w3Z5LJEbDBA65rIt0YW/+ru27y4XR7pNm0+rwdhqfpKukmqob6W7bWuj34wjk0Riqhirw2eSy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, I got side tracked and didn't get to your follow up yet. I will
try sometimes next week. Please poke if I do not respond.

-- 
Michal Hocko
SUSE Labs

