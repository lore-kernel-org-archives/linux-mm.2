Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D21A5606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 01:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Hss3DiLQ
Received: by kanga.kvack.org (Postfix)
	id 21FBE6B05B1; Sun, 25 Oct 2026 21:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8D56B05B2; Sun, 25 Oct 2026 21:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096FE6B05B3; Sun, 25 Oct 2026 21:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB7CD6B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:49:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97C121A05DA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:49:53 +0000 (UTC)
X-FDA: 85363096266.05.DD32C6B
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id D48CE1C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:49:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Hss3DiLQ;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792979391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AN3Hjw/HZft2MXUgGNWgsqw3kkl3NUYJU0ViE8j1aeU=;
	b=jqFsftvmmaF3u/TUUtgdA9hjiMLoBqMRilYsj2YigsGJ8QIMHU2+nLLwKecCcVuoB6YrbG
	GQViYdhIyHrRothwEhn3+zYcBHg/CFbPcwPqhNU9yTegL8JKbA34e8/psoBdBy0ZazF5V8
	JmQqkFN0sD2fwN5cSD03NWCr1FzuAfM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792979391;
	b=V9jwbbJpz96L8eAV3DSEBB9BFeqOq+HsZeACEVDqPESMPLqiiuk/AqMWkqWFtlLDcP+LaY
	Z7fZu0gxKTN1/gBrQnPhgbQadD9ZLD3Sv8+WGaV52uBm4Q9FYrTvkLobd9Ogmjs4PuwlbU
	GSGT2+vl/ymVZSvQwAkumf6hmc2E/Ns=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Hss3DiLQ;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-98301b325c4so510499241.1
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792979391; x=1793584191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AN3Hjw/HZft2MXUgGNWgsqw3kkl3NUYJU0ViE8j1aeU=;
        b=Hss3DiLQGGiIxCMTFpG6ajWGlVA36SQ/GEzLOfxpneaaK1zz2FZHRdWlMMD0clNZPw
         sBdwDeTPYZIBIMsL6Sb9mBc5shZbnFh82T3Akwb42zeJAfAlcrvpED+bYB9CB+DeYA8W
         efZ5R/ScMaOuP30cbEG95oEfyEUg9JpB276suGdtgifmBgA5DFcRc4r+kdYNiBIzwiME
         KH7f5E1UvbVU233AMB4bq8Uh0kkbSDjmlUAamevS4teM1OQ5wLLGpaAQ7E2N5gKuMFcO
         vebTzBE1Ls71tY0BxN1Q07Z4bSVvQEWFPN0746TT28rcz3yesFO5jVUoVJ5sfKVa6kTa
         Q1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792979391; x=1793584191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AN3Hjw/HZft2MXUgGNWgsqw3kkl3NUYJU0ViE8j1aeU=;
        b=jhbfInRl0aFMpUobFNwIP7crB0x1hyMtXcFx7w0dNJrQYt8HjXDV7WNK2i/XkTJWTf
         0sy7Nf6Wf8P5MRdhuoyX3WSJG54m+kL1nJ3N4UCeInlu4Dx9UN5IKOZ6++1GT/flnOWP
         E+dYMERyB9DyP3Sb3jxjWzdveQgJFeaTIcx07alZ9sr1gDA3aoGTPtcCBDoEXkGC1WBc
         tbfNTxFJeQs1ERGvmFzT+Dn9fUMLPm0RzhIxWK+08SEbdDH3HlWszoYxo3rrIbw9H+D1
         Tfj8Akb3vjv/3aSlyGchmmfpQvjbQKbnMOKj4x31qMITGfryZeTm2sDNgKi/iS7l80Ip
         21JQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXYE/j+5XcqnwHLlh0r/lmsdEzDWd4cP+euCiGmw74enPXRpL/XWPabPrOs2dpF27rseMRoucvlg==@kvack.org
X-Gm-Message-State: AFq9FYJypGimxtDoqdUlSBGdBnOptA3TAZr6jEdkG9u29FXJOzy4skPv
	5abG3H8NolMBVQMScWBIWuSnNmuRe+FLORnl5axkRkf4ylvMGd0/Mam+oDgTfygH0mE=
X-Gm-Gg: AYBFou0JhrhuHL9KDC52mBuQFX2Ll7bruFd7IR7z8d6m6uOSY6Kgj9N1qqa7/oSL/Yl
	KrZDYfFV+AjmfO5cbth0xtTbXGXW+bKtDnAMhmugrbCnBlT1LYaZUC8HeJjjquFLdHnxw6qfIlC
	CbhJ6VBvMdrAAVzYD+6kqpqEdy4U0nCky5siEKPrPFhBr+B5s9LtFAP+RM1pM3vz0UEwXOs6iBN
	lk3Qlstvq9L/wIiBu+EwzWBs9XK5MKrxrfos5fX9Y+/Y5SoD6xzbWsuMoneW+zLrjdNsd9jsbA/
	PnEUL4aFOj/G7fOCxB1ucpI/cwflfOVRX+mvh3yfAiZC1fQoUm9UbRWAR8dQ9R81Q9BJ7RAaok/
	eS7tbauGxfBxiplmxWbfvXmDZ7PR3ANOxF9RaTlJkCc1Ia20ibWno2uLxSTv5t5pxz7XcczKAz+
	bkzBacF3riYIkgvSborr5nt1dsMk6MHw5gIYlKqhJqC0pTIKR8UgfiK1G6uOjYlAy2n7uQ2pixh
	AwS9UDaLh+xc3IUWez5MDiwjHGauyzVO+GmBN7P/IQLNF3kD16V3rZU6NsLebBbb2oAMQOOhLjN
	FheRLCsaIkdrWV/jIbY8dywyg+oIf4MZgJr/n5RmB353cHCFl32cj+cKrHD67XoaLJY7fg/wemc
	b
X-Received: by 2002:a05:6102:5ccc:b0:7cc:2a3c:9a33 with SMTP id ada2fe7eead31-7ce5ce4d7d4mr1365539137.34.1792979390767;
        Sun, 25 Oct 2026 18:49:50 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ce5df73970sm6099917137.1.2026.10.25.18.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 18:49:50 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v4 0/3] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
Date: Sun, 25 Oct 2026 21:49:43 -0400
Message-ID: <20261026014948.162559-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D48CE1C0004
X-Stat-Signature: e91uoipfukmfbxp88amf19gdsfwmrphs
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792979391-950138
X-HE-Meta: U2FsdGVkX19zqVKJ7+RomYd5dPD3n2ozxILjjAlhHEfYBjl3avoTDUiu631SMLvq02xFrcJfr8THrnnmlQB3z3DLMpjmMGg8Ps2Iwjv1CqZ9BMn2eKtN4a6n3GOh6gbXM9sAPJVMyKk/ba1OE6ORAjCCo+pTpZixaNtONkXqf9iuq/J0V9IOc7AyM47dEHE0MPx+dG9+2Mh2T0LZeCdTfKmeQVVgRuE+TPsq+SNTis38tX1yedXva64xOEBrmtOIcHrC4NeDKH6J+0ir2K+s05d6dPn3eovb+/bkCfQ5skO1kQOfzZxPEpzBM8nZpzIOLxnshCfRIRBvYQ3q5USdlggBvOZ71j65m+kyAm2OzTB1yYw2yS394DElc4t2ZJZdYFz4QzSYUX9jg9quxlY1WvxGQ2tA6U8XQcbYwpgDFlSAy4p7boUWi7IW9fsR5j56Ztbk3h57pYNsb3zFLnxSz9PtOrHLQNHhmgVk2Zk9xlnxT0mkQSxijudDp5jJ0hNiAZ+zurr7/d736PoRu7lEaPGtMCDP9PDVY4CdbPnlN4MmODSIoUkwemAKqz3/GavKnpdbYrWNWSJTN2qGoyrXukCoghUhRJi248yxFBLPeRJxN4wAN6d5k3YPP2X5z6sAT2hnOWVPYmjfw4yVreD0tZQkKIRpDQ6LB/WTghuELElbKFM8Iosfvr2WDt0MN01hNciZAC6vTskbrZq0y0eQp8uAy7nh7OY1jVjqLBdFRlP57T6oPwJSTUXxNSQjdQGIhn+Oui4pmw4mIxClkDFpg6rBdmW/VGdSmoKmT2h6+e8+OPoV6s/DThR2HNKYKCq07w/5l6MO66wgP6i6iPKP9LKdWZIohQkmDxke2K7hBUI7dGHVEUyo0y9WjBzEHgs0op5BpOSGWCPMHwriW6Kih5cN0IYE/CE2Kemw3uog8KJmDeU4aCUi2DieQpC6XoOjGxrp8U6qLLGH9LWpR8n
 xNo9w9TN
 Nk0usqMHd1ktUnvhUa9rBgIxCOVupxy1OTMtZfCf32zwR0YrY3NIC1kkX0N01BZx7IKkA1F6MhRJl0kED3yhdIrKQnKetXWdMASd7TmjK+6+FDYPH7943i4aDY9nRRJZ+dknjAB7osJAep8lywV9XhoXJz25OfZszuJf3JRKgzyXadITkssfaLvZrE7sWu/jr+YZBDKHiMk63Yf8g0e/0nnWMhPKdx5Gufh7NjmTuW/FM2kUK/R72jUku9TBHK5l4F8D+rRzkKNBdmzmoG69WHgSR9roHBEzUGeNenc1zS86Q8+ev3ljgqSYt8n5q1NrOCux6kyzcheOTwk7fYPE4Wy7R3/4F2pWbx6+gQC8v+wd3etcgqURdueQaWr/z5rFD5tN5mzgbtB7eENn4DozLjPnUcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, LUO sessions are frozen automatically only inside the
reboot(LINUX_REBOOT_CMD_KEXEC) path, where luo_session_serialize()
iterates through all outgoing sessions under global write locks and
freezes them serially during shutdown.

This series introduces the LIVEUPDATE_SESSION_FREEZE ioctl on session
file descriptors so userspace can freeze a session as soon as it is done
with it, rather than delaying until auto-freeze at kexec time. Because
luo_session_freeze() only acquires the per-session mutex, userspace can
also freeze multiple sessions concurrently in advance, reducing kexec
blackout time.

Once frozen, no further files can be preserved in the session and
subsequent freeze attempts return -EBUSY (or -EINVAL on incoming
sessions). During kexec, already-frozen sessions skip the late
auto-freeze step; if an early-frozen session is closed before kexec, its
files are rolled back via .unfreeze() before being unpreserved.

This series is based on liveupdate/next commit 27be83a12b24 ("Merge
branch 'lu-pci-preservation' into next").

Changelog:
v4:
- Split out a preparatory patch that drops struct luo_file_set_ser *
  from luo_file_freeze() / luo_file_unfreeze() and moves file_set_ser
  handling into luo_session_serialize_one() /
  luo_session_unserialize_one() (Suggested by Mike Rapoport).
- Few more nits from Mike.
v3:
- Renamed session->frozen to session->user_frozen, - Pratyush
- Added Reviewed-by's
v2:
- Rebased onto liveupdate/next (commit 27be83a12b24 ("Merge branch
  'lu-pci-preservation' into next")) and split out early session freeze
  into a standalone series (tmpfs preservation and its per-file user
  argument plumbing were spun out into a separate series).
- Patch 1:
  - Drop struct luo_file_set_ser * from luo_file_freeze() and
    luo_file_unfreeze(), and rename the session helpers to
    luo_session_serialize_one() / luo_session_unserialize_one() so all
    of struct luo_session_ser is populated and cleared in one place
    (Suggested by Pratyush Yadav).
  - Unfreeze the session's files if luo_ucmd_respond() fails in
    luo_session_freeze().
  - Update remaining reboot-only wording in luo_file.c kernel-doc
    comments.
- Patch 2:
  - Add checks verifying that non-zero reserved bits and freezing an
    incoming post-kexec session fail with -EINVAL.
Link: https://lore.kernel.org/all/20261015093816.2438942-1-pasha.tatashin@soleen.com/ # v1

Pasha Tatashin (3):
  liveupdate: Move file_set_ser handling to session serialization
    helpers
  liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions
    early
  selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE

 include/linux/liveupdate.h                    |  3 +-
 include/uapi/linux/liveupdate.h               | 25 ++++++
 kernel/liveupdate/luo_file.c                  | 73 +++++++---------
 kernel/liveupdate/luo_internal.h              |  9 +-
 kernel/liveupdate/luo_session.c               | 87 +++++++++++++++----
 mm/memfd_luo.c                                |  5 +-
 .../liveupdate/lib/include/libliveupdate.h    |  1 +
 .../selftests/liveupdate/lib/lu_utils.c       | 10 +++
 .../testing/selftests/liveupdate/liveupdate.c | 45 ++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  8 ++
 10 files changed, 203 insertions(+), 63 deletions(-)

-- 
2.56.0.307.g5fe7bd680c-goog


