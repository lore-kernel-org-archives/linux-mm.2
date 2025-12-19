Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F498D78793
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C826B008A; Fri, 19 Dec 2025 10:53:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113876B0092; Fri, 19 Dec 2025 10:53:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2AF76B0093; Fri, 19 Dec 2025 10:53:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E578F6B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:53:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA2C31312D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:53:40 +0000 (UTC)
X-FDA: 84236665800.16.BB491B3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 531EC140015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:53:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XoexSVUm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159618; a=rsa-sha256;
	cv=none;
	b=Sw7l5Q69PgIy+SlV5KKnzWyYDIH+PTMh5hMMSkX6fjltC0d1TvXpLXaTm/zjercKsD8rsP
	PpHjrmduir00hTsP747B4TZElBvYzvsYiC69OpWF6a3vZGB6qI2V/OrqLk34p2RTSfuhr6
	QRMJr+jygp3kJc9BK8GHasIue6j/XIA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XoexSVUm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/jqv3cJiOiniBhqPGj3ePpHhUWqhzpVBGmNIJAgyrQ=;
	b=kHEgMVe5nUDJ6PW3C/at0FypwxsTYFSQHCpEfeEgCfu3CIoBEIdoLUtk3Ka1rhZB8lNQuI
	/och+90+E9Aw7xG+gl/5EgtOPbPeGgYhaT5UpURvwYiAxkAt2412s8IJyR2aeBiv5Vr12g
	zGPZzd2wxtBHzQKck2WSpr5aGyosUGE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766159617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L/jqv3cJiOiniBhqPGj3ePpHhUWqhzpVBGmNIJAgyrQ=;
	b=XoexSVUmXXpVnWG6JzICABwjYTRotfwSJpfIvc/pRR0lqprz5RVF3/WbflWybAllq1fmCM
	ZdGmBQUX14X+ThQBuE8Xt2CIFmXqASAOPHRH1obBKihFGLZ8UUPb5UHfQtTf4Vd9Qg1Ie/
	45HaOUMTTosHTd5KRJCkaAfIfSLovYU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-x_g8M243OniPzmAwx_AOuw-1; Fri, 19 Dec 2025 10:53:36 -0500
X-MC-Unique: x_g8M243OniPzmAwx_AOuw-1
X-Mimecast-MFC-AGG-ID: x_g8M243OniPzmAwx_AOuw_1766159615
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4ed6ceab125so44801371cf.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:53:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159615; x=1766764415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/jqv3cJiOiniBhqPGj3ePpHhUWqhzpVBGmNIJAgyrQ=;
        b=GGW44TxlVxUIL+Z98GLnDjyamAi38Vn5bEwTkL9SUxAQD1ANlOHAu17vvAt2kNMjYU
         9JTbgQMOWec6WvKxBTxvkaHrVYdwl+5EegN5sBh7FL2Xd1dLV/pV2+JblB1EO77Jv3i7
         NKp5JyJ5y4TSSUACXJBjQ+DCyL0Ij4T3tOaS974VHFubznEzkd3Suf6DWyZmH0D4hlK0
         r7zZIHbNKDuRAvkixBLJxH4OcU+fEMqVoIbU/syL4LqL4HuIGgx5IZXzAvygdfPypUTu
         twZb9GG68WNW0Zvh8JNdDUQmySKsnkcwjM8cKGEVGmaKe7aip/IG+2xZjLfa2mrU13it
         WRcA==
X-Forwarded-Encrypted: i=1; AJvYcCVJjABdeURHJJ/nlZfJSdeNS4fHF2JXDQsZ8XMt+m5vtIvMvRb6Yy13+21M8wp2AJYxJeet+rITAw==@kvack.org
X-Gm-Message-State: AOJu0Ywglgmw7Fc3FfYAIUWsmflgCqJogwWMrqrTMsOYaoj2YZydleOO
	pOEowPw+O85HtjJ/fObXJwYF6m1MBmAuALkXrg9w8A0r2m0f0N+zaqYf2fCGXAIWh+/jDbHVU+M
	HnKLc1LuPB6P2FGZHlVF5TErS+nnlsHlwtUYaJcEL8rnlQ6t9ZS+f
X-Gm-Gg: AY/fxX7xF+FpkJ3HPrImz7yOezXopvc78XgS7rv6FQDCC4iM7VXTPuLGq1gcoEumb+l
	+fukrBzFGhTVl3ajnan+WKZZhgLrwplPx+0322s45IL9Jxz0sJ5WdIcD5sxWAIn0+ef/eINPJ7d
	zKSHn6KHVsf9fSCIJf3AtnNYPZweNhZZQpiPfq4J6HZnllEKqPYjAbU7P1js4PiRc4Wkjkf3vOD
	B7haBr7jFlH9oJ/ciG+EnE1qJpGeSZw1eTe1V0il90k4C2gbr0qpGN0l7OcconZeg+wWIMYiDaY
	9LIdbxWEwIhRI20VftVMsBqoHeu+VtPVq2WEn9i+KU7CRe6YwB2hw2vzaFIjlsGsXhN3pcAkhIu
	Liko=
X-Received: by 2002:a05:622a:613:b0:4ee:2423:d538 with SMTP id d75a77b69052e-4f4abcf11f4mr44817181cf.18.1766159615325;
        Fri, 19 Dec 2025 07:53:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFouxtlBTlJ/HrUU+MwNoFw+6sCgUDeVcjckP1nM19pQghsLhFECfIT9+YLku6qXfDkEDxFlQ==
X-Received: by 2002:a05:622a:613:b0:4ee:2423:d538 with SMTP id d75a77b69052e-4f4abcf11f4mr44816581cf.18.1766159614863;
        Fri, 19 Dec 2025 07:53:34 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9623fdd8sm21404906d6.4.2025.12.19.07.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 07:53:34 -0800 (PST)
Date: Fri, 19 Dec 2025 10:53:33 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUV0_TH56QeZIBXU@x1.local>
References: <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
 <aUG2ne_zMyR0eCLX@x1.local>
 <20251219145957.GD254720@nvidia.com>
 <aUVrfs1w6Sg0jfRw@x1.local>
 <20251219152030.GA371266@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20251219152030.GA371266@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7jssVO2cAW4jbAvaagwddom1r8jbASG2T7V4bL93DxM_1766159615
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 531EC140015
X-Rspamd-Server: rspam03
X-Stat-Signature: zd5ua5o7s1suhgbp7an5pohi6qjc47bg
X-Rspam-User: 
X-HE-Tag: 1766159618-902230
X-HE-Meta: U2FsdGVkX18uBrDWt8h8/GihCeLoKIMEhFoeGFGsBxOJvoIuY/iLa6XEz4DfEvULA9pfek1jB+Fi1sXogPTDBy6WbFgWDSc1ZHJdcni0g/WLj73jedYZfSqYVV9nckRZKxpMB/m8mrwqysVtqzfqMY4PQRmyNj2UiroO9oaHmGwklRuTrrKBD2cMsSFcwnGnbQyp6BRiXBslApZjP0gFcwo39KZ8WyOPjyjQ2uuKVk9qkuaKUW0EHuV70td2fiY8FPzLmHi7Glh3iKGt5UBq+705w1LUqLhKJIYCG+kf4PjbuiKx7/ITsTlZNORq/yqkqanwMQB0p3sVXS80dqD2HjKlMdoGjIQdOZZYKiU3wcF7wgT2T7+g0YKpbsJxw0tUraoiEvihim9OX4hxA4SZl9nEjXBtiuC4DWDyJBhDSq0OnDDlJvmulnY26Lt5d9bbLt+PNbZiiCbuKwYjVKVmohH+ty0VQ/hFi/soJRMYFv17J+sRpITb5Wj4hJKebSrbNx4bhdMrpdAHUpHkusdB1A9NAgQDf4QSPt0M8ayj7rjC5KU6oKrssIGvfb8TE7TCVygWBM7e+qs9H0APOXVc6P3GtBS40meIhgdvaBzlhGGXO/ZDw1iHTGcFqUMRsvJpYSvyilPJAlGAn0aS/4Mbl2caiwMtJ68nOqqebiB14Ngq+0l7eu5A0H/nLBr9KiEbEm2Z88nO5qvsH2QhYf9DEnFfzd6YAUcIEyBqdl2JN9/qjZi3IutjbVXb5aglAFlGcMjspe9lN7J2H2gbKg+2JD+D4NO34Yg4uOKWXWd+cQaR3Y22Xxby/BrphD2lojI6gyug0gq5jUOdOZmQbrGAoBsQvyMFQFXdKWx1+/fbY3Nh0weuFg/hA0DXAah2bgyDergyuTdUyH936yj+U6MazsgVpXiL4N2NQBXR15SPTwp3Ft9Np+4cxBonh/sNgriBKzoMEfRPtzh2b6ERC4Y
 f0yXnkqb
 P4OMwuWCH4E6iT0w3D0vzukaU5HfRemlK4DOTPKjMdl6EncC2uR+T63IRi58xsZuIys7y9B32UaPpVciDcLXQBwedv2N5d1GPZKs3roh5dwk2e7yuDxgd2r8YMmFhjB+lOG28yhphVBbTTCJKzPgxJtPApS42C5XyNhFDZQQ+H2271bsJn5qAs3wqns46VimKL26TDpwZ5/bmMfEw0p4F+OcZ+L7TVgVaQlSCwtfXlo4Ac28U9kQSaiHHCPAwfnMo3z6soJMJWk7xiANYWS45wdkVCIHl4pna6thxpGEvMhxACQismcrUNsHgG1XPG8appiyipGZcD0jBwiJsZBbIZsuIuLa9tvh4sk0TQVWU+E3TYzOJykOC30NzKNDOr5cdI68JGZ1s3Nm40wYJwn28usv7emLiwFfXwNfme93nJdattTH8sryLH3EdxHHBrbwayC9WmFvzmL/0FQF5m8KtZKVqF/RuAnwdPUSy7GfHIFpPCtrYpuKt3XQBR2QcIgAqi0UytyIMiUHeL5Ro7F8yT7+Fpw/o14/ttGpbbTPkhihqYa4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 11:20:30AM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 19, 2025 at 10:13:02AM -0500, Peter Xu wrote:
> > On Fri, Dec 19, 2025 at 10:59:57AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Dec 16, 2025 at 02:44:29PM -0500, Peter Xu wrote:
> > > > > > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > > > > > let me know; some example would be greatly helpful.
> > > > > 
> > > > > Just document the 'VA % order = pgoff % order' equation in the kdoc
> > > > > for the new op.
> > > > 
> > > > When it's "related to PTEs", it's talking about (2) above, so that's really
> > > > what I want to avoid mentioning.
> > > 
> > > You can't avoid it. Drivers must ensure that
> > > 
> > >   pgoff % order == physical % order
> > > 
> > > And that is something only drivers can do by knowing about this
> > > requirement.
> > 
> > This is a current limitation that above must be guaranteed, there's not
> > much the driver can do, IMHO.
> 
> There is alot the driver can do! The driver decides on the pgoff
> values it is using, it needs to keep the above in mind when it builds
> its pgoff number space!

Yeah, if so, it's reassuring. :)

> 
> > If you could remember, that's the only reason why I used to suggest (while
> > we were discussing this in v1) to make it *pgoff instead of pgoff, so that
> > drivers can change *pgoff to make it relevant to HPA.
> 
> What? That's nonsense. The pgoff space is assigned by the driver and
> needs to remain a fixed relationship to the underlying phys the driver
> is mapping in. It shouldn't be changing pgoff during mmap!

I meant, return *pgoff as a hint, not changing the pgoff to be used.. Only
changing the pgoff (as an integer) to be used in the VA calculations.

Thanks for sharing above information to ease my mind, if drivers are all
smart enough (I'll trust you more than myself on driver knowledges!) I
think we're all good..

-- 
Peter Xu


