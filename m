Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885FFC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D9D6B009D; Mon,  7 Sep 2026 08:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF016B009E; Mon,  7 Sep 2026 08:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD0D6B009F; Mon,  7 Sep 2026 08:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 637856B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:09:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73AB3120127
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:09:33 +0000 (UTC)
X-FDA: 85186846626.06.90E805A
Received: from cu-gy11p00im-quki08153201.gy.silu.net (cu-gy11p00im-quki08153201.gy.silu.net [157.255.1.67])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55F91100005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:09:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HVEu8xhS;
	spf=pass (imf14.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.67 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788782971;
	b=hqX90lHDbr+RtXFGhKaPtrSnzC//tad2X6T7rFE4jvudNGgM/g50XXjEIp4polheDANMER
	LCN3xFBrkenA6/yOPGJqWWaR+eqYJmHvYYiVcPbiHwJP+U0MTJaZNNMquJFH6xZCjuwB+d
	H45nUsU4Vw5qSIJVXXXZcPf/7AdEXwo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HVEu8xhS;
	spf=pass (imf14.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.67 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788782971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YnIWUzBq9n0gJzBTdfIFMYDRu6uiLWYe+l44kVXkrk=;
	b=ETVdgr9g+Bza+dqZUDH4WLu1CvqM/9huiVdOOfYQ0dZfYIGuskKmX2FGgR4TEmzlMwLEYi
	trvGAQv8WLr95qUsCdZgHl13XxqzONNRmv1CGaCVkHbFOrSf9xdvvQDgJxg7kEXblhwiW4
	NpuYc2tD8lSgpzOD29bIgBKNZxVB7W8=
Received: from smtpclient.apple (gy11p00im-asmtpcmvip.gy.silu.net [112.19.199.76])
	by gy11p00im-quki08153201.gy.silu.net (Postfix) with ESMTPSA id 98C9B24600BF;
	Mon,  7 Sep 2026 12:09:22 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788782967; x=1791374967; bh=3YnIWUzBq9n0gJzBTdfIFMYDRu6uiLWYe+l44kVXkrk=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=HVEu8xhSfSb+VquGtfp4oe+zpOkceINU+/+TFp33gMNUvPRSLsxjtXVsiEBXxxl0OaAbLJm4xdevpXp9sNtdZ3YrpjTPZkgez2FTHhcnmm4gGXmQNjOfXUh27puQfmuQTVsveZEymL97r6N1S2MnH8SGxsfDCEA669pyLCLwsE0J9nfez/zj2yq0X8cHYcQmVewu06xA5BRF5OvFE/g1W89JoWN7sc6UTKaGDFNZwrmhUrBjOf7jFdJkuYmRToL0hRASE5GHH6YF6ql6E+62PBXzJWaxf30J8ve2fVIm12DPFxI/oQp1QzUQJLWML6sJLmq5Y2aozz1Tzoijyj/gQQ==
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH RFC v2 3/6] mm/memcg: pass the id itself instead of memcg
 for putting ID
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
Date: Mon, 7 Sep 2026 20:08:56 +0800
Cc: bingfangguo@tencent.com,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F14C600B-D8AB-40E1-97B5-D3B354BA9E1B@icloud.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
 <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-ORIG-GUID: hSpqanX9zO9iIYtdsWNxFt_LhSorxX3u
X-Proofpoint-GUID: hSpqanX9zO9iIYtdsWNxFt_LhSorxX3u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExNSBTYWx0ZWRfXwFWvk7Tns3eP
 QdmEr2P8kYx7kOOmbXky6GAaMBsP37rs+iOaViQXa5ktAJMa+oJtPSnmBCCkky/UIWDMadkKTNh
 pD41TDaUxVejkoI3VuoQi6IQVhE/zvCS2uWtL9EO6MWR80QeSFZJ9EjmtJxX4OtguZNbASn7oNP
 VcSnL+pEllZvh1hG+c/fDl9peMd1VMg575W0HquuTUWoLO6jie50ncvubZi+ueYiBYdu5I3mIKf
 pP63eUw13EpsqBEGyWpIwfvqg4GvDDHHo8nzHosjARRjNLVs3eC7RM18dNesQGg4GmT/Z0gG6tF
 wsnSqyY4p5xDBThZvrFaay6pld+qgiIj8DZsI5i7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 clxscore=-2147483648 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2609070115
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 55F91100005
X-Stat-Signature: p54sfs7418ga3s6hiakyanhjap949hct
X-Rspam-User: 
X-HE-Tag: 1788782971-33625
X-HE-Meta: U2FsdGVkX1/s8SVaQ704BEJ8vlCZFllfJRxCqaUo3m1LFxbG7VKET4VDA/m+PTs72zA5WiPTD7kdSMri+pd6kpVf46p86SeF8GxSTfJ2xeTDdjnxJaIE7/bg57DauK2r+TDN5jfyqAe80G7O9aLqZkiDBXUkewt6pximVlHjmhXUVbPPyeJN0I3Yw4WlDoXClkFNYMNbMFV7imv2l2gSNjmSQFDPLQf8ZmxzGtEGd8VcfMgXX0xYgWfZHhEV2rbmfAHB9g35HbtNA2FdtbKxhoUK0IBcBQHx4/is8TXZ3/haBtVpzQTbQRU6zm6XuBT/Ly+VDMRZkIGbhIkggyegjG337YRN4vnVVwORLBHfLkTpcB6B+Ohj2/eNDb8tOmbqc/F3Fv5AfmN0onxT+oR4u0Hi8SiCX9Acf6PJiG9sRrnDr+jds0MpvECjhVYHyuS2R6UqHYRCFWD1LjAG9Ysck+fLO9j2jr6YOb4rs3z68UliPd2zGJPqZiYTgzvYayF5MBZG/gxlp1mT75bo9tMgNmi7x8wATnyw2IE9vsgd9fLHKO2n+6lgOIZcf9Vuzpm1D4czF27WWDcHppQub6ZYKozkr7YAc1A7OXytv5gO+YDGBQZupSQFu4bxD6RCnjT1ldGyD2TqcOdA7VYG9yd/JAkMokdSknY1kM3WhX0nzwuLaAECfrOcYShqBQbXlDIJbwWDYnvuZOIg2nuJfuUtdWtO6VHDT2o7XtetEOJ4bP5/ml2cVUTcq6dNHkBoBeKfpth7gzdO4RQkDXLj6NvzrdcKmZwZcGkRlx4Vf2SPCRnyb21eZ6I/0RyB3N5G4EiEqkppTb9/UghFPa39CxWJs9BLydGxZzO+IXYbPPhxlP3FZGql1WyyXjM78i44ZTz/bmPGUEXpIVO7AN5dz9tNQUmINzkEP3Dd0wCmXyR2VCjWDgZnA/IpI9Qr2Wa7i5xWZDKkD9E6pwxH6KuK9mJ
 eGCvb8yQ
 nGkraF/FftEJtLG/JryJJkm19/2GEtj/ErETMUsP1StbHI+5nJRaQYhgOmRmeirIMVYCMNskXmmnr5/tOHZ4JoAOrT1XrwGOp9j01gN5/A71j66GJB1HYBMZGbFaQW5Lz+PzZgUC1nqkFZkDoxtyMFjwWGIJYhWd8dcJQsR3FhUaTgh1H/k8j2JQIoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 06:01:44PM +0800, Muchun Song wrote:
>=20
>=20
> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
>> From: Bingfang Guo <bingfangguo@tencent.com>
>>=20
>> Swap uncharge knows the memcg only by its private id, and the id can
>> outlive the memcg it used to belong to after we rebind memcgid to
>> objcgs.  Make mem_cgroup_private_id_put() take the id and resolve the
>> memcg containing the refcount internally, and keep the underlying
>> __mem_cgroup_private_id_put() for the offline path that still holds a
>> memcg pointer.
>>=20
>> In the uncharge path, the memcg pointer will have to be read from the
>> xarray twice, but we'll fix that later by returning the memcg from =
the
>> put path, so the uncharge path can obtain a reference in the same =
step.
>>=20
>> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
>> ---
>> mm/memcontrol.c | 17 ++++++++++++++---
>> 1 file changed, 14 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index ecb4fb07d7735..048c9bb0fad79 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4038,7 +4038,7 @@ static void mem_cgroup_private_id_remove(struct =
mem_cgroup *memcg)
>> 	}
>> }
>> -static inline void mem_cgroup_private_id_put(struct mem_cgroup =
*memcg, unsigned int n)
>> +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, =
unsigned int n)
>> {
>> 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
>> 		mem_cgroup_private_id_remove(memcg);
>> @@ -4048,9 +4048,19 @@ static inline void =
mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
>> 	}
>> }
>> +static void mem_cgroup_private_id_put(unsigned short id, unsigned =
int n)
>> +{
>> +	struct mem_cgroup *memcg;
>> +
>> +	rcu_read_lock();
>> +	memcg =3D mem_cgroup_from_private_id(id);
>> +	__mem_cgroup_private_id_put(memcg, n);
>> +	rcu_read_unlock();
>> +}
>=20
> To me, the direction of this change makes sense. At the same
> time, I would also suggest applying a similar change to the get
> function, for example: change mem_cgroup_private_id_get_online
> to:
>=20
>    unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg,
>                                             unsigned int n);
>=20
> Have it return a private ID. That way, I think the two interfaces
> look much more symmetrical overall.
>=20
> Based on this change, it should be easier to implement the
> direction of my last suggestion in Patch 5.
>=20
> Muchun,
> Thanks.
>=20

After taking a closer look at Patch 2, I find that charging the
counter before getting memcgid is problematic if the current
memcg is dying.

If the memcg is not root, the swap counter will be charged. But
if it is also dying, we'll get the root's ID and store that in
the swap table, which creates an inconsistent state and leak the
charge when we do swap uncharge, find that the corresponding
objcg is root and skip uncharging the counter.

On the other hand, if we restore the old logic to get an ID first
and then charge if the ID refers to a root objcg, we'll have to
access the xarray again to retrieve the objcg, or return the
objcg using a pointer in the parameter list. And both are not
ideal to me.

I think a better plan is to just check the root status of the
memcgid itself.  We can store the root memcg's ID just as
root_mem_cgroup and add a function:

  bool mem_cgroup_private_id_is_root(unsigned short id);

This makes memcgid related operations a family: we have get, put
and can check its root status independently, without having to go
through another object.  And we can use it to decide whether we
should skip root charge/uncharge for all three functions
(memcgv1, swap charge and uncharge).

>> +
>> static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
>> {
>> -	mem_cgroup_private_id_put(memcg, 1);
>> +	__mem_cgroup_private_id_put(memcg, 1);
>> }
>> struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup =
*memcg, unsigned int n)
>> @@ -5815,9 +5825,10 @@ void __mem_cgroup_uncharge_swap(unsigned short =
id, unsigned int nr_pages)
>> 				page_counter_uncharge(&memcg->swap, =
nr_pages);
>> 		}
>> 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
>> -		mem_cgroup_private_id_put(memcg, nr_pages);
>> +		mem_cgroup_private_id_put(id, nr_pages);
>> 	}
>> 	rcu_read_unlock();
>> +
>> }
>> long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>>=20
>=20


