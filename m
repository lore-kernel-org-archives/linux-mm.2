Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2075106FD60
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 02:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAEBB6B0005; Thu, 12 Mar 2026 22:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32196B0088; Thu, 12 Mar 2026 22:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14266B0089; Thu, 12 Mar 2026 22:02:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF8F96B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:02:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDC981B8545
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:02:09 +0000 (UTC)
X-FDA: 84539389578.19.9F8CCE8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 73463C0004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:02:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CIaiS/sM";
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773367327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAyhRnlNpUnX5VzPdhg0Qd00rbCwrg1BNtte72JRAqE=;
	b=AfK/lJN9GH1NDugZrMwX4li8gcK0ICd2au+QEjq3ceP+oz/7sTfpx9cjYqBiMO4Zg1qSdZ
	b1YSDWrq8rU9/RJON01SrQi0/w/yOKRxUB4O5fous56cZAghXJRX9nTijqeB9NDj1thsnt
	JlxgbSr8yqx8+MtbUZFhwZfCf7OF7sg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CIaiS/sM";
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773367327; a=rsa-sha256;
	cv=none;
	b=0msqIUXqY2qfGxDsJ1yWEYqi/m5DZFKhXvRU6Ny5A+O7i4is3O8pSfQN0Se+wdEoccli5y
	YmbzUwORjQTxG/+lkDO7UEGxgcuRVgx5twckasLddIkg0gz9i5GPupQasL9QZEzSaWOISg
	equrx7S3HU4LpeuebmcXA9pElhlGrSw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773367326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAyhRnlNpUnX5VzPdhg0Qd00rbCwrg1BNtte72JRAqE=;
	b=CIaiS/sMurK3xS6/KBeNpXlHw69wQnJnVm1h2IWnyreuWN/Nt2lyT1VRqWerAgByVsSjZ0
	IFxLYUFZ9PMlKf5WceOML0bF6S9bN/gShoD6Aqh+b0hpIAm7NZ6rFHMyhoUfwROai3hw7l
	F5pqdVhjdX+MZwFUEIRUYNKNsXh4G54=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-Hs3dG3gFPzmMaH_mfqe-rw-1; Thu, 12 Mar 2026 22:02:04 -0400
X-MC-Unique: Hs3dG3gFPzmMaH_mfqe-rw-1
X-Mimecast-MFC-AGG-ID: Hs3dG3gFPzmMaH_mfqe-rw_1773367324
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8298150caddso1299713b3a.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773367324; x=1773972124;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UAyhRnlNpUnX5VzPdhg0Qd00rbCwrg1BNtte72JRAqE=;
        b=nCLu9tQM1Gi0N5cuLjg2pCV0fA5NvyTMpCTB757u1DyOCDDuK1PabVitTB1rdOiIm3
         rt0ewpGDpsPzhLbXzgi9uTEO0mly6/Eg1j+/esDduOQ9fQpFvrA/f7De1f2UMSZoJ/L6
         7ihRkUePJP4H1uBHI0LZfJ8XR+0K7F5dmELozIUcu652GH1+pf5uGyqGbDPe7PL1raQD
         dOfSLl4hSg5RMm5Zb6jKaUtCTwFb8fMtrH0byLpyd0JaovjAjVAExLMa6sAQB1vZeWWl
         Tk6Or9uTvvcZslP0fVc1OjWA9mJG+7dFZaM0Zec78myCf2dnjXH/b3Iwx2H3qxw9A0qZ
         Y+kw==
X-Forwarded-Encrypted: i=1; AJvYcCUddPNfRug1YgewjoUcfHpqvWkDPVDZbGq/n0/5c+D2l+XbRITh+N1r+TEQFfeqcyH/YQSgyCm5kQ==@kvack.org
X-Gm-Message-State: AOJu0YxixBzCxmVNeODrZfLW7K6ZoUXvS29XoDXDpwoBgk4Hp81T1txB
	wB0IarRcB44JRn6Mgr/XS7KAOS7X7tlmqbsAp6sUV4DqoXbEoRg1Eq3UjB3vQeVgaXOqr41ViKy
	KswAEZTW+zh83MWBhCoumA8YO5um4t41RveE8EkL9BYmaxTKzYy+0
X-Gm-Gg: ATEYQzzrmjWHkZjpJV0F0fy+OghR5Ll11yFyxAGB5HqxBBEA+SbT+7OpD9cA2Aic3NU
	fJB9+twq1CK4EhSv1ABWHslOWxUnsHyurAfW5oAi0HCjcDHB+Ja+2Gwb8oEQ7j+drxnwZBwS1+0
	eKfiNku269b2xws/Rx7dskd7wGbxptGQFexU20gRlnjJmSfgzRB+hw7zSR1sTA9TQ9/jNaN4OZI
	9mp8uWyPnT6TwVblcgt6nY9SOytem4ZsubAbVtjknKQm7F0ge0v7CLiNVX6wWX8ave31q4vSuQK
	wrMBk1P5cYAg3LMEsTWGkkvWM9xrPf3rjhxqnTekUBfAaPRVqVIebbd2ME8JJJ+m+vUpJmCqELn
	VIbSIhqmwCxntBxxK4g==
X-Received: by 2002:a05:6a00:a04:b0:829:809e:897d with SMTP id d2e1a72fcca58-82a1972f06bmr1306952b3a.26.1773367323681;
        Thu, 12 Mar 2026 19:02:03 -0700 (PDT)
X-Received: by 2002:a05:6a00:a04:b0:829:809e:897d with SMTP id d2e1a72fcca58-82a1972f06bmr1306911b3a.26.1773367322868;
        Thu, 12 Mar 2026 19:02:02 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0725e0cdsm4299766b3a.16.2026.03.12.19.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 19:02:02 -0700 (PDT)
Date: Fri, 13 Mar 2026 10:01:59 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: mkoutny@suse.com, yosryahmed@google.com,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v2 6/7] selftests/cgroup: replace hardcoded page size
 values in test_zswap
Message-ID: <abNwF8sZaGEda-XJ@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
 <20260312040627.55257-6-liwang@redhat.com>
 <CAO9r8zNfR5Z3g=SkU9-eEeA-DDY=rp0Tcw8sXKYDpkZtJtQ0sQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zNfR5Z3g=SkU9-eEeA-DDY=rp0Tcw8sXKYDpkZtJtQ0sQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h5JLRb3g-rpdJijzLRNfLhZjUxl4BT3MZ2hhq7aDrzM_1773367324
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mhts6pxjgkehn64816fd1p7fuzoprxcs
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 73463C0004
X-HE-Tag: 1773367327-883937
X-HE-Meta: U2FsdGVkX1+Gm5izs6e7mDj6dHt9XPyNzIzR/8sEUlV9Juya561TeudL2ANHhrGEMUmp/33aFof8x05uDuZGBJgzzC72+gfQjAmKfPZRRm0FpXaLB4IPVkDg9MhkVGw8qa513YjHlohTiMOW2IzD5TSJq1rdeuYC5K9Sm1zsRc2RFSx1UyBoLl5HZQbnssbg5QWFEV9C/u0AcdUqB10ieCJfD1s9FdO6Q6iW3qiWKiDKPAE7aYUMFlCHQZeYpPp0za1R9UxdoL66PeY441FeKLHY+BzagTY1Wl2QNyVwg11NLAKS/A3iSbMY3CM4+UeTM7LAWhuhw7Tx9wGb7Els+lCnCPCZv3gsUdViCVCw+lpuQIjBa2597fEP+hV/F0r3GcztcvCX5a+6nqebwf9milvjUiVeD9qJZmb+MLXb0qR+mSnsh3yTw/25vsRM+wJrIU9eBPH6tuEEEiexe+oxFvX7a3xpfUafXNDJaTD5OtD7lps9/gE/EJGWWr5Mdn2rb5iljwWzdjlPBxGNAi6Im6eksVk+agLrPFVp1sm5Cr73psoBYN3rk3vG7drHvYrWiAloM6fluc9mbhyFn9FnV95Sw8turyqungwLrafCv/HRj/0PwJhKGSYnhJH0aA6svZt/sKVdl4LRQqD5yRin+p0ZeYim3N5lI5R5YDoILdQ72CMnl9lOcYnuIh1qSSxH+xratBR0PsXAW3DtqhVJPZn1SzH+hO1r2OXtYLzQskqDUAsmWOTTxvmfTEhk7ymDPve7SYTlnW1DsckwHoY26Yqj5/+c3NopKwUwE2AMaIS9RG8JtPD5A2Nk6ChcZIG3/O3I/qLPXxJvLFeey/igMQqSpCkfW9GtALF4opsc++T3mqfdxS8Ai6Yec9lqyvLtGd+20ar29lgRhwFshyPy6Y2Keu1VvBL26BHvLKIlyLTS7OH3pWVJU1RUb4l+EzI4uO71g6DSNYBI94VQOvg
 f1tO+oFx
 AKSC3NgxkHtVdq2bQUgXZRE1LCHos2m09+SmCWKXay6I9drNDYG7hfsIWKS3DFmtULlYvZOF7UFDT5ZF6qPabPD1Cmng+yZr8eytAaE5hc9I9BoNGzGzVBKbICZfYAL47x3LipTcPihHNiq0o4AT/1WCwU/a3NYqRlZWd/BbbakonC1ELUN/r4ZwfWGOdfX6GWU6HPsmKLpmhZOTNqBrbHHD8I5lj8AxJnxS7Pu74EROMBBu6o2RcVP2DDOtyg54zUvo++OhnpRwwcTEfM7kaAh/APxUYEu6Ud+3d4CTb8PwrBMM3Vb65jR5PGRUlC10liY7LxNlAgak5590fXh/PvYnLbiYD8DBQMKjB7jk8gj/m8I6NIy16XYLGmN9kZokQI5gqebJmzemCej8wCnUCbBm5XcjlT2zt85WzDyHgF/wi9au8/d2325OxNR8X6MBuxgTAH1bQgR4Dl9FPh4u5EFmkKqgHnPzN9Ce8rRDHOLEhKWFrvcRIwX0jmG99faHnnT/U7c6qub803TXEhb9Rz9gPy+UUfhZ0qC574n+UT0W+5OChHKi60JOmJ9L/acgFM0pi/sUHS5Mkk84SY2mIINbOVsZxtCviNIFjqpSkaHyhi60dK/+8z/EAkn4AlyLCt43ug4W6wQmIEheJHmresTktLfb4lzpGRckue1pw03BJKCCIJXNEfEinTUkshc8LsDpM1CTEMLu1ce4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 03:44:09PM -0700, Yosry Ahmed wrote:
> On Wed, Mar 11, 2026 at 9:07 PM Li Wang <liwang@redhat.com> wrote:
> >
> > test_zswap uses hardcoded values of 4095 and 4096 throughout as page
> > stride and page size, which are only correct on systems with a 4K page
> > size. On architectures with larger pages (e.g., 64K on arm64 or ppc64),
> > these constants cause memory to be touched at sub-page granularity,
> > leading to inefficient access patterns and incorrect page count
> > calculations, which can cause test failures.
> >
> > Replace all hardcoded 4095 and 4096 values with a global pagesize
> > variable initialized from sysconf(_SC_PAGESIZE) at startup, and remove
> > the redundant local sysconf() calls scattered across individual
> > functions. No functional change on 4K page size systems.
> >
> > Signed-off-by: Li Wang <liwang@redhat.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Michal Koutný <mkoutny@suse.com>
> > Cc: Muchun Song <muchun.song@linux.dev>
> > Cc: Nhat Pham <nphamcs@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: Yosry Ahmed <yosryahmed@google.com>
> 
> It makes more sense to have this patch first, replacing all hardcoded
> values, then patch 5 doing the necessary changes on top.

Make sense.

-- 
Regards,
Li Wang


