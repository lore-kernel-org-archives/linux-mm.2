Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362E4CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 23:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A896B008A; Fri, 19 Jun 2026 19:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB4E6B008C; Fri, 19 Jun 2026 19:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C018A6B0092; Fri, 19 Jun 2026 19:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8116B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:46:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14A591205E5
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:46:38 +0000 (UTC)
X-FDA: 84898299276.10.2007B21
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 313CE1C0006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:46:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ROlzD9sz;
	spf=pass (imf21.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781912796;
	b=NGwuXLekjR9z2mG7vrpelw6lbxHlqX66lLI6m8ex4Tyb19nFUGX5XRUno2D0Zb4Oe9glAL
	n6XxKHihtO+vrKc0lpVrx3l8w24WMPPW8IyHFWDuGQqzJU0Zu4p4cZULxW7pvDkzcGhIk/
	45TwmmRnqBK5gEBKq5dssq1ezAq+ajY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ROlzD9sz;
	spf=pass (imf21.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781912796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVy21SE4M2vsW6vYL3d+PXiTMxevRAY3Rjncmv84CKs=;
	b=CTzNaLm6Q8DAehpI6h22WGKBK+wDSdyIW2KfMPQvp+rNMWblEWILuqurF1txrwrZ3a23WW
	m3VmnrJkr0k3Fpkj8dG0Y00Gued/lI8UGnI45TtoSJY/StWvoUU+MohWzhaVgSEh5FPZuU
	rJHdbcxbq8CRIx8eir4fr2UDkni+bsY=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b211ee6aso17342815e9.3
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781912795; x=1782517595; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVy21SE4M2vsW6vYL3d+PXiTMxevRAY3Rjncmv84CKs=;
        b=ROlzD9sz+vKrqO4zlLIjjYE4CWU+zP3GpwydTHq3fWFaSXpdObe+NUWKqGLwHf8Pll
         EJeSNtkFYwenRM+u8/o5KwM9HSCb0AcvqOV/Ci0yvelrVJ1sBpb3Ui8VP65MLkOKrI4S
         kKIvWTZgkTVDrMw7/8cEvW9I+2G053wsABaR/cGMT6m4fWwzzv69V+g/bOtgeUCxPVK0
         RJUKPYN871dGv0ei/YRJHDNZimMGOMpQnI5a3phNkGLcAQjRZsmXLd5ANicF7Hg9tmEm
         4VmvEhNx7fWm6iywcaE4+2bF3zdJFkIFeGZX3YUocEeHiphKLlGdl5XiEqduCsBS3+09
         ww+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781912795; x=1782517595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CVy21SE4M2vsW6vYL3d+PXiTMxevRAY3Rjncmv84CKs=;
        b=NjT1JjMZk8nJyb4TDgAEWbOXlJf2wAfmjLbw+qbVM9J4PCy5YUkl4+GWMcjjLl5VGX
         dO5n2zUytkgek3Tvw6iyNpxSOt7F8GuW6glVb2/JFJj8DLrbJNikD02X5LQCM9pt5+TM
         IgNg2ruqtebSgcni6SxEDI9U/A00pV5+Suu9WL76bMpDHKbUYMfpey4pQyy8ghhO9sOr
         uV0qSpBNn7bRTIQQg+1bX+rtxxSU+myFlDQyTtEv8volsAg0UMR8clgYCnJz3DFlK4A8
         RNlt+kFbi8f2ZYmYzb9VJzzx6QE0uitJS12UpqTEfET77FP2kbFeNBSA/PUICfrn1OUq
         1K+w==
X-Forwarded-Encrypted: i=1; AFNElJ+4QbaOOxd6T2olLgZ4nO9BdmJelg7JUTFmqi1rX09UlkcHoSakH71O+cFxpm43Thq5v2EKsgaJNw==@kvack.org
X-Gm-Message-State: AOJu0Yx/iSOaW+VxPiOaKGB2ygjOSdewhivL9/FnFAHG6OPyu4LdFHyB
	5WaOZXkt20BO8FcbLLesAoIOvjQ3WUuk+U3VBR3B7taW4koQpsxW1BNZ
X-Gm-Gg: AfdE7cncdYKG0pXmXdWZI4X5CHlRju2leS97QKhKRoBjMgjcoSLQi9CntxBkkRaH6B6
	vnuXB3T8GXYd2Kl9cATCAdi3hkuivicuINRGkshtchIVsn/UOkPW+vKgFqfu0V9NF3SV5GAtCVA
	XC//f55mE44tblGzgIk1VhnDsOE8qIGeuFDX0L8uYcdbVAcHwfS6AtBobvJ1NrP3ids1cyNFbg7
	POJvGLUrMn1AsbaDlCrI2dPbqz5ip49pYQ/HrYWcuQbJ2qpOc5thTAY4ffbcsK76B7CdObKyHPD
	iBQIhiRJuJyTaJNH6/vptxKTtj8txxPfSaUg/Jr1thOlShCZFi+78SU37tKVr+ivdW4/8tSneq0
	Rp3ISOIZE4EbAwBRUqAQUgEpCS8ZdxU1Z/0z/DCC7aB949g/W6q2iNQVYq4KYPG7jRiRxv760bZ
	XopKUFyn4udSk=
X-Received: by 2002:a7b:cd0e:0:b0:490:ba61:7981 with SMTP id 5b1f17b1804b1-49240e85d64mr69314975e9.23.1781912794516;
        Fri, 19 Jun 2026 16:46:34 -0700 (PDT)
Received: from user ([104.28.163.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466667882f7sm2868027f8f.21.2026.06.19.16.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 16:46:34 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>
Subject: [PATCH 1/2] mm/damon/reclaim: fix destruction of ctx
Date: Sat, 20 Jun 2026 02:46:05 +0300
Message-ID: <20260619234606.221163-2-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260619234606.221163-1-yahia.a.abdrabou@gmail.com>
References: <20260619234606.221163-1-yahia.a.abdrabou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w4ga3ifc5wrzycna8k991hkeyic597be
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 313CE1C0006
X-Rspam-User: 
X-HE-Tag: 1781912795-838013
X-HE-Meta: U2FsdGVkX18ZvLvZuxAIvr2oXdeq1wWpFSQq0zbJS6cV/6zaoTpxJ0pFNah9RFU9EKQ4E3zDnjVS9rIDp4ao5CgYySpRK2ARlWvzxjOkn4xGEJWXES2iXMk+7BA/wqvtVVjIvGc6WDPIeY7BK5T+Ddo8eo3j3aVe9xIM8qIosCHArnpAJ/yiFAaDzZjPzwn46SiuF3+2DJmZjG5TrsHqusoIktP1hilEOeKTIIuIRoUJGQvl5J0/iZHMISHJuQCIjSsty8INwMHIlhCC9vQ/JINxOhIRjzdL4pyX3CxeuSSFHMsOEdPaTxHhxUgLcLM1zXSenrJEZBUw+ncFLHMHB/ru8HF5xoDF50gXBK330mrIjqnxkY8d24yqOdbCf2RgqITlCcpowmhvBDdH+gShzafdl6UTvYiG3wAOX55lijm1ESniGSjCKUxqAxy/3J2mrJLfGYGSlu9p9ejFG5azIsx0eHjtJ7ZMCOXLdAiuz4zmyFW4FxmXIvMswKJye4oKltR4Lysk0HJacjuo2JijVzLVFSQFiGdS6/jhTZMF0jw15Mi6rBzQnaYyGFmkicySvjIBUsK9SRXTLopmRWBnAj2RCazzLadjtX4dsfHX2GDh2j+AYDQgBQVLMLwesQMVpSxtbkiaG/ZTKEmkbiYR6ttwiAXFd3n84hjN/zQfUbTOeiFJAHMzoTYsix74sXgB5GMt9pi7Z3EdeABubFYsYi9q531MIcU8LGDRxLrOXmLlpv+xevnf5177reGnJ3iRMdKyUHvdSyzNIYIsR6OLOQikHXNfN1lPjbD2IMh7msMgi5dzSW6YaQAq2GPXAZAmWJJLDtx7MRnM7xTMf4IR+HL2e5vhK+MxVf7aSHEh7jy7kFmz/zs8Lb/OzBOOjMXxqSxVnlpnlMwYeqIetyz/PfG3Op/35MKzPrpCjptXFHnwJJ11td72UbRqbdl/gRshkcZTOdDMdpczDmaWJ3u
 ITl7D9wm
 RIRIMDupURgJXR63mXpa6WoEbglgJhkcoyhwstPYpMPpVD7oatMZO2D3tuOKLr7qIWaDaHQCJXzv4uFPTW+jo1YrXHO83aABdwt9Qn0GO4ber5s6ai4dtNsZhOmzXKm2ctycnKEJxDWE8af+qbWMApopYhKPbe6dyvZElAccwZTeqnTuuA8c4BNbz34SxPbPi4q0Ju1UitquUwOQxg6QpZqHfwZcIJnDFSQA5YY+N00/4L2B6iVeXRNrhfx0fA4ZpuLTyY1MKWo14giXMOycrV30K2Azww55VKDqOuxJ/YajLDJZjYfztsmt/Qh0Gn5Je8hUho2RTfO9hogepDA4lBM4ZmSELnqIvvjrwRFDcKI7c8yNYgL19LMblKmon8nvqR/hp7cTCCvM74eXv0w7NPVc8dYICvSTA25lNgHRVYjdr5+8XTBcF6soHI2uqVhbkBgsOdK2CAlRHfkWgEUH0atZnpzOBIl7iyqhlwCGgCMG34nRBNsLEkpmku/0hv7X7aCZzPmkGUmW93P4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

Fix the early destruction of ctx if no error was encountered
by returning 0 on success.

Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
---
 mm/damon/reclaim.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index ce4499cf4b8b..15bc06ae7505 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -268,6 +268,9 @@ static int damon_reclaim_apply_parameters(void)
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
+
+	if (!err)
+		return 0;
 out:
 	damon_destroy_ctx(param_ctx);
 	return err;
-- 
2.54.0


