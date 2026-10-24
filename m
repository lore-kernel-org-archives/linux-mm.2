Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1741F606A326
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 13:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=napl7AQi
Received: by kanga.kvack.org (Postfix)
	id 157C16B0092; Sat, 24 Oct 2026 09:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107A86B0095; Sat, 24 Oct 2026 09:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C9C6B0096; Sat, 24 Oct 2026 09:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB67A6B0092
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 09:23:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDD151A03AC
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 13:23:27 +0000 (UTC)
X-FDA: 85357586454.12.142C7FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62FD010000C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 13:23:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=napl7AQi;
	spf=pass (imf14.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792848204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AenfdRm90WrSjoi864BFabnLzqWgO/qqA3F0PRLFjp0=;
	b=PFQ1bJxhgYt8cY7RFGt3Q+56RFhqF4v43Q3u3mW/ixopZRft68/zxtvgxzVX2csWxzXqsW
	3S6tmMk7mHTbg1tUeIRCFSvw90nlysljBw3mZh2WduEBLDWwMD7YbPzuGs+An0gYhZaZsx
	LZNda83GuliZkDZP/APFNk1OoRdDt0Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=napl7AQi;
	spf=pass (imf14.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792848204;
	b=JJZ2lWhUnm4twUSU2PLrPZSudLGny5z5bmYj8Wvqi1h52jWN80ka6W2UCTZjwrGRLOYuGy
	UaANHawTyJOPhCJv4Dm6cs/7GXUfRUulY9+RfKU8t/jdqEVAQh5vWQog6SdTQVJQbK8OSy
	a8XHgMM5p6Vkh3WMhSo1pbe5WwaD1Tc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 291176022A;
	Sat, 24 Oct 2026 13:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4EB1F01825;
	Sat, 24 Oct 2026 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792848202;
	bh=AenfdRm90WrSjoi864BFabnLzqWgO/qqA3F0PRLFjp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=napl7AQi2UiTBpTwoXjQ8MJt+9SLLnPFu7CuUVg7W/aRolDGozszZGUlIaGY+Cq/N
	 OM471O3WWvM9+LNDFoZVYSx2OjzdA0u+FiDe6SRoEIwe9QgI2HgFtNIw0KfL8rNN1C
	 32HI0xaj8v6w0CTprcI98iFZnFQKn2n+ja77zSSYDNUIBkUxaAMMZmyL7RNCmzuvYM
	 xXu8APRXiotFV/J3gUsH3y1ycY8zXwuC6YoPteRB/kTOqpq87i/lshG/WOt9KNJ7l2
	 2y5CPcgneTBH/sgUMaPQpWYCZHPWj3xP7tQ4BRrLucpNUdwqSrf25DUssebpwne0sm
	 AqfzKMgSYqN6Q==
Date: Sat, 24 Oct 2026 15:23:11 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 2/3] ipc/sem: reject negative SEMOPM values
Message-ID: <atyvbQ5xxtxcxBZE@debian>
References: <cover.1792808260.git.x-professor@outlook.com>
 <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3ypnmqpyuzbufluf"
Content-Disposition: inline
In-Reply-To: <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62FD010000C
X-Stat-Signature: 11ddrw6iomwjyrq6drweiwy59hr19mz5
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792848204-568863
X-HE-Meta: U2FsdGVkX18Sc+TNAdkMkdSiEYwECs6ybE1F4G1UwT25g4HMUhIxpQXxkXhdmO2p0JXFa/jXRnUNKVukCb3FlsB7QUkHBIEBwnodR3ipvXqOF9IrNOsxw4YuDG+5KE6aHwndx+1Z8iFyfkjAi+oH1nce2IZ1fw79GQ6w7QbEqMSAtQLvG+Yf/gkZd4nifhLPdrOP5B4SXicvdOsqfRhdd2L2xPMZ6peVzH1gfmco7NmaZgYmfbU/AovBOJNZNdNClr7x0F3Sx+fpk/iVl/z7zRhem6TgIeqP0zQExN+Urdcfe3MzU8jC4+5UPN/f5Lmni2zIsaofleqINM96WAxFsRURxq8zAaUZOzA7+xqh30XVSy4tXMXxkPAvHbi5tUDYOT5Ukn21T69Q1nv6xcz8dHN/7CrmtCZtPZGFempiPLb5Fk7bk2FmYZnDyVXI5OGUwdB8b4jOD8KAaJBucvXRkDP4Md6zaHgAdlyf1stT1MREDeKKUyG/7sJ9AkaK4FVQfKAEHcMUKOeWokSJpH3pqjnzu876BPawylhza/552UeNp069CJ+a/QiOWSFNl8YahX8kvPhFbxp3sq8ncdq8FgIGp9T8A5dlDjzkrte8JwlH0Xpiu6Xm1I6mhaQ3B+GlZ5PLUxzhxdrlpV8SmRSSPAlDOO9TxCdeGgwF6IBNF94FpVQB3MfPI5Law3T+3IyEROGzZUoin35DEF6lSRUqjH5Si0qtu8hAq+mU/bvOSWN0H2mS8F3XiJusIJouGIbVILzjlZWUrc7esl773sI5kqM3Rc637GVRXByxnD/PNZE0S5p4jQ6YJZDEddsry11aNnJ57aEV5jHPrzTOq6prm0ArYyYp5EKI/qxkoUDilkIfq6uNa6jUN7cwCa7+XdSdq2F9Vw+OO3CplJDcGOVIxE0d94rI56pQi77F3011L9iqM0myTwWUQJboRxm/pWjrLkLdwOvoi/iH+3Lqedf
 YCa0y2CB
 wGTy8vGGqoZ5p5UApzi36yHeTXUQ4dZdOt1eB9qugDAn3DEMCrnb6jKZj+T73BrreE3YkAEEUJjWMI0tuL4WHaDjoNCXNSQTvQ84XQpjOXFZTZVYxmBFH/+x1U8dleJWcfNRcXqivYhxh5rxj50LmpagjAkvdFLqd0fiiJp/O0CXswIogkcuPPvugPdLvHFbAjcGepIARVJ9uAwBz9biuanK4QjAC4s2z+aiOh6mO5bgsOiiC/FG2dLGN8vwX4KXj69zXFO8+8afC/srKncFsa8+sLs4UqRppst2Ft1VzKtHzUIq1MFKhxnn+Jp4ssJINJcwXsERgHVFyocKlEABvdY8nhqTRayKmbE0th1e7jovBRQja38L2UHTNhPCDmFvHabZUrhy13IZ9c4orr2CpfMZgtUQ58AqtFsDNGRYNfEPjWj9ESWHDl2+1ApDorU5CELaT6jxDBXVeOei0N83WxaaNxMJeNg3IsazAdTc2oB7BzrxnyM0RIebRLEozaZvS0au+DzdWfAQ3N2qfNw+ESDm8aCr7XGK+oh5XO7Nv9GKDezgCPE2Qq2+njnoZpXyJaVmUKfqcaRAlGjsf86ZAZii36IXRx7KCiBgFjBpwocLDsMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--3ypnmqpyuzbufluf
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 2/3] ipc/sem: reject negative SEMOPM values
Message-ID: <atyvbQ5xxtxcxBZE@debian>
References: <cover.1792808260.git.x-professor@outlook.com>
 <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>
MIME-Version: 1.0
In-Reply-To: <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>

Hi Yingjie,

> Date: 2026-10-24 12:21:42+0000
> From: Yingjie Wang <x-professor@outlook.com>
>
> The SEMOPM field has been stored as an int while semop() receives an
> unsigned operation count since the beginning of Git history. A negative
> SEMOPM accepted by proc_dointvec() is converted to a large unsigned value
> in the comparison, defeating the intended operation-count limit.
>=20
> Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls inside ipc
> namespace") made kernel.sem writable by IPC namespace owners without
> capabilities in the initial user namespace.
>=20
> Parse writes against a temporary copy and validate SEMOPM and SEMMNI
> before changing the live settings. Hold a per-namespace mutex from the
> snapshot through publication so concurrent sysctl writers cannot publish
> stale values for fields they did not supply. Access the live fields with
> READ_ONCE() and WRITE_ONCE(), preserving the per-field access semantics of
> proc_dointvec(). Read requests continue to use proc_dointvec() directly.
>=20
> Failed writes leave the live settings unchanged. Successful partial writes
> change only the supplied fields relative to the latest locked snapshot.
> The writer mutex retains the existing per-field visibility for readers.
>=20
> Keep zero and positive SEMOPM values valid. Zero continues to reject every
> non-empty semop() request.
>=20
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Link: https://lore.kernel.org/r/20261016155905.2a659b7bb7d61f33467a3263@l=
inux-foundation.org
> Link: https://lore.kernel.org/r/51c93c19-f1dd-455f-8698-6b1ee30eb630@colo=
rfullife.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yingjie Wang <x-professor@outlook.com>
> Reviewed-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  include/linux/ipc_namespace.h |  3 +++
>  ipc/ipc_sysctl.c              | 35 ++++++++++++++++++++++++++---------
>  ipc/sem.c                     |  1 +
>  ipc/util.h                    |  9 ---------
>  4 files changed, 30 insertions(+), 18 deletions(-)
>=20
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 12faca29bbb9c..c06568ccfca88 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -4,6 +4,7 @@
> =20
>  #include <linux/err.h>
>  #include <linux/idr.h>
> +#include <linux/mutex.h>
>  #include <linux/rwsem.h>
>  #include <linux/notifier.h>
>  #include <linux/nsproxy.h>
> @@ -31,6 +32,8 @@ struct ipc_ids {
>  struct ipc_namespace {
>  	struct ipc_ids	ids[3];
> =20
> +	/* Serialize kernel.sem writers. */
> +	struct mutex	sem_ctls_mutex;
>  	int		sem_ctls[4];
>  	int		used_sems;
> =20
> diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
> index d038d944257f6..a05e28e67c305 100644
> --- a/ipc/ipc_sysctl.c
> +++ b/ipc/ipc_sysctl.c
> @@ -51,21 +51,38 @@ static int proc_ipc_auto_msgmni(const struct ctl_tabl=
e *table, int write,
>  static int proc_ipc_sem_dointvec(const struct ctl_table *table, int writ=
e,
>  	void *buffer, size_t *lenp, loff_t *ppos)
>  {
> +	struct ctl_table ipc_table;
>  	struct ipc_namespace *ns =3D
>  		container_of(table->data, struct ipc_namespace, sem_ctls);
> -	int ret, semmni;
> +	int sem_ctls[ARRAY_SIZE(ns->sem_ctls)];
> +	size_t i;
> +	int ret;
> +
> +	if (!write)
> +		return proc_dointvec(table, write, buffer, lenp, ppos);
> =20
> -	semmni =3D ns->sem_ctls[3];
> -	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);
> +	mutex_lock(&ns->sem_ctls_mutex);
> +	for (i =3D 0; i < ARRAY_SIZE(sem_ctls); i++)
> +		sem_ctls[i] =3D READ_ONCE(ns->sem_ctls[i]);
> =20
> -	if (!ret)
> -		ret =3D sem_check_semmni(ns);
> +	memcpy(&ipc_table, table, sizeof(ipc_table));

Why memcpy(3)?  Being a structure, we could use simple assignment, which
is type safe.

	ipc_table =3D *table;

memcpy(3) is way too powerful for this, and that can be dangerous.
A few ways where it is easy to screw a call to memcpy(3) are:

-  Size of destination doesn't match size of input.
-  Size argument doesn't match size of destination.
-  Type of input doesn't match type of destination.
-  You may forget to copy a flexible array member.

In some cases, you really want to defeat those, and then memcpy(3) is
useful (or you're copying an array, and then you have no choice), but if
not, memccpy(3) is not the best tool.

[CC +=3D linux-hardening]


Have a lovely day!
Alex

> +	ipc_table.data =3D sem_ctls;
> =20
> -	/*
> -	 * Reset the semmni value if an error happens.
> -	 */
> +	ret =3D proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
>  	if (ret)
> -		ns->sem_ctls[3] =3D semmni;
> +		goto out_unlock;
> +
> +	if (sem_ctls[2] < 0 ||
> +	    sem_ctls[3] < 0 || sem_ctls[3] > ipc_mni) {
> +		ret =3D -ERANGE;
> +		goto out_unlock;
> +	}
> +
> +	for (i =3D 0; i < ARRAY_SIZE(sem_ctls); i++)
> +		WRITE_ONCE(ns->sem_ctls[i], sem_ctls[i]);
> +
> +out_unlock:
> +	mutex_unlock(&ns->sem_ctls_mutex);
>  	return ret;
>  }
> =20
> diff --git a/ipc/sem.c b/ipc/sem.c
> index a8c9807175520..0f7d32c12993f 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -249,6 +249,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, =
void *it);
> =20
>  void sem_init_ns(struct ipc_namespace *ns)
>  {
> +	mutex_init(&ns->sem_ctls_mutex);
>  	ns->sc_semmsl =3D SEMMSL;
>  	ns->sc_semmns =3D SEMMNS;
>  	ns->sc_semopm =3D SEMOPM;
> diff --git a/ipc/util.h b/ipc/util.h
> index a55d6cebe6d3b..51b4efa3d6db0 100644
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -245,15 +245,6 @@ int ipcget(struct ipc_namespace *ns, struct ipc_ids =
*ids,
>  void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
>  		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
> =20
> -static inline int sem_check_semmni(struct ipc_namespace *ns) {
> -	/*
> -	 * Check semmni range [0, ipc_mni]
> -	 * semmni is the last element of sem_ctls[4] array
> -	 */
> -	return ((ns->sem_ctls[3] < 0) || (ns->sem_ctls[3] > ipc_mni))
> -		? -ERANGE : 0;
> -}
> -
>  #ifdef CONFIG_COMPAT
>  #include <linux/compat.h>
>  struct compat_ipc_perm {
> --=20
> 2.43.0
>=20

--=20
<https://www.alejandro-colomar.es>

--3ypnmqpyuzbufluf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrcsTcACgkQ64mZXMKQ
wqnKRRAAt8enQI5cXjKMqVjXRh1pd0f04+raK2ShM3YQhaynNwX7pqaPuQu7CNYn
XS4UU//IYiVQhRD+/a6w8QixgPRqvYbpQiVSPaOexM4TmCwbciR/XIs0PBVcyjFI
5GRV9vJBf0c3U1Lcsc2rLqtQT5X7OWK9nEjwHdrKSbYu1JOynmH43gBP+b4wyLW2
4Jhurv34jdrxGZ+oBgMBBOmSJcr3C7CIUj7kOgaJO6uA4w7d6KVcuwgHraP25Qat
+kEhFgs9G7SkzZ8QLOSzUhmY59tkAzuNuqpMRM4LfqOaNNrr8LJKEJLW5/BiZzu6
DewbIzVND0w+PwohgGESVpj+fbEjO3CMlln6tAtmneIB5rrNa5kcqLUyKdhszDIB
BeV2nVRI13zzbs7tuPa1V4/YAB53+QH+JkYadnDkwwEcKs3gGw6TA48g4Sr/L0nu
cBp7f/yslXDqiSxIyUwt1Y2AxUX/5zDzTn4/DqDyxUrWwsc6B07X0IY0rvLDSBWJ
Q68dB2r9lsFdzqdMpBb06OdBl2D/no3BEu/Xni7ROwc2RwlOK9gUS86ILuvIwpGU
jtPOTnbk7c3NRO6/xmPMPVCqGrsm5HIJEfkL2x8Gvfzp3+hnIh+37aj6/Gc9lfLn
qEEiMnILRfHuz52Lk+6KQxg4ZjFU11gtlKYtqoo0H4Gm1yGkTnM=
=dC3A
-----END PGP SIGNATURE-----

--3ypnmqpyuzbufluf--

