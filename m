Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B21CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B586B008C; Sun, 10 May 2026 22:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13A56B0092; Sun, 10 May 2026 22:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A020A6B0093; Sun, 10 May 2026 22:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5726B008C
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:49:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13583C202B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:49:39 +0000 (UTC)
X-FDA: 84753608478.25.636CE6F
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 58F3420007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:49:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rx/sUNmw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778467777; a=rsa-sha256;
	cv=none;
	b=HWO3UT04C5xEozuvoPDZEQSHGaJG3hkMNc7kkoOGJWQaTvMLTjeo8MJBJtD4i0sckKYOwh
	igwZITlPeCSy4I4xEooCOTKgDOZMXiep3PJivgqn6iSop50xzaVeNuJthL2Ngome7HcCGr
	2YiQYAhk61rwLUPMBCE9OELJ2EvX/d4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rx/sUNmw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778467777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8yhCRo8NzonWlSii0d9l+VLVr8OjGe8OGS49wtMk6g=;
	b=qaPy+nU53ZPtrneVvTi+TSWV1dM0a5FGtRRf/9tuAYnO7aOZj/Zwp9hAcy4OMNgNCkTgxI
	JW8yq1/30tAbnsv78racvs88b/BN4baLyY3FC1SNtsmzAW/gbpQ5zphY1nacYyTtD2Gi4Y
	N53sWthpEZOTUNJ5CATjOEliNcujjM8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778467773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q8yhCRo8NzonWlSii0d9l+VLVr8OjGe8OGS49wtMk6g=;
	b=rx/sUNmwJV38UnKGxGVDoFaVY5c0MfDnP18yB86HQKy5DCPvh9xUtiIVRFapNtZ6lZYqnq
	aBruLqAnQFzM0rGCKVavU2HEzKESK0BSehaX2up3LPg3lmYoSk9UJvRFfeZ+QKY9f82A0y
	m6tuvn+E1nFVUyJ0kHl7DbC0/hqMz1c=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/shrinker: avoid out-of-bounds read in
 set_shrinker_bit()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260510183700.102475-1-devnexen@gmail.com>
Date: Mon, 11 May 2026 10:48:41 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3E00B1F3-9C41-4E41-892B-81BE19C3757C@linux.dev>
References: <20260510183700.102475-1-devnexen@gmail.com>
To: David Carlier <devnexen@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: txkmewkwj17ocdewrjdzmkgw3eprgg5w
X-Rspam-User: 
X-Rspamd-Queue-Id: 58F3420007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778467777-368002
X-HE-Meta: U2FsdGVkX18oc4pmoTkeS1rbYdF33tF/SE9y8fdroMEfVLrwMxyXG39Wldl/zyR8K7KWLaohGAOT3S5nvbzh3CzKYbAaaIWEfF9enfKIUkNVQc+ymdRejlVgYeAGKomTItRCfbNuoo0uQBnkx/6hq2moBHSVDMTkOvbtjy4HiHBxmD0gz87RTTgZSwO0EdLKVEJnJ41zMoKN9BL2T0o0erlMlrZPYF3FmJmLG2I1tkQYNKrwGqJegBwz/NJYqaY9r+LFj7AjWfTlXCK0SN2gmxKLeNnBYOpzppE1Gc2W0zbj80mV5FUHuOzSQFNrv3Uelfftlt46SKNJZ2Oceb+Rr6hjhOaUjNOMrzrWIpT+RWj9TGTxiebwf9PCY8v3NTcWdXBX0PphyOQabfKm5khzETz7/5yynkH0CgoJhWVVHMdCXPRYts+kxMY0xB/wyOcI6ycI+i27pp/U17Tm5Nvz6FgLCa+kOGX+OctHOwRWO6umTAzmOBTm7Q3Xlp+rBHbIhk3ViSV5IFTw7pFHO8wMwssQIDGhvDi46XDtr9/It9nR5v1UF8WruW9lOf5uaVMrPa5fb6RfBImj0eOjYlzAee586Exc3KY20CZsVIMGqwMMxIPAi86mEEaQ3n31gfs3g9zmmfPUm6AEitj8UlnTtcMYJR0Z557304MRygYGeG4jbCeiDpLnVBFsScU9dN0RJlit8PmQBjy+n8Ar9a+7037H80SuAyVdqvlPCA9bpVCXkPxMyg5LdTKtFYCECukAMWnp0Q/+102Iu/kg8652mqTSY+8DOt8caNPln1zlM4BI7AtKmWTEHDGNLYgznP2Yez6ZlVOQx8+nMZQ8ysnO3vHE6nciR2jG6TGGeIk4D2UX8iQkeFBpguEGcAXmpQobkkuLH6feDx5EfuQDcPK5oDf8dOG/zI9vSXwzhO0vfjJNBGwGi6Ca1I8AF5i9h/yVRdWrIbJdSz/0LGsjG7J
 Z+h0Q3os
 NrDKnz5wP2YPE3TzvSzptohJAEjQs+sngwWRu6pV/kDGqGjBI2utur8hySuuH3rnzUk8eyBbfmtx9T3OstkJolM/RN8KWum6vVvxtmv2MajLvbJy2fsScN+nkhg7zEXmGsIUR7OyKhMyeqx3vbJjjg7hlwlVox7IK6wq/L5JH9t/EesVzKDUJEP1nw3CwsJzwzpdIxw4DWYuC/ZfVm9GS8zMkMe2tp7hawmVyiMvVq36XlbWZne+EBopegup/sfomyUAMSoYlIq1uNOfl1dhtmRoFF3yRnsLEYpA3TuAi31O1thlNviNRCM2jfiL+FAsafPxLH0JxbxskzV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 11, 2026, at 02:37, David Carlier <devnexen@gmail.com> wrote:
>=20
> set_shrinker_bit() reads info->unit[shrinker_id_to_index(shrinker_id)]
> before checking shrinker_id against info->map_nr_max, so an id past =
the
> currently visible map_nr_max reads past the unit[] array before the
> WARN_ON_ONCE() catches it.
>=20
> Move the load into the bounded branch.
>=20
> Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for =
shrinker_info::{map, nr_deferred}")
> Signed-off-by: David Carlier <devnexen@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


