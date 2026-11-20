Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E632860A260A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EB7YZSaM
Received: by kanga.kvack.org (Postfix)
	id 004A56B05C2; Fri, 20 Nov 2026 13:42:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C106B05C3; Fri, 20 Nov 2026 13:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33266B05C4; Fri, 20 Nov 2026 13:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B81C46B05C2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FAA6A0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:42:49 +0000 (UTC)
X-FDA: 85456368858.20.EFCD449
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9304F40003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:42:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EB7YZSaM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795200167;
	b=Mvn4YKH0hF7bVOdMg4w0DqxqmK4WoyUkLKYHWmYFu3dQSSijd4jPleVxVUX7p5P9mAZOc3
	JjyTdmq6y5rPivt0jic+MGnnI38g9XGtT6sUGJmsJnbiuvzlyqX031UcfBTYYhktcEu6GL
	B0Gq5xs4sQe5Pht+YB7ASH0RkNUU5KI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1zh3TJUF2LHvTsPDLhOKm9aAKGeAr+Rv7zEz9ub0Ss=;
	b=YXrL/IO+xvId9tlOltYV2v2v91IBaMipwn6KaC4edDPhGG0gf6CaUYNom8TdK8RbjHAFF4
	5El8RLKR7oKkvxjY/CyGtxBbbNRTskQBcshRaV6QmATwOkdnHi7B/6IkytkDMk/srRFH9g
	ddk++B1Att++8TZ0ZgBRieinwoCoi50=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EB7YZSaM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC50144416;
	Fri, 20 Nov 2026 18:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD9D1F000CA;
	Fri, 20 Nov 2026 18:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200166;
	bh=z1zh3TJUF2LHvTsPDLhOKm9aAKGeAr+Rv7zEz9ub0Ss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EB7YZSaMQhKNHJn5T5hQ26qddBeIY3gRxU8BqrEnzFRly9bd8/QfANR/QM+PrZN8j
	 HEdpRKyjfXWoLsOom2cTj/G+6Y/X/2VfUfyOmKEF1qhibbWjfP6CypNWnhIqJE30ww
	 Kqr8gVQ/x84u7IxYLXoDUYfAV1MrcIwnoOwB32IbLc0q4jPtz2m9GLkB4uJmhxrwBu
	 Auv9aNSYSh/qleHQaAQtj6318u9uu7OhXKo7sWZzhFHmy2igbCl/InZOJ2UG9ph9bM
	 AagsRCpkif6kZtl0iFwX5ViUxHYj0NGAsStGOoW+GmKEhJ2bZ4ngt2cNtTENzI7hsD
	 8MS+YgDdBRkDw==
Message-ID: <sashiko-outbox-225860@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 57/60] selftests/dax: test private kmem devices and
 services
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, "Yury
 Norov" <yury.norov@gmail.com>, "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Johannes Weiner" <hannes@cmpxchg.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "Johan
 Hovold" <johan@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Byungchul Park" <byungchul@sk.com>, "Alistair
 Popple" <apopple@nvidia.com>, "SJ Park" <sj@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Michal Hocko" <mhocko@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Pavel Machek" <pavel@kernel.org>, "Len
 Brown" <lenb@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Xu Xin" <xu.xin@linux.dev>, "Chengming
 Zhou" <chengming.zhou@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Pedro
 Falcato" <pfalcato@suse.de>, "Jann Horn" <jannh@google.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNs?=
 =?utf-8?b?ZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Waiman
 Long" <longman@redhat.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Tejun
 Heo" <tj@kernel.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Dan
 Williams" <djbw@kernel.org>, "Vishal Verma" <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "Alison Schofield" <alison.schofield@intel.com>, "Shuah
 Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <20261120-private_nodes_v6-v1-57-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-57-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:42:42 +0000
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9304F40003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jfcunp4n5xg6su38zx8k69q1j386ar3p
X-HE-Tag: 1795200167-599248
X-HE-Meta: U2FsdGVkX1+IOYMrn8hMjNSO+W8GxbgONYWWcVrzWsLJzSm4yQlCgyeQZl6MwlOX4yA8idfSKpQugCyM+klc/+Ivrjjmj2xuwkkIA6B0YHm4Oaklyz9OdJWsN5q/jrXPEchDo6Diny757zvbWuwiaRlS0mo7ViSX9E8Se5ZjswgfIDXrv+re4H+DXHCF9oC28Y/ejQBj23cJhVYpAj1Gcmut441B8bWmk3RmSDE7ME6cy9wvkwV16etDjBkYwnfChxblWE/W04Yds5EiWfUgu/gSiUSGRkTO0hT+U9JaquhWSkCubg8KvGvAOKjojcRoTB5tYpQmABMuyo7sQn4kduW471JgEWpRl32O1uATndPx+xIecOc2qfDAN0O94Dh3uogPjnRHlOi/ddlT9HyNzWC33tGntJBZttKLJQqy03E5wobZH4Q339/XM9cTO6d9bAmAyvE0gpV3p92wxQ5RVCLZnLo0jSH7Jwocu4OEMp2Ld1PzYLGMO0MxAaV/8ArEnrF2JviHH3Ol99jrjrOC0K9+G72eJ2D1rE5AnLnTwFNImz4J7FyKDz8BAGqbC7sJ5jYYSwT9KlGQvRk+krJBlHNaUIAEPaqPhIJ+rOiKxT/Nm/Rxmigz5nwzswpF2Y2j9x+XHL4bkaCkNIce71VF+qjarvwpn9Jvtj/H9ho0l1Qo6WJyu5lyNz5otKUeAIRwjEvuWQbmZ3SFyvOS7inxP7GQg2zYEbeKuCIJbB4ro3DWfXBimPs3gdu97e3/8kZo4olmOryR0qniYATd/Z6R/IcnAXqr+HZRc0SvZ/tBsrF2/eCMYk7gp0OwChVyauihdMGNIm7BS53+/sbjWwnIQaAzWVwpQXxPDjxaEmlzuNL5/udEpVpEwTzQdYKsHo47FbQXEUor5T7Omnt1NAuvl5K3Y9hdDg1GWHVHCBYv/werOdsCCJkrs6OBsvnHX3nf/3+yp3Ij4HKmgha7O5Y
 q8dRBH+6
 g0mikThc2fOB6Swt1B9PyYbOeC4Kj5a1s/qIvE2wIdjLJ1XT6SuLnH7X6jNJI/IlYDyFnZRaU6qqCYF2lLdgFo8fkmkHy7oiZIlLRS8UvGGBHSixgAIUZMWH4o0Uo85WocSJ4yo7gfGLBbHvPS2dsDJ77igp1FZar1UKqDhDAIEXBH6OIrmc/qiRsV+mqfa54bA+6wDIqzeOhWN5Y1hvRqEw1qmh11j3hYVTxwEgyWIwMjJ19jwZ36DtMr6dmBHXjew6/t9lBXXv2DlqueBG1hdkZeLOj2BdaTXQz67OL8+mqpBX0M5kJwa0gDB4J3SniuBLPpOj9bjoVUR8XiBGPlsr5BONwIqnGo1rY28XBC1Tz2jfeBPDMNK14jQu8No9wg3hxuFP+xy3ZB2jgydbUhpwheOldWrvJOdMEkwA0bW1OACHm0a2YCx/yDvRncC+/LS3CdECicdwDAwugPsSJW4a/Nm/x8EFI5oZbthO7+9M17vFA/osQ+qqRJhSsisPg9/jYZPLiy/qRSobVO5iiYVPoyBYJgF8bjx07sNZyrWF8Rrfn7YY6oECm4jB8Gry6HQ4np3Mg6QhedarXLFUN2VW8Esz4s7vqQTMRPn+/jndLcDo2kYBxscnRor69Z7TM5a/wrWzkqJIRp6gnufJ2c+S1KtfTnhnxwfd5DXJ1fodlFNVeFgqMDWOXUKpuLVB7aG3ZqYTmI1nY0oW3lYORtMvRcMk2c1A1WqUolrMs0gxRlIGLNdeGOQ/HxDysSeJazeWvsCQZ4KVfYmFNaCKt82PqXaBLtchuu5Tp2/VRuM9zsLT/QI/lTdPe0qFXgDMlh0Xs4xxvCN6AvsK9ZgTVexM0KAUf09qGx+Y/sOcSHtpDN9h1FNjXKFbFIyOygNRSxoSaAcqNgHMtXIGQ2Bx+KtjNLIwkouMxSSZkJDDC0oSfosY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] selftests/dax: kmem bind in pn_online_private() without
  offline policy
--

commit 92dda1f7387efcfeae9e63aee96816a2f4e187f1
Author: Gregory Price (Meta) <gourry@gourry.net>

selftests/dax: test private kmem devices and services

This commit adds kselftests exercising the dax/kmem private sysfs
attribute across memory hotplug and verifying which MM services run on a
private kmem node.

> diff --git a/tools/testing/selftests/dax/private_node_common.sh b/tools/t=
esting/selftests/dax/private_node_common.sh
> new file mode 100644
> index 0000000000000..57c5231e768b8
> --- /dev/null
> +++ b/tools/testing/selftests/dax/private_node_common.sh
> @@ -0,0 +1,208 @@
[ ... ]
> +# Move device $1 from driver $2 to kmem and online it as private memory =
on
> +# node $3.
> +pn_online_private()
> +{
> +	local dev=3D$1 driver=3D$2 nid=3D$3 name
> +
> +	name=3D$(basename "$dev")
> +	if [ "$driver" =3D kmem ]; then
> +		echo unplugged > "$dev/state" || return 1
> +	elif [ -n "$driver" ]; then
> +		echo "$name" > "/sys/bus/dax/drivers/$driver/unbind" || return 1
> +	fi
> +	# A private node holds the memory of this device only.
> +	if pn_node_in "$nid" has_memory; then
> +		return 1
> +	fi
> +	if [ "$driver" !=3D kmem ]; then
> +		echo "$name" > /sys/bus/dax/drivers/kmem/new_id || return 1
> +		PN_NEW_ID=3D1
> +	fi
> +	echo unplugged > "$dev/state" &&
> +		echo 1 > "$dev/private" &&
> +		echo online_movable > "$dev/state" &&
> +		pn_node_is_private "$nid"
> +}

[Severity: Medium]
Can binding a non-kmem device via /sys/bus/dax/drivers/kmem/new_id wedge
the device as online common memory when
/sys/devices/system/memory/auto_online_blocks is set to online or
online_kernel?

dev_dax_kmem_probe() hotplugs the device at bind time with private=3Dfalse
and online_type =3D mhp_get_default_online_type().  If auto_online_blocks
onlines the blocks into a common kernel zone during probe, unmovable
kernel allocations can cause "echo unplugged > $dev/state" to fail with
-EBUSY before private=3D1 can be set.  When pn_unbind_kmem_private() runs
on that failure, the unplug attempt fails at the same point after PN_DEV
is cleared, returning early without removing $name via
/sys/bus/dax/drivers/kmem/remove_id or rebinding the original driver.

Should pn_online_private() temporarily set
/sys/devices/system/memory/auto_online_blocks to offline around the
new_id bind, the way dax-kmem-hotplug.sh does?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D57

