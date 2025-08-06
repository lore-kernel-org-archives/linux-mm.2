Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2436C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 01:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12256B0099; Tue,  5 Aug 2025 21:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9EF6B00A7; Tue,  5 Aug 2025 21:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFF06B00A8; Tue,  5 Aug 2025 21:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D13166B0099
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:44:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14462160306
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:44:32 +0000 (UTC)
X-FDA: 83744637984.19.F46D2F8
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2A0E8C000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:44:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="d/2UsUoH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754444670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w74FIGq0AXw75gXfOcQZe3mmzfSZaThuFNuCPXvRBdI=;
	b=dbxlsnk3UmSHBTmV0P8t6ZEqqEq6/om62laRoqGIxi19w9/d6ln/ncmLVqdCs+p2Vs9cSD
	LGazr5/Sx7QES+QA0f209juFxU5cw5c5mTx0aUrQWKSBy3//hAVeuyeXDPzogc7WVX2Yh+
	oD9dF2KBCd7V3cKExEEbb2G0T44XkQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754444670; a=rsa-sha256;
	cv=none;
	b=CPIArQD2W2lmQasJNUpv2RE89fE5uVW3mo1gfbB9dIqBQhb/3WRd+VkHtZZefqgXJ/5//E
	yl2XXeOOmTCj0HDaOzJz16zc2IaSSKGiIyqKylpZ/AZwZ3I3NQb+sJ+c1ax85SXhvx9P1K
	eigaRZhn/Qt7XsOzl+D/tzJfidQvsCo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="d/2UsUoH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b390136ed88so4521064a12.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 18:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754444669; x=1755049469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w74FIGq0AXw75gXfOcQZe3mmzfSZaThuFNuCPXvRBdI=;
        b=d/2UsUoH3noaMLVyv3uzAw2r89VSSWR46L0Fo2WopdhERwcpLfZF4ng6xP7Vlwl8uW
         ocbtyX/UWc3nvD5wsX0ljYyWR4VUUCP/rAULUGm9RCru9WZiTFoTMXUC/p+Ume23ucvO
         e3RrUQmSxw+zJht7rWAZxVly94Vux5CEdLqR/XTarGQzYNPWg8ePouyO+4y4E9R8XdFd
         jB38kYSTp0Q8khCv/lhNWetv0GuzuwnM1C7OmgQ8wgk6wB3Z0qMfPD1XPPUb/R5/eHBs
         aCFnwYc45Esv/qr7ZLvdTDp4Zvw0ausMwEJFcn/XF4euyVmcOZi95GZd7WPaJsfRNGHF
         /bng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754444669; x=1755049469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w74FIGq0AXw75gXfOcQZe3mmzfSZaThuFNuCPXvRBdI=;
        b=jYleEXMXXqQ8yfBKm44lAXz89Bah8ZJzKF/f4iiiM8SDf1Sawm8sJ3IqKW2sPPLPE7
         E6ZTR5VxDhItxFGXDyElRGzbeQFaYhyhjqsTHSqPT2vV14aw1/G+J74PaYn/PQxRb1UC
         aurD4f7jx36uKqoRgqxAuMEOPDLSgqPQw5Ew4IgY4IHmoQ3dIuhcrx91p8Ap31rfcWdg
         UWvZpOwZ1LOGFFVI321Q6pN+3Gkvrf08D0Md18o3Ong3lWspNMDEQkrxI6FjEndOj/Wq
         CZ6pccK0lvITrKqMfg2svvEFMmFadbMntQFI6HJWBjcI5+PlZ04XdhhinQ6ILur5i501
         ODHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNovUPloftxVARcQvMyFzQ+jBDv0/L8eAMpO5HhoX5ixyHupmEw74H7l5luLTH6IVBLZBHAoq8sA==@kvack.org
X-Gm-Message-State: AOJu0Yy5ABQEbe81VLEnTBR0NZRDAsfBvHUBSZYMTqApN2vOJFb/EKcW
	lWWhk3xAJDdz3JWa42mdf79YmTTwXo0MuAFLKBfXmOu8wAMhapVW7zEP
X-Gm-Gg: ASbGncvwQQI/Z6se0InEamF8a5t7VzOi61P5OFvJ1Ig0LILz4tj0qY34paoIRJSmSr8
	E9ST8GD1F60nR+s2aOX3rti9LkLznYV8iN81e88oDcLmorwxxovt0ZlyydulIDR6zz/KRjcoLBL
	AiUDaX/sILSOzdylKGTVUBcr/T0l1rGhXh+BCizX/CMOeuKrbbb5MgsBe1KfD91u6OWTRtroEs8
	mVFwKH7UnX6qdZF2ItFB8f5WBM5cHCH1O29/ajO9sq1nkS/j5ULi6kw8Vpy+l+jvgyyQRQlFsXc
	SBBGO8pqKmU15i4FzLOP6g+bt5HtX2MNswRfLZ5xOxAoNTPHZN9OiBzmk68kvLFRu6bxB1NUtUk
	iNBnHBGbMnmb6Oh93tGbJvAXfGgiYcdK8muhdMm6LfTGb7Q==
X-Google-Smtp-Source: AGHT+IF57QVaXPLLcilicCteL+bMl77C52uViQHcrH/iqr0Corkc4MbpfAiii/PIkLD6ZK5p+aBAoA==
X-Received: by 2002:a17:902:f691:b0:240:66ff:b253 with SMTP id d9443c01a7336-2429f55dcfdmr18204635ad.46.1754444668829;
        Tue, 05 Aug 2025 18:44:28 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:21f8:86c:408a:124f:465a:e2e4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63ee0d77sm17890187a91.20.2025.08.05.18.44.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Aug 2025 18:44:28 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	brauner@kernel.org,
	broonie@kernel.org,
	david@redhat.com,
	jannh@google.com,
	liam.howlett@oracle.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	richard.weiyang@gmail.com,
	ryncsn@gmail.com,
	shuah@kernel.org,
	sj@kernel.org,
	vbabka@suse.cz
Subject: Re: [PATCH] selftests/mm: fix FORCE_READ to read input value correctly.
Date: Wed,  6 Aug 2025 09:44:17 +0800
Message-Id: <20250806014417.19918-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <6E5CCF4D-CB63-4E4C-BEDA-6FE533E0DFCD@nvidia.com>
References: <6E5CCF4D-CB63-4E4C-BEDA-6FE533E0DFCD@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2A0E8C000D
X-Stat-Signature: rdx9g1nzjgkp6qcmshjcybj8y5kztmra
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754444669-88667
X-HE-Meta: U2FsdGVkX1/mEcCk1ZwaewK+9NwDdeaPUUqD29j9Ud0xrFj6fIFGMmFl1FyZgUopKYYlvl1Btc7dUxqPI/p3H6CKaGYDN+91fWWdvIOvJ8dSNa32S8nJNCZ2tbh3yZthWAwRiUioBDUa1vMIPy86HoGhrr08JxHIHvkTz33pAg4FsjivYgsHAtrLN/shyY4R24k3yNwTfnouyz+eMltvpluCaT2IDAQvq0t2EFU96zkWQKWm5tLHRzjQYKw4hCaO0V9L6JRFOdVL2XmC6cVKlXy4Shr36UREyNgr467vb7Eej59kF4Xn/4TlJ4R5mKOMCZCkHKTBldmEUloqPLpI0QhO7uEO7T0lGloLWqaAJ3rAkfxKgkssI7sQuB77iuuEEcZbaG/PY3hkZStboGWAZwMP3H0jfWBWT22WCLWBkp77ji+/tCZAPVt4m63BCK+XQCy6kp/57EDB25KdlyPeP+9oyavsYUVTGV25AziIwbNoSF9BxqKxgQjYiBbgEK2ECp7jpj2VX+IKEtNbDFCBhhpJZeNaX/Mm8gi2pZXDOXv90AYEwD5CciWyCP+O3dTTd57YfzPDXhtGwHkXSj7aWlcYasn5Zx2HkJ9X8oPBtBjB2L76NTqG3+2sHGHCPS5QkccqhNzt2i2HW2TS17o3S76zxNg7zIiIIH24p9AlDIicMspZDE0cKyFgKWvzegZ8Kb4ElPlXDXjvlGQGhAqNwtyi/KtWPo8oixQz5Y++9MA28F0uuIDs11VquKO81ewHPeGIJXSNGeQQpD2ImqGUhmPl0lzz9RWRZjATAv9t7pAfQSK7iXVeuOaC3oN0jt5PBL95UNLGFB67sLI9JAbh1g1Bj9S3KOeHqu3UvprOkNIoNZxbxZ+RqV4sN8MsvgMVQ6deOPxA1u4YtHX0l736JodCqp93Bmp2KgTsrqTKJeNR5HNMvHHZxeJ2K6yneKzqwhwqWBqEXVC4ShSncVI
 /xLJNDNL
 0//mwuO4QblJ/1A80an2tZiLOoKRDxzuKcvp+5DjXoAPltuekzdJBOOA0JBjVDKJIePjuxCmpumiSnzNOVb2OYBb5u+G4cj9oVKKVuRaHfWVGK628HsYz949iRKfUFP2OegebVREfkmknpNcP+q1TOwrl7ZPgKLo5Ja7T3DILwI2PRE29TSfCuL5x0j817j6PSiNRo+JPXcW3Sa1BsBWOoOPwcxX1q6CGfu2Fbi43bfQJKGezHR+Lae+0yZKrmYy+PgM3v+dQhGk36+3AyRlCnYA+AcTTWtGqS6TFJK6tz01ujhcdXVP0ukToYemkpOn+pkreCveR7NOOpzv6hYmT25oli3GvvZFDBrbK72bIsRKEmBCTnv7oL0Z/8f+J2VaHzYsvaGcjGbysxL+3pKuC2MvEcq1krXM0zxlzWKDSlW7XxgmoWLnM0DXteQR3Nj9EvO1IX6GopkXiY6/a9d8/g39h3i/9f71kXkqwo+8IaJ6IkGco2EL/3xkANwZ0iuCmD+tCS1qUM7mIzoK8lWtKXWNKe6Z1fe67JA1iaXe8pEhjM/5oDcmBiDErieKeEY1LuPaE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Zi Yan, Lorenzo,

Thank you for the detailed discussion. I have been following the
thread closely and it has been very insightful.

Zi Yan's fix is excellent and I appreciate the rigorous analysis.
Lorenzo's feedback has also deepened my own understanding of the
subtleties around the FORCE_READ macro.

Out of curiosity, I also checked the `(void)` prefixing on Godbolt.
As Zi Yan concluded, the resulting assembly appears identical.

I will be happy to join any future discussions regarding the exact
behavior of volatile in this context.

For this patch, it's definitely LGTM from my side as well, so.
Reviewed-by:wang lian <lianux.mm@gmail.com>


Thanks,
wang lian


