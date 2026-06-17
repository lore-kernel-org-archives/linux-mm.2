Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1931CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9950F6B0005; Wed, 17 Jun 2026 05:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946686B0088; Wed, 17 Jun 2026 05:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8836F6B008A; Wed, 17 Jun 2026 05:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4866B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:19:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C766712038F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:19:13 +0000 (UTC)
X-FDA: 84888855786.14.0C50E6C
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id D80F040011
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:19:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QPy5fbS0;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781687952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMQGqpgSC5EMLyUBnCorVPFjA76iXNC33Ltwj1O5yMQ=;
	b=1HR+ItMj5ggelF39FYgEmnj4OsAqXgKZjhyAwTzDckF8q0+fI0zbTmcrrG2HFZIURMIagS
	FetGnIXFXUKCp9ycXGpd/V1wlbd4ezfV1jioIU3PH41xMoy+0K78kYdNmDiveF/6LR5jvH
	f2fHFJdNBq92IniSoY7Ux8oG3RQOD6A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QPy5fbS0;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781687952;
	b=Ju17mpfCI/9/vxKIkjo1At0R/fsFEkl4aqS6DtbbhjIjZ2pNGzf3A9lDPWHXqTfyewCN4M
	BD547LM7CI+oUzYNF+6orbaq//+mQNe9iLT4rWjBGOCyP66ZqRJ8hdLGT4Hp7Z+y3VLgjO
	BdVh3krN/dBm3NWC8+mxxIbBuJ+BiCI=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781687950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMQGqpgSC5EMLyUBnCorVPFjA76iXNC33Ltwj1O5yMQ=;
	b=QPy5fbS0RybOo1ITfmRGYOxj37GMmK1I1T8rjl+fDmd6rf2JhYAMwF9D5oAvzGpAGOTjmP
	veiggTaNCIb8k2GPskVwl6CCKSfXJtrbVE2aLN4iYda++M3j6OffFni1+oWG7C0ojDvSGc
	dukv9z/KDBkRJpbWj8PcGFu2gt2rE/I=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: shrinker: fix shrinker_info teardown race with
 expansion
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260617085658.27096-1-qi.zheng@linux.dev>
Date: Wed, 17 Jun 2026 17:18:07 +0800
Cc: akpm@linux-foundation.org,
 david@fromorbit.com,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D326325D-79A4-473F-9C63-B875176F378E@linux.dev>
References: <20260617085658.27096-1-qi.zheng@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D80F040011
X-Stat-Signature: tsftwduxbwzhown388bobr856hmpbx8o
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781687951-553196
X-HE-Meta: U2FsdGVkX19DgHwozexg+jF2RRrDUgFNbJoVstvtdQ7fMXb2MhgRTIuqMRyE0FCyLo+KTkrYBxUcD5T6kBW8BWMS7rX9YnySSs2q/WDebtQeenNomVxj+hkp8qms/kp1/qdIdB299B0Ei6HjjjwZBnhu4w+dC/1l4SrC5BmyAD2wVd5uOMdxKgiy0pWmJSrJd3u1lpa7fJ3CLNRTQGvLme0CQRC1JeO2PzPnPUBto6DIuZDDcs/AlYQNHNMAw+ddUIUSS0R/APZ3IA1mRZcZcRS5M1QWvXFFuS/VL76kebn4JdSzROUVbCw+053LNaCeTZAhsa5dHQ+wpuGj5SQb612e3glTAjhqzeRNa/A659USST0wUYoGtoTcc49hky9LQM5gD7cJ9zjzb+S5Jrh/ixaFy6bPWZdur4YRPbWgLga5mcJD10V9lJxi3/yhTZr6MyTVI5UGPSPaKrHGH1ql2qat4Hhdnjxy5mziajM+l+sAODbwHpC2xfirD/ipjDWy6zVZyHH7krEnbUq/mDDdedoiOHRso0dto7X2K5q+WENxwgwCGIWIuwbHnIQOhjTzKrIEFdnP9WLA0ikyXoRASUlUl0vq8vY/Hks+8pjaK9yzqSyIqGLK9x+/uSB4MLkhwBJ+vRqVcIElwxjkT3c3+EUdXUIsH7Wrs41PPIa/J0JTURlabYxMn4C0tRGCJg2NvaD80rdtlbNcuC+AGU+9RzBldn/kLsMhwCvkijeuBFNHT/GSsKnCBavd8IOWjzG7EF/qDcEFgQXhHpBokJDartyyz+Z38f+Bs/SYGNQFI03JCCebdPSZ1G+bQ6ulI74AaL6KV01CwDdK/tpL2fPNeNZm77Tk1fpw74ukPX1/dtwQrnrBBXy7lRXqvJI6A2xSPKZLgcBxo1ANcyqH1OhtHW775Mmq6RT5HeaiPXutV9iYUMUqU1Womw7CxHLD732NSthPm3raJCAJyDBXBE9
 OoSDk42H
 8HW/44k1D2h610Q58rjHspoGyvaLwDMUTsAQNK1ufIhrD/wagdpDUNlOGQBmSOvx1Qde5aJvdtg7gM9HuTiyAIEzPBOP3oWiEOvXJq6cLZX4kUvpfC3aBFyRcXyIsgSK/KdqPS9LAVgzYjUdHC9ykThqa+qONVyAn3VztOUjtNV7ro5YZoWAbGZweiZ30OS04+eCufwK98Pj3dw/M5mpnINoPcxZZUWboEXaQaw9cuDtFCGF86RbbICpXEa3y1jHMIiCOWxQo58xK0R10EEuqgpsi71pu69umQ0p0UiwTswpD9Da5x6OnyXMkSHP9ph8BFv/a9cVJ2tzOfKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 17, 2026, at 16:56, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> The expand_shrinker_info() iterates all visible memcgs under
> shrinker_mutex, including memcgs that have not finished ->css_online()
> yet.
>=20
> Once pn->shrinker_info has been published, teardown must stay =
serialized
> with expand_shrinker_info() until that memcg is either fully online or
> no longer visible to iteration. Today alloc_shrinker_info() breaks =
that
> rule by dropping shrinker_mutex before freeing a partially initialized
> shrinker_info array, which may cause the following race:
>=20
> CPU0                   CPU1
> =3D=3D=3D=3D                   =3D=3D=3D=3D
>=20
> css_create
> --> list_add_tail_rcu(&css->sibling, &parent_css->children);
>    online_css
>    --> mem_cgroup_css_online
>        --> alloc_shrinker_info
>            --> alloc node0 info
>                rcu_assign_pointer(C->node0->shrinker_info, old0)
>                alloc node1 info -> FAIL -> goto err
>                mutex_unlock(shrinker_mutex)
>=20
>                       shrinker_alloc()
>                       --> shrinker_memcg_alloc
>                           --> mutex_lock(shrinker_mutex)
>                               expand_shrinker_info
>                               --> mem_cgroup_iter see the memcg
>                                   expand_one_shrinker_info
>                                   --> old0 =3D C->node0->shrinker_info
>                                       memcpy(new->unit, old0->unit, =
...);
>=20
>                free_shrinker_info
>                --> kvfree(old0);
>=20
>                                       /* double free !! */
>                                       kvfree_rcu(old0, rcu);
>=20
> The same problem exists later in mem_cgroup_css_online(). If
> alloc_shrinker_info() succeeds but a subsequent objcg allocation =
fails,
> the free_objcg -> free_shrinker_info() unwind path tears down the =
already
> published pn->shrinker_info arrays without shrinker_mutex. The
> expand_one_shrinker_info() can race with that teardown in the same =
way,
> leading to use-after-free or double-free of the old shrinker_info.
>=20
> Fix this by serializing shrinker_info teardown with shrinker_mutex, =
and by
> keeping alloc_shrinker_info() error cleanup inside the locked section.
>=20
> Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for =
shrinker_info::{map, nr_deferred}")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


