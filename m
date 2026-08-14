Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1332AC5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1AC76B02DC; Thu, 13 Aug 2026 22:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9EF6B02DD; Thu, 13 Aug 2026 22:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07E36B02DF; Thu, 13 Aug 2026 22:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9F06B02DC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:12:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19D52160195
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:12:33 +0000 (UTC)
X-FDA: 85098250986.12.0F0641E
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf23.hostedemail.com (Postfix) with ESMTP id 28F13140004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:12:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kKREBeIc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786673551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIKqn98gmXll8u+WUUa3M0FamLhLHauo5Du7QbMYyNc=;
	b=Zh07VBPq8tFdxB80isrBpnkmCknGVGblt+3UfD1lpmzvXKZrzqec/ldCp/I0HsTB7WG+Tr
	73wbVXTkaP8nmQyfq0U3IaC/zlUwXJw3pq+LFPAkwVMSspRuoYCjj+bAHv6ENBRPA6DC56
	TEa0ns+2l/s8CH8TJ5q4FaqBcL0qe4E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kKREBeIc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786673551;
	b=RA0OTYnQjkaH+MqVFpZNxGPEjZB1wmKEX3nJVP7JIne2dDOxd9A2huqDzsjVnCEvGH6VgM
	K/6w4JLSxqSpZ8gcUDhwS9LB1Q1ozBvmKrGR74F8t35mqBb5bEb7HW3yucwFOfxyZdmHtC
	BI6RizIVeGGutOfCOwhLeLauqVaTVBU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eoFbdgYwhAPk1M0cRrN/Wp0rvLcUr3RUxy9FqUNrBDM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786673549; v=1; x=1787278349;
 b=kKREBeIc0ny6/rcS1p0HaYCh8jyBSJMYDAyMMvqEw3egeGNqNxhLy4gLDabvCSdnxf2m+uH/
 lsPET2rb7mBRn1iTRfKj4OzgS4Zs5qnRfKEaB5syXa2SG3LUw4lHj7GoAbQJG0EEZHNbMUK3oD2
 6ME1bCmI7gAsT7SWvBRiVfME=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (114.251.196.105)
	by mta10.migadu.com with ESMTPS id 70dc4e336f65b7bb;
	Fri, 14 Aug 2026 02:12:29 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 1/2] memcg: acquire peaks_lock when reading memory.peak
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260814012924.2388613-2-ridong.chen@linux.dev>
Date: Fri, 14 Aug 2026 10:12:10 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 David Finkel <davidf@vimeo.com>,
 =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <811C3A33-6B05-40D5-8448-19D5BE882A83@linux.dev>
References: <20260814012924.2388613-1-ridong.chen@linux.dev>
 <20260814012924.2388613-2-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Queue-Id: 28F13140004
X-Stat-Signature: 3rh9t4hn3upacwoyfyhnp4bbcctnmeqp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786673550-325875
X-HE-Meta: U2FsdGVkX19bB8Br7PtHU8n+Mw/PsOjNKZ9ZzFG5YkND+HHPYoVyMpqn7uBjX/+yeNNdqWydlse+ZFPxKeD7e49rnlKY+wfBv9N9htHRQCf2ugJVgFkEbOa7FfXDm2oJSK8MrzdKRgZE1TdjZQL9FRvIGFaPE1SrSWuJZheito6cy6uSMGsKjQv3iz7J4PXTzgko7ptgZX8TAyTl7GeB3N4PD5dEnHleicNcX7Y3pYhYS5RPukpX6HKUdhVVBamDW4Vp5oQjk3SN7+Yezj3yqU69WAVQo0lDMcQ8mxeCWYYL/bYLT1VL5kJJLz9FiP7Cw5NsJZdULwGLCs7GQgklvJR4iHqNAt6IvNEv7pLGo2e18j1jFkbk1RuGuCfT45nXfV1zyX4bwSe9b/Nm4KbePewEaHjTDvKBGx3G5ABfQoxhGarEmB+6xszd3G+KM5kjHZQSB4K+uQDqt7FuUsnuHP7GlJx+ImiLzgQBv0iF1/BseTO8xbXceCDWFIHoOfGEHgU5FAPCaT6+vq9GAY7xYi0+Ceii+I3IRchuufbphRiGUENMO9bKw4KJGzgoijuiT3TyKOOI6nWvhURdhIjOSedAdb5rQ3iP9AGDiZ0FM7BPsDKsQMwoHFxkYzyeQCBr2PqWaI4GoF5iauKqefAQN9ROXXfR4A1NiqLDs8zKW4KaaUJnINC9iu0SJ5J3TRauHcMINaunqmla0TSEHvaXG4eqdlIDttTBDI4BN1mchTqYjsiVpwjhPU9ETGoBCCMSBmcJ/SR34bFd2AhsVmiJxP2ikZ2Apu/PXRmmmZe7RUDecDSRq5HL+2yXaAJNOiolUXrR9hzL5OOnqp4M2iig6UD/cSCyqF4u4AEWbxenOye4bjVuYRMfal7f4mNU+AlewBs4bmEiTIJkP0uvGb5xijXQxGr1LQbeNjiWYRjxlXBCo3fA16QEDV/Fc0BisOAvcuoFDfn7fgUrqNvTYWp
 vHSkyNew
 ASJQP8AXFYbpttc7JBcMLRcBO6ldE469gMAwoE5JyJHlVrdScq7rzevdKRxNh/1FJLyUE/3w3vNonNR8R6zkYC5Anp9OTiG336P8fi2yajGaFUz6XCYyy0BR8Uc93meqC0cJdkhuxX1nzANq0nXgYMkQ5Jbk430ZRI0eEwNrAis91zbzGlgDHQGarMDO0tYODBD56STn/z2jwTQurXD+INowdnX2QGsLb0NU93y/TXQ/XHES10cGVEoFGN4DsV3nI9OHf3cye19nmaEdq4+0MGkIc32/l+VxnZV4Swda+lAgXdPA+NhA1S3Bu6tC/c5CwI2Qo+fM8rJ0gfJ0qAwXGt5eRZaSmUdRbu152IuRBDXs3aBDFs4HHk3x6+wWX2OkbuOcdQyfDEQVdgVwPeKtEyli68rA6GPQxdOXZD/U5XNeyh2GSnk3/YCXIprvGlO41QKU/ZD0sTj7piNlSQHZ3yL/VwOvor2FECItG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 14, 2026, at 09:29, Ridong Chen <ridong.chen@linux.dev> wrote:
>=20
> From: Ridong Chen <chenridong@xiaomi.com>
>=20
> Sashiko reported that a reader can transiently observe a lower peak
> within a race window [1]. peak_show() returns
> max(local_watermark, ofp->value), but peak_write() updates those two
> under peaks_lock while the reader takes no lock. The interleaving is:
>=20
>  writer (reset on fd A)                 reader (fd B)
>  ----------------------                 -------------
>  usage =3D page_counter_read(pc)
>  WRITE_ONCE(local_watermark, usage)
>  // watermark lowered to usage
>                                         lw  =3D =
READ_ONCE(local_watermark)
>                                         // sees the lowered usage
>                                         val =3D READ_ONCE(ofp->value)
>                                         // B's value not updated yet
>                                         return max(lw, val)
>                                         // both low -> low peak
>  WRITE_ONCE(peer_ctx->value, usage)
>  // B updated, but too late
>=20
> Fix it by acquiring peaks_lock when reading the peak, so the reader =
sees
> a consistent snapshot of local_watermark and the per-fd values. The =
same
> race applies to memory.swap.peak, which shares peaks_lock and the
> peak_write() path, so take the lock there as well.
>=20
> [1] =
https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.=
dev?part=3D1
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write =
handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
> mm/memcontrol.c | 14 ++++++++++++--
> 1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..6dd8756870ff 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4713,8 +4713,13 @@ static int peak_show(struct seq_file *sf, void =
*v, struct page_counter *pc)
> static int memory_peak_show(struct seq_file *sf, void *v)
> {
> 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(seq_css(sf));
> + 	int ret;
>=20
> - 	return peak_show(sf, v, &memcg->memory);
> + 	spin_lock(&memcg->peaks_lock);

Why not to use guard(spinlock)(&memcg->peaks_lock) to simplify the code.

Muchun,
Thanks.

> + 	ret =3D peak_show(sf, v, &memcg->memory);
> + 	spin_unlock(&memcg->peaks_lock);
> +
> + 	return ret;
> }
>=20
> static int peak_open(struct kernfs_open_file *of)
> @@ -5858,8 +5863,13 @@ static u64 swap_current_read(struct =
cgroup_subsys_state *css,
> static int swap_peak_show(struct seq_file *sf, void *v)
> {
> 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(seq_css(sf));
> + 	int ret;
>=20
> - 	return peak_show(sf, v, &memcg->swap);
> + 	spin_lock(&memcg->peaks_lock);
> + 	ret =3D peak_show(sf, v, &memcg->swap);
> + 	spin_unlock(&memcg->peaks_lock);
> +
> + 	return ret;
> }
>=20
> static ssize_t swap_peak_write(struct kernfs_open_file *of, char *buf,
> --=20
> 2.34.1
>=20


