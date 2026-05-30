Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8FACD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E884B6B00AF; Sat, 30 May 2026 18:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3446B00B0; Sat, 30 May 2026 18:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD93A6B00B1; Sat, 30 May 2026 18:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B75196B00AF
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:19:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BF3E1A03C6
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:49 +0000 (UTC)
X-FDA: 84825504498.28.9662A2F
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id B87971A0003
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DzWtqaOz;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTj0tA/bHNpv873y+awGsfoidHwlRovW0AIu32f5CU8=;
	b=xPfiLeFzJbfkOdRCi6QcuRnF+aa/AeFAzBfAMSy9JJJ+wv3NbW89Iwf+J/7z44YOBlpYqQ
	4sPovLrYLJJ7oiHYr3urq7fkCH/0puLjF9sJxKlwi2LJszWkWg/0RFTALipcr8LKewpTa2
	wvVVxZ6cQ7PN2hMaSLSQ1dSjHu3+SYk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DzWtqaOz;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179587; a=rsa-sha256;
	cv=none;
	b=zCnM6SjXUq3SQkQIQ+21Ev27CGW9TMXNkIlRA7/7IjpRENN+ENFjYLsxfRSZVKWSNvgneu
	TgZKoAwt/pnw72UFDW9Mw1T0tft9pge1kGn9sps8mq3HVKgXuHpYUeYWsqbsva2D155BjK
	tSliwkLO1BhfFKr+KEuEuYSub7LV/8c=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-914bf787977so675702885a.2
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179587; x=1780784387; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HTj0tA/bHNpv873y+awGsfoidHwlRovW0AIu32f5CU8=;
        b=DzWtqaOz50MDZnsqdeQJioEfVTOCby/d6kzJ9r/Ee4nAEFMGFjbH62SIXLyDvzPg+9
         u94IRD+g937BoRzfkCAcvprzUSlXH7+IE5RPJAqKpWQ7iRRDBk1fw+9p55zgANoq3YiS
         VDWDCUCcYfA2gUShm0U6TDCq7bsCY86Yxzx/8Ph3zHvZ3ZbDFG779fq9tHhapvZUoSXp
         mU30aCOV4p8xwz5N1Rw0v1r4dAwwSRvhwC65sBBZTd+p3/6hllZEoFp34OjCSfrTWGRH
         opdKpx6Zujc0y0CZuuzAFn7pvGlpYrRFA8Mz8Bty/bBPTjBSi/4SrG9h8B/lgscEtpSF
         JyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179587; x=1780784387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HTj0tA/bHNpv873y+awGsfoidHwlRovW0AIu32f5CU8=;
        b=lXr2U7lDO9HWN4jZ+8KVggoHcaM5/GZD2TSBaxArhhO3DT2IZHROX6IGNjSnIkEt7J
         W0yUBMiDxh12wQNC7m0LZx7N92E4DCKoyq/bnqp/SSnYX09pLCpiVcz9D6z/ZHYMtdtc
         OR3ca45n+dDFpFl1NK+Q65BOai4dbGZ2/ZzEygcZwiMYOOuQtP2P1t1S1zOxb0tZrKQG
         3VSh5lVdTvWvLKEiwWm7WBUwYrHUmlfe0O9lpWyIMF8fIVsavJhSHElRT9PS+gkCGass
         FiaiFhsiLuZrcexks0gUjF0CAB8Xk+pa33xLfJW8xO5ng8471SX/YaA9VedI+lA4P9Qj
         e9NA==
X-Forwarded-Encrypted: i=1; AFNElJ/916awWxO6bKWI/vbXFTzyVvNulS5e2z9r4WrjApcKrARFjh56UVFhxw2wR8UBNWKpZkeGeU8WxQ==@kvack.org
X-Gm-Message-State: AOJu0YwqGtQZu3l3mdG0QMZZ2wPGmxfENwrgDJIZlGQVw0PE9nAc3z7r
	o+GClwQbH/ONwyM9FUlvSSII5L4KlfOZYJm0ekbJJ8giRijMIf52ma8YT1HfeZ5WGdQ=
X-Gm-Gg: Acq92OEuPm5aJ5Ej3wWD/+4bOH1EiMu5MKVpqeNaEBQwg4Ntqr05X5V5vquBwufmb8h
	pV2OiSf0KlpxLeTWNjbahP2xID9+ZqXbQGRa8YnCGZ8FPUuYQlZr6IxG2TCuUFymPcToCtys11g
	mNGPRsqCNvgkuVZWo59FxwDXiKWC1HhiQ+FkzIlihTg9+oWf0LG+b1+SxmlfeFEYa88IxnvA2Il
	checqe/Yu7lFS68dv/Ypv8mmpLYEKNKRlap9EmuLd/TX3+ochzhaDgCFUmyjrqD92xo7RSBhbIE
	0eyrItn2mTqNAWIldr0flpxcF5xevzn/QONajpA7AA/EXRguZKRemlLEKu7TXSZRxFHGHhbTqB4
	Z7wcvEvsMnXJOkpuHdSZPCYrTQW6vvdMg71on14NL204u+sKS7PzwTV4fZi6BqMPLcUN/QqOmDn
	9oyq0au+AVAayfXuXuXAW0WqJEAVrWeg+jCrLE5D9/344kq69+Mdn3EpNoEzTW3Q==
X-Received: by 2002:a05:620a:2610:b0:8f8:cdd0:df82 with SMTP id af79cd13be357-9153dcb4b99mr859487985a.58.1780179586864;
        Sat, 30 May 2026 15:19:46 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:19:45 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v4 02/13] liveupdate: avoid mixing cleanup guards with goto in luo_session_retrieve_fd
Date: Sat, 30 May 2026 22:19:27 +0000
Message-ID: <20260530221938.115978-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B87971A0003
X-Stat-Signature: a4h3pgqyemye8cxqn51rn1rk8f93f51a
X-Rspam-User: 
X-HE-Tag: 1780179587-401161
X-HE-Meta: U2FsdGVkX19NjH2fMYHbn96CUOGv4RBS1uL0iQ8BhOfLz3RiXNnoGhMTpK9XZL4+tugX/1iMlXsCYha/W/8eWYoWHhfZvOU1jlUhpao0jBv933PqvxgZoFsHrWooL1I7bGG0mwAITRG76CobxyAfpdq0NcbjgzUoVEEI+KczfuKeBK3Ti0MaYVXUAzmaZ3LJTn+jNNiYs3n6662i9Q0nkyrnG2S8V54ZUQbqcRFaQSKWVO7tu87Ah9miGufdz5z7UK01/7G0sUojJ9CGyPYCaKp+o08TM7hcPDsbDmF+KLdBdNinbtiz9g1KiD1YCf/BAOLYESQ3FmqCMOE5DxTOTHHllG4wBdOonyG+AuDhriJYoNuKylsyAPB+QHTjQiKwXzgHTR7uqNNleV/qrM2xoaaPEeEuA3zRzcl3+rVCUjeGySDJcfqW1f8FmhxydZynznnulsRiWR6KvEBohpAGUaoaUws1kdB6xs0Lxdrlb2IOZW6wXd7vau3QNSdgDMSqJMovkFlm2grQHGahDpM2CI3LawU4u9Ucc1o5IRega2jgam/QzF7HXvrzpDAh8clENEYVk56iBlvn6Rbte0erV7NqVQT1jONkv9OyLbnXbR4WEX6QGDDCY8qKQerTflUegBOx9bwgFZOKouF8Pw1eZnj7xIeFvaNjuX7nOje4i8PNjWpGpsXx888HtoD7Nf930qOkXFxp3EL0AsaIF7fpiLRUD/At4h6aZL8ydgFjmJds96aDMtPx06j/nXsBRf7nhszytzbaTsSvefwU0jFpp5id2EalKUJIRNi/4gsc5oyuEILo6EuClQkt5S2FXrM+GB+WtroO5f5syqgIP2igbW0Ycy3bRAg2RcYBuqBjNDaevPJ9fI/MwY1Bh3WL01e2pyfYzyxI061GA/Su0MDqp4yWbc1wN3VUWs57siExwlQm18nmzjcN3RrkWvsuE6VCx3MwJpOUGXgiXMWEU0A
 43ZGaCYN
 YJDOIjRKstZnWVVhAWU380nvw4XfjhPRqv5hPIgmf8fEBw5cPuXu1PXK6vNoxHFcb2rNT8oo7ApIvwQISyqFn2li9CRvvNrsxtCs/j39cqJmRRAOdpBS/hUtxlWAApeHwL0d+O0f0tm9OQ3BCH9ZmoaBC6S/IFCw0HK57ErYhyRJV6erhZMq9ZoS2GWHUWRKeLLUz2ZRx1DoYALbyhBouoB2LVHomhBbpcP7BjdaRH5nYmA0QmJE2Q3msxcjTfGBJFIKFHExca1JmGkXhEJ3p4SFti16sqFz20+6TPBhFVjAep2NmMtm8mrN86U4WnXCKvKpGHCMeSA78Kw7dFh0UWs03FaUJ8iA7qbkyYNti0mqcRutqeygiVibG8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactoring luo_session_retrieve_fd() to avoid mixing automated
cleanup-style guards with goto-based resource release, which is not
recommended under the Linux kernel coding style.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 146414933977..8d9201c25412 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -291,25 +291,24 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 	if (argp->fd < 0)
 		return argp->fd;
 
-	guard(mutex)(&session->mutex);
-	err = luo_retrieve_file(&session->file_set, argp->token, &file);
-	if (err < 0)
-		goto  err_put_fd;
+	scoped_guard(mutex, &session->mutex) {
+		err = luo_retrieve_file(&session->file_set, argp->token, &file);
+		if (err < 0) {
+			put_unused_fd(argp->fd);
+			return err;
+		}
+	}
 
 	err = luo_ucmd_respond(ucmd, sizeof(*argp));
-	if (err)
-		goto err_put_file;
+	if (err) {
+		fput(file);
+		put_unused_fd(argp->fd);
+		return err;
+	}
 
 	fd_install(argp->fd, file);
 
 	return 0;
-
-err_put_file:
-	fput(file);
-err_put_fd:
-	put_unused_fd(argp->fd);
-
-	return err;
 }
 
 static int luo_session_finish(struct luo_session *session,
-- 
2.53.0


