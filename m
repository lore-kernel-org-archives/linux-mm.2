Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B16606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SfNfTQEU
Received: by kanga.kvack.org (Postfix)
	id C26656B05B1; Sat,  7 Nov 2026 04:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD53E6B05B2; Sat,  7 Nov 2026 04:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC36B6B05B3; Sat,  7 Nov 2026 04:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 767306B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:58:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02FB84032F
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:58:50 +0000 (UTC)
X-FDA: 85407874062.25.62EDAA1
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4000F40005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:58:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SfNfTQEU;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794045529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgHfJfhPTBywx3NlxTS/kXQCqL/ALdKzJAvOY9N//Ns=;
	b=ZKNnyDiwFLUmyOf82plPmeVHj2rJoIUFV1I8rKQest40n6YDzIs8eeAqY19YEGLKoJu1A0
	i+pT52xNeNqOsxHRc4MLXs1z0YBjcqbtXBBUIHSNo3joDRkd04SwWIJWSsWiZHrrnguHyM
	nxpUCe1NZjSSocTlZ7OkRegkmOUzmrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794045529;
	b=DFYxv0XvsUqFUb2Gmv/sGklttlRQTH959kdJx2O5qCoZ/HfAmmnOuUeR/IP2SC8ebqw1pE
	J0XwuZ1OjANZw9A7YG3sPgKVzi6UJPHwqOK2wrw0ZSmP5IaftdA76ewQZG4fggrF8mOPn/
	oueTMD6OW2WyDRnIVU1aIsR9kD2DACI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SfNfTQEU;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso667185a91.2
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 01:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794045528; x=1794650328; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PgHfJfhPTBywx3NlxTS/kXQCqL/ALdKzJAvOY9N//Ns=;
        b=SfNfTQEUvux1u0HaS0IVzjxDAmvi7zoSNiPeCaw0l4Tj3yJbEDfE2jJxnrl+wtnF8O
         W8WCtviWYpwurZdADAzbBRl/keX4yjzetji+5vFYt1ZHqjPgE8/4oAek6cmfrhIylnFU
         G/Ch5HaiOHFjy6WRIN4Rz580rOTGh3ZtgLd8n62sSIdjQwwDnZZNZnqwHvW0BX5QqGqE
         XPzuXZi7ir8TY6p73P5x97m5pHWVPWuwW2U23nrK1McrwiePxjuk1Ccdzh/rd2JsX4x3
         hd/vnUMC2RTL64bguE4gkgiZJKXaAAfJp4MkAdy/0cS6RBb9PGkLVVerLDyEeyv72DNZ
         2dwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794045528; x=1794650328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PgHfJfhPTBywx3NlxTS/kXQCqL/ALdKzJAvOY9N//Ns=;
        b=ND74DTzZMksVsoDlfUjFMhrN7LD3IBrQPVs5tzLyq6YKxqduGdXbSzogE/5Vo8UACq
         uB0OUySSWcgV2bgtT0HM4F1rFPuWKtWV8i+dcnx9XRf+ci2CbhnJU7SMENs18Z5+OwYy
         ul/3jX8tucUuT6LksJzOw5Pa8djhYOwRMJuElB2Ls4GmyhAOw6QobF7/S1hXzS/YZd8c
         4W4gmRH5AAuXwYNgtv6UIiyP7+QOyq8demCZB99f9QEFT/dJHhpMjTFiB0khBOzTpgno
         gi6cfCBeWZ3UjAPEpthKxKKiXb/rQd8kPZBRBYo0sBWDgt9xqL6ha97zzV9olk0ClLTh
         CgKw==
X-Gm-Message-State: APuU4Z9YQI9T1I84NHOAalxkFfQXxCaKgzKSDfL5kW5k0kig4PaDBLPb
	RhfgsrL8Zf1xnk/4EhbWy3CuTG9oi2LTHghhcDBpRy7k22FzrM8F5ZNTLN0Niw==
X-Gm-Gg: AYBFou05s6ZWeOheoBrIc43ScAKxIz8kXp73qjjKUjhOwD7mLAtnXZAzVwlagIaIsD3
	knlD9XFERc9LAcxLmHPNb+vZapE2Iv+g0+y8PKKRwWtvyLroeBPAKvrd8QaxDn0hz3OJQ/oCzUm
	nRy7YIdMcTLMTqzORimskklo2cDabtkuJd3yvgyjntZEDYyEAcErFLgvfInsdTNz+UX9cbVe467
	OOxngcFOgMaHWD4XYIjcvMdxzVEP471Qt6i8DcuLJ5Vp/EDUfrxO/7/nfcx+9fSxQCt79NxFMco
	Yiiz4+54+WCmdN6g84HFcpyT0MpePvxEhnqzRtNJODQAylt7hC0rrVvCxApb/3ZpRiJqJHxH+S5
	KUphC4O+ITIL3B1o0bVFbTSDDk1xLm59v1CTPIsAfw4H3w1WWWMezxOKk5ff/Lx3U/stw+2BBTY
	f9x/BVMDAVXWFzlDhIfArONiGcxRmRlcp635f43UGBhe2oHVZdlVp7QPHd5nLoaPEWccObqFxDp
	+EEI94aNxxUShGPqwRsnI1oF/DtFL7xNhryjKQRuyreF8TQGWvH9pwYLRpLMKs83KrHDFIInBIe
	QzXWf/JkDuG8PCQTNBHs+DoYIPgptQeb21ewPhFjW/Yiiizv+dFlTaQ8Cckb0dXFKMAvLnrQNZF
	MCYYrTxTsKkRcGQ==
X-Received: by 2002:a17:90b:39ac:b0:3ac:a139:1b13 with SMTP id 98e67ed59e1d1-3b0db6f156emr4913386a91.29.1794045528042;
        Sat, 07 Nov 2026 01:58:48 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b105905bf3sm2888581a91.17.2026.11.07.01.58.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 07 Nov 2026 01:58:46 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huawei.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org
Subject: Re: [RFC PATCH v3 10/18] mm/swap: add priority queue for swap device allocation
Date: Sat,  7 Nov 2026 17:57:58 +0800
Message-ID: <20261107095822.38098-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <sashiko-outbox-188139@kernel.org>
References: <cover.1793106426.git.lianux.mm@gmail.com>	<b1580bf6460962c02d3c7ebf786583f200db491b.1793106426.git.lianux.mm@gmail.com>	<sashiko-outbox-188139@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ne8cn77et847oms6nk6gd4mf9rwu9rr6
X-Rspamd-Queue-Id: 4000F40005
X-Rspam-User: 
X-HE-Tag: 1794045529-288215
X-HE-Meta: U2FsdGVkX1/2hWFKpN5hhYCPlF1GU/ApuKeTMomOMB0ONRTCf/+ph3W7wbPOYvEuhJxGxLRTX78okCVs+vxdH2rgYYjg4b0fZiQfaGqjZP/MCWDo7tZc7MzzqOD2XVAKGVPq7QIiOSzm9DoJxWfcqy2fMHnd8eey5DzwyjpAYEwP66+EZdWjAIyhP7BRXRAyV/VUuLX3tE2DyiL0mDGTs7Ce1iTXmc2rmaj9aNea+TsbKGdcVqydZI6kNz9+YZQLMvTARtKTD5wEF3y2KAZ2HdmWEEmG1mBD1X7w/rq2o1MnHkGpW+XY6mlDowoS2sKsATjrynAl7Xe22Q6eBcurrkiDgvGAaDi+hQRvdtcUgMrZ2KxONvB/E16+lAEDy/Odr1rsdL9GkmChxVA8+CYXVXLjan8wFogwqGpMluQh7VZgQrNVVUIFpWNEztYuBMy7nTrD6OTHYS9thU4Cf/Z/zI2MNCYvH9NG7So8MYO4uVDVRrWpFNDmqe1CFTBx2kzBME9n9jWGJvhqXR8QAU2ytKfUXrBgZFdpQNiKajXy3pRaYH1mErT8Z5qKUPNEV/HCbVn0t9p1l/R6FvG5FkYZ4xZKxy7ZMSl4dNKiPcmvi6WrAnppwhUJYl5thbSJ/H92xU1XQU1gO7I54mGnq98FftzsNGyCIbQ8v6kWyHpvv7b4MbMa8YRcc4zerTZ+3FknQLiHNDIBUbLzV/3GxrMayBdEDDTT5qrNnMWO/mzG7mbvNj18y46yfdh0TwYzDPSMFPWD6ZIbE1oVfxY5RhDDk+tpXBtkvwt16Ig5PX5EoTz3wD6Ewu60RH7Gt5Ph8v/KNlv4Pg70JnK5zDhJFAfzZBSYTNrklryAGIRAyZOl8cE6qJXWkv9B0QLCOHphI7DYP4AoRfQdforqflOMN7KbFDicnfzmftroj8QtBoCrC6nBAgiMPIG7XLzunYKCO+vgF5GbVTn5IQWXgmwGqnH
 T5QWMh3D
 qcQJlYoLZWfw+h8kfDgggAyV5HCzRWriZztMBVL8WdiMbvYIv2wCiKZt0PYBShj2OIz83xcOKYVyB7M6vE2shymfYUzggiwWZu2jTbruemR4A67wUyu52Tf5J3BY/Eb32rr3MWAzH1LjWkrRTDwSYwUYB/6YGQB3i7eDxkXeccmC/dPgoqpQ0YlN71f96uiV5kVFQj0rdASJ/c2XFzHuPT7b6EbLg/ZRhTznclZ44QIx6n7L6sSc+qJSrClWoYeI0A4eeLPeIksVlbnjlZLH+VNqNGztryK8LBuuUELDhq4XKe9JN/iF++wtBcN15HwEKBIefPzQDTpGWFJOukdzFbYnWLTS/ij+QOY6bd2LRwTakS2KGuOygVUwSWX/Nle7TnHvXUWR3wFCT6rHzvGj58etBWjrBQJKjfTOK8uYrT8Hh3LfcVOK5Jn2uYzpNHbSJ7lNX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 16:14:57 +0000 sashiko-bot@kernel.org wrote:

> Should swap_device_disable() call del_from_avail_list(si, true) before
> releasing swapon_rwsem?

Yes. The next revision will clear SWP_WRITEOK, mark the device off-list
and mask its queue entry before releasing the topology writer. This
prevents a newly admitted allocation reader from selecting the disabled
entry. Cluster-lock draining and try_to_unuse() remain outside the writer.

The preceding available-list patches will also keep their state transition
atomic under swap_avail_lock, since they do not yet have this allocation
reader protocol.

Closing this window also prevents a disabled candidate from being treated
as an enabled but fragmented device and setting cursor.ring_only. For an
enabled device with real fragmentation, trying the same-priority peers and
then asking the caller to split remains the intended large-folio policy.

I checked this ordering and the large-folio control flow in the
intermediate commits. The final revised tree also passes the targeted
KUnit scan cases; the disabled fragment scan does not complete on v3.
Those tests call the production scan helper directly, so they do not
exercise the concurrent syscall selection window or the queue's
large-folio retry/split policy.

Thanks for the report.

Lian

