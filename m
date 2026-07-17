Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A7FC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32986B00A3; Fri, 17 Jul 2026 12:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A6B6B00A6; Fri, 17 Jul 2026 12:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D219C6B00AC; Fri, 17 Jul 2026 12:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 966FD6B00A3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:46:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23D52A02F0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:46:52 +0000 (UTC)
X-FDA: 84998847864.17.E3E565D
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 38F5F40007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:46:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEJmwY6I;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784306810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLbT0SFfuckzKAwHr8EBVzewNYG2dGRNTk3VlAGhSo8=;
	b=v/JTvqJe2WYpIH/d01rSa2YZZHgoKf4kWi0dmoRpF9EIze7vqGCpOTuIobz9wm4VeAMfN4
	d983w2+BHE4iTqeDjrTK2wgOKcBvceVQIm0DmsghXIvqFLOO9FXSp82KWxw/rcTySwMEjX
	pk+taGFpDWG/PoIpXc6lVLbJg4A88zk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEJmwY6I;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784306810;
	b=sq7qLDaioNZGPiW/S9n0PsfKPOclZpj0LvwvttpPxFSNY3mEbz9vpKZbCsZrGaSbayTmHj
	krMxEVvUaFMZH3XAxty97gbzOxf3n2DpPBpe/mVWlrJ/ZjxIPLjQs+ACyhVizha/FcBmap
	ESrUJ4WWSMNpkcyRtGCxuNvOJUdiT+4=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f6609c657so230018f8f.2
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 09:46:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784306809; cv=none;
        d=google.com; s=arc-20260327;
        b=q77DYUiMAID4QV4kLbiKor4BeHfuJSMIMwYKGYcO61Zh+39u02B5V+Gkvb0z7xIiYA
         dtvm3cxcs0BeC57STvUERyJ2qODzqv2VPaSU7kRCKXQdH3i5et2PdxU3sCT2Bel920Up
         nP13j46nAOqnIiB4CJuY9W/+DhXkzZA0yNicOC4rSezHTGOsfR8rXS3F3+jeWDZvYzm0
         mRutE+jgH1KOwv08hXzvGuCMn3Qtf7/hDjr8naE6pQm5AtlswY+d8k8TaluYZI8XlzGX
         uk903MybBH4ohTqDKS6uwPhHN/rf82crB6accjARYUDPtpXdKY4XZwNtK27qSjgEiuaY
         GNLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hLbT0SFfuckzKAwHr8EBVzewNYG2dGRNTk3VlAGhSo8=;
        fh=tTrYJeeN3osQmQtsydr/2WfW5xNDXWSoyuC74D+Kx/w=;
        b=lV20OY8C/0r7jsDDlfZsNQCEk/dPM9nsvGnGPepyfvaDb75vNzPV7Me0oUE5XH86tD
         KOQbI8GRD5qAsfNh+QCChwEX5Vxehhb1Kog2vbzrcvldbKNtljlm+0IJOHLdF83ptgeq
         rNUCXyH9fZsWhDIwpyWqUI7PLynCGm6YAMTW3Q9JdWy6cvYNC97hp80OxAMKLGrzZa6Q
         RUq/q1Hb6rDdSOfaXLXQJ4STFph4dUyEFEAWnnWM+6ZpmtNfgDhlFuz5Ft/CARJhtYre
         jAZQVWy1Dt+xHycrQDaQP8qLRX5DobVKdBP+fkhxhSd6lit/mGD3brnW4w4OMrGER14b
         jDMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784306809; x=1784911609; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hLbT0SFfuckzKAwHr8EBVzewNYG2dGRNTk3VlAGhSo8=;
        b=EEJmwY6I4JRWT964QOIdL7kuTZukfqzo8SbKbe40YHVowsWEGNlHQlQrjxIjFfsJS9
         PtRD5pWgsGOh323X6nNLzroIEOq3htOIHAhL+q50p0f+Y0n5K+LvamEkPfIditn2NEP9
         i5SrT2h8R/BazhezJlRMeS7Ou/IssGR9Yx6/8AenwFS9p3ZpkZOpf6s7gjyK3eQ15HKl
         z6xvYqXK4HBuIc1/8gRHU1Vsdj96kmOO0o/DHZNw/ICYLuMlOtszCT2htErNtRp7nCDk
         4sU0UoChjg6N7PxDbbc2H0Ucpwkj16mAg/5W5TOUolYRg4Bnwu3yU6Qjk+Q6skb+uHD7
         ZAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784306809; x=1784911609;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hLbT0SFfuckzKAwHr8EBVzewNYG2dGRNTk3VlAGhSo8=;
        b=WmrA8PlzNyFLcZn3+3a4Vegw8YgIgTtj5UtlK+aDQKxdBcJnOMuaG1lk1b/VxsMgE3
         eQzcSRKNCSs1a5O9TGyGaSMPoSpxdFqAhHiPaJIaHLfxqb8QzK5nOivbNUpUcuNKb3Ix
         SWPIxrbYX4pwIjtar+tjCU/XjdDHrMP6YXmq+6NzfkiPGI508Qw3deGNOl/9QjgBDC7k
         uBA04/xQ5bFu8LpAKBQjwW+yt7LvBHVCZmW+3jaXO/jd4eUNNxKEzlRxNwJzfBFs5XrV
         4dMssDX7PDTIXZndzIonw3f9a/PEhDHKt6yaA7YheP4fvuuUhY6Hb1ONslJc6RU6yeWH
         N6uQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq2OMtDBZAOqc9g8IuwhUMGL9xUKYoPIUXqY+Pug8oPKYG6fPI/plBzq4pDci2/UtodnmQiesxfKQ==@kvack.org
X-Gm-Message-State: AOJu0YwHee46U9sBEBLRsAibmthGA5m4mdp8adKzcXtzIQgMNCWb2lBF
	doNkpOefak97hTZCGJSOWEA3pefClUm+7XBO9GlZWSBS3n1ptkxCpC7J7a/EsdEL3E1DJVPZoqR
	sicTQTg9WMxi+kCLcx+E3YlyF7GqNfwI=
X-Gm-Gg: AfdE7cnpkSEewOQCHTkXjeerjY8QTXswO/RjmKfXbixAj9l/T7A8R65bIWL+WpU50SS
	SmiAHUR4X4h9NpWF70VTWw+vPZbmCu3gXMyTHaTpAt4lLOnA2mwyQTgbGfc2csNbUeUG7AoO84w
	wFfmeAuM+GrFkTy+UELNZs2csXOZ4L7JynzBMOg8spP15sb0qi1zF7JSbWIrrNbiXkFxz0shTN+
	AYmithO/iUmfYjgtVpn+C3k9aeczKEJRfNoOPW9YB2aZ9cntnqkt6j8/0FMLlM08L6VIuqvxeHO
	ImxK/zALp4VIqxoF7RurOzcIpDBRXK4dhQ==
X-Received: by 2002:a05:6000:2084:b0:475:f0f0:9ec9 with SMTP id
 ffacd0b85a97d-47f6233b524mr4775540f8f.52.1784306808570; Fri, 17 Jul 2026
 09:46:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com> <20260717085151.22822-3-jiahao.kernel@gmail.com>
In-Reply-To: <20260717085151.22822-3-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 17 Jul 2026 09:46:36 -0700
X-Gm-Features: AUfX_mwqJ6k9K8CILsmY533tK_ILpfzrDWmeuk_O0N-L0gFYxxQq9ITENfNpP6k
Message-ID: <CAKEwX=NEevkKu9f1Bji2j9pGSHJkEPugQ8fp7gmUz5p8KpSOMw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38F5F40007
X-Stat-Signature: uaetonpbo1rhhyqbdkhk1mu86jan7e9g
X-HE-Tag: 1784306810-726006
X-HE-Meta: U2FsdGVkX1/uOxSbiCRSeZmgjBymm7gC5nLN9+ghTe7+3WixpFMuvGTqdXbGJBOryzPA8uJZOcpd1uSEY+SHlQIKaGsl7k0te7QM0ZX7rl2fRdwiZmCfAJAlekTkhAPPyyp0a2oh2ySbvc5qxu+DCAL3Cnd5ttFdaKeN+43av8d0bGURFBVjomvLHwHuj90uwAwWPZ4EiEXwbYwNPTdcTvvmBI8XOdM2jVNR1tifhVf6/hIIfMRsR2fimseUxYgqvOjMIMefPjMKwnPpAb8iiVfr8lGH8AdKtvVt4EUnjPIvBSow81M6ACTmltKsTqLrmstAOywZk6VwxIkSQBFjeMnHa3duCHqdVyj2TtgOEJUfUF/5LgPKa+9roqbtZjdOQp8fGGb0V47xgk2wxiyj+EHZTZG3QsCeh1GKpZvnYN9xZBWlsuOwQOMy8I6kmygP8QtJzoZBSKmHPCZKoyL7hAxvbxyeIUlsxSX2PymY9kAVDGzH3ihNVg2s7L7zzig4AwQO3/W3U0AhvUddoyTdyd/NF2js++LT/58qGjx/7Zkrp+skQqiMvyqouBBE6w5hOicRqpU9lJHwK5FxAHYK4qPITpzbSEZrk6/jVnGMD8GVmH+thqOi3UHsvNGdIoB5diHuBg7oM/HefdUoOp+pA+wqR+UcXAkFzObCjcn8Dl1+WJFcWudL5m/wTHjB/t2TZp0iHMhANDjGpHTr27C94JCKk40ZEiB8CuZEoertTNPx7ZZXR2tB96Y0uEWueW9ALb+TnuygEk5uACNiDLyz1hWYnGbkyyfQxH1VD4kugnt01DSuwnELTG+nwGw8p5DUZI6YfEk3pc46OVKFf+CnSlL5qYyZlfDc+z1kqZVvf/TNFBjiz0EEKV69i7Y/GEumpCpYRPnYtwNr3JoRrx8n0vbI/Oh/gmqTjkrr8LMED3Qm1vmRwo+2o0c7HJBzSSN6RoFFPpEfRsLkxYchQqz
 LTckv2IO
 qg5/HAfBYHVi3XywJagyl+Yzy+FayYNsz2CAXazEaaqw+XeLys4QBgasH+gm6OpNyKsEXbQ9yeypK4MRYIR5A3JJhiHDdO1TEGcILXiPbev8py3FmNgjC4/CXUREBjJ5OAGqBQs2kzfgVWkjp+B7IXH8dlRu5YtJ4jpPAMrVNff31A7rn8G4LvUinhxyoOq+aX0gahVQ8TrB7Wou4gTQW3Oy4+/kolJMRyb8csIKQyANXU2c3KElnFEGUygXmRh2TtpZrSAYIEpH0L5EY/Y/8MM7Scy5kDMCaUtjsPGdHiCZNqrO5DLT0syrla9Kqf/X30GnxFL96TCjTaOU0jhXI74pmvg0Sq8H9xrEuKwjdR5Vg72uDect50BsRhVtz31NOCbzmsPJVhW+zSI25wuReWgLpUTYl9jW0dyG7gaIMdY1/SZkOODq4JSBqD9BleqH0jMQv7gowQJ7hc7cdAgULoC0eFVFHEVPHRl0Jv1WCaU2wFpWhsOaStDF5uKfVBng170evpr8UPjWB9LDu/uQ7wTtK5IspSpPv90cTzO/YNx/3qRVRrc7Jeo7izHuZI25fbw65PY6mnNNmE4kEc0fCoj9i7haz7W69Imxk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 1:52=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> Currently, shrink_memcg() writes back at most one entry per-node during
> its traversal. This makes shrink_worker() inefficient, as it must
> repeatedly re-enter shrink_memcg() to make any substantial progress.
> Under high memory pressure, this can cause the writeback speed to be
> too slow to keep up with refaults, leading to zswap store failures and
> forcing pages to skip zswap and go directly to disk, which results in
> an LRU inversion.
>
> To address this, extend shrink_memcg() and rewrite its LRU iteration logi=
c
> to support batch writeback. Introduce the nr_to_scan parameter to bound h=
ow
> many pages are scanned per call. This enables batch writeback in the
> shrink_worker() path, while maintaining a low scan budget in the
> zswap_store() path.
>
> Test Setup:
> - Total memory: 32 GB.
> - zswap settings: max_pool_percent=3D1, accept_threshold_percent=3D50,
>   shrinker_enabled=3DN.
>
> Test Case 1:
> Allocate 512MB of anonymous pages and fill them with random data (to avoi=
d
> compression), then use cgroup memory.reclaim to force a large amount of
> anonymous pages into zswap. At an interval of 2ms, allocate a 4K anonymou=
s
> page where the first 4 bytes are random numbers and the rest are zeros, a=
nd
> then trigger a reclamation of this 4K anonymous page through cgroup
> memory.reclaim. When the pool threshold is reached, shrink_memcg() will
> be triggered.
> The test data after running for 120s is as follows:
>                                 Baseline       Patched
> shrink_worker wakeups              5,363            85
> shrink_memcg calls            11,373,201       180,928
> written_back pages                40,212        40,236
> zswap_store calls                161,190       168,741
>    store succeeded (ret=3D1)       102,743       127,644
>    store rejected (ret=3D0)         58,447        41,097
>    store reject rate                ~36%          ~24%
> pool_limit_hit delta              55,826        14,062
> pswpout                           98,659        81,333
> pswpin                                 2             1
>
> Test Case 2:
> To consistently force zswap store failures and trigger shrink_worker(),
> the following stress-ng command was run for 120 seconds within a cgroup
> limited to a memory.max of 1G:
>    bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>    exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t =
\
> 120s -q'
> The test data after running for 120s is as follows:
>                                 Baseline       Patched
> shrink_worker wakeups              5,640           987
> shrink_memcg calls             8,481,500     2,504,818
> written_back pages                   260       768,576
> zswap_store calls              2,742,756     2,301,414
>    store succeeded (ret=3D1)       934,640     1,308,686
>    store rejected (ret=3D0)      1,808,116       992,728
>    store reject rate                ~66%          ~43%
> pool_limit_hit delta           1,181,310       101,593
> pswpout                        1,808,376     1,761,304
> pswpin                         4,288,497     3,902,658
>

Acked-by: Nhat Pham <nphamcs@gmail.com>

