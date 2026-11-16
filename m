Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7B2606A88E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZWNwkESX
Received: by kanga.kvack.org (Postfix)
	id AB9116B05B6; Mon, 16 Nov 2026 07:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90E26B05B7; Mon, 16 Nov 2026 07:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7646B05B8; Mon, 16 Nov 2026 07:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7715F6B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:00:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECEA21C240B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:00:58 +0000 (UTC)
X-FDA: 85440840996.01.33C9DA4
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	by imf01.hostedemail.com (Postfix) with ESMTP id 36CD240019
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:00:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZWNwkESX;
	spf=pass (imf01.hostedemail.com: domain of 3d_D6agkKCKICNKEGTaJNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--aliceryhl.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=3d_D6agkKCKICNKEGTaJNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794830457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
	b=XDm3xEw22Ndu8csxS2pPRjdsIiHNrRJJNoIe8X0WxhScyUHOhfln/hzPHaFxnCZyz9y6OH
	ZadCP7HXvTaIUsMUnVdH6mXJJ1JXjxg39Bsj2AGWuCPFJaD3NpBI+ykp2V7/q13e2m1RNg
	n3ckRUYC9Aq/g7o1i6CcEkSnNvAuGzs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794830457;
	b=3ERLJXNLMXQwdkIFaKAfPXZGKDzpQZu/FfQy/dl9wnXBF6qaR4QlWOqC12TPmWwJNLFqqT
	2T7qyXjt6aslEj7wQYdbLNLfX8F7ryuaTkkcUNzjdrS/XqtwjKwZoM53nIwMdCBgmU814Y
	6P7ryKWVIR3NLE3vPEcRcwKUxbmDIUQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZWNwkESX;
	spf=pass (imf01.hostedemail.com: domain of 3d_D6agkKCKICNKEGTaJNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--aliceryhl.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=3d_D6agkKCKICNKEGTaJNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e0461e040so2973440f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794830456; x=1795435256; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
        b=ZWNwkESXwzblRRswIofQ4q56LvFax3NqWN54BouMWtaodG5GfW/B/379tAAdVc4Zwv
         iQUsA8BKZr0XMB6erRnk+9LrDquqDG6tug+w51NhZihlNZu3q7Rd3gPA+RevDcSzOCOr
         U9+/y+ZB9EK0ODndDNDhVux6+9pEU/mrmmNmLTqtn6ZOUX9S/ZYnGoobyGC1c4onsr5g
         3ytKmo/to8O33W6lQNLvaaK5gFTOBMf1bH/RK2w82/QJBJgWrRt29amABFP+aa8igLh5
         wnwSBIFtrwyzitLLAJiUS4IYzlpli/lAoqNmFDgzjqXznmoJ5GlW4PBOFm0G/q1iK/2U
         kJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794830456; x=1795435256;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
        b=mjvecO7FyYkWgxLj8AkPw9bG2Vk6O5KDIaNvWevYBiyGRCNFUrBIrZZ26fl4JXkVeS
         Ikgb8dqScb1wjnP1RMWSx8BNfvplczXQFgnqQcuJTb93iTJ3ZoRaaiW19TEJAANMBtmx
         YYpUKB/RQm0gXQFpCbZx5vDso99bG3P2YbQUi3kNIkOw/8sZA5HLzJR6dx6cPOo/4o/9
         6wgFTw8Fe5OJVhmajxBuJhGjzolIulr5JHLuxa09ydCgfSkGlNBt2KjDqrC9fhZBMm1/
         uw45zlV5p3U8/boYhndl6d5sjMqfqMhp6rE6uFc3kuWskMe7l5/fTZd58jafM89kP4t4
         Uxww==
X-Forwarded-Encrypted: i=1; AL+hErG5TidOJxKSdyuzaK/Yzv26t/hkkYNlD1W5pOMsxii3wcpIb5tCDhXzuicjwQOMJWgLiJ6WuYB5OQ==@kvack.org
X-Gm-Message-State: APuU4Z+pT9YQVIEL7M1XiIB+5knnfkZ5KQSbnMTCVPlxXLKNQeRSKNxB
	WGrR5mxt+qdg6/GJ5qtHnNA5FWuoeJ2H3NHJillZGC2fQWojQmhGzOf1Di3L+ljpRTohiYl2osu
	M6BsaA2AevTixiOlIkw==
X-Received: from wrso13.prod.google.com ([2002:a5d:474d:0:b0:493:3d97:6e88])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e007:0:20b0:48e:3697:708d with SMTP id ffacd0b85a97d-49c70ed8e41mr16698595f8f.12.1794830455230;
 Mon, 16 Nov 2026 04:00:55 -0800 (PST)
Date: Mon, 16 Nov 2026 12:00:53 +0000
In-Reply-To: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116120053.371591-1-aliceryhl@google.com>
Subject: Re: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
From: Alice Ryhl <aliceryhl@google.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 5413jsqqw8xb4rg6nojj1gdaqium3m3f
X-Rspamd-Queue-Id: 36CD240019
X-Rspam-User: 
X-HE-Tag: 1794830457-244893
X-HE-Meta: U2FsdGVkX1+WV2hQcjlWpKt6UcW2SGmHVGtFn+KVboQqUD6w6VtzrH5kGKYC+/ryHHAuzF3gvlKyskgHX0MnjQC0Rez+de9vdWpvf85xpeuV85TsYEi13jUfOo5rytzQrIz4LtcvucPqtNPDx3uzOMF+EN3glydVsOA0YMA8wRB7rkpP+zlpy8h8tcFPMimxE5+8TfUWwg6PyH6dM81pG/FnOf8ED3dGm4Ni81ige2nMUT1lZYfadmle87g2GFi/5cYMJChvsJDDdozEx24ebCR31fKUfkoG7q4wxc9wr85JAil/sJIxA6OY9tMbGzkmAUgLfWkDH7gvaXBM8LW14X9YyKBESlhZ9XXvBA+cEOOv5r8dEP7/tpiOT0JnrzD2iBzVgwDO9fL4FdCxWHLbGH6sDfDyxB/FBmRWx6pQEauod9kPxZUGt2HGUI0I3CzhSYcH3Vg/EoufGL4ZPmgIX0CAd1J0062XD4NrJGSgW1yDJ2Yl56RgDaX1Hmfn9fiQi62WufK1fCNNe1WzGoKhbQY9Hwo7fiTixS8bAiffemP6yuyiz7xsccdVfiyeP53YUmhc+KzAlhZVskxsPk1B1VKv87FqBu+0xsyexcqMaP6Qrfio9+QzO5u6EhaklR5ID7jVunzymGetDhPXrO0+SPjrTWgc7v2OZLOb17H62c8QZ59vLprEWoZC7v5LLmSf3E6moMZAmsumOKZJJLBGkBppzWjX1iX3LwKX+6Dflls4IdjF662kTIiy9/rpYrmMWjzTV5grWZoGbp2x1/uXUG+4ygBR3eiKaGj/Inr7fUnDgRiMa+yy5lL9bAFRkKySjRQQGQSanP1B1zuKEan2ZN/g25exuo9OKF0pNOBYgdDAezz5LFO0M796Pa75Rag63whimX6jBwm9LPOlcDx3exd904ol2qZbPqaN2qI7SRI+hP7zQOE9PjhPE7/OoRYUVQED6IPFTSJv4zKQNDU
 EFLhmZwR
 xymBPkLookVRWTk1D5ft++36cjjLtxgfTArTy9fG800KWXqjVtpsrkeuhR+4RnlNm4RtKu2PzE6S0em8z+6YJaQ31p/6g+0/mcoD+1dqHCYhEYYEqGnqpFs++l0TIMQr67NxKCDoH6mJF/ZKzTOdpWwYoU8sfOjQSDeQr8eieyI+qHzUTCKICnR/gbaLUKWrvkaCGXXN7RSkckdovV0/V88noQh1YTdAZkQO+p1GaKovRWrbQHCiKvazib+V8vj0HdxDaoHkh7h+ueB9nruQ3OWBJcZU2agnEozVVA7w4dlfNnkpTu5DyPzUE00+xbqJknKSeJKCEpTiQ98nJMhfRMg7F1tbFAa2Q+WdebE4xU8MbFwkx+lWx+sjOZqOkfN8x5t9nZ26jxi7DKT8W17i4rEhvHOYaZfMDbBHZfq6mpNM1RmwlJDJcnqwDkdWtxppujNQshwT08HbSLgot2XKVj1PWhgCjZLG62YgRo4SpL/pgvdqQPcJeSXo/P5PnAVot5kKtJWdGt7xf3yF1cQQiW5SiP5SndrOe0PzlmlwhbN4+vZtbwfxLqvUSelw2g9IfTu1+zmAHlllLf3wCdOspibgeE2bEktEoUV8PFAX/is+ZszDPdoQzzpYa2BprYSVxDuxJ1Me7nQDqpukdTH/L+J76xyLkirAX/unH7Ska9cYymYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:04:45PM +0100, Christian Brauner wrote:
> Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
> by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
> SB_I_NODEV for the binder device nodes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

