Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B09606C550
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eM3VbPfa
Received: by kanga.kvack.org (Postfix)
	id 8C9AA6B05B3; Tue,  3 Nov 2026 06:29:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AB26B05B5; Tue,  3 Nov 2026 06:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793E26B05B6; Tue,  3 Nov 2026 06:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB9B6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:29:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B716D140383
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:29:46 +0000 (UTC)
X-FDA: 85393587972.24.68974DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 348FB180003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:29:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eM3VbPfa;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705385;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLKPltpOKrJeivfZ4qfED8CPkzZvz3KzKJEccxtQyxE=;
	b=xKucvrwWC5EQYx+O9Rc/FinlyO4ybEc8GSACsRwd2cw/oU50fSwKAqlTGsBKEu4b2NTvuQ
	U9G3NzZX4++al6aPmyVIlmrSIjz8J/WJBM23sZAfktkWfBHQRnJ3u8AKA7q0u6L09aEpcu
	nvxbBDroc5IVlOcbVmiZ0Nkl9UDHvTg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705385;
	b=VTPeMydK0QgmJ44X3KIuLwhS29SeV+YiTe7uBF8MRJsO0mQb1eH0Ym7BJEvJ14qkQiq9HW
	aLM7PTsuJZoM+VZaDDv5mnQ0guyjkLxXk0EHjyyPCfp87RduDz0Ruzidg1CR77ZKZVKd/e
	tIx2C/rlIZYhMji1H3NPLY07O8Z4tq0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eM3VbPfa;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47CE160626;
	Tue,  3 Nov 2026 11:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5504E1F00A02;
	Tue,  3 Nov 2026 11:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705384;
	bh=pLKPltpOKrJeivfZ4qfED8CPkzZvz3KzKJEccxtQyxE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eM3VbPfa7wawjF5nU6A0ctvbSq1HaIv3xtC3m8UTaP+3sc7J4X6m+MLj/JKQGSQu0
	 OiesQyiWwiKBh7oCBbcaH6/AgHm++Si8ln0YhocGDY/M6zemUy1kIEwDqbpKmRNs6m
	 2fftZ2T7Z3A9xzMcS6AXJ23fPzULtvF8MJBBj1NOGrEJmKikk4WIVp4eBr7KyVcY5b
	 Rc3t9oLEtEOewXvnPCM0uO6hSb18zNgjDPPWT0ZWnrkyG9Ik/0Rhhgive9Gm6m+SB1
	 FlG+EKGkaHO7VcVPez/Ee8kweyKH/fquCZB4Eg8uumIscXyljJ1H4hBGuM6mUeI5Kc
	 ZMkLVIMh6TlJw==
Message-ID: <sashiko-outbox-195152@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/damon/core: reject empty access pattern intervals on
 scheme commit
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?WGlhb2xlaSBXYW5nIChLYWlob25nKQ==?= <xiaoleiwangxiaolei@gmail.com>, sj@kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, error27@gmail.com
Cc: damon@lists.linux.dev, linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, "Michal
 Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
In-Reply-To: <20261103105418.362459-1-xiaoleiwangxiaolei@gmail.com>
References: <20261103105418.362459-1-xiaoleiwangxiaolei@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:29:42 +0000
X-Stat-Signature: 7obegpzra77k9tdkxparckjcsr5kgbui
X-Rspamd-Queue-Id: 348FB180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793705385-216266
X-HE-Meta: U2FsdGVkX1/1zjfoQDibC7lEc5uRenC6yUd97XpQb5BN0Kt8nu+K4bZl4PvzVEJ7/kTi5J9eB3iGBQKh4uHX8RviblAB7mEn8ZAYOIntQqsPYT7CgbrTiyH0aFDl31dz+2DJZ83drvDeqxnuO0TB41Akop5rsuWkF/XZJsgAMB57CNxZm7Hm0ehV3xYqSNuL3NQR3tACHpV+0Y70KlxOqUoD5FhNJE4JAXycDcfzb8Q7e3hDhrSjHGHtjj0CjrIFTVH+dEjDZqslSo7RArzQJV1i+VF2d5Uq+wrDMjyzg4E+ZD6BD0LVL7ZHRBjuMgrRryQ03j/BWEEamwYGdMr7U0xME8GWioQYIQYM637HrYVoBOxtnGegu/sVAyUK4yO1K7PtYgycD+Ww7MiOW9i0o4ycVC31oi80FPicTZE4T2QxltJE+tnPxUxNbP1ThXCl8Ok5R/QJFToPVzS+8AtZW7GIHGzv7C2au7x6DYH8jsGEIfadUfq0g7L8/yzfoyS/xuElTgLc9gjhfRbJ+TJR+xqQkJRz+TItQy6mA8iUKuta5pL9Vvl24MDuO9yuQnwh7EmO4qldNt8cu5xbvQYdr4GbOpmxkHouoRkTEfe+o5CPZ+tXUYQV/9Z+7R3JDtvB1XHxu57B4MEZb7t3duUUmEV7ZgSfGFYDo50nLHA2y4mk7CZIwhzOPJ/fdfDNeJSFDyANMHuMuhtiL7kP+gnO4qvo663wvxjEhHik+dVU5oAIeSjE5wGEgtvJd+lTwNjem2HZRgZpIBgp7O3TTL3mEo5NgrrN6g08VrkF/K8NcCEoYei+CIthFVEUcflhaxL7DfylMIxXn2FaY75mWFPE8mBRaGgWLxKKEevgtOoaKiNTlZtq46tOc7x4wQ8iFqyJKwL0GJuc15MQvDH+RlKvY0uWeq/W88pEVYmXfcaeBNNoIOlVaLjmmw4lloIIBuvhTm8HBoN7IcVz5Yrtm29
 xbK9WXMB
 3sBcz0VgmgdtVDW1/JDLkX+w6Cbey1+jWRS6UNNFKRe2fKiNDgHjQhiJMfrGfSLpOcTGMYsNEMQXoA2aZ8WWHMOrcRG9KhkniHWJ2uNnEFCxjPOi6sKDkgJPqrRLPc6gB7Y+1xgpP/qXWQNVbQunBInBrA0WQh8H60NWNfxrU0Z1iLxqqrkgH2NqJOht0Cgt/z3QUunot2gEbRai1aKV0K8PTlGRoZEHYoAVyd7/h5qqLmEDHRMwJTElaoGYsgjkCPGfIa5S00SrEVjCRtaYFO0iWiC26pOvOBtBDmIky8HJJuNfmmqVhdc4B/RUtgtkyOr4sYKAnceiT7UdW+Ijwg05xWD+5pGP/aoowgOQM3KkUSLIt9PM4iyx5omCHKHV8oEpaf6ZINPLp8ba4FACn1XltFsCR6vl5s0sP+U//oKfsdgAg8og7+xQIdxsbmfcQ2QjNmF2CFydQ982wO/4k/HrDsjD2gR//jV1wiU/UC9tq9g5KKXT/D8n4ZVrEACA57/2u1Uta2TCoVSI/Fm4rt9b3YBO9i14O4t2vLhqJNxfTV8h5XguAHCXdVtHIRnF/+hr9ey+Qa9AWNNVS/qeQOcwWKwU+pG0KrKoqVpjUhKvRIV9gD1mCON4xcWTKRbHi8V5D
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
- [Medium] mm/damon: damos_validate_scheme() breaks DAMON sysfs.py selftest
--

commit f1effb4d8401c0508f7cb04b14b9b55d0d6abd17
Author: Xiaolei Wang (Kaihong) <xiaoleiwangxiaolei@gmail.com>

mm/damon/core: reject empty access pattern intervals on scheme commit

This commit introduces damos_validate_scheme() and calls it at the start of
damos_commit() to reject DAMOS schemes with reversed access pattern bounds
(min > max) or non-monotonic watermark thresholds with -EINVAL.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index d36823f4d0928..9b2b2a63a2576 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1561,10 +1561,29 @@ static struct damos *damon_nth_scheme(int n, stru=
ct damon_ctx *ctx)
>  	return NULL;
>  }
> =20
> +static int damos_validate_scheme(struct damos *s)
> +{
> +	struct damos_access_pattern *p =3D &s->pattern;
> +	struct damos_watermarks *wmarks =3D &s->wmarks;
> +
> +	if (p->min_sz_region > p->max_sz_region ||
> +	    p->min_nr_accesses > p->max_nr_accesses ||
> +	    p->min_age_region > p->max_age_region)
> +		return -EINVAL;

[Severity: Medium]
Does this validation break the existing DAMON sysfs kselftest in
tools/testing/selftests/damon/sysfs.py?

In tools/testing/selftests/damon/sysfs.py, main() constructs a non-default
scheme for testing online parameter commitment with min_sz_region =3D 4096 =
and
max_sz_region =3D 1024:

tools/testing/selftests/damon/sysfs.py:main()
            schemes=3D[_damon_sysfs.Damos(
                action=3D'pageout',
                access_pattern=3D_damon_sysfs.DamosAccessPattern(
                    size=3D[4096, 2**10],
                    nr_accesses=3D[3, 317],
                    age=3D[5,71]),

When main() subsequently calls kdamonds.kdamonds[0].commit() and
assert_ctxs_committed(kdamonds), writing commit to the kdamond state sysfs
file invokes:

state_store()
  -> damon_sysfs_handle_cmd()
    -> damon_sysfs_commit_input()
      -> damon_commit_ctx()
        -> __damon_commit_ctx()
          -> damon_commit_schemes()
            -> damos_commit()
              -> damos_validate_scheme()

Because p->min_sz_region (4096) > p->max_sz_region (1024),
damos_validate_scheme() returns -EINVAL, causing kd.commit() in
assert_ctxs_committed() to fail and exit with status 1:

tools/testing/selftests/damon/sysfs.py:assert_ctxs_committed()
        if kd in kdamonds_paused_for_dump:
            err =3D kd.commit()
            if err is not None:
                print('pause fail (%s)' % err)
                kdamonds.stop()
                exit(1)

Should tools/testing/selftests/damon/sysfs.py also be updated to use a
non-empty size range (for example, size=3D[4096, 2**20]) so the selftest
continues to pass?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103105418.3624=
59-1-xiaoleiwangxiaolei@gmail.com?part=3D1

