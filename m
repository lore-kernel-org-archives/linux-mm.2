Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33584CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 04:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E47F8E0005; Wed,  8 Oct 2025 00:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC258E0002; Wed,  8 Oct 2025 00:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB7F8E0005; Wed,  8 Oct 2025 00:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5EABF8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:40:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF8F7C03B3
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:40:01 +0000 (UTC)
X-FDA: 83973694602.10.2827667
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2339C180006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:39:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759898400; a=rsa-sha256;
	cv=none;
	b=ef/5BRy12P/7Ozs4Q2DCyzJlznZFwEnuGsWuf+sVyRrG3e4KTgl90S3ykL8KFcOKHA5r7B
	NZsT6oYxiXSsrhTDtzFXDFZ6n41VJzUHma0xZXbVGTZEYm1WdvXVZDKvfXsq0ClILophbq
	zmnXs3Oi7sdPwFrnalLjI+zX3PRh6H8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759898400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Mvv7sSqOor4odYLPDAZ6ntZ/NXZIV6IKoEJT47Ds+1s=;
	b=xnQETlvJjoY3K6/oIMEgqcxQqf6ocC1mP2gD50bJxyhD0CTzyYCVui6NyMXaZvWDxX+etm
	yMehtYgsc56myl0erfUVIwbKbI+iMC/Snv32CfqabB1Pn5l0UK4gqZbjZ70T+7eU1oDmfJ
	BmDp659jTA1IUKCAk3co1R3yV90Mb9o=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-421b93ee372so3240368f8f.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 21:39:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759898399; x=1760503199;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mvv7sSqOor4odYLPDAZ6ntZ/NXZIV6IKoEJT47Ds+1s=;
        b=KWKJadBUfccZqV/vi8oB3MO8/BwqfWJtiswctn3HZ+Py8Knf+qgt80t/MaiQLUstEu
         rQMIXgDcsbEcKiNlUuwi5bWY35TBWtEOIHZpnU1ywQBREneemVxQkJaQEGcmAw8vc6Cr
         tF4fJKJX/G4RG7xJoqaHotnQy1CcpD54K2LjDLOdpFhQtLg0imJ6A1sR974HPB3aj1Cd
         ++rCZbQlF1iupE0wv3GgBERLGz8tGydToi/Qam7etnqK/fFhoabNfbCH2L2koqGrcwo4
         7uG0TzHc8CHSpIUxbFwmcJvZoenF9de0JWGohgjb98LciU2IqQK0RMzxlvcaUcNlt5yv
         Vrfw==
X-Forwarded-Encrypted: i=1; AJvYcCU6i1DzgRiMnVvs7w1NXuu1gGGZhqGdKSvjUezdkt3ZQoujCCtkZ8Ec55K1RWb7jPFluU6YoG3Bgw==@kvack.org
X-Gm-Message-State: AOJu0YwmOJGRXftQG2fgh8S0BXVOMFlcGQNcFXFNgH3wATqx3VDoA4UI
	h0vRX5Xld7mAQHqYgbgBx/Vww+Dtnb1JYN9dLV30GCo1ux7tJIsekelf
X-Gm-Gg: ASbGncufkdj8Y2qsWhiI0UTyIPVH8ziBeHnZ0A10JdJB4Y/eEP4iLBbV60WbMoQyBoa
	V1ybA3pyEVZ7dQnUBmwOvBjtxVIbt4BHrIhGFyIH53JhhRKhENe8NjuZMA2xKPcMTwJbyrjPEwH
	jjudVzIhcym7/4Wvo3iRT+GhVMwppEdJuPwL67hsPZlwJi5G6+DX6xdXkC9r/RjRFtj82nlvjcA
	f1KKOwycB12j77o1QZbq1GpE1OO/nvVMdqeJ2I9ann1RN3iCuUy+gRzftvfb4WCMlpTdSg6cTSC
	y4CnF0MK6Rdk0zBdH/GnHu5XZh+oyk8u4fEt2m1fJj7Mmyw/7P/Vj3otZ5gcyYzAkfRE3whDQzK
	tBXJTE/V+0xWfYvPeG71iSAxCi4comVbpO0JUVKQ=
X-Google-Smtp-Source: AGHT+IHsgqJLs4+bfAfvT/DMNOM9+GORw/CjObpAPKIew63euSQ+3GLqLlo1CMK/HKXVHgHZZ72ECQ==
X-Received: by 2002:a05:6000:4202:b0:425:72b3:7368 with SMTP id ffacd0b85a97d-4266e8e6d2emr879161f8f.56.1759898398560;
        Tue, 07 Oct 2025 21:39:58 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::30b2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c49sm28159164f8f.3.2025.10.07.21.39.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 21:39:58 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new v3 0/3] refactor and merge PTE scanning logic
Date: Wed,  8 Oct 2025 12:37:45 +0800
Message-ID: <20251008043748.45554-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qwumk14zuu4zsg1j789didiaan8jbsi3
X-Rspamd-Queue-Id: 2339C180006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759898399-158212
X-HE-Meta: U2FsdGVkX18aR8ElLdppVaQDiICdPFVAHePtLK3bfurTfbmwrSje3D2NJpxXAzE/dSO93WcDWPMRFtkWce46JWojbpc0cFKFSeu77Yi76VnDKMfjmCfczLw8xu09HJANNdVOkpJvv3qWlMudFkO1oDF8qifqLiIB1w29laglIONKzMlpDDpkZIzvTVNh4zpr9eMkfp4cbYtj4wJX0LmqsUJPvvDXPMJL+jTQqIta2e0eJbdJHyj4ZAeCemuxBsqOdWGXn/uSMmlTGnvnqFU4UWUnKAQy7c11skdr2VRY+Y62sFqjPxBo6XDewWltg9LTtSlYBOckpu2+lzlg3zpNN7UFk9U23g4x4lljIZS5uHMH+++IsDd5BkPYXo6EKRUT4auoXrWKvDh4WZd3yvAbVa2M0hN/eCTcXHhmA+6jZNPN+BJzw5uMBFUUpTXuwey0ewe2wrU98wEOFKe1XofgGhiB7waVURFZRxRlIrYvlnGAJ6tvkiZCbFRztz0JKR5nUsu+2aKO8UzPPCso4K7etdrQzg4X4yRo2VMta/2d9vLef7C/YzXiSghcXI0vgqYjtvYXG/QVrcw7+71xqcUOfe0CWnoxFWnW+baPCEOKEK9J4O9XFVrYaAK+4fLgWqQQhyMvuDUAEffXeKymw9+Qx7UUelwsGzggMq4O4GmtgZqbT/pQdXH9T8cGReQfnTQrIIdOxrzVPMNc65FoCuqUXD18t0xg92No0oO1UKcB2MtFGdwCtByg0KG6w890wQvv7OdrdsG6LDaCAeJCZqz1zjRxDqLWWDuU4B0mzM7V4AgCWPVr36IPiVP6j2vUKFNTKV4m0eFjhy6hKJHeitLTrjFLu5EfxBwW93YpcRl4Z1i12i9CGLFe1XKYTzSa8cGw/RX2F5bvi8SgHEtjU0cIZcoNjKD2s6j2TJNZkoxuGwqprudQWU1Q78ODpCfv9+FaKzwyO0/2Slw4OAHBfjC
 ikZvY3Od
 z8ADyYeZdh5qS70Sf3PwKAKGIn3hAJy0TfZxf9Mv9thHXGXy+EZ6ldilaJ3DdT2uztCwEebvxC8I2S29ErwcAo1GeVx/IIq2TQL5P1c8P6/SKve3+Dz9JrfAd/lvh3HC1d0OUJ1FF3B2sT+8pwepsSw7Sci6g0FWBcY9BFQk63n/eSfSIwwDN2oLsLrFOjQ8914PfdXhFBCDgGO89TehBmWMz6hLXQgHHc5Ll0VJPIi3mz7peqOjooji/+oCDmh8h3ws3eFBc76xOo2L8zm11wTrAt2xVNu2GWwCQKuxTomok7FPqnBcYhUBhmBD75flssXj3sC4etfIiu1nJ5rVJYnBDMWdakv5TZVfVjytpksW2/meqaLImv/Bbi+9qbQWydMaNDfhBhdCdWH1/tEJgC0LVJ79yINZn50Izyg147anNGJWvFlwBOZKEgDNxXFuiUXhNKKhIrRLVeF1oyeLgvQuRQ+A+iVsM0w/u3AcZaSh3/mMfOFn5vKfIktun7+R5o4AyxduC0fXOdFbI/CKnwjUMrP0annWqUA4A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series cleans up the almost-duplicated PTE scanning logic in the
collapse path.

The first one is a preparatory step that refactors both loops to use
a single if-else-if-else-if chain for checking disjoint PTEs.

The second one replaces VM_BUG_ON_FOLIO() with a more graceful
VM_WARN_ON_FOLIO() for handling non-anonymous folios.

The last one then extracts the common logic into a shared helper.

Thanks,
Lance

---
This series applies on top of patch[1], which is based on mm-new.
[1] https://lore.kernel.org/linux-mm/20251008032657.72406-1-lance.yang@linux.dev

v2 -> v3:
- #02 Collect Reviewed-by from Wei and Dev - thanks!
- #03 Use vm_normal_folio() and drop struct page altogether (per Dev)
- #03 Move the cc parameter to the end (per Dev)
- https://lore.kernel.org/linux-mm/20251006144338.96519-1-lance.yang@linux.dev

v1 -> v2:
- #01 Update the changelog (per Dev)
- #01 Collect Reviewed-by from Wei, Dev and Zi - thanks!
- #03 Make more of the scanning logic common between scan_pmd() and
      _isolate() (per Dev)
- https://lore.kernel.org/linux-mm/20251002073255.14867-1-lance.yang@linux.dev

Lance Yang (3):
  mm/khugepaged: optimize PTE scanning with if-else-if-else-if chain
  mm/khugepaged: use VM_WARN_ON_FOLIO instead of VM_BUG_ON_FOLIO for
    non-anon folios
  mm/khugepaged: merge PTE scanning logic into a new helper

 mm/khugepaged.c | 242 ++++++++++++++++++++++++++----------------------
 1 file changed, 130 insertions(+), 112 deletions(-)

-- 
2.49.0


