Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D266C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8973D6B008C; Mon,  7 Sep 2026 06:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F8D6B009E; Mon,  7 Sep 2026 06:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC0A6B00A9; Mon,  7 Sep 2026 06:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9556B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:57:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1D261C0066
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:57:57 +0000 (UTC)
X-FDA: 85186666194.04.EA2345B
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 342BC14000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:57:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lcgx9DC3;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sJLnGW9pcX8j15B5/bmzsLemLtVeZ3mcxy8gd7OV26o=;
	b=VjKiwvewDsBb2jJEfziCMwdAegSNEkXgI6ewGvuSw/0LHPPuseLAAshOKMGvse0Lhm6as6
	Rs2yu53hv24MsbQk67X0It8kKUxfgB3I78hYMS5spLL5lE5MM9txUKeAnbYJu4OhlMktH+
	3VJs2V7p3u2AIZRZhUSRrnmLVASUNoY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lcgx9DC3;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778676;
	b=X61/P8LGa8M/cATiOC/XV9G4UuWr4rxHW3Uk66zatpyn+1hgfRF/1p7eUuQrlMJOC8DCYe
	0D2NpPqqBGaDLQzm3fNFj2CRsgUMoK5Iq0L+JdnagyFj6rDkzW5lhP7eLk+AfiJ7CkmFyZ
	DZO5WfjgMR98qJ4+vV/ANcTrQEAeCbU=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so2741512a91.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 03:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1788778675; x=1789383475; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sJLnGW9pcX8j15B5/bmzsLemLtVeZ3mcxy8gd7OV26o=;
        b=lcgx9DC3rjoGVYHEcA14f20TUlbTvt5WsWaJ/AdMYMwbupIdZjj0vISoiQFsvx/Mez
         XpCsy1PpjtvV/7aMBCVRe2JNqEaHp0EHlXNbVyf0nzAHTfvZu7NBo2OwOmYio7ABT/gu
         tuNaSD8iut/KVfuQv2dOc2aPR/poyMGcTsHEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788778675; x=1789383475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sJLnGW9pcX8j15B5/bmzsLemLtVeZ3mcxy8gd7OV26o=;
        b=dzrHsyEdCpQ6Wa33v78GKgzxW03rDmnerlCsOj/321cso1IGHcQJvG998MdJktGs8a
         v0Zee/PcfuTIcGmMxiw1v1yK6LIbxj3khtaq/SaMX40kkmU5R4HDSLEvApxSWcl5mPVc
         tZfcNjtDUTqUEmfi2vbAwFEOa+uA8Xfwx24xOiFVRq8qLL9bJoOe1/+rpgA0hP3GR5Ne
         Tb0nsTvZVP+I9+wFMy4Wos0QdvrKGRPNGAPdYYwut8MgjbeX9SeQf+Y6WowyGMP+GHFp
         n91ojLl9gGGrqoRG4B2rJg5HSoJ/XynjLHeL+vjsYXkLTzoFUcv/WEa2zVOPjwwejKW5
         4H/A==
X-Forwarded-Encrypted: i=1; AKwUvByQconDyH5e8/0Okk4qG4fWDWkAxc6j5RX7KYHVhZm9rnM23hTtDa6wANZ/tAyJdW6+E1zPGpJlDA==@kvack.org
X-Gm-Message-State: AFuF++mptqPEgdgbegXRPr3tcoi3uA0mDJX9J9IKVSJjgZzki9o0hrjb
	Xe0za/aTdQvK6B0MCsAY4+UxVE5Wdh4U5vYY/XG1zXvyA72rjlgSxDUJ5bNK7B9QPw==
X-Gm-Gg: AYBFou3AojWOURKUk/bdtUWbk8t22xNdLFCFLzxym79rW+3xiOY/D+SR3NHyeezvTWe
	BB8E/nn1xqOcKQse5nmPVNlf39Sv3DE4/Kb+DbncZ2JJ1A6gpf105ZetPSaCPnJZ6JBXpkwWm5o
	2Y4gy6D9NCyVwvhl/U6Ngbgr53Ott/1EBgJTDO30MJLgk/Fb0+9/dUVt9+nS5nphxW/n83YPzBJ
	dQNX/JYCKqNYLJFIKKcdK8CdvuyXDOyHwy73jpCC7xAshZYuGiq2pcK4FhHMjQiBfZ0m4YTlOgz
	q790ppyBnRaWMTIh6fHcIjP8QEarmuaMqCb5wCkXOaForvhviJtzQ61OJCMssT4i27OtDX/YHcC
	Y8ecFL/PaKqkgDTQX7fQEWDkU2ym9aoU7JCUptlAbM8szH6AQ5BtB0lKhI08BLYVsArxlRj+GtM
	/AonnzgKtZpTZ3CB6Vvz0YGUjWhMNanjZNDlpMW8SHdHIaEJguBJOlMn8mnf/ywGMhjkqXHQTJ4
	Cs11lePTpSGjp0A5kYHTogDad1gJ2iE10+S9SGC5GJUcauMTEnlzQ==
X-Received: by 2002:a17:90b:2f46:b0:398:9c39:520f with SMTP id 98e67ed59e1d1-39b261e763dmr34448742a91.15.1788778674947;
        Mon, 07 Sep 2026 03:57:54 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:7fc7:d8d5:4877:bc3f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b51eb40e6sm10343714a91.16.2026.09.07.03.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 03:57:54 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 0/2] zsmallc: remove old object read API
Date: Mon,  7 Sep 2026 19:57:27 +0900
Message-ID: <20260907105739.1793316-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 36zy8eqha31ww3y9tegnc84qhfudptcu
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 342BC14000A
X-Rspam-User: 
X-HE-Tag: 1788778676-277428
X-HE-Meta: U2FsdGVkX199DXarmNirD+8sAUbyYVBRg/9H1RNIF2TpJmGhX4AKkdViA4z9/j6S3C8FzueJsW2WUO/skWTH5pDWXaE8vylso6o+gLA5gV23Fh5hjmvBYM1kekN57o9pD1nmcQ/iY2NgfC5lC5B7ywxjWL0ZoSLyX+TkbzLwrGtgF1CjWs4kP7DtQPGDez4z4x+75ApCidOfeORYOe0i3F/3mNo9chJByMXICn/M5OSNdbvVuQ7z7RUmCVnOSXQlmdXPidzZ4ERyfGS3KMlngSmcstNB9UyHHNCX5lZdrFo0cAQf4BzlElEM/yXsQrAonou9kcCY0fjSVZPk1UB+EjRPG4r9xlB/m5KEXU2fYhloG9bS9saqpDlLoqs7uZPDfb3vybt3158h5LslO82xKJxMjVExSHtuU0KZP/wuCuKMX0Qey7FXeS7QNsux7JJwjXj4ZLhdq3ZS6KVPWR5QiCQm3q9o3WM2Y4vytapWGl+OniArfnCVSArbO5n//ViRb3YnJYQE9WktIDST76WFYs0NFzscJnLJYo/FWGkx/n1KY+YV8kP8QtGzLoNVEUmzWoN+vVvIr91tWhl0ry5fFav0jklztIyTLL3BtYEwpFfnwWuXejiHBGqinM5/89zc1WVQ8mSd7D9AbusYRt07qaSJyakPWBIbnAGH6uxSsgNBEwOVIyrT0O+1VtnZpsEyzxIXGLd6QFMOHODxnADewwxhPiCtRKQ9r8TtkXQvbihexLY13MosPR8JofDRHXwtHTLhayvYUWiXyeHTrfUCf8+ala8eyDUQjzvYBmRfE1Hg6uxoQsX4s2clhIfYDBsIQ7dc0pjJlL1wtZsZPi8cihYkjJoKn3zzSz20WUvbPEx2mt0S6nLiy+Ahy7AP+paGl5jw1ygQ+2c8k9hceJRG86EOtvJb7x6OwjEUS0e5OxH9dQpC2W29wx+rwOgiFejS0ul2jRok/z/Dd2D1YGk
 Kvri1LJo
 DzD1PU4T7e/d4enfSpOt7jH8g2N3MvC5geRyWatG9WU5wrHg3JD3LSL1GWQCpdapWnkcxa0P8cc9LFjqO6+QkuPYox+bvTrTaXECyfdLLR8ko8uyzSKQ18qZdU9HYvoA9CoUaIa3M9ebwqh5V8AB4F+CmX+nnZNWyTbQtXl3O0RtJd0OChSivuFPD2dVfyG7AXXI3Nck5kp5GzZXFw7iTRGLQVyjSoSpKUs9OD7OBKoxdf0ARA/qqCijlgQJrWFnsKuXWhcVV/tdQNIJTQNIi7qle25l6VInvTSEgyyly21bAckEo2suKojZr5D2Xajq0BCvl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zram reamins the only user of old zsmalloc object read API.
This series removes the old API and converts zram to use the
new SG-list based API.

Sergey Senozhatsky (2):
  zram: convert to SG-list zsmalloc object read API
  zsmalloc: remove old object read API

 drivers/block/zram/zcomp.c    | 23 +++++++++--
 drivers/block/zram/zcomp.h    |  4 +-
 drivers/block/zram/zram_drv.c | 56 ++++++++++++++-----------
 include/linux/zsmalloc.h      |  4 --
 mm/zsmalloc.c                 | 77 -----------------------------------
 5 files changed, 55 insertions(+), 109 deletions(-)

-- 
2.55.0.979.g7e5102b832-goog


