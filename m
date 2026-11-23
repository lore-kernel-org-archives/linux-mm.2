Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03175606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N9LG5Ksn
Received: by kanga.kvack.org (Postfix)
	id 2560B6B05B8; Mon, 23 Nov 2026 09:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D796B05B9; Mon, 23 Nov 2026 09:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144AA6B05BA; Mon, 23 Nov 2026 09:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E52C76B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:16:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 527D11208AF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:14 +0000 (UTC)
X-FDA: 85466583468.18.3B5C7D9
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 87AD74000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N9LG5Ksn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443372;
	b=mC1JSGZp1tCV4Bbe/s6I5g+e0nydQVov8ELsf8Mr2Z8aDd7aLXJzurmu0H0ywzErgsZf98
	fI5dyOjwQ0IWdyx2B5BMtImGVtEqbCGwtJPmAWjH0OmQVJ5ga4aseAO2T2P7on+JE9Ogwq
	XTNa5cIG7xChR6jToKOcgVljUsRs8p4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0kaLBG9armAqyKqZcboCnoBFONiD+mZBC8cBIH32JQ=;
	b=MFFGWRogTaHoUR3NyHW8tqD39w7K6lYXPYgHBHfhcQ5VaDnRW1ROUX4OYlDT3lBp5SbCwA
	Res0RcVfON7OFcQ6b1JZkBQ3QXRBXwFq53BbMq4h6xuv6BE6uC8UkwyVgimBBG7zOJG3TA
	3FIdQZ3m1jTCBi7RRmQG/xnJRcOoElM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N9LG5Ksn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1a2761c69fbso2099323c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443371; x=1796048171; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q0kaLBG9armAqyKqZcboCnoBFONiD+mZBC8cBIH32JQ=;
        b=N9LG5KsnObz5Ai1WxZwNYboddRR4IMsSHIi9rKmVQiXyOVNmKtN0EczrKmUnNW1Kgm
         hJE3ZB22MYz7L76h+8GD45YwOoJ/0m4V5tyRPPZ4BY+Bp06rx/IasOh7oZ2DlNXg1mH6
         lhxjkwwqfL3r5CJIo1roxLngGU+nLSjai4p8MbHJH72pM8BFfEa6QTVDC5cPI+LHWW/1
         RFzStNDxeAvgR99OE8vGLRbTBoyCJ3kCiwMq7qMqyUiweLoxOEzJGHJgigMuVd0jWVbx
         jszBp/lLr7lpGpkyKXZe1HqbotB5IeUPAK6I2taAtM37v6nlgIp975IZCMtUWbdQQpV+
         7mtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443371; x=1796048171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q0kaLBG9armAqyKqZcboCnoBFONiD+mZBC8cBIH32JQ=;
        b=Hh9FXneK76e25I61D9/MZuf2HdqMmFzkOa32YhpGY37+AFmF2E0BgxwS+fxHgQunAr
         MYcwhayWWGi7mvnNcyWm/qT7A50JccX4E47erz59eskuq90NhwPEeELzOWpHGuSZSqkj
         ttm+wUrV2Oh4GzelEo9/vcyI8vBgIdr5ft5lNj3Xwn1C90ZaaFOxnRQ3VVXzDj4mHncg
         ke0h5zi2o7OdRkCdwWYFGYcdZ1NdGg4S+cwZQaolUmvzgwuT5GdpEbACRHymb76NiTCA
         thYwoxgZjKHowyhaocrmmJ8A2URCdtHYGXleY3AeSDtEEvLk9UsyQl4HWC20+3udXCyt
         JraQ==
X-Gm-Message-State: APuU4Z+wS2BfFsZrCwvGHR1FFiVrZQYgvJu4sMZzJVXoT7cxCETmBxbV
	CBSnCH6/gTLgyzgxoQLYjyvoQl07CuolgcUVCjZ4C5itBX2AgXTqdtF8I9R53XnW
X-Gm-Gg: AZFdTZeGaUL3DKaA4Nfn5YXiw3+FxXFA2sYEV744a4KKFeckdAQfGiJB2nu9jjuCwkh
	YO9HBvGCrVNBpgMkiZfhCB51MdZMAtzHESkjBxhNrn0VYjwLT5vxnPgdK979VRxC2jpW+rqMyvW
	sFw9LYVsKqKBycpfCzsS0a0UpaxpFF/KgrezgTkpeaB9D/hspfELbekzzLpXtsPHt8tOAiyHL8S
	qzdomm5RPv03Pj9WDbGTZuM+bonqiVz8aeYLpRe1KWgUtC5yQr/hV8orE/AnwbDS1qhlEQQFE4R
	IlOayKP1DM7LH9eVBk5a0IlbJabsi69QqFKIiEg8Qe18RCrv3zmJdkCA/PS0/8K7y5odx6MOwls
	UeIFEAXN2fJr7zEK00XZecs2iOoL3zOy+lG/Msfbigh1fjzRl5xYW6R/V2pZaVnR5Am4fhMXRSS
	QR6IpeZAJ9TSv0CUfkterDKJ2kBetHW0XWO1n2M67oRVXHtu3lWyGVLDrR/pTxvK7wzxhNyuSso
	v7hkXQpMIy22W2xUyPdUQBHDcisIi43YpBqyUoPyN3MAWYsVyLvue1Gbg646cJsy5v2J+Gt/TRd
	DysAa9nINk2g9XKnyabnjOZiyjBiYbGlhRaxfks94fUZQGWw65XB+SOcbPFd8IwiY8yZ4g==
X-Received: by 2002:a05:701b:4558:10b0:1b3:b4cf:8f18 with SMTP id a92af1059eb24-1b556926cfbmr12460036c88.41.1795443371191;
        Mon, 23 Nov 2026 06:16:11 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567daaf70sm38348685eec.28.2026.11.23.06.16.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:16:10 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 01/19] mm/swap: remove unused parameter for reading swap header
Date: Mon, 23 Nov 2026 22:16:00 +0800
Message-ID: <9f3715ab29bc9ee4aaa1bb92bff47c7584b73ee7.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87AD74000C
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8c77m5pg7d5d14g45x85f4ws4emoxpuu
X-HE-Tag: 1795443372-246211
X-HE-Meta: U2FsdGVkX1/am6jUtRAZpXCWrL6McDWrcCtA16CR/orIDFku5yU9xRGuFBlTcqodQksYFD6UmmEPZW38k0ELTo3DdmcVN7fJ4ZYZogiYW7ka1tNL7qTsJwklXGOEh+5dLFPdVfhmsCqGENhHAtcSrKOlgdq2M4vcz6KC0V2DJQny/zoFrXy1kiGy7+zFnLSo8ySRBtaM8qTrPQbnwdMqKzeO6B5RXJFGe0LHgMDEReUcgjDFfNDRCWHrBp+OpKlS6a2XVHl2BbpFXhpYSKcJSzfAOuDkm+tFNy7tbr0gV1SXeZkphrTc9PxvmDiw7EpRdPK6XnvZFW2Ckf5x2Q++KRMJeWWAImby2VUA35e+ajEWFuaQuSxFxu3Ct0Sp6WKlhV3VkwSXTYhuAX3wnZq8C/8MNtfzq+qF5V148LYP+pRsG6x/G80C5/iJLv/OqRcMot0Hn8HB+5dtCDZ+ie1Ed5nKyNfI+u8EfQQVEhcInfXia1EXIQiTqc4WjGdQp/uBNKBqCNXWlkqX1E/hBQ3r3muwKs4gOgGwFXtT56FrcWTM1OToL8IugVpEplr0HLktxyvFw/GwWHiRLu78RjFM3aWsWZ6AHOAI9XfO1q9iq6mjx5psePVcy/PH3S1OP1lMud5fl1OKb+WNfwy3jieRPi52INWYfxF77FIUBT76GFWyvm+8Uwfo4y7mqOWSew1FAm11glJd6T2mAz3k121gfT8+PyUINpym7b/JqYYrYNIo7RW/VbaqgtDyBuCUCegP54c+6MlPL6LapcQgVaeAh42ORDq3g/GGkXxwrznLvHYhj3UXERKtK7LO+Yybi6YPMhZAhuKpJVMsr76fBw0xt8ZoPfDSqzVrWP5CSe3fqq80ZKNhD2YdFjUTn2lNsC7itRFmQ7GD7SkBoXcvLY4WrEzSqZKwCC/0kdcQuGe91Merb+aTEtsGwsjzWubLeeUbfqY/kn46ke1XawQ5FNQ
 sgVSmZZR
 ihdoJv5kh0xz7kpS0mWYpR3bNWhl9CBEDCk0ySp1M4akAmngIgNrGMoYMUDtApcY/+f7s1ARe9qWEiGsM/7938a5/flxAh7qWT1Aapuxv2DQZ4/9Wu5k/td+5PQQUBipX4XyqPjqNoGh/qvTcoKUx3b518COdMw2cE53GTmn2FoQQXStGhBp0T4fjutBfPEX3wbOhalndECNByJCAUc4r9DPsc1TY2eZqg7pK9/ZEFCDi8r9x2rL2HRcGS8Wro0fsItvZLa+tUMXB2KmGvS6Y6CzqGOlSgF7nzxHR5MwZO7KaZLJ1J1empZLSXt4sI59/Xk2SyoTG6gNKG1TleuoK4o4UlVxtpIgVdqS6mLucFnMU6Xs/wuCAKtQU1en7LfMqcXcN+/M7andEN6YxIPqKEP8BljS5JknZyueGxXGGoeC2c7w+Eip7GCIKnxa+9u3JMYOMsv5KjN4GNoM3gXK0Hm2Dvpm8YSQ5WkjfZdfw4h63ssnwIvWU7hrda5dNk6/BLCQyx9luICYAHLdGwxnF3xCbVhyuaxVI3DUko/Le/Z+CYvedJKJYIoymqWOf1xbYr4KxJRoYgP4cvaxNzrFIc993RN1XXQ2B48CewaoqdI9S/vquLT2LqLuqXBlXriDJYcib1oZ/Tq4/fbiQao33IIinjBAs9QP9Xn10odQiGswyIkeiGf3MWSr5ppaqdNvu1eLE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The swap_info_struct argument to read_swap_header() is unused. Remove it
and update the swapon() call site.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d59fa8220862..c06f9f532e74 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3630,9 +3630,8 @@ __weak unsigned long arch_max_swapfile_size(void)
 	return generic_max_swapfile_size();
 }
 
-static unsigned long read_swap_header(struct swap_info_struct *si,
-					union swap_header *swap_header,
-					struct inode *inode)
+static unsigned long read_swap_header(union swap_header *swap_header,
+				      struct inode *inode)
 {
 	int i;
 	unsigned long maxpages;
@@ -3863,7 +3862,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 	swap_header = kmap_local_folio(folio, 0);
 
-	maxpages = read_swap_header(si, swap_header, inode);
+	maxpages = read_swap_header(swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;

