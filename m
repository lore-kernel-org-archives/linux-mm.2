Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A340ACA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 06:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8758E0007; Tue,  2 Sep 2025 02:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A678E0001; Tue,  2 Sep 2025 02:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8A78E0007; Tue,  2 Sep 2025 02:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEC428E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:02:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97E8F857C9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:02:25 +0000 (UTC)
X-FDA: 83843265450.09.44C187B
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 026C3C0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:02:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BaZzNdZD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756792944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEAeyE+0TMUw/irMNV6HSXBtMni9AHV5BLdYl0T/KUM=;
	b=Jfhyw52Y348u/PvtFVp8g3WN/n7rIc0eNjpvrjmul4MSJFnz7pK9/wsrL92XYmqZnABFB+
	6NVLkxtl8o6r4wXI/O9SuKEirqcvx9cspVIxRek7u+mRNYXFrP7RmTCpDodjX7kqbqUTTh
	geM4u92tJ/8sVY14kDzUB6XjcNI1+fk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BaZzNdZD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756792944; a=rsa-sha256;
	cv=none;
	b=70H9/i1fc7eZTASMiv1CkFrUHmmMjmjJilry9JK+Gw68Sy6j+CBtjjQwS4hL/k/9eR+F6N
	iYyJDodC0fsAuT+euMbpTKt9k6aF84pgnre/ITujmmNVy94wVdRI+DKo3z7EHGARIes511
	36mrEihIcfcOvPKrH7JNP9ywJmkO3s4=
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-89226ff4772so1414651241.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 23:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756792943; x=1757397743; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEAeyE+0TMUw/irMNV6HSXBtMni9AHV5BLdYl0T/KUM=;
        b=BaZzNdZDVhl0qA583PdoHpG74h6bpD8bX/EkbSoLH9APACOzP7Bkz7+Fz036SFG6L4
         1Qm5RxgVMcEt7j/yE3+Yo6eb1wSqJwU7uYPLmPGBUUSQVNhl7+BJtUuAS0aaNFhQvLWQ
         K1D/hvfApSsiVqib+wA8+KwxjIfbkuWkJVaLvDIE96rM2mv+FaHDOBZTHmwh6JAV3xv3
         B2FMTS/iNzm1FJ715Y6wZdIFTHOjF42b7CYhiYZY5lOKQnH79S1GtsJTaDeJp9K170kE
         ZlJd0WELjenczrBuxAMkS+sF/FvJsSFsU0vSTGKJFnI0I9gQqgmIWRMgqKrq1oPEljDv
         xwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756792943; x=1757397743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oEAeyE+0TMUw/irMNV6HSXBtMni9AHV5BLdYl0T/KUM=;
        b=q4Q7AOUGGPpmdM8Jqf8QeEZJxB3dv46f7H9XuuN1mRiQzDy3GSl3vsu/hK0wqhdQoo
         RBWRtK6GYLsUftcEuZVpct2nVeAEv1kPTzYuvnmr/C6IEIL5TV5QP+H5BEKysaBwzQHD
         ZTg2rJfHNsdTMAE0FjkX65dafkadV7Cly1ghu+Ayz8RkyJwF0w/I2j+wxdqRqxpEJwRP
         6EtzMHitzc00KMIz2W3TxSDatjIJFJQbnYzNH/p1NDySqu1ixX3dxLvmu8S8Rfhqbp4I
         JPuWJPQKClxbO7Q/byZ3XfSOl7tWLZqopjRdIpGrWsfCXKfF4fjoa/s+ae/47M66in8S
         o7NA==
X-Gm-Message-State: AOJu0YyLB8HT2zjLpDamI713f4yAWTRUZDAojAGg1NzXsE4c4ycd/DR/
	N3+tkLqff6/sGpyTomFJfMvw5tZ48SNy6QF5F6ktSazDIVC6xPwMq1k1ne/9k1Ff0C1OF0TpjXT
	u912zKl9c3d3FjkVnJsyFoTgHTYMYsXI=
X-Gm-Gg: ASbGncugGOL7Jmy47MJMvuT7XRdi3Ma595oh/ArAk8dgJXpui669dgezkXVRHYpX00J
	nHWTPajN/gPAHozZrd9+xC9vBww9ambD6tik5ECiulUMlz7AxhquvHDM82qu7oy5//cDXS0wWlI
	aacERGi+e5SbgM0bwxmoI/DZ0udm/QQusygNgiWz3ncPdlU+9D+49ypPyJwgqFEmfDr8/LsARSy
	t2rY1ft5CuMo65ngw==
X-Google-Smtp-Source: AGHT+IGnwmcDmk8tkNu8ZMJm6ZsY7tfwmFtfX3iDmwqaGXfOTfaCTjxC2YY9IZQZ4cqZF+eaCLbwUNNJLGjkb9hJJuQ=
X-Received: by 2002:a05:6102:5a8c:b0:524:c7ab:6bef with SMTP id
 ada2fe7eead31-52b1b809c7fmr2467918137.22.1756792943133; Mon, 01 Sep 2025
 23:02:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-5-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-5-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Sep 2025 14:02:11 +0800
X-Gm-Features: Ac12FXy6wS36mbX9MClREZ2t1AIDNIXLnTjeeWyfWCfJkczN6t5IXfD0myHNP7s
Message-ID: <CAGsJ_4x8fgWchmf4C8EvVK+aSK7gZRKzp9h=z0V_RpD2TmXaOA@mail.gmail.com>
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info helpers
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 026C3C0008
X-Stat-Signature: 7xa71sxur1qxjkemweauz4t5t8esxtpz
X-Rspam-User: 
X-HE-Tag: 1756792943-917762
X-HE-Meta: U2FsdGVkX18bA/Q3OBsBXQVzMECW2ReJmhUNyDBgE3kkvPT+CWDTeDBjxvgpVMx178JPKZqEYGicqvSVBPo6M/2BUpvtHINyGOgaWqSR/1+KN9qxlYKLxhKWTO0kvqIjg/Ct/G67hAgWxHhn3Bhgz0gT1bTZmAHVnnWJ0VPo4yLjnzQ7qj5Q8Y4jzzX3YWUTnngyC7+3lI1vYLrFppxdemxgLfAz3YOHM7/4MAoXZA1oLYnSJhSoUUYdeRQ83TPh5G/8wSt6ih7KDSbqazX0n1rRPpzYS++mK6OR3QcYkvoBX/YBstbZBWKlyqlgHRQlrDWCr2jfCpP1BYnVlW4aGtSFcFT5V8c2bS/0CYcb8lQV/hDeV1eH/pHsDVTwNwjcmMMAYA405sT02iP01cCRhHPGo2nxFTenX9jnea9dCf6A/Yw4mJy4wR2ttwcQKqqjG8vX8gOlBlKzRosNZJ7g5z+tIcFbT09haViIu6GIY8blQDrYR8ca9vGwRKXweqHViiV+zzKpeE4+OT+f2qlugAlPZYbKUsu0ay7rtgc6vZx+MShhsgiFQtgIZhnCqG137PXVfsZwbdcqqA4s4BGKxsT5ph1Ndw7LtR3d3bGpAxuZspQaqOw2u578oZM0Agx2AJSfUgfruT2s0LoAl+E0eFoNOUBC9YyNVa0joRzVedMMlxTNYro+tDIRBAZB+cEtJzg2buw7iUBCZTktaZFDVIS2YpfsQNJQ17y5Q/7wU+MXUehLA1zLLPmdExzyv86HFy6XKSa8fHjD47G1LJUuVqhGASfhig9vBQ7bf7tDaxWren0SFq/pZpeUUD0635AVhHdcnhnq5J3mMcoKim0/nPROvcaQfGuyqxyY7BCgdW4lsseGI6vHxYzbyH4CSSl4yuVYpNIX/QNuu+SW9TNeSQu/TedfF1ETOlQkJgJooPbO2Npnmk1i9D+MGOneXSaifYqBJ17uusOQhLfySLM
 Iz8TYrrT
 bbrHi8kX0b5RbK6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> swp_swap_info is the most commonly used helper for retrieving swap info.
> It has an internal check that may lead to a NULL return value, but
> almost none of its caller checks the return value, making the internal
> check pointless. In fact, most of these callers already ensured the
> entry is valid and never expect a NULL value.
>
> Tidy this up and shorten the name. If the caller can make sure the
> swap entry/type is valid and the device is pinned, use the new introduced
> swp_info/swp_type_info instead. They have more debug sanity checks and
> lower overhead as they are inlined.
>
> Callers that may expect a NULL value should use
> swp_get_info/swp_type_get_info instead.
>
> No feature change. The rearranged codes should have had no effect, or
> they should have been hitting NULL de-ref bugs already. Some new sanity
> checks have been added to the debug build to catch potential misuse.
> And the new helpers will be used by swap cache when working with locked
> swap cache folios, as a locked swap cache ensures the entries are valid
> and stable.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

