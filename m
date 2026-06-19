Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629CBCD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 23:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5D36B008C; Fri, 19 Jun 2026 19:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ADA76B0092; Fri, 19 Jun 2026 19:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3764C6B0093; Fri, 19 Jun 2026 19:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13CDF6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:46:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87936A060B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:46:40 +0000 (UTC)
X-FDA: 84898299360.26.92B7970
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9EC8F1C0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:46:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iK0XazLt;
	spf=pass (imf20.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781912798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCxtqj2d33zC9laceeIgBMjjDczDED1aRQYh/m+NvNo=;
	b=7HdvIJTJthGUvCGmftd++vwdzlBNkTiZPFj4kj8JvF5q1qJdsUsmZuc2LSMwPeq3tZgf1K
	sFfQL9FR2j4GWnT9g1t4ZRI7Ny7fgMBAgactqIvYSRdYVXjqDaJVDkqJqE+jDg4EnQm7JL
	qbsyCZOQsQWE7PxHmPS1nZS3U+PfV6s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iK0XazLt;
	spf=pass (imf20.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781912798;
	b=t2XmLh67gY1dNduBGtVSBkgH7RzJHv9MG/RlB0825Gwj2V787VnU2PJUmYFJZLeTYMqIPk
	bci2VCgd1TH9YVP8zjk8RcHKP4a6+pE/ARmkBKjAY8yEyCzOaRjiZvp2xE9OBZaOxOjcb8
	NHNbEQnEvuhriBMO7gl3VVot6REbW4o=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-464192ab2e1so1562200f8f.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781912797; x=1782517597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCxtqj2d33zC9laceeIgBMjjDczDED1aRQYh/m+NvNo=;
        b=iK0XazLtjnSuW0U7EZ4fhvGcZwOqsmGiLPIOqWbqVUSWB6+tW361N5dhAfaDtUj93U
         XTh8E6mrDLr3muBQ25uvC2lf+V3VIx3RtD7HOjfYz3RH5lRS1Q/zVp7ZTkN4vZ8qw0eI
         j4ymkLdLyv3Y6MouwZYjQgUj7qpeDvnnIKNl9vxkrRxR1SPZ9a9L41GPqnmlWMAS3/vy
         U3cufSn9MB23iIgVXhXycfMzXKmCk8B0+wabM09mfnsqPueBwk3qrofz0VlpTBfTav75
         DgLVU+cRC4T7jfFrl+lIpyp7LGHRx9LK36fLxnQnkSn1mGOXPElKC1SJglsyKp3W8U3s
         wsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781912797; x=1782517597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tCxtqj2d33zC9laceeIgBMjjDczDED1aRQYh/m+NvNo=;
        b=LYONUdJtcLRPjZXZMO0ovbREy8+ZmkZ3UhrhuZMcaLipq6K3HtGvX02uuocuK3SqqD
         qMLQ854bj7k0xqiOJJjWe3VWJDTi2T6QUhmY+tboBi09MmfxuWb4zZeahoolapula7ns
         k6k+4b9oYtHC7HD24rAp3poKYTeDIqjQUSAyY3pjkYbcMawIcM0LtbKQwL6GIs7RYtq9
         NjI2PKv1V2obci4crK3F0c/58JumXVijtsIW/KgSXzdrDaZHDuKcIMQXSlB2aGb4NuMY
         7O6UWsegfyU4sG6UK72b8OL0SkhExYST+108lrcoh0U3gtah7BzWyDMbwf+8bztnKboC
         7ZFA==
X-Forwarded-Encrypted: i=1; AFNElJ8BIRvCsF1/I1x3sCDqjhRfTGEJpT4t79PVGRRpRACYPJ2Sh6Tmiir3oW+l5hMuj8jp5EOk2TWaTg==@kvack.org
X-Gm-Message-State: AOJu0YyJgB6u3OC/2z/XMLrJfLmJz03rQaxaXkKq4AWKtbS1lVdraFci
	vC2htJESmINmRWNzXo/cvH6yX6R6FjmWOGSPsYS+XHm9zGoFNSZBIdUs
X-Gm-Gg: AfdE7cm0k2BfJbSFzrqstzGE7jHehJgWFVFAIMAXHu3ZWKpISw45NX7s4hEbG/Tny1P
	skE/21ZhjKLjCiLbPHPOfLDJjowIlR6//mUIEHrSKswm3WLXNYRXFn7gDVly9J9NydL0cL6z79m
	TM7Nn9ptifCVJQG8MsZ4Kiw+MtJSmL+qJWjtMs3syIAqsaXouzlSSSzyiVxt9GgI9cqGKbWssRL
	b7JtIef9TVb2MscJoyxyABqojSFwZPAdwBkDxTAcqkQgZfiJmHvN/ttGtMG4Mlygy8WEIe283CQ
	gDmsMrrGiM3iHHLHqAx/OJtyA1fLcAIQTiZs05AjzwM5WdpC6hH+yNNKOE+iUXMdmeBi4zwPpYs
	7CJAMEBn9lJh9U7WCc3Jxt3WUWakAPnmOUPqMAxWhGi4CgLXvAPydrKoxZhl3EufbCukv2qi8QY
	VGxUCFD3y1qkc=
X-Received: by 2002:a05:600c:4584:b0:490:4e3e:b483 with SMTP id 5b1f17b1804b1-4923f573129mr96809455e9.22.1781912797246;
        Fri, 19 Jun 2026 16:46:37 -0700 (PDT)
Received: from user ([104.28.163.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466667882f7sm2868027f8f.21.2026.06.19.16.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 16:46:36 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>
Subject: [PATCH 2/2] mm/damon/reclaim: fix potential memory leak
Date: Sat, 20 Jun 2026 02:46:06 +0300
Message-ID: <20260619234606.221163-3-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260619234606.221163-1-yahia.a.abdrabou@gmail.com>
References: <20260619234606.221163-1-yahia.a.abdrabou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EC8F1C0005
X-Rspam-User: 
X-Stat-Signature: s5rnun7r8s9ynp4bh4oe4gtczxg54haz
X-HE-Tag: 1781912798-297761
X-HE-Meta: U2FsdGVkX1+kqteRt8WitrwSRlCctJKznjPfpRRc6fPHaEIrXWrqwPV4vmxnZ/tZj8pL++2UaSj5MxtIiNy/amIoDwpH7r/4G5ts5H/+iyNryO1FQVcpo8ODC9dijREeG9wxm0ZuW+lHZN+2gW4OuOCB9WcSvkHVPT0ic3xlnDNhxt3XYmLKqVzCJx+mY9SW+Of/q0k2aWYhEObM0fxm1zwxG+O0g0TIojgYzI50/PwNV3jeSABF6IVhTRZrB4xwRZ5puZ3YLV0X9A/yWOMJ7RmgCb/qCir8q4SxZgU7hEsx1rJtC5m3kL4YDjxweyc1WhHW3mbQoQV2bFxu7snOiS52Bn/NiEZuhmHq1UdyiYVT/OkQzGPEHJNlpw+mrUFpBE1Np+/c/TE/ZxZ1af3dU+4qiHls6TAArkg+Y+Xsf/pNdJR3g6AkDkQfqPyaZpyE3MNmH8kDILsMecFVcW/JC7+0+fWFRSxGpLa+8ZUZ0m6rvnnvecpLfrCrkPhrK83fbb7q+3aqTA6b5n0bi8Lvxae+NvVkk/1DAgSs8AiDoBn3SC7VcM5A8ynKJKBEvxJV1/t9O7UgSBNKqqXr/ecOwuNUN83nWRPSmBEdRK4BbllPQpAoz1kh0Q0pzrPMpAXatMzHXpn8aKfqgPsrfpyW4xxyN20dBhx09gM45jwVY8xv2oGgyeYqTFD8/jVpjRuWYcxRxjlB9lmtCD8SdVvLOaXBeL/jkxEP+kNesZuAe16vltkW0Gh9KXWNuBhBdecCdtCZIc8g/NlOcbV3SyoqSnYdXqFF4UbLpjzPrCT4hO5aOy3l1K4xtw0lqoNHVIxeQ+ZpoE3nJnsi/LuyGEy2z8jbxL8hBlMJdprO5eJQVD8tBGNrNMY6X0VCeoPM5leA9dEYknHguFF0Y1OJM7RLlqdfjxpI8/SKOxtFcu6EnfkdMwSmjsLCfpWMkMizjMyVcvwWeKVDTIo+aN/Dxts
 YprxTYaQ
 KM1XyKfxo3yDBMJIHewk+cYlpk0R3qUK3/nrHCtp9FkKLKEM0MR2nU4HSu7aVf1TY7EFbr/4lH6r/1lOLfvYG3AaMl6nB4DvluZG14DHq7+q8YkY5oIiaUlkKbEmp7vc8k2PU2svJ/Iz5t/tA1s8tCXM0bOCKrcKkBA76q2ZWAVFmlmYdHGFD9UOTOH1pZCIyDR+ChZdl3ahn6c6Nu+QpqbbhAxv1vZBLMzWQZyXzFNibwO6Gabz1QQLrA5MJci/6drYa2Gp6lLl/pvKk7iTczK31swXKdGn7p5JHwptEVqTaHOjK+/dEQfmaIVf8J1wt7Mip+NqUSxI3K5ruWuQzkB82iQh0g0u31EnkSgtoH0MdPDp6oZ66169G7cjkmnSCiwdl4K3F9GWPbv/pbeAAH5l4i4iWUgWcC880aI9FEOwsjo5OElJGBofPh2Mws2w4lQzxHTsiNlbFAAMPzzPwU6SF9FnpE/noM1IwwOwZdDCB6rUzegiwrA/PfXwVvHiYnq5dwVv3CCqZoCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

Fix a potential memory leak if initialization encounters
an error, ctx won't be destroyed.

Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
---
 mm/damon/reclaim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 15bc06ae7505..dfe52717d92c 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -481,6 +481,10 @@ static int __init damon_reclaim_init(void)
 out:
 	if (err && enabled)
 		enabled = false;
+
+	/* Prevent potenial memory leakage */
+	if (err && ctx)
+		damon_destroy_ctx(ctx);
 	return err;
 }
 
-- 
2.54.0


