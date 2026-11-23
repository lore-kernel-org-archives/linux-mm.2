Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA60F606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0Ts8qLQx
Received: by kanga.kvack.org (Postfix)
	id C5FAA6B05C4; Mon, 23 Nov 2026 07:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FE96B05C5; Mon, 23 Nov 2026 07:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26A16B05C6; Mon, 23 Nov 2026 07:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECCC6B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:03:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3236740883
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:03:54 +0000 (UTC)
X-FDA: 85466249988.12.11958A5
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5B1DD160010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:03:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0Ts8qLQx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435432;
	b=49zVik/wvFkozJmTAneWV/FTGOWVi/89Jy9YjTXSIepB4liQacPwz/c1HLdtUHLIvrtG5x
	i4w5IRY03RUg5znY7BnluVJ0adcKTtZxbuzvUKSRuu7aa8QIQUjF8s+y8jQBZoOpIRmWzS
	kp/yaVHoY6ZrCbTV/GgYQyrwSzo49fY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yKvLgZfFwS1iVko5Zbm10jwWwy25iLk7A9hAJwSx/E=;
	b=IsACs6WAprk63L9pvP8BExHqbFl5V60ocr+7m+eABtY92JNbBrGKYtGVmMvG1fNuJCX79p
	mAqbR8D1o4grUPXDgZT7zvp/zjOl2peLMra3xKUKuBf29ot5jhdjz1pGj8jVZco1xwpu12
	OQdMkt8+WBfrhaIc+mqdlBdjYhxOWkM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0Ts8qLQx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b413997581so2666001a91.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435431; x=1796040231; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4yKvLgZfFwS1iVko5Zbm10jwWwy25iLk7A9hAJwSx/E=;
        b=0Ts8qLQxEtg1z85Xwdl1CDmgH8CPREt5SBdqfVuQoKXawyXDmh/IAPZm+oqw3Dt3Bj
         aamKVVsupB9y/uImNrI/MN2TlD5HZD+3Az91+jY5N59aYPABDxlW1PHObSKGNfdJrWKw
         QTW4fwDNFN3LMq59C8cnUw33Y0VZJMc4bex8+R/HGXE3/kkPmZMirmPhn5FFWPdoEt+l
         ujJBjCUNMwPm3zVM//4Y4xYqligEd1ALgNXqvPWuNvmAz66gniDUgzqk3QYwC9g+rahc
         BuEtqEZFDE6ioqzWQnE/PpS4C1FYokvRtC7fakQuMa584/aizZhsRUujCqW0/RPDi9WE
         bHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435431; x=1796040231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4yKvLgZfFwS1iVko5Zbm10jwWwy25iLk7A9hAJwSx/E=;
        b=LRRYZToDCIz5BDaCDc2rv4jshhG0cW9f69+tyxyeccwhQIV16XG8YAnz7Hus3nLOIF
         rnLFg0s6JQLddq+2gY1+J5OUeRM23M86++NwtZ28S+MQF7ExxAWRFo5k+mi7yTmJp/4/
         BM66hU6eqWeB4/hNcCkhC9KIKZmeD8GPAZNwVYOIKbZ2dz1TcoEFJzGQHatM9otC79V7
         zYCC2L/AihBEfGvdm8EX0siS8gkErrIMx+2/iWmHrBz6LFy/WgcfvO90gSHDkPzDuZxh
         KivFx4+rIXNdcwGSmTMoH8dWSqlUBITAaMza209WSb9c2t4dqSpHrmBIZsgu6Mx4wI40
         TJ1Q==
X-Forwarded-Encrypted: i=1; AL+hErE6TFG4aTX7/LmaUNsDCRofb3wYsVfVG9eYAa4QF1qEa88USzuO5c+z4wABOttWirRKId9IkqlKUA==@kvack.org
X-Gm-Message-State: APuU4Z/R0tP9fq1hQqxJ4YRzMkcdO8SsU4gB9CLjRBYKppE1z/BUfDCF
	R5H+xy1H8Dzza0H+osJ5rJflAxGLm1H8YtMdNWIoEvCSrVXIDELC+UB+
X-Gm-Gg: AZFdTZdN6bSnDXpde8oqhvdOzT7gQntv4Isvcz6KCQmwBiYOWJySnCBrl7Mun99f7Co
	+iB996uhoC82KFbPlzFCcuQg6mKOWzQTik3TQB6AdxYk6LcARiz3w/QIAMP/X/n3FtzAZeDStYw
	/Q4oFzdI2W0VUGDEhbwpHk5FYu+r4wNe5uwj6o+iY+qCBCaP9iXAhLh97v1nnqngDt/fq0v5/2t
	T2gcd9KntxDjt38Wnmpe45P6zbqyZV2Nu6wfyA5g/zLO+qv7Yf1TPh9u1zm3V0fg5IT1F7VqNPB
	WVXcuS+UgFSB5xz0SBp+ZfGauyTULRekyE8A7Dg5rsEOZnAXQKdtvnUO5xbWaexCfgvt0drbabq
	zqYz77tsj4Wa2SCDJnOcu3lPUc3Flk5UU8wWLSE4TFTZZJ5D8aJyIq2S03YBN1ChsVxjr5LmSf2
	1XSpaK5vDgmB6SOBfNQPwxXrHu8FmHTpMtSJChq9fbhoIJJflz++ugISMjctBpegYKaY9KZvyfc
	gIQpmfabzkBVu3M42FXKADCpOt3RtBfql2V7wjP/547F856xWIi7bqeZRPmF+dpGWoRfClRr2q4
	N52MVP9HWO3CkAPgjHnyL6MwOzZvAmHKUzrDZKlzTyNS0nIRp+F6oM7nm3ISJffacaNESg==
X-Received: by 2002:a17:90b:57cc:b0:3b4:f23:43f8 with SMTP id 98e67ed59e1d1-3b41c908fa4mr9358128a91.20.1795435430862;
        Mon, 23 Nov 2026 04:03:50 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ff27bsm30450974c88.6.2026.11.23.04.03.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:03:50 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 24/27] selftests/damon/sysfs.sh: add basic tests for admin/reports/
Date: Mon, 23 Nov 2026 20:03:33 +0800
Message-ID: <20261123120340.9486-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-25-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-25-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5B1DD160010
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 1i33dioou67jpp45w7b1ge8uds6j1y35
X-HE-Tag: 1795435432-900333
X-HE-Meta: U2FsdGVkX185Yok8dUXmyT78uM+/IDH4H5I2DB4Ra/EE3gpKrbQVEwFCA24/1iBfYDcwMeIvXrWiQTutknY7Dy2QJTr+RWtyW2fj6kMfP3ugdNxD/Tda3ymVaH76UuvyhGHg7o3X02QSMXvFdYTW3D0if5YYLZ19udmO2f0fMUVxMy12FeIQMZDZqilMR+eyMGC/bKZK5Hloz2sV++3gmhQJyff41R8PGoc6kX7Pm+dR8ZLOgIZqoYyP5P95CsuzhWHojLY9Pm0KqF9j927/3piRAt+c1qDzp3IjDFhxhihpqxfkl/l4v04pKnOjJaXtbQ9Lr+W0zEv1b+HrZ7ZansUFnhNgwK7EsejthaQx64+XYqjGgHhM0FNg/FsxujYjeb9AwaWUrNDGZWGyTqEuC1EuZCBhie/Yp3IFfXkSd32eENC4mYfyUavEYugN1Qd8xh6mEiQv7kdCf9bkOkdICD9T9nIBIGPhFZZ9+dib38o3duY2q9Uo89wLyo/DgvDh+qNH91h6nMaRVcrSaNyC0QfJsedDUle/MC/5cOVBzWSVCgfe+4BfXQBI/UHIUW/lCSlgdW9wj5f6PEjNfjqirlkF+XhLAG3Nz/X2ZaABZyaFRGw9T0QFvQwpvF8NrkY0toam8TOrNQ5DHRtMbn7EFoK/1WMv18ItCI9iHZZ9zMnminqxukV8IYZPc2g10rSDasiFdypQFpf5ggkIfso08lBHSjj3AOwxiofT0XtDyaJJPBRsAGVSu4pP4AM1m0agXEOYw7+OsOKetVMOjz4XFmplp0boIvcZDmo/AArfplER6LNlscbZi2FbiudUcDlrsTRMJfKYx7pvRCfXe9dwXjclsoebdHFHiFbIioMt4usyJm/v1FO07AJNpczox/FFP2fQ0vUXppX2n3hhswSOEZwMT0Y0ieHxbqPORLQsE/WgWBSdjjo/9OBvTOed9PKQXvKqjXPoGXH0A1jaO3A
 fo2fS6ui
 Ba4sKpgNbi29eqV2qSUlHgmC4IC61wp7in9WO+rEgnJFKGooqXjfttRsbQoU5yG7c79EIlA8M2I4hTXlXT4OKgRZ6vIm/AaLb2j7/JGh4ZhWKkpoJUJcfls/VsLBt1TCpxTykjG/yF6ItieADNdFxIYark5H7nBl77K08kiMehdaIZqm/WVOvPoG1XJFER4GQSF+GgtTRxjJ/3x//Q7pXatbR8sx8QNgWJS1tUe9fN5m+8stsvdy/4cNvWWulyZ80Z0/nURpTcX4mcuK4xU8ndqn4BdSsiV/pEVgrtHGztrsHS1FkpwIxd16SHZzHiO/gretHBUzlb8fXSgLEeU9QV2IGm2bYxaMaAgGrVvGylR8sT7eMw/BoO2jtjpW2OPfG17zGEvCRI2Vj4qwYxc7ldmOQELZFGtbRrawjj71fnIDleyjfe/4P2cMBEYO0KfCGPNkGJlWdNR14TGojy9MXqv3PCsGPFm3fZZrdZK+eeOIwLzvq4rXBg5DR7RPjiMXpAjbBH4BlCkVwM7uOLX7tQspXObSfzwEF4VhX97N3FVxeGz8FafKC3GWOCcX2JCRxbWEq9f/Lzicn3nuq9qAMS9yDzaZmTnfuyB+XNHQifaHBcIodpDK+7x3gqZy90PRuXhp2PABddfCaIsGc3JBvkI7yUK5a/14o+653xIYQdGbIpM2/04hgaoTEjjSRKGCU9RgHFB50S+xPVPZLIImbJjVi5XuxW8nVla74k64C6nFId5ibdgEbcv1T2jk3M7xmfRahkJCKO3/+PJbaQUvk4yrWoeGwJe94sf9+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:00:08 -0800 SJ Park <sj@kernel.org> wrote:

> Update sysfs.sh DAMON selftest to cover basic file operations for the
> sysfs files under the admin/reports/ directory.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

