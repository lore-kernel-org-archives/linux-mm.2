Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04643CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF416B0098; Wed, 17 Jun 2026 08:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D961B6B0099; Wed, 17 Jun 2026 08:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C847F6B009B; Wed, 17 Jun 2026 08:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0836B0098
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:26:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16BC91C0C71
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:34 +0000 (UTC)
X-FDA: 84889327908.22.0C02F2F
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2EA004000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VY9QcIAg;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KplI5DIltMOxeWE/hVG9qMzqxTkTYf7x6780RRs6dfI=;
	b=IKF5Ax5NBDIkNrui1I6J5V+RJQiNBhJEoPL2meeWUZFZaXM56uFF0K7aP+1E8GFMNNgjXV
	s3ggivhDARoVo7lZZYPCc6jJV76R/LjFv3NdEzmytCZPFrkbjp2jIttt2zeTxkst5GvpH0
	/mzjCPumnce2PtWhs6JrP1uuQwJhQx0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VY9QcIAg;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699192;
	b=Suawr9RpCyL9L8tixVV9QTs1E9oHcJFfreXa22tKg1I33xzo6u0h4U5nxxUKUVtz/IZ3GO
	fgdFrfuhkoyPAwUI3yTnh4fk9VzqEnxX+FejjprddP2rNwjaNLVPaBJxjhcH/vmynHqelS
	sufj4/5l1z6PjHU8Glc7mNTc4SSB9RU=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490acbb0f89so37079375e9.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699191; x=1782303991; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KplI5DIltMOxeWE/hVG9qMzqxTkTYf7x6780RRs6dfI=;
        b=VY9QcIAgMNR2t2S5Pskor0Q9pS85KptDXf1XrxhI5Pz2bbbIpbh67EuXrmijES2QbJ
         HGumlNuZigSOyHZDWs8r2yQXngbar+c2fb4zudayyT2V3a6XKZxo9bDnUodQcZVzE3CP
         J8XmR4FsACVBxmKxAaxGG5/TO1lsnznd3w/tRt9dygliZOnIYlFlyjFGpKou1imXIq4g
         ptNUVFeFcXyqgCaxdJVSYF083FzwU/B2UkE18CzSfvSMpHOZ1oTRJi7VVL38DPftJ8GN
         Ijn+nrckh3FoSzUuriALnSl8ZZlj+lsjNywk8XEC5f3529UIKFsHWMs9mjJfA5ILyJmH
         BkXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699191; x=1782303991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KplI5DIltMOxeWE/hVG9qMzqxTkTYf7x6780RRs6dfI=;
        b=hdqeUv0Ozf6bsBtDYPOgvBb/usUOfSI3UP+1gCjr8LlHE9POz82g3FLNOuQhiaNJ1/
         ro2nvW+0aNopUL50rwOj7ARoXLtc+xbaiVIqosumRxG0tmjCwRO7P7QRIXo3cKXJGbTd
         HXPgyYTAm3b/M98tXZlEv8xs8n7ftYa05BNQFJoDod/T8/ruiRmm6U8w+HxAwH158Pgv
         UGX+3LvHoLJa/BUsEJuABFbtrbT0SCvdbPDM8aJleT6H0b5UwkuY224KBGBkH8MRaPBS
         xTsoGTVHTkCQSThigtZZJU8RbuFfHeh/Y0MV5p9ia5BFy/Hy+8LRe6VErXhLDvOBJP2j
         fkdg==
X-Forwarded-Encrypted: i=1; AFNElJ8gShPmvQllOj7UJcGsNDqFc9l3j5f9k721GH0aKoRu2cjwIMblOaMGijLEKbKtqa3D8sAGSJFs5A==@kvack.org
X-Gm-Message-State: AOJu0Yx7N26nyArvny35BvrPolt2vLT2U2nqrQjlQuuiLU9CdfcsKvkK
	LNCw7OqwlmAiQkrLpdruY+9Ki+psS7+2QJyo9ZXoBwkcNINq1iviLrXrpzyHtD6QzG0=
X-Gm-Gg: Acq92OE8oGGg92KK9omk2lH23onrqPmjbb0ZRrYPx4D1E1CWnLO7aZ4UZa3JEjzvDYx
	mI73tp5F/ozalnfMdrS62vFCdHRMUfoOfV0J+BQ0aL8oqKgnbATIF3EYkKPF3CbaJJQLfksJI9e
	QWUZzH8Z9jmH+wNHkbh8wSq5o2oC9fqNYYUEYYEr3L98svmamweIzDmADSffyjRTExHxX3kAEaz
	wvAN+Gry1Bu7oZwd0FqTiC8ovgVdGgjmjVKpaAt/f8OedPQ4rsa2NvmdyQMmiSCyBNc2TyeCRLz
	dVHo09MzA9tAif2uqgeUip60vhHCg9x+OY31W+mJ0LgnW/9hsNvxVlxg8lG5ajpQvfgqzv/p/qO
	EnAd3wOy7AmSqP/ruMQGQ38K4HXL/y7ovIxxmUpy9/03vFFzlRgN9uVqDiLC0FKUlU0GFjJvVZj
	LHTBULYlJVuRxk/PrCRw==
X-Received: by 2002:a05:600c:a148:b0:490:44eb:c1ec with SMTP id 5b1f17b1804b1-492333dafe8mr43904695e9.27.1781699190703;
        Wed, 17 Jun 2026 05:26:30 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a458f2sm150801395e9.3.2026.06.17.05.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:26:30 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:26:28 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>
Cc: akpm@linux-foundation.org, tj@kernel.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v7 5/8] selftests/cgroup: replace hardcoded page size
 values in test_zswap
Message-ID: <ajKEZn0KP3KmyQd2@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-6-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yjb7q5g62opqahpv"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-6-li.wang@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2EA004000D
X-Stat-Signature: r38zag3dmhto83igwwf8kpa37igeaz51
X-Rspam-User: 
X-HE-Tag: 1781699191-412419
X-HE-Meta: U2FsdGVkX1+Ei/TNS6vFkT6N4olJ3ywehIZuAqfzkQLRhnzyxOsC1sl1NhP2fE41CG8DZQDHPtZvHooCDtsX6sEpdLUYHRvuUCukJgdzdbyKszPujIp4bkTkYAL2AxE0YJUgzk4D5CxBxJUbGhXAW26M+VPQf/k+pMHIKX2YhcXimFGQl2t4JeX+rRDAdBEcp2wsq/dP+YWsZxY6pkpcKJNeu078w9WNXOxFexWj5AikZgIl7D+1ma6dMYWFEtrC+7ukHK0iAQ0QZs6Fg4ihGeNlUy0IwAt/zEGenCSBgRbB3YH0zBAv8PSD+gkv8GKI6ahijgye67Ze85enJzXqyQUTWMbjV9cnGPG7oY/60TE05C1FYHNOOVb4qL44WEtC7yIXIPyhb5x/t3nQCjrzttRLzr4vPSSTM0dLWoLf/iTH09ZvaZqf0JShajVgVM64/IxEkzlht/OzO9KA7WoriW1Fi9YjFnJm0bEgWqL//ftQMfZ3GlebJrrIx9wR5kaqY+VIwGb5CNtr+ospTI7+5U4pBe9wsKfixfqPBMxNWryMOgIUWPAa3/RDQPeEuxrzh0qH+YfroZ94Nnw1VNrA4ijMIaO5ZZzBZE3BgOh5xG/mCz/mfevd7CzPHn2S1ex88x7UG8iiUKn4FilgnZRj0cCYWvcaGALaME+SL9aRR+gc7VRdUeL8EV6HzaPmK7REK6dwK6txXQk35fLXE9x2bOFe0cH/cCJ+HM1Q41flK4rastKSGVwAICGLNqfPYyDnN8idvjr/nYVls663XIhMn9kMKIRHycZLWcbNFEeuaDucGNDQKKcjQ+FC784EfT38XHAkhoZRq+7/TKVvM9gkYtVn7UrUv8Qfs9zpEy8D9Fypk9KModZ3WiockRrvmPhUbpTpl5EAfbPCvdngQ0jRm+82rVsSx8U53msVhxkjm6wBMY4N8Lohvtfarldy0EN1cuWJrpvYb3kVsuIntXq
 8sivUWKP
 ifL/+uF/0BdIyZfpNEmC64dPdofl5Py+2LN0F++14ZmDjnlrwI+zSj35z7pMsOcY68gi29AHB50Hgfmv6E5Jwz5ee8vO3NgNhIcqRMv75HBO6IcEuH2hBAK06YeXgn7c4bI8/eufZ6jY+LCUt8+cHizeVjQbf2KfNHrMAp/qzXOrfP1iI/eHgoR27zQq2Rh0sJOKz36ED4mnFav/lRmLRXIxoqZUpaxMq+uRrTpmpDRhODMEww1S299RaIzRzW66UWJCWBL04bzOUVHyRNAw6Wj1OVSUTLA058ItLjxF8NKzlula3K96YBzWTxmiPQXbyWsXrvhGAU8h5TC5yAI/22FLp+ycOYTNIFdAi/TH8byQkBaSk4K0O1grRAXJGao4qeXAFcZAB9sQUVaBbuLhPgDnTc+S2IYrFNhYZ4ouR4EJySRHAXFpfEkj1C6pjkE0IOnfY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yjb7q5g62opqahpv
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 5/8] selftests/cgroup: replace hardcoded page size
 values in test_zswap
MIME-Version: 1.0

On Fri, Apr 24, 2026 at 12:00:56PM +0800, Li Wang <li.wang@linux.dev> wrote:
> @@ -752,6 +753,10 @@ int main(int argc, char **argv)
>  	char root[PATH_MAX];
>  	int i;
> =20
> +	page_size =3D sysconf(_SC_PAGE_SIZE);
> +	if (page_size <=3D 0)
> +		page_size =3D BUF_SIZE;
> +

I'd just fail the whole test if this fails. To have page_size always
represent what it says. (When can this fail anyway? Maybe nommu archs?)

(Rest looks good.)

--yjb7q5g62opqahpv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKSbxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiB9QD+JZid1KLNr2xP2rppXnyG
ZyqJwgVUMqNZfB9Kc0L877YBAP851mEpZbHlmbTPoKRdoUXS0YKDMn1wPVRc2WSE
rWEA
=qqEb
-----END PGP SIGNATURE-----

--yjb7q5g62opqahpv--

