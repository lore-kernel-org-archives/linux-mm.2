Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D865CC5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901F46B008A; Thu, 27 Aug 2026 03:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BC66B008C; Thu, 27 Aug 2026 03:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7534F6B0092; Thu, 27 Aug 2026 03:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF136B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:09:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEC88120368
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:09:00 +0000 (UTC)
X-FDA: 85146172440.03.23B2CBC
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id E5A97180007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:08:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jANkGggH;
	spf=pass (imf06.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787814538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRd78QSJGil0ZcUwq3GxqGHQF3GnG4W0ymqk7CGnnE8=;
	b=31KF/Faakk4u2DYM6FyOnBYGyWSuNogT5Jv+fbdEtHt1xUlEa8ISaDUG/jKgbuzLU/xROU
	X5GLwVlPbB1TGXjkHUrDMV/O3nUFED7AeqGczB1xGnScfavAG3YJWTW3qgs7lGCWIBZYST
	CsFUlNd+HWNtkVr5cJbWRfYI3Vsb+Gs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787814538;
	b=KJJ4LYiZpT7g1mL9j3ygW3mBEvsOrHpA1rXwwPqu+79c23T4bP3L2aq68CIP6aDr5UiMPk
	Hx9mMBl9qQiNfDLs2ztjOpsPc+KgZpvgYYfly4+qjTKMS3JsLEdcuSH7o1NpYIyS29Q2tS
	yj/SXfj5toJGia2nZv1QB55SOseYrTE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jANkGggH;
	spf=pass (imf06.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-39682983a0fso1665779a91.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787814538; x=1788419338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sRd78QSJGil0ZcUwq3GxqGHQF3GnG4W0ymqk7CGnnE8=;
        b=jANkGggH73yMp7Qrr21yw5BIcpt6zB87uOq7AB7WTkusG4IvCPMaWHow4waIsLfT1n
         CK+v0827OlwnTBFIm/GAoCZiEt/NUPrbn0JpbceY8513ICwnpdAaQCp6ZbRLdD+4Z+wZ
         ULZn6xlIHz+6+I13gl7lkO5oEnFVbZpbZPYDEx6ehly++tGUTZMgWz2qrtIbE9NI+0Tf
         54xNTGvNssX0Bzyf79oyCNMI6NBSRwqzbBn+dBwbUKdnXHBi/rr9021rghEX/WASL8vp
         uOwPjnuqbT42uG9QVbCs54BXVdtSbEezz4o8JONkqWt0aFPZOR2msgCWYJjZ99pOSG8F
         s2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787814538; x=1788419338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sRd78QSJGil0ZcUwq3GxqGHQF3GnG4W0ymqk7CGnnE8=;
        b=NV72T/RHkTzBkLtTP1OY2zAFq/kcl4fHUXntJPs/snfopblqrkMUoE8Sg3p1ql7Cc7
         bjeKHBE6FKt3N3VBaR2F57hjghKzBpdeV32SOx3Em6B6Vorx6PLIB271UHpDrC6d8DE5
         E7E+W7N+6ax83PCbsM8/gqULckKXmdMOw3gJGmn9keIRpUGo41p44cQCt0itO4HV+pSy
         a4GFPm1D3vQHht8tdKkgGtssWndIWelY5sqRr67YKGi0gY09IWeVenkOw7tyIxZK1vTu
         ulVlXyeT9SgBAWK1GKEKXUbdXV3xeKMbk+hYm3z8UCnIdCeRmwFaKwlIwwK/ApGdmFai
         1wKg==
X-Forwarded-Encrypted: i=1; AHgh+RqPiBakcDgIqKGlLVr+O1uM8AIm2LSphccoujEAT8DPi1IRgbzmQP3N0L3jet/85VH0ucF3Yfj3hg==@kvack.org
X-Gm-Message-State: AFuF++mfmPiuWO8v3EqlH5I+dgPiaUbLO8g1LfjQZ9djBqyjfM3uD546
	zyijJXWwSChzIt4gGctugiWT9tqjlD1SUEfK6tqMAKgKxYjDCiurqwQt
X-Gm-Gg: AR+sD10z+69pk1BY4yxoxrXI+nfvM1EeFjE2pAY9vJ3ToAgsSI8NV4H9OCEGiYphZsv
	y13JJ1BQeO/mvDOA144wUUmAlLwFo3NYOimUHReAzQxqLw2JtcQ0Q2oW6uDHnZE8bmxHaVMBEo7
	IjvBLo6FbtEPPHDlFgAZMNCXR45AHuts21qfnKz8YGpG0AyOj2y1u8JZJRbvLa5YPxwLLr92yra
	+yqfkR1i4+wdAn3Ig1e1ZT1Nrtnp+8ceMEcAwkQ89ns3lanCDKHLR21iVeHaJrEGEAWI7w8wiTf
	TsHvm3CfWQTtRA4PD31m0zOKCiYne3jNc2Qe0wCqS/U0G23hcuXEFMJ7y9pDw3XKbZ50muECZrV
	rEgS3KonBNvSooVxOz0vx0VLdLyo75hYpwVSTVSa8wnc+xr6TqsbJgcGbHLMIQs6/mbcIwX92GO
	sBRDWWaUvpvkpUxfJJ8f9t9Tw+pBfrRPV44cP8T4IwGfJS2FC0CahKaiwrzqXF+rcTFXs041vqz
	o6n80MVAKBOss+TwgZMmzeg1oAR
X-Received: by 2002:a17:90b:5102:b0:381:1c96:829b with SMTP id 98e67ed59e1d1-3966d370333mr28339383a91.3.1787814537645;
        Thu, 27 Aug 2026 00:08:57 -0700 (PDT)
Received: from Anshuman ([103.161.223.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8eefd82sm13559447c88.2.2026.08.27.00.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:08:57 -0700 (PDT)
From: Anshuman <anshumantewari123@gmail.com>
To: david@kernel.org
Cc: ljs@kernel.org,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	nico.pache@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	Anshuman Tewari <anshumantewari123@gmail.com>
Subject: Re: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
Date: Thu, 27 Aug 2026 12:34:07 +0530
Message-ID: <20260827070407.4108-1-anshumantewari123@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ao17EcW1-iNN4Y8i@gremlin>
References: <ao17EcW1-iNN4Y8i@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E5A97180007
X-Stat-Signature: pq7inkfh9g9h8epp9d7xfihbfd48guas
X-HE-Tag: 1787814538-413074
X-HE-Meta: U2FsdGVkX1+ktN8y2Rdo5iDU3dgR9KYDMJjJ+j/Z67SnpCBJHC/NVJBrs2+ayGcQQVKlj2rkgBAugcFwqME9S9SMLBy4z8uV+2E0nwog5hPv8GYqfGdSTlSu9GOB6AdbJ7KA2ArTfG1fmXHqDEG172Gs3Wo5aleMkkeIkwm0NSZUjJ2ag6745E0/y7iJCkTDeLruOarMdr4igjWccBj7Znk1VNvY1baAtpBGTjrZCaH5NWDEbJ3tvrU+UbOBiPx9Ltdcxr2ShUQJy44Kh1Jz/gjppMuNIbfCaj5KHp6d9mJiH5ao9gCvSnuckrCwS7NbC5UmxXhkynV5Ip3C6zdO+SW+A2GORKjktHdriBJalkBO2a0gt9oS25CbvmA4Pde5e0RvhjB1o7LlO9PELJH8nM0nkc8dPWvVSlZoZ3bdQPDecTqASZrjxg661Wa7Dxg2Y75tVuPUyz/XHxcn6IayrIL0LVV7h45IwAOcF9QUQvmloPmuKMTsTQT7oxdCd8ZlX9JPofVdrpg8p+3f2UBHdqnLTmTUCB4DqlkwT38lymn9UhM8meGMiR7xyfwZ8NJfNgube3j+Ph5P/0OTErAwLJ2D8HUMDPWQ12FU53yLNIL9/IMiZ5akTT/lJOgB4rw2Xm/UqRyGzeYxLBeT07ZzTxyURlODnW3kj9CYdv/Mrb/IxkRGS07ZA4rUoIOYsOydaEVmbUiD5PB8S+HszYY+9uTl7eWBiMJAH+BP5mOTte0AGUU7W3kl2kv5Se9cpk2NEBpy2qGuou8Bmer5Kt29nzn+8mrudLx/Esvbs7BNZPtfC8n4yFU3vE3Qq7/Djrw7xmFi2ZMmO+EQtA1JZoaPw0AIjfiGEZIaCLaUDXqo/e9CDRjQFk6pMO0B18wq8B4X7Gic02YIrf9EwmaimaFykKeMQL6+p9gtgXET5oyk2MRMDSKnnsTinSxpqb9Otyi5G173MFbn5ndEo5t8IQE
 /dk/bq85
 9H7Aon2oZAwmLV0358XRxiPCTxoLH6hZh6iat5T0Aj/uvbEPo6Ud49Y3Jc7u/SRxfxmcO2EDryXDm8F5Tqz7LTlvOAcBpwVLJxKfoMKf5cLqqgYKY1aq8cOu4JLDZodbxYCZ1TzYXHkop5G6UQcjk0QsZn0XCOD2eTHwKHZyKJapRMjDCN8nnYEHAR55Ta/cK6oDm/sEdaG9/g2dzorPtdz9Fs7zbsH7huIO6FaU5DR5qiT5LphFfxp49VZ7S+bNIL1yGGUGBOakVoTAzZMotjiSHABSPogtEstqrydlPeF23eldqPd1YnkfrjhF/Z6NYBCmTM2Vk+OAWzSf1kthVFihB3teIJugMKmsDVtZx7zOnjKvk92REeZG1TOnIrynwyEcbiYK2t7by/cr9UJ/PN9QQsgegiC1dteS5ncTsI2kbGWGAHOmYbQHdCzoH816yHb2iN41TRA/9amh0cyezavKvDLJIgcX2qHsaiom6b0S77FDO+YXLni3in56ccrzP4ktj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 01:20:59PM +0200, David Hildenbrand (Arm) wrote:
> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just clean it up by working on
> argv[0] directly and avoiding the str_dup().
>
> Nobody after us needs these parts of the argv[0] string anyway.
>
> This patch is inspired by previous work from Anshuman Tewari [1].
>
> Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, thanks for the cleaner fix.

Reviewed-by: Anshuman Tewari <anshumantewari123@gmail.com>

