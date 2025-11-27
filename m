Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6EA9CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B98C6B002F; Thu, 27 Nov 2025 00:23:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268656B0030; Thu, 27 Nov 2025 00:23:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1595F6B0031; Thu, 27 Nov 2025 00:23:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00A896B002F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:23:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82B85BBB64
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:23:14 +0000 (UTC)
X-FDA: 84155243508.22.B2CC504
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id A40A6C0008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:23:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PIoDU2R2;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764220992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StcVa13Ua5z1RMRwW11UjBQ5LX6jOQB1/B+3NnzqYtw=;
	b=KgAt/2AuCXuia532Qh7RszuDSBvhBzTXGqxZ7h8PUpvYYdeT0yJ0a6JBo4Jn1P4p4uNmgb
	lZ6EAwqLbYTFntPZXeRgNs28rpusH8H29FvLtWOKCDulPH+ypb9AgvrQYH3fwJODu9qa2Y
	soQI4VyzACDzwDFMs0J/iQirlMFUl8A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PIoDU2R2;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764220992; a=rsa-sha256;
	cv=none;
	b=OIm9h/cpMC1WDG5ZLUI7maf+SFOpE5cy2dR48m116MPatQD2yo2nMo7NtzX9oD5bPePHFg
	92uvJQy+pkOzBXGVK9TF2zKHQu+WkdyqAzYFjkLbtENoYt22yPGx4wLGVyxjJn1jVVa9OR
	yMyN6ItnBde8fDmU+e1Boi3w2qRvhso=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8a3eac7ca30so29212985a.2
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764220992; x=1764825792; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StcVa13Ua5z1RMRwW11UjBQ5LX6jOQB1/B+3NnzqYtw=;
        b=PIoDU2R2JCPbz2JJcxgm3Kut/AV+UYAD5Xgt8rQi0pxmhPaLXAUREYMDzcifaWkDme
         ZNbXSL6+Z6xlAuyBm7NxXTMljdT0OOWutNqpud0hSxsPLun1zcM7Uyz+Qy8nqtqNqyn9
         liK05GIns4DsTlg6WUUWzpAcdysjA33FTfVdxoWRqiWize5unAJYBKecwHepktZXjsDX
         D9R4IlRxFaItqlogv3mKs7iOr2a8oQkMGiCi9+rMjtXp9B+Ie30pomoKJErHSr3eBWwA
         C2p4/3KBIE/MMyAUnOWJ1V0WYIpsjE4AsHsP5jEBjqAfWgfxQNRykjQKkc8ULCkivN3l
         JdUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764220992; x=1764825792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=StcVa13Ua5z1RMRwW11UjBQ5LX6jOQB1/B+3NnzqYtw=;
        b=Iie+m8/AP4wBG2BsoAiiDKiM+3CDq64W5dQrjUe9kOzXTsBimLcI5/1ezS2dkllrye
         zMI5trISDrblzl/Opjd+vrUoIDChBMp6Pycns7wT2dU9u+bQoXTCdrzKqtMOZDTC1UrV
         m2neLVaLypn9HV1kYiSlUVpe/IhQBupAdTxOBZKovxG4De23qQYKJK5gNngHipRLEowj
         DQ6JPXACs+LyafqnV1Mxy3SPfl6OwDvQDH+LqHERylnuEb6P0zoqiga7D84bxIp5jPfy
         rcwvn9KylnYjP64LJfGTs9/iL3X/qVRMBfh2m196SKDojP2XTERQZiBvDjy9serFZifW
         2+vA==
X-Forwarded-Encrypted: i=1; AJvYcCVIJhsNnDgMiR6eZSvEnUrDWXyLjpL8wmZh5RY3gNqn2FRDmCqYuGardovF5PQG1Nxvk9QeMAjLcw==@kvack.org
X-Gm-Message-State: AOJu0Yz89GGjqSL48N5SkRt92x3H4YqBREATNuoA+lDsklRy27FgUPmm
	P8OxMlnCOswbkAk9KFdxxiSmS8EuEPY/bg1RwpzqvDhMfY+kjEGN6sOpmJlWy6udG6RxRxWg+eL
	hBBDHWO1lYGWa2eJ8LasFdgkrgg2vJGM=
X-Gm-Gg: ASbGncvEyGPHoC1H3/DUQPwEQ5T1iN6egEYYZkG9WTbCPJ+x3SaD6UEp3pP07yhH1FR
	Xn7cuIPIzPSe4CEWgSZ0E1IJrpREGPLwiO2PipUOeFS73ZH8q/Qbm0BbohkBw9UtVg9/yopcTRj
	M25d2GYlk1XepOBxOeGA/wxwwiqQ2dRB4x+6CuAjwa/sVamdXBGYTzrl6zZ+tO+U5sa4oanUl2V
	WCVxMYx+fk0cZmt9DvCn2b4oO5n+m6+EHqID7Ih6kL0vq9WNhaylgEyjevZjV0+KuAaoQ==
X-Google-Smtp-Source: AGHT+IH9WRbkFjSMkM90Ik45wUsdEAPdm7CMfOYZj3P0AKrWs/2ecgk1KxoPf7v1y2MRQw29xCflOi3LmLk7lt47q9A=
X-Received: by 2002:a05:620a:198a:b0:89f:52d:8560 with SMTP id
 af79cd13be357-8b4ebd9ec70mr1324075485a.47.1764220991599; Wed, 26 Nov 2025
 21:23:11 -0800 (PST)
MIME-Version: 1.0
References: <20251126035008.1919461-1-ziy@nvidia.com> <20251126035008.1919461-2-ziy@nvidia.com>
In-Reply-To: <20251126035008.1919461-2-ziy@nvidia.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 27 Nov 2025 13:23:00 +0800
X-Gm-Features: AWmQ_bklp2T0dZVx2quuRJqg0UUTS8PNBGI3pTDOiCQELG0N-_LxQYk2-SUPTYA
Message-ID: <CAGsJ_4xyFnFefTS6QAC3YnUdm56_HJvxzrTD=bWP5LZqHk0SEg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/huge_memory: change folio_split_supported() to folio_check_splittable()
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, 
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A40A6C0008
X-Rspamd-Server: rspam02
X-Stat-Signature: 7sfxe4f8o9e5jb1z3mdx8ohcw9osxwsm
X-Rspam-User: 
X-HE-Tag: 1764220992-360478
X-HE-Meta: U2FsdGVkX194xbQcazp9zZPXSvUf3zlnnbdm5MGXL4J5ygxPWvNfuLTsSeBJooqKz9x5zsdRZQnPhe1OpCOoaAVXBZVnw3aCTfV2hIysIGFfjHMHJCdm4OybL5sw2ZhAcOO+7DqlSjI+X2g3JeOFjomznK5Zu48Bu3bXF8pAnT5SRf4C9aEYQIvKW3wN5Yhla7hMXcF2LE/7pNyyyZe4KJHCNl1yUXYDRvLay/SFUCpIXGoZdnHlbmtKlXgwYEEnVeZIwKL7KtdnmawuPjEpK9K/MHdz3g3uCAcg4qltWH+TQHVgx4d7bwRClhCpaV00tBI5C8aF0ALdiI4evmvVMZG4BFhmogeVFbLgO/QWfcjKc8i/WKvU2UmB+hZswI9vjESsv0880fcocO2eX1MzUpHDWwWeXPXyjX8uxBV8/4AJsPvhVVisKYYZBLFGDJ2rC5yvBBj7aIWy9pZIAtajMYkKAxUITjhzOWCwuLN4Fl4FBD3jD4Sw6X9IqYJ+7xNZdS5sARh9cdnSkwW1jDp5i4JSVzfNyLqm9K5Us7cnCfGvuAqOuSVbHzbCTobOWV8eCtoLjquqWAbtc53+rrOHQueBcUiscTwKMeGjYPLxU5Tl38UjDZL3L6wVZEBxyqIPogk2Zzl0jPKJH7CDdZNbgz22t6UVJUQOCXXQoDVocuWQ34waqKdbHxuAeEwpwwMAgRK8WSapzEwYAuUZSgnmbdVrdxGDmzQzLcmvmVj+h3xl/OLI6+bhGu8WgKtcXjIZZKlSlYTuGen4cTCX/y0Ud6ByJFItHnvEdEvszvHWdJt/WmaZZLsWPnONqmVLar4YXyT3yuzJsB2Urdw0tBvlW0m8kjKXxLJUQqINsogeFANudr+2bI9GNkjjm/xegOtQbedtxzFc/AAvpyT6ktGXffFdyYUiu0Z0e5jKtcnusNXuwnjdUINODY8OS/Wk/KbUdlsHmqwUIrMdJ1ZTgbj
 s8CgC0Bj
 leAjS1Uge3+TBmIfkXsbc7QzB3b2BA9hac8ncNnxBI9xiCcukfVEwjgspq50/c671Q7XlN9rr/W6WpRt1HuEfthB8oL7PiG2AOfGHHYbnjDHLdGX0WlV2mIb2VtNSo8BO4LEMtYsgolyXRnOMZ//uC/2HDNsa8GE8nXQHsDyO3LCD8j2kj5/+5XhrL5fLWOLSj4JspVe3PZP4wS2ypyntWsygyb6dskF3bj/iHVP0YrST8bPtAHC0e5u0r1cVMecte9ssduXFY/SflAv8xkuzwSwNapO8jS1Hgwy8cKUZszJ5XMJC5CEP8yOOZD6/Y+4R1qw3uqvckrVvaaX0VMBwjy6L+xaQ2P0ZUuhRb2ZOR/Y9lPKDar8sIC+8PyCqnezXLGBpL60u7B3LqTdPobyuQCDV5UmvRBAVSizBZ3TNZzlchF/nkUDq8GTBJhrYj4YyT4N1hhGFffFvNuFcR5Yb3n1EBwIJmW/QUalkQNCO6sHtIAygQDpZD+PEMYU2ZZyTjOBHXYJlRBGWzlZJmbqf6xUyfjcZC6+uvIzN4a6moYMExCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 11:50=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> folio_split_supported() used in try_folio_split_to_order() requires
> folio->mapping to be non NULL, but current try_folio_split_to_order() doe=
s
> not check it. There is no issue in the current code, since
> try_folio_split_to_order() is only used in truncate_inode_partial_folio()=
,
> where folio->mapping is not NULL.
>
> To prevent future misuse, move folio->mapping NULL check (i.e., folio is
> truncated) into folio_split_supported(). Since folio->mapping NULL check
> returns -EBUSY and folio_split_supported() =3D=3D false means -EINVAL, ch=
ange
> folio_split_supported() return type from bool to int and return error
> numbers accordingly. Rename folio_split_supported() to
> folio_check_splittable() to match the return type change.
>
> While at it, move is_huge_zero_folio() check and folio_test_writeback()
> check into folio_check_splittable() and add kernel-doc.
>
> Remove all warnings inside folio_check_splittable() and give warnings
> in __folio_split() instead, so that bool warns parameter can be removed.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Much cleaner than having a "warns" argument before.

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

