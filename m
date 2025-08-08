Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC2CC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 19:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8886B0093; Fri,  8 Aug 2025 15:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789906B0095; Fri,  8 Aug 2025 15:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F206B0096; Fri,  8 Aug 2025 15:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B12D6B0093
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:55:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A475381C12
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:55:41 +0000 (UTC)
X-FDA: 83754645282.13.AD2306C
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id DA57FC0011
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:55:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z1/kLZj7";
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754682939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eqB/Sho7SGdwhbbruKl9GuatUpYpgD51wl6c/nteI8g=;
	b=QAiWguKZH6AYI5IOaucHl0Nq2w7tYDVTZ3Iv+xhxEVCu6sV65/hLFdOc7dDi2RdXIJC01m
	0jTGAIRL/XIsyv2Iloqz19VFFxFRyxPU4/hot3FrRC2OTUimdXKn4SMb6WNSUqw6KBhD0H
	DLlDJE1ziWggTZ68GSEHrEaFe6rD3gE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754682939; a=rsa-sha256;
	cv=none;
	b=h9a2Tqxp8rymrJJDsaTyJgB+UmYD5n4A9YB9x2oY3+XR4MXMCCdX/XSydEbtLr1DDzpZC5
	7yakrfm9DQmUG28yOCP6UEWvWN+4Lp8y+1bCiEzioD6V6zfKk0SdqcBOxjDtZCEousAE72
	2rC9Af/rLG2pSjMIi+tExkyOnlBdL7Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z1/kLZj7";
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-74264d1832eso3082287b3a.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 12:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754682938; x=1755287738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eqB/Sho7SGdwhbbruKl9GuatUpYpgD51wl6c/nteI8g=;
        b=Z1/kLZj7Jdan9lBCvAYIxM3it47pecuEujR6VL43WLM+mILtqohKVeAgS/2XYHNZII
         Ul/bXudgFUdxqvUOx2MqW/YcJihUXOHWeITP2VzM/NjYxL0upE/sioGr9vXnJyjEkzaK
         mufh1A+bBDImIxodIHUFDMjTts6uvDwwD9gHmbxS0PwxIF+84Lsw/GaTL6ntwCa3Ea3w
         KMQvgLC8gxejSjC+96rOvSegBlsCeKaSevPpUpWG/RgT8DOtxd1lhUJzzp7u1uQopiJa
         6ElUWc9yx/pjMBywWXv3qgPPOtDnQUqSuQxfqDCOMI8sW9zZ9LKmwQRdh0QPTkX4rnPy
         0HCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754682938; x=1755287738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eqB/Sho7SGdwhbbruKl9GuatUpYpgD51wl6c/nteI8g=;
        b=TN9OG+qSsqn2+glFwsxUq1Mvl7sLaaOi01eA4Eq5+M8mXiJHXTMSmDGOLinKZp82Wi
         XC67yWZBoV1dnIQfAWFnfjwfa7SHznWXwQ7kIVMM7Km/yEKxU6d2pG1KG6G2o1wlWgAh
         zlcM8rcvGCkqZ2NdoKd9C2UilW2mVpcw3QK1NnN5eeGAvm16GEVfeYZq4N/pW9rPg1TE
         dvZ54xE/FHX+2DzEIwTbHIEpO1keSpjXMjhAHj3sMhjfqWYJc8QclHtg8CddsA4nFdk3
         ZhgNF95VGdpvQxiIJt/CE1H/0MbjQEak5f7P1Cny5h+ai0DbOAF1kOXPo+TTRvblV7IS
         BJ/A==
X-Forwarded-Encrypted: i=1; AJvYcCUVGSdfMt0/vGjTKHWCyBdvEcP4FOj3goZhD5jU0u7AMMLdWzdZB4hBFC2q58Ai6zjW5uMtdzuDZw==@kvack.org
X-Gm-Message-State: AOJu0YxwwNZYyWcKGnkizBKTW0KoQw7T4TUiSUpDP1lW1WesgNrcxBr/
	t1qqzq9o2VfIYhwhSvfYnz9D4PFQweJE6jBATDLUDOfERCgdjmKCtoTV
X-Gm-Gg: ASbGnctW/Adz7ay4XSHmIQf28Y9/TwOeGlKvWRuof6hfYOoNcg7Xh8wgrfOAT5p/j8x
	Tk6sTI9Znre/9d36rZUe/NWtMcE8xYJZOiUAmjtPoxsCL9h8ExqU0HJmlxajgNZQTDexAYUO+Xd
	jLp0utVJISCWNNI9NzYVn0cAhTrz1qFDP8GQTGCP2Wgfipz2huc5PF1MQISGeZQsa52iFfZpnG8
	VG5BV6WXPlnLgSXOj2N2aL5I8vIcgOWujXI2dreUVp5pap0946q5Gqj/HHEoskWtzmyqQInRLLC
	/0i31y8sAqUcve8FGs5OsJ5eP3Cv+Nu72cExuKd0js8lVytIfmPc8Lb5WAZXS2yIPq8yzBUYjsZ
	Y8fOtGxuJ3ylG2NBF
X-Google-Smtp-Source: AGHT+IHFozLerEyc686dk4nlDttJZ9Mww+TdFXINgSUY+cCWvU2o5P3PXK+Bi5fvRxn39KKF33gsuw==
X-Received: by 2002:a05:6a00:2e25:b0:76b:f73a:4463 with SMTP id d2e1a72fcca58-76c46193613mr6289492b3a.19.1754682938456;
        Fri, 08 Aug 2025 12:55:38 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce8f911sm21201103b3a.47.2025.08.08.12.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 12:55:38 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH 0/2] fix damos_commit_ops_filters iteration problem with
Date: Sat,  9 Aug 2025 04:55:16 +0900
Message-ID: <20250808195518.563053-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA57FC0011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: khuehij9dt48xf8p7opah7bznsxeacbc
X-HE-Tag: 1754682939-388940
X-HE-Meta: U2FsdGVkX18KGGRxL917kMpMPBzfOYOngm+pfAe6sVQtniILvNy0lZXdCVMk8wbl+hDfMIDkPx+HWBmdAZ+32TDzbUTi7DiGzYMFNjrh+IkjZ6GnlXQ7yCgEyShOiecY66ezCa8YVrBUpYr0pHgc5BsC1l12NRv2YOT+a+mJuW5Qh9VVt+lDJTS5b2SmwnSIKCPDCkVAbxeC27om9NqSbzdTxmmkjrnTajAh7hZzqVqpKT5XUDaljQSxIeEt3wGDuKjM5IFrbwSZeu2HPt92pVPbOIPzZAfpotFqlETuq2V9fV2NlKFG2S2slMLDv9HwMWZ+PjuRWcQpQ7ez9lbORZhuNkicFJweuwC4AlM4PCq9Cg+wpBxfv/5nTMqG9jbK5It3N17sHFfB3ApZEcGc1QJXp+5MQakwkzBPZTuK72uId8F0SWe+wRLSA6wiWWuArQMbQPRjsx6W9RQ/LIQUT+SRhkstphbVWIWg1wJvcfHhNpvQ1ttybHxePGp6xr+nVWs35RlyteGVy/rMOSroEb21t+8qgZ29N66E6pXg6pkL9znGH39AsTxr1RsVzjbIgZq+/Pjt7HMGyut43hgx0kUEFVzNy6smuJirdekTeXH4NIdYSct8BcdQfRRpvDmCjllSZKaNHj/3h42ERl2aKb2NrfizRQ9J/ESCPHSbEo312P+D9E648FAbav7TiquSBu6jXGulDk8J+l0SJeqG6UuGDo7NiVgAUwFtkSTXkD+DhhuQ2W9RuGEOYOak15d1SC9X03TV1f+PmQHp+kWPAK4dOLKKSqAaZfenWRWvEH2izlwOlcpyaU6gMccpH0vZw2weL8gSTvlLiKjlsOJSECLTBYosFs2dFv1FJ+hrAEV/MfcKlquG1UjKoyouqiNf9yPobFCJJTX4usgVicF7Aodzxngj0beg9bqV+y02zF6RPu23E7JvB+woNyk0PaIFVTFshZWrpELkCbhVKXu
 zJwJ9ZBj
 zy0TsdjF24WZlwgIyD/TpyxH/aVQhHcYoKJ1Lq1sKqjpvER3IqWEp+Idh4h/0B2kpH8Yol8cs7qZJwaFMgq4+PUro4qXUMWV9B5qI5y2bC8Da2ZonOTT2ZoJ7wSAtZcZEH1/coN59o8Tbd/mMWf4kkrIJ2Symk9auM74gheiAfm9wgCHYH9zhwFsxaUaGb7zDMY1wZ7Qc9bDyfBPNSlWyb6KCXky5XkiSWRBr89nrGswiXUT/8b30w/fQaz76unWNxWgnNl7TzJgK0NuGFTJU2udqc8lG2cIjF40D0WrSQ8arg+bYEWzBl2AWeX3Zd0YrAo+JhVaBFPLAbxh0YKMCCkkdDmie8Z8OcTv0YlxbA+y/e78f9tKHPbUp4uw9huIxmJg3vtX7lTY4rJKz73gE5i4424O3vlSRlQ95EJsXO6T1u9yPPbuFelUlAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While studying, I found a section in damos_commit_ops_filters() that
looks like a bug. I first verified this issue through testing, and then
modified the code to fix problem. After applying these patch set, the
test which was added this time no longer fail.

---

Sang-Heon Jeon (2):
  selftests/damon: test no-op commit broke DAMON status
  mm/damon/core : fix commit_ops_filters by using correct nth function

 mm/damon/core.c                               | 14 +++-
 tools/testing/selftests/damon/Makefile        |  1 +
 .../damon/sysfs_no_op_commit_break.py         | 78 +++++++++++++++++++
 3 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_break.py

-- 
2.43.0


