Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBDECCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 06:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20ED18E000C; Sun,  9 Nov 2025 01:08:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BED18E0003; Sun,  9 Nov 2025 01:08:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADA98E000C; Sun,  9 Nov 2025 01:08:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E641B8E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 01:08:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B03B13BEB8
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 06:08:12 +0000 (UTC)
X-FDA: 84090038424.25.8E806B9
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id D9EAB140006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 06:08:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R1RutQ2k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762668490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G69bVr1VjY3rXYJFWqH2x9QAFvW62OSXLU6HasiAsNs=;
	b=e/aylccK57twqa/sPSStjKATRddBVQEQ0ObvzVORewNlEW9yZ8a3FD6F2oQoG9iMYUamf3
	LP976CGYAa5NUw7AL9PoCqNfPxqnzXMlHqECsoCZowzrhAUlJ5FwYbiYr9ZUyrpJTptQkG
	AMiZ7ZQTB6TQD2SBk3oPTxL7FXv+Yq0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762668490; a=rsa-sha256;
	cv=none;
	b=s1jV9aQkmd/Uls6+jrcw1KtojNOr7CrDbi+MmdYgJJRjxm4IQwla6R4I46JnFN7T7yIETL
	rPcZMEL5XOVEm+91FM6YrQo0OcgSzyOCiUqKLS5MbJrtK0s7yglzBSjVhnlTpqB5IYGpL4
	+tyTu7EZ+ijhkAnHkdr7LxH6aPyT5eI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R1RutQ2k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b9a6ff216faso1593873a12.3
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 22:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762668490; x=1763273290; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G69bVr1VjY3rXYJFWqH2x9QAFvW62OSXLU6HasiAsNs=;
        b=R1RutQ2knCHqxkuNZkjrjGbfeUN2rADKoyRRZL6VjjXT5fi1axgQtJ3rYG9NWNhat5
         EV5r3Vg2xZYUWGWyWojCgNgp7zxRVYfcnSdn9rb1UpvYFjmWqS5x6D9kAoztsosBhr8o
         A7mOmatP/SixaWVQd6syBkvwfGqbROxcdXnWn7vN1NaBtiBswEPni9fXa78D+nPz/pL6
         ztIU76OWcjcdCMMuetTXxXYv7q5/FeOFXfQjE7DTMGKCG/0GlwWtwAxHPf/+Vssc6KgG
         oaprp/HT+p1qjbONEUCv92hl3BWmFzKAeX6Jte2RSkZjAh63v8M7ewYxd048uokxnNUz
         FR8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762668490; x=1763273290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G69bVr1VjY3rXYJFWqH2x9QAFvW62OSXLU6HasiAsNs=;
        b=iOReD4j74Y6l0vZM+SD7Xy/d/hZr4nLnzyZDe44fdLfKk0LCNXtADECuK5ilGQb0mE
         qA4k4QAogwlKoy902ivX1dNM0o8Oe+9eb9L1NJB1am5EorSfYj6DRlJ8ONq0AN9XCvvu
         v2VDtzZfiZyA9z0Gj8EU0gphGM0PTtYn5QmZAMIFYCPPeu90EGFVHpWXC4x/clarfRjG
         yRZnsao15O3OxyDDMBx/b2M0RtzvpDy+QWJshOcIn70WcoY/UWme1TONW4stWY/cyLTE
         GuNcpAoh1fXbTN23BTO1d1JBv2lmXmJjTLArkDbO8+i7AmQtrNA8YIBVwLpGV1BVgluH
         slNg==
X-Forwarded-Encrypted: i=1; AJvYcCXi2Up3YeEEpMEpbQWPaz0UNmoXnQrgK3TrRagLRbUQDmKOVUkRllpfQcO60sQ/x1301W72zmfawQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3W7NYAk34/j0vyVRokoTJWgTBFAxuPrjRbaQFDt5lZSfdue//
	zLMgZKAcgVYD6g2iVGtpzAxgeV6GKEkMIr/mj1Bzrxr7TB6QZoNdB+pr
X-Gm-Gg: ASbGncvOGYyC1+jRlChbia9DKcOzLMUmoQrZpQ2tTSaiCs+W2mnH403p3qN0RM6x86o
	tW8Pza9K4VIL27EJJKQdPw5HXleBIvvninCDce8HvTemkqptKK9H7y6gOQ22Gk7I349J9SuEuRA
	2P6jEQy+XI44vopSyDYKYsBGmU4SYGSCTEQeOQsQYcVJL+s6uOJGGVH2uv14/YLGwKPqzjQ0uld
	lw3EKztzHg11F3vnonkcnzg4VnIpNp7vkFma5g63Spthtw0Wnhh2yrFWDFUic3F1uvAa8jtsDwa
	b4JRClwfR1UyXF35yXYXnyr9HcvEX6HVRpGCgMCfWo17VInwhMhP3/4xbU63qmU1buFs7ZBi2+Z
	xSUgx6J4x3Y9Sl4B/+DbPUx3gvhP2PqVj1nhymYpUaLkpLL/Kc6iI56zrMBNrkXwkwdtry63cAh
	OiNR3qUZw=
X-Google-Smtp-Source: AGHT+IFHp7CcRk8EuGvVXBMAKV14iJdboR7Qx/894f3C5vZTBB1ISPfpE7T83gPsFbY8zHpntT65lA==
X-Received: by 2002:a17:902:ce10:b0:295:57f6:76b with SMTP id d9443c01a7336-297e53e7b0bmr65195835ad.7.1762668489563;
        Sat, 08 Nov 2025 22:08:09 -0800 (PST)
Received: from LilGuy ([2409:40c2:1042:913d:b798:80c3:5bd2:24ee])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ba8ffe36bafsm9722322a12.23.2025.11.08.22.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 22:08:09 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT),
	linux-kernel@vger.kernel.org (open list)
Cc: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [RFC] Guidance on contributing to the MM subsystem and finding tasks
Date: Sun,  9 Nov 2025 11:37:38 +0000
Message-ID: <20251109113741.102337-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kqhmfitfgojecc3gh9dt35y8sy8hbsiw
X-Rspam-User: 
X-Rspamd-Queue-Id: D9EAB140006
X-Rspamd-Server: rspam10
X-HE-Tag: 1762668490-271674
X-HE-Meta: U2FsdGVkX19YELerxTLTmvL6slfvGWztP0+Wm8+tzBBJeVZC+eBh0p4tGx8pHs6UXRPvsO/cTgVt3FCPHtDuGPpVpuo+IgjD29PWgSp+XEyliOwepjsaCrh5+t5joOIzO+DAjbXFpEEAxFuQpff+2bOSOVqIR1/PFx4loZCplyruuem3egAUAr2YEznbk7oYb+ZEsNCm9VS1w3n5aN5L5eQchlb9mnhtoaqr23xaLq1qSWQLxBAWpivcVh4hGE8J962XgODr5OI2qW5pgGJPt7aplH/fpeqm9nMxpxbmqxFCMU0qqeVHdz7otL/ANsUb45ozzRpdfGl6m3z53pg+wXxd91ZQw5HF8GDlFtwe91Sn7B+JrGiaNiIvMbmtTgLgssiaykGm3qpRtutd8sz3R34auWFK9ERgsTRT+/Rti1dRaEl6vR+ZT6S0Sjj+vjVDfh3KuNLgQg9KlvDsh+SQCpL7naEnKu64eLCL/4elmXHKOp/8rO2hS6p33GLVtchXZcNE2NVHeSihEDCj3Rrg/Pzy6x2gyn3IjbRK4oQmMuBBoduk+rV+iJoaO/d3yUrp7JFGl5pZMKJA81sULpNJS18eLsv+zhYr2RXICLQjzQ3v07llmh/awjMkssAfH1JuNih7wnln/tG1hVGo3EhOFmnYrRi2InaG/AZuMLGqYkhhUEiOIX4+06lTM39NyUg8bYvTQ4VIq+jKDPiKlb1sbnYitgmsKqkELaTn7CleskhYYlcOfx1X5dDF1UmOKh4T+WpB7EQVN2bfmOpJ50bl3kXvVxIdbulr5ffCUph8flrBQ5kwAPDEWtLRj3vTDW89TntrxbmwEwU25i81t3uzkeUE4Nt7bftYKtl5HRM4UBFlmyUAYD+z1QBOoLd1tWKyg9LbrZwXCvdPSnxqxC/xBCrGeRqlprs9QgzThwJRzS7q8dR67WShlkujsQgoODGJ/nwkUGHjBqaN7vQThpn
 HsARIJOX
 fOpTx+K7yxBGKEhdof+59g806vXhD23q+Kl4n2ClxQZIcB/JxEvRXCtJVVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,
I’ve been following the MM subsystem for a while and have submitted a few
small patches (mostly cleanups and basic fixes).I’d really like to become
more involved and contribute to meaningful memory management work, but I’m
having some trouble figuring out how to identify useful areas to work on.

I have also looked at some TODOs in the mm/ code and submitted a patch for
one of them. I’ve tried looking into syzbot reports as well, but often by
the time I finish understanding the issue, someone else has already sent a
fix. I’d still like to learn from such debugging efforts, but it would be
great to find areas where I can make steady progress and contribute patches
that are actually helpful.

Could someone please share some guidance or suggestions on:
  - How to find open problems or areas that need help in MM?
  - Any advice for someone trying to move from small fixes toward more
    substantial contributions?
  - And if possible, could you suggest a few small or medium tasks that are
    suitable for new contributors to the MM subsystem, the kind of things that
    would be genuinely helpful and likely to be accepted?

I’d really appreciate any pointers or direction.
Thanks for your time and for maintaining this amazing subsystem.

Best regards,
Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

