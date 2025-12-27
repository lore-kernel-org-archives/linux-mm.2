Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3709E6B279
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 05:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B438E6B0005; Sat, 27 Dec 2025 00:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1B66B0089; Sat, 27 Dec 2025 00:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA106B008A; Sat, 27 Dec 2025 00:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3566B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 00:50:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7FB2135F6
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 05:50:30 +0000 (UTC)
X-FDA: 84264176220.24.90C2076
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 17AB98000B
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 05:50:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zb0QestO;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766814629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYF28nILaJ3rJguImr/qXxmG40NW0XpXBZ4kGiyIYSs=;
	b=sK2vTxVZuwivxBd3Xak2tfNcLOkghmSrIiJ2xwzpCByoWruHdUb0SfrFZUR0ZquPFerqcc
	uVU8QMWb4jjllyrtziPYot11d1xGaKFVRpJxkBBlw7+VcSl2ndhJ1/hEAKVnFY3yifXhMK
	2jF5WBS7jKMVFu79FtGGn62MT3AqyFk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zb0QestO;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766814629; a=rsa-sha256;
	cv=none;
	b=LfYF4Xg/E4NUq70CRX0oMxChtVlE4ZDH9NnpFVtv1HkqznUMH0Gzr5612RYTmNrMJ6x1Eq
	b9FzrCoSxepRcz2AK2/WJv5g7DR38aWejmrhsc+OdQxcUeVDRsxugXI5pFEXVwmtBf/hwa
	ZOBnwgbONHDoTYOTQ0aBOBHSxk+mGtg=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-787df0d729dso63517467b3.3
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 21:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766814628; x=1767419428; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYF28nILaJ3rJguImr/qXxmG40NW0XpXBZ4kGiyIYSs=;
        b=Zb0QestOguQEH8rSv0q1hirw6+VjANttjJ5fB9HOOsoQtcdasZ2rkXOI0ecDTbn+9Z
         oaAreYe23Iq+J6cVEwQfXDz+R6ODF2R4yVNOMbaPAFoUbDQwK0zj1S8xJSUY9AZDKIZz
         b05XTlOYcT3PuJzI/HO7N+HJuO7aIn//cH7dpttg8x4aYZD1kQSLtvCNsAYne5f/4BDS
         aQy1tPXGvmzyRH+wKE3oP4wiILTPBex5KpCf4ijV06tFK4QNJeDIwe16BGszpxKx0sQl
         vVHmu9OAWqanbw9tBvivkBBru9ZxImkj1icr5/5U+9eMDQfbMx9X8eFnLQsouV5rv2eI
         Nxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766814628; x=1767419428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PYF28nILaJ3rJguImr/qXxmG40NW0XpXBZ4kGiyIYSs=;
        b=KFClg8qj3paJXRI+zbh6xWorCQW4WLFAJ0IOPo1lRvyoTiXejR3YaZdOw2l5Asnu9r
         SIetJo7tMSkdLVWCNGIRvuZweCbxZ0g4jB+WahBKy6GGxwGfn/WIwrgCoQ6QB0OjbYII
         CI5ir00+rRS9AO+hIp/4v8ppTYh1S2cD+HnckLHlgUtJb9/BWQlP/PWsbHVqPq31hlUV
         LC0OiePdbwbGb/b0AtFRgIXIrmcZvgfh3HUjbChTEjVUfdikxEaLrleNmJZuacPBVYau
         MTEUZS2GN5AxMskgQNEYipurwEyCcwJsPOsQdRowZ/Xs/2pc4uC2uFhjQRyJ9M7zacGY
         8H8g==
X-Forwarded-Encrypted: i=1; AJvYcCVGWCLdr7tF6UcP7qwiM8dHBJ8UgEcyxwlM9G7vXyHm3cShZow1jzbtioLIdzQ6TZYZhstp2RVx2g==@kvack.org
X-Gm-Message-State: AOJu0YzzsUDNm2O/ehjv+NLStUEK7JRrvbqDqgmSqMANDYFCyWjHykFD
	EB0kk/5bVrARDAOZ1CzTVRqciOTgsusbN5bphc2/9H77TGtao8k4ChMJ
X-Gm-Gg: AY/fxX5hTcJ42AN0/kvRSAMxbKtj9SkDvZQ2mk0NOy0JidObyLcJ9lokquowxahsakO
	aYpzr7tnJU+5VyOSZxc+wFw5VA7iC4xeajOF1DuVeCUC75VpYxg/CdTJkfBuVx2PLSB8DOyBJM7
	1NsF0R7147aLBfrpM1SgFXNU+isgwpTo/mUcrUEOwIr8gsTercgEMbNW3jrINXIXiB4yBp0c9w3
	Fs3emTAxut0WWH9bgjMa3CUIiH1Exk5yPOjmEuUA2wYAudhdRz+PyPwaZ1p/YY38DX0Yxdl+cuJ
	BlhT1nvt4yZoab2Vxg4ot/VJmbAtteIhf1IYQsrTNV0TJh+Ini7jB9WhOImFY4DtgoCbyv1X425
	/CXBTKpjLDEolOgmvhJMvspYAC4svmFl/1VmSwBUsnrugwwCG1zwvQDj+VDqBFA6lIPJ7obQnKG
	mKFd1TGX7exjlogXSyMMP7Og==
X-Google-Smtp-Source: AGHT+IH/BaDwOeNhR3tpd5h77fjwCgSXGjR5H11uTLe2SmDq82iVKR6SeOk4Vjq4J6Tp1xuIcPj2iw==
X-Received: by 2002:a05:690c:25c8:b0:78f:8666:4bb6 with SMTP id 00721157ae682-78fb41bebffmr225619327b3.60.1766814628051;
        Fri, 26 Dec 2025 21:50:28 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:40::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb454e1a8sm92114457b3.53.2025.12.26.21.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 21:50:26 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org
Subject: Re: [Patch v2] mm/vmstat: remove unused node and zone state helpers
Date: Fri, 26 Dec 2025 21:49:16 -0800
Message-ID: <20251227054919.1593294-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225210213.2553-1-richard.weiyang@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17AB98000B
X-Stat-Signature: csahgmiubwyhq5jes16crqng4mg417yj
X-HE-Tag: 1766814628-717593
X-HE-Meta: U2FsdGVkX1+DEBnWwvNBH0lsp/bw7vqPNlXXy4KRKlC4EABGk+Ff3eD23bEVjhHPTS+0LR/604VKgLOQ41bsRqN6p+I6RHVowWCbp/v3e3lBbv6ZvOdJ3dQGu5MzQascHmc0PrPxLzkeH27nuIKB3H5t3kq2yeFzp9FBQV+vcPYuB8ZojlF/Jw7bdzTAbzE9cEtZAvd1viOiQc1n26pY3xUvi19NV73rAGvlMryJjvv3TswozGLjFqS3xFZHS9a7AKfohELqICdCLwdZNVHbOwM8o8ayZ9pOG7WYV59NMqPeJDWL2MjwA5TOBtKTH/O8pQ/dgU+j4XKwSwInFl2Rk2QbGNF97g/Ywp344o1Vt9Q1UI+jPj/tDJfnnhp/aNlNg2yM7XnDYXx6RXErPH4GJ1WKO/Hyh38/fYzA3ltQ7NEEfftKiy0IhimuJ4SMRCPXJZzN3POwvG+fomno5YL/MgzPdsl3VWOVqTjcj/IGi87/rH7T74OPQNvyGBi1WZLcnASkTZ46Q0DQd+UGOMd4siAt4qAtaYoY6tJ0lhxECDpTxLaDsnLuQr9AXrIYkX84VOueie3siNS74M5zh0/Q+m8G1alTVf2RiJNx0loJIbJElgaTMVC3L2LOY6It7vkacslaEouHDsF8SI7+pj85fHEc6djFNsk8iNP/Th0ICDY96gT+6c9mowvy48zSQ+0qiFYZ7mUrHlZOLPtVfySd6fat7jFEOj+Cq0ehoqhXtOLwaB/v093JfOSIM2XBXmszbv/1j8BUzZRoisS3GoHDI/VCTo/l7Yn1trfHgBFJoyAHOmt4anDIjs9KdKooOb8OrldIF0ARPM3JwyuaY4svqFrDCDkrL2EA1XPFd1VANlUPLlJ1bhQUvRJF6rksfYRqModoCfDNsrOJabA9LbZitvpaaIOiJfSjbcg4LmNQIDAcQcF6w2/BLm2pTdMuA6EIq204w1e7k3XupIw71UL
 HmBD8Veq
 lgHUyU9tfmfLuj1vOalSYi4Fo2MrSbj3VOFRvu2YA/GPLmOILSXmgtNbHtYkLF7REsevaKoxSvi6DHLzJ+nQAMvBNOAWuroIAOEhhH2so8cBrcfSfSi+lAB/i5+6qEYSTpgLX5AJ7MIi/tC6YO3baUdMnYLkeKekYoCwLEE7YxFjBfZvds4WieDoqAlTt/1fDC6pAqMOwgA3RjxNjbPf41Gp1AXToPOxU7I6XuYEWwU0GINKi8KtxnMSrF0r91ekcrTTGX2fwFDp/73kJTzQsqNW+EonBUoiFdKbO8mfiv4tuAsfDx6eodX2dMx9+DvhrlYjiKIP8+X7YqnGXgEmmdAsZpjessEYb89BXxhgxUwcZr5ak/Nd1pA8mcOu4y+pw5K+8pNs4MPLqrrmjps2WnBYhgu7SVFmgi9edknoZNMye2ZKG4uXRTSzxuY6ZCDOheEjgKTBzne8ePSo1XfGay3Ef0caux+UG3R4xSDYszd35Cze1u+A0USPyl0FOTF9tR9q6nBftVUT7gpGaV4+PfYAg8FfNBo8AHfJkN4EPMh9w/0/cli3xhSeddvJOFpSFqZZ9pQLoVGCY/zLu1OMavDXI352O4uk5EeiK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 21:02:13 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> Several helper functions for managing node and zone states have become
> obsolete and no longer have any callers within the kernel.
> 
>   inc_node_state()
>   inc_zone_state()
>   dec_zone_state()
> 
> This commit removes the dead code.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>

LGTM, thanks!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

