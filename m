Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75AAEC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7326B0095; Thu, 27 Aug 2026 23:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456D76B0096; Thu, 27 Aug 2026 23:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346EC6B0098; Thu, 27 Aug 2026 23:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F042C6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:50:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 708E0C0375
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:50:56 +0000 (UTC)
X-FDA: 85149302112.09.7CD3DEA
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 95C0540002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:50:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q2Q4D6Zy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787889054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4Wo3AFVWJoN6NjZ+CjXyOXScjwk81QQP/wB9zVSLpE=;
	b=bO53nMEevBsxrbmjJEVQuYd8GWLFid5De+vozxPXa7tMOXxcANMBNUz6vwtmVipKaSFJTW
	nurB5kmZn3eWOqW2hzAhJHeK8UwWWC/KGWFk+KxxdZdiiFHdh4VFu9EX3B09tnZhcYV8wL
	T/DYUBYTlJQdB0da0FGxQWaxG9LfgMY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q2Q4D6Zy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787889054;
	b=ET/ydcdIS6GGzpMMAXPs2y0Tza9i/Ala6qnlAbK7XS6FHnO2oL/CdupCvJVaw7rBmPMY9z
	It+AQdeCbrHWPDSjP2sNQm62A+6jiEyNh9JIVW74g27m5196w/lynQCXKhOlj7KBZBrU8i
	IKn1127r/i28V/Db9qR9Y6N8ygt+54Y=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so1386978a12.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787889053; x=1788493853; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=x4Wo3AFVWJoN6NjZ+CjXyOXScjwk81QQP/wB9zVSLpE=;
        b=Q2Q4D6ZycMZXQC2T8IumRYfXijTOUGsyGzoFmE/K6YdLgcvHT8OeorwPpzGvwOudOJ
         wYLSIEh5JZ2YNFkpONVQER44wdlPrzYrPAOJqzHOdVc6H/0tAq2xcXlVizN+r3DfQk2Q
         368ee/wg+tka5x2R1Wh4nSft7s7MoG0xyrPQSm9SXnw3i4M+tUqxdtbyPnSXridaEXcQ
         xnsQqpnaMMQDX5S7+ypkhSRC8OByve+cIXUeQo073hPjIMmXTB2xuCCLCxcvHrFqB++p
         IXD/SYL0hBMjsxeCf8InylU5MneXP4yvCH68Y2mM0choXIt8Al10y75oUXxKDQWpTA6z
         mSCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787889053; x=1788493853;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x4Wo3AFVWJoN6NjZ+CjXyOXScjwk81QQP/wB9zVSLpE=;
        b=SFA8EdeuKNpaKeNZN/3zZaMdkwNqZ2/ji3qwSCH+9o5kdS6uPEYV4IH73dl5Z8/1Wa
         lEWwktGteGLYJTb0MxvQ7MkTuhOPKePEDy6rtb8WZ9A9HbN06Qpx/vX+lfjrLY0gB2iG
         dgOKPIyAsY8tH+PR6lT/ktwBUaWQTfAEBiKuKl/+WB0YEMOSyF29h7vOMHCH678S5as1
         sMiePTMnHEo6lOffDeit8XUkmKiBjhExIlH6g+qJ3YrfHRVzBoD4HpD338vnmcmUAuMp
         pGASdPGwBOX1mcrgTUr6ThledADf/jTTYr4QzoJubWYQENXk3PIk3nRVfh/et/MbwUAz
         gTDQ==
X-Forwarded-Encrypted: i=1; AHgh+RoGMl4bE1XeoHIk5lk5AxKtNiiPgchbb5rMLkuhhPicdprkdc7LNRjFehBzzllMbZQf4oTh9ix+7A==@kvack.org
X-Gm-Message-State: AFuF++mW3qXyH84pbfNtAczZMSLlLOiieYEiSWqee6o6NWBAydq5NMCB
	mh+lbYRktMQjcpIANSdliB+lA6vALIz0JyqwGx4j+XvW6qs/wSQgNxBF
X-Gm-Gg: AR+sD13I0BwiikejISFcjwuhGhj/2Q9lJa/Ljmo2RCkf977wkbT7qibKohQ1zKZWUxh
	ZMePnwqWcTtEdYE6fEhtsl3z+9Joe/8ywwQiagxFhPqjjwfJXgKuDaaQHzAGfO3tAM+0P8nyV5z
	V7leD9UEHo+Ti6QRkG4w5qRiKjfz7X/Dkd0qb9s8J16pHZN6QUEy1oUqCOdr1s9/zZdXJ5luDTp
	7hI+VnSCHFgYVtVK34OvqfReGB9TNIXA49rM7jiJeEYsONDt+BiffBnXQ9zuxvZQ+22o2A28N5i
	Efa0Y6ZKLYM+AGdMnveXqyfQ3VnylvCNJ3914mIwixm+NdToSnV3TwjrT9L/nAY/87ZC6nFb8BD
	PkkVRQvH3UkmwJzTPBG2wwZcNHWfMzW47aCsf22g7IdrHZqeZXKeQnT1LH31YMpgvS4D/UUI6Un
	YAjh1vEtr3BkWZ2wPa0RambrABv1qH8+ZEa6xvhT2a+b0mE50XQBtrxWKNfeF1INBBFw==
X-Received: by 2002:a17:90b:5484:b0:36b:de66:92c3 with SMTP id 98e67ed59e1d1-3969bc0223emr15330087a91.10.1787889053319;
        Thu, 27 Aug 2026 20:50:53 -0700 (PDT)
Received: from [127.0.0.2] ([73.222.46.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0e0e67dsm1659184c88.15.2026.08.27.20.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 20:50:52 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/3] binfmt_misc: only let punctuation delimit a
 register string
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, Farid Zakaria <farid.m.zakaria@gmail.com>
In-Reply-To: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
References: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
Date: Thu, 27 Aug 2026 20:50:28 -0700
Message-Id: <178788902858.3236768.15019506644956689303.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cf998psbrjt7z5smhtghtnahksqwfjxo
X-Rspamd-Queue-Id: 95C0540002
X-HE-Tag: 1787889054-817554
X-HE-Meta: U2FsdGVkX1/GFFyXRFM0iWkhd1KNMESRu8s6trqRpyKGFwgLHpwc3lCqXsLmQt/RIiIFJIu+9Ogu0kuQZ2Ev3P+NZ/9g+aLuihwCVFGBX+DbPzm6HvbfFlbczPwBem/KKM03TjEYBvDpPVJ/eJPfiZSFMLVvNIP/A3URYpHzDioDd1IlRInBr8jX6g0RpQFVl/6RrQOt9XmlHkpf79qdHemTYVhG9bzH2pAE+CqYXKZgBEUlJqUa7dFJvIaNVN86NKBES1c3xg0axHko/sG9vaE3fOGdTQNy3E6HmliXY5DG81Ptr3u+qisduBgAE1JVUcof5GffxpLmAbESl7x8tFBqDaO2yrJws0H1ZieWqxBSEfdZxF+k74dpHxCq2buX74qXVyGbTfa0vkHF77um0npNRzHbA7Wt9yxvQxcgO9oVUFXBKiMLkIWdGujdqq5S5drcd/GSS5bKirKxrX6CjT+aNzDTi9wRB4bZiT+2McVkFGwfEvESQ6b9bC2jal4e+B2XpvOVa3laGLB5bsFsKyeQdakscDIVrmtvS4FG4HhC8rVqvsUOTYqLRF1LIJd7M26j65udq4SVTCOGx6plAVHFMTruBNHsZOv1iZWbIt4uMEMYzFnAnh2WkuPOmusB/+AEWYwgt+FdJGFEp4w6Iz9jXEjtZ5J1WC7qrE6JuosOYE1zNBLoBKoDiKCixRgS0TGvHK55CWrjfkXK5x9qgi4JituqW/TbzXpc1ExZlFTojaORe0dVnYDsDY0KJZW053UkRx3owuCqpLwBiAGP73fgxIe0u/umQgPBJJBjFusOX0UT6l4/JX9EYogWkdsm9uTJhel3sdMoQMSbidM5kP0acQbFoPKsb7KkHQvLNHStSBWQu6oOa6ox+UpzajWvKYth1vjIzhE9bHFvJ1y8PIWCf8cYkP4UMgV/KqK1XWPgDCo1MSyEJIl3rAoyAOBiGSvyFuAN2/7JrIvEJVh
 yP7fE1+z
 GyA4Z2GQmLE8s9DgFpvJ05MWdtf/7n2fFNYLPScDG2QkKMQG2z3RUanYxovtMCSJKebpRycDVYkFnB97lOSRid7hTEJErzjT3syGP0N33MF17NetQpWbCHznglE56O/mn5DYvroT2gkNj6WngzkH65Zy07WMCkDXd3VwRUoy4PRuqY6PBSHKEo8xtb+eCsjvHpM/GpWSwgFdzar2BCd8M4D4sHjiCR2XtCVAUpWZgxp5dnz7pEc56b/UBfqhUobhitIDM6DuiPnAB0l4NfpZI/ve+O84NkpxfAjEs3QjGZvg5TpGF4WQg6jHeUXRqHjWItwJ/+K9f5QiaD2+peeyL84xYpDKiLd8rzscto0WkWnstrbfbS3ciqETFmHOTlkwfh/ThLw0WW2tk+XUxc0pRn4Lb5V5kymNmgE6ugc6c6T5A2O3r13dl7RMct7hqxinLt8E5mbBfRbbLDQxNfhs7evf6PItVNXfmv1ecUk9y4yAG5ClA5wJ64jCYz2PgSL2X8LwPCefPhL9LblP4/af+2WCAF2mPoRw5JX4dmgtlP6kw+5Co6NFXcrh7Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 17:55:45 +0200, Christian Brauner <brauner@kernel.org> wrote:
> [...]
>  tools/testing/selftests/exec/Makefile            |   4 +
>  tools/testing/selftests/exec/binfmt_misc_delim.c | 127 +++++++++++++++++++++++
>  4 files changed, 143 insertions(+), 3 deletions(-)
> ---
> base-commit: 66498c75b4f8017f62d720d9b59675bdf3abce91
> change-id: 20260810-work-binfmt_misc-delim-83f62cbcfe23

Makes sense.
I think it's still pretty accepting when you consider all the
punctuation characeters even allowed :)

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

