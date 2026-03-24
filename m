Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A706E9A778
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D766B0005; Tue, 24 Mar 2026 08:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE356B0089; Tue, 24 Mar 2026 08:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECD96B008A; Tue, 24 Mar 2026 08:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE1A6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:16:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B81D5FD37
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:16:57 +0000 (UTC)
X-FDA: 84580855674.01.CD8E038
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5F098C000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:16:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JdKGtXWI;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JdKGtXWI;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774354614; a=rsa-sha256;
	cv=none;
	b=1MnHm0tdoVX6KGH+7S6rRljPlFnlIuJ0kvwAuneerT5FB8rvBzi0bJ3PaFaO2K++dmRBC7
	AFddF/pLlzl70waVRspQbC+MuB5epip52EhrtR8/6ng1YxtJSrS+3Blj655wjukFoXqj9I
	YDT+mTD5Y5bvWJYZKeyaUC8EZ+5YYMY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774354614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4OtOkqE5K1/9sgyu+3hID1K7mKq/H1/ijDAgg14kY/I=;
	b=gYydpSsHb9vzMu867Z9Gly0DAsmZX9bEExtbCCZdJWA8mu56DlkPlZPdcTyzcCGXVa3/xw
	v09kNgSbNvpEvx1OzRPWXTIoez4pYqqZqEVzFxFcCwpu2Cnje9MW0F/WyI5JXgzXxmmuxJ
	hv6YUf7l6JaniFTrq5h6X1fs9U555ro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774354613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4OtOkqE5K1/9sgyu+3hID1K7mKq/H1/ijDAgg14kY/I=;
	b=JdKGtXWI/g42Dv8+lxvZZMryiJMKSueg/EQAPtsA6vTCzcGtT/LKCpM0ehKKsLcwat9ehf
	9uu7l7CBLPVe7rEJzZr1yQJHHnU7HocdFTJ3CHhzWU2ZCEZSU4NgILzclV0uMXBDIN/KUf
	hdISkwR6UjXJx4sZMWATvIKXunl4vEc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-6YKX8ip5PS6_uhA9qzJk5Q-1; Tue, 24 Mar 2026 08:16:52 -0400
X-MC-Unique: 6YKX8ip5PS6_uhA9qzJk5Q-1
X-Mimecast-MFC-AGG-ID: 6YKX8ip5PS6_uhA9qzJk5Q_1774354611
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b06b68783dso26392285ad.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774354611; x=1774959411;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4OtOkqE5K1/9sgyu+3hID1K7mKq/H1/ijDAgg14kY/I=;
        b=n/wwRazUvoG117kfhlgrY75SHsldhyMCuBDm3SYfAjb53cvozUxN7PaGv/aGHeO6j/
         GNB8aEavQbtZKw0afTE1SC9m05kutCW6cXglam9wRin3gqPcZBqm2/TPyFPwfJ/i4kmj
         faXequZr3lJxp4hszc65mITq4Yp6deAUEhpgF4KjD0cCzRUqtjqrD1Pad3Of+1Avc5Ml
         emPq15eLqZ+NDL2fnvOeXeBEtcSaUprExtEPccehO2RyDro2R+PnQVfRjvEx9Pm7qiGf
         16h8vonFDAwg+TR0Iqr5AmeYTTBn+mlm+ugpTwa08ZWE3McwGjVzX6FNMQnRb2Bp9ouM
         E+vw==
X-Forwarded-Encrypted: i=1; AJvYcCU/2UakpDlDgFwLe0szuPWBtm24Na/OUW/J26NcPgI1ijb1ir/2/eiXG3JQ8j0PzsuJ281TvlETbw==@kvack.org
X-Gm-Message-State: AOJu0Yx3DAwD+GvBGKFEJEqwtYPbhnEN4pmUHFsQHBexKxH9CsGSe9YI
	HncFTspmdqFCFQ7cFUJgO2SHnO0O4P7GH8BSezuPjTvP4TNHCs7Valx/ywnBEHdmhWxcKzxyHGM
	H1m5yKlvUzWYx2ALBN9Wvy8VG17BzxoEhMuUpcz/hI6zDEMf+Rpjw
X-Gm-Gg: ATEYQzwfYx2/cIQCU+HC5L7QZ5w7RKIy3liH/TO2HV9SzX9sxkzTUytfa0epqAkZh0e
	wlQuuPTlx8fjkgfk/NNaCePg21bbUASpUsG4iSjArMw3fXb/1AvyRudA9A0OtLOkFhvSLVPlyxf
	iOXYeEREp1jYkQI5PEcRr0NMHGFiS4ZAmWG7NchvhYcRnn3zjHuRAUQfrzR7PLtO3gPkqNoMBy1
	2tHYxO+f7Yf7UJfuLlIV4qEdwJhAX+Og5S12jxUmu8W9padGwTbaKB4KOT0NgM4h+Ys+Y/c6VFI
	T52N4mJrL2W9MHf9blMb7liuPm1R/vxE9wLrrViKiEPkofpN6Qt/2Xaemvs7QbZM5nZkki0QBcN
	g2+QJmGIEN15YYh4NCg==
X-Received: by 2002:a17:902:ebc2:b0:2b0:7e4d:f390 with SMTP id d9443c01a7336-2b0827e6024mr157429755ad.41.1774354611238;
        Tue, 24 Mar 2026 05:16:51 -0700 (PDT)
X-Received: by 2002:a17:902:ebc2:b0:2b0:7e4d:f390 with SMTP id d9443c01a7336-2b0827e6024mr157429585ad.41.1774354610733;
        Tue, 24 Mar 2026 05:16:50 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083656b51sm183313715ad.54.2026.03.24.05.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 05:16:49 -0700 (PDT)
Date: Tue, 24 Mar 2026 20:16:47 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com,
	yosryahmed@google.com, nphamcs@gmail.com, hannes@cmpxchg.org,
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev,
	tj@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <acKAr0TYzuYPxH4A@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
 <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
 <acCyPNCBoTGAJjfs@redhat.com>
 <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DbFRhmYZPAmKpqFZ-oBru7xbG-9SZxqt5-6-In_WWXE_1774354611
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5F098C000C
X-Stat-Signature: qbs46hsdhos9jpoguac9t14mhnagz8f9
X-Rspam-User: 
X-HE-Tag: 1774354614-796171
X-HE-Meta: U2FsdGVkX18pjBaBBtd+OCDBn7KOtFrWjqgQksviehtmwLwcdtiKKuPJJ5iPpUysEb+1C+hHZq9QVEy0W3ebEW0h6wkcZYgdL271VW87GpAxNxNP2KUcVfsD0oc6q0YINcTGiBzgeVIxVhxdWilRR4jv8kaXU1H2l4WdccapEad69i3VamB8Z/T8nNw4qaQCuyyC/ng6DFc31v3i8o+HPTBT/kjlGBi0wDm4yHfUqINXJ3S3zdtPuflZxV6L8iGYYYKrO2n3yNUSgSFZ4wM/g9VqjaPtNO+xilEggStPM2ikfUn4vE6/0k2yeRhQFvCTEafYdXI8n2TFNyFbYSFwUVf2EQbLsKiA4yMAbb0tTAoqzoh8oGmMN+Dv+twCr+09aoSEASgtxj42a7e2MSDtCTc/zr3AmkreNeLAFIGcdM2xPHDidRBGdLwNA3JdA1jYmEtgPMIRNA4TUXLb32gMRVfQ+Xsgnus2FGym8E2S2UBbp+9WgITNPfbrg0ZrE8ZTFAiSeBTWaW9Ni01D2wIGcQPZexlLq0YQdvtYQs9WxHZYQ0H44bMtHlcRc6xlPKVKQmo3EIZPwfcLhumx2iLJu4Of5xSdj3Lmhi5bLcXYKwyQgzxkShGghNDJXo7y4976Jj2DzjikumZV8UeVGD8wzJU10q0bzz1u1Y4QybpoVXLj9Qa3Ff3tBkM9Zl1KSDdhn6Kn8uaDqtp5t1hVBKDy3GsDOqYybUVmmRxIwI8FLQRfqrHcDSE0mpIp111nYM7ML75m2gvcCeyKFxnGqBPzdueYS4ARBpNa57t20tyYF6PKJeDl+Wgfhym352uYfnOM+6KyiSifw/3+JRwFoRiO0ATCkfTE/XDVGmVVHWzrGj4tZE/YliXkyvh+OYP77zlwTQ+7uOBXEdL74YQfzFOTtdlOqDDXv0X3WX0BhSe7bRbfpQ7TDKN7ht4RjwYFEkUWjsp+tAEmMvLaWu6/BR8
 81tQXZhU
 k+P2ZX0rJuM7zj8w0N33/hlru8zQy7fUJxnNrONyj7Fjf/L8Vqr3JURQOieKCEO/PU3y4hyKXkksl1WcDjmI2AWw3W8pYkCEVdX/Q54kLEfyqYoUmR3dkd6MLlarzhFx/8cfRR01DJknYNhRq3EQ34q0VwJPKFIFuUWuTfniOMQUSEJMg7onhw40iWWvJDJ5mxzvBh9iO0uYFk929/ZUs3HXyb7d5xf9UmnuFauqNlcaZGtSUz60YzVl0J7e+kcz3i011By3iycS9XvSk0MidSA9mvAQr8HVovPyfE1/vm42B1AxLy9rK6K1KQsoZjz7+HoaNwXME7cgRFVVNtnQJ/nBHrLUl2qI3/6OPYb4XXcKI5ZJ96go5zt+5+GbZbk6NI/jIz8nIGjZy+VskPLFtIgmNblNNR2wzC8XD3LUCLTdGQNxTgC5XPehc/p2s91sTBMRhgsxt+/tF7KNPaTXxIuAIH5mbPXD8dZDC+Z86I7xOYLeA7nfPabvy7NvDhE+M5NGKW3WvBKCAVcOcyZiccN9hlhO6DaHExB72
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 05:12:27PM -0700, Yosry Ahmed wrote:
> On Sun, Mar 22, 2026 at 8:23 PM Li Wang <liwang@redhat.com> wrote:
> >
> > On Sun, Mar 22, 2026 at 09:18:51AM -0700, Andrew Morton wrote:
> > > On Sun, 22 Mar 2026 14:10:31 +0800 Li Wang <liwang@redhat.com> wrote:
> > >
> > > > This patchset aims to fix various spurious failures and improve the overall
> > > > robustness of the cgroup zswap selftests.
> > >
> > > AI review has questions:
> > >       https://sashiko.dev/#/patchset/20260322061038.156146-1-liwang@redhat.com
> >
> > > [Sashiko comments in patch 4/7]
> > > ...
> > > Could we update this loop, along with the identical loops in
> > > alloc_anon_noexit() and alloc_anon_50M_check_swap() shown below, to use
> > > sysconf(_SC_PAGESIZE) instead?
> >
> > I found that Waiman submit another patch that do same thing like this
> > suggestion. I'd consider to merge that one into my patch 4/7.
> >
> > So, let me talk to Waiman first.
> 
> Probably fits better in your patch.
> 
> > > The test data is generated by writing a single 'a' character per page, leaving
> > > the rest zero-filled:
> >
> > >       for (int i = 0; i < control_allocation_size; i += pagesize)
> > >               control_allocation[i] = 'a';
> >
> > > This makes the data highly compressible. Because memory.max is set to half of
> > > control_allocation_size, 512 pages are pushed into zswap.
> >
> > > 512 pages of mostly zeros can compress down to roughly 11 to 15 kilobytes
> > > using compressors like zstd, which is well below the 65536 byte (64k)
> > > zswap.max limit on a 64k page system.
> >
> > > Since the limit might not be reached, writeback might never trigger,
> > > causing the test to falsely fail. Should the test use incompressible data
> > > or a lower fixed limit?
> >
> > If Sashiko suggests reducing compressibility, we'd need to fill a significant
> > fraction of each page with varied data, but that would work against the test:
> >
> > zswap would reject poorly compressing pages and send them straight to swap,
> > and memory.stat:zswapped might never reach the threshold the test checks
> > with cg_read_key_long(..., "zswapped") < 1.
> >
> > So, at most I'd keep the data highly compressible and just ensure non-zero,
> > unique-per-page markers.
> 
> Sashiko claims that 512 pages will end up consuming 11K to 15K in
> zswap with this setup, do you know what the actual number is?

Not very sure, I guess each 64K page contains 1 byte of 'a' and 65535 bytes
of zero. A single page like that compresses down to roughly 20–30 bytes
(a short literal plus a very long zero run, plus frame/header overhead).
So the estimate is roughly 512 × 25 bytes ≈ 12.8 KB, which is where the
"11 to 15 kilobytes" ballpark comes from.

> Especially with different compressors? If it's close to 64K, this
> might be a problem.

Yes, good point, when I swith to use 'zstd' compressor, it doesn't work.


> Maybe we can fill half of each page with increasing values? It should
> still be compressible but not too compressible.

I tried, this method works on Lzo algorithm but not Zstd.
Anyway, I am still investigating.


-- 
Regards,
Li Wang


