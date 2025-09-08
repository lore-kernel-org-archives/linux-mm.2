Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C0BDCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 06:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1018E0006; Mon,  8 Sep 2025 02:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B598E0001; Mon,  8 Sep 2025 02:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261128E0006; Mon,  8 Sep 2025 02:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E48C8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:22:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A56245C30F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:22:11 +0000 (UTC)
X-FDA: 83865088062.30.635325F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE5D340004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:22:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MBdxnENF;
	spf=pass (imf27.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757312530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBmb7oUqdoCzhCm2AnJKPGujkmoHds2eGlcnyfX2ybM=;
	b=ymG2pTX5kMe8xrWK4+Sc61ZV6owPJ5x8QoOOLCveF4QEgZXC2hZa4Aj3TakeVwuNa4Ix3G
	oYc6ZbfqmImeJPzF+WvtHD0Gp1UqVgvzzOmFthVTv5Ou/3AEWDEmqdCd2OVyWw+af43orE
	Ax10pYT9tX+GkOebHQ+TOVYAifOph4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757312530; a=rsa-sha256;
	cv=none;
	b=GQpVyRBh/E7RbzDAZX4bYrO12+pSJWqJrZ5alcLRT2BJyMNRzMgC5Vew1kNbfDNqMh3IkB
	rEsOy2a7Elg7kJAt+s5BmMWsznLx5ykFuuhIOvtp+34oqk5rIQ3MeXkHOw0U0QXiy4TmqF
	sxrDghFk8pqm3ov8QQHtSRS5+HVDyi4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MBdxnENF;
	spf=pass (imf27.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757312526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBmb7oUqdoCzhCm2AnJKPGujkmoHds2eGlcnyfX2ybM=;
	b=MBdxnENF56/rocq2cL6js/NQd6A7dIVoaIMbB+jg891jIfODYfQjwTKbLuJ+5pzuuDEZr3
	nSTiOH0RaQSTRhLiVjm6f05Eu9VgCujxGdd/HHs/69cjBlMM+TmWJjT5uBk9MItk4PQsv8
	9we+U6N2RCoHXLcgdgdLTk3Eo4WLh+I=
Date: Mon, 08 Sep 2025 06:22:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jackie Liu" <liu.yun@linux.dev>
Message-ID: <53349cec552be79b9da6776ff778ea45fc3c4bf7@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/shmem: remove redundant entry_order variable in
 shmem_split_large_entry()
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: hughd@google.com, liuyun01@kylinos.cn
In-Reply-To: <888448f1-518b-49f2-9c91-1f4434777720@linux.alibaba.com>
References: <20250908023915.28907-1-liu.yun@linux.dev>
 <20250908023915.28907-2-liu.yun@linux.dev>
 <888448f1-518b-49f2-9c91-1f4434777720@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AE5D340004
X-Stat-Signature: jpj8eqarth1f5m33yb6ew8ub886emug9
X-HE-Tag: 1757312529-871457
X-HE-Meta: U2FsdGVkX1+OiMWG36+phhJd2FklVIFt3C573MQO60FRKPFijrpPA2MR/r/osgvBW+qWlkUSC+mbP82q+bm4vRFMMYpq2+So+D6Teg7Z1Yq8I9jJWBIeMZXdg1XYWbQIGFqAwlkEG7FJZV2lXTLTnxaTF8h+lPIX41nzldVsS+HULQtH6SN1UoslhI6fktMaYgrj9i1RQ9a3mDimR082TbljMVZ5vbsh2yIT2DPcTSZl8szEdZfmeUwQOjEcnJXlO5w8oPPXTF0q1fvPDr8iNRV512rMZ5/PTf7qfbl5u5x2PDTUbq+rDVVT/Qnoba0qRhZdFb0IW8HbF8CY0qi5sjp701IntZ5oMB4g+mccei8HA5e3IaKc9YuDXCU//rJJIeiRbdzguxt0zjhH0Ob7l0P4+B4EswOXltuqI1b2S7qK2pWmteYue7Ttaa4j2wwttqotLzH/M6MtBBqsGXLUD6piQdrFyo6VoAA94iOhql2hhRg7LMAM8sl83IXJ2LJzBjm8m99a+Xlst5xyQEX3MljDvn6NTBqWn3L0sm9BbFKxaBoYiKDDv6Q1MPPjmZOkuxjbTQFgb1WE52W3hQhWuKNHjnsgj9KCdb0uIAUilRasoZOKa0NQzs4r5gh1TDJKDz87SRGzOm55S0s9H2vIpzqAwTxuuu5qf5/qQvP97cpv0PfZy7eBG6SWwHUWYEa6Svz0nQovz25EHFqnrHG0U6bDaFQ+dKpTPHwJ6c2Az/5i881S+9h464hDZ3qbyVWe0h3N3uk3l+bDFKLPsZGLzCxiRtfH5PSlt8tccNNqIKM83MDUqBG/yXNbVGuyfubcVJewFXKvx1wb1gwS1GvaLsnHly2K2H8dexGGJFLpwRy+3ZamZh6rJ3ZM1hP4hsgd1VKdr0/tnvLYzy5XRw8ccrVIYjSwBkwSH6LcOdbpKDRKPf0HdGNIY3VPrBWg3lrAIVlF/VT0OHAsXK+/cWz
 FLVnM4Jt
 gfBxf0TtLZUolehO+HAWYsODA9llJE5RPeszrpA9ViPE+e6mvTE2MLv7kP2QRuBnHZXc+0hkTPu9dd6fGILZdCVBi2iK1EYwaf5v5PzfaFSrMTRsw5R9guhHXf2KMW8TbBqD+3c14zr2CqlJaVY5U9gvq/kDiucZcfC2FWlvtNDHX8Aj1E5ssBDVJ7yk4k0PuEqDBHyYsDH8P62+4TJ0CVo9z0hO5CWZEgFKLzRIcZKX8eLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin.


2025=E5=B9=B49=E6=9C=888=E6=97=A5 14:05, "Baolin Wang" <baolin.wang@linux=
.alibaba.com mailto:baolin.wang@linux.alibaba.com?to=3D%22Baolin%20Wang%2=
2%20%3Cbaolin.wang%40linux.alibaba.com%3E > =E5=86=99=E5=88=B0:


>=20
>=20On 2025/9/8 10:39, Jackie Liu wrote:
>=20
>=20>=20
>=20> From: Jackie Liu <liuyun01@kylinos.cn>
> >  Commit d53c78fffe7a ("mm/shmem: use xas_try_split() in shmem_split_l=
arge_entry()")
> >  reworked shmem_split_large_entry() to use xas_try_split() and simpli=
fied
> >  the splitting logic. After that change, the local variable `entry_or=
der`
> >  became redundant since its value was always immediately copied to `c=
ur_order`.
> >  Remove `entry_order` and use `cur_order` directly to simplify the co=
de.
> >=20
>=20The commit message is a bit misleading. It does not introduce a redun=
dant variable by commit d53c78fffe7a. Instead, it's because after commit =
93c0476e7057 ("mm/shmem, swap: rework swap entry and index calculation fo=
r large swapin"), the 'entry_order' will never be returned.
>=20

Aha,=20Thanks, you=E2=80=99re right. This is indeed the correct commit. W=
hen I applied this series of patches locally,
I accidentally used an earlier prerequisite patch. I made a mistake when =
copying it.=20
Thanks=20again=E2=80=94I=E2=80=99ll update the comment and resend version=
 2.=20

--=20
Jackie Liu

> >=20
>=20> No functional change intended.
> >  Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> >  ---
> >=20
>=20With the commit message updated:
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>=20
>=20>=20
>=20> mm/shmem.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >  diff --git a/mm/shmem.c b/mm/shmem.c
> >  index e2c76a30802b..53d28ea6e52b 100644
> >  --- a/mm/shmem.c
> >  +++ b/mm/shmem.c
> >  @@ -2235,7 +2235,7 @@ static int shmem_split_large_entry(struct inod=
e *inode, pgoff_t index,
> >  {
> >  struct address_space *mapping =3D inode->i_mapping;
> >  XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
> >  - int split_order =3D 0, entry_order;
> >  + int split_order =3D 0;
> >  int i;
> >  > /* Convert user data gfp flags to xarray node gfp flags */
> >  @@ -2253,15 +2253,12 @@ static int shmem_split_large_entry(struct in=
ode *inode, pgoff_t index,
> >  goto unlock;
> >  }
> >  > - entry_order =3D xas_get_order(&xas);
> >  -
> >  - if (!entry_order)
> >  + cur_order =3D xas_get_order(&xas);
> >  + if (!cur_order)
> >  goto unlock;
> >  > /* Try to split large swap entry in pagecache */
> >  - cur_order =3D entry_order;
> >  - swap_index =3D round_down(index, 1 << entry_order);
> >  -
> >  + swap_index =3D round_down(index, 1 << cur_order);
> >  split_order =3D xas_try_split_min_order(cur_order);
> >  > while (cur_order > 0) {
> >
>

