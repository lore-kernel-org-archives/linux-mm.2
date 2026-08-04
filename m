Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5309C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E6F6B00B5; Tue,  4 Aug 2026 09:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4FFD6B00B6; Tue,  4 Aug 2026 09:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F0F6B00C1; Tue,  4 Aug 2026 09:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7273F6B00B5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:42:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05C6F401A1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:42:34 +0000 (UTC)
X-FDA: 85063701828.17.A34F3C7
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id AF5EB10000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:42:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b="b6i6/9Rw";
	spf=pass (imf14.hostedemail.com: domain of daniel@0x0f.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785850952;
	b=qfkuPJ3fLVbhpVWZIS5RHBHDpWGJGPYqdYT3XkChbGbetjCyZlj0aSsO0oyUFmpiaTefrq
	+g0v8urUUK06RGoalV/fNcQV2yQtyA+MYTRjOxUXszQ2Dcd9sppydY2i02hilDucDt5L6q
	XvximGgeaNfIltB7tiWyo1kPk/1f2mU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b="b6i6/9Rw";
	spf=pass (imf14.hostedemail.com: domain of daniel@0x0f.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785850952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BqqmJ+CkjzQyLJ9nl1mxgsYp2XZlncwLWU2u6v8GGk=;
	b=SPNyJ7u4buY3Z6+tDChOkLTxlY1q6VZ1lQC7a0RSLAA+8aumfuDLFg00ogTHqde4JUvBR7
	Pf3Xy3VUDgO82Bmg6vjPaWbMWY5H9QUfy5XPD32c1n0oUJ1rljwxGlBHMhKxSojnOYvYog
	cfMqTR6yQhKCRkgoI0k+1NcfSexwIP4=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8485b358552so4713890b3a.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 06:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1785850950; x=1786455750; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6BqqmJ+CkjzQyLJ9nl1mxgsYp2XZlncwLWU2u6v8GGk=;
        b=b6i6/9Rwe8+6bB2sYfPozj/IM4R+DztbbpTqPqphe6m+vQ1/ix9ovkt1WO4G+hDNm3
         Ii4UcUuHp9una7IAG5nh7qenW3Xix55r1jF1AaGM0L5L3ta1mpbjChu8ln7guYXMLt83
         qbs27tfjqggdaqYruKn4uGjytYvd+aK8EBAq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785850950; x=1786455750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6BqqmJ+CkjzQyLJ9nl1mxgsYp2XZlncwLWU2u6v8GGk=;
        b=LBGdpfbesr5n+Nh9Zyxhoke43ZQslY+hNQn9BxO++CTaTrUEGIHD9h3jZU5A16SBsa
         9mem+0wUAYulCxxCaq5ImJ4j+0oTApsKRUICLn2CtQI8b9mGunzu/Hotlwol/4ZLSRTx
         kSOwTAQRFa15unIoxAMih1biAsQEfoMXLFPwhaqpKLa4HzWlH2HEPJcEUR90UY0gcOJ5
         gLA7TWSIjMyZagm5uZBeiuNWV/SaWq2NBc1J3TE2XXzJZGNdyz1fkB3XU2Bx20dw5FJZ
         QKzXGTv2XvnqDwNf4j8JlOAYZA3cyQq+O22/FE++SO+kmSViPdoN3eljPIMkbjXGPscu
         r4bQ==
X-Forwarded-Encrypted: i=1; AHgh+RoIsvH+cxohulx3yPmUVA/1rt+ITwNgeSSiMq92GLOAYYY4p2Jf1d9NalJkngh1UeL4bMiECWRTXA==@kvack.org
X-Gm-Message-State: AOJu0YzYc5yPSeDWZ8QeAICIsVBPRUHt+vvtC6ywvf2aM3V+Azq5AWGg
	Sw6YnX49mTM4cOM4rk5uzFHD4oi4M8lAGU1Z/MN7KJm8p5lB+sFgYfbgG8Uy/oAvMYE=
X-Gm-Gg: AR+sD11c+bMod2F+RPUZ3sSNeIwFd7h5KCOmvfTy/OJLXcOpKprOU8gseuBAnt0rwp6
	rsrlYFb0xaOglLw+8DVIjGQM9NRho7/RlMtOW17sgqbgrYNrmsyPIFLAKUhGi7Sgtd1KCL3+o5H
	nVkIQbRAhDq1hL+bJRVyj6knIGiaiZNlcp9v6P8IzabqQGXwWmXngyuMzdg+smC6QizXiRgcgyb
	aZzgMF42KQSRu+XQ/9lvqIwC1Rm/tgV61wlo2YFkXG8NkiSPnQ4X5ZZo1/a33XEp4hqfsId/Gj5
	2rn/+0H7qdWEpDAd0WYhNjNNRLHqDf43nuSOzmtC/KAZGsHvYqhTzsB11JeyQM5Qr90m994VYbb
	Sylb4Wjc3APNHbLB9yvunIVBVYeHOJr3o1GBfUF6Ywa22W7/J+lHh6DER7N5TUtMafLrOEUnfAx
	3Ud44AIzQFs3eOPYqMbR6M258h1kQ4lAl02C1ekySJTGuiZkT0N4c=
X-Received: by 2002:a05:6a00:12c9:b0:848:67ca:c03 with SMTP id d2e1a72fcca58-84ee4915d1fmr13645029b3a.58.1785850950265;
        Tue, 04 Aug 2026 06:42:30 -0700 (PDT)
Received: from shiro ([2400:4162:2428:2ffe:e3e3:8255:fe3e:c7f5])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-84edc29e6f0sm5258690b3a.39.2026.08.04.06.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 06:42:29 -0700 (PDT)
From: Daniel Palmer <daniel@0x0f.com>
To: jkoolstra@xs4all.nl
Cc: ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	corbet@lwn.net,
	daniel@iogearbox.net,
	farid.m.zakaria@gmail.com,
	jack@suse.cz,
	jannh@google.com,
	kees@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	mail@johnericson.me,
	stable@vger.kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH] binfmt_elf_fdpic: only honour the first PT_INTERP
Date: Tue,  4 Aug 2026 22:42:25 +0900
Message-ID: <20260804134225.3631912-1-daniel@0x0f.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <al_MqBrjDW1QjRau@daedalus>
References: <al_MqBrjDW1QjRau@daedalus>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eo7xqw6dqwsko5ujaonr8g9wxutjih1n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF5EB10000E
X-HE-Tag: 1785850951-865758
X-HE-Meta: U2FsdGVkX19wgP9xQqnpYImZ1ubMKGAnINe0zRmn6cJt5aSyh6kuGzlL/Wbc/2vGg++WLnM2DEx85hXbIjsPlrVIkjF890u/W4pD2OEkiwnDdCgr+yRrmmmDTlPi+kP8w6vFiBEf/HMlI6J5DqrNfIM3UtiDo2KCvQRTN04WZZnGGThnhAyx2/Pj5TuJRhB2cuzhr4NvcK/ljShOlKR+kXxEZ5SeVJ3Oqnl0peCSUqclhHCd6Ahvjo3xSUbKx4ZlrCBxM1pcOUZjC4BRA3VAi8gChAcBQEnuSUJAQu8Q2HoeGqDVz0gBCbHnIpblsgSDXOSediU4ESmD3MAdym8G/wobJ8HFqaPTKFLKHbYOvU/LnlW5EMBJ8IEr0R4s0/umY+7w0PwHWbXMayTlRzA8o/9OQHbQ9KKqXUBBNNu6+jIS6GHzovOHqPMZYmihRlCKIcaDptOA/FaBY2BvM/MqlAG8JP3Py/5AZvDkzazKEA0EQjJQ9u2fvlQrouihWDO0C0V9lFO8H4xtnnXIJ39GHq61rdKuKRhEwo+GHDyGcHpl3ya2cfdscrm0kUDv2s0WJtVGlloRd7zLGTN76yogu5dMxhPrj1dM26yzTRwfKwSw3oaZYZRhS2/xswIWERvKBBnO8bZNxKAqwJ1uK42GofiRNsaH9UGFJlxPRsNHh5wvs/hMbw612+xbZvk+3ct7O/LOa65vnl37gtMbpKLEDUE9BqZBC3JI4vICVU4lqPTN+AQrHUdPvzwoNLta44jL9UmY9Ba0eA4bnn0zlJ+z1HxiYe/ziZSw5y8OxeVTwhcSjg8jRfc3/s6BcZQLfmCpLWaeg7u+4cgYfq3tLyGLDXkO28rb8FA3qcO2jpnzZFlCdNi6TiOQzbFdE4FtpB2651SfzVqshKs+sEY5uu6XxTUks/1q2Qzrv31yDpl2t57+xJHOmUpbPIrayr8gsLkZG9iaHQmWWI1tFvNjNau
 cZvbwjQQ
 PWA1T2I+ZdEr1ID1aad6U08Nmzuqtdm9qC0lyk2/BQsHb/ncognZ19au8HCO2vhNQOel5RlipspxyqFyRdsdski4H68SIhzqfc1HdAnmcBINHvC9x2GhszlZkPDjvGt2KlI6582sJjGj8f1wDSgYpljhkRxlLK6U88HNjI+qD2FncogapAmK7JImjMJA3iID4wtWWkCrooxOjf9qaBZWCW39rI4mqwS2ixroLt9Aec4+uEumbeW8FuIHdZ/cTcMRe5G1CJdnicB926vL3AUMo4PZZudYdmJIpSbElck8hrf+ozHKIwgRhLfUAG3vg2XtEIcptjp6+cyU5mGeiL6/BEMZ04uPGmGwm5z9+3vqyjkME+Go=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Sorry if I messed this up. First time replying via git.

>Afaict, currently read_code() may blow past what vm_mmap() allocated
>there, which may result in memory corruption for a non MMU system.

I ran Fable on all of the "nommu files" and it found the issue this
commit fixes and the above issue,
I sent a patch (co-written with fable) and we proved this is an actual
issue on nommu via a reproducer tested on a real system.

https://lore.kernel.org/all/20260710121443.1059549-1-daniel@thingy.jp/

Thanks,

Daniel

