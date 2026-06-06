Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A163CD8C90
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 06:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A576B0005; Sat,  6 Jun 2026 02:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2496B0093; Sat,  6 Jun 2026 02:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1476B0095; Sat,  6 Jun 2026 02:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4446B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 02:12:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E661E1C1A28
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:12:15 +0000 (UTC)
X-FDA: 84848467830.27.C446486
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1783CC0008
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:12:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kABdP+uC;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780726334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
	b=Hw7IxRKwYlZpA/BsuwO2fAJGYC3AGPmrosPKlzhnLBnUwghStXl0r92LDHjffaO1/0HWyC
	Cmlsei8ulD34hbunLRfjcMHff7hsLPV4IER3dTLFBAj5TViq9t2Gc185klENkN3Oud3dFx
	VpBZqFhCn9dG9rGPA+LI4WeJmmkY4ao=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kABdP+uC;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780726334;
	b=UmHIxh+U1ok8xB6uRmXEUCybQXKZM2vnNjWRgxOgsGRgY1kZEpb2LyJhPBYJtE08JRBAvk
	u+DKH8107HCi3XcY6elL9f/7XHtxSsvvB5y303p0cACfiQ/hHYws1Hzhb1b6S1kP6xnFjF
	DHIVWAWzPxEw1ZrsINPgZE9NJYeZg1Q=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490a765d410so27105515e9.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 23:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726333; x=1781331133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
        b=kABdP+uCDTWAF7ywkH/YrOn52baPDdpxjh1+FJno52/FYXACS7ArGahBDGl6kKCqNh
         hbIRnbhzlutDQG5TXnHTsGhbhosCVQecKYch+3UVc7SUZM1CN5nOZTGBn5y4/9XqXT49
         UupBiauVYf3hGtFhnt6LH1r4kAr8Otamfssu08nrLUCIEqrKetyXRciOE9CFcebPVVeg
         lmh1f2c0AK6lkB78pHTszIxGYPtpllY3ng1JBd018DgRdNVKCnWGXrmHN6vthmkJkQeX
         9ah6nMrFK9vGFgXV5TQ5ZE5L08u2gsTsrkJIJQovq6p/WP9HiKb+mI4VBpIGfxYbFMpr
         /L9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726333; x=1781331133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
        b=tKF884GTPzJZcVHT57eIZRoGpnxjjeZZ/QpagqjVmD1fks+f4XZH2/nTXEQHlCdCTd
         k/e/MIvmtFNZDBxJOwiJVotZH5CXUaFhqieS2oF3rJ3TQXAUdGGQFHT+d9U7vYpExegY
         yATlZWrR1+GtevxRxWaICmt9+SdI8WWAwesgbzVKmoWspxo3gmjCfiqWODGWWMqI2MwC
         FaapWB+UNqQc9/EZubSg1gZy5DdcqtMWytTjrixb4YNVs44GygSCqHAPIHREViXvNNUR
         Imp03EEBRUmy6ZX1W5PG5T5e5jXoQ3Z5fiy0i0LEU7PUw2Q+S18fI4AeDzr+VQFKnpyO
         mqDg==
X-Forwarded-Encrypted: i=1; AFNElJ9cKMYprKLAt+zmm30RxcoLDH6nJ/ZC+a5UuK5Sz1obTBtv3XNEgaivoK6LTWmjLB4VPaXPfVJZ4Q==@kvack.org
X-Gm-Message-State: AOJu0YyH1HqZC/5UEanapRDlJi2YatojHNrY7epGZcUhWKSf22a82MPB
	6cz9Sfq+FrepI9GSv5tGpu3D6zPIbXzPhNNSO/O6WLzx4bgy4HMQBBgS
X-Gm-Gg: Acq92OHF4YJZjpJ9YtXkJQVKwKH1KzNxzKayb6an+KZTBpgaTgkzSvdJksKfhjD0KE8
	qRXIKmuHvh1U9w0ZoBaGoNTEZUlyxRCmpjvX/TGejPa2w2nHCFHCPBHBo3xFkgtsZs8oLDsUlmc
	5f0NqRfGXvP92s85hS/Ha5Py+9lUpS+UpKdDFcKFxgVAXjnvLRXUmR+W6FNZuMCzKVDvDtQzX5d
	clgXKyYAclZDybtJIYAXTHiKe4IIVzo3Gw6ILs0Q1zSmNsTASOlQKJ/bURWKrOV5yM3fEHviQBy
	WdZBwonUmklcqpG3j+A7WvVq6vl+WXpGWgMM2nWY4x20ILUwylVok+bu/MTrnEqCQDGU6n/O2G1
	WcqkgTrwrKx0tRHw3sruJOaUP5yIgYxGemC0Pbqe0yUdLy2fgRNN/FihHwk+qdtgIVe9qq9RqK3
	Qc8Ix8QPbJeRmOF9eoVdQGqzIe4oUmymqcamyzJgNE
X-Received: by 2002:a05:600c:8b0c:b0:490:ba61:7981 with SMTP id 5b1f17b1804b1-490c25c1e4amr103918225e9.23.1780726332629;
        Fri, 05 Jun 2026 23:12:12 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490c2c9ea37sm178712255e9.0.2026.06.05.23.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:12:12 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH 3/5] splice: turn wait_for_space flags argument into bool
Date: Sat,  6 Jun 2026 06:10:29 +0000
Message-ID: <20260606061031.3744880-4-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
References: <20260606061031.3744880-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1783CC0008
X-Stat-Signature: k1qfu1g5e77xmh3yraa8qph4x1oni8wi
X-Rspam-User: 
X-HE-Tag: 1780726333-942515
X-HE-Meta: U2FsdGVkX19sdpuO8KRa97HW3roj9eCLqk75dsSlVgxEihR4C63XEBHM9pHk7SR6GCkGM7+EbgbADXMCWijKbWRUf+N/Dy/PlBfN/NkkRelxglzsgLW8rLmTwPSP4XV00Q08xalhxWqpEMSMe0+GI8V1wPh7aT6LC36Dsl7SKq4sjba33ZtqLPIUlYfdd9wEIZfl57URLyCuMpX7Rvbi09mhXexBw9zSQCPmJepEURfTd4u77igyLb3MLFaQrT97qhY8eVi58qJ2WKGNyDtQOtYu41Yg1xYEQoGQS2kICsBgUab47LmrwLvjD3PjRVC9U6N376DdJe9MVQT+7wIel6kcgy/KkuLhu5kg8zgwgbZ2T2QRrPsj0EJpEaqQunrARD2jTAzDg5GFTqtxG/Ff4ILLl15oFUOAq0fb4S6602+NEDST4WeOO/p56la6C+39b2UTUxAEcbfe3ukZJIORTsb62OEm/cx8beRPXx+79zx6gCe9AxUbWx1bFRlrFNTrt8/Juy9QYchOw7EdanA6I03YkO5BLPoNeHFWnuV0Jncn2AjJJKuEKT+yuVZT1/nvX4UOBXvgnlrKEndXJ0TD2mx6M18kw7gEnE2IgTARcQ4JTIy/VpcJ5TCVSc2jzXQMAOHhw5MDZbj+tf3fvZrdIv/9A0Re+p0vl7X7D4yRlsoQ6he9+MFfLS9wmKxZJApu0hS+F+qQKlNQZ31f84IVbHAbZTtL5nDISWLxoyDsRaLksdwpq1YAeUAJ2AWnQk87ijlfa0EwNMwtwdRhtFE6GNMrqrSBt6IWfJzq1wgr4m8/H7zgslzhaxLa7hqhWdr2QbIiRag07WReXhMcGIXQXgjcvt7MI3zLpIPHnGEiOfNXBlLQa35W/xDWWbZHHcGxOuv/RZ3q//WnMO1Cj7AP6FNCdXjiShKMn0TcMIyalLk+nwAiRX3wkaJwkFTQrXuz5t8TyiMju0mnbjPQFK/
 Kuvf4+U9
 b35m8kRISV7tCPO1AzGIvABh1R/oul824kJsJ1RN5BcFcbRzGhNVzVKVbPaS9bAqzbVvB1BIW5hHA47cJkMB25jPZ54DEw52OdP8DC7MMQIBvFtzvwd6xi5vKDoWtSqZWdCl8d+ScYhnr8GNl65/zEvAiabsFgVUP+gP2FALBbmvFNBTlxI6NT5SDW4Z8RL+jDFhl3xgp2a8/+Ow2UZMqJuSsFp8j8tpKmOIZcWhU2YgsQCJwbwEfInJv4D8waMmvDfXp1HKTbd+tLBHYLt/vfcilDAGjxAiQVlz7vmqcvloPQFSSX4EjfKZneYLtL/puIPZo57hDnS4u2ARTbAMQKdKnGxfgr/bH2uZRBUhpjjmmZ40CYMTqvbnl2zcH5elgsIYyj7jut5BBcUyVaG2ZaBvTo7H46/lAgUQQkSSv0Sxsh1k4V1rtta5bTbxNSPidYcpm9CCIX1+3yww4fO0Jue/cxtmLeGxyKxpkL+eQddQoM+K1HncuJY0I8Lz5WVkk4YFFqrU3FeTVCpKZLt1BXZhxnlhKXNPY2s5+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I want to do this, because I will move this function to fs/pipe.c.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/splice.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 6ddf7dd72..707db2c2c 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1239,7 +1239,7 @@ ssize_t splice_file_range(struct file *in, loff_t *ppos, struct file *out,
 }
 EXPORT_SYMBOL(splice_file_range);
 
-static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
+static int wait_for_space(struct pipe_inode_info *pipe, bool non_block)
 {
 	for (;;) {
 		if (unlikely(!pipe->readers)) {
@@ -1248,7 +1248,7 @@ static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 		}
 		if (!pipe_is_full(pipe))
 			return 0;
-		if (flags & SPLICE_F_NONBLOCK)
+		if (non_block)
 			return -EAGAIN;
 		if (signal_pending(current))
 			return -ERESTARTSYS;
@@ -1268,7 +1268,7 @@ ssize_t splice_file_to_pipe(struct file *in,
 	ssize_t ret;
 
 	pipe_lock(opipe);
-	ret = wait_for_space(opipe, flags);
+	ret = wait_for_space(opipe, flags & SPLICE_F_NONBLOCK);
 	if (!ret)
 		ret = do_splice_read(in, offset, opipe, len, flags);
 	pipe_unlock(opipe);
-- 
2.47.3


