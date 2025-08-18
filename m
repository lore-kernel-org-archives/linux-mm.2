Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C41CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649786B00A4; Sun, 17 Aug 2025 22:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6211B6B00A5; Sun, 17 Aug 2025 22:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537126B00A6; Sun, 17 Aug 2025 22:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41D776B00A4
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:20:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9C2514076C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:20:12 +0000 (UTC)
X-FDA: 83788273464.14.02F352B
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 007161C0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:20:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L8gc44t0;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755483611; a=rsa-sha256;
	cv=none;
	b=dEhXdUjdujjPm+/RiFKOVAfOsLlTwPGhzPBcQA551Nsz2aY2Vmp6+mBVioZk1XCSeWpoSq
	6mqfU9fxXKT+wkxVLYJtgxGYSZWw8DDIic7ClSeRPXqr1r26WACtA3KgRF8dxeuPQSLKq5
	HLs2VZlXxERLkC5RG01BVIN5jawn3Mo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L8gc44t0;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755483611;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwxGnIGE/u6rpmP70FlpMLLC8ig+krEGJ/6qzKVvYKg=;
	b=HQTlyke642/lXA+xeCZgyOFMDEh2J/o6qDtPU7mp4ov0oGBC8SOZ59R7h5hx3umo9tI8jc
	x3fyviYWcb8ZPNy0POrUzGa+MsSmb6TZ1i91PHcQLshv0LBtGl+P3ovVAN/CMOEsX0OT2a
	qdUBd/F/ZNrIt9/Vlypd+OeiVaVQgbc=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so4791799a12.2
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755483609; x=1756088409; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwxGnIGE/u6rpmP70FlpMLLC8ig+krEGJ/6qzKVvYKg=;
        b=L8gc44t0ldy4WKEF6HZz18gZrDABMbFhOcq1KeKjsAcqzYBVmvXYL+qFFSknMR0Q6y
         uW7RjF9aor5qcYN6TVNk04ScqsSkXu6rqs2Puc/L0L1cWHpWK5RNtySikMbnmH5cOcLc
         SLjnWeTWnnMWUX5/tcRIQ6Zgg0ZKoGaX2GY/Aebi/fQfZ2lX1prSvIQ0BeIb+TXlDq9q
         pDikH2PLtUuRrhUUxenRCGvQnTf1b/kXY0rHHHfFQVrJ7HBjYp0KdIET9fA+mUJ3B0Mi
         kNrXDcTCTVfmUfXkyJizeGwyBFFUsUW+x9FD7/mStmR/CVD5uycHvirpqLEYqqgKCt2+
         upmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755483609; x=1756088409;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WwxGnIGE/u6rpmP70FlpMLLC8ig+krEGJ/6qzKVvYKg=;
        b=rO/uIwVzfLGDlVvKkRzNTDHk0o9ITs2QpLl8fsOgi6x4QYcISQPdwNE0IvrzrM32Id
         nJ5WlfKPhbtfE8BzUMRUU7bl6eWmVejZQ8O/OKx4kfvIKhkNfUmedlgxW3eyrBUIUZws
         eaU/5u8dk+V3avkmrUy3PY/q0OY38CfKDqdtutBRFq32U69hEWn8nWCzOTrhumbcx/rv
         uy9n+Orpcv8pIDULSVUo4UOZm9xZ+mxDi86neZl+tu9kZBbTqsJDUWlXY9f96/ZnO2A2
         foGyQrQ8OTTBNSeeDI+OMpSU8ln5w76finJH1ubKpHFRBQwVQRlNof9UyU59wGodCX9j
         bRww==
X-Forwarded-Encrypted: i=1; AJvYcCXNEx1b78BB/2xoy4GUyxsLAd6NkMYJCXiCiH2tsI90S5YOtDDKFK80NQViAjMStqSdOpfaqcmiJQ==@kvack.org
X-Gm-Message-State: AOJu0YyxB/RqiB6o1l/cVO/7RMsR3KZm8cZxLfMHq7+VPWJh1kIYaD+1
	oSKpaSwRrEUhL9GLS3QOGrWn9rjiRunTlm7E/0te9rXWRNirGKhO/CC2
X-Gm-Gg: ASbGnctggiRazx+uTh/Z7P9Z8/02ReIjMhayY9ben3uuV+WYvlsbg96qwJgkFtc0ObT
	jMk3P9HkSw/soHZu3ZtoH1lrqWp7VhY5SEbP2bE+qZnMx5R4b2hNnTffpqpAn+ILmMN21Q1c+cY
	Srs0KIjB2nH/s96MjcRxP0CCdnJNG8fa+Rw1S/0z7SDonJ14UJychVORT8U84wuUJIOzSHdq1NB
	CQsBsmsJ2J9p/CYCGRG7bMg8EID3cxhXFRsJXiyVRu8IBWRgHB8wg5yGQR4sUbXdENXDBCtKEVB
	xO/5jN5vY6PjAuTF+NOJhxCY/A7fxAwCtL/cxzCexK9R84rubDdoiXdBl57iOomel868IFOb8zJ
	frNp21P6wfo0v2AMcBJ0Nhw==
X-Google-Smtp-Source: AGHT+IGwFdc4gymW39F5mAArWpddLZNkDxDAprsp52VIsn5wtpoBG8S3jd+n14J5BPESLrOPA8mj1Q==
X-Received: by 2002:a17:907:9814:b0:afc:a18f:65e9 with SMTP id a640c23a62f3a-afcdc1b7a2cmr907813366b.27.1755483609103;
        Sun, 17 Aug 2025 19:20:09 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdcfcd525sm694755466b.84.2025.08.17.19.20.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Aug 2025 19:20:08 -0700 (PDT)
Date: Mon, 18 Aug 2025 02:20:08 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [Patch v2 1/2] selftests/mm: put general ksm operation into
 vm_util
Message-ID: <20250818022008.kpw3w3iwgtrb3rdv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250726025223.350-1-richard.weiyang@gmail.com>
 <20250726025223.350-2-richard.weiyang@gmail.com>
 <20250815064717.hlkehch75t6blj6e@master>
 <20250816001811.7f85b64fe8c748dcd6d47c27@linux-foundation.org>
 <20250816085753.n2zxaxilg5ghcljd@master>
 <20250817190522.399e2ef126b816b72082948c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817190522.399e2ef126b816b72082948c@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 007161C0006
X-Stat-Signature: d3frq8btm7ieudwdxuabmpfwe961n797
X-Rspam-User: 
X-HE-Tag: 1755483610-336009
X-HE-Meta: U2FsdGVkX1/qsdTdO52PT4h7tJFrA/Bf2eaq3fbFW1Lf/daek8JfjUIweeINM6XED3CMINreIAagF0wi3VeIZeSZoC/YwMbLqHrmVFYxBxwf0AxPnjzJnU6U/m7MZx8u0ObXumwlYrRYZbouAYymuANgG8NlME6gxnftGjuH6Mh34uRxLCXr0BORcPAoeibckPVaUMjA4fmEauxc77q5htpJivRtoLaDaP2ONPZj3uN7U2QwRfm3vPKo+Qqs058VEahLgYj78VkKM5gDbO6yFdGeu883H/lYyHYY3GYlzmLDWxZFhy/8QBNK/59DiXXOzzfa1rkGdMbs4j9ghdiW+PBycgKVBo4voyzn6IxkY6ECHhzcLb8eVp6viX6bwZxOO0OZbIrTCidz+5+9XrPy1+WAkzD6fYBrrZ6JofZR0mnVLw1Ph/9dERUX+qICh0UbcfXwpSdSb3z7yK/zu90MMQygARsFJh8oRQYfniYHmrTpB/b3dipYpARgo/5Brm+YR+JJ2Dy4UyZz9ESMzQRxi2SCdZsZyYsx6yR+N7dq9fczutaCDVGpzMBN7Zz0drY0s0bziiG4CJIA+SDlLB3WgPR70R9VNMgSRZKGevQtA2bjZqKPpGvSSW/7lXPsTLmgDHlfAI3tmOEnrOTdGNppvmVdNkIJOE23lejJ5S2nH5Pk0UcBlup072sox9h1q4vvun+6R9H4LI26IH+PQT0EG+iU93w3HD+1fKcM3y3a3maUMYRpfs5dbRhlX/SMmWKqkVbch52xWsE+nQUKtlXjOGXNoLOjdNq8/1B82qL2l9n64fePtO9LkJ50FAK6jNKktMdWR7p3xvVF1aYScrw4UEfngx4rRE9xWSaUectZOhslmOv6jVn9qsw5Ar4B5Ozq3u7gDMCB1NX/swBYdr2uivhkOAFJRSIhhNQQq23gmGsw5yK4LggALhO5diOQdWMEY0tOFnIEjFse6gEGl/x
 UbZ0bicg
 pLTGpCHWPID9FbnbCkIbxr7RF7JaPkQAcZvQRGI3I8sLLYiWpc9NVTijgpXlKYTqk6uPmCb7v4NDOj7ONZH08swFo49T4fil7GqKahSVjaKgFiQpgsvFTJyzZb8asyw2uuR/WlRLfwLf6sYChuXm2ck8QJWr0yi1QB4oJFiTt17539LpMtUPUE5lTkHs9j1GTbXG+FyN/DORqqviupwkodrOpGwlfHnNZjokI2ZElei89YDUKmSy7RTI6iWBssDRI9uaVRTjAhjUmx11uk/lWItbwkOsZU7J2L6Kgyvj+4T6iuWUai5n0NFYW+oM7t3tUWH6+fd74KmlGRcckqloXkh71/X3efMl6AJJu1f4PQcE5YU4Jcr/mMTln6SgzVFoehs94wxcmoW5un1eW90nzm727WcfRuj2D2PnduLESLlJ8Zcxba0nsZK5BzT5iCQO3qT35vMsRC5y9RrMaH9bMXuFjPPR5AkUhCcL2GZCFCEB9n6GuWioLYx1cLc82r1c0/q8m8vHP+Bh5NKN4pm5OIaQSuxCJ6zZOFoFwKxbFAxylJNjotpnPLas3Bqx9D3M36/xZfmnalEeRX1fjf1TFrOe8ZcRhjN39UeIReJEYlHUKmr0XimnNrjUV6a9o4xMhUZPQnBy4ji1xmxwcDsTakYIHMrWtgDO7++QjalT9Y3vXupIlrN8rBtfxqhTA4mi5qxcdyZNmfRMuuBqNouk/4Z+7MfrlUnG3Q9NdN2jq2g3aFRZcARhuyLskPh3n8aS4AxMf7jaQL1x4i0VUESWWN9jizg01UMZuxorG3LhpsAxplSo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 17, 2025 at 07:05:22PM -0700, Andrew Morton wrote:
>On Sat, 16 Aug 2025 08:57:53 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> On Sat, Aug 16, 2025 at 12:18:11AM -0700, Andrew Morton wrote:
>> >On Fri, 15 Aug 2025 06:47:17 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>> >
>> >> Ping...
>> >
>> >Pong.  https://lkml.kernel.org/r/20250728020930.w7sv5eccp4kcizts@master
>> >indicates that we're awaiting v2?
>> 
>> That is a trivial error handling issue. I just want to point it out ahead and
>> wait for other comments.
>> 
>> In case this is misleading, I am sorry for that.
>> 
>> If a v3 is preferred, I will resend it.
>
>Now is a good time to fix and resend, please.
>
>And it's a few weeks old, so perhaps a redo will attract some reviews
>this time.

Sure, will do it.

-- 
Wei Yang
Help you, Help me

