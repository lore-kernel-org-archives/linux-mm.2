Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C20CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 02:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1590F8E00AD; Mon, 11 Aug 2025 22:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130DA8E0045; Mon, 11 Aug 2025 22:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0462A8E00AD; Mon, 11 Aug 2025 22:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E31658E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:26:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 756DDB5383
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:26:56 +0000 (UTC)
X-FDA: 83766517632.07.1AA6699
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 93CE2180003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:26:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D+EP+5l5;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754965614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiLtGb26xM/rljzOh9bOmP4tI6beFIMIEXOp2amuWtM=;
	b=S+PONVV+KnS1hSJKxnOF7YUZkqRITQ3EANrqNLpu0NXDKl7HdMljZu2dgYOZH2DiY38ZQv
	1ZDD6rf+oWamDjOWXa0C3mZaMyS2nqcyU5CvEdxSVHidZVuuObQ3F7mSmLxL6oEgK1EyT5
	gjs01sJKiBqREkBzt9ZsfLPS12YFxRA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754965614; a=rsa-sha256;
	cv=none;
	b=GuLaXKkmBVm0O7izpIY9P0E5OSn64h48E4QezuR6u/1CjA0q/mfJFpkGncd8/xkp4+KCNi
	OnMPNlRviTD7OMc2i9ACJ0wf3eNyLOC/ojEIiS2YaCXqvbXC9xf01u9FfAUFd19fLBRyEr
	Uzw6HFSNZPZdiPKMxYC6ghUrGJyGVmg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D+EP+5l5;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76bc61152d8so4249580b3a.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754965613; x=1755570413; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiLtGb26xM/rljzOh9bOmP4tI6beFIMIEXOp2amuWtM=;
        b=D+EP+5l5lrg5rJvbo3rVRMjS2H2trQwfMjj54PJsnbLN1Rs9WdufNWA7U0bPQMZx0O
         HRK2CwD6yXMIq8VtKpNGJMZmxuJ33yHTvRc1jCsQbJmPYuQL02UR0sQS53s/5BXXiXdb
         JQXyll018u31ZpFGpxsC/9so9PrwnkM9zI5yZtR7B1t59mdfDd6BI8f8sUJ3xDKRcPkR
         BsD7ezChbxPe3s+km6KNhfCbrFq26HBU2imtInRnomoLOQHTj7oHzq9osKovWE5pED+n
         QeAjZ3kx9l3p8JGICeU+jnh+fSmvhJRiB83QfywCR8IBVDcJ3c4i+MUawHqeh2l0SO0J
         DRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754965613; x=1755570413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiLtGb26xM/rljzOh9bOmP4tI6beFIMIEXOp2amuWtM=;
        b=X1JeNxcT1oqT2Xbf95uHPQfeHbwCr1JSmxO+DBg2R/444iZGmoKpdn5isKjTlpisCX
         48Ln7T5+8Aa0IBuvsPyssqOneQstny7mbLd1exxetfxa5FwcHS32azf9A8vhmYlIdYRS
         h7vUbUisRnPuQTEHsuNAnIpbHwH/sW+bPca0JaSZicNu1jmpnHv555/MAWpB58qbn4t+
         AyBBjBkoyz9XlELQ5NxFUJSLOx/qsnVUo5D1nR8N2ZTGk5GlEJ+ELz0PqG6yx4grJ/7X
         bfkjHL5zxzpb+pnoJLcjSkidqiBZKiYXzII3RK24fT0fLRxySrEyJUqBGPDtQ2LMNRQc
         HtVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1nvizW5Nsc9PK5aZiaQbPOdHcTXbzXFUtAFKnUPquQsHjQPedbYHa3M+vtLs7jNQOzGCIZVNO/Q==@kvack.org
X-Gm-Message-State: AOJu0YyM0GCC2eH7cWAEi1aHOdkepC/o2D9Njwf5uTZ8zukUNMWrVLMw
	TpTSxC9Y7ELdtNXw+msF7hhKbXGQVS3Gyxo0HETQnHI6SEgW+nqBDBWY
X-Gm-Gg: ASbGncujrOwFxvy/2+ViBv6LoPuokh7Zb4Vnx9HiSe89uKwIhOC3/32kZeOViR59iPA
	02uPp8emxLxCr/dYjTFmFY3UqVn+qeE4S9Uqyahk+NJPIjO8g2Lm4jtrEpszOHiuzBwVRcWGFxi
	obAFYwep9smFr+I5VCBo+bORoTE0h9Ye6MJSh8PbXcAXpWzYJD7D7orDt5mEVKp6TsEv4W22SWJ
	AvmUsU+fsmm5EJ2q5jU4OMIaXPFec/dIjz26Jqq5l7vBUSwRM6hg4S8MYCEWpgkR13d3/6mag9m
	y6P5/gRODb6TSFxKIhn3Nz8ReVmf9J8UHWdcnv51jk9MsoTHTavNCJ2llzgWd6SmvFzC4gwaFQz
	2trf3fLSvXyuJR/HWC291ZDNkZzjXwDenMae1MJI9daxoBg==
X-Google-Smtp-Source: AGHT+IG7v2sUZNZWdWgrLXeE+EbrQkrLxRlUOY1S9LqGCz+ODOxnt1uAtdoQIuU+xHVE5Tb9DxJM+Q==
X-Received: by 2002:a05:6a00:3c94:b0:76b:8b13:e06a with SMTP id d2e1a72fcca58-76e0df53209mr2731652b3a.14.1754965612844;
        Mon, 11 Aug 2025 19:26:52 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:21f8:86c:502a:b15c:34c8:7272])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfbce15sm28162654b3a.64.2025.08.11.19.26.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 19:26:52 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	donettom@linux.ibm.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v2] selftests/mm: do check_huge_anon() with a number been passed in
Date: Tue, 12 Aug 2025 10:26:14 +0800
Message-Id: <20250812022614.4964-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250809194209.30484-1-richard.weiyang@gmail.com>
References: <20250809194209.30484-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 93CE2180003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: bn7a9cbqqno4atnc151edkz4zf7rzego
X-HE-Tag: 1754965614-640296
X-HE-Meta: U2FsdGVkX1+z78D0fJaoId+cQefVqtefOVBmLJqz5c7uTSHFFCByM7RpZn6b9pqcEfCmztXigUYuXL/mHLdWX8tdfNXKxxDnqzGxc0SkfjASROVfZ6nnt+WgMMeZuFGcIHf1amKESZa+vEkinCxoUz7VXmP+ftgkgKpmYmQNVokFCKC6JYSJbb8o1njWbQVhjyvEbGlonu1ns4l3WWX67cpBjRX/gpd7A6iuK4EYFnYUxlttEJljgOfmYmiDxbu0cHy3lI64kIoX5y+8XrgobqfQNgpC7IRVZXvFBn40kt+kFzEwnwh4DiiZL50usyw4PWFb4KWc58xpwzBZoww5KoSSJShtBoHrgDdmHFsdgilZ+362DjwLD/cCg9OXm2f2z8huwYc2P0UTocnU4Zz3VzWh2mBWyyDYfItqyBZpIAmWqbWcY54t9b0gNqyMWIhc04JHUq/Id2Yww1sGjp4nI/F3NyDnd5oWzb/IO+qbAZ7ElayKwR8A34d72dwJAQHEJnldp2oSIHY8ie4atrDn2NDAAB+acI6Lxos/UQA02w1UpmmI2lZtWcgM8W9gNk8a4IZAkMo4Z2r6WJPDX2cij4ytXoj1cigA44KZ3przoeq/qiRVeARIIEsQBVSbnPaK8HRDOJrQkOUxFYTc/GiY0QJFKM0jF9N/FCyxfWwqb0kdTIINU+l6NbXOQ1iwdTka468rqc7m/kYztm5SNsaIx6wzInzI4CcEVIoMi2yrYrrhgm09UOAX+J2D+jHxyUDZqVEqC9wllt982J4dDlqb4juknad9ppaa/ugAFV7Hf9AsRlx7HuhMVFOB5BEsKvRQCryxMNtgKBTEo92Cqd648Y0in9ZNcsMSpiG3bBYp34R1kmcZV4GOoINPVFEh55AVCLvWkKGIeblEWLG4+qXV0NKuPunxZTDITT/ATZ/7IU1ABEzmX2CyatEY4XhhHpbz1gZC788FvCGaeIJHvfS
 ekV1+uYP
 d2pbVJxnBvIYX4I81y2ZUk4QzXiUwKcw6s20DXKrrpm4N/OOpvAsuT4bMXazfY933Vi/3QDG0gp+32jyq3Nf318nQ5LT0lv/ZytR02tDyNrlSh0/EcPDOT8JnlGnlXTuW3d4+C3/TFOOSDuRp1NXOcTtMiHe79/hNMd7WA5v7zJxXpZkXaCaJt1yCvcS6uOXXzlXQpuUZKbzpnB4KxKhAP5ImrmQAYvZbhdIKecSbVWDucWT8RZG6QJqvxEAgYxobFtjwToaKYECRuuXlqd3wTn+NHvjjB9+GvM3xLSB40X924YnGX8jNbaTyD9Kud6nOK9arTLnicnD7GMATHjEp+vRMvxOaYiMJcP602Y9oeiOJY+piWlnECqRtXuvaZ/Ska/Z8D2Zj+DjQuEV7Jtc87DAUrPhB4LyF2rYJg4lVuuYT20lYCe+gKQF2DEGcAV/2PKGpTm0aY9BsYwMwuUyQ6/LOzTLgbKKakBd08pDo+iGuIP3kG+4w0KYVxivHVYrn1qqLjHVe1J3JM5p3zExZF5gowZC16tu/0fK2Wilogjwt9QGcTlE1QTAdgZr6T4K9pqktZDa/Gu2sxbs6CwWelHw10htTaFgJMp7BsuEcuRoehz2Emw0olq/tZC9u80zFjNnz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Currently it hard codes the number of hugepage to check for
> check_huge_anon(), but it would be more reasonable to do the check based
> on a number passed in.

> Pass in the hugepage number and do the check based on it.

LGTM.
Reviewed-by: wang lian <lianux.mm@gmail.com>

Best regards,
wang lian

