Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB687CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109408E0083; Wed, 15 Oct 2025 14:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA588E006F; Wed, 15 Oct 2025 14:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB478E0083; Wed, 15 Oct 2025 14:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD16A8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:30:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 869B11DEEDB
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:30:41 +0000 (UTC)
X-FDA: 84001189482.16.78EDC86
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9811FC0017
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:30:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fTySxmAf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760553039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kr8fHPKCQCSS2Cz0NxhaRIgWGDrTqmH8xm1AG+RVO7I=;
	b=mVGXKLUYALphAtjx5WHmWtZyM7hoYInQO/9gcZ0FFEbaeCn4iekEJ+eyeFcK0Ku6f3j3Ng
	35PI3N9+Ohm0QF7WLa7U2TiaFH4f2laK9jBQMz7hDaQQrdqctwCByrp1PRfHYK/uQ+3dTM
	sxfp1Ji+zAQbthfYAmHmvg1ProMAEc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760553039; a=rsa-sha256;
	cv=none;
	b=7TVLs+MnVAjYiTXKZbWsrr41Yhxrr4UscFhmtVgoCfzwtz/KPKdqxzS1OP09pY6PHEqd3m
	zNlh6qmR5c+OS2vTE5ConWEneQIavloimWJZO4SShvL7wuKqRWns53lwl3ooZzI5Aphq7J
	R5XEJkRk7oAg0fGCFn8vX7hSBn/n+RE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fTySxmAf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so65328585e9.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760553038; x=1761157838; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kr8fHPKCQCSS2Cz0NxhaRIgWGDrTqmH8xm1AG+RVO7I=;
        b=fTySxmAfzjFZIDJki0sEwfarfrdM2DkhyVKCD4DvNvERY4m59g44+hKL1JZJnT08Pe
         aGuEI6jIMmvPKy6hzRsQQBjkTazdaIyrO5j87Fcx3MhIWxNzIv+2HHQf3TAeuQ3Kf+Aj
         TGfviLI6XM+uR783LgaKelkDCFbQplggZ+0KqAmadMK5Yx0V1gOFccopc8Rf3Amm5HjE
         vr3yC81BLLrxuUfLWmjjYuuljDd3uWtZOL9fneNYGqbn5wsMcAFqifJ6lYxC57tscjoa
         Clis6RJQgNQtcCpgkc/PBmwhMfy36IYprrc4/0ku3osAoSUoS07xrpxrO9XH/vdCJbfZ
         nq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760553038; x=1761157838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kr8fHPKCQCSS2Cz0NxhaRIgWGDrTqmH8xm1AG+RVO7I=;
        b=F9QnoEHFHNfrzfxZGA3H0FUhGOtLzo2PYc28EXXyPF6XABNiVRx3VMHp2AkKSdQ+7y
         ZtwwNsfRbNMKoKkY6pI0dUIEgZCyEbbTcghC65ivD+H7xhRbFnwuAEeG/FHh5YDEJwrV
         a2hEhM97PuLt93LYrUsLl8RAJ6GyQCa2GldmXK1/9mK42sQdnu/Erm//gVPIduzPt5IU
         XHkG5tm9iY85TEDWOGajZQguPPONzd4lWYh5fMTwap7Bix09a55f99uEkNmCv+2V5Gvm
         IuL6QDtWJz/5HJ1jHljFdHWzUQF2ceCXqWIPLxWpr9ITwj5w3KqHnIPuokE2ljDUdPv1
         O6Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXsmG5Pkm/7sbNcmjx1pW7hNoeu6m9I9rTLtD2TPER7YFNP2cNqnOemnhhKaPNW1WGg3A5QGkYY3w==@kvack.org
X-Gm-Message-State: AOJu0YxBj4bbWY0gyfRaanZVh48kz8xNKYuMIHXcf/syWFvKcDvvIXTW
	bKjeD5b4pz4z6R0zAtS/Z0XPyzOpneDHUs4urryRQfEIe3we/LZefimK
X-Gm-Gg: ASbGnctzpnx87dtZdryiPaixC+i78osbKPUmtP4vQzeY7A1VVPPjTrU2QEwe6vvvNLC
	IbtOoyialltoIQr/l1gdgProptlK8vnu/k3puEqx7zdQxX//p1nWx0Z3XYHfaagsZVATvch+EDH
	+c5B1Z3GuMEiV1QOze+9A4aRqxypDNrLviD3o5saGse/Oc9hSgiVOZRxQMLdUWnv3F/yXnlKO8Z
	fcIb4lOVzTMtSFJczXUggXK1tmrDmXeqXbz/JxrK2O5fQlA8kfpgCsymnUA2LlGH9UnvBBZ/v/w
	oQ/A+AimqRw1K7nhJolQ1PnPaWhJdHvQQEpYfUwUoImLSTMt+DMCe1uoTY67wKzTOlcKTs+SmEO
	3MF0n3J60rJxAjU6MD46eAC1DoupXr31HAKY=
X-Google-Smtp-Source: AGHT+IFfczfioijaKKD2pS1noEiJWYnY1kDJxby+Nn3g/JuazmJhsP6vmgjhC8NJIK9OxbeHpECqVw==
X-Received: by 2002:a05:600c:6304:b0:46f:b42e:e38c with SMTP id 5b1f17b1804b1-46fb42ee457mr147202005e9.39.1760553037750;
        Wed, 15 Oct 2025 11:30:37 -0700 (PDT)
Received: from fedora ([31.94.20.38])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e83e1sm30552851f8f.51.2025.10.15.11.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:30:37 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:30:34 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: wang lian <lianux.mm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Rik van Riel <riel@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mm/khugepaged: fix comment for default scan sleep
 duration
Message-ID: <aO_oSvC9LqbLjkJf@fedora>
References: <20251015092957.37432-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015092957.37432-1-lianux.mm@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9811FC0017
X-Rspamd-Server: rspam02
X-Stat-Signature: x84ek1rhimf4zaujxnokqu7m9so99jik
X-HE-Tag: 1760553039-419507
X-HE-Meta: U2FsdGVkX1/9DzKZTJlBgJMd6m0esj27S7FJd+CNGmMASOa9VSeAwnoUKkM3JpV1gM6i+A15df8iL0cKvqKLzeuZjd0ZRIS4YcXt3/WSG9VeHNT6o9dXbdgXAQIVQMZ3XehJrqISfkuc3IraXGVVVahI+tes9emoWDZ4cCKmoGwqRBkTp+YhoTN/y99brslm6Fb+Xpbo6O8AD7kp++/qUYBL9eHLffbN0SoiRAppZsF0xjHeIS4PvpgUhstUC2qpldulF4M0oupEKPihL3YOWk13pcConue8mRLbbRYjJSj4o7hOCih0vudI0XbqXMgCViC5Dr5F5WFh39Ulxaq2OhSXYwRxkbA3ozoCgRQKUhDpCYSiao8+1f38/ewpCNknmdPUVFwORisi0DnwsXxGgebxDz3isZeH7Xg7OJZy73qp78ww3FQRdE9MxBNdjCm+2C1SScVz/WU+VOD06dhPjYWMK2S4rHUui3oIHGqeNusR2GG/GAmASzPWr7QlImaXq0xnhWnPtZldmYgaye+KoIEsTx7fja6x+G530dn0O1wYmJ9JqQkE25MtObyqPFYVIKMw3pQssGiK1Tf0+QYMzYC7kAYB703j6P3JWqr/MevXBdE73sZKrxaoT18oMPYFkhV59KsFno3G/b4BhaC+Zyv5EXjqNRt3N+sP8KeAC9m/ohGh3F4mvWEXQLXreVxGC7R7KSNeVpCg3CgjK17W+mAzOfOiew4J8WbOblylmiY8ww+Jibs9KRu25p82FPpuiGwPtX0ZvidUESscrVdqYBITX7xQfCHL7LOmrqQYcpeo3Dclfy2N7WhAM/RjlZulx5MamWRXSrEydKovGQEkIhGwQEqFEaXGvpCs8OU5cI/2aeSAAEANIv4j5HrZ0K8c50XAL40lXJzT5TD3d4WAdNZAejKpOYHLH7NiWOyxhgEV2RF/Rh5U2Dzuhjt4pVI2t0kHeIrtT6BjMStwxUN
 uY2Ffial
 2g/qFhk12EuAl1T0ijocYpvXZiYTI69sRa9zXgXTX8EtZE8R0aXSgFp/tESEmxOKnbouDNiafniqY5BbNEgY+uCiQWkLSkaBeIWcRwwvjniBOfPpWErFVViqJwVvdJQrS1sJ+STOEVv+9LUKu+tZBD3RiU5Fk2xtxX7nKKOwAUW/j/bOjQPfGrEELDgZq0RXbYDzPjrDMO+M77VKGSu1dXnoBMcm7adENkKf6a8BhEXFcz2MMHYSI+dehFwZ+M4EF853t27w9mNpKSs28HTs3zgvogcLRAeB+oc1Nko46k++WZf0+oEqU0iIONu6t8QWIaxHSYEblRgTdNIj98eBjRmkpznqeq7O1YDzNkianGzLk14uqz7w632rWTSCMhqu5HWCvT2i2XEoq3Ev9ii3XankptXzeYlj1XV0RcBsusO4pX7k42jRZbUkXYcCBYH0BI9SzFDBniFNXV5DTnvuZedJdkIudsm5FHz5vQaqsJWLQeNi2Czd23R9Mp4evDFX8EBVjHdkqwmX6fUHuUMIF7Zy/Hpk+4hkrgc8k6WHbdrkSuXFjP5y1QL7Nj9i/8DvmaRoLn1XzTyJaWb7qoufJRosxvwUjQQDfIlah2yGadLcT+uTqTwsVtp+MeyleGTJApzMCNmZzSCDP1n0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 05:29:57PM +0800, wang lian wrote:
> The comment for khugepaged_scan_sleep_millisecs incorrectly states
> the default scan period is 30 seconds. The actual default value in the
> code is 10000ms (10 seconds).
> 
> This patch corrects the comment to match the code, preventing potential
> confusion. The incorrect comment has existed since the feature was
> first introduced.
> 
> Fixes: ba76149f47d8 ("thp: khugepaged")
> 
> Signed-off-by: wang lian <lianux.mm@gmail.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> ---

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

