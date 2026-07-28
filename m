Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D673C531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49BD6B007B; Mon, 27 Jul 2026 23:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F98A6B0088; Mon, 27 Jul 2026 23:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C48B6B008A; Mon, 27 Jul 2026 23:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3536B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:19:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADE781A029B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:19:26 +0000 (UTC)
X-FDA: 85036729932.03.3CC98F9
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id ED8C120009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:19:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LxBsPMN7;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785208765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gc3BaOWtNJ3jTzSBfuxoRtvMLkn1PeCp89CN3dg9r1c=;
	b=EBBVllVb1GmeLWoDUCta80XmhjCbeYkouFbDItA/ll20hEuFeFSVEQF4bHima8SdG06uCT
	JJhR+RqCV76z1OntPML52wMioBd0bDP75J+U9h8nh5hZ2ZoNqTnPBhm5QNilAda79x0awl
	lT3ZYAnflkQIhxM7noqwZjnp1gxK+IM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785208765;
	b=zmQEpGlV0z1V3/xmd82akV1OX+cdcxEj25htrg2S3OWqbIPf3CsJr4Yd4L4eErIUaqKba4
	OzDLu+ufvWZmUtPnjzPkrusi1sLxbaCMWH8eLkQlYilG7DdxWOE9SN7UODmDJQ1k+mA7vJ
	kHbfadoBibr5oDDM377AdMF7HdoQ8TA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LxBsPMN7;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8eefd4a8057so33335156d6.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785208764; x=1785813564; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gc3BaOWtNJ3jTzSBfuxoRtvMLkn1PeCp89CN3dg9r1c=;
        b=LxBsPMN7yz+oTE6lQ1oKU5CrZcsQ0Ry+KD1G3LOSYKwBXOt1J6C6n3Ceu1HYjgNUd6
         rCFiuJBXiP6wNxaZ1d0ixV6ypWbjl3M5oFoRpV2ON6xeWpJ/eG9M0K0xEHN1/HvABiTv
         A+SMKUh+BpiqiAercthhgquQwRgQqkwuyc/9Em9MOPh6FKZa/bA3xnQkjAMjHNesygyM
         Kt6eVjiwE/sc/o2J9XABZEfHHDsWFZ5aaY8lckbXfVYZQ3mxlbfa8vb6dK8ODieefhiu
         EGZ2vumPMnNf8cWnPkUEZEKnovguI6A8Zfps5p+pif8Y7SbymuIjkY2ODgA3IGa1e7up
         J5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785208764; x=1785813564;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gc3BaOWtNJ3jTzSBfuxoRtvMLkn1PeCp89CN3dg9r1c=;
        b=HQth+jcmtyq6cOrS8WPOdAGulOFJ0KM5IjnlCWcfJkTEA+QbEqVRpOtxNEaI3PImiq
         7PsbMNqjnVAhtAbtwAidfs/fmgzFLIGsPEh/XlgWO18z/mEomF9cf9AR0bxznKFZPYwv
         A2LxFmg5moKdvcHMja+9KYwKuaByh+3aYUmTGVhxRLdMcfjZG3x4Ccgied2Pzc7poyc+
         R6DLfoWWVO1wRp5bt7tIdVyFZkhkVQhStUt5Du71ycqdXXL62sYIRy1ccy9Brf1AUb3f
         99cX9aDHU0E8kwnP7kfNRDT6qpnhjlcWzTTk/ypOkvRdy/lYQL1X2apSAsDUXsz7x205
         IcAg==
X-Forwarded-Encrypted: i=1; AHgh+RrEjGtf5rVKyJHXC0sR0PsFo6s4+ulj+WCHFxS44S34D5aKjY8TDg/+iGNwsirtEMMnl0ViiWtmRA==@kvack.org
X-Gm-Message-State: AOJu0Yz2zSaiBe2aRq7rBSXDz8XSYndd2unqieWZLThkr02zeU+9ZCLR
	FssuNQWDwS203L3uPp5EMhsVO3kz5mh7HWGxCR9OicwOvTJzAW4k6fzsuVNKkIhCRZ0=
X-Gm-Gg: AR+sD13FYo61Qw2MCQxBnWDxnBtkaZ4ZXEjitmoonQdO0s0mkgr6cRAKHZOL0GMpds9
	IqZWvauJPZSQPGN70bBBpTKjkkFuTFOkbJRsb/I/mxszrG+EN9WcotnwLA8r3piVS5lBA/TppYQ
	MCWW2qWH/ZY26k+8Q3Px9cwG5LHaYxtOBCmaisyV/oDHcp1b89RhCPUeZ6iEP/kIS3o5uJtEi7S
	h0TFX4GIi0P9z5u1R0M1iN6RsHhpQr7vPntwSN6FvLjUenxqDy90M5E50aYotMgGn21evXDdW0i
	CkmSQlc13xFW9LEZ5TkDVrMNuerQPChB5HsypOGwbzIUHyONQy8nNfNJ1LcKIVFOPdYol4jZMlD
	mDWEL8eEE4pRm+RU5C8m8Goedt6Q1EGVddiu7OPrR1cV6lsrQK3tBZ84hxyIJF8+rYFyA/qbA6b
	yv0B/qKiuGn8eIXYGDAYscsTbxfNz23NbpSW0soMIug/GFoyJlW/BNxQZ3pA==
X-Received: by 2002:a05:6214:1c4c:b0:8ee:88fc:e0ba with SMTP id 6a1803df08f44-908170b5f04mr6466126d6.6.1785208764168;
        Mon, 27 Jul 2026 20:19:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e86d7207sm81369626d6.34.2026.07.27.20.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 20:19:23 -0700 (PDT)
Date: Mon, 27 Jul 2026 23:19:18 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v6 10/12] hugetlb: Set mapping folio order
Message-ID: <amgfohLFK_05UP7l@gourry-fedora-PF4VCD3F>
References: <20260727181310.2671972-1-willy@infradead.org>
 <20260727181310.2671972-11-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181310.2671972-11-willy@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ED8C120009
X-Stat-Signature: 51t6gztgnw3y9nu6obgc7twecyf85b4b
X-Rspam-User: 
X-HE-Tag: 1785208764-337680
X-HE-Meta: U2FsdGVkX1+LlorxSa15/fWdwR9mEJF9Md5YD1JqOaHGN6xQ1EEP0xXky4NOkWGqhgVZZtWWwK13+W7AyVQtVKDd+YDZtBE93j6MJ8CUjLhBGtJPAC9rw5crLc9k+/BzMmI/oWJz24YYuS61dv4iKIMcb6pRx0uWkp9rSFoJnqVgeKopJ12JkEml574etexiDR8R32YAU+KsNF6AMsWMO4mmRxEhu66EqGOKo0WJxCkvKOjFobdcXWCDrcSBxpmVtojxPZ0qvXv1uyFSxwauTMuZfkBRShbXZ8OAzozFrmN64uYr+NgBNj19PW1cq/oR5TV0pBNM8K+6xrFxOfOxsCP4vt0V9s3uizk7bq7WUgONc2IioIYlu4AgO//TvU4tn7cjb2wqWLUAFb14bLqdGzQK0FtXAc0+xJ8D7OkPEUqmMWsvkg7xl4jZqn43gOgijMbDqOKPYWjjMNsjcv5MRVTvJxeb1wRKvfECz+2O0IEHRmrkS7JCLXvj26gX4mi5Ibg574MjelIztFoBQAKwd0HYMMVe70XqUhgtB+XjHS5QEj/EtPsoggbCCu0qOTpJdGAI0D9Pd6xyasQLK0tefUfOB+eaJGUQ/JsyAgvHApO5Dp+iV6ZSzcWhlcnWPEYlLshcxRh3qY1X+Nx4wzrVPlh/Rbkr6S82V0pDJDU4D6d9CP6kOFkgG/BOJ+y8qyvpPC71Qe8XTBL9ZzqRcGkPTTJYYJYrTMV4DZh1785PAqAkXyG6eZT9emwPWlmFTGmwyLwbsuFI0+cPD5GJ/3HeIKCdxssFSEelBYIS4yh9AvmbaVfO2bNYLAga+mW8N91pwy6rM6OF95rMQv++sdAJSDadFhorPbMDtw9OvPnHLkq7VuNRT3o9foZoi4kmmtrnLTS1C0SePihySzgJFam1JtlHyZ/yist7ECsyBXJyTrMIVSDGLDpQELCricY0+AiE6iPL26YArLpLebt2MF7
 60CloAG6
 I9wYvA30jdjUg9ARTL82kAsgpimjn1mNSQMaAGyO8wYlIfB7jQ7U5qgmKI23v8CtknyiZ+dwwP4GIC/SRBMv+xXa5OGRDeoU4OL/2CcsCrQ+F/g0q36QrRwwNXm93T4EdcXxsDCE/BqYif43yI0pK19BCdCd77qEBUOdLUcuZrTJXq/GXHXqQCDhzw7yYgGQO9lbb9A5qJHxN7CoRzrzOhQrGxtna/InbdMVMwpjO4B1jvZ0/Tn0TvF2raLeJusDMMq6oGLFtqDfgNTHQ+JfCq4RnZJGHy1FDsTLcBHxiM8008zP8Z2tukWbI2TvMFardqLB60c2GVmzJssMcxMzILl/c5zt+nOtxs1GgSc2GlO4W8rIcoqJQ8UTWHGpSKt8JrModPqhr1GG2dH4xc/yM5PXLln3jlHP4wTVGVt3K9wxdsZfX7D/H39S5Gncm10t4zkcpo2YOUdCqtIl7guEpsMmi9/MOV0cJbqS/GshSAPD4WgMjtEufVD1tod1gC5wx8op3EhNCjdMC5gc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 07:13:06PM +0100, Matthew Wilcox (Oracle) wrote:
> hugetlbfs currently uses an fs-specific way to determine the size of
> the folios in its page cache.  Thanks to the support of block sizes
> larger than page sizes, we now support this as part of the page cache.
> It's somewhat more efficient as we have this information directly in the
> mapping rather than going from inode->i_sb->s_fs_info.  We can convert
> the rest of the hugetlb code to use this at our leisure; this is needed
> now so that we can use filemap_get_pages() unmodified.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

