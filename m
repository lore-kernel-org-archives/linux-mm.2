Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3338C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 19:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058B26B06AA; Tue, 18 Aug 2026 15:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031436B06AE; Tue, 18 Aug 2026 15:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62056B06AF; Tue, 18 Aug 2026 15:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B874C6B06AA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:51:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FF391C0D3F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:51:44 +0000 (UTC)
X-FDA: 85115435328.16.84B5CED
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5FAE580002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:51:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KBStdG0G;
	spf=pass (imf30.hostedemail.com: domain of jannh@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787082702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmdtIP0DQL+ZaR3puek57DJtEuSE2eL0MrttwPIizEE=;
	b=w+SheT7BfzTCP+3vQvFro1g7UNfyi65JT23VIWWHPejcfBE/LQ36U/SbJcrMmguUrpVMjd
	Eh74c61SdXWj5OnsSJMi0Mc4oysMHG3Aq/0MJ7AyoSPOp3MfXU+5591U+lOE0nlWGdwTxO
	8NMyyiwTfUkmQWyMrsoLhxZnfV2KVQE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KBStdG0G;
	spf=pass (imf30.hostedemail.com: domain of jannh@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787082702;
	b=8X3gzLNPRib0ce7vJPIgGf+iwZoMkjHZ536azcunEZ0OS7Gs7ITTNQvh1vpOcqCuwj2C6D
	nBYi5BKwJmMXz4fz8iglYInfdF2A0NSDoiGkbMuSr5ReDt78gC6pezWmZUzgRKwsmllt9E
	8LEmb1hykXon7WLiqaSW7oVRQp5Xo4A=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4996e2575dbso2835e9.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787082701; x=1787687501; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CmdtIP0DQL+ZaR3puek57DJtEuSE2eL0MrttwPIizEE=;
        b=KBStdG0GXbksCxIjRlTg/TWCFJFMOsFHtfNqt/nFUn1oysFkauqzFP6MQLDYpq1rey
         fPQnbDayUOccg1ztMvHN7ECJ5heBYrrtw9XsTGmu2wDkyFK/8fkOs4noOVDLjMsJnAZL
         95zl0O3pT7Tl4iqoEUSzy7onZS2ucqR9v57ZAjdBKX5VzM3lPZLcwzs3Xo7zi+pYk8dt
         WnHNawIQvyT3/aZPnkTLhb3eaxJahbH4NgcZ73ecvXaxYIbtgjv9q7XurVSlGCd65QUu
         sLp/fuedxCRzPcNfz/UyDGZbf9AwKEkZHEtuw4TMaYUQtzx9cKMtSD83VS2B3JrMs3CR
         fVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787082701; x=1787687501;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CmdtIP0DQL+ZaR3puek57DJtEuSE2eL0MrttwPIizEE=;
        b=QNu5qLXzXAk5pTSSxRavFMVjlGzQm5FmUa0BhMuZAS350g1KvbQqrFgJeMabc+Vn9m
         gOPqVy2CEBhqTnVaqHxuZrXlsVBv2kC4e4JnjFxRwO9xYt6/1JmrvB3jZdWzi3obElfY
         vv75yh1wvrXYgIEZnw+B6R6EGXgYPj3lSUVIrByWWylTjD4YqlvANdUmVi7sQPocPz/k
         jyv7mU8ewkfNKRn+k/0Qr8EhbSpC4I8fUizZ0LITotxGFfJCPOJirKv7eHW6hlntZhGm
         YXdlN1wSq5Pj5etQBylrO9uIBVWoJthuuibegBCBYATyPsuK4x1+zcgm1rqGh7nLszBh
         lFxA==
X-Forwarded-Encrypted: i=1; AHgh+Ro1ioXmNMV8RLxDaoZPxO8Rv0UwKOCssQrOxsmK6dbp9Va+KX/XT0lbkmkD4WJ8EmFQ7VOkHsOLuA==@kvack.org
X-Gm-Message-State: AOJu0Yyufj8iqnkTooxPsX9+bCnnl4MBbgDGwLvo50jDukfHhQe+GBtk
	G9mS8uDlhjiZTgaWeLgJl35Rwd0VcztdoYc3DHncDdx3K/nTMmnejvQhW+1Cq+1gdA==
X-Gm-Gg: AR+sD10uQlgB3LQKnVccz8+HPGJgUDtJsWlFeoJgTKjD3eH7JkQttDk0M1TT4tOUnlh
	c7l9PZTIz6Yu2VYoKm0DN88Hd2Ke61235PcOO1/fpWrZRNeZ+N2ZerIbWL8afNtN8gqLFsTLL+z
	3YwJgCIJ6LNyIQA61kByFPGsfIP5/4s4RXgXjcB9pa1fx4TyZsX0Y9g36sXWCH4pqjwX6Frx6Es
	m+MVsfoHSl9C2FC3GLXSMqWUn3HsgC1G49TeDDj6yd9E1IqzE/ImSbtb69IShcmtAGwucV2lu34
	da8yspqEa+haHSWiubERZp/Mc3FTvfZI45CEH0oziZvBbJQ4RqYokHv+03tq8HSJuNH2eg53Jvu
	mEmPvnPfw70zgBZW38Pls/dtWioWRdggbPJrcjWlg7lsgF3ZAPLgxoOwQUK17hQMH/iAE2BM9e9
	OEFUTJQgzQYotAh0B5NlRf7znWo8cft5P/pe42rHAledcy7xgg7exxtOBMD41U4Bags1kksSFJe
	PYOCr8c7bm77/BtXBoy9MvQRVCA6BdQWT06krWDPwb3BiA7
X-Received: by 2002:a05:600c:254:b0:499:7da3:dd0c with SMTP id 5b1f17b1804b1-499a94ed422mr57655e9.0.1787082700662;
        Tue, 18 Aug 2026 12:51:40 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:f466:5a15:1301:318d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a3b2e9sm14732299f8f.9.2026.08.18.12.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 12:51:39 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Tue, 18 Aug 2026 21:51:05 +0200
Subject: [PATCH 1/3] proc: refactor /proc/$pid/mem to use struct as
 private_data
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-selinux-pokemem-v1-1-90cd2357ee05@google.com>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
In-Reply-To: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
To: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jeff Xu <jeffxu@google.com>, 
 =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787082693; l=2363;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=BYfEHJfZZMUNLO+ETDGvPO3wLBH8V/4ZmUWO04VYbxA=;
 b=UL8/Zxd/s6hlj2bjotDfABJon3uluPe9T2bOof/l5Q1BRt9GWXgZ1QNoe2vEfEOairzDzs3Fn
 M5W4YEachE0DIfsnfKkYw38AHvxyEcD+oMJ0Su/fE/5rFJp6s/kS3fm
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5FAE580002
X-Stat-Signature: 6n6p9uwifrhq9zp3izugjt4k6ydy1ekk
X-Rspam-User: 
X-HE-Tag: 1787082702-724341
X-HE-Meta: U2FsdGVkX1/e0Xif6xgOmf2ZxLukiN7GCtKLj1uQ3DXTWHGqfDFrVsgk0Lf9DwoqEGiMyzaHEyBpy8iB+5T5Q/t3yeR6GHfwdox/P9bfQ+DpT+QSamQAnEA7KMjivoDVT5hDv+NaLUcX19b+Oarhm4PmXFWD9Km77FFV3CD3++L2qT2DawGHUuvcpWSeEu9BWL0e5XxdH2C4fHzRbCUwkTUGBE7MI0sJ2qiqF7oDWk2fOLFh55rUozkWQSLw9ejGG5aMZ9lySZh98WwUN1IEr3XEdMbv93pm0a3Ri/9zAS6mijI6ySO26/qh8xyGQAXMJFLIoYVD3btzkatO+V0cDKYHqjFvC0P0ROmZ0D2EvSN310l/gO3CGCK6i1KzO68Ahx6unjTw/qBMIs1nMRGq+vfAdZu88/kXBcTmz+C9KdqIHPv4vtv7Q3xN11EJydYYF8F7HQlqXQx3pbrkqymkbQZVsA6fJr5cH7h5+MQMaz/cRcYpdz3388ebf2/Qyna+p3nfKag/gI1zrwC4pZoVK8nqesLFS+a3cAPRtRDWIeWleWAScwIptcgYhQdW/knXpT+SwmgybEFFT6xYRk4HvSg5B4AzK65fKGZ3p1jB076hQVyo4UM2qMj9ZUFDwwAb09HPb1kbI0S4LoHAe5z/Yuwbx4bdxfPgX67sMR+PpsyFJl1GRWHAEjnIJfcQ5OPiEWW2shn+eHbT3z+2IiHBfoQnm2WIQepGWTrLKaulHi7lzlaUNY/Cj3aNPjdSvwNKKT1zuv0sDGpLlLE8WCZoV5Zw/+hdZJNdFY/JrOh+bU2SUyXszARZqgzJyUepO25WEt3D4V1HOrD5266a4taJffhgKheXkd3n5SL7pMS+THG1ZHu6IcxWC6N2uVhlRGSno2vYPVrLn6PL7uiHuBbeNr3qYKukAOqkm4roOjo3DBoT57Y3zZp92Rqevy3h+oTz5TsxIiy63zr5YTUUrP4
 TmuXT8U/
 uZRV3wwTKnDfIj61mKu1uEWMIJifFIdzBftkSUmjU3/3UaSNXmubEsSMixVmrMwL4kUeZlaFwc4qx+9iGEH55Ve076WVmR2PFlZERJWon2w6yjDahtao24FlUnYzoe2XcVDDxzOLIxXIO69WJl6fOKujYcwUq1sPUd4J1XeR6ALylRDzmWUoEvsTacNgvTp7QL8f8QWFM6z97z//ok7A5fu1HuqTeoFeXYoOnQ7SL4ivLN49UAyk2YquNZSrsG/56dI01QC36XpFzUHKOOrjxVKw+hOKz05JTdR5o+xH4HlhPfxEFgKB5yrGxU+vcN/l3GXJ+pqpVg8uEa0PFMhDDKQoDNwSujDGZzfhBZOLVfK7WiMdnKF91bpRBNv0IveOOrX62xqk7naHEMSltOc0PS5KfbhBMM7wo69kgiew7PWAMP4fnEgPFnJH0p1R8W4K8/nuOCZeDCauwtEwU3Y0NZSbnEHy+sSNdbKxvM2gS4PrxfAq/9xNUF61REPsq0lNQq15pmBVxPYheqMN7VmNS+AwE2fV9Twis+Zq0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the handlers for proc_mem_operations to use the new struct
mem_private as ->private_data, rather than directly storing an mm_struct*
in ->private_data.

This is in preparation for adding more state in mem_private in the next
commit.

Signed-off-by: Jann Horn <jannh@google.com>
---
 fs/proc/base.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 780f81259052..bec6197329dc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -848,11 +848,24 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 	return 0;
 }
 
+/* private_data for proc_mem_operations */
+struct mem_private {
+	struct mm_struct *mm;
+};
+
 static int mem_open(struct inode *inode, struct file *file)
 {
+	struct mem_private *priv __free(kfree) = kmalloc_obj(struct mem_private);
+
+	if (!priv)
+		return -ENOMEM;
 	if (WARN_ON_ONCE(!(file->f_op->fop_flags & FOP_UNSIGNED_OFFSET)))
 		return -EINVAL;
-	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
+	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
+	if (IS_ERR_OR_NULL(priv->mm))
+		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	file->private_data = no_free_ptr(priv);
+	return 0;
 }
 
 static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
@@ -880,7 +893,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
 static ssize_t mem_rw(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos, int write)
 {
-	struct mm_struct *mm = file->private_data;
+	struct mem_private *priv = file->private_data;
+	struct mm_struct *mm = priv->mm;
 	unsigned long addr = *ppos;
 	ssize_t copied;
 	char *page;
@@ -970,12 +984,21 @@ static int mem_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int mem_release_with_private(struct inode *inode, struct file *file)
+{
+	struct mem_private *priv = file->private_data;
+
+	mmdrop(priv->mm);
+	kfree(priv);
+	return 0;
+}
+
 static const struct file_operations proc_mem_operations = {
 	.llseek		= mem_lseek,
 	.read		= mem_read,
 	.write		= mem_write,
 	.open		= mem_open,
-	.release	= mem_release,
+	.release	= mem_release_with_private,
 	.fop_flags	= FOP_UNSIGNED_OFFSET,
 };
 

-- 
2.55.0.737.g08866a6d13-goog


