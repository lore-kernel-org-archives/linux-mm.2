Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCA9E95A69
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 09:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464756B0089; Tue, 30 Dec 2025 04:49:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F506B008A; Tue, 30 Dec 2025 04:49:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E916B008C; Tue, 30 Dec 2025 04:49:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 277276B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:49:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD3539239F
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:49:32 +0000 (UTC)
X-FDA: 84275664984.09.47A2489
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 84406C0007
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:49:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Cev52j3u;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767088170; a=rsa-sha256;
	cv=none;
	b=BehTqS08dNv5C1sqHeijdK6NQ7P/cpMOKru8NWsn/BR5Y10K+11OHPd0DgX34h9hA/ftAJ
	QkJkbkOGx691xJnpxE4QlDG48/EV9y3/BM1ZR1KuNGTaACMJvdyJPwomNPVQc2yDgqdFV5
	mSVTxkbZEaqXsNS4oVRx50eptPjkvdo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Cev52j3u;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767088170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4eaz+1wTZP7cgGZagXDHTekg6d8pOXeESnOgAUpsxzY=;
	b=OmV4LFfwWO+G0Q0KY4MLY4WmVW6aNCT6AlUnkNTq1jSfRTQ/QQyXgT8GkOv7etUrzMJoUe
	35DrN2oCJuqSr0ziI7b1MCGyPdyZz2MJDf5W7rKiqshzRVTN/dhxzs5DVEHFmWhebte30H
	qJ6bSW/ZrZVNH0B6xjrjswj9wer1cMI=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so64125825e9.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 01:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767088169; x=1767692969; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4eaz+1wTZP7cgGZagXDHTekg6d8pOXeESnOgAUpsxzY=;
        b=Cev52j3ua1fVUNNTevDM7LZGFWcMIpiJHPq9JAxlrR/pIvzl4jUSicK1NQXaYQO3+6
         cNxoRJiH+8OgAS7fF/bUSw1x3Sjy0yF4NL3C2Z6jT12evgeK7SmruDJAs22SsiOhalIh
         cftHQ6EpAYafl59baLolVh9ia3aojqj8SEzn0um3zMzvEVfE2thKZ89CZr4E5gO2IgiO
         RUN8nAs1CtlOjNfE5k1VXQqbe5MgTivkKMR8PfU3yYKIdVhLXHfQPoUhyG/XSNCJoHt1
         beXcA29011+Tkh0eK/ZKtMw/A3cPeJv/u9nn3sr0Uf8vETy5b/cNbtFmeMGZ60z1cFXB
         dQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767088169; x=1767692969;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4eaz+1wTZP7cgGZagXDHTekg6d8pOXeESnOgAUpsxzY=;
        b=azpJ3u6gDpeZ2nNRRlSJwEg3220c2oJ8hxoEMbxDyINJ0cqUdbzW3loFUD6pupu9wk
         APFMfNsRq9ZjynGNq+CzhVH38gtS6g0OvGezrBpnmsSTRZ5FYe4IKSMNIY5Z+oXVp/Sr
         fm7f26GM4zyIcSQm6cufUnGVOXroBmrUE027b8NaOckm4E3Hbnw4I5dHSugZWh0Pd/E+
         zB9G4fD/nbshAqfGpJ4rg3/io3iCt4M2voq0+TqvMs1dp9csw9T47PQBnwqzhzIBbcBA
         Vj3SbsREU8i15Xi4TsKrtSTeh5wVWaizR9PCD74c43JUdd0KJtXSudZKGJul3XHnAv29
         HwbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoZgSQyk4NOptKU40emY0tlP6FUoqWaaoLM2WpL+BeWYjzOud6dqUWPmuXTrTYkQqlbWseV2kXKQ==@kvack.org
X-Gm-Message-State: AOJu0YxQKtk7teIPxtaCaOcEq+Tw/l8kiWoMOHUHTEL86U2EPxClyOy6
	qnqezKYvPrMZPfq0v3RzJbR1sSLrhEDLEX8aG+bSjFChrh3IrvTFXQkZeJ3lAlrwEfo=
X-Gm-Gg: AY/fxX5m82wMNGjEVfUEy+ZXU31Nc9WE3BxvhY68+ZMhk8+GsTMpOvPoI61Ov8e7Y5V
	5I7Q+IOfD7ksczr3oRQcwZ2KBaKusRqXZ2SSYgFN9Mb1KbvsoYeU8vi8xsanoaMzpL04662KRvV
	hGo8K/cdJGE14qH7CRCArtI92RhanVynV/urJDUrVy6uC+Hr3eOHTZyY3MalDwdSQ1C3SXQHKBH
	KCf4oPmxpCRqXPNIi6U/px8hX97zG+pqm5i5LFDcaUmhjXqjlk97zQSfD7T3GWIhlASbmvCyin7
	uppep7Zf5/Jp6By7nUW3PcelweXPr+l/oRTYAcMbEW0bbQ36KjE2wRGqGUQQPIioc9Kzo1HsgkW
	ggCDQk7jy5ytmf0jkUxEWDhAADiAg8LbbgfavIxJqW9bmC4wkYFvJ65LXkIN3HuQ5yj4fXzCbfY
	eUaIARzxPvqljadbaoFmv4eAJPl/yM35fwb9dcIuWzbQ==
X-Google-Smtp-Source: AGHT+IEN/UHYtedJC5gNScUIjciAIBz4WtImq8j9JAVWa7kOqzOpjNxabiVdwQI/0HAatQaCg3ghcQ==
X-Received: by 2002:a05:600c:1d0b:b0:479:2a0b:180d with SMTP id 5b1f17b1804b1-47d1954a5f7mr386619925e9.11.1767088168725;
        Tue, 30 Dec 2025 01:49:28 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be26a81b6sm657711035e9.0.2025.12.30.01.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 01:49:28 -0800 (PST)
Date: Tue, 30 Dec 2025 10:49:25 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Jeff Xu <jeffxu@chromium.org>, Jan Hendrik Farr <kernel@jfarr.cc>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brian Gerst <brgerst@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, davem@davemloft.net, 
	Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH v2 0/3] Memory Controller eBPF support
Message-ID: <enlefo5mmoha2htsrvv76tdmj6yum4jan6hgym76adtpxuhvrp@aug6qh3ocde5>
References: <cover.1767012332.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nav7xplzwe6tizdp"
Content-Disposition: inline
In-Reply-To: <cover.1767012332.git.zhuhui@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 84406C0007
X-Rspamd-Server: rspam10
X-Stat-Signature: frihemgsx61nhun4rcxkbyb3i7durzmp
X-HE-Tag: 1767088170-884942
X-HE-Meta: U2FsdGVkX18p9llM/KW8aUvOJf01ILA722UwbLDt1kCTM3EVg1DDngFa/i8upcrJ4IIpltFP2I/i9agSD5HiQG5RRL120542F8gbdF7VbIgOWtGCRipqov95hUW69ZxDofKA4GRDGPyJ4JW8W2+1uw8XraIOTYl/ZlmcW6HwCJs28LPY5jRpO6gtDhI6ZU3z6sVTf+a3JKh9D+BkbSsKMEzmEVdGozQReRKNZmIUpIJjZLjaO8jADb7ZvSXuCfclTqKx/3GIINXmN8+JuWXr/d7Yqm6ZiNsIiaQ9nJWvFZE1CxmrrrdSYP74VJBS9qet+LXNCDq6Ei4Ee8dmbmmuBnjkpLF+ef6PTA/WvYwuWKjAWenkBEtUwkQmTqzha31xx7H0b0O8fT5qRk7m1Q+2o/eHWMy4DGKTBvQq4SH2iBD3TYI7JoVPbKmGTOBJ1ylFoToL5gFmJr4GLJluXpnuVD7IGRAKanaHCI0YjoHgMSlRQ+w3HmS9wPAToDAUJwizqZKEbJnGkKSDe8g0htabGYRCu0DfhN9U170UiCfpX4/8uI1YttGJ4iGqWeQ6t2ZSQ+UJURJTeNDKbWMP0VTZLucXbS+a5xIVzgqliDxFzLiPKYaWrXslycNa5K+qZ2FblcQiNXmRcixu13QYVG8f1nRgjxm+AFMx3QQmZOL18h3Aq7JqpbhLI50y2lWTgED0mvhPHWa4/97GK4T3if0BwszfWfZjAdOZv5WQByJmsYp9IboCZiFICca99Y+wh9Wwkm7KFD/fpQQImxUc+MP1lyNNkVWAImcHje2TxEiKNAe5eD1fQfmOnRisOIpW2dfIVCaoEoZ7h1bHZwy+KnXYNZ/jgGsHKrfCjCxo4cqSw0Ydj6oDmnJR6SgLdbS0SlDDCX40xpZnyIkr49X06wVN9/650zsgsckNPkgmJbKgsx0grRiRVOuYfX00CNd1PWOVOWC1Biakew1VGUGWkcO
 qLgUf+qs
 qnbvcM4RAvE2BO4GBphBN8PdsBMN+8INUJOCAJWI0U8dIMT2IAxQBJXcpMWags+blbIPoDbFzkAmICHYwBX33c4VCb7LiqlqGuoJPG26zs7Xotmchgvg5HrngbmpwJQMEGWI7sH91qWTXehDD/HYv6Tsx33MA38Dj3wpz/QDAjTHB/t3R7Nt/FZlTpl1iSsjmGlBQxxjkH4vw1d4mHe4S0Jep/FIpCRVmq5w+3eh+gT0aa05+fqxVK0tmAruyPLyuR5L526Llq9S3sYQMSfcDqADKhDO6ymlp/6gXotYJ/r56FHkXOa2OBtwcHGSj9UtQQXdqH3QglX55WBPxK//VBFBIYHpWrYwuzx9MrCSY8qGZIeyrlgpF11azoaaaA16BzpUoRgRS7kdvZJwjqQW3YnuMmAkF9A8WLbt0CIt+L+qFA5trMvPPfcaZoFHA7PdRPrKZCGuBDvTJ+UBAX72yEChBUlCU0ZsiENBq9n0k+J0w0YDP9bJIhTZat29suWVjIUVd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nav7xplzwe6tizdp
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v2 0/3] Memory Controller eBPF support
MIME-Version: 1.0

Hi Hui.

On Tue, Dec 30, 2025 at 11:01:58AM +0800, Hui Zhu <hui.zhu@linux.dev> wrote:
> This allows administrators to suppress low-priority cgroups' memory
> usage based on custom policies implemented in BPF programs.

BTW memory.low was conceived as a work-conserving mechanism for
prioritization of different workloads. Have you tried that? No need to
go directly to (high) limits. (<- Main question, below are some
secondary implementation questions/remarks.)

=2E..
> This series introduces a BPF hook that allows reporting
> additional "pages over high" for specific cgroups, effectively
> increasing memory pressure and throttling for lower-priority
> workloads when higher-priority cgroups need resources.

Have you considered hooking into calculate_high_delay() instead? (That
function has undergone some evolution so it'd seem like the candidate
for BPFication.)

=2E..
> 3. Cgroup hierarchy management (inheritance during online/offline)

I see you're copying the program upon memcg creation.
Configuration copies aren't such a good way to properly handle
hierarchical behavior.
I wonder if this could follow the more generic pattern of how BPF progs
are evaluated in hierarchies, see BPF_F_ALLOW_OVERRIDE and
BPF_F_ALLOW_MULTI.


> Example Results
=2E..
> Results show the low-priority cgroup (/sys/fs/cgroup/low) was
> significantly throttled:
> - High-priority cgroup: 21,033,377 bogo ops at 347,825 ops/s
> - Low-priority cgroup: 11,568 bogo ops at 177 ops/s
>=20
> The stress-ng process in the low-priority cgroup experienced a
> ~99.9% slowdown in memory operations compared to the
> high-priority cgroup, demonstrating effective priority
> enforcement through BPF-controlled memory pressure.

As a demonstrator, it'd be good to compare this with a baseline without
any extra progs, e.g. show that high-prio performed better and low-prio
wasn't throttled for nothing.

Thanks,
Michal

--nav7xplzwe6tizdp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaVOgEhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AjqkwEAsnaDJnUrbpBZvRNgWKP5
6Sa4JrRHis7FmRcVhJPNvUUA/1AnWVzTnXOrXQlAm2C1hsfhl2QuvaTzWc6hD0j/
y5wD
=OLWl
-----END PGP SIGNATURE-----

--nav7xplzwe6tizdp--

