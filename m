Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D02C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DED36B009B; Mon,  7 Sep 2026 02:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7426B009D; Mon,  7 Sep 2026 02:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE0C6B009E; Mon,  7 Sep 2026 02:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2063C6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:59:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F37B1206BD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:59:17 +0000 (UTC)
X-FDA: 85186064754.19.90D33C7
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC5D020008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:59:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XgilNugr;
	spf=pass (imf03.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788764355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9cOmcuQayUUNCvgq+25CsYuokAcgEplB60+U0kvgEU=;
	b=E5HKbOpix7fpzxcFtYkSeQy68WAfuHa0/tR7v7sOmeEKGajpwz2Go3F+wgbYiW/6VOMzBt
	3Wg1rMKqewW4/SiMdHTvIoN1VmQ4vQzwv3nMg2x7xKVjGfyTPXdUk92qGLh6dmMTd10GEa
	KETlC7+Ilk9mNQc38W7iqp+Q5jSDuY4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XgilNugr;
	spf=pass (imf03.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788764355;
	b=GEAMpcMlfmwtxS0b7sCmtR4FeEXcMLPsl1ow/JW+XXT4okzZLUtk96ZGticeCeB/Q0Vbvx
	4KGeS85ky1kUZskBSjYvS/f/f42wLa614lCw63LIDWkZrl+xNnyejyJHqdLCgZE5PZgTSG
	eUJVZlVNAiOXhwv+0cvk+tuNAtSOCbk=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49d036e0e99so9004255e9.1
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 23:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788764354; x=1789369154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w9cOmcuQayUUNCvgq+25CsYuokAcgEplB60+U0kvgEU=;
        b=XgilNugr2ub32CIWKZq7v3lz/Lfl9OwhQtxisJjrjA2FhgAntwPw4v70c3yuHLAsl6
         LDyh0bfptgOPzB0oQlaXLbQfBXbbuCTutrFdpWD5PCxAxHdzGUD/0BF4VzG9QHIS8veo
         pk+70QqnhjixngSZOMYLvLVzCzA+e3B+Y9MRAwF4M19SU15/bDFP7UCw+zY49E5+KZpo
         625ujePz7R330yE/YfcLzfZ8gC0Rq2HAOdJy8HN1p3iyrqmkA32OVgz6qmETuz7jCwFQ
         dI+yBiOEn0LjmWULqQiQ7DNA1lGP8oBIJF8YFrdZLkZkigl/4p9MCFBj+nK5sz5S9IDV
         qXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788764354; x=1789369154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w9cOmcuQayUUNCvgq+25CsYuokAcgEplB60+U0kvgEU=;
        b=QyH9xn6Txnf1LeXuw2+PrIgX7R7rDrQySzlUBqnrM/6VdlMF4FJgpC69/1u4sKxvWj
         CWrdUNf1QdsXedpEvA/C2MPnZRq7x9tw33MfaGY7BTdSCzZFvfPknwazJsP4ZKcaY8ft
         uywEIvS0xCY2sHsq4R8A48g9Mo7pBmZTrImKJsx2kUd22GzCIeRMpMJZy4xBAHu/iWeI
         QFkeMjCAOE1caxYcLUEIlO5f0FCSbsyAR+OduVr8uZTr7rOzwwLKoVq0/6WQUVXzKMlF
         sl23/+8mAjA0ZfAcs1GVSVqs9TYv0V4lea4o3wHx5WdMFWWCpRbvKlEJwhDc6abj+i/C
         J9Tg==
X-Forwarded-Encrypted: i=1; AKwUvBz2HjDgiDc9LiJdD0dN/RmSLfBjAfdWFdvVnEwD+Khxj8ldfh2A7/oV9u1uNjRPdsyDjri9yZf8Gw==@kvack.org
X-Gm-Message-State: AFuF++nUMlh3PdsUF1wn3tJUWf35oMy71pSMxF8JCN7AiwCvU+soaPPl
	zelP07BNKtcOdXGQcGLaejSrZ7mDiN6sM5H/B1P/Kw8hWJv5ohUQ+TLM
X-Gm-Gg: AYBFou2iTQB1h6LJsRAmGaC01e/ZKSKGGBPi0lSvIvIj4FB3pipV9wpfET+d3wGZVtj
	FCoeB/17TGlsxO7vGlOCjkLVmgQc6zWTmTVzzaZxpcDki5T7VrCqwTkYR8wF7A449HX6l4s27Rr
	OBv0DhMWDLEzrrN5vNcSVqtD3oHt2i6u2Ij15af6YWBklsDSeRe8Zkt7YYfn/FajzRh8n0+iABh
	gjezkijerYS02NK7T3drwwjHgfzoLW0BzZVrzquJ6oZiuNsDmu85u8CO9uTuQB8TF25bWOP/c1Z
	RLh5BHgVh/lCEzj7E8wJm7kUgxjP89yKKWas7/RTyN9JD3OszEv8QBVjKO4LuFhk0AwrZLVEmJq
	uOEi5qktPjc2FwMriVmeX3ZE+1g2hRjoRoemvapqbEsTnRa6Q2xHqMrdLGnisfrLXAz7pn0jHVX
	j5fGL81bji5Yx1ngoKq9DwnGFIEwWP/suy42Owfn/7IX+agOi6RbnVCMRuX3/9jjPdh1pXxCyE4
	g==
X-Received: by 2002:a05:600c:34d5:b0:49c:fc6c:bdfe with SMTP id 5b1f17b1804b1-49cfc6cc085mr168534645e9.21.1788764353895;
        Sun, 06 Sep 2026 23:59:13 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d057f4778sm184723965e9.8.2026.09.06.23.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:59:13 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: akpm@linux-foundation.org
Cc: andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v4 0/7] bpf: Add user memory access kfuncs for mm_struct
Date: Mon,  7 Sep 2026 09:58:41 +0300
Message-ID: <20260907065841.4129-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904112643.73448e55f788fb1cdcdd12ef@linux-foundation.org>
References: <20260904112643.73448e55f788fb1cdcdd12ef@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1m8qqfnsh1pce8opxopp1pifqtz43s6j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC5D020008
X-Rspam-User: 
X-HE-Tag: 1788764355-215161
X-HE-Meta: U2FsdGVkX185jS3v71fDQC3DysMNYLS/D4MZs7jzfT43lJ2uexQl8/55roPVMX+mqUbYy1xQh6cSHru9s945YIwBiMp95TCe3Agbcueagm7pSx5SMeAUgc+wtdjF3T5rrCeVvc/3NFlFrFyA8ffBSfhXPA3hzLis7uaeUTfQkYSKlbsc7fRGbSuwRkKOhCvCM4/D7XHpBOw9ehb0HzpLo/Lw9jDJtokctlJ0LKsDTK6wQiaVmrrz5kxcsPfVuU1nd8PSPAFOl9cDqj37BTmjcqThBVYsjN1jsqPzEW0Q/vHVKRdfSJUA0XG8SnEa64M4KdUAlno8CfrfgMUL6wYmbRM/UzwuRCDWFeFQE5/bo27VjA1khK/EWEXwrhHeiGXYIoG728BIiocQGDkkZBKmBo+VE9RnHiI4I6mzxatT2x9P32/jbzBXNmR3HB7VibaTaBPEk1Unc468eSyLIWE8uvzlCx3GuxzrZY8WHnh8FF2onEPNybYQ2wAibyqGcUGQACMtF8y/E+QwWSMnDX31SC97Wej7pWVX99My3Tla8Pr4AwMFvX7PAtp+60w3TWYl6qgW5Ulo8Nou467bXl21pu/s3zTNbvZpaQvamjnzVoeSGklUcrVa42pCHMFB3N2nvp6gwC/efqXyZx3U3Cz9n7x0B9ec9ZK7AisPn+Cc860cgVmo++8KJ7oYPFuh4rJU2BWedl+lUKYRnbkQLquK/BsicIUpAON8kkvS/urkKFZEeeLnmCn5LTg4NDURMdfRsDH8kI+u7g5fsoH6WWhjP2PpUe1UkTb1bXPR1onTMYOqlaxVgj9PI7VhXh/kyB2ziAcZdQNwRxYjLP/RNIdIU+DOU/BMhASkc0aZ4cx+4RG5XE5C65K5SiDHNyl7otmVPGuZgvmgdeUwHeXRcSmwHpKOkfbyf4TM++64VEi+V85vjskfxIXHD2Z4snwmJmpv3+KyEBtr7eeNuwifBy0
 lVfkcOTg
 NjPRyoP3wIO8hpmpXAdDw5iXMfnbW3aBHrgU7kVEQ2comD/v73rW7YUgRVvzAAyEshY0G//BPBTeHq9zmQp4bq9euX+ItXxjPzAtvpJ7LKOiiE6sRzPKYinNr7qFwOioTy0MZStjPwU0zdz4Tl4VHJf6yGqGXmOLnu9HXTYpscZWeoBQ3VynPyJDXTt0+Rb58OaVkeofTIuuoWQtzhJBC0MR0HrHHE3UD47V6UtTDDQHhLSmfeJFy8GtefUegwPSDEIrSjrKIfDMSIGXOfADWwVUygqthZeWJSmpCa/uxR+UjixHmdQVyTqmK6AXdQRNZPo32rXGO66xUEJ55YNHZ3qsVas39vcwhZEHQqmLR5vUjEqOqis7lQezRjROdtH7937Z7E4kmBOtWlaJFD/nuFP8nQuxWasHUwulxbdoB/cyPMO1p5l9s14UdmT/7YK7CcHdIFwDZVpxT11PHBMV2U+JvzpAGE4QEB78//2o2lNcZ00dG/NRkpAP1Kl3Ey3BmyPSMmT2dKCsVnVftaWh371fzc5e1YqUf1/aVaSlUihe7nBvWuWIVWiW9HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Why didn't I get the usual bpfbot review emails for this series?  Is
> this a sign that all was clear?

The main work that I have done in v4 (compared to v3) is to address all
bpfbot comments. My undestanding is that all is clear now.

> I'm surprised that bpf even attempts to support NOMMU.  I expect the
> user/tester population is zero.  Perhaps just disallow this, if it
> saves any effort.

I have just documented that in the cover letter and skipped the test
in the last patch of the series in NOMMU. 

