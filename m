Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AD7C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 20:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880DD6B0093; Fri,  8 Aug 2025 16:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8588A6B0095; Fri,  8 Aug 2025 16:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E4E6B0096; Fri,  8 Aug 2025 16:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5993B6B0093
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:18:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD2F9116117
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:10 +0000 (UTC)
X-FDA: 83754701940.05.B184F3A
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1D66C20006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TGzOL35l;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754684289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Bl43cLtacEaHV/RWtjYcg0CuQlsW0JyoL1eQ6Ei05H4=;
	b=bBSzcOmWWWMceW7sLtphDTVDaCQrDq8+jFn2xvB5f6Ka0g3HcsQT6Gxxuj/iyUcMtkn17x
	4i3Gt6M0ZmAVdR8zrFYu7Zd+4+Q/YPU5SE9Qs6L9bJNMauPUOLn61qWjFfmLtJvP5a8hGU
	ZL5cLu44rE08i2xQy6W45T1vt/cd8nw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754684289; a=rsa-sha256;
	cv=none;
	b=mFhmQ0+YczLTjR3JGhy1qUd7M08OQ4NBhbfvALmZjsvGX6xrvWAHVXad/XPER1IiByCYgA
	AfD9vdgzxQzj5WrlxZFmlBt7rqGT7aKAznmVxlcaL0oO3Cl8TVshE3YLrLaZHYyrSh0gQs
	A+VHRLPw+qOBskNugO+zqbeSheucmds=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TGzOL35l;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b06d162789so28583691cf.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 13:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754684288; x=1755289088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bl43cLtacEaHV/RWtjYcg0CuQlsW0JyoL1eQ6Ei05H4=;
        b=TGzOL35litML0aLmJpI3h3oFavfJv/pXm4EjSGGbpKYJbA0jK0X0hj1eX1DgSHv6j1
         ZM7dGxlU5lYtza7piMqoHcMuFIA6vkagG5/yGyygwViKLdRZLIpViHw61JE8g+u4cLQ3
         lumua7q9PZtloBveLBqIQh29UKFqewrICyZ0avVdn1u160Z6xzjhK04K2hUYiBIFnQbC
         Ds2QVxa8FDm6KDbyxGPdeMcMn1HyAyWWQ01IqHsJoGP0nWEaZyycHMFO+6t+uiW3uKLc
         Ef8/eYoqQ8n5K+nVdyJ+6Yy1+NCL7yTQX1AW1lXib8gy8cFRbO0EkBeHQb6hOgLNMur2
         sGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754684288; x=1755289088;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bl43cLtacEaHV/RWtjYcg0CuQlsW0JyoL1eQ6Ei05H4=;
        b=KSq5orKI1AjFiW03DeFngWGowRpvy5+XvcRpcdEwiT/tJI3NKvQhCrQT5ObvMsGGYs
         0i9YR3trKU6owki6zecFevgrPtUUUMgSrngmH7MQWpCiihrhu+XuKDAWhFfNhohCrERn
         /Vnjg7yiGnyYyW6XU1uwbW8AYraU9cvRflQZj8kzLeec2HpV3RxvifF08SYgxzirCDss
         LJB1iV45Q3IgzI/j+Ttt6m/HGDnkbY+eCicLq3HOJo519BA4UnnzwYWqoY7HJrO9T+nX
         V297Ps01bEb9TfTKeOL+NyPNKN5k1s8dA/ZNW1NrMMH30uR9PdRle35i9is55QQSNSIz
         pd3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmVzveBylADmJR+xI1+yo1dAZAWndebBYAQCsOSo+t/b1gXuMphiSF4TmmLqCr/+mzR6vhznyv3g==@kvack.org
X-Gm-Message-State: AOJu0YxW2lrgrD8jc8O4GWYYIvjlSd2Sv2/xfAx1kBbLtZfLeQkx8zbE
	7XsEvjIWOvi5AE5SDp6zadbnPNSHuyVMmKw7XDKzZEj50fzUcib8zMxJFFwdD6FIcQk=
X-Gm-Gg: ASbGncsIufCpfbQuffch/8/YSDQz1IROJ9GHijb2bqIowwTNYlkVox1cSfvZ4BvsNso
	LERUc4GAKyLf1U+x1ZtjjQgOjpfj/TZXXABFyxrkTgv1cGUUvyn2BrDUkU7Q4bGAPsf3vl20AxA
	K9hfSNd6KSjXkadTiy4tBY043456I7hayu2bB57dp4PPqi8Yln5B0WdDB7o4dX+YYgsdt/gfods
	5Y/Lp9YjMOhXPfUplCwzE6hOOCrpRf0WY1Aftn1G3WBd5j+nGTqnrIJXbfCAJZwR9CsSctUFRcV
	P/skDjZZKYXTOlevCAsJ25ui0A8e8cqXUY1Ll9GD0J2R50DNWanNbR0/olDEtG7VSi0+ZWrUw45
	RuIl10EPFl3iutMvNPNoEswXS+DV96rPGJj1Px58mX0fKskN74cYG0sCyH+qGE7Xnfzm8+8nHak
	MVKCv/KBh32MOp
X-Google-Smtp-Source: AGHT+IEkycL5/Killw0PruH454l+HlYFvVCGLaFuncloU9u/TMGcBjOQJHVOoRlOgjZJOfGNFrwDZw==
X-Received: by 2002:ac8:6f1a:0:b0:4ab:cf30:1892 with SMTP id d75a77b69052e-4b0aec7c47amr80830561cf.22.1754684288169;
        Fri, 08 Aug 2025 13:18:08 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b07c80ddbbsm59490131cf.57.2025.08.08.13.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 13:18:07 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] Several KHO Hotfixes
Date: Fri,  8 Aug 2025 20:18:01 +0000
Message-ID: <20250808201804.772010-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D66C20006
X-Stat-Signature: wacf196isqsm8uw3y76p3ksf4ys494jz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754684288-604172
X-HE-Meta: U2FsdGVkX190xF4z9yZPLPERtTMWIMNDJFFljva1Z+U/uLst43fEwDlysZzm7Gh1deSvVnpDbjeXaoNzsfe0IFhK/75yYiBx+Z5e8lE4V+K9Jd2T1DU+EBSRtL8g8sAUIRLgLYTYO4Gh+Md9ldgDrBMmqEYOtThrccTCRl7CcsmShzqlw0ZFhI/nVgxq3nbLqJDCbxY2KYwDzxAe96l/qpBraBpGp7MPcWTFPRlt5ibW5HD8JBocbAmbX/m6QPIMqTVN1s4gYoEgbrv4xPReJqgd+/FcxnRw2LAXFGBZalpT8FIPvC9smmJudmAUf95UZ1oXfhoowMZxI8B5bZFfVO3zAT6h4v7FDiw1N14BqBOQkKtQBzqVc+cB7ZVdBC18s9QrePetD1CbAjeilXPASMwm2YM2OaM6SHKva43fhqQzjiCfP5d+RnBKY0vALGhQ+WMKC+3OafKwQfgdgCJoXI8EIGZd7Qf+mdVcUudjwgNa+cwbDm/E2ymDBGjG9UXIli1INfH5g+BOhTrSyKdwTo1eBeql02ds2kr+qZxoJFpjur2DHGvqLknLY16ogURvItmTZyGmE7HINhdJ80sdlzQfgS1KLzuc1EbIMKULrM6nfKrj5jf229awhRZwzu0tLQiR7cH06eLehjFBvE0Irz7IFwvI7gA/+7AQ9BsOd0JUkfVJ5XIus0VEgfxHjgkD++fEGxCyXsuRXv1275pKq/d3A0l8cAA/c42WF08+/YBkCdSop5MxzFSsXKIDm+OuDMwgtUKNHupBIq+WOVg8OsihEKNisLXvU+8LWuRB4zv/DoV49w8SWIChYn+uYMLglKs9xdwDAYBTo9qwPOHdymHTIkxeuf0QbUAeOuu7Zz1U8zi9PTBkY0Q/aE9nRTGSKPbNYcxnREd7/i6cTHQh3XFjKHAWBg9PjV4WcRfL7K9w+Famg8Hp7lUp52su2VEV8k1a9zgMshUuMsE2HDJ
 8ama+IsT
 AE9lCttsu1Y1u+ZA2MNpVII1qJcudtcqQdQXQSS6Xdaz2vvvOPtSkVozmQg5pT9GutrtGuuO44kDV2CcyzOXaRmSlUVrzJUvLGIXiFlzR9Ch+8EE+bqZHAAEPnXuxPtgAuXJUvN/r4w6c2995mxuT6vA8aCs0ZTQF4XKhskZozP1qy2jbEWEDFsyq0ZCBYa+qq3uFxWHaEQ+aUC4gnTwM74OKpC+hQx7fPnFbhxa9QGuMEZ0760/VBhBGQ48TJYv8OMoTJh7rwzPIY2fmbZH/Mwu8rSTsvHYUzKy11WtcguOqXtG7l/ZLU1NzAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These fixes are taken out from: LUO v3 patch series:
https://lore.kernel.org/all/20250807014442.3829950-1-pasha.tatashin@soleen.com

Pasha Tatashin (3):
  kho: init new_physxa->phys_bits to fix lockdep
  kho: mm: Don't allow deferred struct page with KHO
  kho: warn if KHO is disabled due to an error

 kernel/Kconfig.kexec    |  1 +
 kernel/kexec_handover.c | 29 +++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

-- 
2.50.1.703.g449372360f-goog


