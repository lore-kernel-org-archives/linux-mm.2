Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2F2606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LeKkS/k1
Received: by kanga.kvack.org (Postfix)
	id A25756B05B1; Wed, 28 Oct 2026 23:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCFE6B05B2; Wed, 28 Oct 2026 23:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBCB6B05B4; Wed, 28 Oct 2026 23:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 687FA6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:05:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF924802AA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:05:24 +0000 (UTC)
X-FDA: 85374172968.28.86536EE
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1D5BA180002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:05:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="LeKkS/k1";
	spf=pass (imf16.hostedemail.com: domain of trilith.zheng@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=trilith.zheng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793243123;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qt+rBjELLMxb0qTKo9uNTiwBY/+V4YZH/Ya3Tn3lncw=;
	b=NK4KbTYKlG8ekYQ7ic05kvVzv6XWNWh2NvBVkL2Q3wMpkViz1ei0IotMF8pMaV83gmU5zV
	11bAuE3T85ochcw4eH+fskVE0RUASOdcAu1NASKZ92lW4Yw5mkkKhH2UqBbmPWwWmpazK8
	N14Ph+xqr+eVEhVrMW6Zd+ZIyeBRXbY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793243123;
	b=tT1AvcONW6pGFSVEJbLRoPYOYWHMdQrgOPjTHEdGiDMVehyTgWahHdc2f/JF1PuZE1wdnM
	nxITloB8iKcjo7YtlRYxaAJCz0ZdspQz5z/T2N2pyM6C1cY+wVO01UvcLRkDE7F83qAOBS
	9TmuMwh3zc/oUq1Ce9AjFKEaUZxCnN8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="LeKkS/k1";
	spf=pass (imf16.hostedemail.com: domain of trilith.zheng@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=trilith.zheng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ae702d28c4so145541a91.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793243122; x=1793847922; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qt+rBjELLMxb0qTKo9uNTiwBY/+V4YZH/Ya3Tn3lncw=;
        b=LeKkS/k15lkmLpZiYC3i4N9TPwYHdYePvJQ01rgcKLIFL/eX4EqAKxbbvX/k9ko2lt
         Rh1tkyXymuw99RkcZZ+NZWUoikRmX/sPrjy14V4eAjTBqftNvgnGlbaftD3B6VO5NmwS
         loLlYP+Js48hsrh4T5fZMrZVdltVGYg8r1oUjxzScS6gi7JpO3bvZCjMBdsxiwGXiRL7
         H2UdzbU/UzRN6NhgVHBkd7twOchY/dgwfWS+f+mdwlc3mLes154FiE+yvNj/eObiwBwq
         dr0tR8BtHWst64hUUU5Oof5BiTQiSrlSHmeDRfOlhCshDcMIjB00E8NWSL25KNMY/Zmw
         fR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793243122; x=1793847922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qt+rBjELLMxb0qTKo9uNTiwBY/+V4YZH/Ya3Tn3lncw=;
        b=1eGm7zA6HnQg6U63aV+K0KzwkN/Kn3OSvnWDXsHz4QhI9XnzmXV7Zjsrd00HwmeKFm
         C/cjJTd2CoXEd2p8o0GXjrU58EZlzJP1L9Q+j2vm953S6A/pw5HgDLV3ZkekTc/JgGgB
         kyTI+hAdEajfW6I/+zxEYt9V0uBXHffDjivGqXc4ClFMqdl43LReKQMf8fXdAJRV06qP
         z2xUl7AsQ/Q0/fbHSd/Xjflk9tJy8ZN4JPs6TeLV+LuvWLVxSB7E/ViS2bHNaH/bZFAZ
         n9JtbuEarfXUWqsOnmk72OUKN6ZdVSnvCTI4v8HFDWtORwmvUdpMRAR1FfKU1fZmt57t
         BqEw==
X-Forwarded-Encrypted: i=1; AKwUvBxbsfdyn1BV7Nm9vyD/odupCFXq4Gmgx+y1C2gKdmkyIhPiuKKR5Ednzap+H1ryOcRw92ru/ahhkQ==@kvack.org
X-Gm-Message-State: AFq9FYKaNfR98NofevOBDANrVjhNCPjC8gNMnOcr4XHj3jdXcD4Aw76L
	7FrztMpo0DGg7yIjbK65iWSSLihAUm/LxbJ1Qz4BkrEei4Ed2Dk4kOwb
X-Gm-Gg: AYBFou3aaVVSo/MRnkSr1JPRPM2nqQ5vlObET1UtgnoiwXFE1i13OsJc16CRXsqKNEY
	QrOxwxcI4cumthk2LZt0V6UahPRck9zX/vRJjac7Kz2//fG6SDAxL6lf5MnbwB8nkA0PFrWVztw
	hTT6EgwjOJxRPvjuypG++5OkRN2vyCj5GwW5f9/E6ufu9MCjrV40VAYGBqs+eBBV7gcGo1pImdP
	ZNt5k/+6LKfcTl0v2mOAUW/WLm5FYbFPZkwvnKILvGh41ru+sPth9Q7wCdJIqM57yIYK63rRLEa
	Ey6/dKJRekU3lUS6DyVkArs0dL/AgBifVccNX72mWsYNfrSgsx5kgxrI+dZ3MnKW6+AToBgcVXQ
	EbV8vkpX9C2orsVWvXgBk6VdNRJWi75S8ydnjUgZ1ryQGImtbuxPX+UlU+g/1ByzBzkxum1o1dW
	OlEw8RTIZDoQUo/hoQFM7TgrLzgQYYSt4e2nmyRN2oFSjlnVfrE41UU+w/E4UUH2LlWrhOay/DN
	/tHpcixVHl974r7cpoKLoApmWQENS/wS9ylbTkjLxlFe9jbCLbnHinTLqj0TO+onOsWTJRt37TG
	yY6QeiuFykykPA6fxrhgY8bTgcv8Tm9+gabuKvz7QpFavyE5Vtz7sw==
X-Received: by 2002:a17:90b:3810:b0:3ac:b08a:ed2c with SMTP id 98e67ed59e1d1-3ae5822fb8amr3357641a91.40.1793243121828;
        Wed, 28 Oct 2026 20:05:21 -0700 (PDT)
Received: from localhost.localdomain ([101.44.96.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9583c1sm1932931a91.10.2026.10.28.20.05.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 20:05:21 -0700 (PDT)
From: Yilei Zheng <trilith.zheng@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Date: Thu, 29 Oct 2026 11:05:11 +0800
Message-Id: <20261029030511.12004-1-trilith.zheng@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com> <20260903122128.12264-4-songmuchun@bytedance.com> <20261027065723.66564-1-trilith.zheng@gmail.com> <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1D5BA180002
X-Stat-Signature: psfsdne7tzhum5dioh1ismobj57x6i4m
X-Rspam-User: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793243122-758975
X-HE-Meta: U2FsdGVkX19sdY3tSroe0qrUWsmnbgo9JM6sP3KcT33Vjz3NCykD+fn7woFaGeuGduqYttbeYDYUlTVtFUJzx7TfgXXZi8j1B/SavaBp/Qca9QHKLE1ICwpCXbMGZubvoTSrNCrv3EntQrYxg4K+9/fXPQ0lz4quki101BXMFrVjjHjyF9k1kR6Vymeo7RDMJoR3TnHyp7xdL97Ox/xY4w4UAJA/4uMHEGeh36WTBb+nliTFRSh82NFvxKCCJ3mEDPsYRD4XaRIoQtJuOGzPmSpi9bHpYanJGdHDXyCw4l3ggLEOg3eJX2G/KQlzmvDr1nf6oLYAkgZGf1k4RXDxlP2aDvT+opfC6YoyGnT0/hfZvbJ2PDXoda51e/fmwfPQcxF/FWTHfsia2qQXt/T0odQ83mG0ZoIomDLVutTaZjoImo3efeAQ9ZrpIwKe6mxVHnWl14FioQ5CwMZDfx3FcWf32/XdL0AzrUvWEAbTfZrcZ5p1+EWqHQARZJm3ESy6hPyHTl6wgSH89I29peNFSHI+u+t1Tqa++kVbnWspncAepMFtBhg/pluMSJ1DAWvvW0I0UXZt86X99awE5qMqX8MogOaUNU1LaLB7y6wIp2Ra1hsNHUHoh2CaSWxFs4ug3PMZquhF7HMP0OpsjqTR1Ti8SvhN2LsftFHL7j1j0bCnv17dr7W9CzzN3pz6ipYGJcaGTmNanj1MWrrt/eMAuE8RljUIrbQSjnZpK3693sCj28uEzXvpbrjcF6mLuETuaMtsS38yE9lk8Kk9V94Dw0S4Bz/kUdoum6zQMAUMRdQRr4nZpOfwOcHHJWj6wnJs/iXLOnQEs+kw9rxBw+jjtQkKyKrH23V9h5qjZWGo18U3AZ2/zFPAfl4I4+7Wpk7LTGPt3uyCpS54nXUmaejPNVXoKbf9+ntFgaoXOHAdPLu7SUbmoG1OWR2IERJ6F8osm9I7Zfp+m5y9cPtIaro
 xCP2GwHn
 ecm2INJwt9DqifDRkCeSs271mfQwFabnLfusN2kTW5Yh2XXJjcS4ORYt5YwKTqntSWPCuTREhZFwK4woE0//ycnlsTSTIJ1o9VFdtPew43ANL6qp1OXA0f31QeSWi/zi87ZApwjbkFctlG/2owg4m2wCZCh22t0T3PaYqNku5GHAypILV45Ry5Dpt05+j5Ki0HHuQsaFMzJIY4Dt0lpiEtkCHruJqcicxsOfrgfFd7WzRa1qRYWT96OArNJQ7Hi6Oo1wOxVtCYR7XSpWU08ffCWP8NwvQMp8vEG51YLTyqs0rI7QiT9XVyRINt3Jc1loS7+JSBvbVVan8pVPetPHGHP3ZUX+yOGb4bymxebXxSjL3wembKVlQD8E8EL8laT1e4Nw9PUBUcMl+SeH2C28uTKUUTmB2fQE+c/yt2bPp9ghWLpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

> Thank you very much for the test, so in your scenario, this is also
> the behavior of your real workload (mainly read/write-based, rather
> than mmap), right?

Yes. We mount read-only rootfs images over virtio-pmem and FS-DAX. Most
file access goes through normal read/write. mmap is only used for
loading binaries and shared libraries at startup, which is a small part
of the image.

> To be fair, it does fix the issue, but it's not very clean. I might
> do some code cleanup first to solve this more gracefully. I want to
> move the initialization to where the template page is allocated,
> similar to what section-based vmemmap optimization does.

Makes sense. Initializing it at allocation time is cleaner.

> Thanks for the analysis and suggestions. However, the reason I
> haven't sent out v2 yet is that I've been trying to refactor the
> vmemmap optimization logic to make FS_DAX support cleaner. I think
> I'll probably do some code refactoring first.

Understood. It would also help if the refactor could support subsection
(2 MiB) alignment, so any 2 MiB-aligned device can use the optimization
without padding to a 128 MiB multiple.

> I'cc you next time if you'd like to help me test.

Sounds good. Please Cc me when you post v2 and I'll be glad to test.

Best regards,
Yilei

