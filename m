Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08E9E77361
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 14:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428416B008C; Wed, 24 Dec 2025 09:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E90C6B00A8; Wed, 24 Dec 2025 09:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336D46B00A9; Wed, 24 Dec 2025 09:51:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 214CC6B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:51:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B73C71602C1
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:51:21 +0000 (UTC)
X-FDA: 84254652762.20.6D975A9
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id A64F8C0016
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:51:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NvKppPY/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766587880; a=rsa-sha256;
	cv=none;
	b=uDRUtkYv+ynOLhgSvrHaE/8SZKgK5rLcZsOeofNOViwvbUvFOoxMXHYq6Eq4Hwq8hPdMBn
	c8cj+tZpq2gcbnWQsw8NBJy/4AY6iidVyh9JaytuS1n0ssoZDV53wN5zINhrFdnHlGYQ21
	tZUSUGFGk1mnCZmtdEmeMNI/g2jKkRM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NvKppPY/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766587880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoh76je9Y3Sm6zc0YLyPu6J6RebFiJwddemaqJXNDUQ=;
	b=F+eMzN8PXoh72ly1U5RM4ixtVuVa4ynIPSXML+XG9HV4rDigDrwhlRBMRLdv3lGHjDeDXI
	y1tLoiv1xFrTI0heDEMD3u12UEYp6UzoSHVyh/L9X9nNHEw3dZabrAhwI5Ht8thcHKrCXB
	30ZyoVBkia2f8OsYUTIOR/g6A+RJ76A=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766587877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yoh76je9Y3Sm6zc0YLyPu6J6RebFiJwddemaqJXNDUQ=;
	b=NvKppPY/LBc/y5r9Uxy9sDkzpg2e5Y348uqB7ay4FLX+k9Tdm2sZxSUermDM+sKVWI6vPI
	vzonrh+F9CaCZQcHYlpVt/H0D67eFs+eeQiCPnsNKNrLlGDcauHDMrLMtgU/f0LM4AUbL1
	UkxrbfC/5LD5mUiv/RvdFAy2UCX/b1A=
Date: Wed, 24 Dec 2025 14:51:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <23f6bad90dd7eb98a7fef00736b4aff21bbcad4d@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
To: "Harry Yoo" <harry.yoo@oracle.com>
Cc: "Qi Zheng" <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, "Qi Zheng" <zhengqi.arch@bytedance.com>
In-Reply-To: <aUunxoFxrx5hiIPy@hyeyoo>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <aUunxoFxrx5hiIPy@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A64F8C0016
X-Stat-Signature: q831n7ewjupbjm3pe6k6s5haf9uqxdeb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766587879-196792
X-HE-Meta: U2FsdGVkX18uNlJW7gPQf0DIysh3uQ1wDkxlaoX9hedI9TM1lQLNMd+N/DL7dWwG6DNg5f96ltiImHMaoIERb31uaUEVH60dK23jSS6fuTX426B+wN6WYFCvYXPkuhz+iQFsFK0dyuCm1WTBeE2InyjxdiEWcZ6RvC9WMdjXbesqujlRlIsHEte+7aat1NgjTUguTvrIBcdlLlN3QNDiFZyoQedR4yGFW7rNIo4a0qQEEbugylp42jc0ibmh6308ypFKy9ehTs0dk+7jQ0/svQ7sAWu65wtmexhfoYiiNoJb/ilB2DQFMHp4vW2Ck2/5hDd1pfwCz/ht8BeeZrjBig5KkXW/4V7lbrzjysChrBcRCGphVNL7rU4QmFZlbQUg7INxyhBQBF+E3Tmw/eVUHEUOKkwfBqeo1+24Tc/VktQyiUgecx3k5QOp+7Fw84XPmNhBq32Lf8uNr17K3w8ZQaXu3VX8afxIZM+0qg9yCl8Jzxcs+buC426jtQka0mLHypHmlBrbjWRWuN29DHMuSH6COT11sq1LwKhlnB7Chb9QXwk2GtEUeuqwC+eSVT+ZI+d+WpQPWxbOpjaojkhmHpY4c++S1cp/VCdlXdS+1PQlql8CgxDsJGTjBY0/KJ/SRgr6la8pn2tLErR8SVJxVtVygL+ThoKBlGCRwC/F4R2aGJqgyELp6GfyWtiud2BdLPs5ZRlryONbi42lc5A8VYR7yXo7IQ5bbBH85J2l8HSwr/xt0p8qiWgThNhx4h5vwe5PByHDqcMLLASai6+h8ySB8TzETXUnrEpwzHuRMp5vprbgOyiHwO/sYZZyaUuKRSPhP0nNpAWCAOVEhT2RarGMQfaTG8MtlmX3ePmNeVS9ruuUOAghn50H+JWdkbBKinh/Kj+eECAOJPwsULtevvOVq2WEIAv88Mw8Ol6SFfLm2moPsg46qrRJsESrBuAq5HFejf407f3qOh1MH+J
 pmjUL8H5
 0e/3yzi9bXEoiAM5RjOfIkvkj7JIPb9fgqX0kohVFwk037d9q4ydmnq5kVCMb8ydYeCk1wx1g0aYEdHntQKIe/9H0x92phGml7h+BCJIzbyVmpxXlEeSjAMYo62ZbyB/py5Czz6K/W9cj3aU/OE9DeGcsAtGKOV3spY1OXUZzhsx2cfrZYHacRmKre7NwDJjix4cW3o4I8a82WrxSjUe7h5fWg/Cx0cwGIpLAyTvhVPlbDoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

December 24, 2025 at 12:43 AM, "Harry Yoo" <harry.yoo@oracle.com> wrote:


>=20
>=20On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
>=20
>=20>=20
>=20> I think there might be a problem with non-hierarchical stats on cgr=
oup
> >  v1, I brought it up previously [*]. I am not sure if this was addres=
sed
> >  but I couldn't immediately find anything.
> >=20
>=20Hi, Yosry. Thanks for bringing this up!
>=20
>=20>=20
>=20> In short, if memory is charged to a dying cgroup at the time of
> >  reparenting, when the memory gets uncharged the stats updates will o=
ccur
> >  at the parent. This will update both hierarchical and non-hierarchic=
al
> >  stats of the parent, which would corrupt the parent's non-hierarchic=
al
> >  stats (because those counters were never incremented when the memory=
 was
> >  charged).
> >=20
>=20Hmm, I wonder if this only applies to LRU pages.
>=20
>=20In theory we should have this problem for NR_SLAB{UN,}RECLAIMABLE_B
> because we already reparent objcgs, or am I missing something?

We do, but we don't expose these stats in cgroup v1, and we don't expose =
non-hierarchical stats in cgroup v2.

