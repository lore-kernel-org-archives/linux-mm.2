Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF231C2A074
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 10:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F5B6B0099; Mon,  5 Jan 2026 05:41:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C566B00D0; Mon,  5 Jan 2026 05:41:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4BC36B00C5; Mon,  5 Jan 2026 05:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2416B011C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:41:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F8C19F466
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:41:52 +0000 (UTC)
X-FDA: 84297569664.17.16DE516
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5C7B980011
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:41:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZUJJqh7w;
	spf=pass (imf30.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767609710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwRMgjJ1REBlPbGQlIl+XDgi97pxhpE8kH1QwnFxGm8=;
	b=V6CR1/BtJcemhKMeXzA6Y5oIaqS38WloFNOD4khzQm6HCttwYjCd5zaIgi8s03+wwk7uKu
	QsX2pj4jRErWGyRUQeIP9BfLvcsW8GrY18DOiL/nNxOZubEJTtD2f040EYkZWFKPPzSVFM
	A7RV6+hGSiV4ThyljLJHk7RcdF0kYzI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZUJJqh7w;
	spf=pass (imf30.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767609710; a=rsa-sha256;
	cv=none;
	b=3O9Ce8CcQCua18PCBriOpdom5bHbb8psylvBgVsLgTrfWBlLbFQKrP1TW7dPrYNltQk/E7
	zOffFDACYn6uYhtdtS3x0G4WeiILjit/AoAYpWE8ZLvl3BPG4JVot24BvXK7z6Pt76D8i/
	/B93kS9+rv4VIXChKUDTqs3Ru7oV8uM=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so69397475e9.3
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 02:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767609709; x=1768214509; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cwRMgjJ1REBlPbGQlIl+XDgi97pxhpE8kH1QwnFxGm8=;
        b=ZUJJqh7wK7w5Gh5JD64yTu2Ro60htoN0CG90xZqFj8lpyxlR9BVzHx8nf3Q8XXvsoU
         xr1Yq1HQRq77bfjHBli8EmcT00w0mkz6mgz/iEcTZunk0SEVRruapK8KvbTjyG4mbBy8
         5v/0OdLxXGwtDVQapB9eXTGqmKsOM3vZL6wkWauwJ+Md2nTFBBjOpcMo4AlQdHKiYyKi
         k6Mp/8s3PxH4A8/MsfiNXJI9ZfpIXSOyG/NGMCfjLayJloDWGgVrpVD1cyElf+9jzPmQ
         NUEkSNpnnrpLA/G3h2soXndmKdxOko7A2/oIzpThm3VejAKCEOj6wl8vYtSGGEXQdL2D
         AVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767609709; x=1768214509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cwRMgjJ1REBlPbGQlIl+XDgi97pxhpE8kH1QwnFxGm8=;
        b=kiFbIz8h0AwTgL5oKqAAz4T9wI9vf3qXzqflytnzk85pq5GhC+IX/j2eTI5z3J89QS
         ueyMmY4Sabeb/mq/GuutmfphtpYiqnGpKL2T/y5CP4hXYOyHRQmkI92nKi7JqxztXYyM
         fERRvtnFngNxcR0tYHSP/YQJzk0kbpcJzoL3wWizC3KzCC0sRKitUzFwzepkyzBPA/Yz
         ss4n0qyFbagUrHZfFwHep35LmDopD9lBFWGJcd4iC5v4bvFCho0wI2EjyEPXL3SEbdLa
         bajgKUj2KPU0dpDxAPXb4+jyVOwh4h9wgFgb2WdzyLHg/Y+G3rujAp7ClDWpfHKpQ8Cz
         LaAw==
X-Forwarded-Encrypted: i=1; AJvYcCVJOOboq8ySeACodFTDqoyPQJ2fpnkoipPPf4BdK1xN9GQnbfvD3+k4BkaaK5YCwX23Ek5vJPFdZg==@kvack.org
X-Gm-Message-State: AOJu0YwRgFW6tJKY1mDvKRuG42szKdr7yi1izeb7M6cOkHddjq7qSFRD
	Qt5jiHu4Wm2yaRZC3XkJQcAiWNzTU8Sm3414W0ZWmorX24tegDlAaY6DPWiFUyKIXew=
X-Gm-Gg: AY/fxX4AJM1eePmaa6IgVi7csi8vBoqNyFHVvfX+yrtxRoATENA7SnVvszkr9Wtunwq
	ur9M8qzUOWCfqt9TgJ7FyXWLdZy/yuFu6I0hOBqFxf91tnfTw1tMVvt1IeGoP7WP13ns9ewLpSN
	Nfo8X6pGoMgOZ1MsdJaNfk7DJRae6faB6KPUfLMEGyJhXrCcgTEGERtsryLEMSas33Z7iai4Rcc
	J6VlHXLQz1wAF2nYaQgCPGTBPX88G31xVut4AE9AtNiPR/8homzMrxYo0xuPLuCk30GURI8hTIm
	MXPW4oBEvG+P2GirI3NGIGJLmP3vEVUhpCKZ8XHAhNIdvSISPXq/ID9kzG/f1rPLIQqIC5x76hY
	kKQ3yunmdX2xuJNMlyCkRUKFfnqPGcP/X3q91QHvMJ9XfnkOVTqhHzOTWZwNJLLQ37B5oTsJ3H8
	TvJe0AWUdVwVRa9Lnu4IhtaQC46LDYoxE=
X-Google-Smtp-Source: AGHT+IECWsjB7/txmP0HgeKCwDbI9pUM7KK9bH4s4kvyNVTIeeHKMkgEpS+/DUbzMvFUyCv6YG466w==
X-Received: by 2002:a05:600c:46ce:b0:477:fcb:226b with SMTP id 5b1f17b1804b1-47d1953c020mr533903055e9.2.1767609708647;
        Mon, 05 Jan 2026 02:41:48 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4327778e27bsm66477762f8f.12.2026.01.05.02.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 02:41:48 -0800 (PST)
Date: Mon, 5 Jan 2026 11:41:46 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH v2 27/28] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <prqhodx7wc3cbrlh7tqf632b3gpcciwmn5n22qqv7c7rbtsoy3@lsnd7rtdhfmh>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ku7l4vetqokv5nol"
Content-Disposition: inline
In-Reply-To: <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: sii3tt8dtrmwd3nfaxd5i4uzzuouryfo
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C7B980011
X-HE-Tag: 1767609710-277849
X-HE-Meta: U2FsdGVkX1+SfeizB80oLirmDWL1auXS/xEZHFDG6xZc+EU2Ye8S8rXu1a5qfLtRF0w5GOp6bS2i6D2ZeSRmGnufNYXycKUvOVXoeMblolFh2c24DEk77eoqrjLIGq/gaDU7tjf1V9Br6lU5Cq4P9ran5xjYZsRHw1yxPXm9lDMs/qR9+abtizsC1ZnNEbMvLGESC8hR+41eRjpYmDakLangArsasmhQMRmX6DQOXLA3XM0/UDHRzymEDk8fHrzRmE0o6INVKHxvlV7GdEcVlsJkPHvlTPoSS0eckr801bzAg0pPewwla2aasQKHsjdy1C5PAgCg+3ZkgkLEaNAh8soSnAieFJnaq2pUa8w0MsY5vNhqsblE26TSVJPGdxi7G1QMd5nhfn74mmyTj7AGwW7JsNDxuT8Ug9e8oR2RSlJKc7xzRJLYeSE9UzEfdRzpYhE9DbsHyWfIxodpz62kUuMEsAeKnPHmo3mv0lJ8ovNY8hajhAr+rXVgGXTeAoGp5a7AqOAmb//2qrO/GDUIj7TjeftwYztkFeKSRm26n+lGODPtXnLyIPve0vCH20Kwb7kCDtKDz+wvTuEuP22VJNhV7tqdg6ONlZCwsxW+VCBCixENyE0jG1weXCwIsTqrju+6CHmQxccaitEQ/00znsE90qQqCBjTX2gCFB2M+9VNm4G80tlSfXFeLlSfTTH798NGepg+le0tk/Ms1fOPpLUIopLgpoVeVCticuxxCOY8MUDpMrqDALH5yL3ZfE9cwzZLBup8dQBxoBZU0AwTVx32EJeKGPZ0j6vVzC9MtoHVSzGu6kerH/j3xzpbIKYQjKevC6qfLZHLu3mCfWyt/LNEqSSiG74akeTndXzLxgJ0pkibARN9r/Ft6RjHV9C9WW/GwROIWjGCeBEK3itEEGbxegjQrJjq4Pb3mHZzMXqL9Cr0xSGnVrO5Zd9scay2FwAjh87UtqcOKi9r2e7
 oRpYVjUh
 FY3GNCEmea793VTUinuXeJpKROiW5/7AEiIqzAodj8dTt4KZDX8Ur9qnGm9SrR35a/EYfAhyKsOuHZibqugz108zz70/JQPBfohs3qYR8JUCz66gUs/jyTZZvGYv6EQ0VUasR1ne4Ok8MOdKbEPfBZi7RbZCm0fXS0pTFLlrviZTj8skQnm12pOrfCAvAMv231KtT92OeaYE0PNcdBvOFWstU8pOxdiBWpTFZq1sFnM3dTfXJzeSCaRZnub8Jd3Yi1J/kL3jwRqudVg8emQ1uQfQYhIGirAIvLy7/AkRkSi0PUuBbrJiZJsy1YTcyR9wFSmARcExw0YD+IeqGqBX619Vh0gd0GvWIAw+ZQi3QuzBRapCISHISyVWz0yUwULODkTHqQlSCs2taw/Ro5FnlCnU+JtSRTPwSu3rNjpvGNnkXLJexUsbs4I789p7kIyJqVCFfVm/XOoF7IW4FIsxip1J4ibDDUrQOcQp6dxHi++ThbFtzdEdqbgYQMy5SUgWv6lofvkbSBLlmoDZVQBCzSeC+jDytWFuPbALZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ku7l4vetqokv5nol
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 27/28] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
MIME-Version: 1.0

Hi Qi.

On Wed, Dec 17, 2025 at 03:27:51PM +0800, Qi Zheng <qi.zheng@linux.dev> wro=
te:

> @@ -5200,22 +5238,27 @@ int __mem_cgroup_try_charge_swap(struct folio *fo=
lio, swp_entry_t entry)
>  	unsigned int nr_pages =3D folio_nr_pages(folio);
>  	struct page_counter *counter;
>  	struct mem_cgroup *memcg;
> +	struct obj_cgroup *objcg;
> =20
>  	if (do_memsw_account())
>  		return 0;
> =20
> -	memcg =3D folio_memcg(folio);
> -
> -	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
> -	if (!memcg)
> +	objcg =3D folio_objcg(folio);
> +	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
> +	if (!objcg)
>  		return 0;
> =20
> +	rcu_read_lock();
> +	memcg =3D obj_cgroup_memcg(objcg);
>  	if (!entry.val) {
>  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> +		rcu_read_unlock();
>  		return 0;
>  	}
> =20
>  	memcg =3D mem_cgroup_id_get_online(memcg);
> +	/* memcg is pined by memcg ID. */
> +	rcu_read_unlock();
> =20
>  	if (!mem_cgroup_is_root(memcg) &&
>  	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {

Later there is:
	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);

As per the comment memcg remains pinned by the ID which is associated
with a swap slot, i.e. theoretically time unbound (shmem).
(This was actually brought up by Yosry in stats subthread [1])

I think that should be tackled too to eliminate the problem completely.

As I look at the code, these memcg IDs (private [2]) could be converted
to objcg IDs so that reparenting applies also to folios that are
currently swapped out. (Or convert to swap_cgroup_ctrl from the vector
of IDs to a vector of objcg pointers, depending on space.)

Thanks,
Michal

[1] https://lore.kernel.org/r/ebdhvcwygvnfejai5azhg3sjudsjorwmlcvmzadpkhexo=
eq3tb@5gj5y2exdhpn
[2] https://lore.kernel.org/r/20251225232116.294540-1-shakeel.butt@linux.dev

--ku7l4vetqokv5nol
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaVuVXBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AhVZQD9G+b2BIoTwqzZNowZZZOP
dajgCA4XQo1Byl6VDL330nMA/21a9Ksyc7ayU/0C92yKZNkp4ovGmd3u2y3uH3X9
E6AA
=CzoF
-----END PGP SIGNATURE-----

--ku7l4vetqokv5nol--

