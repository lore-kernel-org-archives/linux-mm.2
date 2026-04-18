Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF24F8DFFF
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 08:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BC0D6B01A3; Sat, 18 Apr 2026 04:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245B06B01A4; Sat, 18 Apr 2026 04:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EB16B01A5; Sat, 18 Apr 2026 04:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFA5D6B01A3
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:55:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84918E4636
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:55:29 +0000 (UTC)
X-FDA: 84671067978.23.046D8AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B69DD40002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:55:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LP534YJP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776502527; a=rsa-sha256;
	cv=none;
	b=Mw2/pvlRvhcXZBnMQUmQ9aukNCyG3aaes+km+wWDb5ZsVsB8o4QU3BVtEyIzf9JXZ5rzCe
	YNHpuZmhpWz4vfZu7kXslNwfEltHhUv3CA3/JrohRwjyS1QgY/XG2ZxALvcEkSCBBG1Hb0
	T1qhfFRxfXM80WumgcixhwTvtEEw+yI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LP534YJP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776502527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwep7qXAOXFgSRE8p5CjBLEPPmj46K6JEzufHKXWTv8=;
	b=30dfd2IOt1GUZ8Az7cqNcHuXcz2vJOOKl9I0Tca7ytpXaF8Hey24zgq742/KW/i015q0LF
	mVGJccUsgjFf0tWlt8cDewNCFXYerSq8w7Ro5aN1mM5V9k+XkfEglpTtEKF9Cx9Ldxq8Jk
	pwHbBqUTIyg69zHfsEVtrPPP87AKIs4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB65360139
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8989FC2BCB5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776502526;
	bh=gwep7qXAOXFgSRE8p5CjBLEPPmj46K6JEzufHKXWTv8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LP534YJPkYuxXK33tEiYc1O4kxnociZjw0dJTdWyIbPyvacrK1tC72vff2iQsU02m
	 KtobWz2r35dyq+XnwsjkskurAKyAaEe7JFilGEgQwxSYghFaKAIO0EAoZOo9PEpH7Z
	 q+VIlMM+Xq9mO+TK2CdX0hpoR4rjV5tMO01yVT12X+/+MtCCXPD24zGKwHZ0r0kqid
	 IlpIGvIETV76LLs9/5FYRC3lWtHrLfvIq3Iq5AKrtzOK4UqLgDe14HvUM7McL3QJyL
	 oXVzmfaR9blzNo4oPyb2HZ98WAo+Tdp9nuKn2COEHwi2Khjaf9i/OyV/9YVPQBX6DU
	 RpmodOnigbLnA==
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50697d6a69cso7532491cf.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:55:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/vaH+lPWC/UYwXAMAcQS+SWjC4IgcUPkQyw4oKQgX97fZE6saBqcDG331lX9s0PyK0fnXYDuq9uw==@kvack.org
X-Gm-Message-State: AOJu0YxBGYQ9LTSxAHQdfn7xHT0s0zYChUQssCRc1cqO1+/tn8cg0v3i
	YJfkVjYx59yi3X/uNePaHXpWItKTzjuaftqrQronxoXiHUeQeAYQEUe4URkJPD5UTo7oQ+gEBBw
	uRoRi1oxN0ijurO7UHrHxmP6LZN1eyno=
X-Received: by 2002:a05:622a:13ca:b0:509:1470:d3b2 with SMTP id
 d75a77b69052e-50e36ca15abmr84581761cf.60.1776502525803; Sat, 18 Apr 2026
 01:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260417025123.2971253-1-wxy2009nrrr@163.com> <3a28d9d327d84ae192fb3dcb925a0674@honor.com>
In-Reply-To: <3a28d9d327d84ae192fb3dcb925a0674@honor.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 18 Apr 2026 16:55:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wgM_PHGtmsJGjDYykgT4WP4PHYXbVV029XF-7PPVpjEw@mail.gmail.com>
X-Gm-Features: AQROBzCJ1gCaivomkDW20N-_qm8Gvj85y2sY2ml8XUWgnv2HzzBzqcGeXhTKxmQ
Message-ID: <CAGsJ_4wgM_PHGtmsJGjDYykgT4WP4PHYXbVV029XF-7PPVpjEw@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: wangzicheng <wangzicheng@honor.com>
Cc: wangxinyu19 <wxy2009nrrr@163.com>, 
	"devnull+kasong.tencent.com@kernel.org" <devnull+kasong.tencent.com@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"chenridong@huaweicloud.com" <chenridong@huaweicloud.com>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"david@kernel.org" <david@kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"kaleshsingh@google.com" <kaleshsingh@google.com>, "kasong@tencent.com" <kasong@tencent.com>, 
	"laoar.shao@gmail.com" <laoar.shao@gmail.com>, "lenohou@gmail.com" <lenohou@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "mhocko@kernel.org" <mhocko@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"stevensd@google.com" <stevensd@google.com>, "surenb@google.com" <surenb@google.com>, 
	"vernon2gm@gmail.com" <vernon2gm@gmail.com>, "weixugc@google.com" <weixugc@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "yuzhao@google.com" <yuzhao@google.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, wangzhen <wangzhen5@honor.com>, 
	wangtao <tao.wangtao@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B69DD40002
X-Rspamd-Server: rspam12
X-Stat-Signature: x5t91mcfbjncagsdewfi8uannnotzy6i
X-Rspam-User: 
X-HE-Tag: 1776502527-982310
X-HE-Meta: U2FsdGVkX1+fUMNMsJJxP0/LVc07XAapZLpR77MBp4lxMPGr/1GMN8pCZHO0Bj7g7tqq6HR1DioF0g1MpfvN6P89yd1w7c0OnXDCWkrZ2CrQRMLmfciHLWi/U2gIQqkR1vVr9/3vZrjBrgQBFaxojLnZ9d5bBtNp0mUBhLEaQeUSYzIHgbsQuqglA8PAZc73uItINV2+u0u/pKvXZh63CbwrC3ONaOv5lcHv4DOiojwtwQTgkQdu4elbnUB2TSmk8C5P0d1Es+AZ4YJ1BKBH1aUVkWnpmWITKs11Ql0JOG7s/S68736/NhdtIH3+g27kQeoRFnTCKvooK/CWB1ZB6uI2EUtuSI2UihY4fgI5UojEt4D+Gx4ebLRQ01oo+eGweHvxusBxVAFVUmV8fHahgma/Nxf8eTTI9Xh61yBKbb3YWKvdtbd4iV3Lb+ZkZt8CRVTsNwnAWvZu7lBICc0iXLXY1Axc30KMgAY0sS+YgL7UI/HM+bQnawd+jeU0rk1C9aY0IwhwbzxdqXh7cxAB4Pfr8a5cUd27NHDE54zvz3Af5+QzhNy2YQ/Jc47XHvOrn8N1q4QIfr3NgWmhd7Sjqpd/ZzzKL11OZM+iZVPci9hoOyQoOtx8Be2iL8TEFOUvVNDZW5AL4qhm3hyA8KK4x1luHZhG58O/eQZ21YgWc8O5F7rpZbIjJmERBLgA6L0rzcxBmVYMSTWhLDq5njPAcY64SF57Q66n0pbVL3iBhhuRyEL7nyxDlvRqPFIiEQmN4FC4KCJeSi9zdU1uVENVt5yLPYnpNdfmiVq5OKNl1dgQ68li9nX8++tm0t1SPLKvqxSk0HN9dojPK9+Gl/Bp2n2fdnW+ye9uyEjpeKScBUpdCZaN8r9e0K8rPi3JWsRlWMTW3+l6irubOZkfpARlqO+iWfFanedlbxLrs8UTWHSixoWiOuG4W72QW9oFh4hecmdO1r9gSTziuT4ZgmY
 Ga/jvVTJ
 dN1gwiupy5LPy7XhULNTmmuvBgLqSVgWsEQhnMguPZWc+UrVhGVNMDuQxwGriBwFKBn5pjDZeSYgZto8Gqdcl5U57Tj/aasG/z86I92g80OiycEHNwn6DNpzoybmhWnRs6mor1NPvw1KbQ2yB0q8yPuaQV1ZY4bVYPeyfUMsR4e2o3NmJqsEOdjPHsMOovZOx/qNbYsfc5OvTPmBm/WgNH33YLg/6+RwL7rclAzpUk35nogFjHznGLda131A/CmDzgnB/vNeBLqVKKglfeKFf9FBZuj7mZkOCOe7elugogyGwoJ7lIsTDyiM77EQatcm9yYFBBcgZufPVf6qPvF1A55ogEctz2NyG+Pu3EDGGyw5bpTuh4e/lfmbpBeb7w2pa1fXUisjocTVMIcNfeH1Gjo9SDcgaMz1UNFJ3T79iErQkuhcSMS/wljCnaCvCtZu8/IXzcm0AqnPysf5bwi4K5EjkYW4zMdeo3xsWmEPzYxRLZbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]
>
> The performance might behave differently on devices with smaller memory
> (e.g. 8=E2=80=9316GB) compared to servers with 100+GB memory, or under
> moderate to heavy memory pressure.
> Could this be related to patch 09/14[1] which removes folio_inc_gen()
> when ` writeback || (type =3D=3D LRU_GEN_FILE && dirty)`?

Very unlikely. I think this should be a positive change. Placing dirty
pages in the youngest generation helps avoid unnecessary scanning, and
they can still be rotated to the oldest generation once writeback is
complete.

>
> Any comments or suggestions would be appreciated.
>
> [1] https://lore.kernel.org/linux-mm/20260413-mglru-reclaim-v5-0-8eaeacbd=
dc44@tencent.com/T/#m568eba84d35d8d5ff519d3e29237de6d64f67659
>

Thanks
Barry

