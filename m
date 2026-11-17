Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD1A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e0u9DNVA
Received: by kanga.kvack.org (Postfix)
	id BBE446B05B6; Tue, 17 Nov 2026 05:04:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95F36B05B7; Tue, 17 Nov 2026 05:04:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC406B05BF; Tue, 17 Nov 2026 05:04:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AEFE6B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:04:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FB62803D2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:04:47 +0000 (UTC)
X-FDA: 85444177014.02.96A3124
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3957880004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:04:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e0u9DNVA;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909885;
	b=DuGCVXihoFCg6fxSv0yUESg1v/5YZHpTUWsJ2k8q7K4rWxIDafH6wB3ilddJr1nU1AvgDm
	Kokrfk0UwWQC7hvBKscH7Yv33ucJ7SQI9f+TcGakRFzgWBi666SZjMzmRdwXtmE+qZiHLp
	AEoTRJtufQ8ugCkjv4bmVqV/bLNTA/A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e0u9DNVA;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/Tj+yOQGHlgMdHJ2zoX2kGKpzAY6RpKaNTOi5Zt6rM=;
	b=DK8ldylW2XEdibmMHSGzy0Cv8TykkoZNpm+PHSeDTX93s4m79okvn2L5/xMveT5gTROE8v
	+SqmLzUF2iNASUxKpgsP8DUDL0VB+be9WPI4VVfX9B6jBQWbE6eTYEOA07ymrYGwZxodyc
	+uJxnAEPHa4HPgP2LLjb/Mq5XDlAXro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B7E545B9E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308B31F00925
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909884;
	bh=w/Tj+yOQGHlgMdHJ2zoX2kGKpzAY6RpKaNTOi5Zt6rM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e0u9DNVAMICPOaGQ00G5l3VUdjwKqXhcWqtNE3HYcRy93xGW+rb+l657J4dC32smz
	 OvNil7dtuxVr3u6ZfbIlqxbJuBbWN9bTgPKO7MToNhd2nAs1MhQMYrrh2iISEnuaHJ
	 0ds/wTxNtInls6vIiGQ8tGSrAwRxuBOpEFiX/d7uR5ZrDPI9QrhIGP7C1NdOLCgMXM
	 SbXdatAJwX3Iw2DwYlr+1JjrtXzzZC7LAsT0nAx4pxrqjNMfSh0+BwzeMElA37YBS8
	 Kacx9430eex1JdHXbGX2NJiTjN5mj/c6muFuyo/be8UbkTaXpvZlu2q7QcRf3jIydk
	 iJfFcHNSpdKvQ==
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5eae1276409so1630952e0c.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:04:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG+dIDz4+FSsza+HShx12TVQyq3NTXhsbK5eIaswVz0hZ0BejPN0ETUCBjZqmiuKjLuTUK2Vj2MdA==@kvack.org
X-Gm-Message-State: APuU4Z/Opjpk1NbF9CzHZgK9GaKXQ97s8fp1WJ6SGPR2crw20TOCiC0i
	G6GHvcVIuAomuGUwSBIvVQraQkDFpec4zSwDY/XvUbi8f6XiQMPDjK81EzR3oxcWJD4q9t/75pl
	5PJ+W8VlMdoEasHlwXLH4GSnG51I2k7o=
X-Received: by 2002:a05:6122:2891:b0:5ea:c11b:432c with SMTP id
 71dfb90a1353d-5ee34a7d16bmr4305139e0c.15.1794909883279; Tue, 17 Nov 2026
 02:04:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com> <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 18:04:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w-KED0S8kzVy_4B93DTKVpOgAoP40CRtiyv348_tiKvw@mail.gmail.com>
X-Gm-Features: Aa3M54pZMronU9ebrmctqqD2wcMMdI4pxY04GKVdkValZaPDGgB_Qb3xjyXwYPI
Message-ID: <CAGsJ_4w-KED0S8kzVy_4B93DTKVpOgAoP40CRtiyv348_tiKvw@mail.gmail.com>
Subject: Re: [PATCH mm-new v2 4/5] mm/zsmalloc: remove unused zpdesc_lock()
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ymo9pzmfnubew34zat9jyu9pmy3kqamq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3957880004
X-HE-Tag: 1794909885-115310
X-HE-Meta: U2FsdGVkX1+V4pJgldD1229/mTXu2RsTU4XdI6vq0Xy+gVsQLKK5Ha7XGRNxYarRHIHX0CRj/1Gg83o7DhFmcKlQNFZbownkAw18p0rTYDbhK07Jgy9vmZwK7BAgq/8/Jj9b54ZGhhO9o1lHDGJnqx1lt1CC9gh194zj++9SWhabWO5wItlwTYn/nu7rCQhyf8QoRnDMY0DA09NgBcRCgCOKMJKPKUo1Y79Xe66MGLFDFx0uda+T6MRre267/FdFNnrBZmQn2iqBeGjd0aCi/JCAFIU9iZb7RCsz1p+1xNNCI3I7owh/0qtkoK+hLC1ngPOcFgdRk1XWrkfPfym/f0k8yViYCc6QHufelAXkUxzAS5XSm9G64f0QYhhARit/k6f7kjj4vvGW4AQhKSuINcrXSi1KmPkC1lqhAh+uWKDzXc08n30ITkk4zsCj6/xK/Ik9V29VvcnMtp5WEGNux6+9HIMAxCd83HnQ8YMJt+QZFq90q8TqwWRV2NMGvHCD3jxrojbtydqyct9/K3tNSnwsleOvelOmSBeBk+urHA1XYTaWMwexjAvpVyXleY7RvQi+n4he0+s3wvYf1enzNXFKmvLFIcPveGxyzlAb/JUtzXPIXWutC1J85sFjqCh3dIVRlnsZdJglLE/wUfDcTuCPIRY1X6BCh1tUboiv42XNhYmTE0T4GLHLHK3D6rdjwdKopkZq4ZVm5dNaRrjzLiw3dxaCMTQzrtxXL7KpELfU5H8dt0VfZ/kHXaaReyxmvWQ0mWEUij9o4NQ9Rr99KvavqI2KcpGoCM2gntJAIKGCTrJ4TX3BvzgZnkBWKzRyB8draafa8EMbI4eXfXffjCCIAnyv4PYnivUA+Grq9xIiVxHAWNOHrbOjt1XFzcTBe7l4Ze3jq2XDyZrj87G9hz/UKJqlyYf4+MA1Cqv0+gZmz6NuZIIhQG+mJAY42bOhjNXhG/g2fMFa41rf68R
 gAJM+XUh
 SyrqCPRkSRIB6V+9vlrMgkO9ysmm4T9NR6nt1iEhDr7uUgqM8lWSX3QKpMLH1rzjfVKvsGH6znUPKGq3JMKfP+v7j71kLyRo4m1IXeWO5o/o5fKP0e3CwG/Ygs9bcjA5DkAnKss7gW74MeeWvnj1UxM5pEKaUsIctfqJ/gNUhg7P3/JbGsoWizPwCymkBYE6SJS5MwG6v0uy5PdbzdBq6O5whl7c9l6sqev4ICBDFmI9ZC0+jDYaNiPWxCYpVmAnj4izRmQjCceokfGoFchG0vqtM/tXiJlY7+QLBBq3J4piS/45QD3pdv5upGgW6FSRbB3xVTCSa03AP42pKFcOgGvFNA8Zxn0Iq+suUhlmiSoUYX9D0aAzhX5XOPBIddhJvgjvO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 3:17=E2=80=AFPM Shivank Garg <shivankg@amd.com> wro=
te:
>
> It was added in commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in
> trylock_zspage()/lock_zspage()") but has never had a caller.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/zpdesc.h | 5 -----
>  1 file changed, 5 deletions(-)

Reviewed-by: Barry Song <baohua@kernel.org>

