Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CF5CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 21:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194878E0010; Wed, 20 Aug 2025 17:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C2A8E0009; Wed, 20 Aug 2025 17:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082658E0010; Wed, 20 Aug 2025 17:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E99318E0009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:34:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F42C1A0162
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:34:43 +0000 (UTC)
X-FDA: 83798440446.30.F079DC4
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F24E140004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:34:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNQ05Mdu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755725682; a=rsa-sha256;
	cv=none;
	b=DUIi6BoxRxsRxxrBzLvDg/T0TF+Xq0YFrXndlwzAQma8wuwLl3qnvM5xTqOcel5RrUTlCd
	lCFVsPo70c9UTXwrC8W6G5LkEBG4hgTCFgQZhrrljzSINBlG9Tx9kgKwYEtKy65MUVmX6Q
	M4qc5a4HxI9m4zG+hyv0gsj+UlxNnkI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNQ05Mdu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755725682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PM4zc6JuUjs9DXSdg1cZOgc0LHF7QtVILQ3VPU4Ih/8=;
	b=F0EK1A56y3Q4B37cvbYhXQTey0/w5nzG1nWgtnDwj4Qr9BQgPmPid/J1sm7aRHunFQjxfb
	cVIfYiW3720+q76yPuTuNHHxryoYvQE+8jSQLspbLT5ZKIxGTqSCF0X682F3pqrvuXbSWa
	a/cjcx4FI1Z8+YjytuHrreALcUJC+uQ=
Date: Wed, 20 Aug 2025 14:34:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755725679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PM4zc6JuUjs9DXSdg1cZOgc0LHF7QtVILQ3VPU4Ih/8=;
	b=NNQ05MduTzCaRYI9uiMb7owIrlzEL1YD/MvexojLbiozG6JxgMI58P+bKk4ZGymiCm0Cp0
	UcJ3Lmrcrf7o5ltnSE+CU1DdPSXFMbdsWQ1/9NtCpn1//ftaB4Gc3fByz0lVo+9Dgs0Fp8
	a2Lf4TnQry6HsMT23aHSrgSHvx+V3oM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matyas Hurtik <matyas.hurtik@cdn77.com>
Cc: Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <kyy6mxg4g6aer2mht3xawiq56ytveg7vllg7o6f7dgivkoh52z@ccinqivomtyl>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <aJeUNqwzRuc8N08y@slm.duckdns.org>
 <gqeq3trayjsylgylrl5wdcrrp7r5yorvfxc6puzuplzfvrqwjg@j4rr5vl5dnak>
 <aJzTeyRTu_sfm-9R@slm.duckdns.org>
 <e65222c1-83f9-4d23-b9af-16db7e6e8a42@cdn77.com>
 <aKYb7_xshbtFbXjb@slm.duckdns.org>
 <fa039702-3d60-4dc0-803a-b094b41fd2b9@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa039702-3d60-4dc0-803a-b094b41fd2b9@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9F24E140004
X-Stat-Signature: hwctpkwx15ixgkjr41sunj1dwjcgkwf4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755725681-433554
X-HE-Meta: U2FsdGVkX18WTIc8v21oe0gFaxk4e+25gD4uz50CIkQoZgFZ6B5RVMrRvElvMMGiC3ju38kfWWxrNodYQYylKqdCaDbUacjRC027wsjRzFqlE0W7cwGRFS4cQApWclKSaV4yp+6j84fV1rzvOKJzYG9uDa/jWkDmJ7IWVHWXnpVGLouACcRT2vk7sd+pdhPkWSwKWEGoRST/X80x8q3x2FJdnjMXuuqsNTq8adsv3oNQDokmX+WlSqbOU4UFgTsucrAqzs8pH+lECdjhqNb+5MnbxMOG74tzLfy/yT+DH9S5PNALN7mDb9L+LuKdwperyD9Y8YZKjLItPyyIa9RT1fQibD3+/AlSHfBHiKWCySCJzi/uehyb5ohct053EN1Hp1YkyGJBdQNWVpKQq4xudeJPkM+IgBZWnCheJ8YJMajYuhK4t1I8rMB0sDbDqguQ9H6iNqRIZHG8M8M0ZgvKhoPHmmU+mcvY1tDGCiUv8VdJpxdT06g/wd4zbiRw2q+EWhRozPWkDzE1hyoQ8yuHA6vDVGJlD4rzzUh7gEtpiLlDk6QG0cxExMF4joxWl5hooxKfhqYOS/YzFsGwbVtHukl6O2tcS3/BSbefE3m2zh9JGg0gr0Er5d0Kxv87GZZfA5yaws8yRzBhMg+ZqQ02SxgJntPmp/d0o7fyKC6PxqxEJT6D4vCR19fyVCp7ES8XL+nC9rVjaH+0NCThe8cB2eX/jF7poKiIzQG9mzKMlN+AKaV9dUzyHVn4kzB0gNGi+kJ/xeqNoZFBw8lL+wr+7AzeCUXiX+bPhjhVpSpwxuxk6uF68xGe6OYynQ61TarP/bkfBeKhV5hJxrqTl4fT3jVeyE98DDf7/0HT4QmD5ZzvF7SGY1pVQmtfcWR+elLXlQPkLJSPViHtfHlPZj/iQwb5V8F6/Pe2ekrs1x0GNhOctWnmJ004k4hD2Bm5j2EzUIRmwoxGhjbVoRvB/Pm
 DaDU8i9I
 A+gxVGFWbPzoUYBnBrWMkFEOhaG67nD11SdzWVOP+i03/0fn/B41BLj8gTwxGrx8DFpQ0U/dN9s/21q/nNcOVLfEz9i3a87VuXuD0VeJukaJVeNCfZ1jUChECUO5Cqo+FC0SpmQlNKhFyv2i7KtXWSYRanvi6Ilv8LNAMDCiQCF2dFeXXBNynAZ/7GsykQ9CZ8Yiqf2XtSAqO2KFMkhCeljy5MUYoLD7kwx6WSripVPFRj6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 10:37:49PM +0200, Matyas Hurtik wrote:
> Hello,
> 
> On 8/20/25 9:03 PM, Tejun Heo wrote:
> > On Wed, Aug 20, 2025 at 06:51:07PM +0200, Matyas Hurtik wrote:
> > > And the read side:   total_duration = 0;   for (;
> > > !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))    
> > > total_duration +=
> > > atomic_long_read(&memcg->socket_pressure_duration); Would that work?
> > This doesn't make sense to me. Why would a child report the numbers from
> > its ancestors?
> 
> Result of mem_cgroup_under_socket_pressure() depends on
> whether self or any ancestors have had socket_pressure set.
> 
> So any duration of an ancestor being throttled would also
> mean the child was being throttled.
> 
> By summing our and our ancestors socket_pressure_duration
> we should get our total time being throttled
> (possibly more because of overlaps).

This is not how memcg stats (and their semantics) work and maybe that is
not what you want. In the memcg stats semactics for a given memcg the
socket_pressure_duration metric is not the stall duration faced by
sockets in memcg but instead it will be stall duration caused by the
memcg and its descendants. If that is not what we want, we need to do
something different and orthogonal to memcg stats.

