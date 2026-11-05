Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C562606A333
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c2uN/Ng5
Received: by kanga.kvack.org (Postfix)
	id C2ABE6B05B9; Thu,  5 Nov 2026 06:12:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC5F6B05BA; Thu,  5 Nov 2026 06:12:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18E86B05BB; Thu,  5 Nov 2026 06:12:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4016B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8880AA098B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:06 +0000 (UTC)
X-FDA: 85400801052.06.57AA8A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2111620008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c2uN/Ng5";
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877125;
	b=N6xGgJtUDZIjTsE8MGMgme+Z0WZez7PbEfu6c1u6CVOC2T+05iEwLEA4825E4PhdBRNavA
	BcSTKDkbeXpfiRBBaXlD/bY0obxQ84b6WVyi0sCvqiZEJmv6m8tO90YEOXLAYzaddsDJZA
	E00b08LuUKadR5+2zAqBvE+WK1RBRkk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c2uN/Ng5";
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877125;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4OwYANC6wqKDyPgO6eDc7wNQ6edH7rpigotQa7/OCk=;
	b=uSOVIHWJsmrpRLp+K1n2uEEWbs7kSsWNZWPgB/4cZEB15YJdCUHKAw4IHmp++cPY3/5qLc
	TLgvCW4ig6p82jdBRdbCG8YoVvD6aACsf1yyFLyPa/o31O1zcA29j0N47JPaF7WAWJvDpL
	c2v7pgOMDJsXz51LZqI6J+RoNTy6U/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CE3B42E3F;
	Thu,  5 Nov 2026 11:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FBF1F00A18;
	Thu,  5 Nov 2026 11:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793877123;
	bh=u4OwYANC6wqKDyPgO6eDc7wNQ6edH7rpigotQa7/OCk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c2uN/Ng5l1zRBU1f6aKBEfZtQoOnizQ0rrFd9kCVSSHUE4EkaG4YPu0DVrXFd/sYf
	 WQRytoL/bcOM1tMwGTUhoxMGZjd7nrw9Op3dgk7LlqQMSjRvDJDTBSXagtU5aDYa4F
	 iloIC0z1XqsAvA+wuzjNVVxTNcK1vJS2YM72nD09YWg7Y+1F+DhJmXRU8T8Gy/xhN6
	 KiQgtSFJ6rsFJt5ladVLcE0huTLON36jq97Rw9RRIPx/9cUI0YxCWADXC+FyRY98yA
	 EIszDEoo4+ImNGcD/JzSRE7yMABOCWcp+srnamdEnAnuamz3kghzyKLk86XsIYtlff
	 pshldAJJUYr3g==
Message-ID: <sashiko-outbox-198921@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 6/8] selinux: Restrict cross-cgroup dma-buf charging
Reply-To: sashiko-reviews@lists.linux.dev
To: "Albert Esteve" <aesteve@redhat.com>, "Tejun Heo" <tj@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Gaignard" <benjamin.gaignard@collabora.com>, "Brian
 Starkey" <Brian.Starkey@arm.com>, "John Stultz" <jstultz@google.com>, "T.J.
 Mercier" <tjmercier@google.com>, "Christian Brauner" <brauner@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Stephen Smalley" <stephen.smalley.work@gmail.com>, "Shuah
 Khan" <shuah@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, "Jens Wiklander" <jenswi@kernel.org>, "Sumit
 Garg" <sumit.garg@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, media-ci@linuxtv.org
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-6-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-6-1819a017000b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 11:12:01 +0000
X-Stat-Signature: j4zh8qus9r4oh4xbu1t9kcwrajdedebp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2111620008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793877125-996242
X-HE-Meta: U2FsdGVkX1/iNKxJ4ki9U8clIQV5UWKc/t3DOw8AsTYRos4iGx6pdE+lV/ixASA9S/pw7fU2UViVaaAmpqUlFf4h3LAHSsJOUyel4PaY3LQh1uG+EWOcMdynG3b5cZw2YhuKvcv3XDON15A6aEmY6lQpiudyIRfDKB6FXAdTRrF3Jihdu9huHXis0F3MEuDLq2yEVKRXY3YLSvIPLSUvnj4Og0EBKeVb5rjmkTa+9gvmg9/02+5Zy2uv7L11e8rW8uWcIEFFaVsGPER7W2cCQh2ahvAatLoKHNIiksevmNOxfpPIggZd8/5e9ZoyoH4cTUnwcrD9p0y+5nvnYhwSdZK5RSVACTzx9CF5Cq6ut+BceFbolqvmMK6z28wSu92J5f33lzxt7YC90bse3kxU0UAH0DOJKMIClxTqj0zcriWoLleTqtctDeHqGCu+/Qrg31U5AOaqMRiAwjy4wq4hVHLaPPICbR7DxnGq5F5VfzY4yQhRlU7hzuN+jLAsWrAJq1Q3nk8xxq+2voxbTV4EiMLW/kIPHiSeAtBQd3QpUf1SiFg8IXyJwHOZy2RzozQqexOLp/sunkt8z4B7pKnEpR0gZncReXpoUneFBHFRQxezaM/+NEhXuw/TxPlXvIJjIFaBtYldDSjVT+vRNu1ANeLSujJGC/Ny1EZ0YrmEkAYg3FWXyZ89BRKCZVvJZ4WhP4zxnCs5UA+tgeI+YY8K6cMwiEHi3sVluwPxZPPmV+1I3xB/PK/5VxcpErQZCRz9VhTp9geuaMPuLbSJ6US2uGI8iDFf3OZKY7FiMNOSSO4X9grfo7Nhsj5K6Ef39s6cRHD/51hEM6uz58ApVQlDH6xNFeEfFjA4LK+vwTGr8t+omfszfWuPrIt8SaYJikqUG5pbpqVdPb8TPxvZF/SPjz5DaKO9gcJHd1N30X/jaxFNQOfvHGT2wLfhwzNfN+m00N8BDAA9mlyc1D5mxSQ
 VLKywOaC
 wJc507dX+ZBUcT7VUmqPTeYqZiA3am1rrpVI9ip3hm5nsWr9eYDL+IXijjlUFqDk48zTdm/+Av9NRf6Fsm4LiqVexTBCMMdGY50FE2exbBZPYWlEMlAp0K45UKWVSMEp6Od+YixE1FwiE+MxVqq5fJ+ESUD7OAakbPD648YFUw4GILbP85bLXNbc2QTwIh2Ma1LPGBSo9SBvG5CBUT3v1V44VurVCbyd8Iltz9a711CRH8bXDLGf7kfuhQSvjeGdHPE6v+NMrsOcoerIjArurvfGmB/Njfo4UzkOxfEzgETBvZv71FcPnXaftTmeVuaUW4gm7vWcLJ8zzZa1jolh4I0g+UbIpUfpFUn8MSztycTvNr3MycSbGEEU4cKHbBXYxq9GCHql9uPk8IxkyQFt3JZVDkPXxc8mKV0IxHTeJjgHWhSAl9zMRO+WoluRzcn2JzmoMlQ9yXMyPAevDRj6tnMixI4YrRxQb1RrLetpsV7X741Ky+LdUptA7yN/YMzoH1gF8wkiSZrXdsWROBbJjUB64dWdRr+TASYAoMDHbJ+rkLaDnhvp9xvweBEw8zst3WgmO9cT+pWJoU9YyjzwLFKVzfXV/8ic6UNQOAr/MJDhIZ5xJCwjB1JJTdj2YcWxOcJxRVv/rn55/6N5xSdefteVpdXa85MPOdIUPzwOldw0ZBzpeZxVO8PUjzI7skuwSK8OroXJrC8ldhcGFLvefraK+KdnIWfFIInsi9H1aD748Q6zA80vnx3LZXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selinux: one-off dma_buf class instead of general cgroup access =
control model
--

commit 675e985fff50ea6716b8c00023a75c07ff345a6f
Author: Albert Esteve <aesteve@redhat.com>

selinux: Restrict cross-cgroup dma-buf charging

This commit implements the selinux_dma_buf_charge_task() hook and adds a
new dma_buf object class with a charge_task permission in SELinux to
restrict cross-cgroup dma-buf memory charging.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 30776b0107f29..8f39d91eabc97 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2204,6 +2204,12 @@ static int selinux_capable(const struct cred *cred=
, struct user_namespace *ns,
>  	return cred_has_capability(cred, cap, opts, ns =3D=3D &init_user_ns);
>  }
> =20
> +static int selinux_dma_buf_charge_task(const struct cred *from, const st=
ruct cred *to)
> +{
> +	return avc_has_perm(cred_sid(from), cred_sid(to),
> +			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_TASK, NULL);
> +}
> +
>  static int selinux_quotactl(int cmds, int type, int id, const struct sup=
er_block *sb)
>  {
>  	const struct cred *cred =3D current_cred();

[ ... ]

> diff --git a/security/selinux/include/classmap.h b/security/selinux/inclu=
de/classmap.h
> index 90cb61b164256..b4ebedc6e4240 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] =
=3D {
>  	{ "user_namespace", { "create", NULL } },
>  	{ "memfd_file",
>  	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
> +	{ "dma_buf", { "charge_task", NULL } },

[Severity: Medium]
As reported by Paul Moore on RFC [1], adding a one-off SELinux object class
and permission for a specific subsystem's cgroup charging (previously
dma_heap with charge_to, now dma_buf with charge_task in secclass_map[]
and selinux_dma_buf_charge_task(), along with charge_cgroup in a later
patch in this series) introduces a narrow, subsystem-specific policy class
rather than a general cgroup and resource access control model for SELinux.

Although resolving the target memcg from charge_fd moved into generic
memcontrol code in mem_cgroup_get_from_fd(), the SELinux hook in
selinux_dma_buf_charge_task() and class definition in secclass_map[] still
define a dma-buf-specific class instead of a broader cgroup access control
abstraction.

Should this permission check be designed around a general cgroup or resource
SELinux object class rather than a one-off dma_buf class?

[1] https://lore.kernel.org/r/16093a0278a6d7d1a0a8bc055c228bed@paul-moore.c=
om

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-v2_2023012=
3_tjmercier_google_com-v4-0-1819a017000b@redhat.com?part=3D6

