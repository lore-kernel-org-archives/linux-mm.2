Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8B1C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAB46B0088; Tue, 29 Sep 2026 11:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BE86B008A; Tue, 29 Sep 2026 11:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B096B008C; Tue, 29 Sep 2026 11:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8D236B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:59:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58017160590
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:59:23 +0000 (UTC)
X-FDA: 85267259406.28.0EE6EDD
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7077840006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:59:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="M/K9X2gF";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790697561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3j1GsvDFG4oGBkWvUsNYUZ4jWPGCGdM9fhJMq32ExyQ=;
	b=zLxT0M7Lpv/gWHmYhj8an9rLFxdfLwTTC2iXpbjFE30povq/EixzoGpxQuNP6m2RcXmiu4
	Z/PAtvIuSBXQB+Fee2rXTH5VCW8xO2k4JTGymUY9OT2jhwH6EIiLjy8GP40iE8fGP6mZx+
	D2toB8byulVlB0hWEkos9R2+aIV1dtc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="M/K9X2gF";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790697561;
	b=0ZxGg3AYIDNuri8seQpP/gHvBWBov+4IPkxFv3XrGEXmg2Q0sA6C4OKrM9R/XsZn3vx/it
	zsmmiCBOcL3SRPdQu4IKDWou+djfzovt0i4nC9LGu8+HKdHXY0fEQAM1zIEBskwdH3s1zH
	l38K0p55u8sCgSoU4JMF1mnj0LKL080=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e66390995so24796355e9.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790697560; x=1791302360; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3j1GsvDFG4oGBkWvUsNYUZ4jWPGCGdM9fhJMq32ExyQ=;
        b=M/K9X2gFNnHLAoI9I/o3iMwngyNCqqx3iKrv3bnhYu24ZBv7fLoR5bgzVxXOIPnG8F
         BSccg9BUbh1KuxStCARDzTFIbLQh/agor9W8Wq2DS4Y00hDtRlDBIH3vC38DQNQxBZLI
         DbgcFOYR9hdCHk/n/3gmieooekBcqYuW/r1aSTHfcZE5jBPi8+CHXnhFYHmyOJECnSbz
         iBzF3SL9HTp1116fTGZoftwdce7QY+DYQ7Xw3BAwDKYj2ElzjgxZrPF9H5eTKweOTa9K
         jXuT36tjVy5wi5cMg7fKC+KdpQIJ+ehr+oYyAtRqRxfSQbXzv9ZZ3FVlRrgUBQvn3l4g
         dtHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790697560; x=1791302360;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3j1GsvDFG4oGBkWvUsNYUZ4jWPGCGdM9fhJMq32ExyQ=;
        b=XNWAj7O0M0hzFFFi7p2sEDwjrGb1sQRMjlxkkQ812Ol9EAafKbdrNr43xmHKLGs1zF
         7MGTFof4a/qZS/At0pl/QjrrS5YrLw9HnzroxL28KLpNwmtwDAhx6ZgsCWgjHF3qvzCj
         gVNcvEEwvspKEnrRWqFawGM24EutbiqRXScVY5ZrkkWHNsg0+2oF59N/1xSmFgcTOw1l
         a5X77cOKQJCNo7FTBVtvN5iZD2WLv/p+Jq/zbZvwvGVvOibIyJzTJXBHGwYbFpALoG3x
         1hFQGEzjbziiWYgjxtBF3lj2KGL+kOT+9KELii/qeCq8NQiQD/3xOUZ7ErvwMZQZdwYc
         kvsw==
X-Forwarded-Encrypted: i=1; AKwUvBzOWRrkxfAxYQiVRapevDzS144KiO6xVUtvLr1AGOkGmTNdvyVS7TZ3G05wFylXa4UFp8PF6rI75Q==@kvack.org
X-Gm-Message-State: AFuF++nOrrSHqLhKPjWPwMEBRi2UEDMX+osLmn8i8im+tN1EROyFwYju
	tdIWdpWaFmj5dMhDb+X9RwZ+kk6NAhsJP3+DIGM83fl2iPpuz4QaLIGYb3ypiyi22qY=
X-Gm-Gg: AYBFou1jTvIP67UDZSCvCbt8gA5br+1Ft9rM28W+LZrOKQVcK54i8nDLEaogoNJiOv/
	E0ag717oGWYo6bw9k6SpEyUsGZ8yzzW4Srnx63XdvmOhIMOhkORtZnFz8SdTBdLkYjbomYXPCtY
	PcgQivCZ32gP6oHpHinndZeQ2SHWb4DBr1ZiJVG4aRRZNtbvi4bBpg/H3wgFkAxcJEKX/vOIX2s
	RrjnM+YPqLAR1HwaIyj8GbAf7phadR4cTkn3HymZdlPKGT5Tg4dEKFw8LUeo/8Yvhe4CZWMA4H3
	QUgtZ2iTw0A/xH3KMlQ9ZrthS+tzAyFfOGnFnvhhK27yCNmAoFD2ohjB6oF3m7ucgscfO20CQV0
	gf+3+qDYB8QmWVLQo3OFbycDjqPkmmWVEnxA5EggDN5/fC4BycvYpQnUDR8X+4i+XJxuZ2DmXKT
	OmcmRJxaoojvpVIRSryssH7RDnTo4mFEU5Kq9uaTHeui9Haw0BGVXMDsqz+Uf9r/EgAg==
X-Received: by 2002:a05:600c:46d4:b0:49f:ec98:f030 with SMTP id 5b1f17b1804b1-49ff06f839dmr227620145e9.33.1790697559827;
        Tue, 29 Sep 2026 08:59:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::5:5c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a013c6f295sm7062155e9.0.2026.09.29.08.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 08:59:19 -0700 (PDT)
Date: Tue, 29 Sep 2026 11:59:17 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 07/40] mm/vma: tidy up map kernel pages enum values
Message-ID: <arvgNTUgcO0nPh-V@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7077840006
X-Rspam-User: 
X-Stat-Signature: m1objj1p7n611i3sxmi6hnm86nn9bj6o
X-HE-Tag: 1790697561-209394
X-HE-Meta: U2FsdGVkX19gCP0kxFNHzEgbi5CXjZdjfRSciShRlyHD6RE7M+VZHGPcxfmMBdyRtHbMKdbZVVqrQLaiIZWgO0I+MWT2tTLN3NpIrn5bUFf53qbPV6sjUQqG6kTQ9vmUbWeewOQGNrMxNN5vPuCohv8E/bV5lk7NnaXrtV/cj9+kEXLCYrN6plEvtE4I3um0T/KPxGmtae+eyxzPq1bFgmuy/vaSWQAhyEfbVHZ/iS/d2GUDTFj2N8xjDGBcLXgGi+IWEYg1d1rEkoGU3xq1psJ0FBRCD0gP6DYLEJSEfnT6Swklk+Mi0cODU886tuLf7Iqdm+ZYLhM0JALf0dAeVS2S4kZhI5SFwOjoH2dFOiJTWr/sTudNmSyKas9oM2dK99E8KsQ5nKH4zSu9kcKPtUZTmYkbgXk1hx8Q9VQkFR36w6KQq7hN/yR+k+LnW1mZNIV0h6SJjkOZ3HqVfszyEfsfh9AScp22p4fRX3NvWipCQfXtX6689eQaYjygceMX5ao0mgdwawb/dz5qySb8YdOv1jaDB7q/NnHT4tSBSmoFzRVgwFR6i4bRrw4pRy0ImYKbPXVxKaqFe+UR+vn9l+dB18jTnIVtCsTAyqAtrp0swkEdMnThHE7zwd+WdKymhsZk3Bw8CRP/eI+Bc8VoyGSCbjux0hUt3kl0XAtU3RfkGSoigQmhuNnrYPJn4fL952pxe1QWVsNj8WpY+rVZKNP53DHx9YwaqSFwg4VRJ3FQEQ5DgpxoxSPlxkPigLHxlrx9NM10fy7BNnesQBirkAdC+bmwsZEDAZjpb4vb0GTbvrXYRTA5fQSrBdjENQ7bfRx+Tie1x71yuT4SeTZrZI1GD2acI2CphebAnfgtJNRRNU6yYhyac+G1Axx9E7TuZMY1aerw533cNzg5xK0yXSPan4CnZACzJG1WZJhw0o4Pxj6MJ1UsNwecKn9Axe7IMmB50BnkeJeeqaPLPwU
 HAs19PJd
 UYu30dSc4LnKjnSjiKrfLziwzjJ9n2i7751bepklqBf9PgTOIsDW/f0mU2rXe1jrr6/n6gwd8vhowV0WtZ6XYZU2RtYZ+4MO8EhVTeksyY2bqjLhuWMRQPLXqm/Jj6XLOlg0V+aOY1qJDJxoG9HwqP4dBTUk4L2dAA/O5PMoDrgB4jg1tu8E8YV+TEKXZMb459q+KKZJ4Shu9I0NQrZtnV0T35Mv6xOFv1hX3eH7FUEEIuqCmk1D+VI5kDtEy8BzE7zlmHF9MrJIgXZcP8rPyg00JGVEToDWPlK1tiOoWtjSrXI/XbRv6+Y2e6w7u2ezIYdIDJgyAfQLHbXL6fvf/Yi0oVeCwFOhYB6kUc0JlEFV+WcdGJaHMNN5fx+hKurdRGYLaLLxfxVSOnNk4fOJTY0vhJUO56GotGROV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 05:22:16PM +0100, Lorenzo Stoakes (ARM) wrote:
> MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
> MMAP.
> 
> Also while we're here delete useless comments for mmap actions whose names
> clearly indicate what they are for.
> 
> Also update the userland VMA tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

