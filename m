Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73198606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BwlS+ODd
Received: by kanga.kvack.org (Postfix)
	id 8600C6B05B3; Mon,  2 Nov 2026 17:56:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811AD6B05B4; Mon,  2 Nov 2026 17:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701F26B05CF; Mon,  2 Nov 2026 17:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 457196B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:56:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C51871202C1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:56:22 +0000 (UTC)
X-FDA: 85391689404.14.0D60AB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC4D6140006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:56:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BwlS+ODd;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660180;
	b=dmeThnCCTbKJrxuzhFpPayo82yOjYPxsmtBbF9fkUX5Bvko550Tv+ijrk5SWJLcoY0ANOU
	UZ0YO4Be0vpXHr+qPfsZfO/8Kh2VLv26fXGPYYrhXmKXIpuAiMyIp+T6CiPTkLg8Z1x7jK
	wHMUF35F6qPU+vWwCRf+rKzwd7ivLDk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BwlS+ODd;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFYQ0d2h0844nhQw4x0ZMieOCXHXgxHX+w5eXcpQbAM=;
	b=sSonJBGlyrS1kiI5lYKYzSY9v9arqSBHxPaPHI6s5WM6AStg9EVc1+VMZy3T6KM9KKz2ct
	omi0vjje+rQA5a4vkmZG59uA7/uIhH8MUXh/alla4i2w0W8rJABdNDHfoAbhAMXvE1Skv7
	p1UWv/uwRa7UZjpeZnFDBp4z5cze+us=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 741DE6022E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4791F00A1B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793660180;
	bh=cFYQ0d2h0844nhQw4x0ZMieOCXHXgxHX+w5eXcpQbAM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BwlS+ODdUdt0siIbyOLdnHsFImrxeLmqStw9m/xBBplYc9zMvwzEbcN/gAQUkTsWu
	 SmuQLkKbhgoe0nVXDEE7k8qzUUXhaSTUIkYRliC34SFtT7UMCHlqwt+p4BWUIqebsl
	 vQV4TPC4H2hBww1lm8aWqF4y328VCJnUBu1ZlvrwPZTZDxJOYzejW2ZaOELjFdXFSB
	 X+jVTemvcF8j0tJajy/CK+MZ3zC89zWIH8igB3jShGDM25mYp/iDL1gcac/NovwW3O
	 VANVCLdDy8AddHhabBrjNTT2ngCKjbLs/4fgjEsnVdQzMdJKl5hMkUR3WMkrRVVkI2
	 VkmMi0STm7RwQ==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91befbcad6dso62573566d6.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:56:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxzVToGqwkm6s3h2kcfHpfrkz6IZ+Wcv3HPcDAMTE07v7tWUBTRVh9air/6DKkeGYjXH0P+PxiODQ==@kvack.org
X-Gm-Message-State: AFq9FYIS4k68PR0/DBsqAN/2Ak4pCS5YD6iaBRRtSX4W4/Cl7p4xq39N
	9rEDdiJtHxNmNmLTjY1/ls7H+35mQtCwACKxnbSXEbI0PJ0qQLqENEWdz0U/btj03T/EGIfcNHA
	BYUJrJLX/uy+Z6FRxVXKdTG/VtOwt2PA=
X-Received: by 2002:a05:620a:2556:b0:93a:2150:ec06 with SMTP id
 af79cd13be357-944217430a2mr1904131085a.31.1793660179584; Mon, 02 Nov 2026
 14:56:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026202313.63122-1-sidchintamaneni@gmail.com> <20261026202313.63122-3-sidchintamaneni@gmail.com>
In-Reply-To: <20261026202313.63122-3-sidchintamaneni@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 06:56:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zGmtvOApjFH_-V9z_zNWWQnrBX9q0_iWtbqzENCetfgw@mail.gmail.com>
X-Gm-Features: AclHuK9iKml0mqB9U10W06jkrcvQ3DU6aATh74iQjCSlMOo7Q2XN81V-z79dfX4
Message-ID: <CAGsJ_4zGmtvOApjFH_-V9z_zNWWQnrBX9q0_iWtbqzENCetfgw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: remove get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ofwqhkmrsupzp3ncndcdw1qyj9whyu1i
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC4D6140006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793660180-232525
X-HE-Meta: U2FsdGVkX18IRgeeCvyRFXQ/cKDA773xFx64HZzbzmsfmCBX9LsEq8F1uFwMAiKZrpYegoMKVVX4542N1P8POE/tgh1crXl42QVSro83WJM34TZZXJtaAq4qioyMOJHSDxehXnQBeVcJvpAU0CX5MSAeHmYZgTtQB3aE8KHAadS0fidcoORmJ8m3y9g3sbi2j83i25KsAKRbvAYYgzRN/n/Fiui2yfjEgx1KBeceCrf3j9hnOUaVOsSt6JFtvnIp7+KRnGIvn2uhXStD4b+anizpprcxE/ZEH3pSjCPxs0XWdfRi3ebIjg5Exh2JOwL+GLC+1XmODTLI6pBoM4sjiNz/mLC6CO9+GWo9AK1ob6gqQFmK0rM3sok9/skQjkUWaNEjd9HB5CubLUNdoso9rWo3JvdESRr4VIlSvxBKjSgIE0YPI9JMFuv3U1S7F8e/TwO2T5LkkJPAZvpDWRVRH5Iz4uiwcUhZYaklk1UyFiuwpxDE60w19wI7bxypvskcd515Um8WqhOKMhhLb+ye+FjBuWhhTAdo3sMPeMgqSjQAaVwTOD5Xs3LglpeWU8OPHdmo62bOfWIkCcbyJCE5uYtR5/i9uHBAg1ennhRmpGbW8tnjXRQRkuu2QoQ5a6YOrsfmUV3WOAw26M1gjtILs/GgseC9fUlpaPy+KLqnQzpqrO+X3Q374AS93c4Q358dBVetCwa/FzZNa8w+D72qc9ni9PSB2hylyrHPqbwtjh2TaAqse7hBBCttUhRCE2qACI/w16i5EEinzO+xeCDwOa/mN1Z0ZkmrThkQxAa1uCCq3EG2oMpOMJ8L7krUylCRgKjEaLt4vlU8SNb23XjZEUHqDDAnNxSKA/lsy7x9P4p1IucZvLgWBWMOWKSnZSTSsn26PwrXZk8OBfnlT9bXneoictjYmsguX287Sx8phwAyiy+X5eYVRi3CGWtIWS8km0EvedjQTNervTJfV/h
 S4oCGiWI
 2QFT0cwZPpJzAE+QX/aD9pewrsG+OBXvSPUDalmVPsNBkKh6cvgaCOm6e/8xQbdvMxm2CzCipSyaWBDQSQbFwyTMRSi0VSnwKMZEPWcz5A4GYzf2C1lKk7l7nBy03myIl2YFISymelvg5tiG8BMSWyqiNaBCY/5BoW48TSY1yvi//WxJUv6hBbbjK47WVf0jrAxVWsT210xVX3DMSFI0YEZZNXTHPAE8gz6i/tC8SL9NSsaEv/pvP3wvIMp9E0FCJ/HaL1+WIA4rKZIJbRSaos0YTxHqbIz3zb0adyvRiTo0JRgMWJz0EVGr6bjFuC4ZCNjuelVUvxMhdOO2K8wzDs19yiKVPtEvbdbYOAiaKv5YIwF1jMDhSqomGIh/HPRVd+IgUVP3Efso0mavdrh+/jTtFkhZVwVJOi1Z8UDnIXdABA5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 4:23=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
> get_lruvec() was originally introduced in commit ec1c86b25f4b ("mm:
> multi-gen LRU: groundwork") to guard against NULL NODE_DATA(nid) on
> uninitialized NUMA nodes (`return pgdat ? &pgdat->__lruvec : NULL;`).
> After commit 09f49dca570a ("mm: handle uninitialized numa nodes
> gracefully") and commit 931b6a8b36a2 ("mm: multi-gen LRU: remove NULL
> checks on NODE_DATA()"), that NULL check was removed, leaving
> get_lruvec() as a thin wrapper around mem_cgroup_lruvec().
>
> Remove get_lruvec() and call mem_cgroup_lruvec() directly at all call
> sites.
>
> Suggested-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> ---

It's great to see the MGLRU-specific get_lruvec() gone. Thanks!
Hopefully, we can get rid of more MGLRU-specific code,
such as get_swappiness().

Reviewed-by: Barry Song <baohua@kernel.org>

