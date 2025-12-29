Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16F9D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 08:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D236B0088; Mon, 29 Dec 2025 03:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE1D6B0089; Mon, 29 Dec 2025 03:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13DD6B008A; Mon, 29 Dec 2025 03:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0B906B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:09:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6498C62D1
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:09:23 +0000 (UTC)
X-FDA: 84271783806.15.D98488E
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id F0A2F180004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:09:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fBqU9Kny;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766995762; a=rsa-sha256;
	cv=none;
	b=cZ29WrQR0W2jAba2G0+R9kWkc6fj2aNrXUh4wFH6hBw6xyAF96d/CUqNvw6bCN79TzRYZ4
	UlGhiL+ZB379wRpbDbjVxj1cWImkU/uh+j2eA63yFLRVRA7f0naW3XGb8jSTauUnjpviFb
	KIBdL3qsJZlFBGUmsp9SPROoH7s/BpY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fBqU9Kny;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766995762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opSCzc+nC511vQoUKIzdvMPjR7Yt4ccnh4oDfpZqV/M=;
	b=jdGTvKiI9IpkSqV9pc3dIPV5BbUum7M39h6x/I5GI0Bs3Q1+nD/W8BzON3QB2cFgX8eeQF
	qJFSYa1RivRRzJXy6aUQBHay3kCLEUVV3zxIUTD1PbZgYRzkJfyHs6iBC8SNI3t66FagJd
	EeOF1zPhp+mAjv/NzbHyoXVItXB+0M0=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8887f43b224so134272776d6.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766995761; x=1767600561; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opSCzc+nC511vQoUKIzdvMPjR7Yt4ccnh4oDfpZqV/M=;
        b=fBqU9KnyVlMkYHJ1CA8LnHJsBeMYdsqegA4CnnYtML8N2H/mkH/8dRWIVLK0A3bjI9
         Sclwx9Wq1c+mGK2q4OVggolVPNYZ8ZRhyZtsE2jw+pvm7FOrpRm21Yr3WxzQ9qYuIOSH
         UTabhzuGApII7pbuVqc228Rkku4MSI+NDTmsjMLm7tIeB6KEeBglfpFpozzzIWkzvKnb
         UEKcQsCb8SPPg4ICYHv0kcWdAvk2SVu2ftNmVDeHaxuxgNQTrwv85PazU9PN/GfoBw9W
         8259Kh4O1rRWQER/i3VBrjPL1TcJ9GbL8TQxscUOEzdpu6nvx/I4UuBwE/rDtujfkg1x
         uzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766995761; x=1767600561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=opSCzc+nC511vQoUKIzdvMPjR7Yt4ccnh4oDfpZqV/M=;
        b=PuxKKB8Mmk2OFTO5gU7tff8dVp03MqAxTaR/F0XoOOivemU6Hp81czkP5jjb6W0AhE
         BEcUJxa+1oC8pGmbh+Vx0GGfeyGcx0TVF+uSzXu1Cxut8zxVVvJ9CBXDZlNjHLdVFk91
         rTZGePhMrxfILeRn49F+0GN2IRHTSPlYR3k+fMJ3mNi0OP3n9W7nhBscTfy1hDkVHqQB
         2PmAEN++a7mjujNE9aN7xMxI+CYf5YEvQE05zuz8KgxVffPIm9Tj82IRP07zs/htUDAG
         fgIrZkC1azy7YPxUBkS8VhNUmTBQCBBC468F4WxBx3oqaQZWOK5xUlXqLWq7L1zVlQqo
         +Tcw==
X-Forwarded-Encrypted: i=1; AJvYcCXax9GdBkgHQYSUI6VtXNlqOGCK/E3wn06APaxUbDqUXe4SRgpOUl5a8PG6qeYcbGbW9uyBxqukhA==@kvack.org
X-Gm-Message-State: AOJu0YzInMvhxlzGlrwxrIa4vSuJohavNlL5ZmTj7bYM3vQk4TbSlTNk
	z1Linu9z7FQN1Z6lGvovRJqiZUIBm7K56hRnQHs76EX0vApYEiW2zjKVt/znrTMgQrtYpDn4rGf
	Z7cdyyIbgMhVtCNzDvWBs5bZL8ZcueOs=
X-Gm-Gg: AY/fxX782HZPwyjD2kgN0hlw4fkKiWntTJXHJVWxsqB995gcJh89HqwQ2BC82rVSeXF
	vqJVyIBIvDeQGdrAWVQhsS+jTw2ghaPvltbDepPdwzuapDSQc80AMAWeL0mlsRQJGQ34DaLd+1J
	gAW7TkCJFrpxYBJMwMUT62sw7XxgNv1glK8OjAAgsug/qps4MFdLBDUfYM8luz0dM+ykI1EvSha
	OKVN/UykRo4PSJpqpJ+vNgOOUCqgibxh1lXEVRI6aF0eWSLgs1eM841QDqD2QZOLUCl+w==
X-Google-Smtp-Source: AGHT+IHFEPnGVGVvvnDs1HCSCnWEw25Lkc3qUFaeX/pT7S6JZb4A/q1xHlFXxG1pfnW2jDzpbLnUcvmRzyfGvknptJY=
X-Received: by 2002:ad4:438e:0:b0:884:5e18:e91a with SMTP id
 6a1803df08f44-88d8166a2e9mr391836786d6.2.1766995760949; Mon, 29 Dec 2025
 00:09:20 -0800 (PST)
MIME-Version: 1.0
References: <20251229055151.54887-1-yanglincheng@kylinos.cn> <20251229055151.54887-2-yanglincheng@kylinos.cn>
In-Reply-To: <20251229055151.54887-2-yanglincheng@kylinos.cn>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 29 Dec 2025 21:09:09 +1300
X-Gm-Features: AQt7F2rnRJz1XhTQvgOAO-QQo6owISjxtzpIIWUrQPVo-0K_Sb0sv8LM9eG4Ie8
Message-ID: <CAGsJ_4zniJzECtpjAeZrjd1F=v_BbZ_73w8f7Z3Mqg6Ljo+DdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, 
	richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F0A2F180004
X-Stat-Signature: 33acfg9r3mjtbewbrspj6tshipzqqnjs
X-HE-Tag: 1766995761-863132
X-HE-Meta: U2FsdGVkX1/lJmczoqeePJN9uOevPg77njHDvh+7SOA51C6Et+97B2G5mQmRAhwNXBhBNV6Me9At4oTh6UZWCX+ga4hbDIqSLLWphJvsSwa82gGzbMaJhvyvbx19MLpTyfE3lihQLvIJ5+IxYLF445ntadDG7zfOaqLl9+RKNJerfXJolutbIZiWXSnA7bGLodNfnQMdFXDPcwVWRTFr1ScwrJtZoQDvgcozXmKXN1mRBbrnmSq395J/pxeAzi9eDIu8s8c+ETRcd6JsgC7+KlYC44OKezVVvtI25IMaIUDUJXy/AtnHsfHzC/ypaR613UI9R3G2eYKZ+jrb7prv77v9A58Dxh5lQWS4Zal3IrYwoD1/ILnEOR/YbO7zFDoYO4/2GCJeK/GPhq6I7BqS+crwz4XjnFZPQwJ3UjR7osRIknONVBBjI2mt8x17J2k97RyWlej9XO2UR90boIGuuLq4Udj/YypBSBemQsMqPTX/r9lk3ovxQQlH60X7SdenSgTQtl/Zv23tCtzNhCyWUbs8WJxDePQUpPMF2GYw0akHAuhnwzTRI54JwP1EYZp9FzprfbLBD34RyDnRdVgaxYTGEUvwFQxxOOGeTA5ipfskdsOP53H0ZayeZe6Vj/eR5CNlfidvfo9BhDZwFK+x8JYS+tnbQpBp3PHrHhJuok4wCbt4DIPXjRP/ZYOgwrV/bUDLdtwAk7p4aj9TTOLonhEZHIRSbOLrN55UGxaMEW3fCqdGJDqc0TVnMwYpwGQ8LnqsCxcg9tdT4wiagWuopirgQjFv5mIRAAKSEPCbTqRmRZw/FjwZ45w5iDxCmkz6zEGkVgZD6FjT0fKeeskRyqpAqo2EyM2Seneq4t8n9IPdCbWU5seHm2RlYJviBxcLuwZwMBCNBH6HoDzP/Ru9XS9/m/wHtByhlSYYxYov1miY5Jt0wrQzUw/WIarDdc8ZiZBDvLu15K5BD9Uwv3u
 BrY5YzcI
 H1VgfZh07T4Tf47Z+/JNcKKwrLaaF815NhVHG5t80lc+8MX2zT0/1H5Rl2nPFpyhx4ETHuX3ttJvRZUNGJrFlnkfXHhbPVRSgGk3B5V9K6NDvFCayWLA/bzUnGLZU6VqxSCM0KMGW/XehajUlb8+0di3pkSZU1S8VxGgtUiuJzQS65bnwQ/fNO/isC9StgMXjqVZWoo/4xcQp49/vI5LSF0DkmSKf/LF2V7ziYWzhNU4P3VBOOSw4eXo22fqk8EXd+weo36cV0D/urgqYu/Pil/ZHeZc51HkQRSjnG6y3Nt5SYDoYXqTmZDlZcDloMx698vC0TeufREXM/YPEyKOnXYguHPMTrFuxk4YrU9WZDtsngFQPipOG0BlLGtFCNKVsqrwvmht3AP/2LRizZRdsR2DPnYkVRyCFRl6tdz13WDLvBeXXdv5l+uootzn57mYFqtYWOry6n/TADG8TqXwrNAVKNXMYRdBhkpMpak9HfvLitrnbwOs675R3v+4J7YeWEtt31678QhTU1yM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 6:52=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> Add mm_khugepaged_scan event to track the total time for full scan
> and the total number of pages scanned of khugepaged.
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

