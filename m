Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC171061B12
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838636B008C; Mon, 30 Mar 2026 12:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810AF6B0095; Mon, 30 Mar 2026 12:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726786B0096; Mon, 30 Mar 2026 12:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 604336B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:11:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15E63140653
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:11:01 +0000 (UTC)
X-FDA: 84603218322.01.E9C2CB0
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id D9C031C0015
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:10:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=CoFherqa;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774887059; a=rsa-sha256;
	cv=none;
	b=bGM8Sjz4IKaMeyCsuSozt8NkM2Ef/BVDjKBXhDcLylUTSOqZg1pacA3FKFfhY17T6Q2FQ9
	uWfRj25tRziJs4JGFu2SDH+fHMpfgzdm7CUEb+vB0piDspr3XmMXvXhuWU+X3y2SxgNZkF
	cCxcjcyWkVhgTKo9qR6g9Wp1NJyli6g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=CoFherqa;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774887059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9eg20jGYaatkJRZTB92X2Araip8YA2EKm9tEKL8B00=;
	b=Z7HA8783VQ8T4Z0dW3E6a+vVkwbt3DC9UolgBoEvZCHNZWryVftpPslelAn5b/HV1DDbb7
	fvH6Q03S87k6bgXz9f9DIuTQxQijoFvQQSzHTfCqQR8JFyaEPbV7hXQyL32Ecfk3xomOjO
	kj9ngFwQoqMSg5j0Qgki91RXKoXsyhc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b23fcf90b2so25451555ad.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1774887057; x=1775491857; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9eg20jGYaatkJRZTB92X2Araip8YA2EKm9tEKL8B00=;
        b=CoFherqaH5Bj6r1/yiwtNMZe1Y3bEWdllshvZjR+QFG/zjc2dtmYSp4wW08Br7IniL
         M47GnjSYFdT7+s7JJ/4gLp3yOJjVg4tTzr3MikrQQ0BguWq/jhizEqZ9AN4rAvMaW2B9
         umjRCJ5KbAC/8NAlG/kGbeJQjX/hiIsniQdz0EFnVGqF9kI7bUBLw11bqeGAtIoeWS/X
         E7sG2ilqVmC+u3ioZbojXNCk3Yr6l5mvFjkkKDO8P5gR5jQnjFNdhU8kjBNRkqNcPiL+
         XePnp652yZ9ufVQ+90z6zDXtcsmKCZEG2eYcZHUufSuHWaHvclZpnCN21FWG9L7r1QLC
         TWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774887057; x=1775491857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y9eg20jGYaatkJRZTB92X2Araip8YA2EKm9tEKL8B00=;
        b=H9Us/QzJAK56QKMb6MkqSaYNtkQ9pjcQheqQDMT6FCHSM0AaOI8BKRW1XE0AB4W3wL
         Axtz/ssybB+OUX24rIpvtVpUpHyOEjEVXpDnDdROahw1JYWbgCJ8ekmTLAy+jgaxh2Jr
         SeVlYQcBT/WOlKEqpX6r9SfCZePbUIWGVhge7P3GsajYn9ZoqlLKBN+rJFZ7B3DqWehm
         0YY+599gHUfUZ16SEGP7jTYhPd6M/3Dsyw71b0DIYnwn6xEInFMqn3N5RG0VR2xTdNzL
         a56xzyRmnV4Se7AEz+Elkgd9gZ07duUTHSCMxVEWTZgp6Ea/Mdy/InloyKR7x+k2uiNE
         M40A==
X-Forwarded-Encrypted: i=1; AJvYcCV9UdyFthtkBLQtUaM5lPMDhcbC6WwUUEhnujuPR41cRnuSnahdXx2W2NwagNLWiXFZB/aOzbSNGA==@kvack.org
X-Gm-Message-State: AOJu0YxDHLngw78AwtZQoW6a6un5yUXrquf/r3Chthsa0TMtRSzJPy39
	Xof51eUx+8coo64qPuW/AfvbehKViWE+X2fa796OUnZO7FZ9/gx5RBb3gflHkRlHjDw=
X-Gm-Gg: ATEYQzy97xMXZLnGtLmI0bGXTICYFVz5ETbTNYav6YLa0xlSFq1f10TkgQlvvOVoi0e
	5xpoYEYxJdZR9jfEUNK1EOSwKZ6hZnKm7VpVXur5Q7eQ9T3cIdHWzYhiGdHgVN1rXoBPbR6Q7G4
	f/QiL4WUJiuU6jLa0Nl1M2OPu7+16xhtbB9kGrUPazPKMLh44JKLod8mA7GU4hV8+9KiASdGvSY
	pW+vcf0DDH636iDIwXX73xW4gn9gQ6Ly8c+jfeowwGKpauMkEFLHJ63mzzQuJPfwxIl4lnT1K16
	SkDtSHRA5Dbzvm87IKycuYUEtT9WFVEaWrwTFa4JWTb5I1cMhjllMxa0ulaPbpiU0Xce0uU5Mf2
	/5nILiI9xyRk4WynDzC6mXNxmc6yykP0aGpvPCM8yAbCDmaw8Bm/NCzZ1rOh0Sq2Zrwr/y11amn
	Hp
X-Received: by 2002:a17:903:1a67:b0:2b2:51e8:2c20 with SMTP id d9443c01a7336-2b251e831bemr51399275ad.21.1774887057296;
        Mon, 30 Mar 2026 09:10:57 -0700 (PDT)
Received: from gpc ([2400:8902:e002:dea1:c507:1213:2c85:ae99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242642905sm110979985ad.17.2026.03.30.09.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:10:56 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: ziy@nvidia.com,
	ljs@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	clm@fb.com,
	david@kernel.org,
	dev.jain@arm.com,
	dsterba@suse.com,
	jack@suse.cz,
	lance.yang@linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	npache@redhat.com,
	r@hev.cc,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	songliubraving@fb.com,
	surenb@google.com,
	vbabka@kernel.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Tue, 31 Mar 2026 00:09:42 +0800
Message-ID: <20260330160942.173324-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
References: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9C031C0015
X-Stat-Signature: g3cwu9fyjpoxq6tqj8ia9z5sswomhrs1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774887058-28730
X-HE-Meta: U2FsdGVkX1+9FlTWRL3/TMHhUApjsJZtVbmqEIhYpsrTF+8ChBU5VcovOolZTNy+1rDHGcxBsne9NP+qUXhyMyThiAfFDuCAVLtzpii09gaMadkgx3GXJ2ORoKw9Rb5CTl+YxQrwhMXH5s31UNjYOVbVpK2wdpYxkHQQPasAHqsqKh+bU2pP4Ha8fZKFc196mQK24fQBKQkh5rSDk+jRo2DXKGecKQdMCVjOR7xwgBLQOE7hQHMyYIAwmCI390CxMFFNE04NWcDuIcv9zQD23njeBKex7rLYMFt9jP/rKcvpuN36yjp8EeAtZiCYDACm+54B8nkh2xQDrmL1ujUB598YnCSHpt0Eum7ttBJx3qziqhAKDPBNQyzgKmwsq/iqtjY3ubJd49OToMOCvY+qAfiEPR+qJhVu33zRWslbjSgrgX1t6063wn52/NZncv6rbjMYAALXIceS/CDLFWqQzw1waAVZfrkyDo2icj9RNV44PzGaxhCyPSTIciI9EYfSszPkhtuajWJFXph1QCtVDudtI3c5Y36wuAgubM2Ll2rR3FyObFBcwIBG45X/hK17Ym1fh5bT70guAh1mDOA6L0NB+DlVfCpdwlqDf9ubOz/LCzceH/1uc9fJbr173wtQ+/lPZPq5md/Q+SJ6A+Qtm+DZQMdq6fDY1xo57IK+HC0GQhhH8bA41RdKtunpds+w14f50f5l+XI2ckLanxg422K4aaN8TKqRH7JSNeb3LU7JedC1IztOBhKovdeCi7As6kkFq6B3Drxy8tLL/DBK6bXXLENkG8rRMHW3oHqUf3EcOY2xrSJDpBhudCxEk9PxhEulA+AU1XzOBKOGsC4LNa0wYLHq166GjjjEhSGmyTcP80h/Ls92BlL1tnGLy62gMvHMcKmLHnkXWKzbi7gOPIQZ2swCedAL37qpK6IAukdCS29GDR59nOweYR3TFWPcQpCvY+KvTJ7V3oCIlvp
 gsMnEP2E
 UzzHCgjbagkdbXfZmeUR1xtfVPb/ST6F9najd0HIzNxBIPOgzVi8hgZo1grk+qUmPBTPZW4dZcwojdhkOYjSNPqX3D3x4MRH3CKKBk5iBCTw0ZJzedEiNzx4R5caoMxjD71hqzSNY6cjUUXeyv/d61eIzPXPDbzqJqqgRS1T7kXQdlzYHRLXOtJIrXHhT8hTBHOroeCfKnXpy5b4UQgZx6U9UqVTuZGJcGLqw5nFw4kEb+uDeFeTzZN7tEMKFU2BX9UkmWkPx4MSVBZzmD87o9LvbE5bigG3V0WyvnMP6Mq3fYObP27d/5IOmcg3ughqzPrKZhArKXgDT5ne/SvFIrxvRK9SDdGhVOO4NURfdNnXPIMoTPaEfMOCE2Zr0AWOwJYA5dCFNtb4FTSoL8kn/MSWNNbKq1BkXjzyJkvmE46WpSQV5HeW9gmh8nEQPwfe4fV492OqwGOiXB9SWvXacYXiYPtET7obhsgcRk1jrY4Bjylg1387HlkDgknnydGuDGIYMgqK0IRuP5a/2Ou3esHht26Geg0qJaFOYaFjHTY6Xaddwon4ZI0HiF30jRUkawgKZorjYIxsGWRmo7NcSq3ZeKGqs1qSlmzBKFdunazv3CPEz5nyJKAldyjC9nbhiunuTyDf76j4K9GuzGh1CD8ds0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo and Zi,

>>> Is there a reason we can't keep this hack while continuing to push filesystems
>>> toward proper large folio support?
>>
>> IMO - It's time for us to stop allowing filesystems to fail to implement what
>> mm requires of them, while still providing a hack to improve performance.
>>
>> Really this hack shouldn't have been there in the first place, but it was a
>> 'putting on notice' that filesystems need to support large folios, which
>> has been made amply clear to them for some time.
>>
>> So yes there will be regressions for filesystems which _still_ do not
>> implement this, I'd suggest you focus on trying to convince them to do so
>> (or send patches :)
>>
>
> Thank Lorenzo for clarifying the intention of this patchset.
>
> Hi Rui,
>
> READ_ONLY_THP_FOR_FS is an experimental feature since 2019 and that means the
> feature can go away at any time.
>
> In addition, Matthew has made a heads-up on its removal [1] several months ago.
> We have not heard any objection since.
>
> It seems that you care about btrfs with large folio support. Have you
> talked to btrfs people on the timeline of moving the large folio support out
> of the experimental state?
>
>
> [1] https://lore.kernel.org/all/aTJg9vOijOGVTnVt@casper.infradead.org/

Thanks for the clarification.

I fully agree with the long-term direction here. Ideally this should be
handled by filesystems, and mm has already done a lot of work to make
that possible.

However, in practice it does not look like simply enabling an
experimental feature is sufficient today. I did a quick check of
mapping_max_folio_size() across a few common filesystems, and only XFS
consistently reaches PMD order under both 4K and 16K base pages.
Even ext4 falls short under 16K.

PAGE_SIZE = 4K, PMD_SIZE = 2M

Filesystem                     mapping_max_folio_size   PMD order
------------------------------------------------------------------
ext4                           2M                       yes
btrfs (without experimental)   4K                       no
btrfs (with experimental)      256K                     no
xfs                            2M                       yes

PAGE_SIZE = 16K, PMD_SIZE = 32M

Filesystem                     mapping_max_folio_size   PMD order
------------------------------------------------------------------
ext4                           8M                       no
btrfs (without experimental)   16K                      no
btrfs (with experimental)      256K                     no
xfs                            32M                      yes

Given the diversity of filesystems in use, each one requires dedicated
engineering effort to implement and validate large folio support, and
that assumes both sufficient resources and prioritization on the
filesystem side. Even after support lands, coverage across different
base page sizes and configurations may take additional time to mature.

What I am really concerned about is the transition period: if filesystem
support is not yet broadly ready, while we have already removed the
fallback path, we may end up in a situation where PMD-sized mappings
become effectively unavailable on many systems for some time.

This is not about the long-term direction, but about the timing and
practical readiness.

Thanks,
Rui

