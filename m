Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C3DC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767626B008A; Fri, 31 Jul 2026 17:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7179F6B008C; Fri, 31 Jul 2026 17:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DC66B0092; Fri, 31 Jul 2026 17:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A29B6B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:53:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7F24120167
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:23 +0000 (UTC)
X-FDA: 85050423486.08.E62B8AD
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id 114D22000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vEL3ZEur;
	spf=pass (imf03.hostedemail.com: domain of 3UBltagoKCJE691v89yz6619916z.x97638FI-775Gvx5.9C1@flex--loganodell.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3UBltagoKCJE691v89yz6619916z.x97638FI-775Gvx5.9C1@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785534802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QMT8aJxPN69Dyrd3LsDwUHfdRMUYihjZGyjp7f0vmTQ=;
	b=d9qlMeEgrJqITCaU96JWQr3NKF5ITUi+x+yUsIvjccgTVv6c72z9OvS/YBHhOL4YJ950CP
	afQs8PHeL/9e5Y26T+TbEm0KsUKlPN5S34RUc969+cr73mGIA3CL15U7U2tR1AHlOXuLTW
	F4r+BUbwLNrH0oh22NXLKElvv4XdcBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785534802;
	b=Vhd8SuOhiASrtAMSZ3AP6eK9Y3/mfRF3VCv9P0lHbPEGBUtEplQX85HFDW+WhF7RseEWg0
	iMz1+fR4W4FOxW4AqCAm6GDPDV0XmZfr2hxQc1PnAfxEWZYs6yXLgAkQ8k9ttJjVhLVbxM
	t5Uhx4L5zig5Kb18LHrRmQElHX3y5Xg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vEL3ZEur;
	spf=pass (imf03.hostedemail.com: domain of 3UBltagoKCJE691v89yz6619916z.x97638FI-775Gvx5.9C1@flex--loganodell.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3UBltagoKCJE691v89yz6619916z.x97638FI-775Gvx5.9C1@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cab041eced3so2133193a12.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534801; x=1786139601; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QMT8aJxPN69Dyrd3LsDwUHfdRMUYihjZGyjp7f0vmTQ=;
        b=vEL3ZEurSR6z7RNPFIl1Fcc+kq5F276CYyUDHBU10nbG7j1Ww7puQJfAN4bw5dynaw
         XzGuQ/4OUi7mhQZBFLM+8zugb37bEeaMYL3unJziUh/VqB89v5ZvLnxLrJxHSWna8qmq
         6Vxjr8TuDC6AATijJRfIilhR6r4wFwAl+//H/EE6FgBA0j5zl00I+fGzDU+CClDJPE3M
         /VVakFp+chZJ5bTh6aNpR2NMyie4ByHsy3H+St3KoFn7bGr/EP5tb3/TfvTOUlfU7O08
         AndlMWz0z5jlNHNzhOG/lcSw3EcqUsr+fBxc3GsJ5qEn0B8hVM/898yBqT3VppOQFThw
         8n1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534801; x=1786139601;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QMT8aJxPN69Dyrd3LsDwUHfdRMUYihjZGyjp7f0vmTQ=;
        b=bPRXsZ9dek4kLUaP0UauXRpzCqgFo9/bkEI/D1k2Rcjouwh96xOsot6T7pziogjUFa
         th+Yxu6soIyGLrNl/GCoXf803/STvdQ3c8vsyzA7J30cZFHEQ5arGNnEKcf2aa43G+LF
         Zj7Tuz/Zdxn7882SIgVizfjNoLiK/9565nPesfxc6cNS8SBUhOCHqpAMzkMzUJYHg6Mu
         I7qaXkSP/u5ZE0h/A1Sm/H7LC5qh2yHUBHNNW49lJ32iM9VLpqSNyLUQKluvYsm5G+EQ
         9VWS9HBDBMmF0qf/X6VCfAwPhV+4gbVWRqNxfytPvWiNq5lwmyuH/r0H+tzGLYTHHt+6
         kb+w==
X-Forwarded-Encrypted: i=1; AHgh+RouN093exfFGbtOrKRF4RBYtJE82fpOCnwswLfFFV+MUYXOFWAG24LjDfnzSjvxxyshciaI0HyPZQ==@kvack.org
X-Gm-Message-State: AOJu0YyHatfGBXOphaBDrFQ1kHLX2Y6Y6y+ewQzlSQ4HSd3TXokmy6pL
	ET3Ey99DTZ6JrwKGx1qwdemhkdSCMw/0ZbO0a0za3JZ7cXeaqSTwZQpCJJ9J/FDJr3fcX+jq/ge
	XN+YTJkkP+GuZ4zXPFv79Nw==
X-Received: from dybhd40.prod.google.com ([2002:a05:7300:e128:b0:30c:5a76:5abe])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6f07:b0:3b4:7e2d:a3c2 with SMTP id adf61e73a8af0-3c92a52a045mr1268067637.18.1785534800614;
 Fri, 31 Jul 2026 14:53:20 -0700 (PDT)
Date: Fri, 31 Jul 2026 14:52:20 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731215224.831696-1-loganodell@google.com>
Subject: [RFC PATCH 0/2] Add support for multiple versions to KHO
From: Logan Odell <loganodell@google.com>
To: graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com
Cc: pratyush@kernel.org, akpm@linux-foundation.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 114D22000A
X-Stat-Signature: 87w9hxu8okgq357ja63g34yygag7a7b4
X-Rspam-User: 
X-HE-Tag: 1785534801-272925
X-HE-Meta: U2FsdGVkX1/6yO45pBgEvuWhuUSQSiskW5BXAZ51rKiO8BADTJELNxJfaZJaFwTQqfasghykZ5ZQdGdvvF+ff/R9f+WQQcJIqDZWPKMvr86DHK2MTR1IEQqE/hJHzl2nt9qbn7yajIfzIQfEvrl27fJTqaNcFHDB8ogbt9YXDcwMgdUAZI9h6aGL+CS52VfK1iofW1xrSBBS/BKeCIlRU9rHI/d9arQGT5gvlr2g7v/UNCKU5HJW56cdv5RxzZR4qY7dulo1phd5tbgl9h+q1uX0kkOO3FWYSrK/7N/sGkcfCn4KGHXhogTn1be9RA5ZEBPuBOiTf/vkr217QmHwNAANoHkzzN4+K9WTt949PgUTg85Juc9w0CFtk39uil8Gq1GhfsMFkJB3lBLYpMA/n4Qv0OKTsoH5tcgd/pm2bmTAFRBVlRUpAxY452isbGFAqtKBts4pTNwvIYl92VNH6IWKnkgslYiWj2ZNXBgVYQb/TQkaMrkBMHAV3JOT805Nguyv6HctDIO+QoQiAFE7nHp44oakrhbp8eraXtUOh2/7AAF8qXSz6fvegENB6O2GHzG372XZ2wHrhBqiCWVs+rW1cVAn1si7jTbHRb7SP3NHx8cn9MGRx7QsnTLvW0obwpVIR8xDGwzw0Y8Yi34XeatI5OpMLpGpNWLfevr7mJ4JL6RS39EoHf8Y8FGPOk94bY007giMucP6xvJ2tmOUznSirhyf3Azi9/RaSiTTwyLez6OJOvGvgn1cCc4lSBz8SlaCiNwgIr4T8yc4sr2WLyDODruRnOELJQSszrDHhNlH24cgN0cNfXK30iVjhWNM31zZA20x/OogGWovkfdVb3MEHbKyotFCUMVrT7SRYonUQaUaUjzf0iS4YIZDyEIgelFi9F2XIsTfS4kgAhRCtVQjheFeJIeTmfKA6UYq/d8SN3cGMCYjL9ekF+pcXg9jl7Vl4UI1WhBbLRlEYl7
 vu+Qn0d7
 I5rQ2PFGgeHRUfD2arbYsbkMZu5t6gCQHdvppNpViKrLAW6XagQGNW5uTLiKe3AnXttatU//WCjdVBrDd7SAMvr8qP8W8EN92MEMflb5GXc/PpYrxd+I8eKiBrRrAXWrbz4pLRC0Wr5uJWyfPZ7XK6YSTLPE41bN78vZvY/c/Fik79BZf0BWh7opozzzOod4d1FXLSKarqNMdF3scoBaXwrOMs3ZPYIEpag1hwLzcP/dvTu5Ua4eU8Wc6A2eu3WxS11MoqcRU+mglIQB+XOLEXXB/glFCz2WgkKoBS0sONXK3lKLnm4rvf4DgwQQ4gBq44KTFVWvRSku5SoTMcS6SWc5uQRytWJ1+ETjrvnH0P3udtBbUY4Iyh8PaGwv7At0SJk6XCmL/k/CDTl5E+Uoa6lWGtU3zHA/i25ZJI4niZU1EwZf7nrten5tbhvCyC0BBY8AeuM6ppirJMwUBXWasZL5Mje7weXeaU2ddK2n3T4ibOylaUyZEbFfBXorX5tFpq3QMMKXdbgvWYLMmQbfECWeoFcxK0rIdncVnzBJn1+ZhlyyhNtYis77m03wdsY/zMKOZIM8NYjkWUjNNWElTWDmIZIi5h2NNg7EVEUJQsSyFqCUy3hr8V/014g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The format of the preserved-data blob that LUO saves to KHO is expected
to change as new features are added, bugs are fixed, etc. Currently,
LUO handles this by embedding a compatibility string into struct luo_ser
which can be used to compare two kernels. This works if the changes
between kernels are fundamentally incompatible. In a case where a new
feature is added, we may want to support both versions in the new
kernel to retain compatibility.

This series adds a KHO interface to embed multiple versions under a
single node in a subtree.=20

We go from something like:

       / (Root Node)
       =E2=94=94=E2=94=80=E2=94=80 LUO (Legacy Parent Node)
           =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo>
           =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_luo>

To something like this:

       / (Root Node)
       =E2=94=94=E2=94=80=E2=94=80 LUO (Versioned Parent Node)
           =E2=94=9C=E2=94=80=E2=94=80 1 (Version 1 Node)
           =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xph=
ys_luo_v1>
           =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_lu=
o_v1>
           =E2=94=94=E2=94=80=E2=94=80 2 (Version 2 Node)
               =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo_v=
2>
               =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_luo_v2>

We can also support mixed mode, allowing backwards compatibility in case
of a roll-back to a pre-multi version kernel:

       / (Root Node)
       =E2=94=94=E2=94=80=E2=94=80 LUO (Versioned Parent Node)
           =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo>
           =E2=94=9C=E2=94=80=E2=94=80 blob-size =3D <0xphys_luo>
           =E2=94=9C=E2=94=80=E2=94=80 1 (Version 1 Node)
           =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xph=
ys_luo_v1>
           =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_lu=
o_v1>
           =E2=94=94=E2=94=80=E2=94=80 2 (Version 2 Node)
               =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo_v=
2>
               =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_luo_v2>

The first patch moves some common functionality for preserving a node
into a separate function. The second patch adds our new APIs. The third
patch adds support for multiple versions to the debugfs entries. The
forth patch adds new test cases to test_kho.

Logan Odell (4):
  kho: Move subtree blob logic to separate function
  kho: Add support for multiple versions in subtrees
  kho: Add support for multiple versions to debugfs
  kho: Add test cases for versioned subtrees

 include/linux/kexec_handover.h             |  14 ++
 include/linux/kho/abi/kexec_handover.h     |  16 ++
 kernel/liveupdate/kexec_handover.c         | 234 +++++++++++++++++-
 kernel/liveupdate/kexec_handover_debugfs.c |  57 ++++-
 lib/test_kho.c                             | 266 +++++++++++++++++++--
 5 files changed, 540 insertions(+), 47 deletions(-)

--=20
2.55.0.508.g3f0d502094-goog


