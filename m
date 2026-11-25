Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C29C606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 00:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nrDwQrMO
Received: by kanga.kvack.org (Postfix)
	id 5C26A6B08BB; Tue, 24 Nov 2026 19:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5999B6B08BD; Tue, 24 Nov 2026 19:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7306B08BE; Tue, 24 Nov 2026 19:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E44F6B08BB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:32:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27CBFA0E24
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:32:33 +0000 (UTC)
X-FDA: 85471765386.26.72B3DF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 785E4100002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:32:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrDwQrMO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795566751;
	b=AQNBij3f8mz6NUSAyW+ZYTVdz6qeSLu7dKQUfIIahkOTg/a89gbADBUdbbGF0GnR7rtpnt
	kECIad3fotf7Yq+YS9YcuJcB1V2wcq9EZJlJkTHThL26CQKQlhvatJDRykz48twFDN2AIk
	fMUudrUI3bSSatnup5xoJYDKc6hN44Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795566751;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kV8T9KghjSzWI5XC/HdS39t7s/X9fFMZu6tr+/jlyzA=;
	b=pb1HjOplmDpaRx6jscU7oUtF5e9NHyY6dpMFUIqeoHy61sRU8J3A6YGbp/zXGy9tL5pLdy
	0rdlJUKw/YGjfpxCtutc7n+UtBSrPNEe50VLw9sePQfLFFSsJOoJRPAFm+S+s1kM2OTMBo
	IA8aUqRYauSfX9hAhxSDBqKfJU1+cUo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrDwQrMO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EA6B45A55;
	Wed, 25 Nov 2026 00:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B079C1F000CA;
	Wed, 25 Nov 2026 00:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795566750;
	bh=kV8T9KghjSzWI5XC/HdS39t7s/X9fFMZu6tr+/jlyzA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nrDwQrMOk0ZnxRD5VrLhJKcjZlF5e9qZKnjaqCg/mNgQN6JAnTDfAzYPzHdLhiTUF
	 WdOYKB9ddzb+IgWbru/nlXL/6DGw8Pg8RLtcIv6bc69w2Xzpj7w881/MTn/nKb30aP
	 6fw+tXrcUx/cMjEdzKQ5zZGe+UN8VmGvNVGIHhpQKrQUkeBZdNb435FPBYjT3FCLoT
	 HnGZrYU8Psz3fS4dLXuIg9jX5Rz+OL/x+d/45+HuaTOmm8jQHvFfFRCnFF81/Yylwg
	 tejSmKKYuejR1IfsP326x/yhXRAwwR7X/bV4G8xM1RUlQk+3XHm/SROxCgCF48K6z1
	 uZjsrOndqqj4g==
Message-ID: <sashiko-outbox-232294@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] mm: memcontrol: let a cgroup opt out of HugeTLB
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Harshal Patil" <harpatil@redhat.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Tejun
 Heo" <tj@kernel.org>
Cc: "Muchun Song" <muchun.song@linux.dev>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Nhat
 Pham" <nphamcs@gmail.com>, "Frank van der Linden" <fvdl@google.com>, "Yosry
 Ahmed" <yosry@kernel.org>, "Waiman Long" <longman@redhat.com>, "Oscar
 Salvador" <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261124003145.80705-1-harpatil@redhat.com>
References: <20261124003145.80705-1-harpatil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 00:32:29 +0000
X-Rspamd-Queue-Id: 785E4100002
X-Stat-Signature: wszyb6z84wqncqhzjbpprwkm7zze63yk
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795566751-387327
X-HE-Meta: U2FsdGVkX1/ODeyBuV5da/XAg5OfHuMyA6hFKohuN6+dMvHbUNt2wmt1duqkNA6uDHA5N9yOJajUWG7hJvB3UZaiWOUKYaaJk1UiihPIzmWj5bAVC3ljh2G91b5byUrUQKJv6ajD6vXG+kREg/VRUIIatYebH3WZYsBQa4fOF2WRNv8A7cuvDb8wXE9bSCFw5EfJSDu2BDq2RyEwyml+FvXjsh1rCUaAdOKF/dvhjsSjUi6jXciLepYaIlN15RG9kUZNZw3YreQLsg1ug4E29NAuVIhZbAR2VNWIAWzB8yNisnXqfZU5BPMnbD/FVkaaRHEAju8NRooU+3Q7xsHQPL+jRibZ/3gdGTiOHJRwbLe9QbAqmlYuixMfNrtvMWS52P5Xyxaq4WD+kwTHHIPX2NKj/ZkIkpAeyfx31mwgDYDWdmRVOsk5oH+YtNXrWjeXKjPBhQ38Vz2fff5FcySnJJCAozfOqeo3HxIxpsANlBUBJglRrC6I/1rvxO9wiEXXztZ1nJ1NLkBH0ZMI7+ESY0in61bYssIPRvLkvSLFoaKW4vNLiaCp4QCvw85vJhXBZSIFSHZjG1HB71FiE9Li+D+QhyBjvpJPC+gyV1YMumSvy0EkMqZL0AcfOTdKosj6hpc7+QSJhoHP9VOaJzub46hkqCXQcIMixrnRESYz/2W++PkENP953TifxMJrxMvP4ztkCXmlJtjwbJbVnNkKwM8A6L56gctVPB59OPFk8cKgQ3iXfhGA23yQqmgM7Dmp2TJSZSoIlDfypwU+lIV02vsDaWWYxAf1wCWhOUmNTM8D6ZqggntU4WPGVb2Nxw19MGpZy6k85YiIGGhFHD/CkToZVdGsTQIkdG7nU1CXI11YE3vu+alIhDkDgKnHg66niRceoft6/LDxY19LGf42wZN2d6rGBketjmCxpEkABhItzfv5AE1oRQKryGPOUPZsMJQxjuOL3fSq6eMK8mD
 WaFPEu7A
 sUXJoLXSWXTNIN8kmz7Y/5bszTJijVDKelxOnWKX3erosFcK1piPZx1EcI8cbWlL6O4t/gyS3IEFp9jl5PLWMI7Uklrq+XUmTNw7Yy5NuR5tYvK5/6hPUlL3DQzioGKc2tL9Y2lhOD3sRk9ctCrGWrTxJuVMXsPc+Kwvam2jPC6nrAvIhcbp/y3rmpjrzdaoJKd9j2MfUzmhXn1xUWJUzksUrwMgOoDpaAQvZ9tRab5sPgEAcMuBLSKjtENYcfiGLjcO5FEe7ZM6WV6GWHgAKqEiAAQAfkVbcP2XO+zDv3LhIW3A/22mLOFHKWasTSkTfRgn2wtkdASLfD1aKvdrC6bidA2QNG7uFsy4LPHkHjhUTCcIkOq7TCXepx5Bw3qSxA7/nGaT/gzaDmuPpw4WXcpyEuEoNDwT3ftnU2N9ar26xj8fwq+silXmzk3ZJ41lRxRrP7Z8zuBqmhGgLYWf/Kp0VSRmXlsnVnVy2FSCEb1M/stWYjXJ9PQYrGUG7X0noNKwRdZsnOkDN/TyAd3+8ahO4hZztIhnPmpxJXdz8N3bxCr5gj9uGdYYytfYUObKGf9vJ9ciJ2nCjO90ds5PAZW0HCOXZ+cbJigu3lv423kKItcmU4fjlaxdLpOgAOO4wmZ/8pxFJeSPIjDwlweJ7cvynzgNr27sbjOIqsgqCd1D77BoKIgIvi07PFB1Ol7pitlVeazcX1WkUemBpk3EZdUQvNTquloBdmbeLXXIa9EgGtQcnJl1LDg9dLNS0IvnKF7qDMAENKc5bVrvsccwdm3MQ3e2Mik2UV2zn54DgR9PWSfu1aCHc4BKXnmWy1qgH/xqJewZYf0wdSfDGjDgcGD0DMJshbKacsv/NRtst5AL1STahDTY4KfCuFG8WQgC31uMx5NbZNHRulEzu+TGFjLfUZVEoMKEunCNlWrUxMWdVSq8gKG3tK99jGizFnoVlS2Y2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] selftests: cgroup: unflushed root hugetlb stat in
  hugetlb_opt_out_program()
- [Low] selftests: cgroup: silent skip in test_hugetlb_memcg_opt_out()
--

commit 7608afc552161fa7f74ef34d7e8ac3bc7ba49d98
Author: Harshal Patil <harpatil@redhat.com>

mm: memcontrol: let a cgroup opt out of HugeTLB accounting

This commit adds a non-root cgroup v2 control file,
memory.hugetlb_accounting, that allows a cgroup and its descendants to
opt out of HugeTLB memory accounting so that HugeTLB folios are charged
to the parent of the topmost ancestor that opted out, and extends the
hugetlb memcg selftest to cover it.

Link: https://lore.kernel.org/all/CAPTztWY8eDSa1qKx35hTm5ef+e13SDnRHDrevc-1=
V1v7-pEP3w@mail.gmail.com/ [1]
Link: https://lore.kernel.org/all/ZRQQMABiVIcXXcrg@dhcp22.suse.cz/ [2]
Link: https://github.com/systemd/systemd/pull/39486 [3]
Link: https://lore.kernel.org/all/ZRrI90KcRBwVZn%2Fr@dhcp22.suse.cz/ [4]
Link: https://lore.kernel.org/all/20231002162133.GC5054@cmpxchg.org/ [5]
Link: https://lore.kernel.org/all/CAKEwX=3DOwrMNMAvve9a965mBJm8as+njtXE993V=
cnKXdccd5GEw@mail.gmail.com/ [6]
Link: https://github.com/kubernetes/kubernetes/issues/144131#issuecomment-7=
104174643 [7]

> diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/=
testing/selftests/cgroup/test_hugetlb_memcg.c
> index 8c5aced813b62..54e34ee79131b 100644
> --- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> +++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c

[ ... ]

> @@ -196,13 +201,197 @@ static int test_hugetlb_memcg(char *root)
> +static int hugetlb_opt_out_program(const char *cgroup, void *arg)
> +{
> +	struct opt_out_args *args =3D arg;
> +	long root, child, parent, grandparent, cur;
> +	int ret =3D EXIT_FAILURE;
> +	void *addr;
> +
> +	root =3D root_hugetlb(args->root);

[ ... ]

> +	/* memory.stat is flushed lazily, give the root time to catch up */
> +	cur =3D cg_read_key_long_poll(args->root, "memory.stat", "hugetlb ",
> +				    root + LENGTH, 30, DEFAULT_WAIT_INTERVAL_US);
> +	if (cur < 0 || !opt_out_charged("root", cur - root, true))
> +		goto out;
> +
> +	munmap(addr, LENGTH);
> +	cur =3D cg_read_long(args->grandparent, "memory.current");
> +	if (cur < 0 || cur - grandparent >=3D MB(2)) {
> +		ksft_print_msg("memory usage should go back down.\n");
> +		ksft_print_msg("grandparent memory is now %ld, was %ld\n",
> +			       cur, grandparent);
> +		return ret;
> +	}
> +
> +	return EXIT_SUCCESS;

[Severity: Medium]
Should hugetlb_opt_out_program() also poll args->root memory.stat after
munmap() until "hugetlb " returns to root?

test_hugetlb_memcg_opt_out() runs hugetlb_opt_out_program() four times
back to back.  Reading memory.stat only flushes rstat synchronously when
pending updates exceed MEMCG_CHARGE_BATCH * num_online_cpus():

mm/memcontrol.c:memcg_vmstats_needs_flush() {
	return atomic_long_read(&vmstats->stats_updates) >
		MEMCG_CHARGE_BATCH * num_online_cpus();
}

Unmapping 8 MB (2048 base pages) does not exceed that threshold on
machines with 32 or more online CPUs, so the next run's non-polling
root_hugetlb(args->root) can snapshot the stale pre-munmap value.  Once
rstat flushes both the -8 MB unmap and the new +8 MB fault, "hugetlb "
settles back at root instead of root + LENGTH and
cg_read_key_long_poll() times out.  In the fourth run where grandparent
also opts out, grandparent memory.current is never charged, so polling
root memory.stat after munmap() is also needed to verify that the
uncharge took effect.

[ ... ]

> +static int test_hugetlb_memcg_opt_out(char *root)
> +{

[ ... ]

> +	if (cg_read_long(child, "memory.hugetlb_accounting") < 0) {
> +		ret =3D KSFT_SKIP;
> +		goto out;
> +	}

[Severity: Low]
Could this log a message with ksft_print_msg() before returning
KSFT_SKIP, so the skip output explains that memory.hugetlb_accounting is
not available?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124003145.8070=
5-1-harpatil@redhat.com?part=3D1

